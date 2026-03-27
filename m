Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD4D10AB83B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 01:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 729786B00A3; Thu, 26 Mar 2026 21:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7013A6B00A5; Thu, 26 Mar 2026 21:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0A86B00A6; Thu, 26 Mar 2026 21:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE796B00A3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:45:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01B718D6E3
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:45:19 +0000 (UTC)
X-FDA: 84590150400.25.9E05593
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011027.outbound.protection.outlook.com [52.101.57.27])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6F08F100005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:45:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QASeVphB;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774575917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOQ7A6je51Fv1X2GQXdHO1MZyQrpIbFKGewMFHxLhI0=;
	b=eCBJlNMykue6UtvEo8lo9pkr+OmNubPgRQeGo163Gy24IIOz7KDAPVPloKm0bqSj6Q9pye
	jWJvNcg+frKKlchpC5fFdgJtTPyehD9FGZN5FWP70S4PpjgLpUt8eJ3zhC9Lje/DRYwtjL
	qx3jfFCJw54sPssVWeJn2e8dGGoQlcc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QASeVphB;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774575917; a=rsa-sha256;
	cv=pass;
	b=5rJg9AxLU4caxHCN7iPMZ+RXZnlb0UOwn45x83QVE0NIZxQRu0+Uoaj1d25OVsgbAANoby
	WbxXg1fbl6TNq+eFR3H7k/MpB9GVy3OHQSGSSmLLzFeg7Ju+VOC9hiB95H6tVXFYNEXeG0
	2pYMbF7n8J0NXXprhtrs6X/zwCzvLZI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2ITwmA5kfDtbtZ6uWfB6lUtESSvo36T6t6z43dikF2QeNseltD3FE+73HrCXUkZ6wgjhQr+1XbWozYmfZ9k9fKwB2+bso3l6KRSqXiOSxvcqK+I2pyFqefMk7ftSS6D9AVocXGYYXJbTzmd45u6oMhRbXZGy0iaDmdgWjYA9iBye/90hLAXfqJDHqFBqx7K59DCrxBigWPGKQkOThWADl0uD+Hn6Nz6xJUnD2aurL405XKqK2yKWesSDK6m/dew6GF0z5ntEYukMQQrjz1HlCDm/vC6vJ75OOxv/CfQuOlosTufjSb62ZyA1P+/XvYxmeT01V6fVdwJXeaYARyr5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOQ7A6je51Fv1X2GQXdHO1MZyQrpIbFKGewMFHxLhI0=;
 b=It3vi6hgjKz/6JzvlCI45ZS17FP8WE0D2E/VV9UcvREDf/U9veQZPCxB+jBuwbzup8tfXRL09QLBCvHHfaa3h0QR+YWE+1NhDwid92lDTlmDag1yiWhcYI1VcDTDNZe2RA3Zi+Quj+lKc+uBmTZZk6EmPmgIRhYlg7NUFdo8NMNetFS6OfZjT3ms/3NeLyq+9JtIO1xrzSFF93fnBjPCOmo6XlT4tzjPrCzUi3kC/P6eN3rA6SpgUpWCviU+3+kallaCDBIvXHiMI0oe07a2MaWcV4eT8bnIJby8g2TSvHsIHMJZ7hYLU0fYFq0IHioc6wnx7RB7HKxM+g4Cj4KOjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOQ7A6je51Fv1X2GQXdHO1MZyQrpIbFKGewMFHxLhI0=;
 b=QASeVphByR1RUQX3yoz5AhGF0iEijzKMjtXKCGfSN8szXQgca37LSqao7XYtWKmO50AQrSBe1nPNSjgwJALyXsmAPUYjM7QQW+AwbUcMSX0AAsdoxkT4ZS5x2Lfcfhcj60PE+VmaXuhFTcRZsX3my+jEgWxmZ7q0motZZffqwlDe2n9fhlKR4mLYoa6NBnBxbARa3M5diC1it168fWxeyZfpHEcQlQcNONnhtgw+8RLfwE4ZGtnWGm9fLCgAAEFOR+si7CXxDrkuSJzui4PiBDeE7o6Gpg6RrJNhZ8FkcCehZabul170nJWzTjsF2RImdQeuQLw0D/Wx9HMabDYV0A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9264.namprd12.prod.outlook.com (2603:10b6:408:1e8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Fri, 27 Mar 2026 01:43:13 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 01:43:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v1 06/10] mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
