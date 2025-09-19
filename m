Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 498F6CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC218E0008; Fri, 19 Sep 2025 06:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96CFE8E006B; Fri, 19 Sep 2025 06:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8397C8E0008; Fri, 19 Sep 2025 06:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB468E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:19:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32F5387317
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:19:11 +0000 (UTC)
X-FDA: 83905602102.21.C82FFEA
Received: from iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com [34.198.218.121])
	by imf16.hostedemail.com (Postfix) with ESMTP id 10E24180006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:19:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=RsaX5cLU;
	spf=pass (imf16.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 34.198.218.121 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LF9YnUdrpKxMSkc+LEc4zqlPhsgbROXsY4bZTz/lajY=;
	b=LYwIdyYDJ6MnfgXnyiL5zTJzPvYteOJ0ct8CP6ZrTqL6fJzI6pSvIc5eV6eX4iS5SsoKcM
	43C9fnww/FRPSUzpJUPfPSmvyZr/Ju0dcbZdhBJ8dCD442NLpSq/T1rCPM7J3cEAy02FFZ
	FiLJN2XlONucaZ519hr/lz0NaEt5rcs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277149; a=rsa-sha256;
	cv=none;
	b=gKb60Bj0qknVRlH+Hisar1wGnBQ/EO9QHPtT+b1raAaCDHo/d24xaBSRfz7TiRxXsf9aS7
	NUNDQbuXQWvpTVjHP4CSHKhBbcM28TO/XtU2KqEqnAe3ZvcySeAMySDpebi4Q9E/E8yO91
	WSijwhIjZAq7/+Fdydo72rTJUaz5l9g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=RsaX5cLU;
	spf=pass (imf16.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 34.198.218.121 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277149; x=1789813149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LF9YnUdrpKxMSkc+LEc4zqlPhsgbROXsY4bZTz/lajY=;
  b=RsaX5cLUDTwGPwP+ANw9o1iaeUATb6Gmid5jmh+axhFonpGfCsdUtcvd
   CQwCZ36YB4+OadAtXNGd0qq0QOizmr84O3fw4ez3FIzmZ+JjLeBrU5BPJ
   WnIc920Vb72sTsXvmVRfRI+HNStuh/KxOcT+9UXS6/VImeou7Wr71R7+d
   G5F82Cwn6pJMsK7x64n/OWPXQm3pb+/HqUbLmvRzzkNTaqRjRhp4efOwJ
   U6lCLD2N+l1gtI6QBsPKpqj/WId03SgsuTf09aWZnD1bNCUI6w9huh+S4
   xzJtbs2tyKxV98J9yW/ROeVunYTR1GPIEaMNkijDD78ctamdfXPbASt2S
   w==;
X-CSE-ConnectionGUID: d8F3/hpITzychgfgp92K/g==
X-CSE-MsgGUID: gtoPPUcnThqG3sr38HrI3A==
X-IronPort-AV: E=Sophos;i="6.18,259,1751241600"; 
   d="scan'208";a="2429772"
Received: from ip-10-4-3-150.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.3.150])
  by internal-iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:19:06 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:27737]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.47.2:2525] with esmtp (Farcaster)
 id a18ce240-642a-45d1-80ce-41cfb51b85d9; Fri, 19 Sep 2025 10:19:03 +0000 (UTC)
