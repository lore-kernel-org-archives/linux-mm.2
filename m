Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B32606A330
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H2Odb1Wk
Received: by kanga.kvack.org (Postfix)
	id D8CF06B05B5; Sun, 15 Nov 2026 17:34:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64606B05B7; Sun, 15 Nov 2026 17:34:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB77E6B05B8; Sun, 15 Nov 2026 17:34:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 848366B05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:34:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0D421A083E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:34:49 +0000 (UTC)
X-FDA: 85438809498.11.3135C81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id EADDB40003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:34:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H2Odb1Wk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+alireza.asgari.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+alireza.asgari.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794782088;
	b=tOMz3D9O1zJgKU9b0UhXWdgtNc+nE4oIACgaOcd5eMAvQh1cmCvS0jBiXgYGR0FUPtQOhS
	JG/4zd7CmPHEH9HtxtsrEUGwi3lU1RdfRrblFm8dj/cOsIOI4ZDo9JwQw1JnPapD/p88to
	i7VNwltKl1ATbnPCxNrBYA5R9PzLawA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794782088;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23RmUgKwkzTjxTukTOuc5pfGxIXjdwf3dD8nTQxRrOU=;
	b=Ay5F7UtTq8EaDcLxhxZ5Oz9xqYjxPpjqNeNGhnMfB0zudRktjM/CR6Zo2Bxs16NvNoQLsL
	32+MiQ8a1YSqZt8QcVxK12wwFMhtv8PHjMpsDezffhncw8/tOauvVYOQBgG5KHuwGzi7xw
	/e47j3MNxxhBSxJT/4R/EacqpsmUCaw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H2Odb1Wk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+alireza.asgari.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+alireza.asgari.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 721B0623BF;
	Sun, 15 Nov 2026 22:34:47 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794782087;
	b=T8nxya5dtrJJCzoSA+tmnlG+NiNzCkec3CTboIHrsBRTj/t5Df6Z5wHH/d4G/bg5WKEd
	 DpGlhSRpjNCaiRLMmub9itmSLxN1EL0IRAirOGfLgaCivUNB58fowyvOC8fmkp2zd7bkO
	 LLM5TG8aYqIh+ty5t1DGLGNVzj40Qg9oay3Wz1sUsSyvJEQv+tlP4AjSg5IJrGMBTxw+0
	 lFa6MgTIVc0Cwp/afW/rv8t3K2SeAaentLU6NnZ48PcHaRbuJ/VdV/y/i9XqCGFZ8eTcf
	 yL7CNRXPTOsKkwLsOx7QkIQslf0scNXVjRoO2h70HBGdlmsqmOJp1fikHDRCZses3GA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794782087;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=23RmUgKwkzTjxTukTOuc5pfGxIXjdwf3dD8nTQxRrOU=;
	b=VRJBiqFeDsuy8veB1dSLYXarNMlYmOytfHuG+Ah5famFAtRn4ZuclAokXy8tDXU4WCsV
	 Z7XVJ71Ek7sOetB+yKbNI/CdTVHw0zyVzLJUlI9PhtHweX5PpYYvvej4XHMoeT51MVPED
	 9wOeRFFYRUK5VCAipuiB6wkdA00dhtER7T5XkrZRNNoLmZSpr7njR/y6Q4Ng6sIqkK1P7
	 WYb1VHqlzu1L8sta5ySBFEgd2FzcOcWAL5WfjoIAy6yx2vqBcH6WI34pU+uwIrO3dGufy
	 wXswXNoy4T88hCltDnNKLP3zM7YRsO9u+Zkm9Og6Spwf7qv2qaE7O1dElZZU/+Ui5LQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DA1821F000CB;
	Sun, 15 Nov 2026 22:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794782087;
	bh=23RmUgKwkzTjxTukTOuc5pfGxIXjdwf3dD8nTQxRrOU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=H2Odb1WkDoSKM1UxA1qcVX8uvxtmomGzb3zSTOtScGvVN3QWr3c9m+mgO8GnbGYFC
	 oBO2aDBIkefxZGKKFteqk7g08FsLdvREQDNLxPPpXFAx5vonZqQWW0ujBV4cvztqVb
	 A8nGAFruOyvIZ+4gF2a7E+v8qwy0oGA9KRMWSt8nfkRY7Xd62AX/AkN6WX67/ucwBa
	 d7EP05LckGiDxsh2x+tMjZTukKwVtGxKKzEMYre7Lz1MCB9xcxTb87bnCaD+mTQabR
	 62a3eV8l0FNmv/4hoJH8msvGgupdfnfB1YU7/gSTmPNNiEG/XjFFPFy5KtKJloQNFz
	 lFo3NgemCzd5w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A811C4A251;
	Sun, 15 Nov 2026 22:34:43 +0000 (UTC)
