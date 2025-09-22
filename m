Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4A2DCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 05:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6FEA8E0002; Mon, 22 Sep 2025 01:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A211A8E0001; Mon, 22 Sep 2025 01:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E81B8E0002; Mon, 22 Sep 2025 01:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77BC68E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 01:02:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD84011A3FE
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:02:16 +0000 (UTC)
X-FDA: 83915689872.19.066F100
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 05A3D120007
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:02:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=BcNVWZn6;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758517335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ciOrUEs4HO/d/nomzUBQ3OYmE8CggdUlhJdEYcWlwfU=;
	b=4N79lz0ePfXr2QtVJhAXvsxwmP9q8HNA9sw6cV9INZmQ+gQlfUjov7mQDSiYzeODJRaFyg
	yUNwZeQ2bBznAYQfQeKCuGeTTtvZxmDI+RhUIQeRQQzy7bCvmPTnzsY8keu2wEcdvscQvu
	nnbgJcKpO+E/bp3XxdFgQedKnx7HrLU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=BcNVWZn6;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758517335; a=rsa-sha256;
	cv=none;
	b=qf6Brh4FOyZKLTMa8N2CDwOy/geHKuhVCOLbIgAR7TSHC4RwKtFc6StN4wnlDyzLEwFHJs
	b3GDJTWrgz2N/hMVhFbMZ3skFUmrEbsd6mRJCkGeAV3R6OtZQVEx311eW8xt+gAAnQ5JnK
	URXx6+zPZ7spi/HQB946ceGb+l0x/4w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2486D40C21;
	Mon, 22 Sep 2025 05:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A858C4CEF5;
	Mon, 22 Sep 2025 05:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758517333;
	bh=/nk8xPLOsGXuSw5wS41Jy4q570vGloBiPOCZp2/irX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BcNVWZn6zT4Gv/IUZ2C0NZn/XQ5pAMMpsZzcS58NBPYxD2oFH/k4xQ1OcYygH2JDO
	 qM8XphYZH6pOzc+c2uakvnfuiVmB28vwfNolajwWxIrag0Gc1iZ0LiKuoKaX4EXv7U
	 h1tGLKcFUdBrn8iKhoSlB6ijAzBdHBAHMrirLbcw=
Date: Mon, 22 Sep 2025 07:02:08 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Farber, Eliav" <farbere@amazon.com>
Cc: "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"jdike@addtoit.com" <jdike@addtoit.com>,
	"richard@nod.at" <richard@nod.at>,
	"anton.ivanov@cambridgegreys.com" <anton.ivanov@cambridgegreys.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"qiuxu.zhuo@intel.com" <qiuxu.zhuo@intel.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"rric@kernel.org" <rric@kernel.org>,
	"harry.wentland@amd.com" <harry.wentland@amd.com>,
	"sunpeng.li@amd.com" <sunpeng.li@amd.com>,
	"alexander.deucher@amd.com" <alexander.deucher@amd.com>,
	"christian.koenig@amd.com" <christian.koenig@amd.com>,
	"airlied@linux.ie" <airlied@linux.ie>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>,
	"evan.quan@amd.com" <evan.quan@amd.com>,
	"james.qian.wang@arm.com" <james.qian.wang@arm.com>,
	"liviu.dudau@arm.com" <liviu.dudau@arm.com>,
	"mihail.atanassov@arm.com" <mihail.atanassov@arm.com>,
	"brian.starkey@arm.com" <brian.starkey@arm.com>,
	"maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>,
	"mripard@kernel.org" <mripard@kernel.org>,
	"tzimmermann@suse.de" <tzimmermann@suse.de>,
	"robdclark@gmail.com" <robdclark@gmail.com>,
	"sean@poorly.run" <sean@poorly.run>,
	"jdelvare@suse.com" <jdelvare@suse.com>,
	"linux@roeck-us.net" <linux@roeck-us.net>,
	"fery@cypress.com" <fery@cypress.com>,
	"dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"rajur@chelsio.com" <rajur@chelsio.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
	"alexandre.torgue@st.com" <alexandre.torgue@st.com>,
	"joabreu@synopsys.com" <joabreu@synopsys.com>,
	"mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
	"malattia@linux.it" <malattia@linux.it>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"mgross@linux.intel.com" <mgross@linux.intel.com>,
	"intel-linux-scu@intel.com" <intel-linux-scu@intel.com>,
	"artur.paszkiewicz@intel.com" <artur.paszkiewicz@intel.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
	"clm@fb.com" <clm@fb.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"jack@suse.com" <jack@suse.com>, "tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"dushistov@mail.ru" <dushistov@mail.ru>,
	"luc.vanoostenryck@gmail.com" <luc.vanoostenryck@gmail.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"pmladek@suse.com" <pmladek@suse.com>,
	"sergey.senozhatsky@gmail.com" <sergey.senozhatsky@gmail.com>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
	"minchan@kernel.org" <minchan@kernel.org>,
	"ngupta@vflare.org" <ngupta@vflare.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
	"yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>,
	"fw@strlen.de" <fw@strlen.de>,
	"jmaloy@redhat.com" <jmaloy@redhat.com>,
	"ying.xue@windriver.com" <ying.xue@windriver.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"sashal@kernel.org" <sashal@kernel.org>,
	"ruanjinjie@huawei.com" <ruanjinjie@huawei.com>,
	"David.Laight@aculab.com" <David.Laight@aculab.com>,
	"herve.codina@bootlin.com" <herve.codina@bootlin.com>,
	"Jason@zx2c4.com" <Jason@zx2c4.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"keescook@chromium.org" <keescook@chromium.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
	"freedreno@lists.freedesktop.org" <freedreno@lists.freedesktop.org>,
	"linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-stm32@st-md-mailman.stormreply.com" <linux-stm32@st-md-mailman.stormreply.com>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"tipc-discussion@lists.sourceforge.net" <tipc-discussion@lists.sourceforge.net>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"Chocron, Jonathan" <jonnyc@amazon.com>
