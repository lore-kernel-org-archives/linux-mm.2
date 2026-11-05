Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC944606A33D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EkxVW+Vx
Received: by kanga.kvack.org (Postfix)
	id 1C3306B05B0; Thu,  5 Nov 2026 03:44:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174386B05B1; Thu,  5 Nov 2026 03:44:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A476B05B2; Thu,  5 Nov 2026 03:44:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D558C6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:43:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC665A8494
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:43:58 +0000 (UTC)
X-FDA: 85400427756.07.33B12C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 51F8D140009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:43:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EkxVW+Vx;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xthhCC/mcTYZS02cMzlH9pIKp/bPBWf9wsEzlDqqUYg=;
	b=fmBl2pj++ECbtBAwlAyRBoJaJg2xYmZRe+MWsYK3CATwUzLPE+KEm8srf0eTuRr8RdYnLh
	Z4YjwTVav3dCa8+KMkb/C6zL7mSwkhSHdx4sGwZW1sWxrTKlw3tiC7noXECAAIrw6cqUG0
	iqcXfYFHB1Yc0/JWG3EtMIDPyBP/QiA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EkxVW+Vx;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868237;
	b=Z1vP8RYbpxppyTQiBfnPvXLYILyMrV8GgInpCZKjFe3dXu0GIgbxwAFORtQlAnGi4Nj0o4
	dDRIxSqI1u6r4YbVVIEkPwE6VsUMdtLNLX4FY4te30RczRmM4N82yaQm7z2ijEU3giyV5V
	h8Gp4ukqbw98V7STW0ClNQv0akTCgtk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB69760D90;
	Thu,  5 Nov 2026 08:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF041F00A02;
	Thu,  5 Nov 2026 08:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868235;
	bh=xthhCC/mcTYZS02cMzlH9pIKp/bPBWf9wsEzlDqqUYg=;
	h=From:Subject:Date:To:Cc;
	b=EkxVW+VxdxJn899uQCPstrsAk6REcE49Bzn9WNu/in8yFo8SoEJ/+rF3nPZaWtKOT
	 xsJ9Or8PWQwa5hGiPvo5IJmQoRpRxIDVTtErQjNxn5EpCo9MAUI4X2qDtQNawHHbth
	 zv2l3eijl50D+380ZMSxq9ktSpr/2jLpdrYU7Wp3+19zlYSJSVI2WAs/1cKdYi2T9t
	 VtowUeXw7/TirphtlGJfM/AiKtGvtQzBWhgNJ44q3KiS49KkyeHtApPLt3C8fQQHRq
	 pN/9jZPFLrEiIRFAe+2/bFamUgk0ZLmB6gbIMCbV/nTlr0H1h9yZkO9C/2qf6Daa2E
	 edJlIz2YKPCIA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH v3 00/10] replace CONFIG_SLUB_TINY with a slab_tiny boot
 parameter
Date: Thu, 05 Nov 2026 09:43:49 +0100
Message-Id: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMVB7GoC/23N0Q6CIBTG8VdxXEcDVMyueo/WHMhBSacNlHLOd
 0+stbW6/G/f+Z0ZObAGHDpGM7LgjTN9t0a8i1BZi64CbNTaiBHGSU4pdu0oi8F0U2Hh3tsGHzT
 jcaIUzUSG1rObBW0eG3m+vNqN8grlEJywqI0bejttPz0NuzfP4l/eU0ywIMC5SmMOMj01YDto9
 72tUPA9+wiUsOSPwFZBaprQXMhUa/UlLMvyBAM62cIFAQAA
