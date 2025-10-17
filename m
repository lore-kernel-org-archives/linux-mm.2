Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90C04CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93398E006F; Fri, 17 Oct 2025 05:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43288E0016; Fri, 17 Oct 2025 05:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A3B8E006F; Fri, 17 Oct 2025 05:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC1F18E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:12:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6185D1405E3
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:12:59 +0000 (UTC)
X-FDA: 84007041678.14.F5B3A1B
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3F26E140007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:12:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FrhR8d8+;
	spf=pass (imf23.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhepguEQ0VZAS3etCeAAj5D/xXUqupnQ1wf0VPifqWY=;
	b=QvetXDhwpRb1kyK1jJEV1ntVAiytBULnp8BD9YaqZRmSTk01aSAWauARJl9o6kf9ijgxos
	vUN5g+ZnL/0ltjvdsDbxMhe6LL7TB9NaPYsLz6J4HWaBBEQj2h4+zR7gA2WAmSmzP9RcOa
	VN4p8YI2X3FJ42HfVRY76E8fE/ftNI0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FrhR8d8+;
	spf=pass (imf23.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692377; a=rsa-sha256;
	cv=none;
	b=S6N2VDXV3whpnXHJcxXNJDU6O5EzPm4lOGOww3qhxP7soLyBck0OPXTwz2NgMnnoW+lqoy
	PIgOg2A6PDouvRCZjkC9+/sr2kqb8bpes8lxbVqUT2p/NyO33OOlVqzhKigZu40o5r5neh
	8BHPPV/uEbI4zXSATpOfv+L6QSxubL8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692377; x=1792228377;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FhepguEQ0VZAS3etCeAAj5D/xXUqupnQ1wf0VPifqWY=;
  b=FrhR8d8+4KaMTX4ODPJ5cavIHKfdCwqLibkrlFbFfmP/+N1/r/3JRrza
   v2F1wSLDVdv9/kFaOLNmp6/6Wxo5IXstBo9YHIGn1KMJt/s5djqFUD1GY
   /8qSVPhofsLrv19ob9QboMUDaKF35Ib/IQpkJfvAxpl/QSLalmY2OzdHW
   rGzBG/r2rF0v13FKlxT83CYjhVNLKt+Ilpmuvj0NMfCtj3EKtaxp1QKO6
   l4Qd55B+MPaDE+PpdXtz0tLlsmw5sb69OPXBphOEfUTMGyvlYyeYkVfaj
   HpS0F4RRRvZl0PsYRBqAWdY4T9BJjqyIf7woApI5wO5u+sfu1cRENjiOm
   Q==;
X-CSE-ConnectionGUID: 0cfG+9P7TVqqkWZRtcLjSg==
X-CSE-MsgGUID: 2bbXtpN6S7eCK3lm7W82rg==
X-IronPort-AV: E=Sophos;i="6.18,281,1751241600"; 
   d="scan'208";a="5073680"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:12:56 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:2557]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.18.50:2525] with esmtp (Farcaster)
 id bd6808e9-5cac-44f8-aa91-1626264ae0b2; Fri, 17 Oct 2025 09:12:55 +0000 (UTC)
