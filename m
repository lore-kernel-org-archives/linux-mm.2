Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07430CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 07:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 362288E000F; Fri, 17 Oct 2025 03:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A168E0002; Fri, 17 Oct 2025 03:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23FF68E000F; Fri, 17 Oct 2025 03:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F95B8E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:40:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB218BA2CC
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:40:41 +0000 (UTC)
X-FDA: 84006809082.30.3AA9811
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4753F180003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:40:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lyhwgdyx;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Yi66wjQG;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760686838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuFb913pVjqWMYJboVEoEB1CdwA5WHAXM4kAp/PFVK8=;
	b=XcyCfzE6L2CNUpe54EdnDIvciEYVUA2JwJl2knO8FMQ7Hd45vPpWrs5Dmv5+SfEgDG+z/D
	rUFEJKdqmHVHVqMHCU5dTBpHdgNaNDYKGglVWso2f8mbyw9dtwFw1i87tXcfII5Iloxr47
	D6W9qWillwYSaIFjHdWsbSa4HFUvDfg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lyhwgdyx;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Yi66wjQG;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760686838; a=rsa-sha256;
	cv=fail;
	b=vXaPpJsUu5WCs0mSkUUt7Xkd5fW/tarBxnQ+kVEkr72E9NmeHTgtyzNcthPXyYcAu7T2sK
	DFPxWxx3TSwdP0/+ym4EE/7Vjp8CCdeF/kzBCWNhP3omR7ZLB0UgOpkLiraHHhMFZcQ5N/
	UoYWnakVgQt++9k9C/CagHeG3Iyo6GY=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59GLuGRe008313;
	Fri, 17 Oct 2025 07:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XuFb913pVjqWMYJboVEoEB1CdwA5WHAXM4kAp/PFVK8=; b=
	lyhwgdyxev1yvhHipQjxN+Iv0zwhwdaZXG9FGmK2HiEV0CTtTCdWtzX2f1h6yGa5
	Y1I/nw83RiJ/o4c+8VXJHaS7p8UmeteXYPVigtKfBcLe1wlpHHFO9gM9fl6SZwJV
	NjeCgEBGmwipzT9FbTT19diz4Q4+rt/msgeuaM2iBEX/49TGlSEVkskbU6V1aJx+
	pX/xqX40weSSUTeZqZCYB2a5GnoyhTOB78WKpaV4pIsRi+i1dD2Up4/1ZMG1LCPK
	cJp4oOrhJ6eq1EXz8ZrIkSZZ4gRJa7LCNqZx+Lw5ZVlOmn7iHPfr5+3wXH/hw3LN
	Dc2ZFngHwMpN1RNVBb8noA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdncact3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 07:40:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59H794TN017890;
	Fri, 17 Oct 2025 07:40:33 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013027.outbound.protection.outlook.com [40.93.196.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpcgq4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 07:40:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eTaC1oYxQ8/yeR0PmFuujCWqqemdfzhifPRa/K/ZVN3PigvzyvQDGxb7phNl04FIra6tQDZHUUVnEZbaQ05KnQHq3pC8WKRZtGaG4wPYH9DarNWEV+mR0vwYeeYh1ZqdRF0By1pdrVdgJTW89mdT16fAsSTDvZACNQjcL539Au6zxy5z/J3qfVSNlP6ufXUkrufKHlu0vO4SNBCvUINYtf/R0h0HvPnUDGGkxxsFAR5sIDHZRLHtcUcJ8rWs08drNKjnQAHcHD19Eb1w2hK1AkfA56rEMO78awyk+HX1s3AodkAqQS1/+WfxIbo6FTKb4GEZxu7rhZr4nHVNVEmMJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DG1KwxL+diNrbcaAE0lwG2Lo++u5WVdSnp6Ssjq3Vk=;
 b=AmcJO51Ps5S40ZQH/JXpDCSM3JNyhuFN/K5CKcXCYtywjWNg1IyTczQMZn9xuybeD/y67whxCiknseTJbKlLFMgZDWzxn6hjj1+MiK8AoJ6760jvGc8DzQobOzmyQZGBixQ46ou3pS/eOPy6vxaQyE5h4vuj1urLHX/N3xqCQBxUjQbS1L+9PsLcudfrMZBdKq7sJKuWQ6Ph8c1867raDXIJ0A5F2Rr0bXDaQe2QoUU8JsFssHVFQxR0kxs4iR60ehb/59KYNmb14eOyJ2VhXhFXDsnnrjp9HHlLch8ohZ+QHRbKtimNcz8Ezex+hDs21aTJV9scl3Hlvul0rNn42w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DG1KwxL+diNrbcaAE0lwG2Lo++u5WVdSnp6Ssjq3Vk=;
 b=Yi66wjQG1XfBnXpU4biZBYKSIs78uEIOxlHnnKx4I86YsRWdXfdPJV9Ek1rrW9fMo6vCTh2O3O1FWFKtNW0Sg7zqRAGQhRlr9uJpwAeRKaaZKEvZgy0R8pAlZmyuOT5b/JJfdTDd+hQI59WGJhB2TKXY1R8YSxbfV24jp2Hangk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB6610.namprd10.prod.outlook.com (2603:10b6:930:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Fri, 17 Oct
 2025 07:40:31 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%4]) with mapi id 15.20.9228.009; Fri, 17 Oct 2025
 07:40:30 +0000
