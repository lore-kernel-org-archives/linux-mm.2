Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B37CD59F6D
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 04:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E446B0007; Fri, 12 Dec 2025 23:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336876B0008; Fri, 12 Dec 2025 23:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2248E6B000A; Fri, 12 Dec 2025 23:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1403C6B0007
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 23:47:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDF281355B6
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:47:28 +0000 (UTC)
X-FDA: 84213214176.04.1C1AB3A
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011056.outbound.protection.outlook.com [52.101.52.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0902318000B
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:47:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ljcUGYms;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of ankita@nvidia.com designates 52.101.52.56 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765601246; a=rsa-sha256;
	cv=pass;
	b=mTCqIsSkw01vLWh0QUPyRcQTg+i5EagEuEB37xUMvQ+swZG3+ZD5aYtWufTEKhWt2j7EOL
	Vvnm6ghM1apjEFTNCuGx1D5ZgECybofMkVysS9BWzneB/TvJBELUe3yuSbfE0o2l8f3vcx
	5MEf0jRoK03c9WhnzH07dMfwEOCq/BM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ljcUGYms;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of ankita@nvidia.com designates 52.101.52.56 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765601246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5PBuHJOBLm0EQ8jCOVROU3hwKF4m4A4pbWtsE59rESU=;
	b=vJwfW59UOJgShfsL5LXqA+aK9EwTYrmLk/lmqGGtfLwJgHLflzNcwXz9FgjP9lO4UuxkzN
	k7nsbNq0hJumIFvIl4Vv4ZAXvb65uDJyqsSVDTbmfldLH79qV5vSSUfwC3TqqExQ68WJtS
	T8eDzYKXHPu8D/ydtFpLC99QyQ8hMRY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YyhgBNseKv7hW5CxXFz3C/aXfxyqWEFzCvitWmjSpk1HV5QEt2o02qWWdm8hUOQDbf3NP4R5MzRyjGfinsZweI5OuHhwXZHxUZ/1gQQQx1GSsMnDNa7Cxv6M+xZ3mJBd0P3pcOcx0876DtGVEOI8Xyu26Sr4HXxrnpxWSttbxbVu6AE35JochjaFvMwTyE+CB6H4xPmeJgnWPSwLtb9DJ4FQmYcrcUaHBnWjCo1LcxcmLujUGM7cpARSTRCNZ/5+GdoeKi8Fc6uxLFTliimxmT1PWYoGyjTawO9A1JzUAcYcevmUiNY5NXVZNeJ4Mc/vQfMdSVN//LNCbuc1pXzIQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PBuHJOBLm0EQ8jCOVROU3hwKF4m4A4pbWtsE59rESU=;
 b=Lt04uILp/zOrag4ehhjZCwfZ1tFMDUXy/yhPv1P8BS+rMIlzkynIF1LSnsUGfLv321Xk1lljPMHiJmvP2MeYYb7qQYu53Lm82bp7nMq9OuEK9czI6GMuQwQdFKOvKSw/mUkQnrp82jDeTNvQhhsuN5t9WWcROGGEYGuTX1u/vgv4LO0Xm3BbXZqyvp+5N1rYoufMgSJezffHHv+bK34mxyCiZpyBm2FnstV6TT5IElxRb8vlJYCBzA6L0HMM8SOWWR+wh9AYOrWPEzecZPmLT1V/osYlM7S7HRkC2DWmxlgYpGNXeJ/uFCi/MYep/PTnrMgWSK/PHhOBTNmj1RMMSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PBuHJOBLm0EQ8jCOVROU3hwKF4m4A4pbWtsE59rESU=;
 b=ljcUGYmsEq0L6bnrkY5dp+xc/6CcfFC8J2oDrsqawhRCoV4jbqtFDG7Rn9i7QTK9ihfeSZeUbGcjAt9pGfgggoDyFkDu+lZ6wlWTyXFlzMFnzTXZFGpL4YPxn/PiC/mfuLlm2yxvXi5IqP5METxngqScvEpSvgwudKvyZtqpKyBDvPrIjh/vlJLygdkD9hSACWFmzPLzV4NubLJonQTJ+DOrvKyNbfSAuLA8qDb3ty7+OklcpnUr8Q5qgtcHdogaQjI/5THGnAhXtBrwKmbU7KXXPZwhLeneUVKmAF5E+lW2iMS1fd/B7h0D/Ywj6Ej58AHdeLR+BEQCGP30GkIh1g==
Received: from BN9P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::12)
 by CYYPR12MB8891.namprd12.prod.outlook.com (2603:10b6:930:c0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Sat, 13 Dec
 2025 04:47:18 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:408:13e:cafe::93) by BN9P220CA0007.outlook.office365.com
 (2603:10b6:408:13e::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.10 via Frontend Transport; Sat,
 13 Dec 2025 04:47:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 13 Dec 2025 04:47:18 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Dec
 2025 20:47:09 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 12 Dec 2025 20:47:08 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 12 Dec 2025 20:47:08 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v2 0/3] mm: fixup pfnmap memory failure handling
