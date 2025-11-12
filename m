Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1253DCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 00:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3A98E0007; Tue, 11 Nov 2025 19:20:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175318E0002; Tue, 11 Nov 2025 19:20:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C438E0007; Tue, 11 Nov 2025 19:20:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E016A8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:20:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96D5BB7A88
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:20:15 +0000 (UTC)
X-FDA: 84100047990.23.C61DEAE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id BDEF8A0013
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:20:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KwCwPiIM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=G2hy2VgV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762906812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8Z1YxqzEbEnLp8s5gyQlzlaeZZxk6qK1faYN5hyfIc=;
	b=t7tzJYLAtAmP445lL+FgxNPMJh2v3UPn61+piQkl3RtKBuHmhcPX8uyJEqgoqJ8kA+kH9l
	5VwwlbYlhHv2eVzk7W6/b6A+qCOIM3g+nUTTc9i/aw1y12JeFtRejT5cRj+jscnm2Eok2N
	v8ygN2viGtgsm1/UfLqMAKajHobVBqg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762906812; a=rsa-sha256;
	cv=pass;
	b=CFouZ7ZRUuXm63AAv0gbIaGPzOd7kxhq4mc36iWQVuW4tX9GFHEzFR+H8cPJ+xMh9wAfNj
	6ISU1FAtJXDCOHpDmfPmIQqPSSC6So8rNpYlUj2PDsI/WbJvaOEzZSndOl/Y6rcR4g7E8K
	bhQwhiw9GpxsBIjYLB/joabSgUOUxZ8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KwCwPiIM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=G2hy2VgV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABNthO5031112;
	Wed, 12 Nov 2025 00:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Z8Z1YxqzEbEnLp8s5gyQlzlaeZZxk6qK1faYN5hyfIc=; b=
	KwCwPiIMmBmK+qsHYDwIAHMvH3G37W7ekkc0FQ5eeSlS32I6s0R9ea8SmZTidzIB
	y7tqLYj9dMbnx/+sN2eAmOAP5TUguWfwrWHGcorVbSY+rP+THtIr7iHE/WRilaes
	ZK/Y2agTllfYIM4carkipbwK7GxaDQEBOyPk8D/IrDVEXZ0ZLiUyfWbtSnG/4z5S
	aWmOhj6RUBOgzliwx6JIgqcQD+Jf/LAU2Vhy1gShzsMdGHXsVOlLdB4NkLp3fES6
	R2xxB5q/YD97sBetx2aWVr+85Eymawz7SJ1fS+L3//LcI1bxMJw8uPVWmS5KCDh2
	ohOG5FCjVINLy5xXoN4m/A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acet1g2hm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 00:20:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABLLHfp021117;
	Wed, 12 Nov 2025 00:20:05 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010045.outbound.protection.outlook.com [52.101.201.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaa1rvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 00:20:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PYnDwdyHCaC6ZPjCBVvtIqhPnWGXdv6K+1RQd5Rqj2yh4nacYeOkxNLSaVQLS7HdfbP5x05Z4iXIgU052S45YHlk3/S8xfgnNRP4OPjHO47r2+SzwhTrX900KrCPfpODA9rRq3GJLWtB+8NEXNso8/LVAt8m8s+DCrvnqapgFNp0dwhqw4awynmSy+Ad0K2Di64Z6kcXATEqsAJzGOLRAa8nKZy63w6hqW2D2StbP2qI4y+oWexzFJBifrLarTOvBsQeWhq2NRM3KjlDmIk2dQLe+8D/5tDZiFH9Hi2gntEKBsBt2hH7AouPjAxGkNzQ23/grJ8m9uWamkHKXVvsug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z8Z1YxqzEbEnLp8s5gyQlzlaeZZxk6qK1faYN5hyfIc=;
 b=L4G4mjHrrRUv5iTMjf+OcGR7+1e59KNfkaTHynjwyuhHs3KXAuUkIuHb5HB3OEqnWs+HcxhNWNLsiGqpwZtyhVXZqoSPqsZQt3fX0kipp3txGCJX2wFxAr4yhyucUkBh7sr+N+qGzv0wk8RElJYqif7H2uCXvdujPJ/sSgWGTBM1JGk7WXuysdOi6yHj0KtBn9fpk6PjVEVfwt240D3RfWNaxtE0O4yT5d1M7UUO8wYGWBMN45ijDGnOBLJ9rmRDCRhvGV6MvZaSJMj7j4PvmN5MVISBay2hH3nPRORQp7RljidKjGM4pymC/e+2Swpm6u0M2A8FgzKZS80HEyV3TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8Z1YxqzEbEnLp8s5gyQlzlaeZZxk6qK1faYN5hyfIc=;
 b=G2hy2VgVRRBSJCQaVOPMnIuFVY3Zt96Yx1lIH+6Oav7giO4aGc85Q3yvFU8CW+k1MMJ3QX+8pV9rKrvT6a8b5lidIuXeE0aNxBaMXrdaI0wkn50z6+yGoXQP7+UEtxYIP6qG6lf/kHAb0/NfROnccG8Vd7vFm495DuaSkJZqFVI=
Received: from MW5PR10MB5764.namprd10.prod.outlook.com (2603:10b6:303:190::15)
 by SA1PR10MB7832.namprd10.prod.outlook.com (2603:10b6:806:3a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 00:20:03 +0000
Received: from MW5PR10MB5764.namprd10.prod.outlook.com
 ([fe80::412:f26c:21fc:faae]) by MW5PR10MB5764.namprd10.prod.outlook.com
 ([fe80::412:f26c:21fc:faae%5]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 00:20:03 +0000
Date: Tue, 11 Nov 2025 19:19:59 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        stable@vger.kernel.org,
        syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu()
 retry
Message-ID: <kfqzb2dfxubn6twcbiu3frihfkf6u34g2rcnui2m63rbc4x4kk@dh3bxvpzpnmp>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, stable@vger.kernel.org, 
	syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
References: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
 <8219599b-941e-4ffd-875f-6548e217c16c@suse.cz>
 <CAJuCfpESKECudgqvm8CQ_whi761hWRPAhurR5efRVC4Hp2r8Qw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpESKECudgqvm8CQ_whi761hWRPAhurR5efRVC4Hp2r8Qw@mail.gmail.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0236.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::11) To MW5PR10MB5764.namprd10.prod.outlook.com
 (2603:10b6:303:190::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR10MB5764:EE_|SA1PR10MB7832:EE_
X-MS-Office365-Filtering-Correlation-Id: 768f7b96-f574-4c71-13ec-08de21813936
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UHloQWpIS1BrczRJTnd3c2RDRnBTRk5FdWdNNWJKN3ltU0pINlNuaStBVmls?=
 =?utf-8?B?QllqcTN5bndJTzRzSDlsS0lrNmIrZHl5VEY5RlJvdGkwS1dvcUpBWnovVXhi?=
 =?utf-8?B?ZWhUbzFVamxNL1BIMHIzanduU0RrT2xSWFE2cGl3ei9jR05WQk9KRFRBMHNH?=
 =?utf-8?B?WjBJS2cvY09ORFJ5M1UzNGxhTnY2WHJEUG1TOHh0d21nTjhsbFpqSkV4RjF5?=
 =?utf-8?B?dXRDQmdmR2FyRm9wRUlGTDNCMHQvVloxdWVBdXQzM3pBM3E4a3F4b3puNXZj?=
 =?utf-8?B?THAxeWJyUCtjZTZwWjUxK1BXMWxYYjhxWmhIaHZQS3FpQ2FkRWpmNHk5eVUw?=
 =?utf-8?B?aGppb3JOZGNZc3dJMEhXRmtubVZuWmhjcTdPUGN2ZXM1eUFzaGsyUmdrcFZp?=
 =?utf-8?B?dUJOenJWOUxOQnRNNGdMTTN1MDNhWVREblpEcWVOVjExWHdYdVVIaGJQSW43?=
 =?utf-8?B?dEZsMGRJMnlDcnpIT1pQUU0rVGEvK0RaV3VGUkdxRHNPNGlhTkljS01vNlda?=
 =?utf-8?B?WEVZTGxJT0JjblN6L2Z5UzZ0cDZiL3FhZHBpNzc3V1lsYlNkc0pZY0xraGNs?=
 =?utf-8?B?UEsyRHZuNzJwQmlSa2p1YmJLanN3YXlWazJFN2tiL2NiL3laN01veWpWNi9q?=
 =?utf-8?B?SHRRWGN3ZmpkQTZHRU5TY3V2bW5vTzUwaTNmbVpLZDdIcE5tQ0l5T0xTTXV2?=
 =?utf-8?B?OXVZS3JXVkg1UnZNNm4wWUlPMkpqalNXSm9rSWxWMi9ZTVQ0dUNGb2hNQlhY?=
 =?utf-8?B?dkpySzgwL0V5cXBhQ3NhdERPRFhBd0ord2trMjViRSs1aFVoWUc3b1pjd2dp?=
 =?utf-8?B?bTdlOU1vc1EyeFYwcVRtOHI4RFNkdndQeTJobDc1alhzSVZLZDlGZXFXNit4?=
 =?utf-8?B?UC9CYjZOYnVKR3F5anIvOWlKZy9oSXJwdS9kVTRDdlVTOS9mWTRwa0paODBH?=
 =?utf-8?B?NkpodkJ6T0JHdDNCOEFzZWFRMVpleHdvRDNGRENpTEZMNE1NU2I1WlhHK29n?=
 =?utf-8?B?RmxjVjRhYkRNZzcwVnNpV2xEUEl0a1YxWFQvZlJXNmk4cThQNlV0TmF2SHF3?=
 =?utf-8?B?dTU2OGZidTc5L1NLQWZpMWNoYmI4Tkg5R2pNRkV3MWVaZGxMQ293TjR4YkZ2?=
 =?utf-8?B?NW5OaHJmUFd6dXk3NFlPSWlPRWxHZGZLYVpDZWtGVzB6czQ1U2lWbEcxMlJ3?=
 =?utf-8?B?a0RJVTY4MUtvb25GaXZUWVMrWFlldFVxVno2MEJvQjJNMWIzTi81M3Mrc1B4?=
 =?utf-8?B?bEkxdEFFRW42ZnVNK0F1VndlU2FUTGFQbXN2SkxxTytxeStJYnd0NFYySE9m?=
 =?utf-8?B?WFdMcGI4SExSbG1iTzFPcnc3M0F2L2xvVUlKb0I3MHhFbHF0dVlmZGRkc1lB?=
 =?utf-8?B?NUVGUHZXQXhvUGw3eER0RUNCVzFid3J3NkM5ZW5va0tTQWRiaW91aDkzVkNL?=
 =?utf-8?B?VlpoMzgybGNuRlJkeTIxV1JIbzZOZ21JbTZpcjVKOHZSL2dwNkwvTEdQdXdx?=
 =?utf-8?B?VnFlWFdnU0xWTVd2N0lvNWF4MUQwYWtxT3JFcm9qV3pnek5VbXZFR2tPbFRH?=
 =?utf-8?B?UGFTdUpyL3VJOThjWk40ZUx1b3lXd3lwSThmQ3RSditJZkVmYUdBUEtKZEM0?=
 =?utf-8?B?YlpIK2NxVCtLdkVQZTcwWWJuNU45SzdPMk5sR3lKRVk2Q0o0REU0UGJyRGc2?=
 =?utf-8?B?Yk9PL0w4QXBHSENhdWZCQVlBTjR4clM2bHcvVjdydkxFa01xNVQ3VWZ0bkd4?=
 =?utf-8?B?bWllWGhKNkZ2TnRKZktTKzFkQ1hTUmo1VzBJbS9jWEYxMHBFZ3lYRDFxVjg1?=
 =?utf-8?B?ZDRHZ0txYW5GQUJmcVpKQ2I3QXhGVUJPTmJ5eGljdVdsSlp4RnVUSXZ3MEhL?=
 =?utf-8?B?ejNhcW5zWG1YQmU5cFRYM0lKQ2daQUhWTUpraTZobzEya3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR10MB5764.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmFPOG9XTHdWTUZNeVMzR2ZJSkJjZUhNTXdBbVFpQTBKcldCQ0dPcDhKQjB5?=
 =?utf-8?B?dTR5dk5vdzJuUnphRGVTY3NUY0pNNFA3UjRwaW1ydk02RmVvZHVCWEJyYm9N?=
 =?utf-8?B?OUhka0R6TWZkS3c1bFNEUzUrV0Y0RGsycTdKbExrU2JJWnlYL1BqT0hSdXdI?=
 =?utf-8?B?VEJzamV0dUhtTThPNG9wSkR3bzN5M1pqT2dlQ1hib1B5NUFKVUUvb0NZZlZR?=
 =?utf-8?B?a0tQS2FXMEhxUXNEamM2UW9LVEsxbGFaV2FxMi9XSDFpTysraEdhZm5wNjgr?=
 =?utf-8?B?ckFvR3E0MHlHc052alR1eHdWN3U3MnFRNVRkRVJRYk0vSnR4UURaeUxjdC9m?=
 =?utf-8?B?ZmprckFlOE52UkhEeVF6ZHNVcU5FRjVrTWlFaVpwNFFFdGdheW1vbHV2bkpo?=
 =?utf-8?B?QStyZG9kRGJqSXY0Wkh4bjhnVXJrODRTOHpTdHlNT05mckd5c2t1VE11dExT?=
 =?utf-8?B?TmJNMVN0SFZTQkt0RFBRK3hEUlpNR1F4ZFA3dnhnQXg4OWdrR3ZSYzMzVEc1?=
 =?utf-8?B?UmhsQUYxa3JHQnA2V3FUaStVSUF3SXJLbjNjT3kxZFRMbVpFUk81dEJIQ3RO?=
 =?utf-8?B?ZjhzN2pNaDIzL25ZZ1daVFdsY0NuTE5URW5ZaGhmN2wxd1NocjB2Wm5ZZk8z?=
 =?utf-8?B?KzZTSVNyT0k5WnJ6OVVVN1kwTG5pbUZLbTEyaWZ4MXZ3Q0pCZ0dncm5nVkZ1?=
 =?utf-8?B?a1BYenJ3RHVDZWREdFRqSDZCWGhGUmJaNnNjOWhsQlB2STRybkhkT0RsMjlz?=
 =?utf-8?B?bk10ektvSzAxTzlCdmJWNXBPSkF5bmNKZkx5Q1kzamh1cVRsU0lVR1o4V0Qv?=
 =?utf-8?B?Qisxa1VLRkh3ck9FK2R4QkZHTXNaK0YzWnA5VTNzc2FOdXRBMWZXY1Rzb0Z4?=
 =?utf-8?B?MlZLNG5JbkRKQjRwNy9WMkxSdDRzM3N0RWVNZ0tKVzBKSGxDbmVxdGZjU1J6?=
 =?utf-8?B?dFJFbzFOQUdBdDZUZk9ZUGp5OWtWdlRlbDNLcEFiK0tLeUhpV1pSOUZSRm1Q?=
 =?utf-8?B?Vm1PVWU1WitRUmdMNm1FSFJEanFHUVZleDZSTU1DZUJaQUE0b2xVTnk5RzBH?=
 =?utf-8?B?cStzRGVJeEEvcmF0NU1LOFgwUE9CanJQdUprL3RtQlhGV0E5bFREbWhkQ05M?=
 =?utf-8?B?cTh6VXp4ZHhHZ1dJYSt3TDFGK1U5N2lNRUpkZ2ZGdkh3c2NiUDc5V0ZPTmdn?=
 =?utf-8?B?Ym5DRnBWODJ2NUxuTzFBYlJEWWtSQ2FHTEtNK3lVNEE5NlV3Z1Z1MGdWbkhj?=
 =?utf-8?B?ZWdob0M2N1VkZlQ3NW1NVWFJYUQ2dWZVWnBhSEVFYWZHbXBxeUZ2TExQSlFl?=
 =?utf-8?B?c0RVdzFPMjBzVy9yWjZMOTNBVGFHSjdLdG9OUEFEMW1mTE9EdDdDU2xrbGcr?=
 =?utf-8?B?aFd2L29NV1RLWWw1NjFXMnRuMFd4TS9jMDJnaTZyVlQxUjBvRHBncVovSDFn?=
 =?utf-8?B?SXVqZWZLYU1xOHVEOXErVC9OOU5Fb0ZlRTNYRXVqMzhmQ2grSzVYVFlTS2F3?=
 =?utf-8?B?TW4xS09aZ0FsQUdkd21XamlKOFFCMUxXTjQvaittSGdLNUk5Rm5xQnhIY3FT?=
 =?utf-8?B?SS8wdFJlRi9ucFNmUW1zTEdFcS8yemRXeFoxVjZtam5kKzluN2F1QkhGVXow?=
 =?utf-8?B?YWhya0xPY21DaDBiQzExd0M3MnNyRHB0RTUrZ09EVEZCRGNwdmZ6dEZOSm1X?=
 =?utf-8?B?V04raWxRbmtrK3FodUJHL0M3aVFLcjVERmpRRVoyS2xQbU05aDdFSG81czBa?=
 =?utf-8?B?NU42cnZVbUY0cGhWUjNGd3ZtaVN0R1I3M3dXSXFjOGEzbzA3Z0d4QktMV0hn?=
 =?utf-8?B?bmVkNmh1cUFLcDhteEsrMnc4YWdtN3FIZCtZZnBXYmFIMmp3dkZ5c1NVUTFQ?=
 =?utf-8?B?c2kzb0FqcUZtS1pCMnJWQUE4TVJQSXZXRkE1aFNhNUhWbjQydFJsMXBJRTM1?=
 =?utf-8?B?bVlKYklZVVFUQ2xaU1o2Uk90RlBTN0ZOU0dlNEVQOWZjWmQyRjAwdll3RTdB?=
 =?utf-8?B?djJtZCtYcHNmT0xXRzh3RnhXdzEyeFlQaGRUU0lUT0dyb2YrRDUvQjltNjlD?=
 =?utf-8?B?L3k3ejgyNmdhWWU1cWxnQjNoRWxEb2pUMFpYb0FGRmZnU0VXQy9PbkdtZEhL?=
 =?utf-8?Q?YMumB4jVFQ9vfnpPRQ+AvFOzr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h1yp4KWjgEgZaUFFnJqxQ1PiwLYuz6ljKhCQnZGjNj0IVfUH+PRDnCMhWaheiFV/0sWY9/CTCgxn9fm4Z8l2BAEgo6TD1FdVrSMmZpQjkEzcq2adEDuoNRgvpXVYkc7HuNINpj8C/7Rr56U2T5Z9hwnqDGVqu25C8OBvR19BEYV/S9T5lgBfTiG7d463ooAJ4xz36TI18pDk/Pe6gAgZcQq8mmZr/RxOHj1Enu4qg9Oi4zgIJx2zabeisw2lI7qU6MDQfRLG80c9UCbrnJCHHxp9ib6NAAfPeD2pYEANd4OeqMlGx3gpfj0WCsUlinij6MLIc6O38AAswKxXwiYimSWlWDMDMuu3OV9YgOIodwqHlKk2CKhPbegau30mtO8OlkvcOrG2kgeimV1bKrtooSMvJqAvcs3Rif43l+GiY5kb1nwMNGEqzJnxiAhbGkVGrlZ52jCjf6MSApKsUCxB5RYuYQg9Tjfx5M+ZWFAlXXKpwLDL9AdPClSYfHqH4/NH2/HWHkPHhR0RxPIcLt8LyAneUwSfmI4Y7KUwTSNoYL6DurowBpatvrlZA9OapLwhx1qZ+8Mas+MVi1KAhX3whIyZ9MghULX2yWqc5ISPKsc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 768f7b96-f574-4c71-13ec-08de21813936
X-MS-Exchange-CrossTenant-AuthSource: MW5PR10MB5764.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 00:20:02.9438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aDO9MWskKhjCFjB8aTqGifQBANOpmnbB3aWLLSbZGYn5MBBz9TdAoHdF7xBOqK4yuVX4TfUJp1J26PfKlczKwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_05,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511120000
X-Authority-Analysis: v=2.4 cv=abVsXBot c=1 sm=1 tr=0 ts=6913d2b7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=edf1wS77AAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=hSkVLCK3AAAA:8
 a=yPCof4ZbAAAA:8 a=Z_gd7FxeyxXGMzO7wGgA:9 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22 a=poXaRoVlC6wW9_mwW8W4:22
 a=cPQSjfK2_nFv0Q5t_7PE:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=SsAZrZ5W_gNWK9tOzrEV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDE5MiBTYWx0ZWRfX1oVf7OKWQdxM
 ADFR6Rozxrdl1339s6SFOROkUVkIsp+jNUbIry5YzfQmGBus2DJrf2unvvJDrbGQEbPxUzxzf0D
 PZxw7fSoNG94bAdC0BBIslzmMUQ4pXR3VOuVm05U5r1CGtoFKMLE0qxEphSLLOVdMVd0ot4annG
 cfGeYPZt3zuEHb1EcLshPKW52e9k36GxepnJ4VKM3b8IjnCjN6JeN8NOkcRz5J5CuAYv8uwGDqZ
 NejsMnZkNovvxIeOrUgeHUF1K+G4oDKsaqulyfOrVnKd2XYY8Cye3ImUTeYBIyoV64Dv7/mts3b
 7xxdVS2nGdpy6axUQqlfxAgMeYWLNEcfek30ZN7cfR8rwBNyOrWt0XYJu1K+PEXPXTd/Rhy/c4o
 LTDxRTEsyAvhdrKuVfmQQpzW3FMGWw==
X-Proofpoint-GUID: 6XxpXFlvZTs48759ViUYNL8bIFnSF7bp
X-Proofpoint-ORIG-GUID: 6XxpXFlvZTs48759ViUYNL8bIFnSF7bp
X-Stat-Signature: oga9gtcimhpmkahzttobf1nrfge3yd8w
X-Rspam-User: 
X-Rspamd-Queue-Id: BDEF8A0013
X-Rspamd-Server: rspam10
X-HE-Tag: 1762906811-775100
X-HE-Meta: U2FsdGVkX1+7JF0znY7odx7ADi7JPUjl92A9N5wTbUdbzzM7wVNJK0BU6deG4crCyfpAZGACQxFFyrkn16E744aL0TUXljb1o+o/mpX1FwUp82H8N6Hh8A56vgorxUuUcqgpaXRJqaBDA9jnnk4NjY0oQ/XqRQqvjfnr3zUFrb6hj698gdwFmlOzrrRMQTAL7B7RK/kUHixpmMozmWECy845QwkKDebwPXhf3fohVHubgQZjTsiRr7h+1C7DheAkCbY+tHFI++GdaRakuQFqAG8J3FU5UCz1doRqc4IjxFlVAcpOY+gawiV3rUvwTrGKPanno2C+trto49PCUbTb9YwS0UdchDibV6+hDWuQpU/GIhYTsMIF3LkRo3BEdquGMwL9AVriH6YjL3f0UQOSuSqip2QvZ05/uYATkSyhRFHwI6eo8CigTdO/m4ou9SDNGP9XlCEs5lIPP7rmKPkSrkd+RlSX8N4q53LRi6Ianc57rXr2gbE0lVi+iwGArDvATOG75CapjpkLBWSyce47tf9RQEhBSsJ85Z0TStQT6AEHJtwVshkbvT3f5HSB/opF+KLkugUJ5QIUF9z9tUxblNxM7i+LGY08YrRMeisj8qUuTLZfoBSF3gv6A6sutuzwDNplBc7dH1F6Fexj9hVdH0q45IQLS+SIgdlRci24lvkA5B/X6MfkDkY5dGWqtbQzEP8psGUjT3TsLWba3AUlIsm3nmTx/1D3ZShAzlHN6JYv3aZ9Ecvx+Tnj3EYj5mD8/CIIAMK6NHnr65dGY54E34DsjPdETN+F1nGaNlvCkyuCw3ptlN+qrDhYewGOSoQxmFDFA4K2STGrpQ1uieQcMvddaPCi6sNxOykB3fqFyjVhG+qbMaM0iUqhfd7mDLeoYEGFjZJtBePdEjFFk0ATaRcXIYuAKhnU0UvEH3+a0Whf7Um8J6vPPzl7RPYnOlCy18vXhr5xNhhI11OIUMm
 eKHrBrZA
 NXtLnGhzINetwnbJSEksvqfDIiqY19xllSU11FxyJ0tngZKxAewOVb3IhFFE6R+1ZKAW/6mYRaDtjOy22bwN0VboR+wMtgYbiB9Bg5/6jtRYNtI15h/T144jeRmsy8bCocr89etwGFBGpESY4eZC8XDw+QcT6bD6Z1fDdT5Iei4NLxkCVkcYL4vMUtb3PRrb/kufqST2GktlFdHPcWODh7laORkiAGNaKJWLe5Rj08k0LUea04S1VIh2Mr5ZiHmJIlf7xVhLsSA2nZlN2ir4u/Lh3KhcMllDoeuBzWU3/Kfc+8Q834SZYKi+cKs6jzW334ULz6q2ifDfJUFvOydW6ZNVQ7v44Gt+isZ16ADEhWJLabU8Cl3Rfwjjw04l4SDhNEiL3Bsw4Pphpz9rWh2MPyd+XcEeai0SrwMCE6Ckw93lb4gkp5DWgTlS/WgMn2JDFVRVrTcB4hZQhg9MPwPL4owquxVcx9hltMOpZmcBTh/Hp2pc1IzDg8iSgCX4Opp1Qr8X2DIK8H++S1HlUffAGvZcrKEzHAPqB/vqhO03Cajqogz8XXkifTw2wJZZkDoaJgcLFep0Rk9787WPgRtU8mEiHF0moGe97xcl1HDZ6tzteMcXizzeGrAvvHr8vkM8NlOiqcgvXVo8rlsgzw2bDG6Tcr/tdvKqobuJKiP/b2f1bmgzEL2EEkZKnDQ2EaL8IJwn1as1riXl0i5OjMcDGnU2NUKcr9BdAbnkqI5nuyletIxKvT/Hvmxlmj8Wq61qF17T6f1O4aIVEgPdmjKPVNt/sGbvETkRkWwAAUnmrsScf4V3bO44KSn10HgkPq0THJo39ErR4meK801z9TzsClgRkyA21d/4mYdsbmyMs6RLCccH5O37C1FHf2+gor7TI6sDJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [251111 19:11]:
> On Tue, Nov 11, 2025 at 2:18=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> =
wrote:
> >
> > On 11/11/25 22:56, Liam R. Howlett wrote:
> > > The retry in lock_vma_under_rcu() drops the rcu read lock before
> > > reacquiring the lock and trying again.  This may cause a use-after-fr=
ee
> > > if the maple node the maple state was using was freed.
>=20
> Ah, good catch. I didn't realize the state is RCU protected.
>=20
> > >
> > > The maple state is protected by the rcu read lock.  When the lock is
> > > dropped, the state cannot be reused as it tracks pointers to objects
> > > that may be freed during the time where the lock was not held.
> > >
> > > Any time the rcu read lock is dropped, the maple state must be
> > > invalidated.  Resetting the address and state to MA_START is the safe=
st
> > > course of action, which will result in the next operation starting fr=
om
> > > the top of the tree.
> > >
> > > Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RC=
U
> > > lock on failure"), the rcu read lock was dropped and NULL was returne=
d,
> > > so the retry would not have happened.  However, now that the read loc=
k
> > > is dropped regardless of the return, we may use a freed maple tree no=
de
> > > cached in the maple state on retry.
>=20
> Hmm. The above paragraph does not sound right to me, unless I
> completely misunderstood it. Before 0b16f8bed19c we would keep RCU
> lock up until the end of lock_vma_under_rcu(),

Ah.. usually, yes?  But.. if (unlikely(vma->vm_mm !=3D mm)), then we'd
drop and reacquire the rcu read lock, but return NULL.  This was fine
because we wouldn't return -EAGIAN and so the read lock was toggled..
but it didn't matter since we wouldn't reuse the maple state.

I wanted to make it clear that the dropping/reacquiring of the rcu lock
prior to 0b16f8bed19c does not mean we have to backport the fix
further.. which I failed to do, I guess.

> so retries could still
> happen but we were not dropping the RCU lock while doing that. After
> 0b16f8bed19c we drop RCU lock if vma_start_read() fails, so retrying
> after such failure becomes unsafe. So, if you agree with me assessment
> then I suggest changing it to:
>=20
> Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU
> lock on failure"), the retry after vma_start_read() failure was
> happening under the same RCU lock. However, now that the read lock is
> dropped on failure, we may use a freed maple tree node cached in the
> maple state on retry.

This is also true, but fails to capture the fact that returning NULL
after toggling the lock prior to 0b16f8bed19c is okay.

>=20
> > >
> > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > Cc: stable@vger.kernel.org
> > > Fixes: 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock on=
 failure")
> >
> > The commit is 6.18-rc1 so we don't need Cc: stable, but it's a mm-hotfi=
xes
> > material that must go to Linus before 6.18.
> >
> > > Reported-by: syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=3D131f9eb2b5807573275=
c
> > > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> >
> > Acked-by: Vlastimil Babka <vbabka@suse.cz>
>=20
> With the changelog text sorted out.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>=20
> Thanks!
>=20
> >
> > > ---
> > >  mm/mmap_lock.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > > index 39f341caf32c0..f2532af6208c0 100644
> > > --- a/mm/mmap_lock.c
> > > +++ b/mm/mmap_lock.c
> > > @@ -257,6 +257,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct =
mm_struct *mm,
> > >               if (PTR_ERR(vma) =3D=3D -EAGAIN) {
> > >                       count_vm_vma_lock_event(VMA_LOCK_MISS);
> > >                       /* The area was replaced with another one */
> > > +                     mas_set(&mas, address);
> > >                       goto retry;
> > >               }
> > >
> >

