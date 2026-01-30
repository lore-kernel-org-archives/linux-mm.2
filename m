Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66F71E6BF02
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 11:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2576B00A9; Fri, 30 Jan 2026 06:15:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C5A6B00AB; Fri, 30 Jan 2026 06:15:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B545D6B00AC; Fri, 30 Jan 2026 06:15:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A21FE6B00A9
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:15:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6931113B477
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:15:38 +0000 (UTC)
X-FDA: 84388374756.24.DCD5822
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010041.outbound.protection.outlook.com [40.93.198.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 290AE14000F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:15:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=t5OutorH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.198.41 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769771734; a=rsa-sha256;
	cv=pass;
	b=ILgCgVKDk/P4/KUFi64pF6LtJLRg2WYW9xrwVz0w7h+YcZUw76Ohh2kXAsMd0PwB08mQx0
	7VkvN2B71ALpVcthF33YLm2X4sur4u13IlgCAaWPptxSSqZL1UpONRnhzhQaymKXv69tBR
	IWqs3+mSjdUn12Y+mhnje16mTB0el7U=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=t5OutorH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.198.41 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769771734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cOd2na0yunbUh/HvE3nQ7bJd9gh2MU/muYJwnVokw4=;
	b=RnY4Ur9eT0pO8XIy3R8akb5D11uPMV/ow4tnNoHWy2aVq+jBBDlew643msSjvge6yq8fsM
	19ZDcrPsbS500k61ce1lIUTGtMwFDnN/J09vFQi7sBTHh2vUsQjFWlqlqYQMNuGy43r8la
	3YhcmEYV+m7zOdAEfUQnZAOGYYIVaHo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DkZLXZBP//hIWjjD+EXXSSHFGnM/iOw9or2v3FFEmIem5/knsyI0i6GAg5ZomGU2SN3CfWyBaeiCAEri7/k+62IVHbyLK2lgit6WiGO34vh7OzkYVlfi4PRDAqBG4Qm3b6TvOhAGKHVEBS86kLVDG+QKkoBrN9cOiRPT3jgaZeGY6tAgJRnxlqxkWzQTPEol1Gc1NdnI1daSecv3Hy2O/gZhdJWYKwa74STaqbMIMqljTG3LhTVkgH8E3345jjS0FOCEw8IL/0njAUPGgUIKRs6ec0r/oczg1G6AIv797jGPFDYMcu2zuDHuokb95vF6RCs8NUXFxJVF5DxBwyJaOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0cOd2na0yunbUh/HvE3nQ7bJd9gh2MU/muYJwnVokw4=;
 b=U1U8RD6AgvECyAsfCj9MGBqKDC+8P1LQVjRnVN2VnMIv1uA65n1btABZ4pCp/C+q2ni5o/Ev61bghP9Z/EgQCaubwU+LPCBHOfI6yfe/g8xb0X3iYzz1p6A9pS2ZSkB0GfdIHgn8h6FRDGBNyxLwo4KhQK4C4vRmvE0kUivMb5Y/H4XJL7p3B2e9rCpwDgR7Z14pq1UJZZ2O/82+RcRCsZm5ZFYrnAx+7roOwpgPe6KKkhTfUHYiaXhanUwfk6Z7CnxG17q0dKLz5BLjJrDX7Iwhi42A015mOY7Dx2//0es+m7egIInbv+UG4j2HshXeEjEA3QV9CPGvaT6KHDa4aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cOd2na0yunbUh/HvE3nQ7bJd9gh2MU/muYJwnVokw4=;
 b=t5OutorHZqlXkDu6yPEehlIt7okyHRL8Lb7zxIWVDWHKiqbvTBBtG1W5YrW7H2/l8wWp4fEmcsZUp3lQtfQp0t5TyFsM79IFMKn72xq+ChuRQoz61uyLeAUIskbqcZSFG8QvxQgJ/4cFORAWQ0ien8SFUVpUTQ2SuSDmLMB751kHCwe/pVdMiyi0xbYJt1TLeUmzIS9AYnw6fHxUuSrdTeQ0RecrhMBr1VsCGBXsUEB//1R1BcBRus3BcDbQD/mvcslE2FDBFPl8U+zxbN7y464JpVYkWbrhSCeeIdKVZe3KQjnnPVD8fSLfcAyVYO3A9Jz3m60nta3Z1ULnw9HmMg==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 SN7PR12MB7836.namprd12.prod.outlook.com (2603:10b6:806:34e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.11; Fri, 30 Jan 2026 11:11:27 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 11:11:27 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au
Subject: [PATCH v5 09/13] mm: Begin creating device private migration entries
Date: Fri, 30 Jan 2026 22:10:46 +1100
Message-Id: <20260130111050.53670-10-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260130111050.53670-1-jniethe@nvidia.com>
References: <20260130111050.53670-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0351.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::26) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|SN7PR12MB7836:EE_
X-MS-Office365-Filtering-Correlation-Id: 397b195f-89af-43c8-3966-08de5ff04fd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7/aeLbz4ephuXfiV8vTyvyse4RNm9zRAV7mJr2/shfPyjp2u/bmNyd7krdYw?=
 =?us-ascii?Q?LR/xLoTksTV8tfvQ8r1d5mQYcvGB8HawmN4/a62Lc821kwMpuXbUCi8gzVyP?=
 =?us-ascii?Q?IzwNPAvCO7+l2kniSs/lVc095tKarj61dU3MlQQSv8tE/t04NhpXGzVlW0sK?=
 =?us-ascii?Q?nWss/WPk4be2mhkpJDF62vDI7Uah3EFaXO2NH1cLyyzHyB5uxX7gU5zlLYtP?=
 =?us-ascii?Q?pLX6JfWCRaDinzukVM87QD+JfkOXR3QF64EeuuKWjZz7eHuhOUfdwTzqPamo?=
 =?us-ascii?Q?dVsPyzy478ueCjMHZPt4IVgOdhjJ04SX1czIbGKb60YV/VaWcBd3pLLzgOx9?=
 =?us-ascii?Q?ZtzxkXdo57ciVHy4mqBSp8hrpS6+lSZCEsZWXP4RV5aP3P/n+PdQFiJgckrY?=
 =?us-ascii?Q?buiorU/mDhdhjsdyBW9jcLd3eN6p6cykbtJC4qvnwM+g2YBczrwhS5ARagxz?=
 =?us-ascii?Q?0jNb7nMEx2qNmX7oUsexCLpYPQ6W/RADQyhLjlUeKxL+rpDXdQUrgyLUZ2ik?=
 =?us-ascii?Q?yJfcRJKXjHvlE1gKWW3AbM7lFbBxVLqfWUXdZkDHJZ1G9viHwBPL/NwVX+aM?=
 =?us-ascii?Q?w/MR4pozAz3bGnGXi/bdxq9dZiC/XaWU1BAh1wkXjC6E21vVlQHnMmLeRDwF?=
 =?us-ascii?Q?EgOLAm9iYtKXlB35iiRsMSld5RMxU8Kdhm/jh3D+EcCVC4dZ9a9EAFIWCECh?=
 =?us-ascii?Q?oIm2lIqHdxFRctwLFTJ3Pk3HI4UKIzWrtbduGf/qLeCNEOya5dZ6vG8N9UE+?=
 =?us-ascii?Q?DOnFd9sv22RyIIUV0uxhA3dw6wzzX1JNp2nGD0yJeOsAyZoG8S7X1i2aVy+n?=
 =?us-ascii?Q?FmEA+Eit0Dk837vJoavlO2yn+AMpbZMXs4ntT4euRqOcmhonjLm2hnaYFXMI?=
 =?us-ascii?Q?KV2tjLDsB+7RUgETihvPFW5k72ydd2kOYnJ2hncYE5kcODE5+jB2OwnGjx/R?=
 =?us-ascii?Q?zERtQx2q2ZxhF9VGOiRT7QxADWYEnnMighcZ1aLQoDzTxIML+frrYWnTyey1?=
 =?us-ascii?Q?+OhANv4GPWVGnESd/fp9coOZOZA+/7wXlOWBNnYEnu0OdDjsofIIYeHqnIFN?=
 =?us-ascii?Q?PYmu+ZJg95aVXFVwL5Agt8j7NprXbizU1hkYHncsOAO8OWwLaCJUGvIsJ/uk?=
 =?us-ascii?Q?kMj6x6LmwgMXvSLcPe5T8aMQERStjyF7lG5C0VGgdHnMEc0G/Fw1G1Vcupp3?=
 =?us-ascii?Q?px+WJsdWZX4msFqOPil5dgazaghKgEHYDST8rDYt1PK68ZJK+3E/IUEmb/9H?=
 =?us-ascii?Q?x9PKGs5Ei/PSQ4vJYdTaokoevmiDju1tS5q0a4aCsYvs1SfZxbYCHhIduprz?=
 =?us-ascii?Q?NL9A7JcX18Qy0LDA2CLzmonlbVIBTsm2KSEGfWnDZUo9dkpUxfGAFWZpWphq?=
 =?us-ascii?Q?jNXHMjr4cRYQU4VvLZ3YRnU417v187lOdr0NFkHucYjqHhaOUohhM2CQCwDP?=
 =?us-ascii?Q?LJQU7kHde8JKScRV/Ud+Nct9Li2/Zzi8eU2P34TwPmNuX54Bws6hMimx3wYw?=
 =?us-ascii?Q?3p3d82D8FTcSu+Am+i0oeBVgi6mkEquvWCKgUtVTeARhlYCOZ5TJZE3+g9q0?=
 =?us-ascii?Q?FfYvB2n/TvDiXnleoIk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g9yu401BSI/XYvH02pwexwJsLNDjV2wcKzl2+wlf2vmQ3sM0puX4IYXL5j/K?=
 =?us-ascii?Q?28ppq4FnaQqsFHEDnuWt9GEwAR6QI1CgC92gieXjhlDTehn6XF+7UZ1x30cJ?=
 =?us-ascii?Q?vJr91sSzSdi8E1R7X3QLK0Pl6jb2aB4WrSxJrzuHajz0ndhXBy+ZT8eTMmG8?=
 =?us-ascii?Q?omfRJw4PfCRTnhSEBp4KgHrxsJTAtsJfFHrKokyxYYEPhnopZXAkQKbYc2nm?=
 =?us-ascii?Q?jebCOVL+i4XfBU4O3A/nLF3BkqyKIQ/OKx8LKrXne54Mf7rHYoO0W44NcYyB?=
 =?us-ascii?Q?v/tNkZIJiaYp+tHU1uPTbyJ7H5rg8YrtPrEeLHB+Z4FY7oh+UbC66RX31hXe?=
 =?us-ascii?Q?jDyRqUgmy6HmRPxrH22p5uLwTJHyOm1aQ5jOt3HOjPeDQIbEGgHAiCugLtZk?=
 =?us-ascii?Q?tFRe2JBqbTr6pm3lSQc5mDXNBlo2VV55iOTevTbu1I9Z56TkXSXvDeb7IfqX?=
 =?us-ascii?Q?NLIDB7Sbzjmhx6XjoKTW3TPfdzFP5x8ntZggy2SDeilFCe+OAFJLxe73Af5k?=
 =?us-ascii?Q?WbjHQt2dxT3nNI+tZvRI09lTuxPWbuPUJ6b6m8660arwLTiMvdKoLg9SCjhl?=
 =?us-ascii?Q?fVTWU2BexBC81L8BJCgm0ejM14K/oPPKPCKMio59YiuAwVFW+zWAcb6JFYSE?=
 =?us-ascii?Q?l0zA8YogxXk1/TmBocWOD8f9JnxIw1t01TVnH8py5hpxkF+AxnI33ntDvtik?=
 =?us-ascii?Q?0FIaIK7Aj9vjrpzKuPjNeQ2NuQedB9xKNKHvQgH6VOJhiCED9bpx091hf6it?=
 =?us-ascii?Q?UrmShhKSmVnVM1xsgdiXC7BDf4gYcUzrBrdTsanJn4gC7srD6aNO7LHGo0Vc?=
 =?us-ascii?Q?+NfRLBSH6iJJwLqVTfZVCIRkby+yaLegWC84NnCodIkIbVi+0Bf4V1rs5OOt?=
 =?us-ascii?Q?HJ7pYKpnW8d68leX8XhBWaJeRdNa1BRq213vewXwd2/6sKtbf0nH9Oj7jD+5?=
 =?us-ascii?Q?bRpt23KkMavkVao1HYcqVTs0RBiDJfQUqrXGjGXE/yTtXsy5gODd+zCZiPk7?=
 =?us-ascii?Q?vNhhyhJfEhMD0btdYmBXFEcdJOVdHfIDqNpWW7BOLzdWz8wwj8DAYXibmZl8?=
 =?us-ascii?Q?MVFnVtHrwJ5+clpnlv17N00TBBPXGHUy0fRohEHleDCKGPKygEI710u1cPeV?=
 =?us-ascii?Q?4Bgh8XJeQi+U3fii/Lt0ytSqpaY2gSJgg0HiWNlfkp99I29puVD52CzCdJN0?=
 =?us-ascii?Q?G7Bh3cGCK2KlqpXS9YxM080bQGFec9yg9LKVKZMPrD0x02EF0iDqQxuJUsjW?=
 =?us-ascii?Q?GW1CxkMOIeJZ29KLSQRfRjAoY666gWFCXBW0fyVnRs8rOiZ7SZahyPFMwEOg?=
 =?us-ascii?Q?KUV5SJMpDuCyc9DrUmIPiGH92ym+D5PNdhV29+VKitGpEdC+Er63nxjpcJkh?=
 =?us-ascii?Q?sT3IK5E8pgCmBL92syKFlsTXBnW4DMy3kKP99Tu3LWX1PJnXY1ZWmMOzxnZr?=
 =?us-ascii?Q?4Yq1b3zpTuZGXQd5x3FLMAZhXT3ma2MGnAKQkHlAGnmJDlkqXkNckhFL/RpP?=
 =?us-ascii?Q?nVPKLjQd3+Wp8Gkofjep+Ujl7XQHnrdrcxrbibK6JWZwjPBBjV85TTNn1NRS?=
 =?us-ascii?Q?JdicxXSoAEibHcRWEyt2UxCSJWGxvpS/QS8wmDgVcJOjluUmKeWV+IzLwZmJ?=
 =?us-ascii?Q?jCJxpxdVmQd2KNQIaSAUEie118c28iOq4aql9g8Nhxs2RvKOr3/8GA605IWP?=
 =?us-ascii?Q?au9TxN5FrkAhnzo8xP70O8UTlbQ5RN6zIikqGToOW7ofZZ3FeiXdFemuE73+?=
 =?us-ascii?Q?ndWnezyojA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397b195f-89af-43c8-3966-08de5ff04fd9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 11:11:27.0884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lIhL/uyRlIsGVYrZnS2yxun7Gx7pmtH/cG6C9d2OTHowr+QVls/J7H0y4L//3rlVulO5ZGvYjkqH8diuaWMYUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7836
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 290AE14000F
X-Stat-Signature: eqrziopn78kbzhiadf1idgcjwdemzjoa
X-HE-Tag: 1769771733-448937
X-HE-Meta: U2FsdGVkX1+T61oBN0G4Q1caWvhFZK/HGPlNy4eFCbAbH0Vf9oyp4TbnN7mT6XTunErhGUqGnYd9VSmbosQgEQRTWKc5zQt6zLWIuauN8VTNvfPhvevZi3HAiBKGftnem5KYwGtghJ+JIc/1qsfi/SmMdM84ulzT/1+AqOj93nFPC4TcIegu4NHHx1lM0W1j5t93jk0Z2hxxjvelTudIP7//IJn3AseWAy9l643EAtdcPoIInjbR/7ReX+WWA35S7Ra8vyDxdI+aPiqZ6mJVEdGn8fPilGDQuOp5Sp8Xp2ez8LF0/90I6THUwVynDRCP0X4ZPUohx/uMYE1AxAPGQ+2wZnS7yZKxb1UsW5tpgHsjQ/X+kC8GBsocaMswMCPfsQo9bw6f8WceeUlMdzFyPWpwOkw/no7fp9mvD1M98Hk+rbVWrdlHhWkcZTD1ySBRhhKbq9Mk5zsJ2c0LdvMTAomc+9rmLkdA8XptsRqi2Nh+G03LjhzJkA6gMPoV5IpP2O/n3428tYzSW5Kc0zeSb/vSoO1BUo5KtN1yNF/FCRdpxsHMvz41YDmKnomYFHBl1Mv9ECImwBHcpsatsDTVZFSLeVlXoyPl252/ixDaJOKrHVBq/oiD17fTZtZpXKbaY8SG9OwzkhFR2bbZiL2/CP4hIQVSlg7NbWJLMPjx/m38LdrwEjfdk2E5UoytS53gbEShJKSAryQj0vSlDwBgiqcxal+fVHTzeUblkrGyZbz+kbgJqY1z/w7kLUtQ4NkjnFTp+D82KOjTGNv01rk0emfEZn4Y6SciCrcOHrfKNx6hdUj49TJkY6jKWiWqBtxcxDunctDyhggjBXqXdTEPW1wfF77XWIavkAL1SswBXRKAxAc7LdGRQHxfeU2UbBBFrAwbatl+bpiSWlJ3mjOOpEt6a2oXoCSgGxRjGhyiH47Nnovjp06Xu09B1Wm/g6SvXlIQ4pFj1K8PKj03STZ
 1VQMJBn8
 FHu4C4iaRI+zKekzudRLR7HmvHPjfVXNDBCpV5ogHnWkyJnWQFp0YiGvNA4SqoV+cFNXdqi1VqLoJx2nqtSiPNZ7Dlm09lrlhYJhcy7hQMMY59jWRvbvoR7YOVuDWBmxOCiHWUy7T/rbQZOq84cBYmq2mNeX3qoczPWthMiHOMcU8gTzS1FigQ6lYnFrThLCFCgmepNRUP8WHpGetkmLIotTA5K9IrzfTnSt7354388O9s5njmu1qnVtG1xxwvpW6yfJ5VMZQKaOpx17O0E9X4ffwpc9YInFZWFPAXcLmpyjkqvv1OG131yw3e5EaaDvz4gUeLofnpP5CTtouthjqP2/eIMm2gXvJrT62UM0xwJG9LQHZHYbwP+v0mIRDbwVnzjq+GS/Xdz/EHB0RimiBveAifL5xuFcETOZWFa+j/DHIO6QRUv5x8dazYdSUbPxgxjVZ6SipEcH6BCSSBK6LpL5nvzeSzkea7xFo8jPsG+Aikn7h04KjYqZTHu3Po0/39zFE81CmWwHbfLpvkuA416sAQX6qeNJOIHHx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the migration entry creation helpers to automatically create
