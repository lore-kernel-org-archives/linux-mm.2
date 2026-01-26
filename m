Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0DD6D19519
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 20:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68456B0088; Mon, 26 Jan 2026 15:20:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D163A6B0089; Mon, 26 Jan 2026 15:20:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6F156B008A; Mon, 26 Jan 2026 15:20:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A139C6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 15:20:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3260B8C6CE
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 20:20:32 +0000 (UTC)
X-FDA: 84375232704.26.25B8E61
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 970F54000B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 20:20:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YBBckuPq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="b7dW/fbU";
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769458828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHtNHORzErmrOhb/9E2t8rkfSDi9H33PCULErGXuLsA=;
	b=PkDIlgUAUJQduKNBGY32QbtMsayRhKHSB4sxKK120UEdRAZX0ukiucyqhHpiwdVDohZPLa
	G5nsOewKqNwamZtY3WX5bzwD2KNKbF8iQ/rj5k6RSo8x9Ol8xAIQ99Qe9QEgPcGJWPd3Zn
	YG2HGnqXzpGEpx3py4XE2fakSOCfVF0=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YBBckuPq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="b7dW/fbU";
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769458828; a=rsa-sha256;
	cv=pass;
	b=s4teAj8KKuIOjZgO48i0rwTbnP+9fW3GrHmkmAn70mY0w6kPEYkZMh12syjqJNWG3kQMM6
	jPLse15uoi8JDC9SMoaMkjeIbhpMnlTGOy+QjycGdEnkfdjw/SBaC3vzCOTMVGVIlliUp5
	GPTVPn70+ZKW1Ma9gSRWpPO5UnjyGn8=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60QHIwZg284197;
	Mon, 26 Jan 2026 20:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GHtNHORzErmrOhb/9E
	2t8rkfSDi9H33PCULErGXuLsA=; b=YBBckuPq9pw0rpFsU8a/cpzHc7W3cqjiNN
	fypWNZXY/8LMPBnLZ+RP27T0osdQOBTzp7YjBuASXu7k5HkU+wVBEWG2XDzKr+Up
	mOcQlZ8L50kTR+ppiobj+V1HCGUxypUQD0XmhovfMHJBEzaoNbqVXXLheKWcYZvZ
	asZG0puughIfl+p5P2QBE70DwYSATln5rlvrnYFYs6iGdo166i+F3rwh9vPmuSUd
	GpqVx2vP+FF5bcWkjKl6s2JhWmNxt5qbKF8cFcTA6W3b9/zrSIk6rqo7+BwK79or
	4dexHf0+KGOxv/at38shj6O4LkwJ6Z7pDZ1lO0qM32q5TUa66PQA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmny2u83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 20:20:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60QJdqYh019841;
	Mon, 26 Jan 2026 20:20:23 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010008.outbound.protection.outlook.com [40.93.198.8])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhdqfv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 20:20:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GgJj5EPTtyREXVUpisU4tnezBHEU7wzuPFKmtZ4Ot1ZNdhHsgN9uDJnP2A1nk40/B7Yn6stENM68JWJG8o2C64u3AdvphGOurYBfjqBGQpKoWVdJgaOprB4tM4AUr4ExHEl7d0d+WDGuUicCDf2DSF882vjZOdcXRjbgxcmjVHQ+xpkmDrp8Dl0XGpd/mzdrq3Bev+xdGN33nNRK5XiBIVOjDHI5CgCxHilVFEWH757kq73B9FhHxdGCV6SYJ/fcZ6QEb+mXdzjASXcbYsFiZt/BDuF3jK0T3hqaYnb7YaEFYJ0GngEQClQ+MAPADZ+nk3ZcoZBnd/DEsU1yvI/Ncg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GHtNHORzErmrOhb/9E2t8rkfSDi9H33PCULErGXuLsA=;
 b=tI4eiODET1WkljZe9zo3+VwKmgL9+fKD1QzQsEDIuxOADOzEAOQ1PueKrWW4Kz7Yxtps/TGJKDu+lKvksjYccTBIjQmVgSL08Skgfkjr2U0W4+B8K16/y+GOpTCS4eLyYd+51GfMoAA/DdKLeVsTKDPeYVvHs6DFyi+vWzU5j/aqHVlZMMLOnZQVKm/Mfp5NBUgOn+jDzdCSaNkvQ94mTWp3sXiVK0Ud7/xaj7k0YRjv5kkXvIIRTjMO2SYWaOpg/L/805VdVcD7ps84y0MaixnD35DV9cJAZz2zdHW1koiNcdP3cE2goR0YZ4viXFy6oZTQn0eFzz/XzQKQNv3BaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHtNHORzErmrOhb/9E2t8rkfSDi9H33PCULErGXuLsA=;
 b=b7dW/fbUxOGG8IUHN/gG2cmrb8yaBjIEgU6totIK5WK/ONErQlaQIH21PbOfKaDAvZqzD5OQ9tYF0CLnbANFD/19jIiZsPuHXPXoihDXft0yKQ0ETFzV5HE6JSha/fm2KJrvA+3rVEDMyhVjGxiu2RTrtwv2uLGQ1myrunqV3I8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB7768.namprd10.prod.outlook.com (2603:10b6:510:30d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 20:20:20 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.015; Mon, 26 Jan 2026
 20:20:20 +0000
Date: Mon, 26 Jan 2026 15:20:17 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrew Ballance <andrewjballance@gmail.com>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] maple_tree: update mas_next[_range] docs
Message-ID: <6fgs2mcvwlitkjza5d7cpu3mk34sqqn53vqazkicyge4gtqt7f@5dvqmpubypip>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <20260118-mas-next-doc-v1-1-827d9f4924ce@google.com>
 <tal36hph2g5azjk33h564bllr2n6bz2xhdw4vcvizkhptedfuq@56chjersnkfe>
 <aXCiv9vOrMTbiJtb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXCiv9vOrMTbiJtb@google.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0304.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB7768:EE_
