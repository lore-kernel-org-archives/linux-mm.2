Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51DCED3941D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 12:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B722A6B0089; Thu,  2 Apr 2026 08:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23166B008A; Thu,  2 Apr 2026 08:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38D36B008C; Thu,  2 Apr 2026 08:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 971A46B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:43:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 309041A067C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:43:35 +0000 (UTC)
X-FDA: 84613581990.21.DCCC102
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0B04D160008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:43:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=2lK1MPv1;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf08.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775133813; a=rsa-sha256;
	cv=none;
	b=wYMTMCATqH6YfpxCRDpS2Em92nYhcS+fKLhDyYPxLSoDJ6UuGBmv7150PqZRPJUmJCLRGE
	07aIUw6aDdx1kZAoxZ2VhEUaJpD/JTWZHKVghZpwgw2frAT6XIu3l99OBcVxDDOrTnJP6W
	DE9o0kJLl4XLUzw+ek2S9Mo/qY6UH60=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=2lK1MPv1;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf08.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775133813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QyXgvoWPVr5+FW7E5J5E0+RpleuW2xwe4E/ruDFgOGg=;
	b=ecpiPwUen1D2J7y4ubZhTg/QD6UfxqVHeJBI4TRAhW1ohFZWQlxoAv4UyR1Upga9Uo3jWA
	3eXHfb2sdQLHIhBb/y9rxABnjfWGkgD5zBBJsJvmhRrT7O5EI0lFhIjI7qmwtpp4OFK3AJ
	WbBmFe8Q4K2eNRpAino3g4nlT5WbjEE=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 5BC9EBE3F2;
	Thu, 02 Apr 2026 12:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775133811;
	bh=QyXgvoWPVr5+FW7E5J5E0+RpleuW2xwe4E/ruDFgOGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=2lK1MPv1HnzwFABlcrlQ26ilwOgV0q6zP568K7bPTbrApdBc0hddFIRdwBXN3iyzy
	 EqhsvFqjsJ159oZ7EFvNOqcZPKvReIoEFfdNCGyYPFWc834/PX9rcxi3VyFkZ5Kz7A
	 pLV76/nN3U3wkRzvZHcr8aAzXpKtJkFHiRP/Baoo=
Date: Thu, 2 Apr 2026 12:43:27 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Breno Leitao <leitao@debian.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kas@kernel.org,
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <ac5kb4ZHWAouBFEK@shell.ilvokhin.com>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <fa089716-1bed-478b-96e3-a2ef5465b52f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa089716-1bed-478b-96e3-a2ef5465b52f@kernel.org>
X-Stat-Signature: y8zhk4shxhmmhwzeddroewzgiteoo5m6
X-Rspamd-Queue-Id: 0B04D160008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775133812-356482
X-HE-Meta: U2FsdGVkX19Y4VdRaIQda7dR/K91W/ZSlc03/VMxaMwf05sEIT3l6n422rg91odOpaFBDU1mxhnpkjQxapdxu4uBeld6B39P4A13ZZPrLF2VUZ6IN1ycKe1ZyqdwtxQsk/wYmEqt/p0qlpIWFWPGcLLbNbB//hYHUeaz2AKDjM6Z5/1r9HHQvLgaibjCWxzgeWaxZQSkUxbD4KXxVlJ7z0zSPhkdHUjgd3LAyaAywrtVpAGCSnkWcXOSH01c7wy2EGU8/AT69uoE0507KByk/9R578NuRNIldy9fcmquWG2e04C2toVFhAVUKozm/R7Ec0sawLEu+XRaZV/n+KoTQMwlqZg7fDGB7j90DAKTVsZB0kvQxL0msGl5wIls8sULl6V6cYdSH0R81V81wURSos3Lazb6G+94XIF47mHG8XW7mIG3+ARnrRWppe2x0hJZqwMbFbtOid/K8n76/gj2eAoC3bpb3egBZTGTPKqEHjvVjZgqxHcVVyNiZxWBsqowQoCBNepyfqjVvnoXmXJSUBcAMqTbmbVDyXGJIfGQbo7IC8The7dBNDMlOqDDDTFtmEJeK3R3Q3fr+1U3WXalbTcofRCkaDLrNhEXoBcrFvvM01Y2A4i6SWRfkjrckoTOUNa5+O3f1GYTM1vhbXLIJSOqD9c6s71ycS9GP60joXM1nyCYrj3Uwd3SUXGbKmP6gB2E4rE8JIviSOM7EMFwcsCrZ6noiKvQxDE/MDSswNeWHdJKSWc1JS6wom35n19HnyQ5EUMi7rpxHLphdNpmoIv8WiCymg9p+YTumgbGgUAln8hRTZ+hR90SM/OLLuUGV+n+8AkLu8whNyz2r9oo2vGcYZfP7jjkiZ1nnr9JZ/S6WZFFTpzwo9v3cDrfOkH8tqmChYlH/Pd7OZtsHZ6ETO2zEeJWx8kZR+8HxR7hXdW5qkaY7U7csamfbFSAHEcoZFmGPcQmSIGftcg5i+i
 cyip06D/
 Mm4ymZUw7vjrZQ3rVtjUWdy9p3zPHpo8Vh9J+BoJLn4AA6M4Sn1KmB+ijfMygUuuAqOTW+TaJ95d138I9O9AsS0iWV+Dem5EkBkE+yUKZTNecGKUzRKnRMs8W2w2kA1tkCDEE69Mw5Dnivg9S5e2RBqC+FvJhKgFj8Iz4oADV+XXntbBrUCFbNeiHDFemPtZOfwztDHcx/KhB/NVAxFhGS/mRi7Ab7T9beuOQ37TWIyaB+r3CSz/7ttyWcfiokf+7qapSM6qbayT/13yIjY4piDQNwFYZvPNNNtQlx0lZcc6MIX9IPaHwUH3drUaJODuZtG2XbNMH4x4ZPp4dom+8TBHEaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 07:46:35PM +0200, Vlastimil Babka (SUSE) wrote:

