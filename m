Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C6D6C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B5B6B0197; Tue, 18 Aug 2026 10:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422FB6B0199; Tue, 18 Aug 2026 10:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360F76B019A; Tue, 18 Aug 2026 10:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15C9E6B0197
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:09:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D9D48029E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:09:43 +0000 (UTC)
X-FDA: 85114573446.24.5AE42FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 11BCC20002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:09:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bVi5P/GX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8oJASEVHdJhH7uHF2vR+gZb+csEP8hI47I9UkZtJlM=;
	b=6EM7vRNG9qRAd8Wm4b0EeCw72BCM/+6FXTfCEU/hgwsJO3gEO50MQ1YzALjOc1hGDJm98E
	F7r+6/KI9thFsw4ahtynXG7Nv8kT7zwJZlakYL8HJuvWfDG3hGCSNy2Xerk7Q8G2RWJF0r
	B0kYbqnNU/daT1rXOYxoKhHK+r3lN08=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bVi5P/GX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062182;
	b=jpZw52QHkY5b2at8BmFacIfhcmU42vi2EcwiQ8+T8QWnr3r7/UbII4dvOT7UyGLP6R+kDr
	iFJJsIa64K5+k/zc7/RSj0lY4B+jKTnMdTWrx/nE3OMHSppDd3Zi/KKha4N1cHwbk8ILE8
	LrJWqSUOPuyyHa+Fx+FJGMObeO8zyDM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9ADF7600AD;
	Tue, 18 Aug 2026 14:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769261F000E9;
	Tue, 18 Aug 2026 14:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787062181;
	bh=X8oJASEVHdJhH7uHF2vR+gZb+csEP8hI47I9UkZtJlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bVi5P/GX9ay3YUlRE1FTJTFV+g9LQuHC72s4fDxSBwDEcdf1+laLaC8h8z3yaG2iL
	 OVAWG7HMg25vuVgl9hhPokSFjdoyU0W/muL8vOJRWPmbnraprsgt1H2LZzArN/oS0r
	 pBgxo2VOjkCJD/zX2mlqYY5rJhXVCgPR9fdIUZtIFuPgxjLfqDO+Wbthl36m8ZrR1z
	 r9UyDoiZEVrFLZ/WizWZlUcF9A0TKw3QT9Njf83KUs9ARV3+rKwRDld45AMD0gjtb/
	 M22ZOPIEEin/dBuQRzT0NSsGZwEq0bqjMnLm+PA1SWhKymOqVn6DpO37LuA3MbVdgI
	 72aoqmJUlLoBA==
Date: Tue, 18 Aug 2026 17:09:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm: add cond_resched() to free_pud_range()
Message-ID: <aoRnnWIUrZbh2uL6@kernel.org>
References: <20260818134934.92354-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818134934.92354-1-leon.hwang@linux.dev>
X-Stat-Signature: cnk54nm91gmck8we1q8zfximtbtodsdt
X-Rspamd-Queue-Id: 11BCC20002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787062181-233882
X-HE-Meta: U2FsdGVkX1/tBXS4GJdY494//L0YmzF7LkELf+Ek6RkINrvjpFSl04mtOFh3Jy1HU4Jp4qfvc+ZRDyFjqwSOwu5Wg3ncPBoA31lS3JCudfsiIzyOSCQZRiDLxR8QSc3qbnVqa5ijPSyfGb5UcB6lBujhUBLbKj4WbuVFh7jyXk3B1qdJoRgBwaBHCV9WoKKYPO6dDHVPHGBVNdO2Yeg6S3sElo/DzR2hlR4n8sV5qvYp/2KAqFDGNB+p3fXQb15AsAJIC8fwiLvOrpZjlLDd1td71CMhKNFKfjfo37SBz461SxUaLKL6yOv7/RGhZ0JnSUbcEmrbxu5wcLb5D30/vOm7cg3uqhPC3kqDf6MaBa/7/uyQCBrCtoI9xrfoIfAO02My5nGblg0iFa99Y1eC+yXKqnpwKbvvKSq0ifCW2Kq0eWj9zGN5FFpefZaS1e9eWV6WCyq4HKE2e+HNQYUPkAQL85EARqYY8M+7yYMAKn15e2wkShCemlT+Gk1KYlvW6TbIH6StRE/Odx6RIdesnnFodwKpZISBtevBrUYWRPpvk+iFwC9pchIAg60V3LsaeXFJlScVmVywhnjacb96z2C2gSyVeo+8/r7XeTjnY7tMDtPzzGrkqyhnVRmF4mMdiuqMNEWtIu3U9xvv24PKUUpVKIjmwykfW4DwuPJEfd9T9zxT4HvQioa8yJQrT0wSugJiLgpI3U2VtGPoynYk8NHzRrJymee8NvcayQMPbiaHPT5t+K5aKdq+D3X3KOtYRCDAbQPI06BYwFt8QhOxNTKwQPySsdR4auPEr6wS+rxL7pvVnRN4ydnlOS0PDwDa58WfbQD+e5g1luclhOHCT3Ce252+z2izuDW7vxt4Fy6qEPmtEzEl5bQ0OA8T1/r2fSd5KAxu6IFQ1QQw4F1LX1vXoxqCxLcXZ+OlchrusGgYZ6Sc480KgOJzUBVRmieQrJoIalpGY8e8surqCrL
 HtbF2IQh
 ormrmfYSlU55QmXmQ1jDWFGwmR3MEwuoGUXDJ29KuX/KBj4km3UOPLYMvHy96Ri1Ed+l9NI1j56VXyT/iwo+B86ev3yGN28DRMftn5uPs3ASDnV8yvK+YfvFwojupln+kU1MOszomOzb4cohdAywMcq0SIYqiLoKS3wlv6Er7LXA/7nqUfBvtlJzr0PZaSKk+m4hdBn1OAqxl/xql+4PrBsaiqqilH6zqz8R9numpN3CElZLgHQQtFxAyxkyHydpBBcULHfIUbh97y0z/oZWc+BGJC9sApunWTXjmPm2932I5e/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 09:49:34PM +0800, Leon Hwang wrote:
> Packet receive timeouts were seen in production. Tracing showed that an
> exiting process with a sparse 2.5 TiB mapping could remain in kernel
> context for over 20 ms without reaching a scheduling point while
> freeing PTE page-table pages. Hard IRQs could still be handled, but the
> per-CPU ksoftirqd thread and other runnable tasks could not run during
> that interval, delaying NET_RX softirq work queued to ksoftirqd.
> 
> Like zap_pud_range(), add cond_resched() to free_pud_range() so
> ksoftirqd and other runnable tasks can run between PUD entries. Testing
> with PREEMPT_NONE showed that the maximum interval between scheduling
> points fell from over 20 ms to below 2 ms.
> 
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 4134ac607ee0..68c15449de07 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -231,7 +231,7 @@ static inline void free_pud_range(struct mmu_gather *tlb, p4d_t *p4d,
>  		if (pud_none_or_clear_bad(pud))
>  			continue;
>  		free_pmd_range(tlb, pud, addr, next, floor, ceiling);
> -	} while (pud++, addr = next, addr != end);
> +	} while (pud++, cond_resched(), addr = next, addr != end);

This is really obscure, can't it be in the loop body?
>  
>  	start &= P4D_MASK;
>  	if (start < floor)
> -- 
> 2.55.0
> 
> 

-- 
Sincerely yours,
Mike.

