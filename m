Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D307810F9318
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 03:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 052246B0089; Tue, 31 Mar 2026 23:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0021A6B008A; Tue, 31 Mar 2026 23:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0BE36B0092; Tue, 31 Mar 2026 23:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF0DE6B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:20:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D025E0941
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:20:44 +0000 (UTC)
X-FDA: 84608534808.25.6337C76
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id B249A100002
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:20:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qiaw7tec;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rovD6Xt5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775013641; a=rsa-sha256;
	cv=pass;
	b=LnaOzY2RHRejROnpBAB2sD+641uN0NPMXaHKbpNI55LzRDDVeF79/uA1dv+1rwq6/O6MhC
	ACaRKBuuetWPxCaXYom2GqKm0qk53RKpj8IR9ZTUBnWrqhYhLMGnwp0YvsEnIqoDEvkg36
	rZpBJd96JEzOg7/2XD89Ua1nQb5CFsE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qiaw7tec;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rovD6Xt5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775013641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0uhGedYErs2L9+aKThNZoMOA356qHut7h2NwWzgsj4=;
	b=5O9blvM6nYgpeztfwlPoDa+5HJ2ZaOd8YfRFr7UQ6uj9VtMlzVdjsj5eVi4YwwAEMn4wec
	UT5jr7WpGUmnL277quOrdnG062SFWHjMpPnAD5a904u4IKLFwI9qHovVeK5luUArF88znz
	FIP1brvarOZOWoqFHaViu+30a+StiHE=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6311EWGL2192018;
	Wed, 1 Apr 2026 03:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=f0uhGedYErs2L9+aKT
	hNZoMOA356qHut7h2NwWzgsj4=; b=qiaw7tecr7CQrTSye4TCj3kQWp2+FBNkFD
	widE9DhnBVlUs9SnGZPhlbytGHhLAp2op03usI4GxEVG9SP1Q6KNrUByIT5UfMvO
	tGGHJcs1ao6MKHSFc5DBuT9AaxWTHF/q9fOISyJhm7ljmemdJII/OsUcwHj8YXvg
	mYPz4cBrXM/KuATXuevtzpDpoGnYVICJXDsMbWYtvdYOE6WIv9Jlsbc1HJjjNJhW
	rNIsPvXuV/HJlOvPDykRGgembECNk0EUKbUJZzOhmPlnokCAuepJ1z3lZUG/8l+s
	kqUcZkE9Xe9bSH1/y6K2UPlKdGrA/teivEMveg56vsqekWWsDrng==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d66v5nmqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Apr 2026 03:20:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6310d0CO008229;
	Wed, 1 Apr 2026 03:20:24 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010022.outbound.protection.outlook.com [52.101.193.22])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eb0fvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Apr 2026 03:20:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d0oroATdQRNGpQzHh1w0Krrx4R4XoURAXFZJ9Varz2syooJ9UjjAKmTIJtX3xnCyJAyUUgKT+BFkBneeO4FTNScUuZEt8zNzIJs//pP+yLyR7UicAfu5T5jy9MRTDKwsoZ86ZBsX7cTEq/dPyLyRhGaImth93APqZ230GNWXBFkx1jtdj/2Z04HBw1IRiTL21HXUw0iEZm1aoOwWfUn4RKuJXSy5LGLtHyyVLvFQV9e8XKrK+rnxNNzkDGHhCLDcYLL8VnNmFqYS1WFOu1QEAdy+tyKKuxp6wyG0fvL0bPjLPJbe8OCin9IBM3MzyzId0rxAtb6wQdGun7DfHDKbSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0uhGedYErs2L9+aKThNZoMOA356qHut7h2NwWzgsj4=;
 b=iKuFJLBwps0lxAbEZoZA86sNzwAtNCgMzqpQO6F/Uc4yc30688uhrW3VEyRWODyHDejziAn1GGmgexbDtHiVaawm9mrYyO+Q5m35kFFNdC8fBjvuASYTAFwtx5FjipYwSHtZj3N5vwIIFPafPB7gcxapTE893O1bjMmMRJG74QXgfG6pJ0bj40MbRrl+TyuoUL9bDgwszCXk+oM5weFtUX6f0gdCWtIPPcl6Y5XCgquJc3amkWwt6KNnQf7YpFURiDNIE9nq/VIipUrQPBCT1sZzN+Hbg2exl++KBnnGoIKQjueivG8PeXoTfb2PEMYnS6K2GAVVzsP34RZhEY1T/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0uhGedYErs2L9+aKThNZoMOA356qHut7h2NwWzgsj4=;
 b=rovD6Xt5njaA9/glpf3dNqxg1u5rcx2GFTgq+l1ZfifDfdMkh29K6AKGD0B01kvcCHBKg1qS2bLooKemIfNiEtD6a2uiWBoESs19Yvhy1gjEqj1+pBi3lWxF50pQAqCVcKJs+PLDcYw3/XMba4MKY4uRF2znetudZV0KQPkhng4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LVUPR10MB997809.namprd10.prod.outlook.com (2603:10b6:408:39e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 03:20:20 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9745.027; Wed, 1 Apr 2026
 03:20:19 +0000
Date: Tue, 31 Mar 2026 23:20:17 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Josh Law <objecting@objecting.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alice Ryhl <aliceryhl@google.com>,
        Andrew Ballance <andrewjballance@gmail.com>,
        Matthew Wilcox <willy@infradead.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/maple_tree: fix incorrect dead range comparison in
 mas_topiary_replace()
Message-ID: <gim5evcpgfrls3cy6ln7tuk6n33wvbsw4t6opxsbkluwab5smr@lqk2sxjzfkd5>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Josh Law <objecting@objecting.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <20260317222925.87929-1-objecting@objecting.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317222925.87929-1-objecting@objecting.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0119.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::13) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LVUPR10MB997809:EE_
X-MS-Office365-Filtering-Correlation-Id: 3df3ebed-48d9-4f12-bf25-08de8f9d9a53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sSLc/ZODMZ9kE0uwCgRnFI2fRsjOSqcu/86eBj0m3Kbzuqk2LKLnVstRmGcbzbZUv9rLQgUKCHbvyQOtlW5bHQSCIQaNTC8tZbSknuDEp793ncbs3l3C5+keax24RxMDyhGwPPCHq1HH320GOXiyzdmyNDfFVYYmNpM5KrRGeJxKpqS/NLCjQP9Kifp9IMEaBBvxU3PKUbfaqPK0ZWoxhUkRP+Q+eoddu1mZLKW/tFZDttjj6uzk/A33PCMqzoOONsNR6J17By5+w9wTIySdbEDlfDpNbyPTaHnHK5nC9B9H2+pOLhRquz5rXWFKC+gf/2TYe0YGxtYHipynAFwzChO7ru9oFqwxxm2eBrK9OW68qqXcoPZgeTNochqmOcziunao8RLUvQoMb7axW6Ihl7IbMUZ4Wi7mbnegK860mGllVJvD3eKj/G9wjqPxA2iUPbWV+6hmD6/xHzsnVqf1V4Z6mN/3UVAFbZGx9idqkRHB/IVOewbq4H91xN3W6Du8dtsXtagiY8xrGXNP9rHWwA14zgd/4EpfzerT5l1/vs0uJ2hqPW5Sxy+IQgvs0FAqFSmzOZDVTX8geCaFY+aZdaXPxmZLx24qeETGs4+FOwdPRTKmhSUoTynaboxY+LteTJC2Gpq/ReBZevdSjfTZ7q69fi/S1iOazNt0ltkqn/Onr6RANHXs6wex/69VoJdlXM5pI+M8asrGLo2AhJwFMpvYkpzG5rdevlb8TT65D90=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U/yAfILIv58nDRaoEaCWk45RHYPivTVsrZZ7iBYcTdGsD//HgTVboG/rUk9e?=
 =?us-ascii?Q?0M6RPfHnPxkn0z/AOx83itnEurbxzKASSi3w88YBNE5YgaReohsrQpfur/xL?=
 =?us-ascii?Q?a+VTDSpEw1iMCFqz/n0BSQLnyv0yOb6a78QOJ9A+am6RXHvQR/Ql8D0nf50a?=
 =?us-ascii?Q?vcvjhiKzF91XuBGpbrX9Mss4Nv8Q/jQGs2cf3cJfVvaxlAExfVgXGALNDPbh?=
 =?us-ascii?Q?+iaf1K+oW28dwRYE/0wtOxTk06C0Tsgkctl3xzEEOwEJQDtAipiFnA6GH6ar?=
 =?us-ascii?Q?EIcfW9Uut97O9HgyAOnL0NcjHgefBTSZtQfqUkNDljJWjiFZK/L1PsDRKcpC?=
 =?us-ascii?Q?VN509DxIJPMa3enEoH+3bJtx7yKO/t5vBB4DRvYkAVisWUXW07ayHu3PAFwc?=
 =?us-ascii?Q?DBjoFae5qgL/VgWqTnXpd/06kSzMELx9iHVbErV99Ho26TNmELbV9SgNhFZu?=
 =?us-ascii?Q?YfhOlQcYp6vn8QRQCdkzge4x8MBN0sgK4wzqZrToJkcd87vLQqVaro3tF4kl?=
 =?us-ascii?Q?enCC1afODqSUymNoWC3beLVKqil05RFLLr4kO4ZuR9niOO6IbFsozEgf9xsW?=
 =?us-ascii?Q?iqZNOrqNWXgWCZSi5DX1WWuHS5tAPD8cDlmPq5fitCRv9wEDkILokDfZWdyS?=
 =?us-ascii?Q?hnTkopPfHPPo8BLsQj0z7neqGfWUdMqFuRcVU1x3cHmYX0nIeBS2eX6lgqXG?=
 =?us-ascii?Q?54xuItfmk3f+l9lR+2slFBmiATtOvD3ym8Ux1dZFqeDdIBruPbZ5QN5Ph8GN?=
 =?us-ascii?Q?avPZZ58IpSNS8aa2FqySvk7acAktE04pBfLqz1+5JwAhjEhoJd+Rd/3HCjKq?=
 =?us-ascii?Q?TBR9Jmft4ed0m7fmqAv0FCn4isoVLo6kmAZG7sorOUtOJ9Id0v6RAOSIYXBP?=
 =?us-ascii?Q?kasAnMTejn9jvs//dQ43mrBHrfvEmviTktX/WAs0qYLlAcSLc8dWUe8axvmn?=
 =?us-ascii?Q?noIZvrA4ugvUN9mq1E2iGp9whLdSFTJV1bPGO+GJh9wLRV78zlzQ4uhBcuH4?=
 =?us-ascii?Q?cmoMiOy+dY/rx2mvqCzl3O0/tl/IyinohZHOt+YGv7BPfXFXF9qmZYHI+v+A?=
 =?us-ascii?Q?7kseNmWqoQUxz3QZrPnnj3Vf3lJ6X57H5JRnBqq95xtEk1JVPtZigu4O59NR?=
 =?us-ascii?Q?XsDSN8n60eTNFiegvjF83ul/umgDAQDxPUExv4eQcMsHrO3hLDSHgtaije47?=
 =?us-ascii?Q?twY/4ewD2L50UxKirSgjTq2m8HRuWvun38Pskxb+LoAsQMhXYlRhtowAZNG3?=
 =?us-ascii?Q?rbeKOVczZ1toiZEq2mKf5UWhLDCNhPu6CEocblLFGeNkIFBK35ve98ZLetuR?=
 =?us-ascii?Q?KS745xu0r9aSBFVA+wTNFfJpwYVYWhcGj2L6c/usc8Y+7LBeD7lgbEcZ60Oo?=
 =?us-ascii?Q?oXmidQFbeXgumtu0AluVaW8AkCIRWbWzfSwZ0LAAQh5nDs5OzS6eIwK8n277?=
 =?us-ascii?Q?HMCn4U0yclW1go9VHdznsqVkE//Z7tgIknrt5XU07mb2jkd3PbbXMGgd0mI/?=
 =?us-ascii?Q?tiTL9B/2jjSQ2PEcm7mpMVZq3SMj7+v6OGNwsKRW7SonxLieJNVC+8Wpmaoh?=
 =?us-ascii?Q?7Ba+hO2F8Mqd4x/hMxHO1nFwzKBGFmq43ubsPdQsBWGA1w6UXoCkeIFc+k91?=
 =?us-ascii?Q?zNei2nWHuVtB/m/ELenC8bmILAjgv8s07YRVAZkVEJFnBo3QKw/s+0NWtCe8?=
 =?us-ascii?Q?8ovvkep5670z59hAgoRLimz2YmrVWT7Evp65Ee+dBjPc3t/FMTxPdg8pG3RR?=
 =?us-ascii?Q?Ppb/ezlkpw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Wl/U/9lubUCiY0REE7Hgd5/c1qfLoj8Sg/hloH4wI3n/DIS2I0GPK1MRlEUTH2e4tsNNeZOjvIs4N86XRz2ugD74jfnmJgQN6DD0ZIrnkilvQG3Sb3Iqr7ciidymsLr43H7WZTe5G68uIfRmrUvSitHU7UDQ/8RSwSSWb7kCx4HFA0VCtXnwqZNJmgq/SjT1mpwiXVw6ZiNw+5snLVqC2xyjsK5LeyiwK0m/2GU1rvTeKqoyY0IYeA9h1+z5BsQ4+3fAoTKGhW5uStjVFiis0pGFExtda5/pnSEceL+mw5yK3Fd9uzu0wwyAoYAJOQ8v5/vZ7VIjx2E1NQ9uz4nc2w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hNTlbbDXzjbfSzSLyWAIZcMwV4ShBqXPgqmkQISvGRIWbjpqz2ikI/70r+AUvO7gzfHo9oAM5x/ZbjWFajdUeMLLmqgclR6ZP2+dEEksYinw9mGmPrVw2TYek9EVdjxsT1fGK0jxkiG48cbFrfMzXWID5b0rv3j/gfCCxrXvxrofBV0/Wn0ws1CeJZ7H8nct+FG4hjKQMA6UrZXg3HolJUWrgqh1zFgFMKMFfN4HfTsgNmGZvd6D6/vVgbTtm5DQ51ceZbSzdYFDEQxd8jIaSov0VjpPYTK+Bp+NM0IHa1m9jB6X0C70zNlsdb9AMO3uJlvJgIwwH7XtaKJWF+IkJdxumxorYkkTsb+wlHyT68Og1pa9CfjPt4nPKU8m/1EtuUCUbPzZjDpQodgiAjaMBqTueqZjqVKs34+ZBwbdcnmxlLJhQ33qYc23yt10wmzHmV5GQr+EMBXd9EHkiURNzb+zBgmRvKkT6TDxRVBmK5RJ1VBERDq7fQighd2T9LOLVhApopGHoasSMT9CXPcYlGTp0up9Jmw4B6p/D+Ezbhv1nvRy4dovT8k5E5fWBF6igpS+LtZbI684Do1jTIPzPagaQweL9HzsJtJPzwna8T4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df3ebed-48d9-4f12-bf25-08de8f9d9a53
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 03:20:19.6290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wXrqNLYI6Pl7RrfOMLy4ZCO+GkfgzD8zvisTuhPfQM64Pl23usCTgHdicmJ6ETxj+2I/bw3AaEEjSobQ1YJrVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR10MB997809
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_01,2026-03-31_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604010024
X-Proofpoint-GUID: J4AIssYdWpl-QzD-dNs-WBvzTp-voSH6
X-Authority-Analysis: v=2.4 cv=G7cR0tk5 c=1 sm=1 tr=0 ts=69cc8ef9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=JfrnYn6hAAAA:8
 a=yD-zjvGMAAAA:8 a=W3ZwTwFoXFkqaWBFj74A:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=kLuJvYmyrWYxQwIM_9hz:22
