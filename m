Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 278A3CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 06:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273AD6B0096; Mon,  5 Oct 2026 02:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224416B0098; Mon,  5 Oct 2026 02:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 113196B0099; Mon,  5 Oct 2026 02:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E122C6B0096
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:39:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6241014016C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:39:07 +0000 (UTC)
X-FDA: 85287620334.14.A0966D6
Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	by imf22.hostedemail.com (Postfix) with ESMTP id 90BF6C0003
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:39:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bBbOfut5;
	spf=pass (imf22.hostedemail.com: domain of nadav.amit@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791182345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jUXKHUsl8I+TxZpA4AmD7FcPh3xLEY1fLS46VnzRfSU=;
	b=M5etMEtC5rzF4uyDpCROTAQuPsuaQFnjq/JkCPgysJBA0Hj8wZ7TB3j95N2Lz0rOrgu2DN
	9fX1nJ808YLwI3m3rvVjehnNDAYBKLc3tt5OwYpuetIKN4rj/mZBPuXM30Gvmnabk6P4Qe
	6x1aHKVXMU3JFIPUvGLcyNaxwwNP27w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bBbOfut5;
	spf=pass (imf22.hostedemail.com: domain of nadav.amit@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791182345;
	b=i3/EGWGAp+LM3+67AnpqXniZc+GTUOm9uJQ4HvIJU/glQL5rbN+ryVJv8qCMbALLzi7rdH
	AmF2vTO2MMZg6OgMqhvoGC7RYCwo2kYztk04kBHcjPQEt2JCrzc9BsRVXO69pCqAbDwmcn
	4PK+zZu71oxeuHVyeu7YT7z+gNwC5rg=
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48b01c41135so821702f8f.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 23:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791182344; x=1791787144; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jUXKHUsl8I+TxZpA4AmD7FcPh3xLEY1fLS46VnzRfSU=;
        b=bBbOfut54UnKD7dJfB+dWIdssi/1CtOSn5kX7RfjqaRU2EEOkwbIcBeHzVCbU2TT4T
         4MLq3nn/kArp1m9j54xtyz75Y0pvSQmIDqC7ffZyuSmtPBxWKAbAJPcmgUgM4BrvE/NO
         09MyPuodt5pRKnYf2PATDAr/9yl8xpX6nNlQodAO7DHjaSe9ocsLdb9IDPKCx0D6bFcG
         Sa47E88Uq8W8kn6KSWFg3ItFZucPvthl8oWdrqPiBWw5TXK9MpbxbJ2NmhYSm5y9TX/a
         MpXLgotjFYhB6luy5WbBHBvmQIhWuOJNqhitLDaJ1bgdPtXLMzUBnip+4Bduo7dXqzch
         Xu8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791182344; x=1791787144;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jUXKHUsl8I+TxZpA4AmD7FcPh3xLEY1fLS46VnzRfSU=;
        b=jbz6lXs0Q8e4+viTZdJ+9UyIdPUjIlTFB9LvK8tqEd5xe3cp4JaNPDawTMpBd4NiBf
         LNkfq761gcudzjYN0p5hgAlDhMgNEehRYny7tgrZQe6ThMf2MQd0VVrT0b5ewt/dGK+h
         saAl82Y7TMir/4m5FjY6MOe/1avZXWfMJuAU+oNORjQEcGJyySI+sbGzEZxj0lGzd5k7
         Z/vTr1XmNPNI7eds9dOCi87zq0lRid9xoqoa5/WBUlhTjSQYH74cCE60DQUXaMglMKhj
         R2DaSMLYndsxoz212aO0Eofc/9lCgSUgkFoidWp4PBIox6HWd1NWPmjWMnYbqLK7KLeO
         xAag==
X-Forwarded-Encrypted: i=1; AKwUvByvwSGXfRB+Kxk1jCisvoxhEblWlUWSmL0RfwNoi3L1olUjuTuJKh2bpHYKpPz/2/QwfZZfOAiYLg==@kvack.org
X-Gm-Message-State: AFq9FYJyurLrIDwHQ2572lWQKhuJY7CyARn/07gkoxiKoN8l5i5Sg8C3
	wQWREhSYI9TtgZMQz/mzd+0flfwOZ4m4JG1JYS1w0EqThlaYN+i2joeP
X-Gm-Gg: AYBFou3moJM66cikWOY+7Evwoa3Sg+wcE9CNerh4wczb7mzzSS/eDJphaR9Flk/yXz5
	eIxkABWZUlla1o9pF8NHCaHcTqFSds/Ly+wjbEnSfdFLAKTpQE6WwAkEXwlH0qAeZsmegabULWA
	+eAp3PZyfug8lmt3jvJ0QkWHIhQsTEgXV7LjT6QmOYUezGz58ydAWybvE698DTv8XeFWE82dgJ6
	x4dPPnPPqzaAR+L9vbFsvZAtbWBGSRzjl1lyEjJ+FPl7iwHB8SNH50S79BXUxAaLTYaFuOTHcVV
	YHTigIU2ud2bmtlf+8ecNEQ5j2B5jax6njjJZsnRHKSCz3bjRD9u3/dokugjs6QRqxlE+K5UzkY
	HMvVEaUhOCdwxYntd7qIqYhrvKeaNMYN/mZQ2xKI1cRxdWnopp/MyC94fCJXah7RV9xULYFVxxz
	u9JSkAks1AIwEaWzontzfx7Mmxrr1wwDYx13MsW7i1A6KSdHnubTdQTrZo/PktBviT8FQ6ly7My
	GIXpBJDu4YSgZodhipFbHUU4+2Tf9oSto4bA5rUJCkKNK+KJvu06A==
X-Received: by 2002:a5d:6b84:0:b0:488:89ed:4430 with SMTP id ffacd0b85a97d-48b1273e475mr13370049f8f.33.1791182343892;
        Sun, 04 Oct 2026 23:39:03 -0700 (PDT)
Received: from smtpclient.apple ([141.226.89.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c63904832sm967264f8f.14.2026.10.04.23.38.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2026 23:39:03 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20261005052302.43042-1-lance.yang@linux.dev>
Date: Mon, 5 Oct 2026 09:38:47 +0300
Cc: dave.hansen@linux.intel.com,
 luto@kernel.org,
 peterz@infradead.org,
 tglx@kernel.org,
 mingo@redhat.com,
 bp@alien8.de,
 x86@kernel.org,
 hpa@zytor.com,
 riel@surriel.com,
 linux-kernel@vger.kernel.org,
 qi.zheng@linux.dev,
 thomas.lendacky@amd.com,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 akpm@linux-foundation.org,
 brendan.jackman@linux.dev,
 jannh@google.com,
 mhklinux@outlook.com,
 andrew.cooper3@citrix.com,
 Manali.Shukla@amd.com,
 mingo@kernel.org,
 stable@vger.kernel.org,
 toshi.kani@hpe.com,
 david@kernel.org,
 mikhail.v.gavrilov@gmail.com,
 pfalcato@suse.de
Content-Transfer-Encoding: 7bit
Message-Id: <D8AEF6EF-D92A-4838-95A7-EB93BE319BE1@gmail.com>
References: <20261005052302.43042-1-lance.yang@linux.dev>
To: Lance Yang <lance.yang@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90BF6C0003
X-Stat-Signature: d8go8b74pnckpxm6e89ficu9thgfnzpm
X-Rspam-User: 
X-HE-Tag: 1791182345-977444
X-HE-Meta: U2FsdGVkX18wP9L+kiPkZ91WSL00+UwrZTy4pG1GpiMSzgFCp+KcTvHMBgiJjX1O5eIWr0DEZAMUMIM3HMqNMWmh/lP5ei1FLyqk9tGJKh7oNttYzQtxjLq6rH5+46a17RPS62AgxMaxCQhKNSdXjlcYcEUt6uHTjwurv0P9SxeG5le8LoHuXBlLUQd7rFcIxjIT7mSzwxPmY/nEa/QQvV+2ANsLMw+nWXzrl3K9PalQquEm1aFIrb8voKojrhSjVjqIf1Z/QWc4SKEf3b43qgQnmpqvgYxpBtudRliz3RA7kdUjU2f8PXOgWFSj38ynXIvZ350iEDhlb+B54ULqg++14vXiEV0QK46Zf86dcItcmsoWc8B6UeGz49nd9SH4G9vngK7vUY2v73j5RhXo/tWtGYFHTZzoqL5nFBY7ozJ3ioDJNhFi9RuTvKambMXiblgeDNWyCmg25Q3MIEDzLPMAIai4hwEOl0hPRt6+gV2aj12elqBywNOPbAUa4ZROju2fJLF3jWfC8CNCV87lInxxNG76WYdwjTy1onQk1UFS+pg4BlrmrAfMiomgr89mKcAgzPsIfckdDH3Jnw6WJauXeyATNZmCgtkTcPWKr4uHTuLnASQLiY5ddvl4Zawa5G52xs1ROHFFXK9ZBhbKr4fp0XB1jXcvrijFyPToLXnhfeTDDnOf24w4Exx+AstSxkrgJHqDXnWhNxOylyoaoTAi5LGf59EZR3vKZo6FF07p5IWUtgTOx5aWHE/jadukDMhuwGI2n+BBxqEZGZvYl8WxjnSgCcn6HXgosOpbT+qbcu1wAUgJjdOjWxVqk+OrrBJqMvfA9MRhta6Kg60rtQGtDQOvM2OrOYduVUIXxGVlaLmpK/KervqLkNknzg5EnfJNzVE8u1e3r9QKB5BowdiJ93MapE+8wm+iVWINvUXDbQNkSuc4QV0rsjmeSn5vrWlKxbc44ouXbUtULEJ
 FV0Le5t+
 jmXLMSTSn4Uk4nDwTThnvRETdlk+vHvAl2yq4CNwYwNaAgoeuZpZrFmkdEUCm9qLr6qkKCKoJDo431SDWH+tF1s2vhbLtGzoqe1hFnMfPvtGkF5Il9QyvihzAIbSemQsr+AoWNDGz0yAQuX3AJYvohcPDxAPuwJS6myCpPWT0L3U6ndiex18vVIuXEPGtHTBP8XFvYFnAzK4k1fguMdv8UN5Oahb/gYz/mLc6bFAh4DdGmLw8n+1AcakXt1L+8I+sHL8j0OSmQ4jM04yxf42V+ZQeTSAFdE26x0o+iFBh6dmC19mMbGlWae8oQ3CVtPuScLfpQmy6U5kVS3UBdo4M6E4L7bcomCLlqoLhUFKJypORBamY2UP0JSxZU9kVh4ywTutPR6x40Iwa73VgvKDzCTw3IjN9CLs5OA/gu8lYH6IcwjPqFJwcVBRL+QV+PBW8hb4PmJFGPWW+qjVsN0ju2nfwzna81bBavDchWWXy0XRpsJ6RUckItcGQx9WC0qtfNE3U1+uAn7qA9TKMpV2t21rspA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> 
> 
> On 5 Oct 2026, at 8:23, Lance Yang <lance.yang@linux.dev> wrote:
> 
> pud_free_pmd_page() uses a single-address invalidation to flush the
> paging-structure caches before freeing the page tables. With AMD TCE
> enabled, this only invalidates upper-level entries associated with the
> target address. Cached PMD entries for other addresses in the PUD range can
> still reference the PTE pages being freed.
> 
> The AMD manual quoted in the commit enabling TCE says these instructions
> remove
> 
>  "only those upper-level entries that lead to the target PTE in the page
>  table hierarchy, leaving unrelated upper-level entries intact."
> 
> Even with all PTEs cleared, speculative page walks can cache present PMD
> entries after the earlier TLB purge.
> 
> Use a full TLB flush before freeing the page tables on CPUs with TCE. Keep
> the single-address invalidation otherwise.
> 
> Fixes: 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> arch/x86/mm/pgtable.c | 11 ++++++++++-
> 1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index 4a105f283cfb..6b7fa44f1bf6 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -727,7 +727,16 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
> 	 * via normal page walks. Make them unreachable
> 	 * in cached mid-level walks too:
> 	 */
> -	flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
> +	if (boot_cpu_has(X86_FEATURE_TCE)) {
> +		/*
> +		 * With TCE enabled, a single-address flush does not invalidate
> +		 * cached PMD entries for the rest of the PUD range.
> +		 */
> +		flush_tlb_all();
> +	} else {
> +		/* INVLPG to clear all paging-structure caches */
> +		flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
> +	}
> 


It might be cleaner to replace flush_tlb_all() with:

	flush_tlb_kernel_range(addr, addr + PUD_SIZE - 1);

While the flush-ceiling would usually end up doing a full flush, the
code would be easier to follow (the very least). Maybe adding stride
to kernel TLB range flushing would make sense in the future.






