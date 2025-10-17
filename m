Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AC50CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3828E0068; Fri, 17 Oct 2025 05:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9828E8E0016; Fri, 17 Oct 2025 05:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A3F8E0068; Fri, 17 Oct 2025 05:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8A88E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:11:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E9191405D9
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:11:01 +0000 (UTC)
X-FDA: 84007036722.12.7B606CF
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf11.hostedemail.com (Postfix) with ESMTP id 14E5840004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:10:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=c+4vr5j6;
	spf=pass (imf11.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2um4itFa7R6bmR1cOnWiQ4hvHyXTQc+TUC2WBV0osSM=;
	b=ZHymTLw5LDqpX8wPaYeKsXTUP/MwV9v2VidZ+/doOikF7RwlD4fS/2T2OtkWGETAun0GV4
	HTNPAc8gUr4kvaNWzRAUC1uuMqf4OUyRIGunjwEQ7oYR1msQmwh2pSPLlnb1K2JbbxFBGY
	lijt8DHxGjNz4P1irKESoqxlSw/7SBc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692259; a=rsa-sha256;
	cv=none;
	b=7YBOnLXbok456x0a2BG7oOHlii4yFRcCddFOcsEUCYRdNjWimTyrITURFI6qTwQCKH1aHD
	F94AqPr7qg6j1KQMhWkQIGo4x1gardORGGhdApf1FucH1PtFJr9ZzobHVXHhERva1HAKHW
	PLoRXvaKLKlhoBSEXjh9nPaXsS9XZvA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=c+4vr5j6;
	spf=pass (imf11.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692259; x=1792228259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2um4itFa7R6bmR1cOnWiQ4hvHyXTQc+TUC2WBV0osSM=;
  b=c+4vr5j6jZ8uUFf1ALXH+rA/gcqW0pfz2h3m9Gn6/70pwfRwyFB4YhlL
   TuE6CrjiT3HApNdz4UNImhP/RUbtXOSrRz9LNrHgYB+xbFiXEpqkrZ2Ur
   hinIX+yYIgjH2ydwlmBXFhXEMoNHprdZvLllBQOsuQGeQ8MZrSrnc9sCF
   9OcKsJ5DRb8iRPVVNdvfSs/+EoC98sTpuDLv1IH7JJ+f2KNuwX54OBm4f
   yIw8q7/CLGM+HznA8FjRj3nDsA5YuDMvBWWUIm48mJ4CgMYpLjJ0ZVnlc
   TNhmGjU2AoO1Ijt0tlHAo5pvLF4Eb6Eoo1cuOBcU92rl8UF+5hWmwCpfm
   g==;
X-CSE-ConnectionGUID: oT/Oymp4RQWRnFkUx7cDQg==
X-CSE-MsgGUID: m7HI+2jdSnunzdfjsiCfqw==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="4957075"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:10:52 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:9966]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.191:2525] with esmtp (Farcaster)
 id 44fd2346-0069-41ac-8a04-2b36498a64f8; Fri, 17 Oct 2025 09:10:52 +0000 (UTC)
