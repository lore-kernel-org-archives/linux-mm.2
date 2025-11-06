Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 415B7CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BDB08E0010; Thu,  6 Nov 2025 11:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794948E0002; Thu,  6 Nov 2025 11:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C478E0010; Thu,  6 Nov 2025 11:16:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5505D8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:16:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 14B091DF6D6
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:16:41 +0000 (UTC)
X-FDA: 84080685402.14.65D8D8C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 57267A0019
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:16:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OfZ3tZGV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Rab166xh;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762445797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1N7KYauyPz5+nuMfXMNIAlb67+jhyqg0myPt1N6eA4=;
	b=3by0A1M8mrlkRxm38j3ri1p0WxTkLb58jipQThLae9rD0byp3bja+Zbh/33I7YMEltwPDo
	RXsFVc8VDfRsalaxLr2mxCQkyFPOhiSmpjBYpS57hLxhB+JNVzBaG2ut3svTVz12nUku+5
	G65WtVaoNo0WA5FezCO0cxNFn5T8YwA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OfZ3tZGV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Rab166xh;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762445797; a=rsa-sha256;
	cv=pass;
	b=1WMBui36GS8hCdMa1pO9Kn2onvCbnfaLzC5D23ZxZd8y4cwqQZpTPuTO0zZv2ArUYV6/Nd
	K7yzS9rDnl0y8Zm0i4OL9qBVLfe/M+DJqtlwfTTQ02yRik8JiGZvl8YjKH3AVz8LU+ndE+
	D9yb9FaF13D6ld5OPQi4Fw12njhks5o=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6BcJfm032322;
	Thu, 6 Nov 2025 16:16:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=a1N7KYauyPz5+nuMfX
	MNIAlb67+jhyqg0myPt1N6eA4=; b=OfZ3tZGVqvHStRfISZszMwz2BJAIjXSOA8
	ZUJ2ztNrq+E8wD9yRSj0FB76XI0DkiS/zFAIN06w4lbANX8QV2QUYdvN1KvisLMR
	JvL62Jw9Njsz1UTlKrS10zVLPdXpJ63QrMiyGWqld2i9aIEDxbiV38adlRcKGxC3
	S5CJhAe/O2raEFRcvm5eTnhdgllufsmC05cozxKSteyHoxF8Op5ok69y4zwiz2jP
	QbK24C4+CqrYEg7nYMUfij+dD1pwUTSHaWnHwxautVMBYJwqcrgNb0zr4YfKtVS4
	HTACySR8m+zypkdNJ4ifJs8kYdve0EDdBvi+KxwMq3mhzPBhApMA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8at92cuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 16:16:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6G7GdX010962;
	Thu, 6 Nov 2025 16:16:29 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011059.outbound.protection.outlook.com [52.101.62.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ncm6bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 16:16:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qSFbVAtidS6TjsmbM2/psEJCWRyRc6IFmBWAJD7WGsE752N/OuAXJxRN+c2ELouaKq6sMJKIkQ7JNLSm0r7Ezspnkn2JG20ZBQE6kKhU5Zmph5UIl3qiXy/Q7jmseLzOEJn95PtW3hQkyMVrl2URPHQeZfftvTFSSNGj6Ud/HcXST3GpgDCNs3SvHzDWiHOGuQypujzNGmTGn5fbxUj1X88QJWtUzDORXsemGcV2AxhCjry0j9tw56M545a5OFXKYb+peC/hEULgWwb+vecTiZopOAU2UeEUGvRur67osCzFERz8ReFPg/lFSuF/aT2b4Q3W60u1dYafAeTEVrEBig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a1N7KYauyPz5+nuMfXMNIAlb67+jhyqg0myPt1N6eA4=;
 b=ZKxcPIn8ExyHq0ivzcGDxOQqoCLyJYDJloyrpOnwAIsHr1MuXUQjrxowjkP7sbHTtKJ2v9bvaLXpw09wawY8aZbptryQYI5YAilfg5taq7OoYl6x3iBhO1C9WNgiplBRef/k5Gur9dR7y5mrB0a2byFq3f1ykJR7xcdeNyF/18E4fl9/N24YGpGg0cdyPaH3OkrHdZ7Pf5hTxCVYIhSSu7AcnsA/wGiF32Dpz9R42eOp1IpPyja+ZVyPMsygPzJHxRqmjWYreV/7+NkBPpVOGjh3Y+tKa2757kM6uRpCpP7APx/pDfiHmrfgokQdT/Vpp3YOXIISgvQapgXCE9VWUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1N7KYauyPz5+nuMfXMNIAlb67+jhyqg0myPt1N6eA4=;
 b=Rab166xhftsoKpTUM3Io66zpJ9OnrDXJQeGcoLKaJImgS1K3R/SREJqlrcINAgUeP6zK/6+oSMuGtI9iVjjV/taeTeon4vRUTQ0Akq5K5RcBRoFRZ3d/U1k+93Up4ae/QzzBxn+AT5hRGUfNWeepJ1cPzmvY9KdNyWt65nrf54k=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ1PR10MB5954.namprd10.prod.outlook.com (2603:10b6:a03:48b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Thu, 6 Nov
 2025 16:16:25 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 16:16:25 +0000
Date: Thu, 6 Nov 2025 11:16:20 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <dhildenb@redhat.com>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <boylgf5thjyblsvjlumxrwg5qfl43e4revh5i7yyh2yiddhgah@gtht57bgkuzn>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <dhildenb@redhat.com>, Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Axel Rasmussen <axelrasmussen@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, Andrea Arcangeli <aarcange@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <78de3d64-ecbf-4a3d-9610-791c6241497b@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78de3d64-ecbf-4a3d-9610-791c6241497b@redhat.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YQBP288CA0012.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ1PR10MB5954:EE_
X-MS-Office365-Filtering-Correlation-Id: 6daf218d-05c4-4066-4103-08de1d4fd518
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kb+5cbFAdfyq+Xa1RY6VuwlvUhq4RYyLVATXbZYPasmMuRzHxNWrk6p1WuF0?=
 =?us-ascii?Q?SMpdwecMSnUuDC+ke3Pbr88N2rbzDScuwACqLKI5anIG74ySG/0rrWmjq9cY?=
 =?us-ascii?Q?h7ncuoUHeTNkZYn+CXIbRJpNW/IAHdVYA+NKhPwP61pW5ymM9o+zEbtc9SqV?=
 =?us-ascii?Q?2Z1hnBAaVFozb0ATcvQDqEf5kH6qhSSGa36/ToqayhXJM+QZfNIuQGWExwOV?=
 =?us-ascii?Q?ouS8xgiLemO3dQSCPIM5+IBqtwmHkAHhLcfjvAeJIsO+NnDO7hSz559A1jH2?=
 =?us-ascii?Q?DY/Md/Vo1sgLhV3VOHbUpVFSPvpARXPIB3dzIlMNXmdMgZCxdkgMGyR9y+fL?=
 =?us-ascii?Q?VZBCXvUmroDumDRdzwzy09hKkzWgpAKBMSbPX4A2g614914A+VKJNsQBZjG3?=
 =?us-ascii?Q?4XUOL8HGMVMSOGyrFPvW1udjlQ44a3S1zkM1YNSJr+j9pWHwmZg3264v78J5?=
 =?us-ascii?Q?dxMNzLzq+LNdfLZxkQ072UMRmqCbMbJNxhRaAL3UdaJK9CBHguA6Zw6YD3lE?=
 =?us-ascii?Q?qBJuX4d1S/BpnOPf1DsY2RyGyT3cCtV0Ul7i6MWOVAIUHLVRX2DejOiIV2ZJ?=
 =?us-ascii?Q?js1AdA8mYI4ViCGdob/Ri7PnIKiEZGVRQh4C1cXadellSoUP0nNr1yK+fiKm?=
 =?us-ascii?Q?p2Pc/VWlQ2mvysft6RptEGx+P/bc1jOrHTj/l9v3qISsnfCE0cA/vn1LwFBc?=
 =?us-ascii?Q?uA2QfZ6EnAjBcPlRqB2leG++Eyk86vgTBS27p4oUhwvoIUpDUr+GcByAfWBf?=
 =?us-ascii?Q?miyLbeqR2YqLdcq4dOuudoDenj5acMLY20e93yeEGuwBd90cKT+kXeEQydnV?=
 =?us-ascii?Q?mUMSue2CL4939UrAvjJqp1XZ+vQqAvxXYvnw3vxNZRLzh2Pu870nrA18wqAF?=
 =?us-ascii?Q?0lKDqrI4sHaNtNu53BEC/03ovmB/rG1CFyplWP0M1M5oWFDxmJuWyYcPHv74?=
 =?us-ascii?Q?r+F0P6OJBra1UTyhxrsakN2DWvvnFuooG2nPfGQhCGryZtCd/mLEfxk587Wy?=
 =?us-ascii?Q?0HlNX6NRX2pGouAHC4Cqwwt1Hwk8NIkVqYGn9AbH6ZOuR3usylSLqWz0T4KR?=
 =?us-ascii?Q?wbY22EGpGEhDLKR+/Uj6+5OgupMH2sxXNLIqPwVC2QkZrz1iG4upRQcerrHO?=
 =?us-ascii?Q?9CVlTBkJng6Eu6LdzHayYXvhqYweqPqMnJMWUfKRnT/42HTff1HyPQwhgSOb?=
 =?us-ascii?Q?QAeHayg40G9qJjME3/8upfnQm4aUwuhQCzlUaT2hoWVVejNA4jlaEdmGxRRH?=
 =?us-ascii?Q?sEqtWIcXCWEyNtAKLJIvdhglV/m4rPht1JccXO1gXR4hoIzeHMpau79DYO+b?=
 =?us-ascii?Q?NheGzZRcrMbYfQyF9QBVJAeBhualy49GeS7CYdWuOyM2vGk0SbYQEDhX7CxC?=
 =?us-ascii?Q?tk2iwwK4+bZvb0+DiPWM7qcOjBmEvP8frv69Dn3bM3XUzB2YBw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MqR3HbKvsx0RujLHzBz2aGP7xvtwsXH8P3OECy1dE8Atu3DwzVy9IP35Dcdz?=
 =?us-ascii?Q?6urGk+Y1B5v9K1xd0o2IsKNSRR0CA42mpEW7QFMHQ1+ojV4j4VzOQtpAVlMZ?=
 =?us-ascii?Q?+hZx9myrh8mBJjbmTCWLndYdevL8CkTGg+cKW4IcI7n7kK0TFuOfZv6REkK7?=
 =?us-ascii?Q?OvQ1ZTys6hyjLoF4gBZycP8tHcvuAFCbZjI4LSi6Q4IbC49pL/Eb+RYk1RjR?=
 =?us-ascii?Q?hUAGDGliL6ihgYkZIVyNaho2VOWlCOfwUMy5u3P2AybpNgSY8Z8BCNIN30Lj?=
 =?us-ascii?Q?nCsyATfPDoq2P7r9ozd96ONyiXK+pRNBov+EW3JvV43rtEJO5neUPhHFnnZq?=
 =?us-ascii?Q?V+4nvhe1CnGVFt3lFy5X9bvnxTNczvi1QbrdAf2YmVUB205/1QIya5Tu9G0f?=
 =?us-ascii?Q?sVoyJrjdZhfF0DjXvOcIUt0ARmW9I+BDLUKoBltYCq29PVY1NkX4CXS48jNk?=
 =?us-ascii?Q?zItVp72jv86TTTPHM+Ata2BZpl5XOmO2bBTP30iKuGRfgFspQsbmRl+unTj2?=
 =?us-ascii?Q?jnsM4WJeXjbSaTgmjadd1xj4D2QqWB3UyLa6jkQGzAH+QQV7WAx48+1EdPg1?=
 =?us-ascii?Q?yi+86Asa8tD+aVbVSZp8n1fbE1OIVKGqCS9yaTz8tkxuLrytx//2hKiv0Wd2?=
 =?us-ascii?Q?PKXRiiZMz2g0eavK2iIVh65TyoncdBnMTGygN9/nk8x+OkpaFNAtg+Xn8cH1?=
 =?us-ascii?Q?RrGEiW5RylB5FX830EEIVeNFGgXSPTBE/hMtwwJBEPNi5ki+6A7+oHK1tyDz?=
 =?us-ascii?Q?ouaSgvb5yc7c4pUdW53MY7BMUmgkkzaYW9EIVjmpN27Ehcu3NxuSYfTIq59E?=
 =?us-ascii?Q?Szb7C05EoeLTZG+P9qkt7s1FuH8PqdmHsKIl2VEKxyH+GGTxvLahG7EBYQGf?=
 =?us-ascii?Q?eAf/Drf5ZxB8wXbUKX5FB2KVaYmH2BEEH94y5141MjXbHlqNuFYsTpS/74Pt?=
 =?us-ascii?Q?cbTJFJmeqBttZXM8LByCoApTXRn7XjvnTOWefFC2IFgxW6yGEhPyLZbMAKDx?=
 =?us-ascii?Q?pMQURmFjOSw1dyz2z4w+igfEH1jT4PCc0Zp3eULe9xH3zy7N11dAuxe2RBUE?=
 =?us-ascii?Q?bXEVtIsONKz4u9t0HHyWaXgqN8Nlx3W8Cow6WAnRQ3ZF33Zik3Cl1sOVCnwK?=
 =?us-ascii?Q?BTu99RX9xCyLVl9V02ELviihkmVNd02H1JkebUWKV8cZ1ZRnsJL4+zRWNoK4?=
 =?us-ascii?Q?6kge5qsMGYxEJIVE+uVvKYB2EhiNoBkyxWSdrKQO96ed1R4WILzboHYoKPwh?=
 =?us-ascii?Q?GwsRPxDe+FQBwwvkRMwjAiLNi4G8gMVkw6b92F/HJ95GvfwNkJJRnU/SOM8k?=
 =?us-ascii?Q?bqKTcW0lWSPUAMHVcBUnGoTCivmZMukoiIqXmK76EIq0AUwGg15rC9IUSWI+?=
 =?us-ascii?Q?TXM43fgng93ZjqwcBc547enAdhHRF0jw5sBcHrXS1EjAa3NQgMSI5CUwE4vc?=
 =?us-ascii?Q?EzZoxM4eS5jHiSTsItw5ejhJzB446fuUNAbgTupZoJE1DR6YUCwQGzgPO2Nr?=
 =?us-ascii?Q?peu48dBI3T6fopAXuXzriYV/VS12gDcI6QDYdYsTsKWclot42n01QzSSj0to?=
 =?us-ascii?Q?ktUT364Wkx50of4GM5W+htyftPyxAso/9aVPRdCf?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8VTjGDIWIXK/Olqhsj/DaP5kUiYqR86Uv52Cd4C3phtc3RnaDvXwmH6dA+sNFKaAvChWOvwEre/qczTd/1FUEtpg28z6dix8qdIf9iZCIWfGF++OJL/h2y7rHMorikpCpf5kBVyLejptgvRb3LmNP9eNR2qev/RiA8xhwP3RDhr2+rNfGP+YuGo0CYicq3VL/K7TXI7SyDqIYoA7FyX85bQ142F9jYSq4t3d8rrd++8A9oE0OpaMezBeH5stWY1bZupt2prWbWo3xbp1J8rQHImp/J7ein6kR2Rw/iYNvdeU3YizoTDeueNWB0/AKTvA1E792bzq332VxNBDiDAsNG4ZLfKpPHevzDi4ZWg/Qy1Mfoq0Rdj6FPsN4Mk9fdA/E1UDV4kqUndnjAfrxkIk2gEcxAYRCa8YgIWH/aYtdyTuHvbuEed0CiCIFDNFEd0NygI53gw2aXWmpU/TYLFXOUkL9ai8/GSPvXjvDaL1O2mkgXa03q333N5yL6pGttYZgkL1X3qDXD2+0eNWL1HsQzawxJX0NXAGWbUnF045w0jmHQs+KQaaK3ozkJpHu7ABK3G9pczRrbJ191qJxnyed2NNV9BvghnRPpktI+S/xMg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6daf218d-05c4-4066-4103-08de1d4fd518
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 16:16:24.9850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JX6qWYAkVjh+vLIpztlLYRDZn2Dqc2xkQMfXIpO3kSfy2QkSkYjOPPjR5rJqJNXvClKxE78d5nMmWmrTtc2Y9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5954
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060129
X-Authority-Analysis: v=2.4 cv=HPPO14tv c=1 sm=1 tr=0 ts=690cc9de cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=xh0YoP2GHujog8nS8dUA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: EtzI8R6LhN6HyX65QdWHov-m1Yy6TrsQ
X-Proofpoint-ORIG-GUID: EtzI8R6LhN6HyX65QdWHov-m1Yy6TrsQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzNCBTYWx0ZWRfX1xvR62KTV1Ju
 cL5MUSCxo053dbXsXR914wG7aIjyCpQN4fhsCOzng67FrBkb0WGk7skMuhPKfy6qGNVo79bO56N
 pUGrWXngIi5GKerNvg663KJ6EE4qArA2Z1yjvge9XaRCUJxhP0SOp+GPSbv8iRaeu14CP0y5S1G
 p9GTy+e2HCTymeSzY7TzWGZlmbK7xnCzAkyIEUVq2pkPwxGClasgmF0IgMNgPRrIX9rrlB6YAQq
 DfnexsCqfcnNkpcjSxd7Hb3P6Nu78iAaaOLeEGST3+TWQZdFovIFVG43YUcJDWracm3CRQa/9pz
 Nk6pT42GetxbQf95Rjk+EZFwbi/CdU5OoD01+avPCN5eCESErctI+013AN3cHW/Sm7I/BtuRTjW
 dLguSlEt7SJ11VTj2P5MUeSCofOdRg==
X-Rspamd-Queue-Id: 57267A0019
X-Stat-Signature: 87m9irj1miztasewz18bn81aysj5g43a
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762445797-913700
X-HE-Meta: U2FsdGVkX1+z5vDNg+SNeQ9iKFH05AQ+jh8+VWC6KMgtjXgrQxQb9EjzfS2eml6DdVVIWWymPvmcjBmayIGUjz0Rk+ptlPMT7YWSTSqZCCt9Zd4a3bAU/3VN3MZw4dYgpC0DgA25F3Nfo0Erkg6+bnSOsKQZzeuGZCrdVxqXBuWQA6+/43dMDBrhD6TYT0o3Gvmec5gR0NH9jhmYFZHvoBPk/hmuwBIItsgULa5+wbU2/eulPVIh0Bojg5xFxEQhD+j0wBBexuxuBPKgYk5Qe7+yvc4OSTL/V6xDSVrmBTyGFrPGYAjklun8a9BajIXSLxZeSNyUUWNedL+xbjbe3Wi6XnA/GcDKuaqaiwf85obUl9+m6pUZNzz4nTBT9hmLpt/VjtOcQJXN/rQBztGCUPHwMDNltI6dEoNiEnWQnpWUjscvqjXndOqot4IPd9qjaidRa3MIQYTQZkIq6PDHTZAdeX92mSzsUPm4IGKpi3B/Bhx2aYkPTxE7u+Mven1kjhDibvohc+j81sD4OPJZs5c+5Gjpr0MwOP4FsKAytUTmwi1+0aSraC1E5HuOhKZ4IotZiFRzkyYKwQWtg9KulcBBG0Cx/SZGF0cRLjFQkJUBPaXM+O43XmeiUbphqpFsxl/jvBjTXNkgeMWloTbL2FlGnu9lVWrVBpR42mkNECgmLY/WUeOEWeCsz5kQg1oeBfzu1lkQeQdUXMaBB63uHWtJHaTO9wZmTsVpR6FvvdUguybCyhQbwhpLobRn23M8KmrMc98H9rR10cQ0TslmUAF+scdq0Y9mnBolFNWQep5LUGn6zA+26sok3LxhdjozYtLF/8TByenI/d0bbHjGgoCIfJHLnn1QM3z9AP7oKnKMo0Gy8igSNsS6//UT4zgALuePd1KrAYvbSEM/NgYHZcCCwJvXavVhaew9ZIhBH7DkyaL+lsBFJukuvrlaYHXJwIAbEmWVc+nt/HWh+Nu
 ijhdmPI9
 VWuzORDoTohLGCUeo+wl0oGnNgjX7MZ1C8P1TL18AgXQR42zzkJ2FNBtabERb5iOyb7uPOEqJf/AQ7zDo8I7GXK91VpZHzZrlyJi+Aq51e+5jwiZ0JPAAmRbvKJrMvwHSdfHl9/e4vLYz1iwSepcVeyOBgqdyFAto/ka94X2TDT/v1uNxbdZf7d4P4tjoGn6fxjcEsf8Zopfe8IdjbGg+3LpKIv2sXFDVKmR1zB8TbLT0tPCUAcn6yEWDT0krBfkzWRVvBWEnLdnA2AeAlEIlTEAIFm7XnXoQFtAb5FWZKxtYMuP2eYbamKmTP+L2V49LUzUy1vAiUaSWukYnqO1RopYkKA/JAgPd7u6vDhtHa/xiaL8ycuBK9QFv8gEXvzvnDQBXYgvtsIVDtDv0I3dr8T2Vs6PAW7snbOX3Ob+TKr24iRWA5zC8Qqyx1i229fVP6X67xuycS+nuNmCRqN0ddlF+hckYnaCapjnyj3zG3G0VmhsrNcy92noYLFAoONeJFe8i7NN3yPdFWn3Mk+VR2ULXTaahMEQCmC8f1bASE9kH5jwXc/qagE9EeB9tC6/LeyrlzFKVj/Q6+EFB7P+Q7HHpn3Jp0JpHLMZ3sE2e3mqgtsAnf0fKHxcso0E0nWxWNqhc2vhQuJdGX4hx4mdK8Hsi02j41snG+O1iYOsKh+8jGGw9i/N1rsUJxta0wufosHv1oaSyTCL/+/tRENs7fJ+0c1shTCNfNE4A6nu6NIvzJ7w09mJVU1vc6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand <dhildenb@redhat.com> [251105 16:23]:
> On 30.10.25 18:13, Liam R. Howlett wrote:
> > * Peter Xu <peterx@redhat.com> [251021 12:28]:
> > 
> > ...
> > 
> > > Can you send some patches and show us the code, help everyone to support
> > > guest-memfd minor fault, please?
> > 
> > Patches are here:
> > 
> 
> Hi Liam,
> 
> thanks for showing us what userfaultfd could look like when refactored
> according to your idea. I think most of the userfaultfd core code is easier
> to get in your tree.
> 
> > https://git.infradead.org/?p=users/jedix/linux-maple.git;a=shortlog;h=refs/heads/modularized_mem
> > 
> > This is actually modularized memory types.  That means there is no
> > hugetlb.h or shmem.h included in mm/userfaultfd.c code.
> 
> Yeah, I think there is this confusion of "modulize memory types" and
> "support minor fault in guest_memfd".
> 
> So I see what you did here as trying to see how far we could go to remove
> any traces of shmem/hugetlb from userfaultd core.

Right, yes.  This is an example of what we can do to completely
modularize the memory types.  If this were the reality, it might be
possible to create a guest_memfd type that has the necessary changes and
only export what is required for the module to execute - that is, avoid
exporting memory functions and also avoid having the bulk of guest_memfd
remain where it is today.

> 
> So I'll comment based on that and rather see it as a bigger, more extreme
> rework.

Sounds good, I was hoping the patches could be a starting point for a
conversation.

> 
> > 
> > uffd_flag_t has been removed.  This was turning into a middleware and
> > it is not necessary.  Neither is supported_ioctls.
> 
> I assume you mean the entries that were proposed in Peters series, not
> something that is upstream.

No.  This is upstream today.  uffd_flags_t is used for two purposes
today: 1. deciding which operation to call and 2. pass through if the
request includes wp.  In fact, some of the callers just create and send
the flag only within the mm/userfaultfd.c code because wp doesn't make
sense.  Once dispatched to the operation code, the flag is only ever
used to check for wp.

If the code was structured to use the call path to know what underlying
operation, then the flag can be reduced to a boolean - which is what I
ended up doing.

> 
> > 
> > hugetlb now uses the same functions as every other memory type,
> > including anon memory.
> > 
> > Any memory type can change functionality without adding instructions or
> > flags or anything to some other code.
> > 
> > This code passes uffd-unit-test and uffd-wp-mremap (skipped the swap
> > tests).
> > 
> > guest-memfd can implement whatever it needs to (or use others
> > implementations), like shmem_uffd_ops here:
> 
> There is obviously some downside to be had with this approach (some of which
> Mike raised), regarding the interface to "memory types" implementing this,
> but I'll discuss that later.
> 
> > 
> > static const struct vm_uffd_ops shmem_uffd_ops = {
> >          .copy                   =       shmem_mfill_atomic_pte_copy,
> >          .zeropage               =       shmem_mfill_atomic_pte_zeropage,
> >          .cont                   =       shmem_mfill_atomic_pte_continue,
> >          .poison                 =       mfill_atomic_pte_poison,
> >          .writeprotect           =       uffd_writeprotect,
> >          .is_dst_valid           =       shmem_is_dst_valid,
> >          .increment              =       mfill_size,
> 
> See below, I wonder if that could be performed by the callbacks invoked as
> part of the prior calls to mfill_loop() etc.
> 
> >          .failed_do_unlock       =       uffd_failed_do_unlock,
> 
> That one is a bit unfortunate (read: ugly :) ).

Agreed.

> 
> failed_do_unlock() is only called from mfill_copy_loop(). Where we perform a
> prior info.uffd_ops->copy.
> 
> 
> After calling err = info->op(info);
> 
> Couldn't that callback just deal with the -ENOENT case?
> 
> So in case of increment/failed_do_unlock, maybe we could find a way to just
> let the ->copy etc communicate/perform that directly.

The failure case is only detected after getting a folio, but will need
to 'retry' (copy is the only one that does a retry).  Retry gets the
destination vma, where the vm_ops comes from.  This is why you need to
return to the loop.  So it's not that simple to moving it into the
function.

In upstream today, the return -ENOENT can only happen for copy (in fact
others mask it out..), but every operation checks for -ENOENT since they
are all using the same code block.

All of this code is more complicated because we have to find the vma
before we know what variation of the operation we need.  Annoyingly,
this is decided per-mfill_size even though the vma doesn't change,
currently in  mfill_atomic_pte().

I think we could find a way to do what you are suggesting, and I think
it's easier and less risky if the logical operations are not being
dispatched based on uffd_flag_t.

> 
> >          .page_shift             =       uffd_page_shift,
> 
> Fortunately, this is not required. The only user in move_present_ptes()
> moves *real* PTEs, and nothing else (no hugetlb PTEs that are PMDs etc. in
> disguise).

The hugetlb code had a different value, so I did extract it when I
Iunited mfill_atomic() and mfill_atomic_hugetlb().  I am sure there are
other changes that could be removed as well, but to logically follow the
changes through each step it seemed easier to extract everything that
was different into its own function pointer.

> 
> >          .complete_register      =       uffd_complete_register,
> > };
> > 
> 
> So, the design is to callback into the memory-type handler, which will then
> use exported uffd functionality to get the job done.
> 
> This nicely abstracts hugetlb handling, but could mean that any code
> implementing this interface has to built up on exported uffd functionality
> (not judging, just saying).
> 
> As we're using the callbacks as an indication whether features are
> supported, we cannot easily leave them unset to fallback to the default
> handling.
> 
> Of course, we could use some placeholder, magic UFFD_DEFAULT_HANDLER keyword
> to just use the uffd_* stuff without exporting them.
> 
> So NULL would mean "not supported" and "UFFD_DEFAULT_HANDLER" would mean "no
> special handling needed".
> 
> Not sure how often that would be the case, though. For shmem it would
> probably only be the poison callback, for others, I am not sure.

There are certainly a lot of this we would not want to export.  My
initial thought was to create two function pointers: one for operations
that can be replaced, and one for basic functions that always have a
default.  We could do this with two function pointers, either tiered or
at the same level.

Most of this is to do with hugetlb having its own code branch into its
own loop.  We could even create an op that is returned that only lives
in mm/userfaultfd.c and has two variants: hugetlb and not_hugetlb.  This
would indeed need the hugetlb.h again, but I'm pretty sure that removing
the header is 'too big of a change' anyways.


> 
> > Where guest-memfd needs to write the one function:
> > guest_memfd_pte_continue(), from what I understand.
> 
> It would be interesting to see how that one would look like.
> 
> I'd assume fairly similar to shmem_mfill_atomic_pte_continue()?
> 
> Interesting question would be, how to avoid the code duplication there.

Yes, this is where I was going here.  I was going to try and finish this
off by creating that one function.  That, and reducing the vm_ops to a
more sensible size (as mentioned above).

shmem_mfill_atomic_pte_continue() could be cut up into function segments
to avoid the duplication.  Or we could make a wrapper that accepts a
function pointer.. there are certainly ways we can mitigate duplication.

Really, what is happening here is that the code was written to try and
use common code.  Then hugetlb came in and duplicated everything
anyways, so we lost what we were gaining by creating a
dispatcher/middleware in the end.  Then handling errors complicated it
further.

The code has also bee __alway_inline'ed, so the assembly duplicates the
code anyways.  It's really an attempt to avoid updating multiple
functions when issues arise.  But now we have error checks that don't
need to happen and they are running in a loop... also hugetlb has its
own loop.  And returning -ENOENT has a special meaning so we have to be
careful of that too.

I don't think the compliers are smart enough to know that the retry
loop can be removed for 3/4 cases, so the assembly is probably
sub-optimal.

> 
> (as a side note, I wonder if we would want to call most of these uffd helper
> uffd_*)

Yeah, sure.  Does it matter for static inlines?  Naming is hard and I
think shmem_mfill_atomic_pte_continue() is a dumb name as well.. it's
too short really :)

> 
> 
> I'll have to think about some of this some more. In particular, alternatives
> to at least get all the shmem logic cleanly out of there and maybe only have
> a handful callback into hugetlb.
> 
> IOW, not completely make everything fit the "odd case" and rather focus on
> the "normal cases" when designing this vm_ops interface here.
> 
> Not sure if that makes sense, just wanted to raise it.

Thanks for looking.  I think there is some use to having this example
and that's why I was asking what it might look like.  I certainly went
overboard in the last few commits to remove hugetlb all together, but at
that point it was so close..

I think there might be value uniting both hugetlb and the normal code
path, even if the operations call signatures are aligned and we just use
a pointer to a struct within the "while (src_addr < src_start + len)"
loop that exists today.

The removal of the uffd_flags_t is also something that might be worth
exploring.

Cheers,
Liam


