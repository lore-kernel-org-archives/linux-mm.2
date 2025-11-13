Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6993DCD4F2B
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575EB8E0009; Wed, 12 Nov 2025 19:43:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8A38E0003; Wed, 12 Nov 2025 19:43:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8CF8E0009; Wed, 12 Nov 2025 19:43:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 151B28E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6079BAF1A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:38 +0000 (UTC)
X-FDA: 84103735716.21.C63E42C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 70A4B40008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="c2rkz/84";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="nFBl/u64";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762994615; a=rsa-sha256;
	cv=pass;
	b=uQUNvUSwJU+AfPrHfNkKnftancRcJyoqGA7Yp7A0I/ibZ9BRbBckExTo4O2VDS7oEBzoSf
	mbq8AdHlYHXibHFQ7sWxf0MuquyH0C9d2aTBZIgW847LUrGLCw339nl5vPhUVDCXJy3AiH
	GTuT/dtbsj5zSBymWlQYiNPT7I43Jdg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="c2rkz/84";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="nFBl/u64";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8zAw4gsKoL6WBHHtHI5p1YtP3MsRICoeABDZU0WaSk=;
	b=MWdJ67zwtz58+34ZeR+A/K7uhKu/4a02slM3x3Mva0Gg8R1wNp3q2CV2K2GeHLvXOjA72Y
	yf+xRt/mvD62/VHUDO0TzJKzSHVo8zNbxZxeIwZufgQGgzv6BmLk+kTrAZV3pQ17RBsDSi
	tyPrd7tIc1Soxvd/LtRwvAFSBg+UGGQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACNuMWU015587;
	Thu, 13 Nov 2025 00:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Z8zAw4gsKoL6WBHHtH
	I5p1YtP3MsRICoeABDZU0WaSk=; b=c2rkz/84IDzfKPzFRsUU5+HYoGRXcdncxq
	mowX3uKlXJIeQaz3KC/k21xkz7IPbxWFGO5t4CnxnciUHrJpIphc262g77FwD4Qi
	aRbde2P0ct7MilLQ3GnrqrziLEySJ/YAbuPCu+arvRGJeDGeVZ1cs75LXpMI+PdJ
	I2QK7/AKKK7ZPuP4f45dHdNfkkS32P9+eFuzQPtvFYMSUiNgxHPnDsJIAp1kbmSg
	y33esTIK3a/7OD4/ZiQSh98lWc4AuY/8H6L7FBqkI+UrKBNyuyVQJg3SvUhbcC58
	R4NIwzYWS+sOIMzEFqg08QMqi7MpuUDtch8/M1xduN8VkgtDXbng==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyjt8kw3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 00:43:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACM6crr011358;
	Thu, 13 Nov 2025 00:43:29 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010023.outbound.protection.outlook.com [52.101.61.23])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaeyjmg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 00:43:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DRIP+N0yoLxpMc7h6rtffbZr5F9ixS2cmuoeG/tghV8CuwJWs/T62IC8TNF5A3y5vdbxoil7bwcgRbROKMzrQhCCXMkjWIuloE7FKbLRC+BAmCSIwLSIgmthLMA4RstEFvy4ASWIr4rm0PdgloGSzWxwsXDQLno66mi+Ji9J+KY00FnbatYLXwZuKWtLvGKTWOkVbcUa+xKnCyCSjtLXzYsBX/W0hHf8FDyDZZDsgy3HUJN6DG4zcWel9nfP0yk+jSKc1zULLUNBF8auu8phZaeDiTePHivXWSQF/Vrh+nmyZb1OrNF0sSYOY5r0eJZVRIwr1uVVBp3KK+nE/nPFjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z8zAw4gsKoL6WBHHtHI5p1YtP3MsRICoeABDZU0WaSk=;
 b=imU1cK4BsY6D3v64zBou0BdNTz7/YhKk7M4Iybjk+I5NxxroSjl/fhpQFf+8RE69V9pxtpH+u+LCLjJG3OH5tJBdYmZXj1b0jDBNXwshnyOJWV40uWwlRkml3yNFgzEBBpbV0IbrP364T/amwk8ted5ae96CjA8A6+yZDTCAwUd9x42njzLeO8auo7cM+rYATXlnEzP+pwGcicZJLVl3vLIenKVqrZ99TW5RWUzehPIEhfSXptSe4T1O8Jy3Opzzo9p3UpblifHg/PSDEFluZcGOksFcKC+CTtR+1jwy+5uoMkyijQUQus4c/LNQ7haDHp+FAWpbKT+8C7kUg+AVNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8zAw4gsKoL6WBHHtHI5p1YtP3MsRICoeABDZU0WaSk=;
 b=nFBl/u64inAJ0qeVQrp641pR9B+boR9AaPsZaoeXrgWCUcNj36vsMHUR7H3BeKZzq5Xw8mXwuUlyTrKCiwxczPcGFK//gHKbAhNWRynGdlo7xlfRu0Jjk3d7Ag8QMiJUQ34ZRF2r9Y1gKiE3d01cxD1QcgjVagFGaUPGhYI15Vk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB6810.namprd10.prod.outlook.com (2603:10b6:610:140::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 00:43:26 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 00:43:26 +0000
