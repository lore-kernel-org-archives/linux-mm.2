Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDD3C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 13:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5006B009A; Fri,  8 Aug 2025 09:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC416B009B; Fri,  8 Aug 2025 09:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83F56B009F; Fri,  8 Aug 2025 09:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C50296B009A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:16:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C34AE160123
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:16:20 +0000 (UTC)
X-FDA: 83753638920.17.20418A5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 365FE20006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:16:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IYkLmLKI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Lu92N/2o";
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754658977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAi1uKlcrElwAQMEIPhokEzM56eshiCEpwfYxsdzANk=;
	b=gYtY2qfXJyf2VS+bfDJlwhilracqelvkO9LruQHaXVy4EH/2oxwXq57sdO9sPCxzgtRNfi
	sPG7rK9NP2rzPoowSsNI/vy9DJlqCs7o4zJyb5ewLBIrLISFpNhXDkZo+USWX4DmfwieQx
	XjcNZOEoRgsCFLZg9VgPU9bzKWR3xRg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754658977; a=rsa-sha256;
	cv=pass;
	b=AyzYRseFvJRRrCq6B3e98B3L5IgSo4tOAjjaRE5OLVeJyMGmHUbXEuqCHCTBsR82ABw+ze
	tpCwUYJdsOYvNaAZzCmRUPi3jgPep/JJ0HkoOgGQrvfZdKbAH/qc2i8TRd750k4+kuH5h1
	Tc377W5hikGsEEyqzblNBK/Ul4tHkVk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IYkLmLKI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Lu92N/2o";
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578D3P9s008788;
	Fri, 8 Aug 2025 13:16:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=aAi1uKlcrElwAQMEIP
	hokEzM56eshiCEpwfYxsdzANk=; b=IYkLmLKIdz/vutlmxr1iMU34lkW/+EqAXq
	dXasMSJ97avg76kTKhMNDKI56xUEgErkqT/oEMb0LkEhBqjJeAgJwPYkEWtGzjU4
	iagc1KofaTTgxWgL+XSZ3Ae6L3TGaSs3IVCIf5qlThhkZ99MaRUXEQKoCKJcEt1x
	BTAlOfTJhS/FcPqkKebxr5aEDl2QqwT2jg7ck6rUmOVpy/2XR4Ts+Rv7OE1d0ZAp
	b7zznYhlpWPIyKR1C4he59EU0qzI5h9hkBHxPiKq8kOhvnUv7SaJtxEUo+JyK0Wf
	mYktp1z25pGHbxSBYtnIH5mv41bJMUpuabY04SSegjRczdeEbCMg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvg68ty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 13:16:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 578BPgSA005825;
	Fri, 8 Aug 2025 13:16:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpx0sbfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 13:16:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TsuzzkbPizIdzmD9wlj5gXht8dmJXdLklYdsexX+xbzP5Zgg/jIMrGBGe/Qju6PSctDrFLglsqUc+dBO9WjwEQ0UoE4bZVLeKNd+XYaukbwkTRWnN4CkD5LB8QrdAFhWUdrJkijrWKQSCzLzSIOH+NtnlEqssMVUDcR/1hxte7tZQSMN2Arz1EQCi+qaH/QbOumffj/yLvzu49QmWXzCTF5kqtndKQBzp1PRdqeuPWVISne/2E7K6fcMOXbfFmsqPUEdgUkc2t3hMDZgjY553ePt1zOzJbJFz+f54+pw9rVw1S1RHWauyxCwpjAfRmTUDGoiqzVNpxTfxfDImnbtrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aAi1uKlcrElwAQMEIPhokEzM56eshiCEpwfYxsdzANk=;
 b=Twd5j9bqmxYfNbDoBTkqlLrq0jRjfTc1HPTICCj4Xv8dXse/nUR6z1SOiaIHWxszNX+ZZppIG8kMVkR79S/i5YeR6/wMz0k84pqMkJB5Pie70GGlVKqTtACDI7733vgL0I3IJIfbizyoAHwoTyT1MqshZV3sVIO16tNICaIs8wD3hamx6Y3SZulfKciX9cRme+LCred+k3ep2K905Q5fL6VDgeuJFdcfsBG/Yu5R1vJXinDcx9bXNtenpOZ3/C4vfdON8UdigiiY4t8mMf2I4t62C7BWAkl0eSb6Jptp9ukr7LhklCPKcE0Vyx+k3sNn2qIPYgiDNL/oui6Hz5TJlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAi1uKlcrElwAQMEIPhokEzM56eshiCEpwfYxsdzANk=;
 b=Lu92N/2oT/YIBjTxYFcPu2z7YZWUrYChvAehagCXgTQN6cx3otpTkPuWlIsSENB64XKKCU29z3iFwwN7+J/3PH31VH49uvk86xfsT+0HsWisCssaa6ECJzcy7gBlfzBAQSZSD/OWPKL30EP544Wos6f2zG7ojP8At+334lnNCoU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6200.namprd10.prod.outlook.com (2603:10b6:8:c0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 13:15:58 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 13:15:57 +0000
Date: Fri, 8 Aug 2025 14:15:53 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v4 0/2] man/man2/mremap.2: describe multiple mapping
 move, shrink
