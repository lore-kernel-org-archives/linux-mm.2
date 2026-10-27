Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B85606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 05:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=D6Sn4oUm
Received: by kanga.kvack.org (Postfix)
	id 55B266B05C9; Tue, 27 Oct 2026 01:09:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CB66B05CB; Tue, 27 Oct 2026 01:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D4ED6B05CC; Tue, 27 Oct 2026 01:09:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 120126B05C9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:09:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9695512095D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:09:06 +0000 (UTC)
X-FDA: 85367227092.08.20C18C6
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012049.outbound.protection.outlook.com [52.101.43.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6A12EC0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:09:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=D6Sn4oUm;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.49 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793077743;
	b=V4J4fKCVX67vKvhvVBTzqazEq8h/BMwWwbcyrtHWa2x7FIU9ETg0X3xu1wHLPSwA7WkdHQ
	/hZWCsOL0e7PLzZcmOkXA3cnKUStIclnQ2jU67m3AeYKxl1i8or0ML7cqmkOY65Qfpc1GK
	6hYm6ZdFB6q8M5DUKnFFxkYZVmwbM3k=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=D6Sn4oUm;
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.49 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793077743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MHJqqtSGrWoKg4K4K5y0vaBn51nOhYp5twnbWUOfjI=;
	b=rHTMU4hIoI8vhnUr5Kbfo/TfpTUsRLQ4CyPekKx3BjJQ2KrYRZo7LWsvNDxFJTx4deIDw8
	sGNcJV0ArPtmtS/+j9aalpkB1GXULZjrL1bstd14dUQbqhy/qjDAv8c3/XEBLqnXNcQqn9
	j6un7jQ8UKX+EsyBDXBrYQ7bmT+Z3Fw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mcc4WlYyiI5wvhPq0SmWFuVEuj2k8tHfB9wg9dnfvG53sgYR8kMye8CyvIlk2ZP2qW9BL603LUdUSigVB8hcLG0Cz8nMJYfSwfnOCRD6AEkSSPcgMF2hieycTD8sMHoEgZ0WEZI9GeGeUBArpYzoLg9FxYhveSYMSoJQLITih8f9/knSgbZAKeTY/qiYNJQd4HjlK/eyJsARgswDmN+lPwz5DWF1hVfVf4+x+01uLcg0Hp1bFVjkMrxqbm/80QpCBEbQr+PfTTbKpe272ZNkRRE0/KTkiHEbFVFo1Bau84YBRrBjmrDFQS4lbWhnT0XKEWHKRF7ocgdLem6c8nW1Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MHJqqtSGrWoKg4K4K5y0vaBn51nOhYp5twnbWUOfjI=;
 b=Mnxdrfc0ug3bfEK5jwASmNI2TqKbjW1OvTfmbLbhNn1PhNbVmPdDNIdtTa6tGGyUIHlQHTYQSijxYGuMeAbBom/eG9y+vRfsKkaJOin9DFc7SZhoovCRIrmqzaUyzqAycTC0jwwsv9N4jKBcc7RB8BsmPxu/1Z99tWP8hkrPoRBfnjbd3higctRh45SBi+IVOzhPa5QsTnehkse43jImbAubC1FLfEJnqeRC/rXK9tjruUNyGggJS0wqWEJ98BsqDjnG1cHDyXwwznWeFxASnFKkxyLXQXfXftjdWwfhWZpH7KIuz7bhPkTNyxNVM35xUumifB76eRlUsIlWhXrmIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MHJqqtSGrWoKg4K4K5y0vaBn51nOhYp5twnbWUOfjI=;
 b=D6Sn4oUml7EnaY+2vDhoPXihFwUBUanyow8PCCWB/n7LcgwrXsyzcQCzBdHJzPlWXfqen4hXOooV7EMV88AlnBwbhhSy+ye5kHU2FNOzdJzD/waG/3oAayxhgIOSigomp1irLitHVFjl8IpywgrnsV/QD8xh1slFUXJOagvPQEI=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS7PR12MB5984.namprd12.prod.outlook.com (2603:10b6:8:7f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 05:08:58 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 05:08:58 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "david@kernel.org" <david@kernel.org>, "ridong.chen@linux.dev"
	<ridong.chen@linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>
CC: "chenridong@xiaomi.com" <chenridong@xiaomi.com>, "apopple@nvidia.com"
	<apopple@nvidia.com>, "ziy@nvidia.com" <ziy@nvidia.com>, "gourry@gourry.net"
	<gourry@gourry.net>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>,
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"byungchul@sk.com" <byungchul@sk.com>, "willy@infradead.org"
	<willy@infradead.org>
Subject: Re: [PATCH] mm/migrate: move NR_FILE_THPS on cross-node migration
Thread-Topic: [PATCH] mm/migrate: move NR_FILE_THPS on cross-node migration
Thread-Index: AQHdZUap6b89HZSxXkmOXK0M45UPB7cQ1/sA
Date: Tue, 27 Oct 2026 05:08:57 +0000
Message-ID: <dda514602dd1673c0ed23c1c51764f3eff6a093d.camel@amd.com>
References: <20261025110209.4105994-1-ridong.chen@linux.dev>
In-Reply-To: <20261025110209.4105994-1-ridong.chen@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DS7PR12MB5984:EE_
x-ms-office365-filtering-correlation-id: f86444fe-2bf5-4353-d319-08df33e86803
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|22082099003|18002099003|261026121527099003|10067099003|56012099006|11063799006|261021121427099003|261009223027099003|261022075727099003|38070700021;
x-microsoft-antispam-message-info:
 /xqxAHyRFdi2Sv6WYuPX5cUAJlWOlrJiQoOYAyQfp/q74cvx0coNvIjhP07aoM9BF8ahWYm50Xy+y82c8KrdxCL2MMH/6ApgsxLyyliQwxx9UONlro6Yo1qGbOTVc/wX44r/6r2PqrYBp8Eqo216HxgT2ZYYbzkky9zOHhPQsERhFJJ4yCWgbu0Y9hu6H46XljKSLBFAeg/yDT7ARHm8Es0LeLN/KBve6/ZOP0i4r/VQocqzJEEzqf9xFhiDjQP3saJ3spcfmy9e8UE0a7PgMgH5TWZ7lL7xOYpY0o6ruLPoUWH+J+oRrRfjgoMhBinsJuuKA/RAvcMGtbURyOmmvrLcvUL5IWACVaM9EcfNAzWC+44QMKAlC3OkYFDpOedoJC1LR+b6TfG8j0cBDRY5FSAnOjL1t8+hINl15H97BsQ7hPddA19LOAujb8d9W8PMCuqpZRdAM5+5PrMXLx8nvxImsyuuoR41LqxcU084suyAB0+HWhv9yTayT8IGOS4lFMhEGlZMLd54K649gFNno5P/VAICN1w2pT2NrgMl/BYT4isgA/tUH/c7qEWRXxay4oRg6qumk3yycBM9Br/3OCiTzB4Xo1uXVEK4HS3uaA1UzsdY0OCaDFH3pPnA72k1mhklkJq9bV0BVdpREgSFvyx9VTlfgdjUYHy+zgeDiC/XLfieQJWlwuhUxVZ0Ugl9sFvCUKwMZkudDV1hjb9feZQzcpTE2WLQyCM6Adz5Jvw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(22082099003)(18002099003)(261026121527099003)(10067099003)(56012099006)(11063799006)(261021121427099003)(261009223027099003)(261022075727099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NmhMQkJseURORXNxbjRFbEtIZTFBNklRYWU0RXo0OUo1cEJVbDBheXU2TGJT?=
 =?utf-8?B?UmxHOTl4OXd1SmFZRXBBbEhyOGFLemM3VWQ1cmNrWFhnTTZTb0VnUnR6aVQ4?=
 =?utf-8?B?OGlSOXFtcGxXSTc0RE4vckVSajFPUHUxK1poYTVDeEdUbWxmakRKZyttQVMr?=
 =?utf-8?B?TE85NEdCUDNIODBFc2hUaGdFV0Q0Zm01dmNFVFlYckhGT3duOVF1SmplSXBK?=
 =?utf-8?B?bXBFUnZjbThETGFtUkxrN1RXdElhejl4UnBMM1dFSS9LTkZNY0xHL1dwWFJD?=
 =?utf-8?B?Ym9jMGRWQlhPVU94Q3llUGIwUFh4Y1RVYzF6VXZ0UGhLOHN0bndtNU5JSlJx?=
 =?utf-8?B?VGNZNmZwakN3MnV1RWZSaHUrUktlc05QQmdtVGVzc0RxVm53NkdtVjJrdzV4?=
 =?utf-8?B?WTVFRlpFU2x0RVp2cUU2TmhmZTcwVEVhOFdxOWVoSXlGQmpjek9lOWlDQ3BH?=
 =?utf-8?B?V0lWMlBhWTdhaXFqV3FrNThTdTBwcUc5elN5b0UwSlhkVDdEdFVFZk01c21x?=
 =?utf-8?B?UU1yalJnR2NuOEluTEczWG9VeTloTmJKdVlYb1RGcDQ1dlNRNldtNGFmL1Vn?=
 =?utf-8?B?QnBxcDBmRmdHL0Q1Qm9iY0lCZ0RVWCt1ODd1WUVsSlg1SUwvRXFvWEllM0VF?=
 =?utf-8?B?MThFc25aNmFGOXZRSXhrTEFPZE5KbmVUNWNSVjIyYjVEb1Fob2ZCbzlqd253?=
 =?utf-8?B?YklQV0FsMGJJMHJMbDJnMmx3YzBSOHZ0M2ZpcER4QVg2bThMcFRLdHdQclhh?=
 =?utf-8?B?TWFrOVBCWWR5NkFVZXBSd2RlWWNGbTM2NFlwbUhlR251RE8rdHFzcWZoYXFq?=
 =?utf-8?B?RnhTckhGbCtGdW9UQ2dQK0VCZ0J5S05melhhNnhveDlNZ0RXY281OCt4WXVV?=
 =?utf-8?B?SjZCN1hBR3FpUFYrRGZhOXY4eDhzTWdTKzZ1S21PWllGN3VWR01sVGtEbHl0?=
 =?utf-8?B?L3lFdXR4WFdaUkRKT2VmS1ZCaThtYlU5RkVYZHNZVTFlQXRPSXF1NUdiWnlt?=
 =?utf-8?B?OVB6eGREWkFKZzdhK3lzMjF0Z3Vid3BDd1NueFpIRWp4UTJIZEVlOGZ0MlJ4?=
 =?utf-8?B?dk80U21rL21QU0tWSnAvKzFFYTk2cFJESURkTHQwbVB4dVo2Q0lBZStWZm9Y?=
 =?utf-8?B?aUY1dFBndEM0Nm94bzVBR3NRSDMvZWZBWEFTQnN1Z1NxMmlrK3ZmdkVVMDFK?=
 =?utf-8?B?QlB5YytUdkg0WjRKclYrbnpVcHNDV0tSM0hpdDJNeVdGR1c2ZUplRWdKMHZ3?=
 =?utf-8?B?WWV0UWNBQjU4ajdyWWxOUVc0aFBXVDhTcXEvV280cVdJZGl2VzFEK0MrN2JE?=
 =?utf-8?B?dk1CK1Q2WGtmVUdLK2ZlODF6d0dvd2JkTVZiMldXcFhTeU5zM295dE9XQ0NE?=
 =?utf-8?B?QnZ6T04yRjBTa2oyc3hUemFaRFJFZmlKSTc0S3h3MVFDL3pHNTM1ZTN0dHUx?=
 =?utf-8?B?UXJ5RkhWcFRpcUZESy9wOGlSZzhCcm1EZHZsdGhwcDFiNUpad2k1QU9qaVpI?=
 =?utf-8?B?TEV4OXloUlo3Nzc0VWxvMk5RbnVXWGRYY3FuV0ZtSXpDaUViMTVUcGlXMTFM?=
 =?utf-8?B?QVVGK0pWeEwreTh2R2lZZmc0RWNXYXZ5T3dQNU0xeXF0RWdRT2ZTOE92ZlZV?=
 =?utf-8?B?dnFnbllKVTQvblhmU2tZNUpxc3FqYm83aHpXUnpHd0o3d2dyTlV0T016Y2hN?=
 =?utf-8?B?Wk92WGRxQll6aUtTVzdTZUZNYm5VdTFWRi9ld3hIbUNlV3Y1a1RCNlFLbWlv?=
 =?utf-8?B?RDF5RnJGem9pNFhkdVBDWmxXYVNKZEIwR0RLYmlqdE5QQmZVdGs0ZmhnWjAv?=
 =?utf-8?B?bjRBTTI3NjhSZXM5bU1jNVQ5cmEwWG5rTnRLYkllRnQvTGhEUHcweC9iNGtM?=
 =?utf-8?B?b0ZjTjF1SktGcThLNEZYeFovWGo5UVJMMk5ObTUyYVRzYWt3ZzJFemF0K1gz?=
 =?utf-8?B?VkFFM2RjMDl1WEtqWlhVUlJzaVZuNGlydUg0SGhKN3haTXRCOG9JUnRIVFJB?=
 =?utf-8?B?RkhLRitoQ2VSZkZ1TFkzeHRGVXdNWVYyS3hDVlhWSHpZanIwSWZoNm5BS3V0?=
 =?utf-8?B?MHFiYnluM2lqdktBUEhXeUFhSGI3WFBWWGhkT2ZMdlBsN1NZbzczQW44cTdV?=
 =?utf-8?B?YUZlQjVaK3V5S2FxSzhSR1pqVzk0UGhzTE5rRUx5dWpySUdVMFFsS2JWbFdj?=
 =?utf-8?B?eVRMK2dHcXZjQWE5cnRjU3JsZnZodEw0dFkvb1J0WG9iZlcwTkhBZmFuV0RC?=
 =?utf-8?B?M2NDYkNnNHkwZ2hDZU91WlBYZjBsWVMzMVZjamFGN0NEZ0VEc1FlNDRCd0lM?=
 =?utf-8?B?Wkg5REJVL2VLemhRNElQclJYeDVKV3oxcENzOUFocXl0RkpLbFpadz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D325C495F46F304AA1541D17894C79BE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f86444fe-2bf5-4353-d319-08df33e86803
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2026 05:08:57.9462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 24JWDEX8Poh77odkuKWMID5c7iKktEJcDo9yfjmzUsRLNP8IjXdQxoWtXZCPgbxbqNYisSf4sf2f0eREIGcEvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5984
X-Stat-Signature: g7tuxt51gehihcduxw4aqco6zep8heb4
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6A12EC0002
X-Rspam-User: 
X-HE-Tag: 1793077743-13083
X-HE-Meta: U2FsdGVkX18QjeTcg9vjcw1Jlj/PxKyZP+tlcomu6BonrosH5vgU5XciLecYX/+rTvaxzfthcL1ihtctRHzdQFG8LMHySJQNt0GPYJDIw2vbl+OC7Iq/yJHOi7Y76pGupVkhiKuoqN21Sc2eDdLTGOetEv7HZjXmS71ZL/QCm3DrMNSU0Lpf3bKBBjVzXWxzkyyoKRxiVY8XAy19NDRiNG7/yBY7lv4j02fkBCioUgyeEX4IjKAe0xAoWSOO8wuIgpE7aol/SVcU1KBxO9hoqA/M/t/1z5CiTXBQhc97o7jksYL3pLoEgggDSslCZzNfsZEbIV27/V/kWQIZfjeuG8yIKQwL9pe7rn2wWm0jDGRmG5vFzLUhnCDX7LICKNnvar8S9ob8U5fcjBwaLsNrxTTwzxiYCvXvCEgQpscxaOvFLBfihjbnvawHP1llI0bU5SntDkABwvpAAmeXdAReqzWlkLGi+hz4TP3SnBLqAtZc/VxIU+Z+pIC7Mu5jVJQdVAVQwzriT8mYl+gxeGv2wpTvq9ag3CmDvxu6eYZ6BEv4r5OFzz2e46Ag5tavOUBtZDWGIcSStxUMM1gZh6U9UhCJXggpJqet0smXvdkzVeDvSDwx4xYRLISnmNgDuP9D+RmYxdQOytcgtrk+NpVPRHO45UN1JG+uPDSVBOv++GYbtXG0KB1pwCA/SehlSWvInABd3KcMW6GHDdOpW76dVEbCUk7MP5jYcXnNJMVaRHQ+29QmvXxuqZI7jXuEGE5JQYwb0Xp/6BcNjEkbg3hG9k37vTB19KhHxyTTTU0sGj9l5ePmaPNmAXEgOU4i0t9ihQtlecG28RggYjjW/FnKXeJaMqFAYDeo72V92n79l6iu1a9A8fp2r2mcI9EqZsd7fwwCjPTRxitCY+bc8pibHu9q0ah1iQKkLX92jaXGF1+mHY+1G9oZWLO3V03kVSZYhmgcqY7vTW1m7R/ejFg
 BIOzo3HR
 JP2a8EVVVC+zTKCIwHMUpZ44/PZ62JdvBow275HGSqAZc2wkljGPquoXqPx9ulU0AGIke2ieJxBISkX07rIGllC0bN6azGurTejk3nXyZFOyENHbHJbZGMqNJrWkD2IMZgdz4ekJ6eLs0Btk/TCiweih2hJ6dbXpp+4jXGuiJ/W4jfXYnmeXlGW66oA1W/KM0QBG+i6P38eu8PmiZj8gu6BifIo6w+0tIDMw8NK+LzC407mprCfqgEzLs7Yl1cSpjXLYlkJMgFOiY5mr12H3J2EGNmGQyVHgJl+qBtjUSrU7mexUL1SLRC+Rl9vqaQ3vOWW7QbClA18jVR+Yl2YJjK0SOB4nskfbAZVIcvFTlm0v4kTOKJM5OBnsbCqBXdV1SKggV2osKTsvoWkJLB1KTsYcxUqrhaeiiMSVXToUEGKXoZniXv5D4qAk0jWlIFZI6PdHLAOrmS0PfxrNr+7jSu/1ZvNwWhZ6tN6Q37ET5sVwkWwS6FcCn+IB+wpprboXoaNcwuthvKW/iRKMRE1iJ7mYS16D7ZRBaw0iT8XOIQ+ia4qHoOzOcGXGJyU3DRv4ltRdLpEXPiQzv4QTS3yXaDp7ANH2SuhQ0TfVSiQVFK9APZ7ukEXZ1hb1P7oWKIa0uQa0Yf6RB79S3/pA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gU3VuLCAyMDI2LTEwLTI1IGF0IDE5OjAyICswODAwLCBSaWRvbmcgQ2hlbiB3cm90ZToNCj4g
RnJvbTogUmlkb25nIENoZW4gPGNoZW5yaWRvbmdAeGlhb21pLmNvbT4NCj4gDQo+IFdoZW4gYSBw
YWdlIGNhY2hlIGZvbGlvIGlzIG1pZ3JhdGVkIHRvIGFub3RoZXIgbm9kZSwNCj4gX19mb2xpb19t
aWdyYXRlX21hcHBpbmcoKSBtb3ZlcyB0aGUgcGVyLW5vZGUgYW5kIHBlci1tZW1jZyBjb3VudGVy
cw0KPiB0aGF0IGFyZSBrZXllZCBvZmYgdGhlIGZvbGlvJ3Mgbm9kZTogTlJfRklMRV9QQUdFUywg
TlJfU0hNRU0sDQo+IE5SX1NITUVNX1RIUFMsIE5SX1NXQVBDQUNIRSBhbmQgTlJfRklMRV9ESVJU
WS4gIE5SX0ZJTEVfVEhQUyBpcyBub3QNCj4gbW92ZWQsIGFsdGhvdWdoIF9fZmlsZW1hcF9hZGRf
Zm9saW8oKSBjaGFyZ2VzIGl0IHRvIHRoZSBzb3VyY2Ugbm9kZSBhbmQNCj4gZmlsZW1hcF91bmFj
Y291bnRfZm9saW8oKSB0YWtlcyBpdCBvZmYgd2hhdGV2ZXIgbm9kZSB0aGUgZm9saW8gbGl2ZXMg
b24NCj4gd2hlbiBpdCBpcyByZW1vdmVkLg0KPiANCj4gQ29tbWl0IDBiNTJjNDIwMzUwZSAoIm1t
OiBmaXggc2htZW0gVEhQIGNvdW50ZXJzIG9uIG1pZ3JhdGlvbiIpIGFkZGVkDQo+IHRoZSBOUl9T
SE1FTV9USFBTIGNhc2UgYnV0IG5vdCBpdHMgZmlsZS1iYWNrZWQgY291bnRlcnBhcnQuICBOb3cg
dGhhdA0KPiBleHQ0LCB4ZnMsIGJ0cmZzIGFuZCBlcm9mcyBjYW4gYWxsIGhhdmUgUE1ELXNpemVk
IHBhZ2UgY2FjaGUgZm9saW9zLA0KPiBtaWdyYXRpbmcgdGhlbSB2aWEgTlVNQSBiYWxhbmNpbmcs
IG1iaW5kKCksIG1pZ3JhdGVwYWdlcywgZGVtb3Rpb24gb3INCj4gbWVtb3J5IG9mZmxpbmluZyBs
ZWFrcyBGaWxlSHVnZVBhZ2VzIG9uIHRoZSBzb3VyY2Ugbm9kZSBhbmQgdW5kZXJmbG93cw0KPiBp
dCBvbiB0aGUgZGVzdGluYXRpb24sIGluIGJvdGggL3N5cy9kZXZpY2VzL3N5c3RlbS9ub2RlL25v
ZGVOL21lbWluZm8NCj4gYW5kIG1lbW9yeS5udW1hX3N0YXQuICBUaGUgZ2xvYmFsIHZhbHVlIGlz
IHVuYWZmZWN0ZWQsIHdoaWNoIGlzIHdoeSB0aGlzDQo+IHdlbnQgdW5ub3RpY2VkLg0KPiANCj4g
UmVwcm9kdWNlciwgb24gYSAyLW5vZGUgUUVNVSBndWVzdCB3aXRoIFRIUCBzZXQgdG8gImFsd2F5
cyI6DQo+IA0KPiAgIDEuIHJlYWQgYSAyNTZNIGV4dDQgZmlsZSB0aHJvdWdoIGEgTUFEVl9IVUdF
UEFHRSBtYXBwaW5nIHdoaWxlIGJvdW5kDQo+ICAgICAgdG8gbm9kZSAwLCBzbyBpdHMgcGFnZSBj
YWNoZSBpcyAxMjggUE1ELXNpemVkIGZvbGlvcyBvbiBub2RlIDA7DQo+ICAgMi4gbW92ZSB0aGUg
bWFwcGluZyB0byBub2RlIDEgd2l0aCBtYmluZChNUE9MX01GX01PVkUpOw0KPiAgIDMuIHVubWFw
IHRoZSBmaWxlIGFuZCBkcm9wIGl0cyBwYWdlIGNhY2hlLg0KPiANCj4gbnJfZmlsZV9odWdlcGFn
ZXMgaW4gL3N5cy9kZXZpY2VzL3N5c3RlbS9ub2RlL25vZGVOL3Ztc3RhdCBhZnRlciBlYWNoDQo+
IHN0ZXAgKGluIHVuaXRzIG9mIFBNRC1zaXplZCBmb2xpb3MpOg0KPiANCj4gICAgICAgICAgICAg
ICAgICAgICB3aXRob3V0IHRoaXMgcGF0Y2ggICAgIHdpdGggdGhpcyBwYXRjaA0KPiAgICAgICAg
ICAgICAgICAgICAgICBub2RlMCAgICAgbm9kZTEgICAgICAgbm9kZTAgICAgIG5vZGUxDQo+ICAg
MS4gY2FjaGVkICAgICAgICAgICAxMjggICAgICAgICAwICAgICAgICAgMTI4ICAgICAgICAgMA0K
PiAgIDIuIG1pZ3JhdGVkICAgICAgICAgMTI4ICAgICAgICAgMCAgICAgICAgICAgMCAgICAgICAx
MjgNCj4gICAzLiBkcm9wcGVkICAgICAgICAgIDEyOCAgICAgICAgIDAgKCopICAgICAgIDAgICAg
ICAgICAwDQo+IA0KPiAgICgqKSB0aGUgY291bnRlciBoYXMgdW5kZXJmbG93ZWQgdG8gLTEyODsg
bmVnYXRpdmUgdmFsdWVzIHJlYWQgYXMgMC4NCj4gDQo+IFdpdGhvdXQgdGhlIHBhdGNoIHRoZSAx
MjggZm9saW9zIHN0YXkgYWNjb3VudGVkIHRvIG5vZGUgMCBmb3JldmVyLCBhbmQNCj4gZXZlcnkg
ZnVydGhlciByb3VuZCBhZGRzIGFub3RoZXIgMTI4LiAgVGhlIHNhbWUgaGFwcGVucyB0byB0aGUg
cGVyLW1lbWNnDQo+IHBlci1ub2RlIGNvdW50ZXI6IGFmdGVyIHN0ZXAgMywgbWVtb3J5LnN0YXQg
b2YgdGhlIGNncm91cCBzaG93cw0KPiAiZmlsZV90aHAgMCIsIHdoaWxlIG1lbW9yeS5udW1hX3N0
YXQgc3RpbGwgc2hvd3MNCj4gImZpbGVfdGhwIE4wPTI2ODQzNTQ1NiBOMT0wIi4gIFdpdGggdGhl
IHBhdGNoIGJvdGggYXJlIDAuDQo+IA0KPiBNb3ZlIE5SX0ZJTEVfVEhQUyB0b2dldGhlciB3aXRo
IE5SX0ZJTEVfUEFHRVMsIHVzaW5nIHRoZSBzYW1lIGNvbmRpdGlvbg0KPiBmaWxlbWFwX3VuYWNj
b3VudF9mb2xpbygpIHVzZXMgdG8gdGFrZSBpdCBvZmYsIHNvIHRoYXQgVEhQcyBpbiB0aGUgc3dh
cA0KPiBjYWNoZSBhcmUgbGVmdCBhbG9uZS4NCj4gDQo+IEZpeGVzOiBkNjhlY2NhZDM3MDYgKCJt
bS9maWxlbWFwOiBBbGxvdyBsYXJnZSBmb2xpb3MgdG8gYmUgYWRkZWQgdG8gdGhlIHBhZ2UgY2Fj
aGUiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBSaWRvbmcgQ2hlbiA8Y2hlbnJpZG9uZ0B4aWFvbWkuY29t
Pg0KPiAtLS0NCj4gTm90ZTogcHJlcGFyZWQgd2l0aCBoZWxwIGZyb20gYW4gTExNLWJhc2VkIGFz
c2lzdGFudCAoS2lybywgY2xhdWRlLW9wdXMtNS41KS4NCj4gDQo+ICBtbS9taWdyYXRlLmMgfCA0
ICsrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1n
aXQgYS9tbS9taWdyYXRlLmMgYi9tbS9taWdyYXRlLmMNCj4gaW5kZXggN2JkY2RiNTc2NTJmLi5k
NTVmNTc2YTI1NzkgMTAwNjQ0DQo+IC0tLSBhL21tL21pZ3JhdGUuYw0KPiArKysgYi9tbS9taWdy
YXRlLmMNCj4gQEAgLTcwMCw2ICs3MDAsMTAgQEAgc3RhdGljIGludCBfX2ZvbGlvX21pZ3JhdGVf
bWFwcGluZyhzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywNCj4gIAkJCQltb2RfbHJ1dmVj
X3N0YXRlKG9sZF9scnV2ZWMsIE5SX1NITUVNX1RIUFMsIC1ucik7DQo+ICAJCQkJbW9kX2xydXZl
Y19zdGF0ZShuZXdfbHJ1dmVjLCBOUl9TSE1FTV9USFBTLCBucik7DQo+ICAJCQl9DQo+ICsJCX0g
ZWxzZSBpZiAoIWZvbGlvX3Rlc3Rfc3dhcGJhY2tlZChmb2xpbykgJiYNCj4gKwkJCSAgIGZvbGlv
X3Rlc3RfcG1kX21hcHBhYmxlKGZvbGlvKSkgew0KPiArCQkJbW9kX2xydXZlY19zdGF0ZShvbGRf
bHJ1dmVjLCBOUl9GSUxFX1RIUFMsIC1ucik7DQo+ICsJCQltb2RfbHJ1dmVjX3N0YXRlKG5ld19s
cnV2ZWMsIE5SX0ZJTEVfVEhQUywgbnIpOw0KPiAgCQl9DQo+ICAjaWZkZWYgQ09ORklHX1NXQVAN
Cj4gIAkJaWYgKGZvbGlvX3Rlc3Rfc3dhcGNhY2hlKGZvbGlvKSkgew0KPiANCj4gYmFzZS1jb21t
aXQ6IGJkMWVjYmI2MWFmZWZjNmE4Yjg3NmNjYmMzMWU5MjI4YjQ0ZTllYWINCg0KTG9va3MgZ29v
ZCENCg0KUmV2aWV3ZWQtYnk6IFNoaXZhbmsgR2FyZyA8c2hpdmFua2dAYW1kLmNvbT4NCg0KVGhh
bmtzLA0KU2hpdmFuaw0K

