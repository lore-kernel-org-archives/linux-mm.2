Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 078CDCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 617CA8E00C3; Fri, 19 Sep 2025 06:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF4D8E006B; Fri, 19 Sep 2025 06:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 505568E00C3; Fri, 19 Sep 2025 06:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6CE8E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:21:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BFE7140617
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:21:50 +0000 (UTC)
X-FDA: 83905608780.06.6A12A47
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf16.hostedemail.com (Postfix) with ESMTP id C1A6C180006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:21:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="eW7/PxSu";
	spf=pass (imf16.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Axggb3gQ9gMod1E1Yl366ABHVZrqad4JWTadzq2JQtY=;
	b=HVBrXjvaWMUwTcgYoAjfP7oT6ygcFkpwTKnRto3FJaW5g6Zgn3gmj5Q7iykIImBM4UcCgZ
	Ffw9Iv0vVqsxKPX5HR+/cTIqbd8AszusERTxP8m4BBitF0HbOiebNSik4noUvMMXQvXvMe
	QCBYntjFAUKK84JC/yMQY5x+LN6UbeU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277307; a=rsa-sha256;
	cv=none;
	b=YL6edpO4sZPyQ26TLnAMibKMu+D0AY9azDByrTyemSNYsCuhxwyE4rpCbe9LI5sZbwIOrw
	bdMg9sRGkIgfFKpMFh0ff1vlWitRNKlO8AJsiKEuKeC+witMejBRcwq+NVslQhxUJxu8Ta
	KGe7nZj1zGXBffZ4zOHEm7f25o2KwCQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="eW7/PxSu";
	spf=pass (imf16.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277306; x=1789813306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Axggb3gQ9gMod1E1Yl366ABHVZrqad4JWTadzq2JQtY=;
  b=eW7/PxSuXl2CguKZ0Rc6wl4NJkhiVn2nMDsUFLeMvCYcNg8XBh8B338r
   ilYoW57PzukvkNNrvlwpfd7xGNn3f3iVFsmXGevwutmBadusi7yVmiBRg
   KgQIbgYdyu+5U4rD46v/TSScCYd86b27VbJh8KoBAGv4i56iC6LfRtqr2
   mUxVTDgvFjH/bQTeYLET+5cMi8UJYsxZql4aAPe3t3gb8rgflY47jlNQe
   My1I/Eted4LMcPvqERQmCgwiCuT/FYlLfjXH2DFNfYBGkO5TpNFHPFlVc
   /EboyCFxbczy29/OjSFYXDszmfmhWyr5PPeINjU+LJYDKLeAAYR1U3cyh
   w==;
X-CSE-ConnectionGUID: eq5km8qNTamO0G4jMeuypQ==
X-CSE-MsgGUID: 2U2vmzfkRPCWRtsb3mxBQg==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2369102"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:21:45 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:25141]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.30.197:2525] with esmtp (Farcaster)
 id e6359455-149c-40a9-a134-a9e311e8f3d9; Fri, 19 Sep 2025 10:21:45 +0000 (UTC)
X-Farcaster-Flow-ID: e6359455-149c-40a9-a134-a9e311e8f3d9
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:21:43 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:21:14 +0000
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
CC: <jonnyc@amazon.com>
Subject: [PATCH 06/27 5.10.y] minmax: deduplicate __unconst_integer_typeof()
Date: Fri, 19 Sep 2025 10:17:06 +0000
Message-ID: <20250919101727.16152-7-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: C1A6C180006
X-Stat-Signature: pswjek6ji1a4zoacri9sw3asyd7joxq7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758277306-722163
X-HE-Meta: U2FsdGVkX19PchUYYCoRZr36ckYk6lw78i3KzYbqA3pXWSi+VC4JJoEdoIfxEc4iRIEa6Fqj+ldfKhNki+VRxL4pWj+g0QJ5DBCvzPQYSbbvT95JZM1yzJpmK/p5eLte+nQPdXNXkIKbctw5uX0zL75h6YLB8xQSqAUXHip7YBpHSleSDxhVj63dGxAyUisCkeBn0g7YWu9gmTl/N0wM097EWlOYUNZicEq8+Q8F0I2MeMAzo3G5bZd2ucAmZQ88UmzKrF58DKjXPZWZ+QK1pLOmE7pg3g30yQbA9MBmf23U8BpucgSbDWcCmkZ2W1nBrY/RniVqPpNMqr7IejhTqf6HDNu/O25nzxRAy0phpKPys3/855ONJs8ZxK3A+N/elqvqdNrqKibyY7feRp2BFJWpDsE3/aIwSJYOA2fU3YiNNEuzcC25S9PBI1r0XAKn8rzrj86V5xddemu0CnXLVbPkxi6X779Axid+i4RDLWrr5+8+C5vtCkp+6YFjrzC07miA0B2P9eQM85Qh9dytAIEyGDRleLPo+JDv3TiaFxpfEJ5T5EOfIpcSbGqAAyKgEXpSHWgCcjXmqlttoOECtK6Z/+wY1ZLFB4DfaaMlx+lddIKBP1tlZDTyH9YOAeCT4uKAsMrS3wNloyTyJf+IcWTTmkfZSzslBx6w+8b3/4JJZFeTt0rJbaS/USPe7HU3F4lBMfoP5jUOn/Xb8SzQsv2loP3rsIBZWF5Mhuq+ch4gWWxunGEdhBBj+5wsculvQaJFWHiQjj2Rb6Hc1oZfkIFxf7UKbWrcXZLTR9PQhftncHHW0ucl0qyLioqsx4HqqvDb2aa102CvPFVLPzPZ9tTKRibTSGGpHZv35ERG3Q+qQkU11d49yzzeYKPub7FsnPdsxvyBTm+fjcibXfhreZO1gbPi5wKf2LN//Kk4DEkr+RYLhLGar8UZP9/WpjNhUUXrZH0JY8WiGuZblmn
 fIlFtMeS
 x2dgYgTNuhStLJLcb/25FQO5j56BhGNk4HyBxjaPG7rVZN9uNewKfY0vtTITUd+/DzePDUiV/AhHGvd5fqtvutyBZw1RqlwXZT5d4v6o6+AM3rjKNh+JHUno5qNCqivGDfHRXVnu22EfCSyPnQ+Uyi09M8KvOBAfTpU0PHCFFdCWnm9XlIaFKAVzix84pTAwqMCJjVrQUsTIOmNteXPkXSgVjidCEdCtwY377d2RKb3DcYxLB3a+kuMs74CxnJmaYwSkwOCgq+zur2Nzd3n9opPIUvEXrRxcTFy8wQ/45LX6vhkTgx5C8uk4MQebQoPyLaAzrf2oCuJtHRgJTs4gjk6aJPJUWm/wBu5IKMaTYdOvFszsyxwz4EpyOPOUoTtW7ValmvIgghTri6U7VLWbtuP4W15B3IImCADY7HVonwOqGfb+uYizYxfPwJ8etxXCZSWQ0/MY45VhXIQ4Lde4XTq7dU9Il5ffX5hwHhvHyGPDddNfqj1nRkeZmt4eqNpiC2OcORHa0p5bwd98/yP+zbYRsAYZGnxmJW/3eDI2GDuD4myrIpq9EWQ04YpGbTsCHv7wUn6HTYcbMJTRDTARlMzBbQrPnsIPtHBNwSEVMnsk5Urspoa8R5h4vqCRO8ImdvtwgJau31Jgxk0tAf4BKz/nVqPf9FGbcOiQ7579LY10t8pBclKoJrVUG2R3nQrIv/GY8y/uddGWThzTglO6QisDaxZGct3LSvopE/usVhYq7MLk0sPWGrxJyfJaGg2oc2XsWwkcvy3Cfq5ayNCfXGRNQLiBUevGejLqmVvZDt8jQ12ktavvmNwvY8X6OjkDlrwnVN5urom68lWlLMv8zKOahMDtT54uC7kUctYCi/JaxdIvdl4eJgDRMqTLtmQhAxCD6LVnvJG2hNCXaPow7ZoQnL0Rppp1qilFBHPSxxYDZ2t48fHoVADK37PN5EpiaY+PoDbSQJ1IUw4ByActYZQ7vKlXG
 C264MjAw
 IxnxZDzg818xTrTlEjW2+nqkCAaPNugkGIw0QG8NWRP7WdbnD4pu+EwScxgslvVGJ4ugg5gMB5gCdO0w7PY+y54G41pVKaQSeSBMWtfjJuFtwEHjvR5/wyQ9G+JeFhqeVPYu8ZtDxQUw1NFD/ijHcieWKtRgg5iGxzhejeHCS+epEoRAjpLBL7G4npYe1hp/t3amzf3TUjiC3aIBP8FUbMQyJ50OHh6Tk7MVajbdTyQPGxFFgDkjHOOeTTsSZUkbNBzhkaknYkTIJ9BWdjndxsACt6GtEc0ldCqOYq63RZlSQ6XxWKSH9Vd1HBspEydfa8siFeiap3pWLrRJ7HWQc4cLUbPYXNohVemUll1ZjZzy3o7mACrl56h56qrFjMR1YNP16vz/RgSbMKcakFRin8LqhnjC2WGkAZt1RBCXedSLxtszoffS5oMbJ5x9hZXLda+FRNqAAPYIsqZSnZrplRLi/wpKaPp+DqtpYrYtiwKZjBnrSInyVQS6FfcA9DBE8idacyVX2c8U2ifefD0LbgOBfB54IxXykAVfX2Y+Z/2RKnElw3CtbGQr0YP2uZPY+XWOQVghaSSA/MK+7b0PEy3KfQrrQ+TJVjCT670g/CCk4pBaLYtfzINmo5gcSNKMKMioSvApuDiGYxuDp9eqUmTXN6+gJhvudY8ef0nYdczSUaZ2LDK12JjUsGk7XLbRibJacPWUD/Uxsim4TJ0U5tnZ4xny/g8gUfpZyQyQ6SwvliNtjsogDQDuJZXREk4TQcu9/gyRP1Y1GOUuKwLq9/Vv9uULrCME7PNF+Yx/DRV7shE2IWpM9ZyTf5f/xLs+fZ0+31FsHnyf1qimSMDIuJLWTg0Z41P0sxkI9PBI7R+DE4x4+OuquyqU5xKqGlNQRRf9K/Rb4kMn1DsAYtmW1dNjQdCQIEGZjoA/bMTAKyDeGKWPy7OG4UzU23AJvh+tJ4q8nRTAoyM4o+PaKv93vGzuFYRPX
 1fwf9wRJ
 6noWGEN40nueCcFNBNGqODZLsbCrFGyObilvefbZJavwDrxO2qSJ9TFi7RcagrocMXyXLi6lV5u8kfL3IJ1l0uviCgTY0vlPF1S5xR0qBO5u05cSu+DUiuogCFPVYr26kxfzh3QrIWXjtuH0weLZhbX4JdzXLcv+DKNJxYKFZ+B/HudZfAlsBwWE5MlkTpX16bAmgW3j/AqxbwrD+La4ydSB6DOuHD/Jm8c8whecAvt1oUAhKIDF0k3eLw3VdsbU08qt6nHGkLsWLdNMu/bfYMcwHm+ixk09/MqNDNSsdIcQCCWNcB+ambJ86YIoeQnMbuqw0LGmZrRtcQivcHOhSDYSIRdEPiluBFRVIh4813jQPkfSA+p/AyhfSYJNZKxRSiziJMbK1PW8hLUPvxATdoLLO32REI1GyHn6ZoEANGon5M5TYu3O9+QBIoxmRL4KDwEvybkrcML0TqXwHyP47VLwKzkVbLA7QTgEfZNE062Jf9oe8X5Yb8Vwh9U+rzFuNMync0Sgugv+MbAMmS7BrmQk1GOFyHiOlOLQkV9bpJeth2102Ld+MRDYnBg+W6asov+ipPxRNppPhMQdOomwHBNIAsGSN00hMVR8GyH0zmuA5+rBB7psfFkGF+wpL1gCU4uFHKfvQIq6BqCf6tF8wQJDhalBk9Mva9y8kjSyEwZkHi2X612SRX6AUH5A5tlb7QnzdsP3n/Ri14RYebBjO25qjgfvqK2upKb9PGm2DlMBmkMbfyOBhklsxBkO+nSQuCOzIP0uCa8V9jPsuAnpWo2SVGZpSzoOFM5eGGSQ1F7LZL00OMopcL4V+wpDO6qlGuZQud5Xqf+3As7lLCJP/ZzxJYzcznqIQOXHp7+Xn/PbQvRWQDvKnL+CSd9dCphvXy0w62SVz72NWjYH5hXV3qWsWdtvsJhy2/f3r7bkhq25Ff3eBGt580BZ9H7R6anLyQXO8efBH8EG4JdyDzq57WKlT335q
 0583JtiD
 RYJRvtXk1snW607+b+PCKBpSjqzQDpNlMpe+SI6uM12rSVp2Ol6ph5hIWpHFR3JsyUNTHOLiTYkI5Oq+ruuTjzf50TObtlhA8r3paHTBo2z3N9aXjg7WT0+SmtJziO26B8Jy18oiyxBG3ofKHwngRIb/B11G+Ho9fuIKLRYr6JP9lQie9QFpEY/+bK+wLfgPB09F9ltlP6A4S8pQ31VgqH0NmCVV3vbWquEsGlnt/JDGmQvs9uncYD9INoRRb+YWdMCC5gyWe3KMNvo6Kbh1LvAm6m+oKsJ2w8VtI+fvCdc+4I5jfK+9O/i2wzesY94hpAl1wxyCNVOyumRPqj/Zv0RWih99KC9vdrQHLRFN1JYgeGpyL4CMWDDiqaiaAzMnnGdQZTLF7p5ioAhaFyCiSjGZT399VuqKIFqTxx/ghtAovWexKcYEdejfbLQAz4AULm9VaBN317om9aMwftw7wUsCIs9e22x6JruA0tUae8h8VeiPI4K79QlhnObOlNQBxOboxbrgFrornZ+j308qR/s/VDW5KkEdK0epnfFtu3wX867u6Gw28cL0uBNdrQUfjW4+2+dTjnImQZC38F1tOnXdFoD/NmY/V5LU0AzvC45jueOot0Wjep3mNYe5Euc7YnayGxfBr5BKG4AUODeq4CAOi2TM6GtkHp/2Y55KJCsKsTK4ASU52pOBJ2zTnM1CkajWwOU7M2bWnogwlFBfbk5LqHEu7sQ2PgQXa8ZJDrwE9Gu9cf3VwehJAJkUwfXOnTdSBkEU5ydA7gGYeYfhLYXGvrcesjH6XGtc2r1KnTfj3Lxcgb0S3OmKHIC2yoU3VcYr/5RHcCTA8RH5NyfneL1xZMLhgXj9g8GgU+ZumHSQaX0r+IpcOBzdNI0EoydBd7rc+q1VHtaOltKxEyWPFkeBPymYSfJBWaSfKVtvl6Tza8Npr/eiOVF6XXHQTFLHQswa3DKoXOjYHoQq8uvnvaUChpdD/
 gZ3bIpHu
 7gcorNeW2qLhJwu9UWF+ozc+Ha6MnZVyO2ZUS4up9qk4h4OkwxDFIVr4zxpGjTzRGK1jWJ31D5SYO5r8YNTy8yMj3eA1U8KEuOswTEyLsMBU9pJ86gi73WITKin438369INrE/T8TEncWap3ZmG6h2GSZTa6rlvJ3TUtuC0eoII4Ev1C39zXXUl98RJBZdfbtFVUDNpiu8LfkudQiqTwyuAVS5dE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5e57418a2031cd5e1863efdf3d7447a16a368172 ]

It appears that compiler_types.h already have an implementation of the
__unconst_integer_typeof() called __unqual_scalar_typeof().  Use it
instead of the copy.

Link: https://lkml.kernel.org/r/20230911154913.4176033-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 0e89c78810f6..c813c1187510 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_MINMAX_H
 #define _LINUX_MINMAX_H
 
+#include <linux/compiler_types.h>
 #include <linux/const.h>
 #include <linux/types.h>
 
@@ -151,27 +152,6 @@
  */
 #define max_t(type, x, y)	__careful_cmp((type)(x), (type)(y), >)
 
-/*
- * Remove a const qualifier from integer types
- * _Generic(foo, type-name: association, ..., default: association) performs a
- * comparison against the foo type (not the qualified type).
- * Do not use the const keyword in the type-name as it will not match the
- * unqualified type of foo.
- */
-#define __unconst_integer_type_cases(type)	\
-	unsigned type:  (unsigned type)0,	\
-	signed type:    (signed type)0
-
-#define __unconst_integer_typeof(x) typeof(			\
-	_Generic((x),						\
-		char: (char)0,					\
-		__unconst_integer_type_cases(char),		\
-		__unconst_integer_type_cases(short),		\
-		__unconst_integer_type_cases(int),		\
-		__unconst_integer_type_cases(long),		\
-		__unconst_integer_type_cases(long long),	\
-		default: (x)))
-
 /*
  * Do not check the array parameter using __must_be_array().
  * In the following legit use-case where the "array" passed is a simple pointer,
@@ -186,13 +166,13 @@
  * 'int *buff' and 'int buff[N]' types.
  *
  * The array can be an array of const items.
- * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * typeof() keeps the const qualifier. Use __unqual_scalar_typeof() in order
  * to discard the const qualifier for the __element variable.
  */
 #define __minmax_array(op, array, len) ({				\
 	typeof(&(array)[0]) __array = (array);				\
 	typeof(len) __len = (len);					\
-	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	__unqual_scalar_typeof(__array[0]) __element = __array[--__len];\
 	while (__len--)							\
 		__element = op(__element, __array[__len]);		\
 	__element; })
-- 
2.47.3


