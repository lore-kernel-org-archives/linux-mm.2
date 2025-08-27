Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F414CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0648E0141; Wed, 27 Aug 2025 07:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E978E0105; Wed, 27 Aug 2025 07:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F93B8E0141; Wed, 27 Aug 2025 07:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5751B8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:38:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BD00140587
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:38:16 +0000 (UTC)
X-FDA: 83822338992.19.507167E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9BF26100011
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:38:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KCzlMZ7x;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ORTCerl5;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756294692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRom3ExUE6Pns2hSrZoDw1aHz8F0NtuPYa2kn54Tfgc=;
	b=Gtr0CbCrTKiuI+rRVT+gz07kpFfDBP2s+QKyx3EoeHFSQwzOcGnoQPFDEcFjb9bBtJibuK
	5pmGf5WgMNlAjjMpbAmx571V1YPb0qu3UbHU4qUpyf0M7uKRsHQ1T7771ahhMad50oO40g
	SHhO5ymvyFg5nDJ24KLGEE0Vc239uBY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KCzlMZ7x;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ORTCerl5;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756294692; a=rsa-sha256;
	cv=pass;
	b=3NKV3xKPP/2GGWCv0oFlI3T609P9oIBCY4m46Fw52iDJ8hgcWoVmx0BJB6Hu3T+nLIm+lt
	lMchykG5+Ttg5Ikod7TRptGUxH07h7GzEF4ZNYQ46CCpy3lAuQRDqz9wh1h4Mel3S5722Z
	b07wiQVfEc6rtJFW6xWY3zBV4cpsKGE=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R7uCk3010925;
	Wed, 27 Aug 2025 11:38:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZRom3ExUE6Pns2hSrZoDw1aHz8F0NtuPYa2kn54Tfgc=; b=
	KCzlMZ7xpjk93+1kVP5A1+qLsr6Fn4yN8JkbPy95m2FAJzRChgzwAozIuBC2PMam
	PSKyD/2vbZe9s0nHBeZYe1iNM8GDmGj4LrK5/CyIJ+/PaG/rWCv/I0kg+NpuW/ul
	o1L5cT3x3LqKSA76u8XXwqhOvfDv/abBnluy+UWydXX+cT/4amfMIE4gv/DU0Mh3
	0yxaN19kUTl23XT6gbHfpMYG4rfDhrPnt/GIqhzy1Jui+CJxv/he7ryDik6UNcMG
	8F+WC8SSpewIqjqWCxxrCY0d+SiR8cibTgRJtldOF7LduB5HzNkjf0Z5m8CviAvG
	kaGYVVmAuajFNpKxUhGA0g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twd18y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:38:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RBGBNE005004;
	Wed, 27 Aug 2025 11:38:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8au210-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:38:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VGMhPhXtsQSNPX+Eeh23ke29TM/MkwUu68l2OXIj3ApnjA9qjjKi3mEumW0pC5RfDrQmQVeWDn5j4Y9X3sx2e8NR0AGcvqWFJW+5CySaBjt07dJ1MSV0PVkaEDIkfzmwyzfAXIai/3rJTstqxO4CvosH4bhCTlHRstYmXg8GnF4y2gPyj5p3a421vdBui5Mdr42G8hftY5rFr9+jk835Q3hV9HQHC38A27I5HQHPoCDkPG0FkG9LU1XvFkUBLWbEON1OVk5rT8pxfaIeHXsvh4AeCy9orAbAVFVkmQT66gitBk9SOtEJroKTppv/c9GhtLmNGcZcl94oOmORxSeRHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRom3ExUE6Pns2hSrZoDw1aHz8F0NtuPYa2kn54Tfgc=;
 b=De+/C0W7VosKtBvx10fWaPyFCjCyWDEpeaiLXGKYFypIZ+rUJbMIKsgX8YjiBSAYG0YPIvYNJPdiaxO2ZTrusnwLTFuRlK32qUpwYgOjcPmEaySS2/DI8aCj5Yp7iyNLrchjvZUrp+dec643cIvlxjhnnK59MfPO/ocanmdyx3szNGyObEI5lnJvU/iRLtoej2dtw/OAYauFsFoN6w/esY5OIjhqbZNkRJr45ZGA5mfec3Hov56z+1HR335CUIjHFzO2ak9nQct+tFkNfTi1UkBBrhpbLa1BCe9TTKA/KCmx9SjBfqYxxvNnKtUQuIerMcUpjZjZbh4RDLmoOB78EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRom3ExUE6Pns2hSrZoDw1aHz8F0NtuPYa2kn54Tfgc=;
 b=ORTCerl5sZsPqofqm8RQ6pku4BDF3t9PlC/bIyjyygFBSDSKxNsdY+pESeiIdk5+LX2pAS3/NHG0b1aj5r5M7SXUcTKY1j8Vdac9c09ecZwQvgRHZnllfpDhW94Munu5UBDiclWra89HaVHayV18ueX+Pu08onfLiVoC4KPrilY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB6077.namprd10.prod.outlook.com (2603:10b6:8:cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 11:37:55 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 11:37:55 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, harry.yoo@oracle.com
Subject: [RFC V2 PATCH 4/5] mm/slab: save memory by allocating slabobj_ext array from leftover
Date: Wed, 27 Aug 2025 20:37:17 +0900
Message-ID: <20250827113726.707801-5-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250827113726.707801-1-harry.yoo@oracle.com>
References: <20250827113726.707801-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0122.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c9::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: 71f7ede2-9362-4d27-5ee1-08dde55e2a40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kvg7f8iTX5grb/bAiWpfB7WpgRmV3fL2xNHpi123ZUKcKHl11L+ngtVgezLc?=
 =?us-ascii?Q?uG0AC02y6/ekWm5bNBJoRcnxMvp8pI8lHTSX25Zq2qeG88FFwd81P2FlzlK7?=
 =?us-ascii?Q?ZRu8N5LpYkH3RhjMm/wcayiUs7hFirfgQZcyxoTlBwa4rlwnUz17Js0JsYqE?=
 =?us-ascii?Q?3qrkkZyy7nUbv0nXDO3IRFsrnB8cThTUzxHdYtfbeYGVoLo6wvbFGwLiMilO?=
 =?us-ascii?Q?J+IUbTaRDnmpeoixVSjyA1u+XP76da+0kVneYaBRYGh16FBmCmkowHdCRmZY?=
 =?us-ascii?Q?IR2AapWm+73bAnu86tUTStM4i4PGHrn1wzPfPwkFoCiH4ZNAL0dTt6ws+Por?=
 =?us-ascii?Q?X1ANl7MDfrQX76VhpeyqNyfBQV5eYl1nIz07NhjHWsX6e/tIDJXwqHPTLzpB?=
 =?us-ascii?Q?DgeN9uEmsg9Sl4NcKqsGmgj2MrKVq3RQZ/71YlN4ohtepyVd+PdsHvj7a+EQ?=
 =?us-ascii?Q?ddfwN2/Wz7tGIXf0lxyUCHij3IUSdBKtTKYDd7inFZCnRXLx8Rk7pg1Np3Oy?=
 =?us-ascii?Q?h98cWZhfziosmLl2DezsJLKv2z3Terv7m7DN1lyh6fgBmxMvToxnU+AVfOuL?=
 =?us-ascii?Q?eLTeL/v6XbB4i3m1cUJecb9yDG5+opG6Ui+xVrxJBi0sqE0BL77GQnUKbspz?=
 =?us-ascii?Q?ynq6iEOJBirvN/wYqkdRQ7z+hyBN9KEXAj7QEPhtyALo4/d9jR5IVnR6ZFdi?=
 =?us-ascii?Q?pB/34BMgpAClMEvo60UBaC2Yh99WMFcjU6x1xgbM3572fSQsVwqj9pAgwVzX?=
 =?us-ascii?Q?fztE/mtVYe+DJRXg1Vb4IWZ30qEHUG43BmXq9xoBLuR/nzlxyLbu1K7l2Gte?=
 =?us-ascii?Q?daRFsuQSBAWVUT+H3ZaQ/74t6CuDEAaxVk3iEmNCSCGp4x0Pr59zTAg+N8pC?=
 =?us-ascii?Q?Ukt+7Dc4zT4cwF5xEL4RPGCFDT/17KiZofCTYPHLc2IthMs/ESujQo+EOPrI?=
 =?us-ascii?Q?FL2fJz6GAt5+kbSjTzCoaQNuvNnoXQ3rD/IMS7Kr844dDw+/x7HNAQ7izABp?=
 =?us-ascii?Q?BxoPkc8Ei9GpgBxkLeqGNxDFir7nsq35N8wfNVGUXuRYlbHcz75xglCyBIcy?=
 =?us-ascii?Q?+Nz/rvGlYYVXGfy/PB8FhADtIyldAg40QNSI4t1zntRBL7Md65/NHnpEt1Di?=
 =?us-ascii?Q?gOAk9GjimYlYl1Txu2BjMDpaeoGJiP1eRm2KGyV0h2RgKkvQMfwLMKi7wyeX?=
 =?us-ascii?Q?1o+09YqUb3a5LFP3STEkQkV7fcrjqUvMWh6T9J1dq3brzZtiJlf29B/yi+8U?=
 =?us-ascii?Q?9LNyASJxx0ln20NNRHwqAia0fDDmNpjtpaE994v529iO0avJ/IsMlEtoKAHf?=
 =?us-ascii?Q?LNUMwXtqONtEsYcd39scelSo9tc3zXyOCjB1GyMtQjdKIifBnyXWTYKhB4l5?=
 =?us-ascii?Q?uso00To8zFVcw03JF0i7mdH5ffzoAWPCXSvdmAkGpAi+SMhzWksdfuLfa1pT?=
 =?us-ascii?Q?ZtOXtGf6UTI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+vaRb+k23cJIcIhNjk8EaJC8qec8el9VfSr7+zAA8QCd6NMwWREosBY20mC8?=
 =?us-ascii?Q?ft0gt0P7B1gmEpm9QA+/p0St9lPC7mJAAgvsdWxP37+vKxz+i/euKGBtmVdA?=
 =?us-ascii?Q?nAynYoTZ6WWOpznf0xGBq792FRuiPaGfSfXC0lw/6AzorSOn7/g7s7qxi2QC?=
 =?us-ascii?Q?dQjGr9Upo7JXKRYXODlrAXeq9sfB6YwgmLqOafyjXaEAre3is4PORxO7iZZt?=
 =?us-ascii?Q?yvHvsMbtfVZAl+o+kOzTD86tG/SJlXGPzfr6FTa99DflXmkaJoGVv3OmBCL9?=
 =?us-ascii?Q?FTKAHlUX1YFUOkkHqY3TMofc+Wz1C2b8AMMWqXCP4aySvb/xiX98dsUpU6i3?=
 =?us-ascii?Q?ngrNyNi2j1ViB9frdFJeVvIkK2yt/awk9FmwgDY+BMpohCmX1s1Ql/tH2FpQ?=
 =?us-ascii?Q?lLWKazRwOS8bYVDagHV3kwK33N3IjREaIXNvFH0niCf9gjzWTRv3+nGU2Cr1?=
 =?us-ascii?Q?hMcQ28dGcp7RAi9K3AbdfmAZZ8lEiglieGAcPIz/HSFf7gqsYbjmcbLD7lwz?=
 =?us-ascii?Q?xX3edhCGwoM0HxDInLPKkR5I1geBUR+0j97QAwkWYmUtdy9SDQLCTbT+0u16?=
 =?us-ascii?Q?kyu5BnuGnD6Qq7e52BOclhA8rBULsonYwuClKs9NCgSKUKcB/R9EUq2RkpJQ?=
 =?us-ascii?Q?i3C/UYCZiBQVjlzM9fkTfS2pq32tcZMW69/lOd1fTH1DCFslClD34hZWRBPX?=
 =?us-ascii?Q?zbexT6sEC1g/6X8khCBRcLpx2yYhvOXIRazHMhIb4Kpi7+5x2PanPk8dQ1Jn?=
 =?us-ascii?Q?dQtoECjwnw78yD9vwxDuZZIkULITyY8ITfB95wUV2b3G88C4ncTxc52C9ysc?=
 =?us-ascii?Q?1m434Lc0n/fXwHCXTha8ED65O8SahWaIP43xVfvg10Mdria+QgnoJupM2384?=
 =?us-ascii?Q?XlqRWntWnmY+KsTYTK1381sYT1tC1QoEgAiQmULDDYvJlz0qhi8QSR4ysAui?=
 =?us-ascii?Q?VzGudE33SquDffbnzZox4EjkaAiNiowwRiPEdmZrhl5GHkcE3IZbX4piMWJP?=
 =?us-ascii?Q?w7NaMu8gHxTYuYgIo3vktzVuZqlDVuVVfEZaeZNfwZ/CtYWjK5U/dftCJ+Ty?=
 =?us-ascii?Q?3N2n1eXU53ponXY+jkOfbaxHng5i0M8xNBr73wVrGA+wNVFrUulFJLKyik7b?=
 =?us-ascii?Q?r4axQ2eUl8pGZh4N8Og2aJK4WG4/Cky49RHuAg+XQXjqzWAuK3A8loFE2el2?=
 =?us-ascii?Q?SUp3RD3No3goLiC6ADnuRC37kFMS3l1MJSug6uhRS8FGm98FRc1UVlMJ12+s?=
 =?us-ascii?Q?8Jq4p3yyRQxaS7TtOAM7tUtZy8CdMpDODWGhi7DQK0xOvqVRHz73BAbdqlwO?=
 =?us-ascii?Q?1mNk9yexwYSMkikYEwnlCZ+0ytszqHrjwIvKQT04oWuX5up6cxWuz8xBQ7+8?=
 =?us-ascii?Q?PUNXFdeBWkMG5CcaSLfs3DZCjCPpxnJd7yiGe9NnJHc3df2Nf3FNTRu5sOnC?=
 =?us-ascii?Q?qAB4JBQukbh+o5yycejUtJ+X2zCD2DnYMFtTfHFMwXqmnk9TzSvwyJE7I04C?=
 =?us-ascii?Q?ieg5MABtHZUJtj3nK+huiI+50blJ750MvvKQ3lASZtOwzN8DiBSlhOPyh/0i?=
 =?us-ascii?Q?+iR6j8JUNZmFitNoaVNQxfimWnsgpu0fwTCoprzg?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	29eNj6Hk2aSTyQIVJDmAj1a5A9VOqhxkj82TiOZnSuIzj2Nc2XMHU5PLcRcTYDySouRaIWjptbDScm5lAL5na+fV50i3BXBMyhKjNrhEsONKpM+EJuGxGBHJNvmpajr7bme8lFxWADxej8itJLfM1pTWkkoV37X2vkFs8U96emNXiWrnB5u1sPa4YmtiZtDQQQn17fxxGgYKCrBk/kTeOqMZaWfIFpvQ+ulEeBCRnKPD1iF/swMiVwDo5eakDiMXb9UNsRcdiLKaVQN0gn06XAHQruudL+I0Ld6e+W/XP4wjQztdvd7OttAfjkahmD79DvOftrWRNZOP8k4OYZDu5XsfOJ2OCLfDlsFUGFAtF1esioP0T37Sc+9hCLSFf2sOiIMTqnaaQkVzmxPeIVaX2nu3wQdKXtw1vsOcmUJQgIWGBfaFTrn7iGUUmxrM8K+5FrWrJLh3xScleZgxsCZo4/PAnKtKXez1BllB7XoKFpT9AcB4Ze3uP9W1jmcqxz2dOVCMdicqhosBGUh/tn975kE1GY8XERV7rWPwsMcDz9igfu3pS2O3dRts4l2T55zij/QD13D3H3QhpNU2rBoAG4gp6lhZDvoNYpSTm13koPA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f7ede2-9362-4d27-5ee1-08dde55e2a40
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 11:37:55.6784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M8crntJJx7rp7KNXaVxBSu2E/2O92gB84NqhFN5/FCb0MNfvHUgut4a0x7hyDzWkDxRH69/WlLlaEeaTGVY+yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508270098
X-Proofpoint-ORIG-GUID: GQHg1haW5bGddk5f1vVK89LYbaFFPVdP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfXxWZ5eDtrncoh
 7qULFHVJ+EncqEuu3+ng88G+K97aaz0SgYswhprusxY1A1zeAtBzzUOMHdvNf4FCtnHh07p7nRy
 d5wnfhQz6CBRgwf15E//T4S43yNIV1wReHuvQB78uti/GoS5Cnmp5dQ7HWiw8lTgHOkPrXJtcVX
 XgB5oWEQXUqDWoQTqwN+5gQSzhrsne379KM1zMhlY5zewrAU+qfKByUoRSbAvaIya4A6KD7R+gC
 M/DNoh5ZCEIrNye6MC6PlNxLDVZscXte9t2NnjWO+hAqzJOYs8oC0qds9CB2wcIdjSCKhxgzpMO
 W4z/poOKzHiib6NSdpWh3AjnOgpLv8yPvHVIAI/3XlXjNlFWl1yPN1/kJeLwTJPXXjQyP44ynsc
 B/R6phH5Uw0xELKfI7yTKRwaCKLSZQ==
X-Proofpoint-GUID: GQHg1haW5bGddk5f1vVK89LYbaFFPVdP
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68aeee1b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=yeldhbV0fVjYLvCz6hIA:9 cc=ntf
 awl=host:12068
X-Rspamd-Queue-Id: 9BF26100011
X-Rspam-User: 
X-Stat-Signature: c11pkdzowcpp3u4gxnjhcd5nbcaz6w6p
X-Rspamd-Server: rspam09
X-HE-Tag: 1756294692-289971
X-HE-Meta: U2FsdGVkX1/QTCHO+OBgzpODHGGLhkduteFtIXMBhi9Yz4WuFcw42MK5tdbeeNfs1Bo1hqPK/KznY+W/pffSGJy0NzqfMxFiW1OOt0YZoPRHFJwV4ivJMo/PPiDElpE7em6FT6kD4tFWl9oAQ+bW4ZiYsC808cLmSc2FRIIk7KSAOzKulhQFyBIdeG2PSj5S98FWKPbVDwdm1yYvGohTwVhhp4nOdWOL6uRuSF+mExYpqUTMhTSunkhq/TOeY5WmGHsPAhvzrgS44tY+pp4l6SaRqp4y0nd65TFpKta/Z3TDy7wYT52VNOhv4YkjrQnifVBs9gU2GeA6oXn62Krleefh5hDKYstFaP/Ol2vPgpb7NU9SJ4wdO8AIiEvaRH4RqOpZK57FC9oNv0P6Amh5ARndcRhLEhw94Wlt4ymQvNRuZZjtuxaapywDU8mi3wB0yIFfVElvPnsJA0iINdsf4xUQD8aaG8elZsx+WJlCMI+VZ/NOah5IEMEbqCKziqNsRKJBp2gdvKFFYkO4heB6JolFdVrBVhb5pZjvShXj/WNNLj0ggVObarBiXPcwT6nl3nvKv1N74m+/zUqHPBTBlripgrv1giXFyoP+2O8N0qItEg8Jc4Yo0c0mK19HfqIq5vMSh2PjUJ7TJkdqO8YHSWgQssi3pRC8kDHeSvXDBOXeLtxxLLhDFlt1XbLHW/OiJ0RzLkmwxyPS6eix4Grsa7/Ihua/r5Teq1OdNsl4fALGF12EbpgQb7Kmp5o0VMlKOAjugJxhgtoVYQjNdYD1LuC2tzMo3iaIC1qSdNwCQLnaVcsYrFqTKjUYNwBYNDf/g7mIAoGEcc+1hN3ZgyxBVlpnwP8INZEso6OgARdM96HLcqlZZrRX4QSbt8CkKxwjZAPGBJeEaRnk3mL1I2PApEK6wr8ZJuarfCfpK5D6LM0uUgRW1d3wziqezvqbcYrMRpSgi5NpII8ViALQNr+
 3sgBo7Um
 zusGl8lhlpQT9PVRp0z+HE5h3vuDi3BLptxHvOXnqcS1fO9DD2JVc8N3/0MbhMlZOG+sP1y7J0X7QLGMQgOWWbKHcAUBU8vjpDR+41Wyy+i5SBsv+7I0BgpUYBsrbo2akbcq/y1HmsM/8kNLFUVdfNaVyRudEjfo9z0Ty8PMti4jwPytxIixTtLA0JhWxdaP2DbeBTq+VgF0QCkpN7ktW4zCOsWO9vPU1JZxzYrth53YnV/cGZslT00Ya0lNRpQ7Pq9T7H0gmSn1gRn7puXLsattROVhI4IoY239P/tiw17PtZT95bCeyIgCm/x7wlOZJ9PQPc6PmpBwwSbhXYBXHlP+TTveCEH6wh1G02TE4pm7frMo+AoS4SsK5wQdBjSeaBkjt50alwuKGrO9gDPTI/UsxZ9AC6VSDtcZYkDrwXLJIOAf9KDFl7OVkkbGScT45O2PS4bjrxwKXtK3GWJ3D6cIiSVUC8rMiQCSvkAVmiNRu9fDIzNl8mgx3rsi8AC3WZH4uawLLNvwbPUvqShdRMuISoc1pM8QzIwFJmmPRwxIaYSigNF4hmEOBSz5IULO1JBj1j13VngrhOGTgfE1TtDwmNjdSQaDrhqXZOwfnTS8pCqneUL65MrwMDV77pwFqgYAaRSXs2YSVYoZJLdWatjYnzUS+VD5YyCRRk+n/y5WlnGWvcbX7DYlbL/CEbuNXcPqdvOSn+dbih+ylPAhahApE2m5HykYTsmAPx4JARAHUmkKLV4EGR8fG37XZhFadCYtF/9K3y/oSYbtUFXdYyxxrv2ai0AN0dNHVu3uKn7dEcrdRyNa2uh8QvUkr0WQ45fhCcqwn4+fcu7cXI1zStZg2bHX75jU2tbvmrZcwq8dnnVp7K2ZaDT/GE13/FcuzspRq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The leftover space in a slab is always smaller than s->size, and
kmem caches for large objects that are not power-of-two sizes tend to have
a greater amount of leftover space per slab. In some cases, the leftover
space is larger than the size of the slabobj_ext array for the slab.

An excellent example of such a cache is ext4_inode_cache. On my system,
the object size is 1144, with a preferred order of 3, 28 objects per slab,
and 736 bytes of leftover space per slab.

Since the size of the slabobj_ext array is only 224 bytes (w/o mem
profiling) or 448 bytes (w/ mem profiling) per slab, the entire array
fits within the leftover space.

Allocate the slabobj_exts array from this unused space instead of using
kcalloc(), when it is large enough. The array is always allocated when
creating new slabs, because implementing lazy allocation correctly is
difficult without expensive synchronization.

To avoid unnecessary overhead when MEMCG (with SLAB_ACCOUNT) and
MEM_ALLOC_PROFILING are not used for the cache, only allocate the
slabobj_ext array only when either of them are enabled when slabs are
created.

[ MEMCG=y, MEM_ALLOC_PROFILING=y ]

Before patch (run updatedb):
  Slab:            5815196 kB
  SReclaimable:    5042824 kB
  SUnreclaim:       772372 kB

After patch (run updatedb):
  Slab:            5748664 kB
  SReclaimable:    5041608 kB
  SUnreclaim:       707084 kB (-63.75 MiB)

[ MEMCG=y, MEM_ALLOC_PROFILING=n ]

Before patch (run updatedb):
  Slab:            5637764 kB
  SReclaimable:    5042428 kB
  SUnreclaim:       595284 kB

After patch (run updatedb):
  Slab:            5598992 kB
  SReclaimable:    5042248 kB
  SUnreclaim:       560396 kB (-34.07 MiB)

Enjoy the memory savings!

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 145 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 140 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b80bf3a24ab9..ad9a1cae48b2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -878,6 +878,94 @@ static inline unsigned int get_orig_size(struct kmem_cache *s, void *object)
 	return *(unsigned int *)p;
 }
 
