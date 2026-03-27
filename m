Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC2FE10AB830
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E9A6B009B; Fri, 27 Mar 2026 10:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277476B009D; Fri, 27 Mar 2026 10:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1CD6B009E; Fri, 27 Mar 2026 10:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA6B66B009B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:26:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B63C75C2A4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:26:14 +0000 (UTC)
X-FDA: 84592067868.29.D564B01
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012037.outbound.protection.outlook.com [52.101.53.37])
	by imf10.hostedemail.com (Postfix) with ESMTP id E4061C0011
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:26:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="t27/y3xa";
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774621572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUXchkDmn3HsqYD3n5OUj+ds5FuM2RUIJVYh5INDPvM=;
	b=66ywNpCAl2mMYo3YqWL43MZk1W4c1lPJI4+Bhzdao6qK1KDEGDjFHE3dHS2KLYyqfJdW58
	mZNjOzO5IWlH5ZrfHmSptyDFOO6IC9xrxm0h5yz+FzJXJ03r/riktO2KYO3KcJcbiYpaiW
	kGx5L7Z3vR7MhtIS70FKGiZbb1vhsgY=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="t27/y3xa";
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774621572; a=rsa-sha256;
	cv=pass;
	b=FiZwMoi96B6cIT65bpFjr8Ih3OVvypTrGZFLstOT4XmX1B9FnjYn7poXgQ+lMerDn2GgJG
	vA4PbhPlJnD7sxIWKW8TgVVQO00VWwWNxSE21xU/+KvDq3q9mkwQ99FBm/e6+QhX6REGg0
	ufWCVThywoLWZouPcuxu5ub5sHVm/TQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xz4juyUXhuawr9BlRZKqY65p/2RPjSYc6M8RZ9Et4WRQ32XaTPOYzjANkpnYosZvN7GQaVQ/FawRR8XPW9Ccky1IfncMmasihiwZjlb65FydY8tIIBOj/OwpzjHFZUK3gxRx3PXO3CfLff7pT3x5jfMmqkh2V3kijf57Mm4eK1cWE2GQvYopODp5B6vSbDDv/C9YtSRPoRQ0eePjNEzKA1ykoWvTE6UpQ6vPxOcOOK2cwRcrIMeRRRGFVGqAeiux7qy2Ape8vhL34IMjFib98RNYVgkT3EKSaUW+qELQ0fyuwShznuz3+eQ/WqZMLt5rXCEiZqFwoYt5aC06CZCMsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tUXchkDmn3HsqYD3n5OUj+ds5FuM2RUIJVYh5INDPvM=;
 b=L4gXH9v50h+QGxcK+PiLjhrj/8iTwca6sSk22srSCdaWZmJMFzlcSC1biMZDBfqKG3YxqaWOBwkeDbkrmMfsszkd+INvaSHXRbNO269RAdLS2zP2hwFpnOxu+INjCsS5I7vdRgrlVIoGfzd4TRCP9Si/Vt1JS6wG1zvFNdMhap170eZIx4ru8d74+7k6kJ46pruPwp7rcxrTP9y5wKzkh/C2KSaAIXtRv9d8vNT19l1Z5YOkiHjumHDRU7Sua0DgNPQtFqT7ays51xIsklEe+7Qx2BOE8xEmWpJtSpGPtOEas9XGeiF+lUZmGYytlKHmAYFfyylG2ntYreEPoFQx9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUXchkDmn3HsqYD3n5OUj+ds5FuM2RUIJVYh5INDPvM=;
 b=t27/y3xahkIVZU+GYXuHIhECWrmq5DiLxlyNuVcHUVVULJseSE6zGK7ZeR9aYALxnYlWYOu/2Ezu+zbcZkQ2++/XF6jPrpA4LeEuXw2mz4+BwOu2ZOhBp4/tQLiuQFrF0v4yCNCE7MX6GMusxbpq9jAJ7vOax8cCTKkHDTBpfaKb3k/2CSNRHEekdI0gzVPhLJbXG7OZRq7YHixV5547jAD640dM+kVjigyvG5muO1RxW8aQaEGtasxmci5Bo6/77fuS5D7XeY5EC6QgRjcPyVnTMEGZqp8Sq5EIplz8iZpqZsq66qxbr4aIBa9mtkSDkNfwmKvEnibPGk9oLLKdtQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.6; Fri, 27 Mar 2026 14:26:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 14:26:05 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 00/10] Remove READ_ONLY_THP_FOR_FS Kconfig
