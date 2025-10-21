Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FDF2CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 00:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC428E000E; Mon, 20 Oct 2025 20:30:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97C538E0002; Mon, 20 Oct 2025 20:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D7B8E000E; Mon, 20 Oct 2025 20:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB038E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:30:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25C531A02EA
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:30:28 +0000 (UTC)
X-FDA: 84020240136.11.D08E7BF
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 17DAF18000F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:30:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DV4LAPxc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761006626;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWmXV8dUFXBS8lzqQ2mo9kwipLUxt/knr1rcXgkS8xc=;
	b=qhfGJPixrt49QQOmkdLRdbN1hcqymq/9uQgWEdnx6VccL4EoIda8CcIVI9/etOBcY/0jh4
	hjIBycQxvI5CyTVjkRMwU2D+oWh1QpdbCeh6Zka1Vo6VMga5lAlO25lbXQxKqaJzIsxvQG
	K9ajmOTNr0+n+JuY7e0ZVpy1btfRlVk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761006626; a=rsa-sha256;
	cv=none;
	b=26TrmiFNKDspU/u7zvOYCWm5f+evwz07VYoHmTrk6b76NaXQ6Ag5tJ9i2iOhULjOHA1bYv
	KivLJIQ5UQdVrnnADiSuSHfxA0Kn1RYlXdQKiNxZu8JYuLlzxACu+r3LmUh6dT7D6NVt2b
	i2/xOI+KDuZSgSMlkCcWbmqze6tl+2g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DV4LAPxc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b4c89df6145so819242566b.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761006624; x=1761611424; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RWmXV8dUFXBS8lzqQ2mo9kwipLUxt/knr1rcXgkS8xc=;
        b=DV4LAPxcAhpqKqDQN6yNwHcyY17eV6t+pRAyoCZwQSwecDmVCF9u/iM6MZDNZeiNuT
         p6aSgKW9zkxdz40Xmo/O9eZCboizUTl1Y61bQF1fHUVOMbnUIrDhOcPHNp6XC11TamET
         YCbdyb5Rrv5fVb3TrhSNBrroiJmWKAc4sybB51AnYYbuR+LXcmkU6W35XbzldkTU3AkL
         3DhB/LkpasPQlNZE+yvqH3YI2Ob/8pK8zQKTSskYBMY/pwxYuL2i7fQ4nEh3KUQmxaKw
         IoH9BZrof/6edSf5arNtA50UTlxiahN2gpijVNlzify4cbrQpfeLuH1bGNrClm8SBj13
         383Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761006624; x=1761611424;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RWmXV8dUFXBS8lzqQ2mo9kwipLUxt/knr1rcXgkS8xc=;
        b=BizandBRI8nJJDWrhSjj9hHRWe7uZ3gbmSGibFDpJiIkzKMndmuMZgH1tvhEwG4qIb
         85eCQa3COvATTNlNYmH7SDZ8GXmG7+82jGrGFvagS3i7HbLozCc7KCnXCtK6jhhk8zrv
         EBXHlCqt5AWxXUaQKYHV92AbE3tw3aDseGyocl8GVfb87yvzif/gfq0OW31bEWd3lCfC
         QLqO4DzRESJvN8w9o8gLxqf14D9vo4CODCuN6rFF+qMUdxyg4o7LzCCOtwCcfN/fy9pM
         hKqM6c1C42pgm3jYD1/x37QE2ok7CNB3jk/MbM22pEqJ8bf3hpnZHZLZcmfix938ka3O
         5JLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIidSSg6/Q5HNFzf49xiHrZSKAn9SuBr4/I9jNiv6NK3/ix2gVzZhAHtSMm6BDxsEvQfXTaTwjgw==@kvack.org
X-Gm-Message-State: AOJu0YyOa52aP2D/8YLvY5IcJocEhQAUedkYuSEKn+WQ1xvit5/0qcjh
	yQW5lo+4XfBbtzzokHuk6PbLkKUyFPwTxPn83dlt78UZe8p8ZD02a4e5
