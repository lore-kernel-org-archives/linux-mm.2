Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA2BF3C9AF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BB356B0098; Tue, 24 Feb 2026 11:50:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C9B6B0099; Tue, 24 Feb 2026 11:50:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854776B009B; Tue, 24 Feb 2026 11:50:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9166B0098
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:50:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E08C574A5
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:50:45 +0000 (UTC)
X-FDA: 84479939250.15.9C460CE
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023097.outbound.protection.outlook.com [40.107.159.97])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0F57740006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:50:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=ieOriSSk;
	spf=pass (imf27.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.159.97 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771951842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tlGIDbEf1ddjkYA0azvZwfggrHiyYDeo2BRWTzlph1I=;
	b=cy7yMgT/GRPj2tDSKkarsQPqEak3phGISsZr3hlpyYNvxnFW77bPmmtQ12eW4Oh6aJoMDz
	x+9cKI3OqNQAUsErYNMeu561EgVQ97Ff1uKcVJ9v2ZhPchDzcRINcmsCaR7OQ0jwyGKxJR
	M0ri/WLwCxd9Xlc1tw9fuWmj/AY41E8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=ieOriSSk;
	spf=pass (imf27.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.159.97 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771951842; a=rsa-sha256;
	cv=pass;
	b=MqXi/eduAACP9NNMLGXrnxd21FT9CAFHwu82/2+8Ljn+Gn4RizxrrjGUMsVBq25nPJb2QM
	gq8duhlBXt3Ai8YCQFhWaJwV5IYSzKy1SRcCHUFhHFf9Td7mJqqKxbiYGNr2Wmj4ub2RJH
	AQZbt6wYxiDX2IVpIEFXqf1cU/xynto=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HuzqLRcCTYw4M17luHzr+JzkrEXfWnv4A+ynQjhVliiqf3Nf8wEQK1lnt0QnzEmzr/iZbVMFDZRU6KSm9HXGIT9ECTbbXbCqu/Fajmk4r2h6kF+eUb/0iMIEnun1/c1uSBhKnUBHBpgkWUae9nv65hS+O1EIcJh45AW7WCniWimzYVHz+UCAiEPfBpDJCRd9e11KGUfTPSG7nPDaMfIAH0lDULdAQG3MX0qL2IP82MMNWs41JjBfhcqvyAleO7AOeW1rK58jodmZX+GBox9br/RkVMAs45qkcUl+Q20ArI1JpvKIiS/QD4/RFsxt8Gm/nictV4SD7+D7ktswLZijRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tlGIDbEf1ddjkYA0azvZwfggrHiyYDeo2BRWTzlph1I=;
 b=TJHqVJ9B/mZxTsy6bpuBTOYo0Jr/ckKx/AQH4wJJ/W6UoxroQVGvTXJXUK/q3JWsG74jQPXqqDPBrBa3AnurIjeKdi/Q+CWAYVF0NZv194T0FyK27N/Iiyshy5JLdvkLjs9DD8i41thdXL1LNL7CsUkVwUnQk8eODYWek5r8ME/6+IknXyO5sUOngBHITQ18cxzO/NXL/9zly84G+eKamYttjuAG9Gh3Xz9JPMKY43hsDrt6mbsME5gdoSRzWhRPMcuXYdRLRmKARrtc1yuLzE2r+6Il6f/vp5f0MpQxPBQs7NTICS3zJiA1IUlLz0WPISeCOy44vk+FbXlDhSdf+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tlGIDbEf1ddjkYA0azvZwfggrHiyYDeo2BRWTzlph1I=;
 b=ieOriSSkWOuEVlQahl1Fmsq2K74JcJQ6rOvrrey+1bYzaQpLKILqjlvB/M40fttResR4riCdl+JNbugn/ZIxnEz9t01/V7fOCbpekYuRYgU3OgNLW2EEV2KImakQWgumNLOheUbA00YbqVcSD5l/F5AW30txnTgmWLPndaAKdKA/LHCNu5WvmMlrYPHecQiyvmfqTJ6L8lm5kS/WMVsXVUOnTt65FwYuj/Dls3N1QzJneB2L9HeFWHmhJWQB4/Txf7ufVj4BK12GNLlE+YGHiF+IUIv6lSrvZiwWb+sZyjxbei8xIn50exTbpEiPJKPrCQ4aj1NjmSJLiIkh6BQsDw==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by DU0PR08MB7763.eurprd08.prod.outlook.com (2603:10a6:10:3b9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 16:49:08 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 16:49:08 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v3 3/4] pid_namespace: allow opening pid_for_children before init was created
Date: Tue, 24 Feb 2026 17:47:54 +0100
Message-ID: <20260224164852.306583-4-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::14) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|DU0PR08MB7763:EE_
X-MS-Office365-Filtering-Correlation-Id: 71302f0d-0954-4488-5701-08de73c4a0ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|7416014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZkZnRWNXWklya29WNWZZTzBSNkFyVFBoekZWNTV2U1lnd0t5QkNieG5XWms1?=
 =?utf-8?B?R2dwL1Y1MisxM0xBZUpESHJBWmlwemFFZFlJNnQzU0FlTFZHMUZsOGp1R1Jv?=
 =?utf-8?B?ZlRZcmREb1BybFhDVHhiVlZGN2o5ejEyOHRJLzVLL1hrSlZ3Snd0UUhhR0Vo?=
 =?utf-8?B?N3BJUElSYWVkOUFvOHdjRFZBK3lwazNsc0FnL1BTU1cxMENXQ0lQYithcmFh?=
 =?utf-8?B?L2dEQ3pLVk9TanVFTUFFaDF6NzBLUXkxbWVVMnJDdHZyWmd6WG13UWt0cUFY?=
 =?utf-8?B?UU44bG9vdFIzNy9UOWdITnNLVmJrL0dkQXBSdXhOT3ZDRUlsaVVOcU1FWVNG?=
 =?utf-8?B?VDVwZ1NoRm5IUktjU2t4MTdUNnM1N2FzQkxJM0VEck9qdWx3c20vTCt2REx1?=
 =?utf-8?B?R2RBbjFNVGcxU29semJINTdjaW42QitxRUJTazZlMGtCYjFURUJZU0ZzL1Nj?=
 =?utf-8?B?VE5nNnFpKzdNSHI1anZmUDViM1BVeE1jblZZV09HOUVjQTZza1FnYSsveWR6?=
 =?utf-8?B?Wmoyenc4Umw3U2hpU05NNGFMLytncWVhZ25aNXU1NkZTTHV2NXhMTmZRN1BQ?=
 =?utf-8?B?UHNuWU9qWE1YSUZNUm9XdFh0T1ErTS9BZmxES0JBSkFESW1ndjN5bkZISnhY?=
 =?utf-8?B?WDJ0cjRZZ09seXowa2h1aXo2M0YzdWVEbTZSY21NTTVxVzl2cDJCbTQ3Uk1o?=
 =?utf-8?B?cUlYOEZNMDNNUVcvZU95V2REdUpETWdKeW1PdXJWNkFGZ1dCb0FraWRuc3U0?=
 =?utf-8?B?RGxUKytjd2ZjQTdoekdnbExvRWYva080Qk95aDV1RVRSOWVWUkQ0SU4wSVl6?=
 =?utf-8?B?ZzhabVB1YVkzQTNickJVd25uMmNDSEZGV0hxaXNQZFFocHNrek1ZanNoS3gz?=
 =?utf-8?B?c2hPOGhPM2FpcTJMUXIwZmp6d3ZuMWZVNU5hRlkrUEwzNXAzWVNOTnNWVmJO?=
 =?utf-8?B?U2xXUjMrc1Q2dVY3UTJqOVBEVDJva1I5d3UrSHd0TDlwVzVwRGhuVWtCMk5V?=
 =?utf-8?B?cUg5K3JEQnVxS2RRZXFJK3lydUg5REZsWm5nTmV4OEs2RUUrSXZoaElOeWJZ?=
 =?utf-8?B?NzhkNVBVTTlhNGhGSzEzK25RcGRKUWRXQ2F6eldtMDhyOUhkc2Q4cVJXWVph?=
 =?utf-8?B?MkxjdllTRi9SdU0xLzhpWjJCczhZTzQ3RzhGNkZoR0tDWVdMbXN5WW9nUDFW?=
 =?utf-8?B?MmIxeU1yaFRVUkgzTDhzZDU4eVgxRDAvTnhTUVdaR2ZJcU9sb2V6bHE0SWRm?=
 =?utf-8?B?dk9xbDBPbEVEcVE1WndzdGZBTXVtRjJwd1NCSnYwSjhUejV3bmZSNDdiZ0xL?=
 =?utf-8?B?d0FhQjNNOU9EVkJMY3drcFoyaWJWY0xrZTJZR2ZaOHlYTWo0c201NXZQQTgv?=
 =?utf-8?B?Y1ZCQXU3cDExK0hqa3NlNlI0Y3F0MTF6Q1htUHVHQlBnRDJaUy9NWkN4ZVcr?=
 =?utf-8?B?MWRwRVRzc2REaEdiRWpDbjQxVUhOS0tGdVR3UUFYVlpWWnBSUDZRREM5V1FN?=
 =?utf-8?B?Y0Noc05VZVFFWEFuZW9HdjF6Y3RROXlBeEtYVG4rY0hFMENPaVZQSGRJVlo1?=
 =?utf-8?B?cEZPMDVuY1BtK2prekx4VDlobzhhVnhxaS8rMjZRUkNGMlZkM2ZFMWdheXNa?=
 =?utf-8?B?NlNqYjNSUnhwc3JTWVFMVXc1Nk9NMDQrRDJSU29JQ1VncGZmNC83TGZRdlF5?=
 =?utf-8?B?NzdsVWt5Z0o3RElyZE13SGpGbENmaGtBVVd2N3RtY2hLM0ZiYmxjK29laU02?=
 =?utf-8?B?ZmhhRGdVTkRKMmRMRS93Nk5vaTlwMnd3YlNOYzVMNVBweUFRS0gveGV5V0hq?=
 =?utf-8?B?eVl5QkRtYkF2b3VXNzBQVHlKem1qM1g2SmlTUzVBbG9ZR0E2RzhrOVFlWTd0?=
 =?utf-8?B?a09yczNyT2xYR3ZSTEYwR1k3eUZ2MktEeXZqWjUxVGkrazFOVCt3NER6U2dp?=
 =?utf-8?B?enQwbWNPT0thMFhROEd4NEx0TXpLTmEwRGhWTCtDSk16QnZGTVJaMjQ1NFZt?=
 =?utf-8?B?NUV6UkxObjY4UVI5THFoamZrbFdoNVl1RlgvTCtlYW5UeGNlVWwzWHd1VFp2?=
 =?utf-8?B?MFV2UHlPSnZ0TkdPSFhBTm9qY01mTEM3ckRsOUVOUklVNlEwTTZJR1c2U3Yx?=
 =?utf-8?Q?U890=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(7416014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmxvZU9ZaDFiMTJXSkdFSVRWQTczQWhwbWc1SFd2Wkh2UlBFMXRUN29CbU8z?=
 =?utf-8?B?WkdrS2R6eVBNT3pUc1N6OEJuWEcyK0JFRWp6aFR5QmpSZWFjOC85SVVuelJH?=
 =?utf-8?B?VmhNcjFjSWFPOHRhVldUMmx1YUE4QnhjZVJ2aUVveXVWUUprRmZQMlhzRlQz?=
 =?utf-8?B?elBFYmtwR0M5ZWtuTjNuLysxQmNtYldmYUh4aVR4RzNRVXh5Nk1aZkVvRUJv?=
 =?utf-8?B?bmdpY0FaZXM4OHd0M3E2c3lYT1BOYUdlWnF3UDJNcjErbStpUUlmVUZDeHNG?=
 =?utf-8?B?eGdrVTdsTnh0cENWdStiZTNzdHgvMEFxMmRxNHFLVkI2bzROTkk4bmhJSk9U?=
 =?utf-8?B?MVR6QStwZWp4SUFycENuY0tMbFNodjhkblljK01yK0VQN1FzZGxDcXRWWC91?=
 =?utf-8?B?Y04vS1lzOUNubU12czZaM09SS0JDcGkvQ0tOZ2EwcTZjRklLb1pJTDBXUUVR?=
 =?utf-8?B?aGdMUkRqVDkzdWwvbndZOGFlR3VwTkd5M0o4Y2Z4clo1T3BnY2lhK3hVcGRZ?=
 =?utf-8?B?ZEhKbUpBenNkREozNnRseE9ZcUYrS1NpajBwSGdvWHd1TVc1bzYyVHNMR2dZ?=
 =?utf-8?B?a3dhR0pXMHdqS0wxeXdCQWMzMU1NRnZGZVFSNEN6R2pycXZIRkh5aUhRTmM1?=
 =?utf-8?B?L295UG0vUGNRSi9BWldudDBFdkF6T2RuQXMySWM3NjNBNFVheEpFb0xiK0Fr?=
 =?utf-8?B?cWZRbXZnWWdySjAzL0hWSy9rZENad0J1bVh6VmpaU2ZnRDg0ZlVWY0dCRWcz?=
 =?utf-8?B?NjNrbUVFKzRXMUR3Q2tmRU42eXNSa1lFb1M3bnVvSlpWam9SUWV2VFlkTGEx?=
 =?utf-8?B?TkJBRERlTGZDZHRKVE9RQ002TUJha29NdTNIbk5LS0R4MzhtRm1rZGNHZ1Vs?=
 =?utf-8?B?UVVpYkJLV3FLbFhjZSs2emV3cHBSaUVDMmM0WGVJMm5tSlhRT0ZUcFFGeWdy?=
 =?utf-8?B?TUdBempXME1YL3BJM0d3UGNmdXdndTVqUGtwd2xjZ0pPMEFYYWh4R3AvY1dL?=
 =?utf-8?B?Ym9ZOTRRcXgxZmlBc2ZHVnhDL1ZQVTVya0ZNbzFlY04xc3plVFhwOHJtSXFI?=
 =?utf-8?B?aFU4N0pGRlJROFFJYnoxQVpQdzhXc3lnYm0yNmh0ZlVVTmp5QUdIV2RRUUo0?=
 =?utf-8?B?OUUzdnAxWlVoUFdBbUN6bHprdEZGYldiTHUzNDFSM3o2Y2E2VkFwQlFsRDNI?=
 =?utf-8?B?TkdYUThWZEk3K3VHZmdXNERzbXRSTEtyU1FoY2dwNlpGdEZtMnpralZ2d2dD?=
 =?utf-8?B?UXVsM1RTZFB0elZydHo4bGVoOS9Va253eE5GWStiblNCMTg1SEo1Q1d1Rita?=
 =?utf-8?B?TVZ2bk5JdVdlRFdrZERzc1Brb1BiWXovVjkvOUY0eXBOQk94Z2E0Q2FVM3Ax?=
 =?utf-8?B?ZEd3RzZ3enVGQ2taUkV0M3Jtdy8yOHhxMEptVnp5WWFZV1F2R0FtRmxyaUpD?=
 =?utf-8?B?TFYzM1VhTGR4MGFnRU4yckQ1UnRUYU5mUHR3UGRpNU1qd0w4TlVvOE94dVJu?=
 =?utf-8?B?QXJ0c0E5MWhFMyt1ZW1PODZPbjNBSUh5YzhPVUxuMHpTVDBzdzg0L1FlT1FL?=
 =?utf-8?B?WVRTOWg1MUJ0dGZMOVZCQmZWNzEwbnZONU1hajN2QUhuSGVZak12ZHBQSjFX?=
 =?utf-8?B?QzNlVlJEeDZySitjRlJLRmdGSnoyeFhZbCtIS0xUU3V6dUlOYWNrb1U1Nm1u?=
 =?utf-8?B?Zlp4SldiRjZPaDREZVR1YjVpNlpDZHE2Ylk0UTMxemFKUStqR0JIc2t3Vmpq?=
 =?utf-8?B?c1ZUVWUwNVNVN2p1SWRnT01jQko2dVl4STIwZGRHSHo2YTdoWWs5MHRyWldL?=
 =?utf-8?B?dkpNYkxZVDFUR3FibFhrd2pubURXS0dPdnBtb1R3YWVJUTV4RDlFM2dBc0lt?=
 =?utf-8?B?eXRUY09PclpmQXhhSi9pK1YweVZ1YnErMGx0aEhERXk3Mk1iVmFPYXFLK3Fk?=
 =?utf-8?B?Q2Vzdlcva2Q2MkRkVmNZTmg4dFNGa0ZkOHV4RlpIaXMxekM3ZlExUkhHcnhL?=
 =?utf-8?B?aEVtNWVYdjJwR2s1MWVsbUdHYUhKcmZ2eW9QY2Y4bnZLZlVCVXpJMnZBbFlJ?=
 =?utf-8?B?d0dpcUxMbnZBRWxZcjQyQ1BSUWF0NUFrSUJBMzVpWWVwSmgra2p6M01mdmZ6?=
 =?utf-8?B?TUdQcGdMRWFSVGtzeHl6UTFvNFV6Nm8yUmYvcDRYYzIzTk55cDRyNHdoYk5O?=
 =?utf-8?B?a0dIWnBHT2lhcmpqN2V1UmRWVGJ3M0p4VFpZNmh2dU5sRHBFS21mdGNPOXN0?=
 =?utf-8?B?d0x1UHRSL3hsdHo3aHdMWmVxMjdZUUtCNjBVTkhEc2QwbWxnVXNxN1AyL0ZQ?=
 =?utf-8?B?MHJFcEFrVUJ2di9WYzZBdXVqakt4emViYms1eGtjd2x5cVExSWU1OTZDTzJD?=
 =?utf-8?Q?k4uRssHuXEf5OfDZYm+y99olIpDbTdpYjPoxH7yJMXfcs?=
X-MS-Exchange-AntiSpam-MessageData-1: /YkV55pBzNdb9p/xa6ONKx7+PGvzfVaiB4o=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71302f0d-0954-4488-5701-08de73c4a0ed
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 16:49:08.5517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CCsg4hwcqA6MmpNFnL+2gdZEOR9pOVpjlupriXOIZo49F/xlkx3yNrv+cphUJbxOvyA6poSBjdIhd2R1JYUdHRqK5G/mg4ZcoHtop2CMziE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7763
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0F57740006
X-Stat-Signature: zdhqy9qxh6wskgmts3fz7s9f6fuwhhc4
X-Rspam-User: 
X-HE-Tag: 1771951841-905182
X-HE-Meta: U2FsdGVkX180ocKA8NHFEDYm6F8tlQ2Z0aDMkHX5dslrm7LEHu4hDomveAOxpWujQ9tdat8hJQOZxfmUwPs21nRKNZUup3MvoYc7ZMXDzpQgaILppnpkwk5mpZteyKmz3nqDF4i5YxFj54NcsCnsGrGTlFacjGFvJHbsoHZs8l4NmYKENDe0U9Tz5mWHIy5bVuhQ6BzudH3XohS5aofq4avQofHa93jpw3HgjzFhjdXnOwLwBOL58sa0NMpqhXdm4u446MbfjLIpKxqg3Yqu8lePD9NwrdT/m60HDxyy8YpU7HRUKSPsY5J3aGjXVP88NBh3zGsb7q48Olib+REe0s/bqNrTlDarRqHXqVeq9Vhzga8QXdatyPUY23AD8/18ItCUXfTuv19iU/0XMwwrY49zxgXsEecONL8ZmkDUqL+UZKqLmDNm4jnfjD8CPPh1KNXUQYP+CnCkzmbdgNgub5PUWLAwfUWpIgAVO1bSlcHKKrJrMRGSiskGg518Kvml4jPKoaakb77Es18uv1AULmnE7bJ2822wp1dBRt2OLnJ4e3NrpwalaVdE+yac2bObi2Al7CRnxaIKZdzlVFwrA7AEoC7sZJalv2ywz5UaJVY9Ps/8eUjSHtUngJoTQwARcTW6KElm+YamobRn7yxPMVs/3OkD3emf0IuYsi1gXUyJhsp3J2+wxyaxA/osOdoHX6PS4Ij2N+nUzbneZAiY5ULkmixLm4GV5YC6rBiYOlEyGfmzC1s6+VoXIbgjmZIOPsGyFAXQaaqOkjrlTLMY4tAHJIkp5JECBHETbsX5df6HIxtwR3gSR3rHbRDU25mbc0ZR87V8KqrA5o+30vSusgYRIItT91R5VeDe+BVS1pgRFLfALSXBsrl2FxBAelYUUSAQXRIEZJ74+Tg0ORpa3y6fDTpnbfKvkrnWR05JuQzWR9kkK5F3yZ++OeMi8486Cy7rvn0cIcjtSW1hSBf
 SZAH9cBo
 OtNBpvXbNc00AmDdokMkeli+iTwLXYUKFf3p53zUoVOUjWoNvjJ166LyUlcVTMCrHqZ1omvKTzkDsFIwinJPyvzGNOiVNoS0kNVqVBA8NKID3strLW0ia0Veg/kgdGeQwS4vy4tXu5OOqfqC7S67wCCZZtW++yAKegiTGDl1ARg4f/g0kllI+pPQNTst35BG4ucKjmMve43qoiyg6FTP0fIxmCaD2T9CblfrF/26xwl7AWHyz5q2utdNL1ardA6vActLoiA1hygYVWYEF71+YE9hA79Gt0uCQ/pSglUF8UG2ok1oyInTz9AUubE7oDi5LzitP7XaFPeNQmZGgFyC8yGqborYR4w4aU/qfFhxPPjgKVZIlYnif+4L+aoCVf6OTQ48wnoVogLQahF2AgeG3KIX2UUl/FdaiBzbEM16yWKTpbFRgl9ibxgS+YpAE96Q6Fpb4tbO5wzXdPPZtk0tIMdjK6vqVLkqJhLW5dDOuo98d0TyUFRcfOcnQ59AhGgeUmCpysl/00uRmbhY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This effectively gives us an ability to create the pid namespace init as
a child of the process (setns-ed to the pid namespace) different to the
process which created the pid namespace itself.

Original problem:

There is a cool set_tid feature in clone3() syscall, it allows you to
create process with desired pids on multiple pid namespace levels. Which
is useful to restore processes in CRIU for nested pid namespace case.

In nested container case we can potentially see this kind of pid/user
namespace tree:

                            Process
                          ┌─────────┐
    User NS0 ──▶ Pid NS0 ──▶ Pid p0 │
        │           │     │         │
        ▼           ▼     │         │
    User NS1 ──▶ Pid NS1 ──▶ Pid p1 │
        │           │     │         │
       ...         ...    │   ...   │
        │           │     │         │
        ▼           ▼     │         │
    User NSn ──▶ Pid NSn ──▶ Pid pn │
                          └─────────┘

So to create the "Process" and set pids {p0, p1, ... pn} for it on all
pid namespace levels we can use clone3() syscall set_tid feature, BUT
the syscall does not allow you to set pid on pid namespace levels you
don't have permission to. So basically you have to be in "User NS0" when
creating the "Process" to actually be able to set pids on all levels.

It is ok for almost any process, but with pid namespace init this does
not work, as currently we can only create pid namespace init and the pid
namespace itself simultaneously, so to make "Pid NSn" owned by "User
NSn" we have to be in the "User NSn".

We can't possibly be in "User NS0" and "User NSn" at the same time,
hence the problem.

Alternative solution:

Yes, for the case of pid namespace init we can use old and gold
/proc/sys/kernel/ns_last_pid interface on the levels lower than n. But
it is much more complicated and introduces tons of extra code to do. It
would be nice to make clone3() set_tid interface also aplicable to this
corner case.

Implementation:

Now when anyone can setns to the pid namespace before the creation of
init, and thus multiple processes can fork children to the pid
namespace, it is important that we enforce the first process created is
always pid namespace init. (Note that this was done by the previous
preparational patch as a standalon useful change.) We only allow other
processes after the init sets pid_namespace->child_reaper.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

--
v2: Use *_ONCE for ->child_reaper accesses atomicity, and avoid taking
task_list lock for reading it. Rebase to master, and thus remove
now excess pidns_ready variable.
v3: Separate *_ONCE change and "init is first" checks into separate
commits.

Note: I didn't find anything in copy_process() around setting the
->child_reaper which can influence the pid namespace, so it looks like
the pid namespace is fully setup at the point when init sets
->child_reaper to receive more processes. Thus tasklist lock looks
excess in pidns_for_children_get()'s ->child_reaper check and it should
be safe not to have it in the corresponding check in alloc_pid()
(introduced earlier in this series).
---
 kernel/pid_namespace.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index e48f5de41361..d36afc58ee1d 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -369,15 +369,6 @@ static struct ns_common *pidns_for_children_get(struct task_struct *task)
 	}
 	task_unlock(task);
 
-	if (ns) {
-		read_lock(&tasklist_lock);
-		if (!ns->child_reaper) {
-			put_pid_ns(ns);
-			ns = NULL;
-		}
-		read_unlock(&tasklist_lock);
-	}
-
 	return ns ? &ns->ns : NULL;
 }
 
-- 
2.53.0


