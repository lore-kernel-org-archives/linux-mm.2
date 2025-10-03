Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B01E2CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083A28E0007; Fri,  3 Oct 2025 09:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05BBB8E0003; Fri,  3 Oct 2025 09:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB37E8E0007; Fri,  3 Oct 2025 09:01:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA5328E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:01:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 847A0C07E8
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:01:50 +0000 (UTC)
X-FDA: 83956815180.26.12B84D5
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf18.hostedemail.com (Postfix) with ESMTP id C560C1C0015
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:01:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=GztAqyc3;
	spf=pass (imf18.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCU0o8wSJQJX56U4+pnGKdTopFZ/0WcuCtYzGhhpTrQ=;
	b=xcS6XT1ZVRcmeAeGGmY3aRC/HbiyNQr9MxRJvgLPGFIuRpS55A8OCmW1lm8y/AsOZcSRKN
	wduH7Dh3BqdfwdETc5bYrbZgFyjkURvuO6kaeHm3ss2nJVYcO/mn/4eckWxzz6zr1V/iWY
	+uEKxiUSfzmmjPZUHb+/yytSiMjguho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496508; a=rsa-sha256;
	cv=none;
	b=S0rTgy3NmIUiLxbBqo0CEB99N1lqTX0ARSNaAhXkl1zhNm/2vp0TjUY3pAhWS0Y/yVr7+2
	XN+BE3BxS8BN5HuZSpZ72r5Rl4xaca/EMkT9N6MX4wfRkNgyM72zDZoiuMPIjM8MmbZgHV
	Uob7cb4YoaMPK9B4oWcA0KUYBwUhkMw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=GztAqyc3;
	spf=pass (imf18.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496507; x=1791032507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CCU0o8wSJQJX56U4+pnGKdTopFZ/0WcuCtYzGhhpTrQ=;
  b=GztAqyc3hwaVPMn1awjRJ4f5FzWZmpBt0bKKQpnSGaCXsluPh6UDXvoR
   AP6Hb5CiN5fjlC+if9aVfTjFHrYKdK4OccDQpLpmwuGlsOl3HfNpkNf1v
   E0PG5bUApMmt1ZDvWSCO3EjC15RtqxlfrRcgclKcbqK5j5TGUMk2cxMI2
   TmgOuq0XTZAqZvUocnTWmCBjGIabbYO2qBztKVYsBaF9PARUKjWfp27uf
   HCJHyMyDEtzPxW/oFNhYeBBk7PG89HMXDpaf+pmumPvD/b8Tr/Kdq04Re
   oSBlzhgXbwUSDBoNpCnZ3tAo7PCIMqJmQ5v4fbn9RgGzLkAz21RToLBem
   A==;
X-CSE-ConnectionGUID: tfF0uA3NT9Wv7xRjl6BuWg==
X-CSE-MsgGUID: qc8tbCehSsiKPhY3WYGIPA==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="2960400"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:01:36 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:13481]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.22.27:2525] with esmtp (Farcaster)
 id 3dc9ed1a-be3b-484d-8c8a-735ffa6b2136; Fri, 3 Oct 2025 13:01:36 +0000 (UTC)
