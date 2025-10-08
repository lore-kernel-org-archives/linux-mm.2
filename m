Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 891CDCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E838A8E003E; Wed,  8 Oct 2025 11:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5AFC8E0002; Wed,  8 Oct 2025 11:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70CC8E003E; Wed,  8 Oct 2025 11:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C53AA8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:35:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95A44BA55F
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:35:40 +0000 (UTC)
X-FDA: 83975346840.09.A5CC882
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6EA9A1A0013
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:35:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=cVodjNnj;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf19.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
	b=Ru7NI46m/Em5ExLAe1ofS9vO6O0lFnqtbHOELn7gNTMjx8Ni+Nk00Dk3EN6NpFgXRnqlsv
	Za8YnSx+Ak2tkTFoz82mfNq7kOg6+FDZL+/eFBFBQDxZ28SZyeiEdF7Pi3eikwVFCQrdPF
	MEP7N8aZYK3AcgkG9UtYagyBmAF28/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937738; a=rsa-sha256;
	cv=none;
	b=TWdfbA89T4hdJp0zOPzOowWz30vQWIj0kikqCfhz9ac9tdr2j6eUOpt/VvkmMX88yaURyG
	Xq7rsdsk8Ni5MAZyp7O+v8CH4z9Ll7/IzGaUenKZnxpNuUy9WcNXcyLoRL16YbpWl4njAI
	mM2FayVvCp3Si1L8EojiFpP3Zrb7apc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=cVodjNnj;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf19.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937738; x=1791473738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
  b=cVodjNnjMnHwl/4sogS0Yav84XAPjwo3o2unq6Yo8NqsOxmCpSn3QbT1
   hPth0e/x1ukGuwn6OCC0BWKuYFlV25PwoDzMyjmCLzRUL+RPVnCpiuqxn
   oZ3S3VE44Tfzx5A61bfcFD19f5BgGk2tdc/UAmAJm2dOtC96Yg8eCns8Z
   ig/YVbmgFSw/AbUwVVrpZsE7LhuB1ZXbNFBlJWf0QNiRqPLU8iHVxiakI
   itjZz5lSFhAE0Mz41s1PvZ0WAJiK6B6eero3/TyJkHhqJzK0k6a/gm2Qj
   FKIZkBB+mlQMKR6KsXTPZ3zwZEJ3vdk4uV7ZSM/GdNuUOyNxt47mVNRJM
   g==;
X-CSE-ConnectionGUID: b75d3iYwTRuB7tX10Wtizg==
X-CSE-MsgGUID: Px2S2wuYSNWDoNTkGsZEDg==
X-IronPort-AV: E=Sophos;i="6.19,213,1754956800"; 
   d="scan'208";a="4410969"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:35:35 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.7.35:3268]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.15.171:2525] with esmtp (Farcaster)
 id b6cae892-4a8e-4639-abaf-f3ab0bbe7767; Wed, 8 Oct 2025 15:35:35 +0000 (UTC)
X-Farcaster-Flow-ID: b6cae892-4a8e-4639-abaf-f3ab0bbe7767
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:35:34 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:35:20 +0000
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
CC: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld"
	<Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro
 Falcato" <pedro.falcato@gmail.com>
