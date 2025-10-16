Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CAAECCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 03:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B458E0003; Wed, 15 Oct 2025 23:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB1E8E0002; Wed, 15 Oct 2025 23:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2418E0003; Wed, 15 Oct 2025 23:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 18BC98E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:35:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A22F5116C52
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 03:35:03 +0000 (UTC)
X-FDA: 84002561286.19.35F1F36
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013040.outbound.protection.outlook.com [40.93.196.40])
	by imf12.hostedemail.com (Postfix) with ESMTP id 17CF94000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 03:35:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m+bJaUan;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760585701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IbY5w0xpHPdqb6tVpAeGWvg08nuy/ImobQObg8IyCx8=;
	b=anBy+qypzyDNCpKELyNFLx2tt96v1fTb3BgxvZbnwGv/nrUk+29At+Rlo3fVtY6pakLjmC
	M4YKJakhHrnmpftyEPCCcrdcAzplmlCwWq/lw6PTmRmef7sQJImrGDLcrfEGrDLYhVZq5D
	pXk6hFeE5N3pOvMabVKwDGyydQlBEDg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m+bJaUan;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760585701; a=rsa-sha256;
	cv=pass;
	b=CY/+6D+pIfNNqXnj3uAueUyMLo18eITn8a1OgU/BZ9CwhEuax5+KlgeRBpiYJ48oqW8sJx
	JvXrwbaJy50dh46bXlq+WZSmmJLXLP43eG92LIbnMNOHUdwkvaqRepu54qeaaACMqgPCUp
	pNT/tquEzOOBPd9ikO8hN5kKXZxF9QM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UoqCOZ7UEm81U85i9+IcYf5tLw+tT5f1N8LvsZNTcPG+/83u73blQ7F6XZB/dMNH5AtN9flaO6XGWnDnC8qWzGm0WQeTTZwfuOMFOo3ftkLtrwK3VERkmnGV5ZpNLTxf4DaRrdVFzz6ZvamTIgmKR1xM4UtjCLTrJ0IBJgpWFuyR860fcYm8wMqg6RObet3usU8SkIzDTiKjzUlaNjUtrwyuG/EIcGzRAn9ZWbQftc57LgjfHTlZV3SZBll+9MlNItwvUE4MOriDgAtcf7LzcpruxHx+usP6Qc3fXZaEcr93ntux6d8Oop210ZQdbVtfVsz9//LTZ8Aj8HAMa6Uyrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IbY5w0xpHPdqb6tVpAeGWvg08nuy/ImobQObg8IyCx8=;
 b=WDBUatFIiVcDfRoixO9UTVeJPFLmxDYPooDWRf33D7loZYt/R360Ahd3R3Y4HwEgBaiH+bgbuJspr44PSz+RxH+4VexVId3P9oWAXYFYLxzdqoy6W68Gl1Ba7HveDEJGu7ozGGaBeYyu8oO4BG3AYM2VyUfdxRHflgz+UJqbN5ivZoZNR1DTGYHMgtvUHxZQ72Jy+dFXS7jgPtFIYq13O73JBXk+EuQmvwYEwYpzo1PKvTekqigFfrQXxWGt46361B8A3vOXETm4k0FClhlnBGZBhiGaHRRXGkX6jYlP5ZlaP5E0ez4qGgQ4Nongy6QQvEdCQ46cQsOPfV9Z/1ev0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbY5w0xpHPdqb6tVpAeGWvg08nuy/ImobQObg8IyCx8=;
 b=m+bJaUanMMctmYgpM6Ow/vvsZR2/ugMe4WXf7SqS17todRvA5M8R9zOhdEoZOZpgthtJ1Jqm6aswEdCpVlv3FdIHFJoyFApkxHY0kZxH51B+BXLtCgQ/PenskXOyDfcY2+p4xpZgWayGsNbo+4MzHerLnSV5oIu9/MhDNb9SpDaLVl4XcKqWfng8miJSQtTWWM2XJzVNs9AkUpAZR+dnVbzh+UoZVWEAVR6b77ss9S9TarUDeC50lv7rI1JmkrAQlIQb3vKeICndccDZqcngiM4c1slJAgez8EtjEx/J2AvW2Iqoay1GM9C+rP2769mY8cfprvwEraVkJw7wF2Rm4A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH2PR12MB9493.namprd12.prod.outlook.com (2603:10b6:610:27c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.11; Thu, 16 Oct 2025 03:34:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Thu, 16 Oct 2025
 03:34:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: linmiaohe@huawei.com,
	david@redhat.com,
	jane.chu@oracle.com,
	kernel@pankajraghav.com,
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Cc: ziy@nvidia.com,
	akpm@linux-foundation.org,
	mcgrof@kernel.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/3] Do not change split folio target order
