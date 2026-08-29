Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75429C61DD3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 03:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64AAA6B008C; Fri, 28 Aug 2026 23:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC046B0092; Fri, 28 Aug 2026 23:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539BB6B0095; Fri, 28 Aug 2026 23:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37D1A6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:00:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAAA7160609
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:00:24 +0000 (UTC)
X-FDA: 85152803568.12.EDFBD8A
Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	by imf05.hostedemail.com (Postfix) with ESMTP id 75635100007
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:00:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eOTjjhS6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787972422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSfT4HxlRrI7sP8TUXtByEErhJL/3KY/pDWAsSpMXNM=;
	b=QBB8b+fdmtz7fUhhD9ps3UBuU0Ud2O/vC70OKpAPRUlG6dpVV8t0nlckfv67n85VHt6pmv
	YLFHRKaaBRWMwEO03KTYyhCBhj/QFWRmVIrEBaGO2gihvEc0GTcMMQzrVru9YWB5zytZba
	1ZoA8SaDOMeki4qF6AT4dXcZry0TkD8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eOTjjhS6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787972422;
	b=nNWYA1SV4xsYNboXvXlid9mLnjw9MMPKiFUynwmL8AxvpVug9VJKIlCpsVpebCgnBZgWXh
	Wl1aDF9PBX68X/EAXmsH9zHpybEFzNlNNe/5hPJHl3EBjbDyM4b36JU/c5mjIRg+0rXD0l
	LZocIstNsUMPPae2HARWIP9rvwg4CzM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NOrUlbKMwb9Hf9uRBB2hPgRlJDS6GE9m2ZXH7xMBtKY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787972421; v=1; x=1788577221;
 b=eOTjjhS6wsCNhxi0blFeQDYJdCdPq8UjX7L3CBRlvReGBr4Sl9QiEZbO2d9BhPBDPoW6R7B5
 IJUQrhowsf5aMfZFPYM2hdLBn8c/xj1rTJx1WZF0TGUmkXS3LMZkuX3djJrElreQ44eOqE43HN5
 FlPUG2DHjtlOP0kinXbFCw3w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id ce6ac9aa603e1006;
	Sat, 29 Aug 2026 03:00:18 +0000
X-Mizu-Trace-ID: ce6ac9aa603e1006
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] memcg: avoid charging the root memcg from
 obj_cgroup_charge_pages()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260829023251.474083-1-shakeel.butt@linux.dev>
Date: Sat, 29 Aug 2026 11:00:00 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Farhad Alemi <farhad.alemi@berkeley.edu>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <17E1B73A-F6CD-422D-B7C9-95EB581F0ED3@linux.dev>
References: <20260829023251.474083-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Stat-Signature: dirhrt1pahnif5zznu4zhh8rp6nxm463
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 75635100007
X-Rspam-User: 
X-HE-Tag: 1787972422-221315
X-HE-Meta: U2FsdGVkX186tUG6nPnh0RsVhlw8Tx7YRoNgYWZXnHcM4z6DCSIVckMX40U4jg3f4wK+mjpoHHgz2/C4f73IOLPNgn7W53k25pi3asnG37eEcC0ZT2Kwhe5oflpMZ4qQoMxKCRiZ4O2px9VQSc1qJgrQyHv1+t3LF+twXszaOrOxn7zM4Tc3aYfkKOxuU/B33UA6oWjZwKK2xnfx4EmwI7wmHU3XnttX2kN5F8N0rGnp2jIrUK+O6TRxHYX8DSuJ4+EpnuhSpCdlLG6w3b/p2Q9BCRz/R0PxFxKLEsVcajNae1oSaxinaqpXYL9ggGQlkybFnzgtDtfM9FAnPMgge9qECO9QGBQXvAy9h9AJxmVfNBmhMuUoyhOq1Si0dwtHr+ZYzOPxyLYFxvvwbKJAGjexO0J/zBR3n463hQdWyzDZOw4MdI0YCeyiSq33EAPkX7oCMz8y1h3DgEsjwYP/d6Yn0/WqEILdoTC/SmYTpNilrwz7ENcLxcA/xXa0Vf7SJscSnk5yfNYCm8MezZqSfbmu9E29ot40m4eXoYJ+T+vnLJkKTL5ZBxRvH8kX9haxJLJEgGm3urjpjKZUzGgC60L4EFkVEkfYO9mJQSlc/tpKWJBFDh3CbMFyw6J8N4tdt4WidDfX0+athvUFFwHqfSNQqcbGeKtxkVe2RqFlDT3WSIlG/c7NYz2rCgE/8i6zpVbjdqiTKwNFy2+UwlYQHi423+z7kW1HM0IrVndo2XNoDpDXdGUJoq9+w4jiIFI3aYlBElNVgSZ7fKq1XHmMKP7W/qHRp15tWTdrF0svV0gwlAfLsV11zmFZEdNGUqQSwnMlcrvwBP1yLpdc5jxKuwum1VbhAo6sh7TPLdL6ICLnc3dytw5XyXMSB8h0SmV4Xfqnka4xl5aRQ/hFniR97dxX2bmNESMIdOjh7aBxS/U2KikX08427yGnK+flDqqEq8lnX6gchjq6H9rqlVG
 2wCQuv9O
 JOlUPGNXnN7ERi7VgWc+ENaaE1g9IWWVk1PznG9ahUoX1nPvmrjUTqdLXCZCD43ZyWMG1ijUtGR4h8DbuHOABUyxHK44ft+khIr9Wilh0VTev4Cq46MCvxveIY9nmbMxvKIDWapzQubHAqwlYgyvNVOhC5EQYu1g0iRFne32aa7uioGeLxD83SaL65eCYRDTKAcqAJJ1FAjYUdbbncXazgVLnY16jhJ79Z8sTrdJByguS5eQVYWBgnvwpjuBTWB+08FXp9KmULJmKYeqO66O/ly+W+ADelWr0ZneAisc75hn0ajRLmbgZFexBesA2sIr/F+o+KgtobxAq8r50jkR8sDv68UlqRJKJophDgnr9TtDgE0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 29, 2026, at 10:32, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> obj_cgroup_charge_pages() resolves the objcg to its memcg and calls
