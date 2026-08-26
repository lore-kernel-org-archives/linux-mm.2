Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B36C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 17:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85BA96B0088; Wed, 26 Aug 2026 13:10:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80CF76B008A; Wed, 26 Aug 2026 13:10:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5796B008C; Wed, 26 Aug 2026 13:10:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3A66B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:10:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B2F7A01D3
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:10:50 +0000 (UTC)
X-FDA: 85144060260.22.DFF1545
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011062.outbound.protection.outlook.com [40.107.208.62])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5D7C9C0006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:10:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e6e7MfX9;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787764247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43Lk8PzkvXPkQicdTUnj0FZpkn9+fTr1yPKKxp9ye6I=;
	b=YUiGBvA4B11tFYAktx5Gv10MNM/717n+C2HHjAJJbOU0cRLGmUMkc8OVoUacPqy9aETSoE
	diW3PbbIoO9W2bZgckfzvb0Pea8LFKUcJRNu7hcBBbVAGf/Jq5jGEyekfICQnu74n3DK8j
	uFjBfWpH64QtEX5jTzzXkjs+UmGbFYU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787764247;
	b=OTnTg4sNgVcNLv60zbq6zs7drxI335LT9AUTXHQgiNnx3R2EdpD4xn736lFfs7ax2YxsXt
	QnzzpsW5QCP+SvM+uwH/o9SZU8Ad/bqDHg900IoxjKhBnQrjlkhRUme4tKKw0UdSo+Qvmb
	zhHC9U7E2un0GKOFuVmNvutqPsa2Xzc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e6e7MfX9;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qGjR/+dADmueriJydTF97LhICIofZ+UqXcpbRff2z8iMAFEEyYUb2ah0R/CaKMH0UoIM6p5d8o4jAOJf6Nw+D/Qm8y45E464fGRl4SEFnTrLauiBjqE7Tqzk539m72y7obEpZtsjdkJhIaNgWnhZCcAlzyAzA2TYOYzkAc1wClj1GZ+SmZh3n8HlXoM49m4ZKaSdVURogsaupu/Ifn16kl2zHcECg/w8b9M45JLw9be+8DHq2HqE2UlBM96OkLQ4EotKdYMSqo35DkfKl9nv54riyElaT8O4gWEmRFv4yenC3ji72ABki8fbYfoT6ySWN4Zp0c1ORuNXVOKs80ckkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43Lk8PzkvXPkQicdTUnj0FZpkn9+fTr1yPKKxp9ye6I=;
 b=qimOcB+jf+NsI9AiREn83shwq4A0zG+RtUumSDDvlp+3zeE40uHov3sFZoX0CY7ttFjpfZdwdTvEWJGAYDQxI9BcQRc78bfkJCtWmAuJ8NnUggc+NQf7BgWObZm4dLuoQM2zndb6xyYm8/3NWyrtM3Nfbb5pQU2ZfIQQ7Q506bVGByNv+PlqleQAgUaP5KU28JjBH1JSepTrY2MB2+ahogpGPns61HoVLliGjUe9pTY+HH7V5HYuWGcsuUrOsT/24KHMmiz0o6dSzWUUXC5W8esH7zt2C4fJI6m27js+Xa1AK+I6ILITWldQOxMTP4flEFYl6b4gpl4Ryx4D3a/yig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43Lk8PzkvXPkQicdTUnj0FZpkn9+fTr1yPKKxp9ye6I=;
 b=e6e7MfX9r8dillDH5PRMumQ0EjVTm2gpWCrYj0zbpVpMByWAfXJgNR80wltCIawLyPyIhDKJjSdCcowaNAMYTA1vdviWexVORfpBC0PutHJWGQpCniwoPLqqX1FvQgZMqqqfrKExCRYJhVIC/CLsmnWNFnrrBGLeahxYAF35+lhJ6E25PVB1CvCMn0uLTdxVF+bnGI/QqWlw5E6zTqudU2t5IhpApJIAkGt0Gy70zCaCAVUhQcZLmwN2CbLFvGmn703ReSDj1AQ0mKPrz31HnfM/YaHBIukt4hzqknn8hJN7fcAN3fX13yYAhRbuopo1RgO/7GNJ6DjF03im4nA1dQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6413.namprd12.prod.outlook.com (2603:10b6:8:ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Wed, 26 Aug
 2026 17:10:36 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 17:10:35 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 26 Aug 2026 13:10:33 -0400
Message-Id: <DKZ1J2U9OT92.LM8445YM68HK@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 2/5] mm/huge_memory: dequeue the deferred split after
 the split freeze
