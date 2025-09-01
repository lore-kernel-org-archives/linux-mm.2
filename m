Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5544DCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE65A8E000F; Mon,  1 Sep 2025 07:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE108E000B; Mon,  1 Sep 2025 07:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ACC28E000F; Mon,  1 Sep 2025 07:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8891A8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:02:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A82485820
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:02:56 +0000 (UTC)
X-FDA: 83840393952.29.BA5BBAF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1404A001B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:02:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yh6KChN2;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pwINCj5IC9gGmlFKv2NCzdMq2RgfRkeGypury1Wan0=;
	b=CtaDj43R0yi7Sfd/pHCDxKTah+ptR9oMD2huhp+lT1C94orP0u5+WhOPC79nW0szQ5Bwb+
	AOHkXEBJ2JiBnNIQZCCA9sd30u6BJX5tPfgXb5Deslm6m3NgyU4CB+vzDCxeKH0yxCjYGO
	MS/lvkRV/h3fSCoermh5AyEGO3i2g6s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yh6KChN2;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724573; a=rsa-sha256;
	cv=none;
	b=Y2snBuP6H8zR3SZzW/2/9RgP21zOEaziTvRQw/lL/L1gnVgk2ztl1MOJpHcm45kdcL1VJG
	aB25BUsQ3r+ihUC1DljCP2Vm4tEher7K8aVN/2EjNvHkj7mamgl08rjQda/hg7gSR4/e+P
	tqxqNjM+9e405Ydnm1t8a7onNYqGgeE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756724573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2pwINCj5IC9gGmlFKv2NCzdMq2RgfRkeGypury1Wan0=;
	b=Yh6KChN27Y7S8/WXsvYN+tCfj1b9Nt0adXTkCTqSvD4vlfOy0BU7zoaGU/uWx4QX2Oxg/V
	OeNQ6o+6zh2MC/KTcDy89hr7bhiyhMR9eWNFXKWZVFZSfCmDQ+9vaQVGd0R6I2XrWwXMmf
	6hWcPOvef2xkzdg0AI7+/fDqPqYhbrw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-kRiUKRNzM4eZZ3QIEpVEHQ-1; Mon, 01 Sep 2025 07:02:52 -0400
X-MC-Unique: kRiUKRNzM4eZZ3QIEpVEHQ-1
X-Mimecast-MFC-AGG-ID: kRiUKRNzM4eZZ3QIEpVEHQ_1756724571
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b7d497abbso25143445e9.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 04:02:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756724571; x=1757329371;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2pwINCj5IC9gGmlFKv2NCzdMq2RgfRkeGypury1Wan0=;
        b=HQBpcY7oOKIDgCk9kgMYZJ/+yDo+TUqKqLvMmGt97DwT002xm6xjK1K9hobwbSwr2R
         59eLr62GSIa70UB7uRNn//XZYwOiDFXNRvXjKSTgX2aPMXtHllE4HlV/NIwyVilMom87
         Y3yB84z69owlrgkpB36e9C9WzpW0FRbJhLZH8rc3ldxgZy6Qpaw9nMkiyDTblA/Kmb06
         Tt1088ob8f2qRWLbUptZs1WS+jkkL/rATYYEbezKTnMTlf0yuuQ2xxLH6iMYpKh/z3bG
         oYxDLgxwOsCKQxAI5OITIm5hfw7FirDw6x7prMSAtm8sPvDT18tHTgLhfm+1UW0ZG7Kp
         EYTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJVRrYnVWhQOd3of3qruf6RVddF32b2lTe+2qeZ91OJmYzGWHX7A0zKNfszRyrJGiAr/PW4jvYkQ==@kvack.org
X-Gm-Message-State: AOJu0YzoByiS0nuSwZG37UBKoF9V5283f01bZNu3JjFjp7L2Y6aN+FNu
	KfqEroA7jAmuc2hcGqJ1Vq3F8AWBcLUvVIIJ0mzdjWUxQqhXkGiXkpRSXvRMGj5e5MhEMd8qRlr
	0IAyYd69rQ9Dzvu5eRNUl2ezFh/UpG28T3nltJwtuCgRkrCpck3VU
