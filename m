Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFCDFC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53DA18E0057; Thu, 24 Jul 2025 05:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A09F8E0051; Thu, 24 Jul 2025 05:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC718E0057; Thu, 24 Jul 2025 05:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 129898E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:09:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 864841124E5
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:09:18 +0000 (UTC)
X-FDA: 83698584396.18.6357F12
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013012.outbound.protection.outlook.com [40.107.44.12])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2A40F10000A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:09:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=fA8NgzgS;
	spf=pass (imf05.hostedemail.com: domain of link@vivo.com designates 40.107.44.12 as permitted sender) smtp.mailfrom=link@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=vivo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753348156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5dCr3ukrDJQ9ovFT7dYHITFIZXX/UmRi8AB5ypf21Y=;
	b=i4jLkiwyTi/zz/CmjAy7bSPgeqvU+lsW5EfP50LbkkRrFvb4QJ9Uhqo9A582LaIUCSxmC1
	naTJAX8hGpCxMh9UPNB7avE5k0da4EzRv8v9/HxwVH7QVtNkECTdSu+httPTKcubucCX1o
	Kh/foN+Sw120Th9PwFOmb9Ekta/m1nk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753348156; a=rsa-sha256;
	cv=pass;
	b=yoCfwLflDa19N2Cmy3nqtTyTyo3uWRVI1isw3NTi2VQ8x1DOl15c0rHxCg69DUTOvtB0Nn
	CvB0vYZOLtZ4hLyT/+HQ06oc7O3HkS06+yDgVsw3BvC60gnPV/pFg8C0wrjGyAr2tdiA1/
	ANeKMUqowVrJNSwEqCyj7omtSnkuaMI=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=fA8NgzgS;
	spf=pass (imf05.hostedemail.com: domain of link@vivo.com designates 40.107.44.12 as permitted sender) smtp.mailfrom=link@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AOoPCtgtFBzyluiy1XNSPUWdPo9M3Grj7z/JGyOo6DfxCp0ZtaVBE6C5iocgexTCR2k0HIGDvFv5ZZT2UA6k/rxQxyPbTskSBTYlWvUY6VHx+0AfzEjAaXAf8wWf3lkhh6hoYWbSvDEVmKk0ZzWH+oPcMMEVif7Wl3z1NwAHHJxVh6HEN6w3TaLSqauzidjU1lXRwAllJ7VnagwLTWzIFRD+L6Jtme7Dl8Lw1grlW4AHgyt7Ae4gMkhWj6PEzURY8nbE6Rk5F1gUeisOGdxXfArqo2Ea0CdVPdxcdLWPflBQa2amoZzFYyUOZwm+W3504V3tG+Te7781EFRcZEWnBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5dCr3ukrDJQ9ovFT7dYHITFIZXX/UmRi8AB5ypf21Y=;
 b=HhgVkxL/gXlww3WdIOVw8+SYEqn8+wBdYwwdVqZ+vU6fuNmc+RUWBjqyhXAHeRTOhe8/sobIN0+klUHdjd75dK5hrjamJvm7qPRfExwwhv3wyVGZdPPr6q+TjmDS6khATL01pcswQhnVJy10aZtp7dz2ykv4s0O9u1yh24+b/mjs3HA6sFBCoU8YD0uXAloC+4bW9UdrrnlGnz/cSX8oQhy8JeHP8OhdKCfJRU9DNhp13596v7maLyOCyP8mIMrc3U87U6nl+KD0+JRt2S5RGKUhxfQbRUbI7OFItvqbOtILAuFwr3eJULghlrEPC/AtXZyJdvdbtYHaNxd2Nx0HFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5dCr3ukrDJQ9ovFT7dYHITFIZXX/UmRi8AB5ypf21Y=;
 b=fA8NgzgSp54lEoFGKmCdok85VIX/iXEeEiJkaDtUrZoMtn3D+Ljce0vW+xvxeTqoCJoUaBDkoPkhMAHN6mRoo/aJ/UMPnTzisrwyWoNafEaImv9hCfmzq2wGYEQE7pUQjqF531KeQ5ML2PW8ucKkzNdrV/mEwRAwlp2psbsYWVOolILZWwwfcoJLyOz2YGytZnZy4vz00MsWkYRRVNqhq6nQZaizRD/nBodLJmXf6o5bznaI3Z9NxW8MhFlWx+IySkoJbMKpb1Hk1w7VXNF19o2hXUFgrfKNlBJdG8goxHz2FWYMye/ESD9JQL16QzHq9nLXu5NJ8eXQvotF0KItmw==
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by TY0PR06MB5080.apcprd06.prod.outlook.com (2603:1096:400:1b8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Thu, 24 Jul
 2025 09:09:09 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 09:09:09 +0000
Content-Type: multipart/alternative;
 boundary="------------8AhXF963MPGW7Dj1kecJ6QwI"
Message-ID: <cc560d48-884d-4c8f-9fb0-565d74ad769a@vivo.com>
Date: Thu, 24 Jul 2025 17:09:01 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] introduce PGTY_mgt_entry page_type
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, Usama Arif <usamaarif642@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250724084441.380404-1-link@vivo.com>
 <86516155-f2d9-4e8d-9d27-bdcb59e2d129@redhat.com>
