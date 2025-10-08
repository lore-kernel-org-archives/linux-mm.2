Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86520CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB7D8E0009; Wed,  8 Oct 2025 11:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2CC8E0002; Wed,  8 Oct 2025 11:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9328E0009; Wed,  8 Oct 2025 11:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BACA78E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:30:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35E8D13B67E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:30:37 +0000 (UTC)
X-FDA: 83975334114.06.3A5DBA6
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2DB71A000B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:30:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=AlS4UYXx;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf15.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCU0o8wSJQJX56U4+pnGKdTopFZ/0WcuCtYzGhhpTrQ=;
	b=NouFB0OcEa4tMuhSdl3dnuqmBJ9KLo6af5OlvG+loFsMRnnIUbZSiQ7gp7siFpzmCpH9RQ
	mLmEuGogAwGUotFEEzRoWh52vQ8j/qMAJpFNQT+7LezCgT+wlbrri0hmB2+E4BSgypNU0V
	sRhWZ43i16wMdUArWj3Lv6/lwDFAIkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937435; a=rsa-sha256;
	cv=none;
	b=RuFFY50/8LXCVRzFW1JMIIoIkzzSrobZe4UKV9TNKQCeKPEb9Bhp1I0yRgGJoTdxx3mDj1
	2oDbV3VOHNZ0IF/5FOVwEp65qZUKuTY1nbDyIvcNZgzIX/LU/OhP6WRbZp7ValtKcSlwgW
	yxj0eXMtSNwV6ioT810L1ratpfzpypk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=AlS4UYXx;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf15.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937435; x=1791473435;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CCU0o8wSJQJX56U4+pnGKdTopFZ/0WcuCtYzGhhpTrQ=;
  b=AlS4UYXxnd6N/VgBtW7VyoaaYAqh+8qiv38vFf5Q2LD4S9UeBeSYmYzo
   29+EjFpy2WlUGqSVNKoemsFJRqUknZ2bEnPa4VxogU3DLy8D0u7I1vIBx
   WOf8M4KV3ySz0BtWsrkPf4929vHHm2mpWCEHauT8m7N9WTQJ+Zd7IbPK2
   2E/CxuNNHdMVdY/nI2n7YYICcIR9PH+AqD604MN3Cu4coB3iRiWbHk07F
   gkyIiy1A8Jqly/ucJ7hAavnccrpEVpL2SB06GdbOBdLIkR2h+mjoUz9i1
   a9hrLzNZvGR8q2ncLUE2R8ywXY622UcC335THQr4P/ITsGU4wH6lefq6K
   Q==;
X-CSE-ConnectionGUID: FAdGmmW+T0+u0jQ2d4QeBQ==
X-CSE-MsgGUID: X3yDuui9Sv2jpaN6sKHe0A==
X-IronPort-AV: E=Sophos;i="6.19,213,1754956800"; 
   d="scan'208";a="4533988"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:30:32 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:27231]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.57.112:2525] with esmtp (Farcaster)
 id 01dd130f-bec0-4f9d-8bb2-391e29d56fcd; Wed, 8 Oct 2025 15:30:32 +0000 (UTC)
X-Farcaster-Flow-ID: 01dd130f-bec0-4f9d-8bb2-391e29d56fcd
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:30:30 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:30:17 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>,
	<rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
	<jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>,
	<David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
CC: Andy Shevchenko <andy.shevchenko@gmail.com>, Christophe Leroy
	<christophe.leroy@csgroup.eu>
