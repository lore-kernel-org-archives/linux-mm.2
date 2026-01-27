Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D48D2D8D4
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494826B0092; Tue, 27 Jan 2026 05:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442746B0095; Tue, 27 Jan 2026 05:22:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29BD16B0096; Tue, 27 Jan 2026 05:22:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 156ED6B0092
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:22:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADA941AFDDB
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:22:14 +0000 (UTC)
X-FDA: 84377353788.04.43C36C1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0B9DA160004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:22:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SVkp48ex;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mDfCrKUY;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769509331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5H42SB6SDuJUu+3njHUb29zTM8rjL9G4AddRKBKn4s=;
	b=ps+hWrFlKh08rjEQAVrIpXqK9GC3emN2ZtvGKXyJ82ZtJG8woNXlCIoF4vYVl/fgTRvL91
	tR3ZYMCiVUGxPsoy/ehl32GJobErvX5L9dCAoP07G0XujctgsvhDtEENIUslmevV9Cf2hG
	9NxwI3ETAWd6uiIm884dXbms0D5EIqY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SVkp48ex;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mDfCrKUY;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769509331; a=rsa-sha256;
	cv=pass;
	b=XjQ9V2dIG5VZ+MS1zZ2YAQ2HxhDy8i4y9RARBiQzm6F3TRigUS0sFzl3WRE6IVx6QjNV8u
	NLZ88JgO2WvgQJRusx4sidr8pn4+QZHOxugeN4Qeqfky7gFyWNzSd+KbAyTH4CNNdg2G5u
	+12J8tBJLyVMzPxluheuZLH4iir5VOI=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60R9tRqI324715;
	Tue, 27 Jan 2026 10:21:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=F5H42SB6SDuJUu+3nj
	HUb29zTM8rjL9G4AddRKBKn4s=; b=SVkp48exBqPG8XFrbJNag3eF97sqUYNDMR
	djlqku2BUIWGjorOz4g9BzzDafchLnA/NBlNHK8tjHqMUKJt0r6JhkoZ2lBpWBr9
	+FvfPLE0ZWvuWkm2cjjZVhAgl/s3tJ9CRbwl3otFAsQIcNjov+5R6g8QP/6xz/oS
	xkcgyDD8+xF/T0LA176BV6v2GHBq+V+rgC9nWx5s9hE4KW9KebBiZW1JNgnOPbD6
	8fCOX9wtHpL0L6A+DMaBrt9A9Zcn8ST2i/NbUH1X7b+m+bWp8qND5xiP0fni0dDO
	dJoUnNnVKQOKnzu+8ON+gOl/fA0uhMd8q1NiixljNbkP59UWvPSg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmv2usce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 10:21:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RAD1wd001950;
	Tue, 27 Jan 2026 10:21:35 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010045.outbound.protection.outlook.com [52.101.201.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhdr9s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 10:21:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xck3RXD8CA9Iuyz4qBuRl0Ta/YzkoIGdu0qw4uy6AbYUfYpIGI1LmxNKsFj3+gQPT1EtoB9DCQIH3raj5NKRo5kS+Eex6X/sUQ/n2IrE/pCd0hlEuBKC3RBc6EMyJBfoJJyVRzCyJrHdhEpSEWmHZO4oBGYU5nusUEIVv8zut/bvFnC9rGLQRPw82a+kmc/amrVkbO2bzVwEHsNDAdy1dT9OaU3Cko6LfIG2+gy49fv6CkN3QjNl54BSG9gp1HFPkpXouI+Oj+yWLjYYR8dGNIBl39bkOOfSRdn+yXghUZyim2FYIxdyTk5W7MW9bg5vgbAXHbO7hdUIZn3Xziyw9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5H42SB6SDuJUu+3njHUb29zTM8rjL9G4AddRKBKn4s=;
 b=Vios3YinYA8gE5dJ71tW+bNezHZQPn6cPYIfz4k7Jew4FACWvr4vote4dBeB4vig7m1vl8cPkIGiVDESdeXQzQJ6Aulm2mcSupECs5axtZoiB86/ZoZU2azd/f8CxP3BU53efwugsbq0//IODSVJRLii0IxngEfCHbPmIn6FLEmIdxZR0Dv8vfZtCUj9YzmRg77l7OZYYFtHkS38T7kPdujjYGPhHfud5xH7zWKERLNBWdCkWRpKhjlG8Wj8+LG+/hd5WI+uo6f5Tao7uAVxsw93OIBVp8JZHhCbcuUKNqb5UOjCejYQn+JoMyKnexTM9PkReITDkNjdj9JhXtDl+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5H42SB6SDuJUu+3njHUb29zTM8rjL9G4AddRKBKn4s=;
 b=mDfCrKUY9hWnHyYFaN0XWepkF2i2zymCQAXEHIH6RT7gh5PsUVM4e/znb1RR7iElOtW8u/nhvi727XSfgE9Fc5r4s7DKqkmAYA1luTvc0OqCt7gci2tBh8J7AdpTN1zXMmejJvD/OlK11bFJAS5jo8wEFhOQMhlTo0nHkZ101uI=
Received: from CH3PR10MB8215.namprd10.prod.outlook.com (2603:10b6:610:1f5::7)
 by MN6PR10MB8168.namprd10.prod.outlook.com (2603:10b6:208:500::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 10:21:31 +0000
Received: from CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9]) by CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9%6]) with mapi id 15.20.9499.005; Tue, 27 Jan 2026
 10:21:30 +0000
