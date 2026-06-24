Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C50FCD4F26
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 01:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F756B0088; Tue, 23 Jun 2026 21:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F106B008A; Tue, 23 Jun 2026 21:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34636B008C; Tue, 23 Jun 2026 21:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94FCB6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 21:20:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05F3E401E3
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 01:20:43 +0000 (UTC)
X-FDA: 84913051566.10.A1D458B
Received: from r3-20.sinamail.sina.com.cn (r3-20.sinamail.sina.com.cn [202.108.3.20])
	by imf30.hostedemail.com (Postfix) with ESMTP id 22A5E8000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 01:20:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="D/728wxh";
	spf=pass (imf30.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.20 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782264041;
	b=C3JLAc5izYLbpoRxczwDFRRFNRCqkdjwQoeLLh+lQFiezWxomsv5BrX9oqveFtTSNZj3H+
	YCp/0KqRfV8ifqXNUCTPvUkcr2l9E/Y/3bKUly7mN8X3HBvIT2MFBduSgSB3inmKJqlzMe
	1d8EFxbPXaQlW+vqAj8+YhKd40KtFaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782264041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZwPjOiQhIsO80JzngIza/FZ2n0oxv+sciICtuqSosXk=;
	b=eULz/1rsvyDMTO8U0Ifv9UP1g5Uw/Sf42aOmmNVUn+1/F4RAT06DCuj4IrHd5qr2JZ6y1h
	oDxSv2gOriPPzmiQmrbJUUFC3xOJKn2mgv54Iv5/1IBUimbCgXn1Ty+ebEgoKMLKxhdAG1
	/IPm+UhFEDSkqeYIiKEi1kpgKfPQfkA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="D/728wxh";
	spf=pass (imf30.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.20 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1782264040;
	bh=ZwPjOiQhIsO80JzngIza/FZ2n0oxv+sciICtuqSosXk=;
	h=From:Subject:Date:Message-ID;
	b=D/728wxh71d6JT6LfLy1AAZfNYtZ5QQNE1FbWHg8htAHUru9LsW/vQqyEVOr0awbk
	 ivZ7xeVUcY1QKyxRInHYKNxVwoyBWEjCzWcNqhEqVXsosJWEGyEu3DZ1ylBWDxktYt
	 pMFVHSSLR28OwkEn2axtv0rXf5pJnABNEwvZFkHU=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.32) with ESMTP
	id 6A3B30E200006131; Wed, 24 Jun 2026 09:20:36 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 222894457036
X-SMAIL-UIID: D00542BA1DE445BF9B70230553DD5312-20260624-092036-1
From: Hillf Danton <hdanton@sina.com>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Matthew Brost <matthew.brost@intel.com>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v6 1/2] mm: Introduce opportunistic_compaction concept to vmscan and shrinkers
Date: Wed, 24 Jun 2026 09:20:25 +0800
Message-ID: <20260624012027.194-1-hdanton@sina.com>
In-Reply-To: <ajnA83DxAFqeJ-sv@dread>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wyj6m34dtkpst5gbjdco9fg1z9zi1eos
X-Rspam-User: 
X-Rspamd-Queue-Id: 22A5E8000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1782264039-243184
X-HE-Meta: U2FsdGVkX1/+J5K9r3eWz5navYrcg1nJympPVdHmYmrF3vI2jHlZJc9CLiOoxo6yAkuzfZM7ckx+rdIR17CF6yg59K+eGwjZj4RMHS6oQP/axmPhCroiyr7Z9hM62sHcBSOkNUtyCaFlmq3X2n7zUHpWBrawdRjDpruqFjoDeLc2HgU7rjcMCU4PC4GYz+7FgrH03RLYUr9IjjK4p/ZLDi4kBNAiSXlbQOo2VBj9yi5WD4UsyTqoDi3aGRL9QiKaAR0bm2dN22OzFLGjZeLeGgMoEev4LDZgBPLNnXuO23pa17tzyblltrS2B5AoL2e+UTLgwoAZx/6foPS8gm0VKsn8S/XxzSB7AA5dSzBeskIr/Otn9UtcoMzTuV+83htha9D9/YB/7f7yMdMknEdJzglMcUh+Zm5n1XD70tPHrF+rd98B/BOwstd+lFnxoEk2IHFKW8UkHas/8neNrMdYxYAlxOBxAdzvSyWp9b/qZ3bNMjeTir/RDX9ZOk+2gqLKMOX7WtGhI5MgDgxpncqHJuKz0zUlli2zzx6kU45uZ6PPMiZ7nyxHmM7nPUrs8t3bH5hX0k9PvjKYMRNzaGLA/5VAB36EC+jj6H3tnNmw/4qnk31/P2ZFHjwM5dt1cMT3COQ2H+ege+Ba1XsZxZ9K0X+CWi7h6rxDqKGHyC5ENfkUtVr48w9e7B88NW/OAsQ6wVbxBxQziDZgE+1nVv8wdQh6xSGjn592y6L4yPUFNVu1HEyy/ReVIGTGcb5auxp5sT25WouyoxzP6L2++vYddzASsPLnAM/vuJho8ArjMYgzINVA51n6gnizHRzIRdLBpUT2r3NmncBiBvAxoIxOQGbh+b+lET+ajApS7OP8x18AHkUmOnQYctapKMuAmMYQL9p6sROUsxXbpLMR18E9gY62JL+Aio6lxrvCLBrL9qGIObE81CXCWDUZE2WSeqQVVBkTTBvk4iIjCpVJWKp
 7Lm5poAN
 Lx8uxI9qDts74gzFzS1iY1v/QGgxb9C/ZdGbQZZAB/mbiQLGOK4FxReht4xql3FpOA/Ts9XKvRPua/YPssToHqoWOaXgkvbz2Guh5IGXau+101ZLxferkU4WPo8mf4MpIRxiqYBqmfDIZm20pAjFd2siQ8zfjRdMsabDmhMhbAVKxLwSVytay27+3kN3On2ZHJSryU8e5b2RpVj5qzS7CC3U9wVi+b6f01CN4tRCZ+l5d5kwPRk7SX+dfo0OxYXaqHyIm7tdUP25CB21//LGaf14Z1bE5vZ6avmragoQXC2tzD5EhYQRfXL+mOAr77h7YTiqELG1xEKGYVd25dJK0r9zKnWbbj8V1FiQqxVVBNQrRWVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 09:10:43 +1000 Dave Chinner wrote:
> On Tue, Jun 16, 2026 at 08:22:17PM -0700, Matthew Brost wrote:
> > High-order allocations using __GFP_NORETRY or __GFP_RETRY_MAYFAIL
> > are often opportunistic attempts to satisfy fragmentation-sensitive
> > allocations rather than indications of severe memory pressure. In these
> > cases, reclaim may invoke shrinkers that aggressively destroy working
> > sets even though reclaim is unlikely to materially improve the
> > allocation outcome.
> > 
> > Some shrinkers manage expensive backing or migration operations where
> > reclaim can result in substantial working set disruption despite the
> > system having sufficient free memory overall. This is particularly
> > visible in fragmentation-heavy workloads where reclaim repeatedly tears
> > down active state while kswapd attempts to satisfy higher-order
> > allocations.
> > 
> > Introduce an opportunistic_compaction hint in shrink_control that allows
> > kswapd to communicate when reclaim originates from a high-order
> > allocation context that may be fragmentation driven rather than true
> > memory pressure. Shrinkers may use this hint to avoid destructive
> > working set reclaim while still participating normally during order-0
> > or stronger reclaim conditions.
> 
> To be honest, this seems like another "push a hint through to the XE
> shrinker" mechanism under a different name. You seem so focused on
> fixing the XE reproducer that the -systemic problem- that -any-
> high-order folio demand causes is not being acknowleged.
> 
> e.g. we use high-order folios extensively in the page cache these
> days, and there are -many- cases where memory compaction driven by
> high-order demand cause significant performance regressions for page
> cache performance. To date, every single person who has wanted to
> fix the problem they are seeing has effectively attempted to -turn
> off compaction- via GFP flags.
> 
> I've even done that myself inside XFS to work around kvmalloc()
> issues with a lack of GFP_NOFAIL support and doing costly high order
> allocations that fail and trigger compaction before falling back to
> vmalloc().  However, these issues have since been fixed in the
> kvmalloc() code, such that it now does the right thing for most
> calling contexts (i.e. tries high-order kmalloc() without triggering
> compaction, then fall back to GFP_NOFAIL vmalloc()). This has made
> kvmalloc() more performant and better behaved for -all users-, not
> just XFS.
> 
> This is not sustainable - we need compaction to be robust and
> performant in the face of high-order folio demands, regardless of
> what subsystem is generating the demand.
>
Because a) compaction works only when there are enough free regular pages
available, with nothing to do with shrinker directly, b) both order and
gfp are checked in in_reclaim_compaction() in addition to checking
__GFP_NORETRY and costly_order in __alloc_pages_slowpath(), I think
individual shrinker can have more option by repeating similar check. 