X-Farcaster-Flow-ID: 44fd2346-0069-41ac-8a04-2b36498a64f8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:10:47 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:10:31 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH v2 16/27 5.10.y] minmax: make generic MIN() and MAX() macros available everywhere
Date: Fri, 17 Oct 2025 09:05:08 +0000
Message-ID: <20251017090519.46992-17-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam05
X-Stat-Signature: nkcqcghw4i56iiirqomudy8u1qtpas8k
X-Rspam-User: 
X-Rspamd-Queue-Id: 14E5840004
X-HE-Tag: 1760692258-438805
X-HE-Meta: U2FsdGVkX19YSqgSOUsmaesvLKEsu14ZmIrSe/ByNZx8yVT5CsWrrMhkysTAduGiyECe7eRQpJA/VafwDvUAF0W4gKZtEdKd/CVwyim6BSJOnIoT7XQKWJ/D7msBsW2nipgembSJkznA5BQ2qSr4um5otQLROcPuAKVUGoR3MwcplnmrF38meFMxz8ckMrU2muG9J2bJJehmOiSJ/oxb77Y/G1p2rIOuzcCAmZjw2ymvtBMt2QwlTG+fc77DVzzFMq3TCjz0BvEFL7ms4vBCPTUahQRQ+xuKQoNzqQirxY9h8hN2f4jmboZI/+nhfSNxWJOJ2KQz/lGwsdVlHYLVn5NXi0nF8T+saqc5p2C2Jhi7DA/kA++nXWoZ3hZo+AokWBVENDV0TF1ZzxGwfir/x3s+o6aLP0sKxwD7ToyY3Hy3g0vbhrZBbOcFwXwbFgjf04FxtJUiTsge+zJzirkJpsFa/L+7UDjAmNU9P0zq8Kc4WNpsUlJNerh75l3XnpHJwgsAkf1fSiol9bMPFftTt1CD6ianibPTMPZOXy0P+Wc6cRvanxvSlW2d0oW13LAaM6VuGNXHc2sHg2PGBK+WJp7j8nuoYD5OQrBhZenY+eCstJMqiV2w3GHba/fpsIe56bp9bX1QisP5nz4+1+qqyd3xocczkNd/mEZLqqIpjXaQKZNwQ+zU1MRZD/Q8iMxlW0leufAjyPwIWE1bn9NSyYusCAHN6wcq8THXEUEL+Mi1C8k+sDCNKw3IWz2KUHiBGb6pZiTJRA9eXXEIUQCQ5GFaHjnCtM/TFoCLjNeIYPZGBUTygTFc9tcVXlqGlFCNvJTz9k9ncRczmh+PROpiyD69GrXpk9vmtkrw+rf6AAKN6F6QDvkWkK9jDIuBcDAxKAI5hHZGj+t6ETg8rB77JwrcamYEqkpw/Ejl29oLHKIpL0F0F3+B3cFrzYEVLdTzI5fSU7tMtrpRXrEHYLl
 0GaP7Ufn
 iqUnhFrviquH4rHohpeKnvCwu3WMjmKrU30sGlVIJNZLDYJ5GruHrzPxwoxYDc+Tn/Os1oYp9X/7XiLl5aViTWRZKMuHWHkTaOLFXtcIMwkOzXgPUSfa7hq+cwEs/TywEyIh09gbwKRl8IPzDuz0f/aAwFw4gsPiE7fwILC/cj1yF8NTVusQUTA86JWnPCmMDm+RiA4FWL8noI97BH/qzEoQbWjvu07k0XjZrFEb9aQHDA2njrznJysCTvM1/jROhk9qEAfYf+mUKgi2xH5YMQcrkUnyY9c+k+/xlnqnwPAFeuL/gMaLEzxahJ63U+ZLk9TaqtO0ZBOGxVXqc+gaRVkkCfYx2H00StF/o3XBw2e+eobaIBPHsnQqi8M+332/tE/BYaAzFaIQW4hezviIWjwB4lrolQlo0Fhunc77MihkZ3In0U3kYMKZS+iI/PDUHKpysyCp15qEEFsWlh01j5ZLykXOx4vXCuzDloAbVm9cpci75IKZcQSEpnk/t/BfP2g1QGjyjaPAuItklGz9P77tGYbABtELSFsksEAePw1s6hEGRcEhKoH7OZaSJQfyRGHzH+pdU6rn18zs/Z+gILxyJagX5/w9PK+xr5WSLPMkB3SglF5G3SBfVcqSfyshI1rbLVb+1oJiKUxGJJLvfibsA1OLOsMRMgjrf7PJLfyNEog8v0T4uK31mZqEeed+ZmPvZN+73IktbXa2WleSuOHOq4wpjVw6Xc3qwgpV1I06Q0mmiyydgk1wuoe/4KpFXUg3FqGvlB5TKcbLadwFBIkySqa4c0WH52jxPIcKL/tEY5GgFY/CJcEi8cl9VHPM1ki3ikanJKUC3WWLJ2UgpdvJAfMFw8VPj/ZaRAAi8S7zIbOSTINiS0DMd62tUSYWjzk7QYwMQ2QUlVZfFs+hpN2RpU8e6rLNd7WzThEhzO0CNaxCWrEq0EXUSIJs40g8tX7JUQ22TwAmSPFOgST882YVebfo+
 GMxPBIb9
 4hRpAalpTD4hjRIcdndKJZ7WHDqX+OAUQkS8+vPktqxByu6zyjIw3L+t7+z+NFcFlYD28o9Be19iupVEU0wPnpshJU9e7B6N7TcSeuvnZzkbiRXi7Jv675gzJH9Y4SsQ3g/6anoBDNrpbYP8nV9M30tdYpbZIK+9O9ZrH5Kj/AncNDTT4glG7YRE2nlYxHW4W5Gfwxkpjmj79LTIq9U2cdrNcjGJa8QxkQ3bXMZnOG2u56xyFBPhU912tJ+EqNPLZ74jdohH/Omk99bpgLKnSsVQagvtRkfGq2DYfhLVg6cPI/A7gPxJcRHh38pFMpqshgKMALRQLg8Xe6S+23qBsCtT/LnmTpD8lAAOVFHbDQ4IOyDr1HzOfugx2mCnhAGzdxrOvV1Rl7ifYbv9wzUUMcBkZfsjuomVY6mMm6MKhhM2U2w0xrRJqpJxW05SBLeRC2JaAhHUIJGQXYk1YGZ7jThmO9NUKPVoSnP8600nlogLI1mzTgkoqH7WC1o0bLb8xdzsxyj37mEl2tu/l7H3TsuwDlcQfbUhcG6J2qC+9zwXNQIQ0SHeNljY5IF94V6xPa0rsE2Kq2Ih7iGC5NSfOSAgTcZkbxiUpP4Ca3FXwx1B5haE98Bcpck0JhO07L70K0vBYsss52mnQGPKJgHu80vcMThy6W37Uw9uK1sT4HUR1tTr1eqjBT1MbxPB9/I3WRxZhIYro6pR4tnDpcaVgzWmi4Se1BvARodW70MUHzhFlUrNPP3W0ourOrOm7lQ3LAkAlGD/rFIcmKX8iazT4RVOTY8USp4nUGPulUfeg6pXg1mrs0NozecXcbbBLQ8bXev1cxwMuRyF46M+dxaPUTExm719Yw/EaBvUnzANNWYl6UE+4fuSJIQvFWVXe3dACgpmvTOWMbp33DmGEu5uZDNEehqlhUrzI4WZRaCCK2FUWax0bew8yIyZM7hIfQsUDu0mIScnyYA/r2NDmxC7YMw4yf8jx
 /RYTlN2R
 098kZabc4sTMMPIYYQjuUl3oNCn9Pgu1UPZRKzHZ7oP/gICAtocKXizh0cRrGNb8b3YmU7WqjMNgf7ntk94yrYZOSoy+obOfP4j5jJPz6ZitHCMGWK52uZmEdUP1qbybdGOpMTISsygX8pagIGEoljgsN1f0nc8UR4jGsYphN96U5f2OV6GrYES3yf+lz2eZG7dMU0FN891I4Hdcy9/L3ybGCxhvXN5u/bnNFRK+YmMbrJnff0n2I6RY1ABy7+8rl+q/yYwrOpGBtElExF5ZQMCyp95h3Kp8GCRc3fi/e0ano3GEn3+NdeNNdHi6SkjcZw6fYGJc0sPniDk+/O6GqSw3IxnttFEH4Bh/577Yc5xXV6xzA2CqXDcR/OAKKCCqIG0sjMXAGAfdofdQpJhT+32XsMuzqmPY5aB6qQGP19JIZ7N5/qE0DKkqkeMBh1MUpTxdLDKRMqiGwj9u1UOi1Ia9jJc0ZMNQTAdCKzSKb5JcQwBS4PjuN04/GEki0OcMMV61fk8h2Fbu8guWTHBHsefM3V014ZtTPzsxTicCI4yNxNOO1bqlo/AbU5QFmiQYxbW23k9zRTGvYAl+par3/ZdgBHvi2SqxSPH+gy3/XDZY/+OIjR5RDZR0nbn0i0+Uiylp66LcfRcvpUQpCA9x01HPBofRImwPFNIHiAsC4p6ssKGiMF+SQZGAhR88eWtxGhAr4KwjSji2Nn0cuV3VnPUiavJOG1QHlucV4bQgda84Sh2EkK/bIAskkUy/vCPyAjtBu1ccYkauq60F4IKE2DY9/K1HuQKCS85zCcihlL2uTB8LA0Vzopd+n8MrZyXJupkSDOAdBW0/b1+7L3H2QPkRyBJPiq2fGFSnWSQwoO7B3v91ll5jMZrVJhDpTb0bACW+S2dcDgWTdd78r6lkp1QYp5hTVLo/aGOYJVykyo5vFpVOz3a3PMGErsNnQCmrW0vYGowbmDFoEMxbdxMubKup6y5d6
 PBbQ9507
 XdfOhjN29zTcel46iMZgKCBDq8b7XkGXFJptIJIfjTheW3gd5vNE4J9Aajj/P3XNxN54KQOcOpWjuO+WLWZLZSSDk+g0xBUEICmrSB7VFL+l/Mxn6H5EI9vfoYmj6tGrldBIRIu7qvvRFHgCqeaxiIfbS80xwV2fRc3f8Jwk0Bk/f9ocUmV5hqrluurJQUR5vYkvKRCdudkQnEBSVqJ97Yy6WYryG2djuHzGR7iw8OXpTHM9Ph4Wvfv2SdB1yxzsVGjiA5XdPnyVVgqUqqNp7FvGoIO+vLxgQ19RkexH0djtXXOFBJsEIk1NuwYBs7WTUz/PyBXShtXZ2BatqpmS6NG9ilxXbTpXn6SG6tF0AoVC/tekAAA2ZA00ibVIqxyAJ0luFEuVzk0l90DbonueeUomncdSyzT1bY6fc3uydo/6ScJRJY2QgdJza6U/jBxnhX9w1NsF+u1doaKZqEuDHTyoJDZy47eVfVI3NhbtkjNmYFe5z6sSq3b69aYDx77T/pi+BQKDdJZnPBzNMYwtUxT7jcehuLhoPOocxZeJyoZ+8uiSTcFBzz+xO5pIr261vi7wV2O72WUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 1a251f52cfdc417c84411a056bc142cbd77baef4 ]

