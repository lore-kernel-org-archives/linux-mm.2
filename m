Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC189D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 05:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AABBA6B000A; Wed,  3 Dec 2025 00:25:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83056B000C; Wed,  3 Dec 2025 00:25:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0466B000D; Wed,  3 Dec 2025 00:25:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E01E6B000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 00:25:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 268B71A0472
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 05:25:39 +0000 (UTC)
X-FDA: 84177022398.25.79E88EB
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 67B7520006
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 05:25:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NPCnnbp0;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764739537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQd4Pt3H9b8tI3sXslpzNlT4s0PF8/OKfUrI48cqcy0=;
	b=uBmsYAmqYH29srkL+Fx3p6ZRhW0amyxfiusWNAzUNQyE4mGpYlMTwABppecEcShWBQLQIE
	igAeZkpbYEkrd5RqX/7Tjkk1y3T8WbgZs8BpD4a+CVTLXS+hI8+QvTHy1dPSUZlSS63W0Q
	se+TNCYIrnFPmZ2G1TymoekVUdkfrfs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NPCnnbp0;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764739537; a=rsa-sha256;
	cv=none;
	b=yd0IZhNd8Dd/jC+GP8qp5s2HmRVRyLpZJBNPCg+R6GaJQk+AGMUTG2LPwjoremW4/icSUT
	CPFUt/PnzdFG6QbqTq58U3FOCltRdHV/aF6K0CrQT8PDPXPG7Z2V/XLqHnzukkQ9Bm2Yev
	16L+Or5Wp6flNE2iB0yRfO5/iapaYiM=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b2ed01b95dso611304785a.0
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 21:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764739536; x=1765344336; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JQd4Pt3H9b8tI3sXslpzNlT4s0PF8/OKfUrI48cqcy0=;
        b=NPCnnbp0Y4QJRhwsxIPWguhyZxuEedwvjqbaEhk1jbedyzQKoeWiDSZcQoDyGBWQs7
         qkZ8IQ8k7DvUfquVRPvNrBhKu2P2AaE92xg0FLaCgWVWg8Ke9085VGbfgK9B1z8C39Zb
         f2HhWYZmYsZdYGWlBaZgl/V0nbR97CpukX2MQBeW1A/TSIJgARMOI0PlTrQq3WKzD8pr
         fZ0gABYgQEeOiFDcJpSQaGRxaEIDGXzBiWewbuznOb+aylVnHus/Hmqpv/byTki+xHxp
         nZb+9RmlZ7AaxVXdpjsoIu3l8Bmai8aXmC+pe+4Ef/ddsvmqaSeRD2v/dP77fJ/a/+As
         P4yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764739536; x=1765344336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JQd4Pt3H9b8tI3sXslpzNlT4s0PF8/OKfUrI48cqcy0=;
        b=enqsNaGi2uN+QAZaqEe3CAIFy7moJH/ryFi/BVhERIVdwCHphQLbyMldiuqjV2Pj2X
         KeI/52Ty/u34TulfcswU7jbpvCP4TJBuLL6l7zvO5AWgnls/TqIwJXOk2n4eJvPvx7zL
         pby0JZlKzN7yTqJWKUIXL5a+BxdQBss8VHLkrOkirRM3L+Jfd9p4DRZ8z59HpRwjK3a1
         e6si2ZrjzNSgWvHTOl6IdT9HNdC1C/2Asd0hkM1UeAxXN/q0GAjIKmZ0yJCvCNZqhOp6
         tHoW9niSgqA0KT/L1UGCsRsEuGaIerBdPVYmwLDF3IL4tyje/9V9WmpWqO4Cy2sSyufQ
         rcqQ==
X-Gm-Message-State: AOJu0YwM7wNudViLjkBUORgo6kUQ5XkVonCVoei0uIZuKebwYkfxZnUK
	Z0y1cXqGcFz5yJOBq/XRtQ1grWW6E4FeP+XkF6V8yXu8ZC+VrCkWRlMOyThL0YprdUm/k0FDt9s
	uV7ye
