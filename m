Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 353E4CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9C98E013D; Fri, 19 Sep 2025 06:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6737F8E006B; Fri, 19 Sep 2025 06:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5147A8E013D; Fri, 19 Sep 2025 06:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC938E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:28:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 031B2BA63B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:28:31 +0000 (UTC)
X-FDA: 83905625664.08.EC15EEB
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf14.hostedemail.com (Postfix) with ESMTP id CFC0010000D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:28:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DdMh7meR;
	spf=pass (imf14.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
	b=hUtbSQXSEluEQ3Z7il5m6t1hJg8Jq7lG9E40BNtuH+W4/DfzXwMalICHxqoDp9KeqXdbK5
	ecQ/KzGvrG3kCpOlmRTvY11nD52iq2qM9DKTTI06nbusGEB4PuKu0r2fmS/0ifMR0I/aUp
	CI2e5sV2gf7um6ak5G9xUusq/zvM4fs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DdMh7meR;
	spf=pass (imf14.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277710; a=rsa-sha256;
	cv=none;
	b=JxyBw3J9M46MpZhTpKfcMdA9R4FYuBt9FeYBSJLlIGGcKgtbxBjDQA0PlkxNW4s4g+JNgq
	xU4sb5aGmsqorF5kQOHZDHrbWTcuNZLO7X9oU9WNgiGW32BdRO38OJ+hTH0GWWwOG/16QR
	dQyAASgM08/Lw3Krkbnm2Q0eMEAysPI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277709; x=1789813709;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
  b=DdMh7meRpbeQk0lRMrEvZNQdNAzVx7A5BwSIG6v1L6YXX9Ni8DTmS713
   4ngf3mITDFltqocD5qQmNNCKB+4nY90SfxmtmUyYg7pjrjbn6+N/KFYmu
   WzyPKx717O9bv5w54lIommWbVRf4Uuh8FA2kEtl4LN2cZJBmLxTcAv2ls
   TwgNQLLnn7aBkojpfyDiYO1mrPaL116hary8Eh6VWzNy3RBro74f9/rkW
   wx27JJeh/3nUN0N/DWjpP10nZTkDpWvrfefotg30woTm7GW/m3wg/IwEv
   fdrdJMnUiFqVa+WJ+5WsU9HR4siviYTGXul9A+hoHZsAQA3EV9zUSpGAh
   w==;
X-CSE-ConnectionGUID: 2O3lpm2KTiSBHXT6LU8EZA==
X-CSE-MsgGUID: TK648aZZSuy2xvobET8vsw==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2256484"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:28:28 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:1831]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.0.240:2525] with esmtp (Farcaster)
 id e711b9b3-6719-4b3a-b00d-9571d2aab402; Fri, 19 Sep 2025 10:28:28 +0000 (UTC)
X-Farcaster-Flow-ID: e711b9b3-6719-4b3a-b00d-9571d2aab402
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:28:25 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:27:56 +0000
From: Eliav Farber <farbere@amazon.com>
To: <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>,
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
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>,
	<yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>,
	<herve.codina@bootlin.com>, <Jason@zx2c4.com>, <bvanassche@acm.org>,
	<keescook@chromium.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
	<freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
	<linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<stable@vger.kernel.org>
CC: <jonnyc@amazon.com>, Linus Torvalds <torvalds@linux-foundation.org>,
	"David Laight" <David.Laight@aculab.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>
Subject: [PATCH 18/27 5.10.y] minmax: simplify min()/max()/clamp() implementation
Date: Fri, 19 Sep 2025 10:17:18 +0000
Message-ID: <20250919101727.16152-19-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CFC0010000D
X-Stat-Signature: uxufeyqsqebhhgq6cimy6hkwyop788ui
X-HE-Tag: 1758277709-679864
X-HE-Meta: U2FsdGVkX18NXNG0t2tgEu/w8UQBS/URk+bblQG78+F8+fnrFVHsY/us8bjwHCKrBOfOR+PhVdgazkmWKBqFoUUF4ALbA+4UK8ELC9+WIaf+jaeDKEphXfkrojjM8TeHnoqviuz8f1thgIpy/OXPsRglQKXavj+GlgW6Di/gEIHmpMJ21GjiK9gpqsL9FJwoFmMoOgc+cSUjjC5RK9cP28xRrkFbbaKFdwV+bBu2N+jzWs5bRqHdgbk5rfwzLNkMVZzwrnGhbOdKFf1SvHdFHP2mfNp8xA4l0bw7bFOZ1jn8480U64urUKFRbYJLvSiUVjDUv3hW2vEgyRPIq06zobujX4GZEaqrtlGhvIroh6arO/gycb4InrR0eA4CT4bpb9OuBLix7f52sfVurnXedrZtbUPZpLCemF4qFlcGPD7dzEmJ8XId7ews8/mjWAQI4VBOmQyf8sMQ5VqOOWoE/XMCDIOIH2dlnJJTQxUJbYjoCfObWReA6H4oFFbl1DwxftaY1vZy+8UZ6cc/aWzZ1iI/0MUTCfE9ajK/8i9CNTQlIhNxsS0ovYMUbSmCVejymX5K+NSfG5kQPqA4/ty72UJrPViPYgLYlidLCT1rK0IvXS1IO/NfjusLowmg/8zszEUSmAlEPEv6+QeVmYWci/sOMvqeo8QZnDfirSxXabBbTAtaxqPuBq0Ih6qynzCn7sSwd1orl8affkdMvWDhziRo/gRDKP0s5vpcsxlzEfWA/J6U9ps84M66Je/UWbdoeksGx37p+4eEx+e4+5A8FXh4gSRa2rr+XHnZ86uRrTG/LixyMSCfkoNAv9adXL/XeCYEMnCUaAg+0Hkp/u5uVrxEMAQSC3Qtw1B/NmWt2w33RDbaiUoLwvoCFk90/i4rjbiq600UfOnemZwYRkQG55eYW/ka4ntQ/iXoLV5PB/wTjZMXvby8ncPbY9MIVvIt2+09gZWJIXCM2sm+UWI
 Sjl91aeM
 p4DQOhg8NHlJpHaj+ToLsrx3g9m/rlJlf6T3rbbAAdwwVGBWE1cXdSXeUJVoiw73taMWXyOSe3Z1L0fReRqGC2eSZKKLPtYlAETl+B58tuoFO9BJv+cW/PyPLqCaunkVpknr8BQwnPiaM8ARxM/sieMprCFHMM+wULOc5TAwXBurV+D8FpnaZcXfqBp+1e/rbc4bnMC6VTtZ9xoAGs8cv6IEqoqyRIL7mFV/g2B9Olpdy8niBKPVpczaLAZSQiT70YoLnrweJ9rBO3B+3q2HTJGujGUdchL0gZbyL9QnvTwcn5LRxDQXntX+TB/9cf7mR9pRbz1pI+tT5XDq7QQh2g6tI3CROOD6km2kBOMmab8CC2QWp6+xlPsi4Le7p7QzTxupN22xNqVib4wBcdUa6XaPnx+VCL0yj5h1n6a7iJhbvUWQh79eEn6nM2XXz8N+SU0EiYXeWV0OBLjHL8F0YkswRBIpcQKAOsKidclAHclCIJOH6gYcAFbPyT6juaINWVDNi6jA912UaQ/dlQfgzdexcnzI+oFaWKclloJXgfrh07e9yLT59iFKXVxxB13tARKn3DyTrkX/k9vC6zm6Cab4hs99F41XZ/L5XbdhGiBIaoyuyhUrhPU4FR9w7LXB2r0q3p1sOEejsLcCOSPLk+l9qTMIt2O0k/X66p70j/lVWznbRs2xLnwOu5o1gS0D0uTjVvZqNwGsBo0AjhCdEsI3Xq03Rc8P0CFQHe7ztGQWp2hWyqpgUXiBIE6D2aHkiD1tSBG02k6FYGmuHVwiFZoMmAAWyyc0WMNeS//Jsx1h5O0qQqoSS0+1HAyedTy0fJ35cO5Wv5gAi2CZ6GtL/+7ti/V8QYa+Sa4Ap4xiyYHhHG/bFljlShjlp0nPlhEYZGbvssXHlIQi2B88lkvBPzDNtFCgyqTrkeQZo9tshiMdXG2j7gVISK7iz5VlWWm1zTghoI6C/mEXDJDoKJyy7OoWCwXda
 T6T9J3ty
 WX4A9Ns6PuwvByHKm31SxtMWO9ZewjZpW6Ya5+N5GmMmHe7Ix8DqczGPqpz/DTWP9obSY01cq7/jhsUNZCYNMljHhVNyWyZZJ1ICo/lrCFJAheOEr64qpG+bGX8vBKRYX1D1ZhnismzfqmdIli6tALBMLhxDTX5/r0A+CttzPSX9rJHPbd/6kOf3W5b5G/ndH+gTvJXPO/EwkIvlKugM9dmyzBYlnANWpqbdvYvg2FEiJCMoBcUsvLj62WWMoxj3/4zphMOGhliAtuNz6TNtobxuK2LyWkQUSW4IAv97mH/6Pa9h2rTRyBA2KuBBDoW7ga+XJLcKiOabYDD2XDZTDTZdbaWAuvRMHHp0fC++2xruY2d0zgf5lGAyflmcLSatBmaY2q4/mPJVJ5SdNhgMrinJoBlGLjl3KCahIDC9zu9BnV9sO7EyxuVdeJjCp9ylMqRAdlyVmjGiykyd7SFXI5MOKeHUojWBE8aqG44B7ymizj99ZG30BzIFRMNuvHdCgw7obhGUMXbzAwP3tlmaYYmn0Z9ddjb8q5jjZumCmOuIBB/e65yU5xA3NVdGZfzhfKkA1MN8xI4sZ0gbRl0JEioY+QT/IzyK2bvAaTeyhP+0brkw/peF+7w84ZvAKsy+m8YR3tX0LsB4wr+JKca5S1G1LSZdJWSc95Wn5ft4tuOi0hTc3Xk1BRZCXzkz4Y5fWyjLOabaYb964TzwgDDTdsX3+b/kAlWVb6f1cm800KlTt1mNv8eGzKp3CvSaRHbA89JyFiS5Nf3NwBOpRJ/7+3Rz7bshRi8hQYvWg8/jSIiF1MMa2jd9yvZku7VCvG+wqpPKs2AqvqwV0O7vCnZzcLWhJXxHKB6pUufYKV8QOXTFuQEwxD9yll/kuOgK1x2o8IwxGVjT+KogAnpQevOch2UyqyGRrLin2zORLz2294M54OOtQeycOH2pmmfNXlw4jkv2hQcvAmehermpTLTfvIgqT8k6x
 yr/7hTH2
 lfvtkILOQJ7kI5oX5ee1RqZoeuY2demFWblipGrQJ+QoPV7UuPM9isdxQZuDCGHUGWyPUkmLBIwhY9sO+uVzJJ9Eqn+DkteBKd7natqkXAmsY54zevHV30ZMOOaps3Pjtqx4oZVXxzWfVQ+4mJ7A3VbLFRO6pkijx4nRHEqU/GOcYgUUnmWmaJ0tJsCK63EP+KlfR6O1pfHfBoRy4Oby34aLZU+SwycNB47vWc+mVleFcy+5PHfqs8eAyQl22sMcbhfBsIsuMCe1ufa6r+WPWJ2bIPwObW1iH8n7guqiu9gpaue9SNJQsMqqhTVbIJT6PQ+5tiSHg4r5qlCWWB7aiBP23HJetil+4NYPRHlPASbRJm3htb6G0UzpDWr8JmnZQZtZm/Njue1jF336mSp7+/zFTd4+FsTeOFIw7URn6ExKI66DC6VcX83l/GG71ia2bVoZL9yxMDqSitsg0QpJ0R5ksmVBJ2UNQvh9lONRMo6nEQfxRtfjz7iIgXrMeSFpCxNRopzK+A6hbdAXf6hcE0djNlEKWfprkibP23KPuwFR+s0/+lZoSLET80iDDzfYRyXZUfvNF9S5AnZ9MBMq3l6h5tUljOjpvpW2hbaKhiKgbt4HTPJGVnlKfmHt4EwfFzfw9cCFEE9SkHPLRnwj/3t1zcHx6kPhP+mulTWsA3hyMo4NVmzP4ySCQHA/oYXpccmo+7pMQ3iFDn4zSNv7xdDt/qKi8xG1FI5dKHPzAiSCUtIsCLgWZSnF3Nz62HmMdDHZ+biD1PYd7d2uts46ERzNSBGnh6xJ/Cu/UCcvg53VxUP3Sjn4UmZDy/+fmMpbsLZttIBmorsuefKX+w9jWQpDYnEi0fZ1wUuIQ6uIJjHQxntMcmFN6spFV/roN1LMOQibFxGnDQ0vjsV3REvs99E3p1qPWb9z/ts2pEKXYYTk0KMKkE3lilWOgFCCGPsY909lLFcRgcBzhH2VLMjSMgZ+xB6Es
 zon7/0ZB
 2XfFOxm43y0iB5UB5YB/DSXIOmvWSEvnDM74jqdU7RBR2ys/jl0mru2Pm/ufv//vve3OZjLn54sy+ishfLNduX+TqLPj2cnTKiP/YWBnRSAYSiq5Q4+pJbXODKWVhFUmDX4Smu9Aw7Uaucv+qO/wlmfG/AUxn23qXxTBJMZG6KNvBmpwxWVOfoEKQFt3EbCsOaP3pGOZgKK6dKzL0EEl49xNb315vj84BPbJrJQq0AiIAB7OQq9XbzRq2R1rqTZC4YmTqe0zTnYBTOTKLvki8l60TEdkOj48n0n5D7szSCGDOCV7TRbEk+YsXlPE+0n2ZEAXI4Sblnit09wlXwmHVyZx1tVgVDNPfmhfZuEIYWcSSdxzSl+8MuuLbCevnzCc7uPHYFCGwFLiP/6wJLZysv0Ff8fm5tPXOaDhUr8rvFYBpYNxVzm0X0f0yUC1s/KTxDRu+P3nsOvlJ1VUVgdmPLQVjzAMJUFhoPt97HMCwfRopDScoFPDFQ6cxBTMH7lcRbM/rFM1W8tuQwoDnBtT+Xu74OxPqlTvcZtEK35HssMuZvdfY0cZ3/xLKgravvkxUyM8xaAAOHtQ0h2josgm5f9pSyt8LesZ3mWwZztMDBBk1d9fYhZlJsEQjjMemvP+UqILPmsgwqC575fL8cRMJJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit dc1c8034e31b14a2e5e212104ec508aec44ce1b9 ]

Now that we no longer have any C constant expression contexts (ie array
size declarations or static initializers) that use min() or max(), we
can simpify the implementation by not having to worry about the result
staying as a C constant expression.

So now we can unconditionally just use temporary variables of the right
type, and get rid of the excessive expansion that used to come from the
use of

   __builtin_choose_expr(__is_constexpr(...), ..

to pick the specialized code for constant expressions.

Another expansion simplification is to pass the temporary variables (in
addition to the original expression) to our __types_ok() macro.  That
may superficially look like it complicates the macro, but when we only
want the type of the expression, expanding the temporary variable names
is much simpler and smaller than expanding the potentially complicated
original expression.

As a result, on my machine, doing a

  $ time make drivers/staging/media/atomisp/pci/isp/kernels/ynr/ynr_1.0/ia_css_ynr.host.i

goes from

	real	0m16.621s
	user	0m15.360s
	sys	0m1.221s

to

	real	0m2.532s
	user	0m2.091s
	sys	0m0.452s

because the token expansion goes down dramatically.

In particular, the longest line expansion (which was line 71 of that
'ia_css_ynr.host.c' file) shrinks from 23,338kB (yes, 23MB for one
single line) to "just" 1,444kB (now "only" 1.4MB).

And yes, that line is still the line from hell, because it's doing
multiple levels of "min()/max()" expansion thanks to some of them being
hidden inside the uDIGIT_FITTING() macro.

Lorenzo has a nice cleanup patch that makes that driver use inline
functions instead of macros for sDIGIT_FITTING() and uDIGIT_FITTING(),
which will fix that line once and for all, but the 16-fold reduction in
this case does show why we need to simplify these helpers.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 43 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index fc384714da45..e3e4353df983 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -35,10 +35,10 @@
 #define __is_noneg_int(x)	\
 	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
 
-#define __types_ok(x, y) 					\
-	(__is_signed(x) == __is_signed(y) ||			\
-		__is_signed((x) + 0) == __is_signed((y) + 0) ||	\
-		__is_noneg_int(x) || __is_noneg_int(y))
+#define __types_ok(x, y, ux, uy) 				\
+	(__is_signed(ux) == __is_signed(uy) ||			\
+	 __is_signed((ux) + 0) == __is_signed((uy) + 0) ||	\
+	 __is_noneg_int(x) || __is_noneg_int(y))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -51,34 +51,31 @@
 #define __cmp_once(op, type, x, y) \
 	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
-#define __careful_cmp_once(op, x, y) ({			\
-	static_assert(__types_ok(x, y),			\
+#define __careful_cmp_once(op, x, y, ux, uy) ({		\
+	__auto_type ux = (x); __auto_type uy = (y);	\
+	static_assert(__types_ok(x, y, ux, uy),		\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp_once(op, __auto_type, x, y); })
+	__cmp(op, ux, uy); })
 
-#define __careful_cmp(op, x, y)					\
-	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y), __careful_cmp_once(op, x, y))
+#define __careful_cmp(op, x, y) \
+	__careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
-	typeof(val) unique_val = (val);						\
-	typeof(lo) unique_lo = (lo);						\
-	typeof(hi) unique_hi = (hi);						\
+#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
+	__auto_type uval = (val);						\
+	__auto_type ulo = (lo);							\
+	__auto_type uhi = (hi);							\
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
-	static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
-	__clamp(unique_val, unique_lo, unique_hi); })
-
-#define __careful_clamp(val, lo, hi) ({					\
-	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
-		__clamp(val, lo, hi),					\
-		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
-			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
+	static_assert(__types_ok(uval, lo, uval, ulo), "clamp() 'lo' signedness error");	\
+	static_assert(__types_ok(uval, hi, uval, uhi), "clamp() 'hi' signedness error");	\
+	__clamp(uval, ulo, uhi); })
+
+#define __careful_clamp(val, lo, hi) \
+	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
 
 /**
  * min - return minimum of two values of the same or compatible types
-- 
2.47.3


