Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B92CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6786B8E005E; Mon,  1 Sep 2025 09:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2BE8E0008; Mon,  1 Sep 2025 09:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4531D8E005E; Mon,  1 Sep 2025 09:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 262928E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:55:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7857C086F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:55:09 +0000 (UTC)
X-FDA: 83840827938.12.7712EA5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 94AD1A0007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:55:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F0rBeIS3;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NriXVnZPHaqiO5Dj5qEVt/Cua6PNSalsoubuoEiq6aw=;
	b=rFW7LwvOQiabSjKgqwZy1pBSt91unj99VcpKy2GoAT0+i8XAIkc/Bni/Zhh0It9gAZIfqJ
	h4prF//8xj27477lLaJMuZScWPsDoRaTVF/vEzwSxdy1LI063VDmNSATouCdltpGhiPaPp
	9rMSHtNV+RR9D3ZcU8da3GTn+G6nyAk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734907; a=rsa-sha256;
	cv=none;
	b=uK8Svci+5MHeXrvEr+tarBEYLVD4MmNVNidnk9mrLLpOnmWhrlYwgXsga4sM0Q4AV683uK
	zom5anPHDeZxita5WVXtjmYoPIDQTNgjoAOUiFkg5dl6MPnIy55lLIKHJsXhP2mKleiEZy
	HqVDE7NbRRLtfglEAgO0VBWjVHsAvKY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F0rBeIS3;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756734907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NriXVnZPHaqiO5Dj5qEVt/Cua6PNSalsoubuoEiq6aw=;
	b=F0rBeIS3CV5JonUuTjH5pkNUId1KXGiD3MUqpzIonMivgdBJWWqT7izl/mOjkqrMBbWU1c
	tuhotwFpMNsW1K1JsajOD1gZc8ZAkiW2MvWmOuMX65ZG2pm6IQI6GsH0NMp/iuJsnXtT/f
	C57rnjv5kjnIiECikq9NxK2E+kmH+54=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-H1QmoZCSM9KToyhppW0lrQ-1; Mon, 01 Sep 2025 09:55:06 -0400
X-MC-Unique: H1QmoZCSM9KToyhppW0lrQ-1
X-Mimecast-MFC-AGG-ID: H1QmoZCSM9KToyhppW0lrQ_1756734905
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b7c01a6d3so24311945e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:55:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756734905; x=1757339705;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NriXVnZPHaqiO5Dj5qEVt/Cua6PNSalsoubuoEiq6aw=;
        b=KdMqG2q5yhdGI9gfrE8DRB5j6tU4uSUitNlLguhHJkYOGjXFHhNaP+4umEdzsyGL+C
         IFMuOPqGC7/SPTKie2rXvLR4feWayTia3apoxdy3rjipJSrCyqX0yu18xKWF5aGbev2i
         SNznIcDXUgGDHk2bpV2saBEC9msLq1TzoYtRPR8oj+0KbD63snUp0priG1+6nWT8cjfP
         az2433HKkYY/275UFrYevydIr3Kpkyp3QsUFu3+6cFuTY99Atb8SNpl+MTSFSBO2USto
         bIsK0eQ2T6j9zlZWY976MiiGxIaRYSX7r8mHuah5Mv3ZrD/yZbhni2b5KqkscjpaB0CP
         6bQw==
X-Forwarded-Encrypted: i=1; AJvYcCVwuUZiKo21jVkw/AlMigf2JFO9IMqyC71/dZFjs7RoBi/hgZ0Xck1A3ACO3YLtUx//notAFEd45A==@kvack.org
X-Gm-Message-State: AOJu0YwdAlmS7ppLjAZ8xePreOkEbv39Y2gUoku9Gl0HYU1DqKPat40k
	MnfEBAhV1kMi5SzAgcrjqbORpp9DqUJU0UVQ+TpnMlhqs22s5RUBy6QK+N2Ek3gfpy+CvpSwcKi
	vAncLztBxHOD/c/VJpNmMe9KY4WYECIzBwH+P3cKN2hR0NfYJVi1u
X-Gm-Gg: ASbGncswoedH8rXuRZO2ipV3RVP9LQS1naOtTqAUhL7AUIirYGzQhKohFjmx1AFh8q3
	12vIOPH8JMgIMTy4IWywdCeVmADMr6HPNTTmmBvVtJil+B+J8dtiJhXpPJ7Hx8HqTGchMxxJY4B
	0YO510RaBOywLl1bjvAepFedHxXRJS8j5tY4vRAD2kAQCARvMDwQFrbDsvQ8Q+kUYIPoQhkBTC5
	h63GZCWvVMgfON1uDapgFH91tanC1k2sD2roqWM8P1WbCQw6DS/8eS0OxTXHGDgVqxj/i1SD1eS
	G3svBKYvJ6V4IxWSCLn3TCnXCkcefSE7Ohkar7KE+S4gRPiLjj9ksBPvaswovJuKl9fmvzQVHY5
	zR+8y8wCdCZKhu6vbZXbqoxNyoKjPLwYXGi6Zb+izaGV0hmTHlKQGRV/cUPzVNu5T4PY=
X-Received: by 2002:a05:600c:a41:b0:45b:627a:60cf with SMTP id 5b1f17b1804b1-45b8559b8edmr80725395e9.24.1756734904599;
        Mon, 01 Sep 2025 06:55:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEw9ob70sxuIZ5gwuScW1PzmZuqCETLGf0c2CRTvVo9pjc0fxaGT3edOb/FMXm7G3pI6UFHbw==
X-Received: by 2002:a05:600c:a41:b0:45b:627a:60cf with SMTP id 5b1f17b1804b1-45b8559b8edmr80725195e9.24.1756734904134;
        Mon, 01 Sep 2025 06:55:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e9c41cfsm157982965e9.21.2025.09.01.06.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:55:03 -0700 (PDT)
