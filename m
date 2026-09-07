Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94637C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8749E6B009D; Mon,  7 Sep 2026 07:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BDA6B00A2; Mon,  7 Sep 2026 07:41:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73AC86B00A3; Mon,  7 Sep 2026 07:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F27C6B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:41:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D14C6A237E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:41:50 +0000 (UTC)
X-FDA: 85186776780.26.E41E1CD
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013051.outbound.protection.outlook.com [52.101.72.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id ACD8A40006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:41:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=OnHEyEFS;
	dkim=pass header.d=arm.com header.s=selector1 header.b=OnHEyEFS;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.51 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788781307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j42XSNvQmZz+aa33qMqMrmMeyfWYrXzp0n7qe64hEWc=;
	b=XegqXCL49Goxdt7UpDrY/f9p2NrbG182dT1qkeJS4l4Y69gFvquoXAcC8C7w3M6nHShfxb
	/npHPPlqlX/262v1Nxo5gCi+zj8aYZjpOk/xZISuyFR9w8ancvI0TttMv5oSLhvewp9xEl
	hf0GvXynXmtsqD21/UG9hTPgxSS+RXA=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788781307;
	b=xVcL7yWFuDuvlgEWX7xwA1pl62cU7BcodrH9yzrLWii/3HZWM9p6Kx4E07mNmzY6R/rlGg
	2jwE5Edvwp+ZVsgANF4OME+K6t2cLcNbimq9IrzwhteLS2WcagRPD3fFeWlbIXfc0egglk
	htfAcNrmvRYZ7fyusPSkZwm9IwzxZNw=
ARC-Authentication-Results: i=3;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=OnHEyEFS;
	dkim=pass header.d=arm.com header.s=selector1 header.b=OnHEyEFS;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.51 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rR6sjTz9xJAlXFbhzEAgycrLz/OpAL5tGTHBU/pR0Llz4KMOJVQrmc3wtC0mvfDs99j3qzxOyr2YSZbScFc1G24+XOQvYRjbgnfCUf0Z0zrOd5qoFy7o8BErZx8I6lvcWC04vtoF5DuhdsZ+AKRANKY9affYD4TtlhN02wXS/v1sai2dkjcubAudmNxcqQ00bIyJf+qy6qrHYmp1VA3xRW3pkkR0FsAg079Uw8PJeATpNyte3wb/7Pp+sP+sPy1Nn8VlaNvYXtHOOqdsruAlVgqAsI+rtlI407Ap+4VlqUZXCWBh+U/nDz3sD5HDalApL2K49+FOSvnTwjIQNZs87A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j42XSNvQmZz+aa33qMqMrmMeyfWYrXzp0n7qe64hEWc=;
 b=fFCbFpG4p9Sl9q1oN07tQwGn5QrY5usYxPJt57DAzKwk5qFiEs8v+qYPaK6dwDhzHYNgors7eKu6/UZRm7595W3wmMp/TSXLgnvxHz0EwB2SVEUvq4Clhnn0miRcy72yBNL2VhfjW6mXvGgt6nF+ESFqhkZjkRH9MrJ5Hu/nXlL7JzfD216dNMIT8j0iDt7owxRj5E6mdTWgyEiJEHaWcLrgGk9b2jVQTAdKm9Gw2MXEskJ7JiCQBRpaHbaBM26ThMbb5Zp4bBxUHLY17FSDYrlEon4it12cw8dTM+l5Natv1VCALjy+sR059lPwK3W8TGNhgVFBFxw8ZtG8IGJWIA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kvack.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j42XSNvQmZz+aa33qMqMrmMeyfWYrXzp0n7qe64hEWc=;
 b=OnHEyEFSf9VbvjnBVr8yPDh96Jg4ff9gXsRkwqXsYHAiqyK9+d1T+JHVAE8KMCDVNNTUd6l0bbs/BfKxSFE4+J0oHSnxVpgQ48w9G6o1ULq2FUGDGxIgzIMV3W5Bqh1fbjW6DUQBiZ7uYolJqKGQwLtfGDcSXThfJaVV3LtpHyY=
Received: from DU7P251CA0013.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:551::34)
 by AS8PR08MB7305.eurprd08.prod.outlook.com (2603:10a6:20b:440::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 11:41:37 +0000
Received: from DU6PEPF0000B61D.eurprd02.prod.outlook.com
 (2603:10a6:10:551:cafe::a1) by DU7P251CA0013.outlook.office365.com
 (2603:10a6:10:551::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Mon, 7
 Sep 2026 11:41:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61D.mail.protection.outlook.com (10.167.8.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.5
 via Frontend Transport; Mon, 7 Sep 2026 11:41:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DqCgdmJhJ1STfC8Ri1oaxGRbKMNF/MvuEpbElOu24dhwWuyk1+5W3mp1gYxmH6wG6QbJyLpQinYKNyzxVpe5nymMrnn4y7t2Frl/0p0kSKI/18AJ8prCfiJeTk45bKHHN3eBHqQDcPtmp9k2COzEY/sdCUvsx0Foai3MhSb0oJ1b8kMV9lVb4Knfc3qqHj5+YI7TDivOf/L3YAIi7vrAFjBy7vn60bC+6cP8v02CEa1V1wVuWI2pZ5+atgTJCYdM0NxrBc4a6h8HcW3WAN87bdsICMBYtQDaaBSUeq6R0rUWN4tXizZe25qLGKntDhdgqkzi+HH+o9q76rb5Q3i7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j42XSNvQmZz+aa33qMqMrmMeyfWYrXzp0n7qe64hEWc=;
 b=po/jUrqWSDk0CH75e4GcV+5oI9k9fqFEvh1oSELsOpP392bRsUX7NSbSgFyWW1/xTbUsQerhPLgJ2b5zDX5GHuQsGE3cUi9EM7Vkug0YaFbJ5pNtNTmaMUc/lRCjLrNmQsFScJu1YZ3i2mw0RDVr2G+oDka4C9xhSLO8cpU4RKuINtWeopIX7PHoyzGJmOV14Pnl1bTPUZtYu3nriws8Hv9nVznk2gsP3eWT60uaOr8t1huZKaRELfXY1XRAS/6BWWdltkiY4CGDZwPfB8eBfZPKIo8B3/SW0Mh8v9jaE0v4UDOeL95ePfJdJsF3gLrkqHTUMW1Mc42Q8SIV1/Ww0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j42XSNvQmZz+aa33qMqMrmMeyfWYrXzp0n7qe64hEWc=;
 b=OnHEyEFSf9VbvjnBVr8yPDh96Jg4ff9gXsRkwqXsYHAiqyK9+d1T+JHVAE8KMCDVNNTUd6l0bbs/BfKxSFE4+J0oHSnxVpgQ48w9G6o1ULq2FUGDGxIgzIMV3W5Bqh1fbjW6DUQBiZ7uYolJqKGQwLtfGDcSXThfJaVV3LtpHyY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PA6PR08MB11584.eurprd08.prod.outlook.com (2603:10a6:102:524::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 11:41:01 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 11:41:00 +0000
Message-ID: <96627c9e-a05d-46c0-b95c-91a7f6cfcc74@arm.com>
Date: Mon, 7 Sep 2026 17:10:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, kas@kernel.org
References: <20260907081509.924979-1-yeoreum.yun@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260907081509.924979-1-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MA5P287CA0079.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d8::14) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PA6PR08MB11584:EE_|DU6PEPF0000B61D:EE_|AS8PR08MB7305:EE_
X-MS-Office365-Filtering-Correlation-Id: d033427d-7394-4b09-5cc0-08df0cd4f994
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|6133799003|3023799007|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 I4Z53jTbxQsScr2x0vMxIF4WVYx/pZt/78Jb3UMEWKWXvk5PBfQm3AdNej9CDzFD2LBC/i/rZGLGFnogXkzmTRY0o4ycfsy9jewLC+A+VlEYLCId9kpdtmf8GeKNMFGXQG2ISzHSDq2ExtZu0j+DSscJjvUtO6+lpMpiT0TCNFSVUYhJoFakc6t9V9g2PKoQIn3olzwvZfJZ+u0mS6NwsboyG79CdM1Lls4me1443nY3o66exHH7MQxDyspTCSiR1zmJy1x7xrM0dylfdOzVVoiIZv9RZPUpevdbPBA/b+BbOALOLY4Loc3SFWgFrRCXEMYU22TWqIBpDmmj1sN043LbWAdgHElHdayWtMx9Q0bGjsmGQl1OAHfffR0jDMOiKq94ETM8PBQJ5DhZxJlTVapSt7Wryvukg4zxUqewD4WWEMxazPF+2hcWrLWqSWJF4cOvI8DdAJJNRwjVIxnc4POYPfI7WDTppt/73Knyl+MjRLmZ/g0QclZpqAmD/GCLEGm2BKyY97z+v9L3Dlfp2cFmS8j6IP4wZLIJszidl+6uYaGn6SnuZLRw7zmaanAqoKQXUY1RnRPimROepkH7N/9GiK8XGgi2vKysMEfK4FGjO+GAf8vbCDBYlqfVXrJl
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(6133799003)(3023799007)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 QVVu0ah/RUMz9sP6mF6Q78o3XqlswkVUTXIUeeinHI7elfZQIJkzhnxbZwbF8OlQJKk29lcFX3YsZBGXofvsA8zo9z+EjdLkWcNizhv43eMQ/6/pOBqtsU0R4lIBr2qNo7hNW7XGy6CX3O2RXNw8wdimzPPW5wKhKIq0LcPINsUsWffIzaMupsJkIuS7ohxGi2d6+3kvATUlEwHpcd2ksAUzH+qp3O6x16MoVC/V5socwk1YCBk2lDN2SO+2a+IRJ8kkG1oMLyxHSxNjnEbNFurADVjN3OpGJiO7ohswsJl1pjDYr0N1Ob/JkdNVyt3pmo9vOma4tPh/OLnH7z5dlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB11584
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ccf53a23-ecf4-4002-3b06-08df0cd4e3af
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|36860700016|1800799024|14060799003|23010399003|82310400026|7416014|11063799006|6133799003|56012099006|3023799007|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qNOz/ITYFGI7K8bxNmZcyGqSHxiCPAA5ldPSaKadOc7y0EObNW0MJWx50UhGYE6BRjCL4+on7QbNewFYvju3ykVa70gmGlQiSX/LRbroYhobTHBvauRnbvbvz7Q4UpWZNeHOI+65WB5jOsMrLI/iX0OF5XtjgrWxqgKZfWxVeHSMq1zUzhwAC8xr2ORUTWmy+M5BpqTgPyUYv+WLMw1yShDVHSTt6/sS/qct2cJ2xCe/82WfJ2Zz4e1ir5Qh5Q9+3iu5ERwrks+iwPvxF8Oni26Qy9Ju7S/RLUWmCaiytS2f/LjxBaXbar/pSqZxuDRfI25vSWjgx/uB+UGujfAGtxBJ0p+YeJ7oM4K/MvhqoJxNs5KHRw3SHrgLpb/Q5hiXIRNBhmSFkBAmf8zHYUS2UZ/oJemBIF6UkN6uNv8DCY4pftWylMAZNMJz+XRd7mhMtcVPxww8FKhd466Kz7bDiDM6MkTJk4/FR3Z795yfQbDzHzIc1VxVW85bfLHKPXU+meAIzRLKAT6MA7jCublrhGqCTjhvxppHQ0MHh0b/QUuvx7axAVIh6/31vY6iHBNMxoKVbGaLkzOc+nL5VCQrTHF7tocl9jMfh7gnyn1FmxjH/kkQj3dA1tW2tAlfLlEYTY+VtKUyc0CGNtngKYxCPcsv7IflVWXk5OpWbr2Ayu0=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(36860700016)(1800799024)(14060799003)(23010399003)(82310400026)(7416014)(11063799006)(6133799003)(56012099006)(3023799007)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eVMcmjZ3PD9Hv2Dj6Do7ch5RS5HoGuAqBvxV9mMmm61jR5i7h1FaNglkvnEMCxmHx5dIGbOnFn9NhPIufg6GEHBbreDiUaHr4qkNBLVp7vSBh72lI81q/eJDfZZbBC+ADDijulTXvH2oRRv367nQiVqeHpN+0MMVHuPaCTJyUqOGT+jaTy0HxVzZMQzxA+V0Hl2728a3VzcfxC3aW8SV09WzTLjsVvz2QYFtx3nkT7ga4RHeUoqCQbvmPEGmUgYMWO2XffuReIx2n0H07swtNcFd2Jm6Aa01DaUJiNx2hrBojh7dEL6IcFlbqbPOyDhlj/L0tc2sCAENYSF3VtM0Tun0gWo7mUVDW98+s4ASDUD6Aq1mGHWk6xhvCHO3b8IWEtv/HEycXbw0V2BIxN9z3neHmr5ZPJPo9c2sEwqeU1MmxJ9HM8jV7Uy0oWmPHAtw
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 11:41:36.8721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d033427d-7394-4b09-5cc0-08df0cd4f994
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7305
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACD8A40006
X-Stat-Signature: npztikff9ojy51ngftyu7jmzohh7gaoj
X-Rspam-User: 
X-HE-Tag: 1788781306-565125
X-HE-Meta: U2FsdGVkX19u2xPwsfOSIEU4Zaxh2C/J2NoKQhMnHNwE8KZrO1OgXCLmRUCpyfFEPNV4UM3K2f2GE5FApVk4FmtFcAq5RrnYw0E2iF1PtmR3HT7d8qDtltT4VvWou4x4Ivt+Nh/HqjNisrOb/W/8dMVUED4InCdPVsRcjZzDT5sKiwikNgdLLBsW83Rpx/DWt+dKdeGODqXu6ySvVgz8IlXQNTecPRZ+4qGjYbiysfz1AGIpc5DgDMnv9lcdv+Xj5tzKJwq06PE1/9hWeBHIATudYPTAFoym1K5ZluhwCUurbZhEUPZiB+V13wRVKWY+2MMMah2lil9GfVyTF1/tSdTopSwoll5sdTFvzkvDMJZHBDHgTdKY0LkBLLHGzBIFes09U1MzOVNH4qdu+2F0TlAP7DKCUG3nz2+ZzNwbRWtCp9azWYpHczzm9XY0N/utdPgoapLzqe6O1UdgCU209aeIJD8QR/zRHjZD7QP7AFYEepjtU68oPQANdQSkocGFy/ZaPgOeG2e3cL3HoEIkZva2K5AM0Do9/GS+n9Yy1xqPz7EV5twOCZ/V3g2374fw3meBK7HxzUcrB1nG6s9Aie9EvAip0r04JYFdY2w7COrpb5iOiS0ta4Olkg2ZQUlQWS+iKMEz0OSMu4Eb6Gy/48Eidg4cEgF8k+GbVf9qTmNKxoZx9UoHnCdv38IINzJa6syuugUDSGhpCNp9SW26Y8ICHBtmdkXUhsedVTbcCSRr29X7RWELG0Mn1NE3NfQs3BIALeCqPEnAkoKlI4PIr+72XboxFy6+tYw5bYXmENdrRQUeFrcQY7M7jnwnhnQA08tFX24rvhh+O1CD/fjWWmekdWc19sHhtCNY6/XLf+G+WSnD7IJTBtalluNMctWtnCYD51AXua1HGlVYQkvr4wAiJ+lmAHep0xNGzsydH03bzivir2Zb86dFNk+scYJocB3e72ZmQSj+Sta/ZMn
 fCvNfucy
 DSOeM9rUSYHotZZ89HmQheCtNVV1HdWgAj7d5+3UbmUky+1YKyyb9NUpdKSaK2/RKJTDuHjmQxGWiYhe5R7jjB/Sz8lQ35rY0dTVqZ3U7aQTE2VxHJs04T+CtNuDf/z9pZeqtpWke3VQ/kCTKH07gJbdCkjp/dFeZFNgl0cdsYMI+7yhlvROBLkg2791qCjPziGKWuS5uRDMsPu/2GuQyNglpJnKYCSm0+kv7hUoT27iwK0M11pJckUXtqTkOmNVOi9+FPzKknX407gp4K8K+X43SfalCjFwWJ3j+WHQJJpwv/YCzgsSDDRYo7hAvN/85PVu2/wIC9OTKa3IES6Ni8rW0LMOJJTV3JhcF7UeioiEMjFbYJO+0KyQ7egb+vt9LJg79W+VB/b26o5tbyPYJCz6dfdHVWW7EaOfYOsEc5THBui20I5qYHb9iDPfPxPGiLvVYsjPC2EyJANSQnCFmO9Q+ax6aBN4MFx52EOWrt7O4yvecEIiL7j1FbazpuZA5DI6mDXJoA3kH6hVjiqfPllm3J4UPLk6/q7pLwXWiLx6YrMUSHxsxOhA4NlQNG4RpG1c2mqXY/wC8//QSiUutnIp2HJ10tFKoUfa73MF9ZUNqmNVAk+jXQCanPPF9xSKsrLGSNvbQoxcQz5Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yeoreum!

On 9/7/26 1:45 PM, Yeoreum Yun wrote:
> HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> When this macro is used in some test, test result would be strange in
> the system where PAGE_SIZE is more then 4KB.
>
> Here is the example with transhuge-stress test with 16KB PAGE_SIZE:
>
>   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virt=
ual memory and 1908 MiB of ram
>     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s     2566 succeed, 58507=
 failed, 2566 different pages
>     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s        0 succeed, 61073=
 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s        0 succeed, 61073=
 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s        0 succeed, 61073=
 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s        0 succeed, 61073=
 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s        0 succeed, 61073=
 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s        0 succeed, 61073=
 failed,    0 different pages
>     ...
>   ok 1 Completed
>
> Remove the HPAGE_SIZE and HPAGE_SHIFT macros and introduce pmd_page_shift=
()
> helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
> helper, read_pmd_pagesize().
>
> Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
> which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
> and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
> PMD-sized units, the test may fail with the previous size of 100 MiB,
> which is not a multiple of the PMD size when the base page size is
> 16 KiB or 64 KiB.
>
> After this patch, output of transhuge-stress:
>
>   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtu=
al memory and 119 MiB of ram
>     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s     2585 succeed, 1232 =
failed, 2585 different pages
>     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s     2585 succeed, 1232 =
failed, 2585 different pages
>     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s     2585 succeed, 1232 =
failed, 2585 different pages
>     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s     2616 succeed, 1201 =
failed, 2616 different pages
>     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s     2627 succeed, 1190 =
failed, 2627 different pages
>     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s     2628 succeed, 1189 =
failed, 2628 different pages
>     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s     2630 succeed, 1187 =
failed, 2630 different pages
>     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s     2631 succeed, 1186 =
failed, 2631 different pages
>     ...
>   ok 1 Completed
>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
> Chnage in v2:
>  - rename hpage_* to pmd_page_*
>  - Link to v1: https://lore.kernel.org/all/20260902175611.1241118-1-yeore=
um.yun@arm.com/#t
Thanks for accepting the suggestion to rename :)

I've tested this patch on 16kB and 64kB machines. Before the patch,
transhuge_stress attempted the same number of allocations irrespective
of the page size, since HPAGE_SIZE was hardcoded. After applying the
patch, it correctly reads PMD size and calculates the attempts accordingly.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

