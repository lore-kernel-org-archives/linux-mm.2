Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7195CE95392
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 12:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985036B00AB; Wed,  4 Feb 2026 07:55:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931FD6B00AC; Wed,  4 Feb 2026 07:55:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1C86B00AE; Wed,  4 Feb 2026 07:55:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F70A6B00AB
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:55:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C20948870D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:55:44 +0000 (UTC)
X-FDA: 84406771008.20.9E05E44
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1B582180005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:55:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lHb99ms9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ChX6g2Mq;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770209741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=petfKZOdcJrPvOmOCynNhctMgBUESU3m+7TteD+Ionk=;
	b=FGuQCWYs1U/QLeF2aYrxXQ0ZrpqM6R1FHu6KklhpyUfjftiGvI4dRros64LoYxjRDq+6Ul
	T0ekngxK8GXOj7xEp+Dgq9vE1ANFvmWsR7+WDd4jDNXdB3MOUq8FvFa4oTzvFlSVQ9G6+N
	3Aykj758IL/g0yJIoIp4m35oqUWAcW8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lHb99ms9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ChX6g2Mq;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770209741; a=rsa-sha256;
	cv=pass;
	b=Pld+IoK1dQmtYay18DVlupBIChGASWvkpvqRDaNPbrkqUX33zZg8kLcs6H3b13Om+DObVJ
	7EB+/EHs7lDLWXsnRVNgJBjOmIProd/9wNheDFb5uBuDFx1mPHxDJg/kDLMsjA0VgcKwEP
	I17nd/r9kPmUboaSU2qeNFCwBCs/cLI=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614AtlX44087925;
	Wed, 4 Feb 2026 12:55:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=petfKZOdcJrPvOmOCy
	nNhctMgBUESU3m+7TteD+Ionk=; b=lHb99ms9oxdGr7Okz1xuW18U2Rt7hnAJNm
	Z7SARwv75GnVjMy3DyMlOmhSL6Po3GQxAdx4ddrjt9FQqp/wV2Kr+wNIxK6BUP0t
	4vMfNDGjIzj4hsPVL85+v2Q8eEUVi5qkecNrJDhaZnGLra24ZErhElNpHxoLmc0O
	4Snr3gVPZ3QgvK7C6CNhzwokLSIN8Vrk4b9zKqYjABQUXF8HTTHDCpIIxH3tPaBN
	U2McJT7hkBMCUx5GHgNlJJYitP3uCO+wW7SrsR6jXYFwDxCYmbaU1iIXBaYd4CRw
	xyWPjNJKqSgdMvBfrrYL5eM9ItnBi8lL3R3msXYIDzGWZPVFiX2g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb1u20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 12:55:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 614Cefaa026429;
	Wed, 4 Feb 2026 12:55:31 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013031.outbound.protection.outlook.com [40.93.201.31])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186bd4x3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 12:55:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YPN1ooxYSJ87Ns79IDz3LyIWIjxprL/W/s4/4f7Hlg5b/hN3CWb1RxTOPIKsG6rXNA768V3QmAMpQ1lmxfUn1ADuTaBXpQrukp10V9kGlhEdScubCV4AG+FhbFZO9jzR5SyYIkfQibWl9MccN3KA+5VnFRXb2TvVptQWOVgqTjBc8zPJkfDvsgY99c6/hxDT/hbisf86lary8AaT76NTX+uZ525XnuNrsjA5ks0gQDQ/UgMTILVVfmrG/v6QR78K88+5eXaJCOJwdto7Zhqtsh6DB5444R7wZ1EoLSavPKmtDEFFs92OHepzTzzEjJy4+b3lZhbd0X5wxCqCL3hn3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=petfKZOdcJrPvOmOCynNhctMgBUESU3m+7TteD+Ionk=;
 b=MDHkTCmRBDCjcCYqY4OGTceYE3R1vHXO0Cn8o/MBk7r7VqsLR9jxq1B/LCAYFxcaXbr8SEGIgJGcyDtaLmBALgSU356oHEsSUdgvGho6DpnufMIvXudOIEf19TpY6ZCzLLpT3F5+xTgrYMKMT0cxmwAxZrC/7JtH8AksOUorGvvXG6CrRcUm+4/m/8Et7zLbFejYC9+EFALOBef263AsyYxJ3L+H1KJCPcrr+RMidJvMX3ORgE26CPtN0BA4Bf/onztbziYo970foyEJUW7zmhsX3u02kxFt1vOR+MJ3/i9u4WxTebDj7GH6SZdOs6Tysg6yARkOxTm3RPqZXuxJuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=petfKZOdcJrPvOmOCynNhctMgBUESU3m+7TteD+Ionk=;
 b=ChX6g2MqMgTxfl+32SL+hrkxj5OG62A4OZTI0kczPz50YcFiPpH6rT6woMtfDE6F1X1xAce9hDOnHkm8RkGypQ8lIHTCYETuzcb5QQ8kJV7ZMUkFJyCE/FMfw2YTaPCagFKu+sWeS+usBeSFGoXU593yDnkFist3+mQ57+roTWg=
Received: from DS0PR10MB8223.namprd10.prod.outlook.com (2603:10b6:8:1ce::20)
 by DS0PR10MB6077.namprd10.prod.outlook.com (2603:10b6:8:cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 12:55:26 +0000
Received: from DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9]) by DS0PR10MB8223.namprd10.prod.outlook.com
 ([fe80::b4a4:94e3:f0bc:f4c9%5]) with mapi id 15.20.9520.006; Wed, 4 Feb 2026
 12:55:25 +0000
Date: Wed, 4 Feb 2026 12:55:24 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
        hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
        kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
        baolin.wang@linux.alibaba.com, npache@redhat.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
        lance.yang@linux.dev, linux-kernel@vger.kernel.org,
        kernel-team@meta.com
Subject: Re: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
Message-ID: <eac3e28c-974d-4bd5-a8f5-ec703295f624@lucifer.local>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-2-usamaarif642@gmail.com>
 <9033fac5-1dd2-49ab-be34-c68bde36ec11@lucifer.local>
 <1638e64e-bc66-4bbe-9fc3-c4c185d86ead@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638e64e-bc66-4bbe-9fc3-c4c185d86ead@gmail.com>