This just standardizes the use of MIN() and MAX() macros, with the very
traditional semantics.  The goal is to use these for C constant
expressions and for top-level / static initializers, and so be able to
simplify the min()/max() macros.

These macro names were used by various kernel code - they are very
traditional, after all - and all such users have been fixed up, with a
few different approaches:

 - trivial duplicated macro definitions have been removed

   Note that 'trivial' here means that it's obviously kernel code that
   already included all the major kernel headers, and thus gets the new
   generic MIN/MAX macros automatically.

 - non-trivial duplicated macro definitions are guarded with #ifndef

   This is the "yes, they define their own versions, but no, the include
   situation is not entirely obvious, and maybe they don't get the
   generic version automatically" case.

 - strange use case #1

   A couple of drivers decided that the way they want to describe their
   versioning is with

	#define MAJ 1
	#define MIN 2
	#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN)

   which adds zero value and I just did my Alexander the Great
   impersonation, and rewrote that pointless Gordian knot as

	#define DRV_VERSION "1.2"

   instead.

 - strange use case #2

   A couple of drivers thought that it's a good idea to have a random
   'MIN' or 'MAX' define for a value or index into a table, rather than
   the traditional macro that takes arguments.

   These values were re-written as C enum's instead. The new
   function-line macros only expand when followed by an open
   parenthesis, and thus don't clash with enum use.

