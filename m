Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B76B4EE6B44
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C4E6B0005; Fri,  6 Feb 2026 12:38:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23AF16B0089; Fri,  6 Feb 2026 12:38:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB0E6B0092; Fri,  6 Feb 2026 12:38:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E9F456B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:38:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2402D59C0
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:38:46 +0000 (UTC)
X-FDA: 84414741852.30.07DF1B3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 336008000F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:38:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F2xOupG5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uyk46kzV;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770399523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/eUZlaG4oDGMHjZytTnWU2DYLa8LgMQlIrsOYUiDEA=;
	b=TvwldEaVS27+eCSVdFjMS6fzHkFcWcjtiUDYpBUuBJf+m5RkBM3yyyAEFm5ya1cER2hmZD
	o3C0fTla3Qji4O1ntqb2p7QcU9v3Iw4o3nDJh15q+YWma8U0fAmLTmfnbbzZGE0I6UmcWt
	Z0dHzeaxB7uXL9zW5ofrHu4t2g6nK+I=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F2xOupG5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uyk46kzV;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770399523; a=rsa-sha256;
	cv=pass;
	b=KnC5UILXazegDxsQ9JPon6qNszzBZW9groQlAbbG9L1w/whK6PzyimErhkR9ndN+jcExQp
	103oJZsdaVO+kMiCLqTZTSmU71JMlScwF4zOEKWEjz9H6Z/WRV0VHJvcy+dpJdP7o87Bc5
	2Ad3IpXjw7LGd0bzAMhhEMpgzs9FYBs=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 616EvKMS3198157;
	Fri, 6 Feb 2026 17:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8/eUZlaG4oDGMHjZyt
	TnWU2DYLa8LgMQlIrsOYUiDEA=; b=F2xOupG5zQcO7wF2htT/uz48Dwb1rklpEl
	m/Vc4YwfYjcrNQgHAWHcnPel1Jq48liSlu+ICcVhKO+TXBKIO2BU1RHu1/W2C+wq
	3c8YIe/egkJdKAatkVffCbdmdi7lwy9YS1ue80xs2G6yGYAthJm4QdmR+3GZx+n1
	FUqpNPm/xFa0XJGiIzUd0+cHWjlvb1dA7eMje83OkZlQZ+QyNa55W+o6SEpAZfVp
	qkkm2m6MKlQnwTv0MDH64sHm40dptjqRV3kmNNXnlzUvIFWcjz83HkhbCfZjXnLX
	2Laohz2CMs3vs6LMoP8x6UOS5n+8gxEz9aVDz19hUk8il8Mk/0MA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c50fmhk07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 17:38:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 616GSv8W003215;
	Fri, 6 Feb 2026 17:38:37 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011034.outbound.protection.outlook.com [40.93.194.34])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186sdd0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 17:38:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L+ZZiWME7Q9oQaE849qk3nV6QrOwjFmYqFtCB/vvlMl6vegdOHAPc6lnt5M7ySAiWnKHmF64obOmrtjWQ5kVMFoP1Uaz8CJ3Rs8q977/Tw+nYfWLE2oUc7o0RaDZ0oVxa6s5Knw0uR2hLWH+gpHGHKHqydbAbTki/cp7e1DKTyXj6J2B82LNlQBnlEjktVtSHsoxa5mzVdwyGrzPnPG5Vh1/2/DBav/BcEO/pL/F9GxrS4X/4bU4WiJnXaz12wlUPuD8uIbae1DE/mDM9bGDeZxVlb9gUrqQBwXV/L2+gb9WjI5AUTJUGive3FA6ffgVbnJp4pi7GSVowiiJMMJqUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/eUZlaG4oDGMHjZytTnWU2DYLa8LgMQlIrsOYUiDEA=;
 b=K8hFfNgdtuJfryRuzpi325WVJBB+kJPO9xFIULdB/fV2eVBZd9doETd2G+K97DZKBBaoB/2JcifIvFRv6VKQEmOIrKcMnBicOAqMsEQglbwj4iM3rwVRXt2/pgZghQngtw17gGrErWaL/MAsWbJ0HYLA9Bel8+JCJdHB+FZEGCg6fScCUL1vIXsiU6m06H7h8ohn3faj/q2PIAlieHppQsk2v8mYwla8Ngx3SccYXLVZTP1YiHkF+mWQ9hYqVlBxusLtJOcx7EQs7C+X5XdYL4+GdDm+ZdTjEqCBS4da0TOHkIaI7xcmaX/3nR2nfxcIS2+6igX9IFNJSMgensjpnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/eUZlaG4oDGMHjZytTnWU2DYLa8LgMQlIrsOYUiDEA=;
 b=uyk46kzVRrV2hV7F+NjbxHbQUA48K8qQTCRJfick2cSjWQ+kAJ9o35uRTqgfnOUTjWOl5/6xAV+Dq2BtmE0V48CSuIlXuekwGyQgtgsPHuLd7IIoJb0hqWV+A9aqpCt5N9z+c31KV3DiaH4hPE2uESFjaM5o0e8JFTjNW51lDxc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB4880.namprd10.prod.outlook.com (2603:10b6:5:3ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 17:38:09 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 17:38:08 +0000
Date: Sat, 7 Feb 2026 02:37:56 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/2] mm/slab: fix lockdep warnings with kmalloc_nolock()
Message-ID: <aYYm9ICnlB_yu7PS@hyeyoo>
References: <20260206171348.35886-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206171348.35886-1-harry.yoo@oracle.com>
X-ClientProxiedBy: SEWP216CA0018.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b6::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB4880:EE_
X-MS-Office365-Filtering-Correlation-Id: c7bfde09-4d48-44c4-9ec0-08de65a67ded
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?utQ8lKoliSdw50NWvDkcgfOOfaTIUGY5hxgF+ayZIBuYqQ8MEt/xVrRwyPHu?=
 =?us-ascii?Q?x5gntg7Fd1UpIm8avA7cqbwIfL2RsBGRz/ZRnqXKc/yPECt9CXHFaIWUf84S?=
 =?us-ascii?Q?L7U/i4HU/mb17Iiox8fgkAxNO9x48Z8nZF3kRMnzsmsfh7/ZeiuBt5bjKPbp?=
 =?us-ascii?Q?4SW4rfmpX33cTZtNPYm0QO0Kxg+s1mm6ABP+NczOQ3AgoA0BDoF8HtUPLZQ9?=
 =?us-ascii?Q?1PobsuG+W/bHeO3yluDUalKapTKCJsuIQf3eAzHK1s0VgKpUd4ZUzPXp7KOG?=
 =?us-ascii?Q?0DlrjTyAlf+s1LI+nV6mVBa2UwKzJ2vfTYUEXKhtzFCkW3axnoDwMukFAih3?=
 =?us-ascii?Q?CwU75Tu/tLRVvryhC8d2ol4Vib4lz4hlx9ikQDSCv4AmYuuCoN3kWpOax0y2?=
 =?us-ascii?Q?WGkUGClIyh1oBM/zAqLZ0RGVCQkkxTD3lqi30LINIkOXEPubJhwzQkqmY5p7?=
 =?us-ascii?Q?rgq711Je7we8eGZJKFYqYXN6I/EtVV8pdpYF8gzM6BQj0QJWOEIIbhQxFJcH?=
 =?us-ascii?Q?e5MJ1LciDO2H4uLnmH1k20zuXZbstLZuXqGUPjgj9UKACUwJqWUBKTNlEZye?=
 =?us-ascii?Q?HST0E8QdjDwETiOOs5JZTItGavD/ykQzshPb95oyMrd0Cw7CyBZZ7TEuu85N?=
 =?us-ascii?Q?ltUP/LJ6/jGRuWlRoAk/AwW8RyTZShHVP7FKgF16KhTbC34JPqZYBHFOLpN8?=
 =?us-ascii?Q?0Cm7ZbKWpSG3Az781+kaavrrKlsD+MluiSgqgnU068Bk0RI1L37NXDBCTBZb?=
 =?us-ascii?Q?ndlNOIkoXjYS1yYizpruow18OKui9mJN9r4DYi911110gf/kV5Yo28ZdXGcG?=
 =?us-ascii?Q?UVVGUHf7NHZ45nKts1X1zJ6cXDHqAQMufwJxNUkqj1z9eg5OJurhV9i+hYRf?=
 =?us-ascii?Q?qnR2Hlc5YkBQVqMzg/KKrBsy9+xXXkN6RVOXjiJAb8sD1Q1eLlADpPDfzbBH?=
 =?us-ascii?Q?DWbCENi14QYmnLyVVagB7cd0X9BE2CfTNd6TwEhC1Km758hOt129KuWR1Fpf?=
 =?us-ascii?Q?Q9pHkmVv7LT1g5FUHz/oc7RFZVbl1oRnhb7faA2Eq44km6w/l5UFS61s+83o?=
 =?us-ascii?Q?V2oOwu67L+a4/tGS/F79a5W9bdywlcJr08pdG21BBRVYrOFlI992k9vj1q4r?=
 =?us-ascii?Q?HWUj51KLfmkCO2wyalzGdQRJBnHF+dIXLyYiyx6kmKAOyj+K8f3vfL3P2pm1?=
 =?us-ascii?Q?d73lxKenPzueTzIXeqOdglGji8oHzZPp+c8/HPb+1qjLGUEzDw9KYI25XTWe?=
 =?us-ascii?Q?W5ZEaPCzt1aPuAHpp25dpOtYtl/Jhqaz+B54PLjuTzPySWU5GXCPC5Iul2oZ?=
 =?us-ascii?Q?PD4bvGREmJxhbG9EicBd8Eww/2z4yQOdw0D+kVDRJmxrbKPvYU2avJPofrXu?=
 =?us-ascii?Q?XetQBi5TML1FTrpAnANUFGowMwaVcuvYjhP+BIFUUnR0L7CDUrehAmP6iCD9?=
 =?us-ascii?Q?QNBGuIM193dnAv18/KhIUOIK2v9DdyVukobISxAgF8+uUoR92UdR20pp7Fd0?=
 =?us-ascii?Q?5QWRoYj25oeV6x6VLpaSWMYs+QbaxRrF+CAwImiEHBHP55RqG//TymHTpVwh?=
 =?us-ascii?Q?xjNqPbnLGbYn5nnvQqI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ALuN7M7I/+RYO0rh8JuVv+mNaeDUHQ4840P5Y/41eCKd4ejhD1jCqDEtH3D4?=
 =?us-ascii?Q?6tWNjgtWNCV3U8urIdMZXTevUxwbvzw0ShcC/VIA+isnaODo9qwwEU70d2/O?=
 =?us-ascii?Q?qvzOYJa94j/ibKo4aX++VO9MfEsnlpF7mU8x0c8RVtpayRLEpR0fdb8AGPns?=
 =?us-ascii?Q?vyQAtipoeO21XH8dFykXbS3fQ/uKuHNNMfD2Hp2KL3srbBGbBgmeAEbg7hL3?=
 =?us-ascii?Q?xG38TetayOlBlPnsGuB4q7qCHl+INCYOYAt+A+gxAa5I+SBme7dz/rY7NCys?=
 =?us-ascii?Q?th2uOn85PeG/4MWHMtLEcz7iSBgWy8XI+fls42jMTEkEDEn0yWxax/6T3yAd?=
 =?us-ascii?Q?ePQOJLmK/qagrb09B7wr4W/dHah7uFnFI6mxn8eCv6AkS5Vb+V2ytAB5VMfZ?=
 =?us-ascii?Q?vG4CZO+TLgFbfibgyTAbOquJl4gO7r1iuSbRFfpZuNVjKyiCjnN38Qio7Mg4?=
 =?us-ascii?Q?SD51UwM/cMa4b/zKTKoAwWU3sjgq1u27S3fcZGEGDM26M/UDukWAN1zXKV5z?=
 =?us-ascii?Q?CQO2k2dSVyDke2EAjCc/vsPpa16cLavN9EnEAINHEMEc+VQDdcXZ6iY8ND29?=
 =?us-ascii?Q?YBKAKOsgSx64fQxWU46zQKSBVAyi/vRGGgKqF7IBmYpuUW8ZvDxJ3BUCe3F1?=
 =?us-ascii?Q?5UHRm4NfwB0CGyWttg20O0wIS+Ns0/7HZUJJRO3Nfs112B8rmNqERW94nglT?=
 =?us-ascii?Q?yKI3PyExzzwpUyXPhgLo5WjuJuptBJLyj+/G0u26dqTpu2tCt4mBm9EneWbY?=
 =?us-ascii?Q?Dt3Nc61HUv+FbzVCzsHeQXVft9Dj59IRYKLDd5CSnSevZlyMh2IqetzqMS3F?=
 =?us-ascii?Q?uT7ofIYiWRrUSnU423/a9pq9ltbFu0I7Xq3RbqvlKDFjqKNYHYaETWw+MewK?=
 =?us-ascii?Q?n3Xb8+dJHJWZrYHqKIN+5+XJVkooBQIzZ63YBisIlHoIEmcD63mETN9VoYKM?=
 =?us-ascii?Q?bnFjZmIqZpr3R77Rd5m8DQlmeYJdO0otSTXv2KGFwj5hV2ijo+0ma585tkue?=
 =?us-ascii?Q?Z+fJOyndGlZBX6CvmGKSBnzV6Mvu/heZUm/Cpz8AKFSQjSvZm2cq12uZ8lL9?=
 =?us-ascii?Q?wUAuXFbEPpkQPcNWV/rWvD84U3Sdf9hX6JOlRjusEgXcgSNrJ0ziulE/5n9r?=
 =?us-ascii?Q?Gb/RarOXyG0u9EIIffusRCrW79V0B+JcEfdhJnQcbI996X6oNEau1gjRIF+L?=
 =?us-ascii?Q?EpAAfK+l/upodK/I1024gx/abSqrE7eH+oP9Vc7n648W4dL+PWLSEtvDyRQm?=
 =?us-ascii?Q?UHMSQe0le3/LyrAC2Ig6i/GUI4tf2auMNVMAZnUnhh87pu4LKhOSrvBBoDBy?=
 =?us-ascii?Q?+/mEiKzx0C1XROhKvihdZx8+oftu/QJyIHXYgwiW9fjSyEURv+tvgBodQpWw?=
 =?us-ascii?Q?1k1oftTUiJ9sKlyVty7pBdL70bek3tyYddHiqyEjzMT+LMScU61mPzulo53A?=
 =?us-ascii?Q?0KaAx2pB9nuvO319+P7zTzwfsQ6G8OAdAEIM2L0N2UViYLjyNAZ9DunVDwp+?=
 =?us-ascii?Q?ghxUccguxn92dJ6O9vAZzT8DJqH7mjTbVtYEcirdvOYi8ik8xfcyX+w3G0Y1?=
 =?us-ascii?Q?daBXZxkWGxm0hRUUZq8v0maALP5jRXrGLw4eO9XoCcuxGhIbRGmiFrtVw7/e?=
 =?us-ascii?Q?poJMLo3sF/uCXsDtgvLl6C6E2DJ3JoQMfZnHt5FviUAbcg00lO88VGCLVZCY?=
 =?us-ascii?Q?0v/M13F9YU0/v+AYQgvwh74nhH4YNqUMErjM+r+PAWA9fMiM1MfF55ZgvfSa?=
 =?us-ascii?Q?JOUxA4WzgQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qeVQv45FgCW2WOrSJahJ1w+OXxNxAQeYt1PVr8yke4fPhk116FQY8n2Zmilh9Xxk71nSaJRp77IPqYjs4GWaeFtc3SEIsvLOJdKbYhnYT/tCIIlRRzXL0QXrcuIz0+fplScysOa1xd8G48B5aaS3GX94P2z20/IZMtFHaZGw3TPB9NoK3xE86wImCAtcWFQX1u0fBZq+nPWp9s3E7qoUlIpG2t/aWv3fQenj5EH/pJVLG5XZ+mpjNimffW9i9Zyls42M5u9BJa7NxiD5iVyRU0L6wBnIARDVlCLgLhk1tV5GbLlGpV2uE8LDczHK7u/GuS88PKrmlM+PPLagG0+ikwn7WqZmNbdCXu/iQrNH6WJdaKMx3NZNXF7ZWVpL3rl/9dF0UuhfERCBeNx2j6BXQvhBAG+FyG0lcw+wnQeuGYhqHOywBlnMXreqg3IgXOD6/GMxKygbLcT8CHYwzY/uD1uZUyEsO54iX3VRp6npXCSDhPSkNMKYotdiZZ5Pqp1mVAZYMtDOOrCXVt59BxU38K6EORzIBQcA4xCu3IRcriBg4wMCumYyTKWHxbKNRLvR7C34Hf+8caewS29Bw12tDPMgdWc3gTV5+eEcpNRz2Nc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7bfde09-4d48-44c4-9ec0-08de65a67ded
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 17:38:08.8582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+hKFigINQI7KxfGEbRG7Q4GNwg0hevt/apMK8NDMB6Z95C0JjRTYzdz5/AHPA1r5RHFqh/Pc0xgW1N9/Vnfmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4880
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602060129
X-Proofpoint-ORIG-GUID: 9EAhKUt7YeJbGYbCQ87ozlstirNadNUU
X-Proofpoint-GUID: 9EAhKUt7YeJbGYbCQ87ozlstirNadNUU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDEyOSBTYWx0ZWRfX+wZkgXEkhdKe
 eXfp2NtoOHQjTJ8j/dYFS7TKFG+YtdfCM10MZmZOIfYM3VzhjbbO6EvwrfIWW5z0HHpZnE5IBlN
 //njBav4fToG0De1I7nboKFf8bOEtT2Na7hlbiRg4+HdLKL/q2kh9xzq+lNXpTMcph6tfHclK34
 ScNXgujRHf7sWqcQJcrtLPIbjDk3v+K9a7uXkbvkZsJHjwH9xNHRzN7GYpH0gHKEhL4Q6WPOMls
 TOJWmfmWBwIu37rO6ErBulRTn/GZ4aVtS0FhrjnAeoBOrgoAOBQA12/5Cf6eqNSVRr94Ejj+Rxw
 ScJfjnUIIDXkVd6YIczypdWQiVXxzBImN7qwzGPKpedKgU5lvimRnu5AChLZOG/oIfbhXRQDCJx
 XQ0k2cALJ7W/Z0U2rXSUg0ICjSLMNqS3wy9klSeFEIoaAJAgvJAMz+oImpgOrEmV25b6mY/UTbN
 JgNow576uSR3V3T/gBYr9InsjA2fhRg35GTpNXis=
