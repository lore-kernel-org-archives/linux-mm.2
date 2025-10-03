Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4D88CCD182
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288248E0015; Fri,  3 Oct 2025 09:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238AC8E000E; Fri,  3 Oct 2025 09:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100608E0015; Fri,  3 Oct 2025 09:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC8D38E000E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:06:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 988BDC07D3
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:06:25 +0000 (UTC)
X-FDA: 83956826730.25.BBB64C2
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 37133120002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:06:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=UorFozHS;
	spf=pass (imf29.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
	b=CdfESX/NxvDcC0oeK3uX12RiQDtYxiVPrjW1VfpkHj4dHuW3Se8+bcVpy6Bu8QzPz/U6vH
	9omkVAMuWKXrg8s4ZU+23xMKZEpCvDQs/SbPlwuN2SSDApG/EWJOSnf9wMVNTH6r0QeTuF
	D/uqgj816jbSxSfQzJHQuXMt8yqV7dI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496783; a=rsa-sha256;
	cv=none;
	b=B3LBlh8NeDTzhq5qI7PwhxwFxKJaYnMveZdzm30esfh3aGJ+ulh9EcArfV46dbfnXzGfo3
	E45718Lo5TXEP9S7S/NhnnQba4JtwoffIflu2u0T501U9bkXBlbR5eTYTWxqTAQ1t4xCXV
	HSXgqzDqUm1LBAbFSsEXJOPLxlBnLH0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=UorFozHS;
	spf=pass (imf29.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496783; x=1791032783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
  b=UorFozHSkoZQuVY+eG0BwFtQQuVS0WB0vj6wXJjQ5CpPxf1IKtEKVTq4
   PwgeFmcjYSWzpQ6hNuyAf3O+aghn8XRZG9TczRD2Mu9KzVhbChNcjxmVN
   5Y7WM2B8Cpqoc3r0U34uPHFQQ2RYXE7vDfIMSeVfopBl0LzQLGchxJhed
   /bv/pRQeDD8KxGzvPphgeIDfm7r1Jevx/Zgn1TISlPLtwlNJdQdjszYcF
   IQx1UkwDbs7DrEct3C2pth0XVldF3OoS/HjUX+7wGegQFLQY1Hy4hiQAC
   Pzn0IpGLthd8t1jjXaoo1S4CBRgjS+K0nTuTd3eTmbm4jRFNf2zdS1kjp
   g==;
X-CSE-ConnectionGUID: JVo14A0fSo+OrbKGBpJJOw==
X-CSE-MsgGUID: CBqAiqXxR4iI+unB6J4LMg==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="3061520"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:06:21 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:22684]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.22.27:2525] with esmtp (Farcaster)
 id 73d2a1a2-817e-48c5-83c9-e9448d0be05f; Fri, 3 Oct 2025 13:06:21 +0000 (UTC)
