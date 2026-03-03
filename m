Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD55CEC047E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5C56B00CD; Tue,  3 Mar 2026 04:46:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BD1F6B00CE; Tue,  3 Mar 2026 04:46:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0749B6B00CF; Tue,  3 Mar 2026 04:46:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E76946B00CD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:46:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89BE71403C7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:46:00 +0000 (UTC)
X-FDA: 84504270480.26.CA746C4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 32CC54000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:45:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Vlr1NdUt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Katbsooe;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772531157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dw4sy20/Y4L5H92phkW1TSLwBA+EjDxCuw+nQOuJryY=;
	b=m/3NOVcbsHLBiOqxNyKxaJNgmG+KJtB1TXUCJfRqxQmC26vygyszG6LUoO80NTqIjG6vcf
	ftjJ0UFrcYstiXgSESNxHmIPmILCUIzHZVHBpv9//JPQ87XjsmXqT+PlcZathJ+88Oko4e
	g6N0wFDi7GEi328boDLrdqDEpACdy2c=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Vlr1NdUt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Katbsooe;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772531157; a=rsa-sha256;
	cv=pass;
	b=DKLnBxl6Sno6ykS+0EiA8pcjsmVARLONJhJEWANgjQEZAL3vOpnPy1qlbFjBLi9LUHTbOQ
	6H+0WXeSkFtfJOco7kHZQdkwXbsZG70USRihc3fMElGUHKKAeNKTjTQ1A0pMyts1H68Vrf
	ujuuO0eEPmHTzk4qU9Hck+o/iggji08=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6239ajg04184483;
	Tue, 3 Mar 2026 09:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dw4sy20/Y4L5H92phk
	W1TSLwBA+EjDxCuw+nQOuJryY=; b=Vlr1NdUtcdeueFkle+QKdYBECRxCc2Dqr5
	/El1XOx6Gua++CASXn4gJtAnX3fIrH7OqyWdCesYRPgTqyEBmJuNrXcNNzQSPuU3
	pwGoMlKJ0I8ecITL/lNkFrPkHqBkbu0bckdYjrjW+fgg8ujA4rsSo09fwOgXd1Xo
	cnzB9t+L6oaTFoHUICCinZsBz4un1kEW2mjKvVm+WlXbAyfBnZXbO0s5K9MzG9fs
	+hVA1njEfIrEAGO7nAENBVKCwl/mfBOYwMqbHwz4auduVFx3jpGoHWmwgcdT9A6n
	22q9JYcbpqhcv0a6yhPEBY7pj7k1cgbKoYwVv7ZCQzWPBVWuXang==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnw5m80tg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 09:45:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6239ZhWs023120;
	Tue, 3 Mar 2026 09:45:41 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012059.outbound.protection.outlook.com [40.107.200.59])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpteda3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 09:45:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=olByHYlBlWB1tHCyJZ9CM1liVivk37W7VBmJMo0On+XaDbYqh5D6W3t08XaAnukNZlxndLkb3deGqk3QdcwCC1Atxd9Xjk60/wXJxjyA15B6FcjRHt54B0iNBHDh7ubrIiLI/pzaqe15Gh4RhD8llwNxy5bKfoYePVxLVsVr8jDoPqJHQ5EozBDues7hva5j6Z0otmjbKTCkTMtDDnIhNTsa6Q9hRXR1GHCglVSiJM08h6f3ZLNWVuo4BXy1L7Pxa523D50xIGtfyhsFoydDXLM2PyzmXOjaeS5KazvNFW60h7KS3N/JWSoWwaFeenHfkrspFFXKQ3yn2YA015bLlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dw4sy20/Y4L5H92phkW1TSLwBA+EjDxCuw+nQOuJryY=;
 b=agER7lRtrNc9eqbunJAwFo2HRdOVCZaSVDFehxLbbZsILTXVAkloZQ1V/yACLlSibI8km8SU9t3rGOWtvYJLzHQQlQc06bzY+jZHxaFXUCxiKuVZnh9k+vbkjHOK0y51HCrchaULHlQoMtXYlgwHuLKookhUFy48QqHjgWwNOBOWDBLobjITsy6msTfOkaA7TCvG1833GBT6k3QU4o/d3pVcwBNSxd2LlQpOz2k6d49LWUyvnEQVsSlvIUErVnX43TPv5RlV5gPOOD6FuBm2dYX8sxwBvGP/hfpp+gLklL9KntgjgiS0idO3vMT419XgfnIFttlS26LneuUK+qrMng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dw4sy20/Y4L5H92phkW1TSLwBA+EjDxCuw+nQOuJryY=;
 b=KatbsooeeMOf4bm9wGX1PXfqNFDuHWotx8kPXl8i4288yJdfp8pP5Lfl103HYeuyF33AliybeIrbYcWnWNa6dciDvmYa6PuTvujoQaK+8UHqHrVXIOlnlfvG86LsLwrhqpwt5n4esK6p8BFWj3KV2iZeZasfZHCYtmGsJM7wFJk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5548.namprd10.prod.outlook.com (2603:10b6:510:db::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 09:45:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Tue, 3 Mar 2026
 09:45:38 +0000
Date: Tue, 3 Mar 2026 09:45:35 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Bing Jiao <bingjiao@google.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mhocko@kernel.org, shakeel.butt@linux.dev, weixugc@google.com,
        yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v2] mm/vmscan: fix unintended mtc->nmask mutation in
 alloc_demote_folio()