Date: Fri, 17 Oct 2025 16:40:24 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
Subject: Re: [PATCH] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
Message-ID: <aPHy6JLIPQWnXoWS@harry>
References: <20251017045749.3060696-1-hao.ge@linux.dev>
 <aPHcqbQkPV--NCt8@hyeyoo>
 <556352a6-70dc-4709-a0d2-038e2cd4fd88@linux.dev>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <556352a6-70dc-4709-a0d2-038e2cd4fd88@linux.dev>
X-ClientProxiedBy: SL2P216CA0191.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1a::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB6610:EE_
X-MS-Office365-Filtering-Correlation-Id: 2593a252-2bf9-48f7-4a22-08de0d507292
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?PY/ANj+TrKpkvyYgk/FkfFevNYwxSMlXxpwdyS9RCg3MceCmBEiAQT5x4d?=
 =?iso-8859-1?Q?VqozXpBmHFpqUDgsyp/DB1a3Q3tdp7tGb6vXLcHTZV1PfuL28U3GU7/9qp?=
 =?iso-8859-1?Q?hRuBQh0GTZxkhd4T8C9WI+dHIepaJaq1MXK1OeGHNnLaqniTl1XHMwFDOL?=
 =?iso-8859-1?Q?CWgEse5fgY+g/RV6PJm8TSS2y5iLNdoTihw9Ubg62TegSJITp7rHj01nvn?=
 =?iso-8859-1?Q?4ilDB27SC5lLHtHu7dF+DVqv8dGgM6aivdM3/lpw/UN6IDIFDF+G8VPf1A?=
 =?iso-8859-1?Q?QfbnTOarUX8zHvV/yVymYY95xcSccB/Y8mhID3EGzIqeB0cmbVoY31/AaD?=
 =?iso-8859-1?Q?bxaeyAxi4NaGWGeMjBoFe/QMIRuCnJ7wF5zsWHwmr+fyVITkt3JF3HUU2V?=
 =?iso-8859-1?Q?A0f1k52fGBjhzbpRBePSHNmYrYpWsOyfSn0YmeY6QKpWOLrh0IRK0EAkI0?=
 =?iso-8859-1?Q?htDDF5T3XRHvQqCWbM97dJgQiOGqsw4voxzPSAZFaK2eFySrUlDdx1s9+Y?=
 =?iso-8859-1?Q?kqG5399m9SD3vi7H61zaBr/pRiFm1i2i3L9UA647nbUjhjNnFp+ACPeh6C?=
 =?iso-8859-1?Q?dYkk7YcCwAd7CcL+mHmqOx+jwiX+NvySaqdmK86WomSHcLHNL39O6sRrUN?=
 =?iso-8859-1?Q?HL9irf4dxvbtz2ZTZd2pVAHicx+fMV1w3UmhqOZPsGEc3xR0siNO3RBEt8?=
 =?iso-8859-1?Q?GZR8zdNNeDjzIrlR9QRE3OOyrpkbsxXhWNVmWU5IMX3qhYEo5c+M/y92Hl?=
 =?iso-8859-1?Q?YTkqbhnvqXRi7HbItLmrOtSw1olbFDezlXrEjTYzxGd+ZXr8M6Zxvtmekl?=
 =?iso-8859-1?Q?+zLgQdRbDwNsf0Ii/9IwsK7nFDYgsOapdnqu6zsWQjGbbjF9dR7a+/z5xg?=
 =?iso-8859-1?Q?OLhEoN3DyqhmoBHqEcvT9yexWXoM+rX1TapHKpENdlk05QS00i4GdAX1Z8?=
 =?iso-8859-1?Q?fhHV0tOWA6OEQRJwHoZ8RogH2P62z2miUvrNep2YY8bq2OQFsteSjLNX0L?=
 =?iso-8859-1?Q?/gww6MUgbNC+aHSs5FQd0+ZXsHfZzO5N7GSjN5vAWX4brjP//b4PfVx12m?=
 =?iso-8859-1?Q?1eXZoW/GGU4kSEY1uPO4/U3ZyuqrkmL32puwk6dMUllQQ68+mjrr8Aym9X?=
 =?iso-8859-1?Q?awAC+i3I+cHnMlX0oI16/Zsnhv+M0bmQxSEdEqgXSkS8lwmxWjbSPg13/d?=
 =?iso-8859-1?Q?g4JrbLLZZDbzxpcwdpWP+dtvEwsit888I1Ro0DD4AEq675pdBirTz6Dewv?=
 =?iso-8859-1?Q?zDGmwLmzqpn0a+Eue5mJJn86XKmbMRnVvme6KOvi6TmfMNzEQOt9bGkiur?=
 =?iso-8859-1?Q?brF+v2CWpqSVG6esXMZxcpfbwc0R2FKhd99tCx9+y8TOBHyMgqfjrSeWoQ?=
 =?iso-8859-1?Q?zzgrA1g2Jz19cbNq5rZQNA1wvseMzdluFWyOlgfANXcjA6p1qGlV9D5Ogu?=
 =?iso-8859-1?Q?qnLX75uQWY12z3yaWN19tR3jKQ9NIHSCPzjfTjmE8R7EDxPMWw9/QR3Red?=
 =?iso-8859-1?Q?rVVYoYg+5Z9dDteZQLbjCQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?RFyN6m/ejgJrG0uLdvjofIpdOfk+ydSDc1SM6xQ+Cn50hO2m2glKIE6XSO?=
 =?iso-8859-1?Q?2YkurxneKzF4oKydGCORjPmTEJvEkL47p+5u07qB+EXwCl9UwzsT8BLYJm?=
 =?iso-8859-1?Q?chTIBsPO4vYkCdOgKSpNLGXNXUMuTWCNeipRyxFUtYAwo17GXh9dgRuE47?=
 =?iso-8859-1?Q?YI4EQp+teKVuVl/K8dHmwRE7VkgqvO+pNPcO1b67EEFMuwcoRPc+SfpqKH?=
 =?iso-8859-1?Q?Geo5NaT/iBIA7dqZaUYB7ezEKyfyl0uNBsisPRYRnsEaxSWMl/tADlWAYO?=
 =?iso-8859-1?Q?pDrLLm+OZ5UTduOZ4T3Gkdktnr9iQQDHu0Od3n0bPhmBQ9T5K2/TRDXbpT?=
 =?iso-8859-1?Q?c112v9zDQn36uM6H/2CUzH4zA3VFCrwSXIn7lsoCLZAqrdHuOoDC19v9pt?=
 =?iso-8859-1?Q?VYL8BQt4ixzN5kEHHuOqyziiCgtYYNKEWh2uGA33zQxXNLk1rLvb4mogGh?=
 =?iso-8859-1?Q?rY8AXJHR437+85jGsXr7v04JxwCy6wbireNsEcn+UoqfnpzjxEMbYcqwoO?=
 =?iso-8859-1?Q?HUejXTqFUiSDuLB0lMXteIWqQLAeSWpRvE0IbAGcROKRf0NamZ+j5tqcOx?=
 =?iso-8859-1?Q?QOWqCWec8wrtmuH1KcWn/eq6j3F1hWQecuEc9xlKNbANgNQKEp+WYjvHJz?=
 =?iso-8859-1?Q?MHd501Q5sP++n1jg7l4BpRXHkjZWfauh2TvNSD3/Unr4ZXalkSnrev3Yxc?=
 =?iso-8859-1?Q?d+43SZw9FqwlHDAROQ/3onP+a/cjbuTI6BcV0c830n0p8K5vaECAtnmbY4?=
 =?iso-8859-1?Q?LWba/HM5uUYXfvxft/LuUnp6RO1z7yRDn6EGz7l2VnzIP3OAuH/8V9jWaP?=
 =?iso-8859-1?Q?O0wleXbYCzuU7CP3tP2LzoBOMte17U4anWroLyVyc2qWNpOjnhbCKLy8vh?=
 =?iso-8859-1?Q?iHdzNRDLs6cvFUmiui32cGyw7QOV6RUQaCwwIEcJE6Ibiftwz06WxsuscT?=
 =?iso-8859-1?Q?rajicw7GJqpeov48oV1QltaQCNsxhimRwEGadtbnnSwmmdrfV2y6SJYJVq?=
 =?iso-8859-1?Q?ccBNDRnbvznRxS292YCBy2bmX9KLUBRDoCfcZr19AnQtM6SH3fvWvOoG70?=
 =?iso-8859-1?Q?bRn3rf1UygfXo+OR4F/Hy0MHvM23EK+gmMEEBPeGlbqQyBWFvPPZxmldYz?=
 =?iso-8859-1?Q?bLnYu1LbW/6JKnNWgYSFXFZBl4gXO78Z0Zv2mgtr2Zs5nieDtY/Cy36NsM?=
 =?iso-8859-1?Q?ioCn4iMs5aT3xKyAHZ2WG6oAHR319m9GQhktGIDSCYkYjnZh7ytD88fFWy?=
 =?iso-8859-1?Q?qBsLwcr6xdg7o4LvEmAQ7Iz9KgS0aQiVg3IBAAZ4rTbYU3zt2l43UozqPn?=
 =?iso-8859-1?Q?Ub0m0F3ldybFhoNYMV78nliwuOWc0eOMMxhamOyU3ES6Mu8hun8V8JK1Vw?=
 =?iso-8859-1?Q?0anh+5ammVkzFZ2IpmYmR27d5GwUzC/uGMkbJC321q9qzkNus3hnd5Sswz?=
 =?iso-8859-1?Q?dPEYlWXqTYaXAMxBr+dqJ3LmGV1ccSFYbhXMiSxnm0Fw8MSkLQNPomVv2X?=
 =?iso-8859-1?Q?XCnGuqqTS9Z/oPi/wsFSjztxMEidsiPW8CBCb/lSThIG27u4TcBYwG4Cot?=
 =?iso-8859-1?Q?Wo9eZT9uhwo+NnyJJEG5OjdmwmuIltnIEiBl05jeqwz7aOA0nQ7+7CQXBd?=
 =?iso-8859-1?Q?+nCqiYQpsJAZ1sGW3V++nk4lpyuruTEAHd?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	02Vfw27cEkZW/oPTkf9ZJ4wx/9bbOitJTccCX1Iwu5sXVugckTyn3VYQIEt3NkTVJWWF+f5v0zV2+IKroQvWJhU2sWnIB1R7W8vh6Op+NOJSOSoDE2JqbH/W215KEWSlhjEJy7r0vvloz5jIbK9eC5XxAhjII7d8cvS2Y6v+UYn9V/TQFV/z5zxR81e30NLRfpFd/FpbcMiWg5NIaykhJTWBH9S/PF5Kv6uzVSE160IjgyHE0QupnsoAFY6MS5EPVHThxoHS5a0C48g9TpiqrDMsoUDIim/9M0kG/Mxl0Oawllt72CDFZ95gL9VImKvDBrAmOcKjXaAtHS/G7XbJFv7Hj3MW7qt7txG2oXV0652rNbvMgTR7x8KpQ/ctJgqSFyfnYkCWC5LmjiAswXCBprkAD0FD7SqxOmVOOIXIHOqa8dhhmwDkW5et437Z4FKXhUxua/O9ZznVjndIZXuiTFm7te5wspNyqel6847opRi2oomArM93vRJL6ov/AmW2sknVx1f3M+Tv857bPsmZPMuTsEpHPxfhvn9ZnYlSBCb/cvDhYnFkCLDTv5CN3cf41MnvsScEO+vw2JjgoRuwYPkmSxUGTiDWaxdlA+FsA6c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2593a252-2bf9-48f7-4a22-08de0d507292
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 07:40:30.8322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pm73HLRxSq77d10ghEUKUgIku0vrE5dzN4HUGejj9JL4BPe5YarN9OyFTSQT8yULdMY8Czo6ft6ThzAG8ZDZnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6610
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170056
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNiBTYWx0ZWRfXygl1Wh9LWC/o
 z3ybRbbuvr9lnf8EH3zWpg4tvg8I5/vpXWOaIf+9C+xr0SQQJnRJyqVS4Ry/gkDMU+jHJ25iUBQ
 igm9v9CQ1c3/Pq+maTNDP7iSzHBSWI2gOuW2wABzUgyyOw1YV1tEDOmPg23v+8SpAkN8iLWFjtZ
 wFwVjlDHNZpxpWhEAYUzIFyX8/2lzB2RMqTEBODY1jiEAQs5cOwjXa3bxud9XO6FZY6jpwOdgHS
 ojwEtgyaj1AE5qsCg1aRQqB+3mo/33sz23skwPANu8SNT9hoHgqh4AKd+LHynrHxZdQgEPSTgOq
 7QFl174V5NONVCcm3HF3KXg0sxwRN3xLU6KzRRfJh43q7qIAmsiQcRJX3Vhw9lo71i58p2vrrRX
 Uqi0rC6zh3G/ge3ngCC674pIeFIlnw==
