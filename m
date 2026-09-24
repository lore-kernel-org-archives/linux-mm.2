Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A034EC98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B886F6B009F; Thu, 24 Sep 2026 03:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38916B00A0; Thu, 24 Sep 2026 03:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A519D6B00A1; Thu, 24 Sep 2026 03:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81EA26B009F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:58:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 125DE120262
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:06 +0000 (UTC)
X-FDA: 85247902572.14.26832ED
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf25.hostedemail.com (Postfix) with ESMTP id 280BDA0005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jsRrZlnt;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cH8utLFYEujpE6X6Qzd7ExQckIBLy/Lta27TjnKc3ts=;
	b=AQ8eEzRDaerSjjv0oRaD/d1c6TjVAauZ+GJvS9bRbh03ZWCvd9xKmr/NGkGJ88NWijv+gd
	CuMlRana5LD6tXRKty2vvzqG0J9lWnsxCvv6TuUGo81i+tjLnEfYxxtx1XrinVgO/c+TUD
	6eoVr2PNGWmp+vGTShSyV+vKWwhxERk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236683;
	b=FBlliDNcFiHoZQ0UhcE2yhvJIOd+TynljNnnzoVSm5CfrnQrmGfobWXF/cfBqoZsNOz/Ut
	uIROJfQ6V1LFAdF+ynpS0ZVPIxLl0NTgYeT4y4EnvoXPEjTEg+69QLP+P/DxnRrQvS9cSQ
	HY2KVamfkdFQp2AQoE6OJgSvYzhxn1k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jsRrZlnt;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccda24afso996868a91.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790236682; x=1790841482; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cH8utLFYEujpE6X6Qzd7ExQckIBLy/Lta27TjnKc3ts=;
        b=jsRrZlntWzxwm81H+5tzqwAzi4zFUcp+IAny7WTqo/ZZfR5KDY4tdwcShVieewpX+F
         PyV5fWKYidvsyf1J52i2TE9vMTUI4PRQHUnFV3IhceeduH9WQ/FiKmiXOZQc8W/udAqC
         HsbNJRNZf14BlASCh2CMuFQtVzNtCCuA2+XUijESPlxBpjMgx6Q/Y6ZfbNEh0RxGLNfg
         3BDOXIHU+qu4hR9Qi3oI5HIu7UwroHLIrgOWMBqoOJxG4hXR1gepRanGluyoh8kzAA38
         zqo0TDcgxjswKuiqMXyfsvswSdP2XUdyrdlv53SC3i5eAlsbNPXQNiJq22hAhGmQuZOS
         xr1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790236682; x=1790841482;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cH8utLFYEujpE6X6Qzd7ExQckIBLy/Lta27TjnKc3ts=;
        b=y7iIqV0PngSLIHCZrwUMxkVhnTCH4KhLCY34Cfu/KtHgMYVfkd6nb5ifA2CEFxlgy4
         cyGGwN0eYwOcB9sDAHQT90uZmrF/FWQMTM3QEiwwsqRurKgJV4Szh6PYOvID3W7iS8Ta
         vVkmFiKQa1XMwlRz+98iu4PLDyw/kzmw5PUZqpUahQCtMPsRyeWyRej4T2bocZ5FFRMF
         Iyqu7t2a4Jikn0MxJiG6+Y6du1XYu+rIAZg6/bZBczy/2MVAqYcqVQ2/ukHBkTkTmfzk
         9z9ZTLOi75VPjm3DVyUyaGfjhJTuQ4GBP391yIUHOsrsieKwc/XW0hzbk+Wn/Xu6n7Xo
         QmRw==
X-Forwarded-Encrypted: i=1; AKwUvBwOb4GnszgRZAISzaykVx5wGleekAdz/y2QCC7rgMq7twoz4u6BzCohZoRsjy4y0JjUmQTduLTCEg==@kvack.org
X-Gm-Message-State: AFuF++lh3MBNmGCS7b1OGBPLbAaIOlEYMZxYA7edJtHU2xkUgFvlF1n5
	JtKKiW/eR2dBVhVuqJLjihkF39uX5/I7zCOC+7kR+slJa93ydQ2RW2WScG5mUem3sSI=
