Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B4F5CCF2DF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 06:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0FB6B0156; Mon, 19 Oct 2026 02:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659E76B0157; Mon, 19 Oct 2026 02:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5703C6B0158; Mon, 19 Oct 2026 02:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2ADAF6B0156
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:58:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6CDC1A0677
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:58:53 +0000 (UTC)
X-FDA: 85338473346.07.D8C77E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 091B5180003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:58:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ogMA/RRi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792393132;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJlqgxp41eAYYigFtpNAqy8U/Byaa9W5YO4I3+RNMyc=;
	b=U6xo9glQ269F/bolt7ZMaBCCSJWFP1FNlCJh58i66D7w/9Oz0t/6JqOVbYHK/EFOUqoIcP
	nnA4j4p7n9c+es8sKCUIpx2HDzYqsq0kK6vrAqnIy6+B0ed7B/MD9b16TSQwFG9OyDlIyz
	DznmK2bdJJajzxD7HTXBd62zB/3E8B8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792393132;
	b=YUG2MEQNwgTdLrQGd2LKquqh/ShUt+HnzyVsPwXm8P+bgxv3LkPaenFFSc0MKbVSIHVRwM
	9RhpCW3cLo0tv5NTIez/jWANXHNbIYf5AHhqLr+KSEQHaHXvGHVhR9tE6G4YFnJXP8vMjf
	o5WQ94tEWBoYpPv6TwOkb1iOy8uIvp4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ogMA/RRi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6865543A63;
	Mon, 19 Oct 2026 06:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265E51F000C4;
	Mon, 19 Oct 2026 06:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792393130;
	bh=aJlqgxp41eAYYigFtpNAqy8U/Byaa9W5YO4I3+RNMyc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ogMA/RRijFq2qd3pavq5UwIVnN9FHzMkCa6FNXL18Ov8QEIwg1SMOQ3kjCPWGOu2C
	 WEZhy+uHqhFSfQeKXsRoASsHXR4bSQeZF2VzGFqY+5nMBQEeAhUmE6oYdoeJrniwXS
	 Z6zR8oYlR5M/i4z8zsydovatS5TGjAUMHe8eoshN7Los1G3EzPJL//Dp1KyG8wPxCn
	 jJEHYrCksZTMH+bqK73FWGDWb0KaYcd0WvITihAp7xy1hSpuoneFop9tlbUdqSazGV
	 xMFQbx5c+R7q4KBuQXHmW2eRS1YGULWfpwJi/RNsTIIRGIaAU0eAE+G90ae29pv1es
	 EZF9A3f+JhcIw==
Message-ID: <sashiko-outbox-176727@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 bpf-next 4/5] sched: add BPF-based per-cgroup
 NUMA balancing mode selection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yafang Shao" <laoar.shao@gmail.com>, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, tim.c.chen@linux.intel.com, lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261019064157.29885-5-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
 <20261019064157.29885-5-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 06:58:48 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 091B5180003
X-Stat-Signature: 6af8sqcdjkqkf6h33imgmcrbnfr1br9z
X-Rspam-User: 
X-HE-Tag: 1792393131-443994
X-HE-Meta: U2FsdGVkX1/b8dau85rRSDs2gLlSoK+w7LTIVahmKoe5g8Fad4MmiqrEnwx2PsO4ZINnO2ogtlZZ0lwF+nHNkJP54fr/dyrsC/7fp4ZrAURXyJ7+eOfBz0nnA3paVwgcS8VFlOWknKEYXodyIp3o3Awexz/MzRRT/KU50qrSG7m4Ns3E9httKve+/Nn8jZLB7KAcmBw2IZLUnWfJvGTegh8HXKiDeuddHjIX9SbtJVnKaXVdm0r7qWdsp+WjcOpWMPXoDZjpauaw1VkHAsfd+BGDVFVNRHPrcZnV3oNvIaKFLJH1KqgTqjfCuIXcpgbdq4k5oy+Dlicsk14Uls+yNtX9bUC84s/KtX1r0ICewHEQ5wspJYQtAsr4tDfTxsyu++Ij/J3iMAJUd1VvuO7vQEiFPcvoDoqehWqQ1N+seT3vOWmdDDMZOAU5viCBrUKq+Sy6Ea3c6Hi4i/SVd8t/NIktom+p4oNB1gVl8ZZewVFC/N5yRyMLbCopZ5A8fxDlXiOWWRCleYgYBpakyFisWzSyUrxeC74G4yzAauHw18iIvXb7FyHOJqJawP/g7XocVFmoi4+nVmohNDWvlw8iwe6X/ZzQoVYBomCExfojUzZcpfVVf2HNRAp6/M7HmajvDwha/YA9qFBuPTdLvARrfNQTFhOfGLMmerfRP3f3L0JhAY3JSl+jtpZWzmc11TwJLOe6J+6C/5dXaD/OaLLitLb3125YNu7KsZtlY09Eh0WWGnRd9H9x1CBS8FmeKPu5zQbgoulym4nEAwsto9H/b9+TnjHye6qnMqNOkERwiQ27b6LFDGtG+KVmnOUyioPId4KCJ5HrijuEWwiN46QdWwZnbICieLMzFxppvVDflvA4bR/vBoGXJCJjhpq++8dv0QF/HaE13Bfqg71YGjRuOP08zCnI4thyaiD2u8NypLuu1IupQpv6YikwPkCgTDJIUDNP+rgQtaimjgp1NmD
 Q19Ga8t3
 Y0bHYbD/YNVgWWts6DoUg6Ebjk2+bB/Sf1NIszEJ3cdAL0OpTxKSJPWQYCjUopp/wpO/jmfB6076EdXZvH6ytmvq4Yzn+cCXREmmq53GafqDXyWvPPaEfI0VNnfFYslmfqv1e8o1qCZ5w4uhJElt3g/Sq8BqEEHi+oLh1ohLo4C1einbprY2dIlVj/ALa4fN7LQpN6KG6nU0sT1m/khzIhdWB+v7I2itAHDOj93Zy/O8hO1IEVad8Yl1XDUoBxBDUKvSnuHSgI5F/UFbMge1hLtspuKNazcNYAJmRZImY6UXrTzr5EiNc6WWt/i4xw0aI+7uUsQptccPv62uj8kb3+7+UHGTB4ScNkW85VcusM0Z9RBbFo5tOIAHP5xkdk8HtX0UUn4PtRhE0r8OZJ5EasT0cXHdNWKGo2LuR37rQDrqtNN/RF6MojblCbgt1GrhQ3Ff7U0RbZA+vGFkp9jLDikq76BMZsa7VVlsL9pzYctUwUWW8rpsifsGh7PwJyAx5LMRDrhWfd/yqFkKxmPmqr59XVeciJlMbbsrFYLlxCi2/oHZP3eBilxW/kOzPirzsK0G2CxwPCY7UJTmPZBttQ1cYkUdajBvIitZevwqQQs5fkvzhUNr1vux8wjr3S/04BRt9ComcESDSODkfcIIOCOqr0ZtggA3YvK4P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] mm: use-after-free on source folio in migrate_misplaced_folio()
