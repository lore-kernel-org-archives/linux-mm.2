Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986E1CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 14:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3973A900249; Fri, 15 Aug 2025 10:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348286B00A3; Fri, 15 Aug 2025 10:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23839900249; Fri, 15 Aug 2025 10:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5C66B00A2
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:48:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8DBFC01B3
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 14:48:03 +0000 (UTC)
X-FDA: 83779271646.02.24048D2
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013067.outbound.protection.outlook.com [40.107.159.67])
	by imf06.hostedemail.com (Postfix) with ESMTP id 30506180012
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 14:47:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kSN06oMF;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kSN06oMF;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf06.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.159.67 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755269280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3VF1i8XF2IsUYPCj3uTJMsr5kBgCn0MixVn+SU9EkX8=;
	b=HhaOXgHnUDIufxvuCT3mZFpuZfEihulu/pTBeABCENBuMbe0tPHJrSnUN8MitlvBDiAIEH
	oAj9qOEM6iClFbH19uAsAUzxh4N4ZQ0WuLyKEkJFrMqGemMkx1LxYoEkU6SZou86Y3Aj4y
	m8kzhhSHFCRh8UKUaeqoBr9y7jMIq0g=
ARC-Authentication-Results: i=3;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kSN06oMF;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kSN06oMF;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf06.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.159.67 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755269280; a=rsa-sha256;
	cv=pass;
	b=0FqvbqB4l6k2pQmStofNFODbRMMFwafSEwPDLPc0CUZmvJgkWePYrNpDFJKt1Gvy9LKWmR
	g7XV7Ms2YtfdFcsVLNbhHgdrb1Ivjy5OGhom37bmulyOVhvkJxgLMY2T6tLs9gv0lnDX55
	HZC9NIBcEj7grQ4qD0CuTgmQqaRpVjY=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WfZrTUGfTPbYgzslChiunqwW7T0cdcWBdYNUx+lAIWjNl1LMOoogAqUJu/JpV9802cPx/1f9EXhncBIGcrMpyzDrKMVmmqUZ3Mw5t4ybpzxf+xWAj47LHDy0LPYbYIwyXFSNDHy40m3rvGu+92AehMt4RRg/KwWNY2ii0JTYTqKa/1ArH0YBXN1KVNQgiBIfy5Bm3Zg1x/uM1SkOXMaTfIMWDr4VQ4HqvsdbNyeZYWCQSp+1DMSahAe6m9O4FscWovQ3W3R2WllRWxTLFxB1NSFSpXQHqEA06w2JL43KYNecwN653NVEPSdbK0ethpvAbEuv1mtcfxGTKS8auUPXkg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VF1i8XF2IsUYPCj3uTJMsr5kBgCn0MixVn+SU9EkX8=;
 b=DZ4YAeJY//U4UUEvCNMEIi7uEngrgIQ1wx8raVhCW3rS+hMesCEpiRXo8gEs+HB99N8e1zSMMWIFrER08nVSU9Wz8HLXPXc+z3GUS1G1RC5uEUjOywNZYFU9YEqhoLauxy2zsqjkYoKhsz6l+CWMLNmGRH9SC/+3P+sRkPTtDYgV6Sy9IcR0Z0YaZOcDyCITr1atC64LX19t8Obn7mjTy4ZaPmugNFB9+U6Dfrt6Wn2oytJLCY1YILMUfZJoN7BNc4P/maeeRyaB6Wubhfgg61OYX2YaFqBCW008p8aMkY79QotfMICe1NNR+ANYQmgEhjrd/JqYXxHKamyZR5gmhg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VF1i8XF2IsUYPCj3uTJMsr5kBgCn0MixVn+SU9EkX8=;
 b=kSN06oMFYdRy/tyY6RHUaYRpMfoZE7HFbxqr7fQuc/EX0+HTcylfdAzmiYeGUcIkjmd/nUINWfvHfG+VrvvD5pNdxauQihrPj+YY4xlARjrFOPvi4T51bTrh9/WYgcKbUnUnlbVOFDMbwOdvcNnPSCy/aFks+NL4kVqfR7PF47c=
