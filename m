Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49993103E16B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41416B01A3; Wed, 18 Mar 2026 08:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1E226B01A5; Wed, 18 Mar 2026 08:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1616B01A6; Wed, 18 Mar 2026 08:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8839B6B01A3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:23:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53C395A133
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:23:59 +0000 (UTC)
X-FDA: 84559100598.15.CDBE871
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023086.outbound.protection.outlook.com [40.107.162.86])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6F43B180007
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:23:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=GKrRt0tG;
	spf=pass (imf06.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.162.86 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773836636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKPu28Rcf7AjhOJB2C8rhjFC24Bo2XHiAAL87jZaCCc=;
	b=5nYyJcxZYpJTWiENzLh5gbZxFrd9u0NtZ+dChIVZQYHHcvy+/8N6YABOABpwIqv5qK/pj4
	X/9ZshrAEPpBaaZfHWWfqIMs+SCLYNWzd5gzB26MU0zqcgjWaBfS7gVaZsw1g3xTCiFw/J
	LShfoijAckxcaDCpt/dcV7cGwNIYkU8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=GKrRt0tG;
	spf=pass (imf06.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.162.86 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773836636; a=rsa-sha256;
	cv=pass;
	b=qIbVfPTjKnK31bJ/CmuF2YSzxyWAmpPM0AvQO/miISSkHk0HRd3RUF3dIgkfSzwv6gtQJ+
	tE9uhn6jj6KWefPu9zSR7ex2ZA6OU63789RfXA95F+E7FYB+r50HmFGuAo8gyjLKgvWF0n
	qWlU2MzssWEnJTvgGD2bPLq5jpnsuuc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IE3qfqJQ8wCW/WvNFKM/D+j784L3t6sqomMp+cIyTv0CcNzGDwDUYLCZIwERoXXtvgW9Qgc6K4KKeGxC8lBzfszbadkG4fNmT1yais6FHPbBM1wrY7YJKAytaioG2qnOx0906erGBpJk5WPDXfTofXLejoABbhelLxoyUh/eEOKgZ27Lwlr/LIeVSTejYiHh9t131xtga7531opAvT2X1bZEDr8X0DJsfHuySJdVQYhNXBbcr1cuPT7Rm3LjNRK69E6EbQI7dVM+XKgoVhwpN/fSgTPdSWiD03YrKkZFq5+DJNRFJ0H6/95KOgQmcQu/Rcbi37/7i1jFlR2ShrvdeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKPu28Rcf7AjhOJB2C8rhjFC24Bo2XHiAAL87jZaCCc=;
 b=MZbskxu211p3KNuxofwaw5IN13WZGgLMiEFdi6zWn+P+0Kb0OSES8eyAGPJ3uTVfsGIxxRpX4WHBCbbDeLL7rWxMJuePWCgSHB5S2H8w57aO1DG1Rf8Z5LCcBVYAb/n0xNgNlC7OlCEmA617orjvBYGS+RdyfcwthQnwXiNihvmxVCOS2643PmigfJA6rgXPS62NTRo7lrAVCnknXWpvZ2kgQCL8UvscG/3VcG5WV78ACmnnVm2ow8zZJCTcBr1ocjy34/tsG7kXNf5Bfwk5eIDK59gKRbFa3b5vY6vuRszTrzn0RaLrDsBipdnK+fDXV35/CyoNBV59Gop/hEwTiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKPu28Rcf7AjhOJB2C8rhjFC24Bo2XHiAAL87jZaCCc=;
 b=GKrRt0tGDG+2G6hOBDwJiA0TYmf8yAwycSVun/IhsTKytDmwUeyvz19FF1H309V4od8ATxWF7+dKusAPUhS8RqHUed0sNL/kNB5qlGhdunsbajR+bNOSCqTssKgiHR+4mY4BqzxZfR4vHzuCVRhL8JBEXYx8PFDN9R7GgceYzjGTTajSmtZaFxjGrv6BFLHCO4NQ5OPVigheHvP7EgG9j2R4S9SUbpzH04WzQCcbW8kzFKXX4evdp5n9lzPwsrtowi0bzR/BCoGl56lUldrAqDXZYlTDuiL2NVVAg+MZZjd1o1uFT4jTvxbV0N5U4Z4mtSn8SRCtYeRa8m/hviYM5Q==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by DBAPR08MB5830.eurprd08.prod.outlook.com (2603:10a6:10:1a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 12:22:12 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 12:22:12 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
	Mateusz Guzik <mjguzik@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v6 3/5] pid_namespace: allow opening pid_for_children before init was created
Date: Wed, 18 Mar 2026 13:21:51 +0100
Message-ID: <20260318122157.280595-4-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318122157.280595-1-ptikhomirov@virtuozzo.com>
References: <20260318122157.280595-1-ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::14) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|DBAPR08MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 6321cbf1-175c-4fc8-0f30-08de84e8fb67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|52116014|376014|366016|10070799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OyAqhvjDf0oAO3Xb5IkwDqfF2V4opCx3gVPVhD//5ibNVPV+CfkL4bwPn/14Ls1wMEBB3T1Iv4NYP4btBguTPRx0o14mCZfG1+0Qh6lMiq+BWyuZffIA0OANxsEAjfwAkzKLFzf2ybs/vEFp1jOuPmPBGL8ZBIqtCmMbljhen/haFf90j4VEbdRJe2m7+MuV4TlnA1780AYY1PkfGyi26Kg81WT8GgLBW/S1+/1BWweuZzXyUyFvVPbLmt0wl1ktRGvJ5svaJa5/C8eoTBU76dX0cJ9f3VyppSdhpNQUSYr+URue2RrzeDSPx+sUZ6scg+Uih5jQSRKD+ZE0cM274lQDvFGL67oqAqveNx7JEpJm0PWGmMBQFto52v2BzOY4osthx4K5KFEYKfOe8y5s09kMOGnbNYWq7IwPKjijWcsUiDTwX2pXjeC5gKnhuMlWx/sYgxYhx7sHLCL9zaHhlmQ22EsaQTPijiFRWy+DyghiEBdkuZikgjJ9JizTJl8+CEfsjRFl3eIxXkRFRJF3Dy79p81yaKCePIuTiGzS3CjsB+epkZ3zz7EUndMbmd++iwS7T4drDCU385puIWRkOhIIXSiKWx8LuTmQ4ZQ8zD0WIpOm5ZOEmA8SRRRksRE97IdXSRgsDXIbXhQFoSTBgJplKdKKZdXJSp+3AW6mc8kKav/VLVzhYjyo29VKWGq5CWW1r04DKaxaVxZjRtt2pGaBZ0fLqDeXb6m14pWwRE0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(52116014)(376014)(366016)(10070799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXR5UzdCTkt3RGhvQldRQThRUXl2NTJSSjFNMXNwMmsrblpCd1V6Rm1OYXFI?=
 =?utf-8?B?NHZjeHlEODFtcXpSanM2WTBrMkpRWkFLcFlCYWNlTHhUREJEbThOd1h3a2Q1?=
 =?utf-8?B?NkJYYUJFeHpEZE4rN0lmWUwzTXZyYjNWeDVwaXNoWVNDOTdTNHYzUHVoRGdz?=
 =?utf-8?B?ckg0Rks3OXNzaHJPRXh3L2xUTkZoL29FU3JIdnY2WUtMa2N6RThFdUp1VHZE?=
 =?utf-8?B?dmRvTVRQNGJLVjc1d1d3Z0E0ZUxDaERwazlHbmh4eWF4dHJjeW0zajczaVRG?=
 =?utf-8?B?anlGbHdtUWlabHNNU3o0UGI0NDZyc3lGelFoVkZCN1dmZmdWVTRKZmdjRzBC?=
 =?utf-8?B?b0UrOGhNTGREbUwrRi9icXRIOURJSWEraTRoblVaT1dMQUNOcDJDYVNESzBM?=
 =?utf-8?B?WFRUZzhiZTdSaG1GWGxBQW1YbUovdk9qVkVXc21BUDRWRTZQaDZ3c1EzekYv?=
 =?utf-8?B?OGJNS3RYVG5UdDIxRUxCVVhIeEJYQ25oQk1LK1lPbEVOUHdkWTFjSkFlOUE1?=
 =?utf-8?B?WXQ3SHFodGFFZzU3Z1crUnRXU2kzRDQxaFlZNEVvUE9FNlpTMlZMTGJNTU5i?=
 =?utf-8?B?VzdObXpsY2RJczQrSUxqQi84SzlPcVZFSFduZmdYdjdZdVNCOFltanRDN0xp?=
 =?utf-8?B?OG9nd2JxWWtybHpXZmxyUk1xVkR6QURGbUJ6eXpidTZiaExyOEhlM1R4ekdV?=
 =?utf-8?B?bVZ1R3FOYTdsMVQxNW9HYlkvWXVaTEhnVmh0ZW5xK3N3SXFWMTZnd1FBdVRZ?=
 =?utf-8?B?dVJMU3BRdldTY0d4TloxMDErL29QRFhKZjd5aVNVUmhXUVg3SlpndTJiaGV3?=
 =?utf-8?B?QVNUOVFnYU1ZcnplcE9XQXoyZWhaWlhod0lGdEpUWmxEK3Ezb21EMEZZenQ3?=
 =?utf-8?B?NFFqckJZYWJibk8yb0xhY2xYeFp5S3lyR2ZFR0s3MS84aHR3eVc3V2pGTjZs?=
 =?utf-8?B?c0dtbWV1cmdCb0ZON0JFS2FtamxydXYrQXk2V05UUktmQ0pEWWlzN3BwME92?=
 =?utf-8?B?b08rVDJRZGFRK3VlaWVWcm5jSzc1dG5TOXVRSWNDRlVNSkcyOUtHMTBWUnRw?=
 =?utf-8?B?T3FFNlg0cTFJNFMxOHBoUUc0MGZ5eHdyMGRERUM0aklPQXU1V2lJR3RxeDVP?=
 =?utf-8?B?UWpoa2hUSS9iMEYyUXZUUnltL09iK283MGNRYzI4b3ZURFp2RFkzeVhCcmJT?=
 =?utf-8?B?UFRNdy9NWDNuQ3cwZHArSUJxQ3VlT3FhQWZnaUpyOXFNTWdta2c5dFFUdWgr?=
 =?utf-8?B?U1FNRk5obHJ4cTYyMUhZVW55eWNIVWJqUlNXTTZkMkU2R0lNNjlBN2tNZ3do?=
 =?utf-8?B?Tk5vVUFleDFJTCtjRXZWNE8wQ2J1MC9GTzNxOSt4Z0g3Q3VFN2VKZWJsQ3I5?=
 =?utf-8?B?QVZOcmpYYVNHUmlOQnpSa1BIZTJxNVhsZW9Nb0VFMUI2R1hGSHkvSnkrNDN0?=
 =?utf-8?B?SUQxNi9OY1hFUVNYL3lUcUV0VmcyT0RJSEk3ZFdBZjI3bDMrcGc0RTFnNXNh?=
 =?utf-8?B?T2NUQ01od1lGZTcrYzdFNHZGRXA5RWtQMkxBK2RZUlNxRjQ0SkZDd1g5dldx?=
 =?utf-8?B?NzRRTFp5VFdwTWVub0NGcDJ2aVZHbkh6eEZoR0U5WWMrWk1EYVpkNGtEZ2tP?=
 =?utf-8?B?TG5Xb1hRWVU3VkRURHB4YjNneTJJNC9kT1A3dDB4WWJpWURCaDhCZlhEaHlt?=
 =?utf-8?B?Tm1ZazJENGN5TXYwSlhtNk9OSG0xcyt2ZmFrS2FQalhVWVRjTkxPNlhLRWJE?=
 =?utf-8?B?c1pXekZKcE5idGtRY2Z6K25RVTYzWDc1NVVqc3NvUjVpZXN0MTdqeWtzNytT?=
 =?utf-8?B?ekk4UFdIdHhOQWpoeHNZVVdmb3cyOERQck12S0tvV0t2b3lIczNidCtJeXpj?=
 =?utf-8?B?Vk5OUFJHcFVlbUFDNDYxSmh2d0IzaEp3SThOYmp6OEQ5WUN4RjFVTnBCaEpQ?=
 =?utf-8?B?NXJUb0s3UFJHVm82QWlBRld3TmFzc3NBTkpnVXJQL1NObFo4VkRGVlFqdVlP?=
 =?utf-8?B?ckRFalVFVDlzS0lYRU1IUUZ2VGxGOVRZY3ltcjhFaEZ4cnd6NC80UG05MkRv?=
 =?utf-8?B?WDhGMVlXQ3hjSXZEdHNmZFVkSk1jTnpXMXFITHd6ejlYMEJqc21zM1ROY2lp?=
 =?utf-8?B?UFRwcnB5clpUSXBBMTFqUXN2dnNSa2ViRXlpWnR4S3h6TVUyVGxTWmx6cmpM?=
 =?utf-8?B?V2QvZi9ud1JjT2ZQZEx4NmRxYjgyZXd5S3hFZGZzKytlWXhwTEdEOEJPQTlk?=
 =?utf-8?B?ZjZBNDFQbEw3WktKaGZGbTBjWDZtNWFpeS91TkNhTlJBVUNreWFqek1LWFNU?=
 =?utf-8?B?RG01OUhidVE1UmxRdGI0dHhqN2kxY2lvMVpDV0dBMHdRQkhMWFFKK05MZElK?=
 =?utf-8?Q?RsuRVh56pFLqi7XavetbBzAYgJ8K5ji6j6TOSREwxRC2X?=
X-MS-Exchange-AntiSpam-MessageData-1: ftTFZRXBFHpPKApTClwgVBdPT7oNHnSWfHc=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6321cbf1-175c-4fc8-0f30-08de84e8fb67
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 12:22:11.9905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X/HGrdB2Y6tgAq+j+Z2zQqo01waGGYtRmUC7YxqKMNjbh+G6F8hdhvIXbw/Lqz0ZyiuTIqnV+6254dQbJhHcvVMop2MIZWDbyGSMsuu8big=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5830
X-Rspamd-Queue-Id: 6F43B180007
X-Rspamd-Server: rspam07
X-Stat-Signature: rqjspn3ou7dkx57g6rye5nx3abewffj5
X-Rspam-User: 
X-HE-Tag: 1773836636-281073
X-HE-Meta: U2FsdGVkX194yLij2c1oG7gp+OXVdDU++K6z/hNfclrOp2aEvwEOf0PPwAr8qAPqRhd/uF159wCDhjrA+wUkMryH1E/uRtz7CfIgz17qaN3wTGBwJkUdBW60K2EzpzIfEkJ3OqY+GlfkzrG+GwDBM1Hx1V/713Wq00Vsy5kK9RFP5y8xT33UpjsP3O16Bi8UuBABaDXOCkeiWYy8ZbrPrzhRWhQgr0jqcbdpU/6uEdXlBobJvFaf/HWzKeAz1xvDt0ywtvacu1ul+1rYX6nKQHutaPuPViCMrfXTb+L1DD/VHUN/W8JL1c+J4OCjt5LRAF3MUono0VKQ9hxvcOb9mQ+wwRM+w6EnNXWiI4K8hQw7bJnj1uwxflbgdZGcl+GNxhMgE3rYtfTPcJUEnQyHDalGYVYvnqHygta9KgBN+Q4q8cmiObF+7c8BvpPdHMKLtAIssaICkFc0jq4R+sPaWJTgPOUean53jKWYc6I4eoU6fVRPgYMjmLMeHGA1AtfBSjxFhqKOZo3pvHf4bT2Z+5LHAY0F5crp6ut/eQ+VeoU2vXFLECJYBFSqSK/wg5b8hPEclUAUanRz3qzUBaMvd//yrQBfilygCTIoGR70catSHkaZfERzbhr/Z7yr9KcOfMu36A6H1rVs2+j1XsoxqzTkxxC/ZHCRhWzmQ+YL99J8xv0gDRbh7/MT7XsSCbC6qeUO9Z/kHjD8fuSey9aLo+6mGggYa1A4aRnsid58rf+J0M1DBWoAX3NESe1WqszuqYpfWxWjL8O9arQPCW8Tle9d6aMTbyGXcKiMvRqChVJt5t2abwZc0+ZsNJH+4052lAH/08iVmDbeLk77lln6hW36xdO6XQ+nFjRsU2ZbBN4YLq3OLf7YWHXnN8pHwXAljwczK2hrJ7+nGoLsv4BLjq95Z0nLk4qBUXm08eViWSaRpxoKrKSRsUFx2YfAwegbozlbr1mg93tFF0kipiB
 GcZ4R83U
 Lw56lp910/di4x5k3ATgEOkJHqlfQLLW40YSjnpWBeRenAmk6jj3pcLnbOY7ZVJpaWHJqReiVLLk2yIEF28mo7qYF9GiguMyeVGqoatjOAU/r5eqKLbZ2naDt9ZUTIm5BQ7TSKsDCKzoiq/+qUUO97UTphFBQKRLKb7Dkg0ZtMO0gKKYBvKzxuPN221cehwFHUgNJUn6CH1cjboboYMOy/1XEWZw+ac/iA3KZvC4pmQr1qI9b+vnvpTTKO6+rVftVAO7nehY0LdwSTgtgzS2EidO0bCtJsdUw8TpG3wPyl5PrbOkJ6dfruDfr5sxr9+eKHWtSL4YaDMgk443a47E6MwnlbFz5+xOLzwW2cxBoXYdlw6xGAzlMMykACZtTtNBU2Wwpj/R3nOqG24AzYmOSecR5nn6r37Jhss52H1LjO/9sy52RQUlM5wB/t4U05ZDgeJuwMnCzj95GzD00WWe7Z0c/cq0JQaoEWlGA6pd0sfJYvxHKNuRXHqBSDrqM8JbikpW5uwBlOtZWMyYEFBL7vFfsmb6/85xO2T1xHMksUMxeKlqgWvi7irlVbWl0cKAZwGUe
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

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

--
v2: Use *_ONCE for ->child_reaper accesses atomicity, and avoid taking
task_list lock for reading it. Rebase to master, and thus remove
now excess pidns_ready variable.
v3: Separate *_ONCE change and "init is first" checks into separate
commits.
v5: Add Andrei's review tag.

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


