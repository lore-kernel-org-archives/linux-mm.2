Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF628CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211E08E0073; Fri, 17 Oct 2025 05:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2608E0016; Fri, 17 Oct 2025 05:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A2A8E0073; Fri, 17 Oct 2025 05:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E758F8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:14:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 973C51A05BB
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:14:01 +0000 (UTC)
X-FDA: 84007044282.06.9325462
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6E66514000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:13:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Koz3rrcP;
	spf=pass (imf26.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
	b=pSI7aS6cmuxp+AgEpK0SfGZRTRpaQsg0+wXMAW9qxzOPOWPBngKaWylpBNu14UkEKJbyZs
	IAlqef5z4VpIsVA0abGKzmc6czV7gIi3AkkLlAaYzrtm7GZy4r7VXNhW2qaPC3BJh5N7L+
	CLQDWmXmc1zps48vmiMTguRU09/X2Xs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Koz3rrcP;
	spf=pass (imf26.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692439; a=rsa-sha256;
	cv=none;
	b=Z3JIfbKHavg2WVARYhsKI4BpgOGA27GI/dV6+5sJfW2vp3T9Me0/OZSdGA1WyKCApd8ke/
	tpM2nU1tlOTUfDR0gIDcQqfzAq0pgk8Ogv74mUCuXGLCNWEYef+NDkNcJq8LJA8OfbCn3K
	TUuW9x26nGPS3/mMRqryCJf1LPQZbmU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692439; x=1792228439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
  b=Koz3rrcPIHkrE91sI+h38LlnEH7JVrAHPXc/pUud7s7pCGj98Ek52nsm
   KUn/znQexMRuiQCRoqwN37LlZpgZQuQPXxl71/GjKBcvEwe2TJMNbB8ag
   vUk9E0E+ZZ5dV1Za8JCODS90qB8BBdeu+HdwHVhTj9bj/WpGPB4pG3gXj
   3p4peTjg74ptQtJCGLPTFfKC+m6b+x6Gl1hyRUdHKAthPgIxy88opgrS0
   KQQToSV9/QYVlC3F/6q+gmsVIqV8wcOblUK/4uNH/iI0AN0FOfb0SaanY
   PxU0jqmbawBJm1QAuwtzXp3afnHNgM5s2K3vThmHS9YTGS85HWrgxMx3g
   w==;
X-CSE-ConnectionGUID: Bu9b7IFLT+GHoivxOvtSCw==
X-CSE-MsgGUID: p92hdT+1To+3S8jREsqtBQ==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="4884630"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:13:58 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:21527]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.61:2525] with esmtp (Farcaster)
 id dd635e12-e909-44dd-9ed0-83a13ae4d74d; Fri, 17 Oct 2025 09:13:58 +0000 (UTC)
