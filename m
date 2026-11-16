Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5B2F606A338
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Otsqep25
Received: by kanga.kvack.org (Postfix)
	id C79EC6B05B4; Mon, 16 Nov 2026 09:14:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29D06B05B5; Mon, 16 Nov 2026 09:14:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40BB6B05B6; Mon, 16 Nov 2026 09:14:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 944E36B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:14:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25AA8160908
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:14:44 +0000 (UTC)
X-FDA: 85441178088.21.B4C4EAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8CABE180003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:14:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Otsqep25;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794838482;
	b=5eSHY+R4rcWA9hRDXAlJH/vbeUFlswAXXlZBqD6O0KqaLypfmuiUVnFAK/ENDlmRcAmsDu
	CQrAmiz7LZy31zPYWwKtv0OcD9b5MstNK5G7KwkZBBvCXBejX38xu1uE9PC87FbZTCCjqt
	G54saHBjMkMhy5eC4Efhlx/+rOTpQMo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Otsqep25;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794838482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZpAJBrxVDUG3AN5aD0Qg1NU1l6jqV0Ou7o1Iq7ljhc=;
	b=DyViJllro4uU5tCxn1n1WiprvYGQSnq213fTxohdGacPWkim+ojB3wk0FNM22gkTSpCGG3
	e4V3PZgIRFyD32A8dieTWOTGap5ywbyyWOhmX9pWVllB1ZTBGs0u5ourmwGgvYb0Efd2nj
	i/HvtS1hyv5itIrfDXV0316m9UuT7qk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05C2E61445;
	Mon, 16 Nov 2026 14:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AA51F000C4;
	Mon, 16 Nov 2026 14:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794838481;
	bh=EZpAJBrxVDUG3AN5aD0Qg1NU1l6jqV0Ou7o1Iq7ljhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Otsqep258j7a+fFg2THl4lNVNvtC6aDcWX37zWqfZJKN2mhSsfWGwIjoEC4R0bLEt
	 YXF0jBgnBZRxZmVRcMpFLUZfdHaTjOU3RmFZbKu/f4BLfXL7Wf01W3sRklRX6lOFcG
	 5RqCELFJ4Onj+ISZXwdDIJBu+WxZMxTT0729yjDYM2gFoSv2F6ogCPqiF26DVvJdpR
	 8JTvbNHGRouYDUQVCRD4n2bRpW/5wxnNhywny5ovmpMcf7pFCdhqRuV7fFKuzGmqNY
	 hYvbSAfakWXxDYIIXYEEzWH/Tx/iN+oiiqkJQSC8SyIIro6zHT1E7Wrc/TsroTtqNA
	 1JBgQW6wjc/CQ==
Date: Mon, 16 Nov 2026 14:14:37 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: chengming.zhou@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/2] mm/ksm: add initialization helpers for
 scan_get_next_rmap_item()
Message-ID: <avsOr-03NtFVG-6a@gremlin>
References: <20261116014434.310003-1-xu.xin@linux.dev>
 <20261116014655.310486-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116014655.310486-1-xu.xin@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CABE180003
