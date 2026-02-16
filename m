Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF72E81A42
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 16:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51B1D6B0088; Mon, 16 Feb 2026 11:26:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4716B0089; Mon, 16 Feb 2026 11:26:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3512A6B008A; Mon, 16 Feb 2026 11:26:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 225D36B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:26:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B512113C2EA
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:26:30 +0000 (UTC)
X-FDA: 84450847740.19.AB52748
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazolkn19011030.outbound.protection.outlook.com [52.103.14.30])
	by imf13.hostedemail.com (Postfix) with ESMTP id AF07520015
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:26:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=D5YhO6fy;
	spf=pass (imf13.hostedemail.com: domain of raul_pazemecxas@hotmail.com designates 52.103.14.30 as permitted sender) smtp.mailfrom=raul_pazemecxas@hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=hotmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771259187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2kBjqNZ9mu8TE/UgMvUSlLO6lzzreK1EbDQJZpuUGo=;
	b=AW6ASP9PCRnGEdqORqPiPvMomniui9f9ahxpkrKY5cuM2gcW1Y9owjlDG0iiJS+nmTOOsP
	CjoRJszUq2jJjz+FI0N8bmo1utIh7dty/41qeaZAax/JN1p4hXz9N3K/GhD3BQ7OKpTfXL
	cW8UiOBAyD2sZywpxBs3Hw61naBzLcc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=D5YhO6fy;
	spf=pass (imf13.hostedemail.com: domain of raul_pazemecxas@hotmail.com designates 52.103.14.30 as permitted sender) smtp.mailfrom=raul_pazemecxas@hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=hotmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771259187; a=rsa-sha256;
	cv=pass;
	b=5fhpKcWIcBKZjYFh499pQbXRPvg6v1k0tTMPgJyjDI+Zo1mrCmPoJKwydDcDtUIh9B+PCF
	I4a87o7qkfZ3lUijRCw4u8Z1aGqoDsEMoR1nZALGdiBYexDSbiB8/r+73WWB8UpqkHaBl/
	N52bo7+qzKhK+VPmEQ2M6Yu0MmTsNqs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MOC9bTBI6CVEjHbg8slkjiM9+6vIt2x760CFzSHxouP2gCWAWP6MvuBiWUnSKNyxcFjNFbI8wLLfvkGXIUdgn1dPUzyjJHfiO/oc6pTGVhpyURzidcM+4VulGx/Jab9XdesKSYv8F/O7eUjs4wWf8WBs7vNwKeEhLopYIK5hFeMA5PmKxUokSHiF7Qk17cY9cTt/t32lNS0g/Yed8JNvwnk7W9V7FSwymyAn2ikXdaAf0kjtB9mRt21MvYIE4yWu3MBLHlW+IMoqiNi/U+GPkc6Kw3zj+mHZIZBt3dyO8ETZnlkMFyFIWJoF6r/AaUdBZH9eXidgkKLkxsW2NOlbRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2kBjqNZ9mu8TE/UgMvUSlLO6lzzreK1EbDQJZpuUGo=;
 b=WKCRZW3eZO4+xKfeaYpPG2wcHj6Sb2wKFZxrs38uAj3wvH/v1Qpg2A+uyH6jkwZHMdnbeH0JUo/8xlFUgwJlRlMxE9mTvpTBuJ5fgBGqB7Wqy/lGzjb0bdX62LaJlCEAlVZBQ6gpIkvC80VqXT9xY2D+iPXzMei563rV8eN41/Ejm+8O+pnvKHs0hFE6y2yhh8QtUJMV3q10kZjYL4N07uuN1RaPz+bNvJYCvpDiER+6uY0CuCItXohe0zZEF14HeMsigChBbE+Ytp0VpnRHyEZ3bHURAXlBdNChcdRrnoD96tKBXXr/T53tL3HU2tM1oUU0oRCtiF58xsxpH05VhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2kBjqNZ9mu8TE/UgMvUSlLO6lzzreK1EbDQJZpuUGo=;
 b=D5YhO6fy+/ThIGMiEYpPwB/1nfRzCXGA//kcljVN8DI+tfEhSlrCw+J5bwF1TWoTqMB46hbUXrZrjeTLG5cCXpGssMyrm33BD/6pMeoAUlUlZvY/MyUICZGQjFs8T+14S30BN2iqnEoZfoX2z0qxprgohE679ZY9i0ad65WemtCQXKPQBU0SX3ESGKncT85SquApT2Lz5lLcmIqqZFiaLdyb68+jG2fUuwxoO51ffTkp/v6Iez+o7k7KnpmvTeQp6YQNXanY/omtCxE4sxBQbBW4m8SQbImSDdAoj757hKJe4EwTTewx3lrEY1W0roLDYwnCVK9PoWGRx/k12ER6yQ==
