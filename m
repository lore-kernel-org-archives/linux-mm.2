Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B38CA100D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3DCF8E0006; Tue,  2 Sep 2025 04:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8F68E000F; Tue,  2 Sep 2025 04:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFC08E0006; Tue,  2 Sep 2025 04:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E46A8E000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:14:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5C02160B2C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:53 +0000 (UTC)
X-FDA: 83843584146.28.688A635
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4B362C000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YBX7H8yf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tkS5PyFu;
	spf=pass (imf10.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78mFrYCJCjC8cGcXLww93kCFW8Qf6P8C8oDZsaAwyzw=;
	b=WArOF3FcGWWZ7wQ6wtYV9h4LQ8ZC5NKsdAiQWrBQ7471htLKBWjXVVHHx54PVAMaODRSsf
	rUP/fqsf96CVq3+x2d0KurP4255HjN547x/WqH/Kt+V2wlW4JNu3k1Wf9BGW1Q7y4Fo9ii
	o39tDxjEPz+yOONAf98EcheEC39lLzA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YBX7H8yf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tkS5PyFu;
	spf=pass (imf10.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756800530; a=rsa-sha256;
	cv=pass;
	b=tWVqeQNZ0ViDNX4Sc9cA5IWwSmPz5UJ1KQNf5+Gn0xUxoRM2AId1WODyaqOys2CFXUkrL1
	nHUT9OmVnZwO6SPlNRgscQ2HpUIWz27kC+fsqMoUuknkjvyyzt6+4CnDEi98/GYqbfe91w
	0x1AleVMPrS1/8r47F2PRM65IV0xZME=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5826gb7H016481;
	Tue, 2 Sep 2025 08:08:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=78mFrYCJCjC8cGcXLww93kCFW8Qf6P8C8oDZsaAwyzw=; b=
	YBX7H8yf+AZ1OaoOPxywASIqgh31YZu5Clmr4HJE0DRFv5i+/PZYTdhFO8jKf/27
	XlEvgsqM6Zx9Qr+1ZbN/xY9L+4UvTCPalX+6wkE1VfqPYYobycU9DkHWBDH6+Q5v
	1b5xyHwwal5oEBM0u+tBJ544dXhhF1+md2Py0r7KXU2nthxu49x4FYnEXC9HHlWF
	sFr16ALl353s7DYCSlJG15RR7ac0fQg5nuPOZZD8taYDY/bwhBq6xx+cyXILBR0Y
	BGP4tvOt8WQIIEdRk9Sm/Vu0eoRefNSWG207j77QW4HXYiJ9rUUxyR2jIY9dzExI
	UyvJwBnY786P8nugwYImtQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmnbg75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5827nYtR024842;
	Tue, 2 Sep 2025 08:08:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr8j6vg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BmNhSCsI617up7A7C3pmRJkqRzhuRVN/NnfCrpBhVxsvT6cY6UkdMbAZfVGPuoyz2ZLCEF6AcnBULQoxmXxc7/IYDdZh0BrqbRDN2ItRjWlKdqxepja0zSsvMstMC5e3LdbehFfoEu1tM/jv2pHzC4wy7Kdegf1frk4br92s3Nv56ZRyhsdmXz3VHij4QfbNYLPW7l1uGp7rDR1PX066MXyKIdj+EvOwBs4Q8W9lC+B0KsuLtpK4MlMmDg9biscDU/alKOZjiI6rgoURBWA6ccyWyPRn5aw7YeCp/RC7vlnIw+zDI9sV5JcDHSSy/m1OaKAzkuNCbspYWHwag8ef1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78mFrYCJCjC8cGcXLww93kCFW8Qf6P8C8oDZsaAwyzw=;
 b=FUIppCGuyzEusRSuD7u/NofI1CN+T4ArxAonw5vfgoGPlIQLgUQAB2pS3F9alWVENhiXzuwqgSq1d7BDgzQpBMi87cVpXCy2tk0qkWMzeEJy4xh+GpKnShQvip1OZkthSYy5tl4ZBQSB7hinoko29uzdd80DYiRz64cQf9pD4UC/uhghMTSK8yO95FxZviAq1SGnxZq8++YNIxyLT/IfMi1poEgoFodctntngigvAEkCaF2iIROyehyOHMmUj3TTI4iUSpaYqzgavYIZeNOq/ocMcb4QsSBAhqD59CaOk96F3keDqTfA48KhFU7acX82FT2wSZyQRz3GB6KCcrA25Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78mFrYCJCjC8cGcXLww93kCFW8Qf6P8C8oDZsaAwyzw=;
 b=tkS5PyFuzWeSv5ROi6tN+aTMoSnjSQQ3cv0LMoYu7MqL1jxvMrRfUoJTL9DvC7TbIROEMU3E/GsbpYUMsGTt3Leh9oUUK9lg0mL7/db4AGupWgaobN6tYBm5+vTSWIu+h5e3hIhd6mhhflrtXzfNBZjEjNQWkvba37hXwhixgyA=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BLAPR10MB5139.namprd10.prod.outlook.com (2603:10b6:208:307::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Tue, 2 Sep
 2025 08:08:34 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Tue, 2 Sep 2025
 08:08:34 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 07/15] perf bench mem: Allow chunking on a memory region
Date: Tue,  2 Sep 2025 01:08:08 -0700
Message-Id: <20250902080816.3715913-8-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0086.namprd03.prod.outlook.com
 (2603:10b6:303:b6::31) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BLAPR10MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: 41ce98f9-847d-4b61-1bb3-08dde9f7e978
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WWFEDGWRjFL3BmJxd/4gzP5SdlWgkK6dKEt+MxaFxXu61/LvoRAMfAwHHsql?=
 =?us-ascii?Q?AWqmtbRcd8Dkiu5D7hniAdSkgwFZPBNrjW28UHygaPzpHHBRv0nrhgLMU+d9?=
 =?us-ascii?Q?am4nvMacVzvEQoCtLiaPh5waVb6sqisVY3HUW7NweOlHCrA5XDyEMpqBx84f?=
 =?us-ascii?Q?hy3EOU2Tfo69a+xQWqYUwjstfvSC0dTjb+q+5ZZF9SFFbQEs9vPEw5sT3HQO?=
 =?us-ascii?Q?MB3DLp4NLkrzDlatklIeLg4XT6nU0hUIACEpc0OMGuX05CMqXVEw9IZpxR8H?=
 =?us-ascii?Q?yyJFJ03CmmI546ja1hXNqLMWMdkmuGJSKBoyQPdMagyDlZIqTCfcaLN8ZeBX?=
 =?us-ascii?Q?y9rqMmkl4/gVkSnfOoPwUeJweSZsGmXYz85uXD209jXqEQ+apiuvjS3L37C9?=
 =?us-ascii?Q?DW7Anfvy4CT5mmmBd2UBx5Jcsk1ivwcqIrN5VAreHoFB1iF/cUazXqTgcJH5?=
 =?us-ascii?Q?2cP27bVVhaIszS6bJSTuRtYrkyEMP0t1sIU/Jbi9tAUcOAEVK8YP3BCsxN/d?=
 =?us-ascii?Q?0W3WttzhHFMoc3a0DbKHMg+KesQ99roND0t+kYfkKuu7bRMOYVNPIO9mzaql?=
 =?us-ascii?Q?30nluxKg1B1NRLje4/KLiJxrMrQbniv/nWeyYjlqrl2VFWsemmjlzXxL+pIx?=
 =?us-ascii?Q?zDh+DdQGDbwjwlSOzSYMZuLTOLkvwcr4ZC0t/OY+cH3akIaDMAFtXfip92e6?=
 =?us-ascii?Q?1dnloauAyPonws3epp1zE1Ok77emm0N1thyXGbMEdB29u9meRUuL81eD3PE3?=
 =?us-ascii?Q?3O4Z1+HBNMiH6InKuKUO3B2y3HNkRBcuEiNvV0TNICygTWmctCCYd6L6+Vu+?=
 =?us-ascii?Q?mHi+tgNj+YcMOJhoYAcEj/aeY/u6WXbuvzOL4mk8hNUgZVNzqerxDv2jmhAO?=
 =?us-ascii?Q?/w1xpnwIwxjCLLJpxVQc0JyBJInp/guwogsXTV9bzVVHlc0zyaw3tIjK1ak9?=
 =?us-ascii?Q?clPQ/OVY26seMRJCpY7yZLcxv05FMVjfYn8CEYVunAaz6T8EQj3oh2GDpiB/?=
 =?us-ascii?Q?hnZsnVQcEhlKHv4A5+aIFjj2WtbZ2T5xXV+jYM10XXX8/A0Z77tT7/gNpMT8?=
 =?us-ascii?Q?rTBIhpA/wgU79uUceNicn6V9knXDzU/31+8JjDnK2+rosJEkFRC2hkaUGfzH?=
 =?us-ascii?Q?hdBbRnjgCoNfZkRwk5ceJEiBpFbp+HZ3r9aEaKVWViprcgg3Mx8l5cT4qLmr?=
 =?us-ascii?Q?a3rWG1hIBTmbwDeN7K7DvOmbZ+EIgxfON+IWr2zlOqeptVXyHZs4cWfVROMp?=
 =?us-ascii?Q?0x3ngKtHI+ZiYJnJemRJCyq2DHhpxEcop7qQwm2W28rlfN84ZeDs9n9Gk4Ni?=
 =?us-ascii?Q?wjw0lJKLAfMLQHl6bvhM5vS0Bqgd8F7CINAJ5V6LFoDxh4UoKigUxGdIpYOo?=
 =?us-ascii?Q?mB+R3ARrB2F9M3iQDmo7yvAE0+xFoWAkNR/Fw8/9IsJ4BhPblw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ECvhDfn4uKHF2uC/qjf4+tVIcNo+sY2ygqZIJN0sydivJ+MeLnVs3FzYR4i9?=
 =?us-ascii?Q?6UuCBj6tYS9N8KbNZ8ISOBlk6Ar8lYT/H3wFu3TXD5uKUfT6XUIBsKPMPxVv?=
 =?us-ascii?Q?QQzB9EEqlqiz6RU+W9t6EZIpT0AjvI/L5Ko2MEtWDyTs2Tn28gP+FGBry1YW?=
 =?us-ascii?Q?O4rJpbmmqIu4eSCwMBjPFQGHssOsoTArSYA9IMCbXol7h6LREPMRIueFbHbY?=
 =?us-ascii?Q?PNGpitZ2S0uWaHOogNQkKK6dzlfLZ2LWYInGqRRPaJUt1UwBUdwCNUwyYLCd?=
 =?us-ascii?Q?K82p+fSgjmLeel+s+qztGvLPyQ/GT9dSgBQcUQbDpp3lvLyBrEwazAMUwpyl?=
 =?us-ascii?Q?pu/tWAVxGo27T0qCOgt+nyuIJPtrklF2muT5ZbkWHvdToi3iUhBVgm1xXFw+?=
 =?us-ascii?Q?HRv83ziLLHU3vk7kXT45KhWhfNqfHuelcdZYGPvUOGUSlJm87KwHt9IJQD99?=
 =?us-ascii?Q?Jhc0OS+WAOPhdt9ivGaTwmumzFW3OOhsSs71qr7NHF3Lk3Fh1HzqoyVG3sp8?=
 =?us-ascii?Q?MBFfx8JSbOf+sfosDFlpnkY+Hi6wPOYKCYwMcdBoqA+dSAw5a0Pd2hMV7CVT?=
 =?us-ascii?Q?h30WAHZHFk+8Z8UP5IAzkPQctoWm25/NyTXxBEIpeXx2iubIa93dxnkJYMIh?=
 =?us-ascii?Q?8VffIaF/z1XWQwYGYiWv0UMJVgCmBgN7YFxvcq5Huc/x+sNVaWULgXXpKmAX?=
 =?us-ascii?Q?LhxAZi6dajS2nOVrVbiyuhupJDm6XC/lULYPcpt/rOH0TIxqGIFCAjHWyYbu?=
 =?us-ascii?Q?TGMjjBH+UU4Z7EZCkOt0XD/14JFnYVH8ikC4kjz21KyzQiEJI6SijKZThB+M?=
 =?us-ascii?Q?ZdKeYAALaQq/UuPNMZGzXYp1O4DqGk53u1t1npjdu3UMvWqBQ7s/qpXduLHu?=
 =?us-ascii?Q?9NaPOdudjqkHmRjHeBDMIM5tPtNTyKlM1n2rGhv5j+OyRiBA7QgaBpiCzPfh?=
 =?us-ascii?Q?zzVta2A1A/9GVfQYyanFGAC0lqgU9bbhW8b5IaPzx7qH1R7U50GRhMciYMVu?=
 =?us-ascii?Q?mSbgBrgL3XWXIxr6NXwrfR+iyE/F6HBLmHFGFlno9K3h2J9pBA7K4lKq8hzl?=
 =?us-ascii?Q?KbptpApl0xkAyONy6GnmjjZmK8hu+1ddo2YrTfaxlzBO0sj4dsqnv3EKRcwv?=
 =?us-ascii?Q?7KzSuZ/mEb9DaJEp6sNIZjCpyoXiel7ur/f8QBH4XykvM0OAsCnOpSbu4E1+?=
 =?us-ascii?Q?p8nfaUwG7h2IR3AGoQuDjk91e86EH9XQqSGkUXsTDglEIDQ3MMpx98GRHWrI?=
 =?us-ascii?Q?+JJs8eFnxqgZFACQN2N/QX/9aBonTMKcilEZPzbw65qEP9IuAl90cSeICRKe?=
 =?us-ascii?Q?w61hCBw73Z7ivSIxGNew99HILR5eOKy6SQEWreuZXt3GXOhPfm/TJhmreKYD?=
 =?us-ascii?Q?iw6zMM4fQJDwtS3IS6rN1lqlF9/PN/fd0kItRRjpGpnfg81MDK9KXcavfvxg?=
 =?us-ascii?Q?d6aN1OQrfXG16+jRhJ3Tysns1fFCSf0FpJOOybkem22xs30y5LfczgqHyo0h?=
 =?us-ascii?Q?WJn2U5Bpy/DwBhCn8yA2IFWWlcBefNCyyEc1121wM7gmAc7cra4kz44L3Rg4?=
 =?us-ascii?Q?1UqUhmfH5O0UCaeiRiea+claZepKK7tFKsy9ogSpZh/GtGx1DOkfw8fU3ijA?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rzAIhN+kn++iGhgDcJg49rpaI7ztqCt/kQDbCHG7rJ1CFkgrRdk5GgdjxJAAC+xMRc0EYXa9NzMMQ25XathhPih2/H8QZiSPR2QdeCrwkKwUH+UsmPZxomOwYDBxdlvUN3VV3RResmXL23qq8cogHemai3veA4XqswD3JrJOYZ6/g66WOpcRZRToVXxScl2P5lY8D7q+TccqgWCaJ4UVgYi/++Twng44C4BtDy7PVTPCv1kw8pKGM9gfG1uluIMy4J0GJ+9EK8Y5P5gaBcPybftCTXcju8CxeopMW1F6WmQr4Cnki2xepWNdyW9MFzusyJTrEQnPtNadL6LVLhks9Z6j8zfiIgZ0KATj4ATZFElTWJqWlSr9+PG8yWFSg/yJbXvg2OpRnUAMGjJiw35EcKciRvV51ftbTFkec8YN78tFY+0Rn/eIxXrvVtTUoPj8I3wMY6szaErZpv/seJHajYAa1K/ETjJHo0PqbbXWD7CX5tPsCiGxT+tkNvDXQ8aEKZwXViMHMa/FgXA97fRmb04bo2yEtMQBc4ouICL/DtElBBCqA7PxLAhll+SejejRcXNLIERF6hhQXXl1c/xPb5sPfoTU79u/ZHdViNMA0yo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41ce98f9-847d-4b61-1bb3-08dde9f7e978
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:08:34.2303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AK36ES3P2+XyzWN+ALeqtNTDTwzMsRd068uS1QuPiDCiP7JMBGBHwpLX83l2YUjwB2rIEKHM8BShOUpb6XkO9ccWlu+LskLl8ZJX8alQQzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509020081
X-Proofpoint-GUID: URePU8g-pd_ac7Y346C0pKCrP5C96qd2
X-Proofpoint-ORIG-GUID: URePU8g-pd_ac7Y346C0pKCrP5C96qd2
X-Authority-Analysis: v=2.4 cv=Of2YDgTY c=1 sm=1 tr=0 ts=68b6a607 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=Us96s6kiNGSoJA3BlCYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX/NZmrOtGVC2R
 eZ01wp9AKq2G2MyYTyQDLcoKqT1808KVLOGmPCfilgQ+OBAue5i4AzoJDv79zD0D8zln57nVp2G
 H61V07xgeSQizF+VlG8H8xcFVIJ0DgYBEVpF3Ce+55vSNdoK8egbEbD7z/krxp68gypBZyjOz2X
 InR8CrB2juG2T59KMpL5ErewnbhfCkmEpPbDh7EAg0xhoJsB/0POerOaUBZbLLwgDwhRnaDLOC3
 sCMnpcAEc5vT+G8J1XIB5DhY70Ookc9rxl1/hoD1WtBPb9WRrEH3aAIYqdtUpLHD8TmsO5+3fy0
 qg8YjtKqBmRGCYuBO2DdOWTqR3fG0DrqwbghlmtTKLgGJY891f719xTkauvfDKqqsLfE8EykAQF
 qBrAhICL
X-Stat-Signature: he6h55gtoxj57e1knx3uumx9xox6mczd
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B362C000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1756800530-645345
X-HE-Meta: U2FsdGVkX1+Zr1DqldEKqV98EYLnwBqeY1Rq3I/cw7XOFsnjoLfLVRABlSldT01OSk1ZtXsXbA9GyXpfSRSfcEQyj7SYjXFePVXAhLeWX6nJubFGqPgDskRdShhuwNKFOrvW6PI/4QaXQc6EmBy2fBs0LQ4OxfGQIytHQehThaq1M7o01El8bfVk8805e+e5AUVaV3sVxyEhXx5gWi8g09rX9IcxOZpm/3KKAfioApN6mk6WSjRFxyy8qY91EsCXdal5e/w/U+iVoDxzVCLB9uFKM9h0KjpFdNX7oCR0Yk3BgoWmINoaP5Is7ohh0sjH07pz+9MgJ+R5OXsVS0yxNl4e2ZPUBwDku5stY5zwqIp1f1huwVLG8HXHf+KBKR0Q0Lumn0IOH0vVvglAgKbS+5h/iF8nVplCCGp8kUXxBwUn0yrdNRvqhmiAFOVU9OnHf3kw6hguEVn2+wGuuk+hcmxSVCDMkLVlOY2Fzr5DHWfO7k5xEVfm1PSzMG1bjjcl5JxkSe7IdNgF1+H7CipuAuh4/S2uFDjprUMbRdblDXaQu78bFlBobCCdalPLmjy7LwxvSpbc+Pv1KkNi1KaermKqCNLndXzzKNDAdrf+NsOONu9RGQltML8jCIZPRIAPtJrXSbD8DHTmBDJP/EbJZ0oDeEg2tpfS+cZU1GSFDio7eMaCiproKk18oh/664DhPgriib/0QbtDwYYO5UGostGDg1w+OPecxXwhLQ77Zkw/LKSLtH7jmljFGNoH8oQ1o1eZdMge8fpbH71DRWH+tZg+I9J7XyelaXxxSbxW/WNxELTmour0m5vL+ZLMXlEFN/kk3DeaTAWakJ7PsO6Fft4SD+fpqsd2GC6aK/WWjoyz6NivkLwCEeGO3FsZ2MckKjrBcI/tjZfPg91Ru+kSmmWIF/ilyLjXrYxH+MQTEbpX/OO5bQu3QqTaD/KphFNO4DRBCe6+qygzWFYkSYk
 ezVnuajm
 s0jhoslKHqt4Yn4EprPmVLAMkBuzeEvAcZbECCqVZcXfN4pt1M4CCJSQBGxc9anu/QYG2/MekoCK3NE4N7bteqzbzlxqv7ffFAhXhXBbLfL9Pd4k03Xo38poIoDuWfuEuP+Qlj32mVFbfezhgm+vTndGRF7VUfDBGIjRDBvwQabGC4huCuOcwle1jQL+BfXiwrtH+3aNCZzz1EEKMQTFdNM2V8F/A1pnl+2vF6a89QM9kE1fVznAo6tKpLHrHImXiKl5X1Mec0AXPOmbjlgYHZDDJs/opBr/hYBJ8mXVGONwCPsLzA0vzUF1FMPZHATXwhjqOE+iy21IULPvdSZUKX44sBfQur/00MwIP7BKdgWlHdbVcCEtUofkrpW4z4KIsNVKsAEum5CGFjYeT6Wk5gsHpg+bJTJFZY5PQk/2w1+rcG5lHv76GSMD7VoHqEgvsrxGrYEKNPaSjsAUDF40tRFB+0plnSGLR0rDTsyCfaYQnm8gr5v7J5+8jTz6LRAozhlcm0QGldU/63LZ3+TBAmwvCS6o8VEipbzIQ+qeq8Y+D3Ybg5GgaaO289KJ5KzgY914YIeti67acCsJgyiSTLvuyG4AGFfErjaRvOsCLSoOBFmW+USa+LFFft3eUz/Wajfufg5BH7aB7dt5H/TG64QsHQogsBL/n99G6kyGM9YlFwYi0RvfDHl7darppZADXL34OUB+rJ4qQtL3DjXAUHxaLSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There can be a significant gap in memset/memcpy performance depending
on the size of the region being operated on.

With chunk-size=4kb:

  $ echo madvise > /sys/kernel/mm/transparent_hugepage/enabled

  $ perf bench mem memset -p 4kb -k 4kb -s 4gb -l 10 -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4gb bytes ...

      13.011655 GB/sec

With chunk-size=1gb:

  $ echo madvise > /sys/kernel/mm/transparent_hugepage/enabled

  $ perf bench mem memset -p 4kb -k 1gb -s 4gb -l 10 -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4gb bytes ...

      21.936355 GB/sec

So, allow the user to specify the chunk-size.

The default value is identical to the total size of the region, which
preserves current behaviour.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 tools/perf/Documentation/perf-bench.txt | 10 ++++++++++
 tools/perf/bench/mem-functions.c        | 20 ++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index 04cdc31a0b0b..3d1455d880c3 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -187,6 +187,11 @@ Available units are B, KB, MB, GB and TB (case insensitive).
 Specify page-size for mapping memory buffers (default: 4KB).
 Available values are 4KB, 2MB, 1GB (case insensitive).
 
+-k::
+--chunk::
+Specify the chunk-size for each invocation. (default: 0, or full-extent)
+Available units are B, KB, MB, GB and TB (case insensitive).
+
 -f::
 --function::
 Specify function to copy (default: default).
@@ -216,6 +221,11 @@ Available units are B, KB, MB, GB and TB (case insensitive).
 Specify page-size for mapping memory buffers (default: 4KB).
 Available values are 4KB, 2MB, 1GB (case insensitive).
 
+-k::
+--chunk::
+Specify the chunk-size for each invocation. (default: 0, or full-extent)
+Available units are B, KB, MB, GB and TB (case insensitive).
+
 -f::
 --function::
 Specify function to set (default: default).
diff --git a/tools/perf/bench/mem-functions.c b/tools/perf/bench/mem-functions.c
index 6aa1f02553ba..69968ba63d81 100644
--- a/tools/perf/bench/mem-functions.c
+++ b/tools/perf/bench/mem-functions.c
@@ -36,6 +36,7 @@
 static const char	*size_str	= "1MB";
 static const char	*function_str	= "all";
 static const char	*page_size_str	= "4KB";
+static const char	*chunk_size_str	= "0";
 static unsigned int	nr_loops	= 1;
 static bool		use_cycles;
 static int		cycles_fd;
@@ -49,6 +50,10 @@ static const struct option options[] = {
 		    "Specify page-size for mapping memory buffers. "
 		    "Available sizes: 4KB, 2MB, 1GB (case insensitive)"),
 
+	OPT_STRING('k', "chunk", &chunk_size_str, "0",
+		    "Specify the chunk-size for each invocation. "
+		    "Available units: B, KB, MB, GB and TB (case insensitive)"),
+
 	OPT_STRING('f', "function", &function_str, "all",
 		    "Specify the function to run, \"all\" runs all available functions, \"help\" lists them"),
 
@@ -69,6 +74,7 @@ union bench_clock {
 struct bench_params {
 	size_t		size;
 	size_t		size_total;
+	size_t		chunk_size;
 	unsigned int	nr_loops;
 	unsigned int	page_shift;
 };
@@ -243,6 +249,14 @@ static int bench_mem_common(int argc, const char **argv, struct bench_mem_info *
 	}
 	p.size_total = p.size * p.nr_loops;
 
+	p.chunk_size = (size_t)perf_atoll((char *)chunk_size_str);
+	if ((s64)p.chunk_size < 0 || (s64)p.chunk_size > (s64)p.size) {
+		fprintf(stderr, "Invalid chunk_size:%s\n", chunk_size_str);
+		return 1;
+	}
+	if (!p.chunk_size)
+		p.chunk_size = p.size;
+
 	page_size = (unsigned int)perf_atoll((char *)page_size_str);
 	if (page_size != (1 << PAGE_SHIFT_4KB) &&
 	    page_size != (1 << PAGE_SHIFT_2MB) &&
@@ -300,7 +314,8 @@ static int do_memcpy(const struct function *r, struct bench_params *p,
 
 	clock_get(&start);
 	for (unsigned int i = 0; i < p->nr_loops; ++i)
-		fn(dst, src, p->size);
+		for (size_t off = 0; off < p->size; off += p->chunk_size)
+			fn(dst + off, src + off, min(p->chunk_size, p->size - off));
 	clock_get(&end);
 
 	*rt = clock_diff(&start, &end);
@@ -402,7 +417,8 @@ static int do_memset(const struct function *r, struct bench_params *p,
 
 	clock_get(&start);
 	for (unsigned int i = 0; i < p->nr_loops; ++i)
-		fn(dst, i, p->size);
+		for (size_t off = 0; off < p->size; off += p->chunk_size)
+			fn(dst + off, i, min(p->chunk_size, p->size - off));
 	clock_get(&end);
 
 	*rt = clock_diff(&start, &end);
-- 
2.31.1


