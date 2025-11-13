Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64682CCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 05:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3CF68E0009; Thu, 13 Nov 2025 00:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AECB08E0003; Thu, 13 Nov 2025 00:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D9A8E0009; Thu, 13 Nov 2025 00:03:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 847D18E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:03:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37F72BB5E0
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:03:54 +0000 (UTC)
X-FDA: 84104391588.26.15B1118
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011061.outbound.protection.outlook.com [52.101.62.61])
	by imf19.hostedemail.com (Postfix) with ESMTP id 67A9D1A000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:03:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Zo9zThkm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.62.61 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763010231; a=rsa-sha256;
	cv=pass;
	b=BQyNgSrG5HYQiB2aXrAAVfJ1iHDdCHOFJmXwuOIe26xtWDNNYbIOnL3zXxa96YKBwRwAT5
	YFEil8lOIC3/xKLkfsl7XnSOddbC9oFa/T6JrhEmBJyPZ/qQUEMAlk3//DTU0nv+nmEYwe
	FPmiLng6kkvUcfPIuBphqgJC//XNtio=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Zo9zThkm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.62.61 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763010231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8LIlGiXhZlNm9uxyOkg60WnVC4cmK1O0QkVIZG+2Ro=;
	b=5SghOn7iOEkxJ0cU/P0n3xxpDw+NU1O/oITRUoRDHyjhqPnRSH2JZaWD2TipZ02wvjDn/V
	MxGjCDSHpnyiEQh47DNkEK1pg2h6cyjtQq41a7hsOGEGYkzs3mJHycsCR5ESiabjBloCYa
	Nk75XWCsBA/a55qNdU8B/olRz+/jnYw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G2k+OXgIY/t8dubfFjGuaqUfDrdg0Yn2SwFNUMt9CggzOL+3rJvPqdISxDILq/sCPEs/hJvAw0jMwzGMWNQ7QkKUedUyaqHCk681d4fsT3ax7maU1M4+cQmwlx1BdCV8Ax3EvU1LSanfEqRr3+VuGc1wNXzhiP+j9UqKeUfriiNd5IblS04V3D1PAkL/1i/ZIIQu5mWVvYuV+ylqJ88WOOIiU6g2Ns6CiEbPGfBXufbwRL9xWy7bDS8/ZZbV/fehCzjINd03ynn2QjqmY7G0taYnfXV1lDxVjvm1Ql1tT4iNSRLTP648fh0c4WJ6B4n7szXWwG70dtTZTfw2dS0XDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8LIlGiXhZlNm9uxyOkg60WnVC4cmK1O0QkVIZG+2Ro=;
 b=lhUfi4Rf9/KjVJz/5R+MkmaF4/a156bmL9KAIg/5dJ+uG7TphvGtQSDxGOwmxm8fw7UFV/G4uBlrbIe6mK4VFUQhTSYgVdkyBmRygZTdQ1m110TUtUHRS0yC5GVJfIiGWbdYytQE0p7vD2P2chCqFEIu65ODZQRiBxLAbV+0gK1R41MSUoM0+7HkMnH1t0sIQI9TgMXQUToGQ0fHXtFcWhGui2U9dqORXyDSyeV5dOKiSOjM14NqAAor5BgJleHAt8F+QMDN9P0ETKJZXZh7Z/ZNtRdyra2+iDAWtqbsll7s55Du/U+lWptj7xgOflSxenuWvHmOTH67laB5D3axRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8LIlGiXhZlNm9uxyOkg60WnVC4cmK1O0QkVIZG+2Ro=;
 b=Zo9zThkmTkm1wLJlCQvsor530XbxnIu5SbHb2B+GoePBrH/uTU/ZO3kn8BB72ZbLw/RWcz0MvB7U9edWOntC6ynB7Ec8L5TtVSYd7UVrpLDZ7skrrAewo4qafRhak0mKOSuqNf4WF+QsrXjZdpdqBROW0gflhy2NjDbPaaTjh9PcSPka92z9f0Mw27sKyJ8hoxqUt19Oh8RXG29qNox+kiUjTpqZgK3WOTcFO7P90OjLnqrOHvTJ4TDu16IBNOi+VCQigmUKQr0eI79TowZGwv6aXDpyLo8mrxrr8F1qMKdtiyREyhJdtFg13Zn7rZI08aEmI8I19O8rn3bPxGM3+A==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by IA1PR12MB8407.namprd12.prod.outlook.com (2603:10b6:208:3d9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 05:03:48 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 05:03:48 +0000
Message-ID: <a9c8fd41-66c6-4cb4-a033-4138be701b3f@nvidia.com>
Date: Thu, 13 Nov 2025 16:03:43 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: softleaf device private fixes in
 remove_migration_pmd()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <20251112044634.963360-2-balbirs@nvidia.com>
 <4e6286a6-721d-45cd-a4ea-e79e90e14fc7@kernel.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <4e6286a6-721d-45cd-a4ea-e79e90e14fc7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:254::35) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|IA1PR12MB8407:EE_
