Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 312F6C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 08:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6FDF6B00A4; Mon, 17 Aug 2026 04:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47B86B00A9; Mon, 17 Aug 2026 04:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C371C6B00B2; Mon, 17 Aug 2026 04:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 942146B00A4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:18:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2934E1A05AA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:18:48 +0000 (UTC)
X-FDA: 85110060336.04.E340FA0
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010058.outbound.protection.outlook.com [52.101.46.58])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4C7B280002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:18:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VA1svkZo;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.58 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786954725;
	b=raoGm8stO3vR91cHGjQKI3skdk6krGpn5u0e4O2SaeF1wd0BHj+tkxve7d60QdXX48JaV7
	iUClVkEekmzoDGFe0iuxbC9AhH9BdyxQRoQ/o44w/pWRvgiYfWzPZPcYL7myp2epN0666f
	M4hJqVWbPrniYW+t948N9H4X8zu3cVw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VA1svkZo;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.58 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786954725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5G4f9pYhgY+kQUVWeqMc0DoRNYRWJCVMyFdbLKFqxlo=;
	b=Fzwu6rlT7JGM9Sge+AVor7UbFnlBk7+/c4XeB8DhFp9ll1oGPysE0XTf6V3RWgtexAPOXw
	2jWF7RozMld4z6K4oJ3BWfy52cbMlRYeFe16lYe1gwpdRfXH3Tthp3ob4dpGVzrg6E4zom
	cTR+rYHrbGPA5ViLHxStu2S3e/xau5c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T45zjq5F2KH+qwet1iS4TvTrbsEy7gzhAE32B6DWNPlRq3XIxdVDTJcsOpavduO0PKrKvXk7pVSwTB9hOuBo3vpOxZFLsiG2PpjtTRsQPubKWfsYzbgRqXW2H8kiM+DsImz3zOo8FYZeMi51GPDNyRMhFOZhPpajn42WRRnTUVDM/R4X6eNWPAJKytuwy8q2k2LksFoLk7lb2O9nCpBkrQv13kDt4wVZf5p/qMHk/T68CVzMhIbshSy9TpLfOcgutuxSPNk8YzjpYzw7u4vwkQA1PTwjwBjqGgGu7VmLYFwpMzO0Yo+/benVsLx5pu1HKGoGYUfI51xKUc0keWhkwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5G4f9pYhgY+kQUVWeqMc0DoRNYRWJCVMyFdbLKFqxlo=;
 b=gV1AJNPDbhqbsucDlcLjEzW4zaLDbSCmtXRURBhY6OaJW1LMFANAqji0Zj2wwhgIbgt8oYnuL8mvkDZQrLsWgHfW30xewz9dZ5+K5Bp/SDg2G740WUPD2ZlpZHWZY0ahjyLHImPBn9p7uu3wFC7oK1qO5s9lVtBPm4UdoNJ1EyoMMVWPta/FXSTsFk5xBCy5OsfDDHW0NVb/P38h0VvjqCenmt0xSdOUEpvBYgkAiKle8RYE6slrFRMTJlP/o3Dh3+3cJL78sLUWAM/3+QbpgdK1ODdnf3NAmUTOBV52aF0q9tMOCUZXOJub71sCMhN9rSoI1O3CI1AMRYYhN0OjIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5G4f9pYhgY+kQUVWeqMc0DoRNYRWJCVMyFdbLKFqxlo=;
 b=VA1svkZoEh7WezUAWekDBAEE9ZhJkjb5CX24jlaxfSe+fOElcyOBzwaIekOILsEhFbce+tnRpuDK757Vx12rbO3peDXd9aOntYU6f7EB9tSiu14UtYm5PoH+Cx8CK9M8Bm8O1BnWL2hfRa3Il5euYWuo67t8ESahXvMaPfV9TW9pCpAOyS7KGh+dJ0oVIGrnWrCLrLRO/iTaSG1Wj3DBFgYrBHtjXrWTFwuJfI175IhX1u3b9XTVRBPe0nIiWggmVGW6d/QpZkPLM5WXTC6oo6jwm5MaursBs7e+CkCNFdaxoBH8FeK9sCe2xT9FHAgkpBhC5IkjpWJM7JZAaprpDA==
