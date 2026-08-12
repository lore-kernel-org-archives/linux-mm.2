Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3B32C5CFCF
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 14:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDED6B02A4; Wed, 12 Aug 2026 10:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AEF06B02A5; Wed, 12 Aug 2026 10:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D5E6B02A6; Wed, 12 Aug 2026 10:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 126CD6B02A4
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:34:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8ED7CC03BB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:34:18 +0000 (UTC)
X-FDA: 85092862596.01.B8B671D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 217D118000F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:34:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RzixdGVd;
	spf=none (imf24.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786545256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZARXVhRHBjq1rWGwZ83P4vciQ/Vfnkb00xf1CbIBzmE=;
	b=DitjtCEtlunin0jIYSYFzp2ZqqkyOfXtMqyyu1UqG1nBNOzIzo9N8prklvh3277Lx+e8Al
	0td646qy4YUjWAmkZKQIO/cfQU7WxTPoTow+Bhxa1lFbnWfSw50jiT6xcBTqfJdmEDf6ti
	1b07ajysaUXSXS974nf1lHgPdhgTjy4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RzixdGVd;
	spf=none (imf24.hostedemail.com: domain of BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+5bb66369c51ae59fd3c1+8389+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786545256;
	b=ZQeGe1ArE4alxcSiqygFa/PnRybO/TciEna2xmbr0hbWjlWkHveRvEn7Ymk8hGsZrT8Z9O
	tzaB5ewju1oXZOiiB8fx4j4HmWKedp6LSHM3HbiF3JgMRBkFhv7M1pe/rG6WezrQFK/bmF
	yW9RRJCrVbFK6Y5pxG6vsc0PWAvqNMo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZARXVhRHBjq1rWGwZ83P4vciQ/Vfnkb00xf1CbIBzmE=; b=RzixdGVd+FqiWZIYbfgio6xCg/
	v9ZC9sxzk1/2VHghvYuePXyObJz58svciUzc2y4Y3NUXoXSELcXZibbgJwKGsTXsQNXciHxI5P9yH
	IJd6WGdwJKTGoHfJfIumKMDETPZkoEhwYwNABnQiGraTK+fC900YwKJU6RcqPxelmKKKsGT8pXmC8
	iFhzK3e2dwJ7pHcsWLL0uEdW7u1NH+xmpgdyiTs9nxULCeWsi0nuENTS5I7l0rg+OKggN9GCm5qlV
	8eMSJ32hmrZdcjL9W6Usi8axieazc8CxWfIAkr//VA83XQ2B74mqYPejAGGGejEp76VT3JCSYLxv1
	32kiNdMQ==;
Received: from [2001:8b0:10b:5:a3a3:d97e:a004:df29] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuA1x-000000027At-2ldB;
	Wed, 12 Aug 2026 14:34:09 +0000
Message-ID: <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org>
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
Date: Wed, 12 Aug 2026 15:34:03 +0100
In-Reply-To: <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
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
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-wnUrnxZhZDs1Yt7NZqbO"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 9bj6r86f9khj3dts8kxhnpd66s3qhw63
X-Rspamd-Queue-Id: 217D118000F
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786545255-821464
X-HE-Meta: U2FsdGVkX1+FT+KPT/oi/lSQth2bSw5yKrMcG4WiH0BuPwFZUG7RajhT/4gI4GYZLnLG9om0eLl162mJ/sQfEGv/XkXUW1onoR3QJmzEGlrSEBrEvaeK03Gf0zJQQZ5TA5qn0odwe/JAeQyQY7gCAFE48ronGTSFrzNYe0U09BEEYvUFYLyQGGZz7tVAtDEELNvAQ0FwHNMJHZFKuVANUnDJ9YqxIua9woHo8dHwYAoMCKfyZGDC0ig5q5kX8eA59+cky3r3Bg4lFHzFoT7zsX7A9YCNUI+XxsiQjpMV7OZQJlvMqkqwFTtN7jTfMa582DllNVwBO7uN+CYK13OKGKTK04CaycIG5D3p4nDlhqWLOeHrminIGpQR15Jpe8aqsn8UNzvvL6ANdgTprysgvY4Z4A8/rMlE8Yv3rDD5x7NJ+TCIUScuLYGwEU1BKcroPHVfEVAOzdI6aqaQtdPeVhMQOMBJ/IY6rBNDBXtgoRWJccwIApdG+YoVkUrg1DtG6O9mWQ9iTm7Mci06s1I2lToPEJEjEw+nA9jo1Gc8LqCfD2awwptYPYa1DaNmB7ruFhMsIYuFdWny6Fp7fiKGfHT4Hf17sJrHZGAIeGC+udvMLuLmC0KMMxwuaRlxsjbuhlZ56ALZK9YyjpgHU83C4otyObtt/ChcnuiuvmAUhJhAKhYzotX+GioXq3WM39ViCgErg1n61UmbPvgTwkxKW85ptYmFcjKgHdMYNwJQP/bGn2QcQ+27767Lk/Ghd763Y8EuL01NWxCm6zBOwAwKspYKvCwP8WM3pqgOvoyTxjZAINSIbBDbif/yVCq6k58DqR4KmZ1vmKa9sKyj9R8+9r5bahsLWfgSRYyo1MgVQBUlLslQPUJszn7iDcbonEllmGdWDYDbA1qJ+nWCHTPtu7mFd5nvg1oTdckwlSvTPfj50+B8ViiZI2og5QUj27T8qZv8SZq4I8io8JLJ4XW
 mVmU7l0N
 HieU4iGrq0J8PGll0n8J0ZyFLPI9VMVn1QZ5s+JMJAlOrUttDYFNpXyeHum4vby13YkUng+Y3ZiXt7EEdBjSPRjsyne/TM9T0F3TvdfRFQr6pD5dBUdFA1PYuyTBTgN1Luo6vlJRl+GMULynTf5HB/z4X/88F6vZbCcXHPgHbYCkhaqMlpgiS8/ABewfwof7jT8GUsUfApc430+S3rLi12e4q9j95lZyI3SnEreBDWE2GhXgGaW82TuuoLUQIH0O/kSgEX0V8yOHFWW2o8A/aawk8emt/RKRJLi2HGmXtLQiGllDr+5CAx5JTXxNKESpRu/eGvRrttJkqE88Iqx2YwKSduqYprQuhfL0RsCm2CtB/bQJXTlA3XINRnhHdS33TvE3dcCwKcMEEdB2hSKMxDpmdAkSlHaOg2kXBjsZj8AW11nfjZl0Cvg8DV8zlau2YhzmqJz1tD6450VvDSTzhrGx/9rGnlUnA2cYRNt0jlvho5e1jFmVLSclCR1ixrrznWCHUAhVSdJfY+9OxubH+lsd0pd03I/blcKbM+R63Q1DATnezOebxAnUCTg4Z8gt+0cI4p0SMNak5fAOpHbPwviKdOlyuLT1ZamaF2ovmfFyKOPHc4jqM4uGgBrV4tIXN4pFBopQwo39c9dwQc44HGEXsClCscXTqrkVVUejLlk2QvjVAvyfbmQQQ+E3coamKWKtSqLWRUieBeJvsyIcBXCSXHYApnNJ3ntPNjjGjDtmae6LuriWp57+5Gg3g4wmPXvtADmk9SAkuStX0ROfQfWOoXn8C+Usc+e1Qeum/et67GXIAz+RAlT9gbCppYDp28+jVMfUlojvvtl5ISNKXdAGIKw2FvXy+0VUsfqUKmOpNsXzEqnSBuffg7YnYdxxhNsiAoISFZHaHJJmHrYkTJCBjlPXWMcEEncBI9IR6oPMSQmFlaa7j0lPnQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-wnUrnxZhZDs1Yt7NZqbO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-08-12 at 15:05 +0100, David Woodhouse wrote:
> I'll rephrase that for my own understanding:
>=20
> *If* we go all the way to building a whole SRCU flavour for this *and*
> implementing a spin-only variant of srcu_synchronize() which is
> tailored to the atomic-reader use case, *then* we don't need to remove
> the non_block_{start,end} guards around the MMU notifiers, which are
> basically never being called anyway and don't actually seem to protect
> against any real bugs.
>=20
> Yes?

FWIW it looks something like this. I'll throw it into my torture and
latency tests, and we can see what Paul thinks of it. I'm still utterly
unconvinced it's needed, but I concede it has its good points.

=46rom f912e839bf55759a1969e38d9e7897a30967fdb1 Mon Sep 17 00:00:00 2001
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
 include/linux/srcu.h  | 59 ++++++++++++++++++++++++++++++++++++++-
 kernel/rcu/srcutiny.c | 21 ++++++++++++++
 kernel/rcu/srcutree.c | 65 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+), 1 deletion(-)

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
index 76a78336feaa..5fa10c07cb3f 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -1715,6 +1715,71 @@ bool try_synchronize_srcu(struct srcu_struct *ssp)
 }
 EXPORT_SYMBOL_GPL(try_synchronize_srcu);
