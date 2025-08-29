Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D17CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 17:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926296B0027; Fri, 29 Aug 2025 13:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AEE56B0029; Fri, 29 Aug 2025 13:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750446B002B; Fri, 29 Aug 2025 13:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6866B0027
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:31:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00230119C1D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 17:31:31 +0000 (UTC)
X-FDA: 83830486782.19.1591C42
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6489F1C000B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 17:31:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GmvjB+kS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iGZmtxzz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756488688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpNOpOt77gfxGJpdlWLXfxd53AoBU17VYrlk0chHqk8=;
	b=bFipyEkv2KK8yB6TurOIQSo+OF/uoeXDOemyj9PTSPuVZwS7iEPdE+3/CuP2O7wAoLSSoJ
	+EmLAVxRFHIpeeN/ZwzKfkquk3jRqgeu3MezRbZBCR/4xC0/lCDZZDrOL8nEMNoSL3DgaG
	Pq2a3+ygd8zQhR5BQwuOBvWapK4RTNc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GmvjB+kS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iGZmtxzz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756488688; a=rsa-sha256;
	cv=pass;
	b=0XCF04P49fniVzwbREQIsABXXlQ49xEuk/rSni4P8z5bHAXSrEagwExCA97Z2L9EaLEOZP
	KboGU405x3e9Va+UJMxCzSaXWKhdUgrff46SiFmgpSnf6i8gXAl3dVv6ym53UT0veT7Nxq
	jmhl29puCfvwhIUv/Td3pSi5XqgeANo=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TGflje016099;
	Fri, 29 Aug 2025 17:31:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CpNOpOt77gfxGJpdlW
	LXfxd53AoBU17VYrlk0chHqk8=; b=GmvjB+kS+AbbOjKyG4lOJM6DamUTht03V0
	Kv7qiUMnpmx/V76RJOMSaf3qLYVQfGyhebAkwaD8U52teO9cNgwkmEfhWfQqgGoh
	QKtYylqhVsKBv2ub4tB1GWAomcEVjeMOXYy+WUb3tny7f+tDIH6xINVHbw0RtewH
	p4jpqjvpN4KTu1DyjnSun0vgqXpBDOMOWoSx1M0d9FmfngEon9zdIMUl9G5cFPfC
	mLyr92CqSLubE9PEU2zDHzQrb2mhhTRcHmMVAXTmLuiWaITn0KvBrwFjZwWcW0vp
	mUTR061PTWSUS+kGUqV0FgPnmYoi/VpR3E4VFyIZhS9oJVItPiug==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q6792x1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 17:31:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TFsiaf005016;
	Fri, 29 Aug 2025 17:31:19 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2089.outbound.protection.outlook.com [40.107.212.89])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8dnegh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 17:31:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UHkX/SuiOV847OhlRchHr/n2GR+PZXb4YqUdE5FW+fkZ2/qjwEzXvrgIZ5ASJ+bP9cLh9VIxSP4W2scJkQ7/VJgZyEJpvQdh3y/vgDpRdDEiaJkOrfzV8GOQ8LqnFDUoOu3x2ZH4dHzE/tY+LI6E7Z/EBZW/c4VzCTWppRi8LUGoLRxOsK7l+XxJL+Bzbh1A6uC2tSlAEMtBnVeerlhr62oSNkcKk6Ca1q8N2vBEcPTnod1NHXLr0QPTffmnj+PbrFLLjVb6duG/E8i8HQQm8UPq+7Rlq/b0mKoBkiGTHfnh7/tQY2WQ/iQifCVVF9rUIPLYsdXE5ZfcI148QwN9QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpNOpOt77gfxGJpdlWLXfxd53AoBU17VYrlk0chHqk8=;
 b=GMHKLS7bLcw1/1mMcRKeZdnYdVMke3ZyFjk97iTO9kjpdy0r8TO7PYcFazXZLZYhq5DkL1ZcSGiJoB0xzERF8ocyJl+cyVN1o7dck6B/VSy75xZoPnHHbbDolwCJ2yoZHlvyhpVhGjsamiNtK3XssKhDN0YwRjIvyLsw+WjkFW+7iWBaxpTaR63RnIEGMTF8cbJ67t5uojf31EQLT8WWn9+uNGxvkpgxpLyKWpDEffnpgnntMRgecYuMyw6WTBUFIVR5NtxNlbi+Evk0r/QRtWc/pN3xvswMnU732eT6O0WKeKYFFWnyZVu366NesUTIzhuv/MQLMkoZC+pjupm4cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpNOpOt77gfxGJpdlWLXfxd53AoBU17VYrlk0chHqk8=;
 b=iGZmtxzzaUvcE/7QVCERIukNG5G5I7nVOHogTYggrM4uHytWLfCCTIC/bieBYk9m+DHlP3BEbx1PHZSQ7AgeBTL0Jt3GCUCdvG0DmGVSFO5wwvD0QjGWN3PFe3S82uwgFPAYNENOSNr9w4Dr+7/CrFcq0lFC1L25mMe+SJpOvHA=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS4PPF72472EF09.namprd10.prod.outlook.com (2603:10b6:f:fc00::d2a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Fri, 29 Aug
 2025 17:31:06 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 17:31:05 +0000
Date: Fri, 29 Aug 2025 13:31:00 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        lorenzo.stoakes@oracle.com, surenb@google.com, liulu.liu@honor.com,
        feng.han@honor.com, tianxiaobin@honor.com, fengbaopeng@honor.com
Subject: Re: [PATCH v6 2/2] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
Message-ID: <dn4tb3csfkdhbslps53c4do3xdtimcenz3lr7dtk2nl3vgd7xc@widrbb3kirgk>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	zhongjinji <zhongjinji@honor.com>, mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, lorenzo.stoakes@oracle.com, surenb@google.com, 
	liulu.liu@honor.com, feng.han@honor.com, tianxiaobin@honor.com, fengbaopeng@honor.com
References: <20250829065550.29571-1-zhongjinji@honor.com>
 <20250829065550.29571-3-zhongjinji@honor.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829065550.29571-3-zhongjinji@honor.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR04CA0121.namprd04.prod.outlook.com
 (2603:10b6:303:84::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS4PPF72472EF09:EE_
X-MS-Office365-Filtering-Correlation-Id: e8f0ffc8-297b-4a1d-cef2-08dde721d4cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AphRiFzn1V6s7D5bM/4ehhB07wl4+6D1DzGHzOPbKpcb9MOC503mH+QIdfqx?=
 =?us-ascii?Q?f/ijSj/XLYHMTSFxDI748hIs8ORm0vmyyAlQ7pkTEAeodNAPq5DQQ1vHLbtO?=
 =?us-ascii?Q?miPcvw2W4UBdCwKXTYGaJzxuQ80aswbWA5hDe9K/3w8ZvLMBxozgbmcj1B0x?=
 =?us-ascii?Q?KZMxZyn98iRVRe+x9222frWwidVx1DOqhYzLtqH4YQa+TDeLi7jjPZXf44Od?=
 =?us-ascii?Q?6jpRG+ihgepx1r5eV8Qv2edhCZCMpD93H03CXWIoISR/ef8u+WdVcjc/gho8?=
 =?us-ascii?Q?+EFWddGe7RwFI5JfzKfRPJA/pIsnb4bSEbXqYglLmj9lyrgna9/t0DJSeNZ+?=
 =?us-ascii?Q?+V91W8nXGaO8YdYwq7Of7LGiTG4CrVnOP4Um7ufFHixvaBKXJEqjjMPYCJjN?=
 =?us-ascii?Q?iJ3w86vCe8ABsmVDmWf5KN6CxEnF1McrbbPQxr3qAw9t1wguGo9Wp2036N3H?=
 =?us-ascii?Q?ZvmzUNa2VPTqiiXEa2GyU2z+DSM3sbkVDw29UuvBQCr5LkobWyL7AHdVllra?=
 =?us-ascii?Q?z8ik7Kp/S4LEeDsfe122j5Yyhigftl6FWUA6NJfTEy6geNXd3/S/3ajlF8jq?=
 =?us-ascii?Q?cZOjn28lZbYGuK2vToISlt0hKDhIp1WAnGEI0bSkd4DmFC6ddoPPdbxfPFN4?=
 =?us-ascii?Q?IQ8/H1RcvwYNqQh2tSwEyXUK52c0OhsEStaudG5q4Zvpmcpr66SVdoB4HdCE?=
 =?us-ascii?Q?N0Q/4S3MjgEh7NkjgYApat9Yw20xs7BEX5T/LbPW/I80P0zKZBqlpYXZtGZG?=
 =?us-ascii?Q?W2lCu5DHNXFrM8lZOO57P/hroK1LSFNv9cw4PH/ycrsX/3g88y4Rb+oPilhf?=
 =?us-ascii?Q?4uQb6vSYxOT3nsfGAMWvPernl3ZpEIlOUd26GHg5gz9gjvAKZpMrY5xKQRQ8?=
 =?us-ascii?Q?KwCrO8uROfY0w4VblK6l8LElf7Ngr8kLnsKgIeHMF38rr9GyujOquSUSdKOt?=
 =?us-ascii?Q?u6KVQx3qpYMcdBF34DzuQpfxlTZw3Y/ToD16cEDWxwhzj5z0i0o0vG9I0S7Y?=
 =?us-ascii?Q?yxcVortrxj6A7pvEqicfH3WQWv3SZ1bQvjAixga4dwVJb2TQ+ug5LhbgRUHb?=
 =?us-ascii?Q?o/tLU+L+voTYswth2jDUsAp+odV59W2vU+4qoZh5YjsYzTsFfznBCifdTayB?=
 =?us-ascii?Q?iF/ZAp1dxVbDsNI3jXiTiR5nTdjq7SePDvc9w1eat0rZaXPaw89kX3M4XQ/v?=
 =?us-ascii?Q?rMzx2f7ezDUQlY3dkuvtniBBQuZhRHe3QM/LnhpxFHANx/1WCkPwi5anxmLZ?=
 =?us-ascii?Q?ytPWled8gKsEMVj1yX0h5LLD9Fb2PrtED8z0NY6ODKwyLULss5WRZ6HWz0hj?=
 =?us-ascii?Q?orw0a6K9+lnYd4F091OUibgqtQDNYGHjfGITl21wyW0+QuMJ6ZVnH8uX7lcQ?=
 =?us-ascii?Q?gTkwbjiqJJ08DSX3UCDJS3K3vWX38AAfALAtfg50Bz/KTS/yF5B/rhi221cS?=
 =?us-ascii?Q?ihWxHORgeuQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u7vpvgiIepSTtqBs40zMUcPqZCVR4dLEhENQlz1QOIKVX8hnz1MT99FkhxCo?=
 =?us-ascii?Q?KTtORU/nISqrhVkuKY1ataSLIEOaLppjdHRqMfT+zhZxXRd2zv5k6rx5WhcS?=
 =?us-ascii?Q?b/1snZ7m++nr+L1BaZOx9jEj3vlC37yB0vvNckKsDqmTDh3dz1mncKa1ejz8?=
 =?us-ascii?Q?pIHsHitSrFw9SIUBbgWkbhp189BYqjmBRBGIhIbQpXzorpYtGd/w8IK33TBd?=
 =?us-ascii?Q?RW7kFqs2Jw0eZMofunvYT1Hj9bINEh0OL0fYCuVriP5fMgDPBkLWgn0UyOj6?=
 =?us-ascii?Q?IgKTym68Icr4U+QN4OlJwJsgthSzfxAkPUr9J9A5f9Re0PCTUXOAmWLGubY+?=
 =?us-ascii?Q?TX2hLGdYtTCnZgaM8VYQJzmxKaaKGCnIybJyYzadjVk7/W/kj4PhpBEheBs5?=
 =?us-ascii?Q?mAPMK7cW9KrW9H2CeEzZQET8tlhggbEL+iMBGBZKNDJDnFLnMGJO4gFHDl8D?=
 =?us-ascii?Q?Uto81NSnh7abHe+/LM5d3Fkbamj1DuTmiFhs+b3WcluQPl2HsF+/ZAtVrQw/?=
 =?us-ascii?Q?useeAvsqq6QVMwC2WhL5D4lI+nGb9lzgrInsz7J3rYyzpCV1zM2Q+mJcxrkb?=
 =?us-ascii?Q?iJ2rB2tOIXNxPdlXJ4kZ2cqiV/oNF4a4doOo90FPNCcGhJwDfVY9x7Qmwg0D?=
 =?us-ascii?Q?XKfBIimwbIhbisqKIKUuyTZEjZCOewlqlm9YNsXm48b2AsZ8OUSunJLCuIeo?=
 =?us-ascii?Q?pCN1MnGEWHyLC8ZhHHbj24NiwOowMRkLmtGrO7+KIarhH7jZXhI5dn5fJ1IZ?=
 =?us-ascii?Q?3zA/Jfhs3G7TZRH0Cw7SgBLyrL022XSWZ7w7nVa89ai1DvQMWJb9JR0djag2?=
 =?us-ascii?Q?E60UXej1veyU7sJbhBIqEUg8e701lWtCxFu56/vWEmsE2+Mbl5tzN+fjdAPQ?=
 =?us-ascii?Q?1NzU5VtFOv4gvpxwLzqlHvyV2qWdZGKGQXcyzth/T83Xs/AdZ40DpqcvbNT0?=
 =?us-ascii?Q?y44hliw2FvR4cyPgujowD7EfWlRaY8XKUMNmCrR9j032zlgy3loAzAtaHqOw?=
 =?us-ascii?Q?vciqMyb2kXmT84SqLf7LrP3KdRnsME4v5v7CJeSekrKP4pmRefdngUh4rYLT?=
 =?us-ascii?Q?6H+toaSVQHfG44G4d0+CSskwYQjY97TRYXpW3ARKCNECQODgb9qMHRu7rh4M?=
 =?us-ascii?Q?Nk9s3M3bTbEzrivTghAC4MPCzoBQoQzva3/DZOqKnRjE4cNl6wwBJNlqpQla?=
 =?us-ascii?Q?6RxDG9hL7LxsajYzmR2/bUEkyj5FwvXucCpsnX7Q0JmUa8MWRUEavNSkZON4?=
 =?us-ascii?Q?KtX5zUgjmc+T/AaTvTxJwj6vLUj/qsaVZ2YFBPCPfLd4SHe8RlRk+eR44mdd?=
 =?us-ascii?Q?7LrNmUe7bamDuI6SIQA6D5rwzVeol8BUbiSxba6+afXVvLIcq8oRCd8Urzdz?=
 =?us-ascii?Q?XgUDFziE46CoSVxLYP7nmtFHDJUzJiqmhq37tIrsD7elruY4/S0j4liqpzfk?=
 =?us-ascii?Q?zxPLOQO6shBL8ArFrjuveXPShnFsv0StjrqzDwTDXVzHIlIB7raL4jBOTtRC?=
 =?us-ascii?Q?jV36pBXRoBCHVm8qDBPP+BEEChzn2zlFOCNvSbmC9c3372lQWe9qj07DATkW?=
 =?us-ascii?Q?nbywS5dbEWugkWYLrn32Ey97TA+6Rt4UUCDHSCg5vE+wC7OXf8LQ08WrGM8Q?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2i9WHCeGf42676jNl2TnZdWEf3AzL9a8VGxuYXJh87bayb2Km9tHvwLkPMFNA1cQ9IGqJV4N8BSVt/iXRaB8ytVkk/0NlhuU38moxI0/Mt0G67Dyz3wd6C3qKL5QwehJYWl3zP19sCdulk9Cff9GhiY/vc4axcJjt0TOqGOCSyubJcjTxiFuIz4lp62f0Ti1mZ/2+7mPsrJdKmkq05eBsr6hgTG3v52g7hyvlP94J3NstyPQFIbPNIeBtjxt6CnogMKcPZbi3d8KWMtr0gLKmJPStkOX4mifczaFg5d1S7dknIE31AruWqPFNVhgk6CzeWajs1664lJnuvRRB0+lRRCV4WlQ0Ex9ulDuKM1u332i2/nHk0xEiJuYiJb45jfuG/64lXbdiazKJPedq4uG6mIarQYQMcWa5v4N4EwTq8VVJKFNdI1vENgSFhXu3BFiplyA2EuR3yglq3D5q9F4YA5AVBU/u2FHSGoqvOEQetkmlz4/wrz+mjjz5PmrXaXhJ8LPtCoFdiJvC5XBiF9Rh0+GP1nhpbiGQ2wCvn/wySGFcapoqalRJkSJstsoZQeeIJvkfsZvyqTx1M2EHdMCjIoViYmiHT6rs60XxueetqY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8f0ffc8-297b-4a1d-cef2-08dde721d4cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 17:31:05.0764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lZNA7FmvpIepGP+RxKw5J+DlmzWK+/g9TxcqsXURMCT5/w7tgKyieJLCxCdFnqxa87nIcSdsWBcSzCHpRV5+Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF72472EF09
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_06,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290152
X-Proofpoint-GUID: Fo3A4mYPtSf-E3v3leFkT51N2GFocxMJ
X-Proofpoint-ORIG-GUID: Fo3A4mYPtSf-E3v3leFkT51N2GFocxMJ
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68b1e3e8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=CvlTB2HrAAAA:8 a=yPCof4ZbAAAA:8
 a=bpcrAq7Q9ZrEWOtt_ocA:9 a=CjuIK1q_8ugA:10 a=67QrwF-mucXG56UA-v15:22 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfXxPQO5bEhHWJ0
 Sqx94d1z4d2Js8h19pCL+4anx4VUqxjXOpubTim9WeUfEX79OTAZm7FecYANMHnxdaEdwsZ4OwG
 cBPxce0m+N7NckUwEnHeNyY6t0uWjdniLEmpnjhCAssNoYH5ZMUyVqeXiRMmNM703HvkD4gLukk
 e22nj/5aLpBRjJqofg5ikUF3Xc9PHCrjCXnn+VP8oijjcVeGawIPF6mTz/i38YkK8db903l1wTM
 umU2X0cjUHmzUcdB0MS3Zhhcj5ioOXLsgbRUKtyRxCk/Xk/W0JUyhLcNSsgjj34KuXF4E9YkOtc
 EHeTk54i1JzYTeGd83ORbW/xsS7ix2iZtrdom5+RDv+wJai+vA8lWZ6RscPloor1ET+mrKTWu2L
 4uFVQT0eUaisa6NWQHmrqVG9CyfWtg==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6489F1C000B
X-Stat-Signature: kbbdxrsaw6aeaqoua7boe11idmqcad5c
X-Rspam-User: 
X-HE-Tag: 1756488688-392013
X-HE-Meta: U2FsdGVkX1/kcIg9N9+UK5O5b8fxXOGRI2C/KF+Xyqgf6m6vZBg0shV6tOFRtuGqzrklcNaGXaeNmTmr3SP9A259WQ1JZQJeElfndWEVhBz3FiT/hIlOb4h9MF/cBZAb/JmfiuohHmLNwBs127m7gM5HM49vrdPkNp4DPdX1aJFATOhVRRkI6B0P/8N14NPrmRcJFZ9JnMaBhxcBcZdvE4TrsvK8nJ8FXVsMF8RbmE2Ru6fDQsyytUs3hkxbTB2NzAt2ecpLqVGL/nMCN6ea4qKDezzXwnEcnpgjpG/VyOL1I7VBkCH4LB6wUqRR7dENgcRpchw/hMiq/aVNTS6KNAyeh/qE1l7uNPet2d+MU3EDuUpk68iAV4QKO5yhj6DggFjIhSH5rcus2CuDKq26tX3QnjxFWf38AnsdXodncvqG8ckb5YztjmX9FbpurHrCZpzbKTNv7J2/cDPgjnSZGm895G70/SezNQ3zodiB6E9OAa6pCO7S7Sfv4/xegmmnjJaggf9yWd6EvipxPx1t+MDbcq5q3Ve2VPmFp8CDa6e6Lt9D0kFRlO+ZTTBJI56c5LTgTyRJ1Um84HOHg2k0RaAw5IJSNhKqMKqSbnL0bXxvGL6bD7lOkrzoarwNIrMyS3tbcPSsT06AXW+7KQdFz7ds2FhnQJryT41AXJTADkWnmKfRKvj8BwjIhQjifUct8g+vr16Xh0k8n1ni+BLP0s2hIV7HBxECwbFkaywM7hwVcHlU1fHD/Hkmb6gdxCgd8YrOTSRb4rmVCUdTd8ZVXhb/43yeHFyFuqZj5yFfqrdYUsTua3OhPufi5Tp9/NVY8lGdTg7u620TY8QC3++SQD94EqaH6Nr4org3LotKuPikJv0wpBMZPwuWSzBuxvl0jGuwZtk2T1Ng24Jxl9Ay36/cYbp6Z2qTlHa+Reo6U6NMgs8RjdgjzRTrdx6WNjVSLGNwVa4dSnzpakau0Fi
 zZiYJvVT
 6+4LGRHW7Wg8g/j/vHaKQcdHabLax3jvQ0jlJHtXu5iS5qZvxMlaMsofeKrKpqwAvzZeA984w1bSLbe9yqVpQ+Iqri82DCsXsEtR73L4ZDYrEDoOLdEN/FtZd+i9xCX+s0YdBRWbKH9zTE6ojc2JKl9DYZQBjnZozRyqZAPRJyCkSqY32lqawL/jmxs2XBEdpSVTO+4twtAiZ3k8yxfn3+g/DtutJdqHMRnQFLCbkrxo9YMRtj1Vt+kG4Wn3FGFybZRrND+J+xaznOXHgWK3/7z9sweuSF9EPOkVgDSC0W7Xv3b65mn7YbSJePBGCPBYWmKxV4uiFZo13qDSVhuBtSh3TXv7hn48LEIkR6Sq2PjlYhLgzgD0jCmusFv363wHrUU0HZBJqPiZMjzT7k761cWswJ29qbVMMDV28NG+TvFOB+kVSEF3BRVeN7vOwdrTJc7exALOmqjr0UrrAWSSfbCQpnfVvr60pqKUkgGxsJRIOY5Caq+HQOWbPjWYChMYnuoVpDmeXostZVbuyoX3u2j1qYcqExjYahFCT9ytX0EfUz4CISZqkj8nWMJAx0RZKwtxo5PXBhuV4Zl3W0zfEg+XzpBT8lqu032HsLIWz4upqhAFW+1uSUfOSKIGVcVexQdhZvMFiIQt8Wi1Cdr91vn41nu5TT1Y2yH9eb0G4qNlqJp0NIXzb+GpZWHpg23xbbYVGx7RWT5y1DF3XlS/1+2sRbLMXAoAxFNAFlCzCtBH8VEPTUYiIE9dbFshMR4pr+DrI4Cir9OUjIFLrZOXXCrhMRflbjOqXuifISHNPZiMzkrhzHbWOEiGk4DP/1x27tf594jpfxG4x6rpn6J9+Wv1AdkwReCbJmpkbgRO906pIA+0KxDy0M7FIRuhJD61QfVvv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* zhongjinji <zhongjinji@honor.com> [250829 02:56]:
> When a process is OOM killed without reaper delay, the oom reaper and the
> exit_mmap() thread likely run simultaneously. They traverse the vma's maple
> tree along the same path and may easily unmap the same vma, causing them to
> compete for the pte spinlock.
> 
> When a process exits, exit_mmap() traverses the vma's maple tree from low
> to high addresses. To reduce the chance of unmapping the same vma
> simultaneously, the OOM reaper should traverse the vma's tree from high to
> low address.
> 
> Reported-by: tianxiaobin <tianxiaobin@honor.com>
> Reported-by: fengbaopeng <fengbaopeng@honor.com>
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>


> ---
>  mm/oom_kill.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index a5e9074896a1..01665a666bf1 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -516,7 +516,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  {
>  	struct vm_area_struct *vma;
>  	bool ret = true;
> -	VMA_ITERATOR(vmi, mm, 0);
> +	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
>  
>  	/*
>  	 * Tell all users of get_user/copy_from_user etc... that the content
> @@ -526,7 +526,12 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  	 */
>  	set_bit(MMF_UNSTABLE, &mm->flags);
>  
> -	for_each_vma(vmi, vma) {
> +	/*
> +	 * When two tasks unmap the same vma at the same time, they may contend
> +	 * for the pte spinlock. To reduce the probability of unmapping the same vma
> +	 * as exit_mmap, the OOM reaper traverses the vma maple tree in reverse order.
> +	 */
> +	mas_for_each_rev(&mas, vma, 0) {
>  		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
>  			continue;
>  
> -- 
> 2.17.1
> 
> 