Date: Wed, 15 Oct 2025 23:34:49 -0400
Message-ID: <20251016033452.125479-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR02CA0059.namprd02.prod.outlook.com
 (2603:10b6:408:e5::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH2PR12MB9493:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cce9820-1e7e-4227-4945-08de0c64f996
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JCyE5tvzCprxA6SGA2vqJNEDs3wzjkFHqogx45A5/AkrMBfvHIA9/4ikilA0?=
 =?us-ascii?Q?hRGmiXcojWmDwaNfIjwklu63CCVqyyylLOIQ2udma3Iqxr8Fw9D+aDDQgMzo?=
 =?us-ascii?Q?vOLvMgVNKG0JbLMkzfJPqttSLJw7hDnb3L1GbjCs48GBJcZ7Lmd8aGHSnd87?=
 =?us-ascii?Q?mAHBK0TDfG2iz1l7+3HNzvKqzzHC28D5xYqPY10Bjle8ltvLaYtzbYnReIK/?=
 =?us-ascii?Q?6QNK6Y+VwhGz2GLnXyIcsB9B47aOcyCbj0wZVYajJUfOJgYTLGl18MEJUwep?=
 =?us-ascii?Q?CMrH58PJ/WVpoVMlOtAly0W5QSB0CAq9XfUDWMR1+BknkD5SDp9961jtDMNp?=
 =?us-ascii?Q?BaYzR8s5UwTG8/9DsDnJNNGuLsPj24o4cyG/NcFdRgJQNo7b3kzHILfRPE8S?=
 =?us-ascii?Q?Iid9gvxUgqAhAA3Z5y7Nc+dCGZCtDOyMnHsTI4zP1m/VuK3Hq2nT8QrfJqmy?=
 =?us-ascii?Q?wfPP4zBszEU/znIHTs8OR7EcPXzTUCqkLeYI18lJhNhwYmNrgx3FKR7f7htj?=
 =?us-ascii?Q?GQJd4XLuVbSlqo/HtfZ/SMftSHB1Vw6PFT6SCspSlk/q6pDAK4OKbrBdun/Q?=
 =?us-ascii?Q?Y/63vjZOUuCJqhG/xNj3NFyBkIiQlVgLxzbkjLQYqUWa/5KHRwH6gbV89B97?=
 =?us-ascii?Q?OC9uChqUSqUcohy0VjLA3NWAXR8IJXKTXo+nn9SEkM2OImQG9TCmG7gMJyVt?=
 =?us-ascii?Q?I7GbpG8yqcf1IKo2nYmKhPGmcgMv9+xRdDmeXzCAb1TB5zvPPuwXKZNnSDOo?=
 =?us-ascii?Q?DTYolbwPMs1+EXAPJuZofdxZ+Tvdh5iXrdqOqeuDsQMBzf2NcDGGXSKVku5F?=
 =?us-ascii?Q?UWO9Qj1+m0dRiSu39+7jBNIGrzw/4+ef+EAmRsdOnH8mJxtX3b27GdjPcyUa?=
 =?us-ascii?Q?9BdwsEyDaiDc4YVD+JWv6TTzZT3/TI8rajtyEHiuuhboHmJ0hAdpVPOYosRo?=
 =?us-ascii?Q?mOfAiik3K3zffo7xTfBpcr6+fSTwGISsuGK3zsSSDTzWObFS+IPGo9/Qr+ge?=
 =?us-ascii?Q?oQUkcPYSm9KdHWmzcEyenk18RdGmCv9Mgn9nv8UQLvHt5lyzeggWLaxGEpCb?=
 =?us-ascii?Q?MhEzruXDgs3DFH9cfe7HRRSAlRBe81uh0vEbkQwS39IS/FDcSE/P1vpXgo8m?=
 =?us-ascii?Q?Fxe3JeAxkJ0TNgCfc4NO3OA+8gUE8DY1rRrNqRiSfiHzh+zEaZP6rFgeONEW?=
 =?us-ascii?Q?txcD2K66O7SjGdxCvUFdkHXAIQTfJhogTnJ7TTMyriyi6O8kvSs3xoAIYTzA?=
 =?us-ascii?Q?ASYUS7rMC6O0OjmQoF4Z+cPdXt+QZ8q1eodNuh6b8zQVeHeKhTUOJernIvdN?=
 =?us-ascii?Q?A0yiOaELa7IqRbsvo8xCyEk9pEc+3Hx1c2xeR0khpabtj8KXCxRzDV06rOo6?=
 =?us-ascii?Q?g5M7c+hIf5XXRw8Yfzp3wo08AjTAnwXvJfUcKFDIh/p2zQDS+WWnresX4Dsv?=
 =?us-ascii?Q?1iu/4SzzBwgmUbaqlqnlrvv0Mce8k6mumWs+l0oiHudokKrO9Z+AwA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TWoEi5+QQNyEpKuV1YW6Egm7PVCEq4PoECuCQZs3gMXiBQ4v8VP+TCyRlTNY?=
 =?us-ascii?Q?5y7Veidl0vEjdnUDXZ85xIp5d5O6Tgfk+U6Bilq4DBgGV/8U/P3zVzg0SOHs?=
 =?us-ascii?Q?3E/xthi/lDk5eo+T3s3aZ812pJyHQG/6MNuHSiLFk99A6g6BKUscMLnCpm7h?=
 =?us-ascii?Q?5son8e4s8i99AknxgIHSVJTCOSZge2YAYPWLEmr/TqoQmNCI/Zc3ggg79+Ey?=
 =?us-ascii?Q?A5HYGnt4pz6hwPyyqFE+i9mJ4mMXLoWyw0BmZgGKfFOHdw+jwpHe+uT0O7y6?=
 =?us-ascii?Q?RHKSH88JsDG3FLAXLb+IMwRiN68JvThHXm1l94YFEMae/UxwC1zdrQOlv7W9?=
 =?us-ascii?Q?m2Pqx6UNCvo7Z5XdotMU7k17z0So5rNvb999CjzuWBzdNVN/tFgzAwknfKTT?=
 =?us-ascii?Q?vHC6qDMePiEPsF5vFqmEbP3RuBEK/zeiTyOK0ktt/oiTTq9iKr/yK7VeYHvo?=
 =?us-ascii?Q?74NXGmeNzH0SoEGSBV/u2/dP2LPsdKm5JmZmGcVkj49gbTWnYF1hpGo7+Fdy?=
 =?us-ascii?Q?RgEIyJlsyfy+KoAiEFVj+AUoPZSzBxN1zMvtbtAZqJaVT+PEY8WFOH0iU5lZ?=
 =?us-ascii?Q?q/VVRnEyfVrPzvY6LMZRSJ1j7NKEPkfzjuFcg9/huAHoYiASac+71W2aAqvc?=
 =?us-ascii?Q?Lp6e/PgeGsLL0rtZtCxoQY8oUvRlVRG6G+29FwC3ICUT5vZNeDjLJf6f5YB1?=
 =?us-ascii?Q?ioqEBOZ0j5RwCkJVBa4OK75/vS516ljomMUchrXkeUTxwAjVwNv+J0yWlra7?=
 =?us-ascii?Q?4wmhX/dTlZITE+KyZuxEPXA10APDZGOqDw4MPknK3OzwVjjD0owpXFCQyUCC?=
 =?us-ascii?Q?9NKGv8QdqbJiuqIKhBTuorByVbtorjP1nrVdfo+PdhfwDNe82O2EbRtNTafr?=
 =?us-ascii?Q?ERJjP5IFLpa1b7w8BLoPJ/b877RbZlcKlWMYHV4Mqqs3GXSX37mUVD/qvByy?=
 =?us-ascii?Q?OflQyo4P8+ghNiBmWwFCYQGyzRqI11nTDvLleP6wCh/kiYR+lh5X9U0iNxyu?=
 =?us-ascii?Q?W/Qg+d5HPDfY3R5+TaSjj3G57qne0y9levLuX0IpZkOlIuRvGyf04W1TVw5p?=
 =?us-ascii?Q?ZfkY2jIZvbEn/Tpcsuk2B8ibtT0JS4Hpm4bWfqNGemJgvQE9BUCp2ibueWc2?=
 =?us-ascii?Q?r9p1XML4RltgH7rJDiGAdZSqsDYChL5BQUzTwkOLVlVTybRAPx9+7uwajJQW?=
 =?us-ascii?Q?y4SgqlahK5iczmndv+3Yfa8QCwErWyZv8rn4oZNAkZNBmiD5UUgj1UqDx3Jr?=
 =?us-ascii?Q?J9s8bNNQPTjoW/AxmU6aPCGpY8dF6MofodnXHvxGs3X+dBxsuopUxX1CYrgk?=
 =?us-ascii?Q?f61fLFxWGSZO0ePSbG4dxH2xYWQt18Zu1+qXlMCcZejKKkEdRG7PMwBst87Z?=
 =?us-ascii?Q?HkXjMzAcQ6a8ZusIx+qd+ZVMVyKCczrUzGC0fNdNm9dIXogXqr4NmL7szzRc?=
 =?us-ascii?Q?+UiYMYsdnzTdDChULU72mASi4tiPrBN/HwP6CoTPG/pTJ5xOvTsACPB3HsMV?=
 =?us-ascii?Q?n/JpkG8nfffeiPg3dTT/u8Kfd/jriWaSXaEbTx+rsZXb+gcK6NnuCM60zM6L?=
 =?us-ascii?Q?xTiUUYo5KrUYPSxQBDiYp1ZBC6fPQ9Gmt2EoiuzH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cce9820-1e7e-4227-4945-08de0c64f996
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 03:34:55.8360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TnTIqtettCznmLoDSrSUtQf2HGuXWwq8EKpmA3WcrEFVeXbl+6+4IGHgTVzPfS9U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9493
X-Rspamd-Queue-Id: 17CF94000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1fz5ask96ycwpq41ehq87x5ybuqsrer6
X-HE-Tag: 1760585700-117258
X-HE-Meta: U2FsdGVkX1/2BfdCqJs6GlW6sTyP8ODg5qZUCTsaOmCiScwunhfSPss/UCHTBYbjTaD2jiU+tuW4qktgWOMZEuf62BgLYIUUxf9Xl24tDLyWJCmLf3kastl+ZczESHW81s1ITU/vSEYZui4D5HqZVN9bkZxqQdnEaJbQW/9OKjoOfuyLyllbsQVIc41viPnWf+DsodwwVXZ+5t76/hUK2qEcEpmE9lM8CwEUPUSn2yjC+egUfuL+BOrfLZZHRBgjmt8Hg7tZYYMYkv7lcY/u1EAfx4+ldTfu3WYZr6Sk9zPcuo+HRodmE34rPY8F+C9ZjzEPr9Qv3xlflSNaHdpDp6c2wDfQTWXINyRmMoan/IMldUmwObin8Qcaw5dWVXxZUQhnqLo3eUBdMEsjRd6TovCfEG7vp7e5fZSDDk+X8/7DV+FsYj1qBNugUu5HJOCsr3ADjKRuKERkP6mUbOOwYmxeXoy16MyviXP6Np1Rc5ysh7bUJhSa3BNmFWkc3U8FArTloDYEuMfljx5M9pmGw+x9mPsd7OgtdkvOmEbM0cAzFxJaIMKzs0ZIkpDfEONLvVpt6ttW06vKxlgO4jL4EtmrLVldB+jyOm63FlsTXKFeGorFYynRVqf82ORZpMcOKwCvvU5ZtOHtaUsTze/GzddFb72Q/N9z5HB8nyfj2lFRLmSxVbzNkDCZOTGaax8eO725rS6xyJIczmC43uWLTNET1aRpM2WIeiZXN+ApP1dTd0PxGeklYT1blkhmD1d+JUG5DgdXNTT6Gt5UIIDbHoVzh5x1m1Iuw89Na1VM0Yj4kKEehivS4J3Wk0yWsdBHpMMn91nfX+QcBfYx0wFRDQnlqLclzWcwe+CdKhsyRc/EUpywkZyRkbqv475LdJU7yJX59QDTkH76uSxvlbuN9UyHkMHzUJG6zkecuqH7E0w23DKJM6FfUI1r9v7N1KoQzPVdzi6VmO4KMJ57bRm
 ZS0Ukclv
 xZ4qEoSMRMZ7xhUytW61PMl9nYeTPIhHoGo3twi+/HI1VmHXX4+rkIs7yEdrsv3DhHBua
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Currently, huge page and large folio split APIs would bump new order
when the target folio has min_order_for_split() > 0 and return
success if split succeeds. When callers expect after-split folios to be
order-0, the actual ones are not. The callers might not be able to
handle them, since they call huge page and large folio split APIs to get
order-0 folios. This issue appears in a recent report on
memory_failure()[1], where memory_failure() used split_huge_page() to split
a large forlio to order-0, but after a successful split got non order-0
folios. Because memory_failure() can only handle order-0 folios, this
caused a WARNING.

Fix the issue by not changing split target order and failing the
split if min_order_for_split() is greater than the target order.
In addition, to avoid wasting memory in memory failure handling, a second
patch is added to always split a large folio to min_order_for_split()
even if it is not 0, so that folios not containing the poisoned page can
be freed for reuse. For soft offline, since the folio is still accessible,
do not split if min_order_for_split() is not zero to avoid potential
performance loss.

Changelog
===
From V1[2]:
1. Fixed !CONFIG_TRANSPARENT_HUGEPAGE version of try_folio_split()
signature.
2. Updated the comment of try_folio_split().
3. Renamed try_folio_split() to try_folio_split_to_order().
4. Removed unused list parameter from try_folio_split_to_order().
5. Added information on min_order_for_split() in
try_folio_split_to_order()'s comment.
6. Added a comment on non_uniform_split_supported() caller on
warns=false.
7. Added min_order_for_split() to !CONFIG_TRANSPARENT_HUGEPAGE.
8. Fixed kernel-doc comment format for try_folio_split_to_order(), folio_split,
__folio_split(), and __split_unmapped_folio().



Link: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/ [1]
Link: https://lore.kernel.org/linux-mm/20251010173906.3128789-2-ziy@nvidia.com/ [2]

Zi Yan (3):
  mm/huge_memory: do not change split_huge_page*() target order
    silently.
  mm/memory-failure: improve large block size folio handling.
  mm/huge_memory: fix kernel-doc comments for folio_split() and related.

 include/linux/huge_mm.h | 61 ++++++++++++++++++-----------------------
 mm/huge_memory.c        | 36 +++++++++++-------------
 mm/memory-failure.c     | 25 ++++++++++++++---
 mm/truncate.c           |  6 ++--
 4 files changed, 68 insertions(+), 60 deletions(-)

-- 
2.51.0


