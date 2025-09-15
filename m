Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 329E7CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 14:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA5D8E001C; Mon, 15 Sep 2025 10:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ABFF8E0002; Mon, 15 Sep 2025 10:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 625058E001C; Mon, 15 Sep 2025 10:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49CC78E0002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:08:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC9941606A6
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:08:45 +0000 (UTC)
X-FDA: 83891665410.11.3E750C1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4C784C000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:08:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N5BHyqoJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="DSf/XCdD";
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757945322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJ5lbM4j4zjZNOZGhob8Zn1yOPAgGKIc+7HhcjJO64I=;
	b=5pXSXBQiirHU/hsMfVtbV6/X6WT9xj80+jRQctzQNkcK5a5XHtVmluznosnMaW3sguOTcV
	dtcUgRNPmYW3/tp0yFjo4bEe2v3I88dUbGvhq1/6Ctk4AXxFnkr65dKmah7UivSM05GEE6
	HGmlkWujBSoj7h6S8Ij1KZPQZmLYhs8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N5BHyqoJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="DSf/XCdD";
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757945322; a=rsa-sha256;
	cv=pass;
	b=rWG0U7kYv/YrU/aL6xasK2zQEldDB0YFeUV3rD5TULml/uWr6K56YZXsekMZvFfXMsi7hv
	AZ1NaOi95ywP89YoPEltvNexcbiDOgJuZEzfsvpRFd0qOINxXC6/lwifH6SWvwFrdlzqDJ
	Nr4kU1lDJWQmzcoNMN3WpiWftDKJhRY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FDC1Np005333;
	Mon, 15 Sep 2025 14:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TJ5lbM4j4zjZNOZGho
	b8Zn1yOPAgGKIc+7HhcjJO64I=; b=N5BHyqoJpf6R4+pY/T/cFuUyxs6B9U7Ewz
	8cDX4ebYrSOwYDdF15WBY4PpKGn1VjjbSPapFYnr42sx+w2+PVge8xLzNBRYLFBA
	bkPUzGwky2B3gg70TW6Y2XicgFN/WxqQ+MZzRseZvlz4IIClxXiaBrLQxoA/nJeO
	C4390YZkXLjNJsHvRoK936Mk1+6m2Xir2weEE1GaJYSZQQL3yCVV30zsrCMc4YvC
	Ocvr9iXIRVOms3pjTI9dXj5wOyuYST9q+HUGAhzZJlxLKLwOFEu+0OZL0oYko4WW
	eBrTaVNI2IDGTBUFKrJb+WlaCEEDkHmU04VMdZzaPC0uV+r8RPSw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49515v2epy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 14:08:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FCoHK6010552;
	Mon, 15 Sep 2025 14:08:34 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012063.outbound.protection.outlook.com [40.107.200.63])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2b2v6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 14:08:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ekCozGQDhs65PIq6GiG/kMlNuWwKmrbnawk7tOT7WOYyA4LW38yzz8iriG1D2EIl37gRcVuZy8HQVbqMzbQ9w7e5Ak7UVFYWLQzLfnJQZtKFQcSgQUF+K0b1fp9gmALPIP1A+1kw1ZQNF2U7bpagcxk46yAJbZ1qJCUPT5BEv6vxLqJswd8jQDhiAu0wxGuW+tzBccmYfwZBOAHx2i7tyBfCHVYJnVRlbA2iZeO4bdqv40e02TVNB6YXW5QFoh3ZBwzhwwkBZyrbbrImnStASPu7A4SoCV62CfPLPn4/aShgOUMu5v8e1bGmYdnTB49Uu2iuhqGmdwNGbYtT2qvv3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJ5lbM4j4zjZNOZGhob8Zn1yOPAgGKIc+7HhcjJO64I=;
 b=Xdr8mII4a0CJ7aDGBbtUUH2Hb8pHiL+yQeIC4ahXwkG9QowjT772cvgLo2iuZzwXMiH42wqNcpvyIu1E3Xv7PP/XlV2h8RFpNKi3iQ2uRKcV7Btuw6dzUXIRf5tqfyv96nQ1Pqts0NHyfEvUzqGTFxhvWHEejO5lSh3vnTjJI1YHSaF7bugjwSijoTXyYV88f136+G7gpigMp/5ODNC7ZI2UolW8a4l0A/+9JZp9fO+XFpydQX+g01oS5yqjB12dltwnNCVhkRjH+dwuYHLWZ7eknQOy0q3zNWEyXUU+g+sXelcY21fEcc3q8prIRpfmeO+i2cMZntnAdPfF9lP5JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJ5lbM4j4zjZNOZGhob8Zn1yOPAgGKIc+7HhcjJO64I=;
 b=DSf/XCdDWPqIXOJ34pGhn8LgOfYP/OTKdz+lgxQXo8FGA8w58Erkm4R6P3+1PYu23zmsFfWo9bwkKmLIf3LRw7vI7dfFMdSHvfokN1uSMkgiZJVZqxjg2Gfm3wPFo1HUE4MNFEnNtHWXN4qz4JarYWQH/HvINbfvHVnm9FUWKp0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH8PR10MB6411.namprd10.prod.outlook.com (2603:10b6:510:1c6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 14:08:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 14:08:31 +0000
Date: Mon, 15 Sep 2025 15:08:26 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH mm-new 3/3] mm/khugepaged: abort collapse scan on guard
 PTEs
