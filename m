Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA73C5AC67
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 02:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5B3E6B008A; Tue, 11 Aug 2026 22:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C6A6B0092; Tue, 11 Aug 2026 22:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD67C6B0095; Tue, 11 Aug 2026 22:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7837E6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 22:04:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFD35402FE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:04:27 +0000 (UTC)
X-FDA: 85090972974.22.88DAF3A
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010017.outbound.protection.outlook.com [52.101.201.17])
	by imf14.hostedemail.com (Postfix) with ESMTP id 25401100008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:04:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=popfEluw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786500265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YKK7uTT75oPzBHRqjSYbadiFWeTrJ08UJq/8WzoFFgU=;
	b=P+rbN1qQ+BbCQVHSyZGczKGDSOuc6k68HCeRGyI18rAgl6rbsbCjjVuRqORtVQrrMgSEs3
	vmsthCIjbxw0slEDvqlecJ2Ebmy4kvEiMWU9qqnsj05cogBKcEBJeYZANlioGliWTfJKIU
	fXppslctHcllgwg6uDFi8saGuqf8mDI=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=popfEluw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786500265;
	b=CWmrX4vgdVOCcVH6TmUCtIBfSw2tQfpa8QAuFs2mQVLJ7AZ24JpSQEbyT30FtaLQQgZTxB
	xTmbL/fKnLEujAAMfeqAiObX7bnBEZFmxHIZTN3yjx313PDvAVRMW3ewVCzOBBdZeAwM75
	dlBVOBVMAEF7jJCUKB5YCN9gI7KwbQk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AJV8XGzme7Ijts+iP6mOKd9Y05VlkDMQ6M2+ZKJXXwCdR6NMLw6rofhDu3dsitUI0hr0w+aGmuWeW/GCsanu3hurQglejxleN2tPVqs5ZtrdmmqB1aXIqenKPPtycamAH0M5kvKypoxGMZRCENq3RSwpMDxAXrB/Plghm5C9LmHkl3MYtp+VlCqyADAPgAI/v3kTaCMlOg9JEE3GOqVibUe3my6I3ShvmDa0PTUXpMKB3KxcAAXmu3dXAUcrTtsOiv33m8zhSfsvwfy47/FF7G7B6SpFNQONXqpqo15E8AlGFHvmH8q2lsa/pVRtqT974x/JtNC1V+ynIFO2AgYRrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YKK7uTT75oPzBHRqjSYbadiFWeTrJ08UJq/8WzoFFgU=;
 b=nQ9KneeAB/p0QV1c737eVrRcdir1RTScvITkOjeNtRr2NUMuK54HSlpn//CPv79GcJ0FM/yKGqsQ/my02wToUheoW/YbuC2OP9aVixVkpPDhVF91d3JCzvOQuvODbX3IA0URifniREoiLwDsceG3YBL/hMZ6GM3hv4KBQdJ3FCIE/wyh3Ak1mvceECtxe9NrSXPj8HFxwZ8kToVlir8ijjrzG2WJfWZKllIzz2VNY8519KiRLfdVQaAEd4Q9rRe5IWwGujxDLS44+XoD8Rq6n/UGCpev/onpvRMU/n98iNqb4gxGdP/OCMj84AujgC8aGjutt0TfLqoK6Lt6kxhXVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKK7uTT75oPzBHRqjSYbadiFWeTrJ08UJq/8WzoFFgU=;
 b=popfEluwmL3CsZjiBrNJpWZ8Zijene9eZ8OrP8RxwIzO8/IhJa51N7IsEYo1ohPOk/mInxgjXqc6V9bWLi2Z+x5zqn/JM9tZxKenTOQCUyGX7d1R+U/odeEOUfM62Jt8ILwtRg6oBwGz30L8BzExnaRVfzG01c2FeXS/epjVZ6XMfWauzjhF1ZuZMamX8l/UXPBo87I4fWzCp7vpwVPL+/BS4znySGROnTmWpOpzw/HYtKPuQugFFgYtEuNWyHpHtY8L5pznfC2HXtI0ug+nG8pCu3p3Sj6iQNFC31Gm8oYOs/CdPVACW67X8dcy8UIpoyMIELOewSETDUH/mWIxLg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CYYPR12MB8961.namprd12.prod.outlook.com (2603:10b6:930:bf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Wed, 12 Aug
 2026 02:04:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 02:04:20 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Aug 2026 22:04:19 -0400
Message-Id: <DKMLHL0U8EBH.15P950BRTRD0G@nvidia.com>
Subject: Re: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks
 into a helper
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>,
 "Usama Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
X-ClientProxiedBy: BL1P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CYYPR12MB8961:EE_
X-MS-Office365-Filtering-Correlation-Id: de747adc-d3b9-4926-badc-08def8160593
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|18002099003|22082099003|4143699003|11063799006|6133799003|56012099006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	FR6ghjLGrUAPGAs7DZb3h+QClDwDA8bieTtUxiurlCSVMwazbD+ac7sZPFhkMtjGo61oe2+4xYIWGOlGc9ynqROccePpmNskxmF7bUHT0RszDQILONpRtktuar3CHDZcC/1YxNjyHz7Q7jqMz1nToBcaetxxP9FhH5f6Wo16GJ1hnZeRmsNCs1k1qgUrGQWEIMCHAUeT/YYb6Xx5iLs1dPkP2bSPeuWPWzS8Mfn70XXaLPcVZewZ/yUDM4bM2OxAJvkh1MeMWkWRIrRS8gpzQwetHQgJcZTglP0mT+tUhYdpvYB1E4RBigvEuLr9bTkvCdq4em4dbmimjyBPh5vHXYOUH3/1xxGC4u6CQkflYj9yaX1Neod7YBL9R/jJ/tRVH0aaowVhm1s+eKnDvOBTBlK6Qfnp5tvIJ99O8460RlZbVd7zdb6XqEL4AFJMkRdmNZMofa7O7y7ra+zCAf3bnOoUdPTBDDaKl0L4awPNJP0psfVHTuH6VVd7iJDaGDtr6j2dx9FW3VootQECJ69aVreZGHRSREvAwOzSnCkHCXjPuvee8auk8JRgQ/X/Uy3QNN5NCr+oXkvsQR1YqPwfclw5k16y2c0Qj0/m2xICgMHId1J+o4Jpb9YvPTnW5QkkUE01638mWmO387erxHT31QAXLo7T1RAaB8HR6SVx49w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(4143699003)(11063799006)(6133799003)(56012099006)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dG9qN2F4T0RsOWFuQXkzVFV4MWFXQkppV0lteWF3ejlPNFZ5cmJPMlF1UGov?=
 =?utf-8?B?dWdqN29YODlybzgvWVA2SmFBMWEvT2xnc1lwMGVqQzh1T1RmQ2YzRU9vM1RW?=
 =?utf-8?B?SWtrRUZtaStHK0N0cWVqclFuSjQvamEvVlZSQlk3d0wxWjJVWWZuYTliZXlq?=
 =?utf-8?B?bVlFMWlhN1NyM1ppbkVOb3prNDlONlFwVGdQNkhweGlBeXladndSUlpCMHNV?=
 =?utf-8?B?VzVFUUpkZ0xwc3RwV0tBNmNUcXRHL3NEbHI4VHZoQ1NoelJuRjBNOG1zcEk2?=
 =?utf-8?B?TXVqaDEvNVlMM1hJT0E5aSt3TDY0ajk3R3lDRTVJTjVyek5ramlnQVJYWUR6?=
 =?utf-8?B?Qkx5NThqOURwdy8zOTJiRmpFSW5ETnhUV2tqdFNQUGN1MGV5UXUyTUNZc0My?=
 =?utf-8?B?VzJYM2diaXExTTZLRG5QQkhpNW54QXV1U1QxL2RVbWhKeW5oU1Y5UUdNdUJk?=
 =?utf-8?B?SEdhelN1b2Z2cEJMWFNaUjZiVWpWVFRVWXF3ajFDbFM5UzA5QTJoTThUTEF5?=
 =?utf-8?B?SnJOdVhOaCtqbXdzbFNzbElvRk83clZTM2M2bmZ5UkdhdHkxWmlZV0ZBci9n?=
 =?utf-8?B?ZjJYdjFwa1pvM0dTL3VTVnFNNTRPVEFKMnZUbTl2R2ZLR3hzaFVPUWl1MHEx?=
 =?utf-8?B?SVpSSHNpK3lYaUg5NWUzVnROUGRsUDAzMHpteGd5Q0JLdWNRSWhGYlFuL0ll?=
 =?utf-8?B?N1pIclhmNzc0TlBEU1JTTDlUelM1QncrOXZKVkZsU3N3MmN1L1BFbTRJRWd1?=
 =?utf-8?B?ZzhQeWppUDAwVk1GU3ArRHd5WXR1S2gxajUxb0JBb1JERFloZmdlQVQ3YnFw?=
 =?utf-8?B?WFlVVXBhbDBHOGFYVTJySnpBL094N2RzMGdyNzNick80dTZ2RnhhRVJHRU52?=
 =?utf-8?B?MGtHWE5XSlBGNmNIWXZWTW5IWGZuOGo2US8xdGxSdGpkTmU0eUgrdWdmOE0z?=
 =?utf-8?B?VDRJUTNZRUxydTFqS2ovOXlGUmEwQmtqVkpIeEtDVy9NS3V5TVV1N3JzcUwv?=
 =?utf-8?B?Q1ZsSHpXTVRQcGtZbytEbmdEUjQ0MnZCQWhrVTlWaXArMUxmNDBwVUlremNE?=
 =?utf-8?B?aEpJb3dZMjh0eDhaSlEvTnlzM3BlZkdkRTV2MmZCdDl5VXNvYTlzY2doL3Q0?=
 =?utf-8?B?bmppVlhmN010KzJic1lsaEt3VXZzT1BUVnRjaWxsV3Y5cXVQMUV5VjFlOW5V?=
 =?utf-8?B?b1luMnpBV2JKK0VyTW9KcGM4SDVZRUVialhNVlVVRDkxVUVDRFZJVXpXd05v?=
 =?utf-8?B?eERLdjJKYndJM0tPTGNzOVpZRXlLTUVFcU1MT1JsbmlzaWdTM1ZGaXZjSndy?=
 =?utf-8?B?ZkU5eHloTjMzOFdabUVhMmkxclJxYUIvRFRJc1E3elo2NFVWZ0g3dXIxaVA3?=
 =?utf-8?B?UEZVUW1VSll2RnhVaHcxRmJRUlJRSW96VXZFYkJKem81U21vcDlQbTBHTitk?=
 =?utf-8?B?emZRaW9yQkRtNUFXWEhlcUZWRU52SzUycElYemhCNlFraWlvSC9NRVpkdWdx?=
 =?utf-8?B?YXdOME1GZGF5UEJ5N3ZLdGdNQWUxTlFPb2JiYlFielB6TWwyN2ZGYURSTXNq?=
 =?utf-8?B?UEZiQWZwek9wQmF2cXNrMVZKOXBmZXFJVEI1UkJ6YXdsaTNMcGhpUWdYYkRY?=
 =?utf-8?B?cHlMMHFNWXl5WGY0aVpvQktyMmJDOGEzVW52dFh3YjNEVmp6UHpsRjJUYWc5?=
 =?utf-8?B?cjlhZGFJM29sQ3N0c294dDc5YjN2TEhScHZLbk1VeEsyRnkrd1RpQTFzVXlV?=
 =?utf-8?B?cHNmSlBYOU1DZDhjVFV6VzBxaU9DUFU1TnhEMTl3TmpCZEo3QUxYOWRQVkVo?=
 =?utf-8?B?MEswQkhwRmpuM3VudnVVU2RseHphREZFZlUzc0wvV2xWdklmbFhwSjdKcm94?=
 =?utf-8?B?N2d2YnQyczhXN2t3ck5idlhTR29Nd1FzdmZ3WVpkaElDS21MTFFEejZmcno5?=
 =?utf-8?B?Tko1WnpXamFIV1hpWmFaWjg2OUdFTzN1blBSSC81UUwzcURJQ04yRWQzRXZL?=
 =?utf-8?B?SmhiSCt6Z05BVG9JaGFqbXZxcEpvYkEycEJSNUVpUFVXQm9jMW9Fd3ZKYWdu?=
 =?utf-8?B?N0lkc2xWcHNJTUxPQWN6N1htWWZBaDZ5RVRpOXJMKzVuRlRJbUNYRHNFQzI5?=
 =?utf-8?B?MUVnOGJmQzZtQmJnTCtBTGpPRUQwT1M1RTNXbXdNL1R0K3AyUFY4LzhKU2Ry?=
 =?utf-8?B?YU5SZ1craEE0ZldSV2hzaU8zcUJJcldVemtKVWxxN3dzZ0xqalZzNThNUWxJ?=
 =?utf-8?B?R1F6SDc2blV3RnhpL2xLRkQrWUFiMURuUklBM21MSHBqUW5Bd0ZFcHNxRXFL?=
 =?utf-8?Q?rHqZCMcpT0L4crb82c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de747adc-d3b9-4926-badc-08def8160593
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 02:04:20.0760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4bKkQd17tZmIyCfTDpZUjC/Ei12U81OJlBtGgdU0akAo0xBRAVcrnQ9KH3mAtU9c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8961
X-Stat-Signature: g8c7s86eq3j1qu8axwumw1dwz1pa4mfd
X-Rspamd-Queue-Id: 25401100008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786500265-523069
X-HE-Meta: U2FsdGVkX18Jf6sPAAyDtY8RMX7mUdBZgVD9oxRZ2F+OTFPMeb4o/Y8HjecdzqkeCqDTgwhU0kjGKahuOykJSSfNxDMOpQQ0G0h97psjgSjzFz0aRe6RK/vXESleDlmhHyeE4+iRpT1YDWBR5J7jQKXcKUt6VUHm5JMYE/1SIzn6bnj64xZ5IssQvAcilvHx3m3pr974F+Y1g7ElXmJczu04IvvN82gTT1jsDa2HSsuC5gxwGoLPXZRak1Tt2JEwT68rOhv02u1u4a3zfMhdocX/m3m8RkdJHX1FfTyBWcbx56vBn6uRH6e2Pl21f8cQk4/dZ/sQwD4+slxb3mSoWQI157ICHRWLxjqPnQ1RLAOvRf9OCl3LSUmcC/HCcfgmjpo1J7owicgODkusRuiKhmtjfpBNNk3vD/ADmCfdWSkHHIOYDXrJDToatFaitOZeObdXOFw1V4oPeyqyqVRok8BN+4UXteFpGHnI1JqdUys2Inr4u5H1gQvLcxypg2RWjoiejd379PWBzK9crNqxa/iqopfOF4TKzHYPzxX1n6CbXK497kRcslsiHVNsJ/GaaXwIQsr0jlYEx+5YXtMvO9hO6PCl2L1rEhzfG69Q/FYxLNZZc9Ds0qL14ZX6mMUFMR/AUPv1JAqLF2s0engkDq/ejL3NXxceOXDWttyVSVgcvv2PhCooHuzKQy1WVFYTePY2A8I0bLpU4upv+d/Qf2z95ekv1wRUqJbRGdyaYsY6rzQ5KfYHyx72VYW05rcUJ/YcTMSukyF7/HCkuZq/afgax/FoMMaaTpFsdpKjo3XniNJAa+8lohx7pB7z/ZiCkAyHKoCfSmhq/rni3ahBUMd/B4aUbDlrc6cE5dBKcBGQWaSoty4I+c34uC8kkxr57q/xxHJMSGMRssMd+al0FVsBSrL0p42zqpxtunrO+6hhOiJfIx5YeFPuD+saIiBL0ZAJp2QD2d/GtDFUBnU
 GHM6Fyy1
 I+CWOTVXXFZg9U2eEeR9xuCHWw7tjJEUhfxccV4yzLQj+pgdRboBYsVD6HELwLxhaHZE03Jo2etyblT+S3PXqGkAzXxTfZ7AiTQR6toNX/23ux7D9stqlGKS0+J+wkbxkcLV55ZcnHGJKeQ2nYKHuzbtMZUN8P2lL4Dq/8Ij770jg/DcrF9zmUFfB99jN79GEPhuYCLPeyWzpdtPySZB1M/WZ+O1eRr5U/e1NHoaOdDaZVdIniCGAYOtzoMKxAxVUgrY86M7L4mkPx12Ks6IkaUtiuYdyA7xawOKPHlssUYj86KBbTbqnMqjPqcuY9IERJxi9CK7ZTnw0+d3/y0mseGWf+RoOrvcHuAog/Oa8VNMtYWlSpmeiaerFfe2uadOYRTSYwFbxmQ2ZtyMWflVdo2ag+dV9TYYHNDea//iAmZPe5b0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 11, 2026 at 8:48 AM EDT, Nico Pache (Red Hat) wrote:
> For anonymous collapse, the collapse_scan_pmd() and
> __collapse_huge_page_isolate() functions share a large portion of their
> logic. These functions both check the state of the PTEs and verify the
> following:
> 	- max_pte_* values are not exceeded
> 	- uffd is not active
> 	- lazyfree properties
> 	- non-anonymous
>
> Merge these checks into a helper collapse_check_pte() to reduce code
> duplication. We also add a helper struct for this function called
> pte_check_context which allows us to pass the required parameters in a
> clean and elegant manner.
>
> A helper function is also introduced pte_check_fail() to provide a clean
> interface to set the pte_check_context failure results and return
> PTE_CHECK_FAIL state. This helps reduce code duplications across the new
> collapse_check_pte function.
>
> Two slight modifications are done to the original functionality. We now
> warn (instead of crash) if the anon test fails, and we leverage the
> vm_normal_folio function instead of page->folio, this should be
> functionally equivalent.
>
> No other functional changes intended.
>
> This patch is heavily based off work done by Lance Yang, but modified to
> deal with conflicts and feedback received during the review cycle [1].
>
> [1] https://lore.kernel.org/linux-mm/20251008043748.45554-1-lance.yang@li=
nux.dev/
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  mm/khugepaged.c | 298 +++++++++++++++++++++++++++++---------------------=
------
>  1 file changed, 157 insertions(+), 141 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 90d6e595d282..b7372aba4417 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -65,6 +65,12 @@ enum scan_result {
>  	SCAN_PAGE_DIRTY_OR_WRITEBACK,
>  };
> =20
> +enum pte_check_result {
> +	PTE_CHECK_SUCCEED,
> +	PTE_CHECK_FAIL,
> +	PTE_CHECK_CONTINUE,
> +};
> +
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/huge_memory.h>
> =20
> @@ -119,6 +125,20 @@ struct collapse_control {
>  	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
>  };
> =20
> +struct pte_check_context {
> +	struct collapse_control *cc;
> +	struct vm_area_struct *vma;
> +	unsigned int order;
> +	struct folio *folio;
> +	int none_or_zero;
> +	int shared;
> +	int unmapped;
> +	enum scan_result result;
> +	unsigned int max_ptes_none;
> +	unsigned int max_ptes_swap;
> +	unsigned int max_ptes_shared;
> +};
> +
>  /**
>   * struct khugepaged_scan - cursor for scanning
>   * @mm_head: the head of the mm list to scan
> @@ -696,74 +716,131 @@ static void count_collapse_event(unsigned int orde=
r, enum vm_event_item vm_event
>  	count_mthp_stat(order, mthp_event);
>  }
> =20
> +/*
> + * pte_check_fail() - A simple helper to set the pte_check_context resul=
t and
> + * return PTE_CHECK_FAIL.
> + */
> +static enum pte_check_result pte_check_fail(struct pte_check_context *ct=
x,
> +		enum scan_result result)
> +{
> +	ctx->result =3D result;
> +	return PTE_CHECK_FAIL;
> +}
> +
> +/*
> + * collapse_check_pte() - Check if a PTE is suitable for collapse
> + *
> + * Check if a PTE is suitable for collapse based on the following criter=
ia:
> + * - max_pte_* values are not exceeded
> + * - uffd is not active
> + * - lazyfree properties are not present
> + * - only anonymous pages are present
> + *
> + * a helper struct pte_check_context is used to pass and store relevant
> + * information between the collapse_check_pte() function and the caller.
> + *
> + * Return: PTE_CHECK_SUCCEED if the PTE is suitable for collapse,
> + *         PTE_CHECK_FAIL if the PTE is not suitable for collapse,
> + *         PTE_CHECK_CONTINUE if the scan should continue to check the n=
ext PTE.

I was thinking if we can make decisions based on scan_result instead of
a new pte_check_result, but pte_check_context->unmapped also changes the
result of collapse_check_pte(). And we will need a new SCAN_CONTINUE to
match PTE_CHECK_CONTINUE.

The changes look good to me.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


