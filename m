Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B789CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 13:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38AA46B0005; Sun, 17 May 2026 09:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B716B0088; Sun, 17 May 2026 09:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202BE6B008C; Sun, 17 May 2026 09:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4AB6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 09:55:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA920160F36
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:55:08 +0000 (UTC)
X-FDA: 84777058296.11.30E76B1
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010007.outbound.protection.outlook.com [52.101.193.7])
	by imf22.hostedemail.com (Postfix) with ESMTP id DA848C0009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:55:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lDuhaQnH;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779026106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKNKtL3UsTtfMpD+PllYtLxH4Y/lMS/CoXTKFuJOX44=;
	b=yvW+K7Z4cd6IZ8FI+yZSp0yA2hGE00V1Te4puTtVuLHbkbZC1naXiZIdXt4hBQKXfDsb+A
	ggPRYd/iTlRZ9JFg8o934Mh2zDdZ1MEDRrK5ynhDFmF6ktthFpBvJRI7LeYtY5knPXp8Xm
	2HHJzqYphV24oxHGJaAzCDrVr0jZWm4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lDuhaQnH;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779026106; a=rsa-sha256;
	cv=fail;
	b=zHUBybgHPRWzX52wqtyC/EccpPMRA5nYKbnKNFFJArSrtV7yG0/u2QFBFXWEci+VL7jqzV
	81psWyWJM/qwrrG1uRhUkr4VFdveiviCEY4L1lZTJk8QM0vGwFTIV2PFC6r8vSRhW1Qdey
	peAbpbwcZujewhc9iPCIFju99AoGKkc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RyxLeKbhXNgqqNd4QQiRYhApl1IINR7ywd4R0KfgIGreyXsexpI4dvfLWfGIEiaIcwk9nl3nh0Bi1pR+pOshnwUTZCTm/xUNBAe6ZvMdys1KjSMPHWwgj5Rskx1+kPZf8BgiRnZsBpb0C1OgEoi+UBiCR2geHBPC+1ZEe+IIDU6DVD5iT7+4OrPqAXqHIEUZRyucBAzDszec5Mkk15w7lNprKN0X/dlgFQycTo2NaacMG6lg+5goQzN4cebQ874/Nsc0WswMvFgpi76mRqS4V0ADhS8QV3yvFtZ3F7c5OBGOCNyb//s0pSY19BIG/M/9A52G4KultZc6VXHapDz/TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKNKtL3UsTtfMpD+PllYtLxH4Y/lMS/CoXTKFuJOX44=;
 b=fxC7dUYIkfb9tda+qxBBaXT7oDdQ6MYqDRlWo1W2qqE6pOT+/eCzkUwLeHmc9cwY2Qll9Rr2CHJXc6/K8y7Q/xWb/xx4c3hFBE8VTmHFEn6LxTr+CvTTIeSi9TSIgrYlVCwCf7A0JpK0i6kHFgUJutWeCoKxRCpGftlpfKxi7uUExyQIbuUy75NTidBShe31yX5kFOi93u4jfYeX6qFMWsqWWSRkcKD10JGa6jF3sREsB2xvq/m7WUdmbX0vo9weyEVmvfA4wb5endRSkQMcxV81cQXuVzZPUUOzOzAT4mAz87TOZT2FSyaFD+3UGUYmk4hWfhZ/zarEvK19/kC/8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKNKtL3UsTtfMpD+PllYtLxH4Y/lMS/CoXTKFuJOX44=;
 b=lDuhaQnHtpQU07OXpoIvddC/R0dU+lqpjA9pudz6isHtJOmxXnUxPMc7vHF2TWuu3jbE3V9ItrW2IvjMrIZP5TQ674p8JQ/S/Z7s8DrRU14UHljsPLiI/7AIhrqpylBsSBwDniMx1+jSVeL1h0Aw2thhQOHSJir52+yEBZ50011IxXP26wUFm0a7yL+35wueqaK5Ltm8h3B1tZkDCLcdBRdvGE4wbp7BqbXMoI1hBVivjz6s83tBlGXnUo3xmpwSq0bf1PJ4eiTXeF1/OYukHBc5XUC/klY+EI4JWV+yztp+pRpoU0vYYNVtKm2yR7i7dpvLZe0eKGVAxJwKjW1n7A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:01 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Liam Howlett <liam@infradead.org>
