Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 729D2C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008686B0092; Thu, 17 Sep 2026 20:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB076B0093; Thu, 17 Sep 2026 20:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10F26B0095; Thu, 17 Sep 2026 20:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACCB86B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:12:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B9FAC0413
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:12:15 +0000 (UTC)
X-FDA: 85224955830.02.54101F9
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id B288140009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:12:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ryqYN46U;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789690333;
	b=VyAX9bJjL4JdcSCtdQrMNDu1dwx8CbrCbvJc8lw+7DSVjJdoSkG11kBLiR7lUfRvdSXnbe
	l2dn4JbDujoFKr8EAo/u3j1POEDZvdHIBwvRw0NiuJJ7dCDeqygRrlr9PKXS9LbWgaHquF
	83gHE+zTLBr79fmxNifkELGFQb0NjmU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ryqYN46U;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789690333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YgDzwO+XF0qOz1Mzu3N2XDQzWY36fv7PmODRQrhdPD0=;
	b=MY2QY7g/OhGdSWCXF2sy93hzpLKp7pUSkE9ur68li+Yrp1eDjpbEtEC2GX9DhHzHxigLul
	mpnYR1vaUlktxCnYAM4krX568g7dIq1M5IJjDGQY9115+uPFl0+pfw90+Kh6Vvd/g7Oik/
	TzCVv6U7TURpbEDdZjEPCaIaLN2FTkc=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-910531ea7feso2798396d6.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789690333; x=1790295133; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YgDzwO+XF0qOz1Mzu3N2XDQzWY36fv7PmODRQrhdPD0=;
        b=ryqYN46UMgsPNzn1qqmd/Dy8Rf1fXdokmxs9wDn89Jxvr8xsF+JqbtKw43HljLB6I1
         Hp1PNPrg5lb3/OV5QbOTGdxMPQqMrJRV5sKo44UOSzNdu5/s1ky5/LeL+nFoV1XuFHBI
         xUWhZMIAkpQNhIZp8SVEcrr91UywIxBuD1P+LKFk9mrLPVVPF6eXj/8vATEcKd8T8dW6
         BmvIZ1Nq2smO0lOg1D5L34rAOOuXldfNq7ihuWZiWTaouTh9Htyqyf972DLExlOHAo2V
         SReR0vlTr7wkUcJf2tBYQbwvhMayFrmrEKIrojVlu/dfh0UbucuMmKUshflZjO6R+sWo
         9RdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789690333; x=1790295133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YgDzwO+XF0qOz1Mzu3N2XDQzWY36fv7PmODRQrhdPD0=;
        b=2nOLdmKBQfCPqfVrZscYHM/fFqZiA20xbX0UyRH+jQQcsZ5zYTZpMwonPEBUPwtMIR
         N2PLcU4jTZhBPdt13XpKSfH3K6lfemQzoiZhnPrCKJwqgOTUflqo/VAP6TYVLGr3EwXG
         qSeMdybFcTodKT9YSoR4bS/PomXP0gZ3DNaNlrJ+2JhHvG9i9bXSOVeQoC460lM9fhZQ
         iVJSwPBAKvaFfcfQVAvwSRbl+tNzstaKRgsSJqZXLfX+kN+LUw7eFqRW7skGGS5gvUI9
         KhUuppFSUy0xJSlLub0fiPrZbbQPnr0y6Y/PfeS9g/uBKH8shp0O/q5mhLmdEjlUhVi+
         Pzew==
X-Gm-Message-State: AFuF++mbSJEfGcrPf3/9PUR6qkO2uNr4jnOkm0x4JAYGXgpIAhY4ra6E
	OromE+asrio9AOe5ePGBuPcsWlI1NBHAyD1EW5X42fVbEllSDce27DM5B3npsBBspWdGkjHnv4W
	KE6ro
X-Gm-Gg: AYBFou2bp1eBu2hPkNDforNpDa9AYtgpn8hHV07b7lO5ZeyOg6XAbtg+m5utA3/I8eD
	Ct2qa3f/J6daXOPi/PbVW6qJUyf+s84ib6sZag3F0nh6LmlX4wTywdzgbiFsnay3DBrszv6IEOA
	mDgPJ9TYhaKi0bnVPyfQkiGYCa3y26S/GdSlXKk5VCWq/T6c076axWQ2Y7v5efkR3D/PU7HD9N6
	z9Hhq5Epny3tByd1cy7h2gImfZ1wK9ZPpYCv9cwWPgtYgxi//yRduh/DQpmaj6ILG5i/y4C6Dt1
	P98vFUQyINxE0AHK5ZkyVRQDwBI3iycBuTVrcbJ+1X591mF9JDl5xjZ6xul5Oy/dYwcQlqzib3a
	5qz01h9KIIJ6tbnylDJ1m1lB8e5oLkNgr8N5kSv7BTtdy56NKOvRYkxMRF9LxE45XF2yLHN3etO
	FLVge8RZJmxyPA0AqmnxCxcrpD3JsLoOMOxA8PnHVieAIq6nc2uuOtJuN5DESxoINnNd7QgDsW5
	L+vMZ/7tcYhbRlyD9mPaFQjAtrv96MlSBUDWO1V5Mv7ed7IIJJbhSQ/34cl