X-Proofpoint-ORIG-GUID: J4AIssYdWpl-QzD-dNs-WBvzTp-voSH6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAxMDAyNCBTYWx0ZWRfXwLY+AzMoeKIF
 s4yDHAEHFVwS89W584/1xnQx653ON7CbcUYLbnoYfiHDh8h/tUPVpiKmed7EM++bDwh2O2ZFSLw
 ZkMKIgtyz7Gh4tS21+Ho6BUeOhtB8CYbzRpkAzb07vyoW4QhBHEhoPDMXnqZpxJqXJnKEeStXAI
 Ys3uzN+i7IuSRT9EIv+VSU7baQg+WR0jS4gSrcFpsQLeZEBkBp25NLNnUWPRxuVlgJ+HaOYP1OS
 hTSvZ6FFRxFsLUXlm5F+wL3aX4abfdM0pv9/LRuXhWpbQECutnPg08FuuPnIDjlSLFNuyNq+7/h
 mD0gL7U4oUtEkJItR+mPdtS7MRne71XN9aMUQSA8MqEp26+r2bSkGkarT67jkv58JcE7vO/a9d2
 TUQIBYctv44aOIeY/NRH/kuHcJA3RzlQVB43WHh5QUlyuOSu3tU2ZGWcS64BQ/TJ+puutsqkeek
 rKTuKfzQzFXMri8KTqQ==