X-Farcaster-Flow-ID: 3dc9ed1a-be3b-484d-8c8a-735ffa6b2136
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:01:28 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:01:03 +0000
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
Subject: [PATCH v2 02/19 5.15.y] minmax: Introduce {min,max}_array()
Date: Fri, 3 Oct 2025 12:59:49 +0000
Message-ID: <20251003130006.41681-3-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D032UWA002.ant.amazon.com (10.13.139.81) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C560C1C0015
X-Stat-Signature: ituhwd3bwo9j8cqnympdyofshe7k3jqj
X-Rspam-User: 
X-HE-Tag: 1759496507-970694
X-HE-Meta: U2FsdGVkX18JIasVyTXIIi0uZ7JIyruVbNFmiE+P7vr5XFQSjBBEi7rd2VPwxcH3pjCHY9WaUrLQzd82zIvQ7Vm8uHOO8SKbTs1jSk09ayNf938ghgP0Mdl2A7y6nrw0dFjhURBib3RJx1X8pY+H1GLyAOmsV34Bq7HULoKkIZHlbmQkdJJxWHmAjaN5ID2DjiRlSAbyzP7/Y6RNMB0mVm7n4lbZ8p0O0O9ksHNKhaVCeaYf7Vpzr+HUBb4tU3sZjpm0SlfxYJkyl53MCjnNlk/uSaNL8HCj4+DpRGWoVpKkwyIJ4XkFsNyw4Cb+R1UszdKDoMysfmr1dbK2zn7eaFiQfjPFax7b3s1VPITiCU2ByuUPdv65Aqv9e+r0iCGJ/6oSozQ0wAytgy8/e/GwvvMZuFBQHyYyqrL1TbJwnaCPSNhlzvEFByM9//a7opbVRynTMvpyOJ7uk6LtlCHfbv2Q9qtg9AjlEyFBjuW0h2W10mpZ57lLwAF+8Va4tNeLOwsCkBYxGyHK5E+qm6uFkM2tJmQX0Jx92HH1cO1FjjcnCxbj05ugvtWcj9DyN8EPQaqniUDajNLnRGQwN5dWfmf8PeQ+2OvCpCOuDYGQz9rTv3TAAYp70CPsbdLEom/igSaWqIO0qAUbB3ElUCyW9zvk6DevmtwX9fenkHobQlVW+7zQ601LsfvFdGBx4IhWXijr74bc6vVAZ2LLagQZ3e5iiOw4JDpEKELVa6JQMF1I1Q9b1MQDAyq2OJD+p79tphf5DJ1PPmTsOdOu6RO4IT3bVk+b//JqPGQ6ITIHeeltSkoUwWoGkYfqguvlYJoWStUacl0fCP30C8RKEoKNNMylMe16MFOVKS5tLls1B+V0AtJDU9nAx/UhR3FbarMMKeTJwe9N8BWAD6Oi3azHqflC7JHFkGSXlZUsNCIRta/mMVGZmnP9NNx8xcpBN4fjFfjYooL+hixPNU+cKnf
 dAGUV5NE
 TXrEopmBvsdzIRkO5vQn0uePa5p01NU5hAL4AkgfuAZTJoB9IeKmIn91KrjZm46V1NdnOtf48ba/2n3cH7OOt5VPoSjikEoKRs+bFYUEn41e0xqw940rQAEHLemqql/P1xJvQmYrJyg1OP3sHJ1S3T1drhFVO3mEnwGBpgnig6POCbKSR4CnrxySksmWm4EvK0/i7UYbDawRn4nXmjlXqI0QzMfcLuVUYWVsQ1ypoCfTfwZG/kAVTbcq4p+/pgSw1LBjET8bq5XtEIpLVBOIBn7FTR/50D0cR7c8ZSRVAr9j9yUb+OmGrd/kKGdvbHep2dZsfeCCAuBV0iIEPiPm/wGIg0NmHHJU+05JIsBqmqnod41INLxEUdShIJ0eUfJ+DsprZYx5+qH1YEQbvvLnSXSAfeV7q7qI0dfOPouOtnMMi2OZ8QB8fmLpq64w6CpsjSOzUC4ljNm14nited5QbDvX2pyXEb10dMuWhRD9Fr9iBOcSFHDCBqwb6LArGNgF3BGXC5eZIV7sgivg2+teiUxce3tk4ELm+TOkHWjrOPPiadDMvMI3qBW9HdZ/LKjErk5ieeH+0jFUtDQE0v8PjPvL9LPu+XP5yWrpvRavmyXrC19L22fFEguBmYYxZQE2WuIGpoc10Uh1ODzd9Eo0EHzZODz7LQ9nrFmaYgEMbGlvsN8YeAReOu0DLXAXqx/sNVQnTAspnWMFNiwqGFrwrE1JqjqX76Bz1HFkJU/vQkRGEgFJjJAF3fq3rqHnvEjP/+0EmRRpUMHCw15Wz+jjOtMa4d902GLPGyAGfAFdkivp9m8exasPrss8fSW3Yn/pxnI4Yy01uA6PvVPYLmVPve5DCd0I2o/lOu4jCjMYvr2Z3i6dmIoVIlOVYuFYfoc556gkH/EITL0ykOQj3GDcX/kPvKTz8mRu7mlQxwXyL93U+cX8U9d2297KuTlkdocAyJ3dMq3TFg11A7k/jQEgOCjELxsRB
 r/toEz4y
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


