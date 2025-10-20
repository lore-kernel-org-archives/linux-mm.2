Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4315ACCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50C38E001C; Mon, 20 Oct 2025 10:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28B78E0002; Mon, 20 Oct 2025 10:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EFED8E001C; Mon, 20 Oct 2025 10:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4CF8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:11:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44B814C108
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:11:18 +0000 (UTC)
X-FDA: 84018679836.22.3063103
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id C2EEDC0010
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:11:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iKr+BOoQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nzvWIKoR;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760969475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJBgnl6zTJHArKDU/G+nKNjFJpJqz2HkfHS3OAPwMdM=;
	b=c0PnJ1J2Wj80NnNQNpXfjIKBxtvyo4chdO9gPnJnlBz2t+klVkYeAaymfp0XOMSoat3sG5
	Di5p9kSrTBVeGwIehAw7Ex8mQkIujZM6xt1rLaifMFKoNHtWVx535RGnxmEz6Z+Q76/kzI
	lQWoo/Wa5lKt6RQLdfzmQu7gx0ERNrw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760969475; a=rsa-sha256;
	cv=pass;
	b=Mg7pz0qwQdnnS87VtLqQKx38+UMBHiKE8VGntq35jKrGbzESQXVvw0J1Q/fY0xPL+WmMX7
	zN6HPsqurZr9JDVyK3dDJTENeleViOLxCzpPs8qOHR30TlbXabQMqGnWP/MIU0BBncPd94
	BzqeUNhc/fJ682aHx6ykwUXFY/IP6yY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iKr+BOoQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nzvWIKoR;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SIj6001407;
	Mon, 20 Oct 2025 14:11:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IJBgnl6zTJHArKDU/G+nKNjFJpJqz2HkfHS3OAPwMdM=; b=
	iKr+BOoQpkn3n+P4JuaILwskhU4898jSU7Awt4xNloh7r/xi5yLl5LMLAaW9PHHs
	ftyklsVcTLlVJNAPQJvqU4Z8WT817puZHbC03C5EtrTizJ0qFaVY4/yuImyn+8wZ
	VsNCw4Vf2CGggPTj0+39KanOTaVu+B9FddLbUnBfI+rNqfK4Ffot6TyK//2jvP1V
	F0jt+yOIIIlVLiEBiGH7oJkfDVRkr3eFezp1LHNOvzzt6fQFhDjtJXurI0+BExdZ
	8hIr0RBm02d1dnaKmCVwR5DlfO2GynxdjBMX4fp+hZVtl1EHGpROD8Yw2p/GGv7o
	7qcXr1GGCM6xLYd7IIZZsw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3072b4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 14:11:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KD53tv032277;
	Mon, 20 Oct 2025 14:11:09 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012038.outbound.protection.outlook.com [40.107.200.38])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbqvw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 14:11:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mWAJqd5mB9htVt1hGncAdwvW5Anu3Crc7jD1kkUB7dyOzKvDDhyUxF/pSZd22vrVCSjtRRNIsCFt6whzAXXBuv1Nbg6zL+hYV9sn+38UlEdqUAibXF9FF+BmW99aSDZxm1h/M7GZ3mDfsFKrUv7Rml5hkd6jIQ9e7YOEOqvA1mIZXGbj0Z/QYlBM7RVAyph7qlh3Ead9rtLyx6BW1Jx5Q18PtKiczmanb56Xz/ukxjdbPnKRBb3OQPXhm5HaZ1ZGE3vZf9KHw6Mb2IzbRvxStBTopAR0KcuQVToZ5N6izOmDeqUDeRp0h3c7pHrezb9ZOEoSrdW2SvI3IL5EH42yoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJBgnl6zTJHArKDU/G+nKNjFJpJqz2HkfHS3OAPwMdM=;
 b=JuaBxUBbukmrsPXTXM9Kp49fY7BBeKdUhZbwiZIlLICRKEIScfaNnDEjxccX5S+Z5j+PjI68eQENfdpfEJxavl51XkWMo7adzaP7+qYHIdQmiqutzyIzRv1nqyoNQow0ozRkOqCzXv7UoDtLs0/0fIJ62QMa9PwEYKdSCPhi/wvxTxeHdF7PcwkQ6NasdqOmqbxBw3P/JXafPpI36qrvQL+ZOW3th5XBCMlYyMa/ru2ifd/AdWqP3XQCrPFqiPOn0xRC2YhJGIAYcSo/hBuAyQpg4gAAcA5/0BKtpQzLMn4m24ptLX2s8aUlHnD0TWDQ6wHNLhxHDXOM4U7r05NQwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJBgnl6zTJHArKDU/G+nKNjFJpJqz2HkfHS3OAPwMdM=;
 b=nzvWIKoRfPj29tpxv7tJecTx0SHbaJ/0zqaaeryCxKvoOn355Dfb7Sj8LoDUTu4jWHtmW3Ol2Qg4ApLeVcwF7eICdUwx+5suDR65Ygb4yWp8gyPi4a4W28gkpx6tmalgY0xXWpFjhjlITWTLS8iz6dZUL3zSpdLRLB74ioOL0PY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW6PR10MB7637.namprd10.prod.outlook.com (2603:10b6:303:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 14:11:04 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 14:11:04 +0000
Date: Mon, 20 Oct 2025 23:10:58 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH V1 1/2] MAINTAINERS: add include/linux/pgalloc.h to MM
 CORE section
