Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 941FEC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7EF46B0093; Wed, 23 Sep 2026 11:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56546B0095; Wed, 23 Sep 2026 11:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9937D6B0096; Wed, 23 Sep 2026 11:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 713506B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:45:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0AB8D1A0159
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:21 +0000 (UTC)
X-FDA: 85245451242.16.428EDC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C8141C0004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D1Hm8kXe;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=efpMl5YXUfjthe3Hz2QBP8o+jOZW011OrS6pWOOuAYA=;
	b=Hhhfwk296fD0fakpgIYpXaR5vcetp+DDHBR4wuIcO02+dA4BwP6+7+iBjG051zJhmozWbC
	zfu0Xfrd2W5TRYMYHVVvljPobou+0hT/lT2mELCdacu4J25Ijk68RXIWGVPBom6/qYXPrb
	B4zjw/ntl2nKq2A/oySvNxlw+iUJvjU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D1Hm8kXe;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178319;
	b=fotxLGomwuDFzeNLHiaZ8KrsRXM4+xtUNAwfNZu8neKOTU6yqx6nNfhJP1w4lYG8wIv/nK
	UmLJthL3gHmQupXSmZhgMeiXd6/JNzEunQsxxeIBBPkSoBLQLu+kmXz9Yhy8Z4T7Fu0dTf
	Jbk32t30062j88s0HCmTmQUw3pxdCuA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8332340E23;
	Wed, 23 Sep 2026 15:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493881F000FF;
	Wed, 23 Sep 2026 15:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178318;
	bh=efpMl5YXUfjthe3Hz2QBP8o+jOZW011OrS6pWOOuAYA=;
	h=From:Subject:Date:To:Cc;
	b=D1Hm8kXe9eJePiwRdjubTGJr5OUBxD/SUw/kewf49mok0qEJLiZszrYZcZxlbZrQp
	 n4b97y1iBOUMKbTnmzA/FaHQb5Ng7q5NL/Oc2twJriNFDXSq5AIZ9zhfd6HmkczECD
	 xBnG3iKKpWMTDr28iGxlECScUkT4VeumTHXeY9ISGkrMHoi+a34TpiS26u4KNPcStd
	 7pDXKDY7qZ729onc7bIiNE9PQblXCzfgEHG6XGTdq28Urhs69/mE4NQicNlpAH37KE
	 00Evi2kKkhGM+PtQIWZh5tfgzdbmk5h7XAljWK5+iaARkNjjrKM/LUsWg9ngN5scxw
	 SjEpCZFzwJP/w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH RFC 0/8] replace CONFIG_SLUB_TINY with a slab_tiny boot
 parameter
Date: Wed, 23 Sep 2026 17:45:05 +0200
Message-Id: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAH0s2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDS0ND3eKc0qT4ksy8yvii1PL8omxdizQjM2OTlBRD80RzJaC2gqLUtMw
 KsJHRSkFuzkqxEMHi0qSs1OQSkGFKtbUASrEAjXkAAAA=
X-Change-ID: 20260911-slub_tiny_rework-8f2634dd17a7
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: x5z56cgf58woghatfo8j1bx7tk9sedn1
X-Rspamd-Queue-Id: 4C8141C0004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790178319-322109
X-HE-Meta: U2FsdGVkX19NSvwuBBF8jvANeUE4tJHo78kZiSUjC0lvWQUEiLyKhTHqkxn+vFAEZk95VagIRu1tC9Rt2IyQl1CiGcaBcqqYnjG8Bc9xrUaYS/Fo92bn9CcDKL2Y7pcIm3tJ/AkjS5vcsdw5u8qwkTvcbBQ+noDj58HKCNVF7J1z3KWFUKdDak6aTv5TU8ywTqtv4o7UAnYt5MSLihlVD2DAcfYH3T+RF60hSGWSnZ0gmSsJ0yz94kswJeSPu0VjM432On2erTSnWve/QER4Tp02qqYSIcjqGRvxYuwse8ax5czt1rGjnx3rUVdTAfMH/Ac7uTHqV4a3Sf6uRs7qm3GVKabgf+1Ucz6+4SbSFefrkHhqUPUpozReU4/NDrnFQSSWgUmK+07VrhvIaYV8A/aJ4KmiOBEN1N6CXJmz6YtCJwIlXPTDeIrSrwBearmVzWJxlkrXB8Oy7KWYKbp/MdAby3eprOETUrH0uCygpuC4lsXZFTGCcNfQcSClLUfMEv/RmvLaLl1V1JF9O+NZEmPF3CXUq94Fss+tKjuWijKCi6QRQdAXhVmWXPLamYYAKwmARQZ32NHPOOnBYV3j5tqplyXZamxQfogXCE+ZvReyMpPayNWagcyn3uvIVqibeGuuLI84atjw0TaERwu7s5KwCcdIwthgv4J/6LHK4/ScD9mjg+Hre96H+YecNUomsUy83QvIwFFyjEF1D8sT8EesZR5wDcgtjz5hf5D6jYRxRDWWyLfCOfcHay/iJbfP7xXCDuypFyOjjCtQPNP1ivmJF3BJam/SrL95GH8eHIW2rHssIgaqvJVAXsc0rD2sEckP692199vkTrGQv874ahnp+QHk5ByrvlGACpmOv2Xk1E67EXK3Sxr5jaI9NvjaawFFG5C0UKfZ/Q3pouhbi2Pk4kUfHR8Hhg6RRw9jaoCy6zGhKinHVTLTpixNRRFKkFEDOMYUo/77K7y0o2f
 H0ujcZ3P
 cQRMc6yPb0wqZ3aUZ4uxfonLDeqHbXuuzZwXtRCSUVUFVZlHmSP9f7S8E90a8UnVlhnFHsoID/Awn3fImar9/D8fOFPa+nTV1ORNy8kuyv73c1Bpvk2GNtVdaxqWtbC/KHRaWk3AZHnDYy88YSO4sNS5BRizd2BUEJJHZB9DBfJZ5PQJC5WP7yKK1TXB804P0m/38AaHdp1WdyZIPuZASX9GWsiwlwTbFhvvSS2uc+5m+t2SDywkASA7t9JZPkMx82sbu1BPDyPg5w8LT81fmb1y3Ae1hcEMti8O/3TQplcu4bfMEIicWPnmPqOmN294Juauj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_SLUB_TINY was introduced to help tiny systems migrate away from
