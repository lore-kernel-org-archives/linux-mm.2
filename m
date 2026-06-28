Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF841C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 04:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390FD6B0005; Sun, 28 Jun 2026 00:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31AE26B0088; Sun, 28 Jun 2026 00:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4A26B008A; Sun, 28 Jun 2026 00:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF2E66B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:30:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2ED25C18E6
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 04:30:36 +0000 (UTC)
X-FDA: 84928045272.13.E8632B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1998E40005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 04:30:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=c+7YCt5A;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782621034;
	b=zIdE1OXBcLV2k7zaaI5a4Z1oATcWxytyrBlXXFkUdJnPlKxrZgMH6999+RrsCc9d3kfWI5
	yhF/bHgwoh4YA5TSBHuEUy2WHmFVvIdtP/wYGi3+giznkEv6j9JREEvPbitzgGDRqBmMHz
	fW5TQV7uCMASeGkHt/gXPGJ84Xb8Re8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782621034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oqgHl0lkQFdVKyA6jHTymGbQizShIgDETRUXN0bbAlA=;
	b=Bv+EKlQKzS4tm4bwr1BdzKHtSyaTHJMlFOCI7ZTVzR2doK7YYU0hmqqIqG00D3mPXUBE/5
	X/yuo8RwBZzpEn65KO25qvavr62YNBXgbdCLr+d2KsDlPsChsMy5vpViKA4QzEiKYMRG/Y
	NitnG4sdnYV1WRggyTlrGjDMxeK9DUo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=c+7YCt5A;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 735DC601E0;
	Sun, 28 Jun 2026 04:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF7D1F000E9;
	Sun, 28 Jun 2026 04:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782621033;
	bh=oqgHl0lkQFdVKyA6jHTymGbQizShIgDETRUXN0bbAlA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=c+7YCt5ApKBi+stQPHGgQADZucP/8AX/bKW9Nq/uTFRDzhYV0XdUXwhHH25G0NDSd
	 +pn/ZHAQ6y/uer1MXI/qWUSaw+sAMAeo3zgyMO+4f3/VsXp4fpkuLaDok86YtMNOXK
	 ulnyZ8Ufz7j/k+2Tb+ab1Tvev51k8tax8LtmrrSw=
Date: Sat, 27 Jun 2026 21:30:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kairui Song
 <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui
 Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v6] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