X-Farcaster-Flow-ID: 73d2a1a2-817e-48c5-83c9-e9448d0be05f
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:06:20 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:05:55 +0000
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
Subject: [PATCH v2 12/19 5.15.y] minmax: fix up min3() and max3() too
Date: Fri, 3 Oct 2025 12:59:59 +0000
Message-ID: <20251003130006.41681-13-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D036UWB003.ant.amazon.com (10.13.139.172) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 37133120002
X-Stat-Signature: txpxaxxiqxfzgcpzfb8e81rxyyqh8kwk
X-Rspam-User: 
X-HE-Tag: 1759496783-609342
X-HE-Meta: U2FsdGVkX1++HeyMsjk88RGnCDiky1nd7gZwkUYaYQrjLP23V2LzOpLNI2N8qcUpOirD2ndXWGR/lz4BRqbaF+/WWNVGrITTPclna2GgDBZEzQl0EUaT0xSpmZQPNmoV2o8Kvra5p0WcOifVKdUs//GdlLG2/HxkbtzLwAtO35JFJlf+uDarszCQFvePzKAW/QnZtYLTbMhKS+VRZRrJtYXIaYixw9sqG09epik8n5KdXU/Xa5XIvuXlhq0leyVjGqtTtUNCC5yCCSZ9h/Th1aSg45tJVcFF/EQQ3R8MCApWMsxVMdVbFH13zwatrB+lY9V6QxWbsbYbx9xmMQdSCwOGRqktBjLfWha6eXiw/8hy8s+Kf9Nrf2L7E7AZbICA2htKpAyumwERlYd5uI20VyfCRtnHY1b2BdLN9bVqyf5USXu9sLov5Z8f6AS/fTbrx9xul2LDo2H8UcXgUVWWDiI5G9UgXnybZCRLuN8kpdG6up1uBnjHHtdotpH0WZQHmdGTosS7k+uKPLpzS0oSppgSphXtJ4sJhGo9rRp8ABhwWv5ycfJvvlaPUJXDB3AjiAldEejihzdX+MOI0uzjETi5yk14pg9Z2YmE0tmRMlgti34nwis0Z5pziRbvkwFH/IpI30b+9c1KYHzxUSUxt1SHvHpXp250K4dSuIpYsgsb/PLrdvVd+bNmeX3RvmbR78RrjO7g0yBl0l4FT6TRugOqk5vsRdWxKk4xcMxQCSCBFk65QXip13zb0bLyEzOdjJbCJj+Knh9VCabmFa5rFtAVS5YGMivhzCUNTVUfK1EJpWqGb3gTiLvpZJReAds3+99E45KXC6mftGv7LMEJwDc7mnpK8DTL3ri2IH4cFSO6LX9Tw0q0dSQn0z4ZtnXf3CpPkcF6AGrKWgn6i2jux7KShDfdegDyu2xQDqZQAFvJYGBet2hWjZiZp72SWqEmJP6k6bwuv+L2JMNjwVF
 LESWovXR
 YP5oVQIBHLy/vOZ77VRugd6LZAFE3J+TTDhJf0JiG6KNFEggWui/GQrkRs+0696DT7TjY2GMbS6H2/IkJgi08uWOXXhVfMlmNspDISZJrbosXnZPUr7cDfZ4UNLMHGnOrYwSRYpE8FeAQIlw2xvA8ApI9ouiPmc+dfJ/jKPaj9IS+tFCW3zlJs9gn4xxIW2okYw+rkg4X9jgRbiX/FnfLatSHhzuAI8nu0PcwsI9PC440/YKOg22KAaf9r26RjO1FF8yENYJ0tQ/n/EUxhiotF2bJbTt4Q+iaWGAHE0trSDOJZxzq2iKKtojJjw4EYDZ2nSELCBezI4Pv2CaEQV++ojOHOShWrDEP9XSzbM+dTN7oGrYZ6S6UGHRHZHgnzF/X4sHdsdk0zP/U/NMhm99rVrBqjbavATVe4+BD4wWyCOmttrEMBWzi2uLeMgl7w4uBhkHFcNWvCpcZqrDtw1xzAL4HeIfDogdrfSau1XxMHBRieSirLGlmEhWTg+y6vC16X2xY7srngBrp7mF+5Jiq3BjmqZTD7M+pQm05a4hXvsXOyZsNtPc3gasmdnNOs9l2nkRGJwmv+KNp28KkikBik6jGMjLAejKK9qZLWc+nedSzyuLvIkddBLpfB+/SRcPL9lZE0ee0kDkItUeWhsPocB5vtWLjqL/e43vMVuusU1tr3j3DMrNrX7+p0xYzo7+fL+u1UGqGUmzOEp+NdicJIfC0qCzO4E3fgORsfFBjY2+rwETOPFkEyzkmTE7WtE0tn/ewbEhQUKduIb0a43AHf99ef+NC41yJTnOugcICY9cjckDqtprUunyrm9czYoIfABOMttymbFp8n1k0a2475ZJG89EmIQXbzvPdlwOIT6QgYlyw/DDYmY1w2OKsmapDjmaOluc6raPabm8p8V61/m9gJlr+ja4H+ynQ
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