X-ClientProxiedBy: LO4P123CA0664.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::8) To DS0PR10MB8223.namprd10.prod.outlook.com
 (2603:10b6:8:1ce::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB8223:EE_|DS0PR10MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: 62a7e4ed-821d-483d-1190-08de63eca9c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t9Vg/UH8qKP4Ubt97KNuCl/4jAyo8rv8qtEvnOdWmt6SCy59ZMwyMevTYSHQ?=
 =?us-ascii?Q?A1bWvw0r8taiZFhFaElHn5JTFl9yRKoQ40MySYjBxPf0uNcLJzQpELDa6rWH?=
 =?us-ascii?Q?XPxCAV+nZFla+e1UAtNl70P1GbYZLYNv0pxzRaK718Mol2FGaK3cqr7ygAuv?=
 =?us-ascii?Q?drn4C05zE+PpW6kEpelXQV6GHTGZAL8mtfMBC6UVox+dH+mRXB5GI7IjgUDG?=
 =?us-ascii?Q?mwaWxLgyRra6p7snJzYWcOYTntfuJi0FjIoltDZIsrfjnSR6d2uQuDsylFTH?=
 =?us-ascii?Q?rwhxsCctKzOovqYi9mqH69IoUTJ5YXKFOvyxHOdGmpWuWzepronvHd8n+Wz2?=
 =?us-ascii?Q?odJj9LDRppqnrmuIwQL4vdYR5OlePxB08OZk6FNRBX8+dtE0PsqETBvIxonX?=
 =?us-ascii?Q?uNPrUdpvdCNuJq8q7CemqvIto8rVOLpgiNn5CB8agJbSmktFKb8Nnbm2ObxQ?=
 =?us-ascii?Q?mV8uqWw4I1GHZcmpVDul7ygWOvi1ZqDS0tK825x19URaWs7MOSYZqQmMcORu?=
 =?us-ascii?Q?pg9XR+wlCXawP+3kzWWpfJ/ybhks2u32NsnNXbjP16TdEHvffaGOjRYtCjlx?=
 =?us-ascii?Q?ZlpnVDOtp4FPCwxsDHkeFv+FeSJsrH0JHeCmNwoJONiBc4kgdVNK61hxblcW?=
 =?us-ascii?Q?gx9Auis/vvwRTxTatwyOChXlBDOeAFJFUCNdCJ/zL4+T7M0Akd30F4ldLKYE?=
 =?us-ascii?Q?rXahG16WHBQkRzPr2xiDtmN/W+idmQj4KrxPe1cciq2FfMEJzy4myHF6Tze5?=
 =?us-ascii?Q?62Fwn+ynv39AT8i/6vcqKwPK5sGNm/5hzw/WdbZXVRx+VOyN1WD+AxMRRtfx?=
 =?us-ascii?Q?ZhJLG0mhLUlNA54lm7TlKXhaFoKBWJLUuOUceAIZBlsMFXgJuGKQirFO1R7e?=
 =?us-ascii?Q?1777rBxIEoIXwheSva6OBtfLlTLMpHIqT7A7Li2yL52RCuTQu5dCCe3eXfUG?=
 =?us-ascii?Q?axG/MeijXeO0l68NUjfCoyMFIv6wGNFKaBM2XMdp6yANXG3dcRP7Y3wFnctV?=
 =?us-ascii?Q?++YczvlCLhxgViww+xcJ2X9MKKZZBmc3Nq5eOw/g6BFcrB2Ig+7pd5W1u/kW?=
 =?us-ascii?Q?3CjmDjsXJuqBoDf0wg7yjcd5qk+3HDhTfG/Kv925i54BYdDA8G24EogFSI/A?=
 =?us-ascii?Q?rhpiQJGPK7fmakoz0XTXVfxS7eqjKn0TilH79xcIBJYrmH9DmdcvD5FyhPBE?=
 =?us-ascii?Q?a93FmvmZyVd0uzGEMPLFE3KnAVciQLX9wFtF2PSONB66dF2rSIj45UiN51nI?=
 =?us-ascii?Q?w2VoR8wEyqA2liSx+xxRRJ13bgZ0g19oT/bv8kkqNdzvdE9NJ08ldrUoKkP3?=
 =?us-ascii?Q?f2DUGkUg4rcAv9vfWE0gqbklMlxZzGcdyHtQdmFse0vMcDu3OAFSppd9hkR4?=
 =?us-ascii?Q?oEqLbz3ju/Dnakm/9WLwfspUD3Ugzy7P/l1k1F1UjGT6kJvTXX3Ph1D4z2+k?=
 =?us-ascii?Q?gEwVd/jrOfMMNXFSRbS7V8WsKjqrcIRJHBo9xbFni4k49dR73GcbwpeH97Ub?=
 =?us-ascii?Q?ffkNDmuhhnt1ZafQPqmyQWyoGHTFAOH7i68dfdQlld67dzkW0CtLhv3yatVb?=
 =?us-ascii?Q?RmjM7zd0VtcHDOAHBrZPOB1oKQaTq3FYm0G8rMno?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB8223.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0FhDz62yftfk9JjV1Zrbgti44qoqm6soHiC3kH6gTOeK/Yn8V96LbXpMqvec?=
 =?us-ascii?Q?KrrWGY1GsCKnVXwZ52OF0uoPy+JStGY/IBNi7QELg1GSYj9AaOZKJqXcjaOo?=
 =?us-ascii?Q?xixSJfFDt+w/HNoBDa4FpLq/z4OV3Dv3mC0AGQf8/1vQNTTYFE/H6It+bMnC?=
 =?us-ascii?Q?+5xBQFeALu7VhgW2sbaF5a6CtaBqYRa/nk9K800RJpJyhGsACdiTDc2HMvdk?=
 =?us-ascii?Q?SZ5EoXpO6mOnjQUwqEcoIhMfvKyPRgtwA+Tby7KSPOJvQMO/o1S30NM6lwtq?=
 =?us-ascii?Q?LHCXY1JeFp4k1YX1frUiBPq6KWPndsatiIf7FpErfeKtUMf222H1RZoxrDfP?=
 =?us-ascii?Q?hfnBUgsY7p+053fcki44rBj+4Zm9y1sBnkvdcYUymryLziNm5g1nRqyoztuX?=
 =?us-ascii?Q?bHcj+d9sXmdP0GM8gqVHOJXd8DdJ0Ezek+YZAl4JooeFrBXznk1FkwWdUkrq?=
 =?us-ascii?Q?6OriVeHku+21T+yx/e7oVTJGepIqWQGOSjELdMHi7JbHlz2sQGJM3dh+6V49?=
 =?us-ascii?Q?8kT36sFhhn2IDays5dY0Y2pDpI7rNveo1mm84IxtMW4tfd7BM7zX9l9X8K2D?=
 =?us-ascii?Q?wRiA4Rnx+MQbDb9XAUEazXKQj/MhgyiyMyfrfGOG4CsAvgR7D2TCpqOEa1YN?=
 =?us-ascii?Q?TFSnUMVY53NAkZb0wQ3TfgksNv+QouF8TuH1eqGWUlE+BgVSkFL8WwAIyw5C?=
 =?us-ascii?Q?yO4YLsTl4UtQ1BCd2881+fj2k+xgn3AVQGszD4fBNIYKMUWgZZekia9alQ1t?=
 =?us-ascii?Q?cQV+yl2TlovkAW2oGF7SQt7sWuwIyY7gSo4KZk185gtbfxlJE8DBhjanQnm+?=
 =?us-ascii?Q?78pZ1XlN6AIiTQY/bFRgH9JATBX0BHCqYEr/qkLhyPpYCfkuVDN4AoPIA2sp?=
 =?us-ascii?Q?ZxJxXvE7uh91I2bl3czKCMs7j6bjPcTYAFucM9cGwMLL2dqegwq/j5ELY6k/?=
 =?us-ascii?Q?ikNz/zwvwzPwutm7+v6trmGc1locTioaxEl4kXuBDtlRuQ0o/bcRgYIlReYC?=
 =?us-ascii?Q?a72u8fsxk/mT6O5pYU/pq8qz+n2q1fYf30VoUj1H5zdEK/KPAG0lxoe/GuMe?=
 =?us-ascii?Q?0HuMYhpMbmrEV8VH1stjMI6UWdnweKW+aQpwcIB/+B6/QVrN7fdvIPgZtkQR?=
 =?us-ascii?Q?lm+WtbAccChc8zS4KdOj4/wuHZhaoWrhWeczn2DwxoCooy3i/o2SJgxx8HZx?=
 =?us-ascii?Q?VAJ2gk1Eluu9PCdGGJg0/6Whky0O6VfCkg3OE4wz6tuqozkPLC7fAud2gPox?=
 =?us-ascii?Q?bMH46it+MGi6iQu/p3mzWcJyVc+fGEiMN4/pRp3E8UToq95mkLZ6ytYcVqlg?=
 =?us-ascii?Q?O3B6coU7xdFW88W/TKHtXiZ8bqz3eENGESR7Q2a5evMtIP5ExMcoYnYVZpYo?=
 =?us-ascii?Q?Z+wpjUnSdKU0bIHWaocZ8fQKGvmSoovTkr0CJESAa60/LV35XKFU76MiEqXg?=
 =?us-ascii?Q?YD8JFsWAPQOgPt03BkLZ+d3DhpNsBIKjwoGpcPBc95z4l2fVvpxN9Sz/EDma?=
 =?us-ascii?Q?l+GqKMkbVWQTCSYwc2QRLhujqfAOPSTl2dy67QKUKN6DPY2tGhENyWBzZBlo?=
 =?us-ascii?Q?AoG7NGbopGCWY3I9CCZOv1JaktVuDPqTdvTLPT+0sUhyeFELWyCo2LwsTNtb?=
 =?us-ascii?Q?Lbbv7G7/kqSBcp0ei8KTQ97u9ecx4Q8Mi21EH4sIKUNf7JvcN7yiOUUNGrsT?=
 =?us-ascii?Q?1ZpAs612rWYupeQWl4w6t0drMx3VMSvtoi9Gs4HupHBwpPVKPTV0+05zGUM3?=
 =?us-ascii?Q?tenmo5tC9mlaiAylqx9+Iz1/yH22I0k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k8iDCUj9LgwZco/Dpy/paSCU80oHzaTD34A+Sg9TwcK5tEWWh8+H+OzrNxwkZCV1lpsOJ+AKy5Whenu6Ono8JCYpbuNeQ+xlNOttfNhZF/3DLId7I5wnGol+cW4tTfZuds8IZRJ+faDG9jEyRatVHgiIfuYWjxvQvd/47X4MS/MKpaIarmLCFjHJ5jtB7dmbArUufmC06F5zP3QZjzrtLrn21zlvXEaZmhiGi9ciZiKnHY9IethT5eXWL7KiD3oJpr044nk+OGG6fyx3DlLRT5VMuhIHqr2e1WTWo/9XfQlDDjn2LZxm6YTbdsfrPJpt0sr6YxAduEZQDH/bmmW1+vwIGIspgEub9Vs5tG1pa1WyqpBNlx7VVl199iSTIe5QEGTrHSVEB+xuMOQQy87VFDJIm7V8FOTRoYLS/5wzdTL4o+ud5i3mUAqJoEQnamxTjjM4dZokioicVVlFc8WB7LEUD/eOooLNCpxTTncyjocknLx9J4AVVDjazwa0uktn8GhtcmCIHtSg+ZEzwOaHjkCNietcTO5s8bJWNW/LapNJuNQK5bZd3+7eknSWNe4MAAmqncg9duU/rhbL+pgTtHa+9/oKVbQLqy9/q5CrE6M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62a7e4ed-821d-483d-1190-08de63eca9c3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB8223.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 12:55:25.0836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BSF1mFTM29EQWCsKH2TqPZsHH0kxgZ6K6NjTL8rbqSvkGP+P0ua5FPzz4yp+pC+Q4PWM344x7aZmhbX9gm5cbtV1ANAm7KO0rTjVsFgAjzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602040098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDA5OCBTYWx0ZWRfX9Y8Fef3VjvtP
 nAemWUDE2eADHFzFoYTPKUEE8vbPtqg6fj39ZP+cZlyuOnNvQDfpulcFc7t5M4/zhxLQzfZb0qX
 gr/0+My1GOgbkZ1cZy85X7xxyulLa9rtNMDZyf/6ti086HmDIhza3jfypvUW3muxheH1SFRaABQ
 ISKryQCo98NaiXb3Lxr6d1RPlDjuMYV8waaRsj84pqGy6W8GEAoFGyuit6flctR5Qravs+BAM3T
 C0E+d8nU84IsjwrFluqnR4NJQmLVCSWz5ME6QQ3bRJtvCJY7aQNas87ZT/r7vIXPuoIU5j/KqRe
 7mbWCN51+AsHfCx9lLamwTTsqP1LXJHSMXB1V+eJv2bU5Rvv1SYv6iWNklbgmOUjR/LgjoYtWxl
 2kRmF8XY1hBRddbmeufQ1H6Svtk+jZD/skxDzbw/eMBWKI1I4R1qW+aqXd2lb/8srOUBdIj1u6L
 BqkScD3IbuJAyr1vFeA==
X-Proofpoint-ORIG-GUID: 5hSTPvCSedKhXiZ8NtfGzSCJp6JIVeXG
X-Proofpoint-GUID: 5hSTPvCSedKhXiZ8NtfGzSCJp6JIVeXG
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=698341c3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=l9NJdQOFvvZoG9CbEA0A:9
 a=X1KiOZcHs5oEnIaq:21 a=CjuIK1q_8ugA:10
X-Stat-Signature: 7fchj6cw58coenrpuo8m1hhimh4poexy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1B582180005
X-HE-Tag: 1770209740-564552
X-HE-Meta: U2FsdGVkX1/6MbMxaI+aaUj2clv+FHnIM5JeO5m32SmfezxSRdZBgg6xqW3PUiR1cHa6DxppcsTXXQ+bdy0jGQObXFtHTj8ZLovRgbjmY5A3U1CK6GVr19G9t12mdhcBcepFX3moTwSGhjbvVA7KSr80S6Ueo2lwuOqqLLekOVH98tZyTzmj7kcyqq+P/q2O7mEieqU/MdOvPkBBcKQh1FWvaO5UAx/KnMLXfw0L4mIRuss0lDxtwZ/vG8EcRsgJ/gu+emv2k4YEGgUa2IBYJAZRNMnwQYEAj25nF64sCbmIrRrF+zZnT4MULqhJb0gjmhoS+/LJRNkDVJwmOXd10NNSpxAoyzF7PFMWnEe4CSo2beOlDZSLv4MZNsFxbGV/ANDLh/dVSf/W0vV1g9MclUplIAv0ABKl4DXFPHJkAdVFixal4w4Fyo1IEwsXX4DDT+nbe7Xb1+vzARIy9beJjY9OAxBSlyQ7qGxvtwHRL+28qj9SxC5v85HDammERK/4vSpnYmgfPo/OvF89l2PD4yR34WqHY/mNNFGsh93cps4fgaWRFmQJrbUSWeFFJQoLdkhjtAlTuLyJ4fmt83hd0yw0X16sDmYk3nY/NwmugpyXJayAATskiwhFD0Tgqk2ld1nZyPD70aygy41iduysMNjGwcsaFPTu86rc3AzEp/GKOo6r2jJ4xsPRKseK4ptSaPcictgvv1iTCJ+KUWWyuQ34XAPS15rmMcFO0NA4IRdQuwP+OKzCSiI+Gnq5CSj6OTWOSUoNSoD1DdEVMbdv87SMiEpRRkGo+MNvNcW0wrj5UjGWI5vuQhDl1APS5crxtIJnvVZzqKwYZyaD0U7nzO8LwiSoYP9DQu5zpZB5kqyskVTmeXkKlmwIRjoJfhnz4Dawb0LbdjUPiVWk9RXeck2JynXlQpFUfB8zDL44zLooDddiW5Ksp91KR5VZWzfCghrnyH7Vhm38GtmmbUw
 gS/zsMKw
 cf69m9cD1+/vKpISf6pVKCkUTlHOKVHyou/NQOuY8mwP8Xe5uKQKQqHX4FGjRuA5gNhyfBIwxW0FOiaJicscyL0oky6ixwvRCgw9T6NjZF1WIchn6WSnqssWhgggQfYZMdmWMePgvfOffdKK+YLqViEHyfRcQCWxhL8EnccoU81SW720RzLsO4Gc2LS97AHi+GwJunCfj0i6t0AGrMqNX3PaSdXZyGw7m4PnGPJag3z4u97gwuo/mM+wWGB/0F0UGkGPSVDzlb7ITN9ihUmsz3ErBATrj8B/z4zx3KM2qMAo4ggyGHiOdZHUPOsdHpNAA+TzLL9xRAyitdTbhzo1Q34DTf7nE6+WT52zR+WCTZhYCIIVlsF8nf8Cqv2ujnRj0RmmPYw06B+mjqUaHss/dBLY2eNPgqJIj7+frtxAhd6lXiK60NhV4VEEdLmEP0AYflb0zrlDTZ6Wn3C29On5rwi3QRGFU9TK3TnXfRyRPE2ypyJ2QDeYGRYMggmVTjolYWN7LiNefDgiLw93/ivDyNh4WNDXEtkPg8UZ+15LvKHW11iN9a1uZQYXa/mk/aM9VfNiljhJOXMTdZcTtqkZ+MBAsf2Q3WOgEGhbdHaTuq+/M7wSeF1c3XYjlOLfTMriFpvHEK+/eliFbtGXOnVu7Z7zWqJ7usKCWHcb5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 11:38:02PM -0800, Usama Arif wrote:
>
>
> On 02/02/2026 04:15, Lorenzo Stoakes wrote:
> > I think I'm going to have to do several passes on this, so this is just a
> > first one :)
> >
>
> Thanks! Really appreciate the reviews!

