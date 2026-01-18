Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5098C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 19:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C0B6B00B9; Sun, 18 Jan 2026 14:26:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139716B00BB; Sun, 18 Jan 2026 14:26:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045406B00BC; Sun, 18 Jan 2026 14:26:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E586F6B00B9
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:26:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84CBD160477
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:26:37 +0000 (UTC)
X-FDA: 84346066434.13.476682D
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012002.outbound.protection.outlook.com [40.107.209.2])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9A22A80006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:26:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="qUGv/T9p";
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.2 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768764394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCKc2c/qjEjSDRw/8Qyb1Lt+GR46T99lw7jy2DPXaRk=;
	b=YmS9i057Y+JdLzxD0i5Njkuw2NjS50NyVljeyY6+DGeE69dpcn/cZN8A8HVZrKDba6eR4N
	mjytajQPdNQRzMMA75wpj6cPvr/+jERUtcIP1oCKlxvwMHpSl0AsK2Fb2UIVANyu4ARXJg
	i+sa4c1KkKkqCjpWLcq/tLVDqdTUIgI=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="qUGv/T9p";
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.2 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768764394; a=rsa-sha256;
	cv=pass;
	b=HmMcrHMi5xTszVcuZVgJgdUWjgJcuq64rHD7pmloYp0Tb2K8oIrmhNLxbDdvo/cA5sl4mq
	TIKHsvHmjI7T5bLgrEPdBr+dc9r2IhOkBqPR0WXpQu2nilEAmdi9IPLVFKQDMsMAT2/HeP
	arczCt0x9dB+Dx0E+bnUyETrQpKYN8I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CrywA6xRltQ2iQcRgMwAwIDY5qmRTK6P39zR648EB9bB+VIFPxNypbhgvxJKCDKialE73425lbgweD/E7Pxfr7Bhfk4tlsRp2YNDmL/bytr+OFsl34S3LydGfSOmZ8I2Qq45dpGklKjQBQGjyG7oaaMEDFHSfjb4rL2YrJW90tgWCmesHT78L020bUHdCLaQcD+sbAi15l8CNtMEISRqKjRkN+1vSTnlfZQ06yy0aKagpz4fVSlURgGFXRsLu1dQ78wnnPrmUsmEqsYRp9gGOEGNLUNiwUUnt8LCi45t1/bFyhpG4gp7bnuWary3yC2JuB8tyD2EfOdmvMSAgBqmtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCKc2c/qjEjSDRw/8Qyb1Lt+GR46T99lw7jy2DPXaRk=;
 b=IFxMqPBfik6VZZd9J+3qR+7JC5bnl6taGVL4F2tgq/r50SF6qd3IVdgwFdBdDi1BevtwAXNv+ATPD4Oo/TdJLsz9NoKuTTIWSglqtAYMcpGApBfOOs9a2KKmbEflJ8hoDa8XSvResXkofySyKJhzRG4R950Yit5D08NY49ZN6Eri8OiKyDFulMGBS7X81o+NFVf8ckqbajhcsGqSFlmlro7oBg6nFCSCEbAmu5FF6Y/EYk1w2humCorW7oYIoal++54QtIJdj7evXz/34TApVWQPQzWkHbWeybWVrU16XjwrznEduEgD3Kq2rGyOFRF97ElKrh1KidMqxMWvDDQk6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCKc2c/qjEjSDRw/8Qyb1Lt+GR46T99lw7jy2DPXaRk=;
 b=qUGv/T9pFhL2Kgv4aAwmgbICIx3V3FW6q40tWqbu9ahIcuXdSYJqZhzGES/vGMxz3I8+U0xnbemZVmfIf7wtCXabk8nsYbQ0TpLxN7LKlGVENcRoqeUXG6MoeT/SB1yCDrHiBkfRk7ja1ebY71g+2V+G/InmVwJPoJ9FlC+9Wwg=
