Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3736BE81BDB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4706B009B; Mon,  9 Feb 2026 10:23:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1FF6B009E; Mon,  9 Feb 2026 10:23:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650526B009F; Mon,  9 Feb 2026 10:23:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5366B009B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:23:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C1B71BFFD
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:23:07 +0000 (UTC)
X-FDA: 84425286414.28.3F90300
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 90923120006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:23:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b6+yiKnK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Z8Q1CTq0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770650581; a=rsa-sha256;
	cv=pass;
	b=FQVHunHRr4At0SRtF+hQOMZhGyGUFEMJHbU7y6ysjbQ6FhWEXTFqN8uZxCxaBaS3hH+xgv
	jmsaIhkt7Kkhu0JXdBQWFGBQf//fD3lJcysKxsuRQ6pRZmjaEVVXB3Awd3kPdYj7SjgSMS
	LIJEoCcZS0yCGbl5vB8LW7Aqd1rxYAs=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b6+yiKnK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Z8Q1CTq0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770650581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCqQinfnlgSW3rfHpNRzCA3zKQh2zFTzTANJU2xPolM=;
	b=O+ychwdsr4Uu8QBb2BKEzOBAtmySKqhmie5J3tm1zAwwyA8gfGqu9MqEnKoa18TsIvjVV5
	fi3/by1lAiChCQSIyvwEhUI/zDhaOpP8JZ5vK2wC0L9IjZNcGYaDKADmCqqDJ13Sca307D
	HQ0xO0p7sWCD4Cm5jDKC6R6bciBrbyw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619ECfCP2021322;
	Mon, 9 Feb 2026 15:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FCqQinfnlgSW3rfHpN
	RzCA3zKQh2zFTzTANJU2xPolM=; b=b6+yiKnK3/z6Zu3N9iMvHQGErbjnRiNiTq
	UPhTGIU6haF5eeoY4aaps032NNbtCFaajZeXawGTKMKGUVIZ3qJcpRTpCmZ7g7ee
	ZUl107ckSzgeEb64k2lYA9r3Flhpmgpu5C2USOKmjOCBYYUbfhR+5KiXTx0ilzUG
	tLNa4hjl8FoZviDnaZE17o4vKkniDJrqTAtf9aazryLgCeCYg2opbAqb36dUZXIz
	R0g+9SGddl7w8AciV/rilIoEipKMi/mgExrUCYBVtsqmBBVpm8+JquXGeszSWXhO
	djFBqaxLHsiaxmYqVkWxSJ0YttOOP4GJrNjfMaJd3iyAB/OqBbAQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xfp24ch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 15:22:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 619F6Cvw000566;
	Mon, 9 Feb 2026 15:22:36 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012014.outbound.protection.outlook.com [52.101.48.14])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uud57gv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 15:22:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WdF6U16gW6NuOHxdkuu3XAu9NnnL7WUhOqB+f7RikN6rf25chRhdWf9UmV9ubT69j3Bc/Ex8jFle+8ToSnZF5TkPIIq4zjRko18nMkXMAYfuhKHB8LTjJN5743bvjCiMpPbvVjd4pdtxAbGGz/KvjS0aaR/mropUMge5PyX9i692qtSAPCyFJ3IZZqiLGWH8qXZ74lqLnA9pHQf3kq1aVrhviJ9eGC2YNlMGrgCtynEdM5QonCPtY0ahOBgxwJnJcHiiovlMuF6YXnxWVauR9yHZHMyOuv9ekbhd3IGw3OS+IJwqmudfBMbXMqG1SxO2a9LJUo9tVvl035T7KTQDjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FCqQinfnlgSW3rfHpNRzCA3zKQh2zFTzTANJU2xPolM=;
 b=lU6PI8xB6N9rxJPr/gabHcIMUi6uf9llI3938qlaefa0Am6Nhf0PFb//64krDzt2WblLpUmNh+V3J0Av/TD2SGSCLJl+nZPIk08XdC4xa2wRF5C90NEG9CuAtmeFqP/7qdbejUsJqyj1qGA5rCuS0GUbtUucfNCln2r1wLTrInl4E47ncAGniIeNzFmUJzfeng6VmPbO3IZ8kVnlKYWgoTClKh/w+Haq18vQT6N3RiQoo9NNPJbn2Lc8ZHmIof6tvxFBj07NLfL7Bv7uk62hbLKsD5suwk8T5iftywVGS8jwYsMRVf7n9CklupVrjcjOr6ffz2abJ6hXHSLgyBqa8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCqQinfnlgSW3rfHpNRzCA3zKQh2zFTzTANJU2xPolM=;
 b=Z8Q1CTq0y9h7Urw2QX4NTn7mPaHMlaVJP0gmq+9zsSiH+lWrVHyJPQjJp6dMDp8SKJWvqzJOw8r7l5Zm3E8C17MFzR4/xzT0ttBadBnrMMnN3E/EhSxzM7LgixReivWZl5U7meBzXj9fb8y3HujgEuoxbI7VQTZjrUDf8oknhys=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6310.namprd10.prod.outlook.com (2603:10b6:510:1b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 15:22:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 15:22:30 +0000
Date: Mon, 9 Feb 2026 15:22:25 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Carlos Llamas <cmllamas@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        kernel-team@android.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
Message-ID: <43f54b5d-4eb0-4997-a61f-ef413b81766d@lucifer.local>
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
 <aYSFyH-1kkW92M2N@google.com>
 <e7247f3e-8a88-4b46-91ba-cb73cce1346a@lucifer.local>
 <8856c839-1a94-4e4d-9ded-d3b1627cd2cc@kernel.org>
 <aYSKyr7StGpGKNqW@google.com>
 <4c399644-97d3-40a3-a596-e4c93b713bdd@lucifer.local>
 <ba5cb90a-cd4f-496e-a665-cc323ec598ab@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba5cb90a-cd4f-496e-a665-cc323ec598ab@kernel.org>
X-ClientProxiedBy: LO4P123CA0079.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6310:EE_
X-MS-Office365-Filtering-Correlation-Id: 40d4d0a3-15b3-400c-7dcd-08de67ef0aac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dk70HprEP0l+lmwiBEeAasPsE304yvTNj/eXqvP8R/9E+uMrIOnHqE5la4vV?=
 =?us-ascii?Q?f84wvdGNnbB4j6TSAL88ZFSW8bTkRdCsPWEJsR3tlvsbrmecjuHxe200K2BN?=
 =?us-ascii?Q?JAXGxHmFg0PfaXldBekKGSVbo9vZ635sCbbpxB7S4UxduGGcpY+5eAJX5FKk?=
 =?us-ascii?Q?BRyu4R5CQvaAag98METGB5PpL/ALVmnJtwq9CwkyiOCk1u6Y0LkToidyn0ce?=
 =?us-ascii?Q?vZ5wVdWoGqxn2Hp8dzOeR6xfRxRuiUVMeK4yRGkzu1kOQWD5bSdSTjV6mpCA?=
 =?us-ascii?Q?ELNnz6a5msBQoUG/ULvVFWSvxsnaeG5AthSwG0w8FbQHqFXnBBjumZbhQknB?=
 =?us-ascii?Q?XAmddMVRavkrSNPhm9srds3dgCVCDEUJHSjO327c2UY16zemI/qeiQkMcex2?=
 =?us-ascii?Q?8cCbxkpJCRSaqbTF1t1cUxg5bp3QADmja9+NX6zaW9ShyJz199RqLJ9c3+1g?=
 =?us-ascii?Q?ffne3K3BOzdj3zXIEonrwSiDAEUs16lAltsHZWdqb7TQyZNAsmavoL4a5Our?=
 =?us-ascii?Q?W0xhfI1ySON19/ih3Q5VFVHOSg4EeQdYq9DRyI1rJzaKvHNtCPZD2S5eNQLp?=
 =?us-ascii?Q?DPc+0aNRIIQIIUr24kfkeG57l3NofQI97wMjgaxkWwX3/2Bn+qu1j+kGVOAy?=
 =?us-ascii?Q?5Q7qhAJj8NXMuqfgxbx5LZ5u3/zpemgzMOPfj/3EgLPy1mklACLes7XzoXNu?=
 =?us-ascii?Q?bDIlDBxvLMkof+x5L0UdFmwwTKjM+Zu/+DshJCFSMz48Kb6k6Kf1JkZecRMK?=
 =?us-ascii?Q?CsutudGPlkgaO2FXma6CGPQnewwokdLsVXqOqTsKI+7IP5YDOFEJJX4XbRGb?=
 =?us-ascii?Q?PL2WmaDxle/Sj8gmNHiPbcrus5PofFHNl+vGAghf1fm7UHHLY4xkSWA8/nW1?=
 =?us-ascii?Q?4QV3sJ2eeXjQVFzsPOHBNHhW3gLKSJxorCeFxl5HE/wiBNzvfmXFUrdkzmXA?=
 =?us-ascii?Q?EM41AHfeuOprj6e3jvGJyOUWqV7DzzAHI555//H1DesGT6OhBZIEfSx2AKfb?=
 =?us-ascii?Q?3PJZaoR3ofHrhrfnOd4vumvrUza/YCMekQqLUBvOTDnemP/b7gKiGGp9TtVn?=
 =?us-ascii?Q?eXIRvzt/72dHyk2vrQp2du9KM30ug5tgyg3QZbpecx1auJsCJah2WicWzSGH?=
 =?us-ascii?Q?WmU95yzmik5YRT/oQ9N9A2I46rtTaE1BRyYslIPkoa0L0EA7tzPGJm4ojjNK?=
 =?us-ascii?Q?/QtH2xpcbxAmdc0DbnC+gNBqmc4Gvm8DTFZhWKdQKaPk7HtkCWr20PAqOtg4?=
 =?us-ascii?Q?h+0n7nriQJYDgP/f9Mz1pEuOkZPQUnK7P9mzllP1GeYNHgphGYnh82K344Rs?=
 =?us-ascii?Q?NsSgNFw21AeO0psFfcq/PqoBM/38YC+uB6RECVJc2Hj6uuRWe/symK3wVJwO?=
 =?us-ascii?Q?6CQc7fwlVhkLCqztd9nm8IhwbLcVKjTXtMs078oOF7BPX3E9O4eGsTe4Uq4l?=
 =?us-ascii?Q?Rk4u4eGK63LEyylkGr/QiUCSeRgl/FZJYyI70BQnV9+nxHe9GkU9j4bGPIX5?=
 =?us-ascii?Q?d0tCkleOJZp3V+7ZPALklAKB1ribpnRHVToChxXHoAU2UM6tj08MsgMIrwfa?=
 =?us-ascii?Q?A4YvOlR7roZt6SdWEKQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?olkiWelAJ8PbR4z2PxbOe/uEaVlAsvhsvFboGw61JOfQk6G4sF9DjV92uYzR?=
 =?us-ascii?Q?1XtemH9B+0toKC+WnUwdKoc3Vwv44F6JTf8NxDE3LUew4I1G0kakEYnbagq1?=
 =?us-ascii?Q?bQ8xJzlM5CMwkFhxxF2PrueOPMTUfT0JT7/ofzV21K9odfAGb1KjpCoo7T1V?=
 =?us-ascii?Q?27matJswubGPhJnqRLnUWG7Q56/rZ3C1R2hbW1hK1GVcpGrajZtjtHPFijxV?=
 =?us-ascii?Q?xd/5X8bDA1Ku2vxijuHWeSKnWVIxaeYBWYfGoJTypZlQhZAjTXoHd7Yp7XwB?=
 =?us-ascii?Q?SuJQEpmWVQPuyh2GnDD08QyGqYdy5wBAfEdv9H4f96ORj+NiRW3z52JS++py?=
 =?us-ascii?Q?8B5J4L7ZzyuNWBCrz9ku+GZmT8jgAjS3DbqJ/+GT8oasiKCawP448Kim8zzj?=
 =?us-ascii?Q?mH1Dih0xuDqpR54F7B42xdcps94o1v86NLTbL2AObajec8n4fbvqXOqojdvC?=
 =?us-ascii?Q?VoBFv4Jbz4m2kuV9YOxV9l40lrHrwPNEzqjDZvtyG0LqQQ3h1nmdYDTgSlhK?=
 =?us-ascii?Q?d03n9anIlt5Yf47DX547DK5RrfaVZrRsBo27sMEBd/yT+OovPRg/GFS9efDS?=
 =?us-ascii?Q?NfK+QzwrrzYDRzNSyWl79oFIZcdtCGD+4W02f3sGW/moF1umqLpXTvj5eK5P?=
 =?us-ascii?Q?EdLh1+iw3G22wyxh56EoJ1Cz32TCYVRD4zmkcwZcYsWIL/zouUsS0PVNUo9h?=
 =?us-ascii?Q?LajjSTDvjD+JwTvWV14XBsigXnMQbtC5J7CzWZqUeAKnG02y3jhB6wxxvnbH?=
 =?us-ascii?Q?BPuchUzAyomwMBqyKmXuu9S9zwCs2+2P9yw7KCCsAWUOXsKk0HqZgrcNqZrY?=
 =?us-ascii?Q?nqroZwh/d0aE5BqT+ytCsbkbV9IJojeB3ALhNYhPM/LMGIvSVdYJjheIVPex?=
 =?us-ascii?Q?tICkirYTMlJbbR+xAAv1aNkHBIYjLGfvY12WxqjRnV05EWRynlsM9L2GMsxv?=
 =?us-ascii?Q?ineYW4GXOoPziLZx9DmgTCm6KFWkxZbKfT5G8ZpDvgOXRLdnJ+WugHQSxK12?=
 =?us-ascii?Q?WGt+FfOsb4CLigBBMsF1pwykvDwjVbwlBkJLqIyHfFwRfazlPKbJ020FefI+?=
 =?us-ascii?Q?7KNUEMF76LN6D2XwWJv31vSlHoKWXcKtqBtaaAaN1vvJ+ZTMMIVq3gIl0ren?=
 =?us-ascii?Q?/FFKEUFc38hIunFVJL9zL7LX8C3fFFIOGdaeOVlh6FowA3S/1GSHOYFgZYVp?=
 =?us-ascii?Q?/xxrPcfgGQ2lUOzgQFbL80QW+Mk/2YPwzlK1UH7DQ8tCIwv9L/mRs4e3xiAZ?=
 =?us-ascii?Q?tStOFkn60ZTPpOwrIsGP2ZtKY4wUqI3+D4gEZRqkIGGvfbMk41ybgDhKhfyp?=
 =?us-ascii?Q?/NLWfPrMqQA+KMMquQkLgx5vARcuql64kQeQxgj9HrPmhQcMALsKRo7lQVNu?=
 =?us-ascii?Q?9EAGLCcPiwEILdfDoGr7L/dpJW+luL+89wkVjwP/Id8mlZL3VYKwccyj5S48?=
 =?us-ascii?Q?0W1Mytp6oAYwEFGnVAuw55R+kFuDYVlypENbN3GC5BY62awk3nTOmS/ZCXwy?=
 =?us-ascii?Q?FlR0BKt3FwnIQMg6YJtYTsJGAn982rw9OsHLEfre9k8qZykkfNwdyLYChlJt?=
 =?us-ascii?Q?MpIvJNBRL4lC1UIvA1brUmzyaBQFh8YjMwst0hUDAkMIUx++Rj9Xlkj5FoX0?=
 =?us-ascii?Q?pnK2rg+Mmx59lvq9IpOgkWLbqqpSoFnhMxKeu8/8N8iowp4kds4+kOWowKdU?=
 =?us-ascii?Q?a7n9FSHWvRYt2/m1+77ExG1t8yJxpfCXY5QRFtcb4e8iAEAVp3NJXmAVVzFY?=
 =?us-ascii?Q?gYwjHUqNiQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tsb1/csfkz8XCF4368/hDhn3kF+8Td0bgYZP2yL/AjAC5YdV4e6/i5E+YO/NgkOko2v1kMr0rzdN741g8TaZ2c3ux1osm8Jg85SXLq8DbcCvx+F7Osxgxw71qa3BQkp+3SAgKVqxrHWUtZjTJGYPcwyxFV5RsMf6wHO/MoAzWfb3PDnRIQfulQzSMp/9d0iOlDRLMlMSY6hl502EcqOWoPJLdGD069240lPZ6ajA6jhv2aSt8UKj15SONUtu/f9V3u2RSmDAzDJg2qQMfHGm5mZK4q5H4NvzbLh1xN3wiKfJ2rgcR11BQa5ckXwfSXI0nEYOGJ9wNQAraKu5ZOjxgGCp05PQdxkt29z9Q1KSmQKvfgRDYUg8Dc0V6qbVDi1SeyC8uJLGX3eLzJjlOOmKgPvWEI0sMkXAEY86VXM/uzQGv9LVsHN9gkfh+HITHc863ukV1ahs0n57ESZL4KJu177OHePnmkkYDP1YQWfD+zqMKYNOKcl0eNhgqrnjYbvYU1zwHgijTsI2/zyPAKUpQuG4xEl6G7tDucR2FbZrfyvY1G10aSysfRTOZppqy3QRtUD1QFL8s3s5KDP8E64wYPblytpmnx7uaGH+aOL0sMU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d4d0a3-15b3-400c-7dcd-08de67ef0aac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 15:22:30.7937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkmEH/xJuf229vLNySqb+rvLB9/vbcos5mbcqA+yOD/1z2LWztK+Y5CluOEdgiz9HfbMmR6dteSOLkY6mcByeDVuxjl5Xl/uXCsHhmaTgvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6310
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=659 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602090129
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDEyOSBTYWx0ZWRfX1jqIuM2pUrPW
 bqd015K2tGO1E4RD7PB/cdUHzwLPOf+aEPY8znXhOwpHQp6RkqibXQbQZlJ6tCXIQc31b7NXoUJ
 cqkTO4z2yyg7CVXC56rY+WIBf9AW3O5NSfKdEl753xiEMMVyH/9F6Y6Q/iYPXaOdtgpu6C7KSiw
 7dywDUqyuf5zNUMxfwSZAaZnarRPJ2aQ/onDjluPP+F2ZSebmaejdtvQqGUyTQMgkk/iqmjsTrD
 Aj4V1cvF9EoljkZ+Pdz+Tz/vTKE2sbOf105C+Uk/21/2uBCs1zUNH/XpgtK+UtD327K7VfY0iMB
 I8Wo+2AX1/efieGhJ/S1co2VDiODcoBLyftsBgplJSFuk6QD6Y3PbyQ5AFrExbTZq03XdAiUpwn
 jRQ8V+5wSbcuMKyuXsrAIToPYn03Gy9efIMrb/c42t/O/+WrLZjAk2ASUVEkMZs7Wn7BvnldU41
 pDqPPfQ0dsE/hgHMT6P6shfI3hPwpizfRAFCspbU=
X-Proofpoint-GUID: ujz6KloJuDEPCohGbYHL66Xrb7tvH5DH
X-Authority-Analysis: v=2.4 cv=V8xwEOni c=1 sm=1 tr=0 ts=6989fbbd b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=M8_tMiBa0-ZECmQipYIA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12148
X-Proofpoint-ORIG-GUID: ujz6KloJuDEPCohGbYHL66Xrb7tvH5DH
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 90923120006
X-Stat-Signature: y79qgnezyz6ywz6buct17n96jhd5ewfr
X-HE-Tag: 1770650581-67732
X-HE-Meta: U2FsdGVkX18Se1K1qpCepOujGWUa9LHOJd5HFwhMx49w6ybKn+19A8lw4zZViklD3m5kSHXIKoIyxpad7/tG0FLqTbX4NJHKVvEq/LTHR56NOslUJiTOpA0KjZa1Z4GeExBgUlo3aJWhrRiOSTBrgNXj+Is5RaJIvX/JIFkj6KPTNl+Stsd19OsyyMwmYnDH4JY2VmczVHSrpdg8rec+uXCqMC9h4AjzNVuLBhec8enjJvcPSzvrlMvfP6T+RDVwQIIYWPsgKEw11wgC8uxmsYiKcvoCESc7I2jefvktpTlMUaNIqWSCemdfAjbglp1zrV/tTMfT25t7PYiHAPUXFggap4oMPFKLk5ob+UhTFsuxBNbeP29Kss97a8sbTJEY4wn8Ui1ve96517MikiWnUjac+62YB1u80+s75Hb4QO3601QAe0wsnM0k/KGcSdJGGdAeHRJar/thJNex+3Bd9GUe8odc+VoNRDx4MfcV72R9alhRzmtfly+sPaAOfsKM0CVGAasu7QM6VONORVZgeHb3xFYdbv5J6FXWoJytmSCHiCZgB5AT+pX0p3WceB4+Hm+CnwdFidLXw4TzcpVtgSnEYDb7mSnCXX8RzrOr+eKfXsc4SI26o8Gx+Ijc7hgi3GWeZVu71I/mI+1MHePuOMwlnKkexTPZJdmj4LSNTwALhlBCIvJb0RmztnYuzvW8CDFjH6MF/Y1gAQwtPNYb9QgW+5ceM9n1b1vVkUSpJ80kP92c58JvfhhOcVfFj6nja4FTh6lamCg6BK8mejMPD12sqc1393sE9J0HmzEKq+mcKfe1ixaSUm/CLmYDX76DPO9L4OLJMeIiX28v3Tu7cko8b1F6XiPmKvtmeOd01Vs/MDfAtnFD5PeTNcq3Hed8r+8Mxpb2/sQHvu6csNPpa6GXRJKl8OceAPgnfrfcNzAfVD4CK30XQFYR8YaWpELytHxCBadyvYatiSzPRNh
 +o1dbuim
 9GtTEBSgWpNZh07AjzIxjzXYhT68wUuZzwXd/D7f7M9zQVRb65x9aD0UvvqR+3RyLShjkn4lZ2sYdHa9SE9UZJaD4gau8vMPLeZEwPmaKL5tvrhOf+X4RfLHmqfXCNBGZTPcZEbGnxMMwr/j3AcJTdP5E2+O+WHIhlcX7PErRq0dYHah2R1Zfm+wtYtuk3wibq9F401feI9m8oHqanvybypApq/ANOB3UiUY19UYOih3DUuemckA6EQ/TuhuDiqRATJR4WUud0ketf0aEew9hDVx+YvNHz9fYUquQtpQ0F2xeLWdsEmF8PA01tqo/77zfgy6rLOvsrj3MA+bbKHiR4PEpv4pMqZca8wRqgH2DNcecJ+r67SVgGIx3EujUDGViuZm6PR50QptCFBVqTfutu8sipuPXrfcf2bk4KSgCP03mpGF0D9AzAe7VPjAhmMXL7u2ZwZuOyr7R9Diz+le+nWSspyLjXpRwWk4BwFrf0fh1rdzIyutjUzg3HwEiU7gM40F7lo+zn9pj+qT+M0SAVdLvKalQ7K4aEfyZU7Su56W5+7J7scjos1RmX6+Xp8bG6xLQDhpyRq2fRi0azkeqVPmYGxUiZOo3ki6jRZKMzwPa8gtTXGyfqTKdUQHknkbXI36UNYNoKylMymhq0BjEj7Ln73Gyu9dyuV9pTHFfdhZ95MRp2A2wtCYvpXXZapM4tVdGDlVPt4FJNUor28C3CVD4W3RgSklKyXhak4e9795pNbI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 01:30:16PM +0100, David Hildenbrand (Arm) wrote:
> On 2/5/26 13:24, Lorenzo Stoakes wrote:
> > On Thu, Feb 05, 2026 at 12:19:22PM +0000, Alice Ryhl wrote:
> > > On Thu, Feb 05, 2026 at 01:13:57PM +0100, David Hildenbrand (arm) wrote:
> > > >
> > > > Could Rust just use zap_vma_ptes() or does it want to zap things in VMAs
> > > > that are not VM_PFNMAP?
> > >
> > > The VMA is VM_MIXEDMAP, not VM_PFNMAP.
> >
> > OK this smells like David's cleanup could extend it to allow for
> > VM_MIXEDMAP :) then we solve the export problem.
>
> My thinking ... and while at it, gonna remove these functions to make them a
> bit more ... consistent in naming.

Sounds good :)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

