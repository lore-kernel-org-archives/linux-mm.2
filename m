Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F0B6E9B37F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 13:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2A16B008C; Mon,  2 Mar 2026 08:34:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780026B0092; Mon,  2 Mar 2026 08:34:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637D66B0093; Mon,  2 Mar 2026 08:34:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFD76B008C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:34:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCB34138344
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:34:34 +0000 (UTC)
X-FDA: 84501217668.19.D20D884
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7CBC5100004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:34:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aZtyImzx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PHKUa8SF;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772458471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eENbD9B82kZfhjMnfX3EDLyYN/3WREyGsWnFLEtBHwI=;
	b=pajFr9m9BWwknCqnYKTB0H3WA/awwWvBsntGVyyPpG4BKkEU8RLQsIDdZXopCTxg+yPdiL
	Oo2G3jBS0w1THEUunv+LpKZTpVwqeoFpVRovY3YuTg40i5V5kGl3/N/skO6OMAEn04wrg+
	EUAA75zpgoqJxzd6RZBRnYb4lIg2wNE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aZtyImzx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PHKUa8SF;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772458471; a=rsa-sha256;
	cv=pass;
	b=pV5Lj7R1pyrskJnPy/6w1AvQm4sen2wxadFpN0oblRqIXMVHZqRAxSPTJ+Y9CsiaYaRcO8
	PUzdk4/mmBNkImbVpu4A1Bec23yeixrjjR/mI41tPzkomYZUxcUND5HD3FUkKk7CJUk0yA
	C7dkEBfedHZtNTjxM9i+ES7I0VEld5k=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622CxJZ41962558;
	Mon, 2 Mar 2026 13:34:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eENbD9B82kZfhjMnfX
	3EDLyYN/3WREyGsWnFLEtBHwI=; b=aZtyImzxU3JviTz/mj13y34OuPytRL0PTi
	cZ3nubtT0VYRe9GWjWE2e+DaLDPqHn/8cnPlbG+s4yvbqvSHyAPFE8New5fxqKFh
	KEYcPbTc3klaCYaPSg2Wjp6YFyCVmgKj5OAWyxgAednBFQF6SBgjtNQrwVwOkAaF
	MnOakGFx77Y7Zy0CDqVDlJW+TsWsZqNnJ7YTp4EatHUKKxEDLBqtG5Dx9H+wRHCc
	GFAsxmRwtVnzp33XAMJ4YNEv1s5VDqFLRkqGCjivWi3yyoRXj8h6+RJcq7qw2l6L
	OYRyDNJJTBbF/HwJvR9w3RMLmVpSnwgRNAlAkif7Vwo/bPdZk3+w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnb11g1xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 13:34:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622DDq04023114;
	Mon, 2 Mar 2026 13:34:14 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010070.outbound.protection.outlook.com [52.101.85.70])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptd820m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 13:34:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wH/Q3dpnZ5YgBFnBYkXNVfhaxKr56qsQFfCJkX48Y9v6xnb//Gvm+NAF+W9zEKl+MCq7rIGCl+ZqpOokWKZ1Xi14fKGsYRkunhi3Wm34HZtGg8nwF4g2nxqBa1ZrJ3bL66vBkz+cxmVwf0RJkgdPPZEAcB/Ih0O9mBrsR9Dm51/MqOtOVvROgFEX6QgX+eyVk7rIpcE7Kdgb1jbjwjmKktzkoIXu1dP9QZDmXJ5SRTOmQ7yinWBMV3WGIDQIjI1VbJ9BIfpc9JbqTTyDMMeNiq1B0oslBFxhmfWZBZdgFM2Fkc7QNIud0TDatwMhhGUtlQzbg+s8Vietv8wS7ETPdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eENbD9B82kZfhjMnfX3EDLyYN/3WREyGsWnFLEtBHwI=;
 b=WfcMiEoIZVXZIc2PI8GMryUHoIOmuhZIdmhGI8Htyj83xmWkP3gLuPm1kM/zqNRGN8Oas7pe+X2Krr/lI119d7zataVs8pvPbMM+pRwKc0oCTp5ZbUchUKf+/Unex5GNZDmV4NFKd+01aB8z2bFF8Z16ZCxdr+0AgwSR+dULrpviMS3q9dhkVQZHUIUtfTRL9+K5ZQ/aztganMRmHV7Nmu4FEbxo+y+rD0Ed1QNYxTWPGGj+TrMXgvItLOPB1Z6WklxhK0QlLIKEEZ+De3/95Z78Hba12c3IlnJc/4fQSb+r3Pnatcxv6QQ50WJJPRqV4fykb0qzBYc0tNpvOAinkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eENbD9B82kZfhjMnfX3EDLyYN/3WREyGsWnFLEtBHwI=;
 b=PHKUa8SFsQEogTf5G4Geki2YXprBl2K12H1xoWJ4iStyhvBCCubA7OntDW/rI12BmqRNAjA1zVdufvmLT/Jfrq7s+VZ18CF5/IZ+eNHrLCfbbOV2O45mvcpFqDHYowONMZPmIYisgr/wRWTDBQq1xY32WRCtCdqSPMd1ojjz7PI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7740.namprd10.prod.outlook.com (2603:10b6:806:3af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 13:34:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 13:34:08 +0000
Date: Mon, 2 Mar 2026 13:34:04 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Cc: Gorbunov Ivan <gorbunov.ivan@h-partners.com>,
        David Hildenbrand <david@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
        Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Muchun Song <muchun.song@linux.dev>, Will Deacon <will@kernel.org>,
        Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: make ref_unless functions unless_zero only
Message-ID: <54591d9e-0298-4907-8c51-84e45d62e551@lucifer.local>
References: <a0c89b49d38c671a0bdd35069d15ee13e08314d2.1772370066.git.gladyshev.ilya1@h-partners.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0c89b49d38c671a0bdd35069d15ee13e08314d2.1772370066.git.gladyshev.ilya1@h-partners.com>
X-ClientProxiedBy: AM6PR04CA0069.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::46) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7740:EE_
X-MS-Office365-Filtering-Correlation-Id: a58e5924-2c56-463b-acf8-08de786061ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	Y9uNXV+FsaaVl+FErQbyFB2ofuHkQwd0nPRN1cuVS1B0NBmVj6uKxKfnFjNQH1qevvXECzFqnZ+5FRHYRIC3t+ucnOx13M4EVoaRZA8znwWdnNpzo/iyCU8Th9h+uS+WhUuKS7QmHmAjT2piALa8C+7iNZ5uuqSEwFN2LdjPo0hfib9PQq3zXRqfsASW/JUV2ktS3ZdBFqe1TnPm7E6rhlqF/piRuXQV1oea5Y2fbql4buyBfHZBtUdBRrWQqp98ojV2t1xECqGdYcPCaGLE+u2pC71bfnRSqh3tJl2l/MaAu5X9VDYcyDf4vedoi6CWW3hz+HV7b6vrafwh//8HcMNjd/9GEtSUXqs6ekb5tnXIhD+oQSKY0kE5eIZ95Qn3nEnkYLZbKgpam1xmanoJelyNl+Sqs4uTZ699kspAJfBMG+zTKMbo0/dYFlpZd54Q0XkPBZddNEZE+aZBd9zSx7vdyxPykDF3bcbbl1m36DH/ebcjiMt1Pe6AmkZJimJp75u4SNJCNPy2EZhF4qWASFKZVDJG6RP/94K8HWqPmRz2s1KVRzWttlImVZBjXfSMmQVH/4l7QbopVfkQWPz1XaLQZHa0Lag76ASCgQf4hLG6OTWTqPFkHN5t9FIrdSHPiHSMzXhdCjmRJJGukcnBVq0Dt6Va+hB1trSzXJUGu54apLjJl5/KLANKqjJ2m5eC/oPD9hreGXSUm112JY+ewDkZcFcYddxLSGTEP1fjAGk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wddmzawgqBK9fMRNG2BOUzalPtp2RRByMCaobYOsfUaLOHt4zDzodeCbauDN?=
 =?us-ascii?Q?b/RoHD/3QaEGgSGGGfZuy0wo9rD6FrQLwxU8/L0d3RHUAofVMVBpqNWc4lzR?=
 =?us-ascii?Q?G1RLC3WBJApPkulAH75O7v9ObK6wdwLQ/z+nDIBVE36lCJ+Aw2qvvxH4fiK0?=
 =?us-ascii?Q?szhGu7aips9ZeuLHVkxuySRP1ISVshJ8OkdB5t5qjR7ZPUvay64DNw5VCS7k?=
 =?us-ascii?Q?Kk/8QWMraaiZv+pHRv8vrMw1GKSF8GTvhTLE8uuTYJXLhjgdvnM8mae7lyt6?=
 =?us-ascii?Q?KMkX29HGJDNlhnzy0D8XJ7efd5VjouFPM8JnhITr6Pwx/6o4hUZQT3DMHmqv?=
 =?us-ascii?Q?Y5nfgY2b24023Ou/WlcBlwEBwsZcRWOJZfwSAgAVSAGt0g3WcgJYxzArDDL2?=
 =?us-ascii?Q?OnyGQEOOUzGWfW9mOvyEgfjIrdXfHXKA2cMvqYMIH46pMpBl9d030+zhCFek?=
 =?us-ascii?Q?E6aQPFHeuNhXpb5sgjUAia8fEaMF5PpiSOtF9Li2zI5/ao7fDOs61vHbiRM2?=
 =?us-ascii?Q?2I8jf8HR8S4iN8xgBQIlljkwXZGHazcTQ8x0tmVQFQpvY2FexU3RJpfWFO1Y?=
 =?us-ascii?Q?9B0Ms80zV1sjYg0IC2UFhZX9EX2iyn60WDJSJ8XPM1H7G6DWdtAG+ex2w9eq?=
 =?us-ascii?Q?hoiuWCffCSPq9e/5+pXrk6RxwTfGLPibQuYWCka/3/NB6Q3GVIIGZHcNcxmX?=
 =?us-ascii?Q?Vsj1XL12NF+qX8jFv5JmnYkPP+8Wap7xV9fcWkx5gvy3M9793Ygm6RGw0Nmw?=
 =?us-ascii?Q?LxjWOtJe4kXx8nPCMOK1zGDBcit8SEuiVpKIAilGmStNGbMIuY4v2R5vU5QU?=
 =?us-ascii?Q?wHfgOTnaCAtflysvVnxxMTSfXG+Sr6TWTiyHR2fRHPBHoTrD6B17o+Ojzaad?=
 =?us-ascii?Q?Wo0SwW6QdUvuAI2TjytUI1oXiVOeZ2PupWjc0MujUAboUOP8GvNojnePOi0z?=
 =?us-ascii?Q?IpXopnZ0nl5binndUD14YQnhCwJB73XgTznKhxgSffHMRGS6G7AfhWpjtBp3?=
 =?us-ascii?Q?qtEX+iVYXfdA7A3I8fk/jNqeGZwRnEWK6MlqpC8WLTbpLlT+d84exY3o+5fP?=
 =?us-ascii?Q?6AIcTZld+64O8A56XeO6hoqC2o4Fv3Q3jhg44J5yjmNEZrfoXTNrji/KigHE?=
 =?us-ascii?Q?obRxOqKRFK/HSwTZsXHLQAqNVXVHkivo4irmUIpi8SSOunuB9hU7ejJhSffj?=
 =?us-ascii?Q?0AmM/DcsTDLm8L6PJXy3Ah8NRTW+jxNttLjNaodpe3NlUPD6G50AYKvwHEaz?=
 =?us-ascii?Q?vugC+dNt8DPWgiaSxop+yBnwJGBVwGokcTXdNa7TpJkaYOzaa1MEDNkhKp6s?=
 =?us-ascii?Q?mOy5Wr97NMRYUFZX1gDpqCe6057LkiFrNC9OZxDnan12nzruBiwUZYp5Llw8?=
 =?us-ascii?Q?GOS8Ro3FrkQjIuBcvcRgs+vuJNR95qv8XLcuaAM+tS+/pZ8/HiK3zE384LGc?=
 =?us-ascii?Q?c4/TWC96juw8deKjNiKqEa4RGJMfxn6TiIFAp+Xrxv4yfgDkBp6P4yGJbwzi?=
 =?us-ascii?Q?WV1xKZE4j5DYO3Qne6Dn//FbXrcTm5rsQd9BmKQfpSU65/M+nv2Gm3BlvGNm?=
 =?us-ascii?Q?ucKUnvi6+Wtw4V4vTuN10KcaEUVa/A7Wz+x9CFBFRsoL7aoOgyjojz43LHFo?=
 =?us-ascii?Q?HTyxYbpzXCMW79sp3pvIkeZq3mzLdPxpKMEqI89nwE2xz4RvIWp5zuj2s+jD?=
 =?us-ascii?Q?2JCxsiaSC4hcnAwesXJrSJqSNfyum7EKDmRUU+JbZJ40xgqUfl9oSUQrJIeG?=
 =?us-ascii?Q?Rbl/Iwoa/fQAwQaDPh9mKS506DI93Qw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rcIrfcUJbNjOjy68mHCMPOeC7u2ndCGNFky5fWMmzIbMEpzSsrnXAzbRxrGjrLUPgXW9gAHlsJweNajVQlDcMdL+K7lzrNj8ugnBoD/G/tUmokvnGQUo5gDWWZLKGbAv+3IXVvruG2ltkYAP4ljm1/dV5Vc77eY10SswdhKL+7c44BUthkmWTZCyKWRws/Xshdxvov2pUof9ImisFtcPLksj0XE5QLwAs/tmKskbMiAk6wpql9Nxm8QbTxNDHacFLmXhhrZFmqkrDhgV2broTmJqCPwtkDbeUGVR2zr+Kyd5VkyedUr2SgYoKVF8/vWRLOVSPY9028zSaesdazYGlkUqC2+nwtu1BAWwMf+HoVyNB+EDcKy5XJ8JUDZ8PmghWIqEOE/30EIItnExvacxXs95s1Xu8gAz2NvqjXgblIYbJ7e+68iaEjEXWp7DHTUhTmgD+1R7Qo2GJGvKJy8SCkLHXDcXp5hpViiCapr9oLvNXX4gYO4LQjbo5iZKKGQU7+ThLQppo+Asmfa4CRZdH86PXsM9WIUWoGNrdkZeS3Z5GLJnYCYkCFKYOqtbeAswaJ3R0/UUZ0PReZ4+QnS0ZmnAA1VjeG+FNfr0ZAsjvv4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a58e5924-2c56-463b-acf8-08de786061ba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 13:34:08.7470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MQVDSLKdY+R7RO/sXX9WPbA3KetZznOb69DlQEHHUov6uwxV3jnC+l8tttiA++lhVasJgHJ3jWMusoIyuNGl4z5BY7T7Jl1gvOMBlesvS1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7740
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020114
X-Proofpoint-ORIG-GUID: D0v6CRXndSFKET4Zqma41JpsfuIhQX09
X-Proofpoint-GUID: D0v6CRXndSFKET4Zqma41JpsfuIhQX09
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDExNCBTYWx0ZWRfXz4nAFQAiIi8q
 shyQkifHiU9BuTQiM69GoNs7FK24tEeA4+ZhwEu/77Nw5s/nFJdM0k9oAVH5LWgsvos7oP1fTqV
 RObOoovQbio+qc2y71YQoBSYz3RsYmpAEYwncNC9nGVlRFX1/h8ziKgp3OO4DZeJSgy74CtuM57
 +EfmP6Cq2YwahpKlKV+WSW2BxQJG7e1E1g/SaKFXjFaPgor2CTAiz7ucpSF8WCFPHSLvvXqutxd
 Q7+bOcFu4BMWTdOrtJUwwhTjoY78MVCgMOyhUrWsZoFAwbPswTnFXzzH1p1WboqhfK/29wYvb7Q
 BJK6um4VvYZsgVS29jTU2dswbaObrx8m7s/iSbPBEzMJaHclAOT+0TbNzC9OCOx0n8tqOLV6vps
 a1KoHTSnpMab/TiX8nHeqrBH5Q85oKU8/a27Hq6fi9Ii13+aX1fL6oKyaxVg9FYsZhtID0pd4Ds
 68sx+GfR5BKsgu0SCHhoGNlsl9HJtSTdyjamSnUE=