device private migration entries when invoked on device private pages.

The corresponding softleaf predicates have already been updated to
expect both migration and device private migration entries.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v3:
  - Provided as an individual patch
---
 include/linux/swapops.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 220627cb7fff..8b39983792ea 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -206,6 +206,10 @@ static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 static inline swp_entry_t make_readable_migration_entry_from_page(struct page *page,
 								  pgoff_t flags)
 {
+	if (is_device_private_page(page))
+		return make_readable_migration_device_private_entry(
+				page_to_pfn(page) | flags);
+
 	return swp_entry(SWP_MIGRATION_READ, page_to_pfn(page) | flags);
 }
 
@@ -217,6 +221,10 @@ static inline swp_entry_t make_readable_exclusive_migration_entry(pgoff_t offset
 static inline swp_entry_t make_readable_exclusive_migration_entry_from_page(struct page *page,
 									    pgoff_t flags)
 {
+	if (is_device_private_page(page))
+		return make_readable_exclusive_migration_device_private_entry(
+				page_to_pfn(page) | flags);
+
 	return swp_entry(SWP_MIGRATION_READ_EXCLUSIVE, page_to_pfn(page) | flags);
 }
 
@@ -228,6 +236,10 @@ static inline swp_entry_t make_writable_migration_entry(pgoff_t offset)
 static inline swp_entry_t make_writable_migration_entry_from_page(struct page *page,
 								  pgoff_t flags)
 {
+	if (is_device_private_page(page))
+		return make_writable_migration_device_private_entry(
+				page_to_pfn(page) | flags);
+
 	return swp_entry(SWP_MIGRATION_WRITE, page_to_pfn(page) | flags);
 }
 
-- 
2.34.1


