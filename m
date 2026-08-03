Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E9DC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4A26B0093; Mon,  3 Aug 2026 11:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D549B6B0096; Mon,  3 Aug 2026 11:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C766B0098; Mon,  3 Aug 2026 11:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3926A6B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:23:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A40551A074C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:23:48 +0000 (UTC)
X-FDA: 85060328136.28.FF65C82
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010039.outbound.protection.outlook.com [52.101.56.39])
	by imf03.hostedemail.com (Postfix) with ESMTP id B12ED20010
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:23:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KdfBipdT;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785770625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fe9MWB2iOkBPPdY26HXHoncpc7Uv5dmhrYMOC/i7px4=;
	b=7emTOHPMRaJyHl642Qkrxp1e/JXjDVL5F4i2IGaOTaS/0SRD+3RsWnKxfsyNiaxxmFxyWD
	4H1Vk7y2lwCKSlz58iMhZxMwiqW167YtfapX95LonO2tJDXxDH9N4pPNRuEARkgMcVBV/b
	TnvjNPBu+jcpxegYs4eqbocEksxZa4I=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KdfBipdT;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785770625;
	b=Nf3UnZwkT2/UAGctulkWBHX1lc2NJIgJH5kgDKr8MrwUKblhj36k13Rj4Ovjcim0XalcXz
	mdVVt4Cnr2lSYOCakcrV3Qcdk4A9bBUrp1t1OhXtwm0ucAEu3tarN4nYklVgUepB4cpPXt
	yIMV7Vua1LwRv6KpC5lbQAXeksQ4i6Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c5Zk7ylLurT7Zdse+wdoytwB5sa7k3it9cidgxup6m1sfUirxxcJh05hii/jJ2VFEwglHEoaVN6P8wjuaX8QkPOm02xsAxMM9WSAcnZS2eODjy6VG1ICUp1N4tExy+VQMOagynTgiUup57L9G0cNmAo1iYqps7ptJ4iq3qwGAMpbl5VRnAnZytgDJnwyJarDQ+SBpM/yfh6YGyE0nTLiBZLPmsxCLMqwVtQYfQB22whBzJsCb4Xe1KOQg09OzFEccYFMBgGNhMxfVwOC6zPo/75qpDVEgHjHd31bEb3cNHVgIaoTG6LXFDNIPKJeG0jIgoRp0IVTw5dXqLbQwz0ELQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fe9MWB2iOkBPPdY26HXHoncpc7Uv5dmhrYMOC/i7px4=;
 b=kEzVH5m1IY8r3yor2Sd7CzG95bUooc0egmSgxLzAXlo2LK0zPkbHJBA4RYs1e2d267TILhyxqCmz9l6kJUHBJhhowrDS8XPIZXMNRZf7KatLq4x+Phg6Vn8CdaCDngQME96GaOAG7itrbi0tflxl9tDekV3Gw8liQXdsnOggYf22ZeCtyLoCwHAf5LXANT17B9WwQhWBlyWJrTgTx38hNp4GohAn7NdCboJfTl7UPZyCPT17Ja5X7j4fEJ4NvK1BfsVRMoAGZJxzMuqSG5bZ+5da/XmkuoqfjbkzNJzC+PbNhvGT6uU57Gm02Z/NZj2DRmvbDNkh2uxpFXjWd9zwnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fe9MWB2iOkBPPdY26HXHoncpc7Uv5dmhrYMOC/i7px4=;
 b=KdfBipdT/SvTrKaUbnUeaFarPjJLpOWilE6gluWQy4pYlciLzWvqcbIc+ryKnSmaqxE/g0wY2TdB0MVHmSOhQ05Ks38v4ngRqoRvn9XASnoyFCFwmmAgRg0eeo4O6rmjWw7Y2dE1CZVDU0OsAiCVlvFRA0UU9aPkPvJ2dXKiM0YZO+vT4//Aat6VrCSB9v2f3GPD1RhGZfikU833w7iYaKIjP1zB8ISSJn8NWf4Hgq04pVgzCqDPK/JSGsAgislp4ob1gAjHXaE/6VJJftR5X4OgOHdMexPxpdK0aZ54ITjAuh8GgF1bYNuRFTfjc6EpdqewW1N0hSM2I8AXRpsp1Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL4PR12MB9484.namprd12.prod.outlook.com (2603:10b6:208:58e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 15:23:41 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 15:23:41 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Aug 2026 11:23:39 -0400
