Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECFB2CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3512D8E0024; Wed, 17 Sep 2025 09:44:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3296A8E0003; Wed, 17 Sep 2025 09:44:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217668E0024; Wed, 17 Sep 2025 09:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2DD8E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:44:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9EE0859813
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:44:41 +0000 (UTC)
X-FDA: 83898862362.12.73D2B25
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3EFB9A000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:44:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eP/fNEOB";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758116679; a=rsa-sha256;
	cv=none;
	b=d3WJhJOo7oLCXJiy4CR8ip20oGwMC94R6h6SinKt0Z6L9i6JU+O0TJbXOYv50UvbbCKmh0
	ZAZE9+q2k06l+eCWSALqbbHm6L7HhZ/tvSlhvEpP+lCaDs0ENa97QsAVty1qoHzWPjkj1X
	YvWhfXWXMOexMjbZZgHpF0OGx8DcGGA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eP/fNEOB";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758116679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=liGb+1uk63kwOPhDFfASvfeBl4VQTUkO45gHzPQGBUU=;
	b=sHYFWhP1bwO/matEhiIx9bRy6qoCsSsjJA4Mbu3KBLwEdBJ+rJm567+dAfGJzsG73XzdlV
	6gTpTtPNxJSxDi6mvVo3XTjGWJc013oB4HPfQubx8ogwlRKU8RWRgkizrUF//+VBqprTMY
	zUVAEB8XBWcVkfkJ1DXsl80VWuuy2kQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758116678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=liGb+1uk63kwOPhDFfASvfeBl4VQTUkO45gHzPQGBUU=;
	b=eP/fNEOBrcwJV0uDt5y3nfAybIAYQfJhKTVphDBLFXjXDL27z5tK97l8Y541CyzLcVRd8A
	0QuhAMoqcrd3oJctVM0GPR0uKsB/3DYpvHdLFRT1I3pzIVFSTP/A1E8sesuzCItPredMnb
	K/r1VVoepMDxXFR+hh5PkofI6FIjnFI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-fzxhw_haPTGUeB7NNEpdOQ-1; Wed, 17 Sep 2025 09:44:31 -0400
X-MC-Unique: fzxhw_haPTGUeB7NNEpdOQ-1
X-Mimecast-MFC-AGG-ID: fzxhw_haPTGUeB7NNEpdOQ_1758116670
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45f2f15003aso21862415e9.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758116670; x=1758721470;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=liGb+1uk63kwOPhDFfASvfeBl4VQTUkO45gHzPQGBUU=;
        b=JfMVnTm352R2H0u0AC8YODgGvWLujx4eGt7G/vJxAT0Z0hKiGq8NmR6PbxoHrjYf/c
         e8rxdc2PSkd6ut2gxou2IhT8uq/6fqE+I18EKuehN3/CT27GyEJdRkokMKiunWsTWyU8
         TjfbieZxK47j8WM2x3Y6DRcUhb2p/Mm2G/aqY/iXhIp4zwWGdsGG0IDqb1SGRrxSyf/q
         lk9d1C0r3uLTL44tveIJCP8wWJfjbdf9icfM1R/OEo5R7FnqIqQH6iin7FhNdB54kX23
         p5+qXb4jBBtutaTZbM0SUWBjxbpbHVKZGiEWbLsMvmWNHCRlybNjhd+Lwy5DMGPWR4iD
         nlbQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0OaKgoYsje1gnJdHSiG1ySUw7AFtCxwKomubReQbOAVxmPWtfIlFqzaijpBJAlxasS38BAGBQJw==@kvack.org
X-Gm-Message-State: AOJu0YwxzREP3aiDu6lAPt1Ed9CklmnbGPbsNRlabGj7SjRgcP5Xcgot
	FT7TGkCC1cM1PlULEkr5U+R31feqtGIk0ZhjBtzNkwTu+zR6C/9J8gq6l6HnV0DYY3VSz9fD8G1
	PkiQrzw33VGzCsBKYtdTZ1kV11kAqKRlzs7XbpknOx9o9tYvVnFdw
