Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0530CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0855D8E0010; Wed, 24 Sep 2025 16:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D6B8E0001; Wed, 24 Sep 2025 16:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8E008E0010; Wed, 24 Sep 2025 16:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D98D18E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:27:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F84BC01A5
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:27:57 +0000 (UTC)
X-FDA: 83925280194.01.4D0B403
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8329B1C0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:27:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=tEyBdSwt;
	spf=pass (imf21.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIzXOOEvZKeS6UuNgkU2k1mesw4I+NOSJCqENQl3gzM=;
	b=hb41AhUydPfXly9D14r26YrDKzYAkkbHG+WuswFXiXczUwsXygDdtjHnE68AgcJl8qnnS5
	569yOtqvf+JWqjo08lV4hElWsEya2y71mLIVl/8ebOHZ8ofbYjPGYdwX/15/njjuVoPI7u
	iRQYaX29aGdgvTNN1FN4sN65+Nn8ryE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=tEyBdSwt;
	spf=pass (imf21.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745675; a=rsa-sha256;
	cv=none;
	b=n0xJ30JYDLOknApdaWgqH+HgqQ2jLF0LSJGCf9k1W9RxclIJuOmmtpnbj6ABevScFdXYDl
	VF2L+j0q0l0u5kv3zG5jgtHkVOesu/iRB6n8K5For5x4CHvqUv2IGePQdwN55Vo0LeZ2YE
	ZLj7qSGGjBBMT69LmA9TLQsidUC+/RU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745675; x=1790281675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GIzXOOEvZKeS6UuNgkU2k1mesw4I+NOSJCqENQl3gzM=;
  b=tEyBdSwtAwKhiP04R+40T0v5t/lu3fGAcsX6+AyRy2zctfMxwQI5Vgw1
   HN38O1GNhMZlsBbtjEHTp7+1++koXvI8FTBSmboie+VyELjyEReJ/lvAb
   31+MOuQvbaC519mKEGyrZjkCZ6idjPuYDE7k64bpyMDPMH4gYjLFSZ8x7
   Au9SEjfGXFCfXBsA2BGhCDDovz1GK9U5s4e8V/5t3jDWtYHSmWlyoQuPk
   D27j9meMBkr6ERo64isU7qWsZct5pNAfbjX9s3Gnm/qlcfqzOSlyfgzHi
   JNHVrr2zAtRjqE+M2jfK9bKQOlc/NgnCr63CwIKx+tV6SUpumWWq/eHYa
   g==;
X-CSE-ConnectionGUID: tb+xLtZHRNyCcq5D+kLImQ==
X-CSE-MsgGUID: Aa4QP0/wQFe1gvmMRRqu0g==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2523201"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:27:46 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:5140]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.230:2525] with esmtp (Farcaster)
 id a4476151-b5ed-4367-84c6-5e3180aa5137; Wed, 24 Sep 2025 20:27:45 +0000 (UTC)
X-Farcaster-Flow-ID: a4476151-b5ed-4367-84c6-5e3180aa5137
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:27:45 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:27:09 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 06/19 v6.1.y] minmax: simplify and clarify min_t()/max_t() implementation
Date: Wed, 24 Sep 2025 20:23:07 +0000
Message-ID: <20250924202320.32333-7-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D037UWB002.ant.amazon.com (10.13.138.121) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8329B1C0012
X-Stat-Signature: swghuebj8wz3rbz9mbj8zr7duje9hw3j
X-HE-Tag: 1758745675-634364
X-HE-Meta: U2FsdGVkX19Ay/245s7W/aWSFCQCuo1lUOwxS/0i9EuReHemvabxytG+Zw7dM2zTE+c6ScAg3gOXyDR+IMRttqJkUXPWFddEhnk3QcNrnxTpsdZbb9FyzfEt9hzzF17H/WhnIHht9D7vVAirvz4p07hF9+dWPHhUygG5xSWtdA1O4sdOxqRosNyy/K7eBR/yOSWBD4B8Xr18M48FRsLudYCg2pGR53ne5t1OtADwfZhHaouvnKAYdbqnwpneaIJe5r8JSWukY+8qlbKRzFzUTU+XNX6U6iLTrVLXnVvz3iz9X6/gPvSI+Yrz708T+3US7xjcIO7R2Ggel8Nc8ylD87D1jwaElOk9Ul13p4YHfKb822KT7kvFvmCtBOp7nwX2ls8ULEKfQqvioZh2oD3mGMmBW2jbySMwCNCN143YQ5CQFkuu6UyEXeLD6iuBsDjn+lnVZMQZjMCvUlE5rfMrobuXECA1rroKHqCDvL70BnNs2S0WKlpiVr/hTnZgnkimjpKdeX1pqiZFafomx07JujpzvQv3PbNnyRCMeWV13AD9Yda423hWQ1t1Om5mL5jw3EpFTZFrz5KuSH2rsuS+MlP/iMs882yXN1UHLVB9jTpuWSVWkN1Y1MOkAPMf/G0PQIq15oeBRnqyw4llQp3t/5ybejhp9OJxVG0Pim+iLoR0NVrdhcbjMbJkFak4KxvazEIDiIA39xKZhuQ+WQEiGN5YU5HMqKOOACfp3Nb2YZU/ZX2UGe9BzRbxWjSYwGLgbn2KFtZV6T2CN+khzWxqdcfusiC9tAGPnPsOip22zsK/huxB5kgMW+AS7mTz68zyTucMnLaUuCpsPNnuETzytIF1JlVjLK0lVgctoSe3d0uYrMOnCIWSv3Zb3GCIo+7Eg93jPyecEL+H8DIlMmwAjiC87TLeZHYdYrgG/VukZ7JkEV4b0ICxXkAevfQRQIc9V4DTHgdITd7NFTiLSTa
 7HfkcJMd
 ZpoGrswWQt+DOmuVWRxYRag4m6ppQiDWBinhywz20i3zR+9OnkTNy8rWATgfsavr6lavzY8yXTMZEgU/Tx5BYu2tIoT9eECsRX3xmgyw8vnIrd1gcEeRyi0W4K/KoA+1SixI6XxkwCBE48/fB6DkajiUoflvIW7W8ITJjlO7suBXgK2RIcln3p/3K4BimrGJYY+RJQSx8Ep45Yy/D8CvF/7wPYOfSJ65tzp1jWeMW8L6QaVEmQpTBJ3/kUfbRwiezydi+p9hINg0LyuDhoaYX64c1GeJ4yKOt0e6rP3mN2O/82t40k6MeLCxqzuwLrEluxknFEn/L15D1PG7/XZPZgyofMmnKoERO2E0Ow0cAJbcM/ZU+pcsUIfKJ1hMOvkESHvtcpNI7WtoWE8h8l9vGQH2JCmCnTspcpIV1X58R3mEqb3JSVNhW0U2x/LjKRIDJUkc0VRNiFh2LsaQ0HWoa7/QkKhnP37VZ/34yTNwJExWjbyO1D6NUSgJb1bUYu4R2FSlLbMfg1ghZ89O0xvX+WBzcRUYoJmZJsctfeYnAWy8yEHxexfoLHsH3jURFbgCRSDuH9HMRxHsQKf0XB1xVjz09pW5HQT4Yvq/MlEjzi+KAPnLNaLho+7ioXG6oysRv5Zsm+xLgfhYPn47zJ4NUF99N98l/YQqjaqcX7Khui31CMRahmD+hYJJ2vq3G+SQbpU3tNebJ13je+jNYhasLEKwXsMrVmOQlTEMD2QO4Q2Y7rb06+GWPuTw26giw7QezYWyCt78L/MkdFrVTZlhkSwpDx0Zt55QM3EiWluUtNdyn4as9IWqGGcX2xIryRMDt3Dqhccd6PyTgaQ7zWJ17dDfyZ/Fu/WLbq0Nt1EDS5RYBU/CX4jjI5M6OnCfz4eo7zdaB1DJdIHrVfITKkoj4PhW+PNfFBPe4mKgOkY7K/N9QVh+nozMykNparrhfr2UINPYSaKKvy9kq0Y3h9DFncrOTI4kH
 meNWrogk
 9kG9oxWfhHnINq6kV0HqaXxe4DUTNp//JN4SEWkySm4NwSqllnS/72ZedxTx/xR+GGF9/p20jEBOZd45SeJJl7Yfwq3Dku6smkg/CFrGqlVv5rrq2++YT9au3ievyPIm3TdaBO09dV6rn7JS0Xf9TDienZPWeiXQEA41WRzG3bJoezZJKMVRTDJpmGcIJVlE2J7D4G9Ppf4ukjkuWvIMELYyYmzkRFq8AUqwKu8w0GnZl29k9Cfd81JJzAOfbnGlwT9B90AlHURpzuoe7qqEpq/zdrLubua+FcNaC8RFDv5gpczk4tvAnemNBzMcky/SpxiyVq8PQYMqEpXnC8xcVCohfftlL1G3TRBr6JUhBbl6BsT/OtoXKvMox/+tCdFRCwB6yBghEVFaJ1QYiSn5feqyeSrPy+UOJykkVmIBShXRYsEGTab1m3DNmnSknZrUuynIL22Y+h1lqaGpaRwG9FiPqQIGglcGdgmyVGDwik/QWj1OHbvCi9y64BMyVKjuMsY/kygOY9HnBgcjdXUIFNY63dTLUGLfHWFmxY1KrD3y63cjMJJnqfaHaCWD816Tr8mhz7N+9MCPiUq8vFgEowX50xd2utvFvDi5dM06/Rpa5mLCyT/M/hJSCUhmp4X69qjBZ9QEpyZUG2QGD85DywaGF86yUEryVCTVOKuM/UHk1FidJgRK5CMiDnTNWGQ910YxGBiq8/pPYgSDcEIBBnD7bfAWR2UJWv2YlMJZIYFWQ3E1zmcYK7jQarvbWbuQTY+Vkll8oSKJBnvMEMvT2c10DTcfKcYbdeGJ5032B1bo6fdAHET/GpqnTaxqlelZJSngVYLgUJKIAgw9cznvDI8YDY8k6XjW7loGJtf2/hPKZGpmIsVb6xXQfxHuGcAttVuWDeGXAPSVVf4Xpcg/1pmTAjIXi2xhUYybJ/xbFppvdY82+YQEfUt3w9hGyAtFGbcaRbsT3GRgRtHAISCYEHUZFoEYh
 /6Yyfv+8
 tMIXUtMwHSoi2G9LH0ql4LbF2XzEFa76hoSE1pnE7th24vvadYJdo0R03SvAmkJsnnKYSfF7noz8BoLzVFPTp4YQKkv9AwfKo1WE2PawyL1s5nonh3EKXh6xH/u8qQD2txPMyul5LWIbNwagAlU4dpL0kpmM0hYkaebeWdlBxuit9V46hGBz1TJ5ivUOc6GusdUO4px/rAC4pWwzXsnEtYNWGY1/hizi9qiME8BoFQfC30VXxzJl41W94HfOZFUwaTpn3arU9JmaiGYVmPTe5scVvEhAZinF6eAqnOvMugm5tRjKNHq/uwXtPdcAcTPw8iJdRSml5QrMwKi+mDDvyf5wTOUy79mFZ7GDNbFfijcv3Fjq02z0XHzdq9+eR+leaAzweL4pbwnWP4e4x+Ul/M1LKlssIDsRwrxwnL9mOl+6oxHdSwP4/xD4wNMN0DLeASCqFFBF9T5vFciy12OeP3k6hdxE7GoYdIo6qVb2r0rCH1nkEDiwYluqT/K9XPb3T9CxxmFeBGDEmn8xMfoIv2520p/uaI733G/uRF/V8cg5ALo4zV75Z2jmzGMsxZTY0htpmY2qcWGQTXqbTEaJXcHfjD43lnQYRFPjpsqrx+ReWYXro21/qCcvTECuwXoiA4EZOoXjapmTgGWIZLfriqf2q1njUPqUaAYw4/6eGWXa4/gOpT37eoh4ea8X9WBfRQZ0Cx0HKtxsqSFXSQUYBqQFydI2dwHbhe7o+Z8HAwnYWff5ug/bwMsV4l/nk0cmRmKpoJ8voa+Q24Lfvxayv98ifgb4HrZAIocBex6cuiFzSW14G4v9zASYFlLxhOB1qz1soCwb2VFGH8s19l9/AmeRcTuS4jHDZ1G1ZS5LroX+7bqJ9RfAbn54GGPX7+XLBB4eHsX8wP/cptSv0I5MTHBrJXNo0BaZlSD6tBsBTH33b8bW2jq6xAXQLEtXC2Ap09AbilTVsFcjnK5mdYS7PcswBL1u7
 Yzl0xx/j
 kIIcz5w3Am+JBkVB4fYMH9jISRNlbzmcyGjJ0sUNBvm4WKVx0puNsaTxFFfKUxpXkXqJq/9uOmgdgMcrl8+oCK+bHebiCp5LvDMDWjgA6TS/VuztaHRatSKUeGYrEkQfGgQZ0EQQBPuA2N0SHoCt3QhwKHL/kDOV6c9wgDI+qIpULsfDoivMO4jhRHZGJrLhDANn9iQWQKAQaJWr1Flz4qKYcspGrpqQASankUd4UjWdkK/southr1UcFaWprfat4NCj4thhXLPP5rq4CbvJlAi4b4sQJmNZhRJgfsgmayx9uetKbOBH4NsoPi2bkIqGYlQtU9YWHbucWO54DpvSMd/6Vf/bblj+HBfIXBIeCZaANDqqNfWZCiiaQ7czjSjFqIylVNaWKzsant5b78FQdkd94f5tCLqOczszZgZRRVWFf/mXPSUAYU2FjoHlZD4mN7FOwuR9V7eH9F6ZTurCRJ3Xzpp+jvXWCABcocbv8RcqQQlbqiVkDV4NrVY9MNTOtHzjZUoLMae4a5oiIBcVvwZnggah/DzqYpref80ZrE4wo738GfAkpO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 017fa3e89187848fd056af757769c9e66ac3e93d ]

This simplifies the min_t() and max_t() macros by no longer making them
work in the context of a C constant expression.

That means that you can no longer use them for static initializers or
for array sizes in type definitions, but there were only a couple of
such uses, and all of them were converted (famous last words) to use
MIN_T/MAX_T instead.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index a7ef65f78933..9c2848abc804 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -45,17 +45,20 @@
 
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
-#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-	typeof(x) unique_x = (x);			\
-	typeof(y) unique_y = (y);			\
+#define __cmp_once_unique(op, type, x, y, ux, uy) \
+	({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
+
+#define __cmp_once(op, type, x, y) \
+	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
+
+#define __careful_cmp_once(op, x, y) ({			\
 	static_assert(__types_ok(x, y),			\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp(op, unique_x, unique_y); })
+	__cmp_once(op, __auto_type, x, y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y),				\
-		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
+		__cmp(op, x, y), __careful_cmp_once(op, x, y))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -158,7 +161,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -166,7 +169,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
 
 /*
  * Do not check the array parameter using __must_be_array().
-- 
2.47.3


