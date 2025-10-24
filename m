Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E43A7CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32D958E00A6; Fri, 24 Oct 2025 10:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305608E0042; Fri, 24 Oct 2025 10:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD418E00A6; Fri, 24 Oct 2025 10:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00DEF8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:35:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5C8613C48D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:35:34 +0000 (UTC)
X-FDA: 84033256188.13.D38B75E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2EEA280004
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:35:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Y2sIn5Lm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=r8zEKuQW;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761316531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WggVzHSyLeR8NoCkfBdmbeOPbQB4inyATvI/kHIiJhI=;
	b=iQJTnG9b8gtNOluMyD+UOkgmwbLIm6GH6OWqWoB++xwEMQYctMPyUtgg4tTJv0MMaEgfms
	pG35u+ptobnhenVxppn20IdeZYxpLdKOhr4oz+1g3Vy/bbgVXd17ormJB5VZxPA6WzaB+/
	QPbjlBS9YLd0vqrg52INkdwR6sUe1z8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Y2sIn5Lm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=r8zEKuQW;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761316531; a=rsa-sha256;
	cv=pass;
	b=fnHWJHiLaivY86p/5gs0Km0dY5V+KfmD2GQa7qUw9B1oXHtSrVC4/dRfsZVNQxO9yaj0UP
	+YvlTvRrKWwJaR258W1v2ENPkpdXUnM4WrQaOnuU2XOtr4P+qb25qlsupLFXooFFBabMk4
	6QXiF/mr1PunHmeZfSb/AjmdvLMxxY0=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OECJd1012809;
	Fri, 24 Oct 2025 14:35:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WggVzHSyLeR8NoCkfB
	dmbeOPbQB4inyATvI/kHIiJhI=; b=Y2sIn5LmSFIlrNCacvThJqghfJm/r8KyhW
	zsBW2LAN4/LqyE6eo/Q8/EgT6AQ109J6yEviKDJwOV+YrTM6QKeZj4io2SLDBOUQ
	xG4+fpWuJvNgx+AK48LWT3VEXCECY9qxtiB/cSFQiVNocVLULVEMaWCw0U0eqTnc
	Y7nosvJAnqcVaptxQw6NiZlQsH5gWzkN2LBmX4igIUJD6yxXC/ZZu/VSyzT13IBB
	IECqoro5I+S0z9ozy+hobU1ElsS4+4+p9KBKL3DzUKjapk4T5Xwh/V+qSQICwyeN
	IusKK8Oj6YOytVkagT+e8i4cMHzp1vKZOf1VI6g5Lo6z0NmlRNXA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ykah2n27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 14:35:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OE0jvC006370;
	Fri, 24 Oct 2025 14:35:23 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011012.outbound.protection.outlook.com [40.93.194.12])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49xwkag0at-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 14:35:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBPgRwVQ4gXg37wvwHWGpx5C1eaF3bONfuoTKuy20UJ2iX5pgeEtSPb5S6w2Ab8MSGeds2/anTEOShDsb9WakysYia+AGqQyrUxkURWtg/XL/eU5NiVscvZpmk34Zv1zOXNzJMV5loNH/pUI6lwr3+JS1d0lWGGfJDZGVcZLW0CDJsHjtV85wAA1nHItPqubfK2SVS/5KstUXkNLeOYeYWLYqrrXJ63jVL0JWzMEx9I1LRe/03DGoKjvAi1/JPFaqb1ysW7PqokuKL1hrXuzu8/BK83ZynMR07XJ/uVur3VX/WXvvtKsTNQMUTTzWV+MvrCt2D25yoFcLjgiVMVetw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WggVzHSyLeR8NoCkfBdmbeOPbQB4inyATvI/kHIiJhI=;
 b=sNIQ8VdRBpk7qdK2TQWl+Zni/T7bAHwzjzbR9KYS4GAx88BuY8/R+pLCVFTxm1x8fyu2KnJLmopyg1bu99p4L5EGjsvoke3Ib1hvl29lVSk22KaBibVdau0q9S+1LgXA2p3RflFND5vy4Yo6nUjMOWpE0KjRCFhMSLM7NFcdN+n1VXCIgDGwVoW4TN2THfqS/Zc+/yZ7HqaKCmN3cWXTI7ygDm0+zHP2hda2g05r10KnbflOSwhofux3YrJEX3qFa39a4df9Ww135c1hrRGFGMMvJAA11ezpAvu1VF9+YFuPM1Xi/a+HYLTTyOkadTNvZ7vGjFvKVCuJWc+MsyxjKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WggVzHSyLeR8NoCkfBdmbeOPbQB4inyATvI/kHIiJhI=;
 b=r8zEKuQWv7A13tb1EKFIGgXA0GsOUFEMLckMa+ow/BOaLMMG4GAFh0xcBIiWrO/D6bSOuv+sqwR1V2u0A/wnGHAvrLIFR0uBjkzUWhoIrrL5uHaU3UeqQkKutfKuo7riGZB8GitvVbf4JklSFmQlPc5OjUiIpAyhk6XxkbtuisY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5751.namprd10.prod.outlook.com (2603:10b6:303:18f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 14:35:20 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 14:35:20 +0000
Date: Fri, 24 Oct 2025 15:35:18 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
        wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v3 3/4] mm/huge_memory: optimize and simplify folio stat
 update after split
