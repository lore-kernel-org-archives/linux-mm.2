Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF1DCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 16:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FF18E0007; Wed,  5 Nov 2025 11:10:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150DF8E0005; Wed,  5 Nov 2025 11:10:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018098E0007; Wed,  5 Nov 2025 11:10:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE4108E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:10:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9002512C242
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:10:35 +0000 (UTC)
X-FDA: 84077041230.19.4D626F2
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013017.outbound.protection.outlook.com [40.93.196.17])
	by imf02.hostedemail.com (Postfix) with ESMTP id A26638001A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:10:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Qlu3MKmh;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762359032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmi2QqaRWAjSi94ZWJgncWo1eNM7iNXXNC3dV8bMM0U=;
	b=kI8KTJjpXWTNqiVoCcZoldx1zUf4WiKttwekar5niEWsMbpV06n36iIiLcfxqWIBRDhJxQ
	BtZdighAnofFavs06B3XNokgR/XakBQGhmrnqCKUN9vBpdpymClMqeLNSBLxvE9wNAavXO
	ZBDg9AjvaW8pSm/EyFrOiHfTFa1yOqI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Qlu3MKmh;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762359032; a=rsa-sha256;
	cv=pass;
	b=Q3x79hs8rvE0+rMvzhUuj4yXdbkrYhaMosEFzfBwjVXPe+QVtUjim5scZUdCDA9wkerq1N
	6Pf67OyDwn33QnrM4BnB9YNKTl7Tcsfvc4XqPg/4GoLr3OdfMnHl6ybuHLbtQ7SdWgUig9
	MlxkNEti9Grp8FwZXatvZ/xANF7vzU0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=epnsrztolJYorTrYooEpBe0goQYutYddXFegWUutAxT2DgPYmFDNKgfrzsQWQvVJtmFMnsBeZ3U0cBTDpQtG978jLfvKpqDyqPCkTSs3XqJSuJxaevqtQG6Vk9MKGz7wL/c48YScjRGFkMHHml7UhZMZJLaoWO5wyZncsht6WTbY3HUu6/SPUFC4jRksh0GBX5beEOBpanxWWMMuNhcSB0a8bMfKMafSnIIOMu+26FSFih92TJTRozAlmCYQeR9BwlA2G84upas1nigwwi7bqxKuLG7bwH1lkxXT7qa4+NZhmn19tWHE29AAHrI/zTfzTGUbMw0fzGuD6N+gCOMViQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mmi2QqaRWAjSi94ZWJgncWo1eNM7iNXXNC3dV8bMM0U=;
 b=OKJPNz3bmo3v99XGQRkYq6mpcQgzue+ScCrzrmGnKi2xbFgOnxQsDtxpqayLdmnsxFu0U+YgTeIK9eDbhXfj7DAIUeAKPowXSzS9QKVdChCTaVYWWKE6ZWf+uuqpLKl5l286f6kUM9dWY9Qy+6YfeILeKKbos3GCy5c1BaQbUHB6lsGNH4sI03hP0vGwFdmktN/mH6+0Yc2coDKmQ2YshzstFavkW8xzQjJ7harWvU6GYhpSeV1twgFRhoufD+GEmpv4kZ7L0XWWgKew+BZ4J5Ig0auyAHeEYCHMPla8s2jXeDmb/i8bCY0HZN0CkN3caktA/8YtBuyLYpB+lyuIuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mmi2QqaRWAjSi94ZWJgncWo1eNM7iNXXNC3dV8bMM0U=;
 b=Qlu3MKmhZrDCoxP9XL31XNLHN9bFyO0pkyDz4pDlE94NTmqjP0adZwdD4OnKjLfpeYmfppjtqUbi9giJwlyzcZta6biT14/XFmBOoD9ITTsSWMRPlzAtkqhKdV78jyLvXEYVaARo5QXel4JyfXoKiDz8QqbfHbwynFOFg5G6sJmeg1BGRP6ncXndnWXN0mFifMu9dtWg/D9mW/g5R84TkRcTthRK7CBJmm+t9pfdmQnTsDSf/VEZVU1BEC7dZaJzOL4ITnNuB85prkTY/N+8sYt9ZyzGZpk6JWCjbwBIP5QSmcMRCZCNDr0QMIAibwXcnGuBvHUfihsVqAKau3eAKA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB6884.namprd12.prod.outlook.com (2603:10b6:510:1ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 16:10:27 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 16:10:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: akpm@linux-foundation.org, linmiaohe@huawei.com, david@redhat.com,
 jane.chu@oracle.com
Cc: kernel@pankajraghav.com, ziy@nvidia.com, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v5 3/3] mm/huge_memory: fix kernel-doc comments for
 folio_split() and related.
