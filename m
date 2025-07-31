Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A985FC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 09:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302616B007B; Thu, 31 Jul 2025 05:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3016B0088; Thu, 31 Jul 2025 05:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8D36B008A; Thu, 31 Jul 2025 05:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC486B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:02:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A844114545
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:02:53 +0000 (UTC)
X-FDA: 83723969826.27.87BDAA6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7DA8640007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:02:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753952571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=pyDBUeJEYlBK0pxsU0xvDjddAfItdO7IM17eUG01F5w=;
	b=uSzjVA6D2Bzu3uly2f63N0evmrPRbCTX1cb7breACoqQ4GZ4mTkg4N7tWGK6W3cwL7o/r6
	HMhsLx+7XDGFRlgn9Oso5z43oboLg0QOMXf3iorm5jwtfiqXD2dOISsszoUJpObPPXfgBq
	cKrklcRyydZQ2xLjvLTQl6G/6wqWfpY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753952572; a=rsa-sha256;
	cv=none;
	b=dQWYkL8tagqCsisLRRFG2AmaE0HA+xcW1NxtqlUW+sC7POc55sVCeiHk6TcxsKnxTS6BF1
	2YyIMTLHnVvJbHxY7Zwx9gz8KTt0lgH/IN/vK5WW4P/gmwqvE+cK0JK7mO+S8vrPK3ssS7
	iHXIU4FyCKF824Kdobg+3pTOxbGk6iA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4607A1D13;
	Thu, 31 Jul 2025 02:02:42 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A62AB3F66E;
	Thu, 31 Jul 2025 02:02:48 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org
Cc: kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH] kasan: disable kasan_strings() kunit test when CONFIG_FORTIFY_SOURCE enabled
Date: Thu, 31 Jul 2025 10:02:46 +0100
Message-Id: <20250731090246.887442-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7DA8640007
X-Stat-Signature: d54f3qxheyowmfuc9j8s51fks8xrjp3r
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753952571-626340
X-HE-Meta: U2FsdGVkX1/UY9XIvxjCn0ku9bztB6DXuw8+XjbvgehSa7/Ou6IZw4MH3ZHsO5RA/WPZ1RCflMqRHge54bA87uGYD9kTNiU9lqP78B5u6cngIQydH1fm+ilk11DxGakNQ5shfigYjYrBo/iOeDSAmP0tB1RgM9VT2QfLUkSIE3SJZOD8drWcE57bM/vbjNGo5l51HLBGHu6JAXRX35uL5pYX+fAMMGfhaMpjszgue2a+xWh4P4U/zjvrIxkIyKU2sQSTlDh6s6lMLF1LPyqrSYGcAKp2YzVSaokgYfeNbQK+pkEEys+X01PHKVZImWEu40i+ZmL1NFiioTQ0NHCUINKKVj7uOByu9jb8tz5jDu5tqi9QRX3yYEtmNs8a6NEYqdixoQcFb74q9mMB76BtM7+XMO0oRNXVj983sX+kMHi+IT4/ecv284QWvfX56wRMP3aYwsgGQTpRzLSktvuofM4NglZJPeRiJXgD7hCrTUGJlkoK/NOKaEtq+tSbu9pXZsO+9QlorD1pdJc9slSlOHap26gD3SZaJMIufvlXiqE1QnGArRCiKYQgUqgNegL7Ieywv5GfTe0dSmS+DFTXEL50XoCi0VedBEdX9XECL8wt1KY6p3U3fH4SVLfH13g99g+vH7Dz1X2MW0dtN53d+fntlX2SnLsOeiwa+1I/RvLAmZ//QHH6M5isDQt4KlwFrmNMaf0y/OtjLK5zB5SSjfsbq9jzHtx1iL+iqZqraSZyYz5+YqOZreGxxLNFlfxa1j5fVRuvV/T0oF7H3yxVddRoTVS/VKT9KyvevrlQmUMwh8ln1nkqiMQT9ARsfKQ/yMciGh3a7OqJ9Fe8BXKi+lfxw12mm0pzvnegMI5QaKh6kNgYmXTScnKFFZxUEPq3UiqDE7A9P+7OAkdpLl2VOnEcHvVI6nhI7sOu9k2PQHShDZm4iHlqDLB3/tbvrH3xDBs0s8ycOPpaaUrm8vL
 gMnjjsOK
 zcSPaURUsDWA3JK61KGPuIjwwZX+w2bnlipv2qxSwhYSvJpkn5xTfRqNaabAaTARmUlayeHxC87QfKbJxAwKeqMR+0zYjaWRMNu34j92Gns1RMPXwDTxXQXUFXz6H+gNdGSmPgRbEWGPuet4vkgIu51Z8rgvwL0QD25JU7NfCAMUy8sW+Tvw0bFOaADOYw5UvJZxMkp21LEAbF19lkD7MLyyF/EXqxdmUFF55Blp+YObrbpDH/Mw/GOhffwhgp8vuf2XDlTXeoRLNnfw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_FORTIFY_SOURCE is enabled, invalid access from source
triggers __fortify_panic() which kills running task.

This makes failured of kasan_strings() kunit testcase since the
kunit-try-cacth kthread running kasan_string() dies before checking the
fault.

To address this, skip kasan_strings() kunit test when
CONFIG_FORTIFY_SOURCE is enabled.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/kasan/kasan_test_c.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 5f922dd38ffa..1577d3edabb4 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -1576,6 +1576,12 @@ static void kasan_strings(struct kunit *test)
 	 */
 	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_AMD_MEM_ENCRYPT);

+	/*
+	 * Harden common str/mem functions kills the kunit-try-catch thread
+	 * before checking the fault.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_FORTIFY_SOURCE);
+
 	ptr = kmalloc(size, GFP_KERNEL | __GFP_ZERO);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);

--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