Happily, there weren't really all that many of these cases, and a lot of
users already had the pattern of using '#ifndef' guarding (or in one
case just using '#undef MIN') before defining their own private version
that does the same thing. I left such cases alone.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 arch/um/drivers/mconsole_user.c               |  2 ++
 drivers/edac/skx_common.h                     |  1 -
 .../drm/amd/display/modules/hdcp/hdcp_ddc.c   |  2 ++
 .../drm/amd/pm/powerplay/hwmgr/ppevvmath.h    | 14 +++++++----
 drivers/gpu/drm/radeon/evergreen_cs.c         |  2 ++
 drivers/hwmon/adt7475.c                       | 24 +++++++++----------
 drivers/media/dvb-frontends/stv0367_priv.h    |  3 +++
 drivers/net/fjes/fjes_main.c                  |  4 +---
 drivers/nfc/pn544/i2c.c                       |  2 --
 drivers/platform/x86/sony-laptop.c            |  1 -
 drivers/scsi/isci/init.c                      |  6 +----
 .../pci/hive_isp_css_include/math_support.h   |  5 ----
 include/linux/minmax.h                        |  2 ++
 kernel/trace/preemptirq_delay_test.c          |  2 --
 lib/btree.c                                   |  1 -
 lib/decompress_unlzma.c                       |  2 ++
 lib/zstd/zstd_internal.h                      |  2 --
 mm/zsmalloc.c                                 |  1 -
 18 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index e24298a734be..a04cd13c6315 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -71,7 +71,9 @@ static struct mconsole_command *mconsole_parse(struct mc_request *req)
 	return NULL;
 }
 