Message-ID: <8ec4b2a5-61d1-47d4-b26a-e058d3708154@lucifer.local>
References: <20260302070351.3465439-1-bingjiao@google.com>
 <20260303052519.109244-1-bingjiao@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303052519.109244-1-bingjiao@google.com>
X-ClientProxiedBy: LO2P265CA0413.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5548:EE_
X-MS-Office365-Filtering-Correlation-Id: aebab64a-d7f0-4b12-3695-08de7909a026
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	P+ufigBeTauCCCnjfx8BZUGlf0SMO/4cNhviD02qSQGdKm/DUSO1s8C8ksCEbi2QsR42dimsU0sh/EzEQe/ci8Qrf4h1dHDs8bn54pXaVfs9jxNaCTJaxlukHjwlEVVqPNg4c+PGsREUwAy5hP5H3xWXaaee7ZnkhV9VYS3SkE6n+YuejZObjbQCcghKrVfKddqy/Rzci3CQySjDyWq+tdSxvbcqwKzdeeLsqs4GClALiSNDJyAGt3tOKnzGMEp+PBzZtk8G9riYYwxmp+Dbs7KTnXdzjcajz50kZy2sRXcIJK5gBD6VgYl3wo3tKuYMjYyZtSqyzMEaqc5SR0Y6JtI2kktlx4Q3ovPB7yFsoulQJxT9tFNyCl3NYTtKqto7FhdscU8ifINAhEeCvsXy9Ku8ae2XoxAh540hzriJnta6MutTZhXZimNg1TvZzU/4wLIU3l4AhWs1VpcLbrrea2QZN3LPa/Xphy+cD2VSDSbUqTYPZ1yT8/cjnJMFdp/sKvQafqY2XY9fLl+/6km0jxeeVu3EGMXezdjxk5iNyOYjcmPt+C6XhR0ZK0jBVO8cR5hvHW2DkX7z06Bhlu8Q9z/CItciD1EH34H34Sw29TvDtUyb6msEzyZIS6PSvcSPv8DdYduLIGzAKpMvXGsTM0XXvDkpnWEERWG0Um/nDxV6sC3UK1mfkjk3ulbfRbv3lfSnheJLHZtaAx+QDB3twjjRHpFfPB5QwqUcuLPWysM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A9WbqdE1ZHN/5hDjqwCFsTzhNMNIH29WElGmrJRcjYLAi5L/1SoVq+pGLmN/?=
 =?us-ascii?Q?mi40rwE1ft5g+eRIRA30R3IJtcHy0jY0SsOY+r6qK70u5PXve0h3EJOPDy6N?=
 =?us-ascii?Q?iuzJXFrC3c2EaNlS02aRJ1LgwSjtzsS7QFSQYDeRC8Q+yrbroiUeRrpRe8Bs?=
 =?us-ascii?Q?2UW84lPlonrzFxWbl/qJO6h1pHSLgr7xexHL3+KsxWRmkcfM9AjhxE3tY878?=
 =?us-ascii?Q?WeCLdDZggo5/C6S76MfRBXAXDBiInWdKG8Rplu1gQuXua7uRyjxMiBFFEiFw?=
 =?us-ascii?Q?h0eLcUASj8nm1f1ZWCcg3agxHyUin9f6aLWCIw8D0GFs3vzkR3LQMvGtdjU6?=
 =?us-ascii?Q?kHfWQkkEQ9B30wcAy23Cf3kyEyLYFrZXvODDjRqivl64lujglnuPE7Vc+j6N?=
 =?us-ascii?Q?ad+ZXBJmOPzhCsjOVD3bjEITKjBc1FM7pDXNRqs8aF8tZsPsbA3RZbA4EqWM?=
 =?us-ascii?Q?8JRcfmw86y4Vr+bYJNderSrIlyHj+2fpuFtHreyyX3VZgJTpQ+j0RwMlZgzN?=
 =?us-ascii?Q?9c9d4+jzCO+fnLHB110ZjdqGWlrRxapF26bpYQySMDulnqZHBT0ZN9xuUYxs?=
 =?us-ascii?Q?AzaE7OPgA+VpVl+KGJuSxIP9vOKHKR/2QuhmrCvBYe6LlzxXueCvv02OS129?=
 =?us-ascii?Q?pg9enp0Z5SqoVrugTE//ERWzxqxNe2rxG+qyKjXTPuLxBB8fl26poYaXQB+8?=
 =?us-ascii?Q?HZxDj0+hrq2NRaaxmyxT3KtRrDSOlHJ27riMXkT+Gg9yTytQaVu6kuvmp0Bc?=
 =?us-ascii?Q?ljzajvfM+2iB4tiQ6D4oq0YRmDM4gNgEtFCqahQTkMG0KLBZjogu6hjbL/o3?=
 =?us-ascii?Q?OZNMqFqO2HgbxQFuLhCibg8UTdeHpPDmbKmVBJttHfh/cEXVkCvIUzifmyuc?=
 =?us-ascii?Q?HGdiKWp0ByDJoU+KrBhepsw8aE8T7vennd9rgBs02Mk8OvBhTMbuA6aBmCiS?=
 =?us-ascii?Q?8oKLVe9F3p+lFoURxDTC+VXXEnC60i4Y3yzGpKLbmXtkxDTBYb+X0WNMHnPO?=
 =?us-ascii?Q?X0fVG7QPrjOw5EdFBdGMk/cfU69D1kGlzyLJFyKiMkJsrpJKEZgdD0A0B84p?=
 =?us-ascii?Q?IZ7qxDcV1zNz+VFRBBAvFQGU7evuZWmFf88Wo6y2vEprYDh/W875XtXKmKMS?=
 =?us-ascii?Q?D0KADAwGRH1LxQzCCPJ4ds/AdktM4TYwOvlq58dZ/kgJFOCEPawYzHosl8bd?=
 =?us-ascii?Q?+K7KLsxDw7BT1JES2C1cWhEtLPYDH68AT08IHyXVF/qrH0ncBydnzhT+bLQo?=
 =?us-ascii?Q?9aE5sIrWsyFGbphV7vhZI03GxGDvSZu5UmSjVDjJ7YN7TrLcsDKBMJoLcfnX?=
 =?us-ascii?Q?op6b+GdPDdXyduyArDQE60fDuKV3v+LpdSnzp0zRXHg9E7b3U3RjsJJ9GRsC?=
 =?us-ascii?Q?zezRMMTzRR3xdIoyf6YB/jouSoHIHydtWtdrZwiyP3aX17Xfv8g34YSyUG+W?=
 =?us-ascii?Q?FRBXIzx17B+pn33WWEEYgdmEx1vhohST/b8Mf5q0yK8u2DmDqHDgzEbhA/GR?=
 =?us-ascii?Q?a5Rxmr26be90SlPGqwBabH9F3949dPr1+xywsuroYnU7XeuwTCuxyEwv9qgl?=
 =?us-ascii?Q?J7mx0B670TGld4lPvNtfpIS1NQW1PFdzDkaxuTGS4eFUJf/Ev86iphXtekSx?=
 =?us-ascii?Q?m0VQ6xGWevE0hupPwbbU+0ql95TJZ52a9ygbkByAYpIBZmvCmoYZ4PZdooAI?=
 =?us-ascii?Q?TD8HNfP0VTj37YQ8CSmwvOOncpHURLHG+YW63rg/Ml252mTE+YoIT7TMeAzZ?=
 =?us-ascii?Q?7FCBCiEBCg2mMwh9BqCgy5dQwZs2Ous=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Hck8rHB6wj/TaneLhl/AniL5GtdcUGlAZs2fCKtChaL21RHZEh+z5/wf8jGDiKXr30rgpjsLeP0fQgcufCEFXS306uVB20heQGFhiVv5zKiZ7kaO1eF3OeD+oJlAWZdQtsOpdqWtDYBilGElrrniryERCo3RvdEiCTtmd6gKgCXJT/rasnVGze2Bk2Gr3ryxD1AuyqV/ulu79pa8uU3wJqtEcCefNtIKde+d9nJARKWTReqPF20ZfRbBNs5h8/vjGdzTCPjH6D2uT4Pommh/CnkNZHrvO96qYLotmrdxvBLDicHFPvfj9nXOgY5A26Xh3m81Z38t4BRpHCx7Z9d8GNSyunp0kBl4JHjTGq92CZlH1+sJClhJLDRTscveF/PAoyhJ7QDgLQTPIp32VDc7X4iQrbTUF1oH88nzsrGQ5jI7hkmWbs8JQ/dZumibU9ENJOzo0fYpvLxuVEqPByRFbEhNwV36Rd86xuSXfVY2v9kduFWkrOaKhVbwLP5n/8rSvj4RhhY4yPsvdx7Lm21jHdtzYok8L2jD4ilyfxz78/ifmq1ZbP+3zpwj9KMkKABJhkD9bKBpdPBuYKOlW5NrtARpCHkm/iu2Iqy9vU8zULw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aebab64a-d7f0-4b12-3695-08de7909a026
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 09:45:38.2745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hpEu0VgMoiPgcASR4l9mE+1CxBfsP98yvZA/c3o6K+CfK50FauX4OrYT1Gcc5DPnTa1YBEsELeG3DxtM2oMs/J/+5XV7cQnO2WOEztKE8tw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5548
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030073
X-Proofpoint-GUID: 5uF-oV6APkYt7NmtXqPMnhUD6U9u2PIW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3MyBTYWx0ZWRfX5Ul2sFaqNY4z
 oLI+wzVCBK/16EZKjVJSbI9JS+O3S9SsykMYYlyCXoZWcyNFAz610kG7/+OXGAUbyRByc2w/Sei
 OSBfLxjIphJY3YFdESdTU61oA8zW7NJ5PdTPzIVLfB6DFNBlhdQ9Uvq4rSlloQueR/xsqLvfcAG
 DIeb5gZNEQUS5BiNooAJ/CLBgN2Kukh9AN1Dnh338yZjNTb9iQfeYFk59Uh2ClvXKlz9DxWnxkx
 xllpOe7HscH4s+LHm7pCkKi/GrJ6FgT0zRkWvgQ6VeL+CUQCrXoiJy60MaOysh/3iNQp/2Zy2qD
 YIAs0sRnz33SqljAy8k2csGrkU+CF99UmOSJ89GpAI6Z5E51MIa3CbzowCekH1VOdzr8ZbKbZAa
 ojFl6DGuktnLhgHy9pp4Uqgp9bLEKM0c97ybwOcbdeqEGrQr4j9plzQu1UgC28p9vwskn8G2C73
 EJI80JJmecRgptqFwfn5r9d0a+Xpqv2C54aibXpA=