No worries!

>
> One thing over here is the higher level design decision when it comes to migration
> of 1G pages. As Zi said in [1]:
> "I also wonder what the purpose of PUD THP migration can be.
> It does not create memory fragmentation, since it is the largest folio size
> we have and contiguous. NUMA balancing 1GB THP seems too much work."
>
> > On Sun, Feb 01, 2026 at 04:50:18PM -0800, Usama Arif wrote:
> >> For page table management, PUD THPs need to pre-deposit page tables
> >> that will be used when the huge page is later split. When a PUD THP
> >> is allocated, we cannot know in advance when or why it might need to
> >> be split (COW, partial unmap, reclaim), but we need page tables ready
> >> for that eventuality. Similar to how PMD THPs deposit a single PTE
> >> table, PUD THPs deposit a PMD table which itself contains deposited
> >> PTE tables - a two-level deposit. This commit adds the deposit/withdraw
> >> infrastructure and a new pud_huge_pmd field in ptdesc to store the
> >> deposited PMD.
> >
> > This feels like you're hacking this support in, honestly. The list_head
> > abuse only adds to that feeling.
> >
>
> Yeah so I hope turning it to something like [2] is the way forward.

Right, that's one option, though David suggested avoiding this altogether by
only pre-allocating PTEs?

>
> > And are we now not required to store rather a lot of memory to keep all of
> > this coherent?
>
> PMD THP allocates 1 4K page (pte_alloc_one) at fault time so that split
> doesnt fail.
>
> For PUD we allocate 2M worth of PTE page tables and 1 4K PMD table at fault
> time so that split doesnt fail due to there not being enough memory.
> Its not great, but its not bad as well.
> The alternative is to allocate this at split time and so we are not
> pre-reserving them. Now there is a chance that allocation and therefore split
> fails, so the tradeoff is some memory vs reliability. This patch favours
> reliability.