+#ifdef CONFIG_SLAB_OBJ_EXT
+
+/*
+ * Check if memory cgroup or memory allocation profiling is enabled.
+ * If enabled, SLUB tries to reduce memory overhead of accounting
+ * slab objects. If neither is enabled when this function is called,
+ * the optimization is simply skipped to avoid affecting caches that do not
+ * need slabobj_ext metadata.
+ *
+ * However, this may disable optimization when memory cgroup or memory
+ * allocation profiling is used, but slabs are created too early
+ * even before those subsystems are initialized.
+ */
+static inline bool need_slab_obj_exts(struct kmem_cache *s)
+{
+	if (!mem_cgroup_disabled() && (s->flags & SLAB_ACCOUNT))
+		return true;
+
+	if (mem_alloc_profiling_enabled())
+		return true;
+
+	return false;
+}
+
+static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
+{
+	return sizeof(struct slabobj_ext) * slab->objects;
+}
+
+static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s,
+						    struct slab *slab)
+{
+	unsigned long objext_offset;
+
+	objext_offset = s->red_left_pad + s->size * slab->objects;
+	objext_offset = ALIGN(objext_offset, sizeof(struct slabobj_ext));
+	return objext_offset;
+}
+
+static inline bool obj_exts_fit_within_slab_leftover(struct kmem_cache *s,
+						     struct slab *slab)
+{
+	unsigned long objext_offset = obj_exts_offset_in_slab(s, slab);
+	unsigned long objext_size = obj_exts_size_in_slab(slab);
+
+	return objext_offset + objext_size <= slab_size(slab);
+}
+
+static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
+{
+	unsigned long obj_exts;
+
+	if (!obj_exts_fit_within_slab_leftover(s, slab))
+		return false;
+
+	obj_exts = (unsigned long)slab_address(slab);
+	obj_exts += obj_exts_offset_in_slab(s, slab);
+	return obj_exts == slab_obj_exts(slab);
+}
+#else
+static inline bool need_slab_obj_exts(struct kmem_cache *s)
+{
+	return false;
+}
+
+static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
+{
+	return 0;
+}
+
+static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s,
+						    struct slab *slab)
+{
+	return 0;
+}
+
+static inline bool obj_exts_fit_within_slab_leftover(struct kmem_cache *s,
+						     struct slab *slab)
+{
+	return false;
+}
+
+static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_SLUB_DEBUG
 static unsigned long object_map[BITS_TO_LONGS(MAX_OBJS_PER_PAGE)];
 static DEFINE_SPINLOCK(object_map_lock);
