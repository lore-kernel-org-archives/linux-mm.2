Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F3ECA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 01:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D60A8E022E; Fri, 15 Aug 2025 21:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880078E0008; Fri, 15 Aug 2025 21:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747268E022E; Fri, 15 Aug 2025 21:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 607438E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:03:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EBD41380B8
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:03:27 +0000 (UTC)
X-FDA: 83780822454.28.E40C7AA
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1D0C714000D
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:03:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ee254iZp;
	spf=pass (imf26.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.96.46 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755306204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3Zrd08Zi+FaLUWe+XwHL0CvRrFP/vLAxSztGYTZP88=;
	b=2VNUB6IP4D/uIY31g0JJcMSodJSjy50e6mO6Xau9soxlieqwoairtPLrMxDsOi828lgj6W
	5CDxDFd35tJqijLd0+M9EJ7CP1UyTzdrhQkQyQ79/UkkMgGiUSO3YCAohXv/y9GE2N4Rgz
	ID67005dM/5GyLc9GSBwQZSpn5sO+mk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ee254iZp;
	spf=pass (imf26.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.96.46 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755306204; a=rsa-sha256;
	cv=pass;
	b=TmHMOhAc2S0HoscFcpr3O5DN0qi89kgIQ4s0Gn2mUc5Xkba1RQoP/5cWJfSmGgn+nhe1I3
	rEcIBSVObc1GF0VZRFN8W1Wf81b0qHjnlm1hT5RLJxIfGQ4zjoy5XNcmDQNUC6Of/52EPH
	F1Z3kL5l2BmTxYwpsdpqoh/2H39DvQI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Il6Y+Bs5xj8R/y0Xni/F1BB/6pzHNDD6xYEWc8WjdoUvMAqOwF0sOkZMWqtQnSnPc26RHgC+yiaQ/0oV4tbxX8jC69+c+SMtUnEyIV/Lg3OIesEKpEu5du4R1wIf1o7SUAWNsoTWu/HOncusCbZV/YyBbBkMTbM77D0a7eUH6DopAM5vZ7rZz7l5UHN8lt0JbMBI3eRNFNc6SZZnAtsFAc/wqb0KdMfdg0uU5W2pNtrt49HXsCtHKQ5AMYtQw2o97gjUSeyHGKsDApmnBZs785t36PJIqO1/ElEK2zpR55JjmXLShJuCDVmz2zT4bNp5ceq6iKS+5gmawfL8HLEBWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3Zrd08Zi+FaLUWe+XwHL0CvRrFP/vLAxSztGYTZP88=;
 b=NZBBN5oF//qGz0oORGe+TE6nPma1HMfHupY0antzSB3zY2BZA0oVtw5Cui5HeMUEhYEP4Q883IhMitvavuPhKJ6R5oJM+uYEDd8bDksg+o3KRb4MSbaQCaBluHr0uIkAolvioHS7YNFx5zsWQr1vRj6/cAQ/XGGaKW6C9fC1Fvn0zyrYc4i5KRx1jKMm6ws0C9KmVw5AvwbzRf9bCYF89NnnZPQjMsOV+BLWe62IhXC1bQ2wzsxJLm/yRB4MvLFIZWiUJ+9C1xfCMH4DauFfTV9/NBghZQncboJrUph678rdAt7iajZS3LesSQiC7k8bJiX9MEAS/4kW3T3FP/Xqhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3Zrd08Zi+FaLUWe+XwHL0CvRrFP/vLAxSztGYTZP88=;
 b=Ee254iZpymJpbstVJCmzwcyvS1NzhGjx8UTE7uRGIhZzenQ2YK0X+LqJE1aA1GaxwpO2picVDe2acbjbw2usS2JVj7VugJ5fMSozj0utvTDPdU2B2QaZ+L5RLa6HJECtZO4V/rmSp8dqpsWBzMc7YAfjbJH6QRUp6YbKnJTCPIr56WQayLXnBbtx2Sd0hj1WkuojfwdiqaMgF+xpK812Dx9um1RQBZ3/UXCNDoGbdw9TCwLZg0xQuVQcfaBGIiQwYiXLI5E3wKmiHXMC3cGhsBiEuOqWcYQK/8h5oJK2puP0MNjNoOM/CVU42fK0jOwjyCB4kUTzQL01U2/Dryp0rw==
Received: from LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7)
 by SN7PR12MB8060.namprd12.prod.outlook.com (2603:10b6:806:343::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.25; Sat, 16 Aug
 2025 01:03:20 +0000
Received: from LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4]) by LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4%7]) with mapi id 15.20.9031.012; Sat, 16 Aug 2025
 01:03:20 +0000
