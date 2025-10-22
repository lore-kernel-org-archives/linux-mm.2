Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D06BDCCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CAC58E000D; Wed, 22 Oct 2025 19:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BDC8E000B; Wed, 22 Oct 2025 19:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85848E000D; Wed, 22 Oct 2025 19:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D89868E000B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:56:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87508BB361
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:56:56 +0000 (UTC)
X-FDA: 84027413232.03.D78AA51
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1314DA000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:56:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eqDAjbFy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nuVP8fTp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761177412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIIKeO8ZqGdua04q9V0iGqkhStDgkvFBIOgwyUOc36U=;
	b=nwor05W0opP8e3xHykFfSb2YhWfqPFkih1ooCqSqSXqeaW8REj+rN2LC+VvwtokKiZVKKr
	YZVf0qfgl9KDpQ5owQ5C27vSHJQ1M/Bh5GJa2joVUvIS4+N0GIadqQZhRF4fspmMRaVkPz
	j++LCIzwVtwnqQtWyQ+eZ0rpdWDdeKw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761177412; a=rsa-sha256;
	cv=pass;
	b=CVE8FMjR2OB/MUFpw8CvxzVEVMRd7HYKxuTlEQ43MQQiQ61OlMsZStibpM/mL4Z93x32Sr
	t7+zLuBmeKBmYCEX4TKTklaRyn+lg86rHGxZm6ykFLwAe+6l1WdbfJnPeu/wK9S/yE7mbj
	DbF0Wzypd0LbekriqGBWSVJumJp/BtY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eqDAjbFy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nuVP8fTp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59MI0BkW021553;
	Wed, 22 Oct 2025 23:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lIIKeO8ZqGdua04q9V
	0iGqkhStDgkvFBIOgwyUOc36U=; b=eqDAjbFyPMJ2/YfgOZ6bCrfqdKgjQ0Ci/u
	AMvV70j4WoppxKS7jGNecazl95MAylf8Up6fBm+cUy88SpDCgtKhgDhTOBvVsVE9
	7K98jh0EQP2LzLj1qAyv64Rvirair0N3cEhq5xV212TFNeLSjGlH3VS5HnunxZ/e
	xbCI4B+t24UGKbQeYjxodi0UWCHmRpzW0QeVH5lYT0ygo6t+f3SIGLbLbeKJifzN
	oHDz2jtqgFCGYcTP/wFXIQ+FRcpOtw6oj7H5wMGef4GDUAOULTiMEnC1lTCigMFT
	nV+mMmyt/38/w/Y8vxt9XoBshcG32MN69uz6GUACSiwapym0u5aQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvcy9gmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 23:56:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59MMFu0H022373;
	Wed, 22 Oct 2025 23:56:46 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011040.outbound.protection.outlook.com [52.101.62.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bevu70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 23:56:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BE1z1y1Y+5I1hVl8h6+gd14WVEP5mkiZZbPiyCL2tshSC/wuqX0QN16Iw2bHdn3HSctwD4jZ/xGKl4CozkT5GUUqCjcl2V+rOytGPtPuQ4nEhB4/RVwxdoFAyWt7jxIyycrU3uZDUp1qKeXbQvAFMs3mTM4lCb57LmfxP1oLQZxX8j6mB6T0KvA6gaXX/6MILj6woGNTBsxcoF9GQIylsgxgjZmOrHsWa7Qcu3isUaoe8dDLtNzVlKRrHsNNfLVTTayVyJlRx1Y6l41sLFIJFmERslBeWH4tO5teO8OwFC2qqDntBk6lBIIzuzJO/8iry4zB1Inrpv8lYiOOYD7pbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIIKeO8ZqGdua04q9V0iGqkhStDgkvFBIOgwyUOc36U=;
 b=VFXOnO+tui4nUsAAomhVzCB8tO3lLn2zwo2OBABvMXUEWne8kCtnue0lHjld49hqKUf0EAotdOh3ToZrzaNT95NTz3qx3QyDbfU88LqQNvEhSbOsdNIz8yT6Y7bsmdo2H1vkT3Vo/8TiPVLGyrzd6WgWOK2gvIRTLYa+GVBU3hW4wZBEwdoScy3oNh3iYD5t6p2QWV2X0rL703PRElWpnazt8tgYpRNbHLzvBEKm7ELJlXkB1nL88xvNhW6kNDAwX2FXahU9Irr7qzgceBGZZYfqSN4f7Mi3lk6sY7dyF1CeBKqqhSiBs9J/2Ol1nPaclbRFLaZWVNKC7byYot6njQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIIKeO8ZqGdua04q9V0iGqkhStDgkvFBIOgwyUOc36U=;
 b=nuVP8fTpBpHJEMYPUku23YEnpfRNpcronWJE6mKOqXI88LauZosqyYHf9i2p6ftYg7WXUU4X/sbGAuY/9ghdh/Q5R2AE/ozMmZxtM9BRw/m6FXJlkNsQb4CCECjZwmbCPgxmYRiCYQvDMKfxFKa/C6ebKAEUPgY8D0FkUpEFn8g=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH3PPF476853C3F.namprd10.prod.outlook.com (2603:10b6:518:1::79b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 23:56:41 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 23:56:41 +0000
Date: Thu, 23 Oct 2025 08:56:31 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: perform inc_slabs_node() as part of new_slab()
Message-ID: <aPlvL0dvc-sL-TcM@hyeyoo>
References: <20251022-fix-slab-accounting-v1-1-27870ec363ce@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022-fix-slab-accounting-v1-1-27870ec363ce@suse.cz>
X-ClientProxiedBy: SEWP216CA0134.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c0::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH3PPF476853C3F:EE_
X-MS-Office365-Filtering-Correlation-Id: c7be6345-8479-4fe7-e356-08de11c6a534
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+CiwSHu7QeUd1hVAZKl/jG1yd899e97UmlgCbgmBR0ewh221NtRhDftwmQQo?=
 =?us-ascii?Q?4dzJtgbo5DVIYkSfi5vM4VmGZqSQgE6yEGpE0xfQuRS0h2KK8FSXf0fAohAo?=
 =?us-ascii?Q?BkH1JNpJsqUlL0vuneh0ITKopnInyeewpCg25UslpF6ZaDd9w/5yy2sEeFaz?=
 =?us-ascii?Q?oBdvQIRNeUFXn0tNBeU73y0I06vFHDRk4xLzyhYHzc7rFLm5+MZOp6ubc8Za?=
 =?us-ascii?Q?kdyv5xGFhDjbp80zqh+baXubFF9YfmKXqVLaW/eyQcwvjYLN9NXvHxQmtYb5?=
 =?us-ascii?Q?xSyLtsLVwzAUZqSSyofqEFI4x6vGmlOuTIsHVTS2oE5S51vHw7AZV0/m+4S8?=
 =?us-ascii?Q?W8HojqtxBXmPqBofhJfAl0R95cHBHYJoXXIPt73Nma+AZMkvLYUdxpcvODLB?=
 =?us-ascii?Q?lrcFHYpJhziadbwTLmYPcUWAmEmYE/C6xGRdeHdv0/RtoXLTwreas2Moa7/Y?=
 =?us-ascii?Q?mt+UUbSA8YMx+E4XWh85YVGmMD7U8tlUHY/Ezn5wTM/csbeoGw+0Hh1spa/z?=
 =?us-ascii?Q?JQpdrHlxN+ng9WU0EWSlyiZ7tb5t8nyCAAFQ7oA7AX7aQvRLDx7W8oP9pCJB?=
 =?us-ascii?Q?ThvXcPDDz4e3GhgW/tWtyjRcMLHkQWxAZn2RAYqtK6AdIus70to6DubhnAmY?=
 =?us-ascii?Q?SNOGZwwzbWjG3Xj8e8vc4esTmnJH1FPfEKtkt2jJJYN8GrnL+QNDRxKBgiOZ?=
 =?us-ascii?Q?nVsvEDreYZGRXsePvmTSwSCsLdT/uDqVKImQIWaLDx+BwPvDS47FNjNEVfui?=
 =?us-ascii?Q?xfVmKp/zvIVtfQRDc8OxcgcfuNcvWxPzV3K+M18Twz2L7SKUAfaYAKKxo5BQ?=
 =?us-ascii?Q?4C0ZCg54BPQIwziihks9/BOayedDsLUuWTOkV++bUTnd7lokXCkEVAymiQGB?=
 =?us-ascii?Q?3DkZAXbRAXsYcxTuJ6eTk8bKaE1+4aRCxnZn/wGlA5B+QYX6kUupxGSW5Ij3?=
 =?us-ascii?Q?/CVrCmQRoqKIrGf9U3SoAXH8KPsusYWJZW0ccmggxFruZv1IwLyBeSJBbeNl?=
 =?us-ascii?Q?Ke6KSHU3W+pzM1OnlBwwiT3m0/fWbBsQOjyuuwRkpT4iyvG/xTBV542Hid8k?=
 =?us-ascii?Q?kH6a0DSVMki6oQ/eC2KeyyPOkW/LDfMI5US+Vy2wLtRzGhLUNnsP5vgn50Yf?=
 =?us-ascii?Q?Dr8RBqOa66pH8CNmTC4hTX0TcremMf4YARWh30UQnU1spl9C0o6IJ1mgWvKf?=
 =?us-ascii?Q?/FpJpz3gIjMffGLfIf4h0KU0qQVAsg9dC1hY1luWPHI1SSJ1W2L0kudsMfgL?=
 =?us-ascii?Q?sgDdq3oq751hptU1YehIei14wrUwnhAcmLZ6FtxAwIGI9lX7Tp9ayt9t1+Fd?=
 =?us-ascii?Q?nV0rjjsM4LQ7Rq192UNvSZQr1xbP3s7sHu5+4tqh/qctmhGhvLG36KjrHshp?=
 =?us-ascii?Q?eBijpKyPleTqRkVEMmJZCbKntnKDjrcrAtWdVTHo5yz9WrmRSWS3/rC/xFDT?=
 =?us-ascii?Q?+j3kWuagCrxMnJvZvFHzHXeaKxxS245v?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RoGf+0F3TqfGHf1WusGRIR4Nx2yPF1TJi4iCGdqsxiiTvcYMTATP9MDh6uMO?=
 =?us-ascii?Q?YmPLXwORNdE4slN4KNk01id8JePKCw0dX6tawsyw2IXwDM+5OzwUqnmhA8CE?=
 =?us-ascii?Q?1CkWgmq0gXnZACgroT6qODFdBQe+E+3t5G6t6D0zteSk5plK21poHqFSOyF1?=
 =?us-ascii?Q?f58t2BSn3B7ch01HK5/Go0VRuVmKoJD+N2GcDRuo/XLqTYF/7qoOmZg4M+8j?=
 =?us-ascii?Q?rhZeqrrlBHpcE8t4H/gj3fEfxBw4IGgceVpxu56p5q/rjd0BwZAnO6Vlx5d9?=
 =?us-ascii?Q?8F29DHF4pG92C8VFPCBpASMqBLDA9jBRbzaBRq27J7+kCgVjWxgH6XWnh0p6?=
 =?us-ascii?Q?y5K7KAEJZgZ39jIh3xmur4/VIaoE1CDB3ME9jqY5fJueq0YSui+UKshsBo9u?=
 =?us-ascii?Q?a4ZQtkquUflcSKlFfWhFNXAMTEy9Cuk5pCIy6UdEvUFQbarIYWVlBZfrCxQB?=
 =?us-ascii?Q?wZ7vF6IFvBCP6G6HnqcJ5dPup85UymDXcRrBEo4+409dLIlOyl/cioAo1SgK?=
 =?us-ascii?Q?Z1kz6E8XHBhTKSMaFeLJF7ggbCdHjn6eLggtLHrJrJSewEgnNVRCfsuU74oc?=
 =?us-ascii?Q?rjVhDyxzhui7O1a05IiBrqvnG1ZtuPjv5+UX+VNpftRRmrxX6Q4n40fGJBQO?=
 =?us-ascii?Q?Kvp2eGKQFa22n3p9lCXTTasO1bwxs42DHFxse97EpfXwqZ26U7bcOEHFjpLw?=
 =?us-ascii?Q?X5pzSdTvdWUsxVLsMOhtuKT6EPPncr4wcvFHAC3hhHnpcKXm/PMCOLy83rqe?=
 =?us-ascii?Q?mf3RMCJbe09SYNcvWalrkAcBsTLsTZvlY/LQBCU/B8sbAnD349+MNcJGkAdw?=
 =?us-ascii?Q?3RLL9JnCcOhgtsObt/p69jiBY8zo1nD0XqXJQkRxFMi+gzLA7EG6QzCteWR6?=
 =?us-ascii?Q?EI3eLVeYju2dVM6LUnR9wXT+RlF2NmTZ8W4BT7MMzfbdiWtu3w69z3y9giYn?=
 =?us-ascii?Q?MEbTZtLN+029hwGMMn6xwkbGbL6GlvHBLlqS/iQF7qd9Hgd2OgaBKVMvEBm0?=
 =?us-ascii?Q?i8qynKculC8XlYXF7GKOY48o3FyoREbon6UjcNK7BQp6f289ZrebCpA4UtaH?=
 =?us-ascii?Q?4YKd5Rc4WntamdaS1KVcT0SWkTRNe0+yJjlcBAMh31/CNfuiBXSjhNc93Mhx?=
 =?us-ascii?Q?q1jAqaInU3vfRRzdIwmelKd2Lx+Q5sDUCGBzkK/a2GbKEBTNoqyhoUU5e/jU?=
 =?us-ascii?Q?NcQkf4SSwadFrjIR2Cvwk+VYbe2l+6j/rv7O+f3uKcQ5ouTCFuhSYwlaJA/l?=
 =?us-ascii?Q?jEwe7327EsAQhv1SeKChLbinhTbZy3JNYiFVgpsIqjKIlNfjf1k2kbmGxDtd?=
 =?us-ascii?Q?/GvDzaM35WCm6hdc0NyU0eIcIk+Mbf+jxFZELP1BPG1RoClG5sZjnlnGU7CE?=
 =?us-ascii?Q?XYlfssY/pe88pkYlhevnUjJlhSaRfl/iCocHgUQaqicB2nIwrvKRYX+vhNz8?=
 =?us-ascii?Q?/Xc8ZBJwbFwRKiVxSd9pezRWdpaQoK3FbX+fIt6SkeID1Bxxyp2i3XAb1LBZ?=
 =?us-ascii?Q?t4YsJongumHs6BB2up6dA+LCVY65dW950wU2MY3wr8Z/nMC7wUzk3s+MWzwR?=
 =?us-ascii?Q?r7ao5w/yd5KQk+5mS2LXULDy1QE/oWpoozyw/Ph8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IzzuGcnD/gGtFV5GH5QHJe0YdVb9d9heH7NY926aH1MVLV4kuHXsSn5tbgk+B6tbV+x/2XNzAzmcOXPCwFBsZRwBDYhWFY81U+393t0W5SVHeRNMwJargTbWXOd39r3rmbQBkgbHcwxe7t+tGxvTwpbeyHTzE1CX3oPNG7Kb7AXucQFIzKonAWnyHDogLKx6aP+ckQOEECvLMh103ENWXAoaLrz8/JS5BI4417i/coxhDpZGEsOI4AuZVUZXs+pcHzA6eiQc4+1H97m5yabYhqKMN47VCVFOds1vQZTwzOe85L7GLyui/dbtKgCQB7ILItY/gP6YQNPxYqART1uxBlzZe6VMIc+UMxDrWJhKPDRFpC6ZH7r0slrZ/UzOJLaZqeXV3IYSq8WLP50/Esqc/ZACsj3rXnN2gpgBSh6Gk7IxXThHMdlmmXgkG5mGrLDKvN4BjAUk2Wc576OvKOafow+PDUSQ4GFCRy7I/mq3fhHIvVnt9M/eqFuV6oQSvE7vS5J8uNaobu7szxCCLOTzZZZPLQBP0euudo6QwZXMXDBSHtTBkCBa5ZxS8qIMNF+5nRK821FTOwOxmS8NlLdCpDiX/zflZhFD5zWXDri0D2A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7be6345-8479-4fe7-e356-08de11c6a534
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 23:56:40.9224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: byBBvc6Oh70Gbb/nrxQhauB1pLYqjKa6L/Qj2A0uVJnwyA1D96egkT3ZOE8x7a3molfjHc7jbIbZlz5emUKjnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF476853C3F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=622
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220200
X-Authority-Analysis: v=2.4 cv=GqlPO01C c=1 sm=1 tr=0 ts=68f96f3f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=rr1sFD2-PXdA9Bkw-cYA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13624
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX3/XERXLCb7x3
 mxnrEchXBRdDQILKIOh2PhoFe8nRlp8BcRf/eDNI0lOIIygPjS4wrXDhlHiBumHvjrrA+2aaQHu
 brAVRDJiYndQVPEIw6GQRYHSZ8w2F7bOHmW9m66HhsI1xIj4sHse8z7TfDGlG3sHqbZKacFsarI
 8hmBh1BUmRqtsaBU3w2MeO53rCW5u84rNaBylg8u33QnaoUXpnycDzGhil8j7cOz63ViQBs99Hl
 YI7RLklGhWQKMRMhyJXzY0NguNvzFkqxKf0UzjAMmCdo8lddEBAz2W1jdfLaseT9NpC2/nuNMHb
 EIWRc99qugtBjqG0hJQUG9r9FYrU0myDUhG+zuzInkY7ID6fwrNMh2QjDvSvB0ouEBDeu31Z1kH
 fcmi1+u54Fbya76u3h+Hkaz2AHwb0+HWyXYhLtSwz6/xOzqBZiI=
X-Proofpoint-GUID: raP3nTNzo_Pr-P_BljOIEOgMoNF-A-0r
X-Proofpoint-ORIG-GUID: raP3nTNzo_Pr-P_BljOIEOgMoNF-A-0r
X-Rspamd-Server: rspam05
X-Stat-Signature: 5r1tk5873ukei5dfcjc5wtnt9q1igwp6
X-Rspam-User: 
X-Rspamd-Queue-Id: 1314DA000A
X-HE-Tag: 1761177411-738588
X-HE-Meta: U2FsdGVkX18nFPb/AgwJa7MDanW/uqrrqOU9pliO8Hog4vKuGD02zI+PwnLUNO2r34B2eBkY1/6F3+9FHKzeeQNiHo4QYIY8h8hF2c4FQXKiRAqWXWb9UbGROECA4UPAkDtVBY2YoCvao4eaU7cqnuF4Mgfp02DxJORjBHAWj3RigMacneuy09U5V4Tb40+OZE8i976jWP7CR1wKFPQgTF1+6h73NqTjewYpf2o0oRNUE7j3hGQmYJhOahK28pMBAvuH1uNDNVebmqMLUihI0nsOLhMiUmCQVTt2CcinzDebzK2kP4AnsqAnMlbMlg8JPdMpKwEMLKh79uaOwjZ28N3P8ceafjCukMfaC0YxaRA4yIJ/Bbeh6DQgjClAx8X3Vyi6PH4OfZBHaEiUaEfR6DuGJGaC/5w0MDqtQhOpMe36ITWjx05cpiM5o9w2aRzt3KyNOkQefdcN2UP24STGqmEtuv29qnLNp5rRPznnuzbkh4pqOZKX4RBcJfQ7zPVw3EC35c2qBQ620yX29VF/G0oCvXgaEdvnOZIoXT1eUv55OBsR8Z4FNLJhWq++j1eqrr+5XpMuk3+VmngcDzzUygEgu/GZMeRnJeVyOK5kcFbt9j6fHxEaMBZfcl8aMnQ2AVzB4SmPwxmJMhphKNSFadcOd5CCzfkXst6vcPHDmCK5XU0xPnEIFleclm6shbkzzv5Ya3jA2LAQPz4TTv8NBL5zo0VzHhDZbOLoeM4M5/sZm2chMjEXThHqVUHsILXkzAnH0e5AHgYIDm6LDGkEYvlSdrNXGUA0UpRJx8efNTLYzScmWrSq0hAIiEy53NNYcMUQQMr6InVZCPj2dkYRxVJgnk0V8V52GcdrvytVm6KQJmzXBTMThJcuA786lxWtQ6UiJk2XpbxM0hzssyfH5wgyEQeLBGJBgN4NEGJy5Whq1GRmY6kcU6YynBwLG9jmbQt699rYIzUFxbVmPzd
 zKe+n8qB
 2/QmOvZ5UUVTcQ3JJe+m5AI/EmuvAUWZUDn3sulANkNo20BqHVjH6paOFCq8TFR3dZTm/Y4cW185qfA0s964mLX5c/LugdLMK4DoZi9LyWH4UnXR6vbeJcm8zZNDtS28rb35GCBjBIUW8Bs4VN/NQjcsiCuYm3a3QOh/p4pqekn3hxgg+Q0LDTaHZKSsq48iPkl7w/rX2UCLarw15oRs5H+JzzGXGz9+dE4P2ozcZ1I1Aj5/cQlHDyEltfp8k1f3zo1EiL51qA00RADvK2cDXXA0Lw4NiohXC4lzGd/A/yjVLuDxD3pYB36qko9psBZ+Vfd1PXF8kVRERaCTgMnY2BLfqw68gt7s2/xpC9vUrCOQ5Z/qlzlpue3RdqwLKQ+v1IMldiZ0WocMbuJBmP0iaOLibJ0viIfvkBcxBQ6ebKVNjgDVmMOM03NM3rtWcFWvds2GX8pWtxwwj1uT4n1ToNtyCHEqhIcO+0dMlV/hrMGDVz0iq91UQ+tcOqwgOKloQh9UeG4Px3PiOMnliwuD+9HaLI1N/7grIclCdc5mXtlPnMgq/667u7tsxYwefVUBeFDHSckakm/PsZoyXC5MDNemZ1+ISvDbPwCSCr8J3WWXBE67l1ISqI8Ay7w98UpUha/5vR+TouBDodLzIduU3J6MHg+9dQ4Uzy6aje8pBBvLpO1NMTxHYSFe5OZf5aF9NLDqUr8wnovr/WHE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 07:23:11PM +0200, Vlastimil Babka wrote:
> Since commit af92793e52c3 ("slab: Introduce kmalloc_nolock() and
> kfree_nolock().") there's a possibility in alloc_single_from_new_slab()
> that we discard the newly allocated slab if we can't spin and we fail to
> trylock. As a result we don't perform inc_slabs_node() later in the
> function. Instead we perform a deferred deactivate_slab() which can
> either put the unacounted slab on partial list, or discard it
> immediately while performing dec_slabs_node(). Either way will cause an
> accounting imbalance.
> 
> Fix this and also make the code more robust by performing
> inc_slabs_node() in new_slab() itself, and removing it from its callers.
> As a side effect, in the theoretical case where the new slab is
> immediately leaked due to debugging consistency check failure, it will
> be accounted (as full) in /proc/slabinfo anyway, which is not wrong.
> 
> The exceptional caller is early_kmem_cache_node_alloc() where the node
> for stats is not yet initialized. We can handle it by using
> allocate_slab() there as the gfp flags are known and fixed and we don't
> need need new_slab()'s fixups.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Will this reintroduce slab validation false positive due to n->nr_slabs
race condition?

**digging up old memories**... commit c7323a5ad078 ("mm/slub: restrict
sysfs validation to debug caches and make it safe") made sure inc/dec
operations are done under spinlock for debug caches.

-- 
Cheers,
Harry / Hyeonggon

