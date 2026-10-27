Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954C3606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=eqdbWdWK
Received: by kanga.kvack.org (Postfix)
	id 8BBE16B05EC; Tue, 27 Oct 2026 14:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892976B05ED; Tue, 27 Oct 2026 14:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781AC6B05F0; Tue, 27 Oct 2026 14:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53E316B05EC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:38:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4EBC404F8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:38:25 +0000 (UTC)
X-FDA: 85369266570.06.A109AB6
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011047.outbound.protection.outlook.com [52.101.57.47])
	by imf31.hostedemail.com (Postfix) with ESMTP id 80FB220002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:38:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eqdbWdWK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793126303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXx1V+0Z/xWF45Xn1gmYCrJZJHTmYCKmzI7TN4eSNeI=;
	b=s2PJB471vM3Q9GgooiA5yL5PCLBB0oIVnrXJ5dISN/TOfB3YjGKWLwsiHFzfvjqlrTt5cY
	QqhK/nx96cs6Nz330teUa+5jS9oPmTTQIRe+W3Xu5KZjl9CS8rCW+wVprnGOPUdk0cXN2P
	a0T9ZERkqCmk0iEvPAwt5+6R6+BeCmU=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eqdbWdWK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793126303;
	b=3yxIKv8gWN+U8Z8/+wyzQSl3/ZhO8dmG5Y3ICG5Kd9wuXlcb1r8RQgLeVqKfWLxrJ2Xx85
	Q05JrXp5zc6YaopbceDmhYwfbca8/qlNY8/b1BhHQARacQs4LXssJfdaBswjDrGYdng9rg
	eq1RwAAR1duqjQGPgLe0g+dESUeibA4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OKwF8/Z5Fmzr6j8JjMZIQ7+HD9sle/futhkOYyYS4cEb6/pQQfkPLrwI6e6Wo5MAbKyWJfGoi8vCaUGvKIpcgr5g7Sw+qrvXoG7uMPevEZxJ/yf6Ep2ld1CERwlSTrxtTZbgcR8ZHWf1BJ7jmvnLIoCxHbDyOcsJeIHlmer1UaNHkXRnTHJEcXJ5MDfXAGPKHut/Velw8Dri8QD8C5RbDViooNIA0Ii9bkcmzKDuPK4qY5leEqqdt+66OTgOWx/j3mEYoTYo6D7DqKyCOjuMGfvVjS1+l57/QF1ugR1/PSGtHYKLjdQSXAfmdGE3SnByDxmO8N2zn9tfXK5wxydSZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXx1V+0Z/xWF45Xn1gmYCrJZJHTmYCKmzI7TN4eSNeI=;
 b=bgM55dXSsr9Bk2kmmwYIbxNB0jRRTITfidIxK66IOKtjKH3UjO1ncWCc7JAeXUoCkfF9Ord6cNPIn7cj3y8V4ZOU4u2uWHSSXtgmI4BN8Z7nyPVxL2HC8Z6lk8DuYq5ZLPjFCbtsWLkjGgDHniyC72no+0L3pdTZBN9Q16++538chQ331HfIgYOfxapuxmGVBQZPNMgeQnPUsrIIwEnEm7OeueHE0V97dzpaxsTreW6brKbNHJmOtDM4btHNId9YDV59gb/iOCfg3I5q53jowsQeyfvxZKkiTfUWuWr6NG1lBLDkbFfqIGlgFy7Q2F0mp+5LeObnZP9wOX24MUOhLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXx1V+0Z/xWF45Xn1gmYCrJZJHTmYCKmzI7TN4eSNeI=;
 b=eqdbWdWKio5liBvxd01Sq5Jm89Fdh+hK0CS/uVvqNnWo3ZxaYrEsDkN7rnYYeTXcbHtXg0+zdpD/5zHfj1kA4zsWjl7shBs6uHqFzZGuTC9BRmFz5mTlcUpg2+EirAbfU9HX5bkXcyaylqFI8jrpWGC8ud4kc2rapaVoIskVBJDe807qcVF4l89n7QKogAS27GruWPYdDEcdZHUpsdWMoA+lM/7J9defgaU/V65/apc3XdMe5Y1ckx3qDLK5jCttLad+S6t75Gp4LVNW+Oatw3N1YEtmUO5xA7tyCY7wO6mQr/7DWvMzguYJo1PY4HpTu3zi12gcSlla9qjdnkpRfA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB9498.namprd12.prod.outlook.com (2603:10b6:208:594::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 18:38:19 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 18:38:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH 2/9] mm/page_alloc: clear ->private of deferred free pages