[...]

> > +/*
> > + * Return a per-cpu delay that spreads vmstat_update work across the stat
> > + * interval.  Without this, round_jiffies_relative() aligns every CPU's
> > + * timer to the same second boundary, causing a thundering-herd on
> > + * zone->lock when multiple CPUs drain PCP pages simultaneously via
> > + * decay_pcp_high() -> free_pcppages_bulk().
> > + */
> > +static unsigned long vmstat_spread_delay(void)
> > +{
> > +	unsigned long interval = sysctl_stat_interval;
> > +	unsigned int nr_cpus = num_online_cpus();
> > +
> > +	if (nr_cpus <= 1)
> > +		return round_jiffies_relative(interval);
> > +
> > +	/*
> > +	 * Spread per-cpu vmstat work evenly across the interval.  Don't
> > +	 * use round_jiffies_relative() here -- it would snap every CPU
> > +	 * back to the same second boundary, defeating the spread.
> > +	 */
> > +	return interval + (interval * (smp_processor_id() % nr_cpus)) / nr_cpus;
> 
> Hm doesn't this mean that lower id cpus will consistently fire in shorter
> intervals and higher id in longer intervals? What we want is same interval
> but differently offset, no?

Yes, I think that's a valid concern, this effectively skews the
interval rather than just introducing a phase offset.

I initially thought this might explain the increase in max wait, but it
turns out the columns were just swapped.

Spreading the initial scheduling and then requeueing with a constant
interval sounds like a reasonable alternative, e.g. below.

From 56ed7e17b32f0a7ce433caed87650b0de8246c4e Mon Sep 17 00:00:00 2001
From: Dmitry Ilvokhin <d@ilvokhin.com>
Date: Thu, 2 Apr 2026 04:49:06 -0700
Subject: [PATCH] mm/vmstat: stagger per-cpu vmstat updates to avoid zone->lock
 contention

Fix by spreading the shepherd's initial wakeup across the stat plain
sysctl_stat_interval to preserve the stagger. Every CPU still fires once
per interval, same frequency, different phase.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/vmstat.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 2370c6fb1fcd..aee99786718a 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2042,7 +2042,7 @@ static void vmstat_update(struct work_struct *w)
 		 */
 		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
 				this_cpu_ptr(&vmstat_work),
-				round_jiffies_relative(sysctl_stat_interval));
+				sysctl_stat_interval);
 	}
 }
 
@@ -2140,7 +2140,8 @@ static void vmstat_shepherd(struct work_struct *w)
 				continue;
 
 			if (!delayed_work_pending(dw) && need_update(cpu))
-				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+				queue_delayed_work_on(cpu, mm_percpu_wq, dw,
+					(sysctl_stat_interval * cpu) / nr_cpu_ids);
 		}
 
 		cond_resched();
-- 
2.52.0


