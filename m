Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40ED6C61CE2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3157F6B0099; Tue, 25 Aug 2026 06:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A03F6B00B5; Tue, 25 Aug 2026 06:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167ED6B00B6; Tue, 25 Aug 2026 06:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF9306B0099
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:27:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55390120323
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:27:47 +0000 (UTC)
X-FDA: 85139415774.29.A284D22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9A743180004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:27:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ShPy4092;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787653665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AmTIRDghT5aZb5UGuzctLRIrFioVqTHUxr0Sp616qgk=;
	b=iDRd7V+2c/anXI7WOzy0Ko5AVnoUQfmuTFkmMy7r/kqEU1GGBRVgdGPCdo+Ao7yK3xqTK2
	/HTCKMIp8f6cYdUDD0X72Oqj6k8tqPQt9Fbg15NKZGNgBDmO0uSbdHEGLpZa73NelyHonI
	14VESdl7bCTsuhAku85NXARy+dM8W4k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ShPy4092;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787653665;
	b=7BBJWc9JimlT09eahFLAbif89rRl1pnvWQ7nZw8TSpsVAYG+nm68RuIBqBl/6YoxaEMnF9
	Y4z7yNYUdLofs+1tsWNnr+HzQM4qgFk4HONn76TGcYPU72zEOdkhE1NFOug71ETmOUTFnV
	VYpEeQKLbMmXNks1e8qwcuLkA396D/E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DBE3601E0;
	Tue, 25 Aug 2026 10:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12F71F000E9;
	Tue, 25 Aug 2026 10:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787653664;
	bh=AmTIRDghT5aZb5UGuzctLRIrFioVqTHUxr0Sp616qgk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ShPy40928OrdedT4DDHV3NrG1zdtp2MAf0KfSjOriqJwJmwdEeebXZhjY+cP2bG2P
	 DX24DZ2urmbwyD7akQHe+1sPrqr6SvuMKK2AK4T+u3tuHhzhSUtFVd3SlyGLPHZP7o
	 uzFwIK7JLx1I4W702S7bhpj+DSm5lZETQqTbTsWzYkubU9wFJ64sUIFk4STrffBu5A
	 sZBmGRklT2j1Em37fLf7jYrNhqyPiELdLO5jBis/uvJwAi1P+U9XCiDsHvtYDqLpu4
	 9ddSlAgY0CDyl4OLm66DB5z76DhHubcqRw7NHxEWgHWXTb81quv2FoS+kO52uUzrx5
	 L9srPGLmeeWEQ==
Message-ID: <fa60a766-6cc2-4db6-a38c-9a8e33925eda@kernel.org>
Date: Tue, 25 Aug 2026 12:27:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: fix missing migratable flag on same-node
 hugetlb migration
To: Wupeng Ma <mawupeng1@huawei.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, baolin.wang@linux.alibaba.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260707110254.3147686-1-mawupeng1@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707110254.3147686-1-mawupeng1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bpqwp7jqpeb8nzd53ucizzrzsiti4hix
X-Rspamd-Queue-Id: 9A743180004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787653665-898148
X-HE-Meta: U2FsdGVkX18dLJ7iAxQCK2n/kllvSqdDlMdUBhfu/AWSrV9ge6nxnk3J+ZVkedZXvcM04u2TP8zct9JsgHYTobeMj6ZIWiDUooiKmp+3MfzMZmk9U62+1MW9jhy7PL9eTCbcAijhQ4y9G5Qktyb2Uj3GQJgVMRcsVGS5V6C6RK+tJ4Hj//VDS3Y8tidsQ+sZI1EQ572dfrrJfEDQ6ONIH0frfKlbOELlLYtxlVunz8LN1KRii7RrbMlR1tf+s9Cm5+zHASIvfy7Ob0dBG7THhrKv9NnOttxVsTxTEb4HpRyJC1ewcbfSWoREEUfMf2G/OqAEiCglvIZL9H5KaGk9jmn9Bw6mcj3YH0AfeTxWO7zw5curl2S0clW65mUYtXwN5IJN5NBp5RDg4ccPmOOmGjOD1E378GLUJqJkfRwXWgoQtLmh211ymb0SESq5Cy4hdHRbR3n0iOS1PYaDEjFSpTG3Aw2xHr5a3f+geIJkzdavr3HDPjDrpFvmHmABJn2sjDQM9Bw7NpuP/wlRSx1N1ABxvAUWrWI7TEoXWqeEo20A/7GU3X+rv7dLSQuy0r3OgUIjYpEsqH/rrvrrZpxoJz7chTADYzxZjltf3NQ74y99B93BpUQ04hINZOGV62k+Y9pX9UA1Bj9k7Uipbt2fZkzqrP4et2V4SOyVNZteilzmkCrPLvvfufdnUdAcwYosbLhIocaWTWNaWTLEJ2l4Yc/GMc7OK0ZVlpSGPUS1wIM5nRMOe65NY0qixcJPfwdtCH3aDGNtSiGLBHgYwdGx+GT0Zu4aTLKjv8zuIP5bILHCTNf0LsraWLgXf8TcqZVu2y00TXTsOhILE9rNSq4l3gZRFwQ6wIsZSgN4QbFx/MKoJTalvRM1fN4VQhEO5a+kXEoryjc2X4WB1fti0t+tPegTuNrH/dLFBCRKJzWQiC0QD7K2xWiuLxOaX0bs62+RCBJB+0yPqF4AUs7wkcu
 n9iBfRrb
 fhnvTDt/5DnA7oe6DZFFurPuPeGPXyTOAn4NC/KctYVkmZF0cQkhbZkWYq4MIXU+q9Sw628CEmqogvsh/TRuAKWxYX3gACT8UnfKV4f95L5928tBGWBndgIlI1p+7U77Yfde2E3j1YHE3wjDtz9ABYc0111959iZN/cMiRQgh+lhjv3O54Sb69puweEmaiE04hLrODWSYkW6gJ9qaKhvMcGcGFJnIWTcdeydAPr34EMtR0JMs5RfwHH63ZKD5Ia8VTcHskSFbrVi7y874TegSMgVUtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 13:02, Wupeng Ma wrote:
> Commit ba23f58de896 ("mm/migrate: don't call
> folio_putback_active_hugetlb() on dst hugetlb folio") moved setting of
> the migratable flag and active-list placement from
> folio_putback_active_hugetlb(dst) into move_hugetlb_state(), so that
> the freshly allocated destination folio is handled where allocation is
> known to have succeeded.
> 
> Unfortunately, the new code was appended after the existing
> temporary-folio block in move_hugetlb_state(), which contains an early
> return added earlier by commit 5af1ab1d24e08 ("mm/hugetlb: optimize
> the surplus state transfer code in move_hugetlb_state()"):
> 
>   if (folio_test_hugetlb_temporary(new_folio)) {
>       ...
>       if (new_nid == old_nid)
>           return;                       <-- skips the new code
>       ...
>   }
> 
>   /* added by ba23f58 */
>   folio_set_hugetlb_migratable(new_folio);
>   list_move_tail(&new_folio->lru, ...&h->hugepage_activelist);
> 
> When the destination folio is temporary (i.e. the hugetlb pool was
> exhausted and the migration callback fell back to
> alloc_migrate_hugetlb_folio()) and the migration does not cross a
> node -- the common case, and always true on a single-NUMA system --
> move_hugetlb_state() returns before setting the migratable flag or
> adding the new folio to the active list. The destination folio is
> then installed in the page table but cannot be isolated afterwards,
> since folio_isolate_hugetlb() rejects folios without the migratable
> flag; a subsequent soft-offline, hard-offline or memory-hotplug
> offline of that folio fails with -EBUSY.
> 
> This was reproduced on a single-NUMA arm64 VM: a second
> MADV_SOFT_OFFLINE on an already-migrated hugetlb page returned EBUSY
> and logged "hugepage isolation failed".
> 
> Keep the surplus adjustment, which is the only part that depends on
> the node crossing, guarded by `if (new_nid != old_nid)', while making
> the migratable flag and active-list placement unconditional. This
> preserves the cleanup intent of ba23f58 and closes the early-return
> hole.
> 
> Fixes: ba23f58de896 ("mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio")

Agreed, let's CC stable.

> Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
> ---
>  mm/hugetlb.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835..cafadfdb63c0 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -7211,14 +7211,14 @@ void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int re
>  		 * There is no need to transfer the per-node surplus state
>  		 * when we do not cross the node.
>  		 */
> -		if (new_nid == old_nid)
> -			return;
> -		spin_lock_irq(&hugetlb_lock);
> -		if (h->surplus_huge_pages_node[old_nid]) {
> -			h->surplus_huge_pages_node[old_nid]--;
> -			h->surplus_huge_pages_node[new_nid]++;
> +		if (new_nid != old_nid) {
> +			spin_lock_irq(&hugetlb_lock);
> +			if (h->surplus_huge_pages_node[old_nid]) {
> +				h->surplus_huge_pages_node[old_nid]--;
> +				h->surplus_huge_pages_node[new_nid]++;
> +			}
> +			spin_unlock_irq(&hugetlb_lock);
>  		}

The return was really rather hidden, thanks!

Can't we instead just turn the "return;" into a "continue;" ?

-- 
Cheers,

David

