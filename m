Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F30BC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42368900049; Wed, 13 Aug 2025 04:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FAF6900044; Wed, 13 Aug 2025 04:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C245900049; Wed, 13 Aug 2025 04:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A72B900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:19:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8BF01402B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:09:27 +0000 (UTC)
X-FDA: 83771009574.20.E167216
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 81FF2C0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:09:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LyFzJhAq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=i0O0MHnW;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755072564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8INKauVHVJJ82CGEgKuEiFmssi1wFZiw3isz9FDHBM=;
	b=bllq/03iQh1lT4IDkKbBrMgtxLD9NuBJ5VY04IzEnxhrGAOgcsCmG6ZqK0AD7+m+nTAZCm
	AqICt5ee7IKUnilQA3A1qFMV+Qg+KrXH0NUMzNowFe0015WpzUDqBX0GWOJIUEp2HlizXE
	H+XiCMJpS6BB33AM2GhmGnqGJzG9Kxs=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LyFzJhAq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=i0O0MHnW;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755072564; a=rsa-sha256;
	cv=pass;
	b=5mBZqVuJ+LCoJaSnmRTZ/pN96V6NPMmngBc7i7YgpX6nyXYZAL7PifZXfNvX8nCsMieZkO
	4ZYoeko0zRkizDcVzim8yFAEAy4e78KiiLlGKi4+uttmbBBzI4wFumsWgDvLkfETnne91f
	zgMcThc4d2QWFIOu0c+EuQ2XvYyx3eI=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57D6u5qb017717;
	Wed, 13 Aug 2025 08:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=t8INKauVHVJJ82CGEg
	KuEiFmssi1wFZiw3isz9FDHBM=; b=LyFzJhAq3AHGgQgMXp31cU8RHKB7QQJ1w5
	vdj28Hf9YAhZUNgFvXvD+BLy/TRbFl71pghvgYSKwJZidgyX4Hh8s4pX3VDJ7457
	Qj2dmonwB09BD6qdHwY22qMoDn8m3jP1hhWpUbnpRiVOJbH0JkJxShjc5XDboPEb
	ZLIZHpMblR+xF57koJec+BTkAgd3jVrTNIMH0lh+WlAwUVTiczWEhef5dKrxUZt1
	vX7LJfCnuWpjTskjGLAme5UgU+lhV0BDw7/8TjJarkgvFT7nDCpcryrwpTfdkceS
	w0ltEHmLPh1Tw8fP8ReDQiVuNBZkF2714hJw0TlO/MrfIJf7aKcQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dwxv6q5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 08:09:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57D7kGhm016805;
	Wed, 13 Aug 2025 08:09:19 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010060.outbound.protection.outlook.com [52.101.56.60])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsb316d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 08:09:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JRh1D4cYhRlOWGvPzfIsDVr0vWNsM61ywfgBRm9Or+CCTCwOAyvFx+mn2BxWYKqzHELaI+sdDZexEpCXAnIVdy2mBPYznjAhBiWJmXAG/uXA/JsTFBAOMkivqDg4LfxrlDMa5JHQZ4/BxwqrnuoE8KayR3QXqEqKmMTs1fW9ltHDOU9tZD/XHH37i4rW5ttEy6jyRJ2Tg05w5mPzDLAnfxngnXUqgl8TdwUvkTFaeOSFs8aUGkHT3ztmHCn2Fs2Rvm818+zSeTbGZ5t1yuSLl3Ec2bz/xd+MpVJueeJifDdyNtmekWn7Qr+yLb+4meNJItPcLpP65gI60hoDR/0k3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t8INKauVHVJJ82CGEgKuEiFmssi1wFZiw3isz9FDHBM=;
 b=xk1gCzgQubZUVdyijvS/HNF1/iTShR7ZXLXZCnefKHSFc/mufPx+wDWlG9lsWpOTPGpFtUGhugwuB5uglk5vf1hG2WSlz2ouE77GrDaZFIM/l6M1zLOLX/NHBss+ll101zunf535GZKslsDG6uIWsBtz/uI17CYPXUOLfUsWDVUYaJV6gLnpO6tdpnRc963JQAY/Vm4ndMW2COGCsL2Cl08LGqNOD9haOPA4sjpjMiK0bTa92fVxFTpSC4eUJIA34UlerSX9OBRSfu/QtWw3XviRmrpIfskRgP/7flKvrKFBZ8/immedLh2lWyuBoAoRC84sCht53VedHOHtEDwW5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8INKauVHVJJ82CGEgKuEiFmssi1wFZiw3isz9FDHBM=;
 b=i0O0MHnWfqWqCcnCJRNmb5xOQfbl13B7VrGcDcJ2DVL82BQw5Qea8IhcurxkfCXBqMebCkT22HgQmLPC/L/uhtGDphkOVFEY2xhfeNnJ5D+KFaYJFQDHNWUKUjA6P/H29katZK/C8kJJ6U4U1BROS4G164W0v8VwmUQQZbr8Q9M=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5047.namprd10.prod.outlook.com (2603:10b6:408:12a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Wed, 13 Aug
 2025 08:09:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 08:09:16 +0000
Date: Wed, 13 Aug 2025 09:09:13 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] selftests/mm: Fix spelling mistake "mrmeap" ->
 "mremap"
