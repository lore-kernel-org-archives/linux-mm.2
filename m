Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63347EED618
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 16:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3D96B0005; Thu,  1 Jan 2026 11:54:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557206B0089; Thu,  1 Jan 2026 11:54:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6FC6B008A; Thu,  1 Jan 2026 11:54:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2622C6B0005
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 11:54:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB6B91A9FD5
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 16:54:44 +0000 (UTC)
X-FDA: 84283994088.30.0FEE550
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6CD814000E
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 16:54:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="qs/pPaDn";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=R98CDEEH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767286481; a=rsa-sha256;
	cv=pass;
	b=6kXFuHrHvoeocylWwEMKV+Mv1UoUii+qZSNhMp9XKZjWXLXOY/qBruLgToOSs02Il9R7vx
	chIP0sJ4xG9ryOPtmJ2nftPsqN0Fe2cbl/tXNU0L+PgBVm6PH5ZNY7TqGhZuxTrJqVJmRp
	DysuImTNHJPFBHkyhi75xAKcCkqhxOk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="qs/pPaDn";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=R98CDEEH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767286481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbbA/Ei8xvL3l7Ja8X3/5XCXjUPkbTxmIJnEl66jKYA=;
	b=0NsGFbrdIV+qvPitcc5wsvY3lNZqAwRMT4gB8NcFZf3knWM6gMxN+m0qC6T6xgBoR/3Xb2
	/dNTfyMA15zTjdpDCDcW2IYFyKQnn1qJZtY7KxQnCmFbfJH1RxZ1B3qdL1KH3tjShSSZ67
	xZjVd+D4O1MoKoQ33wzIrzS94boCxA4=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 601GSTAh915070;
	Thu, 1 Jan 2026 16:54:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lbbA/Ei8xvL3l7Ja8X
	3/5XCXjUPkbTxmIJnEl66jKYA=; b=qs/pPaDnJfrFIAfJSQyE2t1F8s90V37OLG
	bNIy6LOwGZ8yv5GKjS+07cK89VLOmRCfvHRrR4dyOTsz6OHWUO1KIlfrTN+0t6HM
	ilybA+Z79jk6lFuSwSFcGRXcRkg5Q8h+4TdA635xYgc0BBbdeo4hXWDdbjUNUeru
	GGK+IZn+BgvA7eX4rMJL4gWv91mhBm3DxS8RkSzVKNM1vRP4WJQm8DuVpWIvBqLh
	BqFbNh+h9Cx4cPfMMqWn1FFb0V8jbg+FqR5Y7aX7ZQMi7/BgWaDS9wgsJpFpMJ5w
	cVImq1UB0lQ/D3yZO0ngP4UMGdaZOg1q50EQBl6BqxoVMvtTz0uQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba61wcfmg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jan 2026 16:54:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 601BVGNO022338;
	Thu, 1 Jan 2026 16:54:33 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010003.outbound.protection.outlook.com [40.93.198.3])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5w9a3wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jan 2026 16:54:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RkkTQ12zPWWfcM30NejGf/Rdl2hiBQbkXs/mq+d74XnGLIYtLCDhewTqP0MT5yQESI8pCtjwV7xF0iUqpkCCMyV/DaoMDc29FqvU7jpdOOPTSAw0w3lIFZQnFjklldMoWl48dIlOr1ohCtctuX/jlaHapUaJ/ZTAzsTvCeqwy4Ic3u7Ya1Y3JqiGf2NWKGX4C1DDSFbFe6dzzixJjcH0QZNhW6ore4Y2gbEJPKHhwpDUkC8ATPqxfWCD2DjrZcdHw+gP93jeTf0b1G5iwbSL0KDY3T8+kkO/WUCj0x3ix4jUmc2DLYSDPkohKOE+JEtS7BAG9Yg14NJLJ/FNjUqImg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lbbA/Ei8xvL3l7Ja8X3/5XCXjUPkbTxmIJnEl66jKYA=;
 b=ZjnmAksL/KEaTuf2ywBhwHmeqNV8E47RxZci/4puk/ym/mBeIZOLp6jq7uhSy4cY/9LV9PnVBUbdXKR+grSAIG/OcsEzdto8+fCL04MQ0RReH4dZqBJEBbLzKlNmWC+jX5JXlf7GHYKRv2xhj4ssuqTrD2RnDtdCqR2JNylMIbA6rrCSOhrThXpss0zYnL94LNgPjp07Uuo3k66yt410epoh5dGVxK7UckFQ6d4CLL0Mf8DCcVF3Dj5fhXTlupzK/nFsVkPNDEGomtZhLtZO4HlgPWRlUtmezPVUr7tqOm3j78X4J/iNexPBAKZf3dQ53O0jf2U+HuXo/mpYI7h50w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbbA/Ei8xvL3l7Ja8X3/5XCXjUPkbTxmIJnEl66jKYA=;
 b=R98CDEEHFesw3f0q6JFM6QMxRbYFWO4zkbMeytuxtee3UZcgehdIMJuoZyFgs8fcVTsCASv+8M+CAPb8QGOW1VeezPSe8+5aM1vEf1DT3/ooXAjp3nCI1v6E4rOP9byLPJMjGbBom3W2WmjMTuppb056x2rEOhjejM78UzLglTc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5205.namprd10.prod.outlook.com (2603:10b6:408:116::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 1 Jan
 2026 16:54:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Thu, 1 Jan 2026
 16:54:30 +0000
Date: Thu, 1 Jan 2026 16:54:32 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jeongjun Park <aha310510@gmail.com>
Cc: harry.yoo@oracle.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
        david@kernel.org, jannh@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, riel@surriel.com,
        syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Message-ID: <1de1c501-e4e2-46ef-b7e8-5972f6a21930@lucifer.local>
References: <aVTJt9M-A1BL8w5O@hyeyoo>
 <20260101130906.839504-1-aha310510@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101130906.839504-1-aha310510@gmail.com>
X-ClientProxiedBy: LO6P265CA0006.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5205:EE_
X-MS-Office365-Filtering-Correlation-Id: d061e415-1868-447e-8d58-08de49566ecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xV9BByEoE6w8dhME+e4lkOsDB0+kABu8IAMohoWz32o8bWKovlpktMxOpZQf?=
 =?us-ascii?Q?JKhe3V1Bs74jDwqniPiAGCqlr7nYZa5APdxtWhgukrU35IAsd+Dto053lQDK?=
 =?us-ascii?Q?0/m2KAbiJDdcU/t4JixdA7hucRwgzIhX3UqK6SxrH+CPZhIVwffoWNR9M2pW?=
 =?us-ascii?Q?uEEmVtfv8Z0yaBw0T8xUrzwWsbljquwVeFqXYa/EVYqXw4Zj1Y2JBrHZ9ULF?=
 =?us-ascii?Q?zHRR2rHzGtSQ76xgOnq66FxxWihqmbV+0KPMf3GAQNzc047TDG4h5uk0G4we?=
 =?us-ascii?Q?1F6+aRt8lNeTAJUsYWyQJrxUuUM61hCuF69VMD/dBFT5pzyJ2HfhqjsdU6tg?=
 =?us-ascii?Q?0YTDBOC7scG2VDXr87/WJHdp+fka5LppkHRHDn5kLHxOJawtS1H56/cKr6zw?=
 =?us-ascii?Q?SUPOwHmEsXhkUSx/6VYryrxDO2VdYYfbUkXZpiQr6SHmnbcdet9poVlza/l7?=
 =?us-ascii?Q?Cox7Pn8xmNn+eLF5yOKPV59AkqDvUQy/Y88KvUiXxWlzTsZNeIL40XKmxyTr?=
 =?us-ascii?Q?xW2aoSlcjWnmKmFjHVap+ZCa9x1+fR2GDWCbjxJCAg68U/gT2L8lrMfa0bsy?=
 =?us-ascii?Q?ocSekz8+CU7q1KaXqhvaT8HF8N9W7wX5j8flBJtzPsiv9fbk8T3SBBuDbuDF?=
 =?us-ascii?Q?FAbLn5CyEpM05rkHtRb16bkuCs9C3ftVPwKlsqeH7x3JiTMjsAEVQzVw2vm+?=
 =?us-ascii?Q?ikrEZMTUcWZ9AFuHZycMmGDfct8GAskBJSreclVDNdXbNJ4xgCwFWguacDUe?=
 =?us-ascii?Q?4eDJezVfCx2x4FdrM/HJaM2lsSFgYSvls1fTcjuU2OR3B3ah7u8BMGa9QBYS?=
 =?us-ascii?Q?D2wqBA4KDkbnq9iN9+8w4PMD+Duci5UJj92XlAnJcK6HPZjDgloFYHL8fXP+?=
 =?us-ascii?Q?w6rrMEG5DXJeA4JITpVx7Dn6srDkquHICEmCvwEA/sz3qQMs+5eZGSh/ZlVA?=
 =?us-ascii?Q?wLHmqIMG18cS8Izz0ZlGd94oP+LzED4mcslO8u35o2cPnlihNaVcvqRscH8B?=
 =?us-ascii?Q?6OvXpUvQLBaMgQm+nKFGGop8moUZD3Qf4BRk/iWr2ytwREQKLxLIzWPUeMEw?=
 =?us-ascii?Q?w8Xtkw/Pyukk+PoKYr53pjKh9L9cLJE47SHqfeQLqNn1Gnqpa/BK605Y0nse?=
 =?us-ascii?Q?f/dA8lU/Uj14wfCj6Ko67PAjmGW2A1AgJt7YvsFCrQDdUx2xdro194HNqmgU?=
 =?us-ascii?Q?irnVmryOo/HkCaGutC1X96/3J9hyUA3uFubEjFSzOKbANPH9bB3Mzx6v5QQT?=
 =?us-ascii?Q?z8tZ1XgflNeXaZh73C9oWILIDtBHeZQ2+Wd21shkFhLLjLc1n5Yvqgbq15yV?=
 =?us-ascii?Q?uKQ2tY6pudf1K4E+7S7EfYvPosM59tdvU7DKLopxbclkRKvZ/OUBg2PFs/8U?=
 =?us-ascii?Q?4mbLsKcqfof2D67mVIqPO1ViMUq6fC96Pnd/Jx7756kvmEaBNM42/dUeGGPR?=
 =?us-ascii?Q?5m2ud9+IFwGBwQtJL0wbVEJBp+3mdDAE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3vFD1Z8CqeGwshjDy3j/sAK36kRMfHzHXguV5YzqSMsRUjMy+qHB3xRUkCF1?=
 =?us-ascii?Q?1i+9II/pqts5Ex+siCfvRpXL2fMIR37VPGCb5jv9KXA5WcsysTdq7kQ6ERxw?=
 =?us-ascii?Q?7wEyHPVa08wV560o3qUy0/y2vCsNz8r3olgayvLSrw76u9n960Klj3bSHlG/?=
 =?us-ascii?Q?Kk1tGtISuZm5+ibjLJANZcUb4VSDOHqsYj09/TYneU7mYImvtDWToHlkF0pa?=
 =?us-ascii?Q?NhE0+h6eeI0oEebH0Zh9qbG5aJTAbR5LACFMgd3Zn/HLb7WOfgq71m5EhmM3?=
 =?us-ascii?Q?2scXmUnHF+V8iP6PSn5RjQ5Myoau6RHw8qYt3b1rnhHnEwOKqZg5jzdVH67p?=
 =?us-ascii?Q?gDR5Qg6Z5SqbmeT2U0RFUk6KkYeR+wfqpwEV+JosBnO0YHW+mZCCdpz7ivkv?=
 =?us-ascii?Q?usCJKP9sr0rZvfEDQFOJcdkN2FfBGAhu1cYOJdUavR5CsusVo5X4pdF4kJnW?=
 =?us-ascii?Q?t7IJ6BtM7kxtn27Wrb000ID1kPhg6cThJ9fW9WjObrisWXZJy4yMVt5qz72U?=
 =?us-ascii?Q?wa+dpHKRPuNWN98LYpTNXavbfKNwhnxtMeIidJWWS+No20z9pGICRPgXHtKT?=
 =?us-ascii?Q?ROfiQ5o5FPz5LcmJutNFMhq2j0UEJB+oxurz2bqGTn59XBazu6TLWdGPocV8?=
 =?us-ascii?Q?sgAsOizY2nl++ZoYXsBLmiOfiARs3vQbccggfpMmXrrM5T+A+rp05PD+qqc2?=
 =?us-ascii?Q?0K0MXOY9eyutVSeNjugmwvaZiLfdCDArM1gHMWpYILDTvHtvhvDbdNMFPeMu?=
 =?us-ascii?Q?nRD+Di6nUGBkP0nWwY9YcXtf5S7GvH2MQ1py/8ZhHFhM53tsRidBWNFu33j4?=
 =?us-ascii?Q?MO8AukwSwjH/ey2crewhDWj6HeLTP6PSZ5zrqfUtsjYQvWqyLpe0xFSnQeES?=
 =?us-ascii?Q?YbqNjhGAOmULGLAZjrmPTkSqYtmtlG5JF+ogi7pWQvsHxQ9XFoSGREg5YRNr?=
 =?us-ascii?Q?iAu0YO/gT8BqrR23D2Lj5XquleMO0r+X5ViGDL26sf0zRkuegGe0HwxPhfvW?=
 =?us-ascii?Q?5p6hFgjkFcrn3KY/osIghmCpheVUj4iF/oh7QQxnSQeO4Vw1FevDdmLTasAY?=
 =?us-ascii?Q?9Yjw2yM2g6GUS7BgC8O090hUBA1gHvOGsT4Gi200kx2+ljmu1sAf/FubyyRB?=
 =?us-ascii?Q?48AAQlrAQhaoXX0yuXmht/m3MOYnjW2ZPetX4sBX8izxOu1HxJ20yaGKK3Rr?=
 =?us-ascii?Q?nuSDCa3ePdP6+jtDt9yP4N+nlWEAXedNK5BK3vj5grYszCOxpHsWZSy41SlC?=
 =?us-ascii?Q?VU8kC0hPDBOREeuHzetrCi4ueKYKieHKXiowvNe1DZPkLJaID5qcpyscROKH?=
 =?us-ascii?Q?vEyVIC89eXKyoGWPL3AqLktpv6/z5LiDSFAVpFSZ9+IcK/gPHYe0CclbFfnC?=
 =?us-ascii?Q?X/YmmhIx8nQY9UTCTFIbYgSFzKBKGSnBOxRnJn5Mf4JqTTND0Er5QxvQSetK?=
 =?us-ascii?Q?ZYjR8d7uCtX+Mu2ZiyY/HEzhmyFX8Yo4dmzBkdovCQ7MO0U2tIIA+UQ4KIsq?=
 =?us-ascii?Q?is4JiGEQnBFWoTHrhIfYLQcN182J5xQVf7/ldp/z4wjE0jiBhO0arLfsy8wH?=
 =?us-ascii?Q?tFZOk8/chI8t3po3L1flaiceiyFOzhKiMPLm8zedlM0BltlAihHWIVhQzU07?=
 =?us-ascii?Q?ML06jZzJfB/NEHb8ih52c/V/T1X8r+PgHL3QW+2bKaBcIeGiaVM0suzk20Q+?=
 =?us-ascii?Q?0dMCF8T8T7SbEyo+Q8HkvMWU8SSUprxYNlDyNN3239Cd0u5sfq1vxWe3Fm4i?=
 =?us-ascii?Q?YeA0EaZ7AAAXriPJGaCPyvDSik8ovJA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h34PZjAj7NgNNnDq37XXNq8vZ/tcz4Bdx7oW2q3LNoEl4WuogBbei6lPIlUgQARSVa0fzFptqzDGyg+/qDn0P8LOr0mYEowuYqyOxvuv4kjz5Rqaqcg6Y0EwllqHnboZocB/yyt2AirhL7PwppxQnrmO0Rak5aDHiHIQ1EELa0gvULR/6pLs2Nc3X5fhl4gSUMM82gUxnei2ZdlM2nrxcrFzFDaD2bxr4F3fnjwEBraLS3RCbciPosFx2g5vkvC7g29jX6auV/e9prDV9dHIFgs2Hv3q7ke9hprfS4uQ65UF3HG+dvAz06hw0lCMePKBwA/TGl8sYPPvggAlbPTZ5/FbCVc7a+chMZMaqur4+roLAOuekO1DqqbjQ7l0554pFb9qQc1oH7n7NCX80M9EpSZQYc3wz8TGGXF01FDRhnOxxj531O6thJYYAqOLAAaFlPpNP9embU5dTpOyNO7SBcDDir0VJSs76Ap4P4pDbwQbO+FzEJFLFMCktaZk5MLgBzJZgJIqiIgOvG89ghpl4TdgoPntzfHk5+qEBty9HH7yqpQBz6IFWV3CzIeVfXW4Cjbl55CfXT7rGIswhTwPh3fWD6zvnIswmHlH1O5pnN8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d061e415-1868-447e-8d58-08de49566ecf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jan 2026 16:54:30.9129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tF65HO2NVl7cFApF+k533m/xMVoQD2FqcgMjuo4uFwuO+vge/Z84iDoAwLFCWt6wPvlXnh3IPhRrl4ScdeRfEvkv+iIOOFQ7sV0ZPGeVV5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-01_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601010152
X-Authority-Analysis: v=2.4 cv=LL1rgZW9 c=1 sm=1 tr=0 ts=6956a6ca cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=wWMYGxA4pXnAUEYSkwkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: eDdfvKFo0SrXK_v7_Bk9coLSL7IAuzaO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAxMDE1MiBTYWx0ZWRfX6NkdGZ+bMCzy
 2mnAlEbCfCGyzMXvnXE+OwTdNlLVwz4XW+LOVLwlRra2O8WnHqovV51/1stf51ss4rXXvUDh4mn
 dZdy0gAb+EdYDZU3Vh4pY+A9vW7tHCtAGd0v78aOGEKAv+5LjtHIjDZ4e5B7RTW/st9ceFF5hnM
 U8Up4DY0OfWzhi03EYXPDIFcHX0yZUBHsDSOdietJLlT2mhIrkYvGo0b6wjpyonxKBGEiF44XP+
 /iPdvlSBcDaq2NY5sKySq6YUCL+Ad/mC6zcig+/9Z3IeKXwQDDWPG29pvyv858dFPoP9uHs8/9W
 AlCI10vL5TCbX6MzEVhKmAUiBMswiV+TcrRDIzjlrYEj1byEO1kzFDpkSGPTLueai8I4idirHyM
 t9XP0Q/T8KauW6uk8yYqoe+0MK61y+HVv5FBidNHiKFCqz94jtnN19tPv1n6hXF6syllY/Y95TW
 pY4xUqRwDYynHmMTMdA==
X-Proofpoint-GUID: eDdfvKFo0SrXK_v7_Bk9coLSL7IAuzaO
X-Rspamd-Queue-Id: D6CD814000E
X-Rspamd-Server: rspam03
X-Stat-Signature: zhddd45i9fnztxzuc641cbsurz457htp
X-Rspam-User: 
X-HE-Tag: 1767286480-690396
X-HE-Meta: U2FsdGVkX1+C5vpbfV55caeCKyNegI+XdKdnr3UGT7JBuEAM6PCNqxakb6eeMV3dz3LkQx7v5GDHm43Jh5noi2mH30s2S+I4P0Gxid0T2XQz3UE1O5BAQ5AiUQj0SLCxofX5LWXaSzLaSCxLlMylOStzVBXIHrOOv1OXm9qAyk4taNZC+ysZ+eAqI/LsCHeb4eZfGSaRohLXqEI+HvB8gzCg/nJAALPMdb56O0skp9H/ukYuaVOji7fVIF3S98vP5BBdGdFFnYyT9HR7QFhvTf17cXyryjz5klW7+vAOx/Ty7AXSXgBSlgAqeVk+H/wxBRsq3RrXA9gnHRdGzPptRh6OpcahRizU35CCqCPRsO7wEnsdcC7713IwwhFY1OGhiLqB/NvfjoIKH71PIr86ev5G0KNlWdyMmMuF47QKrqcIEANb8/I0vXJebAzP+L49DIq/cMYGAuFX9DG8EJH+yOxYLzwQuBEkSJpgwOwidz2ULdQd73+IIPuPpgkgSzLtmDm37sMOOQDV1PoUZIhyFqgfROe7XVwpUxNzxTjoz0CJF8h4W1Z9GJEMsH8raKqo6vS5r9OLo9/88XujBHSQDYkhECr9XBfJY/r7EG3ULXObE/EnsVm3Y+LR28hga43ud0SLTwvZxWJgyI+PuwTcy9kJgM0urkeok0Xx0ao7But0YECOCIS9gLYKFxrqwrsJ4+GZvuwVayK8Ha1UWV/5n4Wn35yzdMj99/s2m5FpSUucZsxdLj5x5l9pr5oft5Jb3itvDpfiyb+k+T4LUiKiR8K83OHw4MqlFjbnwAqSiS3y96WnrhDlGVpTCDEfPgpOAIMljqfkvLdU2PQc76vh7lSjSH37iNXkXe/zsoVFULELWiv97q/Bkqv3AJy6aEGjKMllSYY1uSNEfzA2DUVl7cylJM8gPXpaZehmSE0ypQO4JxG2VvfqnNA1tLj4uMEJOMgHvcFvj8v9uPMaAm1
 0Rx/LuLr
 mTwkLBaqjpZTU9sB+OamEmM6HA3n3pqMB27RTmDSK/wSHK3YYSlYWlNMjkaQcc6/vNQ9K4ifQE9+bpSug0sJ6KionQZyWonMee35s6IrBfzQKq3VHuizBe3nwa3K5FnZGfo7kDKrBZCVeHRMolf7UPCqa0CGnYWnMoQt2M4Sw2zNQtVfmc8SsR2UXIOGZ+oMMOU0lJrjWdAzhoe+d5SvDTtIgHFns9TD1XQ4EThgCRcuAPfqxfXBl0yK+cantCpIZpwNqGI7sitLSvhhyPjqYlccf/K+hS7o8N0IvGQ4iNkx9ivZJjXeFtVjj7BbjQkI/tyFFAQ5MHqzqzBYmY2RGyMBIBDrFfEy/J0vXlYY0c0voGmTGbLMU7PUXmCRrmM15H9QIwBtdNuqSccjSqudNiLBpMD7d2XlbvZTjAAD/Ootn+ZVUgKOTWGrAi0SYItN2Tfxm8XWdLkAr1SWDoLJT7v/cMjUfBtROgW+uBdeoZd0MzQzoshbZlMqxm9WR4My9AEwEhkS2jBa+cpIW9tVGJ8hKSoGER2qT0BO390AKPB87HHVdzlsSSRjubXv1KtpsWYONlyvpjrMAuF1c55JICmvjXkMsYDDS3QcUrO6vhGoRiWSD/MViOGLrmExtZB/tzror95HN8D6kn12jx55ZaShN1f4LoHCa1eacKUGntjxH0dmBgMJHg4hfao74GvUUH8XMnH3bIC/Ntnft5LSWKD+U0YKbaSrc69oyNjpBxanMg90VZyZ/2aiLKCNimOyMn1uHBbkSOtB/iaI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 01, 2026 at 10:09:06PM +0900, Jeongjun Park wrote:
> Harry Yoo wrote:
> > On Tue, Dec 30, 2025 at 11:02:18PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 12/24/25 06:35, Harry Yoo wrote:
> > > > On Mon, Dec 22, 2025 at 09:23:17PM -0800, syzbot wrote:
> > > > Perhaps we want yet another DEBUG_VM feature to record when it's been
> > > > dropped to zero and report it in the sanity check, or... imagine harder
> > > > how a file VMA that has anon_vma involving CoW / GUP / migration /
> > > > reclamation could somehow drop the refcount to zero?
> > > >
> > > > Sounds fun ;)
> > > >
> > >
> > > Can we bisect the issue given that we have a reproducer?
> >
> > Unfortunately I could not reproduce the issue with the C reproducer,
> > even with the provided kernel config. Maybe it's a race condition and
> > I didn't wait long enough...
> >
> > > This only popped up just now, so I would assume it's actually something that
> > > went into this release that makes it trigger.
> >
> > I was assuming the bug has been there even before the addition of
> > VM_WARN_ON_ONCE(), as the commit a222439e1e27 ("mm/rmap: add anon_vma
> > lifetime debug check") says:
> > > There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> > > walks that seems to indicate that there can be pages with elevated
> > > mapcount whose anon_vma has already been freed, but I think we never
> > > figured out what the cause is; and syzkaller only hit these UAFs when
> > > memory pressure randomly caused reclaim to rmap-walk the affected pages,
> > > so it of course didn't manage to create a reproducer.
> > >
> > > Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous folios
> > > to hopefully catch such issues more reliably.
> >
>
> I tested this myself and found that the bug is caused by commit
> d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs").
>
> This commit doesn't mention anything about MREMAP_DONTUNMAP. Is it really
> acceptable for MREMAP_DONTUNMAP, which maintains old_address and aliases
> new_address, to use move-only fastpath?

It's not a fast path, it permits multiple VMAs to be moved at once for
convenience (most importantly - to avoid users _having to know_ how the kernel
is going to handle VMA merging esp. in the light of confusing rules around
merging of VMAs that map anonymous memory).

When MREMAP_DONTUMAP is used, it doesn't leave the mapping as-is, it moves all
the page tables, it just leaves the existing VMA where it is.

There should be no problem with doing this. Obviously the fact there's a bug
suggests there _is_ a problem obviously.

This should be no different from individually mremap()'ing each of the VMAs
separately.

>
> If MREMAP_DONTUNMAP can also use fastpath, I think a sophisticated
> refactoring of remap_move is needed to manage anon_vma/rmap lifetimes.

Why exactly?

In dontunmap_complete() we unlink all attached anon_vma's explicitly, assuming
we haven't just merged with the VMA we just moved.

We don't have to do so for file-backed VMAs nor should there be any lifetime
issues because the VMA will fault in from the file on access.


> Otherwise, adding simple flag check logic to vrm_move_only() is likely
> necessary.

I'd say let's figure out the bug and see if there's any necessity for this.

So far I haven't been able to reproduce it locally... :) and it seems you could
only reproduce it once so far?

That makes this something of a pain, seems like a race, the fact the repro uses
BPF is also... not great for nailing this down :)

But I am looking into it.

One possibility is it's relying on a just-so arrangement of VMA's that trigger
some horrible merge corner case, this bit of code:

	/*
	 * anon_vma links of the old vma is no longer needed after its page
	 * table has been moved.
	 */
	if (new_vma != vrm->vma && start == old_start && end == old_end)
		unlink_anon_vmas(vrm->vma);

Makes me wonder if a merge that happens to occur here triggers the
!unlink_anon_vmas() case... but then this really shouldn't be any different from
running mremap() repeatedly for each individual VMA.

>
> What are your thoughts?

As Ash from Alien said - I am collating :)

Happy new year to all... :) Am officially on holiday until Monday but will try
to look into this at least for today/tomorrow.

>
> > --
> > Cheers,
> > Harry / Hyeonggon
>
> Regards,
> Jeongjun Park
>

Cheers, Lorenzo

