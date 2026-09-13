Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B029C88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 08:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202C56B0088; Sun, 13 Sep 2026 04:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5296B008C; Sun, 13 Sep 2026 04:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A56C6B0092; Sun, 13 Sep 2026 04:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D56B96B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:40:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F450160624
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:40:21 +0000 (UTC)
X-FDA: 85208092242.09.10861B9
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id B718F18000B
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:40:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dwLTBxzV;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789288819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XEYszFcJNVmbdBdKEoxiw48cXUFgR+bqS4N4pNtc0Jk=;
	b=etY9LMcxlb3cZOG7bt0zG7TH3VjvYzweXZ3Gn1ZM//hWobKbSGpBz//jIgin+ZTkwTiySY
	88gXRVEbHf5k/Zk4yqKa9+lKdlGL3QR3YLY+nJPIp3j/w4FzqANTqkkJxEs+pelkxF9dKQ
	1L6GrkEWKP/ZD5YKkAE8ntywYk5KeNk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789288819;
	b=HrNtRIoT/EDsw3PsmzbM6CFfMttqDT/diGVXyR8wIhP8liND6XSr97/lJlrv3bpnGMdjBu
	+U6fQRX/PYxqAYr/D1HUYA3PQThO8JPFQr+auXtuIJQtVFBXBoOYxBybZ7F6ZMsC6fOqKF
	oLxENjOfnBR8ZhMCPxLrkYcgXdWPr4g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dwLTBxzV;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-86a25369f16so1751129b3a.3
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 01:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789288816; x=1789893616; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XEYszFcJNVmbdBdKEoxiw48cXUFgR+bqS4N4pNtc0Jk=;
        b=dwLTBxzVi+gkpcMVY5BRV48n8/T8B1TlV3ijRpqc5HRwdrUMekZSeApT4xTB5aNEIj
         3u9dJSKYtG2G8eSza8B3Nwt/VUiVRQhJoy9KTOg0j60LBYUIxoIbhpK97vBXzfSkDknN
         Y7M98f0psiAO5hQUJDp/LQpf5sIMM2ode1EYb5x1hMdjwhJiHuoihyHfPjjimTyVjf6E
         IOU9JNagdS0QEO/SVIGruwPk/+XrCDeNXRfTOaAm2ZZJ/zk+r8cuTUTwHuEIQiQUJqUL
         3FPIUnMB6HYXxrfNwE8cskz8D/eJFQxVyZ+wnBqf0xLpqDWM5W6nrqyO3PBiDYu8u7cX
         Rvlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789288816; x=1789893616;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XEYszFcJNVmbdBdKEoxiw48cXUFgR+bqS4N4pNtc0Jk=;
        b=b9+OI7TOCnegGqPIuxCxnoBk8+RD/5tCIezlETdt/OK+IfGTWI/RdAzwsrUaebcbD2
         A63hf3OKILaaqrEXCXDWemCRWtGWwza6DZk2bfGsl2HhK9Qbysoxh/ReUJgnh4a30Fkh
         eV2hyBf7m0NES4046NunEVgAIXNZtzy//Gf39WhJxMEhtKNrXi/RetF30rXTc+7jZpWo
         8flEmcoVmZMCSpgh3KYpnMv5vYkI04qgGZsCqAqR8oUSHNbNgNMGCG5do32kDpI6Neb6
         ytnp0g+3GCn93PqYf9R8PXVuAbktNQhrFPZsooHTMBs6chhTCULetXMNPwx1iyEJFo4r
         VycA==
X-Forwarded-Encrypted: i=1; AKwUvByOTSBAT677gs5i+uVggaVCaXISUbuZ0ZbsLHf8xvmdo0FOlO9dSb5N/RKZQicUey6cwxSkrTLU3g==@kvack.org
X-Gm-Message-State: AFuF++nqO8SAB5rbXew+/tmyOXLl8/LASnQgxUQdd73VLTuKAAEUv4Ak
	dE2xGj3LIocp55/jqaNCxD6AGOuv+tudrn2/ENmvpHY89BDeXK4l4ejdpNG2YFJaBig=
X-Gm-Gg: AYBFou2cuDPk3A+fhl6NJqzAsr1swjMhDeGYEz5zYYnlF+xLlJsuPeWxYmBK7HTez/x
	yPhPspByVFHNvBMC8VFkLlEJZfoRBajsMxaZ3v06BWR+Uha5GmpzPs1/nNMF0RKMljHjGs1XwXV
	/VcGYOVFfTxOWvb/wdDy9F8Ny7Hl2OhJJwle01BQQIK5EO4ng/t8tHpu5Ft7fvXnumwTW9I8bRK
	cPgDVLGvlDtOFhay6SkuquY6JnOTi7mlqCTUN19MsucYpoHFvPSqk/AtFhQ7DyySJ+pde4qlsp9
	NjsY/+i7cbAwI5KQTbwXThsUoO4eq5KSFnR1RyT1GF8BsAiHTz65/KdGe7syyZiJaWYWOdBKwXE
	y5dSzvBmLdqy4Qkbk3HrOcUZLM2sxhk7EuPyFKyml9QddDnvHxjYPh2yYn6IXse6dy8zH/gDEUM
	5VKj2ggrFBIOSxtRQk9bFGgip/DaSzvgFB1/QBRu+0PGh7W96uUYE7v432I2IK9a7Syg/e5Z8mv
	mWdq2z6k5pLjlZZa/Y879//cu4k5C6B8f7Z/Q==
