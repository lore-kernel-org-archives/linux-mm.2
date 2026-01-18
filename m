Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6F11D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 14:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6C426B008A; Sun, 18 Jan 2026 09:52:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4AE26B008C; Sun, 18 Jan 2026 09:52:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9597A6B0093; Sun, 18 Jan 2026 09:52:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 719826B008A
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:52:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 176881403CF
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:52:04 +0000 (UTC)
X-FDA: 84345374568.09.6D6587D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9D755C000D
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:52:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=k9CHvRWO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=I4rrCOcZ;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768747920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UG0h4SadpShBgRwtlfEMN2PUtIRkSKVNTuzdST26eyo=;
	b=v76OQXOLIY45yo9dB1yGdkPyWUcQBNZUkBf9MdAckyxQmMPrLbEhhi03Dm3gr+q2AtH2yp
	fORVPL5UnApTpIAslJXJB5XWo/GVh2yCopcJ5qgPILWENE15dag8EdRkcb/sUUnNW1HEY5
	ihjeraRskq2VOYTI0uNgZBcEnVud5/M=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=k9CHvRWO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=I4rrCOcZ;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768747920; a=rsa-sha256;
	cv=pass;
	b=7QBcihS7fLo9t3NyKCyqn6xdCrX+46OeJNYtdRsZl2kuSrS+teCUVzUckTGIZSyYL945Tr
	UTWwFyea264yKlFedcRLLV2i17A8JMnev8zww7429RLdFHHV8j87Kg9T2wlLl9pZBctk6C
	RCzjs2sEYqQ5HbwQ4nf/6wf4gzF5fkU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IDp0ix3217068;
	Sun, 18 Jan 2026 14:51:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UG0h4SadpShBgRwtlfEMN2PUtIRkSKVNTuzdST26eyo=; b=
	k9CHvRWORW45NGIcewbaqlFC/D2uumCfEIUubd5SzKflVxKiYtYDydfsr2E4O6Pl
	jiPc0Ft7Bqa9hno12bs5Igz8ln74Csd4Mazgj17t2Pzy76U9wVpe7Cl/lx32TFQ6
	NRENDPg/ZkEDH2+ZjyIE08UevguUdSgGpLSUv7vU15fsC8aU5PGbaJOz0nR2dp06
	93Uj9HFVEDVpHLAqEC6Wyg5ZUGU+x3g2FW+ns91wM3RtTs+nfkfdtVqMOB5cTQ53
	cqjjByZcKzY8T0ypt1wz/aM1x5vMs1sw8nmhiPUo8mAbUeocb67wJjhehDm8BaQF
	nc1Dbm+HNtfXe96ekggLmg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2yps8ra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60IAZ5P0008406;
	Sun, 18 Jan 2026 14:51:54 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010057.outbound.protection.outlook.com [52.101.61.57])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v7eut8-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pi3lnvizQcXVcqT+NDPt39vWzzoZlueSrnDCkQAlIhoxbF2Tn5ReYDIUEpGonMWWy3wM7QEOtRjfqmY5KjQeXciXuu3imdp8wrAWYvK215/BDSeKxBztfUPtNdrGjgfDguJ+5ffrOCAYyqT8VvBsMBIFSIh+Ojvo6tTju5ousFZj8VpyoWDEtzJtuxOXRkL5GakMeck43AiyjPTPu5uUK0OgM9GlvZ5ubD66rnhr8HJg29lSbJyUaT3PFDWe7+tatAjZDjnHn+vmGPshj/8GW0cxcmfRRZCXXIWjb4lGP9DurliHOaUYAvvrzmH5hJuutSevbHby+HWdFdvgH+FQ5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UG0h4SadpShBgRwtlfEMN2PUtIRkSKVNTuzdST26eyo=;
 b=nBnN6Xn9J3Dlq9wBtpkq+FT08psS2LAR5zu1bi/nydFkf/JvffHiR65TA0fMmDzQhvEwalbBxRRuaN0pEvQK2Gtb38GLQcTXFUgK2uvQ1Jp37quOvtzZ03XehNh1fp1mS3wIE7hNELqvEAUv06fhMHRzJcva5bupSPLx4mC+ija0Umx12bkzcldseZTRQStVThcjlMYUge4zzmRkrv/8Qjfd2y/PkgegXEmAFj3a0H4qzO2lVZuokCYXKpPRDIFFXeKrK60iEEayf5gZr6cBPCPdv45h2P3z+HozDYcPkpv/yRmyVxCx29QKO1Vmf04OmvlMoV7T3dngJS8JcVUeMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UG0h4SadpShBgRwtlfEMN2PUtIRkSKVNTuzdST26eyo=;
 b=I4rrCOcZcBYDXaXkLbC4hwwnMGkl9yIRXABrWS6aPljHLhm6K6c8wFXRjo2DeyDT/lPgUXJnI9zmlnEPMQzPWL9+4YcxKPzJuC1JEoE5KGMui995fhlL2qTBQI4NDeP65UuK6KCyv44T9I8MKVxuI1PFZxBRbv4I9Zz4ILgyk+w=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 14:51:51 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 14:51:51 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/9] mm/rmap: remove unnecessary root lock dance in anon_vma clone, unmap
