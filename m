Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A4BCA0FED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 01:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44ECD6B0022; Wed, 27 Aug 2025 21:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425E46B0024; Wed, 27 Aug 2025 21:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED606B0025; Wed, 27 Aug 2025 21:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17C856B0022
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:06:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 482FF160948
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:06:08 +0000 (UTC)
X-FDA: 83824374816.04.224CBEA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id A84BCA000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:06:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KdWljvmE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lonZfwlg;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756343164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=npzH2al4huq7EhCWJl2oAc84zXAOyX0CanZVklrgdVU=;
	b=uCpyMM80uDokJwKVmjweA7ByYgIzT3Zw6fXBTEq3s/YIzYQnXM3+TJl8hMCzb0B1EKqgMv
	ptzIStspl6740PJa2RxjzCKoF4gD1cZ6FPMURQs7I3sKd2ZzdIbvYiUgquH7UUbCLNoDYN
	KYWGLYo0z5l9RBVnU9yEXbzAScECcIc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756343164; a=rsa-sha256;
	cv=pass;
	b=4iQOvvZHJnaEoLCalm5Faz7uCwqSdhdijzSs9o5KqaJFfWcaAUjpwQks0HlWh2hGoGDK4l
	ao9fqJjX3Fw9tt1yMVmMf/mzDkQfS7T+cqY0jV4YoyWrzRfnD/oiNvAlEGS78f4sI2RQ4o
	3kyMpFJ+SCwqF/HLqMUQo3regZYlRCw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KdWljvmE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lonZfwlg;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RLHYHh022955;
	Thu, 28 Aug 2025 01:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=npzH2al4huq7EhCWJl
	2oAc84zXAOyX0CanZVklrgdVU=; b=KdWljvmEa+6Yq9B8uvPflF7PZ9hsFtLiiS
	8lPYSdNuuemCZojhn6PXuIQ0StFnNSGYEo7RZdvulhahnaRZYqwaGVg1IK48tmco
	WS9grqCG07DC1N/NOq7/W0CilkisUkcYyqMVZMXxbyIw9fo5yEGGWW2lJvvLi5d+
	KiuzyG7uwtkdPun+szbg8SUESfShLKyQWiTWsoyb9yynq3/kmv6zp95B96AqaeC2
	uJySLGfBhlFrktH5Qt3xIXBcqIRo6Jydt85T627BpzM3Ol/CH4H5KPPLyjeLz94O
	tnQ5NnuQwECgh2gsdv9goF29Tja6Qrf4vZaQUIClqAJiriJdIVSw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twea2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 01:06:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RNei6U014754;
	Thu, 28 Aug 2025 01:06:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43b9104-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 01:06:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RMMKzPJMAFZa5M1NAQ97kBqruQQ83nD41aD5gkINl43/BFWl9cOhaB5t00DpNkW+lIwmDmoiWngC77QTsF5C5GZppUxTf5yWHNP0G+SWgeNxzpeW6eXmrzXrciHTE4+f3mvw8zoyq8w8YYmN9QnOGh29JbRTLrrs2KfEc8vwmuMFVBO/3KFnPn2DrkLePNoBsS+nRvaZ7snsiApMLiRwIv8Kum9LP11MjFUo2Jo0HBx1kVR52fMAmNLeYSwmB/jgKFqKkLzHP+nURo1jHIFydh+SIl6Nl6zYSRhr8EhpX8LX9AXlPkMeMh5HYlr9h6UEMcP0+41W6x0t2h7/Wmfz8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=npzH2al4huq7EhCWJl2oAc84zXAOyX0CanZVklrgdVU=;
 b=G8vkruS2XxhNSDy+h9nhXzKo6I7xPcgrxUmTNWV0ZeVC4rzVFLlE4QWG1jQvu3sosOP0bvLQTDTM7aAwCZqkMTLA6YjLWMQHhxibXjbed15UQaJ/UU1mWPn9Mpd4ZQNmcj0+vGI/cAOOd+cAeq+rJIZta2ckKmBwkuPkIPtjlFrdJ0ky2J1X5K1NqqKJSYPjjXxri8zPFZFL4H7FToItIa22GnLbREBLfD2OH6abGXndG65lC/Nxz10zBFsKK+3KdCX68e/JZc6CKQPG/Ve2HVQ2B1qvYNNV/MDPxyb0Z1y79N1TU0QFZ9sDgTo/EO0uuPCpxw+kn1p3B+KIVP7cow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npzH2al4huq7EhCWJl2oAc84zXAOyX0CanZVklrgdVU=;
 b=lonZfwlgzk73JTZIlF7GXqc0iKOYPkMhca9+M9zpF/e1CECCk2nadK8d2PrOhdSPwNLmOUdw9gN+GOmua127O1hmemxj7X5JAd8lLqQRJAlj5O59nwfW/FRxMg5UJZgkk/jNamwgKz/Xcf6+EdYaFGhldWN0oz1bTcCuhwAQPJw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB5972.namprd10.prod.outlook.com (2603:10b6:208:3ec::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 01:05:57 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 01:05:57 +0000
Date: Wed, 27 Aug 2025 21:05:54 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] tools: testing: Use existing atomic.h for
 vma/radix-tree tests
