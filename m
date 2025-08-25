Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9939CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 12:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10CD28E0019; Mon, 25 Aug 2025 08:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4BD8E0001; Mon, 25 Aug 2025 08:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15878E0019; Mon, 25 Aug 2025 08:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DFE588E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:30:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81CC9C03E4
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:30:13 +0000 (UTC)
X-FDA: 83815212306.21.F39187E
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012038.outbound.protection.outlook.com [52.101.126.38])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6AF4F10000D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:30:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=UjGHoGvZ;
	spf=pass (imf14.hostedemail.com: domain of wangyufei@vivo.com designates 52.101.126.38 as permitted sender) smtp.mailfrom=wangyufei@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756125010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4dZeXYtIhW+7M5bTxjpHgKLeNjR7ibXL/C58jyfb/WQ=;
	b=y/5DlMDDBspijDwwY8shkoYONBXYmgTUvqElQHg9eAMG4Qsx7097K7rEUMl5yVLbIJupKY
	ycYl8akec3qyA9AfnFPmANIxSCHmydhej2bhtHbFwraFQoiv3XncUMI79VQLMqDzh5WAD5
	Twtq+Z5C886Y0sORJe7WyzK+S6VmquE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=UjGHoGvZ;
	spf=pass (imf14.hostedemail.com: domain of wangyufei@vivo.com designates 52.101.126.38 as permitted sender) smtp.mailfrom=wangyufei@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756125010; a=rsa-sha256;
	cv=pass;
	b=bAUJXdyv9IEp7QDeJpCoZJz9Hj7Pg3WUrNwaIO+LqorXGQQvKA5pGX0hMvjaO2bfNoeqNe
	Mej7ILm4VyvSH8/UkXuM0JT+RQ1aA0HcXCckbwaWLw9TqWTrE7pHc4WgCMjvg41MF85WPG
	G7XFJHQq491fAiSaqYswMm7Fjl2nfug=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N+nYYaEpH8ro89U2bH5aL+to9q/iw2HQhvVnxiaSe+L8AuOnIV25pmeMorsXrckxyq9MqK0fDwZyN+WueRH/tOU8Hofv9cBkBbDZ/q6nBvZu5EfA13G2eL/izNHApr57DJo8JUbAmzepxIZohaBxDujtsR0pBiqp6hKVFfd+j7qhF6DwNzqRI/Pvg0Fv0zUD75rHI+dWGa80GSyF9Qe+QIsuvScmsfsKkp3iwF5My89cg+j2q/FjV/b1twLHIktH1caj03BbGnmiVu9hrwxLLfhZzooURsa8ZGkajRDCog7AKa3BHaCyyCo0yObS3ak8qvQpkliuJIzt1beL7ylNtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4dZeXYtIhW+7M5bTxjpHgKLeNjR7ibXL/C58jyfb/WQ=;
 b=F1pfCqzozV1cNzj/ILBhL4HLHQmwxaGn2UdzOpisnOtXOyKU0tVi/pNIuoAyq2h5pI2i0ZtkoBb9sT4wa6ekF48Od8nv3DVyJ4ATCydioWTdsBK0sgKA0mxF07vn52kVzuU4Ku2B9ycB6JC+VZxc7ZFQVYG3pZgalc8rteGdgrvPGj1/XT0LDNmgaozGk9oovuFG39dKv2Ef5tjrv30IDngf2bp6jqboeSilkbeArnuEVCFoo9qs5Tihz8DVm9U4c9ck65/v3P4NXZxFH2dAQBFQ2VkW4Ce6es1Cg2JUD+EAKWYj/Byein3y0grVpElFARWADHI1HH1qvVq1nGar/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dZeXYtIhW+7M5bTxjpHgKLeNjR7ibXL/C58jyfb/WQ=;
 b=UjGHoGvZAPxq/A94C7WPnn+ZyXgv1UekBqqZrwhQsp0LpNif1w12EUbz2ti/bZYjrQNcUySjOjxt8Kq+MDsWmF2CSAdZ6w/05oxlp3VX7g9LRdmaVfyJveJ6yKGY4DPcZ8ITccBNPv51pB13UeQbkUqQqZKz44Z0/9ByxpFr9shRLvbCtneH5cEhAbVF9FACJe3XJnWvCQIek95QgsgrDYc5k+NcK4usp8UvFjOEQNS9IyrSjEVKKJ1xOa7uTuhDCIGpy9QjnRoKFiyW+QCpuXXQ/n9Ak7cMKdPS698XqjQ3NJUVTtk9N1y6zMseUuGybj7y++4e+UYJ3puseUTwtw==