Cc: <lance.yang@linux.dev>, <hughd@google.com>,
 <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>, <liam@infradead.org>,
 <nico.pache@linux.dev>, <dev.jain@arm.com>, <ryan.roberts@arm.com>,
 <balbirs@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <hannes@cmpxchg.org>,
 <usama.arif@linux.dev>, "Kairui Song" <kasong@tencent.com>
X-Mailer: aerc 0.22.0
References: <20260826162101.1314941-1-kirill@shutemov.name>
 <20260826162101.1314941-3-kirill@shutemov.name>
In-Reply-To: <20260826162101.1314941-3-kirill@shutemov.name>
X-ClientProxiedBy: YQBP288CA0015.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: d92c3efa-4f51-4051-57a7-08df0394f182
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|18002099003|22082099003|10067099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	dJYddiBfczvCaF+t+o1UU1SbAxvZOYKUad+ev+fLVV4k98r0cKhXJjC0tPgwFRDgTiDObqMSH1ZLdvR3qVmRJ7IuvWayElOr7wX3oymNPl5yts+szP4Tp0C5rDUjEjrPEZALjTQLxWiidw0OGOlBDnEN5df3QutDAl6GxJCXmrmDF/FHUn7bQB1qOlt5+aqfHiiDInDTJAZ+GfM9u+EdhHgHfkvXzuCPpxAmf2MVIyIfQlmhficjsWlPGhwdRKPP86ySTrwDfst+mnjI62motl7BqDW5Zhyo67CUIS1RLZm3leScWI7/Ng1Lc0HKMJOJwME9wM3dsHtN8bvXMBkQl5o1YNEOog8BMT2FBKKHYCma5QnQYnGmalzE7d53fqfWwhzFD1R5CeC56oHLKHArwQwWDLTSxwqlZWS5Mz9QCMLLaPLjugEz95oGEm46T6NONTiFoz4VaDpS8uwBDL/Zn1CKs5GJWTCpLIbnHwPjz14mob1uwNqqKiGId+bVm55y8Cq7jn/CDqMJgdDbR2okV6RWkoCFgpbbCzVoXl3bOU4vhnP7tteYxucjGTuffRVTMS+Lxq9OZioweEkkjV7OgQneyW8EaS8L5hE6Lesyfxjk68NC/Wkzd1Ncg6/QqG4tn1ZeuT/G0LPVZEl36cdcScknZDr0CaWUiMbHeEdSMH0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VjRNRUtzbzgvU0R2b1VFT3MzNlBEa2tnRERBUDBJaUlFOS8veVNHNHdPczE2?=
 =?utf-8?B?RGYwNUdPSWd3V1B3RUtkYmRiVStIa1ZoZ241Y0c3UFNlOWVUZGxzN0lOcDJV?=
 =?utf-8?B?c3haVkJCVEVjRXJWSlJFR0Fia3JkeHc1TFFXamZuYkVKYytXUUVYZjV4aXNZ?=
 =?utf-8?B?cUlhSFViSXgvYkY0b3MvcWVKU3pONnpsS3Fob1lLR1BJLzNFbFZ3WWJsL29k?=
 =?utf-8?B?dEZza0dhanRENGM4Z1l6dTZUZVFiMXFOdzhYWUU0WjVscDdUZE5ubEF0NUd0?=
 =?utf-8?B?bUoxUkNnNnJqZldLSzJWSFpUbmk0SVJWdG41TlBFQ2NyNG1YRmFla0J6TVhN?=
 =?utf-8?B?b2NDWW1yMVpzVFRCN2J5b0xTUmVmazZkcnQ5VTZzWHJpV1djUEl0RStZOGhZ?=
 =?utf-8?B?M3p3R3pnN2xHeXg2d0lBdnRncUJsNzYvVGxwaExBTnUrM3I3eDA3V0RIZTkv?=
 =?utf-8?B?MDJIQktRSXUzL1ZTOGtXQWg2SlkwNVd6MllvWmR6M1NueDdhMk8yNEtsMk5F?=
 =?utf-8?B?Zm1TbWNDNVdLT2dabUZkN29QUW1IVm5sSktOejltTHpNLy9FcDJCb1g5NThN?=
 =?utf-8?B?T3RLVFBWajZtemFpWFZwNmF1VGtnNzV3T1YyTmpiRi9oS2J0QmhzNDlrbjBD?=
 =?utf-8?B?UzBkd3cyS2RxS0FaWmxJdGVHMlZvTEpXZWRqdlNNTHBFdnhLbXk5bXMyeXlQ?=
 =?utf-8?B?bFFsZHNFdVFmUkdxd0dtWk1ndlRhU2kzOFZjRlEzN05oQjgzMytmWkgvQVZF?=
 =?utf-8?B?QURLNjdsRVRBLzZXdEJueUdRV0x0ckxWanB6bkxVdFJnb01oeEZreHRScXhE?=
 =?utf-8?B?TDY5djRVNFp1V0h1UE5GS0F4Ym9oRjU2eW53Y1RmTHNMUWoyRkg2NCtMQ0xC?=
 =?utf-8?B?VUdIaHVkSnp0S3ZVME5jSXlCZWd5WTIrb1NnRTZYSTZoSVRSQVZySFNTQ1Js?=
 =?utf-8?B?TnY0aGJjNVNVdWszZGpVdFFoODNxUEc0dkhBQ0tVS0lYRWw2UjYzT2E5VTUr?=
 =?utf-8?B?VFlxdldvd054Sk1LbVF0bGRsUnZpbCs2TXlsVFZId2Zhc0NKMVRtQmF5dm0w?=
 =?utf-8?B?enAxOVV2SElZQ05VUE1VTnY2MU9YRkx2Y3pzN015Mm5nR3dqelo1aUlIbmMw?=
 =?utf-8?B?aHJtbzU1cFpNTkhoSFhDdi81OWJqM3dTdXVhL3NmRmtKOTR1bkNBZyt1SndN?=
 =?utf-8?B?V3JQMnBlcVNxRWt0TEpTSDBwbk44bVdVM05CQVVydTEyUUlLZTVFank5dS9E?=
 =?utf-8?B?bGkzR2ZxdDlaTjVhR2hSMmtPamlUUTdZUFBkTDJndnNYS2wrMEg5bFVEQUNJ?=
 =?utf-8?B?YjRFM2x6cWwra0RJUExRREgvTlVCUWpTSlVkWVhhRW92bTVLd0puaVFFRy9P?=
 =?utf-8?B?U0hxWkw2eFExR0dFVHdJSEpaZzEyWWFEdXJhQjUyU3V2dkUwbGd3ZHIrL1pl?=
 =?utf-8?B?c00wNmJNTmtmM0k2YU1VUWxJU1hvS0gvcy92czF1QldMZTJPSUN3QWJtWlRY?=
 =?utf-8?B?UlJoWEZTRXJ2UDE2M1VVMktGbDVUdU1PaWVHc3RwaEZTRzczL3AyV0RoM2Rh?=
 =?utf-8?B?SW9ZbXA0M2pReHhCUno3WjdVdUYxY3B3aHVTRUxwOWFMQlQ1RzkydkpJOE5C?=
 =?utf-8?B?T29QUUhmaE9tSElPRTBUK1RWMERZa0xicE42OFh1ZDFVUzFyOUNVUHZib2NN?=
 =?utf-8?B?L2tOVERlNE10MWJTcUV6SHViVFlPdlJFSWxiU3VqbTQzUXJPaTQzZFhIQVVM?=
 =?utf-8?B?K3ZTRjFFS2YxdlZIbm5kZjJHMEZNd3ZJSGNGd1F6UmRjUjNEbWptbURKbTEr?=
 =?utf-8?B?TjMyMGtaRjRmazh1a3NLV1lkVUtjaEk4Tk50SDJVV3puM3BRQm9uMGVJcDFr?=
 =?utf-8?B?Umw2eWlmTWp0dFdmUURDcy9uR1pVUHUzeWhHSDFzckxVN29DdFNMVWpaM0tX?=
 =?utf-8?B?RzRYSkM5dndMZFQ0aCtPS2xua1ZBU2tPcHJQN1duaG4rdXpGWUc2dDBla2xr?=
 =?utf-8?B?dEt3ZTBIbmRUc1lnVVBzYThaVjliNVJEZFBVRGdMR2tpck5DMWVYandUWmhM?=
 =?utf-8?B?TjN5N2ZlTFRzZnJ5K2d3YmpFek9vcUxMSFJSdjlCSVd1NWJuSmtodDRmL0F4?=
 =?utf-8?B?VHF5SDBNbXRxdUdmL0pNRzRPZGltbTM0S2pEcjF3UW1vVFRsV3VFVk9XN1FZ?=
 =?utf-8?B?RWliY2VMcGl0NldMSVFUV2M0YkJDVHV6QnNWYkZtc0hOemJHbnkzYlBrVTA3?=
 =?utf-8?B?ZHNNUklpV0szTC9jcklVb3g3ZUNBWWZmZVpxdjdSQXA4VnlJZUpJOUxTSnZL?=
 =?utf-8?Q?Yt0cP5yliYMTcYabGx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d92c3efa-4f51-4051-57a7-08df0394f182
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 17:10:35.5044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OpGpcJbelDLpJhPvehdF1q+V7baIeiABfwOXKWT/PlEMox+aMt+xu10FsMUZ6Scn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6413
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5D7C9C0006
X-Stat-Signature: ossr7h81csd7dahyynrsyxss7cpjkedc
X-HE-Tag: 1787764247-38851
X-HE-Meta: U2FsdGVkX1+KPcTgtE4RyT+hWgBTU8tt+9vIo3xJ4FU3uoaJ8H5Etc+HUDUp18AjxVwDdnnYTw7s1h2okOrqzxD5leE5HHykFSrsICwGZZ97Vcz9mpdF3t6sLNcWIpiHkjR6BhKTsVMxF3IzMB1YZGZQ8ZBLsxbHfjPqvurQlYsbzAqaYcHEg1T1JE/X80FVoAfpVwe8DI2vfZKOF/5Bu26qgMKol4FgZPYRGkbqpPtNIyGrVMMcjmjvoT+rtyBgamcUjH+x/GcQe0HVfKVX7CwFhIVt4f1c8Mhc7oa4iq0Q9KPbX7MNwl1gbuX8dw7oyIfXhz3oElu1iDtKL235ULiGsX7dEhxv0aLmcknJ27PZoKF9k/TJArtAbvfWGnBDjgujuPCh21kLiQREqltrWmxrLNXfTzlP7v+O8vsPOj64DR915rLxcjlFyT5uHkmf0gciGwx8kOwR6in7G9ZTrWIvFrWtMLqUagYUCdkEIr/ZNDxJftgafJOqho49tlbgujkr1B48GcFxSqPV1jSuqtdP0cltRowHmI1q63xLewbO6nj2EeLv7HYhzNyIfGfVgy8UL1NKwidjDcaX4QV+Xk96iwg/uZ0+sUMryyCZLljSCmZIY8BYrz5fwETDlQw4vgusfgG15tx/4gfNgeZ0U2oWAPOAzQI9LZRVpE1n8itNMsro4UzW7OflUzCo8H4HTuRPuSDY0n2q/i05VaU6cKyOuayB1wa1UIRXPILbR0bryRMbNhZ31tpJKKl+S6Pl5LIfT2FuZZawhWyvWBBIuVtdbeXRx7degw452NQyRKbKREpDnCTpBJTphwaELuFNwBQP5YyxWXeJ9vac0uPIvg+YcVigXFZFJYFG/HGCPKEZpzJVMm2sSkFGw0fDocjijrDj2W8OUhWwOfNGxyXexrITVPe3As71M6Iywy3uv4EZhmP1XQs1jpIDiYjLu4me72KXipp4zmeYtwq4r4l
 HHE/7G6N
 il64dw6lTe60fD+mGF1gK7dB9x2ApG4xFyW76e6BXUCiwo6xFj/6QNMuHGtmM2jUbBOhX5OPbzZP+fbGB4SBb55aILwnTYkIyORPrebMyC8mr1hi5xzaDNYyUr2fIgSISW0jCDabW1kqi19vs/YRXHSfsmPUjNYrPAFOVew+AA9h1j+ygellbVxtrAO0baL/nNyWIjjaKChQonaRMIG6YOHd0tF9KoceXSFhxo/IlOR+u+LFpjfyFYtVWmiJBl0oVXCqquBmYe2/q+nPtdOqw4E6jP8n4H0O1Ex6MKFuVnRlH8qelxmEN7CBSmVveDFxSRrHl4DiIZwbqzBs24PBFyee2HWchZQwBMVDyATicwmj870LpNPElqHUhsLO5yizl89fdo4EUrpdVlQrmDj45yWFkT7deMpnZC8aLsQuUJQyExeBIbWJETtUHQK079pX52COy4zPfkJceRUv5+YRWaP++8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 26, 2026 at 12:20 PM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> __folio_freeze_and_split_unmapped() takes the deferred split list_lru loc=
