Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B201CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 09:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E786E8E0062; Fri, 19 Sep 2025 05:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21608E0008; Fri, 19 Sep 2025 05:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74388E0062; Fri, 19 Sep 2025 05:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A84DF8E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:59:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57B5B1DEC09
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:59:47 +0000 (UTC)
X-FDA: 83905553214.11.ED48EF5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id D026C140007
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:59:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RYKrORRd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0CRcqRwa;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758275984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lByjmZqpZFthYYHMJu2AeqRuR4sjv1zhiOSY6Bw5ZUQ=;
	b=pHOUJyg2RnXvP18JzTN4PwXqKB9G85L0TDzUZEsZ/aXeWUlYE6Nen5tjyRye88JM4a/7Oa
	6zpOcr2m6x46Umh1ovr/sshhd0xvLubvNozfhvtyiF1WMeetluOuZQ0WKd/I8py4kwS/33
	//960oJbY1XOtJv2hFs4Sl++pJQAweY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758275984; a=rsa-sha256;
	cv=pass;
	b=uJOGnYgj6MLS81CjvlcSVS2QUr9vVtMp5m+kuf2GLSAUnhBHDJowOveE8obZ1+tfdMd5m3
	Pe2MyekMveqnWXkeW95QXrmChxerfaBuJSoAexcD/RC00x4yEMnQjZ6/nAOLM4FcvaRAvY
	WD7byFABJPKuAFTIFv8mRI8gp+/rF/c=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RYKrORRd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0CRcqRwa;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58J7gBbX008846;
	Fri, 19 Sep 2025 09:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lByjmZqpZFthYYHMJu2AeqRuR4sjv1zhiOSY6Bw5ZUQ=; b=
	RYKrORRdf7+q4RgLjQ9Q09j0CMUHpg2GdwgiGQhK8jMgWPg+oKpzkoDCf36FcY53
	Y5ASPyAvxxJl9gdkWRC4rIInaaYKb72fXaxQ9hBuFHeTuLkFo9kMpbf1X5cSnNjc
	WC4aqwJ+fiGhPMCis+XE0wTSly2aG97e8drsqGjfDlv2R8x3m1no0G9V/Ualxt+O
	dJDS7m6kVJy0ErnJfh1cyTtnAGEUO5Gsf8ewD0jFlz2Wd509z+RDnpJub0kau9a5
	wQvtuwhiGmNgKLfng0FqN2zh9C0Et+ss0hiO2+pIWfYOAjY3FBcJ388rf+NisirI
	Smk/MgpDyHI0QQFEhSgU9g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxbw93g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 09:59:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58J7fNOE036766;
	Fri, 19 Sep 2025 09:59:36 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012024.outbound.protection.outlook.com [40.107.200.24])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2gau0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 09:59:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SpEx8TFGu1Fo1prkx10vm1C0Ui5Vez92L445WgtNmv1lMn2uwwtTPkvRxz8F9N/IjYcN++RlkNEVuAS1WAJ+BRLEWHG9wLtlMirTmiStVUT1dX13zcoQYLZV4BQWkFkdiZaNdaOEkyfXDSwLLpyxlUSX3g27MhkminSpvTnzLiON5Lwtdj1YvSzpxmCB3QjWEzjDzXL7iagYvmwqYYxVLJcHq8yOti2S+V2cB2buDDCsoAWYZbv23Yym77Psb7g6JJvFoKWMAccIDRXq4GvUBK11FahZC0zXDF4u2Ae+U0SkS5O4+moQRuggc1LrjX0pf/KVL2FTwgVgdqOXj23j8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lByjmZqpZFthYYHMJu2AeqRuR4sjv1zhiOSY6Bw5ZUQ=;
 b=RvAhj+ubqAoWX7ZQM0LLFMQ+8PgwFLZtFN2+Hguo8H5j3SRZvQjWWdai1sQ7TEgU0WVDYpWxYcYrBBmS6ieRxyJDbvFKN1g5Po908or73vorXjOQu0Zw9GU4c9Bu6g4XUmYrkXVUED4Qic+e3wa8jpiVf7lAZNXH7g3GBv+LXZ0PtFFhsuWXDtxpe2oZt58jTwduSSckkMjbPb6eb4QHAEzfjYz1trSZ2PGWZKcMu4DWOVHIRs2Jx43JacBLbPelBK2dmLK0cmUhha5U4YeT/Co94C79m7zriWCuAHWjZPZlg+1+OjKAut1GL/0wXxrNipI/oATU1LYMRRssOrpiew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lByjmZqpZFthYYHMJu2AeqRuR4sjv1zhiOSY6Bw5ZUQ=;
 b=0CRcqRwaKHgvwEFgvrMy/STjhNVI/RvKphpmkJXyB0QBuNqBkQ4v33jrJbeeL4mOYTiSpPO1GzkbU0ETBZWaRBO87kuhN9wC9AWi86fuspvhfQV0mTfRNxKzTyF+6QUd+2Suh3GTt3iVKLqSkIScVbVJvZMy89YwODbKSYxW/ck=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4493.namprd10.prod.outlook.com (2603:10b6:a03:2dd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 09:59:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 09:59:33 +0000
Date: Fri, 19 Sep 2025 10:59:31 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
        ngeoffray@google.com, jannh@google.com,
        David Hildenbrand <david@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
Message-ID: <67875b3a-69b0-4fe6-8e37-6289568e7921@lucifer.local>
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com>
 <0ea92729-2403-4de8-9ddc-a1c7bb2121c3@lucifer.local>
 <CA+EESO7yyhNH6TYza+j7h9JZb1_1eHdd1x3ASmuNga2yYng4JQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EESO7yyhNH6TYza+j7h9JZb1_1eHdd1x3ASmuNga2yYng4JQ@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0493.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4493:EE_
X-MS-Office365-Filtering-Correlation-Id: d0dba299-c6b1-4cd0-9ecb-08ddf7633be4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WjNMNkx0S0xncEhsRHArMzN4TkVzVWl4cWV5dlpCN01nd2xaL2ZwTFc5WWEr?=
 =?utf-8?B?cW5sNjUrZFNGUUNWQmJPUkx1RUI5STBCVThJbm10N0RWRmVqbDlZQUZFWTc4?=
 =?utf-8?B?UXNDU0hxUUxWZU9sY0tGS0tmYm9qdFo5V0Y3QzdXcjR2VTN5Q3JYUG1yYzcy?=
 =?utf-8?B?cTFkL3J4aXhKeUgwRkM3aDVEWXFia0tvbGVJMDhyS2VkM2Y1SnlhVzlSNnp1?=
 =?utf-8?B?UjR0OVBGeDF6ck5aeThxdGh2ZXBOajR2SjhBM1dDWXNQeWxHeVZJRlpOVThv?=
 =?utf-8?B?OGtERnl2UkkzQ0JkTGlCR1cwZ0RBeVZrZmhWb3B6UjI2SDcwWlBWbU9BYW4r?=
 =?utf-8?B?NDhxaE9QNmJYbmpDNFhwRzc5SUVqbDR3N0R6cTVJZVlsS0dEdXN1dm9IMi9x?=
 =?utf-8?B?OWRzSDFCSDZ5TUR0QWJPRG9SYXR6aDJNQ2xHNktTd1lkNGlyODZURklMVUZ4?=
 =?utf-8?B?QTdqcllxV0Nhc0doTlAxZWxtTnZVbXJ6cFRidEtPNFVsZEZuODlmZWRueldI?=
 =?utf-8?B?dE03T2pzYk42Y0ZORE90WXJxNVRKellkcm9BMVV6dEt6UUZyYTJhL1gvb1ov?=
 =?utf-8?B?ZjFLM09zdEFKMUp5YldCS2pYTTMrd1RXekhUTk5ncm40YmFRMFhZWUNyRVBp?=
 =?utf-8?B?bEdteWhHclBwUzZPNkRnNDZKN1JsRnpETkJQNldsemlDUlBxaitCQjFqK2sz?=
 =?utf-8?B?UkhSa29BWkRqKytZV09hL21pUkZnQTc4QzJZVmo4UDhnYlpiUHA1RU55ZnI0?=
 =?utf-8?B?SUtaUUozZklwejQ4NUFlR3dGNjNxQ3R0SGlFRGVRaDFNcnljTXRmaHZNYlVL?=
 =?utf-8?B?SGdjUWI4eWdMY25EYVNHZEZYZWIzMG03N0JxNElNZjdxUktVbERnT3ZQU2ZL?=
 =?utf-8?B?WnFKUHlUeUdmU1VsQ1lvSnRIVmkwZUdQQmJ3ZnJHTzlNQW52NjRVUzAyRVhQ?=
 =?utf-8?B?REdHL3QzK2F3UitqY1p3UWdKc2dxZWJFZW15SU5LSXVncnlBOXJUb1VlWVB0?=
 =?utf-8?B?T0RYSnBTZEY3dDNnZEMrOEdDV1R3MVdPc2FobUVzN2NjVlp2NEJHWEtjNVR4?=
 =?utf-8?B?OERxMGdzazdSZEdoU08zc1pma2s1YVFBRkoyRWpZSUJuMDJLajk0bHJvdTFI?=
 =?utf-8?B?UDNmeUk5ak8zSXlsZk9VWThCN0FQZXZkZE82aE5WZVRhRlN1cmxVMFlyVEov?=
 =?utf-8?B?LzhNN1RYSWxCUW5OM1RLdm1JTDFvTmZUbTc2QTUxOWtubEZrR1dMMG5LRW1w?=
 =?utf-8?B?YXpmaTNERVNIRzllVzFxWnlvYVZGQTBlelZ1M0ZKdzhrd2hYZzRjSjhPK2JD?=
 =?utf-8?B?L3RsNjdHSVczeFdhZXNySlhQMzlKK1ZhVXNjODRlL1Zqcm1UOHFCSDZCb3Bt?=
 =?utf-8?B?TzVhZStDQnpMOGFDeW8zR0x0Z3c3clRXU3AydzliY1FsaDRHZ2Q1aGVjVXBx?=
 =?utf-8?B?Yzk5eUJTeUpHMlJnWGYvV2VaemQ2TTNtRVVZRVhWQU5INGorQkkySmc3aEpr?=
 =?utf-8?B?eEd4T3drNW5zcmczL2l6VzhnZTAwWHdDb0ZPNEtNcEtCeVhlckhXdHl6aDRG?=
 =?utf-8?B?cDFEd3JpU3BGcU1TUllOcUlEMDN2MWdrVHZxY2NFcjhLbytEYUJHc295VE05?=
 =?utf-8?B?dzZ1Mmh6Nko3QWN3L0pEb0xVZXBZdTFYOStHSllCSENtTmh6OExwdGVudUZt?=
 =?utf-8?B?dDJYNjhzNjRkSjlBMUtQUzZRUzB5bmxGWi9ZY1hGbUI2c0poNEZ0MXFrTnV0?=
 =?utf-8?B?SmJhWG90SjFLOTBoUUlVSGpacDgxZHhqdWxMRmxSTzdIc2ZCNG01RmtoVEx0?=
 =?utf-8?B?cWpoaFlkMnVkTmM0YVphOFhyaHJCdG1DU0YwT2ZucFBHd2JrbGlQSmNWUDF1?=
 =?utf-8?B?SVM5RDRtYUVwODlXYUM4SUJNd3RmUDhRemFmYTNMRVVJT0QxYk9pWENqOXQ1?=
 =?utf-8?Q?2aIU+5/sKBw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vy9Yd0NJYVh2YU5MbitxK3BHTmpNNDAxUlRtbWY4bkZ2NGdJaHlZUXFDS1Yv?=
 =?utf-8?B?NUUwOU1RYkkyQ29XaCt6UFV0TUVscENGMGJsNzRVYm1qRld0djBYMmxjT1ZI?=
 =?utf-8?B?c3h6VDhNY1J5TGpJUVI5UTdlSVlraDY1UWpaVElCV2RhOFR4R0g5eTlHdFk5?=
 =?utf-8?B?OEVUYUZsR0ZMUzA4VDhvZTEybGIzVlNoeXpEZ1dIMVVrK3E5c2dHR1VjeWRE?=
 =?utf-8?B?dm42bnFwdlBNRHBqazhqSnQ0VDdlN1JhajdXVTVkcWZpRnZuSWJUKzVlejBV?=
 =?utf-8?B?cDAwSnFLeHVVaVNHVFRScVIwN0FhZWJEQTVxQklpZC82ZVVVZ3J4OXliVDNm?=
 =?utf-8?B?bjJTYmJiQjh4UDdpeTNuTm9hY2V5OU1TTzVUYTJScHpWVU1UcFBUSEJxOUF5?=
 =?utf-8?B?a1UrU2NSMzd2N05RVXg4SVI0d1d5WlU4Skp3WE1YRStzUktJRHNJSjhNQkRB?=
 =?utf-8?B?MW1mU2F3QWJPaWVJZWdXRkVHZE8vR25BMk02bjZxVURlOHBPWUFZQWUxS21G?=
 =?utf-8?B?K1Ixc09JUExQVzdNS2NGQVVYZ3RBQ1lqbUREUUx3cGxheGFObVdhd3k0a0s3?=
 =?utf-8?B?ek9MWnlrcEpldENRamFoTnZnZTRRRjhaLzhhaHlabXZsZVFQWEFtNnN3NWJQ?=
 =?utf-8?B?QW95RW1kZ3BHdmpOUzB4V1hFN1A0WVAwcm5IVGVCQ2dkVURVeWVYWkQ3Tmh0?=
 =?utf-8?B?Q0oxR0J0bEZYTUdEb250RkZacnV4ZmtkSnhMdHp2bUZwaTFlYzFFWDVNNnBs?=
 =?utf-8?B?UmI1TWVFam56ajdGQ1dwcTBzUzY4RmN2WTVEbTJyekRyYnBleFJORUJpYXBM?=
 =?utf-8?B?QjFuU1dLaWNBMk5EbkEvNUIvNXliTm5LRlRqV1dnUFRDMU8zbHJaOGF6c1Z6?=
 =?utf-8?B?cG1ndWtTVkd0Q1VTck9HV1dzbzllMEZDYUlZcHdpVm43aHgzYjlVajBnWG51?=
 =?utf-8?B?MERJWjdVcFBTUXNkNjVjMjQ2bkRHbHNyT2NDL1RiTFBwQmZjOURLWXFlY2N4?=
 =?utf-8?B?VGJCOTJsajlDSDNHVUlleEVhQ214VlpTckZtVFhWODdodk4xQk1Cc3VxRVhx?=
 =?utf-8?B?UURoS1phSFpEejVzbktFOW1zblp6VkpLNkpIZU4xdnllRDlFd0Q4cFdkRTNX?=
 =?utf-8?B?YlNoNVdFdUZPYjlVcmFGNWtMN3BBcERxSEpldTRnaFlSN1B1RXRsd3FmYjgw?=
 =?utf-8?B?Z3hEUjhZMFNOR040ZUU1RXJEcnV5UUtLWG9OZnFJKzIzcU00RVBRM3ZSTUI4?=
 =?utf-8?B?TnVIQmZaOFVuTGZCNWJPd1JNUlRYZnZLRWRSK29qRnhiSkhSRFJxSEJuY2lD?=
 =?utf-8?B?WVZ1QzlUNW5wWVlySHFNcWdDM1RCZWRkeTFKV3ovRG1pV3F0QS9ycjArYzQ4?=
 =?utf-8?B?YWRJb1VDcDRqdUo5cVdUaTYvaDZxRGo3d3VnbTJCTHB3UGxXTEh3SmJ6SC9H?=
 =?utf-8?B?eGdMU1RieXlkM0wwR0pOSVd5QTU0UHc0RTd4TSt0ZE9VNU9jeUF2VmdiSEI1?=
 =?utf-8?B?dWQrOStyWFM3QUNuNVdKWWlReWE4Tkg5NDNQYWZSTVpQKzlQNVErS2lzbXoy?=
 =?utf-8?B?alBjQlNURXhudkRoVGx0d25ZMzluSnh4TXFJSnNPYm5taU1PQmFlcU5mRngr?=
 =?utf-8?B?ZGJoRVgvc1hSUDdxS3FaRFdJWHRmdldEeWo1amhuSFlCNnFhTXI0ZGVSMmlC?=
 =?utf-8?B?bFB1VWJJZUJ6TG80Zm9XZVdUcnZBQ1dIY0ttaS8xNFlvUWczZG5aU0pZTXB3?=
 =?utf-8?B?Q1B3bEg1ZmNnYks1Mk1ueWwrWms4ZW1yc21HTDg0c3dBbGxoY0pCZVRLRm5j?=
 =?utf-8?B?OHQ3Rk94VGs4bzNuUVdyVjlvQmJKSC9mRlZRQXZXOVFwKzZJekE0TUpmTng4?=
 =?utf-8?B?VzJNZm9TMk1OSmFOZlJxcFRhVHF2d0t5eXhHb09nTkRKTmk4aWxaelZQV1lD?=
 =?utf-8?B?MEtSeEs2M0RFUWxXdXJCcVVJRWlqc3ZpMUxtZFZYWWVFa0hGQ1lsOXQya0V4?=
 =?utf-8?B?NHRqZ2Nuc2pxVkRnYzh4blVGRWxXK29hQTd5VnlOT1c4Y1ZhNUlYQUJRMUhv?=
 =?utf-8?B?eFhYR09PLzZuY3hIQS94V2JDdzFsV3M3ZzlaYTRUNkV6WmRGUlhRS0JZeG5W?=
 =?utf-8?B?ako2R3hEZUhMY1h4dExGcVlkTmorOVNIdWxIK3k1dFVraVFGQ21hTS9MSlQx?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wRHdk0MRwVwn41xRklEIy4Ztw3V6FEXkUKOCQbHq0qkdIdS75jIhUMGuYbGsfenV0/yq4rc3GS+RfU+WmG4a1KzFgLia3mR0wrK/ApY91jmWZ+leGiYTjlFdeXdbr8+z1lAouFogW0Q8XiKuLNWfvcBPifb2G6HibKE+2XzVD+Xqt8k0xkBR0HhXbZ4xGxpuvTmmzVIYQhMR/7amcyP2rhBMrw8fKaUqqbqksSjDcM1oW6upnBS8pUHQrge/LiTQzbYYf4yWacTSlDmQLJyVfU0z8lf/KKrBWlebxDYZ2yGwO4E4zC5WpHpIboPGNhtCR6PwU1hsMf2QMDf2aP1wMve71Ya7F22nqk3zU66g9yHnZGuVsOIqRrKdI3u2UOAk2ZC8bYzXaLCOC8a0XDqo0fBHWueEJiKllwFglWQJVG2CTubBOUFsPmQfgTQwIryE4lgT9M1ttdjk3GY93cGPVIFKOgfTi5b8BwtK1rTPykLapWB/UVPpA3olD7GvRBoUqx64ZDPdPm71Ag24lNz3Mnojj1hScAzyhPpctWwFAJZAkWuI3uxwSLYb8ET93tmr2vSBw/5hRfSWdOTiSd43ZG3GUz7PXmPpo6yKfYU+lV0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0dba299-c6b1-4cd0-9ecb-08ddf7633be4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 09:59:33.6772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNSGH73j0xJqBwwbDdphWuB4+o9EHLJc9hR0o/KdfC7KNtk+NALQqKgXQB0ajgyRJhUkNAp1KUX7N4k1GyeGQiGwqQJP+JsV0k/8NuEjpds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4493
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_03,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509190091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX3ySW50MGivVf
 JhjG3aEETs0GXMOpnM0pZ5ioEILI9uGtycgVnvugLvlQfujlJwFA9aq4Z0bXIvQmxg4lMysnvtD
 KQ36Xg+sfPNdcQ3vPOCWjmS7aoM8QclslvM2S+K4+AaarGndWDq13DTXxtq4kMx9NylpLrNsu9I
 9pK1P8kN7WVibYhFrJNYsnurCXwIRByyXGrCL6gHkH2a0rRe00XnjpcWSV9fLRDSpZ73C8JNRx1
 zMtnzv12nc3T2yS2T5AbIbRgFFQzTMY304ptNJobi3IF8H6u+x6z/uVdV1JdoUbaCBqDUZCII7V
 bPVOLM9N2aw6TTP8Cx0tLI3erFEr+O84vSNOw25r+ort0Cij+W85g2gw0wNODxc1yv95ptsUc02
 IEPvfQE3zX7Z4hvvQKUEc1SsAyxP/A==
X-Authority-Analysis: v=2.4 cv=X5RSKHTe c=1 sm=1 tr=0 ts=68cd2989 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=cjhZezTOG5YI60u3oh4A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12084
X-Proofpoint-GUID: CDFa9EcGjdREnJz6Y0cpnMRedVcU94sR
X-Proofpoint-ORIG-GUID: CDFa9EcGjdREnJz6Y0cpnMRedVcU94sR
X-Rspamd-Queue-Id: D026C140007
X-Stat-Signature: zfzjjnis8a9fk498o3xgbaro9q7okci8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758275983-288647
X-HE-Meta: U2FsdGVkX195QSsDtr2C3dCw5OuD7W9GJs8I/LaYMhAQLwFPFOcF2vW773JsxYL0Y1C1raDnaHo+kupedfG3/WQwEhOj6uT3a8lv9byqSDqKCiXctfUn5M69kluZJva+k97Lnr+XeVMdTg3Lmvqi5wqEhnZ00Egw5LXom+BA39FvhzJqn59+tqyL6HQFxzMk+cMVHPFsbV2aHg03DYf6USGwDxj/Z2zR06lS2A0m4D5yTHsAKYcXCm/gpxBjhjBgHXcDzQ18vrnbVrTZJ6EZFbi52tozVhrKhdv/ySmGSUnjk3Yq5BrLTCaNnSvaoqCG2/qFwnN/HjhZoUfEvcGOGC4Ctm8JIThhlR+aSo9dSR8+CxQ2E1oeVOefxkRGbJYtUIhzTcXLUAvf4OFUXbyo1lts0vBJXkOJMOFJl/u9FFnoHOstS3SaZF/KoUDezFSULFN9w/YYzYCzRPlavmZmk1Kou/28cE6YSM988EQJb5vdf698KPKWvf0pwPOrD1/G+JZJQhrmQaP7WnpI5MPEZTb9w38/nfZNRl3hy4V3E7QwoS8kDOT6jCWGYx+XA5XPb1u9pfycj+pytYnD1YkwSKyvnRh0DHdnDgcbe1zme4Ap4iv6DBKYtnQvfmn80/R3+fuX2J3tkUZNWBVQN12MuqsezM/bPjg5uMRG3iaMk2bPccL7KfM381OajfWfPRJ0U1WHI21FXs0mm++T8GQlABUQjUZ0v3l9kBAqUv8qZYQ+mBVw49iN58FB49Ct7Yd4FKkrBgmabYeYZLe8Bllprrffyj9Kfs5pWXxFJW6H+h8M/uFYEQegRnGVFlamRIi8sTfFejRbegCKC43FW3AvtBtPkwUZ0o4i1RpL7RbtfBvNl4AtfeSVE+eODKNnDWBZnFpbDh+B3CTBx3WBh8e5Gw6O29t2JQQCC068bzdZdVRxogZ6oeiX9kxOkcHKTDXpDv5Es4KPEAEjd76M044
 0Sf2TtSQ
 alnCWbBE36hcI6YABJJbHW48nFQA1ylMBwiEZGTZlTe+0sANQ2CCWWkuMUijaaY9ngNNzNvDx1FpnMJh/rebVYnRaz2Jlil2lx4fPJBjWkWWMx+7SeX5vekeQl3MUqp4DX11y1f9zSIAW5RKqIiLv6qH7VIH+ZT0Nn5TLgkKqA6SASTGZQe9KRH8wT63LcXZDw94aNPGAH04MhdYATrqLngSnt/3kqfRrgyTbuJ+TaSSp2SGmY9TsrDMKLxoY58VYxE6TnX8fiUnWTNV+qlWixNfTrJjtly9R6KGPU0qCmq5irERZ7X9KEMY9E7PN9+3Io4s0SWK84JYGwpawJhWOvpA1WrjUn8GQM2KPb0NKKrmtmX0v5Ac4Ri3D6YHxjq1epODVus8k7CR7mQM9o0j5zvrMK8WDmK5jCFPsAe8EBdz+9zegDoFKI0VDZHVhy9PCreJuWvq3CAhcOd0vJFMWChcDwW6Db8Dg+saE+9IL/GCAbYTSbHnyIR2Y+DeCvWBME+sgEkjroEFEuHYaUTjwCnP0H1vBgne/IbSc5h8ZFSeh3t9+XeuAlF25wbAGiPVJlofXI10sXUeN+68LARqP5mhiHl6ALhVmaDq5WkC9Mb5n3jL02stWfTb2ihap4xt1EKFoKrZetWn3F3Krx722EHfpgik6VIvRktDns/bJhfE7zzPRtOjrdOXq+G41Qtwz4vyT/k1pd1uwVIqYiHskjgPbBnXRMI/xM1j+ZjWBPxArFumQDGsPn8xGhIP0GjxVO0/FgFD+jBHZ4jPvoNwt+CV3ZO/edfJ+NgJ9p3Kv+Mg0nFedHvMlzc0poUi0xFCh+em1pzw7GB6PYPgyFf7z2JN0MDrwQbnmP8MlnpeFBhp5Titcy+3e5cx+Rf+gmDU/IOnz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 10:45:21PM -0700, Lokesh Gidra wrote:
> On Thu, Sep 18, 2025 at 4:57 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Wed, Sep 17, 2025 at 10:51:34PM -0700, Lokesh Gidra wrote:
> > > Guarantee that rmap_walk() is called on locked folios so that threads
> > > changing folio->mapping and folio->index for non-KSM anon folios can
> > > serialize on fine-grained folio lock rather than anon_vma lock. Other
> > > folio types are already always locked before rmap_walk().
> >
> > Be good to explain why you're doing certain things, like adding the folio
> > lock to kill_procs_now().
>
> Agreed! I'll add in the next version.

Great, thanks! :)

