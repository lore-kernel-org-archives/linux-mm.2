Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19B9D30CFD
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 01:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2274B6B0088; Tue, 13 Jan 2026 20:44:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA386B0089; Tue, 13 Jan 2026 20:44:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0547D6B008A; Tue, 13 Jan 2026 20:44:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E59F06B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:44:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 764438B4D0
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:44:00 +0000 (UTC)
X-FDA: 84328873440.22.D8F749F
Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022115.outbound.protection.outlook.com [52.101.96.115])
	by imf15.hostedemail.com (Postfix) with ESMTP id A6EA8A000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:43:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=QGYSq4bh;
	spf=pass (imf15.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.115 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768355037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=824dD2r0EPBq49NU/6uFbd38zWw9sUUsrQkn7oqSVBE=;
	b=ve9htngV2oUpFkPk43N79Qpo6/UZhrCWEWKALxXh9Cv88+GchaYHra89s6JkjCtQ1rbXTT
	Q8vCC4qhU956Mg+GXtTgdATtiHWsz9sASvdDdJwb4sX/NlUxnCG/FLJbelj7A5r6V1X3Eg
	Tlg1rV9UzdfPULlYIjVJyDdGVRHImc8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=QGYSq4bh;
	spf=pass (imf15.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.115 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768355037; a=rsa-sha256;
	cv=pass;
	b=0dbIhteFsUYTWM19zmJ3IlA1Sh6X6u9uSN+pArnvOCwrtutOJ/wme15u57HkAPTAjwisM0
	NWcibR+W83i/8nANamxJP7eHQ+BXwy+SFh+nm8S3bsD7zCTwK1fYBAbMlrVsnM0IssRVvo
	7hhyqC+5AyIyYxdyVcugJfq/tkIJaVc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U1m0QIEwR6HSToDsAteMaMyfiOnthxCF8ciqdSoqRHMrtJiQzvs+VxcM71ClykzKEHEoUyFg8jx7vczjxPtXSWE71wS0+BzVKQvbybyu+MYzgag4NGZVeJw+eptqQby01DpBCr+aux4b8j6/zJog+kJpQ6Wi4Qcz67JJLKz6yNB/yveHVqUHj0vNsaDcnlz/VG++cCiVnEPcw9iz5mt1G6Cj5uNX2oqogKMoyp/3J85I8+FVgObA0JWC0Qf9blsHyW5vr7B0vXMdANnhClyOR9dZG7yo952NnlJG1um1kGIhBEKlEq3T23cmU9cFVPYur31rmNH2YEghtaApDIbSNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=824dD2r0EPBq49NU/6uFbd38zWw9sUUsrQkn7oqSVBE=;
 b=segigLJugQ1r4vCpRcDACNawHwQVnB+VnERkUtNlkk3spdkQGuK/yMlVzr8y5XHM7CoBEsUPWHfprBqNKle/r93ToPVEUl9Ep17pMdKEk6AAqEOdwejAsqzjM50GyEOg8PTn0WZjzxJRF5NvupcD8sucojCld8uvHcj1EcRFiC7uHV9EjCVm+rRtsCWLOknqNV8o1nc6C3qAj3iuAC5tQyvjZs2MFErW3jhfwdhof2Nn/9AhWPyV6DiCbqxaibaKqHZ5588gekBv7i1eGCn1bpwktj7svYOH2o+AY+UREtongyJ+kzd4+CYvhCVvkRjmjHahUqG16j0h3JXhV+7A6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=824dD2r0EPBq49NU/6uFbd38zWw9sUUsrQkn7oqSVBE=;
 b=QGYSq4bhCChKSZSJdVJmyo6vLFcT8RhHUhLDimbPmvHb/slooUcGIrIdJ4yuHqvRJtzEw+9Jk2C3cYbaQOV+juqwuj4ncln8vw0r1NgSdyt6fzRMsjzGKQoXYEeVwt87zY0WG+fcL512V9iMEuN29YdBdg4/4dXlUStMSRzxHD0=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO9P265MB7509.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:3a0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 01:43:54 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9520.005; Wed, 14 Jan 2026
 01:43:54 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 14 Jan 2026 01:43:53 +0000
Message-Id: <DFNXJJCQF5H3.LP4C926C59BZ@garyguo.net>
To: "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Miguel Ojeda"
 <ojeda@kernel.org>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Chris Mason"
 <clm@meta.com>
Subject: Re: [PATCH] rust: fix typo in bindings
From: "Gary Guo" <gary@garyguo.net>
X-Mailer: aerc 0.21.0
References: <20260113192949.689834-1-lorenzo.stoakes@oracle.com>
In-Reply-To: <20260113192949.689834-1-lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO2P265CA0396.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::24) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO9P265MB7509:EE_
X-MS-Office365-Filtering-Correlation-Id: cba905b6-689c-4cd9-5f49-08de530e600f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3E1eTJQc1hRVDExbHJTTzJDNjUwc0xOYTNGQUplb2hpNW5uMGs3SHI4SzFE?=
 =?utf-8?B?cEFtaFhGTnJSVlZrOFJWVmprRGpQUUYyaGRXaHBmcjQ3Um40dVJDYTJPeTIx?=
 =?utf-8?B?NnZScEQ1UTJ2RjVtMVVpVFU1VWJSQWZzcUUvOVVRZDlrbk9zNVVOYndKMXV1?=
 =?utf-8?B?c1VRSWErRWIzSll5VmxkdWZCSElhVWlrbStKUkMwckgwY2pjYnNsbXI2RGNK?=
 =?utf-8?B?WmhHWE02Z3Z5bzVib1dOWEJObldOMEdvc1dYS2NlU1lxaUxrWWVScjYycWd6?=
 =?utf-8?B?dlVNcC8wN3NDUlk2T0F6U0Z4b0h0Um5icXBJajdPM2dUOVhkU2xPKytXZ0tG?=
 =?utf-8?B?L2RxV0tqYUp1MVlFM0p2Z2FIUDFnbVNWcmtlK1V0YVljTnRiZkFEaFNaK1h4?=
 =?utf-8?B?MU1FalNuSDJIdnRqZEpXTUtkLzlIUDBxY1F2N1hSc2JDSTN4bCtOL2d3bmNs?=
 =?utf-8?B?UzRBMktpYkNEb3ZyWTNpUjZ4RmVXa3MxQ1lNT3lRaVg3a0lrNHo1SXY4aDdq?=
 =?utf-8?B?ckI2elhYTmdDa2NEWjhmam9NZzJqTktxNUp4NDNZbVl2dEtmYTV6Nm0xYVh4?=
 =?utf-8?B?c1dWald4ZlBRS3JVd01MSXdvMUorSHpteVU5RTZWaTIzb2NCeDAzVy9BUnIx?=
 =?utf-8?B?cFlMTzF6bE1UYnNYeWNERmQydGs4S3d4dkUvODE4N0JjMk10QWdhY1g3S011?=
 =?utf-8?B?OG83WnVlVitZUDNia3RGMlIyRzEyMUV1eHFMdFVncStFeXNSeDZna0dXSWpG?=
 =?utf-8?B?OEYvVVVYZElkQkxWNW1rUTVrTEc3S1RON0FURnVMQllpdHFwUmhIZjNzcHM0?=
 =?utf-8?B?endnc3hRU09oM1VvQTVNbUtEUlNGakpSYmJoMHh6SGdzUCsvSXI2U0pxWjdD?=
 =?utf-8?B?ZnIyWkJYaUJ4UnVHTlRsUE5McTA2VDlTN2RmRHk3RUh2ZEtVckppUGdjMktC?=
 =?utf-8?B?bzlBYVExakNkTE81M3JrK0dnVE1HV0hWM0FQSk5ScnQwb0pWQmZLSFFiQWti?=
 =?utf-8?B?dXdJTzBoQU5lQnMyeTJmNGh4UHFnRjhyUmVsNGpoRVNnaWZ3TVR2RWhpeWMr?=
 =?utf-8?B?V0NLQ1VuZzVGa1JURldmTHFMN09mK0toZ0hZcFdSZnZxYklhZkp1MklxRDh2?=
 =?utf-8?B?UXA5M3JGT21JV1h0MGpJNWxpMHZKdmRRakYwSmJJWXBRVFBIaVZBRjIzZVA2?=
 =?utf-8?B?eHpQTWo1cGt1eU91Y2NDTmJneUhFcGFsbFY3VTdqM3p1cmdCYVB1bXh5Q2s1?=
 =?utf-8?B?V3pQbDBpUCtwblJIMjhrdnhVZjA1US9XZFRJdnhyWm0yMlZxVCtFRXZIN1NR?=
 =?utf-8?B?SFlreUlPb0svalg2aHVvbklHMmhieUU0L3lNTzB4QjlHZVJZK3Z3TWtaUXho?=
 =?utf-8?B?UGZkVHR0YWplQlRnMjhYWGhBRXpLY1hMTXpUd1hBb1Zyc1Z4UStVeitOUTdS?=
 =?utf-8?B?aGxRdC9EZ2kyMk45Sk54bHY1eVpRc2h6S3hjYTAwZGZjYytEVWZyZ3VHWmw1?=
 =?utf-8?B?VUZ0Qyt5MURUQ2RDbHFkWWMrMENNNi9yVHYzM3EvTFdacThQNmEzOWlLSGF3?=
 =?utf-8?B?dE9VRFEwSGxCNGhsbVQ2MU1rbzNmQVN6TUUwS1k5RmVUSFl3UFZycExPbnVW?=
 =?utf-8?B?b21HeEU3TXBlNTVpbmNoTTJMN09yMXA5KzFhbGVFb1Q3MzljKzlmZmJ6Vlk2?=
 =?utf-8?B?UzAraU4rZVE2STJiMFVnS3Y2NzVZMWJoS0RlRUI2SFlaR0psU3pxWUxZdThy?=
 =?utf-8?B?UUsrRU16clQwbUxoMGFRdUtLdk9VVmh0QVNyZnhTcHBrNFVtRnFGeDdnd3Bl?=
 =?utf-8?B?TytxK2dsZzlmazVPaTNlZXVsbnlNYldqTkMxd1hVWllraWhXM2ZBV2l1QllL?=
 =?utf-8?B?dHB3WTRsOHkzTVNwK0pnSjlqZzJraFpkK3IvR0xZUWo0YWNzeVdGck5ITmQ3?=
 =?utf-8?Q?k6eeiHEeipWxDnM9G+M2k+5vPni5G3AS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bm5LM1hoNWVXRG1Qa3ZjZlkyQ1ZlL1dlbzdvRDFrazJiZU8vLytiMldvdE9u?=
 =?utf-8?B?L3o1d0RkcGtCYzl4bWU1MXhZWnlUbWxUdmE1Wkl4UkkvUFF1RmZ1VlNZaWRD?=
 =?utf-8?B?VlZIWXFxb1JkU3RUSzZPM1BPZlJ1TzcyZ3Foa1BtNVRvYTlTUjgrNWhQV1Fl?=
 =?utf-8?B?Ri9rYXJYTFFzK0IvcjdZYjlMaFM2SG5Sd1Ftb08vdnhBNVdqNTlMNW4xNUs0?=
 =?utf-8?B?cGdZOHh1VkhEVEFsemx3N3NUcjdJRCtMTjNTRjZ3NkxKa2E5OGNxR0lUdTRV?=
 =?utf-8?B?N2ZTSDdzcHRsNUxLUHVvRGcvME5Gb056aUVjamk5b0xFZHVtZzMwNnhlY2lQ?=
 =?utf-8?B?a0xDcklWTTM5Rk9PRHZyZ3p6eXpseXIwYW1KdDBHcC9oR2V0a2E4V3JUelQz?=
 =?utf-8?B?UjZvMEt1Y1dzQ0JEbG43eGdqaXU1dXg2dzhRNzZMc2JXM0pGTGxraEtYNDNj?=
 =?utf-8?B?Tk9mWElnb2dKMlMzcU91b1NiUW13Ymlrd2grMFpPM3FLSFloS0xDbm95eGZB?=
 =?utf-8?B?NHdNNXd3aGkyZVpkZWFsd2VUZkV5SkY2NjFKZUJ5eW4vYUFhSTcxSktqeVd4?=
 =?utf-8?B?RXNuaVFhYzR0UnpDcjE5ZklRUE9EcnFwbjN2eTIwUnc4QzBFaFBWWlg4Z3Uv?=
 =?utf-8?B?bHZSVHRJRWZRTFV0V3FOa2RFWHRQdHE5aVN6TnNNTXFCMUNCRXNTbUN6YXgy?=
 =?utf-8?B?ODl2TEgvYkFZRzRCc096cFpLYjBEQVlaQ0VCQnlvcnh3WXJkSTZ3VzFEQjFJ?=
 =?utf-8?B?cmF2RElNVUh2cExXd1lhalBIV09xWURoZnJ1NDdOTFNMeVhncTlDdVExVHFG?=
 =?utf-8?B?cVB2cko2WVJaNnhzWDFYNWpNeHlCd1NTZlphaEdvUDZDWFpxcGFYM3c2Uzc0?=
 =?utf-8?B?MWpkZnlJcUVvUjdvb1FpVlRvaEk0YXZtVjhOMEhYUEp2UlJpaTNlWThIVGxJ?=
 =?utf-8?B?d2lnbzBmbEc5Z1F6SSs0T0hISmhEQ2NTRWR0QzFJNWNSYUt1Q3lIcHE3aGd2?=
 =?utf-8?B?cm5Ra2tPQmdnMzVtUUM5aXlmMkVwY2ozdURaQlRxaDlMT3hvVDVzMGFRZ0FM?=
 =?utf-8?B?dGx5YUI3d1E4bTFyRVplS0FvNHJRU254c1E2MERTSlJYQ3pEUVBYdDlRaEtY?=
 =?utf-8?B?K2o3Y1dYazNZZXowNlEyUFAxMWdBUlVsdlE3ajB2a1B3UENXcm1sVUZONXdU?=
 =?utf-8?B?Z3pBSG5jR2F0aWRKNGtieG9JYnNTT3JzWWVsTWRUeVdhbnFhSGhIeFhTOTVO?=
 =?utf-8?B?eVNKeUVWWUZQMWVRQTdpdTE1TDl2TEkwVjZaNk5nY1NTcDAvZ0ZPNGU1SzhQ?=
 =?utf-8?B?dGxEdmtxQTNJQUpVUXU1U3pobXZmQVRodWF5TmwzRnVWd3N6YkRWNk9tR0Fp?=
 =?utf-8?B?bEVPendISUx1dDl4Y2dINzBmd25vUDRGK3lZc0JscG5hZ0p6WXlNdE9LVGth?=
 =?utf-8?B?Z1JTQlJUYS8zenlMa2pVdERDb3JIVVVlcjQ0b2JJekVLbW1QWVd0a1d2Uzlj?=
 =?utf-8?B?RUd2blRoblo3STdpOHluckM5VUpBRWpCWEFxODk3WlVGbFFHaXZWUkdNbHZ0?=
 =?utf-8?B?ZHRxRi9hR2NwUE16RVZOejRqdEQxTktGMHVCMHNzdUZDaHMrcW5xaWhvVkE3?=
 =?utf-8?B?UDZzVmx3dlJuaDZxcW9Jay9ydTFLbGhYKzlmZENibEdKdmhISGEwRWJmQkJw?=
 =?utf-8?B?U1FxL25sbnRrcnQ1akJ2ZkU2VldzRHprRDVWMmczbWp2Z2RhdFNPWWowaytO?=
 =?utf-8?B?ZHdZcFgxVHc3K01XaVJ0UVM1UnlleWVwNG85K0Z2WDBkZEVOcVBIMDdMTlZK?=
 =?utf-8?B?ZDlUTi9wZkg0bTIyZW1hTnVTOEpuQjg1cmVuNWkzVUR1VTBLcjRVU0ltVjMx?=
 =?utf-8?B?d0cvVGhiNEpYRkxGem0zUHNhZzU5N1RTWDhlaVdnRVlxUEQ0NU9HSWJLSXVK?=
 =?utf-8?B?UmhLQ0U5dWNPNURidlVzOVphOENNeXhsRHNEWUJvTy9RWnpNeStWc3g1b3cv?=
 =?utf-8?B?N256ZDVaRUcxWDhKQnBvdVZLdzROcVBuNm11a3NBM041dDVIekVnLzBlNlVh?=
 =?utf-8?B?VzVHamIrbko0YVlHUW5jTWRkWnFENVhRSkM4enFETHkxdTZ0T0QzS2R2R3cz?=
 =?utf-8?B?VG94SVg0MGgzd2xmaEhmYzE3NE40MDdZNWgvQk1tbytCdDBpdkF0THJLTmxZ?=
 =?utf-8?B?Q1N2TkZiQXlud0pFd05hWGUxU2Rrd1M4dnF1eXlVcDlQL25qYThIVXBiNHUr?=
 =?utf-8?B?VjZPZDgyOGRuRXdibDg0bWdZRG1wU3VtcTI1VWpCcDFBbzEwdFlMa1hCM3BW?=
 =?utf-8?B?VWhGSkFmWVpLRTdBcmM2YllsZnc5YlRNMXNpbGh3UnpVMjZQY1Mydz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: cba905b6-689c-4cd9-5f49-08de530e600f
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 01:43:54.0264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q72OLJ0QDzloHq5hVgW0jcSI3w7lq3FrL+IejblZgoCkgfn/ZZcTl8N3a2GAg7NK3Dv/11rLzKdbD+DGL1dw+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO9P265MB7509
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A6EA8A000B
X-Stat-Signature: n363tub7nximtupqosjj8ki8iksb1jn6
X-HE-Tag: 1768355037-699719
X-HE-Meta: U2FsdGVkX18d17nu0gVLVrNJEmR6reBXL5Pyz6pvfuZUoVjCpeaU7PEHB9xCe4MetF22U3b03KlTPASMyrm8zhr9g4MM6pvlQTXt8rCd1z92UzQPZdAlC+fCNmDdSg+vIUCaB8AHj/meysPa7PWZVM4gGQ8l/Vp4Di9Xt0bFQ4Ek3v9selfnm25m2zZm/rPD0DIHz7bsnc6zrH0RcXdd9jJifupV7fZEPvxGgFjgFmGo1gJYLs7M/rqnPAEzgLDIdv9bkr96/tr/eo4zXl7Y0KP1pwuCFehnqnnLLumcTg9MhFtfSkyBcRM3RpzjfZrwc5DExp3knzRIPs2Tsi56KrxZAhX0e/BtsQN1EGQ65OtcshMZEhG7QhzcTVyVDfWOvh5xbd4ozzgEdvfctmAuCCsqE02Y8P0CXfXX8wLw1gBYggRU0kMZRNaQgWYpGQHH6kFFwB2nYBOmNXGIyfbWJwQwZfS5N8vImuk6IP1kX1hPSAQlkA720v2WIMF9AIp+w2oOZnhFBGxD2o4H2lxYO8sBEpSi4UpX4BD2ym1+nXUDXcjcdmvwrah+fBYXyKeV2aBPYAVLgXKPpnSjxcdwnfS9dHDiFxa3B2bSueJRTmTWR/Co3YWk+YRVyISWtZDY3yiAqyX204qQk+Klen1xMz+66CFuH9vBEM86V6WXRqqH0tBfNJAJvAqTazC1VlZSwrZRHRjCAyXiyyuqWwksE7gycIGR2JYUIh9OuBTGJPbNWHU+VjgPB55176eM0VPqxHt1R2IYg/qxjWaw7GECrUVC9X1ECSe7YG4KL5TzL3iB9ZnlzOIds1q2K2nhzQEaP57os/Aa1a5BGlxOAsxj1Pz9AKRLcnlK2JiW8UZfRXt+DIsmwi9VmmTOmRY7Uid/0ORZSMY/eLhR8XrDPIG0rK9Ox2X1C6ell3Z2JEugno9/1dErJue9Xz6pK7WtL83Vo3zmlMY1k0rEWTVe7td
 VmEdMd5p
 parLtpHNBunlnd5GPIQHOJrPloIjBP9OZbdJBjOQ1UOj9yy1HiWc9zCqExrWVsdmZ8XtOGCYsquK17GB3BIfwZwU8cz4cEPkgcKaiHropOFXnHLpht1G0boVBp6J6CicOkDNVONv0uQoSOprvgHyqloR69ekIA6D/usxd8cuNV9PiD8/pKHL3WO4goL0anwudQYclrBNOiWeZXgNZa+KrXlZ4hOdbQGG8x73XTgnDDcoU3JpqwGTQ4FB5aqEG2FGlYxr+Jrfoy2kSDEi1kLfdfEIkEBoOLYrfZGM4aLy6DWou62LSgODW1yvcLKEaFV+vTNue/XiARiMRSOP4EqQUvCcpy/MZeLpYXOXHiB2ZMrCzM8N7pGTHnRssIVv543iVkiXbmrvw0Oonx5uzh9JP8+rQMC/PutgM5I5x6MP7rO7MS8JBtk5x+Vov+ylr1yp7Xh1x7lh+tWkihgAkAysta4Q0dEZP2O0Y+u0/hEhAneESXFhbfvYuQMr27mkuawFoXNVYNd+wuIJrWdIBwj2Al5kRbVfFUr7LTbl+PtYr1dF4WFDN6QBO7mJ9n2HIJTk1qIGKWQQ4vazamzSSuTH1qCz92QWEj7l6ikFPh1DSRLn21V0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jan 13, 2026 at 7:29 PM GMT, Lorenzo Stoakes wrote:
> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added a number of
> overrides to the rust bindings helper as the change performed in the comm=
it
> caused the rust binder to not be able to automatically determine values o=
f
> VMA flags.
>=20
> However a typo was introduced leaving VM_MAYSHARE to be incorrectly
> interpreted as VM_MAYEXEC in rust code. This patch fixes the typo.
>=20
> Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
> Reported-by: Chris Mason <clm@meta.com>
> Closes: https://lore.kernel.org/all/20260113185142.254821-1-clm@meta.com/
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  rust/bindings/bindings_helper.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)


