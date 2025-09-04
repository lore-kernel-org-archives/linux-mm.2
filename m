Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5EFECA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 18:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9978E000D; Thu,  4 Sep 2025 14:50:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A648E000A; Thu,  4 Sep 2025 14:50:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00AC98E000D; Thu,  4 Sep 2025 14:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDE328E000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:50:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AEC285D47
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:50:06 +0000 (UTC)
X-FDA: 83852457612.05.81288F9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id D96711C0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:50:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=USohDrDX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PuKt4JTF;
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757011803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwfu2+wCgKuXk7ZR3tZuMY6mdng7V+2Oy0RUsNOVHcQ=;
	b=bVrRHQ8KFI3QixVX2znJ/I/+ymPGIO6biv8IdAMfO41BomQe3K3IOyRd2Gr30uODR3+7Ut
	oMvEidO7QCO6hW8okFzOOvQUokVPJK9l5hgLbkYeRCJPjeIBWepW5ww/8kM0L49hvaRpD1
	gyhtChtNQs28aNmgdHJYLg/dmc1FZfY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=USohDrDX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PuKt4JTF;
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757011803; a=rsa-sha256;
	cv=pass;
	b=a2iZ/TFQW3Ncloo4fMDTcBHTl4fnoBMXbDGbHS+5pyaioF7eKWjLFMkgFfzEUG/krwGx1i
	ICKpwI3j9Y29hi2X8o7MTCQSfF6gFWHvpFgmBXQUJgYoGEu8M3ROLAxQbflddl8IBfN2XS
	R+Os8dA7Va4GHQhpfj4G6lqeOpRL1Po=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584HOmPf025262;
	Thu, 4 Sep 2025 18:49:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xwfu2+wCgKuXk7ZR3tZuMY6mdng7V+2Oy0RUsNOVHcQ=; b=
	USohDrDXXEYh0iD8HZCYng3Z7JB8z1eb08pKhITTVDo678MZysIDv8h42fPv7aBE
	wM4X2xIcrnraugOupjhfzj4LmgkRCY1KvcWUAyF9mdKcNm9Ij4ay5TLDn6Mn8qux
	GVPDz6j1rflqpsKjqHuZrTmC88yELmkfc79lOXN/JFngvYWUI/Iv+zejX2E0gShJ
	bU3t/tL/CgBNWrUPGU94mvkqN4OGUT++VcQA4ZIC1DXSSvVtimeCyj7RN51H3xSC
	eNTKeP+FUmWQLAUmLSKtiAVPrk1TsVpDE31aHCYOuKmCynSiiVMicMJfE05r31fl
	9t3y2VjAY9aBOW09dPrscA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yf5185c1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 18:49:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584HmEEe036227;
	Thu, 4 Sep 2025 18:49:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbvxp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 18:49:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dudcGIyEL6yCOwIVklHIR+dLysb/us23Xzrqy5QKL8nrifL+/EqKJsKh1Ytn88UAchwzhOFQLQjoO4GkUwFAEKkM5hNoaofaGr5/fp1dgu1Kzk0zDmjEbWY9awNQPi9EGPWyPRhAqC3Dw7dtvpVS7CYtoki1jP7dJ2eno+jGFRDXMhvXbqZrsYjCMxzc4zJ3zjkZ7/pKfhlrU+/efxgSve8feGq10EpTh1ENXg8hJbR3dmaVUlu23wew/Itznjg6mYgbGN6wR5oiU8BUFy8QlqIwv+nnBB4CQG2SzjOgZCBuBKu+6+9oI0U8cVN4iyh1+a/ZmkAbyjfq3SwYBy2jfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwfu2+wCgKuXk7ZR3tZuMY6mdng7V+2Oy0RUsNOVHcQ=;
 b=aHMQtvQKGF86WYpm5yk4mCcbArmQKymksYGrTlY++wdZT2n8vJnyfnD0IFxFsp3H1nbuJvjGdWz47Ej3MNDQZOyzf8E590ztwEL8wv4dgH9qU0bYUomjRa6opr2n1Kj61qxiKfl5eYDXAy2vmND9lpn1pIETbjFkGNQZQB90kBk5Xk1U+jvuIm2eiP4C/W3paaEoIgN2WMkUwDMg7rUm8jSWBqXrD+eJm+Juygq5q5qRSg6tqaToJwEr62XRqlvYu/QjrXrgLDbXsLLcdvSokHLMDoRzRhFdEiQmxGB3SdWJcYS8IMPbJ8SHvR/fVIaqGN2Jy7EZ5qE8ln4KeXTX3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwfu2+wCgKuXk7ZR3tZuMY6mdng7V+2Oy0RUsNOVHcQ=;
 b=PuKt4JTFJHmtAgobWrLDW+yKtVVLn7EEJ36W2f5Ue7QeeKSkg5r/gZ/Tsq4660VbminjwUzU7JWa4MNdzfYtIgKEG/sJmtfhbuT+v5VNnDZuAVHfAn7qt35HXzf/uJgHmQInlbx6tup7ZfIsBXb9+qdY3C3y8FQNZAl9YNHAGOY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB7469.namprd10.prod.outlook.com (2603:10b6:208:446::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 18:49:53 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 18:49:51 +0000
Date: Thu, 4 Sep 2025 14:49:47 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        akpm@linux-foundation.org, minchan@kernel.org, kernel-team@android.com,
        android-mm@google.com, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
Message-ID: <4chxl7uxr4exy2z2dcshxla3c5nzzo2tbnelsbbky7pdzrih6a@hzfnpbenfmub>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Kalesh Singh <kaleshsingh@google.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, minchan@kernel.org, 
	kernel-team@android.com, android-mm@google.com, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local>
 <43ryds7hzhs5bpaxznco7fppmakdb4f46agwtsc5erudqfoz2x@7y4jgbtft7jj>
 <413ee338-1795-433c-b3d4-72c870488d95@lucifer.local>
 <84aad392-3bff-4f98-b612-5e9a046edb36@redhat.com>
 <CAC_TJvc=5=iS8gCumJWqH5eF4XufFSogqtWHJmiH5WBN1A6gng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAC_TJvc=5=iS8gCumJWqH5eF4XufFSogqtWHJmiH5WBN1A6gng@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQZPR01CA0046.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::25) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB7469:EE_
