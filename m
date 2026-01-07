Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC41CF6BF4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7166B0095; Wed,  7 Jan 2026 02:37:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6406B0096; Wed,  7 Jan 2026 02:37:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8CF26B0098; Wed,  7 Jan 2026 02:37:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D70666B0095
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:37:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96A85B6A28
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:37:51 +0000 (UTC)
X-FDA: 84304363542.11.E2D4BBC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 21830140006
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:37:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Cw51PIZQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="IQolc/3X";
	spf=pass (imf26.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767771468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/AGiAq/cL0qvd7JUixr+WiVck8T1/TYx58zaZ8azYg=;
	b=FEIPHbFeTWnUrmUmyVF5dPTWXfCJxrpe3SAjSRH9PPAz+i1aPkuuRucNOI4iLas2asVsrA
	+0KGLtXAwdnfbXv2QdNzEMdcn9dSzVhfvA68WdQhgGAi14uobtqBgS7B4GvjVcgl3FG11/
	C7p0+F/Mmt7PbMQTBEMrxYSoczYG8OE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Cw51PIZQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="IQolc/3X";
	spf=pass (imf26.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767771468; a=rsa-sha256;
	cv=pass;
	b=yy+0SkbSvnpOVy1WVMq6pAUThLmcZNmEyyyesbcHfkVERAs5PJ9cLwGwWlO0LCJtCzVFKx
	KzDTWnuJiIH1MOMcwpb7gec+NVcRbyL6CfPr1uOHRrWPtuGiSyZ7niunYghpZ4ckgCrVqQ
	X8rCzM0YQ0Y11E86+BNGtsMb41+5jEI=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6075akhI1026439;
	Wed, 7 Jan 2026 07:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=b/AGiAq/cL0qvd7JUixr+WiVck8T1/TYx58zaZ8azYg=; b=
	Cw51PIZQGrYeu2b9X2sbTt7T9eublTz9gpygL94ameegXhb7DFxY466aPubncfVb
	TwAlKLptm6SFsY11swJafW8tx8ECgR27zkdoNmFBQxBnVUviqG78/ts4HjMH8JGF
	+3jXrQu698KVxnQIPqlaWL9kCE2+7dZX+Umgj2+o/AOnEs/ZvbbY0MaAMqYVfDZR
	jHSpHU6mqeiNvzWA4/cgLFmXajk3yPOfUhkqucwYNTR/TfqxSPvx8AycLsaG89LD
	tc6opT7Cu29kKFODIqiyacrlrBpY0GMasT+laSxoF7IM4xSSDRhR9FchnN8PUwsy
	imaFClHIJFaELvOuOlFybg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhhg7r35v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:37:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6076txVH020387;
	Wed, 7 Jan 2026 07:20:30 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjkhwjh-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ycG992tTwPDPa+V0c6DBsRHp9excotp9DsDuRcw5AWZ7rGMFViOMrxRIHDMK8hMq+9Y6DJhWJwUFx5CIurm10M/CTJz/WzqGgyFi0qW2CtXS/q5JxbtHRclB98ctEJ+ApGhBe9F+FzH+W0RthmNWqWyvj04cbitPZs30qcSRNwMsusz7rRoTYrOFXx+JyrsNGpyUvkGQpEfREbtFmO24VTyA8v5t19QeYX/TWNGKxBdFp3i5cdtoqaF9l931eMsWuzwLIL9Vh9C4XJHx/Kt+9sKi02NMCfOW+nOsPLb2UgJ10gXXPyyQJuGZ9G47RbXYfCsNSJ8JJ8YCBJZCHi/atA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/AGiAq/cL0qvd7JUixr+WiVck8T1/TYx58zaZ8azYg=;
 b=Fgu07L1nEVEEs6B9PYMYdhaCthejJMNXIWlLmhpqoF85Z329YRxRrfnp18oTW94J2EAZIhlQYFtBuYx2gNYhwyeYbHET9c/XXmX/2yWYmuIZ2G39anrMfB0G4M5tYW/NJYUS19C0time/mhwFjHSiK4ena4sqqkPW9r4hKRLMKVdKV6aJMHC92/wuLAXo/yCo/6h+zv1uTHR+FZXYMg1NkIApeSLJCZCjFNpSmo4KpQyKWXxCTlcrFuiEIstKNz76aVWgoVfT6Ii3w/Jz0IASJKlfAfA8Y1KOkDh5ziyVRnlreL0KtOADw9jiZNZ09atQgyrs1WVPAUO/WRZS/VN3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/AGiAq/cL0qvd7JUixr+WiVck8T1/TYx58zaZ8azYg=;
 b=IQolc/3XeBOZbwSNPBnVeGly5pt6dcQmFOi2pWE7atBU5//E46fO1h55F8mchHfL/6bqCWbovyMQvnK3vihNf0yZQqdrvTn9kgPYsT/b2Ku2OIADECKAdjBGEv0otGxLzMB080vg1rcKXkCKQizqB9OaxFg9HXE9jpTkDaeOQ2U=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by LV8PR10MB7750.namprd10.prod.outlook.com (2603:10b6:408:1ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 07:20:23 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 07:20:23 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v11 5/8] x86/clear_page: Introduce clear_pages()
Date: Tue,  6 Jan 2026 23:20:06 -0800
Message-Id: <20260107072009.1615991-6-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0180.namprd03.prod.outlook.com
 (2603:10b6:303:8d::35) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|LV8PR10MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bc70a7f-edcf-438d-6f11-08de4dbd3896
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FqZvYgwP1UJ5WfVFqYH+yzvD3QXwyo8V9lEfN/dv5AKcgiGm614wSIpwS4Pf?=
 =?us-ascii?Q?v/Mpy9CXFfazlhzcsX6dwGQuPXC+xFx6K5oI14uIMGOynCfZYGc/9ftqbzGP?=
 =?us-ascii?Q?BP0yvqtQt1H5Q5mQ0FQdFQ6iAOhFuLfIaUoZMPt4aPW/2p4AKcZ8LolN8e9w?=
 =?us-ascii?Q?E3p0IF+TKe0wYJUn8uYkBk09LmYM+5j3+iV+tCiDyAsoI3cpvXNTTnMGNc/S?=
 =?us-ascii?Q?4Bu0hI2v8nZmp4PDK0bVa41OStif+w0RVDaMVnfNZibr/vp49UIGxsd4oHSD?=
 =?us-ascii?Q?EREJMAXzaJ5rBnulANB5QCY7eTjqXjsMllvoGPCRK/swnlxC6gQ6bDYfoqWb?=
 =?us-ascii?Q?3JcdyJ+jybav9Ggx6xHn9i4Erq1BuuqO34thqxM/Qw4oehRVCfkWQ23gzDGW?=
 =?us-ascii?Q?8Ntio64FfJnR4NZKRFCbZZk5oB3QerU45bB44M46FmW8jAVk7y9676R+LSia?=
 =?us-ascii?Q?zZEI/TPM8akz90aedmE6ggOyG+Z829emsSBuTw3jXRnuBcHarp8g9fQCMz+R?=
 =?us-ascii?Q?RuJt3DsEYdkCDsV54Uj2Pj5yalTl/RsnE2xPPH9yfSFnqPzgmDlCFhOwTcLb?=
 =?us-ascii?Q?O4VaJ6BKyXodvMoQ0OZSwaI07AZwSd69/LDfp6KxOuIQlIrFref2W53RHWS/?=
 =?us-ascii?Q?HyH+NUWVopl+Rg9YxFfccTzjFXy7qInXasuSoMwpBAe1kEgrKVt4WUejQ3az?=
 =?us-ascii?Q?+R7x8UWsyRnA9Es8gDtCHAtBC6lbgVURhm0cvuyZevDPC4cHAGDo/O+OtWpl?=
 =?us-ascii?Q?BaTLFXCRyPVGRDgfibLIoEhDoJCk4pE/JWu8cTQFdypkECuZbTIsTx57kPdK?=
 =?us-ascii?Q?FwLbWTU+iHf/SgmCwbzrwoar/jByu7yi4vgWtMYzp7jeRp31ci5QrooZ3Myn?=
 =?us-ascii?Q?hb1f89RvNb+aac3eVvpKq/pmlxOrzSyUZitV6iQoZzehyGxGbXGXNm2NQBWf?=
 =?us-ascii?Q?KJk8OzichWbCcvOB+EXo6OZ8ZIcmswBDOuiSbBEJPBtzAyMMYOOk62aIr2ns?=
 =?us-ascii?Q?mh0u9Nwk5jsidxQB3ASfkOdNKEvKzxEMpAoKhG9WUfJb0TTm3u9aIqSyBEyT?=
 =?us-ascii?Q?Xp690bznIHMbZUWMhQVZmw81UX8ncFleZPfMEnRJVD8vK3WaJsdXA2QLdQ5t?=
 =?us-ascii?Q?amXAm/7GwbgOgjnq+dvFH3jPXjoOFx+/qWlBll4vwE+GDuVNFXyYSE2SUALQ?=
 =?us-ascii?Q?vpGfF1cqkAko2hNpp8NLmNADRinSdKo2qC6fhf13j+BJOvhGSln48/kK52R0?=
 =?us-ascii?Q?pQtMLSrcb08dSAKUqh81WQrkvbCB80LDfS2wYFymPA5vbJhKyGOCnpl7JPMt?=
 =?us-ascii?Q?1ACe37zOaLQJVyRX9R/BQZ/DSC2pu9wclPj92eAwuLZi6wFqK1xLRqxzz0HR?=
 =?us-ascii?Q?sVLlE9QGR29dTiFdpZvuTvDFxe1kWPKVU5QcqdlmCAZgnPOz6mVZQqVRw3Dz?=
 =?us-ascii?Q?JFHx/sj7QHEVAmax77pampQBHSZswQLi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IvLLbiqfjl4R5JYlHP3F4CZMATuy+fim0n4VPcLTOfqbI2zQP8pc8C0Fri9G?=
 =?us-ascii?Q?gL77rBALGYYF1xrUjvVS/ZOVL5841ooqJcOD6oVlOxgnofBZU0rOLrcoK3B2?=
 =?us-ascii?Q?2ulI+hFmADV7t0HDvQ9myn6Zt2SUeK3ALo16VYHYZwjGHGvZQWsa7n++Ccw2?=
 =?us-ascii?Q?bPkNF0n+6VG3HPVJEHiVtkeQXpkxHeL+s0Kj+5XCuaGIX1aH9xB+IBg+Lkvq?=
 =?us-ascii?Q?MXQ4udaEg7SAYJGMu2v5/Z8hGJjQqxfGaDY3ZNLa4ZzGjJRUGkSUtTKiAuvP?=
 =?us-ascii?Q?+v7cj95f8wx3STnFP9v6+1phfHdXG+eKh0Fpbu6HQxnJd8oxpggxZRStLjTn?=
 =?us-ascii?Q?TnOc+qwlf4bxqPgYVSMgPMEESQWerly0tE64eD8UgtQ+s7f+Hj2SDZPfbgTM?=
 =?us-ascii?Q?3dLhOO9hd5r6Ur6nPxBbxUMaYzLM2fvO4rU4tNpZ1+WLiim/VwaKjzUxTW/Z?=
 =?us-ascii?Q?8wGKpfWdjZQ6TppT83GnninULcNnBPsQbyTjuk0ajk27GbluT++9DAVG9WT0?=
 =?us-ascii?Q?UFST5983vZQzVNBltsaUoEYfYwzglNRHDla7F+dppqdrH7bRCAunNv7dtBcj?=
 =?us-ascii?Q?9pnPqrT8P5+AF0NpLyG38cHXGpTJFs+58sgx53WUA55a0YZcpPzjbgeS0+Zl?=
 =?us-ascii?Q?hVqwJL5C3+7gtxzJRBYKa4BTI0s+t1KvWiY50aeID6GsNXQunTeAmLRcFJsY?=
 =?us-ascii?Q?PtlCAX3lTsqD8fQFRxhKwNm+3+0PMWt/jomKZwIM5DRi97l0lbErpvmro5zQ?=
 =?us-ascii?Q?zWl1YqD4Z2im2VKrPAS10Qjw5nEh89ViE7MseEoluGhhqGGBrBGrQ4weHpAv?=
 =?us-ascii?Q?3ALDd7dvqcNeSPsTHfsgjOk5klJgIX3sFQVkm0BJG5IX1fzn1LtHOFO60Ibx?=
 =?us-ascii?Q?jAF/XNZWbyxPZvEXHI6ff830CdD9QRAYTniEAm7JPj82XTcHDcx+bautuUCh?=
 =?us-ascii?Q?E8KDcbV0TD4XfIRH7hoYmvj5eMGungi9MJ20klbFxZExGY/JTKPRtyFsft/l?=
 =?us-ascii?Q?V5pBPpmZbgq7Efqyv+ZhP+cRhKa/ZUW93oVNINQkac3Eqne9tFiDP4BdDPHe?=
 =?us-ascii?Q?zySbF/KBFMxsa8fJwBlFpf89W8P1tYp3YJ/wkThkTG1z+j2/lr/BgArB0vRn?=
 =?us-ascii?Q?F6EReiodUH4lfbTVs6VUBmQFweuyqHEwg4enPZoOOIfZgaUsAxmXK6v9LD4K?=
 =?us-ascii?Q?jV8IFeJ3os7wl3iHzaqa5UBYS89bIm9B8tw+Qt+4qSBao/GJbQwS2v/Fd3Ia?=
 =?us-ascii?Q?TmQgRjTdXzAX32K87PAyDdiB10hWOLRZSnX/ZI3FtdJwF/tlqMGTGwpBn+RI?=
 =?us-ascii?Q?9WEazXOMOOE3NBnLyhz1TOJvpa+fyDJ70CXPREjCktzCT3XO7Xg8Ks1GukXv?=
 =?us-ascii?Q?f0TgFhHa+Uwjv49+8PBC7/D7wUx23ctpJnJCzgaf7+H/iKpn1TRf4SZr1f8f?=
 =?us-ascii?Q?bF22wBNTUXZ/XW8YecPaTyFYx189gYpS2IO8fNHslEelXnN25Uaqzal6JGuF?=
 =?us-ascii?Q?CUKSq/dionozDFSXlzDgoRtuifigjWvwvKwsC5NblNffCfwSlObDEcMYSeA9?=
 =?us-ascii?Q?EKjDKI9eh0PNFVcbK/kFx46i7XTD9rRRcNUPc8AKsvg3bDn19bCjLE57cm2B?=
 =?us-ascii?Q?kqW7ZyxAEHN9BzOZUjLrEKALg1t2mO5yvtYFbAGLsOPSqglzy3pKnkkAkbsV?=
 =?us-ascii?Q?97cTpYxc4X2FI4doFxuyjLPo820d1RkacgPMeYidrk+0tL53j6MutkJD+Fvu?=
 =?us-ascii?Q?rYCkzYWqaxFxIRMrGpigh9jZlZwGOYA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BNDhB0uK5cB0WLMB9ao6FJUdQxZZcMwUCdqEKX/g6bOpMDqJ96nQKTDLXWunuprtelG67JpB/bztY28DqcUMqbAoqV2CtfiZGIwQrA4MRYYsnKa1ri//IGvuvd/pmK6KlNbuCRF+dycUxBWJNhq7Eu7Uz4ctzG5W21NAbknFuX/HNurP7CMtycjvaeCye33+8oW12NA4P0S6Lu9XmIMCtWh9zX3ff/vdNihwPcSuI33a5TisZHaeVyQdBlIi4BhbOIQ9qf1KgybiIn2h1SqCeN8mpgtiEzw1JzMQIBQli8irerzt2ETcyY6BXD9gozf0c4d2Tr2VHV0DHx8/j4tQbKz+UoGAdGI6h9jgVfbrSwMuFuiMWskSgS8NUf6hJLlHrDxk2qQO0v+ndTyp9z971wEkYEJ61y5ATH/hrQsObmaZGGYRmtIH8/JCewKtUAbvl5OMqBEkhXbe2IsBtmYe8SkTdCoYwEO57Q69so8qLBh8TaHsShAZDA8U0ZMICct0TA+DpKcX+QUCfKKTuBapsUTurcOyKCEW7XkpJp8Uz7r5a4iwlWL9xdV0tK72NJ16AXqt63rzI8rU7rbmEBxcCAOlZkTxBwLueaAJQQdEuvo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bc70a7f-edcf-438d-6f11-08de4dbd3896
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 07:20:22.8395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nKsJrNUIzWIpXQd7ulYJK7QTsm/L5fA7YpXElh3dVQ0rU9In+3N4srwHoDn/aKBqKvS+AMlTgp2xqaqh5IXtz+be4hJjqlsHSA6CQ5TXkmw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601070058
X-Proofpoint-GUID: RLzEqhBD88rosj_zJDWHeUZJeQ2HgEf9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA2MCBTYWx0ZWRfXw+kdoowr85iK
 W7LoHRtGAlbL68cXH7ACEY2W25185uwn8iKFUHv0tfm0vQgn/Y9V1EHaMW0I0nxmCFTz4y34+ym
 9x737rNDyr2Xf85KfYVTYvauLHBYCw+TUnySgIe5gt/FaxtJ2zU7Qwh5YawMtT/3LF9ul75Sq2Q
 A40QCtU11PplYEfnJm8Jr1s75ghh0Q06eosIN+gIJYCWxHquyunP40F85mWYuPz4cbYSCnj4n7U
 GMRn20ptXmJx7MN44srx495pSUx9EKR7HdY45UhPBul1ooNHmK0i/hTleyOFssXkTZsHVAlyLk3
 RVKM9mrwpktl6yQrwZTfVTzqcN0u9kxSdxBtiB4jyCjon+Ps3pjwG1chGqnKmdMxfgdHBudBmE8
 QVCWMcxTMFZz1P0h99DG+UDjnGS0WV3CLxXhKaiZkb4L0IwMneHKv0gno4nQ4A3yo4xqR2WpDUi
 UPX2SK7oieB/MGOsFDyDGZwcN/Im8q6xjvSyMyY8=
X-Proofpoint-ORIG-GUID: RLzEqhBD88rosj_zJDWHeUZJeQ2HgEf9
X-Authority-Analysis: v=2.4 cv=HOzO14tv c=1 sm=1 tr=0 ts=695e0d33 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=VwQbUJbxAAAA:8 a=Sq42x_x8DAdjSyyaoPcA:9 cc=ntf awl=host:12109
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 21830140006
X-Stat-Signature: ju1xojg86dn5715nte89i36mqioy4w6s
X-HE-Tag: 1767771467-397756
X-HE-Meta: U2FsdGVkX1/qBCUjRxsRNJiOTXgTFY3rFZB8QinrfWdpyRV9Gvp+aKgUA8hOpJUnh35WDhF3wdyCyDP07YE1B2y41ESpOjiBBmkk9tp3RpAQtRC+bhFziFoukgClcL1sFl+1sU/qSiabXWXAWs28Kgl+TUDlvzz0QFuFO2V62F2Q8n9VHVssKJtiQ9eKbIQf9mXwyREg00L3P2LUZiANB8pCTWQ74k8qDbrtowpl0PtAcm26YxtEm3nFKNuaxhE5KbdMq8F2/DV3kvWQIS5kTb85vxHxcAAYn+er9lc35+qBEGh7Gc6DmTLFXi3QITkZnxqr2MtTVDxnDwvFy3Dxi3u0SlqzKQ2Ebwit5RwVUeAdjDuwTaqHfcadp0kOPrBPHOqPCJ/wUdXbWWH9J91TK3NR+UPZu+wM0+hRkT5APv8oqISk72uiuX19vXkmQqRwHUC2psoLvXdDIEgcShALu/XVybEMBqdLUI96tm/xIO1Iiiy1aXjkrWcbzg6y5JB+YqiMirpy28+jXhy6E3arKFjXTaugUfOfHm4CAQqwjtGGeWDrgEPwkZZGXv1u7z8G+4h+auJnBpA1OOajEHfUGh7On0aidukFK46sL0xlz25N8s00CFrbzo4mEhEInYAXJzKoRR9gJwWGKHKEBw/rf3Tg7FUX6+ErXeox/XbdNWYBqdyObyyMB7li6iVR4N3j4Sea7FnDvMjCeeK5d1Gf0IHB+nfrB8dJTAU+A9Vb26AGgB7R0PO04ktTTKpQZGuoN+80eJhhepfxHpI3eR7BORJEuXVR3cgBpy/USo+/Th0sNc0YpDGXtin0amL44HHsBgYWVW/J03DyhUcoYOYB/HZPgh12nZsYJsGTpdaogrydX/RJVzJ2L0fGE7/EAVBg97JrDq452nkiYneGCbDmMpts3AZrHm6qIIik19VQlHgrE9VoEMptNaOe0dy/bczm6Brz6R7nV0RNMNRnZBP
 cPWYa8cd
 dhNE95JpywZN01biODfjZQ8kus2UUQuWAn0zd+ar50mleFq9NV8fEL1v2EpzGdfAZZavTGkSyvQ/wAFvas75RkNzHS38aCLX2xNo9Z8qKlDFKxL93gEUSMqlL1swanvvMexKl4mruae6ElylaiFQ4cH1amG86r7LgixHxBf0dPqSfS76yoliHzYIY2cMCKcGjk7/YRxbSTZr9Je5kfGJGryeuq/0RVVzJ0fLijrbqkCIHJ0Ih0SFrZ2wd+xWCP9fz8YSTPB8AUTOnxNee1SzHwGw5sbf17w0kkM9Gb+aud/WC4t0JOyPCyJ1pFmQ/0jxBh5U79AwmJ/vgwPuU9zKEtNRAI0OkVOz8imnP8GsZAFqtwJNkw09b6DIn3CrWpBiach2C4ZaQ2N/qvYBoIWWRbeE1BsomWYaXiu63CC+1HVGCNj80HClMT2MIQhh+MKz362Q3+d6SD1hhu7nDvPPAnuaTDE+OIuEFRTZM25C18QSQ5dAxzCX19s/ioF7aeBX9o0nlk682lmmdc3Py+WZo0iqy5gy+Ca9gfGqF8rl5Fomo3Dy828zhZpCiku81s9t9cj0I3M5UA9F+ArPbhXULGAZAyETTJA1nxTTHOZgblDN55XAwAu5SaQujEXhSUc8DM0XJMCv6K7ayYG1BfpDZlUv2sXcy+RGKR1FWpihRdeLs0FbvAhj40Z0beJIL0a0wIlPzSBWc65Mfdhiw8TkVo1AIinrHsCtsnGJLUNMOKxgOr0g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Performance when clearing with string instructions (x86-64-stosq and
similar) can vary significantly based on the chunk-size used.

  $ perf bench mem memset -k 4KB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      13.748208 GB/sec

  $ perf bench mem memset -k 2MB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in
  # arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      15.067900 GB/sec

  $ perf bench mem memset -k 1GB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      38.104311 GB/sec

(Both on AMD Milan.)

With a change in chunk-size from 4KB to 1GB, we see the performance go
from 13.7 GB/sec to 38.1 GB/sec. For the chunk-size of 2MB the change isn't
quite as drastic but it is worth adding a clear_page() variant that can
handle contiguous page-extents.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 arch/x86/include/asm/page_64.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index ec3307234a17..1895c207f629 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -52,8 +52,9 @@ void __clear_pages_unrolled(void *page);
 KCFI_REFERENCE(__clear_pages_unrolled);
 
 /**
- * clear_page() - clear a page using a kernel virtual address.
- * @addr: address of kernel page
+ * clear_pages() - clear a page range using a kernel virtual address.
+ * @addr: start address of kernel page range
+ * @npages: number of pages
  *
  * Switch between three implementations of page clearing based on CPU
  * capabilities:
@@ -81,11 +82,11 @@ KCFI_REFERENCE(__clear_pages_unrolled);
  *
  * Does absolutely no exception handling.
  */
-static inline void clear_page(void *addr)
+static inline void clear_pages(void *addr, unsigned int npages)
 {
-	u64 len = PAGE_SIZE;
+	u64 len = npages * PAGE_SIZE;
 	/*
-	 * Clean up KMSAN metadata for the page being cleared. The assembly call
+	 * Clean up KMSAN metadata for the pages being cleared. The assembly call
 	 * below clobbers @addr, so perform unpoisoning before it.
 	 */
 	kmsan_unpoison_memory(addr, len);
@@ -106,6 +107,12 @@ static inline void clear_page(void *addr)
 			: "a" (0)
 			: "cc", "memory");
 }
+#define clear_pages clear_pages
+
+static inline void clear_page(void *addr)
+{
+	clear_pages(addr, 1);
+}
 
 void copy_page(void *to, void *from);
 KCFI_REFERENCE(copy_page);
-- 
2.31.1