Received: from SE3PR06MB7957.apcprd06.prod.outlook.com (2603:1096:101:2e4::9)
 by TYZPR06MB6113.apcprd06.prod.outlook.com (2603:1096:400:335::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 12:30:05 +0000
Received: from SE3PR06MB7957.apcprd06.prod.outlook.com
 ([fe80::388b:158a:e14b:79c4]) by SE3PR06MB7957.apcprd06.prod.outlook.com
 ([fe80::388b:158a:e14b:79c4%4]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 12:30:04 +0000
From: wangyufei <wangyufei@vivo.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	wangyufei <wangyufei@vivo.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MISC),
	linux-fsdevel@vger.kernel.org (open list:PAGE CACHE)
Cc: kundan.kumar@samsung.com,
	anuj20.g@samsung.com,
	hch@lst.de,
	bernd@bsbernd.com,
	djwong@kernel.org,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	opensource.kernel@vivo.com
Subject: [RFC 0/1] writeback: add sysfs to config the number of writeback contexts
Date: Mon, 25 Aug 2025 20:29:29 +0800
Message-Id: <20250825122931.13037-1-wangyufei@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0099.apcprd02.prod.outlook.com
 (2603:1096:4:92::15) To SE3PR06MB7957.apcprd06.prod.outlook.com
 (2603:1096:101:2e4::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SE3PR06MB7957:EE_|TYZPR06MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: 151abfff-31cb-4fb8-ae28-08dde3d31e23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|52116014|1800799024|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l+qKvIhoB0y1tSB7QrQ/zz71kmB5/q330o2F6SjT12PWqiytlUnu7jnexGcx?=
 =?us-ascii?Q?30Gv4J+Cwyh1VktnhxNc3WINwkTCh+jpiaVkN7rWurOIshZncCd1Xi8mweZC?=
 =?us-ascii?Q?j6OR1fJKVJd/ymLE7ajWV3um7QglJpgsCIvGhVPp0F+ITHwNLD1I5+qlrYFM?=
 =?us-ascii?Q?O/zDkvEHrIpokfePnT6NTyr5T53Uqaux7rABaj12jv7O7h2/4c+zJBIgy4tu?=
 =?us-ascii?Q?dLNh7KABJ2iiM8WdtFdmbxvsnzu8I3pzqQU+HpCKrroj12r9V4rjFgbYh0fv?=
 =?us-ascii?Q?dhVhA5H5PHotesdAjPaVqFZdJtiIjoYvbIU48jsOgmMgATlnt89WJUsTtsNm?=
 =?us-ascii?Q?DXQlny+T7E6D6QLGgztZ2QF7u8ajnL56CjWgzy2nt0n0hfpOa6Kzzt5OPBF5?=
 =?us-ascii?Q?YX1CFfEnAbaoYQHMKh46IaLxORX3fC9MpUN3gEeddWXLuOnXEERSwXZeX5IA?=
 =?us-ascii?Q?o26/rt/5kwFPHjUztZrtEl53i/3tDDlWLfeXhB46qp8urEWb9zsh7Cti5IT1?=
 =?us-ascii?Q?YHr/KUplztkuYLdZh2mYWoBYAf3u/2EAD1NZxDsN9Nf142elILwGLchJsOV+?=
 =?us-ascii?Q?RP0TomslCGLBm3TyfkShf2EIKQBIN+nKLM4gdY2XBPHtdz+Fv8IagpY04bZc?=
 =?us-ascii?Q?J9QqBsI5y3SnjLPME3VeiW4sx8phZMckCoOQ6pXx0z47wB+VGs8A29CXtCX4?=
 =?us-ascii?Q?gE3UBhyLTXFrR+h/QqReJ1blfeikL9Uz26a2HiFlOvk7oTQ2R/m94/hF3g5W?=
 =?us-ascii?Q?MfsIm3yW61LT93pjY63S6CMT5karHF+/F+kHV1GOmNBGJoaXR4fEi1W4bZeb?=
 =?us-ascii?Q?QyM7rkKhQnZimw1YYvcfbxt6poeaOgfLQN04H5I6Tvudcaw2z8OflkKF5nf9?=
 =?us-ascii?Q?/P43zq+A7Tc7iWyu9eBU0IxAK0WiTCqKhtXrR0dJkY1Ljmfc8aNmlFf24sO9?=
 =?us-ascii?Q?yUCatVSzouZh04ATk0sRsjIUpbohdGbciqM0Y7Syr22jbS2w8ZWQveZ+CiyT?=
 =?us-ascii?Q?4QkZd/Xsn6h7F+6WQf2g44WhUdraOBzvEOa4sW3gmOLTrjYBD9P+bq5p475Z?=
 =?us-ascii?Q?g/SokN+kCx34DSKQHZQHvsWLlaQdVUYE6kUZeVJTtftM0zq3lH/B5dA67XS3?=
 =?us-ascii?Q?rhB7QwoFujK8Jc2i2juy779baC0FlEQNGP6H7Qb25WWhtRgGiFQNztW6nm3G?=
 =?us-ascii?Q?diddq6RW/7/CIcq2spxHONgBz8b+TUSA/xZXW3x+hXUUlEgFurU6JW4SSuTM?=
 =?us-ascii?Q?mtPFctmfNoz8mHMsoQV1cLg+Pz7kjOhhME7esKSf6Er8uFjvI9Do/yIxdtTW?=
 =?us-ascii?Q?mRDcdFisst8febW5EpxINBxeI1XFYT7EOeuNjl/KCLh6TINjm2QuKFJBwz+f?=
 =?us-ascii?Q?yU5i+tZ3BfRWYI7VxvlQuv8GqC75A8RRzA9/jyVtbd4BzrRR7wXEF4l9qdGg?=
 =?us-ascii?Q?HyMbduKgY2Moes3C0T427/BX133MFL5bXz/Ld91e1Q1PkZYxL+wnY1WdWdnY?=
 =?us-ascii?Q?5rgfiG9mLu6Y0jU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3PR06MB7957.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(52116014)(1800799024)(366016)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LzCQNVom/pRb7v641WuaXWhEHt2Y+HCYvWii5vDSt6p7YY1grRoDx+ILAnyf?=
 =?us-ascii?Q?st/GHTHu3irrHBr/cusQ308HW+OH5b/Hw4K98bT3b3Er4jaMfEzhC/OD5jrS?=
 =?us-ascii?Q?BeTLYxGvIhQvx1AfLDOZdwc53G3LdB5GzIkgVcDnD6G4y/ia7delVA7yLjje?=
 =?us-ascii?Q?EolkPDkM+r0/GlrpcwZ7c7mO7msZLGm9ScYoUPluDAYIk+nqlmrwYAKUrbR2?=
 =?us-ascii?Q?OqKhA134Pwh/ohSLWfL5MjE2FnNOFa7nN8OSdvFozQuBQ2Y03H1UlUZMtkD7?=
 =?us-ascii?Q?Pmvi0kE88L/cmMfgqwP3l4O/uqxo7uH5Xu8F6Bl/uOLS5FwJhjJLF7XkZURt?=
 =?us-ascii?Q?GMiIBNWQLGtLeftOZZ7nFIxEN60nAssuyOsq2RzkRJIliQFKdhbwS2gPcYYu?=
 =?us-ascii?Q?/fQEYEruJLCz3B6+000ZsUs50PrfP7MTL/VcABa8dp2O3bhk9FuwBSsAvJnZ?=
 =?us-ascii?Q?FOZCWu1ejXbIaMqhfIP5/V+uj28vCSJmtFNoQcoyC9yb62bmeqaVwkEMhwaj?=
 =?us-ascii?Q?cv0TSrz1hZYyOO5SBU0MNE6aBMwAf5DPP5rSgiONO9LQ4C11MSUCkITXNEJM?=
 =?us-ascii?Q?G6mwKxrChu4fJXwjCQjA2PoK2RoKk2IiDbTkwI/XtYfWhUH22FuAs998h1de?=
 =?us-ascii?Q?CBzqhqvxb4dljrF+kStUVpao5b+kPmMMPRzskRvzyZ0Pv7HHQr9W+5TBjksM?=
 =?us-ascii?Q?V6mFet9EE9AYWxSYt7ZJ0dbb6HhJ0UM6wVqfyAoBOYwc8kkxlViKUm+EhoUq?=
 =?us-ascii?Q?+v/55GrpPPAqzhcertXabp+RD0mZX5u59BXPrvUbyapYCEO9wPdWzbTwlAO1?=
 =?us-ascii?Q?ngT858UJusOrqqmt8VwlPno7tJJp1+O3/GUSKVTOtR0uk9GAvOE5gTbGOiga?=
 =?us-ascii?Q?HPaFzDeKrcWyIPPWeG52Qax6czo+zJK6vj6pu5HfhRC18cwoemq5sxaPN07v?=
 =?us-ascii?Q?U63RSaGPV9i2ntQXR3+xI9nrHaSnd5Gdtm27XaBi2puKN9YJa+pg7fTSC/3e?=
 =?us-ascii?Q?jnRyypbz1B6PqTaKOaDxAyvsSAeM9eKu9wnwI6Vh+6BT0DAdq7grgqwhPNjr?=
 =?us-ascii?Q?D/VbkX/xsq0YMpVRPFYtnmkEutAvAYSdf7PEdwcgG9PpI4P5yACSgSTEWC8U?=
 =?us-ascii?Q?XKLdazk7vdQcLAKBqll+wg9WcNDKJtd+3DHdmm/Wy7pE188BGvXDY2DFyyJq?=
 =?us-ascii?Q?iUdtcvaCkyPCPRvSsIHlBPqy5RBSPOSHG23YoBMbm2tZe5802aoUZ2S7hN0i?=
 =?us-ascii?Q?E6FcWl4KIcrbnGlB4H2pzL9sW0hJB4O2PPw8ZdWnUMcjNMPEa8A3hVZwk6oD?=
 =?us-ascii?Q?HavFUwqZ3Uj5T1jV7e05C9BYxf7zWmQlaaoTcQ25NHbgJ4RUQBnN7bFAtHx0?=
 =?us-ascii?Q?tYNhUyXAO1L1saPrKJ04yBJ/U23n6+vmO3sK4hf64ckGS1oWp4bZPkYtOso9?=
 =?us-ascii?Q?aHxU84Nhf05Zi9crLX/Z6t3dy0Xo6ErcYN4psGlzLUVQmfu6XnnDBnaw615Z?=
 =?us-ascii?Q?J2MPzgxU/ieokvLevdwrCvZwKhqNTd5OpGVfp69yhiSUDULSiRSO2HZFFzCZ?=
 =?us-ascii?Q?6ct/L5ExQdmeOauwRf1GwK2lmglrCnE6gVDEsQ5N?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 151abfff-31cb-4fb8-ae28-08dde3d31e23
X-MS-Exchange-CrossTenant-AuthSource: SE3PR06MB7957.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 12:30:04.1874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nr3+vVihql8iutiLfjNs4b/Nwyqtlbmjnf2Lk6lrPaeTnUYI7QL7dGdnU5CY/px7Dzms11b2ABEQU0cn0y0OFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6113
X-Stat-Signature: xywd7okwmgui7x3786m1hmuq468eb7fe
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AF4F10000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1756125010-74062
X-HE-Meta: U2FsdGVkX19Q70ykmOXmqXV17MUHnqQXKWXQZnIToRhFrz9YCLc9XJfA238WxotNt1VTPllYr9cSKl02P8DkmMzrz3TsoLswJwIhz+YiO9Pf3wkpNI2aS5O4bH0jOOkKmcTu8zrS4ydV43SRk8ZJBw2z5JcNfzjprxx4Ihx6yekUKqXNhp4rkCqlX/zlTYQZr09eI1VVjndqKCI7VUN+UGz1X5jF3pMRJG1nb9oamTlD0N7nlHTZy4vs4GAj3iCSUVdAGzBPlQGXlp3zFHVIrr9+YlRnHCdJmjulyFq+COc9vOXfa0yP99dyWEqqfrQfuLCTWMg84UmZL/0a1p8DOihfEbCcAfvewGJP99wYOdlID9I7+J8TqW+JAZqEN+xBF8tini/OsVpCa9azUyMa67HLFnuCNA08g7Nfd86VMDbJxOfog46EtpeV/ThUxiVu+lFBpLAZdh16EyXnlxuIxAYZ4e2ha+YYK7hQvcvjZQzjuyP0of7ydrRCH/nOiPtJcijbeHZwgTzfvyaUixfSRuGYIditlisfUy+EXj6J1gCA9IK78NLk+MGc6AV46mCzJq1dHIR5IEwyyjksUvkGiQKiUDz1KI/TfsLcSyGH5KCM0+cPuqt0mZEzKTWYTRyP5djYsdCqMh7gF2QF7/6tDHQBuBfVvt0T9HbDA6oW1ocSPKPYbsebWKSdbyfp9pvcpLzoCeLq1sk0dAuzuODBm49CObsw8iGwL48fxhpDh8NxnQk5q/ii3zpDh8z1poulTTpkFK+aBbSewvPq/i3rHIM+mMrfjVkqzzf+ml61sGo4EaZjYiifIkc4bjU2st7blWAB8Sx0rvcI68SG6pWzIy+bZWfAnVQT7lam+82PZb1+poTHjncPhlM5rVedtvHkTs52laCSFg2MDuXoj12XEMbRv/W9PiRBV+dm8uW+DJGJH2/f6qkEPjhurFBqYz1/tsuAXEnhHGgl/N7M6B8
 DqOuU3Am
 Mkecbl5CRZKpKbAuLBr6PopPtvaTnnv1SABAUVCdk6FMLmj1WEYC2VPaVML4gj5OWHLdTGyhJDf6rViPgkzxRe3Eqqz3mQ8Cm8FzWyI0azvSBIwi3TIdmhUABN7v/+fNO67PCOc1euEXhNHqATX1CB5Lf0EdTiPG9JEBQEHxzrZ0n5C6Bf6CVu8YLkHUO87ugBRlLx/jF0tA6noBeCRJACOSoWQYVyL8sC0zV/tYa+NvyitivMKZCGnbvnwNtjL7yvqR3E3iH7rBj4jwxY73HdP0zk5HB0SV82pZwTL/6BlKXQVGoZNHIhCVNOAm5bloe2AVHnycwSRUpu0LjhvwvvdPLgRoBsKJgB5Hhvb53Rj9qpiK/UirR+x3dVS77WncqPJy9+f0IFylpYnifx0RdZAsyKwXRUSxC0yitkr3wDh0XHUW8nJUtz7n+FWm/gUmvh176vIZAyLpz16fA1MV+fvdVJ2HFEBchQeUFcPxoEo0Dcw9Vt92KDeDO97MAASn2DW3CS76z3TrLqRMWtHj2Bz32YtYmSjy/s36KR1llN7MtQlzFp+QjmZFZ84Ecwtr5Xt9lAunMMrMUeR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everyone,

We've been interested in this patch about parallelizing writeback [1] 
and have been following its discussion and development. Our testing in 
several application scenarios on mobile devices has shown significant 
performance improvements.

Currently, we're focusing on how the number of writeback contexts impacts 
the performance on different filesystems and storage workloads. We noticed 
the previous discussion about making the number of writeback contexts an 
opt-in configuration to adapt to different filesystems [2]. Currently, it 
can only be set via a sysfs interface at system initialization. We'd like 
to discuss the possibility of supporting dynamic runtime configuration of 
the number of writeback contexts.

We have developed a mechanism that allows the number of writeback contexts 
to be configured at runtime via a sysfs interface. To configure, use: 
echo <nr_wb_ctx> > /sys/class/bdi/<dev>/nwritebacks.

Our implementation supports *increasing* the number of writeback contexts. 
This is achieved by dynamically allocating new writeback contexts and 
replacing the existing bdi->wb_ctx_arr and bdi->nr_wb_ctx. But we have 
not yet solved the problem of safely *reducing* the bdi->nr_wb_ctx.

Several challenges remain:
 - How should we safely handle ongoing I/Os when contexts are removed?
 - What is the correct way to migrate pending writeback tasks and related 
   resources to other writeback contexts?
 - Should this be a per-device or global setting?

We're sharing this early implementation to gather feedback on:
 1. Is runtime configurability of writeback contexts a worthwhile goal?
 2. How should we handle synchronization and migration when dynamically
    changing the bdi->nr_wb_ctx, particularly when removing the active
    writeback contexts?
 3. Any better tests to validate the stability of this approach?

We look forward to feedback and suggestions for further improvements.

[1] Parallelizing filesystem writeback :
https://lore.kernel.org/linux-fsdevel/20250529111504.89912-1-kundan.kumar@samsung.com/
[2] The discussion on configuration of the number of writeback contexts :
https://lore.kernel.org/linux-fsdevel/20250609040056.GA26101@lst.de/

wangyufei (1):
  writeback: add sysfs to config the number of writeback contexts

 include/linux/backing-dev.h |  3 ++
 mm/backing-dev.c            | 59 +++++++++++++++++++++++++++++++++++
 mm/page-writeback.c         | 61 +++++++++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+)

-- 
2.39.0