Date: Fri, 27 Mar 2026 10:26:01 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <6800F1A0-7ABE-4CF6-B9E4-81126D59B43D@nvidia.com>
In-Reply-To: <10748785-08a9-41c7-bacd-88f05fdf1a88@kernel.org>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <10748785-08a9-41c7-bacd-88f05fdf1a88@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: IA4P221CA0002.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6478:EE_
X-MS-Office365-Filtering-Correlation-Id: 5741292a-2735-4c59-c191-08de8c0cc7a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	RIw6bLZUTQslwZcC6TW06OksoksGGMI3i1BfUQdLEpZEAPOuiMy+Zv68F142w5O7rIpvZDLOrSZ+3C1ZBYwjP7tAmzCd9lxEuovsDeggg2DB2zD9+pRO57a/JIG8rItOklO8+HscDbzVjxbBQKTkVNBgGgZ6s+KGxe2ayqUH8l9KHLjBs4D3ga4kYdL5M4/OJjujaSW6+93XVGHfnlBYzfL3WUxP/M+DisLzzqO/jZmdXeTIp7yyYacqHgO/os6VzzfN20ayKoh+mVwFirahbYyDSyHvMQFk+vEBLLOPIiiyCEzDixms1iGb8j+jqI3aORxln6sSrtoHWxI6PMgO9wJC5dfbEcHJBsnNX8T8ifSyx1EBc2gTo/FBnPLSazFhhkLQ6TyhUw/CGOqkUPCi1ZFSJl6NUl0N24FpUVMc66w8uVyvWcVkIeeICuIFjTLtM9gAgwadvjqKhpn5aqlrnKB+nHABfPvTg6WUrP8HDKRuix5Yq9cYWrJC57w2aWtjM6YTgWX35vCOdzsmTM2WHo4+cU/Ln0OL1CbE1q8aU9PBZ+Gn4lA/CkK5A2pP6TuDE9CBKHMiwyzNLiC+27PnG3jO0YHs2fDx8wKANTEKcIoGI/+7bCNnvIlqChwtU36HxFtq3HhQFLvRkjWUmhpP58Mr5cgSC9Ql3H8L9ri2KyDQAADM99kkATRfwIeaWPFSQ9omDlcnBzI/8LMouGZqUGnga+oM44ghTjZHJw5gDJ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?59LTIkdZ+ARRVRHxX69SbMiR92nOr3c+anIAkoj8PhCGSZhSMpWQYr3inJ7w?=
 =?us-ascii?Q?gffjnQg1AjyZtNEuPnVFosw4ZJwU5BraSM8TcA8dp/jsw9cVDXCpq+he1UeJ?=
 =?us-ascii?Q?jzqgH8iyb4/HpNXVlg8tHGcjhmkA83KEEYfy83w7kCSxg3BZLArLDhwCZTrm?=
 =?us-ascii?Q?0q2dwzQSnu+ZoKGaJctjh2CW0sc952NFAB7A9KpE3enpNPYNC4A1Cycd4PBq?=
 =?us-ascii?Q?6Et2MqcV+/6d1xcT6xCODYOZHIzPPZnanT9drlDXdyRzFUywEFjJOko8k8ic?=
 =?us-ascii?Q?Q1P1LIe1rPsO/HgJSrehxrJgQep9hhplMaTLBie617EyVMjA4hyxZqEgLoq4?=
 =?us-ascii?Q?N8WMkagS8NiT+Yx+5LekBIZrOlUFSecD3EUqZe5AUmEuX9fP4Jv7tWz3eByC?=
 =?us-ascii?Q?O/ZReGgLWFdB/t5PqMI0lRH8wNjsKIB8JT+tTzVhaJLpkE+yg1hOU7DSmQ3E?=
 =?us-ascii?Q?2Dd8GtTp6hZ7/qBXfg0zSBqOzBySxFbCE8gu2qJvJcXpTuNuP66Nn+hQlieP?=
 =?us-ascii?Q?rGcY5EXsX9hXNoRlO+ijwvCR3oF5JOULmyucMY8RVfLIPwmKpy3I+G/u61VU?=
 =?us-ascii?Q?GGq5jHCFI94DgEQ3b6RzqcV4DbLxSW43MhBmH9kguSbaA+2hP5hP73yG9Q+y?=
 =?us-ascii?Q?M0+df/Y8c6qapmMouRkZ5zTh3OCCqmstfMTwvFGQuquGBu67pYIXV5mxuXTE?=
 =?us-ascii?Q?gO78hQDHiDcvyJGAQ7oN3oyMbhUumOUlJk1eGNtYlPhbq805Q6qWDKv8BI6v?=
 =?us-ascii?Q?hJS5RUrGdGEZDlsSFteWRRjzcvNCOElBJuppU2WvTxqgT3wKf6Uptmocujve?=
 =?us-ascii?Q?Su7c7AwATxo95TH9wpgbp6UZhNdJlB8gmIhy7kmK5o7Ckbhw4ZvhF1dpym1G?=
 =?us-ascii?Q?gfK6V2N9HMVbn8AFU1QbYMMtnvqhFZahhenPUDDL3a0MlF4qxK9bV/Ke72xy?=
 =?us-ascii?Q?uMRKPiJr1aXRe5nYXdx7baSWQRBdOXQJz/DvQi7G2pQDPmaqUPARW/nOkYc6?=
 =?us-ascii?Q?cPlVgmb7nI26/sUNjSbx2UhwyK5jSxVwMrmp13lxbB88fkmTyZ+Fb/6S4sEv?=
 =?us-ascii?Q?WoGYdCyVEy8VKkC8x0Ul/0LmNoyWEL0/TVoTFnyfA2dJ8/gKb86Ksam5u2aG?=
 =?us-ascii?Q?WEuqhWKu53D7NxKNulKjA/fwAX4qTlkV5vyb20Pl+oEzULSrT4W0sviDExxo?=
 =?us-ascii?Q?s5UikV9r5ljuyQG/kHJABaE6YoF2zvyEJa29H/Eh3gEkFNvP+Iy+U0iw1O4A?=
 =?us-ascii?Q?nitAYyqEMrpsaEWxAtZwQuoi8mNbATY6Xh8wl+Tz9AVCxTWEKDuruSd56BQE?=
 =?us-ascii?Q?HFqpNLy83Hh8xGgA15OI/CcUwObAKgdXEKtqP0U8egLCXNIIs30KjJI0Fsor?=
 =?us-ascii?Q?Z24Df2BJM7+memtZ+OtRps/g/I9UkFS0UgfJ8EKJNyG4sMgkCjFzrWm5Vks2?=
 =?us-ascii?Q?NN3VovfWPr2d1TOjIbUcCcBLNyenmE+DqfYsGXSQkAMAgU/c852gS7Y54ap2?=
 =?us-ascii?Q?/UnzBCqJ//X+DY9fWEu4BUxeFNWF90++VjuiujSsATughO9DMOGvSzHXtjzx?=
 =?us-ascii?Q?uOkt03sbxnjGcafAE7lRm1uqqZ6130RBpj8lEuseJJRyDxbmBjwDCObFrVDn?=
 =?us-ascii?Q?2FL4i1ZC/RuF0ixe3k1UslakLrXPQNP5d4xGW0EW2AvEU73RDm6gpOhuixlA?=
 =?us-ascii?Q?a2rssbbc9D15q++ro3oeu9OTadyv9B74QrDhfLa7+16HI1PDRime7Skvbdnd?=
 =?us-ascii?Q?ib44yX1X5Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5741292a-2735-4c59-c191-08de8c0cc7a3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 14:26:05.5456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MtdRenwI01UMOy81jT7rrXAkQsbnQN88YagZNjSFypp6PQcYCiiDZHEMYbhhR9i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6478