X-Farcaster-Flow-ID: dd635e12-e909-44dd-9ed0-83a13ae4d74d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:13:56 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:13:41 +0000
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
Subject: [PATCH v2 27/27 5.10.y] minmax.h: remove some #defines that are only expanded once
Date: Fri, 17 Oct 2025 09:05:19 +0000
Message-ID: <20251017090519.46992-28-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: dsukm5637q8hedpb3m9c14de4891kgft
X-Rspamd-Queue-Id: 6E66514000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760692439-602774
X-HE-Meta: U2FsdGVkX198noHX1z1cNmVSBR4Sf204pXkKFnuul2Z0WCyP8tz5d1cOVsj03B6TDOw7AYDCuoLUcaDLn4x1f8LUJerb7i7xKMIAc1fFwCDsaiCdEGPT20FHqg+EijNbeqYQRWgZBmVZMjBKK11AOFI7ha2ZLxwfSeE9LFNXis6AKb/fGs+49EpMm03I1zR96Pr1cT3Swp98feEsGqvu8C5/rumKKDTMtD7m4dnyBC1v59ziiVgt5VgkyZgFr08QYyFj9pgl+7gpb2qoXiGMqR/xhskPGtXbrLKNW8Fsnc/N90z0JDtA4EkIUIZ3cdGjP4pbi5t5YOaIgmG8AuJXlXoByYhrJIhi0WNS8Yhu4vhOC5ngevoespCoG26+OKyD4TWhm6Oz5/Ct3onZnYIJ9ONMJXXEscUyD8DBK0ksnWZPNSHZtGxjhA1VVOBZlRnIH+ObMGxeoDWMXioMdsiagtewCtbNjx1C6muzItcw7zq/1XljYNHv3VVliHqMdliPgQ9d0st5sFp9tNG4JyxZJ1CYBnOl736VarVa3gtQF5xzURsb0l6dH3kL0k4wXvpE0lzk+DOwAp6lFLNjdeQriGbHGTaoylharniC4GwUieONWuu6OUbgsPKOzWqx//z0I8wssgkLsqtr6tnn9eL/IMGEQP2UWZg/oo8kUVFpKvp+Q2RZzffVpbcgsheimrgOPEwuMt9q9sAF+Xe92i/hXGRWWZ8IU6q+qwJt+KvjuuCI8ucj4D9fIMxj7aZjhVOrzZUwh/4LDxXIgSo/rMqOHN2phGPS6m+/XIZ+oSgOJcxxA5p+ckEJf2dcVTkUJHy3B6abiEWNU40zdZXMakjObq67UkzY9OCSB2XDJbxha1c+fAVmDjLFql20Uy9WGQL1s7P72J0pomfIZHA+GMV8Ss0QE+pgLntrRYK/LfbxPtOMyWaGeSxaUWB4H2DFJIGGr7Sb0+IaVWUY6Wa7d4M
 4za6OPhu
 4ru75rrOiGy48gO6/GyywgTZlWWy2YrS2SJGg0zYiXgnwlMz7lSibXM85fNS1WOXHi6RBaK161wvpSKuk5uqh/t5dw2fIQ7BBZM8tf4iHXU0l8wC8BmzF5+zHoGKqS9bi54hAftdtledkfBx8lUbCkaJjKsJPVwa55YZ5cC48637Ps9QBBW2UAlT2neXI+cpZ1q7/vr74BfTeSQkEJC4XJ7X1gYMLsS0TY00H/ndDAju51o2KaaLTeMWttrFat2cYL8RPUiAcKqoLUI8L2WUrxf+BLZXXBzuwy599cm4IwA7Kd9SnnWqHTNS2KvJdCbGV+b9OR/o+TbQxLTxwhlq2HWYBuqJRq0Fa061e/hr7evYOcl1Vp1uATNptor3GVfC1V+XJ5NLfIFOa5uWexBhMEXvuTu4oqxmkX9v2HimVZ0eBl3wJ1z3QG+inJ8NQqtzjzHcPu+Sbnzh4qDbUoELINanbRCnSVeSwWhjVwsZsnSPgNQ58hOXKkcC0yjyH6FFuPWNtQhtItZzHFpYCrc7XJEk/zdsmYWpKFTR5bDKcKtphgB9lv93xajsjQe4YWadQYneA5XgqeQ/oeDdHqe57umr4ZLa30RczfAEVULddpYFKjlO81VTVP5lnK/EOmmNx7OBWvWdmcnvMDN3ktT/m/0XcDHjq21LhEvxdupvB4r51PPxwmK3tJJ5SdHcnQWD1Rs0KH9rw3LLfwwDJP4+O20Ihn0fbBjoakDZhFmkZ5yV1uLM3nrvLyr2yDRdBXwCgHeX1HhDca7tsI6dTdTL3M5dEoIlRKhD3OLl05d/kX4UVsa0UrrvtzbV2aWLeZkRKMDsmiu0W6XS5VNuwllDD1dYwG3zb0cRWKEKMOjThiSbDptkJ8wkLimU7vsLgYBGiil35gTsYPA+8gd9IcC8h4i4887mhk2I2F2w67ehM4c/qnaUUUx2ld1+kXP8j3OvXJNsk9EbWR2Cr/RJ9oOslMBSnOYPw
 EneOFfSB
 /YnCq/XSnEI39x0ueerzZL12p4zer31SWf6vC8jeBOKi+X6t5q+TeIBhLxsdCcq7RLJrYv/7DfoA6EXevzyOCZjD/U++RrCXSpZzprBzo7OZFlHJ7pMKSlC2NQvkuMntAww0+UXxBnjPetIMpGRfqjGxu/riMtARuBvwQhAguxu+3l/7/pby5tnPY6jf+n3twka3YhHph/Z3WclhDC9CPXu9kmgiIWdsgllrIoNRrXBijcqEZ5UM24BRKYG4X4Az+V9Pz+16xsW3AQws820a2im8pnV1z1blWN3rheOzTAqc5hVwiGfKYN/YGMutGwyU4b8zL7pYQ3A/1BLDOEIEq7Y82mwDMXPOulZz2OxpnzdykLY3ztZR+5ZkCyumCnjaWPqRnC57+OGUCQL7rSSLb0McWe/HOmxrDye3g3u7G07p8UAngvY01/L/8Ty4bk225l3zmM+wIFaVChaq7B5VUkAWVE0Ot2QXns9fRRt+WNZloCARcgMKnq3AwqXh63IEApBCxSZnq4nEgV9r1gJfgoEjLpRrEGdfwTBcI2PdNYCGierRjV1hyYCjBvdQXEI/p6x6nvIyInkTEK5wgwkTX7RhdOoOp/UzSw62GQJruyiWWOrJpk2JeBo7W+1rNsibF8veDmGhcNwLW7ovAs6Ra6tsTQOl4+uVIxn6X2ispvVA5ZA8nUCVBDtIv+dDx2L8pgydXlrcYG4yyehqOGWrYWUwdtzRzdtniGTUoWvZbtOgChZtusZxu0L7EfiKhn+SUAMA/XzLN9QQJaRy7CUBzwDjt8UNOTIPVMdr67nfS28RErUEkCzbRSEHAPsPiWqYaJZ4/t2N9GfihDvX0Vt9QOAX6PAtFXbEFHDxQ4dGmO3l22odBTxjQjDZ70c3Bk3jR1EpYwi2MnoK828CLoBM8DLLWpVxhcXep6Mq8e3ZJzP2YXt+c6vgfzURg3qwn+i+FzIy+UDjhWxSAn3xKf4Tz7Gina9Cd
 KM8OH9PX
 hHnvnpht4TH1DDUyHPSwnhoyy+ddUeB7N0bQwnMbUoyk53GkSkTdlXGQZeHGpieo09mXGtbDQkVcX7Gsr+Bon2GzzuIs+txyLf8ML2cv7e7jW92SQ/pHtx8HbnL3MBbT4c8w8nQmAgc8i9ifUpybl1kLOSyor8GJKvY3whCoaKrih5m6IR/zQzclfJlFMbrkmNhvC21RpSBDy0LFuLx+9JFI8iOKNr6YD3e4GXyEqnWvod4ITL3ZMBqkz5PDYIGHA9PS7aQy/fqVmGfIc7GfPW/y4b/CLfCyupat1L95FjbQbypIO7wIXn20Bo5BXCQzhA2Nn+5NQwyQKp6VWLJip9KkbhwaLsYn9vEICDgA/k3rKGMX65z0hvGOBFfcTwQVvVC7CvGWCDKr5Nreu63PgoES1JvGLT5ox4a8PDoW4CItmVdMNa8OsF+2mZAWJQ3kF4ltmOCEXw/dIMhCGnpOSbt6CxPfPX3jagybtM4+4hmXASfAPcaNHLSeC0Eqta4VJPPuvogU8QK45WIhXIuGxKecrToaeBJJyR6AiNQUL+uGi++Wd21O8h+jcsFWdJff2T0QEZy+ayA0GZoRZiUsDGHR/c9ip4fDOx3JJ6TGKCCAdQ74NHTNOLRhT96XB/mpkUx+cpn1n8lnhIJBmZn14am1sy5XwdEhkGEVr2gBt3/WbJKVXgV6UtiIytcOQipiqsfXMyPGYlRKNEwxxWotOJ36g9MnoJhqXLn9bcz3OThkZZs/vRsX8Tm5mFMPuMmRbty3iMDGbpBCu5NuawTUrCDcMFASMmcX01j0cWxY7u6VFVskANOpBWd/4Q3ME1WWoW4PvqHSl7X+AM0UgxuASrACSHd4ctDgM7+HNO5L84WPgO2oq1zWJPy0PhOZIChQ6G/5GslQHfLUAtWIC4XVfiObnZkrxzFc4Z8HfUcCJxzDkV7aiLmFlnJ+9BKxVTniSHGSPdq5A3HlrlqygSRP5OAerEcpr
 vGvnCQkf
 X1h5KN68SX2PKjd5xEMfP1e8R2zaAH9f0RUfdhsm263OtTBse42Toiw5UtosR42LBic6ZGTEN92eXn1mD1ha7ARrU2tgoMe/jC7tODuPpSTgHf09SoHZg/2PEtey4NWMh+Th38V5W68Gs9v52Rh0m/dh03LIg/nDVqhfEQlNUrT/484hCVm/ZeX+t03pC8JWO4CvyV4TxOOfaVRj7SQGUOhw3SPWcFm/jj2slX5FiyEm9CBzD6YD3UsS960rh/xyHn9JJviPT7QA5EGohJ/hL1OD5UngQwUnJsge4k84AmKLfviEgrsMPeNnuef8I3Wp7TVnSK9qbISI8r8PEbYKVx+EmzZqY7H8EtdKOzc6MckaBQ7gx9GgAGZjGCInMSY1cSb3SsMCHhLx/YQLHcD2JR4mE0wNfsjTZUc31k6r8/Ee4rGEzIdtZvKUgx5B/IMAdUiKJYY+odaGC6pX1pwDweqOmr8NkywgJvwPTwweevU4YQFUHCZ9JSFqQELHacV8NKoGaaDnXgzPubHLa90V+Azh3SaJ0uRokhSum8VQ2fUC1aM3YZZy04m70wvvXWodgQwBIKuklUzwnohVUlZLRRz4t0OycNQ1qgI0mHYom1WcfkU6sORdtmmeuRrs2upHTjQIvhRCCMg1v8HGz3OscvKslMa9Z+gNmslB9PgPYwplRH/GYfziEIq0OvUcNyDWRht4j92tsG1A28dYEC8kSNdum/eO02BsXT2aiX7qwRncnfrTU4JDHUJnlccnA+1JbArFeJT/CigrpC3m7+U+1Ynz9rFnYsajBbB6V8MYPU3+vhHX1ebODWZ+bNn8crauFaJUNRUwBxGOOjcTwGSAevCdXeMYYSKo1TtfhmOJTV7BXl7cbNf9IkxaEulT5OqGLqrwShovRwFn2KT+x3Zwz9uDfMxkqRGCLRggBJYZ8BmzcMKlkZGvhchBrCl8CQLhEfAVnnmNh48lyvz37lAdpMFSK/YRs
 13ADqOeP
 HXs/lg3TYVdNTP6GrVJegiInAf/EmWJax9t/SYuHBOVRBLI/XgCEdkrRvPZhEFcz5qzA6wsOUZ0SXfZclHqnGt/lbdT/K4LmLXi/V8YVoqovwUxqeuuDwGkqZxzmnyyuMakJ28FAS9X3HiIfT00VOER4+qpgMBUxaFzGi69iE5p44RAgnkhYLwgaaB7ppyVD+ihkqv/6IJzLLW2VvcoEd+hooMO0mT4YpUTzQXtIqJedztEa7cnLeFiRnpvefMAIwMC0QuazKFnnzybO0ELhOA4YoCukqom1JUYeWzsoDEZnTgOhH7mi/E75KeCFzaooVl5n1ig==
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


