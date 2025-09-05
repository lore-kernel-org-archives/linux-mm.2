Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF93CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AC338E0006; Fri,  5 Sep 2025 11:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83B6B8E0001; Fri,  5 Sep 2025 11:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AF788E0006; Fri,  5 Sep 2025 11:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5131E8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:17:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2F0DB7C85
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:17:09 +0000 (UTC)
X-FDA: 83855549778.19.3D8D8EF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6637580009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:17:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="nv4p8/xj";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bXfGpgIU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757085426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ql0WJ2L+tEQxxWhy2vYpOoYXpfnez61YuwZ8KsEoFcU=;
	b=DBkFdSKXlnwl0xPXMSbBYelwgJ1mwxrTKBgyyMcbTdmZuihHTcSfOU36Mzy/2JXdcgMsjS
	qqSxbY8TQlDFL+fFMnMCskhSTDFSz0HRKqn4zJWDa44VnDYEYqwZDHa1Eut5POBMhdxYjY
	mqc82ZtshNPK50f2h0tYSFo9Em5L8es=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757085426; a=rsa-sha256;
	cv=pass;
	b=Kjqxma1mJ7RpshMuYNzK7QI8wQ3PETKV+E9G4Nqn5XkB4ke5bjDKIeIv4YKutmBoMzLORE
	pA/X3UR88EUqmh0a2TQ9JOs/EeOn9pNTfi+2oW07SPlkVQHKHLo9YpM6Ps4ISrga2iRrPD
	mVTn2LZWx5tKCnOTW5m1IKykExUouyY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="nv4p8/xj";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bXfGpgIU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585FEbKK031974;
	Fri, 5 Sep 2025 15:17:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ql0WJ2L+tEQxxWhy2v
	YpOoYXpfnez61YuwZ8KsEoFcU=; b=nv4p8/xjTL762ctiOyq+3GEi2xO6HBk2JW
	RmQ5yRWUFTrGtDy1TWrpNeG4pNP0lxbvWL5UhxqKTuG8T8kbykwSIE4gTK9qlMWZ
	SgyteJqqwjF0plspIL9ljslewsxHY6UQowue9W9RAw87msQ6NGj+y2ynAwmNerZX
	Fild6HBdZaQJRtJcn7WwIlglpXZs4ATGSVIWgqpW3OfWVnbjYMuSLCDkXEiNo7kK
	MuvA7raN81dBPCrGe2oEJecF5TGgn79qbz4T6TXlSTCWki52Tu79N+WJ6tFKEhEq
	6DVZQ9N/v9ciN2j7Ftz31A/tstxUjDssxKVmv5vyc97hwgQZ5M7g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4902b2g067-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:17:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 585F5Xw0031681;
	Fri, 5 Sep 2025 15:17:04 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012011.outbound.protection.outlook.com [52.101.43.11])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrkc9km-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:17:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lRg7JC0V2lzu+IeBcAgPxpgLw1N62nG9LDwD7txx7yhqupUI5OHFoS1sdmAmwKSbwe3dcPv3HwIqZXLppgndmbqfRkXb1Z/oAObJoKtFwq0XoP54oSddbInjxiyyixkn42SbnE41tOD2dDfIMq0YNVEX8At0cf2TDaIgPVbQOnuJYyV8hgQ0j3wfNPHaSHbDTA60Q4SxKowi0BNdV21vwTuHqfUPafGW9NbBTi8JxQOG2ERpW6SaSEGPZeBgnpPPYAaBp4aa8iy/FG/9kTuGrOWW32dWCVCx3AVYSYvkQCIWFYuoff8B6M4aD981qZo6o5Pnz5NZnfwOG8qJHBAblQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ql0WJ2L+tEQxxWhy2vYpOoYXpfnez61YuwZ8KsEoFcU=;
 b=yn+2W3s51iimkZSuRhai1XcdyXxeXN+K0B9ZZQk9H0wDrN90xkKFA6KFO3MGdWudPBGlp4h3XZHFQCGVid0g8tLNBIellwH9LuyLbNEUYaAsIm0ByGJ1MGP3upT0FHvEP4LPh6ZJMtgYTgO4ViitfMbtxPsCL5v6pwuKROsnlLfahAKOEugyhU3bnayrFUqCii3GMT9djjiqH2Ljh4DuUH8ULN3csnJc166JmQRmg+ajGsl3DVYAL/X3DMAw83R72m/GaTz7ZY9MBNYPsjluxuM7IuMtdHO4duEn4wjRU0aW/K0x27IvRNdFK8+ewN8t8LmXvUY7npjbNwzqbOwePQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ql0WJ2L+tEQxxWhy2vYpOoYXpfnez61YuwZ8KsEoFcU=;
 b=bXfGpgIUiLyS58WktaD3hBwz2p2Qowgg5avE51LDqbHAsGxmtTZu/yAbgU/Rk2B/EW/KnN7GmK5HJ52dseIgX+rT/QXPqWxtoc1c/VClpJOvub6O5w8wflutxk2QL0UaH9c8A3IYLrAEaZOQvoUnYAMshRBEvVz+VXkANQmVLgk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ0PR10MB5717.namprd10.prod.outlook.com (2603:10b6:a03:3ec::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 15:16:59 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 15:16:59 +0000
Date: Fri, 5 Sep 2025 11:16:56 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Yajun Deng <yajun.deng@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
        riel@surriel.com, vbabka@suse.cz, harry.yoo@oracle.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: make num_children and num_active_vmas update in
 internally
Message-ID: <4ifsfk44so7ychuu57mkbhujjl4lh5bxt2ufdseskunxsle366@3p6oo7qulwef>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Yajun Deng <yajun.deng@linux.dev>, akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, vbabka@suse.cz, harry.yoo@oracle.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250905132019.18915-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905132019.18915-1-yajun.deng@linux.dev>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBPR0101CA0243.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ0PR10MB5717:EE_
X-MS-Office365-Filtering-Correlation-Id: 13a9ffa3-c211-4394-a2f2-08ddec8f4240
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IF1tq0T2YXT7dlc7TewOTUN72ZrwhniJO3Rnb/ZCqlQ7pZ5b2SOj2PJkym8V?=
 =?us-ascii?Q?158Lh7CPwNh5507cbWTUIOKGNs40PdNGkLI7Lyj1tpFrHldSSkJ05VqbGKYW?=
 =?us-ascii?Q?gM7wJR4SA8QwCsm434u6mEOJs1x/9vfvcQZHCGldbK/SRfZvJ0Zr+6ChdoVL?=
 =?us-ascii?Q?wnLs4pMmVD8zmRDV8Uxq+nN37SCQ+/kjUep7KTYnnCf+cV64aus3Szlo9LAk?=
 =?us-ascii?Q?26UUQs9i8UgDz+FNAGxmJtIbQXLdqI/1gyp2+DOZ4aGrPPdz3AjTsoKVOUbb?=
 =?us-ascii?Q?TYzr7lFM6FU5IJFbrA60HkJ2e7Bf/wOABr5sIegVQHasW7Z6GUIjq68Z0l7r?=
 =?us-ascii?Q?KQXv696ERB0Qg4LnjCFm1DeL1ztnb0aB8pUmqsTAuv4QHncCp7xj5qWFTU+J?=
 =?us-ascii?Q?jdV5ZjQiGuYbRaxvKjTAlv7hoSCeITv182t8lXWWJetPyRhSu92Se2G0xnDS?=
 =?us-ascii?Q?DoxEvKkSaXDdAG9vtbLTX0FH59ZjTGlYP0nYvrpO+m8sLnoGa8L7LlCXXFZB?=
 =?us-ascii?Q?MNh6mjqpcTptP8og0qPOdaa9Wa55NHv9j8CsZzjrMgLN2/VE4wEbsP0G0Pyr?=
 =?us-ascii?Q?l2UEo2tvKYbIIxQj+JDNuh5B2NCGcHxgzgIgB1V2MBaVFrcthAURP8q/dtyg?=
 =?us-ascii?Q?9sPifkhB7L7x7trv+DivrZVoERtQ4Bt/ZoGDZq8VoT1mo0UgT9/w80qTKK3C?=
 =?us-ascii?Q?Ay+4xk0HfDcf2tBRQULGyXVKQS7Pvja7O5RL4AtUeVl2APbeKCEDVLlmEN0u?=
 =?us-ascii?Q?MHnSkl3r8j59xmq+Q7seE2uYvyk4nBtayXpTNWhxe2b7q/lOphpp6QVeDvrL?=
 =?us-ascii?Q?kZzWlaysvQGKEDNT8LZdg2/v5VCStP01xVOX/U4Cyg417RPTn2+rwb02SUaU?=
 =?us-ascii?Q?U/nBbgkFRBxJ0VCUwwFNnD39heTy3PgoXOg+EofYdecC5sGAkWSxQkymUzP8?=
 =?us-ascii?Q?uWbjT8QQfE41SeEmrThhvt/ifVUzgWBm0tFCRAoU91jNFyntEUNqLEKfFDy6?=
 =?us-ascii?Q?GWj7T2GwjymmLQaNU1+teQpn/sK6lEWc69kHjR7NK7hUuKOMf0cYMiRSN616?=
 =?us-ascii?Q?TtZNv7S/tPWp8U8NqXf66YScZXezsp573q/LOLgzQnm8LBasvPaLaZm0lVJ2?=
 =?us-ascii?Q?VXPQfrMUnIp1Tlqete8A3H2w9cHVAA9smDAdCgYUcO7I8QbQ/DqVEurySf4m?=
 =?us-ascii?Q?RT+MNZVq+GrMcvsA2A7KBuJ4Vz4ghuShN+WbQmJiCBKemAW+o/u3W8epInSs?=
 =?us-ascii?Q?gvNlCZ/dGAV5TtvjOouvc2k/XD80CbkNWhgr3Z/Vr+HJGIzImIcoHKytXD9r?=
 =?us-ascii?Q?rm7vdb2kuX3CMKSS96kb51JsPRLYQpcME4YoPjBu+ix8duDAHxULEoJ1YNqI?=
 =?us-ascii?Q?zmXvBqToCWhlao8+S5m3q5uTax617LAraE83MerH3gMD4ezMHQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XfyfuYNiaBMBdl7Ed0tzdcLXkIolGdoCP1K4T9JBCgdKZPaXE17KzAgOfOGj?=
 =?us-ascii?Q?2aj7RHEA4+q1BH/zS1DbJI0xhOR7NSsrreHHa9OFDV8Lsu6oNLUcLSbFN3qv?=
 =?us-ascii?Q?WVVh97zTBT4GNdJLJJ0DrDEJOC/eBd2RdUd68niuwdLrTtfqxuPyl3qphp9o?=
 =?us-ascii?Q?Pjuln8E4sKfcRz4olabyAjRcfMnIQnOIkalP4Eg3VaUZVablGTakfSUmFEVm?=
 =?us-ascii?Q?2I90oB3vz4J/Gt2mFrngBozu19pblisEcV0wXoBlIF3oXcgaWlL6vvbybVS6?=
 =?us-ascii?Q?iuS1RNLRS+190TtTQNJFX3CG2l0IxLvzRdD2ENHiFHCaklO6Nc20pifzK+dn?=
 =?us-ascii?Q?RkN9ZzpIoyEsQodoukgdb9O7XIAfOl8luCAZrEmaw040Z/J80j8QkultjCxB?=
 =?us-ascii?Q?DUSsaxntpMmCEMc+NWY2NYfFvW7q0q95+J++OmTDnrZLVxC18yX1aRUUrZzF?=
 =?us-ascii?Q?/lzualtLEuv69JBL0sWnHqsu2WuQu6dH52r5MKWfx0tOTHYTTF6aB+j5cr5t?=
 =?us-ascii?Q?Rce9XPJqjl4U1UbXlWIyCklPfqaoelsoOICbkmqOdlxW/tuQ9JZSV4hQoCTl?=
 =?us-ascii?Q?1PzlyZRmEZhxBFXaKTu0rAePkwCYMCGfT1Oe6hMX2ld65ALXHxRUMlMr/4fb?=
 =?us-ascii?Q?c8CzaqZzAcnugt1oox9ac89ysDufbM4kL9F1TOGnlZOSX52raWTCW0lkI0Wp?=
 =?us-ascii?Q?iwImSj0V02olGVzu3tt8zJ4dP7ZzS20QWAzoZ0V+PrgPJQxrJ86OYT+TCNja?=
 =?us-ascii?Q?L0h7DZz2nKLk6CL7xxjts4IUEqKlR1psAyTcrh2xFPdiG8K/RVJBU7JlISlT?=
 =?us-ascii?Q?BHr/2RY/B+0KFEl6oWNzChnylzGSzIwsVv5HfuDtfeb3MYNE5p47ULc9BQSc?=
 =?us-ascii?Q?CYrpr9vgiZQ+xQ5q+YomCW+7zbWv0mE/nthksloqy0HOssbIvNGniwJKc0JO?=
 =?us-ascii?Q?Y0oDTrJy2kRtR9w8xGUc6fr15FzXDCrZNLZ3PHFV7E8E40xeFGS+zVny4xzP?=
 =?us-ascii?Q?vQTExa7LXMsOQJoY0c+44dk1DIBEE83/dGfmef3VKGojYv0v22NYAI2KNKLm?=
 =?us-ascii?Q?x9BjA72BXxOlYEZczPjiBrNLDLMJwFVZAqtldqH/Siaf6NwyjVxAnx5zLNR6?=
 =?us-ascii?Q?y0EtzOAU1A+GxCz6L/7FKfxCJG3QYv58HwOXluqdFQK/fMDIeVaOtdKmdEmd?=
 =?us-ascii?Q?q5gqXUEVVKbrGL3km0ARJ8ox0vPqGONrjKkRnNB//QCWqQE/2c7RhAw1xiPX?=
 =?us-ascii?Q?mOzH3RzjmMm8z6cODXsw9ZfjkhO8mh8xgCXStK5Pg6RcWiAs+8IlA/zsaxMS?=
 =?us-ascii?Q?MUSc0tgS2mppLZXXJwcCMao90TEmitfb0zhEZMZiyVi4g6T8G+cXb+ZgZLM6?=
 =?us-ascii?Q?nouXhNfMjog94LIGy0vgbQ7JuvzNtwRBNyl5iwAxHUCzxzEsmCswzVdd6FpJ?=
 =?us-ascii?Q?iA/0hze1y62yVjKnH00p3NqGi0qEmig3zsskazxTWC0SRc/7SZWpovW/vbmz?=
 =?us-ascii?Q?LkbOyONQnCz3ojqPSO7lUESBMpZI7oNL0W0mkwgVQrllaewXy1y89jdBqne6?=
 =?us-ascii?Q?LrCMwPu1uvw8gIkSs/9gafjeP2lAObR5bPyZTuim?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	62Xi0+uID5vMpMhrGl+ZRPfynj+bf/dMqBzxZ0JbT5I+93RBVVITw7HflSvNsJlZDxVl2/+0PB8jo1mnaSk09ymmufPEfus3ldOBQvBTWujpeSBZ7amla6e5V8Pg37dLfEba+fwJn0UblKMteKdclkKef3hUISq1f28oAo4Okuuzn0sAvAJLJ4D9kloJrRM4oR6yVKv7DftwyQZE8vZGrK9dXTBWI9aVUgsVNNWWp7VnlvB4F8r5ey5fEQjbkuljfiOR9dUarSmEsmwuWmDndhAQElHBjrke4jwoFj8U2knl4KwLQiKNlIjdlKwuPdeSxUmMzfxNRzeWxPgBgOUZKUE9KDtP/tJySODFYXzePli0E3SV8BsOL7g5IaGatFnWYGXBGg2xz+i7zfRjnunS8jaQAji6a5jfLuFwyQHF3WwHdEUPPp/R75Cxxcd53hiYgaAqxA+bW9uYI/pbboRVjs65uI3kqzsOM40kQd8u6IQZFFCo09yqcuYQZqOdhvX7/KLmk8oVpybaQJPJvS+2puvpNR/l2HByoYHahY1f/Leg6UtFWCid2cSLgWtONZrwafkMre2HchZQMMnX97wihTgcYuF6eSp0SEkwOCorkNw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a9ffa3-c211-4394-a2f2-08ddec8f4240
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 15:16:59.4001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6px9RUCrTf43GB7o3Sdb48Bk5VeE68nzo77MdprmqWxBGv5ACp+gWdt6UtI6QlPGrrHfpMOlrDAStaV0mJL5ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=833 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509050150
X-Proofpoint-GUID: UVD3VfBFJnnz12cqpd3m7WhEcyuKRMjP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDE1MCBTYWx0ZWRfX+2YNtQjimpv+
 H5NcThgucFbt/3B9ZS+GTv06QajpJxt69HNDoTHCF707ADJmIgM+/XS5zI8KH4QlGI8zKZZZScq
 VWWfStZdlYKWVj9wYGG9IoTMGt640gSuJofCUe4dmSHKCtMAaRTyaoR9US0sFlcxTecVvQ5Ioxk
 xEtfl8TbpT3r2vqSTuIeOfaohDbd0a6P5+iuRDNUDqvcnyZSGg16O6HBLhqt1spzvi7dFhsMwsw
 XdfdZ071LlNSK19U52fZ+hZSWjugnZC9J/M0F00IHcEqZzUhMWCa/99jSD64mBQ0DJ4unSyOruk
 FqX/KGQfqfOBgQ3vHfkCk7rbmUu4Bgz5yv2HsoaYBrk0yKxVK5dNGHtcqPlATkX2udfvk9d6o7A
 OzTyd7HG7J1NmcHbd51q6JebZL1hhw==
X-Authority-Analysis: v=2.4 cv=X8lSKHTe c=1 sm=1 tr=0 ts=68bafef0 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=az9HnChzLeXBlw-Kcn8A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: UVD3VfBFJnnz12cqpd3m7WhEcyuKRMjP
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6637580009
X-Stat-Signature: rcfbk4dgi6khbdjsjgtth3f9s3fmqnqx
X-Rspam-User: 
X-HE-Tag: 1757085426-532230
X-HE-Meta: U2FsdGVkX1+DH0iB3v6Vqe9BW48Cwf6WCe9ubH/sTAjSympiJyH7U4sFAkk6IN3ETGNTdGzKKjpeGqQQLOj3uMwmDQVbSUomBno3F9C2jAOnafwcX2UDE1ZGq525QrGjDfhqPZGPPjgjm9nuYvhcpWSQBCkHq7IKEOES+m/ZG84wCcOVso+/vPFxykxoONxCE20bzE5slOAmTFgMdQTezWDbG/8t7LndNe/hDr5IgMxmdmt4Gy7pwLNnMHustEUGE/wJRRdUd2EJwhIYBr3L8/kC4Ja56uCt5gMhT7jbij43OABs5Ixf78zm3S8XtN6QTLa0hroTjtUdw26Kro3/czd8iYx5kycJlTmZDLLjrVG4N+MCxjbCmSXbr5/JrDyrKPfNIoCVec3nKLGf3xMiko87FCV04OPMNU1d5+GzLbZSwRDWg+Q1Av+GRwHGGDX4SeG7z+EfE8TFjE6PqxVBm4hWx7sw0kpZfQ4cZdBkKzjkPYPlyToLSOOhhL9fmHsHDu1F80QiZZbXZeqOWsLKJtuLQIaTKgeurDiGLx0Dpy4CTQwM/EOKbkrlUMY7T66DKRkAZFf15hPnnyC76ncZyoUSU0aRZnZJN9rpTm8dQkds3tcvDcLsksDl88s3wn4SmsYng3GkeF9CNql9C5VKSnudwwp+j8Uy/BKJNgNAXwDSpOF2SQbOe/c6fzeS5aqLzE31910ZT7rGUEQoSqIuosl3mIfARjM6WYcYmQc/YxKGCr8iRpvlW+DMcbnY8b88nHrwI411qcKVcvjOBPGcvmgnn9QLqKWZnT3paZYQLgPdfXR0dt5WRa6OX6Pd8ukNUN8c4tVclDPBpfTLLx6/MbFzKiovU4eR3jb/Xmn8bAHhuXE3HzUKtJmGNDj5tSIgJSpKCxIxuBcozo1MwlKhWuAUewWrdWd5kuKQF0y64rlzZT/lwh1OdkrdHaewNw+xmeSWkgcs2j1o4/qw97l
 XXbLUqzH
 RUTYDOVF39yZQgYLKeG/qdBZJjLS3/m6LmsSN5vtxzO0MJxJPyeP790W4TD2BspzIaw29mOjFFr039P0Alg4GwyRsYuqGu7my0rIMSJACFW07POd0ftuOij8gAyOTMy9Wyw4cXTfEex3uLYC/ltgaqmqtqqgWd6gCP72pu1ARxkwp3qlI9f2HTAdfMN4O1WBL85xPKCrGXHg8a0e8HTqMk14cPvrWk3XKqdVfFalby7C+wMzDfPIv+yet50I9OWaYAyO+hM4nMN0xsZsHkY9a90LnuO32UUiGnm+EipZhj58ndLkam5WBYx7pO7zyWYRhgpdNMiDStIrNl45WKVyD4joddOtE2cxyvBKOERgX07W63llxnHow9MKU/MNkg/hgY9xTors55BbL1IkFd4jPKwHKmEQivLjqGZuzCiaYzkesUgOeCcmhl6BdT/J9QkMUFd2E6wfBP2kInDhYn+GLZsAr3IkQNzAsH/gbSnW4453Jp2o2bL2eHguKd3WDK1jxDnUhUK9ouMhwDou2KzrNcbPy+8eDE06VtwM2zuYkQeM80t8U4aHAVJmUKEVh3PiUT4Vt/u8PXpe/CGdzUM6xIy00ChqpJsZ9a5dLpF8Do6S2J8/VTK8hcRVJRf63Ht179g3giaonxzFEiXEGVjKLJaIXK6d6vqj78qaljnGt+oR347dhz6dFlQiEnm/kDkDOqUirpNOdDi+khgsRuNzwWn7mbqm13hCZm8JY1x3iyXo501rw4/zk83WpT8wBBz3Y+ni93//Ihekfwi3m1OfLTsSh5Yv7FE7tjFTznkHSmFrztDQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Yajun Deng <yajun.deng@linux.dev> [250905 09:21]:
> If the anon_vma_alloc() is called, the num_children of the parent of
> the anon_vma will be updated. But this operation occurs outside of
> anon_vma_alloc().
> 
> The num_active_vmas are also updated outside of anon_vma.
> 
> Pass the parent of anon_vma to the anon_vma_alloc() and update the
> num_children inside it.
> 
> Introduce anon_vma_attach() and anon_vma_detach() to update
> num_active_vmas with the anon_vma.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  mm/rmap.c | 63 ++++++++++++++++++++++++++++---------------------------
>  1 file changed, 32 insertions(+), 31 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 34333ae3bd80..2a28edfa5734 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -86,15 +86,21 @@
>  static struct kmem_cache *anon_vma_cachep;
>  static struct kmem_cache *anon_vma_chain_cachep;
>  
> -static inline struct anon_vma *anon_vma_alloc(void)
> +static inline struct anon_vma *anon_vma_alloc(struct anon_vma *parent)
>  {
>  	struct anon_vma *anon_vma;
>  
>  	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> -	if (anon_vma) {
> -		atomic_set(&anon_vma->refcount, 1);
> -		anon_vma->num_children = 0;
> -		anon_vma->num_active_vmas = 0;
> +	if (!anon_vma)
> +		return NULL;
> +
> +	atomic_set(&anon_vma->refcount, 1);
> +	anon_vma->num_children = 0;
> +	anon_vma->num_active_vmas = 0;
> +	if (parent) {
> +		anon_vma->parent = parent;
> +		anon_vma->root = parent->root;
> +	} else {
>  		anon_vma->parent = anon_vma;
>  		/*
>  		 * Initialise the anon_vma root to point to itself. If called
> @@ -102,6 +108,7 @@ static inline struct anon_vma *anon_vma_alloc(void)
>  		 */
>  		anon_vma->root = anon_vma;
>  	}
> +	anon_vma->parent->num_children++;
>  
>  	return anon_vma;
>  }
> @@ -146,6 +153,19 @@ static void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
>  	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
>  }
>  
> +static inline void anon_vma_attach(struct vm_area_struct *vma,
> +				   struct anon_vma *anon_vma)
> +{
> +	vma->anon_vma = anon_vma;
> +	vma->anon_vma->num_active_vmas++;
> +}
> +
> +static inline void anon_vma_detach(struct vm_area_struct *vma)
> +{
> +	vma->anon_vma->num_active_vmas--;
> +	vma->anon_vma = NULL;
> +}
> +

It is a bit odd that you are setting a vma value with the prefix of
anon_vma.  Surely there is a better name: vma_attach_anon() ?  And since
this is editing the vma, should it be in rmap.c or vma.h?

>  static void anon_vma_chain_link(struct vm_area_struct *vma,
>  				struct anon_vma_chain *avc,
>  				struct anon_vma *anon_vma)
> @@ -198,10 +218,9 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  	anon_vma = find_mergeable_anon_vma(vma);
>  	allocated = NULL;
>  	if (!anon_vma) {
> -		anon_vma = anon_vma_alloc();
> +		anon_vma = anon_vma_alloc(NULL);

I don't love passing NULL for parent, it's two if statements to do the
same work as before - we already know that parent is NULL by this point,
but we call a function to check it again.

>  		if (unlikely(!anon_vma))
>  			goto out_enomem_free_avc;
> -		anon_vma->num_children++; /* self-parent link for new root */
>  		allocated = anon_vma;
>  	}
>  
> @@ -209,9 +228,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  	/* page_table_lock to protect against threads */
>  	spin_lock(&mm->page_table_lock);
>  	if (likely(!vma->anon_vma)) {
> -		vma->anon_vma = anon_vma;
> +		anon_vma_attach(vma, anon_vma);
>  		anon_vma_chain_link(vma, avc, anon_vma);
> -		anon_vma->num_active_vmas++;
>  		allocated = NULL;
>  		avc = NULL;
>  	}
> @@ -306,10 +324,8 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  		if (!dst->anon_vma && src->anon_vma &&
>  		    anon_vma->num_children < 2 &&
>  		    anon_vma->num_active_vmas == 0)
> -			dst->anon_vma = anon_vma;
> +			anon_vma_attach(dst, anon_vma);
>  	}
> -	if (dst->anon_vma)
> -		dst->anon_vma->num_active_vmas++;
>  	unlock_anon_vma_root(root);
>  	return 0;

