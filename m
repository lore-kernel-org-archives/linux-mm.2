Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 463E6C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6749D6B009E; Fri, 18 Sep 2026 03:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64C826B009F; Fri, 18 Sep 2026 03:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562026B00A0; Fri, 18 Sep 2026 03:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 342E86B009E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:04:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1574D1605BF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:04:29 +0000 (UTC)
X-FDA: 85225994658.25.05F8762
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 636594000E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:04:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/LKqi2L";
	spf=pass (imf11.hostedemail.com: domain of namhyung@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=namhyung@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789715067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7MrO5kHfs9s9gpQkpstdAXZ31bb0e2lmCQcEqPnDlQ=;
	b=KIW3QHpj4KQSRP1OY3gJiheoaR0EdRHFqEC4bOOVAO5JFqIDcMgWglbv84oCarmZdegYFX
	xYg4LKc4WKda34o5ec5Q4r0IBgd+0CMZEVHlx0ThkN8LspKIvGCxJEkXVUt6zjxtrbG5uA
	hb9MssJgXhj66jt/HXov3ZY3ZsD6HOQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789715067;
	b=h+9scCbm08HUmf1LYyQZwmURdOiDDF5Ck/KSL6YarjARoovrxamKpy4m+Z5OPt+8KQmQ+0
	bjNqPVK/Iy+JA2avS38BtsVDq+muq1Hy5yKQppXt9fqMrH4J0dr8SOHrnu9Z0AUFTJMiYN
	0uT4GWbGBK4w5Mr/tJAYEKVGxpD+h7U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/LKqi2L";
	spf=pass (imf11.hostedemail.com: domain of namhyung@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=namhyung@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B62A7403E7;
	Fri, 18 Sep 2026 07:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFB51F000FF;
	Fri, 18 Sep 2026 07:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789715066;
	bh=h7MrO5kHfs9s9gpQkpstdAXZ31bb0e2lmCQcEqPnDlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P/LKqi2LqAKG2z2uozCnUWME8OGZ9RbIIELAHHwTXvdmqJNNhcB+P6+T4o1eQ8bff
	 emGEtPWT0PNKHunU+e67JP0rY4/3Tgr8kyp6GDWN5FCOr2JHeXpqhM1RzrzJHkb9Ew
	 brC89Jmwg9/AeYM1XEAol1WvLn6e+jB9Z2r8WtID8EVVzKhebhWUcARXEcnzhnt6y3
	 r34S5YxuU4zLWiUFw7Zf3wQagohKhQK4vsCUZTFh3QOxASwCM3MANSEXJOLdQMuvVu
	 1hUCQ3DHh2wB0WW/fnGCHvw1eL+/L2pnuOVar83DD1+R3aG+zlkAmPp42idM32aMKO
	 /aI0Z7fDCQizQ==
Date: Fri, 18 Sep 2026 00:04:24 -0700
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Harry Yoo <harry@kernel.org>,
	Tim Menninger <tmenninger@everpuredata.com>, linux-mm@kvack.org,
	Chuck Lever <cel@kernel.org>, linux-nfs@vger.kernel.org,
	Jon Curley <jcurley@everpuredata.com>,
	Eric Badger <ebadger@everpuredata.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [SLUB] nfs_page cmpxchg_double_fail and perf lock perturbation
 on dual-socket NFS/RDMA
Message-ID: <aqzieNW5GmhnU_EJ@z2>
References: <20260916232227.4098143-1-tmenninger@everpuredata.com>
 <aqvq8-6IJBDer90O@thinkstation>
 <aqvy8NqRRRmUlxjR@thinkstation>
 <20260917152959.GI4121339@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260917152959.GI4121339@noisy.programming.kicks-ass.net>
X-Stat-Signature: 8799gc8boko7isqm3j3419773aed5p4s
X-Rspam-User: 
X-Rspamd-Queue-Id: 636594000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1789715067-404298
X-HE-Meta: U2FsdGVkX19y8B05O3vHOrbzZrXXiK2MnFJQxHsG9pGCICt8Swmylw/gez1nNqMG85TZRwIZCEd/S2pqRHdmMY4oqYLOcdjw60xpyu/ngxwjEiMc0ATK87AXBLF/1ZrUJ4TYM8NGK/2PwU18ZMRJHL70BCc3Tl7yQ5RNWELiCGbX/PkNcsFkU5e1noP+Fpb4pMcagDH5sjXpa3uVtW4pBwDTskug5wq4iEls/sxIBMKzTR/P5ctKGiAb4tJC7xnudbYjVoVSSbGUQ0zGlWxvdhx7c+NuJT4jG8sxQ5tl1Y8amIlIh8tGNl0rh2iEFJdc7VGbSNrnh0BRhZZlC4Lcgdt8E4JmJ/ezR8DL2qyGBLqekkqjcAnm54PPK7g6XbXI/z5uNK6QoHI9z+7dkjBAU3RQJFFapEVV4vGgFWCDrrU2sSiD3P082kz+6q50xPXVW/2oop8+Q9AbeEZmyUyf7iEItBWqSHYOhhtz9WoaH/9XYGECFPskLxYfY94rAwuABo3GIZOYacawmE+LBjqK2O33jSTyHibOBVWhX0RwHNqafXPH/Y+6pLL0N9JiQxIIlXxhyvmVOnQNIkxhDsKNTwr+J4vuWRMdtEcWdLd5hz+DMARK/xVzVv/U4lyz6S4bVF5lrBMMR4RpmEnOefhsGQu/xm1jv4VCGUyayI4zne07I9Z/OTannrXvWBprWTnPTVlIVAY89Y/FMYSdrEL5FeJuTatD2uMPQdZFvNkFdLOrpjEvjVRCB2rHbvE90yGWyacOTpNNiXXsGEpEfK78J669GTTlJB9Hd+5UFRRedxY0aT+1aT5JPCPE6SU97s5N8eedo6h1O0+2E997iL7xKYeqfdczWkVxgBU4FOIpnTQJyw21lPnoWq04bStNG6Iv7z9qJ4W3W6gFUoOlBRwzoQh52NlnE2cdDZtgAAuEbti6sxO5VWJMe1WBfHs8QaWK2FKA1a22ixVZ36zG89s
 N2Wlfa8R
 Ju8SdQWV1PLs0iaLIq4LD7bLanfEqJ4HMenyt0AC8vS78oT1wtfEKcnwhnKCwDPAjyPEM61A72zHaMWcWQsOio6YwJ8AfZuFPaU0n3JWlgQCz2OGtFzNC0k4zuVVwbpsZxd3eS3N6MpfUXXuhd0boMRpjQ1SkXgocA+OeypSfoe9zq5X6Gby7hfLxA2Ir7mZOzCbSCcVVDb3Udl+BHDhxa4RQLqoIlkN+ukQ9197Cwu8kCh62DWLen4xIyy0lHbE/7rpUm3HnvIpXsZKbBlhoP5NvCX7P5Fm38aR4OOZ0jzBWVZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, Sep 17, 2026 at 05:29:59PM +0200, Peter Zijlstra wrote:
> On Thu, Sep 17, 2026 at 03:10:47PM +0100, Harry Yoo wrote:
> > ... now I realize we need to add PERFORMANCE EVENTS SUBSYSTEM folks 
> > as well ;-)
> > 
> > Hmm, sounds like perf lock is somehow triggering slab allocations
> > and interfering the workload.
> 
> perf should not have runtime memory allocation, its build to run from
> NMI context. It can allocate some memory on event creation and the like,
> but once its on, there should be no more allocations happening.

Right, perf lock record command will save the event info to a ring
buffer without allocation.  It may lose some events when the buffer is
full though.

Thanks,
Namhyung


