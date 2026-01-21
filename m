Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C8EC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513736B00AE; Wed, 21 Jan 2026 11:51:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1946B00B1; Wed, 21 Jan 2026 11:51:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8CA6B00AE; Wed, 21 Jan 2026 11:51:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27C716B00AE
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:51:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC19913BB0D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:17 +0000 (UTC)
X-FDA: 84356561394.11.FE4907E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1FB51180012
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="l6JLC9b/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Uz+5YQKg;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTV2jJNwQsTIqVRgVyikkrl8qhSO0lgwP1k70Tn8pwg=;
	b=IlLeiy64grithreww+rb+RsF1oiVHFEywItb4wt1vS+lZhw+Qef38HbU8424XDbFC/E4Lk
	YGOBagZUV35yWTTNZ3e97/2wQdM54zzZVkWTrPW1w0owgVCiuHPWeLPhvEotoDb90pBXb3
	V0l7EBkk4ZVYY+/+kAltQv6e9P/svHw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="l6JLC9b/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Uz+5YQKg;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014274; a=rsa-sha256;
	cv=pass;
	b=sgaKEIcBsC4MiIF3uFqd0AhvNgwPnxzU4rh2fsSOzcohVX2IBkp2bAUr/FL4093knpojZ4
	gN0XTA2je9EF/7uyTedI67z/C962KnC9ZwRnn/rBm77eyvtsPvTm/uS9JZR4Sv2YPD0WQ1
	rJSWgjFJ8KGtzJ143u1lOZBy+Wig97Y=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LAOBgW3420379;
	Wed, 21 Jan 2026 16:51:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fTV2jJNwQsTIqVRgVyikkrl8qhSO0lgwP1k70Tn8pwg=; b=
	l6JLC9b/VuGE74K5s6JfqlcwYlX5WF0jFdJEK6sE5x0RfB1usZs30D14xXkyS0J9
	xQQRatZQkJBz/9Q0voUugeiyTKzgP/caN3k1v87HyjaDE1dJPYW0e9f71olrsgpe
	o4vPRiCpdTRZAZ1QVfZZwvGU/DZnxWxv0LwHpblUQoQIouij6ZKz8SzoX7NhrL6F
	NkFWyviE09f62ylrBFsCxEj7mDX2SIqoK6Gl9oAkf3oHGYrzoTUaC+2eTNj9tHJp
	8DC1/XFGEx0CXUXwUinGGkVxOJKoGy2ZkRo5JDy4nFkg1QNcQKvUC1sfsR7s3FWI
	HrXVfXnwUll2xMrzJJ4MGA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9pdnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:51:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LG9Ds9019988;
	Wed, 21 Jan 2026 16:51:01 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013035.outbound.protection.outlook.com [40.93.196.35])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrsbnck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:51:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DIhYzYdZxCuoflZYkCkVGQsNXrsPMv0AgZ3p3y13sbovTGpae4qREX9rG0Dkl1pYQYNNNY4X+vpqweYODGjkOqc4oPSxeJltKn8qtAZ7KZN8QA913LLSNd9zjSqiz5iYCci5vKcTCJHRYsyTRY0OEd4ng2/gEjzP70vNbQnC0ItnAwMPw5NVHFMxtyofNT2FJUdTbbMdrYw+CLzGVLs0ghjcr8cT0OuOy119oaQ3OuclYDdUnY8gHngfcnLYRkvxZYyoSk//k3RTn6gBa/qvRnm7HvfnyDETFRtSBJGgH8iDArCxCOZZUgGF8Mi2EbWj+hmD3gfVdR3+NTzm8NJZyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTV2jJNwQsTIqVRgVyikkrl8qhSO0lgwP1k70Tn8pwg=;
 b=al5XUAwLSAAEw/Mav13rfszxgjGocinJl47kcBpUNOy/GcizNlwPme/fHF9GEe0txj9GF1yUQ4iEcU7T4eYhcpOQWKFSfHIVMlIAOJAdKypFCgG3wJUPbzhuOf05YFh9e3j37AiT48jJAp4TRSmZZb+2KChYFsQXJiCKeT7n++J5QW9jfOrP+W0x9FCUX1uR+lGiKhXRihMbHzTBa0opnzZI/tU10FUFtRkIAGejUrM8i17h68tLpcYdN6dO0wIs0ElHmy9fS2Z4z1SJuR1d17mYDuv34v+py3OYzA0RID29udeJoIETAaZGGacPonBkiIXvqh/OeoLVdrLnPuiSjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTV2jJNwQsTIqVRgVyikkrl8qhSO0lgwP1k70Tn8pwg=;
 b=Uz+5YQKgTaVJz9PQcGl6AbUVTlaUB8+KTiTwp5yKYj087k4K/FhYxXewl5TrCkYxQpFr37EK1R08LwGzz5qU5eV/rejB7AgBk1js8e21zD+lgN+CfAGC2XGLSMFfYL7UGzEA1SkHITMrSs9nU9Sw6gUcmQVETf9+5RPMZHsYGBw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB6027.namprd10.prod.outlook.com (2603:10b6:208:389::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 16:50:58 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:50:57 +0000
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
Subject: [PATCH v3 06/11] mm/vma: Add page table limit to unmap_region()
Date: Wed, 21 Jan 2026 11:49:41 -0500
Message-ID: <20260121164946.2093480-7-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0317.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB6027:EE_
X-MS-Office365-Filtering-Correlation-Id: 97167f9b-daec-4b42-7454-08de590d3fa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EuZ/3QTn8zw9upTWWh289W3H/Myq0o8uxzj2P6SjfKcsB6R7m48AO0wnu3xH?=
 =?us-ascii?Q?LY3tUxAlpk7YqWB53j8qHl8+nFhNYQxe2LeicSTeUYUVSqYXo+gQdYoMnIm3?=
 =?us-ascii?Q?xTGTpijXbyswHODLoaUDEQYdB4GGwnjgVr73hV1syGpdhv/Rir90BGI0mL2B?=
 =?us-ascii?Q?2fZGmBBRd/0i2js7OzT3DfG1KH5w2ZhXL5w5AHMkK1pcPoBf624QuoxKx3k7?=
 =?us-ascii?Q?V+L/QEfDDPVtBXRNgap2FS7OgBqxgRNQoHq6y+f3HJAMzKXnVFMOhpcRaP2b?=
 =?us-ascii?Q?lf8O+I0Z0Ge/1lGBQFEuTAC7NVvb/asVKZO3hCGuQOlgNcm7z3/lhj32nWAf?=
 =?us-ascii?Q?xhVgwT3YzVfz2EQYoSV9rTf485co0a1rimXw6hbzWE50tAD5bWlAM58R4pbZ?=
 =?us-ascii?Q?U1WoSqZDG5y1rocjR+B/jYF9RYadiBLL2jR/V8LVqzQyH9aDgfibS9ibvsFJ?=
 =?us-ascii?Q?NQBKChGeUfykt6rxv4ipGZNQ4NB2Q/98sSzZRTEtVpyUhhBx79DMOSfXAEro?=
 =?us-ascii?Q?0XBp0yJahX/QlzZpTkHAOxWMrnXxCHNMYHNObiC36cM49hnQukd88r2wTS2w?=
 =?us-ascii?Q?Yp68S7gwoDOyhb1875qV3EoRwMu8CjPl0BUrQKKmfVhipCzMgTQbB4yTyHjM?=
 =?us-ascii?Q?159uPBUN4Nr/HObl/WZzAFkUoa1uaIdVJDANqp84IH1+hZbVMp67r/o/Zd56?=
 =?us-ascii?Q?KkLZa9LBPPf2umLulqX/uE7pDcrqFbVFJy9V6qOMjj+e64VCv2S/uLxals4d?=
 =?us-ascii?Q?O5kLnPq1z+agM9JYPOLSaK+V5xrLNrVPw/c5Cwxvz7i3pDkJgQWwx7ubkQ6i?=
 =?us-ascii?Q?vnDzMTpQXvg+nByAIPegb9QSWVje0nXRcMkuoAdwkHC1Rh6KfUn1eGw2XGor?=
 =?us-ascii?Q?E/PYfT6U4BNPllncPV/g1RPtkt8fUMCpOWN98HbGwVkcmKHfRsA/klVrVGqY?=
 =?us-ascii?Q?h4ZvtOJvUjtEWliYC23uNionrDOFzrD6efPK9pzy8L6I/19tcKT8Ea8t5hLv?=
 =?us-ascii?Q?f7CULOZ0h3YRNQAT672+oXyrBWakWp7YkkPS0uSrdmRULN7i79ZceZVrfqy1?=
 =?us-ascii?Q?1ablBXKb4TIbYtKHu7W/kK+Wd0b/e+y46dy5OCZ91gcODfPyNdBCTDPuaoJU?=
 =?us-ascii?Q?Xenf0s0fesy/wydFnZBM415/vsSzy7VcS3bUEt7eSufn3vQMg/6LgcVK7dTF?=
 =?us-ascii?Q?+OIYWs9Ha1FBhL4+J2HfxOYZXacevZhVZ5W3y19Fc54WdYmEfNIBvZCWC9q4?=
 =?us-ascii?Q?yNadPCl3ZgM/c04hktdEQAw2uwq/WQwb8rF3jG1J0h8/iflbkzFyt4VCIKcO?=
 =?us-ascii?Q?FfLDnkPYLhLlj86w2X1s2OM0fIkm4Pu7ugQymNvNG1wFzW/LOv/EKqmoMPq4?=
 =?us-ascii?Q?NLO9McELYqunc6NshWBF9Gm3nth/jGxwnoHo7VVpv2BXGrDkrHXBmoO/xJgX?=
 =?us-ascii?Q?wlgxk50LI1YBhaU915GwGngUlEJWNU0Gl6PvBP9bmDd/5cdLxoaVDuDGYOnB?=
 =?us-ascii?Q?4SOzYpGiwf+KYCqTuCXnaAccs89AhEh44PwEAQ/sasvrDHLEW4Ty/ttNWQDi?=
 =?us-ascii?Q?Uw6In/unmwBCYdrxb4Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cytzcF8QD/p+vIE0IwgSwmtktsf2uOWPJo0GJFdgDpeBb+iY2tqZ1Ba9pFxP?=
 =?us-ascii?Q?5xRjMGtZgT4kgPWit4UGF2l2ygBGWRX5NbCmYr4hcAqPH6Xr9jboSB/Hd6F5?=
 =?us-ascii?Q?2AY7Y3oFHEBkpnW9sCMf3Fci/Y0tM4Pe6jpAeSEVmRTbFUhnZ6U7UfBfXt1R?=
 =?us-ascii?Q?COBmpkRGJ5FKdQWt+4oJJB3/lui4f3qO7fd8hCuH/w9YHBrZhFoyrGLq9qJu?=
 =?us-ascii?Q?K7hrAWmqjDzTCGnfmALIfmpZzzPu0ZW+z0qahdlZ1qX7JmE+vjEYk63a8P+C?=
 =?us-ascii?Q?4XWujR6PGd4XJAk/mE9WbvTGSTIQ0xdc9zqqCq8aQY/1JrSRC+1SBpgW8ay0?=
 =?us-ascii?Q?RLgrDdnNtMPB2iPbi7lK3OZ+va3qjR+D/cgG/fcdPSt+1KTxE5bBI3wvBb1F?=
 =?us-ascii?Q?xy/4JqHFuJ83wpSVs/iZsCa8haKW3Dh6UONhpJJA4IKe9xteabzMovVTkTa7?=
 =?us-ascii?Q?oDQ/35eHkHHIXYdMmDn4O+WRtkiemrKbxbnQuJLKBAHuK21OUoa3yoRWGA9/?=
 =?us-ascii?Q?/ndCR+U5Ie4opT1hJp8Ntggiwfq5rAsGBfwZHtgGLdCq/Dr3wt1xQ8IpD+vy?=
 =?us-ascii?Q?cX9vz5caYTZPV5qfLO82J+26kZtb2hX6XXuIApdo+woHUz1dGAgzoP2cu2rJ?=
 =?us-ascii?Q?fWur919pi9tRi4+9zUHgGJVbv1m9grL/ftF/4QROXEKTzuevzjg1K7iKsD+B?=
 =?us-ascii?Q?d1uXKU0zyndtwcPTBMtGMhaFSIKDK0/+yv4Bd5JPFYI8CzuE9lMFc9EBRB+n?=
 =?us-ascii?Q?y82wDSwD+XVWnkiSsLlOk8YDAzjgk0MW6Q6nB87HPQ4XlAWz2Xb22w3+Nzqu?=
 =?us-ascii?Q?xy+kpNGkrzikcSFUWOFIyk4BJaPPAWUHSJEh6xBPtzVqK5QmNoglGsGqJi+U?=
 =?us-ascii?Q?kX1irvi1PpR/CMaYejHGRy9bJfF0PehhUVXdKEN9856LH6J8iq6T/Iz9i1RX?=
 =?us-ascii?Q?b4QWxuozLj/zpuQCxajpk2Zi1Mcjm4qn7sdlAARSu3oBC2ffmE0J4kj5IM9e?=
 =?us-ascii?Q?djXw6P/pMgqGnv6Mi4nYJiEKYs8YdGZFqGx4BxQCV20MAOrAArNoq88LzWS2?=
 =?us-ascii?Q?tmDNwH5v7TDXLMLvgta6G2lPZG1iv9QyNzj04v+9RcPHz0CwCGXfTITsfPai?=
 =?us-ascii?Q?X3GiMNOdh9n9yBlSx7hEidkeX7AVYdmauxhW6IwZv/p+lYsloWsEKbdtTk+k?=
 =?us-ascii?Q?VV9dXZuAH7yxdutG/ImM42+xqWPW1pu0fsNkBZ8JRoZQ6np6YIQhbqPDmq+Q?=
 =?us-ascii?Q?AE23RQUfkrhW8InTm94C99skuQd5FwWu/zt86kQbwZjNLzyjrgQMPyi1zeaZ?=
 =?us-ascii?Q?/n8C6iep/qgC8kffc63eokgrV2maSbUB14gLorNOJpb5xHzrtmJStS8MXoQ9?=
 =?us-ascii?Q?eGFRoBdDpOlct3AnY1DrnYuny3xNyYHaXe95I1WT4ASyGOXybVM3lDtOAfa/?=
 =?us-ascii?Q?3bk+rGW0AH7K0xzPBt3R0th/pSGdroFwn4xPQKN7XqjRzzLuPMsg2qFu5J41?=
 =?us-ascii?Q?BCg27K9vNFewT5WsyI4ryo7yeCq9z/kKn2iiEggDOBj+7WF1thTlge23AWc2?=
 =?us-ascii?Q?+A4v9NN9t8FZG2HGukLLh+U8zNtBmGOfC6TEJKGaIMj6HsxSEjnm0pu3gjCk?=
 =?us-ascii?Q?GkU8iv/xed7NJRPP8S7aUHqQk/fOOpw98vJEeo1dgz9muDebKlSR15k/1yT2?=
 =?us-ascii?Q?1np3w5lXQ8/IPXpIUBc9NkmwUVFJfJKrKJaZBO1f0CAqYtr0pdtCG9iUFJOW?=
 =?us-ascii?Q?BRVEJFXm5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RT10ShT/kw+UMjmCMskdz18Zx5ykDHs5Ar4hu58AdCzdcPj1hOcSR9tE1o9I8osvLB7ZkDekzGZwd7di5xi14Oxg+2a6E7gaNeR2ChsQpcAChX0nbo+3xUCRL5xdR8sNSD8p0JXsxUByaykovE3/s0dF0TVytLdkvSz76rpwqMwD74kwdynq6FCBIAb+G6Ad0MxdQH3Jw1zWgYiNGq7718ejKGcBc6QDSlpuB6pn1kosFc/sUBCp+nvfV0yQCoWMF+Za+Ee3GuixScvNVGkoxrMx2BIKzXLGJAT5tSz2mQz/5fkXYEp/63w73ILL26PZ2GYBsY8XDyPyEuFnp5vX+PpB5GwPk6MV1Ksqf4Tox/1gGO2VMPgDW6gFN4kutuOnApkGDc6kjkvRUJRBY/Azz+DY0nbZGja5b4crr1FyLCluL8dzdhfxhSXD3i48xE63/vkbm8BuvZGS+APOCCa2K+pWBUPda1Ic5cmJsY5AKePqpWCoqxnk01tFm1ezHctqz8efxF8FfYs3pUpr5KDBYuubRHnmaWvgq2unIGMsBdZ+lEajN7mQoCwAx642cBep0GZKGp++g533R3mUVIEgqx6WY91JdlIdANu7e+XS4Jk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97167f9b-daec-4b42-7454-08de590d3fa3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:50:57.1552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fpgy5lqmDnwXGaCljP5YahY0OaH89suHFmoECVOnMsGwhbHmvmcEIvMsH+cELyTiTpv6JJWgF0bQAn+bY0QfLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6027
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=697103f6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=eNAQnf5BmXaFxOQR-HAA:9 cc=ntf awl=host:12104
X-Proofpoint-GUID: yDu8UReXaw5xQJJUXvkb6ts5gdBr6FXT
X-Proofpoint-ORIG-GUID: yDu8UReXaw5xQJJUXvkb6ts5gdBr6FXT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MiBTYWx0ZWRfXxDzPcUB17BuF
 acUPm4jKYkAI+/wnFJcklJ0EyQcGLqQfVx41/Unz4l0Ar8XVvPbyl3TZK4OJizqrjtD3nwNtXuY
 8wqpoW24F7lLDXvLMqbr9zfqZ/CJlrlOEwu3vLhPOfU2wR0Uk8Q0YDCvcMuUTfsgN8Rkm4A1CHf
 1f80F6HWRlmfNQOULhq5r5uRy1yd5hyY+ARFtb5s/fNw8N2Zp9ke2ybyRFb1s1lPJKMI0oUMeGW
 3dISnRg7MydqD24s9WjE++ROLDNErEj+502QG7+eyCtV0tY1/Nyl/uAln/OGg/85zUkIQFyYGms
 rFpuH23XxYSnTOmZhda94ctDj1TdcXneYBu+QWOhTZV7KJN5pxMEI4PdlOgMrHNMCJY7wy+RGlr
 XFJ41PXsDMXPupBm0thkHHffx1kNJBNQ1cmTAftd6G2CdXAnxjzUoYMX3V3lCsT53IfX0xUnHRI
 kuGspUVW9jr0NBk5xQ9F/LyJh1Oh5wPA7URwUdO0=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1FB51180012
X-Stat-Signature: wsiyp885d6jbt3ripd4y6ckqbcbp6tya
X-Rspam-User: 
X-HE-Tag: 1769014273-903630
X-HE-Meta: U2FsdGVkX19QqsEdV16D6fa7FvRWMLpKHBWMu39C3p3Qhnp/xGy8C+ho4yW1w4BXET2z5JFm1gZothFsVqbUid5SRNF1x6q7s52XVTPOpU6oCjhYTGnrj/Ra7F5kF9UdDVlgThGaOEDlDYs32zXueTURTwyszY6TKej42wbFPt4uNwz+PcwMXVoizFqQ83kC+yZwSusLk6fOvpPhT/PxbhMOYppPZkGlgJri4brEO6D5vEuo3hBL8ESSGSEwsXI9Nq/JERAJdseM6YPrg6JUFDXqoyPi+FBWbQtFdCw6xh6r2cYYdF2JRe3mu8xUmxwQCbcl+HES/e0a5HDBXh3nWocXTFlnF3zYDUMkCK5MZYzm4FaJ8JC3oRJW1233aEJYPBa1F8QCDf0yqU2m7LtqoRC+ezoNkJRmdxWe64WvEkFd39ilzw7xZw/pVTVXUE1hgi3i/aVCp5PDc1FKANDy2gWudTbNYKjGZmLfGsY7bR0188aQ2PdnJm/1/DxIJoXYANnOoadTeFhtBDiBZB5enBu7/Wc4G3zqssbH8GiNtiwTO38OhqmtCXQwz5IDvXJU28yf5yCILrL3zUCZF37JAQ3ojgHed5ud5rSor55uzEz9pFA8IXOfMST//3kB6E1Q+PaIVoEpq5krGDMCby9h7xxSb9FIv8ZGInf0uUDPsfddhvOjyVJ6zn6NploeYunJ/QsbU8Aec4Xm3Y3EdO6X7TuVQ9Bq135uaAgXGpBSBbw/ycuDoEwNFG4Smja+T+lX7OonB/4gnZdJ0vRlZmtOx00EuAV3No5PC47kSKQ6e+kjXTIqsWTX3ILNvRRC5dnvcltzYTKAs+hgLFksvDLdaCzOqFHJZQ20c7WLPr0+WX8WenbCgOLpiNd1iNvqYpbmNde1WMUxGuA1ohftcefaDefOwOnlTPKUIHMxDU56BqJj+NipTGSs5WDn/+Fxo/bVflo4TicpgC5M/HIoi0L
 5ZdiMbSL
 egHulnby+M/ICHuhMX07H0qT9jdzJvL/O03VFa06G9ITnXtcOyYykphxQC0JgJiAFo2J1VkqjQkd/GrmHObROj6wvEUY0CQ75QhAIAGoeueRatMimoUfJ39LsCAk3TngytPPx0tUE47awntu5SR/tWCZZFClENiIQVJ6T3oSiBWS1/Zf6P7JO2iylQ/VisQm8Yi1HwgtB5OFSAuLha+MrWBQL9Btyu5xtiBNExByCQa6AGFRavQuQFjceVg5skleuIXg0c339BNQSkV8V2Llf8baA4pr+Mc3a8YYUSj3E+kI8v9I0XZflB7rZB8LIi+59IPOgREpZLkXOqqYrg+rqsds3ucxYpQ1u8IeXROhC+oRI9L5JSEn1ayOAz4GfmOgGRarCj6qOLuU95SSKFdzerQJ7+ZV164KZKXEe/1g9qMHi8U3wiZqhI/vtRLCGvJ97XWEPJAbVctyyDQE0fysfX7f47dq8jqZWf1juMsAF0bH8qu36QhS5VV3SY4XY5HAsD8mtegQtXwbsPfy9Y2r+b2+vXzbygM/yLdsNvHjrVpD3YtFgj8Vi10NFfjOmgYkbD2wT1gbemk7qhQk446N3HxXbIFNJA26qNAmrBXhLj1OC3DW0+NcWqBVkRcw3uY9qtNYl1xRng8yJu76Cn8DOEx5gy/rz49Uf4u0ob+kgKfaLJHcLdWYGnKSrp83t7R4sLGWVlf9c2phxobqE3seJplbe2EAQbZSlF5pX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unmap_region() calls need to pass through the page table limit for a
future patch.

No functional changes intended.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/vma.c | 7 ++++---
 mm/vma.h | 3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index b2b9e7b3284f3..b92383e5eebd1 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -474,7 +474,8 @@ void remove_vma(struct vm_area_struct *vma)
  */
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		unsigned long vma_start, unsigned long vma_end,
-		struct vm_area_struct *prev, struct vm_area_struct *next)
+		unsigned long pg_max, struct vm_area_struct *prev,
+		struct vm_area_struct *next)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_gather tlb;
@@ -484,8 +485,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 	unmap_vmas(&tlb, mas, vma, vma_start, vma_end, vma_end);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-		      next ? next->vm_start : USER_PGTABLES_CEILING,
-		      next ? next->vm_start : USER_PGTABLES_CEILING,
+		      pg_max, next ? next->vm_start : USER_PGTABLES_CEILING,
 		      /* mm_wr_locked = */ true);
 	tlb_finish_mmu(&tlb);
 }
@@ -2469,6 +2469,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
+			     map->next ? map->next->vm_start : USER_PGTABLES_CEILING,
 			     map->prev, map->next);
 
 		return error;
diff --git a/mm/vma.h b/mm/vma.h
index e671adced3a03..7c2c95fef240b 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -265,7 +265,8 @@ void remove_vma(struct vm_area_struct *vma);
 
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		unsigned long vma_start, unsigned long vma_end,
-		struct vm_area_struct *prev, struct vm_area_struct *next);
+		unsigned long pg_max, struct vm_area_struct *prev,
+		struct vm_area_struct *next);
 
 /**
  * vma_modify_flags() - Perform any necessary split/merge in preparation for
-- 
2.47.3