> >
> > Also worth noting that you're going from _definitely_ locking non-KSM anon
> > to _not necessarily_ locking it.
>
> Will do. But, just to be clear, you mean the opposite right?
> >
> > You should explain why you think this is fine (in general - rmap callers do
> > some other check to see if what is expected to mapped did happen so it's
> > fine, or otherwise treat things as best-effort).
>
> Sure thing.

Thanks!

> >
> > You should probably also put some information about performance impact
> > here, I think Barry provided some?
> >
> I added that in the cover letter. Basically the impact of trylocking
> non-KSM anon folios (in folio_referenced()) on active_shrink_list().
> I'll move it here.
> > >
> > > This is in preparation for removing anon_vma write-lock from
> > > UFFDIO_MOVE.
> >
> > Thanks for mentioning this :)
> >
> I got your message loud and clear the last time :)
> > >
> > > CC: David Hildenbrand <david@redhat.com>
> > > CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > CC: Harry Yoo <harry.yoo@oracle.com>
> > > CC: Peter Xu <peterx@redhat.com>
> > > CC: Suren Baghdasaryan <surenb@google.com>
> > > CC: Barry Song <baohua@kernel.org>
> > > CC: SeongJae Park <sj@kernel.org>
> > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> >
> > OK so you're making:
> >
> > folio_lock_anon_vma_read()
> > folio_get_anon_vma()
> >
> > Require folio locks.
> >
> > folio_lock_anon_vma_read() is called from:
> >
> > connect_procs_anon() - changed to take folio lock.
> > page_idle_clear_pte_refs() - changed to take folio lock.
> > damon_folio_mkold() - changed to take folio lock.
> > damon_folio_young() - changed to take folio lock.
> > folio_referenced() - changed to take folio lock.
> > try_to_unmap() - ???
> > try_to_migrate() - ???
> >
> > 9I note that we allow a TTU_RMAP_LOCKED walk in the above unmap, migrate
> > cases too, wonder how these will interact?)
> >
> > folio_get_anon_vma() is called from:
> >
> > move_pages_huge_pmd() - already holds folio lock.
> > __folio_split() - already holds folio lock.
> > move_pages_ptes() [uffd] - already holds folio lock.
> > migrate_folio_unmap() - already holds folio lock.
> > unmap_and_move_huge_page() - already holds folio lock.
> >
> > Can you:
> >
> > a. Confirm the try_to_unmap() and try_to_migrate() cases take the folio
> >    lock. Explicitly list the callers and how they acquire the folio lock.
> >
> Description comments of both try_to_migrate() and try_to_unmap() say
> that the caller must hold folio lock. But just to be safe, I went
> through all the callers, and all of them are holding the folio lock:
>
> try_to_unmap() is called from:
> unmap_folio()
> collapse_file()
> shrink_folio_list()
> shink_folio_list()->unmap_poisoned_folio()
> do_migrate_range()->unmap_poisoned_folio()
> try_memory_failure_hugetlb()->hwpoison_user_mappings()->unmap_poisoned_folio()
> memory_failure()->hwpoison_user_mappings()->unmap_poisoned_folio()
>
> try_to_migrate() is called from:
> unmap_folio()
> unmap_and_move_huge_page()
> migrate_folio_unmap()
> migrate_vma_collect()->migrate_vma_collect_pmd() acquires in case of
> migrate_vma_setup()->migrate_vma_unmap()->migrate_device_unmap()
> migrate_device_pfn_lock() acquires folio locks in the following cases:
> migrate_device_range()->migrate_device_unmap()
> migrate_device_pfns()->migrate_device_unmap()
>
> All the callers of rmap_walk()/rmap_walk_locked() are already covered
> in the folio_lock_anon_vma_read() list that you added, except
> remove_migration_ptes(), which is called from:
> __folio_split()->remap_page()
> migrate_device_unmap()
> __migrate_device_finalize()
> unmap_and_move_huge_page()
> migrate_folio_unmap() locks the folio for the following two in
> migrate_pages_batch():
> migrate_folio_move()
> migrate_folio_undo_src()

