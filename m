Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F633CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 03:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885078E000E; Mon, 20 Oct 2025 23:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835238E0002; Mon, 20 Oct 2025 23:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7241F8E000E; Mon, 20 Oct 2025 23:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6020A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 23:00:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3F3AB8ADC
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:00:42 +0000 (UTC)
X-FDA: 84020618724.28.2BA9B21
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id DD9984000E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:00:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BX2PxFbT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761015640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wolrO6K5Gpk5E6HmjujtcKuYSzTD6g4tns2SCtq/Y9Y=;
	b=kbrBIgZ9PN/ym7s8Ks6YXy9056McBcfu59J1icL+yoPotHphIJNy88+9mj9KLw/S6nKY0t
	AwPSNUHVC/B6tckXDcXdwCU2hOvUHv9sL4OKcSCvn6qCE2o3Ad85mKz3IHNsYCwIOz8o+O
	r5eX295++XZpv67XZY3EYWgdeTwM1Qo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761015640; a=rsa-sha256;
	cv=none;
	b=bNCIFELqEvb2UpZWmlBEA4fPVm5nIkD7ZCZEkwvQVkH52/BwtRYQwwE2WYt8qgqe/aAO+e
	dG8h20Jk9U9sa2TDYiWaO179vMEZM5HXP7ayP51iR59+FCKasnMHxAuJLiIamRW8l2aqz6
	Krhx+7lOLmgFuejPyRdbnGKR+/on7GI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BX2PxFbT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-33255011eafso4717379a91.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761015640; x=1761620440; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wolrO6K5Gpk5E6HmjujtcKuYSzTD6g4tns2SCtq/Y9Y=;
        b=BX2PxFbTWgXlCL/W5i0ZC4WwthAk1y97xJYH9A0DSa47AUABncBXkNOQMGfURT7fAl
         uJa1AqMbzpSe61WI/ifSE3D7NpZ6+6xHWn4a/ov7G0jLkM+rvx4oqeH7SoXcoT7hxDIs
         Eymp8P32qeO4Hi+TvNF1CBw9CUbvdFmxJqdDMRacGDJS/PMkkIRbf+5iFenN+orbClsn
         1DroBKUE5EWOs0D4zj1ExAGeiSTYyZuBBa8sNZ0GQas7K4cTBIC+jETcSw57B3jdngGH
         hMD87tUykamhH6tUbPdVxwMhduZScMZZTb2raZ90Un7RlPm8yBEJo7ZdxMYIVNm5tT5V
         4TQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761015640; x=1761620440;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wolrO6K5Gpk5E6HmjujtcKuYSzTD6g4tns2SCtq/Y9Y=;
        b=qbQFObbdKL6BudNuh1BlkF2QILNYyzhQ1Kr3RMkpe7PTN+XYH14KM9mT53wWh9D66G
         UNJLoNI3lFfaRWhfjf03vBZcHlNY/UYMZ6GNx5V7hRWVb0PWz9kdd/GFCBS7STaf9pV3
         EGsB9JjuspjurMtr8/M3W/BZI2gQjO5CCjHp6KcLELV2A8iX6Xll5bj/Juzkytygl8zJ
         tQun1c6R+8bQUQq10LWrmJy38t1/Vwo608xEXiKjMwplJV5DGjfmomaEoxAhq18M2mmT
         UyZkobqiovLjwnctPGDHYvIZ/eZppOIxyv2qZqZ4R1ejvChGTBxvdfCTr+AxaC92P4dV
         gPiw==
X-Forwarded-Encrypted: i=1; AJvYcCWYfgsty9uhYSk0UqfJJspv8DEq5QZKGsDZmiv+uPULZGMIoPo93wddowJWZtHDV0WMZpCQUHOQxA==@kvack.org
X-Gm-Message-State: AOJu0YyfPcu0knuLwvsrIVuF4m7aTu7Ipp2cKDvCUhe8lXEYOrlPARmu
	SFCVylzIrr0k2DA0AXPV+7wRc4eV2eF1hjU8iZPG+5wnElPcVcfTsVpl
X-Gm-Gg: ASbGnct7AAsqDfisj87AT3hMbvZmwcpWB3AWj5k7Oklx6T9vqZpdg4aMXu5j/cx5uU6
	P0Rvlfn4AvE2mIk/jS+pJiFn06cD1BHPa1SeuIEWP2IwJNr+SfuSF4rM96TLy9nPfkIozisz40s
	sVT9/uZslWwnzJKlv6PFUQA3bZ+XVl/eGZn509yuRk8oFdRO3AmfyNgoZGWU2VcsL1CL/DFS7xx
	3m8LLCAjqUJ3Ghv+SRw0aOHmCehwgy0ZZN8nWSGHFc1yTfkgTLby8tGWOj0qSeJiktu9h3gfuXy
	M1fbu5cHsh1+9G4kI/4xy19tCEGvZmYSSFfwgxDjGffu/VB/mlaYbPKagE4zQgkI2c3vh/3MpoO
	rBaC1rfQRoT6TFArCIhhBsg90MxPZk1dtQRd0ymxNEcc5moz+cGJzBH28UYCldHYv0xBfwKa0mN
	hHKm9lAVoYPitV7X+U8+URYQsUQsA7dVWBICzzpmUHzXVnZ2tILSK/HbHfKKC8o3Vtlg==
X-Google-Smtp-Source: AGHT+IEyWb6zUgAua3fez8vWhCKNdZw46wjWRLvNKVjsaqlwsezQ/r2XFrxgG+mEgkBHLIH21+GT1A==
X-Received: by 2002:a17:90a:ec8b:b0:32b:6145:fa63 with SMTP id 98e67ed59e1d1-33bcf860229mr23990816a91.4.1761015639670;
        Mon, 20 Oct 2025 20:00:39 -0700 (PDT)
