Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B40E6C614
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 07:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244356B0005; Tue, 23 Dec 2025 02:12:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F19D6B0089; Tue, 23 Dec 2025 02:12:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA206B008A; Tue, 23 Dec 2025 02:12:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB1D26B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:12:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 542A5C0D0B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 07:12:38 +0000 (UTC)
X-FDA: 84249867996.18.C08434D
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012008.outbound.protection.outlook.com [40.93.195.8])
	by imf14.hostedemail.com (Postfix) with ESMTP id 84A7B100006
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 07:12:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="a/sgOOPv";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of acourbot@nvidia.com designates 40.93.195.8 as permitted sender) smtp.mailfrom=acourbot@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766473955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkP76M7a+nr0bZlOD86+9Yol1jE3oHco/I5xEyPt788=;
	b=DKaA7tVYeM+mtSLgM3wuSdKEZ61EK9oJrdVl4dz22gGzyfAEjY7lrjpHnXdT803mijNiE+
	kjlEbFhGJbmWV+PEnQdBxdh1owC8pBA6jBqEq6+pr9z2lkXWagxXUnXdcCsQZykVX8Bqdp
	Imi1TDhqFuEBCrIvrfcWuPoF6lpUrkU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766473955; a=rsa-sha256;
	cv=pass;
	b=gimxgPcekY5NEQE85tEpL9uYCGeHa6cjwtAkwfl29PA/zak6MOmGK9YzpiHNCLcZp/sCxn
	VfqKJdC+Ch3rvUFQ5LJqmUcmJA3d0cR4XadtCuqsn2V8mXxSo5LWG43QUkCcFdPOTlUJdB
	76rwoU40dGRbttZeUUoDQ0cYj0kfZUw=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="a/sgOOPv";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of acourbot@nvidia.com designates 40.93.195.8 as permitted sender) smtp.mailfrom=acourbot@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xAOBHzNFD0epzDlH9us0rzF7RXbHvc0p8xlmCbpykJ4oA9GVlze3rgx0v7uT5uizuN3ekCqIjDRRUlJfIwhfw8fbM8hcuRFAnUZOU/se0v9mOBzponopwqulZcAY+rusDU+Qgn4phXqTbwipO7BHZkSmFpd9qetZTNfdMAvRYf6mQx04s4U2QHHviU9O+Q8XL0KgD0+dHR5EU+x5MM2onWJpX9ZRQN5eKz2CUEMsMJrQSRv2Mp6c/yAQ4G/8AEEaAVva/dNmo3I9vgRX/8Itsa/eqJ0Tyx5mSd9HHaVgH62TM/piAAepFfEX6Jle5xqWeYRJKah9/wwOhEz3NB7xEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KkP76M7a+nr0bZlOD86+9Yol1jE3oHco/I5xEyPt788=;
 b=pBnJPGb1MFBbEX3KAddu0e9W2CPvYxiqGr8+oz9ai0aMa/p6OJia9zn6dyJ/Js+ocUM4rKvD+UDgUeKPP78ORvXktY9DE9ZOpwFxeOLXyyXtlAmPFn2KRO1GJKbOg8z4s5QhWJ1faBgNukNBhGshTHq8PR95c6iv984c+HaIcw8cnURFrIBP3zu+dA5LZcaEw98XsBdUGUosV0MowG/7SJiVA9MDnS8/DdLhC0KwxNqSr/U5XHfBFRzv2l2cVqhJJjtXYL9znpAAQvlZ0G2U+TqcBgNmjydVtrc2Un0wGKNSGIH4F8l5f7184pdmwHj4U3ypLYEP3jChadhmR1p+Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KkP76M7a+nr0bZlOD86+9Yol1jE3oHco/I5xEyPt788=;
 b=a/sgOOPv+TOfSxWAqWwRBfuZXJUwMGyvTiWzVjlIoo9MJ6E8zbvI32BtkDg+in+eyNYS07rflx+Rh6CysnBOkiOQJnialXRtN3E0r5vKGa64fLJeH1JiVo1s70DZDYMfE8bIKgeVQLY+5iK3nh4nV5prNwc5BdC50oi+wzcal9TRft78PYmn08JdPRGp1VfOqoSDX1iAsr1sHEW3KxKgGyrW8kWXMpE10n1Ne8fCs3+dW6wqQ+UBIIhCTMpMclr6yNDoI8EouHtWavJEpGNx5AB0H9lKZdsI4GzGV9hnaTcRlzAHpZdqJN4lkI1zsX0+FAS5lckHSQlta0GcSqDrww==
