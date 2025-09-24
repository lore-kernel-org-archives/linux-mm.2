Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7EC0CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7F48E0005; Wed, 24 Sep 2025 16:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CFCF8E0001; Wed, 24 Sep 2025 16:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF048E0005; Wed, 24 Sep 2025 16:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07E768E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:28:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D39F61401B2
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:28:42 +0000 (UTC)
X-FDA: 83925282084.25.BBF6369
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf27.hostedemail.com (Postfix) with ESMTP id 66CD740006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:28:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=fnVjNF0P;
	spf=pass (imf27.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcGDvd353IlFr7UB0Kr3owgOL1Fvn+LLqG0G/i0vGK0=;
	b=0GoTi69r4r98oYDMn+Y5458C7HgyBFjisu0McXXsO5NSSXLzWo35rVK0WjTrfvFEmcb2O9
	a/b2KblPbbHo02HLYNr5bMFDV7vGUflRpMIp3+6lmAjZnFEzjbmAQzKLNyY+GpadSOsJAc
	vg67yjTVFgG1IEpCMHHxw32huaKLBMo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745720; a=rsa-sha256;
	cv=none;
	b=IkqgWDhJ1Syf8yjrInny2c21E7P5as5ruJKcDyglyUqOA3Feb0OT1WmZ0o9j6xJPlzJept
	zhHBf6fjvIx+ijhSEw42lc+TR7oIORW0kSiX2KU6RTv3mYMWrY8sm8ydFfltCXIA3INN4w
	oN9ZXPUT2VNdhLsWEn8U8m812cAfU7c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=fnVjNF0P;
	spf=pass (imf27.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745720; x=1790281720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TcGDvd353IlFr7UB0Kr3owgOL1Fvn+LLqG0G/i0vGK0=;
  b=fnVjNF0PJCuG4HeKeSPaxvZQiVtHFPT6ogCfZno6hPA6KPSigmY6psOo
   Kf8/0VgCIaCDwP9PA59tz8tRAr3J82f1ZR1WwK/pHs+/uRsXUXyK1CD22
   Ak5aE6eD77xsL6T/wHEtzyrB8pyTeWYD49mZiPBUe4xBCjnkFu2lbCavH
   8UCVbV20g9ejnAvQcZ8LOffFG1+VcQ0sVtPBjar1xwMlGTEXS5ummQAg1
   h92FBev+sK4xvrSS6zyjy70RZlbFq/t6Sru0hl8bKsAcstpozJbO73qyr
   JQur5+JBtmYOwX3JCGFmq6Gj2eudmFpVUaAuPlkjp1MuiMN++2bDOZIB1
   g==;
X-CSE-ConnectionGUID: P1dbznDVTIexOM6g049ZZw==
X-CSE-MsgGUID: JVNtKnaRTBqg9c8/5NJimA==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2633904"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:28:30 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:20731]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.9.61:2525] with esmtp (Farcaster)
 id fc69c5e0-afa1-4757-9bb0-cbef464a9cb0; Wed, 24 Sep 2025 20:28:30 +0000 (UTC)
X-Farcaster-Flow-ID: fc69c5e0-afa1-4757-9bb0-cbef464a9cb0
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:28:20 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:27:45 +0000
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
Subject: [PATCH 07/19 v6.1.y] minmax: make generic MIN() and MAX() macros available everywhere
Date: Wed, 24 Sep 2025 20:23:08 +0000
Message-ID: <20250924202320.32333-8-farbere@amazon.com>
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
X-Rspamd-Queue-Id: 66CD740006
X-Stat-Signature: g6ud6ithso3mc4sun3d6w97gb4j9qaha
X-Rspam-User: 
X-HE-Tag: 1758745720-201151
X-HE-Meta: U2FsdGVkX1/nPP+0lJCLI59NKF7nMdh6WjGdpxJinQRYME1deXpDYKGAnqPhuE0/6Wfm0WETF6sE/6o+MuFAjx7HAVoJuyzZbZWRGJbTO+Bq1hnG7tZ1I2Oqr5r4IzyVBUi0dIIIAtX34c3HhRUeUzqGqiJj8e521Tg+Y/TNN4pmpnGtnAuidXDGbwam6oGlzhbtVyPOAmQG3GUUyHjSGp/lugjugvJLcVvMSgJU0hkjqpDuzuyCPuHBQippb3sQ6itkrXnURpoTsi9v2Klw8QBT54DGythnyNBTrsHWCC+7kY/iIHf8jas1qFqsOzAtTrvQ14nos6l8tZCsrk3V1Mqq82OdaWTv+Tq8Ttacd6lRVJrB9b6lXBzFZZ7V79HkzUGtRFlO/G7UrTFO1bJPeVa0lxYKasuLxRN1gxt/qZ4AnvF5I5dPZVQ8/hIxNLYSdg+bAUObHivU5xCxuDfxuhQEDybJPeLYJ4uZrFqjBMprgGbeKFAcm3a/ILr51U5kOnsRiWf3knO3fGakXi7N2tjrFgv1k+JvBQbd4mO2R7k1fY1WjRv1oXQv+IceLpdTx6Gu+EFuxZoAka9BqCNgPm4TCknq82fJNEr5KjH5KFcfX08LmoD9IMmwBsLZCrIzaKjewznZAxAM1vHF9M6HpkoIjj2GQ6OrPzjyxPW4BMoBmSWA0eteGxHKtRsv1IKD1gxe1LbCBjtELf9x/Y1vDXOUYqG7ace15aREbgEX6AT4O9nBBB+TLjetyWiKUoalXyPvq0KFyOKJ9ctxuqCUyjJwnEN7mhc8qVzy61OOAwGTXztB/+bjLsPow3BZ4bRvve9IEikZiTWeOtfoGyRjdq6x9FUXSpXLj9Q9g18ML1WMiHreFIzBBzZOqQrI085tiMvapyBSF+rVk0O+Q86gK4hO6s8U5X7MHpy++pppoxJd2a2BZiVHlaunA5IvEnizP8/qibNfF1yzbXsXu9h
 2W17v3Cn
 UkJvXjSKCpjxfxDtXX0i7I6aqTG+CowXDjuXCmxa1BGnNOA8j3OPGfX8lHf/5fcRl2rsC5Nn131uAmYCWm1pQd4E7cBCGq+0/4MZc+eCtsWD6OuNF7L1lQ/nR6/WwqLeEGazcFnyuIAnLG/Ev/ywEzX8lPU14baJvazCJ/0/nzLKxU4ibeFroKok4Yr3QP3LvKATX4lnVzhvh+LPtLvedQ0J3su8wvILrv1p8s3NywN4qbxWolbwkCV6sES3LoS47fsGI8XpIAzWz++Pg0wsXFTsDgdEleWwHa4sOX7OdRFd6YiIQbt4WoLzJwSxO66bZ/aR7zRfsbS+h/QTiGo6CL7wci0DFGnolwtzWv0t04vzJvNieNImEWRBNL+83Kzz9ZibQrSUun56ChghSQwlkKdpXJfiZELsrFidDSv/cS8pHLEXgFkrX3VsAjF4qLi1gDG8aox8sqJPZwVdobQslh2ywSzVGmx39paY7fH9h5L1LvHX5l9B50CW+SQo+BIS8thADrRPAj/W9wS7jpcxfuvnnPMBZ0aXiRoZubonFM5rulCzybDYmOiQKss/JIIRoUX3Lh/A8YecQd38KvJdrwSnpJNYE/dwtxzpb8xx1Iolzs+jVD5JaQenWSAobNvnYdspTYuXTw78sD+cQG24CS2xHrOK+/3aJdA0YuFFaCNbSiaBNOm1GKGQMYUauA2dGwJLGtNfIzfmFUFAiUUX3cswU9pbCfeXkUq/V9DTJdqhbVhzh/BzGp6pF79u9+yVUrgmxU2DH0pl8KPpYYmb+eZWiEOEXNlmh/dA/BdfNqkVxUs4RUmOG0PAQo9D4bQ/J6QestlB1nPg1pzsjnhsIxfkcfAfeLzhtxaa/dY0hbj9ERBjj76kFHXl+Fc8kaFCVreGa0qsth9DCz9CoMpd5p/Cy9zelRyrXQZIKJJdQSX/0mc9IrnaOiOafkIvJBm2MvaFYw5dJr0NAEmMaQT2VmhQftCh6
 kysyH1ri
 ekdP4wFuZ/7lkKpRi2/IZMbth8cRhXnQc2oJyO9Cp79HwxWLM9X4rNkzTtlO8tOv+3YNWyXguo4Khu1TjeVciCPX3p4BRuYMYMpt1tfvs2IisfDO53iSQvpL6ssVlwafYWtDIVnXHYcs95YQE7g6W3Qk9QH2tpC4lgwxUq7wHr/94lXudv79y97jQHaU+EukNOLh0Xx0xBomvkREaw+v7fFpmhdi4jUzpCmrvfV6Zz7cnWmN/B9pQzW1SNb10sbNGRrpjXkeVs5VCLuBfovnqFgb/uQRkGtGXCT3Liiu/OVIifIMFFoYV6MOQAfLB9EEejqdrdQ3ELbuRoKh0HyGZL2xVVmpX1r9uw0/sKLDMPv0vEbDGkdhkvN0ApbKkEkM1vpsTCccStlkQ4mfROQqFakV9nczZoSshMcfUMYTMmplGA75914Ue39/ECGLdJF09scJjzdcSAo/yxv5jRQIPjx6Vj8PZwq8hblVF8VQeFLyabUP9hCMycUkOO9UYVgYVk4wpv45g84ZjUiP4zoQPK1AhPDFxBLHNwelwFV3vGm+U2Ye6jYfTdxesQieD1R1TG7Ts22IpwWIyGrglVg8zTLcixK/iM/a2JSypwYrjWHGswH6LPULFHD9Ruhxibc3IB0WYZ5j9+n1O55atMO6sWan0BDYPmwdK7FF/eigPeaattsGFYjkhqtXC3Fd6zfxwHtv2Ic9KNgsA8GI03zWJlUMk/a6e9BMJX2u3D3SXdRd9RFjI6Jej+31o8SmyjBoVpwHIw15XnUOR1Me65/X+X1andJX5XtnB9ISP0Yo5vBw28wxWvmlG/NxOVF6BJLw0fKUEnAOMfJyy2LPjNwgoz3FCnhyoJLWpSCdv01kZaYTuBJAw1Uu03K5kY3O9iBPpWcqmQL9UqmDDBY0eQO0/hV0qzKVDKR0WcALH2siMnF3+mJYbbr00ESdF5DWRPcDbfVmkB9iJzRYX2yeg5rl+nWIQ/U1k
 hkKY5SVS
 WijJxK6KGjzspeJurDCNiD00lcd1/nc/HQmmslUKRgnp7H6T0V4sA1TiMmRZ7ENIU7NKv/8txYAxdKdCQkFBVTcp7wjGsmxDYUFRgN6ofo13R/YebZ4X9ovBuO0C/IKfYtdZICo0c/o6vsXjS8Ny4ndqyIqoTxCkXlps7QYxs2zRpu0oz2zBNEbyAbTScNhvyKPZLoNVDu5rRsSaqnxqA/12w6iHFlYhFzUMrlAw8tFvMkWX+wyOjvZhPUa+uIjKa61feiqLY8mLU2vlGNHIXpxnizHc4kIBb2G9E4yYy6kPsvjdA4r+NnT5e2ECv/UJd2ko+U8N8VoqXDmU/AGLft4YEqm+Hw96dwv2OoQBjc77rlkrsgWboH+4uyi2+YSqu6OaQDdqcsfWsqRM82USTXM/CwVcxj8vieWpIzLn3A+4k+cKNKBGdzE0ApEdewh6tpgsxqCCf+fzke1VwSMRWd/IHislmcmWesDfDxsAGpJ7Zc5/usE0Icwf/L9J8snlwqWt6SVKxQU4avNxjT/W9aLp0bjjmekinYTK13Zd6MXHZlkdMLCs6egzMMFHsvwDiM9b2RTaJ2nZmb4V+iCDJsNYqr01HPq4MJWau1hQugGsP0dzy8M8SYQXX4f9tCcg6hOiqFA3cpbYJSwX2BjnU8CPIvaXbmp9HSsNvNm35hvNk2MOVoVIaU+hFHlz8N+Pd9JkxAhdHqXhChnNPKtF/tCiBBuIrmNw9A8ond8pAmgUkZJi4LGwtIrLcxOol7vlig88bY7k8Hn1RY1ZIZG6KmAxzzKkEOjFlAakjHEkcd+8Y9MHE5+J+DCkCOFKoz0EiYq95frYQZx6+htdpzW95HWcoig6i4mJRFuOou3EbCXhNDEV5pabCZqAflcscA9EnAkA5mAEJ4CtR1xqYrq5oCRMF6e6ALn8EV+AM9B2zLnMCZtKA8M5YO9yPyAxuoMqlsTirP10bzAuyy8ye1rFHmrEX2LiH
 ReRdSfkh
 Ybqz54AmTrbvg6mLGp6u9yHLtHL12kreCczHfgWIf+xVSgEWdN8LFwKVNU81X/fwYj4hopsk0rLwHRSxCc8i3/iaunJUfVW6XvyDpnC3+BdSaU/3viLs5LA6k2GoskbwSTXCFjFiJG5Gm24s7Ael0ww+uZn4e30EuvOc1C3rdPtT/73M0H3GQIW3SBK3FJ2n+RdANcDjKDurkjme25PH0mT/0SHwraG0In0xNkE2xfsykKULI7nxFM43/GH7+V0efRKhJEGz+NDyalA0X/mYXSGkSqtEAO/nGxCtwg8W/7WBEvrG3I9TFT4SnEFmqghGmn7a8F14e/qwj4nrsR4g5dHSFuPs4sGgMzVBQvvrA5LirEfChkf4JHDv7jl6Pfw9E1IdhWRH0IO+MGV46xHbmouSQE/1wLvjxxbXghWW4293usChO0vWgBHaZQH6qNEWL3ePr9H7zXpZaCkZ4onQG6DsryMkErC50nniP18USeN91OyBuyB3jOOxJQOqrej54CZsorgRYK9CMBHn0rjhiv9SqjwTWov1Sz0DE5sjoGGwcTclzLzs7LcEqEwDZodnt1Gb9a0xA4g+o/NraPNoFWG5WlHckU7Tq5FQZZeXM1boXWgBQBn2/cPgX1dxK0Ba7c5v7UoiTmbx8+OctthFTrPq9aTHjHn/OsdakSfeuBpklhXTFaY7OXECFgMKdorRb4ZM2CP1U8/Tj8evbkh6cbraSvCnNakb/uyyLVOhkBVPRHXjKi3th1UNBEAuAQq4NRoxWlzGLGYRVif5pRJJ0C+ifcfOJEe9dngfVAkG29AUPRkOjhulztZBn2UoGrMi406WpLnfXCRgA9WllbhrUi4yu5Ltw9NqSuv3nD9o19ZgYZyc0+v1KF+vNKClF0VXSDmiNwspQgk9g5eqRL0YWFf5i3o7J2PBKdZzVkCpwN+dPl8GclREAS6opPCwuLT4JtDixawA/Hbe7bNQKWcAfyOGNKDn2
 fO3jWLBW
 TlzIBTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 1a251f52cfdc417c84411a056bc142cbd77baef4 ]

This just standardizes the use of MIN() and MAX() macros, with the very
traditional semantics.  The goal is to use these for C constant
expressions and for top-level / static initializers, and so be able to
simplify the min()/max() macros.

These macro names were used by various kernel code - they are very
traditional, after all - and all such users have been fixed up, with a
few different approaches:

 - trivial duplicated macro definitions have been removed

   Note that 'trivial' here means that it's obviously kernel code that
   already included all the major kernel headers, and thus gets the new
   generic MIN/MAX macros automatically.

 - non-trivial duplicated macro definitions are guarded with #ifndef

   This is the "yes, they define their own versions, but no, the include
   situation is not entirely obvious, and maybe they don't get the
   generic version automatically" case.

 - strange use case #1

   A couple of drivers decided that the way they want to describe their
   versioning is with

	#define MAJ 1
	#define MIN 2
	#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN)

   which adds zero value and I just did my Alexander the Great
   impersonation, and rewrote that pointless Gordian knot as

	#define DRV_VERSION "1.2"

   instead.

 - strange use case #2

   A couple of drivers thought that it's a good idea to have a random
   'MIN' or 'MAX' define for a value or index into a table, rather than
   the traditional macro that takes arguments.

   These values were re-written as C enum's instead. The new
   function-line macros only expand when followed by an open
   parenthesis, and thus don't clash with enum use.

Happily, there weren't really all that many of these cases, and a lot of
users already had the pattern of using '#ifndef' guarding (or in one
case just using '#undef MIN') before defining their own private version
that does the same thing. I left such cases alone.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 arch/um/drivers/mconsole_user.c               |  2 ++
 drivers/edac/skx_common.h                     |  1 -
 .../drm/amd/display/modules/hdcp/hdcp_ddc.c   |  2 ++
 .../drm/amd/pm/powerplay/hwmgr/ppevvmath.h    | 14 +++++++----
 drivers/gpu/drm/radeon/evergreen_cs.c         |  2 ++
 drivers/hwmon/adt7475.c                       | 24 +++++++++----------
 drivers/media/dvb-frontends/stv0367_priv.h    |  3 +++
 drivers/net/fjes/fjes_main.c                  |  4 +---
 drivers/nfc/pn544/i2c.c                       |  2 --
 drivers/platform/x86/sony-laptop.c            |  1 -
 drivers/scsi/isci/init.c                      |  6 +----
 .../pci/hive_isp_css_include/math_support.h   |  5 ----
 include/linux/minmax.h                        |  2 ++
 kernel/trace/preemptirq_delay_test.c          |  2 --
 lib/btree.c                                   |  1 -
 lib/decompress_unlzma.c                       |  2 ++
 mm/zsmalloc.c                                 |  1 -
 tools/testing/selftests/seccomp/seccomp_bpf.c |  2 ++
 tools/testing/selftests/vm/mremap_test.c      |  2 ++
 19 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index e24298a734be..a04cd13c6315 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -71,7 +71,9 @@ static struct mconsole_command *mconsole_parse(struct mc_request *req)
 	return NULL;
 }
 
