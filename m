Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5095BFED2C7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFA4E6B008C; Thu, 12 Mar 2026 00:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95646B0092; Thu, 12 Mar 2026 00:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B7A6B0093; Thu, 12 Mar 2026 00:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 80BF86B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:36:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4CFE51B896A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:36:32 +0000 (UTC)
X-FDA: 84536149824.08.D2001F0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id B93F3140007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:36:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hhqmo9OR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aRW7lP8q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773290189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTcxOWS040NL6Pr2axaLFilKQtNKE+3FXI15OKYPy/Q=;
	b=H8ifoJbbbEM1nnraNXqlEsCIYksyosm7Yhiz/yMKtPqxrUcsbN6ZAi5/PDPeAhZeiklU0F
	Tx678FUANnUcK3o+VnygEC9KzfDq8hHxy5Uh0oAYuBQ62nYH/11Deo+z/ZW2pZGeB8IfFK
	td+6aCybt7Lh+CGYGrV0RND+lHu2/yA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773290189; a=rsa-sha256;
	cv=pass;
	b=KrHXtbNR8HWmc7urgGVR/vx6FOAk1whA2kEV5Ysv2xD1gjrncDQnR3UNW3T6BRTSt0gwaZ
	lkNGeETSTcBKTP1XJkvwq6ZkrXlHOQyYQx8/bcXfj1Q/PdRJa2Uas7G4jHAOA02iYaKwKJ
	oII437K7f2d3gPIZ14ojA6WiWTn3JpI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hhqmo9OR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aRW7lP8q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BNdkYi3612005;
	Thu, 12 Mar 2026 04:36:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wTcxOWS040NL6Pr2ax
	aLFilKQtNKE+3FXI15OKYPy/Q=; b=hhqmo9ORek17DxOZ/icwDqEdCLUH2Fytbk
	25RIJPhy2oEJsoj+e2f1vAOTgRynR2KuIU+/VFWipZ11xY/biGonL/wivE1Jqezk
	9trOGByET9O0ICSeaA2NzBusvo4xlz7dZvvmsXWhC+nhQkvU5MRsGw8FKijL8qQD
	XN8cqzhn/QLbSmwTNs1jB7DF19bl9s+0fSA+ExOmkOTcFV13g/mzVvrktGtZoTiH
	BflkBUTj34zudi6hMKQ9Xty70WmcapK3oTBGhxAXajnyTh10ahOEh3p2ee3Atudq
	WzbpV30SB6TkbJuoq0veET2ktZJikXxQCEs9YBOYkTfx0jQbNteQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cuh4fg7ua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 04:36:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62C21EFJ023923;
	Thu, 12 Mar 2026 04:36:21 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012033.outbound.protection.outlook.com [40.107.200.33])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cuh5f85au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 04:36:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cHoVx4GORhUQdKiUyLBjErja0r1zYZhzR2F/wJunsTAG3OnWm+z9la2r8l+yxFhrBF2z2qWsYIQU8KVBAJdUK527/C9UryjvQXAvYDEij8UHmV6qDDuzSaTFU7+fD0Gxgm6kP6r1Yky0ymvYwrm4mlin4dRMYFfFxylUYxfY0W/C9KGL5BeW+XwO8bfkbei+tTNWCHfVyD6sKhwOzh3C50uoLqttcm3NOZHrfTMk51Pi3dT3DQbqMbiwgfwlYbZZ7LUM3g08422rveN6lj42M5ZeHTJ3yMb/MTAjkfIyBFF0eb+lQhT8U9FIuqykNVSXmdjtQIRRo8HPXYPHmQj9Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTcxOWS040NL6Pr2axaLFilKQtNKE+3FXI15OKYPy/Q=;
 b=yTpd1OhSqQulV0tawXErpOunzhXYCCcPLrK/G/2mRha1onnar4dx2D0A3W8/32FAFdZ4Q3t+TIXOkJO5zzhmuY+mLsEu/hA/SlXk+cTSqU6DPwtOnOHQfxPoEr6vkaftwK2aIj3NtbdhqiqcWFkSglrVLqyS3BJTTf2p2UMx2gFcs2zNylAMsYgNGlIBh+nrLihwnNn/9oP9E3J1rjkkliZ065EjuCrcbAv109WkMK6mDGsqNwzXLOEPmw7Nb+KvkHzIJhDKUNz9vcsSBP+6wvTlpG1uR02phBxjTG/vrn+laznd0Pm5yutiG0X1fojnKvbORWaXNIFJqBTBim2MMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTcxOWS040NL6Pr2axaLFilKQtNKE+3FXI15OKYPy/Q=;
 b=aRW7lP8qdDb9GApKdW2x90qL9D8cgtZ00xidCZUZDgicOK6WB5cdrFUR4M2yVnTzPWGFJ/Ogn9lNlb3hj+t44CiGE55JAp8v4FGVB13U2ZJJUHCW4527Ex8Z58NRMC3sYezCovzzuj62XbCezZUQn8BGmcup2XwlM+aH/j/JjX8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH4PR10MB8025.namprd10.prod.outlook.com (2603:10b6:610:247::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.14; Thu, 12 Mar
 2026 04:36:19 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 04:36:18 +0000
Date: Thu, 12 Mar 2026 13:36:11 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Qing Wang <wangqing7171@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: remove alloc_full_sheaf()
Message-ID: <abJCu71plqm4t0i_@hyeyoo>
References: <20260311-b4-slab-remove-alloc_full_sheaf-v1-1-c4c5bb587ae5@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-b4-slab-remove-alloc_full_sheaf-v1-1-c4c5bb587ae5@kernel.org>
X-ClientProxiedBy: SE2P216CA0123.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c9::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH4PR10MB8025:EE_
X-MS-Office365-Filtering-Correlation-Id: aca23796-cc6f-4dd5-96b3-08de7ff0e77a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	drc42AEVbjRDQmZjFwaA5Dv5cxHJlJBF4sTJ72Ox1BcQj2oLdIZoyBS8XMUjpikxcWZ8XhDgrKvdIRi5J3xtsNeL+0XN7oUELAh16W59mnLgDIZFEY5T3MjslgymAFtjyDsfO+b7OOWAe2R2mzESNDs1ad4IF1iaJCsIB47gFoAmV1+GgHV8f6djaO1Dyv1O4iAA5gNCWph73lf32uxbFGZrsKkazH1901AZeadAfwdTZq+1HNvx3dfUq+I0lCi5i4qd1sTCFjmlTI7LItnudOzfr5g6l71vuEA237oj+UUppmmEUvtIvGsXmJ9jEHGU9McVbvoXjxm0E8TphLjSMc/NvAesAyxvu9e1J404ZA+RZjKsljUHb/K/cBHplvUXiWnDXZXQglxsqkTPGba9vYUhEkuZPOuvPifkR5Xhg9XGNXsbHUPN0pFSH/asZqaMjuN16BoqvaxS5q2IYoL584qOD6uf+Hd531V8sTaK8wmufi36sRwZ86YCjYMOkc924mPW4Mg2qlrJVsPpkkwxLzS3aodqK694+RBP3iT3rZTwMrcmYQas7AoBTyuiLQYK2s8pFueBu3UtmsLTkvfo5iOc7Yh9deMOUhDOSANy3xKnhE4NVibwoEoo+S3jndMkVZDbRDOmKAtEB6fnjoDwOBXUja0tcGl2H2QyeTM2h3QwWbhrpobmrUFI+RtkzPd7B/a9W7NOxyGo0wpyUae3EtyNzf57l8UV4OoLjxZ1gxM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4f7EIkxziOatXUdsMiVqBy61G58/1VBDl+elxvYLWWPXYdM1bopcoKwxFtOG?=
 =?us-ascii?Q?Haau57ie/bPYGFoFhcWeT3Q0Uwoff5dTAJL3wzZ0lpKMH9A4qxcPQiJ5C+Vg?=
 =?us-ascii?Q?qnPgqjnF6+17xlX89RBpfJYBmvX384VFj6TcGAXtlChBSF7E+2E29Mv0FwWu?=
 =?us-ascii?Q?APiQpSZYwJW9gJunmjIpi59joZP14ErTahYpl1Wdne9cNa5YSubFClxgSHQe?=
 =?us-ascii?Q?RRpNmVRciAVrKteIfvpUhu3jR2lgJNaCIRjwYouRWQ6dnfbTMegJuQeZhpao?=
 =?us-ascii?Q?Phmt28Of5xr1q7N3Hgs8pmKoD2jSGNfcwal7KDM/ntWSM9Ae7DH3zo+qiDek?=
 =?us-ascii?Q?UnJZguU88ZtSWLeIqzcGfkI3nekGxdzTy/kXmOEY3WJEbr00H4BsLs62z6+K?=
 =?us-ascii?Q?6XhBntO3WnI4H3AmpjNrfu/DbwfZsBXAn0uwQyp5bRm1ab+1JTiq075FbY0T?=
 =?us-ascii?Q?gzgsRVfy/iWmfSel4+BBOwRL46YUGHgwpm1ZHZGf52tNQ2pDUEe4FbRItMXQ?=
 =?us-ascii?Q?4mHXSZVnAJ90ebNSbdSCwy6XNW00Pt3S0rRN5Dy7hCNsYGGsGL6avQxQh0v1?=
 =?us-ascii?Q?fRJDFFHwqqAsMOfVl/gE4w3Xyxz3+zpF2tycAI+Oqg5+ZC7E6UKhR+fGyPK1?=
 =?us-ascii?Q?pVr2Qm9LoIonbpElM9LsstALKNzXuiFpNuc4+DPhmwy25OHirixPSKmUmOpf?=
 =?us-ascii?Q?ZKeCkAGgE7c8hfaUb/wkSrynQkgMoWBAB90wkQpsUuRzuTXyzSDATo+l4HlT?=
 =?us-ascii?Q?GzjUKOk/ZgMf+l0XtZgTes4QzAxzkz5raX+fc4wrH2CcO135KBKtk+/+nqoh?=
 =?us-ascii?Q?WwNd9xE5aSl73OOCTl+vPPGagJb8cQ5akZmhYQttOwEb8FyCDxhgbW7DhdSD?=
 =?us-ascii?Q?o0n017CbdUcQRXJ2Y+/HJNudAwRrNXDlxMKrMkCTOiwTmagQlqkLF1cQXEAJ?=
 =?us-ascii?Q?ySUhhdGKrAZHEIr1BxCvT8MYh9lqC6RpFQj1n+4m68KYC6gezyF0YWmxRS8z?=
 =?us-ascii?Q?dSaIGoUaOqjyCHK7Qvphx24u5Kx+/YYCDP6A4U/XOO63vMTim5ECpHmZgznt?=
 =?us-ascii?Q?5zdP6Xhrsou3zXU9AZGql8zpl7m7JDIKkhjil/PD60csvlvRXiHbKJeQB0X8?=
 =?us-ascii?Q?lveLyTIuFxyz26ftHsyQxbAwjW0lmWIp0CdEfryTdyVzYsLZYckLWuSrFtCV?=
 =?us-ascii?Q?BIHhr7AsZQ1MjXIzy4Aq2E9mpn0GWsN8dA01UoSEPW35fh0RA7Bs/VaPOdFH?=
 =?us-ascii?Q?wdqHQtm3EQzukoH+vIHQdaQHvQCn5NCJq+kkqMSZgaD5nhiYuJtrXlJ6nR+F?=
 =?us-ascii?Q?ibI11tH3wapxTNGorqk8PVFptiYUnjeakzOzSs7DzF62YNuIXiEk9Zohe/b8?=
 =?us-ascii?Q?vGfhIhbaHRB8OLot+647pDmGCKk+ghU8U1BSU8Tmnd6+yVQ8dtP9s09JWrzA?=
 =?us-ascii?Q?aVP++oJDOl9TSa/xZvCPkvDdmxamp1FiDoLwYfADGdj8o3LxcFYVsryDnDe0?=
 =?us-ascii?Q?qdVX5lzstJWnezrN5B6wSh/h3kTIRh9nrsWgF/ZN3nTEEB1gvXEnoh9YsDCM?=
 =?us-ascii?Q?eFL0kp9DGoEYSay0c4zVa9vNF52+zrRI5iRUJ22zcJlXXB38tkm563in2mIp?=
 =?us-ascii?Q?nYQI1IUF+2hw9OPlPolxPf8YgUxuPE+Zb31GGlodNf+pOJS931TH5nvioGG0?=
 =?us-ascii?Q?YQ0GN0nfkDLF46sfKsWSx6Xn/bud7pZMJwNCI6Fsbw9dldTf7JrfVl+Hjivw?=
 =?us-ascii?Q?dqdEv8Xv+Q=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	EV8MBI8g+R9uxjWQNJnaiwQ6d9gwuUBkN3QXvElIrIERuJdGwGgFm8aOGpiUaLQq8CCqz53AUEArwTX0n+7CxfcImWu3xUQJPmY0DvNjYIuVpXpWUy35jFlLudW0pBNbePFkLuPBSlyYzzWKLdZfMdeSDA+5SxrR5Bdk0pCWCe74X9Ysk3Yfquz+WLZY3d2tYkpsWJefqV9scR5Ae+YUJ0MvGLzGxTqwE8xbki3rZxA2omQcwQmCcZq4aiqL3bTsrXw/AhM5kqnFFiULwcJYUOs7StRu1MJ+Cyzw6N0Aguc1aokhagNqIDjAl9QUFiBTRMKtAYyGI/0w1lekfC5i6w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Pw1/ofFy4tFYx+DllCCCstCVdFSJQLsgT+b4TvYQCbpgdAbPzm9Nmd4u6b0c9QLiev1VrkVLJw0frYh6kFE/X08e9iwka0G4N6DJZLv+OL01BQo7Fzd4yaX9aEBPXyWkvde6jk/X8mM5HgXz3F0LHC7Jq+rtfO2UF64jMxbFmy71tO+ngS2nIIOuDol0ykoRAcflGk/gXzYszVCXJ7e2LXQUhUrljkQip9R7AGs/D5wsSjBnGT4OvTOG0gu2raH+ZpkeJHK9T9gTgw5DTe6ariBBssEMWFZAhpbsF7LheUZAu7NLZBXCsqOj8+MG4P8CY9FMOVqlf3LimzfsbHgkqLONyIHKnUbo8tE9rxinYVhG4vjEt/Gm1aH9bTfqWOMgyG2dAc4Zx9loZGnltMtYO+FMxuIOyAX/cOBN+uO6BKkT1MoWLeHMq9KujJpGa0qQEQ7dnbJyfemLjvHqwvjbR+KZjW44owVKsbU2LHgnc9WDuVRLvHnLUpknhEKGXR4PWwn99Cby24OvrpNCYqYSUPIbVwLmJaYcpTiXWD1g2Tt4rbo1QDyktoXuj2iYxg+gp2MW11VIxT5WQmeXW7Y3FYzMQNTxXrPiQowJqES1/gc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca23796-cc6f-4dd5-96b3-08de7ff0e77a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 04:36:18.7839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ADl1q+UN+3uMi4azkpm5eEgu4iamedD4EW3eqhb4UEHQ14w61mpWH5say4N5gzNNgVZFENpwIWJHV7p6XxUug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8025
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=896
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603120033
X-Authority-Analysis: v=2.4 cv=c/qmgB9l c=1 sm=1 tr=0 ts=69b242c6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=bDLKYFvtXgqksSk7V2oA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: JSqyAZL6ZZjcMyMajE4ZmZ71hF1sSlmV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDAzMyBTYWx0ZWRfX5+QJznoQvKQm
 CMWxYc8XTMuZkqlsdfxUmia2vyk5mAGgqfIdOVJDAoGJmUbyvATENONd26C/CQ8TvNNn5QzWhsy
 OPLzDw1M7HwZr74BdOd5Julf/lU4TtxCkilgPXftEdnqmGsAhHeRduCaxDwJogKblgHzHY1Z3IN
 NWf6lXMj5aKxPgYRJu/PDNM636WtQiCNRe7WWDQQtIomCGckjf4H1JmjDYsA3sNOqcqfIi/EJZa
 siwdg9t+E1xHb1TNP1IDhoUmJQQKk7GQNutDE93AnkyKwuDZPLSm8as3ArTjVeZuHrcVab8BOqC
 rMQAbeX7tZAkiv43M7e4bAmDxiF3kaIPaB9usr/WnxD9e9GtuZstq7nqTURhM6lsjCIEO4EniRo
 EvCy7YDvBA/4i2nCDpRtRfcO5AHAe1/r35MfWZA7HJ3tJZe9w2Vlc6rtq9/3zkzXru5RlGQ4u3v
 0BQ7CvN7ZHpUWRooniQ==
X-Proofpoint-ORIG-GUID: JSqyAZL6ZZjcMyMajE4ZmZ71hF1sSlmV
X-Rspam-User: 
X-Stat-Signature: 4eo58nmtydgjdxduhso6x67zphox9th6
X-Rspamd-Queue-Id: B93F3140007
X-Rspamd-Server: rspam03
X-HE-Tag: 1773290188-712646
X-HE-Meta: U2FsdGVkX1/nCRtxXy1VXWRJuLBiZq0ueGJ2j5/UBYY9tdgagZi0W8LcUNWi3Z2FzUtIUxAdY5fIS1Wqps1W6Ak3OJ1nsVWgsx9pNJ2hCT+K2kGIBuqSzXyq2kQklejMMo1ocpK3yEbuyoo0MN0HkZ0MbYn54qKEa/w0MBHIzbXJdVSkh4z23SErqu4wzha7qmHhMppqF8Sy8/D9Y2xREHwZn54JZpm573dQe/aC/dgRyrXCoIHjXoTndmOaypkS+JBnI3S9wBOS+z62k2KyWabbtx1GCMM6wPBCiwBZgkWHcdYD6+AN6a4ckq63S5Tmw/XiCa3qh99Ho4vpkAFDbZqMcC3RpgkdiNXAN3/ADvalr5QFMqakxB5WGuQf99TQUhqI2F2Nhre8vSj8Lafk7/Yt+/AvAJFtJPubWs8QPyn6bW6rVrM4QTE7EhKsns4HmFRfhC1nyUsyMqv6GOxE4bXooI6ygPqiu5B/J6PuE+dG1jfoqHKwXIhsHX1F8mRnRpF4No8PGV69UWSEfiQ4tunqPhgrkorUaNuXwFzrQ+iUHNIB0XH+bqeS7LFho6m3r86VBZiuItv5k0Ng8EctJnGqOIAc7BHIgTjUmn/NcCaPIUC2/bQ65hUZ6zoc+x+HZBd4DMOEA9RoNc1XkdM0vn8NDCR9bvtBgpeIvmMBcDmwm1gr2/qQ9XCRORZ8cPVyWfxJU5oug71RL9u6yzNYTbGuJgoiO9YmjHj9ZyIpvarf9/L2lM+foYd8T3iXl0aIY36jZyEDGnQcfcDaH3XPEaLbSfJNji1yitmLqULI8zQRi4iy1/AouYKJjJ+60qtPcAMXhl6U3YUb5zq+QvtUZrSrKdcnMjdUehkQYznREd1Uv727NKqjlcmx+cHCrzuIxz/BsLw5jFWXI55QSApVQNk6i7C7hQdap7KL3zF0b1curvnYQuHgvXt2SxVlkWw5QoPyYzaTe6wADo6m9hx
 ur+L6yvu
 iwKZo722M5frZg7rbVCGKcynnsz1TIf1WXcmsCf6Zn75nntS89gjc2dfVwiSyJy/GUJLSwjVsvUhrK6bN1xDLv5ly121ICXQSCXVWFoBonrIwAmX77vYrmbp8SJTZFscWohR83akQLAETSNn8EtJ1LosyVnF98RvMEySuPj44g1Bk8dNi9YCN2GCxp8JFI7xDqG3roMX1uXYWDjR/Fi/pF9DmQRzy67f9gfaUnlaKQ3Jfc3jRnR0PWFkWUQpw0FsfuRSgwqd0nEQmnWz9VtbswdD4qEsWdJ3+H7ygYQuqGjzivK1UvPVPv55gcDtwli22nxdZewFczeX+zSamo/TegpJnSRQj11LTATGwwG6+nSdN1lc6cEzEJ1xc6B4s7n3M2B9qI4kAMlMJyvml3q10p8EM3APqW8BEIXm9VtmyCPMmNSotvMs2mx62bxWsiD8xEDOqdJYtGb/GhrIrPg0vrlgimzjNCTLhz4TApmP202Rzyk10DQA7RbBkEmQunnXh2+eF210gi4pvLVZVNDMjF5KO3/VTEXMFgfGb+EVhvLIyxwICt++WioNzI7VjGBfxBYjdhZoezo1kH+cBwFNOccbde7MralfTkOPSD0WxJuvCZCn7zJtHHu9No6azxyF/zDyZu7zEuJxBYY9q206Gd21TQqMN2QbxcCjfiuTScuI53h6Dh88BRGXdLZrdXaKh4hWS9EcU2NtPQXmGzyICYMHhZjv+A6J4EsGYZdzckzsV9g8ZATRhGA/Wtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 07:22:33PM +0100, Vlastimil Babka (SUSE) wrote:
> The function allocates and then refills and empty sheaf. It's only

nit:					 ^an empty sheaf?

> called from __pcs_replace_empty_main(), which can also in some cases
> refill an empty sheaf. We can therefore consolidate this code.
> 
> Remove alloc_full_sheaf() and refactor __pcs_replace_empty_main() so it
> will call alloc_empty_sheaf() when necessary, and then use the
> pre-existing refill_sheaf(). The result should be simpler to follow and
> less duplicated code.
> 
> Also adjust the comment about returning sheaves to barn, the part about
> where the empty sheaf we'd be returning comes from is incorrect.
> 
> No functional change intended.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Nice cleanup!

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