@@ -1406,7 +1494,15 @@ slab_pad_check(struct kmem_cache *s, struct slab *slab)
 	start = slab_address(slab);
 	length = slab_size(slab);
 	end = start + length;
-	remainder = length % s->size;
+
+	if (obj_exts_in_slab(s, slab)) {
+		remainder = length;
+		remainder -= obj_exts_offset_in_slab(s, slab);
+		remainder -= obj_exts_size_in_slab(slab);
+	} else {
+		remainder = length % s->size;
+	}
+
 	if (!remainder)
 		return;
 
@@ -2140,6 +2236,11 @@ static inline void free_slab_obj_exts(struct slab *slab)
 	if (!obj_exts)
 		return;
 
+	if (obj_exts_in_slab(slab->slab_cache, slab)) {
+		slab->obj_exts = 0;
+		return;
+	}
+
 	/*
 	 * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
 	 * corresponding extension will be NULL. alloc_tag_sub() will throw a
@@ -2152,6 +2253,29 @@ static inline void free_slab_obj_exts(struct slab *slab)
 	slab->obj_exts = 0;
 }
 
+/*
+ * Try to allocate slabobj_ext array from unused space.
+ * This function must be called on a freshly allocated slab to prevent
+ * concurrency problems.
+ */
+static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
+{
+	void *addr;
+
+	if (!need_slab_obj_exts(s))
+		return;
+
+	if (obj_exts_fit_within_slab_leftover(s, slab)) {
+		addr = slab_address(slab) + obj_exts_offset_in_slab(s, slab);
+		kasan_unpoison_range(addr, obj_exts_size_in_slab(slab));
+		memset(addr, 0, obj_exts_size_in_slab(slab));
+		slab->obj_exts = (unsigned long)addr;
+		if (IS_ENABLED(CONFIG_MEMCG))
+			slab->obj_exts |= MEMCG_DATA_OBJEXTS;
+		slab_set_stride(slab, sizeof(struct slabobj_ext));
+	}
+}
+
 #else /* CONFIG_SLAB_OBJ_EXT */
 
 static inline void init_slab_obj_exts(struct slab *slab)
