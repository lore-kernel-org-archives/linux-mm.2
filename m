Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15918F3ED67
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 01:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B67C6B0089; Sat, 11 Apr 2026 21:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35FAE6B008A; Sat, 11 Apr 2026 21:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227DF6B0092; Sat, 11 Apr 2026 21:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F70E6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 21:32:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B156E3BF5
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 01:32:29 +0000 (UTC)
X-FDA: 84648178818.30.E67866A
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012018.outbound.protection.outlook.com [52.101.43.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id AE96A40004
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 01:32:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="I+fQUUK/";
	spf=pass (imf12.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.18 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775957546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96hMw74eE64KSbnsRaJt29cyly9A8JuzZvYS2un1czw=;
	b=38FF9SS5rQJiLk3Oc0LV3e3JGUg4WQJk6m1Hp/WeSKVtMOCr9Mlybv6kFcd0XcvuBDJGQI
	2PDgCD5SlxJtpPNDSYgHlaFv9SzSCNB99T+8S7m+j0vnzS7nIlmSZx6vf6b9DXJS5Bjub+
	eqj69kCAp1deIno47h8VnonZdfZN9nE=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="I+fQUUK/";
	spf=pass (imf12.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.18 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775957546; a=rsa-sha256;
	cv=pass;
	b=WxXAJMsQbBNmizPiMv3MuxmRIGA+1+LJ6nB0J9Oq4kE6MrLSMwmrKq98UXTqdMOJd/H4Uu
	o/WA6Efhf8dxvD7elShWlizkJJwhvL3IoAAzlkBtQAJnv2ekHUaf8mLnk1AXYS3uE8XdcO
	VmIqFX8MxB5DTpoFw8sQnJwqeBRcax8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i8UzFPpkBjbTKmYUfmlPaoLtOPT0bGTHjOWltpG6ODLiRgWduFwDVCGs347HKNfpnmuLEu7Y79YUOu5Tv5QxLSPHjEg3Vo7ZT2DSoG4BrGfzjhsXJnb+qzbBZBzICkqGxj2qTQpTN2HOYJVba3w5XDJhNQhspMMyTGmKUHcJsr0XZOgKHBe2QVW07fskm41Y05S2zmjQreL6qKagO2tYqc2sRZcN28maJBIwC1S/3aB51miNO+/pEkv/SB4pnGyWO6PGIa1rulmQnJeW23lr2Uy9hHc6tCK0m5ThyWiJBxvZ4Krry6Hgrn7Tp7Xrm7GXqHGmy1IPMwt5eM9EMAiIuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=96hMw74eE64KSbnsRaJt29cyly9A8JuzZvYS2un1czw=;
 b=LQms59GxQ9x0c13sTopy6nEGFwfvjWd58tF+Pp8YiGH7rkMkRvRN+8k1O3LqxFZgpSeHcf5bFPj8Qyg3ABaJ4j/kuhCll0SL6mZkAacX7+NRFIu7wes+uu1J7fqBai9tKQdqo1fVMFr9N/pkNfxdYro8VYGsMRpjbqM9DaW5sGdsMKpm4RoJ8pCEMau88agmOHl+IJzIVHzGOf7XgoFsflhRgMSLBgAvnbZCQpIMBBuRMUihFQRzIg/oR7o/tsb250HHnZ7gfhXC9WyGNi1WXZx3mi08gHwb14oeC54dIpf9qaovj3YMwhlxm/Lthn4OpMhlf93zaJAQhWRJ0AFLug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96hMw74eE64KSbnsRaJt29cyly9A8JuzZvYS2un1czw=;
 b=I+fQUUK/mOiiPaNIgrQqOsEa2dGN1pgqtzy/cH4M5bmqL8/acNGg3/Po3HXGnrHbAEXa+MUQHgtv5grVtbCpP51y3RubCDUrzoiGMHCDW39cA85UY5KxlzIWsGw2mEmenpx/b8OFy6mF9lOVd4mj1B5p0mDobouF5aClglujABDWR7eo/OMstmbiTjAflIEtsk178KP+P4Moyc+qWvMajyjvX2YHQEir7HANjTPzr23TXaAtVjnYSNJR28Js23OJb5VMS+k027rf7NGpLQluoLmKzN6UKkz79FwNF1VFNtwJeuqeT9S/uWfByQgK2/2ywpwbzTD64ZvxPVf2m42Hxw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY8PR12MB7316.namprd12.prod.outlook.com (2603:10b6:930:50::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.17; Sun, 12 Apr
 2026 01:32:19 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9818.017; Sun, 12 Apr 2026
 01:32:18 +0000
Message-ID: <aaf85ad5-477f-41d1-a4b0-85789640df02@nvidia.com>
Date: Sun, 12 Apr 2026 11:32:14 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/zone_device: Do not touch device folio after calling
 ->folio_free()
To: Matthew Brost <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260410230346.4009855-1-matthew.brost@intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260410230346.4009855-1-matthew.brost@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0187.namprd05.prod.outlook.com
 (2603:10b6:a03:330::12) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY8PR12MB7316:EE_
X-MS-Office365-Filtering-Correlation-Id: 780aa992-1b06-4ac6-b8ec-08de983355e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7S4guqryE05NDduSJcDtv7LpbdMQXxKiDfYcx2jmFJgiViId8uPQQtdtYqZW2uj9PBxTJRACeowxMbZTrvnsndvWwBoLLYhL0VA/2pUj+FMrj1dYamFAtpPcaSB7fllM5cMHOI+mxQJXcaOdwQ4RmyJa8UFzJ9ZmVX6PLeEqfCmitEZ/DhVLvRViAjBEfssO7JC47Ryo2Aw0c2FQPxx+pYMoMaae3/TRwOuvXkt1yY1GOcB91h5t4KngGQ45qEVF0NklxD9neXfUOv8IsuzEsaagu0FG/IFbJPSC0AKX+l9Zri8f4iKRQbj1Rhd12lYyIom/OPYb7Jobd4+OX/qrR7MH0nICmDyGba1YJYS2bf3KTFJrp1UeWYdRyIEi0Qg407VzhCj2l3IyuJX4WhPSgJVKPU2AR3QC7rBt7iPDmTyFvkWBOY2sqWOCBQnqRz+zz8iITT6Xq07IH1mlL9k/Ydnt2PNIjflPnZq7NLzxgPytADvvFWQ9fJXYzDz2G/qwxBCZHMZ400qzMUrdWYYLZZSjwVrlw7UutQ0+QUr8rQrh0etF1bykj/WzYCovK2jy+G1W17aDIlNYv0vnMvi4U2VtKgf79kR40Qmyc9uj9JAfBL7qMmRo/Cumq4Gsy385N8ABc8S26MpF80X6pdoM98xWlL58boofmJFy7hg4jhxw3jFMsart+nIHPKLmy+mNGgGh8TP/oAVZSuIvhu6IfpGVS7qqB6VJG+Kh7N94d/A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXlwSThJMmhJWHB6U3hQWUFqVHpsY0F3cmM1UHh5empBcWdYbVVHWnFmMFlE?=
 =?utf-8?B?VDVoekwzcUNPc0liTWEybTVCOFlDOWwwazd3SUxJSVM1UUwzSHN6N1Z6MXhP?=
 =?utf-8?B?YkVoSkpnRmhjSStheHdmUlJzRCs4SHM2MWlrZnAvQ0hPYnFqUHlQWWE1QTZ5?=
 =?utf-8?B?K0FYcEowajF4UjVtME5Ic3Zmb010N3QxR3ZoL1JOM2hIUVhVRWViV1JWVFpU?=
 =?utf-8?B?ZStXUmpYa3UzaTNVMzNNdXQ1UGg0Zjg2WmlaMHFxRFpIbGJDVmc0WUpLZkpp?=
 =?utf-8?B?aVd3SEg5TnRjamljYmhEUU9pZStUMUhzYzY5NEpqY1A1ckMraVVTNWxTQ3N6?=
 =?utf-8?B?MlAzcm1aa1NpNDR1ZmNCdmw3VUdTci9jeUxOaGduMTZIcmJDZEVCU3BlblBW?=
 =?utf-8?B?bUZYMjZ1MC9KOTJwbVhKNUQzRVZtcWRKcGpPQyszR1I0U0xldkpFSEpWUzA2?=
 =?utf-8?B?eGdJc0h5UHQxVFBkVW5ZZUFFZWVwUkRMei96WkZDeHNRQ1h4ZVNUV1pYSm1p?=
 =?utf-8?B?NUxKSHh0QVJicUg3eVRmS1lhbVpGNmJvdEF4bEsrYWtKWk1TOU5TK2dqVENO?=
 =?utf-8?B?ZTBwQXRSOC9pWnNoMG1LTmJ5M28zQWxNckJkS1dSdXlXbUljWFpKR0ZIMkd0?=
 =?utf-8?B?NFI2cXhGUDRxZVdyNW0zdlRib2RxZFpLS2M2aHNjdVlSTUQveGZDZ0ovL1k1?=
 =?utf-8?B?WlRJM3NqcTRuWXg2M3dJM1NrM0dwRnpWdENXRm5xSmlFOWs3T3p3QXdFaG9S?=
 =?utf-8?B?MjEwUU9NRGNJSTlKRjNkYWpQcTRSOVhNZGNaT2M0Y3lnWm5HTlpIQXdSZWRk?=
 =?utf-8?B?RWxsaGkvQzNRdEh0SEZZcU1OazBBckJYbE1LMTRPWDUzc1ExcXZhVFNZQVo3?=
 =?utf-8?B?WHdoc0dYaVNtQ1p2NXhER0srQ2VnYmNDcGRMQVFlNzJPNlRiSmkxeU1TRzJu?=
 =?utf-8?B?cmVkR2xRelY4cTlZUmVQeUtkd0wxdUNDTjgxMFFmWDYwNzB5WXdDSDMrNDU0?=
 =?utf-8?B?eDI5UC84TkN3WVk5b21lVGhIMll3TDdwZm52U1ppTWRCVWFWSFhqVU1Xc21q?=
 =?utf-8?B?bUVtUDJjeW5Ha3Nlc2lKMWJJRXkzU0VvQ0ZrdjJnNHRCQ05xZk1YS0R3N0xz?=
 =?utf-8?B?TmtPY2xiWTBrRDFDeUtEYk1PYzUzY21yN0hkYWRDa1JKSEdZallLRTE0UnJ0?=
 =?utf-8?B?ZVQyWGw3OHp1ODFhd1JMZ2J6SzBLZ0IwaU5Ub21WMWFNMVlRSWlQcStDSGZY?=
 =?utf-8?B?UGRMbEgrdmN4TVdjV1J2SGJEbmE3MHBneVhteXMzcTl0T3lxNXhLMDlkSThS?=
 =?utf-8?B?ZlZQOFhkaElUWDhaY3hPRk1EUFFSWVpnT1NhaFgwa0s5U25qRDY2QzRXMmFw?=
 =?utf-8?B?R3lhY01SUm4wb1RyVUlmQWNjY2NhcUtvNkwxNW8yMG5uWHlTSmJQZVhST1FI?=
 =?utf-8?B?LzNzekczMU15TGhHZytCYURaMGNLVW1oc3IraHAzbGZnYlB1SjVmL2pEbGt0?=
 =?utf-8?B?SkMxZldYNjJnOHJzdGU5am1DaUVqcFh3ellnV05qU3lmQWl2Ni8yVzJhazVa?=
 =?utf-8?B?Szd3YWZDa0dRTkRvanNKQTVOcVBKWmpJN2JQVy9Vcys4a3dxSTZoT3EzZGd1?=
 =?utf-8?B?NmI0Z1NFUHlDYjEyV2N1emQxVks1NitJYnNKREFTS1lXdnpGOGlpT1ZKSTdv?=
 =?utf-8?B?NUdkSnhLSHVnV2ROd2Q5UVJ1WjBhR2hmc2huKzVsODdQTWk2ODc2bG9ObXNq?=
 =?utf-8?B?VllHOHRpY2d6bnBqYUJ2MVErVTVHamF4TWpySGZBZURKOFk0TGpCTFNkQ0cw?=
 =?utf-8?B?N0dLQW45Qlk5eldyejZ6ZlZzb1I5U2tmVlBNZDl3MXNlL3ZBZkh6eUtYYmxq?=
 =?utf-8?B?c1czUjVnZ0cvRWhQQjdGMWwxakduMDRadFRFVnRmT0g5cHZkOXJESkRqaEUz?=
 =?utf-8?B?Vk12NlVudmMwSTNwL0lJOFZKUzNaU1F5MTV6S3FZT2t2cWV4all6TU9jNG1X?=
 =?utf-8?B?bldKdHJKdnE0YjRzWER5MmhvemtsbmZValAxeVNOY0YwcThhT1RKZkUzRElN?=
 =?utf-8?B?bFVKUlpmelZYZ1F1RUNkakhjQ0QrbElwR09WS1dxUmN1bk9YaDEyaW45b1Rw?=
 =?utf-8?B?RnZ2WFhpSFA1aGJ3MzNVS1lKZ2ZGQnowYlZVR0ZZQjRoVEZOSVNHMkxwQlc2?=
 =?utf-8?B?SFZwVnczOXd1TGlMQVpjbDlIeU9RWWNyMVc2U2RsZWo3dlZPSm82R2p6bzRs?=
 =?utf-8?B?OEU5NGdqejRkcUR1WGNXbkJEMnlWd2QyVjFESjUrUWl6UFY4cUdlZFFmK3FL?=
 =?utf-8?B?ZDN6VTlqckYzVXdYclJMSit3OFo5d1cvMjhvbHBzOERnWWJoUEtWdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 780aa992-1b06-4ac6-b8ec-08de983355e2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2026 01:32:18.7079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FAmKBWaXtiQ9e7fBoHMeLpnQtSRB1GYvNmP00GICb610HQKgHUdtQqlT/YI+DYmCJaxR/+NK2Niasb6x5Kaj3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7316
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE96A40004
X-Stat-Signature: 7qog7tp9bsc15iife38hsrhnfxqoofwi
X-Rspam-User: 
X-HE-Tag: 1775957546-302637
X-HE-Meta: U2FsdGVkX1/Dt7RoJqRCE53/lV2155TzSgyLne9C5E9iIXO5NpjE+UuMopwxeymuMveh1AGWqkfGeozfPAtHD6i+lNlTYpvC6VdEbgj7d5D1jcKMevqrcERlJSbWhBc0iD5TijGFU6JP7fIaOLWLdSMz59ZUUNcow1XquS1PXA2dtBz3Dx4ysxc7nvd7qp08GBRHRJy16LOR7T4FoTYaXhMCC9ijdziBlj33q+kiQJm+ckbMjVhXpbQSsNhqBmYiDk0ILCaVs552W07VhkxevdrFq/sLra/+Hl8H3Wg/iEjuOXv1Rl1un5m1mOHlSKAXQMed2KSsvJfzh9P2db9p98usjENZFMgtqB4Dki0tshSlXVFrXoLtAq4Ch/gAiUYPZb/BJsiPBEBNRi0euOX7E8aAsEx7pjbj90LSxl5teBC5urPeU4K6QGl+4H8g18gL2r07KqeBbkGrc5Tl7860sxPGpLziNqXn0lJyd/s9T+0Q9UMwKvXzqYvyeVFdvr7RYkwd5Vn6VGDK/PQENTAq+h1zBxaFpaAlXkeRXWDwQvOc057ZUNPdEHSwzNgiKT5GS5+Yu+p1VzA2MTq/jmypq6K5NLCFiwl999XfLPyhGdEEkhFsV0PiAThl8bGX2KS6HSyQ8TIZoMW8QJZdSstti2lo9294pwa+nEoRsD97pBHUCJOFL7kHkxwExw+SrbXSPF6cLsVcqxZcUbKQ3eOhiY6KaAgGNkMOpb5DQR3NVqWxHtcALJY972kuVGrXsm0Aq64LBlPshEedXPYBkBDdH10Ew/G0IajCySnGzrI9Swk3PxwMUJbbxQuFjhkSIRnUhQCEsYtQNc17VtcTjw1jZ1I8XJAHZIDBV8yujgypSkefFUFatA3cnlipjUoMA0vmbjIH5Su/J0rPvGCrcDGpSyV9u376s4VaV87u5k2G4/tD3LdHKvJxP0hMJCqjWtaBBoX/lLYKqr7OF+FhaUY
 +FojAak5
 14GuR4LSHw7z9aC9dbMLHT7nsrldrjm0vQLMi/ukuQdiq67GxQ1MuZwmI1dsg/DhLuTU9NrD1AqyXBLjWx1mf8Tvsw8WR4czk9EkUOqIpUokiFgtrk3DEUp8CAZlBSWUiuBn6txnq/dyaO3s8T/KYALYGh4+i+ANlYO+C8sCeP1adc5WW/4fuEHRY8aiczqwFqCXHsmU4epj6uIwmtOhNqW1wovvKFSTunsTmzCK90Y3COrR4wwDkJG77pA5SoUYVDftvtaED5biI78ms8ceBsk5hqk9wsn/HOHOpkHT8VYBGwulhoGR0N21+edoVJRG5CuHJ+tRXYP+gPrUSPxCvXsePwCOAY/lNJpZ4i5ml8RzSRl7GcQu8y5oasc84tOYQQb5Iy71OkJCS7syLvAeTMgpVgK/BTFgdwyACR1eKWe40a7ydvmVZFrS+MiZiU3Y2WkfA4mcCB2clVPZ8+k/3Zy3LKah7tYwOAEh9Rrl1eF6HYT4DgABuYGa/KpxbvObIjTzXL6R0OJRmhTyCkRZEcRuIjCwdHLbjprXSskd4LnhbTToL8BXR5ydFE2ccj+OvP8BJeCvhiidEJqERe9cJNu5tBfPPBI9BWwxUc7H5amuFVNFghquf2lvjf4oZ7wV+kg4roOSYjvWF/oY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/11/26 09:03, Matthew Brost wrote:
> The contents of a device folio can immediately change after calling
> ->folio_free(), as the folio may be reallocated by a driver with a
> different order. Instead of touching the folio again to extract the
> pgmap, use the local stack variable when calling percpu_ref_put_many().
> 
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-cxl@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> 
> ---
> Stack trace:
> 
> [  631.875165] [IGT] xe_exec_system_allocator: starting subtest threads-many-new-prefetch
> [  632.282992] Oops: general protection fault, probably for non-canonical address 0x900000000000000: 0000 [#1] SMP NOPTI
> [  632.293469] CPU: 8 UID: 0 PID: 59267 Comm: xe_exec_system_ Not tainted 7.0.0-rc7-xe+ #281 PREEMPT(full)
> [  632.316023] RIP: 0010:free_zone_device_folio+0x149/0x240
> [  632.339782] RSP: 0000:ffffc90023d1fd00 EFLAGS: 00010206
> [  632.344947] RAX: 0900000000000000 RBX: 0000000000000001 RCX: 0000000094472d4d
> [  632.351991] RDX: ffffffff8155c76f RSI: 000000006f2213bf RDI: 000000008e84943a
> [  632.359042] RBP: ffffea0ff4030001 R08: 0000000000000000 R09: 0000000000000001
> [  632.366094] R10: 0000000000000028 R11: 0000000000000000 R12: ffff88811828e400
> [  632.373145] R13: 0000000000000000 R14: 000fffffc0000000 R15: 0000000000100073
> [  632.380194] FS:  00007f2f0fdfe6c0(0000) GS:ffff88890a7e7000(0000) knlGS:0000000000000000
> [  632.388186] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  632.393870] CR2: 00007f2f002e90f8 CR3: 0000000106708002 CR4: 0000000000f70ef0
> [  632.400919] PKRU: 55555554
> [  632.403605] Call Trace:
> [  632.406039]  <TASK>
> [  632.408131]  do_swap_page+0x146d/0x18c0
> [  632.411938]  ? __pte_offset_map+0x3e/0x190
> [  632.415994]  __handle_mm_fault+0x6e8/0x8d0
> [  632.420053]  handle_mm_fault+0xbf/0x250
> [  632.423855]  ? lock_mm_and_find_vma+0x41/0x6f0
> [  632.428256]  do_user_addr_fault+0x168/0x690
> [  632.432399]  exc_page_fault+0x74/0x200
> [  632.436117]  asm_exc_page_fault+0x26/0x30
> [  632.440092] RIP: 0033:0x5587554ff70d
> [  632.462142] RSP: 002b:00007f2f0fdfc970 EFLAGS: 00010246
> [  632.467308] RAX: 0000000000003fc0 RBX: 00007f2f082e1fc0 RCX: 00007f2f12b3287d
> [  632.474355] RDX: 0000000000000000 RSI: 00000000c048644a RDI: 0000000000000003
> [  632.481404] RBP: 00007f2f082e1fc0 R08: 00007f2f0fdfc958 R09: 0000000000000066
> [  632.488450] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> [  632.495495] R13: 00007f2f082de000 R14: 0000000000c00002 R15: 00007f2f1319e000
> [  632.502547]  </TASK>
> ---
>  mm/memremap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memremap.c b/mm/memremap.c
> index ac7be07e3361..053842d45cb1 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -454,7 +454,7 @@ void free_zone_device_folio(struct folio *folio)
>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
>  			break;
>  		pgmap->ops->folio_free(folio);
> -		percpu_ref_put_many(&folio->pgmap->ref, nr);
> +		percpu_ref_put_many(&pgmap->ref, nr);
>  		break;
>  
>  	case MEMORY_DEVICE_GENERIC:


Reviewed-by: Balbir Singh <balbirs@nvidia.com>

