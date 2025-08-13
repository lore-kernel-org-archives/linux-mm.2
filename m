Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 515B6CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 00:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16758E019C; Tue, 12 Aug 2025 20:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEFB38E0196; Tue, 12 Aug 2025 20:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6B48E019C; Tue, 12 Aug 2025 20:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1DC8E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 20:32:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28BB8B700E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 00:32:09 +0000 (UTC)
X-FDA: 83769857178.15.1F37FF8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 97F08C000B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 00:32:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HIxEQ8Qe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GLPA/4+d";
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755045125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bZ8MEmzklxxr8ucXLJ9SQITnfH2DDiahfrHit9cNn4=;
	b=Xj9SdRiDCPh7dK6fonavqAwg2bHjtYP1EUP9WsXrB5OmGi1RrlvoH6BD+VMaU4406SuzQm
	oMCEzjtUeHEGrzozFfOF0CY9Bo9PJ/9SJsvI1TE6Hkr7vIzooUUbM45yU7L7NqG0nYy3gU
	XIP+vATIyThcUNSHtpUTYhZp8sPm/60=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HIxEQ8Qe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GLPA/4+d";
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755045125; a=rsa-sha256;
	cv=pass;
	b=pqOjKR7s4hBvBU3xXhF43JI/girtwwD3hsod/OWUyZ6j3/98UlSOBurcLOWAjFPaKUIjUT
	19EaLa1o1Iok0riw09z11rTpxNW/icwpR4WvBlP3OjeDUq6HVMxHCSaMgaNnbqEWn7k0sR
	HVxGbcFVVGacgridqbnLnJDdZslVcXc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CLQtDG017425;
	Wed, 13 Aug 2025 00:31:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3bZ8MEmzklxxr8ucXL
	J9SQITnfH2DDiahfrHit9cNn4=; b=HIxEQ8Qegqr33/dK97RBJVKdoZ1WNsadWZ
	MLpC2rLYnm+L/NMXUgusKTHk+iMc5BtfSGdotA5ZXsa0+fGrnsKTSfbF1ovIZuWL
	FPcipbkbFOzOb9/Q6vNsnSyedLIHilet6Jxjahv6JF+LdRg9RXQMOHasBTXEVJQH
	oKlKNREXa3Zaut9yeOeseMEnPgVqwlDLylepEW/v3cbCOpvQW28kRQLHSNM63VEp
	0FbqaiD2iRR54s8p9hr3Sxby34gb0hyg16u1QQuCSsyAU9DDJQEptlPD+Ws9JYWr
	7MA/W4Rqjg0+XUZRfn/MNC90P/1dclGvSezj+Q1Q7i0clfNq4ckg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw44x39k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 00:31:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57CMVAgb030166;
	Wed, 13 Aug 2025 00:31:45 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsap0a6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 00:31:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lqm05s56FMPuzFCBFWRx3uXSMGglA8JWLY2IuwN+fdLojlY6zxJ2jNOOzRloqRJgJYRsVNI4MHnwWPBP9w/jGMKlzai8ywe6e0hDkPO0MbHgAkD/HAxbRXVsTjttGUbF7WIcqA6COqqaFcOXqgXkFo6jub792yw37WP2eKMPrHD9noLjW7LlslIdZZw9cRrGRj+5ItX83o1o5PMizi+H4M/4GCtwUF0CeDT85Nn0ffqlXaTUqck9wibe3EFaBMK7GW7fhs080oRpu2Mmhh8Bgf7ZgPd5q3VjsnTniqas8Dib0SCMwqm+YsgGw7wcpp9V2b9cnQUrGL87jqmkQ09T7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3bZ8MEmzklxxr8ucXLJ9SQITnfH2DDiahfrHit9cNn4=;
 b=TqY2qx0A2d/XFYieQgu0ZkK3FeqbLtHRaX65Mg/XH4/x5G4ep95RqVV0r/DpZRnMQp++aoCqXeuExpFKrDPlYKpx1Ug1KpA9rqypGmxfsNYIV2tUNnQM+SmWYK1L0S0yDnb3h0dZF0JWCSQLPzUMHW3INqOGB/EBup3gm+DTU+h1bIszlP5r/XHqutM2iohe5PI4GPieEjcQjp884pBljbYb1mbjOwygfUVi++GXF77cssJLcdDexCcupDbzrkP3kk1Vj/Fo3FAGwzKob6VH9YXHQyVzmwMJgSnNODwXc0wtybySJRYuLbbIi/9Kx+y2WXK+tFzvrjokNZLSOoDjtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bZ8MEmzklxxr8ucXLJ9SQITnfH2DDiahfrHit9cNn4=;
 b=GLPA/4+dqzRMQk8fnXIf1eRlDcmMQOWX/0Xyf24xLDNOmzlV6m0k/KogAymYCKRtPA5b1S7GwRH5ey0MxFhw1mYk0TpzXDNHBDiCFsoi3/NW7VsDQBqV6mDHeQDZfTiwEXrYg3vYxNBkuox/vb6v8/SvP/hC2YH+J6Hm2CQXqZI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB5974.namprd10.prod.outlook.com (2603:10b6:8:9e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Wed, 13 Aug
 2025 00:31:42 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9009.021; Wed, 13 Aug 2025
 00:31:42 +0000
Date: Wed, 13 Aug 2025 09:31:34 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: syzbot <syzbot+3f9768ec54c86997ddfb@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com,
        david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        matthew.brost@intel.com, rakie.kim@sk.com,
        Eric Van Hensbergen <ericvh@kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
        ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in alloc_frozen_pages_noprof
Message-ID: <aJvc5m8Ocm3S_Xkc@hyeyoo>
References: <689bb893.050a0220.7f033.013b.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <689bb893.050a0220.7f033.013b.GAE@google.com>
X-ClientProxiedBy: SE2P216CA0109.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB5974:EE_
X-MS-Office365-Filtering-Correlation-Id: c0a79bc3-3dec-48d6-7fc0-08ddda00c64e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0kNq7ABBoQJdvWZ9jmiJp2IzenfAt5vC60Rc7cnu4GHRAweFjeF3NMZPTJXP?=
 =?us-ascii?Q?oufZYOnFyw3rpj7i1kfxzFeRUXwFFCUZnnEinPIJFHJmb43JSH6fQxn9Z8ua?=
 =?us-ascii?Q?idUYN6ZZ2fHkQBlCEbBCUbJ9gGybgUQHtbpSHGxnWy/oDOukWSC6PaGKKm/D?=
 =?us-ascii?Q?L1kp1DTg7y9vwNmBSDZcj5GZBzEoAxS6jXkUVrIK+So2NDDplUfFpsDQO+Lr?=
 =?us-ascii?Q?MafUVs7EwEUVuiVKD+B8mgOr08x4WXRvj5zBK+ByqvH361UF0E2z55ZrAGqV?=
 =?us-ascii?Q?6AjOFHRKGrx1V+hPQrTS6NgWC3YdXAZtpkPJhQlVsJY8EEHL6chEnJF+HhPN?=
 =?us-ascii?Q?VgLlYzdU3oDUhLao4b3sBVG9Hekmm03qjFa9XlZC7BYiLt3KRZ5fMqPv2Rxq?=
 =?us-ascii?Q?5a7XdTNOpcHkYqaPIB1xoWfXX8Ra6aQb0pMFCqKsI4mC60n43t1TVwQZj6AD?=
 =?us-ascii?Q?zHtgwlIM4AQ10n/xp2zM/uiZUvdH1+8VJ84bWqtAp/eAU/CaQi4DWM7TBBTx?=
 =?us-ascii?Q?oaJu/5g8ow/WH0L3gvDP9WXiIq6XKQXBLq8Gd2spPc6+xyWyDbOQ7UuOPqra?=
 =?us-ascii?Q?2VHmXMOthOfo+133KI50nqwKGt8gZg66cJHhU0A31Xs643YyrLvjQMCI3Pfl?=
 =?us-ascii?Q?l7SCnEpRaicmkT4BO6oxcfMMAbA3nTO5Z4O1QGLxQ9nb/h/H6bPelWG/83OY?=
 =?us-ascii?Q?uyXNqIBjv2+km9MHBC2I3n+cGlfezDkVU2wRwybU+oytWr+Rm3dxEIl2r+fy?=
 =?us-ascii?Q?8IRsPOA7UrUuijqwwxuOixjJF3L0935mPdpB3Lmvg7oZV1oPxX8ujkbjcHFb?=
 =?us-ascii?Q?W4OJ6avG+4NtG046XEWCPuiM6dj7FTBLOXSoSRSih+ccwR8P/kzDCFw0yJu4?=
 =?us-ascii?Q?SZ3okd/rF+PtnOceqQ+D7ibnsh11zRjnY8MRJ75SYJS+6lGJ8t+Bbpj6xeup?=
 =?us-ascii?Q?FPRErGCPYxyOdPtan2dGPU9RPOpvI4qhklt5g+ysdfgZG2dXQ4DB9O6yITPd?=
 =?us-ascii?Q?UWOIGT5RN0iCgyknbGVdVHBRK5q0xIroU33YDCprnEYc+Z9YiL7ghgrFgG2L?=
 =?us-ascii?Q?WKZrz1bwkF2EUqDy2c3yT3EP0TyUnXGicjMhc3swHsdS8+Jjre6HyUwLHmA5?=
 =?us-ascii?Q?rgPwHaTIFI+WNBbqvvB9RaM+zldgPWcMlIMzuRfTSGh7lKOHrWhlTgviEY9k?=
 =?us-ascii?Q?UiFCfV87xmsSAGW2atIfyEiRTE/iB3yYAl9MfpPOVo3vi9fLi9qYgAd3B2+J?=
 =?us-ascii?Q?LkYQ46js61q02lKpsLCNzqtoR6LYXDx+0FKHNHONG4puEP3PLdKu980UIcx9?=
 =?us-ascii?Q?Gr4tfLkOKMuQkOGaG+6FgKFzmPGIYk0o15/OvjknU68I/uDofx5FuOgSt3+Z?=
 =?us-ascii?Q?ceb2XfTAVryPUyRwyIfvKD8v1yaF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qf+4OmBjLI3uOQUEmCQRRz8F60NwSO5GaG1syEe7tlqZiz1KVmt/N3Ttak8F?=
 =?us-ascii?Q?HCYKcdizZmcCwsXj67j3HDauU2TNynABITXnKXHI5kLvSDK4MfAKTfgjhOPD?=
 =?us-ascii?Q?v2QbtKME+RCUdW/2isgXfFyKmPMHZOzwD8isiyNj/wjkwgvIkxjWXqPsy6Bd?=
 =?us-ascii?Q?DRIzfKmZ1SEQd8nvOlFOJx+Lt6e1zzPnqPDcqKXZxFqPvdbwzPJNiWRdZLcs?=
 =?us-ascii?Q?ACj/I1C4eJBk2zDV65uhk3t/El6FGJH4esbXZw//RWd7X1AelEotlzwt/r1w?=
 =?us-ascii?Q?qbGkNynAQHysud5Tg525Hxp5158pzdLl+xIgB3nWtxsl0PtPXJMD79DDhk+a?=
 =?us-ascii?Q?c4KwSfinEZJwXqs7BlxVaup+rUM01StikctVQ9cd/8nwrLw03O/CcHrOALtC?=
 =?us-ascii?Q?SJqn6ircALRHLprOi3jcyfyL4xIrCx/d09Irl10REDJTiG7h1V2/lNuCGehI?=
 =?us-ascii?Q?nqZZ43gr0ST77VaQYrLHDKdccGMc55gX9J8HhNaLtdcoO9VuB2gupBmOrJOo?=
 =?us-ascii?Q?rSuQqPIOkCrQL0bggl4Xmq96XRs7ds5E7sFtET9mWwN1HbiC66A5bYdPBFFX?=
 =?us-ascii?Q?JvAEOHxvrgk1Ie/ZNDus/InBPi6/UwZlfiTFXs0+zaeV76QozSzEsLGJXOrC?=
 =?us-ascii?Q?ZSTNsFwBjxDWQCav/OFb/KrxH811Il6G+m7ckVigO5S8kpJypdPvzGJGlahk?=
 =?us-ascii?Q?NY38/vQGuHNLsliLCNMVtmhdrvYyHuMQtMNNE26+XLZOFJIlXaoaG6bLVutV?=
 =?us-ascii?Q?rfYdF/Az1YqFMJxggW/Pe6kQwlIAruPYUUlWPPlXH8z3jyw9GoJcaXs07u9H?=
 =?us-ascii?Q?2szi9gCuzpYOngB6X1Yg3BIgSdNU8Kep4huooHcvyUqU24Gb1OWMtCl9v9aq?=
 =?us-ascii?Q?yoTKr8uj53QHXlYLb2SyEb9DbyP+6Z+9qXaEI2G6V6mAgr+7+l+3zk7a6c3R?=
 =?us-ascii?Q?vPwPNZ99DOqCCSJntDRpTHrHGeAeSkTTcZK+ETmud8Xp2++HXkBhwlPJS6pG?=
 =?us-ascii?Q?5P7xvnOR5065kQ2MompQdAKac5ciWMKR+PFuBGIWDl/wajxQQhvNO5dVkLXF?=
 =?us-ascii?Q?dtdGgcUrGsqTxdUWfDVET09pODo0z/FQQ0UTqIas3+bNxWjihjqpF6938nO0?=
 =?us-ascii?Q?YqPCmXaoS7IIs3irxrLfWKbTgCIYfMzCPxxbr5mszzfKd4YrM98Ca31EmNX/?=
 =?us-ascii?Q?QiNAn7GfX1pagDATzKH7NPV5/eXa4O2NS5NP1h0RYfgSbS6IOOUUaw0kyEEO?=
 =?us-ascii?Q?VpCTG43uy5xVynguuL08ysQVFrVuqy1TDTe2cZTm3kaEUeDZa6hE+z/ZeozB?=
 =?us-ascii?Q?/Xgpc18RTenVySDz6QbOvCHMWhJnPYMfnGV8ltUlosPNBxPn5zNR2nANnuSV?=
 =?us-ascii?Q?8Is/7xjsqTV7ta2ViTym+S0a0+kS8H1xrYpwkJu+ryQ519viquCWS3sKehrW?=
 =?us-ascii?Q?rWyWNt2GJzvOsfVBBCyEmRyliKI2XwPXmah7ktWTXIHX7XmPbjHgN3uc4lMl?=
 =?us-ascii?Q?KUACCikQNKLQgkU4xG39ck7t6Eh1jJf8vYHb2q043PczcuAyquArw1ForuRh?=
 =?us-ascii?Q?4bSsDolPto1BstUO4aXMGm/8z7zWssuEOFk8quCm?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iXKwfSW2xwIEVKqmL3dNLozYWsqgvuWoFcIvNMSuoP1Rid+gtcoajYFjQDIrrWctYZkJSgcHVCEfn0LEvieX5gEZIQ9CaZhW4y66VpV3Ek9wdX3awCwemeyuayiq03i6kErun7dR2e4knJqJPaQzpMbXbOsNacN2Ev5TdEWqGswA95oCU16f4xTRkXrehze0eW6fNafYfHxYgr72SFE5qI8Nvq/Xrupd1qSOm5v/AGkUHGkC5eQRoezKj+zBgmeKtliHFQAi/GaU7UPH8Hve1zJuaTvkMArI4vSKPM0KnyA4az4DXSgruvGcyUZd0bl90mp9kWH2O7hp/1+kZ6PezQgBbrTDEMH0tNZS6NWLjF5koymZz0DbQB7CBJCoTXcSAWER/54P0k40Vf9XmEpA4WDe/4dzBjZ07a6CAZLvirUqlKk2E2kA5WbivwubwKL57VIiAK10ctPsYFTnlWvTBwoCrAKlBTZACz/xl3t2H/bFLR7ke5MUINxUsqlr0Z2XuOjhuGFtYv1HIPk0WMIWrJPvUzbDOuGaomX4qLSoxf6O2hRRRoIVJ/DlTFNN7AYCRN+x87i0YQGtshJiJ8uyqlU3X6NSrF/PkkwjvPDGU8Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a79bc3-3dec-48d6-7fc0-08ddda00c64e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 00:31:42.0982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XpwIOjq72d24lWCAuQeMnBrEoJuw1rBkDChsZUmcirP3k5ryUpxJ2FsiZ7oqgRcXr1bpsPTpQaG6Q0UmP8ZE9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130003
X-Proofpoint-ORIG-GUID: 2Jz8eTxRJNPsMyqoYAprjLZMreBIaxmj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDAwNCBTYWx0ZWRfXzjw3bBfjg0tV
 zKMLqAP9ALuHBrSYKlPwXKAbkBT5pS7cSxmytMQalxG2Ck2hpLozPkNtD/vTW9HZAVTuOs6PtXs
 Bn6hD0aHzAYe5HG/ph2OXuyuBfekrqg8Y3FA0nPe6kmkkOv4hhJVDo2KIn6aveQNv2lzr+G6POl
 HnhNAL42L6/W4KlzTXpgtY3n+1foWSPcryRLHHKJjtFeTNd9MD03NnQ25tCIr17AUl+6IsSGdXY
 A/XjJQj3pn5ql6DaOZsY2ZG3ATAYvRwZ3OmdlOTBP0/fuF2r7cwrV/Nn0pGy2uesFmQrUS4wgZw
 Wyso/3hU1Um8glh/NfqlEhjc0kWNyBuvLUzdc4FvxhjVcvNUJgIDSn7Tiv5KsgnhQh105Jnjk2R
 MABTgoXvIrtmk6Ac9O8I862tixbPLYhkfCauOlMBxn6zMJYVWx+7lEEcP/nDIoJG5HwtMGWr
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=689bdcf2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8
 a=oHvirCaBAAAA:8 a=VwQbUJbxAAAA:8 a=hSkVLCK3AAAA:8 a=4RBUngkUAAAA:8
 a=nmz7heR2Q2xZR9Q-WY0A:9 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10
 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22
 a=cQPPKAXgyycSBL8etih5:22 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Proofpoint-GUID: 2Jz8eTxRJNPsMyqoYAprjLZMreBIaxmj
X-Rspam-User: 
X-Rspamd-Queue-Id: 97F08C000B
X-Rspamd-Server: rspam06
X-Stat-Signature: oh6w9o8b8d3xeh9weynrygzhcwinf6xc
X-HE-Tag: 1755045125-413886
X-HE-Meta: U2FsdGVkX1+xMd/3+Zo5EpMHbImxqLH7QbLKg8FDyYD6B34sZr9axvi65SxabmjBoxNv2+7wuL0Phd+SCuO76QGJ7aA6D5QB0tgLxPVys9KevxnUz003paTcJ/iFQLqDrErA/YmgZVd8U+B7AKKwIIGEeK8BpVCvT17hOq0iE243aWb1hyLw2Nx3+zMTLLXohCxlzDAWth1dHtTNjF5s6zFD2r+RpRVIOt84+B+0mz5InvT6kq6kx50IFIwjbWta5FMHbpoPE3vFrI6EmitbFFwjTnuP3i+6iYvhpdu1WzUYv1YtyVYBOxNyla0vqc7YRi0jR/3g4p1V0o9yyO8Mk8PDhnI1paQEoYerlCPXnmC9QE0YmbRLtCKjaVTV622C79Da/JQ6KSEATTr87dShSi8JtR9rsZLC+9tfvl9/+6SGLPF/KPpPA7Fw5saEGacxfUKy4aUxCq8cLdVoi5JVwnMcjsKGkUrpaH4HXrPyme+rEPyCditZFqPIkhDW5u2jBJtIZwDEVHt9aecyh1HLemy98FLbHDe6X2GlBB9YL4UgYd2vVN6m9iO8p6VB62LOInBbZHiBzEgwbLuwlRiUWKK1Dh1gmHomtkboZdvYA5tqsvNEcwHUstn9UAVKm0GJ3yoF6WzzvFKT2ZLyRboxtTzx3fZDRkB0uNCO0vhrlO04Bgg4aB87PiMVQYHfCJ2R3xN5Zd38ItguGWE1JO8tGhahl1GwbssyaFAmo/9zpTbFNj/juEDZv+dGTi4jYooSWJUvfCCDbKfJ3mMVRoJyKda4hg9sekxVsexRSB08U31rKnSCchxGUrHPgEbJL0DXe90odpPyLnYRJtGPYZLSDaXjib9GvDbT9LeN9guuhKCz2F7EzHlz6oIVp+sbn+qnQGJRL5wCNvJ4z7VkQTDqjVkVd+e8vesFlqhLLxUYIrk1hqL8vRJfK2e4Gqz2zgjp0V/UZGm7rbJMgTRdYwW
 mTgW0t6L
 elwKxNnClRa1j/X5dQ6jKSh9NkKl78Mksw10Fe3a6Txk2+QsbNPqNu0X4KgtMe+XfZs4Ij8+DUx8fOD7Gm8luQhpf+r6GpsEEm7Vr8mBII2jCHBgc5D402Ql3YWN7kkrbHpa40tqHYAmNp8Z8QnLMdZRvrStm4bFHX8gy93HG4E6GujD9/HTIl/pP5wHwJSL6UpC0kqwAnCVVPhOd+TuAckyzqhF7B78LsXEbK1nCSM9gS8IlH0Y2m7qUOL6+PhHRZVrxMzcxBLdXuLALklEVE/G0exdGaoNC1L4aDF6dWAjGXOvjq7fI5nDvSgMMj5OSI+as9ejgmQXRRdKdVU4Cqnt9OOsMLUsOYh5OoPVTZ8E7QdIdA0v0akO5KEzzb3uqZ0YpAvFaKe+rIXvBi3TW5WhWF87yW1rTVwAgPVG099pTfEDQcGKlh0kA271LOW56dyY3osGNhxNc71B423iurzDY2+scAufszfxeo7zkxpGgR8l/nToyw80ACk3rCOJC9zQrSvrbxxVD1mUs1vzyF3GhpTG0y7pVOwx0F3s6RC9Yg83YtJiNKlJhlVIsciY5zF41E//KFmIcZW7gXh8lYOSaVAHvDddmhC1BgzclgtLmOQuPbo7hbLg9/ZMxaf8qVLMddjWAoNJRWw+KylG7RdhT01cFeKe12nCBPzubUer27yunjkn1MNAY3PUZ9UFY7Ecb8fALKS9tsSIaIjuKkNP8TmWaLfCJTiLA7SYLrZrQkUgtNI0KjgkU6pvT6fNgmvA42eEZgibx8Qc8/K33Q2Z1C8hzPd6pvZ/zjPWm2mpOpExXPAitvC6q7yKJ10lOsBgQhfKVfNWmX1HUKBSXrzpqDooBh3Ubc+ZBKCeokNf1O1cutoP2xyOFgjWt4I+tnHsN9MKoqgPeucbMONoYcv29jq+R5Z5XCq779QvDqEfPfBOEO5UDQ1Xsw3xkK6gmGrxBeWyR0t5Pq6bDYPFi4nxCrPp4
 B//XTyyC
 OaLk9h66Df5PuiCYtvvIjmlx/btC9CY7tMV6mb7eDQCPZqX+aX4/PGPokmg4FT3aCLiIH3dgrrv40Fp5Q3B/mUIHPPbE00lu75x3vUJpDiHRXaRIDvbbv2mNysbZby/GvGz2P6ZrO2qyA9IgkMtxh3EGA8M/d2PpqM/oYyeaEEKw6fk6fQgRl4mmVUwYxF8iKAuSq/azChXALaC7QVqR0I0EOaGzT3vSUnqUIafKt1TJQxScm02bTAio4dGtPNhHRCOpKHciEl7n3BN87A5Pqg8nn9RtuFDSnrcwgTbpcFX8yUg2L70F4OTM3rHsEqjrlbABVDkOi/6zraKc0csPzAvEbP0OjL9DzVPmiuLu38BygPns5ROyT2gcPyw1kDGnS4/vN9yV0JOzOXoUskk0PIzO3lqTQ8GCcZ0ypXfzJNf+BochEMZsJ/qRWJubjOJXuHOhmZeDtB+W/3rrrw+YVW4//WX+YJcT8BJn3AGUPc41ZQiDATgxbz0Qa86tLJZdTAYz9Iy6TfoSBz0sSm9TJBlsNfXPvIm1I7+uG7lh2SW/tMZroNZAtUGbMUI2a+B8WFnYerPjGe9l36SI3AX0xWRdtS5+ObkVNYZpKPNC47GMc1tXo6I89A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 02:56:35PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=1568cc34580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
> dashboard link: https://syzkaller.appspot.com/bug?extid=3f9768ec54c86997ddfb
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132b19a2580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164da842580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3f9768ec54c86997ddfb@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 6777 at mm/page_alloc.c:5124 __alloc_frozen_pages_noprof+0xd0/0x318 mm/page_alloc.c:5124
> Modules linked in:
> CPU: 1 UID: 0 PID: 6777 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/18/2025
> pstate: 23400005 (nzCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
> pc : __alloc_frozen_pages_noprof+0xd0/0x318 mm/page_alloc.c:5124
> lr : __alloc_frozen_pages_noprof+0xac/0x318 mm/page_alloc.c:5118
> sp : ffff8000a3d575e0
> x29: ffff8000a3d576b0 x28: 1fffe00018f73d00 x27: ffff8000a3d57980
> x26: 1ffff00012eb431c x25: dfff800000000000 x24: ffff8000a3d57600
> x23: ffff7000147aaec0 x22: 0000000000000000 x21: 0000000000040d40
> x20: 0000000000000000 x19: 0000000000000024 x18: 1fffe000337a0688
> x17: ffff0001fea8c8b0 x16: ffff80008af6de48 x15: 0000000000000005
> x14: 1ffff000147aaec4 x13: 0000000000000000 x12: 0000000000000000
> x11: ffff7000147aaec9 x10: dfff800000000000 x9 : 0000000000000001
> x8 : ffff800092df4000 x7 : 0000000000000000 x6 : ffff8000802312a4
> x5 : ffff0000c7b3db38 x4 : 0000000000000000 x3 : 0000000000000020
> x2 : 0000000000000008 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>  __alloc_frozen_pages_noprof+0xd0/0x318 mm/page_alloc.c:5124 (P)

The warning is:

	/*
	 * There are several places where we assume that the order value is sane
	 * so bail out early if the request is out of bound.
	 */
	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
		return NULL;

There's not much the buddy allocator can do when a user requests
order > MAX_PAGE_ORDER allocations.

>  alloc_pages_mpol+0x1e4/0x460 mm/mempolicy.c:2416
>  alloc_frozen_pages_noprof+0xe0/0x210 mm/mempolicy.c:2487
>  ___kmalloc_large_node+0xac/0x154 mm/slub.c:4306
>  __kmalloc_large_node_noprof+0x2c/0x8c mm/slub.c:4337
>  __do_kmalloc_node mm/slub.c:4353 [inline]
>  __kmalloc_noprof+0x3bc/0x4c8 mm/slub.c:4377
>  kmalloc_noprof include/linux/slab.h:909 [inline]
>  kzalloc_noprof include/linux/slab.h:1039 [inline]
>  v9fs_fid_get_acl+0x64/0x114 fs/9p/acl.c:32

So... 9p FS shouldn't really request that?

Cc'ing 9p FS folks.

>  __v9fs_get_acl fs/9p/acl.c:66 [inline]
>  v9fs_get_acl+0xa8/0x3ac fs/9p/acl.c:92
>  v9fs_qid_iget_dotl fs/9p/vfs_inode_dotl.c:131 [inline]
>  v9fs_inode_from_fid_dotl+0x1d8/0x26c fs/9p/vfs_inode_dotl.c:154
>  v9fs_get_new_inode_from_fid fs/9p/v9fs.h:251 [inline]
>  v9fs_mount+0x5b8/0x910 fs/9p/vfs_super.c:144
>  legacy_get_tree+0xd4/0x16c fs/fs_context.c:666
>  vfs_get_tree+0x90/0x28c fs/super.c:1815
>  do_new_mount+0x278/0x7f4 fs/namespace.c:3805
>  path_mount+0x5b4/0xde0 fs/namespace.c:4120
>  do_mount fs/namespace.c:4133 [inline]
>  __do_sys_mount fs/namespace.c:4344 [inline]
>  __se_sys_mount fs/namespace.c:4321 [inline]
>  __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4321
>  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>  invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
>  el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>  el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
>  el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
> irq event stamp: 3156
> hardirqs last  enabled at (3155): [<ffff800080c6f5fc>] kasan_quarantine_put+0x1a0/0x1c8 mm/kasan/quarantine.c:234
> hardirqs last disabled at (3156): [<ffff80008b001bfc>] el1_brk64+0x1c/0x48 arch/arm64/kernel/entry-common.c:574
> softirqs last  enabled at (2974): [<ffff800080aab748>] spin_unlock_bh include/linux/spinlock.h:396 [inline]
> softirqs last  enabled at (2974): [<ffff800080aab748>] bdi_register_va+0x534/0x7e4 mm/backing-dev.c:1114
> softirqs last disabled at (2972): [<ffff800080aab534>] spin_lock_bh include/linux/spinlock.h:356 [inline]
> softirqs last disabled at (2972): [<ffff800080aab534>] bdi_register_va+0x320/0x7e4 mm/backing-dev.c:1104
> ---[ end trace 0000000000000000 ]---
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

