Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672A7CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 00:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB0B8E001D; Thu, 23 Oct 2025 20:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982148E0002; Thu, 23 Oct 2025 20:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822B78E001D; Thu, 23 Oct 2025 20:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 68FC08E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:01:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9FF6C0CD1
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:01:04 +0000 (UTC)
X-FDA: 84031052448.13.B49E440
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5DE6A40003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:01:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DXiH8yyf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lxfuBt8Q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761264061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3Yh+x7NIKXqzERF/XcMMBsMOQcvlXq4If7V+/uLyAs=;
	b=f9DlIFWhT6laeyhg6vaTve0LFR3+BW3pOSuU8N7g+Myn83Z2Y91rBWctm683MfpHhbGw1y
	U0NasLDDf6X64ZmiG6GmOqbde6ybpJEgmGbIpq4L2O4yE5cIq0RBSTn/9eg7CTDF66VX0d
	YD/PkBSx+NIyGMHvHQOjJdw/AfFSBs8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761264061; a=rsa-sha256;
	cv=pass;
	b=m2IwN6e0hzLduzouxmV8zgdKffHyTHZGufKNeZ5d9JLKnbBLDEw9DqwL9sz+VTUpXBen7o
	YjgpWo1V1QHyp3p4SLvhRPAni7N0MA7pzhuhkhB4lBkJTwKh/F5Fe15bNbKEfCOO4ybGWe
	RyUrgbnXw+kJloYitmY28VBnTMpCexk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DXiH8yyf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lxfuBt8Q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59NLNNlO016890;
	Fri, 24 Oct 2025 00:00:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=S3Yh+x7NIKXqzERF/XcMMBsMOQcvlXq4If7V+/uLyAs=; b=
	DXiH8yyf1SJ39Iuw4AcFFA4I9C+pZCIIJ1s61FVo4duc+8Ty5BaHYOqLGH7pnQOZ
	lFkrOOOshapNSFmAvbn8Rd81wpBbAFGCcWxtsTLUD7OQi4vgOS2kY8+vkqeOJZ3A
	WVyXy4LgR9dai8xOow7rmGUICuC9ddFjDqZ8i5Iy0ESHnvD2YAnaeeN0TiYiSmmz
	GkID+KLt6aUydm+vCtvUd8KNgwEpHCevby8F6ug3XhAFuVWy4xvv4vqJJ7SZiQ4N
	ooGi0jyTxs5lOnpaREymBYQ1LhrkQEZrDh+hJmf7AttfcFlRn4VgcVLqa+LAAB+8
	eDIZRniwAgY1bAZGACUA9Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv3k3rbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 00:00:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59NMQxss025338;
	Fri, 24 Oct 2025 00:00:52 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011038.outbound.protection.outlook.com [40.107.208.38])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49xwk9qkty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 00:00:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ednLeUJcTJLvC5tyeIDCYGO199ClgEN3c40F7WUspOOwIJyADONOKgB++218emiWIKWSkE6dIuzY7zlXNnsfOcTnBv9W9oDi1hove+is9JcNd+DCLTKNwVz1/JAy8+Twi9N6IJ/9ahmUz3NuIyc29Uzy4SXR0yT1zooVSBxAEpsvdv/c3QiRswJKO413qJBc71qDiCtoMdMC0h8KjhmbILG5iQYYx241T/f7qdlPaY8IujBMLKTZxlCptFuXXdPn9s01/sGx24Tln+wTUqY3esRXiMfZnllqkbWSZEXmanaGO8l2URllT7JVMYE2hpGsbgXtqmp2GLjIUM8tnu88ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3Yh+x7NIKXqzERF/XcMMBsMOQcvlXq4If7V+/uLyAs=;
 b=c7H41czIZMAzSBtOhL9u/mKB/7NvRrnRidRCgdVp8IrtIbB11OQEF5yB2x1RNJunlSo3ksqHki+t+xvdbIO/Lsac2KWwDjXUOvJ5WwPsckCbaAYrudkxMtpST8c+a8XjlKky0mwNvya/e2sgO+LmsCQLcAoeL3MRkndKO+64VQkthOomvc8V/OboHUzRKFKLYAFxIvy4EUdYVNqZ/cvcWpEJAxJ5M4R8Qdbt9mDePsHwLNvN6hipf64WJWV8JOfW7kW2cz0hzx7FfY7wtlL39m2fAy8QzNHcbLDqeyb2PMK/xSmHZIJLH6xN5sw2Ps3rNe7xiZfYupnsl8j7hn/p1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3Yh+x7NIKXqzERF/XcMMBsMOQcvlXq4If7V+/uLyAs=;
 b=lxfuBt8Qu2fHSWqagIDRz6DDPLHJrkZ5ZnrlTqoD6u4S0Bv4awEGAFYvGr5EvK9GzzWfZSV3urZAm9SNyeyle4nW9g8MvdoSHwzR/rPM+xcn/mNa0fdpwoyi/Qr2HFr0NlpogYWQv2ZiJYn3B5sx5Rzjm2C9Jrf6IiwwzEKfzYM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB7205.namprd10.prod.outlook.com (2603:10b6:208:406::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 00:00:49 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 00:00:48 +0000
Date: Fri, 24 Oct 2025 09:00:39 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] slab: fix slab accounting imbalance due to
 defer_deactivate_slab()
