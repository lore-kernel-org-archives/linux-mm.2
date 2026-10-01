Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C70ECA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 14:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35B56B0088; Thu,  1 Oct 2026 10:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D406B008A; Thu,  1 Oct 2026 10:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22DE6B0093; Thu,  1 Oct 2026 10:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C08ED6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:22:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50C3F16042E
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:22:43 +0000 (UTC)
X-FDA: 85274273406.22.8B2212F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A1CAA10000C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:22:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PF6tJ1/6";
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790864561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XyzcN1CM+Sjmv9yngzarkO66OZbEgOAmUF41sBp7ArQ=;
	b=ON3U3dUzLQjbzSmEZNwfhno3Rux/Cn9LZ+DyxE+j3O6T+5UfDa83s2Jyy+PgM9v6aBRNDI
	EnZJYvhuw8NfusFss7YldVRqR27H1sFpNvk8ehbPvFvfqL8G2wNJopCR77HLd66mPuzZjU
	MrZvC5Cl1V0/8wIzUU8icrQ/HAhV3Qc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PF6tJ1/6";
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790864561;
	b=4wtpVdFDBQjKrVB9TaUHROFd3tFIpHf4/K7D1PDf2B9d+ok+kLbTLYRaQxivANlnualaca
	xl7G7LJ6zQ+2IGJtOeFmlJ/05Ha2QuQkW9X5kLOjPI1ECjRsmhdBxjcorsaNhZA9xHIzfz
	bNgKZRthgjIhBxm+RaTs34wwdsxqulU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C54C36021D;
	Thu,  1 Oct 2026 14:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097D01F000FF;
	Thu,  1 Oct 2026 14:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790864560;
	bh=XyzcN1CM+Sjmv9yngzarkO66OZbEgOAmUF41sBp7ArQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PF6tJ1/6dSILGxm3+IyWR0RN4HSaLeM8UR1tkSW5GiMJL9wSnl8UJkwfBnLtPIG/G
	 KEyrAl9ILdbIS4kB+c94qGEEc98b4qzwETcKQw4GGF7Gui5kTXsYjzvuEOBXlcAaIj
	 7fbVrKkEQ0QAnabLPF8Mjm3azdjKzXJifsjdx/xTVxUcYP0qSs9BhXmy909MnZMjBq
	 ix9/T1fGhCMUFG2XhrM0DBfC03we1JTwgQrglpcnIAGa70CyFnzi+cj6ijADRCFb0x
	 0yQ5xjmptDDcfbyLYEXK50UInFq790oUX+gfF4wGThuyfMwIIYx49ZdN+r54JEjESi
	 RSySn/z792Q2A==