X-Gm-Gg: ASbGnctclwoEZEJp6iRz2pcQjAjmS2wtmQlGAx6NX3RXbEFKkGB2uY1gki+OaQnRIU7
	/24MwsSQ3dV034GEueXiELKvWXmjUoEPNR90MRMPJIUI80UElno76PbhrRUiLRzANR5x7Jva14I
	5/7f9KkW3DMKQdoziJ0stFQxrlPrUvH1VOXChTFEYDnz+K7AT937UZ5sIDMPAri+lX5fxBBqgvk
	BOVrNqKHbc4ivBBU9JwsZ/BPZi2OgSKN9ZgkIkYXYFcyLJPim7XzaYa9O+jOEvUY8MXz22Amzsw
	pFHVBAox+SeEXmCGf+2BoZF27SvAyupu/9rNhy++G8YX2aKs4ioaCehtDSGtTyq2M5Jcd4D3C1I
	ZEy2clV5mhXPBwS4oILJLAmIqym8bxLDkRoOAR8gwYkvl6AL7ESEYJEPdYux3B9DPY8xxq/Ew7T
	AbqzBm/uYxSOt8ZhqJYKLHW/KrNt9ozGy9WG4V1GGXOcyzJqNgWW0QYFAObNomNi3zU0zbEo4pg
	Tv982ja
X-Google-Smtp-Source: AGHT+IEtBXE0acM3lcuYUfkevwa5ntm2r18hgzk7j9m68t378myjOMm9OzJsbsysg70BSpP5Mhf/2A==
X-Received: by 2002:a05:620a:4629:b0:8b2:dccd:7315 with SMTP id af79cd13be357-8b5e7453f0amr159953685a.88.1764739536329;
        Tue, 02 Dec 2025 21:25:36 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1b65bbsm1227681985a.33.2025.12.02.21.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 21:25:35 -0800 (PST)
Date: Wed, 3 Dec 2025 00:25:33 -0500
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, mingo@redhat.com,
	peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	rientjes@google.com, jackmanb@google.com, cl@gentwo.org,
	harry.yoo@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com, rrichter@amd.com,
	ming.li@zohomail.com, usamaarif642@gmail.com, brauner@kernel.org,
	oleg@redhat.com, namcao@linutronix.de, escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
Message-ID: <aS_JzWHHn8hBHSCe@gourry-fedora-PF4VCD3F>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <48078454-f441-4699-9c50-db93783f00fd@nvidia.com>
 <aSa6Wik2lZiULBsg@gourry-fedora-PF4VCD3F>
 <36edd166-7e11-4d43-9839-42467d4399d1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36edd166-7e11-4d43-9839-42467d4399d1@nvidia.com>
