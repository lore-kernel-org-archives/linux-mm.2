Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D320C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B51D6B0095; Tue,  1 Sep 2026 03:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465B06B0096; Tue,  1 Sep 2026 03:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2E56B009F; Tue,  1 Sep 2026 03:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 171176B0095
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA6ED40351
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:13:39 +0000 (UTC)
X-FDA: 85164328158.09.F2D8FE1
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf06.hostedemail.com (Postfix) with ESMTP id 18045180007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:13:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=U0fkqFji;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788246818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWhfzyQgaYUJtonCqs7Hc3xCwG5I/OFdVxQZLlY0m4E=;
	b=xSBKNaNXhKMj2CgqTa9lzz+J6CKdk7qiYMmIYvsekrdG0FdmNA6kPaJA79AzaBiEFI+dqu
	JY8x9YtCxG7MJKdJPyYh/ATYRepDuSxblrW90hiRrRGuz4S/Z4OG22J5CJRHFvxrqiICfw
	Fral3b13S8dB184mtqm3ICKjeEOfsaw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=U0fkqFji;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788246818;
	b=cSG2REs1yIVptkyz6NRxKZOHrSLNnchC7jgQuC5lzuX5jgvjdRJu9tKIsYguW9nfbsc8UZ
	rj9blMWpBsSdIzSZ9rvHies9zn25n4k3dFYNE8Gspz6VWZZBfpOrrGerPuRXAZOtpOR13G
	lBboS/T0f1ZMx4QwpdhZJAxGEQqfBYc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iWhfzyQgaYUJtonCqs7Hc3xCwG5I/OFdVxQZLlY0m4E=; b=U0fkqFjibEL2Au50BwXhiEMpAJ
	FHdHxlsHRfE9ddPoa8rf7lCgMRKv8R0QHofEwjFYQmJBCmC+Tolg8GG1fPwUsxRuvRa+YJ74Ppfo6
	QcV27MIXjoNFh35D0OeU3+S4DrKRdwj2JfZRsncSeUjbFH1zsZyH3a50+FYXplGfj/KaPDwlmz7ke
	7heeXq4AYy4kz0AegnczpiqBVkKaneioL+asAzJKQQlIcOlgvmcsrbnaMS6b4wL68taHvyHYZgElp
	ye/iitKbCj9JSY5/4mMsC/2tH32SNuwcadBDQEO/hQiKw363WcDtQyH/9kDltW3nWQo+QPXyFxTgo
	uqa2PJKA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x1IgP-0000000AgGO-1l2R;
	Tue, 01 Sep 2026 07:13:25 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E32853002ED; Tue, 01 Sep 2026 09:13:22 +0200 (CEST)
Date: Tue, 1 Sep 2026 09:13:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jianyong Wu <wujianyong@hygon.cn>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Phil Auld <pauld@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"jianyong.wu@outlook.com" <jianyong.wu@outlook.com>,
	Yuan Zhong <zhongyuan@hygon.cn>, Huangsj <huangsj@hygon.cn>,
	Fengyu Wang <wangfengyu@hygon.cn>,
	Zhiwei Ying <yingzhiwei@hygon.cn>,
	"justin.he@arm.com" <justin.he@arm.com>
Subject: Re: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
Message-ID: <20260901071322.GX687043@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-3-wujianyong@hygon.cn>
 <20260831115004.GF776954@noisy.programming.kicks-ass.net>
 <ee97dce1db374f50b8e87e51ad133d96@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee97dce1db374f50b8e87e51ad133d96@hygon.cn>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: a8stz8imbquyxnj48gzajw6m144gj69i