That's a significant amount of unmovable, unreclaimable memory though. Going
from 4K to 2M is a pretty huge uptick.

>
> Lets say a user gets 100x1G THPs. They would end up using ~200M for it.
> I think that is okish. If the user has 100G, 200M might not be an issue
> for them :)

But there's more than one user on boxes big enough for this, so this makes me
think we want this to be somehow opt-in right?

And that means we're incurring an unmovable memory penalty, the kind which we're
trying to avoid in general elsewhere in the kernel.

>
> >
> >>
> >> The deposited PMD tables are stored as a singly-linked stack using only
> >> page->lru.next as the link pointer. A doubly-linked list using the
> >> standard list_head mechanism would cause memory corruption: list_del()
> >> poisons both lru.next (offset 8) and lru.prev (offset 16), but lru.prev
> >> overlaps with ptdesc->pmd_huge_pte at offset 16. Since deposited PMD
> >> tables have their own deposited PTE tables stored in pmd_huge_pte,
> >> poisoning lru.prev would corrupt the PTE table list and cause crashes
> >> when withdrawing PTE tables during split. PMD THPs don't have this
> >> problem because their deposited PTE tables don't have sub-deposits.
> >> Using only lru.next avoids the overlap entirely.
> >
> > Yeah this is horrendous and a hack, I don't consider this at all
> > upstreamable.
> >
> > You need to completely rework this.
>
> Hopefully [2] is the path forward!

Ack

> >
> >>
> >> For reverse mapping, PUD THPs need the same rmap support that PMD THPs
> >> have. The page_vma_mapped_walk() function is extended to recognize and
> >> handle PUD-mapped folios during rmap traversal. A new TTU_SPLIT_HUGE_PUD
> >> flag tells the unmap path to split PUD THPs before proceeding, since
> >> there is no PUD-level migration entry format - the split converts the
> >> single PUD mapping into individual PTE mappings that can be migrated
> >> or swapped normally.
> >
> > Individual PTE... mappings? You need to be a lot clearer here, page tables
> > are naturally confusing with entries vs. tables.
> >
> > Let's be VERY specific here. Do you mean you have 1 PMD table and 512 PTE
> > tables reserved, spanning 1 PUD entry and 262,144 PTE entries?
> >
>
> Yes that is correct, Thanks! I will change the commit message in the next revision
> to what you have written: 1 PMD table and 512 PTE tables reserved, spanning
> 1 PUD entry and 262,144 PTE entries.

