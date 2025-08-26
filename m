Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1DB1CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23A858E00DF; Tue, 26 Aug 2025 09:35:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212A38E00DC; Tue, 26 Aug 2025 09:35:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128B28E00DF; Tue, 26 Aug 2025 09:35:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 015298E00DC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:35:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D6C51407D8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:35:41 +0000 (UTC)
X-FDA: 83819006082.05.D50DD7C
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id CAC09160010
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:35:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ljXQl1Km;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.244.73 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756215339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMMQOf8kN0Po1OtyUh1N/3typdNKYgrzLBCwt2XCqhc=;
	b=DTlsiTIps91ZiZe5ZF/duFTJKIWU9r702B83L3lXsrnUpG2VGGiOj2rQI2jtf0BZyoaUby
	VH6bzigHiDL3mEw7FC2By+1JPfDWKxAzCevMHZ/vABGADNiezrjpVafkdKHeln++x6OC75
	Woua7QzFJw2Dgs2kSCHReSAR63eF2vg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ljXQl1Km;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.244.73 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756215339; a=rsa-sha256;
	cv=pass;
	b=VC6gdF1QWP1spE1P5eHsrNLYCDIE0BB3OpY2K3Vy7e8NZRZtWP3XXOBx828FcAGRosRcL7
	Mcn8cnRJtblIqSUT3KWhBH3fYBAU6fOaSeST57NUUaXCyPf+pdKJWWaqgfDN/S4Rln3jNX
	QtQmXBXr7DXWEN+zacucUj+9jNwhZaY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F49FsGhw7/cG7Dz6tnwAjFmAk57KLfvFw2GprLPZlqaAmh6hD61/JITrnS3Fn2KDAgAbykLusa2F7L8vfteidKqsXE45+GYDTnNeYDIz3Vzo6ihlr7V5CoJXJuQZDIDkyDTHFf3xoazCUk9kSsZe18BsBU46AOFA00C0fDvuUDjeVmDa5uLCoM/GY7zY8m3QSjX7DnCW18ahKcvYuBKab1pnG4h0vSQqlpysycXDXpcJcL6QnixDaZhpSI46rX7z1fzsHn1VHC2/iWAB+El0+vWOq26jE6sUo+kul7u5YQZ9/bByGMck4DOct/vWF05f8FliDtIX8KFvbdFVXCZvLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMMQOf8kN0Po1OtyUh1N/3typdNKYgrzLBCwt2XCqhc=;
 b=Lgl9+Jzh5F9r0zTk2AsbJMap2N55CYKa7cxUBuCtuOSNFUYrj+On9wilikwBG0VUn/iCLO/mcI0YA221elB5QlYBDXPSAoaBaT1P+O+fIZtLwwt322wQhQEsia/J9YjqFVPRrsOxIdfRBhYxg113osoHJMoK08QplQOZz6EtOb6OR95N/Pagud+JX2HrQgnuObvWp97Py5yV0LvGfdFt9cK66hDrxGy7/EP4uhtoUOgqSLxE4qQFIUsN0ejZAjq+Jk+VGNd1+urDd1W4wNgTmvcElMn8ZCwAHCyQKcSPycQGCSx5UkVuoD1vcvPdhaNzZJo4HuFC0v7liuix8lHSnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMMQOf8kN0Po1OtyUh1N/3typdNKYgrzLBCwt2XCqhc=;
 b=ljXQl1KmhK0M1qmvAYf9bUQwD0dIiAsTLJiQxIXK0LB3L1IwNFx/PJfznVOhsMbbjihc22Y6C9CpolPFg8blGsuqKpKpoBQxE68UTGu3OcRp5C7nxF6UXRvgc+/mgHKnGfcbU1m8T1gPG6utqf1LawQvNzAswWDFuhzC9+fww0o7YD2vROtwEvzmP/Y+DTg7zr8NmkgbYGyZ7tfi5+6ptuHwKKQNtpYLofFgoIojAs8TyGS/PjZn4Pp7a8uQJAVNttotglzjr2kDsvTJDSaFXJIbLsjEe6b5XiFZMuJq0QkpuhPIfhP76tJNsKKxmMnvimGKMS3cgWNKd3M/qd5OZQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB6738.namprd12.prod.outlook.com (2603:10b6:510:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Tue, 26 Aug
 2025 13:35:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 13:35:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 vbabka@suse.cz, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/pageblock-flags: simplify MIGRATETYPE_MASK
 definition
Date: Tue, 26 Aug 2025 09:35:32 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <91600A33-6414-447F-8C3E-494B02D21F52@nvidia.com>
In-Reply-To: <20250826093148.30190-3-richard.weiyang@gmail.com>
References: <20250826093148.30190-1-richard.weiyang@gmail.com>
 <20250826093148.30190-3-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: MN0P222CA0024.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB6738:EE_
X-MS-Office365-Filtering-Correlation-Id: dd2856fa-3e94-4b08-340b-08dde4a56fd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5LwktXzsFwrr63Yy/6/FhKBJCyM82H6whiv/K/wXyJXCDQizWxMQYIrCLHri?=
 =?us-ascii?Q?FtILwGy6gVIR6riHHUlIWbBErFYIhbxUy0/KANR4RUOpDYM1qMd02I8DTd3p?=
 =?us-ascii?Q?/RPIq7o7ZJdMUr2pdGwMLxsFVPFuFevdDugnjLzXksQokqLEoPptts6yv5XN?=
 =?us-ascii?Q?X6gyNxvwtnQiiqQl+WvPjGeP16CoO1mgQk9Zg9z6J2FALIYuW5SAnkIKwxsm?=
 =?us-ascii?Q?FShDB/A62ClOhCrcGY4Z1YVEbjFF39DdA2ehXr/DrGwBQACJ+Hrx5BTSnvEY?=
 =?us-ascii?Q?LaKGAWLUlnZQg+Md96yJjnB2bHnC97jZPdY4/QAAw6ns0JILP5XtoUqKBQu9?=
 =?us-ascii?Q?GfmRV0HGBkFtts4RIjBKCRPQPuVgnKWaPCB4GP6NA4ZagMP8Gitt9GNgrg1h?=
 =?us-ascii?Q?g9IugkoXbX+TQCu7xgtg1tDdD0hgBG8uk871UbY0Os2Z0ktJfyYOXtoA/eIw?=
 =?us-ascii?Q?JWsfDsbTTpLtdpRpzuPulbTff+f73uQQYyiRNwGaYsiecV/RCgU9+sGRO6Ed?=
 =?us-ascii?Q?P3MczZOW927l7fBH+TRqWxd12UEMW/jE+gXQm5/4yQv5Km1YQrcTeaZK3msO?=
 =?us-ascii?Q?heeMXw/XMrtGwJqZHRv1oGcvvMbQ9UVwe/eSa+eSYDbeVvxW2nCE6Yh9jmeN?=
 =?us-ascii?Q?YUK/12JEHENxVbPFgdQN+7WYYcAsFvqYYNzzg1R6HQDcwRgdIWnxiNchLAJC?=
 =?us-ascii?Q?eePJh9zmyb+grLbeBXmZm2rXWiWRjDEnf2z0utjCHF5BR8HJTTnknRIGNugP?=
 =?us-ascii?Q?EiNobL0C7Cm/V0peaer0UNiOHWJMM7isCM/nlGTVx9Bffb5Q5Ihthz01pWdE?=
 =?us-ascii?Q?IzLtzy9EwC1w3yLqVJjPbvMnaTuv7jQTFcQSQPTMAz/Wg1uhF9iS+1w8+vuV?=
 =?us-ascii?Q?oVnawCvrJOodxlkbkDqQM3Ja0vggJ3n0e4sdZznX7C42Sx5sklazGcmDc6xe?=
 =?us-ascii?Q?S0XsD1g5KgMaBnJtpVY2U04F5qymVCVp4rhYMK4+xbr81It/UTAbAEM/qBK3?=
 =?us-ascii?Q?B+jOT7SatoPX2P6rsGdVGuTwUtTyV+NvvR5QWmjsJka9w9V/Wk/TALolExzp?=
 =?us-ascii?Q?EQnFfvPCKKg4FJwXaNsEPjUH+LdzwBjMN4MuCWKvgsx515bq0PJnNXBCbE1f?=
 =?us-ascii?Q?WRHTDzXd6R8VO7mRWaMjLMxFMttNDt0Qv0p9xugQPECYDg0eVJZb6UQ7/BHj?=
 =?us-ascii?Q?5KOH0hpE8eiHzJLc4LVkhxX34q+hh8zUYzKgm71bUEroQ+B/RaY/KHSkSor9?=
 =?us-ascii?Q?lt1mcmE4K0PZ1jBrYcoqD2/CpmfmSNt+YVN6hg4YdnMcQNXZosF/Jg5KbOX/?=
 =?us-ascii?Q?Iav3Ai0HVXHVrFiYu3ccjYQpqK/LNw3ieWOSYBaZI7DHPF9Cz0o7JGo3vzvD?=
 =?us-ascii?Q?Pns17bznEm/aoNFzfn9DsJeJb6qrSvxs9ctE+hIhxzLXjIu1wjiU1wVbQ2N7?=
 =?us-ascii?Q?cM4rcNWIjFQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DxHL2zNp8agSs066TCGQ5lfaMqvkN+FNQjTfvxN79KNXdkid/7h3IAo4VFYD?=
 =?us-ascii?Q?r8rBpUWCh6hDquS4vNAz9GThJEW+1oDP/3SbsVY92r4knHos9JgLVQbTGUab?=
 =?us-ascii?Q?RU6uqzx0clAXtOIU77tjF2EzrCLxOTRyWxV+jWehN1ksBL8Z/f+3/HoW7dEk?=
 =?us-ascii?Q?u4Dkit/q71x83B3P2xxM9D6iRPl67c2litCMdnN9xC1qIBBFtc3A5a9v2y+H?=
 =?us-ascii?Q?AUE0tim9s710l0q7iplZd0DioQrf6GzFhh/tzisQqBVhUbISxO6j0i20d6aB?=
 =?us-ascii?Q?ika06NSAARKu833UrTT1zW44WOJJpIBpwRIewro8hWiGRXjg5bJvAx4wfZFJ?=
 =?us-ascii?Q?8F/3tP97kfriHNcueV70NKSDk2LlKTTtNW0oxdm3vBVfjM2m84HMb/GdUhZS?=
 =?us-ascii?Q?uYmZfLgkERLolj9DiZQ/M1gAyLpa60aUyPNFIMW+rmWTG7nONQ2XbCb2joTk?=
 =?us-ascii?Q?7E6EhXsT053vjtYF/aeX+s9e3rWCkCyScUJRPMo4JJeFW0JSqGJftD79SXPX?=
 =?us-ascii?Q?BQ+3xlEnoRozfk/0goXtW5JkLtEmh6V03mp29iaTNq4rrp8jgsWngxvw5qIQ?=
 =?us-ascii?Q?XcAhOp+lZZhZW3El7iZfIWU9wfUSK0znoQTfcH4bDez3Q6PiMircoa6xCVua?=
 =?us-ascii?Q?qAKE3Ldi5pA5X1sg4dym/E0RCvzVIHAmSvrUYySCx3JhobbrF1U+CvunNXvM?=
 =?us-ascii?Q?ozUztjCh7NAtcTbc5gihu4QsLs1qtCOsF/lGfF8JjKDXqP0I78ZDGknMrW/6?=
 =?us-ascii?Q?HyWm4AWXMqae4nOLMLbFOjFR13reGMRwBVsMy8WF0OotN07CZ0XKi0J0sHNd?=
 =?us-ascii?Q?C88wRTArmcYu1t5pkZHoPaBGyLFvfhwL7Hy/dQC1pG9aaVtv8YcHfJeG0Ty8?=
 =?us-ascii?Q?h/avVZ5gi1KGAOd1XCCMDSPuzfz/MDMi1SREiQUGsLCjdONvmkLh3T6bTYJL?=
 =?us-ascii?Q?xXsAP0pzkGn0rOuNDAbSynmWBo0aDTYG2juaE4v6jBC6qlDrSwdHW+j0YPH3?=
 =?us-ascii?Q?/QZrDZpahla8HB3HkYeiZJQ4o34DQNC5dbunyBr0LWDQr17QqZeIK2LOjFFL?=
 =?us-ascii?Q?Lyha/8XYyeRm6uKkxZuXc3pQNTx4EUYPsVBOqNXdMGaNTMKSkiFczs0+vI3p?=
 =?us-ascii?Q?rvpC+xON4TbAsnBBeSoOY1gQRiWEDV4pSWYz6O1AlmjlXWLBHiulFqiXFQPo?=
 =?us-ascii?Q?uJro8JWr4C5Aw04L07XpaXtga0cBCJ1h2bcDRWuzIK8UGgZXgDqUKrkQdpcc?=
 =?us-ascii?Q?jmq/giqnxnB/6CjD19OIcqNc9cFhuPnZeLleINLzQhygk6ub/Y+c73aspCYC?=
 =?us-ascii?Q?vZUWMZNq9zHxCpE0qmvUd5OR7AETSSgCGdq751pmZ8nwm/VrxrXIUFW/xXBp?=
 =?us-ascii?Q?M43rSgGaXBc5xqRqYmlvHZ5s9Miglvd+SHSxPTEhbUmXyV4XI3QN5mlyXCGH?=
 =?us-ascii?Q?sOnWAeGvVY2PqMqUbJhhTqYeM/cywvUoleDtT4s66ZTEXnD1hBMsyS54PCQo?=
 =?us-ascii?Q?kdE/02qcfvWahFgvLN8eeUo1EEEQy/QBxinNs1/CX8C/bZmMYRJhMGe2bq7Z?=
 =?us-ascii?Q?0o3zHJT9yFaNztF30UUIS3OefiI3aTJfJerxWjGT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd2856fa-3e94-4b08-340b-08dde4a56fd5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 13:35:35.5043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ErpolIb5dhNCIJqJ/1gJW9OQGYM4KANTBq8yMwe3jPOk1ghcneVneP/jGgr4lTdk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6738
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CAC09160010
X-Stat-Signature: q3yikqxa5mujd59eye5rwnikdydoiaae
X-Rspam-User: 
X-HE-Tag: 1756215338-379156
X-HE-Meta: U2FsdGVkX1+U8Jc/55w6do+4DYUyurkC2lDLYZNijrfFX9nNTksbyzBK0ti0c7NIsN29PJW05UMPV1nPuWgE7DFWdNxWJf29kSI5MfPeR5seWuHT1ERQwUMHDwkr2HV/erZfOBINNwogb9nzgzfxQPgpXFzZq2k64TgJ7kOkflQjXdBmAbkFDSib3EKH4dOa0HklO8pNPD39weCRoEcfs+g2li2LK8+mERlqVg3kSDczfjsx3IetX0TyouBYMmN7qC7CA1K4QSLBCHZAoTHNrbTuwRY5jAptlsvTwywBOgySb3WBaB2OWls5XAfKHJ3bTt0ZOMiHpkRMHxw8TqKNWK61AohCCCevCVlmv4rrxP3D3E8Zs04DPzYwOnR2t0SIj70QCU5Y42w4OTGWK32sBG+JgOQy4zhAYxKSHpigo94rkHDo776evrH3pUZamiFZksDGBHtn+52TA8Bj2FurMCmksGohV6465TLytNAKQgTzd/n6kRwKcWTmy/Jh44isv7t4oxD/q7A0VvcMN54NiQplnomYggEK0ulG0Ts4zaKtCsEHBqbq9qphlzRUWmdrwwD7AMqYK4qutPW3VQp3BrSTv9EpZ+0X2rDOsKUidvikzBNgjahoPVuJbrQyk8uHxW63QnsTuMI7vBlDziTrbSuAnSfNSznFLto4lsBp/9B2g6kuGFmEkiskkU4cvdeWgjbL9zcMPDeUJyk4UmYkyDAoeOxUUPckPdmRdh4OEY8LVqK0wHCF5F941aIMgP0a9SHdHuMEIfze3aww2cf6PSL/7aJOvt4r2w+jUqJtH5TCq0euTSGyirb5VY53AC7Lfqfh8mdeh3Z5HicAyt9ekjDeTpt93B6esfZIgdEL7x7KIbrGNYl/aO8nASJAENBPIfwb0TkKa/S1xEWAgbrU21ecuc3QKf1pm48dP2j35vVA0OU4bcPhvZn0X0uIo/zLj672cTuXuy8lWPHZJIU
 72ONnIff
 GyMllGyW/cRyIfXq50HsdLnlahZVMPNWdIkN8sTYRFgTCV3boY8n/VVw/aEVbmwB86teGr69wEXpsXMc5tgUZJYKC/nDHQHjIGcZAhQU7EKGeWAIQrMQrQJlmqPV4hrKODBXlVROiYh1DjFFKKBcUWerFT2/bFZd6hwX18VrwzioXtC0Nw7s9Hr29GGOzs4NKuw8blU1LanIJ4/14IS7Rp2qDF+cfykYnzdT3hJT144sQM7XoVUyM7ufzfwpt851MQXsvV5L0VyyERwlVjYM3T3smeAbNEugduwCdh5gIJD9kI5cqw7ZXLTCPGdbvv25kfkEi0r1G9iqe49kvEAJw9BgH2gy21sTRByZQvl465cCguzoKVcRvK2Vfy0+T7GLxjYqbNcr4q134nefI6Nyh6NOAZlUIOqed4bqk/xJDxKdmMITv3qXoIwp5VUmLdbg6/MVTrKUmZtG033UrXwTValAKHn++hq8dlsGkr4Qq/QvGR51bXWJ7WuBNRwrM5U5oDSIyQUPuI7+Aqiu42T8xY02vpGuL8QzkcGyNjcxe11fx1s6uXcolBVw5wDLAgzFpeGOoWKnd8ZnKE0wRJEiOG/hkNCec+zODwgRo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 Aug 2025, at 5:31, Wei Yang wrote:

> MIGRATETYPE_MASK is defined to be the mask of possible migratetype.
>
> Define it with PB_migratetype_bits directly would be more clear.
>
> Also, MIGRATETYPE_AND_ISO_MASK is MIGRATETYPE_MASK add isolation bit.
> Use MIGRATETYPE_MASK in the definition of MIGRATETYPE_AND_ISO_MASK looks
> cleaner.
>
> No functional change intended.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/pageblock-flags.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
> index 6a44be0f39f4..1489c062a5a7 100644
> --- a/include/linux/pageblock-flags.h
> +++ b/include/linux/pageblock-flags.h
> @@ -37,11 +37,10 @@ enum pageblock_bits {
>
>  #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
>
> -#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
> +#define MIGRATETYPE_MASK (BIT(PB_migratetype_bits) - 1)

I am not sure about this one, even if PB_migrate_end + 1 == PB_migratetype_bits.
PB_migrate_end represents a bit index, where PB_migratetype_bits means
the number of the bits.

David's suggestion in another email might be better.

>
>  #ifdef CONFIG_MEMORY_ISOLATION
> -#define MIGRATETYPE_AND_ISO_MASK \
> -	(((1UL << (PB_migrate_end + 1)) - 1) | BIT(PB_migrate_isolate))
> +#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
>  #else
>  #define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
>  #endif

This one looks good to me.

--
Best Regards,
Yan, Zi