Date: Sun, 18 Jan 2026 14:50:40 +0000
Message-ID: <838030d2f0772b99fa99ff4b4fd571353f14a1a9.1768746221.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
References: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0294.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::11) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: f7aa9043-5c8e-4012-2745-08de56a11d5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SS+zD/l7T+3gtOuws6pp41oX1js5Q5atmLh+6ZuSsmqMcSfJEySyxOGJMxJq?=
 =?us-ascii?Q?sumPCTk6EJyNuR1r2frOdLQz0Q6uzwdLEl7NWRJSV1zrsXVBw47yC5ia0RDC?=
 =?us-ascii?Q?prxdH2qpbwHYC728q7L+yj05m1q2iz2HO1OFHC9QPlb51xe+hXHZtZuSVawb?=
 =?us-ascii?Q?jQkXYvabSF3mFdi/hPGy6s+UAmxkyzUN/zkrVP3wTFkfYxGxnTBmMf9uBaI0?=
 =?us-ascii?Q?91OmVcebMhaXKYgxISLXdvAlStfpIFLbSxe9QPE1AU+lnVK3rndGQfV98x7t?=
 =?us-ascii?Q?WQoXdsKhaS8Xsb0Lqq8lw9yql5yhdmCdRdLDrAXSlONP2d5XCP+JNSHNTvr/?=
 =?us-ascii?Q?FCHUbexv4+k8WdWnA37fi9xVeKn4fjQKl71spKHW+riHBe9lgFfrfYkWrSWn?=
 =?us-ascii?Q?NWafwAhM1+Cxhhg5ia5o1EDtNRS0O7dkLJOX6y7Rr7/v8d3khnItrg8YPuN3?=
 =?us-ascii?Q?DRPU1TaXvQPSBIVrxaJ+qm4sBB9QHrw29bA2RY8Uyk6IJ4RvUHGnzeexzBdP?=
 =?us-ascii?Q?vi39qgrVMrJXFpjGXVOSCf3mE1TJBimS7sQnMaTyc9PBR7RRIoKB38jD9uqY?=
 =?us-ascii?Q?oZVUpjtpa3vXZ0+rzQIuATIhMHe2mVmHTHK8fp77YYNHmU+9hNllU4iod0Sg?=
 =?us-ascii?Q?uaf7eaIl5VwZRIBdCJEynYPQvEy9i27LYdRnmODmq7HMH7IoRcB2LST3bq/U?=
 =?us-ascii?Q?kwpMsBtvPI9BzXDG5lPbN5d6gTIc1OiasfkjwHnaIWygkG+2grVAs+aZ1p0W?=
 =?us-ascii?Q?fwgHOEcdOKOZCL/RVLFtRQyxtRSRH3QCxG7PD2IfJ2txOYFNtR5AhyDIPVDk?=
 =?us-ascii?Q?PIV9Xf5GI1UL0SsRt5FIXPIVov/ytfBUiD41FNzxn59tBGQI89CE6gG7h0JJ?=
 =?us-ascii?Q?KOY3MmkxCk4izy1pzpFLG7nL4uAb2+Xq7zZJnUKM4IgCO9oGdt/STaM9hpAE?=
 =?us-ascii?Q?kwdxesADAZ6MReNgXfHFT7Vhh0qxVV8G9L+C6R8Anm6BR5lZT+tF4U4SITmD?=
 =?us-ascii?Q?XPCWUMxedUxo4f6SWzGInpGK0b7mhpzHY0mKEtK0r51DtaHyHGGcBgTZxVhT?=
 =?us-ascii?Q?J77sF0e2rM9cJu15QVUxSFrzegn8kQ3Y/ChFDCZto4ImiWnEX5BrSD9xRAz6?=
 =?us-ascii?Q?k5s0sExjnGnx5AOOBkhjDgwfs/x+TpIeb8OUSrbLf/WprrRNcv7McQGYKKYq?=
 =?us-ascii?Q?g46uAxFor3VX45urpomlSxS/RZdCClakhRY2MlZb0OF2a7erL+NRQRvtOeHM?=
 =?us-ascii?Q?RTZi10motJZ/+xaYqDnLVRZdX7quNKbjtyf3mGih3uOZlZvbR8GL9G27+jVi?=
 =?us-ascii?Q?IvOHtRpDNvNgp9gZmqA7rULpX65vrYoBXjqSNc77exKyfF7h76G9OcD25N7v?=
 =?us-ascii?Q?p10PfKZq/h+02AODyP/aZO9I6HMC6OZOj5XCSaawAYdORDeLO6ZhCJ9/aCob?=
 =?us-ascii?Q?vBLJW5J3DlbhGdMm6YLYORwu0Z3WZ2raVwapbp/eliMqOoeFs2OSR5WuC+Mj?=
 =?us-ascii?Q?0L++PPRA7jogFKWkk3n5bTNtwRE8NMDym3se9Co/CSnfNBKWkDD/XBmespyE?=
 =?us-ascii?Q?tt5otDg01XgHD2qDeNc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/JYkSF5PhBazHwFir728nNaKqczLUG54GW5XN9cNlOtgFkvBhGouf3tcWsxG?=
 =?us-ascii?Q?M5OO5zrJSG0guEYyFGCeihjHZ1QUupsaFFNuk6KQRPWL0XTJ+yvkYPsWJIhY?=
 =?us-ascii?Q?sF1a/gDmvnVj96Ld8wFO5fIARmjKKE7N1RurL3yVbFF3aGCquSz2ADEXPlMX?=
 =?us-ascii?Q?j5JOkaE2Gt0QIJn0pcVk6aNqz6wi9MoX86bmmlyK/VXumpDNMO+CLnSqj9MX?=
 =?us-ascii?Q?xAHZp7V6datFuCfjapqonm1Pb9NazhIXAGOfJC27idI2RG6TRY7u/3WaElu6?=
 =?us-ascii?Q?yT/wtmswBAB7bvRkUKbA0yLaZYPOREqHhFahHng2bdR8+EyF159P8Ogb4GjJ?=
 =?us-ascii?Q?GvFKdBLTAEyBuEMvTxEtnZdteqfxtVCLQvglQ9nkbVeB0ouORhg7KaEHY4IM?=
 =?us-ascii?Q?wbW60Zd9P0bwCuiwfS4N8TJQnWUJY1WYSrIef/eXB97HYMw9FV1Iea+Jpcnr?=
 =?us-ascii?Q?Oaaajdgfv4kSlGj6R5QQfOy5iS7blAPgXWgv12KEEaYqKVqGP6FjGK+vQ/5S?=
 =?us-ascii?Q?9t1y1ebHhiL1He2MLN0WBNKBc5L+IEtp0McWmrCdBXzQRBNIl0I6ks4fMwjL?=
 =?us-ascii?Q?Hf/qLDLFxHdFn8ac7OFbwHoFdUcZ35DREcwLSLG5Jc5RHAE1xXN6Fe2r1AWo?=
 =?us-ascii?Q?Seg73L22ukGirBq60B2R9+AI+SZheRI8/K2Eo8FSr8wObs+bmLJSvoFEVhWV?=
 =?us-ascii?Q?f2ap/iok4ayqN23p03/sGvU2au9Ba7//atQlH7aFqOIZZeKXguXbakcm8ap4?=
 =?us-ascii?Q?/AWpPkPAiB2Q3yoWReYYYyB9hqFd4kejCwftfkPDteqehObdkKiSqtXnaqpF?=
 =?us-ascii?Q?zXg1FaGMtTJpMYfzJp+porhyfnlJU33FQhN/P9MUKQgcQ2ASwMhAV43onQL1?=
 =?us-ascii?Q?6nRBZiVc1bj5yMU3G4t3H+I7oEsBP5cKVcu/19RVY47z8BfoapRn5RHOeJtk?=
 =?us-ascii?Q?U1b8jCI6+yhQ9NOVDRYLVrelS/SBNcIVCHhCCYZc7sf60fT7TY16oUfp5qP4?=
 =?us-ascii?Q?24AVAIYWlDsqPOGzEPv7bczRdevNQQBCo54k0wEqOzkRYGzMkLIo1ICCPwwZ?=
 =?us-ascii?Q?Z0j1IB1ZOOqLLcUd9K+6FkMqqFGdXpjmHQAObkzkdwbMiipQPF/wmkOt6AkO?=
 =?us-ascii?Q?DHbTwjp94fOGKEXLJkfpUj2Xg6jxBkF2eW7QfVKw7BCijdDN8Q2HtSAvxe24?=
 =?us-ascii?Q?AMBxgaUOTulvPM70OLYiUUoVGSl6fO2JPBW6B2aULYwoXV+avHwoBGrfSjOd?=
 =?us-ascii?Q?Vlr2i561XZHmBiHy5bMk3YThcZzLjlS/o0Btj+DmECovdN7d1mVj+ZEEjJ5O?=
 =?us-ascii?Q?Z+X4yR5mQhYXQTcNtx6apSHtQhNLcCBljsPV9kmZDBIIXAyj+j5PQ1ZO5Gk7?=
 =?us-ascii?Q?bDT5KFHPlZyiex8/IkzO5LtRW6DVQPtQYeJupR+7qWU4ip3QfJiiW51WkLeW?=
 =?us-ascii?Q?3Wux6Uf9DXBIZAfNGgaZENCu2SvdtIURvoPf2wQI4msLVnhbZ8KjNWOU0Zom?=
 =?us-ascii?Q?MbJvdy22hZBjNczDm7Krj2P8kxq7TlpIjEVLP5/nxe4n5rNY6KfjEZNbX/Zr?=
 =?us-ascii?Q?euo/oU7HeCv0HhfBrNZQDfflfC/7lZw8iYcejSF8REaZsf8A3YFkEwIrV/Nt?=
 =?us-ascii?Q?jcrtiEk5LYN3jJXEUTkCzqxdwjESOttlZCsSq8Mopsor994EYQyz/TGUesMN?=
 =?us-ascii?Q?+9BRTHKjoQRvSpjiaWBkGPimDctHugn2kIHgQmgxioLbJQEEKa7ZST7a/SuL?=
 =?us-ascii?Q?P3d3B62BzQ+QpxYgevIDy3fLsTNCVZs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3WrU/+VIwPZuE+7AqC1KqomxduUVCpFczv5axy13ZVlcDjqnz8GtLukGUIoYqVEmPFG6IPHjZ9qzUkR9MV5hsAg2hwBXSf6A1cVQD4OGUDV9fHcyq+ZEv/jIKAgr9FLMPOmuzd6G5p6mo/zCowupUEyv/s2mAq9cALezYcOgv1mvpqrh3aVvc7lAwQ6a37O9hRIe/magT9+bnwsTgiKI+L2+r6NgWHXp2qxUzAM44BdJLWITaa7quugnNNdUi5eRxaY3iDwBqsTOrzVhC2PZPALsKcueUhVLAfag3dHmEN9lrxJ5ANNg4D5fIVHriQ7kD1w7tseO8axSyfAUlkoxRn+11ACmxh9rwUzpLoaR1AOhsg5zevpo2CC5StrlVRq813ridf774Xv/5RBvF8rSCPZ5x9Q+lje32g5MhDAW0YugBdme4ehQXnygJXmKyDon0SiR/Sd5l8DkLUZ4uaHFw78UvzY/9iWJfcOcYFv9Q9gHzmdiu3ur9QdMYXmDsZVCeXKjDQJ/rmp4bQUcuMepK4IiWKWA0ylrVPIbila66p6dRvvMkmJ6/Ku0uJqennOpFd9SoAqQq8Px/o3Xnh1l0MNrhRpcKXXQ3wQJEeX1rpE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7aa9043-5c8e-4012-2745-08de56a11d5d
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 14:51:51.6361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 92WKMQLG+YSIs0vWNj5goHPQPtmnNaoy4Y9gEWLiLA3Z+LQw2nU6/tiFGbsThQXmE4dmcxVJ8wWuxaHB1gUTLKa2YUN4+HgC884r78cUzMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180130
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEzMSBTYWx0ZWRfXyQKb5rpR+vtE
 wsUgLytONMN+RijDOfS/d29gQ+G4DHMFHZeq+taUEXAfIvwqL22dzfsTLRUbs9/r9/y5X5vrdiM
 AZLYsdFbBIkCiNRYF0sZsnhm4kbQ3I2KGXY6neACADEqsh0i5O16N9BqHoTXqm5UPMxOwWLzJf3
 g7CBFCZnqWa9wgHMg4fDjGtffcmD5WQCvUdQNoGEk6ajkpYm+XO5MmE5S1UazKdAPHFwrOe/3oq
 rQfZa4Q+HI3A/X28yKDlxAyHxEQzRC4zIQnFFh/yImaxLDhFKsU/y/lRBsCtZi4QEcAHf2qZq5d
 fZ5g1umqfWTlu1yJuLKmGaUG03syy5a1XLTWtplc2EdcIGE9L3IZHezhh3tMySwyeD7sdLmPker
 nNwZ7eKYOFDfGTlCbPqgBJNCVrKYHqKgQbGisgn78wSNCKV36nZ+/FrWvpWOoX20Ny0AwfwFgDT
 FDIRWr+76EJdtwAu7Zw==
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=696cf38b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=QDGw0KozxnkV29ZdokgA:9
X-Proofpoint-ORIG-GUID: az1H-95i2OAo6l_Eey-zXYLMtMGrdFW6
X-Proofpoint-GUID: az1H-95i2OAo6l_Eey-zXYLMtMGrdFW6
X-Rspamd-Queue-Id: 9D755C000D
X-Stat-Signature: r39woyzhrrxjwhde8m3irjxugfhjk1gz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768747920-948515
X-HE-Meta: U2FsdGVkX193Zx1RlJe1jvPaqGRbtuZdpOH20I7RaKXwbP1Z/5TGKJDtnn8ojavXzHAIzDBTwdX/UjA98YvvMRrHTASnvGD9WpMP3mdpPEztXWVLH48jBk8P28S1wM8wQKqFG2+EDbbAQhz1T6f7ewCih7eecoPClCKTqbvNSCxedcIuIYCgCcrcE1vJh4EnNXMB2GHVlWgdHiSIcG2zTWslOny9GQf2CLgBD4YxEvQI12vL5sFTQ+K15QG5Iu5MpxUz+AKtBHKtl5gPeQVIsUxKwI165kaZ2I7sdBD5MvPef7YRjEprJV6awDJB8n5It03Vy355OHJ8fZCWxlhr41jjh+opyiLWRyetoG3HvlEvKZLQwHS+bJG6AyS9wxdeSwDPRQASTIQVhLMddYdN/JqfHB8UKhrM5iutVlfMam6N7WLhx1+zLcnI1QhmWsHE13zt/jviMHxlZ8vaVpPpQXRwNmVCeER/oy+NHwFJk8fNdXFAgk4Fu7ML5CuG1658weySwYAJzIqNFZ7zuOSjfGYIKp+owBQDAEpBCPaoNkuaRGV8jbRP85JkAuM60QbyXqRrZcE1K7XSiHZCXfI1E7mUBqTojfPL1Epl/rmmxZqS4cmzf9zteLjRgJ2vrXlV2Mg9D96aOyyKdtvyXcB74ewlkB58hlJOo4oRNd0mToav+od0FVlyX+ZrRAa/SyynvB8kB+J8xL1SwmY2S7GFSkfrkktwJ1OR1uO+B44TcZ3DTmNI1j+hh5xbgRLM+wK7C4tStYcULPs2dH4YqQ3udh68l5+e4RFe31FDKsn+tqPUtWmPlY/7dvC8IFa3Qliu3U476uB/ini52dnRb33C+wiEFTyzsLM5HlRdyckUhWXgos9XHIXVd1pPe+YiNMUKrTMRTbYxueFp1F91QM2RA6c7e+N0D5pCCbbQV4vDzdyBctXq4VbQ0u06Uf97u84Y08c5Yx2C9p3cA0azDur
 IfZVXpJ/
 V0auhxAtJ7ODPCzzQ8hVlPXGD+jWxjyYiJMJG/TdCrZ1XVEJ73hOfLmzkPKuVn/dh4BwnObAbGKCkShYW/2GJRDwXu06datgSNmJ/wi669jEAhEB/X/asj6U1Zhtvw0p0Z0N6v0SXUMMLg7Fyyx/iOjDR1HHkbGEOOUvUn+IW/l//cS64VHANHR8b/PhtV4rOGtkQBbPeHQ9UAfpgb2YYqLJiAFV0a9bXYQDMvi+CAhcBKydBh0DG4iAEj4X5OUitVL2vYsq1UELWX8gXQCY35zfp7jbDD/NTAJBTTZW3AI4g9jDTr6X54Mwl7PFZB6elXokerQLtKdR8bT1WUziAW0gjjdsp4uwa8TEn/kBC59Pz8rSO4fKghA7EH3lL37Bq7IkRq2r67kcGWw09IQaf1HHlJQGSYRcMvyycDT931nmZgD6FjKRxLuxBYJaN9Jis5HGSf0Tcn50bIfxSI7dVLBMuY1MYGboiiNEJrhfbu/zlfjWRDAkf9YtEIPorfGo734xX2uEqeUBtWrYqfhjItkkdGfiP8q27JNVyGmNWO5grzDys9vj2ZFkCcTPDxqNTEBOGZ0gTlQn5hoFqYrLs5g9H7nY3OC52tSerw1myp2LRusc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The root anon_vma of all anon_vma's linked to a VMA must by definition be
