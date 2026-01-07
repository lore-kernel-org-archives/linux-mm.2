Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE63CF6BEA
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2620B6B0088; Wed,  7 Jan 2026 00:13:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210026B0092; Wed,  7 Jan 2026 00:13:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5846B0093; Wed,  7 Jan 2026 00:13:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECA876B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:13:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C95186D84
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:13:04 +0000 (UTC)
X-FDA: 84303998688.10.15727A6
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013081.outbound.protection.outlook.com [52.103.74.81])
	by imf25.hostedemail.com (Postfix) with ESMTP id 35079A000A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:13:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=DEy45SNE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of WangzXD0325@outlook.com designates 52.103.74.81 as permitted sender) smtp.mailfrom=WangzXD0325@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767762781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pRWkGssTABUN2NIq8Z0FukwXN7m1p1aQvRIV0QGdEoM=;
	b=guyHeaHEnV/UWyex+WOz56YRrCw5IBsECVsHqNC9mXIt7IncJ9bS+WL5XuTsuwRQE1qRHA
	a8aSnoGTQ18Bp2L6nSTueGk/nBdYJBkXGtYXLrxLbJ+8HI7AYLh05DYHYCosDVIr6xONld
	fO85H3NSPVw0Akt9RkqWJ4X1LYwD0jM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767762781; a=rsa-sha256;
	cv=pass;
	b=bdhgznDFiGOWLSAf2hw0I5h6mUmMONErHhWM2pR5EvXjnctYPflQMYu5BPRqS+b5lhBjtm
	WStuDkbHLLAH0OccPtm8qKqCiHOD82SPRykSoSA++5uZ9UaVqCZ9cAn84W33FjTpNHWkYX
	dpcpNTisxio6xoSEatgvYxKp5hRuq4g=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=DEy45SNE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of WangzXD0325@outlook.com designates 52.103.74.81 as permitted sender) smtp.mailfrom=WangzXD0325@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lUzi4fVYzQwFij9MUiqlzNE4eeArP1BfSuEJIP4jEbtlILJb2tPmX4cXVhlGnzIrmCrJpsMM7BghUGqZTZ5VEVP9GKZ1T3n5UPUyYVkgcVoOwgT+WuXVFkpbL4cRjh3MfjNr3mi1SRiC8ZyXx4gaQCYFdS0TDKSDNJOCSD6sxbEnfqEh8r6gXNzGcg0ypYDlSfmL817wBdNd15EfTRuSkbvRTn51VNckXKT4gqNdCc8EKGoT1TWyIRyX8+5TwDq7w6yHaDyLZOO50nVGvzEMqIxX1pyV8mfeMUbHruEbMbr2ZiRAzkx+tCHiVTq2cFqawxzooSOb2CC9DTuMUioVIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pRWkGssTABUN2NIq8Z0FukwXN7m1p1aQvRIV0QGdEoM=;
 b=Oj8Mz5NBMeL+TOF/JrAVla61stPCXuhvk0AOV/wL+EcldQTlXgb8UADCMk5L7VwxdGHTPT779jWcj/NwoVS5xGD4OBxjMPpyVr/4132CvpD1xDPf8xLADhM8+IT4iDQz5TjCuMM4LEHmW21KvRJLmErUpFnw0TAvsRqxWNTxmxE5aw4LZ4ioH461F+jufknj+L7J4sOOFoIKeNkv0vmGv10jLMn8/Y918AKr3gJgFyMY9amyhFt7WmaN1wpXjh/pqOA/vgqdDlrAZ1dXhP49XirN+oPKaS2q+YYj/pKYaS7lHovStELqMHOao8+R2kvpKqvVmIeQP38uMG6y4SeZSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRWkGssTABUN2NIq8Z0FukwXN7m1p1aQvRIV0QGdEoM=;
 b=DEy45SNEKZzI4HYcfsJzLgRgWBmaWw+FHJBGVcAJIX6Bmt9b/TetVz/Gt4BGb/7FvuyTR36d7GHcs8Qb5Du920NXk7RVbP09011R1mjNViCqeahhPMh4NRLLqbHUU1oh5joeRMA1JCkvg4+pSAw2NDG8T0M4ih5scl/ZbtZKz3FZmlhbCruK62uhLxu9z7QGZg0FuvLSz6vmD04+2s6oh0G17PLoBTswiWqZrjkSZzbZVkV163Z3k0pDOnyRKvSSPECH9e4xZ4hx0+4G/jW1A/6kTvE8BHgAsqTxLiUMd2GbtfCwHVJyF/n+OM1AChdwlbjYUmU6OBRnECenYD44pA==
