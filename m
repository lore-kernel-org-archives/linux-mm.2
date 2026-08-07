Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE390C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 06:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD0786B0093; Fri,  7 Aug 2026 02:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7E66B0095; Fri,  7 Aug 2026 02:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD836B0096; Fri,  7 Aug 2026 02:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 924A76B0093
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 02:54:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF6EAA02E2
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:54:02 +0000 (UTC)
X-FDA: 85073558724.16.E40A0EE
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf11.hostedemail.com (Postfix) with ESMTP id E5C0A4000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:53:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of huangshaobo3@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=huangshaobo3@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786085641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+SijTlHd5AhxqNKcUNtNYXXpBBE/xXrgQw+KpdNqIQ=;
	b=JUxkeyrqbXgpNlKCeYmq8c2u9JI9DbP+zpbzENQalVP0hXhM/k1dWikjSlLRkrlVSbLbH0
	GzqfDDSsJAZ950N12RHpmQqjq/Hus+ZcxcJx69JbeMrttkg2kZ8n9FSMagbHqjQ8i6m7Vz
	fb4JN2HEsgVOtoEa0WUnkaCJdjsYOZY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of huangshaobo3@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=huangshaobo3@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786085641;
	b=dJs6BedOuvyZgly9JvHr2MUqQUpLywazd8IRgNgO+IyL0RU34CMb3qy9F2fHSYmgi1xQAL
	JeoQea7tyFs5Gi6h5mmRVc4VjsrX4Cp7YhujhgIwqJ6H6LioKQOH3y681yZyjUhjNhFFvr
	C+0K4+jra7QVxgKmkHljzv9nXKWpen0=
X-CSE-ConnectionGUID: /3w6XIUhRMmC8WuO2Pwtcw==
X-CSE-MsgGUID: ggvO1g2JSU2ZEXXUbZBaXw==
X-IronPort-AV: E=Sophos;i="6.25,210,1779120000"; 
   d="scan'208";a="184867146"
From: sparkhuang <huangshaobo3@xiaomi.com>
To: <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <bsegall@google.com>, <david@kernel.org>,
	<dietmar.eggemann@arm.com>, <huangshaobo3@xiaomi.com>,
	<juri.lelli@redhat.com>, <kees@kernel.org>, <kprateek.nayak@amd.com>,
	<liam@infradead.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@suse.de>, <mhocko@suse.com>, <mingo@redhat.com>,
	<peterz@infradead.org>, <rostedt@goodmis.org>, <rppt@kernel.org>,
	<ryabinin.a.a@gmail.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <vincent.guittot@linaro.org>, <vschneid@redhat.com>
Subject: Re: [PATCH] fork: reset pointer tag of vmapped thread stack before vfree
Date: Fri, 7 Aug 2026 14:53:51 +0800
Message-ID: <20260807065351.93659-1-huangshaobo3@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <anSVlVpUXrA8ra_z@lucifer>
References: <anSVlVpUXrA8ra_z@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.237.8.163]
X-ClientProxiedBy: BJ-MBX03.mioffice.cn (10.237.8.123) To BJ-MBX01.mioffice.cn
 (10.237.8.121)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5C0A4000B
