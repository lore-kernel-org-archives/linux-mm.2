Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEA2E9B24D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 10:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599096B0088; Tue, 24 Feb 2026 05:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5465A6B0089; Tue, 24 Feb 2026 05:32:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F03E6B008A; Tue, 24 Feb 2026 05:32:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2AB096B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:32:27 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD3D0C1E20
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:32:26 +0000 (UTC)
X-FDA: 84478985892.22.FEC1BDD
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013070.outbound.protection.outlook.com [40.93.196.70])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0F928A000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:32:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=eOf1sCHu;
	spf=pass (imf25.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.196.70 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771929143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=McHP4EbfknJIFR04iPYf1l9yNqjeo/ecvTpxqQk2St8=;
	b=NrwFeyM/RUUoZsVhg6FOLKOKNbKL8jUo5SC2cJZTqsbSmQfR7v/kE3RUMTBRcF7go2xpAr
	T6nHARGiupDnGnA5amqHJgQEh9bZ5wCkkoz7IOgOboLyMzWfEfN3POKjc9Xm4DyOrlwDZD
	KqAXJGtPwVG2lG2HmH7GQAumX5OzXi4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=eOf1sCHu;
	spf=pass (imf25.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.196.70 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771929143; a=rsa-sha256;
	cv=pass;
	b=GmmkUdjnTaiMiOjQ9yIdJm5neQD5jsAjcJ0dyQU/jd8vvYx1c8UzVwQyDmz+lfXHxSW0jC
	NK8BDpl0b/85JToSS3QJU1cuWC0nbyaX/w+66fA+777fb2UZQPzojr6s2bh7KLzvyT4FHC
	c1cX5sYlVxiAtbrACiEzYWBqyLSL93Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F9W3+2xvV9j8CankmCX0Rj3YWWv6UdJuRYETedVIGQXDURoL7azgmUf0vdX4a5xl4ymVL6KOgFyvjIGZorfXTdNqPykNZD21WyJ/F0KRD3wXpAHVjudMSXyvxCS2pnwY3Z914f7jDo7YVQGkxx++musJZM8XJBkgfI6/t9AqYnPZnqhUtB1G/S0a6CQOOA/gORUQWCoft2G7s/SEkgRZ6YZBh8RmU2FE07kEt0kq+Uj/hJA1ygOjVMH7oFJE16np8HPK7psYhdSmH6Ida+pLVJH+MZJ9MdB1b0EWsPzZYe7Qc5haHZ5nTnSsv8dGCUm8BQiICCivgmi+NniKrTF9ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McHP4EbfknJIFR04iPYf1l9yNqjeo/ecvTpxqQk2St8=;
 b=DYtCmgXvrdkhNhYKXX0B2j+hfYBT5A933T93YDBg69gYSCwX6B4asbMlYp7hJDT8D468ch2Y4vgjykj/tTgcyT1hkD0MxK1b8t+jRL6zfYP18Vi4HoucWy+SHzurCuThoJHiYKYJTnaFxHZHx0Za0Im6gaa/np1+WTWm1E+z2obZbfGZRIEWRgIMaH4ezN3A5SaVcNqFqXopftyy1qgGkItAZILI1Ure3QWweHrvTOxN4z4okBMF/usiEDfGjQqsS0WPUViJtkkw3NuVR+JEBQ36KJ7NZy3u1mEr8/njij5JK8jTyy45JHFsbCencJwt3uR/6f6h9Z2p2dumZP6QzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=McHP4EbfknJIFR04iPYf1l9yNqjeo/ecvTpxqQk2St8=;
 b=eOf1sCHu9YnAy+dSP8OSKXCbbVxdk3nRKoEBwc2eVMO4JiNKEfcB1E3qbh4qN4zXq1YixsQvSfrs8NEeFkrkYKaWimwFdeOkyXaG6GszsQMtBkMTUL/WJ6QSQhuLXRtvu+ofubpvsrZyp50SkrMKopd3p1LnePGQGm0CkZoLOXQ=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by IA1PR12MB8517.namprd12.prod.outlook.com (2603:10b6:208:449::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 10:32:19 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 10:32:19 +0000
Message-ID: <56400505-8a13-4cb2-864c-cb785e4b38d4@amd.com>
Date: Tue, 24 Feb 2026 11:32:03 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
To: Maxime Ripard <mripard@redhat.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, Eric Chanudet
 <echanude@redhat.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 Albert Esteve <aesteve@redhat.com>, linux-mm@kvack.org,
 Yosry Ahmed <yosryahmed@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 David Airlie <airlied@gmail.com>
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <CABdmKX0LpKJ9tw48oQh7=3CF0UR5uFtgo0OMwQhHBB40LnijyQ@mail.gmail.com>
 <a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.com>
 <20260224-solemn-spider-of-serendipity-0d8b94@houat>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260224-solemn-spider-of-serendipity-0d8b94@houat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0151.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::17) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|IA1PR12MB8517:EE_
X-MS-Office365-Filtering-Correlation-Id: ec36f7f1-21ea-4d0a-875a-08de738ffca0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHVvQmtFcmhJM1plZGRtUTdzOFYvUmNpT05GZnNDTkVQYUxsOHdNRUFsbU8x?=
 =?utf-8?B?bXhpckpMZGlDZms1NUdIODdQWm5NYjQ3Ui9iblpuKzF3Y1l2K2k4dDNKelA3?=
 =?utf-8?B?cEE0b0FBVFQwR3lQOUpoV2pqS2lqaldSeUZvSGJLS1RmUTg5NndaMTV5L21W?=
 =?utf-8?B?aWpuNE9wMllDcUJvaEJ6WHM3aFF5bklCTGNiV2hjdVZKNmFUM2NHNUh2Y3Uz?=
 =?utf-8?B?YVZzdTY1b1piU1A4TE8vSkU4dDdSd3dNQ2dnWHFHVzEvT0pqUkt1STBGeVhW?=
 =?utf-8?B?ZnpHbk1DN2kvYjAyMnBjVGoyOWhoWUZFbFNTT3VtOHhITW5rNjk2OFBHL0Mw?=
 =?utf-8?B?d1Z5SzRxb2djSklMaXFtNEtJK3Q1YkJ6K2dmS2VQSWtTQ1QxWXU3K3luVjc0?=
 =?utf-8?B?WVp6bG1OSWNzd25JaCtiTUtqNFBzcmtnTjQ1N1FUdDB2TnE2S3krQkVIenVQ?=
 =?utf-8?B?d1lsbXNLSFRWOW01MHJXYzhrVlB4ODZEcHEzNXFiM0RObjZVd0pqa3ZHdFpV?=
 =?utf-8?B?ZHNDcFRSK2l0UDBxdllTNWJCTmhaWitERUJlb2VyS0FTeVY1MVZtdDdJMis1?=
 =?utf-8?B?VW13MGtvVk9kZ01NS1BRcHJkamdZTUtLU2JyanB1Y1NhNVA1TXdEYTcwWmRp?=
 =?utf-8?B?TVh0Z3IvZExZSE1XKzd6bFJub1Z2YXZOcGhxY0dta1FDNWJlc0JXVkJVMEw2?=
 =?utf-8?B?cnV0WVE2VmFTUmc3S01QQW16eGdzb1pHRG0xcHlBSkZXVUdWMWhERlhlUlBn?=
 =?utf-8?B?TUpNaEhiN1Z2aWZ5Szhoc3FDalJyTHh6ZnBIZmRMWUtCdXhSSTN4NW03QzZF?=
 =?utf-8?B?eGpVdkZ2dkhkRkQ2M3FnTHl4QXJMUjFRUHZUT2NXeVVseXJKWHVTUFlGdHA5?=
 =?utf-8?B?S1RLTEwxZGVreHVxNXdDSEd3WkJubGovcGY1cVpIbnpSSzlwWDcyR05XTVpv?=
 =?utf-8?B?bUt6YS82cm1Udi8vYWpQSzM3eWRZSEtqUHdtWXhVVVdwNU1wVFp3TGRFSjJK?=
 =?utf-8?B?UWNzUThRbnlFOFdZeExGcHo5WGxzTmVpOGxLRElqOWlWZGRJUVNrbFV5SW9m?=
 =?utf-8?B?SWJaZ2NtWldyWDRSbUc0Wm53MWpVU2FiMnpjWmJIUldlZzZRdTlibDVLdjdL?=
 =?utf-8?B?Tnc2OGpBR3VLV3Zaek56Q25sRUR2Q0FvS2h3YlNmdGIxRjlYUEExcDUvWlph?=
 =?utf-8?B?UVlrWWVwVkNVU1QrdnExQ2ErdTJCQ1ZEYmZyblJBOHRPbkNqRDhNMEg0OWp1?=
 =?utf-8?B?ejJ4cHBBeXRma3F0WjJka0MvSmI0UU01N1ljTWxkTFQ3UTh2WTdpMkErdUJB?=
 =?utf-8?B?eVI5aVkzYVR0alNtVU4zUGx1SDhuL3UwSVVpdDVkVC9VdjNnZ255YnZSSFpx?=
 =?utf-8?B?NVJnNVMxd1VtS095WENNSHc2SUxPWWJoRktCWTY4ME9vLzdlUzhIM3E1U0RT?=
 =?utf-8?B?LzJYRkxpalpjUFZHbFlJdVdIZTVuY3F2cWE5cVNJUXJLVndtVEhibG1IZUt4?=
 =?utf-8?B?N3FobExMNTMrZ3FQSFpLbzFlVlF0Sk14UEpYMGJyM3ZzZVNSeDZHMmx2NmhZ?=
 =?utf-8?B?bW83ZCtQWkpzMzJya0lnck4rRGk3YVVrbGFTWlFiL24va2dzTzJjUEhhaXhB?=
 =?utf-8?B?UTZ1Qm9scDh4SWMwZ3lBS2pBeDdrOTc4NHFpRHd2TnJpS3JNcjcxaHU1SjAz?=
 =?utf-8?B?UHVkRVljWGtXRlVHS0RCdDJHdElIN2RWSlMxNENhWnd5MFIrQkJYVjZPTjhR?=
 =?utf-8?B?VTFTVGJpK3AzRGttd25pYlZBSkhTeUwwVnpkRVI5MENjYnFVOU02U1lmSFk3?=
 =?utf-8?B?dVgrU21rdXExTnU5SzdPUkMxYms2cXZ4QzB0ZitqT00vWVlDS09RajVTemd5?=
 =?utf-8?B?bno0K1Y5dndRWmRkZTBjM1pjYnFZODZnSlVnS2VmWnVaMWUzaUVvMnlibzJo?=
 =?utf-8?B?bVhGdXlNL3ZIWnN5R0ErbzRaSVQ4SThFWWtzbDNud0RETmJNV0hUVk12SFJh?=
 =?utf-8?B?QkVvTGl4K2pRYWI0RTNiZWd5WEQwTytQZmhITStQaW84d3h5dFB6Z08zRm0w?=
 =?utf-8?B?SlhUNzJMcHpXQjJyemZlRk91YXhha1QvWFhpbUNOUnhXVG1YMzRjamV5b1F4?=
 =?utf-8?Q?XUQc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEs3LytDK09nUTF3em01NHBESW9iOVVXZGI2RHdsb3ErNHpvbEtDT1FmYm1O?=
 =?utf-8?B?SENoNEsyUnBnKzJLcXN5VFpyd01GSmo3RHdRSHllSlZTNStxc051QWl3L1Jr?=
 =?utf-8?B?YmxadDkyN3NoekFLMzFJZWF0MjlCa05DbnJPMVhheWJVWEErNUMra2lnYnNm?=
 =?utf-8?B?SmpGZThURUlXamhydEhaODBWWFpRODlaV0FoSWJBdHpPMTFIWDhPMW1oYVVr?=
 =?utf-8?B?N2NJME5KRWVrV0RwazBweXdnemdmQjR4VWdqTzBIL2VoeDd3UUEwSjdYZTgx?=
 =?utf-8?B?Wjg1Qk8rWGhpSjFqWXNnUUdVVXdMcmd0aW5FU3JFNHVxWWRmTUVQSnhNMThL?=
 =?utf-8?B?Rm1PY1ZWbTdsREh1NFVhUlI4eWQ0UzhDNWdQaVVBa2JpRWREdzBwVWprdnht?=
 =?utf-8?B?WGhuUTNreHA1RTJqUHNvMGZvQmg0NFZjYXZBbStlWldzOHovT3p6Nmx4dkxo?=
 =?utf-8?B?VERyUFNTTDE4bEVDbmZjTnZnWm9rYjFWRFdpc05xSnhkYjZxYXhCNWRxZG9m?=
 =?utf-8?B?WmJmN1VaaWRNdWpBcmdtN1Qwb1VEVnorcWpKc29SVWVaeldOcXQrTEN5QWxx?=
 =?utf-8?B?QXowSTBIWWlHZUJJbTk5N1BqTWlCdHZuMDJ1ZGQ0eDVNcWg1VzY4T256MzR0?=
 =?utf-8?B?ZXU3d3JZY0FrWXFQTVZ6VHFleU16Y0tDdnNReVhGQWZJNGFybnJVNEFpODE1?=
 =?utf-8?B?RXBZc293bk1rZGpEdVV1WE1KWml3MW0zcmJSaWo5elY2YmVSNnZEQ0t1aDl3?=
 =?utf-8?B?b1VKd1ZncU8vckg3SjlGVGRKSFdSbXNGN0s1aVMxMFMvaW9RY280U3Zxbjg5?=
 =?utf-8?B?TlhzY2NIdUdLSjU5dXRKNVpuNmNXOHhsL0gzNis0SC9DYUR6RkZ0a2tCSFhY?=
 =?utf-8?B?QXVXUithd21WaVc4eW9jUm91cWlPZnBCREtCazJzay85aXl0eTdMczZPQitG?=
 =?utf-8?B?QnVhTTNIZ29ENnNzRHV2ZDVCYWoxMWFtZDFLVGp1SnF4MXBFUU02cC9mYTJj?=
 =?utf-8?B?eVQ2QkJrd2dsYVpsV2VjVWQ4dStrckZxUjRURlRYQjVtM2VhTGRVMTQ2UWww?=
 =?utf-8?B?d21jOWMyQTM3YmUveXk0NjlIM1M2dFhKUUF6ZnVKZjdTZGJld2lrUzZwMXVH?=
 =?utf-8?B?QXRQbjhKTm9COXpjK2wyMTRGR0FXRm4zUnpDMk43TkRuY2lJTnJFUEFnbXV3?=
 =?utf-8?B?VXpEVk1PTEdWNUxSUVd4ZlFoTk9aNnVvSE5RWFJ4SmF4bk5qMTdYUHlZK3lS?=
 =?utf-8?B?ejNIM0VQVG1iUmNkZFdRbG1PcUdMMjZVenhQSk1qVlpESEN4ZnRPbEk4MGZY?=
 =?utf-8?B?Zjl0cGkyQ0tYYW9PNDF4enRLcTJJalphN1RNclJXS0VCWjRiQ3MwaXQvUzh3?=
 =?utf-8?B?UXl6Z040Y2xpSlE0d2JFd0ZtS3NmR2VsVEZkcVBnUFdtVHJTUjlGbmlmTWVS?=
 =?utf-8?B?QmpKSDRkUC9IZWQrNitRSUhUckhhL0ZFTzRkTEJsS3hvSUFHbzJKSkErMnVk?=
 =?utf-8?B?REx5TXlYZm9VaG1wVXFjcGFpUDFvY2hLV2dlNHZzSVNFbXAyZWhMOS9MRzh5?=
 =?utf-8?B?ZnRlYXBOWkhuYmJlVEEyREZaekpZOG1HbUk2MjVtejgvOXNndlJnOGpiSDVy?=
 =?utf-8?B?c2s4U2s4TnZsQkFmTDBUVS9RVFZYVjlaQWxBa0swSTZkdWwvb1VBMlNsNEJh?=
 =?utf-8?B?OG5FSTdzQ09hMnNpVk83MTBTVkpUVXhQVi9seEtPQ0hQR3QrSXlIZ1BmMk5O?=
 =?utf-8?B?c3lacDdzVXVpSnZ5Z3h2SFFueHVRekJIaDR4N0l5bW5RNUtTRDJ5RHdaNHFE?=
 =?utf-8?B?V2p5Q1kxVFE0SURVNEpxSnpMclRnL0ZPNzhHay9pSmQ3VFNjWXV5TlFkd0lr?=
 =?utf-8?B?anNzUnEyRDVzWEdkQzI0bHp5N1lyK1RYNk44RGswN1JwbUdlcm5lREFHbEtU?=
 =?utf-8?B?OUlPSnFjNnRVTDRYNVFoK3VKWENZOEV6VFJJNCtya2JPZUpxSXFSMks5SFZ6?=
 =?utf-8?B?UjB6YjZQQ3E4cHZQWitncitpMVd3cVIwbldJRmdpMzluaHFjenpGa3RHUElO?=
 =?utf-8?B?NnNIVEliVzJHRERvMzVSakpPZHNNcTF4M1k3NXI5MVNWa0MyMjduR2M1MGQ0?=
 =?utf-8?B?Uk1EMmZWUzZSeElRS3FJYU93WE05czVnMmhUM1VJeDBQakx5ZTNwcTFjekZq?=
 =?utf-8?B?LzVDaDYzSjZzR2ZLbGdIRk9FWkcydlpMQUNDbjRGc0d3K1F1TG41WHY1K0Vk?=
 =?utf-8?B?L1p5cmhkVXM2NUFoVTM1eGQ1WjIvVEswVTVTN3Q4UWVpQlUrU056dGhIeW9z?=
 =?utf-8?Q?pzhqCfcqisxbajHhzm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec36f7f1-21ea-4d0a-875a-08de738ffca0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 10:32:19.2701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B36yyBM7aw0tnVL7ehrP9A69zcryfct5MbEKM/8Bgbb4yDHsBzpe/tLqCIZNENGJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8517
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0F928A000B
X-Stat-Signature: wp5kk9a13udt3xtchcyyuujohws9br58
X-HE-Tag: 1771929142-658946
X-HE-Meta: U2FsdGVkX19XCxLCYZlsvVx5QqZsayI1N2Mtueh4r29fV/nXtjmWGu+ydIJBZPuDBeZDvqLPlXOGvOZRon+G9B4PUs+edxlJZbebrnTRpu7B3tBNmDH3jYtjtx6FosKVpAHADIsYvvHSLVQTn/xCRwKCAx4dS2T8SqCX1mortn6PlElcJmvpTBAZjTP4+fh1psZBk6tdwqE3EfK8Orwr7iKx1qbr/eUeHBUVxN+duqJ3wzHePxB93blmOhs984nODa559vuLaz0c/BDnWkSTeszG/BaRsQR/mgcpJJwtC2/5Hv0VJ2IH44137xVGO4eDvdjnBTdqWXFAuMa7Pem7qiJF7+UhWlJrqCYg/SdZGaKwf2MXnqy9Xo3J3vUHbmmVNWRUNMQUuC4M3IxoQ1D1R8Tn3JAnZcJgjrpPalRWeZUmIJDtXKpeQ+cbIMSFsHk7StV+u/tYF18L2nmNIBGcyLykbLZLh3FTFJFtL6Mbxb7oi8rHfCLzMwilliYTXr80DVta0Py/h0Jix1ZSlNTPVRsn1DUpRT0vPVfdlfMFK3l7gW0C2D141vD06sR0ijKmqDq+yFZHUzJHYwppIlZ2A+CQSByDDoQspe8n40I5UkAsvRQ0U7KRgF3LWgdt2UL4aH3MTlQ5iJvRucsfEG20KBTlA5sCWiVtUrbX4T+78hLOilKgoZxrH0HeNNXkGMGNiIkyitCMDq6+4dm97LE0+pvGrexap8TRrqW5DeINHGFM8rhUXGWIuyYMJ6xuAlOU+hBEOHx1buiYXSBWIX9VZzrYTwvAS5L6vcTBGgjtbUBSVnm4QkRktf3pILYyLW8QcaWSgdvFywcws8eUalTF8CdxEjduVSOSI/DJbiqcJe9HMKAicmwukB7elZ5hcBEFO16WoR4NuFHtljOPUQ8hAPxtYgUmDVZ7YPwFYyh+tvD7r2WsUClhCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 10:43, Maxime Ripard wrote:
> Hi Christian,
> 
> On Fri, Feb 20, 2026 at 10:45:08AM +0100, Christian König wrote:
>> On 2/20/26 02:14, T.J. Mercier wrote:
>>> On Wed, Feb 18, 2026 at 9:15 AM Eric Chanudet <echanude@redhat.com> wrote:
>>>
>>> Hi Eric,
>>>
>>>> An earlier series[1] from Maxime introduced dmem to the cma allocator in
>>>> an attempt to use it generally for dma-buf. Restart from there and apply
>>>> the charge in the narrower context of the CMA dma-buf heap instead.
>>>>
>>>> In line with introducing cgroup to the system heap[2], this behavior is
>>>> enabled based on dma_heap.mem_accounting, disabled by default.
>>>>
>>>> dmem is chosen for CMA heaps as it allows limits to be set for each
>>>> region backing each heap. The charge is only put in the dma-buf heap for
>>>> now as it guaranties it can be accounted against a userspace process
>>>> that requested the allocation.
>>>
>>> But CMA memory is system memory, and regular (non-CMA) movable
>>> allocations can occur out of these CMA areas. So this splits system
>>> memory accounting between memcg (from [2]) and dmem. If I want to put
>>> a limit on system memory use I have to adjust multiple limits (memcg +
>>> dmems) and know how to divide the total between them all.
>>>
>>> How do you envision using this combination of different controllers?
>>
>> Yeah we have this problem pretty much everywhere.
>>
>> There are both use cases where you want to account device allocations
>> to memcg and when you don't want that.
>>
>> From what I know at the moment it would be best if the administrator
>> could say for each dmem if it should account additionally to memcg or
>> not.
>>
>> Using module parameters to enable/disable it globally is just a
>> workaround as far as I can see.
> 
> That's a pretty good idea! It would indeed be a solution that could
> satisfy everyone (I assume?).

I think so yeah.

From what I have seen we have three different use cases:

1. local device memory (VRAM), GTT/CMA and memcg are completely separate domains and you want to have completely separate values as limit for them.

2. local device memory (VRAM) is separate. GTT/CMA are accounted to memcg, you can still have separate values as limit so that nobody over allocates CMA (for example).

3. All three are accounted to memcg because system memory is actually used as fallback if applications over allocate device local memory.

It's debatable what should be the default, but we clearly need to handle all three use cases. Potentially even on the same system.

Regards,
Christian.

> 
> Maxime


