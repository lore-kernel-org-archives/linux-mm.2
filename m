Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43244CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B79D8E0018; Fri,  3 Oct 2025 09:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968338E0006; Fri,  3 Oct 2025 09:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FF68E0018; Fri,  3 Oct 2025 09:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7848E0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:08:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3301A87ED6
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:08:27 +0000 (UTC)
X-FDA: 83956831854.12.BA9EE63
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1698810000C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:08:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=jYVqYxop;
	spf=pass (imf05.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
	b=qQzCgO/maLfT04rS6HLvDP1HF0RkpyST7YZ35LaPIDB9LpmktpQA7j5QmpQl179Eikz1v+
	2mGkJLr5WdyTK+k4vdRYiUGFiinmo8QW34n5wluX5Ft8gmubmQxZPjP5GLasG1J4Q1hN8x
	pacSgzK7ghr0tywHfwoNa97/nzvttso=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496905; a=rsa-sha256;
	cv=none;
	b=yiv/68os9PSh6PJ7jWv4jL11fAQyhLnZmobiTMbI6F2UTVfMLtbzBrYvJWJ/m6J7i/s8ns
	1p89jsZsVh7kZT5A75dWlPNDr99K9hxF2J2knVv0YHOPp0uR6FTZtYbdGakOW7OCPIpHur
	AOSPpmwvAP00FqfsuaEfyKLSMhH1KzQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=jYVqYxop;
	spf=pass (imf05.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496905; x=1791032905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
  b=jYVqYxoprWH2lE+ZF4Q8WopE7MQy7xNW44M4QyQ2EgNNR+xQb/aq6QV3
   viHCJNkxhHFI5GG1nfj+i99gPsEqMbAFYA2aSlw8/NkKh7lZh+tqIiMVg
   noVF2ztiMYcyHxSVPwBMFBBWRS7Q1KdSBCe/X0shBa4C9iK087yWZQVLP
   j1u1nNytNK4asZO9pGlcbq0tw0fOwuF8jisrtJMbVfSGXHYOZyX2b9tyR
   ibli4jdUKOnXCQFEmEssPw7W+GGougb8WzJec9O3RS1DHTxX4wv5KHAK8
   I6gGqPn3fDyDZXSfNF9/z3Oo3SOxapn+kimNnWmWT6iUfv+u4TVIYA5Kr
   w==;
X-CSE-ConnectionGUID: oCas0wOzRSelb9TD4Pwjig==
X-CSE-MsgGUID: QquCyk6DTYai9N2xbte89Q==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="4227659"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:08:22 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:31020]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.4.140:2525] with esmtp (Farcaster)
 id e36300b9-a6ce-470b-ba37-b2b1b10a100d; Fri, 3 Oct 2025 13:08:18 +0000 (UTC)