X-Stat-Signature: 67zzxqr4tboaaqzbi3bxcrxnu9mux5bs
X-HE-Tag: 1786085639-452522
X-HE-Meta: U2FsdGVkX1/FvULVW8dAvo3nvHtlKGZ3UtQkbdPZoc6E4t4QOTQPYEyVfd7dQN/Rcr4nJtCA11cLUGI1gDtwGEyBMoqY7+FiT7hSMZnRq3OyNMZQnjcIXIBeAqYl0bZZKRwpHwjVO1Cx/5RjYfHtNJ5Js5tQ50h5R8IASD0eq+/k0/E+9NM3enBlnLkqsVKQOgawkeJPztUZEfgc+RhmCQN4zlqcVEMGm/JjBcvYsWVbn5vAK2fVrFzY2r0YP1gQjpyaBT/U2Mr6THDbjWEZ/fZWKjiw+qzhXEo4sVFAJdso5b/YNc8+tITkS5HXDlT38Hq/HUEuLpfHp+hYSenNHzvHWvGDya8bRIEbaHpjTAA29fHftJfqIWPdgNc2OT/h7W88okg7R7w2twRq1U0Fc3b2niYVBtkGPumH3AnTdGTiaYtnzWmmb0Nl2Aiuef6Xug03zKJXfZSRYX3oDzYr/pVsqYTPE2F7jJivE0nN1cszwAxVC1TAr8zNK4g6cqpUPGur5mvh3nWbuLFUs61P1XmCTVE7qvbMID6LJ2ifUfpGN4xIawXkxNqasR0EpGCraLTTp4hmIMymm1wtxycQ39h778LIs/jmqBMa7jZZOV8ZZGgyMl2ZShJYVpCKIhKq0RvAVSidnCH8oAIKeGEfpcf/0LXmwb+35glVb1i7dGC8OeVTbbFNenLfT04orH7aax9O/lGxfoIbmMTupY/gD/QOAtsK0DviGP31jJrpyjn+8hOmbw3Z4Frt0QCMRXM59UR8XtN+xSxkQ04GugRYV1tcUBv+vAQwgXf3LjhOmyidMNnjGUBZdpphGNlg0gAMiMWo0yNEleuKbRdU/GZ1+t9QtBRpRKzVKpN07YSQlVaJTlAOzg0dVS+NZIm/Ras/uGofjKB2fHnx3hSnNLjs0UYT76F/H0/bXx5s/fXb/nCCmFqsLPMblzxkAdlN8kHBuFgBb6laIfrCtZRX3oS
 irFEgMLq
 NcV7DT0TqJNjQkJPnmXj0LiAFvGDwX/nuNzcyaeLAzQPleMv5tD84xtzgVQAbX5ucPXnOeOZgY3WY+t38J3K+mmHxXaPk/adxnr2DXhYjr+aumJ6OVWWviJuU3IRKWmuskuplCe9kZ0G9lzFIvHQkfY5tLhmE6WzkKU8Yo90qBRRCwhVxT7tg9pmFNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,=0D
=0D
Thanks for the review. You're right on the process points =E2=80=94 I'll fo=
ld=0D
those into a v2 (real name, Assisted-by: tag, drop Cc: stable, trim the=0D
comment, correct the Fixes: target). I won't re-spin it just yet though,=0D
for the reason below.=0D
=0D
I want to be upfront about where the analysis actually stands, because=0D
I'd rather not push a fix whose rationale I can't fully back up.=0D
=0D
The one-line change itself is sound and follows existing precedent:=0D
c08e6a1206e6 already resets tsk->stack to 0xFF, and 528a4ab45300 does=0D
the same in scs_free(). A 0xFF-tagged pointer bypasses the KASAN tag=0D
check, so vfree_atomic()'s llist_add write to the freed region stops=0D
faulting regardless of what the memory tag currently holds. That makes=0D
the reported false positive go away =E2=80=94 that part I'm confident in.=0D
=0D
What I have *not* nailed down is why "memory tag: [ff]" shows up in the=0D
report in the first place. On the 6.18 android-common tree:=0D
=0D
  - At allocation __kasan_unpoison_vmalloc() tags vm_area->addr with a=0D
    random tag (0xc2 here) and sets the backing memory tag to the same=0D
    0xc2, so they match at that point =E2=80=94 the report is not from the=
=0D
    alloc path.=0D
  - c08e6a1206e6 resets tsk->stack to 0xFF (SP can't be tagged); its=0D
    commit message explicitly notes the stack *memory* still gets tagged.=0D
  - The only caller of kasan_unpoison_task_stack() =E2=80=94 which would wr=
ite a=0D
    0xFF tag into the backing memory =E2=80=94 is the idle-task path in=0D
    kernel/cpu.c. It is not called for normal task stacks, so my earlier=0D
    commit-message attribution to that function was wrong.=0D
  - page_kasan_tag_reset() only touches page->flags metadata, not the=0D
    physical memory tag, so that's not the source either.=0D
=0D
So what flips the memory tag from 0xc2 to 0xFF between allocation and=0D
the RCU callback remains an open question. My suspicion is the async=0D
vfree_atomic / delayed_vfree + page-reuse interplay during the reboot=0D
SIGTERM storm (the trace also shows page flags kasantag=3D0x55, a third=0D
value inconsistent with both), but I haven't proven a specific path.=0D
=0D
Accordingly I don't have a deterministic reproducer. The report is=0D
reproducible only in the sense that it shows up during reboot with heavy=0D
thread churn; I haven't been able to trigger it on demand.=0D
=0D
Given that, I'd like to hold v2 until the 0xFF source is understood=0D
rather than ship a commit message that hand-waves the root cause. If you=0D
or the KASAN folks have a view on whether the reset_tag fix is acceptable=0D
as a "stops the false positive, mirrors existing precedent" change=0D
without a fully root-caused explanation =E2=80=94 versus waiting =E2=80=94 =
I'd=0D
appreciate the steer.=0D
=0D
Best,=0D
Shaobo=

