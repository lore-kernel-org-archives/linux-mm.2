Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376D7CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5D66B0092; Mon, 12 Oct 2026 06:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256CC6B0095; Mon, 12 Oct 2026 06:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C4F6B0096; Mon, 12 Oct 2026 06:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA6C26B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:00:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5143D120A61
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:00:22 +0000 (UTC)
X-FDA: 85313529084.04.15474DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B62621C000D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:00:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JpNNfIpo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791799220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lO4/itdKD6CCMFfIDvwdmBR6vekfHvlwTW6PI9ipQ+k=;
	b=4djzpPCLJNXK5aE91k4oE+bZGmIdw2TgUqfmJuWZ5gD4wmBfiH3j7TSITjuf+3fNJnYEbF
	bmSvinlEPT4zzP3KvB+wg/xQvpyW86WAWdXIch3HZR7GeYaJwpJlFlbB6duQz0566TdICP
	I6q/xGKAvfiiWchMrHIyssEMXm9GSsw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JpNNfIpo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791799220;
	b=spVrTLfqboqAf89NfOxnIIF9DsXwD5wrWjAwFl8eqcY0oGhR1ZY19nWxoTjLZgB8S/6uQr
	0rDGxe42cXckkOx/seEm7VyZZzGIhYe5ESRbhgnlB2rczMTN43WQ56oSNJcni4OYCxPyiw
	cmgsThbH5b+keewm78Jp6Ftmc9QYHm8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B37B600E2;
	Mon, 12 Oct 2026 10:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C671F0089B;
	Mon, 12 Oct 2026 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791799219;
	bh=lO4/itdKD6CCMFfIDvwdmBR6vekfHvlwTW6PI9ipQ+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JpNNfIpoGhnPu+tzNngBzBta550ZvF4Q2C2gbIhRPZhBtk+SE4mlVrDnCkyJGSx2z
	 qMVxpGfviWXd7ddNy5A36EUH7zrndO2RyWJvlfoiueRpgYeTPyTqoS7FU8uab/K9NT
	 9Gd6OZtTYsS7Br5UkZYbEdjeLL9u69NYe4qSiTxgDyihDvJgJanyj13wn0yufGXWk0
	 i6VY1ZYoHW4Cmf9ln9+G9mtAkUlBjEgiiAFt/NkMQN1rpaMYQFldC7ekAFJNR1Ai+7
	 uMtEn1egMAA9jY0JSnhI+BPI2zst2b2Tyz+b9HzNHDQCcDVKMP4AGklouwuOQxtTTR
	 zK0Cp8vv7BbXA==
Date: Mon, 12 Oct 2026 11:00:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: samarth.colleges@gmail.com
Cc: akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, 
	vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: keep the hardware dirty bit in MADV_COLD's
 THP path
Message-ID: <asyvgymRz9jtjWKz@gremlin>
References: <20261011132227.413217-1-samarth.colleges@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011132227.413217-1-samarth.colleges@gmail.com>
X-Rspamd-Queue-Id: B62621C000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 1wfeycstg4bx1t1j69f3yqoccdppjuh7
X-HE-Tag: 1791799220-554746
X-HE-Meta: U2FsdGVkX194lO8ygiUA9n2VNVmwZ2fXoGJYPjM0OV3BSvPdpVju+/p1Z247c0plqsIjTG/XyYAt9fi+6B/WzJAyCw+mxxJcZ0PSF/tm5L1/SqO0pDdpmDgOqTICbZ+vSiTrqNJFuv0T3y5nxMzX/ji4aSCLDo8ckTXk9WBN2i6kdHOTx9/CZT6zYijl0ytfa+ufgCovlRvKM+2P3joKGfUZ9HbYFb5h+mxCt9y+ONu33UFuChBUCb6SSOhCk22ApJDnZtDnZSTsMh0C4EsLDuOiiSryKqRlQX0S9K+jzATZG3fBeXMW8DYyEzrkaY20YU5IjvgABF9FSlycYH3D4t4waFRgX3+PD9ObHWt4LNsO7MTNlXiTFW57hBvSIiN7md3ljAj1DetyRgC+Wh4aISFIzN8RACEpVrADL0Ypce1yFnOI4iNkg/h2WpNtF9ak6EAdbl8uIDZspIQx8xugSz/9KZ+Z/HULJZgfAiGOOYQB9SosriQzFeicAGkxMfV6cb/8RF56EL3DBzHpimgdgBWFndtOcJCzuQ6wJotmiB7xsAiy8ZglkV6NcBLBUIxoARuT+7QNoRQD7V/LCJq0yfO0/IIF3jkgrD9Jap3LRKQRjjuaHw+8YDxdLHAe53piQtrRJAuHyjwJHNQ97qdotf5n/VmadPfBh5WwY7JfrVclYeXu6g5ECzuK2LR7EnAxR2CO3wcgV0gPrYbk3KCFuWM5cEg0RDTlnIs5gGjvckELVVenjHefGfwArR7jzxGsEOhjRzTySApgBWHY3FEB5rjn006HN2qYwaC3KMZEYH6J+9ri47szvm+jeDidKZjl/rH1v/flRWzDWCjduFZ1argfXONLHqpjsYxaEOFf2KAPGM5UhwKVFww03KSfX+jXQwK3It9A7HEwd0hjCYVubz8pk/7/BcoJmhjvZjVeK2N0iqy5n39iFHxLn6n8cupQtO2zMGCgaVB+wi3ZOj9
 6vY5S7JE
 ODLv31WqP/ioMqg6Zz6ahZkm/dm3iTgS/HvE7/GGN5meHYJtRa9YXlYGQOiTKfElmuNGzKn4UQ7vWHGqicyVjbofFiNdNewVXgKZiM1Ybt/X8zLrntSpN6MwAPlvUO1+lsh7B+O3aeEwuW2x521/uEIUaGYtnE50G2BwUeK2iWBNpa+Bqmi0XJePZBf/sLZh5qt6cKXvr1KHAJTKBC0EJ/gfbMvzGocb8mhdHrSJegN4R21jHg99PUMK6+Jo/WA8xUvbmE6J/PkVgHHy2QJGgE80x4SuFSU1NMoqx6BiiC4jXPknA2dzV/yHif4Ot+5YE7K+I1+08VabiyfaX94VFCHqQvvLJ5qlmCo1rdOwOIQcXk7Aap5enasS1uCyB0sNIBqG0gsDjIxcFxpJu3ANWiSnv7kb397GmKI5o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 11, 2026 at 06:22:27AM -0700, samarth.colleges@gmail.com wrote:
