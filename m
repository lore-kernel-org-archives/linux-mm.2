Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED6BC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 15:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C816B02AE; Wed, 12 Aug 2026 11:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B242C6B02AF; Wed, 12 Aug 2026 11:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12A56B02B0; Wed, 12 Aug 2026 11:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6836B6B02AE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:03:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCEECA03F0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:03:45 +0000 (UTC)
X-FDA: 85092936810.20.6DFBC0E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5DD79C000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:03:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RZh4pKJz;
	spf=none (imf22.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786547023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdPR6kkrAHW24t2SCqGXMhi/x7lTMqdbTLv585Z/SJ8=;
	b=Ia969SxKnXe2/yfqHKCWU4cwE3FXfMPsF/RLoDbi3a38SDSotjDHDB9Ijp2IzfciDsqEef
	cMgxphfihxFc28SgwvXqNg7LoddXN9Rehf51ZZFeezrM1H6px+1H/WM55MtmrXizhuTjoy
	AviqU0k4/qR5tX3wPwh89S5NlmU4jBY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RZh4pKJz;
	spf=none (imf22.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786547023;
	b=LxsJKviIjzshtMUIpJyx1Hw0ZHxxuPhri2cu4xhR978H1xMCyywJ+gZGnfdbv18qF2zjpc
	Z8BHNX2iAFY5AsbMsO82TblRdeq0tExO9WbNgiMAzImy2tI2OkWXSRj5AV3BkZg4pIBE9A
	aFX7gjiiwFXylS2TtLHK8WmmcDhyXyM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SdPR6kkrAHW24t2SCqGXMhi/x7lTMqdbTLv585Z/SJ8=; b=RZh4pKJzneLN5C+tljL72cqcqv
	IYrpwRpBM5d/Xo4t006QpFuXkgBwTXB3LdE5UcdA0RZWsUHp74PLkve7b62s5O7wfYvpwf/tqRfWk
	gGrdJFB6/SeTGtOHrAlJVQ0h7Nc8wOKmnDYrcC3Um1YKv34pZdHzISDceYBoXq1UXj3iwchHF5CYP
	lA14EnUhgF5ebzpgpJWqJoMjtNk4DbtjnJ5cDPo1g/gLmmydk1q6NbT9oSZ+FU0L8Lbx+PhgKixX6
	bzjxJ0UZT3JQ7JgjHZj5lK4p3CRLWbbbYTPYJnDdo/VXDOcWGSh7jbSA660c3dj6phW1/ytTJJWyu
	qdny/2sQ==;
Received: from [2001:8b0:10b:5:a3a3:d97e:a004:df29] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuAUR-000000029D5-3NoZ;
	Wed, 12 Aug 2026 15:03:36 +0000
Message-ID: <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: David Woodhouse <dwmw2@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes	 <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>,  Clark Williams
 <clrkwllms@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>,
 =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Christian
 =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,  "Paul E. McKenney"	
 <paulmck@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini	 <pbonzini@redhat.com>, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Wed, 12 Aug 2026 16:03:29 +0100
In-Reply-To: <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org>
References: <20260811135537.GC544626@ziepe.ca>
			 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
			 <20260811142730.GG544626@ziepe.ca>
			 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
			 <20260811104229.72fdd928@gandalf.local.home>
			 <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
			 <anwraNIKJV8zwrNT@tiehlicka>
			 <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
			 <20260812122759.GA662699@ziepe.ca>
			 <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
			 <20260812134934.GC662699@ziepe.ca>
		 <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
	 <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-kc/muEhCtwjSTkJRJe+V"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 7cbwencu3wquze6h9ka5hdnwsuyp34rz
X-Rspamd-Queue-Id: 5DD79C000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786547023-424132
X-HE-Meta: U2FsdGVkX1+uqpLWhFZxCgfEgcdujNG4s75xeYtkNlZ/3YxTR1BuFDx3EcssmnYq9Lmnwm0RGX8Hi6o7O4v6WTHverKpXapMhpHCxo3yArjWqPjjzy581WCwcAkBnuUrVzCOWRSS4nRKg3N82k9x+R27BkT4owUP6t1d5lfmmfQy3S/6aBh5W7FsHWmjpYcz0z/mgcPr9oWymtWLWCHlXkQIRblQX7KuVcgDZyF9bRO2Vzfd2jmIJYxQwSNzcRPyQDE6918nXhFJPVK4B0+2GAJxhLI8bDL1EnCtGzy7b2pzbMCOKLuCsYIv5IydEsJey1WMDWXhiRPQeTfPurbbyehwiMzPyBb6t67QpX/iJEDaM/4A+F/n3/wm7ZUNK3BxLmjb8uITjKnXzOZjwFGs8Qpuh93m7ZpnJrZl5BUgrXz9+uv7JQ6q1GktoIaE79eoyasDaSJumAepCCP2k/12JE6sZqV9lLEO+wpwWTK5Q4nDLEBNvR2cASjnFnx7Q1q+w2QFxTyVu1dinZv79nOUxwLeq8ev0HnPOm5SISO2uzAnqLd2iwVU96mB1jToN2UAy69t6e0jtmmxFySitQmuxXkzAOGpHYd7lUfFVl5TiPAkKIikFtdyEchLpCT1+HdsN+cCCdJvN4QcnjSP4bz8lhmP2CmhiI6EqJFrpdeX4mpuo982BNrps8TRPtAVKTGZYnnDenOWRBDvjcilG8hUrq5u3b+dx/hr4cp721aiBR3ZvtB/H1XwYM40MDLXztQNCHj2/cU209r4wiOiHPle9IsEaI7ddAwK5C0+9r40Olg9Ol3CDZQp8D7+kIEMH6w6Lb5I969PK88J+63dPGoVPGyUt+SCzdpc/TWieMVG3ivHO9rnQonbxxrI5Dv7xAa7hg4wMqxHwiyQd2Z0HqxlQjkk0uZqyuNO3rS+dKq9YKMWd2uFgUvSlBU2iNMt9Ya85HxfpTadal4zV6MeSOQ
 lpGv6p29
 KhxUpIDdhItoC8Qk2A2TvTk1TEp9G8Pq5LCQt234hWFsZV30nARFYkhsIo4azF0hRdXiVx6ZFerwGVUPBX4FmtlsRv8N/Lh0cOQYKWhZ/E90ICRYturiPEXhoB+ounwQe4kTE2fwkDcVl0EDjLo7Ps4D8moB+tK6rfbQiqzHKHe0607VVD77fmecu7rMSo2/+HMIOEx5Qance7FDhlE0fzoLcCywcQD3Bub4dS4QZ0ZJraNI6D+j8WDI0MbL1PwE0ng6geNUPvzxNXG4yDe1v4VQcgi69j9D9+uCCPtOVUtb9hcEHg1thyVuRQFYzcvKlxf1/V+g3z+dTRSiTR7IlYFgr4el2zN4LXreQHaYByugQlGPZHmaqhWXTKIm5CzRZRsCA1G2tdiUFSGxR8xbEYW7E0Trv/OCDm+mKOT5PIsObf3JDGZK+h9lunnh/xWVPzx7mVP7RMyEFoWKhykpqUqf4DruzatJSFg6XSYzjUrXyyHUNlQ4uScrUmkVi2hK8wg5o7KMXXY3aKj9AE4Xyszg80yXyhhOHKyDNS07Brvb/i9nyqmDK6zAzE/0LFFbx1r1lGmwGfCAN3oBWbRUk8hylLGGb9RrrlGeEjhIJ8VoAUPcA19BYX+KfeMAYrdCeuiKScQgmviMXXIv7MdIkTExo1GzFKIBvAL6/VGi3thXxoJEFL1wfwhTBsVenkVJU93PJzHe8R6rK/7SUUvHcqfUdm8a9yRyPVm68CVOy8F1yyUrfPkW4SdLXlskUhH+yW0jaDfIWLKnZwbiSFklIersn95knBDFDHOrGXcD+siUEQqYvGCil0mi7ifmiH6lbbI0iNxbkvMpK3pviUPzGXrBLcdgCVuygZc/2Y+rhQE6ZYIT9/O7dehwOJTu1AAaHMNLDGloQ8ZQ+LjWrYlRytjfoRxqTFhtbBKKtUZ9XbKK6Jq0aho8kHa9eOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-kc/muEhCtwjSTkJRJe+V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-08-12 at 15:34 +0100, David Woodhouse wrote:
> On Wed, 2026-08-12 at 15:05 +0100, David Woodhouse wrote:
> > I'll rephrase that for my own understanding:
> >=20
> > *If* we go all the way to building a whole SRCU flavour for this *and*
> > implementing a spin-only variant of srcu_synchronize() which is
> > tailored to the atomic-reader use case, *then* we don't need to remove
> > the non_block_{start,end} guards around the MMU notifiers, which are
> > basically never being called anyway and don't actually seem to protect
> > against any real bugs.
> >=20
> > Yes?
>=20
> FWIW it looks something like this. I'll throw it into my torture and
> latency tests, and we can see what Paul thinks of it. I'm still utterly
> unconvinced it's needed, but I concede it has its good points.

This slightly refactored version is the one that's actually going into
my torture tests...

I'll defer to Paul here. If we think this whole srcu_read_lock_atomic
thing is really worth it for SRCU in the general case =E2=80=94 perhaps we =
can
use it to convert existing rwlock_t users, some of whom have been also
blindsided by those becoming sleepable on RT =E2=80=94 then I guess it make=
s
sense.

I can't honestly defend the added complexity *purely* for the KVM GPC
use case though; I just can't bring myself to lose sleep over the use
of the wait queue from the MMU notifier even in the OOM reaper path.
It's *latency* that matters.

=46rom f09baac8dc596596018e7009c15a1cd73cdfd421 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Wed, 12 Aug 2026 15:29:12 +0100
Subject: [PATCH 1/2] srcu: Add an ATOMIC reader flavor and a spinning
 synchronize_srcu_atomic()
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Some dedicated srcu_struct users have read-side critical sections
which are short, never sleep, and never block on anything which may
itself depend on memory allocation =E2=80=94 because they were, until
recently, spinlock or rwlock critical sections. For such a domain the
update side can safely wait for readers by spinning, from contexts
where sleeping is undesirable or the grace-period machinery's
latency (workqueue scheduling, jiffy-paced retries) dominates the
actual reader drain time.

But that is only safe if every reader keeps the promise. Make the
promise explicit and machine-checkable:

 - srcu_read_lock_atomic() / srcu_read_unlock_atomic() enter the
   usual (smp_mb-based) read-side critical section with preemption
   disabled and (except in hardirq, where it is redundant)
   non_block_start() armed, recording SRCU_READ_FLAVOR_ATOMIC in the
   per-CPU reader flavor. Disabling preemption enforces the
   no-sleeping promise on every configuration and bounds the section,
   so it is always running on some CPU; non_block_start() extends the
   enforcement to even potentially-sleeping calls on paths which
   happen not to block. The existing reader-flavor consistency checks
   complain about any mixing with other flavors.

 - synchronize_srcu_atomic() waits for all pre-existing readers by
   repeating the try_synchronize_srcu() both-epoch counter proof with
   cpu_relax() until it succeeds: no sleeping, no index flip, no
   grace-period sequence update, and therefore no interaction with
   concurrent call_srcu(), synchronize_srcu() or srcu_barrier(). It
   always provides the full grace-period guarantee: if the domain
   turns out to have had readers of any other flavor =E2=80=94 a caller bug=
,
   since such a reader may be asleep and spinning on it would be
   unbounded =E2=80=94 it complains and falls back to a real (sleeping) gra=
ce
   period internally, that being the only correct wait for a
   possibly-sleeping reader. The flavor mask is rechecked on every
   iteration so a first non-atomic reader appearing mid-spin takes
   the same path.

On Tiny SRCU (!SMP), spinning cannot be sane =E2=80=94 an observed mid-sect=
ion
reader can only make progress if we yield =E2=80=94 but it is also never
needed: an atomic-flavor reader cannot be observed mid-section from
process context on the sole CPU, so the try_synchronize_srcu() proof
either succeeds immediately or the fallback is required anyway.

The immediate motivation is the proposed conversion of KVM's
gfn_to_pfn_cache to SRCU=C2=B9, whose mmu_notifier invalidation path drains
readers before the primary MMU zaps a page. With the readers declared
atomic, that drain becomes spin-only: no sleeping at all in the
notifier, bounded by the longest reader section, satisfying even the
strictest reading of the OOM-reaper non-blocking requirement without
needing to touch the non_block_start() annotation=C2=B2.

=C2=B9 https://lore.kernel.org/all/20260811132237.102400-1-dwmw2@infradead.=
org/
=C2=B2 https://lore.kernel.org/all/20260812134934.GC662699@ziepe.ca/

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Assisted-by: Claude:claude-mythos-5
---
 include/linux/srcu.h  |  59 +++++++++++++++++-
 kernel/rcu/srcutiny.c |  21 +++++++
 kernel/rcu/srcutree.c | 135 ++++++++++++++++++++++++++++++------------
 3 files changed, 175 insertions(+), 40 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 0d7543c7becc..c81dfd0896ad 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -71,8 +71,10 @@ int init_srcu_struct_fast_updown(struct srcu_struct *ssp=
);
 //					0x4		// SRCU-lite is no longer with us.
 #define SRCU_READ_FLAVOR_FAST		0x4		// srcu_read_lock_fast(), also NMI-saf=
e.
 #define SRCU_READ_FLAVOR_FAST_UPDOWN	0x8		// srcu_read_lock_fast_updown().
+#define SRCU_READ_FLAVOR_ATOMIC		0x10		// srcu_read_lock_atomic().
 #define SRCU_READ_FLAVOR_ALL		(SRCU_READ_FLAVOR_NORMAL | SRCU_READ_FLAVOR_=
NMI | \
-					 SRCU_READ_FLAVOR_FAST | SRCU_READ_FLAVOR_FAST_UPDOWN)
+					 SRCU_READ_FLAVOR_FAST | SRCU_READ_FLAVOR_FAST_UPDOWN | \
+					 SRCU_READ_FLAVOR_ATOMIC)
 						// All of the above.
 #define SRCU_READ_FLAVOR_SLOWGP		(SRCU_READ_FLAVOR_FAST | SRCU_READ_FLAVOR=