X-Farcaster-Flow-ID: bd6808e9-5cac-44f8-aa91-1626264ae0b2
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:12:43 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:12:28 +0000
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
Subject: [PATCH v2 23/27 5.10.y] minmax.h: reduce the #define expansion of min(), max() and clamp()
Date: Fri, 17 Oct 2025 09:05:15 +0000
Message-ID: <20251017090519.46992-24-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3F26E140007
X-Stat-Signature: 8zodzrof55qk1g8ruey79z3s9yfb61rm
X-Rspam-User: 
X-HE-Tag: 1760692377-805422
X-HE-Meta: U2FsdGVkX1+6Ii2gqtmtLLZpUx01C4eX+1Sl/yg8wQAwWNAESYyYoPB4g9ENZHci/ZQhY3B2aWstvNp3NcVOnhvVamo3QSFIWVYZYJGKDfRQRAHpju/uK9BVyHcEUSbJxt/86y5a7R9R5LauL6/Bf7kehs9za6mC1vWQReh9Ef350MjDfCNsLZdmGbsuzqG+VawDKKjQ5jJYle9qKMMQedF3/RLM1EyW6080FAwwk1K1T+IDy1KfzAiutPH0eHxVGqudqUnkvRwLTRfHZCHdkCh//qotbl6Gz9CkKIqpRiesX5m1CZCJPzaF4YnboIsNHVPA6ayFmg9v7v6Z0SkFP02nkKdJTx4lQEHkuzDleA2d9ShbNhyuuyEayk5bS1jP2gHulBzHtiTBPhYo+U3xWq31+EwtmAHwAMMiYuH1BPjWEy2DxU6LYUbr1lc5XObt2Qfzkdmdk4PYhYjxyjuQvwXj4NrOfN7feGsU2EHLbRBWL7kk50maQkZxLgVVUvc5reG2D5FBu3QlCJbGRQS96kDh79GBxjVGwN9WW9j80A2DHgcDCl0lnt6u/m2sl9tU/45DRW6y1JbEmh7QaWVe3Tynq3Tp1XO4ikP6LjbmPOPyvRfyLYG6ZvjwrHp43KHUK5ei0kq2zGSiUaFwpiMIEx9wjPJxfHVWCAYPjd0CED6mUut+6OleEgwkz0ALx//EFSsfPkPACO+H9XvIi5yaNowswaIYE9OBiYz3csgafCCja3907BDOLXH5H/bWn1BgEj6Ykb4W+iF0EduxmNobYJNOHDjjmS8DbX+bRHvmgmyDarbSXUYFYvoKkGWFUiS7c1nfd0tQWfq2EivO5ZCyY+mx73itfUBBeV2i5guhtOrpCh3AHpgY1WKp2PsKwFEs0m5BEprrF+VRqnfNVrGyqpCn7n2zX3rwtJ2iZpz1HVoDbJv9PthpJqmhNS/VeOJ8mfBHTpppaeMaylPgSo0
 oo1ZnHFX
 zlxMN/l7bNEaOjvSHpFRdkGb2K5U1V1hpwyNmIKCQahKCRzijZWiQ6cuHP6gTxrBjErZYBYuW0r3gbYWgCvBtgbp+ChKif1kLiCdqDBCtKKYAm00KxpCErQQMIY9hWqMy1mD+NBzlisqjhPWr3nAtlJuJYtR6zzHiVZvQ+M38UVbjuxanIhO6pXST36NnvI1psVio959C21R1PFWS6h96jReY5/+sy/BkboAuoAqmTo4lmPo2o11MBr7AkOSGKwU2EIl9pkjElaCRa6xRK0e10GdXCcqG3v6SbQlIkARmPBLHEEGBlE6G5eJUZ0aRcf/xLHPGTqo1VG94FiAaC3P+acUXt29mm6OX/0JhM/b3/2rFgeVEvEUDqyAgo42ZtnRoC2q1dXjDSJGi0IU6H3/0gGkCc3LnVcJrmEWUTbVq8PpQf0wdGL5VkyiUMLcBtGYM/oBUpKXRY+ln9Lr+X7k7vih71lRLP/8H4LfZdzDpsE+Zm4uHH9QbJT5R9rvrFdJB7Ju5HCDwumGEj2y/OR+hlrmkwboqxlk2a5NAiELToPl5WLdboqHsKQBpq6neoViaVB3awTrctufszWPN/khHOeT9wvD+AZN5DoT+zuuicMBLFmucdIlMr5YDJVOh3rIItchB54WnBJObi6NLzLuPoYLWCNmQyn4mipffPdc9p4IiG/Ue/hnvCnAl/Q9N/74PayBFZ+Lff9RVdHE9oXldbQrJptgv4+XGKmE9jwdaV6olYei74KGZCPdcVDLuqv0xyyOFnxFa4UNMi1WsQRRMi29xY7Dvz86hKKP71J5EBYE1+YpkbJAD0wzxOIbndLsQCczT8l/duP17cfkb2n/74CYyrh2ZQygYH7IBZLuFnfDFvrcPagifU9j0gbG/Q+NELFdGLLv48mH3SN+g7cbnvU5naYCqhCt5TUhx8aVB6c1HVVbA2aEFnuEH+bvjAWI1oiHeArXihrRwNF4CRcKz+hp21ySH
 hdPamuDb
 BxJCIf2eOPH1fKO1MWjkRGJq1Kh94fnDn3k81wbFeqntE4L6lda+lGUbymhbuvrlC6+nPdSYcecfHAOxgXa4IpT5RW/yfuKwNogqd/vP7UaZcTpLP9L72VBmWM9guLIzERssDXPu10vdvqv5auliiKy4+/96THyZm32sPA+5zl04HxSqu2rNefI5879XtopHP06uT9Ad5hCr+aCbLygTEGimxr1utJoIchKIcpKZvkaW9eV7yyPkqxSHNx4M2qW0fh+hITT5ArZJYbYcxFMeil+UK2rLTbnGp3jaeIs1lFcHUaWPVZa6HilxPURYrcp3dzWUk2U8rPBn4HKQrGoNzNL95FxgutmC2phqrYdisgUBP+Lw6cIA2zUYilYNuEqE/DvqDSmdJk4obbiNvWZFWveVifou014h20XOTjnD6q6Tug9W+fvvJaVFEimPhqSiy3YBJy5r/vh8zLEKIkmijYFirZ3XJsTVNhK//8oGbuV/8FALpNUff8P3aTsCyOaCUXGsOd7K7A/bL48qS+RyJJYQvWNqlNuWlI/WVMHoHVaoVeawlqdZWIaBIGG3JkLCdU8nNBcBdvJsQfOQxpoteTPsbZj/gXo6+gqz6PpYn3oes7ZFstJEcQdBtKoVH+tI7vzH74gi16bnNoD4itg6Vgke/5Ou7y3X4AkFMlKM4gN1wpX3N+UkjjVKipSOiOPoQrdQS8aAIpMzpmS+F2LiPUqtTO+oBjMCqVIZLWUt+TGL+xvbebCafQ3YaF7TLNr/ohWx54CRb1UoLBZS4TZ7xPFOnrSGo3hFGV8mUQRnKmsQF4Cj/z+QSxRruJg4D2mcJIxoMbchuMw0PsUs/InsmnZw86q/izkxK0jIJioq44HlSzhxZUivdKYzwFG+ySImDDn5XtNDFP2oRVngjMqFpmlwhL3wWaBq+b9hy9quZc1JWkXJhC9vr26bT196MNc4ES86fOHP5icQS3S+KOehNCguy13wb
 4HeGGf05
 j5IqyRbdKyKMIxJ2Lof5CXe4oXVCEKhq0zC1yfJrg5/LuN2P4sPYuIiaz4I9fC2bwIV1bG9wY71RXOmTVcYHbioGJR3JQ3wzwdGACyYWt/6UwFdft7cbhnVVN8pdse7Y2vtWGB2QHGs4XDNdwczD/TGmyF/xrMgn/dYldqt1V1I0SNJs6mrraZlQIYm+8VqHGsbHOCxNacNd7Zn0pnLsdelcL08xoAcCk9m1fLsV5107Vg6y4ZmuvIrYnoP4OvesCW40zi5K0h5Sr96Z29E8GiHwgiy3vXW26WPCH0vw8nP4Ffe/4xDfw6rKOuq5ObQfc1JU+aspnooKMiT/KxQid23V6gWrkdlC0xpsN/ZWg88q7CsJf4w72j39yj4wBVJEksYN60R4ozw0PnL2DxYyINeLSSgwb9T5XLInHMIPPuOo4XSg0O5amx5FjbuVsJ9LMw+Rp5TVVqPclO5pcNd5Mb6RKrdixeMcBSXmkrzz5v6jfvbtpkQGi4QismyRQ7LWcheVdZ8U12SiskbEA/LXcZKpC9WNlOGR4l822r/UCZEa7McM/vL9HpZsaTtQg+Rv6CYNzzfpCKuRTxRyp6h1xsRClaJWYSSJRkfblqPUq1JuPgp9pX7F+nihFLxKN20NQOLd2YmdygKjsrqfhCRlAvTQtDmmXdpp7X2v87AqizhTahpzGxOCXlHOpOpc/s+mh13OzaS7W5/zo0pXTUMOzyar0eOs4BHus0HXLV2qboWsN5rmU+mWStzRjNmmtkXke7Kbq3mfyta5P3cjEwnHcFPHdtMfSwTKI1ReJYesLZ8RdW+SbpzEo1LHhr/0mjfTFVB7FF7jkvZUkD+bMprtnYNZOZgzNckYyXFcIOdpIDX3guaZ3Xp913tPUN8JuRefv6z44P1cyvlmA2y3ztw9jdWBpMC43ER1WKkA6FKhwGwb8W8T3yCZQZVnI7EgN4jIM/iGBx511bNUi/kBBYLDb0VEgA6Pp
 SQCHAcff
 vkibHO+7qRkyH+qtaWiUUYmKLaH6oOb7qUpiEdjt/l47dqM6CZZy5HDagXScrqOETrIwXBIOzApwaBNiQt/OM0ZctwIPFtxdbEOjUZraXv72rW8IKSsws3hPO10d3w02ywH84RMtY6uxkDUjZUXNsf8ulv/qgbY1sQI3mQBcC9Kgw9BtGiEQEKPIAdRQwan0YuXCujpNSMOD95S0CdmdWXLHpLd5AjYPUoZPyOYG2QcR/n6lKvncLu0CKYNmShOkXSfgj8dpnlch1OWX0rZj+szYahkuoH5qg2xI3lNNXt0tLCTxgpPixpk0UD7KEq59uB71WAF3DQgCtAkRq2dDiwSCpVKxO23vAfLn+iyaFerqccZB7e5ZvGp6QJ6xmq5+NOHU2iBjFaeKngPIpNLqtMW/WCSN7k8JHbqthTGn8uD6rggRkmgot4afnQUAlnjM+dFoJ/yzEkmKS7SmMLW1oCsCt8W5Pr9X/e//1+zc2+SCZOYEfggvuel6x9ajgMBx/RJsvgiX2BNDqvML/ds8fLdxGhcatrJkXN7sdWcqG4oZEDxjCtQroofgI63HCninKhzroZMm/nPA8fWaCTazG0/ymJQ1A2s40AeA+ebI2FMuChJrf5Srg9F4MIcKwluzEoCB+kuxEBUPnMJbMETGwTEvy0LVyDcPANgtHkfLKNeoIoeIeak5fKXMJUAqnktsbwDyiMXuKJS/ZL/wXkkn2tAOJ+dhqvR9423w8EmuIQX4KnN7ZtsrjibI0ja11xPXC14oxPCRqIYIQQWwSfRFzHQkxPZPzBjTt/HAmbpIga/vrsEc5PyKtYB3F3XUQwVGEuwx9C90KkB47TjRmudEN9t2ngMhe9SIFBm9iFS9zuZ6xTmxDRvgyeO0BJ9QBJ/h1xphNaVOmB+ZdqG9q+5qDaxt8KlB5THET+zERdbsVLlnEgIdZ3SQjhaskZeuYw7pYX0lzzYqCiAQ9m75If62CvANiJtRZ
 7NEzeRix
 cZej8sRfWLJ+0WKU6tRaeJBrBhniAqt3l/QX408LlY4OHBYDfgMV0Ewi6Q1+P6rfem2qpMC+2hgcUcCXWUt7YDBvmxdm/9UN3YXOiEx0vZzQtkKNV7kdUuMXTKQSiJNSfS1XJjWOzxanZs9o0sbNrDqeiPlsHlnScAvBssSk1v+BjtoCmCWYIdKAVPp5SzbsP/XBt+oA/goTNKmeRA1OxkIaQE1hXCpzVkWRD/sUcgyFSySj8BjHp6BZBHgPwezdq5+3jPiP0cmBY89lyixtOyRnlzuxs5wcsIbjpH4R0pLxEV8gv6AwUHfwBlOyAbUnYK3iBscx0yhp7EGiIHyT1ENztY74=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit b280bb27a9f7c91ddab730e1ad91a9c18a051f41 ]

