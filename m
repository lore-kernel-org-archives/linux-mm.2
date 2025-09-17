Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E6FECAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D598E0022; Wed, 17 Sep 2025 09:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0352F8E0003; Wed, 17 Sep 2025 09:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E662A8E0022; Wed, 17 Sep 2025 09:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1A868E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:38:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E38A86E03
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:38:49 +0000 (UTC)
X-FDA: 83898847578.26.1A82533
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 158C480006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:38:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XCB45+oP;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758116327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rWpRpLIJcUNQ4TuuTh6GHYHjJ2Lxl5zf8mNwE4ByCqA=;
	b=6iq6ACCTd4mXXZ7xkrNs/xINp2e2XqPTOGaKjHEE+kLig57flquoJVC4a53mj1A+e19NfD
	Y2a0HKnfJppoxg3XupfYQbawmZyftT1MQLVbJxO1L5OCfI9rm9ZE33na0ZFt6J+ypbt95w
	Ulj5i5azL29SYLMvpLOcTkWJV6vuzjg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XCB45+oP;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758116327; a=rsa-sha256;
	cv=none;
	b=YbQtyyE+xrgS3T1hnkEONSTGqHeDuh7Lvcan7vmh6LUKc/vVq+BcSzcgBHMvfhBV3k/P+E
	CbYY9qKNn6lmIesQfP6T65jPxrSjFZoDp38hLlNljAeZpvXqtduOCFk2qHMpDEHxXShwrE
	bGJREnR53XjTbtFg89XI8PzECIhG4F8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758116326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rWpRpLIJcUNQ4TuuTh6GHYHjJ2Lxl5zf8mNwE4ByCqA=;
	b=XCB45+oPXvuMzHY4+3wT2AsTSyPpbt3M/basGOPHrKHolWAtq4HsSixIuHZqafq2czNTQQ
	A8Iy8b7pqlZ8jgLbopKKSgwD+j+/saT18a6AX2sISXPy3WX6y3gzU6Rly6ioJJEbdL0rAg
	PypZ3cjzsJdQNOTnWpgrlwbOnYMa1xg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-OqZmOiGQOeKpUUIo7wEAQg-1; Wed, 17 Sep 2025 09:38:42 -0400
X-MC-Unique: OqZmOiGQOeKpUUIo7wEAQg-1
X-Mimecast-MFC-AGG-ID: OqZmOiGQOeKpUUIo7wEAQg_1758116320
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b9a856d58so17262565e9.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758116320; x=1758721120;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rWpRpLIJcUNQ4TuuTh6GHYHjJ2Lxl5zf8mNwE4ByCqA=;
        b=AZXGy2NA8La1n0b8yC3OzGUuPNSL71cM9ZzjxiaJJPaTGEMaKJ76FZjEk1I90RsQ31
         zjX04dakOKZmYlf7iSmbguSV/ev/0T359bHvvUuDsgelaDSUJHC4I2rMgGZDelhQBAqI
         Qp/NJ+YIwWhFQvakw/nuqQdUbuibaicPgImCLmZ3fwsysKibbDsRIxcfE7LIh5fHEFAx
         nRmED9oUnisy5GvduiAXK24+7P5x3+uG5hktdBOo7DfjfNKF6QSUDdMfNQYlb4Z1Kt+8
         vgQ6M+6HGXDTfqDSMx/60kXnuK9P9FldRSQ0i/xSvryZ366M97vlKZuVZNJXcHWqRqhP
         Sj/A==
X-Forwarded-Encrypted: i=1; AJvYcCXzv76J988SBQAJ40+0aCp1+o6ApKa+F+sm/jb4v9d6a8i1PA0Tsx2RgsYSGkY6LIF4dRHN49UaIA==@kvack.org
X-Gm-Message-State: AOJu0YyS5vkTFPaVXX+k+ab5BOL1sM0yeYAfzlTYpGgDBOxQz8WxQLMC
	HC7rkgkneQ29U+9M7SjFrMjL4bgYcvhQj+pi/zcb0WvbBSv7+p8hW4YF9g1betY4QSArGay6Owp
	pMO1qkbA5A8V+AN7sQjDTKuoxu4O/s+pdfZtv84vx+GHNllkT1mTD
