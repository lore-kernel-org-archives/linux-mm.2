Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9328CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 487388E00B8; Fri, 24 Oct 2025 11:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4379C8E0042; Fri, 24 Oct 2025 11:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FFE88E00B8; Fri, 24 Oct 2025 11:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7DA8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:29:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7C031A0F00
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:29:11 +0000 (UTC)
X-FDA: 84033391302.25.6976B34
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010053.outbound.protection.outlook.com [52.101.201.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0F0DC1C0010
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:29:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UaxvqHKh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761319749; a=rsa-sha256;
	cv=pass;
	b=FvtA48flay/uDKLYB7lqK999Wwf647ati9zDVRYQjE3T/ZjmMA16kWAr6BFSSsXbxIEyLu
	77t4pQ452UnSdCirXlX/3QEC5+GJn+w6F3dp3P3rEpNXofUXLvq7dJ/dKygoAjn0USM2Ux
	yGnvEim1cXRrCL0/XXOCyQQQdIMesvM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UaxvqHKh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761319749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lida6jBC0M94V8MuzMp2HXJDWsWNSy3IZAJMj/U464Q=;
	b=D01fsPSJ9DUbmaAJm6CXnOHilVZlKK1JaZhTBLFtHPMN0E4wO7UQmn56NfAaWW1OEjwQML
	Vd9GHsItks6PeLoS+H97Uuf+6STKL0AA2CeVubk5ZNA7JgbE8lXl8A/cC8qW07zlb+Zr6J
	y2FOKLPbedf+FHkRG/mYIFRyMZuxhTc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPb9+WLQpaMg3hy/JOc9RA1JGqLGEKAnLoCs9VF6Y02JDUKajiIUTAPEHrGMuDlXnqvKavvQjjkX8Sl9jhJ+cBYevoZ8nQJuYT1zCGVeniQu/qMM7mIakF7r4sCp39D67LQBldzSyyF/7TbHoVvGS7ZRImuEiXRvYkk8rBVYKdyqD7oZUh2c5z+NzYB0ngSymLt4EQWx1eutQDAKPypfjO1hq2Vg5+KwHzwv5AG74OsLaOK0cYR6cLdY1sB792HeL/C6YZuobGuljyis8p6Zk5toHIgfE3MhqiVGN2RlXsa6yYpU/O5rSOi7ZWs8hJkVcB4qHB7UwvhagwI9Aw730w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lida6jBC0M94V8MuzMp2HXJDWsWNSy3IZAJMj/U464Q=;
 b=JBH4FMuYbq4AsG7JPOn30Y1nN0sUPmRjCY2mP0sUifinflRu5qW7CD9Nt/LU3IGiLk41XkvV4ur0izUJwSwPk533DeO/UumDq6triSCbBeI2OQcToEdfo3y2BFcy6FLPI60C2esODwtsdG0JUarZHA8RKUstNvrMn+QH0KISY9R4LXp0/BfeoK6AJUBIJONt0hr/hFRKyAGp8lEz+KmQKs57pq9rYrwdW9vhhGH1J+yKlHT4LlSAVYpvChD+xxIQZtHGJpe6ShGF1quPZ9t3L3YJ2l5l2OiD1xe8DFOwHPAS/i4GOFR5qiH12Qcf9a1li/B86URaAFtI7rupUC5FJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lida6jBC0M94V8MuzMp2HXJDWsWNSy3IZAJMj/U464Q=;
 b=UaxvqHKhIvzd5Xyvsa4EfT1H6stUgTAIUpJOaETfVA7KAOAVKPdOhHnjCFXdJOAcMPBFHXglDgKFndWhq/Q6GCHlqqnHB8KNteHw6fieqlVIMgVLWVq5qRQGrrGleeHdGFGPxOo4BdUpHL9WS1SkwkjNWitwM4C04wQsqnY8ibfnPgpJCZRQjhraZven6ziahmuln8XMWIKKKPwopu165XSaNCwZSYldyaWU9YklkK7J4FtZ2mGjvysqNn5duUh0ld/ItIrdSsI2nbtRTuB9i7tomFBjJRvgBu1rYOHw4NGo6UmClzQH4gvzsBhdIcTV8jSUyfRg5HkAvPl8xFGSEA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7284.namprd12.prod.outlook.com (2603:10b6:510:20b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 15:29:04 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 15:29:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v3 4/4] mm/huge_memory: optimize old_order derivation
 during folio splitting
Date: Fri, 24 Oct 2025 11:29:00 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <9A89CDDB-7C17-4804-8240-E068EA68F7D2@nvidia.com>
In-Reply-To: <f1830e4e-1630-4242-be0d-1cf65f20b54b@lucifer.local>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-5-richard.weiyang@gmail.com>
 <f1830e4e-1630-4242-be0d-1cf65f20b54b@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0402.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7284:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cfb96d6-b11e-420e-9b87-08de1312105c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?buYmRHGNpea5YaXjTZHiyF4J9kxOf0eBLbK30HK4yWAeOl3j+4Fd5aO5s2y8?=
 =?us-ascii?Q?J7+hfdSD2s46Rff5h6TfVwpq/6MvI4OcgOKjA7fp+49zF0XyxN2EC/LpMMiy?=
 =?us-ascii?Q?wQTZeU39WHnasTOvml/tb0umj28w1zJlD6wFcguY8PXL4SLflC4d9cxdMnVx?=
 =?us-ascii?Q?9dCT4YuwggQqsAwjJ/lx/ZL1OSgW1t5OmwOXTl33GW5TF5pT0T/E0JbtnjEn?=
 =?us-ascii?Q?WxF1xSiiibGdI9z87k18ITUEbVXziWWThk3GrY+vQ3Y+otPX4/IGkV/ba2+W?=
 =?us-ascii?Q?biwQNrV/pzJTwpFngRsp7aodW0LYLHaV9PIQci7YuhHOb4Q6apeNndDP6wDe?=
 =?us-ascii?Q?cyPXdU6bN2LfgD0g5gRpaD9QA/sEub4+2Ywrpa9xXKfPKIm4Z60Ng2xb6dR3?=
 =?us-ascii?Q?tCaY0fc2rnuued0iedCQzO6wD5KlGAOv1BIaPNPDsLvM9WYvxwhFfva479Cd?=
 =?us-ascii?Q?5FlizM/lvR9MXTJK9/xBtqbwGPDo2Y/BDILTQOJ8Qw/b4yIoj7Dvoh33dUtr?=
 =?us-ascii?Q?yDNZ7CpVEXgTkTv6lJySwM66rngXYVVO8tY+I+rqz/o/UmrR1k2uCY1CB4k3?=
 =?us-ascii?Q?01PJmASB3Dx5Tt0swAaFTgYUTL8ivWnNc8YyVRPPgyW5Ov72j1TeOnDC5dhR?=
 =?us-ascii?Q?EZ7QotZptJYL+f+K1Qn4NJCoJHAJAc6i6LLKDybe18sZQVuc12OTzU4Tpjch?=
 =?us-ascii?Q?gt/TcXBu/K3CnWJHFMXDwpY4asywVZ+E7PgXiTqO2I1OhPwX8uLUgsKQi/Oe?=
 =?us-ascii?Q?VcMQgSWeZvwOMrJJXQ0wqjPVxR0MGP7tAaFPpdsCoTBbUMPQq8G3n8S4yauf?=
 =?us-ascii?Q?l3KK2T9YVTVK/nw5J5dXAgU8pC0IJJcX3kEjFL53yaPbZme97oe0MQwIIRVX?=
 =?us-ascii?Q?PJeqwV5gMfUrwMD9EndjEYXu/lIm1mF860v8s197rQuY9YpUE2upFn+Y6Xe8?=
 =?us-ascii?Q?yo5bRNF3V4NnntsKX7vGhkEybgAIRPPHj8fnfG6MPWHllXZNF6kaeu/SuynC?=
 =?us-ascii?Q?HVhwU24IYAPohm1SCgbxnjwchX6Q2an3I/VHeACmmeldn5X05Hi+LeAIaH+r?=
 =?us-ascii?Q?m46ta88sDECYFlMK+xBl/BehnW9YCX14gqUvuXOMaokrLN0fatqdGojKpIyC?=
 =?us-ascii?Q?j0T81pwqW/Nhe4W5O5mS4uFFhCMhHNwJJwcjnK0Nj0KgXygqIb49Ud0brlZ7?=
 =?us-ascii?Q?hEhKgXUK1Ci+q2oRf32meTaBGlFUCcqDtmQwbDYObQfzX9p/MPF7EfemeqXl?=
 =?us-ascii?Q?g7UWKWnL+vzz3uNnP3cALuYQC+BNy/cuo3Fi1g+rDUG4rldSJovgsD0nKq2E?=
 =?us-ascii?Q?Er3kARjnCSCr7mEwANxwfJCtSzuRsdjelAEevB48tPdlr1mTw2/SO/VNeueV?=
 =?us-ascii?Q?Tz0qsQFFj4xjwjzNAmYzF8ol48anCYNUW2SVZNVYzihif6J+1yhxQHNMRAf7?=
 =?us-ascii?Q?uXlCjSc6hHObscwcuJVOwX31K4Gytavr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GCEdu+q2hWyG8Dh7dVpGFrlnQRSJEBeVhrOFhwJD7nT4ugRVsVgVZdgs3VRk?=
 =?us-ascii?Q?huqXBsN4XO05L0lXRP44ATYzLhu2Q1ohBUC92JUuSsn5uGYpILOudfq+76QI?=
 =?us-ascii?Q?u9RW8bvfzibWrttiBeJm/90JRxoLt4l3HzbDqwEgtWjyFjAsY8r5PiHVsnEe?=
 =?us-ascii?Q?Xywx4Zvfd0kPsiBU0ONiSriiMjR+tXYxbVMQDH09VDiw3aaKu96FlnB9HE/f?=
 =?us-ascii?Q?3jWTlwdwC3dtToFYWFuc1MGkixh+SCFJOGg8awQV0Xms9oTZaNRuelTDoRQv?=
 =?us-ascii?Q?TiYuhqGBLqP48WXcAm+JGjwpvfZNx1hZ0kytDWMfX9yQrhzxbMLRcfFsofZS?=
 =?us-ascii?Q?3yAVJ1IjzmSWdTdU9k+uEaX1g9yl6KsSmifsA2LjDavZjeGgAIFZ3VfR221C?=
 =?us-ascii?Q?AZyUdSk4rRed0CEol/YgtIRo0OHidNT4gn/jaagqISvBtLsumELpoGU6OgU/?=
 =?us-ascii?Q?oagiym2s6j8ts6CQllbsPUspE0DjIXTtYh2WE5EOXFV9N1s2AJ6OISjcmb+a?=
 =?us-ascii?Q?E3lGtjcJYJyNrmaFcqLlwdGEMh0EqdbbHvy0yijkRRYCYE+omIDC2+UJTCEI?=
 =?us-ascii?Q?AA7ED+UYRB7Aql80GCNE8pPyxDzKKm7Sn14wgtC+p9lEA250xUdalRLDwv5C?=
 =?us-ascii?Q?3GbJwvqo3Pg+lHiyDph0DD+33t4cGxcnf68l7Ex9OXil0QWmfuG6x989qLrx?=
 =?us-ascii?Q?J7oQ2BxQcJppqO9UfTXLctvZsQytOR06grepuHSj+JnTNy1CAWE6bBVQoF6I?=
 =?us-ascii?Q?6Ude5ZZk4IME94h7QAkBKoJXQhdKnVXR2eYqVJpYWJ0+HGAoOkDYheBtx34C?=
 =?us-ascii?Q?hD3lj0EiGcIHA44dpHYCGyYE1mBJWin/64dHn4kV5gPoUI1qKvbiYfhQVfya?=
 =?us-ascii?Q?hIR2bF4bCR3w0+GsGnocDJA6MORay90xC49r7fTgl6dhqfc60e0vs6tYlXna?=
 =?us-ascii?Q?utGBHhMNil760FWKqpch3fGedcLV1/ZWX1EwRGQkOB4DNVPr24PSQQP8ULxZ?=
 =?us-ascii?Q?NFEjJtYRHnLJRwPU9E39DxYXA8oyO0ddpyB+9nUyszcAt/A7Cqy5VrXgz5VG?=
 =?us-ascii?Q?E7jV9MY2bt0i9XDvXGTkhZS57ZuD9DFFby5PMfFeqztnlFyRSEABWiXfgOHV?=
 =?us-ascii?Q?4VdHHNO0pH43cnkxhgjVNrFHtXa4969lNxPRS95mZ9BsnLlZ+xHlAzv386Sy?=
 =?us-ascii?Q?BtZfol4NYEI4EzJRf32cwD0SDLl1nXfiWIlMa9KPpnvJBld6p1hbOi9unUUc?=
 =?us-ascii?Q?1TDsV6T2iPEKx6nGT+Gph/GIcota6gwlwzWT302wfcZaeCwQ0FHrSQcaeSEc?=
 =?us-ascii?Q?AkUg4yFM+Q55vcQyDqea3euOpexOiFpUUSz/bgQRQ7EM75FE0vQFFwzvDGaH?=
 =?us-ascii?Q?Z2SW7XI7iz9EctewkoytXOhAEkkXC/28ogdqo0O0ExXcoD7pY0q+q7Vc2PGe?=
 =?us-ascii?Q?ZiwPAH+rW2cxt+kYG/BJ6Zu6m+JkRle7APyQ9Hfb+krSYNjLicxQy8DjwM1z?=
 =?us-ascii?Q?6A39Vpt76JQUc3Kpld4qUUxsawkJYuP8OtCRZTcgV/uvVJcIYKeyW7UfiU6Y?=
 =?us-ascii?Q?CnBHkHF/Uu8V/FLMuE1Q68bDjKKAE8EtVgL/iRXb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cfb96d6-b11e-420e-9b87-08de1312105c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 15:29:03.9590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXj3/zntlZ6CQKamq7/ZCKkVy3AHCR9hAGknFClEFScSKJ+e5F3f7bHVbhG9kPGM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7284
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0F0DC1C0010
X-Stat-Signature: cohjz76hxgns7f1jgwzw5b97qxqfdkus
X-HE-Tag: 1761319748-291424
X-HE-Meta: U2FsdGVkX18SUcEDobTkvssWULXQMb6wZBsy5U/RhPm0DjZ+o3rC71574QBlWllOz7XixD7wzA3/HBXtw+P57MGy00IvFIv5P0eHRMIfB8WFu+iRn6IEoOpzipJw1E6PYZVyf4OlIgpSPbwjY/nPCJiqWbkLK93DUDNyPfncZ93lfq//d4ki4pA7bCmGE/nedzWj11qUuSrEmRu8X5K5k+TyRhiudXqu6ERTchS6AroEWI7fN5wRSf4o1QBqMC4VzfZh+YR87XSSKnpAldxHMbWEtba3cP5n7GxB++GNxfX3ag9IcgIVb56YIa/P4F5vFARN9AMJvh0FGKwHjYPlgIdPx1CWNjK8ByOK7WD5C4A+hWTiix1hTusRvuB4usaAbGc5CjlNs2Xsp4vCn/vGBATGX6AQaXW166ap9hRVj51hIYqdmRv6UP/8K9p+eqt4g3j4T+ZgRPvO9V+jMeV1FvD1ytmzD/gogo+//0+j3bhCt0SHDoXNCLARVNdnFd2V1B+H8fsL0N5Svk7dPf1pxpMT48zpw1Slyd/5PLfLbEboomdPRlgG6XaTICDu9TZcGfQiO91DZGVepUDiLcCiEDoExLfozQxsUPbFOMIJP51mepp9qo2ZgE7PcYiS85KKhw2QbMT90Enc/uH/+hLsjuOOA/0nvFUiUxVM7fSTDmKNpLFPyrtqqFMqw23LoHyvwmOf27t8b32/x3n0yBNgZHRHP5G95VyBuMzb+LlqM3yneP+A//PJFlKfBGjEyQLztNXQOaPCYV166GdU53fJ+10udHG64AMMGNzOmWtCSbfOftqeU2U5bQ3DtrFSkk5K8KTrAWcjGFCFmDm6jwiLL1I8bD/qFUclcRNqirUi9p2uo8ocmMB02dRIS9vqgJfpDxOHzzsDo9kB1dkb/B8RM7HmYi3v5ArT1FRMMcdYVtEPtKY6S/8dCHLGwkiyBP4ZNsXEkuD7pEcr/bs9Hmx
 eOeoRghi
 3FMllBTiIuweoKluR5sVqZNSwaibGFC1K8FnVWe0COwiylO/luTqoWKnktgUB0R6CxYpQVzEx8DIUsgGBJfrFK3ww0aQz3fxjuZgYGHXOS8neVLUYqEq7jLK2CzG3UhMZYWTMzSSmPBxZn/CPMpoF9aWigGp9EHs7uL0XNwZSk/FytxcZpXxHsWcdpc/exJTdszj7kGnd3jnSSp2l4y1MIiJAJ39riAPZranW0lYTVFtR9hKDfA2XS6FbT4pmqhiiKtmHJEtw4IQMKKXEoRwNAGKJ/N89JEuLRUMIuu9fOIYXa7aC/2vNV8+GNOGz3h/yd5dmqmoZ+Lzf1C6eN6EpY3jyYdF00GW98PE2p4+xi6B1LwQpIB0SAfQISwIFuq7xMzPCTPCch5A68l3Cm8Degr6FNGUZd8ruQphO9qnDlZl8dIRx/8AzagZwzfscbS0lCXvPcSTGDJxeGlL97+96MX63bySO5+Zd5aghjWUrV4VL+S70mOsgbuCIQZ9nRi4figk5Ex161zq2ctwkVKJetX4vXrqEAORtpUPrE/g+RsxnAsg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Oct 2025, at 10:46, Lorenzo Stoakes wrote:

> On Tue, Oct 21, 2025 at 09:21:42PM +0000, Wei Yang wrote:
>> Folio splitting requires both the folio's original order (@old_order)
>> and the new target order (@split_order).
>>
>> In the current implementation, @old_order is repeatedly retrieved usin=
g
>> folio_order().
>>
>> However, for every iteration after the first, the folio being split is=

>> the result of the previous split, meaning its order is already known t=
o
>> be equal to the previous iteration's @split_order.
>>
>> This commit optimizes the logic:
>>
>>   * Instead of calling folio_order(), we now set @old_order directly t=
o
>>     the value of @split_order from the previous iteration.
>>
>> This change avoids unnecessary function calls and simplifies the loop
>> setup.
>>
>> Also it removes a check for non-existent case, since for uniform
>> splitting we only do split when @split_order =3D=3D @new_order.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>
> Thanks the separation makes a HUGE difference, much appreciated. So:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: wang lian <lianux.mm@gmail.com>
>> ---
>>  mm/huge_memory.c | 13 ++++++++-----
>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 093b3ffb180f..a4fa8b0e5b5a 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3596,8 +3596,8 @@ static int __split_unmapped_folio(struct folio *=
folio, int new_order,
>>  		struct address_space *mapping, bool uniform_split)
>>  {
>>  	const bool is_anon =3D folio_test_anon(folio);
>> -	int order =3D folio_order(folio);
>> -	int start_order =3D uniform_split ? new_order : order - 1;
>> +	int old_order =3D folio_order(folio);
>> +	int start_order =3D uniform_split ? new_order : old_order - 1;
>>  	int split_order;
>>
>>  	folio_clear_has_hwpoisoned(folio);
>> @@ -3609,14 +3609,11 @@ static int __split_unmapped_folio(struct folio=
 *folio, int new_order,
>>  	for (split_order =3D start_order;
>>  	     split_order >=3D new_order;
>
> A thought for the future - now things are simplified, it might be nice =
to just
> separate out the core of this loop and have the uniform split just call=
 the
> split out function directly, and the non-uniform one do the loop.
>
> As it's a bit gross in the uniform case we just let split_order go to n=
ew_order
> - 1 to exit the loop.

Yeah, something like:

if (uniform_split) {
	if (mapping)
		xas_split(xas, folio, old_order);
	split_folio_to_order(...);
	return 0;
}

for () {
=2E..
split_folio_to_order(...);
=2E..
}

where split_folio_to_order(...) just
split memcg, split page owner, pgalloc_tag_split, __split_folio_to_order,=

and stats update

>
> BUT - let's please save that for another patch :)

I agree.
>
> This all looks fine.
>
>>  	     split_order--) {
>> -		int old_order =3D folio_order(folio);
>>  		int nr_new_folios =3D 1UL << (old_order - split_order);
>>
>>  		/* order-1 anonymous folio is not supported */
>>  		if (is_anon && split_order =3D=3D 1)
>>  			continue;
>> -		if (uniform_split && split_order !=3D new_order)
>> -			continue;
>>
>>  		if (mapping) {
>>  			/*
>> @@ -3643,7 +3640,13 @@ static int __split_unmapped_folio(struct folio =
*folio, int new_order,
>>  			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>>  			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
>>  		}
>> +		/*
>> +		 * If uniform split, the process is complete.
>> +		 * If non-uniform, continue splitting the folio at @split_at
>> +		 * as long as the next @split_order is >=3D @new_order.
>> +		 */
>>  		folio =3D page_folio(split_at);
>> +		old_order =3D split_order;
>>  	}
>>
>>  	return 0;
>> --
>> 2.34.1
>>
>>


--
Best Regards,
Yan, Zi

