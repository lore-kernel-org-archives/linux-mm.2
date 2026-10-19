Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B9C3CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 08:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112626B0178; Mon, 19 Oct 2026 04:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9866B017A; Mon, 19 Oct 2026 04:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0271A6B017B; Mon, 19 Oct 2026 04:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D46686B0178
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:51:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61495A0696
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:51:06 +0000 (UTC)
X-FDA: 85338756132.02.AA8DBB7
Received: from mail-10626.protonmail.ch (mail-10626.protonmail.ch [79.135.106.26])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4BBBE1A0002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:51:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=EkMU7TSv;
	spf=pass (imf19.hostedemail.com: domain of nick@karaolidis.com designates 79.135.106.26 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792399864;
	b=fSFLTV1SCFyJawrpuD/MYyizW4TqtrxiYHZRIC8R/LIEteDLYAFOTpNiTvCpSBmaOc2OK4
	lEZNFNKsHWnGf4ggXh+X27dwQfdd6CMEEURykQNG/RkTugHCrXjiiQX29QwevYYzRkpHxP
	4O+EyzFebmxScn7iPCpJllWTG/TTbAY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=EkMU7TSv;
	spf=pass (imf19.hostedemail.com: domain of nick@karaolidis.com designates 79.135.106.26 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792399864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxWiRzun1MUxXHHtwkjm2y/TD5zRPsCCzmyXZVf4DBo=;
	b=5y6LHDl8wPnubFf7FgN0G8Db6p7XLtwHNSaKglquIVWoioXraFElRnCTcjjlIq6fah4eFd
	sB6EyA/hCIVu1YCFbqGXKBdWdqKCZOtnJEUbzFi45Ed8cqKMp/gG0SUgefemNYnMJ8aAdO
	B5uglgXS6w2+HMWWgm5TpBStIOzXEmQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karaolidis.com;
	s=protonmail3; t=1792399862; x=1792659062;
	bh=nxWiRzun1MUxXHHtwkjm2y/TD5zRPsCCzmyXZVf4DBo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=EkMU7TSv/sPpSb//opgCgtpPnFPfEK1cZE9o0zTsUUc8huV+SG0wgnm9U2f91bNCw
	 KSTc/G5CxcD73YDpt5w0/grU/CHUe44Bi+KEKULxldGrZK1tXvvHhQkbZfYbrJJapv
	 N+Oc2QsLXYublEw0Gt6bYySPU08EOaRQvCfeNOko9UoICxa2Cv+XHe9MrQIMTpsmTV
	 f+I//a9qlTcDwY2qP6d2k7Xa6FJa0CeokK+1s0u1gCIym66jyWVEAyW8SM5E0DowY6
	 vgdYUT9iVnNIcPpwUXXPCz1JrTMXcjUq6V47cf4kfkNgYC4Vxa1v0ox9tMmxwidA7E
	 Js4kvMYxN9fyA==
Date: Mon, 19 Oct 2026 08:50:52 +0000
To: Zhihao Cheng <chengzhihao1@huawei.com>
From: Nick Karaolidis <nick@karaolidis.com>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs: rotate inodes whose page cache could not be dropped
Message-ID: <qNyuimLVAkP0k7luIlbuqeg7Co3gXnyrzZ2fIuFjRZiKon2IaylrG1-_tkSRE_cWyOuq6eIzU6O12OvRg8J-ZszqHBaxE0XL2uYVhQ08MS8=@karaolidis.com>
In-Reply-To: <5b74fceb-dc8d-21ad-d313-eba7a0009056@huawei.com>
References: <20261016102515.111285-1-nick@karaolidis.com> <5b74fceb-dc8d-21ad-d313-eba7a0009056@huawei.com>
Feedback-ID: 101209095:user:proton
X-Pm-Message-ID: 56a8ba167d1bfe9de3fb76b4475e97c78503300d
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BBBE1A0002
X-Stat-Signature: 6mybkioj4pe86iki4crt4749ccft3fzz
X-HE-Tag: 1792399864-643702
X-HE-Meta: U2FsdGVkX1+bQsd78HyKlteWawKw0DBwy5hv2Y2dLc6bfsqDnkk6mQ9++arPRzD6h3YpqyCy2VsLQbguN6ZSWOm2avq6y2Cezk9ry6SZ4ilRu3GdrIG85nN3Ee3+dX6qKHz0iArQoNKpTncpFLZ00U/XXE/ME7qMrPVZWQn5fAgZaLVHU5FaEzExERtvgpFxJKtxjD/ruNUPMk1aR78ABhp4n4hw3HdkVWvb77zKtz/OPtVA4AQOUIpa88zCZLJppI5ujtFhQeZR5NvY9IbBDCVtaxnCsgPP+BUc9Xia2p6nHpjH97Q9CYg/HxSMnISuUfoNWSs2UtqNLSdghOybomz6/a+bnYhflfgQ8Wau25l5muCviNqedfBt7BY8n8hn9BbvvxFafVQdLlBpSiHjt3z7by4N2CtAadLgq6LvtM5bvzKQEvUu/QdKVvf7iDC+SnTywh3SgrvW7yigAZsN2jjZQkiX7TVSiOy5s5zKrYUUTyCJxY5rMeDYUt4HGXzpC6oK9ysYk8fJ0vlws443yGkMBZkc2zMW6GDTyAPfoGfkyz31KRyIpmx+VHFIzSbD0VyyDjL2tFEC8GWRh3tHs64SupfOopkUPRY59Wf9p0bbRDvJGW8zykWtQAYuFuKqp2quTXPp1TRq79uYPNbQc7fe8YZR7InH6c0TZQrniDlVRMFgXQKTRQdfcDqzcJpXBWz3PF5sietajMnm3hRnvlmLUsrCWWAfRxWjdXs31mG+PuozgSL5wpjNYl27lKWdpLqoW2WXU/JaErCt8NiQduHLIKSWQiFwGebbWBh8T8TUR3iAcE5YvnvWOgO9MLJHqMNK6vM56ANYwCiXtg2cUKNLxEmIdEBXZvP0621rTIINqONqXHK6l8Bw4elzPhOaIOdQDGIrw0upIEcgq73iHktmaOIDPqaKmKeUxSCggRosCuUEfMB7R+YaEqHV61P02xLDK4USfMRggngpx7f
 3cdlRvdT
 DMlSk2eK91SlCJw9yPvwiBCvPczBQ5mn/tSxGsjuqg0R/pQi+aroaP59wEZ3DkkyTsdn6WdZlPNJTuTbUcvf7XLHwrjgl8cxtkZYyqwufn7Y1Pqa2Pd0L0aee2UwHF4RqVOpSIxUc6vuAsxOgmNvSHFglYK4ZPPfaKVhbz+/n9lW8Xl9aDN4C2Ki+ko6/7aaSVXci2rG1ooOIY3KINx/iutP/tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Saturday, October 17th, 2026 at 8:43 AM, Zhihao Cheng <chengzhihao1@huaw=
ei.com> wrote:

> Hi Nikolaos,
> I find a possible BUG_ON if this patch applied, details shown as:
>     P1                          P2
> prune_icache_sb
>   lock(lru->lock)
>   inode_lru_isolate
>    if (!mapping_empty(&inode->i_data))
>     unlock(lru->lock)
>     spin_lock(&inode->i_lock)
>     inode_state_set(inode, I_REFERENCED)
>     inode_unpin_lru_isolating
>     spin_unlock(&inode->i_lock)
>                           unlink
>                            iget_locked // find_inode_fast gets the inode
>                            iput
>                             iput_final
>                              drop =3D 1
>                              evict
>                               BUG_ON(inode_state_read_once(inode) !=3D
> (I_FREEING | I_CLEAR))  // inode state with I_REFERENCED
>=20
> Could that be possible?

Hi Zhihao,

Thanks for looking at this. I don't think that BUG_ON can trigger.

- The patch sets I_REFERENCED in the same i_lock section that clears
  I_LRU_ISOLATING, and evict() waits in inode_wait_for_lru_isolating()
  before calling ->evict_inode(), so the walker can only set the flag
  before the filesystem's eviction runs.

- clear_inode(), which every ->evict_inode() calls, sets i_state to
  I_FREEING | I_CLEAR.

- Evicting an inode that has I_REFERENCED set already happens.
  iput_final() sets it through __inode_lru_list_add(inode, true) when
  the inode is already on the LRU.

Did I miss a path that checks i_state before clear_inode()?

Thanks,
Nikolaos