> From: Samarth Narang <samarth.colleges@gmail.com>
>
> For a young, PMD-mapped THP, madvise_cold_or_pageout_pte_range() handles
> MADV_COLD by reading orig_pmd = *pmd, calling pmdp_invalidate(),
> discarding its return value, and writing back pmd_mkold(orig_pmd):
>
> 	if (!pageout && pmd_young(orig_pmd)) {
> 		pmdp_invalidate(vma, addr, pmd);
> 		orig_pmd = pmd_mkold(orig_pmd);
> 		set_pmd_at(mm, addr, pmd, orig_pmd);
> 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> 	}
>
> pmdp_invalidate() atomically clears the present bit and returns the PMD
> as it was in the page table at that instant.  A store from another CPU
> that lands after orig_pmd is read but before the invalidate sets the
> hardware dirty bit in the live entry.  Because the written-back value is
> derived from the stale orig_pmd, that dirty bit is erased.
>
> If the THP had been marked lazyfree (MADV_FREE), reclaim later finds a
> clean PMD and a clean folio and discards it rather than swapping it out
> (__discard_anon_folio_pmd_locked()).  The store is then silently lost: a
> subsequent read returns stale/zero data, although the MADV_FREE contract
> is that a write after the advice call cancels the free.
>
> pmdp_invalidate() returns the pre-invalidate entry precisely so callers
> can carry the accessed/dirty bits hardware may have set concurrently
> (d52605d7cb30).  change_huge_pmd() and set_pmd_migration_entry()
> (8a8683ad9ba4) already do this; the MADV_COLD path does not.  Rebuild
> orig_pmd from the returned entry.
>
> Reproduced unprivileged on x86-64: a 2 MiB anon THP is marked MADV_FREE,
> then MADV_COLD races a store from another CPU, then MADV_PAGEOUT; the
> stored byte reads back zero.  On current mainline built and booted under
> KVM, the race lost 131 of 8000 stores before this patch and 0 of 8000
> after; a store-before-COLD control and a MADV_NORMAL control lose none.
>
> Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
> Cc: stable@vger.kernel.org
> Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>

Thanks for the report.

As this seems to be AI-generated, a member of the core team will take over
this.

> ---
>  mm/madvise.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -426,8 +426,14 @@
>  		}
>
>  		if (!pageout && pmd_young(orig_pmd)) {
> -			pmdp_invalidate(vma, addr, pmd);
> -			orig_pmd = pmd_mkold(orig_pmd);
> +			/*
> +			 * Rebuild from the entry pmdp_invalidate() exchanged
> +			 * out, not from orig_pmd: hardware may have set the
> +			 * dirty bit since orig_pmd was read, and a MADV_FREE'd
> +			 * (lazyfree) THP whose dirty bit is lost is discarded
> +			 * by reclaim, silently dropping the store.
> +			 */
> +			orig_pmd = pmd_mkold(pmdp_invalidate(vma, addr, pmd));
>
>  			set_pmd_at(mm, addr, pmd, orig_pmd);
>  			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> --
> 2.40.0

--
Cheers, Lorenzo

