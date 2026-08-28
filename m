Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 554C9C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 11:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6387E6B008C; Fri, 28 Aug 2026 07:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610086B0092; Fri, 28 Aug 2026 07:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528746B0095; Fri, 28 Aug 2026 07:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9406B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:54:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6464C0344
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:54:28 +0000 (UTC)
X-FDA: 85150520616.28.443E866
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3D67840004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:54:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=g5q3o2RC;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787918067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lOeYdMQM0yEpqRm+8VJ/e9jItYU1+vsePznvGbz10E=;
	b=8Y/januCZTSmG+OMcV8epg2dyl7uCFZfxLgFV3MFGp/CqougbyF50m13p0OIbRnLFJ4ZWc
	4mw+ZH7G1xrblgK77h4ncfvpZTPSXJwL7H8I0Kp/srTkntEqXPfWiXjLhNxNtOrx99zaQo
	0c+TsgEpSjQfrEXiCdkIUtbQmTSnot8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=g5q3o2RC;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787918067;
	b=W9rGrNXaG/qcRZ30xpml0YytyIpZT+sbQ7Mlm1ujQTWU60EffSTT/WteAujDnJlNDktCxh
	6v375TpZ8DiUlapPsMWnNJkcXbhNRnPb7vteuiYrEBQxaT9FOqy0Ddnnj1Wgw1R0pQ110M
	rLqSvW8uQZAViDRCNzNhgYs/TmCJmpc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/lOeYdMQM0yEpqRm+8VJ/e9jItYU1+vsePznvGbz10E=; b=g5q3o2RCbyi+Yqbp+LTKaPTquE
	7gXYHP3tdr0knxX02PNNzCPOBFWn57YdhfVMe2wVBn0jGTz5C70WZiFqi6q+gGpJPkpRmT276v/iI
	Nx0JCxTzmg7piqalBDEI5CPqK/IwzqOegpNF6bmFCbfFSyS7FPEGTGn4XOICrl7KJogrp6jKLKtiQ
	BFLUSYdoBlhM6+BShUVl6Sc7u4HOo0ZtjEDUm1F2Mv+GRSw0GDtY23DSYzC52ibhjXBiKIkIMO7OJ
	m942aboClPHVMssGPyAA7ZQN5VBksW6w6zHJtn0ckV3dbahbmennTJsAMre8Tcbx+K52/+vDwChBY
	c6XrVZ4w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzv9w-0000000EdPK-1I3d;
	Fri, 28 Aug 2026 11:54:12 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4D3CF30030F; Fri, 28 Aug 2026 13:54:10 +0200 (CEST)
Date: Fri, 28 Aug 2026 13:54:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Stevens <stevensd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260828115410.GL687043@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827232948.2520558-7-stevensd@google.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 74c8tdhkpbu7j4ndhh9d4xa34x9onb6d
X-Rspamd-Queue-Id: 3D67840004
X-HE-Tag: 1787918066-10099
X-HE-Meta: U2FsdGVkX19p7uGyttl63CVHKBkRYHJZFtGQHIOyA/h9ZhUMx4vp9tFpNPk4gPpeHsGMXy6lGCjZ9GeTIjt68+ceeIIfXqnvon8wI2rdgDcz3T5a8E2eIgfldjFv7aM0nNtSGG5nXMjD9gJswMgWV3DOYjSXhFHhBoHynEnNig6EeJDRuqwUNsVh8+TV+O9vkInoQeVuV0ANH0NwJSyEWQiEgzpjMeS9iPNSgQGzjYGdGhjHsPjFhrDEB6FV3zdAPRWY1ZxjR0/BXXffHLCvMYdI9Ex10v007gb8iu+aUqecakDCQYCy2yv7SYQ60lBNUFEmkJcuBUelk9avreYUi1Yg0OkdrhJiuWMzB0b+gNQtoXjEVk4WY0y5fbbz+MRHZJlVAq9Uak00Neb3itldGXy/IG8vv8xPZEFOZxJOLmv/07C6pj01btW4Iqrx9y5PzcKLCSW5GuFZXuOAzb6cGDk5dy0KQrVTY5YmTL8+58wrHB5Poi0iDZT/T2U5XJiMxiFGzx/+2bV9PaZ8UoZ3kRBiQC7Pyvu5+0vt7MW2/68sF0e+d4iuZ/8N6n6MaE7z1Na08cc9yJVZnqeKrRFmg8q2neamNQURgPc+iR6QfyTSpIwxMVY4GM9/AWBPcciru07EQnAHcjQ1it1U+arB0zMsle+HStznqjzN4W+Kq22l5JkL48tX6fGTpPVaXJUcJMMjbLyhvRqKm/r1lO41AS/Hyf2zRZU6RhI2l9VnPDxJ1NmWwzFOfyiY9Jb3zioZXdzCKQfwIvqCyiTt+Nd0WaQbYJAV6IUPdUGxskakbuW4GjfZeZ7m0LmSHh2x4V/SRsO+loVN0keHy4Bp4K13D6QnkctDjI/tT+c29dTdIo8Ij4iadLSvluHFbOi3whDMn5ODHKPy8/yG4o3BEW9H2KYLFJ4528y0PFjcPrJUPXbTMMQm78iLrvs/MYGohoe39yMJBzoXv00cT02zh2w
 Ah5R+yjj
 OS/hcekxaKWZc8/SG8WsJIVcsnVR8TfYFdqW2Pdk3TSG6URGUmuG62+jmgpLNMaRAEOjU1PRzIObOnzZO6lefzc03myiiNUxS/JFrr1klMXOKCoy7gKflijhnm2TNecKLJ+R4tZUNP8+vgvrd0grKTaK13HjKWSyNDW/WxK1lPBfC2U4BCwvF6/Nwzi52DzIyEd62vI2uW0bYoHlELFF/Ao1WyTO4ZHLLld2TeBLEOkHtF2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 04:29:44PM -0700, David Stevens wrote:
> A new TASK_STACK_RECLAIM state is introduced for tasks that are
> blocked waiting for the stacks to be repopulated.

Not yet read the full patch, but *why*.

