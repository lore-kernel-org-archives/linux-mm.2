Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 431ADC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 09:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49156B0131; Thu, 22 Jan 2026 04:47:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF6D6B0133; Thu, 22 Jan 2026 04:47:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947096B0134; Thu, 22 Jan 2026 04:47:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 819DA6B0131
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:47:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3FE891AF214
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:47:42 +0000 (UTC)
X-FDA: 84359122764.04.37BFDAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8376F1C0004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:47:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GpbNi5sR;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769075260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/di3aS+Khp7k2MvBSZFex5LUjDXW/4h4shKoAS+mVo=;
	b=LcsIT9kqlPNyB9W7B2qd3fngxeN1kmApRJwHSTwtCr3Wj5amwklsmvrTwomRd5EBosQ+YK
	QUWxRH7Vg76gwRCIieU/K5NLUFHEotmiIvLtuttelLh84R4I1hHP3UDS64zCSqCvd2EFP+
	vam9xVqVabcxq15bXdaN1LgJbC3G6tQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GpbNi5sR;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769075260; a=rsa-sha256;
	cv=none;
	b=i48g2Dkyr+JZUzJCini+/lxCERCrH5iJCC7Ch5hwl8XNiRlMkDEZ+QeOELgSIkR9iyz74y
	PrfWBur7lhbRhb4Wl4HSy4Illz/UIHuR0CH+qpSfUYUaGorMrOXwE3YbSR8kd5prD+/aH6
	kpdFA/UGdfWTmAHKcQk1kT7apVtL4O0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D9834424F;
	Thu, 22 Jan 2026 09:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B71BC116C6;
	Thu, 22 Jan 2026 09:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769075259;
	bh=LrI1u7CBAl4uC3y+gyT24+udVnx13tOxw8kLKpBQ7qA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GpbNi5sRXEKWS9gQTfzVJ8nPQSDQBsjTw9s+5TrpTIiQf10jjOgW79ftF4I+pXBUq
	 c/eYJbZD/jTXgEanhZSsuenErpzwOnqKWrY1kRo/FT+EgLulk6pR+aTGf+Xmt4r+rJ
	 rjba0YySrfbn1E6vlnHRYh9xxeHpI60CZcNjSd7r3I1BIS2aRdeT3KZDiQk4FnoRHp
	 Oi2GL3TQdHTUxgYnagHd4ietmPWZVoBAwPFCtYwMKwC6cy7opdYNHtWNcCkiFW5oAJ
	 FKex9n193pKNiHwQtqLesOKxVWMfGQ4mAPP3vC7YYGzaKT+rsrTYu/T3OkGdY0a+mf
	 TW1cGoZmfBcbg==
Date: Thu, 22 Jan 2026 11:47:31 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Waiman Long <llong@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] mm/mm_init: Don't call cond_resched() in
 deferred_init_memmap_chunk() if rcu_preempt_depth() set
Message-ID: <aXHyM1R18GI7-gSD@kernel.org>
References: <20260121191036.461389-1-longman@redhat.com>
 <20260121114330.6cd34b4732c7803f1720f0ba@linux-foundation.org>
 <0e385146-67a3-4fdd-b119-059caba8c5f0@redhat.com>
 <13d0b8b5-1ba7-4a3e-a686-13a7b993d471@paulmck-laptop>
 <20260122075747.uSLrSJez@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122075747.uSLrSJez@linutronix.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8376F1C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: mwksygrhwxphjo577f5xhrzjwdkthmrd
