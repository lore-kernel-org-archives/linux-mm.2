Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D28D38FFF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4AD6B0088; Wed, 14 Jan 2026 12:54:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8720A6B0089; Wed, 14 Jan 2026 12:54:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5036B008A; Wed, 14 Jan 2026 12:54:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59C016B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:54:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE8B61BB91
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:54:17 +0000 (UTC)
X-FDA: 84331318554.07.86325B1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9048FC000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:54:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Z1MBnkui;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pjD3Po0V;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768413254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRZ7VHonGSbzHaNC/d8wXRBZGCK2janiJX4BSggXlkY=;
	b=u6r/KV5aMWBKSQpY0Myqy0YE7CMB7wtYc/0cPYhaQ62iKEhvveaiteA3LcQ9Zpse0bBTo3
	325B3hlDPhdw6rMpox366Uxu8/lILOQyJlRHrbeRxI4wn8Y8zb4dHusY0Bt80ZjoFo3jqm
	y3ECjxt5teacHf0GJOxYApt3O36O5oU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Z1MBnkui;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pjD3Po0V;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768413254; a=rsa-sha256;
	cv=pass;
	b=XqU29i9fw+Xgx4w+7e0hAW/QsrG8eovQEqoizC4BSM93kz4q6VWubvkyPLxF/t3sfEKrgW
	RrVLmY+Zv+5F/xMdE1P1GFrA4C+qk2bUKSwJzhRHwCplBBNkxWjU+AhnUWPT6moa3C9M20
	jkCCXmZU2nU6E2qnR1JPczacLXRLsAw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E6D1PU2811664;
	Wed, 14 Jan 2026 17:54:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZRZ7VHonGSbzHaNC/d8wXRBZGCK2janiJX4BSggXlkY=; b=
	Z1MBnkuiRfe4b+9CYMMQs8HTXo5OC/pdiWuQ+uwyWN7fil/XPThtEndvVwSObsHN
	zSqKqNtTRuzCRs/HRtPA7iVa9Q8KZQvM/LgyV8UhxOhi/NPzgMeo9e0rtLQSr8Mp
	0EzrBrndf9rFgv8A06JUGaLIJv0/PBKys7UVBRzcfKs6OCDLbrEUttQMjwEkcEyt
	u4jmjmMfCVstJB7m2jQJa9N+1vFTrXJEU6r6GXf25TOrvnBvLiHtK6qpuoa9+abO
	cov3yC6LnAMVTZP6dVmXL8H+NiPnB+pFCVppRxmfQECc0SoSyKkBHyIFAs2/WJmD
	NO1aKTUYx5unAs2k1sTOTw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nntpw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 17:54:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EGJ6W7001924;
	Wed, 14 Jan 2026 17:54:08 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012010.outbound.protection.outlook.com [40.93.195.10])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7aaqvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 17:54:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L4yTVgDKJ+rCsfkthOKRkPTIhYv7K+iN13gOSfZ42OMk9TI/yquuy1GTk3/tJBLc745VSWDMw7T0+4CJ6d0KGOYlfsYr4tsT6WVji8rsG88iR5h1Y0ass8Mf9GbQzvm74LQZ/V+YktoSFq4R+reJLI9U+rmADorAXbjsAehtheBqNI/IruhhnRmQq0xzgd//KvBm5EgxRISjDmX+x8OR7HfjACEARuOMz+2pvOWWfA/Ff5p349CGmp8qTzxmo1ZPdHaqj9PgClqjoE+/0IYTqqKjo0krc1JEpECnxqyObMF1TN12kG7YQtWlb9xH/A8G7Lq5hqEg+Wx55R5PDNs9Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRZ7VHonGSbzHaNC/d8wXRBZGCK2janiJX4BSggXlkY=;
 b=eFDEqT4w1ykbshdkEm+aUKC1PcVVWDAE0C3jMDNNeAeLtKabKf10crwMTdaZJo1gb0Jd6SsOV2zr7gsLJkEz9HLpAQ6MAiCGgFMyB2OHDoi6PIajY9x/GwiJRGLbJT3BqobxlrE+3Wwe50th7RLrpVOVT632OxWo8wmtBljvRO0GyJyA5mZCil/uUJ84/R9utEv95n/6IVQZm7qcsxY1yXUfBw2ALCTkbWsn8miKCqa+FCAu+pBehrWoEwSufWD4hKZJc2SA7GZ7Zc9vjmAY1C6eBgjY7/Qz/R2qTvtBqJrh9hSQWRQyUb3CX49X9zVFbGzFw0YnHozGVWsw6bNhmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRZ7VHonGSbzHaNC/d8wXRBZGCK2janiJX4BSggXlkY=;
 b=pjD3Po0V4zbjhRBgeAmLkVaCXaxd5ddiZBOvPbziw0J2Rvq1Hk3yDdVgcT5Id66bFo06GdQQdbRwh6++Pn9pp295/Qry8QyohwCClM97KW5bMOwtgiamgXxGCeYZIV5QzjqlSL1VfT9NsjknppZVurvHlxMLBTSo9ERV+ePTd6s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB6288.namprd10.prod.outlook.com (2603:10b6:806:26c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 17:54:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 17:54:03 +0000
Date: Wed, 14 Jan 2026 17:54:07 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/8] mm/rmap: remove unnecessary root lock dance in
 anon_vma clone, unmap