Date: Thu, 13 Nov 2025 09:43:20 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Tytus Rogalewski <tytanick@gmail.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH V1] mm/slub: fix memory leak in free_to_pcs_bulk()
Message-ID: <aRUpqFS8pU0qGIsb@hyeyoo>
References: <20251111125331.12246-1-harry.yoo@oracle.com>
 <20251112184645.GP196391@frogsfrogsfrogs>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112184645.GP196391@frogsfrogsfrogs>
X-ClientProxiedBy: SL2PR03CA0006.apcprd03.prod.outlook.com
 (2603:1096:100:55::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: 168e1f8c-ea34-47d7-9289-08de224da821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wbLblLuxdIO5Eb1puJZqDus6dN+fmOOSbpvLd0vcDoeslMcVHGR1ixLqQrQd?=
 =?us-ascii?Q?phix5q/eM1JqI2kRSZESRfnKT54h5LGh88rUuVzyKh3/X/lnaS8PEN5rNRUD?=
 =?us-ascii?Q?Wyqo/Uag1qFYXzuZHfs7y+a0S2XbPdBZXA9ODFTdPaFKBTQoePM4fWJ0BH7Q?=
 =?us-ascii?Q?M/Z6PdCoBcB+G6g8KQoxx+2AzIcPe2LSo7pk1R/ketgtGyPXKO62sHlqZE4o?=
 =?us-ascii?Q?MOa3OXzUI1NYZp+5hIRCAXBK+P9tdLH4bRwX3X+JlKM+bDto9AfQHUuFPRhC?=
 =?us-ascii?Q?lPKFqsR9xlP/bCKMYbBW8zFxS15G9PGuGbrNSARbRl0dCRYabtao74nrjRJY?=
 =?us-ascii?Q?+CwaoBLDlAXuBeAG1VR/J2HPYiBiVbq/Tc6tewuct4sbk4eqx5U1JL1LBK+F?=
 =?us-ascii?Q?amUnBI8zdd4jGDXSxIT8e18Bime+/voWGSHyfvRsHr3NJNm9TGUCvLZLrYaN?=
 =?us-ascii?Q?OJfm9ariTAF/dxNmJJojlrRvbcyfUXi9jR1OHlv0hVF5InPpDvGlLDX4XMTI?=
 =?us-ascii?Q?qOkTacEIYX5mAkHkYVrKJIAVXs/TRSqr/0OT0MCz1Hdbd052SgZP3pRsh0Yu?=
 =?us-ascii?Q?+LEDBE/kmeePxZwB82kCvCjLFxznRnfAG87W6WV2bEAV+IqjsQgWABsqPRpT?=
 =?us-ascii?Q?pUoGOuGPNWaIxW+g4PEWgRz/GM1Sypz4pjhszW/HWevVyjFOr0kQXD3cVKyu?=
 =?us-ascii?Q?eZdyBn6qYyJNak6++8wEQ6zpHBGOCTRQZPjCE0o2P+qn8OOFfA7MgNsmXoCh?=
 =?us-ascii?Q?pPVOAKLPTlpSaxX+QNKXZIp/hscet39An/Nd+ThG/c2qjvqPj1ToL0zYGci0?=
 =?us-ascii?Q?FapF57QohC3LCYbuaHKHo+nNESAm227kUdm+B8bm1HfPiDtYSwq5mtwwLrqb?=
 =?us-ascii?Q?av39Vcwa4ndAW+rakflVkHV8Svs+erZKhuxKH0OAdac4mvNSv+4eS8rWSzf7?=
 =?us-ascii?Q?a/8ofLS/ZvCfo4ORy7CXC3Z8X9O8Al4WWicN382ANAqddXd1jPofPpqVFC3P?=
 =?us-ascii?Q?W+HjvwERNiRXQEp4C1qYxlaTdn9Nw43HkL0fIua+SInXkRTnpCj3jcMW4fGf?=
 =?us-ascii?Q?2uQgVGmxKnn1wl6USv8BnjW9pSkE9bUOAApjYDsr7sWPMag85nqJjvVLPjjh?=
 =?us-ascii?Q?c7Rf5YeLBzR5IQ/YsoL5EdHLheN+wuagv+G6Wnr4tqDDsCOuDltksshs/A04?=
 =?us-ascii?Q?r9NhvuZgaVGyJLgdSkVYUdKYc72EQj+F2ZBlvg6B1WIl/pk7I5GVCB7DZ/0n?=
 =?us-ascii?Q?bzs030Wk2srCWG8RvDSToHko0a5YkuEODhqLrCyK7UXncXEiN7wd4c33stD7?=
 =?us-ascii?Q?1WoQ2PREVEwnXMvtslSZ/qT6MBtc0uEZT1k3qxntuEjNnosmie8c1QDs1kf7?=
 =?us-ascii?Q?kZHnm3DOBvCDcvx9CDgeHNvv7TptFyHHEpIyyKMxhD1p//I4/P9sG0H4SAOZ?=
 =?us-ascii?Q?dOmwiYV/Yjweo075GfInoEdJR5h/Uz8j?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mknqr4SmValEXBfHndDfbNOB2B1ZaIjJ+akl9CygAc3RodtsDxcR9B/YtTJE?=
 =?us-ascii?Q?ckDaMJD6CyTjv5Gquf4CzHk6mO+6PTkudX8w7jzH/ou37/vkdy0c0Lh2+Ic7?=
 =?us-ascii?Q?mZDRTUnhrlQGCZEXdqvy/fwJkA6HI9gm0k5bHQqsD4rCkqLyjKj/DaSNHW/A?=
 =?us-ascii?Q?fmAgYU2OrPiT2MvLlwxAc0huY904Z9/Z8btr+XO/LerVaujV+A9IVPgWvxjH?=
 =?us-ascii?Q?Qlp11wT13nuR2nqCWoD2ZcG4bpDaeoUFrUqEWAO0ARu7ZSA2o44BXG4JM7hD?=
 =?us-ascii?Q?Q9nvr1YD5iccD7Y/aQoFKxjUM08ft81TkjjseGXdlJpiFK15skDQBPp99L9x?=
 =?us-ascii?Q?3e7Luf3AHSYh8TELLk8/08KLv2Wf4B7d0AqOpFRSIVTsqdEF0/8R4Zc9++a+?=
 =?us-ascii?Q?I+mVxI2mkECcmOsdCIsylI0zhf7pEkCfwNrqQcDQVhdB+WjBaTvizLgGVTt8?=
 =?us-ascii?Q?x1a2/OfwPNkf2oCw74XeExBMHP6xULDATdGWycFp5JOySob611lBf1Za+TWb?=
 =?us-ascii?Q?1YZkJCaYmz6RZs3j8UC252L+nHYWBy639iiEQ5rFdz4lk8xjzd+Qdr1yyUz4?=
 =?us-ascii?Q?5KpmdPOEXlSlJGcdn00gehWeae/TkEWyqlmkDP8ynXFrG3zT7bZS6efzzUm3?=
 =?us-ascii?Q?KaGD/B7xw1FRBROmMArC7sBzsYeNeJI910HPucrugzDYTuWlhMY/Mri4aA6n?=
 =?us-ascii?Q?ddJCX4dMdW+E3kGra6ZhqyW8XxxEp0PsZ0/Ky8qhqxPLWJuCcQnbT34JNLNB?=
 =?us-ascii?Q?w5MrQLl5AuW0Jok9g3EZyY3WMXrgk4iOIp5kTGuHjysUikzSGZVIdXy3jErF?=
 =?us-ascii?Q?bdwBPi1uTbISRWBf9DGnlzguj27tJphmIp64BEiEGIiRbeuDsFDpHoYI7eLO?=
 =?us-ascii?Q?y7Y0LOVmfx5vjJjAdnQXQwt+C7ry4ML1zYZwHH4hsFFyqur5/fq6DOBRJONx?=
 =?us-ascii?Q?julGKUN45vmtr8W0qkiHrpZx3LcREnjrmUcw6yFJCckZCtsynWmngo41SF1K?=
 =?us-ascii?Q?fCCAzvqNYfF4E1X4180dw9VulkFE0NDvjhVCubkVbmrBfaRzoF+3kTJu7PXS?=
 =?us-ascii?Q?96xGbehKzcASAyjJMzzC3tAHA19V/Uqs4eQR1BFq1UnfPP9hnPQ7EEklrFXi?=
 =?us-ascii?Q?ENnk3lXe7FlJIC/H9pSSHbsyADZW11pU/Inf03pxugxjRFlX44onun9l1yjz?=
 =?us-ascii?Q?5PnSgkVQw98YWsy43sO8xYCq6/sMVfqED9HR5rfShlT/y2ri+7qFfYuhp9kk?=
 =?us-ascii?Q?J58o+e5snPTw/4gHeiQAbi+Q+vIsbi+hPKL59pJpEwMOd0cEAM2t6IelriS2?=
 =?us-ascii?Q?5sBavkgsdda8nvb9CeO3rWG68+SP4c5MmhTRmP/CbRRZIwHIAlmCLanSuri3?=
 =?us-ascii?Q?TtNIb2xXW76E1qX6sutqHRv7IbqOgt3qAV0fKztNmIjzpzJzhgPXictbu+8e?=
 =?us-ascii?Q?DEEyLDDnot9+UpPA+GI82T9+LkXDrPrvymirenv4QEiofqSajl6PUfFr8oVH?=
 =?us-ascii?Q?PgR7hxDudxtCHGycDIbDET2q4x/ONldXcEreD1Cu53nUVXNPtbRQCHVgsJal?=
 =?us-ascii?Q?DwZIBhYiL5zC5OM+sJZWjs24JmuSQYytby6rlO4B?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vlnxNfpgo2qsNpzQp4Yb7/OAEKWCKMKmAl0x74IOTKRLEZhEpg1pIb8xagfe0ghrRq5OVT6BEA1Z5MC8m6+RMahE/LhpQwFQ2pcXTI5njpfQSJ9JeB8L90k8o7PGkdUgfNYiC6HJ6Indf2MrI6fCPv1eso7zgOs5YKwTWqTZDMlMNhJOqnw962V1bgEaDlN3yNuzABeGTKFQZsffdoNjbVieqyIQlaXJxTFOYFTndUo6FtzKAIzpydiN1gMm6T/ZmZO0QW6uElIvLu8OH1DnoAHG8L3hVy9WSsk8/don9Rs2adGWWLHBXp3driGBrTHeZ6gDw6zpYyo53K4QHMRrdUXlffQKwatLuwr87TBjFnuqpPaS258dWzh7gWhWSD+5bwO1xzvAMCSKiq5kCZgZ4ucltv4y0nQ6ZYVaEi2ME0pxYSGZUJsMcXhQ+6d1DM1pI27EZGqcLDoXmgavQaDyXNsuLlqiIyI0aFgzBuQ1u4LhncdSVk7x/Y4+a3yRIX5KRXZXqVjoQo9/VlTIpXNSIH0uxIumsDjUsw7lmqOlFTBmQ/ab0ttrsjAKyMmGbtwDaz2ZSkZ3jDR799/7om4VOFhQQ/V9Dc+C5miyKULk4Ik=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 168e1f8c-ea34-47d7-9289-08de224da821
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 00:43:26.3956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T5yo4WoyAANNFs+W/Yzyq0hv4DooPGnoojiHIgu/DdCc5Wh9yEbNDmL1BZByE1huFznQYONWbcNeICnk+csjmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=937 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130004
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0OSBTYWx0ZWRfX3i1oQD4Nbwbl
 DErFtgpEDwuMGk7ucpJgvHAev86KLIGAOLignsFNXnlQSv3PdOwsepcjzyLTcIUrVNHDomFlzTk
 tUMuerQUAVHYEzbYNJWU2U9khzs8c8Xs/ag6y4/uvI+xxHu3klUg5W29cYb0JI34UEu3Cs7b+UQ
 xjHrwjxPalLvhYU78vtlEH/SPVJzRoNkMQUujgUq1H+68sIgSzFUS/x+85zaMjO8NrEZdP3ce6p
 xuCyUmR6nvf3IZNmdFqvwuoQeSGzAanSzEU5rB/gWiSKkD0qEAu6+vyO/cPpt6Zve2AunmvD9fY
 lCCWdDfjsdqxE2YTawZAJuF15GnornM1Y3ZPCJFkI+mFY+0rqVfLp81hcvNhXufaqkdrlsEsLeQ
 amyfefF1uMGmszVus6jqGOH6YwMQOgGEyUWrb4pL+85WiSijYOM=
X-Authority-Analysis: v=2.4 cv=S6/UAYsP c=1 sm=1 tr=0 ts=691529b2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=S-zBKylFtei0ywai-_IA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12099
X-Proofpoint-ORIG-GUID: _BehSp3V2Ou9Q9DviX_hUfdJXK16PuN2
X-Proofpoint-GUID: _BehSp3V2Ou9Q9DviX_hUfdJXK16PuN2
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 70A4B40008
X-Stat-Signature: 4kfz6dn5qekqdb16obb91x6dk66uxny6
X-Rspam-User: 
X-HE-Tag: 1762994615-718546
X-HE-Meta: U2FsdGVkX1/RAWIKbVxmsjsXLqPavT537kzQouGwk+xxrqlRch5oPmyFIxeZ8tHhwnyXBEhVPZYPUzWEYjZyWkgOQb5kY4jglfd+Ym0UCfYG1oCWHvgCTHn+gptIxD6UwGnjVCRs2ssajeKk+2fxob2DtHH2Owuc20wVMdJdH+NGhtFbOBrPnkliXmlgC/JxJXnCSqqpihrz/etcszfp6iYs15b+YObzF7roRkyjF8whqRd27BfufSJsyDzON9vyYKznaxzRpxkiBK679mGrBgaAG9fCrqkQFbXZGZQRCknLfDkk2dapXozs7EUIKydxF3Dfs3m88s0q/mmSgkL5ou2nS1iKjy1q+RxLyiQ2W5YQOTqUJJc3KMbyYUBlQ3Y0v2l1Fg1ewwo1UbQmM34tstofjWRiRDxk8DsywJccycUxoMjIXKHRNXdgom2KO03aODujnXDU9lEBXqdwiAS8nT2KjyL1ID8xzsfR2TvDPXT0v4Ecr2N5gUZvnW9MOqz1nNusE7riNJI7rEtfq4qQofX9umBHMm4G4fEV8jjrX/lxOtU/3ERgQRhmzY3AkQKR4yf+YYg43okqRR2f1cIZdqf/qfG15L8PmLUb0K3l7pn/EV0ZGfacIFDm4R41dvgCQZCgr54O4ZnVKJGQE/WwgQ4PlEw0XgJiLa8NGM4QuV3FDvfbA9FpFjo4iczTqjtT16hOK5nCosrsB60DNqJ1uDxkdF7v0mKUzbm8RR12J5McuuTWwMT16eOQsl4wm+/EKO3jOa66Sg++swIcaOsA2fBE7635FR8JJ8gyXVIj2CfKWzgtJxNH34UmGf8Ufp4Fh5u/NlwSt06zDg1Z0/aArF+SGfrfz5FQsM8gxqQXUuOFaODQ0SXX51gRtTYJPQuxGj2dUXEooucH/nd5qV9x+BOP/s5jKp6a7a0j0CdC1LNRBg6r5HtFJXAP9pNiWtZOtD014MCP4373jdK/uR8
 xLq+sHss
 Zqb6jX6ql92YA+Qs6clf4fCOYlY94GcUFSNDdFknGJsJfaAVD9vh6xqhh8cYcX9Cy9yBr6lHTAtuoHgS8Wdr6OVkYwAKAtk8XiXqiP0O5cW+8G+3Tz4VIvSicXHOQFzTX+gj36U2kX4IXeekh4T7ebsQj9qdx+G8MppQQ/zvfbb+ELJHNVqBqibb4ZtLRFE1x2/cNK4Aml3FBOitIaTegHTFyZ5qJEreZasfX2NIAb+/jnndPqAqu+S2T/XpTZ63SmDcwaHFupeTbyGYZrSUNv6YKYCMbYbG4QFB/BrtPzXBSNPJgSJrBXcux99vi9N25RpVXywHBR5zyFA7Ak0sWrh4+dNPLTLuDRYGdaWYlYqEDGjKaJiagS4Pz1pu0Xoqy4rYUhgCtW8qr11dS18mTOdnByV/ZMqMOEl4KdUU6bzetiIBa0dAdEy5E8VhH9frv45ArW2n6h6ZKQrRs77i6j6U7kGmtUfq8LLJs+PLNvTDm6ud50a5T8y/uiyMfvdkrm+g3g/1KHqj031BSu6vfQQxomIeV5B+hhSiNxx58UQe1ku6gB8aQlxmUSuPNyBgr14tdQb/OK52tqeBD+17LJ/BBAEwc9rE6JIpGZioHySYfn7jDHSJZwKTwV76AgRpt38AOIF32K2nH13ua/Jdl2NwdQxPdvvlw82iv4yUQWrNKSIMN5W5usWRYQx+SfsKVtA41kZVkLL6MaQk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 10:46:45AM -0800, Darrick J. Wong wrote:
> On Tue, Nov 11, 2025 at 09:53:31PM +0900, Harry Yoo wrote:
> > The commit 989b09b73978 ("slab: skip percpu sheaves for remote object
> > freeing") introduced the remote_objects array in free_to_pcs_bulk() to
> > skip sheaves when objects from a remote node are freed.
> > 
> > However, the array is flushed only when:
> >   1) the array becomes full (++remote_nr >= PCS_BATCH_MAX), or
> >   2) slab_free_hook() returns false and size becomes zero.
> > 
> > When neither of the conditions is met, objects in the array are leaked.
> > This resulted in a memory leak [1], where 82 GiB of memory was allocated
> > for the maple_node cache.
> > 
> > Flush the array after successfully freeing objects to sheaves
> > in the do_free: path.
> > 
> > In the meantime, move the snippet if (!size) goto flush_remote; outside
> > the while loop for readability. Let's say all objects in the array are
> > from a remote node: then we acquire s->cpu_sheaves->lock and try to free
> > an object even when size is zero. This doesn't appear to be harmful,
> > but isn't really readable.
> 
> I'll put this on my test fleet this evening.  Thank you for the quick
> fix! :)

Thanks for testing, Darrick!

-- 
Cheers,
Harry / Hyeonggon

