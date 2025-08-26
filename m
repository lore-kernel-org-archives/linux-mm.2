Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E023ACA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F3D8E00DC; Tue, 26 Aug 2025 10:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D98E8E00E5; Tue, 26 Aug 2025 10:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB1D8E00DC; Tue, 26 Aug 2025 10:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A85106B0156
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:09:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37F3A8127C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:09:24 +0000 (UTC)
X-FDA: 83819091048.06.1584408
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 860BC160017
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:09:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CBgx2e8z;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756217361; a=rsa-sha256;
	cv=none;
	b=w3S/jcqmFL+j/pipOZyBI4Z0kEUFhiJmayzj7xZOTrDvQWZUgcLyEPU//RuviwfZBUN2H9
	VujNPjHByfnNy3QLCtFdl7a+PcSLC8PJTRaberG9ojTZg+oQVh4K9jOojFyYKK4cd7rzwU
	eTXv/RSqeiExdT8edqtRvNkT7G5Bdqo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CBgx2e8z;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756217361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r38Ew10IXp4jVZ4hrFLLc2cPCRDjSFsLCeWhOStjPcs=;
	b=pJSSU7JUlOYrBlcMRRVNZND1MB1RO4Giw5ykjePLlhTyeFsCj5zej/WLOHpNjzmWE86/IW
	szyQIlqyuh8wwxP1I5+yZK0V9QTfEFCeHRnpXsPUTmHQzl1tVp8IRfH8BVrhNEMZ7JsxbY
	9F/ekj26xnwi0os0kbYw1AaAkz/1KVQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756217360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=r38Ew10IXp4jVZ4hrFLLc2cPCRDjSFsLCeWhOStjPcs=;
	b=CBgx2e8zgsvyuPNF9IpuP2p/0UTT2TI1BiSY7PvUs666ZCq1+qnmEIHJ+9C4G1QbxtHww+
	i0fe7SMcgVj1tC+cJJIY5wQiVcmrxVtm5iICmXzHp5Ld2PkbRmM6wIBR3dnJH8jnebRmK5
	cJGbAoblZ3jJCOBWvPg6/AFlrT9OeYo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-Yf_33hiINbuFgdyL9gmQSg-1; Tue, 26 Aug 2025 10:09:18 -0400
X-MC-Unique: Yf_33hiINbuFgdyL9gmQSg-1
X-Mimecast-MFC-AGG-ID: Yf_33hiINbuFgdyL9gmQSg_1756217357
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3c79f0a5ff1so1075752f8f.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756217357; x=1756822157;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r38Ew10IXp4jVZ4hrFLLc2cPCRDjSFsLCeWhOStjPcs=;
        b=GeBfwbqV7uf4GMR31XQ4uyDsdXEG95AC3YpGVQWTHNZvPk8AEFskUFpQj1iAebUeJ8
         8oBUfNM2DbZKCr0U6Jt9PJzNGBHw5etJg0OqITyJFRu0t8QaqOksWdYhbXvR2Pk1ydWy
         ede3WtSs8dof+rvyJnbxQrhYp2wj4dmITchz9qhXLRaKS+Ks0j8ui9fAUqOuz1EGzr/I
         gamxnLisaxIK9cbomagdqUEW5uKNz8GXMLzMMEZMTGjAt/0ortZv/nB6iu4jYOuU1yOj
         pXVY95b37o1Zlhzo5SHw66pcycyyfAcaSJAtiwnTM41GWjD/n4ZYmC9ab09XsguD/Kr6
         pTnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyUFVDR9+Jqzuh1slsqTh5P+oDXh01nQkrVjIcDf0/7/SvfJ0BNQE9Mf7AhvOra2pDfJcwaqwRaQ==@kvack.org
