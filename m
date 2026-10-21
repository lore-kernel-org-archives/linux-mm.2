Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8024606A329
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lDNcjg0F
Received: by kanga.kvack.org (Postfix)
	id C61996B05FD; Wed, 21 Oct 2026 02:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C120C6B05FE; Wed, 21 Oct 2026 02:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01086B05FF; Wed, 21 Oct 2026 02:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88B956B05FD
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:03:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94E3AC047D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:03:29 +0000 (UTC)
X-FDA: 85345591338.03.CA4874B
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id D6C59180009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:03:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lDNcjg0F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ziPSCJtGYqR9EgWBDjP1J8OHI+3Z8WTF74NVvp9jgKA=;
	b=wxYkZzY8HDwsNYIZvf1HlpJUSuuVWQ4OyrUPetRENCxte9NGTzuror+FOU4BD0h/4Wk37n
	ashFyYmmJxIdpnsbjJqdx8arR6awrCiSC0UppURihWYl/Ek0yyh0a4t/4BuGdJU3IonqpA
	a2SGK98caYVnXCyhBig4t6Fv2ykiH4U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lDNcjg0F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562607;
	b=5CcbaXTfwK6AFGteQuIeApBBz+soNNnhZdu9Iiav6PUT0zPi9ImxvJsnpR6Xtq44NqaF9U
	ifMDeuBuVqdeaNt8xUJIQ3lf3iazVJZcKCJJzIhc52yqGt0SrwuNZISNniJaVww/Wj/3yY
	+VDucWxSTyPE+6NL7S1yl3ME99Mv4HE=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6798c43a3d6so227923d50.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562607; x=1793167407; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ziPSCJtGYqR9EgWBDjP1J8OHI+3Z8WTF74NVvp9jgKA=;
        b=lDNcjg0FQeV4jIKyhUPZp8s6eqlY8YMJzUjWZHRxgL0v0sEzVs8Zid9j7UHRyUncYW
         7uW7efzDyZDiST75ENG9IGkeWgklotRuQAFAnCxAuIZY9gmGpEVoal91IMq52sYXphPz
         BMF9JxNQ5QiZuogP89c6dOGxbk4s3t7BRTC+LWzkt1WboZ7PFVG9j54wUrr9DHR5s4Z0
         JDIoDwmbbGlEs9OQu5qU5BuPiUM3XX1drKvofrsJ6CZWkikdLy/hcICCr4ifxzt77yJQ
         Otv2bAjSOtADG/hj8IG1AZvDcsuu+acPikfLGcEi1KsxBo7k6vkDy5bY5WIDOICthNXD
         AecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562607; x=1793167407;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ziPSCJtGYqR9EgWBDjP1J8OHI+3Z8WTF74NVvp9jgKA=;
        b=JJizHkLF6E+UrUaO8wbTLNoGS23ciEDTSGWJuy2MlFyeQnOE44vJsq/VEbKiF7nVWy
         XrpPE0lzSkmUWVJvYUKCop23OPO/X7XB8WcbF/G0Vw2CT2GBjHYZG1XccXepdJnC4Y0F
         pxN341kJLNTEkuoVQQHtHlcpSZ5Z3GWqTN7KoI9ZZflEjNGVKKVepfQgdpfinnzIYhrg
         HzacTZsTrckZt+MX4mua9hQcEO9QqSa3dMcYl/IE3ShG4A0zGJFXH+Ljww6MLGiDOw+i
         6U3xruRBiEc9BNPZHluhrYXj+PSSUwJC60xWeEHi4YB9LlkZ5JybEDyM3/SDotkw/Vw0
         lN7g==
X-Forwarded-Encrypted: i=1; AKwUvBz5s+bvMtol2CubbO0lPJuckuPaayjOBSVxXskmmUUYiWuwrki/W7LW7V+WA+gzFuSqsUlM7NTG/g==@kvack.org
X-Gm-Message-State: AFq9FYJGraGaqdYsEzkc71Wf2Ub/rRDdBKy3ziorel8Bob80nTlk/bfo
	aHPo+fVsiMO2uNw1/6LH74sZ2yIFWcaSlROYvpnSEnVWkZAJVhLhYCjw
