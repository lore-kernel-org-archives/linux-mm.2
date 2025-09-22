Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F8A6CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7842D8E001A; Mon, 22 Sep 2025 06:45:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734598E0001; Mon, 22 Sep 2025 06:45:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4898E001A; Mon, 22 Sep 2025 06:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45D9C8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:45:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1A1E59ABA
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:45:42 +0000 (UTC)
X-FDA: 83916555324.24.4F347A6
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5F3E7160009
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:45:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=IMvdEOaM;
	spf=pass (imf08.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHPTQZFCaC0QVf/rAslU2rF+GKEtXGi5htBMXx8M8BI=;
	b=rCidFpYhRthaHt792V0iBK2tIlIKuelKNiTHtu70xnIUqqQ2E+OapVgUAKAR7qBrKTVECU
	i9NgI/7TJ6r3cSHLAW4GeCBvhY0ZKKGmY/N2e6tRBEQvICmz5UE2lXyEXdEEWSMsa0Hqk4
	kDNZnL7YR06/Nh6AXTK23rdjWBw+lJo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=IMvdEOaM;
	spf=pass (imf08.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537940; a=rsa-sha256;
	cv=none;
	b=2mXOXFlX9NVX9o2wgjhbNYH1B5jCcNsaAlfX9Al1es/BBed5QaGdFMM16Pe7OIPJ8HFwoo
	OKmu/SMqi7yA7C1E1cKVldXaT5shnBgvOIe28uLrUvuhNv2WfMiAyf/BTG1qj3Z1CGWX8b
	wtygttJ1Z61nGum80kTKmjks+K5IcSk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537940; x=1790073940;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jHPTQZFCaC0QVf/rAslU2rF+GKEtXGi5htBMXx8M8BI=;
  b=IMvdEOaMe0FP+IRiNewRyRaabx48iIkR6MASuvWpSUyJRCz4No1zsMj3
   JJkx18PvOX4VxXtT7+b/z+LHjF4zoySj64sfRjKGuYAYCqZG5hejOE9YA
   qQQlCJiQNG/xRUtkvVoeVq8NS7PNXApOfYn82/PzS4izkM+75VP4Om2LH
   qMW0Ohj/UlUx5cqki//gorCp/4bnAhxNPQnnc/PkoX3Ann3pMdXYB6N4i
   CQ8JRm8d78O41hqV4swQq0KdQj4zidPRvKsqbCobiE9s6b4Zoz1mUNqaO
   EGo/8/s2hD32Nbtg5CNo7SsAufXeENVgMkX/8b9vziSIfI+feCNVcgScO
   Q==;
X-CSE-ConnectionGUID: 6hOHCxAKSfC6e+p5CvVdZw==
X-CSE-MsgGUID: YBSxBrJDRxalvxjSB5/Ebw==
X-IronPort-AV: E=Sophos;i="6.18,285,1751241600"; 
   d="scan'208";a="2482713"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:45:38 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:29409]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.10.226:2525] with esmtp (Farcaster)
 id f47c06f5-2d15-4c95-af11-de6ff2958513; Mon, 22 Sep 2025 10:45:38 +0000 (UTC)
X-Farcaster-Flow-ID: f47c06f5-2d15-4c95-af11-de6ff2958513
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:45:38 +0000
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19D018EUA004.ant.amazon.com (10.252.50.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:45:37 +0000
Received: from EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d]) by
 EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d%3]) with mapi id
 15.02.2562.020; Mon, 22 Sep 2025 10:45:37 +0000
