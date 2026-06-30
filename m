Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C52DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 23:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937736B00A8; Tue, 30 Jun 2026 19:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7B36B00A9; Tue, 30 Jun 2026 19:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D7576B00AB; Tue, 30 Jun 2026 19:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53DA76B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:41:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3756C07DF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:41:12 +0000 (UTC)
X-FDA: 84938202384.20.A363BF3
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010070.outbound.protection.outlook.com [52.101.46.70])
	by imf04.hostedemail.com (Postfix) with ESMTP id 084FF40007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:41:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VjiawcRC;
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.70 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782862870;
	b=LyhT/Qcu0iEBr/R+5+l391AljojUGrUFkw3CbEkvGC+QUqkqvUcBxLcxT4bwTHtEdaHHHS
	vqgMAaN/zRnCRuf2wWGRyTx9ukDnyp80Hul79owneY5ceAzoEBnkQ5rcPnq7Ad0c+Ghpoe
	O5BnOPcmQV6+J4oZnDwBYZoYrf9wG8Y=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782862870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/M6yhDtURXnLuXObcNA4ARLpYCGFBPoCIFYmUF5w2o=;
	b=NxeJ7AuAwLYOot7m2tq8bzEIWN/FBCEZXwKujIrCFu2+fdDEnPUYV1LBPwcfnB+6+/aMsd
	N92RKzGUEcy7LuBJZcQL9rNT2gka9wxOo9/C8eoFozPKZTGS1mrASR7QNkSH1r/5kNkfXB
	JIts+NLH3gz+ja89V7dx8+IyJtxwndY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VjiawcRC;
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.70 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ng4Aoo+hdre1YSlIIjdqEsToTFsXFtdq+B+OR/WCI1tGZgum0DXEvgFrce2la9oLYgwKIiIGWonhtOxGCJ3axjDVRtBTg3A3VoxZaXtRoyk5zuwds5noqV9PS+JdVSRUEXbkEogLJjppAHEM3jYGlgMO89WzjmtigrE2fKQLEGDBi0xwU/f1l+DIDFob+NrfVKD5FAol7s1OaicOIqoLqB24uaqNfq9bFHWGvKj0rEl6Tm4NFoeW0KPABrfRj8GxdBMy/sXvSu5JWmCXUhU1/36UNNU51ta5cCn3i5FgMMii8UP2eeOnHYMB0KBhyMy/vUJul2eYO4FR5KiNEYmr4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/M6yhDtURXnLuXObcNA4ARLpYCGFBPoCIFYmUF5w2o=;
 b=GFX2Pa2arzCcY5NbPBHCNygghOIVp+K0brhbR1lok+StZTwPnlsF5/ztIikROl7TMg1QakqZbNXyiigp+H3K+PuKBXrC3Fm9PQ/iyruoyjZGg+gN+oVLsFBo3jxddTWZ+lE86E1Xg0vP3WME60341ZOJXeMHMbtKuUCCeno2yLt9zSUkTN+QIdmBhwkGDtY+EaHmQiZxwiKVm8oZPs720lTLZuynP/lhr7Q/URlJSTGZIU2r7A51t5h+c99YeP2NPNiqXZCcjp5Xnd/2FU/0+OwKjfI6A6TBDaP60LcZZcAPvZMpXa6SPtVM7/XLRL1w11FA80hPQ5prq2rzpaLMwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/M6yhDtURXnLuXObcNA4ARLpYCGFBPoCIFYmUF5w2o=;
 b=VjiawcRCMNFu+ZKjcfc4glFPWshBq64rtpU7LJUK58G5lQWjLu2oNzpwzx782Zlw75flq9D586zDcCCknEfRMtnxUU5uhOp2XU+NynTjUJOjj85Y5+wM9QwvvB+AG8Wha5V5qJMA1bQyacpemdqIPsEPDJWu5Kodm8jCgbCsDBZ5C81/vU2r85EvA3DRiqWluOPBs5BJORXgejcXlluBTgWUSc7BeFOt2Hw7HKVovey19bSEAmjoaJf2xXXLjb/liBmZ+MmQ98tu9J0EIfpUXdYZXZ8vzmR6o20wHHZjGjIWr6vzi0jJfAm+MAjv64+E2NKgt65ixTGR8VqlQlUvrw==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by SJ0PR12MB7068.namprd12.prod.outlook.com (2603:10b6:a03:4ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 23:41:05 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0181.008; Tue, 30 Jun 2026
 23:41:05 +0000
Date: Wed, 1 Jul 2026 09:40:58 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Neha Gholkar <nehagholkar@gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <akOqYZm8sjMd4iNg@parvat>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629163337.1264881-1-hannes@cmpxchg.org>
X-ClientProxiedBy: ME3P282CA0027.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:f0::14) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|SJ0PR12MB7068:EE_
X-MS-Office365-Filtering-Correlation-Id: bfb046af-e644-44cd-304e-08ded7010bf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	xTn/1NZmAqDM5Ypr1iEN4OsRSrd64nAb4+cW0HEu4a17zHye8s4NPAVTAG+QmVQt6xL9ZfQHF8F+JkezG9PiBYapByNCPXUeV7t7Aw86BPT7xnUCXhdXuSbhuwqcA++Bdz/n61OpitIY+oSzr4LXC4qJ69/igqJ7+fCcVIVbVtNXhDi7vB5ILejXOsIZDa150Ms4nUX9aTmRMIcJ06h52J3hPEWWccFTqj8/Y95DpWihHykN7trJfWXMa6JhoB5ruOQ+lrhxZsAwmWTTctS31l+lhY9G+M7RVkIRZwKnzR4BHXEli69YGV4TDQNsfoe13oMDiNDCZSjDeBkknVNCdwuCAWHaAUTPMN2Lo2idwGXdojeOPam3JB71p81cNZWZAfx4+d67w7zBVTjHfIeDXN7wAo2pWjlt+gv0QCUYB07xKdsobMDCdVpu6EfU2pePTnL4RoMynMqEpyFS/RZZNEsVAL3tFs8BO/HhWjAkngr4dDmdJkdm9zXLWI7UhRfk+uoDUmJKuNdr69taKkkgNmorOOwEAdOt4e/v3zhOy7mgOiTCgNB4FcfLpANRw1rHlEICrAyGulCGbRdW7ngPtRdiEPNPA5vYSVanWcmn814+U/4ZeVMrVktVkTBO+Nukt0c4uX5iMPV15Tr2S8zboK3U39luY2pCPLev3xelMFk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q9OQug6Dgy9nuyTQBsMgDvkJv6iej2ITWUNcQUKKb/OWyfbAu2diuOg95/Ee?=
 =?us-ascii?Q?tEElMRprKQs4MdDtlCOjIySyNEMK8w/ANz4bmv24FosFVuutgqZehZWii6TR?=
 =?us-ascii?Q?eNH2fCjdLpyqWF6K8wYaUdhoY3sZqbdbvQYZFmdTfapP3CzXsl0oarNWyV2o?=
 =?us-ascii?Q?pS1l8e2g/kT2vIDlmKkkyh1Xb5b819lWhgWJaJawpIcOlPUQgd3W1/GVqRhX?=
 =?us-ascii?Q?8CbGN3d0vTr31j3MTpZ7OvkniaKxBMAwwAxDmusD5g50HNUThYTpsR8dMotd?=
 =?us-ascii?Q?QyX0mcClbdQbcv9pCBal6oM8HAFvn09WsdQ//VH+0dGksQv/sucoZbXI/xEt?=
 =?us-ascii?Q?o0zjb6X5XI4oB5HtCLkyzHsIDAhg/jGOlwNDTLBHQevgQ+UyJbLwMKtVueLm?=
 =?us-ascii?Q?mHx/+zupofgGc2k1D0eHTMDrhfvGUBnp8+HODsdQ19HAuOZ/tFkyAfB01gAK?=
 =?us-ascii?Q?L4mkHOAuiUZY7TiTkrNSxW0ewIeyNXZp9xKV6dAx5eVXIjeViCzTwi0OWqpT?=
 =?us-ascii?Q?dr9KNrFuD7MrM5menzElBw/L344/7y/kVP6SUS8RHzeJD7L0TOQkgcdWRd2/?=
 =?us-ascii?Q?PWPwwBgf1WlaUGBt43ozJSKHmerV7rdT/dOjluXJuhkzEwJDHEX/FOcWstAu?=
 =?us-ascii?Q?pUfxpCnbG88qaxo/CMH6mUQf0/cd13wEqZxPrMDmnLzGYiTIfU0sHqymZWKm?=
 =?us-ascii?Q?gvz6s8Q07XsSFZS3ekS+9sXmutwZ5eWZNVskFpA/nJWXpet7pKsnIG/HulvQ?=
 =?us-ascii?Q?6eQ4PfKZIUY1+cOFSwiw8V0BI5Sc3K55iMZ5Ss9gH4vu7j0f8Dw0O8M0bj+0?=
 =?us-ascii?Q?JayP959hmnqC7R9DkqenrQD3DXPWRru0OlNaM8v6/eQ+313LDC3iQZX0BDr/?=
 =?us-ascii?Q?XpD0d6G+6N/2oCyYOvfHr5iCCfXNf9YI4icqquKIvC3H/3c7Mm8r2VDqi+Rf?=
 =?us-ascii?Q?pWThNpueave57ASQld8XMd9xU9/aTBGGLTk4mn2J5k2UXVYg/aHoDsipXDkd?=
 =?us-ascii?Q?Ub1MEuaAJeVSZWmEq1sYia3wHkglzBLCheErvwgaxlI4DQ4UOQ2lJMYJl1ak?=
 =?us-ascii?Q?zMDrL+U9D1rnR/0nfpBi3FC/60AQdEuGZm9gaaUgh+IKPCs7oeWNiMCii2kR?=
 =?us-ascii?Q?LfKST89eKVIK/SKbbE1zR6QML1zjYA4Zb6svWWsiUXhBZOW4JtIX0n2fIR3/?=
 =?us-ascii?Q?KXDobvzzE5mghC1P95hmSdLAEcLXw8vsx+dBB9702RVG5nflu8fGKrJMt6+O?=
 =?us-ascii?Q?42BnxXUyVpm1CfYn+tVIqQq5O6S76LiD+pnXn6//FEEZ8OzCH9sjuFfNzVFb?=
 =?us-ascii?Q?JMuPoM+aiyqfpjmw2sRNAWsgdT4/54hwSTaT6Z9X8BT5K2aWlqG4lycfO5ZV?=
 =?us-ascii?Q?8gc2sFWnpm8ufLI2xkfbNpYXKxWuZ1lXWlrXsYbOsi/0Vm39aGno1fsOHS1q?=
 =?us-ascii?Q?okQZBJ3cJqlxoSV3tNMBUpsxYKvFuqPgeMYfyAZL7IctnwPu9S32OnaHgwal?=
 =?us-ascii?Q?IHf9ovCMTVKLa/8j+UEYcsJFDgFREeyyEMb/m3hJKWrxB0v1DeTNfxZe+PIu?=
 =?us-ascii?Q?ED3MNJsYU5OFa5V9pQLpcBsS6uK0sqqmjus22MYP2H6GNJHvvbrA4eyC16WK?=
 =?us-ascii?Q?7zLy+FKcMymON++jRheerNiVV/57GXwSf7RKbd08cY9xER6nUTglwFh5CDh4?=
 =?us-ascii?Q?Uyexk+etDZBJMLPmj+c7puAdW4fjJ813HdPKXfTmGWihA3e4HNdou4YlymgE?=
 =?us-ascii?Q?HsYc4+3yzw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfb046af-e644-44cd-304e-08ded7010bf9
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 23:41:05.0336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SFBQlLQSuZ8R9TNmsv7LYax5PqM+CRAF/XHpHT2vsmyVdnLTDICaG2ezbHYK/Aj7iPkG0bd+nuwQgHrN++wk8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7068
X-Rspam-User: 
X-Stat-Signature: jk97ejmscn7c4eb6c9op6a8qt8uf5mgm
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 084FF40007
X-HE-Tag: 1782862869-872398
X-HE-Meta: U2FsdGVkX1/c0+a3Am0oWeL7vhS5cPgipM96Nb5VoLDC5wQmzY/krTEvcw+lSpQ8Xu3u+PtvdGMInz7zwn7uxYwcV9UeIpVMweSdcD95tjCzkpeWqj0SblZDoopjWDs7t5LHMYDJ9mDC4T0VoftpynPyrz4HWu3HIPqzWXQtjFKSPx5MFcAbDcHV12Sc22mxqS0CYzml8jYI006mAG/QF5glSCZEGAApEp7YHVs9olJlRS61XbT8sALZKZ+myiturBAK124Y/Ru+YGclU19XTwXGPSthco3og6jTUdTBejThHi5qrGZ9vsMl0nNkwqDEi7Ttow21SDSrks7ZusV7N50n/A4g30gL9jluqTwoKWMFvTx/JtuNqyO0KDVFE5ckzL5YL09cEseysNllpZVro2a8shs5aG+nh3Kt/7fIhu6w1TcEAEl7t0K0eGYN342mYGWIWfWC2MWl01F9AKEQAIJu6eew6BPnmfkDJw+sCAceKSPhfez4VCIgbNzOky8d43qZxuj31Rr+kYYK0aAVc6jcA9fXbVfDjVb/t1QXva+ELMWF8Dxn5y6lSjNIjeuuAjmpO+9gqdYOO582Y8I2TDo9CsHH1MOo3hajjmJm1nmTAIpsHE04AlWVMaIFSRUkCM2FBrzIaRMWxjPLGPwD3+XSlFU4oGMtZT/MGuVIRjoFYwBEI28zKP7xJOeWTwsu7evGOJWEV9MPzQzVzSCyxTzfrOE9YFqw3ob9cUNuFYx2LdRMoIQFyJmKJPYUaLvDVQ67ObFF6GhlsVdwPW8aanbBW3vKwRITmZU7PsRRMNldpNilPNi9zOqrEHnxxuRmOpqnDc+S7VL90eyAdoKXtm3DYwkyqsL8UsNjjMNw7eMHIsTvToMlJCy3SOa7NDQvZbQmR2OQl7EuYznJ4fhEDQbarj5IDIV1+I6ncjyGVIb/MXSe+jhoveXCEeBkG1XRZmo/Qbj7URLwYXP3soc
 r35VUyRZ
 ZtZpzPobcy9GSXKkuOZT574BoS7aJDCgQO4YXcw1zuSX/rQXOtkwY5wxg34MB69meBhUrZhcCwjWiL9l8AXhtKWngLLQX6tHWEAYXj2ON759TUBfPWJHnSmE/CcNCBJ4NAk86f4e3GLK/zpIf/40g4KtdEygLDfMa2bnhy7CSoMuXweAP6foPxgPLqw6q4lmH4JQOapRMsU2yx41+g6aZkVJFDxj6JEPZTdV2juzNcES0XOWZBFTVTn/RSRG6eRlIoZos/RqJTLgROypSz7zmKzMY5RNgNszK7oHHRL2gslNMSzDUtK5BcbofiQmG9HVTnsE8PunlyXM6bL8HpFigHhUz6mnl0yQ6XTaRxrnkpgqOmlv/RLXe6/VFGBsWGOi5gKYRpT5iBeTa9TrvpGXd2uEPc5LbsaJ1Qzkn8ogIRczKz42GX4tgZ8EL5XvxNN0qR5Um4a9vMH/XlFXW6i3nHs8f2AsiDXpppzbiUQMtkN5rv6e+g6WpBC/dWtPLBcsEXCH3A+NUUO1aQXQdeJFZybnz7uM+DYMSQ8i5wfsPz7kg+UAokB1MK2nubafT4T3QHRyMGiKxjHd7/VY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 12:33:37PM -0400, Johannes Weiner wrote:
> Neha reports that mapped shmem aren't considered for NUMA balancing,
> noting convergence problems and bandwidth bottlenecking for cachelib
> based workloads on tiered memory systems.
> 
> Looking at the code and going through the git history, this doesn't
> actually seem intentional:
> 
> Commit fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault
> VMAs") added a vma_policy_mof() gate to task_numa_work() so VMAs whose
> policy lacks MPOL_F_MOF are skipped from NUMA balancing scans. The
> motivation was a real usecase: Oracle was pinning shared segments with
> mbind(MPOL_BIND) so trapping faults was both expensive and pointless.
> 
> The handling of NULL from vm_ops->get_policy, however, treated "user
> explicitly opted out" the same as "user never specified anything." For
> VMAs whose shared policy is absent - the common case for shmem - the
> scan was disabled too.
> 
> This issue is old. It probably hurts less in conventional NUMA. But it's
> very noticable on tiered systems, where entire tmpfs workingsets can get
> stuck on lower-bandwidth memory.
>
> Fix this by having vma_policy_mof() use __get_vma_policy() directly, and
> thereby handle the fallback to task policy (-> preferred_node_policy()
> has MPOL_F_MOF per default). Every other consumer of vm_ops->get_policy
> already handles it this way, the scan-eligibility check was the outlier.
> 
> This preserves Mel's intended fix: don't scan stuff the user explicitly
> pinned. But allow default policy vmas to participate in balancing.
> 
> Reported-by: Neha Gholkar <nehagholkar@gmail.com>
> Tested-by: Neha Gholkar <nehagholkar@gmail.com>
> Fixes: fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault VMAs")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/mempolicy.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 36699fabd3c2..bba65898aee1 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2057,24 +2057,15 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
>  bool vma_policy_mof(struct vm_area_struct *vma)
>  {
>  	struct mempolicy *pol;
> +	pgoff_t ilx;
> +	bool mof;
>  
> -	if (vma->vm_ops && vma->vm_ops->get_policy) {
> -		bool ret = false;
> -		pgoff_t ilx;		/* ignored here */
> -
> -		pol = vma->vm_ops->get_policy(vma, vma->vm_start, &ilx);
> -		if (pol && (pol->flags & MPOL_F_MOF))
> -			ret = true;
> -		mpol_cond_put(pol);
> -
> -		return ret;
> -	}
> -
> -	pol = vma->vm_policy;
> +	pol = __get_vma_policy(vma, vma->vm_start, &ilx);
>  	if (!pol)
>  		pol = get_task_policy(current);
> -
> -	return pol->flags & MPOL_F_MOF;
> +	mof = pol->flags & MPOL_F_MOF;
> +	mpol_cond_put(pol);
> +	return mof;
>  }
>  
>  bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
> -- 
> 

The change to use the fallback seems reasonable

Acked-by: Balbir Singh <balbirs@nvidia.com>

