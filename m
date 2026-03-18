Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED8E103E195
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4EBD6B026E; Wed, 18 Mar 2026 11:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF796B0270; Wed, 18 Mar 2026 11:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE2B6B0271; Wed, 18 Mar 2026 11:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA8B6B026E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:08:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF998C288A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:08:03 +0000 (UTC)
X-FDA: 84559514046.14.68B08BA
Received: from GV3P280CU013.outbound.protection.outlook.com (mail-swedencentralazon11020113.outbound.protection.outlook.com [52.101.75.113])
	by imf10.hostedemail.com (Postfix) with ESMTP id CEC5AC0009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:08:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of andreas.larsson@gaisler.com designates 52.101.75.113 as permitted sender) smtp.mailfrom=andreas.larsson@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773846481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xpbMIsqvUF5TkdpHspvLo8KBTFUPJJGAZOVkwWVQ1a4=;
	b=sCQ4ibWJpdN+NEpT+JTU6Ra9i/dcvRtoLztEiPk3nF+hyx8CEUnLkieeWWHsiRz9EwSsCv
	ouCaKiGq/I6IftZyNsqPNXnWkFfEbrnpi0GKpkQrcuavwHhBrfJTvlQ1dHXX2eXIhcER7p
	dfFw+vOBv+2h6cOu2/gQGPh31xDdAQQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of andreas.larsson@gaisler.com designates 52.101.75.113 as permitted sender) smtp.mailfrom=andreas.larsson@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773846481; a=rsa-sha256;
	cv=pass;
	b=Uzkmdu2E+hAqx/oYgzQLpMC4xLOu3ktUi3a92BbYkiHCj7VBcnvzTG2m4L5wbbKUJbUsYq
	x52pUd1N5GHosIQaIYjjruAd4eTM7mmIXCPlmvkDPdG6BM+PYyASXibKG6DeaH7M9OMElr
	Eo8H/TKSyffRJkKdxnIfkjmBtmxGVqE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aGODX9J8Hhh/QfLme0UAZi3MQJA39OWcddovqtpLLoKczArmotgiPb8PoYaPKV00Q8TzyCZbZqiXhj4rkgrc7hZjQhnAJ5aMfp8Ci9Zk+UUMIdHCNM/Em9ygPtFtD5ioX/xMVIRtLxdgaY7Kzf6vf7qbuIflNclwI1/Ohm5LwfEdCTDPwWb0cz6mwf5TIRtYWSb0c6gwBFtg7QjLPVWovhzbTsAzpWuAm9W+GUghbkNqpKuIPqILU/1FUXw3plnDxhcEqa0foIyd46D/AszwINrgsjJBLhtL7/Rj+SzeQ/J3jKHu0OHhBUhZQtSZlbLbmUFuKI+ypHXrCN6973RV9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xpbMIsqvUF5TkdpHspvLo8KBTFUPJJGAZOVkwWVQ1a4=;
 b=k0DlQ9y7DzopT1+0gpnYz48Ao8RJQaMMzwECq97e8h/2zNmALr2CaED7iyhLfxihLWgz9qITwbCezTARD8EvgeJrd9d3+wsM7O6P4EJ1dFOZOK31WLNK3gtgcQ0ue4C92TeOdrssDBAbpHp8J3ilnKyi9AR8ur7n+M+0WObXVMqVC8lNALtGSCeG1B/RhNbyjZRiBljmgwpt4Oy25HYk1PnchQnTXoe20ajnhE+2cN9QzvdxueAlc66K/2edu2lL37Lgs5vh8lRqqLymtYLa5EG+skVbMOFFux3VpqEB4nNzr4gWCdIKHY+ofCq25LBkOqMtCWPc3Ly3G+One2quJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gaisler.com; dmarc=pass action=none header.from=gaisler.com;
 dkim=pass header.d=gaisler.com; arc=none
Received: from GVYP280MB1290.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:195::18)
 by GV5P280MB2155.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:376::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 15:07:51 +0000
Received: from GVYP280MB1290.SWEP280.PROD.OUTLOOK.COM
 ([fe80::be76:7636:f4ac:6773]) by GVYP280MB1290.SWEP280.PROD.OUTLOOK.COM
 ([fe80::be76:7636:f4ac:6773%5]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 15:07:54 +0000
Message-ID: <ad2695a5-e696-4f40-9d66-3d46bb911e4b@gaisler.com>
Date: Wed, 18 Mar 2026 16:07:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] sparc: Use vmemmap_populate_hugepages for
 vmemmap_populate
