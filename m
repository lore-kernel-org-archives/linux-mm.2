Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23049CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F04B8E00F6; Fri, 19 Sep 2025 06:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C80C8E006B; Fri, 19 Sep 2025 06:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF458E00F6; Fri, 19 Sep 2025 06:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8B78E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:23:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B3648598FC
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:23:26 +0000 (UTC)
X-FDA: 83905612812.27.E04CBA7
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5CF01180010
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:23:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="Ms+xx/Rk";
	spf=pass (imf24.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbgnO9UxPmlnTs9ErmugBQ9uOmZYt7P0wc2omnh3GaU=;
	b=xA5IAvxGVN7iQYsWeA+wrMFg8FQbDYxkg/jtDyWNTxQTlfSCP6RlqVFc/B8TV10oMWz88z
	Z0kya8PVjmnGT5lPYszzT5jV7UqOTHl7qIU9LrZbnmFkTK9dYcn60QrBDktRZUbJk0OquL
	pqS9pQkR3aRuwqX3bikYrd4kQFzH3AE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277404; a=rsa-sha256;
	cv=none;
	b=SSWRtwbXqnqI+XQCpKS6ccXU5EbHdu/3MyZ5PO6k5FKSY5TG0KoVaw3syMJtgNM3cbjPMk
	ieqhi5MJK5eaj77q7QvvbDJn6yrdJsaqVAMDAZt9fh17DBKuqEKn+mOC8tOvsXWZhGGWbr
	bzHbDot02+nuw8MlEqF0/CSp5vAGmVo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="Ms+xx/Rk";
	spf=pass (imf24.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277404; x=1789813404;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QbgnO9UxPmlnTs9ErmugBQ9uOmZYt7P0wc2omnh3GaU=;
  b=Ms+xx/RkWW23fxBJ07hLojbtuUE4Ul9AVx8/rLdIf4dq9Cimck+Y2Da7
   U0VI83rDqs++WpezwDvE1IAqPdjB5M9F0lHmlIG42OUJ0mMdWlnNXlwph
   bpAV2Qi9IpJdz/4jAiMnCtGo/euALMPd8nmdlcws2pXLeVTyMJQeA13z+
   ySPkAxT3u2wU8BqTsX+Qm2YVRFsUbZjtTUvBalMSABurPdjjsYwpNAyMI
   4efRF7NNc19nDt/XcHrEZ/L0lFVOKlv9aMKC/PW1CBG0k6xhqkuwHtRE5
   /0Cg2eFb0efGAXguwYg+u6N+luqhGv4u9vvc9+AETbDpSkR5Yp/kYehzj
   g==;
X-CSE-ConnectionGUID: 8eNxhgSBQ0aEIqQqizJ05g==
X-CSE-MsgGUID: WTo/vGSJQViEaSGS1QXUvQ==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2369257"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:23:22 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:28320]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.30.197:2525] with esmtp (Farcaster)
 id 3e53f096-c315-4cd2-9a98-27302b532990; Fri, 19 Sep 2025 10:23:22 +0000 (UTC)
X-Farcaster-Flow-ID: 3e53f096-c315-4cd2-9a98-27302b532990
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:23:22 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:22:53 +0000
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
CC: <jonnyc@amazon.com>, Christoph Hellwig <hch@infradead.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
Subject: [PATCH 09/27 5.10.y] minmax: fix indentation of __cmp_once() and __clamp_once()
Date: Fri, 19 Sep 2025 10:17:09 +0000
Message-ID: <20250919101727.16152-10-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D032UWA003.ant.amazon.com (10.13.139.37) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: 75p1s1qe9wp5husujyrqeibwbif8n5tg
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CF01180010
X-Rspamd-Server: rspam10
X-HE-Tag: 1758277404-742332
X-HE-Meta: U2FsdGVkX1+EU0YQS9T8AfLuKdZVyt0lOvMCjnmHq92OursggHep4gE4SVK8/uIP0uCARP7m8zINKSRtBVFxhZR5DLEpdfu2EhA64BZbSHT3ConJ+QNWRQ7CjUUdk+qAzJAwJzJMV/KXrl47wyFxopRSTGGCM//x+WlZGx0rJiRLeZZoGYiuHLouosXZ58+IhnJTpgp1azhwFYRN8rClOGKrxJVMfxvhswZ4TNpl2a1L5JbfGF4+okrMl8WhbwLMEgBoQTA94Iy8YMFA1Wba9gdRyAhPWtzxM0wJuqIv6olVYP00TBSUn0KWuGGkmtH5/i9KWrgZ8C8RRzyJWt87R/zAMFVkxOFLWzWLkxv6FfTN+qAgdLartS1qII3A6gFpYxuKlOOF1LK4w+zGiKeK9B0mw0evBDgvEirI42+FilfrnhJg9od9AvX/+/0CTAzl8zndECxd7FE71bw6IPOij/D/UzV1LgODcZ1dSN8/6rivvBlL0iJpheOwVXVH0GjiCfAEJJ0tLdIoUZbEtindAjtYNE/9ggD6hQdX9GmI/xCDTcv6yka0X1mUzwK87fr5WKzFH0vxbNFMTYZPDR1zke/nsxtqTojoEIJ+NcmPFhcCYJdw3Bmr3yt09rTmjPBpgLQca5IFotOm/lNJoEfG6/2BNTJFuWa2OTABGOEDkPnNjbL0sIquO9sZhSSo1ArYLL2Kp7kVex5RCOow7Wb4x9pj8PwS0ZPJqf+bRy3WVNS1hK5moZ3tByIw9PAujgKtkVgRW1AvDOe3HFlZH/kd2Wm5TRUOWwujgBcuSRvcuA0T/ZZa21qfws4yjJ8c/uxvW7UlECTptR/uiwIs+vr6yWdwl9sYllRmyZCywgQ5cbwhElOsKfdNizr3GbrYKwgTacCo9kklV6tCVOVNADIQvEMlegI4Q6Ki5TwUA8/SRJh+7my4xM99V0qn9Ei9b3OGDcHivVfdqKcKJHaDEKR
 e8mOQWYl
 YzguNvqCplco3o0D9BCTq5Er0wcvPKlRx/5hEGNT9LiR2LbqSa3489kZLg4P8ZSD36rAIfS5YxR3gdFXryGLlcbR+sD8CEfuWOxiFQrNd8ux3kWzreVgghAiEUSch8nIv5HIZ6PYAW9F+GM09448smCtYSwe9P2/5TMhU3AQVC3Z8ie8zl+yXNAOuoEVR8p3OVzyDuPTAqUeF4KDie2TUw9cZE/S92kWj+THptL/PG7CuMxMPnXUprQW8fRW+RaNxY3x5zkVLrfp7Up+JC6xgrbNp1gA86qUbZ52/G+uwNtKA0K3y6fwLGBOXR51FLFrG+h2Eg2R6Mka0mEOlMa7gUJNB/tyBuBvi5oyYk4FQzTlCIFY3d4NQWvONM4GaixBRIRUeacHwCh9teOLUnKnWFdKnOP7FHkO2Ms5Y+dJPWOsfFOS5HvUZ8AwRVHDH2MBxKULOQWc0aTC8KA4wsuAd/UvQjcS6MzpeKGmfB1Rq0NpdzlsgWL+s7eqTt7nFNxtjEmlRU68m/NNemcpyqFeWMtADzrOynX3DzV+gQBwQJvYAqL4Iqam5nyU6gLVVYxUlHOBws0+AW6k8uktkAk0kvMksqMp3yiiIXItAc0z6jV4uJLa3SfU5C5m3JGVM/bT1Ucsenqgc/x2PtxvPHR6jhRuObQiOIR0xy3COgzdFF/4iV7NhPxr0X4xYKp1qaxI4iB44CrTKxErv9A0RQl54NWVkVjm3VY+hYbvu8aWZPz3D7zwurSaWf7UEgMf47L2si2ZaweBSPe8z3CRrv5hbI6R5SISCori4fWtSSZMJhRWeQi1zO8ID5hB2B47XbsqZPry+HNOP/1M3HcUubayynaj6+0xy7c13ui3v71Iup5NG1Pb+vpkqaCfp/w7EfE7zoE33N2B4PvmrU+DMmo6N9f0TNkO/RU8PTP1UzI6U+//zuI8/uNS133GZCB86E+j5UjsHceAgL7y/FNR5ky4sq2q6CFWr
 VRYZrjtr
 yh9IJZSHCw9OaqPgReOlRPQU8Y7JtM4rWD+5OatSxtH8e/qU4FFb6E1YE2ezPFxMW9EYPqIbDu7FOZNGKgYQEZi5cRdgc8DpujX6EhL1VOKXTkCF/2CUnQ2hPcHg8ES62KgRfyQ9WLErUqNcl0Gibn981mCDLD6LVxVLkLPn9fhWfLXeNXoIqyc6WphgMGo2qb5doqyBf8+RoRZEzKVYat5hFgn4QVyE1rz7a4lhx1xdb0wIMRvGM7P35KUg1Dqg57MhPRIabm5+1q1cNHKb15cH9xLlVlMQjuM7h2WdeAgYY4qdrqDUBboE44eA5XzklWX/hHhCWM6sTf7QojYdIiU/SuIXy16FxEdcGmMOQqVhgxx5Oe7wqs0T9Cvch4emAVjV+DdIPcL5hwLbLiZb8+6e/QArdvcBVIxfFVlU0v5XSirmugyov9cuBGV+pTdz1NGmDYRRorm0RremMXKVM0fhMddbdawqyH72aAoX2bpr6+1aJo7kTDt9UGbBU9oyzRL/NeLRjfQBS0WTDK/wv+axn6ZVHZR0raXIcbJl5PE0xJ2ArVGINPt9c+UUjaj2rvIa7T7VBdVLcrU77sJ0MmEFHHlF7gi2EaVP0PQod1Gl/tFF4UjxAOr5740Iap2GgOq8byg/c7BKdQUKlNGPCZY/xieux4heGT9IaSkz7ZB5jatI8hPxLbMYuKI5tYTepIemoZN3nDEBGSJVWstnIpgxg3t53rlRkXSLrWTVJDcftZjURcsX3djLBjPYy34r+NHoUcnHuZkn6O9DGPhjXTF8b842jp34o86RIcaIG+viqRg4UrwkeHQifaRhti/E+/hcdnpMyqwIGCJ+mD7X41xnYXge6A6/I0t/BQtxZSf3AGn375y3RK/LC29rUuSnl/iy/hfp7FHBXbqIer4ieiY4wlKH0MknrPRcMDSFsfJD1Cq4E9btVqHHAvsPfz9W3RRTAbehUg3Pa0mZz06yEcsOhiex2
 u+VZYNOo
 aTk1Whbt4K1K04H+MiJA+2y9HuO3Ym0huqoyHUrv+g0IUROuwMIfQJ7ciuXI20GHLsGUBltBGf5aKY8oUu5yEG6OYVWNZmcNFFoETR1VNKJkdhnVNnWFrk3ABqqpNzAFVml5FpkuZBFZxg32eRhhmIfzqRBDIDKPP/88RtyVIZugKWOyMaeWnb6XJuPNT+L4mSZ61fiZLJc73C6tjjkEcM7h5etuLBfGKxpwZDOlllpaEpFTM8WEJCCQTF6kA8fc/agHQK12ITEo5XcJiTv0dFKENL+UCfXYcpIfvs7ABENyrHs6rH3y//kuSg/FeAii17NSh4uKtfFq/U1yCI7vdtRyBgcvMEwl1MFlGHaBQH3nYFm9YpunvJw7MmQCxeE6opuy/BJxcekQ5Yaa742A+fF497CFzBJ2sPx1dykRF9h7R4UN4yLjycNGXqzsK81TPxpQIhcXeWQtCQ2cay4Tyyckd5Vh0w0453fK749a58NLuf6RuOIIIcHnpOEpTvGE3pFnPmyPkhgVnyjVMC8fn4wVRGGCZ21ku8CiD9sIphPM3nnloPLXr27+xsWoBJgE1uoEhrJzW+eARJeSXLPRNkU8/VKvgh5IKo8DfqwKnUg7gx46UXl4tG4UXKwMxKX03c9FoVbP8MzLyNxKdNnb9RhkjAXlWqsdpQHQ6qb55jTC7ch34kS2kt66Eh0A5i8qT5EB88ggyTIOFhjRSztRBa14zbTBG3stpWbmWMveUPKgMkZEN0wdrlUFdxAw61uv/Zb19buURjc8zAw724msNh0EiP8LWU8M7BXxy4GzbI4kDZgcz0riuWnqIokxABAw966KwX+93EraI5jRpumNNj3Qt7RJw/RnGIK4X8iG3ls3JCA0cuRJdN7ljqCA09VcdIfDVuM5HUdIaEGJWIqsieFNMu55mfXXThcEkPUXh2StDLeMGaggkaKBBJDb1feVGlMA2V1RtY8rvub8lW8C4CpqdB8sN
 o4cy8ggu
 emAOCjf8UnZzTBkZeqs8Itxrm6VpvpPA4+E3faMDevhXaJBXN8H6TOnW8bDlr9fI6NWD0zOCFlzriy67QkOw+xcTRLYsbHLAvVEF2qmKRrgi+9UXYKhNyay71w1/M4+pWfmgq6WSXrHt+0IAqYEz2knAuzPK16m+imfmFjvXNnS6Q+uJNeoo7LmFuY7JWVnxl6/aXT8YZglE0wiG3YIkbwc1nXaVihw92SdlTgmm0R34ldf63FF5xepzvgLukg4PXlTIZb6StuhzLW64l4XNd2iqBisnxS3WwhlnsMGcLmPjrmXS053hHARLM2Uwsk1fPlq8PbkV43iE8gHpbMOTtfKggwX0LXFxxFQ08WN3GJVyCtAJys1gjzJgum6lnbvmRQvRZ3GD56MGQ656t9tq8L+ZXY6A4oJjPNfxSdQqG0gfHZAoDiNj87LQpYfLL20TtH1y2vAtqghpmg9R1hJ2OCjUu+63uS4nWlyLVBdeto55cle2CW4eu6nFNG2lutrFkWi14ipDfG7h7xurgtDDS3fEDBESYumCC2qy4nAqyDqvv6iMAKoXcBrN2MwPo6o6rPeumWM5NpzEsBmMrtAR39jT+U3nD5hp2PgMlPtGXDYy6bkWrX0Tz5Fn08llf30+FToyC+BhyalfY9pnxmerX2cbLm0tmO75JaaknHQle3op5NBex1J3KJdKLwBq3H0H2DV8k6jtVGa4HIzivoI9DAeIz3XGYcojFWlICGwUa/AEaic7BxbeIXdnfJmfMAN5GBwOMT7b5+WTfL9h6paKwpECCCvhU80z0SLXCB+APzE4sOp7588aF/9aRsQtmeFtQo7Ua5aaG0/8VOuj2dxnDzr1tkh++/ADfcEsHhYvX/eQ8IWwlfER5RonWYEedtvC3e0FkWC+FwAByYb4528FE1itJWow7KSrsNDM/Zq+CPiKf0cuV1Dvwe42XZeW7AiIWq+4hkcc85IW7jAwhU/5NGLTYkz3v
 Sk0tYk67
 CgbTXvSVVd8YJ0/AUWN/5/wePfo0CUunibbSu6rz8KxR6jnh47tAyuGWJYv90EL9TVuwvgXoiafOpFeXsj7VCIQHMtaK1PwFiRtVq4MWQG1NuB+OpUXk58x1XlP5wAlDRKczrRXdd+bhJrNvrGjVGKnp1lig97JwKYSSbhcWzwCgY3FMKT3n4egOx8TPzRcrkBB0bkQhdrfq2TZo+mglIqTGWgL93FSgmCkAjup067uTdEnqTzRFaJq6oGsgGnFkA4dlvLgwLrq5DF2OCjWOqOpNbx+r9GHbNgxt4CLb2oq0DJkdSJ9pKw/uVGrKMO/iX/k7lgP7ZwqQl3DeQo6MvSEDxWDc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit f4b84b2ff851f01d0fac619eadef47eb41648534 ]

Remove the extra indentation and align continuation markers.

Link: https://lkml.kernel.org/r/bed41317a05c498ea0209eafbcab45a5@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 8718fd71a793..c0e738eacefa 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -35,11 +35,11 @@
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
 #define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-		typeof(x) unique_x = (x);		\
-		typeof(y) unique_y = (y);		\
-		static_assert(__types_ok(x, y),		\
-			#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-		__cmp(op, unique_x, unique_y); })
+	typeof(x) unique_x = (x);			\
+	typeof(y) unique_y = (y);			\
+	static_assert(__types_ok(x, y),			\
+		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	__cmp(op, unique_x, unique_y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
@@ -49,16 +49,16 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
-		typeof(val) unique_val = (val);				\
-		typeof(lo) unique_lo = (lo);				\
-		typeof(hi) unique_hi = (hi);				\
-		static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-				(lo) <= (hi), true),					\
-			"clamp() low limit " #lo " greater than high limit " #hi);	\
-		static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
-		static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
-		__clamp(unique_val, unique_lo, unique_hi); })
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
+	typeof(val) unique_val = (val);						\
+	typeof(lo) unique_lo = (lo);						\
+	typeof(hi) unique_hi = (hi);						\
+	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
+			(lo) <= (hi), true),					\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
+	static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
+	__clamp(unique_val, unique_lo, unique_hi); })
 
 #define __careful_clamp(val, lo, hi) ({					\
 	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
-- 
2.47.3


