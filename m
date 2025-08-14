Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E682CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C5CA9001AC; Thu, 14 Aug 2025 13:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E08900172; Thu, 14 Aug 2025 13:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E57B19001AC; Thu, 14 Aug 2025 13:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4A7C900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:01:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9DCB21DDD30
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:01:24 +0000 (UTC)
X-FDA: 83775978888.08.A697E28
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	by imf16.hostedemail.com (Postfix) with ESMTP id B29FF180020
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:01:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U6hcEwSe;
	spf=pass (imf16.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.72 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755190881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAkHsODm7sV5wSKxt5sDwbzE0aBbA4TyFWzR3Rav4J4=;
	b=Qx3jfB9r+oA1mXfHDXkBqIluXfZDCiDw2Bj85ksaHxIvqgEzdqlRIJSa/c8BBCLPY1XB3V
	yeBdDB2Yb6DdIHpB4IV4KzXvMc6QJQkxvunKxQdZkcjA8dFTdudwlMJpJHBS36fk4eHFHU
	CL9AZw8d221qt30NcT0cV1IL82BZJaI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U6hcEwSe;
	spf=pass (imf16.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.72 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755190881; a=rsa-sha256;
	cv=pass;
	b=h7m+rHEZcsGlQRUW1BfMIjpEMHmtAAI7PMKuQTmqosyZ1cvyDkun9rYnw/fDIt4fkm60wn
	rSbuYQdeL/5DRMZrZZJ7erveTJIBtUe7B4cgNZigERUYZQ1492G3West/DPk1x5trdyS2G
	pbtgFy2g8UYwKToBZ3PV+8SLpCVi6EU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nh22yPO4G6dEPoHOOzlmvfS8vd+/3FC1QB8TyYE7Gl1wM5EPOmXR82uTkdGvWKwezJim9I39OF8AcXZ3b4vVTUc3sQUMIC/OSzT09/Nikm67JgLCjke1FIgB+d1Mma0UwzzSQNuG/D7mc775xzm5il297CziN/NZ8+2R/DaWruf0Og+H83mHKW57CGz61+zFeq/+9kSc6AQD+XiveGI9kQQhoaciZrN6pR12r/aY8fBZzXukV2wsh2iMKUsP/Dw94sQKalZ682h0p9VZkMh/C33hSTvcZDuloZZBKf5pmVa1CpNrWRbKU9NGqbHLPPHopxh9LP7GqXKwTQWGMQST6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAkHsODm7sV5wSKxt5sDwbzE0aBbA4TyFWzR3Rav4J4=;
 b=J8nc0blOQwwbG8qsGnTLKE/iuJwQ2qqGql9v/XKKJhpxqe6nuxiIUtTZtbZCS4PbI4hvnIhowovCR0Lia+C2wfmMio/UyQSx3YaPxMdkspJOJnTH4yftrr9Hy+EpYqKcxVKW6q0VF0USE4QYiGsVxOw4uqOZqNArBkjQ0ikXNPiux7WpRQCk8ga3eyUIlCyyzq1n1PnUikjzgaHv5ltf2ZtV8iMqDJkucwivKgafNx9CdPOsloaC9ELkF9rzKp4S38L4j0IgmAfQeHgE9lJmukwx0fxcXRtx832B3Wx0iy7pMlTNsSnJxT+8ow3F++YDv3uyRGhSVOW25J0hg72lHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAkHsODm7sV5wSKxt5sDwbzE0aBbA4TyFWzR3Rav4J4=;
 b=U6hcEwSe4dOWlEry64r9g1UEVi7bmOITvrHEWirTXDyG3p+cOnHnPwM/bdpKZbOVK7VBkKQfmVAAA0cA+YkwtVFS2Yv3XM6srqJIbB8lf0tY9OGehcD2kPB/sdHV1rIC2STKTbiCz+MNVxBKvXn+2QspqGC3q73jofYgM1nnHz+gN1fSNh1W5dSM29NPT4VsGJ9fDpL1W/kSNvluStXlrB882SYfUadNSONVZ+AN2pdpzFSUm8alSVEVPReKl7ciCuK9l4Y9LsoGdRqJCxyXfS5hcaDZQsgVX+Yrs0PL5wdEgV96tnyS6n+B1jYHGkX1Aqd2Qtw3+GPjuEm6dvKXNQ==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL3PR12MB6594.namprd12.prod.outlook.com (2603:10b6:208:38d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Thu, 14 Aug
 2025 17:01:18 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 17:01:18 +0000
Date: Thu, 14 Aug 2025 14:01:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 07/30] kho: add interfaces to unpreserve folios and
 physical memory ranges
Message-ID: <20250814170116.GI802098@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-8-pasha.tatashin@soleen.com>
 <20250814132233.GB802098@nvidia.com>
 <CA+CK2bCbjmRKtVVAok7GH8xvh8JWrga5Oj-iK-p=1M79AqvhRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bCbjmRKtVVAok7GH8xvh8JWrga5Oj-iK-p=1M79AqvhRA@mail.gmail.com>
X-ClientProxiedBy: YT4PR01CA0280.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL3PR12MB6594:EE_
X-MS-Office365-Filtering-Correlation-Id: c0ccb198-01fc-44d4-873f-08dddb542fbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R3N0RktxSElES2Y0aDRYeWpWWjI0NHo3ZUZqYzBBZlFYakZLcERyME0yT0lI?=
 =?utf-8?B?SE9LUmM0cnMrOVlSQmw5SUJaSVZDZ0xycU0vWHNseWpZb3QrRGRORmJxYkdX?=
 =?utf-8?B?QkJwZE5seHBBaTdJSUltNmFjSm9jakV3TENzVWJ1T25jYnNZSkRuRjExck9O?=
 =?utf-8?B?T2wvSmp1cHM3eFdpSEJaVW96eVJ2K3JIV3NBMWN3eGpRejhhL09JWlh2bFRL?=
 =?utf-8?B?NGF2RG50ZHMyZVNpdEczenBpbGVYTjh6T2JpNTQyMS9uSEptNng5SnJUemhp?=
 =?utf-8?B?SDV5RDBNR25lVHBZRkxHbEtmOWRrQ0hRV0t1bGJ1OHgxaHVDQzl2QXYzQjND?=
 =?utf-8?B?c1RTdWg4bmk2eVpLV3JzWXhPaWtBTU1pNkhKVFc1STFkNzBjTml6SGhyRFln?=
 =?utf-8?B?cHhDZGlRbUhXUFYzNFFCWVJPUDlRMW1uMDlRVU1UeWc0OFlEMWc4Y2dFaUp6?=
 =?utf-8?B?RjNFbWxUbkNrWThvcGNxSElJSTVUMldhNUoycys4K3dSazdOcWZJSlpDYnZE?=
 =?utf-8?B?VGFudHpKeHlLakRCZFJTOHljaGdrWlg0RXBNRTZuT1liMENlZzA5enFkU0d5?=
 =?utf-8?B?Y1p5ZjNuelNhZDZhNVNJQWYvVDQvaE9DZ21sVWVnQ2I3M0FMc0N6Q1lnNW13?=
 =?utf-8?B?ZWJUR3JURFpHNFZvdkJmckpIWWZHMnd5ZzZyUHRzYnJhYXJTZjZqOElCUlhT?=
 =?utf-8?B?RUlRdHkwY2labnRWSkJXQVMwUDZmYnErNmJIcFY2Ui83ZUNWa1NpNDNueTZD?=
 =?utf-8?B?S1lpdXJsakxIVkNNN2dGTVg0Qk5LdWt5Mis5QS9LUURIMStBQ1ljUVVwT0x1?=
 =?utf-8?B?WUtaL01LZ2lCL3BydFYwdjI5cVdFYXlYU0VYVHBlRk1VL0xqSFFBRVYzNGw4?=
 =?utf-8?B?OHBDOEJYblFUaktGTksweTFLM0NsQnN1MklqQjFZcnNSYmZxbS91dUR5NlZE?=
 =?utf-8?B?M3l4QXBDc0lrZnJKSzN2aUxZbWZFOWNjSzA1S2d1dlRIczQzYzJ0YWJ5cFd3?=
 =?utf-8?B?S0pYMjRFM2VrbEQ1RlZRb2Z1V0Y4Mk5lVTdEcmh4b0dhcUhYbDI3NmErempP?=
 =?utf-8?B?K3dFOENHNndabWFVSWI4ZFhodHAvRmI0QWV4VnZKYjMvSGtnb3N4UFZQeTUw?=
 =?utf-8?B?M213RERXT0l4SmZxMEVuUU9FMk5tSEtZMDYyTGorRDUwYUpJZjdFTUZ2K1Rr?=
 =?utf-8?B?NnRNa0h0R3JxWk12ay9KM1ZzSUNpZGswWDczcmdxdGRObnkvZ3RhTFVKS3k3?=
 =?utf-8?B?L2lIWU9BUVpYY0lycGxMTUFqN3duVVlMbDJtZnpvcW1VcTh5TlRvWXduQmFR?=
 =?utf-8?B?bTJoTTB6SUQvNFF3OStqamdtUDJzTHBSL2ZaeG5CWlIxRDdmTko0SkE2ZHhK?=
 =?utf-8?B?NzF2cW1DUHB6ZXVRbGcvQWRzbnQyOEp2N2x2aEthN2ZmYWZ2bFV4azcwSEFM?=
 =?utf-8?B?VkFRcTBXem5BZjVodG54dXBNd05wc2xlSks4Y3E5Mk9qVXBhZWZCdGlENnhM?=
 =?utf-8?B?eStPdHVCTkJGTnN0KzF5RUlDWVJ1WnNyOXhKNkJSanVBS2hYZzBXMTZsd0sr?=
 =?utf-8?B?R1o5dlZlVHcvZFkyeEhDSm5VWFR1MVJLaVFzamZnS2JyZVV4K1BBU3hsZVVI?=
 =?utf-8?B?bGc0WFJMTGh1dEQ4WXN3ZVQ5V3ZwRnVHeitpNzBSeFRCdjVrdnp2eDVROFBi?=
 =?utf-8?B?SXlUQktLb3lvcW9sSTJ3V3pzRVY2M002M29FZEZlRXRraG0xaGJJNTFhbGtR?=
 =?utf-8?B?eXMvYWxwZFVmQU1XeFpWMmlNYjgwcHg1VGVIbFl3ZGxwSksya0o5cnR3OEp3?=
 =?utf-8?B?QWVKK0dUdkhTYThKL2hCTzJ3MmcwaVhwTGIvTnJyTURNdEtVSXhnOVZWYlZr?=
 =?utf-8?B?Q29hSytuc1M2dWJQejR2SHg4WURDMkpWdkxGVENaYWM3WlpEaHNBUVZ4blVy?=
 =?utf-8?Q?1KNVGaVQglE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFFCbTZIa1R1VHlqK3RvR1M1ZG13Zmw1Y3VGb0NrR2pGZ0E5TVl4WVFzemcw?=
 =?utf-8?B?aWEyVG05TDBwK21NTjdqblF3WFduVk1FcEo3aS9qNXFraDRpR0VWWjl4RWg0?=
 =?utf-8?B?VXh6MmJ3VnNtTjdoZ1d6Uk82RGh0WXRlWWVjK25ORWZEU1ZJQjd3a3Z3cDBL?=
 =?utf-8?B?TEhyekpQb01yVzFBcHZacUdNWU4yOU9ESFdETFlzelhzTEltSjcwMi9lV2wx?=
 =?utf-8?B?KzAzZERMRWVOaHhCbVRNSThGbmczaE9rQ0ErSGRIQklBS0Rqblp4b3kwQk1B?=
 =?utf-8?B?VndMWkVUUHovWGwvOGRacEh1R1dSMHdxYXdLcUdvVEo2U3o4MldyRStzMllT?=
 =?utf-8?B?WDgrSytWQ1k4N3JzT2JSMElUMnZGNmJiOTBjUWtMU2VJYlZPTUpUOGR3TWdw?=
 =?utf-8?B?anJ3V1F5Qk5pWmNMcWJnMEZDbjAvVUMwb29IS251bnVxVUZQdmNldEdFa0gy?=
 =?utf-8?B?ckxUdndmRGFGNkdKYk12OWJpZ1JvSGx0VG1FTVczL0xISktHaDJVM2s1S01I?=
 =?utf-8?B?Q01Ud1d4ZWNkMnNEN2d1WjBoYXYrL0xtRzg3NDBGb0ladDZTUzBMbDdnQ21H?=
 =?utf-8?B?aERoU1luQU5xLzhISUdyaWJxL3g1YXhQN2dJd3l3eXJzOWpHS1JZT2JBakZI?=
 =?utf-8?B?KzBBc2dMOGxPN3ptOWxqdU5XaHlVRXRDNEIxdFhjNUVRWDEwUWt0WWFMYnJw?=
 =?utf-8?B?V0lOeFNJck1ZQ2kycDZFWDBoRkd4UHZXS3p3M0srb2wyMHIvMFNTTUpNZzBw?=
 =?utf-8?B?c2ZoTENsakNJZGJ5dEdmRVM3a0NENGU1VGZleDJqTTBRNzF5TGsvZTVzc2Ru?=
 =?utf-8?B?UmM3L2lNdXdHekp1KzdQZnljWlJlRVFPV2N5UzlJZHB3SUNjMVp5WVdaTzZ1?=
 =?utf-8?B?VHlFeGNoZ2txRXVaRnUwMmZHdnUwek9aeGNiZDNna2xOaWZma2pmQWpEMVEy?=
 =?utf-8?B?V0toT2svMlhsYTlYSGVSMVVXODZUZllZNEJ0T09lWXBqVTU4citLcFdXbzVJ?=
 =?utf-8?B?Qi9Lb2tyVTJqTEttcUs3d3IyT01HTnlwdkhPcWZBRmx2Y3o4MERrcHltWmhT?=
 =?utf-8?B?dGVoRjZZUXJZWUdjTmdlTEJCanprQjExUUwyKytQYlcxN3hlZUZtd3I5N2Zn?=
 =?utf-8?B?MUh0U0swU2JoU0JJb1pGdXQzbFA0V3FiU0gweGt1ZnNYbmdIMUU5YndCRk14?=
 =?utf-8?B?NFlKT2ZIT0JveldyNUJsVUQ0NG5nWXludFZiNUNGNUhxUFRqR3hERDdaMHFS?=
 =?utf-8?B?azNLdmpueGkyR1VqVExwODBiNUNJWFVsN0JJeFpHT2xLY054S1JpK3VQSnJm?=
 =?utf-8?B?ZTM0QnRaaUltMlJENExLNkNDTjIxVXViQTF0c1VZMVlmTGFyc3YwMEZmWkZ5?=
 =?utf-8?B?MTZuR2djZlhOVUo0VEcxQkQvUTRlSllMVVF0VUx0LzBHeURkOFo4SHcrVHFI?=
 =?utf-8?B?TnpZWjVGMzNRa2xETUVUQ3VKcDhrQjdDK1RFeFBZSmludFc0Z1BNSEdSbmtZ?=
 =?utf-8?B?NEtLN0d2YmdMQVpzTGU2ZFBQYTNrQ0Rxb1V6NXZJM2E2QUw3VUlLaVJwUFVY?=
 =?utf-8?B?L2x3NHI1SXkyTkx5QUxlT2t2Y2VSdWd1QTV3UGJnNzd4Y3VaMTRKNndGaG9B?=
 =?utf-8?B?SFVRVTBwK2RJRWllRHlKdDBkUCtwdHhJaW5LbnNBWlJ2NGxER0dibXBmZmN2?=
 =?utf-8?B?QjJGYjd5L2dVUGlsNHExQThhcFg3VUpUZmhCZ1JvWGtkbjM2L2lEZnhFN1Vw?=
 =?utf-8?B?ZDBFdm9vRUkyWkZ2alZCVlg3Tlh4RjJlaW8vd1pnc0VWcElOVjBGTWRyU0V5?=
 =?utf-8?B?UnRucGRUTnIxYU42ZXBxT29mY0dBWnRxNzU3eDRGUVEwZzJqbGIyWTRpTUpX?=
 =?utf-8?B?Q2tvMGJsTnlBRzBWT1BtUm9RV24wVVFyekJqVUxMQTh1aFVhZGZ1akZOTHhY?=
 =?utf-8?B?Y1hGRTQ4aldTdUc0eWphZTB0dHRQYzNvQUU4ME1zM2NzMmJzSDV3OHd5cThU?=
 =?utf-8?B?YmdWajhYRHIwYWN2ZlRDV25WRmQvOGdkemxUd1A1R3hycGlrWVBBb2NTVmpo?=
 =?utf-8?B?bnR3OTRLMHpPN2d4QmVUQkpVb05KOEhObk9COHRyeDFWOXRXOTFQUXdOZHpO?=
 =?utf-8?Q?nvyM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ccb198-01fc-44d4-873f-08dddb542fbc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 17:01:18.3271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jaik2LEhNDqeZzZzWbhJLR6iWzrhkxR7gLl4F80QV8LmdhBSqF5NDNqGNahrHs88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6594
X-Stat-Signature: 9d56qcfcj7r7fxoftbrstd8aoq5tahif
X-Rspam-User: 
X-Rspamd-Queue-Id: B29FF180020
X-Rspamd-Server: rspam01
X-HE-Tag: 1755190881-76969
X-HE-Meta: U2FsdGVkX1+tWGKgPHpZyGPU2J6AiUcNLaudJdJ69KY1tsc1r5APRV/KIq9utXEPkTPyi3NcpbW8lC3aR2MNEmQ6LViKhusiMc64r/KMF7jvX0sw5q459VQyuJHDjmvWWhtLWQqHRr9WAfwuGuCxJ0yF20KDfDyMsyGKjOsf0d5UytOr9/a2qAYFStgPsE61y5hjKFPhtDnwSY8kwvpi5X+lOUqO8f4ebSWmGBn+xgmkEOR/sxdcv8bBrEHgFYKZrrcAXmA/ocXMui2tPtFIt7JtgGvdb4JF0mH0STd8OXNpbsAbdueWLk4xEwb97F8dPKtx6uOfNNy7o7J+D2NBSx2fTwayZ/F0sgQAhet6Pfh8J/3KDJmTUcIa/2U5EwX8Vo1XSYUSBCm73E445tQRFTx7TD6aUvHfrv2RegMtZ3F4wTShH/7QPTFLTBNEyusAxGarHrXWwCuu7sfg/7ylnD6gWzApTCBzUASikn9zbHJnihfdfyjEAcgV7wqzVO8WzGJ9/DIyIl5JwdUURUpuNgCBBGcwnYmLCUkQ/OQ306KJysH+HLvV4/0aXvfntiGGTV7ZNxnb+yamwd961gxQom4/nEbYym/b1CiYx4ja0LkQq6/KqZ5fmSwSKgZrpOS8LQLj6qkcILQHHUeajAmDFPlNhSS3RChKMTycVRChuw3gS13QUaRsUK5ptEGaxlXdTdclR9B+HALleaRHDxIymTUvdpn9b+RKugGIPWUT6tDDBTseIbJOpp+HZVTF0C6odtaFJCQdigWPFiGUeb1osKUbkfAWlZy46qDsnTieAyiAaAVTI9kp2Ss7YBejZ0xih3VCMWdeDlBUAMv4FYSYbcqQmEZ5N7eUv63aWFWMyP6Ge6ZjzIcUc5VFCIYRbovnPz6v5L27VFExRwpyAp9vDwkBliKadAwGBxBX4K2VQAmqdVER//QBFMQi6hJm853xUQQYgDBpdkhhh3GFkGN
 ag5vv5jN
 MKrC4siSJZBDpkvYcLpFpLoPXIezqWlrhGPCPbLEH5TttZGhTYhCOedNtmIfhCMJX8UJ+bUY+lY5Rsi8PvLkz43ujvrJcj5gC0p8vlo7W0T6aVeaFAFw6ZnMmSZCElgZs+XfLI2kmT8+fyU8sc3k5De3jPBrvm6CJvHo0Zy7/4OQMagEBLFPDn01z1SUVP1wcgbNY/U+dHUBqEdZHg7X/ePlseSLjJV7AuJtKh3dycLCMWOMmyvztTDU7SPGuOM6mB/R2t77Yf+ZwK3M9dmlfsB46TSDgej1HDgS0foMKzunSQR4Y6myPW1miGajjNOEUfMey4f3sTn2QKhGodZNXSiwkZx4dx4B7DRbd3S5awefBX9W1RI1abiahUQAbRpLPaPsdeHPjWZKOKWHq7hG9bPtkCF5TMztTrpNfcv3yFBMQ7PqmlNUZ7mMKL3k5ZBTFSvntXMoRAxiGi9HkBScoNto27bnnxOvRNYAYs32uNsRuHhzuLhLL+XP/L8J0WG8se88Em0s1gUWJgBAyCvN7h7dM3Jk3mtM1r6Qg6IcjA0MIeNvU51iIbhDNMvK+jZMeO2xrRJcOa8Ejq8jz2zoawSXpiXVpyllWl7tkADWTs7M3dMVbxbIgx1vcpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 03:05:04PM +0000, Pasha Tatashin wrote:
> On Thu, Aug 14, 2025 at 1:22 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Thu, Aug 07, 2025 at 01:44:13AM +0000, Pasha Tatashin wrote:
> > > +int kho_unpreserve_phys(phys_addr_t phys, size_t size)
> > > +{
> >
> > Why are we adding phys apis? Didn't we talk about this before and
> > agree not to expose these?
> 
> It is already there, this patch simply completes a lacking unpreserve part.

This patch yes, but that is because the later patches intend to use
it, which I argue those patches should not.

There should not be any users of these phys interfaces because they
make no sense. The API preserves folios and brings allocated folios
back on the other side. None of that is phys.

> > Which is perhaps another comment, if this __get_free_pages() is going
> > to be a common pattern (and I guess it will be) then the API should be
> > streamlined alot more:
> >
> >  void *kho_alloc_preserved_memory(gfp, size);
> >  void kho_free_preserved_memory(void *);
> 
> Hm, not all GFP flags are compatible with KHO preserve, but we could
> add this or similar API, but first let's make KHO completely
> stateless: remove, finalize and abort parts from it.

Right, in those cases we often warn on and mask invalid flag

Jason

