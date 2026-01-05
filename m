Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78CD3CCF2C2
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 20:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 009A26B0096; Mon,  5 Jan 2026 15:12:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5346B0098; Mon,  5 Jan 2026 15:12:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC336B0099; Mon,  5 Jan 2026 15:12:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5E9E6B0096
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:12:25 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70C2CB771A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:12:25 +0000 (UTC)
X-FDA: 84299007450.18.BA7F8E7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1A0C8180004
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:12:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=piI3AcAg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ylLoGMMr;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767643942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTfiZyf/2+UgnsYJ9XqdaZsbFBQjH75YOxTKwUXybaM=;
	b=1QK2xJZyouVjDosENMU/YcawWQAaCMu2SSuB2dWLMTKI4rQ9G7Wd8fEh7Yq6FJKBBZgO0N
	5Ltmu+yBZXdd1OZRHfkUo3XVjEqG5/Dy+BpB4fr/b/gMoUNHyucf6/kQvvLi5C1GwYou8Z
	6nvhQwqMB7n+dGuZCEe1V4VgWxqP08k=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=piI3AcAg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ylLoGMMr;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767643942; a=rsa-sha256;
	cv=pass;
	b=3elFHsMe3/TfyWcf2OC8QeTCAHN1ZJpM7v5UEIcF8xYpB09Ud+Vdr8mjh4ljYW43NdIVea
	W7Je8kIgL3n1MvI6ERQ/3R8nUpkSAgKyjBjKD/HqlCsDepNsKsKk++cwgVkcBIHTe21bw4
	aOHZqzWZkjQWupVegTydAAL0zBo2rog=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605HpM7w1935090;
	Mon, 5 Jan 2026 20:12:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DTfiZyf/2+UgnsYJ9XqdaZsbFBQjH75YOxTKwUXybaM=; b=
	piI3AcAgPnmUsKMw9tedns2NbD1Q3bQYrNxoM4E8/o5if658+Xb/z5DzTJoS/O7o
	BLsEhRy9AUPL1Ah6QeLPgpX3sKn7fW8FM9+fIUbCb8DGKZeSfYp4Sa2c/lwPE/wu
	/C5R8aYdrMhVjjcgthvFHq3YGsMLxVdMpBU6TsXauhCAsHkeAiPnpCkWQ5eDGfSt
	n/f+CZqoXESabxL+oq0sEzDi3j5DDD/XjAw7JJLXRHmI32x7ZOmFKHC+1bliIZfQ
	fe9A2tAhJ9kUjCBlXlz0+GcC1z70WtgtRLGaxNo8X8j7CBROxVIr1z1wo2yvpCq5
	w8/DMzxzXFsd6xmfRDVa6w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bgj2c076y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:12:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605J8Q9E034230;
	Mon, 5 Jan 2026 20:12:14 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012042.outbound.protection.outlook.com [52.101.48.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj7sj4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:12:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bexTJUCYfKXntCArC22OfbYmENDiLBTOyCI1NCid/5Vyffqb3uEgstk+0cfuwJuyApXU0ZDkbA9Cko6TowDu2u7KIRPF05/S/eR7iFVRTTnSpgcInfKjyFK9NSzJz3lVljkanxfZoGdEp/Lr/3Ws8KWKrDduCyyk2C7xAeWumPOYh6W63T0Z4RPMQDqLw4bCT76EliLbBdUskdj7M39n0u6wnkP/g1zs9PkwFDsmFjeNjdgcjKHDfkA09+u2xe00OTadjQ95NOdbATUaeaw7PzlEzyAz1lL9EiGyi8cnKFFQnBhDsxnrdI8OULg9Cgynro7RPaXTvyHd/U41F766dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DTfiZyf/2+UgnsYJ9XqdaZsbFBQjH75YOxTKwUXybaM=;
 b=g7JXV4d5oba3+LIUknIPts2ijxFiNESeBjTsFbHPjrD+2crfLT09YqAj2+zN7OI3mZaTopE/zqmidCW/2CevJ+/kPPwczA4jnLrtjHT8Z5htKCobeH/4nxv6OusOxiGiDDs28p+UgsEuFLRVTtRIWxUdgYwxC0CtfjJ+LkskmN8/dDZIN8eQi6h6HUPiua/NHiIWEtcpOFN22Y4oOgRoZgtgq0j69cHH8c1II8XAbk6xamkM+MwLo3zTy6axYY/iXC/LlO6Pp+3CWz8fqimFHpEy2Wx/mibRaaBXep6bBveK4nvREZ9lvwn23kIJtiNJ7ZK0/GQ/T1QS/9bsZhuxyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTfiZyf/2+UgnsYJ9XqdaZsbFBQjH75YOxTKwUXybaM=;
 b=ylLoGMMr1gs211YbmX8oFTv3f+K75elMFLmX3R2jtRk/NqZSAzlM8eydhfccDmMtzxPKKzjMVZbPVOr+0I7ObdRa/wRhIqFtMPGNwCZUISABKeFXai5p2eoLTYT4Y8fZ5WsXc0yjJQ5C6N632WOC18jmz+jown0iQi8V3hD0eNQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPF136884A98.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::78b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 20:12:11 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 20:12:10 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH v2 3/4] mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