=20
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
+ * bounded by the longest such section. The proof of reader absence is
+ * the same both-epoch counter comparison as try_synchronize_srcu(),
+ * repeated until it succeeds; no index flip and no grace-period
+ * sequence update occur, so concurrent call_srcu(), synchronize_srcu()
+ * and srcu_barrier() are entirely unaffected.
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
+	unsigned long unlocks0, unlocks1;
+	unsigned long rdm0, rdm1;
+
+	check_init_srcu_struct(ssp);
+
+	/*
+	 * Order the caller's prior stores before the counter reads;
+	 * pairs with the smp_mb() in __srcu_read_lock() as described
+	 * in try_synchronize_srcu().
+	 */
+	smp_mb();
+
+	for (;;) {
+		unlocks0 =3D srcu_readers_unlock_idx(ssp, 0, &rdm0);
+		unlocks1 =3D srcu_readers_unlock_idx(ssp, 1, &rdm1);
+
+		if (WARN_ONCE((rdm0 | rdm1) & ~SRCU_READ_FLAVOR_ATOMIC,
+			      "non-atomic readers on srcu_struct at %ps; falling back to sleepi=
ng grace period\n",
+			      ssp)) {
+			synchronize_srcu_expedited(ssp);
+			return;
+		}
+
+		smp_mb();
+
+		if (srcu_readers_lock_idx(ssp, 0, false, unlocks0) &&
+		    srcu_readers_lock_idx(ssp, 1, false, unlocks1))
+			break;
+
+		cpu_relax();
+	}
+
+	/* Order the caller's subsequent accesses after the proof. */
+	smp_mb();
+}
+EXPORT_SYMBOL_GPL(synchronize_srcu_atomic);
+
 /**
  * get_state_synchronize_srcu - Provide an end-of-grace-period cookie
  * @ssp: srcu_struct to provide cookie for.
--=20
2.43.0


--=-wnUrnxZhZDs1Yt7NZqbO
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
Vbm99z2ufLYsCbHGermAZd4AAAAAAAA=


--=-wnUrnxZhZDs1Yt7NZqbO--

