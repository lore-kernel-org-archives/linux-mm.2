Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6085BCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB258E0003; Tue, 21 Oct 2025 12:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99AEC8E0002; Tue, 21 Oct 2025 12:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C1C8E0003; Tue, 21 Oct 2025 12:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71E598E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:56:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E7EA160648
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:56:38 +0000 (UTC)
X-FDA: 84022725276.22.B749E26
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010012.outbound.protection.outlook.com [40.93.198.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3B01B40011
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:56:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dbv3aZJq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.198.12 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761065795; a=rsa-sha256;
	cv=pass;
	b=Rp1zMctL7qIj2oS1idR20M8c4bzqvrIpf0+wIA43kWcej72zEJBzO/oTWz2TNYMOpp/Fd/
	c8u2xAr2APkWydjcAtiqLWPs322lP100iaaspotBogBrjxhPeyrb4tEg7KgE7emjqFJaJg
	OWnn7mRhxGFi0BeGX6L0L9/HDSG2+Xk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dbv3aZJq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.198.12 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761065795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfSQ3KYN9Svf1LKsvKaupMe2fIDEPd1NzoMitly2NLo=;
	b=rlol5XsOpqsa5t6d9/RXim8HV4zksrQkt96eD75NA4mGFs9MaLJMmEz7cW0p2vnnya8F4E
	93lYA8hakFFBHNc8aWZNvZ6plXU5B5QsPNec7+SDqnGBbTAomub0k0dgksrUciU6eVgJ2X
	3P/Em/wGSaSBFU8wfv1pxRgvKnlveYU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=reu1C2uy6kIyKVc4heu9vrqR2u9yFdquwruHHLqIa5x6Fl8EGpIDMNuahXFa8W/MRhFWKaZ70yZhcxmax1jhBcqYp4yoWoZSa7rD3rC9pLyMi6zCf5mLYuhSP6dDwCc5SjTEHrka56Ysc0aNLelD6RqWy/RkMkJ9JN3nFkze3bnjbUgU/UGnv89BZFcmpHYc5NTCI7272cnbhv6S9qTt/Y/MBdvcK/4pcagXeJ+QErjJBVoWLYUbwkxtKWAZ+hHDJFqp7uMz/+wbYttwlGVGWd08e6qS2T7oqv4L2ChJ8pyR6pXQkU4przki1aatKlFxgQ0C7wN2upA23ZEky4ge3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rfSQ3KYN9Svf1LKsvKaupMe2fIDEPd1NzoMitly2NLo=;
 b=vrFe2qpNNE7yFmItc8XpZ23TOrxPRKut0P10DYsWU8S9Td8JMUfh+JHIkR0GkN91zJheykRKmBLxG+ZMugRCMWVBPEpMyp4gBkf7l9O34+Xk32THU3ZHeVqywH/9VQb7llVlQHrPcSltMzEkAcqUqFdwOYgnXgyYDQiP9kR6zi1NKNupdiphjBpB/yso630u7srx4z7g7tyn++8VWizL3dpcv76XE20ha5P2Xf9qfRxV2H2vV7nBw5zOijFFD9VbIBE3JCzuvAYvmyUrj/FNRvpd6gzEa3gae2wmdVekQ5nIv84gLKrXljOeUXDPGgurVprRFXFvh1T/1jY+YPvXIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfSQ3KYN9Svf1LKsvKaupMe2fIDEPd1NzoMitly2NLo=;
 b=dbv3aZJqGoeDC6dVhryGHf5VMFhMC/bZ1SnnfnKAkV4rzc62rT5jh9L6vjs4IOgbntfCb3sxfm7Hnv6r9cvohOI+LARkjaTu/RXjcXGAt5SwmvohG2Z1ijdkNXPnh5FiYszLItFZtU+eiXAn3k/ikRi3k8aJDGW+l9S5rG5gZ5SYyycjIjM4+dGRgvfFErRRuyEv1fSeLh0YCObmVmHfxrAiXbtEP075O9x6hq1cmRiGFMjTTBlbDJsEzfyUQGgNTh4qmCLGKLWlDMp1UCNgdn5M+xqIt537PIb5rA+k3RVjVxl1wvx4Cet4nCT+vs34ZTM+gH0IZGinqa32PBKPPw==
Received: from BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13)
 by DS0PR12MB8269.namprd12.prod.outlook.com (2603:10b6:8:fd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 16:56:32 +0000
Received: from BY5PR12MB4116.namprd12.prod.outlook.com
 ([fe80::81b6:1af8:921b:3fb4]) by BY5PR12MB4116.namprd12.prod.outlook.com
 ([fe80::81b6:1af8:921b:3fb4%4]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 16:56:32 +0000
Message-ID: <b4ee24a3-0706-47aa-b2ad-0f60f90793ee@nvidia.com>
Date: Tue, 21 Oct 2025 09:56:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
 Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
 <a1cffdbd-ba98-4e24-bbb6-298eba40a11e@nvidia.com>
 <6hedspdzoxjtdim7nruoeh5m4mx3xecubf7einzl67jzjmi3er@o54b7v5njwk5>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <6hedspdzoxjtdim7nruoeh5m4mx3xecubf7einzl67jzjmi3er@o54b7v5njwk5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::6) To BY5PR12MB4116.namprd12.prod.outlook.com
 (2603:10b6:a03:210::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4116:EE_|DS0PR12MB8269:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b08a5f0-b3ab-4acc-dfce-08de10c2c959
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aUo0d1hUOHRWbmJNR2ZQM1F0OTZseUVNV016MVRtZkFlME03bkhiNlhxYUxM?=
 =?utf-8?B?TnptQ1c3dGVLNE52U1RJd01kTVBNMW0wWHdDK0lRWVdjcmw1OUpqS0NlRm1i?=
 =?utf-8?B?WmI4aFMxRmV1cUlRekN2OElsdnJQNTFpTUlMM2FzaDB1TjErMk5uS1ptYVB3?=
 =?utf-8?B?elc3dmhacHlMV1RVTDJxU0tRd1MvbStvVmkxdGNCVUFJekd0RWVKenlIdDdm?=
 =?utf-8?B?T3BpTWpPajF4VllRaGw1eDRNRWYrbjJxUnllVEpycHhXY3NtY0Y5ajJ6UUho?=
 =?utf-8?B?dHliVW9CTUh0RnZEcXI1bGphbGsxZy9BMW5lN0MveVEzK05STDZnTlh0UVVx?=
 =?utf-8?B?R29ERDhpRzhIR1VxbHByRTNjRDNSZE1INVJuaWZGY2pFYVFXaGU5M2lhejha?=
 =?utf-8?B?MTgrd3FrV00xRmoyZVlLQ3JMa2ZCbExGVTlHMkRmeU1CTGVDbFpLM2dYSjZa?=
 =?utf-8?B?dFRqcUdnU1RBaTY4dmhlbEJMelVlN2JRSGZBenBXZGRCQmhnbC9tYWgxbHkr?=
 =?utf-8?B?MVJSdTdNRHJVVUkzQ2VzSFh3NWtFRHk0dWREd2JiSjVnSmg0eEFpblZ5ZzJv?=
 =?utf-8?B?M1dMMUFXaDZZa2JUMlRGRDN2UmpKeityK2hXQnFwK095enlxYmIrb2pWYkt3?=
 =?utf-8?B?eEU4dWRZaXpnZ2xoUHhNQ0t2Vmh0SjFob0xCOUpsL28xQ1JsaCtSU2tTbjJV?=
 =?utf-8?B?ZGY0cmVmNHpORFFSVHgxY0hPZHJOSFFqNG52dXg5Y1puVVFJTFVybVV5ZzRt?=
 =?utf-8?B?VVlla0JJMlZMbWo2T1J4M1IydXlMUUx5bUhXdHZtbE1tbmxsR09zbytBSkJM?=
 =?utf-8?B?YUVmZ2l3MGVDT3h3UTBWbHVGaFBieDFMRE1yMEErNlFQZFN3QzEyYnN3RDA2?=
 =?utf-8?B?K2xTY2gyNzRqc2ZudnE4eEpJYVhxREtRU3NLc0E0UzV0QnBwMXllMTY0Z2tM?=
 =?utf-8?B?YS8xQmJaQ2lVUlZjc3FvYUJaNUNKRVlCUFhieGhlNG0xNzRvSWpNTHFTdmtu?=
 =?utf-8?B?OUZGR0x4QjNpKzZWV21rWFBBK2hyNE9EQnMrWk14U3lHWndKSWJOT0ozMEFH?=
 =?utf-8?B?d2l2OVhwTitqVmtxUTUxZmZFY1Q0bCtvbCtzTnFhbWtkTXFYcnFacnYwVjVi?=
 =?utf-8?B?ZlZyQ2ZhWnVVTDQxYU11U1ZrR0ZqK0ZFK2hWZWIwN29GZm5OSGZIL0tEQmxl?=
 =?utf-8?B?SmJaSS9ucVAwNFUyeERuWUpDUzhGZmZJYlFOWHNkRzFuVCt2aUFVbDA3TjZN?=
 =?utf-8?B?TTBoQUM5WGpPSFJ5SlBBM2VMSWtHak04em5ZekpQblI4WGl5VDREYlNHVjVM?=
 =?utf-8?B?NkNEaVFCdzdlQTFJMGtKc1NtQVZSbGd3RHN0aUhPZlJ5T1BmVGp6Z2pIc2s0?=
 =?utf-8?B?WTNvMWovVEZYbGxtUUlXVmhqRmpXT2V1M2lJVXo4WVo5TXRXZDR6R0sydjNB?=
 =?utf-8?B?V0RrRHhBRnlKemtXTHYwaEVzSElkQ3hhSEhtVUNJdzkyVmVEOWw2Z2dTZ29P?=
 =?utf-8?B?WW5zVkg3NjYvZkVwcmM0dGlPdE9nQllUMFhwTDBndk5Wd05ESmtJMmZXVzFY?=
 =?utf-8?B?eGQ2SFlBeEhaUFBxOFhtb2VNbEpnNlkzMTBJUW9rUStyZVJnZVM3UWNDZWhJ?=
 =?utf-8?B?Zk5BMitQSzZKNUhrM3NZVkthZGlRQTQ5ZUVFeEpaZFVBc1JTejB2OWFwYmdn?=
 =?utf-8?B?L3dyZTV6b1F3eVZNbnJlTG40bFRkUlplN1JaV2lCdmxZaDlBeXovWTAyeVBD?=
 =?utf-8?B?NkFWZUoyeHc3c1Q2bXZBNTJQRlVDOGh3N2hsSFA5YXprbTNZcnFRVDlLWkc1?=
 =?utf-8?B?NlMzNVJVUWhZZjFxbDFEd0wwRWt6aFkxbTc0d3hXbVhaY2krQWR2WVdvc1NE?=
 =?utf-8?B?b1VEQVBKNDJaVkRzSFc3WkFtdmVVaDRZN2ZGdkhnZjJiSjBuV1VlUDY4aXhx?=
 =?utf-8?Q?UTkZ57GqhLeDGXgAysbguHFPcFyl8AFP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4116.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXI1cFVLTVpqQmRtbmVLYmdxbFZJRHFOd2lidCs3Mm5BelRvT3c0bndMczNB?=
 =?utf-8?B?L3dDNjlwakZYUGdzUmFQeVluTUw2clFyOXdOTUlsQ3VWSTZVNFEyeFZDcnYw?=
 =?utf-8?B?YVNva2RQVE5PaTJ5LzE1QXVUcEhFMWVNdU5WYVV5Y253T2VmMVA3ZzJPUDRx?=
 =?utf-8?B?Q1RpbVVqR2ZvbFRRZ1RzcWdPMTFCdlFuSkJ5TDlvamFiZnNjNTRwSHo4SndK?=
 =?utf-8?B?N1gxS2owTHM0anhGVngwQStTcUxwTWoxUUI5V3dIMDVPdE03c0Ftc2QzdnE5?=
 =?utf-8?B?MUtWaXlSVFFySTdwdXhaemlGdGdzbVUxTzREWmd3WGlzaE5oVlZDODVPaFg3?=
 =?utf-8?B?SHhiUmF2aktJR2FreGJHNzI3ZmJOOXJYSnF0Q2N3QnRxK2I5djNuR3o3eW9F?=
 =?utf-8?B?NkJYNXhHUC9TV3RIbFRwU1p4WHUzKy9FS3pVek9jTDZmb2Y5OE5wNmp1TlhQ?=
 =?utf-8?B?djdBQmdaOVpLbDVObW5MOGpBZnlrZWE5UWRkWVFCZlcxbWJva3RxUFJSNGQw?=
 =?utf-8?B?aENaUWZhMEhpQlpZRU5IWTZseHFpZGdTYTMycGo1WEQvVDFDaXh1b0ZibVFT?=
 =?utf-8?B?ZnBoeUhIMEg2czE1ZkFtZ1BlZjZHQU9JeUVQTnZmNm5mblpKR1RFQW9rcm9G?=
 =?utf-8?B?RnhOdlpFTzBJVmZkd1VUL2RMc2dZR3k5ZTZSN3gydHhLbXdxSXRIL0JqL1lz?=
 =?utf-8?B?YVRLSXZnWlhGa3RZZTlvaXhZNE10aTRCOVpBQTIvdzQvZnVET0w0S3hSbzJQ?=
 =?utf-8?B?T2ttZTNuSThTYkxhbGIwRnl1Q25JUThYOU9EcEQ1cm1odmc2N0pmLzVUbVRu?=
 =?utf-8?B?Q3ZMbTVGY1ZiZHhSWCtWSnI4dVdIMUl4MjZPcDlXanJyUUtpaXdZcTVIaWsv?=
 =?utf-8?B?Y0dUcHcrQjZvRHFESXJiOElOK2Z4QVRqNzlkVVJFTHpCVURWcUJNV3dXQjZy?=
 =?utf-8?B?cWFIcVVZa0lxV2lZbjVoajkwV2hzZmdJcFFZTTU5S09lejM2T2QvMzV2cWhB?=
 =?utf-8?B?VlNuOFlCT2lYa05rKzhVVitJbHF3dGo2KzdweU8yRW1yMEZ4Ujk2NWw4MUxQ?=
 =?utf-8?B?bmlrSGRQem9jdjZQZ2oxdTdReVo5QmdkdXM2SmI5czU3SEZkc2swUWlkZGFa?=
 =?utf-8?B?WElDeE5FQzJOUnhDa1dSaTVtOUlBdU9oWW9PYTVOUk9DK01haGVLc0xNd1h5?=
 =?utf-8?B?ZXJ5aWVadEFkV0VBWEY4aEM2NkNWOXNNMk1xZ0sxTTkvaGFPejR3bDRpZFRE?=
 =?utf-8?B?NlFKM0MwdHcydmlFL1ZIYlcrYW5wWmdDRGQ2SXduR3JpcWZJUU1SWmNWbUEz?=
 =?utf-8?B?K3JNREUzY2p6SGszOVkvRlU4WVVqeUdkclRpTUV3Nm1VaUVoN2RhNWcwVG1h?=
 =?utf-8?B?MHVnY2dsNDNoeTZERG9veU82N3JacDlDWE1OZThacThHQVZIWC9yTUFHOTVF?=
 =?utf-8?B?TmI0Znc0c0xzc2gwbkEzU1RDTU5OWXZOWExjZHF1Qmo4WmplR2dXeWZUa2tM?=
 =?utf-8?B?VDNpck9HenFxZ1l6Zk43SFRkTnc3a1E1YWE1TWVYL0Ixa1Rna09qaHBTMUFv?=
 =?utf-8?B?Sm5TczNrem1oeXlkTDdvV0QzVVpTaWtZc3BHN3pacW41T1Y0U2t0bGJJbEx4?=
 =?utf-8?B?TkI4NytlR2dKbmhGMktETjcwaVV2ZEZ4M0J6YjhyN2xCRlovNjIwSjF6S0hY?=
 =?utf-8?B?TDR0NjNwdDBEOVJjTE9aRmx2NXNaa2Zzb2lRV2srTlNvQU44elJ4S1dVYkg5?=
 =?utf-8?B?UWtHZ0pDbEdVL3NmSUY2d0xYTk5iaE5TQWd0c0wyYzRKKzJGSnUyQW5HM0s1?=
 =?utf-8?B?L3c1MHlWb0t5NzE4SG4wM2pTUzZ6aWxpWXJQRDhPc25MSDJuVzBab0JkUzlL?=
 =?utf-8?B?UlFaQkoxQk1uUmNicXpSZzJVRlkxRGpscVBlbmFGMDhkVVFtT0xTMjYxS3h0?=
 =?utf-8?B?cXZJanlrUWZzNzBHWjVSRDVZYlk4VlBzR1VtYW10ZWQzRjZtUmJWVnZBazlP?=
 =?utf-8?B?dXExZkRabC8zUTdLYUVaSHNleW9mcHV3T2NGYlRnTDNMak5tTlVwZllOYUJj?=
 =?utf-8?B?L05GcXEzMWdvYkZlVEYvZHRmYlNlV0hTdmo5c24xTTZmcTEva3lGMktCMmx2?=
 =?utf-8?Q?GnC5mC3zrtmN9CRWeiDR2VTLh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b08a5f0-b3ab-4acc-dfce-08de10c2c959
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4116.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 16:56:32.2490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zArwNjirOciO0eme4YIyrrByAyT06FwRoqTpfINiW3KQR2jUwUuVtf0DWd9irBxQrGqSdlmP+Bh8jtmfekKGmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8269
X-Rspam-User: 
X-Stat-Signature: aoun9txkjryhfy9x6t65zk5e6pi3kp4j
X-Rspamd-Queue-Id: 3B01B40011
X-Rspamd-Server: rspam09
X-HE-Tag: 1761065795-347860
X-HE-Meta: U2FsdGVkX19ljcJi4xF2g6PqgMOpKw8McScd7G4OpaKef5c0ckrgdLY39ek8oJSiapn5g2Z88k3ICfKygaF1GDCgUJ//E9kLJRBjJU0Do0JQLvOEKSuDq16S9OoFeYfUXu8/y9AHhI1CpBGfP9kkcblfe5H9DUPc1gpcgE/LXF5oMvqmsAGt1YBa/IlXLsy18AjzpnrX4rNZ4fXKfu1rFpUXTqUCLh2+b/47VCHDc7UhN6hXLNNkn7sBnE/Cx7BrldG3Lfc+Dj3IL9V57n7tl1up8RhSKh9iwjBZr/+/hRnbw+OegijrAHpPjKBJtk5toneVAwdoy38Fvz9uV4QssSGtfsKOVZ9/+TuEhn3VImDdK3Am6iQISNm0kZdsPQ8xf/RE1e3U+yaXgMGSbgy40aGun4Dbxs6uWuLoUJZJ9sD+F7+T8aDwUro75sJOz8tWV1U9dQpLGb55bLOpJFXBqVFC0cAeFBxZ33KZFVxvd7uElxfe/DnBLk1vm7OIMn7Wz/PXoRM0wilPLR7nKKLvctgvixaiazjsLs0p4F0dmSktNHKGT3L0Bl9TjsF4fpmZXoty1Ptf08r/Dk4QxH8+tY6jNv/bMbuZ03kG3xjbDvEBrqB8iiX76Gjp5EvR0Bk4xUdyy5OOAOR0KAGrUYWJkEogu+xb5qAX1O90IuqC7UlVukIslzCJ+TRK4q38XiSemDZZb81dm+ZF4VCKcSEwK4a0YdVw6Yp93odjZyLlreg8Ju7n4OgxmWQR6RgxNOIZOR9RXXG+jQPQKpUztSf31ONPg27rcaOT/yBVx6pQGbSWfQ2Wv5kyi29+fet+3UtyNjTLH9AN5RRFsXolcRBiFt2NQHPmlszofd/24Vgs2L1A8pGw09xa+SLygkTTnjoYHqygN31NBEkpj8xcNwhKK+l/l9lISqK8J29NiRnycSEb6okJnTfWqWKV8xSvuCwzolrOGxbA+FlYUyMHN13
 /OFrURHw
 u4eaVv32QXdUXgga2qNx/j6WXq2tpD2Yqbj9JWatt0DqM7/A5s+MgZhPrJ4vYwDwjmmbxi2CeBiymiqx37HYjwJDLXZlYzTwoJ2ByhK5i5LHiwW4h0mvfr48bAwuT0/1NdRi/6Z6aaulQDb+Wnf23YEODvQyHAynx5v1Hv70Assk2Z9deAMNvWXaLrOEoM3r1W11gCpqkWAhSwTTQ05dqorcDds7CCFOzIITTDDWmu1/k75TCsjqGOoTLZEML2kZgTNZYzFzeYVIrN9TdNXj5v33gFWeCD2s1AwcXWHfDmZjia0LDjSfoMBEiGf/tAxDQkoWxGraXPy/GUNKg54ThyhfCRNM8HX/D78KEvEbWXuARdAUzFc1OniqfmJy64NuoU8i9kK3eZCpKDLwrdMfSsVLafeEVc2AWQ6OJrXetE+N9cDg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/21/25 1:27 AM, Jan Kara wrote:
> On Mon 20-10-25 10:55:06, John Hubbard wrote:
>> On 10/20/25 8:58 AM, Jan Kara wrote:
>>> On Mon 20-10-25 15:59:07, Matthew Wilcox wrote:
>>>> On Mon, Oct 20, 2025 at 03:59:33PM +0200, Jan Kara wrote:
>>>>> The idea was to bounce buffer the page we are writing back in case we spot
>>>>> a long-term pin we cannot just wait for - hence bouncing should be rare.
>>>>> But in this more general setting it is challenging to not bounce buffer for
>>>>> every IO (in which case you'd be basically at performance of RWF_DONTCACHE
>>>>> IO or perhaps worse so why bother?). Essentially if you hand out the real
>>>>> page underlying the buffer for the IO, all other attemps to do IO to that
>>>>> page have to block - bouncing is no longer an option because even with
>>>>> bouncing the second IO we could still corrupt data of the first IO once we
>>>>> copy to the final buffer. And if we'd block waiting for the first IO to
>>>>> complete, userspace could construct deadlock cycles - like racing IO to
>>>>> pages A, B with IO to pages B, A. So far I'm not sure about a sane way out
>>>>> of this...
>>>>
>>>> There isn't one.  We might have DMA-mapped this page earlier, and so a
>>>> device could write to it at any time.  Even if we remove PTE write
>>>> permissions ...
>>>
>>> True but writes through DMA to the page are guarded by holding a page pin
>>> these days so we could in theory block getting another page pin or mapping
>>
>> Do you mean, "setting up to do DMA is guarded by holding a FOLL_LONGTERM
>> page pin"? Or something else (that's new to me)?
> 
> I meant to say that users that end up setting up DMA to a page also hold a
> page pin (either longterm for RDMA and similar users or shortterm for
> direct IO). Do you disagree?
> 
> 								Honza

Completely agree. I see what you have in mind now. I was hung up on
the "page pins won't prevent DMA from happening, once it is set up"
point, but your idea is to detect that that is already set up, and
make decisions from there...that part I get now.


thanks,
-- 
John Hubbard


