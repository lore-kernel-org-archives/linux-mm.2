Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2F99D262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 08:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B186B0005; Wed, 21 Jan 2026 03:04:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B3E6B0088; Wed, 21 Jan 2026 03:04:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9CF26B0089; Wed, 21 Jan 2026 03:04:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7B836B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:04:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D01D13BC2E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:04:23 +0000 (UTC)
X-FDA: 84355233606.07.E9CAD61
Received: from sg-1-101.ptr.blmpb.com (sg-1-101.ptr.blmpb.com [118.26.132.101])
	by imf05.hostedemail.com (Postfix) with ESMTP id 415D7100009
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:04:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=qEpyZWS4;
	spf=pass (imf05.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768982661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0PWmmDBVohTXWkCnlTUXIXQ/PjrEDMfnhQhp/O6etgA=;
	b=hMiZ8xvpbTLBHUmsvzkDB1JVwVjqcO53HE28t0AFH2uKi7asxwAZeeavaO1ESEgc7uukH+
	Dn3vSEDXDNMX7WJEMMmbeyjvZ7ZSfJV2byp4rgmT9cIF8Q1uNZGVfsz8ndJTmg1F86Dszj
	uI3U9V6hvOoQN3WWkG7stOatsdXhY9g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768982661; a=rsa-sha256;
	cv=none;
	b=2KOu/7kkbgpeP40Nfb9308zryxeCW8NDTkKk0UXG0rVI102Y2GpIKQOOuvkF9cAGEo+QTI
	8jOALMasKDBzB2r+HgVtYmneU69qQ8OwMic49xF19JQhtI8+DioixcOczVV5kDz/vEwYz9
	JbCr2vMJfUuwIOTxBZM5+HqF6KAU3Bw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=qEpyZWS4;
	spf=pass (imf05.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1768982652; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=0PWmmDBVohTXWkCnlTUXIXQ/PjrEDMfnhQhp/O6etgA=;
 b=qEpyZWS4/r1zPQmiX3Uz1fpnIj0U8uebFpC+zeU81bmWXkTAaN1nobHjk0YAutVikC6sR9
 GTMBwp8/qPx019aybJLYt2+8pAKjodGGgkpi/QBGXd2tXS/vt/B+2QXX/KbWx13xBnDyaG
 HbPM11wP1XCn41oTUWuuBlFSyzROw+7wXlCTmdm9hhzuO47N4yeKYWB7LmSRpSF09EY7F7
 +Z0WqW9Qa/8SmhMkKzBZlV1A8ZVGlIhOgVPLDpOP7YMizfatPNl4ZVn9zO6yvUIdyJndH2
 ijpG5NWdYPFDWCQwZxUG8uNkeoH4z5qvtWhEUBuy+olHxcw2F9roVxa/cF8JSA==
Date: Wed, 21 Jan 2026 16:03:48 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
References: <aW_G66HeWLbyiPHs@gourry-fedora-PF4VCD3F>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <akpm@linux-foundation.org>, <ankur.a.arora@oracle.com>, 
	<dan.j.williams@intel.com>, <dave@stgolabs.net>, 
	<david.laight.linux@gmail.com>, <david@kernel.org>, <fvdl@google.com>, 
	<joao.m.martins@oracle.com>, <jonathan.cameron@huawei.com>, 
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mhocko@suse.com>, 
	<mjguzik@gmail.com>, <muchun.song@linux.dev>, <osalvador@suse.de>, 
	<raghavendra.kt@amd.com>, <wangzhou1@hisilicon.com>, 
	<zhanjie9@hisilicon.com>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
In-Reply-To: <aW_G66HeWLbyiPHs@gourry-fedora-PF4VCD3F>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26970887a+2be0d4+kvack.org+lizhe.67@bytedance.com>
To: <gourry@gourry.net>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260121080348.36253-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 415D7100009
X-Stat-Signature: ymmtjj9i41yeazowcb5wtd54czyuby1f
X-HE-Tag: 1768982659-415820
X-HE-Meta: U2FsdGVkX197w/kmiInJr5BVN0JhNA+a2jcanuqNBiEwV28ur3yFb1ttEf9HMwDuP4atuUkNJ+NO59m1ubqjHEjDdVUnLSJJjSpLVyDsaBcD17YM69ucw2qL/7midk28E5zc9FqUvUROgmDOa9s7gxo/NR4j/plJ5tPI/1V32Llh9mLNKT5OddKp3b92vG55kOpVosvSkjkEeNrlkxC4VMkCpInzqvxb+uZ4xBRiUcbGurRVNHF9zepwdu1gM0UZhzdWLuWPRYDikgrViQg73+CVlO2JUoLRx6mer1Foj0EpYpSdFIqpYrSRQQNjd7duls1mq+pFHstEssVDeVzgJAlJ019z/menTv7KVEFqMPEjnNdBYtDZpcam8qbS546HXdMlDZzMgOSkLDk6cYGQ7a9nHrfU8KRFu2EuUCZE6IxPBxqZ3EMD5uWB/Avd2XhHNkAAbQKY2mSrp5BxwwMwOQNbfxTNgqKLG/eSKoEWpmeaZI582N+z7b0zWp/mPfw2yjCvIj2aPsCLV5fNy1CIp0Drq9Z9ZXKKLw0e3ee/0oZTDSHyQ1Ym59YAvHzb+lYGpREglMGNwR4m6ZK1OmNfmgei6eZg8QwdS6bZaWtQRGQoWekvvhjLHedIRIylVyV7GPgaAwP7gJ/eMlpZ1r2su2vm7BO8wa7q7G8kaUDIYxpMfDViwJqc9LjxaptIC5GnUdM1sibEU2iuEMEQ2HUJs2K5oTIP66Lxn79r2G37YXAGbYWW7NQjWCO9OcCYKJ+ZJ0feFZ4yKRm13OhacX3IDIFrDmg4KZ50wAOmUGoqQVSVvNNZ+Xeh13UkCtjwTUio8QFnkhZYA+6VTC+/Hq2A6CKD606cDCI/ygCE9bMcDyqKobwoY0vrhLJPepv4RDsdhx7E4MlGHtzq7YEIwkiYYOvQi4H4ns54JLWEONnmiP64gyprxHja9S9nSwNZtbhcTnCEMh8kO1vMJyNMSLn
 01eWBU1h
 JuSB8r1fmea55/IW/iD74zm+W/yxpWq0Nyq3A999QPITfUwgEe/RKgobjbx9MINCKVvfMhYKpG/N2Yz0JQBi1pTQM0HcDYyUk33dIlHoDlQP31RJLYzmFcPA3kWTyd417cQ7ZFMrJc7njTvpacZShk3bSYHv5xaaqJ/GyZr6WHFYgP+9GoZWwShzmV4q9m66W8SMdmYOrCir6mRJFEFJ+XTWxliIOQZ/JoW2p24/cyzEqIYjwid0ysvrrQi9Zp3kBYWWhbQzM7bW3HHtrrSO96Qb8XvPazu/Gr3CTRLAlre2JA7J8gzX2vgL9Hq2J2xC0aoU6dfYsuIlKo2gToQ+N8fv4T4wPOL8uV9uR0TaeQaqfmnXDZRJqqwyasFeD6o5gjXxlCDgsC0PPpDX4GNKTj4nP9OFUyKnX2bwk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026 13:18:19 -0500, gourry@gourry.net wrote:

> On Tue, Jan 20, 2026 at 06:39:48PM +0800, Li Zhe wrote:
> > On Tue, 20 Jan 2026 09:47:44 +0000, david.laight.linux@gmail.com wrote:
> > 
> > > On Tue, 20 Jan 2026 14:27:06 +0800
> > > "Li Zhe" <lizhe.67@bytedance.com> wrote:
> > > 
> > > > In light of the preceding discussion, we appear to have reached the
> > > > following understanding:
> > > > 
> > > > (1) At present we prefer to mitigate slow application startup (e.g.,
> > > > VM creation) by zeroing huge pages at the moment they are freed
> > > > (init_on_free). The principal benefit is that user space gains the
> > > > performance improvement without deploying any additional user space
> > > > daemon.
> > > 
> > > Am I missing something?
> > > If userspace does:
> > > $ program_a; program_b
> > > and pages used by program_a are zeroed when it exits you get the delay
> > > for zeroing all the pages it used before program_b starts.
> > > OTOH if the zeroing is deferred program_b only needs to zero the pages
> > > it needs to start (and there may be some lurking).
> > 
> > Under the init_on-free approach, improving the speed of zeroing may
> > indeed prove necessary.
> > 
> > However, I believe we should first reach consensus on adopting
> > "init_on_free" as the solution to slow application startup before
> > turning to performance tuning.
> > 
> 
> His point was init_on_free may not actually reduce any delays on serial
> applications, and can actually introduce additional delays.
> 
> Example
> -------
> program_a:  alloc_hugepages(10);
>             exit();
> 
> program b:  alloc_hugepages(5);
> 	    exit();
> 
> /* Run programs in serial */
> sh:  program_a && program_b
> 
> in zero_on_alloc():
> 	program_a eats zero(10) cost on startup
> 	program_b eats zero(5) cost on startup
> 	Overall zero(15) cost to start program_b
> 
> in zero_on_free()
> 	program_a eats zero(10) cost on startup
> 	program_a eats zero(10) cost on exit
> 	program_b eats zero(0) cost on startup
> 	Overall zero(20) cost to start program_b
> 
> zero_on_free is worse by zero(5)
> -------
> 
> This is a trivial example, but it's unclear zero_on_free actually
> provides a benefit.  You have to know ahead of time what the runtime
> behavior, pre-zeroed count, and allocation pattern (0->10->5->...) would
> be to determine whether there's an actual reduction in startup time.
> 
> But just trivially, starting from the base case of no pages being
> zeroed, you're just injecting an additional zero(X) cost if program_a()
> consumes more hugepages than program_b().
> 
> Long way of saying the shift from alloc to free seems heuristic-y and
> you need stronger analysis / better data to show this change is actually
> beneficial in the general case.

I understand your concern. At some point some process must pay the
cost of zeroing, and the optimal strategy is inevitably
workload-dependent.

Our "zero-on-free for huge pages" draws on the existing kernel
init_on_free mechanism. Of course, it may prove sub-optimal in certain
scenarios.

Consistent with "provide tools, not policy", perhaps the decision is
better left to user space. And that is exactly what this patchset
does. Requiring a userspace daemon to decide when to zero pages
certainly adds complexity, but it also gives administrators a single,
flexible knob that can be tuned for any workload.

Thanks,
Zhe