X-Farcaster-Flow-ID: a18ce240-642a-45d1-80ce-41cfb51b85d9
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:19:01 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:18:32 +0000
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
Subject: [PATCH 02/27 5.10.y] minmax: sanity check constant bounds when clamping
Date: Fri, 19 Sep 2025 10:17:02 +0000
Message-ID: <20250919101727.16152-3-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D043UWC001.ant.amazon.com (10.13.139.202) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10E24180006
X-Stat-Signature: mii41s6zxfkr836czpreokwji4qunfcg
X-Rspam-User: 
X-HE-Tag: 1758277148-751428
X-HE-Meta: U2FsdGVkX19OFuhwT6PdmcjIcoOQaLwUqrKTT0C4pXttckCS5PSFmMus2gCLSsmrl6xzZfOU5ydbSXHWvQZR5L2alAzlxcb7KuH0DLlKbVFKQHQVHn3kJNgf2gSUAr7RRiqMRIJgrpDh6L7IDpZhlBDue4ZmTLWG7q/NT2UyvDI13J5BGVAYKWo/YPc1xZQ4WJwsGgoskybfNQKS5vpE8VqGJCmzCigqZRCnLMZxNCom13CmMOOH3p1OWIv1vBjN2H0n3qGrGdlNLZUH1mq9huSduvQQCygXmT5pLRGJSQB6JJSH02+MgerhBOcWpgoVDw73/9N6DOZY7II2m6U7+Fdr19pwLkUFOz2m4jqbJfdpiM/8guWTwrVgoIO5NYCBxBeyM5xCSDYnPIfI9/Qs+Tc9qp6ra2RiimoWQ0WPHbcAMVkv2XALAh1s96dVsFJtIvBVfpNHWAT0T8ueclyw7mmFYXlf+aeLcNxPOcAEzIOxezri0IHyo0Uf7gNSlS1VJRdsfnXBraWGrK2GoiYnSMe8FfLGqsPchii/w/bsdgCK6EpGyhTvneZuKzUl9j7M3yBWR6grRbNxEUxUnkpRocM+NMj1rWCMOJ+z8cDytTu2/r8y511N6UWxOwqs6xmec/WybyOHf5i6vS2Zvq4MiRebTLJYraV7aP5jp2XvTy9wXtWMMruJdoySH3HDVa/q2028Zk02b8UsGABNvZfxUIHwUwFmGQVBPQs7PxxYZCtdFYMZEjS6/f/r43Be2VDmFYqIYsgI7jmkswU1uKuA0SclvwbGVRi2O/1isexVTNQYHPVYgW4voRurhsm0BC31lmrW9vzxjl1tt7dgf5kaOg45M+oxI5Mp5xC2/632tNvDSvCdXb2B3WVp1pbYTsIhAapaK4pcbd0o23/PWTVD7d57Gr5EgIAKMsPlmA5s1oWCLoS3U0Hg6inDFgZif3Y8gmm9tXUA1i93xDKIWxl
 ExihMJA1
 Ajg+/qYgeebaWFCZeYQFRKy1RNhbBvVJ12KNGAb+kwaULt+x5tVS7M81m5KeEoVzbQ527yUqAm+n9kVVP3SFFJKNIRdQZjhXdDdtqqjhXsK1bLi5bjLQ/USgHMdNYP3pVvzgBSfx3s+3Hk9BnTHkuUqz5wau50751QumdAyFBc0Di0Wjn1DGCIX4CrS+UxkBY4lMJskKjFsJDVuwq5Hsx05bdSxHoB29Oaff7ZscwVFDJl6bcsSLrFDUTrrDYezcfJmeBz9RSfwxo1C69S2ZqS8ySXioR4geUu20rPUcw9Z1uqkhtHYdGJX0C3jxoUNitjxUIISEbFhSYXXd6W8gxU1hDDJD2tjWvO/OcVkCiI6967zpkfpl6BFmXPJMpdznJbDVEe94g+RBZUXPoGJu3a9Id3yhn1jWzHb8tcXBz3itaEYWX6+NZ7U05+MCeaZLZL+41Z+tdnsiRpflalTUBDE3H5+3e53snIPVkdySkbiQjY/NNWXfbN2Rl873c4hJTNoz/EtEId6SFcQJ5jinV/0RHd7C4tR4p9ix9X/R4vV0nEl/0dt3ZEkPzq9w2VASUuiYI0/tDMC9pmebltouz02rOC24IlIpjIeRND9j9TNr/UxEcbiNB6AqYWWZucugYH2fH3cJ7W7zDeQqqdNoi9WgFaaVyH6c9oeegn0RX/eoI/xbCxoeNhLl0liIqDluxb1IZKB3FMzUYhX37GzPV00jWmLlDyg8QpSF2T5nGvsoOioMxwomAB4dbwJODOy9Q9qohg6aSSGY71GJRGyoKPn1vGKDk+441cQ2VS7hNkuhOzILvXKXyAMxadXFFOUk+9RQxi/zGq+3Zvrd64LNP3snx7MaqGmrLoqlGKHaCcZF9nH5/Nbux0qHQK1UYCILouDNTbH+TOvFCRq0GWcSa3LDaLGyXWFhSlfFo0BIjhdxiPcFX0vYUhJpc9NVFuA1RvRebT9J0N/ws3hAgqdp5P8Mo6pLF
 SVScnkPF
 XgBa0G6obAdtF17WnwjYxVMBKE1wbiFfs/hXrO8Mw8hG1kCnML7EFsvGDUTCJN3nTPFtsnox0yLWaEjiHlSHToLCCKPxgLG8am+BomCqN2D5tqifd2TFy9tYuZHiKQ2GpFDrzEDU0ijSnVTN/JwG5P+U5vnaMY2oazOE9QSLXfYaAZDicrU70ieQpgPIiMXalxLJ+g4E6/Zx8vd3hUVcTQBt1RhYv1tkG4S2qcqHes4mk9rIjFXzHBqs1QsDUz20JYIB4PcdssRec3CHDUgPnmU67hM6oI3BslNXgao8u16mwwdKAnZ7hxqfiCf3YLSRoIH7dftGXbqT5dEixeVCA5SbnxA2Pkv0Oy0YOIzMVtyCFenfXjnOvA7IPBYpixkCQilzdFFUZsKmgdctEBC7lRiiWoHxHAK40DJccwKCxcgiPt6wcbbON10jgE7+C+kYikZMwhdORV1OWsSVFPWzZ/R2kxZuykat71aDVXotTml1DLs1T7Ee3Gw8m6N3a67CVeYyJJBAKSfazeV8AOQdbusoPstL/6O1CsIhETNz0ewjwT/SW4Wt+HrP2tmVf3r11TcvKKZ+zW/IxquM3/+aFU0f17EEMPtPLV82d+KOXbtXEpfrNW0Mlk+PiNMuHPL2uqeNixoBApH0pYdfwpiNWSNRvdOzbLdXjJJ57kFO/Q2Bjrxyix7x37d3CfjynI8tY3gCJss7b1rX4THTNvM4DBWKRYBqmAwJtrXCGJDu2hhB+IPXtVBlk/toJ1DZYRQPAQNt0saz05pPsY1FpNgn0tZhZc2MiNZsKcKs+aDI19pRaEX18LoehljL1PGzmCHN7c0q7iG31u3RJpkZcXe0IQASTrWP50pb3xWtMCNzkEW3H+b1JSdmfRHvWbmLVUxtTetT47WDE/bafB990hjcUe5rs/CYiYZj5rkaRFENPTnB4OXjh02b+LcvexqDY8AHnNzb3WHOG8rxdRL6XwSxVHmnr/AOM
 8W+9wgmf
 VIDsoDtHQg9jsY1S9BSGmPhOjspMKeFpSlO2wYqYJEXsCKieqQxp58dT4APp6OjLrgcvCEcLcZ/6tIIaVywakLne/9zHejshKppGw2UCh10duMQuH7KC+bWLdy6ylgg2UBONtDZYaLrKratvEDZBzzwhoHrdEK0D5og4hzBi3RR4x1uZ4WvRn6N6VQizn8zfzcnX5JsABEHz8dP2IsB9bJWghlapLAtCDmYhSZ4q2HlXefgAiPHNfL5JvPEDDsrVvhV7YBa/0p2Rl2J4WO7thicNTQbDok/tzyQwnpMenUabNaa0s1L0+zqriVQsXt2zVmlfZ/U1A5Jy7+RnDLeX1g1M/u2WJT+2jS+iLNxAlChaM7dd5Op4V7PSnXk+r61m/hXWD2LpNwe4ucoYcKH+/spqVenak4TS/PaSt0+Xiv0XQmNuo38ZymF5+ANuU1t8M2YHupNSL4YvGBCRg7BXr7KH/quFHGwmE2RP4VTLlG6NFcHx2LGw/KDAONQnyybJ/TuOLXVGyWwBtQaUUqvpY7Je2kl0zdg2KN+H69iMieWbjRT9BkXunMI5O2EeP5d/PJFf1gLWQ41U0Q2OGDVwRWOLJmfaB4SL9HE39SEFcOjIZtIlTJCVrbK6l5QRLZpRInbgBda4wHk6RilX/+kyMDAdnao128GG2WNAwPkbVSdZEHVtm1xGGBR5m4ZnxJXOPYzQXt9opGj0nFihWcxuVeoTeL91wm3km4HBsRAEZI9MN6FWxl+bnzX5Ve9BPKFv6hLtzqdmzpQXdrT3oJR+NNqKZdsANZCrb/+bHbl35o3YXXdrkSIltBfYtRpBDxMvhYCn+CeiUnVjn2+ve3UvZMfZIoNJdbzW12DnTb00BlJ6PldY06tfFHrIMQj7XuHzm8+siDvlFS5o+INtnwJFYZTNdnRrEYpIE5nZSxOdppyqkhNIsh4Biue32hSUI03Y14OP2npcXCms0GNRU32UDJ926WHGd
 1ksMWff6
 vdHpH5apBsUjLHbwIh5xpR3pqm8aX5jMpYEYIvd+fv++37xHVLx/rdC+ZRqzTsteoShHCkRfSumSuPwIVH3+1Op7xNNrlYdPkU39KYEA4rIvo/DxEnfIl8u3Eyb1lwxAeOe4uoTngnh+0aY6KmDj+VQTaHgIk3w1b7ODVxP//bwhRIxyj7mco6tWKI+Xtx2lqLwi4+YjC07VlBJ/OlNPKzgGXXQm41Td835NCBePQoSZ6lWv17xsfC35ePQK9jbaEYhb0BlBeehEaEohSM1JsrgZO7d+U6tXfh5j73H4FFsUaIzUrvF8B57dBTlQ5CodeTtYcG9pOxhJuOlU9s2coyhrriHTrMwVrGK8eiRvM0nJtvx/vsWJ68GmZ9rFdsIq2xZLfq2Dc5UP4+JQDuHqFEDvl6nI07mQqfs5bv/HA7HbHHoaut5vO3Hdoq2eU4+FTpS5MMHCyfisFHZeyL8NVxAGBawwHwCwgDx14Q59V44vd2qddwWdWaohQYSOGpFB9DzcLT2UBd5BIYCS2YdAzcjSV2jlQboFIbXYmWHdIZYnyUiEiTHG8ISXsC/UbN6C9dft3tLnSaWww/WNwSYsSIsHv0I8giLK3S7oQAAd8dAPkwcmsbQB/WIqZ2c+dgKo1l6AqXvpkHaEXHIkU3m4H0pKIDCbsqluafb52hAH/tOLnrr44QvuWSeQTBycrUIuxbg2kL7JPuP43HjAhEule8hWFoJcqwfLVXOzvKiaHEuaWKUCE/4o96GE0xXVjrs/P4wCwvULIcyInwINc56etVjB16LSu+T7tRaKPNH3xIR8O5TLe++O15fIJQyN4Fx9YKZrHyHoegkynytTMoi0nrdDcJ9aNhO6rhJyHeOFfcaXnCSaS4u1jqqcir+6Se07TMgcU4dHFBMsBIHZiPVm6lzfqfdydDXOtSflSLuuEbf1isnbiiFRUbFd8L+WjPDgtTwKn87GeQfPL7XKYVi3+5RgkljWB
 2fwr9I7R
 QjzNI+oJHk981ktYPBC8HoMLGh7FloJrVq+78rTEk6mxsO1kRYnPaA31+8PffJqwWtsvJ+q29FJqkvqMnhdLpc/2sPH6KHifTdmCx9i/cnmO5FHohTzmqhAD6GmMcdqvjGve04NHHfqD+d5h6hbTvA4JttH0UGT8Gzb5QpCv9QmkMLPpJK+mJYPRGR1WclOhCCKt6MA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 5efcecd9a3b18078d3398b359a84c83f549e22cf ]