Message-ID: <iucjeilrzonjldwizwkeo67ouo6o6nbqbnmlsyoua33737ekj4@uf4iekswazec>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Brendan Jackman <jackmanb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
 <20250827-b4-vma-no-atomic-h-v1-2-5d3a94ae670f@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827-b4-vma-no-atomic-h-v1-2-5d3a94ae670f@google.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0416.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB5972:EE_
X-MS-Office365-Filtering-Correlation-Id: be34d11f-8acf-4d3d-89d5-08dde5cf0b96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q3fkTGuyhvwmkFkNrGogJK0hglob1WgsZGy5JxhKj9ZGDGip8qkEnyZBShcd?=
 =?us-ascii?Q?vrpTzh+JR16jRMyPHACKKTsCyeAG4MreIrE+YbdUgfFbFVEWwaTvsXnyMJWE?=
 =?us-ascii?Q?2D7ZlhxHjfdc60vey9lFuy3K2Mxuqfi+UJFhXIsN92j9hdNxPsaqPtnUZmZF?=
 =?us-ascii?Q?PUAVkSxQJ+LLrJq5TQoGG04PCrPGSlMWbboYfJxlBLeqtKeo4heB/u10sLGT?=
 =?us-ascii?Q?lB39L6xepX2dfGvrI5QUALNIE5Eu/nNcGt+fE1e64wPtidXBvhECXnovPH9X?=
 =?us-ascii?Q?HUXCYvWf93FE1oQqrhnEzf05Yhkv7+7ocq9HmwhA9q1IHYl7z/S+fLBRKEsW?=
 =?us-ascii?Q?ox9Aq1ZLkh4scNUCerov/8RSPmKcExIdVmyt5+nyruMPQKqIPCRQPaDfrmYU?=
 =?us-ascii?Q?KOa9fP7xQdIOgqADEmMN45DXm0FDSYtsg8Ds9v1vl7etwWP9GpihHS12CUmd?=
 =?us-ascii?Q?vKDbHHz9IJzNwmsKVBIwNkDKgQ2ijDBPfm3Ti1ZCEAFSnF98ubRPvQWs9xEy?=
 =?us-ascii?Q?nK/cijg7yjGaid7ErgOgjPWf52jHdpOnyRfrOY9XVxip6wB3hpG46ap4eeF9?=
 =?us-ascii?Q?yqZAb6PnO+qe7x4ClZqJgVHOQivMnHb+16gZv5ECyB0oQZPXTmK90h9RKPGs?=
 =?us-ascii?Q?K+SIXSH/EmyuMO55aEiZTj0PJFWmdlXWrrFB6i0rsFLUC52HPvwRm2Ev7MVk?=
 =?us-ascii?Q?cOftDlSZE057F6GzFS+DFP8I4z5bLb58IRbU9UhNv4rQfrtd51N6kt0DPxqP?=
 =?us-ascii?Q?uvzLtmwYhN1nhUEiaTsMFaBu8FQUWRBfWzoSLZFa2nYXptOxqhnxk0IqRLqd?=
 =?us-ascii?Q?EJnRtuocLorUMA/A9yhxU8JTuvQ5hbBytveLNBTjEl9DM1bF+ka6nlgw2T6F?=
 =?us-ascii?Q?j0yuiGdqStZqQ8Cuo6aHtayr3aHWywqQXT5INRtR0FVKMWUR39SU5NHQCmFl?=
 =?us-ascii?Q?afIrqKn3R8Y/qiF+2hWkLAbHAvMyTIoc/Ff8GzO2Jr+r7uyoWjejrh1t+fGT?=
 =?us-ascii?Q?1jTTDWX0x3taocJyxkS0r5fdJJyTr3QSqfOaE1cp12Z6SZNbf00HdJT+0VC6?=
 =?us-ascii?Q?6tArJX0TBSpmXmDjwp9sfjx0opyIO19rMnzn33BeoJTULCetOIBKhripCIGe?=
 =?us-ascii?Q?Naouhg9Cn3BcpsvumiwRCV42b6L6sg6DRnRiSyGC0zx4nlfjKZwreYPAEraq?=
 =?us-ascii?Q?r4E9/RZggXfCYlYWBRvabqvIh+n+kmWZWCltX3gW1H4X6tCCgAhEzxAHMv/e?=
 =?us-ascii?Q?+UAom9ulezc8Ho2ALnsogPIggzDFErHOvrESb7DT3OPlYC7PKw08Kp0swCSL?=
 =?us-ascii?Q?xuRiibDDA9qTL1lZKkFK6OU+D4x2TIqUAkeZ7C+4kVfbLFHxykk1hogNCYDl?=
 =?us-ascii?Q?sxZFzUziQMaJjxBhG53iGmHGC4XzwNwXQVZcwNB7iYaPVqScSOg4N9OyKaAO?=
 =?us-ascii?Q?Yri0wxvmgM4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mP7ZH2m5azgjtQ+ipxHXaURghn68SZy7npjRg2y+q64j5mTOAwwFlGPkD52l?=
 =?us-ascii?Q?DPLgqKp7VupWMT95IiLHrukig+mCph4qk4hHku1PKLmR4T2C6xBYBbShGqNl?=
 =?us-ascii?Q?O7tdHVQy1QRxIviAMqpuD/oQPLHqoRvmKODHTyE4ntiRL/8IOZj1i2t6W+ML?=
 =?us-ascii?Q?Z1DdTyFOKZB4aL+Nen4aD9PQKXKiMlX5TBR9eaZOhkWuH8bTbrSDlctmvj5W?=
 =?us-ascii?Q?fD1a4Am5tdKILe5X7wrz+rFCpoxklq+cedulk7+GkK2ZSA84ZJHgA44jQoa1?=
 =?us-ascii?Q?LUAY3GhXRvQqMvPvutzCG3QunszpCs7zTXOx9GsJFoRNtKEnQCTHzD9e9Vfc?=
 =?us-ascii?Q?XzO69sCOHvmPJ25St8SZKxmXDVDn0BW8Y9dzzrnjnYX8HJCEAIZ3dc1iwS9F?=
 =?us-ascii?Q?zBGMFpsvG+Y9fDOC+yTdyPd4DjBgoLWLloEESoslveNZIF3sO7xw//e1l9PF?=
 =?us-ascii?Q?KYbh8OnRNZSMhqZ4X95RPWRG4KJkj4cBqWu7OlGP2rLW6dsk/D8Ax5XmXmtD?=
 =?us-ascii?Q?uz/WmyDYm2DbXWdtPU6OnK0EqWtDXhs6k52robZi4/EchW6U3CFM4fh5Virs?=
 =?us-ascii?Q?DHSoSCcUHZWun8iMrZ7vxMnddfZOQzEnoY2eAd1+5GxclG8mPLrzgQcvGZTN?=
 =?us-ascii?Q?ru4cOS/CkzJTDnW0LtsSiuP2PXukzo1qHn0LUuCRWKLh9h+EkE1ksL4aRnG/?=
 =?us-ascii?Q?Wixjf7Tktp1RJS+O0yNKI52j/FJj8ZrWQXwYBXZ7y74tmjy4WxVJrnWgru0Z?=
 =?us-ascii?Q?8gqKRDRP/TY5DHLbksWZghmcfQ9Ozmi2Gdjri6lHnxD5tI2ZMILDxGT6MqA+?=
 =?us-ascii?Q?xFtjcpPEzcBt15GyO1d8WbaO0ZtONjayIY42cAFX8EfeHYWAsbDv9fSyV7Ia?=
 =?us-ascii?Q?y+3NgSueu6ljpXVMe6XAXZbNva5L2AlkmaKtOHc1CkYbl/IYshpkw950pRM/?=
 =?us-ascii?Q?kRCkImTh9et8YgumsaoLVVTfB0wCq4l60UINmwyPrHqN0K5sWhD3p6XwxdPj?=
 =?us-ascii?Q?ZNOrDuFVhVpbf2rSA8oXEEz7r1NXtp5eXZJf8tQfyVkHk5HmzqZ0lb1yJ3Al?=
 =?us-ascii?Q?pPSPI3SkgSB19QQgLtRqXnFVUAhkHDhPE7RUMFzHVKomcUQLUB37M6GWu1cb?=
 =?us-ascii?Q?1YspwcsyqopWy+in99LmvLYf1RLDxHmjsgDZO7+Ws89UBU3V0VXIfp+Iq9/m?=
 =?us-ascii?Q?KY4yZ2cVamJz3sTObE+ZlBVazF70i1B2U/79rmvgy53hXgg0Zv7CYCexhdsK?=
 =?us-ascii?Q?qKUduIrZ4TgydoCWEi47SRQHPlAuZ4Fp/8srFFWlcncMMBfNS8giBEC48HK3?=
 =?us-ascii?Q?6RhM0K7+jVt0aUVlGJ98zWY7rjH+rPuiUhoT42Kl6AQwD5Kr+xTYacWfbpfW?=
 =?us-ascii?Q?gPVA8CHLJDSdDbRWP4hxWDNMu2st0ktKZoSAnNo214+u1k3Xb1ct5J6kn01t?=
 =?us-ascii?Q?DG8J68sP8p9QBOjrwaqrgx/p99rM8OBtwW20qQeWL03lfRDv890fbvD0x0uI?=
 =?us-ascii?Q?XdW03lEYMbpS+E5/P5Ic9MTIcjTNyopFMeC1jdEc18JwDa5HJM3ciE6V5JbD?=
 =?us-ascii?Q?+HSxdwRbcKLvPnh7JARMUb8/n75kRgxC5RVb5bN6XN7K2L+rVf4wokKS76Zx?=
 =?us-ascii?Q?kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BLWw5ebgd7d4Dl2IOio+klqeHDslg9XFK0qYFwbTTsKs5jHcdDVRIw/I4+CxrsC5trwWfRhEULTnNa9fTJ7bYHTyrh01F8+Bl0q7tVpWEb2NL3q/3Fy997DWE7bdoHCDPUbUkkTi6Hrr9CMGTGdn8qSCbiFVFDvXHNJDs9wyQn8GQv0bDFdNvhjvwiIlkaf7aWmD7mPAq/aKccIjYU/qyOGC+5Px1SKIXwfKO0miamf02QeOnhsGD1zwFl/DOPGsuu2rTC8Aq55ZS+8Cf8heQCLvU1rjT1CHRYdQNnkmPtijWzyQX0jXZkn/31umQqdes1MCT3L1oE3434oh4DhZJNHakupB8kY9ZLWfrGZfzpvnpmRbXxzS20Wyi1Ov1upBDfIPtXfcqpDqz7CpOojm1Qwi3CzKdadS519Q1KMkcH+sO5eYT8/0WPNDigMEi6NmXX2YBY60aRn2wyDcrNNIcrSNYy3mcIWD9APaYWHLTvh3FcZyIPjBhaYtRDRz1QSmfJUPn1jo0EN0UM3a6XQ5h/i1eKoNs7enMR7T2tDDuxZlHEUIn9IJGEnUvTR9BJKSLul3nDdn47ColKMyoio8ZKz8WO/F5UvvH2gyLMT1ly0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be34d11f-8acf-4d3d-89d5-08dde5cf0b96
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 01:05:57.3154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LTDG96EfIHPNh3uSZl9FmH7Rbn2MmBTWgr4lU+PLxzR3Q+3XBktO87wGBsO/NqfdMqqUiv14HnJnk1gRK0r/jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5972
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280007
X-Proofpoint-ORIG-GUID: eeZtKIJyVg786-BlriPPrffM652VZHAC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX1A4ZbrmRKABo
 b/g9Sk4rEdDBz8/kQqmQfIrXMBmlngUF2AGU6OG2E8QlB3H9jWLSz5xNXiWMbHzUndB8JE9dZfm
 2LM8J/Q+yfwqisbgbmP9XfviRA7sKeVeiWkM3CnVC3BA35+a/rWXSzkY/pVjAJDGUB+vP8xFQEJ
 DFAIIsSEKLUUQRoLzjJWIT7Rjm/5rW1iGI5MxobUplk9SY8UyzKtdmrt3wHLwKXLVYS4t+NKo/s
 v8gGMslBOXHaqlcCYCzWYY2nVL3uRNOuAYhhAc9brHwN1BbC70+K5GRWnyayhMMrX7elZ8nl6S5
 165kj/aBolBiTzegGWXp2ZnN0k7grrGiie6cSG82T5vX0x09+DOLzxPccxitd4oZZMOORL06wnf
 a1KvbolOR58eFWMHIEK1QB4BXRLYZQ==
