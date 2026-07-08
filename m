Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A1EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 02:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A2E6B0092; Tue,  7 Jul 2026 22:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2308C6B0093; Tue,  7 Jul 2026 22:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9DB6B0095; Tue,  7 Jul 2026 22:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D91016B0092
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:45:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 445C5C3D29
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:45:50 +0000 (UTC)
X-FDA: 84964069260.09.8096C15
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010026.outbound.protection.outlook.com [52.101.85.26])
	by imf06.hostedemail.com (Postfix) with ESMTP id 60311180006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:45:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mTPLCybu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.26 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783478747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZT4KGH7XKQdgEtDf1A6T50PHcdZFuz6Kmh516VvJJOA=;
	b=EoI0CTPNnrIQHs4qhC/nrahJQxGJP7mJ0n4S8+5hvLDdHu0Zp8CStiL9wIAzzgNlHiBQ25
	uOKV1QuvA49xTrTGSQbX1BGhYy4fuLY84JIYOTuJWcnd0MpuPxflx5/rb4UJdxCb/D3G0k
	HSer0CEmnykHqrYBp+xvZSotUn+a0lc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mTPLCybu;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.26 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783478747;
	b=n5tvWqi8BZn9V62q0yN1lqFU7dMe5pTgvu/Pjts0FZFI9abOt9cZEvsOyZySm5KsPKBFtm
	HSVVHTyw00Xr0ZV541G1rhef1f/uN1yuJL5B1Ep1POQn3vNZRy2FC9KCX4FrfkfJJ/D3nq
	snPu6qs5PgMFR356v7WIDvi3stSF+9w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ltvm3dWEe/fufk3v1f2IAIVG0Q8+aA39NuwDyk43jvoad3Bb7TdpfRvQswhnv5etSSR/Ght/l8V1ZnLr0yTTnA3sHx8uJcMTUqirmThhFlHV46nTfXOh4zA45UT+E/B5FfBRKfy10SN/gt6zgwSm62/2UDNtQUTDFF3ZVDFUseSxWyaMoq7SC1CiP30oU2sh0Fj6X9HXL8ezd7hOxBNLw74SLIc+1zlPePZCk3u4fUTnJ57hzWXSV3XyWOA7WrhPWCFmeXn5NPwtKL719DpO1IKutibEanrUfz/RncXJtcAaG76vl4CxHjyfjbGjtdw/lJzKyncX1oSJHj+kVPM9Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZT4KGH7XKQdgEtDf1A6T50PHcdZFuz6Kmh516VvJJOA=;
 b=qrOn/LR6YGHSUc5Y22m/PXEQn23JUM8mVB+MFicPf+Au0yasSdO3MLCEcsr4K/PJjeokCX1oMp4A377b7EG+kzhUvrARjMof31me+Iza0z5jTU4RNijBjMxfQ3hF2/4MUVG5cMQrNmBEEigLjMTHvFG4oUvfJeGpkjW3xgZwPVL352ykA+Z0v2BtuMBVE7Hsi1Wwo3Z746AyXwx3cPsbYK4nmvbGoUyHZ6v7ZvID0Ok36emg6wFim8DjyXWDdpuH6sKnLnB1mnil07KeGuS175vtpUKa9ktfFqdUGYBrJEz++VmArntqpEoEnUyhwtRSnx0w+iGAf5bwFhXr5TT1PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZT4KGH7XKQdgEtDf1A6T50PHcdZFuz6Kmh516VvJJOA=;
 b=mTPLCybuVsyqs6C2s56ozf7wEOmNXMiLdNm5o6R0I6xFvBmW8Ti6igeJN3ujWdJ8dI/xn7gN/J2+OVLis+ZoHoDsucSpJQj6Cug5qx6P/CbPRG2T/jOrBeaoSu+xvuS5Ob8urZysqYCIlMVlcOAqnERomTAxolGoNw0AFmsZhdXpZfXXh7/1e+BcT1a6WdA+5gkQ83Ch30M64UmKatDbwBssCTbxWFyOm+S9gLvM5o3/EJ1t41NcFQsDjSC6BswS5KCIbeTtz+PidYW6/JFX7DltnL4tqoaKAqhxbZpDJpskzqh9B8iEMZjHXsA5MYVJupmbRESjATo+zG/oBKngQQ==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by LV1PR12MB999279.namprd12.prod.outlook.com (2603:10b6:408:3f7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Wed, 8 Jul
 2026 02:45:44 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0181.012; Wed, 8 Jul 2026
 02:45:43 +0000
Date: Wed, 8 Jul 2026 12:45:38 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
Message-ID: <ak25fZVDjSF1XXIm@parvat>
References: <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com>
X-ClientProxiedBy: ME0P282CA0024.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:20d::9) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|LV1PR12MB999279:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b53a762-bf37-4807-66cc-08dedc9b0184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Ft0JUiBZvjrWKRhirFE1QWXpZpk2GAVgAjDrvE+S2yAx7Z6/hBqpKotWhk/73fe295moixBaZMtARA4WiLHXByXz3tb1WBBKBnOVoiIq9YBq8Gky+Xvc2cJarWkgD2YeXZgmHCR5sXVYVV4FtEudxFMAg79JtqUYeI36vZ1UJ7ob1H3RZo6XB0zuM5XqS7vx2zyiWMSHC/UJUGYiBHNVmi30wFInh7+QZvojyMkOniOcrHFRBt6zJ23QL9oHgy1R2fcBl9sypjxc05vsiqE0qexlO9Z5Vy/bmLiKJAUCJwvPK8GRhZ3HToeiDndBBK3rZFpY6Y69kWaE2l10ONk5p+Yll+3XaQwSz9E9TU3IMJ1QedziSCdoWcgq6WJDAEk+yUr5u8bpD+9g2mzbyxCc4Hc4s9K3+HQdioo7FfSNR62TW/uiUQBoUN02cfvgYykpABpCCQSEpXjUKoSRS4K6QdEcvLvY6LEFgjIA/sdr5ywQrlIYex+3ji85kGoe+Bvbhlf0Zh9mquuBf3YqbjEHm9xpFYCIiwN42BI22rC3Es9fe7fInjF2ZbiEc+ejOY2ZYlJFTMZoxtIiA/MznNlGvQpskmqoTPLAb3tmhHofABxQLlGV22jpbbfiVWUMotunw9/UV+Nv4CDcC0ivJkRi29njXbII2tOvkmJkj0GCrH0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EuPsgU8bVfLKPfSdyHz6hwqNxCMYtUew3lEpoJzEDd6eJaiUvjqeibKXRD8G?=
 =?us-ascii?Q?0oSYEa/bUQ8yXApQlQPrBeMHJFrDFVBLjkqg1G29VVgNcKarzL8MWw06loHF?=
 =?us-ascii?Q?jOYSssZ47AmXoClqFz9TxiuxEoPKztQ+0wpZyV/5+ikh29YRSJyacmriUTaD?=
 =?us-ascii?Q?fCCIgJMTdXzN73oL0R4JxrjiE7bNa7A9fGI28Z0NN2Y/DlS4MxXfJCWKbFhp?=
 =?us-ascii?Q?XHkTKRGR5iz5vLeqNCtarUMwsVf151T8cUdRc7J8FIBvMZQceZlHrBDUj/D1?=
 =?us-ascii?Q?fYdH4CMN14SUrghP0meoDlBV9sjw+Ii354Zv47NLZLGRcLl0ndCsN6G9oTp9?=
 =?us-ascii?Q?uNCk8oUddIMjCX02Uq68cgUfXYIES/0dc65gSCeXVV0tDmlBXRnkqXgVuvvw?=
 =?us-ascii?Q?wgGBEaGEBQZmrZDDEvrEsVN2UyD/+nIS+CcEPfcQqgC66ElGN5wdz0DKmwnH?=
 =?us-ascii?Q?FCCP9jdt05En8XeGoh9JAYBlwrUj8oH/VTgfkbxGCug1doNpf+qIvDPa1fij?=
 =?us-ascii?Q?jXQqLCUGWGA/Pfe7CJiiJsqrkyKEjyBSowvKhfMwOhhDXT5NdT1zFwWZpdkF?=
 =?us-ascii?Q?BJEb300fOMabElRT6uBwG8mr6TLFfrtKlOgU5YIeBLtYbq17USFCexqc9rcX?=
 =?us-ascii?Q?/r0pwG8Vkj3a1xw7/d+F1t7W+6bGqZlvUcvzVtFDaMUsFkjj6zy3nk0ibJh8?=
 =?us-ascii?Q?RB4azhW29l8fTNwgpBeaqRbJEHSFVQV8D9nOPSFuLxvAAK2o9TsEu2ovlVyf?=
 =?us-ascii?Q?5RCNTh2Y/j7WwS0F1VlooCrQsW6Jk+cXlRxkk6n54zDczD+Lqh46ZU7FnxWD?=
 =?us-ascii?Q?pRmP90GBE19dOF71ruvBz1foqiGDgpOH5sjwEW7Pslx2V6pNxdG5fSibwfYW?=
 =?us-ascii?Q?AXgmtT/YnjwHVDCmNUyg7x0WzlLKbdt2RWOIFRB1xnWY+d5yvE8Gh+S/xd1r?=
 =?us-ascii?Q?rq+qp3dNweJAWnhm8oagMl2Np2VOyTkPpU3XYn/Ox+IPYFHPNbr4brzZfkM9?=
 =?us-ascii?Q?86gEeQF65JFM6ZKpKDZRVqDA3wp3RIkheFYDCodpvgZu2as5LWRupl0YoobR?=
 =?us-ascii?Q?12K06EnfwQj65ne2B2frZHJWGl++D7q6aZ1HaWyk1p479NrdpaJObYx26YX9?=
 =?us-ascii?Q?XUSEnsPxmqOwenlyLLFZGX3a2WZchvcOdpWbYh7cjJwWktZC5HbFoVLGBa8H?=
 =?us-ascii?Q?YPQHZy7EUDRhZUe5Yk0oXk9WRHow7i5IDOETxVHPtXY9hUYnHdxeEqEpBATe?=
 =?us-ascii?Q?ncJy7W7s+cmVluDQ6SPPuqDnGrjfPzxVFsQjAd/jyK2wBNSlWxTB35K7t/MH?=
 =?us-ascii?Q?zdFG4j71xh1H5PTNFfU42zSkjr0Nl/Gz6HliL0WuiDdwV0RWxZqkgv92PB4e?=
 =?us-ascii?Q?e/oO5wS2giEj1g59SK14r7cbiOOEAPaSr7Z4nVmhfz3OTAUJwEKcysxLhkHo?=
 =?us-ascii?Q?pawLc0DzomeW4tFCnrwmrCw2ldcSMwV+whFp2qyAUGNdOy2W/+fVUyqV3k1d?=
 =?us-ascii?Q?7VEX8oPhm0JCscankPl/5GwGg0TLtsC3aZ4lE+tpyxl7z4WWqKqt2yE4goHv?=
 =?us-ascii?Q?0NbcS0hdqAZr+zyduq/DMraCtPcZKnATeoK1ACWNEnBi+zEGKvz65QxZctZN?=
 =?us-ascii?Q?RCKJi7JEZ5lvNQTihOCljdYTdvFFFTFWdgHYzskQG+DCVQ+0J3hYcUCSCRgc?=
 =?us-ascii?Q?mZ8Uez38VN4hqcXrBehP0oTF1wp+qEl5FStBsfRD4H/Skgp8J9RssZcv9c8t?=
 =?us-ascii?Q?xhRZGVEEaQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b53a762-bf37-4807-66cc-08dedc9b0184
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 02:45:43.8413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2O16VjOuZUQ0jEhzKhCU8n/Vb1ldlHp8JAv88JoztlFVKw7RhVJMaScNT/zz8tVAJnh8yKX59z49J8lLMS6Qag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB999279
X-Stat-Signature: cm9c4crrf75xm77swjqn5dmpicncbgb9
X-Rspamd-Queue-Id: 60311180006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783478747-367777
X-HE-Meta: U2FsdGVkX18XC8p6V+j034ss6Um6cchghIc/HSt8DeErN1ALOdSDRYZwaiR4LdnVnRdzMz8ezR89ZZoCp6cT6YMznBwr9Iq1CieFC4aBiQX7O9j9D3ELp/dxXksQ9EkJTK5J8ea0fYDpshTKfaWaiZgt+lb/PW9smmZtyoCw7tfz6AdQRNmGw7+JuaANHwUIidfDNICWH/2pyQpWG5JlUb0BF/fxTljg3GaZN28hxlcRks9pVtlbm0vZnqRnJubdHR/uxZYmu2Rbg9eBZ6g6pXxre4ZURAvGngI2f3kZyaYfndXni45vf4y418mlXbgw0oypIHeO4va4S0apcxVh9O5NP/oyf9s8xDnz1cvSywHta3Q+DwrdjtM7yK3mIQ6ki7HImLBtW26naSd0/Y4BKHv98CWxBrWK7SRk9eMHP+FU+4UZZ3cjr8/icYIGOF+bTmh6zE0XVlhndVdebPEKYEWmFGW/3zb5OGT8+BRNuR10lKrTetYUVUc3HRb4TINscTYCkZ2s6eZhApLyXTuxO/pAIaB4+3bB/nuU0JFv95yceXSPmrCUqXRsNsJu7GGWuFE12R95gXu/BSaVfer3SJ6OdFEUFiI+rY1ECe9rBp4enzOme3+TGbuCulCNhHU7fjACMCk6nFElQKXlB8UazGSYqsUZwipWEIXmo3X6xmJ6+dS/yR0DE+1QjqGJriUbZBmhDeum1WZRUYAYR9N4LlsLveeJSPbszXaZSPdn4Fd2KsITcb5/AipK5OJOFgGLc0FHV6c0ePG31CGT/SNdg7fum0GZWKClEEKOWxiimw9vIEFO1Y7/rcqfHN9PpukFsYa30lER6gXoslTko9g+SETy9gIi5WXpwYZVSDcjAH/Nmev3wrPM4h23jDQunUrt5S5Ny/xk4ccZfnv/LZ+vZh8P2CjJd2+PN25BQYjKWn3t6AHKUOTYccVmGLn4OsDesFx6WpWro0Q7OO6MlB4
 s9sFWVjd
 t/iWwRfxyAUPIGqon7E1io1Lic6PH4gOZy4nv9kgLLkyls6iReDTh+pjW7xJ4KZDNLBpAs217wwkBU4rsO9Zrt9z8V2SCZ8mrbJsEFreNPcaAD8jzOe/hUbjfy9w5TN8npgcfi+xsMu+RwmfJvK6S5X3dZRtMj7mZyoSXFWIWvwv0dzieAuH5vnyGNkuBTsr5USqLoXT+jkQ9C01benVwHjQ+a0eMQX1umRbPOtjPfabHZ4bPqu04PbmQ8SgQ/P8O8utB4XXK4u+qUQAjQULwzJvSoVor5PpmkSnWptxqRwvjvs8SIPrwpCjiqukpzabOmLvenK5DkowWypyTRaADiyy43EIFcuwVySJqCwluVtuYfudpShzouugiA4Q5+ghdhvtOBSLTYVS9Y+J4Tf/8AHQHs3XjbjvbZ2kfY8Uc10SowqWWOhJ1U30dKRyI4dDMVGo0TidNuensV9olWuo13eMG/i7MBV6fYp3+pUnslGAI6GoV1zDYZtlZAfUluca5Q84iO6XEfot+fm1Xk/d/GjQEwETF4ONNRui4nT2C03dKuUMiCZvyK3Z7MSZYPIdFTR4592nHBvqnhaXHq98ZNOse8w4BCx5ilATjWcKMNTk3KXIat4EHlJxP9/fA/uusR+qvYQ7NOgB9/xTMLy4+65UrHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 09:50:20PM -0400, Zi Yan wrote:
> migrate_vma_collect_pmd() can drop pte lock to split a large folio and
> restart. But the code does not handle restart properly when pmd becomes
> huge or cleared. It can overflow migrate->dst and migrate->src arrays
> during the hole or skip collection. Fix it by:
> 1. avoiding migrate_vma_collect_huge_pmd() if some collection is done,
> 2. skipping the rest of the range if pmd no longer points to a pte page
>    table.
>
> Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zone device pages")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkefeng.wang@huawei.com
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> The issue is spot by Sashiko during a patch[1] review as a pre-existing one.
> This patch has the minimal change. An alternative is to reset
> migrate->cpages and migrate->npages and restart the whole range from the
> beginning, but that also requires a restoration of no-longer-present PTEs.
> 
> Link: https://lore.kernel.org/all/20260706111958.3649651-1-wangkefeng.wang@huawei.com/ [1]
> ---
>  mm/migrate_device.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 2fffeb1f99694..6ceb47ec1da24 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -257,7 +257,12 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  	pte_t *ptep;
>  
>  again:
> -	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
> +	/*
> +	 * Only check pmd when addr is at start, namely no pte is collected.
> +	 * It avoids collecting the same address range [start, addr) twice
> +	 * and overflowing the collection arrays.
> +	 */
> +	if (addr == start && (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp))) {
>  		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
>  
>  		if (ret == -EAGAIN)
> @@ -267,8 +272,18 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  	}
>  
>  	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
> -	if (!ptep)
> +	if (!ptep) {
> +		/*
> +		 * Skip the rest if pmd becomes huge or cleared. Flush if any
> +		 * pte is modified
> +		 */
> +		if (addr != start) {
> +			if (unmapped)
> +				flush_tlb_range(walk->vma, start, end);
> +			return migrate_vma_collect_skip(addr, end, walk);
> +		}
>  		goto again;
> +	}
>  	lazy_mmu_mode_enable();
>  	ptep += (addr - start) / PAGE_SIZE;
>  
> 

Looks good, Thanks!

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