X-Gm-Gg: ASbGncu3L+Xez7dVLdB4vPb1/8Xfap6FnzUnc8DWysqynt+z/8SDxgeMKA2nOzppmLw
	n2U0PfImme0qNAie3/0sNnUKs0liuOJFj3dm1QQ2xE9bc3q1Zbp/5etYaIuEizEBth/TQmdcRKd
	v34wiwTuUZYG8Vfn9ruMtFXsEI8M/vWEGqGuMcGtUjhaGYpFbVki0MnYBQ/LB5LZ73r8mRIHsCn
	tlfgJfCk7pxrds5BwV5qmE7/bAym77wUM+iWPlA/tATVvasERF2wKiCqlvz5d3R6rMcgpZqvyIC
	GhB23pS6dKUZTHGF0fh8LNMDYQxYO36evI6IpZ4t6OviL1TFvXLrl0ntKxAOeD7tcChniD4NWXN
	+veaMa2aLKrHvhZ0512Q9NYcIVTIzHTRm0GbHsQMnFdI+ZeUbHEw9njg7PMHgg4WjL/4=
X-Received: by 2002:a5d:64cd:0:b0:3ce:16d3:7bd1 with SMTP id ffacd0b85a97d-3d1d9ac1cdamr5525183f8f.0.1756724570674;
        Mon, 01 Sep 2025 04:02:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFj8ufgKZlVGX8CMmIcbweVvShoidDXf+HM4vFZF7g4psnQ9bVARH+arPZnVNgJxxWj4BMlvA==
X-Received: by 2002:a5d:64cd:0:b0:3ce:16d3:7bd1 with SMTP id ffacd0b85a97d-3d1d9ac1cdamr5525149f8f.0.1756724570152;
        Mon, 01 Sep 2025 04:02:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d729a96912sm3045340f8f.8.2025.09.01.04.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 04:02:49 -0700 (PDT)
