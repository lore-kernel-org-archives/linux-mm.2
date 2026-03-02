Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC7BE9B359
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE4E6B0005; Mon,  2 Mar 2026 05:38:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9950C6B0089; Mon,  2 Mar 2026 05:38:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8943C6B008A; Mon,  2 Mar 2026 05:38:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76F5A6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:38:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20C1213C090
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:38:58 +0000 (UTC)
X-FDA: 84500775156.16.41F6C8D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id A96DC40008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:38:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E4QLzFQL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eGPt7rzT;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772447934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nsp5T606sa9KAnrxeB7f+daeFvP5G60squAGbA+PBYo=;
	b=K3Pxcn/elvHYA1Yx88kQ26dGAJGHTzstHpxCQchpHBzkfCfVJb5kTqUTYkHur27MinREpb
	2aJlQv5ji7H9/4N9bbrpyEscDX2lIizokWgptbJiUVM3Jq6f+qgIbeG3nXhMPtgo0sEKSO
	1sUaQWNRG4H+Mqrlle27BOeaUvDMnu4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772447934; a=rsa-sha256;
	cv=pass;
	b=SRLZstn9r0TN2K6Wx8uMF64L/Bfshs4fZP30fp0m18pf7VkipiUnpQP0IYWi9bHhCFr7tU
	9uMv9pIEUcjZ/Y9AxT2ms8tTSoOw8Dfbft3kyp9D4o2ci3ZrUD1m9gLcYNK5SjP6Kiz+vU
	MUjzvX6RHUCm2CT0Pv1TQUsid5AtGr8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E4QLzFQL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eGPt7rzT;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622AAS9w1958142;
	Mon, 2 Mar 2026 10:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Nsp5T606sa9KAnrxeB
	7f+daeFvP5G60squAGbA+PBYo=; b=E4QLzFQLS93pERIJ/BCVHtRPn5GhNFbRix
	KQgwb19tuGYl5Vx83AcMfhPmpbGxm+pugmr2qqrTsbSCZyfVVhKFayXD7d3/k93s
	3PofwZScbTbsP/JLRIxc3AL8tKeKVzyyatKLBaPqX/xedRk8qxsp9RML2UO2FsYB
	XpY54wW0pACw+w4iX2tDxhoHNfQdghyFWFMPo7zd2mzkgeDyzRbHsynAAQCRtHen
	dfaH1DyFMcPmQ66gTp2viV3UbEhmGhMy5tghPz+rWgBHGG8cBBaFxHBdasxLEZ7K
	2SwW2nv7ouUok8rF8w3gNDonRUIv2sUWmzf0dPplxwMP8lUrTVlw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn8jkg1jq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 10:38:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622AAjXA024100;
	Mon, 2 Mar 2026 10:38:49 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011032.outbound.protection.outlook.com [40.93.194.32])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8gqfy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 10:38:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jb/ZUu/AwgZ9gRZNeXdwre+EyHzdkli495I3JXovml3n1L+CwPanLV4HcntlSMYpbVCdaKy6ntpXRwnulygtal6V7RBBrpd9r84jIsbkBu2b++/z6EsUgUEUK0iL5hp4BfGY3tnaf8Gco2YmAGpQjwt/2SLnNa9l/Yl4Mdmqu/LL40sbLHoYZhrLIYmcjpMhQKemqthV+A6p3ggM8TxVnOWZ6MDwtbkGx4ftrLwRS4wjLJWJmUEsOuqepijgmrQnjVUxdZ0YlYSMwI9md6osAXhG9BZmXx02X/P7ckvJWGfO9+khBFdmi2oTAlDXhkKRhkEHbfjVebj2AAb59PkLpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nsp5T606sa9KAnrxeB7f+daeFvP5G60squAGbA+PBYo=;
 b=kc428gYsM+JSDB4I0LkVS7Mub7lL4T0JVZy78Ph7YDpDJNHTzahyZjaquHd20ZCAI6B+K0WS6znn58kq/crYy4fH7wMscofEN5is6GNc4FO8vBtn8Em4jkwB4e4KQL+8xAsEZxZOnrZ0w70ov86CbbugIGKB/2BhA1X0n2f/FZcdRxPB7WSoGnJUfxbm/lGTpaaVH1eqoFihvcVp6BWanoFJ8F1izOHOD2Tv9SczVkSLHAALjjAXDtXjbQX8jq2TyLypiNhX1D5qbv5icBVrrbNyKCVLBuDgHNC5fs709v0Y0VWGOKJs3XUpCzpQfponq4MjbhQgvMT+MTJ2ukHDrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nsp5T606sa9KAnrxeB7f+daeFvP5G60squAGbA+PBYo=;
 b=eGPt7rzTubMa0h9ITVP5xFass6LDSlIaPbJT/AakThePeblFgwCqGxKsYhpC/44VKk0Gk2sFlK25vuDxMN+2/HnOCw0woY742zB0S+ZqmS7LhvmSw7wP+GdAfHfTK19x7XDjIlFxHQXfOJ1Yp6Whf6doa3D6RESWAntDgY8rBI4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB5008.namprd10.prod.outlook.com (2603:10b6:5:3b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 10:38:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 10:38:46 +0000
Date: Mon, 2 Mar 2026 10:38:39 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Harry Yoo <harry.yoo@oracle.com>,
        Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] MAINTAINERS: add co-maintainer and reviewer for SLAB
 ALLOCATOR