Message-Id: <DKFEUPDED2AF.22PKCFTWTG6G5@nvidia.com>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Matthew Wilcox" <willy@infradead.org>,
 "William Kucharski" <william.kucharski@oracle.com>, "David Hildenbrand"
 <david@kernel.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R.
 Howlett" <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 1/2] mm/huge_memory: use folio's memcg inside
 __folio_split()
X-Mailer: aerc 0.21.0
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com> <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com> <am28pV2PEfHsi4p-@lucifer> <DKFEEI2EDS4F.1AHGKB1EL6XRG@nvidia.com> <anCtxQE5hDUH5N6a@lucifer>
In-Reply-To: <anCtxQE5hDUH5N6a@lucifer>
X-ClientProxiedBy: BLAPR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:208:36e::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL4PR12MB9484:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d2250a7-4c63-42f6-2280-08def17332bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|11063799006|56012099006|4143699003|5023799004|6133799003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	P6AgpCJMPAbiWqDaV0zzgZXyXnoCbNKMk9G313amcjwdVMB3+YLq26bfepSqB5CsocZAJZDRN+3TzB2QLSas/yrdIo7KrQh80eu9cW+ZVw4MwarXbamBB1tC2nfGvBljmJlj422bjDKdkwUoLBC4snZwphWVKQcJ9pv57DvGP8W5d6T2EBbSk349HZKlQRdkbHFQ4hNL9GRbA/hUkpMTxsqeHDDABgZJ4PNeXBjlCNOOE4jXlBv1yICX3ANgJ3Joh5QcVJLg4hwlInf7i1+HCVqGAyHWu3U1ylmgMEFJ8EHfhv6+BvQyHfUWLhaQS7gNQq76RrCX39j8o42XwUWTsC0lZkT5M7Q3Rw1GmvSUi7/WEuaMUjIhE0MlwUYArMhToAkxnekK+W6Zuyi8LLxnjYFRZaFPT0e4inAo8NbKszFu95M/zrdSo/SBQ/IwQkfAYP3nQGO3VgocVr/S9L0g1ZVWX6z0QZW6rYGUhSwiK8Tk3nN2rm+rVrBP8une4bJMC+vislKJ2bYa9WzLUYWFuyjxQMuQxTw2pWe3wwb1H1l/KP+cB7hVSfjXtsXLLLq+ipilciFt2MNEqtXCKlBj47BNjMzkyrp+bvuMLjwM2hZ33+vdFo62ZJH+wYut3u47kIiw8fvJxrfwAOObA+YzBk0YgerXR0nMoDIGEvk7DLs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(11063799006)(56012099006)(4143699003)(5023799004)(6133799003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2RBSUpmVkV3QXJmRjRFL0kvcGlHOG5YQ1k4WkswSW5qY1lPQi9SamNxdWE2?=
 =?utf-8?B?Z0QvdlllTUd0aUNsd2NHYXBNa3k0N0J6RjBuYS92RXFMM0NzQlQxTkhVZ2lk?=
 =?utf-8?B?OE1PcnA5M0doV0lmV2prUzZPT216S01rNjRHak1zNjEzQlZ1b1NIT00ycDJU?=
 =?utf-8?B?azBKM0JIenVXYXg2YUNScWM3Nk0vRTdZYTZMbjVpdmpQaWRPYXNCMXBsaGpR?=
 =?utf-8?B?b2huK2M5YmhjbDVGejA4R212a2lZYlhaeWoyS050TEQvOEpidGhSZGRuRUxF?=
 =?utf-8?B?WCt4S1k1cE1tQXRyT21CQjlvTjg0aitXMGhkYXRHb2xDNjJSSmZlMmsxNDBw?=
 =?utf-8?B?U2VxMGhuZ2ZrOFRqK2JjZHZnejNzdGJ1ODdsODIxUmEza0hVUGF3UGgzVjJy?=
 =?utf-8?B?V3RyeTYvZXh2SzFZVVN4U0VPUnFlcEYyU0IzS21LK0R4SGJOK2ZYQ011ZUVm?=
 =?utf-8?B?b1RmQ1lFenk0YldPSk93VExSRVZiMXJwMndZUUd5RXUwajJOMzJzc1Y4dkNW?=
 =?utf-8?B?WTdDbi9MTkJGTUhPNFhPYWVOMFdieGVEODBhWUQvZnFxVEcrZVhtc3o2WGdQ?=
 =?utf-8?B?TG02a0pZcncwbTYrK2lOZjBxenVyZElDc0VXREREN09WamttQ3dhZE9zZWgr?=
 =?utf-8?B?Mjh4MTVIY1V0VVdwSnlmc245Q3VFaTBMWlpoMys0cVNIMS9oL3dINHh1ZUxK?=
 =?utf-8?B?ZjFGNWs3Kzl3dTlvVnd3ZTJXdmJFRjB0emxqckFIcW5wRjRXSThCYURQTVFK?=
 =?utf-8?B?d3diM3BnSE5vdGpTL3hETWt2VkpvaWJVc01teFdHVGJxQ0pvK0FoQkptbXVx?=
 =?utf-8?B?cXRHMVBxTlBRc2hsRXJrL05VWllGVUY5VWFZRjljSHJZMGlsUTlqd3JyaEZk?=
 =?utf-8?B?cGRYcVA4NGIwNlFQczFMWGVtYVVRQW9BaE5WWEVtN1UrencrUDZQOUxvSnRS?=
 =?utf-8?B?YUlyeU5TTEVQOVZNOGJTRlllL2VReCt3T3lVa1BNYy9GQS80TjY5R3lwOGt5?=
 =?utf-8?B?Y3dEMnJoWVQrSmFkZDhXWjc0WjBjbDNCc1h0eUdISENuMEh2OTR3RjlwOTU0?=
 =?utf-8?B?NnZmWm42VWpqZWt2b3ljMWp3MVFOU09Xb0pyVEoybGpYdWhwMGNjdWNwZ1Zn?=
 =?utf-8?B?Rks5aVB1Zk5KNzB2cUU1MnBRQk9NcnA5UlF6cmNaVjNPZ3RGS3MwWE80bzJZ?=
 =?utf-8?B?VFB5VUFEUitOWENaRkRlTmFoQkF6WFEybWF3aDZuY1Q1TGZwdTlOVjgyaWxU?=
 =?utf-8?B?WE0vTCs4UFViVGpDbEVZaVBOWG4yV01Pb3ZUcnV0eWRiUWZycVRyMjhma3BI?=
 =?utf-8?B?ZGtjUmNkaXVIeVYyNXN5cWN5OG1pakRMaE5zbG5rM2puV21vYW5yTkNmQ1Vt?=
 =?utf-8?B?TW51MkdiWE01VWlVcXNlb0FkbDNnY1I4bjFaNTROYkZ0L21SeENTaEMzWEF3?=
 =?utf-8?B?NzVWdUJSNmM3QXRyUVFHTk5ZQ2lzUjZ0bG1QOUt1M29kWXNLdDlDYjIrSGgw?=
 =?utf-8?B?LzBIZG9HU1lzdkJ6QldlZWpOOERMcTdSWE1KV0VQVXFlb0RQZzBON0JhTGs0?=
 =?utf-8?B?ZVI5akNPR2tURXFMWDlleGdBSHF5R0N0WWJ4QTlVS2RaNnNXQnpTbFk2YWVM?=
 =?utf-8?B?S1ZzVzFQd21QK0VtZ1ZYVDdjcld3KzBCcTVuU0Z6Ry9aZGRVSktIT1FCd214?=
 =?utf-8?B?TFgxTFJvTWJWRWdHemJIQVpvQ1RONDZwRWlYNWhmWnJBNTNGQWcyUFRubXZp?=
 =?utf-8?B?VE5pWXFuVlVEdzRHMDVROE1DakVqTzFFMUx2Wm4zcDB4UTd0NW51QzZBbVc2?=
 =?utf-8?B?WHVzMDZyZnVHNFQweHhuamZPT2lNejdaRnJUSkNvNVVDV3VjSFo3cFdiNnc4?=
 =?utf-8?B?UXJsYjZKZkRwSW5oY1hMYk8yMWFGVWNTOC9kVFR4NXVyZ2Nvb1cvMElGakVR?=
 =?utf-8?B?dWdFOU8waWl4QWxLYU1IbWVIRnU1bXlueDZCbkU0T1BBcGxYTTVIUXVRWC9U?=
 =?utf-8?B?d2dJMUZsTzFacThWekYwYjcxRmxxZis3QXRZb3RUMFVia243T1VrbTREWko0?=
 =?utf-8?B?M3ZTNTdTTVhISEhMQzJ0WkkzUDhJWFd4SFZSNFVOS2wreTN4cGNTZlJGUFJW?=
 =?utf-8?B?aHZtVVcyQ2JDRU1KRTVnMHhDY0ZCVy9jOFBacTZqMER2NnJpd0djdmJjQnhH?=
 =?utf-8?B?dUVBT01hVFFOUHJlaWlyQ2VRMGZyc1dBbHV2VlAwSjFhWHAwMVpYUFY3R2sv?=
 =?utf-8?B?QkxIY0ZBam1odVIyd1pjZklPbkdpcFQyNHNkUDhLSDd6ZW05Zy83SXZjSmF3?=
 =?utf-8?Q?00vyxPQu09t0101YLu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d2250a7-4c63-42f6-2280-08def17332bd
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 15:23:40.9263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRucwq84gN583raEUk/N/L9jO1Z5P2soT+J4Oho5/IrgAb58iD5RU1olirsDSWux
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9484
X-Rspamd-Queue-Id: B12ED20010
X-Rspam-User: 
X-Stat-Signature: d3pdtoy6ttn6jfcsadz9aizidgs1165m
X-Rspamd-Server: rspam04
X-HE-Tag: 1785770625-145898
X-HE-Meta: U2FsdGVkX1+2jTlEtomcTG1DPPBO4mKIzqvze6NGZgs+8WEswuFjdpJtci7Eddbv6h6qx0xKvrd1aM2z/sU+bLVMtFpAWeFdPEp53OSR+KbPE462ehBNMaDtCdUeefsYbxWZLEsT9T5BNriQQK01ey100A7taPSdAMCAe0mf93UVoPdodg+gm/OuVghKd3yK7YSfPFlRXuNND9R+tEVaiQmznzNd7T1HyjuCaNQlhWcfyOx2zWK212P0vVz0aLniW8DEPtv0qnn3Jx4LKvraNu8jRVAZA/1GJJ12fHL04P6KrBXhjJGazTkFQrkPzl18Ojkr9+zyeOLmNFj2el7t1B01BwdFk0rPWNsiK/kHqYq6FbWxLgCvjfc7hXXZgo10B+vFUFAbFo5556yH1IqczZC/DApr5KJZjugPXbXMIHpMrx2JVhJ20MKrKsokmKUsb3VJEAvRHockSIwVmXoFcmUJYTiMAXm9C3fcvbp5nPuP1VfhpI9TVsLhn9RPntvAs996pMpX3Q7cR/uWGvBn+hLYDzXJv1GgegdhwIvNovEGe/s7sttauQdtUjhuNdMzOsiHkjkNxZQd6qe+wMrRT7tfJFzQYbZGLFKUt3twfeM0mXSPt6+tczE8oMc9wQLt88aVHRMSZjmpM70srr7h9fYA7wQevMDPxLvzgo2VB4GPerRJ7yQcNpJLVH2ivTd7Vkde/hlAVj4bUOrRoIEOhs8Ez9YyHpLJ5a5EDpiXfuG7As+1pOQ4PfObV+A+/fIoTQmfsDEFb27FmDbf7uaJWXlaG8Np7DSKEn58wDYPba/W2cIugD+bXx9n8V7viP901KtSUzA0hSQ3IqgHr4lgIpful3jKEzOk/lENBxGmyLo1DDiAQERguhqR9vFtlyNn0tjSfzGXgBPsUaiueiPGpBOUsh1AaiMQ6mC3y6Qm0OF0mfdMz1b8/YgDJ+MBRlNytXMW3Y5BCXVu47HQgR+
 oBr6F+4e
 MP4S0RB0tm9pLC0w9MTubjLbIRt6FoqmUhi810yJIMYCoQokv87ZGVKTYdAvclCR70rHOnsYHJ3p5EkGVX+yr0+DgNPrdtm4B62U8YVH/Y+VhT2kZR1jOJKKHLDAjZCiGfw1Byqf/baximdjthY8JghCjdSNCtfbTXncnrM/bO5REbl7sc8x0lG/r+godIOheDUOJjJyJzKelw0uOFcbcN35vXkJFud7Uj5SpM2q2LhOu+34WI3VIThaFdElx226x+elGLoPX6qCGuAESV5RrI/ovduhedAifV2llKwXF49jC/kYaMdSY1DLbu34LFOzPZCSNIfnkUA0c7uvQZYCjZVe4avDXh71Yb3kV6Fn8Wu2C/E+oPPE5goswW33tWhrDu3xy/SQcF058YQDQwrMReLKsF2hnby1kISwP+zpR2Rdz44/5MRBgNKOrI2oI2zJaI0jXVMU+i/ztdEwuJ2P0fKn/WM9aoXXzcgBxdoeRGRA+JM9I+buTplpt3CX9RiHRgQ1Erduc/wHWAQv3Vf1vv4MeSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 3, 2026 at 11:07 AM EDT, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 11:02:30AM -0400, Zi Yan wrote:
>> On Sat Aug 1, 2026 at 5:36 AM EDT, Lorenzo Stoakes (ARM) wrote:
>> > On Thu, Jul 30, 2026 at 10:18:00PM -0400, Zi Yan wrote:
>> >> During a pagecache folio split, an xarray node allocation can happen =
and
>> >> needs to charge at folio's memcg instead of folio split invoker's mem=
cg,
>> >> because for example folio split can happen during reclaim and reclaim=
's
>> >> active memcg might not be folio's memcg. Switch to folio's memcg at t=
he
>> >> beginning and switch back afterwards.
>> >
>> > I assume this is the only allocation? I guess in general it makes sens=
e to have
>> > the folio's memcg be active here regardless.
>> >
>> >>
>> >> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>> >> Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache"=
)
>> >
>> > Cc: stable?
>>
>> Like you said above, only xas_split_alloc() is affected. And we have not
>> seen related workingset regression report (like what Johannes reported
>> in commit 7b785645e8f13 ("mm: fix page cache convergence regression")).
>> It might be OK to not backport.
>>
>> Johannes, what is your take on this?
>>
>> >
>> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> >
>> > Change seems reasonable overall.
>> >
>> > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> >
>> >> ---
>> >>  mm/huge_memory.c | 20 ++++++++++++++++----
>> >>  1 file changed, 16 insertions(+), 4 deletions(-)
>> >>
>> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> >> index 04e8a6b553435..b9c2d8908e564 100644
>> >> --- a/mm/huge_memory.c
>> >> +++ b/mm/huge_memory.c
>> >> @@ -4063,34 +4063,42 @@ static int __folio_split(struct folio *folio,=
 unsigned int new_order,
>> >>  	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>> >>  	struct folio *end_folio =3D folio_next(folio);
>> >>  	bool is_anon =3D folio_test_anon(folio);
>> >> +	struct mem_cgroup *memcg, *old_memcg;
>> >>  	struct address_space *mapping =3D NULL;
>> >>  	struct anon_vma *anon_vma =3D NULL;
>> >>  	int old_order =3D folio_order(folio);
>> >>  	struct folio *new_folio, *next;
>> >>  	int nr_shmem_dropped =3D 0;
>> >>  	enum ttu_flags ttu_flags =3D 0;
>> >> -	int ret;
>> >>  	pgoff_t end =3D 0;
>> >> +	int ret;
>> >>
>> >>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>> >>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>> >>
>> >>  	if (folio !=3D page_folio(split_at) || folio !=3D page_folio(lock_a=
t)) {
>> >>  		ret =3D -EINVAL;
>> >> -		goto out;
>> >> +		goto out_no_memcg;
>> >>  	}
>> >>
>> >>  	if (new_order >=3D old_order) {
>> >>  		ret =3D -EINVAL;
>> >> -		goto out;
>> >> +		goto out_no_memcg;
>> >>  	}
>> >>
>> >>  	ret =3D folio_check_splittable(folio, new_order, split_type);
>> >>  	if (ret) {
>> >>  		VM_WARN_ONCE(ret =3D=3D -EINVAL, "Tried to split an unsplittable f=
olio");
>> >> -		goto out;
>> >> +		goto out_no_memcg;
>> >
>> > This function really badly needs splitting up and probably some cleanu=
p.h work :)
>>
>> You mean folio_check_splittable()? You want to move -EINVAL checks a
>> separate one?
>
> No __folio_split().
>
> Comment about cleanup.h really was the whole pattern of goto xxx for vari=
ous
> levels of unwinding things.
>
> But really I mean the folio splitting code in general, there's a lot of
> massive-complicated-functions with a million things going on at once,
> __folio_freeze_and_split_unmapped() is another.
>
> Feels like we should really have this stuff in something like mm/folio.c =
anyway
> too now that's renamed :)
>

I agree that __folio_split() is handling multiple cases, anon, shmem,
pagecache, all together. Do you prefer:

1. split __folio_split() to handle each case in a separate function with
some code duplication, like xarray for pagecache and shmem,
freeze/unfreeze folio for all;=20

or

2. encapulate per-case code in small functions, like
if (is_anon)
    split_prepare_anon();
else
    split_prepare_file_backed();

__folio_freeze_and_split_unmapped();

if (is_anon)
    post_split_anon();
else
    post_split_file_backed();


--=20
Best Regards,
Yan, Zi