the SLOB implementation so it could be removed. Its main purpose has
been to disable all forms of percpu object caching (cpu slabs back then,
now sheaves), and being a compile-time config option, some extra minor
saving were achieved by code elimination or more agressive merging of
caches with reclaimable and non-reclaimable objects (keeping those
separate helps reduce high-order page fragmentation but not memory
footprint.

However being a config option brings issues such as incompatibility with
other options that has caused troubles in the past and Linus argued for
removing it [1]. Moreover, there is a use case for having full-blown
scalable implementation enabled and being able to disable it with a
boot-time rather than compile-time decision. That ise base is the kdump
kernel which shares the same vmlinux but wants to minimize the memory
overhead (which has to be pre-reserved from the production kernel) and
does not mind reduced scalability.

Thus this series reworks the CONFIG_SLUB_TINY to be controlled by a
variable set by a boot-time parameter. The config option itself is
deprecated and only sets the default value of the variable, and all its
interactions with other config options are removed.

The conversion builds mainly on the fact that most SLUB_TINY specific
paths to avoiding percpu object caching are shared with slab_debug
handling, except doing any actual debugging checks.

Thus introduce slab_debug=N (for No-op) option to allow using the
slab_debug checks directly, and extract the underlying static key
handling from CONFIG_SLUB_DEBUG only scope. The decision to create
separate kmalloc-rcl caches is also made to be boot-time.

The parts of CONFIG_SLUB_TINY that can't be transformed to a boot-time
decision are related to dead code elimination and fast path inlining,
merging of non-kmalloc reclaimable and unreclaimable caches, and
ignoring SLAB_NO_MERGE for performance purposes (currently used in
networking). Those lost memory saving should be all relatively minor
compared to the savings from avoiding percpu caching.

To sum up, after this series:

- CONFIG_SLUB_TINY is a deprecated option that has no interaction with
  other options and only controls the default behavior.

- New slab_tiny boot parameter controls the functionality (and can
  override CONFIG_SLUB_TINY in both directions).

- slab_debug=N can effectively achieve most of slab_tiny and on a
  per-cache basic

- the implementation is simpler with many ifdefs removed

[1] https://lore.kernel.org/all/CAHk-=wh-k04MsoEC0SGKff2Snm6bBF_e+0pHOKwaWv4umZ_SnQ@mail.gmail.com/

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Vlastimil Babka (SUSE) (8):
      mm, slab: refactor slab_min/max_order handling
      mm, slab: introduce slab_debug=N
      mm, slab: rework KMALLOC_RECLAIM handling of SLUB_TINY
      mm, slab: make SLUB_TINY handling dynamic for sizing decisions
      mm, slab: convert CONFIG_SLUB_TINY checks to kmem_cache_debug()
      mm, slab: remove remaining compile-time checks for CONFIG_SLUB_TINY
      mm, slab: add slab_tiny boot param
      mm, slab: deprecate CONFIG_SLUB_TINY and reduce its Kconfig effects

 Documentation/admin-guide/kernel-parameters.txt |   4 +
 Documentation/admin-guide/mm/slab.rst           |  18 ++-
 include/linux/slab.h                            |  17 +--
 lib/Kconfig.kasan                               |   2 +-
 mm/Kconfig                                      |  16 ++-
 mm/Kconfig.debug                                |   2 +-
 mm/slab.h                                       |  32 +++--
 mm/slab_common.c                                |  12 +-
 mm/slub.c                                       | 149 +++++++++++-------------
 9 files changed, 120 insertions(+), 132 deletions(-)
---
base-commit: b4218126d498275444f315b0ed4cef6add6beabc
change-id: 20260911-slub_tiny_rework-8f2634dd17a7


