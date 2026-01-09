Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A353D1A62D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 14:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF6B6B0088; Fri,  9 Jan 2026 09:26:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D146B0089; Fri,  9 Jan 2026 09:26:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EDE76B008A; Fri,  9 Jan 2026 09:26:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 177966B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:26:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ABFE58C996
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:26:54 +0000 (UTC)
X-FDA: 84312651948.12.B81F7BB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 456ECA0003
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:26:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YVMMaTx9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TCTdLjG6;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767968811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ignBIy1qF59AzOvNj9MJ+7fPnfApHscvW1n6bGXLXI0=;
	b=7CqNyIrl1wjLYrzBOBPKLuaA9D+Mwyw3/XvDzr/Jq7xv5Rt9V15uulR/O4W4uuS6U/2nSQ
	NltoL2IFpVm4IJm5lrD936l9dywaprVEzpkwn+lOl360KG2i9QrH2Gk6Q982N1kmn4Okij
	DVOiS/kjK1E94onft/+zNXgtbJkhwek=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YVMMaTx9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TCTdLjG6;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767968811; a=rsa-sha256;
	cv=pass;
	b=fucIqMskMrX9QZvdPj9Jvrf7zG5LIbdIT/K47j/RYa4LJngpijWzbwQaosBZ1CPGLUawcb
	DLI0uY5tgIKPo9w530Qpyv6+RNi6eXhOllWfSkTp4v8HSN6Pzb4gF3mXCOgZITqZLUOSd+
	7axg0mIhM7QtjVpDQ+gCZVmd2xt+PiU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 609CfG3P2675804;
	Fri, 9 Jan 2026 14:26:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ignBIy1qF59AzOvNj9
	MJ+7fPnfApHscvW1n6bGXLXI0=; b=YVMMaTx9Fnx71NpVtGZwUjLv3B/yGjUJ0X
	8scsykXx8LZQOCyI+LxIYzPmhVDJaes/l/KB/YwnXH+RiYVFEnmOyFX+y0ovM+hp
	zzX6h9UiQ/ewvxzSgCGsIlAUvTrIdGXA/pONUh/sbBOJWqERK04LJPztetmemwvm
	LbYtTkJzscRkIN+VZn12Ow9VcYFWQFmfPLQAvY4ETKqQhq+TFkI6m/4DKIzfJcbq
	WCeUnqUr2ONH3O+Tq9YYUiOPLEL3fA+lC8KLxEA4HQf1Dtz4hV+AUbbRB+SGILeZ
	7sNO2bElsDVEmwqEgpPSqbi7UKtIVB2o4/kACHtB6iqsthhUwCyw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bk1w784p1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 14:26:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 609DFdcd026370;
	Fri, 9 Jan 2026 14:26:45 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012026.outbound.protection.outlook.com [40.93.195.26])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjppkta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 14:26:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WI9SPrXhtf8FwveJlLYILepB6p7+fJ9WvuTJcntEaqVA1wI/lVGfbuCAgrgJEdZrDS+Tbpf/EUqDbM3hCyL4cYIQu67Mpwr+LXZb3HjXI113gcsTp8L8ARb23Za8rA1S2Cwh8KfRjVzeNkMvXUb762jYLkbPezF9CpVWi1mX4GLEsn5imMr0XlITCI6ta5BlsDr4CC8Ui5/dFUVxkK0J18zmQgmoC+ydntZihCkTUwKVXMplE7Yi+8tG3UBtZ8Vgr0Fw8UlZwMUNUe6aH2Y9NZRK8se2OL6Jf3GSi7KUCr+uRdhrp+rMYUEOgY2N6oidN0qFgKNo2TBGdHY5ij6wow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ignBIy1qF59AzOvNj9MJ+7fPnfApHscvW1n6bGXLXI0=;
 b=XvNXUkIdQzlIWUShbuj02FgtrjeK2V5al8rYQNlm9fgCRw4O2fOxip0l5mg8mNYV+xf42T8N0ZKcDYHJD9POTrTpNDpM6yyV5Hh5PltGJk2bRtHFZEJweqKJJ3YHikFHm1N0Z/XMHn7xz6J37GSsuIv/3o+Jk4fD0KxlOhJSeJmlZRyYricuJUfOXdHfqY2swoRWdEfy61IGm6hu1DQvSSe3zcf2mGd6diesSTQ9xBUpiaFSA4ZEvNXY5ozMnG+ac5wUYnII52bY3kQ5Zk1uR8Kqgj+nLBoLbmo1H2RY49NVQNGwxaaZWqOXMaIoi5FN8nEVdQrQp3tuIRXVY9M7Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ignBIy1qF59AzOvNj9MJ+7fPnfApHscvW1n6bGXLXI0=;
 b=TCTdLjG66SdcHcpNIE90bNc/4XnVhBdKSXEGoFE/5bIkDQTPY3G5sy0v2n6laPX51eAQiFEIO0/DCCyyEvlD9QWAuqZ8aPlub4f0FYbP+C4MEBK0wqcZwI25ygHxwcDvySAsj5zqys5J+YYELOzSw/qozupD0mLwaeOgtQ4x/BA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB4888.namprd10.prod.outlook.com (2603:10b6:408:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 14:26:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 14:26:43 +0000
Date: Fri, 9 Jan 2026 14:26:44 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: SeongJae Park <sj@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        amd-gfx@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: Finding mm patches to review before those are pulled into the
 mainline (was "Re: [PATCH v2] fix AMDGPU failure with periodic signal")
Message-ID: <674d9cc4-1e4b-4f2f-b5d5-809915728270@lucifer.local>
References: <20260108062637.82125-1-sj@kernel.org>
 <746bd1ff-b3fd-459e-b491-c62b160a956f@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <746bd1ff-b3fd-459e-b491-c62b160a956f@kernel.org>
X-ClientProxiedBy: LO3P123CA0015.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB4888:EE_
X-MS-Office365-Filtering-Correlation-Id: c5fca101-bd4d-4012-deff-08de4f8b1ca1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ekf2m82+lKEJvi8QmSDYq/bzjnS6QbWE6OQHblhdA13GAdzEyf5uBi5A2Hfj?=
 =?us-ascii?Q?LdeEGL6k+UxNB1LRE23XYgm2mT1CbGmeXWBNHNyiiHTKS4jGpEPMFWl+cz5C?=
 =?us-ascii?Q?4QC1v/1496tkSMjtb8PJ+lmAqczjt2PypqVjoGDYA9BAJe4CXiOUldCyedCF?=
 =?us-ascii?Q?ydpNaFG+/dmg+eC4sIwd1yTlzlZFKEf15ODt1pW6ItlRR5zlRuaniLifDkyK?=
 =?us-ascii?Q?Y1GdP4J/jatx/L5FbvmM0BKVtPgO35gxDn26RaJpBYOzA+fBCsPEylNBINxE?=
 =?us-ascii?Q?6jiKNZJy3H1w78juNkQ94/8j2jznhwvaRzui/z2ubiXBpCPkMyBCOzIO7BV9?=
 =?us-ascii?Q?EgUo4H+PlRpWx2jdc/V+DBdC7k5adyQvsYmmtU3vXsVPGHdNldAoNyx7ghfG?=
 =?us-ascii?Q?Lg+cA+0q14cGPAxGXdmIG+G/DuPA5qRgxw86L9VyE19cx0rXnlKlZThvM07C?=
 =?us-ascii?Q?YK0KkqKHYiuxLbPN9/rffthefDgzMjl+ji0KQlupjVapF4A5qg0jLYcO2xrU?=
 =?us-ascii?Q?sglnZTj7S/5yNAUYJCi+uJ7ycP0KCwmC505+s3Z9XKhrZghd1s8xQ1+jG3UT?=
 =?us-ascii?Q?3ywRua2jQ4kOFroAX7oHPCC8JAMR6lvMzSuHH5/T8kSHp6rTqnDe1r8Rps8s?=
 =?us-ascii?Q?ewIxA2uXzVRe5ImzuwCu+05uybyhn/NGYDnQnxWb+5FatgFx/n2xI1fQ6GGQ?=
 =?us-ascii?Q?wgMipxo62zv5p59846PnS7RuylKm15Qchu7GcT0fYqDtzKL85K6424gzV067?=
 =?us-ascii?Q?lNNsnNuLqXWDY+A6PdBcMbSS2PuHgLAFyZ85gJWaduxt/JomiDRapZ0kLooO?=
 =?us-ascii?Q?AZRAeYTBKJ/CPhvP78P4wJARwueoSqLBp20zxQfJevD3lQiq8CQOxoNhSYBo?=
 =?us-ascii?Q?vDstB82+/k/9hg8dXTaYR3WeATXD9K7cUk7Oniyi8vmTeDTSYUujTAh2/RH7?=
 =?us-ascii?Q?UaNpvD8RRU9stzQhG+L39P4vbp/DOx5z1jsSxokmL04wJcMBpZih+WeZz04E?=
 =?us-ascii?Q?QL0Le2CExTPuCWgfpvbEIJ1OMmva4c4YPpomB8VZX3dw6bPUhQ0ZMLjlRnTW?=
 =?us-ascii?Q?yJMy+1Ahy4drnSckLo1p43NbtNcacDFiPLsQPPV74tKvSLQMfeGLiTpOmREG?=
 =?us-ascii?Q?c4ZoMvhh11ygmv70I0VdVWkcNT4p+rp0GLzRB7MaSsAEZtPowht+eJaPYGhs?=
 =?us-ascii?Q?b7Fdm2RGQB4zIuyWZxhNCPuWFVKoBJ1N6590pN8Eo52d4Ao94nG3fNtrORKh?=
 =?us-ascii?Q?P1I/6PoM+h4WToebzgZJs6Id1hOPE0PUosab3ks9QHexsmG9wNDkUvyNRxIG?=
 =?us-ascii?Q?mbpIB77+KNZ1A3YfDCDBnuRC/WTgbb1NzAYt1eSASlcDtIWmH2GLZHNxV/h2?=
 =?us-ascii?Q?SVk82ZeQLtulQB+XbIICPk6WcwfJGqvMztHbYmP+i8edU7V88S+/acjwR6Sl?=
 =?us-ascii?Q?tEzjGVew3TlZ6E3azcD3qrBICYFyv8a0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0HNIk9j9dORuwxI9HleiOhgV6/oAKLxJUqzjzxtPkf4LnwZeBNur/LzrBlH8?=
 =?us-ascii?Q?/FMp3GXK1+rQ5zddrdnawpBeP9ykAhVBPdcIut4fXigfI0bA2Nfp3YdvRIdL?=
 =?us-ascii?Q?5O3BMumrSz/zrf4maZFe/xdVrIt4+XmAWaDr+TxnVgg/JYOX3vCbmSgMyfOM?=
 =?us-ascii?Q?T7CvMbalJkE7S3dwwq8ZCgGlm0b9KMRmIDD8WbPNC0MwBD/FW4eCCH0C0jat?=
 =?us-ascii?Q?/Io6BRoKWsF2Jv0EBhZROXTK0rifgRo/q8+gfTFfw2VM/6OM4j1xdMqM7qAM?=
 =?us-ascii?Q?LDgmbfEiZKoxjZJR+fu1RgY7ThjsLyF7muYOLyp+gb+QNrIdrOh1tAhLZ/gT?=
 =?us-ascii?Q?uL2HH0aSSAMHIt7uB8ND7iq7FwjaA/2oaVVi+ZK7/ftVstJ3aqYDrrJasR/R?=
 =?us-ascii?Q?0I9g2AldD1aDur3bWShTqL1z1vC4BzBCEXa2u5PUGW/ohjJ/sv90AkiArypF?=
 =?us-ascii?Q?5hPvWpLJTfzhAumCZ28H0s4f2e9exp5MArXlu0IPM4j5UH8/8X6DV4egifRh?=
 =?us-ascii?Q?wQwede36ncOT9Q01LOUnOhvz8ynIZi/AhFzTIoqtz1YrVjtbzyzjrNXMkitA?=
 =?us-ascii?Q?mBx4Usm1GpyDYQmjfEhnNpAoCdaZgOWvJGFTkm0jvnGh+i1z2nl2IY1zQgSb?=
 =?us-ascii?Q?aFnlSVkQUhdYTRSXOLN33l/EAa1NMGjXmMIEPvW+wrf/qUtS4ce40h7ixuPv?=
 =?us-ascii?Q?inEumwQWVS0a56HuaSHjbJG6WgGcCPnr3RFOdyu5SHSePTGZEBtbaIg68W3c?=
 =?us-ascii?Q?7AbEGkPijD1/zZWmjZMeaDYldK5JXKnoRycl11Y+VCHTW+IWTddOs5qAX/xr?=
 =?us-ascii?Q?eZoi03iptWhSwI1WKgcSEz4e00BuTr3G+oYZGkKttlamtLQNBwngGdte67ps?=
 =?us-ascii?Q?lAURSCnoaB5AQetMfeW6zTnS2KxfQWdsdF1CYSYDW+d4e/KZksE1o5aOytt5?=
 =?us-ascii?Q?qmg/24o4xc3p892fNhfI4fJqxLOdY2MgqWBnCLWte8hrsj3lWEtdZyP2I62B?=
 =?us-ascii?Q?E9CtjR1muKmCYYXXDN8M96nO92JZQj+VK/iBMOIRXJUhBJKkIbFbQm6j2yQc?=
 =?us-ascii?Q?ltDAuQ19Pga+K5dxEhGZpxbldlvUzAp+y/veoIlfcNYszzE5+XPTyXaIyNnq?=
 =?us-ascii?Q?gF2h0L++JlRnfMkIO1QeCESq017133BQUqAt3ioq+gEDdX2TUPXIR+1c6xDy?=
 =?us-ascii?Q?3V8GuCKyIkQ9SAYzbl85L5u9jr0xOhzAPrwoq0HuYYcEFzDzN3vhEN/rEzmh?=
 =?us-ascii?Q?VeMXRjBIbiYC6hhXIzcJb1XRG1OlBlb7JPsdTY1pMMAo+JtrD54UvQaNexD7?=
 =?us-ascii?Q?qfgboF+MTtzfhhgJ7tt1hGJLI6bkiNoWIpLIwV/Emr2WtisNc4pNA5bqN/Z3?=
 =?us-ascii?Q?8sCpYw6490H0eDgLQkksVT+via3VSzPvCO8qU5ecWVPGYnDvqev/964+5A6e?=
 =?us-ascii?Q?49pEx1UQf87n0mdFLwmCZf7NATafP+4FZFihqythv+Q+bQtN+SKNt3pLCixX?=
 =?us-ascii?Q?Zl38L04AvD6UgqNCREvWEomfE15R9VrYuje/+e/9NeuiS+459w2O6XlFnbZn?=
 =?us-ascii?Q?zn2JVTPkbmb/JLx2DlLcRzXiCmh3KQCF+lzPMc5rQn/PBwbKllUrUTxY8wYo?=
 =?us-ascii?Q?0RjcNI2eymhOMs9ZYYpbw+CLdEJKyaMSJPDY/ydA9NKUrGvWjFXJVsIj4qPn?=
 =?us-ascii?Q?GOOhV/onxcnt1EudjYqecLrpEjLAUHmp1ce5Ykc17D9F/vUUroYMIU3fxZUf?=
 =?us-ascii?Q?xNV8qX1M6SZsNSpM0MMv8MMx9jaADWI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KauA4laJX74fm2QbEHXXiB7lbUuhf0QNLndPVrUZqMDI31dRQOjOeuUdqgKGLfEraCCucekhqo4dh6F8uwSChCvFmzsU8iGIv+jAePUxMT7/rUQoQRVpqk6MuVJUZsYYZRGSNF/955bLGeVyCkdS3r+LnJPu3V/WYLOwK0fjp288GxDJqahOfKhAD/wvuKC3z/Wx/i1X5wDk1kArLL6JI/NIF4vmTe6pWoZTAApa7Nx0A1yC70uxY/hCfsHQBXa427406YKMtS4Z6D3ZGXuHyI0y2unPSC/MtsfnHe/gYb0sReo04nRLNO4bulnKnoPrdP6cZr9Smq+P7p9DFivLqd5KlcYVn5idfJkXosxKJvt/KTM6n463ZkNzRXMqHperg3cFkf5B3CuGAK+n8DGGitBnEZ8WDLIBBKn0Z52ugSZHm+P8OWq+OaId4CYM0TBXasBLc2k6+0rbq42badyRgUlXgT2bVoJm1Ad99IUWgvET73nt4k+bJKklR5FgHSR9y3y5Cz9RKcSoneo2lUfdGBfzg133TsSRSBX6MRc+KXK7d3CnqC+1y0dCJQdcIbxoLtZBvT48jEQeo6jjUDy6EWxbvNbFyNiA/8L2rv8+sm0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5fca101-bd4d-4012-deff-08de4f8b1ca1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 14:26:43.3827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9wxDm9uqUa2OXD0gNt8qJ9XBaVhLUqvHgGZjhvh5H16iwA4vVjcSHgd/b4i4JzIHk2BmNNQr7FZ6MD+VkzHgbvFXqX5VoDTt7kRNYydSDHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_04,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601090107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDEwNyBTYWx0ZWRfX+c4opTlem2aT
 rPSothJNWLILIfQTU5/cLugCBwyqC+6IsbsgVIRzbQkJk2Dt04vXFUyda9LFfMZoqDznaRtOuZG
 0kSPTtBErBoVTgXSjdn6rw+s8/eNNo2LQTjrHepaEtqqlpckv60xAnGc1VWn9zr/SAcxnMzvkvd
 hegxMOH2vCL7vMkmhOWbM+mQkbNHG9W5afBFV0O2bAqoybBe0snSWnESX8Z+hRTc9Z60qLB6bXE
 VCx7AwDz1K2q7DVt4K91YX4hnpV+pShXCl8ViVg+g45UduuGLPKBUn4AQnFqDi7FY0tu5UbI/Vh
 LLDwetF7U80U9gP2KVZsytJyc2sWtFQ3S6dnJLy0Gfv3GsqF6m0J+T9csTbwjcvOTD3jh9TNSsI
 AgnYSVeo6q8mpH2QDqYCL0F9FpRT+mZlR0JOcZNcFGAkXFtTD8itYZAJRIMetKPwJFXtkRyNZnI
 k7c0hNnvPrkkf5wCPdSAjYqYyGgSBfDTagH7Pl7c=
X-Proofpoint-GUID: 4Kzk77VisdR8UhIEoBSOwTnEu-jRqIRt
X-Authority-Analysis: v=2.4 cv=VoEuwu2n c=1 sm=1 tr=0 ts=69611027 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=3wTaxfxwHTStLamafOkA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: 4Kzk77VisdR8UhIEoBSOwTnEu-jRqIRt
X-Stat-Signature: 5oswzoz9z43eis6k88mafneywdmpc9ea
X-Rspamd-Queue-Id: 456ECA0003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767968811-734693
X-HE-Meta: U2FsdGVkX1/Zjcn5AO4PF2hCIclL0M51tiw5daafg/T7ZV4vxIfL5TPIxqyGIkcsboWvrGSjgQTqpSDXAC8DyRDlRd1vXJL9Dd2tJoXUsatRzz4CWZJukmKEqS68sXO2BCOkY4rHG7Ced1JAgMP/O3W0MMECGbRXlbYTK2hayHIMMl6yZAzEk8KC5tm2PHWZsrd8PaNFWmXdMFKMC7nFUoA8qPzi5tEVJwXqe7PsXBP0Kcb8Ks3g0gBPyheLlzUegGaybmVtDiPS+SfzBiPG/EOQMxCCohKDC8OJXxxcj1b3Y2GEJhY1Zu4nM0DMmwqlFB3T/RbxvMWj134qyoaE4b1HcDnr3xObOV38Xu0NKaXMu4LZtfGcFud9zOHx7YRfJ8hrEw5mijeMSBO4xvQCw4lJXWvaexhalPansVJdBb51UlOXHANDfVberjPO+QizpYZCuGJQhOLIBznbp5NxXUQzeaXxsAhNdLz1h6Nmo2en6a5n1UpxT9+cF+Bkgwj0DKHJaF+cpmM3dgxAaqoAZWyEljwdcbMZY7XyWhHcbdgp1irSBhxzlpDRtOZxcr5oV1M8uy2mR/2rW25rrlaTSbYY9QYV60G5E2U5JZJo390wI/9Vd5Hky6u/vjIh/u4KH46TuiqRwhEVLXFPaeUCyNg82PnGHcf0Y3mdgL/Wo1GP6NA/KhkEQI/IkqdEvridTacXcmYdm9mc/3oCD+Ei4OUbJ3aBTFFLONnKFbTSZ8U/aql7splip5BLQHchD7qmhYsQs24EBPFC/hCAxnQcU5xOh626XYdukOeDyf0Ftke+ByueVJ0lxkqykgTrfQ3VEFnOsf+knmwIgy3AkddOjpgL2zH6UdJmoqy8Zh+9LpBklojUOCWvNBb/uM/oCaGzo0fwjadL2+hcmBHPZU51JyMaVdqDPtMkLjLgl4wopCNp+aYFJuLxB0NrmDIq5rgccsK8Fc1Otl5LoQ/AUk+
 we0RRwdr
 PiyWym+9fAw3LZ8JxJ1CXrLE5fHildoVtaASQA4rg4dfxa95LXla/AHqE0TOmIMbzPDDylHLH7D7sk+Bx5lXjSszLpFTtfMlcvNbOMaR1ewUcchTnywHW9UHricGozW26OahQ3FTRNasTye0AZfsARRVufZTtNVJCtJuDjDuzNTPnk+6kR4XO+280SVBLmwAP0U2Se128OG4QN+JSIDYnLsTYSrwfeLWoYd4fXIL2qJEKF9rgjG7zTiMOJ5JQUkVvfSwTFsXuOpj2EpIevvy5rufJG+Q1foTjTO8NDSPvKWgkVTEBJgRoptHaaSVBUzV4k45/d46u1IIfa0qdNBG8jI+cvAQW2tWHRwN0Q4goeddJHyNDDdbfY+/Y3CNAOT0YhGuAgi/ARHMUdFltNd5MxyjkOsR/TbOrMvCZiQ0xVu7ObiHAwaDPJVciv+VL65Y5zkTMwxz7LPMWz+2MXVe4a4SIUDuPkD4/OFLM942Rx6zd96JMkxorg0jjhX4Ai8ooGFcIQyVqbF+rjglyQXfjxmmhRBJCMzK99SseI9Z+/FzfdBHQGgBpgsEjCTa3H3K1/7VJbbBZPkT/w54q80CvMwWHEKptB11DSCit41+REHTp+cgL5uBPuaRlJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 03:16:57PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/8/26 07:26, SeongJae Park wrote:
> > On Tue, 6 Jan 2026 21:52:25 +0000 Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > [...]
> > > I understand your point. I don't think anyone wants to see patches falling
> > > through the cracks. But we also don't want patches to get applied without
> > > any review.
> >
> > I can also clearly see both Andrew and Lorenzo are trying their best to make
> > Linux kernel better with only good faiths.  I always appreciate their such
> > efforts.  And both their opinions make sense to me in their ways.
> >
> > >
> > > Perhaps it's time to deploy something like Patchwork to help track
> > > outstanding patches?
> >
> > Nooo...  I'm too dumb and lazy to learn how to use Patchwork...
> >
> > I believe we always have rooms to improve, though.  One way to resolve concerns
> > raised here would be asking Andrew, someone, or some tools pinging relevant
> > reviewers of patches that Andrew wants to add to mm tree.  But I think that
> > might be too much request for a signle human, especially for mm, which is a
> > huge subsystem that many reviewers exist.  And because the reviewers have their
> > own tastes, the solution may not fit very well to all the reviewers.  For
> > example, someone might dislike directly getting such notification mails in
> > their inbox.
> >
> > In the past, I actually considered making and running a tool that scans patch
> > mails that not Cc-ing relevant reviewers based on get_maintainers.pl and
> > forward those to the missing reviewers.  But I didn't make it because I worried
> > polluting someone's inbox.  I should also confess I worried my electricity bill
> > :)
> >
> > As an alternative way, I was wondering what if reviewers consider mm tree as a
> > kind of compacted and curated version of the mailing list.  That is, using the
> > mm tree as the useful place that we can more easily find patches that we need
> > to review asap.  If it turns out there is no time to review immediately, the
> > reviewer can always ask Andrew to wait.
>
> I have my inbox full with stuff that needs review. As long as I am properly
> getting CCed, I am well aware.
>
> What needs review is at least not my problem. And people can feel free to be
> listed as Reviewer to get CCed :)
>
> The problem I have is that if I am not fast enough to review/ack, things
> might go upstream.
>
> It sucks. Hard.

Yup :)

I'm opting out of this game. I think the more untenable this becomes the more
sub-maintainers will do the same, which is not good for anybody.

If we are unable to even determine whether patches land upstream, what does it
actually mean? We do all the work, then still - unless we burn ourselves out
jumping on everything - we cannot prevent broken changes going upstream.

It was an irritation in the past, with the current rate of submissions it's
become completely unsustainable.

mm needs to change or it's going to simply fall apart as a subsystem.

>
> --
> Cheers
>
> David

Cheers, Lorenzo