Date: Mon,  5 Jan 2026 20:11:49 +0000
Message-ID: <6e2b9b3024ae1220961c8b81d74296d4720eaf2b.1767638272.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
References: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO3P265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPF136884A98:EE_
X-MS-Office365-Filtering-Correlation-Id: 9414e77f-e510-46ce-b51c-08de4c96b547
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OIYZaO64Tl9FvTcvn4VV/IA1q/45Igx+N1S4849A23NuCCj3Gc14/F7tPvZf?=
 =?us-ascii?Q?RUFIlnLZ2dVG3A/8d1wQvTAMCiNqJsutphfPx3Vjiu2Ka7qbTEKdDtWBbMl9?=
 =?us-ascii?Q?TxS+eCzWly6v81p6iTcsjCwXDEZnsj63hhn7aPabQ/CHrPOuOqnID4KLLBJl?=
 =?us-ascii?Q?Gmu8fyUJsx/ME38y5wJ53hFaz7Y/JWR39Q4pFVMINGR8rck+wWxija6AyCqB?=
 =?us-ascii?Q?sgQtoVSFALW7DVXLVuR8LFNGejqPAxqTrISAiTj0i3fHiuqL4FbO9tfGQSXd?=
 =?us-ascii?Q?1NnyxFH8aHJImFt3G5AUvu8rdEiC1az5TiJaRehcgH86hqPX9Tsb8ktlxS8v?=
 =?us-ascii?Q?8WOy+K8CIzM4E90oWE/odsH7Cl/ShDCCRUUxFTXPoCZM2tYmZZoEmDV4xQIm?=
 =?us-ascii?Q?oW41FXHQAlsDp0NKuB1Ja6PRVTtPohauBQihFvfsmOs9g0Zl8WIaLNO57enq?=
 =?us-ascii?Q?l3bH8yS1jcWh2i8j02LpoqjNR58QJ1vOrfb7haVAUrYM0b13DDoIgMhm5B/K?=
 =?us-ascii?Q?lx2m74+1kxKJbr+EBYKkcsJASS/lVoaI2tvkfsZv4BX6OzLnZ0ksgqOqyk5Q?=
 =?us-ascii?Q?Eo/prAvRqgSd8EUC5ikvLfnzqnhzeO/3XVF9ZUz9z6xQOWrKjLDVKO5kbNpu?=
 =?us-ascii?Q?q9v2+dU16LhE9akYt9cN05jr0zs1/8fRas45IaH3+4PJNmy2W50s3xiIT4MQ?=
 =?us-ascii?Q?1uEs+u0RaWEXrdPI0YdDk9+5fixT9moWYTyG6d15kMKYcNqNwJvKt+w3mbir?=
 =?us-ascii?Q?8XInN4O75NwJUagoY+DrZ9o1Hbuqh98z7p2UMI2vgAD/tAW1TV0AbfmGuoz6?=
 =?us-ascii?Q?9Cu+k+gwR+pIfCktiXBIlRgFv0wqUznRuu9yy/3mGoiiGpnhu2dT7Xo/UUwM?=
 =?us-ascii?Q?NcAqwqo2AUDLOr8ps9aiCav3SyEpFYJFdyEsbfRotFx3Okeg94bsyd43sb8p?=
 =?us-ascii?Q?/Jwy8pk9Vskgz01sGe44OOzfmAywYW/KCJd53oKKMVRYNY5DSxhaCFoablT1?=
 =?us-ascii?Q?OVZ2Q8eKVHpmgQRKzzdkVOBofIamFZyj9cVg6h5CZ8c7EXFZUTZLbjnv5c9d?=
 =?us-ascii?Q?J3KpxmUwCQSwUSNy+UjVxXCZSUygMNf9U6be4yFrHhOYuPZOleh041wjyzcZ?=
 =?us-ascii?Q?rqw+dLfBrnWxQA4mz6JiRWIM8HotpaZjZeTIMxT+Svmiyyxfxg+FnwIvyqQ7?=
 =?us-ascii?Q?Rvh+x6tspdcJ+QYa5uu/AnnrMhlwk/zcDACTBu2o2ebY1gi4x/7r1KZxgDYS?=
 =?us-ascii?Q?JQQO9NRoco90H68ab3i4ZEcgX4cLEF4asta6kZh8rZXT/9lUc6ACgHblC+CJ?=
 =?us-ascii?Q?m9qrRwTYrFjDnf75vx9RZ+QozMqx2dwzOs6aON8NY2CtFWN7yl85Z156B18y?=
 =?us-ascii?Q?9zMLbUQT8LbKEsBZWguQiZX9si+Ta490RsuTiUHrE2shbRdocQxLPMQKuY5a?=
 =?us-ascii?Q?/ngvj37Tv85NeLtAXANbHXIvfvDANOgf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZGZrUC4qXORQmA8rO8+X8JImEj7UCPNkuyoQeixfi2JGaKScYVpE9E/lDQ1R?=
 =?us-ascii?Q?gY7eFFSERTRIx4HAto86+tFoFwf3SxkTY8r7Qus1BrSlFJAwPBtONU5u8oSf?=
 =?us-ascii?Q?etbNmg9JAaRvr6xEe7x3PV0DNrgwj1ES72XjuFgfmLl936XHbzM4CmWqhbP/?=
 =?us-ascii?Q?ljTtrKxnRRfaTNhzfupMFSTx+BBqCD44QzWOYT8PZurbdaK7ukA6UYJ+8lLb?=
 =?us-ascii?Q?eOTld4jMzDB6IFv0tKu6+6ZA6MfXXFvq7D9Mbc4ySiG+17XcPsR2KmxrNA44?=
 =?us-ascii?Q?9WRDdSA0JTtwpCenE5et8QSxMDebIf74bv6qvd58u5X956irAtO36nrc7Hfg?=
 =?us-ascii?Q?hNAPpo3X3J3PmA6/nKiIiR3aSAWVGS2yiioIlxa7m5iZRzO+zUCmgNs6AUci?=
 =?us-ascii?Q?BYTJD1NRidIq7EOZQy8Ct5T1Ryl07xXJpO86j6+zM5nt8sGAiBA9ShvT7sXe?=
 =?us-ascii?Q?Cpa4+znKpN4F/wIqdZJt0uOpFzFjXoYgy7UONfsfOt/mMb/6TYSHkrUPNhOl?=
 =?us-ascii?Q?jMU5rWWfNTdhCPMQD2hsxIQSqiDWEyWnlEIVgDFrQCRl6MifQMtqMfRnNDTb?=
 =?us-ascii?Q?eWezWxIxsq93DZ1SNilWjkQHo/azw7zUfSlLQT39cdQPC4zTm/a3ugIDa0fV?=
 =?us-ascii?Q?9qK2S0/zgSQx52ZZgOjWCe5KKKVkzIeRYTszHY2bl1frAtgbSsh6s6euXzhp?=
 =?us-ascii?Q?ooamrijYrHeqNK6fCiug+cAnfV2EzwsuaqkMwduvgr/KtXql9g5/1zPudX74?=
 =?us-ascii?Q?QXZIv52YiSQf1HtaI8eMxO7Pwh6n+p2B4L1j154gSKOSmCoOusgG8xoZ6QOA?=
 =?us-ascii?Q?80C06HbyyC6Oh8Yfq/kl6C6JsEd0OIMhONWOEY3r0sdHkFiUrj+d793q3fJf?=
 =?us-ascii?Q?kG/8QIG4VBA38OPqmOilb6PSeKgJRrnmzfFK/TI0ns6hHLqCitmxRzGKepa0?=
 =?us-ascii?Q?pQ2CqQhooMVDbIsxYfGUZJxMo6Hebb+vXsAvvRWd+T16xibubtlkD74qoArV?=
 =?us-ascii?Q?PF2Pa8qFj5KddYw/8USPX2LdZR3zm4A3at4zs9mPALMF7kX3IeulWqWUgR+E?=
 =?us-ascii?Q?ooYyxzEViu4aMqYXqtekcr/keCuVRE7q6WDrmJRiEygV0h4sbz/GF300+zAm?=
 =?us-ascii?Q?w3ZMGLGvcs4T+2izMBJBT82DEaX4BUr5hBineJNgq+J1ISxGkpOpJlceBLcM?=
 =?us-ascii?Q?nEKJe1OYy2SxE1lInRpaeQ/dp+X4l7EKQpP2uob18PeTAIQxCimcoq5kQKq9?=
 =?us-ascii?Q?SQ1IyVrtT557d0LAHqNOn7dCyiZ/bAC2qPq31G3rjd2XAPEe6CddpNAiVq9H?=
 =?us-ascii?Q?f9/Y1r+nhzEg8k9pqMpPOkXnUd/x6b5OK3qBAo/f6ttIYHfXQETr5DdbjgfS?=
 =?us-ascii?Q?6zre0jwoaA+kMD50gWRxf8Ky96VX9w80rFdRQBoeSlbq5a9xbaCfQJ+Xl9xa?=
 =?us-ascii?Q?2olnsMmj2ebKhG6huIzWqR/GII/8I4z4AkmP4MfMD3qR4eNReOMqyW4GUgIa?=
 =?us-ascii?Q?K/tb3H8xaRVXh45nTrppFIOi7u6KLJwS/pIOpaur0MgICCTkIyZtaQwTlKMm?=
 =?us-ascii?Q?yNM26ZLdZQfVZeoMUMd68D3q20vSW/t4nm6YhnbERyZP7Jav2QGv7WPY09Gz?=
 =?us-ascii?Q?DzmcgNacRN6e9gBsYlILhxYTvwJePN4iFdw835ZUwSBP8WDC0hWgx446CP+h?=
 =?us-ascii?Q?aa+dYTHKYQsB0KZfPuRj3DYGS9Hu55o/rSdzthkIyIK2vyWozZtSJyIpytDL?=
 =?us-ascii?Q?yAu11ogJNBAuRFLr/d8PQ5dxznOr+CU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Xte8+eNKrwJT8OlXzExp7HvideHd4TK6+9DnzEl2W8B8CfDH7Ge+OZ4p3bpVh81AzB56UKUguLfmpd4licvkQ4cqaotCQEkiSNBkVA+CTLiKfTNbMhp3thRBs/wMzqUp5ZADP63xvbrxSRkaIdEIZOJL9laDteH6RwWMcbyWWEZYHncQRGuUshuspGxavxxzGeOCstRXS3+ZI+VQBvaAwtnLnCgqAYTFrbXjG4NNYmDjJ1V4pu5DEE82gxro36gxyUPJLU1vB5m2alIIX/qb7vKmVVhSThVsIBI755UpmSUbmBDlebxP8HAxkl6Fps91BfhOmb5Dl1Cdifg6lraXPUqxD/Jc/C1L+V6XzNUD6iA3oDMOiAjY2WUttaQo04TbPuL09KHiRmimxnN6z55tWJXQYUqJtbRzRxmaBAwwA1ryhFH9pdHoNueaB7GrZs/iaxymMaHVKrgUgWyTr03k89oikZv62vhqavjJv+Akmr/6T4T/RGiYvBEGBTV9t/c3bLBatfuDvjvbeDq4ZFpvG8d5wrQbqzKBFQ3ccFqsmW7B5yx4SgQk/rlUVPKe6cyJi9fvsqomfjCIAqUF/1yq6dDYXcBL9NaGBVWpLkqoN2Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9414e77f-e510-46ce-b51c-08de4c96b547
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 20:12:10.4438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0XRRGRbTB05IfIGgEVOpRb6Gn8UvIuV0nYKPcKZOwk45hoiZrecbO1O0H4MEhbiyyrWxYWbU2nJFb09yKD2jrBQyH9KW9QMGDMLClxexmnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF136884A98
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601050175
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE3NSBTYWx0ZWRfX7y2St3e0wNZS
 w9k7mKIH4X64eauyzNddzd9/+R5RdryxLlgsSZMMhVKymGiEZ/UBuYkJi41jlKdsny+SkiBMONk
 QIu/hc1X+UtnZzHe1pDfZ1ckc9elyTh69b+7lLzZ8/RmKeIfDvG6xzmmLh8594FUE9zJ6X2OtSb
 F0B2aSOJCHvTnmOsdRmKwvTbbIC7iJAg9YusTpbKrN/tmx2Y53ecuBghGsx8s136u5fNgAakCXk
 VseN/5EjPPk/6iVc3aW1iBKUMW6eOK4YYlg1Ons+z6waPbBoG2+IlJhcwLO6YK6I/Of2ZGD6iCT
 n+mQSdLr8n/lTWyRLvRS3TWTizE+hHRNiqY8+k5RluQPI0Qp/AFjhLpqdHMfdfu/jDSWQxTiWLO
 NwdG4iE5m/3Hr20EGwehEqZ15cCHLqVBAaJ+gKFFU+TM+fymhzDtOJ+gmUDxScRoVz9IEdcKwtF
 1d7W/+Zpag+n+axHV0w==
