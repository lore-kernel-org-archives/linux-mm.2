Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB37C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 07:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EEFB6B0093; Mon, 10 Aug 2026 03:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6F16B0095; Mon, 10 Aug 2026 03:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DCCF6B0096; Mon, 10 Aug 2026 03:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD9C6B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:58:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 103301C1588
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:58:32 +0000 (UTC)
X-FDA: 85084607664.10.4909F10
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id E6F64C0002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:58:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c4t+qkeF;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786348710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eXqpPmFg3NAwqefW6Q/q19TF5DPxz3Lme5BVQFRJrFQ=;
	b=vYII9tbjadovFcwy8QhydtKt/49QkeDZsCL0GW846mdRttFvCXEE4EVsMDkMWHTO5ac9JV
	7xmf2SI0zqgaPeYlY0p5eEW1rEI3uDIX1MfHyecHnIE8v5J9P4xEuzTEKXigIJNkFjbhVX
	UXIrrm9surPtMXtYMh7PNwUX2mLr6w4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c4t+qkeF;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786348710;
	b=KKynTAk/9H1mF+dUvS2Cizvn6v657I+iYf4nqKvFjHZTHLQKyvIOjaWkk7Vl0IFcN5SyBb
	KiHwHKxlKoWbMgKvLw868mR46huHvlxRKj7R1XtpH5mxaCKrn8YSQAECBxDUrks+Do6MzW
	q/ZffuHdlo1MFBm6DK4wydaCX2PiUmQ=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786348707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eXqpPmFg3NAwqefW6Q/q19TF5DPxz3Lme5BVQFRJrFQ=;
	b=c4t+qkeFJKO/1yXLiMbdEWCssRIOIcrOPElW099+wv7sX6aO4srSJ3FbT9mjc+joDKS+Ab
	G49Gpx2XnYxtUrTjqEQEZG82xw5N2mjeA25QjGxPiYdgD7HBJnSKEpmlWfVkkjyGvg8KBM
	5mvMDdShimSb30wXJ2s2BWtHv6dicYg=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/memcg: fix NULL nodeinfo[] dereference on late-onlined
 nodes
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260810-memcg-nodeinfo-null-guard-v1-1-77a73204d63a@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 15:58:09 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-arm-msm@vger.kernel.org,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5059A780-9C10-4171-A254-38944464F1AC@linux.dev>
References: <20260810-memcg-nodeinfo-null-guard-v1-1-77a73204d63a@oss.qualcomm.com>
To: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E6F64C0002
X-Stat-Signature: usb9tnqt7f6yapd945wu3qo9xxxu4ord
X-HE-Tag: 1786348709-513762
X-HE-Meta: U2FsdGVkX1/EpHkAK0mzEMeC5GrtIg8STcP+EuOnrciTTye13WlKx6C5qyfDqzCTu6QH+hYP67JkYDrs4d62FsB/HlRAKYTkDGBNMuewfpFKU03RTRFLkYp/C9i1cxAva7gtZWm7NJ+UyoHz7Sgb1/aGFxrlMaUnNlQiAhiyK3JpRiD3btwPjlMfxOABt+lU33Uu176AtT3OcPAbye3nv2eAeZCMk+Yyy/Dn53pE+NwQwuHAN81rwnWGcRA+CKSFwCsF+HaxIxvE5R1bWZKZryyj2Ch5tHiMMiyEniTOyTekoTN+T+XrU0L8I2JQ/Mk86SfPnoYL0q9k14lryr/T71hdImnAkhu+yA0BhnkJ80WUp0KcNYrank1KX+3MBP15lT3twzNC1v2nF8SesL7FvcBvqaWAB3mH9DwbWVGenBkU5iAecLPQvjxO7dQf1ENnAmde3TVmDooJsQ+8PguJElhazEoc2U+1RKwtH6Hb3pHmg7ak9ivvANV0NLO2jutQWbQ+XOceIfnKKOXG2Rfy8pPA3mrcqIZwimYWw2lwR8r8dVYKtd1f3jVyVQ+JE09+mrwMHM6t6+Nhbd0tDDKYNMpGT79i5A9oxoPWccNJYJi44/pD08RsBFd1nXkVj+52wc24+el7JP8sVRca+Z7/W/1fcHRk8CaIM9PsA+A9ytGcFEnMBvgsvTDj/HoXd66ccNH4DkVEBNbw7NVWFn2CJGmzfLySQFa0CIoG6mO6CFlF128BJ012bQJO43kTCPXUjkQYehP17WZ/lWz/6CoO6JWDysSrekhhYde6tOkx6CAaIC+n1W2aAMXYMe5WX8KY7aOEeWYFKmmhJPkyNW5MmKUxvaR083k5uTyuvv5Aamadjkn77B3aVcc3FMJpPVP90cyLf6b1MHQvhEfY72HrNYF++dl/Ov86spKJiE/Gh4czhJ6u1dd7h4kd7Mc9aflk+MBicH2dHMjJEE7/mPm
 WrM5rOxF
 BwSXLLqxQQgMRlPXXvAf6Ow6QbKt74bfNsCHmYQwpP+Dwl1fRaaLa7KcX84vrbVhn2gi/B6gl/qvSinQugaEgH3rtzU2J/y3sBwoTl2rcfIUfBzruAEfifJVfNEycA0ABVqOq5UDH7f/+e+/o4mqpSjUxaau4WDEcKAWT1cA+NgwpscnkOmuU866VMwImF0z+0zC52ZtCn1R46eUCIct2j2/NvF3pb8gL4kD5fQxbHOCuHSm6RU7gCP0II8AyXRlYd5z514uFjQoJK2BdNyxTAF6MhBDkQGXN0cHx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 10, 2026, at 13:46, Prakash Gupta =
