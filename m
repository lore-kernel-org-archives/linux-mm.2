Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA75BC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 21:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85C826B008A; Mon, 27 Jul 2026 17:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8332D6B008C; Mon, 27 Jul 2026 17:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770496B0093; Mon, 27 Jul 2026 17:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 438166B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:14:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66DAE40125
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:14:17 +0000 (UTC)
X-FDA: 85035809754.30.F6E598A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8BCBF14000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:14:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KUKMD0jm;
	spf=pass (imf23.hostedemail.com: domain of "SRS0=SzS6=FV=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=SzS6=FV=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785186855;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jDDLZVg0pWK3kfGm3YqYFtcQrrASDE9m+iAc5W2BT/k=;
	b=yyqfYViEN6EPU7b2doxfW7RG0nMNHEyJHp5U1s71VnH9uYjtPsrxx1gLlCVRzs0xmrEC8/
	RknC2J3kjdPd6YDRN24y9jPH+lTSpydyF8u1ltrMb0jeMN+x6NSuhCIk5Us6kxipeRFVaI
	bYtsHtOtfXmWl7kj14kRB+DpaeFc2a0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KUKMD0jm;
	spf=pass (imf23.hostedemail.com: domain of "SRS0=SzS6=FV=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=SzS6=FV=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785186855;
	b=pJ342mQOfvVRrhLw9fLK9GMkmo4ThcWL/wdiDDf+pV9AbD8BhbY75n7r2Wh3KAnQZildvx
	z3I5EWA2biok/uaK2TmSaIo3xe5LNHrhyjuSkSz9M5++QLmJpnqDsjazbu2CKc+LDUAnet
	429MhfPjILEd/sQaFSKbKhV6vgse23I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 613D843D67;
	Mon, 27 Jul 2026 21:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4295B1F000E9;
	Mon, 27 Jul 2026 21:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785186854;
	bh=jDDLZVg0pWK3kfGm3YqYFtcQrrASDE9m+iAc5W2BT/k=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=KUKMD0jmUEbdr5Bl9kcGMvcl/u9Uk8WH6l/lTEGnBJD3pSO9nqcmwjgrtLV9PxxyF
	 Yur/NYH3HkUDWyjRX/iPGaKwEKvXzruecXfO6Lljc7NkrY5nFdKyRKg7dQBsN6/KKu
	 7y9ABQPuD89Sy7j6jW8YtamYO1iE7nWsVbpKuuqWjulfSym9NPNPEcXj+8swkBaaKw
	 N6+7HmRsc3s0wu3eLIwF8nC5IWnfRNGpKAKFciXh23UWewonMjyN3u/HwYT3a7DseE
	 v+FHqxvOstuimGQFPnMnfP80kklDSJj14Oig6WPPhgDZiM3Vdasp/Zd4XgGLQrvnZu
	 LGCpl15pZ83IQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id EFB51CE08BC; Mon, 27 Jul 2026 14:14:13 -0700 (PDT)
Date: Mon, 27 Jul 2026 14:14:13 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Breno Leitao <leitao@debian.org>, David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/migrate: report RCU-tasks quiescent states in
 migrate_pages_batch()
Message-ID: <482ba2d2-531e-4926-a03e-0f97a68573df@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260727-kcompact-v1-1-bdfefddd6874@debian.org>
 <20260727134950.2d091094dbb9bb3ecb7a3eb6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260727134950.2d091094dbb9bb3ecb7a3eb6@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8BCBF14000B
X-Stat-Signature: jrf4o7tcktwkebiz4srkgitx7fmqjpuh
X-HE-Tag: 1785186855-984765
X-HE-Meta: U2FsdGVkX1/Z8d6wS94F1HVCPMtI4Y58shKsjsppugmDNi+KhYx6b83L5WcV379uJ1prsZIApZ78dZIc0W0IUx0f4zOD/DgCforpR//J2GJ5f3V+zxAaMElX/5oqFj+I7DaLVfYbtsOo4E5zfF3LW/ixNHkBrhCbwFXp4+FGYdCUcyx7mbz4YrKQaoABxyZzVBWDQGGx+mor4e9zHjfEvsLBVRnRRW4OqzP5wDpGY3zWrDXUYFJQ0V+FJYbnc/xt5Ien4n48oWZhZbK0CRuYosqFT9pQm0n32dNZTon+EKEKA9Mjf6RhpwSPGuiSmlSDmlTw5rfzSiyIjPAprlJf8YbNCZsqqI7xdhSjD0Et2aOBG+Buhef+jhAjbMKcma93A2RbeWNtKVMF7TCkucLQx89kCgLZfJIr4nbJGV5PO9Sn8A6Go3L7OcNJC62AUKpq0UEsBRpBJe3+lJ5VeD+YqmTHkNUpQorZlDMwwgpxMz8yzQYaeFI6lnwbLHDsvYjMwrlGImGWIEpWbIUwGcq59oiVYr43CiogDzukxR/6WpO9d6hG8uC00EcHxeKjnzcCf7RhIgfFwZWjOqEPy/2huOHj/3lIcMjfsG5aR1Y0dx1QINRWGDL3MNGPQdgyLXLdCwadvQlLy0xNyCFfmmFDfZdTltGdwKNQL5MOLyK52OLJX1hDl1VBkPo8JMPJIdkN236MiFxiyjvhfVjqDA/qQJmf4sD+SxFW7b6aUeCBAk2ZV+8Wbv+FVCpMcU9GAnP2e5Fx4SMiK2r3PD6tfzlHBoe004VTtMgyUL+lnMPh252tj0OV+27TlD9O28MVn873k25Ozk75O1w4KmJfw8R2truai6M7fO1ciRJTZcK1qZ77HSycmvKGLRjV8XR2dMUMLWvDX50aUPUU1x01Z0Qjsurtkrv7vWCfrbbaM5xSyy774iFJ5hdlxSR0O/rSOkjTTI2KWFslGv1zyQS8L4g
 V1JKFr6K
 Qve4z/3pykWyFR8NWUf8kpqXiUd2R3hpF5XBQZA6lFQFgKLP3uvZOWW3CEBAxiZzCI6PXunpBU0oWx4VElyTWRgJtDxbfYvGEz+aIvaQs4l93OzPLmZHOh1w/C84XT0IgjvCQCgSPFX/1okSi7Yoj5oOmJBN1mDziK0R78STp0OMVnGP9QKMcb9muOZDhp4EK0TjXmo13jWF0bKmGNTVEP58hmXZtGwRHLHP2iJ3ofOhgrJgteLtnxQfuCa4UHOgH3pJMgWYdvWBsuf7d8erPRo1tugmLFAYqKOpuL0BfjQaUVgHYz7+V75+5vpcFgDLMSW4l5G2wajHe+EUjT/+oNDAQvRLcKZAWXFaP6ulBpvrWBUcSjUHXmuxPBxY4+rnLlC4qyR6Q/XhaRaI8D+Sg5PcpgFnOVZq6i1wRx5p31o/QVtk/0o/xEgWs6pnJ/QA3jdCsAgtwgAa081HG8IxJiNDolhrwq0BsRUylL9MJAbd8QiCRA1c4hg6Is8WFr21Jw6b38KW1+jQfOin1QEt9Owp4Vkp8Y2fk/vOoKHGGJIyxNT6KmYhyH+pTqkN9KvT92ol9TWhqvK6XF3M3d4ufpXt/XnCsxKDvar0dCcgDAJEb0hGEDCD1msDR3ciMOqZRwmY8jT/JDfPVMnNAkIwj+hoM1KjkeweyKxlK592VZgNXQLarQ6QMhroOaPwu9IuKAvlHY9Zw/W/eM1A1/nOwOFu6ATvAlUw7h225M9ArSEKN0nMtFGQVfZ6ZuP2tpqy5isDany8nXygYvwoHEoU870CzJ1hIj5rcIo2I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 01:49:50PM -0700, Andrew Morton wrote:
> On Mon, 27 Jul 2026 06:50:19 -0700 Breno Leitao <leitao@debian.org> wrote:
>=20
> > migrate_pages_batch() unmaps each folio before moving it, and every
> > unmap runs the mmu_notifier invalidate callbacks.  On KVM hosts
> > try_to_migrate() ends up in kvm_mmu_notifier_invalidate_range_start() ->
> > tdp_mmu_zap_leafs(), which is expensive, so unmapping a large batch kee=
ps
> > the CPU busy for a long time.
> >=20
> > The loop already calls cond_resched(), but on PREEMPTION kernels that is
> > a no-op, and involuntary preemption is not a Tasks-RCU quiescent state.
> >=20
> > A long batch therefore never reports a quiescent state, and the
> > migrating task (e.g. kcompactd) becomes a Tasks-RCU holdout, stalling t=
he
> > Tasks-RCU grace period for minutes, which is common at Meta fleet:
> >=20
> >   INFO: rcu_tasks detected stalls on tasks:
> >   0000000055349ecc: .. nvcsw: 1157401/1157401 holdout: 1 idle_cpu: -1/5=
6 task:kcompactd0      state:R  running task
> >   Call Trace:
> >    tdp_mmu_zap_leafs
> >    tdp_mmu_next_root
> >    gfn_to_pfn_cache_invalidate_start
> >    kvm_mmu_notifier_invalidate_range_start
> >    __mmu_notifier_invalidate_range_start
> >    try_to_migrate_one
> >    try_to_migrate
> >    migrate_pages_batch
> >    migrate_pages
> >    compact_zone
> >    compact_node
> >    kcompactd
> >    kthread
>=20
> Well I doubt if users of 7.1 kernels and earlier want to see this.  So
> a Fixes: and a cc:stable are needed.  The affected code is quite old
> and might even predate the addition of cond_resched_tasks_rcu_qs().  So
> I can't begin to suggest a Fixes: target.  Maybe omit it and let the
> -stable team figure it out ;)
>=20
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -1843,7 +1843,7 @@ static int migrate_pages_batch(struct list_head *=
=66rom,
> >  			is_thp =3D folio_test_pmd_mappable(folio);
> >  			nr_pages =3D folio_nr_pages(folio);
> > =20
> > -			cond_resched();
> > +			cond_resched_tasks_rcu_qs();
> > =20
>=20
> Totally off-topic but why the heck was that implemented as a macro.=20
> Which invokes another macro and another and another and turtles all the
> way down.  End result:
>=20
>    do { do { if (!((false)) && ({ do { __attribute__((__noreturn__)) exte=
rn void __compiletime_assert_606(void) __attribute__((__error__("Unsupporte=
d access size for {READ,WRITE}_ONCE()."))); if (!((sizeof(((current))->rcu_=
tasks_holdout) =3D=3D sizeof(char) || sizeof(((current))->rcu_tasks_holdout=
) =3D=3D sizeof(short) || sizeof(((current))->rcu_tasks_holdout) =3D=3D siz=
eof(int) || sizeof(((current))->rcu_tasks_holdout) =3D=3D sizeof(long)) || =
sizeof(((current))->rcu_tasks_holdout) =3D=3D sizeof(long long))) __compile=
time_assert_606(); } while (0); (*(const volatile __typeof_unqual__(((curre=
nt))->rcu_tasks_holdout) *)&(((current))->rcu_tasks_holdout)); })) do { do =
{ __attribute__((__noreturn__)) extern void __compiletime_assert_607(void) =
__attribute__((__error__("Unsupported access size for {READ,WRITE}_ONCE()."=
))); if (!((sizeof(((current))->rcu_tasks_holdout) =3D=3D sizeof(char) || s=
izeof(((current))->rcu_tasks_holdout) =3D=3D sizeof(short) || sizeof(((curr=
ent))->rcu_tasks_holdout) =3D=3D sizeof(int) || sizeof(((
>  current))->rcu_tasks_holdout) =3D=3D sizeof(long)) || sizeof(((current))=
->rcu_tasks_holdout) =3D=3D sizeof(long long))) __compiletime_assert_607();=
 } while (0); do { *(volatile typeof(((current))->rcu_tasks_holdout) *)&(((=
current))->rcu_tasks_holdout) =3D (false); } while (0); } while (0); } whil=
e (0); ({ __might_resched("mm/migrate.c", 1846, 0); _cond_resched(); }); } =
while (0);
>=20
>=20
> How much nicer would it be to have
>=20
> static inline void cond_resched_tasks_rcu_qs(void)
> {
> 	if (some brief and efficient test)
> 		some_slow_uninlined_thing();
> }

Sigh.  It used to be so simple, then people wanted error checks in
READ_ONCE() and WRITE_ONCE().  ;-)

The point of rcu_tasks_classic_qs() being a macro was to avoid #include
hell.  But maybe cond_resched_tasks_rcu_qs() can be a static inline,
as shown below.  It builds, so it must be perfect, right?  On the other
hand, does that really help, given that cond_resched_tasks_rcu_qs()
gets inlined?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c77b1e02a93cca..9a741ce0588575 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -217,15 +217,15 @@ static inline void exit_tasks_rcu_finish(void) { }
 /**
  * cond_resched_tasks_rcu_qs - Report potential quiescent states to RCU
  *
- * This macro resembles cond_resched(), except that it is defined to
+ * This function resembles cond_resched(), except that it is defined to
  * report potential quiescent states to RCU-tasks even if the cond_resched=
()
  * machinery were to be shut off, as some advocate for PREEMPTION kernels.
  */
-#define cond_resched_tasks_rcu_qs() \
-do { \
-	rcu_tasks_qs(current, false); \
-	cond_resched(); \
-} while (0)
+static inline void cond_resched_tasks_rcu_qs(void)
+{
+	rcu_tasks_qs(current, false);
+	cond_resched();
+}
=20
 /**
  * rcu_softirq_qs_periodic - Report RCU and RCU-Tasks quiescent states

