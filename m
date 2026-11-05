Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79978606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 23:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=df5V8P0J
Received: by kanga.kvack.org (Postfix)
	id 617816B05B0; Thu,  5 Nov 2026 18:31:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C90A6B05B1; Thu,  5 Nov 2026 18:31:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6736B05B2; Thu,  5 Nov 2026 18:31:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 209836B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:31:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A08F4095C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:31:11 +0000 (UTC)
X-FDA: 85402663542.01.5AEFB1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id BA34C1C000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:31:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=df5V8P0J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793921469;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9MkJEZF+tfBcw5o3Zip2FagoDoxTunna3gdku9LHgc=;
	b=S6X03ZmosiGSKqTVRkIZNmuciFbZUKCEBzMsw74P3DIEEU7BEMpuJe02ATdRSbuuW6XAIq
	GRUq2KGuI6eE86ZqY+HlvDnRfLMSPqGOvdx1feFSNoflOfI2m4VvbfP6sTts6r5RG1KpAW
	LyaArwGqTI3uGqCRZQXUYOynZCxvWUg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=df5V8P0J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793921469;
	b=oeyV/ppc9gst/iEvr7hBoYZxMlJLV29oL2khVkKNe9eWixNxuWFE/iLISJMDZ7GhnhpxAh
	mSCsaa09tnTbizzJkOMCpUKAM8QiHYLImFpNAlvteyFaP3CEVlpsNcrbZ0iZ2BSjbSNKwk
	ial+C3FEve5mYIdsEbwyDwANmorOmt8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00695600C8;
	Thu,  5 Nov 2026 23:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D061F0089F;
	Thu,  5 Nov 2026 23:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793921468;
	bh=D9MkJEZF+tfBcw5o3Zip2FagoDoxTunna3gdku9LHgc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=df5V8P0JG9bl1U+vO7BhcUYwiLQN1PW3+gFIQGmLVno5f7mQ1NJ06OK3ysGkJjOkF
	 +Vl9DWE/nX2bnXJypuS0UP7qQlVDnISmXxTUU9kbAuNJPtfSWgVCuCXCZQ/0+CIFaT
	 lvrlO/sFhrFxJUcDHG0zli/5y8cDrt9YP3t4coRecA+MUcGdv1rtWj1Gv7TK/hzAW/
	 I4xlFouBxpvHUviSYiM+qeZrLZP/pLwlhLb+RDLFmOamatCnoEtXx4gLzhL24tyX9G
	 U+N4//RAIFqsZSvUz2esir3VBvy0FwFYUkZa8HMytNplznHfLD2SIB/rTcM43aRtMa
	 Ko+O3TUsFW1fQ==
Message-ID: <sashiko-outbox-200379@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 7/7] mm/memcontrol: restrict memory stock to leaf
 cgroups on v2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Michal Hocko" <mhocko@kernel.org>,
 =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>
Cc: "Roman Gushchin" <roman.gushchin@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Kuniyuki Iwashima" <kuniyu@google.com>, "Harry
 Yoo" <harry@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Maarten Lankhorst" <dev@lankhorst.se>, "Maxime
 Ripard" <mripard@kernel.org>, "Natalie Vock" <nat@pixelcluster.dev>, "Tejun
 Heo" <tj@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261104233029.3282438-8-joshua.hahnjy@gmail.com>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
 <20261104233029.3282438-8-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 23:31:05 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA34C1C000B
