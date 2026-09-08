Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 872EAC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1046B0096; Tue,  8 Sep 2026 04:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7530A6B0098; Tue,  8 Sep 2026 04:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619D26B0099; Tue,  8 Sep 2026 04:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D87B6B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:41:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD478C047B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:41:34 +0000 (UTC)
X-FDA: 85189951308.13.EC60D43
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012008.outbound.protection.outlook.com [40.107.209.8])
	by imf23.hostedemail.com (Postfix) with ESMTP id 87156140007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:41:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="rk/bvfe/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.8 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788856891;
	b=7gBUAqeWD5dQ7vflZJLaPQbWj0Uea3vT7knw9H0vo4oDI1cR0yL4TMUz6awwGVwnYLf8RM
	wS3g2bKSiM0dadFBIo7Tzjo2kCqMZilKXjkw89wah136avN4IzQTxKvQxfFywQCUU1gY2U
	Cm0J5mLu2VR5m+tMQYk8yme2oSA/NJ0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="rk/bvfe/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.8 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788856891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZwjtQhyUkICgreryu2WOPt+4Unznjl33n+dXxEJTmU=;
	b=IX3WHy1CJU75nKu+JYLgllq6LaE969dHNRPhaJHfEgMyXdybky2msHiAYpUMn/MsD5nc3e
	vHoGrAJ420Nx9dpPI9pxGjGwpgErIJhZ4zlx7kBnBXIrhPK/1JbhJCfS2RC+BEuGmwRfBq
	0QwqBm3Z+1wJQCXRgBzNwWobGp6nS3E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qyHBxKch2ca5sz+b0F2s5LX4tn+6Fa9ZMKJFpEdPQI/JKF4lXF47cZGLaEMqfJ+p27dmNi2XuE/efGE7IFNnv0db3/zr5EDm6ECm8bF0uszCFBq9JHICbPMaHbsqS58aTKituuS3c9V4xIYg5OTzw0pHWDn9NcbqfiHa54CghNudIiDxg3wXIqky5zr7SAkdlNVyHjJc2/L1cThIviK9S3qRmTgFUC/fZd2Ci1IXdR9RbF6Po186qp1Ru8cFh1EHPcCBTvhvzlO191GR2WGsX3WIdb37CGfVEZSzjB33XpyjgLh7E8n0lk5NzhIu6F5Xgb5SFk1hAWeJKPuDrq8N2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZwjtQhyUkICgreryu2WOPt+4Unznjl33n+dXxEJTmU=;
 b=xhHDD7iX8yJ0759yD0eY0bdPzsDgAaq5WRq/7Xleba2DEIfJ+NLS0sk77amcHsqvd4L4wHXY/Ql5LCcPU6fDlyRR0IRu7mT+oZkOvQTpNk6m3vAqGp6N/9A3AuNiV2pTZ/6A8KBNkuWFfLFbxLuc0sXj9720KaFChl6N8H9tB3dsMW0kI6lfCmj0PltNeOb45Ey5nhGHXLmXCJ3E7n9LGnwyZd1It4/6+0YqnqvZkEcHtt/m/Og+lUPS1a7kEjqWmSb0MofnB3nhD1PnJYDI6XQuebz7sxahIEE5GLqOdEupKXhpaNMMAyAsj7fn3+01PqFO4/iN0Lfl1NzdLUQZ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZwjtQhyUkICgreryu2WOPt+4Unznjl33n+dXxEJTmU=;
 b=rk/bvfe/EzMJ9wbUmiXmiCxgnN3Ni/PqIBbcPJAkp+cnx6yRoo70NpXKWATVvYwRnro3trR3ZO0tckZ5RbJe1uKxhGLPgfPc8K+mINfgLVyQe2yH7EXo9/DOBaiI3QXc8jGy0gu26DLwIe2+pnGIMUJfSALO752mwsIV7zGHXY8=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS7PR12MB8084.namprd12.prod.outlook.com (2603:10b6:8:ef::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.15; Tue, 8 Sep 2026 08:41:25 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0382.007; Tue, 8 Sep 2026
 08:41:25 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
	<baohua@kernel.org>
CC: "hughd@google.com" <hughd@google.com>, "rppt@kernel.org"
	<rppt@kernel.org>, "chrisl@kernel.org" <chrisl@kernel.org>,
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "harry@kernel.org"
	<harry@kernel.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"riel@surriel.com" <riel@surriel.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "surenb@google.com"
	<surenb@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"youngjun.park@lge.com" <youngjun.park@lge.com>, "anshuman.khandual@arm.com"
	<anshuman.khandual@arm.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"kasong@tencent.com" <kasong@tencent.com>, "liam@infradead.org"
	<liam@infradead.org>, "jannh@google.com" <jannh@google.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"ljs@kernel.org" <ljs@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "mhocko@suse.com" <mhocko@suse.com>,
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "pfalcato@suse.de"
	<pfalcato@suse.de>
Subject: Re: [PATCH v2 5/8] mm/internal: rename swap offset helpers to
 softleaf offset
Thread-Topic: [PATCH v2 5/8] mm/internal: rename swap offset helpers to
 softleaf offset
Thread-Index: AQHdP23TCl1MibJBN0esUfaGpg2m3g==
Date: Tue, 8 Sep 2026 08:41:25 +0000
Message-ID: <e69e68f58afb8001613b710df6a602d490581292.camel@amd.com>
References: <20260901054358.4049095-1-dev.jain@arm.com>
		 <20260901054358.4049095-6-dev.jain@arm.com>
		 <CAGsJ_4yigbhqkrnufJKC2+rW7StraQvD0gr=4HQkTjKGQ9siGQ@mail.gmail.com>
		 <12efdc7f-ff82-412b-b79d-bff211d34218@arm.com>
		 <CAGsJ_4y7V40CnTTh=84=Ek6T3tPTyLXsUtgO81O1zyZpmQcbug@mail.gmail.com>
		 <8cc0b340-9526-47ac-abd4-3f5724963409@arm.com>
In-Reply-To: <8cc0b340-9526-47ac-abd4-3f5724963409@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DS7PR12MB8084:EE_
x-ms-office365-filtering-correlation-id: 144aaca8-f36a-4100-497f-08df0d84f7a2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|7416014|11063799006|4143699003|6133799003|56012099006|3023799007|10067099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 bPUdkvW860hR+gEpYpFlE69dRMjJPCpbiv6MPTq5V7Ra4Kwn9SlN5l3rGm0saPvh8uvMSs4gxXo3NFk7h/O2BH3Rbkfq0r+uOaPJe4uG77QSePnsTwOqkHRvCdE6u4B7tjtTQ2xetbeavafpE9B4P8mN4epTsIPNQtaN+wlGcacKfIC/hg2F4U8pXA3FswWHbzoHWPuT451XA3QkXNzHUNa0F6ZvyfvyuoqPOyIymGtl9IDqMqeJCCmHOAy+HuBJyBMkaYWQgvqs2Y8iQfHHVlb7qT3rQmUVzhueNvjPO6werg/gH+9W8uj6NAyAuZMj3pekkCqaoGlR/e3pGgFDBS9ciF2iFpC8KnpH9egCdhMWUVm6GPmBO2NjptC9tO2TgUeihY+UomdUUk0exjKfj6jtu87/8qNpJ1fku4H13mwQKrRIP6yw5MQVfxW1kxEIc0o+KCCVJ4YcVBqOjjkAhrOyfdYfXVUuoq7GqFUyukPyxBFYtf51AFL0thdnZhYpwVW6AaEXjbXfU2YjFG+GS56igp6eiBMjyszLezcitoeRuQu5W89aTW4GTa34RNxZTt+R8hTftc6e5gdoM9dnIW+dn0z3VAP7E7fbMSruYk2xJz87uuZo1hjt5/KN79UEPCPil2XLDvYTj9ur9otfgOGurXaoX9udxgN0XbdJzrMJZjduF5SBWkGs7wYfPfGVu2wfcSM149Qi9HSGuHhgaDe2280Cf99i82OlW5tSh8E=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(7416014)(11063799006)(4143699003)(6133799003)(56012099006)(3023799007)(10067099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?azdEZ3J4QjNiZk52Mk1HNU94L2F3V1huRlcrK0pXRE43cDY4YUdFMGovQlFX?=
 =?utf-8?B?a1pqMUkrbXNna0NiRGlxTmlteVA1RlV6N2dqbkxVSDVZVTlCOW41Q01JUWM2?=
 =?utf-8?B?TllKQzQwR2kzc2J5dGUrbTlqYjQvSnM5OThUWFNUT2Z0c3UrV2F2cGJpWS80?=
 =?utf-8?B?Y0RTMVQvU1J1TDAvMGRocjZnQ3dwZkVMcEN0UW1Sa3g5SDVoV3FOR296UlBD?=
 =?utf-8?B?aTNnSkhtZExlbUUvRTRxYkZtWjNrdk9HdWxqTFplZ1MzaThzQ1dXS1dFSER1?=
 =?utf-8?B?VWdvSVB1UmVEZ0Q4NlQxUDA2VFhXdW9xa0RVcktocVUrK05JZVhUMlF6Vms3?=
 =?utf-8?B?RWxYcUZkeTFIYWNuOFJBbVU0OG01akVFS0VYOGlWZWU1MWRMN1ppdjlxbHNj?=
 =?utf-8?B?THBiMTB6cXhHYzMwQTc5RGpnT1BTVHVqRVFnSG9YRUZlc3ptQ0lOeFY0TjVj?=
 =?utf-8?B?akQ0SjlBNDk3ZjBLOWl1VWFMeDhBNEpmSGFQS1FFZ1JlU01FWGg2akFPWUlN?=
 =?utf-8?B?R2dhNXhCMVhBWkFNbG1PcndXZnJjbk80MURBRzkwdVpycmw3ODk5TzB3bXRZ?=
 =?utf-8?B?ZVdKaVZPSzhoT1d6dDd0c0Yvb2syMjBaeHZkeUdoalBobEpOODF0eXFkYUpl?=
 =?utf-8?B?RHJqcWJGR1BjWHpTSHgzTk1IM0xiL05lcm5ENmo4NGxLclZaVTRJaEUwMGU4?=
 =?utf-8?B?d3VKNnc4Z0kxZ0pxQThsSHA0NEFnL21WbU1WUXZaZVB5ZWFaZ1hDdEtzSFNz?=
 =?utf-8?B?ZDVuQVhhRlRDZVozSUJma0dwUHBkY1Zuem1seE43S0NjNFdlMFlXN3RjNmNK?=
 =?utf-8?B?bTRoUzY1eEVmRURMbEpJYWxLVWNqNkl6SWRkczBpT3BrOEFTV3BkWTBWeXVI?=
 =?utf-8?B?NmdpRWdiSmpHbU4wek83ZkhYUG81ZExJNGFld3R3T2l4K0JReUdUOTlKcTdL?=
 =?utf-8?B?aE1Md0x2VzBnMlNZVGFYMHphMGN1dHVndlI5UFFma1VOM0dmNFBicjc3ejYy?=
 =?utf-8?B?dFBTdFFTTnRNb2w4Q0lnMEVuTGI3eDlsc3d6LzhqVWZpR3NsdFdZN2c2cnJs?=
 =?utf-8?B?NGRkdWNySzRyT1FlQVBFeENVSlc4djJ4dG5jOUErc2UxLzdiY0Z6dzkzTkE0?=
 =?utf-8?B?Q213Nk1lVHdkdVVvaGFVN2NHbEE4NCt5cnJrUDhWZTZDMytPd1pYakZoem1P?=
 =?utf-8?B?OS83Z04yeS9QWXlRWGRZRXNNL0FUdEl2dTRpTzM3emNDTDdSZWdKemtQMnEw?=
 =?utf-8?B?ZDJ2Kzdtc2hpc2hMK3dmN2hPbGVLZ1ZaR0FDM2VKMlJRVzljbkc2YndZS1lv?=
 =?utf-8?B?SGlVTnFDZnBCOWRWVjdIU1lIQUFtWE5SQjdMeFpCWUcxQUtOdFhaZWlFRito?=
 =?utf-8?B?MWFzaWIrUXBiZkt4TzdZOGNsUFJNRHB1amMxZjY5MUFoTkNVdTd6Y1hpQ0hG?=
 =?utf-8?B?MytkRGI5Mk1hOEVqczdPSDVycTJEQWlNVitFQkMybnVyemRSOTlmN0EveGts?=
 =?utf-8?B?OE1yeTNpVmZxZnpheW9yZFA5RXBkZ1VnMGcvRWM2QmNTWFozMFRZeUlxWk1l?=
 =?utf-8?B?NzA5eTRRN0RyQU9mejhVR0xsSDF4dVhXTlVLeDNFMjZnaUJJd2V4K2l4dlhK?=
 =?utf-8?B?ZTJ5MG5Tbk9YUi9kTGlvWlM4aFhwNytVaGFDNEZ3bjBGQXhHR0o0OGJsOE5W?=
 =?utf-8?B?dmNIcHcxTlo5WVExQ0c3YzZ3bHJNSkc0cjV6NUcwSjZoM3d2bmM1ckxWb2Qx?=
 =?utf-8?B?eE9ObFdkT3hkUDVhKzZhaWk1c3B4cklDeUZDMUxDWnFmVVdRdi81RXFnVTk5?=
 =?utf-8?B?TXpHNFBudytmM0d4b1ZkakwrdjBGL05RNm1YdnZaalV3OGpDN3RnK05YZ0g3?=
 =?utf-8?B?d21PSFFiUnZ0K3l5THNQUjRXYXpSYi9MWWt2d01XS3FoaTRvSnlWeTlBQktw?=
 =?utf-8?B?UzBoTFFQWkgxNGt6QmZKY0FGY0VtVzFQcDJlcVQ4SGk4Z2ltMjZxNnFXU0hQ?=
 =?utf-8?B?cHhzZFZHQzJUVElkOHN0cy9CejlUWWRZTWdCN1FvbkE5VXBKZFUwRlVlV0I0?=
 =?utf-8?B?UithRnFPK2NuMzRMWHlUcFM1TlhpbzFvdDQ3bWx4YkxVcC9lVFRBZFYrRGQ1?=
 =?utf-8?B?TUt6b0JvNEp4cVFBNmZxY2lOUUJ0amhjWVcxYkVUV1liNGNCZFhOYWE3bjJL?=
 =?utf-8?B?TUpNY0lBNGtCbHhtWlppWjNaZEdDRFc5cjJ5OGFIRitidm4wNE5Od0lnNWsw?=
 =?utf-8?B?QUIyVG8yRFhReW1lZitqNmV2ZEJ5MHlEUUxkNU5aQVFzOHBHNjVGdUZPTmx1?=
 =?utf-8?B?U2VFME9reENtZEJEMDV2d3IvZUMrSUNKZ1dhbTVJcGFGU2ZYVC9BUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B481BF83AAE8B34BB8E311537F64C9B8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 144aaca8-f36a-4100-497f-08df0d84f7a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2026 08:41:25.1330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hzu4NDJxSZ5Ifq+uSx41yU0qmqqojVBV26KDlzJc4FITN31qCfAd7QenssK4C31GwxrCJzLzG62Pu4p/w85L6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8084
X-Rspam-User: 
X-Stat-Signature: 1ei51tuys6jbkyrkttgzo8n13j6ibt7s
X-Rspamd-Queue-Id: 87156140007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788856891-142674
X-HE-Meta: U2FsdGVkX1/xxkJK1YyssDH6+YVy7WA/Fl8Kxt3FgMuTpO2n4nrjnyFp8m2QlhBqfa49o20mqzZfyrSgXpqaa8HFSgykaAxyf3G/vYw2ZtfTGIGaKjcEOyH3y5ebgyfYRWckFPDBrj/JhnpELZ3EJYOmRsfsWZGm32d/rBhG7aw8dDPW2mlVNvmRA/qrhk2JDg1mL97VeoiGte6LDOHQQKHubM4IOGzHeNzObQIB87zWC9rD8DfYWQweAVpUI2rW/2EVLTsTnGM3DlhBxGlNntyE0yaSTcoVP8CN05mFhqUGrls/FnuovrvIXjjPDTZR+WCbwlt5jqFAjLiybMJqbyJhsvmgLP/WPjKhpozmD84ZmFftIFP1aDRBx/wGjc1uXdH2W00Qe9oiTwnW2FDJGx7/bBZxPky+2eBGkSCPWD7cpsQ3XEiADRIqEnFrL8nK1qNMtFK9tZpPxpdJoFatio9uOXX9xczC2dayKVfi/gUVBaAHBKcGrs9NRkePzDSCOtHhtEMD6eJXcxe69UxZXzeXJz6Gbx9K1b3bo/MxYyvzTpQ9tV7mZXOa62ciYVEB1krgKamIAhX2rM7M9NYP/2/24CZablGkA//wurF+hBU1ABsbSvVWmWPv7hyrbnQTUTha2crNjr8aA1Yo2cZP+BoH7NOAmPY0rLhakydwLpBbHtCK/aUyzt2dHkGhKXmahP/R1FJIq97xHlUId8ywPonot4kbGck9tF8GJk2IQN/AhnZ3O8iuuFVRGtk1PzY8YhIXYRwDMpAfS/NaHyKjuUMagYQe30H2u5uHvijGnqxWh/y0aVxFuR4+NAvVii7tsnxMzTOXElXY6SB0xj1xm/CF7Qvn4cAIguaD1ceE1j5okSLFBEtdJLiPVfBZrKsLykRXdzQIj3UPdYqrRHKaeMnMnDzsvNRuQ4u8riaaOVcYWuf3w+eQwPnzTpDqf74Xqmy0hfIlQC2mmkhG/X8
 PdNTy1gb
 DLp9eYuNT23BWAU123G4eAR4BadA6U4KZk8+uaKl6YB2CW7uNWCI9ojl+sD7HcEGAxjXSEr44uekR1kn5Cme39cskmHjwU/TcZVWtsexLaItk/g4Rk2tyNAqeE47W/dKJd7xC0bbg5qoLp8HNFMBI4bpEmZ2nyYeFjdBWCQeDXGmHjXqfJxdNDMhSOidvskjnbTTDbuV4dec7t5cDO4pZ8bH6m9Q9ssMueqvT2gGgi/40CuyzZairymUK2JZr1OReNUZF7QyUkPl7q6uZnqtfPiaTNRboq8PUGNIG/pbEcZIdDhVCmsWmrCVt/2jqCUoOH4fYVCww69vzmhW7tjpYpkd0Cj/9/3QpEdAKqhnXSrkjb3kpu7PuD4uDKOPjieBva8LezzcXcWVAIKlETYU4abX7mGwXEBm3NhH+55It1VPN81GW1621IS9mXWuXr2V3Po6PZcX/ot5x0k3T5iFadLlizcOzSD+DksHXkEGQ8gx2MtrhuP4rtGhFeJV439LY0uCa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVHVlLCAyMDI2LTA5LTA4IGF0IDExOjA4ICswNTMwLCBEZXYgSmFpbiB3cm90ZToNCj4gDQo+
IE9uIDA4LzA5LzI2IDM6MDMgYW0sIEJhcnJ5IFNvbmcgd3JvdGU6DQo+ID4gT24gTW9uLCBTZXAg
NywgMjAyNiBhdCAxOjM44oCvUE0gRGV2IEphaW4gPGRldi5qYWluQGFybS5jb20+IHdyb3RlOg0K
PiA+ID4gDQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gT24gMDUvMDkvMjYgNDoxMiBwbSwgQmFycnkg
U29uZyB3cm90ZToNCj4gPiA+ID4gT24gVHVlLCBTZXAgMSwgMjAyNiBhdCAxOjQ04oCvUE0gRGV2
IEphaW4gPGRldi5qYWluQGFybS5jb20+IHdyb3RlOg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IElu
IHByZXBhcmF0aW9uIGZvciBhZGRpbmcgYSBoZWxwZXIgdG8gc2V0IHNvZnRsZWFmIHB0ZXMgaW4g
b25lIGdvLA0KPiA+ID4gPiA+IGdlbmVyYWxpemUgdGhlIHN3YXAgZW50cnkgaGVscGVycyBzaGlm
dGluZyB0aGUgc3dhcCBvZmZzZXQgYnkgZGVsdGEsDQo+ID4gPiA+ID4gZm9yIHNvZnRsZWF2ZXMu
DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gTm90ZSB0aGF0IHRoZSBzb2Z0LWRpcnR5IGJpdCwgZXhj
bHVzaXZlIGJpdCBhbmQgdWZmZCBiaXQgcHJlc2VydmF0aW9uDQo+ID4gPiA+ID4gd2lsbCBzdGls
bCB3b3JrIGZvciBub24tc3dhcCBzb2Z0bGVhdmVzLCBzaW5jZSBhIHNvZnRsZWFmIGVudHJ5IGlz
DQo+ID4gPiA+ID4gY29uc3RydWN0ZWQgb3V0IG9mIGEgdHlwZSBhbmQgb2Zmc2V0LCBhbmQgdGhv
c2UgYml0cyBhcmUgYWhlYWQgb2YNCj4gPiA+ID4gPiB0aGUgc29mdC1kaXJ0eSwgZXhjbHVzaXZl
IGFuZCB1ZmZkIGJpdHMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gRm9yIGV4YW1wbGUsIGZvciBh
IG1pZ3JhdGlvbiBlbnRyeSwgcHRlX3N3cF9leGNsdXNpdmUoKSB3aWxsIHJldHVybg0KPiA+ID4g
PiA+IGZhbHNlLCBhcyB0aGUgZXhjbHVzaXZpdHkgaXMgZW5jb2RlZCBpbiB0aGUgdHlwZSBpdHNl
bGYNCj4gPiA+ID4gPiAoU09GVExFQUZfTUlHUkFUSU9OX1JFQURfRVhDTFVTSVZFKS4NCj4gPiA+
ID4gDQo+ID4gPiA+IEkgZG9uJ3QgcXVpdGUgdW5kZXJzdGFuZCB3aHkgeW91IG1lbnRpb24gdGhp
cy4gSXMgYW55b25lIGNhbGxpbmcNCj4gPiA+ID4gYHB0ZV9zd3BfZXhjbHVzaXZlKClgIG9uIGEg
bWlncmF0aW9uIGVudHJ5PyBTaG91bGRuJ3QgaXQgb25seSBiZSBjYWxsZWQNCj4gPiA+ID4gd2hl
biBgc29mdGxlYWZfaXNfc3dhcCgpYCBpcyB0cnVlPw0KPiA+ID4gDQo+ID4gPiBZb3UgYXJlIHJp
Z2h0LiBJIGp1c3Qgd2FudGVkIHRvIGVtcGhhc2l6ZSB0aGUgc2Vjb25kIHBhcmFncmFwaCAtIHRo
YXQgdGhlDQo+ID4gPiBwdGVfbW92ZV9zd3Bfb2Zmc2V0IHdpbGwgYWxzbyB3b3JrIGZvciBzb2Z0
bGVhZiBlbnRyaWVzLiBCdXQgSSB0aGluaw0KPiA+ID4gdGhlIHRoaXJkIHBhcmEgY29uZnVzZXMg
bW9yZSwgSSdsbCBkcm9wIGl0Lg0KPiA+IA0KPiA+IEkgd291bGQgcmF0aGVyIGludGVycHJldCB0
aGlzIGFzIG1lYW5pbmcgdGhhdA0KPiA+IGBwdGVfbW92ZV9zb2Z0bGVhZl9vZmZzZXRgIHdpbGwg
YWxzbyB3b3JrIGZvciBzd2FwIHNvZnRsZWFmcywNCj4gPiBzaW5jZSBgcHRlX21vdmVfc29mdGxl
YWZfb2Zmc2V0YCB3aWxsIGNhbGwgc29tZSBwdXJlLXN3YXANCj4gPiBmdW5jdGlvbnPvvJ8NCj4g
DQo+IFllcywgc28gaWYgeW91IHNlZSByZW1vdmVfbWlncmF0aW9uX3B0ZSwgdGhlcmUgcHRlX3N3
cF91ZmZkIGFuZA0KPiBwdGVfc3dwX3NvZnRfZGlydHkgYXJlIGJlaW5nIHVzZWQuIFNhbWUgd2l0
aCByZXN0b3JlX2V4Y2x1c2l2ZV9wdGUNCj4gKGZvciBkZXZpY2UtZXhjbHVzaXZlIHN0dWZmKS4N
Cj4gDQo+IFdoaWNoIG1lYW5zIHRoYXQgcHRlX3N3cF9leGNsdXNpdmUgaXMgdGhlIG9ubHkgb25l
IGJlaW5nIHVzZWQNCj4gKm9ubHkqIGZvciBzd2FwIGVudHJpZXMuDQo+IA0KPiANCj4gPiANCj4g
PiBXb3VsZCBpdCBiZSBwb3NzaWJsZSB0byB1c2UgYGlmIChzb2Z0bGVhZl9pc19zd2FwKCkpYCBm
b3INCj4gPiB0aGVzZSBjYXNlcyB0byBtYWtlIHRoZSBpbnRlbnQgY2xlYXJlcj8gb3Igd2UgY2Fu
DQo+ID4ga2VlcCBib3RoIHB0ZV9tb3ZlX3NvZnRsZWFmX29mZnNldCBhbmQgcHRlX21vdmVfc3dh
cF9vZmZzZXQ/DQo+IA0KPiBTbyBpbiBteSBwYXRjaCBJIGNhbiBkbw0KPiANCj4gaWYgKHNvZnRs
ZWFmX2lzX3N3YXAoZW50cnkpICYmIHB0ZV9zd3BfZXhjbHVzaXZlKHB0ZSkpDQo+IA0KPiBUaGF0
IHdvdWxkIG1ha2UgdGhlIGludGVudCBjbGVhci4NCj4gDQo+IA0KPiA+IA0KPiA+IEFzIGBwdGVf
bW92ZV9zb2Z0bGVhZl9vZmZzZXQoKWAgaXMgZ2V0dGluZyBhIGJpdCB3ZWlyZCBub3csDQo+ID4g
YSBnZW5lcmljIHNvZnRsZWFmIGZ1bmN0aW9uIGhhcyBhIGxvdCBvZiBzd2FwLXNwZWNpZmljIGNv
ZGUgaW4gaXQ6DQo+ID4gDQo+ID4gc3RhdGljIGlubGluZSBwdGVfdCBwdGVfbW92ZV9zb2Z0bGVh
Zl9vZmZzZXQocHRlX3QgcHRlLCBsb25nIGRlbHRhKQ0KPiA+IHsNCj4gPiAgICAgICAgIGNvbnN0
IHNvZnRsZWFmX3QgZW50cnkgPSBzb2Z0bGVhZl9mcm9tX3B0ZShwdGUpOw0KPiA+ICAgICAgICAg
cHRlX3QgbmV3ID0gX19zd3BfZW50cnlfdG9fcHRlKF9fc3dwX2VudHJ5KHN3cF90eXBlKGVudHJ5
KSwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAoc3dwX29mZnNldChlbnRyeSkNCj4gPiArIGRlbHRhKSkpOw0KPiA+IA0KPiA+ICAgICAgICAg
aWYgKHB0ZV9zd3Bfc29mdF9kaXJ0eShwdGUpKQ0KPiA+ICAgICAgICAgICAgICAgICBuZXcgPSBw
dGVfc3dwX21rc29mdF9kaXJ0eShuZXcpOw0KPiA+ICAgICAgICAgaWYgKHB0ZV9zd3BfZXhjbHVz
aXZlKHB0ZSkpDQo+ID4gICAgICAgICAgICAgICAgIG5ldyA9IHB0ZV9zd3BfbWtleGNsdXNpdmUo
bmV3KTsNCj4gPiAgICAgICAgIGlmIChwdGVfc3dwX3VmZmQocHRlKSkNCj4gPiAgICAgICAgICAg
ICAgICAgbmV3ID0gcHRlX3N3cF9ta3VmZmQobmV3KTsNCj4gPiANCj4gPiAgICAgICAgIHJldHVy
biBuZXc7DQo+ID4gfQ0KPiA+IA0KPiA+IEFtIEkgbWlzc2luZyBzb21ldGhpbmcgaGVyZT8NCj4g
PiANCj4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBTaWduZWQtb2ZmLWJ5
OiBEZXYgSmFpbiA8ZGV2LmphaW5AYXJtLmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+IFJldmlld2Vk
LWJ5OiBCYXJyeSBTb25nIDxiYW9odWFAa2VybmVsLm9yZz4NCj4gPiA+IA0KPiA+ID4gVGhhbmtz
Lg0KPiA+ID4gDQo+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+ID4gLS0tDQo+ID4gPiA+ID4gIG1t
L2ludGVybmFsLmggfCAyOSArKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQ0KPiA+ID4gPiA+
ICBtbS9tZW1vcnkuYyAgIHwgIDQgKystLQ0KPiA+ID4gPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDE3
IGluc2VydGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiBbLi4u
XQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+ICAvKioNCj4gPiA+ID4gPiBAQCAtNTIzLDcgKzUyNCw3
IEBAIHN0YXRpYyBpbmxpbmUgcHRlX3QgcHRlX25leHRfc3dwX29mZnNldChwdGVfdCBwdGUpDQo+
ID4gPiA+ID4gICAqLw0KPiA+ID4gPiA+ICBzdGF0aWMgaW5saW5lIGludCBzd2FwX3B0ZV9iYXRj
aChwdGVfdCAqc3RhcnRfcHRlcCwgaW50IG1heF9uciwgcHRlX3QgcHRlKQ0KPiA+ID4gPiA+ICB7
DQo+ID4gPiA+IA0KPiA+ID4gPiBXZSBtaWdodCBmaW5kIGEgdXNlciBmb3IgdGhpcyBpbiB0aGUg
ZnV0dXJlLCBpbiB3aGljaCBjYXNlIHdlIG1pZ2h0DQo+ID4gPiA+IHdhbnQgdG8gcmVuYW1lIGBz
d2FwX3B0ZV9iYXRjaCgpYCB0byBgc3dhcF9zb2Z0bGVhZl9iYXRjaCgpYD8NCj4gPiA+IA0KPiA+
ID4gVGhhdCBpcyB3aGF0IGlzIGJlaW5nIGRvbmUgaGVyZToNCj4gPiA+IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2FsbC8yMDI2MDgxMy1taWdyYXRlLXJtYXAtYmF0Y2gtdjItMS0zYzU0MjRjNTU1
YzdAYW1kLmNvbS8NCj4gPiA+IA0KPiA+ID4gSSBkb24ndCBoYXZlIGEgc3Ryb25nIG9waW5pb24s
IEkgY2FuIGFsc28gZ2VuZXJhbGl6ZSB0aGlzIHJpZ2h0IG5vdy4NCj4gPiANCj4gPiBJIGRvbid0
IGtub3cgaG93IHlvdSBhbmQgU2hpdmFuayBhcmUgY29sbGFib3JhdGluZywNCj4gPiBzaW5jZSB5
b3UncmUgYm90aCBjaGFuZ2luZyB0aGUgc2FtZSB0aGluZyBhdCB0aGUgc2FtZSB0aW1lIDotKQ0K
PiANCj4gV2UgYXJlIG5vdCBjb2xsYWJvcmF0aW5nIHJlYWxseSA6ICkgaGUgc2hvdWxkIGhhdmUg
aWRlYWxseSB3YWl0ZWQNCj4gZm9yIG15IHBhdGNoc2V0IHRvIGdvIGluIGZpcnN0IHNpbmNlIEkg
d2FzIGRvaW5nIGJpZyBjaGFuZ2VzIGluDQo+IHJtYXAuYy4NCj4gDQoNCkp1c3QgdG8gY2xhcmlm
eSwgbXkgc2VyaWVzIGlzIGFscmVhZHkgYmFzZWQgb24geW91ciBWMSBzZXJpZXMsIGFzIG5vdGVk
DQppbiBpdHMgY292ZXIgbGV0dGVyIGFuZCBiNCBwcmVyZXF1aXNpdGUtbWVzc2FnZS1pZC4NCg0K
VGhlIGludGVudGlvbiB3YXMgYWx3YXlzIGZvciB5b3VyIHNlcmllcyB0byBnbyBpbiBmaXJzdC4g
SSBwb3N0ZWQgbWluZQ0KbWVhbndoaWxlIHRvIGNvbGxlY3QgcmV2aWV3IHJhdGhlciB0aGFuIHdh
aXQgZm9yIHlvdXJzIHRvIGxhbmQuIA0KDQo+ID4gDQo+ID4gSG9wZWZ1bGx5LCB3ZSBjYW4gZ2V0
IG9uZSBvZiB5b3VycyBpbnRvIG1tLW5ldyBmaXJzdCwNCj4gPiBhbmQgdGhlIG90aGVyIG9uZSBj
YW4gZmluZCBhIHdheSB0byByZXNvbHZlIHRoZSBjb25mbGljdHMuDQo+IA0KPiBZZXMuDQo+IA0K
DQpJIGFncmVlIHRoZXJlIGlzIHNvbWUgb3ZlcmxhcCBpbiBybWFwLmMsIGFuZCBJIHdpbGwgcmVi
YXNlIG15IHNlcmllcyBvbiB5b3VyDQpsYXRlc3QgdmVyc2lvbiB0byBhdm9pZCBjb25mbGljdHMu
DQoNClJlZ2FyZGluZyBzb2Z0bGVhZl9wdGVfYmF0Y2goKSwgbXkgcGF0Y2ggZmFjdG9ycyB0aGUg
Z2VuZXJpYyBsb2dpYyBvdXQgb2YNCnN3YXBfcHRlX2JhdGNoKCkgYmVjYXVzZSB0aGUgbWlncmF0
aW9uIHBhdGggKG1pZ3JhdGlvbl9wdGVfYmF0Y2gpIG5lZWRzIGl0Lg0KSSBzdWdnZXN0IGtlZXBp
bmcgaXQgaW4gbXkgc2VyaWVzLCBidXQgSSBjYW4gZHJvcCB0aGF0IHBhdGNoIGlmIHlvdSBwcmVm
ZXINCnRvIGNhcnJ5IHRoaXMgcmV2aXNlZCBwYXRjaFsxXSBpbiB5b3Vycy4NCg0KWzFdIGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2FsbC84OWQ4YzJkNmYzNWY3ZmRjMzQ0NGVhM2E2MmNjZDI0NDk0
NWQ5NjQ0LmNhbWVsQGFtZC5jb20NCg0KVGhhbmtzLA0KU2hpdmFuaw0KDQo=

