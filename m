Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D89D0F589C9
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368D06B0092; Thu, 23 Apr 2026 09:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319B66B0093; Thu, 23 Apr 2026 09:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209DC6B0095; Thu, 23 Apr 2026 09:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11E1C6B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:15:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43A121B6DDE
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:15:14 +0000 (UTC)
X-FDA: 84689866548.28.29F2604
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010066.outbound.protection.outlook.com [52.101.46.66])
	by imf16.hostedemail.com (Postfix) with ESMTP id 78B71180010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:15:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="CaK/3ye3";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776950110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gG4I47J/Bn8e5ZZJWzb1rpu7Wc7R3+XdnbHMkkrbrbc=;
	b=6FkRV7MK70AGGk7/yTbNUhAw8hXYknstPMYsN4U8yQ8exIG14rpGV1KYcYeF5xpWITLRni
	zvPpKbabZQ7XH/5e6r0rTmvjVlRy813+g2rctPEMwtqjgxXw+8Eje8hELfpPuodfPrGFrP
	odcdXJijcgiCFiiJsvGeSJ+fyDp5pVg=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="CaK/3ye3";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776950110; a=rsa-sha256;
	cv=pass;
	b=mMtzSgVnwDF0h/NRNdoKZzEB4SMWj2x21pj4TUR11MZgP2sOYW6EhMgFbu/FslPzDRGnqA
	XstRATMGkpjCHfLL2Tx1UGmOHumOJaAZ02T4qdYuH3NCryV7WjSqxJrVW1W67eyfdXA50F
	VDQDcNSAy/hHfdHFDM8JWiq6CgHonuY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DU/dauDQ/OhxaWmh5PTRtHxhCE4+VYvwwKoR6dg8ZiyV/PYVyAM9QC/39GeTn+ICjhrHm1wunbtIpA5K9nEN373C3oLeQ9PeSYECQGJt5Ffr9I82AL+ynwQM3KdpzK1pHXwsRa3Ge5KEay5melL7S8mSBlgKN0z5K9SNay8eeNIFMs3zlvGBoFFWkg7FrxBsFteh/vMlLatakLJeXTmY6pnT+m0SLXcu4inZGED8EFa/LnpoFhtLKvqEcfcRqtHLSSSIgBBAU+5ZhEv7qHFvUwI4PQI4W5PHx/uut4EanPc4pn273EQ8LZH0KtJzm92Tp+aAS3b+U12souSVhnnnDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gG4I47J/Bn8e5ZZJWzb1rpu7Wc7R3+XdnbHMkkrbrbc=;
 b=tC/YTKz4PZg1ber7OpJkc4ZSZ2t5KYtH/M+1KF5LqB+04DZJ+zpHvYHe5GlRDl4fdk3hqxthoTPbkwfKLib7FlZRyv9MLU8mMeqfTPWfeDxaHNgekXXDw1sBnCZRqaD4bzMI2RyE8RWi6Iaf8zLcPeMIAfEpMX29hr++G7Qv5bnn61ybodccXJ1DMoye30sDSwMATk2UgJc+456n8r5ch0Gb1EkSLsIMCrENiodz52k8ZQfJmJWW2z4X6Tiyrf2VThlr26l78fUXa5YvOWD3CRASTFOZipEqipBPa3ziX8WWFJUrTadf+uXDf7lSpJUv8liJfL0qr67s6zw0/mgdYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gG4I47J/Bn8e5ZZJWzb1rpu7Wc7R3+XdnbHMkkrbrbc=;
 b=CaK/3ye3RzodMa41sed3u6UwmFcdWV+p/KDZa0xMe3UDNgg1KZ77vzzjtMLKtxjfTm5U/G9h4+vkWVE6rR0XyI0qUMDiskYZ/A1+rMmtkqVKEh24qELjmSleW0CNGkqYLd+hHC9przofc99L6BFj1aQYuBsX1R3jFgoilRvjsZIBm+h2SeD5OZQbEK1VoLdsA+UE1mJ6uQ7hIIYMX/e3gUDQPr+AuRCdD83qozLC0REaARhGyn7OoWZsSnVqSSTc9x9gUy/wYZUA4VRKcHzUGNskf3I8YFej1RHSs32ckxP0JlJqNBrXNox81xvmogZcPvt/6R4O/hQHIm0VaI+h6Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9196.namprd12.prod.outlook.com (2603:10b6:610:197::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.22; Thu, 23 Apr 2026 13:14:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 13:14:58 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: willy@infradead.org, songliubraving@fb.com, clm@fb.com, dsterba@suse.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v3 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap()
Date: Thu, 23 Apr 2026 09:14:54 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <966A0E3C-F483-4C99-B74D-5B74A1F966F0@nvidia.com>
In-Reply-To: <20260423083050.68509-1-lance.yang@linux.dev>
References: <20260418024429.4055056-3-ziy@nvidia.com>
 <20260423083050.68509-1-lance.yang@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR04CA0187.namprd04.prod.outlook.com
 (2603:10b6:408:e9::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9196:EE_
X-MS-Office365-Filtering-Correlation-Id: 0408b226-d2b9-434d-5985-08dea13a5188
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2l8oSeDjzd91smR+9qUWxs/3aDJuLtsV3pAAirL+lM6JbIXCJ3+IWJPYGr4axRPzHvT36J0MGMIIHD9GIyuYCIu/2NTFHnct41MkivbACzKUvFTuNXwOPjiW3KgD98lgSODGBJzbHDe+gxKhk+x5hJqKiDISix/8cMmu96ZDLdwR44nvd4g/57iGChQ/TShaub9t4By5PhLFfCze/mnx4KGodfDGGZKqnqL6FV+/PWm00pO46B94CTBFFc2OLYpzrD9w2r3U/a3FieD2fI3layWpPbRvxaxzIT7FHaE5f+7BKkMHnkeiebmhJlBCvtdPtztCoK+6Jrr6Oy71IoisX4Zs9dSXbhixb8gOrF6Mr/3Hwx3squRD2srB9wp95sGEP/2/0BjD9gthiP2CCLJqTQhYavg/AcztW4qhe2UizIs6mFO8tURu7cM+IIY7NmSPyY/srP0dLjoyKlliH040R2YhSRnl+NSfRDHqT/4XH6BubV1Gt4Ws8nk/NC2Jyav+eEqSK+luNDi8bCfNRblNxsnwdNWFm8KVSB/HGSYkQO9cmcgiuctCXSA/Q0EOFIfq6QsgmOQ4SK0iH85AWlpvJe7NLveArPTRfEfhyctis3SOSJ1lSV6wdOd4j2l/cmcyB7NN7RSZHGDZ252uggTeMV8NR1DVgO0BbEC2bXPWzNrsFWYwXFzl7FUE70iAjreSLzyS4n5hbfZCZk8v81tihtX7uJqsDUt6PKd1DZRDs10=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GlGQlSwE2wxO8D/89gB0xW72Ra8596ZCYLDvrwQd7rxRNTTzqFRBt6W/Cq3P?=
 =?us-ascii?Q?GGt7ZA4nsTKZmX3xmk46kbQMKJWzWRMW4mHh6oNWO8UeU73LzSYKTxCXDECJ?=
 =?us-ascii?Q?D3uWSsPiUx7mVPpjmks6q2zwNeu4WT3i7ET9WYIbAhKVyZTHlZ/FzpsyaNlH?=
 =?us-ascii?Q?AIUuyXGAk8fCRfjXC5P7krWSfg0SS+39fxjd0Fz2GzHSyFcB9sCCtUMMhtaV?=
 =?us-ascii?Q?WLGmsVoltNXpo6wHEu6n9auUyaJoKbQrrNbNhgeW15ij1ucX0T66FS7t5M5k?=
 =?us-ascii?Q?8g6+YfjsAu5y/tia2XWfkn3M5OepUKPg8dmVinw0wMoecb2ob27p87eic2Dx?=
 =?us-ascii?Q?L9kjCOitsyK3nbXa4KhEcxpa5vvkDQZIxT8jHtQUW6Asbq+iTZE9Hqxy2yuO?=
 =?us-ascii?Q?xu7gf1bkLUVTfaPRg0w403fqu/OVMZZGBxSM/4bCKckYv+qMZwx1eRXRULmM?=
 =?us-ascii?Q?cATz2lRkQqkzu9I3RZAqJG2c0ENUFyusOCD8/D6bwFMBvQjHezgbjlds1IYe?=
 =?us-ascii?Q?KVWGNXlQ0Ns18GnQBAwiltwZZ0qP0Ch4iretaeylEcbUij0REuzDUbguhHH8?=
 =?us-ascii?Q?EcV1vwZLjxJvtNwyvFOLzUVHr4fok0QUeGQMAzEhvG3ZW9xfBT7WUfjEB0UE?=
 =?us-ascii?Q?P3YWPH4mFOU65ezZOWkeLKUeE+SKF5oFbQnkW9VTmCnwysLs6JPp7eF79ttN?=
 =?us-ascii?Q?gAyQliSzJPVL/gaApMgVkPFxI8/65v4o6gGv3EaMzQuqnH3tlEuHJmaYY3Ek?=
 =?us-ascii?Q?hci2Vv6lTntalQ2H8IozwnWNopvWbwijaIS5IBljA+jA9HfVWwwCjpTfvrHE?=
 =?us-ascii?Q?tCew6UwGUWpyou2kA4vL3xGUPgDRuW/CRWk2ax0/veQcSGg18LoM1qXCRVPE?=
 =?us-ascii?Q?dG8RYfhe9+TK0YTzjs3agyND+qCuCCyuI3i3kq6282r69JoQYYJHJbrbaVAz?=
 =?us-ascii?Q?zoZuZLbvI97PTjfuKcfydzT72PC2fDw4hhpxAwMdx1qnaMzrs7FQKN/XvYt3?=
 =?us-ascii?Q?5uTgYV8mRixs997jPqdsTRbzJ94V9e+GMS2F6s3mBDUv3cfNrju9D57KmYwi?=
 =?us-ascii?Q?afJ+dd7+wi6TCJQS0WZXtIeIF4/cr0jaT2NIbqsyviHDAUKlLA1gqGK1EiDl?=
 =?us-ascii?Q?QzjlmYNV1DRvKnUv5c5BOcFyuL778E3ok7KTUXfc/R5abxOnwh8C3p6KM2HI?=
 =?us-ascii?Q?dkjM/vnnPEycfEMbJlTSjalWBBDh6scIfDDzAdojVcorJlaX4bEfCFn09pcC?=
 =?us-ascii?Q?di+JjIDLtLUY4CynJcMRCpw9RZ4fA3jtUiUuQoYXPWSxXbSOFiU0A8aifB3L?=
 =?us-ascii?Q?eHw+i4scttIACnVpa9ZYBtSqziRyVQq2N5fW6RErrhlKUi2SShyMQ804wxxe?=
 =?us-ascii?Q?hfDbcKcC8Dj1NhZVRcYi1jN0CcE/i3WhaqE6J/omFibtQaosT2KFCZ78X1pi?=
 =?us-ascii?Q?ME4VbrOFvK1cITSqRUHdDDztojXH7hXb1mdl/jTmOF17OUmN6/gRFh8lt9mX?=
 =?us-ascii?Q?cqE3jRfhu/sS1guRZDDRdlaX3uopW+ggeJsmVLThCPdbtcdwh+k9xp7TgF40?=
 =?us-ascii?Q?pJksM5whSFU2yNYRfS3VxwH/QhRNpTRTiBUrgW7yYwJFLiDZcE4Ud97p9fr/?=
 =?us-ascii?Q?PcIFpVggbwGZGxHLRLlwFAz0yZN8emG/OT/UCa6WWq7goCuVaW2cWu7o0d02?=
 =?us-ascii?Q?1nCeOWhmSji3YE5LJMyWj+xThw2SouvleS7Rvsdv18awfyCZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0408b226-d2b9-434d-5985-08dea13a5188
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 13:14:58.3336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YguAnK3U1GPy7AniWjMGcCpfZvzckNDTyC4MYOYNEAplZSLGgLx230FbIABFWA5S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9196
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 78B71180010
X-Stat-Signature: o6noxrsaqc7kyzzngf7n4a4jj8x3ea74
X-HE-Tag: 1776950110-911733
X-HE-Meta: U2FsdGVkX183Du8EpbVwDFcjMHRjssapMvLundsEAqrU5v87AbN1+xMkffBkTYvnCVh4R7dfUZjMXuA/rIDSa3vJs6BPkmS9yWtc/51egTZPLH3JjpD/+oTa4QrOWmPZCNhlg95zfySnH7WVj5NVtDay2+q+hWJzmLy3ZbQaB63903a4E7gzYXoISo2p3nePmmdeVwBSHQWqIKTa22lT8+b42AUrZvyFb+sfgYysRP0/gwdIxtHq7lzChDrlmUvC+D+LE2Xy4AUAvMABWDn8ki0oHMrx9CDXcbvzJ/zD8JXVhZGJ+m4mSlyVGQCV6zKbVrplmYPLVd4TsQ3+l1Uoh+Tqz4lR3O0oWiZEINqg64JVeY4iknkztbyLcCEcYIMjDm8ZiGpKsoCbBspLSpPtglMzWb5lXLnkGO/R2vdWQnquoP4Lr/MefQUxQ4hq4LZtNfTw0JqK3SgZImwXbQZXY+0x9UUH1IgNsiU+YlNNrxIPPd4brxq9RTgPyZfa1ZjkRcK0xS5hDxP7jGCnFmjdIPUy9djplq8956Bbqit6iwuSVD6hAXi7D2RL7Noa01Yjirt+zCsDxuXeRiVBkSKzKZN8nRoJBhGsYyk56Qbul8watD8dg9tIHT2cEyoapQCJIPB3EzZRJDRiZ73DAYKYYIAycKDqO0BukCGQWKZAiaiEC25RY0KB2zhCORxc8BPDQZo0fx9WJw8isfH+rER/caYgXSl3Xxr4Qq961wU6T7buaxQxd3cgC6yrPFE92rECa0kOPizJPVC90PAVbkFDghnVUOYwJwbMNFA2VOI8n8x2S+X8mbPn2m8q+etFRsA2v2L+qMKlB2rwsjsORUiJOGjJt6H/BLpPMJSnTg2YeWqFcJrKc0/dvs6Wk8vxvLYlfk8wxlh7tHSZL5cJaKyVPvI1TBNSjHWa5PrbkwUA8Kn0RmyhCo0dyU/Xc+VW/+ZMSdY1rX6O8ug+6ygUCFg
 7vIs20GM
 zMJ/koIJMe6bhhBcpA2rx7Sv6Lwk2qMU0ZCxlDy1MMxmH4L6zyiYXju3WQmhqVsUt4WRbrTARLkBZVowRxcj1GTmek5rv0Pk40Xd9GdjpYNn25VdvQqT2tbqWLq1F3doMcZ3fG9yGDbjnK0GL5SsCg4rXvkgAfmIQ7hDoMyrH7XR869oKt/0cJbK53dLhm04JzUKMn+m1beiSo72Ah0CebQNoknWfnZXoisEMYx68avon6PWt5pvElgWv6OENrep02k7orlvE5XJPHbfm/mp06drRvAhpqdZCM+Rbb9Q6AsMb99FxPkeYVSEWnKxM+TjxwjWHJykuCBfHimMkCv9H84zUlDl/VEpAeK5r6Wdm8kTM4mcOOaL4ZhFy/gX86kPDQbVwbEXFiJemk9DW4CVP/++Xa//gVf4RhAPj1fRJxNEnrCCmiKYaPyiBLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Apr 2026, at 4:30, Lance Yang wrote:

> On Fri, Apr 17, 2026 at 10:44:19PM -0400, Zi Yan wrote:
>> This check ensures the correctness of collapse read-only THPs for FSes=

>> after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporti=
ng
>> PMD THP pagecache.
>>
>> READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_t=
hps
>> and inode->i_writecount to prevent any write to read-only to-be-collap=
sed
>> folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and =
the
>> aforementioned mechanism will go away too. To ensure khugepaged functi=
ons
>> as expected after the changes, skip if any folio is dirty after
>> try_to_unmap(), since a dirty folio means this read-only folio
>> got some writes via mmap can happen between try_to_unmap() and
>> try_to_unmap_flush() via cached TLB entries and khugepaged does not su=
pport
>> writable pagecache folio collapse yet.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>> mm/khugepaged.c | 25 +++++++++++++++++++++----
>> 1 file changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 3eb5d982d3d3..1c0fdc81d276 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1979,8 +1979,7 @@ static enum scan_result collapse_file(struct mm_=
struct *mm, unsigned long addr,
>> 				}
>> 			} else if (folio_test_dirty(folio)) {
>> 				/*
>> -				 * khugepaged only works on read-only fd,
>> -				 * so this page is dirty because it hasn't
>> +				 * This page is dirty because it hasn't
>> 				 * been flushed since first write. There
>> 				 * won't be new dirty pages.
>> 				 *
>> @@ -2038,8 +2037,8 @@ static enum scan_result collapse_file(struct mm_=
struct *mm, unsigned long addr,
>> 		if (!is_shmem && (folio_test_dirty(folio) ||
>> 				  folio_test_writeback(folio))) {
>> 			/*
>> -			 * khugepaged only works on read-only fd, so this
>> -			 * folio is dirty because it hasn't been flushed
>> +			 * khugepaged only works on clean file-backed folios,
>> +			 * so this folio is dirty because it hasn't been flushed
>> 			 * since first write.
>> 			 */
>> 			result =3D SCAN_PAGE_DIRTY_OR_WRITEBACK;
>> @@ -2083,6 +2082,24 @@ static enum scan_result collapse_file(struct mm=
_struct *mm, unsigned long addr,
>> 			goto out_unlock;
>> 		}
>>
>> +		/*
>> +		 * At this point, the folio is locked, unmapped. Make sure the
>> +		 * folio is clean, so that no one else is able to write to it,
>> +		 * since that would require taking the folio lock first.
>> +		 * Otherwise that means the folio was pointed by a dirty PTE and
>> +		 * some CPU might have a valid TLB entry with dirty bit set
>> +		 * still pointing to this folio and writes can happen without
>> +		 * causing a page table walk and folio lock acquisition before
>> +		 * the try_to_unmap_flush() below is done. After the collapse,
>> +		 * file-backed folio is not set as dirty and can be discarded
>> +		 * before any new write marks the folio dirty, causing data
>> +		 * corruption.
>> +		 */
>> +		if (!is_shmem && folio_test_dirty(folio)) {
>> +			result =3D SCAN_PAGE_DIRTY_OR_WRITEBACK;
>> +			goto out_unlock;
>
> Looks buggy :)
>
> This runs after folio_isolate_lru() and after xas_lock_irq(&xas) ...
>
> If not missing something, "goto out_unlock" would leave the xarray lock=

> held and the folio off the LRU :)
>
> Note that the block right above does call xas_unlock_irq(&xas), and it
> also does call folio_putback_lru(folio):
>
> ---8<---
> 		if (folio_ref_count(folio) !=3D 2 + folio_nr_pages(folio)) {
> 			result =3D SCAN_PAGE_COUNT;
> 			xas_unlock_irq(&xas);     <-
> 			folio_putback_lru(folio); <-
> 			goto out_unlock;
> 		}
> ---
>
> So we should follow the same cleanup as that block here, right?

You are right. Will fix it. Thank you.

Best Regards,
Yan, Zi