Yeah :) my concerns remain :)

>
> >>
> >> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> >
> > How does this change interact with existing DAX/VFIO code, which now it
> > seems will be subject to the mechanisms you introduce here?
>
> I think what you mean here is the change in try_to_migrate_one?
>
>
> So one

Unfinished sentence? :P

No I mean currently we support 1G THP for DAX/VFIO right? So how does this
interplay with how that currently works? Does that change how DAX/VFIO works?
Will that impact existing users?

Or are we extending the existing mechanism?

>
> >
> > Right now DAX/VFIO is only obtainable via a specially THP-aligned
> > get_unmapped_area() + then can only be obtained at fault time.
> > > Is that the intent here also?
> >
>
> Ah thanks for pointing this out. This is something the series is missing.
>
> What I did in the selftest and benchmark was fault on an address that was already aligned.
> i.e. basically call the below function before faulting in.
>
> static inline void *pud_align(void *addr)
> {
> 	return (void *)(((unsigned long)addr + PUD_SIZE - 1) & ~(PUD_SIZE - 1));
> }

Right yeah :)

>
>
> What I think you are suggesting this series is missing is the below diff? (its untested).
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 87b2c21df4a49..461158a0840db 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1236,6 +1236,12 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>         unsigned long ret;
>         loff_t off = (loff_t)pgoff << PAGE_SHIFT;
>
> +       if (IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) && len >= PUD_SIZE) {
> +               ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PUD_SIZE, vm_flags);
> +               if (ret)
> +                       return ret;
> +       }

No not that, that's going to cause issues, see commit d4148aeab4 for details as
to why this can go wrong.

In __get_unmapped_area() where the current 'if PMD size aligned then align area'
logic, like that.

> +
>
>
> > What is your intent - that khugepaged do this, or on alloc? How does it
> > interact with MADV_COLLAPSE?
> >
>
> Ah basically what I mentioned in [3], we want to go slow. Only enable PUD THPs
> page faults at the start. If there is data supporting that khugepaged will work
> than we do it, but we keep it disabled.

Yes I think khugepaged is probably never going to be all that a good idea with
this.

>
> > I noted on the 2nd patch, but you're changing THP_ORDERS_ALL_ANON which
> > alters __thp_vma_allowable_orders() behaviour, that change belongs here...
> >
> >
>
> Thanks for this! I only tried to split this code into logical commits
> after the whole thing was working. Some things are tightly coupled
> and I would need to move them to the right commit.

Yes there's a bunch of things that need tweaking here, to reiterate let's try to
pay down technical debt here and avoid copy/pasting :>)

