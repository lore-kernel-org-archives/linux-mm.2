Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF7ACE67A70
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 06:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3F86B0005; Tue,  3 Mar 2026 01:37:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71DF6B0088; Tue,  3 Mar 2026 01:37:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70BA6B0089; Tue,  3 Mar 2026 01:37:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93B4B6B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:37:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D4AD1604CB
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:37:47 +0000 (UTC)
X-FDA: 84503796174.20.0EDB9B7
Received: from cu-ua11p00im-quki08153402.ua.silu.net (cu-ua11p00im-quki08153402.ua.silu.net [123.126.78.67])
	by imf29.hostedemail.com (Postfix) with ESMTP id CF2F7120005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:37:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=PAPTsQBS;
	spf=pass (imf29.hostedemail.com: domain of bfguo@icloud.com designates 123.126.78.67 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772519865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=utRYzMHUQLQfly7gEeHf1ufs6qxQ0rMWwUvat19f+qI=;
	b=4cHbOPbS+V/6H31vVsUlJDp4xfpzsSmB52HLgeQG8N+WI3MXs1X116C75qBqr//1mIEV1V
	rcOvif8H7mO1UjduQQ3ZZ5PfsqiRrEInpgMJ9hgd1kJfFPkhSMnhuHao3Wqy/fzAYpGzMG
	cco8V/M/QZg/SNAbq5uJrnDIgfy3M5Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=PAPTsQBS;
	spf=pass (imf29.hostedemail.com: domain of bfguo@icloud.com designates 123.126.78.67 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772519865; a=rsa-sha256;
	cv=none;
	b=tYsL+x5aPEipmM/OfRzKqNeRwAcXVRWvHs1O9Lnb9ct32gftUzT2PRVgUWFhmcWFFnrQDV
	wZYz8+COpCzoOcYEoOiDGliSlKKffhVDIKX37YwnA9Cd+QHQaQmXysGpFvJmCMkrI5XAby
	5um7y70rc1W1gER9+hvfU+HdaOE0J5g=
Received: from smtpclient.apple (ua11p00im-asmtpcmvip.ua.silu.net [112.19.242.76])
	by ua11p00im-quki08153402.ua.silu.net (Postfix) with ESMTPSA id 67DAF2FC000C;
	Tue,  3 Mar 2026 06:37:38 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1772519860; x=1775111860; bh=utRYzMHUQLQfly7gEeHf1ufs6qxQ0rMWwUvat19f+qI=; h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To:x-icloud-hme; b=PAPTsQBSP9c9NVuGlaM8UuOT/zrj9BidWJ5dx7g5LETDVA+388GCg34GrO1A72q1GWzjS9tBAnGdizTD/08zC6oXBJZc6raM+JKGjf+UTBFMjoKn+XgFwWzlLa6KA0H3lnrMgWfSp3nVQtemDNAlxR4y3285Tw81xnXCMzvAw5dM8y39OT8dOtJt6HvoOb3mTtIofgJFGQU42fpKT2ZcAgnDZ8o6DGXiDTehEUFbsvZtON9ZsuV4FHyg5T6tRi/JRGunGbZk3f/GVIyhY4swy/p5Spo5OXU1J85soim/Zoe8GODwmQ+aUQK/DZuwqum4mI1gvrigFvtc0ja/h9ir2w==
From: Bingfang Guo <bfguo@icloud.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
Message-Id: <76ADAAC7-7616-4D84-9EF5-32DE7B350B1B@icloud.com>
Date: Tue, 3 Mar 2026 14:37:27 +0800
Cc: 21cnbao@gmail.com,
 akpm@linux-foundation.org,
 axelrasmussen@google.com,
 BINGFANG GUO <bingfangguo@tencent.com>,
 lenohou@gmail.com,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 ryncsn@gmail.com,
 weixugc@google.com,
 wjl.linux@gmail.com,
 yuanchu@google.com,
 yuzhao@google.com
To: laoar.shao@gmail.com
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA0MCBTYWx0ZWRfXycGpZYFtvdcN
 8vC2TWJlnE7n/Gdf10lYsU2QlluAi9K3IoEV0YDSNbZP89eip31t85F0eAfpK/VvaZKVZRz2mrf
 Y2asGudROylhjd2MqOLpbhaylH2BnpmiMVtKsDQ5BAtzt0X7ECzjQ4XIzF5DoWbnF1KCtvGWqI4
 IyEhlP7+LS7bAxf2QqwT/59+3Wv5HMlovybfGCyaTkzPP99JK0pA/JnIOGUVO19jSZNdsv3y7WX
 slIEEtdaqe9IOdKMBV10psV+PoqWS1z3HHgCrt+q2IXh2Ba/optMthpH63rm/oIqJPruN0PPL4U
 GtuX+RM6GTOpkKwdMjoiE44COLsF3gRnst1TNKQnQ==
X-Proofpoint-GUID: t_YeOJEN2vzKaZesP1ybg_GEYwJGIIHo
X-Proofpoint-ORIG-GUID: t_YeOJEN2vzKaZesP1ybg_GEYwJGIIHo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 clxscore=-2147483648 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603030040
X-Stat-Signature: tqux5fswmqogh9u5mu385ro3rng8mdwf
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: CF2F7120005
X-HE-Tag: 1772519864-68135
X-HE-Meta: U2FsdGVkX1/8ttU27NbncFuv0hyUvOtMw+kFSMWVJHQ3lwZA3LbW1bnf//mAPsNDuBGG3t8pz6XXxpqHKCP17RHmgKrc8KgXNiJ46DavxYQ4MCwTwCroYr9mTZnYzyECUP1dXxvWHs7bzlct5hlCU/uKOSfqV/J25mF7EyMv3vOS2FI9EZoXKtkMbuWt+1UJILmxHMmhjl/q+KQwnbItyhgzn7ueOIwimP4tYlug8tsJdwGp9ZkZDC8OZvoIuRp301P4QDh0P+uqyRDnfKdsUSHnLU1hW0SNNbIHOjpTRU1yWUrvzhB1eCjO/klZ7uNGrT3uwehU29KbYMSzaCFmYiTvpHzDE8fOQuiwX165rSM9bspQ9WLoG+r4/wTJBhIKXDuV+fo1MpyrVrNa5Hf6Xb7LiF++nY7mh+IsdXWb8wxQF8l9VpdkW3VeJ0MmFk3xYGb1vjQqh93KUkReXVkoMcmt15gkHI80DQB1cSd4hXhi1q1PxTt1VgaL4A30i9FWkQ3vSzPbvvcTGmBcdm9rSQUGYRclERy9Db1iQjmSpYEMf+g437RCwA8WxEyvVgVCZzli21fF0ucOZuvFM11edrO0zB7wm0UfWQ/Hb53r0VjKklrI+4oI7QvaQoQ6/Yd/MiMGanMmO/zIwc5rrx4lO+vDjNFIYKQkg0C30jto+flfezOScvuEcr3A3/h7bkitabinXlyVqbU+vsb9NSNKnNfk7AzyotzyAuzc99aCUBHh1/apGoRPzaRXWNSDYhcTtoxpri2CNQ/qnclhWIJnfjslbuUWlgRHFLw1gagiu8Y+XKvtwHJDw8KVRSlPd8JrQiYg3KNaEhWjtErFlUec4nhfuCZRy2UROR2kDLV7I6YFyLDVY27hXInthhExQePzexD/1s0GaDqaFr3l8lBCZRVl1AvACjDm1BkQyfGue9BXx0Pv/9x5LtizqkTyv6hY9wrQ2HwkNFVfMP15rRz
 ZUZjyx8t
 dNwWWfowjPeMpfOcrq5unWqPbfg2Z3OBWI68xjnUu2GOPRnuhBQ60xJbc0PdISrzgMlyjYqNQ/KUxl0sUc/IzLpQ+l+UL9vrc/HgHQk2SXHY9gqcBcpZ/6ZXzOZ3zXITgsH7spwxyy6SEI2UoyeY8t3VscIRaeuQhGVAx6hP0nFSX8Tk6hEP1FMIRtCRywxjfD80/PabIE7+9Uw4JM+rd05/iSKSU1hBaWxC9ti7dMs4qsRYa0dY/FBW7VGFc7DLu2dw4kECeLtPQkBqCybl9uulH8RiebIID8f4AUWUnVZ1qagcz20R/ArPB4OW7OQcYoMUPVdqk9A1/dy0S9jSraBOA+2T2N4NvI+UkeineZJRupLd1uae6b7UywAkzfNvzUiyW2FyPdw2Ia+QrhoDsmeB2i7gcp4cW88V43drNJiY6gq+to2EAegblpsSfomu3EzASpbovg85Ful8NmrAwp1HdBMKo1CTOZH5OJOvzx3EvhsOnWLMoJLiLJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all. Thanks for inviting me to the discussion. I'm glad to join you =
and share
my ideas and findings with you.

On Mon, Mar 2, 2026 at 4:25=E2=80=AFPM Yafang Shao =
<laoar.shao@gmail.com> wrote:
>
> On Mon, Mar 2, 2026 at 4:00=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> >
> > On Mon, Mar 2, 2026 at 3:43=E2=80=AFPM Yafang Shao =
<laoar.shao@gmail.com> wrote:
> > >
> > > On Mon, Mar 2, 2026 at 2:58=E2=80=AFPM Barry Song =
<21cnbao@gmail.com> wrote:
> > > >
> > > > I assume latency is not a concern for a very rare
> > > > MGLRU on/off case. Do you require the switch to happen
> > > > with zero latency?
> > > > My main concern is the correctness of the code.
> > > >
> > > > Now the proposed patch is:
> > > >
> > > > +       bool lrugen_enabled =3D =
smp_load_acquire(&lruvec->lrugen.enabled);
> > > > +       bool lru_draining =3D =
smp_load_acquire(&lruvec->lrugen.draining);
> > > >
> > > > Then choose MGLRU or active/inactive LRU based on
> > > > those values.
> > > >
> > > > However, nothing prevents those values from changing
> > > > after they are read. Even within the shrink path,
> > > > they can still change.
> >
> > Hi all,
> >
> > > If these values are changed during reclaim, the currently running
> > > reclaimer will continue to operate with the old settings, while =
any
> > > new reclaimer processes will adopt the new values. This approach
> > > should prevent any immediate issues, but the primary risk of this
> > > lockless method is the potential for a user to rapidly toggle the
> > > MGLRU feature, particularly during an intermediate state.
> > >
> > > >
> > > > So I think we need an rwsem or something similar here =E2=80=94
> > > > a read lock for shrink and a write lock for on/off. The
> > > > write lock should happen very rarely.
> > >
> > > We can introduce a lock-based mechanism in v2.
> >
> > I hope we don't need a lock here. Currently there is only a static
> > key, this patch is already adding more branches, a lock will make
> > things more complex and the shrinking path is quite performance
> > sensitive.
> >
> > > >
> > > > To be honest, the on/off toggle is quite odd. If possible,
> > > > I=E2=80=99d prefer not to switch MGLRU or active/inactive
> > > > dynamically. Once it=E2=80=99s set up during system boot, it
> > > > should remain unchanged.
> > >
> > > While it is well-suited for Android environments, it is not viable =
for
> > > Kubernetes production servers, where rebooting is highly =
disruptive.
> > > This limitation is precisely why we need to introduce dynamic =
toggles.
> >
> > I agree with Barry, the switch isn't supposed to be a knob to be
> > turned on/off frequently. And I think in the long term we should =
just
> > identify the workloads where MGLRU doesn't work well, and fix MGLRU.
>
> The challenge we're currently facing is that we don't yet know which
> workloads would benefit from it ;)
> We do want to enable mglru on our production servers, but first we
> need to address the risk of OOM during the switch=E2=80=94that's =
exactly why
> we're proposing this patch.

Yes. I believe our long term target is to integrate the two LRU =
implementations.
But for now, it's important to keep this dynamic toggling feature and =
make it
robust and work well. So if users are willing to try the new LRU =
algorithm, they
are free to enable it after system boots for testing, and disable it if =
they run
into some trouble without worrying about OOM and other problems. =
Therefore, we
can have more users and potentially expose more problems related to =
MGLRU and
fix them.


On Mon, Mar 3, 2026 at 1:34=E2=80=AFAM Barry Sone <21cnbao@gmail.com> =
wrote:
> 2. Ensure that shrinking and switching do not occur
> simultaneously by using something like an rwsem =E2=80=94
> shrinking can proceed in parallel under the read
> lock, while the (rare) switching path takes the
> write lock.

In my opinion, completely banning others from reclaming seems to demand =
more
than needed. We have many huge servers with services running in =
enourmous memcg.
In such case, waiting for the draining to complete may take so long =
(tens of
seconds for example) that the service get many timeout failures. But =
there's
high chance that reclaimers can still reclaim enough even if the draning =
is not
completed. So maybe we can have concurrent reclaming and state switch =
draining?



Regarding the discussion, I would like to propose a slightly different =
approach
that is already in use in production. The proposal mainly focuses on two
practical considerations:

1. State switching is a rare operation. So we should not penalize the =
normal
reclaim path or introduce more locks for this rare case.
2. We should avoid introducing long latency spikes during production =
state
transitions (e.g., switching on live machines).

The downstream solution is very similar to a combination of all your =
proposals,
but with some radical attempts to try to avoid sleeping therefore reduce =
lags
from waiting as much as possible. At the same time, we keep a =
last-chance wait
to prevent early OOMs from happening.

We use a static key to indicate that the state change is in progress. =
All
operations are encapsulated in that slow path so no extra overhead for =
the
normal path. If we are in the draining process, we first try reclaiming =
from
where lrugen->enabled says we are, if we still have a lot of retry times =
left.
With no retries left, simply wait until the we pass the race window.

--
Thanks
Bingfang

--
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 614ccf39fe3f..d7ff7a6ed088 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2652,6 +2652,43 @@ static bool can_age_anon_pages(struct lruvec =
*lruvec,
=20
 #ifdef CONFIG_LRU_GEN
=20
+DEFINE_STATIC_KEY_FALSE(lru_gen_draining);
+
+static inline bool lru_gen_is_draining(void)
+{
+       return static_branch_unlikely(&lru_gen_draining);
+}
+
+/*
+ * Lazily wait for the draining thread to finish if it's running.
+ *
+ * Return: whether we'd like to reclaim from multi-gen LRU.
+ */
+static inline bool lru_gen_draining_wait(struct lruvec *lruvec, struct =
scan_control *sc)
+{
+       bool global_enabled =3D lru_gen_enabled();
+
+       /* Try reclaiming from the current LRU first */
+       if (sc->priority > DEF_PRIORITY / 2)
+               return READ_ONCE(lruvec->lrugen.enabled);
+
+       /* Oops, try from the other side... */
+       if (sc->priority > 1)
+               return global_enabled;
+
+       /*
+        * If we see lrugen.enabled is consistent here, when we get the =
lru
+        * spinlock, the migrating thread will have filled the lruvec =
with some
+        * pages, so we can continue without waiting.
+        */
+       while (global_enabled ^ READ_ONCE(lruvec->lrugen.enabled)) {
+               /* Not switching this one yet. Wait for a while. */
+               schedule_timeout_uninterruptible(1);
+       }
+
+       return global_enabled;
+}
+
 #ifdef CONFIG_LRU_GEN_ENABLED
 DEFINE_STATIC_KEY_ARRAY_TRUE(lru_gen_caps, NR_LRU_GEN_CAPS);
 #define get_cap(cap)   static_branch_likely(&lru_gen_caps[cap])
@@ -5171,6 +5208,8 @@ static void lru_gen_change_state(bool enabled)
        if (enabled =3D=3D lru_gen_enabled())
                goto unlock;
=20
+       static_branch_enable_cpuslocked(&lru_gen_draining);
+
        if (enabled)
                =
static_branch_enable_cpuslocked(&lru_gen_caps[LRU_GEN_CORE]);
        else
@@ -5201,6 +5240,9 @@ static void lru_gen_change_state(bool enabled)
=20
                cond_resched();
        } while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)));
