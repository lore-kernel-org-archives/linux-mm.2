Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F155BCCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695546B00AC; Wed, 29 Apr 2026 09:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646BA6B00AD; Wed, 29 Apr 2026 09:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5352F6B00AE; Wed, 29 Apr 2026 09:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5BC6B00AC
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:42:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0946A022A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:42:36 +0000 (UTC)
X-FDA: 84711708312.16.AFEF7A6
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0087680012
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:42:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eFcst+dO;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777470155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZN8aaKgJ1Zzt3TUYPWuZx8THycU/Bmtyi8+XL6pyqc=;
	b=f+FOeZYDRJV5BUZocyTp8mPlQbbfqwoJP980qF7avzm9H8g8B5rj6pQSm5XeuMjp0dSMlF
	yu6NgOYU8oz9i+t1S0PyAgXB85MAqZBU8SPhSyOG/1AjlCkCYY19FZFaE2nuxnv8buFP6U
	9IqhMavRvzopUDGQetLsV17o8aqVogY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777470155; a=rsa-sha256;
	cv=none;
	b=r7wZ8SjTfehiYedkCO+5vO0sC3UfQT5YRrRFIVjH2kAcRCfoBpMVo8JFWLH9EFBQqM48h+
	+Q2vfgHzc1AzE3gBIP4RzPMQDPWy3wWAbrRn/GI4p2/4axA2yNbTJm4JvZGBaOARbhx1yJ
	BnxzmT7ZizfbG/3BRFKDEL5bPXUZ+60=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eFcst+dO;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so217918115e9.2
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777470153; x=1778074953; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jZN8aaKgJ1Zzt3TUYPWuZx8THycU/Bmtyi8+XL6pyqc=;
        b=eFcst+dOqDg4sy7Ry3R4q2bCGxcbFvPipIF8UZcwP4UJuQOUA+E/0stxzLZbNp+Lz8
         iteQ3eeviajLgrS30ovDqq/MY6Djb6+8qmxeVNi9bRMI0u8NLCdK/zv/4KmV1f/ZdSJ3
         cy9CWTmIhxQ75KUY9s7eE7fA0xCYoAoBEpYphSwW9PXT++VRgYaVr0cKKbIorfZRSWBP
         evu7TGsgWV8OyvAylZ2AuA3ssk9wB06gr544Plp8U7GofzoqnvLTHjF97H3w2dorKe6p
         cGfTqbygODmUmmvB+7+fuGavjd+HVmZPjYL8LLCnzXm0jLgnVIeWUcX55rM7mZtTwE7K
         YfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777470153; x=1778074953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZN8aaKgJ1Zzt3TUYPWuZx8THycU/Bmtyi8+XL6pyqc=;
        b=QpVWrwlAkc5OW2f9pnYaOktmd4Lcq/WEZE4cz19iu+cjDv2qnft6KCj0GXFvJ8itHA
         4cL2jZJreB9SXFBYJX83CK86JV1Y1UoVoremb5Rkej1Ld60hxtP5yIKcI7urgg4fxXqo
         C0h0hTbBiEK+9AJaKcv7d/x3K8Gq9j8q7luVQk0Gm8qNxY/6lU5M+sbHmkNmmFOVoKMN
         Xta+f/ccnO3A/puCQgnOs8/oP0sfUztFtWP82kCBhCsVON6i/XlkCbzDknR0zV6jZO16
         mhCZGe5A8D0FPf7M49AOkVrX3FJygn4dgD+MVu32tFgdkDTyxMd5WXTEeBEZayqOEKn+
         llKQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Apq6+cwx9yTJ2EGOemyslGlFLPXur2rVSRWMCfOhnmsaCEExtrJyWy+cmrRFwQ3STh++FkUHg0A==@kvack.org
X-Gm-Message-State: AOJu0Yzrkg3dUwQDQToDmZPzvVR2dB3iZO7gpovYYuAe+pih0Y3fR9Yi
	+Y9cQ8/LWHINVr6RbQB3C3vGo5lYYX1Q3KCGdInbzBd563cYVJhRNP2mbVjCVu+EozI=
X-Gm-Gg: AeBDietYfbkbhvuQL0BtXm9aRnkriENE0orgh1tAaH4v98woqYY9RFJAdFaIwu3HJBN
	EkxqLzxmCfJJnae+BYeY4gMjG3rFJQASSTytNi7wm+cf0dOrEZ03KY6YIf0Mpsnk8ElFyGwSPcE
	RBEBIPiSmok9E3OyIudaoDhuyCdkf5WKQakavpj7EJUxMWqaUsd5rxLLKDwGEd/53gLP82FAaj0
	hyOgC0KAn7R9SvVH3d9+anykdny3MqNK69xspCwExXGL/EzVqBzCy925aKAT6/q8R4uiA4Uae7n
	VXHQIMh7xHDSOS0ohDSYGoaJqq9W4DfyhJDSpOYulKr1YEV/h50vWj9WMIGXcOjXHbNTbO4+SEh
	cED8ZCIQAdgk5s6KizNL3s9MWGj4YXWv28ovfSh0Y9S79Lp0gMqXWhlhCCVf8PbOXlJLpdkVlyo
	vAKKhpOyZVyq9uSgCaCc4uWLvuVy7OQ23eRwqoT6E=
