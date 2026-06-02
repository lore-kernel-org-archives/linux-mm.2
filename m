Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20221CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 19:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C956B0088; Tue,  2 Jun 2026 15:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D016B008A; Tue,  2 Jun 2026 15:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6E346B008C; Tue,  2 Jun 2026 15:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D90D56B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:32:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22D4F120122
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:32:12 +0000 (UTC)
X-FDA: 84835968504.24.0A10B1E
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011011.outbound.protection.outlook.com [52.101.62.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4095740013
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:32:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DWoxabdB;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780428729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5gL5Oh8AELNfskH37ozMD5G2zt9xasmGMX/iErb0jrw=;
	b=EwBfDE+8GFBQC6DBiw4Sag8wjBd1qvg4/CWStJkQN5HafA1AFcIzcbV/fiE18ZMObUMMcZ
	QXdEIwMXjUNvJi5SEIh7pq8/dd88z1Z1vGyWtKC8jWYeX1fIS5LjEG7hXsHTwiKpx/Et+i
	PIQjq5KTe7hF9JAnHAh2y2YIc36yMgw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DWoxabdB;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780428729;
	b=H12IhJdcVOXX6q40KEDsHl8fRgT1SwlYRVqBMjuIcJQG8Ygsvx2S/Lj5hgVMyLITDMpZFa
	LxPBLBfZNcGoVsTmSfmbeF/7GQOfSMkFw7wCHcNuxSTp7EgCxlOGvyxy73KOV8TdYdr3cS
	aIqIl2qHx8VMi48qZmiThSIwAnJEVs4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=of5mbFFqa5coFZ2seGT6TVPpxNw3JcU//ROjpBjcIKWAFVfJOu8ZmQXVaA0u3b5y8GVcu4zgV1AdHCHPd4pPHYumiKvCZUICiO7lDC6yoM9pkQ+CuYCVukya3+GAAD/txnbyM4I9tBpi6upABmtNn8IKKX8kCjvVA9m1WciwBL6w4mSBFyrj2Aa65A7+b0gfTc+uQXqyAeLuCHwUog9KTNJZ7J79FWdrmwvE+GY0FqtIvTtGlKtVj+qese0AVESfGlqFiQbw0jWaQw9TEn6V2WtpVxCf4Eoaeo2B2G0m0fFlXBTR4h32byabNXosnxIGSlqb9mYgD3oRev8kT55+OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5gL5Oh8AELNfskH37ozMD5G2zt9xasmGMX/iErb0jrw=;
 b=cCOT/bmoBuc5TgV+yNtXX1Fbo0uhNbqDs0aEVy5xwNx57MYcw2R3F473GIicn2A9veeaTkEW50bsJUBWFcZIDqXcfes+rgco9kYXbyDTb/UXFZMyS9CWCWJ6Yb3/gNnrrRnTvxrqk5R6l2l0TV4Ukx970UJFqfEAgZ1LKLv3l6qukdrY4MnMceDVh+PYRNA4ivFXyjtCjp7j0MmZfnydpgEm0Tg4fTWpcYtkXX4ziYB2SI1BKX1MI5DejRGKW5t/ZYWuDhXYiG6cOiOeZLgZQKTDz66LhtGVJ6A6Ke4ppnpCQWXPLBjXN/kl3vp5bIxzIiy0L7fvbx3EtZP+VCUhaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gL5Oh8AELNfskH37ozMD5G2zt9xasmGMX/iErb0jrw=;
 b=DWoxabdBGzDAGWyqF1jNCN8oHDSyxlQKw6R1Nw2+sYsbqE8BSVtMNjma7yZDRzr0SmWX/NXYNth/LLcQx06gOUxJCgnk+lM4SUOmubJ9cccEWf3rXnPYXyDbEnFKOW3IdaV2rnM8Mf+DZnm9cBfVTbx9IfseiUohRp1kDbdzXdWk2sK0tLfNmeoQoahqYHQERG48usKqZetyZ5TAVUIbD/ImLRUQgDAcIsdYaCwO81Co5bcUAUCSBDA2VWyx7wlW2FR/eSIStMrNQXh3T2e47cJ4lqUnbiubZTJ67YD8GkChWB0peTf7cL8/y4upzierFC2zXWm6YGYUUtmNH4rKZQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB8744.namprd12.prod.outlook.com (2603:10b6:806:38c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 19:32:01 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0071.014; Tue, 2 Jun 2026
 19:32:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Liu Shixin <liushixin2@huawei.com>,
 Oscar Salvador <osalvador@suse.de>, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v2] mm: page_isolation: avoid unsafe folio reads while
 scanning compound pages
Date: Tue, 02 Jun 2026 15:31:58 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <3BF8FD42-7792-4862-B5B3-79691618217D@nvidia.com>
In-Reply-To: <b03c0d32-07e6-4148-bebd-50784aa3cbb1@kernel.org>
References: <20260602130755.38794-1-kaitao.cheng@linux.dev>
 <34F0943E-4ACD-4655-B9B8-41F658FCDB7E@nvidia.com>
 <b03c0d32-07e6-4148-bebd-50784aa3cbb1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0108.namprd03.prod.outlook.com
 (2603:10b6:408:fd::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB8744:EE_
X-MS-Office365-Filtering-Correlation-Id: 83bf84cd-d880-4a89-596d-08dec0dd9e70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|22082099003|18002099003|6133799003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	1ZODeKtfUa5t9It8CHpverA0bxEJOpcorU9bwr68+RLK5QdpoB+LPdXvNXHGx/6tEzFR6ykZ3YwdJApFOq13aqJNOwjwJub4QDIWxVR7lxa09ATtFe/7P+bQx1HOZdMOAtwn+EarpvVLKBjE6S5Ru10VP0Pj4A3DagUF9zde/cuWkTtHptlhOgUBBsEKZ+BK3WZAsN5m4D3rDqM8HmJv0o9mYMciiT3ATh2iYMLNlymaihLtEeiqF5aLMhtRwriqVU5rD3DACsM0O2qo6VEFplK+tEmbecv1NjCt5sjxeAuEEinMUQu8Jv32SUIvYKS5/nOgGuqQ7QNCW9bNVajkUHS79tY8gMecIlP+1rLaSP2Tp037h8o1ATIOw+q9OuNStkpnlsSkwwhsW+11G8R0UpCad+ASCVySAFPvXWBGb5OxIDJt4Im/A3A298eIv9l48Mf6CoG7NOr86ci0TkbWv+zFznOSX6Pz948NyUr++EvOOuaMygwLLa1V+azeSjvpSU2oxq5ineLaH1KtJPmOQiq3rBBiDzoEp25IHSyqTOISJN+XFtaVZsowc830qyZV7Q9G4ARGie40Rtrx4S1C1k8bJ8v21hH/kUxW3SIkUcCPAs2S6Y4RDzMk3qgKlmi1O1G/2AdGUkGfkpWrrMmQytBxxLhwviZCGJUjn9LBSnvI1B+rc5WNN74iEoUm3pgPecyxmUFt0dFAbBA72JEgsw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(22082099003)(18002099003)(6133799003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejUrZ3YzK3E0cWYrVmdkSStFYmZQVWMwUHRWYWMwKzlHVlZoUHFHbU1IMXYx?=
 =?utf-8?B?ekFKQnMzQnJoWW9HcjRFT0tqNXNwN05KanpESUZsVWc0V2swYWU2bXJkZWhp?=
 =?utf-8?B?amdPNGErVUYrVWRNMlo5NFZHSjNDVzI5R0pOdXFvV3pnM2FrbG5TdVkrM0hl?=
 =?utf-8?B?M1BvV1M1dmk1WXUreHVJa1JkbHJBOFhpdGxJa2FtM0F1K1I2cDJORFJGU0hH?=
 =?utf-8?B?VUhCTjQwWnBtdWNQZ1pxZDI5c3FENTVHbTlQTWRMUGlBbGhWT0did2x4WWhy?=
 =?utf-8?B?NmZVaHRqcnZyWDhzSWJUSmpBZXdpMWFoM2krMVpuNmJlY0tvVFQwNHN5dTds?=
 =?utf-8?B?TXk2bnptZXVjR3ordk1QdENWMGJkaTQ5K0kwYm53a0tVdkhTV3ZiWjd0dzYr?=
 =?utf-8?B?TWhJZEZRekNJdXVuNkduSXRGNTlacjJjL2kyUlMxa2xTTkRxa3ZBM2IrU1Vx?=
 =?utf-8?B?dmRrM3VpUFZIVmw3eTUzUTE4cGFoQzFzNVJ5T2J0eVFaZDhsVGxEZVBFRlZt?=
 =?utf-8?B?NGUvOFV1TFdhOWtDL29Tb3FXWXJOSzkxdFo5N0p5RERHN3VQUGlpVk5qNjE2?=
 =?utf-8?B?WWgrelY0azFUeXJuR2dDcGEyVlBEamUzNmlaeWZTYzl2RGRGUGFOV2NpTURH?=
 =?utf-8?B?U1dEemFtSFJXL0hKaVZPd1pHL1dRanlNR0x1VEFWT2FiVXIreU5td1VaQ2hy?=
 =?utf-8?B?UDNQYU9salJSMmRUblRxZnpJOWJzUHNwQ2Y0czV3dDNTelMyK3FuZU1QZW9K?=
 =?utf-8?B?TC9ORWlraEg3dUxTRlZxT0dyVXdLcGpoUm1tdmxZMzRZK3FDYjhKU291SHAy?=
 =?utf-8?B?cThFeC8vcWJhSXNEUHJiUlJ6ZDVjMFdLQytOSmY0VnJNNHdYeEo4bHQrcmpv?=
 =?utf-8?B?bHZWOUNiOGRsMC80Vk9FMDd3OVNaSGo1K2RjbDIrd0pVNHlKekhaNlN5dWxR?=
 =?utf-8?B?ZDFLdmNoMm04dWdSWUs4L3dZR3ZWdTVvaWRpZXF1WldwbmxZbWN0aEM3WlpX?=
 =?utf-8?B?UG95Q3NpaUx1MUVQQ3g2R2V2d3dVaGlUNDd2MUhDYzhvM1BONSs2eklmczN4?=
 =?utf-8?B?QXBFSzkrREZUK3dtSG1OQi9KRW5wYUhoZDNoTFhGSW0wMkxxTUkzSTFFT0xn?=
 =?utf-8?B?a2Nxd05BaDRiVkExb0VsV1EwWmp4amN3MXhKMFZsWnFBRFpvZjdZRWo0bHJ0?=
 =?utf-8?B?aVZqcDdNQ1FZWFY0U1NibHNTaDladzhxTHI1S1VUNzZ5dmQzMUxEMFhCVVdy?=
 =?utf-8?B?U1p3UW1KMGJOZzBuSFlMOEphK1ZtWFd2MU80S2YzWERUYThJeHJuR1lqcXhL?=
 =?utf-8?B?NzhwYzRNZ2hkbit1dFNQaEJEcWlVQnIwS2d6RmVFS2M1NWs3VXpxbUFWMU9P?=
 =?utf-8?B?TGRMUnZLZ0hOVU9hSmY0VnRSL1VVRTBPT3FGWHppc2dPeUdEZ0ltbm5QU0V1?=
 =?utf-8?B?UDBQaGpKdnNJdUJIZ2lPb3p3TlFrbWlRVU5NQlRuNGdkMWpUaVpueEhDSmVG?=
 =?utf-8?B?YlhySklDcGVSK2FKdG5tV1F1OFhETURvZTJkNU8yQXk5STdDQXhnWHRROFll?=
 =?utf-8?B?cmo3a3FnSVg5Ti9PMDBIb1R2eDAzSlo5N3ZaanY1dlZBcURmVHZFNkZzR3J4?=
 =?utf-8?B?a1hvdWNCRTVFNm5KaEJPRGlWd2t2Wm9zU3IrbFVCeUxFN2VPWlBvMXdsNnQw?=
 =?utf-8?B?bCswdXg4d1BJQTg3U1JxL05hRXp5dGd3UEc3ZjlpUHJWTnNRZHdsNjhEZk9J?=
 =?utf-8?B?d3hBZ3hHUFhUQ2huK29KZWkzUVZUNjBZTEtvZWZvbHVwcjk5YUJCMW9nMEVT?=
 =?utf-8?B?aXlVdHBSbWQySUJjN2ZKZmdnQXJyNDdkWTZJOGhOdXIvamxCc2ZUalkrUHlD?=
 =?utf-8?B?UEpjbHFHZTRIYXk4U3UySHJLV3VYNmpUVHpQajBhWExRS0hocThUZEJJaGE2?=
 =?utf-8?B?UjkvS1dtM1ROVDViRFJ6a1Y0emFFWUhXSDc5S0RWbTArYldSMFE4T00vc2pU?=
 =?utf-8?B?QTNBeFJqN1lyblkydllIak8rV2VYeVJVOXBhQkVYSndUWDNwWW10RVBXQ21i?=
 =?utf-8?B?QTkzWGJIZjE0dnBPV2orK1JOc1NoUFhrY0YwUTN0cThOQnllVUZoZUtCUlBt?=
 =?utf-8?B?d0xOUUJNQVl3TVducmkvd1A0MFRRQVhlRUdneGZMNUZaRmQyaVFTbnR6WVBZ?=
 =?utf-8?B?clVxWHlqUUJCWEE0L0tLdUxINUJLTzhkY2dwTk1Sc0J2aEtDWnRveVd4WWg5?=
 =?utf-8?B?eFZZblVEOW5NWUFUVnVVSHQwOHQzQTBjdjd0N281aUVXZnA1SlNCZXZyMzQ3?=
 =?utf-8?Q?KcA7cJknmcL0Uf59Bz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83bf84cd-d880-4a89-596d-08dec0dd9e70
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 19:32:01.3921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MKLEXlMaPU575BGhIIaWEtlrCrVpGJah5RGyMwHP4ad9kF4xOw6u+tqk6SWZ22wv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8744
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qy9xps1uhkooic5umq3npcnahg5qedbq
X-Rspamd-Queue-Id: 4095740013
X-HE-Tag: 1780428729-272825
X-HE-Meta: U2FsdGVkX1/9w43qox2M84j8wOGlqiTmtzhyYTs9NBGsmQe3BQDKdWzi0XMP8lDxnbMoBgQt8yN08SVmyDiaTQs5tNVve75rHilEBiAY7Sdb6z/QylWqdTbAVGiFEl2IaL7yhJprAPmrDQ7iPKoAB/nCO3/54wNNELbdfZpk9wLz+egda/ocXqlpG8l8xbv0migor4AcHQULaDniOx4meLl+Zidc635Xc9ZjXBycbkQETYU0Km6g09rGDZmbkiq/nqKFFnYl12/xZkmAmiSQDzaG0Eu7/9vLZ7OSMRif+4grS8cLyjgv1BSPECESy/bx3pjRMb08C3Xez4H25EvZ0BgV8+WwVZyFg5Pf9VORTTzIxmm3s+i0MZyUGnksSnRyvfKOsO9kJZhH+HvhVJDxUZ7FqT9nLfSIDzxkK4TevhwGWEIPyYbkz6vEhvdgJkij+pnleeob26BCv5Ic+dWkkb2Nk3z2FJHxmXG+pFU80KBZyZPobrNzqh2o/jMDZlyOfIfs+SC4NB314uwPExvHWDawDLX/A4d/yzrmc3MuTU+QKdqdPstwdw4ExPvkmPBvER57xv/KpDgTM3OwV0MCQYYlbkhJpWDpgDrfVBb8jgOCD9upKMeNfF2838HmN9dD1S+VdSsNCbCdTrKETsmGJKEeiTT6LzUcZh4ksxAq/jMwdKTT5YR0x2CUSJXZoBpPJe46PWhIgZPkSialP42uhXsvFRZyezS3E5ZHcp3ff1Ud82wY31ABTCe6GIk5l5Czx4aaMwZER1tVYvYaM1O6n3aFwQkFgXq2/PQRVhSCOBE/vDn9rCcjci0FqA3cLbxWmDR4bk/1pPewDXqodffzVX+lFF+klXdH84giB2SXpz0IZomfiZzz2WeNrQp1eebHf6gLACKLiYmNCUMty6uyqUlGu6rZBgovsm8oNWFuJxbSMYEMDTDLF2ySjJGXzFnCF8o1HN6GLwhXXnIUVBP
 EBsZKB02
 +LonpKo5+Dbk5NSizWP9SHnT4g70JqRC9Tye9OE58okLidzmbKZudKv71BXEAM67F0drtNvWgJoJym6l6zZuC5+ibaWaWoWufFhsqJkWtsiL+NZBdFSwcRRSt35+GPgp2h1EBrSn8nHzWKxGH/ISarratYumaa41HoWROf7pgFD5h0YpLNhwyHcHfhiu6v93p2tTFNYx5rXqcLPJNuhQ3L/ttdbHIkDZld7erybC5LcHJW5CmIgFkZ0jlUoUvGTBt+1iglBo9OIk/Pn6q5oTmhXfU070ODxTzIbOOhFNhiESy7SRebucRQEwtH6kM2NKrbnRb+3MyHtyPTIuJr2FmRXdIejHjA55A9xrBzWslQCHPuBb8SViW8CYou/qLt0OXYAAOz+9c/lV+LUmCQ97uJjw4kO5bLRJaHrSBtWccuGSDEUAQ0R1Zdx/COZeehOpKZmwE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Jun 2026, at 14:56, David Hildenbrand (Arm) wrote:

> On 6/2/26 17:02, Zi Yan wrote:
>> On 2 Jun 2026, at 9:07, Kaitao Cheng wrote:
>>
>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>
>>> page_is_unmovable() can inspect compound pages without holding a folio
>>> reference or any lock. The folio can therefore be freed, split or reuse=
d
>>> while the scanner is still looking at it.
>>>
>>> The existing HugeTLB handling already avoids folio_hstate() for this
>>> reason, but it still derives the hstate from folio_size() and later
>>> derives the scan step from folio_nr_pages() and folio_page_idx().
>>> These helpers rely on the folio still being a valid folio head. If
>>> the folio changed concurrently, the scanner can read inconsistent folio
>>> metadata and compute a wrong step. In the worst case, folio_nr_pages()
>>> can return 1 for what used to be a tail page and the subtraction from
>>> folio_page_idx() can underflow.
>>>
>>> There is a similar issue for non-Hugetlb compound pages: folio_test_lru=
()
>>> expects a valid folio. If the previously observed head page has been
>>> reused as a tail page of another compound page, the folio flag checks
>>> can trigger VM_BUG_ON_PGFLAGS().
>>>
>>> Read the compound order once with compound_order(), reject obviously
>>> bogus orders, and derive the hstate and scan step from that order
>>> instead of querying folio size information again. Also use PageLRU(page=
),
>>> which is safe for the page being scanned, instead of folio_test_lru()
>>> on a potentially stale folio pointer.
>>>
>>> Treat an unknown HugeTLB hstate as unmovable so the scanner does not tr=
y
>>> to skip over an unstable HugeTLB folio.
>>>
>>> Fixes: a0a9f2180b90 ("mm: page_isolation: avoid calling folio_hstate() =
without hugetlb_lock")
>>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>>> ---
>>> Changes in v2:
>>> - Avoid unsafe folio metadata reads in the unlocked scanner by deriving
>>>   the hstate and scan step from compound_order(). (David Hildenbrand,
>>>   Andrew Morton)
>>> - Treat invalid compound orders or unknown HugeTLB hstates as unmovable=
.
>>> - Use PageLRU(page) instead of folio_test_lru(folio) to avoid folio fla=
g
>>>   checks on a stale folio pointer. ()
>>> - Update the commit log (David Hildenbrand)
>>>
>>> Link to v1:
>>> https://lore.kernel.org/all/20260519121646.40833-1-kaitao.cheng@linux.d=
ev/
>>>
>>> ---
>>>  mm/page_isolation.c | 19 +++++++++++++------
>>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
>>> index 7a9d631945a3..32ce8a7d9df3 100644
>>> --- a/mm/page_isolation.c
>>> +++ b/mm/page_isolation.c
>>> @@ -41,8 +41,14 @@ bool page_is_unmovable(struct zone *zone, struct pag=
e *page,
>>>  	 * We need not scan over tail pages because we don't
>>>  	 * handle each tail page individually in migration.
>>>  	 */
>>> -	if (PageHuge(page) || PageCompound(page)) {
>>> +	if (PageCompound(page)) {
>>>  		struct folio *folio =3D page_folio(page);
>>> +		unsigned long nr_pages, pfn;
>>> +		unsigned int order;
>>> +
>>> +		order =3D compound_order(&folio->page);
>>> +		if (order > MAX_FOLIO_ORDER)
>>> +			return true;
>>>
>>>  		if (folio_test_hugetlb(folio)) {
>>>  			struct hstate *h;
>>> @@ -54,15 +60,16 @@ bool page_is_unmovable(struct zone *zone, struct pa=
ge *page,
>>>  			 * The huge page may be freed so can not
>>>  			 * use folio_hstate() directly.
>>>  			 */
>>> -			h =3D size_to_hstate(folio_size(folio));
>>> -			if (h && !hugepage_migration_supported(h))
>>> +			h =3D size_to_hstate(PAGE_SIZE << order);
>>> +			if (!h || !hugepage_migration_supported(h))
>>>  				return true;
>>> -
>>> -		} else if (!folio_test_lru(folio)) {
>>> +		} else if (!PageLRU(page)) {
>>>  			return true;
>>>  		}
>>>
>>> -		*step =3D folio_nr_pages(folio) - folio_page_idx(folio, page);
>>> +		nr_pages =3D 1UL << order;
>>> +		pfn =3D page_to_pfn(page);
>>> +		*step =3D (pfn | (nr_pages - 1)) + 1 - pfn;
>>>  		return false;
>>>  	}
>>
>> LGTM. Thanks.
>>
>> Just a comment, order can be dropped and use
>> nr_pages =3D compound_nr(&folio->page) instead:
>> 1. order > MAX_FOLIO_ORDER -> nr_pages > MAX_FOLIO_NR_PAGES
>> 2. PAGE_SIZE << order -> PAGE_SIZE * nr_pages.
>> But it is not worth a new version.
>
> If we use compound_nr, we have to check for power-of-2, like
> scan_movable_pages(),  as folio_large_nr_pages() might use the per-comput=
ed
> value (which might read garbage).

The power-of-2 requirement comes from =E2=80=9Cpfn | (nr_pages - 1)=E2=80=
=9D, right?
Since otherwise the calculation is going to be bogus.

In terms of reading garbage from either compound_order() or compound_nr(),
the code might skip undesired pages. Neither is better.

For the sake of discussion, to use compound_nr(), we probably
can use *step =3D folio_pfn(folio) + nr_pages - page_to_pfn(page) instead.


Best Regards,
Yan, Zi

