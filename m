Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3120ECAC5B5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8EA8E000E; Wed, 24 Sep 2025 16:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C08D8E0001; Wed, 24 Sep 2025 16:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6978E000E; Wed, 24 Sep 2025 16:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C97B8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:27:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0736C118433
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:27:37 +0000 (UTC)
X-FDA: 83925279354.15.40C2E61
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf16.hostedemail.com (Postfix) with ESMTP id AB564180007
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:27:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="I/C6K9sE";
	spf=pass (imf16.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6qNB5bioMyGZXC3i2nj3ypKww+g+8GorxmNDFQZFEw=;
	b=X3MKcLwHR4Z9bW1s3v4ZG8NBFy/7lR0h2d2vyxLmwhv1i6IXWwlrqf8TiJKwnbRK9wRVg7
	iBJsrFBzIL4049/+HabiGm/ZTfiDPRWNz/bqh5FQ31jXDN512+1Ew6gQQDlO+Tu4dRp6Rt
	7jdN4HsyPa5+rcqgZAY1Ln0nx2AgkA4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745655; a=rsa-sha256;
	cv=none;
	b=fu4g9Je1BC2Ao+jtOPRnOaTmdRKI3PRxwuPxtAcL1SKy92XZrlWoymls93cfuVAZeoZUiH
	u46CvqS5XuIKqhwZ1WQ1Pb2lbqQgtsOcjcoA36rnw4SKqPJvGmA+kFyenlT3V18hbZswd9
	rVzYrTpvdNfFwl2amCnomM0sdH+0HdY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="I/C6K9sE";
	spf=pass (imf16.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745654; x=1790281654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c6qNB5bioMyGZXC3i2nj3ypKww+g+8GorxmNDFQZFEw=;
  b=I/C6K9sEIPMrcNMY13bq4VDtU9I/6eXRrW6Fsa4sboMDuNXZzy2sAhIx
   e4Md0knK8HxJKnyXYswVmLnBi0R9PqDGnwo7wAiTJm+PalRcvcWTeUMgm
   RQdTZn67FnSwSrXtS6qKiDEB96a+ruxte+e7I+eGsOBS/yydP+7HPAmPQ
   00cKEq2ENpkfj1PzbVUbDjLJY1NaDxSZyciIRUKCw35MoQpLVHxhmSM8E
   y6czP7pY/JLGWqMPjalz0THyTePeHdiEOXuYA9FqALDfY79CcSiKdcxnO
   gcAY7V+li/HMveUOfmCHodi5XCtD7KSdBGxShSI7g3BNnk5EEwQrAaASc
   w==;
X-CSE-ConnectionGUID: 2hR36KhpRXyNIwqF5REn3A==
X-CSE-MsgGUID: z5cz6NKiSYCpHW+AhiLuYg==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2527347"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:27:24 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:18302]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.45.166:2525] with esmtp (Farcaster)
 id 3aa99308-e149-4cef-9488-f6523614d113; Wed, 24 Sep 2025 20:27:24 +0000 (UTC)
X-Farcaster-Flow-ID: 3aa99308-e149-4cef-9488-f6523614d113
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:27:10 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:26:34 +0000
From: Eliav Farber <farbere@amazon.com>
To: <linux@armlinux.org.uk>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>,
	<hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>,
	<mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>,
	<harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>,
	<dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>,
	<snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <peppe.cavallaro@st.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<pmladek@suse.com>, <senozhatsky@chromium.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>,
	<yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>,
	<kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>,
	<ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>,
	<song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
	<kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
	<jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>,
	<wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>,
	<sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>,
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
	<bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<stable@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, David Laight <David.Laight@aculab.com>
Subject: [PATCH 05/19 v6.1.y] minmax: avoid overly complicated constant expressions in VM code
Date: Wed, 24 Sep 2025 20:23:06 +0000
Message-ID: <20250924202320.32333-6-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D037UWB002.ant.amazon.com (10.13.138.121) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AB564180007
X-Stat-Signature: den46or9p4g8hetw1u8jh57xykb13ose
X-Rspam-User: 
X-HE-Tag: 1758745654-32724
X-HE-Meta: U2FsdGVkX1+ir/APIBEzolPWtUGXLEh7tTURXpwJ9fpBsJAJ209fQHSMmQj+nLUFMVCvrhQj+PVvd7w5e7z3bYD0e7k9Q+mrgRhx7JRtVwMrdj7Ad7EYN/reKOtI0YI46lwcZMoX/kYAmciT5eg6QSoN7Rcy6YRuaKkU5GKcFFicFpChEHUglB9hm+d8YgyFQlOYAwNAvD8dN39ytGIwzS2aUAc1yyXxFMMJIYA53oNAnHkxsZfceQJJoV65FM8+FKD77kgH2XtXY003NGxcvyBi12sFfkdtk7CYiXG3b6xezkGWLXrVYiYnY/gPazFfSxDJtJkOqai5NpGO22RG+hzbbookLlnC6armQi44A/Ba8NoK+9OYBFV5E2vXuXolDyM8Yx4JlGwauv5VDXf2eha033Z/87qYousO7CbGZB6HqMRMmFK5+Z5/X3c2bvELdlmqKLHbzLhfYnZJgMDEJcSbYOT6DTS8pRw6ru3zbQlZU0aa6dAJm7faLBqHFRhEyygFOXI1p/ZwZcO5ddk6sChNbMxx51Tk+lCP1Yl9IC3S9brU89d7gxoBtp94SIyPJ4cOzD66Dzmb3+1mEn6CaVAUgh4bpfPyKP5glqUy/lNbVtSMblXXfV7lx0pPbBAFvhkURJg/fW3Zqq/BDz5l55gSr5EXMv6I4uMyf2aLErXzIIbNMs+xXCNGMqRetUHMJ1S6wJ/zriYdCfOrvz3Mv6qvP0yfg8n25T4QKucASfqCkF2Oo6TDN+q94vWB/Bb23I/HgaGt7lssMPdu3m+yp4naPFOk2ojQW+RvqRsVbO9PLyMgw65jPKqO/USjNnroCuzg3jWxZoR/6NnUkLq21qYOtAImCUVqxtob+4ihkEfKiaKhft1Z2Bh8+YybXxEKz6dId+s6U7hsrD/qkuyQGwXe8xdbSzVwKPhVq3G02tyA6PYTJGYIVUoZCTva9XfaS+GMNr0S1pim3ggvGYG
 IYC0zgzm
 cmyPaHlBbGajwvUZH4cLs52/X9a48o90T5ILWHzQIFks5s6IqAVCvf2PD24zpCTAEofcpfIox5R7nSB7rDarAMTTPr6w09Vux6r3fHFcXs+/K82pl1YPHaidGmzRoR1B1yuiwJ2LuWz7XQnzlVkjMkof3p7kCXfFJUhTwu4Y9l4RZ+rDl2wH+bPV/mRzXQiThwVtqx8Sh5OvxfaMxeMAzD0qze8jIk4RBOkq4SrHXfpwGFM1hyw8nBEyd74WrtVn0YS1Y2omB4/523w4ynWDn7Q9qOC5VNwzu0f/EtjQx8Nt3UnWtHpKDNevzthUw8BZS+kLk//LQCEUyMbRMLEiyj7VjN3e/CQEUmvYSDfmD+KeJec0ypLI8dYteMGuJw/QLi5BI7Sx4qU9CdgXF3KzWQTTQirVlxDeN+i2sqrWDwaa384HAZ54qEoPNOJ8m/29jlWvyAn7yYLscY6pVjUFYfxCutSqIOnbszSGdz4rCw2vRSm85IxahaLI8UVUq3FxnKxj5egQOxtsHKYnPkHu3thwGUVQ28/FN+i9BcBodvfzBp4hYf7+UyTMntUoPGWDnV9WvSTaxDFtqp+C/mbfl9et/FQh8Q9ZTDI89KUhJB39TH+Z3Lv3rtJf7m7ol7W8AqEpUyWRwiSUGqSIS8F659YidKasPaIL4oeDfeRShhCIFitUb/ZkNabAeyD2oxtNPSfdBFR99t+hhPwPWRimvVGMwUlocePGeDKY7X1FvYfE/FLhWDyXXJnpHHw0d91dWjp5fe3DoldUjgLq9ow6KA484gEGgmcbrrU6V9CzpIn1+DKsPT40+SJZABP1HZYlCAtlTAuaAH9VLFeoFv7sBoiIAHhRfW0L6u8Hhn/nnFZVXoGz9i4LLMnQLB1hB8dd8i/W7ffg4nN6F1m4R+ohcqPHD5CUTEdR2vHlme2O0Jv3K0RyqOv1XH5T30jLZVgFHTy6Fksg7GuBO+DoFx3A17/QJLsy4
 +twJ3H23
 gFMEGBbB5hgNq9FOMWPr93ogS7OUHOt0QWxaY97LwJADN5eCadaam/t1YV+CliO3NW7yVSEnnByVjXujKRe6fnw4RJT9mYTUVqq+2fyuWMllBl/pUmvlkbnGQlvUsn6G17Lax1Cb7fvoycZmZw74mCdC0DKItHc/ZU60IpoilBmoU5TkSTXw7a/8+oBLfCvxu/rQP/NmSvPi6w43iTdb2dRp+AqgMkoIRxw0P/PXLIRgf10zE9p39ULGpS1QslYQsEFzVa3p0fU0fmUQK8L68PBtWgggz6mLrjcCzezwqOFJfGzReiJTOrXWySLReP8bAAkbEMgq5O2ANJKnEss8Qvm1qlAzc9VH4ZL1/kU/9u1VgWYxgKqNOoeu2Flw905qOj0FUl2i1jGWFtDjK4hniI7FRGRW4jDr1MpmREJKvPQqTiEv1f139Le/xgUdUqmRZEsfOrmKjTQoaEPTvVRqsPkPKe+zVcjaAPiueqBKfm/vcRDLAU0DGgsG0mPBkbm75h3gWp4Q+GAtOWF9BOCZaj8tWtBcxSD1h9P3YvCbTGSl8m2Kro5ylszi92qNBqkms92hTUMgKv/fletEs75qoFimi3uLwYIHV3R7r2L6LWeu0mVUvp8E6UiR06L1G+vLOziThPmM3CKYvYFXlYUdmzO7AbWhZUzRoDRuONlHDYmaoGtfJxvFOWJyKrpNT3IHpOjX44rF6G15aH7qxA/6ELkTfK2cl8x7QBBo517GHrnzn7v7D4Ydo0z6IgiIB2NkaRsQlv7uU09XJ0hqMC8JeVAikLanILQ3diTuNS4eltgyJagXBtXJWsP6AULkd13zahi6JNPQc+L6P0FAsj5dM01zW7IQE3GbomM7aK79v59WOvASPB1S+LzV1Y7phJzr4xVvGFsy1VqV8TOfGUHR88dFQO4/ZcGZOqmqOKnp10yfru6tWB9iExP/joiEtRIcpaqOyjo7nz4XbJrQzRlVnkqJSa8je
 Kp2CIRkJ
 bmSDufExbbst13TzwG74uEYRPP5OzMiTANZ1KedO7oOpD9MYS0ghTyc5XfpkZMnBtlJdp8UCPx1y693xoD0geE6m2Qn7NOzXz+bgksZQMlH36SFJPpm6isnguHIG0CSNBUhch+apBFdu8ohuOXze2fa8ETTO+xSpLn/u3uzQhu/pOJ0HNJbEoTdkObQbXrcCxSYBHzSaMbaTShX+f7DOh2XCWxZqYiiD4czZo+K8F2v8kipVNi+R+dQBXhgqn+3wf/PetPRgwKCqenqw2sFyCUXrgbXsYITMEWW+BiE0iV5l+Bwm3frADE7zHZACLiFC1EZB+77dfxfGMa6Yo1yI+C+CeU8CBWmJHE5wrzLRCr+bvhqcekHio8dllqPr1260dcG2k8/J5jG6JCFg81SaH/ofaypVjvt6GOQSE1gomin8/FTjQCdb3XIG5GrHEOlr6Gv4oNT24SwSCnT+kK9MIxfg3A6j2GxYOaCKJR4L/QVsacM7RJM4xhJ0dZZl5w94g0fBP3RrZvKnsnwbotaxoTgDTSs0srHjMJBd/OG3soDQOCkXckqJzpiREf37AchRfyACzOHdJ+1PnwMebFtPEmL2db7/Yj1VfAYNaOih+ot6kq6uIGMaOEsA3Z2+4m/HNe8nXKDO0/v3v+qSXmONPh1XGjeLfveaRPgWdCM66rLIH2NDKdm2XwFCewOUskv6pLyBEr5lzbCT3hL085h7HC4LlDM3e0KDZq0fWfksCEFZweuzpgBwbpDVukpP15/ihCWoD2Qehh1+t3ScW7UCWlc3KR4cgHaBb1SmBTnvkZ4E7EI8aCqotDqpz4nSxQKUa8FoT2TDMzLhzDS8Yb4S2adsa++IYlfk8lQ2qRmob0XNnsUPM7BZPV4jXLHfb/w3vQCYUuxbIxqny0ejFXdkcFIURyw1gUR3j6UXz6pOpLzLnhQgpQ9usnZz/NG7xDDWIvElcjTvDKfCvwZNVTh8Jq09unu1p
 ct5DIE6u
 BcP92LC03TefNtv6r5tQ1TApHWOPCxQEABJ2c8x/i7a05ggHxGWm0+cCQrhuaL1pFUn+osH7C3mZDgA1uWdPy2PXRJ1dhNQiiVlmLTpSADLWhn/HarghTTSsvEmW7zlGzCvuSE3mEwa//J5/GeF+KqMB/S0zikuXHPxlsqaS3+33E4DAC7wlWT0uejQqWtY/+xPfaB0UewRQ1e666TAb9CX3fXBwVwh2TV2hvAj4BaM3G+OvBxJgqecTij6yvhp1WGIUTNxpPpqN60WyhdT+PqIHVmJTqa6ZDAAPCo+vg0aU0IgFSuiLl4Quz39qZwdKTO8QnQxN4VJxFrk/gH/FmS1G8bVuW+3xCplN164Zm+bvcCZ2pJOBWmM/zWJgRLruqgb9+W6/MMnTbab5zPyFTR7GnZfm0/6QNakKb4JtUVxTlXuESllM5kMYXRLX4sSrGeTeB+hxe/t7g0fxarONUR2TXxfg3hbJMjJBQCVbo3l7qpdl8GVf0H0UDkpKt5zpdujVLLbw0me01u4BZ3dxqIeKhPaXNnZNMAHqQJImGpsXuc57ROiMjwFAbtAnsGUlan0+6wrNLZ+j+ciiVQzmJaktORvHt7kkidPvitMNZTWiqd8xfo/7j3JpXfgrK5r89afj2A0qXGbhiHUK/lU0jZqSf3LW2DQnKPFONnymYMprkxudPx1I0h0shNKDFpnVZw3DcpADpufjMH6GmJCyIDFd5NcvGxW82Ne7M3NiVV9rJXoH4csRNxAJTAXcBXXjRh/eD20KKdQ4sXo7ECevocDhg7BTIMhZO5VMHqwS/CMKCNpsnDBsdRDTqQT68WaDtVR2033T3Kd2SQ0qPgulX/jogifgeCjWkfkk8qTtlehEDDI8yeRnJ9VYxKyy6U5Ar8lJv6iueW47wf5X58/oS65YTFMhRO5865U3AIzJiVE8Tey3RaSX8vE40E7uCc9c0AD3bkhLyJ44ZhJBmomgh2ZftI4yM
 NgIM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 3a7e02c040b130b5545e4b115aada7bacd80a2b6 ]

The minmax infrastructure is overkill for simple constants, and can
cause huge expansions because those simple constants are then used by
other things.

For example, 'pageblock_order' is a core VM constant, but because it was
implemented using 'min_t()' and all the type-checking that involves, it
actually expanded to something like 2.5kB of preprocessor noise.

And when that simple constant was then used inside other expansions:

  #define pageblock_nr_pages      (1UL << pageblock_order)
  #define pageblock_start_pfn(pfn)  ALIGN_DOWN((pfn), pageblock_nr_pages)

and we then use that inside a 'max()' macro:

	case ISOLATE_SUCCESS:
		update_cached = false;
		last_migrated_pfn = max(cc->zone->zone_start_pfn,
			pageblock_start_pfn(cc->migrate_pfn - 1));

the end result was that one statement expanding to 253kB in size.

There are probably other cases of this, but this one case certainly
stood out.

I've added 'MIN_T()' and 'MAX_T()' macros for this kind of "core simple
constant with specific type" use.  These macros skip the type checking,
and as such need to be very sparingly used only for obvious cases that
have active issues like this.

Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Link: https://lore.kernel.org/all/36aa2cad-1db1-4abf-8dd2-fb20484aabc3@lucifer.local/
Cc: David Laight <David.Laight@aculab.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h          | 7 +++++++
 include/linux/pageblock-flags.h | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 2ec559284a9f..a7ef65f78933 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -270,4 +270,11 @@ static inline bool in_range32(u32 val, u32 start, u32 len)
 #define swap(a, b) \
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
+/*
+ * Use these carefully: no type checking, and uses the arguments
+ * multiple times. Use for obvious constants only.
+ */
+#define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
+#define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
+
 #endif	/* _LINUX_MINMAX_H */
diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index 5f1ae07d724b..ccec17a67af8 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -41,7 +41,7 @@ extern unsigned int pageblock_order;
  * Huge pages are a constant size, but don't exceed the maximum allocation
  * granularity.
  */
-#define pageblock_order		min_t(unsigned int, HUGETLB_PAGE_ORDER, MAX_ORDER - 1)
+#define pageblock_order		MIN_T(unsigned int, HUGETLB_PAGE_ORDER, MAX_ORDER - 1)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
-- 
2.47.3


