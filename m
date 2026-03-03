Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE621E67A70
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 06:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AC136B0088; Tue,  3 Mar 2026 01:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 057076B0089; Tue,  3 Mar 2026 01:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70B76B008A; Tue,  3 Mar 2026 01:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D64566B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:38:45 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82AF5BA686
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:38:45 +0000 (UTC)
X-FDA: 84503798610.27.FDBF171
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010011.outbound.protection.outlook.com [52.101.46.11])
	by imf01.hostedemail.com (Postfix) with ESMTP id B359F4000C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:38:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kAtipMwl;
	spf=pass (imf01.hostedemail.com: domain of pjaroszynski@nvidia.com designates 52.101.46.11 as permitted sender) smtp.mailfrom=pjaroszynski@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772519922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YBPk6eDzTBhM7ulfxDVm3TcPKNGl/d88q6gYotxeH/U=;
	b=v2YoZ+iA1A4uN7vb9UU2aCn8VtqumdMl+0kqW5YOkJMcUZzdj6JaNwfpfJIPnKiK6M96jZ
	cLSSWjQxeAh+nmfKN6eWDfaKdNWkISPhaFLLgQiiqOJoeJD1kHQWKf1qsw70iLZDqjf+13
	R7onwyfTPsRbHB2Jc0W/QnbkzvNFUOc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kAtipMwl;
	spf=pass (imf01.hostedemail.com: domain of pjaroszynski@nvidia.com designates 52.101.46.11 as permitted sender) smtp.mailfrom=pjaroszynski@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772519922; a=rsa-sha256;
	cv=pass;
	b=1rZiJZXYCoA2j+tAPq0Ca987wVGMG1TZeYLGGuQrQZdjsI0fHIOIwPOyvxY18Gi0/evdR3
	uAw4PdfPOGCVE7IrdUwP42DWQT0ax9SoPSUw0gDaCK87SoyOugrE6HFLM0rOkLEgeoNtig
	v/c3jyqGjfxphtW0yt+mhlFFRIZh+Jo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XpMqAb8ZNCNdy2/HVmV3Ks5Kr1GDXiFgQaFd0RzcmFqvQAsMOqVenKxXBePPuM+gF0AUzg54UiDEuFj06U9Of6ry4wtfbSdKEGEtcDdhusyajlXlGBf4GEnPAyqHQnwV+EVYkCvRJjBtzRuhXwan5bQQq6liRQBiQlmXnz7up+beomZQiCJNR3aGal9xWnysAlHm0de5WjJax6BN87UNKAP9HC+WtpEIiSAoSy6xr0GFTNtWLCZ63VHmNaN5iSdE1rTirk7eyVsTRhJu1dVCd0bFhUKKx4BBaXHIu/xpzNaJszYq+l6TpXluV1rtPN/mRlkWlFVGn9lPUwsjkWnvrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBPk6eDzTBhM7ulfxDVm3TcPKNGl/d88q6gYotxeH/U=;
 b=qZ6cbEmwtVM0XWcqzdOiM1ZCc28pJ1WwSm8mdpEDgSwg7kMduWn3FBAKf1XN7ssaVqzy2WoD1gVi/8tkn4vgAa0I69a3ye6Bz9PTXEZ8qcscjoZSVmpCCG68fACA97ZDUpVo2dHwIhq7H0IGNwYpUOJny0c8dNCPtzvMi0njRbrdiL8ZVR6Rv8usH6Vrfyk1LKmqXiAm55Xm/7NUGkaLTwpL8Vv0L3I0f6u5uGG+beBatF7rhIbyYIJkBMIrBsDMLY+VZwKhvq/bHIyjwBfyQUs87wo5JVOTw8TVwUwXd8V9yGmmEmDICndUJSwGUalkor9L+Cc6OETOp3zz50OM4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBPk6eDzTBhM7ulfxDVm3TcPKNGl/d88q6gYotxeH/U=;
 b=kAtipMwlcF15tZ40Rx4sqvwusTNCyx/CTaPLu5ppviyd3PYFjJYh3HkU7S/9zg1BkU5pOHm0K4K4NXNUqu0WNzx1lhlkOQDQtZ00Odd8vLTFJfdtymn1pjC0njkr7KhjBHz34/5W7gTnp02p0DdZuHMKZQCEmF5el6oI8i2ry4f7Gfd4vDGSxHVubTJ0uud+vJu7VyY/lni+w+EgvPT81vAqEozNNLZ1EWcmIfYpY+IQEVUse6urzZc7jVFR+L60bzRfccQadzWPYUET08rC0lnZBBhMlcq4LMCYQECZV84lovJasj+AL+wler2AOAyR6UiZzYYQUxQogL+ioOYavw==
