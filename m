Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A629FCF8863
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DB596B0022; Thu, 20 Nov 2025 09:45:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3746B0023; Thu, 20 Nov 2025 09:45:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3F86B002A; Thu, 20 Nov 2025 09:45:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE3286B0022
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:45:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D76512DD77
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:45:27 +0000 (UTC)
X-FDA: 84131258694.29.B60083F
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012012.outbound.protection.outlook.com [40.107.209.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id A58BE40018
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:45:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qeGnJT+q;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763649924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5n+fdoQYwsWwDhz4wLUVZU95qwLeVfj7tA8i3zjqn4c=;
	b=MNPqz2oekN1HG9Tv77ITcChac7zANrA9RRJv9V8N61DBM0iHGE9C1zd6JhGXD7kuMRLlDZ
	l+Flcpc/6IuaDss6ueYyAO2875d+SB9oR8AQuZdZwyRoze90ohe2gELPoSgvil/MJzo/QI
	F9S8JAk28Cvqj456dNWJvNFAAp9hbJw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763649924; a=rsa-sha256;
	cv=pass;
	b=6eyFa+tQkhQ7ZBfqOuzqwDZmOkoXuiOvmvLrEhEiYh+9BrGBB6KlxG/RH1W4m/uv4tK2Dc
	ig8tKRcUz45B2+keA6/dKtwJDD21wP35TwQ7JomIKOJcMZLwC4G8mbHyXj9zHF4uzeut/H
	pE2PQmiIrZiVw4D0D+rNtadSHBt2zWI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qeGnJT+q;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wSJuU1ExZQ1LKm5s6nGeMCkQfVaztrJpoi+oN1MnrRsDucMB15jC28Je12Mwx6d3d60M/e3dtE0XxCe5EsgACR7YEDUg7XJ5Y1lIJ6Kbp/Ho1O1euoqXm1ddflQY3fhhbHJOwmnPbM1pjeXMuvseX43qM24oZjbE+kKdQGuvCacWKhkW4qQc0HBLo1BJgcZxegXf82d+B96w0MA1SsWkhctRP23aIDjhH3q8dMh6monwXcABYZ/L+bUr7KZrLL5seEiaC1i8FID9qhG8DWmVpC0AzpSji2DjeuRq+lWRoClwv13EUqsZ/5U1zlBlZ9Xr8hPVlrE9qkr9ljWNodGkuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5n+fdoQYwsWwDhz4wLUVZU95qwLeVfj7tA8i3zjqn4c=;
 b=QskYeo9yCmpQ2oNZZtNujPTJd2UD2IuIs9Yr/bCuyJc+6dYBqmmHvLNLT4elmVfoLLkjGA0dkHWz4dY58tEvuVRDhT0YgSryuQd20JJjGShIrQsmrocjera8vZOi2q5rINVfrxez0DeKRK0E1o8fLiidgc1L3POO7yEEaVa0qWKw8lpo1/xcuTAj6mB5C5Li5a9Z2977z287V7L+0Xp9ThmKq92Dhmc90ERDyDeI+iIHDEcEsxGVnZBeEKc2aeCS5iP+17YFCJ7Q2AwtDDZDdGZp4O8pNA/RkyiYlHNIVzk4NM7n0XdseGeShph+EA+tpt9BK4oEzqXHDXFF42FK8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5n+fdoQYwsWwDhz4wLUVZU95qwLeVfj7tA8i3zjqn4c=;
 b=qeGnJT+q3otyJp4TlyY+SfEcKVg7gbpEsC5OAghxRwjN7PoEth0VYuusR1MNsbE7SWFUb6exsHA3pcUh2NWnzS2niFkxNTZz+jif8tOaCZjqla34FIXWDPTuiEAozitXWqVEf/9oLwkCYZGduH6CnrnZV+mWpsrO8JSMVYpQy/oggarTc3Kp6T7X5ktGGdQ6P86RRS90udJzvn440tN59bSxK1JWeKnv43+V+L8T+RB5w7tTabhbZ3wc7UGHjKVxSoy0dXWlxuZRDl6tgZZQsgqXuXxodo4yr0bh67tBgpnfNuiZEnnoYtPsKC8kkAHycXJ/LguQuTytD2h0NGPHug==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB5837.namprd12.prod.outlook.com (2603:10b6:8:78::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.10; Thu, 20 Nov 2025 14:45:19 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 14:45:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] mm/huge_memory: prevent NULL pointer dereference
 in try_folio_split_to_order()
Date: Thu, 20 Nov 2025 09:45:16 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <D87B70D1-9A8C-48C4-8817-99F58F64F070@nvidia.com>
In-Reply-To: <010f0f19-8b87-4537-8c0b-bc8f9263aab4@nvidia.com>
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-2-ziy@nvidia.com>
 <010f0f19-8b87-4537-8c0b-bc8f9263aab4@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0228.namprd03.prod.outlook.com
 (2603:10b6:408:f8::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB5837:EE_
X-MS-Office365-Filtering-Correlation-Id: f23868ca-d901-4e8e-1297-08de28436d02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUVySXVUVHFVbkJpVk9Bd1BPSVFTQWtkMFY1T1VUZFkzZllBNkQ2eUZ5N09E?=
 =?utf-8?B?cyt3V3ZTSm14V2hHTnpVVmFLc0FqeTJMWFdreGYrOGtBbmFidDU2dmlPWG9Q?=
 =?utf-8?B?MjBtOWF0alA5Sm1xdVVNeUFVQUZvRjhDdjRIOG54eVNjcTg0emFDUTQyQmw1?=
 =?utf-8?B?OFFmN2FmWmZMSDd3L01NL000T1JJaEFIQ0p0VWVoTFdsekcveTdjUmUrTXFY?=
 =?utf-8?B?NjRtMS9lVDRZREFNTCswWUFxYm5Gb1E0bnBiU2c5Y21HNUljUUdWeW1Pei9l?=
 =?utf-8?B?QS90OXNvUnFSRGh2MDl3QTNqbHppdkVGNTJkam40NTF6VERrOHp0cm5TVHlv?=
 =?utf-8?B?N0lYc0tnTE1SZnhLQ2FxVU1NakgvODdWdDAzdVlmWlBnc3lkU290TERXQVFH?=
 =?utf-8?B?YVJ4T1h0NGJrZDRvdjY2YkpJQkRPQ3kvODFJNUpUY05CVUVXQmt0blBqakJ4?=
 =?utf-8?B?NDVJNytNU3dBckVYT2NoM28vOVB3U0lvb1lhQUt5RHJKZDFYSENvbFJCd0RV?=
 =?utf-8?B?S0pPRmhYMitDNzN2TTlrZFVIUWhQVlBoSDk1M2tiL3BVbVVYdXpqdVMvNW5r?=
 =?utf-8?B?TTlBb2Z0RWNIU3NHMWZWOXRRQmdyQjVjYVV0elU3NkVZQWVkOE1XS2pvalpB?=
 =?utf-8?B?M1orQytWWElxWjNxUk9iYVNNQjJvU3htSk9lVk96YTZvUnpRUEUvWjlrNHhJ?=
 =?utf-8?B?UWQ4QjlNeitoK29KbjQrZWxEbjU4MlhPb2JGTllUalVXbWxUeTdxRzRKSEZs?=
 =?utf-8?B?dVRCSk9SVVEvM05uRUF0bUh6MjgrektSWWM0bVV2N0dyTVhzMG44SzR4dUtW?=
 =?utf-8?B?Y2VqMTNNUGhnZGpEaHMyRlNtenBQMkEzM2xPcEZ3RHhGK3VBYTRtMU10SjA3?=
 =?utf-8?B?UitPa3NmUGRFdjZBbENnc0Vib29KWnlhVGg3bWkrK2VXQlRIb0FXQ24rYjhp?=
 =?utf-8?B?SlVOLzNTMzVCUWRVSnJRR2N5dFB2b2ZhOWl5c0VrV1FOV1ZZdkhwMSt1WGs3?=
 =?utf-8?B?eERCbTFpQ3BiL2hKWS91SURCQU9YWGdUMS8raTZ6OFNyRmFZd0F3N29ZTlpk?=
 =?utf-8?B?U29zdERGQ2ZTYmJqRzdsTS9KTVJXeDNhbGl1OGZlOXBHTlhnZFprcXd5KzBS?=
 =?utf-8?B?aXRPbHIyQmQySmFsUlRuSkF3T0tKbHNJWkROdUlJVzRNMEp2ZDdFOGhsWGdq?=
 =?utf-8?B?TmtOLzRLMjJLV0txbVFVN2VQVjhuUGRCaDB6M1p2RGF3RkVqMjdVS2JndnMr?=
 =?utf-8?B?K0dqZkNTQXQzVW84SlpYcjJiUmlUMzl6MXNsZlJmc1RiRlZGbTJjTEY2TUpZ?=
 =?utf-8?B?OE1XbDZFRE1qRm9iZHo0eXY3Z1Rqb1JoRkE4SVdEcWJGaWYrTkFlMEZrWHhn?=
 =?utf-8?B?akp3dWVhYk52UFMvSnNwZlFvSElOTlJ1RUtKYXhKbUVnQ2tHWXhBRjhZZGRS?=
 =?utf-8?B?MVFaVmVZUFd1Z0hmV1VaT09DbHpVRWNHWFk4bUNTRm00YnpsWDZJeUc1MHZK?=
 =?utf-8?B?U00zamloNUFYaUJWd21OM0diZ2R5NnpNNGY2bFhiYXVtVVNmVnk3RkprcFVE?=
 =?utf-8?B?WldOUlFkZUlYL0pXNjdDeG00Vlp6VDdUVTNtUVVLb0FDd2U0dm4wV3JIVHhv?=
 =?utf-8?B?RzZET0piTUZvVlhjZXJqdmVTL2RHK2FLa3dIR21BOXlxZlN2OXFNdHhlT01w?=
 =?utf-8?B?NFVlaXJmSXpjQWd6dkpkTGFKK1I5czhaaXlKNVJualNPQ0VwcEMwNkR2a1NF?=
 =?utf-8?B?S001NHB0SERFNmFReUtHbUFlckpnVVNGb202bTY5MHRucWZVaDlUcXFBbFhN?=
 =?utf-8?B?S1hXVFl1NXBXTFE3TXdZYVp6QmJ6QklNcC9VV2ltWmo0RTBQMUx1Q0dOUXpR?=
 =?utf-8?B?MXhRYldpaW8zQk5maGRkL1V2VzczSGpmdmVYM1FTc3dobjN5MjlWeVBXcWEw?=
 =?utf-8?B?bWZ5ekZxV0pSQXljRlVVbDgwTEd2dEozVUdQMnRoRmRhZDNLZkEvRmw3T2lu?=
 =?utf-8?B?U1RGTnpwQ0JRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHE3YUsxSG5sMmR4WTdTdGQ5bU9pdHhVdlUwUEdDMzFrUC9rSzZvTVlXYU5l?=
 =?utf-8?B?RnBCY0lCUURteFg2TnlsbUJKTGNIOGdVMGRQUm5JTkwvVzdTSzBDZDkxWGU5?=
 =?utf-8?B?U1dtcGpRVjUyNE1Fb200MjdiT055VVRGd0VhdHZEempYNkw5Z0Nid1VQemhS?=
 =?utf-8?B?Nk55SENzdmtjcmUxQVlFckQ3Y1ptenZtRzJPSjlyNnNTWGdUVkthM1FoZ1Ra?=
 =?utf-8?B?UnNzV1VVUW1wQklPUTVsUWF5R0pDL0RMZXgwZ1lBOFhrUEJSNWRPSTNlK0NW?=
 =?utf-8?B?VlpBSXBOaTZxUUpxeW1XOVNUb1NITDFtZ2h5QWVWcm5DOTNSaE5IRXhBVi8r?=
 =?utf-8?B?eU9va2tPTnZiekdaUTVRSkZSVG9tV0wwQnJDbmpNcnFwOEpvVDJ6cXlqc3Q1?=
 =?utf-8?B?TjVJT05xMm1SWmRmZ052QXQycnZ2UXdHblFreHNqbERkYzRLSjBLdlRNRjhl?=
 =?utf-8?B?am5Rc0FsbmlJbGgrRHAvMFBuWXpubC9lQlNOdFU2ZFlDNUY2RE40eW5XWEFH?=
 =?utf-8?B?NDZCV2tJNC9yTGpVcGNpNit3V0d5Uk9OVko2c3BCUnViMFU2UkU5ek1Xb0o4?=
 =?utf-8?B?emtCdWtmb0JHUTB1MVZjYnpiMDUycE4vRjFWSlZBSWg4Smo1Y1o2dkkzZnZO?=
 =?utf-8?B?TEhVQzV5M1E5Y0c5UEt4aGZSN2IvNTQ4V1VFdTNKSEZNTGpkRUJuUXR4elBM?=
 =?utf-8?B?NVdldDRjYnBNWkM5MlhiblcySzJUSjB2dkZyWHhHSlVRZ1FJWU9PaTFiZFdo?=
 =?utf-8?B?L2gvKzZORHN5WVNtYjJnTDdkVEIrQTJWVlkrUFNWWjFPL2ZiUG9pb0JwaXcw?=
 =?utf-8?B?aHhMWXo0c25nUnl0WEJWeHVtLzc4ZkU0dDUvSFdLWWp1cURFT3dHY0NGMlUw?=
 =?utf-8?B?eElFV1pxNkxuOHVubzl5VEVFbXI0MFFQYVdHbmRBeHJ4cWJQM1E0QitCWEtr?=
 =?utf-8?B?eFNnOG1QaDg4Y3J6NGNVNmo4SnVLUTgzQmM4bC9zcGpNZzdwcWp3L0JrV0or?=
 =?utf-8?B?SzVwaElvdXZ0NUpRRnZ6d25hcDQvSlluM1kxWU1ValIxOVpqcTd3VXRYOGNj?=
 =?utf-8?B?bWpkM2hxRXRuOTRPVmNjZi92TWFtMDhDSXBWWWNiY01MVERNMVo2bnZXUVhP?=
 =?utf-8?B?MFdmejBaZFpzdndlbGhGMDUzVzBrNW9yTktnK1BIbHdCK2NMbmMyRmVQd0Rz?=
 =?utf-8?B?RUwxSk1IRFc2Undva3JnM2tmaGVJclZLOGZwYkxtcEliR0MwaFlRTGRxeU9x?=
 =?utf-8?B?SWdRMjhKejFjNHdoeUNtTDZSenZFNWU3SkR6d2gydUR6ZUJuWDRNSzYxcE0r?=
 =?utf-8?B?QXJWemlaTGc4YjVpanJIRTkxaExGcHh2N3NSdmtqMENxZXdyd0ZsVHh6WXlr?=
 =?utf-8?B?ZDNvY3hPaHNzRGgvM1pLVTNTVTNTV3BEUUxsc3QySnhGKzF4b1dPQzhUNkU5?=
 =?utf-8?B?ZEcxNXRJbVJhTEF6UEJtNnRzU0pSL0NKamdnYlYwY3UzQi9Jcjk3MmprTjBI?=
 =?utf-8?B?UXJ2Zng1a1NGVGoxNUd3bnFDYWZPUlFZUFFpRmtjdCtrMGR6QnRSN25mMncv?=
 =?utf-8?B?NWtTK1NUalFqU3VwYlArWHRTZk1nOWVKTFZsbDkwYS9VMHhsTk5jZmpBZHlw?=
 =?utf-8?B?bnhXR0tmdXIvVVUvaE9iTVFCQVZyR21aK1IzOHl2SXlyOFZNSmw3OEtqdFBh?=
 =?utf-8?B?bjlkOUNIdlZndGRwenFBK2NNZmRtVGszZWcyb2hmYysreHFhM3NqdkNlb21u?=
 =?utf-8?B?WDF2cU83Uzd5SjNlVElTTE1HTkFpZFExUU5GVTk2SEE5NVV4SHpNU25RdXRW?=
 =?utf-8?B?TjhZT2pFNnBVZUMwRkh1anhDOUZ0aW5uWUlUUHFEWkE3OVZIa1dDOXhFMkhU?=
 =?utf-8?B?MHVTYlVHNHFPS2pDVDhtOCtCeVUwMHBmVDNacUV5S1JNQm1KNDk5UlVrVW5u?=
 =?utf-8?B?U3BjL2hMMFdTNktyNmxucDNzV2tIY1hZZ3N2ajgyMGFwVEI4enhud2F0VW1S?=
 =?utf-8?B?ODkwazJpbTdQM0R5OHlabzhJSTVQNTF5YUJuZjVBYjNMWU5HYVN4TUs0K1VC?=
 =?utf-8?B?bjNNT1hsSGc2dXRWK2dTODJQSlpIbDZXOElyREo4MkltNGlZZE1DL3hGZ1lI?=
 =?utf-8?Q?srEvwi2PcoG7L1/rVMYhh/Dzm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f23868ca-d901-4e8e-1297-08de28436d02
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 14:45:19.1538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1GMWFikmwuMrufYFjpG2mqA6gJYnC24rfF8w9Bwd0KeZcl338t12B27RVUgCl0e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5837
X-Stat-Signature: 6fexirs67yxu8cbn3gd9nbjkfwfy9e55
X-Rspam-User: 
X-Rspamd-Queue-Id: A58BE40018
X-Rspamd-Server: rspam10
X-HE-Tag: 1763649924-488986
X-HE-Meta: U2FsdGVkX1/b8DTFoRaYcQu7ApVJu/w3xGypsW4SvpV/QjRVwTZAZCGFUB8G0oMjB7tm/0BgH1pXGuJ5mLw+DlwsHiBvHQ8FKzrAW2wfIygolSXOVGe5eNoy+0RoH08WpPYFtz0U+/wWkT5iZati/fz9+tAHNq5I7b7aICaufQY7HbTpIwbLy++PzlGMAVmojR68R7xc+PjFWDRan6R957Eq9MxWYJj6ln1fpVvwaBjbt3JEPEt/x2P9VNAk0hyQ4Cj6kX+WQFQyboHTYQxYHKBGyxFCWZfIEvZV/oxk4vNARRJ+em80uyq1eIZjij25vbKAOaYqulmtcUnNYAjzbSaPaeA7Y6zFqy1owQ+bPtzth4bKPSB+tSkbCfFEJgI38je8faLcAEg5sVKygS7U3vdXSi0O2bqmivkmlkokYDGQFDHc95ayIcyMvNA97Nr8siT/Rh4TdPPvEDa+TVR/q2ZB1qPgdoxuFSXzWauIiFs/vFIYlmwAp78hh3XToh/I65WZ1pvTOzqGprrttFIWbRuq1VfU7r5QlYuLZjw9uiAy0uZbvEN6+D7Z8AQXXEThR98OZrFiVFD4iFhVPeyMnDDTac3BkgF/tBk5hUFkco0m2Ectjjh9gh5stijVPrNDsfWj3xjGGwciUcYTCcxwEIlZDvsRmm8oBZva7Z2YtoCd7KMzgxstOm2hbzrZrHjf9s9MSVjRXU+lRmfngm3tc+tiaV2clSkqe/gcT/n+yADAwdKwGRjtohIvXqCEqqm5auIi6S/Ba9TcnqC6a+HqylBTxRr5O/41BrXNBtavltHpRQVcKW6Bo9q2n62Qsd4bmJmftewWQEvJ6ulcufenWmULlARxfWy8+aY7R6ouUPNrGpmSI030r0nv/UuumnQyzqFqF3wO/m8YdK2itarLm/+auUU4rUMJlL3bieb+hrajaozSSr3YKGdFgaeXnDmze+zGW60fGpWho4lqQF9
 xKclQJH9
 I533qq0x3AY84rvRt7SU/gewfaDMcYATAw9zchZ/ENYTL6itlQ6QPnlgpsqM4BlxL0I6IChZtPaa8JMKRx8wj0oVKvw1Jhog1mlQ9KdhZYctMHHh8vLFTT5vpsr4riQJ9Z1t4GqD9lsbMiJguo8vo5T5H4tmzNgNHbo7WM9Veeb7UB+bSaWEIPxCw5CxcmiwYaTFIkofvaRHpiKnc0utcr7BGoT0wYfvxhUtWAi3sqHENACr+0+OwvI/KAN365BxEMDM274jtbqsOSLGDgelkc4BVhFGjYEYSjic1jD+BHt6uhA3YpW0C5gbJEfV/ezNNbbF+4463OqYlfCwVC3Web6i50Ao3c2iAU0yAiktoCJcEv55V108Gn92qNPVMF+QG+eSYXh1MNE+JFK0DzkZSR/y+Egf0NILxbJ/wZqX6mTagcgGdBT+A85aVH9YMPSqqjLHn2ULVlEwv3XwSdqt8Me/7gvc4dx/yhiFQjL57sWeNH5Le+7GF0pdTHCT+gHr0HehcQnPxHsl86bx7uuaJzcgtR6LB3v2vHFio
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Nov 2025, at 23:28, Balbir Singh wrote:

> On 11/20/25 14:59, Zi Yan wrote:
>> folio_split_supported() used in try_folio_split_to_order() requires
>> folio->mapping to be non NULL, but current try_folio_split_to_order() do=
es
>> not check it. Add the check to prevent NULL pointer dereference.
>>
>> There is no issue in the current code, since try_folio_split_to_order() =
is
>> only used in truncate_inode_partial_folio(), where folio->mapping is not
>> NULL.
>>
>
> Just reading through the description does not clarify one thing
>
> What is the race between just truncated and trying to split them - is the=
re a common lock
> that needs to be held? Is it the subsequent call in truncate_inode_partia=
l_folio()
> that causes the race?
>
> IOW, if a folio is not anonymous and does not have a mapping, how is it
> being passed to this function?

Quote David=E2=80=99s explanation[1] (note: shmem is not anonymous):

vmscan triggers shmem_writeout() after unmapping the folio and after making
sure that there are no unexpected folio references.

shmem_writeout() will do the shmem_delete_from_page_cache() where we set
folio->mapping =3D NULL.

So anything walking the page tables (like s390x) could never find it.


Such shmem folios really cannot get split right now until we either
reclaimed them (-> freed) or until shmem_swapin_folio() re-obtained them
from the swapcache to re-add them to the swapcache through
shmem_add_to_page_cache().

[1] https://lore.kernel.org/all/14253d62-0a85-4f61-aed6-72da17bcef77@kernel=
.org/
>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  include/linux/huge_mm.h | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 1d439de1ca2c..0d55354e3a34 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -407,6 +407,13 @@ static inline int split_huge_page_to_order(struct p=
age *page, unsigned int new_o
>>  static inline int try_folio_split_to_order(struct folio *folio,
>>  		struct page *page, unsigned int new_order)
>>  {
>> +	/*
>> +	 * Folios that just got truncated cannot get split. Signal to the
>> +	 * caller that there was a race.
>> +	 */
>> +	if (!folio_test_anon(folio) && !folio->mapping)
>> +		return -EBUSY;
>> +
>>  	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /=
* warns=3D */ false))
>>  		return split_huge_page_to_order(&folio->page, new_order);
>>  	return folio_split(folio, new_order, page, NULL);


Best Regards,
Yan, Zi

