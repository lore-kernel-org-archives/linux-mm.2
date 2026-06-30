Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE30C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913466B00A8; Tue, 30 Jun 2026 15:05:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C55C6B00A9; Tue, 30 Jun 2026 15:05:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB746B00AB; Tue, 30 Jun 2026 15:05:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5554A6B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:05:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA2641C6260
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:05:31 +0000 (UTC)
X-FDA: 84937507662.02.BB05101
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012024.outbound.protection.outlook.com [52.101.53.24])
	by imf18.hostedemail.com (Postfix) with ESMTP id D4ECB1C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:05:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="S7d/8sBw";
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782846329;
	b=uaPxxQ8ZPpDK2aYdNkuZ3Y+RGkpYrTcwMBIpg47p+x4rw2q4b0Dn4sCO0TSXwN4k6e05ZZ
	Xrx9WGIhOViETCmX9o+QHBkFeuLS05qAoveSEBYFBF9FGciCeodM9lfRVj911c6zrLVSrb
	fUF3Kl5RzXZ8WyB8J48pYuDod0+zHo8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGf8i/tucmRynxOhf+ZY/2YquKPy4+BbWaL2SgcFaSw=;
	b=AC73RR2FVzVC9IpZgtoFZYt4HGIihkEFFk4p7Ua9y8AGk+HJiMBNoiIEhTZPFQB2ZH05BC
	FthdkaIIa3nmkj0w96j+L/BIunVmRTfNg8v3IMGaSgAZ75FF7xNRf0tFdz01dSTg+n+ADU
	04i+aoclx+SW2I049kx88Ng8SFAOIaM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="S7d/8sBw";
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G75jWPn8Vjfd1RGmZNnJw5lAGjUv7qMgExvfROwhGOtTP+jxk8LrlGPJlmC5Kx5ZMpQDrgNYgFPF3DLuNpaoClCW0YYbCbZtaqcl75/TsLUlFDm/zpiCAH/NT7sCilelvjEOHhU6Lw7Ud0NzUc/Xby2ikU63kBNhSILbJ903xnIOHuKScaUpBaq6WWiXTTURntkR4T710bOOwqjedMuns6eChyi+fXRyT59Tf+o+CW+L0hTAYbcTtme9E45pqWeVXriFh8MZa5w+24LoXc3X3Up/ruRdtLe3MDyDszen9Qku6ft9tXnjHJ8uNyaO6jgkj0K0B8su2FhXbQ1q3EEm7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OGf8i/tucmRynxOhf+ZY/2YquKPy4+BbWaL2SgcFaSw=;
 b=OoAKgswySqSp9J3/8siYlXc3gjhf8IeBC8PFsqmLprsg1fs179VtqbRxrfxA8fJR0C3XNPuB/rQysV1YIf/9IUkNgaLgTZKhF+YHxvcpSAouP906KbuoJ21MSQ6UI9PJA+Y3tAKMRY1cF4LhTeghI2DhC1mXoQxwKd5TtnqrB4VIcT2AFhUHTmFnWM7e3AqblfO0ebP6ZZZnAbfcdu7CnBuRkj2G7Uj6ePzjhfSG+/36vbap03MjvqtVji+NQkrxnLmX418xfonX1mvIH6wUFuudyP8CCVKLFb/imqUQlqubgqWFGqtUr9/WCDF2T/pKgxQ2tbf9DrB8iUU2446Wkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGf8i/tucmRynxOhf+ZY/2YquKPy4+BbWaL2SgcFaSw=;
 b=S7d/8sBwDD6/zbH2CW9NHHZTVs+kUizC5lNo3UuMEK8ggjZGH2MlEU615oeUncKJEkgsgfxSzlC+hHyGWIsGU6GEgVZh+EZ3/URy61pKD0joqciEVLgWRakT/vojgpDuQZ1e9LQeEOV+2VErHoICl7VnZKIkt2e0+0nc/1CIBnEFHEb4uzvq5PtWpyNuS6Th0tv0O6+tkb6IGSNLjJwaSi/RwvxwQcR6o0ntEoTZZjfcvZRybwZZcgYA0rJQnSrYno/Jh7fPJZ9tFJyPLM2dxZpSmxhAhqFH9effvSHDaAQGZhd7Cnr0C+z363pf9m7y6BjJjKRiXKotTiXnQ5WpCA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7524.namprd12.prod.outlook.com (2603:10b6:610:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 19:05:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.008; Tue, 30 Jun 2026
 19:05:20 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 15:05:16 -0400
Message-Id: <DJMM9V4Z58QP.2DXAKKZ4YE6HA@nvidia.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Cc: "To: Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Cc: Jan Kara" <jack@suse.cz>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Song Liu" <song@kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Eric Hagberg" <ehagberg@janestreet.com>
To: "Matthew Wilcox" <willy@infradead.org>, "Gregg Leventhal"
 <gleventhal@janestreet.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com> <akQMy54dxVTVkMJ6@casper.infradead.org>
In-Reply-To: <akQMy54dxVTVkMJ6@casper.infradead.org>
X-ClientProxiedBy: DS7PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7524:EE_
X-MS-Office365-Filtering-Correlation-Id: a527ec0a-0a1a-4ec2-edb3-08ded6da879d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	jwLvBzNnEdVPcbnZiTDzIW4jkYppH/dD+18cQPye6s1HeRpasT4i2lF2BUmxUDbK0LxhjTuQtdHfc7cOL6V+M7u7UwIuslUGairnjvA/+fhW+eTPyAyZMmQEXCH8ZXxjodBJGghtnOcanaIS970sxSV3smeBI4QvMDVCqdmEywm86035pOw9eAl5lDsOQ03GEmP4cn9+PIk61Hv9EW4SOiCL9mbi99YXKbz530bcz41QO/NFBNbeECt8i+oa4WBdKx/6Qo1iMKqlpG5+anIC2JjeMELQUo8/sOzm7waoBILvVZjSav33UPEbwr3P/5Az1qtu1RbMBFLHG35bcDcOiqJWhVIJiR9r7TrGgYLQ9hQ3IoI/ZSCJs2+KC5d9DPXiDfaH7ZwvieFQXIZPEJVxVotQl6C3Tch14lQJYKv/o/GVH22IrTE++M0ihptRt8Kcs164hGZs1YhItDNwvxmS65GvAaRcrRtsyTgSvxscuJEbNyPOwYdRu2favX1V/STVslKqS0ZUseaEesAPY9LQI+z13BRxAHQRSMMHHEGQy1tg2YGaRt4h2XP+3F9oyl/PO4AKmKI9L8avYmhiIR4CKAseFeFnrz4zYEkEWmea/y8LS7y+5gYjp1Vg56pbP5ww6KBm78HlU9l94XSDmCRVqWGvLeEWyIZjIGR08RfcQVw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVpQWkhIWWZ3Sm9aZUZVbDdGQ3ZJMTBBZEV3U0ZGTmlFNjJyQTJlRTdnZXNl?=
 =?utf-8?B?QlR6SkN2UThFdjZ3c0lIdHQ2NC8vMkdDRDN4dlpWYWROWVo1SldNZVVkTHFt?=
 =?utf-8?B?aUUzZG5wV0pHSnY4OVVZNU8vQWh2SzJDOXNwdjBjUUZhN09wdHNlQ1RUK0RX?=
 =?utf-8?B?a3ZDblE5L2h1dS9HWVZCU1ZyeWJLL3lYUWp6alZtZXN0ZUhpOFA4TXB3ZUgx?=
 =?utf-8?B?WlNnTFJUdnFrME5kMkdzNnlFT1BFdzlmd0F3YU9lT0lqS2dCNmFJa1BYb1NE?=
 =?utf-8?B?L1RlN0lwTDhWODg5VnBEMHo5dE5aS0M1SWpianpHdVE1N2ZyTXlpVE5vV2xM?=
 =?utf-8?B?aE8rZ0xkSlJobWhoZE1IVmJFQSthcG1wSW1ZV2ppcFVkSVh3MnMrYkpHaUkw?=
 =?utf-8?B?REROM3B5QlBGY2x4Q2ZRWGJaTTZMaU1sYzBjQlR2WEhVU05DVFFBb3lWVDdY?=
 =?utf-8?B?cVBrTzJwTWlJMzVjbUxKVG5XV3JWcXVMaWErZXZsN2cvRlc4UHZnLzdjaTh1?=
 =?utf-8?B?TStzTTNCeGRBdnhhN1dtUUxNSTU4L01JWGRBUlg5R3YyYnpPR2dlYWF3aW4w?=
 =?utf-8?B?eTV2QTZubmk0OXB2dkNILzhDcnFhbnNSNkQyazd5NG90Yk1RWWtidTZHd2pz?=
 =?utf-8?B?Mk9nRENuZDQyQitmUnV6aE1HWEloeUlTR1ZmcXBnbnFKeE43TjlvelJLRlpH?=
 =?utf-8?B?V09aNHJGeVhCZ2kyMHVpczMyTTdLNk9HWjluSzdudDBHaGxKQ2tWczAyWnNv?=
 =?utf-8?B?b3BDT1dTQmNWVllkSHRoeXZqTjRMbVpxR0I5RzB1WHQxaWwzTDExUnRMdGNF?=
 =?utf-8?B?UGZseGhZNTNVUytxYmVHWVBsZEtQUDBzVCtJajFWMDBNQ3NtTDJrNjBFb05J?=
 =?utf-8?B?aGNMdm1kN1JEQlRZU3pUNjJjTFR4RmpmUlE1cFhFTm5KaGJ3b2Q1UjloaWxx?=
 =?utf-8?B?Kzk1RHhtQzNidTM4K3F6K01Ic3lFK2Z3VTVyditDWCtjeWdvRUZrTzZKdEpO?=
 =?utf-8?B?R24vNGVIUXhBa1ZiUHdOdlhnUjIzcDd3Y2s2UTJzanpmS3Z3VyswakFheXJ6?=
 =?utf-8?B?aXg3SGJZanVwTitkUi9RUGJZbVBiV3pEa054c3VjRUh3TXc4akpic0pSMSsx?=
 =?utf-8?B?clg3R2Znd2VOOGVFK0lhSVVCSzhrMURlV2ZmWGk1TjRqMDhHQUxsZHlhMUNo?=
 =?utf-8?B?VnFEMlRuUk1SNmdBUkFIbXVtcndDUlFQNWdOSDdPekR0L0dHMmFEekdtS2Ex?=
 =?utf-8?B?b1Y2M0VPdHZ5aFFtaGl0YjdHazV0NnhMaFJJdFgzZ1V5WWdhbmtsTVhMRDZM?=
 =?utf-8?B?WHQwcnQzRWMwUTN5YVp1VUdPMS92YnkrWGo2RE5RRStqTHNDVGFpUTg1SXYy?=
 =?utf-8?B?UktEQk9BV2xSNlIxc0pJRTJ1dGtWU3pTL2F6VzlhYXBBWk83dXg5R2tMVGt2?=
 =?utf-8?B?Tm1hZlpjYjE0MThZNE9JVGF3T1I0ZXordGhPNXBDaDk1eDE0dUVqdkJKNU1i?=
 =?utf-8?B?S0ZCVWVxalNiY0R3N0VOTGpvWEs2RENjTWNtNmNZZ2UxcWlJeUx1ZVdYbHRI?=
 =?utf-8?B?V0ZxZDVjV2tQOUdZMU9wSlNoTmRqYm9EQm8rcEZzbG1ObkNlQUN2NjM2TXB6?=
 =?utf-8?B?NmRCaFQ0WW4rNUQ1Z0ZBOUlGNC9ZSVJkUmlESjdPbmppTmMzUjhZblNEcHF4?=
 =?utf-8?B?QXloL3VoNGVCalF2dnB4QXlZcUVBbGt3cHRIUzVBUkx1Q1IwOHdVVVJVK0FN?=
 =?utf-8?B?NDYzTnVCRkJQbXhtaG5meVlhT05YRm5WYkJzdm1LcHQ2TEZadWNoOENMZm5L?=
 =?utf-8?B?eWhGREo1cFJQZ3BGdmJDQllHREVFdzdpZ2Y4NlFDT2JMN3hOdi9jNC9YWnJQ?=
 =?utf-8?B?MDFmMVp6RmpCbnNNWVlEK3VVRlFMUy9WdUIxeWwwUTQxL3BNZ1ZlY2F1NHNv?=
 =?utf-8?B?WDJrTHNnMk93Z3FrYkFoYWhNS3pnYmwvSXZocnNVMlBCekRMVkZtTStoTWdl?=
 =?utf-8?B?NHpRM29hczE5ZjNyVXFId1lROVA0Q1RCVnpBWGNqMURXaTkxYWtXMGhpT2cv?=
 =?utf-8?B?ZVQwS21OMm5aRVZxRVcxTVBqaXNwbmhXakxPSDZhcFpFWVZ5YUlWcVVpalBr?=
 =?utf-8?B?eTlqRGVZOVZBd0R3ZS9qZ1FPT0V0bkdCelBtYVkzVWZoY1ZHZkNGNGF1K1ZL?=
 =?utf-8?B?aVVPSnFKbVVhZUozR0QrOFI5bEx4ZnRwUjlVSmJhS0ptS3dtVzBKWkFOSDl6?=
 =?utf-8?B?dE5mY0NWUjhKb2RkeVJlZUM4Q1d6RW5BUXhtd1FMbHk5eW1pWVp2TVAwVXJ5?=
 =?utf-8?Q?7kW04gU5i3Wy/ftC/X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a527ec0a-0a1a-4ec2-edb3-08ded6da879d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 19:05:20.0943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HEH8Jco0Pqg5LV6lkoqOoZV7E60locBELZB/GxCUrnMXD/jZmnVSiOog80ZHV1d0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7524
X-Rspam-User: 
X-Stat-Signature: 7niswjod34d3wf1pren3fdg13z1gd1h3
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D4ECB1C0003
X-HE-Tag: 1782846328-505589
X-HE-Meta: U2FsdGVkX19GDtHGX0RtzCd103MTgWbbQyQwhQPquF1Si5Kumrb74UG8ocoqnvIB9lxiUtcfr32ooprMT0jO+hQasEq+7YN6n5T89yF2IPAIi99CYxDgCxHgx9Mmdq2rDi6LinGcxFMZwHT9UacOm0qd5lC2hKVLvVGps50GN4O8tLkSDRm+j7pz1fVFM7/REeDLn3pe3Bu+mev00XYYF6chTfCd5iVVMbwA/yotFRm/knZUqj7dg4XVy7h78DYGz4AjaIT7cgjPZFa2da+MXGPq5ntAG0vWZs8h9BSklE4hm1R3CTz6r3FHGIEMRX6g+lAUV3RjazsgV1pIgQSrFZe8dUQ93s7R9BYPKK9zv00rLwr4qgXfT+r2DYaMg3tMPk+hCM0PI6bZBQ6bm4+nTsBw1jc0gLq9HkTTuG3KRrancel7AEeI+oQrHgBY4S1r4CnXDjHeV/xNALvRTV0z/LNlMMVvBRr0+TCdKlkEuNCM/ZaYetFu+pvm6CKEABtdLz4z/AQP86N7rCOityHYL+IoxrUgDM/hsKSXeBdYKVkAYW6w5bDeujPVd/FTpQ7so8KCn3HWhMr5qBzQCk0a1C/9IGjwlwP2Xi8hsSPeb4M0I1o9uyoRV5wnkSNZTZrqFYUuRLA1YjmpszpAaed3OswdjQXejOInT9BsaM1gTO449bfm6S/FlU3DhkqAho1g+k6EzUjvQK7LBwgijxgXfpOyLo98z2TvBbdorPoo5dz7PZHO74UwuzoAZ10b7WULfSuaNYtbYpE9eDt5Vz5Xg+/fOAErD3UvKySRu/OwnI73uhkFDCBwBHkgL0PKtzPLuZWPFr8JfHsvkV+udWHRVVFuOMRtBw1OmvPyIBI5zDwcV15ZxD/L90FbsUB4lidgNC5mgrctpx5yOlwgNyjuJGzvAq//Bi5VQ5sUSRYmamdTkRJUHFIbPyQMq9o8mQv65vzhW783lWfkjyNrjSr
 jd0QmNte
 QGNfl/nxRxIHx2f0b7u9URYqaqWNrwxX/VvdfC1IWDVjfhU9e3OzhAUAwtWOUAMbIofkmrioJYQvB+Zgr0GdafPQoEpelugDbh2w12S5V5Kt+VgMNqkpB3gdRey+UixWrvbAMgVe2rLyW1pA2bW4GnS2j0gow2k4dX8y8oHuv/6Zda0kzDYCpHh4WN2I8kpnJ+av3y7IDrhBeGgpFESmpenOFcE0RKtTBnmsOES5xRxrVI+IB2/oBMPl/7uALSTkIBfKfw2246v+e+8M0FL7SAvfVDx6pGx+JCloJxAwl/TYzaGt3PqA0GqG7vUihxffZA70TLSAHT0L1RtAcuFWZ6mPvdc7HZJkkaW/7MlFL1AoPb18MtwYWH8zYPcLPb4vqEXbIl+mFHGFFEqZYFs4E6sDC1fm0WbRyznkN4E5MNbbFxT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 30, 2026 at 2:36 PM EDT, Matthew Wilcox wrote:
> On Tue, Jun 30, 2026 at 01:01:53PM -0400, Gregg Leventhal wrote:
>> On an affected 6.12 kernel with CONFIG_READ_ONLY_THP_FOR_FS=3Dy, a file =
can
>> contain read-only file THPs installed by khugepaged / MADV_COLLAPSE. Whe=
n that
>> same file is later opened for write, do_dentry_open() notices
>> filemap_nr_thps() and drops the page cache:
> [...]
>>=20
>> This is unsafe if the mapping also contains dirty folios.
>
> But there shouldn't be any.  It should not be possible to have
> dirty folios and THPs in the same file unless the filesystem
> supports large folios natively.
>
> If the file is open for writing, the attempt to create THPs should fail.

Maybe he means order-0 dirty folios?

--=20
Best Regards,
Yan, Zi


