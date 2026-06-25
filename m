Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97CDCDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 18:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3F16B00CB; Thu, 25 Jun 2026 14:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C6A6B00CC; Thu, 25 Jun 2026 14:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2966B00CD; Thu, 25 Jun 2026 14:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BADD6B00CB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:37:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A95CA0236
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:37:09 +0000 (UTC)
X-FDA: 84919292178.12.11AE1B2
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012028.outbound.protection.outlook.com [52.101.48.28])
	by imf12.hostedemail.com (Postfix) with ESMTP id F1AEA40014
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:37:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pMe6Mw3B;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782412626;
	b=ewoMecwW4GsjYm07BszQKvnpbu7HwczmVi3rP0Gz/FYfCXl1VN8QPI5P4xrsqe6ti58wSq
	JEbAI9yj7SM3Sx3cz7DDDsolQBluzuS9ElEVXzGOTQHcr4S65bwt413hhFju/tfWs1KPiU
	KA+vvVIGC9aYMSNSHJVwhTRDXJ+6mQY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782412626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FwIyMLvlSfuIrHzAqkidpUx+8HxczBm1gb7PJ/8uFM=;
	b=BAIK5MasLUM+kJS28ujq/9BOqSfL3zTMnQjawFWrbs95ZfueAhz5pweJ517brV7BJE+cmb
	pGAoLlRxhtB+cU7vP9ICU1x11gyKrDJyP/sU5SabyA5V8SRXA5FPVRMlGCrFiW058nOih9
	/W+CLTVPV60iktbv/K/exUHFu49mLAM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pMe6Mw3B;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OixVjPey+gH5lYt/Kzan8bWDhbOP2j/1cO59Y4IgOR+K0gaqYnkkmctMcqD6n4cEzPpnfFMFSEX7m/hJZOBUZV2v4/0VBxP1kQrt0VpZwKc4t/jzkGfTTdk/LTXHvDL6IZQIXu7GBfA4IoTDOs4WQi8J10l/LyVRyClCtTXK5jh+1aSV7aDOg/HBXhDAVplxNv3MkS1fz65Jht6VE2b529oMWUVtsaW24y8HHeBNP00lkluHd0OcpQ3m06/JlZ3KVfS9VK2v7jjLUGRFBrYOg6aOvsMJKQpROaNFqqZXnz2/oZnTLy3UfUHCbkUsv/fD9MIUvMKR/zqjzCVs5Yexzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FwIyMLvlSfuIrHzAqkidpUx+8HxczBm1gb7PJ/8uFM=;
 b=pQ4DgzOhhegpuX6n7x0SMAFg3FjW3vPEUbbwKA1DcfWlXG4PPoqmfaw9jO+x6FStD2aWtbTHvUsTcDYioHyrrijhSzSZ2Vi34EPg23mS4BUgk0tJTHgpdfRNt7cPRizotv42ELE4tXg9zNBbMcv3NuKdEMQYkr16BT8m2H7MRmlFTlKHamZsMDkxC7Ef9XCLtsamyXcTE885yFFW1524bCAkj3aStOLHzcXjlERRMyHo5BN8TtfcskbfWUBmpKbQnq6ZiEHZCfd/OCRLbu03iS8gidT0BwyZwHv4a6MAIa+7q27QM9cHtoTy96iiG8sHkyUIIfXmALRjqEVYJp3aWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FwIyMLvlSfuIrHzAqkidpUx+8HxczBm1gb7PJ/8uFM=;
 b=pMe6Mw3BHW8xWY3KKVHKhrGar4/Drmpuv/3QCAxdNRAOWVfYEf7zaaIknXiMsS1n+LG0pXbNNMGA2H+rIqWkV8W377meiH4exVZZuTcm32w6/C6a3C3ybWx8tJIZKyZQYSD5DRHo5x34mdbvzujxJsxETBaIHIAZKa44IkigeE8J+66A2XrZAErQRjpjlh/LgnPqbdntm6U0ZUrTbtiIKjf+LZp41WWTSjH1UF0ydL3qo6g88bORZrsb1ORgyOO8tlilHZ7MbkWwlivBs3z6i70JG8YD7vPGxqXknVzJUJ3q9oJiYVM9p/t7hslN/BnvJBLroIjF01dlxCIgQTKmBg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB6971.namprd12.prod.outlook.com (2603:10b6:806:24e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.15; Thu, 25 Jun
 2026 18:37:01 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Thu, 25 Jun 2026
 18:37:01 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Jun 2026 14:37:00 -0400
Message-Id: <DJICJHL8QY2F.2C6UR95O4RBIT@nvidia.com>
Cc: <surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
 <hannes@cmpxchg.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Zhen Ni" <zhen.ni@easystack.cn>, <akpm@linux-foundation.org>,
 <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v11 2/4] mm/page_owner: add NUMA node filter
