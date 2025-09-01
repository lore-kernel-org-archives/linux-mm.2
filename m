Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBF64CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DCC88E001B; Mon,  1 Sep 2025 06:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086D28E000B; Mon,  1 Sep 2025 06:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB76A8E001B; Mon,  1 Sep 2025 06:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D48568E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:46:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 879301A0790
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:46:31 +0000 (UTC)
X-FDA: 83840352582.28.10BD6A1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0C5A5C0007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:46:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756723590; a=rsa-sha256;
	cv=none;
	b=JaszaIfGR6ZSzhEd0plhxSIHlLWuHdclbkWX+4idXVZKK81TTM1wZtoF03SwbvOIxW94oQ
	S5a69rOvwKOCllM0tb1O3uztr8Li2sBwtyIkDHChvLhVyPXXRfh9vnVRACG4LCO9uD9esq
	ReeJC13XCwBVDeQ87nwprv9Rb03uoXA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756723590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=s9FSr+hyjyhHm1NCXUk75KE+XvaONfrQlCmBbK3JdxI=;
	b=8MTztz6Fw1Lb9ZNGlw20A7RZct2Vvx7ifj0vvZlXPvcKW4BWCihUuXxEpNuTNxjm4HjhyL
	GNk2FwjF+ht17s902VYJ7rodNFodW5GNBvV/QfQufHSsaG+GMz9GhG0xn6Ef7oP+nqwqCM
	LVo7jbgs5F7xzp15WVJ4LfYdfAW/9dg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C99E16A3;
	Mon,  1 Sep 2025 03:46:20 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E77023F6A8;
	Mon,  1 Sep 2025 03:46:24 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	corbet@lwn.net,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	scott@os.amperecomputing.com,
	jhubbard@nvidia.com,
	pankaj.gupta@amd.com,
	leitao@debian.org,
	kaleshsingh@google.com,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io,
	david@redhat.com,
	yang@os.amperecomputing.com
Cc: kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v6 0/2] introduce kasan.write_only option in hw-tags
Date: Mon,  1 Sep 2025 11:46:21 +0100
Message-Id: <20250901104623.402172-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C5A5C0007
X-Stat-Signature: kggn767pdiiatq9fe6s3pob31bopmgpj
X-HE-Tag: 1756723589-773008
X-HE-Meta: U2FsdGVkX18CEE3bcsb8YFe5EQrapAxV0U8TBPpB/Wlx5+k09oWUb9lFXX0P/ijVkatKuLZaHjRnLfwBxuCC7iPCTLYV8iG4zSWFplr3L0kAyRlizHv5bV+IffH2rYz6cy+gD4Z/UZONpmsUkbfaO112M5OkYXHK5CMfAlVcrg+M59yaU1ypEPgE2wN8SNjYTWKWGgsR6lhqdDwTVsGrt6/PAC9TZ2zfMwFxwEb+QLGPMAqZDnjM9NzJqKUoUQzBkP4eQDQ75yUhmCuj4MZxaJXKCwnKmqxUCsD2UMUOivURzHSbOQ1I8U+J3OEdQD+cIqeAymyJWQ8o4nM8Qfz5VOxBYB1r9Qfj9LmN7V79UFnVhr6vQT1Due2SnLawPuNBT01R1N9xcp3EsTuKiWf4IDZ8+LBsCfLYly9wBZrZ6K1NuhEAmXK8HAUODMJwTu3lM5B/idnrLekitA91rW7MKHT1aInsIpbGhoHcIo8KDa/VQyEr3Y+puJcAr13Fpr6M534CgWI0TvlJtCtlGdvv1GnL7J5eOKm7zX56RYfJwf3WzIRtE2u5VAXimzadRH2y1fTf5bVxQWC8dIT0Vv2EYVf/hlIQafmgcIjlFxUDZszAaCVSgJPU4+I2KTxSifdDj+slkGvg1Gf9IfviE1oYgzzUG8F6JPUKCcxQ50/F0YoIP5pZ0GzOtncolVQq2gvs/lxk+Vs8Ks2D3+/F/jiKj9r4mIdC/MnVLszSJPnocQofPimx0Z10z6hgxekf8GfYqiCCSPslQjDcvKuGZe0bU8V5wNS3JsNdDVl6IYn+IAseXcgG4D2nNGWCW4Tg2mztxL2vRjuZ4+YspqP/LhiG1cciFKZRnbm3Cm1vs3LHXcZnpid4m6yKmWQmK3QkDzgQk4efqIzRV+uYBe5APqdI3EJkkAej7DBYP4V1zs4Wrd8TCiWtFFMpN4HZtJirSKU5PkaXxTP+HZprjcqR6zc
 S4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hardware tag based KASAN is implemented using the Memory Tagging Extension