Received: from ?IPV6:2804:14c:5fc8:8033:532d:24bf:bd5f:fd3e? ([2804:14c:5fc8:8033:532d:24bf:bd5f:fd3e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff34adasm9716472b3a.19.2025.10.20.20.00.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 20:00:39 -0700 (PDT)
Message-ID: <2d0cbd23-83e9-460b-a82a-d006a14fa9fb@gmail.com>
Date: Tue, 21 Oct 2025 00:00:36 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, craftfever <craftfever@airmail.cc>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251016012236.4189-1-pedrodemargomes@gmail.com>
 <844af749-374e-49b3-91f0-a72e951981c8@redhat.com>
Content-Language: en-US
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
In-Reply-To: <844af749-374e-49b3-91f0-a72e951981c8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DD9984000E
X-Rspamd-Server: rspam02
X-Stat-Signature: 47qqdpe9s9k9qq7ditx34bnmo5unnwbr
X-HE-Tag: 1761015640-68959
X-HE-Meta: U2FsdGVkX18jZ3Zvd4I61BLtFol/ap/LiY9/cEUTQaZjPD2fq0IXb4gt1KS9Wb61kYhoAskdxf1jBWEEdxM8pvaO1CltiWPAt6xzX1xAMkvN/iVNwEmMB/rcn74q/O1B54d06LNMbVU3EWdqbZq3phA4hgpEThSO65zFpoDZvBwhWNYE9TdAKfNMOSxKMDdkD0lefhNHmrXhd61IqQaY2ZqVIFIa0u005IEl1z5gJndufYTVGrPTr5yze5jK0ZCHuW86FC9rUvnR044L3gmjjwLLT/R7U99l5rHz19/SKwCemt4VydjQyBNqgqUUmf6ICO/JzTq6NQ9EHZWc/xRXjlzVcq+Am9EZYF7vOeUzesLW/tAYEeyBydpx1cgqjcCKDtALSmzerCLO/DMSiAgpF6NyeCY0zoCPOsEVawEPR0iHtJfeA+adHSKNi1rO4iws5IZq4W7rAukdISdB06AB6ZEnn5FggDYeJA+cWNG1AvmMPu9KOvamQwd3WL6MUK2UouPX9c39SWKAwzU+6jIgtT8mVHzd9t/vqR+XCZQkFWx7TtgNsTfTq61IMGrD7o890K8EcCNUMGQq48XDcFL2S/HgDL17EAFkZFpMOyZbj0dmtzIdE7LDbST1WYd+EjtVJnIzyYkWEZ2GxECfXaUf/6VDg6KdXs+AKleBxG+aVSXPt3cGiTUMr/1oiyAf1iec9lcYQQ8cPbkMS+hHpGg+G+PofabKVHIfPQ5E022rmzUVsDI/PlnenNKgSkGtIYl57MHlf4hlbh4MLYbluz6QtL7u0GllbC95sYKxyOSBX7w9qdtxyfpKgevmSjp6cbvNrk+eyoZMbfx1UJcIZQ5AX1Rptl1OsTvnMs5Oyotj0VmatsXID13Ttsnc9/MWZ0rChixB/X3xPMoOiWF6dPlygwRBMXxKoIqFXE3HRK8ShFIOC6r3+H6CW/S64iuRHIfP77HBXgn8wM6WoCoVP69
 bFqQPc8h
 DCuN4F+CKnDzjxBzNa1HatyId3V097eh42wUSAi62mh48Bbb6KuDaegD49Qxjxjf8B5aZh9UTKUhrO0tCt9WJzdi2Cpr2NeAP8Cwgw66vhrPaqRPlbzGl0c0bWR5RzyJbGXRHX5x+49OBYGjyWhwOu2N4LUEeFneAFH7GH6WCTp3ZS5Oa3PBudZrw7pQKbZFr87sMUSlYHf0A8WX+NfyLvycxN3PBPHAIsgnlZDYbtX/Xd/iJKsljIzPirlmjhztDBVOaM2+RxGhyLKYKWbDFTcDj3cFqTKsMNMqkRfhrhZ2fmucsXfVyWtEIS90c+haNhIIayWhcmRoUW9h40KvOdGG16saU/b61g126nL47T+otMDC1o+R/mUnEUN3prcSe9f3QTbA+QROJX6m3Og3niZpPMPEwfQqmU+nOBgEEGXxMwDpEu66NwkOzgBbTMj8h2uj1IA/7uzx8WpeGM9qi/gZboLKwLk7F/IvsmbhA4uwnp+CHkgrbh1GUVY422R7DwMDgT9T5/wTtXPs/tE3fs2GUWNRwApKRMA2I7/L+3/nTfjo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/17/25 19:23, David Hildenbrand wrote:

> This patch does to much in a single patch which makes it
> rather hard to review.
>
> As a first step, we should focus on leaving most of
> scan_get_next_rmap_item() alone and only focus on replacing
> folio_walk by walk_page_range_vma().
>
> Follow-up cleanups could try cleaning up scan_get_next_rmap_item()
> -- and boy oh boy, does that function scream for quite some cleanups.
>
> This is something minimal based on your v3. I applied plenty of more
> cleanups and I wish we could further shrink the pmd_entry function,
> but I have to give up for today (well, it's already tomorrow :) ). 

Should I send a v4 to be applied on top of your minimal patch? This
v4 would eliminate the need of the for_each_vma using the test_walk
callback like the previous versions.
Thanks for your patience.