+#ifndef MIN
 #define MIN(a,b) ((a)<(b) ? (a):(b))
+#endif
 
 #define STRINGX(x) #x
 #define STRING(x) STRINGX(x)
diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index c0c174c101d2..c5e273bc2292 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -45,7 +45,6 @@
 #define I10NM_NUM_CHANNELS	MAX(I10NM_NUM_DDR_CHANNELS, I10NM_NUM_HBM_CHANNELS)
 #define I10NM_NUM_DIMMS		MAX(I10NM_NUM_DDR_DIMMS, I10NM_NUM_HBM_DIMMS)
 
-#define MAX(a, b)	((a) > (b) ? (a) : (b))
 #define NUM_IMC		MAX(SKX_NUM_IMC, I10NM_NUM_IMC)
 #define NUM_CHANNELS	MAX(SKX_NUM_CHANNELS, I10NM_NUM_CHANNELS)
 #define NUM_DIMMS	MAX(SKX_NUM_DIMMS, I10NM_NUM_DIMMS)
diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
index 1b2df97226a3..40286e8dd4e1 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
@@ -25,7 +25,9 @@
 
 #include "hdcp.h"
 
+#ifndef MIN
 #define MIN(a, b) ((a) < (b) ? (a) : (b))
+#endif
 #define HDCP_I2C_ADDR 0x3a	/* 0x74 >> 1*/
 #define KSV_READ_SIZE 0xf	/* 0x6803b - 0x6802c */
 #define HDCP_MAX_AUX_TRANSACTION_SIZE 16
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
index dac29fe6cfc6..abbdb7731996 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
@@ -22,12 +22,18 @@
  */
 #include <asm/div64.h>
 