X-MS-Office365-Filtering-Correlation-Id: b18df49c-2bd0-4a19-7311-08de22720785
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUMvSEtSd0ZkSTlTUzZaK2pPb21XN2d3TUw0enIranBzV2JpS1pKbGtrVFBS?=
 =?utf-8?B?RVE2enlEYzdBUDdzeHRySk9UOWtZaWlHNmQ2RXUvdlpuaUFTc2VVZXpHN1gw?=
 =?utf-8?B?dVhwVitPVDJLY2s4WGRTZHJlbHErVXczbFFraFVUazlNQWhabXl1Ly9JbnA3?=
 =?utf-8?B?WDRyUWhiUDRMUDNKdkRKVjQ4Mi9uZndWV24zWncxbzhkUGFMdk9HbXNhMzBF?=
 =?utf-8?B?VGNKWWdwNTRQRWEydnE0WVl3NGVEV3o0cDhOVGUvQllKWlpGcWxMK1l3SkdR?=
 =?utf-8?B?azlRNm0xNkgwK2J2MCtoTk5LZFhrUVJoMXpOODBQdndRN25VUE14aVFLcWti?=
 =?utf-8?B?RUM0R0Q3MzMvSDRveXhlbC9xN0Z2Q1VKb0pxTEJDTlJlV3pxWnZqM0VFVjhs?=
 =?utf-8?B?YWluUGRSNmhCMlI3M1lqYVVLZ3QrNDl0ODUrNk1jbWd3QWh2dnpiNjMvbWtE?=
 =?utf-8?B?S0JjQkYxZlRMMThwMkhOZGptVWZ3ZS9oN1pQTlZBYTN5UlFvS3diSERJK3JY?=
 =?utf-8?B?N1BLb3Qwb3ZhcU1hbHRQNzQwVTV6MDZFeEp1MGJsd2hLVkMxS3JMa01IaGkx?=
 =?utf-8?B?T1hBNUFzM05vTVVESGIwdlU4NFBxYUozclhyMUlZclQ1U2lkY0k2L05XczZH?=
 =?utf-8?B?K1lHd1QydkZEVDBvNHFpZTh2ZWVzbFFLeVJmMkdQczVGS0pjbHlsSldpV3NX?=
 =?utf-8?B?S1BzV1JZTmRYeGtFTkh6Q1RlQmpWZjE1dytMUCtIalJBMWNPMG1wLzZvRW0v?=
 =?utf-8?B?YWFKbXhoS1hCYVNEbWc4UGxEQmI4Tm9SZGQ2ZElXNmFuVlI3QzlKbCsyWXY3?=
 =?utf-8?B?Umw4MXBYQXJoVmtsZzBFN25jUG0zbzltUW0wVFpRVE0vVW5mQ3JiTFJBVmZw?=
 =?utf-8?B?N0pSbEY1M05HOVVnTTI1WkFoTENCWkJRdHhsM092dk85Rks5TG9pZmV4V0Yx?=
 =?utf-8?B?dDVYVzB4WExQZm91N3loQUF2UytZcjJtQ0VsZDdDMEEyK0FuYjk3NnpZZFpE?=
 =?utf-8?B?aE1UUmNnMUtDNXp1RUZuZFRBbHBrZ0RnSHRRcXUyWWJXVGluRVJZVHc4YVJs?=
 =?utf-8?B?Vis3dDl5SURsZm9OVWVTN3dKRjk3em8yVW1iZnJlaG15NE5pKzZuWHB6K3VY?=
 =?utf-8?B?Uk0wd3p1YnlHOFJEcGVhR1ltQVJORkhrc29xTEM4MFVuL05RWS82NW52SmNo?=
 =?utf-8?B?S3lHZEU0L2p4Vmp2VkJHMitpeWkyUjlpWEY5T1Z4UUhQTkdFMjJ0V2puR0dp?=
 =?utf-8?B?NW8rWmNlSU9ZQzZ0Z0dkb3RaNEt5d1lucWpBWjFNYnU2eUpVam9FTlkwOERC?=
 =?utf-8?B?bGRCa1Z2dUlrTmlpeGhUcXVpQTNRaDJSWXcwMmc1WW94Y21rd2Y3L3pTdG9X?=
 =?utf-8?B?SWlacm9WdFdpWXpiZFpYREF3QnRsb2VyUHY1OGlpdnArZno2TjM3U1RnbVZO?=
 =?utf-8?B?UXl6SS91dDhCMnV4R3VnOE5LSGF5czhqSWFWc0RYWVRZTnJhbEJNS242a0pJ?=
 =?utf-8?B?YkNRaVJoUVZxbjVnOE9CRDl4ZGJxenhFTkVlOUFqUHMwRll5Y1JOTTVpUmJ2?=
 =?utf-8?B?L1oyRFpNZnoveEMrSU1xR0h5NzZvVCtuYlJ4eU9sSUdzVFRQTWoxeGMvb3lh?=
 =?utf-8?B?UnVGWk5TaWhpUVVXcDI4QXdtR1NQK3V1Zzl0QVc4ditXRTFYMnNNS2hPVjBr?=
 =?utf-8?B?K0YyYlEwK3puelFlbmFVOUhvMXkwdUpZdkNXT2FyTnVPMzVUZ0c2bzNJRjQy?=
 =?utf-8?B?NVNTMm5kRHhFb3IxOHdwQjVQOEZYa2Q2MHpyTUt4OVNKVjhyQ1h6b2c1akZD?=
 =?utf-8?B?STJJMGVRRkhRamR2cFlSemNLYzVvRlQvTFl0N1Zaa1hGTHl2Q2w0bzA2R1li?=
 =?utf-8?B?VDlmcHh6d2RtUk9aSmgvaUE5aG43YUxsR2VidTFMa0RxYmllWWlIRXIvOG9p?=
 =?utf-8?Q?Ab4baYY125qPGT3+/ZWCnaIkgEWb/7ga?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V1gwVmRBVDNwQ0xIV1h0ZUI3NGw0OTk1OENYWExib2ZySityY0NYbDkvcTNK?=
 =?utf-8?B?T1dmcmVGdlRkdlozY0lvN0h2Ym5OV0hRYlJmK2R5U2xxVXpjTE1VWVJWVFNM?=
 =?utf-8?B?eHY4cWlIMG5pbStNNis4czF0MHRESXowMmVJeEowMWFTYjkwcTNaakVwTG1N?=
 =?utf-8?B?azFkNjNiQnhEVHZDZ2dOSEhLMURGaEEvMnp4b0VDRnlqbFkvQ0QyVitDSHpy?=
 =?utf-8?B?eWxlZDhMRnVObjNEK3cvNmVrNHZZSkRDRzgzNFlVREhCUXhPL0VrMTZSdmow?=
 =?utf-8?B?VGd0T0daaDlnM1IycXk3NGpUb2ZrU2ZndmtjZElBUnlpQUxNUG1sK0hmY2NW?=
 =?utf-8?B?Um5GUUtrZ1RFKzZROXUvTC83ZjV6SExnYkIwbjZjZVg5bUVoYmNkVzlLemZP?=
 =?utf-8?B?T3gralc2dnBqM05Odk52b2FqUmgxa1ZKWHpjRFFyUGl1Y0orK3EwUVRqYXhG?=
 =?utf-8?B?WDRuWUVXSThkQUpJUVBJRkpWMnByWk5XWmdyRHFEZTkydzdkRGNFNkpGR0dl?=
 =?utf-8?B?ZDhkSDk3bS9ORzl1cTVIN1JLcWJhOEUxSUNKdm45cDRzakhSSnhhQjN0MUN6?=
 =?utf-8?B?RmpjWXpCUVN6TmRFalBnWVNXYjFoVmZOU0dzUndobm83NDc4Um8zM2tjQ3d2?=
 =?utf-8?B?eDVyUWZZM0syY1hGYTZVeG9kaXN1YklMV296bFViK1RQcW8zWnpUU09BVnpo?=
 =?utf-8?B?NVBJQUh4bVlmUWhNNEdRYWJ3Y1Z5MkVsN01KUDBsb3hLM25zMzYrSWIyQytI?=
 =?utf-8?B?QXpaRXN6OUZybUZzVFZJVVFNeXZCVlBpRFVVTjRmdWVHQlhkQmNzMlNoaUEx?=
 =?utf-8?B?WTRteW5HNVprcHVZTFVmNy81cTZpZzJJc0dVZmNCV1g3UHhhUnpDYm12TmdK?=
 =?utf-8?B?aGpHOUs3RjRWRHRhWm1zOGNteVVVd0RsOFpoVitmUVBuOEN2Z2NFOTY4Yjlt?=
 =?utf-8?B?NktPQ2JMdVk3amsrWFZnVU1mV1hmWENzbkh4VU9XRWJFS3JlenlsWENoYk85?=
 =?utf-8?B?dExXQVVLa0c4OUpaWnFRZElWZnozUjZiS2h2bkZDemVKZTNWRnU4blRuYzE1?=
 =?utf-8?B?aFlTVXgzUGlSZWdpK0hvRGV2b0krSVIzY3ZDRWRyMzVLaC9RNUFwVEI1dlFh?=
 =?utf-8?B?MmZITHN3M01UN1c4eEQyMmRvUnhWenY2eElpcEJKcWhpbDNmOXE2a2VBSGw1?=
 =?utf-8?B?akVjNEErTTIrOXBDdGNGNGhUYWJKd0hscW5qaFRQemdkQ291SHN3bk55c3Fs?=
 =?utf-8?B?dlRUYmlFODF3N1RPcUpqZ3MwU1lIWmw3MHYzZndQRDlVUW02OHRVZkxPOGV1?=
 =?utf-8?B?eHdZRExBREttUEtNSzRaNXBpZFFkaVpzOHhCYzg0REUvOUx3dDhGOHNmWGhp?=
 =?utf-8?B?UHEwc0hTNkRENktNamNCMjdPSGtER3luOVM5WWpuWCthTGJFd2d2cVo4Mm1n?=
 =?utf-8?B?YVp0ZXo3dWxlVW9CdjJnTDhJZXJxZ0FXYTlyRmNkOVN3WGgwTHZwSUJPRW9C?=
 =?utf-8?B?T2Zob3hZZVIzQVVJNmEvSXU0dy8vd2xEckFrcWNyOTNWS1dNMDgzM2RvcDNG?=
 =?utf-8?B?Z0dOaC9zT2cwUzFjK0lyTHJaZU4rQjhLRFZrR0VncTBuTzJlblpzeDNJeUtF?=
 =?utf-8?B?WXpLOEV3cnk1RmFBR0N4TlJqb1RBZ290V1FHSnNUUkVPMWtON1llcnp4LzNq?=
 =?utf-8?B?b3BEeXY5YmNGVnZ3MXIvSGo2REdFbUpET3cwcmxacFRKbW4wMGZnU2lHVXpC?=
 =?utf-8?B?TGE5QUxmVElYaG5ocVVCUWpEdTEveVlzckgxa2NLRDNXam16TkhkcjQzSGJx?=
 =?utf-8?B?UGJ2ZlAzN04zc0Y0ZW1ScWtxRFluVXhoazV0dllVcGt2Z3k0MWhpYUludXlC?=
 =?utf-8?B?WjVVZFk1V29zdGpyVWt3UnZOd2lLelNvTWFYdlNPd0NFSjc3d0RaRThXaGsr?=
 =?utf-8?B?VlduS2kvUzB3a2M5RUNZOW5iTlNiYjNZdFlpZEllUmo0S2tPUVdSTmRNQmgv?=
 =?utf-8?B?bGp0bEZRbUdvdWs3dm1iZC9JNEpSM0U3QVBvZUVGNlE4eTBYYi8wTUVWa2xY?=
 =?utf-8?B?NWJQOWVxUlp2dEhoTGJ2T2s1bnBoeHhyWmJ3NW5MWU8vbGRQQ0E4cUFnVmYw?=
 =?utf-8?B?ditjaUhYaFd2NGtqOXhMV0NIN2FrU1Q0THdNNGpRSzFXOG1yemRPTG1KNmIw?=
 =?utf-8?Q?uU+0ZAUesnp3npLhbSxz1ea0hNZIC1mGnvUxoSEtXC2u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18df49c-2bd0-4a19-7311-08de22720785
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 05:03:48.3124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCGIWoME3yKqRvyx/SIeJpglc2WKGBs7MkQEZ4EXiSQ+TOvUJIzZxE30K8QhjcndovN1nEMcXe6C/63MU7YSmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8407
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 67A9D1A000B
X-Stat-Signature: 1dt4xg7ahkgw9rm4jbhx4i8kyqxx4uqc
X-Rspam-User: 
X-HE-Tag: 1763010231-873138
X-HE-Meta: U2FsdGVkX18EMQd244ZH2q/CBrcpSajYJY2txcg5hnNtYjdoPhMvJNFh/EM31ZNp8PJuEzBQBGPU5wNylBNcUQvP1Uao2rOQogEt+/CImD9RDcBLVG6jz8PRFvbZH0jx794W/sUDOAcEJXVQ80/teQETX9jBetpAopMI2bxlLauhHAiPHIZ1uRsIz/nKIkUeIXXup1UMmw64spBHE2qMy2vB2A/BXPEIcXSky+5wVodYkz1Me2qHo6ADm0oKN5dBvcqdEXZwjuhI8OpXy6Y29xz4xsuTfLHd/DeOYH5VwvKIQYO563IVTNjFlxp+M5ozzHRgl0/W1/HsTEv2pphDaqhyyVR3PbQ2FgtaY5q4rDRwgyisiu26PmF1v7s1/KdUkBL5MzwYyS08Jb4PjNDSWLFeePkoHJLWQB/6HcO8TuEpuIHUEQJmcbOAXLepZGHF3GKRl9yCG6U41rFbjhjA96OGV9lu1JwcpR8buBqiOitc3uGOe7fc1ImwhXtE8VHRvUGr1vP8JNfv7M7zJI6fbVxpGQRMnB00WFGKLFmg0dM/NHoDItXm6PUrfP95UMxnxk/dVWgRWh/LLv4LIcHC5iyo0e3Zv1PCgBOqWslE1+Kw0eDEoq6Mr7xBQj11i7VhdK1uJ45nzZEzKs2gsb2DYlzsZpqsLBoKdppxMkbtItzYotz9k9GRq/ezsGMYdvv+eQGEJQoBULYd00QSKgCdcFv8bACPmvBHQ/nOPbKDe3wgkApOM9Ro5WNzJu6hhTajLqDNszt00sdWwHKH+h7XN4xex7gm93qAO+b4MbPEh8r1Zewm1FtO60+rGRjdqlK0cYrgF1eLKFjOSuvzj6bHbchrQEbD31/HBI7WL3HNQyXSEJduv8kaDWWAoXmYOQkDkfef3NpfTDOK3v9P8NqOnk/mQnorJCHyLxv0jJkZkqSm10NuRI8kH7AeTVTR6izDiLU2AGxTbkMnR3mM5ps
 j7zTCDyp
 pkaYXO60VKVHAk0orW8WyxlP64cAwnNT5qY+thS6AV3oEFiOw9DkHVHbWNJlxCi33dpO/gZs/1URuurthutfbtTB65NeSHfKzdK+db8Hh4saW+vsiiSxZ44+kIF5olLM2tXz0zHnL88VJDFp0uTvZviEiN95Lihe3M5aigOkoZisAbX4fDTNEOcDp3BDbLZEx0kx3pXRLgcx08b1WaoZ2PAnA9AoNX9AzN40wyoFY45sB+GL/KhpvWZQ2ni4VgRNsjStEcdFARJ75HZmxBRzcfSiG1zvpBLTJUi8jO4HvliowunOskNzFBF5cGafTQD3dKJTlR8LAt1sJKhOc0LvHkUZ/Hsfjph93M+Az+dw1mPHIVwFZqwzBQSjhGSlGMO1zp/TODmD2WoPoz0rgPS+KmngexV7OzTCRS3BR29KOlOqiMSGSBALJI+/Y/J+3ruxPRenpV5ONzyyjZ78=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/12/25 22:37, David Hildenbrand (Red Hat) wrote:
> On 12.11.25 05:46, Balbir Singh wrote:
>> commit a6ca2ba46390 ("mm: replace pmd_to_swp_entry() with softleaf_from_pmd()")
> 
> So should this be squashed into Lorenzo patch, or incorporated in his series in case he has to resend?
> 
>> does not work with device private THP entries. softleaf_is_migration_young()
>> asserts that the entry be a migration entry, but in the current code, the
>> entry might already be replaced by a device private entry by the time the
>> check is made. The issue exists with commit
>> 7385dbdbf841 ("mm/rmap: extend rmap and migration support device-private entries")
>>
> 
> Because this confuses me. If it's already a problem in the commit-to-go-upstream-first, it should be fixed in that commit?
> 

Not sure how to handle this, because that would break rebase of mm/mm-new
or I'd have to send a replacement patch for the original patch from Lorenzo
(which does not seem right).

I'll post a simpler patch, but it needs to be on top of the series

Balbir

