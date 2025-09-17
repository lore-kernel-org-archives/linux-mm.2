Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE60CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 08:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78C168E000A; Wed, 17 Sep 2025 04:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D028E0001; Wed, 17 Sep 2025 04:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603FB8E000A; Wed, 17 Sep 2025 04:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40EB48E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:30:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA0C3160473
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:30:41 +0000 (UTC)
X-FDA: 83898071082.01.5EB963B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6E43C140006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:30:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BhCXa4t1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TfLYVEYL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758097838; a=rsa-sha256;
	cv=pass;
	b=c3Hcx4F3QWlxBwJVRN2uTsGHZOnVxfG+cnQJoAceJrby7cwBq9b2EiF8pyZ//pocytZiIW
	akzuQmeAqrtJC4Vxiz0Swm4WcuCx6HdUpGgkdutXdvzaQL4/rxe2IP3iwEsBxzdzSTPWUt
	cu4I17VL8pcnKihgsSya4JPuWx+xfHM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BhCXa4t1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TfLYVEYL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758097838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mcqsu8Lk7h4/w8njXkmzdfaxhnlB9skKDMKmqcHx1ns=;
	b=aXSYMXY5ehkEiT8QaeGCYtAY+X03gB17f3Lr0JJnQDhOX6JNdJoT+VitCRU9g01XIC26oC
	QZEwX+MFaZUj9LabwroGZu0oPz0H1DhMp3psqOuVu2O0qSzjGbdLUfxZYs2SPlk/g4YmVi
	sCypdtP+Bv6sOxHABD7s7MlbYMRvtco=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H7uMNw011142;
	Wed, 17 Sep 2025 08:30:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Mcqsu8Lk7h4/w8njXk
	mzdfaxhnlB9skKDMKmqcHx1ns=; b=BhCXa4t1+AksHe4QXOMRcKS3Q73LwQknZe
	l6FmoqP644s0sHnmIaMyXBCPoHn7u2HHpKjgObfbvUiuyhbFsK/AlATpRwNY4kaw
	oVWxPrcv79P0zQ8OvORLa7TPmTgGrGBvMcxAd99xar7XFNmiK9crbItloDCOTX9I
	zCuqYFKFqtkC8XvxdGyr1eETC8bKedLE4GuEVyKN+YoBebIU+EQ5aWU+dUpQ0JLr
	zejjx0nSV2CtplK34CBJo1yc7AFRc70LhaF13oee2eEKmecpeHhCzkkzuuoj2F+9
	4fYwB1/FnD3npvKTDBEEYtIqnV2XnPrYaVReUAN6YKdrKN6A0PSw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx9rqkq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 08:30:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58H83W0a036935;
	Wed, 17 Sep 2025 08:30:32 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010042.outbound.protection.outlook.com [52.101.85.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dg1wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 08:30:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rYq9vAOEVpcQhBlfzEhfS4sEDr2GgVgX1g7jh2bhFVKk2yAqF6480YFADVjxro4tJDkbHRYUD4NpncPM+Y23iSTNeIOjy6mH1blJ0/WdbnkCrnGNxsTnnUldAZUuyh4H2WLdvb5/OXpuZowp+a+HzjGwAU3LHEzuudivmAP/ITu7MnNDX2ZlpPH9tt/jAsO2QqTeToSh+UDDyKM88H40C0jo/iaQ7S/0QnryWDoBoxW0wI88A3vJavxKgSLG9aq5PTe5E5S3+w3dViJ9RxwBsAJETgm+uI5F0sJvY1DYoUcZCrnuZlMc5LYnBIyQNuqRkXYGjI7DZ+sk1BpqkDIAHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mcqsu8Lk7h4/w8njXkmzdfaxhnlB9skKDMKmqcHx1ns=;
 b=lhI1huGYyggJ2H/m7KJwHkbVU+i6APM02aCNBbasDYeDtmmSNIbbtUp2knUXYUiLJPCRJ9RCVR8qXZ1xKC0m+UuiD4LZL0mseLJc/L5zIEGXewkgpzG01xuE922euL8ODxWWv0U4dRB4IyzFzmj0kBHx9Pr6Y0ists6yuI9uh+Glw0588beW/MIw/vnTVHwO1b1FsrVAjbsrSmtaFVLSP9YHMQ71noxEoNr/x1lFD0ObLXPLzJvCrYrQ/IJcpWN6Eb55c7fP4NiEJQ/fdaSDbezqAc8T5lg403Hwssb458WqiTbB7MHm9BDFsn8GBFlkmv2SgsCr04eHTP50+b4EFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mcqsu8Lk7h4/w8njXkmzdfaxhnlB9skKDMKmqcHx1ns=;
 b=TfLYVEYLYq5Ci5JbpfEVyc+Kex/JAw9OwVzhKopgVXTXyTzuiZ+EYlV2wvehufBbTd5GupH7kz3weJZYMzEpGLIqZ1mC/9TUS3IBSroiqQiCcA93qGu++8aGCmyuI2e4Yi/xMK+jGXrD6U3fZ3zEkQFe/NjR5lHIOAEq2AX+v0E=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH2PR10MB4279.namprd10.prod.outlook.com (2603:10b6:610:a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 08:30:29 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9115.018; Wed, 17 Sep 2025
 08:30:29 +0000
Date: Wed, 17 Sep 2025 17:30:20 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <aMpxnACqmsQl-lp0@hyeyoo>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
X-ClientProxiedBy: SEWP216CA0031.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b5::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH2PR10MB4279:EE_
X-MS-Office365-Filtering-Correlation-Id: ddc386e9-0607-4acf-cf69-08ddf5c4752e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1xK7K8yoLagc65MLxFXdNlIRIy1eWPqJIBFvqvJ3tZ4wH4/v0oU5bwmBR2Ko?=
 =?us-ascii?Q?DPQzneOHh3OO7neGC+zODTphzaD6ljBZuuPXJvtXSJKCBTI/la6Ekf32tTfy?=
 =?us-ascii?Q?Rukdo9ZZh7iehkgInClyySniRmQopZ3qkbi+f7SyFVn4LB8Dnn9Ybr2C9Swu?=
 =?us-ascii?Q?rupxUczFZCQynNB31oj27SdJqfoOROjVJh1SqhlPWRQG3krVVdtTZ1s6Ofkn?=
 =?us-ascii?Q?zOMhqMYOAai1Q30mFnGD0vRlxDy2RyKqnQivc27Ld8ERlsnkWjTMwecLi4Kq?=
 =?us-ascii?Q?yXkcAdbijRPwte6GHWootIBlilryLpwNPWu9ck7W4LEyMtXoR7Sorge34YFV?=
 =?us-ascii?Q?POYeffM0iGj+BUmXBwFVSOXXpK4mzL3n//O+xuOVKXLlRCBMpyBR2+7CciEU?=
 =?us-ascii?Q?BViFMLD5oapDB384gkQkhycaCxI4a+xlNf3AaP7r6RdqMJ/4VChY++ansvNB?=
 =?us-ascii?Q?+iGHkxU2Pho0hXas6F5Qw4+8O13GZUOSSmLxJu4pQ3+ZgjFN+2deNcOBpP08?=
 =?us-ascii?Q?IyaLoMKKhq4Vwowte7fNO5WAjF3rQVMGo9Rp/0cfkmNOXLBaclOx9rsp4ExD?=
 =?us-ascii?Q?QkGyRqLlB3ln+TQhXybs0OzkOgL5rzxS2y+Rla2t7GPFp5gPpIEi25QUFVvN?=
 =?us-ascii?Q?bMB+qvW+98qVCC4v+yDMs+SwQkfy/VryMAZwM8fKaf6mhA3aN5S9kfgD5l9y?=
 =?us-ascii?Q?vD8QW5wlwGg04ZSHmWOl65ruoglnOOA5xNwP2Tq9mD28djlN/ARkV2dXPBU3?=
 =?us-ascii?Q?oQeqHChQZHil782mTmCLS3lZqNm2yg7Pr2iaqvHFU7gdN42B+EKSz+1GEYBM?=
 =?us-ascii?Q?O5dFLkIDVkwjsX6J3OpFuTM0Vff43wtGcvf5n9PHH1WnbgXXKtzKPoW8i8aw?=
 =?us-ascii?Q?Zz5WKilVVV8a+v5v5/A//IB4qROvx+9nfi2OyzDdgm5oXplOrT4fpmWvh1vS?=
 =?us-ascii?Q?uQWsKVdP7Rul13QyTbCU8lAFE679OCLs86f7WAK9Sb0efDu0n9o4UAWlwCnM?=
 =?us-ascii?Q?IaXT8LR9+kSiQlV77tppu7rSV4BCOB7xVGBQKbYWGYHHat1Cj/ZbLPkfaI8X?=
 =?us-ascii?Q?bJlVpGUgK615Mi7HpHT4aqZmCzbTpg+qhfiWU/hr6wBYL55R1R/e4Jvmgh25?=
 =?us-ascii?Q?Hg4v8tbwiE1vXVho2zYQsy9gm01neqxnATOJLjinF4Wg3oFLxbvxbjgEltkf?=
 =?us-ascii?Q?nMUf/dYfsVUqmHtTzViELICzDLEjZAUuhQhRumNA8HbGCGOly+s/2MZK3qyi?=
 =?us-ascii?Q?4V3iMXNm3TI2Y/uRo9jfGLquG7knu/fWboEULwI/r4Q7v53e4LRj7vayungx?=
 =?us-ascii?Q?cJVgiBMGtLFuWBRD5CVV5+OKKDxKIBzDb8UWElmqH08K+xoAkhYgKyobHB3O?=
 =?us-ascii?Q?94g1DLM2AT02n+BvgYmPpRUNZPh2vFNwmPQYzEcBMhKI9yoxf3r63A+c676e?=
 =?us-ascii?Q?N+SUY6oJHfQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gePPqtN+3F6PQ+MgQhk2ILGOHDCxnAHjYFlFTEnLm6OgYo/vkTs1uuo07Ec+?=
 =?us-ascii?Q?3EZuL1jxXUNa5pdHTn49eGauw5IWmZj1wg27ZqGZgEc2dk137rxA4VmomY6e?=
 =?us-ascii?Q?977cNolQRQ2bCUwCmfMABRD4qdEGcAzhlJq7h60HirKKRN/HMWxnc0ImOhyT?=
 =?us-ascii?Q?zLTzFNuWouvVD1CVABLICh+pNFGKHncfRI3cd1k8HKJ3rWG1CgD4F2OKvwZt?=
 =?us-ascii?Q?d/pecdQ7nUHBBl/EGuGmYrbLUV6wpLPalBRID0KkOmH0s5v7cSl4l3Rz1DMT?=
 =?us-ascii?Q?XqwB1LvZkcuGAuaZZIa+4CXqVSHg+FK4OP/RuYkMYu+VsTz5pISz8uc/j0Ql?=
 =?us-ascii?Q?iclUD5W8IcpoZhKq2UddsdmtknaBU3Iu+wH+C9nzBxOthxhUFgSOeWfXhHI9?=
 =?us-ascii?Q?3+87b9KUuL+uK5ughgfN921atTN0mNPU+xc5G0kV3eZ5JkTmT6x1+s3DTrXO?=
 =?us-ascii?Q?oy7T2uhisu0pDw9cjTWH2SaDdGn47RTHINyCZn4WGGkU9P4W/t37GKlc+aE5?=
 =?us-ascii?Q?auQjIrg0LqPos0vcZ9Wnk7xqtloH2TznghI1cp1aL8TRwniozZKUnqI4f8+d?=
 =?us-ascii?Q?ggmAWxuM6bT1VKmz+rLohrIeEwafi9HNLI6KJKbzuNf8NcWkXkpvXsyaesnp?=
 =?us-ascii?Q?4CbPbdYsxqRrKGueXI03moK5GJufX85PFrd0hQHDP33fx0B0hKDY5QBkow3f?=
 =?us-ascii?Q?8ImN3JojL09zxSHz8i9luWQWTvKa/+2kV03gjN5kVq/2jSEoOjUlb+R8ALQP?=
 =?us-ascii?Q?0jywQX7PCsrGTyCiRnoi+UAathfN84MVIoJ38yVyGLkAFFhfs1j0OkR6U+K0?=
 =?us-ascii?Q?IQRyoicCLirF/9lIQCJqxcO3b2UAGFRtW6XTMLx7atsqxS+74X051Od7iXis?=
 =?us-ascii?Q?mhiBYwYhtQYbnc8+CWWct6YAr24/s+t6rn4h5pOthqC1dHFr34Aguzh0GtP6?=
 =?us-ascii?Q?uze576+86hpgh+otEfKysBMXi7TEQQa+lJFN1TFegSmAPYkn5eRo9yH7bgOm?=
 =?us-ascii?Q?QEzJVitIEsLj5lGOVWxj+V+hcwwrB7hxljpnKr7TtZjiKGXPIl0FsgFbi4LR?=
 =?us-ascii?Q?bOf7hBl0Y4OnkCqmEsnAa4+KQ4RzF8utUo/W9hmdSiDj2PQEMlqF4GoG/Aw5?=
 =?us-ascii?Q?ybUtqWfgXbUWmRp1ZtEws5Q8yHKKJhMpUBxkDP3rAaIwTjSguhaxQd8NeEnI?=
 =?us-ascii?Q?UDQW6jBl1zLv6OfnDQccaVh8xg4C33qQb4hYgOmPUonA8iwMQLYjnNye30VW?=
 =?us-ascii?Q?a2qq+npr8y33NnBvOeg9j5p8Pl8fUcyNYbsSbP7sikfZelZU5h/L1WWka/Xv?=
 =?us-ascii?Q?CItpCUqib5w2kf7nr7iR8jXwcUre1qjhSW+2gIY/Z/HF7vom5q2jwbjMMdJi?=
 =?us-ascii?Q?Bl/N8p4wvF9gp9BZiIOnpLKpss1bCL3svQQYnTLhCUveMzRHxqxwyqtKI+xQ?=
 =?us-ascii?Q?vP2U4yRSTQQ5CjX1kIhuHfw11C/rYRh9TjHrB6vJxHpfk6Wp3gUiXtNOUb/j?=
 =?us-ascii?Q?KZ2XWmGxjKkPkLPNBPFLTuNVB7OM6oR8C6Ql7/oJ8JldnmwWT4KC3N0iSrVB?=
 =?us-ascii?Q?m7G1zE8RpQZChB4FfijvoH6BqEqSWM1IgujxtF51?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rnz6BoKjIdWQsUVyk7ghsC6Sdez1L+hg4AUw8JGcOcYlJLc9M+mdEDpVsUBvZJSaMkCraxI960svdJBJSKTjeRBGqmib7VvUcpduWZlpAxZTwheT6ZYr3uiasaVOKhIidJFToaNnFI2JwFSOZvRA9+Ra419CbTJvfxAbn9GLxqwW1jlwz5kK51hOCm7sXu22aKUilstd4dnzKr7EEsX1R5WSBjeBMK8+jb+8pl9XLMLXxKxyX6zEkngNuQ1tacQrgQc9sVolXPoka91Y8ZAgjIsJi65nIEdLL5b2z9lU1yfYo4hB5g/nnbvrtaIx8q53YBLcnJ9dcw1gXlML+2K++qwgqQlcxGXsVHMJxQ5/35LVTFfASEUWAUUnuIeHNb2YivtthU7+oKzfPksQkBD2dlvfJveZqB+8ETTvSK7JDLMPsp2Em4QGh+m3QP36ft4hAID8XlVlptwvWnP92HlQlqAMhLrH+RCXE6xdo5JrD7BgGi3/vP1mriSpkwUaXR958SK/sEfN1ZQgwp4hIXKW6g8KXCqj5OnBDO4RrzqZhzN+CzwpR4H33HdMl8Spq0vD9Pfmi/9sqLCySOq09wtl6HacqCRvHFBRTh7L65OVjfc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddc386e9-0607-4acf-cf69-08ddf5c4752e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 08:30:28.9183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OKmBFijoY4mhHY/t3UzmlcBOwbJGXrh1rVR2/g99ptGe8YJbqxcQHcUjilyMT6v/9W1YZ/klbKxxAlvIgyN6tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4279
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-17_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170081
X-Proofpoint-ORIG-GUID: bdZZebJWY_CE7Izh2FgGUyYwcSwXOHK0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX0thbfIGoC350
 btQWd0YrTxzv/W1v9MKOn6GWgMjo4whTCpHy6w75fQjnW7vK2nnmsa7vw5Hb5FYUT16zHw3q+ui
 P0AtDHvpQI7wHPAKxB3RQhntJGblxQMTp4vwlUGRD7z+p5VtPT6BtMID1G8ZNJDOZjV3cmqrfxP
 SrhpWFKi3tve+85CiKKaNYU8lFGvy7Ms2peJX/vdqx/ZunNIzBST9i8jaM/n5OB8oBDqNrAOaG6
 RgeBpt+gnknFDk9CiJtDOXvfACluOVHPSsZhMDqt/2NFcYkn20MAKUxRzsu0kEe/o7fIB1A2Fjw
 aobL26gqlB2r8ziaoNQOaGlWjV+vjtcTeL0epzrBmYF9QZfxIrDBUnhJMsN9D87WFPi4ivpjpUY
 lLyI0oLterpc2IlGO7KJrWd9meNHXg==
X-Proofpoint-GUID: bdZZebJWY_CE7Izh2FgGUyYwcSwXOHK0
X-Authority-Analysis: v=2.4 cv=C7vpyRP+ c=1 sm=1 tr=0 ts=68ca71a9 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VaE9Vu_GMSX9YVFyq8oA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E43C140006
X-Stat-Signature: oxn36s5kmwykgzteqe3ptrtp8hug8z3f
X-Rspam-User: 
X-HE-Tag: 1758097838-69755
X-HE-Meta: U2FsdGVkX18x2nzNYMsyCMXKFvnNy2CkBU9g/AANK6BCf7qFPOf6kjRpx6MlqBMqBC0xxfrkqELNGsTt4d3RAYsA2WXSSigTCqhxYvQp1JmUFfYVQeQGRR0jGILTEBDuQodZCeDmVn5AIT85x1t8C67iIZCiSU/8AxrOx8IBvQfgnW5F+yNa4haj2sUkIbkqj9494z+ezBuqS5nBpBp0pRggLyVgzyEIb9JVygr0l75w3G9dzVixOoRn26QrvhhO9TG9zhhXxVNPZJrsYFJnPggAyQqBwdFGv2L13ADJTa6JOttiKBu2jbknFbgQVYH18KwwMve1eqfnkK7YKUM81oViKyr8DnuxBrXeWcsqZ/s/DtnS/LSDVBiPKlp0Xb68FGfISprfIe0t03AL9BcBV82jaBZwn8NEMA645NCpn4ifLoR+wRL3hm+1DazKwPfYmnLhZTWydK/qXnRrj9DUWSChnfsKP0gYRiQYd0YoX/i1PvOoRY/1/TvTFGfCTMWeHbyrxWDetXDCdXc9SIoqv//yEGowMWQSPAg45aFCSSkc/xsYRfDaQWmIM02vzLzzZ5I/1vpU479SQJbdSob1IINTWwj22LjQiVy60i2MFerrmvkh547vHesj8DrCqdkvmtPS8j4vzCQAfTCXGoBFzV8QMMu2XnnhKXIj9scuZVy1Xsh/aIegYJ+6HlKDocIM3NapCecDh2xQYzRhl7l7E5pmldQKc+/nIfvbSiPLO1byHXBFBGPVqhQfjSyMyVFEdX2chCA3muE6YUKyrVcxiGjve+9IqF+tHmz8/I34cSfHT1XlKN9J4cgLBZb5jddpX53ZG55YjoXybF3ejZaufhW85HwJs/XNJIHeAqB/olYNrTSPgVB6AGIUhUxICaji8/Gw5tqOqGolQ7xGqfLmzfxSbvi/6HeIee12CHXJ53ktkkFtlplqvWPDnSFSTRU+LcddiVqGLdsSVZIAcrh
 AqdOY0CL
 dv6C4ya5jNLROKpPZygf2Bqgxw3QsJ7wEI2VTr/AJ7wN8WJ3oJTt6BNrrixS+yg0MHdeIit4pnAQZSWt9ZXKKXSGII2bBgE1VYM6z+QT89dMPJNWBGEDUdib+LrM4aPIKcATmnfKE4K9wMfXtOW3IUYnf97cfvmho9lnhBv1fUQPqODvQxLHM6p9Ry/J+f56R8twHyuVs6DSr53tjd5VlcNA7E6vwTac1VXzEiZuqidnO0PzPFPwMDTbY5+p7Pz+zPahpkAyrv5NiLZn998X4MuU2cXacA4czu1Y8s3DErXnj4iUZNXsKkgbNR/kgFCa+Yz+aS6cUccFEgSsF9WIFM1Y++ypqQQ/21tsEMNQ5rXS3e08dUvbi7ijx32nFY6kxZZANuJkwJrA67Lu/YAAB5lzVOWiD5R09y6OLm4jJhC2JLkCWk9WOZg1U6uhhO6x524iqldQIqsE5NsA7Z1vpa49Z/uo+NE55IX8qnGvbF9jCUhvDhfZtanTYi2H28lYIcZANHuZSe5xoZm2p7DYWPQi7fucSzBUXNYLx5mGF6+yD3Av2QsLs5j5fDqJOeeIpsnxNrxwaT4wVjRb15l6/J8BoBpiPiYyTumWmqpqZZ0A8UnodLMbaRF8nmspy/DO+m3wwa1MRVkADc/ofRg9cW9h0xk6OU2hl1Hi4zNbuTpl7Kh4a30RJvFAsbeIjVbnhgdnex81MV0Mko9vaE/g45G+nD/Ybs3B5DSFCB//0tb67yqLAiTi+X3owu2gcsmGceM0YCkuP1xT1aAtjUPNYlgypH2Tzi4u1WAOUQoJViaroaFs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 10:01:06AM +0200, Vlastimil Babka wrote:
> Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
> For caches with sheaves, on each cpu maintain a rcu_free sheaf in
> addition to main and spare sheaves.
> 
> kfree_rcu() operations will try to put objects on this sheaf. Once full,
> the sheaf is detached and submitted to call_rcu() with a handler that
> will try to put it in the barn, or flush to slab pages using bulk free,
> when the barn is full. Then a new empty sheaf must be obtained to put
> more objects there.
> 
> It's possible that no free sheaves are available to use for a new
> rcu_free sheaf, and the allocation in kfree_rcu() context can only use
> GFP_NOWAIT and thus may fail. In that case, fall back to the existing
> kfree_rcu() implementation.
> 
> Expected advantages:
> - batching the kfree_rcu() operations, that could eventually replace the
>   existing batching
> - sheaves can be reused for allocations via barn instead of being
>   flushed to slabs, which is more efficient
>   - this includes cases where only some cpus are allowed to process rcu
>     callbacks (Android)
> 
> Possible disadvantage:
> - objects might be waiting for more than their grace period (it is
>   determined by the last object freed into the sheaf), increasing memory
>   usage - but the existing batching does that too.
> 
> Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
> implementation favors smaller memory footprint over performance.
> 
> Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as the
> contexts where kfree_rcu() is called might not be compatible with taking
> a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
> spinlock - the current kfree_rcu() implementation avoids doing that.
> 
> Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all caches
> that have them. This is not a cheap operation, but the barrier usage is
> rare - currently kmem_cache_destroy() or on module unload.
> 
> Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
> count how many kfree_rcu() used the rcu_free sheaf successfully and how
> many had to fall back to the existing implementation.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slab.h        |   3 +
>  mm/slab_common.c |  26 ++++++
>  mm/slub.c        | 266 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 293 insertions(+), 2 deletions(-)
> 
> @@ -3840,6 +3895,80 @@ static void flush_all(struct kmem_cache *s)
>  	cpus_read_unlock();
>  }
>  
> +/* needed for kvfree_rcu_barrier() */
> +void flush_all_rcu_sheaves()
> +{
> +	struct slub_percpu_sheaves *pcs;
> +	struct slub_flush_work *sfw;
> +	struct kmem_cache *s;
> +	bool flushed = false;
> +	unsigned int cpu;
> +
> +	cpus_read_lock();
> +	mutex_lock(&slab_mutex);
> +
> +	list_for_each_entry(s, &slab_caches, list) {
> +		if (!s->cpu_sheaves)
> +			continue;
> +
> +		mutex_lock(&flush_lock);
> +
> +		for_each_online_cpu(cpu) {
> +			sfw = &per_cpu(slub_flush, cpu);
> +			pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
> +
> +			if (!pcs->rcu_free || !pcs->rcu_free->size) {

Is the compiler allowed to compile this to read pcs->rcu_free twice?
Something like:

flush_all_rcu_sheaves()			__kfree_rcu_sheaf()

pcs->rcu_free != NULL
					pcs->rcu_free = NULL
pcs->rcu_free == NULL
/* NULL-pointer-deref */
pcs->rcu_free->size

> +				sfw->skip = true;
> +				continue;
> +			}
>
> +			INIT_WORK(&sfw->work, flush_rcu_sheaf);
> +			sfw->skip = false;
> +			sfw->s = s;
> +			queue_work_on(cpu, flushwq, &sfw->work);
> +			flushed = true;
> +		}
> +
> +		for_each_online_cpu(cpu) {
> +			sfw = &per_cpu(slub_flush, cpu);
> +			if (sfw->skip)
> +				continue;
> +			flush_work(&sfw->work);
> +		}
> +
> +		mutex_unlock(&flush_lock);
> +	}
> +
> +	mutex_unlock(&slab_mutex);
> +	cpus_read_unlock();
> +
> +	if (flushed)
> +		rcu_barrier();

I think we need to call rcu_barrier() even if flushed == false?

Maybe a kvfree_rcu()'d object was already waiting for the rcu callback to
be processed before flush_all_rcu_sheaves() is called, and
in flush_all_rcu_sheaves() we skipped all (cache, cpu) pairs,
so flushed == false but the rcu callback isn't processed yet
by the end of the function?

That sounds like a very unlikely to happen in a realistic scenario,
but still possible...

-- 
Cheers,
Harry / Hyeonggon

