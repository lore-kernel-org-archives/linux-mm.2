Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58567CA0FF2
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 02:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8874E6B0022; Thu, 28 Aug 2025 22:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837A26B0024; Thu, 28 Aug 2025 22:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0B36B0025; Thu, 28 Aug 2025 22:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 550BD6B0022
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:13:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D748C1A04F0
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:13:48 +0000 (UTC)
X-FDA: 83828174136.24.3094620
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 648AAA000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:13:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hAZ9D+BY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s4wIv7fs;
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756433625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISLcwuH6NiQt1ABlc4f+srtEn/FuVjAndP7/uR+Xq6o=;
	b=sBtl5HqT+vlH0e3jwnUW/ROYnWh9dBdAI+IkrgGP3x82C7mjp8yMf97/enjZCBhWkVgkPd
	af5beHIZQCR1gPcwZLrH+XliejKvppKqoUhaGvn4WqVzU7/ih3GegC59IbFpVrbvhihxAR
	CZzelcDjLJV353E2zW8Xnk5rJTDfDEg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756433625; a=rsa-sha256;
	cv=pass;
	b=C21q10sfy3+EzOulrGcGPZZJ+anbGtLuqdvCmncYFESG/l1jDjQy31iJA2kRHay2b+hv2+
	pDhkg14152CeQ+0AiivW9zgTT3CSxvTIEaN5s9oaSLP7y2JfyDffUdg/+Hk/8orOke25ga
	qc/xzkD5TgdNVqGzWf9/kNDwpG0X63Y=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hAZ9D+BY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s4wIv7fs;
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57T1fxWE002776;
	Fri, 29 Aug 2025 02:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ISLcwuH6NiQt1ABlc4
	f+srtEn/FuVjAndP7/uR+Xq6o=; b=hAZ9D+BYsis6+sytd+p/mIRWQTUgrq5ICJ
	UoLZL0g8aiyh3TUYa52sY0+qFR/HtMyfMdKOwna1n3iq/TvmvridfMZcD0o6ltsf
	BZvMLZL3Z2C+6c0qu9Kkcfo+D5eXYCywDf6RQSVeV5pMLOgIKURgKJ+rgLKZPBX1
	95DW9oNp5DrE1C/+LhKlOj+WwtI1Gi70j/d/6x4qdjejh4HxMZcA+gTTPMjSCj9M
	VEyXFzmAlZwk7nXzuZueGNVqJW37tivAVnLA9B/3lu6smnwBujw43l5/nPfdC6ki
	Nxe5U7HkPTG56EGfiT6fUHY0t5sRw1UfBybb/bmNqfKn1AmXwfgg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q48esruw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 02:13:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SN6f2j004995;
	Fri, 29 Aug 2025 02:13:35 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cqpg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 02:13:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R6wdmBAYwB+Jxad5vLzb355U67P76zGRB+Lagzk0Iy3To/r4uFNCi/jU3x4g+4VYXzmO4guXG2ViQO7LaZiDyX6DDlzF/rK8qhM0XaN7+9TJ9wxJyxeLeVag7lVxJbFa/489GmxEM+/Oe8iIb9IY1Iu/cuCJ4vd5ISLeRmiaetkIeaF/34Cuvac7wunPk60hKueqepe/vPkMmgD3I/zYxn8gHb54Nz6MBAzgA6aGHtQdiz6mKSfStFQgZTubRpwNFw/b8ZObswC+BEiNWRMuvfM9JSOX3gn91g/l9VW52oNPX/xpJ7Uje4OKJv1zscTsyQ6vaZ0HMivFxNQzV7IKUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISLcwuH6NiQt1ABlc4f+srtEn/FuVjAndP7/uR+Xq6o=;
 b=P+A3h6+fp3X8MGsqsOQBdSMJyCHHvGYs4qNbYB7PYOst11trtqWxE8y7wlzeJu3iCfVwmQjRmKvYakIUhBBCeuTsIYVKZObi0KsJyO4OWOQwt8Uh1xAX2ZgbAHC2Q/EdvW8YFLJiDrBUK0SNhTWL67/YVemO/3z590OEfcUkqNGWYjU34zzGm6+6dtN5nB532BgfpFOLf2r8dyy5p6IfJKQPdrt24fNrtigPYk708FoVUVi49ydl2HUSRci9HM1zHAX/WHi/xoJzas5VJ5srSFFidFJL0eUh6VmY33slrU3BYmxkODXfhDcisFm7IeksmDjckQNJeAop3I/IV7cXug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISLcwuH6NiQt1ABlc4f+srtEn/FuVjAndP7/uR+Xq6o=;
 b=s4wIv7fsfBYKTesLKKakQ1E/ZnpnoGdwf+iJem/Ko7SXTfeCNyvYkemkK+JiVLQff5F/XoHMcZhYgIi0IKPbffDfcQYWUU2pYrysa0ObIGiXkFJSjoDwTxrXdiXUbEyXlbkvJYmCIa01pzoc91LokqceAI6fxCqwKM0vEwGrBHM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB6433.namprd10.prod.outlook.com (2603:10b6:510:21c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Fri, 29 Aug
 2025 02:13:15 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.010; Fri, 29 Aug 2025
 02:13:15 +0000
Date: Fri, 29 Aug 2025 11:13:08 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, glittao@gmail.com,
        jserv@ccns.ncku.edu.tw, chuang@cs.nycu.edu.tw, cfmc.cs13@nycu.edu.tw,
        jhcheng.cs13@nycu.edu.tw, c.yuanhaur@wustl.edu, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v2 1/2] mm/slub: Fix cmp_loc_by_count() to return 0 when
 counts are equal