Message-Id: <20260627213031.88e3bfb3489553afb1102399@linux-foundation.org>
In-Reply-To: <20260626020629.1042041-1-hui.zhu@linux.dev>
References: <20260626020629.1042041-1-hui.zhu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1998E40005
X-Rspam-User: 
X-Stat-Signature: 9oqjgq3csafc6pzcft5o44x39r8syas6
X-HE-Tag: 1782621033-845059
X-HE-Meta: U2FsdGVkX195xc5EX/cCSXt1wTZqlCQIUZoW00Uv4lht3WWIqLLFvrA2zQpgXxD6/pJcOIZnvbjGUe3kcoftZny8sDOYQAk64MINNX9V0Siqaz+g45SbgodQxjr3+ZM1wUTMcO4q7aX89r8qEyWKCvbUaErGSDhR/m2nb6xHBRexfkkG/mmCY/YeUnpHImsNK9aJZ691lJP5UxrueiUp1oKGVjDCbud8c3T5s1iFvp4uwdFVOS894sHYz09961bWV2nOYfgP0U25/12fj/NFldosIkQPkMYNx9vbhV7gHut4fFsXkSUPFBHKZCyIydTI/80YSdIb3COnx8Xm+kEt1TajaPUeDB959ygqj7aPz+tlbxibVroJMmLj7s5qZBPQXG8oIip1IOpohmDYGUO0hZ/4f6E+Dz13o7t5Q39gbSZVGcIAzXrF0cM+hs58dHxIpHI9POXFug3RjdVouX/vVPuKl0qty1Yct39JLSdbZLjXD5+Br+N3sBkLU4QaCmfv28qV05q4tC1Tst4KxS4r5gNb1AbMBIGqgnWHd3Bs0mRcNK94/6mnCIuHQ2D01J74ZlBTbRQ5uvuFngBm22mh0UlgciSI2G6k20WCnRkpRhQ4MzmhFa7TmmzQzqFEKz5eI6VFqXAAd/5v3pvJU6nsdHgkfiWv1D2IBVppHyNwSFTtBwAYaooKdGYnqwbfnsEy2HgdX07IpX/14d/WMIVV2QvpGypRDU9cjEz+kvGjDHc4w8ccI8Od/kH+WbqswCPfNrwQwcAk/UAA8ozi7XmNNAy3FM+d/ICP9BtEyAUkoa/VkTn+fSqWxhghPbWNXsaMFGWlhdqJph4+TuuCoeYUrIN6yt5c5n7IpFv2FTqA+zx5cTdhuzkltbU8ZVJIHKHYN9sCbzHlbCXx5IM4KL9cYdmcyKE311JnkJS0VckscYMzsDxI+nN5+u47cehGYl00iecCJE9sCPMXw6uhB9d
 SslzQdDg
 c47eAfEFm/HpkJ44IePAVUEp8ut5AjBdkYKVPCZac1H+tdY/ZdEdbxWvkwhZ3CqLpTZBCn7fGhz3JFYcy9EbVHyPtGP/9BeDHLCSAMx7l6+J47IunMe1pQn2gZfztj0ZvnEfj/qGCWPe+0YNgx321ZkKBNoTRxhID/ZJ9BJmYnLvnMjs7lojIJ0KUMVh13TmA5zplPA5tpukADfsRXcW5tbIHJAcC1LcJmt6LQastGw1+PorjYZHj64xgJbjZDxuENvfEiGo+fWodp0qwBi62NDMtuTDNstUtPVnxQtPEXKGjAXYA/LMJU/EG+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 10:06:29 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
> page->flags and folio_trylock()/folio_lock() concurrently doing
> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> 
>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> 
> The node id and zone id occupy fixed bit-ranges of page->flags that
> are set once at page init and never modified afterwards, so they can
> never overlap with the low PG_locked/PG_waiters bits touched by the
> folio lock path.
> 
> ASSERT_EXCLUSIVE_BITS(mdf.f, ...) inside memdesc_nid()/memdesc_zonenum()
> used to check a by-value copy of the flags word, not the actual shared
> page->flags/folio->flags being modified concurrently, so it didn't
> reliably assert anything about the real race.
> 
> For zonenum, move the assertion out of memdesc_zonenum() into
> page_zonenum() and folio_zonenum(), where flags is dereferenced
> directly from the page/folio.
> 
> For nid, turn memdesc_nid() into a macro instead, so the mdf argument
> is expanded as the caller's own flags expression
> (PF_POISONED_CHECK(page)->flags or folio->flags) rather than copied
> into a function parameter, letting ASSERT_EXCLUSIVE_BITS() check the
> real page->flags/folio->flags directly.
> 
> On CONFIG_NUMA=n, NODES_MASK is 0 and the old memdesc_nid() body
> folded to a constant, so page->flags/folio->flags was never actually
> read. ASSERT_EXCLUSIVE_BITS() is a real runtime check that can't be
> folded away, so doing it unconditionally would add a pointless read
> of page->flags/folio->flags and a check that can never fire. Keep
> page_to_nid()/folio_nid() as plain "return 0" static inline stubs
> under CONFIG_NUMA=n instead.
> 

Thanks for persisting with this.

ASSERT_EXCLUSIVE_BITS is defined in kcsan-checks.h and I'm not
immediately seeing a reliable route by which mm.h and mmzone.h get to
include that file.  I don't think kasan.h gives that to us,
surprisingly.

Unless I've missed it, we're presently getting kcsan-checks.h thanks to
good luck.  Let's not rely upon good luck ;)


Also, Sashiko is saying stuff again.  Does it look legitimate?
	https://sashiko.dev/#/patchset/20260626020629.1042041-1-hui.zhu@linux.dev