X-Gm-Gg: ASbGncsup0EMGSG9uMHD1LjypG1/e9lSctQ/5p/O8VCWk768g377oefCPBadBBUz19y
	fG9nB6ZBE/UFAw8yHuT4NXN6+/O+kaBHHdcSl2kEiy1bcfUGr7upMytJcUsJKvmIH4tqhOS60Yu
	7dt+G/ty+Mx2STKmFpSv1QtXAoCCTzENzCqK6aKc+ytMa5E5QTyVTovOeHnDFpQJ/7K5sAkbjQm
	jnEA/XYnMzNyYuaBhrn0IWZpCUmG1WQygaLk8KvsRz6C3+efILR3iL3Bx2dsq2cUETUN1DJ0qPz
	Adfd1dCp3Pak41Eadj+QSYOUUaHl401e23b+L03ch4pLy1fTRNjndariPZ5Kyzqa+1aGOAK/5/Y
	9LPGmcKw+Ri7xx59c8iD71GrSEYSYnQeY8n+DhWg/xgDNJWvPviPYOaNOJFoHeoWatLPmA0fIaZ
	4sMz/+m3bZ4A==
X-Google-Smtp-Source: AGHT+IFTtHZNNM3pYydbY2tD4DgVJhdZb4kWEvuqqEz8tni7eWHSikgSGyI3JVKknf9QSXQZx0vD+w==
X-Received: by 2002:a17:907:3f11:b0:b42:7c2:1f9f with SMTP id a640c23a62f3a-b6475706f53mr1605068266b.62.1761006624452;
        Mon, 20 Oct 2025 17:30:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65eb525f48sm913748966b.60.2025.10.20.17.30.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Oct 2025 17:30:24 -0700 (PDT)
Date: Tue, 21 Oct 2025 00:30:23 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Message-ID: <20251021003023.owj5f4gceqpnp2ze@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
 <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
 <d0a2c81b-a0e0-4457-b355-2363f30ecfb8@redhat.com>
 <cdd37933-d2e7-4675-82fe-62b7f0ccdd80@lucifer.local>
 <A67D1276-D59B-41E9-8A88-E54E05A0F479@nvidia.com>
 <8dadd256-175a-4706-84d0-180eda04ce89@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dadd256-175a-4706-84d0-180eda04ce89@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 17DAF18000F