Date: Thu, 26 Mar 2026 21:42:51 -0400
Message-ID: <20260327014255.2058916-7-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327014255.2058916-1-ziy@nvidia.com>
References: <20260327014255.2058916-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0012.namprd06.prod.outlook.com
 (2603:10b6:208:23d::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9264:EE_
X-MS-Office365-Filtering-Correlation-Id: 71df9c0c-8736-4573-3391-08de8ba23553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 M/5qczl8ERkxUbTn09heFWFuMiMITzStUSzcXI5ReTlCQIMUO8x4IeuS1GJ1PZ6KvYSC2HraYusu3i/jMOZqaRwukaYGGKzQo6oXnYX/QPrRyNoAaGnmb1smuwjA10/GP6/cnOBXcKJteP2ICzQmsuYaYeXiJEZJKUyDMYUWubI9BwHn9sK52BxctieBkLy5Q0wL/7GsQ04JeSicWVTmz28JtLO7eDlcc10DSBtKx8if5976/xIq4VCf7i9QM2uILAPx74UtnxG0srK+9FvvHuFSF1a/is1fofb2/g3oUkCx2QK8Lttl1O8ghd5mExqE4Tx0ZWrxubvF3RJ9Rwj7FqjRH8dQZw9e2P/BpesLZKSMKZRQlcV0QH7NVwSWRd6xHTe6R9oMyxTtqVUolvOLau6gVH+sm9Yvwka35d53XzHdabw/J21i1DjLg1RXSzxArtc9dDZHWRp2Tuf1kRLWKZi+Ml+NHEv+XCvTiZwfAgo6cCnF4TyEfxMLl95DAPcBv1SJ6DXRZMifK59iPXHy/EpCrQeGlEDFSO/jr4wQdpQzB1X/ZaWA8FfLYhRtksGum3VgW4Y+WRBUzIbdEJNbFWAGYAMfaB51fC6Ldkqhtf9cna/1pC0eYzu8l6ZfOGMLBvc/Sev4hSFiCN1Wc+AnvyWrtB0sHUYN5H4p2lcaefjukqzRrfOMLI6iONg6C9jOBj2/zKR7cP5NbmXdcNTJ39g0DjCCQaipo+AbXiGuyPw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?oxs5I9LHaaRrT4GcTERb/PRA1zdP42YvzKDPRAK5Ccx6dpME94lm/NiGNIri?=
 =?us-ascii?Q?//GLpDm1u79ZyFDEZwP4XwEDkWg0FGz1RT7UmCLcLH0LW3cD8AF3Z/dGfwX8?=
 =?us-ascii?Q?sWkw3uuQB19BQNtqRgRBeBoPU9jjYOIyqamRpZGvTCu/1FLeBb52qJw+y0/h?=
 =?us-ascii?Q?2M5/zspOjKyxx/Q3IZ7cym+Vh8Z0ASvouXoq+RPYZ1xUbl2CrbN3LsSJIPcI?=
 =?us-ascii?Q?CVC/KQFAbbCbUNZmF1yrltB0JXfnga+PotcODxKi+lKwQnG9qG+CVYrRsuaC?=
 =?us-ascii?Q?sRgtxX2SOhVgoKCHzY1WaY4dU1kyQg6tSGznrhLAaqTSIunLAalnmQAmMOBq?=
 =?us-ascii?Q?EeQwiqA/ErjlHcmUyY5a4bgWNI9e/vgsaM3wP05hA7ZuYo6MXhpyDG1/DuVo?=
 =?us-ascii?Q?jYXwVcK1cKogtq/kGpiw4uQYTLbAQGJrvDoj29FB6E7celSdb3RGSACe0RgP?=
 =?us-ascii?Q?lIYsgGzwJ0b6xSumxSGiipO7+YDPZZjY/1jO54drk3G8uaAO/UQZ5mUu4IW5?=
 =?us-ascii?Q?XxPnvAWMaCtMbyAne9rNqrUgBTTN5/FAWHhqPDTIk/7JSEbi3wovQhKYkiVw?=
 =?us-ascii?Q?PHdo1hAODtrTS5CevDaFSKvgL/1Nfx3wI461SOVuC4yubIHth14TzQAiUMnY?=
 =?us-ascii?Q?8Cj06qUfJbSk9C9Uj1RUUEGvYkGHM0HFfryPD7PIrfGPYNzept4Bthj0N3b9?=
 =?us-ascii?Q?bqz4um49j0UUbFVD6L8AH63y7by/6BB0uy/eI7dxWp9UOgTpRfhnnpg04ziq?=
 =?us-ascii?Q?FVMTmfvS2TYC7g4AR9pTv+waPQujb6PwjiAsX5YreNEkXKYrAzfvvOeeVhJr?=
 =?us-ascii?Q?q238Ye2+Ougr6l3/QFk+ya5k6Em1Bs5eFiWdbBbx+e22NF0pqSMoW6gAn9wM?=
 =?us-ascii?Q?/bqK0JYVp0OaM/cDf7DbB8PdN/ppg0Xxw4oD1KFy1plIxD7dDdjBjqnMHK/2?=
 =?us-ascii?Q?zqOsTWnxXnmnlnaMprhkdQbJsXejfvr6oRe0nLu75k5T88qJ6k2K/2rYO2Qq?=
 =?us-ascii?Q?rNlEsbfIsZIhPvVEFzIYQbnqkNiHsYJx4iG9clLKymKE4G8vxyeRiO1S6Jyo?=
 =?us-ascii?Q?FZD/KxNWQsZ8c0cQ7+d17aAj3tkaxwPrj1azXsubH1wiaTuC8dxbLmlqw53J?=
 =?us-ascii?Q?F16APko/JdpROsLEIScPDQgtvvnhLzoVs+vXf+zV6Icl9MuwwtHzhpHRavZR?=
 =?us-ascii?Q?Shjz06p94WPRvDBDmtRBDoGxinEDTbkrRkYNqlPvKTip5tKt2RInAFunaxyd?=
 =?us-ascii?Q?k/LRM61hb5Ri4+4Dps2TLhzfibP7oXs8VDEZ4rE9BXQH0fU7k4oJ9adiIWTU?=
 =?us-ascii?Q?lbqnV+gZ62XpTj0FrKTB2Hjsitwit0rINt619N/gUNt2JsYzFtqk5Do/FafC?=
 =?us-ascii?Q?VnWJYSMGrv59cFmdnUFLzqlBBf3hfA2qbOBu5lsXVGKZeLA4kJLgF2ElQWM7?=
 =?us-ascii?Q?DPl4+HQIizBtLs0cDg77nmuZdko0xbeFsdSlV7DmDUWrvyDeUlun7hjHxS9r?=
 =?us-ascii?Q?7zQT9YlG7EwyJiHmZZN/aap96wfx56xvK96k/g157u0QDRR9hhpHkhzk0VgQ?=
 =?us-ascii?Q?R/3Z+IJehuLihThcAmlL3JN01WgoAtl7Cr2mmF9/bQdl939jr10TwbXpge6m?=
 =?us-ascii?Q?l+kXRMWzKtWMyC2TmOQJEwLMw52Z5ERnmp39uFaRv1KsV21gvw+VlR+mnc33?=
 =?us-ascii?Q?0PpYBAQgWBWOfpJOX6T+b4YCj8BglTaoD4uUx4RxRFWWHUsF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71df9c0c-8736-4573-3391-08de8ba23553
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 01:43:12.9891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efQRywZvIcJvoRcrtR1nPttwOk7ugJCW1ikJKITugWrmWqjyF39L6ocGjAB3jKdK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9264
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F08F100005
X-Stat-Signature: qh85ijc7wh3nwzhoi9wepyenb174rk9q
X-Rspam-User: 
X-HE-Tag: 1774575917-206890
X-HE-Meta: U2FsdGVkX1/vs7NMydZsOAJ0bhryGJt1OTYeCfv5nnzsO1ekbfAqC31Ds5oHw3I2t3k4oOCMnyK1gkhS6E9wrDHFkSDzeGRzgYYjJogQzt+XI4sxRCx60govsu9ZZdi3hy/y5622WRsoQYBbRuNYwaA1SDqQEfa+JMa9u6g2GgCBkmKJpAqllyZIXBZBIogO83ggdmFbtgrianAMCrUKO8kLGuBwqld8cPWsgw+AHBczVHrnyv07EUHJh+FlR3PIipkQDo0tWx/yQ4WLhUtVX5Owa3OpZa1VyTI61uTgoUDpIXZFBeEe7Nbo0YXhS6oUuhSkv7Uk2c6WCNVMfE06GnNSXM1OQ+hYjCD3zl+3xSNCTnwqZl8pVVzIas6hLnteLknvvaOjwawMYkxRN6klOxuGOJXelBUfNqJfEMJ9fe9AcglgRNKa8d+UBxZALqIhZq2fBBE/k9Edd/tnjz7OCOI0LKOK8BRPlX6cV2mmn4dDPL3Ez3kkAkCfz9M6ljyadqfXG0zvGzMZxujqSUzmvxuOr/RqC7CQYlZ0FjftLjoH0LHphZBlOGum/cc8kGViXUACBXv0m5pB9bILZsR/9F5NEPFcy6g8/WDxKhUcgCzhvDV1uQxdkkjo+GLx+QbAap/UpbyQTeSedMtvvFauSxwH22HxTFroYCLnJUXWJlv39O1CvDDEOSRH8tn5nBsdm66nKz33fM2lnUU4CETPMsLuw5vzSV7hSzccOKHlVDXfrM3sWdAcan/lRhlUHCa1Hkz+LWNWLmxeYNB/pTtUNUnfIw5ESbNu+TSQ8bzfGhRRf1uFVDQTOaMZf8vZMtO5q42tU5uHv9iN4oT9tpCrhiTGQDlFglawP47/4yMx7ER+XcG4qg3mMR+39iBuT9vRJN9N8o7J1iLOMNScTQhe0ByVVfZwV2WamX0cuAQBboaqlVe+2nKEaTqoD+i9TNoEQbQs/UHiMalhKP+hOfy
 8iaplpp+
 is4BNpGSVa3Ryu4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
a FS without large folio support. The check is no longer needed.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1da1467328a3..30eddcbf86f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3732,28 +3732,6 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 		/* order-1 is not supported for anonymous THP. */
 		if (new_order == 1)
 			return -EINVAL;
-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
-			/*
-			 * We can always split a folio down to a single page
-			 * (new_order == 0) uniformly.
-			 *
-			 * For any other scenario
-			 *   a) uniform split targeting a large folio
-			 *      (new_order > 0)
-			 *   b) any non-uniform split
-			 * we must confirm that the file system supports large
-			 * folios.
-			 *
-			 * Note that we might still have THPs in such
-			 * mappings, which is created from khugepaged when
-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
-			 * case, the mapping does not actually support large
-			 * folios properly.
-			 */
-			return -EINVAL;
-		}
 	}
 
 	/*
-- 
2.43.0


