Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23D6ACAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 17:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488E58E0006; Mon, 29 Sep 2025 13:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439528E0002; Mon, 29 Sep 2025 13:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DAFE8E0006; Mon, 29 Sep 2025 13:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 160AB8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:22:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ACCA2140435
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 17:22:14 +0000 (UTC)
X-FDA: 83942956188.01.1E9FD83
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf03.hostedemail.com (Postfix) with ESMTP id 373D920012
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 17:22:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hlC1bmAP;
	spf=pass (imf03.hostedemail.com: domain of "prvs=36066c2f1=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=36066c2f1=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759166532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKvaxmrs9uqyIGzbajJ1O5Hd1/ndu7xAtdLZV5bBh5k=;
	b=3srn7xsE1bbkPahpuN8J3wGHQ2MGuIBzBgz9qdLucESeSs5MKhXvL0SdKnW6CGWG2aRZ2R
	wQIVI3rKYf2/oOBq1a9Q995fbvjTFzArs/o39ikmT/HiGQkIdAuLhv7Z9HL0ebROy/FY9s
	qalGqf84++/2NQu0HthAWtZ9kL1NaCQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hlC1bmAP;
	spf=pass (imf03.hostedemail.com: domain of "prvs=36066c2f1=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=36066c2f1=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759166532; a=rsa-sha256;
	cv=none;
	b=gO+nds2m1mg2wp1GAQ6cK30uUbq4NFxfFCaqLcyiihsuMpXVXSNj9umsNJfVSlSTF+F2vK
	hcO9vkxt9tRKesj0Cr/dTzWTHhG4B5XEaRoqdyVgkG0zPOSLtmEnqct47eJTfAv7cSB3p6
	fILXmObt3wBV8jTs8uPYZt0avQjuDz4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759166532; x=1790702532;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=gKvaxmrs9uqyIGzbajJ1O5Hd1/ndu7xAtdLZV5bBh5k=;
  b=hlC1bmAPHk6t8ey/CQdZUq0TvsAOPMbkCQRdvtutr6l1tDC0Niq24dws
   Gvh3UGSNXXYHPhdSGkP0tYxB+B4pbrLvOfg7lXiiWLbQmJxx/6XH9nj32
   283Sxz/pafiKoSfKAXkqeELngBdIkuD+JJ2Kf/FXpwQTFdUpsGwTvglZ2
   Ot8XOYVWXuYqcBbcsXjcYEv6fbVqPSXsQSqg+7AWbTwMWzG/yKHxI3U8C
   gyMy6fWu1XyV2O3NmFoS4ajjrqS7kVl0PgCmDhsMczhsFNbUKVCTRQRU0
   SNHSYwsZB2LhaY6yW+uQFvM8ouik/brgyw1iDZnPNBxCFFfwn8epEhjtY
   w==;
X-CSE-ConnectionGUID: IafcEd3hQO6oGZOiLnLKqg==
X-CSE-MsgGUID: Itl7dVAmRv28mSSF4DAfeA==
X-IronPort-AV: E=Sophos;i="6.18,302,1751241600"; 
   d="scan'208";a="2841710"
Subject: RE: [PATCH 07/19 v6.1.y] minmax: make generic MIN() and MAX() macros
 available everywhere
Thread-Topic: [PATCH 07/19 v6.1.y] minmax: make generic MIN() and MAX() macros available
 everywhere
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 17:22:02 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:7433]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.19.222:2525] with esmtp (Farcaster)
 id 39c95fb2-68e2-4279-8b5a-834631637cab; Mon, 29 Sep 2025 17:22:01 +0000 (UTC)
X-Farcaster-Flow-ID: 39c95fb2-68e2-4279-8b5a-834631637cab
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 29 Sep 2025 17:21:59 +0000
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19D018EUA004.ant.amazon.com (10.252.50.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 29 Sep 2025 17:21:59 +0000
Received: from EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d]) by
 EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d%3]) with mapi id
 15.02.2562.020; Mon, 29 Sep 2025 17:21:59 +0000
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
Thread-Index: AQHcLZHEroQ9W2lH4EW9XJumD1KlZrSqNL0AgAAM8ACAAAMmgIAAKtlA
Date: Mon, 29 Sep 2025 17:21:58 +0000
Message-ID: <e754fed7d53040fb92e1ef9b64c64f6e@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
 <20250924202320.32333-8-farbere@amazon.com>
 <2025092923-stove-rule-a00f@gregkh>
 <85a995bb59474300aa3d5f973d279a13@amazon.com>
 <2025092955-module-landfall-ed45@gregkh>
