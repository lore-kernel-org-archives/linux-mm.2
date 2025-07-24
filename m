Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD36C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BEFF8E0054; Thu, 24 Jul 2025 04:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6964C8E0051; Thu, 24 Jul 2025 04:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585638E0054; Thu, 24 Jul 2025 04:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 453F78E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:46:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAD10C02F3
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:46:07 +0000 (UTC)
X-FDA: 83698525974.11.443F51A
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012046.outbound.protection.outlook.com [52.101.126.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1F08B40007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:46:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=FtFflH1M;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf27.hostedemail.com: domain of link@vivo.com designates 52.101.126.46 as permitted sender) smtp.mailfrom=link@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753346765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ihrKI6OO5XXX9pXkYvcTjPs9USsoHTJoTgUdpaxsnY=;
	b=kvprBKL//ArzRxWxyFndjvojbATf2k4o0UJoivhXTIYlB3FlAx89inw+QDkDeI5axu9qOq
	ButTzSRI7qcMnEpYSvArZPT4PUmPUJlsg/Wa5VAgdBPGMfEntm1zCtTSbqRNANuo7TW8uG
	gC74F+IYa+TGwEe/vvbhsvhq9Z4GjgI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753346765; a=rsa-sha256;
	cv=pass;
	b=uhmJSrjb6PRvBxZwRxdmAw1rV4Tx2qLOnWsg9uIB6Cm0rc0jaJzsYwVP1n1HWRsLQGxQJy
	mISszcXCBErmI+SIhktmUQmiF1drVqYDeYPOCEXnJBCv7YgHOwvXCfz4kUU//hTYUHZidQ
	d6ya+Xm2tERrMuBxyhZtAcsP/UHW7P4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=FtFflH1M;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf27.hostedemail.com: domain of link@vivo.com designates 52.101.126.46 as permitted sender) smtp.mailfrom=link@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yZdvyoFdYK+//o54f2uyN2IveOZIX9pINmfsBJy+QkzAd6qhg5s+Tfkg6H0MdZ+VHy2AdaDe8tj6rwrlE7NY1kuDJxYLSGg6nzy0sDoy5bqN9YAtg0q4U6S+kyycjQNGb3ytFo2vBf87XJcck/rEw3H/U55Iiegew9EiEU/CK3rP/ZgiNRByQYI6EySNWk0li86bq20MK8qkQGHefiRwyJKuFWSMOU7ok9ffxTccqIR4xm+CuqPqOftE9xHZHI+pMj+/CGrrLFkh/WPyJHXuACOK2wauPpczNCHUWt3XNzLOOK92whsCOo3GneTNej/A/yafX9gArcbhsoKWmytX3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ihrKI6OO5XXX9pXkYvcTjPs9USsoHTJoTgUdpaxsnY=;
 b=oN3xrXYKNlNR/HZ5+RK7L/5v6xebMPZ+8BQ/a2N1+a83lo+uoiHNrVkl37Hm0qJB5SXMVmKuekHM90Ha4Y5uAS82NEqK/YAcLNUBsSYW5c2eaRDmdE06mMuluhD99GvrjnHT2ZDSxmbfNOqK8ZTjwGmcc0nKeiRs4iBYYqSiFwk9vLDsVxxKbBnbQPz6E0LP9Jyi/6JM6lpl3HTw5ZBVfIuyo2+i88Pzolf2lrIaIAnhyECfw7hcbaNpZ4o1e772tslwwm+RHwjM6XxvwIvGlbNC+UxVuvQIssnCLiDC1FvlMXlUldhY2U7lH01Pyc5HqzEagfXL/XepDFD8vyPz8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ihrKI6OO5XXX9pXkYvcTjPs9USsoHTJoTgUdpaxsnY=;
 b=FtFflH1MIG4E98Pkym+RH/D4mUcP/fNi6XhXTTGVWvpgHCkE7FfmNE12yLptK0sjNRNUle/tO9pjDceYD+hLnYzepSaAtBNaI+tdVhm81Xh+oPwWVstUN/qehDGnWQ150X6YqZRV5y+iMMeBVcu2ciqCLnfYtfkgOn/f3gH0kCNCxj6wa1uBwCUMqn3DICYCf+U11lJPYK9DEci6j8R67DBEO+6WgMhpiKGvoHBWgSqdhna7uXrT8rGAzU8Mc0pK2D38/o4tinOt9feHEgstOGVBMxBpH+Atxa0lLTA+2jp7WGxYjbsb6yz8V0u2jEDqos4JhwJorow7zqvqXAw98A==
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by PS1PPF2A261C07C.apcprd06.prod.outlook.com (2603:1096:308::247) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 08:45:51 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 08:45:51 +0000
From: Huan Yang <link@vivo.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Huan Yang <link@vivo.com>,
	Christian Brauner <brauner@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC PATCH 2/9] mm: add page_type value helper
