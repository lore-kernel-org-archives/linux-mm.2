Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6CBA106ACCD
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 17:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA196B0089; Thu, 12 Mar 2026 13:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A78F6B008C; Thu, 12 Mar 2026 13:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251AE6B0092; Thu, 12 Mar 2026 13:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 126F36B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:37:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B15CB1A01E3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:37:13 +0000 (UTC)
X-FDA: 84538117146.01.FE6DA61
Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010060.outbound.protection.outlook.com [52.101.229.60])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1679A20016
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:37:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=ErPMHrjN;
	spf=pass (imf13.hostedemail.com: domain of tommaso.merciai.xr@bp.renesas.com designates 52.101.229.60 as permitted sender) smtp.mailfrom=tommaso.merciai.xr@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773337031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BliYxgVY6B3AIBn4vPtH1U6EXkU8HcWqlntrM80Aiug=;
	b=hCf2Qz065sMkKscQtjF6qOrsyRrWwvl5PVruMturbBtxbu9vYGxsEuEW8bXZMweFy8Dp7B
	tXKFb1CmSQUSwM17KO10mt2uyCevhPI3h+uwSII2AXRetwKiL+DurWKBOoByfyay6N2L8w
	xWLlU2gzNRVIQHHDI9Oo3syb7zVQck0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=ErPMHrjN;
	spf=pass (imf13.hostedemail.com: domain of tommaso.merciai.xr@bp.renesas.com designates 52.101.229.60 as permitted sender) smtp.mailfrom=tommaso.merciai.xr@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773337031; a=rsa-sha256;
	cv=pass;
	b=Lg49AFL9Ml84mPXS4pAkX7wRI1NNjZ3zTeVlgBaEU/glFa3t3Ioz9u887rjqOtMH2cnI4B
	uW4h3lg3AbhW89cqKXGKUuxQb9sq2LFCKU2OiRw8RiEF9n32R29pSvFG//L49QV3cHsFZf
	x4XXwRdhEKE9owizRyBENr/xeMxbpcI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vkkQ+JI5yvnj0/OQ19FhevkGmAkrQLgPOvUB2IPlSaddHbFcsdeua5ymHl7NfK+5nlvZI9qAuALqnYwj62u6VlmpbVU6FlymdyktbwrhbwxFdHxoJRzfPtm53xisDOiR1nb1wpPjprCS9q0QvqeGa6EvGy4738xSIm/7/u+Y3jKuBaFGzc9TsJc2I5hlOvr51wWpJrARUv5TWzjWNi0CPHzS+nx2mwmTGy0dbjfT+ZBJWcvGd3x5gAVHgjKkjHdHwh62Mla40ZtWXmIXSSorH2TQdSPtNT0GkwIU87N3f+gb6fzQX1hKTm9c7BvTcdTVuhk1hsWqVI0FQvqShpkvMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BliYxgVY6B3AIBn4vPtH1U6EXkU8HcWqlntrM80Aiug=;
 b=LQEQmIW0Yxo8KPC75q6gy1DELGjOx7Us7aO9PjK3QgoTGUrR+ty7ZAupnIKBFOUgnLGVuICkiNdS1c+FriEq8NWzemX25vO6a8raTzE6U1tIKd18QKpXPAgzCY8MZKiDfu3qwuqFu8/4VPvdYMZIt2N5zi1+xESHe31oajGV3xHoBPg18OX8ixuE7WZU+5sGkfpt17/I2Ijnix9uqufImjmGpNd4st03rLvpqaiNBZ9PRXYOYKgv7kbYsg1l/LIX5nRyFyp0q3xaAGz82V/HRyfHkUYDt/U3VbmJJm5PDK1Rd0Yif+d6N9M3XJAMoSbh4cNE0js662mL4uGPzlUTJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BliYxgVY6B3AIBn4vPtH1U6EXkU8HcWqlntrM80Aiug=;
 b=ErPMHrjNF59o4nYivxiIYGDPYQSMv/HOvOSs7k6e6//q0M/ZKNS0JOV7G2l2YgAtM5g8xkPbPuIWdOiILUKmVgsq5hzGewK0FdlXB+R6Fs5tW9rpPC8Huzb0BgRS5AjuvDkFUSc879/JoJj1IYuRG5wbWgbm9B3SV2jw77VORfw=
