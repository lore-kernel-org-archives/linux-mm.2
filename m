Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2DD1EE0ADA
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 12:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FCFF6B0089; Sat,  7 Feb 2026 07:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AAE46B0092; Sat,  7 Feb 2026 07:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854FE6B0093; Sat,  7 Feb 2026 07:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ABA36B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 07:36:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CFAF58CDF
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 12:36:39 +0000 (UTC)
X-FDA: 84417609318.06.B218B19
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0241180005
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 12:36:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AuSH6I+6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="de/9K0u5";
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770467796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79F1qNsov4aVjaC/5+wZNEGWZdheduJAi7cG1ws/r6k=;
	b=kA5d3n2DPpaT20lsMMph7pKPX8R5Y32r8WXyGWbvqNaxFIRCyhSPpD6+LWeLYkpUY+nv0o
	WrVDtQNfh4FEOeGTAeSECgDWN2QUTxpqLLZM1UK/LVItBSXFmWpi/P2rJZsQWStvbccM9j
	IOuiZIOabdNSACfp2GoxpQD2CVKz4I4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AuSH6I+6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="de/9K0u5";
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770467796; a=rsa-sha256;
	cv=pass;
	b=C5gi5ta4d28ZVYLQBi3sTmrLI83lTE5T1b9MShyahMS3ukQhsRRK7f2ECNnxGKPW45SzK+
	4SUlJIcRPONxaOY92eSlou2M8IEIDn2uvxFlmW5BJo2tNZz07LcEw4EIl3JvzcmdTDGybC
	EYsQrdvZp65fyXWwVM2wpYyECnYP9tk=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 617BKEB6600103;
	Sat, 7 Feb 2026 12:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=79F1qNsov4aVjaC/5+wZNEGWZdheduJAi7cG1ws/r6k=; b=
	AuSH6I+62e6iCdpDWZRCPw09JbrsZaaqCZb2pgcPaOsDPho0Eyy1eqrVWoGqmjvb
	UcxdqsGroOk7TsYDbUZXa3etEaT0qk7h1duHKjaNo+5LFzny56Uk1I8Uvy+FPW7K
	lnodxFk5eAbg2/ILP+L7DxkCRWLO3qdHkTrnGZM/FhUhzLQwJFwI76T6G0yVu2GP
	xMX+yqVAGCyG8o6xc5oJ/6pNQtgHGO7eJuwJLyC8cbJaisL6k+EvhdIkcHmbtB4G
	HhH4NQ7bl/1jPHnw4Ri4ieNiPOxEcN9xMfiftY+Y1vQrn0rwtilrF+HOqBmawabB
	VkN/4ESzxNbEgo8ZGJNqtQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xes06pv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Feb 2026 12:36:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6177C8U9015011;
	Sat, 7 Feb 2026 12:36:16 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012011.outbound.protection.outlook.com [52.101.53.11])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uuhwhng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Feb 2026 12:36:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQ0MLjz4FFjyIqSU6KZL2jdYkZSuGiedO1bsj+iXoq9y4uMbKfMAcqCOzMLaP3jtewbhG5sQD5PXGvb6ntWVTpCQI9+KK8+XidflF/JH+C27j9Y+UlJsabUpTTzT5Lm3OZoem93RNAnL+U9mCi4s1b8vSB5W59cWo6i2cYHKBrB3n8rbOagnzEiDn5StxaDSnSib/8fvcxma+hnciHBedaEfuSP3C2RS9CB4p5QDL546OioKQwPVfB8lToT2P1heDK+7kMUtE4khJSN62UnvGSdR7dJxO+qJ/cMr8YA6jD0hES4lUCdvmULJcaifBw3NQA/fdXyubwHi7BNyzTI06w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79F1qNsov4aVjaC/5+wZNEGWZdheduJAi7cG1ws/r6k=;
 b=bLSzcNHfrIKOEnARUGSjGwJ8eyfUzLQKYO5yW95pPaPbRFw1zfh1IsCnaIzC8rQrnVSHJPwHmYMsAss7Cc25HAaHO0ohtnggxNiSRKa4hyJSqxGs/Fuj3Inm7FBG650fYibKN8Xma3HlmTp2tFh+l3zFEhN0NPbrj+Tij6j9M661sgAbhRrYkylOvMdCmWcZG2u2SvWRQZSlNd3yLeBvPp4/go3T7C++8elBDeAbOCfrvw9/sVl7PqbCWlGuMyA1nj5lR0OJof1IvC3NlQpHKZ52lwyDtWi6RxPmJNHyviqsYADGuy5HrpcwgxFKAB2YoMAChyUu5sMmvkE8P/TI3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79F1qNsov4aVjaC/5+wZNEGWZdheduJAi7cG1ws/r6k=;
 b=de/9K0u5PXpKA3DiBPAvOnuKTJnCyB03Mgi4HZFicRE6C/hF6qWtcLnbS41pNSZLKGWhKWJpIbwaJraSr36hLtUBH10TNG37MB5O13ujwSiV3RKUjcwgXky4IcgPTiKeCcNfYGdZksaP/NWrz1auZKq9kcsnceWdE7Of4uQxEHQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB8031.namprd10.prod.outlook.com (2603:10b6:8:200::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Sat, 7 Feb
 2026 12:36:14 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.016; Sat, 7 Feb 2026
 12:36:13 +0000
Date: Sat, 7 Feb 2026 12:35:54 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: psg <ab9517532006@126.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        lorenzo.stoakes@oracle.com, vbabka@suse.cz, akpm@linux-foundation.org,
        willy@infradead.org
Subject: Re: [BUG] maple_tree: maple_node slab object corruption via
 out-of-bounds write during VMA operations
Message-ID: <m4vzcyiy7kpu6bov7bdzvfovhf3shp7gf3z4woixtxh4ukqyns@llam4ort6fkb>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	psg <ab9517532006@126.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, akpm@linux-foundation.org, willy@infradead.org
References: <316c8f8e.1092.19c3672a409.Coremail.ab9517532006@126.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <316c8f8e.1092.19c3672a409.Coremail.ab9517532006@126.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4P288CA0043.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::29) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB8031:EE_
X-MS-Office365-Filtering-Correlation-Id: 69879a41-4164-4eef-7a07-08de66457ac6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?D+3FCZg6Uk7GG3CZgreWbck79VUPeG85a1gwbO9EEFYUFdYsWfSQxca8Sk?=
 =?iso-8859-1?Q?2/1y4DlUez0Hk5jJOHr3Vf99iQv6GgoVWOn7Ig+8zQdrtIG9Fc/8tSP7ww?=
 =?iso-8859-1?Q?dC1OAUWp6yXxnnlRCPlqv3Bj1phCWSgNbEo0UQ6YDR8IRXAvikmMdxAaup?=
 =?iso-8859-1?Q?tp3JcpevFPGAsNTVxJFwEYLyyzhPCYt5WFzrjg0lscfMGkMaOEiTbJMkBD?=
 =?iso-8859-1?Q?elzcr0tnGyFKHFjr1EPgDGUdReSIySVZ494cr1WRPsrTPplXTr9orkTVGw?=
 =?iso-8859-1?Q?AlnwtrN14H8tMP5QhKIBFjqG1han5GdOCtYmJpYnkRPYAIKYx1JA062hg/?=
 =?iso-8859-1?Q?Ae+JvCyiYaTn16nsYLw4PbBkz2/dEIJe1yqBbB8brCAZnYyAzw+fC85Oz/?=
 =?iso-8859-1?Q?UQGkYVInNwZGM6RDynbjQRzhcN4Esoneb1Xr7HGNxwpyGhCfeQ9mgCiv/e?=
 =?iso-8859-1?Q?cnIN6JwA5cqz1Lp245BB34ZxPH3HQ57vOtkrDqdRmJEF9qlaJao1T3vz0U?=
 =?iso-8859-1?Q?5+mYaxgDz/rS7/Ihn7W1MZqd9Sq2e15uuoZD0FxDLXI6L5R0Ry4SvqAQiR?=
 =?iso-8859-1?Q?0nmbbU0ahr7jMZsLAOTeiU6T36VtZjj6xVADjD03uzU1sm74axPGXH0s7a?=
 =?iso-8859-1?Q?uSfjMAt90ey/1jva3gZ8A8WGNXqu8ShQWPryBEfKgCdL5zEFBYIwc4zoNE?=
 =?iso-8859-1?Q?dNUiB8UNzmm58KQsRvIJTMgFF5dp60BJkx6bEpdNqjvI8xUTwLRW1frr6+?=
 =?iso-8859-1?Q?8ljUBJTspDn1VHuYy4x+qda9pdIxzkejYgZX/d1OkL/OVAOT1xMgKBboND?=
 =?iso-8859-1?Q?ptWg9E3wKilzZzDzrcOHt1GRPdx6EAkhWDXRZU89NLeY50uvppZfJRhyf2?=
 =?iso-8859-1?Q?StXx2xN68l1Qs93zNmSOdrdlxSIjPoKUmHMrZxFzXJ74qJeb4TFYtdgEWE?=
 =?iso-8859-1?Q?a1M4GOGfwTjcQJlR6VpoFStFsZ7kJG2e7w4LJdfAwnyyc4XAYrhd6SGNJk?=
 =?iso-8859-1?Q?O5dwhYS9NwUjjC3WDJb+o9wyXjUjvEWFwJnFeFp2hw8cJPU4DmX9zcwtwG?=
 =?iso-8859-1?Q?PIqjUKoQiOhTBaX2PLf6r1mbnYohCD+8Vz7TkdYvqZEFa8TeoLuLagkBN+?=
 =?iso-8859-1?Q?KYlxgpMQNLazIjYsV56gnMfI1uzLHe8p/ukm2/RPAojnA6JAZjLwOTJjM+?=
 =?iso-8859-1?Q?Vcwuw86o09EkqaQDaJQUU8MckDLkGUoa2wKcoDlYaTCyhK4uEwpEwpp9gE?=
 =?iso-8859-1?Q?kEOr4JOpOkgpapiUGl/NvLI1bZk0Wdy8LArBEQe6Ayt4pmLVxOsEmEgQRy?=
 =?iso-8859-1?Q?n+JuleOzYRFh5ST+ip3w6wA9Ftrpkq9Fss1P82RgWriOgWes2eh+uHtNWs?=
 =?iso-8859-1?Q?K8oB06qMpRzAiqTFPzyJpUAoFTIpB/X95sGXztK8qDRS48s5bzCT5vnIeK?=
 =?iso-8859-1?Q?M1D3BCQ3Kz21aaE6pGeHEYsi01RJ+6cIcH92YKnQWRBMbtjUhJv3XE6Wyk?=
 =?iso-8859-1?Q?s6YzDGD1qGpVFNj0O/3uUlbj7MLsNzWNzRjPjs/woaFDS60OAphif2Knu/?=
 =?iso-8859-1?Q?a2TnpU42dFRqXwNTyt9mODe0Rgfybpw9TF425F8sGsKjJv/ChKN/efJ8DI?=
 =?iso-8859-1?Q?kP5369pfTtJmA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?W1czRFkUYfRfCF3Lz8Ub8wyV8DLzbCpM59eiLCSMpDByEboKKzbW9U9kpK?=
 =?iso-8859-1?Q?/jeGev7qBZb6L1e9fI+myBv36c87TKnGMuZgRPFgKuKGMD4qHnaS4TI0Mp?=
 =?iso-8859-1?Q?jY+iKG1AsZqMFBCQ5ukiSKyDd22FAqWEkk7OAWFlcdGu8ffyzJEBye6Hk3?=
 =?iso-8859-1?Q?usmivW0FNLQPRPUO+mkW3fw/XxvwEl/s4sg6iXww5Ehsjr5+y60FUr/Q2+?=
 =?iso-8859-1?Q?4wEIqgdn7ipX4J5OnTZUaHIX8t7VGfar3Ax1REsZbS0y+/H6Zp8j8Wtlvh?=
 =?iso-8859-1?Q?Qed/vOGHpr+YNK2YuSWaAHG1V3algkksZkHWopubhodeVvpgryEsZrQgkD?=
 =?iso-8859-1?Q?/fVfIMeHZxSJu60fkGhkXWshtkBNk1dIBVBX+iV3OmOYgLgagK9eBHlTcF?=
 =?iso-8859-1?Q?xPg1Krt1MdY/b9fCIwfD1oQMtS/nqJbj8zSjrBfmltFjDMiatCwns8wFsO?=
 =?iso-8859-1?Q?XcFBOKo9X+1xXGyNtlrky4PY2Ip2lOv87mDXvPyMtZbQMKRyEj49aHlGAB?=
 =?iso-8859-1?Q?IdtVOttFyu/giIVcnqgY4V3zYgKWXnG+mB8xCoSEX4CJyaCPvNL9vGDAK/?=
 =?iso-8859-1?Q?u9ge9yQiO6z3vgFdQp47KLVPiofUgpwGzvKqkD2HMxgWEYmOUhVnOeDw3q?=
 =?iso-8859-1?Q?9sPIV6UI/IJkWk0RHRK7m46/RBpJmNUIrVrgAEeFvv57NwyQVONB1ccJFY?=
 =?iso-8859-1?Q?ZTHmw5AM4Ii9YE9fKb8jTLTCdJ+FenAGv+oRwGsLd3wl2jQpxMgf8dJoGU?=
 =?iso-8859-1?Q?KO1dzTMD19mEP0D52YU9i3G7ISEMkkooEgG9fUMitMiG0ujgaSlAt0W61C?=
 =?iso-8859-1?Q?gqgk7pGKOVZXYSGQ1ue6WhZ5drS1Ml2sSeyMU2nXyp5bvdTnjZqXvR561X?=
 =?iso-8859-1?Q?f/X0IdrC3vHlWsHKqY7ShCm7N0n/i3iej82TboCDWCiB1eY1Yh/SB98QFF?=
 =?iso-8859-1?Q?k3mLu7F42yZygnA7p4RXuBz2U1Jv2gbHfJTFaEvAuka37sSHW36f47INVK?=
 =?iso-8859-1?Q?8xIMR16Jozh9r2hC122vnmbd1XRXM/jmh7nzHPdNEP0Clf3goWCsaKo9uI?=
 =?iso-8859-1?Q?aRKvxKSfH+akaawNJyZWXLRcmtMiy+gdf//+V9W5XK0stZuOZJ1NS3NgKT?=
 =?iso-8859-1?Q?GNFcs0XNX/4K5Z35HcSQmCI8Fvv6CM/QacDImofgjSUR+Z7pzQK4fsM8U3?=
 =?iso-8859-1?Q?ZiCbLpDolKIT7Iij+lSUIOU/z3WTO0U8K9SfT4kHIcyPNI32RF2J0kbbkw?=
 =?iso-8859-1?Q?1/Z1H0uohRM/eJcqd2BsbNrce6KkCLTjo83Ijf8ZuDXZ+np22jhTpMCVeW?=
 =?iso-8859-1?Q?xTJrfQ/zOq1NA46JwBsjsNpXYAFbBPrizjwvHgD7K2nEolH0vAgO7NL8/i?=
 =?iso-8859-1?Q?Df+EfTisGp+0hyE7XmsXveU80ebAH8lCepjKXvmbef16kGQ1+i8FQKY9uO?=
 =?iso-8859-1?Q?Nf+Nj6V7tbuswhr7hMM+1r3zxa+LFZqilEtthls5QDhOS2hpGtHkGXkMzk?=
 =?iso-8859-1?Q?ZNPtHKmzanKhGAvyzQan+2vAlwfylnvzXIFBpJQqm8+DUgApBPz1kw2iv7?=
 =?iso-8859-1?Q?zvKNkrHddm1Ba2HQiYqA1+KYybVcZUazQnAtYmgkWiz1cqI0sgZH/8Ps2s?=
 =?iso-8859-1?Q?ym20mH5L6GrQwr/B5t5sJ6ylG3sDazARoLW6IxVtzfcffL22pUyaiKjLli?=
 =?iso-8859-1?Q?/3t/4M5xbBeOtUkadvDqzUMA/gpeLGBGt1wYZfVWb6FpjWlD4QIP/xkMnr?=
 =?iso-8859-1?Q?FbzLLmofZfXf42l70B+qEUxWSP4sNxK/F6SO3U3ApwdJteZtoz6mjJ9AEF?=
 =?iso-8859-1?Q?IBzi1Qjx5g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tz1FaUQn/XVkXTyGvD947QlV2oF+AEXnVW7q6e40FzR3+FJnAUhW99T6uGIZdhEQmB3A3qTLij/D66Rc8+YdSREJeX3cbx3bkdlB5tkWS+judXLecy+dRD6hz8GuTxWTVZtSO6Qi4LfNLFHtfW9cVCmz9EpWt7TSGjnFpadTAYtJV5lMoqaqqEJihHJwzoQ2WbOS9HgsRv2jrqMXgKprssahdBgcxVw0dL4wtZ9ugKWj2/MiQvWw6eTZJ2LxymrI5EQyLSTqi1/zYNiQlM7QvLRA+a20zHlvyyXtw0cS1C7Q770G8wfamroO8xI7iblLQpma3o49k0Nnrsjz89Ptaev9zlyv+DQpxexKR7depo3L1YReO02TyG4XF3IWAEwn9/zMDO/ZynU1EKHV+nKRppRgqrAz4BHh24HnGK/8Fmiwk4z0shVIy6/BbrRyQhP/0NT4RtQo4u+i0YuoVC9xk0PUyk0dzax3YpTMHgwwdn5O5L6DX+MU44vPELwsiIXi+hRvTCHc8XfiqOeMjnDAQ4IMO0+8KEl+6EfXufciFJ6VQibfP/7av0G0aCiMdDBOXpoLathVqd7um0qpGhnYKGDuE/CcXZjUReNiEboL40s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69879a41-4164-4eef-7a07-08de66457ac6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2026 12:36:13.3653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VSANzMptsZ2up9U1ii99dXjB6eC6LSsVZTKDQhabXkgmNmkcA7dN+HxO5SYjqvYRyJeC9yyJLczegAbMEKtUMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8031
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602070101
X-Authority-Analysis: v=2.4 cv=KaTfcAYD c=1 sm=1 tr=0 ts=698731c1 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=gnbuhwpKAAAA:8
 a=ZPmdeDVuOU-HRAU12bwA:9 a=wPNLvfGTeEIA:10 a=HL_VsaX-4L8esMsM0cMV:22 cc=ntf
 awl=host:13644
