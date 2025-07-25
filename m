Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670D1C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 09:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3F96B007B; Fri, 25 Jul 2025 05:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5636B0088; Fri, 25 Jul 2025 05:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4776B0089; Fri, 25 Jul 2025 05:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CEA56B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:46:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 128A71139B3
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:46:22 +0000 (UTC)
X-FDA: 83702306604.17.26C14B4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 848B840003
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:46:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VcL9njX+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753436779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=faaaZtliI3/9YxGb/+TtNxd57UPwg/2TggleAWIPx/A=;
	b=LU1Kq1g0NMJAp3MhqA5Gp0fHS4PtQ2lRWsbtkdw8VUYO48DuMUWugec4LYfxJ8FlLKkV9Y
	7sMKkmO30Dg34IUO8q3tAF7pLTAYWxG7D8jUj4Eu4Oxmb9mvpvjh/1OLCo7YYA/hDueBCd
	K7rlQM4V+/72vqAfxmbRbGa53WL2rqc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753436779; a=rsa-sha256;
	cv=none;
	b=ZjEPni3CJ7mxx+4r2SqbKqPxwSiSqyGOgIu47z1+eSy/1eHtaVoUR97EGvyi+SFRUmdlso
	DKZmSSzNjfygMExIU3++3TomaghuiSJUPKzgPf0i1X6eNsXh5YaDGixkTghhrI8VXaLYD8
	awOjFe3qbmf6snXkRqjTmALOTOaNvVE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VcL9njX+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753436778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=faaaZtliI3/9YxGb/+TtNxd57UPwg/2TggleAWIPx/A=;
	b=VcL9njX+ysbPAZcJcRcn6nIW/ILw7j/uAL1k9WTk1b8nD/moUJ4hFWG3E9rKBoDhmjSYYl
	QVrJ27UTG+QcVmi3JbealPcO6Laz1PwmXdQ9fbitLV1PgOQUJv6EqgTFp3d/+qhe+dQKRr
	+J5uhzFCczQWKEdTOYw5RbJwaFSHypY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-0DcP1YtgMhCkmMfQPvXGpg-1; Fri, 25 Jul 2025 05:46:16 -0400
X-MC-Unique: 0DcP1YtgMhCkmMfQPvXGpg-1
X-Mimecast-MFC-AGG-ID: 0DcP1YtgMhCkmMfQPvXGpg_1753436776
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-455e9daab1cso3945145e9.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753436776; x=1754041576;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=faaaZtliI3/9YxGb/+TtNxd57UPwg/2TggleAWIPx/A=;
        b=w5BDuOqf+Vkwrrg9NC1803VdWUdyH7DmAQjxQsU781pQWW+PWmxth6AEVEZrIqOq7i
         BrgvkkGCWnjC9s3hSVELKFwxkr3Q3jSbdgsHregVNL9npKTmBX5aqDFePQuJ+vcQVvOP
         6ONhejl5fEBWpIG5peYvWLhlQKO0gBSCVHzQXN/lgY7A/t1NEZHm3CE6LeBYqaZMIl7e
         kMVshKHsNRB16P+FOs37MRkjAfxrfsiX371NGuJuzhha2WL2rs9e8SQaH8BMdgLWy/NC
         ZZeD9KRPZUtJG80091EaW/qaSZlwQbygBa2EQN3jy27Bx8es0h+od550slVb/YiyYLnm
         hmMw==
X-Forwarded-Encrypted: i=1; AJvYcCVEyWSYuLfQ12Q1fF5nro6iT9pqmLpsJUTRLR1x0eYotugvQUGr9lZBX2DHuSA9uib2px1vcmC2VQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2LFikP/YoubfMx577E58P9l8uRZbjptD/jGqKevtJXt2hCkab
	WVvR8qB878PkahlCG4b6VVPp6si/UZeHPRXfgu0KTd0tPMHVY7evLaCw58j/iKrL31fGxICNfVS
	cX8NAObpf23FIC8FuTbKAd+PKSl2Fg8rN7dKqM3Heh1KtTJY14KI9