Message-ID: <aLEMtCwuRzfN3wPc@hyeyoo>
References: <20250826062315.644520-1-visitorckw@gmail.com>
 <20250826062315.644520-2-visitorckw@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826062315.644520-2-visitorckw@gmail.com>
X-ClientProxiedBy: SE2P216CA0100.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB6433:EE_
X-MS-Office365-Filtering-Correlation-Id: 7db51ba4-b55f-4227-06e2-08dde6a19cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3z7uDZvX3z6w5zzK44i8YL/3nC3/FpT4tpY7C0dBty4Q8o7HHLL/Z0In7tpg?=
 =?us-ascii?Q?1YnC2f7hbD3/5Dl0uf2CSkEmVQCQvgcfox6GN7vcEXSKHGbqM49kLRHBZtpS?=
 =?us-ascii?Q?30EoLPFlS9dOfOM+zTkPxSuRGNWHsfTStLAJdu5LR1eh8T6BGpMMH4CD/e2E?=
 =?us-ascii?Q?SbmL0DFZa/cJ4teqRrmaR2wPVSktRkJHEeAN0/CY4sl/4xko4w4BOhUmgSX6?=
 =?us-ascii?Q?0B/ZdPr/CRLlG1Z+NRkT44AhHIUQiKVppR5Agjeznt9r0wwrJalvfs23lkF6?=
 =?us-ascii?Q?HIemnHfkAWs93XMrAz6iYr+uS1nokbHMUxj22L5p6e2NxgDKLs2euMaNyfPI?=
 =?us-ascii?Q?XfGv749zqrQI6v5lDU+8A8v0JLYPgGvCgZOvUGLJ7ic7Hlf6HeQXPqufIZln?=
 =?us-ascii?Q?IG3FAM9NUbBBRR8NE4N63VAjum+Lom9eZvGtjUeNjAtChC3ipJU8NY31oNWo?=
 =?us-ascii?Q?ARRXDQOcD1xsLGXu9rVvbzRI864bTl/X+6zszm4lNU/EFqax0rQIXM0Hg0W/?=
 =?us-ascii?Q?EhyFXodFK/fHsYT9+uQ5n+CjvQK5PqKG/bQS3YWksnqgzBRDYKG8KHrV5+cT?=
 =?us-ascii?Q?8QkXGkG7c8f3/Ncd2NXof1urGE+MQjDlV5eJkjFCQ7qb7Ea8Ji1l/kCtvG6A?=
 =?us-ascii?Q?vupszXiLzwZ59nTFZhB8XQEy33a53p54L0VIXqNQPs6Ns4B5Mu+RKMcuPX4B?=
 =?us-ascii?Q?NdWU2roLUeQO9o17vrXkEYv6brWhlhJ/l81lHvHh+iuS1VXjaVElMMzxMka5?=
 =?us-ascii?Q?Pi0kqDv/9RpxZcgtm5LOhMzHOvUMDyYaAZqJKw9D7YMOomm0TmYwWOcW53cW?=
 =?us-ascii?Q?AY2DN64ziqeaqlAHT/4MzYBvxdBKplO+E77XXKsNnz8IgyB6epcEoBfyr1L+?=
 =?us-ascii?Q?wTKGzE0yaWn9QOmqeCUXpg94qBU8OVsUfSGqDJGQTlRPRBmLTfkg/ljPfoAp?=
 =?us-ascii?Q?LlglPI6QEsjSJEHtwsFedQCUceATGnGcLQKtUCOWdyG6Xi7ldixXGfIbZjVx?=
 =?us-ascii?Q?+P3ML3DhdmMpFaUDBqVZ2U7uKsDhPqKRfzVVponLSFnI+xTtnQvhH33yzX0d?=
 =?us-ascii?Q?MowoU5lfHLdSmjf7U2rOARuGsv18SF3F4CAbFKMSSNAReIzYIAf24sZmof8d?=
 =?us-ascii?Q?x0oG5S6L60VF73E+M2PTMTtlw22sRd/vGjt+UEy2mEzFqpW0dhk2JL8WOyo7?=
 =?us-ascii?Q?sa1H/jWbeH+5twy9ei5V/iRTdJIrUPH/b1K3xxTB4xXvMhE46XX98v3L2/RC?=
 =?us-ascii?Q?4c3XkSXeqz9njeuU8tk4aBJoAebhQefXWbeNe455gJoOVO2Lxjnu2T79A/+o?=
 =?us-ascii?Q?YoNGSR9egxWhtzh9KVw68FMPW7OkbPHkY6sUVTHZaaZVVjNfiLr+V2uJ8WmR?=
 =?us-ascii?Q?VzQakoA0yOEsRoW2DRDK7mhkFGtrGRhmqNiZSki4i2LkujDuIOBRn4fMuh/K?=
 =?us-ascii?Q?39yG3fe5fAU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BhogtleQFLs8TPFS4Vq645vnqwUMdTMyOM2zb5QFCbFVeiC3pYLBNYwz6dVs?=
 =?us-ascii?Q?QISdqmYFW5ETh5w7yjlN0/role6foYHj4p9ks19GkuHRKynEM0CXHlqHi4Lw?=
 =?us-ascii?Q?+SDjr2sIlQl22Q3yDguHrohq0DAM7vpFkfY+jLxhKQ8mmOqsfhxfnaXSomUV?=
 =?us-ascii?Q?D6OWQq4zjItRN3ozpRVWREL3AGVhSyZvVbJSjlwyXzwWVAbcz6JyD73LDZ6y?=
 =?us-ascii?Q?LQ29sB1wGH1oqh5iw5RiUmd0mw20tHd+LcW+UIMXh/qwHd47hGsHuFLT5TpJ?=
 =?us-ascii?Q?iimFHZkqlO/kJILMg6bS8t9o/gAxnGIfhJrAECwiOg50DFdgpyBd6kuwS0RQ?=
 =?us-ascii?Q?A2QkCQAMgujfghGCGl0caX8tISILNH+wuaJKSDVHKzO+eTWVICQNvvWB6U2O?=
 =?us-ascii?Q?W+y1MxWm8Dq91WUrKpIZfvjLrL2lA6o638jl//TkWmSkchQe0RVcsaeTuiGe?=
 =?us-ascii?Q?6dMiQnqFIMeT0xTxrXiopsZ6F6h/OVls/8oN72TUV75UGyRfUFQg2/Ut9TMF?=
 =?us-ascii?Q?rYqkuVyqTGXCT0hXkaJ5fLoV5wwBGcMqFSgJlrAcYPt1AN4GI+JfkjmmKcqB?=
 =?us-ascii?Q?3uy14iZTxkLzGHGSEJ3oAhQmaGoUPp+jDV/qcKGVa5UWJT6Ca0qL8B70uWO1?=
 =?us-ascii?Q?mKK+Bawjn6cIE2Nl4SR9N5oVvq9rAr3s/zIFfZWZs8RYHLxmGkSq5iW03DEH?=
 =?us-ascii?Q?HrFA2QCLuev8t80/0IcD+hFf7wRW2Yv7cZoTtSI9yjkH6Eef61fVrypOtlQp?=
 =?us-ascii?Q?QoSRfMj5rm0dljQe2hvo7NScXKkOOp8yq1d3DtkwonOe8UON4x5MkuRRwp/Y?=
 =?us-ascii?Q?6wqH6owa1I5uPRrPKpIjs3FGA32iiT1tYw/O88WLS9znJAUmQ3z7osHp7jKj?=
 =?us-ascii?Q?hBSMw/OsSDPFuwlK0LC+5sEytX6Byu1sMJ/ux0XUS6vCBAdiGclBIeUzt7TZ?=
 =?us-ascii?Q?PqJ0CEwl0/UdTAHs0PqXYLu5L8XjLTT64J9B3YEv8SeOaRyo0rVUYpxvUpNl?=
 =?us-ascii?Q?UZRkMpi7MsLXfUQCr65QVH3D10WAKJZdlMjskmI3zDmd/BrE/5xpqFhg9Ntx?=
 =?us-ascii?Q?d1ePNaUBiO9ArVpM1a/C9kfMZeqEG48ngWYdFdpzAImrHSKxuFSxmbI3YifY?=
 =?us-ascii?Q?yiLutwsqxSOI0l+7Xh41P1pEsN3i7rf+lZJF2G+OEsKtd17wtSSFEWUIblX9?=
 =?us-ascii?Q?k3RA14+AR7+kmNIXrHMjXNiZjGRBYtbP0OEc0zF8Py+N9pw4TR25JVDKf+nF?=
 =?us-ascii?Q?KajSEhSaCP3buKqZ7L4cRTaHQ6rGDAjBL05KmgrwanLt/4+eGlpDfg4OYvUB?=
 =?us-ascii?Q?+BO0Xbsd5Q/aLhHSRlXI1z0ro8o8sxaYPpqAlCHU4hc49yxCY/OqRBbNWkBT?=
 =?us-ascii?Q?EiUIEQi14BgxIEGSPpx5wqxCJ/HAF9hwyAfLhtJ/N+buezqBPorCgRQGe+gn?=
 =?us-ascii?Q?nihiXRbkABGA50yokvjtGIhC8UDEi6ClS03mshf3AfZrD9DPY6hIYGwjpAU9?=
 =?us-ascii?Q?MtB9uS6yxhJhknoU//H7HqeHlHIt2Ag94Ke0Hz/UgQRPnl/a4JDraLxFSgEQ?=
 =?us-ascii?Q?XnfIq+BTtpHZ0Yjd3sqQ+j5OQdksKjKgBl+dZ3QW?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KShGE2dMI5eaZVC/loKX9jyKYoZDDr8Z8YJxr5anEmljq9grggEVurIxunafaPCaxCWleWRCP4nU3rnuGycA6JjhNfzImdlwjywea8gDhOA3ZSqWIOY1GkeaVr9WnMtL+ZRmKEi/EXMP/1E48fw7IJS5+b7Yi3ITQ6Zt2TOwRr973e6l/13FarsPFBlmQHhJSqdhFr2otEzUIYQXrZDMVUh8gMOwFl8HiforRwZz/Pkumd4Qp3KmCzCmREGlyUD9/4MFfnfvYP03bV8wP+tjfYNuTGrNDmGwkvujK9sIXZqEBjpirUc5goQIaKU1cMElBYPvix99qjqpTxT1ihlPkbKMzVe36oM/i2Jaj6VcJxpzw1rtNq0pggEW/0tXSTM9GZjd756c1WxDXiDJTdvbZ0Z1Dq2X0tZyv+4UmgGatY0IdKyNhrnnLaoAY52/zHoiVO3GxRGEUsk7qC6Dcq0RI1LgdgYk7MRj6nULS+FEc1Ko2tPNFd9vzGy4XijBRkvViR4rMV6o3uyHQWSEdPt0QWaTvlqpAeaflI7AuxMZa0VCw2ujJl0mT6YMTPXy8IExFDX+mlAly/hHt473Y3pOhABlpAhaxZF1nkR5CcAeSn8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7db51ba4-b55f-4227-06e2-08dde6a19cf5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 02:13:15.7387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K2KWe2aCgYT13I9N4pZz6cveve//Dkx2ZT8LncdEpMKYaaYicuD0x1sas/ipL6YfoyMrdhxtpWojUj2VbDzQ6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290018