Message-ID: <59519b0f-af14-4486-9aca-4e721842d45b@lucifer.local>
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-4-lance.yang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250914143547.27687-4-lance.yang@linux.dev>
X-ClientProxiedBy: LO2P265CA0164.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::32) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH8PR10MB6411:EE_
X-MS-Office365-Filtering-Correlation-Id: ca61eecf-9444-44bf-220b-08ddf46159be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ESy9Tm8uNtbl0+Glp4CKVmAXmnoG2RUnZAvfnzGUtvPVdyC55MYO/CN6uiUa?=
 =?us-ascii?Q?ErJQ7KFH1jR8JPJwudPrlHsNR4vzDHnFcPcRMIovUfssyR95SOidgUWU1aao?=
 =?us-ascii?Q?EEjhrakUoZSU1pJSP4R81d807C2PUN7KIRl7eYRLOg6TLYIiLcvWiEc7tsvG?=
 =?us-ascii?Q?AR2Heh7kip/reztEG3vbJQCtWcGXlOaI65RqNRPVTukCb7Lhdhqxf/duwVZJ?=
 =?us-ascii?Q?jGOsA5BW7xWEOHWflRbZ759J3gSwTZf9Vnp0HDvQ5xO7v7554x7GBXjipix9?=
 =?us-ascii?Q?x72/kk3V+wiD569rpBy6w25O0zs/XFFQMJTOXR77uA3l4PJ4Cp3EjhNIzZlF?=
 =?us-ascii?Q?kE2QUs59G+W0vJ+sn+yfHXcjRra4C0HAgXJxLpixeZAVmvPnJaQ4ZtrsSbsr?=
 =?us-ascii?Q?ppOAcMP5l3mbSVWCV2Zv6avTiSgsMudWChetEyXM/FlIbbnlezTe4RIuOzFE?=
 =?us-ascii?Q?vAnDgfBaoO17xX0QOPvyhMyR/Rh3fDzDnZYphLaFYLJOj7TvUyA8dwdH8AHO?=
 =?us-ascii?Q?mHK7y5pOYyKLpSk5t9VMn9Yi8eUrSFcOuME+be2gRMI4vSwnn2B2L5mxQxZX?=
 =?us-ascii?Q?+kwdT/Uaxt+38lkyNM74l+rI3i7uCNbQU2/TcG6Ji33aElXn2a8zt1hMzsT/?=
 =?us-ascii?Q?h6fTbch8RqsSooClIsfZrG12breOGZvl/xPElSqH1C7UE9GxmBa3W6JWcAi5?=
 =?us-ascii?Q?xnmX9xgFv2yuQfD1f2Qm7h+xUGF7XT5anJANM7gULy3R5GDGz6ICmULuKnLg?=
 =?us-ascii?Q?M9dotJdhyF/xum0A8u7IQ30sEnIQM2I3iPXbxRfMeNWmcEMVxGJCVssMOFVI?=
 =?us-ascii?Q?1OHvmV76tijRCY36O1c6fAYg6IUMCyAQPx+O2FORiQpv0QMS8MthsSEmfeZ8?=
 =?us-ascii?Q?oh0GFNoMP68I/scErJ1A9X/OBNVsiCRsxEXWq1+Y+33SDNN8ZJhgeV+kRB/1?=
 =?us-ascii?Q?MU7hR/jQXNpIOHDptVZ9BRJafDCGcGhPlVpt5WghBwyQdohBwibpoUwuJqKt?=
 =?us-ascii?Q?jz7jPm2Vh/m4Nx6LbtX60L8fFdESuvQRyGkYuKwqfrFlAikCqy71jcSrAT56?=
 =?us-ascii?Q?97wK77CzgkmSzpFJZfLtdtOo822dapTwNd+HMupBqsTErkxKjYZoFSfkDDDG?=
 =?us-ascii?Q?dJ3bKtg6H12bZgAZ7mUaofnlpwx4NL6KIFnMvO4nJEIyT7ZINU/1TqWVQSV+?=
 =?us-ascii?Q?82Uvc6Z1RjPuWy6oHWPgs3IwNIZ5fSw+2lX082mraqmadex3udzqVXRkMler?=
 =?us-ascii?Q?kVicDhfqB8Qo7ONe+Kffgl8+Q4+oIbkr3NdqflC2XvkJ6f3LHDNyr/xJUUxj?=
 =?us-ascii?Q?bvIkLQdSRyJ0WDjt/dxBlpY181ZPiDTIRFcVkwUR14mvscSdqzajGoFS4xR0?=
 =?us-ascii?Q?JK5mBcaxj+gzQbEZVmuPhPIAdckoiOSxJGIH8R0JZNX68cIZjOFU0svjTWJd?=
 =?us-ascii?Q?wjqmk3MUkXc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h5FQzzk45hO1X5fDYHKZQpYHVf62FNaCvwM1jUOysjTSRZJkGtefLmOhQ86/?=
 =?us-ascii?Q?ozQOI10chN5RnbivPsFfIjCnsNMX/Fam82Y6ZazOQiNKIUI2oDZ9wOQe1zVj?=
 =?us-ascii?Q?ZS387Tzrv8nniIqr6b8OJUtYALW4e8ogNQvgxxklRNO9J8rZsvGZExYVF17f?=
 =?us-ascii?Q?L2CMuyDQyx72pYaiq6NBmaWtrO2JOGu3YT4QwwwDxcAegB4BF1hPJIVYOcN2?=
 =?us-ascii?Q?Lu/O8P2pHnv8TTqedbQm/pUWh3q2MAq7/1JnWhGamoFwvSJ45yPWUa5c4Vvq?=
 =?us-ascii?Q?184CQAMUI5yVvswhILgstGq+UVAnIk+s8Aso6CQ+yFkgAE2k+Ccy9Qktvm/j?=
 =?us-ascii?Q?nULmGzpgaO1FvtYo8f6GJBCaHJPA1Zp2KuRSpUE0VuOJBgNnYKVTN0iTDQcA?=
 =?us-ascii?Q?WeIdrTnLc65fVrplwDp+ZC/Cypowdhma+4zuxK6j6zjsnnj4meso9ETj31VO?=
 =?us-ascii?Q?UA7mKXU1KQ/RgZrn4hEPdWvAZM9epUNFwrKcNwMrxL9BfxONcO5dw3Vcx1NP?=
 =?us-ascii?Q?zByWwkTgIbBjNpjIjqCfs6Kap0WL0AG6ZXXLsvrA8tJqx+xahv2nxdyt1KLu?=
 =?us-ascii?Q?VD3QpoNYfUiFsr8DstiPlzV3Q8cEHeFIyGCOMXZkniOJPHinBqIUvbIAGtYW?=
 =?us-ascii?Q?uZi9A72s1r9vFgyYNE4J05szx6DnYkqvWWvUM7P64iBk7schGw3KNI7Pn/r1?=
 =?us-ascii?Q?3yB+WpMB7xCUlX0PhmgGWBtRiMQiuNiiVbDcGYpl5YlIiMy0ovWSgWL0zzmD?=
 =?us-ascii?Q?bt0GFzTjHD1+wyXx5Fgl+m1S5FVd9RJH/DfWBw+4s7KtN6rZf3dF1CbRBhzP?=
 =?us-ascii?Q?Y2INuN6OXyBkdQpiYcR7pNGT643eLp66BaB0micUNJSy8nBAt9AIv0WoN6bt?=
 =?us-ascii?Q?xyxB4Mbi8fhUUXWQai3w0ggc5H+rWTwYjyUC2KmhKN7GlSI/Q5msBjI3yfgh?=
 =?us-ascii?Q?jQCfemw9Vmi4K6MRiTsRY3ku/35V7q/eiVbVfoy3qwgmmKYoIR3PWPmF9CBx?=
 =?us-ascii?Q?NFnCZ7jjWWpXcLRuKvbnbmihri8ycwYlpghT6e+bp+H/NmFWnfMsK4TB6hr0?=
 =?us-ascii?Q?wDUeLJm2oYIhnHbsaClt7oNCWWXHcxpnsJcx4n8SnuKlP70XkDBei4W6kHY7?=
 =?us-ascii?Q?IumDitMm4Y/e7ll2B+VJTS36nN61QEhvrH8oIwI+U5mYBd+gbrHuUch7BxbY?=
 =?us-ascii?Q?wnAAYwi/SyrEhL8B5MqXSFWOaKi5z5pPDtAnx1HsMs+In/jMfnLewYZsNOts?=
 =?us-ascii?Q?+fFLzWdyDmlSq+YmV5xg3qVXJGfIhGjD13mIoq8TixmM/IoySCSh1WGDs6xi?=
 =?us-ascii?Q?CPLUjpONe/m9Ei2E8vz70aixwtMZZogs3M2zM+1jxWq+4iqEaw1TSrf4Ne5x?=
 =?us-ascii?Q?cxBuZA6ysj8BZArwHVJFgxJgPxKFVzQZzFEG3u3x/zegKbDc0qbVYRx4esqr?=
 =?us-ascii?Q?/0dCl6s2FTxO5OKh7I+Nh17OUcuhXQAHABMlefQ5wrKIXH2VJpjPizGK1+Fu?=
 =?us-ascii?Q?UD/Y5Wa6GZEBX71Du9B21bE/w+C/zGWPYJGDvtZQSfZNjwx3wP3ULOx0puWL?=
 =?us-ascii?Q?VI20OZpQCnCOPctJrw+9fvP6QQfQkYp+FLv3TdTtU9nmmMjPBmwucnjMluMe?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JxLH8szxWUCjiL828677mdZIsaeeqw1jblq3lNttMa3D1RYShusTowtPc2To7ctpUQPDKgDvz2MYWYcQtPvWWkPMq6gTfiWlH2YbASEaHwVpfXSFg2z0inLtDLz/QbA2rbioKaEuV/KXXAvmWRbJM6tILoLQBvF+UpbX+jYbW2EkC4HYRSPogzrRaBf7USFfWk5Pc4Pg5GynCM08P7I9EPS8zcua/sHu5uvCdFaHf8XuVujDSCElhwOmFJAMbO4VcYhKoGP2M+d1z3Tcx4EUgKEmfqgh5mDU1dB3OOKvwyRb4rvqIHcAxWV9XI+Hdgyfm9b93khNBlYBP1EwLjDoC6BFsdMVtOWL6t1lBpDdi9jfuwwMhimNScd597x8NksI+J4j9TK47p5Iyyq58GzJMrno4mzUqrVn8iEEywDN094Y+OH1khgAnKTtgy2PMduYwIIMrq0Xr7bDlYdRuePul1XcVhyEDL7QwCmgTGsZDMK+XUdxWdaxgjeFGYSKiykH7F+BhsmW8M9MoUTkHUejJpWZsjjzdba/57RIVHDnJIDvlTTt0GZREK3EQfFXJGKbQNwdSgaxnA4NmTbWJ70SPLBtNKo4Bq01fbFeP7j8H9s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca61eecf-9444-44bf-220b-08ddf46159be
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 14:08:31.1696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dhbPUh5KHcBQ81ODvk6x11vwAsYjSaPIyOqOaGfpJvHst3PyrbVuQF/O62RWMola4ovgwENwGgsepU4pAOiHyIDLKWlPxplrgYhKq5+fjlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6411
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=928 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150134
X-Proofpoint-GUID: P4XDK1LIdwwHY2Yij_ikKZmUPYC1p3-2
X-Authority-Analysis: v=2.4 cv=RtzFLDmK c=1 sm=1 tr=0 ts=68c81de2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=KXql-X9u6oLGxoxcyGUA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAzMyBTYWx0ZWRfX8i+BJsdH43QX
 rfr4D4nijnt8GBle3L1F/PAJJDOCLX8u4cvEt2M4rH6Rafk6I7dUIKuw3ybAcCQVOiz42lMEuw2
 o87WZ6rSTwaJxSW54Fk9D+/U2U0iKUnACqHpxVXlfscVf/we4inYZKxmCRNpLvAxcTWAG9Tj/43
 bLeOJ+ank1Iw8jBAyxYE1oZ6V/nhHoqGkkJ4osZg8PgIFV4VBDJVWsZx1zDG3ss41dYmj+gKEQW
 Xx/T7UEfKD0ba3PqIk8pADUb471jyUK9ITgCE1crvp0RmH7vgrzUukTzhPkpj5AZvnuiii3yJeF
 9LOUldzg9Tixwmz78qUXpe5AeoYG0fC7nrk2eoNGt+8meh97eoOgmhtALrOCnsOytTlZYlaIzgL
 eHjvg8Cw
