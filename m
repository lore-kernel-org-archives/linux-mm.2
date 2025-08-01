Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4C0C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 05:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2CA96B00BE; Fri,  1 Aug 2025 01:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B011E6B00BF; Fri,  1 Aug 2025 01:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8B26B00C0; Fri,  1 Aug 2025 01:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 862756B00BE
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 01:14:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E11C81582
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:14:29 +0000 (UTC)
X-FDA: 83727023058.15.F335BB4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id B043740007
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:14:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n3BoVRRP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pOR4czcu;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754025266; a=rsa-sha256;
	cv=pass;
	b=w6ysQBUuq8/FAjGhGZxExx/Dg+IdCepT+ifRexGPblu+y7d4nVas5+lFvI+KIfVgwmC/fM
	yH0auk3bE6ymrQWu78bxScdLfO/85TGt16ccZvf8+a2iC7JVy+9XrWvALURtSEL53eWjqX
	KRd+AJxVp5mAqKaWzBLquM1EzjHwW3A=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=n3BoVRRP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pOR4czcu;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754025266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YP7nchpnT/lOPfEDpvDQ6SIbi+EIrgjj5nLTnbiqeF4=;
	b=sZHfwe4M35DwDmaAxfP/f5zBtjuJ4dyxcBtDy15oBwN0keA6AVa9/CzUhtD+V+7+OlA9LM
	OJxf6cV8d72wS6FccfMEC9EuYklO91Q/BMjo4z1+519fJqRsgwfWwZh0K5BmI73sprtT9G
	rTY/+U6nYNuGj/LoMo7b+UcXjs8rCAw=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5714u6eU014669;
	Fri, 1 Aug 2025 05:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YP7nchpnT/lOPfEDpv
	DQ6SIbi+EIrgjj5nLTnbiqeF4=; b=n3BoVRRPdS9F8MfqDUe+o2RQpMKiYVF0Nt
	dDWZkYen8ec67EAHOjwaA0VpkWvppbgV57fHoNoBbhsmo9PKrlOrjian3DW62P7j
	rLlu+EGnIzCHxacuObOkrSOdziyIEmhiAiX6FsGZAkzpomXbfMGiDRJZlJSpFfMy
	lmr0mjFYJwfTP/BD1vZx0YTaLAuCNhdkkNRJjFiLJMxeoDaDa6T/3fgjWvrBnXza
	LtwAawDeMnpGi8rlKxGcDJVPWxebF+EaiCFWk7Jtll/Xerkxl+ycF/CXUlf/LBAC
	H6LN59JB5HDXGFh15OxSHZC38gC46DRc+aJQcHISyaJBzj6fbHug==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484qjwwh2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 05:14:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5713VVsC016740;
	Fri, 1 Aug 2025 05:14:21 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2066.outbound.protection.outlook.com [40.107.100.66])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfknyxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 05:14:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NvzPLykK3ySQAaS6RtamSkuqZ8QcIXBxBv747ZP5earTnXGrHT+3fclPmEqBlo24tsu44PIfNetuXdrJAYL+JcXfpqzwNwmjr/vTMSsdw91g9b45UEUY3PkHqmjX3ZLCD/S3k0Jj9C7FjrUBhFkM8EAv4lePc94pJ5phOplp5ClwSH0IDaNmzZqm6KWRGwo/+3hWOhjG1r0xefBo7auyj8hMh+swSuf5Uol/spNjR2P1X5WGKCelaJE8DBqdGZFfCbEd40VMd7MA9678j6mJ4+yAjNrK1NHnMC0b20VGcCYUndGO4FRePj1Iu5WANKquQwuuiToRUe6WdoaQlEh2PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YP7nchpnT/lOPfEDpvDQ6SIbi+EIrgjj5nLTnbiqeF4=;
 b=nR4pflRoBVw7DMitN69u5mUgfK6RXRbx3qYNqBlemYpTubuB88KfTX7Rtejg6J4HrSlngZGkf+alQJ2HaDTDNkd0OYmF17anYs4Nh+8MkJB1yWCGaYSDDOIug04+WE0PUvJ4RO5KlpYbtFy+/68hVW2ROChuOu2aldpcPSugFBH++FklZ7f+mr0TRYfj7iiKLsOGfnszi+hCFiticxZXaW1oLD3fi1dPLOU5WUcIOZ+eDMdlQhRNSXtNPKCYm5Hu0p/2JHNUZiqy/HWi81pP7zr+GFdiDj0uRvK7e3REdHlsngOCDEkU06VHVbjH47Kw2/tE0wkP+7thbvyLRG7fVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YP7nchpnT/lOPfEDpvDQ6SIbi+EIrgjj5nLTnbiqeF4=;
 b=pOR4czcuLxQSJqeUOTJ44vEu9tvrIGCobIKu/YM9qokwbra2qHq3wfbMbiCJcUY81oNELxBlXHnbmS3D4Xn6iGfA9wUIoQm55py+ZVT2fMLnkhfWGar42pBPAYdzTP2CDDYFJByKUIRa0UP5PM0pNH0I2TSLc/PQdCnlo7uqKfU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB6496.namprd10.prod.outlook.com (2603:10b6:806:2b2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.12; Fri, 1 Aug
 2025 05:14:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.013; Fri, 1 Aug 2025
 05:14:18 +0000
Date: Fri, 1 Aug 2025 06:14:12 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: WangYuli <wangyuli@uniontech.com>, akpm@linux-foundation.org,
        Liam.Howlett@oracle.com, jannh@google.com, pfalcato@suse.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        niecheng1@uniontech.com, guanwentao@uniontech.com,
        Jun Zhan <zhanjun@uniontech.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tools/testing/vma: Fix function parameter declarations
 for GCC 8.3 compatibility
Message-ID: <12cba6b8-6853-477d-aa6d-23180c2fec75@lucifer.local>
References: <EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com>
 <e7554f93-03e8-4315-acb7-a55312354485@lucifer.local>
 <CB890ABC56C2FA67+56b95783-ed70-4744-9fc5-f2d93ddf2c12@uniontech.com>
 <37b606a7-17c6-4865-a78a-ddde1bc15649@lucifer.local>
 <d31803bb-fb32-4a94-aa89-83b02757d650@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d31803bb-fb32-4a94-aa89-83b02757d650@suse.cz>
X-ClientProxiedBy: MM0P280CA0001.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: 1daa981f-656a-46a4-2dee-08ddd0ba4467
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6Aj6BIUKTy9O1WbP/ho2ITmbgXTudfUQawqvQS6vCKqLuq/XQQMIFKh/RLSb?=
 =?us-ascii?Q?ePl9DtIhob6UZyFHj9T9N9sJDqK5m0TWKToufKJiaH6b7jsWZ+VNudGtjEif?=
 =?us-ascii?Q?qDNsniQaOjeIdO3pOJmkNc8CfxkeDHYRwa58qKEpv3qt6sdKefAQllf22W/F?=
 =?us-ascii?Q?mnHkhF3M/v2NAAEx/TGo1as0/jtJX+R/DbUran6QYoH/RLHRTv9PeWGExEms?=
 =?us-ascii?Q?CAnAJWfQSpZG7KUppYuSUXUr+tmzER/DBgw2REUoyNIIFFKLA40dz20cXOFW?=
 =?us-ascii?Q?zZwx3ZTUbTTEyJlTLqk3I/rx6XIrP6KalLjSvAn9eLjCDiw1R6BH2Orp2QXm?=
 =?us-ascii?Q?Ds7O6lLLLBxsEgNnWkzks/Ytn8ME+m/RTFZVeYFv/iVuqAoL+Zv0/TPdttHM?=
 =?us-ascii?Q?QHv7lHHHzCtFO7Orxs7H77soJhhe38PujehIXLjInsuIHKMLe8K1CKxbUIOz?=
 =?us-ascii?Q?zJzOhGkBsAXmTRaJjUJepsqPDp/KpYocARg+Ty4Sudw6HUoatTVvARRUCPGn?=
 =?us-ascii?Q?wx7phHLlfUUiTDCutcZHGwk08ENS/HgqDKm8W8mrHuUY+/gY+QfYr9R605mi?=
 =?us-ascii?Q?OghWaw5QeztoVBsz4hmjRSY68zFtWRtET+g+ogFsKl2rrRVjhVru6Bk4j+1z?=
 =?us-ascii?Q?KiaJsRGCiN06cqbclrtr46EW4RBQrLDgrsdvL7Kch4qDwIqYEXoCgd/42w31?=
 =?us-ascii?Q?b05VFjjnyYp6rtzNlJEkE0isX0GMVW6QhYmblaNbq6+xee30XmlaEviEXU95?=
 =?us-ascii?Q?FuqLnfjk7JhKIdvNt83W2Qm2BraXD896kGMM8zciONQeuWwprVJ0Wk7piJvH?=
 =?us-ascii?Q?aGXQAb58F7N2eCubVVzEgtV31YyKHkHefyT3PN+/tL9h58fckKQJW3iSK0+k?=
 =?us-ascii?Q?i6isySo4G1+MWCHqm1WZ3xtH6urMgwICegpS0o9MUbJ7ypC/k2Z994LICKvA?=
 =?us-ascii?Q?ZuSwksoptRFv6AdYPiN6eJGEU10JETwMpGRCQXvWJSuZGdhPZoXL/Ugc+9hw?=
 =?us-ascii?Q?E9LrUBF3rhAwgmg3r+SZWphRNKfB0wRDHiY6wv9TFj5kXXxwFuE81+DEInl3?=
 =?us-ascii?Q?Zpwx9Hj9zSx/pPGLZ/OQb9pzq1m5ijRIiZIul1N4v9qrcX4Dui1be8Ez2AcN?=
 =?us-ascii?Q?ExyXbgjjJarsylD1fGCZdGlRpoWgJ1By8YW1VG4uLaabDHLHQIMaelk4971f?=
 =?us-ascii?Q?yRWGlGYrcThRxGlkai42ZLzFPMg+O8z+4DhzOpHDooc4RK0HsSWyQR1arOmF?=
 =?us-ascii?Q?jWQypD8WIvTYJzvbuWCJFsEiGk6ht23AuPNott71PJ7ag6Ewc5K+6uoT2Rbq?=
 =?us-ascii?Q?EKp1g4U3OHtZCeStfgik80nMtL+0t6PStspwvBSwcacMGTQI9ofuMK0SeDGO?=
 =?us-ascii?Q?vNcsZfNHIrheDQasnwo4wbRz/MM59RJqRStkXBLHSO/UyJuyEK1cxfw7W2up?=
 =?us-ascii?Q?wQ1QPfeI5Wc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wb3DM16aG65Bwhj4OK1AL3tpHz7C1QWxgtWYOpaIVJQkIZa0Y54wMCF951RH?=
 =?us-ascii?Q?EIJNo+N6XJNsCvzpXaVxzr1vK9q76l9COHwihEjOkPXdLt62D89a1QrRG4lW?=
 =?us-ascii?Q?7pRB1bbHmQKVwy9HHaj7Ts+y43QDnnfXGb5v432eOQv7NomT5WJq1VIH0e7K?=
 =?us-ascii?Q?ihHjE6OwL69hlOdry6pyOEtDzF2x21vEqwh1lTunkJIjibJnFrL+X8LyTRO9?=
 =?us-ascii?Q?IJuY2qTtEEYVyzPaJintItfBGsNdul+u/2LKWXG6XdE0vear3fBvA6xSvE7x?=
 =?us-ascii?Q?0kv2Vi7S+tkOm9NhtgXzYMM091z0MO6yZtxxoogq7Za7hjo93sUGYUnS2Tua?=
 =?us-ascii?Q?VQ2WThjdtCFKgIcTLrhwMzIQkjb4T6s4KO0qycudbBPS1zK7bLu3Q2nsD/oG?=
 =?us-ascii?Q?QslGUK4JclYvaegxN2sURyxHoucPUq+PBIDdwU49UlYekxJQHD0IQmBIo9mH?=
 =?us-ascii?Q?QMz8O3tIuKfH/74DDUNVqvzYhkfpH25/9kIiNsdMKnhEH+mG422a2MPUmikQ?=
 =?us-ascii?Q?htEox8ixRyZUS7JuSli8kIA3yBzphkrASgkRO/iY0LjXLlVwpvKk6eb6170u?=
 =?us-ascii?Q?6fAlewGd5UmZnwtqmm0T8izfQeU79YkS4TA2RnugtpX1QXbM3eypW2Q0D+pU?=
 =?us-ascii?Q?+uDlvZVinrLlVlQJVXIpF5TgvODfQVTngoXQfDO5hxsl/GnWpnmoo9LdFNc5?=
 =?us-ascii?Q?yD2NHNFy8DsqYnX9+GtuzKlM1ls1LCoigwTQZ9QBvnt9oio9q0wkLPOnfKx7?=
 =?us-ascii?Q?qbJfOULIXBUHHYNVpJqa6om/L/cbM1aT6YsMqbYAbJEyEQJ2Um+wxpCLNnTL?=
 =?us-ascii?Q?dK3FT2FqVxqdS5KqtUc6Sq9jpyoqDYZ3Bg7wjfUSfipidaUAaNO78o2ulhYK?=
 =?us-ascii?Q?QAzQvtuIhsk/GhqXIcRf2FM+2xcjg1KTfCsjfTzWBQvusl+azfItydSk82OV?=
 =?us-ascii?Q?1OFJq3t4/iVcYAz1KQf03QHwmOTMvAw/Bguv8u11ftx/BRJNpn5c5FGHDR9C?=
 =?us-ascii?Q?7DR78SLjRgHyos+Ummz4W0zvtqHuVOy2YknaJYAU4xSOuS3pwgAa3BGuXjsE?=
 =?us-ascii?Q?Mcdh0PO/CwdImqtTL5i2jslL+y3orLKc2KesLkPzi+8xg9pwLH3grf5UAm0J?=
 =?us-ascii?Q?i7z0/e5cIulg2m47KZ6gBmRk4f5eIfIUVFszqgCj5aMOCcb4DgeU7Pq2M0KI?=
 =?us-ascii?Q?Bg70hqjosWHJrjLDLllp1iq3yFxNnrFr3wJ/r0aU+97SxPJPvQ7cPNHBDvCW?=
 =?us-ascii?Q?lMTyZGguP+V2WEId05nSw88N5ySmfjYCS+/Iix750K1Y/d7Q2l0TdjAE/NUo?=
 =?us-ascii?Q?B8dTmW4yMgoR9p6cpQ6ehuskY3Ysa8BSVoeBaw1NBrpF+d7geHozn25cyQuM?=
 =?us-ascii?Q?Xgg81jejPL55KY+6igJgQXa8np4f+weEtrQ7KP/fWj61DgdsYcPCygtwvEIb?=
 =?us-ascii?Q?q598mddJ75Qqil4Rptcr+IPKs4Wx7Q4Bou2ttJVaSJOVActjiSjZTnEl/hds?=
 =?us-ascii?Q?15Luqb7JthpplRmqF1EDazWXfV4pPtl99O0olngIlK2H22G73XNIqxEUjuAo?=
 =?us-ascii?Q?/hxRGm+Q1om362OQUSEQwVEdExJMEmk1MM5a2ln0crqUqvGZY4JUhGe15w3K?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MzDCxjUFdlyIez6BlnJgjxia8QXBY21UNPei9x538bpivKyVaPdRIUeHXaAww34vFnZG1r7iDozN6yDd13NyiYmUEGN/vo41ScW68VOoaYvAkduAGOhqlMNm0C9h9C5kAZ2AySUEN3QOk3kM1FWoaCPIoQDYinZsC8ARSjruOAFzpt0eDoILamgMGzacqVraQU1JMDLdCY+5kCpVyWFfjdYpHqaHPEFBJ5A1GoH/72gGiG+gPIr6va1IkPvVuStw7TpfhIdmvsGiUStpq3wVHZzNDxXvGw4Kbh4njeWulsIlduwfUsW9LAK1G7zuOlpagd67zfXaIH4YxhViR+5mUv/91tlz/w9QzgzEgCs3huG8BY9ihVuDtzgA3rQXlOTb6yq8a8Z1+4Zz+fjAUXDM7o7yIDhrwZcmU/z3khC0mpIA67GPXgKXrgdoK9CObjBAP9X5sig0sy/Gc3GGzJdvDelE6W5DM4YunRM0irmUPiF0grX45MQnhoELmYjOVHfcsO5TQ7REvd/t20uXRgN4S3KuIWSDglgqmNBNfWGa1xaOXtpSHrMqaUXc3uUUOQzghQ+AKNUhxjoefux54LyABXiB2TWJPuaRda+ePjKguZ4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1daa981f-656a-46a4-2dee-08ddd0ba4467
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 05:14:18.7291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YxnawZ5JiyXI+RvPljZIWm97SJKvhzeq0Ee3khsLbr/cibax17rM1y1vmZXLdFreLcHD8jYISMoXdNbeIWw4kalTyEUPB26pQEkC2nEmNyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6496
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_01,2025-07-31_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508010033
X-Authority-Analysis: v=2.4 cv=OvdPyz/t c=1 sm=1 tr=0 ts=688c4d2e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=vO4P1MGHhjqKaWfj4fIA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12070
X-Proofpoint-GUID: M3VOuYkvP2uNxKaKfviPbQlOpf-AGu4f
X-Proofpoint-ORIG-GUID: M3VOuYkvP2uNxKaKfviPbQlOpf-AGu4f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAxMDAzMiBTYWx0ZWRfX5ARpegV1CQ79
 xEOVcW76JJNJrOT5Ki9wZOEv2TKrKUwwLPYfP4NAhelFcqa89vOeNucsfKRTdqqZm+hPMX7aFSY
 kEZK0DEXpHNHzpRK8gdc4bxyxtRTVhUX8hjfT+OhY8Y+ix5xlmx3V/dzdYfnXXXWqO3j3uTIj+j
 vlxU+phwmLX0xcO72wctyMdkH9nociL2qBksdo64ZxbMw/uui9fECx18jswRYqbd6eNSdB15GEa
 k64jm7cgR8h8F63TbgRtXMkgCX69lEEtucsi2ewCvqA5Zzrn+DLCMdFMrhn8f1UDWn126/PLXPx
 qafQ+3SjpvOXCpbt97+FIQHFCUi2qMAP2n0ux/h7mwwWpMy5xJ4ncOrsGALUMgs/X3ILeTxGTVM
 8CBOqr5Z+G7Wxbub9GHu77e77+k1WbWOOAX2pvpjXkW/noaVpC2zdLOGWCgoHva7pOW0m31J
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B043740007
X-Stat-Signature: 8e5ix8dmhof3tj99iek9t3byibnb5msi
X-HE-Tag: 1754025265-507750
X-HE-Meta: U2FsdGVkX1+2Smj47E7xSwpa79+vvRv0K6HszShZtq4K8dm1ABCrIHdm4BKT6H2g1C0KjA2guwuWaxduF1yl3EGabSbhBThm87wOyTMbUNV7Ew5+xQQSdkkkv1zQ1Fe2igYqxcOK2ljPe6B++5oFdi+y6NkPZAPCAv5HtauY21XsO4ejesAnclriyS59U5U8odAFr2CznuShLsjuI+v4D4yMuREUklT/JJH10aYzSyu6+1p2lN0uAj8ZKlIfhbeZFBEAIMTKsZNhPNGTjPAaXEuF2IqIzQJO90KgBcTnNFamRsue/GeaVorl4KrUwVH3kw0gsCfEqpWclUaLIFDFOsPEmVqszvb/WECm/w3DBnIj5yYFxClF4TAjInFF78nYnY7YEKVu/0DaeERpAk5GXVOXPO/DAe2udNurEJYNdal9e6mTOugJkK7uNeGeLM1DS9eGQGoYur6ULNMlOC2NeXm+a0/BlaNYhCphFUhfAOyZarHiKJauBdV0j1G8DsreI5lJE1XKwvDXYIj5T3MhzTt5+5VvPunaemi2Rz3idjkgUkSg6LnoesU7fP0LdxK/tgwcSHTRh/U+TAlHjFDzzvweuxhszafy0BBCVhjjsCHqTRVnKBpdet9wov7mUOthr7fi2G5QZER1+38LCxQCGnUTLe1cIt8IapvT8CtZwzRDydHHhvv3+b303buxWa71QMk0rSiOCDar9OkFZrnz3Mf80iKsIPdX9nehpU0XSfxreMmOAkTnZ7vjIj0RolKbfc1EpsOiCLXNqkOD9aWK5nXO/2uPW9NRHMSOVtWeGXHF54Yt8+g4tKV6TJX01A3vAihV4D79KiPdAy4WPDlO840wH+wpjlvgPGYOZoDby4A0WiJlen1rNjQSu7olxP+Zs4lK3Vayb11mSDSVr56vcp2UreedXONSmRRYrEs44hpiVW3aM4NVs5psGWygZwMYIH6Vp+tYRVMiYjp3RRK
 0gK7BrVE
 +A+JxcaUtSJnIC/Dw0Y1e7DUtZXq9x0qFMJcGzQmHryJDfdWSxbAjjSwmUNXiBvBBBIQNqNgv/ItsTbIS4g4mFN9LinW/V8zFaMLEPDR+/q8M+kwU3ughWJqFiAUqEsZsXiY9ILtvBFcXlVk7QJB8O2snrhf50oksm1KLH1oAbziSg5Rik1b5CTyKcWPTSg+x8Gi0rpgq7CRiMeKllhtYPyqBLEByA8ESfNr/ldRl5C89SfvBXH4RXENO0ZYWUEtBaPR7L5yT0tauWyoaA+70vdC9oiWaTCYXFxc9fGi6lKas7WbEUjY44AzuSqtukqWoItY/nOUjtLZy4G4gpG79urXgEzosBFEOzGcF+Jlr93PB2dapiLSwfxscApCA50tHDX8Ja5XLDFMlBABhFZcuI2v9MeFSylKmb0Bjy5pyz8mCm9ITeO3tLHzhEsQhy/aQ4oGk56d8OBpuKA0bKqW1BJy79hjUsmby1jCV9kB5oowpvWGsI5pTFdac1QyYmjt6DRdUrD9VmASnoz9zQvUOOqWamkFVZlkBD0UJI+8WjFbIrdSI0sWOkbjtxdkvOQbWaKfnDR+Kr9AjR8oh48rLleODYrnwOVuHynty6YfvqgGVbWc57UlcXuT3b/PyqH6q4WMHLdgndTr/WpTYWAcbOrfIrxu8p566NgtYKHMS4JbJQXVI9XZZy7Kqd1vjTFOIKTXubz1booybiUFfAl4cxoF0zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 08:13:55PM +0200, Vlastimil Babka wrote:
> >> By the way, this coding style has been a GNU C extension until the ISO C23
> >> standard. So, until the kernel's C language standard is upgraded to C23
> >> (which seems unlikely to happen anytime soon, perhaps years down the line),
> >> it actually makes sense to modify this style for a practical purpose...
> >
> > Kernel always uses the GNU C standard by convention, so we should be good,
> > but indeed I think this is the case!
>
> I think it's not "by convention" but quite explicitly by:
>
> Makefile:KBUILD_CFLAGS += -std=gnu11

I meant the kernel convention is to set a flag like this, obviously...!

>
> I think this is not automatically used by tools/ build?

Right.

>
> If you git grep gnu11, you'll find various Makefile's under tools/ adding
> that to CFLAGS. Maybe we can simply do that also with
> tools/testing/shared/shared.mk
> that's included for the vma tests.
>
> I don't have this gcc version so can't try myself if it helps.

WangYuli - could you check? If it's as simple as this, feel free to send a patch
making this change.

Thanks, Lorenzo