@@ -2168,6 +2292,11 @@ static inline void free_slab_obj_exts(struct slab *slab)
 {
 }
 
+static inline void alloc_slab_obj_exts_early(struct kmem_cache *s,
+						       struct slab *slab)
+{
+}
+
 #endif /* CONFIG_SLAB_OBJ_EXT */
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING
@@ -3125,7 +3254,9 @@ static inline bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
 static __always_inline void account_slab(struct slab *slab, int order,
 					 struct kmem_cache *s, gfp_t gfp)
 {
-	if (memcg_kmem_online() && (s->flags & SLAB_ACCOUNT))
+	if (memcg_kmem_online() &&
+			(s->flags & SLAB_ACCOUNT) &&
+			!slab_obj_exts(slab))
 		alloc_slab_obj_exts(slab, s, gfp, true);
 
 	mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
@@ -3184,9 +3315,6 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	slab->objects = oo_objects(oo);
 	slab->inuse = 0;
 	slab->frozen = 0;
-	init_slab_obj_exts(slab);
-
-	account_slab(slab, oo_order(oo), s, flags);
 
 	slab->slab_cache = s;
 
@@ -3195,6 +3323,13 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	start = slab_address(slab);
 
 	setup_slab_debug(s, slab, start);
+	init_slab_obj_exts(slab);
+	/*
+	 * Poison the slab before initializing the slabobj_ext array
+	 * to prevent the array from being overwritten.
+	 */
+	alloc_slab_obj_exts_early(s, slab);
+	account_slab(slab, oo_order(oo), s, flags);
 
 	shuffle = shuffle_freelist(s, slab);
 
-- 
2.43.0


