Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59B2FCAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 18:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758B88E001D; Mon, 29 Sep 2025 14:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FCE8E0002; Mon, 29 Sep 2025 14:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61ED38E001D; Mon, 29 Sep 2025 14:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 527388E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:39:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06EA41A048C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 18:39:10 +0000 (UTC)
X-FDA: 83943150060.25.4AD96E8
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf12.hostedemail.com (Postfix) with ESMTP id 705D240006
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 18:39:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=GqCLF3WT;
	spf=pass (imf12.hostedemail.com: domain of "prvs=36066c2f1=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=36066c2f1=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759171147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJ7eD2nV/4N7AIUA9/+6epf2vjH4s0akBoFco89HihE=;
	b=8HVwqB4RQdzEug0Pm5B0rQkyE1lXcfrLPd/aTbL7nhggOss6hahOt4poiQCBViLeicuAyM
	bAmfKzK6P+5GJuiwV2uZSaVWQkero5YpjrSW7sGUrxVTjtcDhde6jiRBFf2EkeK79jSHSP
	gPgG803p8PiXa771od7CTM/poewL42A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=GqCLF3WT;
	spf=pass (imf12.hostedemail.com: domain of "prvs=36066c2f1=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=36066c2f1=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759171147; a=rsa-sha256;
	cv=none;
	b=YRJ4eptuDUG41oAexwaRRXKpu6uJ9U84QBLQmUebPG6hIGOhLqELI7QkST5glPKekSM5lN
	bGJBfsaLQ9pfcsTl9q1IQInYYuXkkI6stmYTOT7nGjDeZn99iK+NNd16KioExuT4mxMtpl
	VHlj7rHORov59igUxu7BBoy8hcBKGs8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759171147; x=1790707147;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=vJ7eD2nV/4N7AIUA9/+6epf2vjH4s0akBoFco89HihE=;
  b=GqCLF3WTdg7/ZtZSFELSD7oYx8VpW98D3go/tfy1sLn0f8XM8KfSUuGp
   ldn52XMkV+17oW4ni2ikZft6zL+iJciGREwhpkyczEZUlXT3NgtY8Nd5s
   jiCxPY0NT0ccAcKNp6O1F0lZNmWxx/5gtSqA4u3vEzjftac0YM/eqUYc6
   i1Y8jexfkZUMLLWDL5NTqG3B7qdoglGiJxCqykGqj0FU0wVtKdJwWJk9Y
   ohV+7p51iI3/8tKuWnKWzIsadZJLqMIyAD/9Zcwk8g0HUYvi3mfzsLx6R
   wd8NZfV9mnv6drfS587PXJUJANpCNXLIi3wTXc7PvlFzleGCcQKGdjBYJ
   A==;
X-CSE-ConnectionGUID: EC85rEzURZ+CERFt3YJdKA==
X-CSE-MsgGUID: tnl/cymrQVqCkLCX53HUhQ==
X-IronPort-AV: E=Sophos;i="6.18,302,1751241600"; 
   d="scan'208";a="2844874"
Subject: RE: [PATCH 07/19 v6.1.y] minmax: make generic MIN() and MAX() macros
 available everywhere
Thread-Topic: [PATCH 07/19 v6.1.y] minmax: make generic MIN() and MAX() macros available
 everywhere
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 18:39:02 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:4036]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.19.222:2525] with esmtp (Farcaster)
 id a320107e-9e0a-4760-b3dc-26c5d986714d; Mon, 29 Sep 2025 18:39:01 +0000 (UTC)
