Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9296CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CE138E0092; Fri, 19 Sep 2025 06:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A58C8E006B; Fri, 19 Sep 2025 06:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BBA58E0092; Fri, 19 Sep 2025 06:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC5A18E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:20:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFA4DC05F7
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:20:08 +0000 (UTC)
X-FDA: 83905604496.14.0730CCD
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9C34920009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:20:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Eq96xiAX;
	spf=pass (imf03.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGaAvozmIqIzV143yBTS5nQtsGF8X9DZFIMkdv4YYLs=;
	b=qWZIx9bsrvJQqouADUSCWRlHdXFfYL8onmTrE6wauTjBLLmxia5VPMTztt/DqSS5Y+4E47
	Xaum91r6G/J4cnZ4jfTNP+6KzGb3e+Wl2z2LbBXA9zPy2FwluAmHmrFdHlUFBLD2/orYLK
	Zo19aXK+pwRQmIMMWaeStINLUibpdmo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Eq96xiAX;
	spf=pass (imf03.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277206; a=rsa-sha256;
	cv=none;
	b=PcvhRtgKuCdPGestWrzi+ItreuUS4xMKghbkVE0XMuSielS0LE0J8SqG+T/aRF+E+sH5qf
	hlgO6J8jlDBCt6sCGchLDbXQ/HCCS20nq6q+SrAm9NQw7kE627gxk/1ZnB88K9Jk2KAZLZ
	gl9QOdP3n0paWvBijvpxjSGmAlfAL0w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277206; x=1789813206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QGaAvozmIqIzV143yBTS5nQtsGF8X9DZFIMkdv4YYLs=;
  b=Eq96xiAXRYyGqIfWcT0D7pzPeIP3KLbaAvAvY0m2isP4AGx8TcMptxis
   cfn9lp7OlRD0doSjpK8kbJpX1D2W+xG2dz6qzULzUJH8bgJ8WdTmC1zyK
   tVKR77hrN/z2gqo0XmlpJhxlcjVjsa56t7m11REua+0lyp7eoKz1Kb2GZ
   SxWId7na3hyaE5Mmda2Ustot0QBNx8nD2CS9bu8VFzQzy8LzeMTgon4ul
   +ZLLbHLIPCz0n3yVq9nCK4vWE0Ton62MfVo8gA/ypQoRhSEX6TQECIMaP
   AoDVff7UvJKdUca73+EnDexRSijxXmO4WIRv8G7OU5YHn7F1mOqFssLeE
   Q==;
X-CSE-ConnectionGUID: bPHvAMglShCbIamgmo14mA==
X-CSE-MsgGUID: LKJuwHbBRtqfNGVtEnsw6Q==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2367284"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:20:05 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:21045]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.212:2525] with esmtp (Farcaster)
 id c8391524-0403-4885-aad1-4a008b12a042; Fri, 19 Sep 2025 10:20:04 +0000 (UTC)
X-Farcaster-Flow-ID: c8391524-0403-4885-aad1-4a008b12a042
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:20:04 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:19:36 +0000
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
Subject: [PATCH 03/27 5.10.y] minmax: clamp more efficiently by avoiding extra comparison
Date: Fri, 19 Sep 2025 10:17:03 +0000
Message-ID: <20250919101727.16152-4-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D045UWA004.ant.amazon.com (10.13.139.91) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C34920009
X-Stat-Signature: iiswj35776j3oi3e7gw67iyyxdn4pjfs
X-HE-Tag: 1758277206-423717
X-HE-Meta: U2FsdGVkX18fy305KfJ19gQlwjnAjZQQsxyc8kjfBQJTNq0rFuPDu4pzY5rxTHTucFjWz81GTgvLp+UxXTcDya4i4vTz8t23JkrKnbjXGw/mj3jxO3GlfgY2oPjq63xUyeCiYLFwq3+G+0R37LHeVvwbDA4kh/+Llpfwb4jX+Sp9AfPdckhXA5wlb9lroJLmseiBPPhqiHDIT3J4dffByHrFEbAnm9vB9xrr6HoVUKMO8fMUX3/FGpAyQZLQSiwEfgC9zEJ66qiGM5HuPsZaB7PNl9sUJzIRnPrJ3U632tVU06tuCGMOHKNiKlCOM0AnDIQ/XOAgyeCLfkU5dCd9ut147woACbsnCV3a7Ltrd8Zwxd/WAdB5nJQFpWhPi/Caok8VDzkJ4wiul1UBMDUjr7pLZVjMH/6K/DVbClFMeO74xEWpI9vvbPYVLAfRXwYOEQgAYv3diyapJRTuAGHMBZHywEkJ50OV2ERnvz5oi34wT9sIq7BCbRznbauHnQXcy4eoJLB3BrefFczx8aGUVXAzhmaiKAEGWfQ5aizO2n0qpcE7SJrOWxfSiHEY2Cri8/V8VcBSYniNUGekUgddAW6WYHZrTUmcioszU3b/GftmUe4kUUnH8Q8aFPhZmYVN8MjJwKrMWQ8J6Gn4pZRlJv8KcL0+84H1+Q40z1N+ZcZlf/dZ+GIOyQarfVlAoK8acue2fHTJ6f6GfTGQCn4L5fKSvIDKLlWcRj4C37vUIgEXA1gvwnUUTQi8ngSUyQRvrrJPSZvLTI1bQLy6ZI3pAtCjJtYtqn7HJqpVoDWa20ludlHetnBaA1jisHmNgrB7ZxLYtCATB573h9v9yNUNySD5d85CbyrgLRFNL809pzLL/xw/O1f/O2sTTgLc7MPaAI5uWiC9IFD2ZPWbNxVUYLVRnFFozM9VYf/WUJhEA1M9BYaih6oVjXecdAdlM9pa+RU+Y1yBhI9RqYRCVRx
 CILO8gaa
 Il1eIi8eeJ8Bsq4+YvygM+6TPSLZYt1IG7Jj5Vppsz2ICcRRm0aJ8VCvpjnNZtQdtY9kxZPn5RziMwkIU3jC0Kn4x94xZKjeOAlWEW1N/s1BL3Q0PjQ7AQkZi52aJgzSAbcDs2txEGz+I4H6gEVZkZuiN7otOjM4q8NO1CaJvtjKK8droOBDHbP9bPUMb69/pjpRS2tdItuGJUctMevykE5mwXgrrZVh9M+Ap+Kj/hCq831V9/Id/g0VUHjvjXqx2p0w9XW6A/OpBFgXJ9CGjTdZybmrOY5uIGRmu9NQYXwlwen6CeOCQY+uZ5oHF1c416Mvg+glyTYGibAoO0BCO4OtCZp6B9t9QjT2yA/yr6aQJ2PDvpVwvX/ExFIxV+d6NCXYxSH7oeNCDdhjrjKfijYq+AzjX2yZZqgsNnnFRPxm9x2KVCRiHGSBCezNQ9w3potlkGI+81qrsq5LKzM1n5AxjXUXh0YcQx0LeEDL8GLbZNnxt18ANeNB2ICAbUeRme2qWSbXtWfCoOuBt/sDJ5vngu7V346JwfapY31OaosOOQ+8sgz7UkqUFcQS5EXbKsaTPk3f1LiJ/j752khCuK166+A0sKx7lbXhec5xRPrWJxmRglVGcyxe92BTYQ+poYUJtj0SimEuj8i7WxzB7o2+9xRpEFlHPFjikpHISq/uIQIFBUX8V3wJZ10z/6Ke20vIBJyVuZ7ReXqbzZfYBukQZ90Q11gxz8ngfpbFv1O98rTIkXgsA7FqkwnBQqFG6E5lYQpNcLD+IHuV6Ny7NxI6fvmK5hMHao2HNJH3gURNJPHrlcvCG10a0mMR/HYF5BZm4gcxIEuHZaFs4zH9vnU3ftR4CldCxcQa5R9Na7Iz5IL6dt6WZZ4ZPwzN3PeVrrkT42wqVUGLyA/ekTEARRspX+N5cEL7TuQkEVgUZ+BknlwF8DhTFXi4DK2FNouly1j8jHjsOgqmknrr6m245y477WY2I
 sl8//6kn
 2qztZOr0A3pob6fbLMVVA5G6N5GGKSAOI9NEcXrKTzsVvakD61hxJwdYN1+6MG44a61T/4DX0Gd0MdSW2BZFJlJwRihU9LR0CxOmy9F2jheJkLdHPE7Ve1YUD1x3QgYUM0shxtxJ0YljPGQJZi2kFeX1U6XLNqOBoxaWEzQfJAtHykbRz+k5GJd+ELTJ9Sl5orZ3OcLkQG2CcfE0wCY8P+x6zCySH9AblrfoZdQVU3LzBEndWwO++T3fW1WoeFS5gbhPpiNJvLAIdpisqT4slI62ZicQyd+vIKQjOXQqLHFDK6YjEqDlz2tG4nhvgLc5XmR2kM92p7ABMpRq4dkv8BqP9zsqwd63LzWxu2QoOm33xdOQvp1Uy6K0AKBFv3nIl37EHtmG2/ttOBhAx1mgBQsu+d6xFnKQ9arSM5N9Q5WCnX1A9o2VCCVfDPsal+2zgVwwwx2VkIBIswDrbd0FLe4Bv7CwlWsTU7Ez+feQtM4ekfxsUG7tgCsx5AtY2gQ7DxavM5Y9Ff/x2bemjpJmPspkV56DE8etjWWfV3kFPefdhqcIAKfvzfApiofKm70/3fmuh8GW32SYGgyJVAtlaubv96hnWakPQbsi2RPJJuq1+Ba95MzHp+fnCfvcji2cPaufq663Cvl1FdlMurC3+1vG2754XZZCo7KgagowCX4Qcr6P6ZtQkgY1Z2mx3+pSmhb6/NzMUVt7qyBh0lZz2hZ9Fzijk+cArlhW0oJb6xwKdL7UqS/NfeGtK36AmEGk3rNHyR2NKABqZdc540Oxah4RnJJellyGdNUGm6ypXoK0ve/QCDZGdQ2XJZUCt9KvXYiUVl6qfK2JrCVTlEDzuiPDE2BlkA6vA5UwWuqopNY37EAv5awY6xMYrRk0rq86skMBFNcX0Iul+XqtI49WpYEo4rHdLAgHZ0f6NNOnNvpaFvkhj1r94UVYdmO2yXcPXvoafFbOivl7woMSvrBexLEJFw0dM
 cFkAbboH
 pXtwPUxLDG0N3pWMi8A7JXE42OB9v+PPW0G/aFwiMhVCY1QkTZS6eQ5jj1hrtS5vxKa77OfgArm3kcvPAJfSL0xB7lX90toxmAtSvQRd11i5pBWXj60w3PQPR8Mgo1HLXkyOPEO2q42iHY29pNdRAeRhZmD0ubYz60fYRcNhiyA3DMEmsu1r4+a4CnB8a3OvJeY2PeV9/pgdxc3YZaY2j/yboArMArfVnc+Ztr0kH4UHmXO6L8wVqPNdNS86Da1ouS451spwaH67hpXLMA8pzAhiv4VgfsKMjhEhT2k7STQeOzQbSsFutVcKeT9Mv08F9uQCHEPirnDQs7qpkRsAsQjIa+70uJATOWr8RHHjhc8yduOInnmIQZkfdKW6fJVxzgALIjXGr0ujgcWdmad9AWUEJtqTgdqvWmUszysXKqAz6H9qX8atMHvAhe26a9sOJMH6Czuq43v948luQBz+PxmuoVJ9uGxoQe7J3SygVwZufXYrnvSdu4S2yeIgzrfGM6zZHZlLN2u6wa/J4K/jDntKIpq6QRIawyA476oOdb34GkvU325TWlXXUZ9MKw1fB2nNkCaEwUu0u6/Qzk4tIzqjtnSmmGCdijnjOESMsay+Nv32a8iuZb1HUNbsrEArNVTps3vhcV2tdVBH5phoYkVD18DtjwsLihreCk4enA+OGJh+IK11Ch3wJlhNww5AcT4dJLx5preUJ34DgJMBEV/ZexeP2m44rXhnyB07vcMOf38aiaqEUxWjVKeYBi8v98NXdTxgxBgSPzrRnSGsVW21Bp3D1G5GeRKSazsE3+WqYnp8kjqoHllVP7HZlTLPo8XexLFzZBUoMoBcQxSTrKnvYW8zegAPt9b6cyfgRvhFc9ZhKF8gU4ZzIpQv71z7ptpqiADK6aPv6LN57hzNu0QmPb3y8LL0aNB6ux7ETg+8+o4Gu3Iue8Pq4NSjYrbXiTjFTNYgvPO3LbUVuytBQIUJnhH9z
 IrbXOZtI
 4bCUKhBJhFQe0Trv9z1Qs0oJlEviEga913x6VF/jTbGnRMyETHSd/7/TySZrL+/jOopKJqxiG2rPmcRunWM/o076htLt6ytjmpQiN+CmXB9LgAbl5UQxMrSIwAYVlN4ziKJgNPA/ueWuf5uFyMzMyXYsQyid554h4xWes8+ZUVLdqi9QQeWquEqFL8kl1qtiwR9DsrRQnmdrGPmHkoAnotlFLfEy6D0CkjceNmE6Bq/xDJDwRhAmeK8GI272r2vAPKKGBhxYR4r0TNKpFURcEUFGrS1nTGHixJ0SWBglpml85aI0b1+xq3RveM7HFUcUKnnEH6BjMAD1n33omhSxY9AV47yrr3fL7jkl5ymK5kQU/lzqtBMIa4NaVZKybH9lRmNYJLVoZ7OkPQMPXdB1j0xn4NiaCZJUSUcD77sDlsUWmilRksf/D8hwd84PCCEvUvy4fXGCEXHNwBfBnJEG7vVeGy+aGYtDI/TcV4r1Knk6ZpzDmYqA7Jn5glwGs2JlmHmhAxRnXZdJHwGo18Mdr3YYrhpg7K1nR+2Z0dd24pZeiEAaX/WRGv75K8MQsccRC1kXxmlduvLFd35Okm6IDnJl3v4p7IKVyqkCd66Z8WWj2f3xcugnnuuFJ3k9Nj6TJFWfKzKrgxNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 2122e2a4efc2cd139474079e11939b6e07adfacd ]

Currently the clamp algorithm does:

    if (val > hi)
        val = hi;
    if (val < lo)
        val = lo;

But since hi > lo by definition, this can be made more efficient with:

    if (val > hi)
        val = hi;
    else if (val < lo)
        val = lo;

So fix up the clamp and clamp_t functions to do this, adding the same
argument checking as for min and min_t.

For simple cases, code generation on x86_64 and aarch64 stay about the
same:

    before:
            cmp     edi, edx
            mov     eax, esi
            cmova   edi, edx
            cmp     edi, esi
            cmovnb  eax, edi
            ret
    after:
            cmp     edi, esi
            mov     eax, edx
            cmovnb  esi, edi
            cmp     edi, edx
            cmovb   eax, esi
            ret

    before:
            cmp     w0, w2
            csel    w8, w0, w2, lo
            cmp     w8, w1
            csel    w0, w8, w1, hi
            ret
    after:
            cmp     w0, w1
            csel    w8, w0, w1, hi
            cmp     w0, w2
            csel    w0, w8, w2, lo
            ret

On MIPS64, however, code generation improves, by removing arithmetic in
the second branch:

    before:
            sltu    $3,$6,$4
            bne     $3,$0,.L2
            move    $2,$6

            move    $2,$4
    .L2:
            sltu    $3,$2,$5
            bnel    $3,$0,.L7
            move    $2,$5

    .L7:
            jr      $31
            nop
    after:
            sltu    $3,$4,$6
            beq     $3,$0,.L13
            move    $2,$6

            sltu    $3,$4,$5
            bne     $3,$0,.L12
            move    $2,$4

    .L13:
            jr      $31
            nop

    .L12:
            jr      $31
            move    $2,$5

For more complex cases with surrounding code, the effects are a bit
more complicated. For example, consider this simplified version of
timestamp_truncate() from fs/inode.c on x86_64:

    struct timespec64 timestamp_truncate(struct timespec64 t, struct inode *inode)
    {
        struct super_block *sb = inode->i_sb;
        unsigned int gran = sb->s_time_gran;

        t.tv_sec = clamp(t.tv_sec, sb->s_time_min, sb->s_time_max);
        if (t.tv_sec == sb->s_time_max || t.tv_sec == sb->s_time_min)
            t.tv_nsec = 0;
        return t;
    }

    before:
            mov     r8, rdx
            mov     rdx, rsi
            mov     rcx, QWORD PTR [r8]
            mov     rax, QWORD PTR [rcx+8]
            mov     rcx, QWORD PTR [rcx+16]
            cmp     rax, rdi
            mov     r8, rcx
            cmovge  rdi, rax
            cmp     rdi, rcx
            cmovle  r8, rdi
            cmp     rax, r8
            je      .L4
            cmp     rdi, rcx
            jge     .L4
            mov     rax, r8
            ret
    .L4:
            xor     edx, edx
            mov     rax, r8
            ret

    after:
            mov     rax, QWORD PTR [rdx]
            mov     rdx, QWORD PTR [rax+8]
            mov     rax, QWORD PTR [rax+16]
            cmp     rax, rdi
            jg      .L6
            mov     r8, rax
            xor     edx, edx
    .L2:
            mov     rax, r8
            ret
    .L6:
            cmp     rdx, rdi
            mov     r8, rdi
            cmovge  r8, rdx
            cmp     rax, r8
            je      .L4
            xor     eax, eax
            cmp     rdx, rdi
            cmovl   rax, rsi
            mov     rdx, rax
            mov     rax, r8
            ret
    .L4:
            xor     edx, edx
            jmp     .L2

In this case, we actually gain a branch, unfortunately, because the
compiler's replacement axioms no longer as cleanly apply.

So all and all, this change is a bit of a mixed bag.

Link: https://lkml.kernel.org/r/20220926133435.1333846-2-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 8b092c66c5aa..abdeae409dad 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -38,7 +38,7 @@
 		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
 
 #define __clamp(val, lo, hi)	\
-	__cmp(__cmp(val, lo, >), hi, <)
+	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
 #define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
 		typeof(val) unique_val = (val);				\
-- 
2.47.3


