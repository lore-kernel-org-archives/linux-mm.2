Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A25606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OqzYynOZ
Received: by kanga.kvack.org (Postfix)
	id E12636B05B3; Fri, 13 Nov 2026 09:09:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3106B05B5; Fri, 13 Nov 2026 09:09:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00366B05B8; Fri, 13 Nov 2026 09:09:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 57CE16B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:09:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C6CB1A02CB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:09:25 +0000 (UTC)
X-FDA: 85430278290.12.1D4F91B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5A72C000F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:09:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqzYynOZ;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794578964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5RaYaqTlEkq9wWix1JsfPr5fojmN++2yJa5YPxa4A8=;
	b=W726hmNWQxegtP6d4s3jS52XYe1hljWBmYqCsV6LyV+tKxwh0gDDJ+MCqHpsvIdL5eEX4E
	HrdGyllucfdfaBk3R46+AkJXvDx01ik+PH2fkZOZlzzl6Z9EtlQMT8HfsGVInl9dAPWSOP
	l08EvgYnH/0zzyjskaHs6BW8u1eHVeU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794578964;
	b=T1oFjv8NUm7pIOsTgVpKBz/d5KZmw17bPylv3d5RJUCyJatotn4i/qnbgYK9fujdrWrPSt
	BHpOH1dzk2YSD4qg0xJe9MkzBZN5BuvOgQ0q4MQRoVufg9n15BqdjHklHgj2vs6stUnulr
	8rYdMc10tuJg3GKCZPJg+f2qvd1hqrE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqzYynOZ;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11BB861EEA;
	Fri, 13 Nov 2026 14:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0611F000C4;
	Fri, 13 Nov 2026 14:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794578962;
	bh=F5RaYaqTlEkq9wWix1JsfPr5fojmN++2yJa5YPxa4A8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OqzYynOZXG2odj2F1DNoZv1gtpuyl6JnGus5F6/MZ5s5tBFfgZETBm+4pk7aElvqL
	 Dw1XXOtW45uMZHuk3Oey65/lhdIS03HohsIjNtyrII4Q5WNVJugP4YlCM7VvJsKwBU
	 DNnvgsXX3b3d27pD6tWEzzQf7PI8NItIm13gNtK6TgeQFePMVuvg3qLvvxFRisq/Wx
	 CMgH9oR3pfZamxCLJT9xVmUXnnas92V9pQBahfy7o1fDOFZFvHiJ5yO7EePDwZB1Kf
	 PAhxeHWJbAcrbcFfQMJhI5m1nZmxYrQndPqaveeLNY++Sz98nWlen6e9h689Vo8JSC
	 B2WbZGyb/C2Fg==
Date: Fri, 13 Nov 2026 14:09:18 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: chengming.zhou@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/ksm: add initialization helpers for
 scan_get_next_rmap_item()
Message-ID: <avcZQNlZ7cisQAeG@gremlin>
References: <20261112125754.176930-1-xu.xin@linux.dev>
 <20261112125959.177881-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112125959.177881-1-xu.xin@linux.dev>
X-Rspamd-Server: rspam06
X-Stat-Signature: fr6zig9jzbao1njmggaj1cb6u46zpyx5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D5A72C000F
X-Rspam-User: 
X-HE-Tag: 1794578963-303165
X-HE-Meta: U2FsdGVkX18myDWEh0WEb0iu2pzVz3Eu0ImLU3OBP3+fVzY/zOQE/uTc0qwFZDIasE5jCw8TJQen4DqZRAISt0b/0mSeFXTOr68SOUC3tMElvn8DSvCeddw2KUH6ydJ7Wa0wkQ9IFnP/kDbVdmWBETg5BIc8axUEpjQF41SlwDxCXHAjAOf6c8S87zvO7Q+seEAWJ5RVdiCF9H+R3yJdmD/Zl8Pm0nMp+4me7AunLyoc4q+yv2pHpNVA3sCfzdodKXOQOfeLE7XcuBdMZoZLhGyBUOmjf42co6hDMzjYo6/k389k6UeQuHXnlAexckiE1T94PpyxUgeeUhCP+1z9GOepgBvf3iS3AQx8MU8YzbvUhqzGisO9fzAbmvNGVuWcOf7GhxDMK5fVqw5VOl7vQ+kAdCfcRaVx24qAUf11fWddr/HB1uibEY6PYl7H+efxNU80+akkugHapGuGD97g/Hy57P426L/S9BCjOGXMX1M6jACAorI+DtbmhU0wZhWYkxKv1+69/1EUDsmUH+JCNMSotCepU8PfV2QuLvk0lGbejfGm5rez1rM25BC+EYJo68Ov4iH4v2s1uH5ApC1gMWJqz77i//2FVk7xZyEAhqr3SQW8gc7yOu0Vzy9HcUJRfwzEhUPeKVYYnYZzF28esroJPF2aLMVljyRGM7dphPUx4q3D/Q7ZT8aAUSR2RjxgJKSEXeUALX6CN326Tfm3JE3pX0lokA8/kYRjfdZQRYl1Suno9gielBFtI5lvu7g9lanRvOqT+S/GAvnjOqrZgomIR6VFOkX4FElxbGVJP2MEnMld6IhJs6KoZfvkUHVvfBEQCu1IyLqlhUchWj6er0fVIRZeXpwGCa0tq92NHOa7uINRaWzE4+EWnT8Kp2aOd3Ba4G85amvRnhucR7DqeqLOXbuq6tYSMTGmYFuy5tLQG7QqtpCvrslwJBcK5lZ76yUBetpGKZu9t00WyuG
 Nx7hXBSX
 eYdoTlAJP9lzPLSQZkMuXe+KDxWDo1vhIQrpH/GnkXGOYENzzGorQ68FklmJAvJ/BIDYJdiucNW7gvs27z2Xk0PZm/mi9WF2Pxd2uPa2NdNW7V7fsN7prl0QK5YtjAy6Whi0+TPMC5OkUJb07UvsM2HQs8Mc+VptoqQgVKPzehPZ0pmupdX7BszYpGksMQd60bPKCjrZMhUbrnOBMm6XuIY4orLiA07Q3uBEyUH7nBqgT91AmMaJwaiMOLM/hz+zSvenlNzDIIhcJo/R6T5rX8H8eDR1wTr/IZFkoK3h/EehF2Z7sNiMzmyS4LmoTmn/Fsrxy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 08:59:59PM +0800, Xu Xin (vivo) wrote:
> Extract the new scan cycle detection (including draining per-CPU LRU
> caches) and advancing the scan cursor to the first mm_slot into
> scan_begin_new_cycle() and scan_get_first_mm().
>
> This keeps the exact execution order intact while making
> scan_get_next_rmap_item() cleaner and easier to follow.
>
> No functional change intended.
>
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>

Again, thanks for doing this! LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/ksm.c | 70 +++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 46 insertions(+), 24 deletions(-)
>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 49977bcf04f7..e79e64372e49 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2640,6 +2640,49 @@ static void ksm_reset_unstable_trees(void)
>  		root_unstable_tree[nid] = RB_ROOT;
>  }
>
> +static bool scan_begin_new_cycle(void)
> +{
> +	/* Check if the cursor points to the head. */
> +	if (ksm_scan.mm_slot != &ksm_mm_head)
> +		return false;
> +
> +	/*
> +	 * A number of pages can hang around indefinitely in per-cpu
> +	 * LRU cache, raised page count preventing write_protect_page
> +	 * from merging them.  Though it doesn't really matter much,
> +	 * it is puzzling to see some stuck in pages_volatile until
> +	 * other activity jostles them out, and they also prevented
> +	 * LTP's KSM test from succeeding deterministically; so drain
> +	 * them here (here rather than on entry to ksm_do_scan(),
> +	 * so we don't IPI too often when pages_to_scan is set low).
> +	 */
> +	lru_add_drain_all();

The sashiko finding is silly, this reorders it after advisor_start_scan() which
calls... ktime_get(), yeah it's zero delta :)

> +	return true;
> +}
> +
> +static struct ksm_mm_slot *scan_get_first_mm(void)
> +{
> +	struct ksm_mm_slot *mm_slot = ksm_scan.mm_slot;
> +	struct mm_slot *slot;
> +
> +	spin_lock(&ksm_mmlist_lock);
> +
> +	slot = list_entry(mm_slot->slot.mm_node.next, struct mm_slot, mm_node);
> +	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> +	ksm_scan.mm_slot = mm_slot;
> +
> +	spin_unlock(&ksm_mmlist_lock);

NIT: optional, but this could be:

	scoped_guard(mutex, &ksm_mmlist_lock) {
		slot = list_entry(mm_slot->slot.mm_node.next, struct mm_slot, mm_node);
		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
		ksm_scan.mm_slot = mm_slot;
	}

> +
> +	/*
> +	 * Although we tested list_empty() above, a racing __ksm_exit
> +	 * of the last mm on the list may have removed it since then.
> +	 */
> +	if (mm_slot == &ksm_mm_head)
> +		return NULL;
> +
> +	return mm_slot;
> +}
> +
>  static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>  {
>  	struct mm_struct *mm;
> @@ -2653,36 +2696,15 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>  		return NULL;
>
>  	mm_slot = ksm_scan.mm_slot;
> -	if (mm_slot == &ksm_mm_head) {
> +	if (scan_begin_new_cycle()) {
>  		advisor_start_scan();
>  		trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
>
> -		/*
> -		 * A number of pages can hang around indefinitely in per-cpu
> -		 * LRU cache, raised page count preventing write_protect_page
> -		 * from merging them.  Though it doesn't really matter much,
> -		 * it is puzzling to see some stuck in pages_volatile until
> -		 * other activity jostles them out, and they also prevented
> -		 * LTP's KSM test from succeeding deterministically; so drain
> -		 * them here (here rather than on entry to ksm_do_scan(),
> -		 * so we don't IPI too often when pages_to_scan is set low).
> -		 */
> -		lru_add_drain_all();
> -
>  		ksm_prune_migrate_nodes();
>  		ksm_reset_unstable_trees();
>
> -		spin_lock(&ksm_mmlist_lock);
> -		slot = list_entry(mm_slot->slot.mm_node.next,
> -				  struct mm_slot, mm_node);
> -		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> -		ksm_scan.mm_slot = mm_slot;
> -		spin_unlock(&ksm_mmlist_lock);
> -		/*
> -		 * Although we tested list_empty() above, a racing __ksm_exit
> -		 * of the last mm on the list may have removed it since then.
> -		 */
> -		if (mm_slot == &ksm_mm_head)
> +		mm_slot = scan_get_first_mm();
> +		if (!mm_slot)
>  			return NULL;
>  next_mm:
>  		ksm_scan.address = 0;
> --
> 2.34.1
>

--
Cheers, Lorenzo

