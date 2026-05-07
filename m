Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85DC9CD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 09:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8906B008A; Thu,  7 May 2026 05:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79326B008C; Thu,  7 May 2026 05:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A1F6B0092; Thu,  7 May 2026 05:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C13706B008A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 05:55:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 617C11A044E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:55:29 +0000 (UTC)
X-FDA: 84740166378.20.8911C71
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010063.outbound.protection.outlook.com [52.101.69.63])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9F2C620007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:55:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XCOKbjDv;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XCOKbjDv;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.69.63 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778147725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCrkm9Tb3cLSXCUWuwoQZ2oVF0wmVwIBgZOsxh4yZ0U=;
	b=AkRV8suCE10PUDz7fncrjnZSXrDsJk5Y6UjJffnRhHfd+fEke7K5F5l8VHRcECN/QeGXeA
	KdtwVZtF5rRqiA/T14/sMdAjEY6g79W3pcQW2rxiJrW0DSlhATwr9dTpFxZRlcHO0ybKFQ
	JKx6Wuico4nYwGILW7Ilt/fevzWf9E8=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778147725; a=rsa-sha256;
	cv=pass;
	b=4zraqw3nJPJZ66SvHUqG06iMv1PaaZoepDR9U0dUiLQfPNI0U/0eSaaU3bFTCrQwCToR6h
	UAejlJbcCK3xmTxvK2YnWWYQhhbdB3WN6Qlw3debScdskWS2uNfZvAXxHtTfWP8H3yCd2u
	uWDJgvP0JOP5LoxDHYSOi5mP6KvtwX0=
ARC-Authentication-Results: i=3;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XCOKbjDv;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XCOKbjDv;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.69.63 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UiEXs/3UHqNEDOSgQIaNkiNcrG8bh1PYRY18zf7Uoy2wDULhQ7c2PrkrdGKqA3dqNBi5MxWaOtb8dzCh6ykk1Jq5bimz5T3O7pSLV+2douwyjpa7ks/QPJwjQmN5Bvuaig5/v34jXlSmoMZC7U8aHoc72wDXAt53nc51FqieWFhjn5Z8oTyKVVbwrqDZXJZm3e3ajgLtyJhGlY9fQN6w1bSihu5BOevI7YZhxaK4ikd4EBYP/SC6GqliAaR0MRwHO9W25EHQ2yGXX5pClbQjWJDKOrg1+UMmfF90UoafVINfHJA2/S8ZbET3oRxrGIFg+9L9gTC7XHzUjT+NB5fQ3A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCrkm9Tb3cLSXCUWuwoQZ2oVF0wmVwIBgZOsxh4yZ0U=;
 b=QOLPu8UGjspHC+ObPSRXRwo4EDSeRL5zYwCA8uPEokfflNPtcWM17kLaJKzHfwepwDjoeIOsIwO+IYQoIG83j+ZKyMKQK1vZMfUDH8jGN0CfV0x9FsAPFgq0AnmXQdU7NUlDO5C0bBNh2aOx1O4PXQwZjLHmejHH+M3cXp3mPJCQlrQLlBOhpTgrpmvKIEeQUKoT0urA38qID6SGz/LdKFLW5kAPwmiQXixMh8SW+f5UNlAubFhR5uJxEe7XjKPmNBucLfasmnvJ4eUjyEKTnWYSmOD2SBNdSD5FZcoLPMRDmBWcKKATqd6rKCpJRDdMoeZ7XXmWG9vtSbvGmAz9+w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCrkm9Tb3cLSXCUWuwoQZ2oVF0wmVwIBgZOsxh4yZ0U=;
 b=XCOKbjDvQSJfKzNzjHwL6LhRfjrH0EupUqLwC34eKYSM1FM9QIoVoT2E/tv2hWBp0pGNuXsyTpvsiCNvSYchyjJ4u00834UlguyTqktEBNe/+AOeOu07jViuuclIB5B+vrhIYOk8JBH1+F1+3Fh/v1tSq2KMGKGFiz3zqJa3Cec=
