Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0F9DD339A0
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 17:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5366B01A3; Fri,  5 Dec 2025 12:51:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375E36B01A5; Fri,  5 Dec 2025 12:51:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216926B01A6; Fri,  5 Dec 2025 12:51:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 071E66B01A3
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:51:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3CD11332A7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:51:15 +0000 (UTC)
X-FDA: 84186158910.02.30BBA35
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 37889140015
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:51:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="l4jR6XQ/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=R6KviA9U;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764957072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Zuxle7ScA7kR9xs/i7TGuj76XFD9MsdpW6B0TIZOX/w=;
	b=B6pnVZKNYHUTwHxicTql0nOu9kd3yscZkAsaMHtBYQEYKLB7Ffn2nslwL8zHZwkTLsLY4G
	RLQCi+e2Lu7NfnzeQ55CPOmrDc8FQkaP4CdCWz7BpxOMEVdtjoNjzmH3S8GPT+M3ydGiDe
	oG/Om0aGy6aU0e51UjuTG6CmdQwBjcg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="l4jR6XQ/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=R6KviA9U;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764957072; a=rsa-sha256;
	cv=pass;
	b=sCyxA9FtsQ0cP9RO3p5ua/qs5xzSLqmT/Z9JoaXXdxqC8UKN5pa5inIZ/4Sf1iJ/vN7Lu3
	8AmXcN661l1tXkzcorxvLMZT70UATl2beNBsKWwBbAlH+WJE8imeyW5XxB1E/Dvw6pV/XT
	ekIqCBMDZwO8HOrkP+sghAl+Fya3BfA=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B5HelCN097217;
	Fri, 5 Dec 2025 17:51:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Zuxle7ScA7kR9xs/
	i7TGuj76XFD9MsdpW6B0TIZOX/w=; b=l4jR6XQ/mdwcRYNPnxPC+Y16So/j95cr
	AJT8/Xlq58sAFyLZCws4JuOyrTndZnRdBYlOILrCP2ztHOmdPu25+jX3QMwqfs4P
	z8CGIH4RxNnB754dWTOZHr5KdcUbo/ryE9mkfK0+EalDYB/9Iy7Z9tRO4GpvUJd8
	A9xa/OXI6e/TMgpiDNbRvUJ6JRbp2TgaW8l0Ft7wO9YCGOw6NHw/3JABrboAvlmZ
	o1YCLIk4cQtqKKH83IS9VnQBp1GzG9u3NsnX5iZRGLZ+zj0tl3EEgm4T6txqX03k
	yfCvaJDo16YexhaAOPzs4x11AhqZ3Li7NqCCE0sUYFSGT0fXlkJNxQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4av40ng0qn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Dec 2025 17:51:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B5HNORY040123;
	Fri, 5 Dec 2025 17:51:06 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013046.outbound.protection.outlook.com [40.107.201.46])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aus9f6jgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Dec 2025 17:51:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Db5FU+Q19nobIG12K79Vory9tiBA5iLgV2HPSo2atiVS58B52LXtwyIkOd+FO33X4RvuH4T0KNp4FWqqHONaomTq3L08AzRqfuJ23c2s/c06xf9NtGctcXXYFwe0A/GIGgfb3zhGxh80u6p1K+1HinTUi5yOOyJseFh8JxYhcnMcI1gZwa93bp3BAxjYo+wsR1KS5vZnh018PuR7km0aVMMv3rlL6RnYedF8kdVxKUH7YV6jFIfyuY6unXrrmDns8l+9jqAdcyi05rwadGZbM8Uv/cCHt/fEDbdc3OTVX68L/Djs7lUZX6ancSI/92iQpBgeohwrmkctFLUOVPKwMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zuxle7ScA7kR9xs/i7TGuj76XFD9MsdpW6B0TIZOX/w=;
 b=jo/zCgsdcnF3egDSCQtkMjHs9tzPvakUwlbxG2wPsrN8+d7Zvkonu8RW6Ej0NV9fUm5Y6/XA7zhj+XLgzQBey2jDWMZMbzFKguMUChASqKKtsclCHZRFR1JSDRFI4tUDPyPjdE2/soK41KY5sRLhZeeyN/otq0Ev2dNY4DT1gAy2F9IE5iDW1oZFRDYVBtXRg1w7A7QdeXQYr7F8vBFHi8s5nq61ZA38Lxj73SRZsKyjuogckwyQIKKvdEutEV94HyDEIw9ipLAXEyl7xIpZFfEHQtHHLf6SfO0VrxXCd5jzMxp+tKFRMfeYsMMY3IoifGD3Svyco1jXUVWIq7PYnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zuxle7ScA7kR9xs/i7TGuj76XFD9MsdpW6B0TIZOX/w=;
 b=R6KviA9UK/WXXpxNekQF/qKsLYgtjQlF+9PpTbEjOVKISJzDX2MiwoNA0OcUEGMoMs6iWxROGFFqMPUmZikFMdTZAEqwtwcV62CC0mI537451sQRxPCt5r966UYQSqATQCzs2/lfGeKA7yhgdEaQpJ1ymyqo4n5Cr9GEjSxyWYE=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS4PPFD91C619EF.namprd10.prod.outlook.com (2603:10b6:f:fc00::d4e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Fri, 5 Dec
 2025 17:51:03 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9388.003; Fri, 5 Dec 2025
 17:51:03 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        oliver.sang@intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Date: Fri,  5 Dec 2025 17:50:37 +0000
Message-ID: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0216.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::23) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS4PPFD91C619EF:EE_
X-MS-Office365-Filtering-Correlation-Id: 49f289a4-c052-4631-f6d5-08de3426dbe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|10070799003|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YYshxYNLasG2BN8m+g38/PmGgBD2BHm1Zrm7g7gi33Ilf82w+BuFUPw5D1+0?=
 =?us-ascii?Q?ghB1eHlz6MVs3yVPJS/lFGvav9ytLQvUMdDHvT+hNlp2mO2e6jCQ/ctGTsxi?=
 =?us-ascii?Q?rv9bIuQxISdQHydbVFkAvzFzS5tFp7lrD41ByNf9viSeteiL14ttGeN8edid?=
 =?us-ascii?Q?XwQ/0LPTHqRra0HkD6phP7YzuC0+DVIbAj1ym0nhL07HA4INjviNFWEllv9E?=
 =?us-ascii?Q?BXvkhDjdDVQtI+VKhqJuM33pmL8yfl+30fja6jgu2Mo10qivwzBD4CsBUCS4?=
 =?us-ascii?Q?l+BKw5f5k/wn5zdEDPictZLQoaTFd4bcgEQwJV9XUyZiJq05K1kUBaPt5yHa?=
 =?us-ascii?Q?VUeojKLpI3yymH6wwsXgxUqC1AtegxuFSw67GKgkjiBEkufPSsZDHwj/fbV6?=
 =?us-ascii?Q?m9FQsEV3smCSZ5tUra/3XUl69dzq7lnfUIUdGDAKaZSntjhSixZ9n8P92NJS?=
 =?us-ascii?Q?f3pBUAwqyLaTRegTeS1rtsCyskIGO8E9KGIiKoQBBpSQgUJHuTL2yZc3vXv1?=
 =?us-ascii?Q?xXtHo/AehIO/BSCBCHbtGLxq9OmmMTl6xXoOpAt0/Pimt/ZvB1TjD+4uVKU2?=
 =?us-ascii?Q?AM9pnBMhlWJTKwzgwZKzhnTMZqXxGgYAtaK4TYDqe7KHVoGq+cFOBd2oHHQu?=
 =?us-ascii?Q?9TYMOkiu43GoIjKl6piEWZQ8EboBnmFD5ysqp9fzSoKaILJrXMrY+dVeb1CH?=
 =?us-ascii?Q?Z5MTRebWVX440NEcup23moLEVLcMxHKr80pPYffbAWNK8RrPHWmKZPcjKc1O?=
 =?us-ascii?Q?RsyWcr78rZPiWR8gE74cVbHwx4t4hd/XAV8QBt7hxYE0X3lPtQwim6DklD5I?=
 =?us-ascii?Q?ia6w2RkLqKqbej/SCicQydH8mMJHpjW4CRzcze52mohdjSXQ+ZiNl5lEn5N0?=
 =?us-ascii?Q?AJefMV+ytji+BM3e42JhsNdZ1ELJa9ERDwQVIDWRMp18jsqXWQrECSrtbSty?=
 =?us-ascii?Q?N7txN3CXWQREYrvWJx/chcxZuYvyudZdFwKG+KnVTxdTLTObqiVnb2UIg30r?=
 =?us-ascii?Q?v7LuqVuSnIp+1gTUdOhTeHjP42KoAC3jIo0fpT8cJX/G4nUCnDTDpSXcVM50?=
 =?us-ascii?Q?vmWNHeUb7jHdDOCkgFOkpwn61kGIGMo2uutVRcDXRJ8eCoKCzyXe5MFoDLjH?=
 =?us-ascii?Q?VThWvdqC5ynzZBPrOzo4vafQGakTfigg3DUha1LSo3n4F4uSdwI+dJ9S8yxk?=
 =?us-ascii?Q?3YRpfsoCYkBxKzRFZwkpuZOi43HRzqm3SfUYP1nlmsaakycHtQQwwFewfLn+?=
 =?us-ascii?Q?vPNmH+u+vAMPgywzWBgZ0YbEJM1E1CwWFNbFWwaZQ/SiiUcRR6tehXgipzdv?=
 =?us-ascii?Q?JFc8khcLkLkQrlaqKHV9t1VOBU5Ux8Nh0grR2Nr25CCR9eFeBUrYUc4eZ7Ln?=
 =?us-ascii?Q?I2GORmRJrcU3w52f2NNcwP7UHFoqCS6XI6JMujGBVDpvAxgZoodw4A4S4BV2?=
 =?us-ascii?Q?GCfNxXtRld3CarMwBUmfxvoDrLC6i3+d87IfYkFAhSaSE5q/iVX1wg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0G0llXEO0G6D7e+QbOPQvn2Pmenan77fyXJEb5ZuhhFT8H8z+pumFfsQrNMr?=
 =?us-ascii?Q?EP5kbcS0e0ExJJDmv81XeNU65Hjw9z8mhPhgwMweoX0RYsIY0nflqVodr1hF?=
 =?us-ascii?Q?gtgv3/64gOV+Mnqn97OPo3KVy4kRmDy7W6XedyvkkLaFWZyu44pv1sWJKhgC?=
 =?us-ascii?Q?AZZmxN5rYBZ5KUdPLhyosMpeep7NwkIrDe17/gxYFEGrHjlKn2e4Bv8Rw1JZ?=
 =?us-ascii?Q?Oskkh3EGvWg4K87DDKBDlK6hKRPw8xg2ZvBR9RzGAcU+yKEkBCU+KvtVeaxj?=
 =?us-ascii?Q?Xy6BhDkixQYvvt18bmZd4vffkPrtD/8ikmGSi43WIZGXIPq7Mju1mB5Lr6Zk?=
 =?us-ascii?Q?6Bfc8a6nhDxWj9Tl+gGpqWE4NKckjyprOn/47T/xiukRLDBIn1QdfJ0Rz9+w?=
 =?us-ascii?Q?w/9rfR1CmvzXSyombU4QdPRZ6Hm8aFibYOZi2OpHccwuH8YxfQTef23P/HGK?=
 =?us-ascii?Q?ZrJMmtTqVKWwUKr+Q0tu5EMPoJ+L6ZBW5TaJLwq4tMkVHaZ4izbD/yBMkfI0?=
 =?us-ascii?Q?6bhj9wfgyjAalLO81sH63Fx9xmn8s+E3UHL7afHm1emDofgKei9eX9V6V2lF?=
 =?us-ascii?Q?Ci3FuliUFNficEVaedMbTao5LTcPiZUjeYAE1EXxUkyYv6KdIukoun+88ZVs?=
 =?us-ascii?Q?Hv/zp0OLa2OfO8p8zh4Y4GYdYvEPLT566rDZW3OtyeFH5CdAOGGgPakKGSio?=
 =?us-ascii?Q?T5I997FgIpn5wFWSyLCHu6KIHxBNfpmMNKT/R3Xi5eDtG49z5ISjkEgPhdnL?=
 =?us-ascii?Q?W+ZUdNJFICrQ8ISfqfKrZsXOZySL4jIqiwqKm3/RtLpAj5d5UusFMHPyVixa?=
 =?us-ascii?Q?B/nNWFb6yy8Jgvl5XQ7Dri+klrsuS6Al83qKRjiLHr8BML6W/NdRVfFoTB81?=
 =?us-ascii?Q?gTKKGMUw6Y82Hdut34wYMxSHYwBXrHuH+JvFzaAoWLUY0Lx9vHxOfPZ30NkJ?=
 =?us-ascii?Q?/tTQoM6oVBfut0t/h0/Z4wYZ/Rq6bFGqjXQ5v6CIpG0S4xVc7VwiiYQXF/ig?=
 =?us-ascii?Q?aLx6tYiOGINhz/IAO5RsIv8OUNZUA2AcpWOIKrr627zVTJJghR8ImhKzZRTI?=
 =?us-ascii?Q?fJDGa9z17U7T/j+jq1DoxnNPEIzLhQZ34926hcTgltvtn9rrFK6AMzjWqCxK?=
 =?us-ascii?Q?0ayxBGLRRh/RjPjoGDhvmqk7E9sZZ3f3hXt26pzT/0NHWUuI+clPsaFicyqA?=
 =?us-ascii?Q?K4TTbFrbS+h0+RoQ73TitBMTAZ0n5hQrY9cilmj9l70uEMvL9YveAtlYVqxg?=
 =?us-ascii?Q?LixvPvTxurEDNmIIFu4ELNozWa4gPeJ+pt+oUOiLFq6MjeOhHchVMOikgPZf?=
 =?us-ascii?Q?DCdaSdKv8M0ABsrY3hz82KeBkf0rWxN45kJupF5VzcEOvM2v8YNcz0+1F60t?=
 =?us-ascii?Q?eP5nKQxZGiw2ylbM6A8ALnd0Ayt/fcRnTy+NWT1gzhX2ntvb2mpIIR8U/hAD?=
 =?us-ascii?Q?E/n06iZVLZ3uq7qND+4G+8nyo+pqf93Xoov2igq3W06MsppTttdvB2jxT1Ww?=
 =?us-ascii?Q?GYBqU2lgm6/AnAmSlHQWz9CGXdI924Vcv6XMQ8k5VFLncZ0y0KOXh2A5VQpL?=
 =?us-ascii?Q?afHdx+8dvpZ+CVOQ7eEWUZIzQbJPmQ17YxIckTDAYsQ1GP4A9y59NJlFWRGE?=
 =?us-ascii?Q?P3e+OjByAYHRMyg7CYPaPITkInBUVOnepcg3xBhJCTjz9D1tKFwNOkHEUsVG?=
 =?us-ascii?Q?w97bMA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WUbUQrJcqXhiWb2DitkKhRAWiOLI6lYUkhuCc18F+d/c6BEnuLBUS3Ndz0/+xmE0c2OblXbBySG+4DTjoeEgY79pxwTvEjT2MgDRLnEMSr8E5nIX7Xug9XGDwvMHZNEaDfGNRM4GJ/hETJKKUqbIksg/q5foYgnTTLoqdzd9VxLdfw8vjfsINYRG6foUvCk7003mFTNnIXldWIoknRoV/ukUYo+hN0mzRQkFrv7piI+vdY3pHkIdITtNw6ZYwMTzmSNOxVkocKGS8/oF12NjeGcmbi442MOTcDNFbZOCycQaKKVbiNnoZA9+I/VOJQpB0oshr210E/R4K5RxuGKcVOywcI1K42f9+P+OClWQk3TANz59XrmjPJhYjUj3zZ0vuGjC/5wlhGmEG58MKkHL5brbRBLXM/lsWSvqNKl2HTih5POP+VbUL+K2mrzLvQMBUBbLTkp+EK52ywq4PzNHx/X+ZMjTr4syt/VZJoi9OsdU99+xaQoK9+Uq+RG1P5mCWlN7wYoxyelM6S3lHBG4iXug3OaOtNnmKXQxcRZrQSG/Nu9vjUq169S5ML+AM/1/OPm/kFnQPkOSwsQrw0O3+zeYjgfsAsPSzl+UEHZTlnE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f289a4-c052-4631-f6d5-08de3426dbe8
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 17:51:03.6763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g9gI36ocXYBdNpO9FmoC3/Lfkwlkp9XTMikB20Q4pKfVQRvZPa1BzJ9CxHTfWtwr5hlgrTryWhX6FJq3SjwUIRzXru8yEDYF0xAZFIA6yjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFD91C619EF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-05_06,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512050131
X-Proofpoint-ORIG-GUID: HGKPGQBE3zZWfiNKUWDGXjX53SrZE8lE
X-Authority-Analysis: v=2.4 cv=Jt/8bc4C c=1 sm=1 tr=0 ts=69331b8c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=yPCof4ZbAAAA:8 a=Xun8_h3tWs6aLwdhPcEA:9 cc=ntf awl=host:13642
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA1MDEzMiBTYWx0ZWRfXzU50sKuuicK2
 bycZ43s5aOJ1Ko1p2GmRzBjlYhyenMP4lVb2K5EaBqokOHaSarXRaWEfgVcm1fIT+mnluurvuNj
 o3/cLVGR204osTgnjGaowtav3VFoTkK7A5yVwKYQqfR1kocnoH2+MNarG1XB9hek4AS+ZrejB8E
 9sTf9QJqGjwzb8ZXhvJeKtUjaMmVV3a+ofehjIRaNRs2R/RHF+vp563IOibuBRFwD7u4R0oCSum
 KnXpERy+hnrlcf8oisLAlHekaOZGZAB2waQz4/VcavPJ4GsSdMQUMB21Xio9uv8dwSc9x1aH27Y
 EnKTASdRlHqMqihDmWCSo8/kg8fgs2f6U5WgOxXODIGi0fBsJtpPYKEfzriYXB8h04uDlABhRLz
 OSIG8Kfegqil64gdAQwGRCwdy1/drHV7SrhHnc0dFDGvjWgNWuo=
