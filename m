Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D26CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CCCB8E011A; Thu, 18 Sep 2025 09:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D608E0112; Thu, 18 Sep 2025 09:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21ED88E011A; Thu, 18 Sep 2025 09:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2178E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:31:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7C25140163
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:31:09 +0000 (UTC)
X-FDA: 83902457058.28.D714E23
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 35F1F10000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:31:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eDKxkTrx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sUhfY8Dr;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758202266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5fbKzBd+GYf3Fe1BG1bT0MDduCZw61uWe2MMqoIWEis=;
	b=JkqlGKl7p1ekPsJvsT0JecIpPsxBdCf8YJuI5btPKFpdC5pQuBO7k8Xq1PF17ht5oBZkfa
	HmAkfhAvAeELXc16IxVs6j4NeFaNpV591ed/zXwIHJOYKLMa01MQQ2dOYT7xXluwh1Qjod
	SF7KokSMitIHjZssuY3b8LqPChuOebY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758202266; a=rsa-sha256;
	cv=pass;
	b=cODyojVIzq5nsMfy3l65+5/TX7G5mGAEON01Mrt9gQoRPa94do4CoTpR7E3IJuyDM1Hg8p
	gykR+BsbwvRGluMaqKx5TBJKTyDr2TvRzjHPcCIbSQdOIPUs6YPuoyvuw/QLQmqfBeNxIU
	fCd/ar0G1Dh9ewk04Qczah6Z6xisJ5Q=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eDKxkTrx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sUhfY8Dr;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7grIB003450;
	Thu, 18 Sep 2025 13:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5fbKzBd+GYf3Fe1BG1
	bT0MDduCZw61uWe2MMqoIWEis=; b=eDKxkTrxWhbFJWDc33BfA64bc3dFMA1PpH
	u7S2HydQuzYPQqoUsqGI5T6QjtnV1OSpGn4Z+bXZzF80FN6R8ryTCSxPNpQzoWHN
	TtllFVAYraU7cJ80w9Qm44uctE1LTg/g+93JxKTfs7ie/5P4jbOP6ZcKVXgCWLfc
	+4m5CrJ1veM7CF+SEbPEUoBNL4Iig2nYYPjiMJfqAwmq72XfpkM65dMVawyu7pDe
	ROVwQ4FnkrpTCxeIG/eGijNPzUB3cCb3BtAcD9rHokhLX+GUEibp8XYsz3KW0KsI
	PcgjoViBCozMyB6tAputo7dWjcFOoKO5peorYKIbyq4Jh1Pw/I8A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx93edx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 13:30:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58IDQiZd036766;
	Thu, 18 Sep 2025 13:30:49 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011061.outbound.protection.outlook.com [52.101.57.61])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2f5pnj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 13:30:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rsQhA1DS7weLDiwTblfvQRFclLlEi1OlB6mNClApIbz8AbEZwXb0pRYUB5l5cQ0AJq4AiVoZRLLNzHglQCbwGNwUJBUaudzfHEUS29JHDKWxJzVrvHNnrLHY9dc6G+HVITW96oWK4+04VBoZ0eYrigZIRME8tL43Fvo06wRSSEnwB3ypRcO17xiCvOmJ/KDJOK/wbKvMrTlGr830ab155Q4UDwNoG5eJc8fwlHuoTBrOLXdgF7wYCsy9Ppom/W3dQCYcK47Xr/RtNYW6cOh3oUjxKMtEJsFDN/h3Ylkoo/baukVOkyo9180yTiaEAfjf5PRAhSUoQRp4CvwMV1u4kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5fbKzBd+GYf3Fe1BG1bT0MDduCZw61uWe2MMqoIWEis=;
 b=JLZ9pgg2FVnyJrFhP9YB/HvlrAk4W0sJ3rmXsnP5Ni5UW4wcGPfvzbfaJsumf4bNgYfCrPAAfDG2BwKbOVpvbznHPo4DoaGiaVeKmuBrlFb2MMRz9kKXMry2VEn0+Im7ZTgoIH9Vpym730DPiNVIvgRWucSQvCjY224sQlu5Y+WFG2aWM/jaAJpSubrWn3WmKjos8HP/h+XVUSb21w+KSnH4B9kcWSkAon1/0QQEwJMyhW+O3CYtDxM3On2vg+t8bWOIkWkzHKZKtoFUUx1DjAr8ImDBvJwesbXG9iB7/ioI4+setMe5BMMZoeXTqMP/DU+I1rkjCC5+yGPFe3qRDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5fbKzBd+GYf3Fe1BG1bT0MDduCZw61uWe2MMqoIWEis=;
 b=sUhfY8DrKEAz0U77JPbE7uygw1IalWTfeL7bvsPKdmXGzv6NDZy8FbsfLbGqbfjpAPuEBFC+tAom0Jz71IDdz03sLOogFbehSRc4TZObVbHFxgicQpWIRt87MFSuB1SrG3RmxCWheVBK7q62LwVDZZeYYHhE0Jir0M0QRfHPNQQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB4923.namprd10.prod.outlook.com (2603:10b6:610:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 13:30:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 13:30:46 +0000
Date: Thu, 18 Sep 2025 14:30:44 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, david@redhat.com,
        Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de,
        kernel-team@android.com, android-mm@google.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 6/7] mm: add assertion for VMA count limit