Message-ID: <2808d8d8-e772-4210-ada4-2b39d30c7029@lucifer.local>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <9b5a438237e4ea3b19a986a4f8fddb8848cba54a.1767711638.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpGcdZE_Qnm4c7MgyZfZr7fepXuJkc=6ucwUNwUo_JjU0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGcdZE_Qnm4c7MgyZfZr7fepXuJkc=6ucwUNwUo_JjU0Q@mail.gmail.com>
X-ClientProxiedBy: LNXP265CA0047.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::35) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB6288:EE_
X-MS-Office365-Filtering-Correlation-Id: 59f15ddb-d2d5-4f50-ea35-08de5395e791
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1hNaGdCTzA4OEt4UENHaXpPeDZhZkhMQUJYZ1d2MEM2SWNGak1oVlo5b0xr?=
 =?utf-8?B?ZUdqeUpPRVlhaHJTUmZSRVV3UUxHZ1VqVnBEYkFmMW1kVlMweXF0aXAwaVFr?=
 =?utf-8?B?Yi9QNGpnNHJNaWk1MmN4ak50QkJ0UkZ3aExaNkcvWkk0cFFUa0dDTmVTNXIz?=
 =?utf-8?B?MVA2QXBWN2Z6aE92YnVGaU1IN2gvT1o1bDh5Tk9wV0FPcnE1RHhnbFlCcXZM?=
 =?utf-8?B?V0dEYlp4Szg5eVhNQVhwYVk4M01ZMHM2UllnOHdTMVppUElUck9yYUlVMVow?=
 =?utf-8?B?VDk5TEtneC9DQXp5ZWJoRzhpMFVaUXAzTFlzUGRDdEU2b0ZFNVU4UWR6UjZn?=
 =?utf-8?B?UDlyNytnMW1KREJ1MFlQazlRWXVVU1BHdDhzWDdJanFNdkZQc0pOaVRRbGNx?=
 =?utf-8?B?ekM3NnB6SHphWW5IOEVlWnZTaFdRak5DVTB5WFRnVDdrQmFjcEJLeG9TSVl4?=
 =?utf-8?B?c3hCUDVlY2hMWUp4QXVldXAwWHJaeUFXZk54Y3BjZjZJaVdrS0ZPZXkzYnpk?=
 =?utf-8?B?ZTJNY1NDVFN0Q2p3N3NjK3N3UHpZTkw4cUw2YW9Pd0Nvem1wOWs1bGhRcGRm?=
 =?utf-8?B?WFFXV21HTVZXVVN4bEhoTlozTmdwQ0k0bGFjaGIxN3dKK1lUc0F0clVvTEF3?=
 =?utf-8?B?SFNXVEJxbER2Mk5QM0N2cG9tdHV1T08xdGp4RTljS1RvMjlrcHRqZHNsSitT?=
 =?utf-8?B?RG5ZWlJlZTRZT0FXN2ppdGxIeStNenM0MTJoeVY1M3ZVd3EwL1gvbkw3Unpk?=
 =?utf-8?B?SDM5N3hMeWtoOHNxQTMwUnIzM3BTMGQrNndwbkVETEp4ZHhSWWN4UDh5RElx?=
 =?utf-8?B?aWJkbk41bncxYzlHc0JTKzRaN0lmbFhlWVNnelN5VHR1WmR6WmxaM3A1NFZw?=
 =?utf-8?B?VjZNME1OdnFCYkVlZWd2R1BpVE40SFk3QlhxcldiSmRTMjZUemQzNVd0Z29T?=
 =?utf-8?B?WjVyQ0J2M3ZQRkdDYklSbUprbW9JTmYyeGR1OTJaYVh2UWxSNHk5cDhUVi9H?=
 =?utf-8?B?L0c3YThZcS85ZDAxK2dGUXQ2STVWaWdDNjk1NGV4TDBHT0ZMSFRiRm04TmRl?=
 =?utf-8?B?TkwybTArem1ibmh6MWc3WmJYT3B2SmJEYUpUWFI2dzFUWnRtdGZpZmpoNnZP?=
 =?utf-8?B?ajNxVlByWFNVeWtFbVFlN2duTnJya21MYzc5bVEvUm1iTDJBRlpFeEpDZXUw?=
 =?utf-8?B?eUJmMHN4WlZZam5ES2J4VllZdDgzUDliNjFBMkFHZ2FhUTVVMUdOeUoxNElx?=
 =?utf-8?B?Yk9ISnFDcTVlYWdXam9LOGZkU2NYS01sbmZYVU10bkV2czVMZUE1dmlaOGhQ?=
 =?utf-8?B?WDJUbXZtTlJyZVE3bm9EcmxRdEJXZHBjd2JCNlZBTlBMSUVLMVhaV1VnNEs2?=
 =?utf-8?B?a0lYR0ZJNVZXV2NOMzFnM2RQbzJxblVDYlJsdVBjcW1rMjJjeXVyd1hUajlJ?=
 =?utf-8?B?WElUOUNCTU9TbDhmL1B0dGMxQngxSHJXYkhWZE1BMGt5aVFvSG5NbFh4YXlt?=
 =?utf-8?B?SFdiTW81UzhyWFdFMjdETCtWallnRms5c2w3VHZzaTI2TFdHUkREK2ZiZm1x?=
 =?utf-8?B?b1M2QlViV0FvN3RBWFdWcjhsT3B6bklEcG5PcTlUS1pzNVB1d3labHRkT3cz?=
 =?utf-8?B?T0VtYmVVRmh1cDVPdkJDY01xMEpDSWJEa2M5bS83ejIvak11NGhOQzRkOGgw?=
 =?utf-8?B?eEt1SlVXMkRHSzZqaVVtN1BRN0QyUEMxalV2cFdhQUsrbFo0NEZHRlc5bFR2?=
 =?utf-8?B?MTFIQm9Yb3RwQ1VSdGJHNHRjTVZSNnNGUFNpcFJxQzJBbllXMmRENWd6OHVN?=
 =?utf-8?B?WDVHY2V0STZOK0kyQkI0aUZ2eGUrOEVreERHeVdZMkhGK01GaDFLTldMMmtD?=
 =?utf-8?B?SEs3T1NCMlVKQ05SUm81Uy83S21kUkVYcThpVFA5Z0dxNlNEK05tRlZ4aWxO?=
 =?utf-8?B?V2xrUVJhVU1GM0lTMGZab1pJTTJjTU9UMWJ3bFdhTnRIR1RDK285dUlQRVZP?=
 =?utf-8?B?UHpyM3dZaGhzQ1RoenhFOEpXcFFhVFBUTmpTaFFGQ0dDR3BRUDh3VFZhdWZ0?=
 =?utf-8?B?anNKczA2WkY3aEV6bjFOeXR2K3gzaUs1YTF0TzFpK0o3a0lFUmFmZEJBY1Yv?=
 =?utf-8?Q?V8Eo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXJrNlFmNGdCMnovWmZFZ1d5eHpCZzRvMkU2N1M3b3JzUDAxVnpvaUJSQldU?=
 =?utf-8?B?eUVnVnVwRmI1Z1NxTGgya2ZNaXQ0U1BBU3BSdEVRM2o2UDcxeDdOYS9YckJI?=
 =?utf-8?B?UW5yOU9KcU5wWHBRUGNLYjkxTklKb2Zxc0ZRN3VjQmxmMGJESGJPVHlmRFVC?=
 =?utf-8?B?QTgveGVxZ29VWmdQWlhyQzBSQSt1QlZGUmZRT3lrM3l3SlRpSDRUaG4yS1Bz?=
 =?utf-8?B?RDV0NUtrZDJZTHptRWE2WmoyQW9lUGlMb1Frc2NZR3FLUEJSMHMvd2lZcEdh?=
 =?utf-8?B?ZktPV2ZUaFVvelBpQjhiT3d6dE8rVmNUZ2VtSXlvMnBlUHpWbkUyYmJ6VkRS?=
 =?utf-8?B?cDd2eFRlbG84dTRTYnBTV1ZNVkpYU0dTNDYyb0wvbThsMExBeUFDYzNpcVBE?=
 =?utf-8?B?S2R2cmNRQm5WNGJoZ1FLbU5yeUJwSXY3dHRRV2NaSDBTbWJ2aXB2bGhFYnBz?=
 =?utf-8?B?NjBQMys0K0RUUjJ6aXMyc3orOTU2aTZEZXIxRkQ1UnBMSVBuYkVzUnRLdnVw?=
 =?utf-8?B?aWlaeDZ1ZktuVWxkZ0tvblFKa0FqOHgrUWxUbXUxaUdIY1NkTFQ0Ync5cStM?=
 =?utf-8?B?ZUVZdjNoMU0rcXBMZ05lc1ByQnljY21LMVRLUnVNelRoRWQ4VVcxTy9JUzJS?=
 =?utf-8?B?RnVkSStpNkVaYzg4VzhrWGhCcEN6N0M4REQ4ZFhEcDNUUGVYUnBqanpGZ3c1?=
 =?utf-8?B?eG1VT25VTEU0UlVic0FRSG5wbEY1R2t3MWxDbnVmMGZCOEJJVjlQZ2xjRmpw?=
 =?utf-8?B?TDZFelhtR3lsSEZIUnl4YXVXTUVOZ2MvYTVaU0wwNlhSbFFpVng0NTBXUUVh?=
 =?utf-8?B?bEdzOW13aGhmS0Y3L2FIRklvWm9YVEpYSi9vcXNHYmU4Q1gvVXZDa0VHUXo1?=
 =?utf-8?B?MUpPK3dPeWFPV1hhNUMxUTQ0SUxvWHdQT2hWSTlhN1EybGUrbWVuR0lmYWwy?=
 =?utf-8?B?bTk5L2NXcFpEZFlJalNnOHpnOEhiVmt6TW1Kek5QVTRMTnNpNFhndFc4MkFy?=
 =?utf-8?B?Uk1vV1p1WXBOS2VPb01sc2xCYXA5bGsxMmVpUXJ4WXZzelhpMW5ZR3BpeWEz?=
 =?utf-8?B?cmtlMW1GS0lRQlh6b2M4OGFlcHh5UUFqVXFabGR3WEs4ajNBUW83andyOXBy?=
 =?utf-8?B?czZ4QklPT2o4VzcvK3lFYVFYTUZKcmZzS0RLNEZmdlVjWkY1RDdXanBoRFZV?=
 =?utf-8?B?RHJKRW5vMFgzYnc1UVliWEdLQlJDU0YwSDZzMFBWN25pUzhMMTk3VzVNM1RB?=
 =?utf-8?B?V0oyMnpTdUtHQXZCcHlwWDQyeWhERWZ3dXhmODRXemV5MHRnckUrK3prc1dV?=
 =?utf-8?B?eXB1OEtCRit3amFhRDQ0aWl2OGtrQURybk90MHdUbldOUEdHN0xiNi90TjVl?=
 =?utf-8?B?Y3ZEOHBUaDkvdUk4NlhJVk1YRmlSc3ppYzgvOEVWZzgxVUlUWjdvdUc4dk53?=
 =?utf-8?B?NE5CQXFnYUdodWVQdlVrRjZsbkxxanJtTDMzT0VKN1JkYUdBV0xNNjFpclo0?=
 =?utf-8?B?MHg2K2c5aG1LdXVGZzNPdDlOVnNVQ1FNbGptMWk1NjUvdUJLWnYzUUVvd3V0?=
 =?utf-8?B?dXN3cGdvVEUwYXhXY0lzRUMzWnhOWnlDNkx5ZGdwTFV3MERYMHNnUXFYN2Ft?=
 =?utf-8?B?TEptNi9KTTR3L1NDOTZ1SklSN1VJQ0tObXhiTWExV0l4alNRVkVBTEFJdlZM?=
 =?utf-8?B?T0tKakkyQ0RQcWFYaER3eXNqcGRteDBKM0wrVjR6OHVlTXdGN2h0cEdaT1pW?=
 =?utf-8?B?TGFVUjlLOVFYWFRxWVZPOUxROVkzU3kzelVrVGwvUE9sUHN4cGlwdldTYUFF?=
 =?utf-8?B?R0N6VXJnT1pLSXNENERUcldhNVh4dk56MjY5YllZTnlUclBmMFd1ODN0ZnQw?=
 =?utf-8?B?bjNtd0wzSVJyQlVGcWN4NEFGdE1SQzBGWnFXS2w5Mi9QdVRWUDhPaU1ndEEy?=
 =?utf-8?B?QkpRd0lwRzhobmFDRmtYaldpR0k1VGFOcHRjS2N5bFhlcXlyZC9CMldDblBB?=
 =?utf-8?B?THd2emh3N1h4d0JvaHJ5QUVnZVlKNWRFbVlTaFlVc05kYlAxdVVvbnp0eThB?=
 =?utf-8?B?WGJqb3JYN1RZY2lOdEtjUUw0Q0crV0xBRGUvYXY3RjFnK2QwQnRiWGxtRFd5?=
 =?utf-8?B?YzlpRERNcjlKRlBCN2NUaW5iUjR0bW1rblFTZUhYdEdMaDJoZmdqakxZK2JY?=
 =?utf-8?B?eC9wZ2JscEZHNzVHK2lrS0EwbDNuL0dtNDl4b2dNNFUrYU5zTmJ2dVcrdlNU?=
 =?utf-8?B?ZlFTTXd4bU9VTGFVNzlna3NsSkFiek4rWGFNN3d0QzlJZ1FkRVQ3MzlNM3JJ?=
 =?utf-8?B?K0lCdXh2b0Urd3o0ZVVidjB3ZkExeXNmV3BMdC9IcnJ6Mzl4cUJDTFhBVW0r?=
 =?utf-8?Q?Lj5jwGMRVi5O33wg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DPN3poDH3Alu0TJEhGKQIXikBZnlOt7CbSj/VLrCG14Cpt9SjrKPuy9pshTnKy3z39xNlU9zh031DAUslCFQ9PLAQai+A32Isc00OIkwt8+h9MuTv5fpJVEBPYK2iTrZ1Zf+x/krLHVSWYCsMeJGWG05icaObXFEqE+VUBY6ujHGSxhxK4wNdg7YAWFkGmgO1HYyioy9Y18IkaU9vNIsD/ROX2jV7sAaBu/z2OSl4VxFCxbxR53y1gO1VsW1kNMLtepuE+LbKiQ/LVN6I6H+GLLSrx6XT5J7jH3Xd64cGLAdRueAEYjbQEUfUM68wEB2aPIZ1p3Qw5i+LQOywSj+kdaBLcG8GeT3Ekm0EdXbN9TQ4JwNhvcSUvTyRYmSed0TFkMW3fqPmEhM/nWgICw9GWFO4OiFlsGpiVhreY3FGPMqzCzbH0X1KPtxvnoAKAkuCkuZauJ+P1PsnGzl/sF6BkWIqCxBjaIH46qfx/TINy2FmPKt5bFqrueexjN/7GP2wCeZIGbZ3glEW7P5FEieamwD1VW20XoKmyZ6GfPzJ1p4R5e9SsFo5xInTo0xtxaRZrM3d+0rg0e6HPrlzGABaAZ6SegguoPVogotIU1rpmo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f15ddb-d2d5-4f50-ea35-08de5395e791
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 17:54:03.5187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SCJnOGT65rl1D97wXNq21mnYdqhKIhThyOYXRigqnzFerbc9KKhVvxsONWQ8H7k5OAn77davYcbTqGbrNAoN9+StVFLYHh5Xa+FAa5EbVnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6288
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_05,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601140149
X-Proofpoint-GUID: 1zzjc9p4w6gXpI-SU993hTJiV5jhhDq7
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=6967d841 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=ZiibHZjQlaxqinHYuMAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDE0OCBTYWx0ZWRfXzh2FzdxDi7Kh
 q7HIVz2ygr4N1dzZo6w4KKzMu0c0ictCPCOkB/CjmGxZ1tk4cZP1Uevz5Fo74WdObFezHUnczsA
 GEXsU9K6hJWfNO753kVXEr02WRnO4mvykcd5V0My0xiRfD/GkScumtWjw4MUYy3mZYtH8U8+Jgi
 kQ/RVcDWlpLk5SxZy0miYc9dXNp8fDz4vPx9LvwbnXmBnyx2SlkiLfMgS6iBUe72QNun609vZLI
 hhfzghQoULnvj4XMmeg7OL6bsI5q8eDcu6uZvP4/wXjzxxgneUEQ/rsr0Ok8gzd5OgyFM9OUkVj
 jc+yRPq5nPdtnM1d5hztR4mxM24XPwLECBJazFtiyb9Sh5THWfu99DeNXfFSC+BREsY71XqjWeU
 NLhNau0qz9hxfQJ7mjetu5KDe/tZAnKD/shRNYMcDPlPpzol8cDOq5ucMuxQ0tFBWFQXmKbRwJR
 mky/XOgAbV6zREuZVAA==