Message-ID: <aPZC8qhvSUJDZJKY@hyeyoo>
References: <20251019072509.9488-2-harry.yoo@oracle.com>
 <20251019220737.1431-1-sj@kernel.org>
 <aPXoJWM8oC-P1a0q@hyeyoo>
 <ee54f8e1-0b1c-4db6-9773-7b30d18c0515@lucifer.local>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ee54f8e1-0b1c-4db6-9773-7b30d18c0515@lucifer.local>
X-ClientProxiedBy: SE2P216CA0019.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:114::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW6PR10MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: 6de72114-be7e-4ebf-fde1-08de0fe2814a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V044OEpxK0NmSHpLalpZU1crdlZHRW1jbDJNM0hkSHpHYWVWSlhVaUZkOWpp?=
 =?utf-8?B?SmRWa2hCcjQzUTc5WXhFQkU4Uk9VVTFQTFo5RDNISGRXZU9WZjZRWjF1SjMx?=
 =?utf-8?B?elo2UG1kcm9iRUpQMy9La1BrM052Z0RZV1RjTFZiNzRHd3JlSWxja2Z6a2Nk?=
 =?utf-8?B?WXJoSmRIaXN4am5Ec1ptWHExbW04b29BMXhpTlB3dzUyUzh0d3lQS2pUMnRQ?=
 =?utf-8?B?Vk5CbXordGY4dDJmOEFTdzJLWU9yREhxeER4a1B4Mk0xd0xnZ0pEeGpBMElx?=
 =?utf-8?B?Nk5Yd2w0dXNrOE9BUjFsZ2tzMXBVclBUeXNWVTAvUlBaZHIzM2kvQVMxcDNh?=
 =?utf-8?B?V1QzdHZvdjhXTGJUUEZldXdydDA5WWRmclQ4REIxMmErS1ExcGY4bFlkK2xK?=
 =?utf-8?B?UmRvSEhzWW9vT2Z5cE5ybGZCZlBkcXI0Z0hUTU9GeFpGTmVLa2x0R2NlL3Rq?=
 =?utf-8?B?VUhFRHlHM2tLTit3M2c2UUZZbm9HY2ZqejFxRDZMZ2ZjNnlubkVRYTE2UzRh?=
 =?utf-8?B?MWZabzlRMk5ZVUQ5ekNBT3owK0FZeXVhalVjOTJZbDdvcWt3bFhSajlzYmpv?=
 =?utf-8?B?WFRoQjNCZXFlQmQ2QmFBYXNsK2lMSklvMzk5dEIwcWZXSGlmaXMyQTk4cGow?=
 =?utf-8?B?ZTF3TlhjRXR1SkE3SHJDTTZhZHNkTy9PQ1RuQ0EzQkNOc3I2dFp4TndaOTBu?=
 =?utf-8?B?REJoYmQ2NU55cXRUNXBoSEd6NEpxczVtZ1BtbmMzNVhPSnBPOTZGSmo5KzRU?=
 =?utf-8?B?aXJmYjA4eDUvdUhpQmhYbm9wS1VQOWozWlVZRTdMYUZjMUF3dXU4ZnFBbEhu?=
 =?utf-8?B?V3cwY2tNY1kza2ZmejZ4aUIwTE42d2F5cG1salFGMVEzV1B1YTVqalQxOUJD?=
 =?utf-8?B?S2t2UVd3QVRhMktRbENaZ21ramFNNyswMkhrUkZ3QzJlY2gwMEpGOGJMbUgv?=
 =?utf-8?B?RCtGYWNjbnlxdkw1Wk43UzNlSkR3VnQ2RXhXRHZyT0ttY29CRzNJa05BTVIx?=
 =?utf-8?B?dVJIN1g5aG9OekwwS1pPOTVYd1QrS3ZtUHVsNEdkeFFsaFJRREhQS0NJcWJp?=
 =?utf-8?B?emhoZFhnNHd4WUxFTE1UTElDRjh4Z1JhWUFDM0NORVpSRklxelZzTjJTTG5t?=
 =?utf-8?B?RXZBclhoWDlFM1d3QlNBemNsMUNJeUJHTzhWUGxVenYzNnIvbjJ4dXpQMk5M?=
 =?utf-8?B?YXNLZ2ZVdk0vbURuTUEwVHpWaHZxRDg2UkpoZy9kLzVEcnkrcWdLbkEwQndr?=
 =?utf-8?B?WkthR1JRY3ZscFNxM2UveU5SN2dxMFJtRWpHMmtPajdNa3R6RUFWdFpYTGwy?=
 =?utf-8?B?cndLZzIxaU5MYlBwbGFaaVZRd2FZNE0vM2lTS2s1anJwWm0vNnlrMEZ2NENh?=
 =?utf-8?B?U0RpRThXOVhWQlNBVi85dVgwMytueTVxOFNQSHB5R1FJRmxLamR6KzFsWmdt?=
 =?utf-8?B?czRlQTc4cVhDbFNuNHpwMnNhbmpFQmF5SkUvNFB0RklqSGhoalZDbGpYTzdR?=
 =?utf-8?B?OTVPcmIzbVRGdy9TdW5CUlc1NEhUVllTZlVFRXpCUjFsTkVSM29Nc0ZBd0Fn?=
 =?utf-8?B?OE1nZVBvMWNYRGI3TklnSlZFeWh6ZnZrWlh3TUJFSE1LM3c3VGtjVEF6QXJP?=
 =?utf-8?B?clBZV1Z1SlE4MGdMTUoySFdqN1NSN2hRLzdDVHJUdE9DS3NtYkpSdytEb1hj?=
 =?utf-8?B?SUdsellFdmNuTkJhb0EvcXQvQzdZSWRSUW1aeWttOG9waWdYaDBnZURJcjF3?=
 =?utf-8?B?VVlIQ3JWV29LOXpvS1kvbi94b2YvNjlNV3ArQmJML1lHYllkTVJwdmtBbGM5?=
 =?utf-8?B?OUZXQndWbEdPbFpBdUozb0dHZGJwNWR3THVUNkZlOGxQWXYxWTBDdXMzK29K?=
 =?utf-8?B?TGdVdEE4amxqZHlpS1VoK0krOTQwNmtzek9lUE5VUU04enc4dnFrQTBSWDJa?=
 =?utf-8?Q?T5+NhGmTRBSUl6nO9jL2c0Cqmjk8t9C+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1JuOStvanVqaUc5ZDMxT2xia1BSMXV6eE5HOEV2OVZSekFCN2N6OWllbGNu?=
 =?utf-8?B?K2pkTXdPd0UvZ1p6ZTJ0Vm5zb0t5Qm1tajZlOU4xU1FjTXZIVUxIU3ZRM1BH?=
 =?utf-8?B?ckozTjEvZjNHRWhqSnN5Yk1NTzBGenhPeHhRWVh4NUFQRzJFaTRZdXkxdCti?=
 =?utf-8?B?SnJXUUppRGovaTVYaWVTK01lc1FDNzA1N2pxVUluTTk2TTBaT1FkelNjOFAx?=
 =?utf-8?B?VUIvcXZpTk9icEVKdXZZRnU5R2VHWTVwYVg4K0JXOE1oY2t0K3MxeE1IWUZp?=
 =?utf-8?B?bmtUaDloOTVIZmQ5Tmtid2ozR0pzU3AwRHVFdmNDOUxmSXdxUmx5Yjg2WUtR?=
 =?utf-8?B?V1RubE5Uemh1U0tuMHhpUkRrTmg2Zkh0NFp1YWVSQmUzcjB3cUg1NEJ6NitT?=
 =?utf-8?B?ZU9sT0k3SUhpVVpzVDhTTWtHakZ4NXRZc2hCMXZYUnJkSEhQMGZyb05MRGtj?=
 =?utf-8?B?VWR5NFRhWklManhEN1Y0MmZsVFJEODVIOEJraGpRTlB5WVo2aWVsbHFHNnlK?=
 =?utf-8?B?SHUyanBKYWV1RDA2a05aNnV0QlBsZ3B0SnFxZEVtZCtMYXZ3TEliemo0S2xY?=
 =?utf-8?B?aytnYy91Yi9VMWt5bjB0aDQyUDhiZjhkYnVqcnl6YWx0V1o0VUxrYkdVMVZZ?=
 =?utf-8?B?akxMZTVJZDljNkNyWHlaYVR5RnFoUXlOQWwrbjJOZmJITzdMVVdHWnlubkZr?=
 =?utf-8?B?R1Z2aC9vM2lqQmN0Ym9VY0V2UUZQcEFRTkNxdkVUOWhkdndmeW1QSW9IaHN0?=
 =?utf-8?B?cUVIcGFOaTFmV0NUdmROaEN1UG1lK1FYVEtpbDZlSThlT0F5YVlrYWEzVlVh?=
 =?utf-8?B?OUM2NXVwUjluNHhsYjZScXErOFhhczBobmtpUmxHenZjelFvajJzemtmUU0x?=
 =?utf-8?B?cG1ZazJtaWppc01rSUFSMDRxZ0xvQVBCL3grWUFtUlhuTG9nWXM5VUhZQ2hJ?=
 =?utf-8?B?RnlWTWsrU3ZUU3lSYzlMSnJHakhLRzhBQTQ5VnlOcEJxODEzc2ZOeFdaSUkx?=
 =?utf-8?B?NU9uRTQ0bTBCRTc4ekxDQTVTNkJlMGFKUUN6RHlhMG9SZDJJdFFGT2ZLRDhn?=
 =?utf-8?B?UkJEN1NwcTJzdStTb0tmaldTejlHQ1hyK3BxZEZBQ3BWNzhkWGxDS2l2VHdK?=
 =?utf-8?B?Umt5NWlScFg1bkhLd2R5ZDFYWk05OTVnczZuQVZKSUpHeDVSRlhJMi9MTGNC?=
 =?utf-8?B?YlhUOU5OWEZXaFRxaXlhVWVXTWoycWdXOWhKMWIydFRzMHR1RGJVNlZzUTc3?=
 =?utf-8?B?UDdsL0lGKzc4Vyt3c2dRYWFXQVp6YUx1UXRsRlFCamlDWmZZamRGV1FRcFoy?=
 =?utf-8?B?UU1zTzNRSHFaczBCYU96M3EwR2NRVm42NGJ5a1NoU2orUm14ZHhCNmlKZWlX?=
 =?utf-8?B?NVZMcldNdWswSmJLeDNsanM3Z3JMYkpSWERXVXV6bC9GQjZ1b3BOODl6N3pC?=
 =?utf-8?B?YU5hWWh6cHdsRlhJb29WRk9hczl2K3NpOGt0UjJGRy95QmsweU5xZGtxK0Vv?=
 =?utf-8?B?NGk2U0NxL213L0NYTnJWOUFpakhuVGJOMklYbWRLNjNwK1JPWHJyOWtCMDQw?=
 =?utf-8?B?eVZsb3ZTT245ejIvTzR4M1VlM1hpbU1rUjRnam5tVnRtUnp1bUQ1NjJFOFNt?=
 =?utf-8?B?QnBTSTJLd3RyOG1wWWR2WVJWQjlDR21BVE0rWCtKVjAxTGpXR25OQUp0V3ZI?=
 =?utf-8?B?eVJRMFFiVnQ2V0Y1VnBqSkJGbDJ3RU9aR1loem5HdW9URmVyQlpoTWIwQWNS?=
 =?utf-8?B?L04xUWpnb2RNd0lBQmRRRTg2ZjQ3dHJqd3JKK0EzRlZHS3BmeFhzd0hiTkpU?=
 =?utf-8?B?RzhCZWMxNkgzZDF5RjdoclZqeGpRb2NIaHJ2L3FPOTYyRm1vblVYdHdpZnlF?=
 =?utf-8?B?eStkQlM0Q2IyTFRKa01yYU9sSzc4Wnh2L1U2REJrdXBsZzF2TWh2SWxZbll3?=
 =?utf-8?B?VWFOUk5XUEdHaXZZNDNlSlYxNC9WSWdqQzh6d2VEM3ZEK0RaYkV4bk1DSERy?=
 =?utf-8?B?K0IvbnR0RFpKN2dYYU91ZW9SRW1sc2pOU3ZkRTFsci8zSkFHRXdTQ1JwL3BB?=
 =?utf-8?B?dzdvcWZQZmJrdEhuSUttbUZXbVpKcFlWOTJUMmd0eVcySjVRTU5EUlpZYXlq?=
 =?utf-8?Q?5OAgW4S55IA1iRpfdq63ce/M4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H9CO0COVC47dZlW/9vpxMjhw/A+kXWdTqIV01Fvi4smjnR01tHPxchaW/NF6i+c1FGd/s7US+EigGunUPdQwYxD2N1FGBR+T+mQi8AbzS4IGlZwsfkKne/DCBonV8EB2vuTC28lO9saq3Nme8ZCvgRMg++tM7ToIhUHTPrsZ2t0ghqdK3ej5nrs1l0abNuN3sS7ce+CJ3D30WnvTl8dwhEx+I4qEG1F+Yc5GSxPbMskuDo3RC2Bxu2ZiPBvSt+IGeCnXpPAZ1tVH4buagk7fudgSugixo5OSHWDiSBUGS2OCaXkRMF0VebiC+b30Tw5evae+ZDOIkjCC+IKYWrJ0qePzipSu/UAolVim/LSsnqXhc/zxty5X7AGdw08mx4JOIxozRoE5YSy7E2j/IvDGIr2lChLaz1Wyw99oVNZYG//leMy/TwE5fVLgjmgFPa32HYh6MGu8kDiaRp4MEgLR0/cPd4KbdZXCAtIAO+mqrIvEaC3SRBBm6FmJiIF79vO4n7s6N4TBNwI5Eaa3h+CKh1ZMaGO+8hgnBCWt2ncl+qKbtPiLyaz27eHfPTmPBqckq4RRJ7DGHGPIyUCnX/DT6R1qrUgb3fj1Zbf3jBv4MkM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6de72114-be7e-4ebf-fde1-08de0fe2814a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 14:11:04.2750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96sUCT9xp22DyRJsMVReYd8TAfpTK74ySZAg4j53cZQoGI6hPrD4wGt8eaiUivsEt8KbuIwllqjfHPueeirWhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7637
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200118
X-Proofpoint-ORIG-GUID: pqUBFKeTjA6KDkV8Dez-RcFU6CxIiUYF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX+3UgNMKdLXML
 OhwEbDHOTswPz03fDEMsGX7sr8n4px4NMCzwQiGFvJP/myJP8BdgRPWDinRgJM671ih/WXGQqrZ
 23FEWqZ8i418Ub4qiPsRIfH48hAx4jAxeuzdIVfwSOq49bDCzfBX7M0xtcKS2mjZGU6Ufp3a4GX
 Ky55kdKzm4Slgh6HZ4XujRF3HdO1HPp+qpHLB3s9bInkEXEHq6TuQF8QpNjfjGedR49lmc3n/0m
 6RApcX6Q0EDt3pmEoHXo8ibnYd8B1xPyUdhfmHyEXcazy3c6Ss/AwoO+qfP8jOCthkvoZPx8RuX
 VlUQHUSDj4xBgdNbqHTSHFOAdDcq0P0gqqlG0fpdaWc4F1DYdrFatIn86+wEZ8jf4JYC9GgFoRU
 WSvUioRGJH2t0dqEDGC5hWCA+BPgT123Q0zS0PIgviLVtYMxLYk=
