Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22517CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 19:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1FE8E000C; Tue,  2 Sep 2025 15:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5838B8E0001; Tue,  2 Sep 2025 15:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FBFA8E000C; Tue,  2 Sep 2025 15:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0EB8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:40:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3DBB1DDA20
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:40:17 +0000 (UTC)
X-FDA: 83845326474.24.1FE0BAB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 73E4C40003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:40:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qB660PUL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fKN+t9J9;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756842014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qxo6C4exPKCoAtBi0FKGO1lrWm/x/vBw9+Wd4i/v5bk=;
	b=uCBpPa9MjxM0Uoj8oeAk81gRK5emTIVIwipsb7yPoBS4kjWK+DW72VO3EJneb1lsLTceub
	E4iaG+LpD4tECOjIDo775pbDtZtzXvv6vedriQq5ryYevbogG15pgbUSiVgpPhW7EuE3Yv
	VsgRB+zLf6pMeC57nUGy380f5/s+MY0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qB660PUL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fKN+t9J9;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756842014; a=rsa-sha256;
	cv=pass;
	b=CrcyIynI53kDPQsBkO7YmIfVO72+TEK2a1HroNAf8j2+J/ZdV0shxLDrqhQO4dqp76J+H/
	/2QKuCle14ZXzOYo7WHZ+F25IKKEBosCWLkh8vW1XdY11qkpb60Wr+C4b5u1rGS/kNOiMv
	VTs8cYQW9ZOD2/akxCYduKs2CNYj/bw=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 582JMk51025090;
	Tue, 2 Sep 2025 19:40:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Qxo6C4exPKCoAtBi0FKGO1lrWm/x/vBw9+Wd4i/v5bk=; b=
	qB660PULgN3TB1MaH++RPLKa69UHTbvHylCYGSBIPJsyKvEoNyBcdIZiemYTKJi1
	SgrZFhHpMdZiRSUOTVtpbEOXt3IcbfMYs727MdD+1FdwR/2M1zdsDBBrC2Ez/Eny
	trzpRZUyZs6FX9q6XssXAIzguitM2Se5ifkRkVUaBaOMvZLbZo7YjkHMwILJYl7W
	R0rGkb569wVR9R54VrlUlikwaswZA20R4P64i1gcpgCD7LLLNav9FwhGyo2LJX0D
	IUHlMZa267oleqQ4ExTXpeAzIV/17Jwv4FijM7sIxATaSXpN8bWrjJk1DcfmZBna
	QIYXkn8zKefWcUcmFAQeDg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ushvvw2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 19:40:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 582Ialug032516;
	Tue, 2 Sep 2025 19:40:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrfu6ye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 19:40:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fDGtYQOIs0g8twbylI5ZELyacnWVC+RFPbb+YgZGMTcUXAOdwgERgjC6A04EYttQrd/rHZG2A6Gc4oTjjSzdT7odrFH9kKpAPA/CMVmeM4JcTtf22m8Tjz7WXIfE4EccaCULNpxdCx65ZkpI6HVkWu8gbvZmsD4+nsGlN7KWUfVBSstWkRGkI+KtNYkXmuVRznuZd3Yl1mBgCie9Z6nuFtjfD+3dynMDXlHVJFnTJV/CKZ9aCHoPlmKiX4QURtpv5k0vb9QeCSIgZewmyOwcQdR+6buDqJ8oy+ozaj5WUSUMRmeCElqwjWB+8DiYoUY9o1D8EIeUgWITodGerE7NpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qxo6C4exPKCoAtBi0FKGO1lrWm/x/vBw9+Wd4i/v5bk=;
 b=C/v5I+qHWm32FZTY5xaF5ev1aCgg9YOaMxi/Hb8WJ27NwGC5fvs/hoEUS/J+WLTz2vD0wjUndXfmZogl8SwVIc48yfnvY7tRFwddq1yVCXHZ21DMWl5AUn/weH/DgFvuOcBxIWmctB+TAamgsu7qtSy6cjELtgSXNcOrhdaJmwTNbNY4iaSqXQk5sj9oXE5LWPiumn1o6ZqTxoRUeqCkJYICXJs+AWyhXynx2GWqObYazeJGzSwCThebNs9Ja7pHeRMyEePQgKvdQFyekPRdPoHhCZP7aQiYpjRYzBTRgTHFhktNJaBENibPnmSZ6VS8bsdQQYbbh6XN+rn4BSu9CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qxo6C4exPKCoAtBi0FKGO1lrWm/x/vBw9+Wd4i/v5bk=;
 b=fKN+t9J9Dg/TqJ/qsDLZmSRXsXbWNnFaLG0TtnhLu8w4s4PLzeS4Otil/QyUfn17ilzzHINrEggXj8JQIEdDuf4Khjyvl5VIVfm+xioLfzKplsZ81bBsGpicQGQadzrsWO6RbuhklVlCNpAp5o3GUzUfkbK/zCMF5Zu/QrN12BQ=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by SA1PR10MB6341.namprd10.prod.outlook.com (2603:10b6:806:254::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 2 Sep
 2025 19:40:03 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.9073.021; Tue, 2 Sep 2025
 19:40:03 +0000
Message-ID: <fbc20724-bec5-4a80-b77c-9bec445097cf@oracle.com>
Date: Tue, 2 Sep 2025 15:39:59 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/12] maple_tree: use percpu sheaves for maple_node_cache
To: Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
 <20250901-maple-sheaves-v1-3-d6a1166b53f2@suse.cz>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20250901-maple-sheaves-v1-3-d6a1166b53f2@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:510:23d::19) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|SA1PR10MB6341:EE_
