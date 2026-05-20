Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F1ACD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 13:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7736B008A; Wed, 20 May 2026 09:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80CC6B008C; Wed, 20 May 2026 09:08:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D21786B0092; Wed, 20 May 2026 09:08:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC3966B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:08:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E9A61A02F0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:08:01 +0000 (UTC)
X-FDA: 84787825962.28.501EDCB
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011056.outbound.protection.outlook.com [40.107.130.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 64E2DA0002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:07:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=invjALqz;
	dkim=pass header.d=arm.com header.s=selector1 header.b=invjALqz;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf15.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.56 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779282476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfkdaFB4Lk5IFUCAMl3mQw1mD4Rp0FaTn7PmWRDkltI=;
	b=x018MAfYT5jEUb6FUwCGcGdbM7A1zFedcWfx5u+VcgzwNDgY0I4xOWws7PJHmk1VXNDT22
	FXUrMIFMf3IJ7yUYOESTdsJarms4H4OEbFz6k7Vlieqo3Cnk9teEmgtGadR0UQM/kRdlYo
	dp0i3gFjUh0Ipt95NTLdnIEaH8mhIDk=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1779282476; a=rsa-sha256;
	cv=fail;
	b=dddaX4vnSzBTg4UcE6plvT7YgyP5Lz5X04JqCrzujloCBiSNEJpmCaKEiRjM3XjsUFiLKo
	kVYuNLMQNTg5TbY9gLA96kFDC5PkwFghIoxz+kCtLUDgOtGSE2CEsbt3VrorOf56wTyBzB
	91TUobI5T+vXvsP1LmUCKUvaUPhWfwY=
ARC-Authentication-Results: i=3;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=invjALqz;
	dkim=pass header.d=arm.com header.s=selector1 header.b=invjALqz;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf15.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.56 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=QkaOPhSgN5+d2gnhIGnbpM7amgB9gPPjjPj0jMEcUQGTIj/aCI3KS5m+LLG4YOK7q5OS37Yb31UnO56JNFVqEo/tAF28RUvF+iZ8iFgcCF4Y07EIR6AkbzEz1nJJU7Ay+1t7ZrQWbr6uF1TS5UA3me1XTtrf9lun9T0HUMH/33JFdtIie3k+DQ+AxReqNrUNH4/Wwj1bgrjdnsPaDSMTx0z0porYbsWN1zn+z4OQKk7iy8ZAV7Aq84mhFtv02+cL8pIyj4ofVD5EM7toPfNdvrf6nqSBijUbjI7HMOazZGbrFIesarli+L+8N7lWiNGad7rlxtxsInwaR3oNDxJkvw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfkdaFB4Lk5IFUCAMl3mQw1mD4Rp0FaTn7PmWRDkltI=;
 b=btHYyjUB1/MO9nxOXp/OsuOxOykVPiK3/FvcwQMAM2VaUwKrgcbuUAeA7f8t8eHD36eSegzoLuyQNWgpGiH/LY+JlT45vrHS5fZoEm/KOUM1xe5pFzgaIr1T5QRlI/yObGyZret6QGjAqrNwFRM94d94BsTaL93bOiZber0K5hPGijfuMQ9ZSWYKVOGtHhQLfdxkqmnQ7qyOG0oSr0DgP1ZeiEPjWabC5JnB3svcvPuPXThQt1IG6FBP53+ZVDCzEF3/R2WqE8E5hGg3nc7Zkur4AtV4QFEiVCYUXEfJG25L6t7+llQCoKIws3JkyLBwVie9DNKOh+0zh6+Er54XcA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfkdaFB4Lk5IFUCAMl3mQw1mD4Rp0FaTn7PmWRDkltI=;
 b=invjALqzhqC+APCMHMcUdjwlrzj23DjCQHrjMstki3raYDJk31QlIg+rTUmJK1/P3V+FLofD2mn1PdjcHIQGTWKQTPLYd1Ub24OB1JASXEMy6/oTOwam5r/o6aPgp07Y4/MTAQ42ks5MG08+aKdN45MdMl0a0HvRw5VP9BbRFEc=
Received: from AM0P309CA0001.EURP309.PROD.OUTLOOK.COM (2603:10a6:20b:28f::35)
 by MRWPR08MB11757.eurprd08.prod.outlook.com (2603:10a6:501:98::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 13:07:26 +0000
Received: from AMS0EPF000001A6.eurprd05.prod.outlook.com
 (2603:10a6:20b:28f:cafe::5) by AM0P309CA0001.outlook.office365.com
 (2603:10a6:20b:28f::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.1 via Frontend Transport; Wed, 20
 May 2026 13:07:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A6.mail.protection.outlook.com (10.167.16.233) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.11
 via Frontend Transport; Wed, 20 May 2026 13:07:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UejbBxtLRSTCTCi9ydWmQolV0p4HqO7nDtimI2pplKAp8oNbtaOJ+Rxws2ZkhaDVECyPUhB4ntoNO84g0xgE8UMEy1qbdDgFv6Whlt3wZvIkfec3mJqNpxqDMbzrCCA+7lRbJM2uGtSLuObQtDJhZPa1wPv6Iw4nR/nRESx5GKfFxnhjBmObxNzKJ71wH8sI3CrjB60uc2OOy/WXRHJpJGgt6FB31rDB/Y7+OpFo8GE+zdUGpW7Lpo0DsoMThXbM08C6CKWSk8RHNmnatbdiPl6yW63cOy7DfN2XYqUynjHSajRgINEGkcEMo4VO83du0H2APQt8RZq7+kSNEFbJmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfkdaFB4Lk5IFUCAMl3mQw1mD4Rp0FaTn7PmWRDkltI=;
 b=NE8yBO4LbIS0YEqob1hEAyh+8owVMD1eTYoWa6UhJLwdOZGcmSy0ftEQFcs6McSt9U100wx2eW/Fo/aSIvtVRtlUqH4UNydqUqo7KPpp1UQ6Hf6nZYaiJs/w5ksI0F17SMyGTozaRXE634fdlYr9/LnsxtOrQLgSFyrs77bstAH7lhIOt8eYDOFftiaOBKOnE9oxp4f1ptpwM6itBow67Ffr9OwCxAnhocr3oAKZrKArV0n2NC4ckHjS0Jvbfk99x0d9JrgHQvvB4liw/Ukn5QA2Do+gQffNflXxIIuw6WdaUvb5JMPE0JPd3NO6iSx4BUbYT6MPYTzkSOMjS4Wzng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfkdaFB4Lk5IFUCAMl3mQw1mD4Rp0FaTn7PmWRDkltI=;
 b=invjALqzhqC+APCMHMcUdjwlrzj23DjCQHrjMstki3raYDJk31QlIg+rTUmJK1/P3V+FLofD2mn1PdjcHIQGTWKQTPLYd1Ub24OB1JASXEMy6/oTOwam5r/o6aPgp07Y4/MTAQ42ks5MG08+aKdN45MdMl0a0HvRw5VP9BbRFEc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AM9PR08MB6035.eurprd08.prod.outlook.com (2603:10a6:20b:2d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 13:06:23 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%5]) with mapi id 15.21.0048.013; Wed, 20 May 2026
 13:06:23 +0000
Message-ID: <63b84c3b-66a3-49f4-bde4-b577ec72f86a@arm.com>
Date: Wed, 20 May 2026 18:36:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] tools/mm: add a standalone GUP microbenchmark
To: Mike Rapoport <rppt@kernel.org>, Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260519120506.184512-1-sarthak.sharma@arm.com>
 <20260519120506.184512-2-sarthak.sharma@arm.com>
 <ag13GbKcLMIoHOHj@kernel.org> <9382431f-3746-4477-bbef-87abb58bf180@arm.com>
 <67e9ecff-e532-4659-b4de-7019474af608@sirena.org.uk>
 <ag2v6KW8E94kl4M_@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <ag2v6KW8E94kl4M_@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0117.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1a7::14) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AM9PR08MB6035:EE_|AMS0EPF000001A6:EE_|MRWPR08MB11757:EE_