Message-ID: <a582d334-3fd2-4364-9e5f-cf0383d1c119@lucifer.local>
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-7-kaleshsingh@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915163838.631445-7-kaleshsingh@google.com>
X-ClientProxiedBy: LO6P123CA0005.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB4923:EE_
X-MS-Office365-Filtering-Correlation-Id: c8b1a964-b108-46ca-e708-08ddf6b7933d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2GCKfSOwqfcuf51sQKf4KCWB6KRqKt4a95yvH+XGwPL4M0yxP21MXhn/js0v?=
 =?us-ascii?Q?9gJatrz429EL8BDG89U93cUoCHu0z5YRtKezcZ+1enUQHt6V7ujZuVzoMODA?=
 =?us-ascii?Q?P3nCx8cypXuDWmsFKxchjrZApQG2IMF4E8BRZepvtBY5b0ocdZRH/QCfwbyO?=
 =?us-ascii?Q?pZeoF8VKjsGjXiRNA4pwoMn6ZvLZOgEUIWpILs7nCIc+bigdrCQTOpv/v14F?=
 =?us-ascii?Q?n/RwqZKkfVwFY4qKBPL1wWTBzYI0oCLaVaxjBZJ2mKYp8bmAOqJrSX0WATUy?=
 =?us-ascii?Q?mUYDc6Bs7YwcXGyqEGfoWt7265Rv1Vt/fC23oAUaMEp3k2KFQu9YlpFqSW++?=
 =?us-ascii?Q?EQTPIFNKh2eM8RJ13apJl0cJZ3ZLirATdy8/4BoURnN75167+kR7Xdm6FNDH?=
 =?us-ascii?Q?MmYoYyAcZUGHFY/+WQbJ0w9mPnzs1ljLqdLyPtHHUVKaZ1NYt7rvPZaAV0N8?=
 =?us-ascii?Q?j6dZ+7RKNPCRU91U29j1LAZHPrVTh+oH44x97hbgpXkFZ8UTXc8Z+Td9WKin?=
 =?us-ascii?Q?94idTUOqmYwe2wFvCxb5L2csDbRo5PUPtNePIUrHRG/Gzbsm5prqYYT1kUIv?=
 =?us-ascii?Q?+thkkxJcWZcWV0UMuHLXbhx34bnSq390Ove+cYlTxifnezCWwVqzfOCA8mS0?=
 =?us-ascii?Q?KP74t33obSu+L8JWntLTZWY1NhUdVPsvZ6WVLm3TBI7sYIb4BZMwnKQ8idlW?=
 =?us-ascii?Q?WaS4hSDkswt69Ren3Wm1Tvax7FFqFp0UjnzjMfLeUgE+Y5bG2o+Po+hTCoMX?=
 =?us-ascii?Q?WLJQn0+mYz0COu/XcZiNeTIAcvTlhg92lt0+20tKMuOmZBV3awjHm8pKIkRP?=
 =?us-ascii?Q?qobcwBSAwQtPFWwKBg945n0XOHKPsrlohbQdgKl8a0gM8BHR5wLncMXNsjsJ?=
 =?us-ascii?Q?5qirMQXxtG9tSnWt/5t2t7kVK9rBQ60WsZ8zM2H8bjAIDU7uHX64PIx/tnvT?=
 =?us-ascii?Q?KlcYyAI51UGxCn6p4va/cdw+za5froO3Bo3FT7yYSgcE3DKYgm+lwKS+kKMp?=
 =?us-ascii?Q?y+EN+Oo0Jg5DBN3SvPxGfqp1Uj+QGCGhSW52tPYC8ndfp2zK8LByl3DRkDJW?=
 =?us-ascii?Q?Gni4u53iZBRBEZxrJw53XSBC5xJwipQSz8JuPN4gwBua0N2SC0yjCVP/9Ydk?=
 =?us-ascii?Q?ThIQgAEbY+Z/jRcNfVkBfhYMMuELSx/IbhHUk0RrNrXZxJr3EHDpEXf75un8?=
 =?us-ascii?Q?aDiIIE4Lm84q7vZ3BXGMdEwUvBtBLgA9EIBM43v5DR5PQCiwHyvIpSWjiSkq?=
 =?us-ascii?Q?45QxCBfBcnQFD2wlKKInbAIrHfiq9SZ76UEVJopAn7hifi36Ltu+q0bnH9ku?=
 =?us-ascii?Q?FOAhlXHxp/mueEAU9jVnYzf07qm/JZBAPJcq12DyIdZpTjcQdSKaCUzdM7dc?=
 =?us-ascii?Q?B/LARWHjyC47e29IynFW567RtRsAeVa4P2rmRy+VkLNTyoWECw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f+xc4nHn+fc4hbb8rWctpCiVkoiVloO0vTKhcGI2gOP/Lrdlb3xDtmro6Uai?=
 =?us-ascii?Q?nid4jZ1NMYjBSa4lQsRWsAKDTeUPU/rvKTjZhtB7c2o2mAi0Z7GYC8jzJ8Is?=
 =?us-ascii?Q?UXPvURqe9YhaiHQYU0XscTxGwYwHSXGUFymT7YfjkyJulgs0nBXWewRGKKfD?=
 =?us-ascii?Q?IqDtn9tOwa2y9JDS+V3r+QqoZm7WVL7Pd6+4QwcqvBWITI/kxqrD8h9WtwiW?=
 =?us-ascii?Q?Xh3syu1//5X5cT+2ySybArA1XHhEkTpQOIZ/DzivliW2GhxqTGqerkJlBUnX?=
 =?us-ascii?Q?aWmyucqhDLvE5dYR+xqk9jaMWP3pB4XqwWbwMcXJVKbFXeZO1fZOjjNzCkRH?=
 =?us-ascii?Q?adWV3Vk+V4ejHWHNrC4bdjkAarcWlUBkE8aqp0TgXYVfSn+KeOu9Ecs+Sho8?=
 =?us-ascii?Q?ciNwxKEjG4/zIEL6WsV3VF/PPb6BZcPTKrAwTTdqVmSTh70+jEBglBPo7stD?=
 =?us-ascii?Q?tTz9M8ORgSBtLH7Vj+g/hxlNgJRlCDtOXDKxiNPMVv4G6ADPs7pvcv4YAVUf?=
 =?us-ascii?Q?hEAK0nfpl7icB4Saw2xj5H/fHOnlPfgkD/3zUERDtI1uwvXUAO5cOx5EhbJ4?=
 =?us-ascii?Q?Nk10s0lePjD4Qr3ufwObqWJE35h4dewcfZkdBRIRBUcp78aZzjb2vSsePAy/?=
 =?us-ascii?Q?c7yAMm3i5u18qMdN3jTP263V2lUl0yB5aqWJHdP+Ki2WtbDc5lRhEP5u4zbs?=
 =?us-ascii?Q?OK1GTIMM3j92xThcmmv3cpf9zbFCBpWQ83elPSmqWAbEQpOskQqj8jXLFQiB?=
 =?us-ascii?Q?u15baN8OkbfF1Qc0FY+fZuoudL22fZff7b3UbzSVr7i1vVsowF2ftIOBSGWS?=
 =?us-ascii?Q?bUuEDfGSZU/g6jx24W+mC54D2mf2b4flsFRgHVFxtfkqpRBKKn7cG08p+tdP?=
 =?us-ascii?Q?29D7Zp/ZtwtpTg9TGMoijHVB1aX5GBr/kKxDd/rGE2pL5VeaaS+uumgQD0Yg?=
 =?us-ascii?Q?PWynyV6acUYgkb/0ef75eDiU3LnnsFATK4MNLdASA379Q8mRLHIbKASg269F?=
 =?us-ascii?Q?R58xqm7l+8QqOPu9MZqe82/Hbj8pv3KwhPTjsopDuZnzbeufVjBKjkNBqIXX?=
 =?us-ascii?Q?AzQFtgv0ej3phihyiv21YGwO1LHw4w25tO52n54n9lVMFwnrziUoDx5s1eJN?=
 =?us-ascii?Q?gPpWTN5+yrT7YfnZUlsOEZr5yeApYLzpy2g4hZEICydNJjf3EdyAbVlyDhAV?=
 =?us-ascii?Q?krboQispys1/qEd7iq6KV00ybYQ6nGGDe4JtmcqrV0k3X81Gp5igUjPTOxck?=
 =?us-ascii?Q?5roG8l9Z6JcHbTVLLO8V0lsDXCOC/2cNZgA7bYLMxi8Shq09DFWFrfhH2+g+?=
 =?us-ascii?Q?q9DfdWmqeWRjaVIk21gcBmyrqZWos6q8qF7ZST4wyaRSru1SgekhjMLVPD/x?=
 =?us-ascii?Q?vhsAEQl1jJOS2PYLwudRb4eG95mhDJ4035zItO8/d9NMuKlaiQ8St3iqFoDH?=
 =?us-ascii?Q?ZDJd6pT7YiX8aD3+AVA2o3CkD8VHeu4gDFB+EvcDF/cjH7epIoUaHUrDZaVX?=
 =?us-ascii?Q?LPqQ9HjCyfXAbVNOPyi+5drAn66qucWtDD6titMJGu9xHJsFmBN/OIxIQOth?=
 =?us-ascii?Q?2FlLWvJUZMVaE6upPhMSdXC+yZFsl6yrY/z8IrJq8t8yELWQYTPLTTn08MHX?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kIOO84chgWOG6zl3zjSTxQbHpFH9l92sxA+E9TSGtjrtOoD91zbCcV9kNeRg2Pw0+8hIEZOUpK0QCcQEC0hV4u/3YyNf26xLCQefT12JMuiCkZ7U04Mzy+zLRaesEDemDpHHKiHkL9Rz6HSCc88o9E86/p/Bbjub3ex3RUssBfGTKIjxuh9WiVbL1xPAT+M0fTh0GGvVfcfiAaLzs3DkfKoGpW5v3W/JwmGK4ivp9pqJxUNW3NvueXWbL/rsOiGYxMLd/qN/Czf7eSIT4riKz8/mTCDjpWAC/xjHY/zxzCyx3BJcz0dBPJERCRMthrYXU7bZ0rJUvZ0EK4S+BH3CZUf2MZMnGELYlHM9xP28Z5Mjk06bosqjJ+6KEmXKPxowCJwED1GJxZlV/mGMILmnEPcocbtmtFLsZJc0GoI/mQ1EqoS9DILQzr0mYLTyu8370qhfIz/d85Jc6gsibVf6TS7jBYLOjOCGee1o9n7WNfG9S/RNAlEOpOjTY6uhoPPh/0AZSom7C11G1Z69vUUTu522qlICEsrCaab8FJnAfi+tYDJTOdbugozKzzX1zeu5/qUXW8bEsrVPcGvHZMzvhld5jRQVIstmrsAxMfJRhl0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b1a964-b108-46ca-e708-08ddf6b7933d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 13:30:46.6873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /piK9EPo3nEtF3a6SI6D/R+zNsibWlgDY+/wSgb430u/cQ+zC53rKZd5whtmHn9QRRl8GnDIfcykWxxhUzjaF0OYL1u6bFl62GatIm29coM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4923
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=826 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180126
X-Proofpoint-ORIG-GUID: k0AWgcECeH2m8baLSz4QJDTZg1JsNus7
X-Proofpoint-GUID: k0AWgcECeH2m8baLSz4QJDTZg1JsNus7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX3NsFqJXJxVq8
 Nbo+MX21KIOAwknT/D3VtjTXYDfN5CFDmYcRYoWoHLIn34uDCotHb2nSrWzoLsTSeaCpDSPFNW6
 I6mabxa80F+YB4lWweRfg58GQSTFZjuxhLghCc+MfdNadkpLtQvGzv0veCghBz2/hXfwNG1sqVn
 d/q8nSlT8UYX9t8jxYkgW81nWgW6eyG1AUQU5ajfqZPqXA9DVP0auLoASlpTawA/SERzgEW0wEn
 oTBwAE7Fnqz/06K/McGXOCeVyHhM8pZOabuerknDIYKAnXEWAMXoX6EOxY8pCKRRwtDR4llR4nZ
 k1ojpccuMMIUwoByrkukMTAQYTUNafsg2IDgm9uCLAmsn43Lro/FU60tX0UuR8TYCvhUlgzVNVJ
 Qqb9roppmEch7B7X/Dg/D6MAWKcSxg==
