Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7344FC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 22:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251AD6B008A; Thu, 10 Sep 2026 18:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2029A6B008C; Thu, 10 Sep 2026 18:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1301B6B0092; Thu, 10 Sep 2026 18:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D55F86B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:01:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C9E81C280B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:01:01 +0000 (UTC)
X-FDA: 85199223522.13.AE3BDF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5B8421C0007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:00:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fK39eLC2;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789077659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCbZRJJSfwFq8fSpu5C5V6NUIqHCcbuO98gGM5adtIw=;
	b=vEkNC12Ah4hjgezYfVBSjB8nUSqPC5QGZUmeKWdI2+d+BjbJyK67V0scgSIiXbk69Bx7wR
	ZlixhGBNDD1zwdrPDJg0dBSuSZAisHJq9gCWnKP2+ovepoUzy8uSkeqN4e9ZgbjEZVOADT
	sx4OrgelDtGe5VHylG727Xx3M/X0kZA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fK39eLC2;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789077659;
	b=1Jws5UwlPYJ5HY5j2TEcs05TRIRYPOqCuQQPHAHy0J//JQITByP2eYy0oEPaIfEcwgR1oY
	EQB+ZLFVT6efuHQI8h0bxBUs2l5HS3OTHuSh6rgfplropwHC2BXQbhL4jclgvvnOORl/Pv
	BXODTrGNZzmxlFkrE5U3JnBjlZR+y5M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA2BA43983;
	Thu, 10 Sep 2026 22:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070241F000FF;
	Thu, 10 Sep 2026 22:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789077657;
	bh=XCbZRJJSfwFq8fSpu5C5V6NUIqHCcbuO98gGM5adtIw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fK39eLC2b0vu1d3w2C5YFr0zE38rwHGnqt1hiqpOiDNabPVcXfSWOoVTWdJa41D3v
	 oii8bg896U7MfHwkeq0lnsDlofLZ2feOp+esT7Y37c0m16NA9v1xAoEe31JU5RQuiQ
	 QCBZ9ehiGjpded5wUGYFHFn8Dg9T+5mk1K6wcsfc=
Date: Thu, 10 Sep 2026 15:00:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
 <brauner@kernel.org>, <brendan.jackman@linux.dev>, <david@redhat.com>,
 <dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <djwong@kernel.org>,
 <hannes@cmpxchg.org>, <hch@infradead.org>, <hch@lst.de>,
 <jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
 <rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
 <vbabka@kernel.org>, <vbabka@suse.cz>, <willy@infradead.org>,
 <ziy@nvidia.com>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-Id: <20260910150056.499c6312198f1898acb68adb@linux-foundation.org>
In-Reply-To: <20260910114602.926944-1-dipiets@amazon.it>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
	<20260910114602.926944-1-dipiets@amazon.it>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B8421C0007
