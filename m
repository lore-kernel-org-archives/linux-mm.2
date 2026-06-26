Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8426FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6894F6B0132; Fri, 26 Jun 2026 14:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6616B6B0134; Fri, 26 Jun 2026 14:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54FAE6B0135; Fri, 26 Jun 2026 14:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27D856B0132
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:45:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5A1CA04AA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:45:24 +0000 (UTC)
X-FDA: 84922941768.30.064498D
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010002.outbound.protection.outlook.com [52.101.193.2])
	by imf28.hostedemail.com (Postfix) with ESMTP id B6E07C000C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:45:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gNOWoiyt;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782499521;
	b=XwjvmcMu0l6QMszg4sfEShn/sek+FwMKo+GLdDIn5UZa+toKFIuwC4td9AMjHXAZyp8yga
	Hl3D/ycuD7wWj0HAuiuXJJknI0/fPDEbIKgs+/ufS4iigHy2N278A6OZra5xuihd3dQhQs
	JfLRKFamn+b2HBTPbnOYc0wBLhgNv9M=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782499521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEM5h3eKJTYQXZ2PCFGrBwgVloRLVCcvKbRXYbtUUuk=;
	b=r60bZY4wtmaEh9thLHLTviR1+olewoR0CeOe9c8P/pGxCtPfxXFToggwlVAG6jAAL3nD7u
	MYqWDjJAOvwCFXGqeAWYMNFnfjKaDWoksmx+x4ZXebav4pr5ztOytkfrCHh4Ic5/e92die
	BOow5hMaZZgSb3S4kBnbq2keaG6/dH0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gNOWoiyt;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DPb0x96p7xQfntXNng9hLkyAfYkEG0KK8fEyd+Aup1TxvI6hHd5/fdpoK1g5Mcd+6s1MRHKq2VoWKQPaqP0EeTbnTPPJCvbtgO8doO3NzjYpOeBUOo5P227UHr73h9RlWntuDbBFtiSFAp2d4gdbZoa2yMel4YBDhxbh/BUouP8LsuSAcXOzflZSck0T7gm6vt6UZGYP25hMsiF2SI9CF7bNQ2FdIMsb6kECGGqH3wwllk/acDD+0GAlAiKEeaV9h/iNUasBs5/zeko9itG+eUZgxlpEcpgG44xuxr0OnB3ZkN0niS9yLvfE8O869QlgEJeDt+kB0sIIMFLQvLsj5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aEM5h3eKJTYQXZ2PCFGrBwgVloRLVCcvKbRXYbtUUuk=;
 b=amSP3g5Ty/qL5zz424jyFJyW9WI+lQoPb40mzpENcz8P34/8OfZsMBnXjc5ippnHkKq4JMiErQRgyY1GcI8FjVyh0oATukDpTe/szTDDKYUC6v7JChNFAzZk5ERu2HPwtvxlwBnipV6Ka2VHq3hAvP1sCZgP6kfTQgk5tRxjvDqVLhvZqApILg664rRTR7w2YLjZp0cQ2StKdF2pz6K/tgutDFGM9g/iViWcZNn7cBzWs1Xxrg62mjo/Uc0r6xaP/Egf6jWc5s9TvQr9b+itlkH3cx6r0yzFunxAdGGw9oVwCxrlZpewLviRwv27FQ4+4P5265u8qxAveVBiCv+vug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEM5h3eKJTYQXZ2PCFGrBwgVloRLVCcvKbRXYbtUUuk=;
 b=gNOWoiytPd0c/AQpi5zl/9Re13/YlUC+9RQh7m4X8AVhh9RQ8g0mQabbEOOhZpvF/G+d3MyDeoKW/Y1Jq6x0wfiydHvGzodzfVPHI4DQZkDeXTZPEemLrfjTqOQsRU5FPvtopPnvMXTWdeIHZJylRsUeDMeKD290zktByDX31S8FhS9Tpi3sGP/JoJ1TPGOC2OGsEjI6munGZCddSFkN7oJk/QuBi8tCe8HFaW07FvQDNVn3IeSIi/VX3js0pDYkd0P4eSW1MqquAhvx5ma4c4koDG4IYeGG1C+GuyhkjIVSaL3HKBJ/bP6FIzKgDZtDyJ5kkUlSu7wyA5zjXboGHQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SAWPR12MB999166.namprd12.prod.outlook.com (2603:10b6:806:4e1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Fri, 26 Jun
 2026 18:45:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 18:45:17 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:45:15 -0400
Message-Id: <DJJ7CCWCYI47.3VWWQE2AWP6NC@nvidia.com>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 2/6] mm/page_owner: use MIGRATE_REASON_NONE instead
 of -1 for last_migrate_reason