X-Proofpoint-ORIG-GUID: P4XDK1LIdwwHY2Yij_ikKZmUPYC1p3-2
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4C784C000A
X-Stat-Signature: r1zrfs75jfb5aoeganunws4aup3x6yr8
X-HE-Tag: 1757945322-731677
X-HE-Meta: U2FsdGVkX18odDMwlKQZm3TUbYxrQnqsF3g+/+RNfi1dNp2xM0CzuDt4iNqpQtbnRtETSlPtz6eXsQfki8pwaACiostkrR7E6OFy2zp3rIfsLK/033Q63t9MTM8JB/qZkezgg9AgP9YY4Q8TuaoWHIUJGHN3d32IDhTATxTqBEMJGOWC3HRiqNe4gvQYwugkDTzO63Uult5At40CMGmoql2qF5/LdMysJCGE90TarQHgAJd6ZnDO+GPhUnj2rse1i3IGlJv6n03NWin0DESJFhDYl4PKc21B9tsdl48BfVak24ZRFXe7BYDyaZ6f+VJBuEfgGWqhpKqPuHv/nTiOJpdVE1sq0mQ2vyg36woqL0GOs/YS+pC4R4xhTz7FRv5chWSeqyu1KRWMrqxlgnvG76yf3fqo2cjTGQ8TrPnUttTfU3ARiBuXe/u4igoeZEQsL0nse8B8HMVE9GSN+c4RlsUNciUIuM7pxtUz0nUwcsZil19fl/flTsnGTuDXZKXQ0Kkkt0QXXK1JjDMxrYgEnRGpfCcrEp4Ax2QC7wmQca01s0/+WkuW0utaU0NRK3gO6O0n1XWJUR1k5tS17wO2u2Rxbc7MSVCf4tFcyCaFL3UcAzDwlbY+P/YWBXzdd3dthss/5XMBnvGwL9HhHEZ09UlCaDfPCLR4ZlH/WhVQMyEkI+pSMgANR6kTKGeBsFgdLKlXOrTMKM83UlEiE+2Qv3Q2xEb47nHpezjC8qjrzGTg1V8+ItN7mM0x56lJZVeqaE8GC7oU8KebVDjUN9D/r3H+bzzvtsPOpsmotQNwDABAWXjIYAhKIxqjxxWIHB8NhtwQOppgd6fuxiIvCcfgdn/tj01BQ7/TKRVWj29xBTGOIXJa5xSe7K1huqpMFIuhVSi3LKZ3VX/aFogLfXz4hLdb1werjl/j75gH2vfzrLLA7tUm/3QVouS2W6eAoL1jxfCu33FmXeW/h/Pi+J1
 GjE4ZfxK
 lHvoJpERH2eFPHP1DG1wuYoqqqotBzdsxGVrqw8jh+B6AQiZi5pLztFXLLVbXWiOzbLyBlq5D6AebZ2qA+QsEfwuIt+fJ5PeIBsTPifSoSeQVXXegB81jNjUclhC9ytmNKXGJbxivs8itJRgoWSZawFAf2NTTALxOrnblCcEZbmzKkO6z3OTA1NN2UTxdZ1gv7okmL8Qcj/S8+MRTS/c4ISlMQwkBivIQ09yONzFBmzYTeWbbQYZ0Hek0V+Bg2pTbmNgoFS7A10iuCEJaG9vpT194K6l88ZPSM6h70TBQBOb5nAO1VuwtVwnqVRswqrt8YDlGH6Wbwy1E6NB5bEQ/Re3CGiBg2zdstJbrpbl9rpOY+Zh8C5+77eO5R39ft8iRBDG444BeEx2OeLcbDe14x/YiYQGiRBf+a+EBNox+KN6KbTAe/D0eMyFWsCVYNt8hRounBy7PoLB1z0XN/60kWF1g/n6oPoPLbKAm9DGUCYat/kNlkkpurfxrrc6ci0nEfFoOE/FN/9Z7Xp1Ng8YI/PB3MjThTyQjZXI+rJA6ULHKpK6FLjZY8O+lYQO54GCB2hojyHQcGrEUPKh8C6wjwcJDbu9oNa68X7u/D6a219rKMILKjRlXCn2UCQ5rnys5U0o5glEp+U3Yy5vBUYCS7bLuB4UU0xEnVL1Js7DC+HqTqDwENfzz7JtO53ZJoIqm+uVsHfzMAW9RhRuqgOXKo+Bp2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 14, 2025 at 10:35:47PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