X-Gm-Gg: AYBFou29l9twCsy7jOK+8P7JAyc3yxpUG9UcHXGlGNFZciw2Ljq0cLP+kZPxFPaBCJ4
	xti6UJ/65dMtBd9goVdOwJPXXWMgWsYYtFN2n/bl4f2XaxzfB+C4m/jKV9k17QQl+ED/byN21GP
	+ixytZpiVVFP4TD8Ne10AsAuzLihmVdkDP2SRn7UF9XPzW1ITSL/9nJVPZVg55JEsAxJbH/Tjc+
	XVZXDDA5KwpzxIUd7QmkeiC0malSIhy9IDEqaZrSm4tOZkvJ4gy6xawoD9oEB1/KMds66ohLWJ5
	N9n8yqBV6uATCT+5HYxIy/iRM87WSI0yF7XAWaJxbPPvhW5A94ZzhKYBLwu1c6XA7d1e6pTog+A
	pDxCYrC0WaLmWO1uat2nSXPWkgDd9wPTEhQ488M1r1Ku+5R20r4cHQLZDh5B5nLafrkPhaa+dKa
	OxOmEl9p6Qp9JyyiMM+krbSeIVfErUAEMdOVR4FMeC4LUNIsKEGRaHGGW2yMGkFnR30soPFtSPA
	L90RSUoNG6Z9rimWZ2W1cldJsviyYS7LbLQfw3ccrw8OrfvqDwha7sLZ6hku4HmRutGa9O2Zr1e
	2p5IpM1f1P85OAaBjH7BcVztIoDpQnN6zW4VFUErNneSSWtwVB3IQjUAeCFCIGFdAng+g0eL2aC
	uQx8RZVbNyA==
X-Received: by 2002:a05:690e:458a:10b0:677:d3fb:6b6f with SMTP id 956f58d0204a3-67a0e57e7bdmr295150d50.116.1792562606795;
        Tue, 20 Oct 2026 23:03:26 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0de4f56esm663275d50.0.2026.10.20.23.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:03:25 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v6 00/12] Virtual Swap Space (Swap Table Edition)
Date: Tue, 20 Oct 2026 23:03:11 -0700
Message-ID: <20261021060323.553433-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D6C59180009
X-Stat-Signature: d4tedjmzzwnicagasu3p4dnsxre7goq5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792562607-711131
X-HE-Meta: U2FsdGVkX18JSWRd4fgEKluAjUyEkMzU7XHPXlsWjPkyXzKl7MDlAkamaeMDlW+jLz2rsVYRkK4Qp1tH4HF+/0aO8N8zfocjAlZ2v+Iu5ycKJMVGI1DXyhbtgPTQeIRTSuxRGvWfP8SJd3A3pASU5TrlBdgbWHRs3SDjDHpwfsN+bISBaqJUYcCMI8XWHfUIoCb9DFPSJXaAYNfq6WML/lhFmO2oGOaRdm05zRpqFwEicdoKqg+nvwax4XpqTYN14oONZxgxsGb1d91GVh5yZWgjBInLNht6/4XVupzPo1RDDCwmjs32fHZaYL4b7Os2ctTcDfWdCfQWWysjaIBmipQvgq/XALMRjpRXuoq+YWQqgHhIO9cNSOvM/87zGo0PpCp5ynSRXaAvLDFqcuJgPtZ3MN18b4fDBwtTBAi9T9JaEw4AxaziW0DI0Ig2LixrjJNAgapgdwdVN8c5pozPOAUV4y0YJ2xwX7x1zsXVyNLBmQyYYQdI1T9e/ERBrWqsVeaPwZzmqOXj6jIz19G0tq0jmQwpy0HygMDwsX/jz00ze827NlDo1NWZeCaW5EJASvUvitla/GLCDGGFNeBu+/EtNLJt5vVpoUTnBMX6DkLBee9p3t2bUf1Cuxxc7mijWmSM37LZvbwXBywSknnLlm4fqfV4AYySQHj/OOqqn0VYJELvtuhGEQ0J8tUmH9CgUYCTUMZTb6KGIKV2L0QHF6XqL+/OptkszNxQA0akEiEkWRMsePINB6O92JRE1M5Ca7jnO2sbl8Jgo+KWbNqjCui3nkS8nHVlJTBrPMmbjfQi1aNAswiPs0pIbQHAFDvZAt4zywQG5wo1K9sbaXf6i1x5dvWq4zNAC8P5e5WX1tG/p8dm8hPZJPk5olCQxfyWWK53ljKBbL1/hf7sXi8hGWVwmB18P8xccRp6zWTrnkphqFU1QvfgTNUW3/pbCjucVmZ84GFxml5IOCrMj9A
 MOeHhclu
 L6AID1ZF0rEZLrsBDLr+Bh+RGWms7QARDcgnOQz64ncN9Pf80Rx6EJglZlbgiJ1h1CqciuVImFrSFPP7Jja5Wr5jr7bKjysgmT/33615eHx783O+wVm4nCDOxvkZyVuh3g9l8Hfu8/tRehqkDwmH9fRXezCa3wEwKlZCvTRuUujtKlzjTpdG4VVOkVNsZegpRP62JowtpKr2NdHZfMXuNKKaWEZSBjdEp+nBUxOYzTo2nmfsyo4YioblMOx2iEzB7vb2nmCPQq76RPWpIMsjA9IqgmP/tS8Gw/TEE6lEQDHtrCtu4IZsZULFDHdYpvwz3dA7P7uUN4HpSXveIUpWp/buEY739XwXqNNFhQ0ROMZArwwpaR6L2xIxNMum5TsZD9k/fFBIVMEhUuoCZMFT0+D6+OqaDaGCtcB7QPGRKRpWTLjqZI2gvZYcuoQzoFodlLNgWC+WtgEkKc7+f+9jtpBx02g1CmJoHuiH/ddqTA/ZQJ/rf2TzXDw7tYNJqvKqam48VaArknUQFfYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Changelog:
* v5 [v5] -> v6
    * Added a new cgroup memory.stats counter for vswap slots (patch 11).
    * Fixed some small bugs: incorrect swap-allocation failure
      classification, nofs check in phys swap fallback path, etc.
    * Rebased onto a newer mm-unstable.
* v4 [v4] -> v5
    * OVERCOMMIT_GUESS now allows for 3xRAM margin when vswap is enabled,
      to take into account swapfile-less zswap usage (proposed by
      Johannes Weiner).
    * Limit vswap swapfile size to 8TB and drop the last patch, to avoid
      memcg private id refcnt saturation.
    * More assorted cleanups and fixes: anon swappability check, etc.
    * RFC: Replace the xarray with a new data structure (vmalloc array)
      (new patch 11).
    * Rebased onto mm-unstable.
* v3 [v3] -> v4
    * Replaced the runtime sysctl with a cmdline param, and remove
      CONFIG_VSWAP (suggested by Johannes Weiner). CONFIG_VSWAP_DEFAULT_ON
      now only gives the default value of the vswap cmdline parameter.
    * Refactor swap-related memcg operations into composable building
      blocks: reference acquisitions, charging, etc. (patch 8,
      suggested by Johannes Weiner).
    * Fixed vtable UAF bug reported by syzbot and Kunwu.
    * Rebased onto mm-unstable (minimal merge conflicts).
    * Re-run benchmarks (no signal change).
* v2 [v2] -> v3:
    * Rebased onto current mm-unstable.
    * Add a runtime vm.vswap_enabled sysctl and CONFIG_VSWAP_DEFAULT_ON
      to gate vswap allocation.
    * More cleanups and small bug fixes.
    * Split THP swapin enablement into its own patch (patch 5).
    * Add production workload benchmark results, and drop RFC tag.