Message-ID: <ef85aa74-180c-4fbc-8af6-e6cca45eed43@nvidia.com>
Date: Fri, 15 Aug 2025 18:03:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
To: Will Deacon <will@kernel.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
 Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 David Hildenbrand <david@redhat.com>, Frederick Mayle <fmayle@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>
References: <20250815101858.24352-1-will@kernel.org>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20250815101858.24352-1-will@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0066.namprd07.prod.outlook.com
 (2603:10b6:a03:60::43) To LV2PR12MB5968.namprd12.prod.outlook.com
 (2603:10b6:408:14f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5968:EE_|SN7PR12MB8060:EE_
X-MS-Office365-Filtering-Correlation-Id: 2900c224-b5a0-47cc-e32a-08dddc60b0eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0JONkRpWGhXc005NHJDT1h3Q2xDRUJURzVQVXhXdjU1dnpUenJXbmZ0QnJo?=
 =?utf-8?B?aUdxbjB1SkJVTll4K1VBeHB6SnVoTEZsYmdPRjJVdWRCVDNJdnYvTndpaGxD?=
 =?utf-8?B?Rm5KSHRJSWtZNjhUc1J2VkE1aUMwenFDNFJxOTIxRDduMTVMWUFTUjRuQlJ2?=
 =?utf-8?B?TlIwcERLL2FLVnFTTlZjMC9QRVBsWlk1QWVhTDQvTWZKMmZ2QUk3VStuZjIz?=
 =?utf-8?B?cjFFbTh0WmpXV2lNb2dORFgxK3V5aDB3dDkzN2xJRFp0WGZKSkYwVDZXaGEx?=
 =?utf-8?B?Z0U3cFB3QldqU2VpOXhvZ09ITFhZUGFpNXhGLzRJcEozM0RWNUs5aFo0S2s4?=
 =?utf-8?B?ZDZwcS9WdmlLUk96dGVvNWFWNVR4QWdVOEtGMUYzdTN0VUFCWEQzb2luV2Yw?=
 =?utf-8?B?ZlhZZHpSVStreEJnQ2xhR0c3SXg0bll5K2pOT0o3NzFIYy9EYmFBcUNXeGRX?=
 =?utf-8?B?SnZmSDVsOEJwZEFwd2J2bk9ydUg2aEJoNzdGVHlGSTYrcHVPTXhlcktrSHZv?=
 =?utf-8?B?ZHFQTTY0TityWVhPVWF6dDBKTENOYjJCYUdjekszUThPbjN2Y0JrZkF5bVZl?=
 =?utf-8?B?V094MWxtV3lxKzFvVjlzdERVS084aFlBUTBVMjJnVGk4cU5TdzFKczNPclJo?=
 =?utf-8?B?M3JJWlRGeThuUFFlSmxuM21jb0d0OHdEb1lvSVdiUExMMEQ4bG9KZzhNRDRz?=
 =?utf-8?B?SDR0WWZWV1RMRGY4WHVYWVNiS1VBMnByUlpINUpjZy9mWmJDVkVWVkxYejND?=
 =?utf-8?B?ZUszUENJUWNBdFdTQ25BOW81cTM0SUxCSG5EeC90QndWNkZLMDhZeENEbk9h?=
 =?utf-8?B?ZzRUQWVsa0V6OU4xWHR0RkY4WlBkYmoxa3dsVW84dkcrYmdSY0dQWnZ1Tk5a?=
 =?utf-8?B?cEorenlGc1NRRzk3T1ZydnE4NjZxUVRjTXRmR1FKNmhWb01PMi9UKzYwNWF1?=
 =?utf-8?B?d3hETm80WW9ST09CUWdiME1pMzBOTktMejNsV2lwVExLbEdsQVdQeUUwYjd3?=
 =?utf-8?B?TzRJUWR2RVVmcVhTTHhsSElTbElzVGoxWnZ5SWZqWW5ocVpwUGpic0hUSlJv?=
 =?utf-8?B?ZG5wRnhEV0VBYkR4TGNMcmRqZDJPeHdWMmduc1FwQnA0T2huRXN5TjdJWENs?=
 =?utf-8?B?MHk1QTYyTWs5bGlmb3pvdGIwdXJFK1hZWko2SlRrOE1zek1nL0dUcUZWeDM5?=
 =?utf-8?B?ekVhVkpKT1ZmcTBtWFJTK2orbEJSM082TEpkZW5malp4WEdXaW1pdjA3QitC?=
 =?utf-8?B?OHp5M3RRN1BldWs2ejRpS3NqQU1VbWFqWTdMRmdWK0hvOXBJSjcvWHppVHgz?=
 =?utf-8?B?ZzQ3NmlxWXpieHR5WURtSnl4WlU0cWJFbUJvZW1qMmZJSDVkNGVKZDFEb1dZ?=
 =?utf-8?B?QWEyY1hna2tBWkRxSVZYTVVFelZBM25PaEtxVk9sWTQ5ZkZFc1ljbjRxUUJX?=
 =?utf-8?B?NDlOWlJqNDV2STdvUzFMRlhLTUdPWlpTR3ZJb2k5NDZTTVpNR2NBdmd3dmpX?=
 =?utf-8?B?WTBEZFhlckJ3TnJNMFpnR2lXalpKNnJqNnNzQi8zRmcvZzcwaVZ2REpQMkdx?=
 =?utf-8?B?elZsU3NBZWJmVDkxUnBYR2ZiU3pBTXIwL29QOVkyZ2JQUHdyVTNXSjR0eEh0?=
 =?utf-8?B?S0dQdHVxMjZuaDNyc21qK1VSUjduZHU1YXliN2R4YmZOd2l6dmlPUG5DQ3lv?=
 =?utf-8?B?b0Q4WFZzdzZKbzJIT29zUnlqUVI1L05RVVFuVVRkcWkyUzI2eXU5eWkySmo0?=
 =?utf-8?B?ZDAvNk9tQ1FJTTU0bmxZS1pUcnpOdSs3UjNTQTd3TVlXQnFyditxTmZZREhm?=
 =?utf-8?B?Y0wwUS9TMWkxaXBkU1kyRUwyclQ5VXc2YUxSamVPWDNUS2cyVTh6UDBNenpY?=
 =?utf-8?B?RE9oYVpOeVI0bzFpTXpobnFUQTdUZmgvU056M3dta0tQYmo4bkxnMFkvYjRt?=
 =?utf-8?Q?VC7gPr2s/Dk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5968.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEJJM2VKdjROalJlekFkbWZxUVp3NmlneFpESjdyREZkWEdCODFTQWRMZVdt?=
 =?utf-8?B?YlFETTA0ejM2OTR2c29wZ2dCS1FnS3pjdkVyTm40a1o0WnZiSWRpMTk5YXZv?=
 =?utf-8?B?dzJwV0hkbk1aTTMySHRHeUl4QlNkdTNkT3JGUG5wZDNRdzJGMVU0RUY0RjJH?=
 =?utf-8?B?NWxhczFZVGRBNzdGa2kwcjdpTTd4cEszUW9aS1BjeW5MeFhrbGZLVkk1OUwy?=
 =?utf-8?B?ZjgwbGxxU0N4Ri8zNTE4anU0UmlMM3I1K0FsT0xvRGFQTExXNjYxZERFbDla?=
 =?utf-8?B?NzF2TFRDYkVwR3Y4YUduUUdFYTBBOVJIQ0NNdkJMMHkwTEZkMm9TNTNlSmln?=
 =?utf-8?B?YkM3ek90c25pb1VxL0NNVGxRNUEvL1I5bzJ2WC9IK2UrUlY0NFJEN0RiNndC?=
 =?utf-8?B?UWRwejJKZnd0VVhlTjNsdnI4TTdUYmVwTVFrUllGOHJKMDFtTVltS3pLcnZk?=
 =?utf-8?B?UFBIZWtZWXM5UDlZdjh3ZXNMRG96TVA1Rlh5WGFad1hscmIyVFVTZXd5VkJL?=
 =?utf-8?B?WDNURVF6UG5Pa09nOU5LVVJoWUNQRTg3ZVR6dTVKRXNPdHUwQnpXN3kwbXNE?=
 =?utf-8?B?TkN5T0hrYXpJMmtOZWFVd3NQcHh1VXdncmUvQXJxYjZrc2x1WjdQUS85TWNx?=
 =?utf-8?B?TjBHNkx0WENGOU4yZVNvMGswdXVuVFhoYWdHOG5LNkFOZWpRZ3ZseWVLcFFW?=
 =?utf-8?B?Ym1iSUpBZDFkRnE1RDgrOXN0cGZaeXBLWEpXQ0U3S1dFejNQSzY3RmwzV0tq?=
 =?utf-8?B?UzRpQmhSNkw4ZnVZZFRleXZXcTFMQ3lpczJLeHplVW1lZWRPM2dhckczNUJx?=
 =?utf-8?B?M2lWZm5wYTU2UTdxd1RMYmtIdmpjV1dwQ0tITjZTclE1Z1c0RXRYZng3L0p3?=
 =?utf-8?B?M2dLMFdvWm1WR1BQVnJJcVNSVFJBK0FsSlRZcFl3MENhVnVXWkRrMElDaHFy?=
 =?utf-8?B?NlRvZlpxMkllL1liRjZad3haRGQyUnJzZERKd0V1RitrNjZwcW51VGdYaFpS?=
 =?utf-8?B?dFBWZE5Wa1Fzb2xyR0RXZUlXZEJXUUdvNG5tNENjcXlvY2VYUDd1c3d2N2pL?=
 =?utf-8?B?NG0xZnFXb3dPWjJEZy9ibThUdmRHL2I4REZ4dGxUODhCd0hzNGxGKzlZeTV5?=
 =?utf-8?B?UjRTTS9ueGt6WFdqeDhSdTh1bjRWV2pxUXFQWlFFY3pheHY1T0JnN0owY3hm?=
 =?utf-8?B?UytzNHNzZHlwbkpzbUNqNktaKzl2QUF0VkZ1WWJIdTlzd3RQeXNGV2lJQzVO?=
 =?utf-8?B?cjFHU2dYSlRzTFp0OGpCS3Vjb3Vka28wbTZBd2VnVU9WT1RxSDFOcTMyUE14?=
 =?utf-8?B?aU4vMisyWlVPZDNGbnRuZkNQa1ovUngxdjhtd1JhS0h1UktXWVIzTVdlNW4x?=
 =?utf-8?B?dlQvWkQ4dkh1RlhwQnhveHJmVldrTVVJejFLcXBmdjZ0WEN4YmhROFFEUFZ0?=
 =?utf-8?B?QkdGSGpEK3QxZTBtUUFjeFRzZ1ZaeHl2SUprcTBISFJ6SUNuZmRXNmVidlht?=
 =?utf-8?B?eDd1Zkx1aVlOV0oraHdqb3J0UWZwVjNVMENYdDMzUGN3TnNYZlZsS0JKaEtJ?=
 =?utf-8?B?NjZFd0hpL3NYclA5RGNSUENFVW5mcWN4dk1OL0xScXcvOTBVWGhWOFZBamg2?=
 =?utf-8?B?TW1qL1pBRTZxWTVPY0R0T3ZYenFGY2pHVE9iRUhyWjBtdGMwUzlNbmhBejF4?=
 =?utf-8?B?L2pzbjVBdHF0bGdzb0haWm51RlV2N2toeHYwOFFsOU01dXFJT1FUeFgzdzJB?=
 =?utf-8?B?WURzMGJ6eWhXNXdLWHdxUHJRV2JITVUvbWtUeE4vN2E1Z2I3VnBoVVdsSGxl?=
 =?utf-8?B?bzE0MFl0NUkybU5wbEdZcUs2aEM4eklHbkF1S0VvYXJ4MHptd1F0SUVjSEl2?=
 =?utf-8?B?cXJYcU51dzFObnVIREY1MVIwTzQvdVlwSzlVNkdlVXArcU00UG5PdCszTkNK?=
 =?utf-8?B?SHdocmFvenIvTXgvQ1F3UW5EQkp6NmlaWVVuRmt4NXFNbDhwVzdPd1Y3bDVK?=
 =?utf-8?B?UnlJMlcvcm1KS2JQbFlWcGl5WkpwaU93aWVNeUlzeVFjbHIxaTJBSzZnQ2hC?=
 =?utf-8?B?OW9QREVaWnlrbFE2b2NwMHJxMHpvUEYwTUZXdFZUK0ZIdnBieVFYaWRwelRF?=
 =?utf-8?Q?1doeBrD3Qx8SYH/Twbf9bfBjr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2900c224-b5a0-47cc-e32a-08dddc60b0eb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5968.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 01:03:20.0813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JM9vPatvuyr4fvNdDh1pLTY3Nqd+M7T/e+ICaQS98NZxSWMyO5I5e/rhEYOA/0T2v8VUezrvp/+/qIdpqB2T8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8060
X-Stat-Signature: dzj5795iaexx7sashmd5jo8nhno8tm9n
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D0C714000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1755306203-178698
X-HE-Meta: U2FsdGVkX1/AgLRiy9+YZmIeMMU8xkK+FU6m/CFSCn9blw3VINRzHnEqIBQfZcC+g7C5MfUmjvj8CK8D6tvGrn0a337wyJWWwxJOYw68sRYCk4V+uN20zZK3ZhStvd546RmnYlKTcQHupsaVgZXXbTjiGSCk4fqHUz5MMs0a3sU5CjG7bb3tjiUn4rR4T5CouKRTRyuWma4utMfUeZ63yxCsshKPyAw4ibFFybj6kiJbE8HyC0GfnpY2bpkv7ZDHgGFvXXDmNkzYl9km2ptWD2fiZqbyI8yynb91GhaBTiHCNX6FHxF7Hffzz86FIkWS+1Ft78Pe8n6VD6IUs0ESZfg5fNW8iY9+OXiMSX0w2dhRxg1RnPCSkYDiMPmpILn7ShIKTR6NWjcuPc0JcXQyZMfRYS+TLI4etA8O1YuYHZCtRTZSn1SbDSek02XXLpBwdJC5u7f/9cfvof92I5575nXmtLeRZpZsfc7afi3aiJwlDevgwnia64HPS5LScKjujXSZQj8xHC/t/iLatQerokxGYPy5d4dimdHbV+uQdmGRa07RYJUZzrbq96JHWSmzUlpjaTcy0/eM9xCevzEjiqSI5AAU0Nl1C1V0SjtBFlqSoqB9pBYUpf04/FU5U2J/HgZY4275MsrUB7jBedrmRZVwfgdmE1pM+N+X+lKBrn9AeomR6KfaYm0KhtWrCrmwge8McBWDzwxvTiLeh15WQSdsZwiJ0CiKlA4FzuXrNTTUlFtkn4hdAPhhkHlnYSPph7IcZVO4f7bRq1QZ4eAxEKIjq2o9Z29vJ+WHWwfELCysy+VOtQecM4bPHdqZ8tk373+hUaSZijEzd1uYCcbfHxqGvEOqGJplvDPh3pYGZfNYR+BK4f7AEeCuNYzYWj/2xaeReo1TV4e11mhom+i8YT8jTBfdsM251JQUT6bgyfrzGQV6nOxNOmisfvvyX9uhoMv6xuZs96dTK0VgK5H
 oAJJZVdz
 VFO324tFcSAwVAKqQNOx1eoZSYtaTFJDyClOkOmIjdKmrDuD+zG/dKo6CWEN97MGQt0RTanjwnfWXxR3bIhO9lkTmb85nRGIfVaNglyNymg2UUrhk/4/zBelWPrt07WhxlXLvj/aEALAVVbZ/UhPhzjemX7FRejEwMnFzoDSG7BRdo5/pQ1oGbPynvmd4BrDXi5tjmTdssGhfdIPVhejM1u0v9wm7GyppyxSJiP0MdK5oget/J5iP2KYGOVb8N0rHkIKtLqinq/7c9riCOtZIY9Jgt/6aM28TigY1mFhfJKnd6CFo9+gj6e38PH6T34sZEZ6qyt20SKxA8CmQrlh4W3yiUElWnG+mSoe5BbfDkD4DM648ifswhxOcPUxawchLK2RGeDNEbfW6r+Fv1lggzint6u/ftUhFLhVRNWs8ohId0sX8m9ZDDpZAObagKRY8NE0ml2HP+qIe54+BhMSRMtTYwQYE4iRIii/y+RwETVa9NhGWkdrMElZ6bB4T6tVg8GErgptdUnFlYjOaVpf9EiVedl/p439uIe3URHfXuujvfLAqRbhJ9KWhlB9dWfWalbKan60kaMMYrUOS/NsZ1ovM17F9O0j9W7Z7nsXb/PYeQWrC9HrNkgkNfHjPyW2MKbQsKqNrGYBxzwsiFK9nvMlIAPPU7PBkzt5VS9kVlkSwre0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/15/25 3:18 AM, Will Deacon wrote:
> When taking a longterm GUP pin via pin_user_pages(),
> __gup_longterm_locked() tries to migrate target folios that should not
> be longterm pinned, for example because they reside in a CMA region or
> movable zone. This is done by first pinning all of the target folios
> anyway, collecting all of the longterm-unpinnable target folios into a
> list, dropping the pins that were just taken and finally handing the
> list off to migrate_pages() for the actual migration.
> 
> It is critically important that no unexpected references are held on the
> folios being migrated, otherwise the migration will fail and
> pin_user_pages() will return -ENOMEM to its caller. Unfortunately, it is
> relatively easy to observe migration failures when running pKVM (which
> uses pin_user_pages() on crosvm's virtual address space to resolve
> stage-2 page faults from the guest) on a 6.15-based Pixel 6 device and
> this results in the VM terminating prematurely.
> 
> In the failure case, 'crosvm' has called mlock(MLOCK_ONFAULT) on its
> mapping of guest memory prior to the pinning. Subsequently, when
> pin_user_pages() walks the page-table, the relevant 'pte' is not
> present and so the faulting logic allocates a new folio, mlocks it
> with mlock_folio() and maps it in the page-table.
> 
> Since commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page()
> batch by pagevec"), mlock/munlock operations on a folio (formerly page),
> are deferred. For example, mlock_folio() takes an additional reference
> on the target folio before placing it into a per-cpu 'folio_batch' for
> later processing by mlock_folio_batch(), which drops the refcount once
> the operation is complete. Processing of the batches is coupled with
> the LRU batch logic and can be forcefully drained with
> lru_add_drain_all() but as long as a folio remains unprocessed on the
> batch, its refcount will be elevated.
> 
> This deferred batching therefore interacts poorly with the pKVM pinning

I would go even a little broader (more general), and claim that this
deferred batching interacts poorly with gup FOLL_LONGTERM when trying
to pin folios in CMA or ZONE_MOVABLE, in fact. 

More on this below.

> scenario as we can find ourselves in a situation where the migration
> code fails to migrate a folio due to the elevated refcount from the
> pending mlock operation.
> 
> Extend the existing LRU draining logic in
> collect_longterm_unpinnable_folios() so that unpinnable mlocked folios
> on the LRU also trigger a drain.
> 
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Keir Fraser <keirf@google.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Frederick Mayle <fmayle@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Peter Xu <peterx@redhat.com>
> Fixes: 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
> 
> This has been quite unpleasant to debug and, as I'm not intimately

I'll bet! It's not even pleasant to *read* about it! haha. Sorry you had
to suffer through this.

> familiar with the mm internals, I've tried to include all the relevant
> details in the commit message in case there's a preferred alternative
> way of solving the problem or there's a flaw in my logic.
> 
>  mm/gup.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index adffe663594d..656835890f05 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2307,7 +2307,8 @@ static unsigned long collect_longterm_unpinnable_folios(
>  			continue;
>  		}
>  
> -		if (!folio_test_lru(folio) && drain_allow) {
> +		if (drain_allow &&
> +		   (!folio_test_lru(folio) || folio_test_mlocked(folio))) {

That should work, yes.

Alternatively, after thinking about this a bit today, it seems to me that the
mlock batching is a little too bold, given the presence of gup/pup. And so I'm
tempted to fix the problem closer to the root cause, like this (below).

But maybe this is actually *less* wise than what you have proposed...

I'd like to hear other mm folks' opinion on this approach:

diff --git a/mm/mlock.c b/mm/mlock.c
index a1d93ad33c6d..edecdd32996e 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -278,7 +278,15 @@ void mlock_new_folio(struct folio *folio)
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    folio_test_large(folio) || lru_cache_disabled() ||
+	/*
+	 * If this is being called as part of a gup FOLL_LONGTERM operation in
+	 * CMA/MOVABLE zones with MLOCK_ONFAULT active, then the newly faulted
+	 * in folio will need to immediately migrate to a pinnable zone.
+	 * Allowing the mlock operation to batch would break the ability to
+	 * migrate the folio. Instead, force immediate processing.
+	 */
+	 (current->flags & PF_MEMALLOC_PIN))
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }



>  			lru_add_drain_all();
>  			drain_allow = false;
>  		}

thanks,
-- 
John Hubbard