> lightweight guard regions.
>
> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
> encountering such a range.
>
> MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
> the special marker in __collapse_huge_page_swapin().
>
> hpage_collapse_scan_pmd()
>  `- collapse_huge_page()
>      `- __collapse_huge_page_swapin() -> fails!
>
> khugepaged's behavior is slightly different due to its max_ptes_swap limit
> (default 64). It won't fail as deep, but it will still needlessly scan up
> to 64 swap entries before bailing out.
>
> IMHO, we can and should detect this much earlier ;)

No smileys in commit messages please... :)

>
> This patch adds a check directly inside the PTE scan loop. If a guard
> marker is found, the scan is aborted immediately with a new SCAN_PTE_GUARD
> status, avoiding wasted work.
>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/khugepaged.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e54f99bb0b57..910a6f2ec8a9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -59,6 +59,7 @@ enum scan_result {
>  	SCAN_STORE_FAILED,
>  	SCAN_COPY_MC,
>  	SCAN_PAGE_FILLED,
> +	SCAN_PTE_GUARD,

I wonder if we really need to have it literally called out though, can we just
use:

SCAN_PTE_NON_PRESENT

Instead?

As it is, indeed, non-present :)

>  };
>
>  #define CREATE_TRACE_POINTS
> @@ -1317,6 +1318,16 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  					result = SCAN_PTE_UFFD_WP;
>  					goto out_unmap;
>  				}
> +				/*
> +				 * Guard PTE markers are installed by
> +				 * MADV_GUARD_INSTALL. Any collapse path must
> +				 * not touch them, so abort the scan immediately
> +				 * if one is found.
> +				 */
> +				if (is_guard_pte_marker(pteval)) {
> +					result = SCAN_PTE_GUARD;
> +					goto out_unmap;
> +				}
>  				continue;
>  			} else {
>  				result = SCAN_EXCEED_SWAP_PTE;
> @@ -2860,6 +2871,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  		case SCAN_PAGE_COMPOUND:
>  		case SCAN_PAGE_LRU:
>  		case SCAN_DEL_PAGE_LRU:
> +		case SCAN_PTE_GUARD:
>  			last_fail = result;
>  			break;
>  		default:
> --
> 2.49.0
>

Cheers, Lorenzo

