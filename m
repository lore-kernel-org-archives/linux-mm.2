Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C26CF5545D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 05:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93AD36B0005; Wed, 25 Feb 2026 00:25:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB786B0088; Wed, 25 Feb 2026 00:25:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B61F6B008C; Wed, 25 Feb 2026 00:25:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 652F76B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:25:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A9031A0472
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 05:25:37 +0000 (UTC)
X-FDA: 84481841514.12.8E23B4A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 940AEA000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 05:25:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rk37bSA2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Qw/tvbGD";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771997133; a=rsa-sha256;
	cv=pass;
	b=MmqYQFJuBSEJfbysQinMGWj0rS2iyoNFCxTdxu1MPk7oe9pxLq2CDJGgahxVy1FF8CbzW7
	A5RUShc2GHdzCJg/c3m96HYo+DSAqshBEgGBTL5NjX2uuc4wSe7EhQpTC9HT3PYLiNMKnf
	C3bZyc0q1HJlmgQo1uyoM7iWWVHuGrg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rk37bSA2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Qw/tvbGD";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771997133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BRlxSGvQnupZPTEDtMMd1jlmK/+8lk/YNYOBKjaJiXk=;
	b=HhsuktUmlud7/dGDA7DXaeIMJoczLLz1OAUAcU89Ck2sFbweS3Am+mDuIsySxl+4A+aY9S
	SxofnjagME5DkiEcWVHXqK5K3Esz0edLOW5YZeanyboyRkUJ0K7DvX9L12rE9oiXVGxdkH
	8u2jSzmpiZsHp59RYgUvW7UZR2Q7L3Q=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OItv423927989;
	Wed, 25 Feb 2026 05:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BRlxSGvQnupZPTEDtM
	Md1jlmK/+8lk/YNYOBKjaJiXk=; b=Rk37bSA2QImCVFj7dqiFjynVDpYFt9Ei7v
	dpHvMBagK5t5QM68fZdW/aVACOGepE7BjlHUOdCrYWrQBPeAQsqq2091dx/VtoTE
	wbiDjyd/uasZF8Aa1dUZcSAYeLdrXBaqwSEh6T5KEXF5554kMijgA3ylWdqn1ELK
	ERQCrskIGVFKcC806fA7JRANTMU33YraPETYqIcDjeWhlMZkNZD7RXXtkIB6/ZsG
	qL4DdabzYG8JSi2EF9g24LiMOPVdjGKLEKnpza0fG5LMtqO2FTmzbn3lb7dANmGO
	3sa4LUa9lAYC7QsrzhFSItLvWz/6wuFbZx0/QNEoQmXM1TokvNMw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qdffu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 05:25:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61P5Iibb027868;
	Wed, 25 Feb 2026 05:25:03 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012013.outbound.protection.outlook.com [40.107.209.13])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fnktm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 05:25:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RD4q5fkcuq7xW9Xrem2Bjkdq3mQGYag2XW5n3OqdyRhrdgAdfO/X0p/c8GEz3zCJUYUxs4EHjNCYDhF20KUA0VL8VgpekTjSua6zsXjnnItrakBBHakpYJiVIIgSgGshsCmKi5dCZZ2hHwrHZJ/qrGFcTHkJnf2+7INNSD5JuXNIqns46Ucdadmc+iBEwxP6EnWTnu7c/k0GDBZNF8udLUGUHj9MP5KUnNo/g2sMxNLOQmAbHYzpKYJwhXJ7FVs65hIevIdAauD2aD0jwN50OfUGBAVREce9c1I7ZZcBXWRu0yZNCiThhaIA2lVEM21o0R9x8F0ZyiD+p5zFVY1e8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BRlxSGvQnupZPTEDtMMd1jlmK/+8lk/YNYOBKjaJiXk=;
 b=kMB8caWTxGeqY2GQu4C6is3gF7CK+ngEDpROyT3zPzKy6gjOEXBrKzHdYTcoS0b7EiCxk7WSV7U7Qt6XlElAh3Wkb0EuBsYlA+gclyNfV5Af1pIbkCXLhEORqjZ/0dtOXB8AVueAngq/gaydPQuIUynMKCqTvWOODQDsJ+c5At21CT+2ZSVicD0hPTnlGRW3GvQkJ2ciqW/SQ6++ybVVPuZTPKJo/D8Qqt5TtZ6789ey06qAEq33E14Dv10ObHScM9D68X0mFWUY6Fk5AlKvDh2J73MBPhc/5IaCUd2NCTufaz9nGkC/r2DJYfQfQ1aZFf5f8k5gG3Lgyv8WNWorUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRlxSGvQnupZPTEDtMMd1jlmK/+8lk/YNYOBKjaJiXk=;
 b=Qw/tvbGDA3FHgLLxBKp6ZbJeQbgmwvhu1Prh2MMxw+nXUZaCOcOMjskWRDfI2bmyNHR1Cf7OMzBu/mGn475h5in6w/1nwJ9T0bFQ9nNMgiW9astdC246HNiFX45EGN1zeaSMvr7DCqSfY9HX2LhRpzdmyCiclhH0QVRcMr7Feao=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA6PR10MB997560.namprd10.prod.outlook.com (2603:10b6:208:5e0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 05:24:59 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 05:24:58 +0000
Date: Wed, 25 Feb 2026 14:24:51 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Ming Lei <ming.lei@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, Hao Li <hao.li@linux.dev>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <aZ6Ho9YXzLzVOZUz@hyeyoo>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
X-ClientProxiedBy: SEWP216CA0121.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA6PR10MB997560:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a2fccc1-ae12-4dbd-e237-08de742e37d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nCO4dba6gdAqWx8vf3QZHBMH7QU77rGOXOM4IWEMi9OvcuElES8gfm45ETqq?=
 =?us-ascii?Q?87DBftp2AxLba3kv8NcO3mof9XwLTN0DvcVgzXD1VV7ZumP2BqwHokMxXael?=
 =?us-ascii?Q?nQuEL5w9izImo6SOnVIBSo0YXhajkoJiU2AvxueQ74weM7HWWHGIzAD3RslC?=
 =?us-ascii?Q?b14+J02EJ+WhjecMSAGCnq93RturFfZYs1hqMnBH+OXc0vHrxujB6AL8iDFW?=
 =?us-ascii?Q?i2Qk51C3lYa/k/Tt4Akjss6EfXvbj14goOCr8xv7/YMUcHR/cQsILkOQuzVk?=
 =?us-ascii?Q?P+6bzGwamDWR03X3HK8L3QEJzOIcRfGpMSX6NSPNk+0RRqxhSOGM9YqHx0jY?=
 =?us-ascii?Q?LqhE8vyYWMwLsONLrfb0xXarO0vYFpaE0eSmqRIDmFqVXvP4oP9ODgEjZCo3?=
 =?us-ascii?Q?IMr2W4rS0c5v+FpH0p2PvAdGXNpv6BoRl9xshSue8PwvIW92AXejqopWLUJv?=
 =?us-ascii?Q?bysVQOaJo0aSJG06k7LiY1YOmiywXMfrbAW4mmvCO5weRmPvjdOed1MWblyt?=
 =?us-ascii?Q?0O8Am7ir3s4iMeO7QB3qcKeyF6MtJeoKYMb+8iFcDfxWAMbxhlCeWe6uc37A?=
 =?us-ascii?Q?h6/8YNT53bmr0RE38FkHWGpS54SY6QZ0ovZU+hwq0smcHGvAFvux5KX7ISYP?=
 =?us-ascii?Q?FslkZQdNIiyiwUZyfe1GoXh+D2QuXSW0MilU8KHDqNGHWcOccl9Lja3rbLMZ?=
 =?us-ascii?Q?oZM3/98uX3RJ0NIL+fgxbsxL7G3dXSNZoAF8rX1TObTo76mGcGck1WGZjIgW?=
 =?us-ascii?Q?OyNkGWyrjvtTUIA+nvDURoffw4r3Pznw754hXyBUKzUK+ZF2WmcUQliMFvU9?=
 =?us-ascii?Q?Z81fnUxx88wxj1j0w4cwu00jHG0PctgvXvO9gYOb5EUXrie/e11IUp4Fm7/1?=
 =?us-ascii?Q?oX5t/9nRcrHbLzEILNG7O7GXfrmP4u1+61pyXiy5aFlML7W/MyX8L2XdpB28?=
 =?us-ascii?Q?dinfWxQabjU80I8991JXgsJv6GwhEgUzsmEGKszpcDstci5ZLiMPEdkVhsnI?=
 =?us-ascii?Q?e4mGFvHUGpIYtaIM73cJoN16McbgtA7QDYivPvzgaf0aRZ1O7TdO8cCtuYpO?=
 =?us-ascii?Q?cT2OXpdnnJIFZZNY02OX4O6u7LdvSr04Gfg3dnW1uwYnNCff58hQWt3p3xyV?=
 =?us-ascii?Q?8oEotIQbRdJKrZxr71L+v5l5/p3I28ZUJEH9GDvQWkqb6DkvX0RjMsH/xN53?=
 =?us-ascii?Q?jV4kAXOiIex59gAbOMBeR5aTI49v0DnDZMgZwGJjRj3l0a5sD+Dz5IWWr2ED?=
 =?us-ascii?Q?ngzQuPo6NxYTzopNYgP7BBVRTGwIS3XvN0cC6uIAc5cgCjeWZ+QjJb5WBQOa?=
 =?us-ascii?Q?9CACFnpJT1kaINWge4F5P7f5H2Cy16Ig8HIiEGjoLozmdKWTyOe9DJzNMgWs?=
 =?us-ascii?Q?uLYCXgzo2SINvrvKHc1Hw/8oDw0bS3lsVpabHaihxDTvpkHehgu4PvZ4WU0h?=
 =?us-ascii?Q?YfpIblp4OHB6twUH/QKdyv/qoNcqQmPNK0Urrp+ZSw4knCd4Wdg0Xuoi1qTD?=
 =?us-ascii?Q?VAeLg06pjmkv8ediXUBq7wZdEowFL7j5un+sC3ExnQuk9rMHLkoFE1mUkK+q?=
 =?us-ascii?Q?A+cLUe3v7xqZ2Tt1gYw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K+X8I7Oj4mTfk4DSD1+lf0VcNoeiWqwiJH1MgRHNAWSkYUT6UqVXowUsz7V1?=
 =?us-ascii?Q?DhJCepBpp5FqdIMxS+hwfZspLY94LVgZPMZXHXmmc6xJF0fqMxzPpBRU8trm?=
 =?us-ascii?Q?GsLUJQXccwiyPZhK/afbWpQq5oTdCUJxgrbilbsboU2/U1B5/7X5VBq644cg?=
 =?us-ascii?Q?dGex5ibKgCUR85BCj7xFVBcOwWXk1700KXd4IDmQO+7EOLdFCMblmaE9vUCx?=
 =?us-ascii?Q?Stx/E6mafXfP4Vzaznif3PUaHg5l+Q4kTKPFeFf9ryL7GZwZ1NN423jyEAJD?=
 =?us-ascii?Q?fmjxVXCTjfP5Mu2D68DZdHjw9vNIVs5ae7aadBPBWL1ww3liZTUElBcRYOoK?=
 =?us-ascii?Q?Wk20ukfvi6FEHVHpiDEo8IzI/Q+QnN4HfBMyA0154jhiuwRglSdZZlHaHgf1?=
 =?us-ascii?Q?ZuZuRX9Z63G3vNaWQWnC22Vr2mvu4EsqJ3F3E4oyLzZ8vlZKkUjXEL/5xXdy?=
 =?us-ascii?Q?ciP6/7LjH/na3mTQTGzgGsDHFt+XDHgpQPagND0I18XoRZhiUfDHk+1KpHFB?=
 =?us-ascii?Q?UxKZUnIXKSRsFbPbCRJxLd/pEH6A8ClfGlDEpQJJfBatqYSgZG9RUjK/LlAp?=
 =?us-ascii?Q?8W6jnHkVaXBeT5205g4FSBX4fzcBzbL7xrqqBjg1H5oy4WZvRV29uJGsCeJb?=
 =?us-ascii?Q?cN8I0ncYA0Qny/z84lwnSx+DHD+v4kB4d49XufluxFNZb5uhzKAKmlwNgdYO?=
 =?us-ascii?Q?zNq0v+rSmHA1NZCKMVa631j1LYC0xsLudL28UjxV71Ddi7xQHZzc8Q2aSYiM?=
 =?us-ascii?Q?ITeFJIMCqX9JiGtrvcME82l7oIyf2gQjE44mSRcQJ8b15VAT8Y1LFQT6Frzr?=
 =?us-ascii?Q?iQbhJIvSGwCqRVYR0R0fYwHJv/jyzbFheoewc980hpJSPsHJ9Ktn3bWw2VDE?=
 =?us-ascii?Q?uSwoUET05rHZ3iBQkKuat82lSK2zRZ4hrVaY1jrjgHXsFKfv5nDhGgCI4sCW?=
 =?us-ascii?Q?C/EkZr84bJZ3FD40ZSIcfjXLATgbbQe3bz7EKXMF1+cyJnL+L15D9Srxj6Ix?=
 =?us-ascii?Q?MhG7sSlu4BF/ATVeEJcLmlIAecSEHfNTppy1day6hE7qMmQZ1n9rDqyTG2gv?=
 =?us-ascii?Q?2cPl0XMospf6LsdlxGJbmRvd1Mf4y7gylACwVHxsE1YxPhHQB5GCfKjRIB5r?=
 =?us-ascii?Q?Ks44U9eqIFaXNmEFIVrNy0R3d5EL5VH/eb+8DwlM+Gu6K6l+5TDDEsq3JlN6?=
 =?us-ascii?Q?mk0tzW6iPqw0S+S5r0Fs5QwyclgtO5vCd/2u3ioDlDY+IgeQiCZMa6XzX9lv?=
 =?us-ascii?Q?+OcUK2JTgfnGGd+vEITm2nNT4yhLEdk2TAGQtk0o1I2nCx1knbQD+jCvRUBE?=
 =?us-ascii?Q?rtb/CrDmcB631v48r4YFByiWoy1bO0y3NAjz9jtBlzc8u75mH0mufROMa4Nn?=
 =?us-ascii?Q?nt3rOMjNzci66sVsbq22o2WKccjbg1dzFdiUjl2TpKy2HuVAWe/JiLbTT5Bx?=
 =?us-ascii?Q?9FDVk0t9Uovo+AIMFWOG51JmL5ObJe6jUmf6OUsltMzZcSVSKesjs1Bc5sY6?=
 =?us-ascii?Q?HhPBzM/89PYU5M+uT/kRzJ75jSObJ/XuAvuR1C8XnK82E62HywS8cGZMdpmP?=
 =?us-ascii?Q?0paP7QDbZY3CigxNnL4W/qh4GiIS9APUCnR/QU7Rlg2DRC36ZGQKHh+vn8hB?=
 =?us-ascii?Q?wwVzRuPZK0XQUyj2ji2Lk/j4OtRJ8pvrG9ZJv8kAnebEQODoq7sKwNptmtJb?=
 =?us-ascii?Q?nhFTPZINDz2i1/09IVSNd0kvGnyqnsydVl4udr9fxxAZTF8a9gX/YSi2Yf9f?=
 =?us-ascii?Q?TKG5gGF8SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	76TEQ9Q9UOdBtzeGHLQYx/5cjzB0GmkxEmynNBqlFrLp6AEMlPN1kjx9c1O1wpdEJh6ix9eYpyVC7Kj9dhpSPAzBcPUtc03O7jpgwAcPDQuGpUa1Bwe6Wo6EVfnhki6Ve//X4Cqfi1EHQSDpTpaCnrjqNm66LLxBqfxDQqkTIrkfq+6kCNJaJFG/FF/b/EoxHFFlSzGkv2jPbBCzmkL3J+cNjXLA1UA+NV+H24u0Nvu9F5r6uJ4JAbZajN0OqGNBTx4rv+SgPgFsHyZX+576sYafnD2YRUeS/7RyYtlVa4BbW5m9xo1QQR+k5jes0UOLfTSSZeeqeTmJNHGYalPfRJDxu+X7u0ejCVsxEwaKKC89UjXWQc9Avk8XZDMPCvBVhB/BJH+xykQpQpuD+0A79JhLxYwZlc+HVsyIBM6BtY9aQwSzhYTIisoMcCj2Z2zdCYKtwGlNa8YRhpZ5Gd2IF5UhbwMzzSX6CavO+FNm2eoKqc52JdX4kUXEyQbCtWQ4c2YaQlpa82UJBkDPFhDvVxUsixOVkNyKKsKoXzMnWtQkkAUiYg3mubXNa9tuvd3iFm6U/7E7O2wXPqo281c9a3TJnRUY5Vhbcv18qi6VMFo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a2fccc1-ae12-4dbd-e237-08de742e37d9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 05:24:58.8894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GrVJOUzLJfIBPUQpTmmxs6uF6j7BvRrTPl3F5yIrHn9ZgYXKoajQWmO4kewjiE/5GRGUY/oqy5bqpozvpzoKqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA6PR10MB997560
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250050
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDA1MCBTYWx0ZWRfXz0eW25c9xMzG
 Kvf+Zdcuhpk7enZX8x5R66QIOIjYqXjLk5QYVC30Q1ET0CY6wwty0s2qYy0ME2SS8sMdhkR9eCP
 fsUwTxhpiRHuGy2g2LRwUat2P0cEoSoz/iGaB6RY4YAUTNqWRBb3V9S/CihLowGt9AYzHCY9OHp
 YwJcWGx2hO7Ez/elglSZ8B8Ystl1y9FiOUVHxnZJBCnLGcG1KyTNPxdq5r40OrGUu/bw8Fq4eLP
 NoM/oXsMvoW6BHNehs6JrPKX8tZgUX9tvsF2OUYWZyP7y3zek5lFndbgyqyZWo7PZbCIw352O+j
 Q7subp02yI3qKz2fwXL88h/dAhciWS4nJ+/X+i/+q3K+KC8oyCMybTuVO2aShyhVoGMJDIe1CSZ
 Kj8yOG30NuP06H4YObfY+5NjxDB4HrUHqiO345XCNAhuuv37jKmVqD8tpakwpN+H3KK5cYEMLRC
 Ui+TncaGCyRt6XGrrW1Jn0vs8yOuBYAsJP4P8juQ=
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699e87b0 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=HLplz3OVK-q_4qNNnhoA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12262
X-Proofpoint-ORIG-GUID: vZ9YqplqeRH2-_rioZnaH2sLuAXJG5lq
X-Proofpoint-GUID: vZ9YqplqeRH2-_rioZnaH2sLuAXJG5lq
X-Stat-Signature: 9wn9ny7arsgm5qxw3f1r55gjyqzwexqi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 940AEA000B
X-HE-Tag: 1771997133-263536
X-HE-Meta: U2FsdGVkX198/mib7fRSgo9B4ZjOJD/+NDNd0Bi6ZxSXiixOmZOIj5VzCykyatTsdnajU8grocfDRa2P+MYe7WhL8SPpSIZDydjXf1LbjYO5cAMrQ48UuMGk+rpfNfihYknLKUwj6ZX/h5YoO7dWZt0jkeb6RsYHrgEtSZ1FbLSsZDWeJFHG0qU6FrCP90SG7XTRpXZ6dK6odQ3CNbkW2UCPOXpE93WdyyMEPsKljhHaao7PlknKFaElQo8/m6i21jHIlDbT+DxPkNgVlrqIh0ukio+/iGwUMjcrm5LhE5AlvvHNYvKCCa2NwxI2R39g14bSQ781s9elQeX1vZciaQvSGa6Ac23W0JAL2NHGuho+Q6zmQm+mOtNF89OxqoUaltlzKC35iwTFMAB8/4ii9Q1Uw2aBum/t9xy3FKNuLoZD3Y+PP6RTcqo/MFqId4cUn3lmHb5Fl0SQj+NeoifYUF89uB6pIdo49bk3gE9vMQ75KpFottD/3ZoOpAbjeNZQH3meiiBuaHuvaLetM2VTyBYPf4Z2HkN8lXKkc7FLvUNlYMOaWbNNTZ0P7jauNxPoAQFg7bIiG8+LvUqZgFVG94cKEMJHby9k4mu1d5ldH6AHAN4MS4sO9RZ3wW78OFJK4Xowlta4Vjcp4wxhzDmtlqlbwY4Zaf8EljzWC4raYlJw6ne62vsU6rsm3MYwvmbQIPjpIK1JZ0SXZwO0dIDtLA576FH02PI6Kzol8HdOEme5vsPtaZ0QwTtNgcp2eZCg8SrFZmgiolIWJJW0oNnXUsnu2R14fohqeSC16eb/Bpkg8OoJ7qHkXQ39axGAeXiJ8LQfVMsgoisLaL1a1nBU2NuYjxpW62FELdHts7p1+6uQ3PXO05CcKu6nb4s5cdc6cVnYIMfDOBQXJ+5i6KaP28ha7OZIeqpkMTF3NT6WKJTuGBlc6VLZLSECd34yjpU9NRadZPiXIiNuS+ukzlm
 m+I4e6Wf
 jUyC5wZO2CFkUEDazWDtMMQOguQHUl4idks0CJOnKEsdDXU3toQJH5QfzkBPpNHNRLtUywhZxAtqVqxxaFrdwf4PyeOncD9lER9nctIoL/0AmhgPXU+w0OJWPQN/yKPmQLJ/xQepMmlDKjpxVp81xPF+hmWyGrnUFwuk91dRHkXhq5/ujhMH6lZxxogNTAaRimpfEAmWK4q/IH/PV/eesZWy+DK8IWTILJIYYjR1L1DWyLzlVIDtT1hIQBrnIM72BPO7VeUWs3XHGj38bJWLDZycVT0/f6eWlanUSPTvuWxKramUNrQji86g9EJs8pzTNZpKlv4f6klmy8tIgmN9n17avCEOjsramMoYmi3zRBIdPy1gKfpX3yMPb/lP+RrEC4Xr9MMJu72Ny/YHpclHxKWh5XepqtVb70RTsk4+A5OB5S7mzxsKngXMP/Hdv4jFY1qicQJI5aLkV9Oak1VKhLnvVK92U+/WXFvI6ENBHqGjy/gpv9MUVtNIj3SSM6F1ubz/JxZWKW1V8LADDAGIC1qXldqDvqBBxjtt8Dzr+eHcBnb/xoT/6Y1MPm7xnJ7jYWdLq5+lF5daMzCNNjennHAtGL2asqI6vULA+wMtgssxZQD0GilK94/xpeIEd9BvRID2XlN0b71+k1456QiywExd95OKD43nIUC2i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 09:27:40PM +0100, Vlastimil Babka wrote:
> On 2/24/26 3:52 AM, Ming Lei wrote:
> > Hello Vlastimil and MM guys,
> > 
> > The SLUB "sheaves" series merged via 815c8e35511d ("Merge branch
> > 'slab/for-7.0/sheaves' into slab/for-next") introduces a severe
> > performance regression for workloads with persistent cross-CPU
> > alloc/free patterns. ublk null target benchmark IOPS drops
> > significantly compared to v6.19: from ~36M IOPS to ~13M IOPS (~64%
> > drop).
> > 
> > Bisecting within the sheaves series is blocked by a kernel panic at
> > 17c38c88294d ("slab: remove cpu (partial) slabs usage from allocation
> > paths"), so the exact first bad commit could not be identified.
> > 
> > Reproducer
> > ==========
> > 
> > Hardware: NUMA machine with >= 32 CPUs
> > Kernel:   v7.0-rc (with slab/for-7.0/sheaves merged)
> > 
> >     # build kublk selftest
> >     make -C tools/testing/selftests/ublk/
> > 
> >     # create ublk null target device with 16 queues
> >     tools/testing/selftests/ublk/kublk add -t null -q 16
> > 
> >     # run fio/t/io_uring benchmark: 16 jobs, 20 seconds, non-polled
> >     taskset -c 0-31 fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
> > 
> >     # cleanup
> >     tools/testing/selftests/ublk/kublk del -n 0
> > 
> > Good: v6.19 (and 41f1a08645ab, the mainline parent of the slab merge)
> > Bad:  815c8e35511d (Merge branch 'slab/for-7.0/sheaves' into slab/for-next)
> > 
> > perf profile (bad kernel)
> > =========================
> > 
> > ~47% of CPU time is spent in bio allocation hitting the SLUB slow path,
> > with massive spinlock contention on the node partial list lock:
> > 
> > +   47.65%     1.21%  io_uring  [k] bio_alloc_bioset
> > -   44.87%     0.45%  io_uring  [k] kmem_cache_alloc_noprof
> >    - 44.41% kmem_cache_alloc_noprof
> >       - 43.89% ___slab_alloc
> >          + 41.16% get_from_any_partial
> 
> So this function is not used in the sheaf refill path, but in the
> fallback slowpath when alloc_from_pcs() fastpath fails.

Good point.

> >            0.91% get_from_partial_node
> >          + 0.87% alloc_from_new_slab
> >          + 0.65% allocate_slab
> > -   44.70%     0.21%  io_uring  [k] mempool_alloc_noprof
> >    - 44.49% mempool_alloc_noprof
> >       - 44.43% kmem_cache_alloc_noprof
> 
> And I'd guess alloc_from_pcs() fails because in
> __pcs_replace_empty_main() we have gfpflags_allow_blocking() false,
> because mempool_alloc_noprof() tries the first attempt without
> __GFP_DIRECT_RECLAIM. So that will succeed, but we end up relying on the
> slowpath all the time and performance will drop.

That's very good point. I was missing that aspect.

> It made sense to me not to refill sheaves when we can't reclaim, but I
> didn't anticipate this interaction with mempools.

Me neither :)

> We could change them but there might be others using a similar pattern.

Probably, yes.

> Maybe it would be for the best to just drop that heuristic from
> __pcs_replace_empty_main()

Sounds fair.

> (but carefully as some deadlock avoidance depends on it, we might need
> to e.g. replace it with gfpflags_allow_spinning()). I'll send a patch
> tomorrow to test this theory, unless someone beats me to it (feel free to).

I think your point is valid. Let's give it a try.

> Until then IMHO we can dismiss the AI explanation and also the
> insufficient sheaf capacity theories.

Yeah :) let's first see how it performs after addressing your point.

-- 
Cheers,
Harry / Hyeonggon

