Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 032DCC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4CFB6B00A5; Mon, 31 Aug 2026 11:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD70C6B00A6; Mon, 31 Aug 2026 11:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E046B00A7; Mon, 31 Aug 2026 11:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A17376B00A5
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:12:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 362004017B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:12:40 +0000 (UTC)
X-FDA: 85161906480.21.93AEE35
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id 59E76180005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:12:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788189158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKf/qv+ZKDMiRuq6ap8IBmRH94f4tOFqUTBggMx1BmU=;
	b=BwHy462cLhdWnNIpM2WtFrFFVoZt2wy8eNRxQiO0wt6YftIuPuk0N5E6WmxHLNMU5TahQW
	adgJSafK7jwpcVfn8FyIQK7HXjCL35lsb2I6CFkRP3VgfIvudBSxpQyUjil9x4rfOiNurF
	U+x6JRxTFrk2Dgi/YrIo95qdM6Dxd0Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788189158;
	b=U+OAavkNcqviu6STmuQlADycFeKFJrN1wWqPeUVYslXmznnSGNk3n+irY8tXrlYCpWPu+g
	rr/HKkVX55ZObCPijc235OhIRkTeMKoCTjzGl4xXm3z2GMhhEFrDlVr4DnK58DDUFGkqlg
	fHfTztaWwEXPEy/gdUJQgfbSIG/ZvIQ=
Received: from omf08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 72460A3176;
	Mon, 31 Aug 2026 15:12:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 17D2620029;
	Mon, 31 Aug 2026 15:12:24 +0000 (UTC)
Date: Mon, 31 Aug 2026 11:13:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, David Stevens
 <stevensd@google.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin"
 <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin Schneider
 <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, Uladzislau
 Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook
 <kees@kernel.org>, Clark Williams <clrkwllms@kernel.org>,
 suleiman@google.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260831111320.7b6b3946@gandalf.local.home>
In-Reply-To: <20260831065509.qqEtERDB@linutronix.de>
References: <20260827232948.2520558-1-stevensd@google.com>
	<20260827232948.2520558-7-stevensd@google.com>
	<20260828133620._x2XfJR_@linutronix.de>
	<20260828135947.GU776954@noisy.programming.kicks-ass.net>
	<20260828151018.HnR9xV1N@linutronix.de>
	<20260828150836.2d5b378c@gandalf.local.home>
	<20260828151313.5c4a5e4b@gandalf.local.home>
	<20260828151747.20035d50@gandalf.local.home>
	<20260831065509.qqEtERDB@linutronix.de>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/3KtEVjKaohpMEOxH4xzYg00zpuzVZqIw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=IKf/qv+ZKDMiRuq6ap8IBmRH94f4tOFqUTBggMx1BmU=; b=cImwxCY5M6/MZq1vXrGpwXyJIW4H4hu5sS1KO7PpnpoXteZNbNQ+GhZzlHqKlL3ZkFB0HN34EWkqTzLeQyS8IcFKie7OGgIlnJDjKa6hVhBcyvMHmYDM/yhwmGkc1A/6BHmeSAl3QTXL0In4xCov5c0vPfeze8DOuvivudM+e4o=
X-HE-Meta: U2FsdGVkX18dzhGCsgKCVwcrIISXc5+c8eAfc+lay5xArphhXwOHYX/nvWZLcCNFYp/sd112suTMB0NzpOGtFdRY72fbzgE39wDPlKiV4JS9YOYXjTah/tBYpd2756XDxPPscNMuqeK262zY2EEZNuLwXIXN/boqjUHRkq/XHc8VDiMguYSMX3Fw9u9/Ec2SavB2O6BTLoVKPnTjGCPjSORO1SLgGh0MREZxm6i8RaGqjgOEjD6WMtZo4umY6LccK88OvdVUTL+WTfjTOF+AZaafG8EqAzLRlgRtocOn6VnjyRlU2JmSCo78sE9rgM2F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: zde79gjnjoi51h98gp5cfbbykcarusf8
X-Rspamd-Queue-Id: 59E76180005
X-HE-Tag-Orig: 1788189144-66867
X-HE-Tag: 1788189158-19827
X-HE-Meta: U2FsdGVkX18SEnmGGEYzVDv0zl7HwKxEO6KdhLhiF0vVcySsBS13s2uQGJS+69AgQx1J3xgg0YmvbnwR+TglqCsYMEhauGNpS9xG9Ggm2/sjs6ld8nzHiGF+rv7TkzbRe1RFDzIy4wtS62y6l5hvCi8GKBpbsY8mwqKwoXw6bY2shQdlHFT6SP7G4zhY0NGVHK6fZmnNSIQcusuQWWZJZ9k9w6Q3WNbCUHfdZu/Ph9iX4so5Y1ldH0wWs0h2gjRIAp9LXlBeSTREUfppDAj7PK7befHQ5+xGsD74CEwo411NkcNf5FGtgSvpANWzls/syucvYH8lQuMao0Hl1UChVrOcGG4J9xj7hVG4ARXUzsjuCn8ccMArGFS/lScioNc3l0XZRvdl+yFY/UZQ+60h8fLe9pyodkZrXvpUEM71bTVs5PbkeTPmUY3jhb3EbtvpA9/Hrtym2Tb19NSSGP7yNyL5a41PawT4Xa31+bAh6Seji3+glFH0hSyt0f6R66GTOjCe06BCxjqt05gpase5ImkMP6mrRNFuwhEHMCeH9kb6TyltH2RfAQ1yMxMlutyOcRwbCoaWGCpOJwKawmj0dJ+2gy6sKW6Z0/iGpOAtu5Pk+jg4CsP5Bt+hJ8EmGMTep4vZnujvw5fP0iOGAW4Q30vscGiYMkL5Yu03QL8+SVfeu495/+I/S3N1HXqWY80FMj4sqkvSPvR1sUUL4KvKao1Q2Uk7iQ8+An0sktNUgeDRHi4uM62VpDP8jf4Ymqv6gGJ6bQ5GbiqvcqAngbxS+6fooeOYeGQI894sbourhHTj/w28gx4dG5Xc2AvKK3cjGkI8KBxHxf7I3WJyKrRC/acX9158Ost5ItfD2rIp+Ig5IVHCJKf3aWp5GyrWRJUnj4FcndXyzSogFRjvoMYCOmcbBejiS8i6GmYeB96mbjQi4RJenaPZl6T6y/emw6q2pcbdcLc4MpMHBm7dCvB
 Vie680Kq
 ic86JXlLC/FeWHzTjLa/XpSWwgOxVyDE+iYO0O6ES00yrx+KOqR6TY/LqcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 08:55:09 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> Does this stack tracer distinguish between the kernel-stack and
> IRQ-stack?

It should only look at kernel-stack and not the irq stack. This stack trace
may have triggered when the interrupt put back the kernel stack, as it is
in the irqentry_exit code and about to do a schedule. The code has:

kernel/trace/trace_stack.c:

	/* we do not handle interrupt stacks yet */
	if (!object_is_on_stack(stack))
		return;

Which returns if the object is on the kernel-stack, and here "stack" is the
parameter passed into this function.

> I would expect asm_sysvec_apic_timer_interrupt() on the
> IRQ-stack and not adding weight to the kernel stack.

Right. But I believe this is where it switched back to the kernel-stack.

> Given how close this is to 8192, I don't think two stack pages will
> happen soon.

Agreed :-(

-- Steve

