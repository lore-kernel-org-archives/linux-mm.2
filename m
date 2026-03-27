Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9691A10A1E63
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A0636B00C7; Thu, 26 Mar 2026 22:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077DF6B00C9; Thu, 26 Mar 2026 22:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6F76B00CA; Thu, 26 Mar 2026 22:16:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE0346B00C7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:16:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46C39C4262
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:16:16 +0000 (UTC)
X-FDA: 84590228352.18.5D2AE2F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9993F20004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:16:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YkBnJlAA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBHgpp/Hlt3gblMxOihtIUK/6fHGYOfso38xhE/8i5Y=;
	b=jaymo3MeL3GcZs9hp4WNwBebvwWjrCTleV6+AOR1QUSdEHITSRJa1Yli3jzQ/4nKI40v9J
	LLcOSR4ELB5OtjpHEFVwUhnt88WwLK0m/HNnjy1oKHvfg0j2e82aIVBtIJVMkJ52N1QrSx
	yZDRsvASq5HbMKeeGhoynQJWAHdYKps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577774; a=rsa-sha256;
	cv=none;
	b=U041qgPa2VoRDDc09F8rUVc6wiiDsX5CMON3DFB9PSnxEP4ibgfR9xVdSkvAjGwt71VT7O
	bdUawo68hhZC6dukzrCBdUEdnpUwBXKQsAlObh9ICnwca8XfD+puHE8qWeVRvXGl6oqaKh
	bh2yIvG74IiTQNedsemzxFNTrgUXZiE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YkBnJlAA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KBHgpp/Hlt3gblMxOihtIUK/6fHGYOfso38xhE/8i5Y=;
	b=YkBnJlAAFSpKbHZ97+87mwwuiOpaKGfMki0IODGcWo+ltRqHD5dxWBr38RHva/Za8up5uN
	sjKP0IWJ4LKydgafIE8LafBBavHbtcDNVR0+2IRtgtbgOEykPv1ek68+Pcb9SQy5kozeBm
	TXn8jzFa4saniUkUmgk+kYIpggBjy8U=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 21/24] selftests/mm: add partial_mprotect test for change_pmd_range
Date: Thu, 26 Mar 2026 19:09:03 -0700
Message-ID: <20260327021403.214713-22-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9993F20004
X-Stat-Signature: pg335748ey4ppyaygiqoyxgm5q54o89f
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774577774-96277
X-HE-Meta: U2FsdGVkX192722NBxWABOqhNpvXoecQDx2uUVnw7fYZCLMbqYA66aA/+o50TKTPCvPqDOrTCEvyluusLUMA8gflcUfxdiAw5j7JEwb9+06ThiNqi+Gi9YFNKuhfQIJ5534ZIx8c5jZXi9A9m1FX8DX+thCdpvddNpRrImCXB0pX62nFfhU2v2HhDR4emFY05cRlaSzY6OchSAkNcR1nBE1HTl+zUXdvAmke1+9y/YrzhCeTqbKsBRWxhVhQ2ASrZlhn4qfjJIuhQSKNaluCwknneWk/BHD1Tz3LaKaATbUXrKbkNORpKixOVwiCFlgMh/s5S4XjYXv1oh6mL1caclzFGdGs5Mc5Hr/N5xn5xwtq/CvutzYa6gxpd0TGG9TVAUIpZmsxyZQ+osysyXqkapvc3G7BvCN62N4AJq2Tyy7z8tPXtzE8F62RmsAFW6LwKEXdkLGT82k2fkLPN9lQZf+n3FiSOLyD2ag59r12834gOqjG9og+xOV01nIm/1jhpcB4t5c1V0jPXnCNr9XpUO1SqRTt31he39784ttkl4CMobiPpAfvRcI0q7N1FTQdTzyOWd3YcQ/3GFPlKktZSp5IOsO4XqlNWrHPVhPeeuVkX5tHja6mFhaHnFm3/6pZ5BIXMkcWMlfwtWOK8X9NB62xG2j7Rmv8J1tDS/tmp21hyMhFxv56UkFlDMw9B1SPTrgHJt6R/iNZ8LOpmWvdNfhdSdUozloJmyhwddDXzISgba1vSKZnEtfHQ7YizV4a5K+TFx4vNS11b9dYE/Ojq47OEAE8rfX+YTVCO3J7kkPjPeVuu74TsdhqRSO+Ygke5u2/9WAG7Hn/wTY/pDuv1Li8aplYvO++qmMiN/SaRrFuMdr/d0NOaVO59t/42KSgrEIXDWBgq3Cq8gHnE+Jw/vl4qaGCxroW9COnbbdnCuOVyxZi8iJVvI7hB9VXoMWZG5/zUMQfoWmauxx7YZE
 J57F0oXW
 mYkR47fqg9wlFn8p86SJteeVojKo3bO6Wual0bXTFUfM60hzZT5ItKFS4F1jbZ+2YJgxkINJUUO9Bih/xznU6U4lTJmvo1P2p5FrxAZJZQAjEdGyQaDRKEoEN9UX+qHbM/rQRfwdhN861tFJ8YPzJaW2ReBk/lGcpspxb9568apCMutr2SwQD4KwsYSKVhTwj60ZERBW2+7DFwII3aZzo0EcheDLjmVLc7+eaqm0DMxFPh72p/dB1pJgZDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test for partial mprotect on THP which exercises change_pmd_range().
This verifies that partial mprotect correctly splits the PMD, applies
protection only to the requested portion, and leaves the rest of the
mapping writable.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 .../testing/selftests/mm/thp_pmd_split_test.c | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/mm/thp_pmd_split_test.c b/tools/testing/selftests/mm/thp_pmd_split_test.c
index 0f54ac04760d5..4944a5a516da9 100644
--- a/tools/testing/selftests/mm/thp_pmd_split_test.c
+++ b/tools/testing/selftests/mm/thp_pmd_split_test.c
@@ -146,4 +146,35 @@ TEST_F(thp_pmd_split, partial_munmap)
 		self->split_pmd_failed_before);
 }
 
+/*
+ * Partial mprotect on THP (change_pmd_range)
+ *
+ * Tests that partial mprotect of a THP correctly splits the PMD and
+ * applies protection only to the requested portion. This exercises
+ * the mprotect path which now handles split failures.
+ */
+TEST_F(thp_pmd_split, partial_mprotect)
+{
+	volatile unsigned char *ptr = (volatile unsigned char *)self->aligned;
+	int ret;
+
+	ret = allocate_thp(self->aligned, self->pmdsize);
+	if (ret)
+		SKIP(return, "Failed to allocate THP");
+
+	/* Partial mprotect - make middle page read-only */
+	ret = mprotect((char *)self->aligned + self->pagesize, self->pagesize, PROT_READ);
+	ASSERT_EQ(ret, 0);
+
+	/* Verify we can still write to non-protected pages */
+	ptr[0] = 0xDD;
+	ptr[self->pmdsize - 1] = 0xEE;
+
+	ASSERT_EQ(ptr[0], (unsigned char)0xDD);
+	ASSERT_EQ(ptr[self->pmdsize - 1], (unsigned char)0xEE);
+
+	log_and_check_pmd_split(_metadata, self->split_pmd_before,
+		self->split_pmd_failed_before);
+}
+
 TEST_HARNESS_MAIN
-- 
2.52.0


