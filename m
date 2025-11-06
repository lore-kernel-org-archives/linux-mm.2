Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D49CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E708E000A; Thu,  6 Nov 2025 05:46:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56248E0002; Thu,  6 Nov 2025 05:46:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6FE8E000A; Thu,  6 Nov 2025 05:46:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7712C8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:46:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 078ED1405EA
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:46:35 +0000 (UTC)
X-FDA: 84079853550.24.C437581
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id A88B21A000C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:46:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Vk4Wwsql;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KupxTZpI;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762425991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OY4sQEBA6GdCo6e/oBbiBxAXDnou22SyMrMXB4Df1/U=;
	b=dSwJgwfKLy7ccPbEW/r1gciND4R+txR3ps4TVBvPGvdAmGaI0n3lefGZXUS0ey4NkRGRi4
	dgOX4ybEVQUXMpqJ2A+wea8XeIUMawbmzoqxy2Qsz4lb4eEQbmhh+zBXyjN5RwdsN5yDse
	QzOJFYinN1zDEESG+xYpHdizgwsXWjE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Vk4Wwsql;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KupxTZpI;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762425991; a=rsa-sha256;
	cv=pass;
	b=DQB0a2NGL2rxHpGqsvbvasqIqOZ7t+NNooSIZFbLVz/U265S9idaMnON5phOp1wSXqFgJy
	SK9vG6QoqnMUV872IkegLaTxbXXVCFfOsPBXFEeeLzTAjeH5ovMw8UUTmlDdsy9B6SpEDS
	Hl2r06uvuPbz363R47baCeomklmtwcs=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A61CZ4g030462;
	Thu, 6 Nov 2025 10:46:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=OY4sQEBA6GdCo6e/
	oBbiBxAXDnou22SyMrMXB4Df1/U=; b=Vk4WwsqlRUHNwMDIDB4oxTfLq0IdvFBX
	8U4LfPIUJfiaOEmrJe9mTUF53Mt9pxmb7ZaG2En5GrgYYM4i3oZb2O/lznVhMR45
	1ohO1SOYKgiNqLF00jTFnnBHgQU4TFrXmlk1BFrPoYceVUBCEuKA0BMfN0QWBTV5
	NChbLvuwmhW76CsYQINMaC0oQUzc0zhbWt8MdBCCcxrtQSizPJCNfnFd8FScImO8
	k8B7zLDFlBUv8Rt/l++OJ/9iqOHxnuNyol3205nQoy67KKJk7ihijLSBkvRvboWn
	HGX6AGqi4Ylx4PgpM1vlNack5BoiVIrcMC9mcZIXSdiJ6aZvf1b6Ww==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8anjhqak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 10:46:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A69vOge010939;
	Thu, 6 Nov 2025 10:46:23 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012022.outbound.protection.outlook.com [52.101.48.22])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nc8c1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 10:46:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PEdbOtpobwhhlpAkDqdhBSBBZZNWNnInGWbW0K4gRPrcvtbjuHmjyfq8cFquXA049/rf6Ux5frOX42tlOd9OU/NnZyGXDXprGhIrVJN6CUTzewftpkJhGiguo8EtL0mfiIuz8dqoq6wBE4s+w85+qKwZACCiE5c3bJSiR3I6riLnGUDcVN62oq7ciZ9xicS3UrrkMbWVMzPGWGCqgVqzWE0706VcQ5XQRfuBxkNaQd8cB2/1U5oTik1KsCKAL5zmbqDNeIJ35Ht53K/oAZ1SBb4cVF63QSMmoGwfH8NWw2wZ27Y+ZWaXshQtagTnVf2QbHd942puOVwTeAh5NzbhXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OY4sQEBA6GdCo6e/oBbiBxAXDnou22SyMrMXB4Df1/U=;
 b=EBQTo9oYMK415HDn2YU/ohlYJghQ9FMXPx8v3X5gYi44si9pxzlE8hAyu17r7JtsPrWDeffjnR33fJSAFnWp/hG9TNdcKlyz/UMXmWjgCvc6hyLC05SDI5zPV+pY1L8V1TrA+OoC7h9CpaKpYRqrZxHTGrCAz4E8JomSIGEM7LDbJCI8iMVXx53hJjmh6N2zaNxb4PV2yzI2frPUO29PHuTnEycYY0g1uQAJ5z4m9KhQ7llwzH8ax+wFxkztvckqzoONgj9UGZM0S5S8KyxMeQOOZFjzl79hpVYQgDwHZvcbHiIYSFC1w7gOXdJtwUuqhDBOvAgn9ctlcBG0VI3Mig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OY4sQEBA6GdCo6e/oBbiBxAXDnou22SyMrMXB4Df1/U=;
 b=KupxTZpI4/v03vLjtovs9rpQcAW2OtsKycIpq5h/cF/eEDzjpqMW7/i9pVzkBODpKsfj58j61pwGNVYLwtCXPGABk7URAdozflAdixe7vLokO8hIweHC864H37m81HvLffM5MLr6OtNlxeq9z0PosjHigtBJw+0f5j88Yq59akQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8250.namprd10.prod.outlook.com (2603:10b6:208:573::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 10:46:20 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.9275.015; Thu, 6 Nov 2025
 10:46:20 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Andrei Vagin <avagin@gmail.com>
Subject: [PATCH v2 0/5] introduce VM_MAYBE_GUARD and make it sticky
Date: Thu,  6 Nov 2025 10:46:11 +0000
Message-ID: <cover.1762422915.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0159.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8250:EE_
X-MS-Office365-Filtering-Correlation-Id: 76abd572-c730-418d-faec-08de1d21b88f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v/7KMrVxt3r3Lr0t/q9V2WJzanKdRW/mBFCP70i+VzXVE14Z3rgzOp5RZtK8?=
 =?us-ascii?Q?e9y2DBq6kiPepnNk7DGvC97WdtnlGUrRwLnKkWl2LLh5oKdoSybEvAYqyrJm?=
 =?us-ascii?Q?ec0TVjysWhHV1NMx1OcSCHcB0qJH+pVnpVWn4mNRhl7Ri4JrGmBMs18unCVw?=
 =?us-ascii?Q?YDyBgLAcEdBXo/0Pa619RqnUFYcHlOdYx4HcHBBlKZJK1rjk26PViJvL+kum?=
 =?us-ascii?Q?zu4hFg9yysm+AphNcphCExN88hH9Qps+f2FU18HBugxpDKuj2010Vnl/wWbD?=
 =?us-ascii?Q?Ac9iC94WubDdpJiRpsn4b/1feTl8THPYHfL8D5VUojqTV5gCrcw6r7aP41SJ?=
 =?us-ascii?Q?QYcwhg0Z9hVXw4D+Inri/AoRZEo+cvZBeQaqs548patqPDCTqUBrWMWXFZu+?=
 =?us-ascii?Q?/gtnXitwFCuWjX66/pc8U9WA5gbRNwCz49HzoILfjHt+S2C/zwD74H1tGgOH?=
 =?us-ascii?Q?TXLwjdBNbwuxRCt3tbj65wqnpX0Ab85JB4kTr8QqtDU5Xho9PeWDB+AztSeB?=
 =?us-ascii?Q?VzEbrLi43iIwI3qrf0MFxLDOycCudSKanji2Rdoz+Z1f9SDMgFu6uimKp/DP?=
 =?us-ascii?Q?F8pWnQI7a5dEfGXG6FMIIQgJ/rD6McufN+pJJWD1wL0bYdxnKffxSTlaGZKP?=
 =?us-ascii?Q?GFwIVDZRB6A+uISi7OmBNWTSimeLmiUe7fCocj+R+1Ml8sKGu5Zllpfle3Jg?=
 =?us-ascii?Q?7MLJpBdYEyJHA6KIXmvFWWI62YVftVkrzgM9zWdxj4i9FV7n0P9dcQk3viK4?=
 =?us-ascii?Q?1Egao0DMX9MhmSRc9fKgwqOV2K4lu2Zgk3hwik00+oNeqY6XQasRXad7h/nW?=
 =?us-ascii?Q?2D1SGXjZk1sCt11+h8bmtCS/f7YMhp6J2oTna+0spDg1T24K8yJTVL/8EzkV?=
 =?us-ascii?Q?pbT55nR2gC+J5G3Nk68EHcmwIlNL2Q/A0fMFFIhimLxZB/gR6iR7MdZdTiEy?=
 =?us-ascii?Q?igSAxU7hq9oH38Whv2qT/wPNImiMjNIAnnrZhdL0G6ztzV5xaV9Z1unor1Ox?=
 =?us-ascii?Q?6Gmp8hcQXBHcYPSvSh7pHHFe++MRydo1l7rd10WyViTPxmJfr2eQzegZ3Phk?=
 =?us-ascii?Q?3aFrC/52IpvBOsj6wftEe/LbMX2Lab07L/h5CyO1Gops+RwzbVfmP6C/QAXY?=
 =?us-ascii?Q?HLP51ph5TGJ04t95/7N6s5C54yYmV5vJLkYjL1m0sQ4ltbiShTDUNDHWJYJZ?=
 =?us-ascii?Q?hvSqjD5L6iB133TGqplrC+gQYYbnwpSH2xxV5q2w6KgamA2Zt/9pNYBE/Z+T?=
 =?us-ascii?Q?9ejFR7y+91nbTCOPrYxazuccmz/mdrPjo82rbe9a+0Yy/u84oupKjhd0t8/s?=
 =?us-ascii?Q?r2ZKjANqnnkQB+Xkh1ycMv/l6jYat4VC1pVyPuKGEce8jr2FlXZVD4QRopBG?=
 =?us-ascii?Q?W49arBJvQG0lPReQGHj5JgDlSp1M/GxHwFrDLPOr4GbIuKTHs6O4R8CdZn+b?=
 =?us-ascii?Q?YxY/X7sAVpehG1o0+46iqjtGHOVr43u4ijh5DPHno32Q4QbAGZGoag=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mwfqfnGnFMtaVhXdX65m3XsLHoye6z+jlhcESmicpzMFRLBe9qs73Sdls/pH?=
 =?us-ascii?Q?nAFmgg//40VqkBpuAtqtI2n4L2H04SQhd3BFyd7f0ctop5OLr+oAt9JodHXy?=
 =?us-ascii?Q?L5gqWJPhvFmSHg9mXG0ouXfwCpEtDTwu+74XLE98QHRbUa4tMZ+CG02Up5S5?=
 =?us-ascii?Q?HlEXBWbhlojajxc1/xs4mZgHh/59Apl/FwN/0oIKG0ShEjqSQdxGNd3GF4hv?=
 =?us-ascii?Q?IYMJ9jXPDdNKrDfw6q5OmBh9kCbS3AljjmhyCUHLJg2OglUfSPB0GnYktzwJ?=
 =?us-ascii?Q?W1kTTYgTDy8CXzyySvyu2rljNxzv+y0tyqr7mJe57ESPBdgNLv+jGIrG4N7B?=
 =?us-ascii?Q?95tPdf2GeWvoIjOSejMcK5SmL/atQaUioyqntNsxgFMqDC/yxEBHqcgNsbFm?=
 =?us-ascii?Q?jqRM+af9U9IfqIlyzOCU1wR5PPgOGbE/rsev9EhhP44Qqzq+nt1pU0v302mD?=
 =?us-ascii?Q?NwBs/schYRq+wXVGcxotmhD24B/aniAyNZe2cGPnZ6hVQvAIPOW9lK8XfPZx?=
 =?us-ascii?Q?P8URwMSCmnx3iC9sxfu8z6rx+xev5vH487o5NMyTn+PFsfdmsZvbkVbNp/sW?=
 =?us-ascii?Q?auB/qxHuUkO+Io9F5Lw5SlVMkx/VfejsTAk3iT38NeswisRmL+J8y415+Cmg?=
 =?us-ascii?Q?aSAVhbI1ZGwNw7mV/TAtZdS1+MufM911nsBkytTSWFNqEFEB71DgE0Z8oIMC?=
 =?us-ascii?Q?sLkkzIktg8WA3ubL5wVJpNUpNU9C+VYVMn2E/cgt8m8oFYQ8TRZllHmzldXz?=
 =?us-ascii?Q?dPzoKRyxfb+B9ed0hUpeJ02ToCAplAztu8ZfxzDUpG2L3lQfvZWuF6fLJFCO?=
 =?us-ascii?Q?JfYy761/qCsed5yxTmVy1Fevwcw8O5FvUM7Om0WNYrYsjx6+5iaPsA0IhpyD?=
 =?us-ascii?Q?tN+tpm0ArHgml31RjSflWRL804ZfxjO0QcWhrBpqAl9ATbDb0vda/k5sKM8s?=
 =?us-ascii?Q?RAZIoG4o6+HuSJKW3sU+m9PFm3NhYf9ABLBS9dp4rIkVY+8HYE/+w5LnZP7F?=
 =?us-ascii?Q?zzzBnvSEykxW9k6PLr2FK26c/t+GkAhgAScO+Bc43wMTZMpmE9fqBfMfV00c?=
 =?us-ascii?Q?9dfdVq+jzsaQSiPhKsf1TuxnOG4VFOjpWOkE8AxdQjMM49+pQDYNKUxbqzbY?=
 =?us-ascii?Q?xo2b1nHiI9vUlH6eeZ5KUtuzxONx/gz+OPwHFeF3ma4ceFBaZcdNO8HalxZc?=
 =?us-ascii?Q?6St+e7EhJ/YjjjIW5iy/R7lMJFxiMtHFXhw7UVIqgfP5xcdi5dSEKg1BubE9?=
 =?us-ascii?Q?BrD5M1kKKsdmo51HtzDtWRCD+Q8gSks77JSQtgkQ5x4xNehxdzs4fCK7nK2f?=
 =?us-ascii?Q?kX1lD0Zxhjc0b2jXuH1jJp0+KomoaU8x0DxAtzzfne8TvaF/it5SsDehTiFM?=
 =?us-ascii?Q?c3hCmRm5GLAbp6rsv+wHLWBcSk/ILPzxXl/BLNz4s6IuM/EaYX9vVPRVIjp5?=
 =?us-ascii?Q?OItDeFFLxhwn5GKWPc916kteAGBUSaGSEzSdPLPBAH1dkAfVx1HwoDXpTQp1?=
 =?us-ascii?Q?ScCpMoyLIQW+7RdirE1r42INWnJgH0Xs+isIUV84oPD6zEI//LIZl8ox/NeD?=
 =?us-ascii?Q?zne1L6+vb+UgdX3eC95+NxrWPMrwLsQjpKDOzO9IjA5xxcqdw4DSRCg5Fkfh?=
 =?us-ascii?Q?Fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uSlya64c9CYTNss8a0+qpodmhmCP0D740HZ+ycMpsbru9pv9Fqba1sHo9LPvHYr7khORCz6/vXxdnTpzpGyW1FYQTJSDop+8adKbkayfWZtsBKGbVvGp4m5CE+ZAUoXo3EeaduJAV4g0BnT7RUVwoUnBHImr8v8B76f0PYNjuITDEhD+JzCatMQ79uj2VK0/d3OHSeFUf4zc0zW5OjdFyYjLu8465Q94e1yokeXd9ItG+ptQkUFaHgT2iziUswg+z247d6HhhJ2+VH6hdVMrAL0IiV2CsROoaRFbd6wfcQP4xgHTEJUO2UeS99Y3jFpQPE8MulSoVOtSZ0bmUDBYtp9HCAj/U7EtbM1/FvBMZ/3vZlJh0Ftlvi2Qqphao551MRRU4qMNcdCBWROS0yZ+6FSa6oyQOYx2+yNhy+aImq7VMoT0jpFUjYXLpWs7dZgDQkR3lCzqnFJrpJeusM5EEdH3dBXbceZGIMw1E0Gjtmo7VqiAXGvZOXkWBvsJOu8LYOpY1PIM865qKzvKqc86Nua4nXcJ9UHHkO0xRox674pTo6MReWqnSokBFdfCjR07LwhoQLgCvlJFhm87OqfhOo3pYVTws4Efr9WJ3Jumfko=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76abd572-c730-418d-faec-08de1d21b88f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 10:46:20.2393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2vgxo3smLlr7ytZVR1J7cEzSmtlHQl6/cBXSh1KYDJx8lfqKNF0pKfXTfy2b9t+7wAgHKF6Px4M+NZtzP3rNfMKk9P9McGXWLIf00fmMIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8250
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_02,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzMyBTYWx0ZWRfX1KspxOjobdi/
 3Nqmb9KFBFo48uLLCv8cIkzYradlQNjHOHC3OL15nr51Tn50jfxw42IrxefP5FngnGlfbocgUtb
 geBoJnOqt3riMdQArE5kPdJwCaPeaZtuOhxbu0nn/XcrfZqT0M9/FwFdKdvXAjA/GdFvZuLU/qu
 ZyaDrxjUFbFyPsvrcuj0MGpR0u3mwkifvkoc/8GUso+tAclGT3PtMODMYa7uC/eA851Rg/Dkg0V
 szDLe7PqxxFN8kxd1Oo642CS6Z3pIOGjTIDXBKtALt3QLxnHiYqLWxllVARXotH4AwM/gUr6IyW
 2gb3w3Hu0/fuVcSHsN6/tDSmHhHUHq43F1xR0RpsnP0YqfITNrwPQAvKryN5VF1ySB1K0X9SrqG
 Db1z1k/hsc1lk/F/DTSEbZwCHM5Gbw==
X-Authority-Analysis: v=2.4 cv=dfqNHHXe c=1 sm=1 tr=0 ts=690c7c80 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=j4PyLaJxrv0Xc63m2dUA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: v9iZ4iJAC2el3coqYi0y6YyBKWre99CS
X-Proofpoint-ORIG-GUID: v9iZ4iJAC2el3coqYi0y6YyBKWre99CS
X-Rspamd-Queue-Id: A88B21A000C
X-Stat-Signature: c5e66ngqfzsyjzofodm54wioq7w9p5ii
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762425991-686035
X-HE-Meta: U2FsdGVkX1+pBhHkd+YixPpf5U0O81reXKDGvQXtniOA4QKopScj4rf0RNTR7UZf5XsVs3nscxWh8CTqPeaExp3lsxJokHUUe5m42W4NXxMQxhnd0uD9LfzjiZS+NG3TafldzdjEzD6XubUhk0xtj6oZa3okIA65Zj627VmK9ZwIoD0ltJ0ofnGLj8yeI+ljsFsOkXqyFvNk5fSag5rJ931F7+P8z2rhxzyfxzGlaGwtYEynDgusEMBn/4k+JbNTJHM1aCk2IKwKiM7rXs+nsHvv35fDDA18DYflmiT/5EdXD1hRRSkPE75gnz+VlZY6E27op7NXdQHYBkVc6ebyIjg3cjWaxhl0w/BYeBKXCVYQcLcLfl/Hdd5l7zE+lH30qg/TZQ3hSEGgy6cHJV82MVRBRC5PH6EsN2hsR/pq3lBc1Cc2FMxLnyl+NUgBEdcQCzFFOsdn7DPlOKqMOjYUSU8wghqpxEVmQcTt4y1nvyX43n78uzwrtjmrwIxtWb1saxbw5T8KX4Cr0csqSbl5RjNrYFhGInV4/JLkqe2dBvIIwLeJwk9PF0Uiv+Kzeecopn5R5j1GMa6BwjP/h9HMrHaawBYk2NGu3AdEpc67b4kJeALJ93ZP19zQQlG49WUlkv+mV6HpXtlBF3ZTGWWWtIaVxX9FeRlikRUmO/QkJj1qWYy4pLHB/uqzhJdixP/JuVADtUgcqGgf38ztjd69nXhdFYPg2Fr0qzWaJBXa0jj9VX/Y3EAzSyBW4F9y116VYEKc4mHhI2iWB9MxgqriygCRb6cFg5sv09eTEi5Yhr2A2ve5QpIh+dTXFT6CZTgBUc7L1EAbGMhtGfbphblT3EHz5z2nph5UP2K75pJdRNXLIHvsyrmWAQ+qHKiwYL29xuNNwkx0YiVnRAJNIy4jzs4JjB/B8sfbL3BZBDiWnMCK6fdOJRqR7ziuCVsGR50fWlRXt5c2bNlqvUKFdbL
 hCHWUS7B
 QawD3pCPYFvcbFRH+8MnH0UxiR5ZnB8yioOcXwivc1xmh5Jr/x4R7Jwd95VVVp6zMx1AIiS8036s/E+Cp2uiEuRGvey3HjOqTzDCZ026Rsz2gwO30/dfOR7jMfTUajA5XSzV7ZoLqrNi/rSzwSbPqVsBGsfXIYHzTuck2+jcDmShrovMr9pPXqcFt+vt5B3CpwTHt46c5arSEluODbEfgLuEUuq3eAliH//kVPudR4hwUZRU89fKpeFe6OHHmHTCBjEN9Goqust4NPLq0d9AUWIhmEvsNWUsir3WEae13yloXZ4h2yBnixbT6MqAjjvXfd/iXfoWJ9cw6f7FkYSISC6V7RWDJbc/1n3Y/qgSTxWexeu4eyhwsIEOrf2oDhYA7n15CCeCZzFyIgbT6Bg52MKA/rPb2UxM1rs/c+WH10Hr9189p0k2nu21NEfIvz7MYDhalr8jTbkxvCzAhR87npDf2UWMTtv6C3jPxdQQb8jtUjyd0uofM0IfLrEuiK+HSpTgn+rkDvIB28sKRYRQSqvhpt9Vm0CMBkAJtdj92i4TU0CdK3gZ1Gvf4fhQ8dirtcZB/D5KRB1xB+V0gem2yPw02h8o5hNrRsWH/ZX4CDm6YkdQ1R8iM7j3XS/PbxRYahdVC6JuTa03rDCqzv1PzfruLdMvUkccPHQiXcGptBW8Bzn0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, guard regions are not visible to users except through
/proc/$pid/pagemap, with no explicit visibility at the VMA level.

This makes the feature less useful, as it isn't entirely apparent which
VMAs may have these entries present, especially when performing actions
which walk through memory regions such as those performed by CRIU.

This series addresses this issue by introducing the VM_MAYBE_GUARD flag
which fulfils this role, updating the smaps logic to display an entry for
these.

The semantics of this flag are that a guard region MAY be present if set
(we cannot be sure, as we can't efficiently track whether an
MADV_GUARD_REMOVE finally removes all the guard regions in a VMA) - but if
not set the VMA definitely does NOT have any guard regions present.

It's problematic to establish this flag without further action, because
that means that VMAs with guard regions in them become non-mergeable with
adjacent VMAs for no especially good reason.

To work around this, this series also introduces the concept of 'sticky'
VMA flags - that is flags which:

a. if set in one VMA and not in another still permit those VMAs to be
   merged (if otherwise compatible).

b. When they are merged, the resultant VMA must have the flag set.

The VMA logic is updated to propagate these flags correctly.

Additionally, VM_MAYBE_GUARD being an explicit VMA flag allows us to solve
an issue with file-backed guard regions - previously these established an
anon_vma object for file-backed mappings solely to have vma_needs_copy()
correctly propagate guard region mappings to child processes.

We introduce a new flag alias VM_COPY_ON_FORK (which currently only
specifies VM_MAYBE_GUARD) and update vma_needs_copy() to check explicitly
for this flag and to copy page tables if it is present, which resolves this
issue.

Additionally, we add the ability for allow-listed VMA flags to be
atomically writable with only mmap/VMA read locks held.

The only flag we allow so far is VM_MAYBE_GUARD, which we carefully ensure
does not cause any races by being allowed to do so.

This allows us to maintain guard region installation as a read-locked
operation and not endure the overhead of obtaining a write lock here.

Finally we introduce extensive VMA userland tests to assert that the sticky
VMA logic behaves correctly as well as guard region self tests to assert
that smaps visibility is correctly implemented.

v2:
* Separated out userland VMA tests for sticky behaviour as per Suren.
* Added the concept of atomic writable VMA flags as per Pedro and Vlastimil.
* Made VM_MAYBE_GUARD an atomic writable flag so we don't have to take a VMA
  write lock in madvise() as per Pedro and Vlastimil.

v1:
https://lore.kernel.org/all/cover.1761756437.git.lorenzo.stoakes@oracle.com/

Lorenzo Stoakes (5):
  mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
  mm: add atomic VMA flags, use VM_MAYBE_GUARD as such
  mm: implement sticky, copy on fork VMA flags
  tools/testing/vma: add VMA sticky userland tests
  selftests/mm/guard-regions: add smaps visibility test

 Documentation/filesystems/proc.rst         |   1 +
 fs/proc/task_mmu.c                         |   1 +
 include/linux/mm.h                         |  58 ++++++++++
 include/trace/events/mmflags.h             |   1 +
 mm/madvise.c                               |  22 ++--
 mm/memory.c                                |   3 +
 mm/vma.c                                   |  22 ++--
 tools/testing/selftests/mm/guard-regions.c | 120 +++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.c       |   5 +
 tools/testing/selftests/mm/vm_util.h       |   1 +
 tools/testing/vma/vma.c                    |  89 +++++++++++++--
 tools/testing/vma/vma_internal.h           |  35 ++++++
 12 files changed, 330 insertions(+), 28 deletions(-)

--
2.51.0