Received: from CWLP265CA0436.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1d7::6)
 by VE1PR08MB5664.eurprd08.prod.outlook.com (2603:10a6:800:1ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.17; Thu, 7 May
 2026 09:55:14 +0000
Received: from AMS1EPF00000042.eurprd04.prod.outlook.com
 (2603:10a6:400:1d7:cafe::3c) by CWLP265CA0436.outlook.office365.com
 (2603:10a6:400:1d7::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.15 via Frontend Transport; Thu,
 7 May 2026 09:55:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000042.mail.protection.outlook.com (10.167.16.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Thu, 7 May 2026 09:55:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t/7xb+fkfMv9RdZLkBdluMJ5n9WrUattr4ZjkzBRbuTsf/o4VwSPqv6KDmsV8NKXd0QRtz31ClStEETOvkdwENAgUV09zHtUYx4lRedToS8SpQn2MilcSLhFTOWVx8d1nthaI7NykFiRSpMhsEU8+zW48HL4yofEimI3uaPtpJeJ5aVwSfJjwRYaJEvpZfr7odyW4RR3afWt+R5TTCWR8mCmiYNh4g68h4Yhyoo5i46jH8zec36znxx2VbnGfCIGkuIzc6vZxjYx38Xe0FBsV/gCzZwu3BRvZULPBF3KV8sVxp2I3e4bnRQ3YmsQbYHJCmUdc0Mp/2mAxgYH7V4JBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCrkm9Tb3cLSXCUWuwoQZ2oVF0wmVwIBgZOsxh4yZ0U=;
 b=DZY3KDCzY90pyib5rLgQZkaX/6bOKkRDeNuX8nTlyGIC4XVrk6yUN/M3vBIyHd4v8meFBU+MISf80Px1DblzSUZMGjDr6XNAHIB8cHGGKy7duxXm/z+b92c6Bet96r86faV0V612yZe8h9B7V8CyUunn4mFAvh5qq/gVuznVzDXfq6b4LG73YuPWQCUw7xzSpVDvOJQ6oWOBgsBbZSt7BvTmkV5TJ+RpXxGYpKMoGf9vBqH3MymnzimwKq+1lETZBFDKzPN+ORhaKWZHnzEGSLJXKbYitm3YIqQM6mSfjmMoTuMlWxfaqDuVcMHdPhsXNfWMtrgVQpB8lFOuNQNUxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCrkm9Tb3cLSXCUWuwoQZ2oVF0wmVwIBgZOsxh4yZ0U=;
 b=XCOKbjDvQSJfKzNzjHwL6LhRfjrH0EupUqLwC34eKYSM1FM9QIoVoT2E/tv2hWBp0pGNuXsyTpvsiCNvSYchyjJ4u00834UlguyTqktEBNe/+AOeOu07jViuuclIB5B+vrhIYOk8JBH1+F1+3Fh/v1tSq2KMGKGFiz3zqJa3Cec=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by GV2PR08MB8486.eurprd08.prod.outlook.com (2603:10a6:150:bc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 09:54:07 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 09:54:06 +0000
Message-ID: <c543e394-bc52-494e-830e-6f4fb3037fe1@arm.com>
Date: Thu, 7 May 2026 15:23:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 36/54] selftests/mm: hugetlb_fault_after_madv: add
 setup of HugeTLB pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Luiz Capitulino <luizcap@redhat.com>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-37-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-37-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0137.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d2::13) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|GV2PR08MB8486:EE_|AMS1EPF00000042:EE_|VE1PR08MB5664:EE_
X-MS-Office365-Filtering-Correlation-Id: ca4f369e-2c2d-440e-96a5-08deac1ebc4f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 xNjViau2ngFmXnpZrQPpqKOJvhKk69znOjTJoqLgBes92r/QliSWC78MdHjsedn6kkzM5kw6Jfyec3tLXlunFgo4wwFHde316xzbmaEK1Mei9Ax0aB66mQ6o71Bdwmqg141jODwL7rxYsAtJK/kF0dqDRE8j88ZswRv5Tx/3b1rx9A1Cl7pP75r2JroWbX82XttYNPbg+ROAICaLt3LG0mxk2Eb4k+dIZS6B/X+sPXWWwdwgDnNoNJy7eT8bXyflE+PFcDPBYNUTzmBpddjh+fBWwWro+huMGntEL8ujp8IPzsEaOlNzAPh1SgNkGJhgdIdFauKVMr0wVJ4CN2rjE2D2qsLHCTVCQohvUi4QD64YsgVdM9LUPI8htIk90u7833G/Q2wjrUc60HMbHbPLETVjkWxJhuwRF36cARz8d6FCgr1s+ajaNGc61fGq2W+WI/wLFUG1CgOJ4qPucbknmkEMq5LX1h0yiw6FnokiEMsnJW7eGAQV7vQMFCI4yJJzLeEpYMDKv5JJotiUxXOAlSmpE2gawgWmsO0Sq0V7GQqZ5JWTYkgLi6KNtuz/oLtTZ43haXnuYizB0X9k83+xmGi1QSJNjbx2FFs9lxyPw7Kq9ZgGdwcD/26FDEmnc0PZ8whrK2b/NhEZ1NSFKnzNBGVRQ3WclfNkOTK4eqN2oioympii47cT6ESwVAKuXaju
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 T0r25dspN4/2RQ4yqwh9QkCVHhU6f+wgnTGV02PEExdyd97V4PnK12Vs2Qv+HZNzdU3Cu/KSslsbcHv3bMql93KXaPFGpT1Ta5o2kDLeWAZoPDlAFHmPzbD9RUgkRmBxUAkRUsIKwH52dYlqBBPaa3W+znheMl/Uh5VEl5Ra+3rdQirUiCbLBrH2+4RCZSrVjdTs/InS6fw88PcufVQWQyFW/9D1Vfj0vs5rBqnnLlvWhk0wcXuphSjFEZYY607hMAhiznoX4qnQWunhEP7MOFB1B1oxdnQpqj1R8pIkCLZnivXSaYvM4gtWduuxyLbcSm9o6u0XKF/bojj1r8cUnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000042.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	44104a48-0144-4ab7-2793-08deac1e9387
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|7416014|376014|14060799003|1800799024|35042699022|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YiKVvdBX3VCk0tDhEmWGC9MlZzakZ/JS2sikBi02p5g1PeuaMW9Rwc5Ns70MupG6ZkhhxWgI81VOMGoj+PgdGyr/oNvxi+dMFNvJLcWqkSASRny3YpxLt0rquYna/BEkOgcHPfcIqi7V1HPdEIYurVp+SJg0VpnLs8mpD0/kymsQitlpgyispv9E5EK4nLNEOvqyZyvRh9/pwAc/po2M7kxG1Msvq3EUqJWEvfO+JSceQtCuG34e4WQVTp0DfFO6jnyMA8ELrUrK/vRTJC2Mk34efVyuQtfuDt3TJcwjpPuLV4OHxE222W3r58RsOg+ILgzeoClQ1AJ8Ct4BIhjRE2NNQEvw5Rm70wKyJu+EGPJ/qy/z+1pc+tP00aEH6GXwO/eVvBQE1xFxv92toyouxGHT4Lr6hyYxwjGtWMbTdCOdyUGoaXyjcIB7xVUMBiqeU0GOcCH1qVYvrtHTorS6Z4DWD21Ul1Q1+k1XxEAGULSQKEaxW6n0eegndpnEHe5x9Sqe0ZV8FUQonXU+/Gd1piC1iX+T7/NjBkSsPApdwHBq4IemuIvLvHtF0w4RlVSOBVevrDad1NHXbRRmrarYLMNFBDJsAJACWMUnr2NmqufD6ud+J0C1oOZJ5kKvKHNyIFeTkxP8vf/mIWKQDmsDTIw+mQfJmPvCvYmXgnA+ny+2NEJPKzJPXUFtmlzFkcZBm6I/9/SL9B5odptXVzjdDRfHorYBqCPriM1PHmU6k0Y=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(7416014)(376014)(14060799003)(1800799024)(35042699022)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YhemJH6rylGngJKHjzLZ82rdj2sL1tgwN4rSmBm6Y+/hJDRA6KgLjVt8FykQh9E4vin3h29cagobODvwF2/Bz5uqVK9fnVufTJ6ItnHmu9UplWnGwXWhFcCDhuZk8R3vhdUEa9vzRZvtYpwWTPuztJ+MvhxBul1JwVDwmMBRCElLOGok/2F4s4paQX2zS61MILDwUtV7FSGBwm2L6HGdLiNbi9+88b4XqMcbFbnQKK4gp+Yhzwd6igvcYAmRXd31i+v0a/6ft+vrIiFv/gERcUbDs0KA2neM3mG+Mw3j6//aiZ3sYalCKGzuL1G4trcnSB1vqQ4xcGbsjFmih/Ub4uOk/vA1FMcrqAcHNGCXhAkCZcsqw3HM+Onph67g7thLlILu2W0kIG2Wnka9fYnAdjOeXR88PYj4pYjYuUuwlNl7Raz+DKXd3pon9kHGHIvg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 09:55:14.0554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4f369e-2c2d-440e-96a5-08deac1ebc4f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000042.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5664
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F2C620007
X-Stat-Signature: 16esd7gjzmta48h8kaijmbnp6yz6xrma
X-Rspam-User: 
X-HE-Tag: 1778147725-378891
X-HE-Meta: U2FsdGVkX18KaAVhHUU3vOjT1vkXtoOl4aLQa2uiwl8tDrHaoFoIeetwzIFnZNOz7ms4pxnLBRVgIAZhzXZyJOcQWQxJ1LCkFkMFzgdJVkQfEXis/ms2TnSEICAmL5e+wmTC48Vbr1jF7lNA76kLeZDfqYyvtf4jl6uMdOuEeMBjoXEgOQfCbTgt3OKA+RXtwB3RO8UVWxs1NFrwUhZb0Wn8YIaiYYUYcB8iSfN7JFRga8Zrb/KFc3HRw6um2+bhqoEKHgPeDYY1Az963fjV312ACtAEDp3KwZ5P2S6divbrrAIWKT4rPBGpQ4R8Nj4Y1m2mZhq3sTY0zwFIAI5zL6IJU6q+bmvYN0kAfEwGymq8wRT34wFCrSKEqqjyGx9HsBqFSZOOtPZlv+ihD6bknlN0dT2VeLlr7oAnBdx9tBSAqsM3PVvyO/QoHcTFX0Nwsv2TadFuMLHWNJsuYhAtvyJpYT5fHxGrz5CYeev7uPHhl+lMUEjLVcmz9NZwsaFslf4V8kLpYrh7y9qbYPhS6tOyZAkQMhnBEI8+l/KQU8epjHS6vXk/FRA/BXEvPsUm5SbTImsG2zBYMRwqN39rj8k2tjNdsZhMv674pRx8OzAR9lUpg6LE43Siyx5kN5LZesx/bAbfPWHkb9xqVChlwcxQ72lBZIxfs0dHgG73l3CpCACIIUFh9Q7g+VcBeRDiYfUKaQMgguFTUbqq35uxNdQy9hDtwwrlTn5rGFJY8/+uXnAW75iZSg5apKF167pJFAUIe5Os10bomu1b1j7WWSzOihp6VnrL84hHwEpR3FGg34GjBSL18tT05MBaV+QQ3nTYVhny+8xQx/Hr5OwNUBNUHyH7K0wx430xIq/MToERRpUpulPN1cjitkhyCYgr27YiRcDUSI7XiMIkT9XjuWa8dBcVhpKAxr5wKV66GKoyrvCGLumWevSF3K58mb4hxSz1xeUqk/16Ni9aeQD
 5cnbKyuC
 fs9VGxakKq3Zp2bxQnxu6PXbfq+DENSns6MfU1JsDMrkVR6RF9Ld3WMD7GCG1KH57rxwKHaM+cQLrh+mDb5MlwCLAVNPv2MYeiepZpsWIuYvwymq0Fhrc08caGQXv2acA9TBWzcxVNtIYpBUN5oaPuRA5a4gAKnkE68ECAnO2co50UipcKU7BHqbG7+PZ5ekOzZgRcHOHB2g736UfjT/XqBk4R3ta+COdUurLqhwA23w9Jtj1nTcrk/vzOAcoMKrD8Y0sgzJRi0yAZmyxZpUhGMmEawh6PaeHRczSfxNfc8R/NW7MZbCBLikqf/SVTcdxIBJKc66Zf/FSMq6UHWoMwfsq94ykvMebLd9qCk+La7zSRe5ZuaVj0w6MEXS7DHwrJENDDNzxCqrvbZjcCygQak/WViuCAThK53HE601KnYo9/IY9U51pLd0T4mTc11oWx3vCY+k9znNsNLjXMqfG4p3OySBEVv62jKpxlOe5aHsoJ2xHpW3KhqKTBD47luQqLqBE1v/t1q5HHViQ9xc3jK4DCP1AMBSjnAYQue7//yDsuqES/R5m/KKF4d7rlHXSfq/ZWWRfiES9tFRKvuyoExUDUqvPuX19uJPaUbqxbGadeew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hugetlb_fault_after_madv test skips testing if there are no free huge
> pages prepared by a wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I have run the test before and after applying the patch. Before the
patch, the test skipped if there was not exactly 1 free hugepage
available. After the patch, it correctly allocates one hugepage and the
test passes successfully, restoring the original hugepage settings on exit.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/hugetlb_fault_after_madv.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
> index c718dd065d53..481863cc5fda 100644
> --- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
> +++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
> @@ -54,7 +54,6 @@ void *madv(void *unused)
>  
>  int main(void)
>  {
> -	unsigned long free_hugepages;
>  	pthread_t thread1, thread2;
>  	/*
>  	 * On kernel 6.4, we are able to reproduce the problem with ~1000
> @@ -78,10 +77,9 @@ int main(void)
>  	ksft_print_msg("[INFO] detected default hugetlb page size: %zu KiB\n",
>  		       huge_page_size / 1024);
>  
> -	free_hugepages = hugetlb_free_default_pages();
> -	if (free_hugepages != 1) {
> +	if (!hugetlb_setup_default(1)) {
>  		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
> -			       free_hugepages);
> +			       hugetlb_free_default_pages());
>  	}
>  
>  	while (max--) {


