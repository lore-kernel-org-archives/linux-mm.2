Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58721D4922D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 15:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D296B0005; Fri, 12 Dec 2025 10:04:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034CB6B0006; Fri, 12 Dec 2025 10:04:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17906B0007; Fri, 12 Dec 2025 10:04:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC8456B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:04:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70948C01C2
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 15:04:08 +0000 (UTC)
X-FDA: 84211139376.19.2B9BFD4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD788160029
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 15:04:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IBHDmaWQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QafMUAW9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765551845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4p3UvjUWoVBkkKJNiHPZBDOsxnRPGWivRg/KIvLxT4=;
	b=S6VhDySMsHCVZ86+QS/VATAkaP5dNpSwV2RZAjQyzkqTSohd7qjsBFCAstvlw72NxWg5qj
	t3R5igm9RfxdAINlltxO5DV7pXbbf6y8rQpt1Lan1piKMBvjPNTtI5NLy7mJcsiNsqFkaa
	RYfIhA5LY4jbAI5n8vHDoAjJ0JKSAwk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765551845; a=rsa-sha256;
	cv=pass;
	b=hGXZgif2OLvXc3zZqiVI27PMImOEYzqgTwhdBwmXYGO+D15XpFl/HRaSVMbxiYkjsHngv8
	oM5rEratZgKZk5NevWnsB1sPzLhcXsECbyluZMg1iWFXStlUX6jR83jvxwQ3ivCi/34OOA
	e6Dk21YREcKnZCyVJ+2pMobkU1ngcng=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IBHDmaWQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QafMUAW9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BC1gYgu2610768;
	Fri, 12 Dec 2025 15:03:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=K4p3UvjUWoVBkkKJNi
	HPZBDOsxnRPGWivRg/KIvLxT4=; b=IBHDmaWQDbGPxm4nOah5CFtH6RoOcX/c48
	byVJPFtOtF5U+v7eXe8NTCJJmHt68vJAIMSYFF5WyiHlK0Z2JGan/2RTpUPDRN9h
	T3h/Q7Douzyrh+RpqEs+IOHuTlJlPLiVm4pS1CjIHuI7a0nZZ60WbgUKFL+/Eu4S
	rnhLbj+9GFAQkr2q08XCXhrmfkzLKrVnOOe1LTYJ8UofRvsyNWyq/zjwFWon3udw
	1OHisK+NoVccn4n4Qx2rPCDaLfhuv4XmrZAzbNPUBA93swvWf6/QsGJvkTLuCnNA
	5lf7ckvr+pStg6VlTpnA3ePWYr01KGZHgqhtxXACL5dZ6wLN9qWQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aycqbbg89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Dec 2025 15:03:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BCDMkYU039819;
	Fri, 12 Dec 2025 15:03:51 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010066.outbound.protection.outlook.com [52.101.61.66])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4avaxpxp31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Dec 2025 15:03:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y/ienq/72tsYDJt87Eg5VPdy/sMX6PndUQwtLWwxed+qPwp44DDgH3UKDFsrikr7YeS/0F4rzjx9Q74mYb6u8LF1qCMux/0/JbiEx3rs8n/L5juXyjduxsb5gGgvoiIh+XutGxI3ZtQSoYOA4JIOcL7+2ijgR+piiAPqX9fALmzhlBGQI2cU2f0TSeaRqA/xN3R1bMFela4/X3stlbalZazLipFjNMCJKL89BkQ7g2MLN3/cfVhbGcrmmpdHpC0MVRu1P0gFyWLW6mT0ibbB1fFhVeBQ+OOyQ1Pa+bRzQTnBvyppsbIBhe8R3I7HLg7kMBqcbhjbTWJPhDR1NegPnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K4p3UvjUWoVBkkKJNiHPZBDOsxnRPGWivRg/KIvLxT4=;
 b=k6o/eCIZ8mVM1DJezkmKqmfbaLEjeBuLhfdA5LwXKZtmJSBnL2wzyFJg1iVfBSa7sMiC03RdDsn5i5MsUvpXkraLsfHaUfgftUGQmRtSzKy26EOedbo+cUseev28dATVGVJtHXP7R35H+CnIR6iYycA34Maiya7zUc9JYc6CLnMX70c61QmAFl2WL4e+LnxWvwv9R2SLACPkHAq5/ZbomhevEoaETMRVxEL8mdXhBhxd6JI31p8JujHukUTlT76ibiYxQr/G5856bqTJD4VsTqxLclazdHDS2DA3qoBsZOwgzOOQBqWDtfCuzlhvEvMO6CJcWJ1HTwI4eoi4boWx8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4p3UvjUWoVBkkKJNiHPZBDOsxnRPGWivRg/KIvLxT4=;
 b=QafMUAW9NG6nDtbcqggwcEXsgEpeeprklMcKYEHCHrSACOjeaG248KeCsvk+opjV/CLu8ItpYmPGJCc9teEzj5syCaCmc4YHiDGuLmzogeOau9ngzoB+9YelaK3bUR96jyjt0P7Q0zjvlMboJAzpz2VxTxxIjLdUE84ZUAwV55A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB6433.namprd10.prod.outlook.com (2603:10b6:510:21c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 15:03:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:03:47 +0000
Date: Fri, 12 Dec 2025 15:03:43 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        David Laight <david.laight.linux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        oliver.sang@intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <9cd62896-f259-45ce-9165-63b74f7c1f6a@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205184342.2cfcc73e@pumpkin>
 <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
 <20251205213449.12bf4819@pumpkin>
 <d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
 <e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local>
 <7006fa60-f4d3-4e7d-8c2b-974e9e4a1224@suse.cz>
 <ek7v5vxht56g77kbojo35eqdcqdmxjvguf3tp5wnfydopbthb2@xie6b7r53ote>
 <CAGudoHHFeuEQ0kBYfrYuUPxNQdw4YHNG81JiHPFHq0evUcEczw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHHFeuEQ0kBYfrYuUPxNQdw4YHNG81JiHPFHq0evUcEczw@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0278.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB6433:EE_
X-MS-Office365-Filtering-Correlation-Id: 3974408f-6bc1-4403-774d-08de398fa6cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hYUKfS1zkmI7SlSxdFZGnZWYg+XSkKGsOH+omLzVHwnNY4vNLsag2WNmCOFk?=
 =?us-ascii?Q?HdS7574sztS49cbJmd9xsZtbcUnfB00RbswS6iQ7V1t7jhiY22woU4CXdGVF?=
 =?us-ascii?Q?lqQgeUOWNepI9cjGlqKO+fRb7+YbId4dMB4r/zIqrlcgnyA5rn3sYgbWhsdf?=
 =?us-ascii?Q?wPadcAXE/K2Vm86rEX5Uct/6AktJlLzirERTz0HYt4j/OzfPRI48nXuz1RnQ?=
 =?us-ascii?Q?/F5R9w6mDoGAYpHjdLxEbdTQUm0N2pa89ozEy5dWP/zAA4I+FHnexi2rogc2?=
 =?us-ascii?Q?kq6nLn4vffxoxsJKvG39w5FotK3lyXxXQ9jB/KD805HOjJU6+qYkMK4fVN0E?=
 =?us-ascii?Q?xffdNU7uHPgeL3G0Us20D6kt6AZCtHNSw1F8fph8SqmXV5MSU4i6ARJB9TVi?=
 =?us-ascii?Q?PmHKJwYVg//qreFmOd4VUSlqVToghckbYBKhZrNSN9dNN87D/HFwbbRUX4yu?=
 =?us-ascii?Q?RL9TN8/xT3WAVewATQM22An5LpsfNV72BzxIl5UJQ4EN1TuXaCt5duK0MqNd?=
 =?us-ascii?Q?xSHH1tvmgyY2mSiZ3YZqmnU20QE2rqUAlI0PI1Ks1pN+RGMMwX1G/uDhyzZ9?=
 =?us-ascii?Q?unqO6+5sV+OndT098kNjU02AadFP82N0iLCeYd4zRH1tcdkZxqPCBCg2t2eE?=
 =?us-ascii?Q?jkr5NrSPl8kiLSkzuh3EWHLry79ZMqjZu3qCCcIuANWSPjguXtG2UNEOq3Dn?=
 =?us-ascii?Q?wrHulUBniocrRP68S2jLLcx50tSIyYAPLV/m6iHSd0G3VCfFTLl7X6o70Srb?=
 =?us-ascii?Q?DD3cHL1s5eBrpnjDMJfWR+KPTx4b6hShDIU2CYvZPSRwjM4fqOyIVrw+La8P?=
 =?us-ascii?Q?8I2ynWv0vs42XemN97P9yjiqOT+TfoEzGg2VbdFO1rnw6N8jviajR6aXu7cW?=
 =?us-ascii?Q?kHyhssIMgvKNk34U9rqD5Hdf6ko+ng6dF3GwOKg20ySjG/NMURvy6DdDMJu1?=
 =?us-ascii?Q?r8sZy3Gu8QfOWkn3qvB6oKpezWsZGzqeki9veAuM9Qk7oFqw+FUtMQrCuY7Q?=
 =?us-ascii?Q?OeYGIPH373+lkfUlPcCPLEKtgj9ee8kQVfWb7wAD8v68pda70XUnfnOdPaPU?=
 =?us-ascii?Q?QGI/kFpfwsST6LLRGCtT1OvjGyQSOMQxOZUIAWdIN4xrZJg3F7i33QVV/MyM?=
 =?us-ascii?Q?Qrrbro+4DdUYjbo1Nn5PQz9pRuMqVez+++nVSfx5nFzcI8kmvn5rlLqqzKeb?=
 =?us-ascii?Q?BNAfp0WH2fdxyAMo4dBSiORsQdiiHyfjO3H7XmHg4VBwrG6D4yZz3yYypZdY?=
 =?us-ascii?Q?c6cLgCFJ7bnoNeJwDijHYUJAUo8bHQEx2ckjFMywaoi3iWUFKk3xprlqClhj?=
 =?us-ascii?Q?XFKRyXjlK1EI/e6eOLboJmneLahUcd6GIqW30dt/iBy7QjzeQ3GB/f6rQB7R?=
 =?us-ascii?Q?tWXgX4aYeoZdVidW+DLTHAuTQJA5HwDDYa72d8xpxEtH3i05wGX/dBboTZkh?=
 =?us-ascii?Q?h7mmWlq7MIsS/ikuIVXgbTH56Z+laTXYGxH9mU/mhOosOaghery7kQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n/ndhk15FJh5a0Hnr2ZKewmRo0Hl661KxUMXuoapThX8JnWBA7l/yU9DYR70?=
 =?us-ascii?Q?+d7EQOLKyelALLXhD6dngC9euKken3aMZ7dcJ5BaA5QG0tA+wsB0qN0k6aq4?=
 =?us-ascii?Q?TE+qA8NI/0lwOHDqjiB2HzfZAe7BZKUsiRlKkVobYRmSbWT1hZoWdexdel8w?=
 =?us-ascii?Q?zUpiXELkX0PWl4xQP1585+oXMzVCzV14a05KLncxRxlTY1jG4D3EC81v141M?=
 =?us-ascii?Q?0WlVrNH+li9+ZsaGNh4st33DpyP+8N8EVTQpI1jenNxDuXZcOso8fH12odfd?=
 =?us-ascii?Q?jEYjZdpHgwYkn1f9+mo2gJq56JIUX8TiS6M+QlqLN3v8/OcNjw9KXwUgr/H5?=
 =?us-ascii?Q?2Pe2y7TptFfvM304KfXrqoBusKbfgGrIdzF06M6XWvPdQkkiKCpWmy9Kx9bX?=
 =?us-ascii?Q?eB7On4YNhie6sgTjUVEuYAG0iGnbFIw1y0qpq2SB5X86w6Yvg9WBEIGmo+Uh?=
 =?us-ascii?Q?T/fKKD7uO5LLsE0SFZjuAsuJyHBv9UR4WU73G4Jfd9q+UNdhmrR3+540qQSu?=
 =?us-ascii?Q?vqR/ToWgGgu6HU1qNhaK7lVPCbavHwgAxyV0vzndyTsAg8ZrKR/xDj95cmCv?=
 =?us-ascii?Q?bFPvj355vXAkAVePR1ZazAMjLgAqpe4fbXPzeCxUXu0W71LSJqjItYqnEJ86?=
 =?us-ascii?Q?tWTRqd3JXRETQ78/YF+cKKhSAyqbwZjjHkN2s+yaKeXf+VTLwnGo0aE1+UOF?=
 =?us-ascii?Q?fFdFy0rpi/YiYtqPpbhbaI33K0Ejnfkpz6B3fQ1Efw25Xpc4whh+9TJ1Ptm3?=
 =?us-ascii?Q?TAS836IRGlQnPbhebuvjKgRoeTXta3Gd85czEZSmLzCkbeAaNYv4l0E27BKF?=
 =?us-ascii?Q?we1f7SkmdDuCPIE8i+ORHev785SCuNdLOt8y2tjOl8+QTNhoEj8e198vfE36?=
 =?us-ascii?Q?GV30Zqa2x+5bnbGE0gSEK/RNOZMmHKgyxs3w7FOhQS3AOG+vyDkqILB+twPX?=
 =?us-ascii?Q?XD53dZyjTWl+9jXi2CMh4oQQ/0WsePejg8UDD2gQk0Xjfcm6k3iwCZn5VAi8?=
 =?us-ascii?Q?665zKKhaTkCntHUjF5Xc7U3gk9g0rkSw6Fm5hmehDlwqtuE8Y+PhMhGo/WNE?=
 =?us-ascii?Q?UPyesAEfUWMlzMegRQdOX9zC/QxyaKpfu/pwWrTw/vz8R9QjaCw5BX/jwqoG?=
 =?us-ascii?Q?OXRrTx48akKL2LsdtV8p8Sls0H4vpyq8AMv6OlnPM1KwttTdgOJY90780ykg?=
 =?us-ascii?Q?Xe62rfOCKNyPA8Ms4CyTkih0qRv6dSoD2/00/DxVc4G8VBDW2vk6By6X8Co9?=
 =?us-ascii?Q?Tc+21YfktsRoX1TwCfpmnN5XiuqUPsUr1loZmjE25V5MXrwNNT/mUtGH99uv?=
 =?us-ascii?Q?eXjepE8KIZd9ck/2m0ROzYwOPWaHYLnkZXqGlEapK4vlOdazhe7V0FZBc9uA?=
 =?us-ascii?Q?saVVV8NddrbcZbclSdBBgtv6phmX0p1yBeI+AGXKjlAaWpVFCZ+bwzZPOcip?=
 =?us-ascii?Q?sUnBsN24fd/oAaPq7zYWIHFpfCs13mtUcLOI+WVwpNFkRco+FinNC9/6Q+wj?=
 =?us-ascii?Q?jsi1WZmLf6R8WAyyYWyyf+bCaALDSXZOJs2o22lnOFM5VoPGcNVqwaj0SJkL?=
 =?us-ascii?Q?dQ91YMEkHYnhmKPaWjfqNr2S6ZE13pe4Zs85cYBeMLIgxCCGvnd27hzr4pV4?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vQLJLdPe5eUFV5B/opDBjK0XkRU9VjfCpIpnPgS4dFlgm1noPMAs1Rcjzu60dQII02PY0nvUEL//fOzSOfO2nmWqLwUHa7CVBleJCJJWV3U1iy8+Eq+eO/oKP4+YXWf/xJkVo/1Ugahpmuu3LQieL+Up3ykClajn7WpazIZrtj/6L8NKD49rvqNUlgnMbNlb1lBRZqdbQqZd5Iy2lc/6JzJB395h5LcuTD/EBkcfnhU84aD54CBuSPswFcSPObtf9hQGOBfb1typc6U8vUtZOQQk7FR9LbFUygrKxNnQPOg5WMXd31/VMrs88461in1/ixgyMGMfUYToRWmeUdaSVp/KGt4CWLK7KK63v1IAZLXzx3QoPblqzsDxvFKuH5fgOfjCWPHYVDxTl2A4HM225qL/DHjbdreIS5/e+50WGIThHn8kvv9bd3pOA3/MimYn6VZ4kqq0rwZSpZWKAx3jMat62zE+lXX3Be9QhGtr5/baSrRtIWAhkO4X47mCdFhpN/juWXT2PtI2RF8oSQu6jvdzrH/rC55/d6PrPtJbwQucksHa1jcusVZd2MVsRKqmMayse4szA9BqCabz1fo9TR2NUOXuCRJwMXQ+I6ak848=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3974408f-6bc1-4403-774d-08de398fa6cb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:03:47.6463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R+IoYi5t+hZ2+ra1/dT8amKeylU1ldAflyRMVgWy0KMVt9aKnq3oARjGnWBMBMsthi7LWcGO0ZG/To6yAYuZYsM6iKm9cRzPBXgWszJiRhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-12_04,2025-12-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512120119
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEyMDExOSBTYWx0ZWRfX3ZKQ9OAFcZVW
 oXNZKNtphpinF0VA/Xe3IvVGS1CWkj+4Yivk26Bp3y9UppzU4rWiOXTK7NBR+ilkspytebu/vF+
 7wq6vqz5wQcsvVyEzHTgKdArXLlMGLP9RSd0RcHIlf6Y8SJZKPZ67jExYg4Yzs3miTolYbjvGM0
 86GTf45QuUiGdZkcsgTIF3M0tZL9/IK7Crvf07nhrmOswAo23/mLjyjAAALz06sFSpvJ5HfyUZa
 mABcYJV3JWLHcdBldAIEogIFmnyz+ap41O4ejAjL7Gsw3gBxsscPh3hCNIN86zYTlGdknr2QJC9
 Qz+UH7pXVDA6UC7kRe1NaHq/0A3s04ysrwmhue9lPKH8hABcwJgFgo0an7feJialOeUu61NKUZK
 BFn4aZ42sQoaQB7Dhzg/28Vm7dTiiB3FQiEERRlwZoPdQEoXuYQ=
X-Authority-Analysis: v=2.4 cv=R8UO2NRX c=1 sm=1 tr=0 ts=693c2ed9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=mDV3o1hIAAAA:8 a=4tpNJWd2qk7mAq3V1E0A:9 a=CjuIK1q_8ugA:10 a=WUgAeXuMlXEA:10
 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: aNgxFdsQK7C3fjto5gcADTjaJhxUE6aM
X-Proofpoint-GUID: aNgxFdsQK7C3fjto5gcADTjaJhxUE6aM
X-Stat-Signature: 15gywoq9mg1iz53jrrjwyob3yd1uhahx
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD788160029
X-Rspam-User: 
X-HE-Tag: 1765551844-527283
X-HE-Meta: U2FsdGVkX18a9Dx9Rt/VmhsvwPhHr3GIqd4Fmfjkgnga0MogRmGagE5kzRsVBXDtk/vCcCA5713D4bmLg+6YIhHTLGbmtTWYpsELE8bHVhik9iuwJIeZlG+7a3kr4RSkoJUkZxps4lyeIAcHOhMtcHmvgVN4Uas85UDzzY7g+Bi+20KcNHHHt4cIYS6k3yy9+uUuNLo2MWJX3ZF1iHSbw7WSxkHHBxQTdTUupi/rqXdSy8HQHpRymNgcb4/Qhro606DqImZNZ2om6Y+3+HbvJGtkLhJM8hcw5b9HtgiTzAKom1WvMdnwD8+OOl4gKyc8m4r5ENcbjGjZ/cS5RnR+6s0htj8UMEwXZF3wAX9wOykpai8MY67Q4jicn/4FkXP05NZ09hALODNuc+pXHOtD9W0i9o7Dja+utvyoRCOr0mdW/miTsTFAkm7gcx2jD5abY5Mz2XHcMUX7BZLCfzOAv4F6/YkpyKQESG+eg+XQMGizjqn8yBOVJ0HLMnK4MyuvDBC9XtbSHp3phO7McGnR9YFlIK/H15sKQEWdJ281aQt1Zgu+21q+qEwxBkk/vDOgkYPh3H0SeyPwG39t9TpgVHacpB26Uv2uR8auqStsYfZO64kgfyxWBktUe2qbyBK31PwXFO5QUKNT7mym3bTl/V0LZG/h4BIL/fh7d6y+8iYBosou75AQ+fZxilVCvMHkwLq1v1DoRlfu3RlxEREtzjo+0IO2dPc4BejhkcnqUImPG96RmXFK11iTpfdpMAT1S8IVCB1M2Vg/+/EeUhrBGrkEj+S+9pj0b5IP1swC7Frcpoy34e78FBsmUxkuuQXMYlswiv4tkrJzK+xQe9sJ/A1Ni6NR94swb4D37o9cXD5KJ2X7BuxQ7NYL4+ZquOazLQtiH+iyP9cf4jH8oIpxmdpVTkKJHVa6/nhhilHXJRg8tBrRGStYQaCesVFiX81W8noLb4M8C+6DJDZwC4F
 zHtv/i4/
 PourqZ+zxcttru+TqZz9JgrS2V/Y2Mz171+gfkkq9ExSooNGtB1IyqIdY3dd5GsZyCko/uAX7+YgTNIRwBcUmOFBoA+YNsR2SnGoTHtrOkBUlTl8v+MOcjO49oYVo/QrJsrOtsREYeqkQD6G5DDwgeJwRJHGoWcEKgXYXqkjbx+MOyIi6NTDhjoAZpb5pBpLj7ixMdlz9MjDwz3EtWztyL1XzOD/TFk5NK76kP0XhDujtG30iZlH1TEdMaFYNKvM3/RYMl3uq55ZWtSBhsWTTreQwDYdX848u45XafL/RA6dPXuCcpwGzh+YM4RKyI3RqxXDMvOruBPUg5wSBRk+OrXq/Vrbb04EbjqJ1hIwQATQRnjJkbjT3MkdaM/ugHNNz5+8F18GY9uHh8gebZfhqIchs4ebTg1X0NDcA3sDfjb45DUua1g4JyL178F37iidqsPNRgTmYuG0h+GDdZj+HRz9TpWZgXYCA/EtwIuRZ0duXMzyrmhICfsGjMiqmg3a3vHRwQelD1IdrU0McblNHNTGyDDSHEeEMM3UwwxL71Fy6QTRHQtXuQWSm+fiOGbCI73FD9GFxsN6WKL6brvJyO9HH18iqW3kn0ddIqR6mwA4l85NH8tv5i28yvaHjuqUbZTXxGx0c17SBaopfkxsH8bqWA8T0hZHBUMmdgge+AZGPAdwKxkEQ72N3WxIMogCiYEBOPkJt5QMQNCA6Cg9n6l2/FFz4aP/oF8zwBFHjXU+fb14=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 01:24:57PM +0100, Mateusz Guzik wrote:
> So I had a look where the timing difference is coming from and I think
> I have the answer: init_ipc_ns does not have a guaranteed cacheline
> placement and things get moved around with the patch.
>
> On my kernels (nm vmlinux-newbits | sort -nk 1 | less)
>
> before:
> ffffffff839ffb60 T init_ipc_ns
> ffffffff83a00020 t event_exit__msgrcv
>
> after:
> ffffffff839ffbc0 T init_ipc_ns
> ffffffff83a00080 t event_exit__msgrcv
>
> This is the pervasive problem of vars from all .o files placed
> adjacent to each other, meaning changes in one .o file result in
> offsets changing in other files and then you get performance
> fluctuations as not-explicitly-padded variables share (or no longer
> share) cachelines.
>
> I brought this up a year ago elsewhere:
> https://gcc.gnu.org/pipermail/gcc/2024-October/245004.html
>
> maybe i should pick it up again and see it through
>
> as for the thing at hand, someone(tm) will want to make sure the
> namespace is cacheline aligned and possibly pad its own internals
> afterwards. Personally I can't be bothered.

Thanks! Looking it seems we accumulate a bunch of offsets in:

	print_fmt_dax_pte_fault_class
	print_fmt_dax_pmd_load_hole_class
	print_fmt_dax_pmd_fault_class

(entries that the bloat-o-meter confirms changed in size)

That continue on to eventually offset init_ipc_ns.

It actually looked in my testing like performance _improved_ with the change,
and I notice locally I end up aligned on the struct:

ffffffff82be16a0 T init_ipc_ns

->

ffffffff82be1700 T init_ipc_ns

Examining stress-ng before 2b6a3f061f11:

Command is:
$ stress-ng --timeout 60 --times --verify --metrics --no-rand-seed --msg $(nproc)

Results:

stress-ng: metrc: [1662] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max

stress-ng: metrc: [776] msg           964459758     60.00    154.63    632.77  16073484.12     1224879.38        21.17          2132

After 2b6a3f061f11:

stress-ng: metrc: [782] msg           1326214608     60.00    194.19    713.34  22102974.72     1461348.11        24.40          2140

And if I simply do:

 ipc/msgutil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index 7a03f6d03de3..df0d7a067bcf 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -26,7 +26,7 @@ DEFINE_SPINLOCK(mq_lock);
  * compiled when either CONFIG_SYSVIPC and CONFIG_POSIX_MQUEUE
  * and not CONFIG_IPC_NS.
  */
-struct ipc_namespace init_ipc_ns = {
+struct ipc_namespace init_ipc_ns ____cacheline_aligned_in_smp = {
 	.ns.__ns_ref = REFCOUNT_INIT(1),
 	.user_ns = &init_user_ns,
 	.ns.inum = ns_init_inum(&init_ipc_ns),
--
2.52.0

We observe:

stress-ng: metrc: [764] msg           1321700290     60.00    196.73    723.82  22028700.93     1435779.72        24.75          2116 aligned

So this really _does_ look like an alignment issue.

So I think I should just submit the above patch right? Can you see how it behaves for you?

Cheers, Lorenzo

