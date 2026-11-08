Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89EFC606A330
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 21:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kRYdX+Fg
Received: by kanga.kvack.org (Postfix)
	id 8B5BC6B05B0; Sun,  8 Nov 2026 16:48:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85FCA6B05B1; Sun,  8 Nov 2026 16:48:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E136B05B2; Sun,  8 Nov 2026 16:48:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48E896B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 16:48:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D2D71404F2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:48:41 +0000 (UTC)
X-FDA: 85413291642.11.9DFBAC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9E77D40003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:48:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kRYdX+Fg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794174519;
	b=BZrZCotQZWlaCtM+wf0e/gUXw2wwSFTMKYolEvMjo9FTHr27GwUzOTxy9Q3AkmFkOQrD36
	ByC6HOyJI5YxJNs1LueBxySKxozGKaDzabSNVBabKqiMzRoWvqSKdr6nrnoxzcbYUax1M3
	IjBHCWUwRZM7QpY6PHA7+N4UA/gwb6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794174519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZdZQVw9H6aXCI8eUM5Z1MxH6OVioYDlzBV87SdVf/c=;
	b=vEiWDuDjnvrlDqmkhYAfNSXiQ3l28LMTfphsFBLNt2raqwFZHj96pD1IN+l0KDESNYuN93
	k7Y76Atv5L0k+9CPfP8IueJfnqS0mBFMmvjRrF8HW7s+oKE94S/V0+jg2jytO76o4ODtxh
	hApFT+yDiZ8n+Pphga8afC8hFacK1jE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kRYdX+Fg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6951A44FAC
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C281F008A1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794174518;
	bh=FZdZQVw9H6aXCI8eUM5Z1MxH6OVioYDlzBV87SdVf/c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kRYdX+FgnrfWfwq4zSef48iAjL9kKWWlKWo0WRVbSg+DHmb6j+3v//k903IN2UrJw
	 CeINfX5avdiI4SW61y5jMTCesyFd6yKXpfkxW4VwIE390AVMNiD3e6wpu5y7GDuuuf
	 02n7FSKKbQMsmZzQsUKVOvA7ExDzXelD6RD7hnZIlwG+0EU4j5v1cG0JyPol12rQK+
	 zayUdQPQdEEsRE49H688l3HfqGfE8jPagljqH0aErPuN8BdgGm5KbYhLkI1VVSXy8A
	 l0U5OyWJ8M2FEPFGUsniQSK0wDqWq7RzEj2ZTlHiYCM8iagwAv5P6vmyd1h+eSR2Pv
	 LXDYEry8yHhNQ==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93e63ee7b4cso24280785a.2
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 13:48:38 -0800 (PST)
X-Gm-Message-State: APuU4Z+5Dm5OMdNWZ79giWaOpn40hUQ41CXiFk3aJLI3IRje1bHgjApo
	xJY8YnJdkuSHXB1w85VcOhygMxHJpn3AvdffAey+cNLNsMTp3iaZ1Ei4bBPbXancSPPZfYpow+l
	US5tvuC7tu0onkZSLJ8T/x2qA60vymHg=
X-Received: by 2002:a05:620a:838d:b0:93f:568d:ebbf with SMTP id
 af79cd13be357-947847989dcmr307877085a.75.1794174517262; Sun, 08 Nov 2026
 13:48:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com> <20261016-mglru-fg-v4-15-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-15-2106750c0bfa@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 9 Nov 2026 05:48:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wTFHJxzuiRDBcuevdULMcD+se6SuPbzWKA8wsUAG80_w@mail.gmail.com>