X-Stat-Signature: h4wj3zumkwurkdda7fpibyuo6asdbb4i
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794838482-480214
X-HE-Meta: U2FsdGVkX1/L1GGmnp/0Arkq9FKNZjGQvpPI0xIV/Pdiy/fiqA0ib9SNUSTLCpCOYPt2hqJ02WZWxMwnGL5pZS9Ym6id1R6tpTIUdtB8GQks3MCUOmes5LvJSP8DNDTOr+RQcVf1WK3maX7h4Jy+r3UfU6d2zxaJwsHH8/+oiflqPHVcHsuhk1iUCc4ol8uN5653U4pib9ZcSGIDBL+G45WqeNCvlftiRiuBG99mXSZVXbAzskeJ4s0A9mbeEC3wTF8VfUgm97ZJm6WROZ++mBhjDCAiMqSL7UyOUShvUh8r+8OHF5i9qlEW97bdHMu8YewvaWe3ZBi6AyxLVWufeI9RIH2ZxiSADMc5uTl8zoHJJKqpv6ta1epVWZLaUcoWBAH6B7H76PXK0881TsGfHC+7YbTswS6jkm+GAUSPgJZ5VUe7YoevCASucBCXF+X14oaB8yh5tN1B2WjGWL9VFYlB8c/9T/Dm3Eqe+4gwrN2h9xBfb88sjNRJukq5QlbD9jMymZJENi4nfpFPWRSpbgk4wN4So4ZJshToyeATk07PwKRZROMrGR/pFZxixOyHVfgpGCt+Lnol9NAfavaZOKO24KzTSGTpcp6zQMAzgtDsDvSpuXUPt+7gga20ERXSlg3PUNHq+hyZw8NTg3mo7G6oMgwDiQIveS2HeqM7ZY5V217w7etXBWPx/O0iZCJFbRliaeYO7p7HRkUMoXefQdPuJHxQ/swElIwShLxLCoGdey1aCSBZbBjqQJ66lzBHu5FHzFJYZIfjETK3TGFJ4WuGdmhZPddCuD0sVG5Ux4TPNqz3Y+0/3BCgBOjt+noeIZfzaYJe8XzFikRMgtaWj7+Ej/mCkQuwDGackdCVP8gLFkTSa+GOINq8lf1BJM99ooPTp4A7GO9x9dua1J+J5j6uQk3ePyJjxjRoq+oN/Dh1RJjFNhOWiid0hGe0GNkvB5zJvYwlNhybvSoE679
 yIgm9B8Q
 rzeJvztK0QbSRnQ3kTF6KDjBBpswHKsvvrQNMt6Ih06KqfjBCEgT4Wkpj3knAXPgjt01rKRB8GGaEfC9iG/ap4HI78jTcwY78Vv3gE/jiK7VdtRFuA2HH2khxa/9g5lL3E3bxzmgNsbyG/UmSYh48x8rV2J2lINYoqlKK73jJvisPOGmFdcNZkdDtKbN7rGRCwYwkeWTalGg6YJE+11czyoOUNjEGIDz8OhqmxDo0uTXZSR7WwhjG7lfBmCUxeeImNPmhrxFYdX0yulh1tXnqMJskhvXmo97HQb3eB2noYRy1i60ioYuFO2eJ7AX8Utx2bC1/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 09:46:55AM +0800, Xu Xin (vivo) wrote:
> Extract the new scan cycle check into scan_should_start_new_cycle()
> and add the helper scan_get_first_mm() that advances the scan
> cursor to the first mm_slot.
>
> This keeps the exact execution order intact while making
> scan_get_next_rmap_item() cleaner and easier to follow.
>
> No functional change intended.
>
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>

Nits below but otherwise LGTM, with those addressed:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks!

> ---
> Changes in v3:
> - Initialize mm_slot = ksm_scan.mm_slot in the else branch when continuing
>   the current scan cycle, fixing an uninitialized variable warning/bug
>   (kernel test robot).
> - Drop Lorenzo's Reviewed-by tag due to the v2 bug fix.
>
> Changes in v2:
> - Rename scan_begin_new_cycle() to scan_should_start_new_cycle() and keep
>   it simple (David).
> - Keep lru_add_drain_all() in scan_get_next_rmap_item() (David).
> - Use scoped_guard(spinlock, &ksm_mmlist_lock) in scan_get_first_mm()
>   (Lorenzo).
>
>  mm/ksm.c | 47 ++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 34 insertions(+), 13 deletions(-)
>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 8db6743ece6d..89a3da4a4874 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2638,6 +2638,34 @@ static void ksm_reset_unstable_trees(void)
>  		root_unstable_tree[nid] = RB_ROOT;
>  }
>
> +static bool scan_should_start_new_cycle(void)
> +{
> +	/* Check if the cursor points to the head. */

Probably this comment is redundant, I think the code already makes this
clear.

> +	return ksm_scan.mm_slot == &ksm_mm_head;
> +}
> +
> +static struct ksm_mm_slot *scan_get_first_mm(void)
> +{
> +	struct ksm_mm_slot *mm_slot = &ksm_mm_head;
> +	struct mm_slot *slot;
> +
> +	scoped_guard(spinlock, &ksm_mmlist_lock) {
> +		slot = list_entry(mm_slot->slot.mm_node.next,
> +				  struct mm_slot, mm_node);
> +		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> +		ksm_scan.mm_slot = mm_slot;
> +	}
> +
> +	/*
> +	 * Although we tested list_empty() above, a racing __ksm_exit

I think you need to update this comment to reflect the fact that you moved the
list_empty() check :)

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
> @@ -2650,8 +2678,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>  	if (list_empty(&ksm_mm_head.slot.mm_node))
>  		return NULL;
>
> -	mm_slot = ksm_scan.mm_slot;
> -	if (mm_slot == &ksm_mm_head) {
> +	if (scan_should_start_new_cycle()) {
>  		advisor_start_scan();
>  		trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
>
> @@ -2670,21 +2697,15 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
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
>  		ksm_scan.rmap_list = &mm_slot->rmap_list;
> +	} else {
> +		/* Continue scanning the current mm. */
> +		mm_slot = ksm_scan.mm_slot;
>  	}
>
>  	slot = &mm_slot->slot;
> --
> 2.34.1
>

--
Cheers, Lorenzo

