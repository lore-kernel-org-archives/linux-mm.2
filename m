Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0742DC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 19:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D33F6B008A; Fri, 25 Jul 2025 15:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983496B008C; Fri, 25 Jul 2025 15:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84AB46B0092; Fri, 25 Jul 2025 15:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 739CC6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:55:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18903BC132
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:55:36 +0000 (UTC)
X-FDA: 83703841872.15.66223F3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9278A100002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:55:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MfNMLK1v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BG+LBDEs;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753473332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvGzvDb1MeLYqgmsWwSYbYBRzfKYDSg18kFoThChvyI=;
	b=mwjvKygTYsp78U6DefBwAxrTW3B/m8whsZLHJTkN1A/xhDOjzStzNFSMmxvtpiqCuGMFUJ
	WUzszlrJ74DEPc5F7TYkTQ7V2kw2eSrvGwXtlEA3eI4hL9M6SpDomKBvdXaVGy6uiYaWZJ
	H8Lzd8pWoQu8w3Ed9ZyIauybIM4sL1o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753473332; a=rsa-sha256;
	cv=pass;
	b=AgWbzcri5Gc+isqBwB9d/MNbC8hACEo5tTcMLawF7sG2/XNRMFY6HOTu3BEyrMWPPw5ZYM
	hA20KF45CvEXcubOT0F4xJNhMY8T+IDWliHiaB/DgF0A6wGPSeG3LHb0Mj7WuLUjyiQded
	PEEPU3wW9e4gA5Xbn9+jGoURImqlrA8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MfNMLK1v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BG+LBDEs;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PGC9C9012211;
	Fri, 25 Jul 2025 19:55:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FvGzvDb1MeLYqgmsWw
	SYbYBRzfKYDSg18kFoThChvyI=; b=MfNMLK1vu4KEYPm8lzIdzcKVVkSM+JUMCl
	MpP92Xo8epQcpgnupc2bVvTVW/vbtR/d0mAQ3srLKTuyqIB4OIaBG2jSwuyxlrys
	gaY3TlgfavIKeHdLkmvzkr4NsuV32SUST3H3JdL2sojz4SBKZZMAM7AaxfSaV2ze
	t6CEuJUml1fXqMCfSS7r8DdADfNr5QCHhFmbmvTzOW9l56L5o5QK+AiKQyQk5he2
	+AlXGyWlZhxLuyBVemKy/VqTfBPBMcGNw35UHDxS3tW9mUgz3lSoBuwA5LZm+FUo
	KXY7EyJZ0gVfT4ZTMBc3D5i+m2ka9YVnc4rZ6+bk8T90Qsj+gV5g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w3whs4j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 19:55:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PIAv70010306;
	Fri, 25 Jul 2025 19:55:23 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tdf0vq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 19:55:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VLCHM6sJCSKxa46j4uWuXho11u7TjcBSzCpP2Nfny0osZ9/8zxGl0mPutKANQREhHznpVMVPLMGv7ad16FF8u7TsYt9qukE/BXDOokV9qtLaG684pItWK9vnDtrzwdLvVs4W7kKrDOfTvezkaAuU/Xh/kFOUsWDJTNfVWUgpqsDKL8UnKnjIAex+XRQDhzBy4f9LjSmPfp1fhx3yShXNJPe9jta6+qUV5WXF3B0DVOcEsVafR0b91yXtrfF0bcqbX6akW40imHxMqb9EjFEcEAZU7i6CYV16XmzCDwD1FXdFOI5xKfIsStGVhfI7r8mg7sWePxQGEDvAyUYbgAQ9VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FvGzvDb1MeLYqgmsWwSYbYBRzfKYDSg18kFoThChvyI=;
 b=kVWdTq+8p9QqcRvandNbniLrpjqi9fnnhb4RjwzpkjKhM7PUxIeZ8A72+NqiClIYEyOXI+WS7ZHqfxlAZyBHOYd55+5j+wpbfJ6/hq21KSJF77MLsr7w62BBTh3e9bK2ZfFMhqDTJT9ID5JvwwOsgNiA1E7+XNf9nV9Lsnezcg2dSzTEhiDH64voH3UlEEN8IWYKTjPZ44F82sf4KEyuD4vU3U9gBsEScl+Wjc+P4MXBmThe7Tosu+H+hfJUB4ZNyX6umB0I/eAOZblYjawtrC2se7NkB5cKFYECe/MaqvkueHv2m5FY+r3iF2Bfa9ekbZPYu0Nbxth7H20i6iI5Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FvGzvDb1MeLYqgmsWwSYbYBRzfKYDSg18kFoThChvyI=;
 b=BG+LBDEsxKLQzUWiF/AfyMAL41/lBKXnhgft5n6cc4V9dBmFOCOEe8sUDz/fxzcrpQdiQScDG3trTW7L2O6JHhYAUajySEe6weTRDLUGvnUHnYGVnBBYMh8Bdq8cdxE8UM/6xBVMpIJdet+ZSfJTEVzjkZ9NO0mSnhCRB9JSCHg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8138.namprd10.prod.outlook.com (2603:10b6:208:515::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.29; Fri, 25 Jul
 2025 19:55:21 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 19:55:21 +0000
Date: Sat, 26 Jul 2025 04:55:06 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Li Qiong <liqiong@nfschina.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: slub: avoid deref of free pointer in sanity
 checks if object is invalid
Message-ID: <aIPhGvYgF0oC8kDa@hyeyoo>
References: <20250725064919.1785537-1-liqiong@nfschina.com>
 <996a7622-219f-4e05-96ce-96bbc70068b0@suse.cz>
 <aIO6m2C8K4SrJ6mp@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIO6m2C8K4SrJ6mp@casper.infradead.org>
X-ClientProxiedBy: SE2P216CA0205.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c3::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8138:EE_
X-MS-Office365-Filtering-Correlation-Id: fd079c2a-1ae1-4125-f918-08ddcbb52fb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gzoPV5s1gObJvM25StYIQBC11RCOBmBXhPZ5YiIUhHybfqZXCz44kHmU3d0m?=
 =?us-ascii?Q?6GmevYlUcGQT4hVv96CEEiVHeRwDPiTT+tCCXmMMYKGTzWxdcR7j/C+ZH4HA?=
 =?us-ascii?Q?+QwnhzdrjSPn1dy1J+Dy5Jf/V6iZruup8tUkQ8ynUXrqon3BM8+3pAhQcbQ8?=
 =?us-ascii?Q?crwGl9zzBtAKf6l8q9MjG6MX6tLQAlka5xEpHP9mNns0af6cnTjPpbMng52p?=
 =?us-ascii?Q?LchQtzfKzb/XmKQCYuYEXrbMUjOT4jTb/4TeBziMHE1Da12MXdqeD+iZKNsE?=
 =?us-ascii?Q?5ZygF/vfrPoPtbNKBhDzNf2t2CIqUikvvsCVfLjyBkgA0xq34prmZjAaRj6u?=
 =?us-ascii?Q?jhsyWjoC/26MQ4qMLQ22Wnd4SAAVRbCuPlRABvsYLao27HDFCh+eks4vW2Xn?=
 =?us-ascii?Q?fyszh4sbFL1HyHrrHp+Dhxizf9/WqJumdY4iJs+/132D63kaf1VWlFejfkYz?=
 =?us-ascii?Q?GGevR5FzASQSlggI31n49ELtVsmT3Tix/xdLO8zSCxyhhXpwqmr3a5Fu7a1i?=
 =?us-ascii?Q?1DFNeGC0buFIAk8yLwiIFPA9ymvd8hu+6a2U+jQNlvOpLFmxlmnxtS9lENBD?=
 =?us-ascii?Q?3YPnuFQt5RUMDSOFZXAbYggBkFtkc7QBKJL3M78kwtSdtpGJxNCZBC8qwrhN?=
 =?us-ascii?Q?hCtebl46PUpC4BP+ZYzlz1sTHKS531xvSFop8KfJPKh80oiqwgsw6pJuJ93/?=
 =?us-ascii?Q?1ObpaV+suepx/2VnsqO425HOujv4aJvDLg39eZVr06o+yAkoAmVG9TCP8XVC?=
 =?us-ascii?Q?SPZbGNFahOjFaeVL+1TAcFCCkjQp7ILngyZ5x/WIQkA3czXyXYGqcVT8P0ne?=
 =?us-ascii?Q?uYvgBiK+acz5JCeAmW41qpSVl6ovN/YVKwE27QD/KsvV9XiiWfxbQzf1q/0w?=
 =?us-ascii?Q?lNyNkGYMkbZpOVXSQ/B1FTylNo5VbdQWC5dxe8zNXdj9TDehzJ4GNMwIzRW2?=
 =?us-ascii?Q?TC4cBwQRTKmapgi/eWh5tsDGErn9FaqV5VLwKEIsi0RGx/toKfz1RlyI6jyn?=
 =?us-ascii?Q?NKYCMx/VBQea7iOyTclSL/xkwrQzcenSnGNMK4KPBJnJOs6ybhuqNccPHuQn?=
 =?us-ascii?Q?QP8+E7K2zgsNaWZ/31fFYoMQeUDoZ7GkUfx91bvI51XpvJct2Hev423Qpbx/?=
 =?us-ascii?Q?RLMcgMOAjOQWTJe/LvCc3e1Pp24cIPeRDrQkxIFi0Iowzvfx37fSlGG8z2hK?=
 =?us-ascii?Q?+3ubkYRMktARpuRjrs4UM1GxfADMvZxZGv98AD+pLWDIcYq0ApqeyYxslXtl?=
 =?us-ascii?Q?M6TjM9N8Eg0dBLyEzPRvepa7CKk1HfzBkA2RBkncaLwCSMOamUHpPESdu2vE?=
 =?us-ascii?Q?u85CDVpOOD8ZFFMlCJ1dbx9qUbm4TEkchUJbhCevRpk5IqySlJMHHFzKTNI3?=
 =?us-ascii?Q?1nPFlQUq4/pbfQZgKAzr5h6DAcEmshRq1ZX2oMUsr4SAo/zsHtsWlJ/Gxbjk?=
 =?us-ascii?Q?yka9D50lf2w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MfLuJ/4i3IBj7cR49fzuPFtSwghpSGNyRCqfm5HedlIWXinclMzBqV0Lt9Yr?=
 =?us-ascii?Q?P1qjwJkJngDy3M7RZFeJYLcBCoeq1Ls7ad6SfCr0b4RALowZPLJ/InN9SiGD?=
 =?us-ascii?Q?DHoqIOiDsn1lapO/J9o0qAbcEyRFalrnHHmoDC0TAotCNXcmky7dZcym1EiQ?=
 =?us-ascii?Q?DjoUJWsZvHnICfZjmACw1EgP+6WMigfE/14cwUc7vHg7IVZ/2RfxJEyqlt3b?=
 =?us-ascii?Q?evvdJoNaBBTQbGy3DOhcwi/Il9dvBq3kopiR2Rs8NdfDyg9xTKAJ3s3MtaD8?=
 =?us-ascii?Q?q6wQp2yrv343QbSyVIYoEct9pUBlCBqr3TxDjnKewPnPdD5eCtHe8P4LJ8CK?=
 =?us-ascii?Q?3x8DDlHDcvqKQpwreI7JpsoNzQEpYZ+mCiEa9OSZvrvbHhTZWwtgVeXfheY7?=
 =?us-ascii?Q?F3WV4amG38hv7KvUqwf1BhAnAFVc88Ki3zEDTehab8NY921nYJa9LxvE0+l4?=
 =?us-ascii?Q?Kor3v2ZviyCz3vEuMed9c0GyVxeapWwcJmOjjLy1tQyKiRhcJkgvfz6LrV9V?=
 =?us-ascii?Q?vOrVpeUR4brk4GSt/Z7uMdHF46730TL1MSTnhNJaB13XClSLzxfILNeosnwn?=
 =?us-ascii?Q?iW1X+Si9s2CGKzekQ7J3+N7n/0FySgqPzfk9jm1DJleyeRucBQoW2tAENqG2?=
 =?us-ascii?Q?TH7myJyc9vVzma5GgfHBdTYtYD306p/6jP/E7fjiAfFDwqMyhueYFJAgm3g5?=
 =?us-ascii?Q?g/xBjUalt6d+x6htBbac3a6+4cc6huhbkwKtzGQVpvWm6i3O6owHzWT0Crvv?=
 =?us-ascii?Q?mdYpgqz9GHDxwF1wTp1o/Q5K3WmsMX0rOgUTma4LgmcO4/SjYBYWefFcW1PC?=
 =?us-ascii?Q?PjAMj60un8rQT3CpOH2wW7Mw9IHNLary0REzXfd7SJ7GDH2WzKiD3j0Z8R92?=
 =?us-ascii?Q?zqjBApdKVt54wggH11gptIXAllioy010CM09WrTnwIUJUBlfZoGOdq5h09Lk?=
 =?us-ascii?Q?orgrr8LZmLW28xi4hdWf1avn1NiEb6dkCdWV9/egC3+tH4vu6JN/WxGFkSHi?=
 =?us-ascii?Q?fLOtUGrxb5JfGpSvC8IqS9eycKmYX5YUHC3+2Mte2whtEl9/IScOjBfZmcoE?=
 =?us-ascii?Q?mluX/IyKjCCXMSDUYaQCv68Kg5j8/Zlt5gjlP3MVlzhfdQEVGRMDX6SP3RVo?=
 =?us-ascii?Q?Hee1veEaWEFI1Nz/XZYhBiFADG0tZDTgIGJQWrAi88/0o9gSQM4jCkB7DivN?=
 =?us-ascii?Q?C6Jixre+/gfCVTknYYLZkundPozGFgBHS8VuriVH3R7j/fTA8ALgUXma3gjI?=
 =?us-ascii?Q?lrXd/UHau5i/RdZN6i4OlhjYoOyFCwRxC1V5UZTcYRUMVUTpQEcpSW47fZmp?=
 =?us-ascii?Q?astI5WcgJFi80a4s5VdcepnHQdVdz2tn5reJC6FAleWthaKR498Thu+wXdLG?=
 =?us-ascii?Q?4E08xezu21H+IwYFVmR/ngJJXahBa7PWu0xMKm+sB0mLPjXU2ehaIyhxYpL9?=
 =?us-ascii?Q?6fJkfi5nVEZ0ykcIH3GeQzBK4O+07CJizjfNUU6tKqYC/UEXpFQeCNbRzGK4?=
 =?us-ascii?Q?3VBINzwiCDAyOPhZs8BUJ1NfBH+1vzfjsMVbckHEYl2ZNH8Y17X9DcEynZuN?=
 =?us-ascii?Q?eR3gQ0iH+/jFdhDe5eSYxcAk51iAl1R/b6ry8m7D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OYCp3hsY6vXw9bZYI9MngUJfpxbf1uZd2/NKlNwVKk3ruuftFWhno/sbhd8gv35bu6yL956VyPcGzfJDRcNI2SOwaNNi+sGzvwMXqKnO7ykLOOb0scNwz2jmg+RdgMm5G39Wo8qBWM6skJFz7mwlksC0KILPbQN2qJjy1UikvSqVmGFORR3+R6jukNkRaXB11XmxqXtI8HXyxiQBXNtdI3tmL8TaKokwV+9PYJAnXRPHI2hZEhu9c/uZswiZ3gwWet57sg5fRCEtvMBuasdRj+siLzKs+tLAF40PC6UV5hACM17qpB/zpEDBw9YDpcoaJI3UsYh+DUG1wOoxLu0w8i9H0yNe3W3QD2nJlhcnvDfZ1XLBTbA0Ph/SCZDgrFAmMak0PuqO7uyIBK+uyVp6DzV0KkSIA9SVc4o2dP46zMjTi/hkrEJKjKLfvaOQedbrap3cNxYVphXXZrrTAJoKBt7TcgAKj+87E05+Wlmv8javxDqhMbVzo/2i2YckBRI/0Ur90tvgrGY+8m73yxWo9B2pQwn2FyTu9E9FoqVIW+ezSxhKy4rKOw54zTq9ko9Zz7YOI7T8wj6OgpT+VeZxYi5BN3nZKCoqMrBsgqOt4Js=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd079c2a-1ae1-4125-f918-08ddcbb52fb5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 19:55:21.0099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USgh3rJvn9Y6qgHHIvU3k4Mp5QRQzulLeIPzY8bbMDOKCT3TNIm4R0NB/C6qx63Ou5PJXbjjlzERVb+PQmbB6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_05,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=910 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250171
X-Proofpoint-ORIG-GUID: xAV68KwtUALtxB-4uvTMhfhkspebmWPu
X-Proofpoint-GUID: xAV68KwtUALtxB-4uvTMhfhkspebmWPu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDE3MSBTYWx0ZWRfX2v2M0JU+kyL4
 VcdPdEm373DUfBX0ImwaA7zaIGdLT7y93XeNFcFYitS4bhAny627LcysCTIDrD0oocvz5Z0Un9x
 zSLNlHqt21gdLMxNT99GE6to5y3HAkzmo3x8sIKuUfOVOC4zck2isu4FvZrkfTLwogyO3kX+8XW
 BeGogE0DIm7Rxb6muIdWw5ALxV7VZD3zdIDU+MYg3oGM4P0T0WMb4uSWTX6LBwPOEhleUH7g03+
 5pkyWWHCPeCkkE+w1G7Si6+Xu6ei0W/qI897YhgsafygajG4LciOMT1Byn+7tkFbyV9ESuf2STz
 3HGnJoUJIAMFMdjjQUEvb97QwdGkNz8YQeQtyc4WJnG77QKQ7Xcf7CdtxBL3TG+GwmkIv4OVQ+N
 2n/GW0dMB7hxxlIWalEfcHWUhSvJVUe9liFRvA7IsIbH2jOz9NDxX8/UjyWynpr40gyTRL3I
X-Authority-Analysis: v=2.4 cv=Jt7xrN4C c=1 sm=1 tr=0 ts=6883e12c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=SlVAvriTAAAA:8 a=QzG9MNd7Bwq9pSN2YRcA:9 a=CjuIK1q_8ugA:10
 a=aG1IO9y45icA:10 a=w3jF0Avn4CIA:10 a=qesGs21RGGeVIEdTuB6w:22
X-Stat-Signature: xfc98qnnuj7brhq8kwnaxuxijdaxox1b
X-Rspamd-Queue-Id: 9278A100002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753473332-898497
X-HE-Meta: U2FsdGVkX1+YTw5EKeyq3nSBO/4XgN65fIAQHsUOvRj1oQCEXg4Q3SBJK+AfxCaVGkvd+aeOpUYJgZTdvArowCWtDQ//MhoAJ3NZj6yitEmLKpb2NbPQGlM+UYzKi71MLSA6Tl668aCoj0Luuzu5H67As3LnhWXFyPmioWCsxZfN0GbeB/twSpIk0O/RzweurAygt3ScSdZyudg0tFO+M0GJaEimjn/bIdHNuJXl6AhvNo241k0W4Jit7LwXjfKLMW31Mb4cqXf+V5dIM8wlqy219kwJBBxushoo1pBkPcGfjMIR+rGGaww1w7ssMMWqeycndEsh2mXH+FrLTUJsb3wbHFB0dngCBF1+qlpYA2nQuDib2C5IhctoU4RjJhTvQr2Gb7pabz1VkXbzRYNOaxrUjCpK14v2ed8dYygzJ2v6pgUiREs8GyYQkqtkLbBGSd0Pui1YouhGvjdM5bQM2eEkwvAaYijIaqfLLcCG5b2S/E8bw9OtdBxGMuz2nvlMmtPbdp4bKkZondSlaQ5majQSZLfKHu/NriEHpYTh4YMqsIiOzoChy+5YKnf1Jwd+eqeBJBn5qWD575J+2SRyyUEUPb5mz2EVVk+iPph+7wQe39skKTv7ntpZ2iVCEiRzZsD9nsZKME7H22whB8/4OWiQ2WJLHI1XKiI8miKENkLXviutvmh0X8PbJSDZTWaNuRT0p4o/pW4atESj5gM7mqojierSYIR2aQXwWfwekpH/02n8eH9PPHey1OM9yYxZ9A8eEQM5JA1JzDbKnpcqeSQvtsCZqyzoI/5kLh4mTtWN8ZD22xrdTJOSZkLrCJ/O6JC4a9qMKWySBzhZuGm19OTX2faHjiN2MkiwTX64LRBcAZxHiJUKG13vfI/k5pAi/lggIh43ziRKcEQAsmH9PH+opi32XLrQoz1TTRqcTmDjSeMP97nT8bWuMRCNdIdgyhcO+ak7XuN00MkisI/
 IPBR+SjN
 59on5R2/+KS0XqZ4xNCH9+Y3oEDAs0/rQsbfqo2UjzWIQXdkt2W7kGTvfTKaPD8+B3GaUiXq6DZsCDmsERqezXXxS9y/Gn/N07ZniCJIi9w/JF5N4aZ6SAheKeTiDTpKOmhpsikfHE7VprHRrsRJTGG4ADzgGED3145XNzYTvLj0EwrFGdEKL32Tu8JOpahjF9u/ZWNk8b87JKdsAJZvP0xzLrt4+NfRLPEosifWGO9OULCtVLyfiIkGLf8pAfhBGsx05Odx2zRfP6HXkNKYnAr7zFXM3LSMYw350fjj8Ayn3yGhH8sx+wb/z6UWQfV6LBURh9xA3Yc1yU+w80OMpB3KFU0KgpZ59YzKMVPg0gr6YeH0W5MGnK7npO/MpM7ZjbPLA6SjlQ4IIFEpH+avYe4hmHWZY/G/N/N0mtnhtYEs+e/B2FstXL2cVk7QS0H+NUrjOOHawQMH/a1usYm0Y0FH/L/NxdMQxotg/3lq177i49FBbmDzAj5l0Cf3BDBB3MefbwMbT4JCmkaewzwAyC57ZIIkQXWhegQDYdYwv7QydkLC7ymY6ep/KmWAh3I+ptPesWlcFZon1PQpzrOz5qg8Q7/RPOtWGhy2aVEP3juWjOA4crSpvoLZiBw8SVm0MlVFLlC6MvE3nfMhX7pje+G0bDMdvFs1BsWjJf106aQepU+y8yJ4x2SOjHJIxfBtBC9/vkziNv1U5o8/ZAMTDILYFmGCZIjmvfEn1DaTI0wnUWtE1QEXTIHCaIAHAIscEJfqVWe8CXK1ne0h01ugEm6tFmrfPE2QD+EDk2RjNx++jFzs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 06:10:51PM +0100, Matthew Wilcox wrote:
> On Fri, Jul 25, 2025 at 06:47:01PM +0200, Vlastimil Babka wrote:
> > On 7/25/25 08:49, Li Qiong wrote:
> > > For debugging, object_err() prints free pointer of the object.
> > > However, if check_valid_pointer() returns false for a object,
> > > dereferncing `object + s->offset` can lead to a crash. Therefore,
> > > print the object's address in such cases.
> 
> I don't know where this patch came from (was it cc'd to linux-mm? i
> don't see it)

https://lore.kernel.org/all/20250725024854.1201926-1-liqiong@nfschina.com

Looks like it's rejected by linux-mm for some reason..

> > > +/*
> > > + * object - should be a valid object.
> > > + * check_valid_pointer(s, slab, object) should be true.
> > > + */
> 
> This comment is very confusing.  It tries to ape kernel-doc style,
> but if it were kernel-doc, the word before the hyphen should be the name
> of the function, and it isn't.  If we did use kernel-doc for this, we'd
> use @object to denote that we're documenting the argument.

Yes, the comment is indeed confusing and agree with your point.

When I suggested it I expected adding something like:

  /* print_trailer() may deref invalid freepointer if object pointer is invalid */
  WARN_ON_ONCE(!check_valid_pointer(s, slab, object));

to be added to object_err().

> But I don't see the need to pretend this is related to kernel-doc.  This
> would be better:
>
> /*
>  * 'object' must be a valid pointer into this slab.  ie
>  * check_valid_pointer() would return true
>  */
> 
> I'm sure better wording for that is possible ...
>
> > >  	if (!check_valid_pointer(s, slab, object)) {
> > > -		object_err(s, slab, object, "Freelist Pointer check fails");
> > > +		slab_err(s, slab, "Invalid object pointer 0x%p", object);
> > >  		return 0;
> 
> No, the error message is now wrong.  It's not an object, it's the
> freelist pointer.

Because it's the object is about to be allocated, it will look like
this:

  object pointer -> obj: [ garbage ][   freelist pointer   ][ garbage ]

SLUB uses check_valid_pointer() to check either 1) freelist pointer of
an object is valid (e.g. in check_object()), or 2) an object pointer
points to a valid address (e.g. in free_debug_processing()).

In this case it's an object pointer, not a freelist pointer.
Or am I misunderstanding something?

> 		slab_err(s, slab, "Invalid freelist pointer %p", object);
> 
> (the 0x%p is wrong because it will print 0x twice)

"0x%p" is used all over the place in mm/slub.c.

In the printk documentation [1]:
> Plain Pointers
> %p      abcdef12 or 00000000abcdef12

0x%p should be 0xabcdef12 or 0x00000000abcdef12, no?

[1] https://www.kernel.org/doc/html/next/core-api/printk-formats.html#printk-specifiers

> But I think there are even more things wrong here.  Like slab_err() is
> not nerely as severe as slab_bug(), which is what used to be called.

What do you mean by slab_err() is not as severe as slab_bug()?
Both object_err() and slab_err() add a taint and trigger a WARNING.

> And object_err() adds a taint, which this skips.

adding a taint is done via
slab_err()->__slab_err()->add_taint()

-- 
Cheers,
Harry / Hyeonggon

