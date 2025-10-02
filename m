Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0046CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3D58E0019; Thu,  2 Oct 2025 16:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553F18E0001; Thu,  2 Oct 2025 16:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B758E0019; Thu,  2 Oct 2025 16:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 295218E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:54:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E7E38BA992
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:54:08 +0000 (UTC)
X-FDA: 83954376576.27.2580DCE
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf23.hostedemail.com (Postfix) with ESMTP id C4D9214000B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:54:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=LrH6TH67;
	spf=pass (imf23.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
	b=rTrIkR/dMaKNLsrVPTrs/OZRJSEvmueY7fbtQegFiv0x9EoUFHWRBCEX/bXeTq3r/Gi53Q
	iEe7Ga+Bql1pnykou/VpZzI7x4a3jt6QoxyzovieouS3+UEBzhUXp8W7uN+uFSHy1xMIGN
	87nmgeDDpygqmuMnz2kWPqV28+uV1oY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438447; a=rsa-sha256;
	cv=none;
	b=uYLMAqrWDEJyxG3UPy/yqBO5HnsLQu7bnQNyM7cqHKx17EI43kf5p9adPwL3ImUMSMoCMx
	DEhI8EkVsRx2r5EWsRJ+6eSnQ30kBQS1LwZfIPVz4ntRWCsl6g6mkocvgoHICHM2yXWTKd
	dIZ5qzi202xAmYjVgLn38ylxKwhy/MA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=LrH6TH67;
	spf=pass (imf23.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438446; x=1790974446;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
  b=LrH6TH67F/aCNImKYDYwZEFg67HfuX3OCG0rcjD18Q5d6oBq7BbJtYrD
   CwGTXFU+ZoJI5ao4jipyDsQU+uzdRIGKsXyv47XmVXZ0kKMnyONdxPlk7
   qQNmRUkEHZrFuwL8oQT4mGgj1XM2VYtkzUb/BquH32lYVubOizyS0cbBR
   uqt/kbVVR5Si3xCnYAh6m5+HNSqtCtpvTx/1eMYg+nN+tKO4MeqTzawUB
   rlKg085aa4GhkdW+vb0yHCaGMXjeTqp/p2KesFT6UiC+UI8cBIwow9jzu
   tlGr848IGbhzdUvMbcGjM0i6APPQkQJPPKalmpzJQwI1NXJQk1J+PZ752
   w==;
X-CSE-ConnectionGUID: /Kk2Y+6URw+T8Li/oNxKVw==
X-CSE-MsgGUID: Wlm0a1+tR1SdfKdQVoro8Q==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="3032570"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:53:56 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:28436]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.4.140:2525] with esmtp (Farcaster)
 id 31b15363-5bb5-45dc-aa7e-82a9ee14e7c1; Thu, 2 Oct 2025 20:53:56 +0000 (UTC)