Message-ID: <d99496bf-6e67-4e64-97d5-6cfe563b8cbe@redhat.com>
Date: Mon, 1 Sep 2025 13:02:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] mm: establish const-correctness for pointer
 parameters
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, conduct@kernel.org
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
 <f065d6ae-c7a7-4b43-9a7d-47b35adf944e@lucifer.local>
 <CAKPOu+9smVnEyiRo=gibtpq7opF80s5XiX=B8+fxEBV7v3-Gyw@mail.gmail.com>
 <76348dd5-3edf-46fc-a531-b577aad1c850@lucifer.local>
 <CAKPOu+-cWED5_KF0BecqxVGKJFWZciJFENxxBSOA+-Ki_4i9zQ@mail.gmail.com>
 <bfe1ae86-981a-4bd5-a96d-2879ef1b3af2@redhat.com>
 <CAKPOu+_jpCE3MuRwKQ7bOhvtNW8XBgV-ZZVd3Qv6J+ULg4GJkw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+_jpCE3MuRwKQ7bOhvtNW8XBgV-ZZVd3Qv6J+ULg4GJkw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hGvkfnSF-qyhAbrakJwD0WmkT2hYDMPA-SEhK5UEzzU_1756724571
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D1404A001B
X-Rspam-User: 
X-Stat-Signature: ozsw1mq54q9oj4yzhdmy4847jjjjsgu7
X-Rspamd-Server: rspam09
X-HE-Tag: 1756724573-556051
X-HE-Meta: U2FsdGVkX18Vl1EOmP7hfvXjiiBEHuO6C7NKAFbJod16BAtglxtEGOsrvAhFvBhCgfmR3C5RT+YXz9PJxZYTzVql2nJKH7hDdUJK1A7PIxXg99zLqgd5mnvZDeOsN+cTxkVLJEPQM9yiTFFmPtwqiUl+zxcn3w14CvARWF6pj9EeS/Lk3IByKuWKTwunt3s+MS/T01GV+0SDyp+3IF/eYdOJTjlwErMhqRAXP4BjLlXuHNKmixML93a0r0AJqmSrBboQLmjAel3EIeQ5ihZt65BLWpPeFSF3kJQnV2Xt2qhvC28bNnkvbj7VceN9VFNS5NAJ0kBkjFfhE3BCxaOfxeMnYrvLvxpD2DS+jxy6ztu3VooAwVEZcO5dMguBgXZMw6MyLOtVLFUj8nR2kIQcLmAwakdk6R5/RcsEMZcTDhVCyuWTvNiYNRGQsZ4UQdO4fzI89DOekCMiTOp8gwqs1BhqYD7kD9dmFumdB03zcSX6er9LBjHpAd6FaS2398qaL559Xy2mH+UAyleMche4ebjkENOVZ7itwRWJzS5z0JtXeEww1fQh58YudZp0VEF7erzVjSKhmJq/ye++byN6ZIsHCAEGbb+50Lcgg9TfBaxYGRJOKn7CDGQ48c/Mhmt5B5DpyKcEjuQUyu2mHzFi6asqJVDmIpTG1TnEtTtcVSBCb6a2kig2LUvxSVOk+cH/XAlC4H3IG/UNLxU6iPUPjt9V4/ENNiuRF+XSWK8+8L2UCKm5c/nG9lLZPYrOOL2dTiv4ZQZICgj/yOWNALUPfD60gDmkPGN7MNmMpFLTowd282anMfcDmyheJ8ZD3ArAZtyCb5z+6cy2PG2MHp27t05WgCPZdEl7tmATSHpOWKThvfhVAvbk0NHHuXhX+7rdQqa50iViv3aaRWKw5PxVjHbuhEltYW0szEtD6HtV81Tu16Y+i/i4twYF6FA9D5VbvrAzzMCAJVEsB+U7QyR
 tFprhMgz
 1Afm3p1HAyF+CS/9pkSYXs/F53tc0ypGKHZt8Pokt/OUTPQ9g9yRh/ETd+FvVftbv2NPptdeGhBR8YWuvGdg82uowrm4P436YAlXAJKFF1YDxiVtNlOr0wC1l6YIrg5ssH+MIez8uhp3OkTgkNvVZWC5SrO5itlJXR8xjDxhhzW88qoxwKq/q2RS/3QTr8O/TYq3GlnjQBI0KoN1F5V4JCG5p/WALPE0UT/e9QoxD+zz3N1wUcnmznw0bOQn7Zkx6yKtVIpM5biQqHZzL2TE7hpirQHzoJbfVjupEI2QapFkuzJujU+wcukOPioWwvYiu6tots5ZJkUrGZrgnXtUGgYqBEXVaJZD4otllRLPVJrNX4UN7q/aKKCf2vzoIgf2HoBF/uBOa23BRl+KvKYx+J9KzstPwV1DRD303oYInQvVnJPE3JpOiNFrSejdXoaEnnZ0SZrIu7xrji7jLsW9NLr1qI5G3gUmJRl9sR/6jLl0HuhNHpQavwL5++Pr9Yo2gdS3Blz7Y6IpiWP9lQfHIw3qrOxAM4k/ZQepuBE5gDqncOX90AlEfTf3HO8Sdr/PhiQou4vTHG7u7paVlVmSydW8sUTMkWzZ6l8So
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 12:54, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 12:43 PM David Hildenbrand <david@redhat.com> wrote:
>> Max, I think this series here is valuable, and you can see that from the
>> engagement from reviewers (this is a *good* thing, I sometimes wish I
>> would get feedback that would help me improve my submissions).
>>
>> So if you don't want to follow-up on this series to polish the patch
>> descriptions etc,, let me now and I (or someone else around here) can
>> drag it over the finishing line.
> 
> Thanks David - I do want to finish this, if there is a constructive
> path ahead. I know what you want, but I'm not so sure about the
> others.

I think we primarily want to briefly explain the what, the why, and why it is okay.

For getter/test functions the "why it is okay" it's trivial -- test function.
Personally, I would not spell out the individual functions in that case, as
long as they logically belong together (like "shmem test functions"
describe what you did in that patch).

For anything beyond that people likely expect a different reasoning.

For example the following change:

-static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+static inline void folio_migrate_refs(struct folio *const new,
+				      const struct folio *const old)

Adds two "const" ways of doing things. As a reviewer, seeing something like that
buried in a patch raises questionmarks.

-- 
Cheers

David / dhildenb