To: chengkaitao <pilgrimtao@gmail.com>, davem@davemloft.net,
 andreas@gaisler.com, akpm@linux-foundation.org, david@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 Andrew Morton <akpm@linux-foundation.org>
Cc: kevin.brodsky@arm.com, dave.hansen@linux.intel.com, ziy@nvidia.com,
 chengkaitao@kylinos.cn, willy@infradead.org, zhengqi.arch@bytedance.com,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260201063532.44807-1-pilgrimtao@gmail.com>
 <20260201063532.44807-2-pilgrimtao@gmail.com>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <20260201063532.44807-2-pilgrimtao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV2PEPF0002399C.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::19c) To GVYP280MB1290.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:195::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVYP280MB1290:EE_|GV5P280MB2155:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e43330f-b8a9-4c86-e0d4-08de85002192
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|56012099003|921020;
X-Microsoft-Antispam-Message-Info:
	qX+Q8n/fy8K74FZ/82wGBGlqOyxDcQ6BcSKAPJNMbth6mWy3yOo/qarrZ7Dg3azye09eGF3uKeaKu5ZH7YLnAPkxgAsr4K+tb0kehQVqD6Nts6QQ2gGE1RqAR3CXF+DTuWtonr3ZZdHJZESTRGDDfsPYqZVc2r1XNX9xgIxo83SkIiUVZL/TDezM4q46xwmNVKHMDPSw7fb/hmhNc1ISAzaugDb+zkmpNRvDUYqGVALdrMuJQKqhHo2IkFdrE2mDqzjFCov5c8CGn8xB6IWv/LmpZF1qgYbDJszuNzYeM0EizX4Z3d6wcZmdOCIkZZ7DzhXX8fD/oMhnUgx4yeoHRF8DTWFTdEAJeVfOiBrUodfJHQZVyfqib4+xqJEhtYK6wfLhcUgyUqW5mvntDpUeFad40Lyk7Ej8g9IQpD/z90HzVeg6efJMxM+Bk/kbRBoWJOYQOem/O64oDU75rW6Djet6gakRaopNf1GSvfGl8KoU0KzNhZ9BKQWrzQDjudg/c/yi5mKTsUaGWnqhiTVOG1ZyOa15mecBxWh1/Y3foY8b7yLi/45WRmVfPPwt1UoJ/1J+WFf9szdND69geTMtHwEdCCzRZW8oNBY9yBjxev2kjQajYmRkRcodv3BlzAAX5JweoSm9gt4hcBBr0Pk5u9ukRIOmN+uM40ali6qShfBkcnzv1tLrnJPeqSBqrGKXZv0COQMYe8LkRj9xtdeT3JmzGu2xaAOD1CsdJQGvsde1Fv3FG7eosCK111h0/egHrgvIW66ZPFsvEmE3k2H3ug==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVYP280MB1290.SWEP280.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDdQMmF6MHR3Nk1MVVN1QUk3WTNid3lMS2N2ejVTMGpBaVZvZ3NtYjJFdmt6?=
 =?utf-8?B?eU9EeElMdjFOcFR5dEJ3WVFGUCsrYWtJaFEyZXVGRGJldUgxaE9vYkE4Y0Y5?=
 =?utf-8?B?SmNaQ2ZRN2pPZU9BdGozUGRRZkhidkVHc0FkUkpGMERPdm4waHZlNjFjMFpn?=
 =?utf-8?B?ZmFKQ29yMkY5NTdXNWRHcEE4MXZUbkx1UitDTEMzMGc5dzlPcGJJRm9WUlhw?=
 =?utf-8?B?U05UaTRtbGozNWphc1Via2NldEtRd2FncXhoVmh2RHBDWGpVTUx2YURKMElW?=
 =?utf-8?B?K2w5VGpWQm92dEhtbGxTN09RanFjOFhXd0NLc1J6ZkRaRUZSbU53WkJlaDlZ?=
 =?utf-8?B?L2ZtYVUvSGVDOTFjN202cmJnSHhkT3RISzI3OC90eGlaTXJ3eEhMd1FvZDVy?=
 =?utf-8?B?SEFsSDgrbm5vMFJIdDBPNXhGd295SDdxRlNPYWMrdlBHMG9RRmZFbHNBMzU0?=
 =?utf-8?B?QXZoSVZUbXRQc0M4YWF3RHNvaG5pUFFBMFJDUnk3YlBQUVlNR0tLaStYZ3dr?=
 =?utf-8?B?L2pnVVhLbXBWdFJDMXlDSEw0aDhJeWlaNFRJMGxBTzVvSWRGOU42VzVES0RI?=
 =?utf-8?B?c1FKb09lY0tMazRBYVRFZ0tySGlva3lNVFZLSXZOd21kejhNTEEzNG1mNlRO?=
 =?utf-8?B?Z2RFZGVtMk4xbWFjSUF6cmRSOGZTa2VucXU1NnZYSFRBc2VuZEtPRXF4WWE0?=
 =?utf-8?B?THhzaVZqa0RYTkU2cDJTRStZdVNNczF0L0o5MjJOcEFZd3lnSnNhQTFkQUox?=
 =?utf-8?B?cWNHbDAzNzdRelFXUDA3cVdpTmQzTTRFZHNYdU9tZ2JUSFc2RWl1WWovYVl3?=
 =?utf-8?B?ZzNoMm5YV0U1ZWZ3V3FnUlNZRHllcWhXbGhIbVJKd3VNUndUL0h3S0kwTXk5?=
 =?utf-8?B?eHVhRHlFbTR6Q2MxeEdVTmdTUG1lRFdLR3dmS3Frbi9RVWltaHpkUnA1UWhS?=
 =?utf-8?B?N3ltWlVoOTRYdnBMTDI5OUQ4UE56N0tJRVZ5TVJ0ditWU0IzeWIzV0EyN01Z?=
 =?utf-8?B?Z1VqQnlBUCthc2ZtOGhtUHg4OFVzM0Q3NEQ0RzBTaCtUK3M2ZVVacFlCTXQ5?=
 =?utf-8?B?by9QalNPaWZyNy9hdkZValM3Z0NrcC9yc0t5MUhQNWdnMmNWcFJ5RURPY2dH?=
 =?utf-8?B?SVlldWlQOGdXckJXcWlsTlRpck94Vk8vVm5qZDVKM3pnQzlSQlN4U2hkZVNJ?=
 =?utf-8?B?RG1BUzJPVnZiSlpMRTJINVRxcVdORlRrWHdTVC9Nb09pR3o3SEh4SXpVRWFa?=
 =?utf-8?B?SzNyNUQvVzg0dEdDM1FIOXUwRmxVT3E0QzJzcGkvTHl2dDZEQzZrRUcyN2lH?=
 =?utf-8?B?dlIxVklmbE5EZmdHbDFrRTZka0lYWWgraDdXc3E0YTF0bksyT2FYUHE2b2dt?=
 =?utf-8?B?RHNZbFBndkFpVXlxZXZUV05BY2lnM0kzYUlpcnZnN3VNYk5POXhQdFZhWDNS?=
 =?utf-8?B?azdlTUVYNWliRWE0dUpqMGhxQm5wekEyNG93WDBEN0pCS2E5SGVWYnhtV1Fs?=
 =?utf-8?B?OE1ONGQvQlRFQTBndDJOT0JHb2kwLzRYM2c5dThIWUx6YTkzc2Q5L3Jpa04v?=
 =?utf-8?B?TmlMSTNJaW4rQlJFNEpmcXZRTUtHcXlUd1V4dkk4cUVDMFl3SXpsRmlOeVpz?=
 =?utf-8?B?N2N0alNKL2h2bnpjcE5jSC9iWDhBdzJ1Z1pldHV0V3E0U1lUbFY1eWkrNDlH?=
 =?utf-8?B?WWhPV2VDN2xJVWpwQmRhNisreWxZTTdkdWZoeDRYcXFBSHJOSDMyS3A4SzlX?=
 =?utf-8?B?QlZjeDJSenAvUkl6KzA2NmlFbFYyaDYzZ3pKYmtpU2tCM1BGQjhWbUNvVkFv?=
 =?utf-8?B?U1Q4SDArZ2lGSjhtSFY1S0I1UnE3WmJoMVg5YXZCbm8yRE04MGhXSFljVUla?=
 =?utf-8?B?cmNLK3Y0NXNUV0h3ZDRQWnhrU0NFNXJBZk5reTZxM2JUUkxPc0FlcE1OUTZB?=
 =?utf-8?B?cXJzUDgxcjdOYlNxUzc2QUtyZlEwbHNXN2Z5cTBDV0UzRlU5TnBLSFhqRDQ4?=
 =?utf-8?B?aDRqd0Y2RDFQZk1LUDZzOU1DbkRqOTlEdkI5MnVzYUU4ZlhTaU5sTVpUc2l6?=
 =?utf-8?B?MFhHbC9URVFtSzFxZVdHT2hxOXNuTWc3MWVNeklYRUJLTTZaektPMTRhREJv?=
 =?utf-8?B?Yks5dy95QStRQnhNTVpzaHo3MnpkZVJBa3I5Mm5YeXBDU2N0Y25qRTJLVWNB?=
 =?utf-8?B?UWxLd1gybXVVV2wzVTRNRGdFM3dvTWIwTno4NHQvakQvVEJRZjlnSlU1V3Zj?=
 =?utf-8?B?WHYvb3JycnNMaGwxN1doNEZOL0ZLNTlWRk9mZXhWR1R5Y01GZTRHTHpGWlUv?=
 =?utf-8?B?cGF4UE1VZ2dzWEx3cVFESXROcTcyR0Z5Q29wdjFnT3VmRFc5Q1ZIZFFZRWx2?=
 =?utf-8?Q?jskVyLwPnCi4Kmuw=3D?=