X-MS-Office365-Filtering-Correlation-Id: f5132aeb-0b7e-466b-85a6-08de5d1853f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u5i3WN+awPYxtacTqWfsj2oWqCbti42wKT29StpHVw7Ymyf4+9T+kYay7zVz?=
 =?us-ascii?Q?xkpq93g18epYNguf0S1UJJ33v26/+s5Twkeu7jkRVpSrP7iUREDi8QqmkLz9?=
 =?us-ascii?Q?Fe4ZjEPyf1rSW0mgjAPy2W0U6QqF7yRdts5O+r+fXYN/sgDUiLhZjlznd3Cs?=
 =?us-ascii?Q?toth52hVWDgDTwGRn48ntGCWnOP7YTmV0JspsHKX304d7Y9wkOwXG34ImY+l?=
 =?us-ascii?Q?GaAabmSnwknx2wn+Ztoq5Dx49ubr6X5evOZu3S6qmleHAiOO/uyApFRz4vc5?=
 =?us-ascii?Q?/+RXIT9grijr0Kt864SbxPktZwMxSU7PolVeFSZjHmLnVTDPeo6+1PQQs4xX?=
 =?us-ascii?Q?pMDQppWyYPEPhnMmci5qXrvRvwrhPyQ1BqweXrMwJec8i14VPMaN+7lSlJnP?=
 =?us-ascii?Q?g1CEjr9QRzmiCnPMVZbFQ7VuVXo4RueaQ4wEScsPUQWR+LVJ6OxiAgoa4W9U?=
 =?us-ascii?Q?ShyH8oneaZgrd3JdOOZMOkywxpBpvmz4/9qWcqe9WpMHlk6brhKgnXs+xOuR?=
 =?us-ascii?Q?KjA8ykv2jDoIHY/VWS7jsGXeN3qGTpaBLSH3PQ1/QijDr0OHoLsRX2kW2f6f?=
 =?us-ascii?Q?BS2nR0BkaUbku12qVJQvAczCyw3E6DfbM0OmJPIzIx93OpN301kB9koE+MCo?=
 =?us-ascii?Q?MTfHGCTy32XltFA/4dKfqPFxZui8P/rFUfR84ZIzLlp77QuDfHfPpJ4ptREZ?=
 =?us-ascii?Q?i+rGoJc3D1SdgBJH4NGkdTzOnquuP1/hLoVlnJcQhu3lXQ5CyO+f3Zi1ou29?=
 =?us-ascii?Q?xgqlTDRDSw/bIAO3G/+cI93IYLeBdD038HAqdt87Anu+QxY6jhncQnO7gcb1?=
 =?us-ascii?Q?+CfUxSAFjIpB61JPfLOPRjepyC79B9d8CoEQufCHXw9Jejlojg4N5C4dF3uZ?=
 =?us-ascii?Q?lReo6O3rNkPfktuMX2eGLCFXySEE0bF5R0inecfyBBHSuXEUrAVr3SNioqaj?=
 =?us-ascii?Q?AWfLB2h6e9iAxsq8y9W9j3/UAZjTq6EY7MlQO6ruU4e//8PUyEqfms5CCxVP?=
 =?us-ascii?Q?Kl/7I0kxTu2V50KxI8Oub6BIfz3noLl3ZfDt8ZTvdpGWzREe1pRvy9+NSCjx?=
 =?us-ascii?Q?URTr8fVXvqGriRPJcWWZQ/3Pqn+qnnOc7O5wC59U7YpoLKg+HkIreFtXoCUX?=
 =?us-ascii?Q?taLaxyYkGwbya+9EQbvnVgwdyqcDZh9WFOnJfNBsRrfWB3dopz9/c/vYly6F?=
 =?us-ascii?Q?1tcMNIll/pmzb6GcgyygB+cJWtBs2GLr/0ZZfI7kLXVLvzI67tuimm17vvFQ?=
 =?us-ascii?Q?BVusqNSooNaDdlry/iBrGwwbO9q77F5lNb+n8NrcyDnDyaSwaHDyOEc+E5gq?=
 =?us-ascii?Q?/b5S1qdiohbFvZtKCoiu8HUFfWSxANH3bzS+BbsGI296lq+3oDnP2vHB91HY?=
 =?us-ascii?Q?RSUaBIJDwlENm56fsQCyCz498gA3xdUOFcMUfrNQTsSeUzq3r9uLBjmZtNfM?=
 =?us-ascii?Q?LufCHekd+TGJkMg5+DlKK3nBECmUwcyPmfecieu686toRWj6DnAdfSKPrC90?=
 =?us-ascii?Q?TmsTe7SS4aHUnXd2W0HfwMT7bvtdOF5rYh7MFK2HuJ1/Ao8H107MSBgaqOsa?=
 =?us-ascii?Q?p+ZQX8U9fLlVgnnXin4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cg4dmkyDyEeSQP8oCDQw23DnnB8k3fTegyYFwhmWcqBLpBXP+C4RsEWFg4oA?=
 =?us-ascii?Q?JzTKNE86xdWs2CrdT8xRjZ49dxCUkoIs9MN4lvdKJXRdJsqq67jbCMUEgwvH?=
 =?us-ascii?Q?wqfjRwMh7aantq+SzhnDpKVsw+kPxYFxFvBcMioLcGVsXbQ4WpHgE/fnxP0l?=
 =?us-ascii?Q?Bqh5WkfFTIDMiKghA5dGzatbzzUkPm+aMVxT88iQ2MBW+04nEuIb1UHifvr5?=
 =?us-ascii?Q?+4L4LCAv6Q0glvH64i/gP/vx5+hJnbcUnmpovgw4GrNDpHuu/2LVfwwXf/XD?=
 =?us-ascii?Q?JK33zsrax29/fXKS4aliQJF1fHt83ul/ehlG4HxvriQXicEWZPxc/7yCickI?=
 =?us-ascii?Q?LvRNtNtr04u4RHP5bLCPkjhgAzWycvf5vV7UpdcBN0iqbBI4W1ECo+QqyJWs?=
 =?us-ascii?Q?AhRDgk0HxV1AFgejcgq+QtaRDDn5qeDgahBQ5PLOzeQFFRt0K9ixWD163JQs?=
 =?us-ascii?Q?fOR4JIQeag9m9ubYfrt2R9od+M3lplep2///XOMC7uvbb1BQf9/6pCOA+Czm?=
 =?us-ascii?Q?x39OQDVbiACL9lRSoulv4JJ6G/Hnq1FTg9oYKRQy3UmbNVBjuBWPYRPtqudU?=
 =?us-ascii?Q?f985A2yXW6/T+xitFZFAR3SVTq3qHCHcXAqYwk40GcFOIgTUV13PBGbXxI5x?=
 =?us-ascii?Q?COyFAfhKKm7DjTmsUtUZDcOtAMe6zylAjZbzppDuvmV8er5q+kN+15UMgpnZ?=
 =?us-ascii?Q?6axVwbUusYjI94o8ys52HsuLbfEWIjngomH7IUe7bdUh6c7JFX+9oyNyqEBD?=
 =?us-ascii?Q?1v1XEbDocID585XhyXQS0CmZz5HSwk5QWVZv+kljMwhJyxzdcQoICcxWg1zQ?=
 =?us-ascii?Q?dPQLkCS9HvYSyi/iYHPpKalVHeDDlAM+gUxRFlEpU+1MRlWUNMg85MFp+plY?=
 =?us-ascii?Q?5hv7ugmTxKCeWX88eS6a6NEKMUKCOqVTvqfkkDIQyCZEW+w8YlY25obAupFu?=
 =?us-ascii?Q?0zp9XS4M953qyAYV6NRb5mggzUEglDrsLEXB4/NdY1xP0GKidU8KkKHI6W/M?=
 =?us-ascii?Q?FnLpdGxo9WfXgc1F28xPhfQNCIsOS8HthM6X0z54V8hZmPXkJ00lfGJaAbel?=
 =?us-ascii?Q?qkEJMThPy2FWHEBvZ7e/kIQKlVtEAVz1W6xdyUb/Op7m44vA5aGbJDJVo25A?=
 =?us-ascii?Q?TYyKtW0KczCWiXQWRZqnJbn0mh3basAfEQ5y02YzSLBU17uJA0p0T8w/6lP7?=
 =?us-ascii?Q?wZujXNcQNTusvnu4ZUDmstiytoxwi+jrTLwBhubDEBKKdUDxCXlAyunMc67q?=
 =?us-ascii?Q?0csYfFxVoZZm/sBcsDzSqxpggKhCcOEsV7RnPynS+ta/QzNnZEfetJdyFO0A?=
 =?us-ascii?Q?TdaMH3JSiL+Byx+r0ylZH4pCzciyzrwVrpUmflRHPVw4XuwFuKvMXjhT/7vs?=
 =?us-ascii?Q?Sdr9s2Y9KIKBVMD/rVzVTp98XQHLTYQqMQt5LSt8vGQNLxrj03XLUyYUXerJ?=
 =?us-ascii?Q?QvEL/ylaXInfAGZmkDhxyHBcZS3/8WZyWd5XlyeF6DazGmeRCO3WCr0tDJ5p?=
 =?us-ascii?Q?JKEN7avtZtqYUVVKSN47mhfM9KLDkElL8xa0V2oqNblku7e3wuHovdiBTq9y?=
 =?us-ascii?Q?dMVxY7dACmKWUoUgnR4vNU6H7VNXkTSWhy5VIq1G3xG+WH0WgbxfozsSlM5J?=
 =?us-ascii?Q?r2dNsvgxqopLA6xOovx3zhlEfXX4ktMKRHAc/uMM7wcaJ3vYv/rkk6Y85cBz?=
 =?us-ascii?Q?piISWgdRTBLPJ8zePuR2LvqbC+xz093cRXp3m/baY75CcDAtx14V2LEoGLYp?=
 =?us-ascii?Q?fxSqA0Tztg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PxeTYczVHsm9J4Y/OKWRNNQXLWuREKtvElnkAaiYWXbwqur5jV4jwosO58k9luizghAY224Blz91XD8yffLUsqxRhZO88AOmoGIClg29HuOQGRkYRT+PFlFjqRVgWGcnflaB3ZzMd7OboFntStdExGGvzIGASo3nM2h9A7VRWFZOcsbfZOmnsiT8MbftFcKQ/dqMHFdkQfv42dqmP5RERpncCPPJAGBhNm8cHARtER3fY7ZlYKeXXQI9fmhuZt0aZUpfiPpblaYdFWFWq5q5L89RrYqHmz47A5nBuno9Sxwyd4Wep+CkoOogjrfi9ZNiU/edD4NfV9hqZ5kkf1zkasYTUuh5zDAV2OtunxwE/iR0hU0bxwTeuNDcsWbAjBcbWIJKVQoUf+sp7Z/48vccU+u85eW0YVCwFlm6zmmdO7mrRYkuz3kDGGHaKDB3OPZJampfuH4o/VAQcbRPD6erpCU/Qvi9TWRxly+bs39xKegNeFIy1QJRVvndaHHzDAZb04vjiA97Y7pSQioSV0IxzWbs86CCa0l0PWNF2n/eKPNQPwK1A+3BiNwTLKwaw2PWe1yre9jzgUHNjSk/g2YkT+vMaTF94QmH6gkGNkvfrAY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5132aeb-0b7e-466b-85a6-08de5d1853f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 20:20:20.4600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wR128awPdI1AmVg6ZNGrVfAvwVQhsNuvw8z5JD+WXjF92KHc/nxKWP3+cUG43RQdZ2x5EgwV+sqQwS9hPKGf7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7768
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_04,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601260173
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDE3MyBTYWx0ZWRfXwNqX9mk/JkH4
 GDwU3PJPAV5iU8HeKHgH6hFO8PPbeCcrfvCrmOmdzutrMERgx1vmVqQOZ64ZUnDhTeZoqwFuFun
 ucvNYDPS+QAO24POFqaHbMZbBDgyWX/MjUpIucANcS2OWFWthaQ1YRP1hqUrMVUFXZnZwwifZ4B
 t0DssP7SgU/s/vu4ZSazz3wOUZUdNPhztI3CExL221HeddmLOp364txTu7BUQ5cD3GEwgKuViYo
 /BDHf1S+rQnADATzfEhdLBoADyJ6ZZP+OzHxfTm3Q5pvliVcC1OG5Lq9runI3FN6pKsThG8WwWP
 Uz+3mxKXZ3LQ9Phon92gULsDsJTHIEA5uWWizdEvNQ4oIKTgqqLDuYKm4GDsj1CuUOzDWEXdfbr
 689dtFWwmp3qyx3nIQe4MbkluLh5if2+E+xoyeGqBbgBXFFxtlvj9/nfoOEom/LCFux596GIcO1
 go2CujLaylJifXAvd05Yni06MV8MVWBlsPwUKND0=
