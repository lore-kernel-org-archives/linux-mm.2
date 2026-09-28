Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D872CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7586B008C; Mon, 28 Sep 2026 15:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281416B0092; Mon, 28 Sep 2026 15:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14DD96B0099; Mon, 28 Sep 2026 15:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E01816B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:23:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C43E16011B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:23:53 +0000 (UTC)
X-FDA: 85264145946.02.AD6E81F
Received: from mail-oa2-f14.google.com (mail-oa2-f14.google.com [74.125.231.78])
	by imf07.hostedemail.com (Postfix) with ESMTP id A52AB40006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:23:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=doqEmRO0;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.78 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790623431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lE2pJ7XkaEF8KIFM+yW0Sa/QGywvOMdlIxfH6fFMxqw=;
	b=1xpYHlkq6Q50q99FAU+r0UQjGkG1RbY8hf7ZKsoT2R+3SpVPqllWtOxGp3vk/KmyfPFfBj
	p1tqKww1aD8MTNMAOTQE23hBoeMG6cAVlGACZiQfczOYQzJUxUJXSXlSpq9OKcvCIvze94
	KvODcqhuc0xliDTPONcTbsZAkABgOIs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=doqEmRO0;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.78 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790623431;
	b=7CKD5anGsA4WA1GQVdJiAbcly3vUHxH6DsEP/fjuctWw+/vtlvD2XfO1/nFzRZi/ozGueo
	/Etlw8pWYamKqne5zRtfR0hA4HJds6mg9RUTBfy/tmEoMVhOeUWCboGQ4vvQpVGlM0vlTU
	47JxqeVgwitE5HYrOA1Yd8lotXQ48o4=
Received: by mail-oa2-f14.google.com with SMTP id 586e51a60fabf-4693691fde7so2165823fac.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790623430; x=1791228230; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lE2pJ7XkaEF8KIFM+yW0Sa/QGywvOMdlIxfH6fFMxqw=;
        b=doqEmRO03zcWCV9VwVT3Gw/s27zX28D6UW5vBBIj6e/qlM+KHwlmjFVP4D9JM3Pi1g
         9yfZxLWBVRdZw9VP5FA2DH8VAMKUaCSu0NwM2PiZMBy6hPBQ6a01Ye8/BmS3B9IZfrZD
         3yXANw/58IohwmY6sIzLKVnMi8kRLdz/ykeKYDhyXnwzE4hDF7RvVsGwQTIhBBbTVaa/
         89Dqe90+v0cK1YSDK3NIairz9hf22+rQ0LJ0qWqQ8gVfL6xkJ95cWk9xkfcfAQvp5sOJ
         P6OTUxRS0MZ4sIxtqpTDNjxccgUZFZcU8pmRX7+MYt2h4Ne898YQ+0NS3LfgokBg8gjT
         C+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790623430; x=1791228230;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lE2pJ7XkaEF8KIFM+yW0Sa/QGywvOMdlIxfH6fFMxqw=;
        b=2O0tpanfnDIo+Dutx5ng5OsrAn3HiyN/rKilLAYU9kOVST+MpyBiy7p0x81BbfEofc
         Cog6ZMwF38RLIiWeyrTR8Emp5rVGCH+VDx8SLaaUVG08x2SqAikeF9CksNhbUdO6xchU
         eUmoUSv4svs2l8gB6tnKcD6QoqArfIVSmTbqtlsKx/P8ad03/oZM3yCjO4FSLnKIE+Z0
         ACN57H06RfAKKdocTpEQD7zRGW6VdJSvqgrmR4ivUWs3TfyqcXuDYTKvBZRR72/1oVZx
         aRYJz1pYqko8OEGWrYFHHLwpz0J9xJIbWujPY6KKML6LBDA80RkUOAR80M7pZTK80edr
         ypDw==
X-Forwarded-Encrypted: i=1; AKwUvBwpksecfccWeIWD9cJMHIoSYG8ouFmJnYPV+CmPqTIk4nACU1pV9GN3UiEeSwdKkgbJHL1uKB0qtg==@kvack.org
X-Gm-Message-State: AFq9FYIwoFnmLmBc/y7w0U0pQdTMjvmhUtCGxK67EUWoo7S496lmIfMl
	viLWZXs9aoPxmxUtZRzA8qRqqNHW8A6xzitMhcFn1F3iZUpvmqgA634R