X-OriginatorOrg: gaisler.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e43330f-b8a9-4c86-e0d4-08de85002192
X-MS-Exchange-CrossTenant-AuthSource: GVYP280MB1290.SWEP280.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 15:07:54.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 91fa4a59-2167-458a-8318-e45d80469d7e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KuhBRUGDPwVZ0kqE60WGfft6TeaCL92vO/RSBYvn7S+6j8nZW82DuB+Lhg7RGqyBmhstFotc2GQlyWJ6K4W+SN5US05gtqs0sjPDYQlH5n4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV5P280MB2155
X-Rspam-User: 
X-Rspamd-Queue-Id: CEC5AC0009
X-Rspamd-Server: rspam08
X-Stat-Signature: 3kc4fcojc1d8e31zf4q5nhddehpwm5yr
X-HE-Tag: 1773846480-352630
X-HE-Meta: U2FsdGVkX19QhsV1cX2zM1nyN/jJtlWi+6+vVeAO8PnNRyw/bBPrbbsHpYJIrM83M5gWxMnU7dPDZt0ZqY09/tJweRsQC/Qd8u2njwBs/v6DsPVbPzTiN1Y1rLl3AOfYIlK0e1qCU60TFQVuL5b/LAv8BAn3wq6L2kmks9DdScOCZBAL/vQiOGBCYdTTdLQ9jcqH9G+yLKE/DdBsnSPKnGnpzBjrmEM8xx+gGl1S6Wr6EuAW3n+kI4FKhy3QOu350leoMONeYBvc44aTXBTsS8ZMGMCxg0fZIcgXFpd+JYVL+Z02qNar8SN4+tgU8X0IzOZg1EZgHwhMMa+LJD00eZRgI89/t1mjLvyAU/HB4QjlSvQoYWo5lcR/05K6iI3BrBMDys1sjO9vcZ4mjm19Gzl+I3V7RVyHiPMFRU0gXd5aQIf3lGuJOE9povhOgSOa6Xe3hAmnxbcPxo4MGOTUPTZJK032Ri1vibledo2l//Ooh0LyJeBUnzDLNrXZ3QKZmLXMDEHz9uF/ATKvRQayPuhlff8xRzYftIrqMQiogRmXZlAhc3AxzxUPwuzGHNbQWV2LZtxcaM9PjzjqPIQ4baQbgMTK7SDDDgblParfK0Wv5Toc/zO9DTJ6VwvKBtp3w1WVYt+u+m/1BweMjHw0bZZfVQB6chzALBlJ8AyxK3XvWheghTRywkcj+4cQYdfKbrEXOsRYNmeUStK71qXaaHMTNFVeNNOkLRW4ZEnPrWauV8rSizXHYXzGNaGQ+NCew/NoW4bkOKPhByl2aJMoMPW166JWL0p62dC364DdByadzfb83/zf2GmIY2B9frYpgetD/zG2izz8IxNxkl//P51phwR2l7X65N9b7n4CTvEod4zEkkINCRmpKhmG1sNqo62XhNhNJcfIrgGbcjU+Q588nEDa7tK8IxWEy4NuZuRBXJ62yULCoezZ/Ly187D6rFkOrzMu40bY0KCblDb
 7qK7qMqU
 1YhhaC3zTAULKlIwUb7Cq0KSKyPdP2dvfh2FhQbINmCAFUp3+i5THC2wWQjlNhxEEo2zHiRnomoSi009WhHF3pfzTA/qY/NDpzASFKXlMsWsbtRoPB4xmYzfb23nsV1dGtdpCYzIAJOzIxeeq8ibSRNu6JF0S4KW3bYPMp5fJKUS/KgI7BmeAQeLjbyeTte3yJr/tmbye2HKOmaC4GzfgqKxDSRDP8C8JnHJzcZQW5uwF3ksJjlaZaMA0JbFeueXj9fewXA2gAmOu413Sp6MQSFLTEIANqcQT9ulVR6iblpdMX4U/F2U5CciQY8R+CmKgpy73YO3u+0UW62aho1fwLQnUoWrpIZtw/DY5ufycCT5JJqcYbLRDzZAsxxhRDgORoZh+3V6yXwNtqEdiZT6s+/tw3zksfAgPQ9hjI7mWDzC9mrZEEFtW6QOoSOUnooYB6jfNvtvyVrHAqBvcHgLnIZsyFxcpI54g9OIedH+bg0CNddj1cWHK+C0uaEo1m+HhOZViILtt+CvpqL7Q/rw1j2gBDK60hB0qNW2Mq4IpaGbuY9kTC1DhUxkPblrPr5e71m0HL8tQUvBd52BLC5/OPepMKMr9Qq4LeTqT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-01 07:35, chengkaitao wrote:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> 1. In the SPARC architecture, reimplement vmemmap_populate using
