Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E632FCCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 14:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F36A8E016E; Sun, 26 Oct 2025 10:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB0D8E0150; Sun, 26 Oct 2025 10:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA778E016E; Sun, 26 Oct 2025 10:19:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2804E8E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:19:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5C121A02AD
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:19:49 +0000 (UTC)
X-FDA: 84040474098.28.FF7AF3C
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010032.outbound.protection.outlook.com [52.101.201.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id E9A44A0006
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:19:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nkkxJpL7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ankita@nvidia.com designates 52.101.201.32 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761488387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+PoeFQBtdd6tvq+PxWLLVPThcvfQiPhoI1YysoCFeo=;
	b=nf/6wAvkq6Hy9T0YbIBe5hboldcXVc/llbT7ti/SAbezgk6uf93mgTD7k68qVzZt1k91JX
	N+ly412BRvUR7JiJHwnbhji3DEHWp29DPf51NGOgoZUVCjMIoZEcspxNuxdcvUjwPWYftZ
	QhurhykKBRpkC6qkkFh4S69rP4jINWw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761488387; a=rsa-sha256;
	cv=pass;
	b=BgtOSWVIMB0m2Tw0OJB7b0w8QCI5wa1j1XliBlRX1syahtrLCFriwWJaEyvKFqemO21V4u
	Fg2jbfA5v7T/AQ1mJttAQ/7/OENKPjvn373Duc2mr3Dpxgnp5zADsp/s6Q41CyYbjVCXRT
	GDV/il7YfzU6HmouzH9h77/zgUhl+Wg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nkkxJpL7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ankita@nvidia.com designates 52.101.201.32 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K0ApDqH3VehTAZQrPi/uId3UyvJMOkECGe2mKywrqybx9IBY3McBQ530E9/fPcWFwOLNmqnF6rLYAZmpXIKNmrkSzWVmxIRwaJm6OsUTMDUHBUrWsrpurhe37vuCuIYBW2MmtVVucMmkTem+WnpMUoKFiEhR9PaHsKZQmG/1Cz/Ci7zsSxs/OGm/HfNcuyW8b4ljMrQzn/r44z64x1fpgbJRp8HdzusOCLzVcYIx7utq9gtXt1mHrBB8YEk6sJLnXv1OI4BD4714vuYFj3TQgJvB00qoqExZDz2tV5/N/3+xMP8Agt32xYnHzs/FpxnwC9aEHqhxddxSpK87u4z3qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+PoeFQBtdd6tvq+PxWLLVPThcvfQiPhoI1YysoCFeo=;
 b=k/ShXzQVNI0sC2uFQItKmxvoXFA9AVHR4f946VaekD6TIqtWlsTw8RnZF2E2au0gSJRZVF8ofTypvxxjzyBkVgYDkm8eUBCaeWh82R3fZU3xWQAGVW1JCD5bFQUep3Zm9iAfZMqVutjAouVyhjR39Oipf8KjhYtIRqMFjRIQPZHaiBMoGA36KSipnXIs6l0FSJty1jv1X4RLrx4C7v8R9x2Nvk/uXt7XRKgCmUjShIDIUQlvaayGwqmVw09ic5yv407l+k+CWJKBpYoA60wQpEL62hIZ6pJ9EKWgUvvItBlgBiX3puc2iyqlj7KcVTFOC5u4tmyh8qfm89nXZ2fNoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+PoeFQBtdd6tvq+PxWLLVPThcvfQiPhoI1YysoCFeo=;
 b=nkkxJpL7T2SiA0i/aq8w+Xoc5KBAcI3yYXAOglkZkuMrDvoDquzzI1xBEycVu+kgWm5OHbUJq8snxQ8vuUTnTjmMPxxIrSomccrLan/8bizNdKeH1+vD23ZnE28IGi9Hl51G1hQNgMD44LAyiIcrfnyKyvh/UniEou/ieGY/rPDTRfpEzitHbn/jHLHOjIavaH54n6alkmt+8/JdOVDPjc0y+aNlQo8nUmE77ueLlt9510xQVv/wbje0U6gWiPuAlQro7nKrkSFB2N+kSvzdZkaufyCsp5oaqkkauFoDowutI5LeyUJA3r9jwkLmGjUEReegpsX5Hh/9wMqeWivqBA==
Received: from MW4PR03CA0347.namprd03.prod.outlook.com (2603:10b6:303:dc::22)
 by LV9PR12MB9760.namprd12.prod.outlook.com (2603:10b6:408:2f0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.16; Sun, 26 Oct
 2025 14:19:42 +0000
Received: from SJ1PEPF00002326.namprd03.prod.outlook.com
 (2603:10b6:303:dc:cafe::18) by MW4PR03CA0347.outlook.office365.com
 (2603:10b6:303:dc::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.13 via Frontend Transport; Sun,
 26 Oct 2025 14:19:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002326.mail.protection.outlook.com (10.167.242.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Sun, 26 Oct 2025 14:19:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sun, 26 Oct
 2025 07:19:28 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 26 Oct
 2025 07:19:27 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 26 Oct 2025 07:19:26 -0700
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
Subject: [PATCH v4 3/3] vfio/nvgrace-gpu: register device memory for poison handling
Date: Sun, 26 Oct 2025 14:19:19 +0000
Message-ID: <20251026141919.2261-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251026141919.2261-1-ankita@nvidia.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002326:EE_|LV9PR12MB9760:EE_
X-MS-Office365-Filtering-Correlation-Id: 104b4566-318d-453c-9d90-08de149ab444
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gNOMF11kKR7xob1kJklxMjBEzWwktIa0Oy5L6/0hnMuAvDGrL8OgVUhSogfx?=
 =?us-ascii?Q?yZHQYs/SQ7K5F0KHgMncJMLPs2ITNlerZDNNc5MBjXuGai/ekQGZGSOrV4FQ?=
 =?us-ascii?Q?FU7P0fnhEmO5EEdu7SJ0TQUL++6JkorLgivvOsLzj9pVokmdfv6VbewAdELF?=
 =?us-ascii?Q?yclsOzOQw6zzKm92ramoLKXhA+Cc8G0dFx0CLiz7enO+6kVSvQ1LS5pRy0/n?=
 =?us-ascii?Q?+aSM9uR0Vl32nCgmqnOQHIf/slH5wxvkkxV5Ff+WGGTMN+LUjgqNnJpT64WP?=
 =?us-ascii?Q?coexywk5dyGohC+8crf0olNILNXc6pHE0L/YzJhq8pUJWwX7Ht5QsrBSOAnm?=
 =?us-ascii?Q?ktzA88zpqtO45yCnNasuod3ObldBIQQwb6DFHW+OktDrqTHehao3CT3PnQlL?=
 =?us-ascii?Q?SPY6fJe49K66ASgp9PhL9i8O+I33FtyP7ImoTvc+PpJO6Fu8kRFQtdx3Elfx?=
 =?us-ascii?Q?EypOkCMA0TnvtkfsakFwnDV/j2MBhtSeNGdSDF6oYC2wLKuAEUIb8OixFRq1?=
 =?us-ascii?Q?k3X9prrgOPyuqeW5/yinr1xrm7o8IoLPeCVYJod+pfj6fWor3qKGHdzFSz8y?=
 =?us-ascii?Q?IfDqa7U6DHw5z+1MOYg1Lhw0VTYOauOGVrhPZYtzebmZ8xQXiNa/kOXOj7wD?=
 =?us-ascii?Q?KBEoH9YHyBiU/xOR1yvzeoaVp0iYCK4qOgkKHRigYL9vUnf9WbylIO7t+LH/?=
 =?us-ascii?Q?ukSSKXnGu2IGihfE/+joiv+SRERT6W/fjkIKehZrjpIK82m4orCjnOxNnMyX?=
 =?us-ascii?Q?PVmutyP+o2wnLzU9Dm99MQmY+EMkyLxJGl7SQdE4Zs1CpSGGvV2fssXQLPRa?=
 =?us-ascii?Q?r2ndwC884PVLc9whrOU2KJHb5Q669+LxTaUpGi9nHaX79fBL1vAlZwxOwE8H?=
 =?us-ascii?Q?yq+N30qDXz/sEaBTpV03jXwYxi9Qm4pcNr7eqPi4/Nfx8btH3SfdvMrTb+ss?=
 =?us-ascii?Q?B9XQH1RH1PG88jwwH8IcReRQ7FVJPofp6HjujBQl5eP1yO+jnZ4xRkdmET7U?=
 =?us-ascii?Q?E+5gYSTiX8Cnwl7qHUiunFrSuuAV2zH+7SwE5PB58p9EWPHJe7mMoBonllGV?=
 =?us-ascii?Q?LPRHM5eTRSfbw47j4hb4Twl5FErqPlpGcdSjHNfnO1Ts38NfLKUiUP4QTG+o?=
 =?us-ascii?Q?GVpQVPpzFPGi7g8anhYz+uFjUwNcTvZHcmb6KunHEDgD3uU40dgc6jahuAun?=
 =?us-ascii?Q?oCAOjUDGfeeRXk8/PqVcRFzNavjCo9fAzQJ3y6Au/2KUvkyD7PcGy2cjxHIj?=
 =?us-ascii?Q?AVZEWlsqMtnzPHl4UGnyC481Tyo2twySbktSiozVdel9kDTNsTsfhWCxJ1/8?=
 =?us-ascii?Q?YyAO0w10FHtI/jKOosPtzTS98I0k4fPOgPHXVj9JncslSgf7iweaT/P9BzyK?=
 =?us-ascii?Q?NPnsSXPMltoM54sA40iGcyNuPZMhANmncrZnsixWKvjB/yHBxnd1qlUN1+HR?=
 =?us-ascii?Q?R+7g44NsSOLKDuXqeRO9i3te8An58R5F7yC0gq7914H1Mx5zPska/6LkkE7n?=
 =?us-ascii?Q?Xn0f3jrF1kUyucTRDczADginue5D2yvCse7CWexLEfAYwfFmBJ8jkJ3QBMT/?=
 =?us-ascii?Q?MoxCdfS/PiefMKmpPuzAwr4Fcknod4w6m8EbAMvV?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2025 14:19:41.4433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 104b4566-318d-453c-9d90-08de149ab444
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002326.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9760
X-Rspamd-Server: rspam01
X-Stat-Signature: xgf69e8emq3qnpkz4ig638fjkto1kpjm
X-Rspam-User: 
X-Rspamd-Queue-Id: E9A44A0006
X-HE-Tag: 1761488386-195016
X-HE-Meta: U2FsdGVkX19BRGAcyREhhFkvB5g5pL4yLtSiZtNvACL0BlFnPdQQdRf/H9JRG1JT7JiMd69iQIy356etNWFwI/NL7nIDd+iP9+Zvsmx2h3KNWK8NB3k1REeSsqBrrYBi5drJJFEpvqjqXO0xGh4sdsIIo/PGH2xTFhNtJ0whleSENdzdAwnhOwrJsmre91E+CyoXIu/KEN9NQW8hP9xtITYfxtOAGwvb93/fGQZ+lfC54/SBnNFfz4FgkrrwlIz5nZRSbdQuz26e07wxmAl9daxTLp9srs+langezwdrLQctyq5WsNhTMO5FoKjy86r79d4ByMYQHoJkcLjOrxUhFPONM9we+8Ajf335yh4TJjImNuKcca8sGGFK3XGzcrmo5B5S6mLrcT+tJKmNuFH0PaQU4cDZPlUR2YMAojPMFHHlgCGsUoCxgcrKeWRnc+uqxJWFULOGEbs8XH/bSKbzIUN5CRbmzDrg7ZcNaDEX0E3vpcesKd6/e2dotE9DcCiJbd463SbDcitanpU3brRfOoUBA5BrlXFDM4QQqsirrHFok9SeEIg8x98hC8O46tPTO4Z00p7G6804UGhyQ6yvOX30riBZI+sDfMjEv8NV6UrMFj+B3j3yc+enlpQI2e79f4dpSVmFJeL29ORg6syW+zOxHAvCSCsKBwDUMCN4IG1aw+JZOp3CrB/a4kvljjJnpBBHDyRTsGZPDeuV6mlCspVfHMxzlBxZDrTaljiph0eVUFzByd7WSIC2l/tmHS/VZyq30O3CARhyBMzhsx6Mly42MWJAIVE17XdGlRc3+v0TEiUSVNsynrq8dZ1Ph1emHcOj52wiaeg62SUJt4LxvI/qa3sp4kbH68bBySH30NYLQF8cDVADs6jD8Pn9CmJC03fOE2pscIk15pGyb8IhxVWPF0CTShGUj9bchQKMxi/H+JaDi82SlxOC+MFC0LsnDEzHV9axUmrp5c3OMJE
 9BNzOAo8
 d5FOpD+0qToBEigAQ4ieSZ6bPdMe9sonxvJH5gykjOcJrYP9qAf1uUjUHVIwYhjd2M16iuHjLfe6QsAThw3NOJiP4GaDQfiqtPmqkmZeDwQ4EL0+hAXxmdvStlKVjGUMVobvT18HV/P9/bCvD5nxmIfKonIVHa8HRi99chKXfF8KJyRWWao/QU3ySxFRPsdz1F/qljhoCmP98qt/lBRvqonyr5lODJDq/vZyqYauChLG77HpuOsq5xw5b+dsxt3RyK+JDtjQwTLJNPJ9qXaeKEIluYLPhDF7AMAkqiP5h2r1y9Lh81YRG+7wG9W+1WnmLHXmsQf7t72V0NrXp7FaZovIedeSWkcuD4BNZRsvZTsAydl217jIqLjM6Rj08d4avkbgpBCVx7tiZeVYmDcktnw3+axaaxaTG8BiXPoUWztNRTGs=
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