X-Change-ID: 20260911-slub_tiny_rework-8f2634dd17a7
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: speo3x8sxktfupwb9poryfdsdndd51x1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 51F8D140009
X-HE-Tag: 1793868237-546940
X-HE-Meta: U2FsdGVkX19XdKtXK3MY9Csa7woyM7sI1pH5e4tH0fR7ZhVPsBAfWpK8z6l5yNtL75vGoNvyS2Co9VXL0vspD4RTbclOF37hxl4hy7dVj7J8OMAF+o+a/FsBhndlf/8kDc4lxJ0s2bltCZoSqqrG4gQRpj1meqYRi704kVEJyFT4uPVHfFQaG/BeXjKoWejhD+YlQbG5hxzlGXz+eLXE+B0+SL6jaZg0bAMThCa5BC8aiEwt25sbF/WJMvk59YSVh6KdpNsgWpmfIeOxCuwsazE1qkb/2Vk3M8JRaIkdkY9vruvhi/8wjzmKnNFY5Rs/KaH4l6S1OXowgmzSh7ZkBrm6Yowm7OMH80m/kYSyBPrZi7HslEZC0hD+TH0KbLqRAu51aE5I0/pBYOEUCF/aotL7gFG9RUQ3YXCxQpG/Ty1nu2/FzTclTxUvbXqcMJZhvQfrV3rwDPxoGfLcLGRpeFtSyfsmnWK74ABNi7/53zohJcJ+so02BmcGej1vOvtfI63BgZ/cnKtaOyMn2Y3FNpJa3HHSc6FDmR7/Fh6l+dtBpnaoU8vj8VyyxZIe19KW5ciLQK41uwVdR0Eue2m0qmDNc4Ml1RwEtDxZ8TtVMWq1/m7yI4kRq5WLWZ1CqbBXLHYNP2MV4+vqqNT8adzUP6PCDG7S/bUkuIEe1loAwyWAIkNvzcVn//sBHkIt2sNE2unQO+rv40CELUgUtNs8D8MzK5DvyAuNKWoE/vSB2mq4joFtyB52joA8IfMpYf3QrHHnRUT83IqH+76U2Iu4Snhn3bLT4eEzjnsDhWPHDLsx5nkdettdl9xW+nnNl/+95Ed+sC8b4ghG3bip0wWFupe3+lSoBYR1xflDPQARXFNYediamS+RFVEDWcMQlKYL00vNNGqAIDUZCpEAiAPuuC5Wg1uNzLtBrpH9jHwp3Xf1ejW128Qi83Ar5Hu6HL5lh+uJYMJf9ysZvMRXcEo
 AexVxB8o
 QJM9tHkISMHB346d46I7eBGh7yww1Bb0/gJdbsSaRecb30A2Vbn7U68A5WYOH4SUZ71UnNot4EEQPlZ0kXT6zhK0BAdHVXnuN16Irh9lflnT0CQrFSuAoSyI3qSJRXLRsLyWntQ8VFuYspGcG3LDeHz66lsueldI21wXODe316JJUeVcjm0uwubwLEgcpbcGlJN9vKEarnFAPsS8/KUuHeTEMBq9LCZtV8iuhrGHDPzdC4dAJcNaWLBJWqVhv1rShJJcU3z1XmsFaQkM6yojqL96lAHVdR09eDtEFgyLzxjtwQ+Lo8OGwRXKyWyvTF3pk+tTysV95s4JKE98NYwiDrb7NTfJJM848Wb6hn0qC0HOfAizJhwtY8v/YLt2neiYSHI7RFbb5ohSkfL1jF9z6MW3mW/wPHGOQ+ke2/mSic6pdIOD+iPPO7yqDcqN6UvFRHs3wqj0ljZvbx1DJ/f9CfYKL0l9SuQSrnvcB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Changes in v3:
- Rebase to v7.4-rc1
- Add SLAB_DEBUG_NOOP to SLAB_MERGE_SAME (sashiko)
- Prevent premature slab free in slab and kasan kunit tests by new
  patches 1 and 2 (sashiko)
- Link to v2: https://patch.msgid.link/20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org

Changes in v2:
- Rebase to current mainline (with slab/for-7.4 merged)
- Stop triggering nohash pointers due to slab_debug=N (Harry)
- Stop preventing slab merging dues to SLAB_DEBUG_NOOP (Harry)
- Link to v1: https://patch.msgid.link/20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org

---
Vlastimil Babka (SUSE) (10):
      slab, kunit: pin test slabs by an extra allocation
      kasan, kunit: pin test slabs by an extra allocation
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
 lib/tests/slub_kunit.c                          |  36 ++++-
 mm/Kconfig                                      |  16 +--
 mm/Kconfig.debug                                |   2 +-
 mm/kasan/kasan_test_c.c                         |  24 +++-
 mm/slab.h                                       |  32 ++---
 mm/slab_common.c                                |  21 +--
 mm/slub.c                                       | 167 ++++++++++++------------
 11 files changed, 195 insertions(+), 144 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260911-slub_tiny_rework-8f2634dd17a7


