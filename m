Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7402E606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 18:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=0e0PAUw2
Received: by kanga.kvack.org (Postfix)
	id 700D06B0A9C; Wed, 25 Nov 2026 13:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1A86B0A9D; Wed, 25 Nov 2026 13:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5784B6B0A9E; Wed, 25 Nov 2026 13:40:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9C16B0A9C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:40:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A407841091
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:40:14 +0000 (UTC)
X-FDA: 85474506348.19.DB232F9
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	by imf08.hostedemail.com (Postfix) with ESMTP id 73C0C160013
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:40:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0e0PAUw2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.59 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795632011;
	b=aZ1cZcVx7wIlYieBMUC8absafr+HqICVM0w7sOpViGh6xOJE30JPPiRNboPfyW+KDTtR6p
	Jmax+4Xgnh7gA/AM99Zc1SbwJsCvZ9k0QsCIbWCDg/KHLr4XH5DPJexpLHAGn9GXb5rRDC
	OmQyYnJfefXJKvHwC51PqhPdDuw8d4k=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795632011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9wZ3OJyy//JK6t38gvEvNKmWTv5ou7MWiADrV7aqoU=;
	b=FvXQ9QJ3sYRscX8GiuwNHxvSitp2QjpEalw87qFk8Ydo6UdBwzDWdk+7j+MV18Q4Bhi1e/
	Dglq5Zl4VcfKYWXHvTq42N1XaBckZydXIZ9zlGTBi9rFH6kEjvZ0DmaTSPxdwaqy+vdDd2
	kUX+dMExSGjUUVosBgubjU2bOX55jyQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0e0PAUw2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.59 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fm6kteYvy/FFPwB4vUmoBp2Xm4iWeNFVDININustcCkW/zIfs08+f5/exXobMYJq0BfN3u/VCSFjvDk+Ww2HMdn5HzMFysjggakW6UeBIUlBC0iwINPp8rc28LKZLeBak6e1mwZtTgask/u8r+5S+PbpB3WRGmoFXapAeiNOCdfcqa+OOrC5Np1KIM9RCV1ZBZdB40jwsb0Ipa8kWDveYoM5NMh2sGcITFIkrhigfOd+XZpVDHhHex16g+ipffb/NiEU1vKfSxD2Df94KpLWKxXDyz4ZCWB171fPRwd3dhrEHlWYwuE1cDRPaUVoAVp2oLaeaehIjJ6lDF9la5IDNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g9wZ3OJyy//JK6t38gvEvNKmWTv5ou7MWiADrV7aqoU=;
 b=HZDsemcLjk4OVx1u9mgpX1hOaFtzIke8bFd/XIuMJVzx1ojGAn/nN5oGjny9bdlLrVUMcnYZzU84LTTNEjk0qBZy874GEvzHTrMwYh5fm9anocudnHTeo59UI5rMkwKfjAMapDXvTDMQC4WfcnvjVYnGbD+RCZjDwWvFnqkNTNx80D4zsVN7pRMnHgtgSOOZQjEErYXS5F7XKBlrA6vbxlDkQuG5Sv8z+GQyH3gAFiN7YaL6D663itJ7Kc+f/mQKZgiplJHNRjsSB3HIuajqSPzdrX3ZRi2IU65z57ATtYEf3qLAScWNUf8ogpsAlxNoPjkpWYgEywUdjUk5m2Yr4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9wZ3OJyy//JK6t38gvEvNKmWTv5ou7MWiADrV7aqoU=;
 b=0e0PAUw2fIryKKwq+b0UAzwCq8GacjCbL8qTmN25cLnXVuf9VNw1yRm5cUIIbK4t7BZTgtSY5XyVJ9y3D3ZrBesXXW+yfAL7P3yc8/nQOJvYM27kNCpUlJkkPNCsP2bQIMCCi0ZWkEUp+84U69Ox1L1wxitIixW+4oizp1xunpo=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DM6PR12MB4329.namprd12.prod.outlook.com (2603:10b6:5:211::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 18:40:05 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0662.001; Wed, 25 Nov 2026
 18:40:05 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "dev.jain@arm.com" <dev.jain@arm.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>
CC: "hughd@google.com" <hughd@google.com>, "rppt@kernel.org"
	<rppt@kernel.org>, "chrisl@kernel.org" <chrisl@kernel.org>,
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "harry@kernel.org"
	<harry@kernel.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"riel@surriel.com" <riel@surriel.com>, "david@kernel.org" <david@kernel.org>,
	"anshuman.khandual@arm.com" <anshuman.khandual@arm.com>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "surenb@google.com" <surenb@google.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "youngjun.park@lge.com"
	<youngjun.park@lge.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"kasong@tencent.com" <kasong@tencent.com>, "liam@infradead.org"
	<liam@infradead.org>, "jannh@google.com" <jannh@google.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"ljs@kernel.org" <ljs@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "baohua@kernel.org" <baohua@kernel.org>,
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "pfalcato@suse.de"
	<pfalcato@suse.de>, "mhocko@suse.com" <mhocko@suse.com>
Subject: Re: [PATCH v5 0/8] Optimize anonymous swapbacked large folio
 unmapping
Thread-Topic: [PATCH v5 0/8] Optimize anonymous swapbacked large folio
 unmapping
Thread-Index: AQHdfQxhV05CbM2dUE+N91SB0PqcxQ==
Date: Wed, 25 Nov 2026 18:40:05 +0000
Message-ID: <70ebf57c53c26fe7cb129b2554193c0fd9b77998.camel@amd.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
	 <20261122224612.8e7f1bafa2b712521a95ed79@linux-foundation.org>
	 <0e23a777-03bb-4363-80c4-e2b90ebf49e5@arm.com>
In-Reply-To: <0e23a777-03bb-4363-80c4-e2b90ebf49e5@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DM6PR12MB4329:EE_
x-ms-office365-filtering-correlation-id: cde4fa4a-d728-4282-f9bb-08df4b23862b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|6133799003|22082099003|18002099003|4143699003|56012099006|11063799006|261021121427099003|261022105027099003|261022075727099003|261026140227099003|261028144727099003|261026121527099003|261102123227099003|38070700021|10067099003;
x-microsoft-antispam-message-info:
 XfJxY11hslHTUGYDcFKg7+2EmS7WsZml/ntSd+5Hq6go8tY8IsvoxXsiNH2WHB8mcoCv/SQ5KuLWg3IhWQ1Xr33MOxj/3AaCMKMo8yOWhnV81HJc68rzoPa2+DA4zSnrlpzQY6QImRNI5wUKvPbl55MN1RMCcUHIsEpa7WbODrm6UfmOzyQe+pkxm+hxd6VLPIFjk57ComcgNWdYq31RE5v5t2f6a+iwoIMkmtc8Af/FBXmTMQ0dhPRbaAyGZOr61wOs8vjuwdgoxdFR0HWUETZr5jbVZeYmAJaDlxg2OB7PCZTaNXpdOQ5/VCUmFLCPLza5f2YyO17V5L0zuv16Njapq8v9Dcw95NFuar/0eBd9tW/DaUY/OsQVA0s++eU4D/UqPp85YZz+RhIeg+a547k+AbRQFTVhl1emm804IsCHodbdgWg+pogJ4FBSI71qaSqsIW4cGUuQ+2UJxBKroDc9A4LFaurSoQ4YIff15UHVVu6nIM8eMtfLqr4qs9A/rOi+7+V/IjPeHVEGrlaFbOWbnL/CKHrxdM4LKQde2Vu3mSekG3t2pmf9+SkLurWlZgD6BDjkkyXZ3+w2RZ0uU7nzX7Y0bs43vbelrUswxjz3ZGbc29U8IIEwlurtB/NvGyGd9LxKu0cm6Bjbr+K4kNwt2zS9wAbpxMnygmLCV/A=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(6133799003)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006)(261021121427099003)(261022105027099003)(261022075727099003)(261026140227099003)(261028144727099003)(261026121527099003)(261102123227099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YkpwNFJXcS9pYXlGNHJWZGFPZ3ZLNEJEMGZ1ZXRmVDV3Q0ZrRlpBMzFxWXNQ?=
 =?utf-8?B?OVNFK09tVjd1NnE3WW5WbFR6RUJIdHFEOUZmWnd4UWJBekZ5VXBHNk1STlpW?=
 =?utf-8?B?NWpNN214WG05a0NacWs4L3lMSlNOQVhmSHAvVUxBWVR4TGMwdUFHL2ZCSzFF?=
 =?utf-8?B?Mlc1MXJYayszay9FRUpLNFFBbXpXNThQLzBPNWs1bmFTdDFkWkhBUU5GeW5W?=
 =?utf-8?B?bTlaeVFCbE1oNUV4Z0htMm44c004U0Y4MFlGb204dXhwVm14cmxJZG9vT0xh?=
 =?utf-8?B?TWpJb040RkxmdzRhTVBoeG5yNnJtaDF2R1dJWWNHelp0T1dzcjBXSzE5b1py?=
 =?utf-8?B?WVNhRnRRYW1TQVVYSHMrTE82L2EzZVBsTENrNUI3eFVBeEVZNlNVUlpNaTNr?=
 =?utf-8?B?M3N4dVZUdUQ1ZTdQN2FqWlNyQ21JSFhlUmI0bnB5bWoxNGZ0SnNLdHVSSVho?=
 =?utf-8?B?Y1ZJMi9ua1NMUmUwNnFrSUVCK0FUQ2dBTGFxcGtHaUlQUDJrZkxMREpIdmly?=
 =?utf-8?B?V0hYYjdrSGFpZWRqN0FSQUhuTFZpdW5uaVIvUkZVeU54UUF3M0k3em5jbFBh?=
 =?utf-8?B?NHYxLys4dExoWDBHc0ExdVpBQXZHdk9MOUNtOVQvd1YzdDQxbVNtdVM5Vm1l?=
 =?utf-8?B?TC84emQxajVjU0t5eC95L1k1ZEZjSFlnRmtSRmIvb0NXZUpnOUs1elNnWXp2?=
 =?utf-8?B?ZzFxMXFzY2ltUnYxTDBPM0pma0Nrc2xwT2srS0sxYjhuWjBMbFh5VEVqMzl4?=
 =?utf-8?B?OXdVQmFuME5iZE5GMEh3eTIydXBYRFJYWVVQQVVLNjVSeDVTc3hDS0JrM0hz?=
 =?utf-8?B?ZUhNelNzaVlzc09iYW9OL3BkTVQyK2N5NmdpZ0Y3Z2NMdFpHOWp1LzhUT1VL?=
 =?utf-8?B?OGZpc2Ewb1pIWmdJc3JOQ2hyeVRwZWR1WlNNUXhucWFBQmcxVTd4aGlYM2pl?=
 =?utf-8?B?ZWZrclBzRkVzYlNhOUhVRmQ1UVlnelpvQnBiaWlUVDVGQnlaQWpWVXh5Tmxy?=
 =?utf-8?B?VXJXb0VkQ09MU2ZPaDc2aU5ZVWMrRmU3VmxwTTdCUXVWcjg1K0wzbUN5ZnRq?=
 =?utf-8?B?azBZU1g1emRtUTdXUStjbElOWjh5MEtQc0VQdEwxQXNsWVFIVEZJLy91ejhv?=
 =?utf-8?B?cmhXWEVxQmFWbFFPKzQ0ZkIzd1NGVzRXRUVlWTRyUmxZUktaZVZRNTdQdUdh?=
 =?utf-8?B?SEZGc1NBVW9kZHJxajZCbXlHTDI0TmRXY0xXOS9Ib0JBR2Y3a2x5aDJwRDUv?=
 =?utf-8?B?eEVPcUR2NWc5bmdpcnZvWk1LU1NHcmhONzJYMkw4SnhpdGV4ak1Zeml6RVVR?=
 =?utf-8?B?VTlPUlR2UkZraEFORE9TcWwyekU1aFJmVEVOTmRTS0pJU1F1SHpNdlBOSDkx?=
 =?utf-8?B?TUs5WU9KeUEyWmVEdmpnc083dUNpUFo2Rm53RTJWRHBRQW41QVRXMGtkWUYw?=
 =?utf-8?B?TzVCakVmbnhSVEhHejlrbm01ZXl2VHhQNWIrVFFVZjV6cG1JcTdxU1k3ZXRC?=
 =?utf-8?B?c1FsQkxBMllzUEw5MGk3NG8rQWJCWXJqMktHNld4TmxONkhhcmJ1MHMwc3ZV?=
 =?utf-8?B?N0s1bVpreUN5K054ZmdyMU1NUVlyVFpiSWNQdGJabHBRVDdTaWVHZEtGS3g3?=
 =?utf-8?B?QUh2L0tIS3B0Zno3TVpOc3hIVm9MRkRoYjhTeXBtTnM2TzhxTVpRYnFsYS9N?=
 =?utf-8?B?NDIycWNCTmZKV3R5NnJoSGNXOUdLYTNxcElQQi9zYXZKVEE1S2RmeWdtM0pu?=
 =?utf-8?B?QVcxb2tjNW00dSthRkUrZHBqckluU0U5TEorSTlvSHErMUJkSXd4bG1PNE5t?=
 =?utf-8?B?M2pqekVKL0tBTVVWVG5jNEhIRVNOR3FZTUl1S01Td3AyV0g5NnZrQ0dyajhH?=
 =?utf-8?B?NWdCYkxRTWNRV0JMblVmRmZHcjNVM0ZQSzlqUlAxd3g1eGx3VTJVM3lTVG1n?=
 =?utf-8?B?T2R5a0VoV0k5czRUVWF0OUFiNG8wRnJxMmRKUkpIMlFaRWtBblp4VFZNRjZz?=
 =?utf-8?B?SGlJbXIrR1JEdThsNy9SSUxQK0lsdXNlVmgzTFJSYmlPdkFMdHBDNEh1YXUy?=
 =?utf-8?B?WDhLWEZMakNiT0xteEJpOHhlU3V5eGVTdEZTUnRORGovTklJbm9OOHIwaUdu?=
 =?utf-8?B?VVVkOG9EeUNzT2dSZlVpZWF0VzNObGo1Y3lGdEZGM2dWOWtBZm1vTVNhUUZH?=
 =?utf-8?B?dG8vVFZwZUV6bDBnTkxzMzFJMTRxR3F4SmJEaTc1Y0YvOWVmUjhLczNSNDY4?=
 =?utf-8?B?SWxuT2dxOW9sZDZTWWhnalN4OUtCVE9xZU1yTzFEVE1JbzNNVXhLUU81b21o?=
 =?utf-8?B?QU5rL0crbHlXQk01eE5aN1dkRVZoQlNQalpESW5MMytvVEtJQ3hoQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E86727338022274DB87E7CF976C6A832@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde4fa4a-d728-4282-f9bb-08df4b23862b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2026 18:40:05.6688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tuGEWhMyMw9fGTAvAU3Iuqmlg/9GT+1Q6sP53nrLIRiJ1sfEykKsbzvwg5+5y2GJRXRqD9sJwVPRBJRjp8HsnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4329
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 73C0C160013
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: asrstog88acwwjnb3wuubwu9y4w9xmkb
X-HE-Tag: 1795632011-284882
X-HE-Meta: U2FsdGVkX1+sHvGnz6jfaITvjKQZhKm4oJISCMAaiZfFrKfoNiol03sqa5sDEuIICiSznVHGidfVBc/+bjJ91fJTcGfyDNF1wocs0kUnRuabYoDzV24HTvqxAo5zBIEHNJPdzTBobz1SsP2ECM5ip32TaLBWQK9EwJJ5Ek+s10eOTgjX5TyMqy0IhGMeFiqle53EWt2il9lr0uesy1hpuQQRhLFluzxxZP3lvSFMOMYYwDvt8Xzq+66XDA1qM10oYqQ74IaNOcp1QOFQYoxRdc4umf0WI+6Cgkoe1vbnvR2lO1w+7TtR14/62v8mGNPx9q/O3Crpm63QQBOqYnrJESFthB8gcaVk7FRDdWEWWOXZi/4Y7Cw+DZdzwaDWJRKjVAiw6AwIKmzHO3heWC5M4fzA+MrZgAtik72R2psU3xkM6MC3zyvZw9/ygzrRWzyGqZV5Wyh9z63/xfypzKa2VdKk08tOB3wC0LGhw4tk6EudCn/n2GXqxppcMLz/8Rxl7VaeQpI3qBYV0hkHJXOJzNKRoo9/7jC0Gwgyrv7N76AZ+EeDQKolBTeSURQ/SAJV5Sz3VR3DnwVO6hBha1ktsLF1mtiPQLFgGheidlrG/7A8gVGXTVT0CzRI+k6z4rqiE2F5cIxN0JdwK1HaXsmOS1rPT8gRl6QB/VjjEBEgYHNfm1WSoSWPJiJT8A8jeosbwwC/ZVLopgM3zRZC0I+AzI5Q7oEsLVBhsu9zxOFwIke1pB0JPfGGBsI5yLmP2MBQWTyfLSvv7D0xVVAyE2XVKxhHGVFZJdkPZPNfCVC6L+hszg5QsbvkffHhvRW1LUlaThwnOaI+8V6imrvXWzhtRni7n0im8oGsXMKQ/49kcpZbM3pejhZrQwsS8YnFpHMD5M+6WQ1DgZV5oEoS9HocT1S8BY0TebKh4AL6pHjhLVpOeVdPhcbsWrXr+EMJvHG2JNMhQlUQHdAmNwoMPup
 mIBTmVLb
 7ooBX6IUL6uOExlKGWE2otv9b2FK5sZ/AiNR55jDemh+Dl6JdoAWOlI4drk3kVUoQ2bUJN/tT0gSZKiBmlftUvd8/InL9BokJKT/BIctoiLCUoj9fj5I09jld0q49nPGLHic+cxWuwe276IfAPUOUVQYN/psNUm/StYDo1dpbsqifBNq8kZMYo92yS5H6wYNMfsPsNtr2CaHnaIerFuxUI7hZp209+kyNGQ7I4Ijj0qMF8F6bS7MkuhWSGj6GmX9xBlZ9eZHSIFeVhu8X6IIVq9I56eI3k1dpmRGiQamCDvmVhCzuJOqyHw94GkOGKOqH2ZNBFGRTaxn09RwiCisegIjPf/zkqDDwPsEpbJNKWjs2a5uiH+Ys/BtClgfVEMV2FyimWJECE+nIczWlpSJQgTIiNl9ECql5waWRC2FCn475lkmuoA3Z5yaQ6Zi2sQpBQ9C7gHykqQ9kmiOsYoduLl+NeXEfrlAQes+GcJ0lL/eJSe9LdGdfrJZgcYTiIBORFx2S4HPukllUL7u4zXj9OfvdB0KNnj0llev+OuYD1DG4j5aXS4aq7L/XayaGw9xzXqoehchLNXL+hEJmm3/aPlC+DISdXEF8HONR1Rybuln8IN5GYcoQY1YfDBSbz0rpj6AcXPvDgEXYcMEQBR4RcXK5FuoudLtN1hZ8GqKgvVcBdas5mREfQ9fKVTBcob0p6Im/TuAZ3FsoED/y9/pqiDFLGVTkFBwU42xcG3ToK+4tkHfGkR3BitvTmvRCIVlCiIeiVohuf1CL4dv96Y+5wRxgMyT5UDH8zUOe8RTdZl4584Fc6qiF9K62A314Hn/LCSgGK2/iBa+hPNZ/OW24qsQk53pU1h6neLbQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gV2VkLCAyMDI2LTExLTI1IGF0IDEwOjA5ICswNTMwLCBEZXYgSmFpbiB3cm90ZToNCj4gDQo+
IE9uIDIzLzExLzI2IDEyOjE2IHBtLCBBbmRyZXcgTW9ydG9uIHdyb3RlOg0KPiA+IE9uIE1vbiwg
MjMgTm92IDIwMjYgMDU6MzU6MzQgKzAwMDAgRGV2IEphaW4gPGRldi5qYWluQGFybS5jb20+IHdy
b3RlOg0KPiA+IA0KPiA+ID4gU3BlZWQgdXAgdW5tYXBwaW5nIG9mIGFub255bW91cyBzd2FwYmFj
a2VkIGxhcmdlIGZvbGlvcyBieSBjbGVhcmluZw0KPiA+ID4gdGhlIHB0ZXMsIGFuZCBzZXR0aW5n
IHN3YXAgcHRlcywgaW4gb25lIGdvLg0KPiA+ID4gDQo+ID4gPiBUaGUgZm9sbG93aW5nIGJlbmNo
bWFyayAoc3RvbGVuIGZyb20gQmFycnkpIGlzIHVzZWQgdG8gbWVhc3VyZSB0aGUNCj4gPiA+IHRp
bWUgdGFrZW4gdG8gc3dhcG91dCAyNTZNIHdvcnRoIG9mIG1lbW9yeSBiYWNrZWQgYnkgNjRLIGxh
cmdlIGZvbGlvczoNCj4gPiANCj4gPiBDdXJpb3VzLg0KPiA+IA0KPiA+ID4gDQo+ID4gPiAuLi4N
Cj4gPiA+IA0KPiA+ID4gUGVyZm9ybWFuY2UgYXMgbWVhc3VyZWQgb24gYSBMaW51eCBWTSBvbiBB
cHBsZSBNMyAoYXJtNjQpOg0KPiA+ID4gDQo+ID4gPiBWYW5pbGxhIC0gTWVhbjogMzc0MDE5MTMg
bnMsIHN0ZCBkZXY6IDEyJQ0KPiA+ID4gUGF0Y2hlZCAtIE1lYW46IDE3NDIwMjgyIG5zLCBzdGQg
ZGV2OiAxMSUNCj4gPiA+IA0KPiA+ID4gcmVzdWx0aW5nIGluIG1vcmUgdGhhbiAyeCBzcGVlZHVw
Lg0KPiA+IA0KPiA+IEJpZy4NCj4gPiANCj4gPiA+IE5vIHJlZ3Jlc3Npb24gb2JzZXJ2ZWQgb24g
NEsgZm9saW9zLg0KPiA+ID4gDQo+ID4gPiBQZXJmb3JtYW5jZSBhcyBtZWFzdXJlZCBvbiBiYXJl
IG1ldGFsIHg4NjoNCj4gPiA+IA0KPiA+ID4gVmFuaWxsYSAtIG1lYW46IDU0OTg2Mjg2IG5zLCBz
dGQgZGV2OiAxLjUlDQo+ID4gPiBQYXRjaGVkIC0gbWVhbjogNTE5MzA3OTUgbnMsIHN0ZCBkZXY6
IDMlDQo+ID4gDQo+ID4gU21hbGwuDQo+ID4gDQo+ID4gV2h5IHRoZSBsYXJnZSBkaXNjcmVwYW5j
eT8gIEhvc3Qtc2lkZSBjYWNoaW5nPyAgV2FzIGFueSBJTyBhY3R1YWxseQ0KPiA+IGludm9sdmVk
LCBvciBpcyB0aGlzIGFsbCBDUFUgYnVybj8NCj4gDQo+IFN3YXBwaW5nIG91dCB0byBhIHN3YXBm
aWxlLg0KPiANCj4gPiANCj4gPiBNYXliZSBhcm02NCBzdHVmZiBzdWNoIGFzIHB0ZS1iYXRjaGlu
ZyBvciBUTEIgaW52YWxpZGF0aW9uIGF2b2lkYW5jZT8NCj4gPiANCj4gPiBJIG1lYW4sIHRoYXQn
cyBhIGh1dXV1dXV1dWdlIGRpc2NyZXBhbmN5LiAgV2hhdCdzIHVwIHdpdGggdGhhdD8NCj4gPiAN
Cj4gPiANCj4gPiANCj4gPiBBbHNvLCBCYXJyeSdzDQo+ID4gDQo+ID4gCW1lbXNldChhZGRyLCAw
LCBTSVpFX0JZVEVTKTsNCj4gPiANCj4gPiB3aWxsIHRyaWdnZXIgc3dhcF93cml0ZW91dCgpJ3Mg
aXNfZm9saW9femVyb19maWxsZWQoKSBvcHRpbWl6YXRpb24NCj4gPiB3b24ndCBpdD8gIFRoYXQg
bWF5IGFmZmVjdCB0aGluZ3MgYSBsb3QuICBEaWQgeW91IHRyeSB3cml0aW5nIG5vbi16ZXJvPw0K
PiANCj4gVGhhbmtzIGZvciBpbmZvcm1pbmcgYWJvdXQgdGhpcy4gVGhpcyBtZWFucyB0aGF0IEkg
aGF2ZSB0ZXN0ZWQgQ1BVIGJ1cm4NCj4gZXNzZW50aWFsbHkuDQoNCk9uIGJhcmUtbWV0YWwgWmVu
NSB3aXRoIHpyYW0sIEkgdGltZWQgdHJ5X3RvX3VubWFwKCkgaW4NCnNocmlua19mb2xpb19saXN0
KCkgd2l0aCByZHRzYyAoMjU2TWlCIE1BRFZfUEFHRU9VVCwgbXMpOg0KDQogICAgICAgICAgICAg
IHRvdGFsICAgICAgICAgICAgdHJ5X3RvX3VubWFwKCkNCiAgICAgICAgICAgICAgYmFzZSAgICB2
NSAgICAgICBiYXNlICAgIHY1DQogIDY0SyB6ZXJvICAgIDI1LjggICAyMS4xICAgICAgMTAuMSAg
ICA1LjINCiAgNjRLIGRhdGEgICAgNzMuMiAgIDY3LjYgICAgICAxMC40ICAgIDUuMg0KICAxTSAg
emVybyAgICAyMi4xICAgMTQuNSAgICAgICA5LjYgICAgMS45DQogIDFNICBkYXRhICAgIDY5LjMg
ICA2MC43ICAgICAgMTAuMSAgICAxLjkNCg0KSXQgaXMgQ1BVIHdvcmssIG5vdCBJTyBvciBjYWNo
aW5nOiB0aGUgdHJ5X3RvX3VubWFwKCkgc2F2aW5nIGFjY291bnRzDQpmb3IgbmVhcmx5IGFsbCBv
ZiB0aGUgZW5kLXRvLWVuZCBzYXZpbmcsIGFuZCBpdCBpcyB0aGUgc2FtZSB3aXRoIHplcm8NCmFu
ZCBub24temVybyBkYXRhLiBUaGUgemVybyBmaWxsIGRvZXMgaW5mbGF0ZSB0aGUgcGVyY2VudGFn
ZSwgdGhvdWdoOg0KaXNfZm9saW9femVyb19maWxsZWQoKSBza2lwcyBjb21wcmVzc2lvbiwgc28g
dW5tYXAgaXMgfjQwJSBvZiB0aGUNCnRvdGFsLCBhZ2FpbnN0IH4xNSUgd2l0aCBub24temVybyBk
YXRhICg2NEs6IC0xOCUgdnMgLTglKS4gDQoNClNvIHg4NiBiZW5lZml0cyB0b28uDQoNCg0KPiAN
Cj4gVW5saWtlIG15IG90aGVyIG9wdGltaXphdGlvbnMgbGlrZSBtcmVtYXAvbXByb3RlY3QgYmF0
Y2hpbmcsIGhlcmUgdGhlDQo+IHRyeV90b191bm1hcF9vbmUgcGF0aCBpcyAoaW4gY29tcGFyaXNv
bikgYSBzbWFsbCBwYXJ0IG9mIHRoZQ0KPiBNQURWX1BBR0VPVVQgb3BlcmF0aW9uLg0KPiANCj4g
SSBsb29rZWQgYXQgdGhlIGNvdmVyIGxldHRlciBvZiB0aGUgbXByb3RlY3Qgb25lOg0KPiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNTA3MTgwOTAyNDQuMjEwOTItMS1kZXYuamFpbkBh
cm0uY29tLw0KPiANCj4gRXZlbiB0aGVyZSB0aGUgeDg2IGRpZmYgaXMgdmVyeSBzbWFsbC4gQnV0
IG5vdGUgdGhhdCBoZXJlIEkgZG8gbm90DQo+IGludHJvZHVjZSB0aGUgdm1fbm9ybWFsX2ZvbGlv
KCkgbG9va3VwIGNhbGwgc28gd2UgYXJlIGRlZmluaXRlbHkNCj4gbm90IGxvc2luZyBhbnl0aGlu
ZyA6KQ0KPiANCj4gU28geWVzLCB0aGUgbWFpbiBiZW5lZml0IGlzIGZvciBhcm02NCBkdWUgdG8g
YmF0Y2hpbmcgVExCIGludmFsaWRhdGlvbnMNCj4gYW5kIGF2b2lkaW5nIHJlZHVuZGFudCBwdGUg
c2NhbnMgaW4gcHRlcF9nZXQoKSBmb3IgYXJtNjQuDQo+IA0KPiANCg0K