X-Gm-Gg: AYBFou2GrqP3da3MhTkhZlx7+OGereHj7pjmvUfL7gpSYeG5gooBJ69QynFMl4SVcCy
	aclmNVvEc90629PqGg50iDC9nb5t7NjHsjd0JY88jx13auUMNGAzsaGh7KgQrthT5kfK5DTJM53
	y8Igno1PEMuQGPUajD+zD72oUusBcN+5ZtaVCM2IhMR+YUuT+M/kTRdRDJNSNsejAL9LB4PHO3z
	9lrG0R/1BwECpzNvutV4ENuVyCq9IgIrOtncbLowczBLR8S6GxjMcmPCz/7/DGKHZdY9e9OOaFQ
	fR5KoGT97kJUm+R5AZS8/9P6AG5MdIqminK/4OErJaBgeC9n/RepViC6Dplm1CMS0Zk7rDW185P
	PwZgYR+Z4L9Q93w+7a1jrg5omR61IpRJLY9VZWhKwJm/gNiM09LH0XftPbIwV9/ZVMGp0+ymzYS
	7GSnk5XlB1uaiuKhoC8TRgSIf9ywWDj/+gGx1WPzrx1IifYoHDINDA1OAc7RWC/qMGNsqzDZyKT
	dkdSDocyUZstAu8SVQ=
X-Received: by 2002:a17:90b:390b:b0:39d:f66e:1720 with SMTP id 98e67ed59e1d1-3a09860771cmr1679255a91.13.1790236681626;
        Thu, 24 Sep 2026 00:58:01 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0972eec92sm3575622a91.7.2026.09.24.00.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:58:01 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v2 0/6] mm: Unify device DAX and HugeTLB vmemmap population paths
Date: Thu, 24 Sep 2026 15:52:53 +0800
Message-ID: <20260924075259.2013039-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6ow8y1f7sp6w35tfny39y54whwbqxxwc
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 280BDA0005
X-HE-Tag: 1790236683-657792
X-HE-Meta: U2FsdGVkX18tLpcDH/ANWj1EAOF781pF3L/ZldoSJkL9BC8paNIpUi3JTr9raAa5sBw1lxhyBKWwCk2WwPjiWRdcSKhsRG3XKq/JnZPKdVFzedC4tTHEvm4lxN1NgDcbBoKirKFY2xdYaU8AMkLxRbA8nax6fSbgvEtAowjpipJJAa+sFTUdzMv6YX2DNdZb6KjtYsY+fcfX9ll/5tN15yxOy3E5dosz6jGFFUcAiD/ZL5qZGVLTqLgSmD1rkRabMF8zuQKD3ZuzElx9axp1fSTVr/+ybIZ9zxQjBiF0HKJFQphB2tu/5NVNYIFEEA6oOgZSc9yRnTlGUVgVdzEW/auXP9ZSImlJxlVtZuYERYIlRiRYw/wVzwFvsNw8YObOLTd9Z0h/0F11Vo9mz3xmrTpQE3lPSYEHsm8UWNmkjUICxmK/HlWOA9IaorSqKbPbvdp5nE96X82tiHBwAkU+Nmt8RD6R+0VV497E3o5pRaizMxtFn4MPuEt04UMKHRPxLZCycIKPPAbAqPsIW6TPCnSvTIYGk6ie36r7FbJR6FsPnZFvWeCu2D/Bwj+9VCMHfIrYUjlMpdEC52pIQNc2mmzdqtBSBdRmlXFITSw926bF/xXR+gopgpLnsa21R8WuoU5bCqYy1rA5ob5GrRTgWYxaiNVRNFzvnBSY11y7x8bb9RzZCW9orokB/GoEudwLZkN/khwXGkgh4vtwgnUwPv9BD5SJ8F1vITjV+TcBZIagmuIOS7O+PACwP8OSortu+Nblyr97wN8VcVjdfHx0zyJOupQFeitwLA/DhgRjEU2DXJZNtg6h7UeJN/MUI/2awSU2K+CbRt9w4CwTyi3tdpkffVY7Y+AeK4EQlVg9emDmQ3aDkVWCPd8JqyWYgQZE1Xpo/2rY8+ooczVndXE5h4yb1wxK6K4q3qxTxhAKzqLV0ODwvkjKDymCf7DE84XrUoNKWhs0M1u0dUWvWPq
 DakQExGz
 YtpYB0RFPeWDSy4hG7rVdlLbDQyQ9tm8iOUOq+IrOkF7+U2BPssVhFlHtUBoPPmtH4VGh3Gp+bYcZeXarPrcNLrGybI2P32LWicdWY7uJSEuC+FSgEFdvfO2+tnFnq3ubETUXiYWmT11ZpeMN20EB57klTOOXNrZ70+eZnYxVbB7dJJozby9zRR2WnMw+i08Ug4uSgG1I6nwNmURmtLOk56FdtcRstxFqigbcbUJLTqMakCnmhSu7HQ3pIfXxLQEWLf4R2bd+PCh1ZBIKhjNH1RavHyk9KCQtbQON++Q4CCr3uimSnm1qkK+D3UsfClvfcxr6Q1wPD2d/9i4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: unifying their vmemmap population paths.