X-Stat-Signature: xzhd5n5o4uqz556e6t1x8oxnag71ajir
X-Rspamd-Queue-Id: B249A100002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775013640-974114
X-HE-Meta: U2FsdGVkX1/vrPftekklxtYTN0zxsjXtg3AiWEKN7DjvMRjWEMzHRpcmEojlXbW5tx2JNrBOIa+ubZ7/byHYxx2Og6IKUYmBLcv9sBdBwqaDhOCzIrL0sUG83uS+mZIbPpnE1yMsF02lJYjVVxmamZ5mvim+NqsQaYwNdh8OD7J1+B/Pfd+0UtA3w8MZ4KILj4gqhugF+R4zJXYQK0aNqiUyLqaKptwsltpjvXPto73lmxMQnjv5RYBqdlcWLZy/q1+Kh+d1kni/1sfRKLrlLZBIF0p5E6y+Xbf7aah2UqBejnY3OffaNIyARUzqmpdhlsJdsQkujW0USCR1NNOJEL00190/CNqe4M9Xy8S3niR77tW74wDQd/u+Ki+l7+WhObQfzqYcyDNBnVQ7Pko9gRNbJ4HC7352l+14LUPiNayhO4rEgPqeFnBKs4AWaN5kTTn1W80ymDaIi/qbUm8eeSeQbWxHvSm3v3Oaaey63OfOCcfE+BXQZ+hrXgTNelH9AjUerI1mYy4Q+Wpscc1n8T2Jdm27MWz+kPGg424oQPLnprT90Fd6+SVm30LyMwcYed8SetwqEn3B6d04DZIXWPNCCEuKYL+Sln3YEEbXXfRSkkvfE1Zs4K9yQy6dx1B2c9YhJuOOWaCQqYlScRp/Y9pxjgEsSh89r4j9qOg7wCLvTT5L52Dr+FAw4J573ZNnuETIt+ZXtHW5+Ryk1jIVhSkgXoiWhOuWJZRW8Wkz96dMQHvMa/EDmzer8wrn+jp0wiotJb/8r3kqoJoNa1VdzliESfEvtOIq07sVGLUsEGqqSoOuF/LjoyelFKm3CH5IvggfUvQwNQcoFD7Jd5iaeDbHujvv5N+tPq3jKJPtLAM7V/ZDOYaaXw253mKcFD8NCVaSTDjZG1LMCQJzd5RIFlG6RpDSKbMz0Pze9BZ3kaXY7CH9gQHw7shyrWgI27L2HMcaXegcuHDvce+nyRa
 3Yj9ea1l
 bV1m/TAX+3y3txjexvGjiCJ/iR0cTx0Jf/CSWKCYLepy/VXEJdMDZ5+sWg5g2nnj4alqzHNXpv9rleoziDAdgT5QSXIHciXmULpejNEkzgyHebrRMWCyKAZDUU3IKIaZusYkfA4jEdS44QkGbZr8HQK37C486OILvZzX1AumR+RE4pep33zAPSESE8A9Uxj8iUlkqN5M+mATrumzdzR9P6OceO3P8G5DKzfp28Ex1RnUj9t+0dvDEZwR9weCFAkI4x1pvrjwRWjeLslG34JjbSoxfZk6/Chl3oNexGN3C3q79bshT0JB9JgLMFTTZkx6mYBFh5t9tte7pNHgSrRTrcKmmbariEC0E7NMfNXj8lr17cACXe+kfzgFUcRC42g/3LBLbBfVBQyggfqPyVGkVQDgs+U+1vdzADzX4JkfjTLrBzsQR4Gk/ngEEFFIJ/m1vaThMrd4UTPXCTSgnc4bAby+F922Myo3uMnvWOndwLsgXYuO3tv5mzGRtdSTT35v7E8TBPN2bgoGU2MrcbPQ/hzirdQAvb310Aatxd4Dg0mWMzXhZHJHH2ToL/4axUY5c+1y7KBIQ3zcJ5GCuepBblD2fHoCUYybn8WJ1nadlWP2Hpd4T1BhDUqgbyfBOvBs6e4GrZWesI1uFiuKKB9f5JiAtX1tJU9w4FG5bjb197yzWWBTzbCOz6lrt16cCJH1SRda2PNQ+dIg4timbIzaOPb/tQWooldiZJr3g43N0BelfJmaXkd64vDF75T8Pa3p5ibiN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Josh Law <objecting@objecting.org> [260317 18:29]:
> When collecting old nodes for destruction, the dead range check uses
> tmp_next->index and tmp_next->last, which implicitly dereferences
> tmp_next[0] rather than the intended dead range. This means children
> at indices n=1 or n=2 are compared against the first child's state
> instead of the replacement range [mas->index, mas->last].
> 
> This currently produces correct results by coincidence -- mas_find_child()
> copies the parent state and mas_descend() preserves index/last, so the
> values always equal mas->index/last. Fix it to use the canonical source
> directly, as documented: "Nodes within [index, last] are dead subtrees".

NACK

I'd rather reference the same struct if we're going to fix this and I'm
not wasting more time on any patches from objecting.


> 
> Fixes: 54a611b60590 ("Maple Tree: add new data structure")
> Signed-off-by: Josh Law <objecting@objecting.org>
> ---
>  lib/maple_tree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 1eaaa5f964e9..64ba117ec254 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -1874,8 +1874,8 @@ static inline void mas_topiary_replace(struct ma_state *mas,
>  				if (!mas_find_child(&tmp[i], &tmp_next[n]))
>  					break;
>  
> -				if ((tmp_next[n].min >= tmp_next->index) &&
> -				    (tmp_next[n].max <= tmp_next->last)) {
> +				if ((tmp_next[n].min >= mas->index) &&
> +				    (tmp_next[n].max <= mas->last)) {
>  					mat_add(&subtrees, tmp_next[n].node);
>  					tmp_next[n].status = ma_none;
>  				} else {
> -- 
> 2.34.1
> 
> 
> -- 
> maple-tree mailing list
> maple-tree@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/maple-tree