* v1 [v1] -> v2:
    * Rebased to a newer mm-unstable tip.
    * Fix a bunch of assorted issues (incorrect zswap store failure
      rollback, vswap_init() failure handling, rmap-encoding collision,
      etc.) and clean up the code (rename a bunch of functions to
      more closely follow existing patterns, etc.).
    * Some more code clean up and simplification: some renamings to more
      closely follow existing patterns, move vswap backing check to
      __swap_cache_add_check, store zero state in the swap_table for
      vswap entries, etc.. Many of these are proposed by Kairui Song
      in [1].
    * Defer memcg_table allocation on physical clusters until the first
      vswap-backing slot installs. Saves ~512 bytes per physical cluster
      that only serves vswap-backing slots (this is the new patch 8).
    * Widen swap_info_struct->max and ->pages (and the swapoff unuse-path
      index) so vswap supports ~8 PB of swap space (this is the new
      patch 9).
    * Split the physical-swap-backend patch into three for reviewability:
      the core backend (patch 3), zswap writeback to physical swap
      (patch 4), and reclaim of cache-only physical slots (patch 5). No
      functional change.
    * Add kerneldoc for the vswap API.
    * Add some benchmark numbers for zswap case.


Patch 12 is an RFC. It replaces vswap's cluster xarray with the VM_SPARSE
vmalloc array Baoquan He designed for xswap [6]. This changes descriptor
storage without adding a userspace interface. The array grows on demand
but does not shrink [5]. Empty clusters release their per-cluster tables
and return to the free list for reuse.

The benchmark results below are from the xarray design. I have not
benchmarked the VM_SPARSE version, but I have run a suite of simple stress
tests.

It is adapted almost entirely from Baoquan's code (see [6]), so I have
kept Baoquan's Co-developed-by and Signed-off-by tag.


I. Context and Motivation
=========================

Currently, when an anon page is swapped out, a slot in a backing swap
device is allocated and stored in the page table entries that refer to
the original page. This slot is also used as the "key" to find the
swapped out content, as well as the index to swap data structures, such
as the swap cache, or the swap cgroup mapping. Tying a swap entry to its
backing slot in this way is performant and efficient when swap is purely
just disk space, and swapoff is rare.

However, the advent of many swap optimizations has exposed major
drawbacks of this design. The first problem is that we occupy a physical
slot in the swap space, even for pages that are NEVER expected to hit
the disk: pages compressed and stored in the zswap pool, zero-filled
pages, or pages rejected by both of these optimizations when zswap
writeback is disabled. This is arguably the central shortcoming of
zswap:
* Resource-wise, it is hugely wasteful in terms of disk usage. At Meta,
  we size swapfile in the order of 25-50% of host RAM, depending on flash
  availability. This is a lot of flash for a fleet of our size, and
  with universal zswap enablement, most of this is wasted for zswap
  entries.

* In deployments when no disk space can be afforded for swap (such as
  mobile and embedded devices), users cannot adopt zswap, and are forced
  to use zram. This is confusing for users, and creates extra burdens
  for developers, having to develop and maintain similar features for
  two separate swap backends (writeback, cgroup charging, THP support,
  etc.). For instance, see the discussion in [2].

* Tying zswap (and more generally, other in-memory swap backends) to
  the current physical swapfile infrastructure makes zswap implicitly
  statically sized. This does not make sense, as unlike disk swap, in
  which we consume a limited resource (disk space or swapfile space) to
  save another resource (memory), zswap consumes the same resource it is
  saving (memory). The more we zswap, the more memory we have available,
  not less. We are not rationing a limited resource when we limit
  the size of the zswap pool, but rather we are capping the resource
  (memory) saving potential of zswap. Under memory pressure, using
  more zswap is almost always better than the alternative (disk IOs, or
  even worse, OOMs), and dynamically sizing the zswap pool on demand
  allows the system to flexibly respond to these precarious scenarios.

* Operationally, static provisioning the swapfile for zswap poses
  significant challenges, because the sysadmin has to prescribe how
  much swap is needed a priori, for each combination of
  (memory size x disk space x workload usage). It is even more
  complicated when we take into account the variance of memory
  compression, which changes the reclaim dynamics (and as a result,
  swap space size requirement). The problem is further exacerbated for
  users who rely on swap utilization (and exhaustion) as an OOM signal.

  All of these factors make it very difficult to configure the swapfile
  for zswap: too small of a swapfile and we risk preventable OOMs and
  limit the memory saving potentials of zswap; too big of a swapfile
  and we waste disk space and memory due to swap metadata overhead.
  This dilemma becomes more drastic in high memory systems, which can
  have up to TBs worth of memory.

Swap virtualization is the answer to these issues, with three properties:

1. Decoupled backends. For zswap in particular, this means we eliminate
   the unused storage space, and allows zswap to be used in systems that
   do not have enough storage capacity for physical swap (without having
   to resort to silly hacks). Zero-filled swap pages and swap-cache-only
   folios also benefit here.

2. Dynamic swap space. Since virtual swap is not tied to any physical
   resource, we can make it effectively infinite and dynamically grow it
   on demand.
   This massively simplifies operational provisioning, and increases the
   utilization of compressed swap backends (zswap). Dynamicity also
   reduces overhead on unused swap capacity.

3. Efficient backend transfer. The virtualization scheme should not
   introduce PTE/rmap walking overhead for backend transfer. This
   is crucial for systems that want to support multiple swap backends
   in a tiering fashion (for e.g zswap -> disk swap).

For more historical contexts and references, please take a look at
the cover letter of the older vswap submissions ([3] and [v2]).

II. Design
==========

When vswap is enabled (via vswap=on cmdline parameter), a special vswap
device is allocated at boot time. Anon pages eligible for zswap are first
allocated virtual slots; physical slots are used if virtual allocation
fails.

These swap entries can subsequently acquire backend on-demand, such as
a zswap entry, or a slot on a physical swap device (as a fallback option
or at zswap writeback time).

We repurpose much of the existing swap_table infrastructure and
swapfile allocator for this new vswap device, with two notable
differences:
* Clusters are dynamically allocated on demand and managed through
  an xarray. This in turn allows us to avoid static provisioning and
  let swap space grow dynamically.

* Each cluster of this new vswap device has a virtual_table that stores
  the backend information of the entries in the cluster (see below).

Diagrams:

  Case 1: vswap entry (virtualized)

  PTE                  swap_cluster_info_dynamic
  vswap_entry          +---------------------------------+
  (swp_entry_t) ------>| swap_cluster_info (ci)          |
                       | +----------------------------+  |
                       | | swap_table                 |  |
                       | |   PFN / Shadow             |  |
                       | | memcg_table                |  |
                       | | count,flags,order          |  |
                       | | lock, list                 |  |
                       | +----------------------------+  |
                       |                                 |
                       | virtual_table                   |
                       | +----------------------------+  |
                       | | NONE                       |  |
                       | | SWAPFILE(swp_entry_t)      |  |
                       | | ZSWAP(struct zswap_entry*) |  |
                       | +----------------------------+  |
                       +---------------------------------+
                              |
                              | SWAPFILE resolves to
                              v
                       PHYSICAL CLUSTER (swap_cluster_info)
                       +--------------------------+
                       | swap_table per-slot:     |
                       |   NULL   - free          |
                       |   PFN    - cached folio  |
                       |   Shadow - swapped out   |
                       |   Vswap  - vswap rmap    |
                       |   Bad    - unusable      |
                       |                          |
                       | Vswap-backing slot:      |
                       |   Vswap(C|swp_entry_t)   |
                       |     rmap back to vswap   |
                       +--------------------------+

  Case 2: direct-mapped physical entry (no vswap)

  PTE                  PHYSICAL CLUSTER (swap_cluster_info)
  phys_entry           +--------------------------+
  (swp_entry_t) ------>| swap_table per-slot:     |
                       |   NULL   - free          |
                       |   PFN    - cached folio  |
                       |   Shadow - swapped out   |
                       |   Bad    - unusable      |
                       +--------------------------+

struct swap_cluster_info_dynamic {
    struct swap_cluster_info ci;       /* swap_table, lock, etc. */
    unsigned int index;                /* position in xarray */
    struct rcu_head rcu;               /* kfree_rcu deferred free */
    atomic_long_t *virtual_table;      /* backend info, 8 B/slot */
};

Each vswap cluster (swap_cluster_info_dynamic) extends the classic
swap_cluster_info struct with a virtual_table array that stores the
backend information for each virtual swap entry in the cluster. Each
entry is tag-encoded in the low 3 bits to indicate the backend type:

  NONE:     |----- 0000 ------|000|  no separate backend
  ZSWAP:    |--- zswap_entry* |001|  compressed in zswap
  SWAPFILE: |- type:5,off:56 -|010|  on a physical swapfile