X-Rspamd-Queue-Id: 67B7520006
X-Rspamd-Server: rspam02
X-Stat-Signature: 7xz88ezwxeyjeoe7pjgm3buq8zctmcrb
X-Rspam-User: 
X-HE-Tag: 1764739537-248839
X-HE-Meta: U2FsdGVkX1+0qUXlqbhyLOjhJqWzDFFBSV0wFD/ofoCfQ3kDRG35nkMWBN5iyH1zv+ogmw+e8zosNrqIr1eJdPOqSYXH8589tBi6TBsSLO9cbxtVk1ZUnRcGBFx51IfUefdqzAmdI+BEzCSoGuazLDCsySGwaYoWUp6VYMGBY+U4IK6oYblNTaca53O3U5i+91EP5UhmoLrQt2Vu2grhuOxUXQpz/iO5yMfohiCmf9v68/eZpBwFwCyiwKIgHz6+aHNyimvHHTUq3nBdrNU9ZHZurF1hM9XHWgBQXOQvO6czvbB4nzLZLgoee3dQ/amPHK4LR6D/vFXcKXT/9rD4FmdhVC6IsoYuCRGv5pXnlS23f+QlAPyOxFfP+w1lVewYBinesYATuur2gtDc+U8JbAvU41WOhfmwbPdshHPvMekf/IYx3vL/GPQ3z+QTwC6hxFMNm5nCiDYOCrslSlGZHYBTyHo3x9QLeoAKvx7EhJmvhfpNbaZ3Xd61UPuBWFHoyxtI4QvmZpT4yDGMfQFCWUbgn1tjUXJLr2D6syLHWo1upRJsKdYuvJZ038BOCsB5g6UgELScVjfCQtiGXGmdjrwr9EhLJ33vX7iUFRlq8lndztoayRfHSwJ4lF7PuRZ/oypqqMs5u22rv2huryugwjsR2kUOjfgJRCgWQEm7BQw4C5FkoZZz5t9iLNBlAFN6RUqQBNY/TCT3qFkpWlY8bv7qGrE10cHnerbh8hrKR7Fg3MHLLzhNhXkSpfADHwOALjYUPznMYKxk5ODMWjTi7q9/2aOpQW97DqLY/Da2u4Ax2B+u3a9UEC9scgeDo0EKl2snhdlag0NBEJjleDWhT7yBQj7mWZyMkT4TnIXBlRDC8xzoEWrqYEPzBeFDZqf9w+xxx4v6MdHnp9z6EWvyPabA2aaCLTL9WOxu3C0PEyNjClt53RBJoEqNU0dI9+rxAOOYGazn8cgslSWWqhe
 is2D1+Ix
 TBFFymFJ5DPy3jPe3gt+pMJzZc/l8WHm4+6yV7q/xcdLzhBRPKdkaR1qDHBxtZul+EE0MWookqjVuIuQObCbXyjZTg1nxEyCoa1OI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 03:36:33PM +1100, Balbir Singh wrote:
> >    - I discussed in my note to David that this is probably the right
> >      way to go about doing it. I think N_MEMORY can still be set, if
> >      a new global-default-node policy is created.
> > 
> 
> I still think N_MEMORY as a flag should mean something different from
> N_SPM_NODE_MEMORY because their characteristics are different
> 
... snip ...  (I agree, see later)

> >    - Instead, I can see either per-component policies (reclaim->nodes)
> >      or a global policy that covers all of those components (similar to
> >      my sysram_nodes).  Drivers would then be responsible to register
> >      their hotplugged memory nodes with those components accordingly.
> > 
> 
> To me node zonelists provide the right abstraction of where to allocate from
> and how to fallback as needed. I'll read your patches to figure out how your
> approach is different. I wanted the isolation at allocation time
>
... snip ... (I agree, see later)

> 
> Yes, we should look at the pros and cons. To be honest, I'd wouldn't be 
> opposed to having kswapd and reclaim look different for these nodes, it
> would also mean that we'd need pagecache hooks if we want page cache on
> these nodes. Everything else, including move_pages() should just work.
> 

Basically my series does (roughly) the same as yours, but adds the
cpusets controls and a GFP flag.  The MHP extention should ultimately
be converted to N_SPM_NODE_MEMORY (or whatever we decide to name it).

After some more time to think, I think we want all of it.

- N_SPM_NODE_MEMORY (or whatever we call it) handles filtering out
  SPM at allocation time by default and protects all current users
  of N_MEMORY from exposure to SPM.

- cpusets controls allow userland isolation control and a default sysram
  mask (I think cpusets.sysram_nodes doesn't even need to be exposed via
  sysfs to be honest).  cpusets fix is needed due to task->mems_allowed
  being used as a default nodemask on systems using cgroups/cpusets.

- GFP_SP_NODE protects against someone doing something like:
      get_page_from_freelist(..., node_states[N_POSSIBLE])
      or
      numactl --interleave --all ./my_program

  While providing a way to punch an explicit hole in the isolation
  (GFP_SP_NODE means "Use N_SPM_NODE_MEMORY instead of N_MEMORY")

  This could be argued against so long as we restrict mempolicy.c
  to N_MEMORY nodes (to avoid `--interleave --all` issues), but this
  limitation may not be preferable.

  My concern is for breaking existing userland software that happens
  to run on a system with SPM - but you can probably imagine many more
  bad scenarios.

~Gregory

