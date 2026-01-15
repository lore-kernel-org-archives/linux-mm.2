Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99D4D46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDCEB6B008A; Thu, 15 Jan 2026 13:27:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA3C16B0093; Thu, 15 Jan 2026 13:27:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55766B0095; Thu, 15 Jan 2026 13:27:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A05E16B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:27:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55C54B8449
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:55 +0000 (UTC)
X-FDA: 84335032110.02.ECCF3A1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id CBC3CA0018
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OhiNXfD+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X+KA1iV3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGLlBXFxFAspnzKmOsHJ1rBSdmNQiTS5h4YWknMKOOQ=;
	b=U4RUgC9b8Cy0h1CmVNVURbkqt5q563+wnD01aM+NpjucDCh7GRdcWLqC0YS50ihVrc7Mql
	7mSZq+uXyZrXwFh9oOxaJWR5o4164Tn26XFI0SVX/axCWbtU4xZlxIZxaEGctV7dVX2UwA
	0MH7l9Hoyqp6j/PyMbVqJwkfkpuKGMY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501672; a=rsa-sha256;
	cv=pass;
	b=YoJ2bmTHtn41zDfAEn4Pn0ZwcMz/CSauMUAuPlHha2JHdIJIxPKmFBiq9CXlg39bDKKq2g
	jyRsu+i5UHSJpa+zMQJ3rb0eZiVV1POsoK/RTWqCtVTwkzj77HXzgj6eTDODW9VIz1eYdn
	Q1iP+s6jFVUYxm0PJM/js8pykkhGMbY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OhiNXfD+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X+KA1iV3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FGpagN2754251;
	Thu, 15 Jan 2026 18:27:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fGLlBXFxFAspnzKmOsHJ1rBSdmNQiTS5h4YWknMKOOQ=; b=
	OhiNXfD+tNsJ6AAsieaFSRJ60MLsx3fbDWcvickvbDiGAHgMl7Ja6WnRTBV7Xdw2
	n+MFYi/7m3PGqSLr5HxDlf1oYJRfUFyZUIZB9WHRVM+0Ol4VqabLJGwCjYLuSaet
	YuYiqrNNFVFdDkEnhVFUNBFSRKGsa048ngKlJgSKh5+JOLrql6RtZhQTR0ofheua
	9PK8og1y2inPzLlFEliGpDH3zVGQLCsuTFnKhaMDAyeaMPuNi+63x/CICEmlbAn5
	G61wezr5brjxSFmCGENtDcv6cAGSebWN3R9AThgIkm7tK3OFaCHGpWj9zlxWPjmN
	tiY8Iyxo/7bo4VY1goanJg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgrc9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FHhtRL035374;
	Thu, 15 Jan 2026 18:27:31 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011021.outbound.protection.outlook.com [40.93.194.21])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bn9cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TUGJRsuve4XkETf5TofujoLP25TOhrdNbLNLGIsNgIlJTataBaE89uvWeAYWQ7P+mBjzmq7giAa19w5GVNVvoQqoKw64HXzmz4ekc5tykd3XZL+nfZYN3d/w/RDn4yIPEYajhUubomBokjAMJyVeS4fYeF+DCISDAc20TM0phjYQzEX20w6ruvGG9//+S+tawOPJnDwzYmo0in1vg2Ri3EYpijjgDFT+/9vir8Ud4y4Ftd1WXofqRFFVS1slTZoNBEOdLrxACtOKkoyGmtokXHM2sPNUBfLC9fWW9va9iU83+oSigedopEMhsbDQuQTAtAer7Mf2GtmYeoufzlIqTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGLlBXFxFAspnzKmOsHJ1rBSdmNQiTS5h4YWknMKOOQ=;
 b=ZhXbnWukjyue9sHhdJGYWH5X9Ub5ND6e5kpKB/vdWm4S2Nax3lcOvs9yfwNIhXGtOEPpRR1svMHBvPTzpP6JRnRV5ee6R0yl+KAm+Optr5U3ffUDD3HgcJuczbUDkDQVhXrfZqhJT8VNVpI0NhQC76pCJXeZgBlBCUzhwMTIVRizxCT9/J2KoqXZpYzhhSD5C6sgI+id2nc8g9chZYFxODeSSJrFzUdblZsgnXQbrs7BRcd6jGmFtRS6fChD7zjsRX2hEDjAEVGaWEXiKtB9jjxFtfHXoRz90Ex2xKdVVN5M2+Z6QNwsLWfk/I28LG0LD3I6e8j7x6U/SKgkp7CLMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGLlBXFxFAspnzKmOsHJ1rBSdmNQiTS5h4YWknMKOOQ=;
 b=X+KA1iV3Bexz2aaIlmq9xOa/1h3H2NhWkJ/jCi5TV+hYBK9S+pKhiYoh+WOHY4KjMDEtHNX+Stb5+/BqS24zM6vQJqy+Yi2GyiYvsAClaOctqKHhAt0qwoDHVT6LZ/7h4R6Zh7VwmoT5rJ+5MeM+OIYtgiqquRsCVnWTWIAUW24=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7119.namprd10.prod.outlook.com (2603:10b6:610:122::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 18:27:26 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 18:27:26 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 01/10] mm/mmap: Move exit_mmap() trace point
