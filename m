Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7730E81BA9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 12:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC21F6B0005; Mon,  9 Feb 2026 07:10:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45476B0088; Mon,  9 Feb 2026 07:10:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD2526B0089; Mon,  9 Feb 2026 07:10:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA4D96B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 07:10:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 523CB1B34D3
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:10:52 +0000 (UTC)
X-FDA: 84424801944.16.D3B26F4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id E5110100017
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:10:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Vozz/1b8";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ekUZ8m0d;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770639049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=P83bfT40LobozYAd1ko/FTe0LJPTw/OuXzjDm6aNVBw=;
	b=YDoo+O2bV/EmHXg/4/gA6R2D94jZAYOT/lvco0xfOXzzwgGhERRwZcyLzMnl5GbM8/PI+b
	UJ4UoM+UK3gQbLwXX159M7zJCOkKCidmvrIRwbHHM4aoo5HEeiaaznmrUzXF+HhPpIX7O0
	uimGzH6d/Cfe24bxHe3kEvgGliKZKcM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Vozz/1b8";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ekUZ8m0d;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770639049; a=rsa-sha256;
	cv=pass;
	b=rbCd5wwnFBAfGxKJuHIRc0ynQm7loq6I20vxYw0YnkrHVjnSM90oipom1nj22KcgwQJuIc
	U9qEUPD+2Nf8ixwilp+tbJ4faJbdKFVOujxC7KuYAbJUQu+RcXYZ3XIkyJldHEdKCMSdxd
	HEhME6ss1zxC2JET2mIv1cJqRCXL5w8=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619BvN0h1004597;
	Mon, 9 Feb 2026 12:10:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=P83bfT40LobozYAd
	1ko/FTe0LJPTw/OuXzjDm6aNVBw=; b=Vozz/1b8QAC5sYKvd+WWhqlZxSEW68+D
	rmXDlUhA7ctTqrOopW8VzlGo84JWTE3wUHyczn9Du63RCV0rae9SrwDATUIpy7BX
	Lh36jF1lnLNB+TJDVEWExLlJe3Oss+yLgSVoW/zIR0DMWb4amu0aCpRtzdNDl1dN
	48W9pyZ+j3ZUebguL3tsxsnXZ5aS7EUmLEOEnsNZufHMNKpgklQcg5ulXQeX7jku
	UzVg0dm3Lxq5L95nSExqzVNdWUWnY+V5MAqz5FknnY5+z6cBPRuNbkBiwFidP4E8
	Qp1aMieNJKwqC8LUYHgML6nrjbQlGNJgERxbHABNp/QVqOzjrQjwiA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xes1ur7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 12:10:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 619AYFqk040537;
	Mon, 9 Feb 2026 12:10:33 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010068.outbound.protection.outlook.com [52.101.61.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uujxgxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 12:10:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cDWuX1KeU/eTwRT0EZwfO3mTPcqD1UutrQMAmZXo/pnVtzf++acif6TeUfw7BjryzgAJ1C9ax1UX02cJb6SlhOqTMIYusxq76v8qks5XiW5oRB4qptwTYmDPLtCuRi+GM/8bDmDVEcsb0eJ9xTK50IJMV1ZsDJNQkv1Ml0SItvbZDml0RUZGW/yMHpBxhTiYQ3ZaLcX5d4jxOfAPFx8j2W11xCFNLzKxmZNrRf2V1TlOP1AIzJLTNoOJfDc/qNwivS2Rj/h4AB3rXwje35jsIbjSWZ2oUp1VP/aaH7f26GqPA7QOCcYijcO1h/22AEg8QJ88ACjJc97zzXSY/N9WmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P83bfT40LobozYAd1ko/FTe0LJPTw/OuXzjDm6aNVBw=;
 b=ku284eSIX/HspceEufRkdIKqweWJZoRcLayG9adHVTbqFOgvLW2u0KUXw06/JK/ftKHg5sfkUhrozdKU2IO9ibdXvs5Xl/ToH+opu/S5/tfK00NBbBgmLc0gbpTgrcosA/FaIjWLJMiTkPSUCGfcWk5+D61y/NK/3ofIJLOtS3f/SIPbR6ebYUO8VMcS1ajzd3GKPXTJwX2vROccRbXN2XykYtCggRGyFZtBR2pU5Habna/2VGwf7KLncmT46xcThopOwTl1WlMAs6DYghzdWkrQ7Cc2E65Mj6cffq1d1gF7PrXEUmmiXz947BKaCPYkXTtXY+ojdRymCTKapF/DnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P83bfT40LobozYAd1ko/FTe0LJPTw/OuXzjDm6aNVBw=;
 b=ekUZ8m0d4XOE0Ul4NSLTMvNvJZi9ouNhH/euyjL075VCsbxW9mPakzNSwe5qW+1cNYBzXbilH8mb9l6YcrMNQ2WhIqa2WC8+plcHSP9g6EgHUKvIuaBaBc2Jy4XUNo0F+7+X/K42mLg/+3ukGSuQ2A3sowMHBJfW2lBKbJH5vFg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS4PPF376CF97B3.namprd10.prod.outlook.com (2603:10b6:f:fc00::d13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Mon, 9 Feb
 2026 12:10:30 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 12:10:30 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH 0/2] mm/slab: support kmalloc_nolock() -> kfree[_rcu]()
Date: Mon,  9 Feb 2026 21:10:11 +0900
Message-ID: <20260209121013.50475-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2PR03CA0016.apcprd03.prod.outlook.com
 (2603:1096:100:55::28) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS4PPF376CF97B3:EE_
X-MS-Office365-Filtering-Correlation-Id: 71aa1332-4584-4764-898e-08de67d437ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EQ0o2XXbjmi3JKlPRJrlVyTIyxRDvwK78HF3au3FNquTjoMznlFZ3hazyBSJ?=
 =?us-ascii?Q?rMoBFoI9Vq2L2kyB5uDnY1O2uUW5CeDIYpB6odOVaJ555N/kQU2jFPYYrORA?=
 =?us-ascii?Q?Sj6tGnPUTSmjd7xkleuucUAzUhIyIBqFcTpQzWlldK3gVVpZzRUsD609JPmj?=
 =?us-ascii?Q?3Ze1dGlTDCXgRy8Yc06zSR+dcFSK1S6q2mlsMspkzrUgJeGR+mhkKkDGvyWF?=
 =?us-ascii?Q?FW9qnnsagrVZtNfeHASW4egZTqLXGIQHNuDBqqCiIQrRN3K6X3O6Fdn6BKl7?=
 =?us-ascii?Q?rDlLLaRzD45uXSpzP6UH9f8wWoS7Sli4rUaeGEqUu3E65c40lf6eBTUpK0lC?=
 =?us-ascii?Q?He9JGT5m5NSlgHlCIWAEsXU56LSqQKMQ7afgBKnmWt8BZ8kryO+06l6fDFKI?=
 =?us-ascii?Q?AWv3BVQlGDZ/+FglxI2MKrijQd+lIfGa23TiOh3ViRSmFh0pCliJ+T7ijAER?=
 =?us-ascii?Q?mcUKQy+OZpizXNqiQBScNU3I+43jojtwopkf9GacQsC0uOddVJ+JuerI42AH?=
 =?us-ascii?Q?0vE1E+LpYjjjxXM46tFrHcE/paQ/QRQbTeOVcOQk6ofcFmoa6q3cWfVmYA0N?=
 =?us-ascii?Q?E+sFUaPDmr8UJE5ZMUXT9LF12+C9CHHUn62wnOxekcvVaIXQCDh5mJQM0IN+?=
 =?us-ascii?Q?3h/7s3fI93APMQmvBokVjqhsXVBI+W//+bXCpE6BbiZ54pXtD862iKH4Ns9Q?=
 =?us-ascii?Q?+mrYwjgFAPVipoq4eRMlO1XvvkwMcSlFSoMHJ7rCUJi+t2UZazaPwIJR06vw?=
 =?us-ascii?Q?Y53hfXRgfsndOPKzypIFBbyjIneirvWrZyZ/BnA7x0rbi2QAfZXs7PaQB+hx?=
 =?us-ascii?Q?/2L3SzBmt99XWvcCRei0yDMsy6W46H3tSpcoHV4pm58vCW0Ub20LioqDwoEd?=
 =?us-ascii?Q?Pdrmyyx/mpmvlmwOft3U3jV580gUDPG/2l5CHkQeMUvxfJTvkJG+VWiAy0QX?=
 =?us-ascii?Q?5VpAhKr//5S8IZBc7fhHkNUokpCZohhjxSa5w0XA6/sqlx5zOHhyBaXkHXzC?=
 =?us-ascii?Q?eJ/v/RI4LENBgqiMjYndm0ovytSMCucQFmyLPRCMBGGjDuQzwvyODvpsVL5K?=
 =?us-ascii?Q?ohdR7MLIB7s4BMNU83NqXhu7K7ERxR0FPSEYkNybjCv+6Bag05UAXEh4zpHa?=
 =?us-ascii?Q?9Qc3byTxAddxMeVXZKmRVcIUc6kAtiiUwJ2pjdx3v91IztZZN0I0nxkB0OWz?=
 =?us-ascii?Q?yp72vtpKO9cxgOUiV4ud3Q3+APSLQjqbVsQJWm4bq/pWe0CORAuZ0UfRRn4T?=
 =?us-ascii?Q?NjLgkH24Mz0UMKYl4fYbNGGS5peMdfzWkKTJU5HVuo16+vieIaau9zfbSCAH?=
 =?us-ascii?Q?vYWXcZsWqcuEt11B3hW9/a6qILO5yqmP/aXkBZrbUCM3r61VDqXTPDGn/Spm?=
 =?us-ascii?Q?usST/8CE0aasJ3ABP6sNYmV0IovRL7TKPqqSrZGqfeDY94C3iKsjZpF79akh?=
 =?us-ascii?Q?KBgKJBG8b9TYN+HXhZj3zpeiNDTVdQkImD5h7FMHqLOMALUePVkHiv/IiFmg?=
 =?us-ascii?Q?O8TbiAXNbTMiYcyFZU4kSPe558x/91cjpheBp8FrRppAjuHtf3gEAbaJgw4d?=
 =?us-ascii?Q?I9Q0NDJ9Cc2p7ete4t0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2h7A0r7YGLcBmXb5oeWFZ8dlomicBfEBr2tIb6qZqCBr/wVZtoxYs6iYb0AE?=
 =?us-ascii?Q?Dkp6N1JeKbyZPPCMDdS6ynsCDJGnrQZqdz5VjjNBAnsoSnBV60CKygR2PGrV?=
 =?us-ascii?Q?J+9ChBuuqS4ZrGTrcSDJg9467wjn9PyDsZfv8Pd+/wBgEfUXXNqtVcMf+5SA?=
 =?us-ascii?Q?FFqDCC7R6tBd52mzR5z+Ce9IOYfs3MRNsTWP2/amdE8x4rOyPwWStTMSn/si?=
 =?us-ascii?Q?DMaSGX/MWiWvLeMtKqw7xHVTqwfX1xxqyu8NXbbQr7BVDrDq8bJCVPEezC1O?=
 =?us-ascii?Q?Bbi649S6aeIlYcCP+jFoglkMHHjgs6tUfNJVcbgueXTCJbO9Nkgw2VPF+r5m?=
 =?us-ascii?Q?aYU6eZdQ6Dr0NZxKG/0LfF3agtx3wxGRZSzWRD0arpW3ZJHexFI3n9jAFzTQ?=
 =?us-ascii?Q?u7yUPvQzPHhnhAn96VpMFlW3deEWQWbo4yGhE4HkChh0cTZr4sYarGzxf98l?=
 =?us-ascii?Q?csBXtY8SnTevECT9eINb3mgzc+o5VGh4VhLT4K/yJM86nzShvCtPndbprz2l?=
 =?us-ascii?Q?X+CcTFzcgFNQNBfebg966s4QDY1+MGk+ItI27+fNMGXwUf+qimPwcMwm/oTd?=
 =?us-ascii?Q?Qc4gXthsvazyNTk90gXrPmAj9aQ8QdxkcbKebdRbkNXpOdWh4h/FxkGVT3cb?=
 =?us-ascii?Q?Pa3ftebUSNTEQGRICPFsB4jFUdruNODGVBqY/224Aqz8dSyyugl+46jXyX1L?=
 =?us-ascii?Q?NtKJRcaAtsODt9y9TD1q3pMoEdYm0CENKV2ZTS7XBPNEHq+3exqutOXoVBew?=
 =?us-ascii?Q?pYJsVzcNdQnIud3Sl3GbYfIfw/tuw1I73syOKXIcPyqh5/KEFo8zyZsVgKk1?=
 =?us-ascii?Q?6MYxXU5Xcw961Ly0NeQ7p+MFM9gAPj5bxpDWhMxtfABk1ZgyYqsLJXE3zn2W?=
 =?us-ascii?Q?CwgvXdpeo4Dutk6EaaxKK0FOXByZLo9msnk12uPEMQTXh3wV6WhqLv+7mHP6?=
 =?us-ascii?Q?1MiArPIFohe8CloLhitMCnrE7H4DSB0HccMGROqRvtNJRt495lCDbJscK/y5?=
 =?us-ascii?Q?rqIFfiNf0BAkl5E6d9neZYq2jQRRY3X9Uoe/oFZIBwToO3E13OhNf3X3IKvx?=
 =?us-ascii?Q?1T4hVowfeEnOAC4ltlfQanHHMhUdW4f0yuanEMYCMiR1uV2wUPWH/hbRNu3o?=
 =?us-ascii?Q?VThrhQ35hTyr+p5993qNCAQIEvkDWw8j29qhZ8g+iycd6VeG2FNjBGH+3Tb3?=
 =?us-ascii?Q?nVIU6MlOdcxJMpqgu4kqzdaht9jbLdW2/MhBiXWsX97tlywczVY28utoPeVv?=
 =?us-ascii?Q?FzKFOsb9YlP8yC4RC+gfxBkW856eK4DnBf2/QfAz3AXX0FbhO6GJpDkgVCGZ?=
 =?us-ascii?Q?7T0IIeHerYF+NrAgwckPkOhFZDvRBAgGM4xMYQ6BmReNUFIIiaSLTIdR+vFF?=
 =?us-ascii?Q?RSZ7iXx9b/42JsIV+cRFhYqg5MeEs3xs2ybrnXTxOCqaKX8Vl+/y6JTvQ3Wm?=
 =?us-ascii?Q?A5Ko29kRfxcIaRIemzEqbkk205vmWRYE7ujTDWbJ5SnjWh6yCTuD1nFnCT1B?=
 =?us-ascii?Q?EG05qx9wxy9BKTmiGs9+vwBa2Gjbk98GVrCmyzLGcE8227JrgaAa2MLnCIDr?=
 =?us-ascii?Q?QvW1jRWSaY8NEZe3MtK0gdtXt5dpcoDN8Tc3VZKZ5ns0ieATqchKPW/4Gi8p?=
 =?us-ascii?Q?ytNBkwe2jqia4siYZH4zTLJuEZQu8ZsWZwbUwcCtE9vJtpyps4fXThVxNbRE?=
 =?us-ascii?Q?Qy1tbIbMN9wAL5kTG0yGn0MDwEPUt7sgIzRhkdTi++hfC6KM5HqHH78qUqCu?=
 =?us-ascii?Q?7J5TLk3vtA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BsVo4U+Zb33V5gkvDAQHKyhP7xPRcI1siexQo0nNXrZ2Jb0iu7dN/WG5psaS+aufl2ZoBCTPGvJMCM/NWfs8JzoKZVMrezE5p4jlxUda4jK6+90j6ff8AzLIzlzd6jHIITYGdtY4yC5XLXgM2VoeAkdLyzkSl7OFErOV89xLvtwJXTIk0e489NtoboLMrvCHo6cBgudZ1508fzvnuoxUohuyWLd2prbxHGc9wuEfE93FFkHvws5Fum1Feem9VosUEd83BaO8XQFyMElX/tjmRos9bTDdr5GFhj6aPh68RKwjtq6EjkVGU0VkXfhR8FOs5gqxxLXX9K4R4dpoCX3R6MBHPJ18G1i4lxu7F9uZ6l19sui1A68qTYIptJoUlWEOumTQOnx89SvnEW2mN27EtBixJtz7L1W//KMyY3ONDKkh+U0ytzTvTl2tPtFQ7kweL88j0JlvCWvy8nuGaozNDHDVGNTg8H/nDpBJCaOpjReN5VYKmNBJLJEySi8cSFOd1OR6oxbxuT6RXFlPK/t0/F3gfKJsiEfC9TSimqEwnzuX/bQLKb4KyWHYlnPwww951PXAASX2H/dQ7IE9hy5InR0DQBY0filSFogwwbqXMd0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71aa1332-4584-4764-898e-08de67d437ca
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 12:10:30.1928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7b7lxLnzf2bQLks7TjMOGviChIZE0p2N2ssicZa9G+qwnqeq1xKhH8kpKA58FfhLMdPm8JpKtZ/Y/z9LF9ftMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF376CF97B3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_05,2026-02-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602090101
X-Authority-Analysis: v=2.4 cv=KaTfcAYD c=1 sm=1 tr=0 ts=6989ceba b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=vW6AseSyelc_Ns9OlhwA:9 cc=ntf awl=host:12104
X-Proofpoint-GUID: EDPA3doK9tbrvedq34DDLVGxhpLjaG-3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDEwMiBTYWx0ZWRfX9fwQZrndogn6
 OzVdoRb/hjRlfSnJGie+tO8SRWfXRMgysYMVBWaY36HRxRZKXyJWJh9AspdZSLsHQsl2vL0H0BR
 rE+n2eq8Gctr9ERmk+iULRdqyzFiwAk0yFZyI/wHFNx4FVEk2B9Y/psiM0V0qBhgDRnDFN6EqXa
 PQHzdULIbS9kgO87p+HGiuD/9TyJQoFwLVPPvhX0ga7mwxzixnBkdshGkNBA2xqdfCuGixiMi0/
 l7NS2Dms+ZPX14ezh5b6Gq2XYhNVdBao47rrqLO1zBtLpYWNPedxHWEXUyDrOC9djjj0SFYCEa2
 b42wnrqaOHNBZlr6MFwrmCnYChDudIOCwngg71phpNP29gVuhxs9y5oBwXOE0vD5cIWlL33Lk5K
 pmRg+qfryKUW00NmpY+kQG6obSOU9aQRGFs7t9V7BI6NEGuJ9NmK7pB0tazmMJOqE9Q9fG1jlxk
 pdd0jj32i2ti6LRBD3Aq8CSNgBd9uRF1BVrkASHg=
X-Proofpoint-ORIG-GUID: EDPA3doK9tbrvedq34DDLVGxhpLjaG-3
X-Rspam-User: 
X-Rspamd-Queue-Id: E5110100017
X-Rspamd-Server: rspam07
X-Stat-Signature: 3y18mpegwcswwi4erhg4ifgxegkjo8rp
X-HE-Tag: 1770639048-883914
X-HE-Meta: U2FsdGVkX18eU1dXKOrAFtHJ4NQVDpMGiSv7vVsFND+nTExcLTLaMzaAZR3fiYKst4gF7QgjlYl7HxH79RITU+Mn3JWQJvm1t/4XGwcwFX6Wd45PKowy1uUuhk/ucnVdxuKspWSc3v9yWZYsSwRO9oJZRrdCo5D8ZC3XAdLOZG2hR5kQoiYGEuklHwrDELVly/Wd0ZXcxKBBy1ss9K33DxRdB1PyLykMcFqHgED5A8E4uAO5YPglfDplpsMv4qJIIYzahb0yKe3m9eZWLoiWzxczS52pEIU0oRL5VyghIHtJ7JrhEjqViFyxhRqXfUcqyPprDJdm6UsoYj0YaA6heA2QXZ9+CpLJvHSBcMtlNMNUFgUiKwAm4uNDdMySUpxbR0hp9QcWmS9CFQatCeu4iNp5hRTQUWLT6b05zAwg+QHHzQwUKdBH+7XslVFMXwLPi1lPSHfbcgi9432S3NYwOs25oRs+Gs0LV7OdPeg7byXU7OYCWeKliN9lA/7b0cf85Yrh9/3zmLuAvIKpcoboZjO9WEqK7/q/Kss97CcWsw77M9sNJNd/nA5OxKgYB3mY7RxvN6BEUBpkP3D2se6Q3oMn2BEd871/lSMihG+z1bLwzMvB1nREQYfBzcXDcv7SNL1aE4Mp5xBzZ25QvFEONUn8BtB7uYuPDhDCzEGLXWlUfdBDDUMxH7ef1U0tdBjJM2WogibHuRZ26TGJD8ZlJq/IjPgxkTOVMDAkrekm5kSfK9sT2X7XVTf8H545dhhMSmj0DdHKsyna9/pWTepnvGGrgqSytVYu4BALBMd/BTKUapRXCuv6PyV3rxm9LrKS/VWD4j6HV68TZAFnDK3gG3iINFmuIrNvK8ai+F0ajqY9KF92y934AXCpUVDdujHZ7uUTJHzNuqDw8tbXC8/OkMaXhNAQk0Ohvmnz15UQnE5Ygvc8u+91wqit2hq+G35DE8jWkIegPLKdBioh8HB
 QhcVeo4Z
 p3ulMIBsZU55FxW9SWtboJSnj2elXnewK3uulIT9iOeizxfFUXDlgx3CLygrBLd1kTrL93bwNyh1AvTVXL7gGfxQ2C1hJU42oZ/MSCurIe9HD2oE8d1f4WFQTTb5N2oE1EjS/LD3aFavCe1RSDbECv0efKptRtaMclqxl78qF4UW02m8YoPqXdc+mLLHhQUATwCLw94l5rV/ooDtqFYyujDsJTEv+9s94aVVd49zPdibvizBKhSCwtwmrry8vDREEGbqDURCp5o/2Sv1LmVpiRAxZE8jHQ7qfdttcP7QpYlAIi37IkwKRE14NRW0PybHQLVHOi+NoiN/tcISHn4NYaFHDk3C5+KuNJBkjWG/TW03HRCpUWI4WWNVlsL2hsgYiucC0sWubRZdgxpQ7MFqXjG4euHgeMKZFdOp3QY+wcYanKguO47ZX8qL3yIgplQfu1kiDIyQ87mkAsmX2rpLMYLWdnnFxXG+ChADMhP6n6jKWFiZohLcctJ2pCXfrmPHXCqFLLxTZ1cUo8UuG7iv95UwKVl9f6qSbyM1Pgj11/hFgAXgp2AjI6Y6lfaneRtKH2zUEF0bDCcDuwqpIOAT3jP9JnsPdvm5M8ILD8O/jYUJxAB/ZnrqhBFgf2j5YMO53LmKODHVpfK88Cb9xt3ngWNlZcLaHD50JnLebeFN4hC8xRbdG7Ptni7JdNJFvape8qoIsjpdU9bmfZ9ttZ89NRMElvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is separated from the RFC version of "k[v]free_rcu() improvements"
series [1], as these changes are relatively small and beneficial for BPF
because it enables the bpf code to use kfree_rcu() instead of
call_rcu() + kfree_nolock().

Hopefully we can get acks from kmemleak folks for kmemleak part in
patch 1, if it looks good for them.

Patch 1 allows kfree() and kfree_rcu() to be used with objects that are
allocated from kmalloc_nolock().

Patch 2 is a cleanup that frees a bit used to record whether obj_exts
was allocated using kmalloc_nolock() or kmalloc(), since now both cases
can be freed with kfree().

[1] https://lore.kernel.org/linux-mm/20260206093410.160622-1-harry.yoo@oracle.com

RFC -> v1:
- Added acked-bys from Alexei, thanks!

- Patch 1: While developing the RFC version, I mistakenly thought that
  removing "Trying to color unknown object at ..." warning in
  paint_ptr() became unnecessary after changing the kfree_rcu_nolock()
  implementation several times, but during testing I discovered this is
  still needed to silence the warning in kmalloc_nolock() -> kfree_rcu()
  (-> kmemleak_ignore()) path.

  So removed the warning in paint_ptr() again.

Harry Yoo (2):
  mm/slab: allow freeing kmalloc_nolock()'d objects using kfree[_rcu]()
  mm/slab: free a bit in enum objexts_flags

 include/linux/memcontrol.h |  3 +--
 include/linux/rcupdate.h   |  4 ++--
 mm/kmemleak.c              | 22 ++++++++++------------
 mm/slub.c                  | 33 ++++++++++++++++++++++-----------
 4 files changed, 35 insertions(+), 27 deletions(-)


base-commit: f6ed7e47c1fc78e78c9bfeb668b1ad9ba5c58120
-- 
2.43.0


