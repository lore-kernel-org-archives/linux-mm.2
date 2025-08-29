Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 132D7CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 02:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 394128E0009; Thu, 28 Aug 2025 22:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344D88E0001; Thu, 28 Aug 2025 22:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5838E0009; Thu, 28 Aug 2025 22:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0702F8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:06:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D8691191A2
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:06:50 +0000 (UTC)
X-FDA: 83828156580.25.185E222
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 20593C000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:06:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KVZffB7L;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VHbO7AfX;
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756433207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xx6QB1bvfPch70kzCWvCjct0FRmDIksZuJnqZVyzvUU=;
	b=g3TD1b/pVBluFmrdQgeOQ/4JkyMi2+QfCUO1GrhId/x/RYNbyOL6j6brEyTnN+DkoF+/9w
	Ydw45Wn5mgR350GHHlbQ5N6awFdFdgBJkkEHpSXkoYmbVHv+qE9w8aNvdO38dMFNw8lr6q
	0AbfyaoemCc61Wyw+h4ars8EPLNWSs0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KVZffB7L;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VHbO7AfX;
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756433207; a=rsa-sha256;
	cv=pass;
	b=wtWybT+z6nIZDyScok6rSj5H3aF0pCnEuBOTkKCjTbTkdbmggxJqhx5vfqee3j7GkwuecV
	qtxVnST8+Ey2Q9dWOkdPVjXiukFeP6NFrd6+NWSmdZxzx1/mqdHiQqxBY/NyVk/Sl7wcXR
	8oCQaJg8Pd65tTEjjPhaMiNwygegoA0=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57T1frxM008401;
	Fri, 29 Aug 2025 02:06:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Xx6QB1bvfPch70kzCW
	vCjct0FRmDIksZuJnqZVyzvUU=; b=KVZffB7L6HWtzndVEavaONKoLRQu4Aymea
	ygzSovuJ50CpFNSW5Oxs8QoSA9+AbBWzyS6bwXfrGkIMUcFbdwEDg7WXyMaV3NUm
	oUAN73mTNFgk/YRExxjeerJgdPJZgq2Pd3MtLo+GHErEXl4Pn5HvmrPnG+BarE0e
	NI5GR8VwxevJ4JGSbPe+IBIBxSvDjb0obdTcRDwxBo7UBsTonzgvWCF8EL2GjDLb
	YwSw4XcIPtCM/lZrC8ALLn+sO2iffFcG2JwDxN7lGvlq2rEnM0eC5vTIswYG641V
	ivrjQMhRby9k+d7soqDawc+MPBxxoU7147TarZokxc1eNCp+JzzA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jaspbe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 02:06:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SNo7pd005309;
	Fri, 29 Aug 2025 02:06:34 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2081.outbound.protection.outlook.com [40.107.212.81])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8cus1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 02:06:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nkcnfN6s4o9nYckXyBrLQqLz6SrOj9GLwAZpLQzbljURMW4kR7gRO/6liKGkfKhYAAlKYb39FVF3TPlUWkL5rWh0yHP09ccSZNJ5At2A8jwhQdn3QmDFRmiL/UxPW8JVbDGkHYOE0FMqYXt4cdHvG6ozZ5o7VU7z6plCItLtP5TCuTXci3cK52ztoxUb+1xxNFehieEvIITL4amFtCTpNLONitCmjDGTcVeXanCB2pTByEBJrGi1uZ/9xw8DmmEG7C+c+hlP/qb2L9oWQTU2Va18Zf46RR0SuNjBmD+4fcn4ttsFMRvmxzHe35jgrxh2I5URg90bXZLe7xRrWIr6Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xx6QB1bvfPch70kzCWvCjct0FRmDIksZuJnqZVyzvUU=;
 b=oLrzjsV3mA0MFIiKm2U2FPEyskyQCqfOhINSQrZe8frdMnnJGuGLz/EPVxx1Qpy2rz/Lh3a8CMrh4IOMAmm6VqKqB2S5ax9H5JbQH4FOeg7K66joSsBXDRMLoQ+Ys3rTH073upLaorTyIsyWDPR4kP24I4lH9TrUeVG336yEhGPBsWBEfncIHlzriaEFNPJBdrBkluIm7Hcu6QJ1JIpssQB1Vyas5kBrsX+KobnEmw+0Agg8GFZHCGs8Mda7pQgX4XcE5VtSLGLS/Oh/LOuZQ5U5yqrE4ISazxQHFWUgnRyPUuOeSEXoAAxqcwhQl1Fl9KPKYIQYu22YkKZtnJu1CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xx6QB1bvfPch70kzCWvCjct0FRmDIksZuJnqZVyzvUU=;
 b=VHbO7AfXtGlSONzKG71r+PKkVCmbX++IENVRdb1KRnThmnv4TvO5ZzUpl6hL0WK467Xkzq7PfdWLuNKXqd7UAK4h9JC0x0GY1UhnptO77cjtMiGebHDDRD5yns28nViwbSAVg/1yA6X3JR/jzhizRu8g2JSeYVPIVeikWNegBjo=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB6713.namprd10.prod.outlook.com (2603:10b6:610:143::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Fri, 29 Aug
 2025 02:06:28 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.010; Fri, 29 Aug 2025
 02:06:27 +0000
Date: Fri, 29 Aug 2025 11:06:17 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, glittao@gmail.com,
        jserv@ccns.ncku.edu.tw, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joshua Hahn <joshua.hahnjy@gmail.com>, chuang@cs.nycu.edu.tw,
        cfmc.cs13@nycu.edu.tw, jhcheng.cs13@nycu.edu.tw, c.yuanhaur@wustl.edu
Subject: Re: [PATCH 1/2] mm/slub: Fix cmp_loc_by_count() to return 0 when
 counts are equal
Message-ID: <aLELGQDzpjmQ4ppP@hyeyoo>
References: <20250825013419.240278-1-visitorckw@gmail.com>
 <20250825013419.240278-2-visitorckw@gmail.com>
 <eb2fa38c-d963-4466-8702-e7017557e718@suse.cz>
 <aKyjaTUneWQgwsV5@visitorckw-System-Product-Name>
 <aK1n_t-V1AlN86JR@hyeyoo>
 <aLCOVoshch9phL5M@visitorckw-System-Product-Name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLCOVoshch9phL5M@visitorckw-System-Product-Name>
X-ClientProxiedBy: SEWP216CA0153.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2be::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB6713:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b4c214f-fb3d-4a59-fb56-08dde6a0a9ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/ME4a5PEwsWkw1MeNQrKS64cl2FV/L3EE5VJFMvHPJO5toKyEPZg5klImve1?=
 =?us-ascii?Q?+z5cAretvUATt7Nmg+o3lfnGQ3l3dVXOV8RaU1f6QX7lAmKRE4v/dH8Y2yGd?=
 =?us-ascii?Q?STk7I2WBhHB8FekdvPzHprI51wBOIYkqjtNwgQFoFS/PYwV8EZI7rWg+tO56?=
 =?us-ascii?Q?6RalPJEHIJkSasrA4bj+zCxr6FjY/8bpa4E0n8/9Zg8TMioKuHJ+q5aKSlQq?=
 =?us-ascii?Q?WWjenOHnmH8WVIVmY0Iz0ALwZH5WbTtlTZah4DRowmaqpMf4AGIvZ78/qn7K?=
 =?us-ascii?Q?yMJ0UHnazMhxZ0bf1QtGH7rP7rEifhKW/DZnZF+FdQi8+Dcz78g5kU2xy+ct?=
 =?us-ascii?Q?5LLcoiROQ/OfOdreYAiGNuQxTFz15Nzp92/G5Yk5U7KguYSccLg5owgXXaq6?=
 =?us-ascii?Q?rbnfatWyj1O8KBBQO11hp+HgS2wPBkMNDgZsBOiHjXTqd5Ckp8ZI7NFmT3Ol?=
 =?us-ascii?Q?hrvfR4vmf7siQ3PxlwKYotiu5hAHl8Hh+IWmqp2DAolsu7dGxGy/yKi/6B8S?=
 =?us-ascii?Q?BEyinOTfY3LmkGO9umkpwt0TQUhJFgg2RvUZhpE4rbepkugWUUtg1C5RWGdX?=
 =?us-ascii?Q?gOvTbDnyiaUpLnR13saoJc7l1jzWEZlvjDMXa7dO7HGhVEfLUWHwmK66FJcF?=
 =?us-ascii?Q?S1Fhv63Y9B+qOPV7/GVZjXjPcFiioHlz2twLzkSFJw/jZW0nwgr9PiS9cjI6?=
 =?us-ascii?Q?Kb5KYGDRRvABq9HNb9ljAymXQc9TZPc5sNHcMu5KA8s83kdh8iYia7eOYmK+?=
 =?us-ascii?Q?PhjdPSKduVSAHt7q0F9wcQY2HYLRAYAPLN7jGTfY4/M33IMOf2IQZyyq8ccp?=
 =?us-ascii?Q?w9PNO0+RH9cRXjhBzrNVhVkFXrtRwUqCbugK+xJvsAGIZ847HaGxgIi3fHth?=
 =?us-ascii?Q?0v6G8jrEsY1wSzqfayw8Qq1ecTenf0a/scAkoCmi+Dks/X8TMup+mHLeC/7K?=
 =?us-ascii?Q?O9RvyAtvWkl3aVfiUK17yktVuVeq259zfA9L2N9MkSV3A+zHeS4VTEarBVIZ?=
 =?us-ascii?Q?gZXn1KH++kcxA7HJ90Q3KgNcDGymmloiah4dgY+lN8St5pSTqEuLS4yO3bjG?=
 =?us-ascii?Q?Th/hP+MMUfM0tXJUqoTu3wSZNnpzqzRBzhpBCd+HPIu2qp1C7YIRw1Pzh3Jp?=
 =?us-ascii?Q?NMXDY1oyaDijrwV6PMf9GN6zpHxg90u52pmp+E5EsOkvQvmbXIpxlhJIROdp?=
 =?us-ascii?Q?6gUwG31XnHkbMk1072t1wg2IOzQZeI8TcSWWfAIt+Hdj6rD+aBSirajUvmt4?=
 =?us-ascii?Q?e+Cf8OwqgEuR6BsB8uNME51kJ7S+E4uMs7K8eDWrvYrkXhHAFMbnZ1VTSIf6?=
 =?us-ascii?Q?ZyIRJce3Y5hKScARqKpaWChvDG5VNWlQD4FU6RWAuBcvKKYm6ZsNgGtCDSVa?=
 =?us-ascii?Q?fdTT7sRs4rd0jVBfcz9+AJ9SBp4EhnIHYNDEhL+/3FZZD6rVIcVK5//Hw4Ku?=
 =?us-ascii?Q?a1tKGm3J1D0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6Chgv91HqpLB3AsWxFPKS6s+2etpitj2Wrf200CaatuWN/e7kVglS+HRJG1f?=
 =?us-ascii?Q?2/W2cwXlAYO9OhQngIulg+PsYU2yfHvcjLmSazAsiB+uJxcITF8PYAnUnbEw?=
 =?us-ascii?Q?mu6is0N8FZQprRIUfW9CHtPx1A44HaGG9/4CBveSIDgXM8JkdRB0UPgQiPZL?=
 =?us-ascii?Q?R/gOPijhZzkZnEvTGBtsTzwCPr8Zqgc4UnST+mvWBu8VEbU5sKTTNvkRoUq+?=
 =?us-ascii?Q?N3QGKOQpG0dKRhh7TNMpobT+ezizJOS6qF+cLevsE5j/5LKTVd6yb5IlPJSs?=
 =?us-ascii?Q?4RfP3anuC5HilqZKLibCQlNEnqHhf1VlMHikDLP6AU8b8+x59QY74EnpnSqq?=
 =?us-ascii?Q?C5jmbSA2UqBi3R4ngQShCMJZYclZxnsh6dfUnaBsQH7fsNW73tbPx1xKPw+Y?=
 =?us-ascii?Q?f6jBNw1Lzd20eTvx9wOeTAi6s4HepEhc1l3ZekNM1CfZS8jFjMHpwzJokH9H?=
 =?us-ascii?Q?BC2Vab2GbOtLq6jL7P2ROq5Hsw8gRESPuvGJdKY1zBcT8gf1ow7gcGkJ308Y?=
 =?us-ascii?Q?nt24muAJmqQzL/Bj/s1Bf2Q3i0yZLQbE9dNUzFPXOGuOI2dFLfe6BqXB6lE4?=
 =?us-ascii?Q?EQZW2j+YlRqaAJGTV2t0GHUbCq33153rIcQUuvitx+M/S2vrq2Q+Ij6gH/PI?=
 =?us-ascii?Q?BPw5YCNtTkmHkD2uV5vI1PnIXXZJHvlm2oKEu56DU8ynnXAuGSRuzqUoHbfW?=
 =?us-ascii?Q?ujJ1c9vpU59mtk/t5kGAXiYCL17bRhNJazzsVS/IpcJuP++kDtWiBEK1Xb5h?=
 =?us-ascii?Q?PgZ8ueV0B6I1XslWOt+WNMQWar+sECvrTsMGWch3Npq81V4Axsq6C+9Luwmy?=
 =?us-ascii?Q?VVMpHVYLW1kZSr+KY9brW4pj30ddGFXiUpTdycfJ9IT9dWnitGT9QiIdgb2s?=
 =?us-ascii?Q?1oJr9dWyv1iQ59zChF5pLhLrWd4rHl0HuWBm4OYSYdQoXDuce2+dx9SiT4+Z?=
 =?us-ascii?Q?bd2BVMLm/EjvGswBMSeQfzS0XBPEdBrZftBl/FBLtXftqxnVgT5mQRmIzNwc?=
 =?us-ascii?Q?Ikx24dRTVzihbvvyx3fZk2jhHsOD/rqiiHllvnBing1U0AmopFiCX1eVxyuw?=
 =?us-ascii?Q?LY4QOsWkCuXModWz+3RuIkn0yXXal0YjHc8HgbgKrrbDjtSiH9Y++XsdBCVA?=
 =?us-ascii?Q?KuPOHc9MCAGuuRZgzS6aa8XdtbjjCH+iT3UwvygIdk/v4Ls/LKR2GKV4jqck?=
 =?us-ascii?Q?j6SrNMzgSU4bKAMA5ofApQwvnbywGQhpRXrsuoACovAvmjseqQ7RKane173e?=
 =?us-ascii?Q?1SxqUMQb422aT3yCxShxf1KXUrvv69PMP/VOmadEUpHjuoebHFjuypO0O+mu?=
 =?us-ascii?Q?9yqKyBwULOKGZvs1UBc7FqrVG04Na13lGRgA8h6tH0zdkambJSWc8+YbPyBJ?=
 =?us-ascii?Q?ls5U2QnBijRJQiqSrE90kMswrx4wKDRg+bwJmChLe2FD58PDA7jZCFteSM0o?=
 =?us-ascii?Q?ZQemgHTsLNTTKxcXPs/1yndjTO5eUgWKezi5Y0KriV5GcZIYwbq+uZuGi7k7?=
 =?us-ascii?Q?sXX204Ro2z7XXXekWfQZ36diK9bxAGyh+yeYt+A6A4VX4gzZRYnUW1UWhcnd?=
 =?us-ascii?Q?8fqvc2sp1hy7t0o0uKde1FFtnG5qZM7fqkWTl5N7?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rPwrvJ20wFBOmKw0At5CS4OPDu5Pr/w1mgtSjnxhnj9LxDtWlfA4nV/RfZ04IF1DWmo2kEW4iXs7alN3cadIVzfL6upv4s+7TwEgTgg5UIzFJT4p9dto9h43p0cO+b6bZdH479MRHX6pzjQqqNT1FcSPpUPOaJZcguNd2S4pFKq7mIn5pVGs0sVaaWWz5OGJrCV5VKLlbcTr0axVRuuoZjK0uP96aLhYn2RXhq0e4sKr1JiEceQNTqJnjdB21cqVK0I69b3/M1+VIKe8oRG/KQqZHNvYO6dkm0ivWfdrrHH9bH5aNK52eLp3knYlbFMn0a6WfyHHHePcrP/wSTIaxc3cXHvD4MIi0VVGgot3w/O4p2heNItnexlt4sH0aXcnGf7tqOTrmr24oXgq0vqJyK9vICzkV11UQwYFKnFyUMaoxNM6PFApop8ENXqihvliC4hWqNacjsWKvJ5U/zze7/3TghThzMuRTwETY/VxufrOrV1/B2crONMBPstAgJnGhVHABERZS91lWeU+vNLnCQKtFTspvfZuJX0Z3epGaNfWxFLa9GVJ+tOLc5ZGcGEg8x3QzpcGgbPwbCOpC7nB+B515JRUuPMEMqyU+UldwLg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4c214f-fb3d-4a59-fb56-08dde6a0a9ce
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 02:06:27.6936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xzqyc/Q4oQ03MexMN09SAr24tLLaa4oCKIHLZfRJi+v+yg+a+ow+swR0i7jq+exdIkb3y/pflR3dxyhlmi5Z/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6713
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290016
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfX1iqUALlyR4yE
 /ZV3KzTFeNxiqY1kVOKxVmTr303uUQ/bIK8Epvu2wEjjCiWZbq1iisCvM9CJyYcxAvv4bHnKUt3
 tFAOOLS9YqeFKuNpuW44diSOSgNWJLOqCEaaqP01X2AK8fRfgKoAepzeN2eVk+DCjkSARmy4E5g
 WefMv8AkKOWVSOYBaWAgQ+o0dbqREVYOUFjiA3xbsSTIcYqU1RaTQdprrxe+j155XvvmIB7vA8Z
 MX0CrbYLp2PbYzUvwpebwn0Ldf294++bqy3lHIVpuc48ezVPMeCQRWOAB4IMpezTsQysoXCaQs2
 skiklytVHYoP9QqjcOhTXRkPGGj6hRXf47tEtDCE3MW29wwRoYkE0sjKe+9MMmU1hTwNkBHMgri
 Ifq+IGxgIuhNi7yRtaVZrJjIlJqU9Q==
X-Proofpoint-GUID: 2cLPU0pwPXTYLK2pUbw8z-YHeUVtIfDa
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68b10b2b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=CuuHCt6lwlVgYl5tIdUA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12068
X-Proofpoint-ORIG-GUID: 2cLPU0pwPXTYLK2pUbw8z-YHeUVtIfDa
X-Rspamd-Queue-Id: 20593C000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ufzc84u461njbsztzyy5yr4etduoynum
X-HE-Tag: 1756433206-279429
X-HE-Meta: U2FsdGVkX1/9wHw7TsM9rC6/1CvNpHYXHFCREHWZRwsTQW4YBJj6w4UYhetfqon5j9dmCsCN8FjKQlC1MdF4D9ZaFopyP4iLvzs4IAFz2HCLb0q9EpIaHH2J25X4KY00Txnq8k9EIXXF9p6ldcg6LOgo0tJL9HOz+Cn85/e/oGAIEcCOuAoK0SEf27p+s3dcTt10/V4rXBuwanzChrYf4edrokWo3SZUozpEfBumq5I4Ean62n1ul97hbwlfOKQj1G0/tcgZgaxuI5ItoihqbLlMMMiEO9ME2LtLylzmxUAy7aKqWY5xevIQEO6rSVCuavyUtqkzwIf0Pxo2bRJRdIkRva+mKIzKkZwCc7/RJo9uHbgORWR8lWQ3VYiu094ULbN7mrdrkTPolR/nauB/gw41et1MXV9A/WwI7NMZkxq0moWNUr/dd0c8sAskptSs6t2E3yT+F/hWx8CdAfc6Pp6BxdqBYeMuVbciRUUm5RmDjJkximqhAIE23VzVjb3wLjCcjhdrCaJ+7RHhi0xE5wxKuCUHfoGlLqoE6ISi3IAEkd/lFUM7Msq5kqiN3L+VTotYBqYMOf1yTjAYEovldivZnHhLB1FT14zvRuO2FtwLIfqq2HWhk71B5TTB6+yai1vptbUQ9T1mBQ/qpoe3WRsGL7yXG5CsFolvhI+lVOGFr7KbtVcLVmNoohmdHAnoEB4nETG7424Ekf8aFec2vdemyFUjEKx0/fWdwxEVtp2lI0KTlyTLBdFmtqjJ/vUo1lXuLAMvwj3AvG6kAP0gPuYt+ZJwmXb7rAKwzq6rm1yxSU4+N0mNnXUYWFHlJC7JYU3LrI/z5lRg27HPe8nQNswuQB2veMqc6z2A9aHE4Im7yErhzVtwmZDDz1+mtYLb47yBAfsT5YpILGFj+Uq2twaFtmb8kf2sh9lTUcUXQqhPLMUL8xpx/LxouRRqOnsuHkxQhuAOGfA0Wxw94E9
 B3uh8KwP
 Z0fGyJRQl4i2HBlWMR56YTB1EKCAzbVRZC0h09E5+AzT0Q4IrDxc7z4W0jiGTdN4CJFnx+HYRzSCDBEYaZ/Qz9OPAEFKZWKZvV6X2MqyM0by3JNiyT/v/rxHr8peh4LmNU8TA4b52SW+m1va3yqWs13S90wRxloBW6ewLgx1YKUsoW3YYqCLArNBb58ptSxONqqR2PD7X+lqHb/n3lxfjY2FIWWZKh0nFi5Q4O1oUT+cdVtmV++W2NdyO1xW4p3cinWcs3tH383Re91gJMiHCO+rjiMHRi2DRM7qzxccN4jQcXxziKKlO5BCF0ND8EeojHghDMPSzjaUwXXqDZM7i54aJGcH2bRXU6XmQhRDXS0QmOLVJks4qQRba5rbRimMPf81x4Fzg/+YtMaYGkWlQgf3tAeTJpUtq5rRH4aYbFazIM0edV7RerOOXcw39hf8pwh/W+ehDwwzW7ZDqXcX0YpRZEZUZeR5DuKmJX1n7iZrcnJcdGZzBGYBwIYoUjljFhZuWfVl+SJ2FWXNlNZ5V/0prYrnh51LM0AHmN5iEDPRqK9twYvF1b/t3NgQ3tjiQsF7EVUNyBFm6XvrPdb1wm8b+nQhu9+E0gF0FydcNG5gomRn3YJzIZKzeqqUWu+BZ5euR2uO2Za9iKF7vDYitO0nPD3ZWynmBakF8tNNYAyY37Smw/06/rvZyCFirIxhSpEZ9ChDS9necot4B0r3Gf3V3XlZw3erQfz6xQxHn1kZTZLVQCLb616jrXfTadk7DiZ0BSL/Uvvzl/tT8Vipb/Y6ycPyrP49u3c57NKfsL64lTImUhEbRWxQEM5OraCOh2sPU1EIU9XQexuBDusbBZZar1yzrH/FmWksc/Or18pDPGvwNKPtFolRdkLaTrPEHdixB0J0fnVk5e1TauWUPJebh60e1iUQIuajj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 01:13:58AM +0800, Kuan-Wei Chiu wrote:
> On Tue, Aug 26, 2025 at 04:53:34PM +0900, Harry Yoo wrote:
> > On Tue, Aug 26, 2025 at 01:54:49AM +0800, Kuan-Wei Chiu wrote:
> > > Hi Vlastimil,
> > > 
> > > On Mon, Aug 25, 2025 at 07:28:17PM +0200, Vlastimil Babka wrote:
> > > > On 8/25/25 03:34, Kuan-Wei Chiu wrote:
> > > > > The comparison function cmp_loc_by_count() used for sorting stack trace
> > > > > locations in debugfs currently returns -1 if a->count > b->count and 1
> > > > > otherwise. This breaks the antisymmetry property required by sort(),
> > > > > because when two counts are equal, both cmp(a, b) and cmp(b, a) return
> > > > > 1.
> > > > 
> > > > Good catch.
> > > > 
> > > > > This can lead to undefined or incorrect ordering results. Fix it by
> > > > 
> > > > Wonder if it can really affect anything in practice other than swapping
> > > > needlessly some records with an equal count?
> > > > 
> > > It could result in some elements being incorrectly ordered, similar to
> > > what happened before in ACPI causing issues with s2idle [1][2]. But in
> > > this case, the worst impact is just the display order not matching the
> > > count, so it's not too critical.
> > 
> > Could you give an example where the previous cmp_loc_by_count() code
> > produces an incorrectly sorted array?
> > 
> Sorry for the late reply.

No problem ;)