X-Farcaster-Flow-ID: a320107e-9e0a-4760-b3dc-26c5d986714d
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 29 Sep 2025 18:39:00 +0000
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19D018EUA004.ant.amazon.com (10.252.50.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 29 Sep 2025 18:39:00 +0000
Received: from EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d]) by
 EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d%3]) with mapi id
 15.02.2562.020; Mon, 29 Sep 2025 18:39:00 +0000
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
Thread-Index: AQHcLZHEroQ9W2lH4EW9XJumD1KlZrSqNL0AgABQRkA=
Date: Mon, 29 Sep 2025 18:39:00 +0000
Message-ID: <f32d53131d0a4b61a7be4862c7a7f237@amazon.com>
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
X-Stat-Signature: 6m59cwu4qond1mc1mhkdjps4uqm6uicy
X-Rspam-User: 
X-Rspamd-Queue-Id: 705D240006
X-Rspamd-Server: rspam04
X-HE-Tag: 1759171147-150238
X-HE-Meta: U2FsdGVkX19kaiSnojf/Pq6ywKUb2ju/uyxez0p8AiJQ5VUH2LdaYiCUENcRwATWHKSODjIolEP5RzfMV78Pg5PwxZ1AhvTFeP2ef0eYMPx2lOKoRd15zKdYA0ZIhs5kbkchHQHI5nqKi5t7czXqOXcVmVYwJnTPm79sLXrxkymBD/fKUQCjHZLsWCiynrlHVTsKwCc5SUk6P7GFf49HR1lyaordQpTb2aaluXamWIiL+jTnKC6azF0/L8FhcYqkH5Ob+YnO5NAj2HCZSlGeJEcizHXxMNXXvaGmrYVYNu+iKn81q9qoM0RRMgpmCj6R9kupyi0+xhX//F3ynpmdi1U18pDDeZ0Sb9MhosqBDVnWfafKRA/cXbZMLIskgGgEf2HkA3Inf54TXJFWyAHlS1SAvVYuUJikZF6tpI2bnpZ1o9AH6Ovx7wE8fshGb6YY2wnLvV0R0mqu0FzAizXi6Y3MiPC0Ti29vfGo1IGDhvtDcDYxY8/XeBr0WPvBIMmHpXTf2X6JzNlf5+CXbSz049BI6TUAEx/aFOlkMcZydb2zf9P13sKb/jMAy4bObaAskI6Xh18bMA67sA5zP3BsU2/i49mZ57I5MpmgTYwSEMWtBk9KTc6kOc10v4NY6RuSsCO1RoxNh/NPVMlZPfBLb0EuSUFvEI4CHk67HgtxYpgZtiP5+qgY3YNlwAVxmwb/oqIFLSFAzqhKyni4PPTNP9rCp8rLcaJpt+rXAMGF7qxSS6CMeXAiq8LS0KpIt2JPzNTaQD51RU6DNuRZLkTqxODrCZAVaRe2e59Pu4NaViFxiokXPjQmX1lo0Sl5HJ9+vbY2sg+qRzhzkJmqosoLYTeKDaZZFn4iDGT6ycWoSJSdyLQg5bRifVbe/ZGR7Nw2aYnnnGCcFTJ1QFL5Hk7X/AjkzLqVB7nV1wMf+lu1uAhJIAtOHPHDtEgBCzNgWrNdXijmtabJjmftFgJ7Q/y
 483HOAQN
 Gj9JlV6cZpZXTZuBSQFGIdv6bjJzQ2/wc4T+2VoxjMRLCQcRzmZaZTSOtaB2+uKWs1VFvBlAmhM+NJzaPBLoUk36zZF2hZYqnESpUtiOW+sla4IzpgchxZBjdcsOwZsVlwHXlskEC4eceYmc9RNe7BibjFmeUHrwMxeJP86gBXNgvRBxnLU28Sb32WZIuTQija2ZBb/EzCavsHbLtBmm5hQhSRuRL+2rFVg6uqnlza2V24nhZBTyP+XS93LlFAlNotC1r8BRLOQOK2zHUj3kRKKrRBhR83DvgqUyqVBZ3z7O28w4iMmhOxU/40wIxkHcve3EiD27TliUmHcZlt2mer2g2/vqoxB2TOX1FyfhutRR509nQr+xPJaZMY0oJEuLFEPp/k0pCIY4mZ4XMuo/mMQwGlopXyTg1JX1htNtZl3K3+aqzd40kY1XKtC1aY+Q3sfeXt5pdmHCXGx0tvR92kW6Ld7JR810DolLG0/tDyeT2KJn4K3q3lvPkJZk/V586n+GfHaXYJJGMtyMVWdUaTU57upRMn2NnhnzGU0Eyl8h8bTOovVzEBVl6LlvWX2YyU7AK8o+/COSHiJ6qetJtq4ACV3+/MohOfzf0U5gyi46/eim5qDpnN0kDOtJUeg8kY6qosbl4woCpHtiIL65gR98z9dIfN5bV6ivgo7B3w5kTtke5HBA+32vtoxeCh4HV7mk84KeZDAR52X7O4q2k9dbiDIxha1pojBVVHG/eukdc3UkuHjle1Fn9LPSgm9jMI+zrrdl7OlPi+ECDcjFBbeJaVRm+8Mk335BS3ayBOCFLPV5HkwxrorxTGxjfgmqSDNH67gl0rZZI1iDF6FkPhdkHUG7drNZhrX3UZ6SIDpGSp2fxPBM+sZOkqo1WgIZrnS7czogYU6PBVzKjg0dDpzJCJdR08PCn8rckqNMntnrQquZTRhSypoNIItPbxbvR9MorxmsQ5kEXB/jp0bxOT2R1fC+4
 yhGMP3Ft
 W9YUuObUVFaLC/TEg7nS/6CopVL2Hb179Z35mPqBUBy7QfNJn/J3j4BhemGFQPsDKrreQ7C9ex23M8VOcQUDjTBlrtlGUcYlpRXGkSxjZ5pdXcE345l9OEe95U5R6WvTQw+0JJ1LlqBKvfQHS8vqN/MX2UYNuTi2tJ2cCt1Ouq8Y0PS5HLZb/TSdr9/QZsQnOoHO5PX90QqVeAFTkPpo9p159oZnYrqHfJWhroBPOSO1G/cFt0rminglqexqXbmCq3mENgH6hi8h0zDrXGOUV0MzR4ezR65Ip6EtHFIuSidBhKRDOS5B053XvZ09n2LtgdK1xNhuQ2Dv1hvPu6/Uktr7B16Ba/BVia3SZY9cgJnd9QQlYwU1EvoTu/xPKfRczwBLQ34EkJPD04fD9m9A+H81yueUiS31qpYGN83ekmcckmbUU3z68V9ds0TzIQHcSB9yZmjXawddEE+6T7bAYaD7nuBjFhLwBw423XiF0F1haswB8df1vjjZvKIjfyjULVk7a9R11YGQzWMLbG8pll1GbkVgJ7N+Le1lcYcHJt2jqq7WlYKghJj9X2L21JrR8Hg7WFwMaGcoIRirSQ+x8EQNKxleHGcGUaQapUrb+vOoTL2hbIydVnrl7XE9BdCDuMQQa9Li81qDcjMHAn0X0MKaXNx6M918rOo8oQoieBFYQ+X553e7J53vHy+4W5Fm8BZhi9C0GRBhogUbXHyIumnLi5S4TGVNsM+c2+wy4rOCIuV7VQREjRPX8n28SGm0i8Ts0tCh638n66Lx97r/AepTshGBx+2wTAwjUU1L2cvzHMNEg4q3J/UwSTXup8/45rB8F/Srbqukn6Pc0Ra35fM8sb89XFYmVteIOnHb4rLGCbrdMos+fu2WBmV49Klgzfsz05e1WZ2uNp+3J1LkxHnOO/IBqQ8nZgO15Ao7EsSaO2Uu1/d3y/2Aj+LoLbZR027QEE2DRNh+A5rlIb9WeKixMku8i
 7yPlkEpV
 p3XRqwBf7e7SL4Eac11dl7lcQnWpeHcMg+gIQrwQ541VlLKuVGiW8P2pXjrr+MJUwUoPOUfePcGvhGv7wHJRlUGlVTDr0xkoM3tTjdWDgv4UGHrMMNRclMuHJpbQTUBIFWtJdfDR5wA2QQL8teeiUd+cXdllynuhh9fIJO1QQDEiwa6JZri5O7lr+/WAa9INnaJi1kLhxJXY1Uo9RZnjTlL4w9egwJtO6Cf4gZVyll6Nskb0LRN2AgM4yScu24gFkhebQiG+588UxzEymBlRmb7rRv5Oz1IoAMfVNX+nSwGTjuqeGX6gclW1HJxJ2YNN07PRp+XjrrniIQa5JRR8l+Cz9vmLdyBkdv2PnHA2qZBLy44eKzdglUbwWX4uH2fs562oB2YxjeBWwi2tG1em0xRDHQGf/8z1+1rD1uR6PRs0yFO2FBh/dj5rbwGLpLkCeC+JLUaU8HsIbYaYUZUBAeJRy9BrzNVwITN64Fo0KDtQhC3+7SYCCNoajpyJ98Zdt7YhK/dOD60X3oSp1gjStfCz7qcM3LIWfNQpXV8Rbbhg2qPzK9OI5R0YGNe5k55s0YVugRN+z0VN6qw1SxUW5rpL3LRebg6+wh6svi73riLhEvT8dGkX0j9coEuwg+tvf3y9e6wxtdP4XW+MbHUrtiFwzrLN4swXGzJY3zQ98Rg9+yqn+KFcsds97umd8AxAqAmZUBrfmpnZ0RgdjGCr8vbnJZ/mx0Gn71nks5HzJyCsCL/DEUd4F5imdJnYAKo+kNL4h9tSyS6Zf4VcRZ/tbE3CQfG/aGMaUdJEzs8wCEksMlo3ZWimZHGz+8Qb7TiTSJhQJkqnM2oPT6ZF877qWjWMHFt5ZLcOtirKTjwwtGe5jgs2Ej+t7DJi2JIx4sd9/Ir7nO9JzE5JoTz2+nya60WpZQdLQi5MqGCPgUwzUtRlsszmcqfKCfPXKgmx7JhBTQMWRH8Adz2YBd7b6LVSLWfYpdc2J
 K4lku+Ly
 VMRDg8GMZDLSOc6QbTOykmcisD5Hc6Uc0Ho9AeeZs+QMNBlG1/BGFeWg30bCL/c2ABViEUQS6WW/brP+KHrvmfKbV/cSmalK+NI08zrvNmzr/4+8Dqm5Cc/hl4Ko1BfuJiT8cDlRLsjr8Mingn36pJRYMpOQkTJKJRcAiBRzNrukgU840BhArzcljcKBpf3p4O+c2ATcNCIR+lsQMXEvwW3A/ygteYGxdBw576TfM/yHPSH8yqQH66IkTKRIIDzIH4BoF6q14PE5B5LAelvRTxIYpCDLw5PXEKWk5e4He2sFAfyDihCWFgHzQT10u5RpDbgk7qEUowLQBHRR4z+5CNEpftxXsoypcBWIBQHRUHWFIwT5qajXKI93vhzfvwhJdNVagDi7nPpiwTHJAApiyNOaS0iVJKq4ALGFJ8IeclYinFst15i60nOOHUkytNXi6LT5q8Rm5HuLETOTTYrKMgPTHJ4/OwdgG9qPnXi2Dk+xY9WcSLo+XSFPoU+rdT2850gIZOI/vkTkNplu0OJctl3E/+xGmHfCiWUWwiIF/IemdVyp9/RW4GC0M5RzE+gTwZxfpzgauksG6M86i6zj2Hybmvk4v9PxuYM3mAit3MZc7AuAjiL9LL8/zpWaAV1bzNAWtR50kwXnEJvlJZyeWOniOoxWahQI8dl9ENUbX37AgtXEyfxqwheyYL5VbkzqWPVwGCgg1aiX2vQMLdyYI5ZpGRK+Dzp1wSXaj2iCeYlF2tbxn6kBh9s6tycT2PCPjBt3lJ95dzMdQLAWNmSxbhigGUfznChu4GmtafBfnP3aeb1hrTnygsl//KbF20wuSxw1AgPwsrKD4OXIK3IwMGShmmYs52nq/GxiX0klYveyauHUHT68k9ocV6hbavIKczKgy/VO+bT70mQy0be9v+XtaPiD7wBzoW12e50qmartgNt7h0Sa9JxjrvbiRk4cbYIAQWGwa5RwFhjOkupvxXa9iFSch
 T1UxZH4r
 2TxQ8yhnZRJBY6Z7wP1lhuPeYMHy7gFNCHusECJwB8Mv0D54kW+8i9qUQEkw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 08:23:08PM +0000, Eliav Farber wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
>
> [ Upstream commit 1a251f52cfdc417c84411a056bc142cbd77baef4 ]

<snip>

As this didn't go into 6.6.y yet, I'll stop here on this series for now.
Please fix up for newer kernels first and then resend these.

The fix for 6.6.y was applied also on 6.1.y:
https://lore.kernel.org/stable/20250929183358.18982-1-farbere@amazon.com/

---
Regards, Eliav

