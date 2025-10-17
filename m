Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF466CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4570C8E006D; Fri, 17 Oct 2025 05:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407B88E0016; Fri, 17 Oct 2025 05:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF108E006D; Fri, 17 Oct 2025 05:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 14CD78E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:12:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D80E211A7B1
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:12:16 +0000 (UTC)
X-FDA: 84007039872.28.FD61D7A
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf26.hostedemail.com (Postfix) with ESMTP id B67FB140007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:12:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZVhX96D9;
	spf=pass (imf26.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
	b=qyArCTNlsyQo5fgLvyCsiFBAMEk1T6ZBNbprKH4SGSArTW47tv9R2/5vJNu7eulwZEmpaK
	bttz/F525c5dVfidoG7JD1nPjzQBe1eN0v6jSGncfydx5AXZGdBsr6KHCYibwsRz8VzhaD
	YtNaOTklohxfeM/uiJ2LXRoa3fmrtM4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZVhX96D9;
	spf=pass (imf26.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692334; a=rsa-sha256;
	cv=none;
	b=RO8vIs299lqlWbXWuuy3/Eyus3ESf8hHznNTtk2h3qvhNdlq6XLy7D6dhwIhyt7RwjlQFO
	kgVfSfv7yJuLJVO8pf+sWpBArvpdTj0gBz29w5xSD+3euywU0NibkZO2CxIZ4wFIFdap6+
	9t3372rMXLRV5ETzLNSqYdEbpOe19zg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692334; x=1792228334;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
  b=ZVhX96D9Sc6h0ZmIX4WZ7ARLN1THISbp9u6qmc/Ln19etRgrSx4zM0s/
   yq1+Rebg/Zdg9OLCGWSTAOzySaZihvofFu5vwqCbQiwycrGQHXCW1f87T
   FGM/S9aSWjo1Ejvs+HKDUnUth5vqlnmXQOwN+T+GAIh6u2mLdBUKNPcd2
   Kwz2By9ch1bGM+SVBoQEwvUgPyHygRpQH+F1sMQaVjuLri2FFY7DTeHYI
   Ri8eNwTT/ewvAPq2OInqH/kiD2LfCLvcTfI/O2oesr3jFRKtsN3HHhFe0
   hgSvDRyHSVcJoV+UOFdeZYQdoc2Ks6ek5p+iqEUznYqL/m9QXTwIJMjA0
   A==;
X-CSE-ConnectionGUID: cIAAXrzNQI2keWjt957wBw==
X-CSE-MsgGUID: W3OOEfKGRsenCLcLU6XOTQ==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="5064477"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:12:13 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:21101]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.44.167:2525] with esmtp (Farcaster)
 id e63f1e13-6fc7-4a12-8af4-9b7e07ec7c79; Fri, 17 Oct 2025 09:12:13 +0000 (UTC)
