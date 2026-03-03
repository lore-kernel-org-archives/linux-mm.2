Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A13BE67A96
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A11D6B0089; Tue,  3 Mar 2026 03:28:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34EE36B008A; Tue,  3 Mar 2026 03:28:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230C56B008C; Tue,  3 Mar 2026 03:28:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11F216B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:28:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F4F18B5BF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:28:04 +0000 (UTC)
X-FDA: 84504074088.12.B279FB2
Received: from cu-gy11p00im-quki07202302.gy.silu.net (cu-gy11p00im-quki07202302.gy.silu.net [157.255.1.68])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8E36180002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:28:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=mAVYbdvl;
	spf=pass (imf06.hostedemail.com: domain of bfguo@icloud.com designates 157.255.1.68 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772526482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCApGIaGSKZC8cCTCH+72YgshK9JNaLJszY1i6IDUso=;
	b=oHvtsEA/XhIgW0HjQM/mJhgL0HC/0syTHDvhjjzjyOWZG7BpHQk8wFQzo+wls5CCN6C/7J
	aHT8mqhTQfUugVNThC+/bxQSvWYWLHZ+3SHVipNFzQc+x16HMsMLT3S4CqtvOfQtyXWjVn
	ZZzsY/ief3KxYciBfyPUyOKmqOVaj3I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772526482; a=rsa-sha256;
	cv=none;
	b=AuUyugfMtcqkIHhMslskZcSMlxu7LyEiTYcmtv01h3HIREdO6o7qBU7p5WBeh6913LhfbN
	YkhtxSwKnBMR41mzGzf2B74m4Ln2Z5tSM7NdFciFYYKADUA36mVWMniTasQ4pAQrPHXG4J
	qtSs1EdAtIDaMrlty6PUa7ULjtK2R0Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=mAVYbdvl;
	spf=pass (imf06.hostedemail.com: domain of bfguo@icloud.com designates 157.255.1.68 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from smtpclient.apple (gy11p00im-asmtpcmvip.gy.silu.net [112.19.199.76])
	by gy11p00im-quki07202302.gy.silu.net (Postfix) with ESMTPSA id B6DB821400C0;
	Tue,  3 Mar 2026 08:27:52 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1772526477; x=1775118477; bh=YCApGIaGSKZC8cCTCH+72YgshK9JNaLJszY1i6IDUso=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=mAVYbdvlGt2XJPyv8WVaRi53G8y5sboyGK3o8S6ucnENvfVhhu6yRqgpADxL4rqsUZBhx8QPvKEKDubg/Vk7hl+UM2ITtfqFP2FdSTTFhSZ0loQWontGch39Rjp+7AKu1sHnszw4nDl6a6L61tPczwhLTUxH7kwxK7mpryN7RpyYcqGR0JgLYoF9eR65XYEPo0lvCEzYTl8VFSiBGZjZWzESr7WYBdGErDH6dG25lwiiB42Iydv58lyjBVW2IXK0+CjZ/77bY2Zt3f37wrbsguFzrPqdtGKEFVYRPMyoxcAVNw0MMn5RyxkE4vHMTdRCHRiIsbDNbqRDbcI1w3UnZw==
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
From: Bingfang Guo <bfguo@icloud.com>
In-Reply-To: <CALOAHbC0XbvG4OCy94j+ZUyTZt65QB0Y=p1UwKvGcsgcWKy7mg@mail.gmail.com>
Date: Tue, 3 Mar 2026 16:27:40 +0800
Cc: Axel Rasmussen <axelrasmussen@google.com>,
 Barry Song <21cnbao@gmail.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Kairui Song <ryncsn@gmail.com>,
 BINGFANG GUO <bingfangguo@tencent.com>,
 lenohou@gmail.com,
 akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 weixugc@google.com,
 wjl.linux@gmail.com,
 yuzhao@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <71281163-F081-456F-AFB0-37DC0470850A@icloud.com>
References: <20260228161008.707-1-lenohou@gmail.com>
 <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
 <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
 <CALOAHbCma=SW4nu_GPv_pbuuXv1V5JPB-9cA3z1TeemWqU68tg@mail.gmail.com>
 <CAGsJ_4yAkaqqzSu7SS=_fgZ_AQCqtbv8LmuPGCb7SiFpGk4csg@mail.gmail.com>
 <CAMgjq7AkvgzW96-JQzEg5c4oW0cMsjPHcCnukCUZXgSvXL4-DQ@mail.gmail.com>
 <CALOAHbB3rQ2b7ABqFegt2afYRL7KjpWREucrhOYfTT=onV1+Gw@mail.gmail.com>
 <CAJj2-QEO=9Nt+HP6m=xtFD8qcXCdGCRmESmcs0haeiMdqqTA1Q@mail.gmail.com>
 <CAGsJ_4ynhyROTMsy1m3AZNsAzFsjZY3EYpSOSTLR0dQSxO+akw@mail.gmail.com>
 <CAJHvVci8nc-yTHkAbSEQQtqkRvgATJWcSTwBCY49A5W4AQcd7Q@mail.gmail.com>
 <CALOAHbC0XbvG4OCy94j+ZUyTZt65QB0Y=p1UwKvGcsgcWKy7mg@mail.gmail.com>
To: Yafang Shao <laoar.shao@gmail.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA2MSBTYWx0ZWRfXwDAoalcqZKk8
 NLmHOXQJEf9qNZFhXgDZXh/S6cnvYNsETHQod2A3KNr4DIVcU+aC2i5K7/4xZGZM7DtnJGWgVWI
 Rkh9Zx0VKokLd6xehAcB1Iac/FvhnssFB84T17I91AKy8weJtYhWnF20i8xPvLsRpXYH31DuQ6I
 Xar3s/TxfLCFBRmS4F7Xt7sR8NTk3ZPaGU9ZIfcX31zDYVkRjXzDp7Lo8B4byZW7nlo/uIlDM2K
 WxDuSD0ChhQ8nHr9BVdUx9VdX9jDtGoNAMNiv1787aozu+/+gfq4+H7kk7FZkEncrOVxmy24Yvs
 cP/UBmjJCjYc4V0a/DbFxLwirhboJn1itj7VtGvjA==
X-Proofpoint-GUID: -yPNnIHMyVVustWlfOAtOyxfNONiM7Za
X-Proofpoint-ORIG-GUID: -yPNnIHMyVVustWlfOAtOyxfNONiM7Za
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 clxscore=-2147483648 bulkscore=0 spamscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603030061
X-Stat-Signature: 7icwxjsxutoo9m4x1escnrmu5hhtkktx
X-Rspam-User: 
X-Rspamd-Queue-Id: C8E36180002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772526481-168374
X-HE-Meta: U2FsdGVkX1/YdGmZrLfFgdkbv3q4wVSt/dsPy10XtvVXvzVFGf6e+hCr1u8yiGCbZdcu/3REUVhvve+IhPdiDoQkGZKRzx1Y3ROSh3hDXzq+nD1ZG+mw5V7B85gFdRfPIvR7gd6EVogvTGeE+4I7KMKhCyti+Na7b2K+LcC5D8j1VUEoZBfU+OZd7kZISrrKEKXfGtfVtIfMbTOiGc9blPnD4ZBUd9zWcmaEd8FGQVRrRFGUIfdJXiIA3DIvVPKjfFdMBvl3bglP7Aak+eEC4+wiqgXXNttwfyvo0pkgkY1K08dM95Ml9G4W65Czmo67HrIarY8SlcketoadAR4ucFWPaBWELLBhVNkCBZlM0FhD7nXFKDVXTseV4zj7fnL/b0mET2Ow55Hv+o4FfTLQfr5QzGuOeUzB/MOI5eS5rxVYtvmPb7vdZT38rknsKoWsSRE5l4siHkfMeSPYdoGxQRjV7HVUl93w5AcrkZsUEDOshfZDnHX97Mjdmc7UlRj3xP6568aJIieBjECvJig1IS+Kf0ALEPB3tKtt4f5NXHWOb9iej2a3qbeesVWzD7SD6f+KzSmNrCsp2LVPLC3WiKtaU+4aSUaZ5RKSc0wCRp3LnaFnN8UeEtA7I8vZHpL/HQxvhYHNZw73dQa7awzr1MsfiqfJC82Hi8hi3NpPpoU3MCFKvotGysmgmMpvtuqD29Ytwfy7A1PSZd+S6iqLmbYtGZfteTybZ0K4Nuc3j3dCpanbFrSBLaWwVC13ENSAZ7XcARS2xkspPhhjkCovT4Snfb7KY6bMzzBlnJaJEDpDeETVP+HN8BzX8oRuvkmfWoF6L/c92pv1V7d42qHMcduKstWC22J4r/ceU/kjq75D4f1N+Hv4kdTISk26xiMzo17JsTRBkhGefm/23hjmCinJiqas6NdDAs0tgeKWmqfNhibAQ50eF978ME1nYAR7TndR6VCgQY5IoCxIpww
 lI07s/Sf
 GxF7CcKIj+dEFZuZXziga66qsPEoSG8E8IyM+K1JeKoHQrB3hwqKo+OTQvGqizcaFAPFtfCrW4GAX0DKDhaSFYz798stCSSrLN5tAvY/lZt4aHEtbDLzsIE/XJp2R35PNqe5drJCRorBlH9Cc7KYcQDkmTSJQnrHIfplkgKIlCDbjGfI50Kv1En1UU2xE4doJTPOGhZeuGpjwvqeDd+xBl4P3PkiqUT2FNcVyYOdUpII1oNvqGQu3/lP/TkBosUMe1zA+BJBbdTArWpG3y27+RnSGw+z8k1Jx+EOA9DZrWv2ub9CGyiNY4ffF6G7raJ2W+QjgybVQCnNMoiC+9fyRCs7RHtWzpyjc4iznTbN2FFMuyzNvXr/sLVVWYzqX05I0GcVyFg07WGPqCQtxfUXOnmOOeW6o8sVumaM676spyyNiMEaFNbUQIQq5orpdzv4WRwoyaJbzvvthmrJbsfPyVoFKBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resend due to missing In-Reply-To header.

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