+
+       static_branch_disable_cpuslocked(&lru_gen_draining);
+
 unlock:
        mutex_unlock(&state_mutex);
        put_online_mems();
@@ -5752,6 +5794,16 @@ late_initcall(init_lru_gen);
=20
 #else /* !CONFIG_LRU_GEN */
=20
+static inline bool lru_gen_is_draining(void)
+{
+       return false;
+}
+
+static inline bool shrink_lruvec_draining(struct lruvec *lruvec, struct =
scan_control *sc)
+{
+       return false;
+}
+
 static void lru_gen_age_node(struct pglist_data *pgdat, struct =
scan_control *sc)
 {
        BUILD_BUG();
@@ -5780,7 +5832,10 @@ static void shrink_lruvec(struct lruvec *lruvec, =
struct scan_control *sc)
        bool proportional_reclaim;
        struct blk_plug plug;
=20
-       if (lru_gen_enabled() && !root_reclaim(sc)) {
+       if (lru_gen_is_draining() && lru_gen_draining_wait(lruvec, sc)) =
{
+               lru_gen_shrink_lruvec(lruvec, sc);
+               return;
+       } else if (lru_gen_enabled() && !root_reclaim(sc)) {
                lru_gen_shrink_lruvec(lruvec, sc);
                return;
        }=