the same - a VMA and all of its descendants/ancestors must exist in the
same CoW chain.

Commit bb4aa39676f7 ("mm: avoid repeated anon_vma lock/unlock sequences in
anon_vma_clone()") introduced paranoid checking of the root anon_vma
remaining the same throughout all AVC's in 2011.

I think 15 years later we can safely assume that this is always the case.

Additionally, since unfaulted VMAs being cloned from or unlinked are
no-op's, we can simply lock the anon_vma's associated with this rather
than doing any specific dance around this.

This removes unnecessary checks and makes it clear that the root anon_vma
is shared between all anon_vma's in a given VMA's anon_vma_chain.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/rmap.c | 51 +++++++++++++++------------------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 8e846ccf7835..d4e41a02a8da 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -232,32 +232,6 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	return -ENOMEM;
 }
 
-/*
- * This is a useful helper function for locking the anon_vma root as
- * we traverse the vma->anon_vma_chain, looping over anon_vma's that
- * have the same vma.
- *
- * Such anon_vma's should have the same root, so you'd expect to see
- * just a single mutex_lock for the whole traversal.
- */
-static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root, struct anon_vma *anon_vma)
-{
-	struct anon_vma *new_root = anon_vma->root;
-	if (new_root != root) {
-		if (WARN_ON_ONCE(root))
-			up_write(&root->rwsem);
-		root = new_root;
-		down_write(&root->rwsem);
-	}
-	return root;
-}
-
-static inline void unlock_anon_vma_root(struct anon_vma *root)
-{
-	if (root)
-		up_write(&root->rwsem);
-}
-
 static void check_anon_vma_clone(struct vm_area_struct *dst,
 				 struct vm_area_struct *src)
 {
@@ -310,26 +284,28 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
 int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	struct anon_vma_chain *avc, *pavc;
-	struct anon_vma *root = NULL;
 
 	check_anon_vma_clone(dst, src);
 
 	if (!src->anon_vma)
 		return 0;
 
+	check_anon_vma_clone(dst, src);
+
+	/* All anon_vma's share the same root. */
+	anon_vma_lock_write(src->anon_vma);
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
 		avc = anon_vma_chain_alloc(GFP_NOWAIT);
 		if (unlikely(!avc)) {
-			unlock_anon_vma_root(root);
-			root = NULL;
+			anon_vma_unlock_write(src->anon_vma);
 			avc = anon_vma_chain_alloc(GFP_KERNEL);
 			if (!avc)
 				goto enomem_failure;
+			anon_vma_lock_write(src->anon_vma);
 		}
 		anon_vma = pavc->anon_vma;
-		root = lock_anon_vma_root(root, anon_vma);
 		anon_vma_chain_link(dst, avc, anon_vma);
 
 		/*
@@ -346,7 +322,8 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 	}
 	if (dst->anon_vma)
 		dst->anon_vma->num_active_vmas++;
-	unlock_anon_vma_root(root);
+
+	anon_vma_unlock_write(src->anon_vma);
 	return 0;
 
  enomem_failure:
@@ -476,17 +453,19 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
 void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-	struct anon_vma *root = NULL;
+	struct anon_vma *active_anon_vma = vma->anon_vma;
 
 	/* Always hold mmap lock, read-lock on unmap possibly. */
 	mmap_assert_locked(vma->vm_mm);
 
 	/* Unfaulted is a no-op. */
-	if (!vma->anon_vma) {
+	if (!active_anon_vma) {
 		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
 		return;
 	}
 
+	anon_vma_lock_write(active_anon_vma);
+
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
 	 * from newest to oldest, ensuring the root anon_vma gets freed last.
@@ -494,7 +473,6 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		root = lock_anon_vma_root(root, anon_vma);
 		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 
 		/*
@@ -510,13 +488,14 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		anon_vma_chain_free(avc);
 	}
 
-	vma->anon_vma->num_active_vmas--;
+	active_anon_vma->num_active_vmas--;
 	/*
 	 * vma would still be needed after unlink, and anon_vma will be prepared
 	 * when handle fault.
 	 */
 	vma->anon_vma = NULL;
-	unlock_anon_vma_root(root);
+	anon_vma_unlock_write(active_anon_vma);
+
 
 	/*
 	 * Iterate the list once more, it now only contains empty and unlinked
-- 
2.52.0