Message-ID: <2a518755-15ea-40fe-8f2e-6be059d13f12@lucifer.local>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-4-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021212142.25766-4-richard.weiyang@gmail.com>
X-ClientProxiedBy: LO4P123CA0132.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5751:EE_
X-MS-Office365-Filtering-Correlation-Id: e519ccfd-95c7-4c3a-1baf-08de130a8edb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XkwrWS0P1GN0pjIQbdXW3yiJkLQP167X62RPAptB/5NlL9pZr9CUo5kCmZTy?=
 =?us-ascii?Q?4xabzFX1kb4eLKxZlA1p97z0N5VxFaG81yT3hZ+jfs+Fhj8ALF/7drF29rwA?=
 =?us-ascii?Q?kQCtRrLLi06fv5l4i6vPRBkAz4LFfFjb0yt4OHhTCLMyF0PSoqBNNtzSbGyw?=
 =?us-ascii?Q?JT4N5jSyaLgxKIU7B7IMHJOuUNaKxrFtJS+QZoxO8nnP8t1k0ytxMKvYguo7?=
 =?us-ascii?Q?cthSv1iKoHERkVFYhTGiSf723fX7BXih151RANWMrjjGLkR8VX52wV0VP7rB?=
 =?us-ascii?Q?fV2DNlFTsNIOtfKhIw8Rfv5IXMnRwNJjxKkcYdWLrfIOTRkmSDsSs6AQFUJ5?=
 =?us-ascii?Q?4TaUuQiTdOnaE/DWQcsqjlwJczbpisysNhLiDFpLkxOEGyqHJ1owo7fKBwn5?=
 =?us-ascii?Q?CDBkYPp1tgo+fWUSJ32e8hO4cQDbN/hvUGn97An+jOo3h1g9XNjGFumHsjUJ?=
 =?us-ascii?Q?RQ1vSYKn0xwQl8NvnEMqxwNOkpAjJs4ShbaaTgzhEXjNM0OKxXRIaLld31Ct?=
 =?us-ascii?Q?QBY9ogNPSDJwNYNQDB3w/t0uvQdPRrsLpShmiL4ok/M7xleMyGAHst1X1yyG?=
 =?us-ascii?Q?u8+AHm6tbpKYmJMOP66RoIqW9pzuTOAb5l2h2m4E9zBri7TNs/4xkQaXMYnS?=
 =?us-ascii?Q?e+VEIkDbMRte6spFhRdVm3QhlkdtRFdDTq3Gf+l3aU3EyCZW92PwcWYHjgRN?=
 =?us-ascii?Q?wSsqE7kcCVHLRG6JutEVFFqIKm3/v1TK4fLKp+5G9y5xhVEMsL/77j0Yvy5r?=
 =?us-ascii?Q?rZjSqTgubYa4Lhe0Xi7RoUodFwBg9AjF9UiLMKHIM7X/hJAbBa7VcdkNJlVt?=
 =?us-ascii?Q?mfbmwRo3va90P1OWULJjLSjf7qy4+hPuLTQpnZAswK4m4Q4z81BG/GZn45jr?=
 =?us-ascii?Q?GGgKiOw1V9YYpfT5f3nWRxOQVU9cN38Gb89Kr6MJMZjA2Ko8WsLsBIpX50bB?=
 =?us-ascii?Q?JyTCrDzlwjV1rd8Ht84VUjhgGEI7Z05xon4DUeXwDdm+Ajc/jVRYl5a1i/Go?=
 =?us-ascii?Q?FIM8rRcSTvev5UeF7YyRrlAg8y301Q/NR78fFREgxkqyq0wCMb0Dm6aRsgha?=
 =?us-ascii?Q?U6ZzDwHJDniQa2nSHyUsTCuUEuUgPfmbtasC18bTDq2YVaydy/b52cxB5qRg?=
 =?us-ascii?Q?sOHITSoD7bxIMQUfYF1SNhrvGO7dcUryJrz3mDnTVLFEOhZQoZpFJnE58HHZ?=
 =?us-ascii?Q?DnHZDpT8ncwbAHL8fi5oYCkmJjrJ4Q4+PgBp98RL+1ApyO2rkeuAzGGZp3l9?=
 =?us-ascii?Q?fPT7AWIZxT4yN2+2eZMgeTsEUdZjtw+QII1cBRFxkm8OYP+KsLcVNMSPjHCy?=
 =?us-ascii?Q?8fnvqPSZbnQXPQ+8GO3dRUCd5LoZVKJZ1TaQgrOjgLd1cFWPxpNf5OjpWLOn?=
 =?us-ascii?Q?Jts8kz+BWX8/3gBr4+lw8k75rBDxxRgSqHouiEo0+cjWJpJg6FHLS/5Yswmw?=
 =?us-ascii?Q?hl9ZoI1Giafxmq5msBYkEamu9ut0ESZc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ftr/Z/oi+rGGe6lmv/tDpeF1aqov7UJgssxdXKO4ZZ2iVeMqrEHNMmZf6p7r?=
 =?us-ascii?Q?RDt8lS2R/Jp1VoSQgna4wmQBQkPK/UxeJbFx36y10x2Gsvcl/Qn7mvuTcPVA?=
 =?us-ascii?Q?remx9p3XKRgehS8aX8KHdsJSZBP6yGb8CMh05z+uFWucXeY87qlT0r7BpmSs?=
 =?us-ascii?Q?QiwTMamLhewSXDjVWfYJd4JYVE4Xf9x4HsgRFtEvAqO7Vc4rsKquOK0mI6yd?=
 =?us-ascii?Q?Mh18BObrH+2AB5APPoUgzUQHMzAJ0R7S2wIXZeTmcA0oSwqRqXIQ5wKbc7TY?=
 =?us-ascii?Q?oOA4lWye+w/aCbjYuHswL2YKQnyi+Ve0wzXzZz9KJi2CqyuyANRP4D35GnKJ?=
 =?us-ascii?Q?BaibBJXusotSbdA/pJs/9aaTxvzXL7+EHVEMevYFvLYi3eIz6d5gGBQblIv4?=
 =?us-ascii?Q?93GObbTqD4N30OvOoV5B2N+sloWqO6UxcBNa2DKnqvItSXwWwez0GXTrB1oE?=
 =?us-ascii?Q?TELQ1yjHL1bshUuDNEGh8Q7HsdzgppuVWgD5eUct6htDNCek6rWYfM6AJVC2?=
 =?us-ascii?Q?enkxOf9gkZouXFcqkcaTNkx7ZFwM6RbQcSZn0chuMT9kZ4owiZ98GP3xn98S?=
 =?us-ascii?Q?7Iyqrn+qWgf+9ox1NPf1R6oGyP9m+wcCCWdU5YPyhVywVF96DRQvMbZ7JA1X?=
 =?us-ascii?Q?qUgyG5ixKrgyx3RxnJDIlW9B7ZfdW8oOVUTPhJVoEpJlMvF5Cyqd02MW2s5y?=
 =?us-ascii?Q?WwhpnTPyfqeZnub8YGIl3ZexIWThjsljy8hcwMlg9p/ygHIpgHS5fwT9Zt2+?=
 =?us-ascii?Q?Xb2jZOqjUyA2nn9Kt2TxM+HQkuvDUSTs4lkASyPIt/idAYJHwYYAoGE7Ew7d?=
 =?us-ascii?Q?gf9dp71xZ3lNuH9pAt9YI0+/1S7qG81SNyGIexsQefyiBI5xHeBpSPs8eZtR?=
 =?us-ascii?Q?bP77wZX9B8Zv/zGXAcp5A0+pKdBEZwPIO4V6xYgSQKa3tuc3DwlcmD1xRlYh?=
 =?us-ascii?Q?JPlwDx0JdexXEfKOqqITK94GsHdRSUwuUYcEAXFYQdbDbK4jSPWkYg8YHPUV?=
 =?us-ascii?Q?uDK3t94z0sPcWx3KYYy6p5z2j0Obcd4muUYl/mZu1+1nvVS8Exv7oSd+tLu5?=
 =?us-ascii?Q?tVlep/WueO0YelNqoVJnrYFuiW4kY4HkzOinxlfGSLjZY5kNXpDrITqRryng?=
 =?us-ascii?Q?Ab+diApFPLwW9BzXl4wlP3alpCPkWgl5divQASU5IxHJklsvjsFZFDXfedbl?=
 =?us-ascii?Q?4OtSkERKx1qhEc3zNJIplrSyMuZ1R6S00TQAA5gee3KWwwZJ8UmOwWBLeMt+?=
 =?us-ascii?Q?1F1L97lNCFarJ9omQ8gMyC8LRVH7hFVYUqHejUtluwrIOqs/c3ehmutE5BAF?=
 =?us-ascii?Q?pyyTxoI1Q5O+JVOi7LQuJ0kLj6eG5faIYeKRJ5hLjVESufDSw5p9NEbelqS7?=
 =?us-ascii?Q?gC/g5sSNxXaHHPTbC8VZ6KNm+0PJGNT5qLbUmPAmgsck+C0w7Jw38J2ZERNP?=
 =?us-ascii?Q?DMM+OSrZaXeF+wwYt9xrGNypFr9qtUtEWcMNTkl+aOwImUHriikblWyh8Xri?=
 =?us-ascii?Q?3GuJNZkCUyFOlhdNWQxgrRE88Y2pl+CyiMfqEnU6ODIbxl4U1oUThynMzQMv?=
 =?us-ascii?Q?croD/79Fdq1LTJWwVfNY3BKvyfWVQ4fJUxb3BO0hY5FmXy+hnHPbW10j3zT5?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	afiDdtGSdtrc616vlddQ0oWAG5yuuwnPqBehSvaIuC1rBDfmPW9GukEGq1n//Sh+FDkoHDYOpkgnMEc/yr4UiX/UpapwxVRbKxpYwM9QIGpwi3LX5XxwJHF4P6+o8hMkFrPE2Ft4GbHjk7+hOTDO0J/Lx4cIlUKtDlGyY50TR+YEJiRsI6iSgaTTwu7WbRhockLLIcCcgRlAekxqHEamGV8A2ORJCbf8BxLpKGQNaWCh3CyNFgnTHGTI2wmuv3WI7zMFcrC2a+35s3PZqZkHkv+RQhehdzARoyFuoVraEoPD2RFDQrsQcgmaIabq5v5NA0Jg6qQm471NAq5mTONSasF8BRkbYY9PmNnTsUMBSAHZijQRzO3Nq8tbFUhIIIE4excAEmjrZPUtBRgsDYyzjmnaAQHnxF+uxGb93YHyBtxd+BCRwuo+ewfNB94yKoZO5zn+675lE39EsEOHUz/U869Qi6TcII3TnxGrzf19HmqLxHV+7VjW09bVj5cQx3RDZKS8hWP/+jLoMQUUlUxSMP/evmH6s1NH5hdpTxGLJS4lgbBzpmS6JQTsKgenPrdnx6gkwxB3zw4FOL3hg/fGkoP9v7dZMJ7shTEP8EbMW7s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e519ccfd-95c7-4c3a-1baf-08de130a8edb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 14:35:20.1276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RfWf9KVw+rv28e2xxjSpYvwjq+6DWPdHzIA2Kw82Lgt/++K+sA5jQYdN78OsojQhX/7QxtPqw6NjJY+3ugnnmcUc/LriKk1M1LI7TbUtbm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5751
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510240130
X-Proofpoint-ORIG-GUID: Tt82cDaztQi27imXOtbVp2UZ3gkAEm1u
X-Authority-Analysis: v=2.4 cv=XJc9iAhE c=1 sm=1 tr=0 ts=68fb8eac b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8 a=u0KvptDUXjxDJ2SQPZ8A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIzMDEwMiBTYWx0ZWRfXy9CmtNtf9GGM
 /gscz+mz+ze1nJvG07NMW8j4/qY3S9/xC9sfyIwd4YNuQwnxkzVzTxc0jedz1MZZwdDxwwXWGiC
 sw2UnSCI/E1JnuoAXOC9oKMRB+obKYbJQFl2ffFH88Omg8fd7Ria4T0YJrwU5R2aoF2BYMP7EzP
 licaeKCrtvmqwG6Cg1470MeDW2L145EckrpE9ILSgAFQUYk/LMWNkZnymTVG4EndTMGz6Of0Upb
 XufZRy/IA25NdH01zS1uMpqnF1oSgWXsL+/MpZk0eVxZLpkNt8HaciMmVNw8a9uo7wKUx9Pb7SI
 3PhR/PNRstA/8wF0dmewtQishUiKBxveG53pjtBD3WC7u0taX83goB3arLGoyIu1jmp6Ta9ClkX
 3MFmNwMI27N450ZdKCQosMLNUYI74nqpJUIyyj5RoZz3G0bh7RM=