>
> >> ---
> >>  include/linux/huge_mm.h  |  5 +++
> >>  include/linux/mm.h       | 19 ++++++++
> >>  include/linux/mm_types.h |  5 ++-
> >>  include/linux/pgtable.h  |  8 ++++
> >>  include/linux/rmap.h     |  7 ++-
> >>  mm/huge_memory.c         |  8 ++++
> >>  mm/internal.h            |  3 ++
> >>  mm/page_vma_mapped.c     | 35 +++++++++++++++
> >>  mm/pgtable-generic.c     | 83 ++++++++++++++++++++++++++++++++++
> >>  mm/rmap.c                | 96 +++++++++++++++++++++++++++++++++++++---
> >>  10 files changed, 260 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> >> index a4d9f964dfdea..e672e45bb9cc7 100644
> >> --- a/include/linux/huge_mm.h
> >> +++ b/include/linux/huge_mm.h
> >> @@ -463,10 +463,15 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
> >>  		unsigned long address);
> >>
> >>  #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >> +void split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
> >> +			   unsigned long address);
> >>  int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >>  		    pud_t *pudp, unsigned long addr, pgprot_t newprot,
> >>  		    unsigned long cp_flags);
> >>  #else
> >> +static inline void
> >> +split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
> >> +		      unsigned long address) {}
> >>  static inline int
> >>  change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >>  		pud_t *pudp, unsigned long addr, pgprot_t newprot,
> >> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >> index ab2e7e30aef96..a15e18df0f771 100644
> >> --- a/include/linux/mm.h
> >> +++ b/include/linux/mm.h
> >> @@ -3455,6 +3455,22 @@ static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
> >>   * considered ready to switch to split PUD locks yet; there may be places
> >>   * which need to be converted from page_table_lock.
> >>   */
> >> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >> +static inline struct page *pud_pgtable_page(pud_t *pud)
> >> +{
> >> +	unsigned long mask = ~(PTRS_PER_PUD * sizeof(pud_t) - 1);
> >> +
> >> +	return virt_to_page((void *)((unsigned long)pud & mask));
> >> +}
> >> +
> >> +static inline struct ptdesc *pud_ptdesc(pud_t *pud)
> >> +{
> >> +	return page_ptdesc(pud_pgtable_page(pud));
> >> +}
> >> +
> >> +#define pud_huge_pmd(pud) (pud_ptdesc(pud)->pud_huge_pmd)
> >> +#endif
> >> +
> >>  static inline spinlock_t *pud_lockptr(struct mm_struct *mm, pud_t *pud)
> >>  {
> >>  	return &mm->page_table_lock;
> >> @@ -3471,6 +3487,9 @@ static inline spinlock_t *pud_lock(struct mm_struct *mm, pud_t *pud)
> >>  static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
> >>  {
> >>  	__pagetable_ctor(ptdesc);
> >> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >> +	ptdesc->pud_huge_pmd = NULL;
> >> +#endif
> >>  }
> >>
> >>  static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
> >> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> >> index 78950eb8926dc..26a38490ae2e1 100644
> >> --- a/include/linux/mm_types.h
> >> +++ b/include/linux/mm_types.h
> >> @@ -577,7 +577,10 @@ struct ptdesc {
> >>  		struct list_head pt_list;
> >>  		struct {
> >>  			unsigned long _pt_pad_1;
> >> -			pgtable_t pmd_huge_pte;
> >> +			union {
> >> +				pgtable_t pmd_huge_pte;  /* For PMD tables: deposited PTE */
> >> +				pgtable_t pud_huge_pmd;  /* For PUD tables: deposited PMD list */
> >> +			};
> >>  		};
> >>  	};
> >>  	unsigned long __page_mapping;
> >> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> >> index 2f0dd3a4ace1a..3ce733c1d71a2 100644
> >> --- a/include/linux/pgtable.h
> >> +++ b/include/linux/pgtable.h
> >> @@ -1168,6 +1168,14 @@ extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
> >>  #define arch_needs_pgtable_deposit() (false)
> >>  #endif
> >>
> >> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >> +extern void pgtable_trans_huge_pud_deposit(struct mm_struct *mm, pud_t *pudp,
> >> +					   pmd_t *pmd_table);
> >> +extern pmd_t *pgtable_trans_huge_pud_withdraw(struct mm_struct *mm, pud_t *pudp);
> >> +extern void pud_deposit_pte(pmd_t *pmd_table, pgtable_t pgtable);
> >> +extern pgtable_t pud_withdraw_pte(pmd_t *pmd_table);
> >
> > These are useless extern's.
> >
>
>
> ack
>
> These are coming from the existing functions from the file:
> extern void pgtable_trans_huge_deposit
> extern pgtable_t pgtable_trans_huge_withdraw
>
> I think the externs can be removed from these as well? We can
> fix those in a separate patch.

Generally the approach is to remove externs when adding/changing new stuff as
otherwise we get completely useless churn on that and annoying git history
changes.

>
>
> >> +#endif
> >> +
> >>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >>  /*
> >>   * This is an implementation of pmdp_establish() that is only suitable for an
> >> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> >> index daa92a58585d9..08cd0a0eb8763 100644
> >> --- a/include/linux/rmap.h
> >> +++ b/include/linux/rmap.h
> >> @@ -101,6 +101,7 @@ enum ttu_flags {
> >>  					 * do a final flush if necessary */
> >>  	TTU_RMAP_LOCKED		= 0x80,	/* do not grab rmap lock:
> >>  					 * caller holds it */
> >> +	TTU_SPLIT_HUGE_PUD	= 0x100, /* split huge PUD if any */
> >>  };
> >>
> >>  #ifdef CONFIG_MMU
> >> @@ -473,6 +474,8 @@ void folio_add_anon_rmap_ptes(struct folio *, struct page *, int nr_pages,
> >>  	folio_add_anon_rmap_ptes(folio, page, 1, vma, address, flags)
> >>  void folio_add_anon_rmap_pmd(struct folio *, struct page *,
> >>  		struct vm_area_struct *, unsigned long address, rmap_t flags);
> >> +void folio_add_anon_rmap_pud(struct folio *, struct page *,
> >> +		struct vm_area_struct *, unsigned long address, rmap_t flags);
> >>  void folio_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
> >>  		unsigned long address, rmap_t flags);
> >>  void folio_add_file_rmap_ptes(struct folio *, struct page *, int nr_pages,
> >> @@ -933,6 +936,7 @@ struct page_vma_mapped_walk {
> >>  	pgoff_t pgoff;
> >>  	struct vm_area_struct *vma;
> >>  	unsigned long address;
> >> +	pud_t *pud;
> >>  	pmd_t *pmd;
> >>  	pte_t *pte;
> >>  	spinlock_t *ptl;
> >> @@ -970,7 +974,7 @@ static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
> >>  static inline void
> >>  page_vma_mapped_walk_restart(struct page_vma_mapped_walk *pvmw)
> >>  {
> >> -	WARN_ON_ONCE(!pvmw->pmd && !pvmw->pte);
> >> +	WARN_ON_ONCE(!pvmw->pud && !pvmw->pmd && !pvmw->pte);
> >>
> >>  	if (likely(pvmw->ptl))
> >>  		spin_unlock(pvmw->ptl);
> >> @@ -978,6 +982,7 @@ page_vma_mapped_walk_restart(struct page_vma_mapped_walk *pvmw)
> >>  		WARN_ON_ONCE(1);
> >>
> >>  	pvmw->ptl = NULL;
> >> +	pvmw->pud = NULL;
> >>  	pvmw->pmd = NULL;
> >>  	pvmw->pte = NULL;
> >>  }
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index 40cf59301c21a..3128b3beedb0a 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -2933,6 +2933,14 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
> >>  	spin_unlock(ptl);
> >>  	mmu_notifier_invalidate_range_end(&range);
> >>  }
> >> +
> >> +void split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
> >> +			   unsigned long address)
> >> +{
> >> +	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PUD_SIZE));
> >> +	if (pud_trans_huge(*pud))
> >> +		__split_huge_pud_locked(vma, pud, address);
> >> +}
> >>  #else
> >>  void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
> >>  		unsigned long address)
> >> diff --git a/mm/internal.h b/mm/internal.h
> >> index 9ee336aa03656..21d5c00f638dc 100644
> >> --- a/mm/internal.h
> >> +++ b/mm/internal.h
> >> @@ -545,6 +545,9 @@ int user_proactive_reclaim(char *buf,
> >>   * in mm/rmap.c:
> >>   */
> >>  pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
> >> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >> +pud_t *mm_find_pud(struct mm_struct *mm, unsigned long address);
> >> +#endif
> >>
> >>  /*
> >>   * in mm/page_alloc.c
> >> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> >> index b38a1d00c971b..d31eafba38041 100644
> >> --- a/mm/page_vma_mapped.c
> >> +++ b/mm/page_vma_mapped.c
> >> @@ -146,6 +146,18 @@ static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
> >>  	return true;
> >>  }
> >>
> >> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >> +/* Returns true if the two ranges overlap.  Careful to not overflow. */
> >> +static bool check_pud(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
> >> +{
> >> +	if ((pfn + HPAGE_PUD_NR - 1) < pvmw->pfn)
> >> +		return false;
> >> +	if (pfn > pvmw->pfn + pvmw->nr_pages - 1)
> >> +		return false;
> >> +	return true;
> >> +}
> >> +#endif
> >> +
> >>  static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
> >>  {
> >>  	pvmw->address = (pvmw->address + size) & ~(size - 1);
> >> @@ -188,6 +200,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> >>  	pud_t *pud;
> >>  	pmd_t pmde;
> >>
> >> +	/* The only possible pud mapping has been handled on last iteration */
> >> +	if (pvmw->pud && !pvmw->pmd)
> >> +		return not_found(pvmw);
> >> +
> >>  	/* The only possible pmd mapping has been handled on last iteration */
> >>  	if (pvmw->pmd && !pvmw->pte)
> >>  		return not_found(pvmw);
> >> @@ -234,6 +250,25 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> >>  			continue;
> >>  		}
> >>
> >> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >
> > Said it elsewhere, but it's really weird to treat an arch having the
> > ability to do something as a go ahead for doing it.
> >
> >> +		/* Check for PUD-mapped THP */
> >> +		if (pud_trans_huge(*pud)) {
> >> +			pvmw->pud = pud;
> >> +			pvmw->ptl = pud_lock(mm, pud);
> >> +			if (likely(pud_trans_huge(*pud))) {
> >> +				if (pvmw->flags & PVMW_MIGRATION)
> >> +					return not_found(pvmw);
> >> +				if (!check_pud(pud_pfn(*pud), pvmw))
> >> +					return not_found(pvmw);
> >> +				return true;
> >> +			}
> >> +			/* PUD was split under us, retry at PMD level */
> >> +			spin_unlock(pvmw->ptl);
> >> +			pvmw->ptl = NULL;
> >> +			pvmw->pud = NULL;
> >> +		}
> >> +#endif
> >> +
> >
> > Yeah, as I said elsewhere, we got to be refactoring not copy/pasting with
> > modifications :)
> >
>
> Yeah there is repeated code in multiple places, where all I did was replace
> what was done from PMD into PUD. In a lot of places, its actually difficult
> to not repeat the code (unless we want function macros, which is much worse
> IMO).

Not if we actually refactor the existing code :)