X-Received: by 2002:a05:600c:4e4b:b0:488:be58:bb5b with SMTP id 5b1f17b1804b1-48a7b547375mr70345885e9.24.1777470152259;
        Wed, 29 Apr 2026 06:42:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2a00:23c8:67a7:3101::e3b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7bc79ab4sm59981745e9.9.2026.04.29.06.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 06:42:31 -0700 (PDT)
Date: Wed, 29 Apr 2026 14:42:28 +0100
From: Gregory Price <gourry@gourry.net>
To: Arun George/Arun George <arun.george@samsung.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com,
	gost.dev@samsung.com, arungeorge05@gmail.com, cpgs@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <afIKxG5mJZE6QgpR@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <CGME20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0@epcas5p1.samsung.com>
 <1983025922.01777297382206.JavaMail.epsvc@epcpadp2new>
 <ae_i9IlIndumJWN3@gourry-fedora-PF4VCD3F>
 <1891546521.01777455002601.JavaMail.epsvc@epcpadp1new>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1891546521.01777455002601.JavaMail.epsvc@epcpadp1new>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0087680012
X-Rspam-User: 
X-Stat-Signature: 6swgqjcsajr9tx37zwy3nthyozmripmp
X-HE-Tag: 1777470154-854129
X-HE-Meta: U2FsdGVkX1/zlnKLwtrHXaurOf3ekuC7V3sGRKCd6ojJRF190Z4+UOjuEvTOS3zAYAQpFX3QEk5OE6ihJtIGUpYHeK3Vdj8pHBI2QTGnU6x2pkFniKF4rCgk06f2F8rSXd73hLrNgrqXtpcDm7+BfE7aFB973Sts1xKkSioX6kxoEO+irk/ezm03qEK6JLOnQcYQGLEKgR9w/7+u/dZYUiS8/ULRt44dQZJQ5/7fKlLJbgt08sK9eyhXNy3T8ZPSMX701wiiIzoLlzRff2v1EYNRqyeAMx87ASpFIem6cIq0ScPWtNxpBOOlIYKMCJB789J6bgDwetulzETYzClkH14bhbpg3fw1v2LM2P2JbxMdE79RCgNiPPYjm9Jqy4rmdap/sI2uznBz/BFrRwy+u/ql7VEh5TOzmswQuCn8zdXxP4w94kbAncHNWJjYS/I9Fbb8y959CXS8Lsw/09STbZEBn5qVyK3M0Bf3m2JP5RRvLtTfimuho2zzUJJUARBdNMKQ6wsk1gNtsFvbmWTGJBFpkLTuVE75+M5XBAXD9tFe/yeOTjQthq1deoUwH0aGdsfIBr26JVNvNqUP3nrgd6m7E78JYRRJhtIRP2CKF5mHnSUMekwm5QZmGLuLVvmPE1C+OZkLMuHi7Eso72+5KYaqEsBnQmgMZh5ivIYhaKo1Z4nUGVThRs3dqsqwgTHPzk172zKGFODNk8HlDX4BA9csqJ72To/GKLbDQpB8pTKzNZmmIJJOHAfrsqLsxH5msoQL4x5M8nzNYPFRuxYv5qf0aktCeM6R/Mk1E62YgwgqKpq84awtO7wSsMZbOZ8FV2/VrwnUy74+vKTzI9dROhnYbOGIH/YTAoydSzWnBDG4cpW23OUXYRa+jpPPyQVb4OmX+nbm3bAJNA69YEYI5Qb/hbqm4CwVMkH8LILZ46pPGHqSNNEp6X3TEGPyJqqEiJK4BB2VHHZuNoJZzXG
 Zv0ns7y9
 omM4d+E0rO8kP+CtT0gZwWdIXab+hy4uHuxqdSpXm8mwjJWLFjje9/wfflpMI6VZLwf40nkFsrJvqxYeDib/QlyylBHdYrpd1Za4cpKCYzqlPp9uHscJ1/Ga0ViQMuDn9FfB495qqM9hHQFIj2JxfQOTvA+DGa+SBDk2gwLGK2cnJTnLzaHAEyuDFF9POqz5g08IwCO3d4lRQ7E3rn6a2kt5bEy8nWK6VnZjt/K5MaJIdlz6Mor1ob3UbSmJD6BT65LP0nOBGeKMXJ4FXe/CPxffI1UB0xzf3jm4gSxrH4SZ5fWXT5djQvXM5WLOSNO4WIkMklMyQ9IhDBhmqiS3k+Vci/y/fFfK1r44L9VCxj9WgKhHuFDSuV8PXyAMEdUuJ4hp/I/3z/7aaBvXUBhkTAK0JCYP2mQdQSpfH7xhHyAIdEWpR/N+qXAap7Xn5WHAnTjUo8yR05FdDFwcmx4MAkzyLzBNRb/LFPPIAEXJarvF2eote44ife4xcqukVVmZ349T7FsZMWqp0mTXtqDEvfMmHWQhPZYJS3bESSo+vkVofsjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:45:26AM +0530, Arun George/Arun George wrote:
> On 28-04-2026 03:58 am, Gregory Price wrote:
> > On Mon, Apr 27, 2026 at 06:02:57PM +0530, Arun George wrote:
> >>
> >> Any particular workload you are targeting with
> >> this (which can tolerate this latency)?
> >>
> >> Any deployments you think of where the goal is a capacity expansion
> >> with a compromise in performance?
> >>
> > Primary use cases for us are any workload that benefits from zswap -
> > which is many, many (many, many [many, many]) workloads.
> > 
> A curious question please. If the primary use case is swap, can't we 
> handle this problem statement by re-using the zsmalloc allocation classes?
>

I'm using swap semantics for allocation ("demote + leafent") but otherwise
on-fault rather than removing the swap-entry, we leave it cached and
replace the page table entry with a read-only mapping (if Read-fault).

If there's a writable budget, and the node is under that budget, we may
also allow upgrading the read-only page to be writable (at which point
we would reap the swap entry).

This requires careful reverse-mapping in case there are multiple mappers
of the same folio.

Since otherwise the allocation is just alloc_pages_node(), and the fault
patterns differ from typical swap - i didn't see the need to overcomplicate
things by cramming the logic into zswap/zsmalloc instead of just making
it its own vswap[1] backend that sits in front of zswap.

vswap makes it easy to writeback a cram page to swap in the case where
the device is over-pressured and we need to make room (close the node,
disallow new cram entries, writeback existing cram entries to swap).

[1] vswap: https://lore.kernel.org/linux-mm/?t=20260320192741

> A separate size class can be reserved for non-compressed pages in 
> zsmalloc. And this interface could be used by zswap, zram etc. (We have 
> been using this implementation for testing btw.). This does not require 
> additional book-keeping or buddy allocator.
> 

The other reason not to overload an existing mechanism is because these
devices (that i've seen) cannot provide per-page compressability stats,
and so it would end up just looking like a bunch of either
uncompressible capacity or unknown compressed capacity.

That makes it harder for those components to reason about what to do
with their normal software-compressed capacity (for which they do have
that data).

> So write-control part need to handled in the specific back end driver of 
> private pages while the allocation control is a generic front-end sort 
> of, right? (Ex: zswap cram back end for compressed devices case.)


write control is handled by the OS in three ways:

   1) No file memory (no page cache)
      We get this for free using the swap semantics
      This prevents buffered i/o from bypassing page table controls

   2) User allocations only (or at least swap-eligible only)
      This prevents catestrophic system failure if the device fails

   3) Page table mapping control (disallow direct writes)
      This prevents uncontended writes to compressed memory by the cpu


allocation control is handled via private nodes - the driver which
hotplugs the private nodes hands that node to cram - and cram is now
aware of that capacity and will use __GFP_PRIVATE to allocate from that
node.   Removal of the private node from the fallback zonelist and the
lack of __GFP_PRIVATE in all other paths prevent normal buddy allocator
users from accessing that memory.

> 
> Great! I believe "writable budget" could be an interesting idea which 
> can solve the 'bus error' sort of scenarios due to device not capable of 
> taking any more writes. The write budget could be replenished using the 
> control path and writes will not go ahead without the budget available, 
> right?>
>

Write budget is simple

budget=1  (up to 1 page can be writable
   1) swap 1 page ->  cram alloc 1 page, put VSWAP_CRAM in PTE
   2) read-fault  ->  cram upgrades VSWAP_CRAM to R/O PTE
   3) write-fault ->
      a) if (writable_cnt < budget) { budget++; mkwrite(pte); }
      b) else:  normal swap semantic -> promote to normal memory

The catch with the writable budget is we may not always be able to catch
all frees of the vswap pages - meaning we get zombie pages in the vswap
tables.  But this is ok if we run a regular kthread scan the vswap entry
list to reap zombies.

This also gives us a great place to TRIM/FLUSH those pages to release
the capacity without zeroing them.


Meanwhile - use ballooning and a simple shrinker to dynamically size the
region to respond to real compression ratio.


All said an done - you get something close to zswap but with R/O
mappings for all entries, and optional R/W-mappings for administrators
who know something about their workload and can afford to take the risk
of some amount of capacity being written to uncontended in exchange for
performance.

The writable-budget is a risk-dial:  How much do you trust your workload
to now spew un/poorly-compressible memory?  The write-budget is a direct
measure of that. (so take P99.99999 compression ratios, and you can make
a good chunk of that writable).

~Gregory


