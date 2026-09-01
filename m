Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4976C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3EE6B00A3; Tue,  1 Sep 2026 03:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55096B00A4; Tue,  1 Sep 2026 03:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92596B00A5; Tue,  1 Sep 2026 03:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 982CA6B00A3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:55:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 30BF41C03A8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:55:12 +0000 (UTC)
X-FDA: 85164432864.14.5C3A65D
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0C4604000C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:55:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Ty4geT8T;
	spf=pass (imf27.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788249310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBjM/K/26wCBzpdKpWc+Hp5EDZGObDeuCaNaSLPt4hI=;
	b=KHzTBlH/KwUv+UnhSV1CsSmBpzGwYQ3liMvwsUADAu76Xe2I8q1QzaRmy4eN1PUqUOWxyR
	zlxoEWvbQEtbYrSReKwlLKi2pmQPIOg/nulBXa36/lSblmXeBqdL4QxP89cFM+l2W8WJr+
	arvo45KD88PpJ7yfzKTf1niOmRUaNlE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Ty4geT8T;
	spf=pass (imf27.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788249310;
	b=GfJZGa0ahyzNWQvM5Mtf01wDCCwPE7F+QOiPqUiqBaxwRoRWXMnaGMnGAFNS5SevV558l/
	42SdamFXBOa/pk/hWvtTVT7hZLY7d+Jdi/0OOZZ9lGPg3ML44tFF6iQ8jMooJKsawLeNFP
	RaDMKepDdJubsNHi+ob43daH2hAMr7o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uBjM/K/26wCBzpdKpWc+Hp5EDZGObDeuCaNaSLPt4hI=; b=Ty4geT8TvA3szhsylN9HGz0LYG
	LFlRHkgLzaFbiHH6lmuUASPjLw7W38ndHLgZmJoxzl45s8GCauMRCBfATakBNFki8Cm8Cq09t+UII
	lXSvTx/uqvuH0/5qYbBxHlojYiMsfFKNe82G9rv+sz/y1zPHJXNsFz8Hu28G0kDsVoh8Epz3l+hgT
	1p/F55rN5HrX+5i8Fa1aFXalPwdTjKzMxqNwMjwIqlRJb0wpiQYlwu5oR5faeweeeuLcdTHyGBKtP
	4a0WvNbm6gWErWnAnNWjzA+fHKHesF6s1M/xWL0KXzsodlS6crB74Rh6sVbUaNnBfq8EJwxDsL7tt
	QvXmhm5w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x1JKd-0000000AiYv-1nB5;
	Tue, 01 Sep 2026 07:55:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 916683002ED; Tue, 01 Sep 2026 09:54:57 +0200 (CEST)
Date: Tue, 1 Sep 2026 09:54:57 +0200
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
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, jianyong.wu@outlook.com, zhongyuan@hygon.cn,
	huangsj@hygon.cn, wangfengyu@hygon.cn, yingzhiwei@hygon.cn,
	justin.he@arm.com
Subject: Re: [RFC PATCH v2 09/23] sched/cache: Account percpu sd task NUMA
 preference
Message-ID: <20260901075457.GO4120091@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-10-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-10-wujianyong@hygon.cn>
X-Stat-Signature: or9ztskb7asmqkdga1tbpyccnkbocakw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0C4604000C
X-Rspam-User: 
X-HE-Tag: 1788249309-554958
X-HE-Meta: U2FsdGVkX1+oWDYpyXtYNygljpmpqig4xIeC4g6CbCPrOjdqXMLFUhe4YdoKh8UxydOFB5zu7OaL4Akb3tcNtn7qTlkzOq63KdIeQGWlWPY7MFj3cMf/U2IdTP5FG5UQpeKpwfis9BvUjjHIm2KUx/chG89+oSjpGOpsNiV82GuJmFKfA3uudb1yHZftdH9ApSl5qBsaDHfQWxfuHI0ON6cS0jkub4QhDErVbFE6GOtFg6UBloXfHoueLxNIHXKAT6C9nhWs/+9Y51VWYTlZMorn5a4K5C/xi6BbNy6wAxOghpZufXmvtoR88/X3D3tiz5gvsaNjDIoKBrjjic9QeK9U57gZ5hsY0IrVSYbnRyiHXPnMFNkoCpG9XpUE5asWcFdq9ptDzuDRm0yw0pWxOdE/g/GVV7Birj0AVIkgxSpBIMpJlpSMiRGYJlM5xwh5cSukhdusSQGWZZFk4/saxIFEoKK2G6DpTNfpZ6/4kv+4AdBWE1hUlvwzk2dyOIrDj/H/VP48p7jvflMyxQaKzp+X7NSxk+7DnOsgSeapC/Ab6ci4E81f7B7wo15LcedueCBLkXHPyDClAbFLVSEYCb/0vWFArozWOF21W9x7QHfcgubm9WvtS1ctTCGNuUuShykF4AxqOR43msNIKcD/BuDhQEwdCqV45JJc+M6N/6SHA8h9XFMmB8ULkvn2eLA2XRn0Lv07LujDxFg4sIr3GIOM6+qJXg+S4E3w1nkZjmZyxr8SgtuwuLhAoDv1DVTNtDVfACvnPvwtJKtzj7EFQsC4cTqgXJRT/nuaTJPo0A3qS12ok24PaD1UVVWDxaLgLR2JQtk2pPj4cPPANS3zHEoFI8/tnh0bsrzwNcKvjUdx02f5O6GcH0bMq9IdkGUeKvBgOM9BG9v/bMXJUr1g2sFSNTgQaBD/zqNxxA/qh1g96FR1CV+KwJIWbq5DFl12CI5y/qlAZiIg10RJUkS
 +6VuBN+r
 pWlpcvFsKjGQ3Esibrv+063mJ8bzjB1Q15+NZtkCncKpmaR5mxVi1CcqtvOPaPwueB7DnfLlThahhWVy1XOJfybkzYhJWRpjkFn41rMKfYkTI0m90ZrR6IFB1hOJTHU0RNX5P49A8zRS2KfjHE0sYKKjQG3zzdL+NRrLINIHL+SUGHbCVF5SgqvwXdPR3Z5ZdHbCWb/UOCpYjwOG6FTkTuTI5BcE+EQdu2OopOPVy09O98E4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:28:02PM +0800, Jianyong Wu wrote:
> Account for per-NUMA task count preferences within per-CPU sched domains,
> mirroring the existing implementation of LLC task preference logic.

So in general I would really appreciate a few words on *why* you're
doing things. I mean, I can read the patch and see what it does, but I
cannot divinate (esp. not without yet having read the rest of the
patches) why you're doing things.

This is esp. important for large series -- or series that do complicated
things -- or like this case: both!