Received: from CH1PR12MB9670.namprd12.prod.outlook.com (2603:10b6:610:2af::6)
 by CH2PR12MB4311.namprd12.prod.outlook.com (2603:10b6:610:a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 08:18:39 +0000
Received: from CH1PR12MB9670.namprd12.prod.outlook.com
 ([fe80::416:ea1f:d17b:2811]) by CH1PR12MB9670.namprd12.prod.outlook.com
 ([fe80::416:ea1f:d17b:2811%6]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 08:18:39 +0000
Date: Mon, 17 Aug 2026 18:18:34 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Hui Su <sh_def@163.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate_device: avoid out-of-bounds writes for
 compound folios
Message-ID: <aoLDQifuyIiO-2eA@parvat>
References: <20260817074350.442493-2-sh_def@163.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817074350.442493-2-sh_def@163.com>
X-ClientProxiedBy: ME3PR01CA0064.ausprd01.prod.outlook.com
 (2603:10c6:220:1c2::11) To CH1PR12MB9670.namprd12.prod.outlook.com
 (2603:10b6:610:2af::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9670:EE_|CH2PR12MB4311:EE_
X-MS-Office365-Filtering-Correlation-Id: fdffbe07-6f1b-4be7-8936-08defc382432
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	lg1paaWcaiRqNlqOOvDWURS1tgmpub3JH/hfD/stKxCo/QQmRwY24Npc0HPElKIdZ4X1sZ56D6EpkZuTEcSSQv0pqWcz9+BUZbXPVfgZoAoqubgNL8YYHw3bTOAh7Ori3Q0uYGGU+tm1t8umjtiNpgjMCeLkK5lgCCeBAI3ULogbT+4QtdC9zobOwdEcWmpVPyKwrcM+xwn6OuLWqOUGZFlQK5+yZyRX2x8llEXTmMmMQyVl5uaHv7igctuG8KF9YhsnZi1VvIP8HprNh4QehQYeCBpjRnnLVuIpLVmOyMY1G0QIi3tZjVikfC8N1OgZZpXkO7BM5eXkZ0+SP6U7R3yzJepTUADjAUn+PSLP3TAAynlBAPw/CW92pKf6JcELYiKq6Bdw5PlYV6cXxTsWe8hlGTvtMEPKb8GT/fOXu0hZpft6EYKfoa6RlrtVV7/UW2+WDyDv58kcZQVbQpvVQcqIGp72xThmKhmYuzKHfjZG//Wa0zKUfJ3u3Vz4ezgk/0N23xi/mOsTxKBGdLOa/YDhHo63s01npQ+zGgHWjGpOmiPhZIyb3U5dT0pel5Vo5wGInNd713lBQlrgTlhwj3kHNOgAIXfjW28gpQeOOvq87qv3qw1pZbyc/uid/mG9QGS9LNGVhC1wy8BY9NIAM0QJffNLWeR64u6EO1yb6CE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9670.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fs5MwAVuxxvaeJHse18Q8A09Y8viWbqicHZeBd93OjUjukp32jD6q3+TVu+5?=
 =?us-ascii?Q?+BNS8rscF8bzN9PdtX9ySP44ZQRZkaKHexTzk1uSToIyb1oVVDZhEAVKsgOL?=
 =?us-ascii?Q?aAxlV0Hyf+2OzKEaU9Gd0JpxqPCKUSBL/EE4OrlyOA4cCZ5wFYrudQdTiXX4?=
 =?us-ascii?Q?hlgHS+hz1HmxVPbPsaTLJW5+LFpbJpXrEyFjP9MF2B+Pxqew061DcpTxArbs?=
 =?us-ascii?Q?QA8J15ZE01s5oKI/T1s8zzr8crl0BazXH1Rp3K+pMbcpxUe695S9LbM5MchO?=
 =?us-ascii?Q?x5Vuz0KTiGuxyjP1MCJCWLoi6aqvU/Fx/PULCK/xe5N2xaIyevdNbnAF1KsB?=
 =?us-ascii?Q?YpLrj2p3POpyks9m07UX3+VmZN7QpokbzS/MvPguP9K6NxbW5soiIOx7eIdR?=
 =?us-ascii?Q?RW2b9Ryw9XS6ezLxakhErQ+YdtBta2uACx5Ii3ZhGFV9KHQ597XPjcjKPZtt?=
 =?us-ascii?Q?gMDueKzZY/nNPeD5zlxnogjOYABNa2putSyPf6Fh8PdGu5S7hGhUIMJ4sg5t?=
 =?us-ascii?Q?YaKGcI7riNJHlJRaPqZOa7MCc4QSJ/QIWy7otnQfUCEor7nVXXsnkrcevGLq?=
 =?us-ascii?Q?dLo5mxhWdfYvT/KQgtM1AmsdhvZtRUqeiYx4ARArGesGI0DEqSmZIy0idIBU?=
 =?us-ascii?Q?KM2izLfRAAw0NFINFaf/DpGqyvvO9BLel7CjlSIak88W1TSRxLvgNVXvbBVN?=
 =?us-ascii?Q?gFwinLmjjiiZYvilotIESWqAMai7JWI7oDQQTkXfOScpWK58UDGY856pxhg1?=
 =?us-ascii?Q?KmMQV70SyBFvE0bYjJofI/YtdzT1nhHhreV7lvdmf+ypRyHKsR/AEM6loSxh?=
 =?us-ascii?Q?Etz6juPAhOdfA9dTJtfnFm27aIiuTnvDakuC5hiQTxILqz9iBcoDrhHXK2mc?=
 =?us-ascii?Q?14BiyI6DXzrS46NfA1TVbsXap0oNEOUqaRIluNILcinF/83p8QTx++Vhc/+G?=
 =?us-ascii?Q?6FDR64k3ju4KHskpTDZ2b9QyQJ6CXFW2fuBnauf9K8w2WZARzd7fscKR/n5k?=
 =?us-ascii?Q?rFShYpCx0kIx0wYyDexXw0t52plh1fMgoM5S2au0xatnKUMbIL6hcKc3Yrg0?=
 =?us-ascii?Q?mpCSUrnytRJTTr5JkyK18UunCfZgqZsGeQdCwMv6kcc05oMLgpcPNziOGSsP?=
 =?us-ascii?Q?pwjgEQ8IeEHF86EGFXBJfcJep/58c9cAnOtzv0QEnJ08p5Kxk/XO/2i0lL2G?=
 =?us-ascii?Q?WJgFY4i13cr85fNe8G9Q+vEzTrsGO++LAF3HGrYf0Q3z1JddmrXJIOJDpJ1k?=
 =?us-ascii?Q?7NUTkZ7ftu8pF7eSDGK2YHq5ZSaz+fnZqLtwkatB36rVGc5Ep5sTSiVteunc?=
 =?us-ascii?Q?hAepBnmIb0LLlYtkDaPM0eLpxJg1TsIEuWhgQa2uC7dyVDQT3E/3TnoqXkgM?=
 =?us-ascii?Q?jxUZO/aWhQcCjz0SwlTcliPhkTHBKo9SYB9mrQjYLPgi3JoVTJsfmgvXbLNV?=
 =?us-ascii?Q?+y35jOspEsazXU7WLHLDpKyNa3UCL4HiJFL7LlrtxqlX6yU/4LWjhvBwCrr4?=
 =?us-ascii?Q?v0LhGfBSE1QeewGcPIHFIzaq/NbWwy/M6LmD0Y9O3pQCVtMqntYLGwpfaSTV?=
 =?us-ascii?Q?CXM7wqrKZJhyruhAYtg7M5mRYO1DN9AKABhzygMZX5eJeFRkzNdif5TV0N/V?=
 =?us-ascii?Q?r+En67JZstfVlsWllmnMSlEgXKp0Z+wGrQFJ8Cegia/HUkS5HGyhhFheUq1C?=
 =?us-ascii?Q?hp4ojFfuLtaElNOsHZPyuMue5RYwjLZHYOhqVKIUXnm6NwPKysNV/KcZ5KrF?=
 =?us-ascii?Q?iSLvedHLRw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdffbe07-6f1b-4be7-8936-08defc382432
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9670.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 08:18:39.0400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26wmJc0umW1WEXtuYtpjH15CMNdVy3j1/xwP6JCW9xDxk8F2pzLviKKoQUosRpb/PQmbqy0y3YZb705YSf4Qsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4311
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C7B280002
X-Stat-Signature: 8joxs3ajbianrcu84hd7ycp3494su1ju
X-HE-Tag: 1786954725-895019
X-HE-Meta: U2FsdGVkX18PTKJlukfthxjJ5ofYdf1V5foVNu+DkQMIncpJ/JRcbjHbqYE6hVeQmpJBP6X7zFeWbP2dfrdxE05Mc7oV150JcIU4u2c1nUgpdtYN97zsVlpprK4QRz3ebWBDrUXFeGF6CsS0DzpqHWl9MWomEXlg1GBTxZ6dic48LLlzmfDZhUUUWZqMDgc70Clj9vPBrbZxqm0h/5M5DRhzkyTx7auf6BeA8mEJd5B+nTOet22r/ti8XSVyE5nSXx6GqgpzEPdjgMED1khMP083DOjMRZaHjzOwDfOGbJa8hmK0l/X87EfA5KEbbXojbAlnmtQrP4fgJcUEmenuQZ9YI8cq1yZAxq5fFSeHp59ErBheF4fEZ7IuYk+4sMFsOdGm5ByZe5Ht9qrpyrF1VzyL+tYN6hi6/z8nGIbiqfSQdVsFBMSWtitCP5L48NQBFLw6cohVHMK6qkRsjJwx0l1pNWOIv9pVQuyJWe184hv9AUgA4JCCiQorhoekL/e5tkNS1p1S2mGevu5Opj+B9LWYX/nIF6H+ANFk4Zm+UD91jqD3aibXiB7SfxLMIxHKUdX8lS3/TtnZir+lfeBV+3ix0Zt5KmyuzClW8ciFwtMdEE8EMxVQCnT42dbRVs+6Vegc9thaGPttgvxIc1nRjGF1ADdx7p9v7djRnblY/grgzNLAr3ajNGdZ6WPH1XC73owWC/IdP+zt90Jl9G2CNo1o/oM2TNZJwnmievJxOYL/UDKaO8MF9yf4K5ZMqjIKef8fgRcEhuI+VcqUD1Ty9l5N5TNuNenTX7RAFeWZy2fUpY1sruD8NyXhhlgmQk0NM4ybPMtR6O24ay17yRZdzyW3P3KWF2iZJhZXr3vQYU6TofOYQm57BP+3nAUgpSj7yCnf4tfE75MsocGEeL7llWWhfCug8fDXBFt5VkqL+8WBHwu3kROMMH7qgsY3tchbzalKbs0mn+/hp8FsXBh
 fiSGIR7k
 YC06HX7/SyYOuRteS6GhK7FDNNBxS87hypaTD55fZvlY+gtWEJzPdlJif/z4nTgRj9r0KCi1GzYrxOYkqPn2tDOrXKzdhIZq/GJoaZT68W00Bllfj61mt5YV5Eh0GAODEk3kyGF9KpmTM8zvq3AKbttRvGovR8tM1fo8Spz+xmWWwpYDOtN6GtVNRkae1VrD9Z9Ux2UkfulTYhv2IRpzBdmrRVTQMBhw5fwO4vnrMJzhOcNCwbSHXv7TGxi/XPqIL8YlnaTy+1KOb8KBxeMQFwWlk3+yJtTr9livtw7y8mFdYmEznvnqWIGYKCDE6xbXPp0KUtJNKKA1xbJob9ntqqcgefTITdaNovmQvwgonVOtJjPP4FSExLpR0zHQHTvp/P9qGheNmapGwD3Sz2CSMaeTn+STts2k8s2C7PKd2KMCTNu+qaD/yNtNWcj7uwoRtAZstBabKjHI/gIpNHM9Qhf3Sf713MuWoW4IIuF7dM1IslhZVGpqbbZFmaJRXYA+8WhN9QYz2TGB7+t81mmLKlfBlR8Xw8t0fsKk1WF1YQCOIwDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 03:43:51PM +0800, Hui Su wrote:
> migrate_device_range() and migrate_device_pfns() clear the entries
> following a compound folio so that the PFN arrays retain their
> page-granular representation.
> 
> If a compound folio extends beyond the end of the caller-provided range,
> the loops clear all following folio entries without limiting them to the
> number of slots remaining in the npages-sized array, causing an
> out-of-bounds write.
> 
> Limit the number of entries updated and consumed to the remaining array
> slots while keeping the actual number of pages in the folio unchanged.
> 
> Observed with a KASAN x86 QEMU kernel using the HMM
> migrate_anon_huge_zero selftest. Closing /dev/hmm_dmirror0 after
> migrating an anonymous huge page to device memory exercises:
> 
>   dmirror_fops_release()
>     -> dmirror_device_evict_chunk()
>       -> migrate_device_range()
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Signed-off-by: Hui Su <sh_def@163.com>
> ---
>  mm/migrate_device.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 908d2d4ec43a..67bfc1af0b29 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1396,16 +1396,17 @@ int migrate_device_range(unsigned long *src_pfns, unsigned long start,
>  	for (pfn = start, i = 0; i < npages; pfn++, i++) {
>  		struct page *page = pfn_to_page(pfn);
>  		struct folio *folio = page_folio(page);
> -		unsigned int nr = 1;
> +		unsigned long nr, slots;
>  
>  		src_pfns[i] = migrate_device_pfn_lock(pfn);
>  		nr = folio_nr_pages(folio);
> +		slots = min(nr, npages - i);
>  		if (nr > 1) {
>  			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
> -			for (j = 1; j < nr; j++)
> +			for (j = 1; j < slots; j++)
>  				src_pfns[i+j] = 0;
> -			i += j - 1;
> -			pfn += j - 1;
> +			i += slots - 1;
> +			pfn += slots - 1;
>  		}
>  	}
>  
> @@ -1430,15 +1431,16 @@ int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
>  	for (i = 0; i < npages; i++) {
>  		struct page *page = pfn_to_page(src_pfns[i]);
>  		struct folio *folio = page_folio(page);
> -		unsigned int nr = 1;
> +		unsigned long nr, slots;
>  
>  		src_pfns[i] = migrate_device_pfn_lock(src_pfns[i]);
>  		nr = folio_nr_pages(folio);
> +		slots = min(nr, npages - i);
>  		if (nr > 1) {
>  			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
> -			for (j = 1; j < nr; j++)
> +			for (j = 1; j < slots; j++)
>  				src_pfns[i+j] = 0;
> -			i += j - 1;
> +			i += slots - 1;
>  		}
>  	}
>  
> -- 
> 2.54.0
> 
>

There is a similar fix sent out by Matthew, The question is, is it OK to
send in partial data upto npages (when nr > npages - i)? We should bail
early and not proceed if that is the case.

Balbir