Received: from SJ0PR05CA0058.namprd05.prod.outlook.com (2603:10b6:a03:33f::33)
 by SA3PR12MB8762.namprd12.prod.outlook.com (2603:10b6:806:31f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.10; Sun, 18 Jan
 2026 19:26:30 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:a03:33f:cafe::19) by SJ0PR05CA0058.outlook.office365.com
 (2603:10b6:a03:33f::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.2 via Frontend Transport; Sun,
 18 Jan 2026 19:26:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Sun, 18 Jan 2026 19:26:30 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 18 Jan
 2026 13:26:25 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>
Subject: [PATCH V3 1/5] mm/khugepaged: remove unnecessary goto 'skip' label
Date: Sun, 18 Jan 2026 19:22:53 +0000
Message-ID: <20260118192253.9263-6-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260118192253.9263-4-shivankg@amd.com>
References: <20260118192253.9263-4-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|SA3PR12MB8762:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f78faa2-d775-4dab-3129-08de56c77b8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?60LifQSJr8AzxseqngO8CodpavTI8L0On3/apMyzwslpRCP22mgK1+5NC9nx?=
 =?us-ascii?Q?iqaF+cyYqyyn8mglHtlxfB6Bu/RawpUqcXsQZBzL59sbfqXbOroGbIoXRW9a?=
 =?us-ascii?Q?1GJZVIFhGpZMNvV2q3DpKK0tH7h3hLf8zBIKmnbdeiPpEu8Jnh5+wBAmVzSJ?=
 =?us-ascii?Q?qRKrxzkq6WV3qOmYEZByhWf+3v+wXkNz0XDqtCT1IR+L2nWKJ6ZpOJv5pTBu?=
 =?us-ascii?Q?WFLdoXt3Fsj6Q5WiSS6ZPFvGzK1vvHKdFGy4eHf4RWAdRxdf3Tczv8JfGsqR?=
 =?us-ascii?Q?52F9LyGl0hiYxFg7Hgfnhelfy/c/yDfLCKm14JMPlWML7l5lNLS9WhpDUuDS?=
 =?us-ascii?Q?vjpYDyxM6oA955pIRzJ2m5Rl0sZC2Qi1vK9cW1wqIBBpfvJBKpzd08kcjrd6?=
 =?us-ascii?Q?OKAS21SpKwhX2kaNBlEFOsPa3z3ZEXa1Ud92vhFX2SFS3wC7yiMhUexyFvNu?=
 =?us-ascii?Q?nnVGeHFaXUldII1dMpFO0uPjN1RZJiE2veo4WgJB/t7fQxT7uXfDXIh7asmV?=
 =?us-ascii?Q?JzB7x/gvruScRxtZF9j495+lBXDBU7EnZC6fIlFkv2vD3JoDEcWgbgnMzBRF?=
 =?us-ascii?Q?sd2j+lKSBZ+5sFdoURKMuxy7dnSbP022We11SYjE4XuqcRLxuL3jGDNFs6p8?=
 =?us-ascii?Q?NuzqZSnqpLdlFFaZ46LQHRzbvYUOzA1sumt8zH/BzJavhZ56a3njOVpPlLIy?=
 =?us-ascii?Q?0PJrYcfTvMKUOtox0NIcAjR0vqEPaeQEPy8JVnijquHCumsgy942hgPQsEk3?=
 =?us-ascii?Q?hM2OzmdHfUlecmZfQSQwE7HOj8ltw3oityKlfQxUzX/jIQV5Wlc56BcQfuwS?=
 =?us-ascii?Q?seTzEpmHVzgEW2OsIi0RpCMd7bO2gRoKduamWkznmF2qfPW2iZdHZEX1xcnX?=
 =?us-ascii?Q?MSnb6lrp9OjECbMl1lX5QcoPwPpbi4hUOC8wmYrfWmP5n7FWATYUJ+TUkhh0?=
 =?us-ascii?Q?AsLzZ+aKfgER1j5yOeiAbhDdultqvdsh69uUuiXZvQvpzdnTly0rCSZOnvGt?=
 =?us-ascii?Q?NnwuAZmKESOXb/tn8nUpj5tcOnVTXmAPrp1FcT2xrT5uc94g8zAccigi/+4u?=
 =?us-ascii?Q?gBP1Cp3s9L7zUQZVbT9SLO4BwirT5xdLb63sCiqujyHmFNBolNSjmkRh8W95?=
 =?us-ascii?Q?7kFFus+fNAs9ZA79BJE8UiJOGxlfaIzidsAnAligAR/0FwUw12tA3BvC/V2s?=
 =?us-ascii?Q?R1UDh08L2rMCV/h3XknUJ76W7U5fc9Anef+awSCX6/DFm5VDN+x9kEzzGTLe?=
 =?us-ascii?Q?OQ7DNaGs2l5nhBoyCY/WWvn4lKjDq4/7BHsFZfywyeGM/W2Xe4ygmUBWtCf0?=
 =?us-ascii?Q?cDmi2MBt8XKreMvPqJ93cCedLXnMr3vPVQlRuXFrCy6U9Gk+w2Ud0f8Bq6Sd?=
 =?us-ascii?Q?XxYwAIFGdSOnhhqtAr0y4bkMWnbsMrrOpOCX4cxeCDttz4wkdqQBas98tkYR?=
 =?us-ascii?Q?7OWvMU6vy6b7f8V6ZB+Xte8zfxldd5loZz5JB2lwUuBRsxdwiUqb41Ou7fxX?=
 =?us-ascii?Q?NVkqYCD2zswSlYjjJ5UyVb4b8ZRYGEnu/PVIN9gStKZO8HI6fdEZh9QUg76Q?=
 =?us-ascii?Q?jVQaerZR2z06QivMn22UNq195yileG4k98UKF6lxKwwsp2NoUYYvWSNQ58KI?=
 =?us-ascii?Q?v2tmwLX0UjqTWUQRpNmQf4lDVBf0slqx9MpTp23tnmJCyq0UHpwxkhRD/rMu?=
 =?us-ascii?Q?K1cnbQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 19:26:30.3175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f78faa2-d775-4dab-3129-08de56c77b8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8762
X-Stat-Signature: aznze46pw7nskbg3t1tt4tg67szmnn4j
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A22A80006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768764394-665367
X-HE-Meta: U2FsdGVkX1/fp2BOL3CgXSqCnHltFK8UudAFmVyeafQ5FUQxBUdnpSDLWCsUzzCMhTiorMb6Rl5ZLQLWWjFYFCv5YyQrs/FhWNllwg/YONF8v6JjqNaXo34EAsnzzspTlpIv1eWrFzjh6q25yKElfYkF/nxh4MBOtkFVrkcSt2e0NuQkZ/jsu+kfZBEYH3cN9s3TqDzGouCoyc2Ar448oh+Ec3XK0ES5N+A733MlYvfp1W5PGNHI9eX5Opx4tRUjx572hMGqICA7G/mH4jlUzZdVFTMRrxczswxg3Ze2uCwsynufDo0NmKJCq2Hx1c2QIT9BG/ubGXwFSctlhrVvhP72QRMHRdEsrRvU/TtXgogzdzdMeZQiF/og5v2EzO5+0wBrxdJfa6SdNkCdRhG7XDgSa+BBo/kv0/edvQ1zwUx3jnKzQarpWUNe3dr93D2AI+aT1zra0VUcj0X8DS4QN9R2XPqb3SM8SUYWopfNoQ7inHTgF/3KU3225f49PRSeeZ8i6p1peLCViKuT+UmWGUkX5wpbUcyEU6orQgH6JM3l/OQiuaobjXr+GSZVlKIhi0EoF4ly5wK4IJcMs59vJbzOttBxgdk5jBUvxXXkHa4COh3nldqrfOZWR5Qe0zTp0J7obHA4fBKGj+uoJiOsR96pUwvDIfjV9OVybIhLhyIJWwt9XTO1x9DwFRuasbdL4Bcf+B9uMjF1187WsNh2s/SFjMypzkO8QNR8lf56gY6JXBOpW/4pMmiotZ73dEttODRCf4ja7ZMmRZYm+1mvqPWmO0w4pEgo11dYmNYk4V2fykxxB+aQHe3GaBl0YfbnYpfGpjhBEuZsWa5s9TxF/7mJ2R6sWq/88xTsvshCJHJUAeeFq56XurNo24CN0LQB8sCSUEUAdS9IocGq7eQ8OsztWi+AL8lr4X4yRRFXBhFkjCmhUIqZ/0AZJo3W8bOOp+ZCO7+Ca6kjR7OFWpB
 iz9DU6/s
 RnUb/RJ5bSJbHmerq0By8zHOVsTyIJu8Mr4GQYsQ7ukGI+NfoVNiYV3LtJI7hUxPkJo0E42VSSFcBpeWqbLBoJ/rGPO82pAU3e4UGLQJMTaXRa5YuyjNe+pq3ZzqL3C4hYHmzMFDMGsl4a3Udg9wwCwfmHww3CAZLZil0Fa9YpSYjpJjQR8CH7zzhxXOtuGR6PjBb5zx4mxo1cs6gp6VgDG7d59YwXUlIVQy8AHd3FyY8cPdNPO/YiGJj590MaCki/p2KpeFY5s/IWe+ftfkR1ke9AiGt/BzT9AFEJiDaFgecLuM6KWZrwDzb7O2mvZLJaUTuaeaJbPsZqD0PbzgNz3LthsE7N8US1q3QlULu2V7mLD0aAgV5TcJO+grq0fyT4LEhNm5nM/xdtUgfKzz7Swr0pyCb2xyNya3HU4PO8TZrVxgoDkr0OkCrYSBJ3Kk9GqpdCP/J9imAmDMY+1rZo0vb82YaYMvCuHU8KRM4wUHPLYaJ29VhEgW649XhyHSu6D/7OTP3NJR1h3M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace goto skip with actual logic for better code readability.

No functional change.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/khugepaged.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 16582bdcb6ff..984294a16861 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			break;
 		}
 		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
-skip:
 			progress++;
 			continue;
 		}
 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
-		if (khugepaged_scan.address > hend)
-			goto skip;
+		if (khugepaged_scan.address > hend) {
+			progress++;
+			continue;
+		}
 		if (khugepaged_scan.address < hstart)
 			khugepaged_scan.address = hstart;
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
-- 
2.43.0