X-Farcaster-Flow-ID: e36300b9-a6ce-470b-ba37-b2b1b10a100d
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:08:18 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:07:51 +0000
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
Subject: [PATCH v2 16/19 5.15.y] minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
Date: Fri, 3 Oct 2025 13:00:03 +0000
Message-ID: <20251003130006.41681-17-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D046UWA004.ant.amazon.com (10.13.139.76) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 1698810000C
X-Stat-Signature: o4tae4pif9dkz3rrwy5ijea7bm7cm43y
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759496904-76105
X-HE-Meta: U2FsdGVkX19v3IsXtUNeTgX0MmHZUiN0a9D0TVfLIXZ989P7bYVlijOoE9s+qQo1EqvI/NXLca34/gSfF1Ff8dY+eKM0sXbIzm9OWA/dty+EkPL4LQj92AjNsb2mzF5wOoi99BvHZQdevWJ4/OgG0zkH3AwOZ9RWcskj6uYsh+bc2Y6cr+xX/5Cvhh9Pth4SN6wY7fmQrz8BK2qawdyE8L3fMGRtk+TnOWAij7FgKIDV2g3d8VQ9OHpWTCgxjpJzaGmqkDX2q3klaCN7+2b2/W61IbkBgETjTdwhRHYpQ6aTYn+dgtQdcDhHBQWtJu2VQpggzrGFjkpu60Mz1NggLVWx7G7IRJRO9eaTrb7W5Y4kYRBaHRpuYNMiotF8BIpr/RBQxTQncpEqM19MBhWuYzCxGmBijfPC53aRTPo7zVA0C7luHowBRGZMRvxVuMTolsPbcrUa793F/a7U/S0C8ChGvB9L6oFzcLqte3wgibaG/g4u18qTpXMlvaj5bIoav6i77kOdYjc2/lSco6t5AxpZyDsYlOS+3Z3XKE0ZzEmEB9i3O0sampvfpfbPv+b3LEUB6Bh5mP6n7wRfrAPt8jU3BO7xNqI1EBiDtsBCUrZnC89o6ZuhdiJVvwnefSE/PEPITY89EpOq5ql9LU02Y4YYUrMoV4gN9Ok3BYK0ratSyBNE0Oa9NiQRU2eODXt/ESWqYyzpSvuL08frlTQuVcQq5zkX9kZMLgndHELnkJ+DWYngFrWwr4nHJLuUVLXRIUgMJ0YgKmKeoV1JtDl5HajvwL9ITZMG+U56xVi0w5oLa3q4f43FBQIc5hfGy7gCoeeCmdeio5tHmyZla25zGHTi1jIMU5KsetdnfLkuVK02n0CDL/mSehfNivGlacllpWtcOp3bgZyokmZ/9f9TmEVOt3r+xwE5uurrDtJjxdlepySBED+zrr1k/WZDREr2J+uNFLm/Z4JC54kOQu+
 Nuhc+Gop
 jHP1dcmsZSSbaHm/o0EIk22JOtn6hsRR8jsAg8iMTnPgDuOxIgTQA2Pi43InIzF6exA5SePY9OOqnPrS7S0p0pgKkVQmUQJLA8Wum+vSAKLqCxy+RV8RD1VUZgpMcaC4SHX348z3l+ccscY+53oyNdQoTPgO3kafxUEFyLPZubfE4wwcYRh5MAGaJrIvUDzWEErsPmyhL2VT9Iziyap6H4Yt1ayC3CnnlygmEpEnl6aWkA0xrEKaRSTd7tdyUAHrR5ZktfjAAeTAGKnhBTVB05RNOBhCOxGDcmOYichumnmxzRtGCU3nqLm9qXbj+E+9IHwr3jLeDdn5TQjaUUDQ7+hjjdIxkKXGEVdwUlGV3P/FSraS1S3EJp7K4m+4TBoJJO4it1Scey2R4ApXBlD7MH8H6kZGCc0glNIptdm83z21VH70UjyPLOFGh7JyBl2403lu1yiOqSPT00K6HRxL4iEj/1o822fQNdGV0emsxWfoM+S8qX6ngjn5byHBgoqs/w10cquLmEdSp1j6pK7N2Q0I5B8e79ubLGsd/KbkspeFi6/KD+0Ah6Uf6X4TMx5HvdckcxuxBloS90Yd2E5XrZ+FzuyiJyapJaGj9DRlSLP2wMD1D/XptGsP2nJwajL3ffbS8Yslxx52CXoQmcC7Bc6n6642wg270MZOJnvZqH0HsKA5YesiBWtE3wR9ZQ8UUzQJDqHLtWp2+fdccL2aH/Vd84+G/hGcmY60FHNbigtR+i9KWvee81eOOaGTHOnX8oarvvQ7Mo9rMsqOOLSjS8d4SxsZUB51MNE7MygfrqkxKYJlwCW/hX0k1+rQYgbhePKfHCqFJrFc0mHPNC7wDj7bNFSOripOaafsD0cFiXdB6R5HN0O3XNclK9Kvb1Mu+pKAXcmnq7jXjoc3JCrlE9iImsboeeEPSBFzBKbWP7hNtZcMMRv6xkqP6jTkOqQh3KoqgmvRAy5wD3JPKv0r+YYXyi+O4
 /AMdWxwT
 y3FTPYqV75LFTlpj3cMeJ8R0SVWttgRtrX2YrHWehRtDTaToprmFDfI1ADwGAxZem0C4/hVGqOW4F/YoNCLI8/6a985o+riqPfEMBtkqJYAzbjPevIviCikntxc7Fb6/bz4pm4sW59V4SoAotxHpI9EyntINMbhyp57dUBRQQd3RX45tXr7WkzUepfHsf9CF
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