<prakash.gupta@oss.qualcomm.com> wrote:
>=20
> memcg->nodeinfo[] entries are allocated only for nodes present at
> css_alloc time. When a node is onlined after a memcg is created its
> nodeinfo[] slot remains NULL. Two call sites dereference these slots
> unconditionally:

I don't think the premise of this patch is correct.

memcg->nodeinfo[] is not allocated only for nodes that are present or
online at css_alloc time. mem_cgroup_alloc() allocates per-node info =
with
for_each_node(), and for_each_node() iterates N_POSSIBLE nodes:

        for_each_node(node)
                alloc_mem_cgroup_per_node_info(memcg, node);

Memory hotplug also rejects memory being added to a node that is not in
node_possible_map. So a node that can be onlined later should already
have a nodeinfo[] entry for all existing memcgs.

If memcg->nodeinfo[nid] is NULL on your system, that looks like a
violation of this invariant, or possibly a downstream-specific change,
bad nid, allocation/lifetime issue, or memory corruption. I don't think
the generic explanation that "the node was onlined after the memcg was
created" is sufficient.

>=20
> lruvec_stat_mod_folio() calls mem_cgroup_lruvec() which reads
> memcg->nodeinfo[pgdat->node_id] without a NULL check. On a system
> where a node is onlined after the memcg is created, any folio stat
> update for that node crashes with a NULL pointer dereference:
>=20
>  Unable to handle kernel paging request at virtual address =
ffffffbebf7e1908
>  pc : lruvec_stat_mod_folio+0xf0/0x444   [6.18.21-android17-5]
>  lr : lruvec_stat_mod_folio+0x88/0x444
>  Call trace:
>   lruvec_stat_mod_folio+0xf0/0x444
>   folio_add_new_anon_rmap+0xac/0x2b8
>   do_wp_page+0x768/0xc80
>   handle_mm_fault+0x37c/0x8c4
>   do_page_fault+0x140/0xa1c
>   do_mem_abort+0x54/0x74
>   el0_da+0x48/0x8c
>   el0t_64_sync_handler+0x20/0x130
>   el0t_64_sync+0x1c4/0x1c8
>=20
> __invalidate_reclaim_iterators() iterates for_each_node() and reads
> from->nodeinfo[nid]->iter without checking for NULL. for_each_node()
> visits all possible nodes, so this is reachable whenever a node is
> onlined after the memcg was created.
>=20
> Fix lruvec_stat_mod_folio() by checking nodeinfo[pgdat->node_id]
> directly and falling back to mod_node_page_state() when NULL, =
mirroring
> the existing !memcg early-return path. The fallback must not go =
through
> mod_lruvec_state() since that calls mod_memcg_lruvec_state() which =
uses
> container_of() to recover the mem_cgroup_per_node from the lruvec
> pointer; passing &pgdat->__lruvec there produces a garbage pointer.
> When nodeinfo[nid] is NULL the memcg has no per-node accounting
> structure for that node, so node-level accounting is correct.
>=20
> Fix __invalidate_reclaim_iterators() by skipping NULL nodeinfo[] =
slots.
>=20
> Also switch lruvec_stat_mod_folio() to folio_memcg_check() which uses
> READ_ONCE() to safely read folio->memcg_data in an unlocked context.
>=20
> Fixes: 6c77b607ee26 ("mm: kill lock|unlock_page_memcg()")

The Fixes tag also seems odd. 6c77b607ee26 ("mm: kill
lock|unlock_page_memcg()") only removed/renamed the lock_page_memcg()
wrappers and does not appear to change nodeinfo[] allocation or memory
hotplug handling. Could you explain how that commit introduced the NULL
nodeinfo condition?

> Cc: stable@vger.kernel.org
> Assisted-by: pi:claude-sonnet-4-5

Given the Assisted-by tag, I assume some of the analysis may have been
tool-assisted. That's fine, but the author still needs to validate the
reasoning against the actual code before submission.

Did you confirm that the relevant allocation and hotplug paths were
manually checked against the affected tree? In particular, I wonder
whether this behavior depends on downstream changes around
mem_cgroup_alloc(), for_each_node(), node_possible_map setup, or memory
hotplug nid validation.

Muchun,
Thanks.=

