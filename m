Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A48606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 12:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fwzpsWx1
Received: by kanga.kvack.org (Postfix)
	id DAE176B05B3; Sat,  7 Nov 2026 07:09:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5EAA6B05B4; Sat,  7 Nov 2026 07:09:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78BD6B05B5; Sat,  7 Nov 2026 07:09:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A69026B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:09:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59F111202FC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:09:12 +0000 (UTC)
X-FDA: 85408202544.05.4D5ABE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B551B120005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:09:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fwzpsWx1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794053350;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=esvZJHYREiteI43FT7jPdQ/u7/sXZjtksIY128uud3Q=;
	b=f7T1qTJNYCrptFXYCm81V6YuiSQ1Oxd7ekX2dWoFu8fMmDDyQwNqp9XSp772xY2KWyXpaE
	Ks06JXD4PaSYnWJcMTswD6B0Bzm25g8PjVPsteaEbPhIE8+cgmANOvzPdF0V0hLJ5I82oc
	r+LcLX6b+1k6LSE3GwIFvV7ClmYpP3c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fwzpsWx1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794053350;
	b=OF5zNKIOCK/cwv80G9r5jPFSZdStRTr8BCqusp/ew0h2uR7t/diR3tL5ZAuo/XA9HDSLIO
	C022saVxrAfYxJ3RUpGOdoqmE2o0oF+QxjYGzropb1e5fr0lQAkVMtKgLR/GUaWoJ5QnGR
	vYk42C52DHnuBNPDiR/XppmYXulTn8Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B106142468;
	Sat,  7 Nov 2026 12:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08BE1F0089F;
	Sat,  7 Nov 2026 12:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794053349;
	bh=esvZJHYREiteI43FT7jPdQ/u7/sXZjtksIY128uud3Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fwzpsWx1TYF5s6aqXbr7wgfjbvh1WKb6pTI6FUqOINWys2uHvZqtbq2DXEzRkqDYg
	 1sJGNo64GSjJzJ5uibxNPh+eht3MGVyMRBXYI7HZqn2P2+NZQu9noOQMz0R8injxTy
	 9T5pKtU+mCAeT2OOT6dIwBjJoQkhSBONgvNQGS/hQJcHH88daGX5Lwhv4+J7k4tce7
	 jzczoAJGoL2SQCuiA/2W6pBIN2CkY+zsCVYZzss+s72f6j+RrDupAF85h8MMkdh7Sm
	 wvFbV131TTeUM5ytOU+lsiFQUl4Jd6YjwvFK6vlzH3HwAO07A9SDi/JYTTtF9Kn8aJ
	 GbzTKulAfjt1A==