(MTE) feature.

MTE is built on top of the ARMv8.0 virtual address tagging TBI
(Top Byte Ignore) feature and allows software to access a 4-bit
allocation tag for each 16-byte granule in the physical address space.
A logical tag is derived from bits 59-56 of the virtual
address used for the memory access. A CPU with MTE enabled will compare
the logical tag against the allocation tag and potentially raise an
tag check fault on mismatch, subject to system registers configuration.

Since ARMv8.9, FEAT_MTE_STORE_ONLY can be used to restrict raise of tag
check fault on store operation only.

Using this feature (FEAT_MTE_STORE_ONLY), introduce KASAN write-only mode
which restricts KASAN check write (store) operation only.
This mode omits KASAN check for read (fetch/load) operation.
Therefore, it might be used not only debugging purpose but also in
normal environment.

This patch is based on v6.17-rc1.

Patch History
=============
from v5 to v6:
  - change macro name for KASAN kunit test.
  - remove and restore useless line adding/removal.
  - modify some comments on KASAN kunit test.
  - https://lore.kernel.org/all/20250820071243.1567338-1-yeoreum.yun@arm.com/

from v4 to v5:
  - fix wrong allocation
  - add small comments
  - https://lore.kernel.org/all/20250818075051.996764-1-yeoreum.yun@arm.com/

from v3 to v4:
  - fix wrong condition
  - https://lore.kernel.org/all/20250816110018.4055617-1-yeoreum.yun@arm.com/

from v2 to v3:
  - change MET_STORE_ONLY feature as BOOT_CPU_FEATURE
  - change store_only to write_only
  - move write_only setup into the place other option's setup place
  - change static key of kasan_flag_write_only to static boolean.
  - change macro KUNIT_EXPECT_KASAN_SUCCESS to KUNIT_EXPECT_KASAN_FAIL_READ.
  - https://lore.kernel.org/all/20250813175335.3980268-1-yeoreum.yun@arm.com/

from v1 to v2:
  - change cryptic name -- stonly to store_only
  - remove some TCF check with store which can make memory courruption.
  - https://lore.kernel.org/all/20250811173626.1878783-1-yeoreum.yun@arm.com/


Yeoreum Yun (2):
  kasan/hw-tags: introduce kasan.write_only option
  kasan: apply write-only mode in kasan kunit testcases

 Documentation/dev-tools/kasan.rst  |   3 +
 arch/arm64/include/asm/memory.h    |   1 +
 arch/arm64/include/asm/mte-kasan.h |   6 +
 arch/arm64/kernel/cpufeature.c     |   2 +-
 arch/arm64/kernel/mte.c            |  18 +++
 mm/kasan/hw_tags.c                 |  70 +++++++++-
 mm/kasan/kasan.h                   |   7 +
 mm/kasan/kasan_test_c.c            | 204 +++++++++++++++++++----------
 8 files changed, 239 insertions(+), 72 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
