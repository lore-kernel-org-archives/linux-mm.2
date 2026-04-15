Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32C6F4199A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 12:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266836B0005; Wed, 15 Apr 2026 08:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2174B6B0093; Wed, 15 Apr 2026 08:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD686B0005; Wed, 15 Apr 2026 08:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA08B6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:14:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6216713AC98
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:14:30 +0000 (UTC)
X-FDA: 84660683100.12.4A1D3D9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id EAD9B2000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:14:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ACvCBR5D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KHAAPvyl;
	spf=pass (imf13.hostedemail.com: domain of joao.m.martins@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=joao.m.martins@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776255267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kg4YbcR8rSvpxJma9KbJQykrYHPC66eBtz3fWRXH6WU=;
	b=h/WjFZS2D/cd571qF/6w9g30yH3aSrb7bNrQDspQE2aBwC4Q7YxEsEPC2B+V2+2CzEZ5SS
	y7/MlbuyjhrIfiWLj+vDF9HkrHpQz6xzxwSSNxHSkH/MMaEdeVyoX4FpybMiJntx31BGjy
	+8/PRiX79AqQB+E+q8P/f2WVHgm2bw4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ACvCBR5D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KHAAPvyl;
	spf=pass (imf13.hostedemail.com: domain of joao.m.martins@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=joao.m.martins@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776255267; a=rsa-sha256;
	cv=pass;
	b=nTEA6Q8eLvysxw2SVXr8pppq0sYOQsPxE8km6CzOc9zl19cO/swUCKczeRcW/GJN+kxm5z
	DXrBVvuF2oIAnS/etDAIneFZECrP1WkLrd+qyJ5fjx9XS89OEnvIbLuB3Z/tjd4lD0RDf1
	obpeqE/KDrflT/EqazIemRwnnQ49zj4=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63F9BcYm888376;
	Wed, 15 Apr 2026 12:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Kg4YbcR8rSvpxJma9KbJQykrYHPC66eBtz3fWRXH6WU=; b=
	ACvCBR5DJzwC6CVxtY+pzRSuofj4qh281fDIvIKeHpziD0MZtXpxffXNQ7Z/fMiF
	kZGnzB9eJNhLWAOmy83DfM2WC4wvVHQIIxcuKMB12mRQSmoU01V6Sm5tivqiGd6r
	Gmqrccd8PESbnOUHBWvCDRB9+E3hjpOAyawwCuyBN8tKTUimRM2H8tTFFFpT4Wly
	6Z7S4g8gcpuEhzn6Z4ql+KMJkBtKnnYGWQzqcp1OHOj43+zOcdCQ8wIZFIshAuJE
	SAwidRWkxsoi985uXRNiI8H1VwUCl/CC45Z3tGWVUIqhT8USRDGJuKhZhbpTzAS0
	3iE9NJwUC8uzEs4MtlAOaw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85jn31q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 12:13:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63FC4Q4w033577;
	Wed, 15 Apr 2026 12:13:55 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011012.outbound.protection.outlook.com [52.101.62.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7np3e49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 12:13:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q1qUNWxqCmotlXYjQdM8CsMelf4Z8PnvnSpOcwrIgUwZ6oSOubB2eWG/EuZtmfXPAyWdBypba+kF8cl0QLFuGMOPzH/QmhUV7szKVWzwQcOGM3/a7g8EuFIXl1zX/JDEeMzXWSGGZeEZwAgckNXAv7+8cNiFe8kegx9ToyVgTEKSAtN0g8T9bWnmz3dEZRgXWp0rr+LGFOy2CWA+x/+2qAtQVfhztYyY4Tz0p2DBcHr6GlYitCZmk34MyXr1Yrus1YoRirvlxSj9hCjFSfzEDUTCVpPN3zUzykSFv4AjxlERx3Bb6mOjSBmzqhGWjrahrLfogWP6hRsXXzGJvnq7Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kg4YbcR8rSvpxJma9KbJQykrYHPC66eBtz3fWRXH6WU=;
 b=YTrl+HdkFQCV/ND1fKslmmHhXj4VYMMMPVlCvsXk6/XhYu4DiOB5qV1hz2G0LL6AFOoHJiNPasNpC/TWzeptV54Kqo1/s5KE31G5VQRtkhHKNKRkbjwoiKwb9olteXwOMHemlx+f0uzaroTaK5H5DYbfKaK21+vHodpV9vyGj04O+wThlOogiQgQVXU/OiP8cxpaXdYblmtKuJAdsEaNJrUhrZKTioupHKzobRUkulYcfkMzZJ80gM4jpkr8PGpZ77zmbMO6n5Z4NaZx9xqIGZrGo2KoDSfRXMXck5cORCmztM/8ykN6UmTpO06OD0orx+g213LcgCLyPth/XthNHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kg4YbcR8rSvpxJma9KbJQykrYHPC66eBtz3fWRXH6WU=;
 b=KHAAPvylYCOG39Jzq7wkpJsC1GFYXNuTs6SNtEuC8QUwQTTtN4uPWDm90isNQviyLkgIGhLEiazFGidlcM2iU8QNpDZ2vVXkOminmZQ67Gh4pyjzDDCJRGChH+O12oY77CXY9nqzwF1aJZqn6dLF3egUeA6LjRxqEp/JaM7LGoE=
Received: from PH3PPFE6F9E2E1D.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d4) by SA2PR10MB4458.namprd10.prod.outlook.com
 (2603:10b6:806:f8::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 12:13:50 +0000
Received: from PH3PPFE6F9E2E1D.namprd10.prod.outlook.com
 ([fe80::c9cf:290a:5596:dc4a]) by PH3PPFE6F9E2E1D.namprd10.prod.outlook.com
 ([fe80::c9cf:290a:5596:dc4a%7]) with mapi id 15.20.9769.043; Wed, 15 Apr 2026
 12:13:50 +0000
Message-ID: <9ceede7b-45d3-4d15-b8ce-f0b04bbb18dd@oracle.com>
Date: Wed, 15 Apr 2026 13:13:40 +0100
Subject: Re: [PATCH v2 4/6] mm/sparse-vmemmap: Pass @pgmap argument to arch
 vmemmap_populate()
To: Muchun Song <songmuchun@bytedance.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, harry.yoo@oracle.com,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.ibm.com>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
 <20260415111412.1003526-5-songmuchun@bytedance.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20260415111412.1003526-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::14) To PH3PPFE6F9E2E1D.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d4)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFE6F9E2E1D:EE_|SA2PR10MB4458:EE_
X-MS-Office365-Filtering-Correlation-Id: 077a604e-635f-4771-726f-08de9ae873cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AJ45PBOqLLGTkFiUNrqTiD36jV6+fiS2y920mm7ZsXirS2prOcSL246a6KrmF2+aK2wTJx2OuvhCN8Ixq5HAsscviL2KWeLh1b3Fh4unmns+uQ4wRsaIfiOhH1RVOk6/8kumsiLH7vZYk98TXq0NukmEXNvTpDOGvWX7yZoddCoFbaJIY98Kx29FZaB+d+4TCs6QOj2vwTG3vVN2MMGQPf0r/jIvagokwSUPzj3L5AB6g2iS+Tb74wHApHAT/FM+XnE/xVHk07JFHvRT2553s0+omYnygK3+BqF0JMAzhDng2mHDuodDCBECSJ0/Ack6zrUF3ZyUe1oDVqOb17DF0HS3ksPWX0H8Gvy5TjGTdWU+YjXaDm5jeZBzw6Bj0MtToEtDo28IhnrvGfvt2HmJDzcHhE1B8zHOFgnQBNmJ5V7pgKu1TRmebjqmcPhzh6IAQXV3fdgMYqvknY1Jd+3JU94fPzfYb5A5aqoK+AM5cz78qa2lLbhpGpT5nce0eU0eBbhEmiyD+w82qiKcQbzyr9eBAUl6mEJdtWSh1eT65hUg/3DdYwjHedgOxekYldEzGEaFoP0CQIASjo3g9g6mm647w8P6f/RWZ2AjcQubzgGkqm2fbo6/TVqnHC4qYJeRF8oL25WGOtVjdHArm38Aj5BXLrmmqTh+YBddRo5I7uWKI83MNmQMV+5dhWvyRpmsr1pf/DrQy78MHSmymtvFV1PaLnRnZTru0hR4OtcXx84=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFE6F9E2E1D.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T1NWWmN2Z2h5TUV6MTh0aGZVQmxrcnFzTUdGL1IxOXJCNWhyYk5OWlQ3Vkow?=
 =?utf-8?B?MENlSUE5U0dERFBocFV3N2d0d0ZVa2wvaXlTNG9CcXpRaWV4YzhTL010Z2xy?=
 =?utf-8?B?Zm5ZejBEazliYjU2QURKT1daQjA2c3VuMzlKNFNwUnY2Vkx2V2VNRlpUMUlR?=
 =?utf-8?B?NlRmdlZENFpOTzQxM25LVkJOMnlIRzQrUnBQejhibHl2SzQ2M0RMZTYxN3I3?=
 =?utf-8?B?aHlqZXF3ZkY5anRNS3c0bGoxYzFXK0wxUVlEMWJjaHVEcnFiMDRmSTM5SXFQ?=
 =?utf-8?B?LzBlYWNsUkVyaE96TDBBVnM2YnBQUWlCY1lEWWU1cXpRR2E1bjUvcFkzTmZB?=
 =?utf-8?B?Znlxb1NMYkd4SmhUOVYwNWh3bE8xdDdDUGNrcWNkYlcwU1BYdERvZWVob2NT?=
 =?utf-8?B?MUJYVkhFQXV0YWJJLytzaDdTL20zZTN2bHBxZklDZ0RLK3QxbnlTd2J4OVR6?=
 =?utf-8?B?bXNraklVamFvcEVyakJETldMQy96Q0Q5cU9RMGxNZnVXejBocVkzcHo4b05T?=
 =?utf-8?B?Sk43THJ0OEpwODkzRGRPaHgwQ09qRThBbkN4RDhQcE5BYmNoaTQ4Z3ZDVmVR?=
 =?utf-8?B?SnJ2emJoNm1lYXd5YU5RZ254NCtoK3ZwZVdDU0ZIWnZxNkI5MTRVY0hienE5?=
 =?utf-8?B?STlRb0VvRElocFV5b1JCVnhJNDhMd3JOTlp2K3lWWGtJa21QSExwcTBWRVJM?=
 =?utf-8?B?WjltSXZOdTN0ckVxREFjMmNtN0luaWdXYWVXYUNERjIyUWZDTXh0VnRhMG9l?=
 =?utf-8?B?TEtuZXVyVnlncDhDcFhaZ2U3ajRWeERxVW9DTFVuWWhxNDAyTWw2U0F3c08y?=
 =?utf-8?B?c2plS2I4VFNMTDNKTmRQQ3podE9WQk1hWG14eXN6VDBhTWpHSnU3TSswOWVt?=
 =?utf-8?B?RUhFNkFRNUxMeGowUjZWaUVDbEJuTDNSbUhuV1hWNDMweG0vM2dleHM0cXQ2?=
 =?utf-8?B?QXZMbUJ2aEppWlo4Vjl2bHd3T0RtS0UxRXkrUERKaDgySUhYUWNXS29JeEU4?=
 =?utf-8?B?dkdOK1ExY2ttN09XY0VMbEkyNG10Y3Boa2xvUHV2aVluM0hJaWZqUmFWOXgr?=
 =?utf-8?B?RHY3Q2VZWmVSMy9CUU8xNWMyd1J1NXBSZFE3cE8xeDRiTVBHK1RqQVhUV2xE?=
 =?utf-8?B?dHFSc3hPdWpJYzBvWE5hVXhLWm1UeURZVTlobTdUUjVxNEVHaFlicUVlRkZv?=
 =?utf-8?B?QXl4dDh2MzZtOFRmZDF3QU1oS0VQMUpIN1RHdWtTTzlWbnM4bUlqRG9COVFO?=
 =?utf-8?B?Rk52V3FqQ2Q1R3A4VjlqZStqdzQyV3V1SExUY25UbEh1dHl1UWZzQW1BN2pZ?=
 =?utf-8?B?Mk9QckxPSElFVGtIWERBRXBXQmZZMGR0N1hkcnQzZXJpc3N6UHM0M1VlVVln?=
 =?utf-8?B?ZHBBQ2ZkVGNXOXdla0hoK1lXQzBlWkRkWmY3MDNVVnVqY2E5cjFkV1Ivb003?=
 =?utf-8?B?UFU3T2N4ZnpzQUljUXdxcDdkUnRIWVpZUmtvY2lBWE5HTWxXM0w3UkhTNzl1?=
 =?utf-8?B?azVTanBNV2VjRXFhdjhIRnBqNE91STVYTThkOGUxVkx1TVFmdzJiU29PQzNK?=
 =?utf-8?B?TnlFTFJLSXdlaDNrZGx2ZGladllKeW9Sa1d3UkppMEtmRjYwN3VIYlc0QmNt?=
 =?utf-8?B?eVhaMXhvYTJsbDBldVJDVjVrK1VIczlkc2RkcFloeXI4R2xsN2licy8wbHJW?=
 =?utf-8?B?VEg1ZklLZEQ0Sy9sT1NjNXRjbHJtZWhZZlJpcU5ISXloSk5NOXlxWEE2SmNP?=
 =?utf-8?B?R1VLMTVOY2Z1RUpSNGF1Slg3cHgyMFdDQjlWaVdRd2NzOVR2M2VvZEwwUTVx?=
 =?utf-8?B?OWlhdEJpaUNiKzFRbnFQOGE4THdvdEVwZTJDQVIrbEpmOTBGSmhtVExKNldj?=
 =?utf-8?B?K2lXelB3R0E5TnBBOUxEU0daeDBycUhzOW90L1ljNjdhRVZRWktGTFF4dzRz?=
 =?utf-8?B?czkrWXdtcVozemRoL2JNNEhOTmhoUXFNYUZsY1FTU2VVajdobCtPL1dyRW82?=
 =?utf-8?B?d3lIblhtN3VoSU56MTgvbnIzcE15NUNSNDhoZW1pK2xNdWtxRnF2V2NoTWNk?=
 =?utf-8?B?blIwL1psMCtlYVIremVTenF1UWRoSFlqWUxTTjFUY2doUm1zMzdoQmNiYXNH?=
 =?utf-8?B?Qnl4QVU3MUpXeC9TUjRMc0o1MSt1eUFubTc4ajhpc1BaeHdTM1owbEhnVmpB?=
 =?utf-8?B?MXhOUWFhc29kN3A5ZFNvVlo4M1ZzSFk5bDFlRXVHZTJJZUljTHBHa3hDaC9H?=
 =?utf-8?B?MEZGZ2R5cEZWdEZhZG5WUTNXMjRNRzF4TGZLTlJSRjFoQTNCdGZ6WElRV2Rm?=
 =?utf-8?B?SU5vMHBrd2tvUGt5eFVodUdWT2Y1ZERTaGRZNDh0VWhuNHFwbUUrRStjMERk?=
 =?utf-8?Q?PkxQdQ60TpMQ65fI=3D?=
X-Exchange-RoutingPolicyChecked:
	u9drPR2kalIK5OtqeQPFxpUfGRNmDWeBnEzrx/7bBdAXE9sVJUYO9CxN512yMnVnGCIf/dkyAZVCQHyN+i+eXZQbWM2AebnhCgAvlb5xVoWoXiF9E8OYF44y+rnuFkKI4uEjggM3fOrrIcVLZR4BWDak9e4Ha2zjp1GcB95w/asmz0RVOtzO66T2mgbQZLH6AUugTAkHQgQBZemnrh7kMy+31B1VwFXuQ7qNu/hSSWyhsfPgMqV3WIjkYIhuG6+GqyhhMbFocWaqupMaqffR0t4Re4lH9hb1fttZT+y6nbh3YQF4yB/t9lKFpJ9Uy0HbsLsj0TPH16g76CxgGmFEOg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8OuH3mE2e/qIp3rlIWSYIMfnpdLWe6gfwzBwy0LNxlm72EK5E81i6W+5UdTNc5G3R1RVF2D/fVSnliNKKxoMLkEgj+nlsIu1Ep5vjsmCjMkg+Wx0PjtfNC7tlD5VSMRta3JvuRCr6hKPveBRxI+E2pMADwJaUtHi1sHNBP9h7fsFIOr+Tt+pm1CAzyRQAXPF0Z09gBL2t/rlxBFISlLPSTavf5Ld2qGSXgZpHf0+kmCArTIo5oacvOX0/veobhxX4ssDXe6EdUj44p3H2AtJtvw5pFQLILeuiDQ1petVYZ7UP5AtwJKwYYgiDqSQFDaFJkvgJ81cAA5ZtsUgc/jDfxBdP59Z+ycr+efMAwRD/xHVWKhSmlpb3iTugnthcZDE9x5UonjYhGoCNVJyCzIF+1B7dhLvIkOBrOd8d9LaJszrcTUaIMyQMr2XcxLj7RScwDK+sAbh5N25IvcgCNlif6QeHQoCx88LOWEe7Cp2/EbraV20J8kQ7c6mHzCu0YtofvVaJ2tv8XV8EWjSkSV3rwOLtbhmzjAusp99vg/7QqL+7CMb1eGygg16+dFM4MpUKGIJfmKhuhHpcO7cRfDNzedEa8heLqQCYR+rY+ojxZI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 077a604e-635f-4771-726f-08de9ae873cc
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFE6F9E2E1D.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 12:13:50.0427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4zW2UP6+mHvohWHWLHcMMWBntjAgP2MuT3DbY6sQzBawEBvJ6WUEOzuAFcMPFV5tkVIz/lyZf/LtUZSJNpXOvFPSyP2dfnd8+SxUARPiFKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_04,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2604070000
 definitions=main-2604150112
X-Proofpoint-ORIG-GUID: PuIXrKetPaRLGE27OwtwQG_FIgDGYoSa
X-Proofpoint-GUID: PuIXrKetPaRLGE27OwtwQG_FIgDGYoSa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDExMyBTYWx0ZWRfX748K80HLRHJz
 M8ybRys8xhGuJSF7Cn/2QiuZnHW9D48gA8R2Sz/REGrNBhdYXDZCgjO2RlO+ONhfJeMPokbrj+r
 AS95vO+TuQf0Kg2QLsSdw+Mps0bp3OyE0BPYSmAP8qglKjeY9KPXsf38opgNpz1awKVM7KrsnXs
 M5TlBsR6OzkJgUXXT91qXf4IDl9Ch/7BUrbPgJbd41xCI6PMxF66JjpvZ1hYiS82hy75479VeWk
 D2Ib2G2az19nuIlKjIA0Y7wIMvVfI/GcLpC02U04sKsDHoOI2UUFuPj4ieQ2B9SeIluCzsElYiD
 T+UCFqSmYJGctZwqlx1J88SwfHiijJZR3NgpEBF+T3zNuII+ISQncgYGnyKkXOS2kkf4PUNjlmO
 fPmHCuYYey2DcX7ybFAyjwT6cxbZrj9/J6NIqr9Msh7oOfRGjfLTGFDVirYe0Gi9DBpkB9zPjbi
 gCcaFNTMViRGUn+awWTY1DU9YKEkIF6jQl1HuG4w=
X-Authority-Analysis: v=2.4 cv=Co+PtH4D c=1 sm=1 tr=0 ts=69df8104 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=968KyxNXAAAA:8 a=44hX-j3RfSQrQtt0eo4A:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13825
X-Rspam-User: 
X-Rspamd-Queue-Id: EAD9B2000A
X-Stat-Signature: xmuktqu8sfbw3yoj4fw8ezcz73oj8btu
X-Rspamd-Server: rspam06
X-HE-Tag: 1776255266-632621
X-HE-Meta: U2FsdGVkX19zESOoLnH72LKuexc9f0Nk0vcr4ERTGjxFRMFy+BzYJULkU0OQx+/sPMViv2pNc6S+ddTCnjAUi+7JlrwwdbU88hEpqSV6Heu8Bw7fEXBOM0uilJLx92b/vfajRk1Ry39/QXmvhCZCaocD5abhj5UKUR8+fGOGJUP2C52SL4mjgDH8+8jHbi4ZOLWUXQ8wN47EyL3QFKUyVE3LHETOPQ/yFi7DE9zsIziK6jMCWvDea+VEWjTaRoGhPnFIKsuXJtk87HtPAMMb4Lrv/CoDDwla1Bcc8vF8uxG9TL40q+ZKEHZvLsSzfj4ED+II0SuLokv/uWtnT7S+Tonp7+s5ZddeeUdH4fL9TMnfC1U3FzV0l6WtX7jfdt4buoOq6/FRRPvdQ21BFhHTbKmgHwRW5SlCKZnUGiFFwK7VUPo8LqN9YMy/e75CYR1GXeK7bvGDmNFzJP79X0mFzq16uKqo5zfMtMFiNEBSmuDkWPFJu/UJvsSYXh5+M7pPrFwVAE2u4GeMU4/PfSjVBYvZMuyyBrwg0l9NxDcqys3lF9RTVuzjrLH9F9Ag+/CzU6vHtnuxBZ1RnFTcIAEWTpal+RDLC8kVPKGIDYTHazdhB0isFtNYkivJ0rGErV1AEZzPuCI8ajvw6xEPfIku8K1qmMuxoKxtXhkr4plIid9XkBRvJrGOyQmxLx1Up1wITUfCBkLmjM0tBSFHJDhguqJKUCcRbKh53cHGFWyenGzet7fhRt7wnYkmGUpTZ3SxnD3dObDwn4wMnXjWbRD6sh453W0rFDBNXiu7FwpDCl5DA55gy+mKTOqiLbYwnFq5DogyyXsT4EV1if+LEMvY9xLwhjYCQw0sKAPeQEBEa/Yz7BVvdo6wYft1vnbzmO//IfofYLEesIxVeWpmEAqlni722ASiN4DwCeXUvYD88DYTzekLuDyA+eOI5gzhb6FvcISneddscvn7Ic8Tlh4
 szd55/J3
 K1wIKAZ5nH5QVeGk19YugJJrliEFodmuIUy68C+N0HcM82TgNPnBmMU6f1YKOO/VNFMgs/pUSHWqpzix9rFnJ3492bcCqZQg/OW23DetUqHVkMGezwEsMlWJD+hIG+5LFIQKrEavoEoWlfh0ey6511wK5nC8bNWEZlS3WJjrc6mUpudbEYJWvMA/9bl9J8QyKZLpKO1cdfZqiWVxsTV/D2vBt9Z/0QH34WicDP6MuEPxklVHi+RCyziou9pmTrRdgpxufdR7+o/wJ78hbzHd7PZyj43zLUZHdzi8k7H+k9xVgKaEhx1jXu/R0moVCHokLzlyNfUFMqjwg+t0v0wF6dDFWYdkEsxJJhbYM15CiNsBIlIFgf4v0ke+HJWa4mdDSMKQC4xyMspEGlSdTWyWdZno20bkMG+pZS3sMb5nSH2P3XDVrII7weBLHAewuiut+i7GQfVEUYLW+qhLtf5Vkp6UJQ3sgeChTj3QoM/QFDf3ptPP55G/qPgThmQ9FXDRt6jFVblGeAlKWfSi+iNdBFhzN36XtrO+IlrMLgGY2msDiPfCvYxPXEOqJr7tR5iRtT1RwFd8tEFiMi6xy2ulRnpyJxss/ecWw7wZBXA9G/Hy/B/ij+N/GoNU04KPrWGmsK8mL4pFaPxpEd9XomYw516Z1Y33EM1lZvxCHxj7yhrDGycYR1Xjd2BbEhy3UwMTpo4SR/H98OjF7h5LJ3J0W0BuaShdhQAc2zfLYTSbas1KMKU+C9jwE9DPT+SsT/Mca5SPG/eZI2X9mbIGJZWAyO7l5hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/04/2026 12:14, Muchun Song wrote:
> Add the struct dev_pagemap pointer as a parameter to the architecture
> specific vmemmap_populate(), vmemmap_populate_hugepages() and
> vmemmap_populate_basepages() functions.
> 
> Currently, the vmemmap optimization for DAX is handled mostly in an
> architecture-agnostic way via vmemmap_populate_compound_pages().
> However, this approach skips crucial architecture-specific initialization
> steps. For example, the x86 path must call sync_global_pgds() after
> populating the vmemmap, which is currently being bypassed.
> 

Harry's series fixed in a different way (for x86):

https://lore.kernel.org/linux-mm/20250818020206.4517-1-harry.yoo@oracle.com/#t

> To lay the groundwork for fixing the vmemmap optimization in the arch
> level, we need to pass the @pgmap pointer down to the arch specific
> vmemmap_populate() location. Plumb the @pgmap argument through the APIs
> of vmemmap_populate(), vmemmap_populate_hugepages() and
> vmemmap_populate_basepages().
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  arch/arm64/mm/mmu.c                        |  6 +++---
>  arch/loongarch/mm/init.c                   |  7 ++++---
>  arch/powerpc/include/asm/book3s/64/radix.h |  3 ++-
>  arch/powerpc/mm/book3s64/radix_pgtable.c   |  2 +-
>  arch/powerpc/mm/init_64.c                  |  4 ++--
>  arch/riscv/mm/init.c                       |  4 ++--
>  arch/s390/mm/vmem.c                        |  2 +-
>  arch/sparc/mm/init_64.c                    |  5 +++--
>  arch/x86/mm/init_64.c                      |  8 ++++----
>  include/linux/mm.h                         |  8 +++++---
>  mm/hugetlb_vmemmap.c                       |  4 ++--
>  mm/sparse-vmemmap.c                        | 10 ++++++----
>  12 files changed, 35 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index e5a42b7a0160..11227e104c48 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1790,7 +1790,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
>  }
>  
>  int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
> -		struct vmem_altmap *altmap)
> +		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>  {
>  	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
>  	/* [start, end] should be within one section */
> @@ -1798,9 +1798,9 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>  
>  	if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES) ||
>  	    (end - start < PAGES_PER_SECTION * sizeof(struct page)))
> -		return vmemmap_populate_basepages(start, end, node, altmap);
> +		return vmemmap_populate_basepages(start, end, node, altmap, pgmap);
>  	else
> -		return vmemmap_populate_hugepages(start, end, node, altmap);
> +		return vmemmap_populate_hugepages(start, end, node, altmap, pgmap);
>  }
>  
>  #ifdef CONFIG_MEMORY_HOTPLUG
> diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
> index c9c57f08fa2c..d61c2e09caae 100644
> --- a/arch/loongarch/mm/init.c
> +++ b/arch/loongarch/mm/init.c
> @@ -123,12 +123,13 @@ int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
>  }
>  
>  int __meminit vmemmap_populate(unsigned long start, unsigned long end,
> -			       int node, struct vmem_altmap *altmap)
> +			       int node, struct vmem_altmap *altmap,
> +			       struct dev_pagemap *pgmap)
>  {
>  #if CONFIG_PGTABLE_LEVELS == 2
> -	return vmemmap_populate_basepages(start, end, node, NULL);
> +	return vmemmap_populate_basepages(start, end, node, NULL, pgmap);
>  #else
> -	return vmemmap_populate_hugepages(start, end, node, NULL);
> +	return vmemmap_populate_hugepages(start, end, node, NULL, pgmap);
>  #endif
>  }
>  
> diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
> index da954e779744..bde07c6f900f 100644
> --- a/arch/powerpc/include/asm/book3s/64/radix.h
> +++ b/arch/powerpc/include/asm/book3s/64/radix.h
> @@ -321,7 +321,8 @@ extern int __meminit radix__vmemmap_create_mapping(unsigned long start,
>  					     unsigned long page_size,
>  					     unsigned long phys);
>  int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end,
> -				      int node, struct vmem_altmap *altmap);
> +				      int node, struct vmem_altmap *altmap,
> +				      struct dev_pagemap *pgmap);
>  void __ref radix__vmemmap_free(unsigned long start, unsigned long end,
>  			       struct vmem_altmap *altmap);
>  extern void radix__vmemmap_remove_mapping(unsigned long start,
> diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
> index 10aced261cff..568500343e5f 100644
> --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
> @@ -1112,7 +1112,7 @@ static inline pte_t *vmemmap_pte_alloc(pmd_t *pmdp, int node,
>  
>  
>  int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
> -				      struct vmem_altmap *altmap)
> +				      struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>  {
>  	unsigned long addr;
>  	unsigned long next;
> diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
> index b6f3ae03ca9e..8f4aa5b32186 100644
> --- a/arch/powerpc/mm/init_64.c
> +++ b/arch/powerpc/mm/init_64.c
> @@ -275,12 +275,12 @@ static int __meminit __vmemmap_populate(unsigned long start, unsigned long end,
>  }
>  
>  int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
> -			       struct vmem_altmap *altmap)
> +			       struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>  {
>  
>  #ifdef CONFIG_PPC_BOOK3S_64
>  	if (radix_enabled())
> -		return radix__vmemmap_populate(start, end, node, altmap);
> +		return radix__vmemmap_populate(start, end, node, altmap, pgmap);
>  #endif
>  
>  	return __vmemmap_populate(start, end, node, altmap);
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index b0092fb842a3..a04ae9727cbe 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -1348,7 +1348,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
>  }
>  
>  int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
> -			       struct vmem_altmap *altmap)
> +			       struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>  {
>  	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
>  
> @@ -1358,7 +1358,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>  	 * memory hotplug, we are not able to update all the page tables with
>  	 * the new PMDs.
>  	 */
> -	return vmemmap_populate_hugepages(start, end, node, altmap);
> +	return vmemmap_populate_hugepages(start, end, node, altmap, pgmap);
>  }
>  #endif
>  
> diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
> index eeadff45e0e1..a7bf8d3d5601 100644
> --- a/arch/s390/mm/vmem.c
> +++ b/arch/s390/mm/vmem.c
> @@ -506,7 +506,7 @@ static void vmem_remove_range(unsigned long start, unsigned long size)
>   * Add a backed mem_map array to the virtual mem_map array.
>   */
>  int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
> -			       struct vmem_altmap *altmap)
> +			       struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>  {
>  	int ret;
>  
> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index 367c269305e5..f870ca330f9e 100644
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@ -2591,9 +2591,10 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
>  }
>  
>  int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
> -			       int node, struct vmem_altmap *altmap)
> +			       int node, struct vmem_altmap *altmap,
> +			       struct dev_pagemap *pgmap)
>  {
> -	return vmemmap_populate_hugepages(vstart, vend, node, NULL);
> +	return vmemmap_populate_hugepages(vstart, vend, node, NULL, pgmap);
>  }
>  #endif /* CONFIG_SPARSEMEM_VMEMMAP */
>  
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 77b889b71cf3..e18cc81a30b4 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1557,7 +1557,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
>  }
>  
>  int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
> -		struct vmem_altmap *altmap)
> +		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>  {
>  	int err;
>  
> @@ -1565,15 +1565,15 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>  	VM_BUG_ON(!PAGE_ALIGNED(end));
>  
>  	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
> -		err = vmemmap_populate_basepages(start, end, node, NULL);
> +		err = vmemmap_populate_basepages(start, end, node, NULL, pgmap);
>  	else if (boot_cpu_has(X86_FEATURE_PSE))
> -		err = vmemmap_populate_hugepages(start, end, node, altmap);
> +		err = vmemmap_populate_hugepages(start, end, node, altmap, pgmap);
>  	else if (altmap) {
>  		pr_err_once("%s: no cpu support for altmap allocations\n",
>  				__func__);
>  		err = -ENOMEM;
>  	} else
> -		err = vmemmap_populate_basepages(start, end, node, NULL);
> +		err = vmemmap_populate_basepages(start, end, node, NULL, pgmap);
>  	if (!err)
>  		sync_global_pgds(start, end - 1);
>  	return err;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0b776907152e..bebc5f892f81 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4877,11 +4877,13 @@ void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>  int vmemmap_check_pmd(pmd_t *pmd, int node,
>  		      unsigned long addr, unsigned long next);
>  int vmemmap_populate_basepages(unsigned long start, unsigned long end,
> -			       int node, struct vmem_altmap *altmap);
> +			       int node, struct vmem_altmap *altmap,
> +			       struct dev_pagemap *pgmap);
>  int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
> -			       int node, struct vmem_altmap *altmap);
> +			       int node, struct vmem_altmap *altmap,
> +			       struct dev_pagemap *pgmap);
>  int vmemmap_populate(unsigned long start, unsigned long end, int node,
> -		struct vmem_altmap *altmap);
> +		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
>  int vmemmap_populate_hvo(unsigned long start, unsigned long end,
>  			 unsigned int order, struct zone *zone,
>  			 unsigned long headsize);
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 4a077d231d3a..50b7123f3bdd 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -829,7 +829,7 @@ void __init hugetlb_vmemmap_init_late(int nid)
>  			 */
>  			list_del(&m->list);
>  
> -			vmemmap_populate(start, end, nid, NULL);
> +			vmemmap_populate(start, end, nid, NULL, NULL);
>  			nr_mmap = end - start;
>  			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
>  
> @@ -845,7 +845,7 @@ void __init hugetlb_vmemmap_init_late(int nid)
>  		if (vmemmap_populate_hvo(start, end, huge_page_order(h), zone,
>  					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
>  			/* Fallback if HVO population fails */
> -			vmemmap_populate(start, end, nid, NULL);
> +			vmemmap_populate(start, end, nid, NULL, NULL);
>  			nr_mmap = end - start;
>  		} else {
>  			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 05e3e2b94e32..f5245647afee 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -297,7 +297,8 @@ static int __meminit vmemmap_populate_range(unsigned long start,
>  }
>  
>  int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
> -					 int node, struct vmem_altmap *altmap)
> +					 int node, struct vmem_altmap *altmap,
> +					 struct dev_pagemap *pgmap)
>  {
>  	return vmemmap_populate_range(start, end, node, altmap, -1, 0);
>  }
> @@ -400,7 +401,8 @@ int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
>  }
>  
>  int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
> -					 int node, struct vmem_altmap *altmap)
> +					 int node, struct vmem_altmap *altmap,
> +					 struct dev_pagemap *pgmap)
>  {
>  	unsigned long addr;
>  	unsigned long next;
> @@ -445,7 +447,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>  			}
>  		} else if (vmemmap_check_pmd(pmd, node, addr, next))
>  			continue;
> -		if (vmemmap_populate_basepages(addr, next, node, altmap))
> +		if (vmemmap_populate_basepages(addr, next, node, altmap, pgmap))
>  			return -ENOMEM;
>  	}
>  	return 0;
> @@ -559,7 +561,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
>  	if (vmemmap_can_optimize(altmap, pgmap))
>  		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
>  	else
> -		r = vmemmap_populate(start, end, nid, altmap);
> +		r = vmemmap_populate(start, end, nid, altmap, pgmap);
>  
>  	if (r < 0)
>  		return NULL;