X-Authority-Analysis: v=2.4 cv=BcbVE7t2 c=1 sm=1 tr=0 ts=6986271e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=rVBAb-3SQB31SjRu7esA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12103
X-Rspamd-Server: rspam12
X-Stat-Signature: h4h3sbifcs8fc6tgeh6aj8us6tgsqjt8
X-Rspamd-Queue-Id: 336008000F
X-Rspam-User: 
X-HE-Tag: 1770399523-760907
X-HE-Meta: U2FsdGVkX1/mALbxuIfEM5embTcP+SvwQA9TGNvN9GogSloyuWseCyPzHyr7nXe+UwrSb5f45FubaBINFUbrPQkZcSYluHTgqStt2rKYRkExYI8slBvEhsX6E7wxFCRh762PVlLmO7fj7kXp42tV3Ph2GS5vQO+1YyN/d9ZuNsDiXjPtA3I9fBaU7cPWtqnVYcDGa5EpnM9f7jOEhkjo/vvYhjaGS7yOlkTWIlk1hqrznAUBIkUsQD7rE0cVNhcTAYs4sQh+u06eTY72TwzG1fvHI1pEv5D/NJuxhYvYhhn/W4OgqOX+nFj1UaYMl1wDBvwKQRGux8ZGHI1yJ065Dq9vI7q06pevfH91u96IA2un7+sHQ2GjZd9MA1Co7Z29eWE9esyFMC5GCWzsvn0ck9yPchci8ivSoyaeFG8xr4Z21fh4bqMa/WS5g5zfAhITeslLUGSThRph092UPql6aJlD1kYlF87lmC6I4GmuJMSWpd/vjWqGu/amD5e4c6uF8/H6heIcEUOzBJLv5m/CwJmqwHGQj+Zg4jeP3VbJ94wCOblTstnl77pwP0V9gKXVXewo4OrFTL8WwDAwOyjWqFcTUUGGjQX/683+37Ay2mE6LRsb3e5N8bjxOpvDQoO5ooK3rvSGE9fy0poSHmMnu5pU0fGDsQ7j/1ixJJYvgqtHlzpuDtmztVDn4xAZriRslkOQQtRJE3yS3vF/80+aWbkISs4/aOVMgyPdu04ashdJYOl33VzQnw8DGjnhqs6nai4MQkPaaKmiUxzP+b+KvPdjPc6Hr2psNM4n6FPXIvtDQgrKj4ufUAFG9pEu+abJLadopB9Bib6i1hvP0AKtYj68am/uZG4pFA3OvRikc7q6U8coW5db8+NlOH3DA33zoYI+dV1eAGYapD2yY3D5NkrPL67YD6wuXvahaAF/nWl9jClIwoyEw9nKR6DS9YBVC67UmZFoJCUSOYFhIJr
 fnHLz6Hw
 IEuD4pWcpWunZC/6/TH8ciImZRMfOd5a+S4CWXBVkL7fI6xKbOoGk/phutD9z3ZkGxVUPj5VCcI/aI8zemH5VCTd1nJ0Gfzol9nzzTgVn5RXtrs0GWGBE8YA+RayZIAmHpNbke2irrwD+lKs+a+6gMZoOu3KOmycd4RtDJJRzrJDj8FhwyxTcXdz13oMhXWSyrFWaCB3U3ZInhRKd7obb56k+NXg/8Gc9qltLHyYjrtqVN+WIkxb024R4oFnFXnEdsKi1C4Z8hI3rY4JnCbF/thuyVfDFjFaFg4vs8V2d+yC6EGrKxMdctW5fy0huOXvx2IcsSI7qGNaWQ9sDLc4wGnHbGWkQpwdL49ft+N+mfxuyEt50oUoTwFRMn3BWOdduMR6hzpiySxA0OVRSCav6zSB4qIVJnSmaXYLGdbJ4/BNu1am4RSHGv5ptWUjkOx+UmPrKZ0uLJfoW9fg6IGsJ3hh1pabuEzikrZISVw1UY3rIIamvy1BnZzf8oDeLp2X+utjTd5yhDKLrjPNJk//x9+mmdxiaNlRSeFfTWnAUtX6xNiegTJjA1xTIuAGvlWCxDfe7E/78BO36GCpuMBkI5+F5TS+vWoKmc3syFEHp1JXr8VbFKFQH9NB604Ua8sSDaLWvDnwQErSZh6qWXrOFrlgg6WS78awYQ9eu/O9YJrwEsNoZGfBeRTCv62jU8WiiwvcmHMalkIIgSHc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 07, 2026 at 02:13:46AM +0900, Harry Yoo wrote:
> Hi, I've observed a tw lockdep warnings while testing
> kmalloc_nolock() in NMI:
> 
>   1. Accessing current->mems_allowed_seq seqlock in NMI isn't safe
>      and lockdep complains.
> 
>   2. w/ CONFIG_SLAB_FREELIST_RANDOM, get_random_u32() acquires
>      a local_lock, which isn't safe in NMI and could cause a deadlock.
> 
> Let's fix them.

I think we should probably add some sort of
kmalloc_nolock()/kfree_nolock() test cases in lib/tests/slub_kunit.c.

These haven't been discovered by bots because (I guess) it is very
unlikely for bots to somehow trigger those APIs in NMI.

Also, I forgot to mention that this is based on slab/for-next:

commit bc33906024eb5955294e28128c3d0f492d2ded5e
Merge: ec15c383fcda 40fd0acc45d0
Author: Vlastimil Babka <vbabka@suse.cz>
Date:   Thu Jan 29 10:10:50 2026 +0100

    Merge branch 'slab/for-7.0/sheaves' into slab/for-next

> Harry Yoo (2):
>   mm/slab: skip get_from_any_partial() if !allow_spin
>   mm/slab: use prandom if !allow_spin
> 
>  mm/slub.c | 36 ++++++++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)
> 
> -- 
> 2.43.0
> 

-- 
Cheers,
Harry / Hyeonggon