X-Proofpoint-GUID: eeZtKIJyVg786-BlriPPrffM652VZHAC
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68afab79 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=FwGiae7DSPBwYh3wwPQA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13602
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A84BCA000D
X-Stat-Signature: 9im1orqyh6dw5hf3kgzxokjjojfkczah
X-HE-Tag: 1756343164-941251
X-HE-Meta: U2FsdGVkX19QKCR4W9Iu40jmy1g430PU0esJ0jFkYLca9/uV8ZfH5CSFrDQToRA/XV1bbV5iAZhQfHeF8vIMUuQRXmELnCAqBzu/LYaIbkFZP2MY0RsVgIkY0zLk6HB0Og4Rj7hacmqfm7O9GyO9RibRKJJgEeRez3+6xh3GNK6FP62XDPlTcOAJfp2ptyd01VfzSgHUwzUE+yx1vo4EVRf5lK8fze3xE3XhbavRrRSROsaolATtdlT1Z0x/pS+Qf0zkb411Tqw1BQIfYbqC1udEyJt76hwUqhpXYpNKYdpjWCLdNZ3DOQK1eU3fJHHJK7a+FDB1iaHUrRJV2VGk01eAl6wL/hYBtVw+V0C/GB4slJ3lnAVFrhOyS+jFPKBnInNZO7Apogp39Pfdv257Pu7p14k0SVOvOnC1zN7+1SAv/UGOVLRRH2dfR+px+cSz5MkzxlbQ1RLd5Xz/W8SuOhF74LJsV4TJ68b7QfSB2lCfKfKJ+ICo18Siqj6s3pZDGUQtpy9e1xvxZR9rFvIN7G1i+78If0NCXKeLlJfsyCbWroYPcJLv57w1DvXpTzkJkbhVHda+FN41GCN+tS8MMKqTyCCZmm/09R75JF4o0HbGHaCDl7RU7aH4sGwxXxnBzvKyhHuIYhQjgCUKgt8eVHacinGkJ0sgAFR2xrX04BmR0crs0MDGw5KVrGGhCh8+gLqrFxL6SxSkfHqKpYubpjucXuRYnCcI/BB3j2cn4BO3U8xEx0eACP2DHJgWAKw3CmFvlVfg7y8VL13T84SrEn02bxT5hb1zCieB4NBp52Nnahw6FtLOPJniNC2MXZZGvAmDvTHlHycWjJ1J/7/CT9U9L2JvcDex0KDlore9p9d3xZdnDqGMGgbR7UIjMUVC1JNWczL/dpBmYzyFxXW0pY12QPvQ8nItNaiLvMP1ZkR72cLoVAXookaZZ9eZ9FchtzuqeGB3KFw4VVLueTk
 21CI7TCc
 AtC7fa1DffYb7/XKZe6cPNYNynkdJmP/R5IJfwBVp/5nF8ZciYxtpO6PArkwjkDwMH26kLzZ3gQoi0c6jU/o3nY5rHOsLZW1fzw/evSVa2EBxbhsPJZe2o2lyilhteWerfUP9dtR1NkONga7VUxIWCeQH0KAoWcSvADO/QoPn7qJrnRUReOymwxs/oXNOibSfEf9re94LDnUqvJRKtFRQ3RcrhtqJhLUNloVBbSOa3lG3MLzzcc8VzjBgw9jbe1YE2x0164DCLmN+Qi/fo3ut0265IMV3vP3JrXyaoLsn7dm+bLs7bMyicKi3g+6AEQ7P60pt81/5tlFufUTa135vcuF+mzopG138AIJOxLDvIRFCD9roZiXNopL84aurpHiFzJZ+cuisC/GMGovFVLndJnQSz2w+zXzOSazsVGEjwod8+3fVOxCaLAas2KwJRoU5Qxbkhh43GL2f+0Uqcgr+CcFKALKeikkJzWlwxeLN917jCccFKmWZ2WrLiH4AJs3QF80YcO8RPjmaHkKdJhWeiu+liUh241h4LtEM9FXOimUh1UzpkLqRZnmqatjPXDPiWy+huXaio1F0hI4yLGVSn+HCx4ls37PcBSuB8GP5KuiwpNEmSBRrz4Jhbakj2jp3C+tD5bQrJxgcZQkjDU/DqW4UUqBTATW4uoZesjbzZ8RiSeD6kxnFW0PSvgQaZQNYRIHGZSKiSi6ViWE4gKqvLFf1SNuoRFx/LnWfqrAejxn6vFVz1/CjuOqYDFOa7znpFkFDywqHX/La+9Sl+dnLcqzmUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Brendan Jackman <jackmanb@google.com> [250827 07:04]:
> The shared userspace logic used for unit-testing radix-tree and VMA code
> currently has its own replacements for atomics helpers. This is not
> needed as the necessary APIs already have userspace implementations in
> the tools tree. Switching over to that allows deleting a bit of code.
> 
> Note that the implementation is different; while the version being
> deleted here is implemented using liburcu, the existing version in tools
> uses either x86 asm or compiler builtins. It's assumed that both are
> equally likely to be correct.
> 
> The tools tree's version of atomic_t is a struct type while the version
> being deleted was just a typedef of an integer. This means it's no
> longer valid to call __sync_bool_compare_and_swap() directly on it. One
> option would be to just peek into the struct and call it on the field,
> but it seems a little cleaner to just use the corresponding atomic.h
> API. On non-x86 archs this is implemented using
> __sync_val_compare_and_swap(). It's not clear why the old version uses
> the bool variant instead of the generic "val" one, for now it's assumed
> that this was a mistake.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  tools/testing/shared/linux/maple_tree.h |  6 ++----
                              ^^^^^
Did you say radix-tree?

I was going to accept this because I put my code in the same directory,
but since you'll be respinning..

>  tools/testing/vma/linux/atomic.h        | 17 -----------------
>  tools/testing/vma/vma_internal.h        |  3 ++-
>  3 files changed, 4 insertions(+), 22 deletions(-)
> 
> diff --git a/tools/testing/shared/linux/maple_tree.h b/tools/testing/shared/linux/maple_tree.h
> index f67d47d32857cee296c2784da57825c9a31cd340..7d0fadef0f11624dbb110ad351aabdc79a19dcd2 100644
> --- a/tools/testing/shared/linux/maple_tree.h
> +++ b/tools/testing/shared/linux/maple_tree.h
> @@ -1,7 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0+ */
> -#define atomic_t int32_t
> -#define atomic_inc(x) uatomic_inc(x)
> -#define atomic_read(x) uatomic_read(x)
> -#define atomic_set(x, y) uatomic_set(x, y)
> +#include <linux/atomic.h>
> +
>  #define U8_MAX UCHAR_MAX
>  #include "../../../../include/linux/maple_tree.h"
> diff --git a/tools/testing/vma/linux/atomic.h b/tools/testing/vma/linux/atomic.h
> deleted file mode 100644
> index 788c597c4fdea7392307de93ff4459453b96179b..0000000000000000000000000000000000000000
> --- a/tools/testing/vma/linux/atomic.h
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-or-later */
> -
> -#ifndef _LINUX_ATOMIC_H
> -#define _LINUX_ATOMIC_H
> -
> -#define atomic_t int32_t
> -#define atomic_inc(x) uatomic_inc(x)
> -#define atomic_read(x) uatomic_read(x)
> -#define atomic_set(x, y) uatomic_set(x, y)
> -#define U8_MAX UCHAR_MAX
> -
> -#ifndef atomic_cmpxchg_relaxed
> -#define  atomic_cmpxchg_relaxed		uatomic_cmpxchg
> -#define  atomic_cmpxchg_release         uatomic_cmpxchg
> -#endif /* atomic_cmpxchg_relaxed */
> -
> -#endif	/* _LINUX_ATOMIC_H */
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index 3639aa8dd2b06ebe5b9cfcfe6669994fd38c482d..a720a4e6bada83e6b32e76762089eeec35ba8fac 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -21,6 +21,7 @@
>  
>  #include <stdlib.h>
>  
> +#include <linux/atomic.h>
>  #include <linux/list.h>
>  #include <linux/maple_tree.h>
>  #include <linux/mm.h>
> @@ -1381,7 +1382,7 @@ static inline int mapping_map_writable(struct address_space *mapping)
>  	do {
>  		if (c < 0)
>  			return -EPERM;
> -	} while (!__sync_bool_compare_and_swap(&mapping->i_mmap_writable, c, c+1));
> +	} while (!atomic_cmpxchg(&mapping->i_mmap_writable, c, c+1));
>  
>  	return 0;
>  }
> 
> -- 
> 2.50.1
> 