Received: from KL1PR03MB8800.apcprd03.prod.outlook.com (2603:1096:820:142::5)
 by KL1PR03MB7696.apcprd03.prod.outlook.com (2603:1096:820:ed::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 05:12:54 +0000
Received: from KL1PR03MB8800.apcprd03.prod.outlook.com
 ([fe80::95dd:dd8:3bbf:2c16]) by KL1PR03MB8800.apcprd03.prod.outlook.com
 ([fe80::95dd:dd8:3bbf:2c16%6]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 05:12:54 +0000
From: "WangzXD0325@outlook.com" <WangzXD0325@outlook.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
CC: "rcu@vger.kernel.org" <rcu@vger.kernel.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [BUG] rcu_preempt self-detected stall during kmemleak_scan via
 debugfs write (6.18.0)
Thread-Topic: [BUG] rcu_preempt self-detected stall during kmemleak_scan via
 debugfs write (6.18.0)
Thread-Index: AQHcf5Lg/18E5O+qc0mVXdIQdmTzlA==
Date: Wed, 7 Jan 2026 05:12:53 +0000
Message-ID:
 <KL1PR03MB8800B64AFA0A40CFF301C50CA184A@KL1PR03MB8800.apcprd03.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB8800:EE_|KL1PR03MB7696:EE_
x-ms-office365-filtering-correlation-id: 6fbae254-52a4-462b-5155-08de4dab6999
x-ms-exchange-slblob-mailprops:
 AlkLxVwsndl/rxNUOXMa9JcMokG6ISaNqs8stGBjwR82Vei5ITA4HQvHs61041IYzvHjQ3aCE4Ik1VcGRv/ySxKilSDA4jMNUADoh8NsqRMFJ4AU5ULYle019gHmNPf9X00i1Vvc8zOoqjHkiSwPtQn038cUq130VuPRw2R2ucqP0X88Xi4ntenA6O/eehT8SK0MO8CR+JvfR2Agr3LnyhB8nHbZRT9iLlB9TU4tlw80RTCXQ3Lni0ZKyKwEoJNfelU8oLr9xkKQKtY8ZTjJL7jhrwTWTgcUYxwn6Lzukf9ViZ9AGFHVKMOGgOa9nudkEfQYlXNG4RoLsQyBNPLGktiSjkUIz+sImC/Uh/mswpMnueSO3q7+SQveLNy7rH4g6nmAS+NF2yOnjBEcSHRCHhNT4YEUzHgPMXH9nSiATGYo9F7I3X0on+lax7oZPfK+uG2VSqrTmu/s98eMUwyPuoHmGqlj0c3VRrIG5cKw3yyZKpXZ3QXQk0jqwd2jD7WKvLW4xbMllQpo5UNj+AYI7AqnLn5YiWjLyrvg/1+Pd71LgATkdII5Lfg7gEAtKPL4m0eAErD44xnisWXCSTJceFySgoCrQNaWwa8txcKBnQUNP21zR8YQpQdrexxWfP6arYAYLpE9gYraL3E0un5zp6kotjxRhRHfDNyW1NmlwTwrPrV2y+N/+E8lGhb+VDOjw4VVQtEg0ae2WCbDA2HrskxcDTcyocypt/7+2yVvj/tn9IwjPiYzRpcJhAbXC8b5Zc5+UixTbFoYlJ14nE6bXWFw1GeGsZo9
x-microsoft-antispam:
 BCL:0;ARA:14566002|39105399006|15080799012|15030799006|19110799012|13031999003|8062599012|8060799015|55001999003|31061999003|461199028|20031999003|3412199025|440099028|40105399003|102099032|3430499032|26104999006;
x-microsoft-antispam-message-info:
 =?gb2312?B?cHFWbG14YnF2NlF0Z3J4dWVQMmxsWVNLZXU3Mkl3TEhObk1yc0xScXBlQzB1?=
 =?gb2312?B?Q2VnbFdJbjcyZFduVFIvdXlON0x6M3JNSm9NZjZlblNsOWt5SzJqMU5PaE5J?=
 =?gb2312?B?Tyt3aDRYNHBBMG1XT3NQVWwzMUpDUnRIdE1IMERnK3pOdUpKWWJSc1FpVlAz?=
 =?gb2312?B?TjBVb0NaR2F2a0FmUmNsbTZpanF3RmhMS0N6ZUdvVnBiZHhacFozeU1vcVpH?=
 =?gb2312?B?NUFpTU8xS1NjdFNJTUJsSHJyZWVMd2w4MHQ1Um51aEovUVRWRWdrM01DLytE?=
 =?gb2312?B?b0Z1Tlo4MkNKcTE2bHcyM1ZyY1RLWi9QS1lDMjVsU1UzSi9Fd09XcmE4UDBO?=
 =?gb2312?B?bTBlZXpkYnRRUE5zeEFXQTFoRWlJZkJUQjVTNC92d3kvSkFjNmY4L0g3cENW?=
 =?gb2312?B?VmRFYzV2OWVoMTVUUUtpOWFWVjJIamtlZzZkUUtNOTdMQWVDdEkvMTJocG93?=
 =?gb2312?B?M2VLWnU3NHJ6Wmh2ekllQVp3TzJBM2FqaEZjVEpQZUduNWl1QWlabkFNRHE3?=
 =?gb2312?B?YzVaNS9LVlY5OUNCQTFvMHgvaGJOTEZSN2ZJM2IwZ1Vyb3F0NmlOZlpiSGtW?=
 =?gb2312?B?Zk56dGZKZHFDNjZ4SWlNbitCUWZPMHcwS2pwc1RRdkhPRnN4bWVrN0g3eUFP?=
 =?gb2312?B?Q3J1NEY0czBNbnR1Sm5HY2hvb3Y4OVlxdk5LdXVDclJsR0lVLy9Ka0FVWDBC?=
 =?gb2312?B?SnBtNTVpNExjbjZwV3ZTTUZHeCtraDF3ZjZGZjlrNWR3bStFamx4UGRndFB0?=
 =?gb2312?B?MXpKNkxWSDhvSERjUmNvcjlnWEMxN09WNFFhdU9HTFJWbEZCY2JQcnZLN0Jp?=
 =?gb2312?B?U0VVSEJPczNudEtzUVM4TWxKdGFsTlZaZXVTQ3JxYTJrQTJiVytsRGt4enRq?=
 =?gb2312?B?VXYxU1R4YjBUWWdNd0ljSzlUd2lrZTlySGd4RUV4OFJFME91cTFHUktpemxI?=
 =?gb2312?B?TWNscDAvbEpRUERhcEd6TURrRHkrbFBZb1FzSWNOSFkrNi9qY0hSYUJhOUpU?=
 =?gb2312?B?SExOU2NsVUVQV2FOVzk0R21GTDZGYlc3aEdiUU5nR2hEbElyUHBZM0FkTnd5?=
 =?gb2312?B?Tk1jcUxzOHYzemZHY29GcS9zRy9TbGNFK1lIYTJBMnYvakNIam50OG9rcUpu?=
 =?gb2312?B?Uyt2N25SdTdqc2ttR2xWWXNiUjBJdGZ5T0N1QkZIdkZsN2FNTURIL08rQk01?=
 =?gb2312?B?SFN0cG9uZFJqNmNKTFZ2MSsyNVRhOTdVM2ZMSEFWMmhDMTlzM0lWV1FoRVdx?=
 =?gb2312?B?QUZpUXNWRWprVmNIUGFCOXY1NEdOTjRXU3JUVGtleEFCcnZiWitsd3lyaFhy?=
 =?gb2312?B?SFdMcVBhdEZCd2I1bTl2TldiVVNmRGxDczIvN1FzdEtsZHg2eVpIL1VIZEVC?=
 =?gb2312?B?djNQbE9jbmx5NU12L0krKzFHdmxnbnJDOVc0VFUzMUFyb1Z3SElZclZtV1N6?=
 =?gb2312?B?VUpTMWlZNkFuZ1lKUTVvUTl5WExxaGpvcFEwaGhQMS9ZdFRzam5IVWhSTUVi?=
 =?gb2312?B?ck4rQUxoMklYbERqQU9FcEkwR0d4cWhqREtoZU13L2xHL3FNaEtYeDcwQWJG?=
 =?gb2312?B?VXZRdGVBdjdhSVplaEVhU2dkVXRRYzhuZVJHUGlaWnM5eUx2TndxWk9nUi96?=
 =?gb2312?B?NXRnTnFqWFFmTUhpZUxackhUMzVIK2JCYTFqdVNXajNYaVJCa0d5OE43b0Zn?=
 =?gb2312?B?YmY2Vks0aVhJRFdVeHdoSmhiTGtCYU9zZXJmMmx0dXgwQm9vS2VIMFQ5OEFP?=
 =?gb2312?B?SmloT2wzdThiTlhoVEhpeU84S09wdDJKWWszRm10WjREU3JYckNoSXMvNkor?=
 =?gb2312?B?bHRwc2JOWGNodTM1RElJdz09?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?Vkh2UjhySVU1a2N3dWxSTzdEZnBZd0x6RVBxWWtCanZYZDBnN0I2RTZFdGth?=
 =?gb2312?B?cjRmVWFnU0ZEYXI1azhIRWVOQ1N1YUpJUkMwNVB4ZzJBWFFxRnl5bXBzZkNE?=
 =?gb2312?B?aURRVmh6WUo4THFaUkZhWGtpREtaT1lZM1ZoSjBZMGZXaEFyQ3JtUFBNWEpR?=
 =?gb2312?B?dW9oeERWSTN6OTJPd0pYemo5NnJxd1ZHaXltd3RxSEQzdkNFd1REVm9GMFlx?=
 =?gb2312?B?YWo4bW8wOUVDT0NuQndTc2sxVTdCdU1vNm8xUS9XTFNZenM3Y21ZWDNvRVYy?=
 =?gb2312?B?QkVjVk96cjdhazV0azZMeUROaVRTaTJjU2xPK1dzcmNuS2tQMTB5OWhVT1k1?=
 =?gb2312?B?RnU5S3VLVnY2L2FHZ1Zabkxrd3E0T3U4dm93SHBQSFVEOVF4TDBMOWFJVytr?=
 =?gb2312?B?ZWFPY3o1ZjJkaWo2dHFwL0JPNHk0bDY4L1ltMmkyMmliZ0tFQklIQ053N0hv?=
 =?gb2312?B?eXZSOWNhdkNLb3p3RGlibktKSmE0OERkMzBGblFYa2dsS2dIc0o1d3EzRCtm?=
 =?gb2312?B?ZXhJSHdJVE8yTjUvY25yNkM4RFNOYTU1KzF0U1l6WUpDRGYvWTRld0xpOExt?=
 =?gb2312?B?ajBRQ3R4N2w3UGxCQ2QrdmZob1JNTkpWY1R4T0E4ZjJTR1MyTGYvWlV3amRt?=
 =?gb2312?B?dks2aFU3RmR5QnhuU1c1TndUU1M4QmlKUXRWU08yTWZ1aXI0bzhCQUlzVTg3?=
 =?gb2312?B?MkYrTWlVdXlxald4cHpzR2dEbEQ4ZkMwL0pyclBZVXNXK1huc05wdklUaW9y?=
 =?gb2312?B?d1F3T1YrQ3VnQVFWZkRjekt6OTJEblRaUkRGdUJNV0loWjZWRktleGFCemha?=
 =?gb2312?B?Yk5IZGszWm91bmtCVU54VGJzUHhhQy9OUEUyT3kyZ0Q2ZnM5SE8xYU5XSkIx?=
 =?gb2312?B?SWpHZUY3Umc0Tk51NkxKTW5nK1UyUG1ON3QzNHpXZStQOWdIOVNPamYzekRk?=
 =?gb2312?B?K3pxU3lNUmlydjlZTjlFbmhJK2VySnpCYW9UWDhDRzdRT0Y1WW10Z0ZsL1dO?=
 =?gb2312?B?QzlyRDlweFhSL010bi8xS0VrVVhkZ2hXUjUwcHM3Wm8rSTh2R2NLalg4QTNZ?=
 =?gb2312?B?MVpsSFJLd2ZLZHNqRnkySlRGcGVrTzJQYUEyUXg5emJUWCt1SjhDNURnUng1?=
 =?gb2312?B?am5OWER4dzNtWmJHeEZLblVVanp1aC90ZlVib3VMSElHYytEbU9FdXFJaDI2?=
 =?gb2312?B?MHhHc3VoWWpra1FMV0puM3V3UlZkWjlBSzJDMnk5M3Y5V2pNNlUybDRWSEYx?=
 =?gb2312?B?NDdRcDhJVUhhVGlJVjdLZi9kS1VFZFdJV1lTUlNqZjNwREhtaUxpWUxVWVlW?=
 =?gb2312?B?QTI2bWFwTFhDeU9iM1lsRC9IY3pqZGdZeUIyT05qSGdBRFhYTkJkeWlOQ0pR?=
 =?gb2312?B?K1ZBaU1IbDdOQjZ1WE9mYm9kNnEvWHhTQXRqNlJsWWhUeHhZek9OSy90VGIx?=
 =?gb2312?B?RnJqdGl6OXg1d3dMZUxxNFRHbVRZWHdQdm1namtJNXphWTN3aVo1TWNyWFVM?=
 =?gb2312?B?b0l1S1lqejAvR0owbkhCYUN3YUFIRUcwYjBUeWpBWUMya0FySTNldThrc0w2?=
 =?gb2312?B?ZCtzaFVpK1dZL1lrb0tUU2dDajdVOEg5QVpwS0lLa0NTNVRMTDBJQ1o4d1Z4?=
 =?gb2312?B?d0Fic3Mzdk5SWDBONzNoMGFJWkxGRzJEaGtnZFNWLzlIeEJkLzZSSXVZNjky?=
 =?gb2312?B?VmVoSXRxTHg0UDNucE1zMXJxdnFkQ2J0azM2UWtoVDNDSENOcnZHRUl3VjdE?=
 =?gb2312?B?Q1dRUk83SGpXK2NQREVmNEV4TmtQZnBXd0tTdzFYMFd3K2NuNm9DV0Z2Tkhm?=
 =?gb2312?B?SXBadEdaSUVnYlA4VkFsVjdxQlBaQ3ZGNFN5cWl6VEVlTk5FOUJZbG1EZ3ht?=
 =?gb2312?Q?IIct88oPZAg4h?=
Content-Type: multipart/alternative;
	boundary="_000_KL1PR03MB8800B64AFA0A40CFF301C50CA184AKL1PR03MB8800apcp_"
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB8800.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fbae254-52a4-462b-5155-08de4dab6999
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2026 05:12:53.8336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7696
X-Stat-Signature: ynb8u1o768am48uoef5fc7qeonr4nbuc
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35079A000A
X-Rspam-User: 
X-HE-Tag: 1767762780-580215
X-HE-Meta: U2FsdGVkX191FP8zoHhljvEjKP7bTX6nH/ssLu/or9GblRn6whAN8tEAvzHxDK8xk5TIl68E0l30ZLbXtoc5tM8y1O9ulhfWt7NuWL4eex5npMQA6GEgWS1Uov1L+TV81fa9oBd/+a+l2DCdbGDGIOpemi7GktO6ygPDnUUJnVBtzqJNQL6SReX+f7yyBByoZgeqiHr6fOpyHcH0Aa/wzcZahTLfOVTHKun8ONsUQhfZwmJE4OnGBk2f4eW6RHudc0XLPIFP/delK8SSYCTHtuIWqRv8oXZSUBWKKVpZWw5G1hJFTnZ+YmdHmXbQL+aSi81wytAYhrbxliVkmDBSAPI8HgpbmhAZ4gIyqJ1o5cnGZddilEIvmwwKL6E2O3XkKPBTrkFWQ8x5RYsgxNWt2cNWHlOkKdcrAbKWTIONGwYmRy7aaDR70C45fRqwcUouwNHN/JHwN4rddwChYSZyitkRiPuOhrv0GyRzeZr/MO61wvYemXHkaT4MX1RlcLPY4V/z0hxutWof2iE9qMF2LwDcOxJfFmTH9dkIVKF9fQYHwCL6Yf7h2H+bu3cItiPw+Kxn/FEUXDQSKYJIPefZZhL/9zTQlFZK+RhKf3xYKGr+imOEONSRpfnXGlNzmOmKIxIL9u7l0oz7szhBGgnaqMj6cUCXzOjAh7Q0YjEYaVFImf2kpY2+29sDWMNUjXGRYi5AgN699LBGy6UansS20V7Tl27FHJTY+u5kXGKFfPEc0caahMEpPoDSQj2k5rc+ASnQ2BgqBRPib27WeCFoDTzfdmKm1lYCSAs5pSCZqSeilTfVw1ZqHzW2MpIkKIZBZUwUk52oOpz74f2qEjGdFAkE0fWdj+pw/HZXPcEhbsVC6a1WrQm0R1ojg8imB6fYmYw6+owb/GQOk7b8bJrzCtauwLODOO/OwZ7/NoQ1yy5EZUmkpNGQHABG5QyECV2QS46XFShrBu7wzwDUENU
 1+wHmotl
 jyh3zENKOI2fxHckIIHjr0lrbH7J0XzlqGNGNQU39vydt2DEn+clPWppeGcPwceh/4SHjw7S7LhiEB7Fmo0ZsVmLvpi4mNWoY1O12fBTUmE37jr6pNZwhEO0Lw9VZ6CyjiaO4kRwARCYZU0QjIIz6b3le0+jIb6e3d3l6zds3WhDHFmKMzporuUAkoiU79Hljx0B/GlKxjvEEhnVms9IxNt8htQ5uNNkhiimchehMhsLfuxS4mWSZxCD21zvWxNzVi4XaSw19AxSALimOXld430o6L/IJN8jh4M7xZlxELh9QDcgxdQkvcn9Y73qGMliIVW/RBJKHpii2vfplf/b31uxrgPErawakTgLIXQf0vpaOUzMjzS8bb4RZbHsCyfa4JVtBLoakea4294AgYEL31ta2f7G4BASOMA0UyLwo9HTwj4ppdTQQ5xGHgjgmALaj+sS7VRFDFWL2ewrQoaxnLIjLwt1Cr/Zxi3+QtXRnOfG/Z1jaXvJdgVtHeWepVzuU3e82jXk2EFDrRanv3bDEyub+fFBC4xKHLgsvigDL1ek0uTpgFI8fIj2R+XPsdFBpameDNcb7lQjTK3SDpZJRoIMvrnJ2OkxDak9vHfDhXdc2sR9Kh8HmtRETthmmrvqlx8cGqPtFMZOpsXf8HwsxoAZ2RoSbjFPbZ1SeKIZDA2ErwqG7UuUc9gEH5NCuz+WuLrEKZPdGHAhyL5+jOQ4PtvqGVhEt6a4MUMN8zIjO3aPTmuc+J/xYaZFJGsdTP38g2XA3ArBOAnRhc8AUW+I2XxrD84ueOXZfb8sVMmUTDGDtteUqgchYWwyhEA4WGL7iE0ZBnBxeUzyDsNWBCh5YTW0h0UXoa1uy6L+hqdtwHtdC2IgcDVgC4XWsk2LwN5HPsmFc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_KL1PR03MB8800B64AFA0A40CFF301C50CA184AKL1PR03MB8800apcp_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGVsbG8sDQpJIGFtIHJlcG9ydGluZyBhIHBvc3NpYmxlIFJDVSBzdGFsbCBvYnNlcnZlZCBkdXJp
bmcgZnV6eiB0ZXN0aW5nIG9uIGENCnJlY2VudCBrZXJuZWwuDQo9PT0gU3VtbWFyeSA9PT0NClRo
ZSBrZXJuZWwgcmVwb3J0cyBhbiAicmN1X3ByZWVtcHQgc2VsZi1kZXRlY3RlZCBzdGFsbCIgd2hp
bGUgZXhlY3V0aW5nDQprbWVtbGVhayBzY2FubmluZyBjb2RlLCBhcHBhcmVudGx5IHRyaWdnZXJl
ZCB2aWEgYSBkZWJ1Z2ZzIHdyaXRlLiBUaGUNCnN0YWxsIGhhcHBlbnMgaW5zaWRlIGEgc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgpIHBhdGggZHVyaW5nIGttZW1sZWFrDQpvYmplY3Qgc2Nhbm5pbmcu
DQpUaGlzIHdhcyBvYnNlcnZlZCB1bmRlciBzeXprYWxsZXItc3R5bGUgZnV6emluZyAoc3l6LWV4
ZWN1dG9yKS4gSSBkbyBub3QNCmN1cnJlbnRseSBoYXZlIGEgbWluaW1hbCByZXByb2R1Y2VyLg0K
PT09IEVudmlyb25tZW50ID09PQ0KS2VybmVsOiA2LjE4LjAgKGxvY2FsbHkgYnVpbHQpDQpDb25m
aWc6IFBSRUVNUFQodm9sdW50YXJ5KQ0KQXJjaDogeDg2XzY0DQpIYXJkd2FyZTogUUVNVSBTdGFu
ZGFyZCBQQyAoaTQ0MEZYICsgUElJWCkNCkNQVSBjb3VudDogNA0KV29ya2xvYWQ6IHN5ei1leGVj
dXRvciAoZnV6emluZykNCj09PSBPYnNlcnZlZCBiZWhhdmlvciA9PT0NCktlcm5lbCByZXBvcnRz
IGFuIFJDVSBzdGFsbDoNCklORk86IHJjdSBkZXRlY3RlZCBzdGFsbCBpbiBjb3JydXB0ZWQNCnJj
dTogSU5GTzogcmN1X3ByZWVtcHQgc2VsZi1kZXRlY3RlZCBzdGFsbCBvbiBDUFUNCnJjdTogMi0u
Li4hOiAoNjMgdGlja3MgdGhpcyBHUCkNCnJjdTogKHQ9MjYzMTM2IGppZmZpZXMgZz0yMzUxNDkg
cT0xMCBuY3B1cz00KQ0KVGhlIHN0YWxsIG9jY3VycyBvbiBDUFUgMiB3aGlsZSBydW5uaW5nIHN5
ei1leGVjdXRvci4NCj09PSBDYWxsIHRyYWNlIChyZWxldmFudCBwYXJ0KSA9PT0NClRoZSBzdGFj
ayB0cmFjZSBwb2ludHMgaW50byBrbWVtbGVhayBzY2FubmluZyBjb2RlIGludm9rZWQgdmlhIGRl
YnVnZnM6DQpzY2FuX29iamVjdCBtbS9rbWVtbGVhay5jOjE2MTUNCnNjYW5fZ3JheV9saXN0IG1t
L2ttZW1sZWFrLmM6MTY0OA0Ka21lbWxlYWtfc2NhbiBtbS9rbWVtbGVhay5jOjE4MDANCmttZW1s
ZWFrX3dyaXRlIG1tL2ttZW1sZWFrLmM6MjE3Mg0KZnVsbF9wcm94eV93cml0ZSBmcy9kZWJ1Z2Zz
L2ZpbGUuYzozODgNCnZmc193cml0ZQ0Ka3N5c193cml0ZQ0KZG9fc3lzY2FsbF82NA0KVGhlIGlu
c3RydWN0aW9uIHBvaW50ZXIgYXQgdGhlIHRpbWUgb2YgdGhlIHN0YWxsIGlzIGluOg0KX3Jhd19z
cGluX3VubG9ja19pcnFyZXN0b3JlDQprZXJuZWwvbG9ja2luZy9zcGlubG9jay5jOjE5NA0KPT09
IEFkZGl0aW9uYWwgb2JzZXJ2YXRpb25zID09PQ0KVGhlIHN5c3RlbSBsYXRlciBzaG93cyBqb3Vy
bmFsIGNvcnJ1cHRpb24gYW5kIHN5c3RlbWQtam91cm5hbGQgYmVpbmcNCnJlc3RhcnRlZCBieSB0
aGUgd2F0Y2hkb2csIHBvc3NpYmx5IGFzIGEgc2Vjb25kYXJ5IGVmZmVjdC4NCnN5emthbGxlciBy
ZXBvcnRzOg0KU1laRkFJTDogZmFpbGVkIHRvIHJlY3YgcnBjIChlcnJubyA5OiBCYWQgZmlsZSBk
ZXNjcmlwdG9yKQ0KSXQgaXMgdW5jbGVhciB3aGV0aGVyIHRoaXMgaXMgZGlyZWN0bHkgcmVsYXRl
ZCB0byB0aGUgUkNVIHN0YWxsIG9yIGENCmNvbnNlcXVlbmNlIG9mIHRoZSBzeXN0ZW0gYmVjb21p
bmcgdW5yZXNwb25zaXZlLg0KPT09IFJlcHJvZHVjZXIgPT09DQpObyBzdGFuZGFsb25lIHJlcHJv
ZHVjZXIgaXMgY3VycmVudGx5IGF2YWlsYWJsZS4NClRoZSBpc3N1ZSB3YXMgb2JzZXJ2ZWQgZHVy
aW5nIGZ1enppbmcgd2l0aCBzeXotZXhlY3V0b3IuDQo9PT0gRXhwZWN0ZWQgYmVoYXZpb3IgPT09
DQpObyBSQ1Ugc3RhbGwgc2hvdWxkIGJlIHJlcG9ydGVkIGR1cmluZyBrbWVtbGVhayBzY2Fubmlu
ZywgZXZlbiB1bmRlcg0KbWFsZm9ybWVkIG9yIGFkdmVyc2FyaWFsIGRlYnVnZnMgaW5wdXRzLg0K
PT09IEFjdHVhbCBiZWhhdmlvciA9PT0NClJDVSByZXBvcnRzIGEgc2VsZi1kZXRlY3RlZCBzdGFs
bCB3aGlsZSBleGVjdXRpbmcga21lbWxlYWtfc2Nhbi4NCj09PSBOb3RlcyA9PT0NClRoaXMgbWF5
IGluZGljYXRlIHRoYXQga21lbWxlYWsgc2Nhbm5pbmcgaG9sZHMgcHJlZW1wdGlvbiBvciBpbnRl
cnJ1cHRzDQpkaXNhYmxlZCBmb3IgbG9uZ2VyIHRoYW4gZXhwZWN0ZWQgdW5kZXIgY2VydGFpbiBj
b25kaXRpb25zLCBvciB0aGF0IGFuDQpSQ1UgcmVhZC1zaWRlIGNyaXRpY2FsIHNlY3Rpb24gaXMg
bm90IGJlaW5nIGV4aXRlZCBwcm9tcHRseS4NClBsZWFzZSBsZXQgbWUga25vdyBpZiBhZGRpdGlv
bmFsIGluZm9ybWF0aW9uLCBrZXJuZWwgY29uZmlnIGRldGFpbHMsIG9yDQpmdXJ0aGVyIHRlc3Rp
bmcgd291bGQgYmUgaGVscGZ1bC4NClRoYW5rcyBmb3IgeW91ciB0aW1lLg0KUmVwb3J0ZWQtYnk6
DQpaaGkgV2FuZw0KDQo=

--_000_KL1PR03MB8800B64AFA0A40CFF301C50CA184AKL1PR03MB8800apcp_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div>Hello, &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp;&nbsp;</div>
<div>I am reporting a possible RCU stall observed during fuzz testing on a&=
nbsp;</div>
<div>recent kernel.&nbsp;</div>
<div>=3D=3D=3D Summary =3D=3D=3D&nbsp;</div>
<div>The kernel reports an &quot;rcu_preempt self-detected stall&quot; whil=
e executing&nbsp;</div>
<div>kmemleak scanning code, apparently triggered via a debugfs write. The&=
nbsp;</div>
<div>stall happens inside a spin_unlock_irqrestore() path during kmemleak&n=
bsp;</div>
<div>object scanning.&nbsp;</div>
<div>This was observed under syzkaller-style fuzzing (syz-executor). I do n=
ot&nbsp;</div>
<div>currently have a minimal reproducer.&nbsp;</div>
<div>=3D=3D=3D Environment =3D=3D=3D&nbsp;</div>
<div>Kernel: 6.18.0 (locally built)&nbsp;</div>
<div>Config: PREEMPT(voluntary)&nbsp;</div>
<div>Arch: x86_64&nbsp;</div>
<div>Hardware: QEMU Standard PC (i440FX + PIIX)&nbsp;</div>
<div>CPU count: 4&nbsp;</div>
<div>Workload: syz-executor (fuzzing)&nbsp;</div>
<div>=3D=3D=3D Observed behavior =3D=3D=3D&nbsp;</div>
<div>Kernel reports an RCU stall:&nbsp;</div>
<div>INFO: rcu detected stall in corrupted&nbsp;</div>
<div>rcu: INFO: rcu_preempt self-detected stall on CPU&nbsp;</div>
<div>rcu: 2-...!: (63 ticks this GP)&nbsp;</div>
<div>rcu: (t=3D263136 jiffies g=3D235149 q=3D10 ncpus=3D4)&nbsp;</div>
<div>The stall occurs on CPU 2 while running syz-executor.&nbsp;</div>
<div>=3D=3D=3D Call trace (relevant part) =3D=3D=3D&nbsp;</div>
<div>The stack trace points into kmemleak scanning code invoked via debugfs=
:&nbsp;</div>
<div>scan_object mm/kmemleak.c:1615&nbsp;</div>
<div>scan_gray_list mm/kmemleak.c:1648&nbsp;</div>
<div>kmemleak_scan mm/kmemleak.c:1800&nbsp;</div>
<div>kmemleak_write mm/kmemleak.c:2172&nbsp;</div>
<div>full_proxy_write fs/debugfs/file.c:388&nbsp;</div>
<div>vfs_write&nbsp;</div>
<div>ksys_write&nbsp;</div>
<div>do_syscall_64&nbsp;</div>
<div>The instruction pointer at the time of the stall is in:&nbsp;</div>
<div>_raw_spin_unlock_irqrestore&nbsp;</div>
<div>kernel/locking/spinlock.c:194&nbsp;</div>
<div>=3D=3D=3D Additional observations =3D=3D=3D&nbsp;</div>
<div>The system later shows journal corruption and systemd-journald being&n=
bsp;</div>
<div>restarted by the watchdog, possibly as a secondary effect.&nbsp;</div>
<div>syzkaller reports:&nbsp;</div>
<div>SYZFAIL: failed to recv rpc (errno 9: Bad file descriptor)&nbsp;</div>
<div>It is unclear whether this is directly related to the RCU stall or a&n=
bsp;</div>
<div>consequence of the system becoming unresponsive.&nbsp;</div>
<div>=3D=3D=3D Reproducer =3D=3D=3D&nbsp;</div>
<div>No standalone reproducer is currently available.&nbsp;</div>
<div>The issue was observed during fuzzing with syz-executor.&nbsp;</div>
<div>=3D=3D=3D Expected behavior =3D=3D=3D&nbsp;</div>
<div>No RCU stall should be reported during kmemleak scanning, even under&n=
bsp;</div>
<div>malformed or adversarial debugfs inputs.&nbsp;</div>
<div>=3D=3D=3D Actual behavior =3D=3D=3D&nbsp;</div>
<div>RCU reports a self-detected stall while executing kmemleak_scan.&nbsp;=
</div>
<div>=3D=3D=3D Notes =3D=3D=3D&nbsp;</div>
<div>This may indicate that kmemleak scanning holds preemption or interrupt=
s&nbsp;</div>
<div>disabled for longer than expected under certain conditions, or that an=
&nbsp;</div>
<div>RCU read-side critical section is not being exited promptly.&nbsp;</di=
v>
<div>Please let me know if additional information, kernel config details, o=
r&nbsp;</div>
<div>further testing would be helpful.&nbsp;</div>
<div>Thanks for your time.&nbsp;</div>
<div>Reported-by: &nbsp;</div>
<div>Zhi Wang</div>
<div><br>
</div>
</body>
</html>

--_000_KL1PR03MB8800B64AFA0A40CFF301C50CA184AKL1PR03MB8800apcp_--

