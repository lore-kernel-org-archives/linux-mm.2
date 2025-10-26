Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73741CCF9EB
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 14:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C80A8E016D; Sun, 26 Oct 2025 10:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678598E0150; Sun, 26 Oct 2025 10:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2D08E016D; Sun, 26 Oct 2025 10:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 391478E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:19:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D6B7D87FD7
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:19:41 +0000 (UTC)
X-FDA: 84040473762.26.60EE230
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011031.outbound.protection.outlook.com [52.101.62.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0041D180002
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:19:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jvGcUot6;
	spf=pass (imf16.hostedemail.com: domain of ankita@nvidia.com designates 52.101.62.31 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761488379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNIVFlRtuevk6wMRAs3kl7QZj2pt5+QR4uhVt4OoXqQ=;
	b=kFut2+rGJDXiZ+yPLxLhoY+YpPpRq/iuo7jgfCOkX79/MkHGueJ/vHonSW9msyYicwn4f5
	gHTsMb7qdFO8C0h4+ygIzrImxeR6GB8o1NOHjslB1ZaKH2LyDawhOsFWjFaWjqcIvjWMsi
	unjQehD7VM2NhohqiB+cZ+McVI2rz94=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jvGcUot6;
	spf=pass (imf16.hostedemail.com: domain of ankita@nvidia.com designates 52.101.62.31 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761488379; a=rsa-sha256;
	cv=pass;
	b=Hdh1XEf2G6Udda8GfhB3xvB8gxULZ4j+nNAfLS7hFL07+Nt6dtAlONP9cpDICf5cHpdpaV
	Yg3GtVEXTZ6eHmANfFL5VaWKfnGgkAnZ92/iUm5WdXC8EP/rOjAkNSZGZ3PKD9SgNz1KtP
	PtttKoNxA3+BmXXJxDiByAQP1V8biuc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UTXYciZKGQqU0OmEF+bf3mqbBJg19UaEPKS2Ex/VY/Sqnw5YgJInCFlQdRTECX3oMjg5ELRHMarP8J35ecmy6Y906aQCDnMEu0XryVlU28CC4uv2PHYwIP8/Sr1jn5aAp6BSG9wlEF4iYKlEaoCY80cpLJKxGcIWEJGSAiO/C7zwfLHEQ7LP/OC27cPStcqY64Oz1Ijki5cmrqEO8skt1tqWs8iSXFly0xI9ggXKhrM6qcWMFqHTUh0QB/PJibl7Vf4oxNLZdpdTwBlJwiDB4Kw+bLckmXB9iR1/4DIsoKLVYDV9I7Ta7ZW0fpTTmvYJJZoD5sd3s7s0v8Xv5t/fuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNIVFlRtuevk6wMRAs3kl7QZj2pt5+QR4uhVt4OoXqQ=;
 b=gQp2tKT7OsJ0qTSCvLbNfsC/C1KuA+5QTZkcJ6RTbtDEdq4YTuq1LM/+M+wBjo7HAWg9rFJYwf+84eBLqEW2gCX/8VCIbHo1sOaHfSi2dqPyJXZkKq4t3YfRNrGjkF/G3ui2mjWxMAW1arBNuMF28FQTJQlXGD7/3gcvwQgR5EKliPTUHPd8G5ghf05tDfQ40CzCreUHRJ4w3R07b0EHA99+vRjBHqQgrmuxCxyKf59k0EqTTmOK52FtdAVIipu7eq6vOOyAqL56VCFH/upCN15h9ZOCkQlojWphZNq7SL1vBObtfDE4UdeCTU8Zxo+1+CmyAs0zziXwiyAn66vang==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNIVFlRtuevk6wMRAs3kl7QZj2pt5+QR4uhVt4OoXqQ=;
 b=jvGcUot6cClLq6EkJdK1tCIE+PElDn4GPlvGpZwtQDpaZEhCMr9LtBp4XiPkW9Zn91Mu5Dl5jZ9a1e5qgfRV8n/65IYW0rZC/fNWIYN6t8XJGRzozwXEz6pfk11Qzi2Ybbr1g7/Hn3uhjxkbhts2MNOx6T9Tu0u4GXKvj4ICb02jy0t/+88xeL5ReV1e2NdEUpfRzZOVrZbiGcjhirgtxzOfqt39tsBebSkC/gr7Qs3sgyuQI1kE7rITtupvTs9OGayi3HZ1GMwJUKXC9Vw+0JIXbXIDTTQ5BVSMnp20NPafCJtBmMbygWJdfqE3V8O1kA/UtkaBCrRSuKnu754CIg==
Received: from SJ0PR13CA0141.namprd13.prod.outlook.com (2603:10b6:a03:2c6::26)
 by CY8PR12MB7754.namprd12.prod.outlook.com (2603:10b6:930:86::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.17; Sun, 26 Oct
 2025 14:19:35 +0000
Received: from SJ1PEPF00002325.namprd03.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::f5) by SJ0PR13CA0141.outlook.office365.com
 (2603:10b6:a03:2c6::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.11 via Frontend Transport; Sun,
 26 Oct 2025 14:19:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002325.mail.protection.outlook.com (10.167.242.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Sun, 26 Oct 2025 14:19:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sun, 26 Oct
 2025 07:19:24 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 26 Oct
 2025 07:19:24 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 26 Oct 2025 07:19:23 -0700
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
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>, Shuai Xue
	<xueshuai@linux.alibaba.com>
Subject: [PATCH v4 1/3] mm: Change ghes code to allow poison of non-struct pfn
Date: Sun, 26 Oct 2025 14:19:17 +0000
Message-ID: <20251026141919.2261-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251026141919.2261-1-ankita@nvidia.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002325:EE_|CY8PR12MB7754:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cad322d-704a-42f1-d119-08de149ab08e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IyGEF6AHvTWB5b5hd/3TEiVzsw02pAqRLVCQTnUyfYZRk6V0cmSZqV2SUZn9?=
 =?us-ascii?Q?fb+9FHGxAFMvNCSg2rGPjjPwbXlsOliKqm/eehR2Oq8YDnsTjQNQo8skColw?=
 =?us-ascii?Q?ec1XxwL3E9NWRFckv/1XguvWwQ1jZ2bQFVR8Ipoggzv4KFXDj58QHcz0Y23K?=
 =?us-ascii?Q?ie2V2J/EC2H807esLPMTKt4JIxZcjkW8Z2OqfuJYhE/24x0y9MtfozcNP/Lo?=
 =?us-ascii?Q?PKacprnvXTmbNPQzx/C9bMyD27BsXmThEg3Tk7DbiUHeR/IUNKSoPzXbJI6V?=
 =?us-ascii?Q?yW22HK8kIqso7SlVHhHgltIQcEMl3k6pn5UaZoXPP21b4TQrFG7JQpbCEkeg?=
 =?us-ascii?Q?2Ajx4ZF57TB3/ty+MVJeUHzVZFMYcy5DExPXhIkduM2WMKHQRIbLZErkXMkk?=
 =?us-ascii?Q?Xyfoqa9+9+B786lGDKSJjK+kqOrfN4qfrbVKguUuCnMicazPzF86mVwpzNhV?=
 =?us-ascii?Q?UoOQkijZAq/06YCI8A/bZy2AQBgVW1rXcXC8vR8UrZKNLnzs/t/dcujZUip6?=
 =?us-ascii?Q?32ZnyBtG8xZrS0TXdgEHCHYKixef3CttuId3dM9dsON80S08t0jpS5o/IBBc?=
 =?us-ascii?Q?QCSObYAdVgmDxg4ybp6QIbknCxHAbyAlesbBdiqPXGJiKv9k4kj+KVwT9tLn?=
 =?us-ascii?Q?3NaU24x+t2dNf5JQjDQM2bUfXitoOB/SH0vlylO+S2DUZx7E3rWOjluF/ZB2?=
 =?us-ascii?Q?WWdUBcIwDhnWJmhCNBDO+ceASjfHB8oaGz+yzgfq65RfCvIcV7zf+UyMrR7C?=
 =?us-ascii?Q?MDjvviT93mQFtHioBFILw87gaed8ux9CrnHbboNC0zNSFtdXjOCWfHXasUs9?=
 =?us-ascii?Q?ovbzzJa7RbINwSQg3wPSVV8HMhNBhozrv5hnKBnYPau4mx1l5SUbaD0I2AxH?=
 =?us-ascii?Q?bUa3ssBrqwkuPZ10khOHPYvbW223Q5NOfh5soMQTYMddydmX999pSLztESjm?=
 =?us-ascii?Q?igWjHMELf/gU1/jSucjHGNOKADM63z2ekW8NpBjeOAmj6A6qFzXszG+zKB5c?=
 =?us-ascii?Q?uGU+0+RUIYlTFV/O7XLvdo7Xs9BmksykST10p24wyVzr/FxcU8iefwqcXYL7?=
 =?us-ascii?Q?4+A3ufzJMxvfAj0a2EugAC8QVy5kxHVLkz56y4nmEJxDAutZX7d1bvUMZUIv?=
 =?us-ascii?Q?mjV3v7KL/0yWIO+Bpm7eWjWJFvVWjwOflrJxfvOLS6ob6iAqg1ppcTrnanAM?=
 =?us-ascii?Q?SQwvNgFf7bu8kn31eD5lr8zjUabCTW6+ZnGNjpMnhIse1liYvopLoPP90awb?=
 =?us-ascii?Q?sSuOaZ5p8lUFkNcb88ZDwWhWBd7U5r9+gXJxJ153qGpdGlob1F+s3ayC9kZ3?=
 =?us-ascii?Q?FqvtVL4I1gPdvYo0zlpDr4QwHNpAA0UkivgeBGku9VFAGDPDcEK6batGNP07?=
 =?us-ascii?Q?b4pJZ4MxtNs1CHs/X99Tze/5mSBHgIHWXCAUnXnGlA4wZqezp9c5EbmzNI+V?=
 =?us-ascii?Q?k4a6O1hO+zY6xlDZNaycwPzZLeOxQGiA8r7sZ5bfnzcqMI/8smn18uJwolPg?=
 =?us-ascii?Q?tQk9ZBH8vfnBWYp/XeM0cmWmXtX0rtS1cDsJSWYwkInohKobXrgmtSZ5OEAI?=
 =?us-ascii?Q?uUgMqi5QOvTYbD4yX3lDXasIQaPhJGX5/S/SVsvR?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2025 14:19:35.1881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cad322d-704a-42f1-d119-08de149ab08e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002325.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7754
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0041D180002
X-Stat-Signature: sftiq4n43n75d5u7err5hj4sairr3cs6
X-Rspam-User: 
X-HE-Tag: 1761488378-497971
X-HE-Meta: U2FsdGVkX18XJ7DTuKJZAelt4Stf+coQTY1MEHwEnW40soVh0x3CBoXp4AzHadAP9r8exYlCSQMYp6DKOX6ef5GkGV5qzs+IyE91Ixj2LTc88Omeyrepog5h/UFJV7CnT2jpE7wd+PNRv8DfyoB7vRAT9xOiN2EDLRzRTM2YOe3MGw2Wj9L/Up6rPBcHu7PTQBaBJbTFkMogdllfw982QhgKR8oTFUcdnHU7xY0Rg7bWCjiIXQSQlD6kzGyvu3ax47EdfWmYNvGq7rdDJ5HmTUK8wgWxcI+HxlPO55qHz517FGpvrQyyk99WRZnyDruIiVUM+cAaaJl+EGh4L1BshXInGQb1kDjqUfVQAFa3vJOc60kGvMYS3UFe6JoAUdg7ScPlr67J46pJufy09U427eMGR2wHoRBoBE37OglFVYMA5b9N1Pb7iYNWSKs5sSNX2BhXc8JL/semmtqo8LqeJNSgdX8ef/oTIekz9oJEYhBW4GoCIdC1Z09pF88GU8GXpgOJgBwOjGZLg+GbBavuOZYo0OKTskDTjztBDzLAT66FoJrnvJZfLhDT8YjXszPHACbmuY1tumVkyKw/Xa22RvNZBM3ECA0tje+iG1Xj8y1fmhF+E6PKfk3ksuE6dnACwtDjMuaV90mgYfj0lH16ZvXe/O/C5pjPu4cE9jPWUbxHWmYKpMJ9Tzv4/Tqcc3Boroz6+MlN83orWryBf1li7GFCg9Npy/bp9ulzECPb6719LP0kanljsBe/dDysutH4pVbHdmpZfho8Rq4zGHjOPpSQe6Wqo6PZSBzG/3RlDgQIvuHscCQ+Z7gstpqC3NDK6cu2rIk2CncORwCq7CjMz+Rqd0JWKABx26nH6yb1SeJMe4XkA7kVXwGl3aFanD1WuxSUn2i+XX1NH3CXXb8sxbZbbzXLmFn6/aThmcfeuo5VAI71MAst0wmMsWHuFfkB8UwQwiFX8446crACQVO
 Qv6q7+qE
 aPda8rf549/DWbgkoSYTxJp3/EBJh+0X2DugaOAr0R9NYArpPI+mbf78fRPoza6E3rtmlIvlWucrQBYImcFjGXXYkRa7hi/QtVJESDVpW+J350v4CQrsMYQlZUBqtu/250Bps9l7eDQFrc2UxzfVTtXOl4oeWAqg6MXY8ID3J7/8Dwyf6ClK/4KrhpFbfB67WxMHOIv7tBnr6pqyV2y5rNMFLfKKb9gHSXnT2M8y5fxjxkGvhY+vFWneD8gd6q3VNvLyLTMDKBB8UaxjnSniAXx63bs1Ha0WA3MSqMIR2jR3H4IjDC+1Ztim07OMR0srhpObIuZivsRZ1jvOzea742SbIg6Djs80qSGhTpbPSefrqnGDhmPFdXjzF/WesgfN8Z6pEX43c9hvDDAi/u0arKFh1MaZyWkGPvjwYn6tSAbwd/Tg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

The GHES code allows calling of memory_failure() on the PFNs that pass the
pfn_valid() check. This contract is broken for the remapped PFNs which
fails the check and ghes_do_memory_failure() returns without triggering
memory_failure().

Update code to allow memory_failure() call on PFNs failing pfn_valid().

Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/acpi/apei/ghes.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a0d54993edb3..bc4d0f2b3e9d 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -505,12 +505,6 @@ static bool ghes_do_memory_failure(u64 physical_addr, int flags)
 		return false;
 
 	pfn = PHYS_PFN(physical_addr);
-	if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
-		pr_warn_ratelimited(FW_WARN GHES_PFX
-		"Invalid address in generic error data: %#llx\n",
-		physical_addr);
-		return false;
-	}
 
 	if (flags == MF_ACTION_REQUIRED && current->mm) {
 		twcb = (void *)gen_pool_alloc(ghes_estatus_pool, sizeof(*twcb));
-- 
2.34.1