--

commit 5de3ed8c82d3030544f5f025b8ae47dd8339bfeb
Author: Yafang Shao <laoar.shao@gmail.com>

sched: add BPF-based per-cgroup NUMA balancing mode selection

This commit introduces per-cgroup NUMA balancing mode selection managed via
the bpf_numab_set_mode() and bpf_numab_get_mode() kfuncs. Hot paths combine
requests along the task or folio's memcg cgroup hierarchy behind the
numab_cgroup_mode_set static key to override the global sysctl setting.

> diff --git a/mm/migrate.c b/mm/migrate.c
> index 211c29bd2a283..c0692c7b27467 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c

[ ... ]

> @@ -2770,7 +2770,7 @@ int migrate_misplaced_folio(struct folio *folio, in=
t node)
>  	if (nr_succeeded) {
>  		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
>  		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
> -		if ((numab_in_tiering_mode())
> +		if (folio_numab_in_tiering_mode(folio)
>  		    && !node_is_toptier(folio_nid(folio))
>  		    && node_is_toptier(node))
>  			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);

[Severity: Critical]
Has the source folio already been uncharged and freed by the time
migrate_misplaced_folio() calls folio_numab_in_tiering_mode(folio) here?

Before calling migrate_pages(), migrate_misplaced_folio() snapshots the
folio's memcg because migration transfers the charge and releases the
isolation reference on the source folio:

migrate_misplaced_folio()
  memcg =3D get_mem_cgroup_from_folio(folio);
  migrate_pages()
    migrate_pages_batch()
      migrate_folios_move()
        migrate_folio_move()
          move_to_new_folio()
            folio_migrate_flags()
              mem_cgroup_migrate()
                old->memcg_data =3D 0;
          migrate_folio_done()
            folio_put(src);

When nr_succeeded is non-zero, calling folio_numab_in_tiering_mode(folio) ->
folio_numab_mode(folio) -> folio_memcg(folio) -> folio_objcg(folio) reads
folio->memcg_data on the freed source folio:

static inline struct obj_cgroup *folio_objcg(const struct folio *folio)
{
	unsigned long memcg_data =3D folio->memcg_data;

	VM_BUG_ON_FOLIO(folio_test_slab(folio), folio);
	VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_OBJEXTS, folio);

	return (struct obj_cgroup *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
}

If the freed page has not been reallocated yet, folio->memcg_data is 0, so
folio_memcg(folio) returns NULL and folio_numab_mode(folio) falls back to
NUMAB_FOLLOW_SYSTEM rather than using the owner cgroup's tiering mode for
PGPROMOTE_SUCCESS accounting.

If another CPU reallocates the freed page before this check runs (for examp=
le
as a slab page setting PG_slab and MEMCG_DATA_OBJEXTS, or as a compound tail
page), can folio_objcg(folio) trigger VM_BUG_ON_FOLIO() or dereference a
slabobj_ext pointer as a struct obj_cgroup *?

Would it make sense to evaluate folio_numab_in_tiering_mode(folio) before
migrate_pages(), or derive the mode from the already-pinned memcg pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019064157.2988=
5-1-laoar.shao@gmail.com?part=3D4