Date: Tue, 27 Oct 2026 14:38:16 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <CB9339BF-0D18-4F8C-995B-E2912C3BD758@nvidia.com>
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-2-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
 <20261027-pgalloc-ai-hotfixes-v1-2-9c7d1aca801e@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN0PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:408:ee::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB9498:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f00ee21-b494-49d3-ae52-08df34597884
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|18002099003|22082099003|261026121527099003|10067099003|11063799006|4143699003|56012099006|261021121427099003|261009223027099003|261022075727099003|261022105027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	5VEoKlulZdveSQdck+Qgm9awBZBodo9d/1u8mtAO1P0qZuc7oZTJ1zj8Ima3ImuRT3HjwZlUnlKjwikSka/uh7EGBZ8xOpZnJKy6jCOkcuHLp3hNYq/P05Clw1dAaZnTyOkVsDlxTGlj4r+4BkcGUCEYlV2hPEtkjzm5DzO9XrDOm0yTqCKwEXosgty6PNhx7+bAQ4w/doXrFVMhulxceMLL3TC7GWUNSyvpmTj6s0OpFKBaOWJmm9eicTWoWTksjdlfq9aT7DCQNeSHOLweG1+p0d0+xtXoxK6dXMSKl8MwrNu7sSVZIYi78pEXdgWRd8RbxkkmNJx6KPsgKY32fXz1pyykf29dJctkZIfDKhdPvXnTp8YdThGsWMNoE+Qo6jBH4YIYhjopB3F018M3ct2g7tA/e9DKo1LBzeRK/+xbtFCE8tmEawJLUwv6a0OdUF/81BZIiEa8c4qHwXJD8lrZGHRb/niQcUWFriUrZiMsD3GnzC4Epet0MUKAh9e2MhGXklcf6nc5y3m8fdypABZB+w9jJgAbF5vvw02PIxncUvc3KXLZ9i901SoJi8WprZ5I8HidTlYeAO6DrP8j/hnDakEdTB8SD01WKkIWiGuZreT2n0fFBPI59+GTkVAfbBDssmT/RMSv4u+E/LWKDbdFnXMaQl/lG6Blyuj3RCU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(261026121527099003)(10067099003)(11063799006)(4143699003)(56012099006)(261021121427099003)(261009223027099003)(261022075727099003)(261022105027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WuFT3Vs04UC3Kv64DQrT/4VUUdow36lPgujvrHpWZ2ib1xwQ+Ry3Xii5xIE7?=
 =?us-ascii?Q?zVTxSo0Yk8oiSAAOuBI2ptzfxCkNWsPaoUpuV9eNpN9ROpHf0pJcKkoUSny5?=
 =?us-ascii?Q?lnXrTnEqDKjuYKZdsIY0NPjyrn83LXVY1MDftL62CBdXQFR9A4zrXHAX59eQ?=
 =?us-ascii?Q?Xz0P9SGFAEWv5EcawIMWzjnBqH3+bgx3AsYni8VvXnq5HxGDGUminC4LH288?=
 =?us-ascii?Q?MpyxTPyCJfFQ20CxNDaTKXEipQDXVgK5k0PdWCQ8gAg3YqN0k/raES+um/5O?=
 =?us-ascii?Q?BZqHEkrKgezehucfeeTWEHIc/DWvzubqmKWwXLThizaz/vNUut0TNStncMyL?=
 =?us-ascii?Q?i+w+MRtN6P+c7jCqvHGDGPLJq0Yt+8Ck59pBfJEGw7g4UgMNi17B3HCvedvS?=
 =?us-ascii?Q?angX8wJcWejgI9k3b2WQ3bNsAVQ6HegDiMmD1hwn6EgTahrfjcI3QmLs1TxW?=
 =?us-ascii?Q?H7TS09rw8vDr/wfDpmQu5NRfY9ztUaVipu4vYKJYi83JXG4euYSDpLaCshhR?=
 =?us-ascii?Q?hvZRIgu5VDvQjzLmkk5+2qRflAxJHvDvGPlNS31TzvgPaEuqGWt42dkwSu7+?=
 =?us-ascii?Q?R/WE7rSGJI24hNG6es3T9b/LcLXMv+3eivwe6ILltlBChIgMVnFzmDi7Khnx?=
 =?us-ascii?Q?VxNixVRGiOvn5OXXM5au0jaZSdA68sWQy0E/vNCZw/qI/XLvKsTpBPKh44Vf?=
 =?us-ascii?Q?fdYS2KYU4BY8CeiiffVYJamGcBcf2/iB6FNt9qfeKK//CMin2QtdV8j9INc/?=
 =?us-ascii?Q?Kv3bLwlxh7b6z+5VqZ9Gyb0VcfF9ZaTJHu3RXGCxporeLg0vkVoKw7yje0eu?=
 =?us-ascii?Q?Y/+hEkm466rofUXBQ3jhWlIBgJD7ha4n7eWyd5iKi8DMwJ88/2ldYMr0rYE5?=
 =?us-ascii?Q?r/H74C75b+YNGC32IuPNETF+VReRPd58REu1VuNwJaB3D3sW/iJPHXyydobV?=
 =?us-ascii?Q?n0bJKG1tVFvRQln6kFmfO8LbMqQX3ZHaIM/OrStGdxHsazUGvQDRsgjNRSyt?=
 =?us-ascii?Q?9WFSjEnTV26NaPUj+VHzOs6xm6HYWzR5Q9caoC6VHSeUaF0ivxToTsiuHCRs?=
 =?us-ascii?Q?j+Z4/bfSMzztNNSfl8jynsKcwvwAwWesqonQ60VW4mI00ddaqq0vhLpDUPrc?=
 =?us-ascii?Q?mfpApAXnYltqO2NpSvtxoeNwXf8CwsVFnwCeQlUD7H/QObwQmFGYTKa9Qj9d?=
 =?us-ascii?Q?VrODLvFIRB4sIT+RTTnHUj2O8qqkM1zLISMvs9S0lwpnUpa42WLP6nVf20+z?=
 =?us-ascii?Q?NViC9V2Hj0PSIJKFqTeb7ebO7//sm6vAerMzVDGdJSYpD8rrqe+NIykpgroi?=
 =?us-ascii?Q?3sf7+lL08+MsQ4xQ7N4gDFtqD2FTyrnuMFoWc8oKvXSQOafWuvIgByOba7YN?=
 =?us-ascii?Q?eQDAcB4OhlLLnkgihVVXkUHfRE1NlJlyiIKzHdzPxIM9TdmCgRAPi26gjQXX?=
 =?us-ascii?Q?EhC1vxVjwyGgtgZYZWJFXRiGcAUPj5AONJ5Dejg4DXx0N4xvG8k6sbbvMmRj?=
 =?us-ascii?Q?j3oZFTmI+pzqNslIraDC94QL99r/LH3dole1Cs1FbbQxbeTy61zx/HKxvUfq?=
 =?us-ascii?Q?eIq1SNwKBrTTxUR9qv1+1SICOkaS9pKfLa37aLl/4WrAtgVzrsfL0nlEeVYp?=
 =?us-ascii?Q?Pszh69PmKIhR2CWaQx6Lbm/foGWzFzi8hQXpGckkLLYJzyqjW1on2r9En4jO?=
 =?us-ascii?Q?1T/Y1OSY53ppl/PpcbXE7PelNq1svq2ZDVuzKMNCvky10WsXf9o2oz94KpHu?=
 =?us-ascii?Q?EPaVp+WB7w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f00ee21-b494-49d3-ae52-08df34597884
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 18:38:19.0108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJxf06Y63HrdcD+RLJSRMEoVTEDlwZQD0O2LWpRjZJXvZZFoukZokDANAr6fuB/z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9498
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80FB220002
X-Stat-Signature: 7y59y8udwj1a4n4hpfx5g7jkg8k8wf4h
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793126303-592942
X-HE-Meta: U2FsdGVkX1/pF3AE12KOePLQK5Zp53DwOXX8IKN/Kg6u1tLTiWeRRstxtjB2sN/i2bBqFdUw+LoyAzYJgiZN+jdJKYgMCbXLNrWH3DCmijg0nZ7Lkoz1nl88Q5wGb4QoffBGaINGwyy0a7KBQ6PxuCOVOwZyebXY2WCkUxLnHoBj2jUMzv0NVfyxPFKzXUFmfH7Fc32YrrbtGF+mEyyvpRxPkKTMywEMPNTHefgmgu2pfe9oG7upEzr2fgOqtGGQiINFMq6mBQNemYhbENqdFIUNxfLpy7hhdvFVFqloQf8xCikgjxAGltk7yJBsZmi6UjY/Wwo7W6BJM2ZR6/M7z79pudML57wvXxNIYQcRqn5nkFlls6y9ZhtdmzgBjtc7OhozZzgQB4ocHjTjus78zv/10I7brGGbr6AzwViiP0u5zdQpDNOroIah5ivT1lr0NXsmxzs9qoU4nMxWD5f1KjahDM+w1FehpLxLY5LN1w0TGpZlYZkbnx9cXerYMP3mTAS+2Bf3IcXJBRy4+SWlu48E8rlHvf0RguoWjQmHeaLqgSK5MsF01m+HieoisrzdpKyqsncTaeuCbQ65/dEiTRmxOJyDK9QX3YLBu72zC4a7/dbDk3rY/tzo1i7Ozse2zkzrSrmJAXKYZcgU07TFzbgRqGW6kawGhd4Xt+AjIZlGOzTRHXtBprVKS+Ol42Pp6DgXuS3a9cH3dr7a3wINynOu25O1TthUcbN8zcCi222dGKTrsTTyTcYLtdGnBnM3Qrv8E5H106URnA+QS0LRJPNeVDgR5dim8w9DNJcUS3a1KF88PebzSQMIC+eny5rbOu1fy9lQCfLfo/cBIDycfRDYQbSDf27Zao+571rEs1zrV4MIBS85vGW7XPDE2WbMUv/i79C0hEnLck/aQB5Sb0juh30dxyJPiMGEfy2FaSI60lsRq34h7grYw6d4ZcnEYhZGGl8agp9UK2R3wMN
 GjvQSYUw
 91RpR+yw0HIKsP2m7X8hQw24XFM2rssHQUSaJiFguqZ61oUoTQqtFhhihbZJJVCdV8gsM6Q+xeTJ/BKbUgWquIiOjjYxhlgqymu9F13Ovz+5TzL+pOzXKHkQNb6ij1oNBMku1R+qGYuIb0F1W/MCgI9fefR2AX8lHPRCEJPocfIMdbuHNj4dGzif5b5xc75gfZMrGNw1NRoZDK1AfG93qMjyg50MtyX1UzsFLZa7BfJyuPqkYZ05RCVKBDF4+JrEbLjKT4ZGKJqEerua7g4YFhfQH3AqzZCD70ZfjOUj2Nl2p3VvIfRIDxOnqcZKMmSoiO28OjAxBiq94rxnq8Zx8uXjstPtVb6Z/ezna2TyUKWuO7+1+0lWiaRwrasuzwh6gckzk3xdXbdmGvsJDtoLoChnzav5KNn8VbhXjsxwmhwO1NReOjwQ6AElF07Q0uwYzqA1ADFdPJj8GeKJZ1q/fTYgIif0bpwaZMhX0GVxxCuzkOcDoClRT+v84nm4jZYPcSQzIfxW/xZJgPew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 27 Oct 2026, at 11:46, Vlastimil Babka (SUSE) wrote:

> From: Josef Bacik <josef@toxicpanda.com>
>
> free_pages_nolock() and free_frozen_pages_nolock() put the page on
> zone->trylock_free_pages if they get neither the pcp lock nor zone->lock.
> add_page_to_zone_llist() keeps the order of the page in page->private.
> The next free_one_page() which does get zone->lock passes these pages to
> split_large_buddy() with ->private still set.
>
> __free_one_page() writes ->private of the head of the resulting free page
> only. If the deferred page is merged with its lower buddy, it becomes a
> tail of that free page and keeps the order in ->private.
>
> All other free pages which are not the head of a buddy have a ->private
> of zero, and since commit 819bfbd47e49 ("mm/page_alloc: remove
> set_page_private() in prep_compound_tail()") the allocator relies on it.
> When the stale page is allocated again as a tail of a larger page:
>
>  - prep_compound_tail() hits VM_WARN_ON_ONCE(tail->private);
>  - with the page checks enabled, __free_pages_prepare() reports
>    "BUG: Bad page state", "nonzero private", and leaks the whole page;
>  - without them the value is seen by whoever uses that page next, e.g. as
>    folio->private of a folio which is split off a large folio.
>
> Only pages of an order above zero are affected. Those can be freed
> through _nolock() by the stack depot (order 2) and by SLUB (a new slab
> which cannot be added to the partial list by kmalloc_nolock()).
>
> Clear ->private when the page is taken off the list.
>
> Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
> Cc: <stable@vger.kernel.org>
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/page_alloc.c | 2 ++
>  1 file changed, 2 insertions(+)
>
Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