X-Authority-Analysis: v=2.4 cv=KeDfcAYD c=1 sm=1 tr=0 ts=695c1b1f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=2gQd8Ctu3wjniymgDV0A:9
X-Proofpoint-ORIG-GUID: NSmt2m0f8laVrUQsTVtxBb5FS6k7tgDd
X-Proofpoint-GUID: NSmt2m0f8laVrUQsTVtxBb5FS6k7tgDd
X-Rspamd-Server: rspam02
X-Stat-Signature: 5juasoiydkx3nzo16yx9uzqb7iskztf9
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A0C8180004
X-HE-Tag: 1767643941-27726
X-HE-Meta: U2FsdGVkX1/7VaImD4EdYBppnQYsY/ybkaygL4bmVZO5CT3OlofwvX1v+fRHPwJKzrHf0Uzpc+hYs17g2U5UUVplsPP2oA+SgfA0qromFCNhlO1DiilSQ/LcYQEfpvGIatRmZzg17jIEGaozDw763KVR45GhMMOlqULNqnWnP+sSk0RGXfIn2s+xbpdXqJZZhBEJWo5UyMK9gjBKjUJkGA6u2qaKQU8UN67l/LPzY65WjF07otmNRyqxoMoihXK0QCtAVd1GB7Dwl2jyjIq3xHRma4jhR4Ary/JyyT7UXpRiq1LB/r247K/7FUW0ff0JRLiK9q5FwJ+bdW3Mgi3xMfyz+kv1nExropv8raGBYzlHUGCDlQ+ReWNKOQA3+g79iclPc7o+6nyI53JYRLgkzdjZb6ikHiPxb7qdnK9gt3Lzeas7stLgYt7fpsXnUCCzABLO2pVv2E3thzkE04z/W1mR4+aZDw1I8wjzkoUTOIlj3tyI6rI3Q/g2ZdIvR6hPvO6Mc3c74v9S94Ya94lCTKptLuP9C2m9stYt3Awmi5FchA8jOAqT8/DxpV1F9MKn+LREjQsMu/k1tOAux/QOv3PbzRYuSy/RvUw0CGuvUyo5pC36UGUPeoP5uQWsFacD8GhTYvUEGQgP0YCuukBiA9WGvAnHA7M+OVcHhKAvjONaf9ELWIPCEfddb/Q91xtZUgZu1vaXkKPtjAm3TZ7x8BWHSczBuD81bgeUz49R57AyBjTwKXjxgwE6cL3+vjfLl+0MuBUHHBp7hpByayiq+DZxscODBCiSn4k/tLpVeyEfzVjvSxB8CZ39Fwz8TqQM55O4rjMm40q+5E3koXJFyvjRENsYO27wW2jhieqkMxxeFN9kvIgDpH8qGFgivaDegHorRHN9ocVJIjl6aIypx7eHLZ7NcPKc0zuB+lLx1elliNS4m/wGY9ZyjneC72daTNGmxDEqRCMp/1WL/gD
 vUNahRp3
 ZO1tGfixTLed1kTh0GBAANtf+Qjnvl/b7RH7co7fIEUNnFfPbLyRXsh4Lgnx7DBnFQvAy/8mJauOfsqaM998FSuNOdAyKOp9GrVaSJCtCwbXiNoQjfHPlA+dISlqKXN7Bo9VRhwOM9WAEQ3P53BElaFnYeCg88asVCXMLbaCra3jPDIzMiVP4y1IquPwXzTte2jRNiuzkql8lnEYXYHDZJLlBdPr740xBwI5246TCmWZz2tbUpDaW71vEreqfmHPYpjFR0k7mPzhlpx/x9k3yALa26zdVw/ZkjVXRObsrtwUrvq14YsmjjRcm++onI7wOo/j0kR+Urj7BcKsaTPLX14PU4US6/O44e03LWvSIFF+3A19TAgI+1XUdsp3aiXb0ntV55NqrBCkQgJTOWZxa8VcnMLbHMPAS6z8hlPvAot/Dax1PWUn/5+o9JWiuZLAcZyh/MLl0Gb7FTQhyl6wA1uJAbLi4oXzXdztNf0aJ7t55CFYT/LW0OiFze3i/3cNexLHU6hx1XGczIWF7KP1/4dysLkOlofRmY9YKeGhY1zsZu4vRro91w5eUdBZRhW8S6wTPXda8Wc5HXWGYKcwGJedtJrPQRU+KtFBQDLmGseGMvqFVhuDTKCuqYjoVUYRiyS4lNKx/lYVybK6mnhvYpEDQ/yjLVB+la+kV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The is_mergeable_anon_vma() function uses vmg->middle as the source