Subject: Re: [PATCH 00/27 5.10.y] Backport minmax.h updates from v6.17-rc6
Message-ID: <2025092203-untreated-sloppily-23b5@gregkh>
References: <20250919101727.16152-1-farbere@amazon.com>
 <2025092136-unelected-skirt-d91d@gregkh>
 <4f497306c58240a88c0bb001786c3ad2@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f497306c58240a88c0bb001786c3ad2@amazon.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 05A3D120007
X-Stat-Signature: cofu5qa6h6f3rr6jgscfz713jnwjt7b6
X-HE-Tag: 1758517334-844698
X-HE-Meta: U2FsdGVkX19+bjXcU4GHta3wJocq8HmohZbf4hI+FYfz1fnl8s9uF7RH4QpSvLHK687Tf/Rv7PWeWYr8LABYLvFLXlocAhwr8klsptrd3R+eBYhpVpJ3w/5f36VdIR2yRHSeNuvx82kMCStDpzKr4IAPm+qp5Sa1432yOV9+MbRuKx2myCrY5FnJ4V/pcpLw3Q6q1t5yn3CAQ35sYunqqkpS7ub/kFWInxkBvXwXtnXqqgfxslmQMK9nGBjoabs3Dxzr8yYnuH5hITBI1KojmciecPhoahEZG/HLbhe4MgR0EPvy1Ali2897J7mvSMGkxG60gYTjyferCcMRvSJCcMi+koHVjKEJjW43J/lSObyT11jF/F5SXMBh/332Vfv4Ewcoi4sfeu5bVqFmV6faMA+1z4k26wx0sQJjk7a36TXwfLSzcRHSQYDJmXtpFxB6MZWez1JOVEni74PxzfiSTrm/Ay+tCNuepV6rGStmP7cLCioRQeS5fJfePpvrxplb+4Cy+y/IAM0RrU1TywgmdONI+mhL3C66JdonTxG1qr4t5kBCB/5x5V3C8jEBgk6B2q2Int5KpktYvDXocbiSUxBQFNI5KpvwS/z15MmedQasnSu91CTPqCvWmNaHwwfoQAEY14jxfHZlDLIsDvcd7R09p2QTNJyYEhxDPk7GfNNA7kHGyGl2JHrXJ6PfJanibTmOMY5h6KFTthmnuCsKkdMh1GJsOKKfeKLkEVH9HXcpZ7ths6C8AouJMR3D08WLJJBA/8XMkMjVqlheARJYGW9b96SH/HiNLzJMukufhmKHpnOIqfr3fsvxjBzoiKxxh/ZxT7BLycAzRniBNMi/WdxBEfq6QtIQvvAiOVUE+Z1vGIV0LjstwqGb0S2R6xU0bt+Nzmlp2P0rumXq0ev0DOR3jZyJSiQqWce7YB3pPA1S5R6oV2+LN60K+19eMDwBzL4fwUjASgAjEWA9/x5
 USCam/bL
 H0D+uFzLzIRle5gSxE9000VUJ1HSwTkF2OwX1W7HCQf+D1Jlk+uA0u58+gR0xntUtxqVu0zzbo+xOAeyPJovk5bQicbhCVMQ5otEA7ZiaJ01PsTHLcF3liHYGbHbTu6tyP/QquYvfFxPYFyR4VR798o2yhVrEN5McmnL/rq+67BWlccAcffp9Jo9898ApdobRniT4xMwQ1KUH6VC2syMYVoCCauRiCZztR3YAdkixCPSDmGLqUgO4fcBaaBwaoxUIlW82IHWz82kH8raxlDpvnpNd3Th0e1QjZo3SB6U50I+/rVYkDg9vE/R8vSsqdWI1DJ4hvGbgt3DhiF7waPyAeh2ScccXfN9lkWrHzyH9anLyfS01oHZRNbyuPisEoRgFNPzj32X1TW0y/A4+gjRBwuYEKvl6T2IXnbVPS1YALDh90EpUTMrNUqVnqNOvBFa5m2f8CAaW5kUH/JGUVV0xm7JTQVXfc4e/spMnOyVGw6wYH1X+WnZTDHRIo1VaK3lxQWzOjEWv04CrEzhaa6MiWBNA8+fTndIc7rTnS+4rnPPkfO87i9umg5/flcoZ8stcD3JJajs/dcVrEPEwW6Z36UZdp8j976vVdzK1a6H7QdiiFxm5WD5dd+oBfnt8vmYybhzntfznOb78vM7dhP2Jq1KaY0NKr3nVdejWPAhplaOztZgm+zNxexN82r+wNxfh3LCpCbF/4RryKrc58qgkFW+GgsZ1UEsVQs7zqSnJLbUOiESD1Lh8aTcOwicLLiCd8imCsGhGuPtkiL8wKDHCkqsK3BV4g2YGX507bN8cAgwICsrgltlp3QlNM4pLOsqkiPiEwDeToKGCUWfZMbso//kIxruc6T+wdl4UQgdU2tM9ivIh+iteV9tgXOoetTpxgjxbUBrsR+qFCLZVMkGRAMNp1pHhKNmyvOUwQ6ysidgreOO+yPers3S/l7ZUOj8x2vrDF1HuCzMCLS17HEzYgNrj5Dtn
 7AcxsZZt
 GPFWEYr7mVVHZmIGESla7S+T7KBeEn7qS3m7kdve0d2JFoY3nGcEjFfe2N3QSip5RTzcijTWOtUmJMGw6x4zRp0GSEqtdz1fwh9hjGQZwm71b43sGIlJTM/ZxlsvN5klN//PDE0MBBpvnRPpolkPy6g/ffWtj0i5/Mmex8woiDErqXa0cXiDJbwV+fAYuKaB2VO47LsnipsDpDu0vRePcOaMe4HVKfao/A0eqOMwFkDmaKZGXKK4IEAKuJwtMTKPxzfA8IzkbR8hKEl5szC3KcqQnE7ikcI1/yGHN2w4TAxqVJcTPCKJcQ0cWf9IEDN06Z7AM9w/REd0ahHu2soElRkXktGf1ygAHxH9ylxLE5qiGlRBPRvpS/2GWoh0uyC+qAZXnILD0xg4JgP9eJoLRUfAUXm2kpAQtziB8IcZk+WQZ9JOBWM+K8o2Rncl+sDigxRfee4TM4VI4Tth6ZTWEzN9G5O4Nj0jBXonGeYwDVtUKE0kWSWAVeFnFYN4u5AOyl7ql61zETTfKZW6f3JxHkfiKxmtdfOW3qbCLNM8D6DJDuZnqFQHIJFjBpuEUmY216di3JfqlL4h38bgKEo2Pby7YicPqKx5ee6tFawcnhitVgjL1VsXVV24hRKFLg7/WkGyMMFnL8ilfZ5iUMcLgV/f+kKCROgoXSdF5eXaS6cak4ffxZIpDN2yE934m+5B1rUaQI1bB374Vh2lsB8+xTXT1uPuSu2JaG9sBcbYCR1O29+FvOnzoEXbAadpwcdTTbwh2MZXeWmVrlfcKZ8pE1LdbqYoAvlaN3Vs8BRG0QPeLxOhv18xKHIstvdndDXNdGQhr6gGmxoqQq7woFB1LWwkFr/8QFYzi32PWEd0ytA1oaCPA44HXgwCHnxM+HPaoVmRVS1R3Je21G1OJ/fycdsK7SAaAGao1UHSmT9/RwQwPt+uTwntBYHuKaFbupLjbj98z5Q9RFEJd8Z1oYJdYfb8rUJq7
 DEKhaZqG
 by+MkFeyN/Qsguh0w7pn1EVQb/MfMMWm98cibpOBYqgUXjf9HiUdQyeUYiAnlJjORr1J0vXfj0dbI3kHrSFbD83dlr0qEA57DvEBH2COIzwN8iJpcf0rex3TkclFVY4+mA7v9ZdqjmuIC4B/pyjLcD79Pb04BFkgP8I8+xTQXwMcdXf5yVyZqbLb8+J2ZUFckZjt8qYSyPyLt4k0tppVYwoz3b60QL5gbJ3AUDz16/Ry+W+iaOSyjCUW/iNFcaUrNQz83Hma4B+TP2iHts3yLDROvbNNiKHY0lldZVgKjV+8LXelEmdZ4GtGxa/tbXOy8r2m3BObKXdbT52vSBbZ/1LlZnq1WX4okd4N2ZYgcrWQJHHGyLP79e9R3BDeH9IU7qA2PRp21teOR8/qeoJORvxvSp4W1WZPiRXClSmoLoRe5eznuJp73e/PCeS3ufVzDFfauXwtnK2WVBy9RJ/7DGTHVkaywtysXIFtOxshunYhcufpj38/yf3ARjtVExpQGdGCoet2twNI8hcNNKJbvUhy8JpKw32E4vu7fKitGSarsH9txIvzCa77IkPj4azXz7t3CWP5D54qZlBqxdBCiW7tcUIxVyuUWB15e9xTIWmz8tTihZ1adrxPj09PUmuuUriPeDbPGJ91E7GmerbojCciiBUZSeDFQ98cA1HhhiX170dFljM4kZhlenAu7cj9d+9SQd3D6NfjwVuIQ3Wi+3CSRCJ2rMGzTKTfKKsqgLvJTTYkLJjGbX+oTthgFU0xwedpAL0DThWZA/7FP/68XNTh+TL7CeQQiF/D26WS7gsnLMj3PR+kB9T0ZY13qd32f4loVX+y76TVETi1dvvhZVokI5VrJye6sj4UxHSFX9OgfNBDPuI7lz5YQ/oSFoS+A1zXFnNa33mW5/JheEMGfGJHCKgOlICCS9+DqC/TBi5VE48eYC0hPKp0j5NoHmUtO2QSOwmpdug+kJTWn6mdMBCxO3RAE
 7P+Eng+U
 /AQ1tprroYdk0uFZg4qKXBs3eE3DhQGUwi2xn/Srj9JhKkjfvgl7af+KMfR0dJvPP+oGuAo8zGRet+JwZQMluiUluobLuJQsiJinRZMuiVG/ARMGCUZ3Tw0fdnAz7fOVtJtFPoXX9PDRn/6A1+pDnn1J413dORJeNm3S1unu35EKkCDWAekhVnNiZBITQI41gU2KOFL0CzVa1rUc9PzJnxxNf/hztQ/dxySQCrU0hVvfosdHdp8mpPdGrBBOgNJ6RK3W3hGLa3S6MW4PyzFh6FrVrAxMltG0zPKXoVFk4hEsz05ZrYWSESr1G4WceKLOuve18BSX9xVfwymWe8RzqRwu4bbI/+rsk/wydIhIUQOyTIZJhEGjM2TosLyu/d+nfwbzck/LgW9ofaWyuEbWEy5gXFaVKKX+N03C9iHydTek+DDI5hea0c/DjUm4Qa0GjMgKojGiJ923V0dU+K96ZNvdZ+hHc1cNvEA1mBGbIGmQBc3v4syk7+rhNedTj6CblMw03QxYPXbK0qp/7x2o5AEFP8NXS9G/MTVvHwKnrZf7q/6ZTMS2SxQAFnlNIv2oZSo1Z7QmQS8pq0uDfDrob9WiuBrAq68AITtwoEuwIiIW8ME54X4w8ivDvw+Od12qyYMAB+2Et+WrGuSaS5EzmU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21, 2025 at 09:37:02PM +0000, Farber, Eliav wrote:
> > On Fri, Sep 19, 2025 at 10:17:00AM +0000, Eliav Farber wrote:
> > > This series includes a total of 27 patches, to align minmax.h of
> > > v5.15.y with v6.17-rc6.
> > >
> > > The set consists of 24 commits that directly update minmax.h:
> > > 1) 92d23c6e9415 ("overflow, tracing: Define the is_signed_type() macro
> > >    once")
> >
> > But this isn't in 5.15.y, so how is this syncing things up?
> >
> > I'm all for this, but I got confused here, at the first commit :)
> 
> It's a typo.
> It should be 5.10.y and not 5.15.y.
> 
> > Some of these are also only in newer kernels, which, as you know, is
> > generally a bad thing (i.e. I can't take patches only for older
> > kernels.)
> >
> > I want these changes, as they are great, but can you perhaps provide
> > patch series for newer kernels first so that I can then take these?
> 
> So you'd first like first to align 6.16 with 6.17, then 6.15 with 6.16,
> then 6.12 with 6.15, then 6.6 with 6.12, and so on until we eventually
> align 5.10 and even 5.4?

Yes please!