X-Gm-Message-State: AOJu0YzOWMnbrbqhYfw38e1K4rn/mrudSfZaTvdRFstKu8M+v7rQvDFf
	2p1DiVcSl8JtcNt7taCXktq9BGrL6Q5V/An2MDNmMtZhwLGJMqj8ITESjlKWurTYdLN0oQNIjOh
	5n/kvACVSy43/EJTqsrzOEf38dXxjEALXpEGkxGkCVkquAxLEnaIo
X-Gm-Gg: ASbGncsV1yCwSd8/r3QIbH2+FAjfeJmo63Z7OrIoCKSxK1TUjDLi9CQo1nC41wzOPTz
	N7Xo8Qcq6WvqVNTqQTNCzr5eZU7cmjd1g/0he1cztWQ8o5DrAl6P4IXS01A+hpkrt/JNpaPKadv
	rre1Bg1FnEGh7/K+lA8UNVqMRTwtmCsrbXUWfARKF+PIhaTIBzxrGN1FluuOURceJ/n6nI7c8QK
	gRBgVcnpSJ67TdrZZNZVi2DvwQbSABwJGVMNPBdWtffdLDHXlBN/BfCEGo/4XyM4utKpiXRKZ2d
	Nr9NiD6GzNVjR63DwzSw8ktZmGDdO8rPlJdSbgeoP4HShDlUmzBZCTGqd4eB/QlGA6cVXYnG/g=
	=
X-Received: by 2002:a05:6000:401f:b0:3c9:a4b7:da09 with SMTP id ffacd0b85a97d-3c9a4b7de2bmr5506097f8f.31.1756217357347;
        Tue, 26 Aug 2025 07:09:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpVnjqNtC8/am/9sMuVxjSqK3ied/VaDZynwsfDDcUj7OQY0t9J9gKlKy5kQIg+ur0P4AuDw==
X-Received: by 2002:a05:6000:401f:b0:3c9:a4b7:da09 with SMTP id ffacd0b85a97d-3c9a4b7de2bmr5506077f8f.31.1756217356889;
        Tue, 26 Aug 2025 07:09:16 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c7117d5977sm16676603f8f.51.2025.08.26.07.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 07:09:16 -0700 (PDT)
Message-ID: <53a7bf3d-843d-4e19-b0a3-cc6852fe72c1@redhat.com>
Date: Tue, 26 Aug 2025 16:09:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/ksm: Reset KSM counters in mm_struct during fork
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
 donettom@linux.ibm.com
Cc: aboorvad@linux.ibm.com, akpm@linux-foundation.org,
 chengming.zhou@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 richard.weiyang@gmail.com, ritesh.list@gmail.com, xu.xin16@zte.com.cn