Message-ID: <5a38db18-494b-4f3a-8ce4-44bab5448559@lucifer.local>
References: <20250813080156.1977375-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813080156.1977375-1-colin.i.king@gmail.com>
X-ClientProxiedBy: AS4P189CA0036.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5047:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ade42e9-9987-4022-f80f-08ddda40b292
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?to17IVBvsFMH3CAFUjJ5AHwGanzYy/YvW1VTUYe6H1Nt+dppSHEldLECT9wb?=
 =?us-ascii?Q?lsCw5g5vhD6EYZ0W6Zm37GDHakNjZ9jGqKr179r4WWhBRsyGln0DenNT7DRT?=
 =?us-ascii?Q?uSDaypWx7s+KYYRgXrws29WFI8rkfZbC1HCzqHewFCDOjjntmHPiVIhST8jP?=
 =?us-ascii?Q?4kk93BtB69q3s3AbttMLvHcl/M86tL9UwzfSnBFlEwNz1NTNiY6bRD/3oBTL?=
 =?us-ascii?Q?CLhu6Qx2Dsv/nOKNeR2LSu7WyGEceCq3TVXd66ywxxzoS+jRsh+EkTclPCr6?=
 =?us-ascii?Q?ABJ0hV0DOBi5cgvaGwmnN9GopkkgGTGIwlsmHJzhnRJxHlMN0KnGopyXn+qp?=
 =?us-ascii?Q?ahIZ+MidiBOQa1zGisbrZOoI8Txy8xFh591LV3flfO+RHCZGmOao39cw35sM?=
 =?us-ascii?Q?B1TGugyhK0givBSwzPLdpfBNZS0geDvRJs2du+oH3JFTgrKEnKg1oBOO4TQK?=
 =?us-ascii?Q?V+xn5XPETUwji6s04i06v1UcYqL6qxI1hggEC6F12xJud61xyBP7mB3eqsDr?=
 =?us-ascii?Q?qBZTw+QhqRYwB9PgcenyYLkgl9dlqFhx87I1Rqec1hu9G5N/X8s5MPQx4ecM?=
 =?us-ascii?Q?/k1sbBLYS8+xnrnEjm4kC4gt3JMj/YVYIBR+GBY+bWbRzI0D7udxJLozcZbN?=
 =?us-ascii?Q?ruehec9Z11K/1xUpezY3RGDgofjiDs91OXAVrTOA/HMqMV36WYqfv1MlLI8O?=
 =?us-ascii?Q?hhR4u+vEeanx/OZoBBq1Ve5Vmglw6iIsG0noUtPntL7ZfZ2T+Zrjl/V+H3fO?=
 =?us-ascii?Q?5JjRJSW5rIPBTRHjUow0GMeCPARmRI3dBJ0R+ciP5159b9LAiwIi54o+z5z2?=
 =?us-ascii?Q?Att4u0IeSEGx7lTkIHZsdgBOP/20/KlF/z5RtywiCRspXX94PcmKPop9zpyW?=
 =?us-ascii?Q?S/UPbsojvk8rxzNsOdirBGPa4xjTgDb1GXyyD5mheL8V+8/omyzpj2YOwd+A?=
 =?us-ascii?Q?EEje06kMXqVa3hryQGRPCyaFsGtuFC8F07SfKXrLrBKs0FNhnWBlaaBlSVsp?=
 =?us-ascii?Q?9g0qq8bE8WbXWT2M6yonFJpFmoBPEdCBr9c/0k2ZllBNNU0TKgM2emZpPIKx?=
 =?us-ascii?Q?lXCw+/Hn2pr6t09e5olTzVbDBhg/I353tYwIq3gtUUL6qOk1n06QvLjB9Yvd?=
 =?us-ascii?Q?Gn2+ETLQVSzNP67FFWVXqNEWXn7LNQBKoL1TEhZdBupFdSp8+Vbp/iSNILzO?=
 =?us-ascii?Q?9mnD8TNAUMj+C2GPTG1HXHqLUnDtAktn+uyNVNUdpqlxX5E7SHOiAZEHjcSk?=
 =?us-ascii?Q?VBYSAJIap3JHaqZjmqPpNbcDPUYjxfjusINcDGbJ0R8EIXuCnrL5XT400Zh+?=
 =?us-ascii?Q?08XZU1CNJABc4M16NVkDAYFAtYOwvcePeu2x79KJZaRYp+qcB3fFH2x0z1Po?=
 =?us-ascii?Q?Je7rd20OTCr1jAR7slWAg81GppPDMmaVaui4gOb9A0F8+kZ3FA5efwcvjuFW?=
 =?us-ascii?Q?Qh2FlyNPafc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cn9l2hEW17ax1vKsnqusa0OxgbcpwhQyXSNFmwwNjozdljcqU/A+ouepMUV7?=
 =?us-ascii?Q?RK/IDQZQ7imIBVLjZmGgznIJGdGpjfjgK4oUNSoOuQFetZjszPv/iFHhSLHZ?=
 =?us-ascii?Q?MqRbUMYFSbSv9w7dbXnoHn2RrzUz8pORSvhkH54B62nrwUoV+U7SonocQHFz?=
 =?us-ascii?Q?6Oz8qpS3Qu/U/FK0qEuooUIiGmYxjWVodMxz9bTLhu4FpeDnX2CzpEO+049c?=
 =?us-ascii?Q?0q8luIcrqjRmyHk7zfD0PtvTdC2xAKr9Urooy3qsWSOLU8sKSQRM7Mlt4USD?=
 =?us-ascii?Q?HXVHAPPvi/wNYO9fPYGhPIGXrVJi1tp9EIPpA6CP6gU2FJjM2D3Xg/5fB6fh?=
 =?us-ascii?Q?/IhE4zOCbkP8aBxjt2BMKxYai7VgkSH0hcp6cExgV5YHrq9yVM2izcZJGLD9?=
 =?us-ascii?Q?qJdhYpznjDskdEC7md/KR7ddwIn44kcpPekcxvB6Le3RzYvPqvfwBGRlmPwy?=
 =?us-ascii?Q?/nrAJTFkrfFXHVzNH7KhTkK0shyiv3KZTUn2NQtDv/J+dGrCBze8p2poHt2o?=
 =?us-ascii?Q?vrF6lq+IdbwNry2oC7klO5vt+hH9pbkHmgN/lsV30Q5O2cCO53W9mv47/sja?=
 =?us-ascii?Q?DYBRkE4AtJfttrUOfwpJXuPRDsJbYmAKnXFw5nfXQEX3Z87hglzthp4fy/aE?=
 =?us-ascii?Q?T+GYO/jB6s2UDcQepgc/i1bliKoHz1nsqPHt09RMNOHuBCIB7VUewCQ6j7V7?=
 =?us-ascii?Q?K2pZhYLJEAEhp8MBLZClTAoFp6pX41K0ojsCPfqLG6CJ4Z3ki44gI0RAc5VR?=
 =?us-ascii?Q?isdAoTId27LC4yS1hVVesOtrtV221loLhdVZYyoJWPMU0uMTaRuPT4p1gymC?=
 =?us-ascii?Q?kyDsWWaldFClYDC6AUth4az3M2IHhgQqdubdNLpDRXXBQ9RRTNO8Fzo6pPZ4?=
 =?us-ascii?Q?jPgiEtEeLZg4fIXDcfJDBUamGdGY5IeUdGO22D/nzVJC4EIfrY/zyQ/k0MFP?=
 =?us-ascii?Q?+SZL7APBjaNdbqpPf8rIqiSna30xIaga/lWz44U/dOpMqKkJ2KzZloDs4mDR?=
 =?us-ascii?Q?GhR6wY4mgwXHtHloDscjBg0BZlc7pYm3Yc97i09c8/j1qA7uIoRSGnxyfIaU?=
 =?us-ascii?Q?FuY6NsZIPNFNJvUiCLB7X3TSwCukPkaqXySAXj2HXPnE/pAK5Qsd6knYSwVk?=
 =?us-ascii?Q?M7WlvbAyrt2oXBqtsjt8lTq7XazNYzddDYdJay8uY30FpVHb5E2LnZFj+dbC?=
 =?us-ascii?Q?ACO1cGdkzUfqBtuksecv7QR6TlocnG/z4Ql8bIs6IFQ2Ilew2J7k6ZixhVgV?=
 =?us-ascii?Q?ZIna/5KtIWA85bx8wAaLXQ6obSqXxkL+CLTw68wi69aqDROCkwxowggpNbCA?=
 =?us-ascii?Q?C+nPngq2OI5QfM5qdGrTAgARtO+NBFWvUDza2kgGK2g/QpUYOvvzeHC1nmg2?=
 =?us-ascii?Q?MEZ0HHjdZLs053YUqftanxyrRIkEprdqpC+tWnytJllVYl2JY+keL3KAVjKW?=
 =?us-ascii?Q?SsngOcHMfd0MbqJIbPxQ80gufaZmJC5UtB32WniZ/rgrWsnnvEB+4rlwjkQq?=
 =?us-ascii?Q?TvUPlQA82lV2btrP2n75jjmCHBLTQDnQ+NF963HKKkP4aN2V5zwCD/yH0E8G?=
 =?us-ascii?Q?8ZrIBDsER6EUv+K3kl8CoHxSvyWNIwXhCzuN+/evH0cht+IFz9IdSBMD78X2?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XmWRhmPz8QhSKfg5GIDl7KAcqRCH2Ubd1iCct4VCh699+kS8+W4e8q6LX4LzGaT9JT2ZHDDYMzwnUgKMryTDuZIHOhp3uz8BOZ8qXfGBf+M9q+mrT0qwItrtm05DKqc9BQT64txdo+9RJ3LERM3tIpxAGyhatwxXjneey6i2Dbtf8CsirVSOlTmgoPCIN8D9dge0CFdBEmfhjHoQDxSVszIuO5Xh6fjBD5xQf7Xh7zyrMqOSlsBaG+AaOJmJtC4l8QXuMGsKQNUfkORD+oIDdjtSg4nJ2gtAPedQKLXkhElbr9KE4a/H2vpMP/+mPeBbTuPYMUCU1TdwZ9KyHuPnYa0W7XVP9W7ziOLrk00dCvTSkSM3zLRzl2456VhgQwKDxDFsmS91SfIBmuXirUo7YPjUidE1pvz0Nm2UUUzrW8sw5gAvmUfacpDU0IvtJpwHqiag9sawcbq1JKHkHc+Sqim0o6hv1iGd0ZADiUZ2gZRGh+O5l3XmmYUJQwS57vRUoWLTYQAUbSxx1ZYh8gTYhFLzxS1J/7pL+C6KTnXPhpenIP+uvpjjlbZb7oq4FBTHlHSXUZdfcGT2DtH7RUqvSCOoKFaIN3iq1FtQCkMG7QI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ade42e9-9987-4022-f80f-08ddda40b292
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 08:09:16.5953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OglkLaem1FVouv+kiz6sLlRqQzne3IqvIha23vhHfdDpUsFavSz1UnRSNxtaV6YcsUEnpLq8Fk1U7pIKW44/7P0H/0TeNdI08moft95/S+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508130078
X-Proofpoint-GUID: UFVBbJ689foSpiH5U-rsxb0zONy8793C
X-Proofpoint-ORIG-GUID: UFVBbJ689foSpiH5U-rsxb0zONy8793C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDA3OCBTYWx0ZWRfX8ojILfhe70me
 hYAkwAv4iz0iEYdBtnLPHDnEHlC+cIgeEI+xMf7hUIfS3L1z/1jtb9ssX6rEFxgg6yAlp6Fuhi+
 1Qsnr5c7uIV+WR6dF50DJg90/WbP7inU2AZryjPJGjKXJwiQC5IV3TW7LBWPHYE0q5roOBJqD3S
 rvT+6Qwg2U3Dgw4iOmXgpnP6EhZpJLtETJ/A3/VjNyKfgwW66B/DYhC0MFMqHcJCFj+RTQ43Bdd
 Vc2E7BW9rE9No4FO+ju0awEK/wrHL8F8/RmxXUMjgS8ePZrdtZm10aIu9Iv6KMq8UbK7GksG/BN
 44KBTEpMPyk56dB/iwyJu388/np8RBeWpV6q9Uk8dclndIVH89ZSJq/vNX/zUXHoa2s5bhwukD3
 FWZnbYo+kx5hkmglvvaDzwcu774oSM4OThxMorOwB7aPBVuGT+Vzg8Sw17XZQ53vTSlLILIg