+#ifndef MIN
 #define MIN(a,b) ((a)<(b) ? (a):(b))
+#endif
 
 #define STRINGX(x) #x
 #define STRING(x) STRINGX(x)
diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index b93c33ac8e60..5adba76c3f4d 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -36,7 +36,6 @@
 #define I10NM_NUM_CHANNELS	2
 #define I10NM_NUM_DIMMS		2
 
-#define MAX(a, b)	((a) > (b) ? (a) : (b))
 #define NUM_IMC		MAX(SKX_NUM_IMC, I10NM_NUM_IMC)
 #define NUM_CHANNELS	MAX(SKX_NUM_CHANNELS, I10NM_NUM_CHANNELS)
 #define NUM_DIMMS	MAX(SKX_NUM_DIMMS, I10NM_NUM_DIMMS)
diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
index 1b2df97226a3..40286e8dd4e1 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
@@ -25,7 +25,9 @@
 
 #include "hdcp.h"
 
+#ifndef MIN
 #define MIN(a, b) ((a) < (b) ? (a) : (b))
+#endif
 #define HDCP_I2C_ADDR 0x3a	/* 0x74 >> 1*/
 #define KSV_READ_SIZE 0xf	/* 0x6803b - 0x6802c */
 #define HDCP_MAX_AUX_TRANSACTION_SIZE 16
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
index 8f50a038396c..96b03a342f38 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
@@ -22,12 +22,18 @@
  */
 #include <asm/div64.h>
 
