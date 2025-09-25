Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0567ACAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 14:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5FF8E000F; Thu, 25 Sep 2025 10:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567778E0006; Thu, 25 Sep 2025 10:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42EB98E000F; Thu, 25 Sep 2025 10:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9018E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:24:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB14358207
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:24:36 +0000 (UTC)
X-FDA: 83927993352.21.498E153
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010002.outbound.protection.outlook.com [52.101.46.2])
	by imf16.hostedemail.com (Postfix) with ESMTP id D70F118000E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:24:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="DcZb/fhJ";
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758810274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1xlSZt9oZafQ+AZGNoUkUJZKtCK5VceqrDMX6OmQ34=;
	b=WBP7Fy4njxAJuAaQrr1wjoLrDrhYz31lOSAgwC6ye2F08RBdJv957JixO+i1s2Fn9UUNen
	QDgmx1xwD3CefbOcSEOMlClit/dnbP1w8pRbAvgbchJX9vDAUG5KFJDvrgtNmq7pO+nuDU
	cNzVSvVH8PvI62ln7lnA2arX3mim3lU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758810274; a=rsa-sha256;
	cv=pass;
	b=DDK9OYC3tD+drogamaypqqNhpXlfbhVBKV3Dx2optHDJ3d2oBh23jR4hpC2NCb2/r2pKLL
	t8AoY7POUR3mvowaBQyx5jblOdJ7O4exPoq8ednSnjif85qrbOlPGbq4rmbVl8sw6kHZa3
	6qG5a/JFl8oBzNLn/kaq7Wodh+1PrSw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="DcZb/fhJ";
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JiQWjwwbb22g4w3j9W4JfozMhjZSC1ho/mjYpXqXa+s9O1v6MVaIIdPHKJfFDWAdnXpIQwP0it1kjIYVhTW+Fx+tr/Q22gICbD3D5F7osBRz7T1AqUHtOzpC63kCnPb7fslKN0GNGiUC0z4r7CXtMnfXzV4w7TdcbN74DyEx182iNvxKLRBaAZ1jdJt0bVdGwzQT86oe7lV2JreUHhDzG+8SonqgFpJD5uhak3f13jY/tucUt/pJF3M3JvOdyanryJq3qMkOm/pC2vCPyN2c7K/bWUe0oQUb4C1GSWUN6MZXyssHGEUTtLV59KI9VUjdXkjee8bRdKZmZhrCcMuGCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1xlSZt9oZafQ+AZGNoUkUJZKtCK5VceqrDMX6OmQ34=;
 b=iZ5uVsZ+UXVOPYoelEEiL2MaO/ZuKoS9Q3zkdE3IF1n4zOWGFewBBMYQjFZWy3buMKrUWNl2c77ixTtcRcwKsnNPcQImDU1B3c1HaTvOU+lioXADTqghg/zoR8Uu6fjB8mLicG1m2vWYbQI9f1DH90IueY2dmUfYXILyNWOutEsRtoh82veHPLsSgFs0BRcDLJEijJ8VS08jeV638C0vbEswY1GGNYuow+0p6vmRC0/Hy4L+OG71nrAv9DKFdkfvm5Yq1X1p7JxOeSzYoy9rdI/o+LlzFYM4GgKUCOcCyB0QthXDgBW4zVEQNyLedqkDuwxBwNbR3YDi5D2NSuDp3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1xlSZt9oZafQ+AZGNoUkUJZKtCK5VceqrDMX6OmQ34=;
 b=DcZb/fhJ/tb045CuBlJUUNg1vvC1HN0B/RF+oLeWMwIw1rKUBEZdd0WK/5TcJZedocqqS4ahdrMpfZ1LYy+ggakiFROWxGg0G3vImEYhuU0GbexiVseU68eFsT3ycuQY7uDoxTj8fjKQgaO34iey80MxUmYGmU+7rP7wudm7cnV9NfGgSpY32wUwvNKadOavLD+nmn0lCmZ7sgNFq5CcuAlwaffZhMgONclZF+sGgMwHd/OwYzIowVnIfjhU6nNUWMROadUk456poGgApwnVr5t+KAZVVtoaVaJUD3mkNo1isZAv4JJRgrkDgfkpS7ecZBm1d9vgNzc8qJKbDfziag==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB8817.namprd12.prod.outlook.com (2603:10b6:806:347::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.10; Thu, 25 Sep 2025 14:24:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.010; Thu, 25 Sep 2025
 14:24:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: David Hildenbrand <david@redhat.com>,
 Luis Chamberlain <mcgrof@kernel.org>,
 syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, linmiaohe@huawei.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nao.horiguchi@gmail.com,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
Date: Thu, 25 Sep 2025 10:24:20 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com>
In-Reply-To: <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
 <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
 <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
 <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com>
 <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9P223CA0008.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB8817:EE_
X-MS-Office365-Filtering-Correlation-Id: 256605a0-1f45-462f-cade-08ddfc3f392d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L2pjbkN2Z0V1MngrZHFTU1FTaDNUbUZYb0x6cW9HYmlaWEIwTUxqbDl6UlMr?=
 =?utf-8?B?WmVkUmhxc0ZPT3R1THBTbjJDaEJITUFjSHE4K0hZY0FTZ3E1RnNXVjFNVElJ?=
 =?utf-8?B?cUFwek5LSnU5aVRDZkF6RUliRlpROTdreXdHWDFnTlJYTGpDcHhNUUJoN1lu?=
 =?utf-8?B?WjhoS01iMGpGclpGT1Z0eXFKSTVidTY4Vm5oZW9qM2FiZWFHSmluV3VIQWFx?=
 =?utf-8?B?ZEdoS1c4NXZ1YnZPVWxJZDI2MVNpYW9pOVNKaEVQZzR3ZmVxQ2U5czY0NWpv?=
 =?utf-8?B?Y0ZqVzBRM3FqL2RwbTdrWUhFdlFQNlVpWCtYYjV2TVNsOXNRSmdUbWk1Q2Zi?=
 =?utf-8?B?bG8wbXNOSXA5alZmSlNJT0prK3Iwc0RZR0NzY3pNMWdYWENZUHNBOGhIa3pI?=
 =?utf-8?B?a3JXdDNkSFNuY1pyT0IyT3REWnhnRWwzamIxS2FxS2ZrRHZTdDNmYU1iWVZm?=
 =?utf-8?B?QlV2ZHE4NDZGUzRYVzM1c25FNW01cGh0SEtRR1hZWDlQSVBwZCtwb2N6STRQ?=
 =?utf-8?B?ZExZOFB6K3hjdmlYWE5TUUpPZzF0UkVRQUJuNVB3NFV4TWRmMGduL2lCRzdW?=
 =?utf-8?B?cEl5WUZKQ2I4TVRpOUI1Uy9lTnRVOFNwYnd1WnBsTUhqRkcyYkYxR0d3SDc5?=
 =?utf-8?B?NDc3dHBrWm12TE50OGdyRnNKVVhOcEtoTlpYcUMydmZOTjFvZ3pNRlBHeTFR?=
 =?utf-8?B?WHkvMlRmRXgrSUpPbGxvKzF4bUNSK09RSThJcHo5aWdqcHNhbHBTVkd2RWl5?=
 =?utf-8?B?UEx0SnpNZjhva0JHNitFRk1Ocit1TG5Nczg4ZWJ1Z2xhZmxocmFaMS9oc3VP?=
 =?utf-8?B?dzBzSlpEUUEvNWUvT1MvRGVYTHBJZVBJS1lKWmJDYzBMdzRwazZ4Rzg2SWs4?=
 =?utf-8?B?Z0xVaml5dEhaYmxwTE9PWTJINy9LVXMrbjNTSFl5QmkwV2Z3SE84WVNTS1Zo?=
 =?utf-8?B?RldKSzk5dkJmNUY4MUdXNVdYTjF5TjdXditpTDNhT0c4NG5acE1KZGhqdDUr?=
 =?utf-8?B?d2hwOWVMaWZvbjB2VHAvdmlkblphT2UvODFlbFJ1dVQrQUlld0hBUFVxalB2?=
 =?utf-8?B?ZDdWTVVBWFlkS2NuQ2R3L05EM0c3RDZuVm80TlEvRStKSHdQZHZHRmU2bGM3?=
 =?utf-8?B?ZVFmT09rSzZSeDQ0RUhzYUtmY2E1dkdpdnBUWEFYS3djYkYxbDZnVmVRN1Vp?=
 =?utf-8?B?aU5sQTdTVTRsTTFWYVQ5eXp6UTJYbTlxeEUzTHkwZVkxQXEvaStLc0VGRlZk?=
 =?utf-8?B?b2ZzdGdidExicW1HOTFWUWlSb25ZZUdNREZDcnJnVDhQQ0FBV01aZDF2VGNx?=
 =?utf-8?B?MHQ1Z0l2SEhIYU5SaG1henF6YnA3UjNSeGtIZ2JGTzJUNWpqcEhkUy9kUHNj?=
 =?utf-8?B?eXJhWStWSGtrbG9uOGxiQjZlRVh1MGdpWFZpNU02cWRtU3gzSlZ4MVJGbXFi?=
 =?utf-8?B?TE0zNlRuZCtHbXFBWlkvUXVHelRsUFR2OFQ3MTZJZUNLVy9GNDhXOXp4cVkx?=
 =?utf-8?B?T3pCd1hqVmY1OW01RWVWeHZEVEE4T3pNME9QQithOVBxbkUwUlgvWjB0WWxW?=
 =?utf-8?B?bmU3eFdpUFhNQmYzaUx5d2VaWVR6WXZZcExBRDJHNVpGZWZ6RGZrZmRmamk5?=
 =?utf-8?B?UlBaS0ZiSXkyUnF2enM1SVdXSWVRS1Mweko1UVM5eE1FeVJLVEFvbUhwQnFV?=
 =?utf-8?B?YmxMOXFFa1pKZGUzdDExaG9uOC8yV3hCY1c2c1hzcWhjSk1UMklweURiSWxV?=
 =?utf-8?B?VmdYL1c1cVNIWjN2ZWMvdEtDQzhUdXYzKzZhU3Vod1lKNmhWSno5M3M0MEV6?=
 =?utf-8?B?MEJIK1F6K2ZBMnZTWnZNOC90NTFoMEdlU1MxN1EvdnVMbEZMeXFjbFpKdTJk?=
 =?utf-8?B?bG5jbEdtTmxJeExOYzd3dVlZZHdYTWZQOUkrQWxmWXFPRzVGSTdiTG5lZmR2?=
 =?utf-8?Q?rMupMBSyAA0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEpad1o2SFJvYzBhM1Y5NG9mVmxkbGd4N3dPaloySklDTFlBek9pRDhzN2w5?=
 =?utf-8?B?WDdmcGQ5TmhmblVOVGJtQzRXV3NlMkVaSWNZNitoY003NzFja0NScnpKWDYy?=
 =?utf-8?B?bUhNYUZsSlpxaHRkTUxUbEIvbmN1SGYwN1VzN2Q0SkNBdFJtcWNLdGM3V0tk?=
 =?utf-8?B?SEtrazMySmdSRW5WbUpMdmk0dG4wTklMWXhtUnV0Y0xDYUMzSVdZbk5TVUYx?=
 =?utf-8?B?NVJjRGo4Wk13OVI0RU9KcW83M25lM3dwL2tSckVDZVdXUm5KVEMxWGkxQ1d3?=
 =?utf-8?B?THRBVmdVWitFYnZzbjdxbDB5WG5WK1pzR1hYL1NvZjcxTzF5WE0vT1Y5RTFu?=
 =?utf-8?B?a2owN3gwSkpnNnZkZjArMnh3eUpjU0dMVWpYekZ2WFRGWUc0NW1OaUlrSnRz?=
 =?utf-8?B?N0lyb3FMTlRNMlE2OHBZbStCQkxKemNGYTdKa1VmVjhFVWY2c01HZUFNdG43?=
 =?utf-8?B?OXpjOUYrWGdxZjFFRmtFRHQzck5qSTR5RFR4VVNUQm9FNlgyV2hFSkpubVFT?=
 =?utf-8?B?QlU1NDN4SEJmTllvVXgyVHNrMzNkbGdFRzF5TkQ1MTQ5OVdNYjR4R2ZwTWQ1?=
 =?utf-8?B?ekZSZDJrcUJhc1JOaUppTVlnMWtYQ3pwa3ZQTGNybWpEQThLWEVHS3FxYTFz?=
 =?utf-8?B?enRZKzRWN0FiblhvTkdLbzBtODdTVFppTDgxMnpnMXZ4b1czKzdvRUoxL0M1?=
 =?utf-8?B?RzRLVWk4L1NwSXUzaXRzZGZMekI4ZENmdHNCZSsrRXZUOXpneWF1QlFqNmJ2?=
 =?utf-8?B?NkNYcG1EcWo1a0dSc1JKWXhTY2JPY0V3cnd0OXJaY3pEMkxDWnpkeFl5ZHBC?=
 =?utf-8?B?eDUzbHdRZzVSM0N2aWkxTWpzQTJ5L1JMczUvd2Z2Uyt3c2MvUUVvVkVpcGVo?=
 =?utf-8?B?TjUyQlBrbFp3QWxlNEdaTHdYT0JnTDFaN0E5THJib2hocHE2U3kybmRKQlQw?=
 =?utf-8?B?SWRtUDFZWitQK0lHa2hvS011TVZGNVVhQW9ablFLNExEVkFRZWVRUXozOTcy?=
 =?utf-8?B?bnYwaUhEemxzOEY4TmtvVXlpSUlKUWpIcStWVXRFdmEzckNkNHI4RnNGcG1N?=
 =?utf-8?B?V1pGUDRjVnNJeTBBQktzcW5iMCtBOWY4TGx6bWk4MURCY2YwVDR0UWFoc0Jy?=
 =?utf-8?B?bTZpYW5WWkFIY2c1NTF0SFdER1BvMUlHYklRUThMRG1hTFZkYVFjYkJOS3JU?=
 =?utf-8?B?WVRqdjJlNExpdTVhblhnS0VLc25lMUpHOU5SWE15eHNPN3ROUjRReTNPSTFi?=
 =?utf-8?B?WVdxMEdUZVRVemxDMFlQb2JoZzdLWW5ZS2puZDhjaE9vd2VrNE05Vkc3NEJa?=
 =?utf-8?B?elBpenBCNGovb1Z4M3hYQ0pVS2U3TmhMOU1SUTV4VEU3M0VZRVZEMytBN0d6?=
 =?utf-8?B?MTc4ejJqNjBOcEtCMTFSclZPM2E5SXlWNlNzU3M5a3RpNllZYjlZcGxWWVBw?=
 =?utf-8?B?Q3VPNm9qb3FOTk9XczR1cDZwRG9aeXdBd1ZBUCtWaVRzUTR2a2lrL2JGQ3BH?=
 =?utf-8?B?MkpMQlFETGdxSUNGVXB2Sm05WEtVYmo1czIxdzFpY3c3YmhqRUlrQVpiWlor?=
 =?utf-8?B?UlVSbDRicUozRkdrZ05oU0k5QnVLM3N1QjEwTFF0RXVCN2hqME1xM2VHc1dU?=
 =?utf-8?B?NXdJMGFPWE9saFVoeHErMUR5Qi9VSlk5eEQ5UWE3WGJBZEdXS2xMQXNienVh?=
 =?utf-8?B?RllENE9IZWU2Y0F0K1NYTGpsMGxRaitmYzJ4bFlwWkwvQ3h5STRTZ1piVGlL?=
 =?utf-8?B?OXhxamd2WU5pQzFtUHJpV3dldFVTSFlqUUhXQXphaFppZVE2ZExUTGU2S3Bk?=
 =?utf-8?B?c2ZUVnlxU1BSYnRVYVRMbWIwMEVBaDk3amdSOURyNmtkcTFLR2hoaXhhLzZT?=
 =?utf-8?B?cmZGRlhONVorUmQyMkFzNHdIZTZTVFNBeWVkd1p0bHZ6SDVHcHBhOWlHc2JJ?=
 =?utf-8?B?WFBESXNpcUcyV3lBVUFhYWFtVGp6VE9HN1NqU2pOc0MrSS9kYVdicVdpUVoz?=
 =?utf-8?B?dHdnS0k2ejhuZGdKVk5hWXZqZ0IxckFEYW14amJOcS9OdHZJb1MwZlhmdFhk?=
 =?utf-8?B?NDN1cjltcjRhZnp3WVF5MEVCOTRwQ0hFblp4TzF1MDVGbUZHUVROQ2FDYVFk?=
 =?utf-8?Q?+XvKwnSmUsqx4Lfmk8eyG0LsD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 256605a0-1f45-462f-cade-08ddfc3f392d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 14:24:23.0017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I1ddR91Z1tmfNWMLW0MTPbarmlRsclzyCm0fICzg4uHZJZT7gAjQuER0UphXG94l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8817
X-Rspamd-Queue-Id: D70F118000E
X-Stat-Signature: werexd4acg9tp4qzhqmznjqw9o7e5164
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758810273-874952
X-HE-Meta: U2FsdGVkX1+lDbCUNTILGVMNoVbKAkngs00OfUKnMk/5UIw7/FVExpxPYN+5Pq6LgKhVzE/ZptFbq8RhyW/92nWnl058CpiDI/8DIk1nZByFlc7VDnK+uR33JSujo32mGyhTXqlkOf9Ql/uLB1n+6Iaw15dmd8/28Gp+I3nbTWhJsEBXbpOzU/nlgunbt947vDLqgXT98dQV9oRvAacBpl2HKTaDMhLh9sIyhBaCGMIIVLioxgZGmQ2Io/8MNC2TxyNYKRkjbDrtIAcBGknkef8aQmzuIOVRfl9Ti7ROwaAO3In6KgkoN6wyTVtNVDsiceOBNe/g+Mielb3iMOJG8IEfa7vMVYl6bsdU0mGyGIuFdwpVWkVXTZc5cxHKE8k6q3bEyKo/FaVnJQ7Zyp1V3N0XN9te+AX77Q8YAkDSuvUNT74UplUh9c7s1KWXpboJDpObyirKaRiflhrgKoln6mfa+7yAAaEnQqZiI/7o3aPK9j0IgA06T5XLNCYgOStIu8t3jutMXt4wJu7e/1puUYIpouElZUvUWm+FFmnpppvyzHGkaHfTYUIJLVjRyOkZYeDiLJghVwbtNCmE43moWR794BhtUzPhm7yRZ4HKW+aQnS8aUyxPdaI7WA+NF1GGtZAPwgtHlngL8gXzyST7V1Fp3dO5AHWNv2+iYZq8FT0Invh6hTxuP89SH3UcRWSrcEtaPykM19DghP9kbKqZWPmBBjuSwmOMLB4Ffmm9YNcwkbO+xeoOVxn8AIUpP2l8su37DtPYlEm0iFIoAK2FqCNaKOGb+NJoVJsDe+ytb5xfDikl6mdgkK6fTkhrtN1dAQ3631BZ3Pff1sZDZkJhFmuIoRM70ZpRrBqvDEdWSor1rgv872Jms8hbwj66atsILoAyiEYuokb9QcLJJ9IN6qRNB65xvWGmcXl3OEIsLcJam/t7F3EbjZW1DPAzL8qSpCkV4pPO6wZP5h2QJAV
 vuw7JoLz
 4JioHNgDf/TIUH8+k1W2eqphlAn3Mavyl355HA794YOAibW5nu6UvqqEdjDnpnPc3gaXWT6JCZeJADLtgLx5txjSxukK3N6qwaYdyKT3AHR2N+VH+R5OUZ0fjMxOVjm54NGxk1y9v6odEtNT9Aio4G51QSnJnLXVhqc3hcC5ArR5MssrCHHIxM0pdCNDxXp1XubtVMgVp+oLTtfjIpuYf8MW2LldhC3vogPTwIfo33jHJWkejTY8WqO5dCgfvzipZKtZ35BEKMHiD6ook0iWnujzrLCqrw927n98eGRR91rQDzr0BGjPfD2UnmzU0PTN3leWMlm3dVP9QcscVR8djvcR0VEBPpzrLwkm1rQzFJ96PZbPx6gnOybRMaGp/jRKBtV+dqc7kwcX7kuwjjptdleJIpagsL6jI3/1/7xyNcVFIG3uuUJvqiFNoPs+Haq1lnQMI3rSbZncpPiMs49H+RXFO4+qKX5WY/A0aaEgcABbT6rbWQGY+hiNNcf1o13B48vqvgJbY4BtilqG31V6MdV7K0wBR/zgRbBYvV4whqS1ZVS5gJNdS0g/nqD2ZyHylaDPBitv7kc6L2fGp3HCY8kdWejADToTR5H9KOmx5+5Cq/H0WjBCmuXwZs5y9oaMmWVbGb203QRb0dGQKfFVVfdnF1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Sep 2025, at 8:02, Pankaj Raghav (Samsung) wrote:

>>>>
>>>> We might just need (a), since there is no caller of (b) in kernel, exc=
ept
>>>> split_folio_to_order() is used for testing. There might be future uses
>>>> when kernel wants to convert from THP to mTHP, but it seems that we ar=
e
>>>> not there yet.
>>>>
>>>
>>> Even better, then maybe selected interfaces could just fail if the min-=
order contradicts with the request to split to a non-larger (order-0) folio=
.
>>
>> Yep. Let=E2=80=99s hear what Luis and Pankaj will say about this.
>>
>>>
>>>>
>>>>
>>>> +Luis and Pankaj for their opinions on how LBS is going to use split f=
olio
>>>> to any order.
>>>>
>>>> Hi Luis and Pankaj,
>>>>
>>>> It seems that bumping split folio order from 0 to mapping_min_folio_or=
der()
>>>> instead of simply failing the split folio call gives surprises to some
>>>> callers and causes issues like the one reported by this email. I canno=
t think
>>>> of any situation where failing a folio split does not work. If LBS cod=
e
>>>> wants to split, it should supply mapping_min_folio_order(), right? Doe=
s
>>>> such caller exist?
>>>>
>
> I am not aware of any place in the LBS path where we supply the
> min_order. truncate_inode_partial_folio() calls try_folio_split(), which
> takes care of splitting in min_order chunks. So we embedded the
> min_order in the MM functions that performs the split instead of the
> caller passing the min_order. Probably, that is why this problem is
> being exposed now where people are surprised by seeing a large folio
> even though they asked to split folios to order-0.
>
> As you concluded, we will not be breaking anything wrt LBS as we
> just refuse to split if it doesn't match the min_order. The only issue I
> see is we might be exacerbating ENOMEM errors as we are not splitting as
> many folios with this change. But the solution for that is simple, add
> more RAM to the system ;)
>
> Just for clarity, are we talking about changing the behaviour just the
> try_to_split_thp_page() function or all the split functions in huge_mm.h?

