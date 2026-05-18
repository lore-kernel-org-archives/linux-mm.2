Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 607BACD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743536B0098; Mon, 18 May 2026 04:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A61F6B0099; Mon, 18 May 2026 04:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5464E6B009B; Mon, 18 May 2026 04:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 451A26B0098
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:50:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09E2E1614D1
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:50:24 +0000 (UTC)
X-FDA: 84779919210.02.B86BBA8
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf05.hostedemail.com (Postfix) with ESMTP id F02A0100003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:50:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Vbl42/ll";
	spf=pass (imf05.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779094223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JfppSwEbo8CVHsJ/3tFLMi3O9oZ5mHSNY9AbWVhXA+M=;
	b=M7GXMQD0s/WXl0UNKlYIqVsQBt99pzPvdvcj19gbv53mGPIVH0jElTcHeVWgCmwtBR1eMS
	vQgjVxfJijtbm/MtHfKFk21bfa0RG8v5tE0XoQWX60SYjA9TGwCifY/htyn4yYFaZcXySU
	V9lvjgg1d5NxU0EFLux8CMtP7DR8uhU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Vbl42/ll";
	spf=pass (imf05.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779094223; a=rsa-sha256;
	cv=none;
	b=OYRW5BZOfNUtDSCkQUpcPzrYjmEsI5Tw/fFqhB204pMylXQcqUgdgiOTdgSPX01hDwEVw/
	SBN9ImYhyKKrUInyJg1eIjd6w6lCItnfSWxhiGptx0uC+3be39B8sW0s9glu3i2dBA4MSQ
	NZpOtywkctaM2H0HFbHj0Lgl/00ODbg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779094220; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=JfppSwEbo8CVHsJ/3tFLMi3O9oZ5mHSNY9AbWVhXA+M=;
	b=Vbl42/llSQ2EUXEwsMBx/H/utodf96qMtOvziDNl7WLhnVPLCMmDu5vUykNzMmeka77AphVz+ILyhr5AqjYLxuqJ/dhvt1tF7k0VYiJ4PeGV0PNs/z5L9b5YRBdYSzwzIqYOWBKNWQiT+ZYy7yvAlre7hsVG4xvVWFFFixeH7cE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X3647Nb_1779094217;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X3647Nb_1779094217 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 16:50:19 +0800
From: Ruidong Tian <tianruidong@linux.alibaba.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	rafael@kernel.org,
	tony.luck@intel.com,
	guohanjun@huawei.com,
	mchehab@kernel.org,
	xueshuai@linux.alibaba.com,
	tongtiangen@huawei.com,
	james.morse@arm.com,
	robin.murphy@arm.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	tianruidong@linux.alibaba.com
Subject: [PATCH v14 6/8] lib/test: memcpy_kunit: add copy_page() and copy_mc_page() tests
Date: Mon, 18 May 2026 16:49:50 +0800
Message-ID: <20260518084956.2538442-7-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
References: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F02A0100003
X-Rspam-User: 
X-Stat-Signature: mr4764stg3reej51ke51eyegsxsq8ho6
X-HE-Tag: 1779094222-964635
X-HE-Meta: U2FsdGVkX1+5z0sPmHHu3dnEj3lrANoXjUL+fHJcmcbM30nYOaRdA2KzHDY53iblCXB+oOUgdjqH/WfAWRNZTdW6OMP7Wvma16Cw6FeGpc32PjDmDcblktKOpD7FWhypvx8+ssh0EO+RtF8LijhhuTe3uSRAfYLsjF7gyB3O1ApfRngXZa3jzHVjSG7Dz8Hg10UmrAlXGPNP8bIjHnqzhkEwjzUdxpQ96itHsd9zD9yWFnc+gy84ZehbuNcuxMJeKBuOSFR1q0MA6Qcf5MWvGTeXBlu5FE+aZ3wseT/L6OUlgnvRg+0kt71w4bTQ06GlnJK1hm4lHa99TEbH2/+tEZaY4y36lWrpoGuW2pDwCyvkvVL7PPQrwCb1QCKOFbrMNhW5ba9ftb9ENTPdp/1AJmaE5HWrnt1RG+IkU7M49RLFeWFcnruMTmZTyJVT2ev9zpzR54d1lFD3OmeMbEU5gjV3bl7Flfsch/L4/R2hQbaxO03qMOAagphbVrCNP4z6G+rr33CudzRcgjyYQ7uEbCDlWKx2dUKFwcLHOPSbNjaW3uMV8R6rhzh79AMp7y9SLydwnPz8d7EhhM5H1uLh16nlLJsIH73QmX6fit+3EAMD/fvkOKmyxmKwpQcYqYCUdPq8hPB/TGqIEMn8dAXDJUrO9H9LAipbQg+pHnWA7Ov6Xpi3H23cazm5fdeV5i02t9zgZu0DuLGZI8Nx54IyqsTmrtSEksitBYjbcmliByrSON4czDDzsjGgAJEsDFbCgrjKZF72/W7yuh7vHv6UzC+EJwFwcynQ2jhpIOaFTbJWtCc2eU9LZYRMK2NczNibMxor1t8H36eADV6n+oJJhfz3QcVtmAtJULthvHa4sHXd1jcclBZfWrbX3P6dc4eh8NuEgnL1CyuwlaS/UqDA1656iaFqQWMi02m42iJYhihmFEZySavATpggJ4PxlE0nIeN77MFmrUzK+ifKwyt
 R+GShHCU
 x7sm5pACxfz6Kfi9wwcXno0deFl7ZJLZkKLjPJpI0SfHYrf1dv8Z5lbv2ebgEninhtCyCi+es6u/cS8Gp2i4cAtr8w46BeGky4/BMJlcjjtJKbgTwTJ4tPRqhELIzVUk8++MsQYg6I1GCPWv3mhJgpNmYQ2eNoY9ap9suALvxPQvhhVHW3xw2DVBBlnkDEG4rrCW0cg4M77825N5g3g32AY2gbbGMHX5NrDPVbcA5wItZaKpkL1ZD/tjukdxplNT9xTJsWk3w1pyVyGluPtbQfNP3mR2COXJyf6E2NB6w9f6IYATmyHmMAgw06pxrKJ+swrrQ6qYRyXeiBQf0lnmW3bPNfRolbnWnbN31yxXEog1VzH9QSRGrdGX/jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add KUnit tests for copy_page() and copy_mc_page(), modeled after
the existing memcpy_test() style: a static page-aligned src and a
two-page dst, filled with random bytes plus non-zero edges, then
verify byte-for-byte equality and that the adjacent page is
untouched. The copy_mc_page() case additionally checks the return
value is 0 on clean memory and is gated on CONFIG_ARCH_HAS_COPY_MC.

Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
---
 lib/tests/memcpy_kunit.c | 67 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/lib/tests/memcpy_kunit.c b/lib/tests/memcpy_kunit.c
index d36933554e46..85df53ccfb0c 100644
--- a/lib/tests/memcpy_kunit.c
+++ b/lib/tests/memcpy_kunit.c
@@ -493,6 +493,67 @@ static void memmove_overlap_test(struct kunit *test)
 	}
 }
 