k
> across the freeze. It is only there to stop deferred_split_scan() from
> touching the folio under split.
>
> With deferred_split_isolate() fixed, the workaround can be dropped.
>
> Unqueue the folio after folio_ref_freeze(), the way
> __folio_migrate_mapping() does: folio_unqueue_deferred_split() needs a
> zero refcount and a memcg still set, and both hold there.
>
> If the split is called from deferred_split_scan(), the unqueue is a
> no-op -- the folio is already removed from the list. But
> PG_partially_mapped is still set, so it has to be cleared here or
> MTHP_STAT_NR_ANON_PARTIALLY_MAPPED never comes back down.
>
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/huge_memory.c | 44 +++++++++++++-------------------------------
>  1 file changed, 13 insertions(+), 31 deletions(-)

+Kairui, since the change affects his cleanup series. I assume this will
be picked up sooner than Kairui's large series.

>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6281ed993243..c84e8cbc986d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3931,41 +3931,27 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>  	struct folio *end_folio =3D folio_next(folio);
>  	struct folio *new_folio, *next;
>  	int old_order =3D folio_order(folio);
> -	struct list_lru_one *lru;
> -	bool dequeue_deferred;
>  	int ret =3D 0;
> =20
>  	VM_WARN_ON_ONCE(!mapping && end);
> -	/*
> -	 * If this folio can be on the deferred split queue, lock out
> -	 * the shrinker before freezing the ref. If the shrinker sees
> -	 * a 0-ref folio, it assumes it beat folio_put() to the list
> -	 * lock and must clean up the LRU state - the same dequeue we
> -	 * will do below as part of the split.
> -	 */
> -	dequeue_deferred =3D folio_test_anon(folio) && old_order > 1;
> -	if (dequeue_deferred) {
> -		struct mem_cgroup *memcg;
> =20
> -		rcu_read_lock();
> -		memcg =3D folio_memcg(folio);
> -		lru =3D list_lru_lock(&deferred_split_lru,
> -				    folio_nid(folio), &memcg);
> -	}
>  	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
>  		struct swap_cluster_info *ci =3D NULL;
>  		struct lruvec *lruvec;
> =20
> -		if (dequeue_deferred) {
> -			__list_lru_del(&deferred_split_lru, lru,
> -				       &folio->_deferred_list, folio_nid(folio));
> -			if (folio_test_partially_mapped(folio)) {
> -				folio_clear_partially_mapped(folio);
> -				mod_mthp_stat(old_order,
> -					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> -			}
> -			list_lru_unlock(lru);
> -			rcu_read_unlock();
> +		/* Take off the deferred split queue while frozen and memcg set */
> +		folio_unqueue_deferred_split(folio);
> +
> +		/*
> +		 * deferred_split_scan() takes the folio off the queue before it
> +		 * splits it, so the unqueue above finds an empty list and
> +		 * leaves PG_partially_mapped set.
> +		 * Clear it here: the flag does not survive the split.
> +		 */
> +		if (folio_test_partially_mapped(folio)) {
> +			folio_clear_partially_mapped(folio);
> +			mod_mthp_stat(old_order,
> +				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>  		}
> =20
>  		if (mapping) {
> @@ -4067,10 +4053,6 @@ static int __folio_freeze_and_split_unmapped(struc=
t folio *folio, unsigned int n
>  		if (ci)
>  			swap_cluster_unlock(ci);
>  	} else {
> -		if (dequeue_deferred) {
> -			list_lru_unlock(lru);
> -			rcu_read_unlock();
> -		}
>  		return -EAGAIN;
>  	}
> =20

This is a great cleanup. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