-#define SHIFT_AMOUNT 16 /* We multiply all original integers with 2^SHIFT_AMOUNT to get the fInt representation */
+enum ppevvmath_constants {
+	/* We multiply all original integers with 2^SHIFT_AMOUNT to get the fInt representation */
+	SHIFT_AMOUNT	= 16,
 
-#define PRECISION 5 /* Change this value to change the number of decimal places in the final output - 5 is a good default */
+	/* Change this value to change the number of decimal places in the final output - 5 is a good default */
+	PRECISION	=  5,
 
-#define SHIFTED_2 (2 << SHIFT_AMOUNT)
-#define MAX (1 << (SHIFT_AMOUNT - 1)) - 1 /* 32767 - Might change in the future */
+	SHIFTED_2	= (2 << SHIFT_AMOUNT),
+
+	/* 32767 - Might change in the future */
+	MAX		= (1 << (SHIFT_AMOUNT - 1)) - 1,
+};
 
 /* -------------------------------------------------------------------------------
  * NEW TYPE - fINT
diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 468efa5ac8fc..3ce87e5f90f7 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -32,8 +32,10 @@
 #include "evergreen_reg_safe.h"
 #include "cayman_reg_safe.h"
 
+#ifndef MIN
 #define MAX(a,b)                   (((a)>(b))?(a):(b))
 #define MIN(a,b)                   (((a)<(b))?(a):(b))
+#endif
 
 #define REG_SAFE_BM_SIZE ARRAY_SIZE(evergreen_reg_safe_bm)
 
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index b4c0f01f52c4..1e0678eb0077 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -23,23 +23,23 @@
 #include <linux/util_macros.h>
 
 /* Indexes for the sysfs hooks */
-
-#define INPUT		0
-#define MIN		1
-#define MAX		2
-#define CONTROL		3
-#define OFFSET		3
-#define AUTOMIN		4
-#define THERM		5
-#define HYSTERSIS	6
-
+enum adt_sysfs_id {
+	INPUT		= 0,
+	MIN		= 1,
+	MAX		= 2,
+	CONTROL		= 3,
+	OFFSET		= 3,	// Dup
+	AUTOMIN		= 4,
+	THERM		= 5,
+	HYSTERSIS	= 6,
 /*
  * These are unique identifiers for the sysfs functions - unlike the
  * numbers above, these are not also indexes into an array
  */
+	ALARM		= 9,
+	FAULT		= 10,
+};
 
-#define ALARM		9
-#define FAULT		10
 
 /* 7475 Common Registers */
 
diff --git a/drivers/media/dvb-frontends/stv0367_priv.h b/drivers/media/dvb-frontends/stv0367_priv.h
index 617f605947b2..7f056d1cce82 100644
--- a/drivers/media/dvb-frontends/stv0367_priv.h
+++ b/drivers/media/dvb-frontends/stv0367_priv.h
@@ -25,8 +25,11 @@
 #endif
 
 /* MACRO definitions */
+#ifndef MIN
 #define MAX(X, Y) ((X) >= (Y) ? (X) : (Y))
 #define MIN(X, Y) ((X) <= (Y) ? (X) : (Y))
+#endif
+
 #define INRANGE(X, Y, Z) \
 	((((X) <= (Y)) && ((Y) <= (Z))) || \
 	(((Z) <= (Y)) && ((Y) <= (X))) ? 1 : 0)
diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 2a569eea4ee8..9a9ca5a8918e 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -14,9 +14,7 @@
 #include "fjes.h"
 #include "fjes_trace.h"
 