Since the test for signed values being non-negative only relies on
__builtion_constant_p() (not is_constexpr()) it can use the 'ux' variable
instead of the caller supplied expression.  This means that the #define
parameters are only expanded twice.  Once in the code and once quoted in
the error message.

Link: https://lkml.kernel.org/r/051afc171806425da991908ed8688a98@AcuMS.aculab.com
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
index 24e4b372649a..6f7ea669d305 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,10 +46,10 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
-#define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
-#define __sign_use(x, ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
+#define __signed_type_use(ux) (2 + __is_nonneg(ux))
+#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
+#define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
+	__signed_type_use(ux) : __unsigned_type_use(ux))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -71,13 +71,13 @@
 #else
   #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
 #endif
-#define __is_nonneg(x, ux) statically_true((__signed_type(ux))(x) >= 0)
+#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
-#define __types_ok(x, y, ux, uy) \
-	(__sign_use(x, ux) & __sign_use(y, uy))
+#define __types_ok(ux, uy) \
+	(__sign_use(ux) & __sign_use(uy))
 
-#define __types_ok3(x, y, z, ux, uy, uz) \
-	(__sign_use(x, ux) & __sign_use(y, uy) & __sign_use(z, uz))
+#define __types_ok3(ux, uy, uz) \
+	(__sign_use(ux) & __sign_use(uy) & __sign_use(uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -92,7 +92,7 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	BUILD_BUG_ON_MSG(!__types_ok(x, y, ux, uy),	\
+	BUILD_BUG_ON_MSG(!__types_ok(ux, uy),		\
 		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
@@ -109,7 +109,7 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(val, lo, hi, uval, ulo, uhi),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
@@ -149,7 +149,7 @@
 
 #define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
 	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
-	BUILD_BUG_ON_MSG(!__types_ok3(x, y, z, ux, uy, uz),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(ux, uy, uz),			\
 		#op"3("#x", "#y", "#z") signedness error");		\
 	__cmp(op, ux, __cmp(op, uy, uz)); })
 
-- 
2.47.3


