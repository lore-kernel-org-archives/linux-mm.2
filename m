Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA33FEE20B9
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7963D6B0098; Fri,  6 Feb 2026 12:14:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73FE76B0099; Fri,  6 Feb 2026 12:14:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643536B009B; Fri,  6 Feb 2026 12:14:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 40A786B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:14:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E554F1B236D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:14:46 +0000 (UTC)
X-FDA: 84414681372.22.59809D8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 834361C000F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:14:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dRDl0m7d;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TYaUJyVy;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770398083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCSJuFbwgWEWwgFPIv+QxprGqx1aqNz4C7une1rrAoY=;
	b=k6g+EZY1SzIrdHlBRtEg1ZGLToBhxloRMPKbGrPTvYgpQVN7qvnJtXtLT69m4cosjWSJUJ
	DNZYT/VG1WUDbYPaFveBykI0fFHzi6i8z/8Lvly2nFyB3HqYKPG6XjMOnowuPsJpQbQkuw
	ytNku50ouxnQcG+P37RwAlWLriEt+hY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dRDl0m7d;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TYaUJyVy;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770398083; a=rsa-sha256;
	cv=pass;
	b=3b+58KUy9cBRGxhWXRnvAMBz97B8JhLP5pzbjYY7xviOeAPxu/voe4v8CqPdiavrjC2mfu
	MOLH0Uk2KgR4m5iSBQ+h5ImFC6xtOtbd6ehy8GfTj/pYh7597cQiQZNbz3QVdC4jJQNTfu
	8r5obDfmI8pcYQ6czuL0VnZ0P8R7DNs=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 616EvZkX279593;
	Fri, 6 Feb 2026 17:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zCSJuFbwgWEWwgFPIv+QxprGqx1aqNz4C7une1rrAoY=; b=
	dRDl0m7dqvQwg5ajIm2n8x/W/QLx9VoA/1Z1RyG5FBy7tF1yXL2pFz2jpsajvETB
	HNdMhM6ixDDYp7RMNdCyi+I65F0gTHhqf5PHLtL5XCW4ChgPBuML97RhOhsrofQB
	67x8gp0vxjwPIqMRDjuW44dsiZq80qbs/JdS4wKRB3orr0GbvY587UWPCC4S9xNn
	cymeRD8Da1QSORD8Rv0aazgtBMW+FxE6K65VHtE7gRixQPGMRKjHxmBzkwPCWpU0
	3GlYCXbxgcZEN3JS6GNwI2JgfD6A5t3ocIXRvY2QZVTcNpDMsT4ZQSpNx/jgc8Ik
	oARbLYjP1l7WkwRbKGgjAw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jsqnuwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 17:14:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 616G1hrU006294;
	Fri, 6 Feb 2026 17:14:38 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011051.outbound.protection.outlook.com [40.107.208.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c257df5v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 17:14:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z6rVQPw4d7+1JO/GhdWj/zYvxbZbQdJVQzxR48sGxFVzh4pdtoEuBubH5AhIMQxB2VxQzr06jb5uM7fpaZpmtQxG7rsFom6nbYVW5uS216wNA34J2vewl/rHOJbcl1IFpdE6wEG/vGUy7duoyFQl8mcYUcTq4VHDEK1eNlrcibxiheLkkxAvXmq7NsGXepxOQcHNe7K0rvgu1EYZ+4fZyLkqAmnO5ESmH/BakZjmtM7vwh39bXdHyGKBd3kdN90ygQmlkjR9ymNgX4RhOep2nu89ybqeOGJX4TJEjFlZs7PGYWGWbLHZBu0vP4w98fFVss6ryENRpCqdRCdBPHpLnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCSJuFbwgWEWwgFPIv+QxprGqx1aqNz4C7une1rrAoY=;
 b=jU+0b46A3dBF5nh/yXzBLUKFfY+aFSZ5DMx79Z3GaexJKcHIUPBVJh8T+PnWkOlJdzFIa98pvQw4Po5DbghiBlAAzsGGaYqEVXfUjnoh2y8+47Te1udzzHF1/RiXmjYE2ZzxH6s5civSuCH+BfW4daPZq+jIqvq6x5Y3ne5HNnvOEbMaIJJRxF+L0pyeDGgUIzMg61MWEtKDjs8HeIN8F7z5VdC6mRY7dMTeWPAfmHr0VQ1ZTqfLHY9Jb9JlowiSwWfnDq92tkHB2MlAZZs1CSWLSZzL2EAM4D06ssesT8kSMqbc2rNZU6XZhu9pY3Yc7x1WPCcbyw8eKNmfZbn7rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCSJuFbwgWEWwgFPIv+QxprGqx1aqNz4C7une1rrAoY=;
 b=TYaUJyVyEA3JQhic6cr65ZOG3XewgzR0D6fFCKIO0uaLNtZZlkTSYfj7m/tgAh3EVtCzadRBdsKLJPcOAalsUlM8CT6LWIt6oBQpfvao5/xTi0Z5Q2BvzOj9H3zeSNwWWr3JzWIEsCxPqbkhKwI0q6DLbuzShsvNFguz5uOEuT4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB7579.namprd10.prod.outlook.com (2603:10b6:208:493::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Fri, 6 Feb
 2026 17:14:32 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 17:14:32 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Alexei Starovoitov <ast@kernel.org>,
        Hao Li <hao.li@linux.dev>, linux-mm@kvack.org
Subject: [PATCH 2/2] mm/slab: use prandom if !allow_spin
Date: Sat,  7 Feb 2026 02:13:48 +0900
Message-ID: <20260206171348.35886-3-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260206171348.35886-1-harry.yoo@oracle.com>
References: <20260206171348.35886-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0151.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c1::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB7579:EE_
X-MS-Office365-Filtering-Correlation-Id: cf2357d9-6bb8-43ae-986c-08de65a331a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KcR7PewYt94JVvUVKpLYBY0/AtJ3zyi4gpscoNfVSg+KUn0NnxBW9Ixx9hpq?=
 =?us-ascii?Q?X/EuWsWNdMaLsJFPvuFHS1tepatAAvh9ambrHj5PTFWtQers42vGnQvVhREM?=
 =?us-ascii?Q?1vh3YWTrtJn29pAUGVGKHloylt4JaANDnWiH9vzE5+ALNJnn6C5uEKiHR6Ze?=
 =?us-ascii?Q?u7QgY84BSs/hjruBlyX3oGjid6lgRmhL/Trtbk8XC1i4V3YiNxpPD3LW3oLa?=
 =?us-ascii?Q?EMKqZ/zGA9Pob9oJvh9MI/frm3/etJ5c8y6Frlm54LpYAKGD3LGrgfI2Y1gv?=
 =?us-ascii?Q?xxEnxk2Vg37FM6CZKhIJxir9NbuszrWLMB1nG9hnhPLr0MRkff59Bx7d0RxN?=
 =?us-ascii?Q?OgCPoFh7HNWxds1h0rmlpIGZBqTkIT6f0EkCXDYtEFJR2VZWUxD4pNiBxQoZ?=
 =?us-ascii?Q?4Ip1lgjSwcYojpvU2cTLzAftE0F79eehbIdm372shAAqakdX67GHPAAq8yTN?=
 =?us-ascii?Q?tYF98cnK6XB7FyYHZtdnonnaX1ne8yHm/4kAS5dca9IpQVDPrDAss0BGEj8E?=
 =?us-ascii?Q?+9PmfQsvTxYZM26WIuk17Uu/f8MoLJ2HVlJPvTgmtWe9FFka2GpEg5PL3GTn?=
 =?us-ascii?Q?mzEH6u1nKNmo3fOAiYJDYv+tJK+C4GJUiZ2NpjUq4gjPed8b5H/UhMJUEUVp?=
 =?us-ascii?Q?E11xdStRMrZ7tXgvnOLRziKC5w0VZXN+DZKD+Jf0i6t5vKQhhN5M8X7TlT/m?=
 =?us-ascii?Q?16WVQ8FHIQUDiNVT36XnRCZ+qfpjEWiN/gzKqfrr7z8k328sj1OLhS8Y1257?=
 =?us-ascii?Q?Nep27D1FDYrPKmMTlntejx/b2oqlne18j1lzJHB5KZpUzDyuJXa7wE+b8cJs?=
 =?us-ascii?Q?7RUbXl45HOT1tUdw0gBSVkS+sAHiQLDY1wBMEfm7UDFlPgI/vzMzm4mC1jal?=
 =?us-ascii?Q?1PZ4uybFmkgm9nv48xhOca6EZVWqbbvbsWL468NauXKcHaEJq6dReD8GqhYc?=
 =?us-ascii?Q?7F6dA8WwsJDV01s/yOJ1naWZheOwUWDGpgfPHGVvtKtIN9mAziE8y1iI6edM?=
 =?us-ascii?Q?KiNQNuLv+iDTznGTZxUoCJD0ON+0Lpc7wF4MHvJKTXsOE5itN7+sN7mvSYJi?=
 =?us-ascii?Q?WMPgccTv/Ullov+g7c8W3jhp2B2xkGmjxaLFv9O63SYdqJ9k8iSrOphyfMS2?=
 =?us-ascii?Q?UAIsh3LcocBa7TgXOWjePSZGgF7YjCjjk9XVF3HhfZX/uPBOxDdRGDpS/UZE?=
 =?us-ascii?Q?UpEKcIZS1zfOTKz/42LxeHv+m/Izt47Y+aPZ0k7n87xD98Mp+an2h58JrLcG?=
 =?us-ascii?Q?KJM+z+WXPVvoU4+d35WDeEhIWU4N11YxzpV6kySqEk2Zw04PfoxT3/f1QyI8?=
 =?us-ascii?Q?t6UQjqz7p/WxfbeLjAoNxpV55xLwI9lF7g8dYVcQpeGVAcBr5LHbSdSqyzSo?=
 =?us-ascii?Q?nXTNbr4qfQUTv3tb9gRQH5lFk7DDQjbdC4JCNFxaV+sQzK3tojgCFFC98St+?=
 =?us-ascii?Q?8vEFhzMMCHhTk8O3B473A7yq+Tl7eabIBYThmMWneyFnBjlW0KetXnnk0W5F?=
 =?us-ascii?Q?pV3sysJzp7SR6gscTtmG53LfpwmAYItkj5yuWPImHhyxEqv9eOme6u6H5WaW?=
 =?us-ascii?Q?DBE7WbLO6C65IjCyf9i34v4hw2SaDnil2K23hb30?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FX2aCCQjQ4RM/rENZGaXerdJGxhn9LAzY9bwuJmQyy7TiPSCZ6h2VvfU6X1h?=
 =?us-ascii?Q?svpIh7M7L1Cd43NNxSJ8nOFcpQvjEO9pCuGf5G6Z8+2/jr+1lT8FnCl8+fgQ?=
 =?us-ascii?Q?ajRHo/3CV9WoMnW/gr+zYvzvybngkTEky/Z9+aG5A+PaeD8S2ENwhDF6ZMM8?=
 =?us-ascii?Q?3fskYrGeRlGyy5tRH0Ng9rsCacsHPSiySrMh7hlVFYtROPBmTtHOq5HTC5XQ?=
 =?us-ascii?Q?2VfFsZZWPrTGaDLeXDulVxSHj3k/ffEGOFJ9jP4CCjBMJYkblVZbJ3WPx3qz?=
 =?us-ascii?Q?pseVxc6Mylor1qa+a12LvfOsl4T2mThFBkuGCTKFBlAEEU1VzjXQmqFBQgms?=
 =?us-ascii?Q?IuU48cnuf6HSo5D/Wm1O/Ds9hv2piCKlvmnD9y4pBOLw+luR2JD5LXPDIff8?=
 =?us-ascii?Q?T7HJmDJU4gOVoMUuLhrrrq4FF8isMk1EMlIwJtHLVuIYARZIUunqY6bZUXWf?=
 =?us-ascii?Q?udclMD4CA0cYNXonrhAzoD1auM5QcT7wpBmO4HILdiI1fqMoQdsSbIDddOBS?=
 =?us-ascii?Q?RoKdekIwrdmPqvk8QuAhsG2s1oOv9RtZgmGDF5PO3KvBcdwvjZY2kdyOovK6?=
 =?us-ascii?Q?/5UE0nyV4RW4sHOIDhqSm1n75LO7+9Fve9rE9lESRAOtZd4t43WTy+rDJsdh?=
 =?us-ascii?Q?BdTUri1Wj1PsPj2clSeZkSnKModzouA/mx7lukdiqwf3Hpfi5SEtIfAxlaI6?=
 =?us-ascii?Q?0ekt2rDbuPk9DUN4A8JlHs19T6Cmi9MicaGneCo4ZNSK37ejVeOi4O5VOIPT?=
 =?us-ascii?Q?ymfoY3IAD6Mg/LLuJUHvbwKz+SCf1l2RxakBKgojmY3g2cPdoEAzbIRvqmQn?=
 =?us-ascii?Q?B3MX2vNbDnytd8zhK4uUZttfR+PC+OdDnP4QvrcXsuLDitdVkl0eLJkBa7RZ?=
 =?us-ascii?Q?ocQOspgZ69gii6Mprx8Pby3UqNosDl9BtxtUl9F3zh5oIh9eqmZNh10kccEq?=
 =?us-ascii?Q?PE7xU/ybi9qaHGWyR/DJMlGdHyJxqPlK78iNTLw++dP60owWaJVG+pymuOn6?=
 =?us-ascii?Q?GdgM2yhCkVoNHpbbS90UuChPWKotGNUxuih2UlxVjFlEqQi8dm5agUANVNiA?=
 =?us-ascii?Q?CRrLbWdKoB9wgeL+7CwNOJ6vestwriL/HtjsdSTILcvDTJN3KTxK1X70mxUb?=
 =?us-ascii?Q?oaVe1F2sFsRnqpEzHNkItLtdkuEcwMHE0SSOMFE2wXMd6xr0zpAlkh9pbAQz?=
 =?us-ascii?Q?i/tYib4fdPl6eHABhqxNofZ1eTLb15ZIFTBbjy2ldJ01a7ZdfwuskyWA+Vb/?=
 =?us-ascii?Q?K464oDIEd+FPFWrWy8gOF9C8NidylVYtDtH2kY5RKPzJTrxXbbxBezRD3x8p?=
 =?us-ascii?Q?MR2HKehSWhzap/UxiflDQypJMAEGrM3GvAJMRqLU9UJIBpumNkfzWGJqu9Kj?=
 =?us-ascii?Q?pVBFOebPhIgtwHRGnBuo/Da6bCLJIj5LA3rChYlIxj2h3JFgf/EJP7pwoE+s?=
 =?us-ascii?Q?XP8mPy6QSRdQ8WrL/asamwLc1dABUWEJt6wy+BzBeLx76xluKvc/nkq5s7GB?=
 =?us-ascii?Q?vx+sI5kMngPYak6Omha9fFNHst7ZRG3I5O8AEzalvskltSCkXkN+Pzr7Q0u7?=
 =?us-ascii?Q?+a4exyOYYjr5INCq2AdAuaerHwN/+F2YbcawlXI+MELTs9+/JcwrwBXaDSwr?=
 =?us-ascii?Q?kMUY6fujMcRHnQjowvBlvUcArNMp3I6XMAtEMgxWSy5UcB0YedjC5/VrL9jW?=
 =?us-ascii?Q?47biiX/+69u9puMFtXh50GMLcSq31LP0AOT1WtnXkPJU6Fljp69Zetztpcmu?=
 =?us-ascii?Q?yHjmtBTbKw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8eu8oRCLjix2dpqIDCa2u9ji86PCe7MzdesDgWj8u6xm39xKyyBYPOE/ZINGDiFQQV/TtwXhFPhhevS71acvYBod1Vw4L3Fxvsoojwky2Dktobw5cJotPFCaNT95p22dwAnLqnUcrM9N+F7wlNgtVqxoPS5us0aAotaO8tqLWT+Xi4vUfDhXJF5P/EZaQ/OHoClzowvFQBYcUt6tEOJqbjAxLTUGkn4ihEx21FIKEKrsFlRmvSKWnOrVGU5F/59s7/0kYKz4h3+FhM1osbDycIkDUKie/2FzjaZgmA5/xLuvkzIUSSasH4vV/b8klnylW/QTxRTT1IIlXDETrJ8QO0owZBZGrJ7KH9kqWE25iA3jCThOCMyh/ozNZ01BdN5cCoysXAPh4jNerurCQGywbVsX26DEbswypPcrTAS6Y2RpB4m2I798f3pEdv5GlLyhvM+6JzTYtNtBs3YnwTJhPIwmEsNS2VEd9LSjWRKA822sSOdjXQ5ggnLtDueUF2pqX1focJme0y1IavcusYIz2YbFAuEWXOhCJBul9QaMbdGKI2I09o/hnn16P8VBjcpjixcqvuqEQFJhhDqVlWDOtlYVj3Snwh3lC7qaR8cNct0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf2357d9-6bb8-43ae-986c-08de65a331a8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 17:14:32.1642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uMxngzRPRzhOxCq39L3t8V+6UqvslqPLZQn1uRVLqsywgCz3KJRfL1OuZ/2oHK+HQeKj/yMThzndna900GThEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602060126
X-Authority-Analysis: v=2.4 cv=Db0aa/tW c=1 sm=1 tr=0 ts=6986217e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=fFAbNiGV370v5-WorDQA:9 cc=ntf awl=host:13644
X-Proofpoint-ORIG-GUID: egRlGZFbpErig3E8lsM2vzikG1cWR_Ya
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDEyNSBTYWx0ZWRfX+270mhNLggjX
 3N4+5BLC8VFfkDLQp4wcRZGWP+WEYFp0qYsbJdXaEOWFkOXlwpB7v7k54c3RIbzKqROdcciWCbI
 UcbzPps13He4luvavS+Lqiv+Y9lb6pSzTXpRePQtsN2YA13GguuBAwgwPkgf9VIHCnm2qZPAie4
 AyHCefQMc8uLnXMV2FNyXF90vBSNtYvkHpit6K+fkaI75/9GhMthot3SvH8g5k8PvbAhBj5Ftsd
 kzFYsUwnSO21SO2N8XOC8s5ogzlfthgWEk9Us55ZAp5LYpfPEBO5DHXqcGElyx5dK7JXqmoipNn
 d7wu7sMjKgetwc3C/ubRBGC5Mx4M9W/wdCEsQ6L25e9E36obmnHGsIedKIRcbbVpRJ9O7eWrGa+
 OOfk0V7LmxxkwNhksacy+qxsnjq53xIjKfWEnBt1cakb8LdVyCjc5feDKXCcu2Cx1g7MnC4ivTl
 m3YGedEf/XPfSFaTgaXEIMXH5qHkMlhVvuCnrjZ8=
X-Proofpoint-GUID: egRlGZFbpErig3E8lsM2vzikG1cWR_Ya
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 834361C000F
X-Stat-Signature: 7uggjyedhswxxzkjjeo5fmbahcwdcxmr
X-Rspam-User: 
X-HE-Tag: 1770398083-230378
X-HE-Meta: U2FsdGVkX1/L3LwW8ZfD37h2EJZMIBGbfLTO3xFBTzp5EY8B39iiFIMYrDpffJZ4l6TgOQhlOYfczsQbDiVr+UcQGJqsdsOGovlCcMbZUKKJbQIuyzuHvUkcVeoDxaJAaRWZ0/SMmWvSiklGeHmwRGxsgB3wq2U4v8Lu5Z8/syiustAGiHaW5okVG5++JHJnEGOdC51FX4iDwnRi6VC34oQSkgRRiGwLMI/bQiBwwGcEDw5bB+nYf0FAf8/Q0grfTz72enQP/kNUmR1+LPapsaf2ZqI5L+35yM0R4SRGveVrW1WZCQcW+rChhRYqYzWyZ8QIEnW5LGN23iIxknglhuyF9/poLit5nYkoX3hpEyKWtzhvy03eRgQJ8E49Ou9T3jMP4AFoUrHzng374m22QDUFNjLG6TAiQ2sSwgTXopvvlRuq4QEjefoXJ0uZuF+V6rlRenBg18WKH3Yy3chko8YxFQ0497IREokGqD+i5BuIRdXjE1Xl44YhwwggPUBQxDRrf6H4OxICxQaOCdg6dSx1jgbaceeQMDBzLNeaBZ4U2IlYkfNLZg5LRIgPoBUAre/2GIAg8n+9Q/YoOqfXHMDuJR8qm+KDPY3FeqzZctPdTiSziKYwzWj7CKP1oeB1HXs5lzSMn7E3dz/gn4bTCP1xLOXLWyca9jq5CbgcJ+xNZ+M5R9Zqz9WjByRJlObDGqusxRgqFjyzzfVDOqXpwvKtPUnZBYpCN8GSbMlIKrzn7Sa68XB0wWkujs5DhVgVJShxKBVQVbZB4OZwP/5xungJ30FFw5StvMe5yl3KmSfG2NELz7XRJk+da+FgJMo8R00HdloVxU7SvVH+KWbUJRQQG/p1J80rxEDeiIvqp6hEluSGET30LYVtG9bfBw/EuwioTclm5I7KVHnVjwnY/njT4UZebvrsWLVB0oDMegPUBu4luZVBBorGEAqT6iuTSli6NG9IcbWB9UhRu4Q
 liVGf7w0
 B+bPJ2JNxdyK17SkswZMutCcXHOZQSMwfEMU7tgS04oO9YAmSuV62tgnLfK/Wu7mZQTvFhZX8Et2+GIIphSC+pFyooyz8aXNvvLF6YdEqdBxnspY+dzb7k1ihEMOXQ0dLksHZ6p4qQqX7uzRr6B6DUeY7iCPp6uRLErvKrRfQoH0TXL6WwO0a0kbsT0k+TdQfZ5sgZxORXRGqopDpHVFw646PN6kK4O8fLzuU1xCTDyxo4zEGWgRVDYkM/PUzmfmSBQeEnUUuU2qn0Cpi6OnpniMh3QE8v9iWUA0iNfNFVBP833pzTCCeehUO2cPdRVa9A37OiIyErIH+gnVO+M3/G0NleTlqebYU18tk1eNcPl4a6ZHWrI0lBs89j5RkKcy9ohVb4N490VoOD+l4fPSzsum5FehpPCr6nhUiJFJ3gWUU8N4F30TJQZhIfNfdGs9f0T8xgqi5BYhrZxVkfuHPHGgMGs5HPjDXZRVSZWSyvFCdl55YeR4sn82UNf4Rftz8QHXjMdzAYQud7KcfiLNTv8MzhR1j+CAD0kP4l3hUyTwibNvP8jEBiqdMgbtEAFP/tWYEhgAKS2ym6I6611jiZJy2EefljheLzi/6jlqddmBJt7rCmA9E9yr/ADbU3gmO4KYmyXSiHR10T8eWSepiOVKKac5fk45QXrohtmJBl75GJSYKAecubv8EWstCSrEODlzYDcUBOIHgGkKi9CT/EUwtJfgNKALXaa9jz4HTnfLRmsdA3FBOT4oIVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_SLAB_FREELIST_RANDOM is enabled and get_random_u32()
is called in an NMI context, lockdep complains because it acquires
a local_lock:

  ================================
  WARNING: inconsistent lock state
  6.19.0-rc5-slab-for-next+ #325 Tainted: G                 N
  --------------------------------
  inconsistent {INITIAL USE} -> {IN-NMI} usage.
  kunit_try_catch/8312 [HC2[2]:SC0[0]:HE0:SE1] takes:
  ffff88a02ec49cc0 (batched_entropy_u32.lock){-.-.}-{3:3}, at: get_random_u32+0x7f/0x2e0
  {INITIAL USE} state was registered at:
    lock_acquire+0xd9/0x2f0
    get_random_u32+0x93/0x2e0
    __get_random_u32_below+0x17/0x70
    cache_random_seq_create+0x121/0x1c0
    init_cache_random_seq+0x5d/0x110
    do_kmem_cache_create+0x1e0/0xa30
    __kmem_cache_create_args+0x4ec/0x830
    create_kmalloc_caches+0xe6/0x130
    kmem_cache_init+0x1b1/0x660
    mm_core_init+0x1d8/0x4b0
    start_kernel+0x620/0xcd0
    x86_64_start_reservations+0x18/0x30
    x86_64_start_kernel+0xf3/0x140
    common_startup_64+0x13e/0x148
  irq event stamp: 76
  hardirqs last  enabled at (75): [<ffffffff8298b77a>] exc_nmi+0x11a/0x240
  hardirqs last disabled at (76): [<ffffffff8298b991>] sysvec_irq_work+0x11/0x110
  softirqs last  enabled at (0): [<ffffffff813b2dda>] copy_process+0xc7a/0x2350
  softirqs last disabled at (0): [<0000000000000000>] 0x0

  other info that might help us debug this:
   Possible unsafe locking scenario:

         CPU0
         ----
    lock(batched_entropy_u32.lock);
    <Interrupt>
      lock(batched_entropy_u32.lock);

   *** DEADLOCK ***

Fix this by using pseudo-random number generator if !allow_spin.
This means kmalloc_nolock() users won't get truly random numbers,
but there is not much we can do about it.

Note that an NMI handler might interrupt prandom_u32_state() and
change the random state, but that's safe.

Link: https://lore.kernel.org/all/0c33bdee-6de8-4d9f-92ca-4f72c1b6fb9f@suse.cz
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d46464654c15..4d76af84f018 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -43,6 +43,7 @@
 #include <linux/prefetch.h>
 #include <linux/memcontrol.h>
 #include <linux/random.h>
+#include <linux/prandom.h>
 #include <kunit/test.h>
 #include <kunit/test-bug.h>
 #include <linux/sort.h>
@@ -3308,8 +3309,11 @@ static void *next_freelist_entry(struct kmem_cache *s,
 	return (char *)start + idx;
 }
 
+static DEFINE_PER_CPU(struct rnd_state, slab_rnd_state);
+
 /* Shuffle the single linked freelist based on a random pre-computed sequence */
-static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
+static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
+			     bool allow_spin)
 {
 	void *start;
 	void *cur;
@@ -3320,7 +3324,19 @@ static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
 		return false;
 
 	freelist_count = oo_objects(s->oo);
-	pos = get_random_u32_below(freelist_count);
+	if (allow_spin) {
+		pos = get_random_u32_below(freelist_count);
+	} else {
+		struct rnd_state *state;
+
+		/*
+		 * kmalloc_nolock() called in an NMI context might interrupt
+		 * and change the state in the middle.
+		 */
+		state = &get_cpu_var(slab_rnd_state);
+		pos = prandom_u32_state(state) % freelist_count;
+		put_cpu_var(slab_rnd_state);
+	}
 
 	page_limit = slab->objects * s->size;
 	start = fixup_red_left(s, slab_address(slab));
@@ -3347,7 +3363,8 @@ static inline int init_cache_random_seq(struct kmem_cache *s)
 	return 0;
 }
 static inline void init_freelist_randomization(void) { }
-static inline bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
+static inline bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
+				    bool allow_spin)
 {
 	return false;
 }
@@ -3438,7 +3455,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	alloc_slab_obj_exts_early(s, slab);
 	account_slab(slab, oo_order(oo), s, flags);
 
-	shuffle = shuffle_freelist(s, slab);
+	shuffle = shuffle_freelist(s, slab, allow_spin);
 
 	if (!shuffle) {
 		start = fixup_red_left(s, start);
@@ -8337,6 +8354,9 @@ void __init kmem_cache_init_late(void)
 {
 	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
 	WARN_ON(!flushwq);
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
+	prandom_init_once(&slab_rnd_state);
+#endif
 }
 
 int do_kmem_cache_create(struct kmem_cache *s, const char *name,
-- 
2.43.0