Received: from CPUPR80MB8171.lamprd80.prod.outlook.com (2603:10d6:103:2c6::9)
 by RO2PR80MB6326.lamprd80.prod.outlook.com (2603:10d6:10:6d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 16:26:22 +0000
Received: from CPUPR80MB8171.lamprd80.prod.outlook.com
 ([fe80::18b5:f8c:1f:ef82]) by CPUPR80MB8171.lamprd80.prod.outlook.com
 ([fe80::18b5:f8c:1f:ef82%6]) with mapi id 15.20.9611.013; Mon, 16 Feb 2026
 16:26:22 +0000
From: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "sj@kernel.org" <sj@kernel.org>, "security@kernel.org"
	<security@kernel.org>, "damon@lists.linux.dev" <damon@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/damon/core: dangling walk_control pointer in
 damos_walk() on inactive context
Thread-Topic: [PATCH] mm/damon/core: dangling walk_control pointer in
 damos_walk() on inactive context
Thread-Index: AQHcn2D9a0d3EOICgkKKTiS+H6T3jA==
Date: Mon, 16 Feb 2026 16:26:22 +0000
Message-ID:
 <CPUPR80MB81718B12798BCF9959535B05956CA@CPUPR80MB8171.lamprd80.prod.outlook.com>
References:
 <CPUPR80MB8171025468965E583EF2490F956CA@CPUPR80MB8171.lamprd80.prod.outlook.com>
 <2026021646-sandbox-duchess-5b7b@gregkh>
In-Reply-To: <2026021646-sandbox-duchess-5b7b@gregkh>
Accept-Language: pt-BR, en-US
Content-Language: pt-BR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CPUPR80MB8171:EE_|RO2PR80MB6326:EE_
x-ms-office365-filtering-correlation-id: 27ebd699-5fbd-4a09-8326-08de6d781fae
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799012|8062599012|8060799015|41001999006|15030799006|15080799012|12121999013|31061999003|51005399006|461199028|40105399003|440099028|3412199025|102099032|12091999003|26104999006;
x-microsoft-antispam-message-info:
 =?utf-8?B?WWZzYlMvNGllWFZNZUltMVlVc2hJdlR6a01NRk5XdGxUNHBtM0o1UUFxbjZQ?=
 =?utf-8?B?OWhUczZJTXpxckUvQWxWUURYVXhVMituRVppbWlveG1TQ3NSMmxqUERmTE5o?=
 =?utf-8?B?TUxtQ29ORk9Rek9yUnVNd0VXZU5uRmx1VVROS2M2UEpmakFRVkMrWmZBaUo4?=
 =?utf-8?B?NE80V0VNNThzTm16NFBaMXUrQWl6eDk2eWFMSExvbmZjbFVxRjFmN2dHcVZo?=
 =?utf-8?B?NldEZ3NlbGswYmx3N2xJc0trY1VkbGdjeUNORHlYTzRvZkZiZUNZVU4vOXo4?=
 =?utf-8?B?YVJ0Wm1tVWdmdlpxTEk0MlhOOGpNaDhEMEVUL1JhTFo1bUxsMjhqdG1PTTRB?=
 =?utf-8?B?dTJMcUsvUURjaDFkbDhtOXk3L2cyeHMwMnVza3BnUGttU0pJSUVBY0c0TEFQ?=
 =?utf-8?B?V1NUbW5YWFFpTWNBV3ZpN2VEZkNlNE5LSmYrUWJaQ09abnQrQXM4YXRMQnZ2?=
 =?utf-8?B?QUk2MGN1YURDdE1zUExUNXFMUTlqZC9GS3BXK21HbVFqNjJBQm51czM5dHNC?=
 =?utf-8?B?cUNzM24vMytHS1lGTXpoK0JMU0FDRGl5VHRhVU94ZU9vMEJGYXdvVURHZUd0?=
 =?utf-8?B?eThHR1d3cWlBOC82dEtOMEd3TEJzNnN0UlV1ZGJEZi8zQnF6L2FWa05haWh2?=
 =?utf-8?B?b2ZYdGRqVGRzUzRXRTdGRUVVOHo4MVBXcGQ0WGJSd3BEVjdWdlZqYldVcjY4?=
 =?utf-8?B?ZktIY0YvUWxaREIyb1p1S1crNzlUSlBzMndEaStXV0E1bTJLQTRQTTRTKzJ0?=
 =?utf-8?B?dlVSYUE2SWtoRWNPditEczdtOVFMVmR4UDBQUUZFVnBpWVhRVjhuWitQRStZ?=
 =?utf-8?B?b2ZSbnI0U3gvL2czYUIxYkdRZTM2RHBZc1V6VUczTHdzMmFhTTJ2SmNLTWdx?=
 =?utf-8?B?bndKZWdXNkUxd3lmb2xUL3g1aEQ2VWJQRjZIcEE2MkE4ajJybzJPbytrQjV2?=
 =?utf-8?B?UDlhUWI5dWw1Vm42K1Z3YVlEekF4SDZxcGpQS1RwWTA2cy9DZlZpY0ZCT0FY?=
 =?utf-8?B?SXZ0WUZkR3dyY09xRVZwcjFMVzhzOExWUmVLVnprTnd2WExYUWFBSU5HZ2Zr?=
 =?utf-8?B?U3BZN2ptNk1venhsR3cyTGxLU2hTR1lkL0VnZklVV3J0Qk01c24xZGlwNHRZ?=
 =?utf-8?B?R1g3dWh1SUJWS2ZIRi9BTEVGcCtmcCs2RVM5Y1lTajZaMnEybDB6ZEpDUlMx?=
 =?utf-8?B?dVpvZ2Y2VWozL05meEhpQXVTOXE2L0hsM3dPSlQ2dzFDLzJvMlJLUUVNYkF2?=
 =?utf-8?B?S0VmdjNvNnNtTHVtWEh4RHh1RFEwVTdCYjdFSTY4ZmpVb1BsWkdZcHQvdWx1?=
 =?utf-8?B?di8vclJYZHZRa2oxWS9TSllFMi9NUWoyM1BMdHRLQTZWaVNGOWorenJnUzRq?=
 =?utf-8?B?b2hzVml4bldSbCtnTUNpNGY1aWdiSjc0Q0hnZ1ErclFjUlVqWW1qT25COUxh?=
 =?utf-8?B?L0NoZDlCa010dzdiSWxEV0RnRE1LeS9IT1lySGNzUm5wR0xxYVhidC9SRlVU?=
 =?utf-8?B?UWhVTVBOTlFuTktVRFFkeWxyUDJoUFFlcUFmN3BuQ3VDMFhseXo3MDFraSt4?=
 =?utf-8?B?dUN0SFdtc0hEWHdKL0FTZDFkalZiTkZHYTlSeHVVREkwUktHUkdIejlTWWlh?=
 =?utf-8?B?UWs5dmNYaG5LbHBQMFJSdFUrZ05ZbmEzcHNncUxHZlBLUTRGUHVuZDB0amhH?=
 =?utf-8?B?NDdCcXVDakVVbHZMTE1XdUhvU2xwNnBoMVB2anFIdlVUanF0WnBWeEJPSUd1?=
 =?utf-8?B?MDBublBhc2FPbnRNcVBJeTIrWXhReVdQRW9ybldKdytoNXk4K0g1S1lyaWE3?=
 =?utf-8?B?SlR3dlEyczNmV3lFVVhQUT09?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d3ZHSkwyYzFrb0hOWnlmMU0zVGJQR3cxbGFQNm9pSWxsOC9sRFJKVXJxZHNw?=
 =?utf-8?B?TEh3MFVBeHR4ckNuQXJtYmxGdi9YVEhINmNBZXF3TUtlanpoYzFkclhxb1Nn?=
 =?utf-8?B?Skg2S0xZdzh1VFBwZ3poVEVjOHZXdmJWZmdUMGROblloVit1aXBxelI5UnY4?=
 =?utf-8?B?NXBTcEpxRjZHYzBWaWRsSjVVVmw4NU8wRk9tRkhTMldlVTE1YjZpU25FOG91?=
 =?utf-8?B?djR6VTRuWm84U1BSS3RaOTlDdGIwY0hINVRDRU1LUWx5K1J3SVNxLzFVRVc1?=
 =?utf-8?B?U3RRUHAxN284Vm9ITjVOWjBRWGVSWm9wMTdHOWdtbVlqbDFEYUFRTzU3N0FZ?=
 =?utf-8?B?dU13WFU2a3Zzb3lPOHlnRlNYNTRlN3hKSjFITTB0OGdPR2MzWmw4TVlCbTZx?=
 =?utf-8?B?U2o1WGlLbURrT3hDRUJwNXNkUFl6NE5QMzRCZVZUYTJJdTlBRW1iVHFmSFl5?=
 =?utf-8?B?VjJxMVJaNnd5U2JEV2llNzlVNUhLaWo4YVRkY0trSG1TRWhFQ0l3bzBWVE5q?=
 =?utf-8?B?Y2lMQ3RGdGNwV25nbEwrSlg1NVZCZFJvc09YTFIwaEorNUhmRFJMK1ZLSWtL?=
 =?utf-8?B?WmI5cExSLzhMdXBTVzZXaHQ1cjByWDZPbFVqRUF0VXYyRUNYOXMrT3RNTFdB?=
 =?utf-8?B?eFkwTFZmVFZFSE54akVDRWt3dkZYWEhDL2tybHcvUTNJTTcxUS9aL2sxenhS?=
 =?utf-8?B?K29WY3VhTW9TTkUzRlpuOW9rRE5BR29pbEpERHEvOFhROXZCRjR6TGFyakJB?=
 =?utf-8?B?UVNTN2M1UW9uRUx3U2tOeTM4L2JPcXVYdFJtUnk5dnAzMlNtTnNYc3NVTzU5?=
 =?utf-8?B?Zk5KZTIrUys1QUpramhaVE9lM0JhN2RXc3loVFBlYlE5Nm9xYlUybnhFc0g0?=
 =?utf-8?B?QkxQcDdISjJGbnYxa0wwdzQ4cm91ZENyTkRnQXlaTDA1YU9oSXRRY2ROcEdV?=
 =?utf-8?B?UzlkSVB1M2lKM3RxdzRVZWQxTDVZcXFmMit4ajROb1Q4a2hEYS85ek8yb2s2?=
 =?utf-8?B?cFU4SGlJZ0RKa25OUzlUY0U3cVNOd0xQZkljVFNpQk5VYWV3cEVQdGdQanVs?=
 =?utf-8?B?RlRBZ0NFUEdDNElFRmxwZkhwQXREVFNwUkFiakxhYTlwZExFVmNxUWNXeFZZ?=
 =?utf-8?B?bkRZaHFYQ3pCNm9ucVFiZ3dUTkdvVTVzTVBod1MxelEwem9iYVl1U3hici9j?=
 =?utf-8?B?NDN0cWwrOEJURVVDV1l4THFzb0h5RjMzSTNxek9Za2ZxSWo3YWJJZ2c2OHph?=
 =?utf-8?B?UlJzZ0xjKy9VVjFUOWd5SnN1WWJVbXRtVnlXMk8yRjVYU3JYK0tjTGp1aGQ4?=
 =?utf-8?B?UEpsVnJsOGtrSmFoeUQwN3Boa3Z2dlhsNHFXdWdkSUlFQ1JOa0JjRitNejk5?=
 =?utf-8?B?ZStmaTBWNmZRdk9ac0krOHB4Yk5JQ09EaXRSeXR5R215RVE2SU1yU0lFR1Qx?=
 =?utf-8?B?M0tUWFZOb0JZT1BLZVhJbmJodFI3VzZ0elljcG5KNmkrc3NkNEZUWDdEaHk2?=
 =?utf-8?B?akxyWXVSMmJCcUJTNlhCUmZwdnF6WGJPZ2lpSjB4bW1ObTJtTTVWbi9mdjcx?=
 =?utf-8?B?amVPdWpZZ2l2WFdqZkdJdGh2dmRrQ0l2TUlNWGN4RnVVZUJIN3hvMWVBUTUz?=
 =?utf-8?B?aERxSm1IV0NpenZBZVFEa3BGTGJKWVRUbUhZZ3BNWGtpa3ZWa0NRQWdHWkZp?=
 =?utf-8?B?QVlIS0ozNERKQlJXajNoSFJyOHRabDgzZkphb1M5ZXdXYWxVT1RvZWx2NTdO?=
 =?utf-8?B?YzArTjdGSGtSZHFGY2h5YUpEakFQdHhMbnVHcnRrenkvR2Z4OFpOaTg3U2RO?=
 =?utf-8?B?VEFhS3lDdmk5bE9md3krVzQrcm1uOWxncklBdG9RN0svQUQxYXRIdXpaOWlk?=
 =?utf-8?B?RlZ0M0hGaHp1VXFTdEFvZ3VIZ1IxNXpQUE1sc0NQajVKNTdWWWZ1Y3h2Z2dK?=
 =?utf-8?Q?0CMgDGd/6zWnF1xaBJx2TLcy/69/+nQl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-8eed7.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CPUPR80MB8171.lamprd80.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 27ebd699-5fbd-4a09-8326-08de6d781fae
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2026 16:26:22.7750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: RO2PR80MB6326
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AF07520015
X-Stat-Signature: s4gsfawtieg6b9q6ifjbj36h6yjohkkr
X-Rspam-User: 
X-HE-Tag: 1771259187-428249
X-HE-Meta: U2FsdGVkX1/DZGZ/gVQKa7mnaZ+75SNh0hzoPaQr5cfVK/iUvRhpp13uOHAKbIF+3IihPhccZ2mbTCThXb8w0iXm9dBp8MsDf55tNPlxjXo1lue7zWhICvjcOc77sbDDh5lJ6teIDlnqdfaKDMmP4/O0KlmiXGzMZ4piYie6fQeWkkPTGt5VQZv+dw0yQP3O+nyK/b4f6pytQlmCvKskO8zmiD8ouOjpKKVgGv4RRZQZvgg5FJmoHjoIFBbQ//9NkSWxxBFDjGYrWCTwjKyoZMrbDiKziBLZLNPT/qF+hOKDqflr3kN3k/qHADQL2pIwhxgOVrEYQBG1v3NcBfy0owCiw9zZpdT+L8bv1ZkNwSajNhNPsazdR13arpzVWsvqd2kvqn7Gbbio/Uj6JKYUaMGnz8UIOItPf0cghje9gjP/OtULqz7nvIEgnKdS4cP+FWaF+EQqV/zy2h2QUwxo7dbVOgMhDXtVCeu/hiwTdF+ADtbj9K/3iRQbqvCgcohFS8HmhUcsV14+jKQDCNP5qSv7afTtQnajWIno0gADYYEebIdKDTz1nSViY1c8jgsImyI9zoM1FjTULwt3e2PcfXluB7ahHElmoE3n7Awa0afHv883H8PvHj4pqlGS6bSF6Ml+mI927jl/trupU251im0umi+qNatYb6f6APrCwc3aU1lNU9TKYZs8z7V5rNRkR11Uk2YWmpruf4mcxUgvTbQeafFQcyOIivj52bFqUVtn2kgr0ROlcrTz4fd+EuXblI/wPpfEs8N6I8xZw6Z2mN3FfNj3Wtz3JkfzDAp130zoPNt5np08nWwGHI9MSLMsDrljVsxQmbJCwyf8BERpDgmYGDRu9MZEgtwao8cTbIeBeuLvHajnMgGV42k2iTNcqR7h2dWFSd7lT0o7zaX9/J5HWjPiVKeXuHbshvKB9VcS6aUsqXQKoC/uMwIk26bTFTf/xGA/ZI9i1HML5C9
 6567XPiZ
 Mk+srfWwXlL4b58KRwPLGvxmUz4Ace3kaXo7LRoY0AbRPxQqZvsWFjbSMuTx+xMGp0Ahx2vo0waM8NnBLbixI3GTnuqzFemMwnDM6N6AWZZdKHoKE25XEoY1En5R8XIoQ33RDKvnwlKO8Znz5UwBfPDsQIMkoXWxJ6aYQOYCCuwbtsNkV/i6FLzqMYjpszripvTkt2LDmgeNuwdPO++1CorgaQC8qveCrmEQEL4TLQXrSvjava+DQjPkkILyZM9R48VA82pNSGaEKHm0hMClAszrSNWQcM/ZjAF27sEVXBILwvoqErPjExCn91RhfhtH0nSUpWvqs0LAZwTk33hwBBLtWZ7r3QEAm2yGXXyfUhVHxCzzWxqGf6ZHevMsqXILJwYQNSGxW+rKmh3xVlFZe5BIBp3bxntLXt+g/ZYSRYpRajXkOt64tUZvo44K7IYZ/fRb3q0ZAleGtbf4nke27hQSS/Ts7q7SBxTDoYOYCcvGfYsdBLCdVVWJIx19V3y1LNNBnaIWZpp3NRtNabMRBULbkRi9uqN+KKnlMuBUNnLqA7IGStzisgBeQewqzna9U4mDpv7a1KFmHijtYuwaupHzCUL2csiJMwZ7d1BE2YxC0ZeyzwXPECKf7fJ103yWymtUzYchG68o3gZILZZzN+IKYUU/FyeNP/GSj53GQV4/3dXL4nzn7Hm0e7z48WosU/y/GtYFY2aOewvdY94L0RN1+eW1Eqo4NJnKmDaycL35Zvb6Knms7vEmvqjZ+k0iktRbcBhhSKsIZaG4cvr6jwdbdeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RnJvbSA3ZDgyZjIzMWY5OTk0OWQwNDEwNDU3ODlkM2VkOTEyYWQ3ZTI1NTQ2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSYXVsIFBhemVtZWN4YXMgRGUgQW5kcmFkZSA8cmF1bF9wYXpl
bWVjeGFzQGhvdG1haWwuY29tPgpEYXRlOiBNb24sIDE2IEZlYiAyMDI2IDEzOjA2OjA0IC0wMzAw
ClN1YmplY3Q6IFtQQVRDSF0gbW0vZGFtb24vY29yZTogY2xlYXIgd2Fsa19jb250cm9sIG9uIGlu
YWN0aXZlIGNvbnRleHQgaW4KwqBkYW1vc193YWxrKCkKCmRhbW9zX3dhbGsoKSBzZXRzIGN0eC0+
d2Fsa19jb250cm9sIHRvIHRoZSBjYWxsZXItcHJvdmlkZWQgY29udHJvbApzdHJ1Y3R1cmUgYmVm
b3JlIGNoZWNraW5nIHdoZXRoZXIgdGhlIGNvbnRleHQgaXMgcnVubmluZy4gSWYgdGhlIGNvbnRl
eHQKaXMgaW5hY3RpdmUgKGRhbW9uX2lzX3J1bm5pbmcoKSByZXR1cm5zIGZhbHNlKSwgdGhlIGZ1
bmN0aW9uIHJldHVybnMKLUVJTlZBTCB3aXRob3V0IGNsZWFyaW5nIGN0eC0+d2Fsa19jb250cm9s
LiBUaGlzIGxlYXZlcyBhIGRhbmdsaW5nCnBvaW50ZXIgdG8gYSBzdGFjay1hbGxvY2F0ZWQgc3Ry
dWN0dXJlIHRoYXQgd2lsbCBiZSBmcmVlZCB3aGVuIHRoZQpjYWxsZXIgcmV0dXJucy4KClRoaXMg
aXMgc3RydWN0dXJhbGx5IGlkZW50aWNhbCB0byB0aGUgYnVnIGZpeGVkIGluIGNvbW1pdCBmOTEz
MmZiYzJlODMKKCJtbS9kYW1vbi9jb3JlOiByZW1vdmUgY2FsbF9jb250cm9sIGluIGluYWN0aXZl
IGNvbnRleHRzIikgZm9yCmRhbW9uX2NhbGwoKSwgd2hpY2ggaGFkIHRoZSBzYW1lIHBhdHRlcm4g
b2YgbGlua2luZyBhIGNvbnRyb2wgb2JqZWN0CmFuZCByZXR1cm5pbmcgYW4gZXJyb3Igd2l0aG91
dCB1bmxpbmtpbmcgaXQuCgpUaGUgZGFuZ2xpbmcgd2Fsa19jb250cm9sIHBvaW50ZXIgY2FuIGNh
dXNlOgoxLiBVc2UtYWZ0ZXItZnJlZSBpZiB0aGUgY29udGV4dCBpcyBsYXRlciBzdGFydGVkIGFu
ZCBrZGFtb25kCsKgIMKgZGVyZWZlcmVuY2VzIGN0eC0+d2Fsa19jb250cm9sIChlLmcuLCBpbiBk
YW1vc193YWxrX2NhbmNlbCgpCsKgIMKgd2hpY2ggd3JpdGVzIHRvIGNvbnRyb2wtPmNhbmNlbGVk
IGFuZCBjYWxscyBjb21wbGV0ZSgpKQoyLiBQZXJtYW5lbnQgLUVCVVNZIGZyb20gc3Vic2VxdWVu
dCBkYW1vc193YWxrKCkgY2FsbHMsIHNpbmNlIHRoZQrCoCDCoHN0YWxlIHBvaW50ZXIgaXMgbm9u
LU5VTEwKCkZpeCB0aGlzIGJ5IGNsZWFyaW5nIGN0eC0+d2Fsa19jb250cm9sIHVuZGVyIHdhbGtf
Y29udHJvbF9sb2NrIGJlZm9yZQpyZXR1cm5pbmcgLUVJTlZBTCwgbWlycm9yaW5nIHRoZSBmaXgg
cGF0dGVybiBmcm9tIGY5MTMyZmJjMmU4My4KClJlcG9ydGVkLWJ5OiBSYXVsIFBhemVtZWN4YXMg
RGUgQW5kcmFkZSA8cmF1bF9wYXplbWVjeGFzQGhvdG1haWwuY29tPgpGaXhlczogYmYwZWFiYTBm
ZjljICgibW0vZGFtb24vY29yZTogaW1wbGVtZW50IGRhbW9zX3dhbGsoKSIpCkNjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFJhdWwgUGF6ZW1lY3hhcyBEZSBBbmRyYWRl
IDxyYXVsX3BhemVtZWN4YXNAaG90bWFpbC5jb20+Ci0tLQrCoG1tL2RhbW9uL2NvcmUuYyB8IDcg
KysrKysrLQrCoDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9tbS9kYW1vbi9jb3JlLmMgYi9tbS9kYW1vbi9jb3JlLmMKaW5kZXggNWUy
NzI0YTRmLi5mYjAwODc5YWYgMTAwNjQ0Ci0tLSBhL21tL2RhbW9uL2NvcmUuYworKysgYi9tbS9k
YW1vbi9jb3JlLmMKQEAgLTE1NTksOCArMTU1OSwxMyBAQCBpbnQgZGFtb3Nfd2FsayhzdHJ1Y3Qg
ZGFtb25fY3R4ICpjdHgsIHN0cnVjdCBkYW1vc193YWxrX2NvbnRyb2wgKmNvbnRyb2wpCsKg4oCC
4oCC4oCC4oCC4oCCfQrCoOKAguKAguKAguKAguKAgmN0eC0+d2Fsa19jb250cm9sID0gY29udHJv
bDsKwqDigILigILigILigILigIJtdXRleF91bmxvY2soJmN0eC0+d2Fsa19jb250cm9sX2xvY2sp
Owot4oCC4oCC4oCC4oCC4oCCaWYgKCFkYW1vbl9pc19ydW5uaW5nKGN0eCkpCivigILigILigILi
gILigIJpZiAoIWRhbW9uX2lzX3J1bm5pbmcoY3R4KSkgewor4oCC4oCC4oCC4oCC4oCC4oCC4oCC
4oCC4oCC4oCC4oCCbXV0ZXhfbG9jaygmY3R4LT53YWxrX2NvbnRyb2xfbG9jayk7CivigILigILi
gILigILigILigILigILigILigILigILigIJpZiAoY3R4LT53YWxrX2NvbnRyb2wgPT0gY29udHJv
bCkKK+KAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAgmN0
eC0+d2Fsa19jb250cm9sID0gTlVMTDsKK+KAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKA
gm11dGV4X3VubG9jaygmY3R4LT53YWxrX2NvbnRyb2xfbG9jayk7CsKg4oCC4oCC4oCC4oCC4oCC
4oCC4oCC4oCC4oCC4oCC4oCCcmV0dXJuIC1FSU5WQUw7CivigILigILigILigILigIJ9CsKg4oCC
4oCC4oCC4oCC4oCCd2FpdF9mb3JfY29tcGxldGlvbigmY29udHJvbC0+Y29tcGxldGlvbik7CsKg
4oCC4oCC4oCC4oCC4oCCaWYgKGNvbnRyb2wtPmNhbmNlbGVkKQrCoOKAguKAguKAguKAguKAguKA
guKAguKAguKAguKAguKAgnJldHVybiAtRUNBTkNFTEVEOwotLcKgCjIuNTEuMgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkRlOsKgR3JlZyBLSCA8Z3JlZ2toQGxpbnV4
Zm91bmRhdGlvbi5vcmc+CkVudmlhZGFzOsKgU2VndW5kYS1mZWlyYSwgMTYgZGUgRmV2ZXJlaXJv
IGRlIDIwMjYgMTI6NTIKUGFyYTrCoFJhdWwgUGF6ZW1lY3hhcyBEZSBBbmRyYWRlIDxyYXVsX3Bh
emVtZWN4YXNAaG90bWFpbC5jb20+CkNjOsKgc2pAa2VybmVsLm9yZyA8c2pAa2VybmVsLm9yZz47
IHNlY3VyaXR5QGtlcm5lbC5vcmcgPHNlY3VyaXR5QGtlcm5lbC5vcmc+OyBkYW1vbkBsaXN0cy5s
aW51eC5kZXYgPGRhbW9uQGxpc3RzLmxpbnV4LmRldj47IGxpbnV4LW1tQGt2YWNrLm9yZyA8bGlu
dXgtbW1Aa3ZhY2sub3JnPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZyA8bGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZz4KQXNzdW50bzrCoFJlOiBbQlVHXSBtbS9kYW1vbi9jb3JlOiBk
YW5nbGluZyB3YWxrX2NvbnRyb2wgcG9pbnRlciBpbiBkYW1vc193YWxrKCkgb24gaW5hY3RpdmUg
Y29udGV4dAoKCk9uIE1vbiwgRmViIDE2LCAyMDI2IGF0IDAzOjM0OjQ0UE0gKzAwMDAsIFJhdWwg
UGF6ZW1lY3hhcyBEZSBBbmRyYWRlIHdyb3RlOgoKPiBSb290IGNhdXNlCgo+IC0tLS0tLS0tLS0K
Cj4KCj4gQ29tbWl0IGJmMGVhYmEwZmY5YyAoIm1tL2RhbW9uL2NvcmU6IGltcGxlbWVudCBkYW1v
c193YWxrKCkiKQoKPiBpbnRyb2R1Y2VkIHRoaXMgZnVuY3Rpb24gd2l0aG91dCBjbGVhbnVwIG9u
IHRoZSAtRUlOVkFMIGVycm9yIHBhdGguCgo+Cgo+IFRoZSBzaWJsaW5nIGZ1bmN0aW9uIGRhbW9u
X2NhbGwoKSBoYWQgdGhlIGV4YWN0IHNhbWUgYnVnIGFuZCB3YXMKCj4gZml4ZWQgaW4gZjkxMzJm
YmMyZTgzIGJ5IGFkZGluZyBkYW1vbl9jYWxsX2hhbmRsZV9pbmFjdGl2ZV9jdHgoKQoKPiB3aGlj
aCByZW1vdmVzIHRoZSBjb250cm9sIG9iamVjdCB3aGVuIHRoZSBjb250ZXh0IGlzIGluYWN0aXZl
LgoKPiBkYW1vc193YWxrKCkgaGFzIG5vIGVxdWl2YWxlbnQgY2xlYW51cC4KCgoKQ2FuIHlvdSBz
dWJtaXQgYSBwYXRjaCB0byByZXNvbHZlIHRoaXMgdG8gZ2V0IGNyZWRpdCBmb3IgZml4aW5nIHRo
ZSBidWc/CgoKCnRoYW5rcywKCgoKZ3JlZyBrLWgKCg==

