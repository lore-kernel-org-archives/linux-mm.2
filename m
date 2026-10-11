Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B423FCA9EC7
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 23:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8D16B0088; Sun, 11 Oct 2026 19:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490FF6B008A; Sun, 11 Oct 2026 19:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7BA6B008C; Sun, 11 Oct 2026 19:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4BCF6B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 19:05:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2FF708080E
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 23:05:27 +0000 (UTC)
X-FDA: 85311878694.26.A9310DD
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011043.outbound.protection.outlook.com [52.101.62.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 49042A0007
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 23:05:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LCSICsy0;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791759924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLLSOL0pQFX3B6dreLozfjxpXmoIZAuc/ORptKE03m8=;
	b=DY1fubAyOrAvR360lXLf9Z4utEEqfsqY1+CoWy+n+hLxzk0PM3mP4t5ZpYAPuGmgXO4AkA
	jm+y6GNI5MjvjbY+N7DxuWaoNKWkX5KM6AGhBoxq7Ug9wLr66AGf3gEFFjbikkOzAS0Cqg
	5mI5odxkDDmXKpMu7eVp0TJBNZUxE6c=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791759924;
	b=IpwCeVz8noxsrxwaKkr7c5J3ql3BJ8sPb+q3OBotmD4BKm+r7bVyWeL+UKV0WC2BpS9JEY
	RyuLi7+GHdtfOTsfHGeyK49d4Kkh28h85VcHfDGpL4ZhDz7R/njoit0ylUipeO8QdenPOj
	JB4VO/wEWyiAtJqXXwu1H5UUqL4G8WM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LCSICsy0;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p8EhW7I0hkESBGbLTzn1CtqvxSm0hH9zYaXJ06LR49h2VnGGXwYPYYTQLQwyxlq8VNREDh0a064idccSPc08br5dUBhw/eJlDr/VWLyf7u2ja2twHfR2DgXweZWFaRRhxp9Q/GaRVm0g3qX59CAAFf0c0toNphG7zTiny5iirIlbtXYAt7EnmCLaUzUmymOBVz/ChxndDFvZkgFeCMp8sKGPt9KsoTzrDVdchi6cNkM1h/zMeKN8RYV5ZwDiHJtArkAFH0uw6dA0xiPVAQRWvW20dAeDGqteUS/2gw7G/+VN5JKGZJlWeAXiZucCtjTMmoMrqxSHFUHOErhMMn6X1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WLLSOL0pQFX3B6dreLozfjxpXmoIZAuc/ORptKE03m8=;
 b=p/890gg1eQaXE9RjsRFqACRqJYJByWox9wHFtJyaOVeoJQPA7p1T/cdLkTHJ/ueadzbnSnGxNlqcbCWXafv6tCKdngc7LNAADq8xA9rChzozRB32fcFqSHJwCK0jqrPPfYN2kGEuZuw0YBnY5nJNI+mGIyi/MY7BSPKnmt+91ap/TluD+g6kE+S9DjCFGNaVIoIBIZ+gCIkZvcsxbHd/y84kk0gmMID0QKteI5XC+8T3O7cm132vXWbOSHfKcX/hmzws6Z7HZ+yQQBuzoLzlkvngQaUGFu78CJUl0sY8QysoKJ1R5C852+EVqZEdzQfNAEtpEt2I7vRnz3Hf5RiQIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLLSOL0pQFX3B6dreLozfjxpXmoIZAuc/ORptKE03m8=;
 b=LCSICsy0LRBT4FZJmmGXvRVJ9Pl3WSK9+XQGmkGzLYmICedcztM/BYcp8HuWjdUjrjuTm/VBXTLqGQ+Wy3DDGd1N+IRpawAJUm0vfnEPU7eF77602IYUomU3ft+4LIvz/OO9N7s4uLzE09zjNR9kK5GD8LGhZpR3mPJFhTNs/C8BKS6jku5nXPpadf1vqc1Y+ds5GSNhqWarX1b0tIySp24bVq7T7tU+AEosY2TLLMdtnhVx/dLwpbFNA0gEbQLNR2Lj+tlnebw5R7XKxS6i0IGm4aSUd68Rj6snxUSDB1CihQHcbD6+veHZwPWQkKhk+fDVPJ2gLUYxXULGLmWtlA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB8925.namprd12.prod.outlook.com (2603:10b6:a03:542::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.20; Sun, 11 Oct
 2026 23:04:23 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Sun, 11 Oct 2026
 23:04:23 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 11 Oct 2026 19:04:21 -0400
Message-Id: <DM2DV199T6N4.19MU82DJBDOF9@nvidia.com>
Subject: Re: [RFC NO CODE] [DISCUSSION] Anti-fragmenting ordered buddy
 allocator
Cc: <linux-kernel@vger.kernel.org>, <ryan.roberts@arm.com>,
 <riel@surriel.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
 <ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <kasong@tencent.com>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
 <hannes@cmpxchg.org>, <brendan.jackman@linux.dev>
To: "Dev Jain" <dev.jain@arm.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261011215412.1181172-1-dev.jain@arm.com>
In-Reply-To: <20261011215412.1181172-1-dev.jain@arm.com>
X-ClientProxiedBy: BL1P221CA0037.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB8925:EE_
X-MS-Office365-Filtering-Correlation-Id: 95745c0d-e7c5-4861-51a7-08df27ebfd45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|6133799003|10067099003|18002099003|22082099003|3023799007|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	kY6br1wYw6yolfgBgnhdDysxQTtIIZIm8oE9paVQ5rpXRvCv/rv5S5tMFhLahWAbMwhYFTQllzlstJUp+EwfZ+KjWpaDhnZ9+G9m4i3tr9tNSMgPLi70NfiFXieUPBRdO9W02HxcQHs81ea7tSHlFF6WLtCtLODczia3JziMVN+LcK9m+qH95RfwJgD36erJtzBF/PZk/vu16QwgXvKLXdBJ5BHtIkYo/BXfjn3gMuAXnKPc1SwrqBMjg5uHy1BwYojxkhFszPKAwtCs+3nZUH2jWgfCm5XI+CQWRGlcJhsyVWARBAA9xcBgxHO92x9geshYxPVDTsE7B0UTY67Dv0f1m6Kfm1RoV6jO+yP9HTmRYI1krz8ye8p1IXePzErpLUWuE69ABaQt+SGs15yZKKIx1gwVnemk+AkfMCSK/JMHEPohVUF0uRdVBhqmNS3Fm6KAz4pFy6q5MM7Era4n5u/Wg8We4AKVwdBZdGQHwUClGJzoMFekp7Efq5y5jTDpyZywxO1E4uFtVBHUlSu+QQLpTovxbefIWqKaopjMm1L9eVFt1oZmTMf74+9UGmgGdKKLoEFuXvfqrATz9SxVC5bhw8qdB/YWGTAJqtfUFicb14Rs5SJj9xsuyikSctr4aPbNJ0aERmNMUHRrWcZy3NGqHU25o2BS4hS/NVtHEa4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(6133799003)(10067099003)(18002099003)(22082099003)(3023799007)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TENya085VzVkT0ZTMXBhUW5KOENXRURvSmwxUWp2NXB4TnN6QlA5dENDL1hO?=
 =?utf-8?B?R0V6QmRtQ0Rza0ZaaHRYbW5nUWFjLzBLZFJsRWM3NWtGbjZxTUVmNmEyaUNo?=
 =?utf-8?B?L1haditvYVFnTjhjbll3b3Vzbk1tSXphRkhHN0pna2grUzJqeVVqQVd0ellh?=
 =?utf-8?B?Nm16bEU5bG9tSUsrUllhbUg0OHlrako0eGxyVUtRd2VIM1Y0bU1xSXlxRkNT?=
 =?utf-8?B?NmdUOWFyOGpYbHRhbU1POUJlMXpPTmlzRXpHZHRrQlQyYVlncmhlS0ZhamMv?=
 =?utf-8?B?SzVrUXVLc0RDWmZnd0N0bjJJcStuWWxUaGFTSk1iNkNlYWRNTGhrZGpaWGth?=
 =?utf-8?B?ZlNiRHdPNFRoWXZJNW1LTnJxamVzVHFrdkxPdHAwdlVwWGUwMDVpRi9QYTZi?=
 =?utf-8?B?NUVuNCtMSmRweXh5S0dLSTg0aGRVb1JWaFA3Y2VOdUZXS2lMMmJ2MjJkUEls?=
 =?utf-8?B?a2dSazdTRVl6cEV3ZFBSQkJIMUlSWGR0RzVZQ0hLUEZ1Z0w3VkV6MEltbkRy?=
 =?utf-8?B?b2dhdmU5aWxhcG9EOGxkRkgzTEdlSEV0NVBqbWFzb1ZSRFhBWFNXV0RwY1VX?=
 =?utf-8?B?ajRzNnZqNlFUR0Rma0hraTZVUW90RWRDN3VrTU5NL3g1MWN5TUgxQUxZQk4w?=
 =?utf-8?B?K2kwSTErSVdvUnpzelU5VjVRNkk5YW5td3c2U2tJa3E0YkFkdDlWc1VoZlVT?=
 =?utf-8?B?YVQrUmNnZU12aXFzNXl0MDZqTzFtLzZ6VGJ6ZmdocWtzakVxQVVic3Zra1V2?=
 =?utf-8?B?NC9ENE5qTWJWaklINnhib0ExOVp6Z01ldWdsTXY5eTM0QW91QnNzNHV1RDU1?=
 =?utf-8?B?UHhvNUdUL2RuNW5yZlVSSUZjV1NEc0tlZFk5QlgvZ052TFpIN2c0eVFwT1g1?=
 =?utf-8?B?QnVkTTlXUkhTK3VrcmQ3emtWK2s2REo3QkxPSXN4ZWFmQ3RjMVV1MHJIQU5B?=
 =?utf-8?B?dlpTYzByMm4xUTdSQmJEZmtycnpkcEwvVHQrUW5RRFVKVHBqcS9aZXBXbHhU?=
 =?utf-8?B?OWIxMkd5czRrTUpVQ2VtbzhGTG05YW1HTHZtR2pNK3dVemN1d0oyZDRvajVR?=
 =?utf-8?B?UTlqRFR4RFRXYXdpTmN1MUFyQ0Y1QTEzMjN0ZjBReEVKQ0N3WThKTmtwRm12?=
 =?utf-8?B?V0tYeWc1MVd3blNWcElpTWJqam1KVjMwcFAwKzVJMGk5Z2lOTlNsZDl5MUUw?=
 =?utf-8?B?MEVXK0pndWdabSsyeFd3SVgyTW02ZWVZWFBYalJjSHRLL1kwczQ4SkJHbXRM?=
 =?utf-8?B?U3FRblNoYjhIWEIzb2VXWVd4M2xWUmpLR1NzVWZqaExYYXJsRXRVeG5Fa2Jq?=
 =?utf-8?B?OGV0Ym05RE5Za0F6eHNYcVRwSUFLWVJGeGlFV3Z2NzhzaTZvRVpPRUNDVkZR?=
 =?utf-8?B?YjdWZnRJZEhVV1plZU5jakFyVHd3L3lvci9UYyt5MFVEUEhrZE0xNFg2UFBU?=
 =?utf-8?B?QWVvdUd0N2FrSHNzZ3UwNU5OSEhncThJd3VZSjBVMERsTHJRTkQ0TE9tZDQ4?=
 =?utf-8?B?cTl4TlNSWlBxN0dSMUVLMUdJRmV6ajd6Z3Q4akp5S3JUVkRCTEdyK25idHdY?=
 =?utf-8?B?RFVPMG95ejNadkh2Y3ZvNUlMUFVqZk80OFBmRmlHSTFhOWlFVjlCZ3cwSk5S?=
 =?utf-8?B?NXgzejdSOG1hM1BrYVFZLzVabHI5L2FYeEFYbHE3UWhscUdRM2xqaitDWExF?=
 =?utf-8?B?Z014N1IwYUpxRStMKzM0dFRuWUhDQ0w4cTkyNFg5RFR5UVhWTXI5WUxxc0V2?=
 =?utf-8?B?aEhXbFZaQTFsZjlpeTNYaDdHTWd1Z0NTSjlDSk56RmN5SWkvRmRxSzVDY3hJ?=
 =?utf-8?B?V2ExZHp1OUg5Z2FhcGh6MzhRcXAycEpZTnYxem9iR2FEcGsxUVh6MjFqaEVU?=
 =?utf-8?B?UzlDTjlOSmxCWS9GcUlPWXJ5MURRdnFrS3QvUTh0L3dhcnhXUEpBUEMxUUh1?=
 =?utf-8?B?bUdFTGlEMXZlZFhpMHMwcFh2QVYzcmZCRkVmMkZxaVovYVNrS1VjZFljbWwr?=
 =?utf-8?B?Z3Rlb1h2dkluZDEwanRFZUdJNUdQM0NkYjFRUWFxUExhL2lIUCtMSzU3d3Zu?=
 =?utf-8?B?Wm5EU1k2OGZXSjN5am9UM3Nha01qRnFuN3FKZlhuRTkxNXdURkVXTUg1cmhD?=
 =?utf-8?B?aG9xcHZDbEJEdUsyeVczakZ5blRBREpGVFAyWC8wUzRMNndrTUo0WDMzSnhW?=
 =?utf-8?B?UEdzZWlOL3FmVkZ6ZU9ZdVk1dUczaG43UmIwOHJZLzcxOGNiY3piTTRmbTJY?=
 =?utf-8?B?WGswL3NaZC9JWUhCYk92anZRQm5HL0JLa1pVNW9lYTJMNWRxam1XREhXUGlv?=
 =?utf-8?Q?6FWaWp+5tPmIy9yVId?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95745c0d-e7c5-4861-51a7-08df27ebfd45
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 23:04:23.1318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NLiRjP3mge88O/0jVM/hvQHL3ZnZVeTQ2nrEvIigXM+y1AO1TmC2rb8MY0jDjMn4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8925
X-Rspamd-Queue-Id: 49042A0007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: shywmsukt9wqb95ksortk1hxapgtzbhw
X-HE-Tag: 1791759924-346022
X-HE-Meta: U2FsdGVkX185rxALe/d0WUalYzgTQTkxtbyBtUFQgAtKpK/AvVCESt4p+V2LbKrKolLn3P7y9+wZLMqrbymaOYDXCMnkxFS2rO4/hARBG8HmJIDCocXUBDImr2u7t1z6VPojZolX/xe4+mJMavtdO14mK4lCsFbKx6G+brEFi/444MtsySsAy3ttRuRFlLf+3PPYgTv4eStRijv95xKKdhv2C49gmu8GYUILiVc476K43QhDdlbhJfPI4F72Pzqp0WPpWxloPo5JKAVFuCjd22OwrD4LnBpOZg9sGASn0Q6PFTaq+HS4fY8bZOdZjNb4YyTUwWyvg8kNmHojGr9lfMZsCE2ld4i29CMRfd1uLc5K/JjNTMMa+RxdoOvaMMDOc35DqmUslBumMNTomowCq0oOu+W6aYvis5iFAPslXsd/KxIcFdLskQfovG/GltRLUmN4L05U0gHLVC2WNaSmz/lT0j4AbColrstyYHFFmCr18GAeHfgKQPE8ZhO5jS41zn8cxfNDWHURno3F+DX82Rd9qniouMSNsUP0aT4RIrG3Wmej+fpFAEOsn1oiA46WskRjjDYTR2r8WYZdblINToAmtfkgo4awCXz+VaEVs3E75Mfzy12TwMv/SLZoyJkr7Miomw1ojRHBlNiWtNwAavcJxVeXBsa+c0glmIoW6Vmj7o4qcVUOGC8VIp4yalJkjvQs2uNUymOqiQ4lkiU0Pcf2L5HBSClpeA6++px6MxxsplLuYvq6d/WtrAkElYEe9gmUwHuybJyiuSVYKQRx4wVoJjzXM7hG2P83+V5+8f5b1eDE/sQ3KBYtZ8J5LiWXIYdb75Y5R93pxxrfbQ+CYCFaAYqKAoQRdZ2G6L8V8qJ6CxZA7ns26W+NRKFZ4w01ZQTnKu/fiam0DklPFPcL04n+nt9V/CPjz0PWwIUBE/w24NFfL8hQjz1huR0CWh11iijDr8MHIZOmjhEumQk
 KZretTE4
 LQDiJ+IV9Yw2ErBZLvnp2Fmm1lKcNIURUdEJKlRIzxkxqkEa7hxAOW4VApqdA19CjuSedWJXPx/8lsQLR91lUMavP3hnK1gGDCJOfnfao/t/+KtRXw1Yc8TFAlq2IwAVPLgsw874a8KIBZFPlYkFpVL9I4n37U1ehCFqPynv33P8Qv/P8Vbu7bePH+GKF/PN/Q9RXZoxYXcUDl/bS0oaHzSuWyqP1We7yl1G6DswogVjb24gSlaK8RvQ366emJ5f2rgwuHBjLtxu5abVsos1Praa0OJhgpASOuHoL7f36HdMQbwRhwGR8SemGZ/Ed1GYJ+vAGTYEbChMYNAppm7tSFr1oqjkzSzQYc4jxqnHdAkoCKloVtt9oreZF+N5MRA5TLJFB2DEBXPSnKtzP7VfohaMgM63ocWPKQMsihb8TZNJLqyA5MVigwSL09GfoEyMnMQ7Ywx5YKUEYPRboASpd0zJPPqmxXRfcRPQXecEszcUpuivrhFltqRc0nktmx5iovh3pu/RylmGbUzDNQB2NcHdNS/cLYPIWa9zVg9EZmiqnDrK5IcbcjBWthg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Oct 11, 2026 at 5:54 PM EDT, Dev Jain wrote:
> (I am not posting code yet since it is in experimental stage.)

Thank you for posting the idea.
>
> TL;DR
> -------
>
> I am proposing "ordered/bucketed buddy allocator": we divide the buddy
> freelists into buckets, and prefer lower buckets for allocation.
> This reduces external fragmentation (and, further reduces it when we
> reverse the ordering for unmovable and reclaimable allocations) at the
> cost of regressing the alloc and free paths, which depends on how many
> buckets you partition into. I think we can partition into 4 buckets and
> do some tricks to remove any regression.
>
> Design 1 is the simplest and the most upstream-friendly method in terms o=
f
> allocator speed. Design 2 tries to scale better with the number of bucket=
s.
>
> INTRODUCTION
> -------------
>
> Apart from dividing the freelists between migratetypes, little attempt
> has been made to change the algorithm of the buddy itself to reduce
> external fragmentation proactively (termed as "anti-fragmentation" in
> academia). Linux has defragmentation (compaction). The analysis below

Like Rik suggested, it is better to focus on one thing at a time. I
think improving anti-fragmentation at pageblock level is high priority
at the moment.

> is *not* to claim that compaction does a bad job; I just took up the
> challenge of anti-fragmentation (because I like to torture myself) and
> kept digging the rabbit hole.
>
> There have been academic papers about replacing the buddy with bitmaps -
> I did not want a hard NAK from upstream at any attempt to do that, so
> I preserved the buddy freelists.
>
> IDEA
> ----
>
> There is a correlation between allocating from one side of memory, and
> reducing external fragmentation. Biasing on one side implies the
> probability we fragment already fragmented sections is high. This may als=
o
> enable smarter compaction by directing the free-page scanner toward
> higher-address regions. This also circumvents the discussion around
> a "fragmentation score" which is dependent on the size of the
> block we are considering.
>
> The idea itself quite obviously improves clustering of allocations: I
> observe reductions in 'compact_stall' and 'anon_fault_fallback', and some
> large improvements when the number of buckets is high (like, compact_stal=
l
> going down from 4000 to 5 with almost no hit in execution time for a kern=
el
> compilation). The obvious downside being slowing down the allocator (whic=
h
> needs to be tested more widely). The content below is mainly on how
> to minimize that.

I am not sure how your bucket idea is better than the existing pageblock
design, because the biggest issue in anti-fragmentation is unmovable
pages spreading across the entire physical memory space to prevent high
order page allocation and I do not see how your idea could contaminate
unmovable pages.

Unmovable pages can sometimes take majority of the memory of a system,
leaving the entire memory space fragmented, for example a burst of
dentry allocation. Roman wrote a small userspace app to do this [1], and
you can give it a try. Afterwards, some of these unmovable pages might
be freed after their use, but there is no guarantee that the freed
unmovable pages can create contiguous free pages. Unless we do unmovable
page lifetime prediction and group unmovable pages with similar lifetime
like Yu Zhao proposed[2].

IMHO, pageblock is already acting like bucket, limiting allocation
range. I see each pageblock a small bucket for allocations and it is
better than growing allocation from one end to the other end, because
the latter means unmovable allocation can keep pushing the boundary and
the boundary might be able to move back if there is a long live
unmovable page sitting at the boundary.

At the moment, anti-fragmentation is only preventing mixing
movable and unmovable pages in a pageblock. Rik's series[3] is doing
additional work to keep unmovable page allocation within a unmovable
pageblock, further reducing fragmentation. That is probably what we want
to get in first.

Maybe you can compare your idea with Rik's series and tell us the pros
and cons of both. :)


[1] https://github.com/rgushchin/fragm
[2] https://lpc.events/event/18/contributions/1779/
[3] https://lore.kernel.org/all/20261007021250.1665929-1-riel@surriel.com/


--=20
Best Regards,
Yan, Zi


