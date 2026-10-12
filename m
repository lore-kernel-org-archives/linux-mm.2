Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E85CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36F8E6B0088; Mon, 12 Oct 2026 10:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321366B008A; Mon, 12 Oct 2026 10:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E94F6B008C; Mon, 12 Oct 2026 10:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA2E06B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:33:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86B4EA0C28
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:33:49 +0000 (UTC)
X-FDA: 85314218178.21.5168A07
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012012.outbound.protection.outlook.com [52.101.53.12])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8558F40014
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:33:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GEN1TWym;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791815626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ITiMwsdR+THhAawOwB0YPNCgJZvaxIiioMf+gpAwgE=;
	b=QOqPqeJUL9MP85Lp3XBG27tG5u3M4cYWagsDyzitm3K8o5WgtAKJHR8c69LnS75yXw00kZ
	jje5TO8yjskEbn3zV6vishEvanSBahE9j+7NrUqWjVnUXD5OSfTMDq/tEnKNyVtgYSQprF
	gjGkVMw4oLc6hIUcspMUlTyLUOnOCs0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791815626;
	b=pakOXSB5vbDENa3gAXGRgsN4Y/Q36wxZGGUeE62E3akR1gR4Wh87oJEqQoqvQ7cmKzVG6k
	CX3sF2Ya+0jOz//8AiO7nbAtsiOc2GimmdlP05mhNy+WjjdmMNP4aqj3dDceSCBP4jxvg2
	DYNzaRVl38/BLMHRZHvXDt+3OORuqAI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GEN1TWym;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dNCzvEpaIszQW3ah9Zr3OoVS3JOu2Dp+z066riiKHC35zagUjabMu28Wxsmug4mXqkIZtEwBlLLVMOYnsSTybqbVcQZmg6ptx2dUmY8E2O0hMHW+OKKlEzmeIpDms+LP81uc9wI0UrKS7jbP8BZs5gTrjVOSvrJKUhEP4fwZge07RO5dYa3dSK8CsI607JPgG1ufpmqesWVOG0uuwnrTwy2dmFZBAGxYD8yWr90q3nSgqWM0LphbWOuzmWSMu4A4JECKveiuziZSYbtSsUWv8tGQJc0odYXpPLjYN6luIEP3f1Im5oXiNdHuSfBsqW6CqL+ZOvO6sg3qLSjlexipgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ITiMwsdR+THhAawOwB0YPNCgJZvaxIiioMf+gpAwgE=;
 b=K6Eyn9zhhhiER5BrUVm3IKT6g9ZWRv2R/vX+VDUqhE1veVHcmGWWjjk+WZM8u1/DB5oUfs7wLp1tGupkxvrAAOYFkuIkhySGQRI0QAHwVjb/x9VkfQ1Ju6dpG96GOawpJVeoW6Cs4+iEocTlOkxmsVRyUTCleIoTeCrxaPfYuTCzadLrXTQVrjT1o3f5JWvl91aQo2q2+53ClysVtHYJG9N1BntPpHbrV9WmOAIVINGssoBFKXnXtVJYjJCrQLeJHPpu5RvQnRaj2XIePg/U8dJscQUtorGE9wgtMvG2iAyJcXhay/2kNaIslYhTF9+r5lS53JLxXK0BW3GHEu8HdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ITiMwsdR+THhAawOwB0YPNCgJZvaxIiioMf+gpAwgE=;
 b=GEN1TWymX3pKArqlml7u246QP1EHuvhuTnjQWl5c6B0UX15Zqfty4zYcKUW53ATEIB91P94V7mDwSyT/Zv1Nqk8trwiJSGCuL38c2hj1EiRp8/4VKxFo2NcAmQTpLoO9lAcXlR7yy1WW2/UwFs3OhooIqUxzeUr3efbivXDzCN11/RW7BvQJWAeJWeZ5qdbSPMPGyTH6mT5iV9hGexZ/1jqz2BAMtnLAG1F9VEmkMszpma8oTVs14JIpuHUrdxA6U75Q1FtYIGOtEdxOqtF+Jhex809i6eG1gHUyy94pDxRlC2U/+7mZQexo3NAX1wVf4pWe5nYCYhuNZ7rIboEEYA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS6PR12MB613404.namprd12.prod.outlook.com (2603:10b6:8:4f6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Mon, 12 Oct
 2026 14:33:40 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Mon, 12 Oct 2026
 14:33:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>, Kyle Zeng <kylebot@openai.com>,
 stable@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: don't discard lazyfree THPs at PMD level
Date: Mon, 12 Oct 2026 10:33:34 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <8B17F897-40BE-4834-8078-949DA951B46F@nvidia.com>
In-Reply-To: <asy445BYRhcsGDE9@gremlin>
References: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
 <asy445BYRhcsGDE9@gremlin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: PH8PR15CA0005.namprd15.prod.outlook.com
 (2603:10b6:510:2d2::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS6PR12MB613404:EE_
X-MS-Office365-Filtering-Correlation-Id: aafd9f4c-db27-4f1a-0235-08df286dcebd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|18002099003|22082099003|10067099003|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	WMHu7cWvoBB9bz72L94bAzjBKULHfChD+o1jqDusLFbCtmNsLjwYD7qjMACFz1cA4tXpTxU8+a/85CVajo52Uwnb6P+4asRToVOYk0pMOy1qndEpbZR3ZGg3XdqLROIxylpdyMK835jbrCfqvMZcRhHCUsuH/fyICwVfhifKZvtGhaJVx4JOpyaxQnEqT0rUDyq38+SCcGtSQRb2E90Ec8PO/GuLYJA6GfgXqOJU3q/gRN/U/bc6FZWOeF5MFXMxFU2seOl3BK9vTli8mF71rRtSA8R76IWS5ilvoDwGy3eNMPf6EWgmdDDjKS5FPHAJ/62B6MJrrdG1C2atM8KBn9oauPZ2gsVrQ+rR56aboWBwfbXu+OUoy3ndDV1nPKbJD2j7hm9pkiiLyee52X2D4ek4hvaLw6eB2d+bzGJcxCcVdhsxf1COXJrla8p/lo2w5SSgE7PC8lOCDbNZvwDVcGt+KQOy32+hqIwP/SGUSfEViiErUVfDiy4E/5yV5sE+K5nmZ0LE9ifNWVlZo2b6TGhsTRVJydB5a0ooKPDMpBzy7Mw8DSc43px1l5jiSFb0AcQ6WMr72aKQdKviWiHLG0ga1MxOg5otFZc0oy+5Ujm5jbgAAdSnaz/rxHhi2+CFavIWSL4oSw8ZE9Gk/abh0xPrQkVoUGc8K2j3oDxrhqI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(10067099003)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnBvQlhMZkg2UFhrVVA3bUYzUnd5RG02SW8xeXJYQlRCZTVxZERwQnBKbytL?=
 =?utf-8?B?MGpEV051QzJ1YnN2REswR3FXYjIzRG90V0xrVGFhelVTd25LYURwazZHMVFG?=
 =?utf-8?B?di9tVnJOeVVUZHNpeUdoYnFCS3VaYnVQM2VFNUViWkFDTncreTlaYkNtNHFv?=
 =?utf-8?B?cGIwaXMzL3lCSlAreTErcTcxWXhEWWJDWHB4dzF4M3RnU2M3WTlIbGNmWXZX?=
 =?utf-8?B?U0JVbWs0ci9pMmh1NEY2ak1nZEp6dW1ic0EzdHVvMGpjSmRBWHA4TnJiK280?=
 =?utf-8?B?V3N5TnYvZHpSU3B6cElrWk9uYTQ0dm1JdVAyQ3pVQTB6dklzeUh4SGl3NjEr?=
 =?utf-8?B?eHVwUitmZ1psaDFZNTYrNm82bDlIMWNoMnNQZmVobFhUR0o2Y1czZmg0UDk3?=
 =?utf-8?B?Yi9McngybWYrcHdjR2F5YTR2T2Y3cG1Sd2l1aUt1eHJ6VXloaFl5TFZFZHha?=
 =?utf-8?B?Szl0b1pSOEdzRjJKUEZEeVYrQ0h3VDMzKzU5SWhSSGRjZllidHpqVWFNZDht?=
 =?utf-8?B?Ulk3ekI5MnVIVmdDQnBKRll3MHJ3UTErd1BheWpHVElUM2tkS3dsbGN4QUox?=
 =?utf-8?B?ZEpLZXFOMVRJbzlIVksxNkhaeXI3REhxMmczMjdTQ3I1UkpkdU1sRmE1aHNB?=
 =?utf-8?B?bkdKQlJnL1R0RzkwVFlnZi9waGN1TWNHRmY2R0dJTStsOTJ0RnRtNjkxOUJS?=
 =?utf-8?B?V3ludGM4YUFYNTE0VDZNMkNpYUlRaDYrdFlZeVRJcDkwV1kxU1lFZ2JqbkFr?=
 =?utf-8?B?SEIza1FEK2tiY3dyZWZ4OTFodTFhZUZSSlp5Y3YrRzYxbHFCU2I5aDNSeGpw?=
 =?utf-8?B?cGpwMnduMlpjRUJFS01JOFpmYnl4VXNUcGVEREE5MitubjBXblVWcmQxUmFL?=
 =?utf-8?B?RThqem9INVJTdC9nbGJia1BoWXp4N3NJQU04MEd3dlpleDlvV0hETnhNellI?=
 =?utf-8?B?RER5eUpKQXpGd21VbU1ZVjJaMDFPLzVVbVY3dmdFa1Yzd21TdXdWVnRZQ2FJ?=
 =?utf-8?B?cTN3dTlHcUo2Q1UzZVAzNnVQRUhtUmZiVEVlYnFzWDlyUHp1a2poNTIwYktV?=
 =?utf-8?B?MzE4RFM5VjNLMnEway9FRGY2ZStLRElveUVpKzk4TFYvZEM4QlJaTDdwOTZ0?=
 =?utf-8?B?cWFGNzFNZ3VHYlIxK2pFZGN4dnVqbmsrcVlocGpKbjNHWHNPRlNRQi9iNzNV?=
 =?utf-8?B?WUp2eERlQUdxRWhyWDFlb2pOTWNsNkhKbG5iWG1Mcm5aQkxXVXdFTFVJWTRF?=
 =?utf-8?B?OEovbVh2RVVOVDJEM0N4U09aZ1g0YUdWTjZERGFKZFFNenA5VDFsV2Zzak1X?=
 =?utf-8?B?YWNiVC9zYUVVVzFndzNSdmJkT3diTHZSSERoWmEyWU11V1BhVTlibkVYZkZC?=
 =?utf-8?B?YUlrdzlCNTUwWCtvSG4ySVlsVVMyQmN1ZmNOUlYwdHpFTDJsVjE3dk8wYmtG?=
 =?utf-8?B?ODVZYnBmZklxQStadXQzM2xvTmEwZG1MTWhlVVlkdFdQbEdqdHo1TlJRNTc1?=
 =?utf-8?B?SXhSUGUxck5sNldUSWFmMmVNZlNHVUFKUlNQVWVnb1ZUSDFRK3JoQlIxRXdX?=
 =?utf-8?B?OTdqSmMvc0FnMWFRZjhINVpEZ0VDeVZmdlZyckxucVNJdlJqZGdWa3owQ1hZ?=
 =?utf-8?B?YmF1ODZLWkR1YTA5ZWNoN1lzMXRVaE5haVg0d0MrR2NVZXBqaCs3Tnd1U2tG?=
 =?utf-8?B?RHpBb3puTFdHTjh0b0drVXJ1MHQ1YUYrdEhvZjdqZXhFZFZYY0dDSUhlY29p?=
 =?utf-8?B?eWdQcy9jd0dmMkY5MEUrbFBPYlZWQzRBZGVUQlZyc29PbjlCWnhDRzRtSUxO?=
 =?utf-8?B?anVyZ3paM2ppcTJlclVNSjBQUWorbFhDdDIvQVlzcGJJekwyT0p2NTAyVzJR?=
 =?utf-8?B?N0d0MU5sUU1UeGsyZXJySlYvNmZOMi94Sml4ZDJLOVhSSTdKQ0Njb05aTDVR?=
 =?utf-8?B?VXZOUnYyTGFNTWdnd2JJUkU5NE9UaUJXb2FBeTB1T25xUmFMdCtMY0E4dGhs?=
 =?utf-8?B?Um4vSkdONUFNb2l4OUJtUFo4dGJVK2JFVk5wKzdiOStlcm9LeGFlRVFzK0dF?=
 =?utf-8?B?aTNYbHU1TmUwQlVSd0FOeXBHSE5mQlowenV3OW10eG1vMjFEYmdDQTZZcUZT?=
 =?utf-8?B?ajhNWWl5VGl5V2N6YTBEOGJIQmJvaHZwQ0FBaUVPOWpoN3JwV3cvRC9jMERp?=
 =?utf-8?B?OVdlU2ZGZUtrUzBackNnU0VzaDJxM2gvUXpCb3dqL2dYb203aVJvVzhvdHh2?=
 =?utf-8?B?VGJJVXFIbEFFS1JIa2dKdXhrM0ZWa0tyMHNLZ3hFQ05aWkhneWRxM0FKNlFZ?=
 =?utf-8?Q?n3I5MnnBGUkATbxnu9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aafd9f4c-db27-4f1a-0235-08df286dcebd
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 14:33:39.7090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oT/XNCJTJTE1rpO5dN3tvgI5HeMOybm51jc9gi2a5ZSBTzUBtTF9GoKYg815xOEt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB613404
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8558F40014
X-Stat-Signature: wkbj1tyihkpioafbbazbpmtsnn9hr9zb
X-HE-Tag: 1791815626-723112
X-HE-Meta: U2FsdGVkX18qGAB1FNcuaAxGJo4IWpnmcDxh940NNDNvCtjlKBgjXLsT+JJMvP4yvnLRd2oAFzOyyz619N+J5fPSQB9SgOPCDvoVD7vkj+iGjf9AbYmrQEDrPBx0ws8slFeidEou6zn6gNkWd68UVkIkDKksQvf0HjS1IHn7oftYQJQWSpgJtAFwPvEo6iwssN8QBK8MG95JRAND17HGXHBfakdjFMDi9x8wVpXKGGdEACkDHXDSpO9TakEOqbvTBNk61qrIjZcOfwPzWrEq2wFmyF3lZj3hQE7FF/hpB1U6cXqDMvJbpkBu4r7JVrXnem5jOAZLuubDQbZDLZqeW2pDp2sD6uM1QvEc1yDw3Qq+0+FuGqsdS5boUzT4QXO2KjfCTFu+YeTtTQsbIN2loU8JD5OpLvsmDsNCrYoa3esmeGw2cXgUWgPK8n2B+jXr3Vw9ST+TsKTFB0lJsgXAXH5YxaJSvyLC0kkpaeZ4Xqk3h+yWXBiP1gwGHjuJm4KNXH4o+Q8PnYxiD1mtNlEB6BUvYMBfdmYVbEZYYfFyFPvK7MhHYo4g112qKZZKwk0OUeb6/sdwfC8eJnzMUBcU42x1CMTzqtnyjSeZ4eMeC45Kru3s04B1WLZZVmMK5npx9PNVVCUuHFr/x7nkxRGEz3Zb/vR8YI5aMWbuyyv3mddkAdBTn6gbsmEDEjC2K3DB34hozdUac5Q4mB2KFHYNtboZsa50jw3sEDIcZuY79mWmBg3wdw7Wk3VY5LEl2dBNhO+wozwI1TifsNdCA5lH548tTkdtqYVEXdAy70sWyNcuZM5mdxnvkl8Pvj+Xo1uomy+UmDImfI59pkIwqVX4fMwb1fRav6tTyIVIVT2xvsAzTXqA7d6FL2yzoIJBinnVXFjGttZuqVKsTbcYLtU5xHBCKP/BJNpm1+BcUgZtUdS3GoWv88D3c3m9qMJHej4VfIpwA/NvaFDBdt/0pc2
 CWzosIWn
 x5oL8+/HW4QIlMZRww420RipbFuzDUMbeUjQwJjJluE2Xys4xbARYonWzFY5qM/cP1DmVnq7YYcwEc/xSZg2yxpLI/FiCvrWcmCXnVtdMQWcxyhxh6XEBXlvf9gZHMQrAV4Zh94IWEXh3RVsa9TnH6he3Uiti98IcLJOVN5ioYP697Uhe3Yt32Li2vpD+/XVlzE14cVpgCBSdoL53Zg6nyO4atLDSluWzbUMSUrn6IIGTzHIac+TSK4t+zf9ckAsXpxYTGtKN3wDFGPzw0t6TL1Rissq5FiUoP8A4BMtwWjdDAwMGz2rYghKIfgpzHiEc5ZQYmawRojjN5TnU4+bS6nd9e5gamOHhzPeFDTXkmziwjLPyM3WSSlvUooFqJpuiTY/A9nEaaee6p+CUArYDT80pXo9ZAjH9NOjuL0foqBchBZpP+2FTNreIFuJfm8rCgXG9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Oct 2026, at 8:07, Lorenzo Stoakes (ARM) wrote:

> On Fri, Oct 09, 2026 at 10:08:18PM -0400, Zi Yan wrote:
>> __discard_anon_folio_pmd_locked() clears a lazyfree THP PMD before it kn=
ows
>> whether the folio can be discarded, and restores it if the folio was
>> redirtied or has extra references. A concurrent munmap() or
>> MREMAP_DONTUNMAP skips the temporary none PMD and unlinks the VMA from i=
ts
>> anon_vma, so the folio stays mapped after the anon_vma is freed and a la=
ter
>
> Yeah this seems pretty horrible, instating a page table entry under the r=
map
> lock is pretty gross in general, is there anywhere else where we actually
> _install_ (even if 'reinstate') page table entries under the rmap lock?
>
> I think this commit message needs to be clearer/more detailed though, I'v=
e been
> sat here working this through in my head for a while.

Sorry for being vague here, let me clarify it below.

>
> I'm confused about the locking, which is really the key point about this =
change
> isn't it?
>
> unlink_anon_vmas() takes the anon rmap lock so that can't happen concurre=
ntly,
> so is it _just_ the case that:
>
> - The folio is not properly freed/unmapped and ends up with a dangling an=
on_vma
>   pointer
>
> In which case, nobody can actually access that folio since it's not mappe=
d
> anywhere, or is it the far more terrible case of the above and:
>
> - set_pmd_at() in __discard_anon_folio_pmd_locked() reinstates the pmd en=
try
>   regardless of the fact that the VMA and surrounding page tables could g=
o away
>   concurrently
>
> ?
>
> But I'm confused here because unlink_anon_vmas() takes the anon_vma lock?
>
> EDIT: See below, I figured out what it was.
>
> Looking at the code:
>
> <anon_vma lock>
> [reclaim]
> < PMD lock >
> -> try_to_unmap_one()
>     -> unmap_huge_pmd_locked()
>       -> __discard_anon_folio_pmd_locked()
>         [ clears PMD entry ]

The PMD becomes pmd_none().

> 	...

There are two readers making decisions based on =E2=80=9Cpmd_none()=E2=80=
=9D locklessly:

1. munmap case is via zap_pmd_range() in mm/memory.c: it skips pmd_none(),
so the above folio is not zapped;

2. MREMAP_DONTUNMAP case is via move_page_tables() in mm/mremap.c calls
get_old_pmd(): get_old_pmd() returns NULL for pmd_none(),
so move_page_tables() skips the above folio.

> 	[ reinstates PMD entry later ]


1. for munmap, unmap_region() calls free_pgtables(). In free_pmd_range(),
the restored PMD is treated as pmd_bad() and cleared. And the folio=E2=80=
=99s
rmap is not removed.

2. for meremap, dontunmap_complete() unlinks anon_vma but the source VMA
still maps the folio.

>
> Concurrent munmap():
>
> <mmap write lock, downgraded to mmap read lock later>
> do_vmi_align_munmap()
>   -> vms_complete_munmap_vmas()
>     -> vms_clear_ptes()
>       -> unmap_region()
>         -> unmap_vmas() < zaps > <----- EDIT: the real issue, see below
> 	-> free_pgtables()
> 	   -> unlink_anon_vmas()
> 	     -> < anon_vma lock taken! >
> 	   ... clears down page tables (no rmap lock) ...
>
> Is the issue actually the zapping in unmap_vmas(), which doesn't seem to =
be
> protected by rmap lock at all, meaning that _that_ can happen with
> concurrent munmap()?

No. zap and rmap walkers are serialized by PTL. The reason is described abo=
ve.

>
> So unmap_vmas() doesn't correctly populate the mmu_gather struct for the
> range, meaning that the underlying page isn't freed and the refcount,
> mapcount etc. are all left as they were?

Yes to the underlying page isn=E2=80=99t freed.

>
> MREMAP_DONTUNMAP seems a bit of a bizarre callout, but I suppose it is th=
e
> other case in which (under certain, likely, circumstances
> e.g. non-partial/self-merging remap) an unlink_anon_vmas()'s call is done=
.
>
> With normal mremap() that'd happen via an unmap of the original VMA.
>
>> rmap walk uses the freed anon_vma.
>>
>> Using an invalidated PMD instead of a cleared one requires additional ar=
ch
>> code fixes. Instead, disable the PMD level discard of lazyfree THPs, as
>> before commit 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during
>> shrink_folio_list()").
>
> Again it feels like this commit message assumes a bunch of information th=
at
> isn't presented here.

1. SPARC has thp_pte_count-- in its pmdp_invalidate(), but set_pmd_at()
does not add it back, since the code assumes pmdp_invalidate() is only
used in THP splitting code.

2. GUP-fast accepts an invalidate PMD on s390, risk, loongarch. They
need to fix it to prevent GUP-fast from succeeding for this new
pmdp_invalidate().

>
> Why would you need to invalidate the PMD? Is the issue actually TLB flush=
?
> How does that get around the fact that a PMD entry can be 'reinstated'
> concurrent with a zap?
>
> Or is it that you put something not-pmd_none() there? Hmm yeah I think so=
.
>
> Doesn't all this cause pmd_none_or_clear_bad() to fire too?
>
> All-round terrible.
>
> I've not dug into the reports in detail, but I think the commit message
> should also talk about what exactly is missing from pmdp_invalidate() tha=
t
> is broken here? Are some arches not doing things quite right?
>
> OK reading the code more and it seems the _real_ issue is actually
> pmd_is_huge() in zap_pmd_range() right?
>
> It's the -> pmd_none() in general. By doing that, you are breaking a
> contract with PMD leaf entries.
>
> So you get:
>
> zap_pmd_range()
>   -> pmd_is_huge() ? [ no ]
>      -> zap_huge_pmd() [ WOULD HAVE taken PMD lock that blocks against re=
claim ]
>
> So using something like pmdp_invalidate() avoids this, because it keeps t=
he
> entry huge but invalid.
>
> But I guess not every arch does this properly somehow?
>
>>
>> Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_=
folio_list()")
>> Reported-by: Kyle Zeng <kylebot@openai.com>
>> Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.=
com
>> Cc: stable@vger.kernel.org
>> Assisted-by: LLM
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> With the commit message made a lot clearer and calling out the specific
> locking scenarios that allow this + getting rid of the dead code:
>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks.

>
>> ---
>> The proposed fix[1] requires additional arch code fixes[2]. Disable it
>> first for stable fix. The function will be re-enabled along with arch co=
de
>> fixes.
>>
>> Link: https://lore.kernel.org/all/20261009165214.40212-2-kylebot@openai.=
com/ [1]
>> Link: https://lore.kernel.org/all/DM0II2QHWWS1.2RXEJXC8S0101@nvidia.com/=
 [2]
>> ---
>>  mm/rmap.c | 11 -----------
>>  1 file changed, 11 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 805db93fe0428..1131b76bbbc28 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct folio *folio,=
 struct vm_area_struct *vma,
>>  		}
>>
>>  		if (!pvmw.pte) {
>> -			if (folio_test_lazyfree(folio)) {
>> -				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
>
> This is the only caller of unmap_huge_pmd_locked(), making that and
> __discard_anon_folio_pmd_locked() dead code, shouldn't we remove all of i=
t?
>
> Otherwise we're leaving dead code around.

1) it keeps the backport small, 2) I am going to restore the function and
this reduce the code churn.

I can remove the dead code if you think that is better.

>
>
>> -					goto walk_done;
>> -				/*
>> -				 * unmap_huge_pmd_locked has either already marked
>> -				 * the folio as swap-backed or decided to retain it
>> -				 * due to GUP or speculative references.
>> -				 */
>> -				goto walk_abort;
>> -			}
>> -
>>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>>  				/*
>>  				 * We temporarily have to drop the PTL and
>>
>> ---
>> base-commit: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
>> change-id: 20261009-lazyfree-stable-fix-67712b2049dd
>>
>> Best regards,
>> --
>> Yan, Zi
>>
>
> --
> Cheers, Lorenzo


Best Regards,
Yan, Zi