X-MS-Office365-Filtering-Correlation-Id: 92343afd-bdab-4a51-1191-08ddea588316
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVFLRElmUk9LUERaYUkvVEZ4NnRFK0grSXZpclloZjQzV2xQZDlWOU1OTlFE?=
 =?utf-8?B?dFd6dm1FaXRqSXYvMFFQWVk0L0xUdzEvZTJXeFZrSFNvVGVnRFZnZUExME83?=
 =?utf-8?B?N3VwR3JTWkNyVnVMaGRFVUNYSzhhSEt6MWVOTUdxTTBhUWc5bHUvbkJiekhW?=
 =?utf-8?B?V1ozc1dKZy8waEN1U3VEMUllSFpzSDhPU2tQYyt2aEhzSE1MMXpoNXdzdlVi?=
 =?utf-8?B?U25tQVd5TXpCaHNZaUhiZ1pYK0U3dlFzU0NTc1o4VWVGdGdCcVZVajE4Uzh0?=
 =?utf-8?B?dVRmZEZXellOTHU1OWVaakxiNGppWkdTMDJXRWJ4V2VvMmlqbUl2V25UZFpM?=
 =?utf-8?B?bUx4bXpqOTkrR2xmSjMzOG1mK2w2Ym5UVTN3bU92eEhld2ZxWmFVTENhZEVH?=
 =?utf-8?B?MlZMem9CWnpCNmxlQWU3RXRDVTZDVmJJTG0yYXRZajlTdXNqTzl0OU1mMWdV?=
 =?utf-8?B?dm1HSHM5WVpMU2c5V1FnQXR2b29zbnR0clhZRUczNS92V2NjcTF2aUdLdnJ3?=
 =?utf-8?B?bjl3NkZya0ZQdS93a1FhUEQvR2dIbm9pQUxxT1B6ZkFNenhqTy9hbmIrbzlK?=
 =?utf-8?B?amY3UllLRksrZm9OR1dhcEFUSUY3WFl0MXlqSGhMQ044Z1BOQkE4NEdna3Nm?=
 =?utf-8?B?R3NrWG9NWUVMT3FZWHIwTm5Zc0lNdi9lNFh1Tzd5MlhLTTZQMm5RSEE2Rk03?=
 =?utf-8?B?N25Ec2VDclVWdEZ3MkVoSFVWOUtqN3JxNXNSWTl4OUpUNGNsZU13Z3ZUQWFE?=
 =?utf-8?B?REZoNnZaejVNQ2FtYWF6OGppTXRtK25neC80OHdPZGliM1ZKSkR5KzNMa2Qz?=
 =?utf-8?B?cjA5VkQxOSt4UGhUSGtuUlRweWM3d2UvV1Q5emhhWjYyUnBHOXZReEpHb3dn?=
 =?utf-8?B?VXpJcnN3V3BySzFMUTBlOWliNHh5cFFZWk9aWUwzbFplVGFyOGZrSFA2SVFx?=
 =?utf-8?B?bGNsU2JjK0JsZytqdXNwQjdGeURrdnZEc0huemRVcVBsUjkxZlUzcTFMa1Rx?=
 =?utf-8?B?bWM1VWlQRGNFdW1ZeFJUbVV2STBqNXpaR3dLTGVmU1dyKzF0V3p3QmI0NE9N?=
 =?utf-8?B?bjFOWG5pUWFWMzI4djQ3enpQMXFKOUZKZzl5RkVpWjgzRnJhNXRwS090L3pX?=
 =?utf-8?B?SkxuLzhHSTVEZ1lhN0h2YUI1cjNTL3NHZFpFcUZIRk9hR210MTNyOEVobFI2?=
 =?utf-8?B?TFV4UVFlRGVzVVEyUFlXdmRBL29kUjUwN0E3RzRjV3BLS1lzRUtuYUVPaExa?=
 =?utf-8?B?ajViYk93aTE3TkRwNDhuYkRLVEJkSy9CMVhhQTVXTFZPeXF5Uk13QTA4aGw1?=
 =?utf-8?B?cTdFQnU0bE9YbjlpTThUK005K2NiNmIxcXdLMC93S3FrMHlzWS9Kd1VYVGZR?=
 =?utf-8?B?QVM0c0NEOGcrZGtudDZacVpiRWRxZmladzhNVnh5dVJNTjUxTEZxQ3Ixc0F0?=
 =?utf-8?B?cklIZWhmQmFKR2R5MWZ5R0VzS1hHRitBc1A0cVVVK3ZTK21WTnVkcTljV0lZ?=
 =?utf-8?B?a3hTd0ZhaDM3L3ZCQmV2NlJLUk1wTGc1NUxkaWRLZ2R5OVRZMGp2b0dtSlBD?=
 =?utf-8?B?eHVCeEE1THhEZXFsUzNxN0tZWXhBVHdwcy9HZVBXT0hwZDhGQkJ3RVl2QkZv?=
 =?utf-8?B?MTdaUnRlNTUwVE5mRHY4b3RLNm1Xb1NSTk1aUFNIaDlpT1hDNkdnaFNIRHZW?=
 =?utf-8?B?SUU1SVAxM09tNHRuRkFwbzgrQkhDeGJMQ285a1V2WDd0aW9RN0FEZ3RXaWVn?=
 =?utf-8?B?RVo5WFZURjdSd1FsMG1wb2thMGZmUXlzZG4zQkdUc1h3ZmhJVUpwc3BZRUs0?=
 =?utf-8?B?TmRCVXczakFGbzF4UHBXNUltZ2t6WWJvbE9JRXc4ZTJuaHAwMzBzNkVkZWhz?=
 =?utf-8?B?dmpITVB5U21qaUpMcmphWCtyanN0NmlFcEVVR1VTa0FUaktIb2M5M2p1a0RZ?=
 =?utf-8?Q?NNLTAWrPI4w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0ZxaTlSNkhuSElWcFVNWTV5VXRxdGNMbkc4VTRjOExPM0FoT0J4eGxBRVJJ?=
 =?utf-8?B?akU2cGdDOU8yT1J6c2U4NUhReWE3UEdBSEVwVzRXV3NudUtlRk52OWxoU1Zu?=
 =?utf-8?B?bEc4SDJhSUM0cml1OXpvbys1RG1NSDNMSUJSaFRSbXdDcmFOaGdEZ0J1aGdM?=
 =?utf-8?B?YUladi9UTVBObUlzQ1E4SU9uVkRkNkp6Z0ZyK1c2QzU3eEtlWkpUY0s2cUlw?=
 =?utf-8?B?RmgvQ3FFTWxKSGxtd0FXTFNuS1NZZG0rN2lDZDhqcHJONUh6YkgrUEFaclNX?=
 =?utf-8?B?U0RRS2xSZ2dOc3AvMHloc1czQ1AvTGxDaFpTeGxPcjErMm9LOWZwQ1NpcFZG?=
 =?utf-8?B?bU5IODY3VzFRR0RqdGxJTjFaWjNDbXBwckd1bzhFbVZMbjFmVzJLanpOTWpP?=
 =?utf-8?B?elc1ODFvOHMzejBWL01hVy9SSW05RnVDUkV4SkRuTjhhS2ZIRGg3UnprdHdJ?=
 =?utf-8?B?bWtlOGJhd3JaT1FEak9zVThkMTlucnB4VUZySzFZL1pGOXZSVWVSUDd6RUFJ?=
 =?utf-8?B?clgrVVhoOStraTltVnBpQTlQdC9iWHJWTkFueVlFSlpSREsxWmY1SEROZ3px?=
 =?utf-8?B?dDY0Y3VMcDdTREoyNW9lMTdDVTQ3YUc3ZllxSXNrU2Fqd3B1N0tRZXVGTXlW?=
 =?utf-8?B?RkRDem9uenZGK1NFRHFYOUlRU1kxYnVRM0lXQ1FpMWNJSXdoakFSUyt3VXVG?=
 =?utf-8?B?SWFFS2FFcW1LZFc1ZzNMN2NyRlpXVkR0Rm5TdDBQSGhyUnlSaXdMSFB4VXFQ?=
 =?utf-8?B?U2hMcGkxY1Z5MHpZTzN5Ym1OVnhrcHpLR1ZMNU9vTlI2K01LQnRMUU9mcncw?=
 =?utf-8?B?WGVVeitZLzhlbDlNYzdNc2dDeWFucnBDay9iY2lJRmZzaHNscWFjZlNrZmh6?=
 =?utf-8?B?VGxyNzZCOTBBTnlyYjhyVTBIOTE4L0pHVi9CUlVmdlhiV1ovdDVQUGtzR1gv?=
 =?utf-8?B?Q2ExeGdPemZidFovMVdSSW1Ja3B3QWMwQUszWWxaVFVraGhTckd1ZnJxaXpH?=
 =?utf-8?B?QVVnUG82a0FEdEdQOGE0anRTdU1HVkFSK3JOa21wRXRCb3R2ZUhycGc4Smkx?=
 =?utf-8?B?QzNQNDBGc0RnR3Y3NHkwQWFtNE9iOUhWQ2o1bXNYeG5zWGtKb3Bha3M2TUZW?=
 =?utf-8?B?M1NBT2g2a3lsdFJNelZjMVBIUFBkNG9Td2NqMkIrMUVjUDZxbmtSTTUrMmE0?=
 =?utf-8?B?eFZUZ2gxNEM4RWFNZW13eEFXNmJMN2tYcXJNV2x3aERhWXRKcFlTdE9UeU1y?=
 =?utf-8?B?ZnE3Ukh0NkJKL0JYWG0yZWFjaGRDYTlWbDJtdS81THdtVUFmRFhYV0ZFMXd3?=
 =?utf-8?B?VGFZc3Z0SWMwRElBZWhZbFk1QWRuK2V1LzEybTNVcVE5VnIxU3FRYmptRzRN?=
 =?utf-8?B?a3R4Si9ES0M3WmpaRnNuSVplMWVUQmZLM1h6QW9wWVhkbWRLR2M4dzJlaHAx?=
 =?utf-8?B?Z1ZYRHh2ekhaWEdWNTZ2QWIxdHRNU05XeU9ldHNSS29BSVFqNUo1RHlJN084?=
 =?utf-8?B?bTZoaFI0WmNTdzVHa1dsejlJOGs5UnpuSWJLMUFhMlNWTXJEN2FEeVJwT0NK?=
 =?utf-8?B?Q0VMZjBLVHV4cDV5bmZPUng5QzdqSUIzWUQ2dDNpdERCRGEvR1crazVtT29E?=
 =?utf-8?B?OGlQZTdQLzNxc3QzRERhS25HRGFicUtvZ0ljNUdrOTJGSGJrT25kNUlyc1d1?=
 =?utf-8?B?ZWcxM1NGc2FrdFpEa2tQVmtsb3ZTK1c4b3UxeWJQTHJHbmwrdUQ0ZWlGZ044?=
 =?utf-8?B?L2hMOW1Ob1hOUVk2R0Z4YmdHZDZlKy9xemVPQ01CT0JSa3RyWWYySTVQUHlw?=
 =?utf-8?B?VGo1cXhtbzhHVHhXNFFEczNJRTZEc05xR0lCemhMOVZrK004QnN3MkxHZkpt?=
 =?utf-8?B?eGZQLzNReFUzMDNnUjBtVENrOEpsM3VOQXFaYW10dUwvSVVERlo5UEVZamNt?=
 =?utf-8?B?WXFGWGJvNC9LVUJFcEZXYjlWSHBBWFNOeWxjd2t1WTB3Qi82N3BpdU14clRq?=
 =?utf-8?B?SnFFREIzU09yT3lxclRIY1FHcGF3TzNPYUR2UEp4SXJXNEFBR2lONW5XV0sz?=
 =?utf-8?B?NGFrZ0l1dG1jTE9wRlpFS2VXNWtzR2hCWG9vRGZEM1g3WDltOXJNNXMvK2hr?=
 =?utf-8?B?VzF4dDNXTEFNRXg4QU9qRGlZVy8zSXEzb1Rqckd6cHZBMjY3MU04YmMwL3BR?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EVdhwurMLuYC/lzN1QuY8nZMEdpFwNO+STFISihwqcwQm1JfAxHEtneBCWUYEXTpRJ8dv64nTzGsOqnhPZGiNlYLavG1b5jryet848bRjFnYHvgvgzOG5UQsv4zUGwm0BwQmf/5X9tVj3MLVs2NrF6JpBjE73Xwzmw9bexZ9FqS41OQVke74xYEJDUxmT4fX6gtI4s/11VSIfEKh2rtLrBDK82b3zE8VUgvpj0e1dWHD66IvhThMUqbupHjPgkmQAHaxHWWK6Es3GJoLGA8CNbgBnl5G9OZVshtnVgGCnU6xdCLZKoI5meYysXJf8FBp0XtF3CyfAcSZRz5/HGl+kwas78wcQ7oCKROXNl4nRbg+VhIP8HE9CN+/7SNJisZBOQZySmKfXroqo0GjIp99Jfw9b+e5oUd5CRzAr4hYvUWKRHWv79DoGICx4jHGeJ4OxwYvPDnXGKvJHlVfCXHQD/ESehZ1pKkm8XsqhihbbGbKNVw4v/zOGxlCWBT4flMnJa8kl86TZc5EStOV5/2YgqWRPM3LSqFDXQgYKL2pG9UdZE2OAy86YuYL9r+UnwaMuJjSjVGeL+IfOMsiOiGMpouOcDSW//P1HRc2oj1wHXo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92343afd-bdab-4a51-1191-08ddea588316
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 19:40:03.5779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /8WW9ZOawehoa3WZ6NSYXcDzVFOSlMKJfqpvlRlKRPFk35S7sWpodat2EPNpyyutOaEAWBR/eHbbjNGCzJmfKAhMd4C5pPSt4cqJOHbCKzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6341
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_06,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509020195
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX4+PsDY7zqYOc
 fgInYOozYZBlZJWrfwoPaO94aSqUBYcX8IQphAo9IbGIkRz8iK2odcM/OApplPGvj9cUDQqOAf1
 tPsUKwV354onfIfj34XC5EOsF/VHcZkHiUw4n3zAOLN1gqzU1K5ZnVIr50e2P5v158qhsdzaIVE
 gwWb5cfv0KwfmNL2C9vADQt4mq2MCg9R3oTN3s8E21GRuwTkpT6d58tjc5OzxuBUPhcNSgqAFdq
 2/2vl0/XOCoFRc5xNOR61O5xdXdZK/w7qfzk1Gd259/vKuEivRbP7y7aVfBj17JFFzdCylxKlb/
 YatH66mt9WBGYSTdv1Tsv+NyrvMz49d9V2ahXW6cOC3n0yl7wSTs73BmbtIJ4R29FpqauwIW+Fk
 mQQGm0XxIuNjomltsnf5TTI/1kGLQQ==
