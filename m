Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38949606A337
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cxvv80tf
Received: by kanga.kvack.org (Postfix)
	id 505A16B05B8; Mon,  9 Nov 2026 07:05:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCD56B05B9; Mon,  9 Nov 2026 07:05:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A786B05BA; Mon,  9 Nov 2026 07:05:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 263206B05B8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:05:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFCF4120644
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:15 +0000 (UTC)
X-FDA: 85415450190.21.6BEF0AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2D6354000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cxvv80tf;
	spf=pass (imf12.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225914;
	b=xOr16i4AL2QYExjehy7ZtKCI4kuFfxZY5Zxt/g960DnhvkFntN1h50yI7EO43yUOYJFTD1
	4wJXjD2tUbhXmUzf43TxzC49s2lPUp07uHY6h0bpvyR0H8IKNVk3CW+AgAfnQGpFPx7lBA
	9gLoe01zwlfWr6kk+H25nwuq1fJflsE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cxvv80tf;
	spf=pass (imf12.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7QYMXonlT1X/OPGysSVGx2KIKbzgu61tqS/KtO5R6L4=;
	b=cSMLLLrEexqoNwLwMObH5C2gFSArKrq7q5jDZeNxsNY5S3WNpB/sRi3IBlgTX97eTquhkr
	12DDoZByasQHlKlqD4Xh9SNbEOPzvG5yJvAYfx3SWenfMDgMRJnE6SG4pVIMldbC/TgYm/
	4a+xPT5aa8jrJjKArF5NcFT6rtd8FQg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CE0D630F7;
	Mon,  9 Nov 2026 12:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8725E1F0089F;
	Mon,  9 Nov 2026 12:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794225912;
	bh=7QYMXonlT1X/OPGysSVGx2KIKbzgu61tqS/KtO5R6L4=;
	h=From:To:Cc:Subject:Date;
	b=cxvv80tf4aXmD9C43/MEHNe9zk/XOvqolhWIiXZdZMbWuItd64Qt+Eec5f3n8l3TH
	 bEeXEYYcf2FECsC4387/eB7cZ7Dzz5R8a4Y9NITxgFw57Fx4q2uUiCx0XlzoyIkFIe
	 e4OdrhnHbZHoyCSKGEcTrw7Dn41p6jBtM2nkI1URQFwSoTPAQpiDoR3y8bh7nl7ETf
	 FrVXkorB2YhV5Hk/fN7tPjhceB2XfaRA+04R4fYULh4TrbRlGfGhRTBDxzWqnxOy4B
	 lxEGLabfYbu7mcX5Pt+8TBuKYaf/YydINE9Tke532vWOT8D3B9rOVXXVa4YrzkL2Nw
	 zs9k3s1sFuN0w==
From: Jisheng Zhang <jszhang@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Tejun Heo <tj@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH v2 0/6] arm64: Fix instrumentation escapes from noinstr path
Date: Mon,  9 Nov 2026 19:44:53 +0800
Message-ID: <20261109114500.20298-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tspnfs56ssyh8jidannfgaoigaf6c3uz
X-Rspamd-Queue-Id: 2D6354000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794225914-943909
X-HE-Meta: U2FsdGVkX1+OKNGWTr2VSG1xtslcxs9cDQAr0dsy6tYqSYfjDnCZ+bHOOecEgtjYz7Gi8WQiDjwhcMSQL4g3W5z+aeU/mvItcK7/e3jq9o+jHa47jt9wmhgnO5hNYFt2VUqCXK05aXMindK2odU0+09WalPuucLL9o4A/5Ed0xwnO/SxBnaJpsWx1npDbjnv76oB400m7AQgsMrgrO2raiugXIVkikcxcPvscOhbmbBasuGzMaahzeK3wuIy5zkmdMm3KugSzWfyN0YSyPppIBqNy/U/a9zpoEzCrj/0pS5ZtAC7TN/p1st8qyxMkixBpNHb9+NMP2UV8TTtSwWOrb2rgL+da4IyRuYAH8mbRev0dfKKC8G3sY9AXoccwIdKMYidMqsVf1pZ21gmUNBvImbwFsuYBxPV+4fM+DXnJP/0ImWdNQuwvzWlH8gTb/z/j4ebn4vcpNdUNaSbsVmNYSjt3ZXGyrEwMd1nBFepklZcO0WhMY0J7XPliybu4gui/A5rPBscf0F60YB6m07EGislc1ConLlBGo/tTuFmZx5m/kSWTPk9xT61whcvcnlpu3DmHAKNDztzX9uU7hb4OqKGzI4PaQJFz3AWVFFeIkRbjFqwa5nbUBpmjyUhFSEvhGgUs1hJq4ttyTG1hqD2B7NQDWIqNu38qsmPbVTxRNac1R0sJMyasiqXsEoGh+39mc383p25ztp1Tb/gLlnclKpCIzG9MURK1z+nI0jsTYogTnNYlDr3Kk9NzGYts2wHx2zZ4WSJ2A9FAosTXusIiSLBEMxYpIY3L2i77GwaQvtdm6ENA4t1TJb3yCYkS8LQ9Ort232ChbFgpl+kjilZYfWjg2o5heVWOM2L8aEPqBYLYDI3gTmVerqYY6Uqkn7f1mBh8MPvScIFgjE/eVGznmMIm8pqliGgBeq6ZzsQgwJSefjLiNg1hXMj+3/tNSRzjUbkBNhDIZcmqgcooTt
 rrdMNcGw
 6Ra5jtu/H6u6XHCGrqHPJ2fa2Apl9mRv8mpoSBvbsZs2yv7y4kZlz+wMDNectS1wiUayubOZz0+hZC6UFmcf378Wu5iMkfZWyeN9FhpJCL2PSxM/DucwbtCTgppmTVaKqx4NHb0o+2FSrrzXShF+0yBBDQSdWvahGMnGdpmlCZ550ria+4mXE6PQ623XMSRMZp66JpGgZwXWceUAbo8SaQhjvDHpIDeqZauBXBchddUkaYriQJeosC1egGG9ClqIOFuLYaJ49xMbDdbZLLWWOFrrC2dYpd2sRZG2q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Code marked with noinstr can only safely call other noinstr or
__always_inline functions. When reading arm64 source code, I found
necessary noinstr markers is missing somewhere. So I asked AI to scan
the arm64, this series is the result.

Since v1:
  Mainly address sashiko review comments:
  - add always inline to per cpu helpers
  - use tif_test_bit() instead of test_thread_flag() in sme_enter_from_user_mode
    and sme_exit_to_user_mode
  - a new patch to mark kasan_hw_tags_enabled always inlined
  - a new patch to Disable branch profiling for architecture library code

Jisheng Zhang (6):
  arm64: percpu: Always inline helpers used by noinstr code
  arm64: entry: Always inline helpers used by non-instrumentable paths
  kasan: Always inline kasan_hw_tags_enabled()
  arm64: stacktrace: Always inline internal stack boundary helpers
  arm64: lib: Disable branch profiling for architecture library code
  arm64: alternatives: Make branch and ADRP offset helpers noinst

 arch/arm64/include/asm/cpufeature.h        |  8 +--
 arch/arm64/include/asm/entry-common.h      |  2 +-
 arch/arm64/include/asm/fpsimd.h            |  8 +--
 arch/arm64/include/asm/mte-kasan.h         |  4 +-
 arch/arm64/include/asm/mte.h               | 10 ++--
 arch/arm64/include/asm/percpu.h            | 18 +++----
 arch/arm64/include/asm/stacktrace.h        | 16 +++---
 arch/arm64/include/asm/stacktrace/common.h | 12 ++---
 arch/arm64/lib/Makefile                    |  4 ++
 arch/arm64/lib/insn.c                      | 57 ++++++++++++++--------
 include/linux/kasan-enabled.h              |  4 +-
 11 files changed, 82 insertions(+), 61 deletions(-)

-- 
2.55.0