X-Authority-Analysis: v=2.4 cv=KphAGGWN c=1 sm=1 tr=0 ts=69a591d6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=u7uoXELoAAAA:8 a=Ikd4Dj_1AAAA:8 a=yPCof4ZbAAAA:8 a=sa8MsQgM-CnFqvxBFIoA:9
 a=CjuIK1q_8ugA:10 a=07tN73Fy-TQQJT60VmHH:22 cc=ntf awl=host:12262
X-Rspamd-Queue-Id: 7CBC5100004
X-Stat-Signature: ikt58yi37hxpsu9r4sntonky1y1d3tkj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772458471-891549
X-HE-Meta: U2FsdGVkX1908/Wzj0LPbDkMSXpH5XE0l6Aa7b7gXmpwZ1t/bUgRYMdlJE+98olZeYW9/NduyWe6adTiB/zOrpPZkcyez9nIJj3LFixIbiii1u5rCtXtkdmc3zz6hVwWXVOlpqmq+R/uP03g2FN/0eDtMQyGgpef2fdvrfsTgI3551r5e1GaOk2NMkXbwXR2/soG7A27QAheS6Bz6GfaXCTnfemgi8vjk2PdtcaJj9a4oVbtvFjhw7AvTjvd4zuEe4HleEf5k5sjVUOjd5Iv0VnOZOjGqx7230+mYkRbxfQnCKpLHt8J+JjEXLrQrPIBcmLzgN0RcD5aUfBey6eO3iuUj9Qpd7r9ZTG4LwzA8VsPMJKDiH27byHTMA7uDe12VVRgZIAR+ENLRqbx2HxgI90qZjEr4z7ptN2ySYMolysHy8SZ29tz9r28CUVU6yvnAg2Ar31eCpiro0yRIAY9lbsB5i6v3VaOUjT+qsFxJNDQPUk/FCmLcabckUNirTar+0Tc4w24lC3g/juSkW2b2eoX8TcSmS9I/YsoIdVcBwMB/fbfzVIbDmbJsDe1xAZY4thKx9NIGgEYChNRWuyKphpjLZdLDKDK1IZNLwbL3WvMpztLk/R2+UG5aBTwldd7ZtZ+xUZ5OsEDpPjzDZwGgdhL8KKQZVbgXktoot9/Z8pb8mwI4K9at/sztP8B9Mv6LdMMVO04AKGhkldBMueYFzDESeRfqQQmcvFeIXsG0lnnxPH1cGZ7lFV0Bw2xJeAFmJz7GzxaTZ6142gYLLr/ObBiX5Ce68jog2ykQ0Q0FbIbcccy9MYEYwvpziG5bmiaOCR1nbCz1U7s/dCE3wR0HVctNGP0Sjth0283Ab4LGbkvyNnB4g4N63yh+mwrSDxK6WCA2v6JXxcQiBtnuXQvSZSAYPfhafcMBstcE6qXjcY+/EOwygLvYnlykOqoSDzjaGSsPGIOCsRWcSALmnY
 8UT4WASd
 Q0h6E6K6xbCBT9slKQBYWAOmoPinwv0BM9rM7LOimQ/QABbeWMcfZqR/L3OZp6bGSprOhHV7F9NHMTyWIRVHMPlm/WKOhdl0pHbQhpharOIF3WCsWDjqFb9tMjqjDkysW2brvyghUYZeArL9+zwQsenLAu+S/fnIeWHw6r4u/KiNuQbsW1VY5FbWPhLGJBsBaYJvgM+p1hV92k3QfoAdL4PnIP2K0v2rZeCoAvuBcO2l6pvoZ2ALDPVEHEqfEURYY+tRGnhtVLo0wZujvAhKWBz2qHJGNzN2IGBAWzluZ/CfEDxL3pVjPU+v3JistopB7CywpjgdwcYW8HnOSxC02Bcm3uFKMjmT4hxbQ8Q0wGQ58dWJjqy8kIBx36TG4MxxubjHhUWGZXYsTG3j8hq1QNPUAP7ap1m6O0eh2hUTA4Nte/dI0JErmCbjE8wxknMYFWzrn31+iZkyFMqis75P0hfLY6WWpVSmEiZ1ypjDMlqgqe5Xk5W0cJ8ncwfv3j9g6R0OnD0dPMXMGh4kosc4bklQjDYWajMMIGGVaVRez2krYMAdp+xJR3uy0jSUYkzU1BYOSe3f69gdZbC8dmciDr+MKjU7tYouMUTPjCVWQ+MagNloKhe4UUlSKkyrfFPChAqdPPAT4EeiS/WzRhQi61E14Zl1vWDiAPL5aqEmu+FDxoUzm2hbdNlVpE0++7Nocr59D0A2YooyolfqCD1e6XhEbFlsNXEVMgpV50WeGN+tThHDjtaC+4iiflx4+iochpUApIalyI/Hnr+B6osjMsnTUHVxu+oImIp9NmVjkMl+bhF5E1XOAfDDsy//76Ntu51DgSKFKyhYB/W0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 01, 2026 at 01:19:39PM +0000, Gladyshev Ilya wrote:
> There are no users of (folio/page)_ref_add_unless(page, nr, u) with
> u != 0 [1] and all current users are "internal" for page refcounting API.
> This allows us to safely drop this parameter and reduce function
> semantics to the "unless zero" cases only.
>
> If needed, these functions for the u!=0 cases can be trivially
> reintroduced later using the same atomic_add_unless operations as before.
>
> [1]: The last user was dropped in v5.18 kernel, commit 27674ef6c73f
> ("mm: remove the extra ZONE_DEVICE struct page refcount"). There is no
> trace of discussion as to why this cleanup wasn't done earlier.
>
> Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>

Nice cleanup, thanks! LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

>
> ---
> Changes since v1:
> - Rebased on mm-new
> - Remove mention of the "next patch" from commit msg
>
> No functional changes
>
> Link to v1: https://lore.kernel.org/all/20260206133328.426921-1-gladyshev.ilya1@h-partners.com
>
> ---
>  include/linux/mm.h       |  2 +-
>  include/linux/page_ref.h | 12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a68f065399ee..1294d29c8d93 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1506,7 +1506,7 @@ static inline int folio_put_testzero(struct folio *folio)
>   */
>  static inline bool get_page_unless_zero(struct page *page)
>  {
> -	return page_ref_add_unless(page, 1, 0);
> +	return page_ref_add_unless_zero(page, 1);
>  }
>
>  static inline struct folio *folio_get_nontail_page(struct page *page)
> diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
> index 490d0ad6e56d..94d3f0e71c06 100644
> --- a/include/linux/page_ref.h
> +++ b/include/linux/page_ref.h
> @@ -228,18 +228,18 @@ static inline int folio_ref_dec_return(struct folio *folio)
>  	return page_ref_dec_return(&folio->page);
>  }
>
> -static inline bool page_ref_add_unless(struct page *page, int nr, int u)
> +static inline bool page_ref_add_unless_zero(struct page *page, int nr)
>  {
> -	bool ret = atomic_add_unless(&page->_refcount, nr, u);
> +	bool ret = atomic_add_unless(&page->_refcount, nr, 0);
>
>  	if (page_ref_tracepoint_active(page_ref_mod_unless))
>  		__page_ref_mod_unless(page, nr, ret);
>  	return ret;
>  }
>
> -static inline bool folio_ref_add_unless(struct folio *folio, int nr, int u)
> +static inline bool folio_ref_add_unless_zero(struct folio *folio, int nr)
>  {
> -	return page_ref_add_unless(&folio->page, nr, u);
> +	return page_ref_add_unless_zero(&folio->page, nr);
>  }
>
>  /**
> @@ -255,12 +255,12 @@ static inline bool folio_ref_add_unless(struct folio *folio, int nr, int u)
>   */
>  static inline bool folio_try_get(struct folio *folio)
>  {
> -	return folio_ref_add_unless(folio, 1, 0);
> +	return folio_ref_add_unless_zero(folio, 1);
>  }
>
>  static inline bool folio_ref_try_add(struct folio *folio, int count)
>  {
> -	return folio_ref_add_unless(folio, count, 0);
> +	return folio_ref_add_unless_zero(folio, count);
>  }
>
>  static inline int page_ref_freeze(struct page *page, int count)
> --
> 2.43.0
>