I want to change all the split functions in huge_mm.h and provide
mapping_min_folio_order() to try_folio_split() in truncate_inode_partial_fo=
lio().

Something like below:

1. no split function will change the given order;
2. __folio_split() will no longer give VM_WARN_ONCE when provided new_order
is smaller than mapping_min_folio_order().

In this way, for an LBS folio that cannot be split to order 0, split
functions will return -EINVAL to tell caller that the folio cannot
be split. The caller is supposed to handle the split failure.

WDYT?

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f327d62fc985..e15c3ca07e33 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -387,34 +387,16 @@ int folio_split(struct folio *folio, unsigned int new=
_order, struct page *page,
  * Return: 0: split is successful, otherwise split failed.
  */
 static inline int try_folio_split(struct folio *folio, struct page *page,
-		struct list_head *list)
+		struct list_head *list, unsigned int order)
 {
-	int ret =3D min_order_for_split(folio);
-
-	if (ret < 0)
-		return ret;
-
-	if (!non_uniform_split_supported(folio, 0, false))
+	if (!non_uniform_split_supported(folio, order, false))
 		return split_huge_page_to_list_to_order(&folio->page, list,
-				ret);
-	return folio_split(folio, ret, page, list);
+				order);
+	return folio_split(folio, order, page, list);
 }
 static inline int split_huge_page(struct page *page)
 {
-	struct folio *folio =3D page_folio(page);
-	int ret =3D min_order_for_split(folio);
-
-	if (ret < 0)
-		return ret;
-
-	/*
-	 * split_huge_page() locks the page before splitting and
-	 * expects the same page that has been split to be locked when
-	 * returned. split_folio(page_folio(page)) cannot be used here
-	 * because it converts the page to folio and passes the head
-	 * page to be split.
-	 */
-	return split_huge_page_to_list_to_order(page, NULL, ret);
+	return split_huge_page_to_list_to_order(page, NULL, 0);
 }
 void deferred_split_folio(struct folio *folio, bool partially_mapped);

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5acca24bbabb..faf5da459a4c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3653,8 +3653,6 @@ static int __folio_split(struct folio *folio, unsigne=
d int new_order,

 		min_order =3D mapping_min_folio_order(folio->mapping);
 		if (new_order < min_order) {
-			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",
-				     min_order);
 			ret =3D -EINVAL;
 			goto out;
 		}