Message-ID: <e695b279-0540-494c-99a8-987179979d58@redhat.com>
Date: Mon, 1 Sep 2025 15:55:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/12] parisc: constify mmap_upper_limit() parameter
 for improved const-correctness
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
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
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-8-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901123028.3383461-8-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3ZBgPhC6NA1AsYWdfu6DSB_I189jKTQFn4h4c4ntwDw_1756734905
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94AD1A0007
X-Stat-Signature: kmg3uaghzgbios73ckq5yz7firfyu56h
X-Rspam-User: 
X-HE-Tag: 1756734907-959494
X-HE-Meta: U2FsdGVkX1+Q8RtjV/gAEP8oxI1CCkAf8bV4W+elvw1xLNn6lqfbo6Akpek+PSRa0F6/WJmvDUECg9FqNrTlbZkaEc1rszhYilQw3KSxxii/nogb1GrAdoEj9eW8ASyB2xRvAsouok09fWQeIGSXTH8zLIzOobtzsdRCbm6i1517QUshZrSh5pwX5N1UjUGVEkccHpTpWwOg33jdhK1pd+1L3XFoah7KaaCtGVdSArQf8iVVHKTSOV4LZstP8RenAWV5FEquWlZuicEc7L0hd9NoDQnH/ZvZUGQa1KxoAbCr8pXFWxzFrAljrV3qzhFsWolgLtYsnIKSPYSMh7ZJe61EtjuzTh6m5TdqUhIombSUv/xwrLiHDM/hvgc16bjA4As+W3tKCscTHuiWBuI5jpfAV7GDdSuhC1flTdLPGwRcYlOUdowai6rvyfbUgDPlQH73JToZ+dwSQIehrqAvm5GazkjKQDqbuVahSxlDtGHqUghHQWpyzljW84WGybPAkBitfN5agk42SrBdNXhPkm0Fdw0zZZCw3g0ClAN/hSIJLrDijkJnclLQUfnqqA4G146NyOEmbQAI36YU02+kTDqbiAGIV/xWbAdBk6F1/+NU9Eyw0fBhOuil2h0Pan/K06DXNJDOZ6KjRx4KWn4eVDzUhtxzACPUvXy8li2XJpMLQzYTxNbDpbhdbfpOgpFqnTiKIVEVLk76Mv6A3jet0bjUWJaUl6CRX1HpuETcAU+aBfyAdrYXl0ZO4eselpF4ZsSV45SS3ifpfBcK+q6doRZ3esL033IlHIi67pLxftlUkYRIuAUdVRNXnFs4r9wF/4uEa5limXu5jzW6ZcWH1e2W/ehSTgMyWAsMUNxZ+vwgh3rRT3ZcezvsrQDJ03Lpza1pj+/Fnjv5jJBUr+K1PnFC4mf2qh/uF97SPUXWAkM0+c5gVamyit4YmkL3lCrPGW8zi69jRQxue1VIYJR
 SntCzrqz
 /QwAxJjVmET0lEiS4Rc6bAAAxsl1rK7azTRd7EvKtBVKdzA8RfiEtTdAQOrNAB79jlBjVELjJERYUdMrjZXcfaTg9jhzF0qBJH5ZijvrpFZgerFPBhDpdlZSbEd/qhMMJkaKdb559tUxhSmG77fNDJ53kwjD7D+MpTJ59+ZdSEkGCZJRoqX2tIg4HIZLR+XBcM9iznVUQ4xe/wV4wfwdIfsY6+5iTpGAuO7TmpQb+QHgocSGDdoMlQg6vsuhFMynCPhorf0f9XldAPZrKzsOSsJ2X7UJxido++8rrpYRwAI1Jd/nD51fM7t+iz3cmOxx/h/LO/k4h6EToWSXIN2GKT/fBfct3URpKw/+73xc3U0K/YCmpAZoGc9N3rTwQEwX/x7wWEz4OuNCYdrTDW83d99sRQJ4wnMPfqO2REJUdvbcgSclbk4ILOGxAsWWb0h7VKZnrbdiy8MdViogwmHZIbaw5fIdfahjQCjPUIAhst7OjTZqWs/BPZzbislaY4q8XoyugViTfc5A1KGbdjFuRvJBkjO7+7BWeuzvF7ETrbSyeeEVk9poxwxMLx1Ye7LwNbAKYERaTuB1l6ZvZnfcnYK9HsRVaaPIpoPp6rnCqVipStZvq6a50ICgG6FE4+Qw1oDrWyc5H+urkL+eStajGe2EZ2UpDfA05Yae1pLhjFSGNcIO3Wm1Hvgc10o7SCfBohCFcO9NwrINHjyK/ig1mTiwyk26tjNgQ2O4k/jsEFyBbm2r+nu4QRBZJww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:30, Max Kellermann wrote:
> This piece is necessary to make the `rlim_stack` parameter to
> mmap_base() const.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>   arch/parisc/include/asm/processor.h | 2 +-
>   arch/parisc/kernel/sys_parisc.c     | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
> index 4c14bde39aac..dd0b5e199559 100644
> --- a/arch/parisc/include/asm/processor.h
> +++ b/arch/parisc/include/asm/processor.h
> @@ -48,7 +48,7 @@
>   #ifndef __ASSEMBLER__
>   
>   struct rlimit;
> -unsigned long mmap_upper_limit(struct rlimit *rlim_stack);
> +unsigned long mmap_upper_limit(const struct rlimit *rlim_stack);
>   unsigned long calc_max_stack_size(unsigned long stack_max);

*const like in the other case?

-- 
Cheers

David / dhildenb