Message-ID: <aPrBp_vG_D-8qG_E@hyeyoo>
References: <20251023-fix-slab-accounting-v2-1-0e62d50986ea@suse.cz>
 <CAADnVQJS_RUTnpCX5etS_qGD=jgHjtY_Mtc5GQqPwvyyTfghdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJS_RUTnpCX5etS_qGD=jgHjtY_Mtc5GQqPwvyyTfghdg@mail.gmail.com>
X-ClientProxiedBy: SE2P216CA0062.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB7205:EE_
X-MS-Office365-Filtering-Correlation-Id: 763ac5d5-072d-48c1-9ed1-08de12906375
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TTM1ZDljd3BxZ09XQlZCcFZod0Z1WUtWNDFMVVUzTTgwdTlQT2h1SVpLN0hF?=
 =?utf-8?B?OUszZ3V0NU51RkEvZXlKakVjL1Izb2hmRUtSbzMxWVRTZXpETHM2d3NEMjZS?=
 =?utf-8?B?ODJtNkNTb0hEVmRuS1JLZlVsa3A0ZEovKzV6VkI2dXFNOTAwQkQwelIzejFR?=
 =?utf-8?B?Witqc214RDJZRy9aUkxDOHdqZ1pIUk1Xcm1VdHEzMEIxaUF5UlZ3UjBoaFRF?=
 =?utf-8?B?OWZ3T3VzZXJXcDZGZnZTV0J4dmIvZXFzeHJDek51K1Avb0VYRnJaU2xldjll?=
 =?utf-8?B?Z2wzUWQxaUNnUHFqRC8xcW9jMzA5ZUhETUFBd2VPbVFrajBxNXRJVzJ4R3BD?=
 =?utf-8?B?V1VXTDdKM21ZbnZ2Yy9PSjE5UysvNW00S0pGcldyV2ZRZXhiOEFNcVZFU1pt?=
 =?utf-8?B?ZStOdjMzZ3h5TFdJM3hwVzJlTVhVNVFXRXZTeFpqWE0yUEhVaCtwdmkrRmhk?=
 =?utf-8?B?dFk3VEwzVjJGR3QzUzlYOTg5V3dPWlRpUzB1ZDVXakdrSG1KOVluU3lyR0pY?=
 =?utf-8?B?dUF1Sk92eDU5K2hQSVROMmUyU3d4WFptYys1WWJTUkF6NW44bVQ5Ynp4c09x?=
 =?utf-8?B?QmFOalpiOWVRTEZ0MjZ3a2RnYnp1VzBuUmpseFI1MzBLU2ZpODMydUNSeGNZ?=
 =?utf-8?B?RktwR2tVb29JWXdnalUxM0dyalR5VjJVQ2ltRXNoQkxTZDdxVnA3b1ZWNUhN?=
 =?utf-8?B?ZktQNHppY1lIRkVDbmluNkJLclBiMXFSUEFBMEpXVHRza2VWc2FJNGt3TmY4?=
 =?utf-8?B?RFlOSjBCa2VFSEhQSWpRUG1PakpIbmJNdDFGNWlKZmRJenIzYUI1ZUtRUmJO?=
 =?utf-8?B?V21VbERkRlowZkxLWFZHQVpaTnNWY1V0WmI5M1RzOGEvaUxEQ3pIM3NPZXNP?=
 =?utf-8?B?YlhLaHBxRkJYaFQyeERWbmRQTHg4QjJMSmZmdWlZZ3dvN05xdFFWNDRCazRV?=
 =?utf-8?B?U1RwaVQ5THJwVmFLN05EaVM1NjlKcE1EM0NXYWlMQWEzVFdFNFR2SC9FdnZy?=
 =?utf-8?B?ZjhXWmEveEFmcFdqVGxWSXVzQ0FGQ1VNMUtVeENiazVmZnE3Yklwd3VrSkcy?=
 =?utf-8?B?eUExb1lXU1B6RTVvWlZUc05hZHFlOS9jV0ZNVkNyQjY3MzRsRW1aRGE5R0E1?=
 =?utf-8?B?UlBiODdpeUNqRHRYOG1janBNdXN0cG1HWEZoWWRNWStwaWVUS0QybVZ2SGdD?=
 =?utf-8?B?czMxdVFvU1ZxcG1DbURRSW4rYURXL3lKV2tMN2JldmRQOFNKMHU4MGY2KzlE?=
 =?utf-8?B?bys5NWE0bE92eVpXbUtQbmV2ZUx6WGl1US8ycGNaM0xRam80ODZWZjBMYkFp?=
 =?utf-8?B?VHFIZ0ZiS0hKaFpuQWYyd21Nd0JUT0FVcGhCcHl2cWI0eEVVU04xZG5CSDlr?=
 =?utf-8?B?OE81L090cWlaN2hFd1ZpeEUrKzFLdnhIL1BHb1BOdC9rNUpVS2JZN3ZOeThU?=
 =?utf-8?B?blZzdlNkVVNtNzB6SkV3Q3JZT0NZVC8xZ2VyTVd5MzMwTEdmSEVjY0NYc2c0?=
 =?utf-8?B?b2k1RlIwSTRUWTVJQmZQZ29WY2NkYWRKZUYrN1lHL2lIcGE2NWhnKzZPTmlp?=
 =?utf-8?B?d2U0dnVvNHQxTFhIRTQrcFUySUJPZHZOMGxJOUlHR3FuR3pBT3g2VjU3UnRs?=
 =?utf-8?B?QWJmOCtveDdwQ3ZoV2RxaytJN25sejBDQlRlTTlRMlZ5c0dWUUs3ZkM0REZi?=
 =?utf-8?B?c3pMY1cybkxkUEd5S0FEbk0yOVJaOTRSNGhqZVRLVTZtT29hYVlncFZYT0Zv?=
 =?utf-8?B?WEJ2QUxJRTNBbkhXRTJVWHA1Z3dENGcwYkNnbG9FTDZTdXMrK3hxeTNLeVB0?=
 =?utf-8?B?NVZQUjRWbFNRUVhDWW01RWNvTWFldWU3cWxGN0E2aG9VeFVTb2JmbHF0ZDVV?=
 =?utf-8?B?enJiUkdBSE9jZy80TmZnd29iTFF6Wk9lQlBHYVZQbk5RaVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVR1QVFiOWxMNXhPNmc0ZnZDNGVKNWV2d080U1hxTXJxM014SzJxZ1BTaVVS?=
 =?utf-8?B?azBYRGZyK3VGSnlkd0ZaUWJ4MENvMmFFL0M2K2dWWTByWFpxUVVHSUNMOWd2?=
 =?utf-8?B?N25xRWpYK0k3OWJsY29TWUxBVmJKSzNLQXFta25IMVpOR0FHalYwcnpJSEZI?=
 =?utf-8?B?S3ZnTmI3WHR2Wk5LVjc3a3RKdElCd3U3RHdjVTBNdTF0UStFeWgvMThFYkxr?=
 =?utf-8?B?MmJYZGRRbk93QlRKUnM2TCtYVjZFajNiOEpGVTRMeEp6a2dCcXZWQ3RzMGNo?=
 =?utf-8?B?VnB3UUM2eHVPZXgxTjk1ZWFXYnBwYTRySE94Vi90N2pocUFYSTg3ekxBbWxH?=
 =?utf-8?B?TFFTQy8zekJzOHo4YUg5UjM5VUVMWjRJUXZtQ2ZEMkltSGFTRnFPSmU5d2RC?=
 =?utf-8?B?TVdZTWYwenJjSWwvc0xGbzhsZWR1MWw1OEhnS2hNaEhhb0d2WG9udGM1SE8x?=
 =?utf-8?B?TUJNbW5uNUtBQnpLMkZlOU1RdjU0VzJldTZFRU1EbkQxUFRyWjAzakZrZk5v?=
 =?utf-8?B?RGt2NnlWM2YwNWN4UnluVEEzdHNYQm8ySldrYlh0Rmt4ZVJRdklROEl3bTNv?=
 =?utf-8?B?SXVGYys2NWwyakZhanI2VnVUc2FMTWhZZ3VPY2NvTnp1TGRNMGxKaHNWc1Jj?=
 =?utf-8?B?cm9UYyt5VGZxNG9ZNmMzd1dnR3dFN1J3dy9IWVdOamxSdUVPYmUrTnVaaHI2?=
 =?utf-8?B?K0NGWUdTZjM1S2MyS0gya1dWaHhldldpWUx6VHJGTzBsOXd3TStWQmE0VXRO?=
 =?utf-8?B?dU1qWE5QdWhqdGFOcXdiVzNtWWxVejdnSlFMem1MUEE0R3hCeG8xaCtBSXdo?=
 =?utf-8?B?aDUxSmJsYmFXNVR6QUN6Q1IyRFdaV3JKNXNEYTJBSDR3elgzd29YOVJ4SHNl?=
 =?utf-8?B?Ni9ZdzRmai9hK3NmamIyeUczZkVQajN3d0M2aE8waFo2N1pvcXNNRlFPUDJV?=
 =?utf-8?B?bWVkdkdUVEFHZmZ4a01uRTh0d3dKNXVqSUdZbndIQnFhWGhXS2JXdHhiNE1p?=
 =?utf-8?B?TmpydUE3T1B4U09UY2lYbEc0aHVnZzRZL2M2dURrYUg1WGJwSzA0VXRoL3VQ?=
 =?utf-8?B?ZU8vazB5eHBVNWQzZjBrUFFaYXl0WDVETlpPVnRYdnBnQzdMTU5pTytZVXJw?=
 =?utf-8?B?MUdobm9GU1Y3ZUkzSmp3WXFSOFJEdURwS3hXZnIwZklUbGJla2RRSFJ4Smlq?=
 =?utf-8?B?WitiTk5JRnV5RkhFU0VmejhLK0ovUmkwcTkrczlWVW9rajgxVHV3Z1B1QnNx?=
 =?utf-8?B?U0FUa0RQNGxJbkErOUhDVnZoMkNVbkk2NnlCVVpESldObXA4bjJaMGdoM05t?=
 =?utf-8?B?b09oMktPOTkxbE1xOUZRY3lrdnJuUU41TkdTbDk5elJVWE10VXdsYVdWalNB?=
 =?utf-8?B?Q1VyYWhaM2R4MTM3MG9TaEZpZC9PRXFoaE9pbmFtRVRONjlpTk55N3prRlFZ?=
 =?utf-8?B?R3BZalRRMFpjaGduN3c0NVBzMVF3cmxKYlM2aDJMSTU1SDNJZFFXOGd3TWRP?=
 =?utf-8?B?ZWc4bmliTTZ5YUorcHFxeW1kVm5xalkzS3pUR3FCK0hjeldvZE95SGJIOUJ4?=
 =?utf-8?B?ZWlFajhqZmdlNFBZU1RLMGZuY1IxTFJQelRFK3pxN2VjQXdWZjB1Q0RRM1hk?=
 =?utf-8?B?OXduaG1vWVdlR1dONHRwUHFSb1V2TThqSEtDcEc4d3FpU0NwcHJzUHN1ZnA4?=
 =?utf-8?B?c0JhM2l5dy9UM3U1SE9sZTl5cDJsM3JHK3FHb2k0Mm9rSXZjdWNRTkl0YkVU?=
 =?utf-8?B?VzF1U1FHR0kraE42dXMwNUsxZTlSM3pzVDhCYzBZWmRnc2ZjS0s1RUNPeUFH?=
 =?utf-8?B?anV6N3BrTkdEVjhPNnN0YldONkNQaU5PVkxmQUYvZW5zdStabFNtaEgwY0RW?=
 =?utf-8?B?R0RvZ0V6cWkzdUpGMHdYT21uSStuOGIrQkhlaFAybXVCUTZyUGxKUEFsd0V1?=
 =?utf-8?B?Y3BsbFR6NGN0bEdlWjhlcFdjaEhNbW9nRzFlMnJBU01hZ1FlcWExMTRsVGxl?=
 =?utf-8?B?b3VKUHdHZ1hMbjZYOTdxNElkRXAvMEh6eTNveEFOR24zangyNDE5SERYRGVB?=
 =?utf-8?B?d21yZlRxaVFDSXZyYmJIM3ZNbDJOcU1oaUprL1dNemQvZ0VMaXduSzhQSzVo?=
 =?utf-8?Q?AUAfx9fp1LFUtvVgBwu8ctvP0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+ums2hHAoXMUPaASRwBX98VCXtzlGKHWbcfTkgZEcUcXCFAdciinRB7Evq/vlyon0QYFBlVwli/xifMLelWzEGaQFWtoxROPvPFU9WPEEwU93P2f39tky3MkHImrk4FOfc8zLSJlccoQqukVlD5mLKfQmB6Eni27SrECD9z8+qafUvncWqnorzZdlkkyEFWf9pNH/ARGR6LZaWZxDJetbN+S5STBLcISqiYPEnXJ/Tw88GtRUv/uDGwW8OONZCl8kvyFIwLpVhHauSIdXUzhpAsYiXq94BkPnb1V2ar3iomk/RysH53JhZQZjtrB3hTl4CidUSyLqcVRlh4Wsk9G8gcJyVq7IXBWf9KgtC5iIt6Ubzm1zWBm1mjRxf5wDt4Fi0eVzkk/ih7dMAFk7KmG3umQkmra5jEFaaTYDS2i0cOOqaC8vvnSrDK7UKjYyA22XZPvhpA21QRe5/Gnk46+VnzUTArhoaPS3Jz/zq9a80uxz/DOcfINrmoNKXBbimm4pZM4KsnslFul6buygi1HArdMfFVgH6lNgCVmCL3WuH1T4/Un8lFD87Kv76i/WJK/H0+1eBFKT2L2+evMgGonGbcCnGqmFTFp7NUVwKOAEDI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 763ac5d5-072d-48c1-9ed1-08de12906375
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 00:00:48.8436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2bbsi7ymlJ8xkPKTs1MJkn7PsqA4EN5IORtt8PRTDGCCyytiyT9I9+6sv01awCTO6V7cqndv6//Xp4kkPB9u9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=818
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510230218
X-Proofpoint-GUID: AuTcGGNbwSduG2posjU2Bq0bUP_RF68k
X-Authority-Analysis: v=2.4 cv=bLgb4f+Z c=1 sm=1 tr=0 ts=68fac1b5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bC-a23v3AAAA:8 a=_DkvylGvobcdNYOqZXIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 cc=ntf awl=host:12092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfX0sJmym+FJ9Ti
 zNQs24LBL/vVonL67s4SBE/rpDEkUaOO/6PfGVHuQS+GAuzm9XIdZcEhF2jmhntfamv+pCwuTcT
 NcLqmAPvTFK72a0Lfo6+fQwosZzVFvoSypwH2EMlUSfnrj8/MY81A3Jb4AoAJQjJqg65zeYxYv9
 Ey34/4lHP4ShEZdJjOIyOahWrW8MMbx9MZiJlEkExzkaL/szbrAGr5GP6si99/4Fzko1TmqxrMn
 LpajNLb8PVPDYpDGnTRsu/V6AcTZrulei7AigAheNO8ay6DoUDkx8xTYw3FkNGd4z/oAuWeyeLu
 GkJ1gqv/+dgphLt3qtaosZerXlsuTVT78zRB53io7mSzHEempsTNb7VH7QjTbYeQLJvvASN6XUx
 6ytln/Cgoo2DhQbSayf6pDflCmC9v/CvaFJLQRG/dXHhJDgf3EA=