Date: Thu, 1 Oct 2026 15:22:38 +0100
From: Harry Yoo <harry@kernel.org>
To: Imre Kaloz <kaloz@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: sample slab_state once in kmem_cache_destroy()
Message-ID: <ar5pESlkEMqNsgxv@thinkstation>
References: <20260930195110.13296-1-kaloz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930195110.13296-1-kaloz@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1CAA10000C
X-Stat-Signature: ij8pp7tdqook1zr1aan1yokonfq9ibo8
X-Rspam-User: 
X-HE-Tag: 1790864561-261076
X-HE-Meta: U2FsdGVkX19aJzxSTircbd+ZCaP+xvkFIBkKU0uWQ6v+THbyPHQdF01ItWVtjKVwYKHKW1xooIQF36iTViTJLQ4ebWDvSa0Yc2cPHAnKg6SJnzxHnLwl9rpEVIbzIZQ0aHPjn8pXCg3n0XSPvFdKBh6kzjVRq7ziDLvC+UO4a6tFw4tZ1JLbnrSGromMENR5/VAcy/fdl1MaOOMZBse/5v/bVVOI4cgojWg9dWxs9n28YdJjcYAwpVleelzE2okS6LTQcA7yn0/5nHexW7Xly7SMRHYaSJzVBKEAvtcuUAPVv+MRpwMdBMUUJUQ5rU14QBLlW9NAJjA2h9wXWqF2PHcyMDj/QTysCCLnss3V54o/srUcnHvaBeorgEQ/12h9dkQgh8KJNs2toJ7XMrbjxj+WNpucQx8otF6I3p3k8ig92YOcdvV6ePWdaRiqL//EsHLOMuQznNejSFat4EvlDsxeTXuuKda+S30cgVsLS1d0QffN8GHLwDY3EztRdQ2u+0YDGdkhrkHuoVggtxSJGq0c8Ti0zbdELG2WUpM0lED7hHmIfs29QWvuEjpOfEBcyxo78mtFChTTRisTiqrB113oEpOCOi999lH2qm+e3CfWXxJGP1dBCUO9uA0B/nEqi90bInc0ROeGfqvot6NYFoXS4N3u99QXmb7k5tbJCdZpFEnGB/3qy+blXtKk6EkzJX61iG0q3br/eEB+te6ie0/JnVWl9joTHJPlNIjGH2hbfKFgOTJlmrd8DHkPPu8KSnz6X3BtvQSlEZccTEjV8rnCzlG0J8+xPugtdy0w+Ky1LmNrE3SuSiMpr+0IkAoz+DTbDQ+qTZ3+z1Oa+Pudw8Us+pFwzQSPRMGIN4uW5r6HjcBLDp6RjXQOPKzGQq/3UpLtyqV+J5R0XoXBNOiZdKA6mHYd4U3bTEEAEXzjuQYoBn1kBr0Mv7mfMCyv6drQGFUz1/GkPpXOZnGlU4A
 1G06nVb1
 f2ELsjr0F+7xFhfPUhf+Tta8EnciDpzSnRlh2eSaN6F34kBgt9g2Vdcl6UWX4X2JbigzHZOUKBtoc30cWT6WHbqp3P5KL6dDqAGQXiLhA31cQRjxbJrQ2lEMmGT/Chj7iZ5hOQ0JbwxT4f3Kizyv5zTJs7xCBvv3SmTLcqs/1iJXcMRHo6o3ZcmTBVlSk/xwFE9yByOlOXlZl3ZkPyMIPyzdcGrddvnshTC5Ub7/DBWN4XDxWBHekSHTdvR9l36NVpdzzlONMb+5xq2IfO94o9NIr4R9pcZ6CDvucKfQfoNSuYK/6krCBLGEQuwHXxrmMM634
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Imre,
Thanks for catching and fixing this!

On Wed, Sep 30, 2026 at 09:51:09PM +0200, Imre Kaloz wrote:
> kmem_cache_destroy() tests slab_state >= FULL for sysfs_slab_unlink()
> and again in kmem_cache_release() for sysfs_slab_release(), with the
> cache already off slab_caches in between. If slab_late_init() runs in
> that gap it sets slab_state to FULL but never calls sysfs_slab_add() for
> the unlinked cache, so kmem_cache_release() ends up in kobject_put() on
> a kobject that was never initialized:
> 
>   WARNING: lib/kobject.c:734 at kobject_put+0x64/0x2c0, CPU#1: kworker/u8:3/55
>   kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_put() is being called.
>   refcount_t: underflow; use-after-free.
>   kobject_put+0x64/0x2c0
>   sysfs_slab_release+0xc/0x20
>   kmem_cache_destroy+0x104/0x1e0
>   bioset_exit+0x13c/0x1e0
>   disk_release+0x54/0x140
>   put_disk+0x18/0x40
>   floppy_async_init+0xbec/0xd10
> 
> Seen on sparc64 at boot, where the asynchronous floppy init tears down
> its bio slab while the late initcalls are running.
> 
> Read slab_state once, under slab_mutex which slab_late_init() holds when
> it sets FULL, and use the result for both the unlink and the release.
> The kobject flags (state_initialized, state_in_sysfs) were considered as
> the key instead, but slab_state is what cache creation and
> slab_late_init() decide on.
> 
> debugfs_slab_release() is not part of the race: it only looks the cache
> up by name in the debugfs root and does nothing before that root exists.
> 
> Fixes: 4ec10268ed98 ("mm, slab: unlink slabinfo, sysfs and debugfs immediately")

Overall looks good to me, but could you please explain why it's
not relevant before this commit? pre-4ec10268 still reads slab_state
outside slab_mutex.

> Cc: stable@vger.kernel.org
> Signed-off-by: Imre Kaloz <kaloz@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