X-Received: by 2002:a05:620a:601b:b0:93b:d7a2:83ce with SMTP id af79cd13be357-93bdca0712amr95805385a.61.1789690332732;
        Thu, 17 Sep 2026 17:12:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b81cff7cbsm583762585a.41.2026.09.17.17.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 17:12:12 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: [PATCH v2 0/2] mm/mempolicy: stop copying state in the interleave paths
Date: Thu, 17 Sep 2026 20:12:01 -0400
Message-ID: <20260918001203.3389165-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B288140009
X-Stat-Signature: wd56b6ep3t3o3qg4p4ikfwmqnqyjj8qj
X-Rspam-User: 
X-HE-Tag: 1789690333-304248
X-HE-Meta: U2FsdGVkX1+l33NgylGShmDm7iJVhKA8ZdQuBDtWMR4p3gI2ngp2PhogX9VTih2WcHn5Lto8GexayDHpced7JLdPSMhQE4eUZTF7/AcwyYPpC9PV8ZBem5zvLyGbEz0BOdK1ysaOLo4Co2qRDhxFdH9VvCMoLNI2SRmZS8daDraTPvZagEkDxVQHaic2M7C5++pqS/+/GomGKlmlqjl9umNf9tV4uDHaOdsnGN6pxOTO4lHCGjRAOuidL7gI/w8B4i2s0y/fUSh8U+4ZHMyV/bwbofy6+Ku+1bpQ5ox2Sa/dMQBm/5FEPPUl3+GkNk0o3ji+pknwpVLYX3FobfSpo0jnQBtS1dSNxq2n+dmC2rTRZLevoq9MJ8ljIabOMYHQfBWlhVoyt0VtSGAAA3FQOUKKUbpaPkbSSDX8VtP8H6/MUTT8fW66tkL7jAKPOCZSyeiDEKSS7RLQltB/yh0mVqFQ+oJ8hiLYBwZLE59p1HlLR+E6H0L/OHg0Xtl6YefZtX3OsZn39tpQAyOXJ4JaAaQQJQsZ6lXG4gH5sCNEOhKM6IV+i5KN8+PrVuO9BimuH3zerxzXqCC5PaDDLgCzXFB47HNYnyOePo99oFonJq/ZBROlVLssQs1I28f2szEyVx76jYhn0BgKyasnhFoKRStgBdBOoPM4/P7jmjY0GJj47Uw3aD/a/l/DnrGns8qQ0bjRF7Fj0iCLum01Iz8oIMvwzgO8t9vHMO1oKL0n1zQUIyXth6UHEZmnGiGvF2e/yHUVdYQyk4HBeLqcbjwOHH8DG5PZ+DITmYBT0T8lVTvgmxw52zQTt/+i5+RQbbz0OrqRI12kV96TEAYYVrZOslUofOdrNdHodrTkrR2q3mUiZFcTcLIrSYz5D+pH0mR3cTQwAJY9qV8H79sQ9YdgLXLHGt+WsKCEuxbug/5mIEb9mimoDEO77SBJpLrRBKKNRa6xgMNvOeqM/vZc9UU
 jWN2k0Hf
 0U7XpBlEOg0mydWJkOFN5fCKZzW2pSKkBosDROZmDBVZ9YB34AQi7euhghWO+unkNylHlzDU0hkdhCoHWW20fbQ/oNxIKdTIpyc4d3ojRUWiktNcS/rkVETwkKZ30iFdb0SR2mN1yNZ28rQxnHZmqFlOmLQH2CTn6Ojj6Qn03DPNJ5jJn4Ljt+Mdg7CXUsEbFGUTmmddGdRpS6/BwpO5vDdw2gPNQj8nn0mbHOqRpu676ixJtkWrsD7j27hkt6waR+0T/qpJKMCAJ6THe8sn1qOE1PdN4I4bxGgfk2Zj9P6zGD5t0kG6TlxjO2yprSP1/Wuh9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The interleave node selectors and bulk allocators take copies of
nodemasks and node weights (for weighted interleave) in the fault path.
Both of these copies can be entirely eliminated.

For node weights, use SRCU to pin the weights in place.  This eliminates
a copy and a kmalloc from the bulk allocator path.

For nodemasks, we can operate directly on pol->nodes as long as we bounds
check the walk.  A concurrent rebind can shrink the mask, or tear the read
of it so the mask appears empty.

 - The interleave node selectors fall back to numa_node_id() when that
   happens, which is what they already did when a copy came back empty.

 - The bulk allocator simply returns what it managed to allocate.

The node count and weight totals are read separately from the nodemask
walk that consumes them - creating a time-of-check / time-of-use race.
Just clamp the walk to a single pass (number of nodes), and clamp each
bulk allocation chunk to the space left in the request.

The cost is distribution accuracy during a rebind.  The copies never
corrected for that either - they only kept the code from dividing by
zero and overrunning the allocation request.

Gregory Price (2):
  mm/mempolicy: use SRCU for the weighted interleave state
  mm/mempolicy: stop copying the nodemask in the interleave paths

 mm/mempolicy.c | 163 +++++++++++++++++++++++++++----------------------
 1 file changed, 90 insertions(+), 73 deletions(-)

---

v2: Comments and commit message [David]

-- 
2.55.0