X-Proofpoint-GUID: pqUBFKeTjA6KDkV8Dez-RcFU6CxIiUYF
X-Authority-Analysis: v=2.4 cv=csaWUl4i c=1 sm=1 tr=0 ts=68f642fe b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=F5R6MPIUSCKKepHF8icA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13624
X-Rspam-User: 
X-Rspamd-Queue-Id: C2EEDC0010
X-Rspamd-Server: rspam02
X-Stat-Signature: yw3qfe8g8roip8igbnr3mbqo86wr5zgt
X-HE-Tag: 1760969474-834697
X-HE-Meta: U2FsdGVkX197877xvCC2kH7xF2PpXNwzgEUT+b7OQ7c6CSBs61NLIIcqwuQwUfSpPXWp/ZqiCcAzFkFD8vTQ82rAnYKE5vs19PufH0ixfg1fyDrFhQTOAJfvIfhAKh8ibRAc2l/tLx9JuZj7F45nLUwpkgVdI4DWE7rq5NwNYzL336iU3E1mu24MeCJPUX5YXfZdODUuxu9qNCzFwo5S2qrPa9F0EjE+i8RElB4qJxOuYZfMirXdbn6KOI4mkRJXb+ikiLY5fae8EvTd9W0ecL1gvxX0cfvpX6C11oSsNoCGXHP6NJdpTbHMAwicZOFn8o6kexePkk7hDFlKyOoe87o9CGNeq2TX8F7GNUtdsPpRqElS7MzbOHMsZelnmOqF1Gbthp9/cP/WrHG1l2eMJJ9T+3kydNg4tofU/yv90T3xD+V0JkZPRE6M9AYm8Ewe2snT4KMAfHGQSgfX9oTby0r6BqY7uwDyfME4Hfu+XUp+NSw7U+Pzi+trepKyJWSx9myxuNSM1kOzx9FdM91TOu4w+wyKbpJI3tfP5MV6BjRPrT8qI2SEsypWs2rYUHXlikWHf1iPWrXPxo6tRHl1w6w2hL4Wdls+CA5z8Z1Gvy4he2Kw14PBDiEWISprTVtP8HlpV4RnxVdcLAWQLYHcq+eV56DB8uqOaVcF3DQQ0D7mSn1fsJhns+Y94j6a8wmu8MyqBjPZbO+Wi7+AgunZrCUP59gl1DbgZBiQUNkejeOXbcAUC0Yf+L5YlM8zLoHANfKywVfcbwPc4ZjjWB8cf/F67Deeq8xtgWcQDLqcS/cbzteFxHkUVdRKP1z/RqdSOsyQhs5M5wfuMlQKOIbqVv7M3D/N8e6nh5SQ9ipktnkmePDboo5EebztqA3bAoCszUYjBkQw6tgeohAlO2wMRn7Pm8XwJ4dAGa8dTJtogQHCV1BDVrCA30Umu6XFbPAI+Tai6ohhWCIK9ovq/SP
 IBimpPsO
 bip74Ku5MMso5dpL2WEml7pEPIMVSdFyzDlG9CmC8zM8d9nCMQwU4xVse/cnx4wD9altbMKTziKwQIR8rwo8txD97c/91QVfuAVrqineSz4iQuFBl2D9ooFHmoWZW8+kAVRS5HUdc8n3pEVDdxL3M+ZRVxCx49BhIO4KqxFa2k6eJlh1A1luWDAlVAVCeGAHi16QcD06/a0A3TStABZfmx4rK6iFWwNhoEy5nXtD4PnGqlr0hO6NW4Mcjhr6OsXE4/TIFMCt7DwrPixZzebnGq1sF9ePKHH94g1D6yazgyQcSwvlXBG2O7meDKi/fCtSpJtkO0ZxSdAnRMigueIU9kClz9viC5NRHYs2qShRS5yisKjx0iHSALmCgNAghX0pCknIWd0rFlwKhiJtRW4IchQFT2LpSwGutf2Y862NFgKxqcxyAlhVSdMvYIdCL+RrJ0b+KlxSmtuB1Z3SrOVkGmJexThl+7OX0yrJl1T1WB5fO5fdmiiUXM7sz4F0XJDluR+gtfZ4LWiF4URVPIBa22OxlJDUFUfWGnkiWDXJsRZkfM+0GanAXZEsDvHroOw7ZusM75gRyIl4kbh8F3Z/ozc3qexTf1aGfbKdqVaMoAzHw+fdsxnweYBvmKCkEVyjFfLuohbK/8oFFNHy0fjWHO3Asj5kspLSu75iXBTvzrzQwF3BGM0Gsmzpijvrhpf0uLQEknu4jQqtqqpAMIxvwFEDOmfZKbfk6nJtKjG2x/LU2IxY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 03:05:52PM +0100, Lorenzo Stoakes wrote:
> On Mon, Oct 20, 2025 at 04:43:33PM +0900, Harry Yoo wrote:
> > On Sun, Oct 19, 2025 at 03:07:36PM -0700, SeongJae Park wrote:
> > > On Sun, 19 Oct 2025 16:25:08 +0900 Harry Yoo <harry.yoo@oracle.com> wrote:
> > >
> > > > Since include/linux/pgtable.h is already listed in the MM CORE section,
> > > > add it to the section as well to keep it maintained by the appropriate
> > > > maintainers.
> > > >
> > > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Thanks for adding, but please put before pgtable.h to fix the checkpatch
> warning.
> 
> With that done:
> 
> Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> > >
> > > Acked-by: SeongJae Park <sj@kernel.org>
> >
> > Thanks!
> >
> > > > ---
> > > >  MAINTAINERS | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index 46126ce2f968..dedb9525c2bc 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -16249,6 +16249,7 @@ F:	include/linux/mmdebug.h
> > > >  F:	include/linux/mmu_notifier.h
> > > >  F:	include/linux/pagewalk.h
> > > >  F:	include/linux/pgtable.h
> > > > +F:	include/linux/pgalloc.h
> > >
> > > Nit.  Should we alphabetically sort?
> >
> > TBH I have no idea.
> >
> > I thought only subsystem names should be alphabetically sorted?
> 
> No it's files too, checkpatch will tell you:
> 
>    ● checkpatch.pl: 262: WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order

*blaming myself for not running checkpatch*

Thanks, will fix it!

-- 
Cheers,
Harry / Hyeonggon