> I tried generating random arrays to find a concrete example where the
> old cmp_loc_by_count() causes a wrong ordering, but I couldn't
> reproduce one. So I would like to withdraw my earlier claim that it
> definitely leads to incorrect results, since I cannot demonstrate a
> failing case.

Yeah I couldn't either. Maybe mathematical proof would work, but I
didn't try.

> That said, I still believe the patch should be merged, because sort()
> only guarantees correct behavior if the comparison function satisfies
> antisymmetry and transitivity. When those are violated, correctness
> depends on implementation details, and future changes (e.g., switching
> to a different sorting algorithm) could potentially break the ordering.

Agreed. No doubt the series is worth merging, just wanted to clarify
that bit.

Thanks!

-- 
Cheers,
Harry / Hyeonggon

> Regards,
> Kuan-Wei
> 
> > > [1]: https://lore.kernel.org/lkml/70674dc7-5586-4183-8953-8095567e73df@gmail.com
> > > [2]: https://lore.kernel.org/lkml/20240701205639.117194-1-visitorckw@gmail.com
> > > 
> > > > > explicitly returning 0 when the counts are equal, ensuring that the
> > > > > comparison function follows the expected mathematical properties.
> > > > 
> > > > Agreed with the cmp_int() suggestion for a v2.
> > > > 
> > > I'll make that change in v2.