X-Proofpoint-ORIG-GUID: AuTcGGNbwSduG2posjU2Bq0bUP_RF68k
X-Rspamd-Server: rspam05
X-Stat-Signature: g1d8itfexf177qhcs9ujgsrrxjhqce75
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DE6A40003
X-HE-Tag: 1761264061-92985
X-HE-Meta: U2FsdGVkX18IFa5iXsheVLTTT3PC7EV4vxWrFwrwag/HyoYaX9E8TtbgCtmDt5n6UwYe63PRsKfsOz7WJ7OAeI6FLYXoaejrqurzv1kjghOT4sOxhUCwGYY/6Zpg75tKzu7mE5C7ZtvV2wqncib7a7n6FIoP6TTNyGZiHfBWSEev7Gph2p/MiF+EhpJbPrLHh9dFHNdXp2s/linWHwqIhmCPhE+LXVdukaZKZ7DEPMwv1ShACmXhomZII7GZdqqQXD/lWUfuDperacETF19/+ITFeNFVDKM6wn/px3RgDFNU/C458tOWrWyEjdR4ASZoCPg6bqv26IdfSf/cOQkkoz8odgivKZQxMhgcAtKWCFOp0RNVy+9UxqKe2sWW5UnPzZsgeSwxhN2UZpaMrkuf8vP0NnZ/X3ho4aOacX9C3apwWffq2lc8KOAqwmWSZN14llRLZ+DHPfCwlvsXrnCoLm3jEgCdSVmfJiFYQNM6avsq+5gdxXHYhn2fmpYNzM25JQABKVlOOvCjE1FXlOnpKBqrz1UDmRnN+4SkGq33pNYZZMqjqxm+/VOnA6MWqD/O6lEux/wo/n4n2JNFOsZFtRH3CAKX5Pc2ZBi27se5jag360MtGbxw8ExacI4qzXtiL2ufv/XiAqa8ZpioajdIQAoeRHLNpzZvhPN10GsyhU0QDjFlRWK1yIWvlV7ZbpioXClVIDUImNNufeOQr1wpy/BeSwAyIaoP9WmEig8UDAYinPHNwuNF4KseVuGs67W3nC+QhxCaZhDeQtWrSBD2xcb6CyaVCirprPQV2KdhYBuB8bKpVmOFlApgkVCqqNEhrxSIAS6s/awvLATED6s6MUHFEG6Q10iYpG2ZtostGw0S5hGJoqAdTuunW7+Fh7OePNG+O6umskz3O8CCvtC3lsYL96VhlQtUytXvYG2gPK7aA3LUTUFNThRuLOtga21kCkgUcnl6guopjIAry+U
 VyGtnctV
 greoK/BhF5zkeHaQeSKImFuxx4TQG25dWtbmzh+jldN3cSockeVEx4DVjBJmbIlAVe50yjyXC7j7hElYq7BNEPATdvChsHeshw/tW/gA3QT5rNyyuMogFaL53psOwi5JbCZMw1pWje1FRrZbwtCmtMfpmDOEVXtud2I5vJzOdZ9BxaRUhTx80MXOnn9F3/rx9E+Mhcm54vYjBOCqoDXho/Bq8hcj4J5dKRJI3Y/zK6nf9v9ZPPnt2kDRpsESF8l5OvmymthnQTuq4pqGIU7QAl63aS1kV8uDWZ6z4cfigI3fVPUFDteTOmj5Bb1yMaZqx9aI6RgS7S9/BZFiiMnbMhDeql0FVjYHhPdMbecZDUyeu+9ynpTAfLwwECTZXC76E0VdoL1E4FH7fk0vl90c+M5JudPxVDiJQW4eaWRPV2kKe0jwb8TX7dxrg7WnfhF85lz9JClfYymOyoAzHYGQPfKqlZgjh5oashw/xWCutsiAmaUlPs7yLnk4sQjANAs5oAezVVRIyiY0qKDa5YHmi/oJK6ohXd3wyJnxy4EUFWTxo6wYr0JEYHpFFWO/YraR/bDtOmDIS5yX5UBURoRhPQcWoQWZ6g60jBQNYeYhS4cQnPUtaimLxi1Hdw6NX1YCyiyFFHoC6yLXK/8/3TGgFbxljeqdV7maiQlyv8SCiEht+8u0V+XqbjlqbDvisxcbB2AVcIbeeWP6pZrCR3YQYhodZb5CFt9d2SPAOc8zkNtIEFE6mk9F2enKHKaFciTcs3X6H4u3rUWD3oTMBtPQRnYItEGuONYasrTCxuq/4T9rOj/rhlkuVx8vWmZ2dRBn9l4Ple6Su55l7jd7gxj/lbv90imh3y5Wu2dX4VwiKhYPNpXXVSDjRL7tKFpPldB40eP6u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 04:13:37PM -0700, Alexei Starovoitov wrote:
> On Thu, Oct 23, 2025 at 5:01 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > Since commit af92793e52c3 ("slab: Introduce kmalloc_nolock() and
> > kfree_nolock().") there's a possibility in alloc_single_from_new_slab()
> > that we discard the newly allocated slab if we can't spin and we fail to
> > trylock. As a result we don't perform inc_slabs_node() later in the
> > function. Instead we perform a deferred deactivate_slab() which can
> > either put the unacounted slab on partial list, or discard it
> > immediately while performing dec_slabs_node(). Either way will cause an
> > accounting imbalance.
> >
> > Fix this by not marking the slab as frozen, and using free_slab()
> > instead of deactivate_slab() for non-frozen slabs in
> > free_deferred_objects(). For CONFIG_SLUB_TINY, that's the only possible
> > case. By not using discard_slab() we avoid dec_slabs_node().
> >
> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
> > Changes in v2:
> > - Fix the problem differently. Harry pointed out that we can't move
> >   inc_slabs_node() outside of list_lock protected regions as that would
> >   reintroduce issues fixed by commit c7323a5ad078
> > - Link to v1: https://patch.msgid.link/20251022-fix-slab-accounting-v1-1-27870ec363ce@suse.cz
> > ---
> >  mm/slub.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 23d8f54e9486..87a1d2f9de0d 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3422,7 +3422,6 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >
> >         if (!allow_spin && !spin_trylock_irqsave(&n->list_lock, flags)) {
> >                 /* Unlucky, discard newly allocated slab */
> > -               slab->frozen = 1;
> >                 defer_deactivate_slab(slab, NULL);
> >                 return NULL;
> >         }
> > @@ -6471,9 +6470,12 @@ static void free_deferred_objects(struct irq_work *work)
> >                 struct slab *slab = container_of(pos, struct slab, llnode);
> >
> >  #ifdef CONFIG_SLUB_TINY
> > -               discard_slab(slab->slab_cache, slab);
> > +               free_slab(slab->slab_cache, slab);
> >  #else
> > -               deactivate_slab(slab->slab_cache, slab, slab->flush_freelist);
> > +               if (slab->frozen)
> > +                       deactivate_slab(slab->slab_cache, slab, slab->flush_freelist);
> > +               else
> > +                       free_slab(slab->slab_cache, slab);
> 
> A bit odd to use 'frozen' flag as such a signal.
> I guess I'm worried that truly !frozen slab can come here
> via ___slab_alloc() -> retry_load_slab: -> defer_deactivate_slab().
> And things will be much worse than just accounting.

But the cpu slab must have been frozen before it's attached to
c->slab?

> Maybe add
>   inc_slabs_node(s, nid, slab->objects);
> right before
>   defer_deactivate_slab(slab, NULL);
>   return NULL;
> 
> I don't quite get why c7323a5ad078 is doing everything under n->list_lock.
> It's been 3 years since.

When n->nr_slabs is inconsistent, validate_slab_node() might report an
error (false positive) when someone wrote '1' to
/sys/kernel/slab/<cache name>/validate

> We have an empty slab here that is going to be freed soon.
> It's effectively frozen, so inc_slabs_node() on it seems like a safe fix.

-- 
Cheers,
Harry / Hyeonggon

