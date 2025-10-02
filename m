Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 622F1CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD9B28E000E; Thu,  2 Oct 2025 16:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A768E0001; Thu,  2 Oct 2025 16:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A793E8E000E; Thu,  2 Oct 2025 16:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 925388E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:49:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4830E44B27
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:49:05 +0000 (UTC)
X-FDA: 83954363850.06.EA78565
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf10.hostedemail.com (Postfix) with ESMTP id E58BAC000E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:49:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=YSZswaoQ;
	spf=pass (imf10.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCU0o8wSJQJX56U4+pnGKdTopFZ/0WcuCtYzGhhpTrQ=;
	b=syTmJleYf56C0L1ouhXqBsZ4OGllrD0hym7F8ZEAM2TczPxJS3JWOzSyQuYlLGX2yHR5GP
	EpTQcrRPxNGQeh7wTpr2XpoqH2H7Cn4PUhgUp7XqSI/62wnhkhAfJXbDG4hVFr050r+PBH
	XVs0ky+ObZuFxZ0o3qG82CQwLZyX+Zc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438143; a=rsa-sha256;
	cv=none;
	b=ErHZ06LbCEuh0JFozpITmX3L70mLKPyrQtJB5En5NMzRybMJigSPssa/jB3TadAoZIpd5d
	wZU/eyfKM2qKzMUWtUM8qgBGRkjcyVejac/ggN6mbOOdCAL2ptC2ahvhgOU9UkH172IuH4
	Sjw8LvDh3TIGNcZwiwaM6edOWPDz1cw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=YSZswaoQ;
	spf=pass (imf10.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438143; x=1790974143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CCU0o8wSJQJX56U4+pnGKdTopFZ/0WcuCtYzGhhpTrQ=;
  b=YSZswaoQG6SQPyCPqsNHwwzPXgk4aNF8fcCyzKuz/XQWqFRXb4/wviQs
   PweVqKaoU3ry+f2iV2atrhlJMSirfOJ8XoP4tBq9JmbNsxQ4J80/vRpkN
   135X8XdmkMlsTlc/6k3FR2GXDRKz3fOGwKomI0UfZwFBA2JyXHzGUknOC
   gqNE8IiUKebqT05YN21Ha9mtQWN2dlapQFRIdfEq/UTBZxucNkV/8wAgp
   LKbqxGbZwtjy0GAGyxKvCYqxaY/yUnat0w3Q98SzkA2l48OeMW3rrqhOf
   tt2GWaz3FGukEnXz3XWyrqqTUr+cT7YY8cBmIxCeAX+2tGCHO+pgk8pfi
   Q==;
X-CSE-ConnectionGUID: YFe8jPo1QUeEW67O7ndAHA==
X-CSE-MsgGUID: tTAQC90ERwGyVX6J55647A==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2924497"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:49:01 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:11827]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.40.83:2525] with esmtp (Farcaster)
 id 6508bead-2ec3-4a32-addc-2cd3f144bb5d; Thu, 2 Oct 2025 20:49:01 +0000 (UTC)
X-Farcaster-Flow-ID: 6508bead-2ec3-4a32-addc-2cd3f144bb5d
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:48:55 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:48:30 +0000
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
Subject: [PATCH 02/19 5.15.y] minmax: Introduce {min,max}_array()
Date: Thu, 2 Oct 2025 20:47:16 +0000
Message-ID: <20251002204733.35652-3-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWA004.ant.amazon.com (10.13.139.109) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: pz8bte9khteq4hi89fcs6sebi7dqjkuo
X-Rspam-User: 
X-Rspamd-Queue-Id: E58BAC000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1759438142-339545
X-HE-Meta: U2FsdGVkX1/184m3c6RbWxXzBSgZDy/mCCIf/nmlX4VBsqHM1dSBW97iYaQvTNhEpdRFhj56Otp1Ky5lovGyWblch3oHPdD/4MfOQsa/kVejLBJe7w3jf5qqAObrgVSgsqoJ10E4GAEfvt67Cza5pcxNALQbDf6YglojuSkfYklqXCgRn3hAcQOIl6L3rix0XXqEZMEmk+8C2du9eUrTb6lyQVRkZHtkXWzqedkeNOx1Ptx4cDSuK79q4UddKe3SPIIooikpr3dWTsneL4TsyggE/c0xfyp1v9hsmerIZHBkQE/loehhNLB6uSp/AjC6TUYJ1S+aMHO7ShTQt6kzXuCUjw10sIyBar4D1RjOj+uQmLxU2Rywv5agOCh6kssxz+mFqrcofyvjfXzOuDzAMobI+S+DHX8eJYgSAiRLAP6B+vBBdzJqUBGxgJcCfbOgi2axosyje6pcs/lh3WmgbW4+0TDPJu3rnCbL40/t1RT9ActY+svP6wDqfQV/L8liSx/CArDiBVAkgZ/sUldINKHvaQIyC4rby+gnqO0t0baMLR0XdZWAHKziK84jwsNeNC5iJ9VHx0mreJ+K5cjuxyJVfSr8cNC9kMqtTL4qUyzcC3h0gjEfAVhqWYeNbs4uMomuXx3VYbQ1AuM/f0XFSVvY6jZnHAl0tP2Ld9nzvqHhfI4qZ0pVhYVdaOgfFLhfoBdsJPbH11Hh3nP7rEKZIChGufr73J6rwO/TSoyZYl3I2re+awu58mSxX14e6LVlfaU5N7zUBE7x5GxbqU5RsDOS9W8t3VX5Pvciopul2xvSPBpENpPacpls3hL6QfqKL60+xujK8ySqDoRmU0bafbCr/Y2ER5hjfDqywD5QEs/Y2qbC8KxPn9DgrqPadrP0CzJdHPyrY0AMGcCnKo6R+hub9nvmPeeE00YHNKuJMk2iivfqDyVd+ot7v7T9tIB9DVsaXl8ovvw93x0OM0c
 i37sZok7
 RJGOsKw1fISkky+CFeZqgc+C40SYpG2rd5QqctaAwVvHYv+J0mmKwX/MEkp1QpZzFNGFCSfL48wsAOnhvc+XPPcTenZe2KYr7/xWsTNtqhjUusdPQ45ZG0+MdmyOgQwglL3nqg90285/b8KHQFfdFTcxORQ1uRRgucHx8uJ4ainOMqtFD+AyiWqqWhbPNWrmmmVvhAX+F6sAyJAactOpXxDQAIEhAXW6cU27I82L/ycBmqfGs7ffV0H8T+5eN9yMadukn0yo9Bh6aDQwGv2wV08yOhLUI8XbfggP9k5kvettxpVcS5tV1wzpVay9IQAKjruXZZ94VybuNISzkX9Jmsa2pYgxb7Ok7FVb/2Egt5CUsz8B6vzbReQ8wpxU6BeFD0g+9AMC0badxknxRoJunF8bIYlTf+wNfEBVk+KZAuYy3MiibqHcDBUBU7yrcY+25uHSw/lfJaLzxCBszsTJZKovoRKXQcbRoGOGCoerDEgP3E8v/HT3eavqRKhaAyi6Pt3leGr5gM4/rFaDG50b3jt/hvg6ZKZm5ZWeULEegjrSGHwZ+rgNVekmqjTPXYALo77lDraArRUqDhsCZXttuVi1t6PI39wBQux1yuyAPU8qjeuTki/mReSH45Do6J53rVulDIc72wqInmoIokv4fL9QcX+dMBTzWdgjs5ZKMUfrWrDXQFvGHSQSNvItdrYiWdnzoR9fEIn1G9+zLdrdtYo1SahPNyGP+7/H8f7gDhUbGWSLxKbCDhqXLbl8TogRcDQCbNZ2f3LqVr2HDY0Zf6JJOFPxzLahiG/0pUJoUVoK6V9zOrI3robOti5YgAXHlwgfj5rKd2T/EjruRHmA3ChWM6vlf3hTh19xXhM6lMxdOewRJpS5uiLf4Lp2e1xQJiMjcwIvF9srvtjgNefjBv8heB03DiXeFhvGKQOLN0iNihNmiy0uaTAT+AtTYtUmMoflUs7nAAzVBusnkhoRPMJRAeL+W
 pyWMlfap
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


