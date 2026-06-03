Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E84E8CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 20:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414886B00AA; Wed,  3 Jun 2026 16:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4206B00AF; Wed,  3 Jun 2026 16:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA386B00B0; Wed,  3 Jun 2026 16:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1FD6B00AA
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:43:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2090C1A7D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:43:45 +0000 (UTC)
X-FDA: 84839777610.08.7F4EF52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 206174000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:43:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yBdr+bJ3;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780519424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXt3HlkGjPjjBzajXWzeASZrNMEoMaOOwTld8L39WrE=;
	b=qqIIkp71WRys9aP1zBOmymyhRcPNtmf6OKWcg8RZj4Ch6mR8Y0Kl1wbzIfcgqNu0obCSlm
	/P6aoDSGNFyNoLxvOAFvZWqGptmCFFBzBJEGKK9Rg/xzAajZAd3E4nmIy4XuTUfo/kpXjG
	9eE8XGHqqkOKG8U1gwKdJQAkRR4X7M4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yBdr+bJ3;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780519424;
	b=KSn8a7V4al3D4122JyoTrKeW0dzf6PVe3t2lZEo1nYUsQFeU7YW3BqKGgJRe+ZZU/rfCGf
	Lnb10XtsbX5YxqG4HOgzyjFkoNAlOa9NiMzxuNQwIcswDnATdmWGBdEdNkAFISjT3WCot1
	kjj02OEJ8nB39xJiDm3m1T5iu+m5xwY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DA766008A;
	Wed,  3 Jun 2026 20:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671A01F00893;
	Wed,  3 Jun 2026 20:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780519422;
	bh=qXt3HlkGjPjjBzajXWzeASZrNMEoMaOOwTld8L39WrE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=yBdr+bJ3R9u2rDk5PgtPf0n4/DWOgv2ezwhc2Eed/mQYXPKajZ84o56T7yrPi8eYJ
	 2TOVLzPMil8VxdpdiVWZyV8fEzIsYE8RX+LkC/7urfMv9+aG76CPTgtZvy56WlL+Kh
	 7zRz0TsvrKJCynL8t4AnIgfZUZivZFMHTgYW+mFA=
Date: Wed, 3 Jun 2026 13:43:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+deedf22929084640666f@syzkaller.appspotmail.com,
 stable@vger.kernel.org, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song
 <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>
