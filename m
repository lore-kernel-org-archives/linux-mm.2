Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D457F105F79B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 11:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A816B008A; Fri, 13 Mar 2026 07:10:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5086B008C; Fri, 13 Mar 2026 07:10:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6E06B0092; Fri, 13 Mar 2026 07:10:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 137F76B008A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:10:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D020D1409EF
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:10:37 +0000 (UTC)
X-FDA: 84540771714.07.938CE35
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020111.outbound.protection.outlook.com [52.101.69.111])
	by imf18.hostedemail.com (Postfix) with ESMTP id E5EC11C0014
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:10:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=G+akWfwU;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf18.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.69.111 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773400235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QeTBsJPMMzqH60iz3ulNrn36n+PzkM6fQa1jMRnjxus=;
	b=i/nHtDkJfjRUo6Lr8yhah12AMrtJlsVS0RBCvNZs2dV/FLvLPDp6NTeynjpIS0cUAjMyA9
	MUo/OoXGp0pN4m9P/FXMLItR32o8avxzxodzIodR0NSreS8UjVF49Rk7UvFC+ksG6V1Td0
	xVdPKSsb6tDEgedZehSX5Vic33kgkRQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773400235; a=rsa-sha256;
	cv=pass;
	b=e0s4ztjPhEIWdh8cpKrzYii/3bu1g9sjl3X686/OXk1DrGibTt7+hSg9HPq3ZFZaiZ8dtb
	4zkioKlrRQ0Ha/TzbMieOVTi1FdQRynEBnN1hPzq3prvj/sdCo2pPG5jFubcHHFDjLdXZn
	5Pbys2dxZ/Wbyg/Tk9n6XJLBAmiRGvE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=G+akWfwU;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf18.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.69.111 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o33WZSmXfYh5m0m5dJ/9KQ8o/K71lpG/px6gAnPYbpShNPRvkdEx9ojN2hIR/L67vuUmMa8ZWZ7c+CA7T5TQAOlHrq/nT3NdyVZiUkeuj2xOWhydHYmtOFuk0308s0NBWzHlCueZFbHO/sL+hPkNax+xZEyJsJI9tBJKnP0Yh2VePZwdyJjnxWOqbW05hVAVQyz/2TlFUrGzIe/S4Uw0JeGBUvHHAIvxIYVJcCje7MKX+lsnuYBVSanAddHoBQEqZYA2QoMYxOFMS77ySRvG4G9pGFR+FS0cLDHX9OTpz9ElVBHwLBwjd8MEL8II0eA/Gh/1tf0LJSg1YyZkqJKhPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QeTBsJPMMzqH60iz3ulNrn36n+PzkM6fQa1jMRnjxus=;
 b=Jy/UE7vVjwlkSaeZuhimc4XS1QIT+68HP6xsej8GHGW92LYjhWkwxrf7Ez89hdj3SvnzOJOuik4k6lSt7v0yB3nHeBYgLpunfD92/x7xiFdaEjzr1QuAoQDL56PQVaZcmfghuWWJGc6RZCmuFKJOrNwdGkxQfocAFOdRtPIWa7m9NRByF/pr8SGLs+owpiA5mylnTCHCIOj5H7kbfNu4Fl4OMrvml4cqJ+u9+6uXLybttu2y5/mh2XN5JCA1UJBZuALs9bjGsLFRR+HqRi/LPU8hhyKVU8Qpt9g8ePSOtmYBCOnPifNqVwD1QTCKJR6FM92Z5kkUthK2/eRf5e5hWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeTBsJPMMzqH60iz3ulNrn36n+PzkM6fQa1jMRnjxus=;
 b=G+akWfwUctxJ1kUOMwhepOddFkCcL0JnB3+M0gqV9U2priXcsIjI2h5tb33k4+8Gif3xkqDVbgehVsS6BgsuC4r/0dX7b1tdNZaM9OcBl/AbtiGfw/DFKIiuO4D5b0R3W7uuYrphv0UKnl51egUbAFQZlKqT870pEXINT8GRaOmQXHbGzHW2eg99QUIZNkWz2/bsuoguefi3N6Zvcae3Y5+mhm+hNmpccNi3RZ71EH8B55Zbokv1yQICZE93xaIvOcSBLFknilEOdlgvHHV9K4MsZgL/nOVLCzms0aNZVkH7FnJLcOUVnZD/EZEMNu2QCrvnFib2mdahbdLAknxv0Q==
