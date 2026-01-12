Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DF0CF45D4
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 22:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0399E6B0093; Mon, 12 Jan 2026 17:00:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F285D6B0095; Mon, 12 Jan 2026 17:00:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2906B0096; Mon, 12 Jan 2026 17:00:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C4D3D6B0093
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:00:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DE57C501E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:00:49 +0000 (UTC)
X-FDA: 84324682218.09.249A359
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id B2A98140013
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:00:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=P1jTtRI7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lOhdmQCd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768255246; a=rsa-sha256;
	cv=pass;
	b=ytHeyS223642vYk4UgJ1YN4FI5OVx5i4qJWjEO86lk41c1AMajWnyS67syMXcj55LUFVjR
	1aZwdJSPnvgzyZnNDZh0i4oiJ4Da6jgAiRFAs6xldwtp6uqllQGRAKrcyYujoc9Hd7DLYc
	lp5pwWCx+skMQkZaIrdqqrfqvv/embc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=P1jTtRI7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lOhdmQCd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768255246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3bFIfvZ3mypI5nsKRgI9z2BPgR+F0YGocSZ78DAx24=;
	b=4MEq7dLuRQN0pJBH3ASGqoJvOULjaDVbPDOxbkTcQjbELnjeb9XSxF5NbKeTzPsGjNqoGL
	r3xvY2HE8H2selirfk8bcfsJKsjO6UNqtcO8zV3Q5RZBNsgJvkd3mgydCdSwmmFkrNqg1L
	6vkuN4Jgh5r8sYAxZJCF9TcCHr1nVZU=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60CJEHqM1757120;
	Mon, 12 Jan 2026 22:00:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Y3bFIfvZ3mypI5nsKRgI9z2BPgR+F0YGocSZ78DAx24=; b=
	P1jTtRI74yT3+Hb6g7w5ahORt8eIXKj8MLdea3TWmQS4prau7ihR1XKtPi8ajORW
	Qk0NUgLKQJYoCUSZN0fFUMOS78HM25DNaW0B1C3rrPchCU3KCo9YUdWR5OkMz6Dk
	hGSGCQhPJto48lY7JbTIlo/bhD8+mmeTKarvkBv/DCqAaMDFno/20lre0Q1QonaE
	hHu7T2K7AQ27gibr+P0LeDAP7tsjBMcfEP3TmlW3X7Kk8DKBjX/XdV3KqL0Mu+nx
	1/CKoDVqdYYLcz2bsCx5b1xL2A4FbZl7P92Sc1eQqxbON9osg34tNJ+m0Yletdd+
	bagJW3a/z1tuSPuZO+0irg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq52fah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 22:00:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60CLf4jI001847;
	Mon, 12 Jan 2026 22:00:28 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011039.outbound.protection.outlook.com [52.101.62.39])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd77xcq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 22:00:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CxgChADsFZpnnlc8J2YcsTlCKMQMTYtX0kgyfIXzALuJBiiKrdIumz+P/+cWjsmXE+LcwHYI9JVpO7QW8Gq/M1tIGUmCm2VxstvEexOvoexUi3nF9wTF7eicG1T5KgtbULvoCSDHQAUzS5WI5TzTWAayXF5GwWjH55IKiIipaUINAW0W5hbKcy/oO5eEp9/FdNfo24CwmnCFRoX4qZq5ThRrZv1OKhLBAX7IHAnXMgMqgtpCfr7GfuqVT5jyfTqeiPoSSAV0ulAXr/zTdEcdwTBJWtqZDqulp4bEgFUyZEnRPzARayUVmsb9xhLcR852HoUL8yG194mkWY0TxVSVqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3bFIfvZ3mypI5nsKRgI9z2BPgR+F0YGocSZ78DAx24=;
 b=ljEvDR6TiLs+qom96x+PpYJ72+HCn4QKCHa5OsXKp/R/NPEsjc7OlJvE/4/4KqHtX0uVUUZqIGOwiRtaeZczvyr9oL/3O+yi4Fp6/NzbOpK1qgusv+0BKKWt9hNRDEnDNQhSsxTuTM+RKt4aOXP3UWY2UBUkC/sv7Bvoau3uDgykGoxJBWrbWgsoiFwSMSBP5MjwOqhwL7+E9nNh9XhW1qH4ub6TNqhf32N/aKLyFn6GxWtv2aiX9518IZmMkCJmekKCXDkP1R3wkJutLWcBk96K5zpBV38oq80XWI9XqyTXPxBiu00TDFTpBPuGgOsW4HaUB0nXaJ9cMqQ9T7/HyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3bFIfvZ3mypI5nsKRgI9z2BPgR+F0YGocSZ78DAx24=;
 b=lOhdmQCdzIqpneNA2chfQvDygFt5ziKovSM5GNT9PXrc7MVVMJWtbjotGc0r+70VpW0EVgQKqoak/hDyNUQVih0I/f/lTcMzMJgoUDpkoxknUqvo8qRxkhMpH4+VK0voRtyJLodb4QEr9DjJP7AkkAjto1nGEeTzsGQh4uOJd8c=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS7PR10MB5055.namprd10.prod.outlook.com (2603:10b6:5:3a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.6; Mon, 12 Jan
 2026 22:00:25 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 22:00:24 +0000
References: <1981A332-0585-49AB-9ADE-99FA2FB32DD4@linux.dev>
 <20260112112728.94590-1-lizhe.67@bytedance.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: muchun.song@linux.dev, akpm@linux-foundation.org, david@kernel.org,
        fvdl@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        osalvador@suse.de, mjguzik@gmail.com, mhocko@suse.com,
        joao.m.martins@oracle.com, ankur.a.arora@oracle.com,
        raghavendra.kt@amd.com
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
In-reply-to: <20260112112728.94590-1-lizhe.67@bytedance.com>
Date: Mon, 12 Jan 2026 14:00:23 -0800
Message-ID: <87qzrujxu0.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR03CA0218.namprd03.prod.outlook.com
 (2603:10b6:303:b9::13) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS7PR10MB5055:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f125221-4491-4443-5b01-08de5225fd06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFYreEF5eUpHR004MmJiU28yeHlkeXl5OEZ3cFpRc0VOQTZ0WVlPMld0elRI?=
 =?utf-8?B?RkNxQzNPeG9UN0tXS2JSdnlRVEg4V3lkdnVJbTl2TFliUXZVdklhRGh1YUJx?=
 =?utf-8?B?bU5RdzRwUTE0ZDdtUEFZTDlXMUI3eElEQ3RKWDhFeHRZMlFHcy9jeXVhUEJT?=
 =?utf-8?B?aWI4NkxjcUlKQ1lhUU1odGV0ODA3QmIxR3ZBS29ZY3dYYjc1U3g3QVR0blg2?=
 =?utf-8?B?bmsvcmswSmZMUjI2WnFMeE41U3RPdFVUNGhGdEZ1aEFFdWM4UTB4OHVsczl1?=
 =?utf-8?B?K2NHanIxRTM5WlRJbDZrUXQxRmJibVgzU09mNXhxZ2h5UmJFRnBVemQyNnov?=
 =?utf-8?B?RHF5RTQ2bXFMUER2K0RNaWx6OTNiK3lpQlZZR0VnckEvMm03WVVpa01TUlcz?=
 =?utf-8?B?dndSQ0pRVUZ4VzVvMUFIRWE3Zm9HZXFFY1BPeWdCanlPVUlTRThWUFpNRE5L?=
 =?utf-8?B?LzQ5THoxK0d6TDhPQXJhZHcvSzFUK1NGa3UrTUVUbzVhZ3VCcjNja3pIS3pY?=
 =?utf-8?B?SzFoclc1YVllRk1lbHRaSzZsbHFScnRyaVhqb2YwUXhxUXZ4cjZtMFgxakhh?=
 =?utf-8?B?RVZ1VmYwSk0wSFFoRUQzd1JUM05rc1BTRmR4aktYMnJvMitCbVhRZWwxTG9Z?=
 =?utf-8?B?U0FYOW9BMzBXbUFsc1ZKRDRYY2tqTmxLODBjQVRFR2syL05UWGQrVE55UXRv?=
 =?utf-8?B?WW00WHA3SHZyMjJHZ1d5V0VBa1NzSkprc3JaTE1vRHpSM0IwaVAvNk4zSDhW?=
 =?utf-8?B?QXM5NWdYak9MWFJmQ0J1K2ZqTzA5blFlbVFJWFloYkwvaDlxOUhzYm0rWTgx?=
 =?utf-8?B?NzRKUU9POUxOZmJ5VmdiSm1DdUhQSkRzMU1JcnlMczZNLzE3WUhZK1VycURK?=
 =?utf-8?B?bVUvMm1zaVdpa25pcElYb2l6cEovb1dhWkJUZUNld2pVL08ydzJEWFovZXM2?=
 =?utf-8?B?Vk5xZldDbzlhekNQR3lLTVFoOENvU0RNZHJ0cGJoazhJRGZGWEhZZnI4R2lN?=
 =?utf-8?B?NEFnK0pMQ1ZQYytUenFCc0k0Z01JVjBJRHhpak8wU3J5UUJFNXM3MExpYTlE?=
 =?utf-8?B?SXdZbU1HMFhQTENEZVVFQ3UxWDBsUXNpK0pVdnhDZlJic1NvWTRiMk1vMndl?=
 =?utf-8?B?ZkloNVY5dHR6RWZ2L1Rlb24yU0dDZEduUThuS0kwVDhmbFJGeUtzT0tjRlFD?=
 =?utf-8?B?NHF6UmhZZk50U3RHZUlFK1RWVmV3Ukc2OFFCcnBqamhJNnpKZUpWSzhPWlJR?=
 =?utf-8?B?R3REV3pCaWhMQkFzQ2xjTXU1ZFI1UDNRTjlHbEZnY3FIdUxYREFIRFJxaTlQ?=
 =?utf-8?B?MTc0ZzdzWCtTTXRkTkM1MHByUTVpTFdzWTdJVzlaTHFXc2YrdzFKU2xVdlRR?=
 =?utf-8?B?Q3MyaWdtNEhYdFJHYzNGb0FMUlNGRzEzaEZldWZGNEQ2MVhwT2c1MThwaHFa?=
 =?utf-8?B?OEh2VVovU2ExeGMxc29YcVVtQ1JqcXh6akc5T2oyMHNDaGdpNjJUVkgwckI4?=
 =?utf-8?B?ZnpvM3k4RitiTzhkWXRLUG13L1A1eDZaNnY3cU9OaEJJNW82dm5TMENBZzN5?=
 =?utf-8?B?N3FnOWEzQlhpdmdPem5PMnEzeFA5bXhWNUMxQjdUdFJicy91aktoVTc2WkRm?=
 =?utf-8?B?MjhNMSsxeXdtOEhZd1REQytqNjB1Tjd0ek1IR0x6bExIcE9oQWNHeVdNc0pV?=
 =?utf-8?B?akRIeUdka0gwNkhlbkRQS1RBdGpoTG90cFh0Wk1aUlYrSjdXSWVSZmQ3ZDd3?=
 =?utf-8?B?OThITjdrRktFY1hmaXhFaTNaUWpVSDZvUHUySVlyamo5d1JSbit1SXJXd0R4?=
 =?utf-8?B?ekF3ZVorS05mOEh6RlA4L3J2MENyWkFlNmxVNTB0RjZvZzFmMjVBYUs2cXZz?=
 =?utf-8?B?N0w1S09mWEFFNUVnN05weENqQUFLNDVZdk5aYTZ3ZmNHQTQrTGdabWtRY1M1?=
 =?utf-8?Q?XsYYXZER4ZRU4wYqF20Go8qFbZFuanxv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGpJVHdBaXl0cHJreFhUN09Tc0crNjVML2tsL0dXZVpGUUxpemNTWGNSS09U?=
 =?utf-8?B?YXpWTFdDL2RhQTZDSm9uL1ZFMEQraG15MFNJSGtwWUhSWG45K1B5NjVkOG51?=
 =?utf-8?B?bTZBelFKSHVKbjlDeDd2ZHVEUEtUNGxMVzQwcWV0bi9KTkM4bGRybmxRdlBM?=
 =?utf-8?B?NC9uRWNqUlN3WU54RnQ0bmpiRUpjcWNyN0c0c1ZGSEhXby9ZSHFPVHVxVnd3?=
 =?utf-8?B?OTVQR1RLUHRaUW9iOE9jeHRlNVNHYTQ5NXFSNHBaTnBsNXQwMWQvRHY4Y1Uw?=
 =?utf-8?B?WkloWEJsU2pzUjhuVnVrVUpJSGc2MXpla1lUbUpTTExDVG1YdEJoaVBHelNJ?=
 =?utf-8?B?R01oS0F1ZVhSZnVybTh4SDlHVHRCU2Z0dHl0eXM4bi84TjBML1JONFFxV3R3?=
 =?utf-8?B?SnIrR29XcVNHM2VvZURwTjFoaXV5R3B2QkMvTWwyT09RMmtQSHNDMUI1SEpL?=
 =?utf-8?B?VWJJbWYzQmJnMnJLN2VYeEN6dU1CQ3NwajVrMHNqQmF2UTN1eU8zbndBcXFQ?=
 =?utf-8?B?VlhOMmRGeUN4ck9TTmZxQWxiT0pEM09LUWVLTVVTUGFNL0tLSWNTcFA0bUtt?=
 =?utf-8?B?RDJKSVJLbDB5eDNMQU5tWDVSVXFDRWVtVnhoaVp4Wlh0enV5dWIvSWhnSmda?=
 =?utf-8?B?OGo5T2w5a2JKQnNmZmVhYmdrODdJUzBwRUN3aHl5cEhwYkRkSWNHanRoL0pp?=
 =?utf-8?B?a1AzYkpMTmNPS2licnpoRnp2Z1hPVUlJaGFkK25ZVDVrL3VuWURjNDlZUDMr?=
 =?utf-8?B?N3FtblZHK2NJZWxmTzJiMmpwejEwTGhtdGhIWTkvOVZoclZQTkpRYUkvZ1lX?=
 =?utf-8?B?QkpkQnArM3liQXdYNlNsOENYcm1vUDZidTlRSFg4bDFwZk5EbHpQQlZXQ0hC?=
 =?utf-8?B?VG9IaDZha1YwQnFDY0JGQnp0Z1c0WDY5YnIwQ09NeG9oNTQvQzhmN2ErK3d4?=
 =?utf-8?B?V0dKWE9zY3p1QkROWHA4TmZYK0NsUEFwZXRXaW5pZEtpNWhCTkswcXh3NTA3?=
 =?utf-8?B?VWdPZDFwY1dsTXF1SkhBV2c0S3RQejdxUE5DQk4wUlJHbGZCV1N2R2pqSnph?=
 =?utf-8?B?LzdUNzZSWndXcnd5TWtGd29MdzVScGE4VElxQklzV2E3QWhLMG5iYkFIdUZG?=
 =?utf-8?B?NnJ6T1ZsWTNXMytHTkpCTXhacENjaDVLSnhIZmZGWTdxb0U4S1lIdDhGY1Yv?=
 =?utf-8?B?SVJQTVI2WVN6WGZWR1hKMkFweG51TXgwTFVZZWdVV29vVVNHcS93YmV0bUVU?=
 =?utf-8?B?T0YvUXFKN0czaUtMeEZ1cCtUd3VkYnRYVDVKVW1EVGwzMGt0dzUzMEUrMWFo?=
 =?utf-8?B?VG0yNmZhbVZUU3MvRHIzT3lNZFpwUGhtYm5nazdkcXZoRFBLeEZ4VEJPeGVU?=
 =?utf-8?B?bk1sWEM0cENlVzFLV1RYWDh2UVlZVHZDcmIvdHJhZVAyT1lJQTF2eWxqZ2Zk?=
 =?utf-8?B?dHJHa0ZWM0VjbEJlbHZYc1lOU0ZjSDM1U1FJbVBORXV2ZEZ2LzRjRzRPMDJH?=
 =?utf-8?B?dGFSRVRFakxhOGhGaEdFNlowempLTkh1aXpVL2JxMHNCQ2dJc2EyOVlRKytY?=
 =?utf-8?B?UEp0dSsxV3p3S1ZrcmYyMC9PNDlyNmhXbGZZYVJMQWpSNnVuZ0xlK2s0T21a?=
 =?utf-8?B?UGdaOVAyN3BzU1lTdCs2M1ZoSklXbkpYY3ZjQlVaMi9EYk5FQ1lXNFVGZ2dz?=
 =?utf-8?B?UTYyRkIydm1aSnVrMU1VWVhHcCs1UEdpeDYrZW1DZ3VEcGVkM0dMY09ma0Zt?=
 =?utf-8?B?SGY0aWtGallMV3BUcldOTEt3eDNLODk3bUxNVktZaHdUaFNGcmhmWFdCd1FB?=
 =?utf-8?B?anphYWZhQ2NCSlM5QXBmTFlhUHZpTFFoRVMwSTRlUXNnTTlQY2lUbUZsZ1U3?=
 =?utf-8?B?SlZQdjk5OFIrRisyYjBteHhLWGV6Y2ErbTgxdHVhTWJHdzdDUmdoN3hPYkw5?=
 =?utf-8?B?bkc1TkEydHFtNitUS1JxRGNkOFQ1c0x6U01lT01udmlEL0kybU95QTRmNFJm?=
 =?utf-8?B?MXZWVTNDN1VTaEo0cUFjdVVlMzVaQ0Y5bnpFOFFnRlI2NTFWazZqYUYzakxj?=
 =?utf-8?B?OHdra1J6SWJFYWpxcFcrUVZyUThnT3VMVGtNUjdjODJESEV2V2hNM2tJUldk?=
 =?utf-8?B?VjRadzhkbGIxUnBqYlFiYkV4eUR0QmxJQjBuYmJiRk1GeXFVWDZrdERjWTBy?=
 =?utf-8?B?TVh2R3BMUWlUTFFTSmFXd1kxVHZJQXFpTVhoYm1uY25KNm5XWDc4bzEzQVhS?=
 =?utf-8?B?UnFuQ1pBVEI1YkxxckxXdFd2Tk00dkxaUDFLRnBLSU94T0xpUFlsNmV4aDQy?=
 =?utf-8?B?UUtXNkxLSWt1aUZJREgvYk5YcFBwR29qU0x4ak1pVlJPZDFtWTdpbDNwdXZ3?=
 =?utf-8?Q?Bq5Hw2cOYdo2QcqE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DyS1XbV4kxgEv9kRLFmBfchkMsxJyEJFRXuTZ6vq3IP00kvLw4JZ0s3dSEX69N/I/IGKch6PAOeei89BCGXRnkd6ltLgH+kfege5AJhUdmG51p8du7rb9t9MhucKppTveCOdfm9ZiA1oobXUJ8QfRdjHIG8XfFZAk5W1b+XrY5rroPvR85C2DC1i0t47gxEQSBlMu7R9OsWztBaH7MD86PRomtDeZ/Uvw6CTTrF3Gcg49NNGMTK2MDnR5kMO6n/81W949oIK+IfG9ZUIzWUt25vyVmFPm/LU14qsCvDGYVpsnHGUbh4bClSMorT/F4DFitAdTGwAvPwGsutl2JEzi0dfAN5TyZndj4CwILI0bOOJ3CecMM9Nj8rMGKRtCpUghU55sbrKCZA+Ne8QHRPrNYC0O27qZ7C6l+BzRBNucPx9nC2gNQ1VsDXPEfCndqWCKKlrIxoO+QJbYHJt1VEMMwq4OheAcIrhRCf0Z7AN9d/Ikl5U85WSk6wvDhyWFcknX9g1pa4SbaGnhC1tr3q9qXxvl+FPGtKeurrbHnyQs+VaTgXZLhDCcxwcKMD3Ub/M59OJvtWMRevupchPg95nACUJuKr+mS+qTiHQyI+hCz4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f125221-4491-4443-5b01-08de5225fd06
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 22:00:24.7831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YGXQm3IxexMwqMWbBj01zA2UgAEalfAoDJchqAcU7EVNLq8Lvif7y1PBzXvpqzbIgrfbLa/3b9H6KA1wLnMmqvI+N5dvT/IYYG20somR3Ps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-12_06,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601120181
X-Proofpoint-ORIG-GUID: 0IUpoBsXidTjPLgaTbaNcF1O7joOwYkv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDE4MSBTYWx0ZWRfX3vd7BDawg5tH
 SFLOYJed3QFM2fvaxhI7RSCALi6QdnN45lmhSFqWBd+HEhRM9INWkUVHBZCt1MXfbLaRCUulqTr
 I/If1y1/zRp+SxU3rHN6rwcEJPuJaVCmAdv497TKgbYikASUqHEx3OK363CPbY/FQXHjdshYZ5x
 NlPZddVuM627kjpaoVnQ/WTueb9InAUNLjQx4Un2jrBUJHZAcV28adoIaglucBfghVzY/6IBUn2
 TUmoxLB6nR7S1Rn1/560JZ2igjir/dbpgCCdpEweSyR2VTLO4dx00jH0uj2G02fv2Gx1MTFLPCC
 CIMb4lqxeFhNU/CW5PjhgWwdLjcw4rmi/dkZ9dXS/47cX5kRZ5ZR3n0UGJq90Nn58QAS6vGz82d
 1H+n/G/DXrqF2pKMS+Mzs5VP4t+tc+S3hakp1WhHZMeKAjK0mFUZPxdoygEktopuK2IJ3r2w5yR
 mSa6opC4eiCBOsjHTBw==
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=69656efd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=FToYJGKOHP9-SlxBGs0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 0IUpoBsXidTjPLgaTbaNcF1O7joOwYkv
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B2A98140013
X-Stat-Signature: wr7unawhrkwiyw6y7djchdn81hpth5o1
X-Rspam-User: 
X-HE-Tag: 1768255245-433341
X-HE-Meta: U2FsdGVkX192kBijD6F8u57jX94SdUwKGizp/7dRZyEoF87R4KvLIONC6ueSjpqrpH0/ASmJk15Ugm4TwnWUT8r9XM2vZ9v8IOncYsQN/EO/xkbkv3UKFbcLwURX0R9NQSDa+27M6QP9p6hnXJSCT84xSwbyshh5FMNU+pancg5mqGML3Ilf7hepqX4s6ILDfDxQinWl1lcBwYomouA+lZCdjP5H0Lre6k8ZDwnibaXW21XUkT8ze6pWYnShr18msOZXU1pLZp7PN1lskwgLro7yVZcmCguXf3Apy7qgvNSHywmkNo/LTJ2NeWJg3Hv8WwTgjUmiY88TYwlEO1rngetq4VdOa5z85xeE/TIQfbrUV3Fq0nsw1EBi+JctpuSU7M+skhii0krl2JiJH3Qgn6teIx6CpQij90lpw6eQApEGceVSmUt4HaHLYbfvLLNdIjxwvgZ3G/xm1UB7eptGZOCw9VSXGbLOI7/sLFyP/k25JZsJwdwTBJEbd6gDVLs0uV9QktWIipWfKirDaAp0AlspJiFo1yoKuEn+ZJgzfBKwkYvb1wWEv0+N6SQNDWh4zmXPf4XNds9xWTole/SorCY9kYbwbkRvcQ7v8L8nv28gX2G1wZNDcRq5zQg83wQ4SzbyphEhj24fK+FcfaXOFxiFQrpujLm9h7BGPpWGhoE+QSVOQitdR/matp2QAcsblolOesM3UsC2quGCSTRoeMlhQyaGUhTdehgkGjqLT0g+BZtUzk046QKegf82qZoa4mGidBszOQf23hDDfTwP5B/qsN1LiaEr7f710P3XfBUkVkvQljYkcniQA1TEKrks6iYpVv39jMgEuxHX9YzOlWlo/7yuvhDGMED5QbIIuUQgvgrFbSKoyDyhV7GZRerj0iu8+4iOZNf5wHkqaiiSDfgcW9F0JJYHzxPdC8ALVHxvdiREbNQcGshMIsQRyvCLpKXM82jFLlL92IH/HUZ
 dq7vOlmH
 EOXf7jXHkJG2OqkTqKmq4KffM/TPysmRhS/dbL3BuCCgTRZd6AlzFD5yKDm4/RZxYKBytrr6TgYL/Xb0Rcz9f/Sw7NTOR94Piuq9pzbU5sKdJ0Jm9y0bjDUOawCz8AjYZnrPAND+B0b4B+SPzLH+UblB4gtQ1c2lMUu7O1+Q1Q9vcojpLluGS04DiEl69oZhn6WEti10mQD99GeuyAyL3lVaXCo/EDf2h8THGnG3p8aKcAxkli4ZYJVKtfY/SGZQQDNXkosWdqCRKDKDXPwk5lBPnfupSWGKsqwJJE0d7WmcJToJbL4C3LbNkLfrTW+WK8mzTkVnbg2rvZq3wgnNJRq8HueaXi80p9UHoTXQGWjbHPHOaNv7/BWS0dZ1/PGhwUY/uFuvazrdTRRYFD83F2JRPCqTHXiDS9j3tolsNezzG26GTmD9rrQriZgCEe7DV4JVsbpTpD7emwhA8YkOp1C7o6B4rPQVC1hNNiV+/NsdkkfG0MRBHk4vLcLDunPvWfnD7xRj+Z0l318vPEq7djLNOXPLShsjRZow3pdbEoH+0oflWYrYqxXu5plRVATe90XxKD0UzpXmWC+xpRa/eyGyj/WEhZmwYEIUe8Ng0qjgpBGMsSKpH7v6PCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Li Zhe <lizhe.67@bytedance.com> writes:

> On Fri, 9 Jan 2026 14:05:01 +0800, muchun.song@linux.dev wrote:
>
>> > On Jan 7, 2026, at 19:31, Li Zhe <lizhe.67@bytedance.com> wrote:
>> >
>> > This patchset is based on this commit[1]("mm/hugetlb: optionally
>> > pre-zero hugetlb pages").
>>
>> I=E2=80=99d like you to add a brief summary here that roughly explains
>> what concerns the previous attempts raised and whether the
>> current proposal has already addressed those concerns, so more
>> people can quickly grasp the context.
>
> In my opinion, the main concerns raised in the preceding discussion[1]
> may be summarized as follows:
>
> (1): The CPU cost of background zeroing is not attributable to the
> task that consumes the pages, breaking fairness and cgroup accounting.
>
> (2) Policy (when, how many threads) is hard-coded in the kernel. User
> space lacks adequate means of control.
>
> (3) Comparable functionality is already available in user space. (QEMU
> support parallel preallocation)
>
> (4) Faster zeroing method is provied in kernel[2].
>
> In my view, these concerns have already been addressed by this patchset.
>
> It merely supplies the tools and leaves all policy decisions to user
> space; the kernel just performs the zeroing on behalf of the user,
> thereby resolving concerns (1) and (2).
>
> Regarding concern (3), I am aware that QEMU has implemented a parallel
> page-touch mechanism, which does reduce VM creation time; nevertheless,
> in our measurements it still consumes a non-trivial amount of time.
> (According to feedback from QEMU colleagues, bringing up a 2 TB VM
> still requires more than 40 seconds for zeroing)
>
>> > Fresh hugetlb pages are zeroed out when they are faulted in,
>> > just like with all other page types. This can take up a good
>> > amount of time for larger page sizes (e.g. around 250
>> > milliseconds for a 1G page on a Skylake machine).
>> >
>> > This normally isn't a problem, since hugetlb pages are typically
>> > mapped by the application for a long time, and the initial
>> > delay when touching them isn't much of an issue.
>> >
>> > However, there are some use cases where a large number of hugetlb
>> > pages are touched when an application starts (such as a VM backed
>> > by these pages), rendering the launch noticeably slow.
>> >
>> > On an Skylake platform running v6.19-rc2, faulting in 64 =C3=97 1 GB h=
uge
>> > pages takes about 16 seconds, roughly 250 ms per page. Even with
>> > Ankur=E2=80=99s optimizations[2], the time drops only to ~13 seconds,
>> > ~200 ms per page, still a noticeable delay.
>
> As for concern (4), I believe it is orthogonal to this patchset, and
> the cover letter already contains a performance comparison that
> demonstrates the additional benefit.

That comparison isn't quite apples to apples though. In the fault
workoad above, you are looking at single threaded zeroing but
realistically clearing pages at VM init is multi-threaded (QEMU does
that as David describes).

Also Skylake has probably one of the slowest REP; STOS implementations
I've tried.

--
ankur

