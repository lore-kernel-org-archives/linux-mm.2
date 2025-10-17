Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC6F2CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3738E0072; Fri, 17 Oct 2025 05:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173B68E0016; Fri, 17 Oct 2025 05:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0143D8E0072; Fri, 17 Oct 2025 05:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E1BD28E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:13:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2CE71605DC
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:13:54 +0000 (UTC)
X-FDA: 84007043988.01.E6361B1
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf24.hostedemail.com (Postfix) with ESMTP id 991C2180007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:13:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=PgKiXLrM;
	spf=pass (imf24.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
	b=Pa/kksumJnC9mwrmHJ0xKivuP99B+ljdXWmBGJ2PdGiOqdZW53VK/5tuz8N2FyGhJSvW6C
	ldMZ2Bt746vHw7Uoo6PEa4VJ71oQIuudohihhOVoD8oXiAkoU23qSrmhQwwmTa16vbndB5
	GSFH/35v4xu11fQBB3/tmd2MK13Am1A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=PgKiXLrM;
	spf=pass (imf24.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692432; a=rsa-sha256;
	cv=none;
	b=7J9cPlb20qFEh5ftZwMiL6lAFdRNacn9QZxvfgLlSCVfB7rpmpiwbyuA/CtLskcHmGTZ42
	WM2FEJxOMRqencSY5I6ip0paRXvGsa7nj21dJGxx1e/ynElIX1XHuAQCwUHhL7qvZP6NI2
	ibzCd+DU6yVdSx/H8QU5dOoPbluU/co=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692432; x=1792228432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8djAgabF22BDsxfYcNFa72Q6mXnC3doUyHk+thXHzBc=;
  b=PgKiXLrMGSIXvyqXMnb9mBPLmUQtpPMTq+syawkNDNQNJR48Apwj2dM6
   8zIbNkamx9Et3URh6TndHTHoEUcrSbPpXma7Q1J8+7RI0p3hctN0ynozp
   F6L3EuY+JEkGa/4P4IOu1pEIzhIybDzVzaV9N4h8pqsQYnlvM46MjQbGc
   SHvrEwZ873Pab8Ax2LVrR8ynSKWgQT3YyOBqgt8dnEsa2aItfmhQRgZaH
   P737e5+F2yMWNKRWJZcPbTIVJgdleBm+WXqmBr7dW3UIZXYMz529qzASJ
   +LKLr3kTFUbW4Qq56t0YilIKi1kLqGIG1mOeSzk6B5OeC8TbjkrriUncN
   Q==;
X-CSE-ConnectionGUID: 9N6uYn2bT8mKwtWQXTK9YQ==
X-CSE-MsgGUID: cX0ypPr1Tt6abq1HoVUo8g==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="4878275"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:13:51 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:5770]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.61:2525] with esmtp (Farcaster)
 id f4912632-f6ea-4d01-bc73-ced9f8ee5846; Fri, 17 Oct 2025 09:13:51 +0000 (UTC)
X-Farcaster-Flow-ID: f4912632-f6ea-4d01-bc73-ced9f8ee5846
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:13:41 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:13:25 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
	<linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>,
	<james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>,
	<sunpeng.li@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>,
	<dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <rajur@chelsio.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
	<joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>,
	<hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>,
	<chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>,
	<yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>,
	<herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>,
	<kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>,
	<ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
	<freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
	<linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>,
	<linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<tipc-discussion@lists.sourceforge.net>
CC: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe <axboe@kernel.dk>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik
	<mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Subject: [PATCH v2 26/27 5.10.y] minmax.h: simplify the variants of clamp()
