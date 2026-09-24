Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14753C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242996B008A; Thu, 24 Sep 2026 08:55:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 219516B008C; Thu, 24 Sep 2026 08:55:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F3C6B0092; Thu, 24 Sep 2026 08:55:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD2116B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:55:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 745A91401DB
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:55:06 +0000 (UTC)
X-FDA: 85248651012.28.3D41CDD
Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	by imf20.hostedemail.com (Postfix) with ESMTP id 93D951C0003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:55:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U+8Y8dR6;
	spf=pass (imf20.hostedemail.com: domain of klarasmodin@gmail.com designates 74.125.229.205 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790254504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jRDEaPuRQnqZYVUGBv8Aoyxx7cxKw9wJHUOozSK+UI=;
	b=u2fBHvJKMY66pzXES1TrB50Z6LQKlP1ydiRnCcq1ujYiEp9JfFhQ1YDzQ1QfOuD+5bcBnW
	bUyUzbKosb/MxcUu/xJU52vUfl87OXQwL5HKzy+9dKajPv+m81D83GAO0LwWc7CqNjTdLQ
	i3BQGNwlVKxrf/p8XjWXE49/QKxFAoE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790254504;
	b=c+4WdbVkY3LA2s1b+ULj0MImHAa5oet5F/phomB4vWkXTLP0aO5TQi8gsA16rGe42+WO8s
	RlXOHOhdNr4+XyS0T1ueqcEACICi0GUUY2LaBlmNtz9MzjNx1ZdBlKfukhds5iSewVwFiX
	DnhDTmo+W50GXgS1PlElBfho56sSUgE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U+8Y8dR6;
	spf=pass (imf20.hostedemail.com: domain of klarasmodin@gmail.com designates 74.125.229.205 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f1651bso1625968e87.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790254503; x=1790859303; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5jRDEaPuRQnqZYVUGBv8Aoyxx7cxKw9wJHUOozSK+UI=;
        b=U+8Y8dR6lCVKJ81rXOHky6BpcVS1FK7q6/iA19baP5WluBSGIv9pe3Ip+1CEcbJvgv
         xszwc9Z2fwEPHZxQsOOYFTSJheB3BQk6T0mjPj9RGYZGqX+WLDSsUBwSk2p2J1Rb9tN7
         tOf2cIxKbvUNKasdgw4KR8ql4o6HVt8uvuq/PRQhd8sMpLP4SeDAdlTcw93SSrBKcZyy
         +tj2ydfsmyJlD0S3B0DfQzxrtL2YammVWe0N9w+wjNOEHiImj/2xqU+Yy3Uy6708XOIg
         X47kx/qPmnHaSh1W3iUIsw0OS0XGCsqEu2HI5tKOj7jwyLOPK2+SoN+TuPI4zswINrb3
         wHhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790254503; x=1790859303;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5jRDEaPuRQnqZYVUGBv8Aoyxx7cxKw9wJHUOozSK+UI=;
        b=CB0f7Lxr1Pq5YAzD2Y84klrQkcHkPzMxztfO3BxP8TGnh/cdI30iWEeV5OD0giX7Lz
         5yiDLm58NxjfWHte4+nUty2IqzmD05fsFRJ6mxWRK3mJwy8e2S835rjVqXCMobDcW1EQ
         3/jfmwMwTSKu5mgqshOqk85f1AvMmaqF6VlJc5o4KqE1y7yJEFUb31PRxJ2WBsQnLF7K
         ePrLfDPildjzh//4JRoWE/2Zz7Maz6uqo62elfrhIihyp1S97F4VGnTNKzdhU+q3SoAP
         FFUtyIClSw38eHwss1sj+K5VX5PbrkRBzsrCgqIgOtV0XEJXLeJyYzsvkk2JJpIBqJGq
         B01A==
X-Forwarded-Encrypted: i=1; AKwUvBxT6qx8xx+Dq+shaTOGOT+PGHOGIx4LlnAVEy2dqHwGH+w55+8VgMZi9UltXBAD2VBcolgMGiaL7Q==@kvack.org
X-Gm-Message-State: AFuF++l6iIqlO4vtY+CRwi9ePsK2qHCkzt5PFbvPMyEhAkBYGSdH2ZHG
	L7NTjQNfApyh4QW8wRJkz5VD56aF5Vw5TV2kc8fEvp/zoa2xGIvQftrD
X-Gm-Gg: AYBFou3e9xX9N4jnUI79Qj9T7li+LAU4Z7Y0tNGobCocem/6dSq67YyvVM/SfoYE9aM
	VR6MU9g/9QWPoAyxu1mSoCSX7SCq5KxwtKZHML1e6/cDsR0ra4UTn8G4/KN0ZruVZxJ3/tig6fQ
	w7C+igwYi6OlBFcwRC6J8LeWO3TmD1CCf2F3YcNrE31Cp2f1qWChOTINGVBMQJ0T02jgcNfLMb9
	u/dpW0gSCH94rMbA8r3QLrO4gAQpOhkmPVgtfFXGSrgAJbO9Gm8SYFHqWMBnYFKdwN6ICWhncgD
	REQruhl1ow7Hzlelpl/7mW8/wTfAGykTBaJq0G1U33RW4mIRxY74Ujf7O/PyNq5bsVAc5jPtkjX
	sf6QTmLQzaFyXxbCeiPUMUgNXBYwZMof1a2d9xP7SbYDPFJ7JoakgDRX6nhULByH/QpFHRqdtM6
	ItT+GGzjt79migGDiO3xQbEJIFcvTX36S51BAVCKOdyiJbG/9a9q/PK0cT4FGA0jWWpLKyhNAvV
	HNO9c/rqbmtaZ1dGsr101zaM1TC
X-Received: by 2002:a05:6512:1444:20b0:5b6:1883:d604 with SMTP id 2adb3069b0e04-5b8df0b5b39mr649519e87.67.1790254502275;
        Thu, 24 Sep 2026 05:55:02 -0700 (PDT)
Received: from localhost (sol-eduroam-pathost130.ki.se. [130.237.96.130])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d8552dc9sm1430310e87.1.2026.09.24.05.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 05:55:01 -0700 (PDT)
Date: Thu, 24 Sep 2026 14:54:59 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, baolin.wang@linux.alibaba.com, 
	tj@kernel.org, mkoutny@suse.com, skhan@linuxfoundation.org, 
	kunwu.chan@linux.dev, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v5 00/11] Virtual Swap Space (Swap Table Edition)
Message-ID: <arUakv94VBzBzL6l@parmesan.int.kasm.eu>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 93D951C0003
X-Stat-Signature: 9i985rmm4fg51rfy3j7snjwkoj14697z
X-Rspam-User: 
X-HE-Tag: 1790254504-705061
X-HE-Meta: U2FsdGVkX1/EwH5Uvzw5zHNKri3ZwTx19hV9fG4t7j1jAKnXSIL2Q6ogzristLHdg/lqGa00gjAN/WT4kPhutbejZhrGwLnMkey4cX4LrJEvaNrW9CKlNxfL7Ux55h/iDOShUFV9GmV15DLg8laQI+67E0F2EsNzSa+0GdL5ton6jSQ8X/TbtfxOfdrgCgA/8zVvik7BMMG7nN+0Vpb1HRSOE5xrd5SyvifCm4IkZcsA2O54eOIbOvmMv9hoA3GoX6GQXyEYraSTC3SziIuN4MeZM78DF2YXHkSuwC0rTBGvM2ZliEkPd6ni/P8HRZsRZ5OncEFyqgjdDWvfqO1L3lDP+gxFqAb327eUcOsuYBMKPEJpuZlxtXE/z3w7X365/woAPS4HqJfpFRBUPKVVHJAjvjoE3DIgUdc5N6ghXliBVSemIaDZXH3+5kFrH7yKxAYq6X3ex/yjVEhN0M5juop8a8Fdoad+78uJDzF0NIOHshpgjjgjds+HcS2lrr98wZ5wLXNBxZHUspDK8MFOF/8fNT75WFEbgH+0HOXj0e6pVCP+UObNawm1s7MLizyoQAi2hp1yin/iGSRH0nvz0ldbqLP8Ra5XfC/NeAAWrCKdrtPljKiQubipShbOczyaqEkIF6+EBSrOJlVJGmFWggjPR0X0B9cIS7Q9ayhJZ3Zfb1rWXx0AamRmmxretDd9FKdf+t9FKds4HLLvyzdrENeS9Fbrj+w0tZYP/00IM4yEUm/mNOuY6GNNICyx+4zHW6Jo14++gOGnZ4G43Vb6oEN6qjYzxVzoez/4ZYVVK0eTdIzQ5GbxisLBO0lD7/8xFTKSvewPP5K1+3KKjUguKfMpLdFxZ0R/iQMGndQcaXsf4kRBCm8g9Ml05ooIA0DPUcmKOFhTktcqF5MMDdF1PEI208H1zX/TahnNcAC1CuaFikjrRZSlKDEAOK2W9AZPvaUFKm4gmircWKoMXW/
 JmVTdZtf
 NsuComSWdLvjxNpcZNkdfOyUQAeNoubkApyr+ymxuxCTWLVa4H/Cz9XM0jIdTNLXWE+bWuajSuqLQpretIlo/5rrhXseGIk0I/xghpGeZVmJh6zYbpuxONPunwgyEp1alhS2OPtAIMa6vbVjpX8OTi8GLuoPS99EPAGqLLXUUzfQjav/yVbeurILl5Sff6dQHnPmaF4hD93FUmUPTKF5QKXrCsQUp/IDdn/pWujyakZAWpNq/xSYkSlMxGB2LE9pnAWZ5cBsgHdvij3ueFZ/AHiCXw/luBiID1PkqR36j5IPDxJLg8+2DwMVrENzhVDiuImLXOMlg8sJDOXdZfXOdCUi7jNYZZU3c0Y9/5hYnjS26DM2W9tvPt0uVI4vx2N4V1UGvMoh7nvnlkiQhu+CdqE7nwCJbXID1721p9tLKErI/CC2kLVBYlYTe03Wh1U61mexyuYDOSBg2lPEsPhjtqBie+yevMdB1dXH9Xr/jdu9ZOwcwz0cbz8BbwfUYmswgWqfK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-18 11:02:30 -0700, Nhat Pham wrote:
> Changelog:
> * v4 [v4] -> v5
>     * OVERCOMMIT_GUESS now allows for 3xRAM margin when vswap is enabled,
>       to take into account swapfile-less zswap usage (proposed by
>       Johannes Weiner).
>     * Limit vswap swapfile size to 8TB and drop the last patch, to avoid
>       memcg private id refcnt saturation.
>     * More assorted cleanups and fixes: anon swappability check, etc.
>     * RFC: Replace the xarray with a new data structure (vmalloc array)
>       (new patch 11).
>     * Rebased onto mm-unstable.
> * v3 [v3] -> v4
>     * Replaced the runtime sysctl with a cmdline param, and remove
>       CONFIG_VSWAP (suggested by Johannes Weiner). CONFIG_VSWAP_DEFAULT_ON
>       now only gives the default value of the vswap cmdline parameter.
>     * Refactor swap-related memcg operations into composable building
>       blocks: reference acquisitions, charging, etc. (patch 8,
>       suggested by Johannes Weiner).
>     * Fixed vtable UAF bug reported by syzbot and Kunwu.
>     * Rebased onto mm-unstable (minimal merge conflicts).
>     * Re-run benchmarks (no signal change).
> * v2 [v2] -> v3:
>     * Rebased onto current mm-unstable.
>     * Add a runtime vm.vswap_enabled sysctl and CONFIG_VSWAP_DEFAULT_ON
>       to gate vswap allocation.
>     * More cleanups and small bug fixes.
>     * Split THP swapin enablement into its own patch (patch 5).
>     * Add production workload benchmark results, and drop RFC tag.
> * v1 [v1] -> v2:
>     * Rebased to a newer mm-unstable tip.
>     * Fix a bunch of assorted issues (incorrect zswap store failure
>       rollback, vswap_init() failure handling, rmap-encoding collision,
>       etc.) and clean up the code (rename a bunch of functions to
>       more closely follow existing patterns, etc.).
>     * Some more code clean up and simplification: some renamings to more
>       closely follow existing patterns, move vswap backing check to
>       __swap_cache_add_check, store zero state in the swap_table for
>       vswap entries, etc.. Many of these are proposed by Kairui Song
>       in [1].
>     * Defer memcg_table allocation on physical clusters until the first
>       vswap-backing slot installs. Saves ~512 bytes per physical cluster
>       that only serves vswap-backing slots (this is the new patch 8).
>     * Widen swap_info_struct->max and ->pages (and the swapoff unuse-path
>       index) so vswap supports ~8 PB of swap space (this is the new
>       patch 9).
>     * Split the physical-swap-backend patch into three for reviewability:
>       the core backend (patch 3), zswap writeback to physical swap
>       (patch 4), and reclaim of cache-only physical slots (patch 5). No
>       functional change.
>     * Add kerneldoc for the vswap API.
>     * Add some benchmark numbers for zswap case.
> 
> 
> Patch 11 is an RFC. It swaps vswap's cluster xarray for the VM_SPARSE
> vmalloc array Baoquan He designed for xswap, to show that the data
> structure and the device model are separable: moving to his is one
> self-contained patch that adds no userspace interface. Note that
> per Baoquan's commentary (see [5]), I have skipped shrink for now, only
> freeing vtable when the cluster becomes free to minimize metadata
> overhead while keeping the skeleton in the free list. I have not done
> performance testing on this patch yet (the number is from the old design),
> but I have run a suite of simple stress tests.
> 
> It is adapted almost entirely from Baoquan's code (see [6]), so I have
> kept Baoquan's Co-developed-by and Signed-off-by tag.
> 
> 
> I. Context and Motivation
> =========================
> 
> Currently, when an anon page is swapped out, a slot in a backing swap
> device is allocated and stored in the page table entries that refer to
> the original page. This slot is also used as the "key" to find the
> swapped out content, as well as the index to swap data structures, such
> as the swap cache, or the swap cgroup mapping. Tying a swap entry to its
> backing slot in this way is performant and efficient when swap is purely
> just disk space, and swapoff is rare.
> 
> However, the advent of many swap optimizations has exposed major
> drawbacks of this design. The first problem is that we occupy a physical
> slot in the swap space, even for pages that are NEVER expected to hit
> the disk: pages compressed and stored in the zswap pool, zero-filled
> pages, or pages rejected by both of these optimizations when zswap
> writeback is disabled. This is arguably the central shortcoming of
> zswap:
> * Resource-wise, it is hugely wasteful in terms of disk usage. At Meta,
>   we size swapfile in the order of 25-50% of host RAM, depending on flash
>   availability. This is a lot of flash for a fleet of our size, and
>   with universal zswap enablement, most of this is wasted for zswap
>   entries.
> 
> * In deployments when no disk space can be afforded for swap (such as
>   mobile and embedded devices), users cannot adopt zswap, and are forced
>   to use zram. This is confusing for users, and creates extra burdens
>   for developers, having to develop and maintain similar features for
>   two separate swap backends (writeback, cgroup charging, THP support,
>   etc.). For instance, see the discussion in [2].
> 
> * Tying zswap (and more generally, other in-memory swap backends) to
>   the current physical swapfile infrastructure makes zswap implicitly
>   statically sized. This does not make sense, as unlike disk swap, in
>   which we consume a limited resource (disk space or swapfile space) to
>   save another resource (memory), zswap consumes the same resource it is
>   saving (memory). The more we zswap, the more memory we have available,
>   not less. We are not rationing a limited resource when we limit
>   the size of the zswap pool, but rather we are capping the resource
>   (memory) saving potential of zswap. Under memory pressure, using
>   more zswap is almost always better than the alternative (disk IOs, or
>   even worse, OOMs), and dynamically sizing the zswap pool on demand
>   allows the system to flexibly respond to these precarious scenarios.
> 
> * Operationally, static provisioning the swapfile for zswap poses
>   significant challenges, because the sysadmin has to prescribe how
>   much swap is needed a priori, for each combination of
>   (memory size x disk space x workload usage). It is even more
>   complicated when we take into account the variance of memory
>   compression, which changes the reclaim dynamics (and as a result,
>   swap space size requirement). The problem is further exacerbated for
>   users who rely on swap utilization (and exhaustion) as an OOM signal.
> 
>   All of these factors make it very difficult to configure the swapfile
>   for zswap: too small of a swapfile and we risk preventable OOMs and
>   limit the memory saving potentials of zswap; too big of a swapfile
>   and we waste disk space and memory due to swap metadata overhead.
>   This dilemma becomes more drastic in high memory systems, which can
>   have up to TBs worth of memory.
> 
> Swap virtualization is the answer to these issues, with three properties:
> 
> 1. Decoupled backends. For zswap in particular, this means we eliminate
>    the unused storage space, and allows zswap to be used in systems that
>    do not have enough storage capacity for physical swap (without having
>    to resort to silly hacks). Zero-filled swap pages and swap-cache-only
>    folios also benefit here.
> 
> 2. Dynamic swap space. Since virtual swap is not tied to any physical
>    resource, we can make it effectively infinite and dynamically grow it
>    on demand.
>    This massively simplifies operational provisioning, and increases the
>    utilization of compressed swap backends (zswap). Dynamicity also
>    reduces overhead on unused swap capacity.
> 
> 3. Efficient backend transfer. The virtualization scheme should not
>    introduce PTE/rmap walking overhead for backend transfer. This
>    is crucial for systems that want to support multiple swap backends
>    in a tiering fashion (for e.g zswap -> disk swap).
> 
> For more historical contexts and references, please take a look at
> the cover letter of the older vswap submissions ([3] and [v2]).
> 
> II. Design
> ==========
> 
> When vswap is enabled (via vswap=on cmdline parameter), a special vswap
> device is allocated at boot time. Anon pages that can be zswapped will
> obtain a vswap slot at swap allocation time.
> 
> These swap entries can subsequently acquire backend on-demand, such as
> a zswap entry, or a slot on a physical swap device (as a fallback option
> or at zswap writeback time).
> 
> We repurpose much of the existing swap_table infrastructure and
> swapfile allocator for this new vswap device, with two notable
> differences:
> * Clusters are dynamically allocated on demand and managed through
>   an xarray. This in turn allows us to avoid static provisioning and
>   let swap space grow dynamically.
> 
> * Each cluster of this new vswap device has a virtual_table that stores
>   the backend information of the entries in the cluster (see below).
> 
> Diagrams:
> 
>   Case 1: vswap entry (virtualized)
> 
>   PTE                  swap_cluster_info_dynamic
>   vswap_entry          +---------------------------------+
>   (swp_entry_t) ------>| swap_cluster_info (ci)          |
>                        | +----------------------------+  |
>                        | | swap_table                 |  |
>                        | |   PFN / Shadow             |  |
>                        | | memcg_table                |  |
>                        | | count,flags,order          |  |
>                        | | lock, list                 |  |
>                        | +----------------------------+  |
>                        |                                 |
>                        | virtual_table                   |
>                        | +----------------------------+  |
>                        | | NONE                       |  |
>                        | | SWAPFILE(swp_entry_t)      |  |
>                        | | ZSWAP(struct zswap_entry*) |  |
>                        | +----------------------------+  |
>                        +---------------------------------+
>                               |
>                               | SWAPFILE resolves to
>                               v
>                        PHYSICAL CLUSTER (swap_cluster_info)
>                        +--------------------------+
>                        | swap_table per-slot:     |
>                        |   NULL   - free          |
>                        |   PFN    - cached folio  |
>                        |   Shadow - swapped out   |
>                        |   Pointer- vswap rmap    |
>                        |   Bad    - unusable      |
>                        |                          |
>                        | Vswap-backing slot:      |
>                        |   Pointer(C|swp_entry_t) |
>                        |     rmap back to vswap   |
>                        +--------------------------+
> 
>   Case 2: direct-mapped physical entry (no vswap)
> 
>   PTE                  PHYSICAL CLUSTER (swap_cluster_info)
>   phys_entry           +--------------------------+
>   (swp_entry_t) ------>| swap_table per-slot:     |
>                        |   NULL   - free          |
>                        |   PFN    - cached folio  |
>                        |   Shadow - swapped out   |
>                        |   Bad    - unusable      |
>                        +--------------------------+
> 
> struct swap_cluster_info_dynamic {
>     struct swap_cluster_info ci;       /* swap_table, lock, etc. */
>     unsigned int index;                /* position in xarray */
>     struct rcu_head rcu;               /* kfree_rcu deferred free */
>     atomic_long_t *virtual_table;      /* backend info, 8 B/slot */
> };
> 
> Each vswap cluster (swap_cluster_info_dynamic) extends the classic
> swap_cluster_info struct with a virtual_table array that stores the
> backend information for each virtual swap entry in the cluster. Each
> entry is tag-encoded in the low 3 bits to indicate the backend type:
> 
>   NONE:     |----- 0000 ------|000|  free / unbacked
>   ZSWAP:    |--- zswap_entry* |001|  compressed in zswap
>   SWAPFILE: |- type:5,off:56 -|010|  on a physical swapfile
> 
> Other design highlights:
> 
> * Note that for the vswap device, we have merged the zswap xarray tree
>   with the swapfile-level clusters. This means that for zswap only users,
>   we have negligible extra space overhead.
> 
> * Both vswap entries (Case 1) and directly-mapped physical entries
>   (Case 2) coexist as first-class citizens.
> 
> * Backend transitions in the virtual_table are synchronized through the
>   swap cache and the folio lock - the same mechanism that already
>   serializes ordinary swap operations (swapin, swapout, zswap
>   writeback, swap cache reclaim). IOW, we can only assume that the
>   backend of a vswap entry is stable through swap cache/folio lock.
>   Looking at the backend without this should be done at best for
>   optimization purposes, as there is no guarantee that the backend
>   will not change under the observer.
> 
> * Pointer-tagged swap_table entries on physical clusters provide the
>   rmap (physical -> virtual) lookup.
> 
> * Virtual swap slots not backed by physical swap are not charged to
>   memcg swap counters - only physical backing is charged (I made the
>   case for this in [4]).
> 
> III. Benchmarks
> ===============
> 
> Note that the goal is not to match vswap performance with baseline on
> every single case yet - running with vswap off is still supported. We
> can optimize further once we have landed this new feature.
> 
> A. Production Workload: Instagram
> =================================
> 
> To test vswap's stability and performance, I ran an A/B experiment on
> Instagram (django) workload, with zswap as the swap backend. On these
> hosts, the swapfiles' size is 50% of RAM.
> 
> Compared to baseline, vswap gives:
> 
> * On par request throughput.
> * Lower request serving latency (by about 1-3%).
> * Lower memory pressure in the system service cgroups running alongside
>   the workload. PSI-based proactive reclaimer can therefore recover more
>   from them, lowering their overall memory footprint, allowing the main
>   workload to expand.
> * Elimination of swapfile footprint for all zswap users in the host.
> 
> B. Semi-synthetic Workloads (memhog, usemem, kernel build)
> ==========================================================
> 
> All values are mean +/- standard deviation across rounds.
> 
> Test system: x86_64, 52 cores, 64 GB swapfile for all 3 benchmarks.
> Swap backend: zswap (zstd) with the traditional active/inactive LRU. We
> focus on zswap here because it is the motivating use case for vswap.
> 
> For each benchmark, we test 3 kernels:
> * Baseline: mm-unstable, no vswap patches.
> * VSS off: vswap series applied, vswap=off, to verify that there is no
>   regression to existing swap paths when we disable vswap.
> * VSS on: vswap series applied, vswap=on.
> 
> 1. Memhog: single-threaded, 48GB allocation on a host with 16GB RAM,
>    20 rounds.
> 
>                     Baseline           VSS off            VSS on
>    real (s)        124.05 +/- 11.64   122.31 +/- 10.29   118.57 +/- 15.68
>    sys (s)         106.75 +/- 10.86   105.01 +/- 9.64    101.34 +/- 13.97
>    user (s)        10.81 +/- 0.11     10.85 +/- 0.09     10.79 +/- 0.09
>    delta real              -              -1.4%              -4.4%
>    delta sys               -              -1.6%              -5.1%
> 
> Dropping the best and the worst round to reduce variance:
> 
>    memhog              Baseline           VSS off            VSS on
>    real (s)        123.75 +/- 10.39   122.04 +/- 9.10    116.06 +/- 8.22
>    sys (s)         106.80 +/- 10.21   104.99 +/- 8.86    99.29 +/- 8.27
>    user (s)        10.82 +/- 0.11     10.85 +/- 0.08     10.79 +/- 0.10
>    delta real              -              -1.4%              -6.2%
>    delta sys               -              -1.7%              -7.0%
> 
> 
> 2. Usemem single-threaded: 56GB allocation on a host with 32GB RAM,
>    16 rounds.
> 
>                     Baseline           VSS off            VSS on
>    real (s)        178.75 +/- 6.47    178.95 +/- 6.56    175.97 +/- 7.74
>    sys (s)         127.03 +/- 6.56    128.08 +/- 6.59    124.71 +/- 7.90
>    tput (KB/s)     386662 +/- 14648   386264 +/- 15150   390443 +/- 17532
>    free (ms)       7669 +/- 146       7678 +/- 136       6439 +/- 111
>    delta real              -              +0.1%              -1.6%
>    delta sys               -              +0.8%              -1.8%
>    delta tput              -              -0.1%              +1.0%
>    delta free              -              +0.1%             -16.0%
> 
> 3. Kernel build: 52 workers (one per processor), memory.max=3GB, 10 rounds.
> 
>                     Baseline           VSS off            VSS on
>    real (s)        165.58 +/- 0.45    165.83 +/- 0.49    166.01 +/- 0.58
>    sys (s)         694.24 +/- 26.13   710.76 +/- 19.83   705.06 +/- 21.40
>    user (s)       5132.62 +/- 1.12   5133.69 +/- 1.57   5134.68 +/- 1.68
>    delta real              -              +0.2%              +0.3%
>    delta sys               -              +2.4%              +1.6%
>    delta user              -              +0.0%              +0.0%
> 
> 
> For zswap backend, vswap outperforms baseline on usemem freeing, and is
> on par with baseline on the rest.

I have been using versions of this series consistently since about
August and occasionally before with no apparent issues, so I think it's
time for

Tested-by: Klara Modin <klarasmodin@gmail.com>

> 
> IV. References
> ==============
> 
> [v1]: https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.com/
> [v2]: https://lore.kernel.org/all/20260612193738.2183968-1-nphamcs@gmail.com/
> [v3]: https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com/
> [v4]: https://lore.kernel.org/all/20260825153238.2695446-1-nphamcs@gmail.com/
> [1]: https://lore.kernel.org/all/CAMgjq7BhOn48xEyC=2j837R7qddfjeBVHMiRqdx8no4ZEBpBLg@mail.gmail.com/
> [2]: https://lore.kernel.org/all/Zqe_Nab-Df1CN7iW@infradead.org/
> [3]: https://lore.kernel.org/all/20260505153854.1612033-1-nphamcs@gmail.com/
> [4]: https://lore.kernel.org/linux-mm/CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com/
> [5]: https://lore.kernel.org/all/aqjpYHbZ14A8xRtK@fedora/
> [6]: https://lore.kernel.org/all/20260916101929.149106-1-hebaoquan@kylinos.cn/
> 
> Nhat Pham (11):
>   mm, swap: add virtual swap device infrastructure
>   mm, swap: support zswap and zero-filled swap pages as vswap backends
>   mm, swap: prepare the swap IO path for vswap
>   mm, swap: support physical swap as a vswap backend
>   mm, swap: enable THP swapin for vswap entries
>   mm, swap: write back vswap zswap entries to physical swap
>   mm, swap: reclaim physical slots backing cache-only vswap entries
>   mm, swap: only charge physical swap entries
>   mm, swap: add debugfs counters for vswap
>   mm, swap: defer memcg_table allocation for physical swap clusters
>   mm, swap: back vswap clusters with a VM_SPARSE array
> 
>  .../admin-guide/cgroup-v1/memcg_test.rst      |    2 +-
>  Documentation/admin-guide/cgroup-v2.rst       |   46 +-
>  .../admin-guide/kernel-parameters.txt         |    7 +
>  MAINTAINERS                                   |    1 +
>  include/linux/memcontrol.h                    |    6 +
>  include/linux/swap.h                          |   88 +-
>  include/linux/swap_ops.h                      |    9 +-
>  include/linux/zswap.h                         |    4 +
>  mm/Kconfig                                    |   20 +
>  mm/memcontrol-v1.c                            |   10 +-
>  mm/memcontrol.c                               |  147 +-
>  mm/memory.c                                   |   21 +-
>  mm/page_io.c                                  |  101 +-
>  mm/shmem.c                                    |    4 +-
>  mm/swap.h                                     |   28 +-
>  mm/swap_state.c                               |   50 +-
>  mm/swap_table.h                               |   64 +-
>  mm/swapfile.c                                 | 1254 +++++++++++++++--
>  mm/util.c                                     |   13 +-
>  mm/vmscan.c                                   |   18 +-
>  mm/vswap.h                                    |  422 ++++++
>  mm/workingset.c                               |    2 +-
>  mm/zswap.c                                    |  132 +-
>  23 files changed, 2180 insertions(+), 269 deletions(-)
>  create mode 100644 mm/vswap.h
> 
> 
> base-commit: 27e4e1835109ef599d72abe6c09711e0b1916033
> -- 
> 2.53.0-Meta
> 

