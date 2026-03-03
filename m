Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71405EDA694
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17276B00B6; Tue,  3 Mar 2026 11:31:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE9E6B00B7; Tue,  3 Mar 2026 11:31:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF13F6B00B8; Tue,  3 Mar 2026 11:31:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFE516B00B6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:31:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B2D1579EF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:31:51 +0000 (UTC)
X-FDA: 84505293222.06.9E988FF
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	by imf28.hostedemail.com (Postfix) with ESMTP id 84126C0007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:31:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MtFBb+O1;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772555508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVjK5SINOhgOlrRRjppNtwlxFvqzetymBkRsuXH636Y=;
	b=Hs2TXZOA+wt+g3RF7yEjE+pM78po/xgNMHagwgSDN1BjeWD5WGyEokfHbG+KMBhrMM1lp0
	QPm5CyeZGRY0Ab3jJ610ERDcCb/GL8rIIVFz1lNVsmWDYMXBPn1pKQqTEfiJgOrG04vUcn
	1JgeSWmadfHH0K9TvQhWfIdMO55NQQ0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772555508; a=rsa-sha256;
	cv=pass;
	b=gfnlpjCvG44g+KfG/jTOwlbvwVPyp5+3oepfCZnF4sIRmzQXAlScJf88n+x/uXR+My+0EK
	d3cHoLghhprpS42Sff93lAClvULAbYAg3YA7nZEkpbLtgi+c+PWEBiMNwTHNIeYPIdezr2
	aYqmmeyozu80ca3JH/jRKSlLt74xJkg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MtFBb+O1;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m9sWlA5SOTtIDaNXa6weJEYwlqO8fZTbzhhVJH/z+sENKSBTy0a98yKZABQuHkvDZHuENnjbf2m/LKQAVw/4JgYYlkbuxMXjx90wkAcaMY9tzSWGT25F7lNqV3/ve6hLQhRYTJCJ7mEMpFQHC81Sy/PTYB7gMLCaXpLa/DepHkeCgI/MmU+oukL5X6ooATiQDg2VSjhwXmvcnQXoZSBAD6L3VOGv8TxD8c0NGb4IiSVo1MkpnEQ4QSkIfu8Z5BjSrDY4jEz4Sw+2d/qB1Tnrnw6nVF11MfaJDJv950TX7xB5YMewLnDoFVQjEeVQmwhOxojMeDRFbgJsEWKC+WfOBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVjK5SINOhgOlrRRjppNtwlxFvqzetymBkRsuXH636Y=;
 b=KRjhtsdw6ccd1mGXXbgQmbt6nOJ1SOAsY+HLh9YQbazqOaDhJOF6hi+olY7FfKb5ZYoQ3XM/+2SGe5NMpPZLTrTSpg69LlzCL0vr8IvaWZZ7b2TtlM+EV+ekEh+PafiaDds7tjfDvEmtzAzMYwlmWpZuOox+MgGJ3YBEvFdMHotFblnj0VBtYHZj/J1g16TH0s64edwEXVvrL0g+xPZGeYKovTFXQ6iRddY02FxBULeTbTiRmHzjuJZGUFb8F/2/IdqNHz/hXvi+oGjelarFjok1QFK0WAGshhO+Qw2TWS6E3rDL818UP4+6iv9xa70k5LIns4hFJLmnmYPCZV21nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVjK5SINOhgOlrRRjppNtwlxFvqzetymBkRsuXH636Y=;
 b=MtFBb+O1CyaduX9NO30+occ3gLxWRCtpPEWisWbyuOf0I+PQjiamjH/c1WFen1h5EmuSSuCfdiVbiMT3ueHTTFQeiv4UUSuwlugoJxPhUhHw042fobaSB1OTPrU49HRB5r7MzFQCkfmonNVq1iSApKKNttfjhpcvPv/PcOm7l10I9eYHJBpIIrNMqnH+2ERfaqeq4Dm8S/76V0LHfvRWMa1mx5ldJTKk5e4i/qfqw1XgxMp8XLYTs6rLxvbbAA+8It5UrtJSJjyRVFt884QUTQu9eLGgS602Icv1YZwtogtjRu+j7bAamykBg8VgpOvxMBkdJkpHLbFtLHF6bPoYjw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA3PR12MB7830.namprd12.prod.outlook.com (2603:10b6:806:315::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 16:31:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.020; Tue, 3 Mar 2026
 16:31:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/huge_memory: fix a folio_split() race condition
 with folio_try_get()
Date: Tue, 03 Mar 2026 11:31:31 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <5C9FA053-A4C6-4615-BE05-74E47A6462B3@nvidia.com>
In-Reply-To: <56a23a23-cbed-4ace-acef-3ada41bc182d@kernel.org>
References: <20260302203159.3208341-1-ziy@nvidia.com>
 <56a23a23-cbed-4ace-acef-3ada41bc182d@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:208:335::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA3PR12MB7830:EE_
X-MS-Office365-Filtering-Correlation-Id: aa44f576-f003-4feb-d7d8-08de79425654
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	q8iqYuhY2IQlIH5Tl1qFxMz1IwvsrualH5290e6V/FuJUiNI2lk4HoowE06Q5Lb4ewhrEKSVIrtCLC88a9nDVVAUX5xYrHa0GTedmnwem+tCJNrwcVMeMNSk/Juj/f3VW2z9vqcVUa7fpcMFZy6+82vNBmwrGrfd2LyJzocYjqPsZT+ymVUybpE7YhQL8tK4Hf1p7t38226nOQlsC4pzP0KhabriFtO32N8XJpYlPp1xK3jOL2tSecmPbTRuygnBpvr2VarUI8Ci5ifQFXY66kAf6DWEyiP1BO0quy3yqwZUWijk/QJAslqFvuOyrp7d4MX+5mkM6xevcMJAG7ysEMLAmMEfjXHjh83hYmL++z3QhnUQSFTbG9FKjbB8919/7xsQVkgAVwFFAfGBoac/Em6/KTT4hncNodNnL/WC6tFetF7wzqDrRKb5/0Ku8Z/MdXwUBOAT6ENUlnRptascR1DuTSYv/3CDHtTd8v+3pkFEkBkGgH8bFtDqKOunchJyDIKzY7/FN4MrM3TCjhfXbKOHPoXEh/aavuhcrHbRShoptYoNJeqY7L8Sywwfkblict5xCF2U9IkLPwXXXU//IzIC8uJ7Q95eCBh5pmDkv1+Mg/gEvjkQat/FjbLP4TFvCQliNFjspJ9US6nb23/3V72XSU2eRxfY3sKGM962mnNTejU/cEXRzjFcAq48J4vAiEc0UJiF0zUFfpGZUImGQGGnDdiP5HpzmPuz+mA1+/8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dg1JaRNcMYqac3Kz+JPPnFaeecbH1mPUH0OSPRHDqJBMBbGHaSaX03XucQba?=
 =?us-ascii?Q?cnVKRpcbVYaGweBW4wWnhpUo3PA6RBm6CreIyWIAhoHTcVuMRKjhfoUBdbvB?=
 =?us-ascii?Q?wPIqnMX9yWOIUf+i5L5tUheTGTFrQmzz5zQHwPy1II3DTbCEAS0Giqe23W/F?=
 =?us-ascii?Q?+ZmYvQmAn0Ut8seQ8ca7EMpUR1P//q2gtbY6msH34AMcGl2tOMJdF/vDWuK+?=
 =?us-ascii?Q?vMu0H2qlu+Gl/QYfR/KJp13dNj0nSzZu5MCt6CbkJAsozvsBR3oskXRxM+Il?=
 =?us-ascii?Q?ZHZt3yRjLxRTctKTFA6OJY9Z50cfJUN0Hd8Qp7dfM7lizl5fhMc3zD6CTfSm?=
 =?us-ascii?Q?jDU4Du0zkxVEUPuZC3PCFphRTfqb7nZ5tQ1z99blAPuDjsFh6OZxylIXdicS?=
 =?us-ascii?Q?GZaF41XVT3iLEKNaMHlw2dD7AicpHm+E9bzOTi2rRH3E8MLn6G+JY6EJsfmr?=
 =?us-ascii?Q?a0vHiNBYRFoPcZKWud3EraQJDxTNmAR61d/fKLb1u1nz0E/66V75DZeMDoDo?=
 =?us-ascii?Q?Rin58g4r6FQMAV5/NBxUPRum9q+Tsm4IVgWCQMLQs8rfsppoIdzhritQ8Dpv?=
 =?us-ascii?Q?d0WzXyZBxMoGtWOey9AA2k+NnB/SB1HnSlUs8kK4BSy40Nthem5/UbbaxfBv?=
 =?us-ascii?Q?IIxQbixVfz0mqd5/ePM62RsX2omMqd4P3FlvBOmMrwq6XR7GR7AvuYDi1UDD?=
 =?us-ascii?Q?WpGvn7D5u5f7n9XQxXx5C2v7rlfN5j8hX3HyTT150/gHnAEzEjD88uJdjuyz?=
 =?us-ascii?Q?W6uwiPBidJmvJgY52rpyoPSwoJ5X+FDFruyF2T/V4S9Re/U9LMzDBdnLuHPe?=
 =?us-ascii?Q?Z38ZFeCvUC8ILP8Y9yU2O0QHN0omUWOWR1ibgl4fw925MQ+4Mne37XrjvQaH?=
 =?us-ascii?Q?BRwQ+gr6mjxbDSVZTyCyeLGMULEuf4NtENE+B4OAZF+nClh+RxB+p1R+5YP2?=
 =?us-ascii?Q?uthIO+bZ5SUhZrN2F9B+/l2zLZmZM6ckvZnMlHnE982MofQCIDWUfbLhoSEe?=
 =?us-ascii?Q?Ur1+L5fZFl4ZJxdang4MqPbddCKNvrsv1nuc/yX+LkyW4EHwGSTMVehsdg34?=
 =?us-ascii?Q?CQ/LqtNANf7iksqkvAiz5SWKY8rdI55qbAgsni41QnZ6T6eDIUT1hi6OsX5z?=
 =?us-ascii?Q?x/GxGIRzIZSgFb2vRlVDGYJnvcpfEbkIJ9epn6V6/uH6I29YiBcfOWdAN7EP?=
 =?us-ascii?Q?QN9wuXOTEogfOq8dNOwA+ZQYuje4RjpnjDzxqZkI3G9zCeQfON7CUv65to3S?=
 =?us-ascii?Q?k9KYTF/IjHN/woe7KelfJ/rF6nrNl3a/bqhjiI28JWUpXon2HBkhk29KICVS?=
 =?us-ascii?Q?Utam2XCRERsnesspn229fbipW8k3aDcunG7mxwJgKCGqCFyvmAxpfOvJy6N8?=
 =?us-ascii?Q?JiFlhqmqhOlvkyCcxTwL8+bO8E1l36i576e54ro3TFSD7sc/wLwoJdByZ+Et?=
 =?us-ascii?Q?G6aS6boR09YEhynMKwRDhXJcsLdXfAkVxamwwUzyAkcKGQV14D9fcNHwtQox?=
 =?us-ascii?Q?B6m7N/fh+8P/eq5aCKVzYyiKLQG9kEpxKgaePeBRY49AnwO+tCpZGX4Xar3g?=
 =?us-ascii?Q?0rIAr/QG+r1C9mjbXXXwcTU6gaM60s5Z/WGKlG1QymQXM4CnXCdwX8i5Je+5?=
 =?us-ascii?Q?KGF/K6Oe9hFAljqKCc3Re2BePivFUQbkoXRqt2pckDy5LXuLwUWTJqQTA6dC?=
 =?us-ascii?Q?qsMtaU/YGCKgZDtuE2fR5pP3fxopR5AaJpTuxZsJoZiEtdEW955HEMJba45T?=
 =?us-ascii?Q?xUB/YkmJxlUk7XyG3zF/3AwGmcqJdvzlJ+quXDtJV5hfE99OqEgG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa44f576-f003-4feb-d7d8-08de79425654
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 16:31:35.7644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ftw2Aw7kzPOQs7uiD7p6+Qmk8sReBIRaJexNI0EAXLr6wPjaE0mV2vfDoPxFeVai
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7830
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 84126C0007
X-Stat-Signature: e7i1xs61ar75bjt4rsgadt1rm7uxbq56
X-Rspam-User: 
X-HE-Tag: 1772555508-68696
X-HE-Meta: U2FsdGVkX18QoBxoG3H/n66c78j4ea9QQLDrobLv4sjpPS9avcgVsEfdTrn1fvyZUjWrpz07Nf/XR0Ynk4zUvVOnxc4STSuuJVMaz3CyHHtp4VmlCPwfvPPBgALh9k1b8xZlL4o4+XZrU0FxQBmIvXJrJynW2IEcdT2jsC1o9pDSBofzCM7ENAfn1EBvSOAYH6rpA7xqrrvseRlKcRwAZwh1nABDYsDgLcynadeQFMnU6riYRFAKgAJlQD8YMzmdWoWVC/uGY+R1Ibx5g5H3oti22/yCknvhwEIq6DJ4lUjgARzi5QXi4KSmQosKzF5k3p2m9haMZ2+uv1++tG6ZiXxCTPuf8fQCPDMYL6bd1hBXGphWQRXnHcGlxcJlJCuNweNACpcwwAAs5UbUtnG4J1KLMrq9Seux+tyKmCte4fnfrmBmjE2dLo5qiZ+HfTOQppY4mFlYTR1CSiwOnV2naEc0beP5ykrBEFWQknk4hyiKA5J+ulB1MCYpbDN/RRjJZd5+ZgDNgenQwqTYlzF/rHaEDFzCsegS9BlUnEEO0R776jR4FPsGcC1n2pn4RR9BV7Tt6o5yVaczKYWH3NN9Qm+2G8x12jPVVCMvSxNlgO0dxrpHDDRBgNhCL9jgsQsq9hA0e1V1m84gYoH5s1Bv5Aq1O0hSR+/+RTXXmhmBUz+tCNGt5oS0lR3elbSbQL3wGPy6Y6RNK2JrtoPQyKn0OFOmZKHH2uHRLEukqYWydogTniGJrVAgKmRx+P0ZzYh4MJkvTwY/TUCaIeD2xXOFjfxFzsyZq7DrtU7krBcrDzLIimGl9sdY8HFp6SB/Z1fBczp6not+wM/V/FzAS7g+tGCBvE9+YHPhf/9cPK6s5DUw+t65UxI5h3zXPNri4DO0LtUp+cbq08SXRE/J8ul1LCaso5XyT2xKf8vs1z3Wzd4VggVRniutTgma7tWG6JlPtruX3ulDFe1UMltlwv2
 dIavglfE
 ++2J33QoLWIq31t8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Mar 2026, at 3:48, David Hildenbrand (Arm) wrote:

> On 3/2/26 21:31, Zi Yan wrote:
>> During a pagecache folio split, the values in the related xarray shoul=
d not
>> be changed from the original folio at xarray split time until all
>> after-split folios are well formed and stored in the xarray. Current u=
se
>> of xas_try_split() in __split_unmapped_folio() lets some after-split f=
olios
>> show up at wrong indices in the xarray. When these misplaced after-spl=
it
>> folios are unfrozen, before correct folios are stored via __xa_store()=
, and
>> grabbed by folio_try_get(), they are returned to userspace at wrong fi=
le
>> indices, causing data corruption. More detailed explanation is at the
>> bottom.
>>
>> The reproducer is at: https://github.com/dfinity/thp-madv-remove-test
>> It
>> 1. creates a memfd,
>> 2. forks,
>> 3. in the child process, maps the file with large folios (via shmem co=
de
>>    path) and reads the mapped file continuously with 16 threads,
>> 4. in the parent process, uses madvise(MADV_REMOVE) to punch poles in =
the
>>    large folio.
>>
>> Data corruption can be observed without the fix. Basically, data from =
a
>> wrong page->index is returned.
>>
>> Fix it by using the original folio in xas_try_split() calls, so that
>> folio_try_get() can get the right after-split folios after the origina=
l
>> folio is unfrozen.
>>
>> Uniform split, split_huge_page*(), is not affected, since it uses
>> xas_split_alloc() and xas_split() only once and stores the original fo=
lio
>> in the xarray. Change xas_split() used in uniform split branch to use
>> the original folio to avoid confusion.
>>
>> Fixes below points to the commit introduces the code, but folio_split(=
) is
>> used in a later commit 7460b470a131f ("mm/truncate: use folio_split() =
in
>> truncate operation").
>>
>> More details:
>>
>> For example, a folio f is split non-uniformly into f, f2, f3, f4 like
>> below:
>> +----------------+---------+----+----+
>> |       f        |    f2   | f3 | f4 |
>> +----------------+---------+----+----+
>> but the xarray would look like below after __split_unmapped_folio() is=

>> done:
>> +----------------+---------+----+----+
>> |       f        |    f2   | f3 | f3 |
>> +----------------+---------+----+----+
>>
>> After __split_unmapped_folio(), the code changes the xarray and unfree=
zes
>> after-split folios:
>>
>> 1. unfreezes f2, __xa_store(f2)
>> 2. unfreezes f3, __xa_store(f3)
>> 3. unfreezes f4, __xa_store(f4), which overwrites the second f3 to f4.=

>> 4. unfreezes f.
>>
>> Meanwhile, a parallel filemap_get_entry() can read the second f3 from =
the
>> xarray and use folio_try_get() on it at step 2 when f3 is unfrozen. Th=
en,
>> f3 is wrongly returned to user.
>>
>> After the fix, the xarray looks like below after __split_unmapped_foli=
o():
>> +----------------+---------+----+----+
>> |       f        |    f    | f  | f  |
>> +----------------+---------+----+----+
>> so that the race window no longer exists.
>>
>> Fixes: 00527733d0dc8 ("mm/huge_memory: add two new (not yet used) func=
tions for folio_split()")
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Reported-by: Bas van Dijk <bas@dfinity.org>
>> Closes: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OL=
umWJdiWXv+C9Yct0w@mail.gmail.com/
>> Tested-by: Lance Yang <lance.yang@linux.dev>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  mm/huge_memory.c | 15 +++++++++++----
>>  1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 56db54fa48181..f0bdac3f270b5 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3647,6 +3647,7 @@ static int __split_unmapped_folio(struct folio *=
folio, int new_order,
>>  	const bool is_anon =3D folio_test_anon(folio);
>>  	int old_order =3D folio_order(folio);
>>  	int start_order =3D split_type =3D=3D SPLIT_TYPE_UNIFORM ? new_order=
 : old_order - 1;
>> +	struct folio *old_folio =3D folio;
>>  	int split_order;
>>
>>  	/*
>> @@ -3668,11 +3669,17 @@ static int __split_unmapped_folio(struct folio=
 *folio, int new_order,
>>  			 * irq is disabled to allocate enough memory, whereas
>>  			 * non-uniform split can handle ENOMEM.
>>  			 */
>> -			if (split_type =3D=3D SPLIT_TYPE_UNIFORM)
>> -				xas_split(xas, folio, old_order);
>> -			else {
>
> Just wondering whether we should no move the comment over here now, so
> it just covers both cases.
>
>> +			if (split_type =3D=3D SPLIT_TYPE_UNIFORM) {
>> +				xas_split(xas, old_folio, old_order);
>> +			} else {
>>  				xas_set_order(xas, folio->index, split_order);
>> -				xas_try_split(xas, folio, old_order);
>> +				/*
>> +				 * use the to-be-split folio, so that a parallel
>> +				 * folio_try_get() waits on it until xarray is
>> +				 * updated with after-split folios and
>> +				 * the original one is unfrozen.
>> +				 */
>> +				xas_try_split(xas, old_folio, old_order);
>>  				if (xas_error(xas))
>>  					return xas_error(xas);
>>  			}
Sure.

Hi Andrew,

Do you mind applying the fixup below? Thanks.

=46rom fe94203b814a7fb11035c5b720a5e798ec2bcbb5 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Tue, 3 Mar 2026 11:26:41 -0500
Subject: [PATCH] move the comment.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f0bdac3f270b5..6d3bdde334126 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3668,17 +3668,16 @@ static int __split_unmapped_folio(struct folio *f=
olio, int new_order,
 			 * uniform split has xas_split_alloc() called before
 			 * irq is disabled to allocate enough memory, whereas
 			 * non-uniform split can handle ENOMEM.
+			 *
+			 * use the to-be-split folio in xas_split() or
+			 * xas_try_split(), so that a parallel folio_try_get()
+			 * waits on it until xarray is updated with after-split
+			 * folios and the original one is unfrozen.
 			 */
 			if (split_type =3D=3D SPLIT_TYPE_UNIFORM) {
 				xas_split(xas, old_folio, old_order);
 			} else {
 				xas_set_order(xas, folio->index, split_order);
-				/*
-				 * use the to-be-split folio, so that a parallel
-				 * folio_try_get() waits on it until xarray is
-				 * updated with after-split folios and
-				 * the original one is unfrozen.
-				 */
 				xas_try_split(xas, old_folio, old_order);
 				if (xas_error(xas))
 					return xas_error(xas);
-- =

2.51.0



--
Best Regards,
Yan, Zi