X-Stat-Signature: kmyqnytt1gzuafubs9erzpswjrj5tm4n
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793921469-389552
X-HE-Meta: U2FsdGVkX1/Hf02MxTNWQVPUlizCqU6HqhmbbYuWmYUoqV4+CF2ehJZkHK62e8rSdcfJIQ1zq8GmgiWzGUjqRH4PGMoHaINnCVfSGT4K1I3jXBHZmy3AKzLWwY92cTQcD6Fj0rdrRK4rgmiB/Rf1OR0xjmz6HJhiqIB2L/JcYwowV1Vi3KBfs0oSEdXsuWwQBCfZxUhrn3FaZYH/h2utCXokNnZbYgXdqeUlzpApNHAlKbnf0NM2905heZTi1BTWwpu+rnrp17QlqAzRELpcu4H9T1NTdUoPOBlkN7zStBJ6KqyccT2vZ7lA1Md/kchxrl4K3Y1woKRX9lXKNtSF5Rc8ux7dQBXwu3OCGjlQIEyDENkXB/bI2U6aePzNp4RTJB6PqpCM1ZB5X1dzAbUaYIFu94gJAzlF4NnCnhqflOckhbvNOghnEJUCp302ilKAcig3pwTrv03DF+4x1njZBL0TOBMQBK7q6SkH4yTtSgN0SiEq9Tt4Tdz50iFm0p4iIH8pDuHymfbh5UmueSeFm6usafZJeDaCChdIuiL2YQbHt96TK5031RLimOxXOWqBeB5pgQbGDHhcioJzNiQKFnI5YzUq0Jzz3JRvqRwxiyonMU9xdFJKSuEkXd2S1rowaJwjt7HTcGbcrc6qtlWcodBAgiRj0DgtaqwVouD6gQwPWt9taJIzcpklCDPb+kWq7IY12UXhm7jBZaG9rIYWhZqe/8mdi8dhFuXV8FqMszgBmaFweq+hhR65M0tVSpQZkOj7M74iUBbVkx1gGqHyiARg3LsTkisvpKdOLZvGXaPw99AEmHCAuaC5DkaecNIFnh3Nrq9VREhbMAlCTu8RDzdBXJiJaboEplbpQNwjjdRkPAbtE+PM/XKWwWFkuWoxRMZOpDG+lw863twmtW2gCuLviXLuZX797sZElTAl/Ayg+C3zGOa2CpxQ3f/wsumPNAW8FptUFrb9BVseyiN
 d5ioEj+7
 WaebA2gDXC4PHFwLz0SaHdmB+thmlPiolT9DgTpZOLtIaF+krH4lbzyRsIYJuzzC4MCKFrUsA+Qu0+5ygHC1gis0ZMPne686pdySGpeyesQyB6bNXM3zoMRP4mkZhcZktVm0xluU22a7Gn2LVYVVnBKgczttUPbMPLRbL7mfdFMAjaJQwy6IvZvITFtlPwjl8Ce5tCzXiyI+eblyxQQ78hYj0WCjwaazhNQ/IywiOf2vCl3cyp7ZK8edZQcy87my7wssawY91lepbBKZG8a+YR1nlV+/OlkcDmI1P6cCKH15MaxLFuKzev/7BZGmw5OVJxm1Y0TmzCIRzuVb4eZ3IjCeT8cXo4mec41zpiZjn8lnV2Pq4LEoXGQQJzwx5ErtDd6vrxJLBWOB3gtPYEODvqs515VmUQk4PrLkxWa60bKkWmo4e+MmiP+IyhKrHgnBtfya9uQPbUM96d9VMFJocZtbXwZSgdhI7zNJ66xTuH+HAUobjHpo3WKSgBvFNZpTOs60mnRB6GX/It91twoYgKg96St1gE1AmXQS/jbtEeLNnLtwFk/zysMeVR6MPGhf1hE9z/l1h2CLdkVxzygNXsWtRo/1EbtyJnBslNS2lSao/HgRGG9DJctbU8Tft8Nz0Vy/VrUsySIqQ4EfWItg6ZPIcr7Y/3by4Ld6h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: foreign slot drain on fast path in page_counter_consume_stock()
--

commit 4a3e7ea8b6bee1d8310dd3c42d8ad7c15aae3cf4
Author: Joshua Hahn <joshua.hahnjy@gmail.com>

mm/memcontrol: restrict memory stock to leaf cgroups on v2

This commit disables memory page_counter stock on cgroup v2 non-leaf cgroups
when they gain a child, schedules per-CPU stock drains for online CPUs, and
lazily drains any remaining disabled cached counters during stock consumpti=
on.
When a parent cgroup becomes a leaf again on child offlining, its memory st=
ock
is re-enabled.

> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index e1feb2bd1e225..7a3b7cea0ff94 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -158,6 +158,7 @@ static void page_counter_drain_stock(struct page_coun=
ter_stock_pcp *stock,
>   * Consume the cached charge if enough nr_pages are present, otherwise r=
eturn
>   * failure. Also return failure for charge requests larger than
>   * PAGE_COUNTER_STOCK_BATCH or if the local lock is already taken.
> + * Drain disabled cached counters while looking up the requested counter.
>   */
>  static bool page_counter_consume_stock(struct page_counter *counter,
>  				       unsigned long nr_pages)
> @@ -176,12 +177,17 @@ static bool page_counter_consume_stock(struct page_=
counter *counter,
>  	for (i =3D 0; i < NR_PAGE_COUNTER_STOCK; i++) {
>  		struct page_counter *cached =3D pcp_stock->cached[i];
> =20
> +		/* Drain any stock that is disabled but hasn't drained yet */
> +		if (cached && !READ_ONCE(cached->stock)) {
> +			page_counter_drain_stock(pcp_stock, i);
> +			continue;
> +		}
>  		if (counter !=3D cached)
>  			continue;

[Severity: High]
Can draining an unrelated disabled slot in page_counter_consume_stock()
acquire spinning locks from an NMI or alloc_pages_nolock() context, and also
add foreign cacheline loads to every fast-path stock hit?

In mm/memcontrol.c:try_charge_memcg(), may_batch is set to false when
!gfpflags_allow_spinning(gfp_mask) so that charges from non-spinning contex=
ts
such as alloc_pages_nolock(__GFP_ACCOUNT, ...) do not evict other stock slo=
ts
or take spinning locks:

mm/memcontrol.c:try_charge_memcg() {
	bool allow_spinning =3D gfpflags_allow_spinning(gfp_mask);
	/* Charges from reclaim or non-spinning contexts don't batch. */
	bool may_batch =3D allow_spinning && !(current->flags & PF_MEMALLOC);
}

However, mm/page_counter.c:page_counter_try_charge() calls
page_counter_consume_stock() unconditionally before checking may_batch:

mm/page_counter.c:page_counter_try_charge() {
retry:
	if (page_counter_consume_stock(counter, nr_pages)) {
		if (nr_charged)
			*nr_charged =3D 0;
		return true;
	}
}

For the counter being charged (counter =3D=3D cached), the caller holds an =
active
CSS reference, so css_put(counter->stock_css) when depleting the matching s=
lot
cannot drop the final CSS reference.

For an unrelated counter in pcp_stock->cached[i] (cached !=3D counter) whose
stock was disabled via mem_cgroup_disable_stock(), the charging caller holds
no reference to cached->stock_css. If that cgroup and its child were
subsequently removed while its per-CPU stock slot remained populated (for
example on an isolated CPU where schedule_drain_work() returns false, or
after a racing refill or contended mutex_trylock(&percpu_charge_mutex) in
drain_all_stock()), pcp_stock->cached[i] can hold the final reference to a
dying CSS after css_killed_work_fn() completes.

If an NMI or non-spinning caller on that CPU then runs:

  alloc_pages_nolock(__GFP_ACCOUNT, ...)
    -> __memcg_kmem_charge_page()
      -> obj_cgroup_charge_pages()
        -> try_charge_memcg()
          -> page_counter_try_charge()
            -> page_counter_consume_stock()
              -> page_counter_drain_stock()
                -> css_put(counter->stock_css)
                  -> css_release()
                    -> queue_work(cgroup_release_wq, &css->destroy_work)

wouldn't queue_work() spin on workqueue pool and scheduler locks in a conte=
xt
where spinning is forbidden?

In addition, the commit message notes that lazy cleanup happens on the next
local stock miss ("The next local stock miss on that CPU scans for any stock
that has been disabled, and will drain its stock"). Because the
!READ_ONCE(cached->stock) check is placed before the counter !=3D cached ch=
eck
inside page_counter_consume_stock(), every fast-path stock hit at index i w=
ill
also dereference cached->stock across foreign struct page_counter cachelines
for slots 0..i and drain any disabled slots before i while holding
stock->lock.

Should the lazy cleanup of disabled slots be moved to
page_counter_refill_stock() (which only runs on a stock miss when may_batch=
 is
true and gfpflags_allow_spinning(gfp_mask) holds), while
page_counter_consume_stock() only checks counter =3D=3D cached?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104233029.3282=
438-1-joshua.hahnjy@gmail.com?part=3D7