In-Reply-To: <2025092955-module-landfall-ed45@gregkh>
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
X-Rspamd-Queue-Id: 373D920012
X-Stat-Signature: zcqbtch7g9b4q5cm359aunywrg4zy9ej
X-HE-Tag: 1759166531-420498
X-HE-Meta: U2FsdGVkX18eghCLitYEimCUtLj6t3CSAdnTHr07bA62DNDq8rD26DU81cr/K1ZiKYhooFqPGQf1O8VmlIHuYGQM80OVbqfky7rk3UNSQ4cmEaIWi6hRTLdE7JAeCNeukQmxJwhR8tubJQg36CHcAp7phFWTVCazn7a2d1h3RRLdX3O5L3f9MDuqMHImqO1sukEPWiG66AEcjoBx6UmqfXtE89Lw3/e6/ZYqaM7ik+d+2wzE7zOH7fLjuA6rKcp+N4vPOomw32RP51AvYZk2NkL7hlhXqwa8tirLEKunem8a+Aw7VWjA8JvPdVE5nXSBoOd4jS+r9e172QKnzPsogMrfXPrdI6OnD0aEHriuyzcz5DmU0XHwrUuiWqP6m+YimySvbzvFLDUyX2Jc/TXM3gtAr7a0+WbTU1jAnQl2qz3HA7qQttB1V0lS+fCz1Ci/pv1Jv4B9RhKhTK3Ygm9PKM/XR7F9STOkcxnta41hzXYygNBDRl1225tRNHzt+4t6d+4VpDxzWSOUzkAA8gYPc1hvXN3xrUHfk0PO6bPEh2kzDu6VKsrmAV5xAB/OrJhIMZsl2OaKkmW2E9FAAyA6AKOVSD3niVfX6B/Ojul95pOpZ6V+mLJvYE4cXl33fdoJEl4/ONL5YIwFG93xxEsVZY2E6+aelp0QEV70QAfKtZzkpgWAnTPo3p/uQhb5ovjjbXmDg66gtL9ZTAUTezppqFm51CzCRJwRY6HoKlpxkKBFfPt1JRYogjrPxySibBwD7x29v3KTMABzQmbUKLvFRthSEGm3AfBdG8rFwmDcVo8M/ztmovP77D6WkDS9y5pPmEDzeEV3OSCSI35HZ/cdpZFaqwrpaAkiHpMsEAxufZFlcE3cwBL0Py86hgoA6i0YgmWdk+44581Wje3qruPdTbIZt3l18yERxnRYAjbBHU3UC4Y6YGq4rGnCLqpqz7xKBLkFeiUE5sBMGVLBAVr
 ZDLnP0Dj
 A/u2ixqPufOgKs/OJ0TJCOJRm0ClmGd3t40bhZcmPcIs2IRJpwxV8U/JOg1PzTdZsExdJd3yiBHcNXQnqOFmETHyNhk/KcY1nOrU5getqxpy9cWVJ0CguyyVEPu8yIUxUxzpWG7DFkdTTwwnMQR9qGTd4JeVKhvZpkTALF5XGSCApODpbBhyHePjo84gF4mh9fu25D6tAlO+NlAhuBBComASVQYmpdiWWA185CPHdyPYhZHNV31DbAMNMDUCN/segrk7j0Qry7hdqUGbQqv5/aaA3b74hd0mWPJy+KddKdgMRZa6+rM8QVIbGYhEFNS6EO9591YGyjg6u9Xgc0qoSwf3OQi2bE7kjeyN43hSnVuXAVmhQGXi9XwGkhe+sOx1pKCN7fZiK/NZIE9r/g4gdXKjFdK5S7bweTC9Q9fHX6w50D9mnuGPpGWEvUk//GqEIOb+rpnXNtaHG1QskuZOkhy/nUIY8kXdIinUerBvklOVwk80vryzFV4issNpwCZdMCaRaBkU/Fq8zDaCbhE6USLkeKj+D2IzMyV2wMTQEV/CMV7kwv1NHeeikHdXQavjzmKwM7i/hS5ezMu9zR3r2joQEFIo0cjZBJA+SCykmHe68b1g9VJSZ8nOlHGt1KgQWqiv8SuxC8IAzTvmNSjVRLW3plyA73+n2RsFS4Tqc58ny1qiZdX6HtuxsIYb9YLRIuKO9ySr9+Zu2ue3NKSkzbybuio8ap/9vYvsIL+O1TZlDoSMs3QEGLOfUjRAiRX86nWan2h+fDLNj1gv+cMg7qTFdea08JjAmHEprdRqP2TehGTKAra8H/Gtl+hbPtxd0niu8kbA5nTp8QRkPC83cEwRGfVrHvG7t3o+va1azgelmDzyEud/c4Ty0Qz48l1lUIeHo0r86BlnVHwmmO8LSItfz5MUvFyx96Asvsh4vkPzTFbm7xn719D4CTJncmrJIfv++CC3drjyFVzqjD3QUamz4m42B
 dOTI/OsF
 f5AhEIom3W1uy7S5y6wWxK6vLWYT9tXAnr7JtlML7MQef+iEXRsjs8aYZQYqe/zm2cgQNZIA/4AyFL2CPJAkWxYZavzvwZT3S/UbypbUk3cKkYf5mak4MmJXEAEfM2xH5g9gBSz3XmPtM8rRes/LR/3cErhS947tmg1kQPXvo34lqryMERRycjcKOT59DOHsHBv+7y0UnbHTN+i4hg2uQWyrnXFj9lYDKLK6IdWYXQ6lR8D91I9OC1VWhkXmxQWOTVFXXnL9FUlieBQ8SlxChxp1FdvWtXmEEpbrJynFqET/r4Pl+yjb0qSCr6SrRxfJ7NcFfYmrfbTVYVxfapKRQmgEnyodV86nO1JltsUipdIku/zoDkvpc7O1sggtK/E1NItpCLgA8QxU1WZoItGDqXbZ0WEj09XeqAbbX+uujKwIqTTEltltkyyjbkJ5p/ntVWOI7B5XhtJi3LPxAAi3PceG2RZJmYZ8FBPQOupXWoMNxmn9pda2va36jPUh/p02PrxGY9qumtt6m98AK9Rw2EO4CKfS3Wnrh6C+QWFsF4/++mK4JTG1FLHsa/968SnM6yNjk0Q4mooGan5MIw8BTJ1N692dFg7ngQwcO9dLN2wyUNV88D8U0+I6+09qLodrv2MIQ/CnjqWwKuahh0xI4cyQriDXIlCAqQvbrmuOAa5Iw1rluIWOJG61XEK6C2aeLqLAfuGReVnNckNFXbiNHB6J4BSic0q0CBNjsNaFjTRl6PX+83CPXp5Ybjx57MzDL/hRJcQVm456pDuebjCsax5vmbqVG7eh32xlQmN9ecrbgNVVkDPS2XqsFxJ+u1WlZIKDBwBrejppM+JJf70ciBflAoQZn6Y1IqDCl6G3K+fcBonZQIw7K9iNqujXSr41zlestpZih5r/ekowXYS5qFewdYeTi9AqL9FwCFmdoR1eQzRcl43Ob/vrfZCR1Lr8Ab1G6viysPdOzlQLuA11Vo627FrK3
 Oehv5LJc
 C5QNZp2Obiyr99An5ky2XYBA3Z6N/+fsossIn8krGsMW78/nlobNHLiMZ6UnDK1D5skPVl+mKqD9zi/jYIw2MqjXgqGO1jkOSYMrSNunnAnPL5uTi/DyAnH7vzqscIdhPM1xYW+zgPez0qUQOWc5cPWBEMDdPd9vr7s+2B1G/gy0qUyXWn/Og6htlKCfdraic9Wur5HeTA52+X6mqF68D7nKf8BJvB9aKWhS2EZdAaCVf5mHmF805fYOQPTgWAmrwoiUPgs4REF8Rd8gfjvEu8LLhlwi8W1samJszyr2X+ZRDO/wG5JyfdTDeJMWsF0m29yZdXNmtoqn3i23KXODjK4k/CVwNse01hKsVhufrvBKSLrIUuUGjbjJ3Q5ok0ajyvnCTa00uHx3uHwJPxEOYNrBGcURtalDCcOb32Jz7mWzRORvMhw8WSvCER+DIpG+6dKyaKTuQaJDCGz9+gSxpoo3yC9jsDyBZHBdJTX7UMhDgCjcewU53AOJn05B/n2cFVNUtC9QNYnlcIOGSD61tzJWnw7R/2zZuYZ/jRIsoKLpwcKL6YkqKENu8/acUp/VeGOcNVMmatpjTcXn3kDt1xNYXPWgB7STpMUZxBoqSWLtm/z5ZnX7Semm0G/Nw48LmbfC1sVXV1M7Pe0Iox5DIbdnPxYKCTx8fffJgxpuRGOpvTtS67zg5Uw/Ky5sUN+xuSs8HQJH+oQVTju+3DVxAUzTkTCP4uBvcIGYxQ9/P5zFzK3BO5WILzl9rPtVWKQbjhwJjBrCZvtYb1iRDQzMuDiv1By/mW5uJiIu0xjDwo5p/gww0xNx23X2hpYI1Lpe6rmiSO/YwxeNGtruX/XEEd1G0qvjQyja5LuNMAcYspppYuFp9IBMtKSOpNR8o2ILDSEi4H5JSk9pVaC4ZTeudFiI8px5DOjgV0LGJQZsP2BFJ+7LqKTreAkmTidA7QQmiAooLwJ78OWBJeQupTkjB6JT+bPgT
 R1CFaAfQ
 cTy74e6YjKCcjDH///XDuHjj9C08JwQrQW4UtzdAc8aXtsPxRbFWu7G2FuKqKWDr3yJ69+PpeLkDHhyYnmWyf3RXNUqekJ5aFV8hRJD1IJx4HmV8HWGUrDqyC1aGIjt57p8y5oSA2X6kLFP4Wz2kcITO4oIjVZxI4r72/MiInHXxf7KpOSGn/XpHYLVdVuP8L7L9ZsA03JLcQ0N3HeaCB+SCKWHwTS1RAcEY47cdW/n4IlOBpUvtWz+pR2/d08XoOABjfyre4FRgD38lXkSXrPlUpM8MOEQa3oM3h/FdocYWydSswM/j4cNQqCKTOWMNDbOfKVOo7sXr6zpXj6d/ONdzjhZZXH6lWc3j0mmGVLhUlZlOcpnIe1Thb8OBrGoKzJ/kYrEH+iNonWia3q6Ta17wlTkOmmxPjQZgZxHXZQvqPexbURwffTCq++qlMdlsHT2BVruBm0JKRzu7Bt2f01YjzzifsPCjQfpQ/qOmx6AkW8SfviL9/0LcsG98817M0yDS5vCv3wqOwRe2FAyknYNBdpz0IHHgrlI/dvBOePxy7G5reQbuV+Qo/GeSX9gkrCjABgaQnzyif1y7BVix6/lKEn8V6xPhWegbr1+jeKD2Q+aVXy77pfaO3+6rGDLcJh3A49Lt/110JvwnH81Z2zN/UXDjwzRkud/ZFdON2MYuDC620pAVzvlude8dMbZx5JCIe1A4K59Ru+nkmQ1eFr3LiFJX7NmC5ZT8jIQy7P7GbWJB9tWEVWsYWTAz3ioKdT8qnqVHpBxKXdOw/K5DPuM26WHpljAU5U3xdpDugQK+YMqV6RWS8VZryCTOEzDOVwjUwbEADL6gdW4oPvmN4b7bw2O8+D+iR6zLJAykP3DhXPj70oq1g0yUtTQRhT1STkecbgx0c/ZNMvN85rLkCxvV4iP1/VI/5Ehw4XOwGEZ3miYCVVQgMO0wZc9lkG9LDSAq1qwyz8de1/PKzmEw3WcGLkYR1
 YtkpbFDE
 OYty1OHNWvDUNgmdSsDN4ntT9vxhAKgznx6jrmUluYpHuvlDDuiskhNnHxBk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon, Sep 29, 2025 at 02:39:26PM +0000, Farber, Eliav wrote:
> > > On Wed, Sep 24, 2025 at 08:23:08PM +0000, Eliav Farber wrote:
> > > > From: Linus Torvalds <torvalds@linux-foundation.org>
> > > >
> > > > [ Upstream commit 1a251f52cfdc417c84411a056bc142cbd77baef4 ]
> > >
> > > <snip>
> > >
> > > As this didn't go into 6.6.y yet, I'll stop here on this series for n=
ow.
> > > Please fix up for newer kernels first and then resend these.
> >
> > For 6.6.y I backported 15 commits:
> > https://lore.kernel.org/stable/20250922103241.16213-1-farbere@amazon.co=
m/T/#t
> >
> > Why weren't all of them picked?
>
> Because one of them broke the build, as I wrote a week ago here:
>         https://lore.kernel.org/all/2025092209-owl-whisking-03e3@gregkh/

Fixed:
https://lore.kernel.org/stable/20250929171733.20671-1-farbere@amazon.com/T/=
#t

---
Thanks, Eliav

