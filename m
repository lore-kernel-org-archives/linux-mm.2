Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95C7CAC5B9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 14:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09488E0003; Mon, 29 Sep 2025 10:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0FC8E0002; Mon, 29 Sep 2025 10:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCFF58E0003; Mon, 29 Sep 2025 10:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A958C8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:39:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D90258CAD
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:39:41 +0000 (UTC)
X-FDA: 83942546562.16.961CE51
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id C7D74140002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:39:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZSS5hXkp;
	spf=pass (imf23.hostedemail.com: domain of "prvs=36066c2f1=farbere@amazon.com" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=36066c2f1=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759156779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQWfyryv3PwAY4z7JkjeqszILRR0hMtG2kXXZBJTGME=;
	b=BVYX8cjWkDcjW/QNe/AFypxIT8l8jN8ewGrL4IjTY1xUjmn6JtQtE+IOmTiVsAsKEUkvZg
	mM8pgS7kQwvqQTvJKjhuIrueUEIk2o2ZdcOnilgQUGozj/tfS8IPXqpFUvhxrxt/9+VPbZ
	+t3yxtfoqBZJls0Z/Cb3NXdX1gl9QnM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZSS5hXkp;
	spf=pass (imf23.hostedemail.com: domain of "prvs=36066c2f1=farbere@amazon.com" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=36066c2f1=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759156779; a=rsa-sha256;
	cv=none;
	b=ni0GUWzZTDgoZyTFSiqjSI/eX91YysXBpgYa5D9/aOJwC6qoU4Ig6d0NjQRQQHi70r9SCE
	7NsHh5GRmT3o8gby9Br4L5ISyNm8q/aOZHO6qjKZYJ48JvIScbF+xowzFivt2shnf60F/T
	fJQlEgqv/LFjrRWeF2W7fmHGR4ozH0o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759156778; x=1790692778;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=jQWfyryv3PwAY4z7JkjeqszILRR0hMtG2kXXZBJTGME=;
  b=ZSS5hXkpZFc194Od3iEa4E7d8zu2U6n3DGeYGpj60uX5xiSiivAv4s+z
   11WQ8n/WWxSvcJNmLC5YPXrVjlflJ4OdE4q6gaPb9oBsccIQNo/rx6PGu
   FfH8rwFjan5uNH4b8J3VPKjYY6JxKBt8ASPKALJ0gPLN+X3QT78I+7/o7
   7rYX4L3XiFxkLKlN2uqYVZqLI3c2BiP4FvoLHYnGl30bKvERxeR6ohuhE
   p6/fP/3iF9nLccsvZ3VDzMfn7FR2Tf+KDWzKh2zqHyR8VylkZj5bam8eh
   ed9FFiTwjgi6VVI2L+JMeEu0G5wx6pZS2W4sNNnueDMdUIeaMYOr10jHD
   Q==;
X-CSE-ConnectionGUID: Eg5FVd3DSAe1GaVTZtKB6g==
X-CSE-MsgGUID: z2L5KGDMS7uQ8XhGedGakg==
X-IronPort-AV: E=Sophos;i="6.18,301,1751241600"; 
   d="scan'208";a="2836489"
Subject: RE: [PATCH 07/19 v6.1.y] minmax: make generic MIN() and MAX() macros
 available everywhere
Thread-Topic: [PATCH 07/19 v6.1.y] minmax: make generic MIN() and MAX() macros available
 everywhere
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 14:39:28 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:13136]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.147:2525] with esmtp (Farcaster)
 id 231f5531-c12d-4148-9dbe-5b2468a5b014; Mon, 29 Sep 2025 14:39:28 +0000 (UTC)
X-Farcaster-Flow-ID: 231f5531-c12d-4148-9dbe-5b2468a5b014
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 29 Sep 2025 14:39:27 +0000
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19D018EUA004.ant.amazon.com (10.252.50.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 29 Sep 2025 14:39:26 +0000
Received: from EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d]) by
 EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d%3]) with mapi id
 15.02.2562.020; Mon, 29 Sep 2025 14:39:26 +0000