X-Authority-Analysis: v=2.4 cv=N/QpF39B c=1 sm=1 tr=0 ts=68cc098a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=V5HFdCmXdFhsvwO3JpAA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Rspamd-Queue-Id: 35F1F10000A
X-Stat-Signature: 56neqiaao7kucyjqqdqqkegt9hy47kgu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758202266-851473
X-HE-Meta: U2FsdGVkX19nZAkL9zUtnqfwd6lKzP9/pAKceEhzoXtN2noXGLOcfSVe2+J6ZdM+igneUOho0S6r7fKznMS0zle8Ck5bS9B0dgv49nUEbPqcSwMAWRelHB5HRwmpsuDocU5pkm7oRrgFuIT10KEIpnLY8Xpu/0/VxqVHlD5YY6rp0VVcc2tg9LfLnj/xpB5hWXn8QAupelBcyKLjL62IdqXFYttuOI8ApOUz4xKEzKghE7WFtQ5VcxLD2vPLepeApN52B7STrWx0n9ClyZ3tSR8Z5L4lqVMymkyFvluZEYQKR8tvmuNFpnSogc5/rb6uK0kU2Tp3KX7vdwS6GqGvGDVgtNsW7Jz/9/YpAyA7wMbsVGTmUK77FS6cSvZPZX/891dxrswZiNIQKdroTy+jth4hazytJgIwEDqkw21Frvf1aK8EDVIlSde68wzLm1lj8AO9FdBClUYwNTPmh0XAimFGZB5sUiA0Rr/ogmo6rWprwAf8+ugs1rRhC3fUemE4tpeOdmiRA1gG8BeVW9UjkkjwtbIYdzqURuq7HfNT90xx31rMkPO0uAItW/STGlR9KY3ECGUMqqXixdGuBcW5DH86BXkGGVGBP5jAjXyTGQmgJvU9JBSL9mfr0bw+DoTDdLGvUfhaygGfOowLP/ZfGFMO6LfG88qz8HcmWst69szpq3Xj9IBxWYaJTD+42ECGZPgmmRULJbcq7Y7oQjoDD3ppDhSYUHkroC/JdMA/gqmrdHyVVhwS7wmRC2j6s16zXLqfsoYM3ZQ8p9nfu0zXpoF0lLSvZc4HqolcpldPl2l/jzKRvcVFQSzWqGBT//v6ndnTLaV7i9J/Kz9Ko3Oo7eKccxA+jamrksrjrxa8gwFTMBTGGJiVPhX5NFZsy4/TnU2wyYUHEf4nQ36mj96uLVsXEeElVu3Bqlvn7UTcd3fOSg2Nkml1iB34DjjaL6M1W12KuUw5U3bESNo+Jx2
 fxrqXTEo
 ESQ99JVVINe5ttrDnbXRKHmSKDqE5w4b4cOqrE+AyykizauaBB9/ZQKKsTYDOIQaTonuUMqPtdzOct9twMiDUhkkKQtXfuGXULGQICaH/JgsBmErcuA07LfOmJ0cjTRq84EMvprVCqumaVbz4ROqNNEGzpNDU90wRmTtS88C5wIIqP4qcOggtRKMY2Uh7Cv47Oww+ZdNXAgVUwQt2iZNSunGAOyrZVpbKyKNuO6a0V1WdgdMUKwRdvCg75Jh1v1cj7IImd4shOZ5fYLwMYs62VlqjA+eEBFJZsOmwxTSb9tO/CMJl/mo8ft+gFl3eIYqH8+ztPkdyJ3++EIWWXb7N2KLxLzwh9URtRiUUHWyehiWWNVMAvJ1zAlfNjFPB2g8sMNqASsuld9/JJBaZ+rvOQ8eFdfmhPYG4/+dA90u8GLOK9BdXknW4LuTKG+xclhsKxFeAgolB3lG58tHZ6WTm8mry0Ag0F/BqphuOi0seJcAJpdbu5L9zvVVjMun5sptf/FUfBrtA80Shz7BSdAUMedn+Anw393ZWWB807e9LXCMRYQqlGpOyaNizZblmvmZrgBlnIyeU62bSA2OLBahNbZ8k1NXgOqhn4pxy2PVTWkazfu9zJ4iLQwUDoYA/e3M812oZegW8mT65k5XQZ/iaid2OcYBj30j5vzhSXyz7QZDlQvddWzEenXMy6mxWYlwwELR1PzOKhn42HVjrZ5bj+n2/yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I see that the review is generally to drop this one so it's moot, but this is
also not applying:

Patch failed at 0006 mm: add assertion for VMA count limit
hint: Use 'git am --show-current-patch=diff' to see the failed patch
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To restore the original branch and stop patching, run "git am --abort".
hint: Disable this message with "git config set advice.mergeConflict false"

When trying to b4 shazam in mm-new.