X-Proofpoint-GUID: Tt82cDaztQi27imXOtbVp2UZ3gkAEm1u
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EEA280004
X-Rspamd-Server: rspam03
X-Stat-Signature: outym7pftbswbn7x8mdfg15h88t5wdiy
X-HE-Tag: 1761316530-329918
X-HE-Meta: U2FsdGVkX19r85jwWzu6aojtC7p015TCDWgjJf2QoJYVxXFoTnqRiwnPYaANZG58quLdoHfPcsaWDA9VDZjrMbeZxGS6jbwhWOkYq+yqLWt10ApRe7S+EI55o9qYWWvzdwJHnFwt+dimtnI/a/pwDfcAIisec9yLV1QvFXvHLErPyLw4N9hyWJzDvljFqYlwVK6394z/FJptpUDv2IRme850zqapu6uYh4hEygaDBDJPav3spwUsqhOqLc7sbVv28CbqQSekvI+dt3DyaV1H53r3PfF2x/qAiz4o/h3p0eA3r1Jiu3q71mjIfCB15W2761/y7Br3WIp2mKCUeMXr0rJz4ciHm1vIjn5rGAqGEiNshF6sOPbp+9XfkKRP21Y4m/0Ks7l+jeEuWn8NycWj7K4f3eafMhiJp0SLORMEbii2rpEQPfIHrafDDmdV4HDZSYIqUOu91zTQhRExdeD3r1Z+OvJkCu8a+08bXn8u4sibOvlJi3oJ6aUVpc/gDxzigqImpwzaR2R0jhYZ5H1QlaBj19jXywCAB/a3SJnOaGH2wbJ26T1Re+OyMVjkZdmQHa7oTg27VvnzlxtUGshhEqgXEQ8ixo0FFAerMea/SnbR28iws9bQQw4/wF/VFWIkzY1GkU2tOfIzleGN9mUfhd/kF3d0rKyVjUqmamR8VK4xuvFjhmuH7PkB7WFlFub/BTR/kLpWmDY89E3gM3iP3zBlPQ5V4cZQPnvFhMEAsq0zJzKgIqMYgTJtIpzNalA9jtYZReM7/yUDrq0/lzhxbFCTfhWwBVNyA3UDILe9z0Hma4nFqujkMeTB+NVrV7miN9TTbtOl/uDLjAjx0tFpkTYSWavjcsikgvDLRIbh9zMnyy2uJbAl1KfP7VHhJRfxJZB2dSgATWOhBbTZHj95LOVyjWLqjw6b/bbwKG0r8K0l0Ia8x1SET36I9Q4aHyUHt8NoWwazw7Pb1EJMOcZ
 SOYdGLBb
 n55dkmcuS/5fv3ZQyxjWRomZ4dHlckzHlD59jO2iG6m4DleuT8gKtmqXAEOjuUW0gyqWniKp9CmRn+ZSFzvv55XakADxvKSWgCq+g6rGD2gIxb22ZAA86LzMPMSJUGjGAu51X2CWnOmiOu6RHklg3z5exqqldRf0mxE2GsDOni5u1L/YEyVlZHdkpVtrpnxM/MV/ZKWhTrwMO0X4db+7t1gPzcfaQxeoYrEFdcSrBZMXqxUGvbTX7bZypi53GJxILrlQ03nNz84mHSC49+w7ozmpWcSQY41JEP3WRNtr7+dgheUzBBPBjuGMpT0XWG/C4zVCcu9A5fOi4jfEyNScIxt1F3/eVHMobJMCI1Zev7ozhPhdaJx2NRSVI7Up+7U1sfrMLh0GVrukrJ31VieE5mQ969sq9dBFFsm5nZO5AXVy2IetG6D0J/59ITc23V7eBlBK35ILyJ0Q3BSdjT21Zd52yu+nTj93rcpe6zhj4S2qhQAtHJI1Eio6V4svY2aSnxWDuKxEYOAdfSvrgSn1xlwZxMqOvhfUvtKdBM44rEW7Q6ZfI73R+sQ9uG/yKS8CIVeV7CGB/8Zw99DdrNgnXnnqCnzull0h89jm2TgqWMIKdZOhTdfehIsuQx0XryjCOxT3EYvxadN/1r45UI8tdFSlf27QUz9iJAdf0eQ/ByjGAakAUpc1Ji7Em4AwtU+9MdigxxoqnOcq9krzgFBiTZzVxng4+Vb8RLqumo3vAN80u5PdjS9cIcccGnyvM7RWcxHxme4S7ZDARrQPhqXpWOsK7Z3UMX8KvycKQ3YNNmQmY/cz+BkBO0n6j7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 09:21:41PM +0000, Wei Yang wrote:
> The loop executed after a successful folio split currently has two
> combined responsibilities:
>
>   * updating statistics for the new folios
>   * determining the folio for the next split iteration.
>
> This commit refactors the logic to directly calculate and update folio
> statistics, eliminating the need for the iteration step.
>
> We can do this because all necessary information is already available:
>
>   * All resulting new folios have the same order, which is @split_order.
>   * The exact number of new folios can be calculated directly using
>     @old_order and @split_order.
>   * The folio for the subsequent split is simply the one containing
>     @split_at.
>
> By leveraging this knowledge, we can achieve the stat update more
> cleanly and efficiently without the looping logic.
>

Thanks for this + previous commit's great commit messages, much appreciated!

> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

This separation makes a really big difference, much appreciated.

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> Cc: Zi Yan <ziy@nvidia.com>
> Cc: wang lian <lianux.mm@gmail.com>
> ---
>  mm/huge_memory.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b9a38dba8eb8..093b3ffb180f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3598,7 +3598,6 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  	const bool is_anon = folio_test_anon(folio);
>  	int order = folio_order(folio);
>  	int start_order = uniform_split ? new_order : order - 1;
> -	struct folio *next;
>  	int split_order;
>
>  	folio_clear_has_hwpoisoned(folio);
> @@ -3610,9 +3609,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  	for (split_order = start_order;
>  	     split_order >= new_order;
>  	     split_order--) {
> -		struct folio *end_folio = folio_next(folio);
>  		int old_order = folio_order(folio);
> -		struct folio *new_folio;
> +		int nr_new_folios = 1UL << (old_order - split_order);
>
>  		/* order-1 anonymous folio is not supported */
>  		if (is_anon && split_order == 1)
> @@ -3641,19 +3639,11 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  		pgalloc_tag_split(folio, old_order, split_order);
>  		__split_folio_to_order(folio, old_order, split_order);
>
> -		if (is_anon)
> +		if (is_anon) {
>  			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
> -		/*
> -		 * Iterate through after-split folios and update folio stats.
> -		 */
> -		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
> -			next = folio_next(new_folio);
> -			if (new_folio == page_folio(split_at))
> -				folio = new_folio;
> -			if (is_anon)
> -				mod_mthp_stat(folio_order(new_folio),
> -					      MTHP_STAT_NR_ANON, 1);
> +			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
>  		}
> +		folio = page_folio(split_at);
>  	}
>
>  	return 0;
> --
> 2.34.1
>
>