Zero-filled pages use the swap_table zero flag; cache folios use its PFN
entries.

Other design highlights:

* Note that for the vswap device, we have merged the zswap xarray tree
  with the swapfile-level clusters. This means that for zswap only users,
  we have negligible extra space overhead.

* Both vswap entries (Case 1) and directly-mapped physical entries
  (Case 2) coexist as first-class citizens.

* Backend transitions in the virtual_table are synchronized through the
  swap cache and the folio lock - the same mechanism that already
  serializes ordinary swap operations (swapin, swapout, zswap
  writeback, swap cache reclaim). IOW, we can only assume that the
  backend of a vswap entry is stable through swap cache/folio lock.
  Looking at the backend without this should be done at best for
  optimization purposes, as there is no guarantee that the backend
  will not change under the observer.

* Vswap-tagged swap_table entries on physical clusters provide the
  rmap (physical -> virtual) lookup.

* Virtual swap entries count towards memory.swap.current only when
  backed by physical swap slots [4]. In cgroup v1, vswap entries are still
  accounted towards the memsw counter.

III. Benchmarks
===============

Note that the goal is not to match vswap performance with baseline on
every single case yet - running with vswap off is still supported. We
can optimize further once we have landed this new feature.

A. Production Workload: Instagram
=================================

To test vswap's stability and performance, I ran an A/B experiment on
Instagram (django) workload, with zswap as the swap backend. On these
hosts, the swapfiles' size is 50% of RAM.

Compared to baseline, vswap gives:

* On par request throughput.
* Lower request serving latency (by about 1-3%).
* Lower memory pressure in the system service cgroups running alongside
  the workload. PSI-based proactive reclaimer can therefore recover more
  from them, lowering their overall memory footprint, allowing the main
  workload to expand.
* Elimination of swapfile footprint for all zswap users in the host.

B. Semi-synthetic Workloads (memhog, usemem, kernel build)
==========================================================

All values are mean +/- standard deviation across rounds.

Test system: x86_64, 52 cores, 64 GB swapfile for all 3 benchmarks.
Swap backend: zswap (zstd) with the traditional active/inactive LRU. We
focus on zswap here because it is the motivating use case for vswap.

For each benchmark, we test 3 kernels:
* Baseline: mm-unstable, no vswap patches.
* VSS off: vswap series applied, vswap=off, to verify that there is no
  regression to existing swap paths when we disable vswap.
* VSS on: vswap series applied, vswap=on.

1. Memhog: single-threaded, 48GB allocation on a host with 16GB RAM,
   20 rounds.

                    Baseline           VSS off            VSS on
   real (s)        124.05 +/- 11.64   122.31 +/- 10.29   118.57 +/- 15.68
   sys (s)         106.75 +/- 10.86   105.01 +/- 9.64    101.34 +/- 13.97
   user (s)        10.81 +/- 0.11     10.85 +/- 0.09     10.79 +/- 0.09
   delta real              -              -1.4%              -4.4%
   delta sys               -              -1.6%              -5.1%

Dropping the best and the worst round to reduce variance:

   memhog              Baseline           VSS off            VSS on
   real (s)        123.75 +/- 10.39   122.04 +/- 9.10    116.06 +/- 8.22
   sys (s)         106.80 +/- 10.21   104.99 +/- 8.86    99.29 +/- 8.27
   user (s)        10.82 +/- 0.11     10.85 +/- 0.08     10.79 +/- 0.10
   delta real              -              -1.4%              -6.2%
   delta sys               -              -1.7%              -7.0%


2. Usemem single-threaded: 56GB allocation on a host with 32GB RAM,
   16 rounds.

                    Baseline           VSS off            VSS on
   real (s)        178.75 +/- 6.47    178.95 +/- 6.56    175.97 +/- 7.74
   sys (s)         127.03 +/- 6.56    128.08 +/- 6.59    124.71 +/- 7.90
   tput (KB/s)     386662 +/- 14648   386264 +/- 15150   390443 +/- 17532
   free (ms)       7669 +/- 146       7678 +/- 136       6439 +/- 111
   delta real              -              +0.1%              -1.6%
   delta sys               -              +0.8%              -1.8%
   delta tput              -              -0.1%              +1.0%
   delta free              -              +0.1%             -16.0%

