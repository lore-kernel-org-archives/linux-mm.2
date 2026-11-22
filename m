Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C980606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 03:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mS/ND6mc
Received: by kanga.kvack.org (Postfix)
	id 05B066B05B3; Sat, 21 Nov 2026 22:06:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C196B05B4; Sat, 21 Nov 2026 22:06:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3CBC6B05B5; Sat, 21 Nov 2026 22:06:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3B7D6B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:06:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C41AC0633
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:06:11 +0000 (UTC)
X-FDA: 85461266142.10.BDD47B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9E14A1C0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:06:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mS/ND6mc";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795316769;
	b=sxBuokEASbjUmsce8rtrluZrsEcy0sO8amLJdqI9sNeBrZGHPpUENA3997CD3A5zliGCc/
	l8VF3NiPa36DQdKOnvc3r2uS/VVkmik04DArleeDhjUQp6/ln+Rk8lL0IJUQR627lXrFBE
	LRTErwKZWmyq1Ks1sdt8ayANjnUJKQE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795316769;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nuth1ESHpISoM8f5XHfuVs3cajbbWyp62tE4i6qZmvs=;
	b=cWUsuZcJIrr/igsKojVkxvKaZv+cq0rcG4aVT/TTgTUymqn8odeJnpOCYqZgR5jVKG86JP
	i/k/0XSTkpgwnFgTx76aYK24WqYitFj/duisrgyb0fD+muW+UMFF7EWFP+vdr8BMHQqx7q
	JnSz27cM77xCAUYUWOnF1G1MSiGBU/c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mS/ND6mc";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CB6A60181;
	Sun, 22 Nov 2026 03:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD891F000C6;
	Sun, 22 Nov 2026 03:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795316769;
	bh=Nuth1ESHpISoM8f5XHfuVs3cajbbWyp62tE4i6qZmvs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mS/ND6mcFmQ9hIoCHypUEMazIrOu0oYIOZS7rVquHuJ7Qx4InpsVcNDx2Xuq47pPq
	 XWWNcdfJs+9sJl4j6oWbtcZ1tu0lYw7k92RpW7FuSVIdG5j7qLuJ6Jv2LKJei5gQoP
	 /z67SXP/dt67pS62BTPOEUYotYJkOpMA2rmnKwMmGhDIwmmUhnfQwdXfUb56ijkNPk
	 A4BrAap6MnfOFu/4EJCgloVsJI7f55zNDqmnfguhOWb1Z14MTBYGmOkBMZFYgr9HDG
	 x07S5Mk6/bK2IiYPEzf0KF5eawxEa9x/cjMdvpcHrdhdtt3aPuo6xLFU5OywSpUCDe
	 TMOSOtcko7Xxw==
Message-ID: <sashiko-outbox-227661@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6/7] memcg: remove synchronous memory.high
 enforcement
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shakeel Butt" <shakeel.butt@linux.dev>, "Tejun Heo" <tj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Koutny" <mkoutny@suse.com>, "Christian
 Brauner" <brauner@kernel.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Jan
 Kara" <jack@suse.cz>, "Matthew Wilcox" <willy@infradead.org>, "David
 Hildenbrand" <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Meta kernel team" <kernel-team@meta.com>, linux-mm@kvack.org, dsterba@suse.cz
In-Reply-To: <20261122024737.2741569-7-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
 <20261122024737.2741569-7-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 03:06:06 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9E14A1C0004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: cpsfkujiqrebn77m1cise5e7t61p915d