Date: Fri, 17 Oct 2025 09:05:18 +0000
Message-ID: <20251017090519.46992-27-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Queue-Id: 991C2180007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: yujasojhu7gckbdrxqzumqrthuu6km84
X-HE-Tag: 1760692432-621848
X-HE-Meta: U2FsdGVkX18wNbZJec2zwi0Bwwi6IC8C0cF3D00Ba0XIGNYO9jhhoGXh0BGpQukQfp7KiQvOX3qKXCqQURckJ4P6scI8dLqvx5l6eDch2nvqWs00w3aIcHoLuofqfvuKGC83ukls9jlJQkL4Sx43BVFC50KV3D4wdeEk54B4e52otcl/n4M0Hu0Q6MUSA1XNJSp7V23SMzZa7HpuBUZQxtt75nWiAM3kD12KFKZBevyoqxm5p9jEVLLUJ2IS4+xQJ0VKj7bfEvUf5GNdj/Vtk804iAGFq1XNY7Ewl+6yPCVp261aoYja6mjZWUtMEZ/t+EhP8L55uYC1C9ookr1ziBO2FANPbV/NEFmY9Sc2fj3JT26SIUYxx8wyXDQ1IaSO+uJXjda2SR5CEatp8GW9Jui5Z9jOOLcxELyidH4Xep8JaYP2jeo7I+hd8e6btexTwyqqevmEOf3rjBIDEdvQaYgmwUGH12zPIYBqAxMwvtHF67Ey5PB8Hn64DxK42RLvHZQAGtAyfhL0lzCQoiV4ZaVHiZ4ljj/maXisPJxHRyjOR0gtLWmoQ0TgOhM30NM5WTKb/bNQVzg9OVijET67foE0Er/AInR2SEjBoqwfp8Tm1S8HHICvMExpvlbDkZ1J6VMza2nMOu9aBNZ5qa/UHccmr4G0FbntBHAOeA5KUvtB7Pul463IJTsAV49EkIBxDm73WVu727VH32ZBy3hvObCqvtg9ntRZRMTEhvS81NmNfED1dC1cjmrVd9zP1GNiMymVC8H2iolPB70XWsPdEfLk3qfnl1SkrU2nh4kK0KMAeY+YBhAgCHz6UIrIh8tXSdoy+b017QkVwsqJjMvwlbyE38ZOUaS1XCEENnNtcUArPNbHSRQU6F8ohNrH5X+j/JApwqZOXwqWWc3i5SJWsNfIzQKOdhMDx8shd8xZGIPyG6mNgwneTxu/miEuoKZXbBXRFl7jdA4dp+f4ydi
 D1G+mTj1
 JpZWyNqZyModZsXdJXeeDbJz7s1cxMpCL66xmL4BVkLvrI+/5Z9vy5w7KHbze9wrAmh2wZvuHKokM+lU6WRgJQX7zGJZrZYshMEeiDfc+ev320oMvAvizWN7HfEW1W61YQbPQVUAtAfzMJmVDfoJDgmaSsKoF/OU5NUQ+ZrMWlJrFVMbelaiqcFLlTWMY77czNr1IaH7sFP2kPB9c9VvYwqev6QQjfevFIhKSbplRrJ6GU8aEa+/pnsRZyao9erWzzyrIVZxgEm7QGbLXK1fnLaCM17XZGU+OhWL4GpBLkTcG5t4tbcVE+DWPqWQUTWsHeZysxmgyV/jxxK38ttT/TRIcSgWF8LLVEMhkupcecJUkPGVYUC+XdJec5W4LIvj6bZXuOH9bZJ9kcVCpqaufXR7n3NMymGKISYc7eVsWdnf+0BSp/g8SkV1gD7HBtWUbLu1z6Hsyyjtnj/EXsVePGo25YgF4xey9Y871ATp8NuYB8Hi/XWLzw5Mc7qdFd9jAKVjpyeAIGes2rL3FNEKyJOGPgcwxjM6oOJsNXUafqkcsLm/rTDJoFB+7BV3O50oo5IR6eVd21wGLyCUVk3aOtPh1VsgUaeVB2woBeM06n2fe5MDoS3TL6HWqYiIvFM+J1ron3hgxWm3cmgb0ilGwuGieBA4yyeLf7/ukftVv46asSrBi4nFtpZu67AD/yyfYlumoNnTJhvDbJ+RE7+C6+4LeMX+gpMshFgcfEvmiYOGNZxUs8ywcnAuuDsHSt6nVL+FauOwuhihfrm6BBoHYUSOcwINf7USo14GzFG8EuVroAtC9euCpcyz1ybkuuUudxAXAOZAauih9ncz85lS+GDccfU/unWI2JqqsA2kZcuUNSJWV307/opIAwsPjDQiwWP0Lqme8RsewhRk5iLmg80+scfhbsHtZIu+qt8Lq6ArZcXt5yE7UFmlMOX8oXwBiXunrB4i6VTLjGK6PphkXMBsVan3M
 maSR7GFK
 Q5VmsvxiunaXfHi2y4WezkVmYDNWqKXE3A5Y+96Q8mlu7T6J8pfuF+eRBS/JnC6JmljLZzmyshEq8XrbyJmajvvzldIB4fJezxuC3Vjk4miCNOTXTCp19wrUe4djbo7q3kwdgFeXybMM8eMSLf0hbMgSwpWDcb1ArZSr9jNYVprMJ9AVOn9r5uRtrvzJxfYCeIl8Ugtstedkaq4hFnQG89ykG1QXXGlhINkbBTC0SuWvcYtTqmzvSssukNJNWztQ/6Xig57CUE8i4aW1nz8ihgcCK0nzh0ly6J/viLqVhQOhloI5YueZfh/VExdhKSHEC9IWVa873wl/h02RsTenGrranlvfzYgbe5CqvXnE3ZvCchJ/slp2pcEeC7jVbjcHHrQ09o7kkAd9VTcj68noR+df+AGvx95yRC+hg47GDFuxen+9LJpeYa/nxvBd+/9lBkl5uLfbshaux+/QMZsKlgCxlwJlL+jdX3WVqJdePoHC/+nbEppTaHTQYPQFP6M68uJDlZ4OSH5tu5wk5RXutI/ayJpG4wzHOMM0TdEE6zv+B780WgJHOREMF4LWRWKnLKXADZIwbkCCZzdfTchaaDiIIkQm+zxfR4L/0CsP7WE97J/Yqt/WXS2InOfixiG70RZVWA2d0IPR4VHcujab524is+0Iu7ZxkTF4D/bdJMV/1f+Lp2MWeZkTSjTxUOzu6bs0Al3Ckx5o8OgzqBnxPxJJR2OR7QdtBt5tWBFz30I7YGJqzeON0epKQ02jaA+qqccoK2dekkY6ocUOL910K6a0qUF70CmYGac3ok5CZZFBz/Q3dKouavJx+V1LYFIiYFgcEpNCiFWM6BTO2gv64N6lSPt3+HFaJ5qywOSnHghpnGUNFQoPq1Ki9O/jE92i8bDLqA/A6oWdo63G+owsdVywU63acljEfITbZcf/vhDnE5b1SRXc6NMazQ0G3oY2vE7XuxSaRMS1Oxs68YOwljvFX+HbJ
 nNfmztgt
 gkNcZZ8cl586STyF3iV2rfn+HpHWhzkCFMJ6lLC2LjzhejVEdx8TUsu3wyOFPQSHnfm5mIe+IR3jw+D9DPIrlknxh+uRTzgMdURJW6wNL6Qq2p3otS0oZ305IsFTl3Ge52BV2kTW0/E/mpIJCsuid+mt9W/OtUFhP+ZUzBU9O1ZRTCiwSnjTXImOlgxgJjGGE4H7JkopQEMGFceUC1ZlSix+7gJE3+DsTM3dqf80X6D7PLziOUyvtXQR+Z1H3Nk1KNeW4K9N44jRmInlQ37qNQteqigHyH4/KV4PIL4okNq/A/hymDoze7jRAUflscWNHnvTGc6j7N3mjczuE2L3onOFaS+SMcKLCrkiHo6A3mrxc/l9vL6Hl7/r0rPFrsXnrUps+Lj9Dc2cjMpp9jF+sc/3+RwVVrkkgaA2cjQKKoOt1eHeUOGYNamTYZcuioX9sG0Dpyyd6p++scD60Dhd+am6HNFKwhSj8RO4hjB7U93bvk6EA97H1h4NOh2AGkm5QokIOLXLtV6u6hc2KcGy4SSzOY07iUSGpqiiyiwjDx0PX2HLG6djTzFbDcvIdcqrRd30SOZuo4iKOVQFaXo7UEuSfce7h8xKwvNfikYoGRn1wOxcw5Hs3Ax43Suinek+cv3JkJj3FsJjljbiPRUf048iI4H+WIdSH1p4UiAt0Jfto1a1aUbrCVsjEJTgPVUE64bxxYrunv2h08gQ89eOm/RSE4E1s82cquJieUPtkRfk+3OgHxl4hZ3E6ZAiHfbvLtir77vqck7nvsWSw4jtN3DxDM0MXAdnkHKkKgfil7Httk+zen0uwK3rruJx5RX9TkUrRzHRjoICyGJ9UobbiKCm83tIcVAcZzTHT3DWQGO2f5iqZaBseAJyPhc2xp9w5xsOPMLb30bJf+DCLUdGB3eLdNUy/bTwnzrGiXRVqf5o8ZbjU2WiE0diqDQbiREldPhXiumqZmTy8xpM6UZpdEszE5ZeN
 hGTaiU50
 xtciFKdT1a62fQ6btU7bmB6KIkBCfklAVbolr1IDl9TYRwMi+IYYaobuMP4g7pVyB3Gh9OqMgp1FRGDX78LJxuYcEZ8OORXmUuyqv3D1jOMCpl/W7uQngu9TFlbv0PJZxw5ozj72g69+HiK6Qd9rFhY0oMUceyj5+O7eN/ocepGuSShOX1kHvKjURmUPuSnpteeat5kIV+uZftAVy/cQeb+K5XLCZfz4ryDdNsVrrrfaF6n9b9d38ECLdPtB8hTuUnTmAKw4GDGo94j9SIzQ7yiLqNQD2jSAPUr/3ZWv0o2U4p1tsda4zi2KKUD5BIV+21lgnnrkbTTVneFZpXul27sAl9v6IieYV1u5K7Ytlzqnfau8AINXvizYdqCvcfY5vr8Y9/AiOoCelR+b9MxNt646wsL14GAzQssO3V7dPLP7+VG2Lu2JFy04MRFZsbHzAigdPsfe9v+yF3s6xEkhh2PJjL0q8Ahu5i4WpJX7R9XtOwrwQgWbMoMlJ07cWm5V+t1ioa4c8IGyEMK4WdLn648KdBYimKxRQo3TDGoyuSgh5pcKRn+9gZH9GnPrgPVT8XJuJ+UhpIeMNgPE8CsJEN8chL2g84uk6pxH8WWWHhaDvIr8LPAxKPdPKpO76r83PvBFAwgJH4CFEdmtGORFplR9ywh+PAk79iAslkG1+otnbtYkxhkDbWVkVexcBAwig1ow/mR8jSPzOtClDEwe7YKdS7tIqfDArKZjrjxP5mFoPyAB/ntsqwHTw5a7l33ZMlstP9CGLUHzG3f5qNveJwnvcVIeIpMpn2y9iZBwryVRMVnV3+M/3t/vgpg1SFtC+izxEVIKvH+O9z3A8zn9+SOEkbxtzJRhddwFUcWHBNi7pB1X+xkHoGxg9G4Zt8XtJ5pOaQexQat5H+rYxOJhHStUupEdOG2oo7cZ3s/2bIFH5maOc56Bp4zlBxMPAmGnUE7G1jPyxVbywci41UE5JInwrJhL4
 pNChaIkc
 kxQpohlUoECiQPQl2CTSiwRWf8TresfYqNV8T6vtzY7vC98SIJXZCAFvCu+1olqJhG3qYF/9t38Ut7/9XBGQWEJ3uz49EHeZkMfD7mKIiXxfSoWdabLlGFeKNjAO3fN3I6nv0nivD53VICSQwVeMxUWNCgaFA/GbpEKJdjfK15i8Zm5pLNqw7uMKCb4/FoKtro6RXoTqOF7Cs07nbZnaDMsqlDnEf3Ng1F9+JTxPJvf53exF1M5SS3qfMchSjRffN8N4zpYE+rTqNWygntwVc+WBPyBhDZPiP62KgYe+DKZ1lXes8YJDSAYtw1rApbzQ0sE57Pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 495bba17cdf95e9703af1b8ef773c55ef0dfe703 ]

