Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4C61067023
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 14:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079296B0089; Thu, 12 Mar 2026 10:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044146B008A; Thu, 12 Mar 2026 10:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91C36B008C; Thu, 12 Mar 2026 10:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D97636B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:00:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 572B88AAE4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:00:29 +0000 (UTC)
X-FDA: 84537570978.03.7458DAD
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012042.outbound.protection.outlook.com [40.93.195.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2AF2BC0011
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:00:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Jx+JuUKV;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773324026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctevzFtcplbZ74O/HDKpopiNfjNHeItQjGdCCe+K52Y=;
	b=MilCo57cKc4FNqxyIaL3wp+KJvwRMHsrkv6h4UUqhmtGzMEl5pgZkYTSxwaiSot+Hahq28
	5cZCV7W45+1roEXry0Vq3UCQmItIylAMf9tKBTdGFDgCetWcS0NCjUPVo7SuYgs1hIU7Bq
	XdNyuUfwQcqMzLkPP9G8OTZ3mA7hxRQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773324026; a=rsa-sha256;
	cv=pass;
	b=6lZ+8uMVNSEVVtOhQeQZO1iTGJHJhYmIMsoC5R7jlyisAVrNl7y02gPuHHkBELJkGyUl3g
	hMl3WB6oHkwGbVoyyFOLFFYHy6D3u23NLUzruPnHXv8DY/eD7pOT8stpNbte5YG9gQBVux
	gVpJz6I50YF6CbBX9aSfbwo6OMcwEkc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Jx+JuUKV;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HwP1EJF7IIxgiHKlI2D2DD9YFBoZKfVxJYlgEhOjXMhUP21QmmxsE1CxN1jwjjs30e4vjk6EpzYB2Br3PnNITP4VSNU/G6qOjnXgWuPJkicpKPglE95xc07Px6gq9tXBPxgNJwJwUA6X+iUyfZxMy4OWv3yP8f7Ua0ORFedimCWd7BC9i5x4SVRLY83c8PVX6N0vS+vb1VRR0zxjlkf0IJuqSacGPDbzxk+kByyOqXcmoozPYM+uT6t5f2jhYzeQXO+t2oSq22HWynoXLWli98DWkmT2W0EuiH9VfdhKWEqLlsFkdjtCrvPgsGDKMvisvHfSmjtmJHKruRhTC3drLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ctevzFtcplbZ74O/HDKpopiNfjNHeItQjGdCCe+K52Y=;
 b=B6UWDQsSGNQMHHeuTrO4J5w4x+/CqwgyHUPrsmS6xbxpLD3yvA6Wx6FxtA0QgI4ZdiLVvfgmXFcioC9up8cpziwGZb0bCJmIDY2fbIdJGavOqUSTdACNHZpbgEqpR4epIYk7Ml5HEaO+NnZATQQlCffhcw0ZlBKv7/CT4qhmtDPlR+eV+VNsxmqUONnE7qrV1eOo9GW6ksMCfAv0Ky7d3aNl4Redu8vwQEce/fxFbKYc8lwsfXKQ1JtE0Z0DrIObB5F9is+5Q+hKU+GEBB5mXCLvfRGQwxTv+Twn3I3NHv+gluKjHAtBSXOy6otuldWLlYkKrAcTqIa8n+beHy7V0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctevzFtcplbZ74O/HDKpopiNfjNHeItQjGdCCe+K52Y=;
 b=Jx+JuUKV3zPBvy/4dBieXMU75BKOqaiM7ZepngpwjFMNFqZ0rMhuNiaeW2MDStEw5JjVgxVyPpbYSGpwJpNgR7dNcFCWCiSe2x2S/O2Dsobo2W7/yE1TJ10SEhmKY+faWtS9OVro+LCG8ZkIaQSVJT3nz6OeWn/je5atGOBvRw2mj6p+edf6JT79/TAZqMp/ymNsvTllv7EpXgD2GtAFrylJ0mlb+nXOZApxbWYK8fjWnRkP8AxcNbwbBBlv+JIGYy6f3RxtVscwxf0QmoLMuAdbVpDuZBz+shW7+5nhHEsdv02RMIdjRoJXCNdsET9r4AP4townxc5iRsdBPn8Qgg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN6PR12MB8490.namprd12.prod.outlook.com (2603:10b6:208:470::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.6; Thu, 12 Mar
 2026 14:00:16 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.000; Thu, 12 Mar 2026
 14:00:16 +0000
From: Zi Yan <ziy@nvidia.com>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 2/4] selftests/mm: soft-dirty: skip two tests when
 thp is not available
Date: Thu, 12 Mar 2026 10:00:10 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <15C0D70D-CDD4-44FF-94F8-ACC0C5EE3C69@nvidia.com>
In-Reply-To: <20260312114027.634559-3-chuhu@redhat.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-3-chuhu@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0102.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN6PR12MB8490:EE_
X-MS-Office365-Filtering-Correlation-Id: 79ff23db-0685-459f-9123-08de803faff7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	D1OBWTnpS7YikGZsUq7J40qO5yrd4XBrpt3pIh4OveWA1XON98Z27XVcLpko4FliwOlRZV49SUPruH7f25C8d22CQxEZmBTCY2ZAGUbzdbtAPFig2V4Du15IwSpEAnK54ysr7O5XpvFaxkgycitiMvg1GhlZHsySOSqCAA93csxgqlazdgTxjpgKnxkFmaHOTuRxzrUQprcdv+74alo5/AyNp8Y1extWwTdxDULA7aiHI9DbfKJmjWeQbrw2yUvvbCTnq1KmaQbML19gcuWUY1glAlIIzU7C5PILmRTYhvxTt0Z4qdi2ZkgtE2oOto0KMv/9AkXh8jOKzmK/hpYswDr5tIJmlrcrcuY1Co0xNwsAD9/VH9Sx+o1WIttKZHTfR24PUiGUkWRlDcyezq/kwaCXREAJ7GOaXmY2MpAy5UK8yH2mAgaJCdseCWqRRfSecVFmfh9xAEzu7dJvfUKHrUmWiRBkOsE8xR2eam7z+UE0d5YAOTLqqXDbCvnoJQTrF/fQaS8fNH7WKIl+1ONN7F1qD+1x7J50tfButOh9jGtDcXSsAagYzTlf3jMsfO+IJ0UhxNQtB7tNreQG862EbTaghEkA9m4DxwRxuhr7OIADEqlQar3lGYDlOePkWx16hr5WnDlp7CjBdsNfxpKVQSQoT7nW7EWJ3Y9JNMihs0lPjtWcsfIDWHWFDjKdgUlwwrqogxsOrIZMpebX7s/uQWz2ACtHOZOWDEpWSwVTK8A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?orT1ox/dBW5DQWN4aaD8I7fGieDzB6w2WW5x3fjQuKeDFGhzRH1CLa1pAZt7?=
 =?us-ascii?Q?eHFTEFxbiABXeYX8LW0Smbll2gXij6CXNu6owVVCDnGd2c9hsXn3rIF138R4?=
 =?us-ascii?Q?/C/BrOi9RTTceDR+0qNuR10BzSvodyZ4cuF/ixUOZCzujKtGv9O9B/L8VIg6?=
 =?us-ascii?Q?6wngQ7B198ac9b/Hn5lrSe6NyK3oLRbrU8uJJL7TrBglDh1nf/wSHzPSWGKP?=
 =?us-ascii?Q?ks5DRhswtT7K6qvPDLPrZlS0ILXKBfAhls5qByBErm6e98yGjUzVyg8naOG8?=
 =?us-ascii?Q?lUPqAQfM761jSP1K0lGmO4ZyPYDOBnTbd+MdfY2LXMNw2x2xrf8eQKMBGBgj?=
 =?us-ascii?Q?TTvSgmpPny6ENJ711uG6TK+PrDSONaOyYW02k+Ube1+TB/dKnk5vmCvVI6b5?=
 =?us-ascii?Q?AZCoyA5iRWrAzD9jKsSU0xPbODxyCGKS4zo3esFT4g1oJW2c030IJYvPG919?=
 =?us-ascii?Q?nFE3vS//LeJ4T6knge4mI/ODj51rCV/ehCDVSoYneP0cj/mlPQMPjfw/gqS4?=
 =?us-ascii?Q?tSfAswPNDjYnz1PalVhnyUyJ6hdWgdiw7ZtHBs7GbZ7TMbOI5kttE0TeMOMS?=
 =?us-ascii?Q?jLCIZaB0M6Ladg5lFD/LDEMjYhYIIFwewI6bTTnPcMfF5EbTIb4cT3c1jvnI?=
 =?us-ascii?Q?prKhdP9Nz0Q53IawDFdsjvk1VbCol5H4zv+kOOxDYapCWFSON0v69iuJF/mC?=
 =?us-ascii?Q?FSnf35Ed1UvVXz8uAjKYIcD7xKVX8WzkuEn2xv5Dyl/gKh+ToMcppLANL4FY?=
 =?us-ascii?Q?OL87Q6EzK90j7qTtdXe1AH+8BPObaneoRfI0MYyE82QnYFMgXhY/y4wi4NC7?=
 =?us-ascii?Q?wGbs88f7oECu2TiOs+uEoavaa1r7iH1Zn+a3tCtPfXyQe3SAiAD1odszHB+n?=
 =?us-ascii?Q?L/UgzOG86IJBVsOCMUW2vseyOzGy6HwxhFaKmI/aRnJIlkCux+4eLBDOseKm?=
 =?us-ascii?Q?+Aoqs28a3jf2JEWixTRu5XzSIV1AOj9jJzyMpjyHcic7g6vxYmRlBHkncFQd?=
 =?us-ascii?Q?mrqsovyLNCrgyrIIN2RojZFtgPc90N91rD0YWjb4IqD518BLou7uDKD4MWVw?=
 =?us-ascii?Q?H9SQVk5LJI9JPnNVAuzTNzM3wVgfn18D1u0GBZPfyyhCMPLIFY1BJ596p6t4?=
 =?us-ascii?Q?1Rk3hW1H1nhHmKNAtX6oqkZhv7SE29sNedxn3GxqXRiNdT4QBh1/6HgSkSDg?=
 =?us-ascii?Q?9PZPGcwYel0OQEUiAgzqigkahBUCGJv+OshehPefMTFffkzqL/TXLjbgLZn+?=
 =?us-ascii?Q?casqrJ0cmrjxwdTEpAo3pPJ1Tp5zLQC7gga1ztzZG1CUYHeCN9u4h3Iehvfp?=
 =?us-ascii?Q?l35g8ZXZAYmNEKip9bw2WFPoC+E47VuRlYUfjqACfV4SG+TOUyRAFq17ru54?=
 =?us-ascii?Q?CTlSYSLvcKKo2qvR9+dnZjyJ7pwdHfQFyIhY1q98G/qT/P5wdnckCP9x9Czw?=
 =?us-ascii?Q?/ydDHk+YX42FUhzqaEqMZi/LusHpQNYQu/5QNHWuCSPE5e1fmOXo9pKvsX2l?=
 =?us-ascii?Q?zcCWOVuXhz+iCiejL5kEdESA7aabsK7CiMalEvQczgbd461T3O4hAyAwBPyq?=
 =?us-ascii?Q?0O7h653pd5eM+JeRhM7QO+yFimYhx9H08mFkQx/HTdW2zvQV/18gGJ86gIlI?=
 =?us-ascii?Q?mN5UC13Z+TYwcvqGjdn/jbzK4c4BP2jM0SPqij1zgZ3NqI3zqdVTZG+2YNtR?=
 =?us-ascii?Q?CONSvAFV57t5oh0Z5lk5IIllrNXOoXkKP51QVsn12B9qNNwOHWpa3EM0FzpX?=
 =?us-ascii?Q?J5UeJECfmQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ff23db-0685-459f-9123-08de803faff7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 14:00:15.9080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYXYqWiVT3ooEOQe6Gsh8Fk22uJBfq/2UFFIJLgchxML8q970FsveIq60UX7NZ8b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8490
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2AF2BC0011
X-Stat-Signature: odwjpwrwnznd66e5b6iomty3f8g9tihu
X-Rspam-User: 
X-HE-Tag: 1773324025-645944
X-HE-Meta: U2FsdGVkX184olfo4Jt2JsKOX3nI5JQ8RppBYYUWq4AUs6mFEx2SyrpQD/uDakSrFf0agwnXgHx5vgoxYahJ19kvOMAg+t7ouFxD/M9Sx92hs6JwomOvgrOimQJVYKp/PsZgvrJ//hm2wOV9k1bdN0/76i3iZuywrdnADfKT/XMuCPMAxHxtjwvNy1l81EMhQjaddICk4PL0hWdvwsdad3701J2QU+6ElW06dYbHbZoTlZk6IKO9C/vhK2SMmXx8fSK/czmO2cWIIk3si1JI+DTXkd01Z2vr8cF3WK80fupbQKACKPZ/debl3xDi51K2Kbd+XojS6k8qqWN6V5bSP5IkPzTJ+GlqA4tWAk+szQYp9xJ9GwDGDPJrBN+bjSi0cb8fwCJO2Z99qnKjwCP1Ued2n0f1cJH/odjtTPpf/8cqrO0ZD2Jq4I0e8+OvBjDmzAZpc0FN/NsWRWKLuaqfbQ0mDaYOjGtfLa7nDqz/mYzyEB5BR887L1vEekRW1YDwl0LyBVoECmOfu/uVrKmkYx1OVS6Lc2z/m7kmWbDJk8zHbj509t5BhoQEEpSCdq579eisfkm5LMsWPdrpDgk1OIgomnJoMqIJ+oCdVzmrdmsII6U//PcQviDcziIt6neSW5JME59XTzzj1R8abhmA4eTEE6f4fUvngT8h4f5BoRTAaz40u8c8R8LkWL3hGqfXdEIbDOQCkcNzPiU7HMDHIf/giptuqVYNs6AxhXc1tDv1QaGg0GKs3BEjJIskPyzQPP+Yjk/GqtME7zW0UFhpUtDW6arFxMpjEazq21Pr3cqebnbS+4PgNvyjcmInCjiwUXOwDv1PZhojo1sj48LXzLnp1zY9uCjg6I1d1LhfoVUP1p8CO6dqImEwuAp/XF/4jqPeeogkNDlSkSu2nycdJxpNJHHBJX8een+yajqCNgE/Lio9WRG86FcKWmz3cfiuHqxUx5dKcqbdccliIWl
 5mdrPR4w
 r2irsYjkjsO2v5SctN9+BdbxYxax43JTFxbxDOqZdsRWhbSsJRJsh1UhQnnmFNamu2psynTnBYrkDfZZNPaBBGGI+a6qyvT3uRnNqWgKw4OQksvPJUJG69iArZsT8MTav+J1+xvOxNJXDYXoqArXOowJ1+m5GbwquSB5kN5r7NtTHh44lwdS9UhuWykS4TBjTUm5cVBrZP7FmE1L2uAHt4GttaSk5VmFkfZT6+iADSKx9akXDkMlKU5UlRgMblz8os4EFi+EfrZYua9CEvR/0/6WnuAfbmh5Nz70Pwep+7hWOYLVXY/Gx/zda5NPYemErNQjenXOTMB148JQQ7YqFk5KuLkQ8fHOTUSA2ZOIyHZ32L4kG3TYeOEQOhxwBMP4hSniwL7dgx0z3D8Sn5eqxJXr7Gw7aXb+jTjZl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Mar 2026, at 7:40, Chunyu Hu wrote:

> The test_hugepage test contain two sub tests. If just reporting one ski=
p
> when thp not available, there will be error in the log because the test=

> count don't match the test plan. Change to skip two tests by running th=
e
> ksft_test_result_skip twice in this case.
>
> Without the fix (run test on thp disabled kernel):
>   ./run_vmtests.sh -t soft_dirty
>   # --------------------
>   # running ./soft-dirty
>   # --------------------
>   # TAP version 13
>   # 1..19
>   # ok 1 Test test_simple
>   # ok 2 Test test_vma_reuse dirty bit of allocated page
>   # ok 3 Test test_vma_reuse dirty bit of reused address page
>   # ok 4 # SKIP Transparent Hugepages not available
>   # ok 5 Test test_mprotect-anon dirty bit of new written page
>   # ok 6 Test test_mprotect-anon soft-dirty clear after clear_refs
>   # ok 7 Test test_mprotect-anon soft-dirty clear after marking RO
>   # ok 8 Test test_mprotect-anon soft-dirty clear after marking RW
>   # ok 9 Test test_mprotect-anon soft-dirty after rewritten
>   # ok 10 Test test_mprotect-file dirty bit of new written page
>   # ok 11 Test test_mprotect-file soft-dirty clear after clear_refs
>   # ok 12 Test test_mprotect-file soft-dirty clear after marking RO
>   # ok 13 Test test_mprotect-file soft-dirty clear after marking RW
>   # ok 14 Test test_mprotect-file soft-dirty after rewritten
>   # ok 15 Test test_merge-anon soft-dirty after remap merge 1st pg
>   # ok 16 Test test_merge-anon soft-dirty after remap merge 2nd pg
>   # ok 17 Test test_merge-anon soft-dirty after mprotect merge 1st pg
>   # ok 18 Test test_merge-anon soft-dirty after mprotect merge 2nd pg
>   # # 1 skipped test(s) detected. Consider enabling relevant config opt=
ions to improve coverage.
>   # # Planned tests !=3D run tests (19 !=3D 18)
>   # # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:1 error:0
>   # [FAIL]
>   not ok 52 soft-dirty # exit=3D1
>
> With the fix (run test on thp disabled kernel):
>   ./run_vmtests.sh -t soft_dirty
>   # --------------------
>   # running ./soft-dirty
>   # TAP version 13
>   # --------------------
>   # running ./soft-dirty
>   # --------------------
>   # TAP version 13
>   # 1..19
>   # ok 1 Test test_simple
>   # ok 2 Test test_vma_reuse dirty bit of allocated page
>   # ok 3 Test test_vma_reuse dirty bit of reused address page
>   # # Transparent Hugepages not available
>   # ok 4 # SKIP Test test_hugepage huge page allocation
>   # ok 5 # SKIP Test test_hugepage huge page dirty bit
>   # ok 6 Test test_mprotect-anon dirty bit of new written page
>   # ok 7 Test test_mprotect-anon soft-dirty clear after clear_refs
>   # ok 8 Test test_mprotect-anon soft-dirty clear after marking RO
>   # ok 9 Test test_mprotect-anon soft-dirty clear after marking RW
>   # ok 10 Test test_mprotect-anon soft-dirty after rewritten
>   # ok 11 Test test_mprotect-file dirty bit of new written page
>   # ok 12 Test test_mprotect-file soft-dirty clear after clear_refs
>   # ok 13 Test test_mprotect-file soft-dirty clear after marking RO
>   # ok 14 Test test_mprotect-file soft-dirty clear after marking RW
>   # ok 15 Test test_mprotect-file soft-dirty after rewritten
>   # ok 16 Test test_merge-anon soft-dirty after remap merge 1st pg
>   # ok 17 Test test_merge-anon soft-dirty after remap merge 2nd pg
>   # ok 18 Test test_merge-anon soft-dirty after mprotect merge 1st pg
>   # ok 19 Test test_merge-anon soft-dirty after mprotect merge 2nd pg
>   # # 2 skipped test(s) detected. Consider enabling relevant config opt=
ions to improve coverage.
>   # # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:2 error:0
>   # [PASS]
>   ok 1 soft-dirty
>   hwpoison_inject
>   # SUMMARY: PASS=3D1 SKIP=3D0 FAIL=3D0
>   1..1
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
>  tools/testing/selftests/mm/soft-dirty.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