prerequisite-patch-id: 136c6b02685560c44ec3344be9b716bdfbc5ffa2
prerequisite-patch-id: 45bbbbf89a641d5daca648988d8e4d45de45db80
prerequisite-patch-id: ea19c0e099daab02577ee2e86671417fc57d0b0d
prerequisite-patch-id: 5adddd8cd6865b4d6a0b7d9e9085220e22723faa
prerequisite-patch-id: d8471a1aaee960efa4fc41ca42068aef6730a8d9
prerequisite-patch-id: 969950ee5ccabeb3df369142dfa97a4474788859
prerequisite-patch-id: 21b91081876a36ecaa5547e1f251b2101ba97950
prerequisite-patch-id: c04ce4ffe72ad15b8ab13e157d8b25d635f170a3
prerequisite-patch-id: e8b79e0c052d28833e4f4c627d5365ef5299e617
prerequisite-patch-id: 07b1a7e43f2c7f61c397ef4f6c5e12b0df3590e4
prerequisite-patch-id: 2f420864ab40988d03c96c27ca5ba431efe2717f
prerequisite-patch-id: eeac7cfc0249e5ac71f12e340277633cf4d7aabe
prerequisite-patch-id: 6d190150e7f678ce654800a41800278dc2dd0bb3
prerequisite-patch-id: cce369222a7cdd5f91d10c12cb3905107f6a7874
prerequisite-patch-id: 290b18733f6fcbf5b0bcfc1a378d2cbf3d952669
prerequisite-patch-id: c81d671f37e6465fe8ae0e5ce2e32aac8e3e5e10
prerequisite-patch-id: 7f38f1b76708ea2b33e0bd7ebd334ae6d6f95b78
prerequisite-patch-id: a730599474985e4e8f4e17a6f3521f7de687825e
prerequisite-patch-id: 0af8e9b6d2985a1da4a220de34e1a37179fa1a2c
prerequisite-patch-id: b4a83f3d74686eee187f25ca12ef75a0475fa2cf
prerequisite-patch-id: d0e7e6d3485eed1b85fca8e12c6ef4118ccd8c2d
prerequisite-patch-id: 8f1932d6d4892d06de0e6da0606fe94644d10b02
prerequisite-patch-id: 8149f1ed55eda3d2f7ac70c71480c4694ce8c293
prerequisite-patch-id: b244e6c6438bb637a9c2123d7875072a336dbf40
prerequisite-patch-id: f3bb5cef44a4dbd16d314ac72674e87da9576031
prerequisite-patch-id: e284957cded74a97be39563cc68771753f8ff560
prerequisite-patch-id: 42fb46241a4969b46377fe372b107ecf84fdac65
prerequisite-patch-id: 03ca449e3ef1e354bfca8dcfad1c1754992770f6
prerequisite-patch-id: c784c79c432175b2b8f980b570604cb3839a1d0f
prerequisite-patch-id: 6cf468fcd78d9f5566c848caa29c2e63279914c6
prerequisite-patch-id: 9e4ccee8587702f2e0fe537c7072b9888a0c1aba
prerequisite-patch-id: 1e44823aba4d29d8cf9c2d5c7659382cd4e9f578
prerequisite-patch-id: 107f6ba7dd4b22e870d641670ed020cc3d783df2
prerequisite-patch-id: 0bc6e19edcc18632ade69696a057a71f9169e90d
prerequisite-patch-id: e776b9cf46afdc0c90293081a786144d21e4ec46
prerequisite-patch-id: 18ff9ea0304a49a5e1bd200a723d8eb45c7c92f7
prerequisite-patch-id: bd747f03cfe61caa1bda1caf594ef9f195d70a73
prerequisite-patch-id: e5f37bb65433f4d290cde0a65c3cb46a5bd8f6b8
prerequisite-patch-id: 230be9c059f823ea5c78d1b1da55fb18892a0f72
prerequisite-patch-id: 150d0a767ab84dc9eb3c39bd7d63338e961b0233
prerequisite-patch-id: 383116f4edc62f1ba03ffd10385aed7140b9971c
prerequisite-patch-id: df971da9ff346719a80df1dbb0728ee35fa71ae4
prerequisite-patch-id: e725511837cca1e7e5d04670885a52582aecdc39
prerequisite-patch-id: 594e3fe39c37f00f20f48127ef02b4363ece1dcf
prerequisite-patch-id: cba6439f7314aa62c188077a120ae56201660b16
prerequisite-patch-id: 29df9f163c4dc8518a0b408b5972a8883b841dd1
prerequisite-patch-id: 78667378d037d37076499b68e80393b0861512b3
prerequisite-patch-id: c8af68f162f02af7d2090e3a20dfa95a68067fd7
prerequisite-patch-id: ee1e3cef0df94dd93584110c9fa590baec1e951f
prerequisite-patch-id: b75496be2f73ac73bd7e1f5de1ec25f395db9d1b
prerequisite-patch-id: c1c008ad523d34fc5bcd3455a6b7b46a48a0372d
prerequisite-patch-id: 13ac4ac649d2721cb1fa1a96c8680050b865de87
prerequisite-patch-id: eb6c631b6f18d1d9666723b92e11e005009a5d92
prerequisite-patch-id: 540bb74abf0680f0857eccb6d9507875923644a1
prerequisite-patch-id: 27d953412b9416a0523eef0d45557db08edebad8
prerequisite-patch-id: 28adf1a29676d8184b138f60a02e033435c44960
prerequisite-patch-id: 7f67f3bf300491ea7852fbca10d7dcb0638c1771
prerequisite-patch-id: 358ba438674c82a7998d68cca853f2828276a609
prerequisite-patch-id: cadf6f28cef328a919572d8e0ab2ebc9ed2019e6
prerequisite-patch-id: b1f40307c72f0a314c4184c2d45e0a8b4048f685
prerequisite-patch-id: cf02be23717b54437918c80cfb663ddecb2d1483
prerequisite-patch-id: c2153976ef7c54556abfc04cedf18eed300e4fd5
prerequisite-patch-id: 7413f73a43098ff888f715c13747abb62f498770
prerequisite-patch-id: 4285dc47a26a5152eaf515c2934cc0d1b7cc9d1d
prerequisite-patch-id: 94032debade30f10dfb6a4021c1a41b49d4ea069
prerequisite-patch-id: 1b0d245e4b8c568f4865a00e011d79d39adc1649
prerequisite-patch-id: 33c3958dc29779f84a2858902043840169cc7de3
prerequisite-patch-id: fbd86d03e31d738865d27b860bca951b283fdab5
prerequisite-patch-id: c20b348d2820cdfe31d800efc950c22255bc22ad
prerequisite-patch-id: 0a15397743a75a3a56017975501301d56963d771
prerequisite-patch-id: 64dca2daa72ff52744f7e86623309e757e0f1c40
prerequisite-patch-id: 34ae142eff624e64106ee0f594394e1600973e5d
prerequisite-patch-id: 9b3c97d6537a7d6ebfee8e7a51057ae0bd6be479
prerequisite-patch-id: 7ecc644ea8560552cf4cc12925de81b56fece04e
prerequisite-patch-id: 800813b629a6e3d09d47076d898150cd73119c07
prerequisite-patch-id: 745083490be7d6e249f24ff7574c2b8df9f37a1b
prerequisite-patch-id: 878c0fbdc362b4fd5c943400b72f4f4ffe141a55
prerequisite-patch-id: a8627b9e4e87a5fe2cb0d17125559d7be15910aa
prerequisite-patch-id: caf32baaa38ad7ed80e4109fd853097b8bcc41c8
prerequisite-patch-id: 48dbc4fefb04926762e09342b63eae52df44048f
prerequisite-patch-id: e1fb352d09da8fa6ee3306d85af029a9a4be7ec8
prerequisite-patch-id: e7a5b69d0283bfcb4e2901f64d8834ff5361f126
prerequisite-patch-id: 04712cd6067166048944e741e8f93e018904ac56
prerequisite-patch-id: f15d057c5ca21a05f7a205a6519d58ea1f592d7d
prerequisite-patch-id: 7476f8cd099b5fab7a0f6c76a378e2d50066be0b
prerequisite-patch-id: 38f0c6aa4dd53f308b4c211d7b6326de6622f045
prerequisite-patch-id: b45a6f20519aea585527078495a2c9c63feb3778
prerequisite-patch-id: 9344feb49232a49d171c5c2fee55a28873ef5710
prerequisite-patch-id: 3ae3b35697646f814c74a62027a9555bb1c28ac8
prerequisite-patch-id: cbe8aa31360444f9768764b0659e1d04cd77a5b2
prerequisite-patch-id: 133cfbe76d691ed57dbeecdc355833b0ddd20208
prerequisite-patch-id: b54ad7c10fc1a6cc0f93e603397510906ef22a68
prerequisite-patch-id: 6d62f0ec7000fd26db84a7008e2cd92738e6bddb
prerequisite-patch-id: 642b15a05d3613f503651ff795947df69c8c856a
prerequisite-patch-id: 7fce745555f774f4ddc39044c41e013fd42a5b7f
prerequisite-patch-id: 81aa7af170f321450fb7d29e788b9de90ef60261
prerequisite-patch-id: 3307943829aea5595b3ec49f22204c55adfc9c37
prerequisite-patch-id: c865672ddb7be662d9fade867201679bf5d62408
prerequisite-patch-id: 2fa765c8477947130a6be91cccae9fb2de84e193
prerequisite-patch-id: 08a9efdd6e4bc6de5baa2789f1d608ab98a327e0
prerequisite-patch-id: 0d0b0b71375800974dbe7237927dded7261180bd
prerequisite-patch-id: da00f3be5a9c30a68c3ad40eebc9e857664ba39b
prerequisite-patch-id: 7ce6f4d8ed2cca29fab9d06b53d94eaf2d4a71ca
prerequisite-patch-id: b353a98ba3563e9f19c3d869753c2a000bb0dd5c
prerequisite-patch-id: 14fc49629b991d714c75068d1bd31cd4df00369f
prerequisite-patch-id: abc5404e1ca9ebba2d256e5f19aafdc3da8433e9
prerequisite-patch-id: 3fd33bd1054f7cfe8c3d08b7c53a77df6e89dc5a
prerequisite-patch-id: 90eb019a38dbd0099a9aee921bde795dc77281c6
prerequisite-patch-id: 69933246ea66c02b0291a946a510e63b28aa4a07
prerequisite-patch-id: d4b2f02a1df02786239131b2af8626f19d7febfd
prerequisite-patch-id: 54470e5d2206ef4dd8ba2168b29cc57579fac520
prerequisite-patch-id: e0b3b83c0828ad746354d536270942259ad7d5a5
prerequisite-patch-id: f7d545aa7a1c82938ce0437c251acd1a041a32b2
prerequisite-patch-id: dfd0e53d9bf57c760fd284ce27c41ba91bf9ae5b
prerequisite-patch-id: 76313f2c8af79cfd97a5f79da5fd5b3fc4a48bfe
prerequisite-patch-id: 0779fa85eb9cac194a01a6351288508d6e80e90b
prerequisite-patch-id: 41f7a748ce6619611991b479468334d1edd23022
prerequisite-patch-id: dd030d0200d8ce2340bf7d9b71c6e9aa719eed8e
prerequisite-patch-id: 5c32ccd9b5010c5b70633a54a2e0e9273ae4cd89
prerequisite-patch-id: f9eb03ca1f597bb99366adb81a201cfdc5f46538
prerequisite-patch-id: f08d8da3f1d4b72b27a1eb0f21e05839c0dfb2ef
prerequisite-patch-id: b6d1fe4754a2f54a6eb1f881bceacecc9b8aef6e
prerequisite-patch-id: e1164905fe6444b47d301aa73434e24395ee3692
prerequisite-patch-id: b98524d164fb5270fc83200b0005dfab8ab085d0
prerequisite-patch-id: 7de80453bca3ab7af13f2d5dd0af53b49ab775be
prerequisite-patch-id: cab73f2d83bb9caba9a9140e871ed804ad93012d
prerequisite-patch-id: 4ccc38815bc167042fd9480658ca977c5a018865
prerequisite-patch-id: d7549e7c36b461ef9816b2580d31a3b322189f6b
prerequisite-patch-id: f62a5eb77118b9f534e1829f9277f78159e0426a
prerequisite-patch-id: ef6cf9280b7ad0d6df39e3c30ac70594683b3237
prerequisite-patch-id: 097d27325d53feb894b26bb0c7e152fca314e7b9
prerequisite-patch-id: ca3a3605a04c9d3dcd7f577bf11b827735ae9fb2
prerequisite-patch-id: 1896423fac08929b2cbe94ab22f355e1a1674d91
prerequisite-patch-id: 0ed94130a16282e44a3b586ea7b5a2fbcbfd8e38
prerequisite-patch-id: 2246611dab54080318ec3b1359f07f5a6c37363c
prerequisite-patch-id: 18b914f2dd8e71ec7d128bcdb4ec7f78ec7760ee
prerequisite-patch-id: 1871f47d222aa5d1a85830e25be310e38288545c
prerequisite-patch-id: 57a66df1e4e0d2ac3bc0c4eab5f622fe557f7955
prerequisite-patch-id: 26647ddce2ad9cd5ea2b6e05b9b36b64e51d2b4e
prerequisite-patch-id: 2b1aef1d3e43f6a7a9dab2e1d3eb30e9df131684
prerequisite-patch-id: 7ef55b4a331871c3153e9043aadd0aa16d4aba5c
prerequisite-patch-id: d18e41b2d1d5dbc4362ece6b4c5816a86b933638
prerequisite-patch-id: b7a386f31313694e8d75fd7edeb10c62d9bf7650
prerequisite-patch-id: 261051e73501abfbfa106f44e0e0e4c74603f131
prerequisite-patch-id: 8498a2e4f746081e719d9a021b57bc80a5ac3817
prerequisite-patch-id: 3b6a398d6d2d5f84011eb48401bb453d9e9bb1a2
prerequisite-patch-id: 7e910758654df94dfbeeaee0429e0acdf5035edb
prerequisite-patch-id: 23115277def65ee8db1c7a0b0f697211253eeef2
prerequisite-patch-id: 6514c6f702538db3fe776443b03205e0e331d59b
prerequisite-patch-id: 4eeb4b19bb876c449f377c2fce9e8d5d2e3384bb
prerequisite-patch-id: f187aa49a1b20ca85d7556fee15f526c26650688
prerequisite-patch-id: 997a8549300388c11027e465c6781acd2fa799b9
prerequisite-patch-id: 9094fb34dcdb72d2d4d9cf7b9a71dbfbe85f47db
prerequisite-patch-id: 32231f11fcc72302bf4e2bddbd362b2f27928b65
prerequisite-patch-id: 2497ea23d9ebf51b71472136e1a74bfbd2594a3c
prerequisite-patch-id: 0cf170373dfeaab97e724610375091972b91b3b3
prerequisite-patch-id: 2a20ef3c132bd0259826e6d5b020df71ace360ec
prerequisite-patch-id: 6d3d248f710c8afaa68ac2648ea0133d90bca19a
prerequisite-patch-id: 8d13795b1a92c79ed5f1c3871e3a7b0ba17e34a1
prerequisite-patch-id: 80dc4103e79eff0a7ebe12169c7b36d098382552
prerequisite-patch-id: 17b2a915420e30817ee4b8b76fe69245c351adab
prerequisite-patch-id: e3b1a35f82d7a87f54fb049bc08649663d93e889
prerequisite-patch-id: 3192e8f3349ba989abfa1603d9df1ff8ddc72801
prerequisite-patch-id: 1d258467dc0bb5418885e6cba6eefa012ad3da09
prerequisite-patch-id: bc3a68e959b57b6dc814550f81d70369b3fdc5ab
prerequisite-patch-id: 1b477cffeb8eb881f8ef21cab7d9d0fcf41bc65c
prerequisite-patch-id: 21c5fd0bc10d681bb01c4e6b9c809efb46af0473
prerequisite-patch-id: d8cfb68a6653d82fc55d9577ba45face4abdffeb
prerequisite-patch-id: f95b2692beefcdb4c01e26a27ad61fc79e15130e
prerequisite-patch-id: b4486a6d6d3a870d8604a5b95ff217a7a25b787e
prerequisite-patch-id: 1fab4dfefa1608a5668c166bc0f83a5eb03f1f6d
prerequisite-patch-id: 7c768335c56ef9f5adfd59827475bd66fceaa608
prerequisite-patch-id: 226bf92946bc11d17c3fc46a5d63614e92a9ef9e
prerequisite-patch-id: 1ee2b49c3c8ad17e9b50c5e005e9c7ed9f37a0de
prerequisite-patch-id: 29cb1d6dd1a1815e72efe384b6779a0aecd30904
prerequisite-patch-id: f75afa353717cc8eda63b392c1f195bde1daff5e
prerequisite-patch-id: 0834d786bee7772b207590046df0c594bc39c9e3
prerequisite-patch-id: eec4e0f5694ea87625ae8cb483601d7dcd1518b3
prerequisite-patch-id: 6e467aa948af15cb7d5d848c6923c311fba01a19
prerequisite-patch-id: fb2e1540330d24599ad4dd426cb78f4db631af1c
prerequisite-patch-id: 76b11bb00d485a802efbef14aafd93387609470f
prerequisite-patch-id: a565b77909e10221b99afe597443ff71de11e1ba
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