Date: Thu, 24 Jul 2025 16:44:30 +0800
Message-Id: <20250724084441.380404-3-link@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250724084441.380404-1-link@vivo.com>
References: <20250724084441.380404-1-link@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0006.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::16) To PUZPR06MB5676.apcprd06.prod.outlook.com
 (2603:1096:301:f8::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PUZPR06MB5676:EE_|PS1PPF2A261C07C:EE_
X-MS-Office365-Filtering-Correlation-Id: 7048dcb9-4f0e-49b0-44d2-08ddca8e7ea7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|376014|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wLRiQnMBdiUllkSMFo2ISzmGsDq7vaZSIxABhJyKaFcHXpO7qzFougID0VTm?=
 =?us-ascii?Q?KWt5xr/PDXvjp3QcCa2bzYiCEbGlEc4V4rEVfweSpvoBlYOuJdi2PaAKfjE2?=
 =?us-ascii?Q?EhcKZ/quMfTY5vXSsEWECClgECQLdQF+q+DNVSVPvdOSBP9hdWAHorCjDz+4?=
 =?us-ascii?Q?vRXH5fpnvDSQu7iTwBD0N3MlNlJSEWVSGuc0f7KcpYGfMso43Ddb8yjb16Vi?=
 =?us-ascii?Q?kfVWRNp69FjZju2PBGGrCQdAKIeXjNTgowcx2vunHYMh+cY7aN+c/Jrfk+V+?=
 =?us-ascii?Q?z2IEn21UnZ/Eu21KvCqsLosLhKmo6BrD1mC+idXnLkozeq35pKlV0qgUaJAT?=
 =?us-ascii?Q?O4PP3hZCW0Df1/e7hp7fVX7HJMa04VabYZjgazlMV3XJIXEaRdaFcKCGEaCs?=
 =?us-ascii?Q?EPfoqxCN0ZUQ80MJzHNkd1IuIVlEXPC9NZN4GmbyKA2uSC0AvsfOlncyokYp?=
 =?us-ascii?Q?oRKYvmzBEDOWGdzH9QROMaffD7tlNPs2DBrOBMAKxRBzMx3ckj9a7NWcK8nY?=
 =?us-ascii?Q?Zs4ChhLgwjLSoNi9MYJuY8uFntmy5n6XH1L17z+iid6r0m8ArC/hlfRc5nfQ?=
 =?us-ascii?Q?Tca+/JAWwbvcNIQhK8iInRevxMs7HAwh5CusMY8FIrLRxW3bzzcdKPaTPHea?=
 =?us-ascii?Q?3UeSLzgyyIRz5ctB6I6Vi4OtF1k460N3rX6OYNhVQldhG4Y6dovh8vsL0xLd?=
 =?us-ascii?Q?cSKn+VwjpVI2DtkgerpOEAKAUMl3RPAL/CaWBUeVwY7iebjfnyy29sPjNjN5?=
 =?us-ascii?Q?KN2lqLyTITq9xX2vLRcadH+saOfKDjMwmAAu4noO/GGOImYlD5w+L2fXjxye?=
 =?us-ascii?Q?njM4H6SznEAl6XG0XuZfIZAeoRNqn7XkkGHXmeD8KJEICQh5VksxLN1G1aZ7?=
 =?us-ascii?Q?1ATGNwHCPlSx2atnnVjWe9v1xzrzWgR/gGeClDmwQINZif7E1KceomF4gfK5?=
 =?us-ascii?Q?xsbkUda8Lv9vwq/4IHkcvh14uX0+68fon6EreyyxZ27yLYev67jM710AZ/KJ?=
 =?us-ascii?Q?Tt93dc/hUTXdiwbiNsJtvlZqayrs0GgoWeYQcicpEkFYcsDeB52nDUdTa9ZC?=
 =?us-ascii?Q?wQuna/Bcrcz1H7oJGkG0xaKW9b3lyWuI2ChKskpTmkRrZUFeLlU2ObPwlZ7M?=
 =?us-ascii?Q?2/WyBHQ3e8YOCUAYdV4Y95R93qiImWdTlw65Ph/cD8E7rw+ve5xuyHtB0p+d?=
 =?us-ascii?Q?qTflg7BP1ZND2OWXaxm2OnZ7MlSO09zPwqAqj8dLVgY47o60MvI+m/qnSEzN?=
 =?us-ascii?Q?xtRnsfT+/NVRv1tIdi3LZuOyxKlnp52OsYZp7bKmgUXcgdvH8ib02JFqpgXn?=
 =?us-ascii?Q?hBmiEdJ4k/vQ+IVX8wAVBGUJ4c6sT/TFShNjUEiR3JOA6BIpmwIUulxx3cRs?=
 =?us-ascii?Q?b1nT0NZZySMauUAb9eyz0cxMSAXr5/hmOWz8PSkjZLk3SoSSMx+Y3nxuQShj?=
 =?us-ascii?Q?Lp05mcHobtjBFWqXJAfkO5PxIggCYbgQ316UsOMYcVQq/LDFE+b95Ax2J+3i?=
 =?us-ascii?Q?u51jCrzGX7EvRCA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(376014)(366016)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qt/L+mJkAmDZbxADRrTzEu5CE1tLR2LjrgChgN0jtgdbi1J9CsXCT+B7PBZC?=
 =?us-ascii?Q?Ncm8Y27qJMVElwu1imxDPe+LOp388Zyed55dHxwcGxMK5LrtCDmE7h/TSbX4?=
 =?us-ascii?Q?lfgFQVI/M/nIMZ6rxrMM+lp0iucAJ1+0pOxjhxKUJEHo2G8jC/NZGeZzZo3Q?=
 =?us-ascii?Q?FZ5hligrqC5qq/PheaR73KV6YvAoirLn2sM/2QKV5IbP6UaXKSiRdHZm6j4h?=
 =?us-ascii?Q?HI4/2PKqiBamiOLeAAQB8w28z3oXqLAo0tzfFeIg6QU2F5fFWqY5LVLAOSbf?=
 =?us-ascii?Q?dlKm4BJtPBceLrlUpsJhR3xRqY8Q8zk5oDye1Q54w0nt+pMLZUGPXmG8Q/e6?=
 =?us-ascii?Q?NShaoumdQttwdvN8u1WQZjijzyWNpFHlVk9NiQEjqyCfMNRimYnL5QrVV5at?=
 =?us-ascii?Q?K8fyIbCgaFxIJXdW6c8B9ya1piif/X4WJIfKAITP2xo4k+lLx+SQ2pdbj1/i?=
 =?us-ascii?Q?mfWeHoVRK/e3Te8wvC+ACzDMhVf88/MbKapRVnW2uNQ6xf7Hqtq9nYXsE/rl?=
 =?us-ascii?Q?BtSn/OVhDC21q2/tJJb1KlCN9touvJgHvFQsF+PoL2GUfIy2JYRr7mIf7/WO?=
 =?us-ascii?Q?ipeNcG2vrcpYze3Y3AbOhc4dCesjbAv83AL9OIex5YI333gG+9wWlKyj3iu1?=
 =?us-ascii?Q?oQpGVYgqd7n8ljEfa1WIv8gW92V890pyn/WkLAy5SuGUt3qOAbLAZ5k7Ohrz?=
 =?us-ascii?Q?oBEJdXmS6NVIY1w2k6VV8WGWPQSzngIcWzaLvHtOix5cftnce9oJ5vBGr4H0?=
 =?us-ascii?Q?Mel70UoPVtN91VcqaJ3Yg4u0u5qDGx25nhj4TuzvGNvmSDgMpGeTjUcl5ZLB?=
 =?us-ascii?Q?jn210iG6POnajyk9zaw1gYWCW1AsF8qktPID/gc4yazR+ZsdmZOoXNwm9F9p?=
 =?us-ascii?Q?ZWxltq/0a41BD85R6LkFxuVwVZnPNGHcozH7HmpYEXb20vec4oS/NKDO+eL3?=
 =?us-ascii?Q?kzWnJzyD4BOl8zNEadvcaGQytzRxe1yP9K3wToauKf3Mg9yfQAK4e5H69mAQ?=
 =?us-ascii?Q?cdEvLMJmyQtM7/rJhg2dAhm0eg34MmagiB0jjtleo4NZ4GF/b4EHhvnZ0zyN?=
 =?us-ascii?Q?Wp2iCk8Xw9QXigB8UlIJgP5lZHuFxtaiVJB+9cYjzhP7RxlO6J5Mahf1R2gb?=
 =?us-ascii?Q?d6wXwmMNzij4EchYSqICiSdhFXLeaM8F4x1n1qOUurM8gm74/aLdXua2yoKE?=
 =?us-ascii?Q?ZZiJ1v9Xl7ihYIllNTRGbBMeOVov0RKn9pDi97cd3jlsJ1mMmwGBREQ3khIh?=
 =?us-ascii?Q?w8ObZF7E6kzW/LlFEJZQQ+3nWTQq1kq6UZADW9V2zgIS2vgiw65evT6nLyXl?=
 =?us-ascii?Q?JCg9xLeXTkzMXx8sMyVUUq8PPQvx5KbsKBnmWjSj4zmHTkt2VNLDxEG1nYKj?=
 =?us-ascii?Q?mUq9T92KuvGQXyAECSqx382qcJmBb/kgWA0hkqXpItxGZFdqBtn/Db1/KvgJ?=
 =?us-ascii?Q?A9szFjTqiYKJVOeAv0qDl9f7it8SBuk/E9+3YQZRo2P3fXu8ezIe2figk0tz?=
 =?us-ascii?Q?Oc5QZ3rLVt17C88qDAn62roW7TavgpdFZ3UJDNf9CazwoFNG9iiAkXOBMv3n?=
 =?us-ascii?Q?qDwUj1kQ1pvoJ85smih3oLlKfQz5NyCDEhfo+tWh?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7048dcb9-4f0e-49b0-44d2-08ddca8e7ea7
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 08:45:51.7070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5dkF/VkrTG807dGDhrVsMwcf1sAqOW6bY/lspcUIT+0tHtHNImrm7hkXF2XwHCPMexG8hkwrVw9J88d36DPMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPF2A261C07C
X-Stat-Signature: ryqmqa5saug1hauhu1q1gaz8a37ne8a6
X-Rspamd-Queue-Id: 1F08B40007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753346764-233850
X-HE-Meta: U2FsdGVkX18kyf5VaTsfN8W9XnsEygEatQVEqI17YL0MzPgKwfsebbuhbtbmSlnCPwdta41Ajr6ZG5dyNFv5weU4NE5y1Ab73qB+nADAFk3Br0Rrt2RmdqBN9A/inxx6CwROz+tTG74GVmI1XyR1aaTfPmeD91s18ZyJgGucgVF+U1HF/dHhDhGk4P0dt2cKAGekar9qlMn4GCyKYZBcGQxj5oX779U+GCqXWZr41bP42SsmimPBcmhxs+oMU338BIDVcdnViuxU5Ld0S8WWjRjrCZxvNR3hDo0ksJJa5WhVgCwEZgFNdlfv2WQwenVuf+KnfNEwqEISol6VWGkK8aN4AGYvd2FrqLVNid8lRKH6I/cwa2tBAoIyhsCHwy+JXRgXYi5OTryPRZ4SJnANjTu3BrDKoLR/Yl+sGNLxKHfU6LBXHg4gz1lykamJvNh1UiWrEMiv2aDVd6yJadXa3yfqj8qd+5ESJXPbKDHM83eoeUXfDrYXIa2TmhkbdFOnYf5ddIUfT2UnibzPpXOv7QoDMVkl78vlft6yXUxZIFI85DdXPsEwTYoUMTzq8EACFZvH/P/1zAMAYzbYzMW5BnmZ0PebqcSFTcauYldOXykCVrTrlBNJJGhePbJaXcQuSKeX+OyAa+W5YJ3js56sGJMgYlz+ArUc/cHG0p3B7iU52Z1mRp8Eg+lahoFZBIvRGZYGiQpamxTUcE+GxkWYD3+FrIXwbUtK5wbyv3PRnRYvS+lG0gVUocMmwOfhGdVITPjD9+PvMXHWPrzLhtSvrdDA+mnEVFBcnweqs6fcrKxldPX/BomAnJ4bPaBeZC5OscnEZ86we3KIKUk1E/SDDj8zkV05PBLEvW031D6P9wpLwKj2HZCtAibhBnNgrPiVms9VJ5f8dAmZHOgIx60aBjPbWeqK6Qdimdyc128x1mvdK+852+psUJjs5tCuEKBNTDsMTYC1tueRB7alN9j
 9cx1HUS6
 4EeQwGADpivFQ9dQpyIEri1OZmNWtJn965g6yyt2nCsNKolwSRcy9P0CEWfZol5b9ApGju0wBoKllmSi+2KvnAHqsZr+g7VEZLE6cqa/Dtr6CTzSicw0GQzb2MbWyGPaqSJUVBFGslnveblegEb3RYOJn0BFQDi40w3ztDPR20tUfyw2BiDMOLO6XrTKebmWngzKxYGbYoqh4oUBbrdMqP3Vmc1AfVW2Sztovacn93ausX+7N7lXUFMc24vu+gu2ccq0gPe3i3CrovX3DIT/B0WrAS+SLMEAuunzCXpqskhCuyzfNKIQ+YegHe+QRGvuWw0TaVlW5eG+ouAXrzZpyT75oV3CCcp27HYxM/i6Eqjr28SUcmsDidXfuPrB+BvpEz1cDZk3sd4YJyg8sHeEfAj/WadoQjEsRfhPmvayPtW6Fge7FOqjCjAVaMLbCkWZtJImt/Y5AGubT4F6vV9G6RX3+MSEnTujmMgbSQ16zUY8KJwR4ZtLoO0MkKgFI55B9x4TQbCJvkR5TJiBiX6xAcReT6bX1ZQu2BDOBG/SF6cOcvLK9cOuaTn6ko7T8gFW7zPT9XegFfj7EvnVHARHhDuh7h/811YlKs9yo7jmMmLczeg8iqlSqUoeP9UWDoeKnOdAs2AjJHMIrpULi8nkBx1i1V2TR3NgARz8G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add two helper functions __SetPageXXXValue and __GetPageXXXValue to
assist in assigning values to the specified page_type. Since the current
page_type value is not supported on large folio, only the page version
of the helper functions is provided.

Signed-off-by: Huan Yang <link@vivo.com>
---
 include/linux/page-flags.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 3c7103c2eee4..52c9435079d5 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1024,6 +1024,23 @@ static __always_inline void __ClearPage##uname(struct page *page)	\
 		return;							\
 	VM_BUG_ON_PAGE(!Page##uname(page), page);			\
 	page->page_type = UINT_MAX;					\
+}									\
+static __always_inline void __PageSet##uname##Value(struct page *page,	\
+						    unsigned int value) \
+{									\
+	if (!Page##uname(page))						\
+		return;							\
+	if (unlikely(value > (PAGE_TYPE_MASK)))				\
+		return;							\
+	WRITE_ONCE(page->page_type, (unsigned int)PGTY_##lname		\
+				    << PAGE_TYPE_SHIFT | value);	\
+}									\
+static __always_inline unsigned int __PageGet##uname##Value(		\
+				    struct page *page)			\
+{									\
+	if (!Page##uname(page))						\
+		return 0;						\
+	return READ_ONCE(page->page_type) & PAGE_TYPE_MASK;		\
 }
 
 /*
-- 
2.34.1