X-Gm-Gg: ASbGncsY+BhEBpeIEuM4uxnuO7bMYJjTqhmtk2ptJRSD4QoWEl1bGMOlHGdZDscdKt5
	hVHKWqJjGr+90g8hhRIKyGc5KUL8GWpkjCsmn0o0E0ftz5Yq/+i3lhZOrrB3hwDYFDtMjJgZ2mz
	CBSFBqAOyTsQRRzbQ20qQwEu3A8xfUa/XDvpAfIGelX8fFRIWJ4yJWNaxV0BfrowFqvcX966ar/
	MFhdxkPcZe7JaI2McngQZcXj6LmQRjdf9XR7oI+Pz7xRWNNT9ULqsbVRLim53Xp2godjHZWLrYr
	sICwoRp1OdB9fD1twRBG3iGVCG2txRSP0N7YH2RS+wdKrZW7ubORSb1BC6DbwhBUjdCQeoKfmeU
	2PQfW3sfHyowWBsRhBR924HSQxO1iPuGPQjhWC1ZD25tJJDSnIuZV9lau6wA5gYkT
X-Received: by 2002:a05:600c:4fcf:b0:45f:2805:e269 with SMTP id 5b1f17b1804b1-461fcb3c0d2mr22688545e9.0.1758116319590;
        Wed, 17 Sep 2025 06:38:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuvYWydvbyPpvj1AaR8P/P81WlSFuc3j+9G9hsVgOCA31SDwOQXwQpZgSSgyzLhp1LrsumRQ==
X-Received: by 2002:a05:600c:4fcf:b0:45f:2805:e269 with SMTP id 5b1f17b1804b1-461fcb3c0d2mr22687815e9.0.1758116319039;
        Wed, 17 Sep 2025 06:38:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46139122cb5sm36519695e9.8.2025.09.17.06.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 06:38:38 -0700 (PDT)
Message-ID: <c6eacb69-86f5-4bdb-9c6b-04e3f7ef7c29@redhat.com>
Date: Wed, 17 Sep 2025 15:38:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] mm: introduce vma_count_remaining()
To: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
 minchan@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-4-kaleshsingh@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250915163838.631445-4-kaleshsingh@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8n5hUgFXwPdMvZMxofjbbqg13nwx6LONn8l_7-OkM5o_1758116320
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 158C480006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9tsxmokacexigr3yhdon1q8139mxtzpn
X-HE-Tag: 1758116326-112778
X-HE-Meta: U2FsdGVkX18w8x/4D+BGQe8US0nG1LSpnBc+xxLuYB2PkX/GEFnP3nDYgXnPGYv4WHvfpXDMtv0mzPKyDI52tNLo5AYWS5iOy0NYMy/R6Eu8mvxEFEPAJ6qjEfM7g8O6Cl+mHUbXb33ArQBqPB2z0nvg17BYhENlbYHFdhtaNR+QnDlqtoldBppknkpqdlN99Z99v62ZRQos3yDNUnPEl6DPepls11QZ6HtKQV8z4TuTeOKawbnztqmRvH5ugJtEibiL+D9myKk+zDtKCymGiwf41r3Oh1wZDqGEPXg2Vyeaju31vYO8tQGaYGb3J83kl+W5C4HfLvBK3iQZIvdPvYoghd2VFllwWH7YWj3uvfSdvMbExoHVZA4y8sE1UQXQvg/xsHtTohDHe/q99CU2pBFPSZpApIO1GQIDlbD+wUKm6r8XjX+hKKQUpPC4Jl8gzbs7qL+94tt3yOZzvxao3DPDTYuxnaKBxor5O7A1g/dMiWozxiuZar7jQ2HpmM+gMux3xtJG+TJVjKvnbnOHfncBMArj76Wliw2y0R7yRYqsFqRcj9754D1Q517M0do6eKnl1PULQYJV+bpe2w08RdKd3W+KYkS859/pGveWNtd8Nc4cfQoVc5w0EgkmsLicGF3lq6/Nef2N0kuio/vQvvHjh+KWLe3Q4Nw5YNttXN69Qi0cCgDHOBH+5SsUysZgV0mh15WgnrqC9cIM+Kx6viA1dQCy7CEHfQ07m0M4beHUjxtuvxVFCWYlwz1ALkAldytmGLcxup4Oms5wRuFo7g4IzaBi2jAFtP0uw3Qc/fpqjSF9hq9acfZqBX92lnFhhiQA0IcisGXYdzHBZ2p8CGh3N2rnggBP5L9CzbVRxJmUD5xz15ljr6sk1V+KLZkg7O+4QKlvIHIcnGwAVUU7mHwCTTzYKcedUz7yUcOj3jCA405S5KMRID5hBlqAiRShhS1Dg3BmBDrTAWxfKZd
 jFzrRwY/
 Mxjms8kHDcmakeOpx6LyQS/oi0PrhaG+nkCDU6B3GzDDLmLs7Pn7IE896XNCAkojeHLE8GI6TUsE7VkxQpsi61jkDqEtsXxZjZMGXR5yc31Ib6aZjH8/V19j3/e5uYmbauNZC91lXRS8alIH5du0nbo+p+Kc8plmUeYdKbkTAhKzzRMYHurgKgXr46k0NemIYfPAGED/wrFBxlBtkxxNJRnGXmzzKkc/POVYpFHWEztIbMmjkUEjCCvmAhzHfYJatQtqqlQLYaSSkdQvwI049azwfgur92z5ryiMlozhr8rOIqw+CdZNFCGrCxrGYma6ccvxPodWe7zmaEADZfdIcVfkN0GEwCu+mKCwpN3CMYsSQbNzK/ZsH+bdBbEUODqUtflyJzBnyMJUKe0AtYJKO5yD28QzHeZVvmARaPqZJGcjJqh5feiXSXNKMUfvbvSBKoGW4I15UL6dZjYjR0oFv795NKH2JqAXFIW6wYqlBDiWUEcgnPVYmDCSz3RY/luZJXt2b+eJe9h+uYaJ0W5EV3BXU/P0mFHi+0kjL1Bt3hz2Ha7VXl1LEJuD+J5Nrr3pRoDxpTXsnsp4WFgfJeGz5BRiZZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 18:36, Kalesh Singh wrote:
> The checks against sysctl_max_map_count are open-coded in multiple
> places. While simple checks are manageable, the logic in places like
> mremap.c involves arithmetic with magic numbers that can be difficult
> to reason about. e.g. ... >= sysctl_max_map_count - 3
> 
> To improve readability and centralize the logic, introduce a new helper,
> vma_count_remaining(). This function returns the VMA count headroom
> available for a givine process.

s/givine/given/

s/process/mm/

> 
> The most common case of checking for a single new VMA can be done with
> the convenience helper has_vma_count_remaining():
> 
>      if (!vma_count_remaining(mm))
> 
> And the complex checks in mremap.c become clearer by expressing the
> required capacity directly:
> 
>      if (vma_count_remaining(mm) <  4)
> 
> While a capacity-based function could be misused (e.g., with an
> incorrect '<' vs '<=' comparison), the improved readability at the call
> sites makes such errors less likely than with the previous open-coded
> arithmetic.
> 
> As part of this change, sysctl_max_map_count is made static to
> mm/mmap.c to improve encapsulation.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

[...]

>   	/*
> @@ -1504,6 +1504,25 @@ struct vm_area_struct *_install_special_mapping(
>   int sysctl_legacy_va_layout;
>   #endif
>   
> +static int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
> +
> +/**
> + * vma_count_remaining - Determine available VMA slots
> + * @mm: The memory descriptor for the process.
> + *
> + * Check how many more VMAs can be created for the given @mm
> + * before hitting the sysctl_max_map_count limit.
> + *
> + * Return: The number of new VMAs the process can accommodate.
> + */
> +int vma_count_remaining(const struct mm_struct *mm)
> +{
> +	const int map_count = mm->map_count;
> +	const int max_count = sysctl_max_map_count;

If we worry about rare races (sysctl_max_map_count changing?) we should 
probably force a single read through READ_ONCE()?

Otherwise one might trick vma_count_remaining() into returning a 
negative number I assume.

> +
> +	return (max_count > map_count) ? (max_count - map_count) : 0;
> +}

Nothing else jumped at me.

Not sure what the buildbot complains about but I'm sure you'll figure it 
out :)

-- 
Cheers

David / dhildenb