X-Mailer: aerc 0.21.0
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
 <20260625043101.338794-3-zhen.ni@easystack.cn>
In-Reply-To: <20260625043101.338794-3-zhen.ni@easystack.cn>
X-ClientProxiedBy: CH5P223CA0003.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:1f3::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB6971:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bd8693e-e411-41a5-272d-08ded2e8bf0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|4143699003|22082099003|11063799006|18002099003|5023799004|56012099006|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Y4Z9e63WTvpiguInraBtTc4e/67ElD13BYGK82sLxGTrdmKgXi2mucGByEbvV2THmVVjOBgqk1QiQ/4roZk8EHK4CzmuSxF07M90EKjkdb7jfqaZoFQdzu+XHIoq853Mqsg/5FLaqx6/mCNDMk3DboCHtZdOPHTIuKrtZKVf5v4IL6cydGr/bkj8bfmKclopyjEkfjPL7UX/V/Ai+G/hvRwFuQ42shykn5erAB6XRTDgSgx4msGHKjkm4F2jhded5ukJUHmA8iE6oA/O5V2YV5ijv7uOqv5+BZ+ho5lq8ak/Dts3TXwrMAxdB6Olms1ryaFoEoEw192Tl16guOBel5JfqjKvzLyrbioxJ5NjaKhIlafMQZRh2lZ052x7MO1YLUyefgf6j0VvFu48Xp9GclE6wZymn5bj+qtj/dajpJxQ6mxxgeQEg99EpyegPESVrJgSVM74CwFmZySe9dXZMl+Ru+chvwpOCOVxr0ZlUmSf0LpeKbeu20QrXKuzovdCf9nTYtjhZzlLPnmEKUXwofjhounfdMaUHbuNgFOMgk/16bhWznJptvaQ8sjomsG1dVIkr9NUzQmPvBIDpnzbrP+EIBuo0OOujHgyxIYPMpUUilnnf4DJHCSUTv8CsSIU9nVNbPm9/h0XbTqWJ4QIAOPs3JRd6kWDjvjjDd2LICo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(4143699003)(22082099003)(11063799006)(18002099003)(5023799004)(56012099006)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkhiMXdGUGI3LzVkWXk4MFZWY29vcm1tM0NsTmVmdWJ3NTBaSjVzY2Q5MFhl?=
 =?utf-8?B?d2RHUUN2clQ1aG1lWHdidWJOZ20vazRZY3k3VUVnL09PaFpiWnk1VnVpRGtp?=
 =?utf-8?B?RElpSThNL1Z4WXNYdldZbXNZZkw2QWpqQkFpdnRtcm9VSnYyUFdXdThZYU54?=
 =?utf-8?B?SUZsQkM0Tk5uSzRxaVBqd2FRY3EvQnZIMG5iVVhLYmdiTjlKS1pIQWRqTExu?=
 =?utf-8?B?YzJEOVBvVE5MdTJXNWJKL0FqNXlKTWw1WURuOStkWjE2bXh0V3RPWDB0S0lH?=
 =?utf-8?B?N09FM3RpQjY3SlllaHMrMHFtNnpKdDFGV3dVbzRlS280TEIrWXBCWmg2ek8v?=
 =?utf-8?B?azdOaTRaVytnSGw3Q1p4ekZTaWNnSm91RW9mMFphN3l1ZTF2Z0N5dVBPd3dQ?=
 =?utf-8?B?eVZWdGJWRGwyTG9SWTNYVG5hZ2tLOXlWWldQNUx2SkE5NDRSWmNCK1AzRTJC?=
 =?utf-8?B?ckNLakVvRzExV0NLMlhCYXMwRlloNUVHVy9ENTlmZThRaGdSTkpFRWZva1Iy?=
 =?utf-8?B?Yk1nNVF2OThqTDE4aFM2cXIxcklKNGo0Qzk3MXcvOFo1WVVvYlcrSmVPTmhX?=
 =?utf-8?B?MVFwQUpDbUFuUEQ5ZXpqMnZ0YWp4RmlJNi9VUk1FY1pVcURNTm1UR3M4T1Jp?=
 =?utf-8?B?UDlNdDAySFFEcnFVZEU1S1RGVEZvS25jU0VoUzdjZkZYZ0VMZlJYQ3VDNGMv?=
 =?utf-8?B?ZGpXZWJ0MW9lZ0g2amVwblNhZm5ZMERJZDZHdklGb3JuaGtOV3VQdlM3WXUy?=
 =?utf-8?B?TktPT1E1SFBRbE95b05ROWhMQlhGbmFIa3ozc3JZR0hJL3RxVlZZemhrYVB2?=
 =?utf-8?B?bk9BZTA2RVdrM0ZmOE5wazZnR0NyRVdwN09JTDRjSWp2WTRxSVF5ZU9kZ1Fx?=
 =?utf-8?B?VXZXR3AxYTMxOG91TTBacGRibW9wdjl1bTRsbGNOMldwNWxuVlFqL0pzaDcw?=
 =?utf-8?B?eVlhc3c3UktmOWJ0RDZXL1ZGQjNwN2ZVa1RxRERSUVE5RktiZ3pKNUEzVzRI?=
 =?utf-8?B?Zlkrd1lFNGt6QXEyaDJ2T3VjK3hhMy9rU3puR1BodUh4aENmRGtsRkF6OEVP?=
 =?utf-8?B?Nk8rRkgzcXQwa2FGYkdQaTg5TjErNURNRkJ0VzlBMk5zRmluc0hpWlo3dWtR?=
 =?utf-8?B?S2Rscyt3WExYdWZqT3R1SURTYmsxY3BVQXNMbW1peTJXR0JoMUNTTy9sN3p5?=
 =?utf-8?B?SXRhQi9WN1dkZ2Yzd3UrMFNpdnRzUERjbzNwUlpZOHl3d0tWZ2s4bE5IeWkw?=
 =?utf-8?B?U29rZVVzNlFWSVJxeGVBS2U4QWJOUG40U2tDR3B5SUErY2N4S1RFUWs1N0sy?=
 =?utf-8?B?TXpkL1VJNUNpcjhNUXlQMng3bnJBUVJCSFlWZ3pqbEpMZFJIOWFhcnFpSzhR?=
 =?utf-8?B?VXZGNlhEejNaWkp4YTNreUFkZEJuN29TdWxpd24vUG02NU0rMitTU09vNENp?=
 =?utf-8?B?VFovaGdSa2JtVDZVTE0zTFRPeVpMbVFxRnBxcVdpTDFTSm9MQkh2WS9SZU9v?=
 =?utf-8?B?RkpTS0o4VUh1WDVmSm0vWmNTWmQrc3daMUx1NnY4bmZGR0krOG0rK3hMSzNC?=
 =?utf-8?B?NHVvK1FtYi9UamlrSzFoMTNabHFBd0dNRE1TL1ZOcHROU29ISEtOMm0rQWsz?=
 =?utf-8?B?cE1hUzBCem5KVGVjenRna2c4QXM3QVVXWmRSY21UcTlhZFVRN21Xbjk3U3p3?=
 =?utf-8?B?V295Z2g3UytMb3ozN0VsTVc4a0lweWNEQmYycXN6TU9Qb0JyUTlOT29tS0tP?=
 =?utf-8?B?SUNCVTFZbjFhcUxSVHRPU3lzOEZVQkl6bkMrMUVqQXRBYmxqUXBSUEwwNnIw?=
 =?utf-8?B?UjNOUE1kNmg4dENyUW4wVCtkUHViekcycFg5NmV2bTJVSjJwSUV3VmlZNldx?=
 =?utf-8?B?ckQ2VzVjR2JZLzZnRGJhWnpTTCtJUklGTXN2YktNNEZUdnFkT0tiZHc5cURv?=
 =?utf-8?B?RzBRUHRxNEhiYUx4eG9kMkI4TldUcmM4VDRkYTc1QzV5czl4czJrYmhRVzUy?=
 =?utf-8?B?bGFDVjB5amJZb2UxVVFoazFab0RkNldPM0NiejZMWld1M0twTWRxVjZLc1VK?=
 =?utf-8?B?cWg0NTBiTCtVd1pwQWRkNnY0Sng5M0NJSXdzT3d1M1FxMTk1UUtodkFUS040?=
 =?utf-8?B?UTU4SWYra1N2Y0RmVDd4V3pWVU02OWxETGpUdGwzOFdjcDFLNCtDMkJYMDd3?=
 =?utf-8?B?K1ZONitEa1ZwRTFRMmUySy9PaEJRalJteERlZUtuN3c3SlFTeDNFdXdSQ2kv?=
 =?utf-8?B?SmpKWVdBbmVvZCtQSHFxMkR6QzBtUG9vQndQY1pvS3M2WTZyM1d4T1pCWm1K?=
 =?utf-8?Q?dA7oJWydk86rEMk1Si?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd8693e-e411-41a5-272d-08ded2e8bf0e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 18:37:01.3759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XXozdXw/lHFgHwca2rZfw6VbRRS2EK4VUxBoYw07tU6qT7MMr3YVvRcBpwEutt9w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6971
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F1AEA40014
X-Rspam-User: 
X-Stat-Signature: qihmsxsoozewqzqgxsar4ajp91dhf34j
X-HE-Tag: 1782412625-788731
X-HE-Meta: U2FsdGVkX1/9X3t7A4OG+lczvaulyd/y5SnuW2LN1+Ip7susotd5c8wwGbtazH6Bw9WHV2FX49RXLfRvXTOP18dqm3SOTLk5LKb5FD7NEBZzS+CVza9OtL1Cyn/+VKliFNC4mXlzb2sE37KERzuMl6La4LaBXkOBKNo+P401vmgqMSKgR3RUfi+zLMLK0YTDD4yHGDpanIvYtABhrvSGbRZf9uAscLmnHLO8jO5b2h5Z9JR2nYSWr80T8Xgi9YT2jIGtNKNxvwW87A4l2IX52BwE7VnA7UyfKpXBezKRaXxxnJrLT/MOdUgyE7ZU2jahrXhwOLCNNlXK7g/zntb2s0wFkTphHq9Ps8uI90wyktlis7ajkyzLRrQh13ycWgG9lHq6aOTHH30QHQDZZfcfZFLWFQppO7yHY/od1ddpkqBNNvhZa8h4cWMHJElSmfZfzKgd3KuU1BJln/xL9pcsbvhdxX1+NVbS0MwqIhe93FJ7zjNTjzw4Cva2eUwLWdKX7PpsoWw27n/9SSXlpHQhsifLLdCTc+Z2IbJCBddEctnwAJ63mHmnNBPs8PMATNsfBs+LH6UmQyxRiW9vBRytNcRTDwE153ycbACG/m4orF4EYMPsxvvDoYzeScih7cOMyhAGaATACdDRm5aerKoJ/yiUibSS5QV9Vpw0laU1RH/jOLFQzA6G3xYHv58nVollOs1sEYT5UHAifxZrpRCcmUZBZU1z39ItruDVbsvPtEjqCg5mJ6FtZvLU4UxvdP75xTnzMYshNTSZnnS6GQZySXvumeENxN7ZkDoXAjb1On/sfJdnhQ6yNZ7vxGmgmdsBhI6PaazVjFtV/PQ21JRi/jZwWN6e++UfOdgh8lLVB8LsvHq+yUO/o8IPRlTkZqHM7Xz3tlkR/Mrm+KgUUIqnAFz0+3v6YTlcVOOLZ4iSWIPL0PBrMtvSsuqajZQmCAh6T2LpcAXip6jOwPXUMPc
 53oBWXMv
 npqe2CMSRHUJcPCDnrCCxusaa09K4O57qBMOgWChOGedpvBnEZRi2X67BqbqGzC3GRP513WmnfQRA2tMHn8c/Bp/82+zEqv2lOgqcPK9Wd02M0V1TREfmV4hvFLAy6loFzQnXQTdFjVFGhFZVKP0sP6gLymBKYWyKW+ey4IYHqMLxoIWNk9WNrSvoa4mhlFbuLhdZfQney+5vy1ifOc8P8iXoEFIfc5AlUXjLKrgdkJTmPYJ24mqiPZbpBkJZ5Vi41C+rIil7LWVz9zsJSaNc+0uLPq4JoYsLRxI7zrzeePBxFv8YgiVwpYvJjiV3j6BhrYxzg/iepapmwWEQXtRQW5zCUaK+BL13U3H3Cd6aWL+8CYYW55GQQx+J0ghYDgLXxZV25I+pZSoOYRM1kJkYOyaZawaovGlkIne/GHF5mhCEHoCgNJQH1EaJBBWInkBifh9xZtZGunr0p4qnMCY7q7R9aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 12:30 AM EDT, Zhen Ni wrote:
> Add NUMA node filtering functionality to page_owner to allow filtering
> pages by specific NUMA node(s). This is useful for NUMA-aware memory
> allocation analysis and debugging.
>
> The filter supports flexible input formats:
> - Single node: nid=3D0
> - Multiple nodes: nid=3D0,2,3
> - Node range: nid=3D0-3
> - Mixed format: nid=3D0,2-4,7
>
> Example usage:
>   # Using the page_owner_filter tool (recommended)
>   ./page_owner_filter -n 0-3
>   ./page_owner_filter -m stack_handle -n 0,2-4,7
>
> The implementation uses per-file-descriptor filter state stored in
> file->private_data, allowing each opener to have independent filter
> configuration. It uses nodemask_t for efficient multi-node filtering and
> nodelist_parse() for flexible input parsing. Node validity is verified
> using nodes_subset() to reject nodes without memory.
>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
> Changes in v11:
> - Remove 'nid' member from struct page_owner to save memory
> - Read page->flags directly with poison checking
>
> Changes in v10:
> - Add 'nid' member to struct page_owner and record it at allocation time
> - Remove cond_resched() in page iteration loop (unconditional call)
> - Update NUMA filter to use saved nid instead of page_to_nid()
>
> Changes in v9:
> - Add spinlock protection for NUMA filter state access
> - Use memdesc_nid() instead of page_to_nid() to bypass PF_POISONED_CHECK(=
)
>
> Changes in v8:
> - Add cond_resched() in page iteration loop to prevent RCU stalls
> - Reject empty nid list to avoid enabling an empty filter
> - Improve comment: "Commit all filter changes"
>
> Changes in v7:
> - per-file-descriptor implementation
>
> Changes in v6:
> - Add node validity check using nodes_subset
>   to reject invalid node numbers that don't exist in the system
> - Move bool filter_by_nid declaration to top of block
> - Use kmalloc_objs instead of kmalloc
> - Remove 100 bytes overhead
>
> Changes in v5:
> - Optimize nodes_empty() check in page iteration loop
> - Add __data_racy qualifier to nid_mask field
>
> Changes in v4:
> - Remove "-1" support, use empty string to clear filter
> - Use strncpy_from_user() instead of copy_from_user()
> - Add concurrency safety documentation for nid_mask access
> - Rename fops to page_owner_nid_filter_fops for consistency
>
> Changes in v3:
> - Remove READ_ONCE/WRITE_ONCE for nodemask_t (fixes compilation errors)
>   * nodemask_t is a large structure (128 bytes) that triggers compile-tim=
e asserts
>   * Direct assignment is safe for this use case
> - Add comment explaining input length calculation formula
>   * 6 bytes =3D ",NNNNN" (comma + 5-digit node number)
> - Simplify "-1" check using kstrtoint() instead of dual strcmp()
> - Move nodemask_t mask read outside PFN iteration loop for performance
>   * Avoids 128-byte structure copy on each iteration
>
> Changes in v2:
> - Use nodemask_t instead of int to support multiple nodes
> - Implement nodelist_parse() to support flexible input formats
>   * Single node: "0", "2"
>   * Multiple nodes: "0,2,3"
>   * Ranges: "0-3"
>   * Mixed: "0,2-4,7"
> - Use %*pbl format for output (e.g., "0-2", "0,2-4,7")
> - Use dynamic memory allocation (kmalloc) to handle variable-length input
> - Follow cpuset's max_write_len pattern: (100 + 6 * MAX_NUMNODES)
>
> v10: https://lore.kernel.org/linux-mm/20260618035750.3724613-3-zhen.ni@ea=
systack.cn/
> v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-3-zhen.ni@eas=
ystack.cn/
> v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-3-zhen.ni@eas=
ystack.cn/
> v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-3-zhen.ni@eas=
ystack.cn/
> v6: https://lore.kernel.org/linux-mm/20260511033017.747781-3-zhen.ni@easy=
stack.cn/
> v5: https://lore.kernel.org/linux-mm/20260507064643.179187-3-zhen.ni@easy=
stack.cn/
> v4: https://lore.kernel.org/linux-mm/20260430163247.13628-3-zhen.ni@easys=
tack.cn/
> v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-4-zhen.ni@eas=
ystack.cn/
> v2: https://lore.kernel.org/linux-mm/20260419155540.376847-4-zhen.ni@easy=
stack.cn/
> v1: https://lore.kernel.org/linux-mm/20260417154638.22370-4-zhen.ni@easys=
tack.cn/
> ---
>  mm/page_owner.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 59 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 7595735979bf..cae5abf0ac9a 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -68,6 +68,8 @@ static const char * const page_owner_print_mode_strings=
[] =3D {
> =20
>  struct page_owner_filter_state {
>  	enum page_owner_print_mode print_mode;
> +	nodemask_t nid_filter;
> +	bool nid_filter_enabled;

I thought about initializing nid_filter to node_states[N_MEMORY] to get
rid of nid_filter_enabled, but that adds unncessary nid filtering to all
page_ower reads. Your approach is better.

>  	spinlock_t lock;
>  };
> =20
> @@ -698,6 +700,7 @@ read_page_owner(struct file *file, char __user *buf, =
size_t count, loff_t *ppos)
>  	struct page_owner *page_owner;
>  	depot_stack_handle_t handle;
>  	struct page_owner_filter_state *state =3D file->private_data;
> +	unsigned long flags;
> =20
>  	if (!static_branch_unlikely(&page_owner_inited))
>  		return -EINVAL;
> @@ -774,6 +777,27 @@ read_page_owner(struct file *file, char __user *buf,=
 size_t count, loff_t *ppos)
>  		if (!handle)
>  			goto ext_put_continue;
> =20
> +		spin_lock_irqsave(&state->lock, flags);
> +		if (state->nid_filter_enabled) {
> +			int nid;
> +			memdesc_flags_t page_flags =3D READ_ONCE(page->flags);
> +
> +			/*
> +			 * Bypass PF_POISONED_CHECK() in page_to_nid() to avoid
> +			 * VM_BUG_ON when accessing poisoned pages.
> +			 */
> +			if (page_flags.f =3D=3D PAGE_POISON_PATTERN) {
> +				spin_unlock_irqrestore(&state->lock, flags);
> +				goto ext_put_continue;
> +			}
> +			nid =3D memdesc_nid(page_flags);
> +			if (!node_isset(nid, state->nid_filter)) {
> +				spin_unlock_irqrestore(&state->lock, flags);
> +				goto ext_put_continue;
> +			}
> +		}
> +		spin_unlock_irqrestore(&state->lock, flags);
> +
>  		/* Record the next PFN to read in the file offset */
>  		*ppos =3D pfn + 1;
> =20
> @@ -783,6 +807,7 @@ read_page_owner(struct file *file, char __user *buf, =
size_t count, loff_t *ppos)
>  				&page_owner_tmp, handle, state);
>  ext_put_continue:
>  		page_ext_put(page_ext);
> +		cond_resched();

In the changelog above, cond_resched() is said to be removed in V10. Did
you miss this? Or it is intended.

Otherwise, LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