_FAST_UPDOWN)
 						// Flavors requiring synchronize_rcu()
@@ -92,6 +94,7 @@ void call_srcu(struct srcu_struct *ssp, struct rcu_head *=
head,
 void cleanup_srcu_struct(struct srcu_struct *ssp);
 void synchronize_srcu(struct srcu_struct *ssp);
 bool try_synchronize_srcu(struct srcu_struct *ssp);
+void synchronize_srcu_atomic(struct srcu_struct *ssp);
=20
 #define SRCU_GET_STATE_COMPLETED 0x1
=20
@@ -296,6 +299,43 @@ static inline int srcu_read_lock(struct srcu_struct *s=
sp)
 	return retval;
 }
=20
+/**
+ * srcu_read_lock_atomic - register a new reader promising an atomic secti=
on
+ * @ssp: srcu_struct in which to register the new reader.
+ *
+ * As srcu_read_lock(), but the caller promises that the read-side
+ * critical section never sleeps and never blocks on anything which
+ * may itself depend on memory allocation to make progress. Preemption
+ * is disabled for the duration, which both enforces that promise (any
+ * sleepable call in the section will splat on every configuration)
+ * and bounds the section so that the update side may spin rather
+ * than sleep when waiting for readers: see synchronize_srcu_atomic().
+ *
+ * The lock and matching srcu_read_unlock_atomic() must be invoked on
+ * the same CPU, from the same context; passing the return value to
+ * another task is not permitted for this flavor.
+ */
+static inline int srcu_read_lock_atomic(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
+{
+	int retval;
+
+	preempt_disable();
+	/*
+	 * Arm might_sleep() to catch even a *potentially* sleeping call
+	 * in the section, not just an actual schedule: the atomic-domain
+	 * promise must hold on every path, contended or not. In hardirq
+	 * the annotation would land on the interrupted task; it is also
+	 * redundant there, so skip it.
+	 */
+	if (!in_hardirq())
+		non_block_start();
+	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_ATOMIC);
+	retval =3D __srcu_read_lock(ssp);
+	srcu_lock_acquire(&ssp->dep_map);
+	return retval;
+}
+
 /**
  * srcu_read_lock_fast - register a new reader for an SRCU-protected struc=
ture.
  * @ssp: srcu_struct in which to register the new reader.
@@ -488,6 +528,23 @@ static inline void srcu_read_unlock(struct srcu_struct=
 *ssp, int idx)
 	__srcu_read_unlock(ssp, idx);
 }
=20
+/**
+ * srcu_read_unlock_atomic - unregister an atomic-section reader
+ * @ssp: srcu_struct from which to unregister the old reader.
+ * @idx: return value from corresponding srcu_read_lock_atomic().
+ */
+static inline void srcu_read_unlock_atomic(struct srcu_struct *ssp, int id=
x)
+	__releases_shared(ssp)
+{
+	WARN_ON_ONCE(idx & ~0x1);
+	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_ATOMIC);
+	srcu_lock_release(&ssp->dep_map);
+	__srcu_read_unlock(ssp, idx);
+	if (!in_hardirq())
+		non_block_end();
+	preempt_enable();
+}
+
 /**
  * srcu_read_unlock_fast - unregister a old reader from an SRCU-protected =
structure.
  * @ssp: srcu_struct in which to unregister the old reader.
diff --git a/kernel/rcu/srcutiny.c b/kernel/rcu/srcutiny.c
index f07159cae241..c04112d9c332 100644
--- a/kernel/rcu/srcutiny.c
+++ b/kernel/rcu/srcutiny.c
@@ -283,6 +283,27 @@ bool try_synchronize_srcu(struct srcu_struct *ssp)
 }
 EXPORT_SYMBOL_GPL(try_synchronize_srcu);
=20
+/**
+ * synchronize_srcu_atomic - spinning grace period for atomic-reader domai=
ns
+ * @ssp: srcu_struct with which to synchronize.
+ *
+ * On !SMP this cannot spin: a reader observed mid-section is preempted
+ * or interrupted-out, and can only finish if we yield the CPU. But it
+ * is also never needed: an atomic-flavor reader (preemption disabled)
+ * cannot be observed mid-section from process context on the sole CPU.
+ * So a reader observed here has broken the atomic-domain promise, and
+ * the only correct wait for it is a real grace period.
+ */
+void synchronize_srcu_atomic(struct srcu_struct *ssp)
+{
+	if (try_synchronize_srcu(ssp))
+		return;
+	WARN_ONCE(1, "non-atomic readers on srcu_struct at %ps; falling back to s=
leeping grace period\n",
+		  ssp);
+	synchronize_srcu(ssp);
+}
+EXPORT_SYMBOL_GPL(synchronize_srcu_atomic);
+
 /*
  * get_state_synchronize_srcu - Provide an end-of-grace-period cookie
  */
diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index 76a78336feaa..3cafb1c2160b 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -1645,6 +1645,47 @@ void synchronize_srcu(struct srcu_struct *ssp)
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu);
=20
+/*
+ * Attempt to prove that @ssp has no readers in either epoch. Returns:
+ *   1  - proof succeeded: no pre-existing readers, sums stable.
+ *   0  - readers (or counter movement) observed; try again later.
+ *   -1 - the domain has reader flavors incompatible with @allowed
+ *        (those which elide the read-side smp_mb() that the proof
+ *        depends on, or, for the spinning caller, those which may
+ *        sleep); the caller needs a real grace period.
+ *
+ * The caller must provide the leading smp_mb() ordering its prior
+ * stores before this proof (pairing with the smp_mb() in
+ * __srcu_read_lock()), and is responsible for ordering its subsequent
+ * accesses after a successful proof.
+ */
+static int srcu_readers_provably_absent(struct srcu_struct *ssp, unsigned =
long allowed)
+{
+	unsigned long unlocks0, unlocks1;
+	unsigned long rdm0, rdm1;
+
+	unlocks0 =3D srcu_readers_unlock_idx(ssp, 0, &rdm0);
+	unlocks1 =3D srcu_readers_unlock_idx(ssp, 1, &rdm1);
+
+	if ((rdm0 | rdm1) & ~allowed)
+		return -1;
+
+	/*
+	 * As in srcu_readers_active_idx_check(): ensure that a lock is
+	 * always counted if the corresponding unlock is counted, so that
+	 * a reader racing with these sums can only inflate the lock sum
+	 * and force the (safe) retry or fallback. Summing both epochs
+	 * means no index flip is needed: a stable equality proves there
+	 * was a moment at which no readers existed at all.
+	 */
+	smp_mb();
+
+	if (srcu_readers_lock_idx(ssp, 0, false, unlocks0) &&
+	    srcu_readers_lock_idx(ssp, 1, false, unlocks1))
+		return 1;
+	return 0;
+}
+
 /**
  * try_synchronize_srcu - inline grace period for a reader-free srcu_struc=
t
  * @ssp: srcu_struct with which to synchronize.
@@ -1656,64 +1697,80 @@ EXPORT_SYMBOL_GPL(synchronize_srcu);
  * failure the caller must fall back to synchronize_srcu() or
  * synchronize_srcu_expedited().
  *
- * This serves dedicated srcu_struct structures whose read-side critical
- * sections are short, atomic, and usually absent =E2=80=94 where even an
- * expedited grace period costs two trips through the workqueue and an
- * unconditional sleep of the caller, three orders of magnitude more
- * than the check below.
- *
- * Only readers of the srcu_read_lock() and srcu_read_lock_nmisafe()
- * flavors are compatible with this proof; if the _fast() flavors have
- * ever been used on @ssp, this function always returns false.
+ * Only readers of the flavors which include a read-side smp_mb() are
+ * compatible with this proof; if the _fast() flavors have ever been
+ * used on @ssp, this function always returns false.
  */
 bool try_synchronize_srcu(struct srcu_struct *ssp)
 {
-	unsigned long unlocks0, unlocks1;
-	unsigned long rdm0, rdm1;
-
 	check_init_srcu_struct(ssp);
=20
 	/*
-	 * Order the caller's prior stores before the counter reads below.
-	 * Pairs (store-buffering pattern) with the smp_mb() in
-	 * __srcu_read_lock(): any reader whose lock increment is not
-	 * observed by the sums below is guaranteed to observe, within its
+	 * Order the caller's prior stores before the counter reads in
+	 * the proof. Pairs (store-buffering pattern) with the smp_mb()
+	 * in __srcu_read_lock(): any reader whose lock increment is not
+	 * observed by the sums is guaranteed to observe, within its
 	 * critical section, every store the caller made before calling
 	 * this function.
 	 */
 	smp_mb();
=20
-	unlocks0 =3D srcu_readers_unlock_idx(ssp, 0, &rdm0);
-	unlocks1 =3D srcu_readers_unlock_idx(ssp, 1, &rdm1);
-
-	/*
-	 * Reader flavors which elide the read-side smp_mb() that the
-	 * pairing above depends on cannot be proven absent this way;
-	 * they need a real grace period.
-	 */
-	if ((rdm0 | rdm1) & SRCU_READ_FLAVOR_SLOWGP)
+	if (srcu_readers_provably_absent(ssp, ~SRCU_READ_FLAVOR_SLOWGP) !=3D 1)
 		return false;
=20
-	/*
-	 * As in srcu_readers_active_idx_check(): ensure that a lock is
-	 * always counted if the corresponding unlock is counted, so that
-	 * a reader racing with these sums can only inflate the lock sum
-	 * and force the (safe) fallback. Summing both epochs means no
-	 * index flip is needed: a stable equality proves there was a
-	 * moment in this function at which no readers existed at all.
-	 */
+	/* Order the caller's subsequent accesses after the proof. */
 	smp_mb();
+	return true;
+}
+EXPORT_SYMBOL_GPL(try_synchronize_srcu);
=20
-	if (!srcu_readers_lock_idx(ssp, 0, false, unlocks0))
-		return false;
-	if (!srcu_readers_lock_idx(ssp, 1, false, unlocks1))
-		return false;
+/**
+ * synchronize_srcu_atomic - spinning grace period for atomic-reader domai=
ns
+ * @ssp: srcu_struct with which to synchronize.
+ *
+ * Wait for all pre-existing readers of @ssp to complete, without
+ * sleeping and without involving the SRCU grace-period machinery =E2=80=
=94
+ * provided the domain keeps the promise that all of its readers use
+ * srcu_read_lock_atomic().
+ *
+ * Atomic-flavor readers run with preemption disabled, so every
+ * read-side critical section is bounded and running (not blocked) on
+ * some CPU, which is what makes spinning here sane: the wait is
+ * bounded by the longest such section. No index flip and no
+ * grace-period sequence update occur, so concurrent call_srcu(),
+ * synchronize_srcu() and srcu_barrier() are entirely unaffected.
+ *
+ * If the domain has ever had readers of any other flavor, the promise
+ * is broken =E2=80=94 such a reader may be asleep, and spinning on it wou=
ld be
+ * unbounded. That is a caller bug: complain, and fall back to a real
+ * (sleeping) grace period, which is the only correct wait for a
+ * possibly-sleeping reader. The reader-flavor mask is rechecked on
+ * every iteration so a first non-atomic reader appearing mid-spin
+ * takes the same path.
+ */
+void synchronize_srcu_atomic(struct srcu_struct *ssp)
+{
+	int ret;
+
+	check_init_srcu_struct(ssp);
+
+	/* As in try_synchronize_srcu(). */
+	smp_mb();
+
+	while ((ret =3D srcu_readers_provably_absent(ssp, SRCU_READ_FLAVOR_ATOMIC=
)) =3D=3D 0)
+		cpu_relax();
+
+	if (WARN_ONCE(ret < 0,
+		      "non-atomic readers on srcu_struct at %ps; falling back to sleepin=
g grace period\n",
+		      ssp)) {
+		synchronize_srcu_expedited(ssp);
+		return;
+	}
=20
 	/* Order the caller's subsequent accesses after the proof. */
 	smp_mb();
-	return true;
 }