X-Proofpoint-GUID: 4W3OV_9gUL5F44vJ5inWsZWjLGMu71ba
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA3MDEwMSBTYWx0ZWRfX3ZULxK5nMZRx
 sCHhrSTWNqsNRGU8EK9J+dnXF76kg9KBumwa27EWzcOc7S+6Gn15LH4nG/3A3m47MHzeQew2fXm
 L/y/LW911cxd4Rq2iYNhTNW5G4qnWUPuIfqz4SQhRoFgKnkTCUS2RvoorZBoMygaQWVj0YHlIy0
 fp93rjM0q16qsrr4QpxT/jhJxlgwAr+8oi6zT/6o3EB5JIoxftJGel/9eHBDiCZWPAT5yImp0KQ
 630AOL9kA8miBe/8tuwkMsRi3p+J5IcLJ4JuJigqHXhmHykQknhI7C3TF8ksA2aUiYxUNQ0kWdt
 ugYJu9W4XvLP7sQBQwlKzOniv+qQZicvCRp+XR6BO6hJZ8ASiPrN6VwJbHVKYzNfRw7VbgFG1fA
 gzwmK7yEFVb/qzgdgC9tuJQiDb1h4dK5d6LY4XMSiBpnWO/o22rKv7y9xMPwDCuVsPXU3xH4Twe
 2OtIjcnTHniw+9Q7wn4Z3nJOCYW25bEyN98Z8Qc8=