3. Kernel build: 52 workers (one per processor), memory.max=3GB, 10 rounds.

                    Baseline           VSS off            VSS on
   real (s)        165.58 +/- 0.45    165.83 +/- 0.49    166.01 +/- 0.58
   sys (s)         694.24 +/- 26.13   710.76 +/- 19.83   705.06 +/- 21.40
   user (s)       5132.62 +/- 1.12   5133.69 +/- 1.57   5134.68 +/- 1.68
   delta real              -              +0.2%              +0.3%
   delta sys               -              +2.4%              +1.6%
   delta user              -              +0.0%              +0.0%


For zswap backend, vswap outperforms baseline on usemem freeing, and is
on par with baseline on the rest.

IV. References
==============

[v1]: https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.com/
[v2]: https://lore.kernel.org/all/20260612193738.2183968-1-nphamcs@gmail.com/
[v3]: https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com/
[v4]: https://lore.kernel.org/all/20260825153238.2695446-1-nphamcs@gmail.com/
[v5]: https://lore.kernel.org/all/20260918180241.3424851-1-nphamcs@gmail.com/
[1]: https://lore.kernel.org/all/CAMgjq7BhOn48xEyC=2j837R7qddfjeBVHMiRqdx8no4ZEBpBLg@mail.gmail.com/
[2]: https://lore.kernel.org/all/Zqe_Nab-Df1CN7iW@infradead.org/
[3]: https://lore.kernel.org/all/20260505153854.1612033-1-nphamcs@gmail.com/
[4]: https://lore.kernel.org/linux-mm/CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com/
[5]: https://lore.kernel.org/all/aqjpYHbZ14A8xRtK@fedora/
[6]: https://lore.kernel.org/all/20260916101929.149106-1-hebaoquan@kylinos.cn/

Nhat Pham (12):
  mm, swap: add virtual swap device infrastructure
  mm, swap: support zswap and zero-filled swap pages as vswap backends
  mm, swap: prepare the swap IO path for vswap
  mm, swap: support physical swap as a vswap backend
  mm, swap: enable THP swapin for vswap entries
  mm, swap: write back vswap zswap entries to physical swap
  mm, swap: reclaim physical slots backing cache-only vswap entries
  mm, swap: only charge physical swap entries
  mm, swap: add debugfs counters for vswap
  mm, swap: defer memcg_table allocation for physical swap clusters
  mm, swap: add vmstat and memcg counters for vswap
  mm, swap: back vswap clusters with a VM_SPARSE array

 .../admin-guide/cgroup-v1/memcg_test.rst      |    2 +-
 .../admin-guide/cgroup-v1/memory.rst          |    3 +-
 Documentation/admin-guide/cgroup-v2.rst       |   54 +-
 .../admin-guide/kernel-parameters.txt         |    7 +
 MAINTAINERS                                   |    1 +
 include/linux/memcontrol.h                    |    7 +
 include/linux/swap.h                          |  101 +-
 include/linux/swap_ops.h                      |   10 +-
 include/linux/vmstat.h                        |    3 +
 include/linux/zswap.h                         |    4 +
 mm/Kconfig                                    |   20 +
 mm/memcontrol-v1.c                            |   13 +-
 mm/memcontrol.c                               |  208 ++-
 mm/memory.c                                   |   21 +-
 mm/page_io.c                                  |  104 +-
 mm/shmem.c                                    |    4 +-
 mm/swap.h                                     |   28 +-
 mm/swap_state.c                               |   62 +-
 mm/swap_table.h                               |   64 +-
 mm/swapfile.c                                 | 1241 +++++++++++++++--
 mm/util.c                                     |   13 +-
 mm/vmscan.c                                   |   41 +-
 mm/vmstat.c                                   |    6 +
 mm/vswap.h                                    |  438 ++++++
 mm/workingset.c                               |    2 +-
 mm/zswap.c                                    |  127 +-
 26 files changed, 2291 insertions(+), 293 deletions(-)
 create mode 100644 mm/vswap.h


base-commit: 4dbe24720eb3811563cd56b35d87ddf3f9beed2a
-- 
2.53.0-Meta