X-MS-Office365-Filtering-Correlation-Id: d53d4ca6-cdf4-4965-21da-08ddebe3d470
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UVgyVHZiQXVnb09OYUtIY2phNXVYT0xseFUxL3E0TkY5bEErQ1lKM2tadkdK?=
 =?utf-8?B?VHVmZGFyZEVlVVpLaFFHc2tPekxEQjh2cXllS0NaQmxNaU4vQUJiWDNtbU43?=
 =?utf-8?B?V3dtUVBDQVZ0V3RMdHJ2K2xMcnZJME44SXZhQlJ1cmRhVjdzblQ5Q3dmbkNC?=
 =?utf-8?B?dzRyNzgzVUUyRkJ6SmFVOXZUY2ppMnNaMEk1V1ZybXJWcFA2TW1oYWh5RjBy?=
 =?utf-8?B?UkdIYXNuc2pETDBuSEFkRE9uNTdqZDl0TU5WKzl0N3plZm9TOTRLL0haYVNq?=
 =?utf-8?B?REl6azgvVXNSNkxTMWNVaXBBRFFEY3FWT2tJUitydWUzOW9mamp5bWRWK0s4?=
 =?utf-8?B?YzNzQWRJTTVxN2xkWEovbnpjbU1oNGlrek5aV0h5cVFDWGVUZ3VUM3dvZTYv?=
 =?utf-8?B?a0VReFJtQ2NlNndYc25iS2Z4VDYvT3NnZ2Vsdjd6RmFUVmQvdXZNVkdON2Ez?=
 =?utf-8?B?VktieEFtaEJ5VTY2aGgzNU90VC9DTnVIMW9OaEhUektpd2JPK1VNRG9LWnJs?=
 =?utf-8?B?dW5qblVCd1hCL1lGakVtajQxZm44NVZ0SEtrWm02TnpKbVlTMkY0OXZxcW9P?=
 =?utf-8?B?bmxhelZXZll5dEJ1cWJldmdRL2xyVzA5bGFZbVhRSlhUODRFdjRYbVRtRExv?=
 =?utf-8?B?M2JRUDI4L3cyLzBqT0NXTGp3SGs3RmhUbThld0JuSTlJWEFrQU9sVWd4b3d5?=
 =?utf-8?B?NTB1b0Z4Q0JqRmVHUEY0RW5lald5RzIwdWdndUpsT2JmeDg5cDQ3bVhMbTZm?=
 =?utf-8?B?SWY0Z2YxRmFFYUNuKzVhWW1NandUbmhIekxldTV3dS9hSm1qVEJQTjBLVDAv?=
 =?utf-8?B?NHRSS3ptcmFUcFp4Q2ZxRVc2Zk1IV2dtRmFxV2drOXA4Zm5XOWFFd2NhSktn?=
 =?utf-8?B?UkZ3RnFJZk95Y1VrWW15TkdwbHhBK0xEQ3B0RnNXZnA0VnpMVjBNeEk0a0sw?=
 =?utf-8?B?VDBHSC9Vem03Snd4djFETlJ6cUk0Q1FldmJIY2R5Ync5NnBoR3FGNVFpWUJh?=
 =?utf-8?B?a0RoRVNLN2VqQVpCNTc4clZUSHRPMTZpTmpyYzRWU0ptNWVhODhnK0lxUHN2?=
 =?utf-8?B?STdzdmprUXg0dkpKRXpjcXJVTDNsSlVQM21OVkV5T0txZlNCdkFJYWVUREVj?=
 =?utf-8?B?a0ZWYjFLYlJsejFIVlJ5cklzRHhZdUF3bWZTVkkvR0pBOVlpd1dWd3NaOHk4?=
 =?utf-8?B?YXNIYWE1OUdscnNqWHUwS3liT2FWd216cDlqalErYkZRMmJkQW9WTkVSbmtW?=
 =?utf-8?B?ckk3c3MxV0ZMVUxnVERSWnV3NGN6dXB4Tmd0R1BYUFVkOGI1UlhuRXh2V1da?=
 =?utf-8?B?WUdwelZjdk1NK21SdDRyU1hGMytUdEJJUmZ2cnJqZ1ZYSjE4K1pjcnkzTE1K?=
 =?utf-8?B?ZXhab1JxMlBUV05QTzUvcGNET3I5WWFBdUlmSEdzRU1Dblo5SjBNNVRrRm9w?=
 =?utf-8?B?T2VPMTVJeFdkMGo3UmpENzJBTWlzdkhKb0Uzb2hrUG5nQ0JIN3JzVEYxeGlo?=
 =?utf-8?B?THY2WnVacUcxU2hCeVdqVlRTa2ZtNUp4cDVEc0VhenQwNEtaYUU5b2ZXZ2Vi?=
 =?utf-8?B?U3FLMGN5cVM3c0JWbXZmdERjZWdWMGlhSUU2eDRtbEVGVDcyR0xVbUpNS2RH?=
 =?utf-8?B?QXBwekZZZWY2SEVEV1dzdVdwZloyRDBuc01Ca0x3Z3RVUW05eHBDc3BOdlVR?=
 =?utf-8?B?cVJDQmdMOXdCU1lKSE1kREswZnBSbjVGY2huRVdHS1Q1Mi9lVVVRV244OHRB?=
 =?utf-8?B?OU5VZExmTzBSa21RMHgycXR2RkE5Qkp5S0VwS09FNTJ5cjg1OVRjN25wZmVX?=
 =?utf-8?B?aUtWVzJwOWdTSVJrRC80WjZrVzZKWGl3SVJOOEhuUnU1dU9sV0ZzLzI5UGw2?=
 =?utf-8?B?TFVuTkhQUnMwMEcrUEw5b21BWFNHZEw3ZHZXSEJwcGxPbG81UklGdExsS2tS?=
 =?utf-8?Q?dSwhHM7PgjI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnpNcVRQNGRZTExMOVNDcnNBMEt2SkptRnJCNy9Ua0RrT29aSkxJQTl4ZE1O?=
 =?utf-8?B?OGIrS1YvSjFlUmN2ck9CM0RNVVpRLzArUEU0ZnlQejNCRDltV1lKQm9yU1M1?=
 =?utf-8?B?MFNCdkJoUGVLbG9DeEsyUGpQSlo2Rmw1bk1wem9PdWNKaGl3YWZpUWd5eExI?=
 =?utf-8?B?cUp6cXVNbC9SSDBBbDFDOEl1Y3pSamFRZm10UmhXQVNWdm1xZ1BWa1JQeVZG?=
 =?utf-8?B?cjhaQTFPUlM3UlRqZUdUOXBCODRhRUpmaDRwaEJoRmJBZXc2ZE9mbEE5SCtZ?=
 =?utf-8?B?WGkrSlpHd1o3SXpPM3NDRzBsM3ZSMVJrZGw4elZTODU5TmZPZ2ZqRmx0L0pE?=
 =?utf-8?B?S2VmdUxxKzlGQXpNa051Zzc3QzNxbG56bVEvMmJMcGk5ekRLWTFwUUJWWmZp?=
 =?utf-8?B?bzhLS0IvekMvYUpKSzBzZmpnQjhONnN2b2lvZE1aT2hGR24ySFBuakV4M0Qw?=
 =?utf-8?B?VGRKWld0SEw3NGFlcTgrd3Y4ZnNRSlBhcjZjK0N1NFZUUkQwTTlkaGg3M2Nq?=
 =?utf-8?B?U2JPd2tjbFBINEVnNE5heXBCWkpiRzFxRUJ6clVId2lNb2VBM2tjbkNjTGpV?=
 =?utf-8?B?VU5GQm04MjVrbWk2RUZXeDNaMVFDWXFzeVd3TEVocjhUTWozNlpUd3lBcEVZ?=
 =?utf-8?B?aVE4dnA3cmREOGRXRlowcTBUSTRlcVFFN2RyaUNlRndLMWlZY2g2YmpsQjNU?=
 =?utf-8?B?a3Rvb0NGOHM3VnNZbDRNN3dCdmtUVisyRTltazFQd2xkYStuVE1PbklxWm9F?=
 =?utf-8?B?bUc3TnVOZ2FYSU9LNHVnNDNZa29sK2JINUJla2lDdTNSeUdBMzV2dU9SNEFk?=
 =?utf-8?B?Mlg1SGNuM1ZEd3JrVVFRS0pMcFBVZU9vY0NzTDZDRW42QzJmNWIrR0tkbE95?=
 =?utf-8?B?RzAvWWFjRFh4YU14UUFEcnJRdS9uekUxSnpEV3grNit0ajJkV0tvL2Y1NE56?=
 =?utf-8?B?ZEVyQXhtU1FIbkFEK2wxQTBobEhrY3hZREdXVTN2dVBVRXlFRCtZVkE4SzlL?=
 =?utf-8?B?ZTU0TFpwV0JEOHJZbFhQK29hVU5xNDRyRHkxZGVCWWo3c2tVdGY4NUlkSUpn?=
 =?utf-8?B?a3pUa1pzSnVVY01VVVNGbVVPNWthVlZMZzgvd0d0VEFjcThrenhsVUpsM1p6?=
 =?utf-8?B?WU8wcnZRcDc1REZzRHJ4bWw3Uk1FcnR4ZDdDNU9GUU4wcWIvTjR2ZXlLQ3hH?=
 =?utf-8?B?a1Vocmk4QjBWUHdXSDVkQkJQWGFIVGI5ekNvejE1L0JFUS93VFhJMmJSYTBw?=
 =?utf-8?B?N3N4VFl2Uk54VnFyMVpVcjdYZG9YcC9KUTJ0b1o0RlM3R2crL3pBSWIwNFMw?=
 =?utf-8?B?a3U4UzBRVlZTRkxUTEY5ZHBYVE1CakxmQTJBcVNTR1diVTJMNTQrc0QvMVlw?=
 =?utf-8?B?TlcwUno3YXdhcUZvZldlOFNaY3Avbi81cFRIaUhWRDZZV25tV1h0UFNENGNS?=
 =?utf-8?B?WDVWaE9UZThqMlJ3VEw4Z2FXbUVpZk04Q2tvYjNGK0FYT1F1WFZVYnVTMCta?=
 =?utf-8?B?M01EQ0Z0eUlaREZpcGVwUEtwU0pBVkhUY21HdWNKS2M0YmJpQS9zUWNMZ0hN?=
 =?utf-8?B?eExyS1l2RFFWQ3ZTeTlRK1U4NVNnZkQzeFFEMk8vZldEMDJvNWhNdmxFSEFa?=
 =?utf-8?B?ZEtPQjB4ZjY3c2NrbnoxL1A4dVE5RnZpd0dZVEZpWVBCeEFiT1RVcVh1Wkwv?=
 =?utf-8?B?WGNlcTIrR1NaRFVVQk95SHJXUnpHZGNNZnVnbkFSWm5tVUhMdFNVcDdnVDZX?=
 =?utf-8?B?LzFDTDNoQ0xqL1poVy9rKytuVS9IS3JuOGpDTjFXTU1aL2h5ajRheCtJQTUw?=
 =?utf-8?B?NDNFODFneGJ4dlBpbDdLOElSVXhKN3lMajZvMUVLSzF2WlNIb1hXUDFOR3M0?=
 =?utf-8?B?bHJjUCtBQzRsL3VVQTg2TTllSE1KdHYrd1FrSE9WaHhHYU9NYTdxeWphYm1k?=
 =?utf-8?B?S05NOWZzelowOG9wNVRIQ3BkaVBDcG16ZUpveFB6UmwvTndkMU1FbXV5RFFW?=
 =?utf-8?B?ZVRhWFNybFY1NWpVbUlzc1ZpN1JtTkNlM2s2M2d3RmhYdmNsQWRYRU5Xa0p6?=
 =?utf-8?B?bDVuOVpZY1h6MUdhM3Z2SHM1dWlFK1NjTktYOU5qVDg4bVgzV3d1b0FUYWNR?=
 =?utf-8?B?YldsVjlKMWlaM2ZHUDlSVms5MEphMkdVbmVramVWTFhEUzhhY2FoTXp2TWYz?=
 =?utf-8?B?cVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tRqyey4ZuQ8GNesmJZ5Szkew/bdpD05iLisopxBTNvoLUWmhOJjenZkghCUsSi4RfhK7WBkXFQ5vluBOTnfPjvXoH2dfNwKV4oDt2jV/9fm4sJm/WQCM5khDfAkloQqdAT0DG8UuvvkUiMRiYBbOn/sQdcMaAoAvjX5hPm1X9gGYS/cpLoesnBOJO+tF+KG+0ZMwq1dK7S6Ohv576Y4aTu4rou+GYwhjsHVp/Og0XekKx3LuTcxN2Lx1bKvdz675kXnJt+xabM6JtlhSuYorN/OFr9JkejLq53TnaDZgGaeJoDjHcXs2gUl83ZAfeMabRRRjfVbVWFks731Hn7Am59FQQYyCgxE+6tTXv+I2ZANW4Vk9a1By1KPccsfPn6tQowNx8R0lqVZeqfzwpP05I5vpM54RMNXlzPM4wLmiluHQX0KWllAUgs67LyOZFCHNB4wxbw0Eq3idIfOF2PyMFY2CKpIK3l6JnxWnM1p2QsFNFUM30gQFz0gyBeMl76eWrICJrzXftt3bxkJLj7VhkNjyFD2CjFLqhnmF1kW2WNHibwtU06Vx9ej2Ps3YvR/TFUscBHwtI/xhJCyI0Y6pAZsam8bO8UPxSl7IkU7wOaI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d53d4ca6-cdf4-4965-21da-08ddebe3d470
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 18:49:51.2245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m2N3tx1CXSxP0vGIpamgyR4tyiR9jkIumL4S6A3Un4m5BhNhENCL2khgWe6zm75UzHEkY094A8uOW5l1ZLZCbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7469
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040186
X-Authority-Analysis: v=2.4 cv=b/6y4sGx c=1 sm=1 tr=0 ts=68b9df54 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8
 a=QWGzfrk0qg9OPe8umlQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: h8MKAPj3gfUqPDnj-Thmw20gDWgZJw3o