Always pass a 'type' through to __clamp_once(), pass '__auto_type' from
clamp() itself.

The expansion of __types_ok3() is reasonable so it isn't worth the added
complexity of avoiding it when a fixed type is used for all three values.

Link: https://lkml.kernel.org/r/8f69f4deac014f558bab186444bac2e8@AcuMS.aculab.com
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
 include/linux/minmax.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 75fb7a6ad4c6..2bbdd5b5e07e 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -183,29 +183,29 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
+#define __clamp_once(type, val, lo, hi, uval, ulo, uhi) ({			\
+	type uval = (val);							\
+	type ulo = (lo);							\
+	type uhi = (hi);							\
 	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+#define __careful_clamp(type, val, lo, hi) \
+	__clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
 
 /**
- * clamp - return a value clamped to a given range with strict typechecking
+ * clamp - return a value clamped to a given range with typechecking
  * @val: current value
  * @lo: lowest allowable value
  * @hi: highest allowable value
  *
- * This macro does strict typechecking of @lo/@hi to make sure they are of the
- * same type as @val.  See the unnecessary pointer comparisons.
+ * This macro checks @val/@lo/@hi to make sure they have compatible
+ * signedness.
  */
-#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
+#define clamp(val, lo, hi) __careful_clamp(__auto_type, val, lo, hi)
 
 /**
  * clamp_t - return a value clamped to a given range using a given type
@@ -217,7 +217,7 @@
  * This macro does no typechecking and uses temporary variables of type
  * @type to make all the comparisons.
  */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
+#define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
@@ -230,7 +230,7 @@
  * type and @lo and @hi are literals that will otherwise be assigned a signed
  * integer type.
  */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
+#define clamp_val(val, lo, hi) __careful_clamp(typeof(val), val, lo, hi)
 
 /*
  * Do not check the array parameter using __must_be_array().
-- 
2.47.3