X-Gm-Gg: ASbGnct9aPkSjRc74x/7f+3IKrGneN2o6mkO/ulGDlU/8aeYbsU12QSvw3VvHCF/IGL
	kztbuDWGtXlz4LCOKOHdZdFeJeAsyUzezSEKWPWdA8wci3AgOGEHudo8HvdVMOKoHrNgygzO9aS
	tNKXW+VpDQmG5t2YggHA/9yaozXVODxvKqKY7wb22/9nPE9qzDWJadwnq21IjQV+a9YqG2GPXvf
	6h2T8hJ2m1FgVjsrSXxWSfHh+fmeY+RLXpR7OIPPKz4zJphI1SCS6mk2oeBoB58hO4bkHdSBqzC
	eA7GmJl4IVrimeG6T17ZLccv+1F9guK7psvRXd4vN6ZzrUqpLVrUZcprZ+CqPNRiGTWJZn9rs7Z
	nUJ2xgSq9uCVsFOAQgk0tDYZmS8njwRQTrMOyNLs08O1RJBKeLfosVnilH/LddHQTlfg=
X-Received: by 2002:a05:600c:c059:20b0:441:a715:664a with SMTP id 5b1f17b1804b1-45876e74536mr5456835e9.20.1753436775650;
        Fri, 25 Jul 2025 02:46:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoa9HpfTRy4Lj08i/N3rWIm1AseMs1WcMYAu9tdaTVNPBh8JTCYaWhAP6NnneexqsPU6GKow==