Received: from DS0PR12MB6559.namprd12.prod.outlook.com (2603:10b6:8:d1::6) by
 IA1PR12MB8191.namprd12.prod.outlook.com (2603:10b6:208:3f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 06:38:37 +0000
Received: from DS0PR12MB6559.namprd12.prod.outlook.com
 ([fe80::3f99:f532:cf6b:ea46]) by DS0PR12MB6559.namprd12.prod.outlook.com
 ([fe80::3f99:f532:cf6b:ea46%4]) with mapi id 15.20.9654.020; Tue, 3 Mar 2026
 06:38:37 +0000
From: Piotr Jaroszynski <pjaroszynski@nvidia.com>
To: Ryan Roberts <ryan.roberts@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Cc: Piotr Jaroszynski <pjaroszynski@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Breno Leitao <leitao@debian.org>,
	stable@vger.kernel.org
Subject: [PATCH] arm64: contpte: fix set_access_flags() no-op check for SMMU/ATS faults
Date: Mon,  2 Mar 2026 22:37:51 -0800
Message-Id: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
X-Mailer: git-send-email 2.22.1.7.gac84d6e93c.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::29) To DS0PR12MB6559.namprd12.prod.outlook.com
 (2603:10b6:8:d1::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6559:EE_|IA1PR12MB8191:EE_
X-MS-Office365-Filtering-Correlation-Id: 341b95d6-72e7-4bcf-0e31-08de78ef7fe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	hRnq2L3Zv/So91JCmazmCFOFMfuXkLY6GiVs5bdthmfTAl2VjHqe4EzsJtPEyDBIwJWUnsxF//SobzpxkK6TvgMQukPTGDX/bUMBeqRug6FR94GuFw862TfXQ5859tGR3ynTC2bRJGY7CZXZ1da3x189iugRPCcvXSEDq8ISkTnJHfXQMqR7ixIXtrQwSI+FtDFUV2KYezhDMxJB0qCt+TzTZMX02/9VbGgWtzJZgjIQ9zMoX/YzHq5efdXYSe/zcu0CU5RC8Wy2Mdbnm73vK1zbjqvwh01uF/152nWGc+KKH+q9n6rLI/S4huUwiM4oeehDHcm3EoKOaq/w1wqdLt5UTmvXYKfdK8Vdr1uf/Rj9pkUniOFwHJqyEBf7D80jXZVX9kwSrxlEXr5+ibDyoX2lSYNr1+ux/CuckColV87CyJKkawYfpVWw3FNT1MSLjfiUvz8kl62Y6PzUL9ejU3VRZki7ucHmHXwzzYgpuBASkXX4XobMILwCPiDtxd55SjRsrhWESNdgZPZYHsgWfFECxdS1PG9yYhgqbGfmuk+WF3xEicxjx6wOpCYcI1zweaYkabyBmanoVfPs4PNg9QX2zJBh/CyRKNf6Fs+u/CdwlwUUCX3Mclx3GHdJ/DNP2/mZUe1kxD9EoVNRdYXknFXcF5rV5KjajlYqgMync8DKqBPS0UwL2hdcQko0K1sNy5x7thSGrBd3houwQq/KtpT01cov0ON47wfcuOwxxPg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6559.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JKGwG7P5aEPT5uDBFEwiwUN8LFUklBQ7SgJodYIQ9tMMHTyldBPHIacreKAY?=
 =?us-ascii?Q?6BEM+oAxZGkRCPHrDQjtkOqZVOeQtSqDB19vDIvkcV8Ndc3TNYZffsJquI8X?=
 =?us-ascii?Q?uCznrLF74Uc2HeHlh6UNyfu0mmhnw6B5M58kojam3rs+DPygXpHQ90lQ90sm?=
 =?us-ascii?Q?YK0gkLEcobqTJhNA3VEzFS+GqJcMdD+cVGwr0MBNJwwsskFOamPNZvBcr95v?=
 =?us-ascii?Q?YDFFtwKc3adKTmrSyxJK816s/W3NyDjdGN/isyak0o0tLoLVCzuU7I16U6Uc?=
 =?us-ascii?Q?rG0pd8HeqfSXJKxRzb7zpOww4udwIVp0S4QHNZhZxhlOjY5xIX8ImnRu7Mja?=
 =?us-ascii?Q?6Ql+HSxLsIN0gBudEr3dZVFz5TCq9TQsVd+z9fQflfLc4UKnKxI6KCQcghTH?=
 =?us-ascii?Q?l4s112nHWP4UEpVZdwjcVRKM4x8ZSBSaMR3d2bMOqkL1GEUrH5K6lFYVr/Y+?=
 =?us-ascii?Q?DxOq8ljEeJwi6Yz0HDQ+WinvlsMz3Ww+gaYgU1ZC8AvR55cJ0VwTzurCEv3+?=
 =?us-ascii?Q?G5+dMr43n1Xnvq+MBhEXTE2yTuShcZ+zu1FsNCXwblYnVqhFqtoRYYsqBqRF?=
 =?us-ascii?Q?Iga3l2PBQPJIx5AzfEBlyJ8ImyWJavE8EIHRQpueMKQRm7wDwaLDxgi815XF?=
 =?us-ascii?Q?yyyucdoF64sypz3Ds9DLmQtAg0AJ97w8t3a0Gew3heqGex93TDkhw2CpMuJn?=
 =?us-ascii?Q?BwtL/eIEnDjmorfreZRKhC/qbMJzt+/XIZ0PO1NoizSz2a4JYAJNmzs2DUjP?=
 =?us-ascii?Q?RYd2jO3JI0WiEmJ4g68Q/GzdWqFCAyUOLSZGbffEjYzdJEUaqaQhmy/oHb9P?=
 =?us-ascii?Q?hECnnRgrwsVBuSoX1RvqhhyDu7gT+nPzxzEDxPtKx1Y1XD4ygwPbcWOvVbRq?=
 =?us-ascii?Q?jx/Q935W7nFHDM1cDPWHeYCP+MfNbKA+T2HvrUlX5mLCVz8SUyK6RSOTuQmn?=
 =?us-ascii?Q?zG78UBrR6OyW2qmaf3B/22Isg6iH+Zb2WZUhHBJvt7+dJeZMIobSgU254Fq4?=
 =?us-ascii?Q?B3knqrJCCPhmGaO/nYeJAvTxzI1NSgyteX5qWvm/GWlRtbQweAAsPlfAWtC1?=
 =?us-ascii?Q?Wolaqd5q0ESyiqFf+EnLW8/GXrIVpDPOqR+y9VlxhnfOvgJsgmEALfiuL5Y4?=
 =?us-ascii?Q?vjSTx594sSAsA4lcV+SrhwZ367VKZf77my6D9hiA/E2u7u6S7UusQBO1XLIN?=
 =?us-ascii?Q?KOB1WOJJCfjP+92GPVhVcfEwp7uCMlWyQxrzDjttK50hdXtAKx0Hd1Bd8JIs?=
 =?us-ascii?Q?aO00IZNDC0Y6ZVES2bC/6JO+W5t0F6hbj2gOXDtvy8B2BuDx4yHWd+yzlb7s?=
 =?us-ascii?Q?s3CkFGgrmFAe+Pi/YSxSblzpPjTYTVH8FRdhgfMm8hiFPHySSfzIfAcGz8YG?=
 =?us-ascii?Q?TV9YEMrA5ntMMsm1dHipJxxEnEskPMM31UYpNSbL4bMFHgAgnf93JV3UeMcL?=
 =?us-ascii?Q?oALzCoWIGg/HPJH6obrfetdYYodAE+WZyOhol90y3ywCa4JuHkT2QF3mCTL5?=
 =?us-ascii?Q?qsdTdUa0b5rv67C9FwRUEFH1W/qa4zJ0U33Ajzc5LQGzRWCCdXdrsIREvHz6?=
 =?us-ascii?Q?K2WpjgQ8ZxvUGhq4ppYiomb6uFxHhHhOFoA6bAHOaybKm/RlfbJw8TzW8z8/?=
 =?us-ascii?Q?R8BudKdYO/NCdUkvZeDHxGa1VhjXaFX0v29h3wUwWSOcZUzSoJ0oonosq+c1?=
 =?us-ascii?Q?sYQGiLy7Pk+8Zr+FEbnZMxlFxTLPl5QVSOmzn4LyNHzdLCHWBndY8IWItVn/?=
 =?us-ascii?Q?HfCBTni+fgfHuGjRKNsqdAQFGkl1ycg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341b95d6-72e7-4bcf-0e31-08de78ef7fe1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6559.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 06:38:37.2411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wxDf6Q3rKApRsRRzvHVVahIfF7iF6XoWfmW9SGVQIIGFAT2pjnR3tznXXoAqYz9JxwN5WbPryJgaUZwgrgEcUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8191
X-Rspam-User: 
X-Rspamd-Queue-Id: B359F4000C
X-Rspamd-Server: rspam08
X-Stat-Signature: 98qdfo1dx3g6tkgftotpt1ca87rnnopo
X-HE-Tag: 1772519922-947048
X-HE-Meta: U2FsdGVkX18iBtYQkeuTu1g7I2mAwGEnhYLz+H7NN1MBPvVfCJBFs7VF4iKVE9E6g4PY6qNY4Bc+bE+vzC1sJF9E/qUmbZ34iELnbwl8ICcBSYdaD3N3Rube+d8RWJojux8C2dclLyV0gLyAwlg0vSvwaD9tdSKe6YEbHKcQ3GiXN07wZfI/6CFaNmpaQ6GMAu3U6tzH5l3T3JLl8ax3lsQD6+RgKOdar+qA5z0QFZ8f5Rhn8RhQ54fwk6S5KjCLlEkuMvz5eeZAMVQFj1+QJ4UuxapyOQqsvapxOGgkCoCY3WQaA42ffu89zuL7NT5iFWX8xj2yexkdj9/XONbLUFV7AeXJWTYSYfcqMHzeB/HeWQK7FK3ywgPPD/VMK51+9s8+ZBR+7M0cLi96Q5mHXZdqMx1rEhtJrt6k7o7G3Ptxj4qL+gErWSZaJX9wy7wVATlIpkQ/wkJoaY27RBpHLVRIWMwNhnETTD5J3s7dJwaaoSP8XQ3hrIK7p2AipD+b63X/xGItFssnJegNqLBqW2O/SwVy4AfKM/Vu7aG3eAiBhTNRd8Hp1EmT8LldVva2ncOnqpQzSmNNloc5VUPQMRk8xfos6q6el/wNMAb2l7ePQ8+UKvYM9X2fRJYgCA7HqRX2PFBi0L5BGL+JlVemtB1kb13C+C7iTpKVky0gf1ZgsSGeNdZt2cO+zjuc1Xpn7JhAMTvNnuyKI0DW3r0r7lo475fnRj3RirtzYgW0k+dS233B5VsDT+i13loqWy1vwAejokpY24RyO1456rMihdG7DFbwDHFNwAeMu8/eVp++JUcB57sUMsfwSnasSLdGJTui7hCcFfRpEW796ybGNlKL3o7GQHv6/Y82aQWxUS7eWJyGG6vSGdegVGGsKZ1AKS51K/Hvi/bf8tN+bJG5LzElsdB3wP6/vHdjQpJeJYDfp7vLYuMWC9gSCXOun6lCeVbUURoLDjfUiZpuG2d
 zkUvGwam
 wPWDMU/GSt04bIVy/8+Z74etFrkZSlgLKCbphLjwO6hQE2/922Ny6gsq4tnLsiHlRgo9lc8owXRfjwZjYUy3a43NgxlDh6cr1ZnDVrPwBvajAfmcmK2YWrcfxwJEGLa2VTw1kj6plv5RmmPYfH8eP254C15+nTflQn0FL5a3adJkUsnQIwkwDnLXnMQcCAwABuZ3H/zhtvEJm+Hk5NqTWxa8Db3DPuCLh2QT6hs8xW9YpwxKyLBbXQtlHgl7d8cOo6HqSHl808UjJhEyNU76MKHwehzWgA4dTOb8TqoCxSpb3bQzQ9l73QDKmHLVNZHFKV3uRWExjfgWUMcGVg3ZXlCSU6cPszfXM4U5IU8yAAlJVghakt4WL8RbzkbirVKiUKL+iywB9codKVBRCjy3TU9GWHmiyHvshw5PIUBAkEiGLwYXobH115+kaAFSX1s9cruFEZCGNA1Ju0YgluA8Zzeib9Ds4zMO9nd8A4ihAqpNHkpTOFNVYk6r+na2GrblTqkgq4HuTHD91l8Xy2K2FmLdQaR6wihB6iJ6I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

contpte_ptep_set_access_flags() compared the gathered ptep_get() value
against the requested entry to detect no-ops. ptep_get() ORs AF/dirty
from all sub-PTEs in the CONT block, so a dirty sibling can make the
target appear already-dirty. When the gathered value matches entry, the
function returns 0 even though the target sub-PTE still has PTE_RDONLY
set in hardware.

For CPU page-table walks this is benign: with FEAT_HAFDBS the hardware
may set AF/dirty on any sub-PTE and the CPU TLB treats the gathered
result as authoritative for the entire range. But an SMMU without HTTU
(or with HA/HD disabled in CD.TCR) evaluates each descriptor
individually and will keep raising F_PERMISSION on the unchanged target
sub-PTE, causing an infinite fault loop.

Gathering can therefore cause false no-ops when only a sibling has been
updated:
 - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
 - read faults:  target still lacks PTE_AF

Fix by checking all sub-PTEs' access flags individually (not via the
gathered view) before returning no-op, and use the raw target PTE for
the write-bit unfold decision. The access-flag mask matches the one
used by __ptep_set_access_flags().

