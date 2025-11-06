Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD7FCCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 03:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6E98E0002; Wed,  5 Nov 2025 22:42:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8972F8E000C; Wed,  5 Nov 2025 22:42:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6743B8E0002; Wed,  5 Nov 2025 22:42:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50C2D8E000C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 22:42:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A5E01A0580
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:42:04 +0000 (UTC)
X-FDA: 84078783768.01.57E0F9F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id B96961C0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:42:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OwVg5LP5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rtbnRJrj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762400520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfVXxjC0iPAyfGeKdNeO1luHARWUt5DVSsio092WZbM=;
	b=Sz91VcMNOPn93ASd0iV6ehvKZhTmX2H/QNr3iCa8IxPwsIXDGz3a/uI8I5ARJ4OFXI74yv
	Rq7T2DUpYFuOBHABzxITNyq5N3g0LEiX0Vfb7J33tqVCTfr4nyKkEtc3l3/I1f4/RZfBhc
	QjBHuWR5xVTZSDwF62lu77Vhhuf4Ox4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OwVg5LP5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rtbnRJrj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762400520; a=rsa-sha256;
	cv=pass;
	b=r5m+MH9bzjjGV6uj181X1G2D+dD9438UCebxhAZW9TuTus5/JfaV9HuGe2A9WJ6c5ppyQ6
	a/9GJ0UTs5P5fsU7J/CuG9CibGs864SB+t1cf8Qm8Q1Vg1klXckMFzTWTl9Juen4tvzYw/
	Oq4/UaZvw13b01wtzSi7RttKxRE7/p8=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A61DP7V010292;
	Thu, 6 Nov 2025 03:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=OfVXxjC0iPAyfGeKdN
	eO1luHARWUt5DVSsio092WZbM=; b=OwVg5LP5TgGuEkx98Qp6MdrxNhnVimaJCi
	XWREglcQu/jtFq0e5S4mpQD9WYvRrnBSC/Zz79ips34QVsrS2WXUDYP3QSw61QEk
	fPuyqOx1N6IofPBEwLaIiu1triN4vg4jeQ1ijnvOalAQc9N3aZgOtINHNHUeujHf
	DzUQ+pyfjrWmjg7vDSgfwMsXBhS61DYs9WBXaIPV50bOyI3ZMoDVcUkIXRAPGEw2
	AODaSdYNiET4008EeLvrHjbmwHR8JwP6l8pKdDblZ2DIWtIJgqU8t+vIlUpb7vHF
	lxy5l/MGB72h09YzV7GbjyBAxgv5xAVGwFx9O+PzTPgl75h5HsWA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8b5ys0mw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 03:41:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A60uuaG010852;
	Thu, 6 Nov 2025 03:41:55 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010065.outbound.protection.outlook.com [52.101.56.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nbv4fa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 03:41:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DEQxirMP4++RE1j9fFhlshrA7qJcYa9J2h7BHqPL8eULIyKqQIK0s8P9dsLWheTD56c0/INIWqxaSX7k8VRDzlUgPQZTgJD0fJlvsZ/BeYXvr8POQ0XrYl5kbiYtQVrNPhz85IAapFVylgpFCL+aTpx3tMtjy0MuF2wy6sRLVJo9NlFQMEEYrFR1sRbBZOlindks/FZovnnbny4isOFdO3HaAwesuoZ28yh9Mw32JAoaBlSQT2gmp35/eWpzn+gsW3pisbG4U4Qkz449eeazsR6OJQh6NU9t01jnmQzercIleNOSU7pttuyfctrvSfaJYEp9OzfdIOhtyauWAETS4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OfVXxjC0iPAyfGeKdNeO1luHARWUt5DVSsio092WZbM=;
 b=cLZdgmERTpoGyks/JPm/TZyvUWGdZrpzHL/heFLYv4XqKbq0AW3IFIYlrr19N6qdcIiPHUHPANEA9Pa+TfaDSY9ujwqr7jDB/+YBhaJPE7Px9h5ZqK8x1YkYX7JBthNRJqDjWe3EBSeYpdm4y9wagONiaPTABFpjfgE7/q9Dum0tLznIDUt5Ox3Rgz9H5jRRrTuF9jCqKcbVkQdtM2MFBoKtwNasu9tNfT2fd+bkwZD1GYu7KoDJGUzOUwlGWhiXQrPcoCeqJcucTjz82rNyP17P2MqF4TjX85LY394eg8ajRhgIUCT8nGaYdQGZlw1n/3iHOJWpPQDFDcbz1NX3Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OfVXxjC0iPAyfGeKdNeO1luHARWUt5DVSsio092WZbM=;
 b=rtbnRJrjOHD6gnth87P/QVZlpwyPwV/tD2IhIAcumGVqY7sZS25wY+QRDSuXXfk0cTWbS10fCMPcGCeXQ9ORJlhu52qVR4oYXKQF7+6vJXcYTsKKXw8KATgJiTgQKfTd+zvHNu1wKiqj0WyrRL0Jka5ye4g/TVx1uvLhnG1wORg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB6657.namprd10.prod.outlook.com (2603:10b6:930:55::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 03:41:51 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9298.007; Thu, 6 Nov 2025
 03:41:51 +0000
Date: Thu, 6 Nov 2025 12:41:43 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: prevent infinite loop in kmalloc_nolock() with
 debugging
Message-ID: <aQwY90CJJECSSFtW@harry>
References: <20251103-fix-nolock-loop-v1-1-6e2b3e82b9da@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103-fix-nolock-loop-v1-1-6e2b3e82b9da@suse.cz>
X-ClientProxiedBy: SEWP216CA0148.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2be::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB6657:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bd003ce-c3d6-4742-cbc8-08de1ce66bbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CmokcPSYDs2wq3BWJvpJHQXR1+sAsV/iP79Mt2OVPQoZo2OCQvIGIUIGpmHJ?=
 =?us-ascii?Q?rZ3QpsjK3lAJp7x0qZPFB4V4ZcVwEO/yCjSOf3NoEEtlEVAKeDux3iEFrPvT?=
 =?us-ascii?Q?Z4AcnvB2Ha/7VflGGTPCLkd+kCXvxu3c3fhLelmgURgNu/VD/DwvTQP+TuYs?=
 =?us-ascii?Q?ovJjgptJ7Oi0VdT7q2DpggyLqHzZK9GysvdIMtJAGxx/m/DNlF/g+jezwHw0?=
 =?us-ascii?Q?x8Q6mpZOWX0FRQ5H9JLNKpPTm0cDjeoFpsx0OfGv3I00/uOzDEQx415ltQSW?=
 =?us-ascii?Q?tDe4wnskH3Oizxx4SXmmv+XxYWG2BJaPiKbB3GLprWEveBwbFppFdjpyMpeP?=
 =?us-ascii?Q?yRtq7hdhkUsbZcXST2WvHpWlustJk0Rdq+kxkBAuspBUmKXH/xYhFMRF/Vvq?=
 =?us-ascii?Q?SW3mzYEb3ME5+IpBVBpD0MqZf+jM+06BIhbLTjc9/+cOaMm8ju1ZcFYdFdOW?=
 =?us-ascii?Q?Cnz6EkLammoFDK6o7zTZgvsiJVKnTcmB6GegIUrJYCuAGv5UDkmQ/8rJTeEc?=
 =?us-ascii?Q?pJ7KbfbiASj1zX6dI/PQddBnU6wIDAo86fwC4T01bCje4dH9ciKrJYTY/ST2?=
 =?us-ascii?Q?4yd6B1ss5qGhSoXakwmPo1KcqjpAZqRUSR0oazURWyxQHN84o8VshHmwYzBo?=
 =?us-ascii?Q?n7mqvFpVZSH67i5kWl+9aLGn/V9xPLakXK8q+tswkG4SyXI0PKnoWWMUCACH?=
 =?us-ascii?Q?kI+ScMpmntRbUvGJtaViCWR1G7OgLgaXbAiXtpuyjZsK+QbzrLscyBrYj4qf?=
 =?us-ascii?Q?VzJSVZT6ayrLgo1FDJUMRswbmwesoQmSQpkm+utecc/YrJrKBFSDaKhkQSqC?=
 =?us-ascii?Q?YBNRNvzT7jeqwWx1KbDMcOota834TPcQXlis4KrkK4AYndcFv+P8Jg/i9+5R?=
 =?us-ascii?Q?zzbh72p28naMon4OIQeioebGPWkKsrwnkpXGhGdZdrE6pnMeuIDbb1ZHie0Z?=
 =?us-ascii?Q?COTjOw5aI0wfxk6Fdps9dwyJvhvtw6qSiBVw1mbSwhHSbi1GbGm5sCzt7ttZ?=
 =?us-ascii?Q?YoKWG61hx0lOAeP2Gn5D61rPaEpCout80JXajg4QNNC5gc3fj4L4zXprWmas?=
 =?us-ascii?Q?fiunjH3SmraN5MyrQDxp1y7bdvXnyXSv/2YbSSHyN59c83Sto0/iehoC8pBt?=
 =?us-ascii?Q?LaXj/QYCt9uja488xMxKVIANyLdn/s8RVxUAWwwaK9545XNAkDEbxILzmuko?=
 =?us-ascii?Q?KPfOMaGyPufy6mRJ9uoKO/NuRfvS2sKvfnd9N2rB2e0m/OYpjW+Hp6bOCnlS?=
 =?us-ascii?Q?oEiN9XmfT66wn9wa+PvcsbrzAvswGpPokb3uIWJrK6oDrFp10lbYGwyhL4Kn?=
 =?us-ascii?Q?j7PMunzRJ4KBUNYZNawQkJFlkg/hKgdK3eLDyHLSU1204MhKwmZJz/YE1HR5?=
 =?us-ascii?Q?213BHboVUj3if0fqv7N1bE1R5Z2OWlFjsgGi+6eBXyEnRknZx1DyvFYu/0J9?=
 =?us-ascii?Q?o3i+0IS/MRX5vMHvGwhjqfVTfWPbtlXc/vvgdkutYNid5TNoqpE2lw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S/iG+zGz2JYBNItUgt/tMQ2omtKWZLihA+xLt/zuK+nwc06cmCIj3PofEl/X?=
 =?us-ascii?Q?UBwzyDAEkgUgeCpN0V3ZaMSdP6yG8ZnLKqPmuro2f5EIFvVmNwUqXSM96qGt?=
 =?us-ascii?Q?QJp493bOTETiELImq/i0q2AuXkJoH+Hhxrg5efu65khP71MyqjneBy6ujOng?=
 =?us-ascii?Q?ZdxzInOqmJjbpbUFK8OsutSmgAhne4GnffYVg3ET6lAyJTxOgn5ylIoLpVbR?=
 =?us-ascii?Q?rymuPenS84szb2W97/xDPa3siIRyNjQeruFsSpzCn2FsX0indUdLIFnswrJQ?=
 =?us-ascii?Q?6ojAUoDCWB0wyxivvRwMIGFpJaJhnRsViQBEugLV+94ixkhisxBoJ5klyc7O?=
 =?us-ascii?Q?vF9lF+SrXmtnYzZBfyx+JicmBPALyzn/IJZaoyTFNFEE14uJJYNJ4o1AKM24?=
 =?us-ascii?Q?kOOuAhbv3ryMcnBQu1NvcsKglkNpXwzd3bc3cDSN6Fns4V/0mTHWG3rxtJhR?=
 =?us-ascii?Q?bO5Pm28kqiayxF9mGQbGAhqOrlRRWjwjMa81zFNoA/TqRxtqdbxeZxSE1kTS?=
 =?us-ascii?Q?F/FFEanuwSS0VUEvnnO4yrpmh/MUzzoRs0bhgIAqWa2H163gU3pMRWM5rR9P?=
 =?us-ascii?Q?lg5Y2PPlabjso9WywLW8aZ80K9F5X/0GQgxZ384Ql3LjOSO8XZaO5FBJdxCU?=
 =?us-ascii?Q?kMx0daxKXUoVasOyY7Wg7GQsHxPwRmP5K0HUD/qrkH1cDIAH573CMY3713TU?=
 =?us-ascii?Q?EBDICy9lGa+mgSA8TLV116ZWNNOn1dUCT54Xf6FeyoHGXtdHmXdjyYUtrtmN?=
 =?us-ascii?Q?3CnVjC4QsLzCdCUkcJIwZewOCW4C2KQucPKhfJgph+WAXQbjRRSs8U/mkbnN?=
 =?us-ascii?Q?pGJuoznoRzUrCs1yXu1oEvpU6sbCRFmaoNW1bXqUiql/Y6e7RsfanUAl7w9W?=
 =?us-ascii?Q?Hyda2buhR82uUH7SwIb/2DGZaiPyhVC637JSLHCn2ebskDSuu4yLNtSSBTxK?=
 =?us-ascii?Q?gOil0yWCBpSUvRyrkVO7/eMR4xd8/ZIYbN1h+q8i25O9CEPyrvk/d6UbG3W1?=
 =?us-ascii?Q?1FzTQK9aSHPrZDHlVShN+5lzxNCfp6+d2fkBG8EIRpeE63lDzFI0qcQkg/gz?=
 =?us-ascii?Q?4TJmmICqRhzVqo59cc5l4Hkrp+AVt3DWIc4wUV3Is8+y5ALiGNv0dU2/8YnN?=
 =?us-ascii?Q?TDC0OHTg3/O3y3vpZve3RUYztiPy8qUMXc2kVCbq4reOPE09giZBvPikCYu8?=
 =?us-ascii?Q?dKqHMJLD54TF/rcVzLQDh6yrX7OY2U9dHddiVhPip5IzoyaCI8mU/V6uk58R?=
 =?us-ascii?Q?hAPcICtKF70jtNMGZp+5HXW+C0iNIUCvlsSdeXinJi1LrRLGYs8mK+ooUwSu?=
 =?us-ascii?Q?QQbsIKw04RhEHFhEI8sYNz3+QvvXyo908adFJYJhzfH1shGplBeTpNShrxD9?=
 =?us-ascii?Q?ylt/8RWx6wrZG+PguOXZ/tcC9HD7J9vl9CBJuJgASBcBzO9KGqlVNz3Zcp4p?=
 =?us-ascii?Q?5jRx+wbfypvgyfOZSTII14gNydgJbR59LD1N1M7ATk7YGnvQ0GwjAZB1MT1S?=
 =?us-ascii?Q?OHyviREP6GkvCnOvZKNuSjt1L7DLLnL8Ahh3Y0ygULFpbOVqkWF+tICeOa+9?=
 =?us-ascii?Q?T5RKeojTHwFzKcyMDy/79jN0UHmoQNejCUG4H99y?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ecVg2ho0T3YTL/7cFNQhxKxqbPb9qzzSbU25wGvNzXocVsWq9RE9i5Cb5hjRdEo9QkDkgXJc5feQ9VCuhjfLwos0WNukcdeWsmZWvglf7ls+lyydWvSlOumWc2A1prRmcZkcQGjyIXqRW3P0WFUFD7rY8o2r2YqbJMhxmGT5OqMXih0Hqroy/7obOwFp8EjYUXmQS1aNHuKY7AtXZPogvvmyBnO9aUB5HaDVhQDygYjhGgeBckMwIGi8ijG9FvYZTiZ5RlUZSnWERwcgjAL0A/NROCRahXrOO7FT6dSyC7sRMQghIELBcT8Z99tTVA+zGg7mFGQQ4hRSZ6eGQVmy42gwU4Ea75QBrf4mWwPrD+W6FUvzWADowkjUK/fW+x4sNlwksxDOL0iabkM4Muyqv5cL+2blUBsFfylYo423yg/2pP6cShn2YlbRvha8xEFZiajcox+GZcf5hczKEN8TcB7KWjrlXQE/3svmV+H78gAevNTVSvGjfsTzN48scCz3wzjTRFYOmRsCsoD8QFXgc/o5UfqynkEtq3F0/Ln4lNnuV0Rd0ELVY0NQdauzO0wPRme7r/MFE95GTya3kr9pWOWmLtPS95pPznOwQiuoSck=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd003ce-c3d6-4742-cbc8-08de1ce66bbd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 03:41:51.1388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U3f/r8XhDfzNm/JCb8565FRPZERhITn87eeWT1Wx95yqkTyFz3MwVIfBspPyWAEEnVoPEp7zX3FzBnZI5x+XoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6657
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_09,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=996
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060027
X-Authority-Analysis: v=2.4 cv=IcKKmGqa c=1 sm=1 tr=0 ts=690c1904 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=u2ey0Y-QUYRKGIaFtsAA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: f6Yb9qMTiEEJHKWaoKqSvZSUBTyYKPTk
X-Proofpoint-GUID: f6Yb9qMTiEEJHKWaoKqSvZSUBTyYKPTk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzOCBTYWx0ZWRfXzHlawKOvRzzQ
 R1e/afaXjr8L+UpCuSpjRqZ1N8ilSQbfx4xmXEsWqy8a7Dxqde2N9p3GP4880ylL6c4yt9sqMnZ
 +bltOms/5BMpRxP5a/Fi6zTFJ+89rP/rb9fHT8ruTpsCqCv5K0Q62pqIz1AF0au3CiIR0zeuyvS
 nDPW0ekzwqzBl/41c/sa0yfv54i+fHKYO0n2YDxFjwZYpoFv/y0ZpxsqdOyuUFSEZegG6VHKOIe
 apyRF/r792dUwVUN9SXeIPbKF1izh3VEKoIfn2160EZJ3sNXIyzveu8PkvRHFdgt7bepUb0Bdys
 CpzEm7WCyBFvgLoj/oOxmt7UIxQZ5YQM3XU+r4V4djR1GCP/jwlYn2/PV/Glmezuqfh9mX1j63c
 23wgNP5JFicoBHiGOtzA+tH8KKif+A==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B96961C0002
X-Stat-Signature: mseo4piy8pgspao93yrsqynxe4mhyhmp
X-Rspam-User: 
X-HE-Tag: 1762400520-882187
X-HE-Meta: U2FsdGVkX1/JcRANgQf+dD5rwwao6Vaw2IIaXPv16YDPCqLAfPv+38LECuapnVopX0pbVpzYzdNLo+Gej9KGwpHOU3UNfwLmm+9sM0dAX4OuAlr4f1ZIh/+xavpnDrHiQuvvO4kY3tQ2NZtd24jxbe4W8K3NeNstGheuu0J/TFtU8fayCEXcn9GjUd4qQBikwM0yQtPTbswabXpGzXCAuJpmfuk3VAOYgmoxldzppWZKBaQsdhtFQTHlzHhFFrneK9MMyW+SlX7XYg3q+to5LQ1s4aAHQxWCS9OmfS34CAxjs/yWpcrEaODHE5ShQW2I2f04y0kD3seFPs5s4VbaRHS4l2b1LQlgm22iCLXj1N/b8JeIBQBubclmKFjYH74OXrDD9NEOqkntimEfz7NhA7n/lK9dMBmZbcTkuAcAOKvIqR07gJdaOZ9IXwTYJyyURCPEY7TUvPB0HpDrv+c8dYW/aYASG0OK4tpSw8KZO6eLkOH+aLQHB4+JRgnsU5DmpMKd0/FzhMq5qWk2EjVB7n+3nQZxpxsnuBRf0VUCVuWLwE2RvuFJyZG43d7vH3Ela21f35Le5r8TdKOYwb5Gfk91TV4MYWN+iK5ZcKaWa9OgLPSqxVRl8bEDGly2JTRTdsvEwyY7zjrrH9L18B3JRr/rUAl9vbhhJh5a/EgXVPwxFmGRD/DU/5f+up413dyinHQs1beWLBcySWORfexQLinKPrSimQ0mDl3OlwrBPdgZZNC9GrelC3//kGBMuO9tbHUl5nSwJcM+Je6wyYDueUYHINYe7MS5cljix+ViCBXBBIlM1vTTf4TuzdW183q7b1AVSYOrew14ojJ7BNYDEOy2ei6KrZNDxC5oXVihbFsILhQhM9YP2FW7ZuBfWkVwINJX4TxADDUunjqhUyWNp1yGsxHVdJOtw4mehv/PgFID0ou287WQ2nqljNOu+irPmzzQ4qj7Q4dbaMnF6ol
 +GlX8cGj
 7t6hydH1hO75/Gkot/yoS3cyHnMtg14hf99lo6D7YMacNXmMdGcVVz3S1FY4dgttBPXDIMiGci4PgRV6UGLM7jrIEoksOXWDFa91zVUi2EE9oKLpjWIZ8n2YDHG0+bD4zkLCtOz/bZKB3l+hdw5Cr8tenfvUfu++Q5eprfG0aV3mD3rH6fo71JRh6Y4YwJemWll5etBrCbeJhM7eeVXtMRfmVeOxJ6/faXlKGRGN4t3CanlanvLHGfIPWRaV1n2ItQx1/eWJXT+xSO4zlmyKW1/KCkQkNb997sKM3+gIh3E8eHEN3qHd7IXvOcSv/olrmn1+EqgzkNw6PBXDKlZt3j8TznoXAa/vZTbNAdYxFE8Eo5od4uP5cWpV4gbnWpMc/Uepn0TW64dcFv7V2WAOZ9+ZFSpk2n/C4dmzKsSHBrHJAYpFY5HcP8BnQP7L0moN5JzYWRnU1vJR4fnY/B63v9C0OeRoMpypec5Ds9O2AtQOja6bu+t8SPvW1QhtXmm7WIIxvqJ31aWipaI5u4QdjOCrfep5Yb5VNY0SsVFLZprJz+FMTtkHXDO1KEaN03KkWug+zSIQId3YVT6W0lvvo7OQeqLfdr6zl8V4N+CBDXYBxd3NZyV7OMoxDEa/gDovkJirsOTMW9/jzKLRt8g1fT5mZNjl2g5fQ4iHff67OtUXzdfh7m0RRnJxpcc7RXq4S55dneUiFbJ3ePMunoUF/bQ958w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 01:24:15PM +0100, Vlastimil Babka wrote:
> In review of a followup work, Harry noticed a potential infinite loop.
> Upon closed inspection, it already exists for kmalloc_nolock() on a
> cache with debugging enabled, since commit af92793e52c3 ("slab:
> Introduce kmalloc_nolock() and kfree_nolock().")
> 
> When alloc_single_from_new_slab() fails to trylock node list_lock, we
> keep retrying to get partial slab or allocate a new slab. If we indeed
> interrupted somebody holding the list_lock, the trylock fill fail
> deterministically and we end up allocating and defer-freeing slabs
> indefinitely with no progress.
> 
> To fix it, fail the allocation if spinning is not allowed. This is
> acceptable in the restricted context of kmalloc_nolock(), especially
> with debugging enabled.
> 
> Reported-by: Harry Yoo <harry.yoo@oracle.com>
> Closes: https://lore.kernel.org/all/aQLqZjjq1SPD3Fml@hyeyoo/
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> as we discussed in the linked thread, 6.18 hotfix to be included in
> slab/for-next-fixes
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

