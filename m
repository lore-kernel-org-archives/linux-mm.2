Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AF41CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCC888E0013; Wed, 22 Oct 2025 16:32:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4088E0002; Wed, 22 Oct 2025 16:32:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93008E0013; Wed, 22 Oct 2025 16:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B66D08E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:32:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72A59C092A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:32:25 +0000 (UTC)
X-FDA: 84026897850.16.1604EE2
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012013.outbound.protection.outlook.com [52.101.53.13])
	by imf08.hostedemail.com (Postfix) with ESMTP id C021C16000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:32:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="sOJtiq5/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761165142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6p5FN+m3ZLp9cFO89SiSlg59v6EOhnjgYgCGcsHrT1I=;
	b=QAKfTMbnCaZKovACPAigwNPSpfjISMF9KSbe0Uspo/1STY9v+gePc7lSEVum1Id9+6Hgt1
	15PFz1jNgIX6ww+9hqYPEqPmHzSJrzXi5aCpPgDjGIa9hSs1s0LpqC6bnV8V2pQZCRKH6F
	ezdsYS5Je/xzULAs0uLWzUryCe5jWrs=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="sOJtiq5/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761165142; a=rsa-sha256;
	cv=pass;
	b=2Mq4+tRQwNepSL6marvwzwOSAXoS8LMCoG8HORelr6fXfSFYdchFZ9U6Lhuw95b78aePG9
	IcAC2x18PGB1r6zHLIn+B80rrWhxo4xkjeLJuYeDNjprTVov6IKdSKUkiiIIFq1JQstlLG
	22UdwVCeDTtcsopc5UcAlahaHHPdJqY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U31NCLh1LB3/BsJ7dUBU4WvNVTDpPOF61TWlVmQuzQT/GNl4p/d9Qbz+vkpFjw76snjKEXJdYpbhMPggPqyMDvMMGM2xcEYtQA1KLJMN78yA/VyeZkD1NwMvT75LmGn3oUZd0/Bf4qciPUpJKsM7lRsVXsG3CsivVGkM8h0ixFEhzevzYBJ6fGewQvNL8MnhKYUKFl+QPVTEMMhsM+QrTLQqEuvatUzobpMkNbks2MjtBVhePLE6EVdprNxTFYl7bMu0m4yU60RR2j+z9rTpTfwfCZY2ksc8ItWFIgZtfuH+GTF1TmGDN/XozkQWFLJ0O7p/wKTFbbGkySb28ucb3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6p5FN+m3ZLp9cFO89SiSlg59v6EOhnjgYgCGcsHrT1I=;
 b=iA7pz9SE7nME2FM4k1Dz3fEzE3JJuptfUT0WKGtVxJS4hkXqtXKws7fqIIIfOpumXTmfNhx4Oo0Sc4rZFXvsUNB3jNSztz725aCx0YZ2qAlJXR8gJg/a4myQj8TFUNTxYcglcyVzkIdXLN7sshDB1NWNxeVyifFFwUC45/ASkHmevGT45W2spSeVUK0PeP66mplLdQT0ZgQLdpPp+9KY80r8FPXnovNofNXttOXhCCpk4Hlgil7lM3AVlgYigBGQtLxyVDQv9ozJg7R4trS3YBFiiyehGi+AqS9T46JZlkUWy7SwN3M2prxawWRvFTzUicma6qau5AOmRcFXDenqdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6p5FN+m3ZLp9cFO89SiSlg59v6EOhnjgYgCGcsHrT1I=;
 b=sOJtiq5/KngZ7X3n/6wmH1wsNbdltp+Cr4CSsfb8q5RhzEVzHe+QyaikLdtaOsYrhgTxR8q6P35BXF21SSQGrE2Jz7LtGOAh09JdpGPAvEn76E70KZyYnjlbrYKv3cpMUMfVOofyBohiCjZSwvPrf7JjvNzEc3s/CLrSN75vosQKoXjzXingSM53qUjNm18SprNQwHHfYyq9Mim6E05I13GVLKwFlp00YQGzaWZGD/nyCF7PbJ7qbxrDGLZyVZRVNFKHJprO5LyhA9FUEo21d8aO5KaCq4wCRKR8Dg1FhQk+wp+iq7X1V4+yY2VMobjKTka9Q+j1LKVkngzE1L/FcQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA4PR12MB9764.namprd12.prod.outlook.com (2603:10b6:208:5d0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.12; Wed, 22 Oct 2025 20:32:19 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 20:32:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v3 3/4] mm/huge_memory: optimize and simplify folio stat
 update after split
