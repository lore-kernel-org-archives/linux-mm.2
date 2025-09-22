Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 864B4CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28128E0006; Mon, 22 Sep 2025 06:37:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF1F8E0001; Mon, 22 Sep 2025 06:37:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15268E0006; Mon, 22 Sep 2025 06:37:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEC738E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:37:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 834D613B75C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:37:47 +0000 (UTC)
X-FDA: 83916535374.07.9E73C0A
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5559118000D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:37:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=pCIWAtXc;
	spf=pass (imf16.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
	b=epIIZod8Gm8D3QTqlngAn5KJOq69E7+sDPdZnvePyguJlpl6E9pHubg9wJb7WH3zAln2Va
	asHO8hhzTYto5jzKOk021Y6FZhl0bhsQqpniqnp4dDAUeodulg6qZwW0qa5KD1Vnz0YFYZ
	zNvPHQiHJPUu/bopwYzSvYmRHWSf2jI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537465; a=rsa-sha256;
	cv=none;
	b=aEGTXUmD6jZXda9gAM87CK0bSnbBZqBV5a9IOMH8sd+z9i4ZRNVgH2u8QzBfQ8ogaOFMwi
	N8fKlOCdFkicNQYdkNLY1/FMDdE5a8/cOD57rxBtPwnHfgjn43LSslHJFSeSPkqZwfCHzx
	TrH5ILdlSTrDOHX+x2dqSH9TgDWMl/0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=pCIWAtXc;
	spf=pass (imf16.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537465; x=1790073465;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
  b=pCIWAtXc4noJR+T8BjWd3q/1RnDA3lLUCovsUm8rOYoZQlPl7y6t9GnO
   65oQSYSYRkiUWgQVpuZw68w1+cJLHqSb66eaPsKGl9mkwwfZb+BlPViXn
   ZOW+ikBjoPZXd7u1RN2fSIGD8DJKO8pYlnmgAc2Sd8wPGiMlF/8C5E3xJ
   xF3Surf5CkyZKYKCoDy/yHcmZD6BFYll6mJVSzz6YHjG6XdcGrGuxinl8
   lE2xjKt18KwVT3HNfdd5f2DkD3u6PTgY4FobnqyZDOVCxBLXtQJPqbLUu
   UaKnrnaphw3gZPlT+hhOtDrUHPFUKA6vrgHU0en+/AD8r3Yy+Vo2Nze3B
   A==;
X-CSE-ConnectionGUID: ybwv+TYrSb22Qw5bPtnI3w==
X-CSE-MsgGUID: qlg/Q2pRRv6wwCq9dlWYcQ==
X-IronPort-AV: E=Sophos;i="6.18,284,1751241600"; 
   d="scan'208";a="2474156"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:37:32 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:28149]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.3:2525] with esmtp (Farcaster)
 id 7d7e2500-de3a-42f3-a9a4-a3fac983dbef; Mon, 22 Sep 2025 10:37:32 +0000 (UTC)
X-Farcaster-Flow-ID: 7d7e2500-de3a-42f3-a9a4-a3fac983dbef
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:37:31 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:37:06 +0000
From: Eliav Farber <farbere@amazon.com>
To: <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
	<johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>,
	<mchehab@kernel.org>, <rric@kernel.org>, <harry.wentland@amd.com>,
	<sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <maarten.lankhorst@linux.intel.com>,
	<mripard@kernel.org>, <tzimmermann@suse.de>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <wens@csie.org>, <jernej.skrabec@gmail.com>,
	<samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>,
	<dm-devel@lists.linux.dev>, <mailhol.vincent@wanadoo.fr>,
	<wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>,
	<markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <pmladek@suse.com>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <minchan@kernel.org>,
	<akpm@linux-foundation.org>, <dsahern@kernel.org>, <shuah@kernel.org>,
	<keescook@chromium.org>, <wad@chromium.org>, <farbere@amazon.com>,
	<David.Laight@ACULAB.COM>, <arnd@kernel.org>, <linux-um@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-sunxi@lists.linux.dev>,
	<linux-media@vger.kernel.org>, <linux-can@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-sparse@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
	<bpf@vger.kernel.org>, <stable@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>
