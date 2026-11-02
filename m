Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D97BE606AB8A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BfDO4kcZ
Received: by kanga.kvack.org (Postfix)
	id 01DF76B05EF; Mon,  2 Nov 2026 09:30:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10E76B05F0; Mon,  2 Nov 2026 09:30:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8986B05F1; Mon,  2 Nov 2026 09:30:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B766B6B05EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:30:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A6C440145
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:30:58 +0000 (UTC)
X-FDA: 85390415796.29.A8CE32F
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010057.outbound.protection.outlook.com [52.101.56.57])
	by imf09.hostedemail.com (Postfix) with ESMTP id 49F3D14000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:30:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BfDO4kcZ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/8btX5kYPqK4Hpvc+sxxLoSdJU+TCcdZZ+DX3BGDeE=;
	b=BGi8Enkpz/p0C+/OpXFVbrhjOtwhiAT74E66CwERrKZYDpY1nLAdbN0sDuOdiNUzejOZ8k
	k8aD0OAbUbD0YQhkINYmDOBh11hlLBIbXH0mk+WRTy8U4TEtPsgodkUqqwOJGTAaQqPce9
	0qY73ADbm3QVuSK33xQr8XpWspVAfpE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BfDO4kcZ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793629855;
	b=s3lMuEWqcVgWYA4Bz9ZzjSv+Qud540pyY7+pxvyWT4m3u4i1GA0NA/VWc7pyziR8nxwrfP
	U3q7UUCemO0OcMAgk+GyfmVr3X4+17S+zC1Kb7LzDR/OTiN7rHM8NGNTicCfBaVQIVcVM4
	rT8CqL3c/mrYXsfHjOXqOB0/mga7E2w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u0cV36ZEAQRJUV1xWnpwWP9Zaq9BBPXziCWYP0lVZEihPDQhI1f7r/2mPxpQ+XR2YwbWGlWt1FFfDof8YJi/2DOgaaADFnxDTUevSKgaeiYJ0iVJ9zyPcUGkyEisiBrsoVKRyL2XkloEwJfL/DChI1d99dU4SwsC2D7bgPk1+1EcsFfZe0HnoPLzsuME5zYitmqYpjnwhujg1fa5+SgWi8eoIqoYMk/cTFjhF7AwVYfIYcuk7RpBzaXj7bjZ/BkcO+dvtoCzACtoq6D4wCnxaQm2GmvS2yL2EJS0iAbrQFGg2bk2XLT2VYrpxPV4yXc7jwWkIKWLLI833dL4Oh4OPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O/8btX5kYPqK4Hpvc+sxxLoSdJU+TCcdZZ+DX3BGDeE=;
 b=v29yzUjzrP2NNcil5y5Wp+vkhijEFUkz5CWkFtGOaFI2yP078Lu+oJJayXimr4CO6vxqcdHuyMOcnwPx0c/iahjjp8bZRM/dFU4I92ip1dqo0dBq54K6OQK/SD8PFR9OLcoGRxtBORFIhvvHfR+C8l1XAFQl3eIGAEAssoOPXZIa6SDabU4hcifDRVGiD7ZfAuZf2FjSRaUVdyHTJ9rFfiRP1OwDb+raO0klD98z2enTZThe6lzT+Pr3rkY7QsPq0IEPZ03SSW3Q2B4cWGNZdAK7kQKT6RVSC4bB0O7FtJbgUuiFIXcWoEAhcliz4ckFqneSsqMboIbEsRzz1qQ+cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O/8btX5kYPqK4Hpvc+sxxLoSdJU+TCcdZZ+DX3BGDeE=;
 b=BfDO4kcZGUWOlwaFK3UOTTb0uiojpSC8Vgj/g1lCv2Jl6SSXROk8oCFo/2wsYXfUaTPc+Oi51KlXjMtZLGOGKLTKWpiY/bYCP63tZ6pffsrWwlzERkP2PLVGOizCSR4H4JG0fg1k3XxnAdyvgX7GPab2mmJyL5JJZuCq8MTudnycD9XAsmdSBoRQZAnK9upzwJNZQ629HFc3VioM3m7DN4TXi2vmdsj/kdpy5n3gls6UFQB6rIqrKLhlRmzStw9DlrpmqJrN81dtqT24YaDwi+O9jbJgt2vXznh1aZZNoVWtMeOLujSk5O/Xp6Wmts+KIaRAYWd0XSnCrKmavVxpSA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB8344.namprd12.prod.outlook.com (2603:10b6:8:fe::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.12; Mon, 2 Nov 2026 14:30:51 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 14:30:50 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 09:30:48 -0500
Message-Id: <DMKSPTAEU1FR.3EF4U7CIIJ39J@nvidia.com>
Subject: Re: [PATCH] mm/page_alloc: release isolated freepages on compound
 range mismatch
Cc: <vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Zhenghui Hao"
 <zhenghui.hao@qq.com>, <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <tencent_869149E9C4305627F0ED654860AC4DDBC309@qq.com>
 <5d79db66-2195-4f8d-a721-e1756bc6ead0@kernel.org>
 <tencent_9125D3B8701AD20B318ED534FC1119659807@qq.com>
 <bd519d0f-9e00-4efe-a090-9ce81bd4ccfc@kernel.org>
In-Reply-To: <bd519d0f-9e00-4efe-a090-9ce81bd4ccfc@kernel.org>
X-ClientProxiedBy: YQ1P288CA0005.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB8344:EE_
X-MS-Office365-Filtering-Correlation-Id: 67d180d2-01ed-4a4e-8dd3-08df38ede482
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|6133799003|10067099003|18002099003|22082099003|56012099006|11063799006|4143699003|261021121427099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261009223027099003|261028144727099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	hhXwEvnOf8+5MLbo2fgrWxSY3tXDQkKFUd0S6NiOoh1Be4WCJVbe1jEHwnlpp42w8bz6oVaaH/fI7wyo6zSZGpU2VQnvfNAzVE2PD/HrtWsnh4FDDEVsyLgKyA6/NeW/Gq6NtnFA5Y7HFzWs1KlNWKbLNjFVqXuYu/SUQ4G7Arp1k6VCrUt3H1g0LnG13qiD3ibkdFU/U7v0fLtJZUkWMqBQ0g8b1iQnWwufZ0pcbEPpSJPTjcQH351j9URNPeSScW4LYS8mkN8Cp/YG/yMbRnB7cwVc92wIT5RZz7FPkb+H6djh4pP0KBnBG8AVkDYMwK7biSoYQ5K69HFhdCzetpOjQLx8OhUOC2rpw5Sn4/5PlAqgJPclQW6Oda6q6VdRzddaJjp0WsxepWm7l4URuWNiz2+kS9WOr7yG8M/ysLli+cnlP13a3t8aQ16o4o1T9TTAPSAgf1uiq69tyviqMC85ZXpiAUQy912sXuXfptZ5PajggJwvlxC/6kzp6dfeYgGLMBvsnxwoR6rB7T9ItEP/1zbA3z6NyWZ5WXRDZBzMY354Cc+GSwHKriLLQo9mxcQWb0SQnkFSYP3UaXgBE1RagGza0+JJ3PE8j4di6SMYvctn0Yc9zp2LwVWc/6eMy5+y16acbbB4HL915uTaun7w530TghvwRZOGltDk8IY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(6133799003)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(261021121427099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261009223027099003)(261028144727099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tmg1cWNjUmxxVE53VXlSb2RtKzZxMm5aR1ByUEFVZ3NibWNJa1M2YmUyenRn?=
 =?utf-8?B?dVRVeU4yWm5KTU1ER21xU3Z0aktBTGF4dEZ1M3I2TjZxNHE5UzFPMk80K0Rq?=
 =?utf-8?B?ejV0T1UyR256T210dVlwQ1BVcXp2bGpYOFJadUJCY0ZYcVBqNXlXdzU1ZWd1?=
 =?utf-8?B?Rm1QZlFhdTFLcTloQ3FRMnNWOE9TamIrT3hrUnRZYXNpdXFEYndGUlBSRUo5?=
 =?utf-8?B?d0VoTTF3bk0yWkVxSkdBUFZPdW9acDBpa1Z3bDBpaE9xTzdHMU1ZU2xNTElj?=
 =?utf-8?B?ampHVmRPK05SMmw3WG5TQU5qcVo0WklySEdBYTBCSCtFOVFXcXF3dXBDNFlm?=
 =?utf-8?B?T0tSeElZaTg3d0FHeDZxWisxSndYdkhRaTBZQWM3MHZ3RDduUmg2WktydGpI?=
 =?utf-8?B?aEFMMEFYWnBiSFFiYmNZOWZpb3hqMUVuSmtjOE9qS3diTEorTkt1TEhQZEFO?=
 =?utf-8?B?VjB3K3NockIzU0VxRElzM2dGaHZpYkY1aXV5QldtM1l4OEZpOFlwWEx3QkxL?=
 =?utf-8?B?SnZ4SlIyOUx3V3FzWFdwcEM4Rms5Y0lYNUg0WXEzODEzdnptR1pzZy9MVkFr?=
 =?utf-8?B?ZjBjdkJaZ05ldlk3bHpQYTRKUWlDeEpBY0JoZWtwR1ptZnZEQWFST0RjV1dO?=
 =?utf-8?B?eDJnRldNOS9CK0NvdnBXSGJ3dVU1cldEbzd6UkxlUlVYMjdGVkVxWkFacWNT?=
 =?utf-8?B?a1pia3NhZ0dsTnJaUWZJck0vNmtIMThwRWV2Y2I2ZitNOER3SFZMR2tpbDBz?=
 =?utf-8?B?ZUxuNiswRkZ5c1FBL3hlcDMvb0thM0FWT0R4SjlGSHR0eUo0NjJaQkE1YUZn?=
 =?utf-8?B?c0JXd0pJQVhmaHNNSytWbWUzVHdaZzcrZDRneit0SU1kVEVmVXdPUzkvWmxF?=
 =?utf-8?B?N1hreTFvOTd5K2RrWXllbkdFNzlHT2IvQkZiMUlvd1pkclF0aTUzUVRXcnR6?=
 =?utf-8?B?YWo4dkVEUFRQa3dPU0c3THNjTlV2N29yZFF0QnRQRVZrNDZOdGpVenR1MUdT?=
 =?utf-8?B?QVNEN1IvZzdFZUZsQzAwdTJSdDlHSi9yUzl1S2tqb1lnbnRjRXpoYTFLK3FU?=
 =?utf-8?B?T3JlOUZENzJWN3JIcmV6QlQ1OVhDdFBRbng4WjQ0YVdkT0gyc213cnZ4TGJv?=
 =?utf-8?B?cnhQY29jd2xDTi9DMSsyOUl1THd4UFJkYlU3Kys5blFPOWUwTVVEeUR5Q3dE?=
 =?utf-8?B?a3I4VnduMTk4U3hPWStvUjFIeEcyQ0s4N01kL08va29EVS9BRDVRa2haVS9q?=
 =?utf-8?B?M3FsWkVja1dnbk1KSi8yaURKa1JzT0M5WU5xa0M0UkJONDlYOWRNaHBSTm5M?=
 =?utf-8?B?T3Y2NkdRek05Mnp0NWxtSGgzL2MwS200alRJV2RkS0RoajFFUXRaeGpBZk81?=
 =?utf-8?B?emhZNTlpMkJRUmNxRnl1ZEZYVi82cDNRTmVyaGx2NnRycldzTG5pREQvNVB6?=
 =?utf-8?B?Q1VUTCs3Uy9SU2R2eldYL0U3Q2tFLzdONHNoM1dpS3ZIMW92eTZLc1VKUlM4?=
 =?utf-8?B?cGN5QmJXSGc0T3htZkJEK25RdmZ5MFlmUm1kQzlRMFdDYjltbFE0WmdpOTZa?=
 =?utf-8?B?ZkMvdUZDYStNQjRSK3UydGMyNkMza01iRDVTeHljbkcxM1lVZUR6SGl2QzM1?=
 =?utf-8?B?RUFtanJWcDFmYk1TZEJsN2NuaVhjbElQODVJd2lDeG5XNU1rZWZIdUg2WU4y?=
 =?utf-8?B?cDdvRjlFU0s2YXA1aG54SzU3bHBxNlVHWGFZRGlhOGJLVE1OTVpCbHdocE1H?=
 =?utf-8?B?M0t3dml6VEJPdWR2K2xPLytlWVRYdFc0TzdqeUFNSUVRWVpzUExpamRBN2h5?=
 =?utf-8?B?VTdwY29Lb2NGdjNwMmdjdkFNanoyOWZuRjdNWnZNM0ZFMytCMGMxNE96UEpo?=
 =?utf-8?B?VUZCZWJhTGRWamFoSVg0MVRTRGg5eGFxUE5ZanZIY0lqMUV0VktpSGU3c0lN?=
 =?utf-8?B?NDZlMW9uTDdtZ3NVM0tRTXk5WklyYVZkUlVjZnoyeCtEa3BFM2ZSWWh3WjYx?=
 =?utf-8?B?UHZaTG1ZRFY0VXZqaCtnVFFiQjJwQzFaMW1TUk1QQ1JmVnF1Smo1MnFYZ0FF?=
 =?utf-8?B?elZWNVlEVG9maFhCaE5uWVZOa3gwYmJUUE01V3kxUThUYXJYd0k0NlBrdEQy?=
 =?utf-8?B?YUFvK0dSS2FKamxhQUFMdU10T2lSbHZoeXNJQXVrNXFLOFg1UkRxU0R5KzFQ?=
 =?utf-8?B?N3F0QzhWUXdSTG1HMHpPU3UrUGpWQzVkSUxXdEFwUWVzdWpJVlpKUnd1dDFE?=
 =?utf-8?B?K1psaEZSL3JSZEFENDcwelMzSVBIVmRGM3JkMWxXejVUczRveGxsS0tsUDZI?=
 =?utf-8?Q?JMD3DhEiOCmr5z/Awi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d180d2-01ed-4a4e-8dd3-08df38ede482
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 14:30:50.8519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1SYIUd4xvUgaDCHWzbem2d1W9Uh7vwxFjE4+vgsAgR+0HPtBSSVtEz17JgArNJ/d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8344
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 49F3D14000D
X-Stat-Signature: icca6a4yo5j9yb1ufzj8gcia3ri1f875
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793629855-762229
X-HE-Meta: U2FsdGVkX1/mvy4p5T2lTbN5dV7fXS/2G8lvz4VRXIY27wWHi2HxkcrBTg3XgOHRio4k7EId2l2vMOrUIsyW1RFtDsDCObKBEOlt9KATOEEaooYfVUo1nFSA5dkQI2t33248//usvHAsESjA0HJgDbiCrbgQZYChw+5ZdIgwMKSbfdrKd/vERFtKaaHZbeidkURfZDzzuEEgDJQpNfhre4Ynth6/5MJEwxpP2xrQSaFhfv74BY2u8jbxPoEAx1ORKEDW7mTqVOA12RvOGt+ab58GFxM1mJCOcUdUFa1qCNF9HTYGHwkBUEFxOrORHuuMUmo6KsrBDmeMsgtYkNarNyT+qUMTlYVsUw20eznqkEx7KWIHoURAGudTL9xGLtxR4j6hlgHmQ/7sFiNUoRyDntKWOvEr0N/rUIxDrInf8G5qdoL10mtH4TvDErix8hnsNwF/Ioo3QVHWAQSMT6s5/O0w9Q7Wwc83K1i5a9KGtqiBGkUYXQEH/KRf6ZKC7MV/gKVEAkPzFUImjK2YvefbkLUxTHLmWmkz1oyi7e+0TI4gmCk2lPVJ5KIcGZ+BLm+A4xlEyLb8cXoaR+WSQJ+Lg8JUy0pXwoWnGCE7/kUG+eCvzH3DlXi1se0NUPcjf9HJWVt4uszy0RRe5ts6bRo65V/0x2qxMo8/EgiTi5XMaTWv7Y4Zw4B46DDdmoUC6Wz6TI3EdzftJQ9KIfA8vr1WQflbsh6u7M01AoLNpYVh8XN+pmyWGTjn2siBrqO4ycjoV/71FyK7+VXvulGBKrbU/xwb+hRfVyWTF5TCYgkxRJwn1qIFe0lrFur9XiDp4IUkN6mRpIk804iBU9gVrDxHKHjME72NrOnqfASZFsff6Bu5zWu2Gzr4jobw5oTUP3tLHjb9SPNtzkjMvxsX4LLxUC52WJycDPCGAq4FMZdJPFYDgdM8LBffHZasIO/e+XbnYWaprY9tk+pBut/7q2w
 BsuJMgNp
 CAB4+o+Mx83HXeLN+hiNhTVLnWtflYlZhdvUkY9ihDiiXp1hrGXUyLSjNPWWaB/t2m7Uc9XwwX6fNAKKr6uENM0lqhfRTVMRhJQTXjHpA7RGgVTbH06Txn3vgmnHz+IsSRLhZTjSrZpqS00KcpvRREJ4k5EThDhHz7Ylp8cs6XjK89H/4P0igA+PYWopPRyYgDa+tRvzLWRtszbkFcI7zh8R8VWlFJPSUxw3ik6LX8fQoGe0DN8xGVMQhDDM0GEfoI2VTkzjvRh0+MqTsx7usM5cT94+lcW7U6QqZDbCnAeXheqb6DziqntxI8PcAMOpZLkjNzfSVc6vAYz0o03VvuSBYGJnLxCIOK/XzTcWVRnZVOmPTob7D2pGbJazj1nK+JOYvjrw2t6j7QqfMmN9TjLRjG19uC5ree2ShK4mid5tRrYi2QfFsYlCs1bBoNw7mtJovGpxuUg4xLuFdYYiHeZGvIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 2, 2026 at 5:10 AM EST, David Hildenbrand (Arm) wrote:
> On 11/2/26 10:29, Zhenghui Hao wrote:
>>=20
>> On 2026/11/2 17:11, David Hildenbrand (Arm) wrote:
>>> On 11/2/26 10:06, Zhenghui Hao wrote:
>>>> alloc_contig_frozen_range_noprof() isolates [outer_start, outer_end)
>>>> before checking whether a __GFP_COMP request exactly matches the
>>>> allocated range.  If it does not, the function returns -EINVAL without
>>>> releasing cc.freepages, leaking the isolated pages.
>>>>
>>>> Call release_free_list() before returning -EINVAL, while the pageblock
>>>> is still isolated, matching the cleanup already used when
>>>> isolate_freepages_range() fails.
>>>>
>>>> Use WARN_ONCE() as well: the condition is reachable through the export=
ed
>>>> API, and repeated invalid calls should not flood dmesg.
>>>>
>>>> Tested with an order-9 free pageblock and a one-page __GFP_COMP
>>>> subrange:
>>>>   before: free_buddy=3D0, leaked=3D512/512
>>>>   after:  free_buddy=3D1, leaked=3D0/512
>>> How did you reproduce this? Using a hacky kernel module?
>>>
>>>> Fixes: e98337d11bbdf ("mm/contig_alloc: support __GFP_COMP")
>>> I thought we discussed this in the past: if you are able to trigger the=
 WARN
>>> something is messed up already.
>>>
>>>
>>> And indeed, same patch already here, SMH
>>>
>>> https://lore.kernel.org/linux-mm/20260629-free-pfn-on-alloc-contig-rang=
e-error-path-v1-1-496ff9ca22db@nvidia.com/
>> Thanks for the pointer, and sorry for the duplicate -- I missed the
>> earlier thread.
>>=20
>> You're right on both points: the reproducer was a synthetic module, not =
a
>> real workload, and being able to trigger the WARN means the underlying
>> path or validation needs fixing rather than papering over it with
>> WARN_ONCE.
>>=20
>> I'll drop this version and follow the existing thread. I'll check whethe=
r
>> the earlier patch is still pending and only send an update if there is a
>> real delta on the current tree.
>
> @Zi, are you still intending to follow up on the things we discussed in t=
hat thread?

Yes, I have the patch locally and will send it out today.


--=20
Best Regards,
Yan, Zi