Date: Wed, 22 Oct 2025 16:32:17 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <D3B9824D-1439-4606-B7CC-CDADF570DBCB@nvidia.com>
In-Reply-To: <20251021212142.25766-4-richard.weiyang@gmail.com>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-4-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:208:236::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA4PR12MB9764:EE_
X-MS-Office365-Filtering-Correlation-Id: e05aee18-1f65-4d31-610e-08de11aa1916
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ob4QqDkG42YTkpv/yeX3zG4d5mTnY2le4jgHuxBupBgdF2R+hij2yVbw9yAI?=
 =?us-ascii?Q?eMxHvpwx07WnprigizZPdkzKoEM8uHY9GfpjUhkvWrqYv/3HhYpuZ+shM9BL?=
 =?us-ascii?Q?240drAvqViOHc9H9KkAB4/tzhX+B24jmv1U4DMmgQO0lg1JH3NZMFjwUrUZZ?=
 =?us-ascii?Q?xBMNPaVDilMoxptpUlEwwB+fOveCiRKKS7TnnKhHmjdGFjGyjzxE6bzHif19?=
 =?us-ascii?Q?ADIlnoTCPSPpxMBiosfs6ZxB/vH7NHrz7X+2gKy8zlIHYXWArUU8LTjddejV?=
 =?us-ascii?Q?BIfxmkubxz58fHOhj1N7SuBiniMQb+Yroo1VRJeRyXeDUWFoCtIGV1KcFrAF?=
 =?us-ascii?Q?7yYq4e1pcmETPDKY0qfw0uQRYeLp4/p9xLXAXO4YzBBElrFVyRr1eX0DtFS+?=
 =?us-ascii?Q?6FPsMz1FHMzoYeV9JlqNkT4xXIMeHZSW+hHvKDaCHXi/Xueg766uquGFqwis?=
 =?us-ascii?Q?xXFpC4mfGg29jKuL7dxdhVq6T8VwqMRX/RWLWf6gFfC1B3GqdRqoMdBYV8AF?=
 =?us-ascii?Q?yQjAbVB36pBxbOXS6g9dtP8fX094Ci+Sj0lFTZ4AXaHv61chOFK0jNNBh+ed?=
 =?us-ascii?Q?FaM3VfNWaWlHh1pxSWp3OnOBDBpKYVMzdWOIbYGAiXD0mUykXFFQTNX08Bv5?=
 =?us-ascii?Q?jKJHp2fmiju53WJOikj2usZS2uijK8+qmTEips+akCkGxK7TZxzpxsioJE5A?=
 =?us-ascii?Q?c3HiMU6+bF23W3E0PaBreB6EOTRvRIW2A3gyH/MzNBYxw1Thl7bSXCUofi/m?=
 =?us-ascii?Q?MMNjm/lUFRJlab8xx3ULgucJjAKK6tCTJWz+uHfagBVTWpizyuyZjGo8Ukya?=
 =?us-ascii?Q?KRp+6tinqHXygUvbk+7sFO+Gqlid9prhaihzYb8AL5PcMLGDFJf9zJsijdu2?=
 =?us-ascii?Q?0NTLLa/ky3k/p4sYENV3hiVWs+SDNRBxp1B4MixJWn9sFgCT1KbIctOL/+fg?=
 =?us-ascii?Q?V9FhIX+PiTr3N+LEsklqb884cuZ8RF0s5Kaz7gD+39pLnLlLSKZOaDe4ueXj?=
 =?us-ascii?Q?E3tyADLvTS0VoajCKTRldKgk9DfCWsGSDCKHSUKBNw313aFI82hgxH8gi9HH?=
 =?us-ascii?Q?6AuvEAYZ/Y2ouAxVRftk8lvuT/Th+JwcRGVDG/LCGevmWOoMdPr6hAtWHeze?=
 =?us-ascii?Q?Q8JDhTZ36CTxphfajvrTkmmk2rtryIYmf4cH100f5X8Q35J4Pf9T+pHYlCZo?=
 =?us-ascii?Q?Kumk/LgdjGGFYwrbkBmbZEr7NqrBaYBHDyUxETkwM9dEW0mK+HGcnd9VkJOp?=
 =?us-ascii?Q?b8Vv0PMEnLnVWK1yhSu58tYr/4H1E2UP/Dz0n6WlOAYuLMiFK+1RDQ7axOGJ?=
 =?us-ascii?Q?771xXBOT126ZgBJLlRIPcKuu6x+v2zoLviZC6+yZzGi4fO3t6QzXFnf4267n?=
 =?us-ascii?Q?egFHFLd4bJg1GRgLzNPUMeOg4k+T++IyN0BOuhQCyVRP8PF174tjHrRtHxWZ?=
 =?us-ascii?Q?/bOd3Ndkgad5rDrn8i5rapQfYbA7zg/u?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ykM3NsOz6kOBEzGPMQBVzVRWKUxkmyW61U4fY5kxm0CShrBB4iMlElYHv/m5?=
 =?us-ascii?Q?wdnuplLCqyYi9l3lAH7wB+pG1Ujl0m/M/uW0ufDLOUeapakY0ZOmrHDcgi3M?=
 =?us-ascii?Q?b7lKH6BTRbGcMns9rPLkDSmKy48LttPMGynDfccFrtfSzV6ybEqcuAD+dpco?=
 =?us-ascii?Q?PNod+x6nFob4u1Y1UvdQ96OWrIFHF5CsAYnmooIjpiHPgqRI4XJ2ZpwPLnIO?=
 =?us-ascii?Q?iUSGevk1J7BkWkgJ9Ccitaq/WmmF4Js5ImTfyLmpzswjjnCYW5Gu0cmS6QpR?=
 =?us-ascii?Q?PLbhpRBKk2WS9JTMu4Ycp1EduHpKhZqpJ/6sB7BSPqE1z9RVNYCSXmHPH9+G?=
 =?us-ascii?Q?158trpfdLDjAnNlxqdIUtLCIHQ2yBhBfnvnKrIgatgKmIMMj3JRDmiv1/u3X?=
 =?us-ascii?Q?EiR3cLTXq7al4tGs+2waoIzwgzWSmvWaGJFrC8BV5HzGFAqh9ITrkjJNdPil?=
 =?us-ascii?Q?iS73tTzwtMs2Si9M+HUyDEAEWHzScaybN/55csyUnIl7N0WpwjMNOx7VWfY1?=
 =?us-ascii?Q?YWPxatKNuw2DrbVu/BekZ0ZJgD8qk+oVpnR4tpRWJHkWbMgVzR6u2mlnWvno?=
 =?us-ascii?Q?zTK7AODghTykaGECD5RCfnLZEBTNth96imfmQYmmpj87huxfOJfykJwHpvqf?=
 =?us-ascii?Q?xmWtaahk52QKba6ihCWItw+Q8fkBDccd6rszEFQ52MXb0aJMSp1L1htrFuqD?=
 =?us-ascii?Q?kPUJTrv+oyOcNYbb1pyRy6IwFylzHb7IvXyCwCiFRqtp12F4BT3WdFKHW5Nj?=
 =?us-ascii?Q?ka/0sXJVGJEH5By+FqFSRdZH3wOJm7WTl1Lxj8P59eu5b7KgPOcri2pIJ1ZW?=
 =?us-ascii?Q?vCdBKOQ8ET3E0RVFN3Z0yZjUvEHOWjC7PWCRzDPAbcE0BrmhtCl+VwWYMWa3?=
 =?us-ascii?Q?VO4E4bdRylo/mMVt8T/WXMOFGw21pm3vTtDehFBXsSamIMjU8BVwUqI6kCRn?=
 =?us-ascii?Q?psrU0MIx8tT2kV1k4QObJmjFBsU8ereXD/ESAJAixbgFZQ4EhZF24tZsessC?=
 =?us-ascii?Q?1afV4qPKiF2tAuLYiuVUsuVV1dG9fdaBEiyUM8gN//Tt4lMj78DO3nuvud1A?=
 =?us-ascii?Q?Q/mICnJs0Nl4dcp2t3OCItkcupjCzNoJpwYLTg97tb/ceHW8Ue4wip1zmuaH?=
 =?us-ascii?Q?awKGJbPPBFDhG/cOlhKcQINyBmzZa9AjnS5rQdmE68ucJhF2I9hOO7st3hKs?=
 =?us-ascii?Q?DAvSc1thcJ771C2oIt1PTz2RWFCypuwXBeQ0NvbNHloeGt2uMnz+aZrrxAHw?=
 =?us-ascii?Q?xKSNVckt5B0rqhiiHO6reN3hzts9uOTz6QG8XZmhhhSnmIDl51gLhWKdI2+O?=
 =?us-ascii?Q?QfPJYiCp7ewLdf6f29+GV3ZBDzpguiIQ/j3a4wKc4QSHG+nEbw5nY61f8z7f?=
 =?us-ascii?Q?TDHwm8y+GB8z6CuVE/RMygiLFlv1R+Do1eOqC1lgLK9cqP3tRrexKa8mH3bY?=
 =?us-ascii?Q?xQE50Dzo8Bh0ggwPiGoVY+RliWMi+HWa1qp5suUhi7bDF5tb1cknQV1xiGmy?=
 =?us-ascii?Q?YzLaJrVWLkJ0d7cfgP1738XBVZQkL0OhsVz6M9ZRkylSal0HIfkvuXNqVlJp?=
 =?us-ascii?Q?HoSsfquxtIeQTneVV3jK+C1xfRxdzHA2innridW+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e05aee18-1f65-4d31-610e-08de11aa1916
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 20:32:19.7654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: joWzbLLAORPfFE21v2LuTlqRJKU7stA6o4BKmSi8yji08xm3Xj5LM0PCgW5BHtYT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9764
X-Rspam-User: 
X-Rspamd-Queue-Id: C021C16000F
X-Rspamd-Server: rspam03
X-Stat-Signature: 78e9jqsu7jidmxzhwfxjz9h855iffnp9
X-HE-Tag: 1761165142-769852
X-HE-Meta: U2FsdGVkX19mdIkJ+FlZPMBa/744zcahiDu0VJrOKZMa1VbzghVKNNonX+RvkO4djbHXclqsKwaiOM0q37BUUOEaVMfhhq3v5kvRL0EhR6YMJZWT+1ljvvAB8Xr6IZ4JZ0aOIdTpkZyBiv4e/QWl2dJywzhvoKFYp5sMjdwVM9dNj70nShMmBnQO5WHmNY0eh5c5mGdo681K0Z9PIS9ftwV5x9nYiODTl6CO+Ww+Wt8ql2uiXb/ZX20Qz01LAHdzZCLJ3H9dOj9rtil/WCV2BSqdZWSC+IS9YL7vpaMS3VH4JK2Ja6CrTSa7QdSu1se6TMO/IPqcWJMBTFMllWIsU4yVIhs+j2hEJzndcEs9AANtZPuus8r4Vj9swdHMMx8WfVNrvIwLhsLWG95cvrqUwIJ78Kpsryrj7Rr5jK58dm/a8md8AQ/HtekwUfMLYt2s5uokrijsX+Y5V1K4kuXlUiJhdWueM6otup4LHW6yYU9Glyxrj8suaKOV0Oo/PYBRVSqVgUk89P58E150JffhGaAxTFElfpDrHQZPE7QpxaEAP3/32Jk8In0eRf7tkNZL6kR4Il32MwEgFWcyCqjQgom9eUFb3vWj7TIx1WzTfKkHAx4sOshky/Afr9eXUSoiYbM66Gcb8A5xAodQzz+/BjrNkQi7oBQ6qAwBYxUCh1vlIXQor2afx8a/yCpDsEJL13OTBKlgG+KKgTMDfStcaQdNF7DddGS/5hSSSAaGOIHijsIVzEC7B+lZdPmkWlP7LAci5WmPvbn3Ou6HbnUfEe8hEhhZU3UqG9WlpGRdncbMRj7Msx6CIaDwId7+ltp8rO+91giB84QQ4HRDdHTfX1MHoeU80EPa94mDNj2xZ3j/g63/2KYOLJFDm8z/2OljDRigCLzRfF9XDJBEbfSxQ78Wx3JHuQop6bcqrkE+PvKFz2uiprj0gZtamCD+O+mZBPZzLw255rm7J3lCymO
 8XrVLyRJ
 FrxYdsN6cRHE3VsSMYxyay3BG7l5nfLCeFZyfbLVinGQEShgw6WVrCxlwFPsVsijBJJhwEFtBSVko49PVf6h5Nd/TCX1j8o3qM3ob9/zGBNW5Ahn/2ZlU1Ap0F8rNb8sEuGZaXW92mUhj25SSyGDJDaitjx3hJCxOSHWKFGsNu07yZD3vYXpYCpwwYhQj5l4CEsYZsDfOi8Onuk+EWm8s1zlkE1HVf6Lk08HyUQGfxFp1sdUGis9e/lL8APQUqlgbVcJZkcV4zXPkXVzIsVtNvUV9eaS4/4rmUUosc5E9GklR3nQygY1EKe8vTvwkAdB0npUmgsxatG+g6O9rDJIEkrklwKivh7/PoKKio9yYHh9OM3m2VlpTRbCxXcEEiVWlxYuPQJmnrYTc7VWLjswrz4qd6hUCfmhlFyQcyDfXpzpvc6iswAGfYkDbevbv/tUK70ILE3RLA664FmFc2dQDjCXy2d+Blg1zBrmmlv1ZgbBYL+4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Oct 2025, at 17:21, Wei Yang wrote:

> The loop executed after a successful folio split currently has two
> combined responsibilities:
>
>   * updating statistics for the new folios
>   * determining the folio for the next split iteration.
>
> This commit refactors the logic to directly calculate and update folio
> statistics, eliminating the need for the iteration step.
>
> We can do this because all necessary information is already available:
>
>   * All resulting new folios have the same order, which is @split_order.
>   * The exact number of new folios can be calculated directly using
>     @old_order and @split_order.
>   * The folio for the subsequent split is simply the one containing
>     @split_at.
>
> By leveraging this knowledge, we can achieve the stat update more
> cleanly and efficiently without the looping logic.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: wang lian <lianux.mm@gmail.com>
> ---
>  mm/huge_memory.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
>

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>


--
Best Regards,
Yan, Zi