Received: from CH2PR12MB3990.namprd12.prod.outlook.com (2603:10b6:610:28::18)
 by CY3PR12MB9653.namprd12.prod.outlook.com (2603:10b6:930:ff::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 07:12:32 +0000
Received: from CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::7de1:4fe5:8ead:5989]) by CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::7de1:4fe5:8ead:5989%6]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 07:12:32 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 23 Dec 2025 16:12:30 +0900
Message-Id: <DF5ER5QH96IJ.3TVQDT1YQ39VA@nvidia.com>
Cc: <linux-mm@kvack.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rust: page: Simplify overflow check using checked_add()
From: "Alexandre Courbot" <acourbot@nvidia.com>
To: "Kari Argillander" <kari.argillander@gmail.com>, "Alice Ryhl"
 <aliceryhl@google.com>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Danilo Krummrich" <dakr@kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20251219-rust-page-check-v1-1-df2e52fa3bd5@gmail.com>
In-Reply-To: <20251219-rust-page-check-v1-1-df2e52fa3bd5@gmail.com>
X-ClientProxiedBy: LO4P123CA0313.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::12) To CH2PR12MB3990.namprd12.prod.outlook.com
 (2603:10b6:610:28::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB3990:EE_|CY3PR12MB9653:EE_
X-MS-Office365-Filtering-Correlation-Id: 72bf706b-6538-4121-18a0-08de41f2a30a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnhVMzBIMktOUURNR05GRkJMK2psd0NxTGF4a1MyYklYYXRQR3RScnYvSWs2?=
 =?utf-8?B?Tm0yL01qTHpDUGEzVHU4dWFGQ0ZqekZWUEZDYlN3THdTY0F0RFpGVGZIbGR2?=
 =?utf-8?B?MDZNdWp0N2tHRTd0bzVUVURBTC9TN3BaTlI0enQrbDd6c1lTb0JjcWRod3Ez?=
 =?utf-8?B?emRxVGJzVDFta09iVXA3bGtsZGQ4SnlKTFUySTNWTG5MTXBXVytPOHp5cWdF?=
 =?utf-8?B?T043azhjc2J4WGRGU3BCQTN0WHMwN2c1K0lNdzJZOUVSejZQc2x1WWlhSTdw?=
 =?utf-8?B?ZjRyeGlTNVlyaFJ3ejJweTVXdTFRc1dseTRIUlVBSCs2a3k3Y0NkVEZYMUt1?=
 =?utf-8?B?UitRQ2R6c2E4a1JmY0tBdXZVa2dsZTNrUlNCOXlCRTNzc1dCajM5bERobWg0?=
 =?utf-8?B?RjNvUEU1MGhRbmZITUt1cm03eUw1MGtKYnRlcVhONDY4dzVBdklmdjdSQnJW?=
 =?utf-8?B?bXd3MTRtdlRXTzErTVZocDFWWi80cnM2aXd1aHZrcW5RdWJyNTBJZ2pQbzJx?=
 =?utf-8?B?cTRDc2lkSFFoeUZ6VlFEYXVpb0hxblpXRytKTG0wVHdmVDBxdFNJeWFpUjM5?=
 =?utf-8?B?RDlwMnU1R1NyNW54M1JOQXpWY3BCd1dBVk8vYlZubFVFQlFiU3FubDlPamwy?=
 =?utf-8?B?ZEtUS2dGNW1TcnFmYUpYc0Z5cEgzc2pSQ2EyQ2Z4UW92cTJuaDdUdWxURUYr?=
 =?utf-8?B?L3dtQ1NLMXU4c0d5QVNRbDNyN0ZWWHlYM1psTkthRTNJWEJrK2tWNzdUaVAy?=
 =?utf-8?B?dU1ybFJqMFpXMndYT1hPVGdpM3h5bENOOTdKMXMwNmZEVTZjY3I2dGIyREUx?=
 =?utf-8?B?dEFaRWkvVWphZ1dyWWt3ODF1V0huelFzM1R1amI3OTJVRnRqdG4vUDlqckpq?=
 =?utf-8?B?bTVTM0FWd2pPTTM3SnhDWTZ6eW9SM3U0aC9uSS9VenUrRzZDQ2djOWNUTjR0?=
 =?utf-8?B?YklkQVdTWjd5VkdtVHluT0VQS0dhZzJQWVAyTWNySW5CaTlma2ZoVEtSTVMr?=
 =?utf-8?B?UU9wckdOWkFhSWJtcENCbk93TEpDd3N4Y3BpNDRpYkQ4UUxvODQ2SDB3clVW?=
 =?utf-8?B?Y1kyeVhzeVNnYi91NnpkbFFOeGE1T3drRFNYQnZaU0toTVZldjJCZ2E0V08r?=
 =?utf-8?B?eGFyVWpFRVVQREYvY1pyWFhvNy8yL0huVkN2R29xQi8zYUQvbHNZRWRiMHlI?=
 =?utf-8?B?MmdtQUpBN1NEN2FiNHhzTEJHck9PaHdjOWlMa2Z0SUd5dHFsWEhVTTJGWXh4?=
 =?utf-8?B?WVRyeXdqbk95b0NLQ09LWlE1Uy81bHhpTHBDNnV4N0hYbnBuNlhHN1ZpSUFF?=
 =?utf-8?B?ZHEvTnhSRUNIWE5QNVNMcGVKV0p3SVA4OE80MllyOVMwbTVIR0loREo2LzJQ?=
 =?utf-8?B?UUpvaGtUZTJScUhaYmtJMUNGZlJjQS82LytsbS92MGlrYWpWK1gxN1lRTEt1?=
 =?utf-8?B?UnMwblR0VVRyOUdXOEdvUDhmRXdKT1c1OUtsNDdsSDVTZ1JweGduTHZxTUhl?=
 =?utf-8?B?YUJFTWFrT3FObDcyQTh5UlZid05LOUorc3F5WmRMek1jTUxxclZZSlJabVdC?=
 =?utf-8?B?VnVnbjlmQVdKcUVFMVA0bWhDbldRc1dZV2pvam10T0FLQjBHZDJwUkhCbGxo?=
 =?utf-8?B?MEM0NlFML0tyQzRZSUhuRDNReGZMeXgwcmppTnVsYUdvZEhZa29uYnBFdXBF?=
 =?utf-8?B?eXFxVEJteUs0aEtWZWpQeEh1dGtyYVpNNytXTHZaSFdqTkVtQ1MxWFhsS0ZI?=
 =?utf-8?B?cVIxbWNDMGFkanlGakNPc3JFcTZKT3RhbUlCWGtBcjdZTHRucUlNOVM3V21p?=
 =?utf-8?B?UE80T1lpWXkzTmE2NlBsekNvUWp5eWFPZmRBSmthNkdXRHNVSEtxOEtpWXVK?=
 =?utf-8?B?ejRSTm1xb1pHSWVkZG9ZSVMwelFyTWc3RDFyMlZyTnZkSnAxaWNXeUVUa1hr?=
 =?utf-8?B?eEpnc1FUTVpjSmZpWDh2MFB5NU8zelN5VU96bysxTWdGKzVnMGEzSG9oZnpO?=
 =?utf-8?Q?MIKzVcZcCz+wdZIrZ1MnKr0mBMbUEA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3990.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnMyUHA3UWNGY2g1WDl6YnVDMVloczIrWFZnME9OUUJveFFlOVJRYU5HSGxj?=
 =?utf-8?B?THViNWozMGZQL1I5dEVkNG94ZWhqaHdDNERmTWpiMXE1M1lTemVDNloxOG5h?=
 =?utf-8?B?Qnh4djd1OFZqNUpMcElIUXRBZEVkWUU4VGRhOUJUKzFMcHA4ZitTWGVMMzR5?=
 =?utf-8?B?UmIvcGIrdnBHa2pmYmdMZ0VXS0dNOVArMlJBVFpSc0VLMGhheDBWWEx0bHJn?=
 =?utf-8?B?RWFUNlFCY1piWHpFRHhVYzJXL2V5OTFHakxXUTBielhSV1FtL1ZneGFtM1RU?=
 =?utf-8?B?RG5mVDAxOEtERXhFbVJNSlp6Q0kvWmM2bXN4QkxoeVhTNElQdkFBeFRVVzUw?=
 =?utf-8?B?MjdrMUxlYndkRGtpUVR5SlMyV2FaR0xRRkZyb3grK0xNVGxBVGdRQUlqT0wy?=
 =?utf-8?B?b1VVSkJpc3NvZFUwK3Vqck1JT05TMzRLNnJFQkYreElSWG9OUFowU3Y2aVNt?=
 =?utf-8?B?UjFKSEtjNFBxbGJBM0E3b0c0b3RPZ2NvaUlDelFZQW56WGtUVFlTbE9lOEc0?=
 =?utf-8?B?dEdsZUlxWVV4RHprMnc4WUdmM0FhcFRBa1BMemRnR3MxYU9UQzU5cGZjUVhn?=
 =?utf-8?B?cCtReGhrNlJVMWd1Lzg1cm9TNmxMT1RkdGs5VERqSUhrdUw2bDV1NTd1SFJw?=
 =?utf-8?B?TFNMdVJTaDcycmE1TXBuamtMb1hWek81QjNySitZQjUyYTh6VnJpcWlNbnlr?=
 =?utf-8?B?WFRocGdvVmYrTXdkRHlMeFZCMXdlcHRXOGYrWlA3OXJmNmduWHFROWpwT012?=
 =?utf-8?B?L1dFTkdhVm5KK1pjVEY4MENCZHhQTDFFTERraTFNWHYrUHFsNTRLTGNFejV2?=
 =?utf-8?B?NnJXSWtrRVB5MVhpeVQyQXExemdaaWMvdzZVbmZSVWtRbHBreGtzVlVLcnYx?=
 =?utf-8?B?VTlhbFFhUnZSZFl4LzRIamZVRGdFNWFaSWxkWDNMbW42ZndCalZ4Mm1aTmpa?=
 =?utf-8?B?QXh0YzJSWThORk00eGd5TkZkNXBhSVBnejVrWEc5SFMvVWVOTStMa2xpUlVH?=
 =?utf-8?B?dlhLbHVadkhzSk5MMFpyZmlQOGFCUTBac2czQnhTUVprbEs2UEpRZXN6NFFw?=
 =?utf-8?B?MGtDbmlmWXZmRElZRDBqWG96ME1LSGVkTTVnR1BveVpoQkJldjNvNit3NjUz?=
 =?utf-8?B?NURvLzZqVnozektiUE5nbTdMSXNnYmZtWWJyK2lIZUNuNDdBNFcydmxOaHZK?=
 =?utf-8?B?d21UTEpPcnBhdnhTZVUzTmFLUE5rZ3RYOEJnM0FtVGg2RUpTYTJtSFdxU1px?=
 =?utf-8?B?U0Iwd2xYTi9ZSTNUaDRrSlR4d0tGelc2dGlxQVBwRGZMeE1ObmRlU0lFN3R4?=
 =?utf-8?B?TzBkeUZoVm1naDNFR2ZWVUFxT0pocHNIYjVoNWtQeWNtVkdBcU9jdWx5YzRY?=
 =?utf-8?B?b0IrYUViZXZPQkhUYXhmTGpaOU5jMGx1YlRzTGh3cis4WVdvUWtrZUlWRWg4?=
 =?utf-8?B?SE9aYVFudTVmNytHazYrQ3BkdE1xUE1HOWFlajRueG5xZjJjV0ptNVJvMDFV?=
 =?utf-8?B?TlZTblA2Ny9xUFVHcFpGYmJJY2lJbnBoNEE4T3JObEY1Uk4zYUJmSjY5c3po?=
 =?utf-8?B?b3Q3cVNZc1NZRHdlTkhBcTFIeit3MlczRmxjbDBzY2twM004SHhzSEQzajF4?=
 =?utf-8?B?dW5vTjdycUxZZUxSekc1aThJcXpDblkzSzRlUllLNk5UZWxTaURWRmowR0F6?=
 =?utf-8?B?RkhPcDY0eHBFeWtYTlE1YWdYVUxIVk1ZOTQ5cStrMCt2a1dIVDFpTjU5RmpF?=
 =?utf-8?B?WERHUlVrZzBsSzlsMS9DWVQwcmMwcFFMeWtMMVVKWkVPb2Zaenp3UVljNm1s?=
 =?utf-8?B?T3JmQmRZRVR0NmJuWEx1QXBOYzl2SnVUcGRzeVNLRkF1aysvcTFKdDlGYXJT?=
 =?utf-8?B?eFZTdklrNkpKbjdVRFVhSkU5STh0TlUraWp3QnhkZytMM2FQU3g1RUE4YlhV?=
 =?utf-8?B?TWZXTzBJUndXQWJZYjBmaGE5VUNKVnR2S2tMNm1waHJWSy93VzIrUEVuMVdl?=
 =?utf-8?B?bUZmQnBtZVNOQjNVOHZaVUhlVXJOcUUyb1hiVlp1SFhIblAyTlVkdzJVVUls?=
 =?utf-8?B?MzBodXhVSjBGLzk3dWo3bVBLVzQ4OXhiTGV1T0lHL3l5YTBZSTBBdzdZRzk2?=
 =?utf-8?B?MWszZHgza2FMc3ZMd1BNLzVmTHVGdlEzMjg1WWFIR2ZyZkozOEZDNnhxUDVE?=
 =?utf-8?B?b0JYMHJ0Q2cxWDZUMTd1NGkrdVNhWFZyTHM4dzMxYTFEeEEvUklFYU4yd2pr?=
 =?utf-8?B?RjRXY1I5T0Q3TGFCTnZLREtSZXBkZ0dXU3NlOStycXVnMXNmQzFSNXA2MFlL?=
 =?utf-8?B?Y20rNjZZZGIvM1FlRjhPM1lPQ0phUXNxb1BROVMzbWtaYUVzVWg4Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72bf706b-6538-4121-18a0-08de41f2a30a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3990.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 07:12:32.2429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: brhlzOcbb0NBpAki1FjwnNM91ouFCOIVIA4VqLkgNWIlhFlHsD+4xDn8zjKQHqbZCLy/HPtiMbSuIG20Gaap7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9653
X-Stat-Signature: zc1etair8fmo7giffz6igwr8bpk49mhu
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 84A7B100006
X-Rspam-User: 
X-HE-Tag: 1766473955-221007
X-HE-Meta: U2FsdGVkX19qDHRsS/Aej84LuSzETPCYisbuxRF4KER3m2Ll7GQjV98V0Q0wyPEk0uByBFP2bvqa7MhUfml6M6Sfm2OorA4Rl66kNo+/jhmgmXNG44O+fWHc95req3R9uTSVeR8ENGQ8HbqFWqD1RnnyRT2oK51BWk0AuHP13WggLOB4IjRWA3FdgI+VZr8zHsBLLGcZajzhZJLKHvo87HvT5sJ5ugALkmCpRCD5y2J+aPkCxj0JMD+3uBFCgUQcS09Q1wGmbmwoFJgFBUM8zbxik14P4WCnjCL/YLcGQdcbUSpnmsnVRCUGMaX49MnZqM92IgL08DhPiUnM8bWEriZc9aWsYIjs7ZXF9xWNIt7RD+1JFtLtpHtiGZKu34ec75LRHD9ul2+eE9p8GWsTGf4Zgcw2/4CEZqX1QrbnHDg1XD467o9vgyOD8vrFHQVIllBZeDQpmV6pKnNzQ13MX7hlqw/wdXN3f4NcCof9x1/UFRtq7ovqAzSZ50d+FzDKUGablgCJWwOnVDHp1SZp17LwLwHsQ3tn/XaONsWsP7eE3WuvaGWavMnXw6hRTaDuC8PzO2QNp2CctsKJuj4rdUHjbpyb6GufblZ3l7Pk9y0JLh/3839f51esKOfIH7XQejhSxtacxKfIchoX7BLUqGQ8A5ctJ1PYIMbudobXENLS0I8y3VHxD+ZI8ybPEztZghWuYJeu7Cd5T5J3WKp4eAKXRhkyqaYTJbk6nN0UKX0Bb9oMF2Qi4IMzb7Bui69GH+h7aHoZj+lkAynVlNTZNcFgxD4lQM9DvSKRDZCS3sKFvTupQIGOpGHUE1aT9drPkenmJhulM2+ytnzhZo/lfFHnfzRJsTL2SiYNL8kfdDFGbFJLNkAIgQ2FkMTgOYSq37IyuC6Kck5njk2F9lq3aDKH1iBAj4qQUsUS05m7QhI+/S1EDVD/dxZ3/FS9E6UcxPZXkkVDucDEGiuOUnS
 eiVEya2/
 zF+gdbzgcWRPc0fxrCFnWJRFZZL6InqAzaZDXqE/hoTEjsVjbPfgjRCAHXCy+7zDH+ijY5JDD2NwlaYRYkxSoIkIy0LtONwPgXU63dHIQvhQL4TsEcOUWocy1gpSsx+XnYyKlYNmQf7lg5HqMDroBjUcslWen1KDfEsmTm/bqe8L2meTa6230h71xQ9KJ4OYUGwaHAIT+PRXOyw4G99PzIhGtYfIbNzi83wUeEfluoZnZtLgl53EQnZDFeuvzbdMf9nkJ0nic0gMTL3ml9Cw9aHkrtpzB+umwpSp9kBK6PLh3SqrWTzzgg/3pEh/LYTid3MLYAqGLN041F26QogLFcoySuwjd0eeLtyI7Vr63aADcqxy8yWJYQZEhMonIqHrJra70rafeZS7litt0y9jU+WGM97I5prnjOBd+wfrIEoci9iFUilZNmxRl2eERmc2kIGBF+Enz3VEkUOHUhNq76Jy1IAobc9BeWVG5bUI6XPOwmNxpGGvpHDhQZ3rAubQDg86GcA7cYLaMR8RpbBkk8ohq5/IdPcbouBgw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Dec 20, 2025 at 6:29 AM JST, Kari Argillander wrote:
> Replace the explicit bounds comparisons with a single checked_add()-based
> range check. This avoids redundant comparisons, makes the overflow case
> explicit, and results in simpler generated code (checked with godbolt
> for x86).
>
> Option::is_none_or() would be nicer, but it requires Rust 1.82; the
> kernel currently targets 1.78.
>
> No functional change intended.
>
> Signed-off-by: Kari Argillander <kari.argillander@gmail.com>
> ---
>  rust/kernel/page.rs | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> index 432fc0297d4a..a07e6d256860 100644
> --- a/rust/kernel/page.rs
> +++ b/rust/kernel/page.rs
> @@ -239,17 +239,15 @@ fn with_pointer_into_page<T>(
>          len: usize,
>          f: impl FnOnce(*mut u8) -> Result<T>,
>      ) -> Result<T> {
> -        let bounds_ok =3D off <=3D PAGE_SIZE && len <=3D PAGE_SIZE && (o=
ff + len) <=3D PAGE_SIZE;
> -
> -        if bounds_ok {
> -            self.with_page_mapped(move |page_addr| {
> -                // SAFETY: The `off` integer is at most `PAGE_SIZE`, so =
this pointer offset will
> -                // result in a pointer that is in bounds or one off the =
end of the page.
> -                f(unsafe { page_addr.add(off) })
> -            })
> -        } else {
> -            Err(EINVAL)
> +        if off.checked_add(len).map_or(true, |end| end > PAGE_SIZE) {

I find this line a bit heavy with the two-steps check, how about
something like:

    if !matches!(off.checked_add(len), Some(e) if e <=3D PAGE_SIZE) {

Just for your consideration - the original is still valid and an
improvement over the original code, so regardless:

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