X-Proofpoint-GUID: HGKPGQBE3zZWfiNKUWDGXjX53SrZE8lE
X-Rspam-User: 
X-Stat-Signature: jkk6941dh8xwmr8h5knifnsa4cqrhrt3
X-Rspamd-Queue-Id: 37889140015
X-Rspamd-Server: rspam06
X-HE-Tag: 1764957072-463775
X-HE-Meta: U2FsdGVkX18M4AFZQMZ/On7H+29nwzJlZE2FYn86EiLJZ1xncfdDCwU7XO34KvFgg/FiQb+wYt6m7lLDrDNQzRQfaUBxPXQlFxLLMteOTXBxoZtwS1wkzvwFhTGlXX8yNS11rCPN0DRrvCN4bDfh0+3AqGDMg8P795iQZyK3prKJfJ63ZrCOXoc742FdcyA6dY0G0UxrJGf7ILk13CnAdqgxvbJ+yMpPQz7OBOqJ+yy35L7Cy/c8uLr/Zdmq4l29pkhQ0LXtAygsGdPdcEUeR7uvKaBfpYKDODcAFPtRE8ERALKKpEq7RSeterX3i+/M+9Qz4rhmbE9W1AvJ/4uwlBKIom789/xIPq6WakJzmVTKglTap7cPnQ2gA5OaUmR1M+6lw66714zTcGEbafcJBo54ahMKu/zojD12fHnk8ZedM/8kpikxrLAIFHJJfyxYy9M60Ekuk9sB4QkPIa9oP3vbAE4dpoE5fZpqKrSY3JzGx9U4Imnlez+0eL1/bnHv4fR1UpQX6prHzwkLfFa8egRKhUOIS6HGLv0Wj/qBXOXG5tvKSP7PSIse0qTeP9SoiQ1wC0pHUvKTYhXSDM5WVA0pAhxf6QulsfdosWFPmoB5rJsXUtvMFwaIg3eCR8BNEuBkguAzCMoqa/ysFMNzan7l43uAOlwp8SIeGHKNyHTN9qbt35acZGqn6bzwuhBE5904qtg45Y2C8JcC7EoOWKBrVQIRZ3EnAZ/CbfWtoU/9D1R+jhQ7kp4JAUGi90nU1Zn7oqGqPK3A5H4/jxx+Fb9uGPGDPrqLXhTkHlUzcstcDEGSROVNpbb6n+GFD9o2ps+bUOF/c0ZgEJN3BfQzngcyh3zBwYg4Q3vSAe+uHptDPGtfabKsHZGVePfOVExA8+Ihdc9SfGFK71EeGyq4xhRKM6AjetfrSaxHBb6EiV9gEWxzHD1oESqcvlH8cDOfk8uwAeAz52HPEQnQMrf
 bLa54GXv
 wvdwUgceuSv3AaTM3tFpgFrjET+jLoz3q1dFAhgU10BnORKCxJtNIhiUO7uKb1Txd5inysUp+TjcSdB1HGx5zhVCdNEqnvFhhqrp7B0Dk1sITvYpcBH70p0dUC2bO4M2Edu4GAPZAQUP2WdxqvyxNWQe9PKlzxtejLx3wwpwne8afj4FirlTwTE2lzfecHDoKLUzK4tv6Iv/85hLAfO8IoNFVeDRNBjrNCyc8NrNKhKpf9jSqiBmjNTw3ZLnwo9t9IpkEw3aDYWEX/qoHiehTblQlzx9p0/MmZz13MWupN8evfEc7iPbPMe2Sv5CkvW/Wu+bOTDpYbN2A8fkApq3uQs7gynvaPw0Wa+LwBmGlwIaZNzGp1eecRAIO7hJlHUq3ZP69mb2u6LDEApbQWOaBz/5Ozd00EcyN6y7t0Yu8iHHwa7q1+hJdh4rns8oEm9sAYiUYXE4iqGn9y9A5mtYGqVh4IEgAo/33FNtAi4pomkRZUjVwkQyiXWUecN88+DKzgcPJTzOhXpo6Kbl/cJdcYI5PPew5MixpV/DlcYzoHCXsNYYxkIuCLH8xy3jdkp8qpGL6sbCqWz2eLqdVn2CUC71GiXR0XKqBzx+rAYZz1N0kIVLSqAHIO89BMRfYwYFd8qx1JoPA/ctM/s8ILKLUfnAzF9dLhquFxs9UjZnMTYe2xWLAaMHJO6IbDV8l7YLXgpRwNLkTwkCwuJ/4EQwiof6/4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
how VMA flags are declared, utilising an enum of VMA bit values and
ifdef-fery VM_xxx flag declarations via macro.

As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
the newly introduced VMA bit numbers.

However, use of this macro results in apparently unfortunate macro
expansion and resulted in a performance degradation.This appears to be due
to the (__force int), which is required for the sparse typechecking to
work.

Avoid macro expansion issues by simply using 1UL << bitnum.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202512041634.150c7e4f-lkp@intel.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---

Andrew - note I've referenced the linux-next commit number above, could you
replace with the upstream commit hash once your PR is taken? Thanks!

 include/linux/mm.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a2f38fb68840..c4438b30c140 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -395,7 +395,8 @@ enum {
 #undef DECLARE_VMA_BIT
 #undef DECLARE_VMA_BIT_ALIAS

-#define INIT_VM_FLAG(name) BIT((__force int) VMA_ ## name ## _BIT)
+#define INIT_VM_FLAG(name) (1UL << (__force int)(VMA_ ## name ## _BIT))
+
 #define VM_READ		INIT_VM_FLAG(READ)
 #define VM_WRITE	INIT_VM_FLAG(WRITE)
 #define VM_EXEC		INIT_VM_FLAG(EXEC)
--
2.52.0