From: Huan Yang <link@vivo.com>
In-Reply-To: <86516155-f2d9-4e8d-9d27-bdcb59e2d129@redhat.com>
X-ClientProxiedBy: SI2PR01CA0018.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::7) To PUZPR06MB5676.apcprd06.prod.outlook.com
 (2603:1096:301:f8::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PUZPR06MB5676:EE_|TY0PR06MB5080:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bd7de9a-bf53-463b-6cbc-08ddca91bf9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|7416014|1800799024|8096899003|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWhrUUQxelk0UGtrRGJRaGEyOENvODNzK293YlRxZXA4QXRmT0FIcFY5ZGta?=
 =?utf-8?B?OWdEbC9IdmxSZi8xTi9ETG00Z3hWMzF0YjBBUXpxSTB4WFMzV1d4cS9mZ1Vq?=
 =?utf-8?B?VG4zSStNSkc2QVA1Q0poQlArSUhlZmQvcnBDVHl0Tktyc3JwLy9pamxSSFBK?=
 =?utf-8?B?dDBwbEJSQnhHV3NOWHJiZGsraWk5U3dQVFVBU2Jvclh6cjVzS1J5azcwVWNt?=
 =?utf-8?B?YWExamxTRkV4SWFxbmFXWU1CMXA0cDhMNlU2Nk1PRjF6WDZVY3BrQ3dQWW9S?=
 =?utf-8?B?bnorM1VuZkx4azhMai9HVmlZL1ZYclB2VHNVSnNqaCt3N2VrUnV5d2pEbjBs?=
 =?utf-8?B?alkrU01vRDI1OUp4Wi9sMXgxTFZwY1NOK0xDOXdhTnh0RmUyR1p6ZjRvR1pm?=
 =?utf-8?B?ek05MUNMdzdQeHc3Ly9aWnR4NjNxa0NvYXAwSkpKRGFMSVBaalE4TFJ3a1lT?=
 =?utf-8?B?QWhiWGdUcS9wVkZGMnE4dC9rbmlHTlZqcHVwOStPUGo3OWVnM3VUa1oxZzJO?=
 =?utf-8?B?NEZzZHE3UXNRT2dtSUdXVk1oajBZTDJIOTZuc2c0dFhkbnVDVkltazduTFF4?=
 =?utf-8?B?MHdMdHJ1NzRLV0xoak5mZmhYdDVoYjk0NmZpcHdMTHQ4bUZwOXp2K3pmTDdU?=
 =?utf-8?B?U1puQW9NMUpZREg1c1k2eC9XQkVINUpUWVlGWktIY0hFS3ZnQW9MNi9sRnVG?=
 =?utf-8?B?QXduM1M0RXFGajRXNVpiYmdURkxpaVpTemg0bk5FQnVWWmQ3L09XY293YU5z?=
 =?utf-8?B?MmVUak9qeUJxRVVSY0lxcHovaWcrbStlM3dpSHpSeloxSHZEdytyYXpHTVFS?=
 =?utf-8?B?S3l5U1pFL3hzMC9ncVIyMldBR3QrMVp5bWw1L0pmODl4TDBwY21BQkZFVkxE?=
 =?utf-8?B?azBybUQvVU5rTUo0RFFlWGFWdHRhOERGSU9IWUErYjN0UEFNeVFnYnpuRUVS?=
 =?utf-8?B?STNkN1B1UU96QVZDMkVRWUVvTU1ZM3ZNcGNpdmoxL1hGbkh4endlZ0xraXV6?=
 =?utf-8?B?Mk84QWZhcHRxbjVaZms1KzU4ZVljNkh6Ym9wNVRMWnZWUVB4ZzVNZnF2YU4r?=
 =?utf-8?B?aldrTjUzY3BIYStFLzQzWWNzOWJ5dGJpQ25nRmRyK1dpa3VsVlBJM2xGOTBT?=
 =?utf-8?B?OU0zalBFcWYzNndTYTRPeTV2SVN6VUJwRHRUZFlOZTJ6MXJnUUlIMWtnTVAx?=
 =?utf-8?B?WTB0cDJMRTdoUDh4MmtwUXdmczdnWUg0dGd3NzZ5a2Y4aS9STHhteklYaXpL?=
 =?utf-8?B?TzZJV0pSSXM3all2OVBaWUE0TXdsSUtFQWNKWkI3UHJkRU5ZM2VGQ0R1S1ln?=
 =?utf-8?B?czVwcGFtY3FNZGVqaE90VFQxU3lqQ2EvZU9mbm5ETU5NVGRISjBWWHErbUJB?=
 =?utf-8?B?SVBqMkN5T3pnL2VBckZFWWoyd1BHU0E4YnlTcVVvVGFSQ3FhcTdvWGdTY3ht?=
 =?utf-8?B?Z1FaSXQ1aFBweTl0RDdVdUtuc0FINW15YS9sNXY5OEtQZWduYzdabDZ6Mncr?=
 =?utf-8?B?WUpBK2tNSzRidFNaR0FtVHFqenFKRDZzbUZDYWZMQnJHVW9GMXFBR0RQQTcz?=
 =?utf-8?B?N1p4WjVrS2VRTVlTbXZneUdZYUwwU0VobmgvVHRrbzJqYU52aWd5eWhsZ3J5?=
 =?utf-8?B?OHN3Umc1U2gxVEZpQnpwbXlOZWduSWs5QzdlWGNaYUIrSncraSsxa3g2TlJp?=
 =?utf-8?B?d2I5RHh1NHVTbnBUS2ZsV05xYVZUOVZwRXJ1Q29kTmx5NXNwOU1kVWZmaGFk?=
 =?utf-8?B?YTYzcmJ3R0N4dEtRaWdkNFhydTExOGVJYWxFSFdSUks1UHBsRGt0UmtWaVhN?=
 =?utf-8?B?QTFhTkhRanQ4bG5tcGp4K0lOOHY5TXdNN3RIUFlOME5kWFhxSENXRmk3ejdZ?=
 =?utf-8?B?NDlWSlRhSW5xUEpZbTJ4eVQ4bnlTOWhtcitNeDQxYmFOc0dTUDVYeGMxYWVn?=
 =?utf-8?B?YVFFTU53eDllVUhWV1BQV0hnK1A3eDJ2ZTM2T3RPNVd6dlhiYkpSQ0xhTDky?=
 =?utf-8?Q?aRddfupQXBGhwRba8Uk1i1aqXYqWSU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(7416014)(1800799024)(8096899003)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MCtGT1NCL2RIWTUzSkZoZ1BoeHNId09GeFlkVVVmdDNGZEF5T2p0RjdCUkQy?=
 =?utf-8?B?ZjBaSHhxVTEvQXZqcU0vM0xyME1OZld3REptczRjN1lMQjJsNmRNR3QyU1NM?=
 =?utf-8?B?d0JPV1hUT3M0Y3ljd2Ird3ZNcmhmV3hjQ0o3TlVMdUk4Q3AwaUppVExKSnd3?=
 =?utf-8?B?ZXZ0V2w1MEI3VlEwc0dBZGZkK1ZZUFlJT1BKY0RnZ0RJMkZpTlVkKzBsUDZY?=
 =?utf-8?B?TG90SkQxOVVZOHIzQVBxYVlYUVA3SmhFTVUvU2ZNS0hXNHJKSmo1TE5xS3FH?=
 =?utf-8?B?ZXRDVmpTeWc5U3BZU2cwOWRvdlFLbTdKTnU2Yk91cUx2SkpPYWM2U2VlNktZ?=
 =?utf-8?B?MTJiNFR6bE5CK0ovZEN0eHZsSHpRd0lZRU5HV3RCakVMRkh6b3dEMHk3K2p0?=
 =?utf-8?B?RXBoVXd1d0ZBNUN6a1QvT1Q5ZzZxL1V6RG9TUTBBNGxwWEdJMTAwSkRNbFdB?=
 =?utf-8?B?a1pnT0tKNHRkb0RHdzFBQllncExKL2kwdHROOXoxVHZBSENCaFpKV2kyYTNS?=
 =?utf-8?B?TzZXeXRsQ3VhOStsaGk4Z01IVkt4K3k2Z0xIek12ak9sRlVKVFM1QmlaeUZw?=
 =?utf-8?B?NC9JN09oYmVURFVWQURBYXZOcGthSWVtVVdRTkc2bXpnVjhBZk5XVTROelFo?=
 =?utf-8?B?ZTlIdTlJdGVxNWN3eU9jZkNyUjJzQk95MTFOOVpTbjI2Sml1OXRUUndac1pr?=
 =?utf-8?B?akZNZHhPUWpUR29QSUwxVHFaTmluUnlpSmZOR2dieDVSL05pQUpuVTU3eGcr?=
 =?utf-8?B?UGZVNGlYTHRKYkF2d2NXRjVDL2VXUkY4Q3dadDZBd0RkZXdtN2FQZXFPRzFr?=
 =?utf-8?B?R012MURLUndsZWhmMmMwRDluM3Y2K0ZYTGdEaWFIS1orM04rL3hUZFBHSlFM?=
 =?utf-8?B?OWlmdWZGQkRmL2NPaFNsNHJMTURocTM3ZHBkbUdSbUM0eGQ2NUlyY05tT2tp?=
 =?utf-8?B?M0ZKdXhVY1ZGZlU0aHoxUnE4SFZ5Q28xRnVWZ2FWa3Q4ZmNrY3FqazFja1lX?=
 =?utf-8?B?bkFtQXFKaVRjSFl2NU1XWVYvOTBYcHErMFkrMmtscGJlUzdDWnZpd0FCU0da?=
 =?utf-8?B?WlpmalNjeVIxQmNaRFkraFdKNE5OcnN0akNHcS9heFFZRGFoVlM2SVJ0ZnJw?=
 =?utf-8?B?MEExS3hFRncrOU03bWExYnhiOXdPY0E5S3BSMWdPWllrN24veEovZnRwL0d3?=
 =?utf-8?B?ZUtISG9peWJSRW5naytDYURtVUExWWxtaURwREJvRGwvdDJja2c5U1NjYk5Q?=
 =?utf-8?B?T3QvaEhENXlQRkRyK2lWQmRIYjNKR1VrMVF4MmJySXZoRG9oWGpFRWs4d3kv?=
 =?utf-8?B?dEwzSmxkZXJiakNGVFVDQW9XenhGWXQxQUNYL1dWdVZUZ0tia0ptczJzVWtz?=
 =?utf-8?B?RWtqbGhkU3FDRG5sWGRNTmdyS1ZqUjc1Vkt6RHdCVVlJRjIwY1dJSWY3VUZK?=
 =?utf-8?B?L245UDNEaVNiZnFudHgra0E2M0tlZC9UY1ZUVGhNRHlpck5YQURzYitRWSth?=
 =?utf-8?B?WExDajI0MHJoTVRkRHlyWWZEc3lpQ0ttTldVMGZHUUt3ZGp6Yk9LNTRrNGhY?=
 =?utf-8?B?SjRxNEJvQ00wdXF3WmpCN3FTelpXS3VqOGlxOE9Dbm9EdDMzU0prajJQK1VW?=
 =?utf-8?B?Qk9VQTlIcFpPbnduVXZpOVIxQStiSXVWY1hMbGJaNkxtcUlRcWFnMXB2endO?=
 =?utf-8?B?cTg1S2lmcDhIc0JTb2daSHg2elFvajNtaU5NbWNCWStnR3ZtMGpmL3dOalhh?=
 =?utf-8?B?SkFaMkJWOCswQzgzYVdhVFJhVEtEZFB1YVl0TXJ5Tk1NenN5amNkVno4V2F4?=
 =?utf-8?B?VzdWSTUzaldxYWpHdEtza2lVY2hxTWdEYTBwRjlGRXZ6NUxFQndldW9Nc3Ex?=
 =?utf-8?B?cjZrRXRXNS9MN3hTYXNoRDlORE9vaGVUUUpUNHBBS0NPR0xWZFdiY1k2Z0dJ?=
 =?utf-8?B?RVRHWDJWTkhnQ2pMaUJwNWN3UlF4S3J5VzIyTjNEUksrQ3I2UE9uZmhCRkhM?=
 =?utf-8?B?SG1jcXNENHA5eTlMaDBBOFlRZUs1U1VTS0xIcVMzSUIyRFZDL3ZKWkVlMWI4?=
 =?utf-8?B?L3BFRitoRVdSTk5IWkRpVGtQRkU2d0hQOGZRZngwak5BZFliZXpmWFdYcEhW?=
 =?utf-8?Q?B2TegE/LNuHDbWXIXrue8YdTy?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd7de9a-bf53-463b-6cbc-08ddca91bf9e
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 09:09:09.1789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1DSzfbsuMI6lWMrYHOYF72ONWaH7pFUdCBBgRmJ4W8o5OhViepnfM5nIYuc0ngUAeezThC7law81uqjKQEoY4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5080
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2A40F10000A
X-Stat-Signature: coxxag6tam9bpg39nq7nw816fitzepok
X-Rspam-User: 
X-HE-Tag: 1753348154-54114
X-HE-Meta: U2FsdGVkX1+zYqv5RGoKnnOy2VTzYKXcC7nnKbtDAESOkms9d9k2bK1jFE9PrVzFLbng4+dtWE8d0JXrojUdSH6xUlI7PcX4plO6J9SbjUoMkK1l3H3wyLiNbdF5pQOjMTWM7u+PVwWjkiOsbt09ZrjZxtErt71lF80Nj0iqWK3PLG2ZrJ8dSuGcVJa/s//+COszbZt6XkdU71ybUzgRU7mpnGNVO+mYJMOSKujAW8y2Bh5Jm5SNTZhUzj76whUGltojkfgKiVsTzii6fjHo23SJGe2fACxhydWTxpmwaGeDjAlRfM2PAAWwLA6SgOIgyHm3ilCOterjYuBxpLEbsUGXKKLso9MCJ6NFfJNY+/UwAPy47m1kB7QcDEOv5m2bhSVfMWxJ1MQhLnxVQ6heuvkKxq3iFmdMCSUA47JytAzMdZnM70RlsLGpCeie+ZPzc4BYRFF2PIdDJTn8kjy4/x3NIwlF+SW6ixSBkZEOu84uUjelSYc539fBoAnCscGEsvFos/Sq+o6m7HKn5i1cJlW5lvyefCst7YUod6zK1J3tTJr1n1K7nIeVySfXYRwGgKY01rc9FUFnZQjPFg3qmmmaM4/yJMECkrcNM8gkNdgDZN6pnnp+uhqyoDVwvEKdvCo0YCJD6hICFMUgdWydwMt0gBGse7EnvkW9mpqaDArPBp16w2TAwyMa2gRvqrMQDxoJPBj3HN1Ip6DGj91OOYdfmTfLIp2B9QNiGAXb3HUfnyLea+gAV397nLt1d38Tc4X25YCQAr4LxsTtvS4Gu18z0j3qzjFQh3Gr9lC6UrUfhwpmfSkThr/UC7Te96l8X5I754XRc0mphM/GPUar3QA+zDijiWsQuW4K8RVHDSCIzeDWbEDQXCCA1fiYgVQBn4DIC3yN/jXhA8gcjUvx8xQ6edwF41znD77m36ws8ZtToxjJSWe6CtHhaoWxUXio/vlAUmLW9ihcARNuSyZ
 hS6ltZc2
 TFdkpy0BdUs7+Z2UJHoWhijfgrLbFi0k3eDvls0wXVoQCFO88XmIFTbsnsGj8Uw1+pAIj3UFeaLCH0sU6NeIB83ao6tbUAdVW0fMSRhoxk0dFzoo6YlNfZJLnyygiQYPVfJkgjO5roN7Y+TddUIPHghdsTph0ru5RVmSKOWHkYZFDcbCMcsvm/xUTYakMiAvtlTuZaZk5GprHOMUlsVg38kkdiq5MjXQTFDjcTWTtppT1KJA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------8AhXF963MPGW7Dj1kecJ6QwI
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/7/24 16:59, David Hildenbrand 写道:
> On 24.07.25 10:44, Huan Yang wrote:
>> Summary
>> ==
>> This patchset reuses page_type to store migrate entry count during the
>> period from migrate entry setup to removal, enabling accelerated VMA
>> traversal when removing migrate entries, following a similar 
>> principle to
>> early termination when folio is unmapped in try_to_migrate.
>
> I absolutely detest (ab)using page types for that, so no from my side 
> unless I am missing something important.
>
>>
>> In my self-constructed test scenario, the migration time can be reduced
>
> How relevant is that in practice?

IMO, any folio mapped < nr vma in mapping(anon_vma, addresss_space), 
will benefit from this.

So, all pages that have been COW-ed by child processes can be skipped.

>
>> from over 150+ms to around 30+ms, achieving nearly a 70% performance
>> improvement. Additionally, the flame graph shows that the proportion of
>> remove_migration_ptes can be reduced from 80%+ to 60%+.
>>
>> Notice: migrate entry specifically refers to migrate PTE entry, as large
>> folio are not supported page type and 0 mapcount reuse.
>>
>> Principle
>> ==
>> When a page removes all PTEs in try_to_migrate and sets up a migrate PTE
>> entry, we can determine whether the traversal of remaining VMAs can be
>> terminated early by checking if mapcount is zero. This optimization
>> helps improve performance during migration.
>>
>> However, when removing migrate PTE entries and setting up PTEs for the
>> destination folio in remove_migration_ptes, there is no such information
>> available to assist in deciding whether the traversal of remaining VMAs
>> can be ended early. Therefore, it is necessary to traversal all VMAs
>> associated with this folio.
>
> Yes, we don't know how many migration entries are still pointing at 
> the page.
>
>>
>> In reality, when a folio is fully unmapped and before all migrate PTE
>> entries are removed, the mapcount will always be zero. Since page_type
>> and mapcount share a union, and referring to folio_mapcount, we can
>> reuse page_type to record the number of migrate PTE entries of the
>> current folio in the system as long as it's not a large folio. This
>> reuse does not affect calls to folio_mapcount, which will always return
>> zero.
> > > Therefore, we can set the folio's page_type to PGTY_mgt_entry when
>> try_to_migrate completes, the folio is already unmapped, and it's not a
>> large folio. The remaining 24 bits can then be used to record the number
>> of migrate PTE entries generated by try_to_migrate.
>
> In the future the page type will no longer overlay the mapcount and, 
> consequently, be sticky.
>
>>
>> Then, in remove_migration_ptes, when the nr_mgt_entry count drops to
>> zero, we can terminate the VMA traversal early.
>>
>> It's important to note that we need to initialize the folio's page_type
>> to PGTY_mgt_entry and set the migrate entry count only while holding the
>> rmap walk lock.This is because during the lock period, we can prevent
>> new VMA fork (which would increase migrate entries) and VMA unmap
>> (which would decrease migrate entries).
>
> The more I read about PGTY_mgt_entry, the more I hate it.
>
>>
>> However, I doubt there is actually an additional critical section 
>> here, for
>> example anon:
>>
>> Process Parent                          fork
>> try_to_migrate
>>                                          anon_vma_clone
>>                                              write_lock
>>                                                  avc_inster_tree tail
>>                                          ....
>>      folio_lock_anon_vma_read             copy_pte_range
>>          vma_iter                            pte_lock
>>                  ....                           pte_present copy
>>                                              ...
>>                  pte_lock
>>                      new forked pte clean
>> ....
>> remove_migration_ptes
>>      rmap_walk_anon_lock
>>
>> If my understanding is correct and such a critical section exists, it
>> shouldn't cause any issues—newly added PTEs can still be properly
>> removed and converted into migrate entries.
>>
>> But in this:
>>
>> Process Parent                          fork
>> try_to_migrate
>>                                          anon_vma_clone
>>                                              write_lock
>>                                                  avc_inster_tree
>>                                          ....
>>      folio_lock_anon_vma_read             copy_pte_range
>>          vma_iter
>>                  pte_lock
>>                      migrate entry set
>>                  ....                        pte_lock
>>                                                  pte_nonpresent copy
>>                                              ....
>> ....
>> remove_migration_ptes
>>      rmap_walk_anon_lock
>
> Just a note: migration entries also apply to non-anon folios.
Yes, just example.
--------------8AhXF963MPGW7Dj1kecJ6QwI
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html><html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/7/24 16:59, David Hildenbrand
      写道:<br>
    </div>
    <blockquote type="cite" cite="mid:86516155-f2d9-4e8d-9d27-bdcb59e2d129@redhat.com">On
      24.07.25 10:44, Huan Yang wrote:
      <br>
      <blockquote type="cite">Summary
        <br>
        ==
        <br>
        This patchset reuses page_type to store migrate entry count
        during the
        <br>
        period from migrate entry setup to removal, enabling accelerated
        VMA
        <br>
        traversal when removing migrate entries, following a similar
        principle to
        <br>
        early termination when folio is unmapped in try_to_migrate.
        <br>
      </blockquote>
      <br>
      I absolutely detest (ab)using page types for that, so no from my
      side unless I am missing something important.
      <br>
      <br>
      <blockquote type="cite">
        <br>
        In my self-constructed test scenario, the migration time can be
        reduced
        <br>
      </blockquote>
      <br>
      How relevant is that in practice?&nbsp;<br>
    </blockquote>
    <p>IMO, any folio mapped &lt; nr vma in mapping(anon_vma,
      addresss_space),&nbsp;<span style="color: rgba(0, 0, 0, 0.85); font-family: Inter, -apple-system, &quot;system-ui&quot;, &quot;Segoe UI&quot;, &quot;SF Pro SC&quot;, &quot;SF Pro Display&quot;, &quot;SF Pro Icons&quot;, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">will
        benefit from this.</span></p>
    <p><span style="color: rgba(0, 0, 0, 0.85); font-family: Inter, -apple-system, &quot;system-ui&quot;, &quot;Segoe UI&quot;, &quot;SF Pro SC&quot;, &quot;SF Pro Display&quot;, &quot;SF Pro Icons&quot;, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">So,&nbsp;</span><span style="color: rgba(0, 0, 0, 0.85); font-family: Inter, -apple-system, &quot;system-ui&quot;, &quot;Segoe UI&quot;, &quot;SF Pro SC&quot;, &quot;SF Pr
 o Displa
 y&quot;, &quot;SF Pro Icons&quot;, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">all
        pages that have been COW-ed by child processes can be skipped.</span></p>
    <blockquote type="cite" cite="mid:86516155-f2d9-4e8d-9d27-bdcb59e2d129@redhat.com"><br>
      <blockquote type="cite">from over 150+ms to around 30+ms,
        achieving nearly a 70% performance
        <br>
        improvement. Additionally, the flame graph shows that the
        proportion of
        <br>
        remove_migration_ptes can be reduced from 80%+ to 60%+.
        <br>
        <br>
        Notice: migrate entry specifically refers to migrate PTE entry,
        as large
        <br>
        folio are not supported page type and 0 mapcount reuse.
        <br>
        <br>
        Principle
        <br>
        ==
        <br>
        When a page removes all PTEs in try_to_migrate and sets up a
        migrate PTE
        <br>
        entry, we can determine whether the traversal of remaining VMAs
        can be
        <br>
        terminated early by checking if mapcount is zero. This
        optimization
        <br>
        helps improve performance during migration.
        <br>
        <br>
        However, when removing migrate PTE entries and setting up PTEs
        for the
        <br>
        destination folio in remove_migration_ptes, there is no such
        information
        <br>
        available to assist in deciding whether the traversal of
        remaining VMAs
        <br>
        can be ended early. Therefore, it is necessary to traversal all
        VMAs
        <br>
        associated with this folio.
        <br>
      </blockquote>
      <br>
      Yes, we don't know how many migration entries are still pointing
      at the page.
      <br>
      <br>
      <blockquote type="cite">
        <br>
        In reality, when a folio is fully unmapped and before all
        migrate PTE
        <br>
        entries are removed, the mapcount will always be zero. Since
        page_type
        <br>
        and mapcount share a union, and referring to folio_mapcount, we
        can
        <br>
        reuse page_type to record the number of migrate PTE entries of
        the
        <br>
        current folio in the system as long as it's not a large folio.
        This
        <br>
        reuse does not affect calls to folio_mapcount, which will always
        return
        <br>
        zero.
        <br>
      </blockquote>
      &gt; &gt; Therefore, we can set the folio's page_type to
      PGTY_mgt_entry when
      <br>
      <blockquote type="cite">try_to_migrate completes, the folio is
        already unmapped, and it's not a
        <br>
        large folio. The remaining 24 bits can then be used to record
        the number
        <br>
        of migrate PTE entries generated by try_to_migrate.
        <br>
      </blockquote>
      <br>
      In the future the page type will no longer overlay the mapcount
      and, consequently, be sticky.
      <br>
      <br>
      <blockquote type="cite">
        <br>
        Then, in remove_migration_ptes, when the nr_mgt_entry count
        drops to
        <br>
        zero, we can terminate the VMA traversal early.
        <br>
        <br>
        It's important to note that we need to initialize the folio's
        page_type
        <br>
        to PGTY_mgt_entry and set the migrate entry count only while
        holding the
        <br>
        rmap walk lock.This is because during the lock period, we can
        prevent
        <br>
        new VMA fork (which would increase migrate entries) and VMA
        unmap
        <br>
        (which would decrease migrate entries).
        <br>
      </blockquote>
      <br>
      The more I read about PGTY_mgt_entry, the more I hate it.
      <br>
      <br>
      <blockquote type="cite">
        <br>
        However, I doubt there is actually an additional critical
        section here, for
        <br>
        example anon:
        <br>
        <br>
        Process Parent&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fork
        <br>
        try_to_migrate
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; anon_vma_clone
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; write_lock
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; avc_inster_tree
        tail
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ....
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp; folio_lock_anon_vma_read&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; copy_pte_range
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vma_iter&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pte_lock
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ....&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pte_present copy
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ...
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pte_lock
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; new forked pte clean
        <br>
        ....
        <br>
        remove_migration_ptes
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp; rmap_walk_anon_lock
        <br>
        <br>
        If my understanding is correct and such a critical section
        exists, it
        <br>
        shouldn't cause any issues—newly added PTEs can still be
        properly
        <br>
        removed and converted into migrate entries.
        <br>
        <br>
        But in this:
        <br>
        <br>
        Process Parent&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fork
        <br>
        try_to_migrate
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; anon_vma_clone
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; write_lock
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; avc_inster_tree
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ....
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp; folio_lock_anon_vma_read&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; copy_pte_range
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vma_iter
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pte_lock
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; migrate entry set
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ....&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pte_lock
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pte_nonpresent
        copy
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ....
        <br>
        ....
        <br>
        remove_migration_ptes
        <br>
        &nbsp;&nbsp;&nbsp;&nbsp; rmap_walk_anon_lock
        <br>
      </blockquote>
      <br>
      Just a note: migration entries also apply to non-anon folios.&nbsp;<br>
    </blockquote>
    Yes, just example.
  </body>
</html>

--------------8AhXF963MPGW7Dj1kecJ6QwI--