X-Rspam-User: 
X-Rspamd-Queue-Id: E4061C0011
X-Stat-Signature: kp5gfmh75cg9wet3fdwpn4jeh4ut8xhy
X-Rspamd-Server: rspam06
X-HE-Tag: 1774621571-837948
X-HE-Meta: U2FsdGVkX189YydAuQm3g8sKx7WgOCem9hHcQ3nCSuPu14rszFa03IWiF/HGACzY6CWtUYo+lHP/HrpPT58V0LGXdkFX0uyUH8nMjF/ZqPfqysMkPLzDlvvlTsbTOzX8ZCHbmhHIvVNA92t3wT/iTbvBbO50IcFvo2qhL1q61jEjZIFCGxdCUL55N4GGB+JNoxPjhzG89MFt8FyRVUZg/VUUUZztfi6zQqPiObNqjvCFjV22NSYuh120rwJXpbv/h0bleWh9gF1+jkVmsKQ72nfxL340JNT1Nqyp2nmakk3+G2ZzddsT9MxQ/TeLI8w6RNh0AhDayyEr4mmvKLCER05q++aOou8eoYUCXgSgWSaNqKVzE2U5yvEO/bF0cF+U6b9krxSQfACgWP4MvAq6MOnP9BEujwr4njYt2q3T9MLrVcZDaxy9xBNi+Zrepu5o7HImvEhHbWhKO6Scy+duBfUv+y52FvT8SewlxiPhDWixMOjOYSDBrXNLDiNSeuGIGfekNTt+PdK8PvNf8CA86vr27H8jmFaBCWCyYvEQbCe0t0pN4Icl3zn1cJ9G+umYQOCEVvj/PBw5TUEoSU5OK2YxaWJ8KBGenMJVFtEPIKPcdQFrxhFBfox0xfrfsjnTEBe7Pfj0fIaQz76wgD8FmZrr+n/Tv4+vj5daZxW88DQg6D9zp16AMDSYaTVKwlgFzsRmy+aYUHBMkmw93+P7BGAA7J5wHBnMesJtcRfx4kSeQKFjjKSRAjn4OsT07b8IdIpeP7lBhA2uAk8B5Q3zq1GZUmbiJTwFmrgggAhCcoehGlLZBw/XmJr9xeN40W4pZGUiIH6eXYhCraQKim6Lgk/6ppg41Yiv50vqs7fCF1RuFC+H5PY1kbm6H0GC+XYLTqR9pst+oIFeRoj8owFNEKdqb6nmnivuyn2LXTlq3BQB1dsgsrBZrzFlpIkIvq4+DDT4t2YCyOLXGF0VNK8
 wqVwSa/i
 KThb9UwQmxY/f1J4CHyPq78w+lRUIycHBeASS2u51wkh651WfzZt9ZkwJECLB/Jb+MMjKEcIANeuJUM/mLZnW1+B1eLHhHZ6ON7Z/0RekKga2bls+aNDEAXYn1BA9AwY8l2gMhQq7P5xZ7wJmPsRgAjox3MzMurNx7ceQaJeMdlWXg1UNri0NS/QAWL/dfzRc+jXO+OJxPyLZOaTlL/6zVmVRcNpWgGShdHFwdM3kJ6aqd/AiRH/tGz1wPP11N2gup0d2C2Z5FLAmgiQcN50jrCY6nzDffk21LxGfRRbNNEM2rKeYHJ3LUkvJUNlJlCmYM6zhW4nEXn+8K1suYYNqyhHddP79LX7cWg/zWdheVzRAsxZOOOXBER/uqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Mar 2026, at 9:46, David Hildenbrand (Arm) wrote:

> On 3/27/26 02:42, Zi Yan wrote:
>> Hi all,
>>
>> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
>> read-only THPs for FSes with large folio support (the supported orders
>> need to include PMD_ORDER) by default.
>>
>> The changes are:
>> 1. collapse_file() from mm/khugepaged.c, instead of checking
>>    CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
>>    of struct address_space of the file is at least PMD_ORDER.
>> 2. file_thp_enabled() also checks mapping_max_folio_order() instead.
>> 3. truncate_inode_partial_folio() calls folio_split() directly instead
>>    of the removed try_folio_split_to_order(), since large folios can
>>    only show up on a FS with large folio support.
>> 4. nr_thps is removed from struct address_space, since it is no longer
>>    needed to drop all read-only THPs from a FS without large folio
>>    support when the fd becomes writable. Its related filemap_nr_thps*()
>>    are removed too.
>> 5. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.
>> 6. Updated comments in various places.
>>
>> Changelog
>> ===
>> From RFC[1]:
>> 1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
>>    on by default for all FSes with large folio support and the supported
>>    orders includes PMD_ORDER.
>>
>> Suggestions and comments are welcome.
>
> Hi! :)
>
> The patch set might be better structured by
>
> 1) Teaching code paths to not only respect READ_ONLY_THP_FOR_FS but also
> filesystems with large folios. At that point, READ_ONLY_THP_FOR_FS would
> have no effect.
>
> 2) Removing READ_ONLY_THP_FOR_FS along with all the old cruft that is no
> longer required
>
> MADV_COLLAPSE will keep working the whole time.

OK. I will give this a try.

Best Regards,
Yan, Zi