X-Gm-Gg: AYBFou2wG181Shzlr5ThgRovB4Yo9BHkBe370GSBq1gDZbC4f0tcwOL0uXubvFNTwW8
	okes7gqGzlSeVDkNO6xfU9/kKQKSFxSXD1F/GCHtew59FJVVUT8cOQmSXCOZOb5WaMV8StGWLiF
	Ya1bVnHvMc3RGpO27wjzs3DnxqoEhi1nU9rmzjGpU7W7YDnjiTbXmRDvpDBPgI/hgMlXhgqvxUZ
	06AxSolv6QSAJmY47u6sbgo1k0Bu4Hxwc+6A/75rhi0M6F8wGmjg6kCIRw0Ci/uiCGkOMEt3ZRy
	YBbr4zkBK41m367Cr5JrQocgBgnQ8E6SkQi+31B0zkdXt/oN5O6puc4KWbQRufOA1NljF/vTBNX
	dU25qRQriKSDk1j/enM7Gxpj+gY8QbqbpmFazmxrVGDvhUv6UfCVGMlfXaj7LEY6vRMDv23ZpVN
	3jDWPa72dkTq5+I1mHEOLNBkgtpda7id/LhPPwVsRH9Ar6wZrIj1gMf/qSVgYtWMxPP2O+Cgd2S
	RYIJnK5F+9m8xiipCsHm+kiVg==
X-Received: by 2002:a05:6871:6c17:b0:448:9d5b:6393 with SMTP id 586e51a60fabf-491e539b5c8mr13913645fac.14.1790623430281;
        Mon, 28 Sep 2026 12:23:50 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-49335c7a60fsm10239209fac.12.2026.09.28.12.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 12:23:49 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v6 RESEND 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Mon, 28 Sep 2026 12:23:43 -0700
Message-ID: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A52AB40006
X-Stat-Signature: 7ac3747pytw3dpa75zrg3wdwd66trc71
X-HE-Tag: 1790623431-368426
X-HE-Meta: U2FsdGVkX18E9hjxnOdMmGoXupIHjenjCgLBBHPse+dAXd17RFiu0pcHPC49JnOPDt06fc6jPxxA8RWLxdi19EetvYCx5HTmUMyDmrkRz7p9/I5NHJJVs3qu19/35fd32YBo+MImgNXjKqAuUnNCFnZPVl60iSrwBzzxqlrRYKnKvBJ/GqeeTQ2P9WqRs6aBJ/4HIwculFLCLo7NqjUHDnRyA5W6jsWTG4KmFm/hTc7g2yRlHlr1eVyXopSxnwYzemduDBhAO3V6G0rIzOkztph6GKnycQa9Rcmn/b94yUBp545FaW6jdM1WK6+yXcWcHZTgUOLD80CLidG7HwrfMDI8Iqhmo7IVbHul3B3JAx/xYVLSCsA3dgLlfjldlccGp5mviOnP85j3VKHgnpzeNRvAjmZh+ZkUzSQuOvFZh+/PxxZ54atz6Hvro7aQws4N5M33WRqFq2bwjFVTzFilWsIBFPPfDBINO+X465Nls5irA5+Se7hk0BizgGFC9Mb0z4FtCZ28X4bRzgWsfgxfNZ7LZ0xonwneSeD7M7XXKH2VOP7s8ofJClTDu6Xvz5gE2Qyggk57bUxWHE7dZENSV/CGwbv6Pn3ZywXwfSDBGCCTQD4RgumDsTH+oAc1ZNjsdyAghIGJLpnfweIKTQSOnbWU4XcNJef8bU5eS94f8jMmb6ExSBLtXD2bC2x7QwZ0zokr2JuYvgrTGShUaZFXJ7JDi/d85qYhTXlM5ee18ooIufSEPaZm1wjZayQlZGpxH3PG3+0d0CCMaPDwMVOt6pwlpH7viXc2404xZcvTw+mfnGrVLg7FClZ5boz1ao+6QxK2l1hcoDJbDHfCeET15TJwcCMyQWJ2FzHqQVWBeylbfibYyfQC5YHsUO/WgAOVTKJ8dsHtUWbWsbXyxRHmfmf/TUvQ3TFEmgfuP8ZRTfpGfVwm/KTfCqY5hx5ixidcdh+9Me0X/Za/mFCKhya
 2ghz/Ivn
 pElRPMcInonPavMnXS6vGU5aGyoQZfjnNGFrt4ir5w8XBaOfSmHpDm+44CgAjciIkmYtcGp1v283HNu2LPWn7TmVPOXwDqVpiH+k+yXPZ4zPmuL6NPvtg4V/5SnnPxX0N4VsLJiEbdZJPO9EoylXJKOC0RBRTjTMLer/TW6Dym0szW3S0sov9KQv1F8GuvyLLai4mxXSyDgkC2bDwIGIuq8BhjZCePUzPFpDX5kHnt9pQhbxJ7oyBdZ3f+aF+sMPUMExwFAezPRyl79rpYtG5zjVHrIqFGu9nPqzHydMl8YBwFxLzh3v3T0ZGairVtz/QjdyW4n+liX4SqobPanixkn9j0KILbBqdosgdltAtbq90ofzRXvLCEhL0BKpsZwCUIs7XgozhyS5BwoT9vCXOdvXiXe7VNXnmZnyH82+Iq2NHCVkNGHXk7cMR91NGBUFoq6pl7xkAuiXh/rAZ8fbEKtX/IFfP/7rhyuBpTdy3V00H/4GYdbN3LhyOjrPWWia+b9p8sNdS8KU3/mOqTOpgcrSQrbdZHn4cF5PYTK+jEGM0MLYkaS+r3WdB8Xx4ark+HI3Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v5 --> v6