Subject: [PATCH v3 19/19 5.15.y] minmax.h: remove some #defines that are only expanded once
Date: Wed, 8 Oct 2025 15:29:44 +0000
Message-ID: <20251008152946.29285-20-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Queue-Id: 6EA9A1A0013
X-Rspamd-Server: rspam02
X-Stat-Signature: wuz7wxd399tsxztz65ss6dpxgo16k5ix
X-HE-Tag: 1759937738-733172
X-HE-Meta: U2FsdGVkX18RH8Ti90vYC87d25KK7hCfAhJxG2rCMKi2x26oABLpGSlfe7IE8cyT08ZoC+Hh/vTp49nXCmJjpyvQ1HOQfQPSfkHYMKOiwtW2ZEpvYE0zJesw09LKjzRzJMTsv7rN5lNGMl71ZuD4VrJoGUkYbEIr1OiPVp++3TE+8IHKVGtGyeHwQhCrWNpJdEHU4jZMG2CIWtSL5UOSnqZ71AgJoiqAnu3QXNZ2+iOZdfxwsBUtLV0zstZuTzdFczEU0XzjLhMaHIKec7WPVnMbfERIykDh9K3VQlvh6RFE4xI8+r1l7FBfrvya13Sbe+KFS4eU9gareDGoF9CWbKCWhPyxz5kF46SJvN21jszJQ8MB5SxM7DWpoFMd8g+Qur02fTOc/CVVpqKUk1pvSDwoH8I3+0K+G4nzpkvvz7CfB5hOJPx6h+gPAJz9zs11laP3nDsYtFp1vc0W4SDaJPO2L0KGECYtKApHPHMHfDzX8WMKKdzY6TOo12Hx43Fp462yY1+Fwwy4nHr1UZI3WAPLhKBO8EbrU4bFedbgr1ucZqIph/Dfgh7xh8ZmOOee/kPqvRwZXBLpDBtmx3rc7qbUOZUu9klBJzjgJPKSQUHVWeJhROHUhcozw4K7wLvIpeRTWH6c7ldcKh8Zjoi9OrgzsAbMFG+JGnezq/MVfriiLtpl9qmtt16XtUfuVmVuFjp0O/xE8DO13/pdDpGeN13ldSl9/Y+FXJtldZJsGtLapomh1jdkrdzdPze2KSYslUUt2lLNo5b+DllIK/UlaDUVzRxhQ9Rh1Uac5dd43SpSOFHUiQ/gBilzXVbI8BXwM9YCanLGeDm0misBwuGL6SX8bTylSq2iw8Efvyd7zFCb5EA/q73g1+CCF9nBPcv+Pi6DR1+Ms8cPKZrBxvwLwO/6BD0xH/TTBkebwovEoJxT24Q+IdmgLwvUoJjVNi3P7DfY4z3GrqUITAPiZNH
 0H0T6t3N
 SNgAcdEnFTQ3LgfQaXSPVXiOeaqFCZAyxepfZlg2zyrsFqqsog3mGlS5lwyLIajv3ezeXg96YIbZ9d1HbgW20gzgOSfNe4CXMHzxOhr0n/aFuHArW8aXupH59dHzZ5/8DvSpVmo5D94uUEqjljkB27oQoR2UFY8Zq1hyHP68qgK3XRcA5LwQBFYEeKlWLYsCIUE2Pbw17sPSmF5urcE54kCrjSdjoIug8hp/rRgtL4WsmNnnbF0KO86/yVbPKZuMHz44XMfssGuE74vBxpr7zhIMyap4uIVT8RwoCuqGy5ERT86zb8CZqaE9xRI6aorp+DJQXo7roZDnnlR/k1D/84ijVVZ0IkPtGk6pgmPE99RJmgz8nRZPtUoT1jDkcjTS9wllvRHbonxViAz0AV7fnvYNPhkLxk07dCEy/jYbwOyHfYwpMJhjvEwOc/ieU8Dbm+0V+lJLlNiwLA9q95ZDAUjGOIu7aVwOnqd3/vvGV5hJ1uwrvjRbxgTdGBBD8jBstPz3iVk4a8Wc9FL8Ro27EXkZ5gTWt/HaV07SdFWBLk4v+YKDwXgnVZtHpzT+zzGzFScEOUPVp1Y6YiKI3lWjWAlri8qVUyeY6hALy5RTrpwx5JzCA8X9OJhibbJl2B+r1CMlGzC156EzErQSjMfUhY+O9JPR67bS5AsWZsEWOu33mIFGjll+fkJ7o31BZ2vdZufeQxdzebPDW8w003lMfoto15wQgpwKxlP54AGUYwPmc45gGjvqaCf92nBJ1+s6rHVmfdCfFkEOrGj/H6f3Y9a6q4+NmwLdTXaTKzC6wCKATvbal+YYYIH4Vrao7TuM7ott/mFYUrXFiSh/iSot+M0tTgQg5K70RZcJZJtxpApEmwBQlnoBl8Y40GEveWxyuYa6wfwi0RRRiJejG5P6ySLmMj8ihQbAFFvWHOSv1usKOFOV2R+UhXSukc8HnC2zGwxo+Q6JeikS1oOkIgNoXE447PHRc
 3VsdDvIu
 MtNFDCPSh/POXoGmNSl+YjdW+cZDKanz9UK3rpBh+tXiZnwpPG+GdUdw8J54YbbXYVPytTFWM19OE+WH5wMmEoaepFsLhjmGTbzO3ubWWYAE5T0pqHDc7y8llMuTLvS/33Oqz1nEylMxM0li22ijew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 2b97aaf74ed534fb838d09867d09a3ca5d795208 ]

The bodies of __signed_type_use() and __unsigned_type_use() are much the
same size as their names - so put the bodies in the only line that expands
them.

Similarly __signed_type() is defined separately for 64bit and then used
exactly once just below.

Change the test for __signed_type from CONFIG_64BIT to one based on gcc
defined macros so that the code is valid if it gets used outside of a
kernel build.

Link: https://lkml.kernel.org/r/9386d1ebb8974fbabbed2635160c3975@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 2bbdd5b5e07e..eaaf5c008e4d 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,10 +46,8 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(ux) (2 + __is_nonneg(ux))
-#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
 #define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(ux) : __unsigned_type_use(ux))
+	(2 + __is_nonneg(ux)) : (1 + 2 * (sizeof(ux) < 4)))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -57,7 +55,7 @@
  * A cast is needed to avoid any warnings from values that aren't signed
  * integer types (in which case the result doesn't matter).
  *
- * On 64-bit any integer or pointer type can safely be cast to 'long'.
+ * On 64-bit any integer or pointer type can safely be cast to 'long long'.
  * But on 32-bit we need to avoid warnings about casting pointers to integers
  * of different sizes without truncating 64-bit values so 'long' or 'long long'
  * must be used depending on the size of the value.
@@ -66,12 +64,12 @@
  * them, but we do not use s128 types in the kernel (we do use 'u128',
  * but they are handled by the !is_signed_type() case).
  */
-#ifdef CONFIG_64BIT
-  #define __signed_type(ux) long
+#if __SIZEOF_POINTER__ == __SIZEOF_LONG_LONG__
+#define __is_nonneg(ux) statically_true((long long)(ux) >= 0)
 #else
-  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
+#define __is_nonneg(ux) statically_true( \
+	(typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L)))(ux) >= 0)
 #endif
-#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
 #define __types_ok(ux, uy) \
 	(__sign_use(ux) & __sign_use(uy))
-- 
2.47.3