VMA. However when merging a new VMA, this field is NULL.

In all cases except mremap(), the new VMA will either be newly established
and thus lack an anon_vma, or will be an expansion of an existing VMA thus
we do not care about whether VMA is CoW'd or not.

In the case of an mremap(), we can end up in a situation where we can
accidentally allow an unfaulted/faulted merge with a VMA that has been
forked, violating the general rule that we do not permit this for reasons
of anon_vma lock scalability.

Now we have the ability to be aware of the fact we are copying a VMA and
also know which VMA that is, we can explicitly check for this, so do so.

This is pertinent since commit 879bca0a2c4f ("mm/vma: fix incorrectly
disallowed anonymous VMA merges"), as this patch permits unfaulted/faulted
merges that were previously disallowed running afoul of this issue.

While we are here, vma_had_uncowed_parents() is a confusing name, so make
it simple and rename it to vma_is_fork_child().

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
Cc: stable@kernel.org
---
 mm/vma.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 660f4732f8a5..fb45a6be7417 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -67,18 +67,13 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
-/*
- * If, at any point, the VMA had unCoW'd mappings from parents, it will maintain
- * more than one anon_vma_chain connecting it to more than one anon_vma. A merge
- * would mean a wider range of folios sharing the root anon_vma lock, and thus
- * potential lock contention, we do not wish to encourage merging such that this
- * scales to a problem.
- */
-static bool vma_had_uncowed_parents(struct vm_area_struct *vma)
+/* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
+static bool vma_is_fork_child(struct vm_area_struct *vma)
 {
 	/*
 	 * The list_is_singular() test is to avoid merging VMA cloned from
-	 * parents. This can improve scalability caused by anon_vma lock.
+	 * parents. This can improve scalability caused by the anon_vma root
+	 * lock.
 	 */
 	return vma && vma->anon_vma && !list_is_singular(&vma->anon_vma_chain);
 }
@@ -115,11 +110,19 @@ static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool merge_next)
 	VM_WARN_ON(src && src_anon != src->anon_vma);
 
 	/* Case 1 - we will dup_anon_vma() from src into tgt. */
-	if (!tgt_anon && src_anon)
-		return !vma_had_uncowed_parents(src);
+	if (!tgt_anon && src_anon) {
+		struct vm_area_struct *copied_from = vmg->copied_from;
+
+		if (vma_is_fork_child(src))
+			return false;
+		if (vma_is_fork_child(copied_from))
+			return false;
+
+		return true;
+	}
 	/* Case 2 - we will simply use tgt's anon_vma. */
 	if (tgt_anon && !src_anon)
-		return !vma_had_uncowed_parents(tgt);
+		return !vma_is_fork_child(tgt);
 	/* Case 3 - the anon_vma's are already shared. */
 	return src_anon == tgt_anon;
 }
-- 
2.52.0