When I wanted to make functional changes to mremap I took a lot of time to
refactor the code into something sane before even starting that.

Because I _could_ have added the features there as-is, but it would have been
hellish to do so as-is and added more confusion etc.

So yeah, I think a similar mentality has to be had with this change.

>
> >
> >>  		pvmw->pmd = pmd_offset(pud, pvmw->address);
> >>  		/*
> >>  		 * Make sure the pmd value isn't cached in a register by the
> >> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> >> index d3aec7a9926ad..2047558ddcd79 100644
> >> --- a/mm/pgtable-generic.c
> >> +++ b/mm/pgtable-generic.c
> >> @@ -195,6 +195,89 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
> >>  }
> >>  #endif
> >>
> >> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >> +/*
> >> + * Deposit page tables for PUD THP.
> >> + * Called with PUD lock held. Stores PMD tables in a singly-linked stack
> >> + * via pud_huge_pmd, using only pmd_page->lru.next as the link pointer.
> >> + *
> >> + * IMPORTANT: We use only lru.next (offset 8) for linking, NOT the full
> >> + * list_head. This is because lru.prev (offset 16) overlaps with
> >> + * ptdesc->pmd_huge_pte, which stores the PMD table's deposited PTE tables.
> >> + * Using list_del() would corrupt pmd_huge_pte with LIST_POISON2.
> >
> > This is horrible and feels like a hack? Treating a doubly-linked list as a
> > singly-linked one like this is not upstreamable.
> >
> >> + *
> >> + * PTE tables should be deposited into the PMD using pud_deposit_pte().
> >> + */
> >> +void pgtable_trans_huge_pud_deposit(struct mm_struct *mm, pud_t *pudp,
> >> +				    pmd_t *pmd_table)
> >
> > This is a horrid, you're depositing the PMD using the... questionable
> > list_head abuse, but then also have pud_deposit_pte()... But here we're
> > depositing a PMD shouldn't the name reflect that?
> >
> >> +{
> >> +	pgtable_t pmd_page = virt_to_page(pmd_table);
> >> +
> >> +	assert_spin_locked(pud_lockptr(mm, pudp));
> >> +
> >> +	/* Push onto stack using only lru.next as the link */
> >> +	pmd_page->lru.next = (struct list_head *)pud_huge_pmd(pudp);
> >
> > Yikes...
> >
> >> +	pud_huge_pmd(pudp) = pmd_page;
> >> +}
> >> +
> >> +/*
> >> + * Withdraw the deposited PMD table for PUD THP split or zap.
> >> + * Called with PUD lock held.
> >> + * Returns NULL if no more PMD tables are deposited.
> >> + */
> >> +pmd_t *pgtable_trans_huge_pud_withdraw(struct mm_struct *mm, pud_t *pudp)
> >> +{
> >> +	pgtable_t pmd_page;
> >> +
> >> +	assert_spin_locked(pud_lockptr(mm, pudp));
> >> +
> >> +	pmd_page = pud_huge_pmd(pudp);
> >> +	if (!pmd_page)
> >> +		return NULL;
> >> +
> >> +	/* Pop from stack - lru.next points to next PMD page (or NULL) */
> >> +	pud_huge_pmd(pudp) = (pgtable_t)pmd_page->lru.next;
> >
> > Where's the popping? You're just assigning here.
>
>
> Ack on all of the above. Hopefully [1] is better.

Thanks!

> >
> >> +
> >> +	return page_address(pmd_page);
> >> +}
> >> +
> >> +/*
> >> + * Deposit a PTE table into a standalone PMD table (not yet in page table hierarchy).
> >> + * Used for PUD THP pre-deposit. The PMD table's pmd_huge_pte stores a linked list.
> >> + * No lock assertion since the PMD isn't visible yet.
> >> + */
> >> +void pud_deposit_pte(pmd_t *pmd_table, pgtable_t pgtable)
> >> +{
> >> +	struct ptdesc *ptdesc = virt_to_ptdesc(pmd_table);
> >> +
> >> +	/* FIFO - add to front of list */
> >> +	if (!ptdesc->pmd_huge_pte)
> >> +		INIT_LIST_HEAD(&pgtable->lru);
> >> +	else
> >> +		list_add(&pgtable->lru, &ptdesc->pmd_huge_pte->lru);
> >> +	ptdesc->pmd_huge_pte = pgtable;
> >> +}
> >> +
> >> +/*
> >> + * Withdraw a PTE table from a standalone PMD table.
> >> + * Returns NULL if no more PTE tables are deposited.
> >> + */
> >> +pgtable_t pud_withdraw_pte(pmd_t *pmd_table)
> >> +{
> >> +	struct ptdesc *ptdesc = virt_to_ptdesc(pmd_table);
> >> +	pgtable_t pgtable;
> >> +
> >> +	pgtable = ptdesc->pmd_huge_pte;
> >> +	if (!pgtable)
> >> +		return NULL;
> >> +	ptdesc->pmd_huge_pte = list_first_entry_or_null(&pgtable->lru,
> >> +							struct page, lru);
> >> +	if (ptdesc->pmd_huge_pte)
> >> +		list_del(&pgtable->lru);
> >> +	return pgtable;
> >> +}
> >> +#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
> >> +
> >>  #ifndef __HAVE_ARCH_PMDP_INVALIDATE
> >>  pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
> >>  		     pmd_t *pmdp)
> >> diff --git a/mm/rmap.c b/mm/rmap.c
> >> index 7b9879ef442d9..69acabd763da4 100644
> >> --- a/mm/rmap.c
> >> +++ b/mm/rmap.c
> >> @@ -811,6 +811,32 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
> >>  	return pmd;
> >>  }
> >>
> >> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >> +/*
> >> + * Returns the actual pud_t* where we expect 'address' to be mapped from, or
> >> + * NULL if it doesn't exist.  No guarantees / checks on what the pud_t*
> >> + * represents.
> >> + */
> >> +pud_t *mm_find_pud(struct mm_struct *mm, unsigned long address)
> >
> > This series seems to be full of copy/paste.
> >
> > It's just not acceptable given the state of THP code as I said in reply to
> > the cover letter - you need to _refactor_ the code.
> >
> > The code is bug-prone and difficult to maintain as-is, your series has to
> > improve the technical debt, not add to it.
> >
>
> In some cases we might not be able to avoid the copy, but this is definitely
> a place where we dont need to. I will change here. Thanks!

I disagree, see above :) But thanks on this one