Received: from PR3P189CA0007.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::12)
 by DU0PR08MB9749.eurprd08.prod.outlook.com (2603:10a6:10:447::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Fri, 15 Aug
 2025 14:47:55 +0000
Received: from AM4PEPF00025F95.EURPRD83.prod.outlook.com
 (2603:10a6:102:52:cafe::2) by PR3P189CA0007.outlook.office365.com
 (2603:10a6:102:52::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.18 via Frontend Transport; Fri,
 15 Aug 2025 14:47:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F95.mail.protection.outlook.com (10.167.16.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.0 via
 Frontend Transport; Fri, 15 Aug 2025 14:47:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykmMdFV0g5DXc/yRPs4oyHBd02X8hlTqphguMeEOkpvu9D1wdyaV7ecHYtHPmVYp4e71YNimL5e2uOIT3IN3+kdjOXf9M4wAgbJ28s1BueUxumtFtw6I0HCRDqWC8lB13H/QNhMZ1MegXLxM0mxavRwBLnXG1ot5uD0XcH2KzvihsVEXBGySXe5r2kKeiMEA0DjtXJNDOWTDlgwnHARoc27ShPMIcQYEZXFb/LiYxzvgI9IZ5G8LZMwDmupqluDX4YN6QMT+vxtWj/kPMaHPJJu7H9e0kAvk2HHFMLVj52MMMLYj6/ycRC06DM2ZvvYWynHltFTkzYBBvndjp7Rz2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VF1i8XF2IsUYPCj3uTJMsr5kBgCn0MixVn+SU9EkX8=;
 b=vDpV4tZqSZest80m1KqQZQI60UxZm4aLkCclXHwXhzh4n+2CViYTOjU32+acEZ38Ud5fWskwtOx506rjExmWcsnBXRbKh1dnREZouWewE8YM6xhXYWVQgSwXS6Euuv0lOSodniwLTVuiXUYzZnUUC0s8vxX+1lsawpvUFsZTb1p9uolYqw6xMlHgXHtUlveqIdNX1CkGUGeaYd24LABRDW/atXzGqL7wd0j7jXSlIeWnnOeXVI4SwGW2Y+Nq9xgTvofehu6s9QDWWTWSKi0qtwk/82Wx1CoQAiqw783BHckekJ9DIEz6ZJvI91eMgFANtnx+Z1cePwddIro0Nld35A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VF1i8XF2IsUYPCj3uTJMsr5kBgCn0MixVn+SU9EkX8=;
 b=kSN06oMFYdRy/tyY6RHUaYRpMfoZE7HFbxqr7fQuc/EX0+HTcylfdAzmiYeGUcIkjmd/nUINWfvHfG+VrvvD5pNdxauQihrPj+YY4xlARjrFOPvi4T51bTrh9/WYgcKbUnUnlbVOFDMbwOdvcNnPSCy/aFks+NL4kVqfR7PF47c=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB6731.eurprd08.prod.outlook.com
 (2603:10a6:10:2a4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Fri, 15 Aug
 2025 14:47:21 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 14:47:21 +0000
Date: Fri, 15 Aug 2025 15:47:17 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
	will@kernel.org, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] kasan/hw-tags: introduce kasan.store_only option
Message-ID: <aJ9IdVsSxppYh2QC@e129823.arm.com>
References: <20250813175335.3980268-1-yeoreum.yun@arm.com>
 <20250813175335.3980268-2-yeoreum.yun@arm.com>
 <aJ8WTyRJVznC9v4K@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ8WTyRJVznC9v4K@arm.com>
X-ClientProxiedBy: LO2P265CA0266.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::14) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB6731:EE_|AM4PEPF00025F95:EE_|DU0PR08MB9749:EE_
X-MS-Office365-Filtering-Correlation-Id: 05decebe-c7a2-40ec-ebda-08dddc0ab715
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?w6lz+PBEALq7JAfJwRNm7ZIdmODh42CAA0QDW5zhawuIZZzPpuogM/qByXGz?=
 =?us-ascii?Q?zLlvvYuOuAyAJKEo9Z1/V5zXM6WVrypmV7Y0FdCqE4VabbrQnMSdQnYTnUGN?=
 =?us-ascii?Q?zU6B3TfvKZ3Ugkzy7KUhjRq9swmXcaV5RMLLdG8y83jiwyiWHhChhvc1mb2m?=
 =?us-ascii?Q?Vxr9kwGRz9+SvDg1mw6ObIKjWu5hBT1BE3Kr8k/+oypWwqZ0aM9oFTVshTFG?=
 =?us-ascii?Q?RhdTKygrU9vCc5g/IxLhzgMd/kxn3i22LyM+8b17/xNP+0oOlJZBwIz+p7P5?=
 =?us-ascii?Q?/SGbDtdQxkx8da2Pix5eyFeKgnOPT8bPeTmAEeINKsB3z7zMCatE4IAL7RkY?=
 =?us-ascii?Q?CFxNf94oVEUXeaAw3vdxk7MCuuFGDpxceLGd4t96Ksyae8v56qcEDF8gdCdk?=
 =?us-ascii?Q?4KRf/qSwVrvtqrf0WGNnr+tzCC4ZtpedBwRwNaGbRFqIaDarBzmQt4e9GA07?=
 =?us-ascii?Q?HBQ/8EVuXHAq+qZnqWahCBfnIR8Gz5sNR2C2A1QY/GLocdETnP8y+qX0jX3P?=
 =?us-ascii?Q?flOGaouCWRKhQH3KkU4Yc8/LshVzEowI6T4rL7fwDTSxb+Y1rMFzlNSg/Gho?=
 =?us-ascii?Q?0cvWXsfmJvpKfdcu37jcw686bmbB/RDepQCugeX/6bmf+C0qINiVNWRVNnpa?=
 =?us-ascii?Q?c/2l7GGJj9U5H43c2bzJ2ZEuwXopQkxOwfrpg9Y464bvypi3CIQ0TO9ANQhQ?=
 =?us-ascii?Q?taTaNfuwE5RYQfEfY9lc0L5etRKX8MSZ1m3uNxjH36HYGNb404hX4eerS3UO?=
 =?us-ascii?Q?bN1bF2oc3ncTBKcQV60rGJlSCTr/k+l9LMZ9EhRx06WPdeZt0UWnaIJ5zy8J?=
 =?us-ascii?Q?3A99GGjzifVD6v60EBf7CheCe+kb6VVazk7okk0SKn61Ac98s8tREv6PoDWk?=
 =?us-ascii?Q?cJC0NwyhYUkh7Svz/9k/YRubRtjiu6rbgRY+F7biJRYR6G574eThTq2m6OrM?=
 =?us-ascii?Q?ZxzkHza25Rhug76woU7ruXVn/Qeuvrsk4KsqLfPpBtpwOhbkvRvs5G4V4X3/?=
 =?us-ascii?Q?Gc77y0tI8gGcaiOWMHc0W/d4A0LlR+CTFu33Ju3eAc+oqDgmTXrdvi1KfPzy?=
 =?us-ascii?Q?l6vFY8F2V7WfN2f07LprVNmNhet8ueS0VYTQgQ3hUfK2gDRNFbdFeDpI1eOx?=
 =?us-ascii?Q?131eoIX3q+XXByelJnGQQcWBFkhAOgu22pQKanexVom9cKvsOBfEsPFlUPpj?=
 =?us-ascii?Q?3ZlzTnOaeyfCiB1l1IR8DMaVGK9asY17Mjsz2m6oW3lgThKjKmZmTIQMzSS1?=
 =?us-ascii?Q?gPGwVxLp6r84b6d3bwlW0VUn0WZd1Aq00+xycbVFoXHJHVTdhu8vmyqZasl+?=
 =?us-ascii?Q?ml/QvpZ6zqMV0EJK0UYIqe2MLJ/k4g0oCxTegqoqz8VTGjp781O/+OsW2JU4?=
 =?us-ascii?Q?IY/okTGMNtsamYmLBGQznaGWhEZn+f2IORdSoYhnt9gHBT8/DVETBvEJOBI+?=
 =?us-ascii?Q?NHqlju/diZ8=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6731
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F95.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ce15e0bb-112c-44c4-cf35-08dddc0aa38e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|36860700013|14060799003|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pAYxwjr9MJ49+dVltyvWrKjAzdN0bDjOMQ6j5vUwjvad984dUokaRLah+omQ?=
 =?us-ascii?Q?MX2sxuTSSmnEx75Tsgjblk+jdrCs6pXxoNPQFmsoqIRM9IqWByVlJvrzzZw3?=
 =?us-ascii?Q?mkXtjgW7jp7XQFIiazbalLszKwSgWnXvzwQRbPuwqGWD3lx8lXb6NohK22Zr?=
 =?us-ascii?Q?hGtXIGrY4axl9vxd317x1hKQZsA2cM+V9QA+dvssKnTXKGZ98jNi1zjoDmn/?=
 =?us-ascii?Q?FYqx7mWeP7SNNqIrm1FLRg7Gg5LgzQ2m3Y0w7QlikZbZldv1CPFL5v9vOrsb?=
 =?us-ascii?Q?noQ9w1yaL60Ntmyp4cSj5fBJBUz4IFN2cz2e1acwK5h4tKKyPIXrlnawzGS/?=
 =?us-ascii?Q?mJOvLOpT/xOAuoFMV3Hj92TBuEh+obaRntRCgSc6rsRIp1ztH4ks4cb6XrCe?=
 =?us-ascii?Q?tcPTK5n9z7oNml0YkUqK0nmHl7d/l/QuJlHBMC1AdZy+eIvVGOlLwTeITKYi?=
 =?us-ascii?Q?BBZdjKPopa4ARWl+Ou0g+Vk0+wbirZBYIXhVLi28MI+dDxOCBhRkDaoQ2AQH?=
 =?us-ascii?Q?j/jyrpFCTXisP/efx9o7Md+R0sYzT4d/Qk4FpE+PIIzGQD2lp1P15vBYBR39?=
 =?us-ascii?Q?U8kOIXBw/QXfHVR1su71ApYsb6L/+1+PBGo8w9Qwtf11hbCRE4l57xXbI5bV?=
 =?us-ascii?Q?ADfCp1AiExnBV6XgpKk1mhGuLvsd/25CUKrQbkvBY3e3LfSl69Bn/SOQyrJ/?=
 =?us-ascii?Q?3+78sLyPEo6CilscMDumEfq+QOoSz9KZqwXLbkSrYAZEGueK+Ka8ZBquedPZ?=
 =?us-ascii?Q?a8fImLMDZ94FLreUYUDMal0RwQKywttTVp+g6G61ylJf9JXOAxbJgfCfHfYd?=
 =?us-ascii?Q?iRFplwpwqEbAPEsoFNwER9+Si0moHzU8ZXwPP/00f2gE0jT2iNDMg8buV00U?=
 =?us-ascii?Q?WObcQTmIHtRwVyTh+HLVSwbv/hidpK+01URKHp8eOYuv9L3CXnDCzO5qJijh?=
 =?us-ascii?Q?r5jdTQWgH3Dl6xEf/psvpg6ztmtOTPieQp5UHNTW+7KtNCVXFwW4bEcW0uEn?=
 =?us-ascii?Q?gX77TwLGnvZoNnB4O+Kl9IKbY17Xkzkc7TDnxjdrOt1stDqBkKzvE9ULybj+?=
 =?us-ascii?Q?RmRwK2tAXKUGcYMr0iV2sJ3fDw/I5oeZsw3gY647h6qA+PIFgOe1sfPUTktX?=
 =?us-ascii?Q?4M41T39IhAfFQ2cLSV25k7oHSV7Pwdq5/GZFxTGxM80drnQxX60HelPIWFmY?=
 =?us-ascii?Q?JIEAim8CKjxxELszAVYDNYlkmYKqgTi1lnUFHTk038B4oxlVyfUNeu+VnBNb?=
 =?us-ascii?Q?cJBcjFqBtDwqlyrrABQkkyNOKeTDHHYG/WW6eKNIoIE3uZ1ZRESugfeebt4h?=
 =?us-ascii?Q?JUBkiyLf/ulUK9XC9mC8siAIMX1pKMQiL+ocsANQQaimSMm+eDZKdVdC8TeS?=
 =?us-ascii?Q?790XZN+SaSe73OvEJXsen6CZy9XyyuYsMOlMTmjGqZtCNhPfjSoFWtUSZ++s?=
 =?us-ascii?Q?oRZxjoaNYjfjJJKnwkrGSwu3X+WxUXqCFrZvaqi0jryR/doiMszs2kaPlzy/?=
 =?us-ascii?Q?DdYU2TXmNnD3g2ipDyROk5ePI6lIYSNqv64Z?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(36860700013)(14060799003)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 14:47:53.4982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05decebe-c7a2-40ec-ebda-08dddc0ab715
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F95.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9749
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 30506180012
X-Stat-Signature: xy6uon1uwicfor5aqxj5bdhactogrpto
X-Rspam-User: 
X-HE-Tag: 1755269279-88899
X-HE-Meta: U2FsdGVkX1/U/iOdQ67TWhplgIlUlLFrjmYwxadf03lv15UPy0OX9fnuNwQj8IQAezHgQxZOrYSDef5p64n9DRkvLMcQNBvosO19NPdZGv+yldOlti9UDiX4M+kn01ZHeeFiPEEisOgxGoqMbqEt+eBr0T2Vx/zA3Qoz1F1hVNycDjl7BkiF6l1uoK5fJ05VjQHMA0OsABBaoJbbcVFIvg9Ra6kblzwE7yN0xhksnR0hBUWuNV7JAjuBWV0YuW62jhYnQjWHtyeC6IfXCU2Y+cnB2gAaXYUWyoldy8sex3FAk0Brr/M5u1sjRinaRz/Nhjl3t6moO4RNfuY7hFAH+Xrl0kXmOAdkfoKfg5O7u6VZFIBMGtPLYj8on9Zy6a3dfw91rCkPb5fjErFjm1BbpFup9epfwg65bOrpekO++Ap13/detW0d81S+S4t7GnN0pKJykHamqROuQhfBHHfnChHZTshoSuuN8UJ42YRgP2hZU8Rz5MB5azQxJBfu/JPYNBZ9MPQO/MdC0diAuTt2WGQhAjoXSZzoIr9zTFeSeFU9/ILWW91chF4ZytHCZFbZ/kN/WlNSzTyMc/Wgdllvnof2H9P7DI27IiHcTHrgkUs7QNlAtqlrC3NW+t76Styc6lOlzEpq5mgzPO171TcPxiqXR02x+MdHViVV1SBsHdB+fQhhoVtfy3RBBthvijKrnkQI1xnGieSa6FZOwUz6H/xCtTvy/iqvOqOuhTIivXunmJURkTeoFd0KgBV53x4ZYfKCEtaeC7bolMF+sODGef3KDSQqSXldVs+G/NxDQbPIJ9+JAX2kXlRGXzT2rkyn0J12XFUVDPbB/oF3P6w/DVVPBrAzYgwuWqx4OU6Jb11jjsOYtNsoc+FIzeadRuC2VssQHHUvn86zrn0TrjK3pfuCVs2+Qn0i1frbWf3eVaL6NN+g8/oIUiDfEZkp80SanR9N5bgCCpoDWrAsZBE
 2oP+dEc7
 Dd1UBSnUaCxR29r0c49kDkqMtLce+Lyue2RQ1jwaqguLiunRc6cAT+BBP/C7RrVQYVFp/r4hvwsilcIg+3xtN9bkrzcQ3TM6UqM7gh7m3IVKNK3XvIp+5dQi0W80hyeubSn5H6a+yMRhVVj/F9ERJlLr46i+Tp+p5WITFegLjIfVwLTYSFYfEPlG9r6uRfVKfuFihVzZ8lcdPTtH/NP1bHY7hghWbzkw2sJmDHXViPrwxBNllYXcwo32FnAW6IcsLxmqY5h1JLvmBQgu3cS3C0My0c9/mwWITkrsi247TTMCClxs2JdUwcNRX5+qqIMqBvxQ3GUIOxUKl4OFa2bGsN2VoIu3joevAoFF3QmGvlvT0Vi+t2XaF3sgedShLHzuPylInvKpwhAkRXx0ZEF3Obal6pu8tY+jHCYn0lePLDnPj5WPSwdGy9fHu8gvQAw6ba7aA5JoDwhB4rns9Uuc1o4Nwbav8Lg4d0DLA8iZxa7rmlKmuH8bo2zMcjDCPTSMrfGDIDfQ/oJeR0kl4gYDiVrH/26G4pn4T2NdHf1QAUE9W3NbEFoEEDJ8XiFITTGu/hTj64Q+AaUAjDe6aL2LdfSur0Xl0wnVMJqZFOCZVHc1wnIlpNixuCEvQMb/AwaLjeDgI5ydtdMooN5cCewNAzxEKJ6dZevogtyp4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> If we do something like mte_enable_kernel_asymm(), that one doesn't
> return any error, just fall back to the default mode.

But, in case of mte_enable_kernel_asymm() need return to
change kasan_flag_write_only = false when it doesn't support which
used in KASAN Kunit test.

If we don't return anything, when user set the write_only but HW doesn't
support it, KUNIT test get failure since kasan_write_only_enabled()
return true thou HW doesn't support it.

[...]

Thanks.
--
Sincerely,
Yeoreum Yun

