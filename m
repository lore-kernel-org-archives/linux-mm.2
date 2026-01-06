Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17710C47BF4
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760746B0005; Tue,  6 Jan 2026 08:58:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B656B008A; Tue,  6 Jan 2026 08:58:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9FB6B0098; Tue,  6 Jan 2026 08:58:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C89B6B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:58:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA7F8140144
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:58:34 +0000 (UTC)
X-FDA: 84301694148.25.45B7A6B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8D77C1C0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:58:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="na/HA0qV";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cTdWyTIV;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767707911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcTlK2lyUKlPgjFviBoePTa4SJbkffbigvPUI9qe6NY=;
	b=LZ1zq+mcKXh/WJhKX3JY7O+gwIvO+Pu74qBxR4e+EEGSm7EPMD+wkJ6OmQy5Xbn01X+MZX
	IO6s3lRq1HS0i+8b6BWrrKbybRRmelyuWV6gAt2j1mWJJYlDG0693GxPHBJpfCn+Q/OeBO
	1dEwClcxLqjy9pAnWfKJLPrOzKgCiZY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767707911; a=rsa-sha256;
	cv=pass;
	b=sUJnBZPz06E0/Fw4bUs3kY2dLdFcWb31h568nkCGbnSDKjxYv5CEFzxUj2n2hPlLg1RGY9
	zQNkSFHIt1R/+D0eVJ1DwJhb/Y0PacGUrsNyb+DaVh6CE2JVVqzeZgoptIiomI9kmn3Dja
	c3UxKe1dHTqNXQXTHxShQ5pjK8GgwEw=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="na/HA0qV";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cTdWyTIV;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606BtZus3785447;
	Tue, 6 Jan 2026 13:58:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dcTlK2lyUKlPgjFviBoePTa4SJbkffbigvPUI9qe6NY=; b=
	na/HA0qVOZq1XRNhbEMI5/romjQhMPTFS1ey/FXMCVOg4ZHOrZzY0pOM/Wigti+8
	C5O/ZpyKTHf0ENkpCC3KY3le5RrZAkJWgjr8TMeU4goBgb3XXvO2y5jmoX6Xe75b
	eptjrD3jfqQYCd/SWz6ovJbp/HrC1n7Q2tSEWNDtdT9Vivyn/Xz0hrAgqLQwIpVK
	bliI8jGaCqxP2npWcb6v3pivc/lAA8i5lV3SobXvTrOcQC+0IEhAcbDWbOmt/0bK
	Jj2oc8LZ1tWMbx3PVdIgEsahicg1nIhsRngMbDvXIsvA5UGKnYU3X+Alc99r/X8N
	k4/WtsNXDBME72YjptZlfQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh1xrr48e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:58:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606DPPw6015607;
	Tue, 6 Jan 2026 13:58:24 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010030.outbound.protection.outlook.com [52.101.201.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8c8gp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:58:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ig11cGsf6X/hQsuKqBZt8XEXKgclSImRTziOSuVLejfRo3Mxo0hn7z9Pn480ieFa0JOJmN75f2urXkSxPcjuoenqXQT1ewyP2xvhK+jnCJU2zU3WEID7Bvnuh+sDaoKdVrqKKGwVe0IiIXcwWff+d6ecURENfaD9jC9nl9ZruOs28hDRfp6hoZtIFdn3W+WSzgsLTxQs4SCOfmZM7IMCzNu2VjQRXAENLAOUADEAgkrxIMgGljWBnlcJLvMuZTyYg42NHHC2NrUuEC+JuvEQf49weHqcf9M6TWYn4Ohga6o3ruYk2T07udmqg9zmunlQsLVAiMjbKbvOQwzyB15sBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcTlK2lyUKlPgjFviBoePTa4SJbkffbigvPUI9qe6NY=;
 b=w14qn90g0El6DgdvKXdFizdnDvs3wvNxHghLiyF32GytM4Jkch4LT+lUXbv0rrUL9OGLz4fhx2O1N13JVc5LA2RrYxr/XGiNBzOVHEgvqFcm8CfCn3WEXYQf/ndRgTSJpqVD0zlhxx2Va2nkKnQ8WRp8EyoQ102T/tl8A27ydklv2d2F1jwRh2k+sIxotXc82qHy+mSZwR0nWgFV6WLMXXVcR58oWiOD7o1ToRmfnXiYYWUSjl0FRJJ7yjaWzJyhwcY7pRl9FdG3IFaRs+QUG/tA68tkfuowYfafla85zl566t7pOH4FPCFZ4vFB5vqw5BkzZ/Af87enqdsTZfOQBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcTlK2lyUKlPgjFviBoePTa4SJbkffbigvPUI9qe6NY=;
 b=cTdWyTIV/ZKBm39dAiSOAV8iYxPvPtOWVhi+6ACktSeJ1t/DOxtqCO1GV+lEi1ozXVSHTurL0eIpc/9oNlVkF3+nIDejKsmpRn46VhGHtVuzyrXaa9jpoprp1gRX3NiHzf2hX1CMH5UAno1jCdE3JhKICGxDtmlNZ/ejWX/S3nE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BY5PR10MB4257.namprd10.prod.outlook.com (2603:10b6:a03:211::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 13:58:21 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 13:58:21 +0000
Date: Tue, 6 Jan 2026 13:58:23 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] mm/rmap: remove unnecessary root lock dance in
 anon_vma clone, unmap
Message-ID: <2ec5bf63-139e-4e8b-85e2-efb48adc93fb@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <454c0680d4fdd5504b1e90b2fdaa098bd70d4d2d.1765970117.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpEWwdnNs458wSb__C0eHSEvbvJ9nK3ryQWLTjA3+b3BmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEWwdnNs458wSb__C0eHSEvbvJ9nK3ryQWLTjA3+b3BmQ@mail.gmail.com>
X-ClientProxiedBy: LO6P123CA0011.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BY5PR10MB4257:EE_
X-MS-Office365-Filtering-Correlation-Id: f12e17e9-270e-420c-ac01-08de4d2ba6b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXRsTXhvSVNVVVQ5Q3JhdzdyOG5DY1g2NlJLOEhBMnF0ZzFvQnRhb0pyNVd5?=
 =?utf-8?B?OHBxcDZ2VytFRmVLYlRtdit2ZmhwWEszaExvWFVtMis3MDR5WmoybHg2U2RO?=
 =?utf-8?B?QzhCNGVIQTlXbmx6d0t0WjhOTUlyaktWOTZhQjlXZzdtdE55RzBkRC9EbnFO?=
 =?utf-8?B?WVE3Nk84bzU3aHhqY2F5ZE1lcmRLQmp4MkFudnZ6eUZUNTZRNFo1WFBnQ01p?=
 =?utf-8?B?MDRITXN0SmgrRGpQdG9kZE9zOUpIRDVyS0ZxNE8xQ3lJdWFpVlR0TGhDRkNY?=
 =?utf-8?B?NXdwTFpSNSsvVVo5Q0ZoenVOZVlkTzlyN25jUWoyeVpmKzg4cm83SDdBTHI5?=
 =?utf-8?B?ei82VENIamMxcEpzY2x5dEQ0eXcyMngwb1ZYRHZMeDhwV2pmVzI0cjRtRnNI?=
 =?utf-8?B?dWxtNitQMzZqZGFmZ3hURTloRFdBUWplNFdmckdDQVRTa3pXNUw2cUh1QmtM?=
 =?utf-8?B?bHR1QVhpWW5CWXZCdUJ0TEZnOVB5UlRnZmh6NG12amdwREFCQlBjOWplU0J5?=
 =?utf-8?B?VStvVTg3M3IyUEJheDNPcU5Nc09ySnlEZmxFQUs1NHdYa0ppcWVJanVkRHd6?=
 =?utf-8?B?QlNIN25HakNNckpSeXM0WjN2TlNEQUhxdjk0STdOVGJuRVoyRlBGdytDLzlx?=
 =?utf-8?B?b3dScEI3VjNNaDhPTFJnUC9UUWt5RnBNeERiV0ZlVzFoZitMYkI5RHg0VlhK?=
 =?utf-8?B?NmVSVzNuWEVEZ2pNckI4aS83bFJ6b0UwNFVPaFNBcGlabEZ6TGl5L3ZwZEJT?=
 =?utf-8?B?OXlpSklmQ2F1bHNVbHNWamZHUGRGdVo4U0dhWENlK1JiVmRvOXNHMFJuanIv?=
 =?utf-8?B?aGtxcW5yb05zOTFlR0plWUpxLzlNL0RNQmt6ODZxWStGQVpXRCtCODN4WE4z?=
 =?utf-8?B?YU4wWWFCbkpYSW1ZWTh4T09FQU9vcDE1cW1TNG1YeEhVNmRZcDdsZmdEZVZ0?=
 =?utf-8?B?WDNkTVZUSTkvVzl0N1FLQ3hQL1NwNEtjV0YrNTc0c1BhY3Jka0ZkYUxQOUYr?=
 =?utf-8?B?SXRpMmRlOWJ4RXlWb0FZU3htNEg4cFdER3cvQXQyNDBTTVY0YUJRNFJaNkYy?=
 =?utf-8?B?UWZBRDA0cnh5SXVXWk4xVDRhZjFOUEd2NVJmaE81S2dSM29KTnAxZUF0cnlM?=
 =?utf-8?B?TFg2UXFsWS9SVVNuNjBSNFZTb29lL2JjTFFySDhzaWpNRHRrVjlXKzFzZzNK?=
 =?utf-8?B?WmpVd3VRVkg3OGg1ZkRBcDk4T3pJYVVraE9wSS9EVXR0QWV6QjdRVVNHQzdy?=
 =?utf-8?B?b0pIMjNzcnpJcjRWWlE0VFRQOFV5RFNOWDJKZHpxNGxkNFRvV3FSQlFpTDdn?=
 =?utf-8?B?R3BtTVY3V2NiMk1xc0NjUGUyODlQQTVkWkRjQ3dUb21lN0JOY09zOEtOckJE?=
 =?utf-8?B?dkNKWmVhNXdDVkYrT2NoZUw1c1Rqb1JlVkxsdlJnRG5yNDMrNzlXWVRrVnRi?=
 =?utf-8?B?ZHNoeU1ZdEUySE1LK2dzc2VQa2pIT0paRTBxb3NJb2RMTWtQVHZWSXFTcmdU?=
 =?utf-8?B?akNNWlRxWk11dGhQNUl1MlNNUWwwdUVLWlVlTmlQdEt6NGUyU0pMT3R6Tkt6?=
 =?utf-8?B?VkNYZkNQUTAwSkd4WUtOdnk4L0lETFl0RjEwRk4ybC9uZ0l3L3pLRFFCSFVH?=
 =?utf-8?B?SFJPM1V3NVB6ZUFXTVdBcmZNSWR1bm5VZG1mNUoyWkVkeU1vTUdWdUNHZWVX?=
 =?utf-8?B?RkNTVzlNUGtOOVQ5SXl5OUtWb216N3RmRkFWTE9JS3pzV3p0dkFEWG92VXkx?=
 =?utf-8?B?YjRtRWFUM2xGRG5ZRHZiYmRRRWJzcGpwV3cxMHczeFF6MVVqUUxtRFB1NEMr?=
 =?utf-8?B?VXNHUlloUXQ3akhmN2t1emQreHczV2RiSEZqSkJ2anA2UjBPdEtuNXlnNDZw?=
 =?utf-8?B?NG91akpJT1VFSWlreHlDcWxvcnpmSXVFc21ZVUU5NEYwTUVLNmNkZjRsNVla?=
 =?utf-8?Q?l47tLdAqh8VMqkSDQ+48x8i2Lh0doeaj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RzBLUEdTdmx2ODVGS3lCeDV0LzRPdlRZTG9WbDhZeUVia3FQNmRMbUppSi9W?=
 =?utf-8?B?WWhhSFVGcVZnN3BYNVk1NW5jQU56Z1F4WjNuNkNiaWJWOEhJbTJQVUNlbVdH?=
 =?utf-8?B?QnY3OUVDYmFUYjJNMi9oQWtZRjk5VTBha1F1OXJqalRBWmdkNEpKMHN6dXI4?=
 =?utf-8?B?VGk0ZGZEN2hEV3owcmt5bUJjSUZJWWpyRmpCMU9sUU9ETFVydHBVWG4vcTRQ?=
 =?utf-8?B?ekhXbllyZlRjVHIvcGdSRFNSVnd3bGdjaEFLdXRtWlQ4YmlIQjdDb251OVk1?=
 =?utf-8?B?bCtlbHZXM1BQK2pzZWpQdlJYYWVDZ01UTnYvR1k5MTRiNVR0NnBsNERaRmhu?=
 =?utf-8?B?UDBwWFRpQ3BpQUdxaXJyL3FFRGtpdUF2aTZwOFNZQmtjYVNyNlBPcld5M0dJ?=
 =?utf-8?B?NkRDenJubU1LdWFhRG8wU3Baa0NvcVNRcFdmaWJodWpNTU5GaVgySEllYkRL?=
 =?utf-8?B?VHZ5T2ViRmg5ZWMvUGVwSHk4VFpPS3E1QmVVNU55WkgzdWdwY3NuQmxmNG53?=
 =?utf-8?B?YWVlbXVzbmpWOWVLNmsyVkJScjVrdHN2UGM5NmEyMEt3T04wZlNCckk2V2Vt?=
 =?utf-8?B?V2dZai9sSWVzM21yaFJ3U2NvYXFLT3VFYmMvdUV3aVZHSEhzWDMrQm9oS3Jt?=
 =?utf-8?B?ckNDTjE1aFhvL3h4bzdKNnZWUjVpUmRGMnJveDNIWFVvbkZ3ZzlzRGdzNmpx?=
 =?utf-8?B?TEpYd2RONnIyMGgxdnU3TkRScUdsVVAxeFRwQXl6WW5wOGxDUWJxekZzSEp6?=
 =?utf-8?B?RkNFMFJIVGJNSVZjUDkvcmRoUE5TdHZIOTMwYitwUkh1T3Y1ZVVwOGNQamUv?=
 =?utf-8?B?ME9ob2VkUnpIWStINW4vTy85bHhoNEJOMGxER2JFVDdBVXc5QTIwQ3pnc0ZN?=
 =?utf-8?B?cURhM0tVZWl3RTUvWWFMQVVTeUtWU3hmTzVkRGg4eWhoejhPNmVNc2p3M25n?=
 =?utf-8?B?eUZEZzhSb1JWSnMvbm5tVVpxMTdCUUZhQkVMQ1pndWgrRDlUdEluRXNEOXpk?=
 =?utf-8?B?QzRRa1RybTF5Z0xLK3oyRW1uR2h3VVgwVEZVZkZVakJhVDU2eUtsa0s1UlZ1?=
 =?utf-8?B?Zmpjano0M05MMy9kaStVOXFJVm1YZ3YrSnFSUmNsaTk0YXlpU0hpZFdrbWph?=
 =?utf-8?B?T0FodXRwVlpHdnREdWdIc1pWWHpRRTZUSzF3anAyNTQ3UGFWSE5mUW56REpT?=
 =?utf-8?B?VHFtUkJyQ3BseDdRSEV4Qk5FTkp3bXlZOHpqaFhKay9SYW5XRHFseWI5Z1RS?=
 =?utf-8?B?WVJ2N3R2QzBlK0dHdEFHdk85aVdCNXQxSUM3cnhMaE5Ia0p3L3hMTHhqc1NO?=
 =?utf-8?B?Q1drQnpTMFIzdUc1NFV0RlFUdC9ZZC9udFVLRVBGTHdubFhEYk1RTFpWdkkr?=
 =?utf-8?B?TkJ2c3BLLzlGOGo3M2FZYjBGZmZqZ1IrblNZMVhMMlFlWlZtcG9HTmhEam43?=
 =?utf-8?B?UzUxMDM1dWhldHl2T0o5UFovWGYzVFZRZGxXMXRWNndRZ1BBMCtReGNKaFhY?=
 =?utf-8?B?YUN2MTFmV0pZS1BHQlp4VUdEZGphckYraHlWMjJaSkV2NnliNWdIcmhtSTdu?=
 =?utf-8?B?L1RjeENWMmlGTWQvSVpGVjVJaW96SWlDVURBRnY0QUpLb0ZpY016Z08walI5?=
 =?utf-8?B?YkRNUTJRbWI5eURJQW5EbTlTQi9QZnU2WHd2TTRtaEhPYTlEb2xVd2V3RXdk?=
 =?utf-8?B?NDdSaTMxSmZuRm5kUTdJK21OVHFPNzNnQndxcXdvaDY5L3JEQU1wQml2Q3dU?=
 =?utf-8?B?UE54azNrWTd3RjdySXNPbTk1bS9ZRUgvN002NndNbURUNGlrQ0Y1MVVRbVZ5?=
 =?utf-8?B?VWF4V25qakhOZllnSStOZTZpOHplMlhqeVY5NG9tMkZhZjNjRXFRWE9mV3cx?=
 =?utf-8?B?K3F0bnRNeGJIK2NxRFpYTFAwT2FCUzM4eGxCck9uWEFiT01md1A0TEtnbW5z?=
 =?utf-8?B?a1EydmxTN3dmMlhlZUVqenF1T1UraFZJMldlOENnQUx5MDdqbnI1OHhrWHJI?=
 =?utf-8?B?TUVidTFVaUNvcWw2WkdZM0tmS3NDK1FWb2lrelpsdS84VmdFYUdKQkh2Snc1?=
 =?utf-8?B?d0k4cVQwMG9ZbCs0VzFBOEJ1MjhJSWx2ZnlTckk3eHdxSE5EWUNnN2FRNEdV?=
 =?utf-8?B?MXVDOFdjTmx1RlRHYkpSTzRYOHc2YjJJSEp5akwvS0tBVnZ5TStrVjhIbGo0?=
 =?utf-8?B?WXg1djZRM1VzUVdOK3RtcXg5bmpQMW1nNnlMMVcxNjFOVG44NjJtNncvaFlj?=
 =?utf-8?B?RE82QzlUcG9sd2ZabHcxbXhPaWZhb2V6R0FmN1A5U3B6elFqUmpQb2NqUDZW?=
 =?utf-8?B?R0g2ZXNvWFZJUjNEQktpMWNiZ0t6SEFudldLdmJhUU5ucFhjRHFhWnhUUEJu?=
 =?utf-8?Q?LJO61IBqogXjdJ7o=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9nREMtO/JRQSH4aR20WPl3rVwbqxZJcLhI3Psb0uo3zX27XR9NfX7IV8wMFpEsPjJhWlmXq13sdRHulYQ54KgowJWjt4RTUghEjwqH1LWB320J7XmuHunMIRrSXGSX32FFld2qZ8fsHQGxln18YlMNlmFcV/ByKAwU7G2qA8E6ZVHBfLaJuDfKJvTYh1dbFCD2JKZG5WETOkX35PfgkXDZHirxcJysb38Dgt01tM8GGXeXqDW7qrgAMPKxRjqUFG065NBgJ0exvs4tYfrV6OucV9Xlq7hRsCgS9EYDxgXqRpqraSNNH8dhP0mE6rlqt5XwGmVBQRNTjGWJeafxJw1GCo5l1h/qlrMMHKfAirtR8roFpHsE0yxZntOefnuuEKapGGmRSSc/sT8csiAi/kIUvfhTlhAmmACfext75QOWbcK54VH3RgTwYXJdd1fJaEbNa+bBoQbcY9g0mMaBsAlCQbqnbwCgPns3ZMER3f/5Em59Hebi8q+/bp1sciSn9ExSe36HsAJdPuytAvwBWPz3MnRljbrhuZIXSOHmI9+3Quz8Utzlpv7/cYO9yY/+t16MiPpDjh6V2ebvvOx14jTb212kCwEBkQYTG7DkPHUis=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f12e17e9-270e-420c-ac01-08de4d2ba6b8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 13:58:21.1823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zkVRTIRiNDyRWzVghG/jBbQLQ83ouWhW900k7mOGt+xopKNHSfvutefpONWov+IGo01yH6RU6r0v7eYB928DBrxjOjG0QYt0bolPz5BpiGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4257
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060122
X-Proofpoint-GUID: k5WlANJsSYcUAWTTkQKlOIuBLwM7YAA-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEyMSBTYWx0ZWRfX1XsrL08Q27nN
 jS7n93DtFzvI9pI2hroDG+Z3sIvERbGUZWA+3oSHZagvbgs9WR47Ysy7BuZYm+Zz3mt+tXZViPa
 PxQ+xB8mn3I3msTfQcf5tO/uS+NIaOIkwQ050VgK2v6V6sx03PTb+iYan297bytIYcbkbn4D57G
 81V/ORJxaUUQqN0DvXKyawvcWGpdL+0zefgTVtvXjjbwgX6YMY4xXZ/UgTe9uDEpcEOKEV56gpM
 haEzzEKl/C8vrdqK2w/DXtiYgO8zhB8oK8RBXEF0oPLvjhHNIlErbfg5Vfq9GbZgPn1wuz+din3
 tAKS45XdxYrPrY6k2vbvxncyY/uojb/clgIplo1qPq4O4d2V+QU7DBf2C3t33E5Hz1DuESrd4WS
 6mGbawwYpv1QZQNMaP2BepKAWk4r/s4ineMDhxWNCsCzAn+0VbEQedOoAMoR5sAgd37dns0Ft2Y
 mYFtiTRa6wYN8bDiYaA==
X-Authority-Analysis: v=2.4 cv=J8unLQnS c=1 sm=1 tr=0 ts=695d1501 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Lpb4Jv3iZZkEZ0-9uVgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: k5WlANJsSYcUAWTTkQKlOIuBLwM7YAA-
X-Stat-Signature: ptzezmsh667uxkiznenqxr51cpousxpy
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D77C1C0005
X-Rspam-User: 
X-HE-Tag: 1767707911-720543
X-HE-Meta: U2FsdGVkX19Ph8XmHjn8PSYWSFdM7Aw4So+71hmFZN33WLCFFeG8QG4Iw+C2lA431Zp8kQ8RhCdDQxX5pdryuRQ+T+nesDX/1pHWMOmieaeKjW35Ntzh5vLWaah/l69Gj7f8KUZk+s4wLnNybYWmlZZJnceeEcwKQVnHw5cs++VFuvjyQHvPsmxdj7zrs/qmXpu9HGnzFe8++VMvWxDpyh/HdXYYxlIFFHmB1ePj0YwMIZcTZ3q7p7aZnawA4txv33Th+3ln7S+roIiGbfcCSGvKDB2IjS3WSpSlVVXrdQgF6+zN7vNvGhBVPgVQ7Y9sERnoe/b0NpIlBOzx7sGkcBNMyoOLNqGLi2W2vtEBq17lz29PxKLt0Mp81Dq5nyxaX16QQjsp4eCL0nq/3IROyvFIcnERjReBaa1donMdK3Ft8VOZzgxKva9j+2emqlvCWflHCcaJhaxf9fKGnnmEa/Xd2rIYzpR54eMnp1e2kc8wh2E22ea+eP0EBNDgdgIt6KJ03j0XpzQWgJYrbJmqnSowejj3ABFhKO1fXarmpw8pECNYCsm/p6E9ztsAqg6NIwdSbHoVVXBKHIydv9SxmYfXTFZGHCBeNOwPgwcZMgGq9M6Bzc4WGNixF7o3CeWXnv3ZGDd7hsjrRljKwuc3ZlKWih1Emdbh8NZR7tA+hyECW7qUoUPlVCjR/ltVhhqjn4Zj2c/kF8snm+tuuqS2inW7P5ZKcBxeKVcIfSpi+o0imBuG4BLpU5ZMTprRTrblVZaDrvv07O2o9+rWQbxKgABOnpxgxZuuaINo4FLaYLXcD4p6CKu3z6Cr5z30kr9of8iRTIgSxAXBzXA59eSCAS5tlNJ4dxsnTEvM43XshgGL4r5wjcV5QInlc6bGntYCTWVf0cd6XiHKTM5vIeSKnz9xclgD9O1FTxxhPuEccxhSUBoa6WXKfMufHeAZI1AT/L1omBRfeDFDYjRJeKw
 zx4RHdHX
 ADYwT5ybqFtCTbgudZU468Rr0+5RlxiiSX+C2zRoM0LIEbXm5Q2+JM10SNn0GfU7rdv9dzdaAvhiCqh27eSQlI1ZuzIWkhHQfvHyQOIbyt5W1C8ONnG4QuQQkaNMm/juhVa+YIcPBNH3FH02YiB+SYrmeCvl4pK+0kfwAozRAN6N8TRTdnJXTCiyk55Cugk0Hw67ae1/9vyxAxx5U/iiOinAu5eLwjpM+Y4/Mf+YnV3rXNVUOE6cCScxwYl6ZdwM92wmvuONOt37Jyw7wX4QnH/W53cj2jrcC50P/Ml/rGn7P+gBWhO9YWqz8Qw4vVlAHJqCbEuBOVIFYe4Z+LT9J+7a8Lbm+UEYzPR9JCyfdmKmaJ2i+6Xp8nFsDoEWsSjjnlSMm2besJcixWejY7AVVePN52zWGYog2xPDBwGlIrL8X6/Jwfm8em2i6slJW1zY1Ac3nZw5zmFDooh4D2Q6GTpUAWrIB3/tQX6x4HPEHJKMbnq+5lHsJgNxm7uwaqbnG94DzYCJvhRfL19qnUo/9LqZNrEI3sp/P8lhwbfAgsF2qdOAQg79Mbst+cG69dGWTCUE+IQMoSHDz9RVxbAyENinfXbLGLjYkQ73IP5rCyhRyXpd0Vb2ksalY82yChmSpKM7q5g8RJoVh3Bn/7W/bZt2f9k6xY14vaRuq8eW2FwTfz2GG13LULTxy7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 02:17:53PM -0800, Suren Baghdasaryan wrote:
> On Wed, Dec 17, 2025 at 4:27 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > The root anon_vma of all anon_vma's linked to a VMA must by definition be
> > the same - a VMA and all of its descendants/ancestors must exist in the
> > same CoW chain.
> >
> > Commit bb4aa39676f7 ("mm: avoid repeated anon_vma lock/unlock sequences in
> > anon_vma_clone()") introduced paranoid checking of the root anon_vma
> > remaining the same throughout all AVC's in 2011.
> >
> > I think 15 years later we can safely assume that this is always the case.
> >
> > Additionally, since unfaulted VMAs being cloned from or unlinked are
> > no-op's, we can simply lock the anon_vma's associated with this rather than
> > doing any specific dance around this.
> >
> > This removes unnecessary checks and makes it clear that the root anon_vma
> > is shared between all anon_vma's in a given VMA's anon_vma_chain.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  mm/rmap.c | 48 ++++++++++++------------------------------------
> >  1 file changed, 12 insertions(+), 36 deletions(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 9332d1cbc643..60134a566073 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -231,32 +231,6 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
> >         return -ENOMEM;
> >  }
> >
> > -/*
> > - * This is a useful helper function for locking the anon_vma root as
> > - * we traverse the vma->anon_vma_chain, looping over anon_vma's that
> > - * have the same vma.
> > - *
> > - * Such anon_vma's should have the same root, so you'd expect to see
> > - * just a single mutex_lock for the whole traversal.
> > - */
> > -static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root, struct anon_vma *anon_vma)
> > -{
> > -       struct anon_vma *new_root = anon_vma->root;
> > -       if (new_root != root) {
> > -               if (WARN_ON_ONCE(root))
> > -                       up_write(&root->rwsem);
> > -               root = new_root;
> > -               down_write(&root->rwsem);
> > -       }
> > -       return root;
> > -}
> > -
> > -static inline void unlock_anon_vma_root(struct anon_vma *root)
> > -{
> > -       if (root)
> > -               up_write(&root->rwsem);
> > -}
> > -
> >  static void check_anon_vma_clone(struct vm_area_struct *dst,
> >                                  struct vm_area_struct *src)
> >  {
> > @@ -307,26 +281,25 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
> >  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> >  {
> >         struct anon_vma_chain *avc, *pavc;
> > -       struct anon_vma *root = NULL;
> >
> >         if (!src->anon_vma)
> >                 return 0;
> >
> >         check_anon_vma_clone(dst, src);
> >
> > +       anon_vma_lock_write(src->anon_vma);
> >         list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> >                 struct anon_vma *anon_vma;
> >
> >                 avc = anon_vma_chain_alloc(GFP_NOWAIT);
> >                 if (unlikely(!avc)) {
> > -                       unlock_anon_vma_root(root);
> > -                       root = NULL;
> > +                       anon_vma_unlock_write(src->anon_vma);
> >                         avc = anon_vma_chain_alloc(GFP_KERNEL);
> >                         if (!avc)
> >                                 goto enomem_failure;
> > +                       anon_vma_lock_write(src->anon_vma);
>
> So, we drop and then reacquire src->anon_vma->root->rwsem, expecting
> src->anon_vma and src->anon_vma->root to be the same. And IIUC

I mean did you read the commit message? :)

We're not expecting that, they _have_ to be the same. It simply makes no sense
for them _not_ to be the same.

This is kind of the entire point of the patch.

> src->vm_mm's mmap lock is what guarantees all this. If so, could you
> please add a clarifying comment here?

No that's not what guarantees it? I don't understand what you mean?

I mean in a sense, if you had a totally broken situation where you didn't take
exclusive locks and could do some horribly broken racing here, then sure you
might end up with something broken, but I think it's super confusing to say 'oh
this lock guarantees it', well no it guarantees that you aren't completely
broken, what guarantees the shared root is how anon_vma_fork() works, which is
to:

- Clone.
- If not reused an anon_vma (which by recursion would also have same root)
  allocate new anon_vma.
- If allocated new, set root to source VMA's anon_vma, which by definition also
  has to be in its anon_vma_chain and have the same root (itself, if we're
  cloning from the ultimate parent).

But I don't think it'd be helpful to document all this, or we get into _adding_
confusion by putting _too much_ in a comment.

So I guess I'll just say,a s I do in the newly introduced
clenaup_partial_anon_vmas():

	/* All anon_vma's share the same root. */

>
> >                 }
> >                 anon_vma = pavc->anon_vma;
> > -               root = lock_anon_vma_root(root, anon_vma);
> >                 anon_vma_chain_link(dst, avc, anon_vma);
> >
> >                 /*
> > @@ -343,7 +316,8 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> >         }
> >         if (dst->anon_vma)
> >                 dst->anon_vma->num_active_vmas++;
> > -       unlock_anon_vma_root(root);
> > +
> > +       anon_vma_unlock_write(src->anon_vma);
> >         return 0;
> >
> >   enomem_failure:
> > @@ -438,15 +412,17 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
> >  void unlink_anon_vmas(struct vm_area_struct *vma)
> >  {
> >         struct anon_vma_chain *avc, *next;
> > -       struct anon_vma *root = NULL;
> > +       struct anon_vma *active_anon_vma = vma->anon_vma;
> >
> >         /* Always hold mmap lock, read-lock on unmap possibly. */
> >         mmap_assert_locked(vma->vm_mm);
> >
> >         /* Unfaulted is a no-op. */
> > -       if (!vma->anon_vma)
> > +       if (!active_anon_vma)
> >                 return;
> >
> > +       anon_vma_lock_write(active_anon_vma);
> > +
> >         /*
> >          * Unlink each anon_vma chained to the VMA.  This list is ordered
> >          * from newest to oldest, ensuring the root anon_vma gets freed last.
> > @@ -454,7 +430,6 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> >         list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
> >                 struct anon_vma *anon_vma = avc->anon_vma;
> >
> > -               root = lock_anon_vma_root(root, anon_vma);
> >                 anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
> >
> >                 /*
> > @@ -470,13 +445,14 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> >                 anon_vma_chain_free(avc);
> >         }
> >
> > -       vma->anon_vma->num_active_vmas--;
> > +       active_anon_vma->num_active_vmas--;
> >         /*
> >          * vma would still be needed after unlink, and anon_vma will be prepared
> >          * when handle fault.
> >          */
> >         vma->anon_vma = NULL;
> > -       unlock_anon_vma_root(root);
> > +       anon_vma_unlock_write(active_anon_vma);
> > +
> >
> >         /*
> >          * Iterate the list once more, it now only contains empty and unlinked
> > --
> > 2.52.0
> >