Message-ID: <sashiko-outbox-202871@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] sched/mmcid: Defer affinity updates until schedule-in
Reply-To: sashiko-reviews@lists.linux.dev
To: "Weiming Shi" <bestswngs@gmail.com>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R . Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Kees Cook" <kees@kernel.org>
Cc: linux-mm@kvack.org, "Xiang Mei" <xmei5@asu.edu>
In-Reply-To: <20261106120846.2405936-1-bestswngs@gmail.com>
References: <20261106120846.2405936-1-bestswngs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 12:09:08 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B551B120005
X-Stat-Signature: s3mgn9dmg4sbnys6dku41gz7jjwzpptr
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794053350-760990
X-HE-Meta: U2FsdGVkX1+P3rsy8njWF/H8qe7yGVcAVUcWlxs/J5NJc9gc1AS8+lJ1cSscli17ZJxl9B9uAvyiVSG/CmMWqI41U3a08zMlbK059U7xKvvTZ94YQYYvVujsOu1kUXTGXf0PtBs9b8Pmy2sWLMSh/cSTZkAHEx2kqRuKs0yzEqopoy6GXN55NYRsh9XF5z5JyeLfmMBGH0Qq+ilsRzE836fAGxT8//s4qMYeyhIQr5nDtu0ZdE26uTt/w0+IJckzH8+rpBVGYJni2t668dR2qVf8OlDXLCiFr7k5+WH4L0L6SOSM/zcgcR9drq6oaBVpAxe1DhZW8CTt7SRKRGYFjsdqokmO/vI5BY11hNLqvMcUWKmD0I2KhMCMhNpGBBsYcqpaXAhIIRhuIBYFZx4eok3c7fYiqrY/gvehBKOlEtGcHipE9Y0bhqVJB5d1dVKzO8dgJh8GauO5CrKsyXPhvF1oZoPeskAw5lQwCfjpKMpV2gdJLToYz/trx99F3C4brs2HVPpDBVuYGcqZILdw/CgbIDJfr6pEQ8AWXV8j+x4fnCMfZ+8BxH9i1iaKm0ePsYGpMjr8A1tvV1x5018dZAnZKeTBy/xOdZYLHdpRayqbTAu2hP+2q2S9TB0PAp9g9zA/mikEc41AU5a96RnCFa3K1PVXJ1Xys5F+synT6+Hp9qDdiS1VFffUbX894jcsXLhaklsIvWCRDZtGIRRDQAssREQ6Ndyq3C+t1hwVLsMoWpCHHsSG2vnIgSq6lU6+w8PGYcba8LwDvOW/psaYRMBO4VEBlsI0VTnK1LMknUzCdchruLgekVIwq02TnCdHV8yE0529ugaDg/EMTj3jVKorgd5git2xCOwPwPuPy4HdwXuqaAyEb2y3PJsDKyaz07lqrpp1tFs6JH20NAsfn6OYiNeB7km5iJTbncwLXMDxg3J/eZTpy/AKExO5Ye3yFYK3VRuaFuOE7vS9rM7
 2ULD53nC
 QZzFvD2le8pVnt85/xbKdBlkbXyH8QpULcGyE8kNdFTBg1FCNLa+L/vbtoTXMcyVSHUU+9OAKE2Ou9tG0g4EaxDabDwNsallcGEQ3UgZ20/rmPaQHyJ4utLG3Tpz2R0x+9YXMRYS3S1zpDfvP4iIq5D/7omRoIzvx4pAUFeG8iM6tBqKiQ5ZE54kD1itGn92cx1lj6G4ILwvqZ+M+04XJ9Hviz2H5AzmULNUWouV5lrs/inHAMw//8pnfIuH+gUEle0FXWOVqhC9QjttNFeST4BKZsRUc5u6xmzjZxZinWXG74P3qRzY0BicH5yg5Sytg5g9D/RmyXuZ0dM21ydG6LHVBKeK4B90QVBKf1nuqMEccIsQ+PZZ/oDa4HFKJS+p5h9wvM4y0Y6ulbKHgXeUC1V9oFDZc0bcpZg/pOZO/CrrXvmlTpzbMtWUOjNCKq53nA+OWNd32ZH0/c8hLKjZf44BxQnNMJ9lVFO4AFAGE4tjO5B84B+B6/5zq2qVl2ArWtUgTfg4/zpjiZze099ayX3Zy0pnH01H6kfDCoYenE8eBwcoEpwdQzHDGuDNEGAz3r3Ho+HGWazPIY5JskdPLuZN4/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] sched/mmcid: affinity expansions lost or delayed by
  mm_cid_schedin() deferral
--

commit 8130aa795d763d1b0e9fc8f80bab96df5fedde9e
Author: Weiming Shi <bestswngs@gmail.com>

sched/mmcid: Defer affinity updates until schedule-in

This commit defers MM-CID allowed-CPU mask updates from
set_cpus_allowed_common() to mm_cid_schedin() and sched_mm_cid_fork() to
avoid accessing a remote task's mm while it may be replaced and freed
during exec.

> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 7d2ec527b8a25..8e8934376e340 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
[ ... ]
> @@ -4132,6 +4139,10 @@ static __always_inline void mm_cid_schedin(struct =
task_struct *next)
> =20
>  	if (!next->mm_cid.active)
>  		return;
> +	if (unlikely(next->mm_cid.cpus_allowed_changed)) {
> +		mm_update_cpus_allowed(mm, &next->cpus_mask);
> +		next->mm_cid.cpus_allowed_changed =3D false;
> +	}
> =20
>  	cpu_cid =3D __this_cpu_read(mm->mm_cid.pcpu->cid);
>  	mode =3D READ_ONCE(mm->mm_cid.mode);

[Severity: Medium]
Can deferring mm_update_cpus_allowed() solely to mm_cid_schedin() delay or
lose affinity expansions in mm_cpus_allowed(mm)?

When a running task widens its affinity mask, task_cpu(p) remains in
p->cpus_mask, so affine_move_task() returns without migrating or
context-switching p.  Until p is later preempted and scheduled back in,
mm->mm_cid.nr_cpus_allowed, max_cids, and pcpu_thrs stay stale for all
threads sharing the mm.

Because p->cpus_mask only holds the latest mask, any intermediate
expansion that is narrowed again before the next mm_cid_schedin() (or if
the task exits via sched_mm_cid_exit() before scheduling in again) is
never folded into the growth-only mm_cpus_allowed(mm) mask, leaving
max_cids capped too low or triggering wrong per-CPU mode transitions.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106120846.2405=
936-1-bestswngs@gmail.com?part=3D1

