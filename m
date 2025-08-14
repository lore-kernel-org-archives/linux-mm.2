Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A801CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054E990016C; Thu, 14 Aug 2025 09:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C23900023; Thu, 14 Aug 2025 09:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5DB590016C; Thu, 14 Aug 2025 09:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D2FB8900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:50:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F705C036A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:50:01 +0000 (UTC)
X-FDA: 83775496602.10.9A809B3
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9E30540010
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:49:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=UFHsVPxH;
	spf=pass (imf12.hostedemail.com: domain of bharata@amd.com designates 40.107.237.81 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755179398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4pFxsh/MnX5KgYbH3aeIt2sca4RFkSKRgN95HPx9EdQ=;
	b=CPNsH7HPEKHHiHyO/5a4d7dsNIt0gOrO1Ha1NKYMIF+pV7c5RX0EjU+W1uaOo/utKXfLe0
	+NS636sQL0D1nVU/ZhtlwOHbZZKcRp6W0/OcTgaxC7xWIIapOK8i8CZS7krTw23HNwAGNQ
	weW4Owgn2p7DZbUXLFUVA5NT2YzcFhk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=UFHsVPxH;
	spf=pass (imf12.hostedemail.com: domain of bharata@amd.com designates 40.107.237.81 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755179398; a=rsa-sha256;
	cv=pass;
	b=CoSaOJ3brYDZy8YtidQM+F4bR/mmrlKUiInqnByH4JYSh/RxKDz8x/xTGR8lJ5ZkvtLVOr
	iXUSnf/rSzmdn2iK3KdXZCEZEtlMhxx4bL0t8PNtp4kJatrKAUZ6tY3bYwbB0tR5wa8+Bw
	Pxf8ebKpD4DiwOwAyKPOXYkpCROYQjk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bf6ApQpTRaGqJy5WAwgl6mW5Z5H4DN9vCSERa0DIx6//pn1RnZhN7ERANKRUnENB2c3wgTlMsXm9/btVrOTrcFRCudLM/LPPzAfs0Npdd+JIWTZNTjV72CE3z+1NeEcfrdthbUvcZLMigGDoMyC2U/9QzUDukE7p5UTIQLLit6EPihWS9ANQC/s/5AV3AYJIHRP9ArZSwowGa5p6zz2l0LmohhGFhYpgwFByDoOMsSWAOJoZ9s5mpq7wciZPLolXAP+hnEvVpEcFz9jKrrjGCppdnJlVMk8+kLcK6ytCiytDipRuI6Q6vDU5uDyT0WSgiFOcfW/m9SfyVoNOQQQxgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4pFxsh/MnX5KgYbH3aeIt2sca4RFkSKRgN95HPx9EdQ=;
 b=j7Je/POXIU4gTrgjTMoqB62yc2DponArTQNdwJYucMvRbbIGGMhoezyoQo5J/yAtLDbEGLSdHpDnDfrwPDnU1QydywF2XH7u8QrZT4RtV8Lbzzk2PFYX1zDKggjMK0q4Nc7kkKHuySh3W5+BOG+yh94k2+dI3OJIGOr6f2cbUQK/Vx1bKw6lrt5t8phYy8Wug9H7t9uFC/LnRnPIfeH5YmgKCA/gD6VQRDAzFDwnrmZiWAbWP7Ae7If7PiY3vOv40sFH8pOBESPB3poNsk/Q6CO5rkRm0+BxMZpjIX1gIgqlW88yBwGxK6E3dKs0VGi/U+AlnqYTWg/JwWPaXPl+cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pFxsh/MnX5KgYbH3aeIt2sca4RFkSKRgN95HPx9EdQ=;
 b=UFHsVPxHRgIlK08MJ5U/ofR5AOnbMVR2A6sXW2R9HJNVRoSabcDtDhVVGQBFPT8K8PcFF+C0sPGSUuBBNw+tvarz8xgytTgX9a2VzroVuBEXxnMayHVXKHltKGQzqo653TmVsyyij89anN/6VufMXPM6FPRRh7Z3G5zn164usn0=
Received: from BY1P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::8)
 by DM6PR12MB4316.namprd12.prod.outlook.com (2603:10b6:5:21a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Thu, 14 Aug
 2025 13:49:52 +0000
Received: from SN1PEPF00036F3C.namprd05.prod.outlook.com
 (2603:10b6:a03:59d:cafe::81) by BY1P220CA0012.outlook.office365.com
 (2603:10b6:a03:59d::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.18 via Frontend Transport; Thu,
 14 Aug 2025 13:49:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3C.mail.protection.outlook.com (10.167.248.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 13:49:51 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 08:49:43 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <rientjes@google.com>, <sj@kernel.org>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v1 2/7] migrate: implement migrate_misplaced_folios_batch
Date: Thu, 14 Aug 2025 19:18:21 +0530
Message-ID: <20250814134826.154003-3-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250814134826.154003-1-bharata@amd.com>
References: <20250814134826.154003-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3C:EE_|DM6PR12MB4316:EE_
X-MS-Office365-Filtering-Correlation-Id: 2866845b-8127-46ad-3d54-08dddb397108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hcPRhtAGzIONTGD6qadvCEezoeCZG20/4VXd76bigPqfUeCedXdQnZWg+FvC?=
 =?us-ascii?Q?UyCG2hm77btwpYdq5QnofpXclBtSi7a087gxAidMY4ToaFj3s1Rxo+lsn3v6?=
 =?us-ascii?Q?nkt6SZ+bDaWP8+0pIPoNyERjAFcyn/IJbsmW5gK3Y/S4hpYF861lX+W2ik8B?=
 =?us-ascii?Q?WyoGMAGxvecdq6qgco7QkJcTS5Q011vjnN0AbkpFvgDUGnM5Sdxad1A4UIVM?=
 =?us-ascii?Q?3n2/FfytfA5Uv4vtnmfI61JY5G6OBp8SJyxiSYMHYD/lylnuV9rnAviZEJgt?=
 =?us-ascii?Q?/7ZOQNSmnMZVuJoBM1NI4BXb0qzXb3Sj0LRTmT8t4KWxvhRaLeOYJn+2plkC?=
 =?us-ascii?Q?gEpOvfpOLrg9HLAFu2Kzll+s2F4CERiA3DIwi6/WD7xWQoneCFDGTtCT3+D3?=
 =?us-ascii?Q?DrUfUajE4sOWPBfreWNOEABA0bvaM133dNaxI3dEoSRsTZa0kc/c4Wo3ss0e?=
 =?us-ascii?Q?dNNqsPg4WnuK2e+ebO5GP9f7LCK4/VWO42n8VZHLShZ871dxP+zwnAWizb3f?=
 =?us-ascii?Q?nOh4zI9+UF7cJGYPc+Cpnw9EuNjdBeSOP57AegzdIgeuXLKXSLbjrrI7PjGW?=
 =?us-ascii?Q?ek9rIZwSM4aW0ymn9BToiRTIpTmWD7QD/2ZJIXPzCZuOvwYI0FeOm84mmSo6?=
 =?us-ascii?Q?8ACHwVeqWQhMG8lJjNhC5iCrewKJxCGkMjEEZYB+96rDYAWN24Sms4pry3CC?=
 =?us-ascii?Q?PhE4HVk4WLGftFrtEI7J4JaytB+lc1lxfFo45YzvgdIEM4FLpaNtAsU/knOG?=
 =?us-ascii?Q?/drGs0e+gHQ+HecE2h6801LcHABHQ9SBp5Emktkb7xn2W4BoJIGmQuAty2uo?=
 =?us-ascii?Q?r+IdEvjdbq2nHl2tcBub2XOS+whon2O3AZ44g9ZIt9rEZdOcyBr7FlCRa8lr?=
 =?us-ascii?Q?aJKHHEiG35iNJRbSJoTVljZQh0X/WjFQSDH2Jq6Cg7zT3qHnw+ljAGeDs8/N?=
 =?us-ascii?Q?iFcaFZfQww7wXCOQFr5G4xWV5ICsAcAc89R/5y0XE8b8A9gN8nkZ4KkoXxxo?=
 =?us-ascii?Q?dbjbiq/ZIcpqDaDpu9BN/dJ2qAm6F+z593vaXBZT3MQrmZJYT9J2j5Y0l6C3?=
 =?us-ascii?Q?ID0DKNpHX3/c7W9m/w42Zm1Y3KbBrxvbeJzBdLZ7UL00fjYouWPZQ9Zngzg1?=
 =?us-ascii?Q?DNhmufWVDMXhOKfjAuJzmpOFHSgVcJpzqi0aprXjYREw55izzYMHHwvOZFHs?=
 =?us-ascii?Q?9Dg7pnoKWrYNnYPtPbAZpbPkv4DqkguvOnhX/gD37fJAYxkMXwSjRCgcIg6e?=
 =?us-ascii?Q?o26MKuBGbGucBz46LhGAWZ8fDF70wB4IxfBWmNbftbr2qPAgDCD3uaK52lSe?=
 =?us-ascii?Q?1MTSOgx8FjE8LfnFunryFw3vw5DjvIB3AMQPKP08FXwrK2HKWDlPtY5t3ny4?=
 =?us-ascii?Q?dajT1hTXz1ZgyDNc+PK8a4Oauk3sKhhEMF8/Oh1IYK8dvk6WClOeGT/PgunM?=
 =?us-ascii?Q?hdC0Vm1j3arW48dXOFqUnkq3G0W3nNS54fhMEDFZlPiQr6ieYbRok5s50Uhx?=
 =?us-ascii?Q?ci3qPB9O6TF6i/cJ6Mfz3T4mNxa1kQ8z9FfJ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 13:49:51.1735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2866845b-8127-46ad-3d54-08dddb397108
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4316
X-Stat-Signature: syah7i9j1ynqp1ehqdoreayp113gbb54
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E30540010
X-Rspamd-Server: rspam05
X-HE-Tag: 1755179398-769091
X-HE-Meta: U2FsdGVkX1/dT2Desg4I3ZtNinElO99DkpNjx6UOciI7Xhib/QF/VSqEnsq8Q1RGU9ZaIUZZeKtRHoCYKA6va1jO0qYsWg8m0r2N+wbrPruaLMtfeOyBX2UtXNz993Msp3YweymHq0k4kSi0xrQWvI11HE/dZiR6Frcl1y+XVeCED5RUNBlX6RcZGgiViBWX51QO+GGvDSmfrQZX/9ye5teSje3wd+hbswdC0uldoNnGEJU0NKwbzPG5HOi5rfdHNv1FNMSajcVFBKszl2z6hbItLSsar6qQ9cegP3Dq9DS3LZDCXD7ZDXKWVDPyOkklze9DMQVDzCsWSwZyvdI2ZdzVjPZsavJbib0bAqdst/sV2B3G358lXO6maMOErStPhAl5/oFpiwKh/lu8yH+Ov9NTMyUyWncOP1LHKJpkGYYwS/jTlGcMnEs116s0B6n+vM+E+9dUtckFOdA+ZAQTFqlw4uW9qpBg2AHENeNXtXdc+8laMzU+tPI1vRG32nztxFaFUN2NLTOKWs+Gp9ieBLeGywOCAYa/aYwk4rtRa08CqCEPEvfJrpQE3fMNLK7euHFbUzMg701nzA5GSnHvsGSkVJV8dRIhO8+pP7wVbwwYprxZK+ffSLqoAhjG3znfZ8jrYiCqPOzbyAGwtfxIs3qdph3e7shQlzJ931DgJimuxD13dfRUD/jZ4hNlCjZ9jaSOFhYBo6ZouD5cYKu1LscwjqG2MqeZ+PN/xSTXafLd3JUQ+Irp1SLMeXXd3zHF/nNFqFlFjN+/x0FDmEd8j4r9w8/1nXisFWlJNPZkP6KFH4u7dTjJX/EGxg/hWZC074M3subRkvwpoFxCI9746IcL5bfM5l8ZFN5Mv64yEs9uK3kiHeHTOw8eSr7neQ+HMpmRWdL512GONUejJofyOhM76GOmesPrH4akS0b92ySHkLCxF5PJMKS8RkNPHAJrC9VOf4Xd2i+pg/jEqYq
 fbeBIVLS
 fwLmNAAFfDpj5WkON7Q6+RcE/iqJM/xXKc8rp23K6sR+4g63D6OEX02JY2Zkh1jKsG/dAdUQDPNI/EHb5jPFY0IvVrNw5md/C4MwfeHVN3fVA23QKKqnt/oNsT8V1BgXuz6uQ8YjnzQPAFh+vOdIdnObUhMdjK7vnQK/ghvRdEIbhrnaTJfFnfDHrBgVnR5o7mIBzBqcZ4WJl891Ed09U/Wthp9G9qMkMz95VOIT+ee2Rp8Ui/qC5mbSh6xArcBtBM4wR1XTXI0QxMClmHLhAU4iDTtzmhKlwpXl+AHP5kjNin0KndJf0hqHMERD6EWFdr6X8gwqgj+zNoY1qpCshASxcQFYqchcWdS3VdWGPzRukLG8ZSjZnO8hlZZSgC2tSaEDCzvoyaueLldzHNL8NIXQyp5RhTo8VlXwv7VJKbHdmqJGa1eKjVTuIXX8LvsMQxzE+E4mYi9EHrMsSUvGCZ5aOowxsYNgeSMNYcKhGJnE0Ek19MNNhZkmQP+CDEnqTdqqSEE+ic24csSijsvsCaQ6drSBsDIpDJvhxc6BVa+UjBbYc4W/5eiUylIBWSazxwgaK2/Im7uPu5r3m4bpTih1U+nRGNxW8oe2QRLaId7eLaDcZesxQEtuv5XaSU1wYH5N9/e296XIVlM3bPMwJqBFYaLw2YJEwqcosPxPgvGyAUONFaBH1DnzE34BmUV2q6+evJoaaRctGoMTeI4LYID1dB5yuS0KNtmehinsRtckjLDeN8kkAiAjTHC+NnQ9TI3uobrEDl27VJWYV13DZmG7O29ysGKdGFtLKsR/fbYvRuCo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gregory Price <gourry@gourry.net>

A common operation in tiering is to migrate multiple pages at once.
The migrate_misplaced_folio function requires one call for each
individual folio.  Expose a batch-variant of the same call for use
when doing batch migrations.

Signed-off-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/migrate.h |  6 ++++++
 mm/migrate.c            | 31 +++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index acadd41e0b5c..0593f5869be8 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -107,6 +107,7 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node);
 int migrate_misplaced_folio(struct folio *folio, int node);
+int migrate_misplaced_folios_batch(struct list_head *foliolist, int node);
 #else
 static inline int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -117,6 +118,11 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
 {
 	return -EAGAIN; /* can't migrate now */
 }
+static inline int migrate_misplaced_folios_batch(struct list_head *foliolist,
+						 int node)
+{
+	return -EAGAIN; /* can't migrate now */
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #ifdef CONFIG_MIGRATION
diff --git a/mm/migrate.c b/mm/migrate.c
index 7e356c0b1b5a..1268a95eda0e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2714,5 +2714,36 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	BUG_ON(!list_empty(&migratepages));
 	return nr_remaining ? -EAGAIN : 0;
 }
+
+/*
+ * Batch variant of migrate_misplaced_folio. Attempts to migrate
+ * a folio list to the specified destination.
+ *
+ * Caller is expected to have isolated the folios by calling
+ * migrate_misplaced_folio_prepare(), which will result in an
+ * elevated reference count on the folio.
+ *
+ * This function will un-isolate the folios, dereference them, and
+ * remove them from the list before returning.
+ */
+int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)
+{
+	pg_data_t *pgdat = NODE_DATA(node);
+	unsigned int nr_succeeded;
+	int nr_remaining;
+
+	nr_remaining = migrate_pages(folio_list, alloc_misplaced_dst_folio,
+				     NULL, node, MIGRATE_ASYNC,
+				     MR_NUMA_MISPLACED, &nr_succeeded);
+	if (nr_remaining)
+		putback_movable_pages(folio_list);
+
+	if (nr_succeeded) {
+		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
+		mod_node_page_state(pgdat, PGPROMOTE_SUCCESS, nr_succeeded);
+	}
+	BUG_ON(!list_empty(folio_list));
+	return nr_remaining ? -EAGAIN : 0;
+}
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_NUMA */
-- 
2.34.1