Subject: [PATCH v3 02/19 5.15.y] minmax: Introduce {min,max}_array()
Date: Wed, 8 Oct 2025 15:29:27 +0000
Message-ID: <20251008152946.29285-3-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D032UWA001.ant.amazon.com (10.13.139.62) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DB71A000B
X-Rspamd-Server: rspam02
X-Stat-Signature: 5ystm1e6nbmfugffqn5omw6sd9cgwx4o
X-HE-Tag: 1759937434-686697
X-HE-Meta: U2FsdGVkX180besXUwQU0EsCyO5chHC8YvBlbGEipcyeKKgzfQVAm4QxLh2OcbQvOznLg3ocTJL28oqsNvcVDDbAXN4yJX+WyxueTBcIz3J883lna5MrRvgWJQMxF+prL2uDwyj6P8ilDmtEEd6pf/ENWIcIPrgxlODiPbkyWnqKt4+t7joxc3Gtj/x/e0bJ9Q7f5Lv63zPwwCpTYojGN2aVTYNUuN7k0RngJvNUScGjQ4YMvVkuPtHRdDdmoyFBD8/DK4AfR+MMPRD3XEDsXI73MgZnMFK2p5UQa0yM/I190Z+GDWOM/Alg+AbW1Xqs/SsZiMqqGFOyud8NtgeS7qMNNsWM7l1qQCN8g109OS3wGtxiH4+ZVVn13EzAYJ7IFvRtmLbHpHvZo2f+Oi7nNtNbgdcW4vtIi2SwFX06qFpptXKSAf7f86Kdl6+/Zkr+rIrsaPeQ/tHD/00b+29/Rr/n5ljIEzVjMtuvjygG8PmESpwFtPQ+Pg5udD1QLIpNFtY1d0i1M/NAATaVMHB0y3/774YDB6EO/Mcd0nrkbt4FAyn72NbhTRxDGo9SQP2Iu9b3C65TKju+L+z+OfsIV8jMPWSxRISEbKy79MS+xcGzSAk5ztinPeUBYcsJFa6C4Aie/4ITuu5NUBZYAjaiSXaKuz/qSoMYo+/P5JRZiZFXs6gIUbydJhbLIR8AEExaHgSAw0DhqWiPVuJlySuplaA2896vZdQ0KywjVh5UoE5/FU5iAwIAW4Agv/jTR4GuH5jeoFjbF8fpeiG1q1uDn2jik5C0OiZ5hlMJo4nDcTohghArRu9dmww8gwgjKNbIRtYD9gZbol+VaeV5Skyy15T3+pH7+yyrfGtta8/XipkqXCevmkmjD/Pn6bhW3ukoH2o1fEnfWuLz94woxYbRvbdYL9boRzaGwkKhiheD+4Z/zOj0GinMH0OANdPFWlHslt5+YXtGQwUWZyDbxqH
 eYsw6uis
 yfSqN/4JaLjkSSRUqVdiZ517QhC147Q6V9sbjiPmvmR970qs5pevNngqz5xDtkOjm5dbEL2lpqtiMh5EtESzOVVz1WFHb6/mNS9r+nymi76dKLpM2ZTyY1rpNYcb4SoPHeIFW1tKJtXoiIK8yIj61Wo0+y2YGTKFFyJEYfZ7MtkDqJ9jQArfcA9bGF7Pc5ZP0YZp0x7F1QgC++3YOY/uLJB5oCzDeVOsUGse+08UCqZaObEcnvwY5kXJaC7X2zeixtDqcREc45Lyu2aBvommswLrLXuvCbm0C200wqm7geji9R1YiXYTVsyfkO2kskp0TFokDzOVWcG8yv9jiJwXJgmS43qTzN5vpIESgY4ydSSa13mF5WNKwP4MuV8uRkSXtZ+fc+afmvN6qzxXgCCLz3S93atCitZS/JeGsvOFojUcQ8lqohnRJW1lHlqhGrbdVSLoGiAGxfjXOnCAeqdddPO8m0hpnRx/3RC4/WT3bSGUxp0XU/ER7WR4mh8hmHHeStlf+e1XHy+a/TdJ2YPCGMJGfZsFZ04UkMnEysKI+vN/3fIwPlMvx11qOpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit c952c748c7a983a8bda9112984e6f2c1f6e441a5 ]

Introduce min_array() (resp max_array()) in order to get the
minimal (resp maximum) of values present in an array.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20230623085830.749991-8-herve.codina@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 64 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index d4bc394b449e..aac0b7d23768 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -168,6 +168,70 @@
  */
 #define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
+/*
+ * Remove a const qualifier from integer types
+ * _Generic(foo, type-name: association, ..., default: association) performs a
+ * comparison against the foo type (not the qualified type).
+ * Do not use the const keyword in the type-name as it will not match the
+ * unqualified type of foo.
+ */
+#define __unconst_integer_type_cases(type)	\
+	unsigned type:  (unsigned type)0,	\
+	signed type:    (signed type)0
+
+#define __unconst_integer_typeof(x) typeof(			\
+	_Generic((x),						\
+		char: (char)0,					\
+		__unconst_integer_type_cases(char),		\
+		__unconst_integer_type_cases(short),		\
+		__unconst_integer_type_cases(int),		\
+		__unconst_integer_type_cases(long),		\
+		__unconst_integer_type_cases(long long),	\
+		default: (x)))
+
+/*
+ * Do not check the array parameter using __must_be_array().
+ * In the following legit use-case where the "array" passed is a simple pointer,
+ * __must_be_array() will return a failure.
+ * --- 8< ---
+ * int *buff
+ * ...
+ * min = min_array(buff, nb_items);
+ * --- 8< ---
+ *
+ * The first typeof(&(array)[0]) is needed in order to support arrays of both
+ * 'int *buff' and 'int buff[N]' types.
+ *
+ * The array can be an array of const items.
+ * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * to discard the const qualifier for the __element variable.
+ */
+#define __minmax_array(op, array, len) ({				\
+	typeof(&(array)[0]) __array = (array);				\
+	typeof(len) __len = (len);					\
+	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	while (__len--)							\
+		__element = op(__element, __array[__len]);		\
+	__element; })
+
+/**
+ * min_array - return minimum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define min_array(array, len) __minmax_array(min, array, len)
+
+/**
+ * max_array - return maximum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define max_array(array, len) __minmax_array(max, array, len)
+
 /**
  * clamp_t - return a value clamped to a given range using a given type
  * @type: the type of variable to use
-- 
2.47.3