Received: from TYCPR01MB11947.jpnprd01.prod.outlook.com (2603:1096:400:3e1::6)
 by TYCPR01MB9571.jpnprd01.prod.outlook.com (2603:1096:400:197::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Thu, 12 Mar
 2026 17:37:03 +0000
Received: from TYCPR01MB11947.jpnprd01.prod.outlook.com
 ([fe80::33f1:f7cd:46be:e4d8]) by TYCPR01MB11947.jpnprd01.prod.outlook.com
 ([fe80::33f1:f7cd:46be:e4d8%5]) with mapi id 15.20.9700.015; Thu, 12 Mar 2026
 17:36:57 +0000
Date: Thu, 12 Mar 2026 18:36:45 +0100
From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: boris.brezillon@collabora.com, loic.molinari@collabora.com,
	willy@infradead.org, frank.binns@imgtec.com, matt.coster@imgtec.com,
	maarten.lankhorst@linux.intel.com, mripard@kernel.org,
	airlied@gmail.com, simona@ffwll.ch, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, biju.das.jz@bp.renesas.com
Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Message-ID: <abL5rcYIaFFO3GW2@tom-desktop>
References: <20260227114509.165572-1-tzimmermann@suse.de>
 <20260227114509.165572-6-tzimmermann@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227114509.165572-6-tzimmermann@suse.de>
X-ClientProxiedBy: FR2P281CA0104.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::11) To TYCPR01MB11947.jpnprd01.prod.outlook.com
 (2603:1096:400:3e1::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCPR01MB11947:EE_|TYCPR01MB9571:EE_
X-MS-Office365-Filtering-Correlation-Id: 272a2e72-4c84-4395-55e1-08de805df5ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|52116014|18002099003|56012099003|22082099003|7053199007|38350700014;
X-Microsoft-Antispam-Message-Info:
	hWQYKo+A110NBubvgQrD91OT4ANvL9Yri2IuDwR4lHDyfqqHn5LK7bCf06umh9KAdgXtouGv1HrQDwyF2wEAB4gRghOolODK/2gmqo7lgrf6UUH/NsJEnTHQlC96VPX6GuWPvV+LiV4A0H1kbFs91YrDDAK07IdkujKt2IasJqBBJhc2n8YAcAZqmr2ZUXEo8VmQOoJStCbxF1lfvrYajCQF0NbmbErZ1J9MtXcS1+FIt32JSxD1yowh5cLB1yXzv85G9tFbKo3hbetv+cFALAlPC+XdR8P2UaHBq53GpxqY0zAib+0ce6RCUlJ0tDzn/k4kqOHPOKYuZXysEt4/hAH3AhxeGC3gYsWW7N3WKbs/P4dSyiprVsJsevue6zmpJiKjak2uOUzBPz2qNQ3hGWB6msBR5kfvBZbc3asbvH9JO1AkUQ4d9VqG+DdTvms3XwVhIU9C5I5zfaYuxnbuKfEo6HHbSKUqlMD249af2BP+7Ua+Y5NhuIfj5jnerpVrfinRRV4riMkA/eCO+D62o9CnWKWNbPViauvVu2k6x2Z6Cli0TxAgLafNpA4m5nkCC+EgvcF407cGZITbsfv839fkcNp3xxSsd7aNfLiKv+zOVxM1SPEwpmD0bLzUl22BzO70eVcq6gBtlOOZSlYlEG5MDFgbBRdHM5Vzzq+QPzsy8EBFnkCK7JODNT9Wt8AlVu4Tzk2tkRIdKlTrdTPTUrM0+ip7sqCBBLrLcBvH8ir370DHUmzK2baUe/fXoUv6TbLpepVrnq8wxqmKCoco9ZL7+dthxTyte/wQwFqlCXA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB11947.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(52116014)(18002099003)(56012099003)(22082099003)(7053199007)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YuX9eZRLpdzl+x6T3xHEjaR8x3yciuyH9J7sQpRX2JJywxVgf5VJxx3GA5bk?=
 =?us-ascii?Q?MhtzqaTyXKof0MtxzCQQEAk3CFoe2PU4HG+yELdpxokuQ2IJ9+2NB14D68f8?=
 =?us-ascii?Q?fR6sGT6/bAC5iAjkBOix1WKzwpwGq4tgPYFroX/GXYA7jMj3bZzdqPiy64KB?=
 =?us-ascii?Q?hwB6QRSQOOZKwABbpR2VW3/+VjHWs9G4Abmf5v7niE58zdWNDR7GUWCcDIaG?=
 =?us-ascii?Q?XFURntwC6KCIHy9ZOZEXvXAt5Jn2hguAF2jezRCTt1shJ0RbSkgcPqsCEl7o?=
 =?us-ascii?Q?BjiVsQ6ru/t4BaMlhnQ7j89EcMg278A5UNlRo1OOn6HFIKWQ84pzCLdEfgCn?=
 =?us-ascii?Q?rdFKW/0vqOPNAzt1Jc9iIJdgattgFPfsyuqRU02ncmH2ZubdFm3A0jMvyHmb?=
 =?us-ascii?Q?9Qrm2PQM9x/E3MNExDSXTX3n2c0vA+i+ll0r5Hw4ZeFyk33j9xF73rWQOQP1?=
 =?us-ascii?Q?a7gxi6KNiD0p6F1ASr9Opti6sOoQJ9K1Nwesd6dhEgiFprMun9Rt13Yh+Ms4?=
 =?us-ascii?Q?p3TrLEgw3sAWyfvuhOxb0u6b7YiAlKEpJ4GUMI00FKpGYWXNN7+UB1s7gdOm?=
 =?us-ascii?Q?968WWun38PnTPzv0CBDT92umIQUSX/aZpOkI9XRGmCae/kUjXnAVzSgFI+ku?=
 =?us-ascii?Q?TmHWzKjgfIfpWHPKMqCSFdfGjf5pE9CHL1xclaZAlIZUrp42+L2HFMdZhm6y?=
 =?us-ascii?Q?oQUQQ0mjczpzW7nHc7Bc57cIdyYoFFV6RZp7AfKlzQci+BQjmiUYpRhjTyBq?=
 =?us-ascii?Q?6engjkB0U4E0FdxKLV8d0Q7H/bgqlF7Xd1X7lRrNSWYv7iGRqa9SZjyvJTCn?=
 =?us-ascii?Q?bLVqU8dX08d5xoKvuiCwddVKl2y15EDnsTKY3vFdWODiKZbSk6wOlSMYjdPp?=
 =?us-ascii?Q?/+zgfTX6FmBXeDAidYn/sAJtDix6L+l2TCZPGJGR+ycMCfTy9yXYVxgPYUv7?=
 =?us-ascii?Q?XP1W2ga2ctSBEf26rHRb5muTe3NpeSZY+cWUjd9WYf/V3YFUw7RWVqK1sY3u?=
 =?us-ascii?Q?/aB41XjCFxfuNyovR1hfumE3HwELP8p1xeWUZkTZFdPGFEDLW5iJ62qMaSpx?=
 =?us-ascii?Q?F2piojkMca6QtFqqagVZEpvlmx9qVWhs6x5JxydILdx9R0+FLcphEhGAYraa?=
 =?us-ascii?Q?JV6oRtWvFdhwkKe7KCAduhMBsVeRUYI8ROHhtJKmcNkAlNuT8a1S25mvqfa9?=
 =?us-ascii?Q?vErwZ5gT0UDNyT6yiBRZkgNoNJd6nyjEfupMrdjw4phsTGw402zgtXUnfAeZ?=
 =?us-ascii?Q?MBaQ4TmvAz762S6b/wMJC8pPIbmHbeNjkC0YQRnSSL7vT1twq5P0q/DI+DlC?=
 =?us-ascii?Q?o+nWY9RBvIgzOfX5xEvTc60c8XRR2QwoLu0cq508/M3S3ZAnBw9SXGc++/Ni?=
 =?us-ascii?Q?JdRg+7C1goi4CMz7YlqZmXuen/FJ4w79BOaoYr7GSo9eDe01m1MWpKxAeLe+?=
 =?us-ascii?Q?MTX452DXOmSy9Zt6ZvmDpQPRERJnRwbbtZ4630aZVDsYtwXjCVNPopHK1LjE?=
 =?us-ascii?Q?SvozEM72a1Oc8uGgg+TYAjpuNa0hQz4w5fXvNW8PbHRNKwl7Et3ar7yWc3Yx?=
 =?us-ascii?Q?CCenYEModsnKyGDuE717qFcf91FIb+Ghq6RFvqNmYhNyXRUEdDWOVR+qBIhv?=
 =?us-ascii?Q?oW8zX1HY6a63P1TPRJK66EK57bon38ax906k6b+YhaYdgNEqLzl+QDY4v0Lo?=
 =?us-ascii?Q?rKuJ/dgEbq2QpQmUQFHBTbmVTluo6MAxktbc8N7/zg7nAlgDPChnGLtRUN7h?=
 =?us-ascii?Q?/SftISmNk9+tC0AiqoORXUoRuZOjySfHy3iGqeHERbOwXk8lznkf?=
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 272a2e72-4c84-4395-55e1-08de805df5ac
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB11947.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 17:36:57.8988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /pw0BLBlNhFL9m6Ny1RgCCD50Tuqsf2YaFMTX4lUPDYztNewtQLAk+i2u/Vs34wvfIfkgEoSfC90U4JIeQ8DjjuCNK907VnhuiYKaa0z4gc9vHnh+jj4UYEHNseTy7t/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB9571
X-Rspamd-Queue-Id: 1679A20016
X-Stat-Signature: oiyre3decuf477e8p9odsrhx6c7qgq5q
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773337029-134902
X-HE-Meta: U2FsdGVkX1/glfvKvHLZW+3WFXc8uCf/NUpjFP6lsJ9Y9RVAD14A8nL57VAy5d66ZUL4RT3TdO3RC30BStxTaJ8EskyrZ0F9bv1zQrGfl0KE7LcloFFOqyqjiNA2t/itDWawZcCctuIMIjKS31Y3C5qKA3yXs44iwInhyzjK8Xyg/Ur83M11uvkHJmeBnHuQVyKr5US2t6207aSrU9Us0yIiVSEwIBKLi1o//0NGHcskEj/OGDf9PMpyjo6ZNmF7l+db3WytRy97DS6ZAM0zvQX4NKrgkHoUKQF5hTc53UvpFGpOtv2FHz5ONvY/5WXToSTHV3lhaE2DgG2vCglFswrC10cCn3lTDAwVUHamkVFrglWSh6TozMPP7SOE8cfuQAsVA+yCDm7SGIsTYbf9TvKlQL2we06ItToO62aZ62wqZPt6z1aCixBAcN60h7R8ketBMjHm2WN74IyZMTCf5zTCDjCV1q9wRNq7CGryr89J1xuGjYgkor3OCzlSmyrp5kmHuGJE91rFClVSuPSmEZggF16OQFgzcDxD3iIq1OBKAn/5YVVLc7VXm4IRDeDGKFdJkz5+pjcApuaZpJhiPXniO0+DR4cpbs2PYw/zJhwpPPvwso9SQA7ciAVrz/TLlsVM7AVWo78LlYmqa5z8PUEspnVCly/WhX/sQCGRnLPM87syDEkLjGBgCrp3CUU0i0jph2ufmPEDjWx4ZGpUq6xvklGk8Bzupr8dshIurgG+EB/noX4YserS00HB0y5HDHCFEvBfXcL8f6rD5SQxDrVNiZEf7JBn5dsyjbWdpGeelNLsztF5l3sSA0/d/Q5yNHTgHRDgIH2yVHGUoVtRYUTar2yPQkZzHd5eC+nObIRzHbd+njohs5r72VJE/rzxZUv5Dcx0lTzGFXCunL/HJhIYxo0m5fSZWMXAc909zCCBcvSWrrk46cXAtXgUH9xEahkvBUJN8E9Uv+bskFC
 rFIYuQ8P
 4Kftczj4fInRAVBBgH2bJmihkw9NXankADW2zKeca/wo8eQf3ZO2DfXzn87JuWYdy7nYZHxNzG2VPFLiHKDkR2qR0e89FHSGSJZGOA7ya+eov2vbglviFcNFBKyuAYSvXhGpur+BkHiTp7P5Wn8RDolXc3IHs4bjBhSpexHseaNZNSHCTwDxcod47GgxOE9Li1hz4XSqMv7kjcu7icw3XA6m2+MpInF5z6Jvb/XUUfUXvKO3k8mS6fl1edl1CA3y1ftB3Ro5tpt7G3UUirTrBeQbG6UWuv59NhOslaUVVRH+X97wYfSHJxySABUgjTxp0Cp+qSfviGK2r7SwYR1yHN2kCKUWXwudjuddkOIMm4aSj6/OvF7SmdLuJyBjpp7qXtL67U2wFUA5mT/OFk5JfAy8CwUE4xtBBrxBfx4il6r19n9hgj0JFojDRwpaHtY9q2mNB6lq941snR3QzxC1YYCEPeZqt4v3Ym+Gr9l5jwC0cDO/uW1FMOHbR+syBt/ZcwrtK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thomas,
Thanks for your patch.

I'm working on DSI support for RZ/G3E from this morning rebasing on
top of next-20260311 I'm seeing that weston hang on my side:

Reverting this patch fix the issue.
(git revert 28e3918179aa)

I'm wondering if anyone encountered this issue?
Thanks in advance.

Kind Regards,
Tommaso

On Fri, Feb 27, 2026 at 12:42:10PM +0100, Thomas Zimmermann wrote:
> Invoke folio_mark_accessed() in mmap page faults to add the folio to
> the memory manager's LRU list. Userspace invokes mmap to get the memory
> for software rendering. Compositors do the same when creating the final
> on-screen image, so keeping the pages in LRU makes sense. Avoids paging
> out graphics buffers when under memory pressure.
> 
> In pfn_mkwrite, further invoke the folio_mark_dirty() to add the folio
> for writeback should the underlying file be paged out from system memory.
> This rarely happens in practice, yet it would corrupt the buffer content.
> 
> This has little effect on a system's hardware-accelerated rendering, which
> only mmaps for an initial setup of textures, meshes, shaders, etc.
> 
> v4:
> - test for VM_FAULT_NOPAGE before marking folio as accessed (Boris)
> - test page-array bounds in mkwrite handler (Boris)
> v3:
> - rewrite for VM_PFNMAP
> v2:
> - adapt to changes in drm_gem_shmem_try_mmap_pmd()
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index cefa50eaf7a4..1ab2bbd3860c 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  	if (ret != VM_FAULT_NOPAGE)
>  		ret = vmf_insert_pfn(vma, vmf->address, pfn);
>  
> +	if (ret == VM_FAULT_NOPAGE)
> +		folio_mark_accessed(folio);
> +
>  out:
>  	dma_resv_unlock(obj->resv);
>  
> @@ -638,10 +641,29 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
>  	drm_gem_vm_close(vma);
>  }
>  
> +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct drm_gem_object *obj = vma->vm_private_data;
> +	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> +	loff_t num_pages = obj->size >> PAGE_SHIFT;
> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
> +
> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> +		return VM_FAULT_SIGBUS;
> +
> +	file_update_time(vma->vm_file);
> +
> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> +
> +	return 0;
> +}
> +
>  const struct vm_operations_struct drm_gem_shmem_vm_ops = {
>  	.fault = drm_gem_shmem_fault,
>  	.open = drm_gem_shmem_vm_open,
>  	.close = drm_gem_shmem_vm_close,
> +	.pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>  };
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
>  
> -- 
> 2.52.0
> 