X-Stat-Signature: 8qmtg1nt88tunx3ezd17aebomimeqme3
X-Rspam-User: 
X-HE-Tag: 1789077659-850545
X-HE-Meta: U2FsdGVkX19YL8ifg4fEdyjwybb3bnLc8cUb1ygX8C8X96PGAkvlolH374Tjgz4zzHzbs5kLb0JahKwT/SdYC0/WM+8/vlbqlwXrd3Xa1coztdx4/kD6X7AtvNan2VJ10v0zg546PKAvsOUpkOjoRxJMNoMfxFQoe4Tf5sQ9ulyq1I9nx7PstRvlXBnZkL+HwMhD+SvvApPwI3Cbuw8kSeqasr57gX/IF7FR75PJUwcbtXNXz3SkqD3ojKZ0qQMDSqhJMQqJZ9nfW/tiYVJ5aGWpv6NggY63tC2OJ40/Dhc0G1gvh9eSI1zmQvLfQ1SsgE0twRV2Mn6AHOBKsbpehn2O1CB/xAbDA/kPiBb8oGCtxS/V9x+/QDXzjW/QDsSUpDbEPRMG5Z+fbs+JjE0zlXh6V1lD2dBhDdUsYdqvpQRwUFQTRh8kASm1keoqlHwhQqBcVHxpipNb8FM6WQwBy0W0cFJU7TB0lSBqnhNFzlTs+Yvs3bqwVYSW9MXoT3Vf9YbO+FSYUJ2jhKQlZDXAo4pN3znei4LqW7ovyJaixn7qaWByaOXONEv3TKdewtXUPCQWzb7Zw7DabFbEIijZa/89lEHBWgyKnHVwkx4KdP5R632wnuFAUGQF5SbyRj36TCp1/ryLGOFZVPHVCMP4mbSX1/uHU4lpQRNw86BLZKlVLsbfSYHUIpzmKJEQkpbRnjSYXkBe92IGBFFnJlvfKGG8inu0jTbrMMsisQ9lngIo4wqByzFNtcyR1AbA+/SpVZb3Pgbj7pPBMPu4PgtSOt9mYqWmOfhyf0QTartWgTS/0Qu6dHhb8vQWtttuA1/bNXsnJTaQdLeKCQRqFsq6r0AXYnNazqRL7JUr/VcJrZsJeIe5k5PnNAOvNVSpLFvhGaUIpIOq1gbRIVOmWhUZtBlBb8IX6KyohSOVhZz+23IstVkzZi8BYcbDsYemAKpOltzcCKsKDL7oFtQvbVx
 0eT5ZQyC
 sTnJu2t17PoG+TDh0yMMqwLgp0AzsAIq+wwc+7dTiCMp6JPq4f0P9rDB05BXU23OVUVqofEMG6PV/FP3pSpkLdfOA+dFzdOjOAZaJXSAtEpKSLVAYp9dfb23xImbCs0U1MAeAsPan7m9jEjfPoec/hiMf2yjFPQQl7SYOFFnuqMr7/mICub1UHWUBxCclJ7IEc3fyejOZJDiP0Wxl9iINwP6PIv+NRmoUvc+X+aWzeT2qUhLqsmNMXRrksw8jjoPYKV9KAaChfFwUOEXP9Gr9ftEBdWiI76EvHmDeY7xz8n/Fs502KRGTURceWbebfRO53TmY4nTQ0KPMsS6JMiGBVWXjEg2URQ9d5W5x2JrJv3mO+ZZpTFTgE7rIkHjjFfI7txMZPCtzs7v0vbPnku2gb4mjbXszHqTAoWuYEVAEmOIdZU3grKbv1TouyWArt7e45WV1ayrndBweOoHbv3++KyKy5uAHAo0czgZhlYBQSY5i1VY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 11:46:02 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:

> 
> On Sat, 05 Sep 2026 17:42:39 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Is there anything particularly unusual about this test case?
> 
> It is a stock pgbench simple-update PostgreSQL workload on a large
> instance (96 vCPUs), using standard PostgreSQL settings and with no huge
> pages assigned to the database. We deliberately overprovision the
> pgbench clients: 1024 clients over 96 threads. That keeps enough writers
> in the buffered write path concurrently to hit the costly-order
> allocation failure path continuously. The memory fragmentation comes from 
> page tables: PostgreSQL spawns a new process per client, and those page
> tables consume ~40% of memory, which significantly limits the page cache
> and the free memory available.

OK, thanks.

> 
> > > Results (average of 3 runs, TPS):
> > >
> > >   Config                   Avg TPS      % vs Baseline
> > >   baseline (no patch)       59,408       -
> > >   With this patch          155,409      +161.6%
> >
> > Is this back to pre-5d8edfb900d5 performance?
> 
> Yes - fully recovered.

Great.  That's worth mentioning in the changelog.

> 
> > AI review asked a few serious-looking questions:
> > 	https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it
> 
> Thanks for pointing that out. To address them, we can have something
> like the patch below. Performance results are still similar to v4. Happy
> to submit a formal v5 patch with it if you would like.

Yes please, a v5 would be good.



