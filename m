Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B79C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700306B00B4; Fri,  3 Jul 2026 05:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7B16B00B5; Fri,  3 Jul 2026 05:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE216B00B6; Fri,  3 Jul 2026 05:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA636B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:33:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 864308E484
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:32:57 +0000 (UTC)
X-FDA: 84946951194.26.4A0C8BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9F5B180005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:32:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ewYhOz+y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783071175;
	b=72JSZgxCjQ0tb0I2FmrZ148ut5BlHH94kbG31WuAI3nI43tb1ggSJPs4MGJM4hgDZSG/el
	bUwW+zxqzCt/51t59wMIKmeOCFZOvJogDnSKfkURcsl2io+JLIELEP+mkKBmh4pC/HLSDi
	w+h25QASuRUv2/amgQAdG/cH3uKd3HU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783071175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e1pQpUBYSThfjFqXpi3CJbvoH2B8jgJGjXQchqDbIYs=;
	b=thv4soVoc4+g3VnOy7muMDaUXpMcVehj8eshizlNe+vnAeVjEG4hvbuPF+ORkuC/gGu9Z1
	JoTNRCAuSoaKFS2qqaLLoMR0Nl0ucyUuW6DS0bv7Hk8LNqZdfXk+IOb98/ILe6aPR2/JcF
	bAkpLiByvTNiHPXHY6oX1enBqIyzm3g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ewYhOz+y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C746B41157;
	Fri,  3 Jul 2026 09:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1451F000E9;
	Fri,  3 Jul 2026 09:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783071174;
	bh=e1pQpUBYSThfjFqXpi3CJbvoH2B8jgJGjXQchqDbIYs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ewYhOz+y/2ODJQiSe/1wYQEvPysmor5pP4hs4s16yHMRJct21kwF7eTWcwUsHq5jr
	 xbKpyswZ71LI/axa/e7vJAaK0uyh+cN3GPhs4nDzG/9z77a4NzlfWMCzpiauiYyC0G
	 otHE19G5VpTD58+dIcVh4xBBtQWZtj8UwN7J7hGJzkPc2cNMWok0Uxe6GXgGX/iaD0
	 K3rlzEMJQfO8x7gTe1qKW2vhOk3n7DxihnDmtl3zT1cBAZ4JVjdKyaU0sRMvsJSUnB
	 xUDixob2C4kwpPJB6mdECWk7woRCVBU5gPDlX7xWq0KJFCmSgxI0fipNd6D+r8yfKu
	 yuDeJKhf3eneQ==
Message-ID: <1e162a97-1594-495d-b48e-7dafaa0a6d82@kernel.org>
Date: Fri, 3 Jul 2026 11:32:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/18] mm: factor out can_spin_trylock()
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, derkling@google.com, reijiw@google.com,
 Yosry Ahmed <yosry@kernel.org>
References: <20260702-alloc-trylock-v4-0-0af8ff387e80@google.com>
 <20260702-alloc-trylock-v4-18-0af8ff387e80@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260702-alloc-trylock-v4-18-0af8ff387e80@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: km7j39f1n3bqiq8p59d7b631w9nigm7s
X-Rspamd-Queue-Id: 9F5B180005
X-HE-Tag: 1783071175-592854
X-HE-Meta: U2FsdGVkX19JMswiQd+lJHals0aSTIMEokfiNV2ZWSEL/SscgPvmspkMGDQHg9ENm//z42XeE1Y4ov599hAVq259p45xQ6d8KjyEhk14otrW5m3aJluTq49OgnXdk9/0KBYMW8QLa5ip6Zpd2LqMvwr8w8s31h2uJcSl/ch6iMQC9GSdlqkBaX6jJ8QP3wlNeO/2+OPQIDqpX/Sl1g3f9RPfY5Bf4RsH7c6M+lQ4sT5N77He3f4TYDRf2g9g97LQkEJlmrKe78xlXRe1gbtpIOAPbv/+QJ8htLLJwhJEFLKaGCkFv5qt8bJ9QR0TYoREq4PzFH4LM1o04intCsg73ymFCtdSagGjeMn0tgwNfS3+jtWOmJHnDfCfyRUQowZAqWm/vAo0v0+4IHmih+MRA4V19MTXXRW6daO6JFXqZHq7WpPFGvQt+g8Wulil176+dWk9hit4rMOKOp0666pd60ouE8dnsNNsysBPwMBzVY3vNV9QIyqrhtszv136Oj7mZR1+251twpgTndYHRSRLCt1M743g+n9i99rJv1I345U/gAUH1B6lHYx4PszhC3ZXNbZ7wCM0Yreo865+ZeFIxK1dhkM7UE5Db/vH3L4NhK3RGlZHRvJN8zNUVPHrr8/7kCT5JVpDikAqXapd+U9VzwkchLIlIE9glLUiG4QtOKbQtq0xC3qfPF9kji19neyXj/MqygV7pXnyoJqsDmKXTBdSRADOIlsEo5SJz16VfUfn3fPhHEBbgbc8bG/uK6AQFNYdbGN1lhIaZdjEeKtIsXY+oe+IAlauZLJlEWpeAlcLwmpGTNY6xzTkCkqXZ56rpzZBWFcHXFqSiKd+aL1NvX9gSAjGBPWxzhOyLYWJAjsQUyqiFhojplCsaxO9uRFQl/evTTWDPLjAjxRMyb0hQ5biTt2EwP7KLbTEWZBhvkDw1RozfIlEukEeQzyRPUZQcDn8fJOed9rLqXmX72R
 yJg/VQ1r
 wYwm9isj2dXHdOKyXGKA9xsWdh2CJWkmPTyIILVqLIKxhd7a+2TmhDQSgYaHMqTyDnQdkeg41meI6zDYTSpn6GnLA0c35d5/MvKA+fUnmn0Rg++RKCshs4woALoahxppjcUa/PypEHJJT1KQKVr9CzFz5iFoVSaTlqk7dB9bTQp9iQjJAfiKoyH2azhEVV0PS26oRCDwhHQiVHa/0o/FUJQzoKxIA+jUx53HzgzXstjfr0epAoP0SyCMfLKKed7uP8SAp/C8HxLsUR/rCnOdiv48VYz45OoIcCnEvLj5C/TZoIOoqAguWGN8aCn4LDZrsqU+5LjREaQLM+4qoBSyL4T58BZvVP6Py5+Wdjt0NJbxEcgkA5xTzQBVHVW7A48hMtXQCRXwHYpvsCenpIYmTtCuhMj1Le2C3ZKg8Dnt8WoLCFWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 11:49, Brendan Jackman wrote:
> Deduplicate checks for whether the current context is safe for
> spin_trylock().
> 
> Does this function really belong in mm/internal.h or is it generic? Not
> sure. If someone ends up duplicating this logic elsewhere in the kernel,
> that would be a shame. But goes in some generic header, someone treats
> it as documentation about where it's guaranteed safe to spin_trylock(),
> and then it emerges that there are other subtle preconditions that
> didn't affect the mm usecase, that would be worse. So, just be
> conservative and keep it local.

Agreed. We could even use page_alloc.h ?

> Suggested-by: Harry Yoo <harry@kernel.org>
> Link: https://lore.kernel.org/all/397859cb-b127-4cc6-9c71-044afc99bf0c@kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/internal.h   | 23 +++++++++++++++++++++++
>  mm/page_alloc.c | 17 +----------------
>  mm/slub.c       | 10 +---------
>  3 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 3c00eaf5f45a4..e6f300693ffd7 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1715,4 +1715,27 @@ static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
>  	}
>  }
>  
> +static inline bool can_spin_trylock(void)
> +{
> +	/*
> +	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
> +	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
> +	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
> +	 * mark the task as the owner of another rt_spin_lock which will
> +	 * confuse PI logic, so return immediately if called from hard IRQ or
> +	 * NMI.
> +	 *
> +	 * Note, irqs_disabled() case is ok. spin_trylock() can be called
> +	 * from raw_spin_lock_irqsave region.
> +	 */
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> +		return false;
> +
> +	/* On UP, spin_trylock() always succeeds even when it is locked */
> +	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
> +		return false;
> +
> +	return true;
> +}
> +
>  #endif	/* __MM_INTERNAL_H */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c3b246e67ed14..a63733dac659e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5291,22 +5291,7 @@ static inline bool alloc_order_allowed(gfp_t gfp, unsigned int order,
>  
>  static inline bool alloc_nolock_allowed(void)
>  {
> -	/*
> -	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
> -	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
> -	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
> -	 * mark the task as the owner of another rt_spin_lock which will
> -	 * confuse PI logic, so return immediately if called from hard IRQ or
> -	 * NMI.
> -	 *
> -	 * Note, irqs_disabled() case is ok. This function can be called
> -	 * from raw_spin_lock_irqsave region.
> -	 */
> -	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> -		return false;
> -
> -	/* On UP, spin_trylock() always succeeds even when it is locked */
> -	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
> +	if (!can_spin_trylock())
>  		return false;
>  
>  	/* Bailout, since _deferred_grow_zone() needs to take a lock */
> diff --git a/mm/slub.c b/mm/slub.c
> index 3989b4758ae0a..b19dc46de73c5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5408,15 +5408,7 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
>  	if (unlikely(!size))
>  		return ZERO_SIZE_PTR;
>  
> -	/*
> -	 * See the comment for the same check in
> -	 * alloc_frozen_pages_nolock_noprof()
> -	 */
> -	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> -		return NULL;
> -
> -	/* On UP, spin_trylock() always succeeds even when it is locked */
> -	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
> +	if (!can_spin_trylock())
>  		return NULL;
>  
>  retry:
> 