X-MS-Office365-Filtering-Correlation-Id: fb965235-0e05-4a53-80c4-08deb670bd7e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003|17002099007|11063799006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 THpYWEtj2WCPLfaUYa6j4oRY/EpsQoUz4XASR7J5MyOpAndzXq3aonkSzwBHi4rvZusknT4S6a8ZeiQ+j9XHhRrvwXtrTG7L8bigX7N5z0b8EGxNvL7TU6adJ7Bbj8xuAyNhX34ZfSvuhKVLRiubX1CMl0EyZ/SUzVqvoaJocsFMn70bhov6PGOB+wlh81LCH/+axHxBwBFT952kXo+mOMaXcJe2geCjg7MBYFZSFd1w6HMo1DqkDah3JU7tTtSSTMhRtdijB15ol2D+geELatjTLaKRlixgFf5XDXgfIYmE9rLiq6rpfIQNVTcS9IaK5vqvGdmiXV6yzHmFweS84dRyF70BAe8LgGwoKaPXikAG9ZwlsulCUrzLERi1BQYnWAAUvhn0ZOpTb9TM5hiBxkT6R7IVCZ3aOU/8NqJ6X+pN/yyUY1LZum6+N7ptrUzry8qbFpoxEVmwIQfj5ADGKkFYeZFcxNP2gJoro5jEOUhOft3bJ2gs7s5gDSMaV2kVk417Jdhr4b/pgemLJpqliUnDFoiqoz8z3mMn6TWi02DywXB7pAh8L/WQxcKShdFgGzyVdMFDxcZ43wmk3g0T8EfxonwCcC7JD+JWzz9nyy60lQ3ZzNI64LnVP+As5Wn9U/jkEjVngRSEs8IOjNwvFUn8aeQGCi+PMPC6fT28/bKezlENcUsULgpMayp2x6jI
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003)(17002099007)(11063799006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 RoMVpnw27QdZ1mHv0LEDOvL0ZHWc295MtdplA+ncNweKrXEiZmZNqk5ZlsoDYul9h6FT3Z6F9HYTdS34yd9cESfdnCSIFETG/F60UmZlcfYvtJ+Mx+2khVsIn1hk7ZW6L8Tx9IWAVk0ceDmJpzyg72jhg7OE6YBn44tKKIPL3ouae/yb6mkZU4ZYYhx+o57LYZ5qJaGz95EXzpAf5dbn8yx8Tg7TTTC0ArsuOiHEfJ4yxXs+5isSg+Acm8klez+/PrGkIuanPUO1wBsZPyNy69PLW4n/qykYQ7lACYTdO8kM9UxFPF3sdgJQXuIq9i3EiGL5hgkKuuBS2QMrLaEy8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6035
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A6.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2bcb996c-aa3e-4286-0c0b-08deb670976b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|36860700016|376014|35042699022|7416014|56012099003|22082099003|18002099003|17002099007|11063799006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info:
	fmJZ4soDMUG0gAK82PJZmra7M8CvqbHlR0KHHowut2iNnDCm+sMsNiczXSEKeKSR7ncIU15M0otVWonhs+OTm9oggZBsAgRMtZUzchXHrnPQAlci8fq+I1slAlRU5Lj8Sl0/hqy9fJ48my3E7GqV4yMQosgl83X9J4gU05hagYvc15HkgMODYnvpOm6FRPqANW1WjwYtrwxGS5KtSP7DtXXrin5F4FPmSCWIc3kvqWSPy6FYbptwsm99YgAn8/l479mdIKPYS3azql7bQi2hrDhihaOcF1dfvpK51wQO5ZT+IWh0dtiypw1pOKkvqgGgD1JcI0Muy7P63sVonpJN89x/ZQ7qGOYOS7WK8d8JjJnaM3TEJZQaouUAAHK80UlvNkrrJToBREkrxCw7QzJSy/g/A78OpKUBtQeo2yUJ5pEFp8/ieNNirg8s9pXZsy8rL7PdG3ywZ7OJZoLqwXIMlAAHSvCJUl5DVfZ+0Mq+jnR+LrfBf/oIyJE7JJ8KW1OEsih47WpLdK5NUWU+VqYh/2AaSDxmL/AOfFi6tJZT67y6WM2Hlbe/m1Rw9+Weng2ArvW77e8mOFBC9UHFCyOZFdTLnYh7mFQO+Hw2kDX29ACqO7knDspfrkwVlDBw6xi5aC50XpsF1nkFLC7appxXo5La46TdPolaXlFYbkqyinvVwrz87eBuIt7fC2MUyZmv74LXg79S6tGpwxTNldzvNPf+soVXRzYF+/9HBtgXdTE=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(36860700016)(376014)(35042699022)(7416014)(56012099003)(22082099003)(18002099003)(17002099007)(11063799006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rZ+2+kPppYhphLDzPVLQihdbmz9U8BHb4jm7oOOzMmcxLk8EddtyaW8jpms6I59mYAQ6nQeIVBXZE4KTZcgPSe9XsrE0Jer3+RT5bIn+qe5oMvY4JmTsve0UELRhSQI2gXE029spEDbVYp4gmxbGt+6InSZ2unGMdhuzBcOxWDtMP3z8pe7dqPGPzR1D2zG1cYBTFJGU6ibmHhdkzEtxG6MLaHp2gh90KuXvLIksiQoHs7+8+gGNDfqqGgvPwmeCFatUBct5JC+WuugsJjjtya36Amp4pZiHdiQ1iuZEa1XT6ZBzl92w4tLXIulIFP0FzfG18mH87LmD5NHe2kIIgY1q/HCe7pY96d5bzKmvRgOPujJz1u4dd8r5nwKHzlNL9aj9v6KV8VpXADly0rP+aOwzkSm0bcXpbR+dMxhLNsowbl7/dEUz/64WRZCIQXeA
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 13:07:26.3990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb965235-0e05-4a53-80c4-08deb670bd7e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A6.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR08MB11757
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 64E2DA0002
X-Stat-Signature: j85w91cs4hr9orjecu8phtsiqypmjwjt
X-Rspam-User: 
X-HE-Tag: 1779282476-104750
X-HE-Meta: U2FsdGVkX192SAbWMS460uXyAuMpj3P2DCqYBFkRyRv17jZbdM1tlwlrr/NCKVLuGXhhGz9E3L9Yu/O5ZG8RgQxcJCFJcbl+e8KYuXnqHrMvPJtc16HMN0OOWRAg/zY4OkDfKlEUNHmpz8Ty+ay+L6weHHS+XzdBcDOmS1f8IdKXeOVFOxvHlW3y3B1xmI/Wz5CaMjF8LTW7MtEncUCf8x0gaw4m5LKihPb0AWIr+qZxVeZRtK2VAsYKPBKrn9PL0f5wTsUKZYgIXDKZLhs4Xm816XCBrIWRj56T0oY8MzmW9ChcvgbKFsHKVI7wiVSDvfEUA+C0PWQ+5eWUcaK5EHxHFdRQ79uLsH2DFzhelgBoA5XFs3BDP24ADCnlYFZFNlnxgLE7xW9kXoUl+oijRLoavbkG/y7AALw0yMWrRaP5ILvg0aBjmZS3vZDI82pidcotnEj12BTku+fM04hsXxlkU9aO9+5Bp4mwv1y1bNL0fDZUTX38NpX56kL9YlbIQhwUEBEkgXO5w/DdVt5cJjmcOMBTdadkd1aiMR7xJGRIhwj6UU5vFWqccBKxsa2guq5DAGQtKnjhaKfdEy6UOn+NQpN59Sf1k7vUdBndCc9LuBbXf8jsNGYb67EhfWZnUsDQIOtsiQeKPMrJ2B5QKCy3G/cebkaNK43mSbPKglgTsHuSPCo5UMp1doEz2cCq59m/1IwnB4xpGacwNyMqwcBr91NWzUG3PutPT/VuBgVwN72eqBdTbbQInA1IihDvpmgsiZFj5Bl7YEfRa60g5fciWwIsujTVc34rVdt5yFcM5gtAct1ki4AdqNij/SgDEUZCXmpZo65gN4oqyaeqaUynq4UdNZQ5RitQKOlWJKGJOElfVAHJTBOoondl908u80FL5chIGHQEtKAomrvrh1vUYYcQnOh9O0izh3QBL3j2ihsuTzlIgK9bejpV6UgZot7BQmFsn1SHaGHqA3k
 E/KciSCG
 itfK27MncI2fNWYuLfM6XIQsRSqmsIYNr/vh9kfTPxkdAyPQnBMF7VgqKh3NmgwbLxNxMiHWszJbwKEgsURter1/LYnFbHLHHsau2xWvBf9rhvRPC6TXfLqAap0yLc+3p+tNJRtLzCHt2zRpkCoZ5A7YA21ITcPxdj/Gfz+tuaCUUhwzWkMqOp3Cs5l1LNF+AlosI68qUY7DRQdDU6nkO3qsLmtm3cEiCEG5N8R9joX8nqan1BvINhOg4m/4fX8rnNAklo4KGAtSVxgc6cvqzfNoV4rBAn5rC/rv6oE2fomO63/W+Z2w03SpLqRhkXQ8WzbNLMg8lswlgZOp7OB7rpvt5DTqdOW9NkyCu5SgM9WkoRs7jLoPuWNluIKTcYWgLRA4V9xApjo/fCC1Lf2gLCeRYmU6yty3rd6tBvOvjV1Zs0GCwHnX85/JioKmCLaO22h59oO/tShHCby6GWylm1K4wcfoVuwy/jxjgG6soZiS+tu5ugiWUOLLcWj5r37FpWPbE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/20/26 6:28 PM, Mike Rapoport wrote:
> On Wed, May 20, 2026 at 12:58:32PM +0100, Mark Brown wrote:
>> On Wed, May 20, 2026 at 03:45:53PM +0530, Sarthak Sharma wrote:
>>> On 5/20/26 2:25 PM, Mike Rapoport wrote:
>>
>>>> It seems that we need to better share the common code in
>>>> tools/testing/selftest.
>>
>>>> And adding another copy of the hugetlb detection and setup code does not
>>>> seem like a great idea.
>>
>>> Agreed, but that was the least disruptive approach I could think of.
>>
>>> I am thinking of doing this now: should I move the
>>> hugepage_settings.[ch] to tools/lib/ and move the read_num(),
>>> write_num(), read_file() and write_file() helpers to a separate file in
> 
> these might need some adjustments because they use ksft_(), but in general
> it makes sense to me.
> 
>>> tools/lib/ itself without any ksft dependency? Then both
>>> tools/testing/selftests/* and tools/mm/ could share the same code.
>>
>> Using tools/lib sounds sensible to me - as well as the sharing it makes
>> it clear that it's a library used by multiple things so avoids the
>> issues we sometimes have with selftest directories referencing each
>> other.
> 
> I'd make it tools/lib/mm as most of the files tools/lib/*.c are stubs for
> the kernel functions.
> 

Thanks Mark and Mike, I'll include these changes in v3.