Subject: [PATCH 08/15 6.6.y] minmax: fix up min3() and max3() too
Date: Mon, 22 Sep 2025 10:32:34 +0000
Message-ID: <20250922103241.16213-9-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA003.ant.amazon.com (10.13.139.42) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: 7f748f7idsbhwfis7o64nqwtwfomhe48
X-Rspam-User: 
X-Rspamd-Queue-Id: 5559118000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1758537465-757618
X-HE-Meta: U2FsdGVkX1+nvi4/XNraTa40jDCnM8hK7pUColAy5f1BiZ3BIZc8YUrDyGv+qCOjkcG8yZezSC0QtKs0bsQt6iXAPg3ieoeBcIdPlvWUJf5/81vuTuWrpqyozsGZ4VMt9Ufp0TiBzxt7WlEkQMNm8WUPdzu/ez9WaP9C+Y/V27qSUpPvNzjRFSTACiWpfYJxW0MdXA7SF+r/u4L5W7/CxaObJyg0yRfpzYcV+UvngNz/YDOCwWa4t72hvxjaiRK4RlIlws7ncyXy3emkx59zVfVjG0/w4vhMSrxfpgqp6gTYA1bpns3/kh+hcmft1VU8QtW9E93QS8ufJ0+nqT7uVyewL4Z+2uKX454E0Fsdb4ikd2flR+mW1JduemT8nzFJYLaiobE7XbG6naIU/N1Xv1+3kXulERV6kBpol017LgJdk58XTOZr3GioX8eycnhDXdZ1Rm9w/LOD3gL5U2By5tGnDKXeG04w05edxzhOSVyc4fiAzQ+W7vGhuYDwsqYxOga94Fn8/CHdEMhqgxLFbRMZHbR0B44+URL9UARjPZNF1QRNHuj0uOKznnBJw9iiGx4M1Y32+ZtR1VTZbw0jvIZvUhYRQORJkGl1V3+VjhjQmCdq/eB/66JA3O1GxzoSE5UEgH38+u2Wvk3SFNdvy+/aN7tKg+JfRN7EI9EcWiRGO7m9Ot2l0kGPEaj7YNrnbqbxRrwO97la4Bxx12KXPVJpP6cTsZvHhfHe/s0q7KZEK5UknaFpfPv3HvXVZnh0zOC3Z/nU7SEbxGPeiDxf1XAENoKK0T7hi30SILg448EsGHCbvBa3NeRNvHNQBabIJnMQclqB9+V1Ge1eX2nnCCWV4ZQy4KL5HAoiN5nv+aKNV+t//KNhPlmVlIpA/Vhz+u8Xpm2Bxtz0B77NHiJj+VypVggIV/PSHiK5MDVZQOYa7p1wwXqTfGTg9YrXbC0XiDlPl36J+vFPPHl12Lt
 bGSr8jLE
 x9SpR+Vth6SB7ma9fe5PUIbSRVOdLu+UCEeO3MEBxygo35da/IVKS34QjsrU+NtobrdgtQgcaxcDvxWta5Zd5PuWTMmrEvvmD3IEZeh0UEOBQz3dFkJNy1nEnBQ6k6xgnr8r2O/70AwabQWJ5WO++3kKkgfSl8YWnU19sSaY1QFY1ry+jTu14+vIYMjN6C3CC7jlzPn77DlEejJSeS4+LTeQAe7oqsKDqQTPqHFvxOHmV0GfFfhs5kcw/t6QvfiKml+ayHk10FuWJUjc7TmdOYB3dck5DwCM4aFY/ZtU9FBkEMR7/2uBW/SjAITDEa2ITHRPlF+/z+z9Jk8YxYFabj5f8ne25qgsAD4WNgNu08PAeCU+2jKHEbx4PNQZE3IsyGkRDi80cGBw7YtjcX4BcBxE+OSqBfRveGG9QX9Jfh/phvWbL77QRiWoqNWO3ePqeV3VICPmtoRZ1DpydSgJyZ47g79ms75KIdNdej0gosIykwEpaXY3BJb5duPnIYGShdTamlvMHLxTOXzjfrXBU2j8lFqouyxTGRtLgWPAKGyPwiI4=
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