Awesome thanks for checking that! I did think it was probably fine, but
it's important to be as thorough as we can be.

>
> > b. Update the commit message to include the above. You're making a _very_
> >    sensitive locking change here, it's important to demonstrate that you've
> >    considered all cases.
> Certainly, will do.
> >
> > Thanks!
> >
> > > ---
> > >  mm/damon/ops-common.c | 16 ++++------------
> > >  mm/memory-failure.c   |  3 +++
> > >  mm/page_idle.c        |  8 ++------
> > >  mm/rmap.c             | 42 ++++++++++++------------------------------
> > >  4 files changed, 21 insertions(+), 48 deletions(-)
> > >
> > > diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> > > index 998c5180a603..f61d6dde13dc 100644
> > > --- a/mm/damon/ops-common.c
> > > +++ b/mm/damon/ops-common.c
> > > @@ -162,21 +162,17 @@ void damon_folio_mkold(struct folio *folio)
> > >               .rmap_one = damon_folio_mkold_one,
> > >               .anon_lock = folio_lock_anon_vma_read,
> > >       };
> > > -     bool need_lock;
> > >
> > >       if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
> > >               folio_set_idle(folio);
> > >               return;
> > >       }
> > >
> > > -     need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> > > -     if (need_lock && !folio_trylock(folio))
> > > +     if (!folio_trylock(folio))
> > >               return;
> >
> > This _seems_ to be best effort and not relying on anon always
> > succeeding. So should be fine.
> >
> > >
> > >       rmap_walk(folio, &rwc);
> > > -
> > > -     if (need_lock)
> > > -             folio_unlock(folio);
> > > +     folio_unlock(folio);
> > >
> > >  }
> > >
> > > @@ -228,7 +224,6 @@ bool damon_folio_young(struct folio *folio)
> > >               .rmap_one = damon_folio_young_one,
> > >               .anon_lock = folio_lock_anon_vma_read,
> > >       };
> > > -     bool need_lock;
> > >
> > >       if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
> > >               if (folio_test_idle(folio))
> > > @@ -237,14 +232,11 @@ bool damon_folio_young(struct folio *folio)
> > >                       return true;
> > >       }
> > >
> > > -     need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> > > -     if (need_lock && !folio_trylock(folio))
> > > +     if (!folio_trylock(folio))
> > >               return false;
> >
> > Same as above here.
> >
> > >
> > >       rmap_walk(folio, &rwc);
> > > -
> > > -     if (need_lock)
> > > -             folio_unlock(folio);
> > > +     folio_unlock(folio);
> > >
> > >       return accessed;
> > >  }
> > > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > > index a24806bb8e82..f698df156bf8 100644
> > > --- a/mm/memory-failure.c
> > > +++ b/mm/memory-failure.c
> > > @@ -2143,7 +2143,10 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
> > >  {
> > >       LIST_HEAD(tokill);
> > >
> > > +     folio_lock(folio);
> > >       collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
> > > +     folio_unlock(folio);
> > > +
> >
> > Good. I hate how this works.
> >
> > >       kill_procs(&tokill, true, pfn, flags);
> > >  }
> > >
> > > diff --git a/mm/page_idle.c b/mm/page_idle.c
> > > index a82b340dc204..9bf573d22e87 100644
> > > --- a/mm/page_idle.c
> > > +++ b/mm/page_idle.c
> > > @@ -101,19 +101,15 @@ static void page_idle_clear_pte_refs(struct folio *folio)
> > >               .rmap_one = page_idle_clear_pte_refs_one,
> > >               .anon_lock = folio_lock_anon_vma_read,
> > >       };
> > > -     bool need_lock;
> > >
> > >       if (!folio_mapped(folio) || !folio_raw_mapping(folio))
> > >               return;
> > >
> > > -     need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> > > -     if (need_lock && !folio_trylock(folio))
> > > +     if (!folio_trylock(folio))
> > >               return;
> >
> > This checks folio idle bit after so that's fine for anon to not succeed due
> > to contention.
> >
> > >
> > >       rmap_walk(folio, &rwc);
> > > -
> > > -     if (need_lock)
> > > -             folio_unlock(folio);
> > > +     folio_unlock(folio);
> > >  }
> > >
> > >  static ssize_t page_idle_bitmap_read(struct file *file, struct kobject *kobj,
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index 34333ae3bd80..90584f5da379 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -489,17 +489,15 @@ void __init anon_vma_init(void)
> > >   * if there is a mapcount, we can dereference the anon_vma after observing
> > >   * those.
> > >   *
> > > - * NOTE: the caller should normally hold folio lock when calling this.  If
> > > - * not, the caller needs to double check the anon_vma didn't change after
> > > - * taking the anon_vma lock for either read or write (UFFDIO_MOVE can modify it
> > > - * concurrently without folio lock protection). See folio_lock_anon_vma_read()
> > > - * which has already covered that, and comment above remap_pages().
> > > + * NOTE: the caller should hold folio lock when calling this.
> > >   */
> > >  struct anon_vma *folio_get_anon_vma(const struct folio *folio)
> > >  {
> > >       struct anon_vma *anon_vma = NULL;
> > >       unsigned long anon_mapping;
> > >
> > > +     VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> > > +
> > >       rcu_read_lock();
> > >       anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
> > >       if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
> > > @@ -546,7 +544,8 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
> > >       struct anon_vma *root_anon_vma;
> > >       unsigned long anon_mapping;
> > >
> > > -retry:
> > > +     VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> > > +
> > >       rcu_read_lock();
> > >       anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
> > >       if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
> > > @@ -557,17 +556,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
> > >       anon_vma = (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_ANON);
> > >       root_anon_vma = READ_ONCE(anon_vma->root);
> > >       if (down_read_trylock(&root_anon_vma->rwsem)) {
> > > -             /*
> > > -              * folio_move_anon_rmap() might have changed the anon_vma as we
> > > -              * might not hold the folio lock here.
> > > -              */
> > > -             if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
> > > -                          anon_mapping)) {
> > > -                     up_read(&root_anon_vma->rwsem);
> > > -                     rcu_read_unlock();
> > > -                     goto retry;
> > > -             }
> > > -
> > >               /*
> > >                * If the folio is still mapped, then this anon_vma is still
> > >                * its anon_vma, and holding the mutex ensures that it will
> > > @@ -602,18 +590,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
> > >       rcu_read_unlock();
> > >       anon_vma_lock_read(anon_vma);
> > >
> > > -     /*
> > > -      * folio_move_anon_rmap() might have changed the anon_vma as we might
> > > -      * not hold the folio lock here.
> > > -      */
> > > -     if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
> > > -                  anon_mapping)) {
> > > -             anon_vma_unlock_read(anon_vma);
> > > -             put_anon_vma(anon_vma);
> > > -             anon_vma = NULL;
> > > -             goto retry;
> > > -     }
> > > -
> > >       if (atomic_dec_and_test(&anon_vma->refcount)) {
> > >               /*
> > >                * Oops, we held the last refcount, release the lock
> > > @@ -1005,7 +981,7 @@ int folio_referenced(struct folio *folio, int is_locked,
> > >       if (!folio_raw_mapping(folio))
> > >               return 0;
> > >
> > > -     if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> > > +     if (!is_locked) {
> > >               we_locked = folio_trylock(folio);
> > >               if (!we_locked)
> > >                       return 1;
> > > @@ -2815,6 +2791,12 @@ static void rmap_walk_anon(struct folio *folio,
> > >       pgoff_t pgoff_start, pgoff_end;
> > >       struct anon_vma_chain *avc;
> > >
> > > +     /*
> > > +      * The folio lock ensures that folio->mapping can't be changed under us
> > > +      * to an anon_vma with different root.
> > > +      */
> > > +     VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> > > +
> > >       if (locked) {
> > >               anon_vma = folio_anon_vma(folio);
> > >               /* anon_vma disappear under us? */
> > > --
> > > 2.51.0.384.g4c02a37b29-goog
> > >
> > >
> >
> > All of the above actual changes to the locking logic looks ok to me though.
> Awesome! :)
>

:) we're nearly there on this... now you, David and I have gone through
this in detail I'm confident this is actually a really quite nice
improvement in general and by unravelling some of the locking hell we might
actually get some other benefits out of this (as referenced by Barry) :)

Cheers, Lorenzo