Subject: Re: [PATCH] mm, swap: free the cluster extend table on teardown
Message-Id: <20260603134341.41b8c34935efd448c3a16a1c@linux-foundation.org>
In-Reply-To: <20260602222358.49061-1-devnexen@gmail.com>
References: <20260602222358.49061-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 206174000A
X-Rspam-User: 
X-Stat-Signature: 7gub6tfa1ix4mujf6bkja8im69zhzzaa
X-Rspamd-Server: rspam09
X-HE-Tag: 1780519423-933620
X-HE-Meta: U2FsdGVkX1/dqBbQZ+vVYRPMegE+CaAR4bhZOpG/rkyaCWKyYDQ0Idyh8hhLUtTPA6o9OyC0uOCa9AfIS+GABkPKA3XiqlUQX58o26/1cWutu4sLRpCEk8jNUXVpxDwl2LCLHLT2wKzhrKjZWBJeaaeDT4N5HrrIA28M+Ct+4q/a1wbtLzzVuFe+DukPkW8FlYPfMU1T3bn31TrufsZ4/XO9EV74tzzeydbN39qT1eDqP0zN2bepw1Sv/u+8hh/6sgvMaVQ/JboL2/rSdIHPcz3fznpvFMjdzV2jR5v46zD3gRcpn4i0H7mP1M2fpIvFiSlE14Jxo7o8i7eV0fFf2Hkj33J/T1B0X50g5vLhKPewIu0Au02Z3Qynndzb+Sbqkm/evVDzAppAeG9U8g9pfHa8mBBR2RZ+549SKrL/5sUkVbezuNdF0SvcvwQcflehHNG1dTlmUdQLLsj51XzAz5yT9QNYHhmf9DAUxmqL4Rt4RVdnwic6Wv63N+Co46jDpuF3Q9BhmuFJRuTJKtjmX2rMfN5uPB5qtPk4iNTJht3uD/kv9iR1z9BC6QdY4edkW+MXa+Q9gnpMZDEhZagozqv3vT4qkXhQy1GmZYiwKkfmdXxiI9+yF399OjMGJFIOFd21OZujh7f3vEcnJGyC9S3p6OqaeXnUR3TFv7hkFgT5zeoHJCGsYJACh8zWtSAtRvrFAHogD0L/cnVOctq/ZW9+OSxASsL1mF/qa7fG+1YwsIxb+qCEyhrGxyF1ssKgwJ9NnUDn1v4AXWbfrMPJaeHPVuHmLOD4fpb4VwAj+h7yl1DOASWXx1Hd1dwW0MQKSOJNa+zlgYP9smGEDeY37kXvYjMHd8jittILLg0xKiymRm1txPBSQTmHU63BM8SMdr1XsV/PDnkTgMHE5aBHqQQts/0a30G236oyX37a4xcUvKx2a8eBWgpA4CAFWXsN+qycP3J+73VhpTgveQH
 ZRMgHoed
 Ycu5Y4KqF/laOL/NhTxuPspPJszFyeCwQDV2tjwFpz2aODBKudOGj7JAa8ZvFK8biruhzfUCRNUDJgAXObygRVaZwCJWAYWkcgxiWvOA9c3WkgqIh5WwQZOuLhYZlwRuUO/BVIqbkx05fXZdfRcMiVGa9MH6W4wYVwL2Hy3qHw7FWv8jAXeDrMNckaGbVATEkUH2giGPEYN7vF9QAHwroBV60pPpJbd81DJZ/kj1oyscJxk/9e8TQCC4dmagGjhDo+E9x7x4jjpaEBENtgph+mXnj3GBAtUI3qrz28YTA2stxVOxORsKHzXSoqejvcXMAtlNqZVhQZhpdXg7uqJhIvaotPmfTOW+ROrNN15PpEKJkXQzJnOZYNaEoSo2PSdFRs+c6+8nXdaSYtQyJfVL/sgaKEPOfOoABdFCrUZBMgLoBFwf4EbcQ+BmzFdhysmNdIcRC3pUGOYzuNJ0WQvkOsFfg++iI81RX5iiwxJDO0RASAukj3Ol2N9cg4ky6pdkmS9uZbIOl8CjPCioLI1+nsti/5QXjYJMWXuUyR0aCAgs4SgA0BpYjS2qyiRtV5ABRlk9keEPiAo61wjUbSHIHKXD00WGaXE638xPB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  2 Jun 2026 23:23:57 +0100 David Carlier <devnexen@gmail.com> wrote:

> swap_cluster_free_table() frees every per-cluster side table but
> ci->extend_table. That table is only released by
> swap_extend_table_try_free(), which the teardown path never calls, so a
> cluster can be freed with an extend table still attached.
> 
> It can also linger while the cluster is live. swap_dup_entries_cluster()
> drops the lock to allocate an extend table when a slot reaches
> SWP_TB_COUNT_MAX - 1, then retries. If the count dropped in the meantime,
> the retry takes the normal path and leaves the table behind, all entries
> zero; only the failure path frees it.
> 
> Since a swap_cluster_info is reused in place and swap_extend_table_alloc()
> skips allocation when ci->extend_table is set, the next user of the
> cluster inherits the stale table and its leftover counts, corrupting the
> swap count of any slot that overflows. CONFIG_DEBUG_VM catches the
> dangling table in swap_cluster_assert_empty(); otherwise it is silent.
> 
> Free it in swap_cluster_free_table(), and also on the
> swap_dup_entries_cluster() success path to match the failure path.

This all sounds rather horrid.  We have no description of how this all
manifests for the user, but I assume "badly"?

> Reported-by: syzbot+deedf22929084640666f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=deedf22929084640666f
> Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
> Cc: <stable@vger.kernel.org>

First merged in 7.1-rc1 so no cc:stable should be needed, if we upstream a fix
promptly.

> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -432,6 +432,9 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
>  	ci->zero_bitmap = NULL;
>  #endif
>  
> +	kfree(ci->extend_table);
> +	ci->extend_table = NULL;
> +
>  	table = (struct swap_table *)rcu_access_pointer(ci->table);
>  	if (!table)
>  		return;
> @@ -1711,6 +1714,7 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
>  			goto failed;
>  		}
>  	} while (++ci_off < ci_end);
> +	swap_extend_table_try_free(ci);
>  	swap_cluster_unlock(ci);
>  	return 0;
>  failed:

AI reviw flagged a possible issue:
	https://sashiko.dev/#/patchset/20260602222358.49061-1-devnexen@gmail.com