> vmemmap_populate_hugepages.
> 2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
> when vmemmap_alloc_block returns NULL.
> 
> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> ---
>  arch/sparc/mm/init_64.c | 47 ++++++++++++++---------------------------
>  1 file changed, 16 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index df9f7c444c39..f1981adc99ac 100644
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
>  EXPORT_SYMBOL(_PAGE_CACHE);
>  
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
> -int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
> -			       int node, struct vmem_altmap *altmap)
> +void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> +			       unsigned long addr, unsigned long next)
>  {
>  	unsigned long pte_base;
>  
> @@ -2595,39 +2595,24 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
>  
>  	pte_base |= _PAGE_PMD_HUGE;
>  
> -	vstart = vstart & PMD_MASK;
> -	vend = ALIGN(vend, PMD_SIZE);
> -	for (; vstart < vend; vstart += PMD_SIZE) {
> -		pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
> -		unsigned long pte;
> -		p4d_t *p4d;
> -		pud_t *pud;
> -		pmd_t *pmd;
> -
> -		if (!pgd)
> -			return -ENOMEM;
> -
> -		p4d = vmemmap_p4d_populate(pgd, vstart, node);
> -		if (!p4d)
> -			return -ENOMEM;
> -
> -		pud = vmemmap_pud_populate(p4d, vstart, node);
> -		if (!pud)
> -			return -ENOMEM;
> +	pmd_val(*pmd) = pte_base | __pa(p);
> +}
>  
> -		pmd = pmd_offset(pud, vstart);
> -		pte = pmd_val(*pmd);
> -		if (!(pte & _PAGE_VALID)) {
> -			void *block = vmemmap_alloc_block(PMD_SIZE, node);
> +int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
> +				unsigned long addr, unsigned long next)
> +{
> +	int large = pmd_leaf(*pmdp);
>  
> -			if (!block)
> -				return -ENOMEM;
> +	if (large)
> +		vmemmap_verify((pte_t *)pmdp, node, addr, next);
>  
> -			pmd_val(*pmd) = pte_base | __pa(block);
> -		}
> -	}
> +	return large;
> +}
>  
> -	return 0;
> +int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
> +			       int node, struct vmem_altmap *altmap)
> +{
> +	return vmemmap_populate_hugepages(vstart, vend, node, NULL);
>  }
>  #endif /* CONFIG_SPARSEMEM_VMEMMAP */
>  

Tested-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>

I assume this goes through the mm tree.

Cheers,
Andreas