Message-ID: <79171dc1-1946-490a-932b-16bc57269830@lucifer.local>
References: <cover.1754414738.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1754414738.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: MM0P280CA0080.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6200:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eb56f13-30ed-42e4-76b4-08ddd67db685
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z6iLkJA8WRE+Oe7jWfLl1yqConngIiYCfw2jLXsrJz5+EofaaReKPaPLMHdT?=
 =?us-ascii?Q?z3OLHDw9LUThEyRtQRuJKSfB0UELji6LmUhy0KRPttTVnyqD+lIFPN7zvEdi?=
 =?us-ascii?Q?HpMYgWOgZ0Cc29UZFAQOTqTJmNirHT1agjL7sqAm6tWgigfSRsQrTrdN1HW7?=
 =?us-ascii?Q?3jSUobECmWOa9Aa8XT4bFpQjhjegXTj/dUomHPYwd7Ku7dml9Y46UIvW0d8M?=
 =?us-ascii?Q?X7hbJzftP9T/YQhh4cMI4ckJh9hkw1BUB4XXdLi0vCX5p0A8T22c7N0IlWu8?=
 =?us-ascii?Q?qjooIUKlANXIgKOuErPFOEVfaFm6iMsELVgfQiGBP72G9O1JX7nCpQIaYolS?=
 =?us-ascii?Q?aO1EqKANFRaPuH15pX3trot0DjVvOkJFU2j6hQMmlmTP1TqynWr1oEIn5+qy?=
 =?us-ascii?Q?5/Ph/Rypb9JZ1WgDfxBnEq1AmqOIlmvgTmLRL2l1xXXpfK9+bmkyySiYzx1s?=
 =?us-ascii?Q?Zj+tJ9UHG8w9U5tE5xGeNf1/GxiZQU/k+TgveU3QDmUSBJEU5DVYDyNf0mhh?=
 =?us-ascii?Q?4VEKZVAXToI4DzXFETPNOZj2fra1eyI4QURx/cFQ+HOJMo5J6OX5BHOnI3WX?=
 =?us-ascii?Q?nBFCgx9xhuDBPr5+/ASq3C5p1N7LuaQ5X7qM4tWo1LDxJHQNhpSAA5iWEI4v?=
 =?us-ascii?Q?aUi2gI1e+P+pI8gkh0Dc2M6BBdlHIM2n9nB8Byf2SyOQQFlHq8Xe6Y+67MeO?=
 =?us-ascii?Q?x/UD8ph6ctov8DARzMHt3f0hDdGQz9NwFIltGeqP15mNG3hMe0x2KlyckVkn?=
 =?us-ascii?Q?F2/oYDnvU+JxUU4/oheAcrTJqA4eZq0PUmzJbPgWAuJ4oYX9IK96lvTul4uZ?=
 =?us-ascii?Q?3t1x9NkZ79ftsJgqMFmQUfZ1QNsCfirZVjZ2gfGLEaPnf3J0eDldhcJbL2cm?=
 =?us-ascii?Q?YMOvDPj3QV+1xE1EdFxUHgJ9YuhA272fzDI1HVnK5AzqWxZuF+xkb758U+Pd?=
 =?us-ascii?Q?5IzgKY9picrIb/TEplqcqEsLu2eHuLPXq1Y1bHC6F6YMAVXLSB6bjLkgiIw3?=
 =?us-ascii?Q?88pqYXgK6uwTHQt2GuOjAnZAkOoKW4mzRGcLKpDITkKWi3m7Trfg0FpR4N0T?=
 =?us-ascii?Q?l/edBDn+TdaVLWozYsOxGatnwH/LOzyRvAWsH/1fzra7r7iVpEG6krpRpJyZ?=
 =?us-ascii?Q?n/KFu9rxUudVCmguIux/avW2klzC75018WXz8Kj93Y5nYYSZsMquks/+IhbY?=
 =?us-ascii?Q?cmTrsGRi3T1dknV/+ekHZaYB/yFRaVIkwyWYAzfCRJG/PDzOO7BjQ1bK314L?=
 =?us-ascii?Q?LqfpcGP+4+LHAD9g0uSYCh1NtqJup1E7Bgx3wA3XmjXlVhjQdUKEtMOs49yf?=
 =?us-ascii?Q?Yb5vKYsDJJCjV5GYE8dicedbfTvMJAiLxDDdmwVOEVPeqmhtqdkYtd8bE7C4?=
 =?us-ascii?Q?s0w3BgllIrFdtvjYZZ1wfAfryfLNmUUA+GbFXJs3+EROilm5NFnsy/92W2xf?=
 =?us-ascii?Q?DWxA3HAizUI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+GHq/HTvDbfdyYnFQZFHsr+IW3dYuW7sKP0ylmpbyDiHDFBL63zaWXpz/3Ye?=
 =?us-ascii?Q?AAP5yCQul4bUqC9wzqLqiwnIGE1SIGlbJvGKDATF5uy3xaQnW3IF9bO+Gjkt?=
 =?us-ascii?Q?G+xshciQCo3oa6arCcnw/I0ANsCtqPcn4i7rLuk6u9Ouhx4WGhHjT6koiyy7?=
 =?us-ascii?Q?mii37djN1jU+6ZxV3zv+aBDHHOb3WsLY0vkjv1uNEC7GGwmm9LE89VCXv0sd?=
 =?us-ascii?Q?q+oQtzZfKOupD2a6t76MBByL/8kNABf+vaHq39j2HQdS7mcOh37ak1uUeETy?=
 =?us-ascii?Q?tH3NVOqhkXdasCtWXmNM40dGw/LEzCl1ggQ1vv7BnVER/ZgTmASp3ihoZZaQ?=
 =?us-ascii?Q?ADzaAAh4uEfBnMDF25ZWdwTYG0aUkB+8EdxSniXNCHgKH/cpOao0pnAK2hUn?=
 =?us-ascii?Q?9QCkf9H4cYWbSeDfjvIXNt8gQ1ILD5wLlwKb/5aAMF9TD1VdqM8kY1K7LFhE?=
 =?us-ascii?Q?/5iDeP+alHZqDLw8wsgW4FYzr7WchTEJnEqifqgq8ui/47WGMmJkX2XXqme8?=
 =?us-ascii?Q?MWY+d7xkwNca6i6hmGlt7LvHorQhDYrVW/hsDs+/wrTI3b2NoYcPyhhxQZUD?=
 =?us-ascii?Q?v2Zj/kMwZnzttZOxg0MOpuB1mn/eS2baWaa/SEqumm9SsCdWxEqVmCsRW+NL?=
 =?us-ascii?Q?2tIlWvf3wkvyBwuAASxuyWC0NVwtVt3YwiQh4XH/cEcchMmDzJILJlEe7jUI?=
 =?us-ascii?Q?jU81HlaoCUl94mdj/UiJoxTH+F8oeTnwmL5M2rY4CbrCt6zfU1szk9VX+Dk8?=
 =?us-ascii?Q?woi7ZcNjJnVyJxOHtzPjIvxTchfsvfTMX9E3mDRt4yFLHktobStywXrW3Erw?=
 =?us-ascii?Q?BIFYKthIvSgq7UBbQYlCoAB0BK39XMvUTwa6suSxExm+U2/FHY6t4DtrOv6A?=
 =?us-ascii?Q?8vA6cnCfrwF9sq4XVVRNl2MMv4vZ71ots8uevIMF3rpoon20CZnfhz+Z1lut?=
 =?us-ascii?Q?eGz7RCvPHjqYUItP4gXirtlRHHE5bAMP4u7WjoizqTV4GjRnnRKcbYsZAYAx?=
 =?us-ascii?Q?Scm2HUFRrJgwj7QJgODF1HFN2CcPohUkOV5X/LOnRKJijUjMVj8AxuWe3Geg?=
 =?us-ascii?Q?GkGBy3rGA0keJcloSpnnzQzWqhWriiGERt3tVkhQDfZZyiyfLPiRFP4csyct?=
 =?us-ascii?Q?QN3yOiRRfnT+psoVO2dxPIjS4YbDWnMkDKXx/Vz4+j9WnzHys0Ud9qVJ9zDW?=
 =?us-ascii?Q?6Sr9ZDSTErqeQayYaQns6OKOAalgQPLBecPe0MkCNOnB7wePsSzGhZnZY3X7?=
 =?us-ascii?Q?60A8imTvzSDBmkuvqgD5c2/nlQ0H73l05PQwYccWThjtu41Z4pOTdk2IbDET?=
 =?us-ascii?Q?SccDVEyMupPWiNs0AJz6R6iHCGDYwEsjpAfT7VTb+9gwVHZBTU4Cc+plHDVq?=
 =?us-ascii?Q?1lQVKnf+sPjFzfM6SgqP1FxtIkZpSfz2jK8XyaLDx1zGK5TtLu+EtYAK2k0c?=
 =?us-ascii?Q?gSpN4LJU+phkS556V9oTBnMmCg/yE5oSu0b+dmtctY7yLb7sdBo/31yYN/Mw?=
 =?us-ascii?Q?GlBRY+GRfFobUCkSnWjtPHr36n1ZJsSzPkTErArjMBYPg+jUjQHUQb1qPwP3?=
 =?us-ascii?Q?JGxdTDi/lfplgKAOeBaziwCk+E1ifQHOwbE91y4kzgHqx3Wa6K9APB0TJzxi?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jKOyomaCAKuOSgDdFswY4oztKqpkz/lGUmsg0o9sjkOBkg3QKugozoq0FxC4h5RtPN8MNcxRa4/JJqri1q9WnxWBqLavl5+Lsdkls8Fv62klwV9ZiDMau3utPDOWY0q0BZH2HQhq0ytQPnsDpKJCmHagGpHxFxVMzxHuWTRvobguGGBXIhQ2iPBOYf0Z3T9rP/7RoRiGuWWNT3m3sj7zUqouGiS7+Gx4XQI302d5nbFLZ8GkdJaf/ExvB8mzWp9SA2/Zp7qrTfQnZ7mMnSwKWNcS74e6Ru/yvkXRAfQYS8OrGpoy0ax+FNDKkp024TD0AJLzBt3CWaYm136Cq37D7DrcfOdJIsmEq4FnH7KfVs2q6WKXbyxCg6xPYdmMBfUj4TY4pzo9ourI6i6LuxrbBiSqU+h494f6XA3rJP9Y7MrDraYrTOrjqRt390W1Q2ktdBq78Z7GYxIE5Fdt1FSWOItSSkd7OSb+Be2Wdw6LDJcwoyrtXHyEowPf7tf8Wu6KAHU2IN3c+jHOMO7WJy0gam3IwRFtJnZ9gZ33ufsEv1a7hYRrLhvCqQdgpW0WKHMnq4E3/NfrhEmhTS/dLgsatXVPkaTcjn6uWXV3HFP6tOA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eb56f13-30ed-42e4-76b4-08ddd67db685
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 13:15:57.9540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: buCSbl2L6CmisR5s60HlVSMaqg39gWgxxZvyCevUp09OA+ZwOysw2AC1M5yTUAamAnLxyrP9YD1TY6/cPW+yMFkJQ8+q6S+fcuU89n6DZeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6200
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508080107
X-Proofpoint-ORIG-GUID: abkoBAVrKSXUtFNs6GwKjJumNZK40DgI
X-Proofpoint-GUID: abkoBAVrKSXUtFNs6GwKjJumNZK40DgI
X-Authority-Analysis: v=2.4 cv=QORoRhLL c=1 sm=1 tr=0 ts=6895f899 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=DnMGP0uOmLHrlsQ3OkAA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDEwOCBTYWx0ZWRfXzWsSy2VNNssc
 obZSz6ch6GrNC46+ICsngHijPAHwyxXmGLsElSBIqzOO12/U5DbpoEa4g0gOfJvdC4e+B6p+oMK
 AoPr4e73laoY3ZN7CqiKuoFxZUAg1Dst16i+zNPZ/pq13s3q7LNNpqQgVtOUXesxZSiLOjhW8iC
 OCS6q8ozGEtlmhhxNEPOnCXIfOvO76p/1f6e4Yc/1d0bL9vmvCo5RXWjVLHcx9ZoqddGZ/qmawk
 6sfBypAkGn/hrKQiwYTmzGv2lV51gZri+mHXc3QlwVP/uKeaBx8+w/7V2Imu0NVJWgPuLUsgR/e
 gctUjQB4Tx86SjTSvoVHN0jBdtgLJoZRPBJKaPxTE+HoTGOR7xPxM2nE7iU4X0PfcSk/Kv4SNu8
 ONvRP4zuoxtIEVKw1j/7FodKbK3obG4G3YwJB8j84HQua1qOJGo8/2dDDV286vhbU/c7C9sS
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 365FE20006
X-Stat-Signature: 49oi4a6n3fdj89rfaipxfqhobo46a6k3
X-Rspam-User: 
X-HE-Tag: 1754658976-844434
X-HE-Meta: U2FsdGVkX1+AStJD7RkUFjMZuk0AnZCZKE7ZutApZiuidK9JVKVVt4vv3/haCnHVNXzdGxAngAxZnIuu6e02NSMUDCqje2JCIDy+vFmg56gsf3ZT5wsZoYa727a/na2tUOyQ05+b8vdlIMiSwTX/bAgrpKmKvIaGaoWLvYhPFAPkgjgFfbH5J2TCUZWH4/axjcLJzeh/zFmVyyH/z3NGQqQouV+H1+TBmkD4DZCh9ZJtFEn9URqOONHozLdHU4QGUyPDo4LYphvU/w4StvgS2QZLt10TgVJ4SLjBgeDhXPxR2v0nXW2Rq2xNSY+DjFniC2gY+KZH/tVvmLXeMTgKQIBWZABsfftEm7XTU4LM6dOqzc6hAorfXr/NjNkvoGRTNe+WUeos1wIYC//lSJOuuBFzvQXZcraHMGG7rDsdYD3ysnFTfFnHAkuf3p1hVDmI2gFH3U6jG/XHM8dEB/QK8WsfV+CXryqG5aHM+/8fzqlcyS+PXPALKTQQAcm5H8Caj9Lzc0CWHlEcawR3gQ/X/kIJDEq5PECTalfEnecV+TxeUcZYfGIlY2G2eeLGhnKNfH7Ndb13WORtqnxKRK5uTnJd2MDF8xmysZtVJ9ziOsvrFuBaUToIeXdxEXHX46aby+CP/Wz82yPytMhBxfUzO6EaR8vOV6+wohUcafyGVwv8wXEDF+fbSXFdRFPMKSBKiWo0xDLqbkh/g5dsiXwR11RyGrIH9o5TZcU9EeVjH3fX/4H+bOHuRzpoT5c7vU9bE9W5ATIeXC6dChS0CSPrKHhpemxM7cnMlh3/kKuUO8NGXzvomWi/YHS1u4dAXp+5zvH8waAlPvLixKMEZcYRFaxKWHM9+yht63zLjpD45qFVIK+IaTOEjTmGm0kK/BuyMtQENcHiv8wzYPfgPzvu2BoXs3wgvnU0Sb1runf1JXlhG+VC6VoDAg3WhLtpTmKW4uU+8yC6+Vwn8wCY02C
 jxcGLcPH
 /E/3LeBZCuoBOZqZvJKFdRMIoz+gAPrdJgd6QLecIZfCLtZo1/yMqzPcGPWiAG6Zko5omjIzqZVIOP3iFw2teXK2Yd3dXquAv1c2abnhLfdCY8NOiYuYjVglA7jp+DyZxRU8/xlCLrFmLaNXEIr9ouNBZsU15KB/VLtsHRsa71EZBFdEy1arp0ZEF7nSmD810E/l0L6Onh9USeRZj/7ZBB+lgKTLHNgjU9F/tpw38D8e1s59MUHjCow3N0zXZ+3/RT6Lia/WZft6LmabWE0Nx2zavdsKlrgcS8cpnbnTcQ0xHAi6tGk/9mxvoUDjHxVgCUr13ZeYSgaMrbM42R/8j9ZHqAEOIuqoqaCCGd/bnS/+bo0jIdA/BIw44Pw9ddCZCUcK0oXZ6tnPt/guf3a1SmIc5ycLmGTxwXVTGANKf8TXE1gGEmwtKF2Bk8MSmzcaTiB8B7y/ht2BBxbf95a/103LctxpHTDFERFbrqGDJP1QCqg+Uwc1WEZWL5tlSiRmkP3xekzODqeqhVZ15OdWHTFJX8CX/zNOWka8RuM0FJct/JFv/ZGV0uhMBu+cwJYopbgNyHlb6TwHZA5BXc7apyh8VnJX6hZISmY1lOtrshlbIMOk+Mqwusl/qPA9zgPmm6CvFAGud+nVxsGFQtmFHBLOjc6a5P3oDMrF3b3L7j92tbjp9VPgDEd31U5Rl/M+oNIvVRxMoLeYwlKuGi3fDWCdlf01xrk6apOUb4uVdMpA1o/k/VwJFXuBHgFYwFrhO4JNU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 06:31:54PM +0100, Lorenzo Stoakes wrote:
> We have added new functionality to mremap() in Linux 6.17, permitting the
> move of multiple VMAs when performing a move alone (that is - providing
> MREMAP_MAYMOVE | MREMAP_FIXED flags and specifying old_size == new_size).
>
> We document this new feature.
>
> Additionally, we document previously undocumented behaviour around
> shrinking of input VMA ranges which permits the input range to span
> multiple VMAs.
>
> v4:
> * Update description of newly discovered mremap() behaviour to highlight the
>   fact that, if in-place, [old_address, old_address + new_length) may span
>   multiple VMAs also.
> * Fix up commit message for 2/2 to correct typo on specified range.
> * Added code sample to 1/2 as per Alejandro.
>
> v3:
> * Use more precise language around mremap() move description as per Jann.
> * Fix some typos in commit messages.
> https://lore.kernel.org/all/cover.1753795807.git.lorenzo.stoakes@oracle.com/
>
> v2:
> * Split out the two man page changes as requested by Alejandro.
> https://lore.kernel.org/all/cover.1753711160.git.lorenzo.stoakes@oracle.com/
>
> v1:
> https://lore.kernel.org/all/20250723174634.75054-1-lorenzo.stoakes@oracle.com/
>
> Lorenzo Stoakes (2):
>   man/man2/mremap.2: describe multiple mapping move
>   man/man2/mremap.2: describe previously undocumented shrink behaviour
>
>  man/man2/mremap.2 | 111 +++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 100 insertions(+), 11 deletions(-)
>
> --
> 2.50.1

Hey Alejandro,

Just wondering if this has everything you need, let me know if there's
anything I need to do here!

Cheers, Lorenzo