-EXPORT_SYMBOL_GPL(try_synchronize_srcu);
+EXPORT_SYMBOL_GPL(synchronize_srcu_atomic);
=20
 /**
  * get_state_synchronize_srcu - Provide an end-of-grace-period cookie
--=20
2.43.0


--=-kc/muEhCtwjSTkJRJe+V
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCE8Ew
ggWvMIIEl6ADAgECAhANkOKMSmGXhF5eMl0rsRhvMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBHMjAeFw0yNDAzMTMwMDAwMDBaFw0zNDAz
MTIyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UE
AxMxRGlnaUNlcnQgQXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTCCAiIw
DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOfSIeC0vv1xPQ+dgSxbIIrkaru6skAWJYaGFzmv
q4Kq+2wU2jxhcWlJg/JeP5jEkq/LM3pn5aaLao79j+XRmS7J1ZpJKUODJVoM4s9MQJhTMvo4qS5Z
S64g6QR7Obkz3I1Lr3aWeSBmDDEyzue+NKtuWZ1Cxy3RdXo/w5HgRc3l2AercOM3Gt1XonTzEtTb
Z/Hwc0Sn9Gz8RmGRK6Ka4hVDl8q/2l110KaV233Kh5etP0csXS8MIMdVRfRu3sc5hp13DG7lCKzK
72a2GEpI8Wpl26G6I1/LMzz/98T+FqjTqxsdquk7Cj7m2vKGLW1BorpQH7WFGPdJQXJe1hfbfiZA
CcVdCtl4nAacFacmsiArZBfX7AQGL7isvHUwwYFEtcApyGW4p2Lt+t8nvU0CANA6BHOpOz1xOP8W
mAESbUriIjyuTUf3fJ9oDNCurVqhASMJCDaWI3lYX/QAoiAzt6akqbbZxo2ujW7mGGqc0KxqE2cs
h2T79v7pC8aUtHBfwNrTR19GnZVxE0eQ7ViIQhR6mpSaUQFA9sG+cmD2G8TnCgYsLa0q8De6F61a
CBevQGHNzrbZ3JAMneveYg/Jy1XxQHDRcvrMfWKe0jjcWbdKYlaGVPm5V1ILwYz7Yv5ewo3NUrxI
GJiywe9qPhuJSDZs7VehTuI0FxGIsgKzVjgbAgMBAAGjggFcMIIBWDASBgNVHRMBAf8ECDAGAQH/
AgEAMB0GA1UdDgQWBBT3m6JO05fF9DQPQw6Bhc6RkzKv+TAfBgNVHSMEGDAWgBTOw0q5mVXyuNtg
v6l+vVa1lzan1jAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMG
CCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
b290RzIuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdp
Q2VydEFzc3VyZWRJRFJvb3RHMi5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUA
A4IBAQA+b8Uw53sDspdZgukU+qzLyyHkcjlxGGhHlP+zrmDLKm1wEFvCRS2pili3Hy67i8N4N5NU
vw5Rg6kv3lxb9S9Rktxk43k+tvm68pl7OxQE55ZjVY87P0lUPGwEqOOwLLyH02ZQcsfq5p5LrOH9
0JvmvZ1yy73HS+VpDAqOlytE0NSvTIRqFFkKQGQwfjvtql9YflujuNNvJztjBaHKYZsnNSg+J38o
jYq4TP3pSg3UdVH0PncVjPQyqxC9xef5Xae92Kbkzol3x7Nel3A1bwAkalrDMspvTHvey6LfiBks
FIqviTnoy7fgjaRAJgHS+RXx/cmuRd3rUAclSVVrYu8RMIIHAzCCBOugAwIBAgIQAzUotrsybJHx
HTjKOIVdIDANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
IEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQg
MjAyNCBDQTEwHhcNMjYwNzE4MDAwMDAwWhcNMjgwMTA0MjM1OTU5WjAeMRwwGgYDVQQDDBNkd213
MkBpbmZyYWRlYWQub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA2pYux73kdbYX
sWF8f1u6DJP91qcqaZetsyfPkZk0B+MmXmAEv0kVes5n15V2mbDThOnpoPFly0UugQO9JYqLfrtD
tKD5yL58fgrDB9Dw+LQikgrHafl6YSCds5AvUu/8hw2J6noKrcOLJpKlKn9Fl/4IB9Q3JIdLx5aa
EtTqMalIPqHFOlgrJ7s+aua8xbB8YQ9ahqYBXWRJNv3P/2b1DYtdrz1oqZPE3CcB8Pc6Gf2a1Tcm
6TAgtEx7Cf1BFcrsrMz7TWHmGQITieNb2r9UYWSc2Gp+GtYFNJCgT0JJXKUBIauPMKBLteYrL8Fo
ff/uY44dC/mDWjdCP/5x0qelPQjlBvWdHL5zvBTOj06rJ0m3HNI/hnIcDh0Qu2j9reb9rLVcdym6
bWmBM4uDEB8Zv9Ph0KTBFSy1IosyakuD1j1Os30EzjGfbi0EUXIvnOcYbTBAbM5UAzrxEHMhBvoX
Pvnx+OyvjJmc9tWxTX6AcSz+m40esbT17URBeZS18afgieiikm5TynlUYP1LciR3hSgGVzvGXnKO
02VDFR5itGWdRKZ2W5wIShNfWfhSa0D0K5UdIDt5Qc7sjzwK1Yb1sY5Tu0uA5mhIS82q1ov83uxB
sFkriNnhGv/M1NCDVLBiOMsHu73qUM+yKmgKLwF9Hfn9WI25glbAMI4S5r3hYzcCAwEAAaOCAfcw
ggHzMB8GA1UdIwQYMBaAFPebok7Tl8X0NA9DDoGFzpGTMq/5MB0GA1UdDgQWBBRcYhqbcGzn1jrT
JOZaB8O7qllDpzAwBgNVHREEKTAngRNkd213MkBpbmZyYWRlYWQub3JngRBkYXZpZEB3b29kaG91
LnNlMBQGA1UdIAQNMAswCQYHZ4EMAQUBAjAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYB
BQUHAwIGCCsGAQUFBwMEMIGpBgNVHR8EgaEwgZ4wTaBLoEmGR2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0
LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsME2gS6BJ
hkdodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZT
SEEzODQyMDI0Q0ExLmNybDCBjQYIKwYBBQUHAQEEgYAwfjAkBggrBgEFBQcwAYYYaHR0cDovL29j
c3AuZGlnaWNlcnQuY29tMFYGCCsGAQUFBzAChkpodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
RGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZTSEEzODQyMDI0Q0ExLmNydDANBgkqhkiG9w0B
AQsFAAOCAgEAocabrh1cPd5s3vY5rnlBVQSTc7zs2ZWs67dAIltR+05WELrYClVzzUhMs/LOJPlr
EUo45UDDomXq38DxFepaPd9+iNLjXfn33EX/IG44j04lU/oF/Rg9VeQILkYLbCZ/x9wOjNHZc4SN
ydY7Dhvf/sT5aBz88u7D5+azZJ7Qf1U57wYseCH1Mt0nDrtr5y19IJ8D9xJJ33RFL6vfpHZBBAQ8
+3RqkKNxLoV2aFvQhxdhjNLDqTv3LjUIdicwPraN7JkxEu7CV2Lka7eRqJgkWL7SK0YmBjGpRafs
+icP/ON5RCCKTTb6VlX8eTG2sJJfsFhvJNCCt6xexbWzWtIrfP7NvPBvwBB737AyEGBZkS5aNizT
McURJGTv9UKvBh1LF/+tNhYtLvPCN7oecGzhCHht9jcwSkygTo3Y6YlK3QgOu+ncmiBbfeuwlLZ1
LxbYvG6hgNqXv7u6YyADbYajAQJXJ2OQen39pm3Q/AQSyLYG+B8lDglWsM8tYXPlEdrYJcksGK6F
nqIX6Bumn43rBooLJdiZp4WmfWdL2pxe+LxRDjprmqu1WprixDxULSTOKJZoqTlugs6y3Bc+if+s
gHnBBtz9WQ6MtPHkh7zONDAFIKcBmv8OqPQCx0F3Wv3OEybwMpXx0OsKgK8wLldaX1pXcMuyDgTL
Sqs0AV0OHUgwggcDMIIE66ADAgECAhADNSi2uzJskfEdOMo4hV0gMA0GCSqGSIb3DQEBCwUAMGIx
CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UEAxMxRGlnaUNlcnQg
QXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTAeFw0yNjA3MTgwMDAwMDBa
Fw0yODAxMDQyMzU5NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqG
SIb3DQEBAQUAA4ICDwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZe
YAS/SRV6zmfXlXaZsNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2z
kC9S7/yHDYnqegqtw4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qG
pgFdZEk2/c//ZvUNi12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41va
v1RhZJzYan4a1gU0kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0c
vnO8FM6PTqsnSbcc0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PW
PU6zfQTOMZ9uLQRRci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXt
REF5lLXxp+CJ6KKSblPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQr
lR0gO3lBzuyPPArVhvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7Iq
aAovAX0d+f1YjbmCVsAwjhLmveFjNwIDAQABo4IB9zCCAfMwHwYDVR0jBBgwFoAU95uiTtOXxfQ0
D0MOgYXOkZMyr/kwHQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3
bXcyQGluZnJhZGVhZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEC
MA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwgakGA1UdHwSB
oTCBnjBNoEugSYZHaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZEcyU01J
TUVSU0E0MDk2U0hBMzg0MjAyNENBMS5jcmwwTaBLoEmGR2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNv
bS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsMIGNBggrBgEF
BQcBAQSBgDB+MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wVgYIKwYBBQUH
MAKGSmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNB
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
h1xdPSMyJAdtb7g0wuxfftoAAAAAAAA=


--=-kc/muEhCtwjSTkJRJe+V--