X-Farcaster-Flow-ID: e63f1e13-6fc7-4a12-8af4-9b7e07ec7c79
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:12:12 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:11:57 +0000
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
Subject: [PATCH v2 21/27 5.10.y] minmax.h: add whitespace around operators and after commas
Date: Fri, 17 Oct 2025 09:05:13 +0000
Message-ID: <20251017090519.46992-22-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: bhbdiocr5mckux5jbwcsr7pnc7hioego
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B67FB140007
X-HE-Tag: 1760692334-55340
X-HE-Meta: U2FsdGVkX1+IG+2wHoCbUZLwB6LrFA5Uc5vt5YSdF6C0+JUCos+C15xEC344ZGS6Xk96OtI3swPDGBWnLEVymz4HTwGOwYggdV289h+RUFumVEAiClbBlcpkDaxXrpLov3RyUN+2Yv1fv+zURX51O/j5PGZxIwuLklfMfj+G9SYGs3FW6dHb1DyvlSsZLOBaGQ0W9QEnIF/s/VzlYcCryi6HezHJyHDBW/197tccgHpC5Zpq+B75Ns2KPVyLBCTbiMaIuXzxbPg+qCf81Fgla/rZ4NQ1buJAdvS3QuCgS8mr0iGhr3rh2iWqKVIOhxSS3XrM8yqLPCyCNFQHGwJcggsQLoou/Nl1ckx3ZOjGeRX1Ju92DNCgdnRGVrDanqvvRp3hKDZftH+wFFNwf8g5kexMRar/h2FdqZjdflxt/ArVq1sgpXzQO7BSahDW9O0534niMbNfw+jBEUQTJy/PvR9k7FKCSt5zSfC1F56VqRBoKLmDOyHjnExClt28qbGnim6skPtgR9N88UcNkmC4URpMhXh/nWCln3KjP+cYMU3E6CFfd60oIOotm19QSIrp6EbCxrZAM8lINe0CAIxMsWVRrxpOlXB8Oc6G29VkDZ2Twi4T407/wRepGiz3nUZqiN2qvkWch1lj3MT/LL/Vhqk6I3lsjBAKMCqb9M5zwiDL0fTbq0Z6DCt7dfH1jucTq9qKe+V19pLAz/bayf6O8cAHOlASkkfe0jp6DFz/1aTUrtRl7POXWhFkvqqCi6DU5GJKp0/frNmaUyu9hdwZiXw5XLc/1S7rCWmCuHQ5Kqa3U5xd5F9yujcGlyOaMG63KT39G1DM0fk0tLIoSC3dVDzoMDxcE9o9EE/S60AHDaiKSYLNo77Dz5qu7ANfPSRAviKLXqWTwPb3fbjE3/ajUwq6W5saDYHnSEP6/zaYxjsR+sSADgZhmMaZvVaT3A+9tciCWDhZXfCzJDOZHWF
 Rt0Xhc2A
 /yPNC2o6du1603AKTC+fpt4LopB/M5bVOs1Y1IlFU2/hWyaVpnYCDPfDD6AqVi/fXyZy0Y0dQSserQQ8Q6PACKGQ0f5pDg2GDJHA38Hah5MynxjgScAU9KwiO6OlcViyOEtK+t4AM8y0byK/nKbEh8z5zxTwiZNoeEGWl1OGQ65AzQIFgFMfw7nMFfuYdUIvz+LygSShYLC4eiHSbrTCj8VjQ6M+Gldt5AW8IFpP5z5+vA0PLD0C5rG4gRjC6Wy3+vx+sbThQCRcLS4p8lcZ4bVfByhgB3gwHBjb/f5rpEHTYMEWKxYStQc5yJEPswhqqqE7FrR0FeRFiGCP6CglxFARNqnWyrI4XxlbL+wXBSXFX/ykwq0h7exx9FFwsUmHKUDadbj37ioR0is4+/dW0tYDdThJbC9xVOLkk0dfsswGFWMkjPmhn+/sbNP61/Rzwd8XdAzwlenmnYyxPKOAql2l7xJAjmGLvYnfMGRHRZ4vlKbQkXCFwicWKntNdccsfIloNyO9X6/gP/dWx69AIL8E3VPEAUTRmMCG+Eb+ZCL8texCkBqHhTPfRpgiSM07JSGkBJ32fHX6bJeL7FVhD3sW+HfXVr07pehZHxjlpaBQ/IrSEC446mJxfADoVarrhz9erAdD6WNyu2/iDcjc0xeM8Sd69LuORbVqunNu3S40At1jxcqYjoAyzoYIRrPTjMUEWHc7QcfG6qEyIhiiu5gin57mDadi0yyMOo2bSctS4tAGwlKR6TGPb+y4fv+vZulQ6508bE43ZA9Nx58r+dEmTtUJ2blZ2pF6bOLxOpkENnDq7lm0KcD1J8FX3k8g8fw5Q/bmwdBLC1SI61I0ctBFrua2xkPe+xSK9yOSQz6i8aXmERLfbNNIFl/homl1Rzj4VxHC/7VbPK+Jjz9Gzgtlj60j4WR8MN72Sio1Kafj1fFDgytRo0af/TcM47jczqWKj4uZlmcgx1Zp3VTknkoNKzjL0
 BdynZ9Ol
 pVAYiVXscgOaqxVE4RumNmIQapiCa7WPX78vECppmlca66mZJTcwrjl98ft2rAMtrkNFOlce9PxO/v1fRy3iSt8joQiw+7GsbPRP+myk7BoPYL6qqXQXJ0i6rfQCfqIcv4M+g/w/fWa/wuqvMTU6vqBq0xn/ykzPQ52vqyzO3nnBbb5OO5At9tSkR0CtYlusMD694DaZK9PHd0vhZRrgTJoxFBTJTgPs9tXmss7EaPEJkisxzFSh+HJNPM0yBxZiGMAWH9K/zWsK+FpCLBgKyB4iSjVtRRQMT4965ycyDhY4jjlBC3jjPkqn7uZnNTF0pW9Df4Jv12yFCsC13J69kzmMMO82aw62cQ03o4n3hu/yagU3jTtrVI3MPjIob/3Tm2hePAihPt1Y7WaPAIPFCirtPq49enQ6/UkTktIL4cqVJYJ8A6L0IRDs8tboOWTokxsgFbIGc43jPCjAlp3tZZQHiZMhaIAg2ASKi9yXQ2NoPga8HZ2CAindAp7hXMgGAopwhtwWZa1wToyAPa923mv6RFiXRz4GhLg/66yKfgQIeqB+TYmooU1qbHUq5U6GucUb5bTKbxDTxVBn3WAuWhaMXN/iSQgQmSscXZs2dPFe/OoUeRimejcWC9hwoa3afrfFVGiURfRCExTq4uBgusZmhtdFm1sid+lVXCLJOQHI/0CvbvLeQ49n19fq55++ACloe8sg/o5H/jjcMH21YJu/zUjbRg4u0cXfL/WQ4gSsK4Li/t3A4OI99I6rgNabRJuQ+sErZYDABUnU02idP3NyDaI60lgumyxrdvqyZJO65EfzTOtRVledeLFjW0qYM5de0FDxNkuoGPnWM57n0RhmmKJ5Dzn9VMG3xST6tMWuQgTDCtBgoL0R61yr1SgBSpPspox29ZhK+rOcPrCJSK+uxodG4KteJJ7jPNkiOm+DXENA7QoVuzh8LO8kPwU1SwBoV2aNUJAWzZj9cLQFzDoiPKibO
 7YG18B+0
 v4G/UPlAticFxhgk5Nw1SlN/uuHyl0FwscC7gOxxBzOTehmQ3Fi5ayDX1r1ap1SsE22FnKZ2FwN2m4MkdmxS26hAuOGJVgfsQzSjKhFeRKQgkfQVdqidTer+SiFaloZEBb7KG/HZl2h0P6W/zL2qo85xHbNT4t31rs5I6xWlcqx5psAV1jKj8gCbsbi67zS15D/Oh6eZcjjqIhOd+PYBPXZoI14cLZAtfdHWc6r+3q1hlyW5AMs6XJ2PZxGfx7Blzg4hJfCePX6frc3lbAYTNzepzE4CN0vSu8l1ou6vifcqOcwugfkm+SOgkfIPnOz/zyNED3udt3k14YePms5h9qSgmVaYRcxDV4L6o1VHUGUjYhJNMhbeVd/4UoK4TEeCaKyi8PII13aGYvNIQ9IB16feefXcj9SmiiL7+FaZVTS0s6IIltZhvW9oi2MRd1I5gxzk/b26F8/SDR3w8Aqxk3QtwuvQLKilX6TYOEaUni9UbCEYcgUAzpUalw0ZAsgAP1Fvw35M9V4s8TDYJ1pp0Xy+2cQDQYIkhyCcyO5tmfoVmYi4HPwZtH3wfWkrjImi4ss7QxgDjsWYCR0+mzZevE4az0L01Vw/nDkfXpCBbNocOK8CXCYDjVnY74SEY6pXmJMmkR89vVsCF5KwAkYfpik54030+W0CtT3i6QycREd6sy5Xekk/64zqX3679sNI/WPaTPvelBM9mDkpW8pLpQpGqgzlWa+G61Zl5gbmLsTI0W53T9XuNkvJTfyGjVx+3Z+abwsBOD2nGhHjSVy6h3UO6fYIAZDDzCaOS8wmGT1NByR+5bvJz6exG/dQrcW0RHJ/KcEDcEdnnepUiVmjIVkoIn5tCy0SNMuP8Q3GsBzB7WuZH2fGam6m6BB2MGfeQyFBGdvBYeNATOLgLUb/jKj6n7eMs1DSuBeZlZ4YWOEvr72rM7SnLD1hIJVbIKtEVZUb0g9jP28qpRKrHmmQWdruX1PXk
 9C2qjK/O
 EYyAnvvrPsG21ppZqspwfEfdjSnsQlgjeDImvGa0ZN1L6W/lY85uzPeCk9iylV5GFElrRvDkJfd7g9NtkmOLuFvvNkJOnHi3weyHyGnqCe4KQcWfL9GKDtR11zl6NTaY2jcByEm6LAblB8Czh92x3W7tfIcJXlHxoQb7Sn9J4Hr8eTZx7+x9OZmlOz6mYy3disDD6AWzbzytLwfTLh9fz+p+8fo04E0HZ4/m66wqtVYfXJldi+cDhI4vV2UR8ZD5GzpaJTeOiGebfvpQYYbAuKP4u9dS1hnAFAr/R+wLAFWSD2XuTzzPM3uLQYDXG/l7hukjMEnGlPiJmi/GBds6jnh+LGoJoyDBXVvJKyNYazA3yBmzxxiB7wmvFuJ+TIZYIm/UkFy3JULAqrnh7RhQY1CaZxs64MTRE1HudH+XBpKr832ZJQpFnO2ZFeC5zC0Pv6jj9DIncRQYKhqy4UPJ2cg+y392p4JLjthuxTtK4OyGX6Djh03BZelJaxuVH1/9ECqv1soO5hXSXBvzyTWqkae2YxtKJ9W4PVzdT+wcBtELUcUXUv26QErBngaVzf2ibLPvSoxqg1QYVPLatMxqCH2AU0k/4peqHaR7wYG0RVMQyuT4xxJhQoBPWuxhg+sFq791+EKDiMrXmuaxeNNFijZkaU3NGWI0lLrtNPZVE3/d6afYcU+dpWDOLlifAWgmygRULZxUx51jln0A1V+Eg9z4hR3k63BjmGaPnN0GWF3WeC4SW15HJBoq+WxSdJb6cDmmKGiq3n/QDxL7ZuaZhxVrWYh5gNyxjksVeUo8pRPyG/xi2O+rGbLqH35x5uSfLveLImR6kE1NeRmhyxVSypvUCM+Xf1aYhYjeq0IMybGK9SPiPPIWCQTbjritqtI2TzipJjLGj35fMJbZe+iGOe8IAr/CGwBxmXxI7c00LDvRvfZoj7bugnKkMhpiay+B4NEmN0HF4HFxGiz7Gk7dhx8f1Z76C
 Tq2TNfJW
 uApxAXWzMOLiO5JfzGUCSMsHtdYZrauV33bYNSnYtO50o292y3sAy55jcIWhG42ckmKJw3shqtl4+gT+T14T3cCk5cLEIeOPiTRY3sO5tZDx8x3cBEX+vy7EL8NeRRYJkW1wTk5Fm3vccHQ4FCHj43BcjLb4k6mnlpTG9+0nTSW0prdAnOhKgKa2Wqn5Pl1mcGU/i//rmRaT8tPle9GysrFWGXGle6x14Xi3WfUhUirwdJpcSkveFsr+jCsj7TB1gfcozkFsuyNcvpoAsi3tk7mmYM/qATeGWqJ3AC61uHNrJWCm9Vuhu6ICtB19X66s3EYbQCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 71ee9b16251ea4bf7c1fe222517c82bdb3220acc ]