X-Authority-Analysis: v=2.4 cv=KJZaDEFo c=1 sm=1 tr=0 ts=689c4830 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=afshGVS_br9syxqHRkEA:9
 a=CjuIK1q_8ugA:10
X-Stat-Signature: qfmukpubtumqty3sm5nebwrys5cucqz1
X-Rspam-User: 
X-Rspamd-Queue-Id: 81FF2C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1755072564-932837
X-HE-Meta: U2FsdGVkX19NelfepTgOI9pogSKU8WhOZ22yD49UnmX8e/IEwmtBkPNJEAnBXQMVYgl3bbneHMsyu9lFoIYrCgMYNpQl3bMSliNRqUb+ZR83G/q1Kor62lcGLYZlx+6UvZbvmytCcqXdtMeLz1If1CKmBDJWBfAHB2i3wWyK3ozXxzYkjTe1K37ChaeDuAgDHlhW6r1i79bm/VswmySyyuvdwOqpUTU4jMJoaKOZS+f7oSRNW6qp552Mw6tevogxgH4MmVwI5ufdGaY1gp+1Mtn8L73ayLW52lh+E3KlloIBOuWry3HBpRC1kD3VfHXny9qjuTbkAbSecR2P46codO6H36HiVg/m2Uf+X6EJHARdIOVBYx4x/+6a7wUeeTIbbyxFZzFrUYbyATvMDfeufzNBCuwoGdFB2UsC5p0WCPKo+TAB2KrV2VNSVjR3owSW5sEEa60AApI1PO0cuzglSC9P7dygHRUQlodGtpWvptBLDfw3QG4X/OVrod5q7jZQDnUVVunVYGXuRXTNCk9w0KhtDcjkuisxm5hNTl1nNxgOitgRgmr5vhYkKwmAbQadvROErsrnC4dq+dKTNJnPMBQ1Potn8LPlpnOr5S0rB5Ozj2SC/VHaOzwcOeuCuySzGBG0alblBCJXQ2x5/S5Rcy8UsmYlxxWID4jn2iuK/om92XZpccVNe0efLB8kllnyWR5BW4DEwHmQO5CJMmG0+0yBQfEPq1crgudT5SlSrV3XcD5KtOMzVKiuBUSiVBkObwolQ+O64bCjRq/yCEQ6nx5ZQPRJM990D9Drsm+nZ3IDq61ThK0MrlSkiKzJpi0BuWmE4VdsmLyisx9Y6YaUmxiYw/LQAtenMYmr7z9/qsOk6jlFWCKV70MiJHTsqrEEhHw1Cbph4MZKrXAgSrDFThDyFxm5rwXTwDpTTXajpLcFpPETR8LwE5+NUR77N9vW+uECdkmJVWUM3c7qOE9
 serTBa/R
 DcSkvQF+a+ULnNgeRDPb7G7o8VnXQVypcdIb33AXoJhMvpdsWVQNhbzLwGPNz/UzJZz79Akn/wlqdSICJGTHQzNSZvmI2yo9H9Ihg8BMrWw1vxWTKnbl4TYJQrjSXR0wQi38U5rg3plyLGcInTtWT8PCSJnhxozDzoZd3C8Q7d3jt5/XSv04ugGWrKCip1ELDEGq+JINOocXQiDZbur8y+l8eJ3jqH6mmKMk2xZRheXGGutmh4Bl1LazQE90Y3K5ijldElajR2pIoLSUqWGId/FFJwVmk3PzWlEOiU6nJLO76j2BNPPpHrHmYqu+8lUUZDFcmLAGfDf82RQr41ZJPZ75Dyn9WVeqU8UwarI92lxbc+6OpAyzV2Lzn6NHFvzPYv7eytxRKP/XBP7y23gpzTQDOriIOLHEzE8ztKPtdU75rO2iwY+tCFynxt8uCRbW/JK3ZAQz0x1ZB+D+jTtLRrF6IYhdyNP426DJ0Ff4KMvzE8g8Hv19M/3hpetBbzxipX6BeyG6oJLLOePcsiDDj1bYO67Wz7hDLB4J5p01qx0UUAd9FZkBhXd6Wn7Z6MqE6MCJmM6AJmTz4ttoUhsSu42LAw47uuM/cb/+MgBO9dSGXcZYPvlaNwRoJjhu85tjvNnIXr4MGy54P0KRIsplUfIO3a7IakIl78G3FZONbAHB9tRSlS9PGNygvzsbrMw9DGWZU82JxWBwb0+fIW4FmoOwCBi9nY2fkh36EBdA+UaKMq7VVHWc0VC92N6Foo4biSMh/MuW6VCzcLBXKxKRxX7s0pXdyziGylOlANaA/pSD7GuSyCVb1JXeN4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 09:01:56AM +0100, Colin Ian King wrote:
> There are spelling mistakes in perror message. Fix these.

Oops :) I am the typo master, apparently...

>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  tools/testing/selftests/mm/mremap_test.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
> index 5bd52a951cbd..e289bb1112db 100644
> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -846,7 +846,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
>  	}
>  	if (err != EFAULT) {
>  		errno = err;
> -		perror("mrmeap() unexpected error");
> +		perror("mremap() unexpected error");
>  		success = false;
>  		goto out_unmap;
>  	}
> @@ -899,7 +899,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
>  	}
>  	if (err != EFAULT) {
>  		errno = err;
> -		perror("mrmeap() unexpected error");
> +		perror("remapp() unexpected error");

Typo in the typo fixup :P should be:

		perror("mremap() unexpected error");

>  		success = false;
>  		goto out_unmap;
>  	}
> @@ -948,7 +948,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
>  	}
>  	if (err != EFAULT) {
>  		errno = err;
> -		perror("mrmeap() unexpected error");
> +		perror("remapp() unexpected error");

Equally should be:

		perror("mremap() unexpected error");

>  		success = false;
>  		goto out_unmap;
>  	}
> --
> 2.50.1
>

Cheers, Lorenzo