Received: from PAWPR08MB9008.eurprd08.prod.outlook.com (2603:10a6:102:341::8)
 by DB9PR08MB11361.eurprd08.prod.outlook.com (2603:10a6:10:60e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Fri, 13 Mar
 2026 11:10:31 +0000
Received: from PAWPR08MB9008.eurprd08.prod.outlook.com
 ([fe80::e9d0:437c:714c:396a]) by PAWPR08MB9008.eurprd08.prod.outlook.com
 ([fe80::e9d0:437c:714c:396a%5]) with mapi id 15.20.9700.013; Fri, 13 Mar 2026
 11:10:31 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
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
Subject: [PATCH v5 0/4] pid_namespace: make init creation more flexible
Date: Fri, 13 Mar 2026 12:09:38 +0100
Message-ID: <20260313111014.2068913-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0190.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::15) To PAWPR08MB9008.eurprd08.prod.outlook.com
 (2603:10a6:102:341::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAWPR08MB9008:EE_|DB9PR08MB11361:EE_
X-MS-Office365-Filtering-Correlation-Id: e5343c3a-1e45-4291-34c7-08de80f123c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|7416014|376014|1800799024|10070799003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ysqCcnhsP863pQ+wC5j3+zeW72qjzdzbVWDupTRzAmfT49BcYgyS3BFC0c7iQMCYV4v0e4zxd3clBYgwlQviE8tDpx9GVYW9AuaFZFnP4jI4DAuUH4R0XHK0wgpasTvotlLGATPMdybSHoePu9I359wY1gIyTalS72OtErCeHgWElZJNiXtqGE7Mp+g6VDGxZs+4EGx0X7jeuxwBs+CUaqu2tk1YLGsRl8GUsIuc4kfkDUpOsYm3CNPcnODtFmwjKaFD1cnOj60dQmSfaq8I+sbtVzHQGr80G8ja5K1zb/A/S5EdpeS7jFaIJYQw2JIAy51T/l0t8N7S8hTSr7u4wgdqOfm6XxExNbkmmQSd1PDOiqLUC8e7hR+VHi5ZteeJ8loOJcnJn98x97hy6ZIezDMuwPFl2ZDV405q+epFW+pqK2dxMJCo2pI8n1A0aU9L5kRRQlee93868bLr0+wtSW6OzUyHu46KvMpOAdlbNRVwajtiuj9nA95dX56n9vqImmsMasVpNlW3/mr14H/hHYVCpjreHGOvDYOZ045/h6PidjvwNUPrmJ9oSKzNYWYrk3QI9wOrUz4L8uKsJ5wbL8QDREnrmzp7+JYZK8UAszt96Frt2Cy2bLwjwUvOao3XZ+BKaB9GsX+yC5kD+fi5wWxb6f10J7t7xuLsOsND/l1Pwjc+iIDrrzGmRfAbHFGf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB9008.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(7416014)(376014)(1800799024)(10070799003)(18002099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2Z2dnY0b1FHbGZKWHhpTUxoZGtUdUgyOW5oUUhaYitITUxveDJOVms5Rmo1?=
 =?utf-8?B?Y1RiUE5MNFpCeVJFUkRvK2RUUGx1dE9UWmZXT0ZSVFEzWGRFb3dKRDd2QWVK?=
 =?utf-8?B?RStOUVQrTHlRa1RiSDNLMUtIMHJGUGZBVVZNZXNZSHlGVmg5cnFoaFVHSExR?=
 =?utf-8?B?WHYyOE1WWkF0SzFnMUtVTHhPTDBXczIwYm1YblYrNjZlYnBrS0k1MzVKRnpR?=
 =?utf-8?B?b014VGdLQjI3RGgxbkhuSUVVRjNvb0R1cHNvTU5ja1QvcTNxRWlyWDdjRjRU?=
 =?utf-8?B?WmlDd2FEYUh0aE1IU0gwclZJU2oyeWJaWEtRUDZDWnIzWnZtVS8wQzU0SUdH?=
 =?utf-8?B?Z2QyM3drYUVwNnNVSnlvbzdScWlETThJUVJjNzhwUlBhNTh5QndzYjE4NGFi?=
 =?utf-8?B?dDJlcUl1ZEQ4WVAwYkc4WTVFckFUSmNHVFRiZktDVHJYbzNIbndVQU1IQ2xl?=
 =?utf-8?B?VlhZc2ZnOHkwcGI3YnRGOWRDK09YcFFHWmhDcXZOOWk1WTVETEY2a3FTcHFR?=
 =?utf-8?B?ZmtHNTgxaDZ6TjV3Q3lMdWxhMWVKTnBFcFV4SU41TWM5bWhnc0xvdmU3U0RR?=
 =?utf-8?B?RkxKSTdna3o4c1hOcm5US1J0YmZ5bGhFZHFyZzFSQksxZ2k1aUtSZFYxSHJF?=
 =?utf-8?B?V2syRzFCcEg1aU5IMFRTWUJBeExKVVUxMmpVcGplSzdSTlFlT0dyNUk2SXFF?=
 =?utf-8?B?b2d5aC84Mzc3N0xnK1JxeU5nSXJibmJQdFVNRGdYK1RWNFUwNXhvTXdkRzMr?=
 =?utf-8?B?ajNpWldVS01pVVMyZFlWYWUydFpLcnl1TWc4aWJNQUV1dG1VN3l5ODBocmM3?=
 =?utf-8?B?bG1iY3IydmZBMHN5aFhyeUdyTGFSUFh5M2wrcytQcEh0UHRpZVVBcXZ0VUFh?=
 =?utf-8?B?WVQ1eDBwVjFpZlRpUC9UTEhrL0RINkxLZXNmRGJnYWE3R2JDdVJhQ0x1ZTJV?=
 =?utf-8?B?NEhyVUR1b1BIR2ZTOHFsUXozU0JneTluSStxRDFBaDJrWFFTQVB2UzR1TFJ0?=
 =?utf-8?B?em9aeVRZTm9kTTNRaDNhQ3JYT1FRQTN5OWpmRmJVRk14OSs4ZkIwWFBwYjNN?=
 =?utf-8?B?OE5WVUswRzZ1ekRWaHFacU85UFBwSkZBWTRlMnZrNzhaL2p6ZDJRK2hBZDUx?=
 =?utf-8?B?YmFMZzZxZjlWalhyK2NWaDFjc1pmY1VUMlpWamUwREo4ekhrT3UxRGE5cWpq?=
 =?utf-8?B?UkQ1ZFlTMjlmUTlFS1pER3FtUEo1WEFEa2UvSVFmY1BBTlo2bEt0QlRCY3Bw?=
 =?utf-8?B?K3J1b2t6OTZjUHRwTnlxbVNXSEx1VkNUUGtwRHhoZytWTWlRRkl2S1lhYjhh?=
 =?utf-8?B?eHpPTm41b042c1FRQk9pYWN3ZjF4VGtlRlV2a1VKc21lOWRCTzk2ZDV6R0RB?=
 =?utf-8?B?dHZLd0pVK3RaLy9MMnh3WHNjWkszOGk2M1dXM1hxdEVRQXZoTzJYYlV4WFNI?=
 =?utf-8?B?L1BuS0FGaGxxZTl1OVJCQW5DM2toSkJnVks2d2xObXRkbEJBTDRzZk14YlpB?=
 =?utf-8?B?bWZ0aTIxUWVPenk2ay9hK2RZRGNoM0tQd3ZHSjJpZ2RjdjJQNW9YSnZqSlZx?=
 =?utf-8?B?SGZNUGp2dXFiM2ZwandQaTROc2VrOHFjT0hFR1pQb01TNDVxQjUreTRwbmZQ?=
 =?utf-8?B?c2xpMlVMWXpPK3lhRkhVVWtrcmcvRVhRSWEyRzJHcHhpeWt0TnN0bEVaaTNV?=
 =?utf-8?B?V1NxdUNSWTQ2WVpNaWFBa2ZQaVVwbURtRmdqN1dHMStyUWlKUFNveWFiSHdJ?=
 =?utf-8?B?ckViMEZkRmgwQWp1RHlUaU5ONFFpVjVEZ08ycmI2NUI3NmJ0bDgxYmc0Q1dR?=
 =?utf-8?B?dm9keCtQVkluRTB0VEZqNC9MTTFuU2dCbGF0MTI0RzAwZ2JsMWpUdzBhOGNn?=
 =?utf-8?B?czZsM1F2UWRRYzUwTkRSY0dIUVVpVVpuK0R4RDgrcUdxZnhqb3hUaWltNVM2?=
 =?utf-8?B?VHE2SGkzZTVjNkNwQ09qTjJYM0NmRG5qeU0vdHFCbnhwVmxKbnRnczNWTU5N?=
 =?utf-8?B?eXg3akhuZW0rTVdrTCtVRkJWTllqREJiNUp3YWVHOFZraVVORUFwNGxnMDJT?=
 =?utf-8?B?NHFyV3dscDRWSThhL2k1dWJWZml5VElxWHVTRHhVbXRkWHVzbHFjMitqK2w1?=
 =?utf-8?B?c2ZZZyt3dHRjVENqdTN3bGFMT0kyZzNPVDUvd08zb2M2VFFuR1p6SXhCdkcv?=
 =?utf-8?B?cE9adWtuZEdibW1Kcjg5amdlWkhTSTBJbEVMWEtSWlhoNHVlSjI5UC9ZK2hY?=
 =?utf-8?B?RUhCdGI1Mi8zZjlXd2p0M2FvZTBuQkhiSy9oOG9KWXZDUUhrZGd6cFNrd3NR?=
 =?utf-8?B?TTRhazRPY1NweGJrVzVOV0ppZHIwT3ZyMjhlMWE2SjJGTGtpK1l1cUxWZmJh?=
 =?utf-8?Q?aXvH8F0uDcIFRnkFKxOoItyeiY6TlUnc222dUh7G/GaEL?=
X-MS-Exchange-AntiSpam-MessageData-1: DM01IBMDruPpYpw/EhVINTEAtOgS63nqZ2M=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5343c3a-1e45-4291-34c7-08de80f123c2
X-MS-Exchange-CrossTenant-AuthSource: PAWPR08MB9008.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 11:10:31.0310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DU9OXGA5GCxUfR45Ro7nTNxaDEvpFNTMGb2sU/17jSEiJVdJfNvnPJf0ot+V2zq04np7Pxcqoxuo3kyeiRsEnQVNpGLUxZeBk6TPVr05ls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11361
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E5EC11C0014
X-Stat-Signature: ifn9usjnsjdmem5zs51cjp9hp55y5qnr
X-Rspam-User: 
X-HE-Tag: 1773400234-702486
X-HE-Meta: U2FsdGVkX1+Oxr9l4xaGSFKOjfPVdWyoAip25QvOMuVmZi7zeF1fAQkuxSl72YN4gU3DQTpdbHiZmQhl37o+e1mpviVB+vnKddxCUquvfzjikt/S9g7szIOM4Px15I77R1OCoVBFw0/5gZNBaDXzMBjL/xgEcRgIfI94Ka+iL/XLmGk5jArbVmhG5ygfCytQ3xmc5kN1mYkoYkWhNHvY/pv5tC3ul/JFMR39sC3X8iHVPF5YoKDhKUE05hpG3SEbPMeiKGPDTHL7x+qm8d+aMAE7cbwJp8RCZ3VS4YT2ixvCppT9PRrGH+cbYpDwqWc6RSme3ni3AxTvZG40l9nDDtmPVlaP6gjP+e7lOI2Ts86s7hJADBHcNQwyQHo72hQmK32X4ianQ+Gu98/wTUXDcRx2RebaauJSAZTQDrGaueyRgzAxMj/6gdX5pF93LZDCTuKjkGGVcedghmY0bBRoXehprz9FxRX1mftwhRLOkJrlGJ+BY760/CifFcXhj4G57fjghEejraOCX9Q0F9ZG2H2RoUTOK3YR+ltuxEY9Lgz1PRe1HuU046wfh/PW09V+tXbAa0I6fMAAlP6NuJWdFeWlJnmjPnYrJs3KyIdJL+7U0JvwN3OQWAaIiEmGIV5gAV75OL+XDcqw0fwDBwr+fCnwdjZ76mIS1jLIV6SpnyfRMLjvUvhMTtIpsW4o4KkGdc7AZdIfEcnD9ih6tRUNGXQwvAFOYTjaTK8/9cEb4QlxjLVzm3a4uKT+PzJdqyTUWx598boOxbtq4ONjqT3Xwf95Lyr2fBU0HJdGzRgJHjmeNzUiu1bHmQlaNKdlahlOfS7IOVlJSq8lGcDH50h/GWWLayyA9IdCx1jcJsZiE6wW2ushYBXWSYNX6wvaTcnPWa2BZvE2oNwhsTDtOs7W3tBxv0c5ZnWRRSXH63gzEPlZqHQABWPnSgSNiatNNs14Uxg41BBw4/xeSZuu3i4
 edw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first patch properly annotates accesses to ->child_reaper with
_ONCE macroses, to protect unlocked accesses from possible cpu/compiler
optimization problems.

The second patch makes sure that the init is always a first process in
the pid namespace, previously this was only checked for set_tid case.

The third patch allows to join pid namespace before pid namespace init
is created, that allows to create pid namespace by one process and then
create pid namespace init from another process after setns(). Please see
the detailed description in the patch commit message. It depends on the
second patch.

The forth and the final patch is a comprehansive test, that tests both
basic usecase of creating pid namespace and init separately, and a more
specific usecase which shows how we can improve clone3(set_tid)
usability after this change.

This change is generally useful as it makes clone3(set_tid) more
universal, and let's it work in all the cases evenly. Also it is highly
useful to CRIU to handle nested containers.

v2: Use *_ONCE for ->child_reaper accesses atomicity, and avoid taking
task_list lock for reading it. Rebase to master.
v3: Separate *_ONCE change and "init is first" checks into separate
commits.
v4: Update second patch commit message. Include Oleg's review tags.
v5: Handle one more READ_ONCE case. Include Andrei's review tags. Base
on top of mm tree.

This series is also available here:
https://github.com/Snorch/linux/commits/allow-creating-pid-namespace-init-after-setns-v5-mm-tree/

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Pavel Tikhomirov (4):
  pid_namespace: avoid optimization of accesses to ->child_reaper
  pid: check init is created first after idr alloc
  pid_namespace: allow opening pid_for_children before init was created
  selftests: Add tests for creating pidns init via setns

 kernel/exit.c                                 |   3 +-
 kernel/fork.c                                 |   5 +-
 kernel/pid.c                                  |  19 +-
 kernel/pid_namespace.c                        |   9 -
 .../selftests/pid_namespace/.gitignore        |   1 +
 .../testing/selftests/pid_namespace/Makefile  |   2 +-
 .../pid_namespace/pidns_init_via_setns.c      | 238 ++++++++++++++++++
 7 files changed, 257 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/pid_namespace/pidns_init_via_setns.c


base-commit: d1b4433308592363d133a788f0443d5d63872bdd
-- 
2.53.0