X-Authority-Analysis: v=2.4 cv=fZaty1QF c=1 sm=1 tr=0 ts=68b7481a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=Ixn0wpfdpkI3Fjci8i4A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: S872p-xD6EnXZ_DYHNxrrJ3a1GDkLKdR
X-Proofpoint-GUID: S872p-xD6EnXZ_DYHNxrrJ3a1GDkLKdR
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 73E4C40003
X-Stat-Signature: m8wxbtf1r1z5www6wbkypp95drkqkud3
X-Rspam-User: 
X-HE-Tag: 1756842014-681142
X-HE-Meta: U2FsdGVkX1+zfQLZ4o4zxTTu++R4hKeh7p1DDrIKsn/zKH7F655aUk7fxspL5MbmBhp3YBbknoaJ3jxPcxCatko+xu470fuZ9FUKqE3T4QxTlGb62YHV1JaMV3bVtjSpbQH6JbQd2wi44ReTp5rO5W1b8jH+u/I09lCNfnu/RZc5l/ElIZ3YDm1yrwGV8q4Kn9W2eo7o6DEEyTnw+inOyENptTvXNT3kqEVvYeQJiygzO0folRrBLZE8VfXyHNagHVRD8xWJantUZ1P93ypWtUyIGGS6eZE8gWcxN25fMQVcj9cgf3M4plDOlvM/h4884gcR+48cuJQsI6ESpnPnO4vsnQvL0f5G5fPl1dlz/D72m4hEOJzEmIMip+X3G/jd5ebEjpvbieK8JX+EATu2TXe4GTCTrgjcVA0I+UiYsEN50p4N5EPUWJGF9pCstsV0Qx+gqnj3XX7xZCfBKBqT9fOj3Kim2vX3Z6N4B88lahm+TJLVQ0x+ZnHKzBlYkYliec/PB58D+xsv5oM1kd7ARVfiSD4P8c4cYN/TnCblgvk7oxSHHJ7wv9C4UxQdjhV7MkaJsoGN3ksJx1GbCbDTh6Mc/3KGGQxaCmca5+tBT9lckYIamXa69g0n2zDS1UKP9ZS5Ulnw1PESx6BtNvhkdhU2gJWmETDfwruaRfSTiyQDzh9JdU/PzBytej9GB84/nu6FMycWdhbqckdffyNY7oy6pX/M5/5/v3NUsNkofYNdgxui7X+ZfEaRjAokvZNtqjRwBfUT5mNrS/0XGkeellRx02uN6OaCsyWlabh9hUzysK9aDOAiS+5waOZCdoDYf2XLYZUJS6hYMCA4bxgeafPZZZRDXTnxawm9At6jcJpaYJE4Cp06ssGm4LZJ/FvgjrZ7HKDKoW7qzNjcc34ug4D7Fi6tSLjXTwJ8eTKRWHBLz8hVdNOzU6Tlq7QzwebJLMysrcseP3j0pm/ogtA
 hUE7V2MH
 sCTlPxS3S7p8N5SLdKevuymyktgFNLkbicgnleepGSZpMPZvhklT3nv3WtL+SxkRddUXqxVYgwr4VRYp7U7JAAD92Se6nm3rkZ9pJDTVT1j1oF//0g0O0Be46l/g6muYQjwudqDCbyYmEj3kLsITefZtbaFwDXZI/Vp7t91i4gB+T+UGGJ8PNSWPh6oP6XiSQllzsLXRMwvSLgdlF7I6DC77xFOhXxLWyQ9ANPHkZpoXpMqQLWwzh5wQjsbS7GYPmWtm3D+pXEcd4lrvfA1eiJrckmRXwZpa+vpxOLLSQgCqCa/AUyTek+CoJ93PC6QR4zyczuel3yvDHRHvVSBYpWpdAYpzY4Kw49QAvdyDUNceT5ksjIohg7HDiKe1QlibzqAk3F/QvNGxQRT4R783EnSiJ6v+/H7PcU2Y3yXx8Ie3QJ5CfbELoXJYFDjx2a4z+SiqDFmrG/vY4xuiLVUcaXkTH7InSSWUvCzUTG7z1CgWBUP6pHFmJqfUZMXXCQbYFCQDUFteQ+h3nFOkvRRurn6WV3SRjJeuTS22xD9SuDexKMZabttZKzCJ9lrAzS3vgeyWB6wrW8Jp75C115VbuwPw9SNKFCBJMSGu4G0EjY/CAOQC6Pn8fsmB1C3Qc/N0l87wCURJf6KGSTPYGaImfWqcJuFYRdF2nBv9MnlVAQBf2aadYTGSiq/1TQU2k1+zcnQTc8EsOGLrPt12HncCEYSYF3Vvx0whZKvjsgboDmx0pBxiL+TwJL7POt9EEnH5E/n63C6k8qijRJy6SRjd6paV/lgMw9+azQrUaLKD65sK5zdHgXVq74anTBFHfZtUAhSRRSmz+bsElN1TUdIpLWJ5/ELYa4M28k9if
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/25 7:08 AM, Vlastimil Babka wrote:
> Setup the maple_node_cache with percpu sheaves of size 32 to hopefully
> improve its performance. Note this will not immediately take advantage
> of sheaf batching of kfree_rcu() operations due to the maple tree using
> call_rcu with custom callbacks. The followup changes to maple tree will
> change that and also make use of the prefilled sheaves functionality.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   lib/maple_tree.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index b4ee2d29d7a962ca374467d0533185f2db3d35ff..a0db6bdc63793b8bbd544e246391d99e880dede3 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -6302,9 +6302,14 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
>   
>   void __init maple_tree_init(void)
>   {
> +	struct kmem_cache_args args = {
> +		.align  = sizeof(struct maple_node),
> +		.sheaf_capacity = 32,
> +	};
> +
>   	maple_node_cache = kmem_cache_create("maple_node",
> -			sizeof(struct maple_node), sizeof(struct maple_node),
> -			SLAB_PANIC, NULL);
> +			sizeof(struct maple_node), &args,
> +			SLAB_PANIC);
>   }
>   
>   /**
> 