X-Farcaster-Flow-ID: 31b15363-5bb5-45dc-aa7e-82a9ee14e7c1
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:53:56 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:53:30 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH 12/19 5.15.y] minmax: fix up min3() and max3() too
Date: Thu, 2 Oct 2025 20:47:26 +0000
Message-ID: <20251002204733.35652-13-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWB001.ant.amazon.com (10.13.139.148) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: zo5phec8fftnroxzfc555dro8akdntot
X-Rspam-User: 
X-Rspamd-Queue-Id: C4D9214000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1759438446-382795
X-HE-Meta: U2FsdGVkX19Iy95crVbDYdsIe8ZEUos6tRC5GNKgE/EDYqc5weDgadORxT2ftpiQGsepg4Q8eBspM8gpKTM9vQS7SlC+7orMEgHSIlHaJ075EE5XAMpd5o6jcmEWZI29IKurSgejgKS0WudgfQ10KQzU5TWwidBGREuwFoDJ6FpKZvBbs6g5p8a/e4daJk59KrgLFnIC7qXdWTuyQnvVSUu+CUpJyt7TGB9qd+q8MTokYRRfMjL9PspoXpefCdqs0rLWQOgr++yrQSCg1sZkKWGR797N1Gcvhp+x30sVXo6WgZTwyxYbzqzAkWcwMnDVxzXGKM597mtyTqw5aD/DjwusVzkN/4ovdFJvvtZdAzK6ObF5/AfCef3ThSZVtoROLwexfzwGltelrJOXn6droq1npXGfTnxduKUQvlU4KxYuiEOIrSFAMZr7zQWsUMbsotSBJ9oFDAVvBktiXAFQAvRaOGTfAT+FJL3jH0Ir/ky32gzDlt42bHK7wZ/w0WMSJk/qgyjCYEemqNFrOnhrthWFWppTpj+D1tNZraBkwFudQ+G0BZydzKIguuMyWMNHSh55zPSFMzLRihDbX8JKT0benWEweVBcEAqHjg9v+mm27/TaUUoTlOf7Gpwq6b1mCn8qa5eEC6TQmGNtj/VZ4WHqKbq6qDIfcU0uP7ykUTEs1Sv/QU4VVEByMjrq5ONQXJnvgHezecsFO7L6rKSpnH6RlGJU3XYFdYewlM4buBGqPQcvhekzKi36M5ATcaQ1+8tYXNh7iUpOja330f+Q+HP4f7u3NejCQ/0rd6ZDF8zFMadC2VjZcMbySg6VGMezut004T/iSDyhFl6RW0UP3CGaM8diX0Ta4CN0xXj/2vHl6xCn6t2XzXneyCkxDQQfLRpnYevr0muc3Ix8gZX38HKnPGSUjFd055Eu/lBBVpo556hATdVKSuZsJY34VSU/KjhVeuY2pz27+pdB0ar
 XFV06keg
 oeOP1zBKtyb5B6SxpVmVwnH94QHgeNOHX+IDfqwq/gu5NSZ8phTtXFzL2HdDYoU0PNHwT42+db4w6aiFs3BamdDkY7wVPEQiQT1F8juyuQxN5/LhIMGKqFPr5WEl7kWcOLl4oKejVGyTYA/j1ZJuqDOx+qU9bJnlMGT1QQ9U2LvY4pL2DsdrHW8kMrv9G673qMu9rBRULIctAtDoxREVPAUDnQQSI32H06T/7kN+WhvXOecea+C2QWx2NkSRa7uU+4PVopEqJwpYU1EukTdaG3Qw1Na97zS/N67XZi7IbgHOD2pQMkNa7CvIwgoeWKRIrqgFBXrTl5a0bVZXaRaW3xhP42FBDmLm5ZgZe3yO+PIOnR5420srS3/BIQd/BTqgdtqtk/8Mi+CjcvS1TS0DQJmTkZcwwFd4OxkNpBoFnVqLeLH4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 21b136cc63d2a9ddd60d4699552b69c214b32964 ]

David Laight pointed out that we should deal with the min3() and max3()
mess too, which still does excessive expansion.

And our current macros are actually rather broken.

In particular, the macros did this:

  #define min3(x, y, z) min((typeof(x))min(x, y), z)
  #define max3(x, y, z) max((typeof(x))max(x, y), z)

and that not only is a nested expansion of possibly very complex
arguments with all that involves, the typing with that "typeof()" cast
is completely wrong.

For example, imagine what happens in max3() if 'x' happens to be a
'unsigned char', but 'y' and 'z' are 'unsigned long'.  The types are
compatible, and there's no warning - but the result is just random
garbage.

No, I don't think we've ever hit that issue in practice, but since we
now have sane infrastructure for doing this right, let's just use it.
It fixes any excessive expansion, and also avoids these kinds of broken
type issues.

Requested-by: David Laight <David.Laight@aculab.com>
Acked-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 41da6f85a407..98008dd92153 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -152,13 +152,20 @@
 #define umax(x, y)	\
 	__careful_cmp(max, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
+#define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
+	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
+	BUILD_BUG_ON_MSG(!__types_ok3(x,y,z,ux,uy,uz),			\
+		#op"3("#x", "#y", "#z") signedness error");		\
+	__cmp(op, ux, __cmp(op, uy, uz)); })
+
 /**
  * min3 - return minimum of three values
  * @x: first value
  * @y: second value
  * @z: third value
  */
-#define min3(x, y, z) min((typeof(x))min(x, y), z)
+#define min3(x, y, z) \
+	__careful_op3(min, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
  * max3 - return maximum of three values
@@ -166,7 +173,8 @@
  * @y: second value
  * @z: third value
  */
-#define max3(x, y, z) max((typeof(x))max(x, y), z)
+#define max3(x, y, z) \
+	__careful_op3(max, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
-- 
2.47.3