X-HE-Tag: 1769075260-469031
X-HE-Meta: U2FsdGVkX1+QeCkqgSgFd4KfMHlFY4WF3HT8TiCaPCwBciD1/PQyw8QYSWRu1b+ysysc4/lg9GZZuffnSzSQx/1ZNMr7aF0065vKflB40KW6XdQnIZBNT85dwBgZ8khGVI9i190cLLLIIwm8ZEmeZKkv1f6jBFMP8a2ea92U9Jktp68TiSJ3BzBWfaYiQWd82n2a/W3v1gWY1Z+96575u5iGFTIESa8oXsrVei2moTYE8WmfPsr+ws7C+ar/qyIoflgzaD7pHM945O3bMZaRLFu9xivIHswz1Th5rJjw7b1LXk3xEr1qAUF197NGDVJ4DBMQ1nJdeHtHYr6+qZyXyykwRcuQ+l86s7Rl9bkfI/mzDYv4ooDeR4JKjGrJSyh4gmS2oUUNYjPP5WPNxGs7i7dxMDqeAfp+pIEfyvhAwwU57Sd8cOb9w+XKT/Cmd/Ncs6sczlsviwZjts5mkyvcjwVfy99mEDncET906ao1YEQUMns1C3wKRUjC3nbStsxwXKQmqagWcZGNUIq5WPg5VGWA17XeA95UP+BsFldPGYKRxLIgTnik2o88f+3L513l9tE5dFq+AmkHn4tN9JqX9JVNYHeoeIlbdhmHnOJGEU8kRKGqDWZV3B2gxvMN0PdcgfGG2KqtBMGKNsV0j3JaTubrjOt+QbUs1s7gK7QnOFrX0RAid9+xfrvUqrTTO1VvYY2ph2oCQAoxaTBjT1DkgMrjQhW9+1ZtT8QZ4ZDS1b8nF3zSgTygllrxN43GCJU6IjcxUZDWqqUUwnqH9Zdn1ROkKm8LYsu7D0WDVnklXfiD3KKc3FsjbypKEyjYgcnKDuWJE3f34cvz5IgNZuS1iXshl9Aa3rcHMUGy+XFXZHa9BwNk1nImoUOhn81N7cJzOumXGcp+nbxHkJGbVVt+A1VeeSv7OH+ZdEtra2n00TUAQm6UDj6ehEOWdCSppdEekFYuFnc3JfbEK0Uyzn4
 eEV6BAg9
 t7EI44ssirQOoIhQc1OJjeFDduaeMqUJiq8sl5jj9PwVoLkE9qTXqT8+EZvaBpPdMg7WN0bH+RQPn1JteiG1fE6Abfag11BGSqM0TjN6VYeub3Z+Lk56/W1NJCd+Qx2ow259dKCs2swrycqVdz7kVZ4d8peGk+m197rm4sWSPrPe3s2H+JWCfpyMmKyXDc4la/YbQQ+l0G94pmzMuXgv+fx72XopL+/DRsYIybctTZpOsUcJE0xV+MZjG41918mRM2Ve3dvs542AhVqe9REe4A/hHUFQUhZA086g3nrARsB4mhyCUKxCirzmv5327p5WzgmKPfSJFxyPxA+g8Azpslr9x9b2pufMasIMRWM+sobC7LcLqs/ELR68j3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 08:57:47AM +0100, Sebastian Andrzej Siewior wrote:
> On 2026-01-21 13:27:32 [-0800], Paul E. McKenney wrote:
> > 
> > It is a bit tricky, for example, given a kernel built with both
> > CONFIG_PREEMPT_NONE=y and CONFIG_PREEMPT_DYNAMIC=y, it will never
> > invoke touch_nmi_watchdog(), even if it really is in an RCU read-side
> > critical section.  This is because it was intended for lockdep-like use,
> > where (for example) you don't want to complain about sleeping in an RCU
> > read-side critical section unless you are 100% sure that you are in fact
> > in an RCU read-side critical section.
> > 
> > Maybe something like this?
> > 
> > 	if (irqs_disabled() || !IS_ENABLED(CONFIG_PREEMPT_RCU) || rcu_preempt_depth())
> > 		touch_nmi_watchdog();
> 
> I don't understand the PREEMPT_NONE+DYNAMIC reasoning. irqs_disabled()
> should not be affected by this and rcu_preempt_depth() will be 0 for
> !CONFIG_PREEMPT_RCU so I don't think this is required. 
> 
> > This would *always* invoke touch_nmi_watchdog() for such kernels, which
> > might or might not be OK.
> > 
> > I freely confesss that I am not sure which of these is appropriate in
> > this setting.
> 
> What about a more straight forward and obvious approach?
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index fc2a6f1e518f1..0b283fd48b282 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2059,7 +2059,7 @@ static unsigned long __init deferred_init_pages(struct zone *zone,
>   */
>  static unsigned long __init
>  deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
> -			   struct zone *zone)
> +			   struct zone *zone, bool may_schedule)
>  {
>  	int nid = zone_to_nid(zone);
>  	unsigned long nr_pages = 0;
> @@ -2085,10 +2085,10 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>  
>  			spfn = chunk_end;
>  
> -			if (irqs_disabled())
> -				touch_nmi_watchdog();
> -			else
> +			if (may_schedule)
>  				cond_resched();
> +			else
> +				touch_nmi_watchdog();
>  		}
>  	}
>  
> @@ -2101,7 +2101,7 @@ deferred_init_memmap_job(unsigned long start_pfn, unsigned long end_pfn,
>  {
>  	struct zone *zone = arg;
>  
> -	deferred_init_memmap_chunk(start_pfn, end_pfn, zone);
> +	deferred_init_memmap_chunk(start_pfn, end_pfn, zone, true);
>  }
>  
>  static unsigned int __init
> @@ -2216,7 +2216,7 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
>  	for (spfn = first_deferred_pfn, epfn = SECTION_ALIGN_UP(spfn + 1);
>  	     nr_pages < nr_pages_needed && spfn < zone_end_pfn(zone);
>  	     spfn = epfn, epfn += PAGES_PER_SECTION) {
> -		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone);
> +		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone, false);
>  	}
>  
>  	/*
> 
> Wouldn't this work?

Yes, it will. And I think this is less fragile and clearer.
 
> Sebastian
> 

-- 
Sincerely yours,
Mike.