X-Rspamd-Queue-Id: 18045180007
X-HE-Tag: 1788246816-445511
X-HE-Meta: U2FsdGVkX1//TD0L02tu8/O4csH7h5FtlPN8QWCL6CJRIQ8HD77unGEw8uILQMqNHBYMLn4B20+DYx5UyGGm+PPjankgmOKTYzyQche5Yo9Q5Oh3Fh9f7bkNn0k9+OeF2cQKYMki8GzgNQI7Fa5gL1xuFqUl6lHkG9U88auBKBYbVy7suWBs2nqcX4zpHgFbjhWw91ml9V2qNzL7EyxmCIHqZassKdsnYHfrWqrKOqiVBNrUO85aXwS/S5eH+qUq8IPfOTnlDBXSvTRFCZZbrwqzGwdtjescQ6pB4JlMABS7HmE1FaLGCQSvujwvL+Dc+z9caiR+78yct46hB3VIgunhBPJRdBTyLfXzofT9a826H+KKwT7cTng8/e6/JpUpDGUiXFBEUO19BOGxu05OiLRgphUWInaAPotI+6nF/5Po3hTi7P6dMu+1diE5+N7FdT3CBnFwe+iglCqzZJRy7ha7xT64mXza27d0X7YxCHyN7hnbeHLNOZllcC+KdSg1BFruHwZN7dzE8blWBkg21L6Yy5gVAGS/oEz37DgKdbpi5L1ID94Qc4LRAaxQfnjsWYLNGZcxpVodpI8wZ6MQrPuazjSYFk5c2Yehh1GYZhqER5d4svjEm9UswpjDVjIjiDXWP7wee0hCnItKOIR8SH+qB5c5ymIzcY+Q/qpFZPDTp/IrqFnMcU1HDcPzuC3MeY8+m6k6rWlu6xVTl3W0vKSmFHfUAzGprf8ECioWe+ouWq0tFrOBYWav5G6uN5FUOHeW0XEqLx7eEjRp1pZNfslBbGH7hPnDncv0OrAbwWjFWKSMkD+SrmdXqILziN00TsyeRfttZQhltNNsEoOLwmErxo9KSy7yIrIqRxz4gPH/unrX+ANrF0WTtNH44xOEN4zI8rf3FcPBtzvXpNvvuuq13xjTd0++ACtaZNr4O44YdAg6h/2ogeCotv86PlOXZlWlOmGbdMSlxLFJIOK
 RvA+zwm+
 Vk4HGKeOAJGeLOnjs07Isuw60/b5E74XWJonjHp1Nitm81TRrg5nLIwOdaaunqsX0HUwtp9kIt41Pen+eRoO6dqeyv62bMc7w4hgSgnhrARASEgd30Y9JA3aTxG72wDvPFpR6dzdxgiFV34Si7kjIQrZ9SBfFV2v1XS4F9DwFjVArGLIUUIEpY6UC+LcotxCsI7znkmI4UtyRs0BjxJqRmUmYoYhH77uVpNEsp9P19ZolPoZvRFH6YFD8iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 06:57:43AM +0000, Jianyong Wu wrote:

> > This example uses Node only, but the code in question is specifically
> > aimed at Cache granularity; might it be better to use a cache example?
> > 
> > A little something like so (I got tired of prompting Gemini to generate
> > more complicates / less broken examples)...

> Originally I tried to use a single big LLC distance matrix. But once I
> realized how much memory and computation time it would cost, e.g. when
> calculating affinity scores in later patches. I dropped it in favor of
> a two-level scheme: the first is a NUMA node distance matrix, and the
> second is an intra-node LLC matrix that only encodes the LLC distances
> inside a single node, so it is very small. This way, both memory and
> time are greatly reduced.

See, that would've made good Changelog material :-) But yeah, fair
enough, the matrix will get rather big I suppose. And going to
triangular matrix storage will only save half, while you still scale by
n^2, so that's not going to help.

> > > Each row of this refined NUMA distance matrix is sorted in ascending
> > order to
> > > generate a unique per-node affinity sequence. This sequence will guide
> > > thread migration logic introduced in subsequent patches.
> > 
> > IIRC greedy has significant worse bounds than many other schemes. This
> > would result in more unique distances than strictly needed here, right?
> > 
> Yes, Greedy edge-coloring is simple but can't guarantee to get the
> optimal result in theory.

Right, so the theoretical count is :delta: or :delta:+1, but the greedy
bound is 2:delta:+1. But IIRC (and I really am not well versed in this
particular area) there are algorithms that are still relatively easy to
implement and get better bounds.

I just asked Gemini (so take with a big pinch of salt and consult your
algorithm book) there are simple algorithms such as Eulerian paths, that
exploit topological constraints, such as hypercubes or 2d meshes, to
still reach :delta:.

> > Since this is all on slow paths anyway, does it make sense to pick a
> > slightly better algorithm in order to reduce this bound and get better
> > results?
> > 
> This matrix currently has two consumers:
> 1. it is sorted to build a unique per-node affinity sequence;
> 2. its values are used to calculate the affinity gain in patch 12.
> 
> Therefore, when changing the de-duplication algorithm, I need to
> consider the requirements of both Consumers, For the first use, any
> symmetric matrix with no duplicate entries in a row is sufficient. For
> the second use, however, the actual values and their differences may
> affect the affinity score.
> 
> It is not yet clear whether using a more optimal algorithm would
> provide any real benefit for these consumers. I will investigate
> whether a tighter matrix can be generated without introducing too much
> complexity, and then decide which algorithm is more appropriate.

Right, fair enough. I'll continue trying to digest the series.