+/* --- Page-sized copy tests --- */
+
+static u8 page_src[PAGE_SIZE] __aligned(PAGE_SIZE);
+static u8 page_dst[PAGE_SIZE * 2] __aligned(PAGE_SIZE);
+static const u8 page_zero[PAGE_SIZE] __aligned(PAGE_SIZE);
+
+static void init_page(struct kunit *test)
+{
+	/* Get many bit patterns. */
+	get_random_bytes(page_src, PAGE_SIZE);
+
+	/* Make sure we have non-zero edges. */
+	set_random_nonzero(test, &page_src[0]);
+	set_random_nonzero(test, &page_src[PAGE_SIZE - 1]);
+
+	/* Explicitly zero the entire destination. */
+	memset(page_dst, 0, ARRAY_SIZE(page_dst));
+}
+
+static void copy_page_test(struct kunit *test)
+{
+	init_page(test);
+
+	/* Copy. */
+	copy_page(page_dst, page_src);
+
+	/* Verify byte-for-byte exact. */
+	KUNIT_ASSERT_EQ_MSG(test,
+		memcmp(page_dst, page_src, PAGE_SIZE), 0,
+		"copy_page content mismatch with random data");
+
+	/* Verify no overflow into second page. */
+	KUNIT_ASSERT_EQ_MSG(test,
+		memcmp(page_dst + PAGE_SIZE, page_zero, PAGE_SIZE), 0,
+		"copy_page overflow into adjacent page");
+}
+
+#ifdef CONFIG_ARCH_HAS_COPY_MC
+static void copy_mc_page_test(struct kunit *test)
+{
+	int ret;
+
+	init_page(test);
+
+	/* Copy and check return value. */
+	ret = copy_mc_page(page_dst, page_src);
+	KUNIT_ASSERT_EQ_MSG(test, ret, 0,
+		"copy_mc_page returned %d on clean memory", ret);
+
+	/* Verify byte-for-byte exact. */
+	KUNIT_ASSERT_EQ_MSG(test,
+		memcmp(page_dst, page_src, PAGE_SIZE), 0,
+		"copy_mc_page content mismatch with random data");
+
+	/* Verify no overflow into second page. */
+	KUNIT_ASSERT_EQ_MSG(test,
+		memcmp(page_dst + PAGE_SIZE, page_zero, PAGE_SIZE), 0,
+		"copy_mc_page overflow into adjacent page");
+}
+#endif /* CONFIG_ARCH_HAS_COPY_MC */
+
 static struct kunit_case memcpy_test_cases[] = {
 	KUNIT_CASE(memset_test),
 	KUNIT_CASE(memcpy_test),
@@ -500,6 +561,10 @@ static struct kunit_case memcpy_test_cases[] = {
 	KUNIT_CASE_SLOW(memmove_test),
 	KUNIT_CASE_SLOW(memmove_large_test),
 	KUNIT_CASE_SLOW(memmove_overlap_test),
+	KUNIT_CASE(copy_page_test),
+#ifdef CONFIG_ARCH_HAS_COPY_MC
+	KUNIT_CASE(copy_mc_page_test),
+#endif
 	{}
 };
 
@@ -510,5 +575,5 @@ static struct kunit_suite memcpy_test_suite = {
 
 kunit_test_suite(memcpy_test_suite);
 
-MODULE_DESCRIPTION("test cases for memcpy(), memmove(), and memset()");
+MODULE_DESCRIPTION("test cases for memcpy(), memmove(), memset() and copy_page()");
 MODULE_LICENSE("GPL");
-- 
2.39.3