Message-ID: <96fe53df-0bff-4540-b219-6aa8ce35984b@lucifer.local>
References: <20260302101345.36713-2-vbabka@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302101345.36713-2-vbabka@kernel.org>
X-ClientProxiedBy: AS4PR09CA0022.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB5008:EE_
X-MS-Office365-Filtering-Correlation-Id: 95509c21-c79b-408b-dc62-08de7847e1f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	PonZuyBUzgd9oJwICd/T1LoDGXMFbxWsFXRPThMWGXZl5cTUMzWzI0tLZBTGorMZP1G+xBIvHNHhBjSWxy+4cav2xbwE6+Ld2onOI/WsS+LV/x7D84hU2rpoepXvhr1SAhVx6J+Bn7y4I+jPVxXUpv97+x4XqAk+nX6R1g7Hil6fcB1mVX+pnNz8I4kkrGyNyfYGZ52c5DX5Qw4yEXcov3+HXH4Do1GV7zhXG/RQFj6X+GUOfYbllwaBhzktAE39dzUIWZNIJyNedLF/B702jrj+6DG6W8rDywlpk86JS8dsN7AF94KdjY+01UwPR7BFVK8tBem+qSXh8VBv1tn7wcS77Y5InAHH5S/jwF/UPEIeiuxC+R9zQHC/GIVrXVTeMZdFKLz3SvvxlZnSLzM8AiDp3B9KnBDPltD7O494feiNChrDoVl4rcM8i3O0/+UtlaS6whpjUGVAKIPCswb64qmtK6DwxwwBOSDLLTNqGHY2aqEskiwnk2uClefmuvOSgKcdB3rWVAozw0stjn4bPSnNlf7D32fsqeojn1NlKHUqwTKswIL7LEuIUtNpp/1xyN+H4BpErsVlDOP4aelqkvJv9/SU5VQpTrj8/YIhilnNmF+P4j8u5xzQ4MqGdR0m/R/4n0SQ1tfnqj1nfrUzgXM/15VF55pbbFIHjtqOtkfplFs3KqNDRH7iJgRaLFwJL8VI/vaJOm1nodsuGk3GKPHCzslQ2T5U9N4N/b2Qhgs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2+ldv21Ro5aC8a5KGC0KRHclMXtyIuFuHV2Z2hZ6KKNtAZI5M4HrRfcUVJ/W?=
 =?us-ascii?Q?v90kjvSUmxg8vMvUf91M/r53ssPfCBDYYRQj/fElmWW4qN9290yHboVQuSFb?=
 =?us-ascii?Q?Hs3r9XJACXUHPK40a1Sw9tp07E7264LswjGJfZgpw40qGlSMPIhx38Q+054X?=
 =?us-ascii?Q?AzLriz7dVooHwx8v5sQ4KlxaHsY60+toFFKm3nDLwlxeiA16Bixok3u9YZ9h?=
 =?us-ascii?Q?0xCfuzSXP5fkjWtKwD61mtrNl4cy/FMrvMqfitVUvcUIaU680KsFNcTuQoFe?=
 =?us-ascii?Q?wTgxA2tAHAiHGmz0y/5D7f59KTnpOv5Coq2KsniFfBcJhKjdG1PS4eZ5BeYK?=
 =?us-ascii?Q?MiBU0+mTkR18LJYRf7ThXMTznG6HzVGnLTfdz9XRhsyHsr8RJqkBkCoSrrnt?=
 =?us-ascii?Q?OfKlmB8gAScxub0zYHxX9etG0GW6c8xruxwpZqvcVpmheO4pPug4QfVxYxHA?=
 =?us-ascii?Q?RPczCLk0/ojiDwxZOpMp+zeLAeJwrEGDwOzcdew7LGlLXbMd3a7ktSMF4FXx?=
 =?us-ascii?Q?AyQenQms4CGAlJckhjy9SIkCD3I2oPEbcZ8mEKDre2DQ3dsIQpejUOy9PFus?=
 =?us-ascii?Q?vVinlIYvbs/Bj+p9EmwmAt9t0ioc9+xcIQxnlY8Vq7ETgGFJNdYRDvrPHNUV?=
 =?us-ascii?Q?g9fa7UfzQUYiG0DSoIAPHnQllnNQy7vlR1xT7xSaoo8IlQJtOi6Y965dpnSw?=
 =?us-ascii?Q?3+J/YU5eD3DlHWDz5wxAfQrPKksnmTyXGL2f1xWMpFObnKL4X/qY9z54r+3z?=
 =?us-ascii?Q?YvrsJXcs4x5sj4I5gk0W6nAGu9Jh+bOehI5OhC1Z80Xf7yZrFPTWKsh3aR8h?=
 =?us-ascii?Q?aj6WbFJDqtQ02rcyByQd0TO0LBaDq5WJGIeGQq1mT8IOQu9OMf3uzZ+THgDt?=
 =?us-ascii?Q?aQ87Evgyd70eHb5qFdgZ2kzvLPGNHTnC1w+7HSV1ToE09XaotkR2zRqweLcv?=
 =?us-ascii?Q?DPlCXVopHbx8PW9MUm/johzHRZBJkIhg6zapLQ1Kr/mx+dB8FPPN+1WH+141?=
 =?us-ascii?Q?svzpEQNjQGOQPHJED6/hzfgqhqo/7bav7dJGX61J3UR12WsuBO3AjsKRAg0d?=
 =?us-ascii?Q?o32uGWG2+K29sQUOYCiGjpL6AK3DQRHbscOKluijFLGEOqgF73vy9CqcjMqu?=
 =?us-ascii?Q?0i9672PFnIpyjjJXaXc9DOaexRRkqIwWErwKQSll3LIPArRW1cxdfzP4wOYf?=
 =?us-ascii?Q?DDkl0o+Rg9eLwJb13nNnQJ3Pii+9alhPUtkQPbyogC0lMtdLs0pyYcnUraZc?=
 =?us-ascii?Q?YycECtJzNQuburTDywiUQijlKb5N1KBXCpfEJ085lvFWYFDjRK8dLKu9u6zr?=
 =?us-ascii?Q?/dOyVnuAa3KmP3TJWLdX+entIgfYbkx1vSBxeXlv5egV8aCePCwWBmHurk3S?=
 =?us-ascii?Q?1fTzpYeFhyTnn4N8xwWanExZpCPHCVpHwncPY1f2xkegQWqf2GIfbFzWUblJ?=
 =?us-ascii?Q?uq/JmaMZhez/v+8lMnA8HXt4khbmim5WTR95ztmGL2UwDWZrENveofPfi/TA?=
 =?us-ascii?Q?JTWYRF6Bl+RYQ9QpWCMtYDpV6Cq8ByBAuDGl/wZQR4XsEaUW/gXbfpVwLIKp?=
 =?us-ascii?Q?XvOnf0AAwbkkSrUivMP0MiyJ+pXwA3ZHmxxsNFaxWyUd5EhCOlPKWf2G3A5B?=
 =?us-ascii?Q?qtQSwCEIUsKVOhDYKVwvceZyi5Mvkfagq8V4KnE+r1spTzbpqfK5RGFgxDhF?=
 =?us-ascii?Q?qaQQeTi/lEdWFHUJ4w3wyMHZfC1m/FaeY576Qb01UvCxeGkxG6LycWDBBlb3?=
 =?us-ascii?Q?qXGfXG9PDyk14BnQcZiGcOSaEuv5vCk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mZ5rk/67DpFKmpF89XjRt3eDQC336H+Ufz/ZAZL2uIaR7awmSdMdl91JXFTjhzb7s6+mnkOQeNG5e7DX+oNUAhucLuoO+8/48N+zdqMWTdkqjNV955yu1PZAynN1+NZbrZJ7qz1tSjUAgM8w0HUw0zSRR9zAaRah8aEs6DCYK8tXfoilX4wTqkck0Lz7oCGSV8k+TpHoKpVTWA5XV3peDfkxbrsvbTaM7+FZ6RgfdlZPqI8PUIrIZDMTl3WG1a9H3jzLwk7goWq0xcJmIgzmnShg/K1ILGTSnAh3yI/ZgmvaWFrI38K0G1v8Vmk76ky5QkUxOpcL+d3eTA3A/NpS2qLIkSWR91kE2lwJUNZn7XLqiX+DjXpviVkSBMpwLF5juiOshkB7oYH8fltmCW73ijzitoPq8zzwKQnfTaQLJI81aXDKtTWCcEZ04GD2/it/Ipbm3Du0Wkky2Z3vEw4EfJ8iBkR/7wFDRJ99VJUxDzS1gdUOaLfoYu6epVRprRtvvR2EQpL3bgZpKNQIp56G96oEOqq+Okumz5vxWZmbsyNqiB0Cd49KSEbrttxN/31uOjpw+lkktZCfRs/b6WXYGW9Jqi+mu11p9bWP0wmF+AA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95509c21-c79b-408b-dc62-08de7847e1f0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 10:38:46.4951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6anRNIBWylbiLG/DvW1+SpgDnJFNksSBstlr4l7Af1IjpH+E8TpoMMO2JOeLHO9D0OAygTSU4EX7gJ6oKW9gll1+m2OR8dP/kskANdnGoAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_02,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=963 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020088