>
> >> +{
> >> +	pgd_t *pgd;
> >> +	p4d_t *p4d;
> >> +	pud_t *pud = NULL;
> >> +
> >> +	pgd = pgd_offset(mm, address);
> >> +	if (!pgd_present(*pgd))
> >> +		goto out;
> >> +
> >> +	p4d = p4d_offset(pgd, address);
> >> +	if (!p4d_present(*p4d))
> >> +		goto out;
> >> +
> >> +	pud = pud_offset(p4d, address);
> >> +out:
> >> +	return pud;
> >> +}
> >> +#endif
> >> +
> >>  struct folio_referenced_arg {
> >>  	int mapcount;
> >>  	int referenced;
> >> @@ -1415,11 +1441,7 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
> >>  			SetPageAnonExclusive(page);
> >>  			break;
> >>  		case PGTABLE_LEVEL_PUD:
> >> -			/*
> >> -			 * Keep the compiler happy, we don't support anonymous
> >> -			 * PUD mappings.
> >> -			 */
> >> -			WARN_ON_ONCE(1);
> >> +			SetPageAnonExclusive(page);
> >>  			break;
> >>  		default:
> >>  			BUILD_BUG();
> >> @@ -1503,6 +1525,31 @@ void folio_add_anon_rmap_pmd(struct folio *folio, struct page *page,
> >>  #endif
> >>  }
> >>
> >> +/**
> >> + * folio_add_anon_rmap_pud - add a PUD mapping to a page range of an anon folio
> >> + * @folio:	The folio to add the mapping to
> >> + * @page:	The first page to add
> >> + * @vma:	The vm area in which the mapping is added
> >> + * @address:	The user virtual address of the first page to map
> >> + * @flags:	The rmap flags
> >> + *
> >> + * The page range of folio is defined by [first_page, first_page + HPAGE_PUD_NR)
> >> + *
> >> + * The caller needs to hold the page table lock, and the page must be locked in
> >> + * the anon_vma case: to serialize mapping,index checking after setting.
> >> + */
> >> +void folio_add_anon_rmap_pud(struct folio *folio, struct page *page,
> >> +		struct vm_area_struct *vma, unsigned long address, rmap_t flags)
> >> +{
> >> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
> >> +	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> >> +	__folio_add_anon_rmap(folio, page, HPAGE_PUD_NR, vma, address, flags,
> >> +			      PGTABLE_LEVEL_PUD);
> >> +#else
> >> +	WARN_ON_ONCE(true);
> >> +#endif
> >> +}
> >
> > More copy/paste... Maybe unavoidable in this case, but be good to try.
> >
> >> +
> >>  /**
> >>   * folio_add_new_anon_rmap - Add mapping to a new anonymous folio.
> >>   * @folio:	The folio to add the mapping to.
> >> @@ -1934,6 +1981,20 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >>  		}
> >>
> >>  		if (!pvmw.pte) {
> >> +			/*
> >> +			 * Check for PUD-mapped THP first.
> >> +			 * If we have a PUD mapping and TTU_SPLIT_HUGE_PUD is set,
> >> +			 * split the PUD to PMD level and restart the walk.
> >> +			 */
> >
> > This is literally describing the code below, it's not useful.
>
> Ack, Will remove this comment, Thanks!

Thanks

> >
> >> +			if (pvmw.pud && pud_trans_huge(*pvmw.pud)) {
> >> +				if (flags & TTU_SPLIT_HUGE_PUD) {
> >> +					split_huge_pud_locked(vma, pvmw.pud, pvmw.address);
> >> +					flags &= ~TTU_SPLIT_HUGE_PUD;
> >> +					page_vma_mapped_walk_restart(&pvmw);
> >> +					continue;
> >> +				}
> >> +			}
> >> +
> >>  			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
> >>  				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
> >>  					goto walk_done;
> >> @@ -2325,6 +2386,27 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
> >>  	mmu_notifier_invalidate_range_start(&range);
> >>
> >>  	while (page_vma_mapped_walk(&pvmw)) {
> >> +		/* Handle PUD-mapped THP first */
> >
> > How did/will this interact with DAX, VFIO PUD THP?
>
> It wont interact with DAX. try_to_migrate does the below and just returns:
>
> 	if (folio_is_zone_device(folio) &&
> 	    (!folio_is_device_private(folio) && !folio_is_device_coherent(folio)))
> 		return;
>
> so DAX would never reach here.

Hmm folio_is_zone_device() always returns true for DAX?

Also that's just one rmap call right?

>
> I think vfio pages are pinned and therefore cant be migrated? (I have
> not looked at vfio code, I will try to get a better understanding tomorrow,
> but please let me know if that sounds wrong.)

OK I've not dug into this either please do check, and be good really to test
this code vs. actual DAX/VFIO scenarios if you can find a way to test that, thanks!

>
>
> >
> >> +		if (!pvmw.pte && !pvmw.pmd) {
> >> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >
> > Won't pud_trans_huge() imply this...
> >
>
> Agreed, I think it should cover it.
Thanks!

>
> >> +			/*
> >> +			 * PUD-mapped THP: skip migration to preserve the huge
> >> +			 * page. Splitting would defeat the purpose of PUD THPs.
> >> +			 * Return false to indicate migration failure, which
> >> +			 * will cause alloc_contig_range() to try a different
> >> +			 * memory region.
> >> +			 */
> >> +			if (pvmw.pud && pud_trans_huge(*pvmw.pud)) {
> >> +				page_vma_mapped_walk_done(&pvmw);
> >> +				ret = false;
> >> +				break;
> >> +			}
> >> +#endif
> >> +			/* Unexpected state: !pte && !pmd but not a PUD THP */
> >> +			page_vma_mapped_walk_done(&pvmw);
> >> +			break;
> >> +		}
> >> +
> >>  		/* PMD-mapped THP migration entry */
> >>  		if (!pvmw.pte) {
> >>  			__maybe_unused unsigned long pfn;
> >> @@ -2607,10 +2689,10 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
> >>
> >>  	/*
> >>  	 * Migration always ignores mlock and only supports TTU_RMAP_LOCKED and
> >> -	 * TTU_SPLIT_HUGE_PMD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
> >> +	 * TTU_SPLIT_HUGE_PMD, TTU_SPLIT_HUGE_PUD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
> >>  	 */
> >>  	if (WARN_ON_ONCE(flags & ~(TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
> >> -					TTU_SYNC | TTU_BATCH_FLUSH)))
> >> +					TTU_SPLIT_HUGE_PUD | TTU_SYNC | TTU_BATCH_FLUSH)))
> >>  		return;
> >>
> >>  	if (folio_is_zone_device(folio) &&
> >> --
> >> 2.47.3
> >>
> >
> > This isn't a final review, I'll have to look more thoroughly through here
> > over time and you're going to have to be patient in general :)
> >
> > Cheers, Lorenzo
>
>
> Thanks for the review, this is awesome!

Ack, will do more when I have time, and obviously you're getting a lot of input
from others too.

Be good to get a summary at next THP cabal ;)

>
>
> [1] https://lore.kernel.org/all/20f92576-e932-435f-bb7b-de49eb84b012@gmail.com/
> [2] https://lore.kernel.org/all/05d5918f-b61b-4091-b8c6-20eebfffc3c4@gmail.com/
> [3] https://lore.kernel.org/all/2efaa5ed-bd09-41f0-9c07-5cd6cccc4595@gmail.com/
>
>
>

cheers, Lorenzo