Per Arm ARM (DDI 0487) D8.7.1 ("The Contiguous bit"), any sub-PTE in a CONT
range may become the effective cached translation and software must
maintain consistent attributes across the range.

Fixes: 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")

Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: stable@vger.kernel.org
Signed-off-by: Piotr Jaroszynski <pjaroszynski@nvidia.com>
---
 arch/arm64/mm/contpte.c | 47 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index bcac4f55f9c1..9868bfe4607c 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -390,6 +390,23 @@ void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
 
+static bool contpte_all_subptes_match_access_flags(pte_t *ptep, pte_t entry)
+{
+	pte_t *cont_ptep = contpte_align_down(ptep);
+	const pteval_t access_mask = PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY;
+	pteval_t entry_access = pte_val(entry) & access_mask;
+	int i;
+
+	for (i = 0; i < CONT_PTES; i++) {
+		pteval_t pte_access = pte_val(__ptep_get(cont_ptep + i)) & access_mask;
+
+		if (pte_access != entry_access)
+			return false;
+	}
+
+	return true;
+}
+
 int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep,
 					pte_t entry, int dirty)
@@ -399,13 +416,35 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 	int i;
 
 	/*
-	 * Gather the access/dirty bits for the contiguous range. If nothing has
-	 * changed, its a noop.
+	 * Check whether all sub-PTEs in the CONT block already have the
+	 * requested access flags, using raw per-PTE values rather than the
+	 * gathered ptep_get() view.
+	 *
+	 * ptep_get() gathers AF/dirty state across the whole CONT block,
+	 * which is correct for CPU TLB semantics: with FEAT_HAFDBS the
+	 * hardware may set AF/dirty on any sub-PTE and the CPU TLB treats
+	 * the gathered result as authoritative for the entire range. But an
+	 * SMMU without HTTU (or with HA/HD disabled in CD.TCR) evaluates
+	 * each descriptor individually and will keep faulting on the target
+	 * sub-PTE if its flags haven't actually been updated. Gathering can
+	 * therefore cause false no-ops when only a sibling has been updated:
+	 *  - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
+	 *  - read faults:  target still lacks PTE_AF
+	 *
+	 * Per Arm ARM (DDI 0487) D8.7.1, any sub-PTE in a CONT range may
+	 * become the effective cached translation, so all entries must have
+	 * consistent attributes. Check the full CONT block before returning
+	 * no-op, and when any sub-PTE mismatches, proceed to update the whole
+	 * range.
 	 */
-	orig_pte = pte_mknoncont(ptep_get(ptep));
-	if (pte_val(orig_pte) == pte_val(entry))
+	if (contpte_all_subptes_match_access_flags(ptep, entry))
 		return 0;
 
+	/*
+	 * Use raw target pte (not gathered) for write-bit unfold decision.
+	 */
+	orig_pte = pte_mknoncont(__ptep_get(ptep));
+
 	/*
 	 * We can fix up access/dirty bits without having to unfold the contig
 	 * range. But if the write bit is changing, we must unfold.
-- 
2.22.1.7.gac84d6e93c.dirty