After the preceding Device DAX conversion, both HugeTLB and Device DAX
describe optimized vmemmap mappings through memory-section metadata and
use per-zone shared tail vmemmap pages. The generic code, however, still
carries a Device DAX-specific population flag and compound-page population
path, along with arguments and helpers needed only by that path.

This series first removes VMEMMAP_POPULATE_DAX and moves selection and
reference handling for the shared tail page into the common vmemmap
population path. It then removes the generic Device DAX-specific
compound-page population path and routes section vmemmap population
through vmemmap_populate(). The powerpc radix path continues to use its
architecture-specific compound-page population implementation for
optimizable sections.

The remaining patches remove the unused ptpfn argument, open-code
vmemmap_populate_address() now that no caller needs its returned PTE, and
add a warning for inconsistent zone initialization of shared tail vmemmap
pages.

This is the fourth smaller step toward the broader HVO generalization.
After this series, HugeTLB and Device DAX use the same population model
instead of parallel generic paths, while powerpc keeps its
architecture-specific implementation.

[1] https://lore.kernel.org/all/20260513130542.35604-1-songmuchun@bytedance.com/

v2:
- Expand the comments around the slab initialization boundary as suggested
  by Qi Zheng.
- Collect Acked-by tags from Qi Zheng.
- Defer the patch making vmemmap_populate_compound_pages() static to a
  follow-up series that cleans up the powerpc vmemmap population code.
- Add a new patch to warn about mismatched zone IDs between a page and its
  shared tail vmemmap page.

v1: https://lore.kernel.org/all/20260913083734.86802-1-songmuchun@bytedance.com/

Muchun Song (6):
  mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
  mm/sparse-vmemmap: support device DAX in common vmemmap path
  mm/sparse-vmemmap: drop Device DAX-specific population path
  mm/sparse-vmemmap: remove the unused ptpfn argument
  mm/sparse-vmemmap: open-code vmemmap_populate_address()
  mm/mm_init: add zone mismatch warning during page init

 arch/powerpc/mm/book3s64/radix_pgtable.c |   3 +
 mm/mm_init.c                             |   5 +-
 mm/sparse-vmemmap.c                      | 200 ++++++-----------------
 3 files changed, 59 insertions(+), 149 deletions(-)


base-commit: f19407ca08644f728cfe9762bf1d1f6985826c47
-- 
2.54.0


