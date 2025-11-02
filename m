Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83632CCFA05
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 18:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2C58E0009; Sun,  2 Nov 2025 13:45:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353A98E0002; Sun,  2 Nov 2025 13:45:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21BEC8E0009; Sun,  2 Nov 2025 13:45:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1337C8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 13:45:03 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6DEB13ACD0
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 18:45:02 +0000 (UTC)
X-FDA: 84066544044.09.234CF0C
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010065.outbound.protection.outlook.com [52.101.193.65])
	by imf09.hostedemail.com (Postfix) with ESMTP id DC744140003
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 18:44:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Gw7rISxJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ankita@nvidia.com designates 52.101.193.65 as permitted sender) smtp.mailfrom=ankita@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762109100; a=rsa-sha256;
	cv=pass;
	b=5OC7p+zv1ZUdPyhCFbFxIbOZQPHHi/cR5YKHBRKgk55gYaAVlek5WP4qqKI55o2yHkC9fg
	kAEnwDPc0gIYbH3H+maG81yxE8L5fH9YVFUmHL0yNn6Q9kjYMGYhK5ydQr37nbGG1CppHd
	Z8qxiJf+pg3LnXMRsEcXjQ1MUBQmckY=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Gw7rISxJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ankita@nvidia.com designates 52.101.193.65 as permitted sender) smtp.mailfrom=ankita@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762109100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+PoeFQBtdd6tvq+PxWLLVPThcvfQiPhoI1YysoCFeo=;
	b=wxgR+u5xdLLCJBvB9J9nzEx2h73URG19/u39qdF2hmTM7hC2h0TmqvWnaic+Ze4Mg/LxUV
	kjPgparK0PxLGRrWfGDyG95KI5R5XQb9apy3g4aytGpmedLqr/LosdQfV1BgWDri1KHIEy
	pPlUwhF5phh+Q4g+/UYjT07qGqv0B34=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IInk9iO+mKsZC2etefRQSca9KUITU8TAPyoXJoMrI+KexRVV2dv34W3yWT/TaxQAB8TsLSST1MUJvYyhI79xsWYNoof8qZ0WSDroYJXBHOr6Rn3ITv3aHiK40ZR9oeOiH8ayb0Xl5z0fRlyUvSRofw/Fl2wX8EkGTq5A1a1eqxbr3Et9DjhIqN4lnRKKB+EnkQ0BwA85R6H8VfhuTp4o3U2Y+h2SXe7yzpTKh6jKtvyrty9I5hGKFNzxf/I/LyJczvA5NGG+2RXcusW7Z3kXjMtTExzPEYP3sBcQXJCMjVsJ5o4IweqQBnJ4p9OPwTS+h3l42ZZFzM/HYmh1VoIWjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+PoeFQBtdd6tvq+PxWLLVPThcvfQiPhoI1YysoCFeo=;
 b=Jq6ohgMcVi5w8bvw32N0kqlwzyaQxQRHGWTwi7Zc8RsaUJD535ptmFqpSn8+BnyEeVyn9Fvm5G97gQvYpOcHR/v0Rop9Ou8zxG/CcxMIH5yJvslUmLrS29GKPuyB16o1wVn2xPbSgKPGc01n0XJbNoESnyXpymQC2eSsEkWEcTNwbD7h7bAxkv7FrexT8oKvdXvtXANkbHd4hQSvg1kIsj2I0PLLRvBtCcaCQVh3YYkTgv3FnuXVtK9ut1CMZU5PZyR4fAJThXWyhuFPxNNHiwzT/ec6OIAEnq0x8nvL/CQ9sd4bpB8hZt+HPDSnV1bJz1TGvTbGqVcVuoySGnqqGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+PoeFQBtdd6tvq+PxWLLVPThcvfQiPhoI1YysoCFeo=;
 b=Gw7rISxJVtSYinqKAVxLlBEdnhKp5njHn4GWfojrflYf1GKdFfzASBkf8t7j/stEeJT7c8mVsaFDG/yIYg3hDZXaNPjuJJ2sA3vCxzmbVpnqPG/3xZPzjZREsWCYFM30rA6tiKshrKzOrKw3ChaCvpSKo1XYhO48UiEQqw3i4idSVCkTBmsCpICSab0zvgTxpbKyI9MeE5PWIKpdWImcDEmbMVWpNjWq4m2lM0YovvxYiNBsPc7my245Pmw8kDP06j6I4OKAKyma8JUUL8C6F4C1G60VUG42qq6c0zMeE3V8fxTqOcMFvcSY2sJShTA/r5JNl0Db4iGZ4VbSgbw2lQ==