Date: Thu, 15 Jan 2026 13:27:11 -0500
Message-ID: <20260115182720.1691130-2-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
References: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0130.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7119:EE_
X-MS-Office365-Filtering-Correlation-Id: 43d08e6e-cfba-4503-4ff2-08de5463bc12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a/uG3Gu3OMKd9ma5Il9XwUqb2wvG2KA+H+LL3sMpC9GE+exWAj8OsdHmMbYi?=
 =?us-ascii?Q?KyiKGvYVl18IWCYkzRUOpwRqIDTCeJFQXKxcXGJFpQHYZVXJi5jUyNUNpTKl?=
 =?us-ascii?Q?UJAyUgM75OZZ6itZY1MtQYEbEybjXAc4KWRMak4vlmwl+ZNuMnPL/xXBPedE?=
 =?us-ascii?Q?96EU7hLI1BQ+3CDAT6s1itTKx/F9FXvZqDdqIT3rbri0/tS0wXPL+od3PjnD?=
 =?us-ascii?Q?CKm3h31Ws65+RJ13HTYynqSDXQl1ykb3DjQSQ45PYS7+sjXs7flsemIcKENO?=
 =?us-ascii?Q?/eAhgDaUBQI8zUvo40slcLm/zwENvAI8J9Y6ta4avL6mrVRnvXOzDDjeSxNs?=
 =?us-ascii?Q?M4II3hJNw7kECaquU+esTskaHwmUCk+GiyV89WeQ6BHzwP2gNwtJuIoUQI7T?=
 =?us-ascii?Q?RxyE0pFngkZTyd2mVjqJ8IkPw71Ia6kqcwqwP3ljZfM0NdRt6Y9PadxVI5K4?=
 =?us-ascii?Q?M2G7tIl7q/eSzddRZIW5WRAxRb9+HvYcMgbZCy/HLYEABolEndT94ICXuYkC?=
 =?us-ascii?Q?Dllzt0nxwDnjXBgw18eHYvT1r6cHobwJp4MM6qhyey9tKrxjXesBzooqx9wn?=
 =?us-ascii?Q?7/JVTXUppZxgq4/d2nt1Ku7TjG5e94Bi6I7veAwPaNcOZWoWY1+i4jrrIgDa?=
 =?us-ascii?Q?dcEO5XT9lU1sFO3+se0nA/Saa5GmETF2S67HDn7VoyNcNyTQVCG+HFOVeSh2?=
 =?us-ascii?Q?zkEYxIUGKMPO9Y6JDKNnMEs5GgoshLXdPDdqpq6ZCD13MTHp+LuZDvfK3slT?=
 =?us-ascii?Q?XJmietKKXdBCMYj/YJax4aUfQz7YmfTgPRYqEoGeMAyXrGViZzTyPv0wsQZv?=
 =?us-ascii?Q?lswK56zuRY8mxZ0JTVDK31JYhm5/oucI4RbTRJnO7K1hJeLIR2rgp0j+eDEW?=
 =?us-ascii?Q?SA47TLL7Q7DM6aMq7H8GnU6co2EcFospZk5dXYpfeXuew+ev/fraL09u5L2Q?=
 =?us-ascii?Q?u0wIlVbdc0uvIp3pejalgc241EZSqNpOwmeCLW1wqpPuAX3oNRdXF+9s6D0z?=
 =?us-ascii?Q?/3uuEfeiVXi0lFoBHoupYmS7D7VuNc9W7vjee6aCk2vWYoYagx91ylM3Ouw8?=
 =?us-ascii?Q?4DysK3rujvOcnJBE0uaVT/XrtFpadqGz0VzlXGvnC9AQJCW8Ql05MWr+NhBT?=
 =?us-ascii?Q?d+qZ17Zm6G5JpK79UwACWiSvQjVNwHq5ea4rQW/0mz8vuU0iBIzrGA+CI/FV?=
 =?us-ascii?Q?yQNpCEPijDB6OwRbunkYPknn3qLGpxdT6RQDv4VkPicsippMMU6EduiHxW1F?=
 =?us-ascii?Q?uTmSqdLNIY5AxXf+nQCSFUJQUfetSeabNmiGB0RHln1q4dTzWdNTwkWnIxK4?=
 =?us-ascii?Q?tjK6N9JWLIB6D7R3VktN/vHejw/ShJO/7STdro9G8lo/ktv01PmTY5Vtv/gZ?=
 =?us-ascii?Q?9I8kFDy4N75OFQu1otofeQNGs8z421FxlUo1jub6Ce0gFhbjI0a3figECZeH?=
 =?us-ascii?Q?Kd7ml8E7aO4hrlfFO/4kPmUgI3d1qDpEBGNFW+Rt1FNmyfOsQWUdaR3XvpFt?=
 =?us-ascii?Q?kkP+Kaf7UwZ2I7jojuRQQd5el0EAtXcYZJVK/1OXeADs6gecY3z4aOuy0zQw?=
 =?us-ascii?Q?FqlR3uves01AzAzIRfk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?504G5xjGXiTv9Ac5hbTV2oC01FfvYchsaPEuo4GqoZXigR1LlSNroVsj3H1E?=
 =?us-ascii?Q?tOqLcbxhJS3hOeqODMGxy3MOTGBng4G2sRI6xKXk2BYKbLQYmgHCZUuGZCtU?=
 =?us-ascii?Q?oBSY8fsAjQV3JB61/6p0qbsTIaaAjf6OZhmQ/mNxMqze0NXXZrYtNpfA7r3M?=
 =?us-ascii?Q?B9eyOrx6s1IW0Bt8B+FYRP+tU9iFKxdpCGip+3J5LE79d/IhheBn9REKnhdu?=
 =?us-ascii?Q?G/xs7aKkq7B55at+wf2wBqRfKHE6NiNwx86XTv58dkPiSaXNi2Cx2vQd7Iic?=
 =?us-ascii?Q?ec6xzk4w+oRB6DP5TcX8M3KXtaX9wCbKUqqDAll1pF+XnnrVw7tdVf4ZycWN?=
 =?us-ascii?Q?v0sAtRVvPocgDePAl2Aj200AD1ZsrRN2r5U8H3YPl6HSmzDu4FSqVGxmzJmH?=
 =?us-ascii?Q?zJfhPQ1c8bycCGmUmdLMt2K6HS/42bckeaCE9GzieJBQa32/SNK8xbd3FD0N?=
 =?us-ascii?Q?5nIF0PU+UFj+p/3bqkfXvuzlv+J/DOzKtQxtmN3d6W9nmGoMbICrfXybIjuJ?=
 =?us-ascii?Q?GQjL8jFRc5PyG4GYnmNJwX5Vu95gG1dkT1Qj2gJ9QTGSdarKIANrKsVaDMi8?=
 =?us-ascii?Q?8fEWuQrBX62XsMjL7tM4yfISmZGJeJleXeEHehg4w4vDPT7fMxBqdXNo+91Z?=
 =?us-ascii?Q?Cea1ZDsmXWA5l49hBjAv4fvf5QvX9SmEyJXZjjN2aD3NscASbAGnD8y1wa3V?=
 =?us-ascii?Q?19/QkH1YE6vxUyxCdVKzQ3dhyvzTu3JcS43G6FhzJmRstiMxxWCDx61XciqX?=
 =?us-ascii?Q?9doUvZapORH6I/4RWjwn1KDudOSvfsnm/kADQAoz/gO2bwwJgv5fxzlDFoEj?=
 =?us-ascii?Q?DAVlJvioQWdk2iw4dVaW37r2Pc2ugv4gd6OCOsyensTPIcAdmahfmo+9Rhn3?=
 =?us-ascii?Q?FZ3dcdJqmxgMj5XGEso2z7V9W8wwhToeNR2WSg+slFRCbE15a/PHZLijyeHL?=
 =?us-ascii?Q?aEYieVEu3/28bFFmm7mszt/19HskQ8aY/GPpIIPvTkp+8DOew1emdVoGELx6?=
 =?us-ascii?Q?54Ag5TwIer5dPX27puDNrObZZvFJuoQILGaSi/52m/kKp5uavTW43jgP7vr0?=
 =?us-ascii?Q?J20kEeQlzyWWFyeGflIOPymcrcKTXyc0L8Jq7LDMv+4BAWCOUyUJVfjtK4tN?=
 =?us-ascii?Q?HyitLxFvrnTa9w06pOLCWGhCrElngVdxUpjGJ0M654uaQK6Ol9PTnjLX6O6t?=
 =?us-ascii?Q?inWlLizWeX0sRvi+ZownnlzRD/18P8C6mXnJBCq+F6thwysx9XU7M3sBmFCF?=
 =?us-ascii?Q?uoo9MZVRuWrII+T8bsBSCiUEh+pp8v371ZoAvk3hWmKz+d0e4NUX58iEImXz?=
 =?us-ascii?Q?y0cTNdrGqrIWdn0a2OlAVc6wZYAPLPY9vaPAmeiRUZL6n6GgkR8EHyFz9Z2B?=
 =?us-ascii?Q?HEZvhEWG1j04Km6IOwJyKP70m3C5RHi4m1auJNrOGU2KY3HvmWq0FHV+P26R?=
 =?us-ascii?Q?HGMKh/hz20CyHawKSbh9B7Nu3Yv9xf8Zjk87osUlJWlssoqsoFIl6Vo+BvrT?=
 =?us-ascii?Q?09tFphjlIQPyEETalBnAJWmrEROZNH4VBqPxD35R/nzD41/lbtUya0muySeT?=
 =?us-ascii?Q?zzfE58bjW0WEBN+WHCpyZWPPKpj5bL2VfaYqHMiaTpMLBN16rJGy2QjaOisJ?=
 =?us-ascii?Q?Wlh0KXf9v61yY6lxJNCaezW0cXmxtjLyqULAOv6o/bz0ptEuio8VhWXU2hNa?=
 =?us-ascii?Q?wxH8vDzchdHEFxaRS5QFcxxR4jeP0OBRoxk4NHlIiDzD9kSJ+ngfu4g6qXxE?=
 =?us-ascii?Q?nzKoaJa2hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mrmtqGBchmDZ23keVlCUZvstXOgkTEha93SjclZOCklmeddSjAPY21FLRbiqCwi+99keXbpKqIG8qVgPN9LSJiYjQUohoUSYkS0BQmSaZ6YbB9aHk0N3jKA3dsAV+w9UO7s/KdtB+ZfOHbUHTy1iCnSC+/jQLUYy/HbNG9ikkS3jW/DSvdY9rLqoES4oR9tqgF1n2hAeGXApW3eUMpyRxgc0f/0GRCiySt6CWENO/xLVPzKKA95Zr9UCr0b7+2SIz0FRUpuh4QGtOoDNxpjW7+eGMwu9FQdM29XD4Z1Y7EQN1Rk+4zIhxpaWI2rAqe32cPclDUMzRVuHoNae/4EfaAQnxq68zyzLzZt6u1fubbA5vHqxepDIaMjgbBH1j+e7cw/s4ZeUQYU3rYqyOHVmX5fn9NzUpydBoP/BeVkZFm/6iRXoTlcUTf0e/eM3+wk/+lenLYDrmlK4BX8XnwZKx7Rqdv8jB6Dg+QmSNl8Hy+5/ko1EZqevKorwimCLI1qWT77hs1l94KuP/kkvcAMvZg4mAtJs/g/dlQEoxtR5Zyg67tlcSH4pCtUb0d9SsQMkChfKMylDXVs1jH47foilebiIZ7Cp1bKj5n4o/T75hHU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43d08e6e-cfba-4503-4ff2-08de5463bc12
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 18:27:26.7821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OvRzMYSH6yVJsBTcLHjfHmIo/ieZUdEH+x2kkvX8D/TVUciJljtiOzv8dR2xh6Pic8eHXZWtVOoaUGLEmuqZCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7119
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150142
X-Proofpoint-GUID: i5dWwd86s6fg43OaRmm6In_eEfRSKgsc
X-Proofpoint-ORIG-GUID: i5dWwd86s6fg43OaRmm6In_eEfRSKgsc
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=69693194 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=bdutT2PD6jGpcJvN99EA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MiBTYWx0ZWRfX8JVdBbmnJJMI
 c/C2XM4qx6v2pxMFwgNMYToq93ub2/zTqvcOWfVetBK4B+yzmLZRHlx5Bd294M26vrSDRX9Df+j
 WXCLjVyoeWdDNn32WymyhEXb9jJMsl5FadDSSD1hdNjnglaEmPSrpdxI+Bg8uItElSp/yMUw0OE
 VwCneMqcz6GKWHXL2el/yZ7jeta2i6pz/0nSvbti4X+BmsQViM+eChSQ9b81+KDJwdlyFDaz5nz
 wpj9/X9dhZj0/0kSwv2jqErICqD1rHFBYYyZpa5+pnMJ5+KOJdkBigGcG+tk/G7RSmU6x/DBVig
 0X2FlucBuRJ0LbW1j7KeDH+wEY/TNOjWUG9zaqXTNs1LePSxGEXOBpf2LzpSPimgXO5sBeN3lgh
 3Y0KFwPBs4k5qpBJs13cPLqUwcofwon1pY0qNOwLyI/jydUZA69bI1rJULWs92GHHOYsINHJRmU
 CZlzKeLof7tZP91qlOw==
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CBC3CA0018
X-Rspam-User: 
X-Stat-Signature: kswps76nmeji74y184uextq5irgfhwwa
X-HE-Tag: 1768501671-737206
X-HE-Meta: U2FsdGVkX1/bmPI10ee4oY2skvgwegT0iPd6rZc80Ms9muZkhPjlzHaGJCgWOoxi5cQ9WV5UQQk0AmXIWyr/JSZoKTM0JU5RweaZYyeECMBn9eFzaYz++lL6eG06AK4rVWtBVcFJedzse++yT4uINVZNKoT4zOpdQtnGIqHPXRQzSkUuG3p/6fV31u4yUtiObGxWe3oply8ycIibfjcwEWh0pDLt2uwHqdZIt0/xXLQ689NJiNMxyFkIAWsKmpTt+OhHRJzPHPDmM7U/QdyyZmRGI8mglOVftGhl0NgvcMDEJfE6pm6ZUnY4ceNabeMOHlqYoDA0Pxcn+ohwJMPYoa4RM9EWrewLlwTiwamxwhhG9DFRqVPHcyiL2Lf3aK/M8Ec18fVG0WHQeq1fgrRViTATiGaDAyt2QADAj07cdwk8+KjsU5DGNGKzYheegxOMAp1ABwSmE54eEdrN+AVW7bQDH3Vp1yq9zImWQLU4PiCJeBFE7okh8CFUsfG817X0p/nuZpEU9wJAJ+zMdMMITXcw4DAojj+TIzTc8YRf89tlHGO6dZGE5tjm4asOLg1XuYO/gQGEQoQvxtdAEQF3oQR4ABPYH86LRd6iaac7HPjc3BmRcA3ISCByIiApeQYfOKlzmlwGiDLYW1wnY0x97SAh2RgCMKYarIl0f3ToH1feTPbiaUYYGX+mP2JJSED0dF2jPZxWiiP3SH3YfM4YfOzlH4Uk01FqxjTTS3RekTI7vJzj4qLtTDj9C3fLvfxqxU/0PSj+g6RaNY/BZ4+Fqx7aBUzunfqYa0lLI+uRkyB4aT1K4Z8vq0LuKkNy4lwrX6O/Pfhsc6wWX0n24QZqhDz5C+xQbK2IYRyknV8BH8CgLCI+JoQ92LdY5fwQeEkLt3kcHzkA3h0cA2p9ND9QFQilLAyfUsymEw897DtDIMSq/n3w5MkeMOV4t6WKHfJ537Kfv/MJ5rmy3/3rFjs
 Viq29fxA
 2uZ2UIj+kRaDAhjeD+UifHecaHvQle2zmgKaRgKivy0GI11nFxIa30nJO6adAEa1t4AtoP2w/46q5EEAZwRgpLHJDRRvrNPTsd/LJy1pq+0eMWzQHJf1MfH8vN32tzbbkLDZH0IaL89YVzGwrK5xjqn+K3iiI7i9H9tfEo+jqTbD/WHHROQTmlM4wx2azO9doOinvQUxPOw5drdlK+Gw8NzNJuGinr/iY5Gme9IZ/AjPHAEyIRCFkCJ5DR7v23WCU2BIP1skEWJwbs815qDzewkuKW3gPfxAcLaXA8Lb1/T6K+93TF6loAtJCbe4V38JFBrJu0zBh5hF6Br2lDHgV2+DdX/sqrAbDboVrWIyZXBXIcuuwjdYRdQV+piuUwSqFcE3bSQ55Sjqbx2hpVk8Viabw4mWmrRDysml4orJ4nRfWJAr5GaURA142xe+x8rJSHzS73BroaxD584ruSRTGvooRXdsMfCtsAobok+mT5yS9G7a19Af/BiOHto6i6Ke+Ctr0xT27YzCRbKapqe2/4iKPdWJBijHCPbT8YdJusYxm/4nIKuMiXpfd9yZ0rebHMGE9fLT1LeAhj7kMU3DbCNGE7lRVZnJyPlW1vXB6pQj5XEqQ2+tKz1CX7ZzgQLwqNO0c0EthAe6xnkyixLeOLQN+fVBFg/p7dhG8RWDI/LnlRHFudH+o+MMpMQKWePOc2QS2K6N+ndhHQASDapbNQerUbz767HjlcLddSzD7RidE9KeSTeDQskoqQTN+OS0I87DC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the trace point later in the function so that it is not skipped in
the event of a failed fork.

Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 4bdb9ffa9e257..1f025edf8d7d0 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1307,9 +1307,9 @@ void exit_mmap(struct mm_struct *mm)
 
 	BUG_ON(count != mm->map_count);
 
-	trace_exit_mmap(mm);
 destroy:
 	__mt_destroy(&mm->mm_mt);
+	trace_exit_mmap(mm);
 	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
 }
-- 
2.47.3