X-Rspamd-Server: rspam02
X-Stat-Signature: rsn7p63cqtqnpsyzdsq866bt3mjg61o4
X-HE-Tag: 1761006625-397255
X-HE-Meta: U2FsdGVkX18O3fFMv1GKqliuPUyxLTYI8og7jE1jIWYBYrAfVdVNaMJuFVsV6UxhtIpkDMyVhvCMdyVlpsb1l3wSGihBIOIbycOMG+Dye4EgEJTXSS449uKreWeTZ0AYTxsA1ozTNgZmJl9au2Jk6EUvnN8t9mcgiB7z35THJNYmrGg5xrT4Hvh8Q47jYjvnHimQZZWAOzBkoUPSoDVWvvP+1BYlYVseKgeqrfjN8pnPq2H/8N0QkNCBmebyq6yV28Hqpt5aY78YzGeAszDxTMqKqhDiVW1WH+J5kDIJlMF5lm1/oI24v+hYUXMj15isAnBgJ8PLVSL9twDCOIL3vRP8tVFMwhEUzYb4dC0f3uAkliCMzVda6fqJWzebXgK9ouUQYRxsiXcMppzqwmPlxHi6/Jk/t3Bpyr0Po3Z7z/u1gfOXYqchB1wnbYh5yMuVk0+x4o37yvTdGI5SXgj2X8hdTbjiXPI1T5cIJ9ysUvMsBkKNedM7jFexAL4uVsWN5uR7BW/5iM356TlCqIi27ilkHTfterFclVgifCnMD8RujKeAeofrs/7cbvoWKXwyI9nNj8PTxyG2Yirv5eiM4I+PInNJGx57Ld3PV/iBshoMHugsrH+7gK83cPrPJ/1vWoEAIV7H7MoyCMtMf0c9ilqGJJQwtqfLB+RzlxZSAt9n3YXgkcLRwIMoFkEL8pq6SO2MC6MQiQnWQXrwK84agfdfhlYAPDDC2P+XbiUM7cV63Iqvm/+APgl9LqwTB0SksTLp80UurZQjFUfK7Em+i0YLA8sFx9dEZyP+NsXAh/Kdqs2Dyf0RRHNUuXP7F3AEw4zbcMPmgBgSl5QD1Z5QTZX75Qiz+jHzZYCbW0beh0XkaL2EpZe0hOgTLERpjyhM4l/S/GPlYSSdz6UcMEt7zc8fxFRhB6ps7EQSLoH+yxRbayY6dYpLQ9dUUdoZfW0DRy+V69cm460X5YxqDR+
 5/20+lpo
 nUY64dahU3/o7nolR3TJXVVpEjdmgNnfToD7BVHDzfBehwsEsBprOMzDN3LI21gmV4qagoOjYNOHG2bd9wUExLRBLml1wd8ne8HHYYwckiMBGHtuWuw7oibWZp2Q8B2UGUo3nn9MXPvf/NDnRcKbZZfrcUKNKEB3izTZPLC+vArw4QIw2KRdIneqs3XYyQMW4mZPN+rxDpq4SaFEcrxF7+GvB8WTGhzWch6yFUsDL0eLxLv0xSvsMhxmn5icAx//GT20DZMyxlXGFcPoW0MW5m/otFuJwkYLpdvH4Nw0KKXoH7PkAtzjcG7PkyRfiOrpoe9FpAJvltesK6GTsafsFNNtIrxgQZ/vqiM/ONghwTrURKPwJ3xP1vyNcWgCTbxq5s8XmEyvaxwUgiQVZK3n0b7QNqDB6OXbcVdakGOMFX2Rf4qP9o2BofNvYpvLTS52s+26n0SuPc4ASGqoZq4VCTNE3hBmKcdwNXdFBJphJnSr9YusS0VlsZgAXAeAACVtOxhuiZGMkus5j0o92Ens1L25nK0yCsqgMU7p8/O/W1wONH+sopb6tp5bYRMB4fZyn3uRS0IG+Q/UKBYmrLXQuJSca3OPLvY9noW+HyrnniduKr7T6/M89ViYteHIxZvGXIaaqA76DjgtqWMX6F1PZnI/PTXkd6fZZp4c0UywC5Wc0b7kGM8gRlrXXh46FrYUUKKiScUtVZaSF9sd3d1DvUTZB7KG0/hWww0lYc82FcrLesbtpNn/J8kOglSOaxWyuOZOc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 03:03:06PM +0100, Lorenzo Stoakes wrote:
>On Fri, Oct 17, 2025 at 01:24:37PM -0400, Zi Yan wrote:
>> Let me explain the changes in details below, so that we might find a
>> good way of splitting it up for an easy review:
>
>Thanks, much appreciated!
>
>Looking through it seems to me there should be 3 patches:
>
>- Getting rid of the trailing loop
>- Stats fixups

Hmm... I don't get how to arrange in this order.

Remove the trailing loop before stats fixup means we still do mod_mthp_stat()
in two places? And we keep the stop_split and fixup the stats on stop_split?

If this is what you mean, it looks complicated the change.

>- Remaining trivial cleanups
 
My suggestion is switch 1 and 2:

 - Stats fixups
 - Getting rid of the trailing loop
 - Remaining trivial cleanups

We first update stats only on success split, so that we could get rid of the
stop_split. Then we could get rid of the trailing loop in a clean way.

And this my v1 with patch 4&5 merged.

>Do you agree?
>
>Each can have a commit message that describes in detail what's happening
>and why it's ok.
>
>This is also useful for bisection purposes.
>

-- 
Wei Yang
Help you, Help me

