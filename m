Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2ADFFD4600
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB216B008C; Fri, 27 Feb 2026 01:42:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041586B0092; Fri, 27 Feb 2026 01:42:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06D06B0093; Fri, 27 Feb 2026 01:42:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C79CF6B008C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:42:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87D5CB9CE4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:42:12 +0000 (UTC)
X-FDA: 84489292104.11.7023D57
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4806D160002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:42:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QS9S3wZu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="FJ/Utzzq";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772174529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g+yLIrsanlRY5REWZOCoJDkMaH9+7UWx2cqu1d7Ret4=;
	b=1IVOucK12A+dA2MsqWnFmycYoov1uaAoEvQF21t8Ml5NNkZQItzRCr7RgTi/+v5ADZK0AV
	/zphRACwvOa/IfQD1tqwQhEz0tMS8kDv8Uu0lMIZRM/zQJsztNiwFtjPOkAeW/+Jk8LRbw
	uaF6G0YsweqJGZBRA3nvsS43fCh9oSQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QS9S3wZu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="FJ/Utzzq";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772174529; a=rsa-sha256;
	cv=pass;
	b=KNJpCK6ZzkQOE+hpVEFVT6e4ohFXCDQRwmju2QPA3vKYZefxcPkJNbXPYBn2i21TGE/NtR
	UWYUqaIXvCE3sVrs03MJbBMkYYG3VNUpl+fAjCHvtekiI6qndrA7dmirTEoBd2lWgrBNLT
	rT+aW/xasH4Zv8wG0lqGBCldZ602t0M=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QLUAW51973023;
	Fri, 27 Feb 2026 06:42:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:message-id:mime-version:subject:to; s=
	corp-2025-04-25; bh=g+yLIrsanlRY5REWZOCoJDkMaH9+7UWx2cqu1d7Ret4=; b=
	QS9S3wZuF6gjj0xZaBSfWUim5Mg6yCMWwh0+jMSnX35Su5pMin2rRY0tzhfmUq2+
	jq+OjHJ1xuO1REry40SQVLdEhCc54KOPRcEbuoqEveiXFw9e9j9J9bnS178Y93SY
	xH5bNBNUzWh9R0TQEZVFfDJ/+M/PhtLk/9Aalyb/ALTcSDgxlWd4Qp1Y/Hs6MebR
	e4NAgbtaru3ADA2jS6hcJb2m/BroTLBitI0hg4ldiBkdGXA4iTs+xLHrnjYrbkPT
	FEmJvH3NqK9esc8jf05DMc4g7UmgMp6U2xJIv3aZSRMHWOt3t0hKF4aPKfcHufb3
	URrDpz6A4by851VeE6u24A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cjgs01y7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 06:42:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61R3na7X027681;
	Fri, 27 Feb 2026 06:42:02 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010050.outbound.protection.outlook.com [52.101.61.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35jgr9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 06:42:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FUGd0LQw8i9Yf6XZ2r8JiG10wN0r0pqs5AnhiT8GvDVDQoeBIOV/bnaJnjz8LDuycLdRFB2uz4Vi2ExtMrdyHLw2u7CnAzs0HChAJiKpAZk8Td0KSA1/VKAxPHml8K8iZKE5LH2IwU9Ti9QxsoInSwgRufJ45C+cH47BKV5WHadFSLaGvg44rZwq/kR+43nJQ2Vtt4zIIBAzu8i839VGQvhMJ9WIhX506f2OzAnxOhak5wTgJlMpRIP+5WdzAgeTw/pR8yV/zCRIPLzYFu7DtXbM8N7pyz4a/2P1Dhp6UOrgnGHSU8jb7BoPUm1LsGFzRKG2lpUKmBBQ7I/W3uJHkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+yLIrsanlRY5REWZOCoJDkMaH9+7UWx2cqu1d7Ret4=;
 b=p5vfHaNYfr1MjuTTEYK3O1NH2MBM98vWKkvKNh/7YY/n16RqLB1Z2hIx8rH0bM3r8lUAE3PwXDRIl1WOKYwidb/SP9jhQ2REBa9MlBYZcmuun3xTup/IHVRRO/SrSatIan+K9T7ceB1VBd/JrUAuUEvttK8HY5n6DaPq5zgTbmmSWz9zGlFsUjQfsH2IRJbFgVH+uP0Q/ii8/YBIN+X5fD26fqvHi/1uAFhsJIqKmo3NhUG8XimGvIM1B2d/pbbql1xgz6IPrZsbyh44cPZTj/Hi06GmYq+duv2U11G1m1lnWLiwaaIvj3ZgAm3bcsUj7bYv2RmuVlGFmHLLtiC93A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+yLIrsanlRY5REWZOCoJDkMaH9+7UWx2cqu1d7Ret4=;
 b=FJ/UtzzqKgqBs0numICD1Umd2TIUC7pwWeeqpqM8NhrW49T05X7BKb5dpcerzhDoP1x9NPRijsRmgr6YH+5zCguPxmcoBx9C/FqMciFrJQYu16jDJsYz/9L6aIqlsMoRXB7TKQpyiQHK1PiLz+nPNBdNRQpfKghY6NPRT4gXGnQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB4991.namprd10.prod.outlook.com (2603:10b6:5:38e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Fri, 27 Feb
 2026 06:42:00 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 06:41:59 +0000
Date: Fri, 27 Feb 2026 15:41:50 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: linux-mm@kvack.org
Cc: lsf-pc@lists.linux-foundation.org, Mateusz Guzik <mjguzik@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, Hao Li <hao.li@linux.dev>,
        Jan Kara <jack@suse.cz>
Subject: [LSF/MM/BPF TOPIC] Ways to mitigate limitations of percpu memory
 allocator
Message-ID: <aaE8rkGzxlB6wCTt@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: SE2P216CA0098.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB4991:EE_
X-MS-Office365-Filtering-Correlation-Id: 55344e32-5fa4-4f91-968a-08de75cb4ee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	x3BZOF7nfm5UKHuKmNvJ7kYzYG31QZOPJ1B6X78ToTqHUvA8jY6B++8V48B8vMwbHSGL7c8p7K7btXnFxBqWvFrTgVmsO0Hyje55S6B2HcRbJayR4KiZX9m3kKI78OCRkmnT5b6DZal0bj9MPvznFlI7fL8hZhzN6al3PtZjF6R0CXXmCF9Xl6MuphCGn0/XuhMxs4w7osJ6okc1zXVQb/rNKSInEZPf7GHfTfFQsrkr2cReYSjn1pRUoXWcTRn45yvmjlPa+ITLSjpIeHrZlgVmS/4Slqc/DotEWYs2yFn2vCI1Tomh4eHEZ3EM0fifRT4j10IhQOG9UOO5/4HFJmyK3Q7Xk/CTlmru0ig7fHvRWlLUNi4UvfmrBKx7CY8YWe/efMXoVl/Q0iXBdYTmz68H4LG6E1Dcyw59XXgedSYPcDUpWqNI3RaRIXAPtetorsntoQcowmm4ozVaNQpt3Ly30kENYpJYjW0hpfBgc681vu7R66JczHY/rdvjPE34tlYr1eYfXKqSQi23XQnkHyKk9FU027V+Qwoo9am+/cnmucqemDC55XhZyCDCS5O2qlX2ERfJx4LjsckaOzGcTx4PqTHK2Okl43KaDJiiwXFnDxV5LmhKlQU9QuO1HQ015h+pdpkpDTplyYba0d9Hk4H8Hwjm+JlaHgAxYdRNRnxE7o/8JRehF+OMsKLvFWvS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LBnaT+EtwaILE1xeI7ApTVvUClSE2/BpwpKVZIjLeajXZ/BGQjXzcKCVO10E?=
 =?us-ascii?Q?WgYOr/Dr4cpx2E8WZX6JGvuWzaByosqeOKO4380/wMra77aPeXsBTzHgfYWt?=
 =?us-ascii?Q?tKqCPw4cpTx4QuKkkLDplE1pim1IYFrGz1Gn/OC16O2MoGrfgkhlnpdJIO6u?=
 =?us-ascii?Q?Og+7J6OS5rzFYgb6qeLyhrAfOe8TuaZxHVYmdxlB3BQn8+qt7VznSNa1MSnz?=
 =?us-ascii?Q?JGBnImsWp7xzElngu2mJQO3n0cH+sMvuhXUdtg2yUImYfXzFXCuokBZi4zX4?=
 =?us-ascii?Q?7gMr9emxXQJuxOtddWq6UyzgngSgyYYgrMjRIqrdfQ+ENgUyJWEO3oIDw+D4?=
 =?us-ascii?Q?gvls26hEfnNN5HSyVnAVMiNgwZ6D76PSPBmvKM7LABUxWnqDdDiVuIhN5OoL?=
 =?us-ascii?Q?TzaNiR7bcUiQS9S2HPYgUhyKqgtGfc04hUOUF5NEZiTjrCAjKYTJmqwQhKJS?=
 =?us-ascii?Q?7VZrwBJQbuFH5qVgB9jJrJbxay6pEq+iQoSfD8TDjuY6hyps2V+WPTm1geIl?=
 =?us-ascii?Q?yJh73JpdZkwuE4Is6AyIWUAOx6iXcH6blG8OlSeSKNOEvkL7ccNHZbAeesTj?=
 =?us-ascii?Q?0SRl21BVmkraRQG5zIUsvJIG5V1gPrVqbHbPtW74iIu8cA6LwTiwhwFbfSFL?=
 =?us-ascii?Q?r68Nj5H+FKzeQKw/x1k0Q+HSgHCfWB0p8QIBoU8ptnqkyZ1hDPShvkLmjsEI?=
 =?us-ascii?Q?PwKqQQ4+v9hv7nclvV3mRyx+4D8EaSQy2K3p8buAcJ0p2XjSNlNGFgbB4wXe?=
 =?us-ascii?Q?4IQrQeI/GJ4vPFdE/rZnsMgM+bls8fephVzoeYSViayrlKXHJSAx+Fz/36ZK?=
 =?us-ascii?Q?nYpUdMG/lhhnHtVqw0hJ12GG7rbxV7Ua10uFlR1w/+dcatP9ylNjZpma2/ZN?=
 =?us-ascii?Q?vVOfDT2l9DuVemLpXOBI34M2LRVL5pnYYEtKzFi8qgMCtiX4LeoOqej/NK50?=
 =?us-ascii?Q?YFGf+TqcOePUMkD423zXK6yxw9cuOeTr6uuolZg2cxRy8qPjeUGb79iWCNg/?=
 =?us-ascii?Q?jrQqWi/7uTtfS9gPtVCR3bEzY1wo0YCaJpBmSdnuSL8L7c/sF3hIXe+44ioZ?=
 =?us-ascii?Q?a+lj/SQdpxNV/zTUJpyRV+23C5aETb2OJG8G2Xy77sw/yTzi2eNmNuL/vbJ8?=
 =?us-ascii?Q?psCti4ncj/9Afmp16LDmxAnyaW0pgioIB8HZoskljyUnTFNepw6z3xF+3glO?=
 =?us-ascii?Q?P0SM7cFIk1i+Lj3rlk7yYJx0QxO2Jv3ACMsELPZHGgKPDcXEH8u/KW5b5ryI?=
 =?us-ascii?Q?Di32GpT87U4L9jdjO6etKMSgzsopMiLNdG/wgAJBr4G5PxDbiK4Vb3Z0DKcl?=
 =?us-ascii?Q?8fWx0lujdmu3Jepb516CCRyz9fXLhHTe59QSjak/L9LVGxDo/ZJgB1srKQYr?=
 =?us-ascii?Q?v6COzVF+qOu8XZxIerOEZBUn1A3zBKrpyejTl3vKFCoyLZGyphRAaTux0INj?=
 =?us-ascii?Q?ij5aYicQhIaacZjSSemcLRJuccdLBJZTvGRZgdkOBWXHhvmbAPP6K8M6o0jq?=
 =?us-ascii?Q?QskN7A5c2QTeQr9DjoSWnuONuKPPHBQ8BCZ+6adRpzBprFGhjJLT+7XOExVb?=
 =?us-ascii?Q?7TX9O2NUQaf807Mmf29b+GyK62VxxZgbaYW2yHAkLel9EJZYB3cuUwQ+0ToU?=
 =?us-ascii?Q?/CrO9iI7fBJfXpOrp/eGjpsyGxVNiYiUBJPANXbmhaZQKcBhRNeBEAZa1+us?=
 =?us-ascii?Q?z52WraOwItYMfvWfvYbf66SYN314isAp+V62OgQCQq2RBmi8NXS4bDySSvoS?=
 =?us-ascii?Q?EtyvwGgO1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Wo4pxFVQXAcRlOWfXpPCOGLbLJD0Dd5qsiYJVL+RvjHZeoWce11a4fLnm+KARMnE8sGFkLCh5a4ofXhxo+AuA6FW4tcMNZg4WNKjrpBRvpTXS5p1nIP1Nl7n4iftCPp2P/+WAngrFqJuJJDFtgOWl9fQGHqg0Y4E3baDjUWxPgRPID1chXsTLxPZLFmqbMbZE/0iftyZj4UPsOwiQ5Mc7vjYYqYzRFc437axI/rAqILOLOHtgr/HdFqYPYdI2Nda4noAtrCm1T6Hn6Z5LiktFC6GOcHUZd6TZeL6V+uSstYV1h2n8408wAqhYNwVy9YAQ7bbB/Y3cgGVuDLoI/PJvt9IEgSromJ1fG94UImxXHI7AB7tyiv+QuBw04diSgDnYsiBiOAdI4/1eX7+fr4DTqhcjZKvTDyTEUNuHr8UAytkOlmcI1EPOHobboQYkLYdW1//6kCicysAu/ShFng1xGRfiNGN1GnK3pUvMOi6KE56h7ZX41q82mhehL2+FiTSzhib6s13r8q/O4C/S+KqknhV1WlTV4pTvv51cfOhEmDYoSfte2PE6HOnWu75HAi79nMrR6oeq6ozjtWZYMnDF2xhhYt24RMADKa0ELUEqXA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55344e32-5fa4-4f91-968a-08de75cb4ee2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 06:41:59.7040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uc2T3SB+KY5eKp0XBCVtR/cQPzObCbUneeaNJANUipq+qpW6b5R7VxydswQIWwCfbtto3oc1E154mTxTworxTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_01,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=993 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602270055
X-Authority-Analysis: v=2.4 cv=BKK+bVQG c=1 sm=1 tr=0 ts=69a13cbb b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=7d_E57ReAAAA:8 a=bGkT0FmL6r124Le223gA:9 a=CjuIK1q_8ugA:10
 a=jhqOcbufqs7Y1TYCrUUU:22 cc=ntf awl=host:12262
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDA1NSBTYWx0ZWRfX2mzo2G+kST81
 9r/myvKm7PKMwVcVuWeTjL79IAUKFOc9BQ7isstaWvfAD535d4sGxHkcdwn1XdEUHA27pE2CNYA
 h+89oYygt9dP4no3Fbl56cV40obJtAvUZltiSG+EDqhDeV7wXIQD3oj8/MVOQNrWovIYtr0Zdhx
 MHUjcX1bX4QUqf5TQJalx7B0AGR+ghKs2ihT7VrZyN0yJPEz62Ew62NFJTIhWy96TcWHxDioX+K
 cLeNF8NFL5yr+wZv3Y55VZlz/zMkNU0zU0EhvPsH2XC3TOqDs5C5rR21aT94HCMOrc1SrFJ/NMR
 A298J1s8UVP5HSuqDOrJrWh/vdYvBismKDyq5v8jMUH5N2y2VfL5ZSW07ONVABfpBl4qq49mM9u
 vwlUasiknMy5F9qjg/6tcfJNz1645cRrWAyVXNMOThRZ+hu7op67G/eiSFnvLaQbhn/DZwIzbgK
 UvsCAWHCz8JIQNAocWvhnBHhLMU2Gqw+tac+mMjE=
X-Proofpoint-ORIG-GUID: _gkE8Eof3_sk9lHAB8dFVN2BonQSMqRw
X-Proofpoint-GUID: _gkE8Eof3_sk9lHAB8dFVN2BonQSMqRw
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4806D160002
X-Stat-Signature: 7pkqds8mcx15as3dgj864t8t6344hy7s
X-HE-Tag: 1772174529-614195
X-HE-Meta: U2FsdGVkX191NDs5Ak7aCMADYvV8dyS8+EGEwLlVKLE+F3FdnwUtl59t/jGHIV0dg+9Uy1RRJ+S0lYLYH4YuiBS7er45+ivVYm1Xl+piHPfs+a+byZANC7a6XVgINMJ7pOPB2OWb3rtt+WV2D7IYFgt2UnLtUbetac1wPwhCMJgYYlSnUNBenXdLbOiqjhLxIbgp70D1DbGcW7n1jHa+JzgLNaedOTmJsMj6xruM+rbYNZ7Ne0F/ooD4SftH1AofurHvjCL7+fqeSHiyFbgHq7+cgp7xGnKJd9z7blGsn6pHD9EzhLlr4um5w4mWv3LWQ1pfj6tur6PXSg2P4vpRIZfxgwJir1OEQZVUM/8xfTZU/z2viTnuFJa2YjexWg5XebSq8XqZEY7iMJctuyH4N2AKTpXeSBy1J0PsIt4bcDQy4r7g5Z6IJn1XboCKPU/vP7QCLZARvlfehmxGpV1T42y4NG93cysMO3o1/dSuvWCoZ71WwnEroKMWMz7Bn47yGwdrRa/zN3hm75O08PTefn1258k0BomTRnsXI0XA2inQAXVrpeRzaShL9r8aZtn/Jjr23u+ARe/bKEdhzkgQkaVtzxryTGmrlFUMO+P5x3Z0Kq4Qyx8o3XE15krova/loED53j9qrO5b2HUUvCCRRMcBMHeBDuFyR6IBgnRH4BRcVgE168ZwroNL2WlGRGBl7k4rj52SY4UKwQRWEnfanDDCshjKYOxzTxu8ejuLp+HgmQ+GufjlhG8tfI6NyjHEDJF2agke2ioTnZssTl9gc4qYkKtSLgWPpZB/1EmL2fF+5hDl+jjnL1N//C89b0GpUfM3n74IDaEL0hv4RPuGcpyMie+TAgVDn9su0JX/uIKDB+jBNupbumkNPagXC52bH0uOsOE/yMR5eP4nuixbdF9RJ6KjDejxzVokQoHXciQirWmBWXKpiUxv3GvWAfLXN/DLI5IApVSZIXK56uy
 Hz/LbxoQ
 4afyvfTjDjdRPsfjl8u3dpldcqTe8CwWPdKeezOoXZSbkyRCL7kyGKvDesK0NpHenE9kRsl+OIv3Nr/gExqeHwOIC+KckrUH/3zozraSX2WqojErWDSIRsD0qJlRlDYlTigidGU5yZFnmVH1FUwzM/UhZcBvHGg6L0dB5uFtdZadT4ct3MJS5ko1TF9GNbu2MQlRzK+w1glcw8xbOUy4ww0sv50eEWrV/rbM3UEIaMovUc7kGrAAvuDve9C08qWPlx90koenDB5DOxoDojk1Uht1zJvopfJNYL6eGptmOeP6T80oVG6wLpMjWPEnYcKYYp0JVFM4pKFFg4/Gsy/tkmneyIibA6E8bYDp6z+9V9sh4uY7aW9FFd1NKo+RwSozoqE97XGGjL1zXBS7poPADPbiAjPdwi3RA3GbftR6oNFGWUKEUr6Q4vp9b0bmPLbxKZsaTBaJFVetpY4vfk5KiY2iaZ/xdgJ4/37J0ufHCf00e/wjFDI4OpkyFcN9IcWMkoZahQLvbnavSwymYWF9N0UeJ71DCraUZLpRIOaHzuLaIB3+gwIei2oTQDJSKDWgUQf9uUyX83w5ggRIYsQgmxvs+Ei0X5mZzjBIFGghmKs4OjUDxkG7Kp7Qd+nk1JumHKPfupCYmqUTAKcytykRC/ydT5EuOt363HDh8UBSeKwGbHNv8fb/oGEk3nFZ/A1KlDZsddUhmfAFdGKuN9lWgxSvBXapajG7/UOEiYgICdBD7chywCSngFP9YFUqDumCf+ubPWTnYcF/Zpg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi folks, I'd like to discuss ways to mitigate limitations of
percpu memory allocator. 

While the percpu memory allocator has served its role well,
it has a few problems: 1) its global lock contention, and
2) lack of features to avoid high initialization cost of percpu memory.

