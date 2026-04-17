Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B351EF8DFE3
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 08:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C1A6B00AD; Fri, 17 Apr 2026 04:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED1E6B00AF; Fri, 17 Apr 2026 04:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102F46B00B0; Fri, 17 Apr 2026 04:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0126F6B00AD
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:31:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7156C3678
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:31:21 +0000 (UTC)
X-FDA: 84667378362.02.77144C8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id C6F0040003
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:31:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tZgojb2e;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776414680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7iudLHxEeLtdzNeFZM32eDp9LSIRdGLwCdrHAKpCQus=;
	b=6/SL9y7IIrfqj2ePtZpp/2NGDfB9QXCp7jS1QcQy50hCvwWR5DRKbmStIwqUpNnk7exKf0
	b6Nk8OY9466Lt7SvXnxw5IQJMO25COAIgG3LQcFcVD8vzZc8unQjDx9XB9ZTlGIKp4p7n4
	VmBCf5mwzybxxO8wpOZY+wYHt/Jm+Y0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776414680; a=rsa-sha256;
	cv=none;
	b=UUQE6BW50Jh7opuPwVXcM748x13sEt0PVbv6to3WXfCR+4hjpWROPg4toM1K8zb77RDEqN
	zRd/NsWBaxOFErJsAUHur0kbucMgmc/iUClr7L+JcgXdQsSgisBmEYhNxRO8UsjO/HjlyI
	QSzXINBp+tJYu0xmj3Ep0pDO00zibx4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tZgojb2e;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2FF51E7D;
	Fri, 17 Apr 2026 01:31:12 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 235843F641;
	Fri, 17 Apr 2026 01:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776414678; bh=Xf8oSVlSyjbs13J2X0kdO8ZpK0071NFBikk2L1e0ZT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tZgojb2evQ6/7+DClcXpyLa99zzRDpUS7S0mVhSbZhXIt0RPhE/BPySCWlI6E2NHK
	 KPE8JCU3bOeXhjZ/k47vt0jDLgArIHpRRZNbU2Ju8E0bWimOItBpxk5rNzeDT8az5m
	 g7QTTyHdiLu7/ZHOEJT2o8LaOxRwWwqLBwRqKEgY=
Date: Fri, 17 Apr 2026 09:31:10 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>, Will Deacon <will@kernel.org>,
	Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v2 2/3] kasan: skip HW tagging for all kernel thread
 stacks
Message-ID: <aeHvzh3A0eC-tds9@arm.com>
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-3-usama.anjum@arm.com>
 <adlCN9sUcQdWbf_i@arm.com>
 <adlDSiuBeSduK0mj@arm.com>
 <aa7c5a29-c8f7-48aa-b0a0-ed147d29fde4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa7c5a29-c8f7-48aa-b0a0-ed147d29fde4@kernel.org>
X-Rspamd-Queue-Id: C6F0040003
X-Rspamd-Server: rspam07
X-Stat-Signature: ppn71wz1wcmkmtonwh7ntjmpidnyiykb
X-Rspam-User: 
X-HE-Tag: 1776414679-755626
X-HE-Meta: U2FsdGVkX1+gUMJAiRmfmJBn334tOfuCmFn7+85AScDAFRQHIQvmwwxTs261eAKUwF4pI469ZoHpDrWqSXnaHqEaBErKiEnSR3pr6JqWhqSposJHVjEgetPCaxHQT0OuwkUu10SlTTb0/19PvrStIsteBukB8/o/4vuiVxlJfdM2A59PeYGfKH3FF+Gb0XTFnvH3xNABiFgC6l7vDI58tJasvA4k4jfOdG5D/FTyn6HqtEmthuTyF/OP3TlojC8s6Vn161KxOKpxrmplH5wBinezCMGkZxGrsJ709IxzuGnDfdivGEaSVrZ9oVtAtgaEGXrDK6+yvEnfpSXl5nv2ckbwsqo7F0O7KQqcUe6nYA2h5MWOo6dUAF+0CY/M3Uw1v2y75Z23CCr5pHL/nlYLE4Xvmiix/udKl8FXbViYix2d0SyF1ciFnOBVqi2wJxynWL4he1pldq/Qu1ldGUFFQv2jzDDBoWIJFPL2QrxwyTBByZRce0uUNidWv72Og4eNLubwmiSwbVZt2uV+6bKq3/xFSD/Apny7MaVMjf66jsgqN1UpRD+G9BcAG9/81yZqHb9QE/DriYAfb955UPe54kmRoV8ZUGWQSixY8RBxRnYMWVvR+eVij9zESiMZaUluiekOr5pCL9MdWArXS0+xIZF6fd+siFOxlidxQwY7nzhsCmnjl0o7GCfDI4fjQbYRifbB4XRk3+vK4O7GOO6JYQftxXqDYajeCAZWO1dzuBFro6TxRWfknmBlprF2b8Rpk59QNjtHp37JDC16XqvCOGzMgFoDw/vqQWxzad/nhmNHpIANbdqfeR9hzlvaMV+icEvIxlSIhfy44wuBHwYqPYlKXOx8DokbKYK9LzfZLq34g5DmaqrDnorhka3jXD2qLqpAiP1UKcdCkfmln2wdzcHL/MpbwCmg8jAyaJruc86xmfFJO/NJWdNXnKE2pvjlbOmvfDQ+Lvoccm+V74A
 CzZgh6MR
 1aKfFZ4qFXfdyZwWomuYWJQCKqxGZDThiiIk80wQ2QJ1uRFTkFmrUifwolnP5lkAPX584l13q/uqUgvC5JhSIwc1U5gAoylz1xNjwoEsx7sQPwA5N3Tl5y53Su9eycs/FBlj6/X1WXa24W8P3C5ycEBQitGnXDLsOs5WozrMEW/7WxB5tdlRdvMGUsaxcg8NqEDgEOvcr8Lw6WaT0wXnhVM8dQFmtvUSECwTHCvGT0fY2YBs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 11:03:46AM +0200, David Hildenbrand wrote:
> On 4/10/26 20:36, Catalin Marinas wrote:
> > On Fri, Apr 10, 2026 at 07:32:23PM +0100, Catalin Marinas wrote:
> >> What the original approach might help with is use-after-realloc in case
> >> we had a tagged pointer in a past life of a page and it still works now.
> >> Oh well, that's I guess for other types of hardening to address like
> >> delayed reallocation.
> > 
> > Another thought (for a separate series) - we could try to map the stack
> > as Untagged (unless stack tagging is enabled; needs compiler
> > instrumentation) and enable canonical tag checking (newer addition to
> > MTE). This way, any stray tagged pointer won't work on the stack since
> > it needs a 0xf tag (canonical).
> 
> Do you mean mapping it as Untagged in the vmap for CONFIG_VMAP_STACK or
> also as Untagged in the directmap?
> 
> The latter brings in the set of problems with direct map fragmentation.

Just the vmap, there are a lot more problems with the direct map. Not
sure how much it does in terms of security, maybe marginally. A
match-all tag (0xf) would still be able to access the canonically tagged
memory.

-- 
Catalin