> try_charge_memcg(), which does not short circuit the root memcg.  That
> memcg can be the root memcg: obj_cgroup_is_root() reflects the memcg =
the
> objcg was created for and is never updated, while =
memcg_reparent_objcgs()
> does redirect objcg->memcg to the parent on rmdir.  An objcg of a =
dying
> child of root therefore passes every obj_cgroup_is_root() filter but
> resolves to the root memcg.
>=20
> Folios keep the objcg they were charged with, so this is easy to reach
> through zswap: allocate anon memory in a cgroup, move the task out,
> remove the cgroup, then write to the root cgroup's memory.reclaim.  =
The
> reclaimed folios are charged through the reparented objcg and end up =
in
> refill_stock() with the root memcg:
>=20
>  WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940
>   refill_stock+0x644/0x940
>   try_charge_memcg+0x12d6/0x1570
>   __obj_cgroup_charge+0x35/0xf0
>   obj_cgroup_charge+0x1de/0x210
>   obj_cgroup_charge_zswap+0x83/0x270
>   zswap_store+0x1620/0x2000
>   swap_writeout+0x94c/0x14c0
>   shrink_folio_list+0x3388/0x52b0
>   [...]
>   try_to_free_mem_cgroup_pages+0x30d/0x830
>   user_proactive_reclaim+0x504/0x840
>   memory_reclaim+0x1f/0x30
>=20
> Beyond the warning, the charge is asymmetric: =
obj_cgroup_uncharge_pages()
> skips refill_stock() for the root memcg, so the root's page counter =
grows
> and is never uncharged.  It is not user visible, since memory.current =
is
> not exposed on the root, but it is a leak.
>=20
> Use try_charge(), which returns early for the root memcg, restoring =
the
> symmetry with obj_cgroup_uncharge_pages().
>=20
> The above sequence was scripted into a standalone reproducer (zswap =
on,
> swap on a virtio disk, 512MB of anon memory faulted in inside a child =
of
> the root cgroup, the task then migrated to the root cgroup, the child
> removed, followed by "echo 600M swappiness=3Dmax > memory.reclaim" on =
the
> root) and run in a CONFIG_DEBUG_VM=3Dy VM.  It reproduces the splat on =
the
> first zswap store of a reparented folio, with the same call chain as =
the
> report.  With this patch applied the splat is gone while the zswap =
store
> count over the run is unchanged, so the same path is still exercised.
> cgroup selftests test_zswap, test_kmem and test_memcontrol show no new
> failures.
>=20
> Fixes: 20d6c1725228 ("memcg: avoid refill_stock for root memcg")
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Closes: =
https://lore.kernel.org/all/CA+0ovCgWzUMK+nNbbtH7eV65Ca=3DfDN4Ozu7iASgryjv=
v8Tk8zQ@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

LGTM.

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