@@ -3986,11 +3984,6 @@ int min_order_for_split(struct folio *folio)

 int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	int ret =3D min_order_for_split(folio);
-
-	if (ret < 0)
-		return ret;
-
 	return split_huge_page_to_list_to_order(&folio->page, list, ret);
 }

diff --git a/mm/truncate.c b/mm/truncate.c
index 91eb92a5ce4f..1c15149ae8e9 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -194,6 +194,7 @@ bool truncate_inode_partial_folio(struct folio *folio, =
loff_t start, loff_t end)
 	size_t size =3D folio_size(folio);
 	unsigned int offset, length;
 	struct page *split_at, *split_at2;
+	unsigned int min_order;

 	if (pos < start)
 		offset =3D start - pos;
@@ -223,8 +224,9 @@ bool truncate_inode_partial_folio(struct folio *folio, =
loff_t start, loff_t end)
 	if (!folio_test_large(folio))
 		return true;

+	min_order =3D mapping_min_folio_order(folio->mapping);
 	split_at =3D folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split(folio, split_at, NULL)) {
+	if (!try_folio_split(folio, split_at, NULL, min_order)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -254,7 +256,7 @@ bool truncate_inode_partial_folio(struct folio *folio, =
loff_t start, loff_t end)
 		 */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping =3D=3D folio->mapping)
-			try_folio_split(folio2, split_at2, NULL);
+			try_folio_split(folio2, split_at2, NULL, min_order);

 		folio_unlock(folio2);
 out:


Best Regards,
Yan, Zi