Patch series "minmax.h: Cleanups and minor optimisations".

Some tidyups and minor changes to minmax.h.

This patch (of 7):

Link: https://lkml.kernel.org/r/c50365d214e04f9ba256d417c8bebbc0@AcuMS.aculab.com
Link: https://lkml.kernel.org/r/f04b2e1310244f62826267346fde0553@AcuMS.aculab.com
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
 include/linux/minmax.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 98008dd92153..51b0d988e322 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -51,10 +51,10 @@
  * only need to be careful to not cause warnings for
  * pointer use.
  */
-#define __signed_type_use(x,ux) (2+__is_nonneg(x,ux))
-#define __unsigned_type_use(x,ux) (1+2*(sizeof(ux)<4))
-#define __sign_use(x,ux) (is_signed_type(typeof(ux))? \
-	__signed_type_use(x,ux):__unsigned_type_use(x,ux))
+#define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
+#define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
+#define __sign_use(x, ux) (is_signed_type(typeof(ux)) ? \
+	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
 
 /*
  * To avoid warnings about casting pointers to integers
@@ -74,15 +74,15 @@
 #ifdef CONFIG_64BIT
   #define __signed_type(ux) long
 #else
-  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux)>4,1LL,1L))
+  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
 #endif
-#define __is_nonneg(x,ux) statically_true((__signed_type(ux))(x)>=0)
+#define __is_nonneg(x, ux) statically_true((__signed_type(ux))(x) >= 0)
 
-#define __types_ok(x,y,ux,uy) \
-	(__sign_use(x,ux) & __sign_use(y,uy))
+#define __types_ok(x, y, ux, uy) \
+	(__sign_use(x, ux) & __sign_use(y, uy))
 
-#define __types_ok3(x,y,z,ux,uy,uz) \
-	(__sign_use(x,ux) & __sign_use(y,uy) & __sign_use(z,uz))
+#define __types_ok3(x, y, z, ux, uy, uz) \
+	(__sign_use(x, ux) & __sign_use(y, uy) & __sign_use(z, uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -97,7 +97,7 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	BUILD_BUG_ON_MSG(!__types_ok(x,y,ux,uy),	\
+	BUILD_BUG_ON_MSG(!__types_ok(x, y, ux, uy),	\
 		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
@@ -114,7 +114,7 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(val,lo,hi,uval,ulo,uhi),			\
+	BUILD_BUG_ON_MSG(!__types_ok3(val, lo, hi, uval, ulo, uhi),		\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
@@ -154,7 +154,7 @@
 
 #define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
 	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
-	BUILD_BUG_ON_MSG(!__types_ok3(x,y,z,ux,uy,uz),			\
+	BUILD_BUG_ON_MSG(!__types_ok3(x, y, z, ux, uy, uz),		\
 		#op"3("#x", "#y", "#z") signedness error");		\
 	__cmp(op, ux, __cmp(op, uy, uz)); })
 
@@ -326,9 +326,9 @@ static inline bool in_range32(u32 val, u32 start, u32 len)
  * Use these carefully: no type checking, and uses the arguments
  * multiple times. Use for obvious constants only.
  */
-#define MIN(a,b) __cmp(min,a,b)
-#define MAX(a,b) __cmp(max,a,b)
-#define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
-#define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
+#define MIN(a, b) __cmp(min, a, b)
+#define MAX(a, b) __cmp(max, a, b)
+#define MIN_T(type, a, b) __cmp(min, (type)(a), (type)(b))
+#define MAX_T(type, a, b) __cmp(max, (type)(a), (type)(b))
 
 #endif	/* _LINUX_MINMAX_H */
-- 
2.47.3