-#define SHIFT_AMOUNT 16 /* We multiply all original integers with 2^SHIFT_AMOUNT to get the fInt representation */
+enum ppevvmath_constants {
+	/* We multiply all original integers with 2^SHIFT_AMOUNT to get the fInt representation */
+	SHIFT_AMOUNT	= 16,
 
-#define PRECISION 5 /* Change this value to change the number of decimal places in the final output - 5 is a good default */
+	/* Change this value to change the number of decimal places in the final output - 5 is a good default */
+	PRECISION	=  5,
 
-#define SHIFTED_2 (2 << SHIFT_AMOUNT)
-#define MAX (1 << (SHIFT_AMOUNT - 1)) - 1 /* 32767 - Might change in the future */
+	SHIFTED_2	= (2 << SHIFT_AMOUNT),
+
+	/* 32767 - Might change in the future */
+	MAX		= (1 << (SHIFT_AMOUNT - 1)) - 1,
+};
 
 /* -------------------------------------------------------------------------------
  * NEW TYPE - fINT
diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 820c2c3641d3..1311f10fad66 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -33,8 +33,10 @@
 #include "evergreen_reg_safe.h"
 #include "cayman_reg_safe.h"
 
+#ifndef MIN
 #define MAX(a,b)                   (((a)>(b))?(a):(b))
 #define MIN(a,b)                   (((a)<(b))?(a):(b))
+#endif
 
 #define REG_SAFE_BM_SIZE ARRAY_SIZE(evergreen_reg_safe_bm)
 
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 3ac674427675..44eb31055256 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -23,23 +23,23 @@
 #include <linux/util_macros.h>
 
 /* Indexes for the sysfs hooks */