X-Received: by 2002:a05:6a00:6c97:b0:868:7a65:d92d with SMTP id d2e1a72fcca58-86b32fef08emr19801366b3a.26.1789288816421;
        Sun, 13 Sep 2026 01:40:16 -0700 (PDT)
Received: from G6L4RL2QG9 ([2409:8a00:1832:cf0:5137:990:100e:cc7e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b29cbb0d3sm3070531b3a.42.2026.09.13.01.40.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 01:40:15 -0700 (PDT)
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
Subject: [PATCH 0/6] mm: Unify Device DAX and HugeTLB vmemmap population paths
Date: Sun, 13 Sep 2026 16:37:28 +0800
Message-ID: <20260913083734.86802-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mbj9cwg4p1c6dqxiiy7541swm3f9zt5n
X-Rspam-User: 
X-Rspamd-Queue-Id: B718F18000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1789288817-962672
X-HE-Meta: U2FsdGVkX1/SjQyJLOQ2UjfTvgA/G9D8GzkV/ad5L8Tkha6sJOi9j4raZi7puV8Yds9qLUGe802cU7OoqwB227Ws5OqwUCTZ0l1DvgmO/E+QN5VVKK2TIalr2ZMW6jpDrKJT3ULfWOL0B6gz0+LnW3vdoTWJBIvH46VaydLgyx65F703wMNfhYakN0oHxcbkIYDkczbHB4vCe2cH3EMuve+yGLm9A9LNktwDTxdCCCD3+O3DhB42kiRvviMwWFMUJQKip4+UAJxcSunOwUmfknJSz6wOUQN+3efUllCJxgh5/cTizVQsZc4AmQs2qU2U94GITJ3rtyxTaGX/LIsz/hOY9asK9g6dEMBTs3X/dxcqh/Jo5CqjiRMb81e3K+6gqMrbaieG6RBd76mkzPBnZtC275mXhSBD7zc4tHnsUho4LsnoE4XeMDBbXtKtrfefN9tZm2e0ykv9l1UYrEOTzxkqNEi1yogzQPsdxaoWcZtA4whoH0mtYEuPIXpXIHfZmGvRaWofxoRZ6XRMxlhDKdexYScBZ9yyIMgWp7RwKPMVrjk2lCmPWfUdz8AYoTBlzFbGfa/+5ymsRrmTHj1Ksqk2p5Rc509ZnOBKqhPTu1hiJe2QkgxxB+zKVk/PxGlgvsQ11hvpRM9jMV/LbrrPx34IqPpoViAHDLviYtlZ8RpG03+WOTrbZPGOSiWO1P31/usi27VhJ/sCg8z3GzaMRp/gjdt0QJMCHLlR0Gb2W/tDyupbsjvrfpPRzIjaCitvxdO6eLitK4mCLaVPzHo7BswqyTLnh9ArbCH+wYgcw71V4vTyeWWZTRJOcYUEMso1uTvGV5J30+DwDJ0BhwP8qylWf+xo2KirDW5armpJALmY3sxsOWBY2gtR8UZqcsgS9CLJdAkaaYnem1Vemm6a8ybU2rAtIUEGkEi+rDJEKUj9gsM9fRCzm+qQvMvgzaUJyT7aAgNj5om19WV7Xso
 Fgx4JWBX
 TbxH+/3qGfNT5AMI1PVRWij21tqs5p3tc1BC9zvbvig8guvOS1sPpaaPqD+kkACe3PC2NfUBBneNYsmk4L29RSRKVNOgwlrURaRVgkgojEN8IPOwx+SIkAnGz8oI2srqA2htd3OidiiA+ppx2JZ5NFb3XjokajQK4O4prwIaUcjQpYhBYs9k01gcyemX4/1Skh82TEMHEvtcJZnkIjkD+r9BrBGZINrXAdtIL1POgvkqn5Z46I8PALIK96xLcjTO+gJdPrX1knYZgWZJKwhk0nVUvFIAF0B7brO6oBRoSLbRwGN84uHNp5yMk6eZlVeW3IZg7dmj881Bn7aU3euj/yfnw7Q==
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
through vmemmap_populate(). The powerpc radix implementation retains its
architecture-specific compound-page population and selects it directly
for optimizable sections.

The remaining patches remove the unused ptpfn argument, make the
powerpc compound-page helper local to radix_pgtable.c, and open-code
vmemmap_populate_address() now that no caller needs its returned PTE.

This is the fourth smaller step toward the broader HVO generalization.
After this series, HugeTLB and Device DAX use the same population model
instead of parallel generic paths, while powerpc keeps its
architecture-specific implementation.

[1] https://lore.kernel.org/all/20260513130542.35604-1-songmuchun@bytedance.com/

Muchun Song (6):
  mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
  mm/sparse-vmemmap: support device DAX in common vmemmap path
  mm/sparse-vmemmap: drop Device DAX-specific population path
  mm/sparse-vmemmap: remove the unused ptpfn argument
  powerpc/mm: make vmemmap_populate_compound_pages() static
  mm/sparse-vmemmap: open-code vmemmap_populate_address()

 arch/powerpc/include/asm/book3s/64/radix.h |   6 -
 arch/powerpc/mm/book3s64/radix_pgtable.c   |  14 +-
 mm/mm_init.c                               |   2 +-
 mm/sparse-vmemmap.c                        | 188 +++++----------------
 4 files changed, 50 insertions(+), 160 deletions(-)


base-commit: 383fc05d4650b021f3c17e36a145106dcc61a294
-- 
2.54.0