From: "Farber, Eliav" <farbere@amazon.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "jdike@addtoit.com"
	<jdike@addtoit.com>, "richard@nod.at" <richard@nod.at>,
	"anton.ivanov@cambridgegreys.com" <anton.ivanov@cambridgegreys.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "qiuxu.zhuo@intel.com"
	<qiuxu.zhuo@intel.com>, "mchehab@kernel.org" <mchehab@kernel.org>,
	"james.morse@arm.com" <james.morse@arm.com>, "rric@kernel.org"
	<rric@kernel.org>, "harry.wentland@amd.com" <harry.wentland@amd.com>,
	"sunpeng.li@amd.com" <sunpeng.li@amd.com>, "alexander.deucher@amd.com"
	<alexander.deucher@amd.com>, "christian.koenig@amd.com"
	<christian.koenig@amd.com>, "airlied@linux.ie" <airlied@linux.ie>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>, "evan.quan@amd.com" <evan.quan@amd.com>,
	"james.qian.wang@arm.com" <james.qian.wang@arm.com>, "liviu.dudau@arm.com"
	<liviu.dudau@arm.com>, "mihail.atanassov@arm.com" <mihail.atanassov@arm.com>,
	"brian.starkey@arm.com" <brian.starkey@arm.com>,
	"maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>,
	"mripard@kernel.org" <mripard@kernel.org>, "tzimmermann@suse.de"
	<tzimmermann@suse.de>, "robdclark@gmail.com" <robdclark@gmail.com>,
	"sean@poorly.run" <sean@poorly.run>, "jdelvare@suse.com" <jdelvare@suse.com>,
	"linux@roeck-us.net" <linux@roeck-us.net>, "fery@cypress.com"
	<fery@cypress.com>, "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
	"agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "rajur@chelsio.com"
	<rajur@chelsio.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>, "peppe.cavallaro@st.com"
	<peppe.cavallaro@st.com>, "alexandre.torgue@st.com"
	<alexandre.torgue@st.com>, "joabreu@synopsys.com" <joabreu@synopsys.com>,
	"mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>, "malattia@linux.it"
	<malattia@linux.it>, "hdegoede@redhat.com" <hdegoede@redhat.com>,
	"mgross@linux.intel.com" <mgross@linux.intel.com>,
	"intel-linux-scu@intel.com" <intel-linux-scu@intel.com>,
	"artur.paszkiewicz@intel.com" <artur.paszkiewicz@intel.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "sakari.ailus@linux.intel.com"
	<sakari.ailus@linux.intel.com>, "clm@fb.com" <clm@fb.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>, "dsterba@suse.com"
	<dsterba@suse.com>, "jack@suse.com" <jack@suse.com>, "tytso@mit.edu"
	<tytso@mit.edu>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"dushistov@mail.ru" <dushistov@mail.ru>, "luc.vanoostenryck@gmail.com"
	<luc.vanoostenryck@gmail.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
	"pmladek@suse.com" <pmladek@suse.com>, "sergey.senozhatsky@gmail.com"
	<sergey.senozhatsky@gmail.com>, "andriy.shevchenko@linux.intel.com"
	<andriy.shevchenko@linux.intel.com>, "linux@rasmusvillemoes.dk"
	<linux@rasmusvillemoes.dk>, "minchan@kernel.org" <minchan@kernel.org>,
	"ngupta@vflare.org" <ngupta@vflare.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
	"yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>, "pablo@netfilter.org"
	<pablo@netfilter.org>, "kadlec@netfilter.org" <kadlec@netfilter.org>,
	"fw@strlen.de" <fw@strlen.de>, "jmaloy@redhat.com" <jmaloy@redhat.com>,
	"ying.xue@windriver.com" <ying.xue@windriver.com>, "willy@infradead.org"
	<willy@infradead.org>, "sashal@kernel.org" <sashal@kernel.org>,
	"ruanjinjie@huawei.com" <ruanjinjie@huawei.com>, "David.Laight@aculab.com"
	<David.Laight@aculab.com>, "herve.codina@bootlin.com"
	<herve.codina@bootlin.com>, "Jason@zx2c4.com" <Jason@zx2c4.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "keescook@chromium.org"
	<keescook@chromium.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-um@lists.infradead.org"
	<linux-um@lists.infradead.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "amd-gfx@lists.freedesktop.org"
	<amd-gfx@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linux-arm-msm@vger.kernel.org"
	<linux-arm-msm@vger.kernel.org>, "freedreno@lists.freedesktop.org"
	<freedreno@lists.freedesktop.org>, "linux-hwmon@vger.kernel.org"
	<linux-hwmon@vger.kernel.org>, "linux-input@vger.kernel.org"
	<linux-input@vger.kernel.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-stm32@st-md-mailman.stormreply.com"
	<linux-stm32@st-md-mailman.stormreply.com>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, "coreteam@netfilter.org"
	<coreteam@netfilter.org>, "tipc-discussion@lists.sourceforge.net"
	<tipc-discussion@lists.sourceforge.net>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "Chocron, Jonathan" <jonnyc@amazon.com>