-#define MAJ 1
-#define MIN 2
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN)
+#define DRV_VERSION "1.2"
 #define DRV_NAME	"fjes"
 char fjes_driver_name[] = DRV_NAME;
 char fjes_driver_version[] = DRV_VERSION;
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 4ac8cb262559..b9a58a424933 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -126,8 +126,6 @@ struct pn544_i2c_fw_secure_blob {
 #define PN544_FW_CMD_RESULT_COMMAND_REJECTED 0xE0
 #define PN544_FW_CMD_RESULT_CHUNK_ERROR 0xE6
 
-#define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
-
 #define PN544_FW_WRITE_BUFFER_MAX_LEN 0x9f7
 #define PN544_FW_I2C_MAX_PAYLOAD PN544_HCI_I2C_LLC_MAX_SIZE
 #define PN544_FW_I2C_WRITE_FRAME_HEADER_LEN 8
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index f070e4eb74f4..a66a2ee3a9ed 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -757,7 +757,6 @@ static union acpi_object *__call_snc_method(acpi_handle handle, char *method,
 	return result;
 }
 
-#define MIN(a, b)	(a > b ? b : a)
 static int sony_nc_buffer_call(acpi_handle handle, char *name, u64 *value,
 		void *buffer, size_t buflen)
 {
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 9d7cc62ace2e..8c7594720ef3 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -65,11 +65,7 @@
 #include "task.h"
 #include "probe_roms.h"
 
-#define MAJ 1
-#define MIN 2
-#define BUILD 0
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN) "." \
-	__stringify(BUILD)
+#define DRV_VERSION "1.2.0"
 
 MODULE_VERSION(DRV_VERSION);
 
diff --git a/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h b/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
index a444ec14ff9d..1c17a87a8572 100644
--- a/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
+++ b/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
@@ -31,11 +31,6 @@
 /* A => B */
 #define IMPLIES(a, b)        (!(a) || (b))
 
-/* for preprocessor and array sizing use MIN and MAX
-   otherwise use min and max */
-#define MAX(a, b)            (((a) > (b)) ? (a) : (b))
-#define MIN(a, b)            (((a) < (b)) ? (a) : (b))
-
 #define ROUND_DIV(a, b)      (((b) != 0) ? ((a) + ((b) >> 1)) / (b) : 0)
 #define CEIL_DIV(a, b)       (((b) != 0) ? ((a) + (b) - 1) / (b) : 0)
 #define CEIL_MUL(a, b)       (CEIL_DIV(a, b) * (b))
diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 9c2848abc804..fc384714da45 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -277,6 +277,8 @@ static inline bool in_range32(u32 val, u32 start, u32 len)
  * Use these carefully: no type checking, and uses the arguments
  * multiple times. Use for obvious constants only.
  */
+#define MIN(a,b) __cmp(min,a,b)
+#define MAX(a,b) __cmp(max,a,b)
 #define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
 #define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
 
diff --git a/kernel/trace/preemptirq_delay_test.c b/kernel/trace/preemptirq_delay_test.c
index 1a4f2f424996..91a3f4006ae6 100644
--- a/kernel/trace/preemptirq_delay_test.c
+++ b/kernel/trace/preemptirq_delay_test.c
@@ -31,8 +31,6 @@ MODULE_PARM_DESC(burst_size, "The size of a burst (default 1)");
 
 static struct completion done;
 
-#define MIN(x, y) ((x) < (y) ? (x) : (y))
-
 static void busy_wait(ulong time)
 {
 	u64 start, end;
diff --git a/lib/btree.c b/lib/btree.c
index b4cf08a5c267..b12f99d4c45c 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -43,7 +43,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 
-#define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define NODESIZE MAX(L1_CACHE_BYTES, 128)
 
 struct btree_geo {
diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index 1cf409ef8d04..5b9c7a1bfaf4 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -37,7 +37,9 @@
 
 #include <linux/decompress/mm.h>
 
+#ifndef MIN
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
+#endif
 
 static long long INIT read_int(unsigned char *ptr, int size)
 {
diff --git a/lib/zstd/zstd_internal.h b/lib/zstd/zstd_internal.h
index dac753397f86..927ed4e8c11c 100644
--- a/lib/zstd/zstd_internal.h
+++ b/lib/zstd/zstd_internal.h
@@ -36,8 +36,6 @@
 /*-*************************************
 *  shared macros
 ***************************************/
-#define MIN(a, b) ((a) < (b) ? (a) : (b))
-#define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define CHECK_F(f)                       \
 	{                                \
 		size_t const errcod = f; \
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index f5f80981ac98..bd66c28afb5c 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -126,7 +126,6 @@
 #define ISOLATED_BITS	3
 #define MAGIC_VAL_BITS	8
 
-#define MAX(a, b) ((a) >= (b) ? (a) : (b))
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
 	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
-- 
2.47.3