From: "Farber, Eliav" <farbere@amazon.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "richard@nod.at"
	<richard@nod.at>, "anton.ivanov@cambridgegreys.com"
	<anton.ivanov@cambridgegreys.com>, "johannes@sipsolutions.net"
	<johannes@sipsolutions.net>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "tony.luck@intel.com" <tony.luck@intel.com>,
	"qiuxu.zhuo@intel.com" <qiuxu.zhuo@intel.com>, "mchehab@kernel.org"
	<mchehab@kernel.org>, "james.morse@arm.com" <james.morse@arm.com>,
	"rric@kernel.org" <rric@kernel.org>, "harry.wentland@amd.com"
	<harry.wentland@amd.com>, "sunpeng.li@amd.com" <sunpeng.li@amd.com>,
	"Rodrigo.Siqueira@amd.com" <Rodrigo.Siqueira@amd.com>,
	"alexander.deucher@amd.com" <alexander.deucher@amd.com>,
	"christian.koenig@amd.com" <christian.koenig@amd.com>, "Xinhui.Pan@amd.com"
	<Xinhui.Pan@amd.com>, "airlied@gmail.com" <airlied@gmail.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>, "evan.quan@amd.com" <evan.quan@amd.com>,
	"james.qian.wang@arm.com" <james.qian.wang@arm.com>, "liviu.dudau@arm.com"
	<liviu.dudau@arm.com>, "mihail.atanassov@arm.com" <mihail.atanassov@arm.com>,
	"brian.starkey@arm.com" <brian.starkey@arm.com>,
	"maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>,
	"mripard@kernel.org" <mripard@kernel.org>, "tzimmermann@suse.de"
	<tzimmermann@suse.de>, "robdclark@gmail.com" <robdclark@gmail.com>,
	"quic_abhinavk@quicinc.com" <quic_abhinavk@quicinc.com>,
	"dmitry.baryshkov@linaro.org" <dmitry.baryshkov@linaro.org>,
	"sean@poorly.run" <sean@poorly.run>, "jdelvare@suse.com" <jdelvare@suse.com>,
	"linux@roeck-us.net" <linux@roeck-us.net>, "linus.walleij@linaro.org"
	<linus.walleij@linaro.org>, "dmitry.torokhov@gmail.com"
	<dmitry.torokhov@gmail.com>, "maz@kernel.org" <maz@kernel.org>,
	"wens@csie.org" <wens@csie.org>, "jernej.skrabec@gmail.com"
	<jernej.skrabec@gmail.com>, "samuel@sholland.org" <samuel@sholland.org>,
	"agk@redhat.com" <agk@redhat.com>, "snitzer@kernel.org" <snitzer@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "rajur@chelsio.com"
	<rajur@chelsio.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
	"alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
	"joabreu@synopsys.com" <joabreu@synopsys.com>, "mcoquelin.stm32@gmail.com"
	<mcoquelin.stm32@gmail.com>, "krzysztof.kozlowski@linaro.org"
	<krzysztof.kozlowski@linaro.org>, "malattia@linux.it" <malattia@linux.it>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>, "markgross@kernel.org"
	<markgross@kernel.org>, "artur.paszkiewicz@intel.com"
	<artur.paszkiewicz@intel.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
	"fei1.li@intel.com" <fei1.li@intel.com>, "clm@fb.com" <clm@fb.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>, "dsterba@suse.com"
	<dsterba@suse.com>, "jack@suse.com" <jack@suse.com>, "tytso@mit.edu"
	<tytso@mit.edu>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"dushistov@mail.ru" <dushistov@mail.ru>, "luc.vanoostenryck@gmail.com"
	<luc.vanoostenryck@gmail.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
	"mhiramat@kernel.org" <mhiramat@kernel.org>, "pmladek@suse.com"
	<pmladek@suse.com>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, "minchan@kernel.org"
	<minchan@kernel.org>, "ngupta@vflare.org" <ngupta@vflare.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>, "dsahern@kernel.org"
	<dsahern@kernel.org>, "pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>, "fw@strlen.de" <fw@strlen.de>,
	"jmaloy@redhat.com" <jmaloy@redhat.com>, "ying.xue@windriver.com"
	<ying.xue@windriver.com>, "andrii@kernel.org" <andrii@kernel.org>,
	"mykolal@fb.com" <mykolal@fb.com>, "ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "martin.lau@linux.dev"
	<martin.lau@linux.dev>, "song@kernel.org" <song@kernel.org>, "yhs@fb.com"
	<yhs@fb.com>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@google.com" <sdf@google.com>,
	"haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "shuah@kernel.org" <shuah@kernel.org>,
	"keescook@chromium.org" <keescook@chromium.org>, "wad@chromium.org"
	<wad@chromium.org>, "willy@infradead.org" <willy@infradead.org>,
	"sashal@kernel.org" <sashal@kernel.org>, "ruanjinjie@huawei.com"
	<ruanjinjie@huawei.com>, "quic_akhilpo@quicinc.com"
	<quic_akhilpo@quicinc.com>, "David.Laight@aculab.com"
	<David.Laight@aculab.com>, "herve.codina@bootlin.com"
	<herve.codina@bootlin.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-um@lists.infradead.org"
	<linux-um@lists.infradead.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "amd-gfx@lists.freedesktop.org"
	<amd-gfx@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linux-arm-msm@vger.kernel.org"
	<linux-arm-msm@vger.kernel.org>, "freedreno@lists.freedesktop.org"
	<freedreno@lists.freedesktop.org>, "linux-hwmon@vger.kernel.org"
	<linux-hwmon@vger.kernel.org>, "linux-input@vger.kernel.org"
	<linux-input@vger.kernel.org>, "linux-sunxi@lists.linux.dev"
	<linux-sunxi@lists.linux.dev>, "linux-media@vger.kernel.org"
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
	<tipc-discussion@lists.sourceforge.net>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Thread-Index: AQHcLZHEroQ9W2lH4EW9XJumD1KlZrSqNL0AgAAM8AA=
