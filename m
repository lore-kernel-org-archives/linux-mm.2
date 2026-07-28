Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052CBC53209
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 01:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C376B007B; Mon, 27 Jul 2026 21:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE4E6B0088; Mon, 27 Jul 2026 21:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E9E6B008A; Mon, 27 Jul 2026 21:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 478D06B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:30:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C00D080267
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:30:55 +0000 (UTC)
X-FDA: 85036456470.27.354EE1A
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010029.outbound.protection.outlook.com [52.101.61.29])
	by imf22.hostedemail.com (Postfix) with ESMTP id F13CEC0002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:30:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fF2IoPyy;
	spf=pass (imf22.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.61.29 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785202253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pz2NCHhPvo4PPr7k5d3nZp0iEfE5ZaYBjgNSeDVG4eg=;
	b=lykhWn0e+11WcFQEsiky4EnnipYMKqGh+P9Ztx4VAx0RM32qL8UNUlO5AQ7o7ImuZUTSz6
	0jp0Td7Nf4PLhvU258JpqKtWnnTb2N3NDUrY5x308iNf53+JINftw7TK5+xtcBDnnCPZpz
	uc8E3qKovxO9R3Vi/rj3z0nE/U6bhXw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785202253;
	b=q07dtFEac0QaRcqurXYdxu3uO/LYasl0PFn5g4JW+o8aRHQHJkamcE1TA2ZJm7PFQM+7jj
	ULZDQ3ATs9xE+EsOXzvkSQ/hwsHFihlDW5tiI4bSoKLDgVdV6gVmhpoeuKjrTS548/0CPK
	srsUDBFPYBio0fpQcdrS4h0NaQ1NTro=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fF2IoPyy;
	spf=pass (imf22.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.61.29 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TTm0PWNnO42pn7VJBV0fHeKtQOfpfXRykMvWSVWzx7M4tYqFX4IqRNpMSOvjTGjnkZsRiZd/jdXEU2XZOB/vf0nUt47PctOuMW16axajgryDiljr8HfhiMar4GxNRFmLCOC8xoTB50OIgnahtKfxSqo1Vrz4VEoLG5bJKGffkoq4xIszTncpweyNjPTW6xkSxzx0MVEGclRDhN2iLEvqIEXDE1JKLmTPIuNv7DMbnO1L0lEstTNAgc9lv+s4N2sH7skB4CvTBGs/S0SkFVhCNglk2WImKXY41RTz+yw11JHkKftrpVCsHfZ85EZgWzHb1DAiaZyhlNV3lVk9gUa1tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pz2NCHhPvo4PPr7k5d3nZp0iEfE5ZaYBjgNSeDVG4eg=;
 b=HsY3OCM1z1gIMFFmr/irwNcM5H6wr8wOFn3clrTy1kngQ9rYi2BEqBhKI317Y/eFEiEeE5bpFAWWaGXwPgojfhlIqtIq3k4M+O073PEeFpYjH//BDbZzpOcgI0Lx9mZ8JnAytMbRmlviN+LwzzvAT+Ir64hQShYvmoKzAL89z/tSJ4igM2aQJPFUvpo3C9ZHhZ0Hz3XRXAuEeBUF51JDQux11FOt0M7ah8HwjMUtjgkOtKutnNBlTLaXmtpHVfRas1dSu5at/CH3Np9PI73ovP7cLga8YXesdXq6aWgjrWMIQy76/ZCo+CuwA4Q/95l8iWxNEmIR4+OyTg0BI76+5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pz2NCHhPvo4PPr7k5d3nZp0iEfE5ZaYBjgNSeDVG4eg=;
 b=fF2IoPyyyuwRjZklZ07LEUuVX2OdzOH7LNDfXOIOn/brrWd1hwaZt8kyyZ+xhqNmA0h9KaLU1h6Cu2TkMeHq/3TZrh74pH2d4p4y29b9lRAv0G3TUnfkNVuS3L6gJdY5Sa3dHhQI1jVMCmqc3Va2YmAM/SVR3f4bJT9ZmDzgQ57Tx0JXsYqW1UnZvYEyL412rmMSMg4NfDDGpwrMoFExOMr/9LHgRQoarnYMM3jSMXgiHpSSVAOitDzkMEZqyVcOglQ5URTNQ4lezxsHmVnaChmwamTTvjvhbS+FzpmI7nvYOZYI/rIqUotkSVTZ9Z9WyS1/cDXP+yi2tbVpePAacw==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by MW6PR12MB8897.namprd12.prod.outlook.com (2603:10b6:303:24a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 01:30:49 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 01:30:49 +0000
Date: Mon, 27 Jul 2026 21:30:46 -0400
From: Yury Norov <ynorov@nvidia.com>
To: "Li,Rongqing" <lirongqing@baidu.com>
Cc: Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: =?utf-8?B?562U5aSNOiBbPz8/P10gUmU6IFtQ?=
 =?utf-8?Q?ATCH_v2=5D_nodemask=3A_reduc?= =?utf-8?Q?e?= bitmap width to
 nr_node_ids in __nodemask_pr_numnodes()
Message-ID: <amgF8r2CByFAKSXV@yury>
References: <20260713075104.2196-1-lirongqing@baidu.com>
 <alY1Rm7n8DmEzqAd@yury>
 <91008c9df2984342af5dc887ae13939f@baidu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91008c9df2984342af5dc887ae13939f@baidu.com>
X-ClientProxiedBy: SJ0PR03CA0274.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::9) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|MW6PR12MB8897:EE_
X-MS-Office365-Filtering-Correlation-Id: 429659a7-c00b-404d-b42f-08deec47daed
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|4143699003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	nV1fE/rHq3U/nyRi+NANxw5IqxbN2CK9++4MJKWZa8ZlllVBccj4xgXRMudRdlvVbTnpsmd/Blo9AToDHmMS+LNIFWYRQ80MflPakRLpNdLnWXwJn76eAI6MH6hUWBf3kXEE3f80J7mlKbqFfTRy5XFfQym0pHR2GMWD8mh2oQpeao2ssskg77vbTWapSqwYiqJdwq5e5znD3bfvFZPbFJexFOQQWAMwQzNomm/nJ8K1qXNwU2zirCB6XeBVyrYIoyVSQrU6S2MP9MDsuIGhgqvq53nLOZny2/I7g7d6SpKdeG8em100yzFXiCOWfNDRWTxHkCatNG3suV8YpOyxHmZWwyUBvYZ7UpaShNPOd+RD5h3RSPVR1yrnkT/sKqcWH8+TCCFtJDRKwRPozOsGHhWzKOB2Fi13vHYAO1n5g3jz/0abkPRtsX2/8SQueFZTl3BAht0itKFRq0dLb82ffofCdaOxMZZVbTjO5tE5Mm+XkquAgxKmr+FK1cQGhttjRYAM0a7SPNqSpARm/m/fyqhSmqFzNHfXeZ7EQ8QUK3bcA01u/yEETbShExEFW6mdWgkWa9dbytSRMe/TZDlDJqeAbZ4e4AeLOyPsa/pKq20JOkY0xZvkF2mVuLdJpX65zyrbXFT5XzyBIYxDvbp/9l8mGaQzuCRvC9zAbde5ocM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oKPQZqImKRZX99F1Wadg/FshsJtW65qV4aF5ReIOJOB6O1xjZXchWdjOBtSy?=
 =?us-ascii?Q?ZmfXs3DQo82ABzqJhnpac9WvfbdflD3nW7o7Q1sdOaYVIFbbLRwp9EkKCMwD?=
 =?us-ascii?Q?IRGVjL3988b/wiu6/QM8yne2anXjuPtAaqdXr4VZs3HRn4qlgKsteDzBB5ua?=
 =?us-ascii?Q?Q4FxUvBcP3x00bCztCGZ7VpYEcnorcHHJcQ69gc+wDxK0ZslSmQCgnE8cyUB?=
 =?us-ascii?Q?ybCbpZiU1yHoJL9Gr6nWydo1eHYFB365mAwwruEn3x+LgQYOSxkG/xvlbYl7?=
 =?us-ascii?Q?sZGVOmReV4eNZ38o+TeZngUZNwjs43MCVL489ACmH5J+wLZiP2D65uHtpo6m?=
 =?us-ascii?Q?sgKyPPQyKUTZGF2KShg+p28sO0PoLaNkTBiKlg86eVRmX91Z+mZ3lPNJndt6?=
 =?us-ascii?Q?bUkl6T1rNQDXRa/Rw+1aZiDmlcqbwHLxRIpkYurm7OJCXISV3XUe5hKrWOGe?=
 =?us-ascii?Q?R3OoLMaqUGmni4SWvo6cFQ9XVuRlmoNnigVlXKbmcffR7QrS+SfsqO6vsmO6?=
 =?us-ascii?Q?fnVhNQYrgo8jYfvf1SttXMwcIrcBK/IfXOvhJ2RiNAuMqyUpMXm916YxQK7R?=
 =?us-ascii?Q?uFG7qgfKgQ1E65lHIVSWprew79MGygFE5IBGXmbHtj1l03m/9tylpz4LupT+?=
 =?us-ascii?Q?IT/8MJHYxRFUh71gVqjwlxcZ+P5QpuSatxYrIOnDEQxl3VrapHuVWZitxITb?=
 =?us-ascii?Q?uPD+D1iQWjVH0qGjmJWfQxHvmbvo15kKiqcKwnskyfwWb75JvU0jyoL65F+w?=
 =?us-ascii?Q?Gdvx/+gOJVLNPijHBeCpV4SG5w6uloXCbTTw0evKat8Z58+lSuhkERBpySdv?=
 =?us-ascii?Q?ES2UpAgPLZku/nx/yQygQsZ10JaCHByTbDiLLz7N/GnKsx2wWZi6eRhcL3w3?=
 =?us-ascii?Q?iGoTq9TtSGNYjS3A/mA253Bg2U1rYHfWUF+fDJK4J6cshL2KxspcOUXd4QKl?=
 =?us-ascii?Q?Td+m0CMRF21KsX66oN3Mb9tnmwQbss59LZImEZoOKoOoDfpwbUsbt6zzyAhr?=
 =?us-ascii?Q?kCJGLZbUfu5RoQdHE/PXyMyTtlVrbFussKJXM61kwZoBC5Y8t27Jh16qkLqn?=
 =?us-ascii?Q?iFiqmJPJoTDKB6BMISF8lMQY1+bFL5xY+qdNPPVIhnMUoYlbS25BtHBi0gB1?=
 =?us-ascii?Q?PrmI4FCZ3wXbwHdzSHzIpJQbROql77l4ES4zsSuitKenqBJ2ujmlWzdF3muX?=
 =?us-ascii?Q?VNvuP4AH7PyyY72E6G1ciTbYz+2aZ68vWsqWsoOmfsmHLCSkCpzIhT5X1KZG?=
 =?us-ascii?Q?VcfiXkMIo9h/Zr2AcqW0D1IA5iXF90h08v/CY7JnP2iIV1NG/1msVh/kuPx0?=
 =?us-ascii?Q?ngEjj1iTO9KznukB5RiunB01/Nbt6mNuzhLfoTt+8CUhwHybzuD9NgP6IAuR?=
 =?us-ascii?Q?0+1PPhve/F0+bZojP+WqkG++WqUt449qbkZVDvgZ1ciTlcehhAwC1XNQJt5Y?=
 =?us-ascii?Q?1wuDhghhovjce8ZRD9L0HlmaPIzdOyzrjt2sDbtlr/ZR6ldsvTVdOu6udet8?=
 =?us-ascii?Q?522fb4Di2KGYzn0G/yQmnP92Q+8TPecb5AY2hy3coQEVzy3Z1JuIAo76HeIV?=
 =?us-ascii?Q?MKvI3+OdAoPv3Pe1GYjZxwDwHPy0WrUEtshzYoFw02NBRKmlVWr0urBgioYo?=
 =?us-ascii?Q?aCco3n3QSOxA4sQUfdG80cnkJX70hMElDCh7EH4JCpHq03KFhzj2dKzyiX9E?=
 =?us-ascii?Q?OhOkIANNQritZZURKlrPNzP/JV11w6+BYc+OSl+59UA2zOWrFALmgcebb8jq?=
 =?us-ascii?Q?HAAgb4GWPg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429659a7-c00b-404d-b42f-08deec47daed
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 01:30:49.4473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LmhZwD/hbCSo8cI5TQn2BpfsFiiPOa2pFTUzG0ivUwH9mijp3VsCRBftv/3W2U5/jl7SJEMuEVkJ3VkalOwcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8897
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F13CEC0002
X-Stat-Signature: ohhp1ehnfxdi49gsun3bz7rach1w1kwu
X-Rspam-User: 
X-HE-Tag: 1785202252-738827
X-HE-Meta: U2FsdGVkX18Pdi5vn+3+bi9iD1zA/6ZEtKopdWu3vl7OjskI9mBIYCOgJEeZgeBFxx7rRL9v30+OVS+zyvXywuVVCPjl/WOwuEc18H5OX5qixiEWzqYN7rB27UpY/pesLluNSPjK/C/lmdOi1hcTrY4U5q5ZEuKu+dsgSdwULz3ZZWerQYi4CJIkCPNN4TUVqnv/kEsYBxUZF4vNk/6IBzTi4zIHWX6J6AxidQxVwkW86Jq663xtCfrE+VJBuvaTxzYeHw0r81Y5x/hv9UQb3d228v8lWZLRiFAOwE3iWw1MKi0esPXk36HTOleNzMy8mHuI2hKNfKwwTajPMiOmTBRPtlE0Ko5xqY/OiHmW7Lq794xhikOl8zcPLC7GFS0uiDaJqVRVgbvLWF67TnqXhAdTo0HrgYQuunxlsZtd0vAugBxpWR3jYVRmkAWbvOBymYxWP+AKZofsBpUMjJOu65m3Cha4AUYuIQkdjfVGCpiN7cjuyZk65fSShKY8PRtOmc0jm4wKtFMO7EaJQZ+BDdeyoPdYGbggDBQA/vaQY+FXQB7pJn+Yxchrx2k+42ctinsAwfk0HeAZgnxpc863/cGtancl8OlC2BBIiLruB9kzSLI4OIfEsqpMv0yg2id3em8/Yld6O3wSGWjAIcoaoow3nkvgJhBIiidWXxceRSeHE7rShOqlfGQUa733v/hZpw1R3s6CicN8QqqYby5T1FxIO/gmP7d0fKI2QBAj2tajfjgGmW8xs4FXcr0aumgwux8dYJcJvR3fTklZj6xgu8NrpcEyGUkoFaOm9lG1F55RKytVpXnnYImy0DDh8TqqQfZ/4DfqHIP+W/ux5LW5nXVjzh+mKpfNYSpRRwkWIhsjSrQ10NmHtYL0St8Hy8H5eiSKHNcOLo7bDcxBZ/aCAhd4ibJXlO034IV5P/TDGJBEWW42pH8ySUHCiTxwzRdO5hRDs/QxMT7nlYHrihe
 kHkym1aU
 977tKM6NwwKS7JdZBR2iPNJo/BHaa7cncLMStVyv7zmcsAylxsX3zPUNCoNA02ZwMQyvr4QhgmgQ729treAcJmsXDuzO02WdNWpBktXA4l3AFr6aPWsfcc6j1A629IBPX8drFrmoH66OqP5L3eToV8SUUW7zjAOWyVxebYphJm2aum5smTEVZzpjdx0cKkUllDU0PXdTv82d6VhL9RQeanFmIBLpmQhpJrqaIoqd5I4slk4cHtLtFi6/vUV6+GxoOTcdwZOSbF9U2tDwAikaKaltx8TRAy2DZszMvyrLXVhLz7Y2qOT0OuV1l78zbtrTkmFD7u3XH3mrEelgxnDYZFsNXWiVj1tCpEF6Ppg6KR03WgrMvRGKS//PFM3VAjkH7cT94kq4ZPur0g4tLLG3bhMBvPWM6VVj5YVjgV0u2tZCYgD3Uot2GLSLgrHRErprP+t5yWRBLPvhgxXUv//gh04gQEiiyu4spJiicrripmJIAGrvfVm7NYYy5tZhrPTkIx9mCd9N2lgErtcbyKejVuvLxbvKCPiHzspR3ETeGtkW9k7y7XxlAw+3nOItE9ezLl88GbCQ+wyDYKB1wGj/Rd+/6MqKxAnquxJQpY8VgMzFsM4QaHMfMud+PB49KuXB2AfmX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 11:56:35AM +0000, Li,Rongqing wrote:
> Hi Yury Norov:
> 
> Gentle ping on this change. It has been under testing for about two weeks since your last comment. Have there been any user reports or other concerns?

It's in -next and scheduled for 7.2.

Thanks,
Yury