X-Authority-Analysis: v=2.4 cv=TNlIilla c=1 sm=1 tr=0 ts=69a6adc5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=HR6j9pNFQoEbHVzbSHwA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12262
X-Proofpoint-ORIG-GUID: 5uF-oV6APkYt7NmtXqPMnhUD6U9u2PIW
X-Rspam-User: 
X-Rspamd-Queue-Id: 32CC54000B
X-Rspamd-Server: rspam08
X-Stat-Signature: u989i4c7o51ce51kfjn3qehkynz5duwb
X-HE-Tag: 1772531157-418483
X-HE-Meta: U2FsdGVkX19g+jpjBzXN0ogHOrwKOtReBTjJhWcEcV+0c6U8Z4qDhfi18iTtJ2FD++wc4+4hR6Gjf0f41QabirH0z5bEBWu1rhDzFE7S9UGQiTjzP8CHFVNbkPJkLeWvxgE1OUW71XtXUh6uAuDUOxV2+xnlzhjtcY2/QUAZCYkkVZHhHxi+s/UP/C29TIF9ThFqzULCTatHuJ0sbh/a8TLQXAYfVNOCyiQC3nZEecghn+qcP12/77l0wXULtmn0mf7alRoebLoNuJJLWtNOw0t/6GZcl+737Vi7POF1sWhUGO5BGU2My23z3kaWeRAZ5N8gLmeyv6Tg6u7kGLwT9mvP395rhGPwGSjvUwfonaHc3xzGbEIZx8zQHhz5c5gOqTjrOzxGBKuu+47ExtYm+MhdNPD7Gf4WM88RagjEGQSnVMwZ4c+Sb1LWGSSmXw+M8rVXo6oivlWSYthdSaj8KvO9TEkZsgwQpfJp53l/7BfRH5OGfKPONC/AjZrcBGUAJsdR56XdmbM+rOTDeFy5WvjMdqHd6q5U1V5fzUOHc8MFh++2pNBI+WCBtvc/eW/mVgmhVful+lvZBEVWoLclwPmxlSgwjpc6xrjYgEC/lJyjB/wp7kyw9AteXdToD2JdyKdsL0HSKhmRHz2fyI4dEnlFCvQN6rAQYIXiNW/nim2CJECn3z7igUksTLCJlS6D1CFaiYCmaRARjMbs5phWdCxi9Zi1DvnC7sedbOtsgEY1dbnJbP20YeqLkyWln8/5t2vFBJPEtgl624dFKWE3UMBdrQv7ExiX1U16/ps5eWDhXeW4KqVd1HBmlU5lJjv9SHsTp4jzEaWRxNyekphy232JSZ5CgUIa0SGXA2dWRtOLQ3Yq4xFlemYu4T0/2Avepl6cvaDoKRczjKloG1MFhxsAJBU5j7LjWjHBIuNJobV04LCZx2F/mZwf2ZE/maNVsNN2RnvKOGifcZurfei
 0MNR9Aak
 iX8LR5zoCIN6sHWl/QtHHttUCPkVSqhjmixVvOJ9lEiDjSkR8lm7cgmAN3w6XUFPboHXFvDuYHFTp+Z9ZYnLjb6O2chmLFjlm4qzADqN6RphxsX08noOOJqF/BOstYzg7YlnnyRdAGjawp2ovzZlPOT0fuY2xbMGEb50HeM2afHJzTr++3sNN8oYss40imBFRfdJdY6k1a32IVRfZ3gRxzdLNXuYbN/kqwVoD1a5IQB23GknZoUd55cH9eKcs4nXs9+c3B+gA3pyaD7onFbcPePgvpsN8JpIntj/s0KwM7+Ws5BczmVYBGYvNf//CBGy798MviXZaGAsgVPx7beDt6kvN3udoVK5kxOfSm4NknbbKrP0/bQJTWzVkPd36SUOoqBEVSGpIDLbel3pEkj0p8KIULYXQCknEN+auLZp1K6j+PKFKjPiHn2hyF4JK2w99wp8nqKJp5BcA/sJBbIvQgjcbaoG+MP+xlVtEfJ04+BBRSb73PiKzsLuJgP50TZmCH8pH2xIx4tqlO4ddDyieBzm5YnXbpobRScwmuw3Pzvri96N2G4LCt+fLhaoL0obYLmwxH+G/oRV+mYAXUrWLUzcTdoWU0sdxLhYrsKlVnn7+bREg9GsBZRUUCqxyM4E+pAPePsyqRxvZrUvq99ai6MWQqKl81/2pne/khJu3FmbuWWUndsKNmGjyruiZiZMu2y+6gNlWosK3DYlZ6FQcyqQ3Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 05:25:17AM +0000, Bing Jiao wrote:
> In alloc_demote_folio(), mtc->nmask is set to NULL for the first
> allocation. If that succeeds, it returns without restoring mtc->nmask
> to allowed_mask. For subsequent allocations from the migrate_pages()
> batch, mtc->nmask will be NULL. If the target node then becomes full,
> the fallback allocation will use nmask = NULL, allocating from any
> node allowed by the task cpuset, which for kswapd is all nodes.
>
> To address this issue, use a local copy of the mtc structure with
> nmask = NULL for the first allocation attempt specifically, ensuring
> the original mtc remains unmodified.
>
> Fixes: 320080272892 ("mm/demotion: demote pages according to allocation fallback order")
> Signed-off-by: Bing Jiao <bingjiao@google.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/vmscan.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index cbffc0a27824..c4e0ce737e03 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -966,13 +966,11 @@ static void folio_check_dirty_writeback(struct folio *folio,
>  static struct folio *alloc_demote_folio(struct folio *src,
>  		unsigned long private)
>  {
> +	struct migration_target_control *mtc, target_nid_mtc;
>  	struct folio *dst;
> -	nodemask_t *allowed_mask;
> -	struct migration_target_control *mtc;
>
>  	mtc = (struct migration_target_control *)private;
>
> -	allowed_mask = mtc->nmask;
>  	/*
>  	 * make sure we allocate from the target node first also trying to
>  	 * demote or reclaim pages from the target node via kswapd if we are
> @@ -982,15 +980,13 @@ static struct folio *alloc_demote_folio(struct folio *src,
>  	 * a demotion of cold pages from the target memtier. This can result
>  	 * in the kernel placing hot pages in slower(lower) memory tiers.
>  	 */
> -	mtc->nmask = NULL;
> -	mtc->gfp_mask |= __GFP_THISNODE;
> -	dst = alloc_migration_target(src, (unsigned long)mtc);
> +	target_nid_mtc = *mtc;
> +	target_nid_mtc.nmask = NULL;
> +	target_nid_mtc.gfp_mask |= __GFP_THISNODE;
> +	dst = alloc_migration_target(src, (unsigned long)&target_nid_mtc);
>  	if (dst)
>  		return dst;
>
> -	mtc->gfp_mask &= ~__GFP_THISNODE;
> -	mtc->nmask = allowed_mask;
> -
>  	return alloc_migration_target(src, (unsigned long)mtc);
>  }
>
> --
> 2.53.0.473.g4a7958ca14-goog
>