Date: Tue, 27 Jan 2026 10:21:28 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
        Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
        Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
        Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
        kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
        linux-wireless@vger.kernel.org, llvm@lists.linux.dev,
        rcu@vger.kernel.org, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v5 06/36] cleanup: Basic compatibility with context
 analysis
Message-ID: <599729a5-da4c-473a-bd07-4459639c95c7@lucifer.local>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-7-elver@google.com>
 <0c2d9b69-c052-4075-8a4b-023d277b8509@lucifer.local>
 <CANpmjNNHmOzaCSc9hQJNuzNVHXA=LRgXB4Q69FNk6wBuuJGdAg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNHmOzaCSc9hQJNuzNVHXA=LRgXB4Q69FNk6wBuuJGdAg@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0098.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::15) To CH3PR10MB8215.namprd10.prod.outlook.com
 (2603:10b6:610:1f5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB8215:EE_|MN6PR10MB8168:EE_
X-MS-Office365-Filtering-Correlation-Id: dc6d1f63-e031-474e-ae72-08de5d8dd6a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+/KN8W0B/VzVARbdg0cLl+/Jbd70KCs0Jw8I/VSYasAC6XgzwJZS0hBxQTYe?=
 =?us-ascii?Q?pQkWpibq5KvyYSlbc9z4mDs8fL1mUgXbkrslDtMRe60AfStUkHK9NxxVRenp?=
 =?us-ascii?Q?4L1WhoiKcVTAg/eoHLAzrpwV6QD6+6IKRcjWBQcgXhLSm3rMHTMdVBRanmno?=
 =?us-ascii?Q?dHvye+5BtdT3PcZ0LUgWPzapTnD2zPyCtne1QIY02LkVPzCmHOBivrsGd3Wi?=
 =?us-ascii?Q?f5u9kn1eG6o/f+0HBKq2LcwPOVl2wWvaoWFbKnvOQnR88c/JuFNG7VcoudpZ?=
 =?us-ascii?Q?HJsYbKmxKVzGeu4sULpJ1Iyn1OG7a+GQEyEfLK3dBkUclMZ5CrFbwznNG1dP?=
 =?us-ascii?Q?cH6YVLwt74MLBkg+EIrH5tLDTuIYsngxBTxDs8SpTSD7cqx8LsFJSYtWB/ep?=
 =?us-ascii?Q?NI0V8aeoYKcAKSwLxyiAGGhAmocQpfKE0J3WGxe9nKbj4yyDVpzEgD4JB9k1?=
 =?us-ascii?Q?cmrYM0TSa1kS6nqrghFYoI8Uv/KmItl0w59pxktSrrb4uH99F9o6YYx8qpAb?=
 =?us-ascii?Q?E6SWfxv19hTGboh5UYKlKkwm/UDVEjPsHQE1xWrlCjIzRXizyoo+eamGKeMt?=
 =?us-ascii?Q?mxDhI/JrhYd3GlPoLs/AMtfXZvvymQVwB7yyN+yLA6NAOkp7VsEmXdGaSjzf?=
 =?us-ascii?Q?26r+r8fvK88YHFG0Y3sr9gNm9lGwDFeiWLMNrwcxEua5Ammc2a87/VV71lmk?=
 =?us-ascii?Q?ONaAWd2vzc5YCNJ6ZnHMjDnVDm0GK1NlZRO6bx7IbGgxlY+gFbJQ9OXrkaxR?=
 =?us-ascii?Q?daeFvU1vyzQH0hlY2+Tm2z3VDEITeXkCO02izAL00psvPvLPitp6mDt0QL+i?=
 =?us-ascii?Q?M+xSapJlJE7NbN0znUMLTbAHR04tqh7Yy8eYF+9UxEA0qxbAdTTEfr2hT18C?=
 =?us-ascii?Q?iI2sax1H+YsAbiloEal0bfFOkee9f9b9cb5RZbVCbI1Lywsyl0d5cVFh9sEP?=
 =?us-ascii?Q?//+3A6LRqd66Y0pYR2XhmaNXfjYa1dy/AaQ4ul5FzEol4EsqbAUQv6jc9gcs?=
 =?us-ascii?Q?SCrHBwYe0Kv+C52sGSbXHrLyxZtPowDleL27TUJxVPn2R1cfil5j6egJrFwr?=
 =?us-ascii?Q?ll2kcfviySqkaiF+5nTRqUl0ZsduZVU7RGmj3gogN1MRqgdBssnt6or7ZsxV?=
 =?us-ascii?Q?ATX78pN89B6SDo5I2iA2kTFYd+7wydRV1425IepPHSCOBqs+nCTylfCq72e1?=
 =?us-ascii?Q?zN/rxBGa3jYnFGhBdJqvN3vp4UkSd+xnVyt7ZMtYa6uR5i6Aq02vKn0UGvRb?=
 =?us-ascii?Q?HtvIvCIHK47psPUuiLEFfbN0NHwHAF202UIdzhQcuQAiHBNv3gMsXh7ZKLJk?=
 =?us-ascii?Q?z2KIodcOx3Fy4bTs1auZkWyg4yI2IQP3HUxDVnfgY5ODjJ2VeRL7T78iSue8?=
 =?us-ascii?Q?VVud/hNO19hpvJvAZneiDdJBUqd9lpu6BN4v/D46uyAYe4E0wh1O2CoV1WH8?=
 =?us-ascii?Q?Vy6IMourIWgg4BXW64FpqHEOACQ2UKu4HHrGJJiJa+YPAsJzAGHyjaABQvwX?=
 =?us-ascii?Q?Nbp1U3sF8SYS4Ix7MdqZUwxxy/o8EddbjkG5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB8215.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Za9BAMgAQJtgvYqu9iivQMQu+V6cW7waeo3EtNdmhqc5IuGpIOU6y0Ni3/jP?=
 =?us-ascii?Q?Yb4ZyPRyvzCIJHaQ6R8jZ8atYGo3ZSrEmB4eJ7ofEQWnzha34cmsv26hiFx8?=
 =?us-ascii?Q?lwyBGZTl2utT9mk9SSi6DtANAwKkmCKSOHx3BFhCzuR5Ft5/O3f1jzhTHAOr?=
 =?us-ascii?Q?wd7+z51yHPso0tOSafhLJ//P+H4C3r/5k2QAqjg9p8Raz3H1ZcMxdHpF7yDt?=
 =?us-ascii?Q?W5saYH/cafTewjwjEWchp1TmMJKa3Q0dtyFjgzd+/z2/9Cn6Zv8Uw9l4SH8D?=
 =?us-ascii?Q?F446sc3fYAKxOHPxeDiWWREM/WQDU202BTAMmfl7m14LSiz94OcZzoRxecu6?=
 =?us-ascii?Q?CQuTlER58ivNVFYzeDluzVQ+/8KvxgZ5eEvMEN5qeiyQyEt5bUfkhGjy46k7?=
 =?us-ascii?Q?1F0wyL4Boh1hbzN8BDOYMyp9mA/MmafkXiFM724eM7h5ENZqycKw8EOAq1pA?=
 =?us-ascii?Q?s9XsGOanIp9kI1YZx2qyCvksRYhlGkjg3HtucK7Xn9d8g7oM0vDdGwZelNLa?=
 =?us-ascii?Q?OIxkQPSsfzm2b8/HsRPtI5xPcpo9wvDvi6OAcPt7kpifxIV0cgPQLvdpV2F4?=
 =?us-ascii?Q?aUBm8dvDmuLzJezEuaJPf3edLV6mQTILYSlepWE4a+Dma9kRsM9vrt/pRUi0?=
 =?us-ascii?Q?ERs3W9JFzZ263/TN+n6QuuF1iTlmUngQ1hJmOLSybdXzMxdF9vssNVMfxVcd?=
 =?us-ascii?Q?IxNuBRBUilJM1on5fSMIcyFQqy1smf6jZWPmC/0m9LIbYQ87Q9iZQA6LpUiq?=
 =?us-ascii?Q?6rVn47Mthv82RXaL6ixTXFyEP8yVg408Je9SwdPELRrQfl5JBp0JANiP04SU?=
 =?us-ascii?Q?DNj9CsTLT1b9Tv0SbOw5BI1Vyhyhj2wbfe/qzv8IEjIME/bFWYQPMO4ie9pk?=
 =?us-ascii?Q?AlgqzLrc2VkjB7D+mFiy9uCQ4c11EteTLrQrqJSYZFgYvPJN94+FzmxvRvBa?=
 =?us-ascii?Q?PMTNGCreR6lpfPqnhUxH+WJvfA+An8clyEYl0DlJ6BB9vZdYAbHmTtOHSo/P?=
 =?us-ascii?Q?5IF60un/TK71rPdljRVImpsGSxoIEP7ZXqGbmS6nEvk7okjL8NcdwQTUmBKP?=
 =?us-ascii?Q?IddzM2lPbPFr5Hpa/CMYrOsuNAqgKv/ufhDX41Ka8aUlT/l0nsrVrWROyxCB?=
 =?us-ascii?Q?Uose3BmhnxQwHTazcJAR2ff9m2ysffB8No1sev0cKbvK28IYs5wUWUYkkH7x?=
 =?us-ascii?Q?f7QOGM0KF32pr3Px7PY4Qq8J158QxnG1vtzjnj5WKCeupK6z6BGnyRg6nCPX?=
 =?us-ascii?Q?Lj4hhOaS41L6MR/jz9qc3ESKT2w4hFDfw5ZBpLJ8d0vu+6hm43+AOIrCI/lB?=
 =?us-ascii?Q?JbQQRpm7bBxzjxaLLpDWkg8KQfi2BEEcvadYaOItrj5pq4Q3RAKZ6WAujeMO?=
 =?us-ascii?Q?9uujMYY45713GqJIK8cyL7cOZIZbx6MepcDB8IzVCEnS/2n4s55DwDgtiTYS?=
 =?us-ascii?Q?9b0SoDYUswAVVvAu0IiOdIFMwsw1nkAa0BNSKTS/YDI6pYHNV9ltCl9kETm/?=
 =?us-ascii?Q?8jhxw2KfvjVur0vKj4/LgPmmc4dXnZPzeKijj09p1BuU8cBY8CjTWQd6mjd8?=
 =?us-ascii?Q?A9Dm+6bN48czVmEzpRz7/XSUaoY7wxObj1ilg0kIMoik+nw5ea+a76Sl5jA6?=
 =?us-ascii?Q?EkMKyIierO6KGUNIbLApurv91T5CjUlVOF616Md654p955SRsU0JMWW6jo7c?=
 =?us-ascii?Q?njWb5HIHxJS50rF9FB7KnfuU2X2sLlhhDUP59b15RFRbIJQSG2FKS5xotRas?=
 =?us-ascii?Q?PypK1HKECeBN4ZBbD96H/1UWosxH7WQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BSU2e3QFIBy5TXIVZuVzWBiZ/kUY2hmTmNYXbHYf08/U3RXAFVDhAYXDC9jSNlqOWPm0s6ugUlahFas1a0LjXNIIpD5GGsYPrJ2qLbJ4bLKEzrkLlDjV4if77uSotjx6T/ATobS1FazjjgA8CLXfyKDFrq2mVM9SLjN2njqo244/ifotyHqnyPt8lORITwZAuAXX1hGcGkigh5SZ+Lq2NQ4HhNxYL141lik8k7YpQpPtw20dcg0E+1ieDJgk7yQArtYVbUenWd3g1BVs5dqtPqvtl2H+CLtbdqSuxu+TiuPAc4Q0FZFsdMTwhzAhd9XhpzXE96cSV1TqDoDkDgKAEmdsJJ4Fu7Z/UR0pgaWglREMnLdsI4fdJ17w14IOHSZdL28z0soPYFX0uKEOJAsTyRbxQUQ98+x82l1BpycnWBiyNJggrgHvcepEO1PizaELPdW74O0JjWWNQuu032D38tU6SZZZJNEGrkYXjYtXryTiaV+EixTv8W6Py3DK0m8ym2ERFyov9h4cAoyfPtELXfItJInSqzRT9yjcdTeyk57cwxueIu9lucEt1LflnTyaVhTvTJ6EftQjQET7bTtIayHPxQcFLfw9CsPGms74Dtk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6d1f63-e031-474e-ae72-08de5d8dd6a0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB8215.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 10:21:30.6986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHiSXOwUl+kILM/2jzOnV+XuxoKm9mAKGqDfPSGWWqi0WRUQbJcHgm5dbxwTMHtQ3cPWRdGnlQVN8+lARdUBesXxVVL6ux/CLWVJMUCgU7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8168
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_02,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601270084
X-Proofpoint-ORIG-GUID: 0mpK42smoVkGrNl8Ra4GuDxsj5klECIO
X-Proofpoint-GUID: 0mpK42smoVkGrNl8Ra4GuDxsj5klECIO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDA4NCBTYWx0ZWRfX5NTA4oDBEaLA
 Ktkq1sCslkUG/9wv2gBrLeaqcCMKL3PX1skD7eDmh90W1GlERIve5jVYJ+1HhCaPgaPKWAwkcVR
 q1fmCJI8CXeaY1RhSmMrdbUMi88mAAfA7DLMPeZZo4dopQ7mxG8m1G6YnBFGaiHtFF+x6buILtK
 pc+haAN2moIoEo3zVX/s3HmBh3GThUD7UG7JrlewDOjCcugT76NI7AKTBzgUOC3NOrWOWZDfMZ9
 J8B+ocp0/CR3M7z3FudW8kngVEj8vsIgRoeLFSrV45knF1Iw8TbduRIPedWfnkkpy4razYz9akC
 6mQ9Lxqqivetq0UShzFhFClBN4Y6yEyy6d4BwtY0F75cIHNLfgYuHxkfq6x4jN4KWs2jCEEanLV
 pO828Ylnhh2vtzjhSoOC+ak19oAxTNu/e8FMZEeTUZY7CPqIcb6/I7cGzF/RshYr31LX5t+ez4W
 KluWpQqZ47UrGuIVnXH3Zz9KpbhyjrVEh//CHWZE=
X-Authority-Analysis: v=2.4 cv=cPLtc1eN c=1 sm=1 tr=0 ts=697891af b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=nYO3-bDRM2uWDnqorzEA:9 a=CjuIK1q_8ugA:10
 a=zZCYzV9kfG8A:10 cc=ntf awl=host:13644
X-Stat-Signature: qqjbq76znidz79rahxsrnfwkri9p6me7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B9DA160004
X-HE-Tag: 1769509330-800493
X-HE-Meta: U2FsdGVkX1/bFIefMk1cou6pKGyG9LZfOf2jo+pBGBLiUYBrhJ4SPh3Jz8lcdEb3cD2pmZtgesMZsJapzEPgOtxN7KvY3xQ3jhEsRPdtBQcwDmLLR33Y5maR55sJulvz7Vl+2hdFOz+L5vx67Ni6oodKC20qz/qX24j586frYF1WkpuMukD+GkHHK/rFDjG/wwJ017NMQyUOkg9WHuULzOxnJhxeEjvUQnoqvvlkYq9c3o5twanbp3SyDTzHQ97oWyLh/YPpNCibsxyBJibwJj+HyiWlsm9RU6Ak3owyxWagewYB4kso8/74zSZamFcTGHcBWnmSARgTNNIIObmY8rvyH7tiRy4vOFYZOgYl34x/PwAuK/Q59bG+IxcLHui3jaBO9IHctiqrtJ7Ax5H+Pei3+nxM2SVPuM0ApD3AGpDjhijk7X3VCyjQlVIWz82G8hqK1HpoJ6f7mrKSdHSaasovbMKl3f+OpThhaHxC10Z/upiEhck9mFIV2ks7MLawiz33AVDBvXjP8tMlhlr9cWotwVKjN6JrN7zDaITzVnju0X0UBq1Y7AJBGxazG2DjaLVtpXimg5UQS1u9kqdsMgQBjKVmDboAYbOm+18IMjdWcWS53l81Uxu6z2A1XkxEBCIk3NaAa0C3s3yEF4SYdEBo5kTZyuz7QO0pDCU+C99rux2cQgd6nUNXKmnvjv37QIKiGxKkjn+1Q+NRmM7qFUTPfQbD0vnYd5I4uanCyQ/cY6cnbI2iJfjLoOBDHbvbD1FTtvjUKhehrONDyFsSb21/OwYND0DoXN1F+kDgA4d0BMA+/iKA4DE6TkAQoQ/JYq9OPyuC3qpy6ZiW7YFXSBS0pCq8uyjt8AVh1fhrXLp/T1fU2S6ZBz9b7RzCwpeRf90RmVRCHcjixP+v9sKx9sFMAlkXcd8Fx3RPcoO3U6uD+KEKTeo2rmH64YCGy5PyljZ/hlT4ffAtOuoW8EE
 Y8r9VFhf
 nAfHY5WbBs20mDMalNgdyl3rRhCSnIdJpe8gzm3LieFurhQs8DxDtO5QsSUv8mJvBipq2vwRDizgNNoYdIES9qOXuSHOxPCcohDFv77T/3+GMqRfeXydIutHZUDbkr/U07EoJD6dS9kJqpOQ0Qo60ZRmnXRFnIuIGEGUoRHfjtNL+9Djgv06k+Mq6enyp4+NrdmQXtXLRoGPoUg7tPvgI0buR97d9MYhNyg7bMmK/FoMSpMl/HAfyLsUoNU2U9I5h3HkCt5duIusf4hj3d7MViKJHKwjgAZvZ5x8HqOE/E8ysnPZ+n4HWi3szRWPdmqICPTff5lIc+wKQStIsp4eNtQRz5LopPcy2RonLiPzFWh+K/ahuAJPDJ6kcn7X+67CoB2awnlljphLyDluIBR8v+vOcirtz4jqvuwW3BEOo/t0ZvhK0Dr8TRvAlo4DrQHmcpL9FBLCQ6Po0iloFYMQ0r4zNy8wUvHFE3eMdSubcmPY2bNU7suOPD9EWHPjsur7NPHyNOE7eH3bs51R/vH+nTepIZBSSCbbR/7cKmnGK7vDlZSLBDv9qNMdAWqxlk5YeUMURAc7mm4oJoJgDZ+jw6f8NJqQ6SNNnM3cGk8f95kcIh48hmXnXUdv3XxfQZrISyvawPQTqai2UxbHS5oelgKcTdP0js1+A7EhpBNrzKSKaJXHj26pwbn9fS5oGUMKaP6iongPcZVRwj+5aiaF7gmK6CboEJ2tBZQfXxxpC3sOYOT1BBF1+BpkAM/8yM7YOKSMVHXt+fq31BkM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 11:17:24AM +0100, Marco Elver wrote:
> On Tue, 27 Jan 2026 at 11:14, Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > +cc Sid for awareness
> >
> > Hi,
> >
> > This patch breaks the radix tree and VMA userland tests. The next bots didn't
> > catch it but it seems now they're building the userland VMA tests
> > (e.g. https://lore.kernel.all/202601271308.b8d3fcb6-lkp@intel.com/) but maybe
> > not caught up to the issue this one caused (fails build in tools/testing/vma and
> > tools/testing/radix-tree).
> >
> > Anyway it's a really easy fix, just need to stub out __no_context_analysis in
> > the tools/include copy of compiler_types.h, fix-patch provided below.
> >
> > To avoid bisection hazard it'd be nice if it could be folded into this series
> > before this patch, but if we're too late in the cycle for that I can submit a
> > fix separately.
>
> Thanks, I saw. I have a more complete fix I'm about to send.

Great, thanks!

