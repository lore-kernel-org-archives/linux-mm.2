Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2A9CF3961
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2076B00D7; Wed, 19 Nov 2025 11:52:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B525A6B00DB; Wed, 19 Nov 2025 11:52:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1AE36B00DC; Wed, 19 Nov 2025 11:52:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB9F6B00D7
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:52:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DE38BA18B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:52:39 +0000 (UTC)
X-FDA: 84127950438.10.0C3D9F8
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013067.outbound.protection.outlook.com [40.93.196.67])
	by imf06.hostedemail.com (Postfix) with ESMTP id AAAD0180006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:52:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=l0vubO8F;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763571157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/DpSL1kOqZTn/e7f+0Ex6ABwIVWc73CLw+e7ok6jdI=;
	b=itIIZK9V+2yhn7ot5L/cE7oDkRgeUui2UQsG2vONSCvefU60rs7n2LmLX/Xg28ooPI3Npe
	kX7nvcPz/Cql0NEx7aH8PQrtQdB811HhhGaGDPxjrL9gAYq+vxoHL/7DqWLvLR4hnCkGIx
	hFv/zCymPipboCLzVVvQ7ZI9Czp0jGo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763571157; a=rsa-sha256;
	cv=pass;
	b=AG6qsy1tquFLgMipKleYrhXCjKfWunzFXAWu6fSJmUtjXzqYrzSt419H48+e7qrGuw4wfE
	oBgj4m3dBT+newASLHcZr8XTpEFoTIrcEesgUjy/UoL8PvdjrZ8PG2LBdaiXuzRqhfOWW4
	3Wz9ReDqC4+XraROk3HV7mncorjqgAQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=l0vubO8F;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rIkIWpKif4byzimojjHKDLzaZsrV6MEV29iSAw7yXtGXSRryhgiIMcW9GQWXlbr7lJca91+Tp1HZGwAbywr2MPUyTV2LcgcjqPDU6ggqQ1QtWPg5YkKESlnnlX5pa51PjVZD2l+Xb+nfZhL7wHkyQx+dAMSc6iMgkxhoQ+r6/Ti9r9UYHY788BZRy4moIP7OIzNsdXwzSQrfLquUtX7SiXusru+59YYJytfWT/NtKhlcYbK4FEwwtcSZuZoPOumqTFUR0ut6Uaijw0eHf6uKWm7anCRBxA2r4pqfeMQ2sEugyPmjC6ioRTNBea3tqTuTJ39zcZimXfWD1ZZxVKtX+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/DpSL1kOqZTn/e7f+0Ex6ABwIVWc73CLw+e7ok6jdI=;
 b=HpFnYNsHAqUlAzGZ1fXL50qvVhzLrmJroTdLrSXLale3tECKhlyt7N0XUnmZ8DoPGQsqFujDtPMvp9kK5ojYAo8TUtGI014Nnjt/PYbHVuAgQ4DH87bUX5UKdfW1w+WNNFoJtKL/SKqG3QiYT8Gr6W8Gfch1YX/d2X+t3F37QFsgkUS+bD4CDxHIKtA3TDIj0rsdnwTtPJ9L4ilK2aoYFjAADjbgpZvYF4zbnHfcc5h6EoOf1g9LNct0r8hcTXvKsVUmGAx0K23FGiNn9eOcs98eQuTd85wxNafriswOjqIVN0V2PykPNUUylDg4lRY+HmpAPgSOjboVpmuX5U+tWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/DpSL1kOqZTn/e7f+0Ex6ABwIVWc73CLw+e7ok6jdI=;
 b=l0vubO8F25gS6Xx63kNTjTJlJ5qJfgUeXnMBSZmX0g9Mlqv9pJmWapAcl9291bvAGG2CWCnx2mdxuYjs6GGMyOaRTfTIW9Kumqs7ZieT6ZvUqc6nEhLC9kMDDRyt80y2XivTbDwH3amE0LF1SY0eayC9wDzp0iS7O6lBIH8Wltif1ZKDX916EIRK4zkHyhXV0+8RxnOxnBbdiTMkrQ3L+lUS4c0pygfvS32PnCJDpB3Gedcb41yFLXreaPXW/tz2oPEABtFdKnV6MHptdeUXciMceaQ4LrMxFNJ1+aieqedWI+dvW7gwAqybAfhzIZonQnxapQS1MWIhWlyxSodBFw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BN5PR12MB9537.namprd12.prod.outlook.com (2603:10b6:408:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 16:52:33 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 16:52:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jiaqi Yan <jiaqiyan@google.com>, akpm@linux-foundation.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, inux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/huge_memory: rename __split_unmapped_folio to
 __split_frozen_folio
Date: Wed, 19 Nov 2025 11:52:30 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <6F8BA2D3-E087-4A02-9ECE-F2EEF470CFE0@nvidia.com>
In-Reply-To: <3828920e-4a50-4f64-a25b-b6c677181fa9@kernel.org>
References: <20251119054639.244202-1-jiaqiyan@google.com>
 <3828920e-4a50-4f64-a25b-b6c677181fa9@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:208:530::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BN5PR12MB9537:EE_
X-MS-Office365-Filtering-Correlation-Id: e75c1ceb-2e56-42e5-65f7-08de278c08aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uoBp8CUAttVrR5sWQQv+1bBiDf2otsIqnZL9/+9KJpJvDc5BIwf5pPBGFJYf?=
 =?us-ascii?Q?N7PgorgYtVyB2juyBeBPjaUCIwe1K3PddqbDWrUzFkkt4zJcqUqmRKNQ75XL?=
 =?us-ascii?Q?dMhIZD7MLs17X+JkCgFrG9cTTiaHN38OfD0E/vJC0gmfk0OfrFe18X8EQbnL?=
 =?us-ascii?Q?9OWBvAutXm6mS+rq21gOm64UlGO8EbQvNcgnUjsl9w+kuHvF3hnDb3nxSbbZ?=
 =?us-ascii?Q?pyRex8sLFOWG8GPyXupyl4NIrWAZMmy60Fa5jUhhD5N+OU41L1yMk5GVAOQt?=
 =?us-ascii?Q?oCn+YJiQSlRa9WSE2OWc8ixPBLEXSmoQ3Jfe5Zv0wiHr00FVc3nKPDe6SFSk?=
 =?us-ascii?Q?S2HZ6izCOoWe3IMCIUTVKu29ytuO8pkK081NIj3ZvkfXo+VsCIJwoXUORnAH?=
 =?us-ascii?Q?THKa7JneC6fAIQjaZ+FrNBwjQ0R35aXO1k1gip2BM0uxh2D0Zg8tk4N5o+tn?=
 =?us-ascii?Q?7VJZ7ziRvjfxZ9RuPQbhYFSI/Ck6ygKpy+LhxczdnRxIeHc8HGTRhzl7Vs+7?=
 =?us-ascii?Q?yKmTaOY9Yc5fJwlPz8fqQtGZ83sLov0WAxhaoRmnNivKEvy6ppxK33HaojXj?=
 =?us-ascii?Q?W4zj3umbB+ivvtT+2aH4MHHA5bHKpPbQtLwpKN2VWd334WiEeLeqQDrZ8iNy?=
 =?us-ascii?Q?o0WrYqxVXcIhCevUfbMFM+D2b6JMUIQ+6eg4L11ZFM0qqvVDnPxt+K/I8Ika?=
 =?us-ascii?Q?k6oyaKVM81iOfM7Sx8ZLw0m1qeAZawoZScpz16edERsy+usZKuYslncSIibD?=
 =?us-ascii?Q?K3IvBkrmV0MlLunW5/hShSfWGBRhgqA7imMqt1fp/XvSNjfBiugF38GVCskw?=
 =?us-ascii?Q?IFf7VD9ZfIi8e6nLWEzXqswH660KLNzAenog2kwEDReo+OFrl+AaSWS7suAz?=
 =?us-ascii?Q?x8W+QEp9bDdakV2nfJYgP6srjfXMDGUSD07OSs7//MbdPpS+G8r/0+PHEjO3?=
 =?us-ascii?Q?zqltqZ4ev81jo3PDraw4SrVx5KUqzHG5X1kWcAUvTqo88RhoYieEnOYdZQFm?=
 =?us-ascii?Q?hm6fl3GCXW6kmi9DKdxKpbQ+fNM8vVLGqaPAqpmglSAbpZEXbECUBXsT4iB6?=
 =?us-ascii?Q?ysVbtCCL92y81RJL6Q/jaI2E6khrhalZfOfjyJTMSZ/GLG0mo17JXu1IRFLw?=
 =?us-ascii?Q?PUDrJuy13+j6eRfVW8Fqkr6AiAk+Pyh2Is+p+zZQRFtOU5xwG0k9RhrPYWnG?=
 =?us-ascii?Q?csiACMZfpLkxW6QEcPEf+5hD2MUM3tcZZlmpdJXfkxrqhdeLcpKmTGT34PpQ?=
 =?us-ascii?Q?E/Ctu0uapsQY3Bh+KeKRgidTamk6Q6cWrwfpAtMoQBbnAMckNaqHbdL1OJRI?=
 =?us-ascii?Q?sIx9eQDiIwL0Eoc1ekJ4ViwqLFuA87fYFuGZ2Qju9VttnUUBpN1DPN2IXCKr?=
 =?us-ascii?Q?LJ7/JYY2wTZNWr7nZi7UWI0oE4HfmC5xGQAkqE7TrBg1gOk4hTdFjDxl64nZ?=
 =?us-ascii?Q?ss+hJE4/cnXT4x4J+yqZlZ3REKO45AqX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1YmN2OEDMW2NAeZzTNj23q0LlItPTC5/xtKNtM/rEbNM40JLqWdRYx5QpJxu?=
 =?us-ascii?Q?CPfEeo0KY8vD3d0RCu5Mqooq5c1EVe3AKR4tBiityrTO+kXj6/LY+662EJT6?=
 =?us-ascii?Q?RCV62QPjZygeTDViduxGLfEU0JbbnUM423jm6p6ReRtic2RlnafVhEMtTblb?=
 =?us-ascii?Q?82fiFYnYqqmgU+7LkB6nyaR1ZDhwFPmSfHb4IHgyrGXQFX37rBRMQzBQEc+h?=
 =?us-ascii?Q?fCPsCwX4Mqpj3LU2jRhuufGT84A8dXPZOJpJX5sK1u50rJ2I9ktljYbnwYq6?=
 =?us-ascii?Q?lyizGUN2oHRG/CWNrVBCiPXmUwcAyIx/qxwpclyW86B7NXWRX6selVWyMv5W?=
 =?us-ascii?Q?uRaJx+AvceSl7CwbJCzV0NO9hMKkMzJGYCL2BrxFlNSufd+TdyuMNTKX2aUW?=
 =?us-ascii?Q?8lHw66n30IdKzgB3LRUwKUwExzanVkRWl8TrRodIOQonM0JhN78fZx2w+w5A?=
 =?us-ascii?Q?JRFJF0a8/k5rb6u9CYoTK1hf/wS/kXLCx6/wxXvCPBHCkEabY2HJ0NR6MP2B?=
 =?us-ascii?Q?YnBJR3r4GLRjaA/+CIqvyxJtLNwHSDAaoE4qfaT6TJiFRuBVLM6kvhkOODdg?=
 =?us-ascii?Q?81nTcM3S3MN20UJMpCs5piJBKZwAwkUFvzpiWfVF1E1LNC0o1p5LwOX6rnji?=
 =?us-ascii?Q?YX65vUJ84roU6MJ1SyeNPAbDdIqL4gbQcTRveZu+nXRFwX7UQd3JFcAdJtLg?=
 =?us-ascii?Q?NjJMlbmFVd9NFQ11lNY4O6ydSEM+qyr/ce9MgaW4F6RxBMc22dV5LsvQw15n?=
 =?us-ascii?Q?AWbi4HIpbQGChTzvaMMIZC7evVbY699iS9pU60f5KJM/vaMuvKU5YBTRelbi?=
 =?us-ascii?Q?YxyoVHAaTeeOsoIiZ7IGrhJadXYxlja8WmjI62bDVfhkOsSI3OazQFAXK6Fe?=
 =?us-ascii?Q?0opNWiEEaTUmFH2v694deaF1+Fn6ObGLhN2ySerAQ3knunnAwfqX7yK3YCPJ?=
 =?us-ascii?Q?ZiQRInMBxNJaGg2+WTnZz4hJHwPVj5dGHhi0gLQm+VNqU/IsanFEx2dwB5la?=
 =?us-ascii?Q?Am90ak7mnrx6UlG9mInDoUyTXAqXj3g6YtIq8taMlgZd1JJ4OacD6VtQGkCE?=
 =?us-ascii?Q?17BZTCV9javpCZJyOxcEmBHH6MTuBAJBqWAsnU2LXTOxyKbUjquC1mdVKMS4?=
 =?us-ascii?Q?PgcG/qS3ky4wJg2PdaiZEe9bUaBYhQKydO3iCMhei9gVSeIQLYGI+QFVkHBq?=
 =?us-ascii?Q?TNDay+J8LsmY51AMtkwPoXkpuq59k+JJ/ifAu91iGVtbbv5C811sy3YCcKTm?=
 =?us-ascii?Q?Cme5NRuHdewR+jDMjxUn3qTscPIY5SReeerV9MbURYDJSr8NOZBgdAwHFzEc?=
 =?us-ascii?Q?Ll9p/gY86BFEK9Ct95IzKvI/jXCS/97NBqf22xc3dmrVE5PMBvsL2DovJUrP?=
 =?us-ascii?Q?6//JuMHRftcXA+kOrC9+Y/uGHKczoICYMcUxdyQbHMg2wrYyvqAsB2fZs/5l?=
 =?us-ascii?Q?mTRPMs/wZyqZ23zNwzsqf48bToX9xG50g/MngvROI5lNWldRAia9Znnixbif?=
 =?us-ascii?Q?Qlr5mscj+Iysd8iUN4bfpRLrVYA2NM9RaAa4kIHtpyaWI4KPel0bFqQLqCkD?=
 =?us-ascii?Q?bmfRy8DTNj/Z8Pjx3t0pZcI5ocCtHmJUrmrP3sB9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e75c1ceb-2e56-42e5-65f7-08de278c08aa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 16:52:32.8636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: imbS7wfqc8Qis65GYdZjgMZup8Rp6B7naUUNjJFyi1P5nmw/OrcMgZ3la8I4diS8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9537
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: AAAD0180006
X-Stat-Signature: gzj4caoidcf3ssm3eu13r91apyeypzdm
X-HE-Tag: 1763571156-937959
X-HE-Meta: U2FsdGVkX18tOYfcqWXwHXsbHEBGk3+bzk6MzD2WZE09A5yI4VIZBoprEnDCd3z37fe5MUv39lruXVDwn0cgtBQUK+EUB6GBVhr36SLK50QuLUHcm5Zaxk1ophG8hRG2lJEyDhb/OHyIrpTz7MBUrccJvOhA7c5Uefqc/gv7XsYjz/trYD8lX6oSP9qiQnFEFETvpMe1PTwcNLp3Bc/KJVGt8C8QYPFB/Dcn1TzRkwJzqHKJ4fybyuZ6FEi+p4zEmKTNTHyU8VyF8rfIN0DLI01MGpnsHTdi7zdsl6QcAGNifHAbHTmH1Jz1QahUkpLCf/8KqlqvjfWV2BFmyovPYwbicQfUPOY7j+c6IqQqok5M4Nn8x+wmUmyRz33FHjnWXmsnbouT+AtpwWTwbbKRmV1/zVPMNBZTePikWo0kTZJgbx48IDUTa8MCAt0eULoJU2CJqjK4xdqIfehNWOBSJPyGdgHDfl70zfFQcqW1Ey58/4BioKTjPRAbQ3DwYVMQA34qP4ibYSyIMWl4Jg0Vfusia/x2V4a+Ua/zYe/Cfkrz9YtgoJ3GTz2Q+EzNP9XmtS+5wngKXGm3Vfs6YrpRx8D0uCh5u0Xs6UpQHLRLPqF0+SSZGwH4L7ENQxsiRV6VW/bstKsNqSzCsYVtj2liRUPOC9UpE3P+PpIGC8nRkt2bWzDkowLMsNzoZyCpmH9eIp4uLKXvqW0bCWZkJe6uO5wljZEW+GMlv11hOnzpcm3EgoWFPpnhkiuhxtUrSWW4V73h1qC1pi803ofRXZ+R0RfU8xsNzTipE330yRV6bh+b9Z1sM9NgXpGs8anEPaZH2pZS1E3FoLQbrOIfLOxbEiMNsmZnnWDtWvJ4GxemK+ERfuWENfxjidAoVOcM5oN7pw7bVquQPuUbUq1gJvQJAgFVxL+L14fRUC6kDhxVdBleyELQARUrNTwk6kvrtojSuNJr+ydDcw/6sIkg0SG
 ur88YfKm
 zN0OZYE839gfsXGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Nov 2025, at 11:41, David Hildenbrand (Red Hat) wrote:

> On 19.11.25 06:46, Jiaqi Yan wrote:
>> The correct prerequisite for this split utility isn't really about
>> if the folio is unmapped; it is more about after unmapped, folio's
>> refcount is zero and has also been frozen. So rename it to
>> __split_frozen_folio.
>>
>> Add a warning in case the folio has non-zero refcount.
>>
>> No new function is added.
>>
>
> While we're at it, can we look into calling this something with the pre=
fix folio_split / __folio_split to get some consistent naming at one poin=
t?

Does the prefix have to be __folio_split?
__folio_split_frozen() or __frozen_folio_split()?

In terms of naming for split a folio, I used folio_split() for non unifor=
m split,
since split_{page,folio}* are for uniform split. Are you intended to use
folio_split prefix for both? We probably can have a separate patch to
change these function names all at once?

--
Best Regards,
Yan, Zi