X-Gm-Gg: ASbGncsWJ5NAkiJ2CEk4+BBf2QThul39OC3FJ3MmBzT5l/WaYCeBXMjaTUyySQ5GREZ
	im5kI8GwGoSF522GTLETFtzXwBjSqbc46+qynjha1mn/kb0pacoRoLZimW7nb8HxY2tW5CQCXhH
	bdSlKkX1LFjkxUpOWXo+9IdIeR5Wv4hGsLmYX51CV7gqrXPmRTjXAut+jrIWgewesPj6haRNkmD
	YQFjB7JlLf1StsvoKWM0TS2ggIZ1hGpXY5bs25LArzdFLsRvg7cOGSKM2xOeTYAqy/lYmqty+eb
	JBjRHEuUT1TIvhZwu1+pZ5J0Yd67AFeGsFJ5qWQWORn70mZnQGfw0s172xsxN/2d2iXWdX/CIFk
	JtTDxZsp8mrW6XPcujlrgcM/N3QVl8Js5P6extSnyX7dPSfAlL2CUq5nkvLRgPxI7
X-Received: by 2002:a05:600c:4ec8:b0:45f:2843:e76d with SMTP id 5b1f17b1804b1-46201f8a9f5mr21886305e9.4.1758116670356;
        Wed, 17 Sep 2025 06:44:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFw1RIyEIK4TW5AJcprHmluKxUYcV6LPPbUme37h+GXCQZ40f8U9IBbOvKE8vFxsWYa4at8pA==
X-Received: by 2002:a05:600c:4ec8:b0:45f:2843:e76d with SMTP id 5b1f17b1804b1-46201f8a9f5mr21885945e9.4.1758116669885;
        Wed, 17 Sep 2025 06:44:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46139122cb5sm36693815e9.8.2025.09.17.06.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 06:44:29 -0700 (PDT)
Message-ID: <eb7820ed-3351-4cb5-8341-d6a48ed7746f@redhat.com>
Date: Wed, 17 Sep 2025 15:44:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] mm: add assertion for VMA count limit
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
 <20250915163838.631445-7-kaleshsingh@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250915163838.631445-7-kaleshsingh@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t-l6TwW2s3_T2rewEKdJLb4l7EV-0P0qd61-X3EEqlA_1758116670
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3EFB9A000C
X-Stat-Signature: j1kexq755aaccnq5zpjoj8sjrfx5bi33
X-Rspam-User: 
X-HE-Tag: 1758116679-586698
X-HE-Meta: U2FsdGVkX1/S7P1zfS8GMPvNBLRXpvowySiUv8hciVCcqtJglZoXFAOZFjNH1Wv7AIkfirtgbA3sx03oemEYGbL9eMy4rmGX0hik9lJ9IPIBCkKhvc7F9WQS8Ja3HDf+zwhNUsfl2ss9dC7q67pbmfIDbzR/5DF/GwOy3T7WqHJaWl6yJTHGNf02YZWuyQzJP7qyySkX+PJTdY/hQ5qdASMdQctBn4Vu1EdbouWzCbzsuys3O8QFYl7oZyAYH3tF2XgVavKPkyQYajbOt1pEFI5R6uzNN8UYs3MGGS4JIyNhVbNtvisHE52MKVGk1JzC3wjQ6Ag5ROzJybrpKhs82Mjija/9x626ArR2KOvhNGZR2CLx6jyHxSVDCis4liMeBGy+UeLvq0NisetBr7G/y6cFwvTCBi/SGQeDMG4pcF4YcX1rC2X81qG4uLkZU+tYkwDZO7SLUpWAX4+uhRhoB3Qp6CvZdm/tUafnRbv7HbJYsUw29pFIW8AiJHfgQSOzRh85VFbkfy4NKl/X8aU3S5u+s0ocrR/4JpxjLhgZ3PID21n/cS4zjAzzAL77+q1ZKGETBJPmuH64ZLGW97dEFuCgFlXmRaheSXHQKTGIfPTJthSW3XvXBhf2nfM/wGHi3l+t4XFjjB+htqL+yWG2sb0z2d+eap86uaPXWc40bHCA+Ck945yzBgKnAytxvDogPc+yajdqeFYdXjY2uhupupI+anKOkdRaeDEt+RZGx0nyqM2S9APwKCFahGozVSENzvDOpCrF/iI03C0BbdLG4pBt6weEuZw+fB89JwJpeU8oOGRoFGA3xtOLhl3cDHxO9x258tK7rEgdH1RcKSxIdjQKw1uwHaADBaYdMxrwSRimOPSmQzm19KBQ0oZoVIi3gvSVf/o56lxVwCrlu9hpGj73pm69CAuEEab55nw5XmKGU0amxk7tGIisfSWfKnNqWA7230hYuj1T9AxO4S/
 XV0a+VLL
 bhOLnxEF60HKdL3jbOIBpZjfbXU0Tj39OeYFQFhdf2Abp+BfvTah0hAcb1bvT500eJXT+/g7gig1WAHJWZB4ttxjLErM1zo9j3jjwy9j0H3cwzpnyHI/4dZnpV1gQo5schvDRYaXnPuEz0RUfk9T50iOea9Vk0u6MUWp8NkqUeoz+MWb9oyDaRoXlfvOca9OyL3Vzs6vc2EyIUAr1WLyIo0kgYMpCcOrIgmCA6MTjwu1u+mI8FhAMnzzXKziXs2jOyJmLUc2kqDgSv7Ta+PR3cKQDi6yTfiWFH0yV9iu27i29WQHRnlTASE0nxxicBxFOoGpxR+DHy/KbZSz+Nei5PJ3fJuAUU2vmB39KY0+IhB+KJlxYsn+oRcdUy87HIIgi3dnHPcyWuAuck1a6RtGG9YgSHXKCFx7cMXvoPNuw6ZyWLZ8kV+A1tLMDGjD/WYjBDLeyWiXsKePHFzkBkMEWfZ/H9wP2T2bhc9x4Jag5kpzQwyC/idkuhPSTtJ+SXpo811kWXtklNU/n5SelTxX2ZkjrQVKvdlt4NLhgDLpbvLCYrNxyDf/AYC2Kb/07Q+rghEdr0ygMU8dgDFQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 18:36, Kalesh Singh wrote:
> Building on the vma_count helpers, add a VM_WARN_ON_ONCE() to detect
> cases where the VMA count exceeds the sysctl_max_map_count limit.
> 
> This check will help catch future bugs or regressions where
> the VMAs are allocated exceeding the limit.
> 
> The warning is placed in the main vma_count_*() helpers, while the
> internal *_nocheck variants bypass it. _nocheck helpers are used to
> ensure that the assertion does not trigger a false positive in
> the legitimate case of a temporary VMA increase past the limit
> by a VMA split in munmap().
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
> 
> Changes in v2:
>    - Add assertions if exceeding max_vma_count limit, per Pedro
> 
>   include/linux/mm.h               | 12 ++++++--
>   mm/internal.h                    |  1 -
>   mm/vma.c                         | 49 +++++++++++++++++++++++++-------
>   tools/testing/vma/vma_internal.h |  7 ++++-
>   4 files changed, 55 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 8bad1454984c..3a3749d7015c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4219,19 +4219,27 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
>   
>   void snapshot_page(struct page_snapshot *ps, const struct page *page);
>   
> +int vma_count_remaining(const struct mm_struct *mm);
> +
>   static inline void vma_count_init(struct mm_struct *mm)
>   {
>   	ACCESS_PRIVATE(mm, __vma_count) = 0;
>   }
>   
> -static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
> +static inline void __vma_count_add_nocheck(struct mm_struct *mm, int nr_vmas)
>   {
>   	ACCESS_PRIVATE(mm, __vma_count) += nr_vmas;
>   }
>   
> +static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
> +{
> +	VM_WARN_ON_ONCE(!vma_count_remaining(mm));

Can't that fire when changing the max count from user space at just the 
wrong time?

I assume we'll have to tolerated that and might just want to drop this 
patch from the series.

-- 
Cheers

David / dhildenb