X-Proofpoint-GUID: Ypu5YnoJWToHy8wAhchxVnXkpSq9y1GU
X-Authority-Analysis: v=2.4 cv=ReCdyltv c=1 sm=1 tr=0 ts=68f1f2f3 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=wzvW8h1II__D8GxyZYQA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: Ypu5YnoJWToHy8wAhchxVnXkpSq9y1GU
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4753F180003
X-Stat-Signature: rarpui4di4iayipoyucn45f5xpqzumpm
X-Rspam-User: 
X-HE-Tag: 1760686838-892481
X-HE-Meta: U2FsdGVkX1+Ka3dyOqPSTBtPGv2fbQxspYgB3AcR7jw2Pz1AsH9+XYR9xzx+JnV+VndoF1np778ZEqnR/5Z68iTFbnZUkkSvU8FH59SkSwQOjxCicRdaIhCK15IYHqp4JekGpIQ1QancgGQD5kymHixu4W12o2Xg1PT2UjJlsuKa07yACL7JDev5ezh6quP/HkN0fLduBUVGAVr9SvaUYHHUEE2sQgDtifbuxOCBFigbd9vWd3BRF+lQt9IfFQIFm19QgPBwg7yxSxoeG6JUmz4yrX0DaRZs8Rrgj5MW/WfuLRpQCYp7cQjR12QLR5lGtd6MmW8znXWCRJzsjX/QPmgi8dmT5X306oTxyZhh9Ph3c7cp195guWeL92gvhy3OpoULIYa0a5uejECSdVnEEViho7nXNdtpLzRu/89CunlH2jEIVtkZrNxsWFvH8m+jzc0UU2IsdcE7YJa1yU2W+kMlADGqNEsftHxvs1jRs7Jbox40pZ1Dj0e0MCpuU2QwSRpSSA3sYu0A5qdQRGMo6rqCDyfDR4wKHROjyKJmRhJ4ngUQ/OoEmR1LguLv12C/xR0CQPSTia9HKbMKHbsQt+en0tBAusmLYHbeKH9lRfNzDGH53THz2fy8Z7HuGA+frC9xGomR+2eXzlDCTW34FJTFIVgh4jozx4/NWBru0sjeQ4GzdHBycboj2F3pmSx6siKuJfjDVSpDLry22J6YjifjH7s2nUI7PV72oR1Zv4zQSsjwvl89b8XgboUUAksalkzyLRPl6VV2i2gOrWY7iFEgcW6p/LcVz+/3h1Trkv8v8KjgGv87EFciVxUnVRzRAcuVtIUAu1p09BZ5CfXEYFb6ljuYfBVlj79gyHYibuaPruaQwpuXY4ffqk/D64dBjThmABMF7Zt0PlfHfKrZfX6BjQ6oaI/J9PWmY5QcNiw1fyCKEpqsN5ZLWRFmjKscMKxZjlgBEv2U/rC8TTn
 eyaM8Auu
 HUPpizfvcmogC+agcJ7p4TK6j0dkSvGvajbLKI8VB3AJ/XLEL0gsGuw8/88kwF84L4OxA8G9SiXQpu+N0nzCrll9t7Hevv00uw12Qs5yMzIjwohWw6EhYDPo74+ja4FaBXzNREL5r4XgM3ANDOPsNguSfe3VlDLVT9DXOSUi5S1UiTCBJldkFqAO3Wx4YbxMxETCQ8kyc5+ziYows7gsMw0r49rLu8oK5h2172HGU+lrQHHGEzyaPh6RRYJwp1s3EZYELJH7X9DWTgPwNaY3f6NWLYfsQ6sfQov/s/+/5OdexAOmy2cyMTvs6VErzH4HrzEzSnEXU1rUVKgGk3bb6tssI1Csbw8s0KNNjDAbxebI8JoIc+YukXk9tE3vJXIOwWIdw2TiCkwK40Q6F89Ada6nRCybO5tTtDi5Gq2Q62pLDWUzUfkE1jVjs+o/Jc6TCiUxe2zZFXKWCj4QCqeXOgO42vy7sTSdXjLopG8QvTXe4037UgJ9ehM3zqqkVeoaXYj1tdvKBvySx01Hzms2FGc8yWHLhLdQ73ZdmmpdgYRPfsPNgiA1DTym3jMPUn/nNzV5w/TAJ6Ca8IoP/0jvygC7Sfh0//SMMHztPiCuRnAy+tHTez5P3z14blhph3lpO/fz5RqT925SR46t8Ayc7HBJEpKtuF+0tndiN391Ek2+DVapg3WpSOKYssbJlki/AMMbupZsoh0yK6/HgtyDAvwXryx39bF+bgU3c7cppvFBiPbZVv3B917ssY2o06JDTGJb9u4LFm6fctkmYi0NrAhhroWt8hKXto+Mmu0yStjiKV6f1PsIgR9+HnjoRQ5DoHUtDfujr2mZVwm6aDmhfVj2ApPEBJXdlYOa4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 02:42:56PM +0800, Hao Ge wrote:
> Hi Harry
> 
> 
> Thank you for your quick response.
> 
> 
> On 2025/10/17 14:05, Harry Yoo wrote:
> > On Fri, Oct 17, 2025 at 12:57:49PM +0800, Hao Ge wrote:
> > > From: Hao Ge <gehao@kylinos.cn>
> > > 
> > > In the alloc_slab_obj_exts function, there is a race condition
> > > between the successful allocation of slab->obj_exts and its
> > > setting to OBJEXTS_ALLOC_FAIL due to allocation failure.
> > > 
> > > When two threads are both allocating objects from the same slab,
> > > they both end up entering the alloc_slab_obj_exts function because
> > > the slab has no obj_exts (allocated yet).
> > > 
> > > And One call succeeds in allocation, but the racing one overwrites
> > > our obj_ext with OBJEXTS_ALLOC_FAIL. The threads that successfully
> > > allocated will have prepare_slab_obj_exts_hook() return
> > > slab_obj_exts(slab) + obj_to_index(s, slab, p), where slab_obj_exts(slab)
> > > already sees OBJEXTS_ALLOC_FAIL and thus it returns an offset based
> > > on the zero address.
> > > 
> > > And then it will call alloc_tag_add, where the member codetag_ref *ref
> > > of obj_exts will be referenced.Thus, a NULL pointer dereference occurs,
> > > leading to a panic.
> > > 
> > > In order to avoid that, for the case of allocation failure where
> > > OBJEXTS_ALLOC_FAIL is assigned, we use cmpxchg to handle this assignment.
> > > 
> > > Thanks for Vlastimil and Suren's help with debugging.
> > > 
> > > Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")
> > I think we should add Cc: stable as well?
> > We need an explicit Cc: stable to backport mm patches to -stable.
> Oh sorry, I missed this.
> > 
> > > Signed-off-by: Hao Ge <gehao@kylinos.cn>
> > > ---
> > >   mm/slub.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 2e4340c75be2..9e6361796e34 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -2054,7 +2054,7 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
> > >   static inline void mark_failed_objexts_alloc(struct slab *slab)
> > >   {
> > > -	slab->obj_exts = OBJEXTS_ALLOC_FAIL;
> > > +	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
> > >   }
> > A silly question:
> > 
> > If mark_failed_objexts_alloc() succeeds and a concurrent
> > alloc_slab_obj_exts() loses, should we retry cmpxchg() in
> > alloc_slab_obj_exts()?
> 
> Great point.
> 
> We could modify it like this, perhaps?
> 
>  static inline void mark_failed_objexts_alloc(struct slab *slab)
>  {
> +       unsigned long old_exts = READ_ONCE(slab->obj_exts);
> +       if( old_exts == 0 )
> +               cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>  }

I don't think this makes sense.
cmpxchg() fails anyway if old_exts != 0.

> Do you have any better suggestions on your end?

I meant something like this.

But someone might argue that this is not necessary anyway
if there's a severe memory pressure :)

diff --git a/mm/slub.c b/mm/slub.c
index a585d0ac45d4..4354ae68b0e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2139,6 +2139,11 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		slab->obj_exts = new_exts;
 	} else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
 		   cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
+
+		old_exts = READ_ONCE(slab->obj_exts);
+		if (old_exts == OBJEXTS_ALLOC_FAIL &&
+		    cmpxchg(&slab->obj_exts, old_exts, new_exts) == old_exts)
+			goto out;
 		/*
 		 * If the slab is already in use, somebody can allocate and
 		 * assign slabobj_exts in parallel. In this case the existing
@@ -2152,6 +2157,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		return 0;
 	}
 
+out:
 	kmemleak_not_leak(vec);
 	return 0;
 }

> > 
> > > -- 
> > > 2.25.1
> 

-- 
Cheers,
Harry / Hyeonggon