X-Proofpoint-ORIG-GUID: h8MKAPj3gfUqPDnj-Thmw20gDWgZJw3o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE3MiBTYWx0ZWRfX3Eu459pg5TxU
 uvk0PIICSZGCSnf91gocZ/7LAFsZW9kYV1UbvmqrJs7HKtxoQEYWxQag4oemdlMyRIwf33wW9zK
 v89l2yfJZ+sObKt/ih5K21zT2pOpfT7iI5r0Is/BmYTHItO/30l2Oc+AT9APQYy/bROACBWuW9u
 b7QAxfQ89mb/woRhMO79HslWyULGCbhSxTVG2RRMrH5azZu5/qQgK0Hgx/4/nVmlEHceuH6DW3w
 35T3Cq+TQcExM1xZHYoOr8Y3omYEV+fFNCEGLSa7mifL78avPcsJetr445G5m9txIcF9j69GyL5
 mBG4rU19pEm9A206aukYWSW/3CHBg1GN49n1OrXbsU98GSxiiDGb+91WIUmsYnxO4ASC0qTNnNl
 7CKt1iSH
X-Stat-Signature: j3fg8f6iujp5kgs58ah88bkoiiy9e47n
X-Rspam-User: 
X-Rspamd-Queue-Id: D96711C0006
X-Rspamd-Server: rspam05
X-HE-Tag: 1757011802-384562
X-HE-Meta: U2FsdGVkX1+Kd7EFfXy7PIF/hjT9VaFpAlmBZ0/ZeD0g47ITdDzCYpAVgVSM7XJYZ+C61U7HCHqXKPWnHAmjSgCgXj0hq+IUs4QdVMFQcJqjI/uMA+xuFrlMS92thwLQ+7GZsN+kR0nQw4hfoekzWPiPtihrJQ67ZUOiSd7ifvZrRhv4AC8m3epdifxyeomzZkJNm/omY0dux52LZ5WUjQKUjuTKWFMEoqLXUQUE3ZGT8BIxVQPPyAaatI8VwX/6GsBlFfGT1a3amE82E/Z2QX1j7wyJ2htll1IAvqxolYnA1a0HQL+gInWLeq6z0BaNQ04Ji2g2sBK0c99Tlcqdwx+F7G2OejpT3jbPjsuNHRrFKiqJBNaH4n0MZYjGbqpBOmbKnVzh0ooWbrVqXUFGBq+WgIE1iWe94Ors+ixBWdQOk0J3U8FJroN/zmfZTtDV/IGAVT4aOzR84fHaeINotBUFQc/nW+MaIhgZcZQfgODLfpKBET93SDGIWeeIR6yYmK5moj/YKl6Gz383r0BwiDucyWZSkIONTgrNLrgMVvsxx9xBeUFQPcFoltm0OLR5XtI7CBGzGHZvOl5wAO7r36xQkmDHosZ0y5znbhX6aDVfOl5Q5NvHP+WYHZIIuwllu36pT0ndH4ylpJox0ikHhudIw1povl34F5f3jTXHDyYrcB3ssgXK6zde3k+CLKgQZyKgVClNfip9jHDJJRR659TEJekT6s0r88GEJGwJobfle2Fw/tu0REuVvQcZ0ELgiOPSTtiFmEmXavAXRaIwUNwog47t/HZtJKjLZDNKOcqb5dS2mhr+Fm431MSChLf0ffdSxX2K6Jra3W11RQQZ0EsEI0OKj2eHZlGuqbWKh1NzKchRx1vvwK8+BTQ30xJIFuJoCV8Mn/l/+8wVjQ5fpnd9C/ImXuAHWCElZAN7D/uxuf9zxHJWEqCsLIdMpFwjWp4YDa7Pprjg11kULiN
 qYPqJAZF
 SSmX/jS/3icHKSgVO8FyNFyZZvopcIKTmjYPxCFj31WZy0iEXSyOC/E7NTHCaHejVhTfxNj4VuVsYCGuZt0exnMNzvauW4c8vnIrFJ3H6lgo6yvSGNNxIsh80F+9It2X2Ac3ETOQ8/pPJ+1mxT7Wi5Sr38ohVyd0k9dckklz/0ooIBqljaI6Luw95Ow7XVP2pnLQvf1wKF4d6bbCSlDOFGjJYh90zUj1ppRwhGZb3mqsV24FWAaJVCT6F/5mkZYc/GnydGb4JX4thlopMYXZZqF5HgZdB5M2c1xdb/qsWIQU/dhdJW8zqNIxBSDQQVZlKRxbhBlBIhzrNl0cfzZTuVPSQ2Q5RiPhrjGyu7ULdwhAIET6QDSOMfIJILHdHhCXntl84AqydW8M8n2lYUkaCLWSSaMOVT+YG30bfOCtyDuBwJwdPorUgji/IISfV3mSu5ov7TOr5/5t+4jtrgO5rJWEGevLOB1F907Qrl/ZSNameRpE7XIZXq5Wf+Dlf/bJi/36nZ8C7cWLYjJcNwwEF4Snv9zu+cVP3OaYKWUVdcQFmmVK2kCjEuWx3UbQZjXNXPT20e66CeB/a8PANp56jV8a4+GcbgIDTjfEQJcKpy6AniadzdfDcszTXzFoxi1KcOHx7rMwBI2N0dwnyo/OjnrvOl1rMe2NY4QrhIZvkcjJD2EU7cQDdES56iTvsxhLGrJe7IeU93Z58i0E4rmAYv3ZWZzjeAN3fpZSA7PQQyK2JUW+PCeGcJmez7bmNCuzuneoThbKJVZGTOYw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Kalesh Singh <kaleshsingh@google.com> [250904 13:51]:
> On Thu, Sep 4, 2025 at 10:42=E2=80=AFAM David Hildenbrand <david@redhat.c=
om> wrote:
> >
> > On 04.09.25 19:33, Lorenzo Stoakes wrote:
> > > On Thu, Sep 04, 2025 at 01:22:51PM -0400, Liam R. Howlett wrote:
> > >>>> diff --git a/mm/mremap.c b/mm/mremap.c
> > >>>> index e618a706aff5..793fad58302c 100644
> > >>>> --- a/mm/mremap.c
> > >>>> +++ b/mm/mremap.c
> > >>>> @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vm=
a_remap_struct *vrm)
> > >>>>     * We'd prefer to avoid failure later on in do_munmap:
> > >>>>     * which may split one vma into three before unmapping.
> > >>>>     */
> > >>>> -  if (current->mm->map_count >=3D sysctl_max_map_count - 3)
> > >>>> +  if (exceeds_max_map_count(current->mm, 4))
> > >>>>            return -ENOMEM;
> > >>>
> > >>> In my version this would be:
> > >>>
> > >>>     if (map_count_capacity(current->mm) < 4)
> > >>>             return -ENOMEM;
> > >>>
> > >>
> > >> Someone could write map_count_capacity(current->mm) <=3D 4 and reint=
roduce
> > >> what this is trying to solve.  And with the way it is written in thi=
s
> > >> patch, someone could pass in the wrong number.
> > >
> > > Right, but I think 'capacity' is pretty clear here, if the caller doe=
s something
> > > silly then that's on them...
> > >
> > >>
> > >> I'm not sure this is worth doing.  There are places we allow the cou=
nt
> > >> to go higher.
> > >
> > > ...But yeah, it's kinda borderline as to how useful this is.
> > >
> > > I _do_ however like the 'put map count in one place statically' rathe=
r than
> > > having a global, so a minimal version of this could be to just have a=
 helper
> > > function that gets the sysctl_max_map_count, e.g.:
> > >
> > > if (current->mm->mmap_count >=3D max_map_count() - 3)
> >
> > I enjoy seeing sysctl_max_map_count hidden. But map_count_capacity() is
> > even more readable, so I like it.
> >
> > I don't complete like the "capacity" term, but I cannot think of
> > something better right now. Maybe something around "free" or
> > "remaining", not sure.
> >
> > I also don't completely like "map_count" (I know, I know, we call it
> > like that in structures), because it reminds me of the mapcount ...
> > talking somehow about "vmas" would be quite clear.
>=20
> Thanks David, my original implementation started with vma_limit() :).
> Maybe something like vma_count_remaining() ?

Yes, reducing this confusion would very much be helpful.  In fact, if
you put it in its own function we could change the actual name with
lower impact.  map_count vs mapcount is annoying.

vma_headroom() ?
additional_vma_space() ?

Maybe David would like:
remedy_vma_space() which would be !poison_vma_space().. that's pretty
clear.. :)

Cheers,
Liam