X-Proofpoint-ORIG-GUID: jqzlUFu5jXNSswOLP-f8fKuS411hukVz
X-Authority-Analysis: v=2.4 cv=Rdudyltv c=1 sm=1 tr=0 ts=69a568ba cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=PuvxfXWCAAAA:8 a=1XWaLZrsAAAA:8
 a=37rDS-QxAAAA:8 a=7FyOuCSCLbaznseSS48A:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=uAr15Ul7AJ1q7o2wzYQp:22 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-GUID: jqzlUFu5jXNSswOLP-f8fKuS411hukVz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA4NyBTYWx0ZWRfX4w8FYPS98ipe
 GdZSEI4Szb3nw/2j4GQpO04Ksq+RaVDj4g2GKoUX6jpNigoSvD1Dv8NR8GokzNGr2lg0BqkRr5A
 Zpo/DhjKQmYTnp828Dw3gy86Pjn218h+qViI3pfccRRDCQXbFV0iGKiLcTf9CXbuBNMiTAHWW6q
 52uidXVHE5CQJnZfMMHcS/YyimCsy71g6ljXG+b5wbJyCnixO3zgF1TiVylunN2gPyEwqzA5URF
 zT2hp67gpf9ZlK0yzpv5LyJd0UIJ82t7yl0Y0QQ58IyOtRs0oo/RfJZ1j7yBe8gNpcG1Ev3Z6m9
 SBwuLw0UEnPMHMPFarn4AK6z2wvEpyIYOWxoGzzyyE+U+YFLTOmSSbZPoQ24CiJFpaEyCwMaRb3
 /pehPI6njWuZDXOyrzfEBzZ5kw0I9dHeBPoXEJeiFBgVZLtGQPwaaVUEZRdfPm6aCLzVo+Nme9j
 BPLUs3GT4s4F0Jpch5Q==
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A96DC40008
X-Stat-Signature: be95783djrog7uih39icck3hazn5fedu
X-Rspam-User: 
X-HE-Tag: 1772447934-210096
X-HE-Meta: U2FsdGVkX181/sbnRS2FReuZYLU1bIMM5u4/C+8EmTgbkRQ3gTB0PESZWBHb6INeFhDGnCbrBPuiNJLyHXthb/6nYJrmZl9Qm0txXVlMj35DR1qES7jJU2nAn1QHYqb1tkcF/w6+fIZHetOGVRbYEm3Pc8jvFlKSybhGoFC1EV7N/HejOc2S6XNZlZfeBjswEQcO5xIbLoB+Js4LTgq9NcAeiy3xEnyuxHFNNIQKVLHPFLF5Zzc7LpiY+MWyAqSCHBg109yUqNCK6u9JBCjT7csFu05z/b14J0/2hlUlABZ1hCHjQAAHMWefuL0mP9kvHbcCXND/1G9VLcVu6S3RLCBK0Xm/PLkXJTIJl78/k/P8JgmIN6Onh6K7h2F1lZGuMCl8FQ+T536eoMIk+kuL63Pbe8VAUywjP2kTmc8k+6mh1+IQpzx46yjwc8mTy22W6/xozoYwVyUJPranXzrCBXTaarfOBJiLBDbcCxs/df3V/VrzHdutBe3m4J6CiFUroGvmOQpg9/psD75rq85s815u9nG63plNHT+LylRauAo7OywRAndHa5IafWXrECraKmgXePlK9X7rpQf4C9BNWxIfO1mvwYwlAx1Blh2y+yDwukH93izE/+s5eDqaZiGSRPLMs+579Mz2ysiD5tlcSrCk3f+ILqGo15WlMk21w1NTOjDdmsActy0ReQE1mchBZDna15+33HexzL8Ph2SgWgkMRmgoLH2pmdzVyMv72AxcujrrX081KzZWN0Bdy2uc3J7Ha1yc2bgocrBvu9yAiKap1u3/gzzgBVV9YTQKq8dX62Dmiwu9H6FBXbqJjliNDOfubWT4sntMiDujd9ggOE6qjpch0CnOpsNyj5sfM+ogkNANbtR5hEM0004nkGGXkVCG2O1k2A4gdt4By+nigrkyGATZ1fdzBuXJcFarYpcrrwXS7QwlLic3QrlWP9A4Y+Dw+J3fKx8YjVaaiAs
 sydjSIKD
 2N7E1wHyYuGNpamlgTb1clpCusFaPCnaGdDkWMX4CnmjEGYkhxF01Iel33kS1WObtkQSfO3I4Xr2r6sUaY5b/lvarQNk8rRv8MIPdm9TzlYyctliD6+l2vs3NRUgeCJBuytEQ7vVrZwrllVt8SXura3Ywn2Nre4ORnG36b5nQG8H9CVyiitkpzle4SxFt37DGE2tf//RiG/hwKbxlvL5rRNOewUvPqwfUf3zuM0tM6947PUXVfbEXlGjkQZC3kNnITAA6aoTiJF7DujNvYcoVfR6A6+aebklicG/7to1F4hpWY0HGjstST7WeiDP+jNGE/yneMJlfWPCf8zQFPjB2Gt85UUryl3PHGLRuQACvhpsKZVgRWTwLulhOQoTViZ8tg/KP7mQKTn6r9ECr37Wub8Rsg3kWgKzaqOns9sCDIgMuOi/VVibg5Z2IGXtwWnz3jbr8QxPHLhl3HehSeSU8pQtpVGkOhVSo7ZYNtvquMAg3YhZzL8NDQ9vskZ3aKgeOyIyUCiYk9ZKOm4Bjxhli5t791gnykNJyOg632vBxouJ3vysPJlcJoUw08Trhgyx40H3RY2hSMCYNjZA0/PL1N27QGW68/hUVoJFbz1eytg7ragsqbnPvIAYuIfK79ytrJbxno4UYg1mqQhqipIK8zVr+MJ16bA/f7BApnmlzGrv9BvMjKTFtcRtDFeIy583u9Imvihb6UXMKXxDBIb6K+Lb7l4xoYWLXdvMP9QzU/gpZcmAZ6Np+im7tBItZoSCkyNhLY4kt2OyEf/aeoExRpoNsnVzXVe486HFlHZZMxcEuOzlpicL/sjvxNRcvDEyBMbH0w9pAipn7iJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 11:13:46AM +0100, Vlastimil Babka (SUSE) wrote:
> Promote Harry Yoo from reviewer to maintainer. Harry's been involved in
> slab development for multiple years now and doing a great job.
>
> Add Hao Li as a new reviewer. Hao has been doing very useful reviews for
> a while now, so make it official and ensure the Cc's.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Very pleased with how incredibly well Harry has been doing, congratulations and
very happy to see you obtain your well-deserved first M! :)

Congratulations and thanks to Hao too!

Cheers, Lorenzo

> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 61bf550fd37c..5f3cc4193a8e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24350,11 +24350,12 @@ F:	drivers/nvmem/layouts/sl28vpd.c
>
>  SLAB ALLOCATOR
>  M:	Vlastimil Babka <vbabka@kernel.org>
> +M:	Harry Yoo <harry.yoo@oracle.com>
>  M:	Andrew Morton <akpm@linux-foundation.org>
> +R:	Hao Li <hao.li@linux.dev>
>  R:	Christoph Lameter <cl@gentwo.org>
>  R:	David Rientjes <rientjes@google.com>
>  R:	Roman Gushchin <roman.gushchin@linux.dev>
> -R:	Harry Yoo <harry.yoo@oracle.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
> --
> 2.53.0
>
>