=========
Following feedback that v5 combined the (1) stock abstraction move from
memcg to page_counter and (2) changing the allocation / draining
behavior, v6 limits itself to only the first goal. It retains the
existing seven-slot per-CPU design and drain policy.

In the resend, 3/5's commit message was also modified to address
Sashiko's concerns about preexisting memcg semantics about how
charges affect high throttling.

INTRODUCTION
============
Memcg keeps a per-CPU stock of precharged pages so that small, frequent
allocations do not walk the page_counter hierarchy every time.
Today, the stock implementation is within memcontrol code, even though
the operation it caches is a page_counter charge. This makes it
difficult to add new page_counters to a memcg and preserve the fast
path behavior.

This matters for future work like my tiered memcg limits series [1]
which introduces multiple new page_counters to memcg. Without making
stock a page_counter-level property, it means that every memcg charge
now goes through multiple page_counter hierarchy walks, instead of
being able to cache these charges.

To make future page_counters scalable and performant, move stock from
mem_cgroup to page_counter so that each page_counter can opt into its
own per-CPU cache of pre-charged pages.

We get an added benefit of simplifying try_charge_memcg code, which now
has all the stock management handled transparently within the
page_counter layer.

EFFECT ON MEMCG V2 USERS
========================
This series has no functional changes intended for memcg v2 users. We
preserve all draining, refilling, and (un)charging behavior, including
the uncharge path's refills / direct uncharges.

EFFECT ON MEMCG V1 USERS
========================
For memcg v1 users, the decoupling of the memsw and memory stock means
that each of them now manage their own independent stocks and can lead
to a different size of precharged cache for each.

Cgroup v1 has an invariant that memory.memsw.usage_in_bytes is larger
than or equal to memory.usage_in_bytes, because memsw is a superset of
memory. With separate stocking, this could have been broken in scenarios
where the memory stock is bigger than the memsw stock, leading to
memory usage appearing to be inflated and greater than memsw usage,
even though the real usage preserves the invariant.

To prevent this, report the larger value of memory and memsw
usage_in_bytes for memsw reporting, so that the invariant isn't broken.
This is a bounded stock-related overestimate and does not affect
limit enforcement.

Based on latest mm-new as of 9/28/26:
f4e9810097537 "mm/swap, PM: hibernate: atomically replace hibernation pin"

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/
Joshua Hahn (5):
  mm/memcontrol: flatten try_charge_memcg control flow
  mm/page_counter: introduce per-CPU stock
  mm/page_counter: make page_counter_try_charge() stock-aware
  mm/memcontrol: move memory stock to page counters
  mm/memcontrol: add stock to the memsw page counter

 include/linux/page_counter.h |  35 +++-
 kernel/cgroup/dmem.c         |   2 +-
 mm/hugetlb_cgroup.c          |   2 +-
 mm/memcontrol-v1.c           |  12 +-
 mm/memcontrol.c              | 328 ++++++++++-------------------------
 mm/page_counter.c            | 209 ++++++++++++++++++++--
 6 files changed, 334 insertions(+), 254 deletions(-)

-- 
2.53.0-Meta


