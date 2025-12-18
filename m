Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCC0DD6E2B0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 16:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204AA6B0088; Thu, 18 Dec 2025 11:41:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC5D6B0089; Thu, 18 Dec 2025 11:41:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 094556B008A; Thu, 18 Dec 2025 11:41:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF59B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:41:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9618B1602AE
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:41:33 +0000 (UTC)
X-FDA: 84233157666.19.B49B866
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 19BE54000D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:41:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XjHGySx8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ugrncSVB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766076090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+mmkdVrgfu3Txwq72/NRncKG6beqd/skGh7hC6q/jA=;
	b=XDVSE7DLqUp9x7g4sc+sEv15ARJiO2NYp0cxh7U9kmYHYgVo1RXHMjHdvWMGDQgiNHXXJs
	gXqJzFVgMg9PRuh/L/EYc+ken9AM11aru6A9omX/Arbtmrqqy8lddO0Y7ZnCJPZRXP1sWY
	qke3A7sxDGsThJG0YBysA07x+kRBeJk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XjHGySx8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ugrncSVB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766076090; a=rsa-sha256;
	cv=pass;
	b=FbqclldZJ6oinKvLdR6WFZ3BhbhsPEPtMDzwURkdOvMtNJjGMBnq5zc1reLhSbY9qSqaLT
	hWiLwgjkU9qZHMrRVSBOWfttuH7G8Pqa5Ub31OI9lH6yjqgys68jYPQqHMNGBi+C+gukSO
	ZTAdmHIinStdq9w8dXdqmLOAmLqkdBY=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BIDCHRB1002804;
	Thu, 18 Dec 2025 16:41:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=w+mmkdVrgfu3Txwq72
	/NRncKG6beqd/skGh7hC6q/jA=; b=XjHGySx8sJiwUnoWpXIlCg5CUt9nDQ8hfn
	cI7wdWagW/mk/TimbYhFI/sue0ylBfepnxPX4KHZ3V9J2UoB3YuIlYc+UUYxVXIc
	SKN82Ys7dNROElZ8+kJIfqT0eUf0HNvgqDV+mgcbZqzHUGEyyjuj3ItmHLFE2tjq
	kGWy/e51k9ub8MjCFIrkb8CPcU34lmQeFshgO+e4UPm89FMDjA3tK0uDGTHOVWKi
	cq8FAccMJB89KQqwPPwZSlHz89gvkBqoeg2UcrtzkyPzKj2fWmes7sfmbuiswH1C
	ElqBofUMncrraQySAwqEQgPiekiZIhRfDuNzTAmNK1M8JRmruUBQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b47n890kj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 16:41:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIGKGXE016716;
	Thu, 18 Dec 2025 16:41:20 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010012.outbound.protection.outlook.com [52.101.56.12])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkpmn21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 16:41:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YWKsuzn4Eula5MqJAxfxtgxfTgL36zESLnFm6+buJ2IiEAgHi/mUlYgtToDzcdSheN3lIuSCROJc0lbIo6C0T2gaIrzJ7j6floYiMEGXoahIcPFgdsc6mvUIbhhPUkrEGr7+IipU+bdtkol4wku+tFUc58Cdd1P5FRgcMe5rgW1OxrBHNGhUT/MLFEmvj5XfYLFXZWA5hZ2BB24MPo+3OwcQUxuFrxWhhWJl4bi6OEWrgQ0GXbn6dTbLM8LfHRpY5yLDkVCD4nasYC9RpMeRUAv0ygJH6MwVjzUkXnRiwkB0bXLJ1zzxIjxL5UPPCcFKlWFNlGRGmcaoNkl+Mv3j8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+mmkdVrgfu3Txwq72/NRncKG6beqd/skGh7hC6q/jA=;
 b=DfpC0xZ6jydOt3GHcMqzxPBgtB4bDH/tu5ZL1uqZBTdTQG/yjgET/hls4VP/vZu24HADFuFUsRsjD3neXsmcTnCyDpJSnfgnAp2X+N3JpmIJCYV8aTpmK7vIy1z8JZ4EcxOXL/2Nvl5YZe9YF9kBcSE5kIBRxXUPPSyLKzPFcaUsEYVphUyM6ENqmM9s1p5AkvovAMXDD4NE+bqpaawZh5L7M34EzRq+6l/TpeSMac9oyFiSPJm2lgve0jBIrnrPhZYKUKHdAlvxQOj/jwEe2dWSovRk+mjLe5qUH+eAGAW5HDTA/XpwhrXB6OwnIlJkoRNg1A7VQZ46+Ven6vQy1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+mmkdVrgfu3Txwq72/NRncKG6beqd/skGh7hC6q/jA=;
 b=ugrncSVBq4B1N9klmLTUcLBc1e2LfMO9kG4fSMyWA2WwpstZ/otPo7QzTxvNKaYQGl9ZDys/+TMYo7Bu3xr/PZn6sGM8Fc35gtNdSfU5xYJvAMvxp2nAMexGVTaKmOehU1fo6/dBgi5DI0WUBsjLF4b97v5H7rzxJhgoLwXHIeY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB6774.namprd10.prod.outlook.com (2603:10b6:8:13c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 16:41:18 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 16:41:18 +0000
Date: Thu, 18 Dec 2025 11:41:15 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/khugepaged: remove unnecessary goto 'skip' label
Message-ID: <hxn3cvnfglp5mtsc5ray3drhxccr3up25xsn7lzuigqjmhmyc2@oi2td6qjo2cl>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Shivank Garg <shivankg@amd.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-4-shivankg@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216111139.95438-4-shivankg@amd.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4P288CA0027.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB6774:EE_
X-MS-Office365-Filtering-Correlation-Id: e796b9b1-6741-42ac-e9c1-08de3e5444b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bruoQ1z4zIxaaSn3Tawhom6diws7EEl4HJwFFWZaOLFPT57EwupL4+4PJoyc?=
 =?us-ascii?Q?Kgz+MihIQIZ5sSrXqidmvIXuywXTGch3Q/RQumfs1qWsqorz04wgjIH7bh6K?=
 =?us-ascii?Q?lDvQCUaBUgM5Gk2Bbvt3lT+dCPu2bi6g6ojV+EG3oAsbTYUQ1rP90ZOuR2Dj?=
 =?us-ascii?Q?IsOY6Wakqy8jxrKT07ACUCiXsfGDDQuH9m/kZT1F8AD/E8HolT3sdiL/3lyC?=
 =?us-ascii?Q?kBYXO2lMrwpCD7Z7V1i9imZHF5kY7FEG4hD1DvAtsbCmIcut0wJZvOSNL6l/?=
 =?us-ascii?Q?UhTH6jQF9tBwVwP71cBQbLeS9PxJlvlrKC/2My0wng/ciAcsSuY1JiUbHe4O?=
 =?us-ascii?Q?zhPSiyThorPZ6rrC9n8NdDDn5TiIydqyl6jdIxgqG0264nLNY0eCKIte/8vW?=
 =?us-ascii?Q?9itfJ1SYT3RyfPhZzMD3uFTqKAMnkzv9o7a23XIbFb+0m4UREQ7a6bdPTchI?=
 =?us-ascii?Q?Z5LCKK+D0qFjZcmN53S4J8wcdizfx/rnLhFrMDEuEH5WJ3aoi7BB7yaaT6M3?=
 =?us-ascii?Q?OegmzqUwgU32/kvtchbDd34TXfYpvuhHQdCaspBE2osAWEByJP/GFqvMGfQO?=
 =?us-ascii?Q?4qrol7xIi2XKQFMDBfgQIgb0TLyE0oUC7nohT7LjSPAXd2IYd54+yRVDjn4u?=
 =?us-ascii?Q?kmQRx8ofdY4sirU+tFyDi3b48XJGsQtiSHl7tLQWEtYMS+MVauDBU59lDjJv?=
 =?us-ascii?Q?TGh0slsD1UBpIfkNQ3fkLnq0lfxzuqX++4Lrr/PdI3ohkwRRbD12IFzhDwwD?=
 =?us-ascii?Q?1M88BDBFej6OKzsrXZk18UZsb97R9EkL7AKRZO9ZDOjhC79EfJ8/XVL5Dfwf?=
 =?us-ascii?Q?akEu9636o7cBeIQtpEcKp0RmmJKVfNo6/eEgn+HVKT0Ca2vveUyXY+Pjbyb7?=
 =?us-ascii?Q?IW+h7fHOcHWWnRDia8sC8T6hdLZyJa/ey/mBRsGG1scCk0/O9YGOOpQLrOrl?=
 =?us-ascii?Q?vwTidW1FFVszw5k3iymDB8gnlV8DEr1jPia8WAUqPIgR8yDjrEs+473GCkus?=
 =?us-ascii?Q?buVp7H73oAg9TRr4vdfc4NSKG6/DmyTIRvvVaTyMBUR0N6vD0J0RX2jRAdNA?=
 =?us-ascii?Q?ptBt4mrh2gCDj267cvYq6Fl9DbWnNz9b1PGfT9Cs+e+jEI8surK+1UgVDMGo?=
 =?us-ascii?Q?xRRBvz4ZY07S0GhcxKyoEzXHQD0w9RSdm668cGkkbgoWy9i+zqzkbsw2+Fc/?=
 =?us-ascii?Q?Hnt6/Kec+gO/6E09hFpq3DMg+DlI1GKBFUqDV67y9Fvhe1iUfg4yDARx+jlI?=
 =?us-ascii?Q?38lN0th6lgqdRtSArJiCHG2ht3uTKcq8dHrsw0aYq7pRV6VFCcp/B5n9E9Ty?=
 =?us-ascii?Q?CU2MNtwvakdVd6r7PlrdLprEBp+F7rQmnDDbZLAkZcyWvemfsBONyMTinl9h?=
 =?us-ascii?Q?jAltQ7npXhc70Bz8AroEsMn5olOFTQCca0zXmyWD7rELBeF+XQ7KGke5zCLI?=
 =?us-ascii?Q?C0ccRWOqHmHNLYa09l/ceW0LUYGUuY00?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jfFzAMgvnrx7AUpRe+OXrWC8pj+krWua1Hjp1b0T6dupHGVaSLxPqtvC1maB?=
 =?us-ascii?Q?T6lcwrWuVFQeQCSeE3h+QnxoWSXvze1OvcvQOdtY4jClZQhuBg0B0VLs5zNg?=
 =?us-ascii?Q?R8Ahm7Lzzf00HUR/5cJ5/jvR7HmuAg33duEobJ+H0i+OYnA7K4LzfM7Zu/YF?=
 =?us-ascii?Q?wCYyMPZKGGiUob70xmQ2IDTrBmo9KYQP5XsQooNrLfaR5NQotUS5aV0MtAcx?=
 =?us-ascii?Q?1fwmb8e3ciAemBxZtoyEJhOT8/Nl0z5zA9rQyDzSW3c55h2Dhl/LZvOQCQPg?=
 =?us-ascii?Q?OqEeFTdSWa2xzEe0672S3h2BOJJG81MHMR7NRDD39ycBTwiZFlM3JzfZoerf?=
 =?us-ascii?Q?nlE8Uirl3aWGvkiNi4j+2ug5W/kS2iEIMdjF6VM1H0vtWuBX+UWmndoGqzuF?=
 =?us-ascii?Q?egRUkMvFMjhHWS0bh7hse3qu2cUWo6VJRXP2B1Mu/4bZ0CvrervVs6Ra2Bzv?=
 =?us-ascii?Q?JzDN6bkvObgS3RIONtxJa8MW/iFGJEiihYUVdX83UMaOCoQNDOq+vYFrhK7s?=
 =?us-ascii?Q?hHo4NJ3PU96iPN9fc07EVgmXYFP7v7TqLqNNM5HpOnVU9A5jBI/n4i9WpzYV?=
 =?us-ascii?Q?wEekBB32qJxZmg7cmBrTjBDlpxiizGPjNd50qFcFMZrF4mpscRHyR0HS8n4a?=
 =?us-ascii?Q?Mf93AIGxSvK2Kj0bZq6PfnQrk1D1IdJtmPxnXiVeZ/xWk/Yf/Nw++m1QrT/I?=
 =?us-ascii?Q?19Sl3MIhNQ2RMVc3zWpALRFFKf878df0s9K3LbGIfSOuw4Cu6qIHq8ynXxva?=
 =?us-ascii?Q?olc8jwhW5Vz008EfyExofTgYCmYmX7sUki80485Az71UwwlZvNWjzJsiwPKV?=
 =?us-ascii?Q?MTjLmvAb/Fl3bu1AI5qCtXSieFtAZ1ttiGxGaQhath5WQzrJp/n+g4pkOvZ9?=
 =?us-ascii?Q?SkwExGyPG7MoLs1anL3x4zzn0AaL0JbVHj0tApEShiSwRyiBMkSRpm6GhwpY?=
 =?us-ascii?Q?TBqIFuxhtKlqA0RQCVEJzejzH9kft/omoRYIN7q1+dJC0ibC3Umh8Ybjyas5?=
 =?us-ascii?Q?nSa6hUKEF3lmHPpzQjc9sRWBbgrWimgSaxZCpDWzzYNzjtP6Q2shpI6NG4qb?=
 =?us-ascii?Q?4qzpwRAGsJXAw8Ic0AoqCKNAmVCPKHlj7Apb5VGJot+pdKYSBLKvuQZ6wSOR?=
 =?us-ascii?Q?YNIrNV3kgBJGUcaRD3I36OIephYiCmkebDknD9eN71ZnFvN7tBov/lJD2NVX?=
 =?us-ascii?Q?OQ5lZDZMtx7VMk7gO/ZBjI3jpBEfJlqfK3HC0qxv3yZap6oyZ1ATII6/OOJX?=
 =?us-ascii?Q?q8UXi5QzXAfpkr6UIpsBoatQmT8wHPOJ8joiugOy4oRB+//i+32mBj9OZ1fx?=
 =?us-ascii?Q?7Cs2fuOMaO7d7ndrfxuzfWdI2sp4RQwajLmVRGmxOu4tUJYsSmAV3ZR0p+Vv?=
 =?us-ascii?Q?DVVht0AI/7ahWjH1xIBb/zQOfH1q5dK4nptGAhBLNFQnYdFpAojIB7YdbOU4?=
 =?us-ascii?Q?LOfVFX+gurYALquuna/CBkqE6lM/tXBOCYinrkCVqYNKrc+KAJbn7siQPie8?=
 =?us-ascii?Q?PpSzH69DAQlLSafi2J1N9W/3YWNkOEFm7Qu3zRF8+H4Pw4X88g6LbwBHaWR5?=
 =?us-ascii?Q?Lix7Ed8ldcGV8iT/aqmsEEv1l5t0JHGN7hBHC+95?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E8BgYfx0UBRQYXSIjedSdFqoyCE+Wl+TWt7z3nU1RYq9zoEZ9Po3FbTl/kH9QLRowYBl9106NrikYZSbw5TKtECryS75ABBALfR2A52rzPfFKtyiJ1zJollYeb5OA46rxGGnhj1GaDHiCU4kCh3XygghgI7jPUdofIMt/KrrruzvDTlJ0l7AFEKEBYSpdblnAQVXBS1GwdIP1QX6dEsngZZkk61stD5oM4nVZa3b7nSpMHNPaM+HckfGT/4ueeew041cSvBIpZEsvVem1iEA9PNAal8Qdi8R98Ll8Naf/tbEBvSJ6tkNgbfKjlj1ATYcb68HWapWSY45aE+zVSpy7sFh1bSHdEdvtHuIk6nJHAN8ZFVO0RMuvpAvqvFeF7ISy7OBN0SPTkcyLd2uGKb20rfOu03Rm2taKeBi09+txXr9eK99bZSxlEHka7Crw4/lwHo/9pg4+vGOlph3AbPxHkDf28rTBaekGcS7FvySpoAJ3ld2Ak7cCFpfNlmJwJiwqhqUPmyb3apisphCA6pwoW2Zj99q1s73eN6Ay1ArqGkx13C9hcTZuuhnVh08DDqaT7Thqx0q/y02YExpjsEI76JhBWas5i4KNmIL9ggbx0A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e796b9b1-6741-42ac-e9c1-08de3e5444b3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 16:41:18.4863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P9w8LJ+LaR4H74OO+SmtiezBbW+Vij3i/C+bnlR/3pvIgpFTwujk5UkTbqrSynY4E435+N/gzIkykb2MIRrxGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512180138
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDEzOSBTYWx0ZWRfXw8a2hqWQiDhA
 T5N81P7nqJbiE+JzB1/DLGT/N1odEOaARwKukb0mdjok+qFTJdw2Mxv/+kU/mJmG0JIz+YDkYkS
 JOV1QpnLeVL2r5Q2rKtROwL6eZhD5DB1FJyNxjWhNshXF2hfu7WJZp+nuku6tzd1eKS1Qymo5At
 Mf67KKUa88rDYAT+I0rT4MnZtn49S4BbavelBuLXsto2nUDoPx12cYILmy6RiQzaSplGz15hQ//
 kUn+F3p1qfJKVCsMJN092yEe5ncrv0Wj2gMNXSR6FLk0DppHaEFw2TH+g2KmaQYHYln9FnZlAP9
 06bTaM/AO5sOjHjHC/JmeHcRZM+241HUEiVjafkHAUR3jXosfblEb0ER0VZCaHQ7uiAzS9EPDdL
 oDyFMAe0SGQBBBIQ7rVv2gGGipT/Vo2IZ+0BCh0nwenCdbJoXeA=
X-Proofpoint-ORIG-GUID: HjE1sYhhEqKwQEOL3KghNKexPi32zPNJ
X-Authority-Analysis: v=2.4 cv=Vq0uwu2n c=1 sm=1 tr=0 ts=69442eb1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=zd2uoN0lAAAA:8 a=yPCof4ZbAAAA:8 a=3sJvQCbdZE8G6wY9B_sA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12110
X-Proofpoint-GUID: HjE1sYhhEqKwQEOL3KghNKexPi32zPNJ
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 19BE54000D
X-Stat-Signature: 4sxx89x18m95ng87fxsrtsh7iiz7xn9f
X-Rspam-User: 
X-HE-Tag: 1766076089-195647
X-HE-Meta: U2FsdGVkX18OH+xyLIFpCklnrqykz9w8kexf7rgcf/4tyxDsIvUraCZNFQekle3SQBDxARnwuKlCqf4ljqDiv5aX6oXFebG70zg4unJLW+T1PJs3/ALrJwqSEowbY4XFJcRZV1uC7Kuze+cISN8aHNWSBQ0Uf4frLuEDJYHr17/+clkGsIvGL126rPAnKd+0r+FBWl/DLUzl0y/+o9Gawq7xExwmxQMubqFOQLgWnKrkTGrbb686Q0v5RDvdi/tWgvLtvDwlHd4gi9dPQMkG2q7MvSKUyolvGdFMRemm4WEOSwOsG0l52ioFK97rZk2ZWeu1tyBQ95zcIn6/GJWPGcQhtpeFcfMG5jocKeJD+1EflHxZsvAIyY86IsgaA67i3eZf8kk9D6k88OaC4Vga+Yi4d6Qhx8cnyLk2yOj23gedGEkRfzpqsHgpg3eFc4PqMOV3Gz8IkxHcFjRB9DTglXo1cLriW4Ig2v36r4UKDx7Pq143YgOnW27rYw77a39rnMyts9DHtPtM5Z1YWQ5Aav6s/JeJ7fGYJd+RDB0KUQjGkGYJ2tXE276b6uSd6HN+zPonx0sIhwQ5SNJREANmD2ndtAW4DWEVBOnTwUmqmh0FGieH1BN+dya40cosVbZQYBlnBn+9pz5u7RfS9iiQqh5kS1vnTJVrKnNLP2AH8Dno2GuADcVQ15VZVNsrHQXNLhCXpQw55+9EJ1AyC9o5SxSNCYa7D10bd2o8WjgTW7EDPRrmOm8Yh1xOSBvj45jtLAn73i0YUIlB7MdDIMbFHok+Jo2+lER1TxR1wOaWdAmbZxSK4SzAH46YCVjLmj5WIQ871tBCCIzi/8eyqWvgOnVntuCnyzxvQmkymc2hnVJzVP0e7JqQPAC9KhOeEwH/UqfvdFtjk2jB0rBoSxRDnFPRD0oOdQx7Fh264kfeYwecdvtc5s5Fcq4rsAM0CcZR59xcXfs6vsHEwGHKM92
 Code2lmy
 QoAXN9HoJciJ6JFNHKabfSJ/FbztXtqwOD6SRs4jE7LKbt9gfSf1QTSP7GyjOhX7d4FAnX2jhKLRYZQkWFPkW70YAMBKVvmOXTRuEj/xGk1xrUZ9uUU8q15tZiXYV/uS6s270KfCaQA0Ch4yGDPwNLkz2e0acZWM94pxhtDSWlYlinTR1B6tzvTPhpjeWGtkcnNfoPNYUyvGqIaJnZgmuzyAE3Fj1TtUJEvu7kgyBa2zkYdu0THxjQUbeNOnzQ5Ir42Ko74oFn3zN6gduhKzNtIljdJfKvzxZj0zmn953e/nxDXrhb1LmHR8bdQqLPw5jx9t5XisRrR/9v5BDAyHFpydRTsWUr6Urc8Sw0xtRX7jxIOCqH46PVYpfXLd5nWrai0eEfyHlny8j3q41/97YFtEMFlnMihIwk4wIC08Rnd5NOuCPqd2O7WGmBiJjTdkenEGaTblS9XdQeuucTZ0XJ7rl18tLhDDn62+zXCoBGsNWFHzD7MXnnzt2p2iylSsyqVHeKO2JHnexmfHSiCaN9ao9daAUfAW8oTFd/9xJtySXri5CIu3d6B8KP6fsp+MTUClI/63Tpu8gyObmi1ZqfjSWZUCd9r3aVlaSN9c+p7vymJQRI1g+rfZ+69q4R4WVYBdYr7oO6oUTvWyhuwlkrKA1Lhef0791XaeAGAKUUX7+vas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Shivank Garg <shivankg@amd.com> [251216 06:12]:
> Replace 'goto skip' with actual logic for better code readability.
> 
> No functional change.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/khugepaged.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6c8c35d3e0c9..107146f012b1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  			break;
>  		}
>  		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> -skip:
>  			progress++;
>  			continue;
>  		}
>  		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>  		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
> -		if (khugepaged_scan.address > hend)
> -			goto skip;
> +		if (khugepaged_scan.address > hend) {
> +			progress++;
> +			continue;
> +		}
>  		if (khugepaged_scan.address < hstart)
>  			khugepaged_scan.address = hstart;
>  		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
> -- 
> 2.43.0
> 