X-Proofpoint-GUID: W3WbxE_KpnA69s2wQL_glPFMwbLtt-zO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNCBTYWx0ZWRfX9Wy+/6IARD4K
 F/eNWjiH0NB/UfPu0C/Fz8J+//vHZ8N0Cn3BdQrJujVveZZj6to4IUfZr8QUe1Px/bDtt7qSYqc
 iilaEBxCpWQG8FbzSCDmzCkASk9LgoQD5CwaShVkT65roiEXfq1wuvLA/jQIOlc0lA16pJi1fzJ
 m5/w29cBzv8XvN/RNaPrWCyQ5sLtVm8WDHGHxdvj3wAUCUApv+m7KQSET/B1KziMDd5UgMssmlo
 7W0gHmFYsa4yU9IIjs2Q+slQz6yTjNM/uNPgWrxBDVEiaxkIfq9kayLbDmFoqp1CbqYQLkDHEpP
 F58yQLUtqIFVeDDsd+575MV7CdD/vY3gBJKQtyirr/BdjVSGpjLBOqWXVs9/2Q91bojmcBKk1V+
 g79vCZBM
X-Authority-Analysis: v=2.4 cv=FtgF/3rq c=1 sm=1 tr=0 ts=68b10cd0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=LqTgufPIsQKCKt3zw6oA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: W3WbxE_KpnA69s2wQL_glPFMwbLtt-zO
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 648AAA000E
X-Stat-Signature: 7uj6be3k44ygigyssq1o4u7et7qazoji
X-HE-Tag: 1756433625-74477
X-HE-Meta: U2FsdGVkX192dh2m3IfDisNDuYfgyUvMsgEHbR08+J+92nCzi9yA4Ny70L39IDeQUP6CnCtfqwCVuT6SKGJEHPQ06TY0JRSta+n7V4lQ22uPTkqF67Cs8Rz/+mtmC/oxgE1nESgSKc77LScX/ktzUXXVXMZ0FQ1ep7tMkx8fkhB3Dbk/dISzxIDWUJsBTxUmI5/sVtDJVRvGq4zIQep7XJCbHduMekhWetP7GhKzXQvJiwJ/RtSPoyfv0R6aZHKdEMYpae3t36kZ7k3NG9WpCLWiNCG8Zd992WPtqp0oROBiNc/otRH7gtpUVH7T3tWQerbJqqhKS6ovcbQlXAmpXXNLjuierYKy7ZC573vAoKf/aW9gxnQUDK5ykthvFcoFVVRLF53VyPkl/5vKeo8UULytoxshtFl6mq5yLnOce/Zsb2WnMZpMyAsuGg0nTP7RUnLvHMJPiRehm6XPlP5kbmGG1LTFta9EYa8cxhWXKQZIg8aaEKLDHTyEv87AV2Phh6AMZsrr6rKPBwItRVmM8FjAtY98NCC4Pn8c6VkxiIt3jtsurPLyXl+iLiMg9rRQ5X2MUUzel7Tj1GG6OapeJM470f+aMQ4CQ8gajUkNfy4jB+c9QgI8PQHFr2TZCQzxs/YLktGW+OvRLE+aYcvlfTAEqFgYl/oF5Y6ZQIThQH/RYMq2hWj0ErULqcGWDxKV6Y0JyGkkIKYs+d3Qw2iEZVxWPw7czD7Qd9sPY6TUe2agvU9pRziKpKWsnED2d6H15b5lt68m3rjG65vYy4swjfT3713DS+voFNm6KZvOqOnk6dd9jTenFrrR9ZmCF496jXv2BVulElq6tW1uVytaGNZtrdj93Dh7EIO3HClONJOajSaSpIK7ty6jqR5KIUFXvLDO6H+N4nr5UBxKtUEkKiJHukCwQJg88zIEa2TpnHwQgUvJ5iinOSLFYh2Khl2Swrw0UtOHAoZadvRsCjJ
 /eVe9zYV
 fofLPnYcYjRVZC7rCnrsLncxRnAu/AEit2UtXP4wmUqYWU3oOPN7N3LgxxX0umFZJCsHLD25oaDDIKvUemma0BWDzy2VHxEHSrWNvkfbqL4uZLIGOTu5V07/PMukJINoEzyiRebHt5p6GDH4NwCWzp0l/8cErmY6/+TmyVPYaP+K8Ki0+gIMLwWSptI8aoVLCJfPtw6/aGaqHmqOgNmK5mz7D32HGElvP73atzhUf5aGYPTb9MpFoMGhApdn49ZqXAK8w2+8NHOEl2BZffSaro/NUoNrqTDbNdGmDsMg1edPzYBsTgotBnwDHokYDsPatyK5PmwTOQRKre3+G9VuKKLsX6/M7uyUT8KQD+dLquIRtIAp7+46wm/kQpVPPOx+mRmCPGFifYybl2V1qjz3jkaLop0D5AyM5VakgPB7/zpiVkU06LV1ZSI4z8l+YdO0q+5JlFYdvxj1G9fP9cCfQWlYmPtzn0wBoyVjdE0UHobkUvLpupWziWTtKj6xCffui257WOFtYMC8wDLi27Kr66/BP5cfNoI9omXuZRUhriBnh6uzqbyCwA4aH0qIDL6bjeYVUFZmzo/3HdMJSNysaV3Dj8eFzKOasHw3WcMKo1B978vQ2/Q0P2cQhvPpaG11uJvbH6a64tQMNkiqsfvCpWqYplW4Ol5kYsCyoIa2d1nHBUmT/Nt1Fs4+w5mO0Z/Obmt2Pw15ei53iu098+AAbDWnzEK9L0vivbvrGs7UoyvpthZoCJb3UG3iKpb0bV6z9oD9B7mLh+7Y+qbF+AHxNIb2ZkGIcgykj9GHDZmvO5+UbTkYY/8KrpS+OHiUniImj3qvCbGgYb4+NtNECEoTwKNEFovExPeUcPNgNafXj/IawRQsUOg57pv/PiuY85aGneiej2Igf5Ttbld9dCXsPPzufs6WAUYZMuKMs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 02:23:14PM +0800, Kuan-Wei Chiu wrote:
> The comparison function cmp_loc_by_count() used for sorting stack trace
> locations in debugfs currently returns -1 if a->count > b->count and 1
> otherwise. This breaks the antisymmetry property required by sort(),
> because when two counts are equal, both cmp(a, b) and cmp(b, a) return
> 1.
> 
> This can lead to undefined or incorrect ordering results. Fix it by
> updating the comparison logic to explicitly handle the case when counts
> are equal, and use cmp_int() to ensure the comparison function adheres
> to the required mathematical properties of antisymmetry.
> 
> Fixes: 553c0369b3e1 ("mm/slub: sort debugfs output by frequency of stack traces")
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---

While the author withdrew the claim that it definitely leads to incorrect
results, it remains true that the API requires both transitivity and
antisymmetry for correctness, so:

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

>  mm/slub.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 30003763d224..081816ff89ab 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7716,10 +7716,7 @@ static int cmp_loc_by_count(const void *a, const void *b, const void *data)
>  	struct location *loc1 = (struct location *)a;
>  	struct location *loc2 = (struct location *)b;
>  
> -	if (loc1->count > loc2->count)
> -		return -1;
> -	else
> -		return 1;
> +	return cmp_int(loc2->count, loc1->count);
>  }
>  
>  static void *slab_debugfs_start(struct seq_file *seq, loff_t *ppos)
> -- 
> 2.34.1