Date: Mon, 29 Sep 2025 14:39:26 +0000
Message-ID: <85a995bb59474300aa3d5f973d279a13@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
 <20250924202320.32333-8-farbere@amazon.com>
 <2025092923-stove-rule-a00f@gregkh>
In-Reply-To: <2025092923-stove-rule-a00f@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.85.143.172]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C7D74140002
X-Stat-Signature: nzrkas8yubazp734iahfhbbftahndzng
X-HE-Tag: 1759156778-458987
X-HE-Meta: U2FsdGVkX19/4/4f3qzZRkqSAvw580SKeulbe5CPBBkmW3HQxcw8CCW3S+E9NqZip/VBhPxTInoehTrS9ndbHYz3JKxIW4+z5HOy6o1oi70hIjKKOLwc087r0a/cRTV3U7wDxQmxU9sgvtSRuoF7++X7daQtZB8uD2LxAO/vISftGmFgWoRu0ms5JgxUy1Gwpkz2lDB/pg0FoQ6pG40Gxb8AugxNFfY31zWF6cS6wuDxcfKXwRsSAhaSTmzDNpYrt0jZ4mSbhe+GU7tbY6THIiVDPl3HVApnUtHjfLdCOlJu72QhmQoXGORgQ7d3uQppoleTcNJuC15wDMGfUe/1awY3ph3BqwQSB/3efiQa2vfh5xvbtJFf5vaGoej2xc+mM93O6NtRP4C4y52DtFPq2NQuXy7UCEXxZN0Kle6QiHGBHgbnfdY+Qky0EOViHnCaGNPgwcMBctFgB+Ou/nIg+4gBw86AejUGF/0OQ2LX+nnzQDDVgMdFI5CUSQgOFeoCF7Z9rSRjE32zA9r0/qpnWebUybrhcO8ragLdMxxTHYNAi6m+Y5oroHCX3uEJkQCGCE77zEwetlIsB+yab5gm8PBfShO+hezI9CyfKMBGhdIfEUI/5AtQRs9gFIwGZ+cwnJCfPb8/6UHngdNo37QZYAz0XlSw8qwN4/ynrbtoqFKLomntx4WQb8khwuZYrFIH+7JTz+Dk36+HpgvNbqxfh0lx3g9V1jzGZp93qSvAKQpC2qAHwDGyyjU1gQ8Fn0MGCPj2mecLFSHyOgf85jGB4vg/Wn9Y7vO1ll8hhVjpeC2v3RfZCmJ9kpepYrU3CLpzw4L1xx1k3jWwI1yViJoJtRI9+RoVvlLt2Cn6/bm56Z8emElN9ilGhQFBHDKdxneecu8N/RxZRRZFD0mJMv7H3OnnVPDmoXns2iK5HCNuSo7/A9u6kvU9gp6dq1q7/s0uzq/YBnQxGmSuKIlOzJZ
 zv97PX9w
 0r7T7+aDtKpxE/Gc8zNvIpz/bs0YKx/6njp8Ge1F/SBzelp54UWbIU9qIJkgHZfBWk9w7V/tKIx4eu+E310Q524ri0pKhWnmnUtr2jGP7zAkzIWJyZryYxAyoEvf6j5cEH/s0gXnu9CDgPdlfTF/kZCe+YcSzDwei7DVQL/MKsBlM3UAJsoNi3IrxrOvw+Bv56HEVgf8f1g90kst0uNoGo++guu31oUcj598d9BftwSZlhEyzqBBY9nDSlNv3EUasbJ80ojsMnnrZI5WWx6GSCf3z8hQtZfpg4x47dwyn4kxuJHGQzobnsX+FwJQZry7RgDXV2Y2zc26iozIv6QkzqP1iUj93dAUlPnzc78HKDjlPd4lD5a1XwPEI/Dul4ceFO/KujQPJ2VS+3NOZhb6zR/gvMk/yH9kUWetFadE51eFd3tJ40Rm/PQoDeQN38mMPFIvgQTTsl6Vi/0HQc7AZ3mpjfMJMsz6zFUmafdQWdhbkB0sY1n+4f7r6xTjF2jLfsM2FkWRVN6oqEe9KvDxrkqpMoEojeVFqchMtyunSKLrkqrpsEK/kfYPslGbNZ1+2jhk5YkuIZPUSl6Phh3Loqd8Ur2h+B2NY7cpP/OLbrbP4Dj4MneUWG4uyV+jNfqmbc4X12wFcIJy8ZOUfCyW0MOV5b2NafZ2mP5iUuNhEynMDmJLWtkqzoa0bKHoukTWaj6LMIWaTT82xGDOlCnpqd048aBkvjQFw80utCUqsaQUTGiBT+ZPvlEzzYR3cQUPN9vnx3EJQEg79s3q1PZcvIVh8Mr/krwLfYit8qaz1vL1XhvmcDljPi/+NltBEqqvizkaUYfyj6P/HM1E4X0lvk+YqZ2+kdcDa2QDXx0Jt1MW8eIDxEq9qb50GFIaICsW4ibeGE/xxF6QUb2DRi6szwYdoQ08DP+ArT7gFzynyxOAH6nliEZMYdt1Q58SAiBVlu3t9eAhgPTZ6N2kvw3MdAjnm3Ell
 LIK7e4qV
 W4s5WLUWwJcrQXfEUwbno6YQqUsRhLeNtHORh+E/g99MUbw2+7GonUE4RcMMKUNuzK/sZqIsaAtLLwtWMJRroFyzee+diWbj0Y4B1bmROLGui4+Y5PetTtm5YHGLMmCS2d0Ft/j5jvyTAxi7pObR4m2FnBQ9alR5dVVNP3t9GWJuzQxX+pl3QO4njaJs16nHtWn7K3rh9HbXHSvB6IEhc/mZFHBZxv9Bc+2R1J3OWJVnYeeK8jT69Z7xVDPYcVevKTIyuU70jtwsdiwXlu0UJMfN6U7WvcVIdQ0Dw26EkUaQTgIbbxUtVwpqb5D4jTF+3ufWOdk3R4xVKS6d3icHBAqRJKvzT1RpLeXAuDzv2H4BTa2mS/hXTJ4hJmUxEHXMH6tm8VdGoWK5lBhidlJ7IwJ20378I45EICAQd93FD3VVbf2ndbZYMSteBNGurjsWutdWcf7ca0BsGl6Zak1FkV9bqyVxH7Qe1oWp9CgnSj5GvBEe2Bkf2WpPlNsmmfpJTLN9OGbnLsE0IiLimkrm+aHCqmzw5S2BMEomduHLA7zI4H+R3uHfzt96ECczawUfEHgp+ytKZSo7XBVZGvDpwVVPr69mgR2KpeXhxDGg3mHTk+0w5+cgjLUa3CrUwtMjk2EFBnpOMiYndYd/xDyH4vXFi8TfbEtREjNvYptYNmRnCzUd0y1Z+neJMk8kaBaHj5O8R9v6hWcP+Nb8hcbJChmjWJ4ewM2VyecvIC5H5F+6HoDGJZJRzS6ofsZ3LM0RN2m47Gdb+HJ8JlI7nUh1rOg/vIWlNcmntSgAnKirwFiBT+2PulJNBK7DBsmapLx9m7SVmLjtO+nFPQMTZP23u8nf4WdOUltaNU9ol6ye6ZowOCoabPK1utNmS8PyuD1ojA+ORHav0vpQJ7fdsOwLtc90mWzfPhJ6j2OhM+rL/YiyAkyIOiPRsHj+rDDbUByl9+0CtIsNVV9J09zuJOvyyyUi0KgsV
 Dhn9fDzn
 ngCIHNR7vNYNEPA6EHv47D4OFayqYPIGXFJVrL2WBoQ+SU4G+zYzHtwWDHeQgMeN1yJHhPsSTQzLO6zxLuztTAqes59KO/jOaSsg2eh7S6m2/gcTTJopcbje9efHZbYnIJHtnzuGW/ZPCLzLfzzqJBKe3VGD4RUCCV7FKSg+y1ujck9aje2zZHApHoD94Yc5MqN5uDtGczd4g2jyOuMesrfbzmkSsjJudYOOVMyUIT07PW5mvK7xSi08KjoloaKT7GW7NDDMIMS2e18bxW5ImGh8AdObE4o5KGQ9p/hXqCcxxo3DiwlAeb8xUh34D45adG760p6au07F0bVtbS5pJcwtmWyB4seqc4TIAdEmETpZ5VGfMI7PRJXPMsEHQmLCWtOSUk5yz+5KeiPEs6sg31eEDAR5Iyn/7O3f6rm4hboZOY7zBevkCcunehvE36hMP3n8YN5IYFsqfldcWajk7oV8A1WTh4J6wucQHLDPptDT0qsgyhpYhVBNDvveZEKF3lq3lokXHB2miFbM/6MM6Ma8O6PXJRtmmZxXseZuldMAeXAbFUtHB/0Wi80Gtg5eCs5iD3DlshDL5/2JKaFRvsaeStStGIjDzwsLh0QCsZiQ0J6nAdSNVUDXl9zyyqlWY10DRpEDfaQD2ymjmDGpNKnsnbIyWjo0x3KSj1po8I+fVLTwyGj9CRVVNZ3FO9TCFIGeq4Bx33fcBepVkQWLz8hd29EIF1KIyMvThO5cbd9xlKxBp5o/CdgR8VXBsh2lDVt3J8Cl/9jOnIj3UliP696YEf7Ua51wa9BrU7gQFo0FQ2pNJ9LdfF/qTqVrgI+DPEvGv3E1Yg6TiIasyKfzkSkCCqyp8HywipJYFXDuBgrFklrDleucPiZtOuIq+esqmHehvaFiwsSxty9bzDALozCqUCsgLtIFKIiWZoEjujFDRoHkvvHflQTz5ACnQRxQ7OKHO6s3DyGNFuJKAke1XTR4jHOry
 kRfdKbaD
 zo40Dd6CY9zrC8+f9unIsQc3ErdPAbDJrf3w5D7cgmJpgEGCxv3ZH1iVBKsWezgwn7iY5CwPQowXEgMSMRshiCMB7Sqzsb8H5IRB+VMRc8B3wmgNNDsLb2eduBWbrKCLCdxf5GchrCfyix2HkRTX7cpGXX2pgmVXaG2/lLs4sRG6EFDvIMIs4jprG8Z92yOa0r4rw2v44vw3Amcz/JZcJwfcwEWCOW9/gFFmqMBiEkz+g09G8q3s/LcDN/vg0YkWt7Flku17vK0OAoRRJHjsvl+sW8OPbf43ksJdqNKgmzHVAPCJ6jLIGxRgA/PQdwmQmMRm6O6DkR/aiKHqM7gSscl7kWUObymss7XUbYfdkc1sGr5kOB/TsEjhNZYIQ4ukdN8UiYdhXYh/fUndY25a7sKLEqWh1MvncgONMIzbVTSbxdKGZD5QLH576PgOV9lyLIwEk0rC2HbVhXXbMq7NqcXdP5eikLN3oEJV8mpPKmNfEKEs3goK4kUemlGjZnSCEqNfiOQXg61ECZv4CJVqmj/Rw2ma4elzYKtMaRr19VLW2ef6TAGawImJCG/eS9vmrJTR9+lI9SHPhSzEebSJQxSvyU6HX/IOEdr3FCkOAUVheuDBGOleAY5dMGwGT0FtTtmlN87/wd/DYaBlnbPYjAemGnAe5xSarKt0iLxrzGFDaTTXN4VbjQxP1pEvdxa2IZaTMDuJQNHNuCzA1Oq1qHl31yjD5qE//JGzfcK/J2ApZV9kUk2mCrZ5DeTiO0uNX5mYyG9Htpqt6OqN4aPlIsWqY6RKL3EgHbstUxUzxGo4Ktg3wpnEJndBdFNfSoQitQf/dvh9OA+//5/1ZomzZK6k3cwKG0zlB9z8n+wqI4M1mjEQYj2vWp+lxSn8BKzku47TBRPFLf6qDjrY2aBtl6byccP7OrTkm9x6QBnffkHJNPWt5PxJbDJoKO4yjVJWhRMHdH6rb11uBppX1SyVh+ve/ANSW
 S3vF+HOr
 nNxN/ybiV+1WQZbNypRQZQ47YvPR7G6M7I/ESB4tdaYHyITU9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Wed, Sep 24, 2025 at 08:23:08PM +0000, Eliav Farber wrote:
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> >
> > [ Upstream commit 1a251f52cfdc417c84411a056bc142cbd77baef4 ]
>
> <snip>
>
> As this didn't go into 6.6.y yet, I'll stop here on this series for now.
> Please fix up for newer kernels first and then resend these.

For 6.6.y I backported 15 commits:
https://lore.kernel.org/stable/20250922103241.16213-1-farbere@amazon.com/T/=
#t

Why weren't all of them picked?
What is missing?

---
Thanks, Eliav

