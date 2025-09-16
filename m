Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C26ACAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 11:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B58048E0005; Tue, 16 Sep 2025 07:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA858E0001; Tue, 16 Sep 2025 07:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95AD98E0005; Tue, 16 Sep 2025 07:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF498E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:00:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E37B4BC3BA
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:00:25 +0000 (UTC)
X-FDA: 83894819610.28.53AB935
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 45EE712000E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:00:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rJ10lCBh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q5DGSX5L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758020422; a=rsa-sha256;
	cv=pass;
	b=y5g+fjOu0091HS8dsyGK5qbnfPxI4RTRFn6NyEfuWO6Ujc8wxToFvxmpQG7Y9uHVeDI1lf
	UH2V8Lk4FyhudmwavHKnvnzrBWrlLscFuKFBuofEKd6VnsjtyFUuVM0HDpf1EFeP85IbHw
	1mBI0BHcjV4i2MoAP0IrnL0iQIkX5AU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rJ10lCBh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q5DGSX5L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758020422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ciKar7t5ljMdG4Bc8Y3D+6ga35dZedC7cc2lJvkVfPQ=;
	b=gf4l95muUEG1hGTYUSY7nqzsllwVUDXb9rHBtfaA6IENTkTAEOLH4dbjFZwy4mmKaHYpdY
	XoYXVxLZe36GKdJhGy9JoaESNKtUI9d2IOwEQJgKRpIPXq4g20zJxbMhgaAyZJxQBTpcNe
	sW/F5rR6wNDl/ZXEzgAAcYjurkZrSpA=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G1fwZD002375;
	Tue, 16 Sep 2025 11:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ciKar7t5ljMdG4Bc8Y
	3D+6ga35dZedC7cc2lJvkVfPQ=; b=rJ10lCBhACA6SQXEqmO88dlSvhtpGmJZCi
	XQJv2x7tyh99oYdOwxLfW8LrbE7+DQHCiElOqoP8Z+A5Z2Zsl5CPFszOci5idiFB
	PiVlCXT18DU7axTPLir1QcU+UgwpSeSx3FkS9TweX4Ez+kb++fu/TaVObHEfFx1B
	t0pjvmSy8y0F+1GZePGe0wVjnFg5v+ROq9xdG97LGmdpqQOnARUkXNW0iHAep1SY
	gBlLJV99vn6AyeTAV5RQwwp90Wdfksxkpjxx23HgwnPVgbkmuMkxa/yVyCo3yE4G
	caFjHPuBfZ/DuzwZjonjjt/P3qmpVJydTmt7f3g9feSfeMbgUxBg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49515v4a8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 11:00:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58G9Nuge027252;
	Tue, 16 Sep 2025 11:00:08 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010070.outbound.protection.outlook.com [52.101.193.70])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2jgdb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 11:00:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yAJRdefoSSJn+aCPMtZu3M0imChn8ZafOdy/HqTfq+FByL7QgSC+HStNsW7hSv021vFPVEl634TmdeZA222EHTu22hX8C6qpSSRx2JVgvQ3Y/i8t6BB6ujML5NbB4AgI078Lg7uGJ/YCwRtHZu0cKvyq14kw49DtCDfPqRps3Usnyg1PONXNpcT/GoNcmfIdKJTy/d3NNwM9skPp/9i4p6hETrdDXagOLpHdIzemucLvyX3xdJDPWSRo/DWcS6nt1230mAE5NHhV/ZtB/vimU+q80ItAFHXiycVlPVnh6g5YTQEeZKQwDjQeD3SauYy4ZkGdIYaCzKyQI2ULNH5leQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciKar7t5ljMdG4Bc8Y3D+6ga35dZedC7cc2lJvkVfPQ=;
 b=eshapPDpGmCKZTlTD8g1hNDqJ6kZ4ukIu5Fu/h3A40xb+i5TDhwOHJzv5bhWDj34EPWLIdmBZaHoFwgBfGvKUdkrQb5MRfAbrQsdYUrfzgPOgFGhYwW5ahK45Ey/R44GElXn8bs3x/V4o6S0jZu6UmCu4McX7ZCqkJ648i/KZlZgAmUvTC01khzBGDfdi2P5FAHEuuUYw9w/ybn4ycSG5XY9YcDHPbCqWhSbWtmtL9ohvhLVDmyi0dToxDF0DpG4erp4FsGyGJQCLJ34sFnqlpM9cVJ2fFSGg0+Re6B3fMFvbW1sfuLJysoqUAjn2ehnZXqkV5q7z65SJ8nD5rIdeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciKar7t5ljMdG4Bc8Y3D+6ga35dZedC7cc2lJvkVfPQ=;
 b=q5DGSX5LYtUcrhaVGTCH1cQ05lXklgxnIoSYRV/LOMSMhqff/J5EJvp+uGymxj2wzR9kMVLFWkdICFQ8fgHaXE6ob5++Hl47NVOfoL155QKD/TzK/RFCXIPnJSDU9Wp/n5QLNnJWejEWjc82hviMiQtQxqk8Y/mZmU+Q8sI0VjA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH8PR10MB6411.namprd10.prod.outlook.com (2603:10b6:510:1c6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 11:00:04 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9115.018; Tue, 16 Sep 2025
 11:00:04 +0000
Date: Tue, 16 Sep 2025 19:59:47 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.cz,
        shakeel.butt@linux.dev, mhocko@suse.com, bigeasy@linutronix.de,
        andrii@kernel.org, memxor@gmail.com, akpm@linux-foundation.org,
        peterz@infradead.org, rostedt@goodmis.org, hannes@cmpxchg.org
Subject: Re: [PATCH slab] slab: Disallow kprobes in ___slab_alloc()
Message-ID: <aMlDI_uu8_UZSzlm@hyeyoo>
References: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
X-ClientProxiedBy: SE2P216CA0093.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH8PR10MB6411:EE_
X-MS-Office365-Filtering-Correlation-Id: dccf12cf-db33-4cfe-8bb3-08ddf510309b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tB16MO6QAx0D21DgO0OZhjq+XM2HSG49dfkwlhgAsX535NPUdJqxFEqXiwcL?=
 =?us-ascii?Q?CpUiMLBw4tR2grqBRCmx2E4ktx1BYqsR86aGumNOPJ+F29csmC9qbwMJITNx?=
 =?us-ascii?Q?P/eMZOTvFVHdt8i7rZTH3dBiURFvdcE1YrAS0MHLNnbBuE0Yk9L+yAMCkWIG?=
 =?us-ascii?Q?9URWlMbDzmEnzHJA+MNAggJfkkzCNWRYKDf2YJp4kgNw4j2NqxBXSVY2ExH/?=
 =?us-ascii?Q?+iipBUk3QCsXyckCREuA5MuEXYkHcyCAbmj2+kGsq0ddnavkuzQGF94fz8uF?=
 =?us-ascii?Q?ipsdudhqOsHbwbOzYIGeDbHjwH6qDvhVUavgKc2AMq8JAlhdcVhiZKrzipBz?=
 =?us-ascii?Q?07ttawP3U2ZQ/iLXyxfL/45ILSbetT3rnSa3H92RclK9gD4FmPI8fJzAetCA?=
 =?us-ascii?Q?MOzeByIAxh/61nsGdNCg68dbYXBCDq78F56jLQ+SJ3NKz9u85EQwPEWTaPaW?=
 =?us-ascii?Q?F1GV6KtHU0/EOw7caHk6Zce1Zxj2WqfeF4T+HPIRyGRIDC+FNzczeBzjf7YU?=
 =?us-ascii?Q?PEpjadiNmVrZj4jKAqR0sngGL+CraAg6a1seiNJbIFnVZAfKigLOSkHabqth?=
 =?us-ascii?Q?gaNCfOe9lD8XFfqzXcQpRPPo2XiCIZBoEYNDNSusRR0q2Am165jbsp/DNKq5?=
 =?us-ascii?Q?JxehOsB2mScRFDs5mThylb07pCe664+9y+z2Mp3xrpxD2flnHHEpWj+4IjjW?=
 =?us-ascii?Q?egl/J0UfGxA61aTRGiex4lo/xiSPdRZ4dFRZ4YoBOZvvwIliyZWzQMWg77Xi?=
 =?us-ascii?Q?eKO9iKGYcsFeXWB9rMLAqXvGS+oK8fm9mmlFdR5MsYK+ZIUEExFJp5pavo3k?=
 =?us-ascii?Q?eZkzBpquXVPYmFF1KNLh2SXJ6nv1aFb2yGc24noGaDhRSM4lZ3cHaliFXB8h?=
 =?us-ascii?Q?44iOoXDZS/udt7xQRcs9SC23aRLMlpdBJat5xLISGX/bpcW8AbbXbr3CmPQk?=
 =?us-ascii?Q?WbV+/gy/OUuoECEMzNkKIIn+hfCnN78D7ii+YBoFa5qGBVx3MJDXL+CjIWb0?=
 =?us-ascii?Q?E0B6Dg0HF/QP0k1vqEhlAOU8X2r/CAYyT259OL/mYP8bO8022rDkYsaCytTY?=
 =?us-ascii?Q?ZDPtCU35Bzwb22IvgCsEh5Gizn7bhLQN5IajDn9cPB9GqNGPyowZI+eST4Zg?=
 =?us-ascii?Q?U8NUCad1qep8EAFjy8whChvhD5X/XyuAlfkE8LkUguV65mtcDDNL4KrgvBHy?=
 =?us-ascii?Q?49Ih68VRdJrFbVVd1gRIPooAFhVNG8e3XCwAWfrj5rY3AsTb1epOTlfmlRbb?=
 =?us-ascii?Q?2UP7xGPKcXtf5DXUyxfV/QwW1e2rxz0LHYp9bvXQjKAe4BpXPCCDvLDUsKko?=
 =?us-ascii?Q?rFjgZjJDKx8Ks7e/VG9Vb/qOjKQ+oFjgmYgSmJmUUnanUEJBsHapn2xemDSR?=
 =?us-ascii?Q?KW/KPudSM8d0CJGjLfVSpTRd3Z9J9dVz5zq2LtOgeqwHdAzYlA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6X0pMsyY0uLWd6IzA0wnn+TdyLuXmcMBDJ7DNkqD78kiK9Z3jt4nmG1V9YF7?=
 =?us-ascii?Q?crTXgJVV11n+obuM/fs214HVGPGYZMzZXXzH8dyBlX0f8BIWxChEkHZT6Aqz?=
 =?us-ascii?Q?8QSWGUVAINkEBKXcjtR+s5IF3q5uUkJJ5TpVHdBS6hL/TwvREp/BJYbQGUGz?=
 =?us-ascii?Q?zFAzAKnr/9Q/FEGPIv7ss4yFRsbLi5+GpIMcbMoiBm7htkqo20+Yu+76ss/c?=
 =?us-ascii?Q?TqBMsMC+xqrfqrF44egG0HrAXghlPYLdoN7e/iMyez8GG+wguXCb7CfB44TM?=
 =?us-ascii?Q?1QTXEdmiBWpZITa6oVUAv/+AY2KXmuKjRwyveUrNRiENUL2VKvTn4Slb0KyC?=
 =?us-ascii?Q?b9SHaEjYFv6ZnicPPUf3oQQSP64ZxH3DgXycOyfYgsNJ1VYgz1+FwIvdd+BE?=
 =?us-ascii?Q?oC7K7nHGxALzT66k/Lot6gO5MbabvOB7MIFj5H6es5KyNS+w/BSRg4TDXU35?=
 =?us-ascii?Q?vVf9r4Y5QZIF7oFgMogaShLNqjc/w/GYXpUKSgZ7qIfBXsXeIVEhVL4/ELtC?=
 =?us-ascii?Q?FJbLD7u7WTvhDbJgqjlo2fzTCpOjYoTtfR2ujOGeafafaHIZOQ3TXmhiwovr?=
 =?us-ascii?Q?OqmQV2ZMhzvHb4OB0a+ZgdIKYnt0VKFZIaOLNF/TXhz6nLnCTJUW7VnNZTHu?=
 =?us-ascii?Q?5YowfhT06ZDCX0x0mV87mjBz/CJMBJP6aGtROUCe5adodF3awwo4bKlh2z1E?=
 =?us-ascii?Q?8B//PB56tJDzvhqOAS8IDwoVIebWQoQxwjWPu0DPFsEUPIvyhqAtJhNTcpgE?=
 =?us-ascii?Q?V7f5uEIwR6BOZeUM3qi6UnJ8n+9S/KnjIph7jibqKXb6TeTadgqUn1UyT0tJ?=
 =?us-ascii?Q?b+UmLerwI4lS+WjOCBjG6ZJ0VLuBrGrvKy7cQMDLRFEWnI3cJGbxcq8S2/H/?=
 =?us-ascii?Q?clgon/RnqKVYQFZblhzYkTDI9JF9sgXPaQ0KUpy7bMq+EMTA95lkjzjtbT9J?=
 =?us-ascii?Q?00nPRltw8ftZVazTE2IHWBs2RYoexSA+ppT2rgtvIdU2OHKvpfzxOQOvfH80?=
 =?us-ascii?Q?rkT/Z9iQnM+Sd7ZRRPZmslnjh4BHUD8IqqeZk5PUwXMHL6ibGMfIKEMIg4ny?=
 =?us-ascii?Q?KvYDueBqBGbUp4GpDB6bzzch7cxMWyrqRSGQo9Wyg35tZxEMbubVFgovEClD?=
 =?us-ascii?Q?W3+Y1TL8Mp5hwaAUh7MDwSQ7vmYWCn5FavaPgRbvLQkpCvd6jiQnthtZV8ia?=
 =?us-ascii?Q?/uopKT3eEPssMMBCaUIxkPOvmHyuMm7KUXDOBym6RRpRPAN8Ymo9jVSiGBf8?=
 =?us-ascii?Q?7jTH+Py8+P7/jYOpxEp60Jqq7lJGEXebfCTQUpPCN0VwUZVHsRk3DMz2rEyh?=
 =?us-ascii?Q?s6q9eyN6Ng8mAtBky7rW8Vb+D12cnO660zzsjERgSkUJ52J85BO5IP8EWHft?=
 =?us-ascii?Q?6jFF2HUJhTWjFmY3/dMz/Z0MpAMwawIUZIiv+HwpXYCt3T3eWng3CSyx7X8q?=
 =?us-ascii?Q?y4eUWIdAEuwtKdBnVRn56hvy42XsPNS4eOMTQgEubq4MamDz7DziOSCKm9QS?=
 =?us-ascii?Q?DIOJ+ZXyggoPtGPDVyUP3DdBiv4fF0IKaDfAfQyliGfX3KN5fhJuBshlr7KO?=
 =?us-ascii?Q?PbEK4WRjY/xa+wBGVArVk7uaDY9ifBUkalxdrnIp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FpVqW22ZTu/EtFZImJ+S7tiBlibX89t2zKZ1bxQbW2ln9sfVqMKKW+GM1v6wTZYvx33cKxDL7X8MOC7yVbvPRv8BEk9o2poVHYQ8ojWHibo+A/OUwV0loBzjcr+mDKz5oz2igRR9TV1HuoFe58hRy1HTSLl7vXF8ntdcUTb+MpWlZqDgIO60aXGYxxLv7rJS8m3EyPmxbhm9iEpbx65xitkI42Vq8GZIvVDKhQ0UVRvglKTl24A8YfT4qL9Uer2Kks+be76tlvysmuT8RnC36LBr2ATZdn0EV26MkNuRKWOlkWh+vHvYhZSLJ3zs21iQlMxVvHtLH/buCrAj4eiMf1jPJGC+JQtW68Abo6vK5iGy0QE+aKAEjz41UYDWELIkAG1YNO3y9ZQomG7mMiUToZ4/o6kFWDz7bY3WspVQ8FIJuwB73yapvsmck/r6+TAotipKqtOvv4cU1OOQaHd50IxwcawM4y3XPxhAArCqNLNhfWIJDKt3rT9OoqeshDtI+5CiuV7DADT8OWL7IgdI6Kvb6IvLu1sjE7KXeJ6x2FhTg8X7SMqHkgHipG26h/KQlQSeLIZeyiuCTSCKSZvMmwfJFhVbG/1DPe6C2a3st+w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dccf12cf-db33-4cfe-8bb3-08ddf510309b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 11:00:04.5377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LIQJuJJqli3wcsEIWmgWZkOtCHUh0ISocxMwzr686x63j6sCPIXW39/YIC7Lyiy+KZ2e11MnrLCq2HSatHHOPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6411
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=936 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509160104
X-Proofpoint-GUID: tv5wWsJiiu2d6r9UVuQEX1M-cU2c0MbJ
X-Authority-Analysis: v=2.4 cv=RtzFLDmK c=1 sm=1 tr=0 ts=68c94339 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=hwdmIJrUtlIEGi64XYYA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAzMyBTYWx0ZWRfX4Zxgplvg01wZ
 BF//0XLfRr508QkywHUbxNucBg9zPe3cPDBuWQ915ASWyelOr/fAUE4maN/I97l34e8PoAqNbQP
 1q8bOJeFX+VrOzwPt493L/v6ZDe1YINdGObmYUL5lWmRXV2+o0SORsWgz1aFJl5+peOH7HDV3uk
 VHVl6Q5p7cDOkRgI6o5xHjvBuA/9ZiBEajd6n9LyHPX1Cq41w5Chz+VrjXXTm13g0dFU97hUZUF
 Om1HV8UkxFvspgdQmCz74NJlGx/Hb4r0lCk8GO0aRhE04yFL5ze2+U/5ANup5iNJTcJbqwpistg
 RXlug5aMRVD33GPlZhbcxsCZKkRr2X4wHb6r0mmWevXeXUu7mYrracFth2noY3RnMEzUyxFG0NO
 +TgbNLB/6MyQbCE/k8EV6VtQgyxXLg==
X-Proofpoint-ORIG-GUID: tv5wWsJiiu2d6r9UVuQEX1M-cU2c0MbJ
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 45EE712000E
X-Stat-Signature: a8nwugaarqxzinbti7pop5otthc9pqo3
X-Rspam-User: 
X-HE-Tag: 1758020422-511061
X-HE-Meta: U2FsdGVkX1+VvKM8G1IHiNhrgOgcqYO5PsgMR7xbZTnRrmrEDRfO3VOU537TzIOFXavSqmfzeIog3CfEA998Fd942CWYVUSO9C4TP+veczSkNqa5h4WeMY1J6ID3cgqwdc+IWeEhkBAQ20YOP2BBBFWfi+2WJqDWyS/fRGV8eKPvMNTxvfWUfXcuSDEWncCKdxfvJ5s2H/Snhu7pWKjCc5G74f3u4x2QjIlQXCbAHOTEJSIP5rvBwieWe0WlldXZKm5xRQn2yeqp7K1iGDIVx6yjgQ9r8AIyfHEmu3JRw2Pb4leJXp1BQ7mu9r72QbZhFpBvyy/EJV+86QHyh+uZif/SnvtAffZV1LghamCg1iEIjzG5yew31p9Ocdkg7wtDFuxjkLHEmYDylnfziJEMemqUsde035flcxpcJ4DlYlJYUdaaBhPb1NfL4C0V8ZVMnerYrW8ObCQjLK4e+000x+nBbPsCvacrFX6PRklVEIJ8ia9eize1bNGVtQB70FA7+faBuqT3n/xSarycDR1UOqTcvzStfbOnVEhQzD8A7dSJVRKT36fRwcoXzOe3F4eUMUjAQQaeOTwyxy4VlQixsjVFKWuLIBZwPu9vcG4jG2/LqOPzMNmPnRWNjAZsHlndS8rInmi/yCAMlhKYzcJY179WYdAH+kvhcmRgZfwmKg8nVJdlN770m+wH6qejtCGniz5xbj+MsegcwJCuY1+yEmh3CFHcuLTC4CAX+03ncptlMHOzneEK3NVYVheCFeqbCsdo85jVRTi7vU4VtJgzG6SxA9QlI2AIvs9T6dUZCjB41wysy7tMdGgFB3MxYPb5bvOIEk08LhR+9Mo2rOrAbePzUnkeJ8hIwT83pDi1tBBYzyB1/ZU4NmzH0wVlPfRlFrXBkGasyfWqOWwW8k4K9tEkSCJGUBOQIEF5giGe/BVlPnxRpCutm/XTEjea3SOoMEotMGHGmWdkK/mOEnA
 CwamizFR
 yWYWMj79OnajAVo/oW0WuDWYHYGSqRWo5aC4go+NtP1QROhZvJf31JZ3S8IHJT6OAz0m2Tf2GiRa3Y9SO25cImDjeuOlWofLHsRCXSbVd6BNCC5FIDBD/p8Lp34WAbP9mFlFKXMRHjnpXwX/nefQQcB9Qxg9MPLqF7zLDTalrLAqQHAE65Xx2mDJtCy1eZWFGHUp7jiTI3CSsftCGnyTHdi+UPLBHs91T0wro4+fxCHdQkPRB9PChoO7aKvWqQuiA9QIix9isSZ1CHpZzBb/r4eNRVnT6QimSbm37LNcYcnwyDumYH+pI4WaZb4r85xZXy3hcK1DfY057FMmd9qfgNYffMOMyl8D8p9oz6QCReEbSuf48kk82l3VNZSqNc+7W7HJm7Fv/xOUORfw0tQv+Hgb+k5W9dl2VM86M+aJ54Uz8e3DLJUCsF3EDHJa+8a7i4Yc4R3cCykwH3aMxHp7HfvNZD2pOv+6reurzOTFOgXNxPmWnJC+YzBwxIapjwOLjz9xNyQ+O5R09xHlMYLBqlOvQbM27gwVqqjKOtjk1DB+zivOYW7NHqZ4xpIj0mQEKpbK3xY7yvl4AHd/Vtq6aMrBZt3xnqP+ggGUci4wdfBwWi8IS7YsECtK/EmrfxlfnG79KoYiO+pw8rGFeIv429DHDOdPzRzwsYNJEimaqtCa1vniIRw4gcUE9sKeb4LNUFGLRGijlNPETdqud19phi/n9pyjvPG+TrxbpGC3Dk+sBsFWRXeP8R1XzxTk+CNmKcv72YN19h0AxmMTI0oTUCXKdKDg/qT++lCyhkZHttHthU3s9vKpp6GhrtzfS3zQUuFRsdlwU+1dgWuXxrf3YSfkcKWSh5zJyDy4+x4JAcG8Eos+xbIwoUFg1iRcj3cc+kHu77uFGaQAi3Kt5UmxV0JE14l3qMy7s57hecxl4znZ25VEDXIvrUa7V0fWErhJ8HijEEVXZ1fHyV2MLwy8iFY2Qcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 07:21:40PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Disallow kprobes in ___slab_alloc() to prevent reentrance:
> kmalloc() -> ___slab_alloc() -> local_lock_irqsave() ->
> kprobe -> bpf -> kmalloc_nolock().
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Maybe I'm a bit paranoid, but should we also add this to
all functions that ___slab_alloc() calls?

-- 
Cheers,
Harry / Hyeonggon

>  mm/slub.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index c995f3bec69d..922d47b10c2f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -45,7 +45,7 @@
>  #include <kunit/test-bug.h>
>  #include <linux/sort.h>
>  #include <linux/irq_work.h>
> -
> +#include <linux/kprobes.h>
>  #include <linux/debugfs.h>
>  #include <trace/events/kmem.h>
>  
> @@ -4697,6 +4697,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  
>  	goto load_freelist;
>  }
> +NOKPROBE_SYMBOL(___slab_alloc);
>  
>  /*
>   * A wrapper for ___slab_alloc() for contexts where preemption is not yet
> -- 
> 2.47.3