Date: Wed, 05 Nov 2025 11:10:24 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <040B38C0-23C6-4AEA-B069-69AE6DAA828B@nvidia.com>
In-Reply-To: <20251031162001.670503-4-ziy@nvidia.com>
References: <20251031162001.670503-1-ziy@nvidia.com>
 <20251031162001.670503-4-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR01CA0027.prod.exchangelabs.com (2603:10b6:208:10c::40)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB6884:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f11e9e0-3b56-4c97-c520-08de1c85d5b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?meA+hqSRaf/AWE71g45RcWekD0l/DDt4TshDbz5YkfsjAd5/yeWuX13ZJbV3?=
 =?us-ascii?Q?Iu1Ei2hX9VI7QzvasliBingtdMLq/9fZi7XuT2vN5baSa2IVrKNSVN+Zyy8u?=
 =?us-ascii?Q?if6Ynjw7b9DDtfRvAGxwM2ZbanlSijRAjj+SFPe8LbV3+SLTJCWfwcSklaxg?=
 =?us-ascii?Q?pdzYaKUkIs0jAJZsHTNA+Qu4yupdpMR5Zq6yVYcgoxHwu5+XfZ8C8c7ao/mQ?=
 =?us-ascii?Q?69dSIFulTOlrGFa0Vyh/B69O6065ecg+lE8GxMIOLYC4Y0mDl9V2xCEKTc0d?=
 =?us-ascii?Q?0Opng/fY+C9Uo+SRhnSY5vf0ljokui34rFkdsTg1pEY9WJOcMFkXE9UXd9en?=
 =?us-ascii?Q?oKEuB2Nycv9fG6FdzknhOLt3YtIernkMsDlPnGUg3OSpZC4jB8o5nwo0OyB9?=
 =?us-ascii?Q?3miTu9EGV+R0q/lbwgeVRk453GVayEBCtD1CO3V+uboVZJJzlG3qGZOg4TKP?=
 =?us-ascii?Q?dPVhIDFGWWXK2iJB60H3nvaUnXArV+ujIWfOdycKxfX8HFgpZT3/KVyHukjj?=
 =?us-ascii?Q?ce1iRqySmhl7xGdJIKx3yWkxgofYx8EnJmM3pg9XNymQbX3q768GE0vyb5+e?=
 =?us-ascii?Q?y2ZsPwR/8sNnCyeVav/5YZyTdHJBMWT9EgSt63cVOb0lH+N0pp4B/2aUtFGO?=
 =?us-ascii?Q?DcO5eokK0mRXmKtaIKx1BHBtoo87Vw/xrd8YMhLzhZa2jtoxQZTGy8WIE88l?=
 =?us-ascii?Q?EoJSgaMoZafHMzd/gaulowft8+1pANeOHBqzhHnjUW4dH+H0YrfA4xcpzX48?=
 =?us-ascii?Q?5OGrKdvpS81NyBY/3AED+sjWJmZod5xqn4JgH8CZc0Sir77Mij72I318aaF8?=
 =?us-ascii?Q?tu94olEhU+TmGayeCw+D2/WjZPRxkNmtOZG+IYz0xVpNY2FCHsJYxTdSKnHb?=
 =?us-ascii?Q?pnyRdWl6xE1MHG7qPx75JVRSizwo5XcHaPxNHclPpi3gh+/EYkTP+KWnuArc?=
 =?us-ascii?Q?swqTRpo7EYS4r0DqozEDl434fumhXeYdjYcfat1hlH5K1Oyp4lE33pjoSyFW?=
 =?us-ascii?Q?j+XLsCCSijVQc+rrSOvH6DfvI5fs2AVZdTOVEzSucKUHxRH3W9Yzfw1inUfk?=
 =?us-ascii?Q?x6aug4N9mEs+eTUKjEwnSxrmQXbx2YI5yK+KXwfcmdqyiyzHbqnOaTa27VGe?=
 =?us-ascii?Q?BTCKscaPefe2gLL+4I8tlFD7IIUakdg0v9jkwL7IkdmgUOSX+LwsQSTo3yOy?=
 =?us-ascii?Q?VTUTYg/BwKM2K1l/ShdZhHC1qDwz78yKYcdK/WwCKC3NvR99EIqlt9ggXW8C?=
 =?us-ascii?Q?7GQ3ygxno7da5cUeGhPOeZlm8I9Eoq4RzRNeJtgNbhg+Jbo7CvD7kcfhIhoG?=
 =?us-ascii?Q?AdGAW8WmhLj07vUEVnlAgTWA6VPxGCnN7JU1n2C/vACxWFCs/+isfgWDH+Hb?=
 =?us-ascii?Q?nRbGxIQ06CR+YMKYsCR0vv8hKgQVwUcAKpof5qqAUPujYZye/bQegxSyfsnf?=
 =?us-ascii?Q?sC/ZVMjjYTJks6udCd8S+qftzmmfp0VIEVv2qCboOwv0ZTosDvEcUw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C4KbW9AMnw/fQoYlNx8ND7xVn3K8nYEBYRjXs+HBTpUQHjQitaOc8gluKwn+?=
 =?us-ascii?Q?7R/7jfqfOOKNNqf/EwqObaAGkFRCJN4mbyLl6xfADuobOvjIZulcrTF6U7Tj?=
 =?us-ascii?Q?XNVyBWeoB9AyACUm7gqWxAzNcnHHPd0jJtJVRLkbP4QClMWlkjVtDeROGl/I?=
 =?us-ascii?Q?1gXn+NfycGxLo0ZSwUAQtz5FmUH4uvX4grBFAFhrR71ymjPhmIGdsfcqMiRE?=
 =?us-ascii?Q?7kXeXWAbahnB2ekqEoe+yGxz7SypyUpYPu9Y9KUgkONr7ofUfKsT8v4zsK0m?=
 =?us-ascii?Q?2FkPIT9FDkEdt37NincegQWjs7LXwohFYdv+BhyItrUSQft0qAyGN+Mo2+8u?=
 =?us-ascii?Q?89LjlvKG7FESGe4kS9COMbDjbwc4/cVRsaiF798V2aNJsHqqkGhGN/NqacWJ?=
 =?us-ascii?Q?JVyZKC4IW+wWLmbruHi3t/HGJh0F+WaZCad9bpB6R9NSro7X6pILp4jod0Iw?=
 =?us-ascii?Q?XaS5WrsOkaeKYqKocD2gpDnMLexc9hll/HLiPL9Lba6Eppn94dka9GgS4fm6?=
 =?us-ascii?Q?m9w/4lGIy8wi9FUlABV33/dFLv2glk9PiXtX2tWYJFfa0qp3E4OrBq8wKOzB?=
 =?us-ascii?Q?+k1TTmggt/HOBJhdTnJJ9WstF8n86k5EK6D6U5EIDCIZ41gWbOvTglLIIJTG?=
 =?us-ascii?Q?1nYwunvwioSpO4stJeLGtgUKnafA2CVCc83ZGiiZKPsYWYFe4TRTO3d/mL1D?=
 =?us-ascii?Q?N4EeVtZXkYOSJ26klR1MbQn4eYDUPQHm9mFt7KjPVgVcfiBVkt6I6wg64o2b?=
 =?us-ascii?Q?DOnxDV3OnOV34x/JoVb0wiRXgBk5kG7UVlqv3z/a7iwj0wf351ex/prZrt4Q?=
 =?us-ascii?Q?T0+inSG0NeRExbJB5Mizuy1x329AzhIWRfK5MfT0ByZLIFk695tAlvnXgYlq?=
 =?us-ascii?Q?4p2kN8T83ODe0P31laGZNpVQPKgLLPEC9SwHeUAa36nrG50s0YN5kHm+9yip?=
 =?us-ascii?Q?FSWYTcy1Z3azu9Ummy0mS+VSAIU4ZvMCts7A124OOaTCx9KeGGvr7QqYguQy?=
 =?us-ascii?Q?vGALZxH3bdRcNp+9Nc7XSglBwqT8ymZoHp0eniC3RRa6Yg9WUTG+TlVvd7Jb?=
 =?us-ascii?Q?qRVFn13ASPSBI5pV4/cNMgeO5KQ1fg4yKuO8sXaYyUawHn0ZRAQqk8ybvoCA?=
 =?us-ascii?Q?7np81XI92bgAAqblMSlbc3uczUJ4X3LkmdcJqp84VwKc4EUtpgRhaee5zCsU?=
 =?us-ascii?Q?sorAXfaCPjju4xoCA0XJ1DvJVKDt8I+bsUAmEamj1/kNN4S+tTwLpcEgsyV/?=
 =?us-ascii?Q?weZVPLdeEQjwjuKK1fIKMZ6qs8sunPH5vKROLAt4h7622ZJU5JxONPea6KRe?=
 =?us-ascii?Q?lJD1FHeQ2wUyXqvG1u2bXVeVpoHi1X4nCDWiMi0BNtfGIeJYlXSSdrdKeI2+?=
 =?us-ascii?Q?XQ5prot/AAktF+PJITPIAhEJbz++sVl/HFyWTVx7v41AVooLVZgswEZrLcB2?=
 =?us-ascii?Q?eBLpiV40YVQlTGHZNRtEpMbIRuQQEC/pMBLwYY2GP2JuC3NkayiGfSceDyaz?=
 =?us-ascii?Q?O5EAkYQCjLuaYtZWnPGkeLwnUKYUwgCCqLlEC2qrL6dPUZH9Z+DFC5iCly7y?=
 =?us-ascii?Q?8IHXvRbdRQqnYBi0g3lD4176lxtwVEmLh7AoQ7wY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f11e9e0-3b56-4c97-c520-08de1c85d5b6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 16:10:27.6381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nG7ksS1VT6oh2rVWiDic8qQ4GduLBQPIi+H2/19/PV1BjZH4n6QKbbHJ+ZxwM3PH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6884
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A26638001A
X-Stat-Signature: y11gar9ay4c5hsassrruzbthkudpaake
X-Rspam-User: 
X-HE-Tag: 1762359032-180678
X-HE-Meta: U2FsdGVkX1+3IV95Z3EvSt4FoKgMVYcUjEzHGZL/yJWzCD+OazR8+qslMOOwGPtelBKJM0D3QtxyasX2W0FDbRGA0anSZyUIlq3qbD/6IbcTuI6hNq7XB4caVWEobK04iAsKfT57Jlc+M76KNfygqTLRoQREAtoJ7wfsnq7tenY5rKR1xVkNdyW2yNfSyidTZAmanRxoq9iRDYZf3UZlsFzcZaamENCf335eZcaMYdbH4R0Qf0qCs8uost3ijgy9CZq70MIL256nIBD4Uo4RXKmNOJaCmBSUaRaYN/rp0hlOBoDkKnIG9U6Ue3x0hdQw9qXdhvTkqaJzTh3QiUVWFk81IwwSt5JREiiFMrQhAQjSAPAD326ObEGoe+iapvSYIU8XxE7zGiIc8vlpxQYRuRx9YqGg+y3gu9lvpfJUNkXhXL9FK2x2+Qb4IufCoQY+EUysE2vIN4EAf1nlGtCIkemt2gzSxXZZPY+51zKCDgLWfJ4B0KexaAl2t6HWztQh9SrOKffd/ztAw8FACUvVCL5heKs58tgfoEZ20sGOqYMUMXm+vCDKmmZm/W63nNAlEN2mHX8pJgXdSM9tjQxN9o6zjcVgpZgJCChcCsJ3Lo1ckdu2d+Gy0h4irU8gDNM31gOUphB9ywNtE9lP6/mCK40jcm2dLX4jLzKdjbgQWgS3Viul7/ePkeWT/bNL22RjUZzR99JRqcYxTjBhymqmrFJBSoLa5pqi/ZuRqgNVxfHowGL+w6YhmLczlV0qA/6Df7+y8I6BLx33km7AhZQYaqj22tSULUiRdQV1UnqCpm5vyDSs0jWiPvFwFuVGgj2rMAxkkVQxmvRCi4hL15+MSdB9KOmsRJ0s96r1ClF8NiGWTzhvPWmYUggn+3lUchLoLnxaMVglRJ3c5lJVaOYvQP19adn8wxEf0Ls3vCvYHi7ciOM3lps2Ci9nQQzPuVT6MG3JeLIsOKUk9ZI+ETH
 Blc3AuUo
 S5OmPXlelRzfxoz1+eV2RsaMZtXg0gbKHkjMoD5HSx0VjNSqhNayLZRKeh+8xYDcxy2GSaSg3E4zh+m7LH6/R8hZDwKgDOkiEEEwjN1ZyccHEBGcgLpkoX6Ihm7VwYPwoTnfHU9kDxqvrA08zPukykWDcdCF7uHUFaZ45lfJPJePqdbg0QWlf3LsP55CtofM6nzVBXrtqEZtyAjc4Zvmr8jKy78izCjm6hF6cBrnnLbPLotihk3njGuLIwbYt0H4ym32N/GeSL5/0hNAHIbdag3cIpsyjWbQ18pUb5YYRr9EplK7uwrFH3hJ0V2KrMxqd9/at9OX4sXwQXYlj38m4osx39tayx8xbG6DS2t9p3L0pvxB/Zkp1U2rYS8FKhCpM5XSrKO0trwmW+PD3LxvUrAnXZZXAaisN0jlEUCtBG8f9ZjeV3tqLNbpa1RVv73oVwj5qLKuj6JoStLaghS84zCa/HP7/9ISFnFQ40lS55Q6ULB/Y6ZoXS5+o1XIQZ2yR8bpOtaLQGFY3HjPWXToEnGM1k5AY02mR2GPAw8+RClVXSg5uUhysZmFcGbY8VB2+K1dyC1VYP4zoB1WeA73Ig+Gquw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31 Oct 2025, at 12:20, Zi Yan wrote:

> try_folio_split_to_order(), folio_split, __folio_split(), and
> __split_unmapped_folio() do not have correct kernel-doc comment format.=

> Fix them.
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  include/linux/huge_mm.h | 10 +++++----
>  mm/huge_memory.c        | 45 ++++++++++++++++++++++-------------------=

>  2 files changed, 30 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 34f8d8453bf3..cbb2243f8e56 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -386,9 +386,9 @@ static inline int split_huge_page_to_order(struct p=
age *page, unsigned int new_o
>  	return split_huge_page_to_list_to_order(page, NULL, new_order);
>  }
>
> -/*
> - * try_folio_split_to_order - try to split a @folio at @page to @new_o=
rder using
> - * non uniform split.
> +/**
> + * try_folio_split_to_order() - try to split a @folio at @page to @new=
_order
> + * using non uniform split.
>   * @folio: folio to be split
>   * @page: split to @new_order at the given page
>   * @new_order: the target split order
> @@ -398,7 +398,7 @@ static inline int split_huge_page_to_order(struct p=
age *page, unsigned int new_o
>   * folios are put back to LRU list. Use min_order_for_split() to get t=
he lower
>   * bound of @new_order.
>   *
> - * Return: 0: split is successful, otherwise split failed.
> + * Return: 0 - split is successful, otherwise split failed.
>   */
>  static inline int try_folio_split_to_order(struct folio *folio,
>  		struct page *page, unsigned int new_order)
> @@ -486,6 +486,8 @@ static inline spinlock_t *pud_trans_huge_lock(pud_t=
 *pud,
>  /**
>   * folio_test_pmd_mappable - Can we map this folio with a PMD?
>   * @folio: The folio to test
> + *
> + * Return: true - @folio can be mapped, false - @folio cannot be mappe=
d.
>   */
>  static inline bool folio_test_pmd_mappable(struct folio *folio)
>  {
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0e24bb7e90d0..ad2fc52651a6 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3567,8 +3567,9 @@ static void __split_folio_to_order(struct folio *=
folio, int old_order,
>  		ClearPageCompound(&folio->page);
>  }
>
> -/*
> - * It splits an unmapped @folio to lower order smaller folios in two w=
ays.
> +/**
> + * __split_unmapped_folio() - splits an unmapped @folio to lower order=
 folios in
> + * two ways: uniform split or non-uniform split.
>   * @folio: the to-be-split folio
>   * @new_order: the smallest order of the after split folios (since bud=
dy
>   *             allocator like split generates folios with orders from =
@folio's
> @@ -3589,22 +3590,22 @@ static void __split_folio_to_order(struct folio=
 *folio, int old_order,
>   *    uniform_split is false.
>   *
>   * The high level flow for these two methods are:
> - * 1. uniform split: a single __split_folio_to_order() is called to sp=
lit the
> - *    @folio into @new_order, then we traverse all the resulting folio=
s one by
> - *    one in PFN ascending order and perform stats, unfreeze, adding t=
o list,
> - *    and file mapping index operations.
> - * 2. non-uniform split: in general, folio_order - @new_order calls to=

> - *    __split_folio_to_order() are made in a for loop to split the @fo=
lio
> - *    to one lower order at a time. The resulting small folios are pro=
cessed
> - *    like what is done during the traversal in 1, except the one cont=
aining
> - *    @page, which is split in next for loop.
> + * 1. uniform split: @xas is split with no expectation of failure and =
a single
> + *    __split_folio_to_order() is called to split the @folio into @new=
_order
> + *    along with stats update.
> + * 2. non-uniform split: folio_order - @new_order calls to
> + *    __split_folio_to_order() are expected to be made in a for loop t=
o split
> + *    the @folio to one lower order at a time. The folio containing @p=
age is
> + *    split in each iteration. @xas is split into half in each iterati=
on and
> + *    can fail. A failed @xas split leaves split folios as is without =
merging
> + *    them back.
>   *

This change caused an error and a warning from docutils[1].
The following patch fixed the issue.

Hi Andrew,

Do you mind folding this in? This fixup can just go after[2]. And both
can be folded into this patch.

Thanks.


=46rom c49e940cc23e051e3f4faf0bca002a05bb6b0dc1 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Wed, 5 Nov 2025 11:01:09 -0500
Subject: [PATCH] mm/huge_memory: fix an error and a warning from docutils=


Add a newline to fix the following error and warning:

Documentation/core-api/mm-api:134: mm/huge_memory.c:3593: ERROR: Unexpect=
ed indentation. [docutils]
Documentation/core-api/mm-api:134: mm/huge_memory.c:3595: WARNING: Block =
quote ends without a blank line; unexpected unindent. [docutils]

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a30fee2001b5..36fc4ff002c9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3590,6 +3590,7 @@ static void __split_folio_to_order(struct folio *fo=
lio, int old_order,
  *    uniform_split is false.
  *
  * The high level flow for these two methods are:
+ *
  * 1. uniform split: @xas is split with no expectation of failure and a =
single
  *    __split_folio_to_order() is called to split the @folio into @new_o=
rder
  *    along with stats update.
-- =

2.51.0





[1] https://lore.kernel.org/all/20251105162314.004e2764@canb.auug.org.au/=

[2] https://lore.kernel.org/all/BE7AC5F3-9E64-4923-861D-C2C4E0CB91EB@nvid=
ia.com/

Best Regards,
Yan, Zi

