Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DDBEC88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2666B00AB; Sun, 13 Sep 2026 22:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65FA46B00AC; Sun, 13 Sep 2026 22:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4609E6B00AD; Sun, 13 Sep 2026 22:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 135056B00AB
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:24:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9029240E27
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:51 +0000 (UTC)
X-FDA: 85210774782.04.844C9FF
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013010.outbound.protection.outlook.com [40.93.201.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id C7E1A180002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qoSQdr28;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rN1+a+WbXXMcnQSTG/PwdTVyIvCPX0jjoxiMDHWAUIs=;
	b=aP09ACEKftDiLe0Tf4NGrs2AmH0SARhrJ+FnVSy4FIyvcSKsM/qDakrnTVdEeWmAktNcW9
	RpGPL3dVdMa3/MzOxWrFtx6PwtOQEOEZ0W3em/WHoFORiHs5QH8HuZ5I6ACgRUyrgFoJ+n
	vlpcbuYpykFxxZ0c6U8J13NHaZ+dcHk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789352688;
	b=8S3nDz0kz3h9nTG3FCszzOd+qbX/GEGDkhiRlB1zOF7N5vYpK0PTHgq2vIic0ecXwUWxbj
	dVLiplDsvYiGR88b71PbfWMAYh1W8p52QfLWxNw9+ZLwoXOVArGaWAciZm/hQz3iB4UKIw
	mLR3ip9eSjZDTtvNzkz8fp3wqOJlL4s=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qoSQdr28;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnYWwJSbl9iCnp8O1wWePNMrJRBPqweLglChZ0rec+n49BxOjT6hXNskgsJdjQpG7/KYtkEE7Zn3thKmKw+oRD73c681YrBgR6GP0v/MzhYAatRq8Ppd1LscnVDHewZMuMvu8F7AyKvuUdIHacbRHFZk875qRIUwUZBDszE/nr/53gXXt4O/qguk/0z7qj1f35ezjBtfi8aD9S66KMz37MXD5K9mxA+I5N+V79+DlSTwTKbp8W+lvuaT7UuWclwXs9VVBeh4voxB3G4rossaiRnGBkvQVabbFJX2o8QXmX8+o74XQjqS64DCYpcu7mTuYXTM795ToYF+HQ9V9bj9Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rN1+a+WbXXMcnQSTG/PwdTVyIvCPX0jjoxiMDHWAUIs=;
 b=j1Rvs3MIp+K56Tb5UF8pcTgdYy01Y1GEOBJzRXrCx5KLyxHJBKptn+RHgWbCnxBB1yXcEfldlAEaA5DN0bqhT+UZuXzs7NBP3DNlQic9C3rZlpBxjsKEG4FnaUNUDBpD5f6rkLE93QagqHYhCg1iT8nXG4wM7czhPSGPQzCaQLgYpfezyMFf768s3dprfhjMztiQZIbBKna9oUcNYHS+4j4tvMdZK39klJ+0oG4p+V/wLaap7RBGFFBWCbMoFI5cn76xlYTQHPowSvwVW604ymjdZb7q+vq6gjvsgCx4Xe5yl5jNTpzaoTP5Oyj6EhG1GMaxKKW0W0QP0Qo2PtLgfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rN1+a+WbXXMcnQSTG/PwdTVyIvCPX0jjoxiMDHWAUIs=;
 b=qoSQdr28E48G3GnJVrdEWlEkcb1LINA76FKQDoDZduly8G+67ecTntoSAOA0JoPpikan+Z5RWLQBitOdGOybktFa8DJHeQFpkLLEElSJDPooMIEdVnS5MJmphXgdKV0p/16YKyRFjITRT8kMWmxA7QlNCkjYUO3J0IKQnAJxoooxQ0LTxY4Kqx5tEooW3MOB7PMKqTAaL1cthhzb6adTsZiu+sRSWbjz8QVYDSWYcRi1v4q/UxhhkHocle/hyjyPFRn81VeEX/xgMLbzJHC0JPW3caIfKxVPwfOCdrLe0+klZoYbCjNEweqJMDtxg5A4PCFiuDSzWphtahftVbJ0dA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:31 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:31 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:14 -0400
Subject: [PATCH v4 16/16] mm/page-flags: remove PG_private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-16-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Baoquan He <baoquan.he@linux.dev>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Dave Young <ruirui.yang@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQBPR0101CA0083.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: 30c58b29-3f79-4729-a59c-08df12074f21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|6133799003|22082099003|18002099003|921020|10067099003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	2dfEYJ61jJkyc61FyZejhtGZoce7Dq79QvLrSw1OWVjyshKApmvePFW4W2CoK4XWwuFF/6VLcPrpTVZ0aAIy1HVt96MaHpGL0i9WuxqKoBeormyPcnT2P7cQVRkbprPxkZSuG2/0pHhQryzLuqYXJxpdr+6C0mhgWmjk4z3P4/64cGuH+2EmPYp8lavgRO/M4mR314LzYc7nU0CkXu7k4zZ9aLaGrs2W6PXZuAoLGQ3FflE8K4oQnHoeiYRi5Qey2b2GBk4MYeucYbY5yWIJt88sW2LuG/Cs4g+QscfUw/4aPLAIdKlAr+dgvIMD7tYj2tUtOCIJWIoSrz91WfUYZXQus8lEt16aU7v9KrZxPeYwiSuAJ1nv3oW3W/zmOnV2DCjxlFSPEHKAVQP3qihOYiJi7uUgCqVXwZVb6QKaPYQ5vAFCMRAkyMsWNRgEgpHqZ2IXVpsp7c2ufKLbV/dchC/Vp3owH7LwcWNBXOrsl/+GwWVQihvYJpUyjZiW8e3QXTWl5wCxnMiv2wANXmIDhS+LaV6FK0Cc8Kenxluh6mdlMtwM720SzROkLMYIDM8OevrGAjhfLDmOLXT1OZsQxGgIHQJCiJpt6CvY6bujVvZl9wRV2EijRkmG60ScGjMLWMFhcT73hhPYvYmOnteeoZ6zqZ/9dOXzUShO2xW/2GrCcAmGIF7MCQxjUyjCVQwCHeUkcUWTn0bTvtMfvCzR1w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SSt2Q0UwelNKVDVreDdmenphVWU0RnE1dG11Z3lPaUxZNmh2WTFkMmNweCtZ?=
 =?utf-8?B?WXdBVXFQWmNDSm1VMEpXVlVEaGRhdC8wclphcy9BRUg3YWU5WkRibHNqYzds?=
 =?utf-8?B?ZzgrbUU1UWVhNlJJSmhBSlVScjYwa3o4VmdSeHAvNEZjV2xSUG9IcjJ3SCtS?=
 =?utf-8?B?Z3pnTThGM1ppc2Z0NmF1cy93Y0VQSGVZQ1IvdmVjUVd4cTJDQXZ4elM4T2sz?=
 =?utf-8?B?N3lWL0YwajFwY0ViNDVXZERpZFU5UnJXSk5IRXI3UjVGV0VIZ3Zhd0VhNHIx?=
 =?utf-8?B?Nm1zYTBTUk9XTmZSR2hTSXJLSktYTUpXZkNFK0pndzQyWnkrRTIwOGcwb1pO?=
 =?utf-8?B?dlNjMTdMVEl4LzBmMGRpemMzN2JDVUZXcHRQNFVEcDdZTjZIWFRPQW5lSysx?=
 =?utf-8?B?eDFpeGhtUjdkMGRpOTRpUVM3Nk5weXNFNXRjanRCbzRJWWMxNjZqZHlBdzkv?=
 =?utf-8?B?OUVnNVpmb1ZDTjFvNFRkZUp5Q3hIcGNHZERXMEs1V29WSE5FSS9RQTNUdEFS?=
 =?utf-8?B?NC9EamJlbWJmZUI5aWdxUW0rbkQ0WkhuN2JkSjNYZkxaNm0xWnc3VURYYXZi?=
 =?utf-8?B?TmhKeU0vNjV0QWRDL3JOeWptdGtDYnk4N0FNdktxNVFXWFd2VW93ZWdiaWwr?=
 =?utf-8?B?YVpNM3BaTjdQNHEyOVlFMllHNkpFTVRaRFBqSHJMTGlzeHROZi9ZQ0o0Wldu?=
 =?utf-8?B?VGEvU0lycFVld3dWbG5EV0JBaGJ4YWFMemlUamZVdDJIbFRZZ1YwalVRUVRq?=
 =?utf-8?B?cS9OazFrYmxRNUoxQ2pZWGxqSmZGWUoxc2ltdVYvbk1sWklLYkRmYzNPcU9N?=
 =?utf-8?B?Q1hTWVJRWHlWL1dzN0dzUWJLZmlZOWFyQVBkcG8wT0szM21EWlZQYURnTkpY?=
 =?utf-8?B?aEFISFR4cng3SnUxcVBWckRmUkgzUzJnYXNCT1lLRzREWG5RcHoybVJiTVZ2?=
 =?utf-8?B?QUxkWnY0TXo3RnFhcGRoeHR1b2E2NXRzRUVhYnArSDJMcXRnNGpyT2c4YjZ1?=
 =?utf-8?B?YWV1a2hJbS95K0ZTWU9tUWErTnBOWEhsbVJ2b3ZTdXdYTmFsZWhwNC9yTSth?=
 =?utf-8?B?YS8xVDdOWXJhUlByMC9UKzBJZHYzL0dNTFh3b1FYSGpydUtsYVJqL1R2QUEy?=
 =?utf-8?B?S0lrdVhKU2VpUUdjenU0dUVxU2NTZkxuOEplUEJ0bHdMSGJHSHVqR1lxajAz?=
 =?utf-8?B?QXhqUDdtRUtCZHhlTHZuNTduSG1Gei8zY2E4cmo4UFFsTEE3OEdmMFpjMTd3?=
 =?utf-8?B?Z3lrMTdzb29uZ1B0VTFDQWNMbWJacTdXUlErV0ZpTkFGZWdVZHc0VnpwT0cy?=
 =?utf-8?B?Z09JZnRrZ2Q1UWhZS3pVOC8zb0FJVE8yQ0g1WDBVL1FoTjUvQmgyQ0lyRnd3?=
 =?utf-8?B?cDVnV1lhZWVrZ01FSlFzaEt2R2tBeWJwWXQ4ckRPY1R4YTAwUXBKcmgrT1ZR?=
 =?utf-8?B?aThtRmhBWUdPdjgxdVp4TmJkVEM4SUhsc3RpOUtiZ1hyUXNpYUlaelE4bGNK?=
 =?utf-8?B?VzFPS2I3ejFQS1FvNGZCb2VFY0ZhNEhwY3pKWEdIdWZpQW1PcXJ5SVF6Y0Nk?=
 =?utf-8?B?RG1wS3JQMTNBbjdLOFRzQmNkamZSbVFUWnZVSDM5SE5ucWxTUDViZzNBdStE?=
 =?utf-8?B?R3ZJdlJGUExxY1FEcE0wVytYNkhERjZoL1diUkhQblc3K2RRL2pSVnRiRUlD?=
 =?utf-8?B?ci8wSEJpUnZZR3RYSW1qeGUzYWRCTXZGdG8ySCtMT1pLRTVWZTJxL1g4eWQ1?=
 =?utf-8?B?Z1FaQis4QmV5TFZraDFmbUI2M3o0TDE1Q3RCakRjRnhvTDVlVG1BajV2V3Jx?=
 =?utf-8?B?YXAwcnA2QjZzNXdyalYwWVVvVDJvOHFraldqU1o5b0hQeUE4SlRoTitwK29N?=
 =?utf-8?B?TVJ0TUg3bTFlSHpCc0NUMExqb0JNMlQ1MnNQTXJlMGttUlNTMStOUXAwTEl5?=
 =?utf-8?B?RXFPcWhTdGtjTkI3L04yME5lTFpSM1NZRkpuK1pyQkxWNW9EOUlaQ1ZZRHNU?=
 =?utf-8?B?OFQ2dFA5b3lMSDBZSHZBL054NmNlS0JaNjMxUVB2RlhtbHFmNTZoVjFEV09W?=
 =?utf-8?B?blFucnZtSENVTzZLdmt4a3Y3NitMb3dhMDJiVkFrMGtCZGlQRnc1N2dqaFhM?=
 =?utf-8?B?Nkt0SVNpcTE3eTZ1bmpoeElpZ1ozK1VXK2E5dkozMHdGdkNDN21rREVFMk1F?=
 =?utf-8?B?MDN0WXFyRTNsWHJwOFBkRlhLbUp4YmlVczZkM1g2V0Rkdk1uQ2hnb0JZRzlh?=
 =?utf-8?B?RVVMQlNwTzdLRmlYQk1TbW9XY2czaHZFcThqblpYM05XY0E4eDBYeDlVNTd6?=
 =?utf-8?Q?q2wq2jEb4D/jcp3Bbk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c58b29-3f79-4729-a59c-08df12074f21
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:31.2611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1cV/qG4beDPnCKyYZaiHFdlLYF93aWukeu6iKxzuDP6p1pfK9036LGKUfqt84Y3F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C7E1A180002
X-Stat-Signature: qa8hbmf6njgkagc6macfznh517nwrm9o
X-Rspam-User: 
X-HE-Tag: 1789352688-457321
X-HE-Meta: U2FsdGVkX1/RZulKl51iCifD56cAX0A7vmHWkALtJunAZbiETLYYwDNDggToHKxWcjXLk3gaGYmyIx7MjdlJ1jyRmoei69A0UFucKh9dg4uzdJSt4sHY+RUo2MZiyl1xnqUNhK3DkuAfdDevhJvfTCa9Lpy9v0/JSqwDD2t7dkOdyCLexj83cUIuEvWf1gbzBPRoK3y0a6cpWRz5YtGH0mJy1dgfwX0FMqsyjRwpnQ+q2z2fekIv9vVAO+NfdPDEgkQxTiUx6/4BMcD1NPUeCqqgQZ6V2peGZN0WdEui5vs1eVQ0NZJolDOQiwq7HrxmM2v1SA/g+IVjdOjOb0j4h4uRiSKCRHVE3BYlO2/7d+kW4Lo0WVsN8wTMpBvxamKUOEXpdpgDvYyGf0xAUKjfvi9DjiaULxGHRGzMKdiRn2AJ/ZKPdq/+QZUMUo0xJmf5OYBe1b36dL/d/6N4LDRh2phXyW5KblJfVlIDEG/QIXZM8/BOIe2dSY7Lj5NCzvGmq9kBgSQkmH+K2Q12nb9Y2nN/PxbqMx6PcWuLM0pdFferlsWt2ATLbYSZL35l6GkUFNw9qrhwntrw8ufO3EaweLSB4nKXjrKK+nosvMM0VsZYYaOzNUnJ9E6mK1UTDy73ELV8XBmnu+OJGzVCL6n233BJKTmm3ywNoxlEcHCAuvUxGSkAYhxSClwCGIfTRcdrBDej8WmSh64Cz8pd4U6SXMpUw0vwULmAAc1wKeQ+jlrSg2dF8NGVhjXMG/a2DaVb2urXXpI/PzJ9UB0ZUw0U9o0NONV0GltLu4od4TSKwU1RrKMeteHteZT9n4auFVUQbgzOMdWlQ9UidUREyuF6DB1orgqnCmEeIbhKG3goUu8TIPf8raVClTH2ra7zSv5m0muOsyO6CWCWWhZ35sfLrG7cMruW0VVteOq0l0lWALu2iJHGOoalj5GdhFXQWxF+eSA/SK90RbYH2An7oLJ
 cqhyEyl+
 7BlQ4+y3kXhJ+tZb5xqGLKdVOxy5qWMcv3cp81oAZ40uNJ/msRibrv8G/bXG5akahojySaZADDTDE05huPbswBN5bj0D1IqwDCM4NPtugqj79gphmdJh5GgBg1eQc9sTu1FF7Jk8KRINhSE1XkERSmQlSidzyL6ior7L6SVeepdhujTw2xF0+NkS5sQ6Zgi7ZORB8m8MgENshTH5Eie6kEA+HsM7aAOieYNcS/mRSOCHG9d8NT6OYrJUJSL/Xfg3qvCiMtMLU4vhOmF70zF1Qxy0WCi6KcC9o5eIkRRBb6xz5qLFz7AIKzVddDrH5VXhl/b1H/4rhh/rSRgRi3G7m1kAy6xSEgNUnzVuUogGm8E1DgAOIX+lIsBET+46Mt1CtvbQ1Dj6wYTqkLBfUcFoCy8tpPbuVqVyYtUMJaMqgM3KgYIuo67bLQHnlLrkKWDhz3pnybske5NzYUotO+lJiPVV/ad5Yt1qY+VUsNXRidi38H2mQVffOIH38gL3iRre3jz7zjyQbe2vVA/SRdj17x1cSI0QIRTk5ZbhIk+fqbJKTazUyX6jGNrQKkWJOBH9IIhloQ7Zqd6VXofgq+ZRhY4rS73gxFb8vsmak7r1voG1f5yuITGMYti6xhQ7H3HYNVocNoZIQvXnY4gBpFFeYyBJ77w6eHZnWkNZDiYqc35y4uqFpMcCRka6B1UbbPclBQ4ylw4HFT0zl2cpZIFj8hHNw7m3GgdEEfMa7tdSEb2anJSG10JQ73fbrkjC4+sfq6FUIxD6+rjyPZI+D72gOE8J5eYWxzUP/ustu5LAg7AZsrEEzNOGJNMWi2udu5aoESgkHKFj7IuhOBHESjZ9j4OXB4YgU2092+H3uOxTsBEnYi7XoIc0IZJcJ1/SfX9GWZU57Bj8xTg2iq841VvNrP3McA4PwN4JTjegP8ppOPYe1KeW4+SXjG5Uq/6YPadXl3vRnPOop7QaSaQezJhFcTbRTACAS
 0e33aQTy
 rbclPmwFYfdOvFBihissPxsOjpvPbmYCkH3KeN1FPoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio->private != NULL indicates a folio carries private data, replacing
PG_private. All PG_private users are converted. Remove PG_private and
reserve the space as PG_folio for future use. Unused PG_private functions
are removed too.

Assisted-by: LLM
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <baoquan.he@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: David Hildenbrand <david@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: kexec@lists.infradead.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
---
 include/linux/page-flags.h     | 19 ++-----------------
 include/trace/events/mmflags.h |  2 +-
 kernel/vmcore_info.c           |  1 -
 3 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 08988877331ba..10f4ad075ea48 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -44,10 +44,6 @@
  * Consequently, PG_reserved for a page mapped into user space can indicate
  * the zero page, the vDSO, MMIO pages or device memory.
  *
- * The PG_private bitflag is set on pagecache pages if they contain filesystem
- * specific data (which is normally at page->private). It can be used by
- * private allocations for its own usage.
- *
  * During initiation of disk I/O, PG_locked is set. This bit is set before I/O
  * and cleared when writeback _starts_ or when read _completes_. PG_writeback
  * is set before writeback starts and cleared when it finishes.
@@ -105,7 +101,7 @@ enum pageflags {
 	PG_owner_2,		/* Owner use. If pagecache, fs may use */
 	PG_arch_1,
 	PG_reserved,
-	PG_private,		/* If pagecache, has fs-private data */
+	PG_folio,		/* Do not use: reserved for folio identification */
 	PG_private_2,		/* If pagecache, has fs aux data */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
@@ -575,7 +571,7 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
- * - PG_private and PG_private_2 cause release_folio() and co to be invoked
+ * - folio->private and PG_private_2 cause release_folio() and co to be invoked
  */
 
 static __always_inline bool folio_test_private(const struct folio *folio)
@@ -583,17 +579,6 @@ static __always_inline bool folio_test_private(const struct folio *folio)
 	return folio->private;
 }
 
-static __always_inline int PagePrivate(const struct page *page)
-{
-	return !!page->private;
-}
-
-/* no-ops during transition */
-static __always_inline void folio_set_private(struct folio *folio) { }
-static __always_inline void folio_clear_private(struct folio *folio) { }
-static __always_inline void SetPagePrivate(struct page *page) { }
-static __always_inline void ClearPagePrivate(struct page *page) { }
-
 FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
 
 /* owner_2 can be set on tail pages for anon memory */
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index ef9aa388b84f7..3c153b3ad8450 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -144,7 +144,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 	DEF_PAGEFLAG_NAME(owner_2),					\
 	DEF_PAGEFLAG_NAME(arch_1),					\
 	DEF_PAGEFLAG_NAME(reserved),					\
-	DEF_PAGEFLAG_NAME(private),					\
+	DEF_PAGEFLAG_NAME(folio),					\
 	DEF_PAGEFLAG_NAME(private_2),					\
 	DEF_PAGEFLAG_NAME(writeback),					\
 	DEF_PAGEFLAG_NAME(head),					\
diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index 8614430ca212a..5a417f8a922ab 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -216,7 +216,6 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 	VMCOREINFO_NUMBER(PG_lru);
-	VMCOREINFO_NUMBER(PG_private);
 	VMCOREINFO_NUMBER(PG_swapcache);
 	VMCOREINFO_NUMBER(PG_swapbacked);
 #define PAGE_SLAB_MAPCOUNT_VALUE	(PGTY_slab << 24)

-- 
2.53.0


