Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC5E5CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 13:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9C06B0093; Sun, 17 May 2026 09:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670306B0095; Sun, 17 May 2026 09:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389FD6B0096; Sun, 17 May 2026 09:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 25C706B0093
	for <linux-mm@kvack.org>; Sun, 17 May 2026 09:55:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFFD11C041B
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:55:22 +0000 (UTC)
X-FDA: 84777058884.30.3725148
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012048.outbound.protection.outlook.com [52.101.48.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1B5111C0003
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:55:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZwX7dSAD;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779026120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehzXYQDIF7/6cmQ2TdeNHDAfB0MXNZsBNh+08worURg=;
	b=0UXQIAyLwTANtquMSEVUZte+IcSgdbb88IQeqIOdbBmxHkduj9Z9IbVRM1pYRl4V4of47S
	Y9MIySLqjMz9UBSx5Pw9FnBE+gbaKM3kV7HqRy5MWkiGQ7ZL9DBkCOQZdaqlpBqabIBhMH
	qIUQXx0w/769DfP1RlZ06ZNtNuHAEEQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779026120; a=rsa-sha256;
	cv=fail;
	b=6kAm9ehgy7oZHW/VpSv+CdYOXn9ziY94Y00levvHzhSUF96HVDrBYmlsM8t1KWdXyCytiU
	2v8JFuqnq23FicIUi3t3WSrOZh4UBZnEyQBWmIGHh3WDolx64SC6cmUdLFki0D0W4vRI3i
	6TSheYXhjs+O74wEoqgn3Hk4xaNqEJM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZwX7dSAD;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cUcUBKmPvpQ5SDVcdSLm5vex5OTPwDmD4h2J5ujxyHRNU2JhwE2aZEvYWy90zi+n1lchwzPOB/BD0ySTRygd4UxptsP1RwWBarp6Acjf8ABqjEfLtHtN83VEdkP5VDq/YXzbUl2ZIvjzqJaeCHJUjnK3T+t/Hzl8vMjCN5Gx/fi8qVC1QcmMUPNtCDrSYudz9FufPswaJ36Eo3JHuVGp58OG20aUac572sTka82/T/3RgraFJearW+EeIxdjBox4RzR7Ng/jYioc1Ik7SS3x0fAAYAHwMQ/8l2v0daxLVnOjFmrESq3rVQscBMfrTFZgnPqDBXDgL9nakqiARtNLuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehzXYQDIF7/6cmQ2TdeNHDAfB0MXNZsBNh+08worURg=;
 b=NqlPix+qD16um96Qh3VzcDnEBvUlDcD3tUrTm3TPT/T6ipTO3iAAGKO0leUhjDiuW0tkOQUCUGQ5URqVNmR1zqhoyJAjOsNptZdwC43c30AV6H4Jaydq7DkkHYqjMydWUCQr48gbWlIpnYYUIqvgLK31RbYLgR+45JXUyKpe3hYYqzuKsZE13xRSAoi29neWEqvhAGQ20IRgI8O/at/F7ZmEqwcActPqGYI3RaRVNUKgu10AX3RL/GXzKIQXoYjGLCTmrilN2YDpbzlRb2C0R4EHKc43vQgICQTW5j4yWVraxQyemTfwO7Qc2PYn+5VuCstr/01myNRR0raToPiTpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehzXYQDIF7/6cmQ2TdeNHDAfB0MXNZsBNh+08worURg=;
 b=ZwX7dSADkmWEDtsqfUFVVm6BqZUxV1xQIjkXnWbUjYTgSFRvJypmSwGfrxfVH3kGuXENNZk8d7Rs9zANoXKV7sTrSEvoAqmKeEv+bc1ovYWMtOAFrTAjYjWx27vAms7yZTOpjJrqkF8uEsxjoAkqEFfYMFV14nM47eQcZ7C4jUznyUTQrU14vWL9DPJsvqwXhMvzLDVWur0bCqFlMyk2IUojwW1xbv04ak/9w7fpfWpmGYlFvMc4zIuscedtPgscIcu23CdnxJOT+cbs9152J1X56ONE1RG6Dm2ESeHqUbG9d7H40pfk0tFRDeZJa21ic28uz8n46qlJRzZBxPP8sQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:04 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
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
	linux-kselftest@vger.kernel.org,
	Liam Howlett <liam@infradead.org>
Subject: [PATCH v6 05/14] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Sun, 17 May 2026 09:54:07 -0400
Message-ID: <20260517135416.1434539-6-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:208:52d::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cc0b694-06ee-4529-0854-08deb41be579
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	UkQxukGtRKBuJ9NSLW2cewsbxxkCY7jM3lcksY1WsVkpc4idVpbdGZpaR5o992b9i+68s2s+u68VNo6ETTh+UlIq14/0NkDs12Yqfw8WOUqUCEdQxnFBeXA6N16Vl21E0/oqzvbDGww59wBwWJD6kipdID6NfJFfivgw6s8zgYYRoxJ5UTRZWJcDgKijIsgoNO/qIHXWGotagfZMIYu/j4zYRkFQB/WwtVIZ9CfFXWkX4hD0sqwa51BU3NazpqBC6m+NXbn0vo1cd5PkBvZyo4UKPNIF0FhNl6Bc2iQjauC1kmW5GrcTq0cPjXHfA6pmg9FgnOuMMGgrvPBYGW96MKM3Jlckd5s1lZmctB/e8oUL1nFrtvheKLpN0TtAn/EEHbDenhwM12JrLg986u2LKQFpzab7Iue8NuvFgLzkhAhTW4fR2zqdTSLgwvTH9EiHjwDwFqvmXE2Q1zfzu1KKrbFDTGiColBltW6SLK3zAYdXKzVLcwi6o31ZkK3C0CQhJ1kmivvvoN84LoiDzTX+tpSo4IpopvvuFOQLD3zd+rP3JQJCvjXhEh7mOKCiy58goPlDGad6a7U1aibrIk+VhLZsbbtxw5eFPSLEv8oZ8FZtC3F4mNA7zy8UkbPbOgGKvgVTDsJV8ulBek7Ez99Pi0qhSSbajsJ1d022K+qBg8+1+szR6wCBF5+D/8X8d7SR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4c3les0XUL++lgU3d6EN4o7FBdrK2rQfDo4JuNRuQhdUggQaD8K6jPrqKOhF?=
 =?us-ascii?Q?LehiMNUj732iSx3vge42UCG0idj/iinci1n0WJHf9QW3O8UOFHKTEHkde/3a?=
 =?us-ascii?Q?1ooq5Mj/GmkGzgi5/vvfdPYVklc6o7TxYpJseD7sm2gH/SwpuTJJnfY/T5jC?=
 =?us-ascii?Q?5rTm/QdGU+wst+jf77aEdPZLUnuOtXkxZqUhR4G1F8xysvmObylP7+rJX1yl?=
 =?us-ascii?Q?rYSx40cjTQRbTIe56cmNIRGtkxt11FzGNCPtJHYhZg6M6+G8cOrFd+VeZM9z?=
 =?us-ascii?Q?i8vSjwDqN+kzI1dzHprWSsbYPTq2pABP5bYiVNw7uaj7+pYfjrklETU1aruM?=
 =?us-ascii?Q?byr2CWUscPC6PWJkuY5J4U/ysI6TJ9XGCX0kCv647JmBhHaQ5hAJnDnIHkl4?=
 =?us-ascii?Q?XFv3gVyn20XogE0rc/CeALttbZTEBjBnluZlyTh6Jhxw6zOkPiJl9Eo9zToI?=
 =?us-ascii?Q?9DFkEHT1MJxtFud5wFYELZhQJPgDJuWe5aKdg6q/0WHs33FMCo0RVcCln88N?=
 =?us-ascii?Q?oD9sFjRj7zWIGCvTQuJlnvez3l30cxSqye0Cj5D6IlCJJAG8ZQo3HFdkQ8hS?=
 =?us-ascii?Q?KSLzl+YV6R9Q+N52Zo/XNV+h1A1to09efGfHzzriPMd5C+82O0vmvm09BF+9?=
 =?us-ascii?Q?hlQK+TZNKGfcAwP/qeOBrLMnHOPOHuur8wdEEU+U8oGooNicVllKfq8SDyDw?=
 =?us-ascii?Q?dUthG2nYUSwKNV4i6f++KiHVgSBed0aKEoQfdx7UkFrZWWX1Ew76vgW4hty6?=
 =?us-ascii?Q?7w8kcljEW+yqG4cWLU46z++pyY7PegQYGeKO7A19/pyZtE+PaRTAnOtydlkJ?=
 =?us-ascii?Q?Mv0iPexiKLW1PupotTOzVhrJ6PK+GuVlMfEfPr5t9hA0DhNmFWTBv0JNMOaT?=
 =?us-ascii?Q?zSB3SWM9lnyD7G8J3rBlQc55L1E7bVFhyG36tMcrLRZxHkzD/I6IDKdvBZYV?=
 =?us-ascii?Q?pEmFt2tQgCdYl0dwll1L9GVWgHrYdibXBO1o/VVEYjtakFv8zm0Fdr40P6vM?=
 =?us-ascii?Q?TuOWXqqAXsrew5Nr4rmRCMSqu0Bk7iavmE+Sn92h9ld4kcQaOx5fVQcYTcTx?=
 =?us-ascii?Q?5h8KqaAbhFiFkJCyVKEtnbXgzUKtAz58So8Ez/BftC8OdMdVrL6gpxxV+AoC?=
 =?us-ascii?Q?ooFtjbmkY/wRBjEcXkrdobYUyAYfyMmqn9vbiQMzoU9BbJFZFHhosfR4bKUY?=
 =?us-ascii?Q?wnZE0MtnVftBHzsCW27XjOwkxGzgZFh8SRO3pUzmdc1uD4qA/DsXP5WTB8qb?=
 =?us-ascii?Q?MMOdV7mkGGhXqdFgq+37197VKExv7h/0bgwHHtlZWubA0qca79j0Kt375i24?=
 =?us-ascii?Q?LybeBR8iZrwMwM1IQtMjcc2QcbaLSD5dsGanDBJAk7jK7al29x84kYLZgoFd?=
 =?us-ascii?Q?YmCKeSjsefbD3YVA2z5A/+6kQfqOB/+bjUbMZ7eg2d29FmPavLgcc7d6y8H5?=
 =?us-ascii?Q?dSvFuO2o6njI1cU98Z0S5DbxCyAPA4NWXv2t2+0jkzhCiFScSIpivOwTGe0i?=
 =?us-ascii?Q?4Ise/IAuNX4a5Py1YSS28VCrC5ngbnI5MSgNlXuu2yRemasvWqtkbRgphOOG?=
 =?us-ascii?Q?6yDOrZiOyPQPAbFByBD1W4DgWTCS6vKZ3EIKEFoU217KValRdGaCvHvfUuHe?=
 =?us-ascii?Q?OvTuRJSbX6W8oszJO5ITCRtuVfNjhKiNqFY1933Dw9D0rRhST2VNaDMR4cuQ?=
 =?us-ascii?Q?QTSl7jJjR3lsVLarOElZDWkUSlhujdcZd0NU8zIYsUruNgyJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc0b694-06ee-4529-0854-08deb41be579
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:04.1017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tm0apA1Odt94CXDi41podFMWyJe7bxldY/DVxWdbrDc9x/2eyly3pcyJVwIsw7bM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B5111C0003
X-Rspam-User: 
X-Stat-Signature: zyuc3h4nsa39uqwb6cqwunho7tm175nf
X-HE-Tag: 1779026119-702616
X-HE-Meta: U2FsdGVkX18210Zh44BpcVrNHeru6RT+aCH+XKpGASlJdeNOxO2VjOmJ9spDdR8tLLUqSjX/Mawgx4kC0oihN7+FO0sWhjKRhoYQME1G7g3dlkJQ8HgORWSIwXC9joJLzDbUksazYqx7RcspzEo6dLQzGBhRcy7r133tbFjjn0kT+QXwj8h+DQLvceO33Y2TYmWC80aQ9adAa9SntZzuw52kCDcNI8ECKNjluvkJvu8htF2bFrdBBmCrEfA/ah3V6JO3w+/12fVb4KsPjcJ3X5L1c3RrMdm9ThHOKzBjvTcwg99mv5JRnjZq4GeEECgZtZWGxowyMW4mgSFzA0mpysa91ZESzDIr/uW3NRERMmYN7OUUkw4vmh+UtcLJA6OzRkS7HpHl2tOuy/vno15CL1lJMKbkiZsqZDMBVpS8AFtf2un7MAAEhbk3+xADxCsxYCVLoEH3PDNoNeeVw0EZ5AY5YHwDES5R/OWe/qS/DwkqrdwiDF+AXe1gOM+U0R5ER5I2ZQV+B8oWrmH80EV8xJu8G7oC8h0Y79C8+wHJ09rSgs7y+khvANpqlo3JF+UKlahhGMkSjL6BAgJ4sXU3yHTCmWWKVNREqZv0mFx32TVsohVyKoQJTLXR1SA7Dl3Bg+K4CfAh3I7Enq6OUS6ASww4maOTPlvR9TYZkW5r8YHvJVITUdLlciGngJOyF2N0+tz2UI/ik8IgFUPf5ARCuHx18OjZl8e1I/I0sIM4X8fxeEECLMabU86fV74BZLW0/PwAWSgV2Te/rJ9+++aYYR8uWUswV1VyOVut6BWxA95u6PIUJ0K34hMVaYE17S872t4C7TikjW86wRuZAO7b8XgjPxAn2zMUXsut6Yqx3hyIiPE/Ptta6Ze9VcmouZpOxULdBtT+G8v1Q6LziEKI+rG+bwb3GzETiaEAYmnzZ5tMLuRD3x1Y/RGGuty2W7b5aeGUldQBg1GHGS7eSWP
 FqNk07eR
 NmyjI9Y5bQBTsnEDfmd/Or84lYHONV9mwIppXNjPtHWd57L2AsXemWp9iAfr/hJsm80EugCNb27DH10Uq9OvroxDJPRk6rnhVczZCI5iXCCpy9H9BJO+nDTQ4PIuY30dC41VRLh1A7vie250y0JxJTFxTFEZRn+OE7SldAwAhjvNq7DCdnW2Bk9eEbS1uNGtaEDjBz4fftHsCf/A89526um8AgP3APA2z9IWLpH7jNYaUg4jZ8jerO1WxEZWSp4OmBf8tVqpeo0HV+Ct/fZ4kW3KJ7AR4R5flzqrc3DoU5t8l3oGRsYemP12+8OcJYEjtccdHafSTIYGheNkE/HbFgby6HJg0BKeR7C9e6Ga4fRDm5FLqqyaqmGn4lxjbfpMwNqF1oakDECDvGZyhkMg4LDZOtyAzeaSUzkoYkepnO8b0EkKRIebKlCWcliX5Dfgcl/lTvFTo5JNTHxmlEFJMwTRqh2bTxboyYoJb6nS9SV4pePj7/GiZg4SlB6ewAyqEv6hIYkLUrToyVdyogYcLGDNA/KIH9AvS6AblyJta/D8eukY+DPWd/YeZeSAGsgM/N3r7BjC0zARqdvhQ3X4lOt1OAWzpPir2aHsGOyj/WveOSUyWYURoFTEPBtKZ3QDOlW12ziMy5aKzXBMFhf8u2S+137iFw7MLZWWiz/fvTCcq2YmAUeK9QZmvhBaw1BooPkRSeZDoPwRX417IrYQXCOI2Pl97lM56TCPefq88Xh8TlifHspsriplIjNheyFog7q/ch1Osu7gqKK+OKJKiW+byZZiH6KO7obBmOSwkwIvVbidCl+DCGJaoJTFH1vIiNK9K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
support even without READ_ONLY_THP_FOR_FS enabled.  Remove the Kconfig
first so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits
remove mapping->nr_thps, which its safe guard mechanism relies on.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 mm/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index e221fa1dc54d0..27dc5b0139ba6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -936,17 +936,6 @@ config THP_SWAP
 
 	  For selection by architectures with reasonable THP sizes.
 
-config READ_ONLY_THP_FOR_FS
-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE
-
-	help
-	  Allow khugepaged to put read-only file-backed pages in THP.
-
-	  This is marked experimental because it is a new feature. Write
-	  support of file THPs will be developed in the next few release
-	  cycles.
-
 config NO_PAGE_MAPCOUNT
 	bool "No per-page mapcount (EXPERIMENTAL)"
 	help
-- 
2.53.0