X-Mailer: aerc 0.21.0
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-3-ye.liu@linux.dev>
In-Reply-To: <20260626024550.25677-3-ye.liu@linux.dev>
X-ClientProxiedBy: CH2PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:610:59::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SAWPR12MB999166:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d93964d-b4cb-477e-0f99-08ded3b310ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|6133799003|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	KXrzsC5dupKY/4wGH0eaq+YSw28bFEyIskY0KwZh/EcODBcwhy93QQWXmu0jt/ITtshfWZC8OWVwGXXi62bsSRUK2cHZD9hBAv35Z1Zs0m/JBBecywICmHDAAJtp6nsgZ6t5ZvbjezlL2lfbhWiz4I0+zyj6QSEeTbU4C+nTYo3Hr4vj/X3rA3PdS6ZHDq+RriaoAkaZDFYflxk2rIisXC/idT28iq1sYd6iD9Hy147Se5cqrcxowKFduS1TyCOvZh6th2B7Uwa4nxdyQaGF0ETQZ2f/ZrmhSjP93dUeW2M8kV9LNuyHjM0qWp9s65uPrblRjj4VUc2CViXMGb6FyNISmudULPmpTv8d2/7D0lNg8vtMQtF99XTiM9Ud+xo2Kx9eUdc6GAt/OMKkaFsfYx47NqC5/Axe3hWJ3O3+s2zph7Pc2ajr5BcJBUQeZtE79uRwUu0aAS6JFuznAXVxfIfuPZdSCFfQ2TmB+bnn6aReaYz2t8KAszZUfKo2o0eVvKD08r60FG9WmY3Y8CVW4W9e1My9k7q1owoOo80ys5pRkBiU34uzicYMcz9xppmNcHJs7WDRBsWnX70+8GMUrUx/QBsdpILUEdkIba0iZeoWgaqr/c2EDT8WkdaSMcOCd62T5gVZmbaz9svgfxlgaD5kaK7csDO6eNNmPX+P03M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXVwQUV3bjZxaVc5RCtzUEdQaDRHOWdmd2syWG5WZXFmQnQ2ZktEMXNSNGtp?=
 =?utf-8?B?bjNDRFEzZ09wWTVCeG9CTG5RT3pUN2NRS1I1LzNYd1JmNkhHVkZ2WUpDWFF1?=
 =?utf-8?B?N05kMGRONTJNWG1QMXBrU0RWYW9HUmVZYWRQK0xESkVRYWc2U2ZqVE95MXdX?=
 =?utf-8?B?T2RyWkc4NThMSGlwMVEyY2RRSmlMTVpBekRERGs1MVZ1bTArWVN1a20vQkwv?=
 =?utf-8?B?T09aRnd6V3YxVEZObG9oQlVVNUNqWjY0T0RML0FKWUdVa3Q1RzBkZDFSaWlP?=
 =?utf-8?B?T1ZxcWI5TU5mUG1DbzlYclVkb1VBZXd4R0FDUXIyWFVvOGNNQnptOWdNelQ0?=
 =?utf-8?B?Y2xqWXYxRHlkY0ZhY25SYW84WmlhbmNhaTBxUDJwN0YvYWU3K1ZCamUvSUg0?=
 =?utf-8?B?M2wvcHN1TUVRQzhDaktEY2o0OFhSdU5KU3VXSmRjc2Z4L3d4akxwWUNUTEpY?=
 =?utf-8?B?b3c1eGQ0Vmg1R1V2V0xycmZtZTJ6Y0FRZjBSSUdENS9rRjFINWVXTUdPa0Iv?=
 =?utf-8?B?V3JVQWZVTHZNcURIS2pYQ09DQTNZMUwvTjVnRThFODU3aHpUQUI2T3ZTS2xN?=
 =?utf-8?B?WVhWeUJ4Y0kwbytjeGxZQnFjL29JeEVWZlBST25QNEIwVGk4bzRXVE42b2cx?=
 =?utf-8?B?bVFMZy9PUktqM3VyamtMRGRMRnpMclNUT1Rpamw5UzhxcXRjNG0yNW9MSFNl?=
 =?utf-8?B?WWs5cHp1bjVPcDZMQm0veDFRWWpGL1dGcmRlRm9BYXUxTERDRTJUdlpKS3Bx?=
 =?utf-8?B?Ti9JUGwvOHRvbXE1a2pRQnF2aERwdFFhYVZ4R0tjTEpTQk1abEU5ckI2WFBD?=
 =?utf-8?B?Nit6T3F4N2Vndk5tVlViUXRoZTkyN1NPbkxFcXVMNXlXNi9KeEQyZDVzQUhF?=
 =?utf-8?B?YklmMkp6Q05sZGNMMmdtd0hNV2xXaHB1aTFNZlpVQTFiMXpwWmdKQTVtZHVJ?=
 =?utf-8?B?Tlh3b0t5QXV1RnFEc3dJYy9NVVVqUTBRaWhQY0tzRlRYZmp5bUVJSFRqMmVP?=
 =?utf-8?B?ODJUdVpXRXJDMTVmblN0czA0K08zMFJJUWRIMWsydlY3NGpHVkJKWVFzdlpS?=
 =?utf-8?B?Z3Jpc1JLRUE5aTZINmx4eVBDWHh5eEZkbGNVNGl4S1ZGeVJweTlWRlVVVS9N?=
 =?utf-8?B?U1IxdDZCS203dCtueVF0Nng3UC9CeVc1OTZEdUFwVGR6d3FvbHRRelp0U1Fr?=
 =?utf-8?B?ZkdiMlFQbGlRMlc2U1FRUzBNeVdwV0orVjM3b1NRMDFtYW5MSWk0bzBTWGFW?=
 =?utf-8?B?TWlKOS85MGQyT3V5Z1ArMEpoSDcxSmNqMm80UFMvSldRN09NL3psRFJkZ09x?=
 =?utf-8?B?UWI2b0JTL0ZKbk1SZjhwOXowbWdVelpjVWFXL05iTDJPYTBDSnptajFFSXdv?=
 =?utf-8?B?TDZPV1hrRS9NWWM3bVRkYmppMHZzTDBrb0daMVBuUUJacHg1ZWJiRmNQeHRI?=
 =?utf-8?B?bTJsQXN1d0lOMCs0QmVZM0M2UlpzbTVYdXFDV0xGMGpqTmw0d0NWQkpCZ1cw?=
 =?utf-8?B?S1pCTS8zM2FLTU5DK1BZS0VrYjRxWnVBd3dTWmkzYVpaQ2libE9aOXFDR3Uw?=
 =?utf-8?B?WGxmc0xYN0h6R1liRVU4TVVLRDAwbE8wczZ2Q2l0WHJNaExSVFp2M2tlUzIw?=
 =?utf-8?B?SjJ1ZHlqYW45aHlNcFAvcU1yd3ZzZkpPenlDemNUTFNDZGwzMU5RdFhFVG4y?=
 =?utf-8?B?YjFHakdSMkVLbTF2dHlVRzFEZGF6NlRNMTBrZ3BoVTREQTg5WGw1bXlTNGxH?=
 =?utf-8?B?NGN1amMrdDdRNWc2dVAxSGlkVXVOYk9NNnJIempEaGlBM1BqakFLaEpsRUdm?=
 =?utf-8?B?QzU4Z1NTTUJLZTJGaUhhQTBDTnV1blVWSnpkYzFtOENLQ0ZNblRkZk5nYUk1?=
 =?utf-8?B?ckRqUDAwWnZqWFloWXlCdFZqSkRBakl1SmJPRzluK25HT0pWblZaZUE3NGFY?=
 =?utf-8?B?WGlQQVQ0WFZSaEZ6VTVWSlpiWHpVL1ZMK0JQNDlyS09TNHQzWjhadVFrT2ZN?=
 =?utf-8?B?bzREcUFSNGx3SUdXTzd6MWdydTAyM1lvNFd6elIxOXhsUXAzRjBQaFhORmNL?=
 =?utf-8?B?TTB5UVZnTlF5aUNGWWwveHdtaVJMWlV6M0V0MzIzckNwK2J1YWtqdXNHdE5G?=
 =?utf-8?B?WVZjOVUycHIxNFQ2VkpNNEVSUUdSWWt5WVZVSmY5VXVrWDBodXVwcEJQU0J4?=
 =?utf-8?B?Y0JGVUJQM2Jjck5yaS9tL012cXVxR0szc3FwN0p0a1lrbHFTaHR4Szh6SXNC?=
 =?utf-8?B?TmlMQVQvWXlZZGNQZy9iVFRJczdBRSs4VTBuRFRKOE0yRytFTlJtSlZYa29E?=
 =?utf-8?Q?Br2XtQbBmQhmNznsfO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d93964d-b4cb-477e-0f99-08ded3b310ee
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 18:45:17.1043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJsMfSM6m/VdyjFGJPesxlFM4gWQ6ZMVJtdTMKnQvwhlIXsSz1OvnfonPJUBUES3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999166
X-Rspam-User: 
X-Stat-Signature: t64kcjm3qzbji884nt89sgopstb7zzxw
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B6E07C000C
X-HE-Tag: 1782499521-213604
X-HE-Meta: U2FsdGVkX1+MTJ0q30qfU1tlWbFmLbSi7stxEctrZs5WQf9B9+OVYNSq2jWP2zy8gYRBbi1XRSWPPrchOt5VrLN2fE/HAn6uZqCPQIdgxi1yjG3ZdMOqfvRCjHl1YSeNxF8nIeaKBclX46IhwHlPP5Xu7LjZRgG47p8oAw38dyCXSxCHvPdzji+bphMb+K2rsfyB/ndd/B1oG2xloc2O2rmRfJkCd2JqMKTmWHu0mdbu41QYo/f0OqvG2rGryspDz2vDOc3upsToF5VENxLA38N9zr/FT9uKGQ8b44sP/XTFyHZommnm9miBl7D5ZgPr3RjAzcGCyQc2mUSr/J8xUN1CksQLkvYMiIt9RGOPuERrSdP4dwU5LW6+kNz6UEuA/A4H6zu3xBRYV6ygVR4laoYbB93i/MJfdHZ5NoGCGkafMa051jkyOdjZ0g8u8klZmeJAvLmEbDj+thUeskMi0eobswdlbR5b8GVqM+NujgHpd5wwC+9qLvHakuUnOsyzNJTk2onRqvabfSY8+NFXMdBvE7uXRhEzG6VNaahj6MnlEJkvVW6UK1gjt7CqevTN5h7bKUsrk+WsH5BJmjN+hDx1FsxIgSbR/gEgtPpxwwnqz44o+hngU/3gM3ac+qHiShDoUMN3k1QBj5eCp+IzD/bTlvcMNthqfhDOPw7uKpLz1yOq6AGI8zaZnW+eImPXfY3KGCAdMj+qYQyl6DiajbAES8/7UzdFj6ZzsYYlQMffk4XKPpancuwloVU3MYTW8w0MDvR+r8ZudkzAGrOPiS/wle83w9IQyfO94gh9Qv5XcTC5XT3ZP6x2s9whWEi4tk2vfvetP1yFqk/wfX/nnxwBDwvocqBicqhbAwNY/9TDk/VohZaXk3XAIu7rhM5Pwg4EYMUPG6KATMImv5QQk26IhPVenp8Ku+27AB37RyM10wCYNA99DqjWZlnmYXDzU/mBRi2o290Xa2Lrm2l
 aGroCMYa
 GoXqipx/+/iz3pR/5cwzBrItodkmij1gyXfGTRlCZD6lpY17rzmR6JjF1wQoGOwZRbU/VQdvRXz5i5z9DMVLpQ51S4rq2pje3KmwaZLrBYIqP8vKN7uoASlEmP3pboITuZ5GymK/IvF9+P55rg8TcE3UhM1kwnaL4NsalGO0L9PfR8AVMB0LxoXrZJdkTZcod5dxFTR1xt+vovZ5+trFLAixpgriP6VOZahBJ+xBdReq3/S+SnIHm50bGN7Yxp6oAJQm4V43Ws+ql3EAWACTQeGZs43ZG4qpg1DXcnlPbq51gSZllQyKXtFnwkNSU34zytjKYru3E3G42dqA6jreSyx7TGXuccQH23rm6NG7fLSJnXLZrPJzUaEk1NrvcSIg2z3q37jEm7HDiDnOidaNokozSYU5uz1QhNfzuC3Jh5eZmibQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 10:45 PM EDT, Ye Liu wrote:
> The last_migrate_reason field uses -1 as a sentinel value to mean "no
> migration has happened".  Replace the four bare -1 occurrences with a
> local MIGRATE_REASON_NONE define so the intent is explicit and the
> magic number is eliminated.
>
> No functional change.
>
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> ---
>  mm/page_owner.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 342549891a8d..ebafa9d7ff07 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -21,6 +21,13 @@
>   */
>  #define PAGE_OWNER_STACK_DEPTH (16)
> =20
> +/*
> + * Used to indicate that a page has never been migrated, as the valid
> + * migrate_reason values are non-negative enum members (MR_* in
> + * include/linux/migrate_mode.h).

Why not change last_migrate_reason to enum migrate_reason and functions
pass migrate reasons? MR_TYPES probably can be used to indicate no
migration has happened if we do not want to add MR_NO_MIGRATION.

folio_set_owner_migrate_reason(),
__folio_set_owner_migrate_reason(),
move_hugetlb_state(), and
__update_page_owner_handle() need to update their signatures for this.


> + */
> +#define MIGRATE_REASON_NONE (-1)
> +
>  struct page_owner {
>  	unsigned short order;
>  	short last_migrate_reason;
> @@ -339,7 +346,7 @@ noinline void __set_page_owner(struct page *page, uns=
igned short order,
>  	depot_stack_handle_t handle;
> =20
>  	handle =3D save_stack(gfp_mask);
> -	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
> +	__update_page_owner_handle(page, handle, order, gfp_mask, MIGRATE_REASO=
N_NONE,
>  				   ts_nsec, current->pid, current->tgid,
>  				   current->comm);
>  	inc_stack_record_count(handle, gfp_mask, 1 << order);
> @@ -596,7 +603,7 @@ print_page_owner(char __user *buf, size_t count, unsi=
gned long pfn,
>  	if (ret >=3D count)
>  		goto err;
> =20
> -	if (page_owner->last_migrate_reason !=3D -1) {
> +	if (page_owner->last_migrate_reason !=3D MIGRATE_REASON_NONE) {
>  		ret +=3D scnprintf(kbuf + ret, count - ret,
>  			"Page has been migrated, last migrate reason: %s\n",
>  			migrate_reason_names[page_owner->last_migrate_reason]);
> @@ -667,7 +674,7 @@ void __dump_page_owner(const struct page *page)
>  		stack_depot_print(handle);
>  	}
> =20
> -	if (page_owner->last_migrate_reason !=3D -1)
> +	if (page_owner->last_migrate_reason !=3D MIGRATE_REASON_NONE)
>  		pr_alert("page has been migrated, last migrate reason: %s\n",
>  			migrate_reason_names[page_owner->last_migrate_reason]);
>  	page_ext_put(page_ext);
> @@ -826,7 +833,7 @@ static void init_pages_in_zone(struct zone *zone)
> =20
>  			/* Found early allocated page */
>  			__update_page_owner_handle(page, early_handle, 0, 0,
> -						   -1, local_clock(), current->pid,
> +						   MIGRATE_REASON_NONE, local_clock(), current->pid,
>  						   current->tgid, current->comm);
>  			count++;
>  ext_put_continue:




--=20
Best Regards,
Yan, Zi


