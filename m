Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE495D78797
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C9B76B00B9; Fri, 19 Dec 2025 11:07:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0EF6B00C0; Fri, 19 Dec 2025 11:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 058BB6B00C8; Fri, 19 Dec 2025 11:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E891C6B00B9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:07:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DD5813A7EC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:07:30 +0000 (UTC)
X-FDA: 84236700660.08.F083E3E
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013054.outbound.protection.outlook.com [40.93.196.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id C741240010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:07:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=n8W6Kmxf;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766160447; a=rsa-sha256;
	cv=pass;
	b=aqqffvVhKvs6HG2WpYV9FvPLNaFz6qTt7zb2ZnFRb6mS8S5lUbUwaJFOaw8Mgu+yvNuHy7
	HKSu2LcBLyeMcY5g6rfDTn2ZITlmROMLC9Vaxgf/9uCQkEuBNMYSXgPs4d/Je04NBCkabM
	6dKopqu0Fxm4jQPOgFn3jAfJPCwFu/U=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=n8W6Kmxf;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766160447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9CzKvJ9sgX3Ap4/YRyI9WTOIGVrGH2lo4kKKLMFp0c=;
	b=8kK2Zrg2xFNpoi1GTe5yRDDhY0JRMDXRd9XnJpQRvg9jtKk2Mwv+cByHrF6xXjVHh4wrxp
	AlPNnKwgnLxTboby8smhN7BcaGH9lHfupJNLop88yeKJzmN0W2cdG+rkyFQ2iEFcbaKKO0
	N0zF6bNMcz+odBMsBfiIvxsbKKDDyk4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pq6vYchTr4rLOnJAGYPs9uzdstBfzxu0pyBI0HR87FdWVZDQXY8R9LX8Z2f3RZuszbfoz2RHsj18689YCqLHBC+I6bCB1/mTk1wOz0bN/6wXUOFWHUNe9VI+KIJ9uIWbkhNRmBOovoFQ1tMPw5s819CQ7MEDVSsdpPk2tryRhL9CmRYfNFSGIN2Evn9EQKAjWSZoG/zvAOxdIPDm/UIwJ/ZBpLBgyGIL9snwZXloxJggNuP99IslHwPLhcyehrbsldFTX+VDYGz20UdqBzSOeX6+1yY6Zit+wyNlHDlRaJXo4ISwyl8WeHHcyi4yxZmxi49mKFrKpGhJsO9U4oIX+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9CzKvJ9sgX3Ap4/YRyI9WTOIGVrGH2lo4kKKLMFp0c=;
 b=ZMv9m8sbdwbjnw+shynNEuXoHSi31zCYO5145/QNldYZkFazlbyXnlBBcsFv3enh4j6h1P7tZAIv31NMMp4XvjQCyjHCv8GCA349NnKx0I16HMm5hNwOpImOZ/xc8035FGUZQxikMIAuYFKTJQVUHMbCesHZXc1lIET6QVd8scFQLixUOXns9lZ3GAowJN6Nv8DtNysFt0J1WbkO0zRH2rPOR/W1phMIkEyOhqVK+/g/p6/AGsSJ6wmEONRWT7d+OHytjvx/yFIPfIoc1hqoxBTXsajmBC5rP+o682N1CIm0Zf+6JbV52LXLe88RUWhBVrEdUfmEjRwfKzpKGiv8LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9CzKvJ9sgX3Ap4/YRyI9WTOIGVrGH2lo4kKKLMFp0c=;
 b=n8W6KmxfqmObVPCRh7zTIH65LcpmELivJFTIvcfh48suIkM8pZ0icg3wi+BBpBfI80wU1K5VIgtDULaR3CRqG2ViQgqx0LrD9TvkrzfSMCpTYa0b5aAIZwwZsdE1VRWw7sR2aYw6fnJ/T1LCeba80LFcjsQ8TvLIviJ+9GjXdPImSUCE8hjnYSPVGAepI96ZPo5gSOB5BW8/3by0Qn3Pch28MhfwNfwk8gtXhqHHSceGyWiqsrxxMNPo77H3RCayxU9pP+EaZUiJ1Tnz6yqTPORH9TtYDCJKJBUrdd7bSV2b+yQn86irncW+xzTKOL5vOoo8nEA9LoT3KS7LLM6Yzw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL3PR12MB6474.namprd12.prod.outlook.com (2603:10b6:208:3ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 19 Dec
 2025 16:07:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 16:07:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
 "Garg, Shivank" <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/khugepaged: remove unnecessary goto 'skip' label
Date: Fri, 19 Dec 2025 11:07:21 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <769AFEE9-3E8B-4FF6-B40C-AF811D6118D4@nvidia.com>
In-Reply-To: <20251219-flying-congenial-harrier-a7e4f5@lemur>
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-4-shivankg@amd.com>
 <848E8F85-CD24-491C-8A3B-474E4FCBF995@nvidia.com>
 <32f3f9dd-f84c-4113-b356-01750b2af80a@amd.com>
 <20251219-flying-congenial-harrier-a7e4f5@lemur>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0399.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL3PR12MB6474:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ba471fa-8555-4f59-be8b-08de3f18b244
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2Qb5LnU2i75Rbiza9LazuKwDqiomkc3o4p35pvSIqgdvCU3USVMJVaA4LWW0?=
 =?us-ascii?Q?7KTOkV54eM07dg7kfUKIygwvOKryop5UcxfqOQ9AK8m6v+gzY59NYTEWYpfK?=
 =?us-ascii?Q?04N6hiiOzxsU3VrzhkPWIvST3/2+0hcOyNdMe5SUFpJ4v9mB79ASyPfmVect?=
 =?us-ascii?Q?dMUfU2MRtYGi9gyVPLKgJH4SbWcGo6V2JXBjMkqzd7MjHntu4vqpGHxQSa8A?=
 =?us-ascii?Q?XjTsA70dq9+S44oCNsywpzeXjY3ukpzLZ8lX5B9WNmvR0aPBqOBk72aJaTyi?=
 =?us-ascii?Q?0W2FNP4i2egXpd4YNRWzp6aCfwpQ8iu7plkH6dpMMRRHoHQGw+Rsuvgdwq16?=
 =?us-ascii?Q?JBMXVXoh4FG5yClX1MIJa+j7j8Vv/NucJMKagGfs5Rj8WgJPJ+JPjozarNjj?=
 =?us-ascii?Q?regrzMBp7hMPsXgcHCgLJJ0Y6a+aogLKtSu+Wj0xgXb8gsyE+jvQeCaMHBCk?=
 =?us-ascii?Q?YhGgKb9OWSm9hlLBqSurdX1zCyZ5ZmbiWiPepvvHFtV2KkEcfwvuU+fseYGB?=
 =?us-ascii?Q?g2iId6iAzQhTqf9324NG1QkycKg0wV7o4rVhdlARS8r4SNrQlrR2U6VtPPN3?=
 =?us-ascii?Q?Gi/iFSUR+rA9tXxJMhG8hVhw6rolLwIYFFoWPQqj9QXNMPOdRI4dCLQB/Tig?=
 =?us-ascii?Q?ZE3wiBmRvdD64aAnP0ryWqMOSZNMIAAGuRybpVTRVO9t9NakWi+kIx4a4LgU?=
 =?us-ascii?Q?m+/QuyWn8I0F6NMyEBAs56a6xbb/wRx2zYnoCoH0bs5hUIb29yXr5fJMl16C?=
 =?us-ascii?Q?3V4RpkPOmcl5UWOxADpQX2aGcvi2457IADwB6QyVgjlPyfphKs/FpTkD78S8?=
 =?us-ascii?Q?0NIoegE9trISZ53ougGTxdbTEvvUQ9k3ToXzn++WMit0C9Lze7tEMjQrMEGd?=
 =?us-ascii?Q?V2VxylPwPnJFbdNE7VM1m+EGBd/UvfbcViJm4pnGQClWvlHGskbNNWkfxpqF?=
 =?us-ascii?Q?EMaKyUVli7223+TmZanePA2tEZu92p/OIcBQac9faxbF2h9qy5UbbslrmkHC?=
 =?us-ascii?Q?Ev9Nlb7bfUZLvgs4b2DTfoDlk+XKnWrtdoLOzFh7BdEOyIiRHdXnDYqGAh86?=
 =?us-ascii?Q?7sxshLWmYXVhThA/YrwEmAYnSiLZ0E/C70C2O+qg34aIrp5969wspi4ma6sd?=
 =?us-ascii?Q?4Exfy2PD01x7iNGnloJfo2D0yMJ+9Cm6jL5hnj+NNA/fVf8WRIjOceZR1YWP?=
 =?us-ascii?Q?9Ry+BBYfsUFOZU/C5uAjMAMBKX9H80wlH0cNh1QnYWj3KGhe3rTcUbrOPEon?=
 =?us-ascii?Q?lfIXb1wUKIH/owp6ZSszO2H26X1xHZA0RzOfgT12XVlaB2SEX817n9+w5ONj?=
 =?us-ascii?Q?76LvrSDkEx/4laBPhC161KUVBJst8ibNyrIX2VnIS1NM2wuhnSUn8vnUnMpp?=
 =?us-ascii?Q?kEDQij6oHwn3EH8YVxfLJ91T8+O4cIjaPIyeVwy6u5UOxAGLxKqcevg1syxR?=
 =?us-ascii?Q?jMxjEj8paLr8woL9QPIZ4itG2MGPY/o3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W31pXtdXkzRzLW0B7gJtMzTIwOZleKSV/3E/yQidlRNliXCvflBq0HrDz4m9?=
 =?us-ascii?Q?ItNtxUhVXDdeKpS2MIdwmsgAkK8QEL/XeURQG9gYqgxXyuO3ra3QsxaHttzc?=
 =?us-ascii?Q?YPNDFTd4iR6XaWVPr5sfn2ugNbe+WMNPawZfzWebEYopjgUWHr1macyqLraE?=
 =?us-ascii?Q?oXet4GaQW6IgqcPlcjm0V/EwjGK0ACIlmrI9NDUyqswlk1v8Z+Vmkjqo5S1M?=
 =?us-ascii?Q?NglYj6F9CUuoXOOU6Uan1qgyOrb2DnIc9e9qLFwBbq6u5tlRYOnX50sWULfF?=
 =?us-ascii?Q?GjsFFG6xKOk5gsc3sH1l5GYKbTAeqyHfzq2BmuwKyvYQ5nNYOH5gvCZRJRwW?=
 =?us-ascii?Q?59tL9Gk5fVZaXJXVGu4D0FiEj4S3H7yz+OWG7Bm+JgKT7gyJpZ9e8w1MZ8Qt?=
 =?us-ascii?Q?Qv8s5Ts2dFUgMR6AUdTL38TCcfDFg9ab6iKgCFAU27xbp3XwcETd6uvoCI1/?=
 =?us-ascii?Q?xTcXk7CwwTgsPkmJ0kY3UzejXQLWMnYheASRTFXJkKbeFxPZK1o7kscdbfbX?=
 =?us-ascii?Q?2ddVhilimU6kKyp9hSGt/FYmj4EV5nbvPCPy3t9y979k5ocUIPcxkgKEKfuA?=
 =?us-ascii?Q?e+kjiurWlHFNelC1XYOErnnEGqrZ1v9aHjMGaBk4aLox/2UgzhnI8QHkEjK6?=
 =?us-ascii?Q?KUuV+2vwUlzLXQFERdHzH1c0N0J9oNg3reKP0BuZuUqXKA+qID1CMe86rh7d?=
 =?us-ascii?Q?VQEfPDKeZVJn9hyR+NROfXpOedMqBd+ww9VhYNAA6nvIR68LehD5Ct0yo6gN?=
 =?us-ascii?Q?4f3C6vqRJaZGhyqrXaLALfl1vEwpmJGw7O9ta4Ic/cVcwesVUFmZnooDzVKV?=
 =?us-ascii?Q?y3+XGjh4Qh5xdvkcySAcxeHZcDOrMHKodgUbUswd1DDqYo9Y0UmIDNBnS+b7?=
 =?us-ascii?Q?vHSABcXmE+tLARfl0UvKxJVFIqHlyuEtVv2erEhHrplOIjn6uvUMG5lJtnza?=
 =?us-ascii?Q?izNcVpZnGLbTCSe6pI6rgtTuwEsLiKbEoQJ9AHKq+xY+j+rprGZgD/M5fWq/?=
 =?us-ascii?Q?AacJ8NCD49hfrwwS3eGCAdMWKwbAI5YPAThlq4gFZNe0H/5R+ExItZFXFM9c?=
 =?us-ascii?Q?Nt7bKDI3hh4c+CBklHrgEPq2S+lhCKLy/Y0oEfIrRLOfCBo94D9L7fr1xzGj?=
 =?us-ascii?Q?tkyKEAR+spmgOpHwAd6KDVB7IMzqzfKq0gUPYolArDObFfMIKMBWEDoCRDaZ?=
 =?us-ascii?Q?p2re1zp8AFM+NFV9J9zwTNqpwc2oOg0vbkWKxTzP5fXSAk5tSfmhAYQQ01QC?=
 =?us-ascii?Q?SgFj42/J8MpREU87nut70d5qFBhX6f4c/yBUDxe3TEd2Eb9bqYEYj4oRp3TF?=
 =?us-ascii?Q?6M6RlU05iB9Diq2oH5g9fjcWSP9ve1SO4PZ0R4MI88Sq0fPMGiwClaArpx7c?=
 =?us-ascii?Q?pyf2fPkU80ynt1vASdYqXR3JhjuAR/xH92CQFICdtW4NqEN7+KnHjNxX+z8o?=
 =?us-ascii?Q?b7wM3imrk38YS4BkcBLaKvAPf8+tZqkZC93S0jwsC67os7GqEehVdE361r68?=
 =?us-ascii?Q?6OubDSXoZvHDEGLSO7yl9ZUh48e8PvhewqpcINPiHvxbkOFrwLN31cnhVKMh?=
 =?us-ascii?Q?lZOZW5y3n0uJdADLyl0a/31qK/pBxCMeFeq49rgd8MZLsN4VeftoiGy7mNea?=
 =?us-ascii?Q?SvtKCq632DSWxIOh3HBBgAkglqc+4S5ATvlIh7yZB1dwroWvCLzR9Dm/NZRn?=
 =?us-ascii?Q?1Ptxq7aTqZZXdsCc7mUtf8QurGth+lIi/l8+PWGu64fNO9yz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba471fa-8555-4f59-be8b-08de3f18b244
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:07:23.6943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 75eJbovlhRTKCYuzMtZLEC1mNGEJPrmX0I7SikQPbZDkCYbtqPXHX07q5obBFx1N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6474
X-Rspam-User: 
X-Rspamd-Queue-Id: C741240010
X-Rspamd-Server: rspam10
X-Stat-Signature: 7bumcbdsankgyewn8yxi7sf4cr8m9tdf
X-HE-Tag: 1766160447-228566
X-HE-Meta: U2FsdGVkX1+A9kZkJjAtEoZGr/T2nPEdsH3OI1eMg5CuKFK0f0XdOM8fILChpiZTVty4rI1ntbwbz78NgsG+Tly25hsslFMLX9WwLubs7cb9gdXOljBK0bp7ddItTVr8jrLjSEkRePTnB2IUsEwemEQ+li0PujfPOASTXlr8CwjPOHptvamqrdBwHNJFrd5Tvso45rP6F3ICPCQ6clUGf5RUyFyocQBL4l2/MwVRDijhrzKvh2tbU4YN4+cYBHiRe9H5Tx7gjl8KuYTccoDcPDIKvuyIFzRRp46uKY8nmeFua2ezsBI2BTQ8qwoN7R+fYHoF3EzQBWjuUoWMbfd5zxcxHQ5WNoinfEx8+dF3E3/N2hgE2h0O2PjrsLygFV/v9XTVWCdzVx4SZMHgym1WzjO6tID6A7XiwwRKHInxN/1H9HDArwDTMUJBaXFxt1yMq0/VGdrh/GWp7X8Ip+cEs6EZNJnVPuOZxSwf7ZnN3Mxlkg0MCPaAIJCUzyPvF1OhcIZ5ZfeHiPjEBq58NNLJdQZO8ZXPb8zKFtS6NkAInf4qRHC2bMc709KYPxdxnhPtYpJA5kSS5Sho9fnSshMcl7jk6+vzBDsyKYzE/Tj5xzHLiWUbM8PMMzyx8CN08pQ6LP/D6q1ti7CpTrpOyhdsEsS2ph9aG1uET+nMNmIyzXl8g0QsdK+Co8zXDlLgJynghS1TKTvJt02Q/JL1OHhxOE0HR/cN6YShiR9E29THzXHc38Y7ffY1RYgLjSz0WpUJSaQ9PDop1wM/zvFUq1KMQCsqLDZR/8cVVs7wzxxW3+wN/KUsu1roduc9qn+M54XdsIt5oLMkdcFG0lLtn3zV9N/JHQJ4Fbpwk27o9tz0H0icBIz+xijDM1LQfrI1GcEd5mws+/42a7UhtDxcOIHPlqHYSskkSjNJY6dLFvma0OLlL6tq2xlUs+O7G3QuGgF0apRHkgWrAPgcubYxhPY
 MJyCMR/f
 2llarUa8B3HV+kUejItO+r6q+ofazzXvxqHDP8IkgU5GzWSLci0P8a+IuIm7pji9WSef1KTXWRpJl8eg0Z5kGRP0msrRhkF7bN/2c+pPArF2Q4yWEI4V+Km0cVSxpOjZzp0irKMnfGkKLEQcUpeLasGokBVaJdzbWpV12Y5q+NrNGQXzWbsRwEQaRKfTryVplAwrk2G7bD3X6G1Zwuk2mu9Wzc84PclBsDZXolmasgeZNtp689BCHUYyVlvBvBoYYkSSIMSeldb/tyPx0nBtXpwXceOldB/+loQNf6ayXDZwKnwG2Oq1mA949R0gcTmutXjr6DOIgkkd9Wus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Dec 2025, at 11:00, Konstantin Ryabitsev wrote:

> On Fri, Dec 19, 2025 at 05:50:39PM +0530, Garg, Shivank wrote:
>> I noticed that b4 didn't pick up your Reviewed-by tag automatically (possibly because
>> it was on the same line as "LGTM.").
>
> That is correct -- code review trailers must always be on a separate line for
> any tooling to properly recognize them.

Got it. Will do that from now on. Thank you both for pointing this out.

Best Regards,
Yan, Zi

