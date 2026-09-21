Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C379AC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66876B00DD; Mon, 21 Sep 2026 11:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0206B00DF; Mon, 21 Sep 2026 11:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE916B00E1; Mon, 21 Sep 2026 11:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98D066B00DD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:31:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2431E40200
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:31:59 +0000 (UTC)
X-FDA: 85238159958.03.BE5631A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77A6DC0013
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:31:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BpWnWfx2;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790004717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuUrqWc9bTGN2ILuKnc9hMdv0vV4JMwCLib1Eff7GPo=;
	b=6JuS2UcBw+bFXact9COYMwdcwInhzi6oU3po8gvsK03TCWaT1stFIzp6wFKP89FB8IUqEg
	HaWD9V4pt//A8goAWRJCZfMwoft7wQg4/Bicki3CB4QEoGeL9Dnk71hSkM0Cj2sLqssOPZ
	o9R9kLdtaMxlpvSFLFbymsJoD73cXL0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790004717;
	b=xgpRO7pbP67DOFODIR7BpYXamIWzJ97/m2EzQThgjOA/ez2fNR6ZTiGHXbiNblDFfKnb/3
	579vB8N/gnfEutMFyThdNTe7lNoZRUKtBjSDqioMfQ1YCsgvUsAvOIWbg7rnRttoccIZdS
	cH6BEvj9kJixuZPzve0ZrWc8y9Hwn5k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BpWnWfx2;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C04D940244;
	Mon, 21 Sep 2026 15:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C741F00898;
	Mon, 21 Sep 2026 15:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790004716;
	bh=FuUrqWc9bTGN2ILuKnc9hMdv0vV4JMwCLib1Eff7GPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BpWnWfx2ds3Fe0emxSeG9TZPaU0fjs6BNTQP9KkoI+3KJtqZ/c53fPAcFTUWz4E1b
	 23fgyM9QIldp/Ud7j2JcDXbZR7MY3ffMBZMYTMjb7RHPDAQdV9oFWu/rPLi9x75GdW
	 wqLix0oxA7ZjiuZuAA5szff+krYbGlVAY60Gh+q5/5mdR9xpLfCA1oHMoqB6akI1o5
	 xPtXZ8W9vQG4uA61wqDz1XOlOPTV8POlHsKzV5yG8b+GNPUIXpVntti06qvivtGb+H
	 4qVvcrlSiYCVXujkEwaEmTL5GzWaUz1EzJqeRGnEicy8fFZx6Er5LvVSJrxOpJSCqA
	 krGUh0imuKFzA==
Date: Mon, 21 Sep 2026 16:31:53 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Tim Menninger <tmenninger@everpuredata.com>, linux-mm@kvack.org, 
	Chuck Lever <cel@kernel.org>, linux-nfs@vger.kernel.org, Jon Curley <jcurley@everpuredata.com>, 
	Eric Badger <ebadger@everpuredata.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [SLUB] nfs_page cmpxchg_double_fail and perf lock perturbation
 on dual-socket NFS/RDMA
Message-ID: <arFNKeseUHBvdRCA@thinkstation>
References: <aqvy8NqRRRmUlxjR@thinkstation>
 <20260917162533.600472-1-tmenninger@everpuredata.com>
 <8705aa4f-5e02-45e7-ad45-0baa982a8c02@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8705aa4f-5e02-45e7-ad45-0baa982a8c02@kernel.org>