X-Received: by 2002:a05:600c:c059:20b0:441:a715:664a with SMTP id 5b1f17b1804b1-45876e74536mr5456595e9.20.1753436775127;
        Fri, 25 Jul 2025 02:46:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1a:f400:5a9f:b1bf:4bb3:99b1? (p200300d82f1af4005a9fb1bf4bb399b1.dip0.t-ipconnect.de. [2003:d8:2f1a:f400:5a9f:b1bf:4bb3:99b1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45870532b43sm48224365e9.2.2025.07.25.02.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 02:46:14 -0700 (PDT)
Message-ID: <aa839e3a-11f3-49e1-8c3b-a60106c8d165@redhat.com>
Date: Fri, 25 Jul 2025 11:46:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <4f66d89a-631a-43eb-b4f9-c9a0b44caaae@redhat.com>
 <692f9624-e440-4cf2-8202-861c679ddb73@lucifer.local>
 <0ad414a1-9a57-4050-a7b6-fdea08aebbd1@redhat.com>
 <507a09cf-291c-4886-92e7-9d9cc294a247@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <507a09cf-291c-4886-92e7-9d9cc294a247@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NXdLRtVJ9TjjwuqWs8vdVMxCxewy2DOaeig_bKHHzaA_1753436776
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 848B840003
X-Stat-Signature: jyz5xedcr8imgmn3stiux39nttaaxs3x
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753436779-546071
X-HE-Meta: U2FsdGVkX1+Mh2b+1vkt3Yr7UZbfgsMG9JPy/hsnOTRsiZ0WL7CgfM/WUkCA6IhC3rTwd8mEqEMW/PL2pSggwDwSNkVNAzepqJaKudn45NtxFOz1n1ArBbBtG88/I5xMIc7KR2NDGvlHG4xbADw1PfIITW/OCHUKjZxoVXYSx1lvIDfh/irhBF3xwVslK+aws6RhlfW7JPYaKiwAGPV8jbGzNwOBK6RSJv7E9W0XWCMiJXZK+n3JCUkg1sOf0ep8rVko13vi942jrzTJc9hAZmPfUaSEVpjQWcm0k1CBQzaqw52a4M/Bj0nUBRFqNNO3ts63MIZS9RF1Uw3S2SI2bhzOt6RbGalQDhrmVaujvcuag3O45fw1ixrebWvbU0zieDzW8rGZza89oxcfJiNK84jyYpfjre6YnDoBxNgtmcj45aA1H52d/UPeUiK6eLQAy19v0NcwkYDmswgvLGKDrRs+ZKA5WP0Cuks8h6/rDmtSAotT4kWPLu6ctlDG8Wz9ZBULbgR5DGCic4pZb/hObACDaajm4Cu2OeJX4Vkp/dtvsmOufjDm/kYjD7pMr9MtC34E3j3Bk9mtSUraf7CkJbZ+EyJspqx9xRdHcra7Ko1ZXvz1OzG1ILmJFQxj8MiNvFhgA0irnQ8U0SQYD/2KT6TLcSqXCwgeJBTk9/5hqqua0KrgmZ+HfNOOtbeaGjC3xPvxOKvIJ1zqiUIXYRhmafBOkusaz1wdn9EdmAqgOrDYnz8Qj0y9Jt3anpAdKCsqCo9cYhwrHISqubKu00GgVADdfHuHD4g29Ke3oOHM7gBeu3R81oxD+cSjWg2HWh+RAYjzPpv7TbYvdZDKC1pPAXacizEqQkjrCPigAfKbf+SYJEQX1P6IQ9VZpch8YWeK9EQK6TeUoIccP2P5JNuDWuMG6S0yrJSA9svOV0WpSsKCYeUabXwR5wPijGAFW9G1sFaywtBciP3NilQefm2
 a9cBo9ex
 OtR3fg/O8PeP9JIgglxDZSEBQUv+3tulZC0J1412I16h5htlckcuiLYE7qEj0rLivXBMIHAWIrLc+w+UsMiL5rqOCq0o2CExsAzcfmJm7ibOVX53o5X+kQRw+6TwpsRocqzhSvZE6hSSFu2C/aIsRUHiposaCcF+Ds5hCAPPHIrtiy5RVFY/cQ9vuB83bl3XeKM0Dxkmd36bPu2K1l/bbJdyZZyicJNtJWQigglg4iK3Q7C/vIah0Czo0s0NzqEqCpS+qy2fSKmNrZwJ3jKUqOpDDKcUldJCmXPUnM11FxGr2i7h4/PDZHG9Mk9myTLpkWQrKgWRvTCrCeSRyoCI15tRwa88+TQggWTOz25Pd4Hs/IEYxAnpqQUOZPfM3WfL3bVqnrcNsIHqEbWagoOeLcbn/kzM5VqTZ6W5fC114yv7yUVb9SZDU/LoST3j1RcYhmdGcQxuEJq+xxOl2D5vY8i1xdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Well, there is long-term pinning that can break COW and other weird stuff
>> like FOLL_FORCE. Most of the latter probably holds the mmap lock in write
>> mode. Probably.
> 
> Well GUP uses read lock.

Right, so it can race with MADV_DONTNEED.

> 
> FOLL_FORCE won't override anything as we have this check in check_vma_flags():
> 
> 	if (write) {
> 		if (!vma_anon &&
> 		    !writable_file_mapping_allowed(vma, gup_flags))
> 			return -EFAULT;
> 
> 		if (!(vm_flags & VM_WRITE) || (vm_flags & VM_SHADOW_STACK)) {
> 			if (!(gup_flags & FOLL_FORCE))
> 				return -EFAULT;
> 			/*
> 			 * We used to let the write,force case do COW in a
> 			 * VM_MAYWRITE VM_SHARED !VM_WRITE vma, so ptrace could
> 			 * set a breakpoint in a read-only mapping of an
> 			 * executable, without corrupting the file (yet only
> 			 * when that file had been opened for writing!).
> 			 * Anon pages in shared mappings are surprising: now
> 			 * just reject it.
> 			 */
> 			if (!is_cow_mapping(vm_flags))
> 				return -EFAULT;
> 		}
> 	}
> 
> With:
> 
> static inline bool is_cow_mapping(vm_flags_t flags)
> {
> 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
> }
> 

Not sure what you mean. Using FOLL_FORCE you can write into MAP_PRIVATE 
R/O mappings. Particular useful for installing breakpoints into loaded 
executables etc.

is_cow_mapping() tells you exactly that: the only place where we can 
have anon folios is when we have a MAP_PRIVATE mapping (!VM_SHARED) that 
can be writable, for example, through mprotect(PROT_WRITE) (VM_MAYWRITE).

A MAP_PRIVATE R/O file mapping matches is_cow_mapping().

> So - we explicitly disallow FOLL_FORCE write override for CoW file-backed
> mappings.
> 
> Obviously if FOLL_FORCE is not set, then we're ALSO not allowed to get past a
> FOLL_WRITE and !VM_WRITE situation.
> 
>>
>>>
>>> Hmm maybe I'll soften on this anon_vma idea then. Maybe it is a 'cheap fix' to
>>> rule out the _usual_ cases.
>>
>> Yeah, something to evaluate.
> 
> I'm thinking more and more we're probably actually safe with !vma->anon_vma ||
> !(vma->vm_flags & VM_MAYWRITE).

I think there are possible races, the question is how much you care 
about them.

In case of CoW-unsharing, you're not actually discarding data, because 
the page in the anon folio is to maintain a copy of the pagecache page 
(of course, they can go out of sync, but that's a different discussion).

-- 
Cheers,

David / dhildenb