Date: Sat, 13 Dec 2025 04:47:05 +0000
Message-ID: <20251213044708.3610-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|CYYPR12MB8891:EE_
X-MS-Office365-Filtering-Correlation-Id: d3dc3e01-f96b-4d96-5e1d-08de3a02b242
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nRzjw/xu/4g0NQYm3of5l67o6A/IIAzVBfHqiIjTy9PvQEmbSfQrAIU5Oe+w?=
 =?us-ascii?Q?n0ucOk0I0Jh98FZ1KfLfinGB0JA3G84WphgmoGkPhm2RfachDq/LanzwOWSH?=
 =?us-ascii?Q?VxgrdA3pNmh0dzTLRLWU06uuudWhf1vcXe7TpA28FCYfFOS9B7SbV/8g3iE2?=
 =?us-ascii?Q?PGnl9jAcBUc0bVnMYPUHjHRcLn46DsNairJM3iEgJBhqzoN0P3NGa3k/rLKU?=
 =?us-ascii?Q?PBZ2s/K34Y51R8ZiM5PQ9Tdh6mvzsgneWUy+EGtJCAg+IOqK036pqsoNKutI?=
 =?us-ascii?Q?sjAy9RdT8Clkbe1exlzakkwEBSc5E/ycjVHq1jnRF51pG4w5oCo0Fqlc/vPt?=
 =?us-ascii?Q?9NVwiOwhZTPMuF4xr5EjR09sYbcfeh7FaDTVj8QLugACyFxrXPQqQH0dnXTc?=
 =?us-ascii?Q?m4qq90LOBI9lyHvbZLCHpslFh0s/eM9LAiKF6M+myYLuS+PGdx0X2o4Yhv6/?=
 =?us-ascii?Q?xKu3PMp89XZSn07xqQiVGT6H6QIbBiMYVZ3WFesTDstnt6ODrRmvpfSTJUxq?=
 =?us-ascii?Q?/WOGmoEAhcajfzFTJwEitP3ce5uC/0AIbXcmz7L343LxazxGCIloO/zgCQYN?=
 =?us-ascii?Q?jdXGiXGKEdiNNNp5lPu3H47eliDNmtGzocwP6dIGI9Pqlh7Iz+fL58ndhhCL?=
 =?us-ascii?Q?I69j6hMKZiP9ImYmbOKEG8mWkrTP0y/9TGiIMFuDn8WuJzeQ8wzDk5hzc/z9?=
 =?us-ascii?Q?ckjEzpxhQT8BdpbxHK6JMbLMns6H1B4HQg+U1uHM7fVrt8H/rwNf/ktAl8ZQ?=
 =?us-ascii?Q?Ah/1ppKAWjQEc885fLcGFXoEeDkBxtB1I7jTBYCZLPM7hvCBG/Iw43OJmG6d?=
 =?us-ascii?Q?RftXIBxVI7ZayTE987AXKrmWk1CYjUXw96/QTb9XzwYzRJUSioeYtI6UQF/9?=
 =?us-ascii?Q?CQvcnDdVZfXmTn0B1lJ3O7Knc4TL4H2NCXWMQbXM5b8UpANiZypHvys4kUZe?=
 =?us-ascii?Q?Yi6vLqefv0uFtASKag/MLFLU7pTcTgZhPn6ulhz+9bviIJLFvgwJjb3Q1QhI?=
 =?us-ascii?Q?Ajeg9YV18H2BP9Ea8nHukZdPRUd4QqxCi6FHBlYNqU2OsX8redGh2rmagHv3?=
 =?us-ascii?Q?xsT48PsNNgL5G2VWPegN1ibwdat8Hw7M088J1yrBPxcf8vSC8EGv+OjDFPcZ?=
 =?us-ascii?Q?TQzOqvP96S5S803+SifVTTxClk9ZCqG8vtpsYjt5qWFFNHBK928NGOqCWaoO?=
 =?us-ascii?Q?Z/RDWyO8tS4+FWqxwbXlQnU58q2oLE9uOfLlDu8UThb1R4EY7bSHb2CT0S1N?=
 =?us-ascii?Q?IE01C0qxfhMoua0/nB39L8p/jMDrfNd5xJkCLnFf0ZZ6eTYS8qQRbUrcz+bW?=
 =?us-ascii?Q?WzxZr9VZ4rrTK5J6kFZczjURvwDZFc/z9tfXkfeXii0YcP9Vs8Utx4FE4AJD?=
 =?us-ascii?Q?UD+oW721O+eODQzh4VFpkJuC6N5BiJdt8StQSBMEgNHQCdLYnoOnXLqCaB0Q?=
 =?us-ascii?Q?DN67/JyTgdp+BF3Wysy6oUdhCTf9ibKRDvM69NcglwhTwmAn4v8gbAloCCED?=
 =?us-ascii?Q?lvszZSAGwAKbDEG4yJUu8ORnN6b/3rCLXoBWQW9EeiCWHfnAnIq+x2iY0KS7?=
 =?us-ascii?Q?t2sOx/MJHIPBwK3E2OolVh1a/ChJGTe+GsJNoh5s?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2025 04:47:18.6575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3dc3e01-f96b-4d96-5e1d-08de3a02b242
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8891
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0902318000B
X-Stat-Signature: 4co9ei4duwek8byygwmobpf7psrxfwtm
X-Rspam-User: 
X-HE-Tag: 1765601245-157695
X-HE-Meta: U2FsdGVkX19blqlqzuVCyYdthhdR+okawWhF3zw8p2f3RXxstvNMYbeo7tGL43P4AsOO+MciQ+VQ4+AfgPYgw0laaB3KOUSF/CAj7p/aurkICciNT/FqeR9HXFfhEtEw3JR69p+I3bnWNfebhxiADnh12x/wau0OdLqbbiLT2Vg9gZR1q+0DBA4Ka/CfBybxePKD0weKvVpmtF+LmBN1gpHLmy5ew9BZ3CpwJPFtDgaKmLmWRag+kmQq0flTfHya9yhHoWH6bRf4HyM4emZZI2wFBGWyfexzKQjwkor8qU0KFE6WTBEKTK9dRI9hNNpUM0fraiuao79LPJEesIombu9JCXe3KdkXeiT+uLtrrE+asawq+3xpE5hgD5P960fcBAid5QUmC5tq2h3Uw0BHfyyyjVWgd4XKtebGMqEnuEp2iiiGTbHhtCkt7blLO7LDpdC9cG8W2oW/QJFVX5LFbGxr6dR9x3ZXaxQMHXyQxlOqe41u0SkRYSwl1wbEcJnPF5qf8o0HLA8PcA/o14pSrIUHb2puZnWNL4AOQKqN+wumdeQ/MqRTpJRGSCTdH8I29Ps6dd7EInO01JXBirm4r8oWD60jLpmIvMqN+SNAJ0M0TJ5VBZNJzSzGbfYIz0/u2ozUNnrSZSXTgWJhdHjpHTaGQlIPKXFPZWQ2aDU3qbc8YbgC9HAlXb90PO+xomqpzqpokg3DVBU1wys9rPsGECdNNO3pFsR8ztOhjdB9lYhs86//3N1KbcWlvNlTIpBJ/utoTk8Dna8vzRoISlovgJy6i4JUa5AurjzNjj7kksWfcXXChzo19KJipx3yJ2ROqzIOtZiJOIeEKJ7uv116OpfqFHeFJ7N95ITnM2qlY7ywH8GX7QW9J6B4AJXgafF19cF100M8dGgj/BMWmbae7t3cisgAxH+kDG/p/NvpclGWFF34T+OAPtK6wAQPXE9+Pri9YglphRWnW5v6uoM
 MRDQEU0V
 NLrQQSxSmcYsUl35B10PUIEmidj4e30aROktP80dVEWXkwWYowqgiOA4zxTmLocInuZoQx8LxRjCEW8qPsARYc7CbFjXOhim2GvNXlsURd+22r1KeIV+ttN+6iLfIck7qO1p47Y3ifRTaVTxwMo3Fe2YCykwdNmNy3lgh+A4DvGwm9NpvWbs2YV8HsITK3irB8VZKqbVKwJA6Ca26pXoZnpRcd0zqn6U8ny19zl/U4wfxLZUUSk+E7c08YjkWTmjAHP2lrNxrlZJQrgLx5/qtOFGdITiRZXK8qwyojlTYHjTwAxiVnZXf6ssqM7ZfIZMOLnTqmmGfTfPZ73Q7dfGWc4KG1YUa+TsTmW5t53TzgzYFqN2xRGcjnNhvDrFANkX74zh8/m15yDnvzUV99S8RCGgGrW3GuyOwMqIouLrW9ZTl+4iHPNQYbDTuSVjObFSqGrh4iyFpHmOtMEf7y8fj5V5teOYCTSFzJRmwQEtNrdy6uwyqxvX2UmyMI9fHom5603cfTBEIkwGOZRCOeWZMCWIv9Id4+K+Oi+KvO0GjD+Xy9Q0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