Subject: RE: [PATCH 00/27 5.10.y] Backport minmax.h updates from v6.17-rc6
Thread-Topic: [PATCH 00/27 5.10.y] Backport minmax.h updates from v6.17-rc6
Thread-Index: AQHcK64HHJftfGNvN0Cy23wGYTG5SQ==
Date: Mon, 22 Sep 2025 10:45:37 +0000
Message-ID: <df8d65b372864d149035eb1f016f08ae@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
 <2025092136-unelected-skirt-d91d@gregkh>
 <4f497306c58240a88c0bb001786c3ad2@amazon.com>
 <2025092203-untreated-sloppily-23b5@gregkh>
In-Reply-To: <2025092203-untreated-sloppily-23b5@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.85.143.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 5F3E7160009
X-Stat-Signature: r6afn38t953uw7uyy84skmexj4od5kso
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758537940-142081
X-HE-Meta: U2FsdGVkX18aNfSwglmoN2iOvhE+dN2/ffstpreH5kyuQNVW7lAqqZWG8FXyJzJ9kMp6ncBIxLLX7pX++soMAe0ytRxXbLLmbatNhRAhHlWMH0gu1+OfYseP7myDrf7GBaV//T07fwTNMUP+pHP7nBqLk0achlQv0V2M+MW+8irqsziPeCvqEBTdve8zRiCxzo7y8iG3jCA1Jtu1GJ3jVkZBBNLlTXXJ8VtmRjYPW+f+xfX2RvOjq/4KPPID591pR83s4bhMX54Az4V5lHwkTK/W7MN6HJnP3VebfnyUkxw5rFuhr6ycn6DxbsFl6lNXKET2OLXiUIJfMoQtzOkYUmdgQOYbQrDqEoA4fHLcMvsQWWzA442sRy8/Ngqcl2BIiKcjz0HbziE5MgA6aFDf+EPOZ9BNL+o8Wp4ISWHclBc5UuoVL9RDQISXZO0TR+5JuhLCINllt35coqjA7uu8k1zZmARPLGtp8JSM5K/tTc+Cp4HOYXtmprKi+WKeTj7JPxp6QeKdtH2I/PlaUcC6OE42cIjBNTJ2mSEGu9vqDOhlk3cf5kEGxyM+8FSyFE0oCSbnM5wYJUcV1JYVWIZiZybUAJRYPCiQ1JHi7CvHVkUTlLLP+c8i0utnfAF7zUR1Mva4WpI2LXmOP8Q6yxR+mvnDKWYNcKziTn6wE5nzlSAXfbHnF9jP2SrKqs8nhWX66lH0PbCrVGUpE8cz2yLvO1E89pG0o0blkYnrUszaANDYwHLhoKjUqehQm6ldJSQHZn0Ty1y0Y/SiVRt0UUBglaN+d9Zos4wIjufcOezSkQNaFGrhRw5v/lndGNWnW5oU7wQCgFYwYBuuUDzXgWWUg2Yak9znwUbyizycVkK8On/0cC9tmt/+/8Qr9ElGHHn23n9ihjVHlw8cJL7eEvi5jNAzU4/FwCXAtbdbAHu5FNM1lajvnqudVn2Htj3FPiS9lUFYeUtqDlN/RztIS1x
 Wz0ukTat
 jO9WtsdXTibWSaVI/0BYMZYzT1VXxHAF3neTLOIVzli8DL06v8JaErLwkm68PRCfGmwHe/p+7kXj37THwURdryWVPjfAa1fFMSkRV95O+/TNBbHl/ja3VLERoZD5MiH0hS0VDy/FpqjfsneihH6Gx2X4aP6O15XHRo9o8q5cw+mqUbQZV1ZkP/EvT1r19ItIKLsCQeu+eD/BQVr2dNubYt1yvVLeT4WCFZItIxO5fpMNEf3BVNamt2qZU+RXP3LO7SWZqr5a50y2AxF6VAIgpONcsETKi44RdamMj+dWcjjBghV9Xo2DWQ4cvXFQ6t5/2mH7jdqDsifO25TMMmkV0Q6/2/WZiVckfnsMpBD8j4U8A8eie+fCwSrCRQoHL3Qr2bbMJb3pTAGa+QMekafNVaLrbonhZ8kdYIQhlYCs/tRYHgxDt85p2L3aPTFars1wsIyualowTSJYPA2hJr1IAXv2LAZMIJ5hC0UdJmC+R7Weeb1rdw/o20wPQWyOIdas3yB6mdaJ+KeHCc5AEsgSpMW8pvPo4HC1rXYH46igF1qvtcT/pgxCYpUB+TiggM3zlH6dgM2TYih6M8gCggZS+MB2g7RahU4I2+0WfQo9UgzlKzcyyW0bYfB2AJXadNNQV3cn0ha1l0cqj/9cSiBlER6O9fgz75pmwJbvl2kuT+G6YtXZkKMkKl7pIGPtIeTYHe3LfCQhxHp/lJCsbzTJZczQ2KbXwIFyUOWWbMdLbGxRDMi1UuICnAjF6vxqUFy887LRoy2SXynNl6ihLvzIEPfzJcrtfouNmE2o8PqVPD4g+v+e2eUVenk1fuMnIJ1ZwLVWOCYrptTz0egIngie9r+yi+SICZvEE+giJIh8c/UkMQH6C0QzNOj6N8OLwLhivYe1Nz2OrsDTp0G2WDPfJWuiR3DnvSvAcY3QpIf/w1VlQoHsWJvINGkebO8m+A3G+lzyShFSrDAeT9zZ+oihqdKeay20T
 Qz3L76W+
 jATQ14/BiMwlGBNegCvrfQSaTVIcGgviJvWlxKlEVGe0f7nICZwwVxJUFFDvUrcIlCjQKhnE2DHcRwX+DTcYbXiL57WtqVy67yFYhGq2x22+7wINpTU0mC5QHXJctfJYp7LcJGXFsaMwPVSjCRfmncKd3R3fNNRGbFVZOJtJm7nHljzrH863EySOozkJdxMeWBbB2SiDFsavuiZ7aFOXYVe40kl9sv52sOpbl1ekshnNqf73DjLekfnQviP4NpRzMQkExpJI5YqRV1upKii8SlOwa63SsCA5f0Xe5mcbt/j8j7XEL1oGV89q9WdfO4bsi6dI78lmz0o/DccJ08dKjHIQthSwkXoIxCs4Lg2ZLDYaifisJ6+T2BcECcMN9mQyjfyeU9vJJnjIptIg/99Oskh3iNDr3kdtAY9aDacd949zgJQ5UurSMB8HkrEmmGmnn+LRm9z1AZa7PzID4Oy7K9U+VpvwcN6oUjpSdc+GkqnIER25Vp5yZqdZh8fOYjYlrEweImFHdZnOringf2p4FttZHtpV4BCFkNiyFcGzHB/Nz/XChI/Pzx0+6cMK1xr746kflPFmIzdk6NWFCRJJMIm6MkTSnIfcyGAwdtXj/ol1jnJRqac9wxK+FdR/3cztlPmYr0vhlYBjubFIVg8Lr1nsBsJ8HuPxiN2kxwbS4TYjOuAH+GY/iis4RRybNzDX/zptFec5ifHamtph5FlQZXu2LN5qhlaYrqkJfJnkZygDIbagWoJrGZjvC5BdYdteLxqvXFb7alE9RiAL9uWNK/h+Zw+wioqohAig+fGhmUu93a7/3ivlFXin5D52rdD1eitxuizXkJZ1wN6VXlpBGyRaVS5mZcixtfZ8eLzTU+sHltq2jp4mftgIqpzYArXYvinlDpEolpjUS2LzZks00j+OfRiuKz2o0YhKRaYBUbg2noOkYqlc9kQG/r27+vRkgkzyIcvF0kw217k0sghifm95FdxQo
 G5LTdgAC
 AWUFW+L3tP//lXnWjfP+7pj26sSxGmoSiKWW+cNmaKHaC3ybBmmXg4Do6CCr+rC6qVOdPqnH6ag6RFyf4lwIZmxt8D5zCL5cykgSk5h3XWdN6dWnrWRPIvKfrVFtZ92CUhsS4qhR7EdodME8q050UACGqpZXIwYB8jtTAOURXpqqnKHOfLBAgWeYpqnKaTEpHwhpsQq5dhtHllXFepTsBEoivMzksMTkN+yoDpBFs+QEXJW9xco9zJu9BkMVb9/KjOaj+xcpcXcieFroMSZDUNMkXEIb8CxfHhBYuFZTKcI4pCq5RRxPRyDjPHy4rkg5tfOPF3IWBs9OiKT66/E58v6GxOApBTtfubAaPcah5RMbgpH2k60avpCM+wVn/KED8pf8XSEAjlwyeFgJyKHSIPzfOIlJKFqhfHSg4YhaIqXUy0lps/cGMn1mVwX8PdEm2iqGdKnlpDwtZATXfFlm5EW+fZk8+ywiG+HjwwL7kgLaqhqDxf8iAPKtqBxujWroyICs/n0zyG9K5Bezn/369oxC13wKLPNlURtmbAzbDejvWQg/c71rAUVeNreqKi57uH19g3zY31Z5NAbcX2vWE3UHKJPLihczVsZTMS137YuQy7UMphTOZ0cCdNSGX4kCQnBYAtF4DqC+hghearC5l1L866DhRgoZiQmvstRzFGvD+TGQxVhsl0/S6V/Hkh5vByQmj/tPEB1lyUnUoZXSLl6/mYZDDb4MQxXWqJBCIzR4XezhmCIXXCiYKv3Bv6DO/TwxV2duX0sUQSXN9VZDm3SkYBnQ51st/Q/woojvPN5kejrXwwDDlYndjI1BRvlTCYWeRECTfdV3OW35E3iNMaYwzzQFbOWPAa3lQkqhkLl9oGhbACLkEkI07JcKw78yZ/xaYU8mbW9RKdvTyO9/TsNxYU4B8BHQFS+nPkKLn7puedd/ZuSZ0Ux7P+rIoabVdJmMYfiUViVVt8X7nUywrN9p30af0
 JgyMCPFC
 f0DL2+OPnT0ZOB0qKazf4h/ByaEi5ljze1ndYUm0HvX245T5MPLW4ASqNlIqkxOxyKriqMAr/UrF+hYSEVOnnULnF36qJvNAeqDxMTDPJqZXugHRlB4/K9msthhrckTIIW+SKnX5S7oh5HwwP4FV+L0+gdzwsirpiLWtQI2CFd460IKt+z8oX++37P258Pln8JJxKjRdk9uu9QCBoskIiAebos6fbOdbJ5QGkb9fW+mz6OWalMyfNspB0eeQtR7zj7Vf3hOtRapr3Ewbq6fDRytxCJRffEljRYKj/Jd+FAlgtfECWcA9aXjP7NLvvHrtTyan6PPeZe65gA6Sw5K8oWa/frHhNXyd1s4MN3L1ZiJJBhfQXTPV8IspdLVqSw0/Iaos8qwUwtHyUEPPwEvQmMwN6sPtoR3T93ZOMdg5+8dWa7Kt5jPuSvF3XozfsrWfsGeF7XlEnJMiUfuEz/0DZFjs7S5BzO4mH245vTE/urCxTn4K2tm8vnvb9MO7I4hqlTkCFUAHmigwZVBwMq1ch2RL49fwgSAS16mEtWtM+9yAoeidOxsSvvRus4XBCOEbxS//itztUReV1I/Vjopw7q2f6fJpZPDaBeja3ar8QkzyABiaBrp0ilFLNrxDWqKPaUk1LiKjghvaBN5+lOMLqRE1a+tt6suA9KuCpZSOt/66LP4R8Zn0rRnVzQ40ZAEQ9/mp5XAIDbqN6lC+NC6SE9maZCnuyUbAoZSa7VgzjWjwFyXJm4PEl2Zds52ILkc3gbx1hUNusDPDylrUgjTNaTamtNjbMxsmP5MczTfsLU5beVUSY5UONthQwZXnr56tZBilwlNczBOequZHdLOWyxrIpcXW9IscqAH1XJVbLsJZO6dU+qbNL2Z6D7/MZDTkb0OjpZjkmX+joDuJ7KbgJSP6IJDb8IFfZaQdDmGAdog8LcIzdCqvRQcwkZYr1jGZuSEsosrfkFF+RlUkak49id14ptk1f
 MpDISvzh
 LaUu/BA9cPAoj8K51KiM7ScjBsz2zNc0vVasvtc0lTNo1Td3y4ex6wu/vNk8Fker070F7HccBJ+g2EVR5MekBMvk+k+CuSvtESreoXYT2zP64qIWQJTlGusYWMEN3r0up0mJbmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Sun, Sep 21, 2025 at 09:37:02PM +0000, Farber, Eliav wrote:
> > > On Fri, Sep 19, 2025 at 10:17:00AM +0000, Eliav Farber wrote:
> > > > This series includes a total of 27 patches, to align minmax.h of=20
> > > > v5.15.y with v6.17-rc6.
> > > >
> > > > The set consists of 24 commits that directly update minmax.h:
> > > > 1) 92d23c6e9415 ("overflow, tracing: Define the is_signed_type() ma=
cro
> > > >    once")
> > >
> > > But this isn't in 5.15.y, so how is this syncing things up?
> > >
> > > I'm all for this, but I got confused here, at the first commit :)
> >
> > It's a typo.
> > It should be 5.10.y and not 5.15.y.
> >
> > > Some of these are also only in newer kernels, which, as you know, is=
=20
> > > generally a bad thing (i.e. I can't take patches only for older
> > > kernels.)
> > >
> > > I want these changes, as they are great, but can you perhaps provide=
=20
> > > patch series for newer kernels first so that I can then take these?
> >
> > So you'd first like first to align 6.16 with 6.17, then 6.15 with=20
> > 6.16, then 6.12 with 6.15, then 6.6 with 6.12, and so on until we=20
> > eventually align 5.10 and even 5.4?
>
> Yes please!

Stable 6.16.8 didn't require any changs.

I pulled the changes for 6.12.48:
https://lore.kernel.org/stable/20250922103123.14538-1-farbere@amazon.com/T/=
#t
and 6.6.107:
https://lore.kernel.org/stable/20250922103241.16213-1-farbere@amazon.com/T/=
#t

Once approved, I'll continue with other longterm branches.

---
Regards, Eliav