-
-#define INPUT		0
-#define MIN		1
-#define MAX		2
-#define CONTROL		3
-#define OFFSET		3
-#define AUTOMIN		4
-#define THERM		5
-#define HYSTERSIS	6
-
+enum adt_sysfs_id {
+	INPUT		= 0,
+	MIN		= 1,
+	MAX		= 2,
+	CONTROL		= 3,
+	OFFSET		= 3,	// Dup
+	AUTOMIN		= 4,
+	THERM		= 5,
+	HYSTERSIS	= 6,
 /*
  * These are unique identifiers for the sysfs functions - unlike the
  * numbers above, these are not also indexes into an array
  */
+	ALARM		= 9,
+	FAULT		= 10,
+};
 
-#define ALARM		9
-#define FAULT		10
 
 /* 7475 Common Registers */
 
diff --git a/drivers/media/dvb-frontends/stv0367_priv.h b/drivers/media/dvb-frontends/stv0367_priv.h
index 617f605947b2..7f056d1cce82 100644
--- a/drivers/media/dvb-frontends/stv0367_priv.h
+++ b/drivers/media/dvb-frontends/stv0367_priv.h
@@ -25,8 +25,11 @@
 #endif
 
 /* MACRO definitions */
+#ifndef MIN
 #define MAX(X, Y) ((X) >= (Y) ? (X) : (Y))
 #define MIN(X, Y) ((X) <= (Y) ? (X) : (Y))