It was noticed during 6.19 merge window that the patch series [1] to
introduce memory failure handling for the PFNMAP memory is broken.

The expected behaviour of the series is to allow a driver (such as
nvgrace-gpu) to register its device memory with the mm. The mm would
then handle the poison on that registered memory region.

However, the following issues were identified in the patch series.
1. Faulty use of PFN instead of mapping file page offset to derive
the usermode process VA corresponding to the mapping to PFN.
2. nvgrace-gpu code called the registration at mmap, exposing it
to corruption. This may happen, when multiple mmap were called on the
same BAR. This issue was also noticed by Linus Torvalds who reverted
the patch [2].

This patch series addresses those issues.

Patch 1/3 fixes the first issue by translating PFN to page offset
and using that information to send the SIGBUS to the mapping process.
Patch 2/3 add stubs for CONFIG_MEMORY_FAILURE disabled.
Patch 3/3 is a resend of the reverted change to register the device
memory at the time of open instead of mmap.

Many thanks to Jason Gunthorpe (jgg@nvidia.com) and Alex Williamson
(alex@shazbot.org) for identifying the issue and suggesting the fix.
Thanks to Andrew Morton (akpm@linux-foundation.org) for picking up
1/3 for mm-unstable. Requesting to consider the entire series in 6.19
as 3/3 is a resend-with-fix of the only user that was reverted in the
original series [2].

Link: https://lore.kernel.org/all/20251102184434.2406-1-ankita@nvidia.com/ [1]
Link: https://lore.kernel.org/all/20251102184434.2406-4-ankita@nvidia.com/ [2]

Changelog:
v2:
* 1/3 added to the mm-unstable branch (Thanks Andrew Morton!)
* Fixed return types in 3/3 based on Alex Williamson' suggestions.
* s/u64/pgoff_t u64 for offsets in 3/3 (Thanks Alex Williamson)
* Removed inine in pfn_memregion_offset in 3/3 (Thanks Alex Williamson)
* No change in 1/3, 2/3.

Link:
https://lore.kernel.org/all/20251211070603.338701-1-ankita@nvidia.com/ [v1]

Ankit Agrawal (3):
  mm: fixup pfnmap memory failure handling to use pgoff
  mm: add stubs for PFNMAP memory failure registration functions
  vfio/nvgrace-gpu: register device memory for poison handling

 drivers/vfio/pci/nvgrace-gpu/main.c | 116 +++++++++++++++++++++++++++-
 include/linux/memory-failure.h      |  15 +++-
 mm/memory-failure.c                 |  29 ++++---
 3 files changed, 143 insertions(+), 17 deletions(-)

-- 
2.34.1