From: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Date: Sun, 15 Nov 2026 22:34:45 +0000
Subject: [PATCH RFC nf-next 5/9] memcg: test capacity reservation rollback
 and refunds
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261115-b4-nfqueue-memory-accounting-v1-5-b9cc30819997@asgari.net>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
To: netfilter-devel@vger.kernel.org, linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
 Chris Down <chris@chrisdown.name>, 
 Zhang Jiao <zhangjiao2@cmss.chinamobile.com>, Song Hu <husong@kylinos.cn>, 
 cgroups@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Alireza Asgari <alireza@asgari.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794782082; l=12013;
 i=alireza@asgari.net; s=alireza-kernel; h=from:subject:message-id;
 bh=JloqzugReTrQDTmQ8+3w3kkQBiN+qr4RbrFYTkj8puY=;
 b=gg11vMfGHX0ZXN6TpMvg36yRN9ncGpEk8plCsVJP9PFk5Y2as5paAhWF0bnq91G+PynzVjsEA
 Y1JGes7kSe5CdUilOWpBrOq7AGkkAT/+kmim7jw6bR3Seu7vVVS31XK
X-Developer-Key: i=alireza@asgari.net; a=ed25519;
 pk=wuQ0/M69FqoVnrCMUJ13EQCwrCwVjCrtz75k15vW8tw=
X-Endpoint-Received: by B4 Relay for alireza@asgari.net/alireza-kernel with
 auth_id=1055
X-Original-From: Alireza Asgari <alireza@asgari.net>
Reply-To: alireza@asgari.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EADDB40003
X-Rspamd-Server: rspam12
X-Stat-Signature: 7dit199jdbikxiynifxbq1gz1w15b8oo
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794782087-94485
X-HE-Meta: U2FsdGVkX19/uWBdKFxffTenPDq5UakPyoEBulf95BaKlemUSFgfqTj8jS4SE1JpkYD7mrwm0rvEGvmyQcDObVimUBek+7FWZWeMQ5KRCs4drgnUcd412f6enlzgLdGuwIzDa413u7SR0IvNnhwFImZFeBGOYi1+CLa4bLkgoNgY9m/zQN9m2uNSRpER3EhPBPSH/fUvfVxQFxzRaL0BNg6hkLcLD0vy7E8lehWMJFWyOKEvE5mBSuQ2yK9unjKQUo9LKD6fUXBsfNIVvZAOKuOEmPb4Z/FBNFKoyl60Cd5d+k7XHcepSGre7MhumPpdooufoaJ0EBJH87lzz9cJzqz149rLAU1lS5PDkVRxq4TvirBJ/vlTNlp7gSXfN2B/I+uZU5+hFk4tUt0qNaHYy24v8zb4JcVRA35WFAim7Ga5TwLVqD+5xKzC1eIoyiD1Q7TIRCToLkBEl34meX7TKcgFYA6ivcpZalm9mOGApRPaIJYpc1O0zbFLIctx4xl/D35VOQk+CoZoqyyml0kJha/b5mUHhqQVSiswtvLe0k7OLHA39jp7HlTOzDq5+eOn2Sp1fsax2SCDmAMbfYXCVFLfIWwpM68XnF0ZfPKf2LdoZydE/JlwofJEMlTkZcKGtzwQo+uoIPTrLt8h45wf3EBPpYuCWQs6Ik3X15gq9qIMn9HDKb6N5ibat2HUIDb9M/u6LqMrJ6giweArWL7eHJ8vTQ/QfnsUij1dwJm4o8t1Q1W1s4BNXqilEnKtVazLKZU0K8AgsV71FZ5l8TTNQRVkwE3GUrZiLNiXlIFcpBX+jGWDRT/KCBnRre8s8T4NbVVLBlzF+m1gDe4A2F3JihqlNjLppZkLt0nSgtLj0hPX+opRQEXlZLdnzVbCSY11YzKfdOMMKGpo6k3UxZd0tM46ftZf/AmAn0cYsoFl+X3Npo2xzLddUTohuCiT6StZNWqVNIG011DXaTJMi4k
 0yphzZD5
 8i+uSemCpQFiuLI3JvpZNsFadN8yI5+liIbtLFqwVH0MvPPOVgkzpIsIpT4ZreqLztK87ilvqM29+VOu1eLL78ZTDFk9yFPLPpeQd5O/N0d7W/2VlwzZS8fb6pPrj9urve8+Qhp/4Q0Ty1W0gFM0nwU1+5pFsTHoiEsi8KaS21odFnWvr7bNvOZoC2u+JwY/UAT4VTDlrYNNLyU9ZRBq5OHkdKzaK2ZuZ3liDEVyh1sWo6c2N4RoH1qcdlQwQ8PfKSU+jsFu/Xe17YZlE0zRUmbSlptpfeR/mJCzIOxWuymUBk8jwq7nLnZ5cwFj+3HsPBFi+Tn0OHapEibMwEavqn+BskohmNaton6+67ow/uVnURV2aDySRWwh+R5Y2ZC+D/cLnDDgIRTICWUy6iUJ6gyT6vN/fr8717h1mE6t+/d7ba8jOY6x98JqnFw80bt5Ms47WOyyQ0zdMoL8J+gDb0imI3vjK8m/04cr+eV556JImPueG+0dPJg/mt0NP3TQWKDb07XXPZlQ6W3Bbhlt2BcZQLPTvqh0XV/UyuiM5b7Qv94GrkDiYGOgz6xV+JDnZxi87CFH74/oHex2IeRfRWls7dOxKeSaGQdRA5REvh2WlhkABsXIWdFqwxvgSo9bJMnjjVi/xcvgLFste2IX1DxVugcKrEgTTvcXR+7eZ2wdOU7yvKHYezFvDk+0pUx0yNlVY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alireza Asgari <alireza@asgari.net>