Subject: [PATCH v6 03/14] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Sun, 17 May 2026 09:54:05 -0400
Message-ID: <20260517135416.1434539-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0058.namprd13.prod.outlook.com
 (2603:10b6:610:b2::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: e43a53db-4c3a-44c7-83a7-08deb41be3db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	RrTfJ80jx0/44lfEdLpFNsjSMuoP7c5nkxFUtTltP/GwQ1KGDb+f1EONuaN+w08d80FUH9zE3+s5yVARoAS7ssKiQYgMiY5oTxHjk/mjytnVdM1e28g2Zz8DzACzkqDwT3zJd+OAFSryyNSo/ho8GqFa3hkTBNli0+XLEcuKSy0blO6PlZlgwl6Y0q2R6xuL2vvgG47BYWqR5wfCcnlsESV6L/w6w3IbG6zKOaao2RtAwpwlECLRSIg7w55lBoQSOv2HgqO3386KgTBSFLIYEFMoJvswMJrhdMJTmvDaRQB3qqVwWxog7/2FEF1ecgcUk1XDGaRLM0BR69dMy9VGPbFgiBzYuzmsJ41le24MpXea1PnGIANEBJxvTxsqxzA6oQZ0mLGVe25dAQE5oCY3omaBHg9nhftVJWYHNA9S7f18jIyLm3RbvrCTMTpLFNVSdiHL2cN38PCsEZcgmbw261QYUfh71LxIA/vwZs68jOQ2wVyOrzJVuFTFwCCF/uf2ItYCKUgoVakoG/nypW4h+daSrpJFaOF320ZJXbO6mSsL3yeBhD182sbpwCgVaifXHanaMffm+LIeNdh6u8IjyQxzF1oslmXWxJwRNphfWE5l90I/I5tpL7hO5Zg0lnczgKuy4KOmI9jsGjq3157MmS3VIu8UVjg12d85klk5B5CyX3l1ZEHIWUzmpJo3s4UM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IAsJCrOhgkAU8XMRhyISmI8i7k9uLoD9WPaXI4I7hKgChaCJufx45VDdzMXX?=
 =?us-ascii?Q?wRCLI6xBijSIzoteAc7CcMmie4vaWMZbXaz4S5BX3E08/N+gxR4CF1mFrkA2?=
 =?us-ascii?Q?nqy/HqeBENU9az8bkzg1iqlX2a2DPJgltAQSWf7FerpZ6tubNR66aIekzaLD?=
 =?us-ascii?Q?SA1zVGN1DkdaLaBIJ4YJ+lztN8cSRuuDju8oMT81iEQD3q6sTziwzWIgVgog?=
 =?us-ascii?Q?tip6DGAydYtkgdr8vfjCxRRKo46vVwCYdMdAN0spcQGp4NxkyOUJO9GbJoHA?=
 =?us-ascii?Q?SrzCvZVPe+hy5DKr0hWLD7IjTrQXSyVwCN+iqLUEsit5TV7yiZy0D4RkhlbI?=
 =?us-ascii?Q?l65MLaDN6LUuATlrjS2KaeY+fqKk8749tbxMY4pefUqmKMmr5s6wR7IxGQEY?=
 =?us-ascii?Q?dKJF0ZWzWII1Rr3pThMONKt1pNFNbLkdTuLLv1UJjgYTJ1fbQITTzNpJJK+T?=
 =?us-ascii?Q?6QhAsXNNjp21LVChDCuXwlFayi5cT5xO35DKxzOoWwo8UKbW7zimDy6IgrMp?=
 =?us-ascii?Q?NJiiTcwkHrxTzIsv7/4Fwn2FiAelLxjYJLTe0AlyaEjfZ/1rXtrfM8F2NspK?=
 =?us-ascii?Q?XPlCSO+hhSYSz+UPDfk5WiE3MPXa0NcQ5riFc31mBc1RJqPpVrvXPSZtp2ps?=
 =?us-ascii?Q?o7uZIJTUv8kee0tDnoeqcTAG4dJKbPRRXTNNDnQZyX5NUtTuwTS8Z0fQlb+9?=
 =?us-ascii?Q?cwWGDobzFaRPz6iaiKsFyAIVH/WffV4dhloBzsAysy02Mu9pWSqM/rlUbw9i?=
 =?us-ascii?Q?zNtzj5NOv9i1seI40prq06KGZG8yzp/GLnQtvzskmEvKHDM9qwH0dnXI+z5L?=
 =?us-ascii?Q?Fetz9DyGS5huWT9JkRLAxcGZXRolXAIO+6Pk4YR2U/cFWhYeIFgh+C0/kKVf?=
 =?us-ascii?Q?e8ENRjKXL70vWade37YB6Di9Q8rFETBsve2xC7k5oAOAbRzWEmzn1PQAkuCg?=
 =?us-ascii?Q?bEPFFA/ppA5lX2MGg7dEovjrQ3JBP7Vr9GHyeCLdATnviCFazLx2iyC9hpo9?=
 =?us-ascii?Q?cTXLIth4+5n83xSL3t9PM/Tzu+sf2opM9LJm6oa4bjJoDipztfqm/k3IRF33?=
 =?us-ascii?Q?f1MiFdMb7aWCFIXMO/WXzGm5fa9rngFw5jbekGymjNFS5uXjO6HdOOpD9Eqj?=
 =?us-ascii?Q?bxTwgHMuBMruHP+Bgg1k/q1hBCK9KqA0B7mwVdxcnTG7pz/1XwKf1POrpV6f?=
 =?us-ascii?Q?pWhBxF9nD+F0Qi1uE81MB4e5zoY3KwnNbUR36o/Ous0WG3bLg7MsZwM0qqDz?=
 =?us-ascii?Q?tOzkP8OTRrRE1MldCbrLk4lDT2IvVQ6DSG/FstN6KAj/AyCTtrqvIpisW0Lf?=
 =?us-ascii?Q?Scourz12UWy8jUlKatKeSTruA45I8SCpUK9EmFAMh6eR0WGwYIoXxUGdnPTZ?=
 =?us-ascii?Q?JYWnlVXURYmq1FVARrthuSLcIPXf4jni9XksAuRIe4zeuIDeUwha8zA52TDk?=
 =?us-ascii?Q?BkhQUmaTrVbxxEWulIxR7vFdjUTOn0biZ3t0DBOuGTN+sxg/U455QtmEZFny?=
 =?us-ascii?Q?dZNkHwYgkNzMF2+9Kzs3d+qR6cZ13z2kLWdzZ9JYuwhq34w7Crv6dNKXtdKb?=
 =?us-ascii?Q?Lu8sK3jkp/S7jHuhyj4gYpYFp8MWtyG9MLIYgYqLRu3PR2k1JOxQm/9qkNKF?=
 =?us-ascii?Q?NWwFon5P4DfmpAkI2rloS0UVwPAH6VvCrsYx3+YZ4TTGVjtG3VBM8TPIxaW0?=
 =?us-ascii?Q?II8/2MU7hB0Z7e+SMUuak/55qzplZW0pyM9nhoDeJL1XQQ0J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e43a53db-4c3a-44c7-83a7-08deb41be3db
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:01.4437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OfjzyRx3qbXGpv51JB+0Y+rvpidCvEZXwagiVhU2qrCDCCsa5KVFsDo72K8cCJe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322
X-Rspam-User: 
X-Rspamd-Queue-Id: DA848C0009
X-Rspamd-Server: rspam06
X-Stat-Signature: xf61gtoyucayz63iubido4fejytscqj4
X-HE-Tag: 1779026105-69109
X-HE-Meta: U2FsdGVkX181iSytOBihBgP/x8+eBWvpiNqC7QU0A8QvN7KhnliJev3eolVOe0lv0hfDQm+Lq4jpvphFyylb2I3OWhGnI2S4CnQVRHAUbMDhiewksVcC7gS3DT6tLQhSgfz2BpC546MKrlwKLLYLSgk7FWNAx+USsGPWow+aEIzk8o5sYlOGoCnylC4mu2+Anyn0oXLO+HftHXjnIBSfGG5WMNRhKb+sVbc/BphRgM6K3/kuzZNlGktgK7Kg1ihkH+gdkyaTu5WsP7rAKBYW9gnYyFnSFzx7mLMkeh3nPrJ7LRQ6Sa+jsjkWWw6yZAEaw1Hn+IiMCsUYtUxYfLbte1PwUm/rrDffVaXMS90/JmqgncddR+KcyTk2WOSp4ywebUnle1Lm6NHorDnA/xfF2Kv5rWRlSAe2XQWBkLQRFwxObuzC1Zqg/JG/SNqD/ADThWm3zzjKn3+AAzLOHfpHdG542+d7cYkOOIQPwDivyfUE2hN/O1i4t+flTLG3Uw/zjsJCqfJQRM2iMuJyVWW25ptuM9zvUk8a0Vk9gnYL6spdUpa8LASVbLXo+R/SwASEcB5u0UMTihUKMK4hE9GDdDIsbihZ6OTJaomGYLtgOEAI/KyO9lqODD77zoKcVqVYrnG4fk4DuhCPc+L6T2uGHf0OLvMJf/djZamvOiWUoRjeUlhxWsfGDr7tXM1DPuZBlprrdo7BCqgxBPcmx8plCx7oSfCKx4sGzda2A6pJm4bR7PHtYomQytwkjGvd8pfb9JngoTNSehfLCxP8l6RJck/zx+J87JUhgc4c5io/77MbHsl+H3EN7An8kCfLFA2HrEZggVLY9BbB0BIbrcyIiCOME0nkvPB23ZHJQ7vP08Ythu/d+dmJi9Zyh+dhSVC/ZFe0nKjk4sBgS6mYrbYbUBwAYTcV1Q7MAYAetge6Fun7FottvJSYPZE5jr0t2Doh0N1fKKycQPjvp/g5/jf
 rVU5A4qE
 8VbhL4y+rH82zPyQpwWYAWe77ZAkBM3xWWDJxrZsEy3RaGWf5oNorbvY+qS3ylS2PsYKcg9T2hQi51KMUBH/6+H4JK1bGxmB0wg3FE8kWMcqiNqyi0HfeXoABeVHY0raJUOhNHp4O4NR4rjmCNIk35/32EQQzxRcV3lS73AkYr470MVflmkfly+1Vn1d4YIJUhncXGU0LcouJgXQJVtBUazFC++SdtPCC3pp4goEhxMHsSj73T34pMY949N5LFBPan5oZ5PuVqocIFlQ+c7P56rtHpVY1Q8SHX5h67nQinM9Qx3dV+d5vVOJTYv7hlU14adWYw3eAntjiUTOUgiiGr9+mHVYRq+xsvfz/Qt8tjLtsAdPm2DnbLP9DxA5J+b5xPhiWeVKZRhvieQ91gOUp4Ze3xMOw6tYAL58qjWnPZRRTQsu8hOVJu3wZ5qCpGgi2iklExgIUkfxNJIR40tnhnVHWYVtwMA224sNAf84efX5Jsgds45Tk2D0SSnr6Ppq1pxO3nkXYXq+YMz1NW5QnAHjlQwPZ24iniEQ9W3VtuqbywG0NRV/iWnXOTk0k8GWbq9447iX5tmgenbMKPwOEpB1zIiE2Fuyb7vd1LNGB57yh7ceNy8g2OVBSW6cEITbtWjFAXtwsDjOfAzcpaGmLcXkzYu9reCNJLfQGVIf0iJZF88TlontZ3EPQBWFtikcXsV8203IQ1LHQ8BVrjTevS3JhiGYrV1bO7OL8SlT/v8/PP9OJnD/Y31/m0Dy4KYaGftUrdSopcMZFwmwNEQlILoEiU4/VPcc4uWOWWM43TfY2HX9odiOUzHTrm7V6jU6PNKdG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD folio is supported.  Keep the inode
open-for-write check, since even if collapse_file() now makes sure all
to-be-collapsed folios are clean and the created PMD file THP can be
handled by FSes properly, the filemap_flush() could perform undesirable
write back.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 mm/huge_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3e9eabc74c6c3..ccd623b9501b5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 {
 	struct inode *inode;
 
-	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return false;
-
 	if (!vma->vm_file)
 		return false;
 
@@ -97,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 	if (IS_ANON_FILE(inode))
 		return false;
 
+	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
+		return false;
+
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
-- 
2.53.0