X-Gm-Features: AclHuK-s7JbtIEWTZGMVhiT12ls0SfPHfw3O0hQ9GXy9byf5WRAn6-BR9O_AjyE
Message-ID: <CAGsJ_4wTFHJxzuiRDBcuevdULMcD+se6SuPbzWKA8wsUAG80_w@mail.gmail.com>
Subject: Re: [PATCH v4 15/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
To: kasong@tencent.com
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9E77D40003
X-Rspamd-Server: rspam12
X-Stat-Signature: 7wzmpi5xf7mrpf3q4str66ryk9ua7cjo
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794174519-194751
X-HE-Meta: U2FsdGVkX19kd1BjZsday7KbWxpg0hkzX4yT0Z3xAkODfuRz3DSiAnGQxhD8rVptAXwCzIXR8Pg5CpfeXrdVNH1wtb9nijMyScrEBdsh+qBIT7gVM5IOkGlizL/rAbcTgbOPvxk0xdJ6L1xxnQqIr+J3jyE5c5PyNe0hAVdFChjl2kIm7MlcBepZUqYEO/pDzWIpasSiWG7CD29E0r6qJGYrZEfSzhYhE/pfkY+bD12egZiSvKweLNXAwBE94uvtiXgvp4G51JOjj8dxyzimcIUxK5lXCfqIFB6wqv8dzEcrHtT6s3j9f34Hw3Az9MaMsTNAjFH3+A5Z/C68CU25Nel2ZZXq7BsUjYKfsQzCOu4puAfhLwGHtzAT4ZYtEXEcCIMeNpsIlcvJ3evcskoengIKIy+TRfg92Tke2cGGWQprhkrfZsOu7A6BllDcOD+jZQmzViTxxSYCpXN3z4Dr1DKV+6oU9L87XU35Xi33/Ggh9qhG6huaLXDYYh4aOnPR0Y3Ei36kYSX8XYWUgsD5cBmkuX8HELxiX0TeQ1Uwv72i8MW5TKix8d8m4Dwr7GVk7fdBbfQKGpqhepWjZSnAriPjDwn0D4xuVRnjG+vzD6UgRLgzUbW06inZdNmy2VxqpThDOes28lztJTmmBKm5plTiWsscbbsGGXvduokDUxX95UKJSqqVEwJePY1TCUSciWbbRFYWU74wfrabFd7q7thyXUUibeOqEEw5mkvlzF6YTC4ZncFEnSDB//pIDquSNzLVwdMVEvGtCAyuDRsd2e/xbVAsCTK8JyfZPkwdzm6ais7MQREJUKy5InVTTtF9ehU9YmF6Pzc0uyb81FNOTQNPxlBCSYAcurNoOkhtz1zmOITALGcii+OSC6Cx+d2xpSRTE1kGN/iqmribe1gdhkBzHtfhNahdjueRQygNyUpLXc+ewO8f1S0TtEl+hcWykVmnFvqDbgtJjaaZsgQ
 GyLt244z
 V0KGYJ8QNyzVD/qj8tlsExupIuyJMDBWtPQ1ieIgbU9BbFhXTuPBETsIZ6mpYoJk3KUktxwWh13f2jPcLTyD4NHO5r1NuLIb9bZgkcQCSe14OADjsPLz8H9L6k6XoBH9DgoTmbg+CghUbRVhR7Yh65eXMjbZUipQcMRIRHXLnCOYvi/vsi21z0I8kyUyWC6qeqBZOMVmbrOqtRm4eyaukz/OSGKnVVnq3i6OBHjOmnC2JH2jnmhJjhma6zQtmN2lTixXMV/jtM+Rz81k+BOQN2MWwB8WUPDVVUuTdlUnQK4qk+tYDanq9beEpvphracowkDu2++mWKIeiuq4DS3/fF7OmZ8IDHh7WJB+7JVtwX9UCSTkM5qHMUg7VZqtdn3gRhZMlPk8SerMzJkT1VrWu8YN/ddqJ1AKB1hhyTyGn/FHZk+ScO3Ox0OVwtDi6ViwdXmoDbJBGdvoGzRYkLTjS9ZzB8f5lzjJGq3I1rgp6F2+C+dSNrF4lFwVu08T05qtfUdXAF9vbvPH9BZO2iBs5xtSSQvazfJiV1JUQSZCIROE3yAuTmO96C1+66A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 2:16=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> concurrent aging from corrupting the size counters.  This is no
> longer needed: the per-generation counters are atomic, and the
> active/inactive ABI counters are updated per folio and linearized by
> the CAS on the folio flags, so concurrent aging can no longer corrupt
> them.  The same argument already allowed folio_reset_lru_refs() to
> drop the lock.
>
> Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> read lock around the lruvec lookup, and drop the spinlock entirely.
>

Yes, this is cool. We have two paths calling
folio_inc_lru_refs() or folio_inc_lru_refs_walk().

1. folio_mark_accessed() from syscall access
2. walk_update_folio() from page table walker or look_around

For the latter, we can't actually cross multiple
lruvecs/memcgs, because of get_pfn_folio() as shown
below:

static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *me=
mcg,
                                   struct pglist_data *pgdat)
{
        ...
        rcu_read_lock();
        if (folio_memcg(folio) !=3D memcg)
                folio =3D NULL;
        rcu_read_unlock();
        ...
}

Consider a common library file used by 100 memcgs, with
its folio residing in the root memcg.

When walking the 99 non-root memcgs, even if the folio
has been accessed, we won't get a chance to call
folio_inc_lru_refs_walk() for it. As a result, this folio
may eventually reach the eviction rmap path. With a high
mapcount, folio_referenced() could become quite
expensive.

That's what I was trying to point out here as well:

https://lore.kernel.org/linux-mm/20261102213915.57805-1-baohua@kernel.org/#=
t

For the former, you can get the lruvec with:

lruvec =3D lruvec_live_lock_irq(folio_lruvec(folio));

I'm wondering whether we could eventually unify them
so that both support cross-memcg inc_refs.

This isn't a blocker for the patch, just something I've
been thinking about.

> Without the lock, aging can advance max_seq while a promotion is in
> flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
> flags can return to the value read earlier and the cmpxchg succeeds
> with a target gen computed from a stale max_seq.  Recheck max_seq after
> a gen-changing cmpxchg: if it moved, account the committed update and
> retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
> The retry may count the access twice, which is acceptable and avoids
> folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
> orders the flags read, including the one returned by a failed
> cmpxchg(), before the max_seq read.
>
> Also simplify the post-CAS accounting guards: gen is only assigned
> non-negative values after the old_gen < 0 early exit, so gen !=3D old_gen
> implies gen >=3D 0, and lru_gen_update_size() needs no explicit guard.
> The active/inactive ABI update keeps its gen >=3D 0 check because an
> off-LRU folio has no lruvec to update.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Thanks,
Barry