Add reservation-specific KUnit coverage for partial-growth rollback,
reparented-root growth, range and architecture checks, and root refunds.

Transaction cases inject charge results through KUnit static stubs.
The root-refund case uses temporary real root page-counter charges while
other CPUs are stopped, and restores the counters even if the expected
refund is absent. It models charges inherited after reparenting; the
network selftest separately exercises real cgroup removal.

Keep these tests separate from the generic memory.high suite and make
all redirection conditional on the reservation KUnit option.

Signed-off-by: Alireza Asgari <alireza@asgari.net>
---
 mm/Kconfig                       |  11 ++
 mm/memcontrol.c                  |  16 +++
 mm/memcontrol_reservation_test.c | 232 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 259 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index dd763d3d0e36..39db388f193f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1541,6 +1541,17 @@ config MEMCG_HIGH_KUNIT_TEST
 	  fixed-point rounding and arithmetic bounds on 32-bit and 64-bit
 	  kernels. Say N unless developing memory cgroup high limit handling.
 
+config MEMCG_RESERVATION_KUNIT_TEST
+	bool "Memory cgroup capacity reservation tests" if !KUNIT_ALL_TESTS
+	depends on MEMCG && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  Test capacity reservation transactions, including partial growth
+	  failure, architecture support, and uncharged growth after reparenting
+	  to root. Transaction tests inject charge results. The root refund test
+	  checks real counters with a temporary eight-page charge while other
+	  CPUs are stopped. Say N unless developing this interface.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0227d9b411f5..d49ce5a92c1f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -73,6 +73,10 @@
 
 #include <linux/uaccess.h>
 
+#if IS_ENABLED(CONFIG_MEMCG_RESERVATION_KUNIT_TEST)
+#include <kunit/static_stub.h>
+#endif
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/memcg.h>
 #undef CREATE_TRACE_POINTS