References: <2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com>
 <512764a4-611c-42d4-8b4a-2aaca4e519a4@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <512764a4-611c-42d4-8b4a-2aaca4e519a4@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wnO5bF3Mi1-u7F0E4yoVpQeU6_D35m5e6lXpvj8WSPs_1756217357
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 860BC160017
X-Stat-Signature: aum416nnoar1eg4kf51kzdnbkpa4hjm4
X-Rspam-User: 
X-HE-Tag: 1756217361-677282
X-HE-Meta: U2FsdGVkX19V6BPtB3ANDP4noUSutEL6FkVMHsC4Ct53XayHAdrivJwdBhIVXS8fS4s/gBOkt4nZv7lG4BHZ/Err9ikT2f9DRvE44Kwu/jqXaDvlDzJE7vgS7m66aYMg4yddX5g50suhA+D39TGqHF9N8TRKNqWoWXK14Ks6LVoVFX8jzdF85pKDZK9xccbLror4rv9fraRbKWv3KiOyoM8gnp503dcidd1Q/QJM1b70QQ/PKoxTq/zfknFN1JlqLsKw1kbUnUMYBlICVRqsTZE7rY8LxiaFZUZ7mG+1Sz7j5W2qemIduBhlXMK/FUrdK8F+FO4tV5ckOCbpm4dYLRSjkfTO0STdUVtPBqvPVX59ct8nSps7/nsiZHKvZxadMnociJrDzOUzz5/OFXlAiI6PFH8KedILLGka8qp1uztWUS4E5CuLUK7hMxJngA2pxq0rhpJE80batDnjclBGzNgWsdGT+SchjK4VNvM1aKK2O8oqXm2TwO6TS/LDAc+JN5/MDngoh4CWmOFlerzbYNKkEhxFVlHwOWPLXaaLFPXloSk9kel4JjR29IdMsoHXei3EnkvJjt6DR8i565QdPWX/tQbNZ0h7qeAl1xiUFy/mHPThNJPke0ySPTf4nh7og/qxhE8rLpiedA8nVqL2swS2AqZy4/86vNMwIMxnYTPtpKVxTQw/eN4NdLvf91sSFe59YTk7gtBvQ29rS7bb9HyTMapD3W+9y8zmwvdYLXuAvhp4nH4ssI9qfy9TNelJTGyIKtDNhrSzV9OaYn1+91FF0V6Z9ick/lHz5/V50aWYr3WU199TIVpgDcOUwvBtrbiHPcgrVQf7mlOAH2mI4p8/e5JcqoSKviAlOJ8ONi9ywuPsw2p8uH2CQfzKbhB0zl06viS+/fErUC453gt94qV9iN39ZZuLr7ZkxudrQ22945Tgg3DyP/afHm/S4q2mFImX7QChFy1lEvASLX5
 hUBe/7Sl
 30TJbVSIZAvp+921svn4SO7tsW7krYJ7kVaTz9S11vlzVmoWw8bd7KjKqYO4tlki8z9Z1gcqJ9j9Te5xt1Ney1xtd9Ml9uuTX5FWmNz67NNeLJifVrfYU/TmUjU04D0/+n+NsI9iQs0uPJeE4KOUr9p2xSc4IIplt+z5hKcg2D0jJi2hraL/6mcO05LfkpcQ92gTwu8uRfnFzh46G6xNO4iRugE2gSI+hfrM1c3EjMmqHtkX2etCyXr5nYuWCYf9+vzfStQOcw+744R7wBcjeGi6aOy2H865J4HfWZ1wvyEG9Lmi9Z47ZA8XPCowRlNdzNsQJ/6rIiJFFw+kZlWIizG0RqG+R2K5bG1q1Q3lBOCZcK553FvxqtcaIT45PyLc55zktYMIRHaUBda7TxcmO0Rw49j2jra+3fh58yuv5O5mIEEk0d0q8N5nQCGf4NVbvUbtfStud9PzJZnKwHUpSJyPKpQprzPEKz3EKoC+V9moeALyKgYTZnvKcni1Mf2xMk+zpnNkA1yecaTkNhWhwKs2WDXXlTjHeYRwzdwpHC0pq4ATUKdzTwpkmhf9GbmmOrNfG5fR5KkZEPpI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 15:47, Giorgi Tchankvetadze wrote:
> What if we only allocate KSM stats when a process actually uses KSM?
> 
> struct ksm_mm_stats {
> 	atomic_long_t merging_pages;
> 	atomic_long_t rmap_items;
> 	atomic_long_t zero_pages;
> };
> struct ksm_mm_stats *mm->ksm_stats; // NULL until first enter
> 
> static inline struct ksm_mm_stats *mm_get_ksm_stats(struct mm_struct *mm)
> {
> 	if (likely(mm->ksm_stats))
> 		return mm->ksm_stats;
> 	return ksm_alloc_stats_if_needed(mm); // Slow path
> }

The fork'ed child uses KSM. It just doesn't have any stable rmap entries.

We have to copy the zero_pages counter such that 
ksm_might_unmap_zero_page() will do the right thing.

But you're comment made me realize that there is likely another bug:

When copying zero_pages during fork(), we have to increment 
&ksm_zero_pages as well. Otherwise we will get an underflow later.

@Donet, can you look into that as well?

-- 
Cheers

David / dhildenb


