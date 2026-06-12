Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E782ACD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36DBC6B0005; Thu, 11 Jun 2026 23:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DCE6B0088; Thu, 11 Jun 2026 23:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D166B008C; Thu, 11 Jun 2026 23:48:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3B36B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:48:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B095A1C2E20
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:48:19 +0000 (UTC)
X-FDA: 84869877918.16.64B6FFD
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf10.hostedemail.com (Postfix) with ESMTP id E3888C0007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:48:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X64yesLt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4acUcN5cewJBmGpl3WpO5aKCvDT+7GaPC8r+f7iGxU=;
	b=WoJG49umKeCFLWW+3cXNAsbRXj3/ApaxvPyd3q50MLJl/vO/rme8mFsAOxm/geNg8/U0zc
	VZLkWjfHBd7GVxyhyKD42u8js4igmSdNKvo630pgmuPr2BRTsZ5g4uE29373UvjENvUiBH
	uy08Fvq0P0mTIu45YdwzTaLDyPgr5+0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X64yesLt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236098;
	b=3Myc2L2HV4obSiNmRIWzwBurUtM/0ZkcrMymr+cmzHjViDHLagh4JJvB7CNWf5Lz8LufOG
	o2+hPWh7rTofN5YSV2eCrAxjA1czQDnei01VdQiCgY927drm+tAoboX7KLv/OWjXnQhUuE
	ufLnMRhf0pod3ZeQAXzPUofRfhAIDyY=
Date: Fri, 12 Jun 2026 11:48:04 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781236096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M4acUcN5cewJBmGpl3WpO5aKCvDT+7GaPC8r+f7iGxU=;
	b=X64yesLtOC7VbaPN8dpYre1uzI5cHOBiNSM9VJh4CDBD7FO0tzhTA7DmzzyhqknI4rADra
	lWe+NbZpB4CSHevsAVgJg2T/aiD438EaEneqIMDDPTVQQhdqPTbvWkJVWF/y1h0dzASrrp
	faoX9kIfCeBVGwAvx9kNvUW8DDUyYz4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 03/16] mm/slab: stop inlining __slab_alloc_node()
Message-ID: <aiuBW_xY6x5IBQfE@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-3-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-3-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 494yfh6ikd9sjjro7phz5en1eo3fot1g
X-Rspamd-Queue-Id: E3888C0007
X-HE-Tag: 1781236097-208317
X-HE-Meta: U2FsdGVkX19OWRGYZvZWjh+mhhls8V3oXt/zHDFHFN1NG246HejUPuhIc4iAUnJWBiBZEeJ77aXedrW7brvBLeKBaFtGPGZCl5Erm4c+aGOJKtZbCbmdvxLde75VnA/jNPartacT/ESeUotbBgCJnTPrxDNsB6gWKT3FRFml8tmfKv8gbxFidXWmRDOERNJCv+HmwRknIMRqbEbaZOBwgM30tl2JG/neL+k0a01duPbZ0BY2qA/AEa/RJXngaH8MLm6hxgdZQZApzkKvsrtVyTzlfjWO9xnfrDQUrQ2znJWiIh13icWQ6VaeeboaETcqbcqIfG+olnoEF/Ht8MxXlzX7CfOv3PorxO+SY4/J5Qy3PK8uT/gXJMp4P1RJDpTl9/e6Ecn/Jl6cOrXGtqURR9m33AZ6Ru8fSDGicNJRJuLbYm4JEzc9jlAVsVYURoi2J2dAtyJqD7NcqsTnG8Kz0XGPHoWFmszoC5E8iLrs30dB31WHtEgrC7PdF1zkvQ2rsUrHBoc/g/Li7e+fpMP/Rpf8soYOSiux0rh1Mu420QeEWbHFv2ydBShHE/2/YdxbA0lMknpyb7HWC/cjcn8a9TY/UeYc9fn3W7sHMJRmg1JoQFFa/C31Schmchy9dGZPma/vqN+gy1iGtxYDpWzrUxwSODD5WxbQenA8i9XZnVIblhJqoqHgRYcnLL48CFymxH+OoieyvXbiP5h3nn27gHtoUn+bHwRKFFkvo17TzlLlQtVDcZggwkZpafnby9QsWka0lVLYERkbj8IlY9+7izsLmAXut3k0BXjxQsJO3zgmqnN7tTrrcLycye+A/aSdjS//GJPmHYq1M4rrRaVzLpkrN6MUH7ctAdhqIawpqBvFpGTB0jkKOd3aeXa+cRUno75C/X1+rGtXWPuc4L/3NW9C4YVMZMdFCdF7j75TOvYTgaMrv6inhOyr4lOEoqwL1uAL7UG3WL8S10bDGeS
 J62uKu9X
 C1BinX/0QUgmu8+LV6PTZdUD3L/qLp5c/L1+8eJjAsgOtbUH8d87Fm4SJ77qFeb87k4m7qlShfpA8CvEpuTylDFVq12WpChJKbgUt5HcSLL5s2LecMO6OHJJEyQ9RLFXupUfXcQnUxAmYqWd64k3KVki2BMEQv//ShVwPiuE5L7tClnRvknCnXIKe0rhK0NQipajnbG+BZDdhQJwHKyCPiCHAWdMIUXgmW6AqCrzVx6ugdKh/pmMeV6S+rSoF/dk6rdlUQAiDoc1dgxaCpeHvT22TPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:05PM +0200, Vlastimil Babka (SUSE) wrote:
> With sheaves, this is no longer part of the allocation fastpath.  For
> the same reason, also mark the call to it from slab_alloc_node() as
> unlikely().
> 
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