@@ -3264,6 +3268,10 @@ static int mem_cgroup_reservation_charge(struct obj_cgroup *objcg,
 	struct mem_cgroup *memcg;
 	int ret = 0;
 
+#if IS_ENABLED(CONFIG_MEMCG_RESERVATION_KUNIT_TEST)
+	KUNIT_STATIC_STUB_REDIRECT(mem_cgroup_reservation_charge, objcg, pages,
+				   charged);
+#endif
 	memcg = get_mem_cgroup_from_objcg(objcg);
 	*charged = false;
 	/* Reparenting to root removes the limit, not previously held charges. */
@@ -3291,6 +3299,10 @@ static void mem_cgroup_reservation_uncharge_batch(struct mem_cgroup *memcg,
 
 static void mem_cgroup_reservation_uncharge(struct obj_cgroup *objcg, u64 pages)
 {
+#if IS_ENABLED(CONFIG_MEMCG_RESERVATION_KUNIT_TEST)
+	KUNIT_STATIC_STUB_REDIRECT(mem_cgroup_reservation_uncharge, objcg,
+				   pages);
+#endif
 	while (pages) {
 		unsigned int batch = min_t(u64, pages, MEMCG_RESERVATION_BATCH);
 		struct mem_cgroup *memcg;
@@ -6699,3 +6711,7 @@ void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
 #if IS_ENABLED(CONFIG_MEMCG_HIGH_KUNIT_TEST)
 #include "memcontrol_high_test.c"
 #endif
+
+#if IS_ENABLED(CONFIG_MEMCG_RESERVATION_KUNIT_TEST)
+#include "memcontrol_reservation_test.c"
+#endif
diff --git a/mm/memcontrol_reservation_test.c b/mm/memcontrol_reservation_test.c
new file mode 100644
index 000000000000..5ce4f05431b3
--- /dev/null
+++ b/mm/memcontrol_reservation_test.c
@@ -0,0 +1,232 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <kunit/test.h>
+#include <linux/stop_machine.h>
+
+struct memcg_reservation_test {
+	struct obj_cgroup owner;
+	struct mem_cgroup_reservation res;
+	u64 refunds;
+	unsigned int calls;
+	unsigned int fail_call;
+	bool uncharged;
+};
+
+static int memcg_reservation_test_charge(struct obj_cgroup *objcg,
+					 unsigned int pages, bool *charged)
+{
+	struct memcg_reservation_test *ctx = kunit_get_current_test()->priv;
+
+	*charged = !ctx->uncharged;
+	if (++ctx->calls == ctx->fail_call)
+		return -ENOMEM;
+	return 0;
+}
+
+static void memcg_reservation_test_uncharge(struct obj_cgroup *objcg, u64 pages)
+{
+	struct memcg_reservation_test *ctx = kunit_get_current_test()->priv;
+
+	ctx->refunds += pages;
+}
+
+static int memcg_reservation_test_init(struct kunit *test)
+{
+	struct memcg_reservation_test *ctx;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	/* Transaction cases stub accounting; the root refund case calls the batch. */
+	ctx->owner.is_root = true;
+	ctx->res.objcg = &ctx->owner;
+	test->priv = ctx;
+	kunit_activate_static_stub(test, mem_cgroup_reservation_charge,
+				   memcg_reservation_test_charge);
+	kunit_activate_static_stub(test, mem_cgroup_reservation_uncharge,
+				   memcg_reservation_test_uncharge);
+	return 0;
+}
+
+static void memcg_reservation_test_rollback(struct kunit *test)
+{
+	struct memcg_reservation_test *ctx = test->priv;
+	u64 original = 7;
+
+	if (!IS_ENABLED(CONFIG_64BIT)) {
+		kunit_skip(test,
+			   "Charged reservations require 64-bit counters");
+		return;
+	}
+	KUNIT_ASSERT_EQ(test,
+			mem_cgroup_reservation_resize(&ctx->res, original), 0);
+	ctx->calls = 0;
+	ctx->fail_call = 2;
+	KUNIT_EXPECT_EQ(test,
+			mem_cgroup_reservation_resize(
+				&ctx->res,
+				original + MEMCG_RESERVATION_BATCH + 1),
+			-ENOMEM);
+	KUNIT_EXPECT_EQ(test, ctx->res.pages, original);
+	KUNIT_EXPECT_EQ(test, ctx->res.charged_pages, original);
+	KUNIT_EXPECT_EQ(test, ctx->refunds, (u64)MEMCG_RESERVATION_BATCH);
+	KUNIT_EXPECT_EQ(test, ctx->calls, 2U);
+	mem_cgroup_reservation_destroy(&ctx->res);
+	KUNIT_EXPECT_EQ(test, ctx->refunds, MEMCG_RESERVATION_BATCH + original);
+	KUNIT_EXPECT_PTR_EQ(test, ctx->res.objcg, NULL);
+}
+
+static void memcg_reservation_test_root_growth(struct kunit *test)
+{
+	struct memcg_reservation_test *ctx = test->priv;
+
+	if (!IS_ENABLED(CONFIG_64BIT)) {
+		kunit_skip(test,
+			   "Charged reservations require 64-bit counters");
+		return;
+	}
+	KUNIT_ASSERT_EQ(test, mem_cgroup_reservation_resize(&ctx->res, 8), 0);
+	/* Simulate the charge helper observing reparenting to root. */
+	ctx->uncharged = true;
+	KUNIT_ASSERT_EQ(test, mem_cgroup_reservation_resize(&ctx->res, 16), 0);
+	KUNIT_EXPECT_EQ(test, ctx->res.charged_pages, 8ULL);
+	KUNIT_ASSERT_EQ(test, mem_cgroup_reservation_resize(&ctx->res, 10), 0);
+	KUNIT_EXPECT_EQ(test, ctx->refunds, 0ULL);
+	KUNIT_ASSERT_EQ(test, mem_cgroup_reservation_resize(&ctx->res, 3), 0);
+	KUNIT_EXPECT_EQ(test, ctx->res.charged_pages, 3ULL);
+	KUNIT_EXPECT_EQ(test, ctx->refunds, 5ULL);
+	mem_cgroup_reservation_destroy(&ctx->res);
+	KUNIT_EXPECT_EQ(test, ctx->refunds, 8ULL);
+	KUNIT_EXPECT_EQ(test, ctx->res.pages, 0ULL);
+	KUNIT_EXPECT_EQ(test, ctx->res.charged_pages, 0ULL);
+}
+
+static void memcg_reservation_test_range(struct kunit *test)
+{
+	struct memcg_reservation_test *ctx = test->priv;
+
+	KUNIT_EXPECT_EQ(test,
+			mem_cgroup_reservation_resize(
+				&ctx->res, (u64)PAGE_COUNTER_MAX + 1),
+			-E2BIG);
+	KUNIT_EXPECT_EQ(test, ctx->calls, 0U);
+	KUNIT_EXPECT_EQ(test, ctx->res.pages, 0ULL);
+	mem_cgroup_reservation_destroy(&ctx->res);
+	/* Disabled/root ownership still records the logical reservation. */
+	KUNIT_EXPECT_EQ(test, mem_cgroup_reservation_resize(&ctx->res, 9), 0);
+	KUNIT_EXPECT_EQ(test, ctx->res.pages, 9ULL);
+	KUNIT_EXPECT_EQ(test, ctx->res.charged_pages, 0ULL);
+	mem_cgroup_reservation_destroy(&ctx->res);
+}
+
+static void memcg_reservation_test_arch_support(struct kunit *test)
+{
+	struct memcg_reservation_test *ctx = test->priv;
+	bool supported = IS_ENABLED(CONFIG_64BIT);
+
+	KUNIT_ASSERT_EQ(test, mem_cgroup_reservation_resize(&ctx->res, 0), 0);
+	KUNIT_EXPECT_EQ(test, ctx->calls, 0U);
+	KUNIT_EXPECT_EQ(test, mem_cgroup_reservation_resize(&ctx->res, 9),
+			supported ? 0 : -EOPNOTSUPP);
+	KUNIT_EXPECT_EQ(test, ctx->calls, supported ? 1U : 0U);
+	KUNIT_EXPECT_EQ(test, ctx->res.pages, supported ? 9ULL : 0ULL);
+	KUNIT_EXPECT_EQ(test, ctx->res.charged_pages, supported ? 9ULL : 0ULL);
+	KUNIT_EXPECT_EQ(test, ctx->refunds, 0ULL);
+	mem_cgroup_reservation_destroy(&ctx->res);
+	KUNIT_EXPECT_EQ(test, ctx->refunds, supported ? 9ULL : 0ULL);
+	KUNIT_EXPECT_PTR_EQ(test, ctx->res.objcg, NULL);
+
+	/* An uncharged reservation remains usable on either architecture. */
+	KUNIT_ASSERT_EQ(test, mem_cgroup_reservation_resize(&ctx->res, 9), 0);
+	KUNIT_EXPECT_EQ(test, ctx->res.pages, 9ULL);
+	KUNIT_EXPECT_EQ(test, ctx->res.charged_pages, 0ULL);
+	KUNIT_EXPECT_EQ(test, ctx->calls, supported ? 1U : 0U);
+	mem_cgroup_reservation_destroy(&ctx->res);
+	KUNIT_EXPECT_EQ(test, ctx->refunds, supported ? 9ULL : 0ULL);
+}
+
+struct memcg_reservation_root_refund {
+	unsigned long memory_before, memory_shrunk, memory_after;
+	unsigned long memsw_before, memsw_shrunk, memsw_after;
+	bool memsw;
+};
+
+static void memcg_reservation_test_restore_counter(struct page_counter *counter,
+						   unsigned long before)
+{
+	unsigned long after = page_counter_read(counter);
+
+	if (after > before)
+		page_counter_uncharge(counter, after - before);
+	else if (after < before)
+		page_counter_charge(counter, before - after);
+}
+
+static int memcg_reservation_test_root_refund_stopped(void *data)
+{
+	struct memcg_reservation_root_refund *result = data;
+	struct mem_cgroup *memcg = root_mem_cgroup;
+
+	/* Model charged capacity inherited from a removed child. */
+	result->memory_before = page_counter_read(&memcg->memory);
+	result->memsw_before = page_counter_read(&memcg->memsw);
+	page_counter_charge(&memcg->memory, 8);
+	if (result->memsw)
+		page_counter_charge(&memcg->memsw, 8);
+	account_kmem_nmi_safe(memcg, 8);
+	memcg1_account_kmem(memcg, 8);
+
+	mem_cgroup_reservation_uncharge_batch(memcg, 3);
+	result->memory_shrunk = page_counter_read(&memcg->memory);
+	result->memsw_shrunk = page_counter_read(&memcg->memsw);
+	mem_cgroup_reservation_uncharge_batch(memcg, 5);
+	result->memory_after = page_counter_read(&memcg->memory);
+	result->memsw_after = page_counter_read(&memcg->memsw);
+
+	/* Leave no counter imbalance behind if the refund regression returns. */
+	memcg_reservation_test_restore_counter(&memcg->memory,
+					       result->memory_before);
+	if (result->memsw)
+		memcg_reservation_test_restore_counter(&memcg->memsw,
+						       result->memsw_before);
+	return 0;
+}
+
+static void memcg_reservation_test_root_refund(struct kunit *test)
+{
+	struct memcg_reservation_root_refund result = {
+		.memsw = do_memsw_account(),
+	};
+
+	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled()) {
+		kunit_skip(test, "Memory cgroup accounting is disabled");
+		return;
+	}
+	/* Exclude background charges while checking the actual root counters. */
+	KUNIT_ASSERT_EQ(test,
+			stop_machine(memcg_reservation_test_root_refund_stopped,
+				     &result, NULL),
+			0);
+	KUNIT_EXPECT_EQ(test, result.memory_shrunk, result.memory_before + 5);
+	KUNIT_EXPECT_EQ(test, result.memory_after, result.memory_before);
+	KUNIT_EXPECT_EQ(test, result.memsw_shrunk,
+			result.memsw_before + (result.memsw ? 5 : 0));
+	KUNIT_EXPECT_EQ(test, result.memsw_after, result.memsw_before);
+}
+
+static struct kunit_case memcg_reservation_test_cases[] = {
+	KUNIT_CASE(memcg_reservation_test_rollback),
+	KUNIT_CASE(memcg_reservation_test_root_growth),
+	KUNIT_CASE(memcg_reservation_test_range),
+	KUNIT_CASE(memcg_reservation_test_arch_support),
+	KUNIT_CASE(memcg_reservation_test_root_refund),
+	{}
+};
+
+static struct kunit_suite memcg_reservation_test_suite = {
+	.name = "memcg_reservation",
+	.init = memcg_reservation_test_init,
+	.test_cases = memcg_reservation_test_cases,
+};
+
+kunit_test_suite(memcg_reservation_test_suite);

-- 
2.34.1