anon_vma_clone() has a goto label of enomem_failure that needs to be
handled correctly.  Looks like you have to avoid zeroing dst before
unlink_anon_vmas(vma) there.

>  
> @@ -356,31 +372,22 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
>  		return 0;
>  
>  	/* Then add our own anon_vma. */
> -	anon_vma = anon_vma_alloc();
> +	anon_vma = anon_vma_alloc(pvma->anon_vma);
>  	if (!anon_vma)
>  		goto out_error;
> -	anon_vma->num_active_vmas++;
>  	avc = anon_vma_chain_alloc(GFP_KERNEL);
>  	if (!avc)
>  		goto out_error_free_anon_vma;

At this point anon_vma has a parent set and the parent->num_children++,
but vma->anon_vma != anon_vma yet.  If avc fails here, we will put the
anon_vma but leave the parent with num_children incremented, since
unlink_anon_vmas() will not find anything.

>  
> -	/*
> -	 * The root anon_vma's rwsem is the lock actually used when we
> -	 * lock any of the anon_vmas in this anon_vma tree.
> -	 */

This information is lost when adding the parent passthrough.

> -	anon_vma->root = pvma->anon_vma->root;
> -	anon_vma->parent = pvma->anon_vma;
>  	/*
>  	 * With refcounts, an anon_vma can stay around longer than the
>  	 * process it belongs to. The root anon_vma needs to be pinned until
>  	 * this anon_vma is freed, because the lock lives in the root.
>  	 */
>  	get_anon_vma(anon_vma->root);
> -	/* Mark this anon_vma as the one where our new (COWed) pages go. */
> -	vma->anon_vma = anon_vma;
> +	anon_vma_attach(vma, anon_vma);

So now we are in the same situation, we know what we need to do with the
parent, but we have to run through another if statement to get it to
happen instead of assigning it.

>  	anon_vma_lock_write(anon_vma);
>  	anon_vma_chain_link(vma, avc, anon_vma);
> -	anon_vma->parent->num_children++;
>  	anon_vma_unlock_write(anon_vma);
>  
>  	return 0;
> @@ -419,15 +426,9 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>  		list_del(&avc->same_vma);
>  		anon_vma_chain_free(avc);
>  	}
> -	if (vma->anon_vma) {
> -		vma->anon_vma->num_active_vmas--;
> +	if (vma->anon_vma)
> +		anon_vma_detach(vma);
>  
> -		/*
> -		 * vma would still be needed after unlink, and anon_vma will be prepared
> -		 * when handle fault.
> -		 */

It is still worth keeping the comment here too.

> -		vma->anon_vma = NULL;
> -	}
>  	unlock_anon_vma_root(root);
>  
>  	/*
> -- 
> 2.25.1
> 
> 