X-Proofpoint-ORIG-GUID: 4W3OV_9gUL5F44vJ5inWsZWjLGMu71ba
X-Stat-Signature: zh41kzbp7u3smxrj6q41gh1thu95pzph
X-Rspamd-Queue-Id: 0241180005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770467795-552250
X-HE-Meta: U2FsdGVkX1/pKhLcvRaSFXcpqoGO2FyEpnjyPLFNAPNq39hyCPBXSNiJThVYsQN2c5LU/bIWYdLYUegMbq/MqGBih56i/Tf5cXSRvPB1HHMvZ+UITJ3GBwm5vatGzz0UONg0RHQap77JeYe710hVLYFXLvPExVNTUHX/C0nZO9o6GuVMrp3RMjNIrORR/+VbrvpxuEnJYxHuOtGAZEKdb6t2EHREZyVMtELipzrlaMblz/dAyi4+4VqEGRO0AlwQFeUh9/XdhPlL7vLqcK5I9rrVO56xQ95Ru3lxSJEoLHH68Zg9TzurzHvbu5tz3Ic4w3qVMMnFxQCf1yCzmZyYwdOZPGDCEiC8fd6VXeRlwybp5/5G0KwVSibXkmwZQbKx1jzc3qrcoas1Rh3/cronPAu0586KDp9i1o1fPYoi465vzhOHEGquEg0NXta6JYMuFo7KHdokXz3KC7gUDaaYcigBF0TJfSaSACQhrkDXBKNlGmHCzbmvDKhJ+KHB9HoaLAanv1jMzvnCQwo/d3+W7w2tWGNdTyZOtWAWROLqhG6TsaL26PUqvyZNlb8ZRYzmrG90LVaA+tmBVM2OG0IJ+cBBpUoQbrp0F+eJgXkwpwW8PCKoZFvKtX+EZEz/nB4uyB0Fkit9sHWw7zxoSq9RtrUnFN8gjec0ZKIn0kU0tgV/DpFcA1mvF7NR4I9pttUdWqVtjrVKspg+u4UKOw80ZY4px+jElwq0H4h0kNLXfGFzMpVhK+ez91MsnoLlDg5i5DouvGzIbpubFZCEQN/WBI1mw6SmDdB5nQdYrdUh0a6bm6cXfFDRn6t9o+8sci3MBufsxCNfn7StOZuQ5mL+Xtg5yCI8asI+gXtyUlfnJ9vtZqStkJ/CPONGSYODYIshwApo3z6DidE5T3gC+qLu3J3JNOfMQ0tSks+77mY47jgX2te1aR8aRkDoMxD7YVANFUbNzeiKGl3+yemcCnH
 LAh8w0dN
 FCHaG6XoEWV2B9Xm9WHMJNGkProBepduOidsAgohrUfw1oezU31IM0ONPIuTqAepgOsWOubVdsx6azqvKdiwbzaiUuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* psg <ab9517532006@126.com> [260207 04:54]:
>=20
>=20
> Hi,
>=20
>=20
> We are hitting a reproducible maple_node slab corruption on 6.18.0-rc6
> (ARM64) during early boot. The corruption manifests as
> a left redzone overwrite detected by slub_debug, followed by a kernel
> panic due to panic_on_taint. We have captured two independent crash dumps
> showing the exact same corruption pattern.
>=20
>=20
> We have verified that the CVE-2024-50200
> fix (commit bea07fd63192 "maple_tree: correct tree corruption on spanning
> store") IS present in our kernel -- the r_mas.max > r_mas.last comparison
> uses 64-bit registers as expected. We have also ruled out CVE-2025-38364
> (MA_STATE_PREALLOC flag), which causes NULL pointer dereference rather
> than an out-of-bounds write.
>=20
>=20
> Environment
> -----------
> =A0 Kernel: 6.18.0-rc6 (mainline, ARM64)

Did you mean 6.19?

> =A0 Config: SMP PREEMPT, slub_debug=3DFZP enabled for maple_node
> =A0 Cmdline includes: panic_on_taint=3D0x20 slub_debug=3DFZP,zs_handle,..=
.

Can we see the full command line and config?

Have you tried 6.18 or any other released kernel?

Did you try enabling CONFIG_DEBUG_VM_MAPLE_TREE ?  Please set
no_hash_pointers on the command line.  This way we can see the full tree
dump and where it is happening.

>=20
>=20
> Crash #1 (mmap path)
> ---------------------
> =A0 BUG maple_node (Tainted: G        W  OE): Object corrupt
> =A0 [Left Redzone overwritten] 0xffffff8828948300-0xffffff88289483ff
> =A0 =A0 @offset=3D768. First byte 0x1 instead of 0xcc
>=20
>=20
> =A0 Allocated in kmem_cache_prefill_sheaf+0x308/0x33c age=3D291 cpu=3D2 p=
id=3D87171
> =A0 =A0 kmem_cache_prefill_sheaf+0x308/0x33c
> =A0 =A0 mas_alloc_nodes+0x98/0xf0
> =A0 =A0 mas_preallocate+0x234/0x33c
> =A0 =A0 __split_vma+0x11c/0x364
> =A0 =A0 vms_gather_munmap_vmas+0x118/0x310
> =A0 =A0 mmap_region+0x2a8/0xae4
> =A0 =A0 do_mmap+0x470/0x578
> =A0 =A0 vm_mmap_pgoff+0x1e8/0x264
> =A0 =A0 ksys_mmap_pgoff+0xa4/0xf0
> =A0 =A0 __arm64_sys_mmap+0x34/0x44
>=20
>=20
> =A0 Freed in mt_destroy_walk+0x16c/0x344 age=3D391 cpu=3D6 pid=3D83838
> =A0 =A0 kmem_cache_free_bulk+0x3c4/0x9f8
> =A0 =A0 mt_destroy_walk+0x16c/0x344
> =A0 =A0 __mt_destroy+0x40/0x80
> =A0 =A0 exit_mmap+0x2ac/0x4b0
> =A0 =A0 __mmput+0x38/0x16c
> =A0 =A0 mmput+0x44/0x7c
> =A0 =A0 exec_mmap+0x208/0x2ac
> =A0 =A0 begin_new_exec+0x188/0x46c
> =A0 =A0 load_elf_binary+0x434/0xc68

This is on exit of the process, so it's not very early in the boot
process.  Hopefully you can reproduce it with the debug flag without
waiting too long.

>=20
>=20
> =A0 Slab 0xfffffffee0a25200 objects=3D21 used=3D16
> =A0 =A0 fp=3D0xffffff882894a200 flags=3D0x4000000000000240(workingset|hea=
d|zone=3D1)
> =A0 Object 0xffffff8828948400 @offset=3D1024 fp=3D0xffffff8828949c00
>=20
>=20
> =A0 Panic call trace (detected during RCU free):
> =A0 =A0 check_bytes_and_report+0x104/0x31c
> =A0 =A0 check_object+0x98/0x3c8
> =A0 =A0 free_to_partial_list+0x174/0x638
> =A0 =A0 __slab_free+0x204/0x248
> =A0 =A0 kmem_cache_free_bulk+0x3c4/0x9f8
> =A0 =A0 kvfree_rcu_bulk+0x17c/0x320
> =A0 =A0 kfree_rcu_work+0xb8/0x144
>=20
>=20
> Crash #2 (mprotect path)
> -------------------------
> =A0 BUG maple_node (Tainted: G        W  OE): Object corrupt
> =A0 [Left Redzone overwritten] 0xffffff88184b8300-0xffffff88184b83ff
> =A0 =A0 @offset=3D768. First byte 0x1 instead of 0xbb
>=20
>=20
> =A0 Allocated in mas_alloc_nodes+0xcc/0xf0 age=3D343 cpu=3D3 pid=3D89696
> =A0 =A0 kmem_cache_alloc_noprof+0x3fc/0x55c
> =A0 =A0 mas_alloc_nodes+0xcc/0xf0
> =A0 =A0 mas_preallocate+0x234/0x33c
> =A0 =A0 __split_vma+0x11c/0x364
> =A0 =A0 vma_modify+0x424/0x4dc
> =A0 =A0 vma_modify_flags+0x74/0xa0
> =A0 =A0 mprotect_fixup+0x154/0x28c
> =A0 =A0 do_mprotect_pkey+0x410/0x5b0
> =A0 =A0 __arm64_sys_mprotect+0x20/0x34
>=20
>=20
> =A0 Freed in kvfree_rcu_bulk+0x17c/0x320 age=3D335 cpu=3D7 pid=3D9090
> =A0 =A0 kmem_cache_free_bulk+0x3c4/0x9f8
> =A0 =A0 kvfree_rcu_bulk+0x17c/0x320
> =A0 =A0 kfree_rcu_work+0xb8/0x144
>=20
>=20
> =A0 Slab 0xfffffffee0612e00 objects=3D21 used=3D8
> =A0 =A0 fp=3D0xffffff88184b8100 flags=3D0x4000000000000240(workingset|hea=
d|zone=3D1)
> =A0 Object 0xffffff88184b8400 @offset=3D1024 fp=3D0xffffff88184b8100
>=20
>=20
> =A0 Panic call trace (detected during sheaf prefill alloc):
> =A0 =A0 check_bytes_and_report+0x104/0x31c
> =A0 =A0 check_object+0x98/0x3c8
> =A0 =A0 alloc_debug_processing+0x104/0x1b8
> =A0 =A0 ___slab_alloc+0xb10/0x1314
> =A0 =A0 __kmem_cache_alloc_bulk+0x1d0/0x460
> =A0 =A0 kmem_cache_prefill_sheaf+0x308/0x33c
> =A0 =A0 mas_alloc_nodes+0x98/0xf0
> =A0 =A0 mas_preallocate+0x234/0x33c
> =A0 =A0 mmap_region+0x548/0xae4
> =A0 =A0 do_mmap+0x470/0x578
>=20
>=20
> Redzone corruption pattern analysis
> ------------------------------------
> Both crashes show IDENTICAL structured data in the left redzone of the
> object at slot 1 (offset 1024). The redzone occupies bytes 768-1023
> (256 bytes). The corruption originates from the PREVIOUS maple_node
> (slot 0, offset 0-255) writing past its 256-byte boundary.
>=20
>=20
> Corrupted left redzone dump (crash #1, 0xcc =3D SLUB_RED_ACTIVE):
>=20
>=20
> =A0 Redzone  ffffff8828948300: 01 00 00 00 cc cc cc cc cc cc cc cc 78 59 =
ef ff
> =A0 Redzone  ffffff8828948310: 08 00 00 00 00 00 00 00 00 00 00 00 01 00 =
00 00
> =A0 Redzone  ffffff8828948320: cc cc cc cc cc cc cc cc 80 59 ef ff 04 00 =
00 00
> =A0 Redzone  ffffff8828948330: 00 00 00 00 00 00 00 00 01 00 00 00 cc cc =
cc cc
> =A0 Redzone  ffffff8828948340: cc cc cc cc 88 59 ef ff 08 00 00 00 00 00 =
00 00
> =A0 Redzone  ffffff8828948350: 00 00 00 00 01 00 00 00 cc cc cc cc cc cc =
cc cc
> =A0 Redzone  ffffff8828948360: 90 59 ef ff 04 00 00 00 00 00 00 00 00 00 =
00 00
> =A0 Redzone  ffffff8828948370: 01 00 00 00 cc cc cc cc cc cc cc cc 98 59 =
ef ff
> =A0 Redzone  ffffff8828948380: 08 00 00 00 00 00 00 00 00 00 00 00 01 00 =
00 00
> =A0 Redzone  ffffff8828948390: cc cc cc cc cc cc cc cc a0 59 ef ff 18 00 =
00 00
> =A0 Redzone  ffffff88289483a0: 00 00 00 00 00 00 00 00 01 00 00 00 cc cc =
cc cc
> =A0 Redzone  ffffff88289483b0: cc cc cc cc b8 59 ef ff 18 00 00 00 00 00 =
00 00
> =A0 Redzone  ffffff88289483c0: 00 00 00 00 01 00 00 00 cc cc cc cc cc cc =
cc cc
> =A0 Redzone  ffffff88289483d0: d0 59 ef ff 18 00 00 00 00 00 00 00 00 00 =
00 00
> =A0 Redzone  ffffff88289483e0: 01 00 00 00 cc cc cc cc cc cc cc cc e8 59 =
ef ff
> =A0 Redzone  ffffff88289483f0: 18 00 00 00 00 00 00 00 00 00 00 00 01 00 =
00 00
>=20
>=20
> Corrupted left redzone dump (crash #2, 0xbb =3D SLUB_RED_INACTIVE):
>=20
>=20
> =A0 Redzone  ffffff88184b8300: 01 00 00 00 bb bb bb bb bb bb bb bb 78 59 =
ef ff
> =A0 Redzone  ffffff88184b8310: 08 00 00 00 00 00 00 00 00 00 00 00 01 00 =
00 00
> =A0 Redzone  ffffff88184b8320: bb bb bb bb bb bb bb bb 80 59 ef ff 04 00 =
00 00
> =A0 Redzone  ffffff88184b8330: 00 00 00 00 00 00 00 00 01 00 00 00 bb bb =
bb bb
> =A0 Redzone  ffffff88184b8340: bb bb bb bb 88 59 ef ff 08 00 00 00 00 00 =
00 00
> =A0 Redzone  ffffff88184b8350: 00 00 00 00 01 00 00 00 bb bb bb bb bb bb =
bb bb
> =A0 Redzone  ffffff88184b8360: 90 59 ef ff 04 00 00 00 00 00 00 00 00 00 =
00 00
> =A0 Redzone  ffffff88184b8370: 01 00 00 00 bb bb bb bb bb bb bb bb 98 59 =
ef ff
> =A0 Redzone  ffffff88184b8380: 08 00 00 00 00 00 00 00 00 00 00 00 01 00 =
00 00
> =A0 Redzone  ffffff88184b8390: bb bb bb bb bb bb bb bb a0 59 ef ff 18 00 =
00 00
> =A0 Redzone  ffffff88184b83a0: 00 00 00 00 00 00 00 00 01 00 00 00 bb bb =
bb bb
> =A0 Redzone  ffffff88184b83b0: bb bb bb bb b8 59 ef ff 18 00 00 00 00 00 =
00 00
> =A0 Redzone  ffffff88184b83c0: 00 00 00 00 01 00 00 00 bb bb bb bb bb bb =
bb bb
> =A0 Redzone  ffffff88184b83d0: d0 59 ef ff 18 00 00 00 00 00 00 00 00 00 =
00 00
> =A0 Redzone  ffffff88184b83e0: 01 00 00 00 bb bb bb bb bb bb bb bb e8 59 =
ef ff
> =A0 Redzone  ffffff88184b83f0: 18 00 00 00 00 00 00 00 00 00 00 00 01 00 =
00 00
>=20
>=20
> The corruption data is interleaved with original redzone poison bytes
> (0xcc or 0xbb), which are preserved at 8-byte intervals. The corrupted
> bytes form a repeating 28-byte structure that resembles maple_range_64
> pivot entries containing VMA page-boundary addresses:
>=20
>=20
> =A0 Bytes 0-3:   flags/refcount (0x00000001)
> =A0 Bytes 4-11:  [original redzone poison - NOT overwritten]
> =A0 Bytes 12-15: VMA address fragment (e.g., 0xffef5978, incrementing)
> =A0 Bytes 16-19: size/length field (0x04, 0x08, or 0x18 pages)
> =A0 Bytes 20-27: zero padding
>=20
>=20
> The VMA addresses form a sequential series:
> =A0 0x????ffef5978, 0x????ffef5980, 0x????ffef5988, 0x????ffef5990,
> =A0 0x????ffef5998, 0x????ffef59a0, 0x????ffef59b8, 0x????ffef59d0,
> =A0 0x????ffef59e8
>=20
>=20
> This pattern is consistent with a maple_range_64 node's pivot/slot data
> being written beyond the 256-byte maple_node allocation boundary,
> overflowing into the right redzone of slot 0 and the left redzone of
> slot 1.
>=20
>=20
> Our analysis of slot 0 data from crash #1 (via physical memory
> reconstruction from the DDR dump) revealed DUPLICATE PIVOT entries in
> the previous maple_node -- a pattern reminiscent of CVE-2024-50200, but
> occurring despite the fix being present. This suggests there may be
> another code path in the maple tree that can produce similar spanning
> store corruption.

What are the pivots?

At rcu free time, the data in the nodes may not be reliable so it would
be good to try and use the debug validation code in the conf option
mentioned above.

Thanks,
Liam


