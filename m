Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98353CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0518F8E001D; Thu,  2 Oct 2025 16:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029218E001A; Thu,  2 Oct 2025 16:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E812F8E001D; Thu,  2 Oct 2025 16:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D60908E001A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:56:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E24F1A063D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:56:06 +0000 (UTC)
X-FDA: 83954381532.19.4A6A40F
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4A76840004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:56:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=eXjrWVC7;
	spf=pass (imf04.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
	b=5yUblvKXUYWU4pvpQEdZmXIZ13UL5CWNGqgt9mKcggn9ezCzHRoiURwv/T5G757Gv948tT
	wUkaTsoPcOzkYx7ckDOl++OhmdByp9GdiOi87SKzSoguQ+CuWjXycEKDXoMbM+rBLM21Vn
	WBgwoX+wUoRo+7dQDXpveQhj29V1zaA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=eXjrWVC7;
	spf=pass (imf04.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438564; a=rsa-sha256;
	cv=none;
	b=0Vml6d4xzMPLDGCCjQ6wR19iFouON6PzH91qvvzGwCgT7SGe/3JyCJnvQzAWjTBUpklYUV
	7W/lgKsQdDhYgqvxt682AoDJ6G8bDeXPHlcJXQRX9sm2HwXXmkyHS55NR3+QtewEcjjNrd
	rZr1A/BhN1geusS5QqtqbNhc5bOz7Fs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438564; x=1790974564;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
  b=eXjrWVC7pQAmmqtknGwMTEIKPcgnqUrynKKoeeyik65SsKgQMXMhDyRu
   OKWQEq0KrvUss1ZrN39Sn5dA4i3uP4A4Ip3TVqVfNS29G+0YD5XB/Dd4b
   Gg8OycExfS2UOoSBnybYTkw8RQEKsryMcTxRV7yfwAGzDk3XS3W91+VBw
   COthpaH63nZ/+SyyQbm3S04uNHbaHNX0RHgq+jYizKKCrOId1+s+2x4ZM
   cmt8opamwRrR4G0Ghej8WiyUbkpEAbjllp1xKPwuEwHNGt7vEwWO5ihQd
   ir8ntB+NiFxpIgqOL3cpDk5NTTWJqBFWXXiK3bRlfA4MTWAIyFkuxV8P4
   w==;
X-CSE-ConnectionGUID: 4o/MF6eqQCqoBHISDbBwLA==
X-CSE-MsgGUID: d5i7K1K8SCmTe1qKPRQWzQ==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2924638"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:56:02 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:9194]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.22.27:2525] with esmtp (Farcaster)
 id 526e6cf6-504d-4beb-93a2-65a6652871d6; Thu, 2 Oct 2025 20:56:02 +0000 (UTC)
X-Farcaster-Flow-ID: 526e6cf6-504d-4beb-93a2-65a6652871d6
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:55:59 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:55:33 +0000
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
Subject: [PATCH 16/19 5.15.y] minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
Date: Thu, 2 Oct 2025 20:47:30 +0000
Message-ID: <20251002204733.35652-17-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 4A76840004
X-Rspamd-Server: rspam05
X-Stat-Signature: dkpkr118hm3oebaadzxx86y4aaigsyid
X-Rspam-User: 
X-HE-Tag: 1759438564-69755
X-HE-Meta: U2FsdGVkX19ambVTzUDxMuFbyu+9h5RPqp37GBvsGtoRiEPhqf97bNJhpN3vzwkvUMl9rws6CapjhlUsvi1CIMvv173VTjxTovgjwJgE71Rqt8VSA5yACRj7tOUFKS/U2PFLcblsyE9i1oaTUwFqMGM2wsZx/s1eHJnz5VmJ2yyALKioCFQvFBjGWkEaiCpWev7mh4/f8tHhjQk8m60V7PxfRSYt7jBHnuDacykibyx5xB5ugshqOXStgt2BkuctfkKtaXFPYsw8cLhpgZXucXK+FW60OMRkS9PKPEeMmOboleiyR5HqSw85N//VUAEz0rLhWkWJZpdFjfe7QGdtqNGaoESxVQnfyHQM7Q6jAHFyFWc3DFHSCR2kw1JbsAMHiIHXYGCyd0P4QR41yw0isxoN1oSU33PUqcxKJffy4iQa6o83G6H9px9NsbAOIyRjtLbV/dvxXy7VsjqdYhhXhrv6jxFCMq0MTryrZD9IZoTV1GiVXNaEE5CxwkV73JtkRq119fdGTgR1FREXxVSUs5IUv7BQD4gxiUhi6irye2X5A6c+bEPLFTe0Q4a3lKkpsR2m5zDq4gmGavr5b9SaVdAGmRNAj1OqYP+3y37kDCqdfkfahO8OBet9eoJyV95MGdT6X0hO7a7NS3m1HMelHHxY0upIulbs8YncpGYemh0TfKV2yPEUwFyCWFyx5XHW7aOoLpmSVMvJXqshleAmzJHOOIYck1rbyB9ySbnA/SYth5y7KKuyTEvOiqH/BNiDwpjrzxXsrqxrrOIU9+vRR96FhjdMfWAMCGv5O51owzLdyGrcvZGWWJrXfKiXevwOwWcXJ1juPp5+K4qXTAEHd/0LEB9LC5tPphf4OlsUmfKgs2gY8wQHzeoEURRRszBX1Fenuw15xDS45e6dLXUAPksc8ltWGTi4gxq+F+G8yLj6bb5dSCsorOLsJ5sORqxyTJ+0/REQ83EXyHdnncL
 1G+Jr01k
 zqNw4netgwpG7qJ8kGtOeJKjpdRQhnkq9rkvf7zVAgyUEsz5SWAbO0gSSPDBNONXHo2jBRChPbRFU6si+ZbZeSo0ho46YLooBA76esycWjlgF5LOKwOgyNNMzRULP4OsBGoakXbVtvejSHXTZaW4MJ8qeHXFTgEGRkeN9Dgbdkjb4KfouxhsxBkDlhIjTpG+6ABO0INIxi1qOhyPJEi0dHX294M5WjtFLUIT0ooUr/Ohh2XuzWFNUCEAjtdcM13nEmymGRDfN1sThkeKTLbiW2FrQ4GqYWE19tR5AhJKzLPOjj1vteMh8F/jS355oJkShj1JKMNvsearjnAp0i2fGR9BigI0BdhQaT9N9NC3BZcMthMU/bUxodt3jUAylgKyfPXCBlKUzj2G1GvNZI7bbtmS5j7BRWYPzZqalvbkfzkBZhYqHgP5RXMVMT2cquprWZwAQs3urXd7i3LgtgRJjmc6d6yZM8WgHgOCb3p74IJoJPFv6Xwrm6rqP0rGvy1EEKhDQ349OwZHCDIEfPFdQhDRZZ/0FzUgulNN9Pz8Hc1IAXeXtE3FNR2Eye0LMXoeTy6VKFED2v4dxxjeJx8BoLx+9TlC2CP67UVw9mrwVIpvKLfxB2SOFvWTMTv1poy+BiqXWw84rlvbbq+vFhAXcyUNXNUGTMELLN3+ruTQNgTEk5dDwcWN/iMCHLbmXjOh375wOwwHvAwABBzVP7AqGtn9/tvluRxm4c4PeOiqPb4njDxoDclYzkOSZ2NCHBhJFd4QTJArao+XF6KinQpJ7o0JO4YuYp6pmJDUoksucEqip5er2n4jgK38NhH7uTS1zpCJf9PX0LABU0pLiSoXxwuZei+QE6xtTWhzlM53ldOmjUc8GgKnd6mtFv0av6pcMRLrPk4eNvOotG2Tfjtq9w6dTrbPJ3EmCZLN78ek85EXa8m22gmIQUdTnbhwa9Bs4QusWXRE51JkSzINSxl5ZmEEjd0xy
 XoxhEadD
 5LIPsr14xZNPwYUkspEnMkcaaM4ymGmIu/2tp5WVuW54U8E0fd5/Puf9A8sITlQgJgXmk4xoKTIxhwqk1IvOxy1v3IPfOWnphZwIwyM/HdCSaOUqWBBPvMHU29QdPXWPmtA+e9dhTZBDd2c+5lwDv6EQWqD7xQ5AbA5/mXVfqrPm1njSXZoTYlk2LVACTd5f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit a5743f32baec4728711bbc01d6ac2b33d4c67040 ]

Use BUILD_BUG_ON_MSG(statically_true(ulo > uhi), ...) for the sanity check
of the bounds in clamp().  Gives better error coverage and one less
expansion of the arguments.

Link: https://lkml.kernel.org/r/34d53778977747f19cce2abb287bb3e6@AcuMS.aculab.com
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
 include/linux/minmax.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 6f7ea669d305..91aa1b90c1bb 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -106,8 +106,7 @@
 	__auto_type uval = (val);						\
 	__auto_type ulo = (lo);							\
 	__auto_type uhi = (hi);							\
-	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-			(lo) <= (hi), true),					\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
-- 
2.47.3