The clamp family of functions only makes sense if hi>=lo.  If hi and lo
are compile-time constants, then raise a build error.  Doing so has
already caught buggy code.  This also introduces the infrastructure to
improve the clamping function in subsequent commits.

[akpm@linux-foundation.org: coding-style cleanups]
[akpm@linux-foundation.org: s@&&\@&& \@]
Link: https://lkml.kernel.org/r/20220926133435.1333846-1-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 1aea34b8f19b..8b092c66c5aa 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -37,6 +37,28 @@
 		__cmp(x, y, op), \
 		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
 
+#define __clamp(val, lo, hi)	\
+	__cmp(__cmp(val, lo, >), hi, <)
+
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
+		typeof(val) unique_val = (val);				\
+		typeof(lo) unique_lo = (lo);				\
+		typeof(hi) unique_hi = (hi);				\
+		__clamp(unique_val, unique_lo, unique_hi); })
+
+#define __clamp_input_check(lo, hi)					\
+        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(			\
+                __is_constexpr((lo) > (hi)), (lo) > (hi), false)))
+
+#define __careful_clamp(val, lo, hi) ({					\
+	__clamp_input_check(lo, hi) +					\
+	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) && \
+			      __typecheck(hi, lo) && __is_constexpr(val) && \
+			      __is_constexpr(lo) && __is_constexpr(hi),	\
+		__clamp(val, lo, hi),					\
+		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
+			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
+
 /**
  * min - return minimum of two values of the same or compatible types
  * @x: first value
@@ -103,7 +125,7 @@
  * This macro does strict typechecking of @lo/@hi to make sure they are of the
  * same type as @val.  See the unnecessary pointer comparisons.
  */
-#define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
+#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
 
 /*
  * ..and if you can't take the strict
@@ -138,7 +160,7 @@
  * This macro does no typechecking and uses temporary variables of type
  * @type to make all the comparisons.
  */
-#define clamp_t(type, val, lo, hi) min_t(type, max_t(type, val, lo), hi)
+#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
-- 
2.47.3