X-Stat-Signature: jruds9cdceru3bme467sbtqz9ri49s34
X-Rspam-User: 
X-Rspamd-Queue-Id: 77A6DC0013
X-Rspamd-Server: rspam03
X-HE-Tag: 1790004717-748680
X-HE-Meta: U2FsdGVkX18FQQfpZvKDUOf7LeQAleZMWztoyQ1Um01XzMaUDGqTmaoSnrvLhYauZexf5NkkI2tcsIFau75AzB5uacZD4/AF3EwEJYf/XiAhFhgeM6uHlKRcDT0dBr7IQlbmkX6WCUvQJvq+ejuP5laxhzbBHvODqPOIy5rZx2AHYSx/Q6ZLdqPI48vX8WntZimoCTlXkH3H0mwo+bUorvCFpQsMRueIa7PhJIBXW60plnUEZVR/01bBkBiJNVTA6sIVrPE8UtexgR+8zIWsH0aMJt2r9qcueNdDLGb1rZ6Sol1tO18ZmB66hLRhKFXuoy/yJlcLWrJfd19tSW3yEdVtyT8Zn02u0WomeB2vWO5OjfRgFLpmPERmhotwmGqEOidte42Rl9wzYWPPjAiLEjTi7nonoUjSgtQikPJy820iWFXHLW46/ssTCbAht+IBvxFXGLfxh3bnSImOS0tOgkkxoRA5lHl9PDsdf+euWuklfLMjMVcw8iaHhia4eykJ/x7x+QHPeYKu/nEN4KzugyGYTKa6c8dmsi+FIlAkcqqjhoDqDlbTkiMW2B4YDvjIdUqu+XZVkQC6lCerTR/R+95gElW7aCdy8i126umn1klnyp6eGfByahw5FGvDZ9YVCqwZtGvsrKjk9Ex0gOXGxXOyHYaXR9N/ZE+CTnJWtP7myB2eGGQX5TBmk/E5xolSVLqI76N6d9IO+eujEG02oZo2jDJqFQ78JcNUfrp2evD2V/YdtapLWutGhgLvsMl7u1NUEcWIdL0IL7HYnA8yORzIgSiGq1mhM8rCP4p5ZwYSn9zti6UaWvtYqL2Fx9XgJoJSirhYA9vktOzSGs4iu1AnI8an3uZiREL+nXLF5I5wzhWRGj+hFRH8j73rzY2XxXSJGJ51P2+AVAFRMj2g8SFE6a8/m6ueaYhT82PDJpIAymIdNho1gH2SHZB4P1AIjiXyWTpmMuw+ebfepQk
 pU0W0AiJ
 bOWPUw2V0TlAagnJZgaHMTJUkOzVBTfWCO9Q90I/EtzcyElHcjkRrCbRjCw33aCluV5sRhrKKaSUKJZlEaoQPCwE+nz0Q49OV0VSPwl1/QoAailUesOMBzBl8KELaiVggiqA4bplcB02r+tLIO7MfsQw81jbdL/Dk6l+zbjVfDndUyMmsytyOw3Y7P+oeATz5fTTj4YlzvOBSsV7athZnoDT2fF5VZ1GEFXSOpKH+n6F8jeVJOAs9QgQ7syg/I4LRI/T/okny2DppKDmYF3OpRDnodbshibaqscY2RgHkqyZ6wls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 09:08:37AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/17/26 18:25, Tim Menninger wrote:
> > It reproduces with slab_nomerge.
> > 
> > I booted the same kernel with:
> > 
> >     $ cat /proc/cmdline
> >     ... slab_nomerge ...
> > 
> > Uninstrumented throughput remains in the high-45 to low-46 GB/s
> > range, as before. During perf lock it was around 30 GB/s in these
> > runs, versus roughly 25 GB/s previously.
> > 
> > The dominant lock measurements are essentially unchanged:
> > 
> >                          default             slab_nomerge
> >     unpinned/node0
> >       contentions        4,782,839             4,858,759
> >       total wait          14.39 min             14.26 min
> >       average wait       180.47 us             176.13 us
> > 
> >     node0/node0
> >       contentions        4,582,012             4,686,729
> >       total wait          14.13 min             14.34 min
> >       average wait       185.05 us             183.53 us
> > 
> >     unpinned/balanced
> >       contentions        4,572,196             4,544,677
> >       total wait          12.81 min             12.56 min
> >       average wait       168.14 us             165.84 us
> > 
> > The uninstrumented cmpxchg_double_fail deltas were:
> > 
> >                          default     slab_nomerge
> >     unpinned/node0          7,471          8,892
> >     node0/node0               713            457
> >     unpinned/balanced       1,503          1,504
> > 
> > The CPU-utilization change while perf lock is active also remains.
> > System-wide %idle for uninstrumented/instrumented windows was:
> > 
> >                            default                  slab_nomerge
> >                        uninstr.   instr.         uninstr.   instr.
> >     unpinned/node0      31.46%    3.60%           23.02%    2.15%
> >     node0/node0         84.26%   12.07%           84.62%   11.85%
> >     unpinned/balanced   66.86%   14.83%           66.58%   14.78%
> 
> I believe the weirdest part in the original report was how slub stat
> counters such as free_fastpath etc got order of magnitude higher with
> instrumented vs non-instrumented.
> Did any of that change with slab_nomerge?

If it didn't change, that'd be very surprising.
... unless perf lock was writing data to an NFS filesystem?

-- 
Cheers,
Harry / Hyeonggon