X-Rspam-User:
X-HE-Tag: 1795316769-139635
X-HE-Meta: U2FsdGVkX18jNWuVW0aqoEpT4zphOILOzm4DjNILRoFgi23tOBm3DFD+mj4b6lipfI+1mxwbZTtRuk9g0dXU/d9k94ws8vmsl5cwZjf15UHFGCeOkDkiYahbmrHK1nuAtTjQD0ZIsRzhAVxPeOLgmmz2PVtVuhiJY75JgmM1spbcjMMtUqspQFp7jUlbiYL3YjDE0PXlGQxUDodni3fdz6+h9WxJGLao7s6ai8406HNh7a6xLNPl3gssoeV2oV4tQeQeGW3ptkCP41Cb+CxWg1OZJoXStxg5ACJez/qbRiWSy08yqfWSuheczD09tUlW/BXH5dtN9sZplssQllHvAG4sqxbGMtQJcmYM0neryBre/5Z1lLXx4BTjyDwJrvz2mItLjUpzJSMEhWdE1DABJ2V+35P7nRAjvvrqkhbrcpEYjpDW/1OxxuSErW6emCC2J0ptO8dtdXlIRKqRAseBfQZzyrosQRWWN7qNwFDlc6WbN0kHTI3YCFRyKe4RR+6a8QSsQETKi8T44T6rIxYgbcAt46F7lHW1igPVrBb6/YaQgpb/FGCAiCD3/HBUMJ3p7zCuxbCizs9BQiKPt/LGpjGcDKbfwh4/6GPsWfr0woK21uO+qi49ILfquXS2ypS98VzqgvuKHtcYSTroCbNCyQJHW/UiWXRcnQvavXA1eLRtOFD76QI4jZPMzsTB/bLxmZku3IhE7LeDpyUMyr2HqjMEJQ/VMQVym2o1Q5xWCGDROlhxf3i5u1jPRQy115HP/m0Yq2IH7IjaK3LFdaGMoaNrOZDUIsySSteXssG64mFOK9v1/WO/f/91MkshtB2StG6hokg8x0V2Y0AO0gxf/0Czo7cuN/mFjml6y+qXYIG47qzaIBLI+KzzJpRptH9u5F8GauQNgarbJphxDSQ2VvrcnTXYVyUQGM92gRN5rLz4Hl1K29wtrqk7Ttq85VplwpaQ36+yN+vixdEN6aC
 f9ZpYJYn
 Kr+W5DIFVpln1Cd0rZTivxxK5kBFRr/5TazWTTP8EaJrNO3BadC9JzUwKTub6VHwzLTLTHj4eGnkGFE4jOagowbrXxnU7h2A7ZxgCZ0U8x4B35GcJnZUC0F20Gh53TrKtnucDUSodzOxk5876a1FvJ8G81vmBw+JDY6Jzf28TtKcu7jm1cSzla53vLCy1L7fI5zy3OMsCO7gACLjpyQsB4kpOqjRCUEGhJkSsN+WAfTXVUgvO88npE+aouV0CxaElsim8nfAiGs5iJ4sC7mX3sAJjahrKRJRscNT3h3I7DCBmboOpMEFe2pbJMqohwb8X6JQ/Q/Q/PpmD0wVsJOO73ms4XWhePuqWX60hynDiNd46hqfnicJlG6fBEp1Qqw87Voxs7DmarEFoZ/IDBgyo9Gz0VPHW+SYBdkkLkiL7BPjbTX/VwqtX03VTPcahmCNDq5CIX64f3F0FW+kGyweYUXng4qI7ihoVPQv+Fb9uX80Hs8WAqmlnztDCDVY5mVMS4erQvi0qeM7K43AAWUqM49CmxSTKjT+yPimpn1Kx2PlaAhs1d30LifP2lU1wonufzBoR+HA8evi3wb2uCTN/47DuTDO/Ix1U4XbFPiDjrB+sHn+I3cQ0W9ARs/LyjtmFUJ+qjVdCnuQcfsFfjFxxL2NYnVf5rZSHAmXkAI8ZLTNR4JKNM5H4yC/jq1ZYQ9yWT9RpbHjTyU8I5uP4Tc/wui4DDi66lhmRMrN225feRQoTu7t2LdUCSD06fQ8n2LWVzUSi5tS+68Oeh3scv1fNP2Yrt1RzN8NqwZv8
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
- [High] memcg: memcg_enforce_high() leaves vhost_task PF_USER_WORKER
  threads unthrottled
--

commit dfb4aaa1098cc7070f618d5995322b418d647d3c
Author: Shakeel Butt <shakeel.butt@linux.dev>

memcg: remove synchronous memory.high enforcement

This commit removes synchronous memory.high enforcement from
memcg_enforce_high() so that pending high overages are handled on return
to userspace or at explicit throttling points in long-running operations,
and updates the cgroup v2 documentation accordingly.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6d147153bd06b..4771730e017a5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[ ... ]
> @@ -2765,15 +2766,6 @@ static void memcg_enforce_high(struct mem_cgroup *=
memcg, unsigned int nr_pages,
>  		current->memcg_nr_pages_over_high +=3D nr_pages;
>  		set_notify_resume(current);
>  	}
> -
> -	/*
> -	 * Earlier charges may have left high overage pending even if this char=
ge
> -	 * found no new overage. Handle it now if this charge can block, to lim=
it
> -	 * overrun while the task remains in the kernel.
> -	 */
> -	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> -	    gfpflags_allow_blocking(gfp_mask))
> -		__mem_cgroup_handle_over_high(gfp_mask);
>  }

[Severity: High]
Does removing the synchronous __mem_cgroup_handle_over_high() call leave
vhost_task worker threads completely unthrottled by memory.high and
memory.swap.high?

vhost_task_create() clones workers with CLONE_VM and args.user_worker =3D 1,
setting PF_USER_WORKER rather than PF_KTHREAD while sharing the owner's mm.
In memcg_enforce_high(), use_high_work checks current->flags & PF_KTHREAD,
so it evaluates to false for vhost workers and only increments
current->memcg_nr_pages_over_high and calls set_notify_resume(current).

Unlike io_uring PF_USER_WORKER threads, which check TIF_NOTIFY_RESUME and
call resume_user_mode_work(), vhost_task_fn() loops in kernel space until
exit without ever returning to userspace or handling notify-resume work:

kernel/vhost_task.c:vhost_task_fn() {
	for (;;) {
		...
		did_work =3D vtsk->fn(vtsk->data);
		if (!did_work)
			schedule();
	}

	do_exit(0);
}

Previously, blocking charges from vhost workers (such as guest memory
faults or skb allocations) were caught by the synchronous
__mem_cgroup_handle_over_high() check here once memcg_nr_pages_over_high
exceeded MEMCG_CHARGE_BATCH.  Without it, vhost workers neither schedule
high_work nor run return-to-userspace reclaim, bypassing memory.high and
memory.swap.high for the lifetime of the worker while
memcg_nr_pages_over_high overflows.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122024737.2741=
569-1-shakeel.butt@linux.dev?part=3D6

