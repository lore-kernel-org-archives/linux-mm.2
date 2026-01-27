Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62DC6D2FEF4
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 23:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8876B6B0005; Tue, 27 Jan 2026 18:27:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834A86B0089; Tue, 27 Jan 2026 18:27:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8826B008A; Tue, 27 Jan 2026 18:27:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 589146B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:27:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E29C11403C6
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:27:09 +0000 (UTC)
X-FDA: 84379331778.27.8BA2FB5
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010014.outbound.protection.outlook.com [52.101.201.14])
	by imf05.hostedemail.com (Postfix) with ESMTP id 35B75100007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:27:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WoUwig3H;
	spf=pass (imf05.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.201.14 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769556427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQqknpQqy4JhFOECbjUgQownCi2Q61dUwmWEG2YGriA=;
	b=p7YPujs0ix/eFqpZrNivaieHd5ec4l1t4e0ZIq13VwUk+36ue4TpTz7JyCol/aKrFYjOXE
	GnamRCUSDkL9NXg1ynkWGM5K/nXI3GveI6wfevchOPjc3e0+Tr26xFUL4MFyAoe8+QBJ7q
	0O4cNcvfcLa+7rQf2/05xYpw3hbcg94=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WoUwig3H;
	spf=pass (imf05.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.201.14 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769556427; a=rsa-sha256;
	cv=pass;
	b=QTqlT3yBcLDBtgjJdfud0DedKh3oewWFYQ0khyoM/vpBcUrqBf/CGyhtOcuGLzGTgsJIeN
	vzO9rYac272hJBmnnOGCJ8YJkjmx+6C1hFwwQz4H4Wov/qHVcAIxrvnPzesj0V3Bj/k6hb
	eDPw1MlAuHmGY1WNr8Eidx9JmnKYU5E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IJqatHPZknzFf4bxdemEgvr42HFVs8e/VlIEc8StJW1nrTRG8K91bUfBvMvFjeTnUoT4+flmONvbMj0yLRdRmgVcfzrIw7mxEsdbixhPTGlGqzACyNebqe7YoY6veVrKUErfOw6ykWtXKkUt7resZK2WypYz8EY9ewNNNAZYYmgDtB3rO3SvwfVsbh06BPPzykWr8mHkttLzFRLbBFvjR+2DeBYO95KSCp+Yy5VHFu0O3LiaIZ4hs993kSAYO2bcKBb8sk1yp0j00BHhiuju32jLK/UQjShXDJJD61wcerfpkA4kn0UBbemp5K9uxWEZ/gCkh3v47kMlKCm4T7GDYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQqknpQqy4JhFOECbjUgQownCi2Q61dUwmWEG2YGriA=;
 b=AFZ0uz86m60v90izS89t1l4YVyQZLk9B7grAMKgVsgIDUHDVhGledkVtARWKsox3n8y+C5oMgDNb7zb/0kMRl3uYdpTfSmkbrRRdkF7pugZbdGn54V/FbT8q2mC/T5CwsXoWOLoyJCWVPQIevYdj4qY//NTSrqkivHWv0zZFyNrevorgQOgs7UvCX+8RtS7xwrvSvwy5LtShx3938pG5p+B90xvcoHm0irpFgSWsWaidIZLdQUVp4QLwJuek0gELZniXVvd72/2RGQ2Aj91i3mqvGTNTTX/apB2iuu8QofzL7OjhcbZBr8W2GbH6JYhF4K11IUw4spj87ikMOs7RRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQqknpQqy4JhFOECbjUgQownCi2Q61dUwmWEG2YGriA=;
 b=WoUwig3HRHhJBPpKsqkMFPVgIPppUNthfSNax9hNfOcRfiaCdIstPaNNCnG9Zv2zxippPB5ehejK6F/LzvqZYNFgZAWoMLhfrKvkWqaHZWJoMValTpoU56aSMT8XuKHsylT1FAhlLCc40efLLNScHWU32oFdQPv+fwUPg5GsCf7F3Tn9jztnpGC9k49JPdAQKWghjU0CfUjmH1/TgvxUsmcwGDI36Wp/O89ydW7fdk8ejftDh3EOs9w0us3KslsUCRbIPyXeqoYxh9B/Z2uJr0rtY/F6jk7QFpIQSzoxAp8JjmWsiZayGQTmBd6aGDe68O1jIEYYwMq5va+H5XclMw==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 BY5PR12MB4161.namprd12.prod.outlook.com (2603:10b6:a03:209::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Tue, 27 Jan
 2026 23:27:03 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 23:27:03 +0000
Message-ID: <91a36928-5c92-47c4-8b4d-1c0ad320671a@nvidia.com>
Date: Wed, 28 Jan 2026 10:26:55 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm: Remove device private pages from the
 physical address space
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, matthew.brost@intel.com,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, david@redhat.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 Felix.Kuehling@amd.com, jhubbard@nvidia.com
References: <20260123062309.23090-1-jniethe@nvidia.com>
 <20260123062309.23090-14-jniethe@nvidia.com>
 <1ECE2357-DEBC-4E46-99CA-34BE894161CF@nvidia.com>
Content-Language: en-US
From: Jordan Niethe <jniethe@nvidia.com>
In-Reply-To: <1ECE2357-DEBC-4E46-99CA-34BE894161CF@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR13CA0011.namprd13.prod.outlook.com
 (2603:10b6:a03:180::24) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|BY5PR12MB4161:EE_
X-MS-Office365-Filtering-Correlation-Id: c8ee91af-c88f-4db8-d098-08de5dfb9394
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2NndnNPN01FUUpDMER1TnVFdnZWODFVRkRlTmVaYmRKWmVrUTh0VTRzYUVa?=
 =?utf-8?B?Rk9HSTFTbGtGc2RqdUZJRmdYSitjdi9GY0lMaWt1N1h0ZXpzZnRSaS9oR29J?=
 =?utf-8?B?RVVCcnZCbWJZcVdVeXc1SkNkTTVlcEVxSDF4Yk0vUlovS0poQzhwdEV2Qkh4?=
 =?utf-8?B?Vm1IcDVJZTBxTEVFbEdBdXJSdFRRWEg0dWdHVnd3Z0QzWTU0MXlpelRXLzQ2?=
 =?utf-8?B?dHlDbjA3MkpFRjVraFRWd0kvb20yZjlXNzJsMENMeFYvR01DN0hndWgyNlhv?=
 =?utf-8?B?UWd2K0IwWHJRSHlZanQ5S1NIQmM5aUU2ZTZ5ZkJJVUdpaWJBQlYzVU05aU9t?=
 =?utf-8?B?RVhyRmFMMVpJeTFnNEZZZ3RIRklHNzVXTy9CN0IwN1pHdjR6bDgvYlFROFc1?=
 =?utf-8?B?ZGlabHVadzBpLzFUejhtV0REa01DY2s2bXBZWExSNFZRb3pWZUFaVmJ6VmVO?=
 =?utf-8?B?dEdBNHZKcW9jR3NoVmU5TzdwUnc1UFhaWWFhdk4rMjhKc0hZR1lscE9VZWVJ?=
 =?utf-8?B?NWhLSFp0QkxEa1R5VGN1UVZ0MVAzWEdKbWNIbDNuUENHajNFeFBuRnN3SUxI?=
 =?utf-8?B?Z2tkcytLZlR2WUVENFRPaXNncXZ5S3hkc3QwRnhvWkxHREN4M2IwbEJYN2RV?=
 =?utf-8?B?Z3JZTVR1WFQ4ckZOcXdKRStoeE8xNGplcjk5bE50SGJ0REhnak4zYmZ5TzJp?=
 =?utf-8?B?b1ZlSmdQOFEzRmhnckcrTmdvSU9ET0x0SldCMVVPb3ZlN3lpUkk2TUpnYmVZ?=
 =?utf-8?B?L3NzUGpJZzZiZ0k1cEkwWVBOOWRUbFY1L1NnYXdnRjFET056TDFhVGVCSTVp?=
 =?utf-8?B?MkkwUXJGZXc2c0hhQ3lXUVpPamN6VGtzWkpzYXhZN29EOGNjSWVZYTlhV1E4?=
 =?utf-8?B?Kzh4Q0JjQ0dsNXpkdUlYYWNGMS9XWE42VDBXU0lndys2RTdyWm1IOE1URFVq?=
 =?utf-8?B?eDFwLzY0NkwwY0s1ZW5uZGlEWkwwRWtydlRDNmxQZ0VTRWZiR3ljcytnZmdu?=
 =?utf-8?B?LzRtZGQ2dHVuS01MeVN3TlRldU5Sdy9vRHkvdFJNWmVhTjVEVHlsTEVTZ3hZ?=
 =?utf-8?B?S1lQZEQrRWRVdThaVVFWYW12WXo1WlphaUdtNlNsR2JUSUpKWDBwVW9lYlNZ?=
 =?utf-8?B?N3BmcG8wZVpoYUp2N1kzTmI3bFdzTnZCa0svQ3IxbnNkREdpNHluVk9TRnAy?=
 =?utf-8?B?K0QvNHdSSTdnb1Y0N2Q5SWRDc1pWNGtWSjNZalhxSnVyc1JENFBJNG1NY1Zk?=
 =?utf-8?B?RVF2V21aT0VxUm85Vm5rN2NiRVhXRHVIQndpd2FEWmk5MCtpdXp6MEhMSVFC?=
 =?utf-8?B?a1NzU3J0V0tnNjc3SGNOYkRMcWtHckNqRlA3Z2dVcVBVSU9VVVlGYnIvYmhs?=
 =?utf-8?B?UU41VVVXajhkQlpYMFdsY09xS3VzR1lyN2xvSWU4UjRsK0RkQU1wRElPRGtj?=
 =?utf-8?B?MGhEWXZVYkVmRzQ5K1pIVVdOUVBCRVRuTUdXSU9OMlh2WXUzVEdoeGNyeHYz?=
 =?utf-8?B?RUFhVzJqdDZTZzdRcFVqUCtBMEh0VHMveEh5ZlJkMUhYZll5Q1ZrNkRHK0VQ?=
 =?utf-8?B?TE14REVDVjJRTC9rbHpPRFVkMzhvZHpqK3ltTHhBSmRDb2h0ekNTd0VoWjA2?=
 =?utf-8?B?YitYalpwdDNzcVp3VnlsL0toYXYvTXJEOVUySHVXdC85YVF2aStTaFZQbS9U?=
 =?utf-8?B?UHpGMTFpRTdFRWgyRDI3TGxVam1XcndsQzJ3Z3dIYlRQWlpLVWx3aytURGFW?=
 =?utf-8?B?Q1dhV3M1bDE4b2pvVy9mT1c2M0lGTzI3TzNHcGp3MmFXUURtRDdqZisvUUUx?=
 =?utf-8?B?NlR5T2VWRGhlU2FqTGtlMXpOdHF2aUhFZkpMUzVKMDV2ejN4ZWJOUVgvVVZs?=
 =?utf-8?B?OTY2TDloR3BtUUYrNW52U1p3YzliZmMyb2JUQXJZd3oyelBLbm8wNW84N1FX?=
 =?utf-8?B?Q1BjNFgzeWFsUC9jYXJ6K1B3SnYyaTRGcmhPZmVYOHd3eXg4RGRrbTc0b1Ux?=
 =?utf-8?B?V01OVjRSeU9JTnBHajZlaUIxSWcrckJlSWRqRHgzTDBhN01SSmhpZVVjZ0xB?=
 =?utf-8?B?QW4xODFwOE9DczBKZjM0WnM1WkxzMUFyQVpuRHBnQ3kvKzdtUWppU2piNGgv?=
 =?utf-8?Q?gsas=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bm1mTUc2MjU5eXJpSCt3VG0vbWVDdENzTlAwWVlJQUVzZWIzSUZBOVJxRDIv?=
 =?utf-8?B?dTJnMmEwQ0lKN016MTZ3b3RIV00yenJ1ZkRsZnhWL2Z5SGQ2TFBvYjg1WFJL?=
 =?utf-8?B?eWxmMjllbWUyblFVaEFOb3RBdVpIZmdkakNkNm5haGZlUHE1aGxTZGRabmVY?=
 =?utf-8?B?V1BTU2o0WmdmbDIvbWFBamlaRVo1MmZNK0dvQWJPcGQ2RUJzeDYvWEtEMThN?=
 =?utf-8?B?d0Z2aC8vOGtBaFRlSUVqQ1F3dytIRTBIQVJ1NGpwQ1c4WFpuRjY4V2N0YmF1?=
 =?utf-8?B?bGhHMjJlZytTbFJmcEpQaUlxNzgxMWN6TEFmYkJ1TTJRcGNjNW5aNk1TZnpT?=
 =?utf-8?B?cUc5VkFhWVpjN0RXdnYybnpjZ0EwWFl6Y05aWmRHdktHRkM5NFdicWFTVG5Y?=
 =?utf-8?B?dHI3b3k5ekVzaEprUkxtYm8wWm9OeWJDQ2FQTS8yM2FCc0orUUlNZExOOEhE?=
 =?utf-8?B?L3dlSVQ5WEdJMzA3Nk5qN3JvN3FDMmFMSGw4Z1NSc2JkbnVSK2kvWmhuMHVD?=
 =?utf-8?B?Nkk2VlBGeThIdzdDS3FZTXJPa1J4Zkxsa3NaWGtaMnByN3ZyNWNhVXdYQjly?=
 =?utf-8?B?WjZQcWRUT3FaeHUwMDF3UVNBSjRyZDBBWTFwenB4bVpKaWFhTmd3eC9BUTh4?=
 =?utf-8?B?K1JvNC9aa1hiNVRMSkUrYnIvRU4wenBESW5WR3cwM2JlcFZzQXhqRjFCM01l?=
 =?utf-8?B?TlVJYXdoSzlPbkIrWGxaa2pmbi9MUGRYMy9GMFFzSTZWN09Eam96S0pmcnph?=
 =?utf-8?B?bG1CZTU3NlF6TXU3L1BsNDlleWRoSktBVzU4NUg2VVpNRXZDVksybHhTaS92?=
 =?utf-8?B?aWo5Tnd5K2I4T1p3VHdEdFNZaVFGQ0w0Q2xCU1RpbjR3ZUVNa2dZaWNHdmlj?=
 =?utf-8?B?Tmk3K084S3ZldlM2V05ObEVyWm5IUnBNcDFFbktuak05UHB2MXpkaG1qYUxn?=
 =?utf-8?B?b2hyYXRGeERvME9ZUFhwNkNrdW10T202QnEvNVpPVjdqMzgzK1pkWTlGSTFj?=
 =?utf-8?B?Sjc5cVI5WmhsOGRFeUFoR1lvaXgxZHFTajRsd3Y4TWV1bU52RlJaQ1dTY1J3?=
 =?utf-8?B?bERiMjRkeGVZS2Rjd0JWTEhqNXk3cWR0c3BMazVvbktZS1d0Y09WeERHbHJ1?=
 =?utf-8?B?R2h2MjZ5d1loQ2NFTmhTekxncjBWV2NIYU8wZXhYWVJDZGpTV3IyTm5lMzIy?=
 =?utf-8?B?Wmd0am4zTksybTcwdndrbThacE1JUGNVR3JYcm93L3FGSmhVRDlPekpjbzhM?=
 =?utf-8?B?U3JsbWM5ckw5bkV3VFRGZENDanFHdFlRZEZkcG9YOFQ3SE45a0dRQS9keXFq?=
 =?utf-8?B?VTRUZjNDbjZ1YktyNWtlOWpqcU9UTHhFV3B0US9pSnFxQXBCWFVlVmpTS2w0?=
 =?utf-8?B?alJZYmwwYWwzeFNEaWMrREFHS1ZiUkt5SGdWVHBCS2NFUUhRcS9XSUJtR1J6?=
 =?utf-8?B?c2FRKzgyZ0w2Z0dxeXdSeVYwaXJtdTl1QU9BdzZ5Uk9tWTV2dWFqUVA1a1pX?=
 =?utf-8?B?QmVJYnVNbkw4b1k0YS9TRzQ4YzV5cTQ4NkZHM3ZWZHdLcSt3Y05TcDZLODNH?=
 =?utf-8?B?QVJZZTBkMlYvTHpzalFrSjFSWFJxZ1JLY09kcGNMQlNyN1FvTkxJOHdySWN0?=
 =?utf-8?B?QWF6eVBwQXp1VmRSdG5QbThxQVhZSHVsQVYvc3lmU1dKR05iMyt1dnQrd3NF?=
 =?utf-8?B?eE85V3BnaW5xUC9zbklaY2NqNDlId3E3c1FiS0cwK1kzVGxJTGhVUXNHUTZ2?=
 =?utf-8?B?aHJ5S0U1UzE2M0lsQm1Nb0V6ckFsaEV3Y3UrcmsyeVlaQms3a0lqWkZ4MTNQ?=
 =?utf-8?B?WCs3cGRSRlB2V2d3d0J4dEhFYUhqUHBIWEx6QldWcEQ5aldUd2Z2OUZGL1Bw?=
 =?utf-8?B?R0NybWNKSEYxTU1sWCtpR2ZuZ2trZm16dEVUN3FUeG42dU5QSStHS2FUZU1l?=
 =?utf-8?B?ME1RdkxXZ1hmUWJHRGJwRkc2NUxzVXZ5NVNBVGpKWFh0MCtFRG9XMXA4KzhM?=
 =?utf-8?B?QS9pMkJ5Rlc4TTFKQnFqTjRFNThpeTBmUzlaWHptcE8vcklvVGZuQzNwRHhU?=
 =?utf-8?B?a3EwZ0RWQWVvSWJWQ1BzTGNjSFRkbDc4YURLNFNoQ2d4VG44c3lVempHa1o2?=
 =?utf-8?B?OXY3anVKV3B3SnlOa0tMVmkxSkJNR3ljV3k1WmxFODRGZmlXVlBzeXF1S0Z5?=
 =?utf-8?B?dXlVOXZUVngwM3UxVmhhS1FVNlNmb0RXcjdJN2F6ZlBXRGtLMTBBMlhtVE81?=
 =?utf-8?B?aHM4ZkdwL3F2WHF5RGljamIrWGFuVFlNajZON1EzQ1dTanowZVhxN0cwbTk1?=
 =?utf-8?B?NmIzVjNMa1BhMk9jaVNOTW9qb3pzZFR1aWZxdFRsbSs4dVltQm16Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ee91af-c88f-4db8-d098-08de5dfb9394
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 23:27:02.8874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YnWA5PtZfAsyrBFsJJjtp0EazDm5XofdMgC3cPb9AQffw2iDXYIJi4u/wXQawZfQMYFtS409qcHLLHNn9BawoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4161
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35B75100007
X-Stat-Signature: gwiqthzkomyhpwpfkwija95zdgcjpr8k
X-Rspam-User: 
X-HE-Tag: 1769556427-127302
X-HE-Meta: U2FsdGVkX192Dp8U3Y1pNrjo+vS0lWvCSoBFhSSP6KnDOoW3nKeuPF4v28fIlmbkC5I3Wm5L4clutNane3sSTppFGoJnTsvUYaV3LcoDqgYy4MG/Pj6hyIZfSXDV8YAjCRNJZe/389yjPWqjnvSTV7JhzL6I4VgZult6NwRJse6DbtW+F00j4inZGDqxsaSdV6pBUy3MqflzWGJbU3NcSS9d9Gt6P4Wy3vtzICXPowd4aXCgPAmyFN3A+t87qpLOrF/2AqyQNY7LKLbeg91NK640QZjQjZGWNtToE+B7Y5V8E4h8VmoGQlqiccW1OvI8lMnIGn9CO9lG6qv9oEfLBjCfBqAzwCxEmuxpTTvElNTfMq8nDOs6mDkrYNe9L4qecFrOeLRLFe8dXY2FZDEhj2/9E2Wuki+PV+wl4PeCqquuumECjtTQr/PP3t+bE/3EEdscwGjHXvDOqOKZDEIzVMb8J0IpA6f65nfucagfFYqtTRXAlQXIyixNX0UUpjvsXCbINU3QmzYCiMrW4iwUoc+WIfS5TolKPe6rV4rbLe2JpV5v1zLznkk2jReqfRpmAx9844QuD++/YaQgZRy9A/iuIoWIfYk3eYp7YbQbQFBFEX+fZkKk5HHumn0EKnznWjz1XvWfBwp+F/2tzTOAVWc3plFCeirfb6EzHhk/3tLZgTcIXPa8ljl8V6qmm3pHEJbR0afCK29PVMbggxkqWxOO1QI/oJo9UiznOuw8piKGdJGDoX59HBEnTUQD5CEFwI/LsfLtKP3h40U24R2hcmmvbaln9UDAUInttG4Wr/A5QDioSsMfZp1rUvMg7ViI0Rxq2ZKJhb97xyHf03QaiD+6hj1sTHe6f1vL1SKWMaz/NAO6qsX8lEi7KOiVm9eMaYimFKg2SG7/7KTeJ/nXyzt239hBUv76h8B/PyvOURQqCS9xd2dRC/ztlJotsIJv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 28/1/26 08:12, Zi Yan wrote:
> 
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index 039a2d71e92f..e61a0e49a7c9 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -107,6 +107,7 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
>>   static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>   {
>>   	unsigned long pfn;
>> +	bool device_private = false;
>>   	pte_t ptent = ptep_get(pvmw->pte);
>>
>>   	if (pvmw->flags & PVMW_MIGRATION) {
>> @@ -115,6 +116,9 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>   		if (!softleaf_is_migration(entry))
>>   			return false;
>>
>> +		if (softleaf_is_migration_device_private(entry))
>> +			device_private = true;
>> +
>>   		pfn = softleaf_to_pfn(entry);
>>   	} else if (pte_present(ptent)) {
>>   		pfn = pte_pfn(ptent);
>> @@ -127,8 +131,14 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>   			return false;
>>
>>   		pfn = softleaf_to_pfn(entry);
>> +
>> +		if (softleaf_is_device_private(entry))
>> +			device_private = true;
>>   	}
>>
>> +	if ((device_private) ^ !!(pvmw->flags & PVMW_DEVICE_PRIVATE))
> 
> Would “device_private != !!(pvmw->flags & PVMW_DEVICE_PRIVATE)” be more
> readable? Also I wonder if “!!” is needed here, since I remember modern
> C can convert “pvmw->flags & PVMW_DEVICE_PRIVATE” to bool.

Yeah, "!=" should work. I did need the "!!" - maybe because xor is bitwise?
If it's not needed with "!=" I"ll remove it.

> 
>> +		return false;
>> +
>>   	if ((pfn + pte_nr - 1) < pvmw->pfn)
>>   		return false;
>>   	if (pfn > (pvmw->pfn + pvmw->nr_pages - 1))
>> @@ -137,8 +147,11 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>   }
>>
>>   /* Returns true if the two ranges overlap.  Careful to not overflow. */
>> -static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>> +static bool check_pmd(unsigned long pfn, bool device_private, struct page_vma_mapped_walk *pvmw)
>>   {
>> +	if ((device_private) ^ !!(pvmw->flags & PVMW_DEVICE_PRIVATE))
> 
> Ditto.

ack.

> 
> Feel free to add:
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com> # for MM changes

Thanks for reviewing.

> 
> Best Regards,
> Yan, Zi