Global lock contention
=======================

Percpu allocator has a global lock when allocating or freeing memory.
Of course, caching percpu memory is not always worth it, because
it would meaningfully increase memory usage.

However, some users (e.g., fork+exec, tc filter) suffer from
the lock contention when many CPUs allocate / free percpu memory
concurrently.

That said, we need a way to cache percpu memory per cpu, in a selective
way. As an opt-in approach, Mateusz Guzik proposed [1] keeping percpu
memory in slab objects and letting slab cache them per cpu,
with slab ctor+dtor pair: allocate percpu memory and
associate it with slab object in constructor, and free it when
deallocating slabs (with resurrecting slab destructor feature).

This only works when percpu memory is associated with slab objects.
I would like to hear if anybody thinks it's still worth redesigning
percpu memory allocator for better scalability.

Initialization of percpu data has high overhead
===============================================

Initializing percpu data has non-negligible overhead on systems with
many CPUs. There's been a few approaches proposed to mitigate this.
I'd like to discuss the status of ideas proposed, and potentially
whether there are other approaches worth exploring.

Slab constructor + destructor Pair
----------------------------------

Percpu allocator doesn't distinguish types of objects
unlike slab and it doesn't support constructors that could avoid
re-initializing them on every allocation.
One solution to this is using slab ctor+dtor pair; as long as a certain
state is preserved on free (e.g. sum of percpu counter is zero),
initialization needs to be done only once on construction.

Dual-mode percpu counters
-------------------------

Gabriel Krisman Bertazi proposed [2] introducing dual-mode percpu
counters; single-threaded tasks use a simple counter, which is cheaper
to initialize. Later when a new task is spawned, upgrade it to a more
expensive, full-fledged counter.

On-demand initialization of mm_cid counters
-------------------------------------------

Mathieu Desnoyers proposed [3] initializing mm_cid counters on-demand
on clone instead of initializing for all CPUs on every allocation.

[1] https://lore.kernel.org/linux-mm/20250424080755.272925-1-harry.yoo@oracle.com
[2] https://lore.kernel.org/linux-mm/20251127233635.4170047-1-krisman@suse.de
[3] https://lore.kernel.org/linux-mm/355143c9-78c7-4da1-9033-5ae6fa50efad@efficios.com  

-- 
Cheers,
Harry / Hyeonggon