X-Proofpoint-ORIG-GUID: 1zzjc9p4w6gXpI-SU993hTJiV5jhhDq7
X-Rspamd-Queue-Id: 9048FC000B
X-Stat-Signature: ojz3zyg9yb67q98rxwxxynfaxpwp6sm1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768413254-699392
X-HE-Meta: U2FsdGVkX1/ahR6rDTWvr6GY45B23Udf70mvUc92gwCPW0uVZCm0KNc5Zav0XpyV92Nwzn10CEA5pM/bbg6oq7buMZMR+Aky9ncmvP+x8yi9NCrQZMT9l4L3jZlVl1Z8daFEuaprCuVqfCFAc/QStFjtLT8U8qyy0ji3WnwnLtvZxp/o7C6/o533K+66OHDxpAYvJoZOAet4pASZoJtGOvmjeJkdtDJ8TN/zZlMEAMhZYEi7YRzlATs1xUqEfrn4wLd97J0lOlfheYDmSIgu1VTA7mcBMmagaqiaPaZkWWSNQtjobTAzq4KdJ9JJ+BKg69R7AQnFqxKbsTfUUjUfAo4nF9G14rNLcBzNvM1dMe8w0o1Z0ccXXGCujaiIHQSNpycMHtA9T3NaikkVVuSmqpal4xddcV0la2Ejgo3swkh7hg31N1gua1s0oHNLkNCinLT/Pemc1lRnHDVxzjIqLpHAQC4mNxufPMbrhr9HBCLGEfjm6xpU8WFNlJPebNs1KnWRAtCzUNsqD96qGh6iMr6lwoVpBkFhUyIWRXwcTGMkGANqVj/XohrPO4aICfz/MRHk9wDgEplOHnO6PZF7lQ6JV0+GzA1kG+CaG4FVknFUI0uDitrWAmzW7jCZP3tEwnnzODovx85nNZJWf8yCoGf4pIgjit3IyZMIVVnC/S3TMQ/k0a+H8GeTuVPHRwmeBbC6pRvmX+5+Y5flLB2OGEIP5sTp1j2VU/pfzbcpq7UImDJHVIRX8uWANHxZ8jQX5GuXNzqXNhl0r7GZFH6R4VeBzDl1LX0J7wfQkxETyb2syI+Z6zGuZ66iFhvOmHfeWea029/sgPlivsjUiMF8ZZzEA3mbhZ5mQWfwUcJi+89ylEOx/kxwiamG3vi+O89UXB+ysAxB3IvR+Xm4odZY3CTQoHvLJGgMJ/R0DvwDAI7Hrtdr/9Uy9CsU8blnrizu2ZffssWExPx0MxbTMvG
 IKlOEF2v
 5/DRPVODqaetPf4mWIg09gLPV3z3JFTaLqEfYmbYijNrosfCvPBwHsyBXipGjEyW6llt1Gh5FmBk+0rcvlwzOboCoTjCe0mQqh7kJwITHHnOfoPGOV4ACD1uLb04bF4W4vD9NxVbvxPRylDdxrlN2pwIfogWTrZLl/HMiBKtAb8eoyb07V0bmyKjTPL4FPAqgPJyd2mCv+gcSnYdJcaPLu2DYjKZ7hTtsf+dZpHSy1yjmzMlKM8lt8WS1bw+COwrBZ0v023ai+HTEZAfT1uZSi9knku2Bl+Zf//fJUj3qCbwUN9mT5tbiDmYiaTQMM2EP2hE35yI6w61I0oVeIwHE5D67YCHITnCJsKfuLuiTnoAjtK4Z9UyPMqIB1SSxdEjPR7f/hqRoNHBKN/OUGsfTJD0koDTf7NpNNnBeq92WxoaZAouOVG8uNPW7A7A7/WLSU6ZMHl30kHkquQ4ezE8RRb2fBRDC+l1hbNJfneP0xbQjon1UVHIY9sQ3Og2oThD3OefG2W9+yVHNpFSakC0+8ZW7CzIKCRSdAVEZiyZiUWzPT6Xi61c9EoTgM1/HzZlaCYOk7H6inQkyPvFhG22rPJ0zCAR7tSCUiFUW5rfFUjh6yRdsaysan4R11oh9j3hBB+MBevBg5OKOs/0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 08:55:58AM -0800, Suren Baghdasaryan wrote:
> On Tue, Jan 6, 2026 at 7:04 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > The root anon_vma of all anon_vma's linked to a VMA must by definition be
> > the same - a VMA and all of its descendants/ancestors must exist in the
> > same CoW chain.
> >
> > Commit bb4aa39676f7 ("mm: avoid repeated anon_vma lock/unlock sequences in
> > anon_vma_clone()") introduced paranoid checking of the root anon_vma
> > remaining the same throughout all AVC's in 2011.
> >
> > I think 15 years later we can safely assume that this is always the case.
> >
> > Additionally, since unfaulted VMAs being cloned from or unlinked are
> > no-op's, we can simply lock the anon_vma's associated with this rather than
> > doing any specific dance around this.
> >
> > This removes unnecessary checks and makes it clear that the root anon_vma
> > is shared between all anon_vma's in a given VMA's anon_vma_chain.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  mm/rmap.c | 51 +++++++++++++++------------------------------------
> >  1 file changed, 15 insertions(+), 36 deletions(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index de2cbe860566..6ac42671bedd 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -232,32 +232,6 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
> >         return -ENOMEM;
> >  }
> >
> > -/*
> > - * This is a useful helper function for locking the anon_vma root as
> > - * we traverse the vma->anon_vma_chain, looping over anon_vma's that
> > - * have the same vma.
> > - *
> > - * Such anon_vma's should have the same root, so you'd expect to see
> > - * just a single mutex_lock for the whole traversal.
> > - */
> > -static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root, struct anon_vma *anon_vma)
> > -{
> > -       struct anon_vma *new_root = anon_vma->root;
> > -       if (new_root != root) {
> > -               if (WARN_ON_ONCE(root))
> > -                       up_write(&root->rwsem);
> > -               root = new_root;
> > -               down_write(&root->rwsem);
> > -       }
> > -       return root;
> > -}
> > -
> > -static inline void unlock_anon_vma_root(struct anon_vma *root)
> > -{
> > -       if (root)
> > -               up_write(&root->rwsem);
> > -}
> > -
> >  static void check_anon_vma_clone(struct vm_area_struct *dst,
> >                                  struct vm_area_struct *src)
> >  {
> > @@ -310,26 +284,28 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
> >  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> >  {
> >         struct anon_vma_chain *avc, *pavc;
> > -       struct anon_vma *root = NULL;
> >
> >         check_anon_vma_clone(dst, src);
> >
> >         if (!src->anon_vma)
> >                 return 0;
> >
> > +       check_anon_vma_clone(dst, src);
>
> check_anon_vma_clone() was already called 4 lines above. I'm guessing
> this was accidentally carried over from the previous version?
>

Yeah I don't know why this is here, in the tree it isn't, maybe Andrew noticed
and elided? :)

But yeah the check above is correct so current in-tree state is correct.

Thanks, Lorenzo