X-Proofpoint-GUID: PyByw5S3uGKNE_drVYCo3YjDMfkMZhy3
X-Authority-Analysis: v=2.4 cv=cZrfb3DM c=1 sm=1 tr=0 ts=6977cc88 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=ANdX_8Teoac9-Hzhv5wA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12103
X-Proofpoint-ORIG-GUID: PyByw5S3uGKNE_drVYCo3YjDMfkMZhy3
X-Stat-Signature: wy9iua99w6dkkq4n3z8pqhpsqfm5xupf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 970F54000B
X-HE-Tag: 1769458828-144315
X-HE-Meta: U2FsdGVkX1+ZxPJlHETRtu4Ehw7kXlHddTKzWlL5kKfNhF+GuP1ive2sXAUERZnvaDxodqYCfm6SE2nagJocafTM4lt4/a6OjVP+58QUgde2xKjtj6+p6xbv7C/pWF9E65zSHb8YOSmVvaQbTfzmnk/Mu0KhUm9lU+JEZxkjnsh5Fpsz+O5bdJI51uUB0eg2pN+vBQ+yWdKTQVcAg17TcouUh203kl9wBU2cuDa7ZMo23/LBcYMErMK+b/azLgyGS8G27sMVpwdguWvDa+sdn3Cv5mYUFogDvr8u8vw2D32Z1ZWKnGwl64Kzt6b61zp8/Fc9CKuKVOc5qbswPA3vbKZzFMtgexlHbqlWC3y4ttB4j06Mq4dGtt89ud/UtZnoi/hi/QvWbjJhNxstAXAJGYx+xhSyceG0VPx/EZcyVER5kXMp5/H/PjmsxNRFlPLid8dsZzOxfnmGJkAelFhyzMO5L34FVu8lqjNOJa/L/LEuHRPlj2+Ctg1vQvK8BHr9tJBcTwxUUFsH5vKEEKBnJISc45s0huo8NBHKedQ3SRYM21zQ3X7Ur3V7Vhh7EimE5R0ByTLFm04EEYJx3T2ULK3x8OaP6uLqlzNvvCBwRUOmXHlBBmxM6pcwcmFGLT5Zy/hpXIWEJgtsHmIhQsfmrqngIzxLCxRCC/9jBycHiFNWCHwy2F0j2JJiTMmrPzQ59juptq3hnj1tEwq4DExx8ckM2p38LjlpF1f7YF09jaI6aJpX3/Re6RKyCcY8807vUhd5FSfIw6zNFvHQhJStaHOYED3ygtl3+MT3PVmBxk6TL6JGmkCa0zboFKzjBHkwPscXyb2o9PCJtjppBh80xUQEcAvLySjbDJJdwAqknoSFoOK1zGhzmJohFBnIFB5o4boV4o5JVNyr3zxsitFqCt9GBlJIlPmZ80TbTahLryEsAdC03v64OxzHz+ahW2Hp9MFvueQ8MPraB/NIGp0
 zbKk2+aE
 IklLcppxW/PyQXNB/T2DVLwq+MKgQahsS7GCD758OxmD6K2PJz9mtepkJps3rvn4PrXfF8RJagGVrnCv9UeKac8sbrs3mP2THcbox4UopQ44dHYiqYeRSM2cBy7RfrHOvrH6ip/RIUaVZSWvGnZl7qrWCeIxVcH5gFCYzQ/n3itIiv4cJ+QsWKWJYmZ1MZUq+zsCmJQth682E0Du+Gm9CZy1fVNNfl7e8gQ1qIWXZvVIO3pKR1lBawFgwLvMWyFmTMIABZlYJF4vlRUL87UqwpF1rv+VHzOpnM/HfD7Lfh+Vtx9fsyWQY2h+m32wPtSPJigPCnFlXb7JFEggopES25/VvDfgKKwboBLP3v3ojHsCgHYZji7aKH5bL1FLJWLcUsynpBqofnnCcmIHhyGxF8fmGuw8+N0Nnw5QXqEhxUKL5kDZH+JOcDTv7vzEwRc1UGA49vzsVcmJ9Nke0v1r8W0U6aymFlqQw9ZQIAQY2fjlHLwMuqJ1yiPLILR1bVqg2JFDFjoPYNLKVAWD9uKEnQMpOGLGRTEUAABG9qp4YU/+pmfzRfYfLQIqMLPYEWsSHZppWIm/e+Vg+Q2pzH4aXcbXkiFi1FoNM7tflAFz+QysNSsxpspc6qd7rUBWF4a515bCtfnCVFFbYmfSg8C7KG9kjKyGsy6TtN+fOWeAgrtaAuDRwhASz3oUzXwpmOk2NMC3t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Alice Ryhl <aliceryhl@google.com> [260121 04:56]:
> On Tue, Jan 20, 2026 at 12:54:47PM -0500, Liam R. Howlett wrote:
> > * Alice Ryhl <aliceryhl@google.com> [260118 06:00]:
> > > If you read the docs, it sounds like the difference between these
> > > functions is whether mas->index and mas->last are updated. However, if
> > > you read the implementation, you will instead find that the difference
> > > is whether NULL entries are skipped.
> > 
> > This is not the intent.
> > 
> > mas_ should return special values including the XA_ZERO_ENTRY.
> > 
> > mas_next() should get the next non-NULL value.
> > 
> > mas_next_range() should advance the maple state to the next range,
> > regardless of what is in the range (NULL, special, or a regular entry).
> > 
> > Both should update the mas->index and mas->last values, if it moves
> > (ie, no error state is encountered).
> 
> I guess I'm a bit confused about the difference between XA_ZERO_ENTRY
> and returning NULL. Isn't the case where we return NULL when a slot has
> been reserved but not inserted yet?

mas_ will return the special entries.

mtree_ will return NULL on special entries.  I think this is just
mtree_load().

If you want to use your own locking and use mas_, then you can filter
out the special entries yourself.

If you want to use the normal api, then the special entries are filtered
for you.

This way you can mix/match the apis but the noral api still remains
simple to use - even if there are advanced users that mixed in.

The idea is that if you're using the advanced interface and storing
special entries, then you probably want to do something different on
those entries - at least sometimes.

> 
> Like the docs, you use "get" vs "advance" wording here, but I don't
> think there's any difference behavior-wise? Is one intended?

On return type, no, there isn't a difference.  The difference is where
the mas points in the end (mas->offset, mas->index, mas->last).

If a NULL is encountered bu mas_next(), then we proceed to the next slot
(which must have a value, if there is a next slot).  So, mas_next() will
always return the next entry until there is not a next entry - then it
returns NULL.  Note that mas_next() takes an 'end' value where we'll
stop advancing slots regardless if there are values.

If a NULL is encountered by mas_next_range(), then we return the NULL.
So, in this way, we can move to the next range even if it's NULL.

I hope this makes the difference more clear?

Thanks,
Liam