+#endif
+
 #define INRANGE(X, Y, Z) \
 	((((X) <= (Y)) && ((Y) <= (Z))) || \
 	(((Z) <= (Y)) && ((Y) <= (X))) ? 1 : 0)
diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 1eff202f6a1f..e050910b08a2 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -14,9 +14,7 @@
 #include "fjes.h"
 #include "fjes_trace.h"
 
-#define MAJ 1
-#define MIN 2
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN)
+#define DRV_VERSION "1.2"
 #define DRV_NAME	"fjes"
 char fjes_driver_name[] = DRV_NAME;
 char fjes_driver_version[] = DRV_VERSION;
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 9e754abcfa2a..50559d976f78 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -126,8 +126,6 @@ struct pn544_i2c_fw_secure_blob {
 #define PN544_FW_CMD_RESULT_COMMAND_REJECTED 0xE0
 #define PN544_FW_CMD_RESULT_CHUNK_ERROR 0xE6
 
-#define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
-
 #define PN544_FW_WRITE_BUFFER_MAX_LEN 0x9f7
 #define PN544_FW_I2C_MAX_PAYLOAD PN544_HCI_I2C_LLC_MAX_SIZE
 #define PN544_FW_I2C_WRITE_FRAME_HEADER_LEN 8
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 5ff5aaf92b56..b80007676c2d 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -757,7 +757,6 @@ static union acpi_object *__call_snc_method(acpi_handle handle, char *method,
 	return result;
 }
 
-#define MIN(a, b)	(a > b ? b : a)
 static int sony_nc_buffer_call(acpi_handle handle, char *name, u64 *value,
 		void *buffer, size_t buflen)
 {
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index e294d5d961eb..012cd2dade86 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -65,11 +65,7 @@
 #include "task.h"
 #include "probe_roms.h"
 
-#define MAJ 1
-#define MIN 2
-#define BUILD 0
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN) "." \
-	__stringify(BUILD)
+#define DRV_VERSION "1.2.0"
 
 MODULE_VERSION(DRV_VERSION);
 
diff --git a/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h b/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
index a444ec14ff9d..1c17a87a8572 100644
--- a/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
+++ b/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
@@ -31,11 +31,6 @@
 /* A => B */
 #define IMPLIES(a, b)        (!(a) || (b))
 
-/* for preprocessor and array sizing use MIN and MAX
-   otherwise use min and max */
-#define MAX(a, b)            (((a) > (b)) ? (a) : (b))
-#define MIN(a, b)            (((a) < (b)) ? (a) : (b))
-
 #define ROUND_DIV(a, b)      (((b) != 0) ? ((a) + ((b) >> 1)) / (b) : 0)
 #define CEIL_DIV(a, b)       (((b) != 0) ? ((a) + (b) - 1) / (b) : 0)
 #define CEIL_MUL(a, b)       (CEIL_DIV(a, b) * (b))
diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 9c2848abc804..fc384714da45 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -277,6 +277,8 @@ static inline bool in_range32(u32 val, u32 start, u32 len)
  * Use these carefully: no type checking, and uses the arguments
  * multiple times. Use for obvious constants only.
  */
+#define MIN(a,b) __cmp(min,a,b)
+#define MAX(a,b) __cmp(max,a,b)
 #define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
 #define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
 
diff --git a/kernel/trace/preemptirq_delay_test.c b/kernel/trace/preemptirq_delay_test.c
index 8af92dbe98f0..acb0c971a408 100644
--- a/kernel/trace/preemptirq_delay_test.c
+++ b/kernel/trace/preemptirq_delay_test.c
@@ -34,8 +34,6 @@ MODULE_PARM_DESC(cpu_affinity, "Cpu num test is running on");
 
 static struct completion done;
 
-#define MIN(x, y) ((x) < (y) ? (x) : (y))
-
 static void busy_wait(ulong time)
 {
 	u64 start, end;
diff --git a/lib/btree.c b/lib/btree.c
index a82100c73b55..8407ff7dca1a 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -43,7 +43,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 
-#define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define NODESIZE MAX(L1_CACHE_BYTES, 128)
 
 struct btree_geo {
diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index 20a858031f12..9d34d35908da 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -37,7 +37,9 @@
 
 #include <linux/decompress/mm.h>
 
+#ifndef MIN
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
+#endif
 
 static long long INIT read_int(unsigned char *ptr, int size)
 {
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index af130e2dcea2..aede005d1adc 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -123,7 +123,6 @@
 #define ISOLATED_BITS	3
 #define MAGIC_VAL_BITS	8
 
-#define MAX(a, b) ((a) >= (b) ? (a) : (b))
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
 	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index b300e87404d8..b054bfef0f4f 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -60,7 +60,9 @@
 #define SKIP(s, ...)	XFAIL(s, ##__VA_ARGS__)
 #endif
 
+#ifndef MIN
 #define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
+#endif
 
 #ifndef PR_SET_PTRACER
 # define PR_SET_PTRACER 0x59616d61
diff --git a/tools/testing/selftests/vm/mremap_test.c b/tools/testing/selftests/vm/mremap_test.c
index 9496346973d4..7f674160f01e 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -22,7 +22,9 @@
 #define VALIDATION_DEFAULT_THRESHOLD 4	/* 4MB */
 #define VALIDATION_NO_THRESHOLD 0	/* Verify the entire region */
 
+#ifndef MIN
 #define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
+#endif
 
 struct config {
 	unsigned long long src_alignment;
-- 
2.47.3