Received: from MW4P221CA0030.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::35)
 by CYYPR12MB8963.namprd12.prod.outlook.com (2603:10b6:930:c3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Sun, 2 Nov
 2025 18:44:55 +0000
Received: from MWH0EPF000A6734.namprd04.prod.outlook.com
 (2603:10b6:303:8b:cafe::89) by MW4P221CA0030.outlook.office365.com
 (2603:10b6:303:8b::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.16 via Frontend Transport; Sun,
 2 Nov 2025 18:44:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000A6734.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.6 via Frontend Transport; Sun, 2 Nov 2025 18:44:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sun, 2 Nov
 2025 10:44:43 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 2 Nov
 2025 10:44:42 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 2 Nov 2025 10:44:41 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <skolothumtho@nvidia.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
	<guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <alex@shazbot.org>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v5 3/3] vfio/nvgrace-gpu: register device memory for poison handling
Date: Sun, 2 Nov 2025 18:44:34 +0000
Message-ID: <20251102184434.2406-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251102184434.2406-1-ankita@nvidia.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6734:EE_|CYYPR12MB8963:EE_
X-MS-Office365-Filtering-Correlation-Id: 839be808-df8a-4910-f006-08de1a3fea27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0MTTMYc95tKexXH+nsaEtf5T1LmfXWjaOsX+9WecLhLLaa0EjucticDUA2Pj?=
 =?us-ascii?Q?CFqZXzKjmwGJuIauQkXLU1I2aql/KxfCxq9E9mAjZL1KcwbruEaCmOgmFXni?=
 =?us-ascii?Q?M3qs6tDHlVmQfzOmlY1T2mmQPzWeimZ6wL73Cgf2A3WRK8aLg1PEZzg04mME?=
 =?us-ascii?Q?dDkoM6GxcrF9WZ9fxjlGrJQxD7tmwB672KlpgmhFgnXhj92NceYL/8fYhvYB?=
 =?us-ascii?Q?xNHHIIYKrw4woTxLp73SU9lW5NE+DQuYbs+l41MTanCcNxzocdPQirINSTOB?=
 =?us-ascii?Q?1SyGajjvwOU5kPyC9IDAvowJ4pWYPo70wjMSdDJSRcLP7yQf2pez/R3lNvWS?=
 =?us-ascii?Q?+KuLjp/VFXTzchusG8YiooTvSXsx/IpguuPvAvugZ4Fr2km8+Kw5uLYwQ+Ux?=
 =?us-ascii?Q?o0L5MHfDW8y7wW84kdRf70CQVD/DaAwJauZIadyfqtoJJwlhc7KNZlCR+bVk?=
 =?us-ascii?Q?pbSIH8aFy5tXARWG/B6CWqRwfHUler6iPRwdAkIXFSrSl9a0SPnjkFeQIR1G?=
 =?us-ascii?Q?UltQG9Gx3qJtjAj+pqc0xynMQW1s7w7I5yjR1ar82UP4qYBWR7XuZbDecwip?=
 =?us-ascii?Q?VEvzBzmmoGLyzcp3QaBR9PBkzPa3DYHnF5EgEr1D6aN/9ZB/7yS2l8CEUMfj?=
 =?us-ascii?Q?IswzjSoIMqwRpNpObvTnrmsfzLeyvFNeHTqHdRR9vyfCuwU6Hq/MNtwzoxFB?=
 =?us-ascii?Q?3LzyRWlWb3EXShI739S8UCW6+92cwrfIim55QhKc6gSJ6ha48HOhfumT7sWu?=
 =?us-ascii?Q?gG90rwciCpyy02/Km+pY204uCxpnBsO+BJvTdZb4Lbzu5YgexEJDHXYCERlW?=
 =?us-ascii?Q?ckxkO7D9vqrQAw0sIjFzSFBQ6YtK4wkCKFVG2vx9obgJIa2cJ+YeqIewXMtA?=
 =?us-ascii?Q?LdugQ4isK8t3bC5NXq9om9TGAWFKizi2w9e9RpKITQopBdAg1hVzMORbS5N/?=
 =?us-ascii?Q?rn+6Uz0y38jJ4Cjgwqg3sw0s3O/xVu/5UU6fdZN88ALPeZIG4KOe/Zo77+i1?=
 =?us-ascii?Q?byhuSHA8qGvCXWWXIuHrGrrfmvpNiWf2XURFnSb6sojD9yosatWsb2iTWnD3?=
 =?us-ascii?Q?UbGpl3nehJPBNce5Rl/98Nc2bLEHmBBxj7siD+R2g1Z6rhIs9o0URCAkjORz?=
 =?us-ascii?Q?hOJ/+UWkqBa9Mmkcu1Kt44/KDxChEjyWeJP8+Jrrq8qE/Lw0+V11Lmrs6VSu?=
 =?us-ascii?Q?jWrja/Jj30GQQoR4LWKfbw0/Aqy5X/Uk7dGpAEognHS/6783CQstKbmaNPWi?=
 =?us-ascii?Q?IxZo88BGxedjNNybEO/SzJM34VDXMdpjSFYa6PiLI+d2fQf5LYkkQ1kkSOIS?=
 =?us-ascii?Q?f92OjP13Ml9oPUSkTFlJG+uAz+ezRGAnrSFLWVeJu56AQROVMT/R9GwLcX7v?=
 =?us-ascii?Q?c3VIESBRE9ojbPO9Eb8H4H8Ojv6+pJiAnz30A8qya+krzqeUoW6EVv0NtRps?=
 =?us-ascii?Q?UeHBy3H4ozWtTYh5SrrIhQCWcBH+WEDTHYhRHLyWnG5Hfnq0P2ECRIJe3AYZ?=
 =?us-ascii?Q?gxPZ1FUmHR2/4K2PbjFOkKZyLMqTKVvFZm2D96b8DwbWT3wTtkyy3KLUipUA?=
 =?us-ascii?Q?6RFHLn1G9G2PYeAyJ2GjO5c0e3b/sBDXK72+8tiG?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2025 18:44:54.6331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 839be808-df8a-4910-f006-08de1a3fea27
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6734.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8963
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DC744140003
X-Stat-Signature: djpbn4msat7st6sjtupmnzyspidb3zkq
X-HE-Tag: 1762109099-301904
X-HE-Meta: U2FsdGVkX1/OL3oD40zq1NYVaJvG0DADdDloT3uQvYec+rd03K02w9LnVswKtWTg4ShiZpjzwHZbyQHUttxyvh2/A3RXVUAblh0uMlmCIVsDh0bDPTXZh2WZQKw3I2Hrxx+SxGyXsITJe8ypPU6J0Z8zDC8M7GYaHwFvtHfXnjoltCWUJys/Monrn08GW3h1HlDcSeAq2V+qND+lPCml+gm2+cmrDjXBZxKFjazFQaZbFjF+y7zFDx/4GB2qtUKrmwNvcrf9nnAltga8wfT35/ETWhRrmdmuXIDYoEsk80OQjFVTenYBlEQFLjqDp1GVG9Ae9wFHp9xMNrVBj5v/WtSfGdtDMnV54cDBpZH9rb3ktB2lx3+2bv90fatE9XEyTUT9S4w20thiS1ibpl4cSnJlvuu/l0/QzDJLGInmAagPgcgYWwM9LGi7iDeiwYoKx2pQmn9w6EdNy0mlkjOi4pzwKhyUhlJ9+3+h+Ga8NXw5f7Cj/X0RftfUf02jCt5j+UOQaZFCrS2I9hect111bAezj4DUPI0D0LjpLKHvgWwaBd9fp/htIvoI96htqusejdUoXI6goHkvJpuJeD7Uh8p2hlwYfnV6Q0kmG6+xLDt1I7/Zhx9O1FnQDDD43N1MAC4etcR2urU4qqa6Z8BrZ0vu0IVuCHL5Cqw+l7SGYJukKHWkh77I9Rp1JT95mo90MIVE6ncxyiDLZUwpep8t2XMMa1tz/IdAsdkH3Om/c3kLDobS7PsX5BUzxLszy+uhz/Bx8ekcYhkp2li+CX5dF9M22hzGDbx0IP3XKo0rpjXEhhGVbOxRjBb++yXaMehgQSfLUy8yrNlVrfAXbapFWZFOxQNvgBRzWjvhPh/PkCdvNte14bMvwGM+pNHMqRDknNajvevxLTxWeJR1CvsuTYrxSOBq9O0hgQLg5pLFq5RZ59vWuDEYEUcQWt+cwgvdPdhz1URWigsQZ5RzYH/
 zbG4DUyb
 +XcZuPNyFFaZdBBmeO4ZU9mBzDPJyHLZ3iW+P1xIIYjxqJ138a1gt42mAVzarI3plIyFYVMe2/ZmrD0RzzeIWCAR6jaMCKOCYIbE5W7VdmFzoZOO1lHi+LEJKcIVQ4rjbWSNlEUfYh4dAUoXQw8TKGFtPXifEbEvppm6kY4aPbrgwMRJvq+vxArFJcvS9jc9UPtuQHv7K67CkR37NawMuVg40qAiywSpYjFIfyqmZfzDdMaqVdNclN1wsJKdujOTxqNX3LTN2C988zdcLWodpYqW5eviV8h/vE8xT1Gmg3XIb0Js4DcrbsoCQGhnJhkyQZ4az+F9g6uOWEDQDF3ssYO1OgoNaPf9be1/opQ7o8iLQdgcJHHOmOk8YHRucTYlk7dLdeN1Nm7doXnqu+Rsn9EFVkzcNWyOaPxQx2klqWeB9EuE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

The nvgrace-gpu-vfio-pci module [1] maps the device memory to the user VA
(Qemu) using remap_pfn_range() without adding the memory to the kernel.
The device memory pages are not backed by struct page. The previous
patch implements the mechanism to handle ECC/poison on memory page without
struct page. This new mechanism is being used here.

The module registers its memory region and the address_space with the
kernel MM for ECC handling using the register_pfn_address_space()
registration API exposed by the kernel.

Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [1]

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 45 ++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index d95761dcdd58..80b3ed63c682 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -8,6 +8,10 @@
 #include <linux/delay.h>
 #include <linux/jiffies.h>
 
+#ifdef CONFIG_MEMORY_FAILURE
+#include <linux/memory-failure.h>
+#endif
+
 /*
  * The device memory usable to the workloads running in the VM is cached
  * and showcased as a 64b device BAR (comprising of BAR4 and BAR5 region)
@@ -47,6 +51,9 @@ struct mem_region {
 		void *memaddr;
 		void __iomem *ioaddr;
 	};                      /* Base virtual address of the region */
+#ifdef CONFIG_MEMORY_FAILURE
+	struct pfn_address_space pfn_address_space;
+#endif
 };
 
 struct nvgrace_gpu_pci_core_device {
@@ -60,6 +67,28 @@ struct nvgrace_gpu_pci_core_device {
 	bool has_mig_hw_bug;
 };
 
+#ifdef CONFIG_MEMORY_FAILURE
+
+static int
+nvgrace_gpu_vfio_pci_register_pfn_range(struct mem_region *region,
+					struct vm_area_struct *vma)
+{
+	unsigned long nr_pages;
+	int ret = 0;
+
+	nr_pages = region->memlength >> PAGE_SHIFT;
+
+	region->pfn_address_space.node.start = vma->vm_pgoff;
+	region->pfn_address_space.node.last = vma->vm_pgoff + nr_pages - 1;
+	region->pfn_address_space.mapping = vma->vm_file->f_mapping;
+
+	ret = register_pfn_address_space(&region->pfn_address_space);
+
+	return ret;
+}
+
+#endif
+
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
 {
 	struct nvgrace_gpu_pci_core_device *nvdev =
@@ -127,6 +156,13 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 
 	mutex_destroy(&nvdev->remap_lock);
 
+#ifdef CONFIG_MEMORY_FAILURE
+	if (nvdev->resmem.memlength)
+		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
+
+	unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
+#endif
+
 	vfio_pci_core_close_device(core_vdev);
 }
 
@@ -202,7 +238,14 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 
 	vma->vm_pgoff = start_pfn;
 
-	return 0;
+#ifdef CONFIG_MEMORY_FAILURE
+	if (nvdev->resmem.memlength && index == VFIO_PCI_BAR2_REGION_INDEX)
+		ret = nvgrace_gpu_vfio_pci_register_pfn_range(&nvdev->resmem, vma);
+	else if (index == VFIO_PCI_BAR4_REGION_INDEX)
+		ret = nvgrace_gpu_vfio_pci_register_pfn_range(&nvdev->usemem, vma);
+#endif
+
+	return ret;
 }
 
 static long
-- 
2.34.1


