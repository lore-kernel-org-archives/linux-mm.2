Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C0D105F79A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 11:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3D4D6B008C; Fri, 13 Mar 2026 07:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1496B0092; Fri, 13 Mar 2026 07:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8FA6B0095; Fri, 13 Mar 2026 07:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE7036B008C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:10:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 454AF8C8C6
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:10:52 +0000 (UTC)
X-FDA: 84540772344.26.FEAC2F4
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023102.outbound.protection.outlook.com [40.107.159.102])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4CE2240006
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:10:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=fTyGP3Ws;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf27.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.159.102 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773400249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WuJ5oXIQCLPdeIoXrzdBNFWvkjO7nuUndgRMSZAk6IM=;
	b=fdSE3e/Q/SRwUYGzfy/ObRa0/SWTYx/g8iCTzWZ9xxUhLrtejDzMtRTU13JDGCbeN5lKl8
	IN7IGk1B0gxIheHbhWhRjoDwBE/jHmdJbTgnoqEGOH8mlUx/ARatqpra8S+bNdiI6L/YLZ
	aXrYnmQn+7VYZAiVLZ5SFpboslyz4cw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773400249; a=rsa-sha256;
	cv=pass;
	b=c0zTfoPwtuVkB5IXjOOP35LxA5kNnfvGpUqW9/6BUfrwz+SJyI5RHyi51TPbg6nVteTzck
	y37ABrg8kKiOYRio5M9PatAv86TIiaoSNkQDu3Nj8jOolMcKupFktCk/38Z2b7pohLFsPD
	5uSfV/+/GDaFeThBfm4H0LM0DUSCt7M=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=fTyGP3Ws;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf27.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.159.102 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fq1kKxu7gYFd0r7V/WWDUhZnvwIP3vivSTTcbsHGDbYVYSAOW11fDoZ/nubZrDl1v5d5EBSBHz8pOpmZR7CrYLCXxlrig2WD4JXiEfCpSNcU+RTU1ewytVW8VozXP35PbiOJ5DnsOlhFBA6501qWBkeCi3HDtd1GjW/Qbk7V52t2lvP/u85/OACyHcdBJitaXinNNL6W0yVIC7/dzBEgr+Mev5+IqRrhx7zKQ0xjQQ0lP+dVt8MhCta40ZEzgmTrRd1DDOdWA6Gim7nVxWmyFyjz7Nqo6bMgJsTzCko6614jARg/1zf0SJr0G+zd5/xQRvtNaVA25MoBP0qQA/IYFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WuJ5oXIQCLPdeIoXrzdBNFWvkjO7nuUndgRMSZAk6IM=;
 b=jqCcM4ovxmAvtvj30E6zlGBkN0Z28Z1sbGgfd5bMFRXPZz8w1OdEt4Ws4XVHedmtdncKXgVMi4LFixoandSMwP01AGLVlinfTFKe+M+CJQ10pSZ38uziGLhjcPA3H/QpX469xk/i+YPUv8ZjkyIdT72afJvuT+RG6iK02E+Mpf+A6WTID+6ZQPTabkwKXBZ5JNM0ObTqzqsqpVpumKGhxO57rXA2yWV5eVE9wxONt8wX7AwW0cKM2G5v2yGxi4QS+wmoynJ3jLs7HWhDDJtyucuTnnpf2h1TP1fI66+0063cBYsj5Nuk6SQvYljJLEn+0pKUNOh4YFEJqvRGMX7Pmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WuJ5oXIQCLPdeIoXrzdBNFWvkjO7nuUndgRMSZAk6IM=;
 b=fTyGP3Ws8wudi3/KEKp6CI8mVfvLU+xHIQD75nZLOwBOs6GTRCN/PUHnNPaCuAwZ9LXQRmrfdo22tbM1sXdBQIrl0oSP8zvyxuFF/4u8oT1yMyY0h7S/A1qUfYcaAWTWlsR4TpZsOeNwMnRS9jE7pEmu+sdOkOJteC1Z/UdzluCKWLPluFnJ4h9ILPGPst5uq0bafIBe2L1EMR8gfibYniqz0ma7MTzfkC+clR/RhR9r1RuqnZvJNqg1chn+ahjuIlwFQIz4iaFR42l1Um2ng00c9flE4xnAe3iMNHN3kc+2Sdw/8/AFD7ovRYjAwp+ThYkcBscimoxsdol81e1ctg==
Received: from PAWPR08MB9008.eurprd08.prod.outlook.com (2603:10a6:102:341::8)
 by DB9PR08MB11361.eurprd08.prod.outlook.com (2603:10a6:10:60e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Fri, 13 Mar
 2026 11:10:33 +0000
Received: from PAWPR08MB9008.eurprd08.prod.outlook.com
 ([fe80::e9d0:437c:714c:396a]) by PAWPR08MB9008.eurprd08.prod.outlook.com
 ([fe80::e9d0:437c:714c:396a%5]) with mapi id 15.20.9700.013; Fri, 13 Mar 2026
 11:10:32 +0000
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
Subject: [PATCH v5 2/4] pid: check init is created first after idr alloc
Date: Fri, 13 Mar 2026 12:09:40 +0100
Message-ID: <20260313111014.2068913-3-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260313111014.2068913-1-ptikhomirov@virtuozzo.com>
References: <20260313111014.2068913-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0190.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::15) To PAWPR08MB9008.eurprd08.prod.outlook.com
 (2603:10a6:102:341::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAWPR08MB9008:EE_|DB9PR08MB11361:EE_
X-MS-Office365-Filtering-Correlation-Id: 263ac218-bd85-4e14-aa6f-08de80f124ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|7416014|376014|1800799024|10070799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	L+G/sJSuJleetwjB2VYKtovp+PaqwstJAuPDJaqbpOcmWwKWlrAs/gsz4w5bFiX/KW5WxSmRKNCmUeoI70crpLFcm8aPhoXQax1cs5PSeIahY4IwdSnSQQ1tq8YuFBf+fqV9MEzgtfCHGZge6bdGd5pR9VlibAKRxy0Mp0WFOy4zrqKKZlFMdnvNCdF+23JDj9TSwL4uE0S1/3fgIJPN37i8cqP3HBEOH11dz3zrL0KKpl2jiSrhNr75cbYQkT8sBB1mcnTMyT9wmsj2aKqZq9ag7M0qeqCHPHynUo3sAe9fKgkSs314W6C9VUgm/ZYALdN6CrYlSCW5pP9+w9L09XNWQ1DCx13ge6ivS67TUHvhhuJfZ/uur071UvRC1KBV/m2ZDS6Wnlmf7g9rcVUMSgQ2oI3Hs6JT3krrRvT4bLF+LyWEAPavojk37fZh7LEdzIZGJEU6NYKrw6V6pTmTxbpgQQ/rvO1CknvFYX7t5UppqI5mhYn1VGKW1aCUKLYq2+8+32uQmRQV0bl1TwHjVWqvHTJ0tDWfPXCDvpLbyfGoO0yU902SX1TWX7VAfswPRmBAnzzV1xD6gQzUOweAs+2mznLuIw6h56975qBZ0ZkYgELyeJs7BmbOy65Y1iX+5ZZU1t55mI65eSa/lJ/fPb/osCsMXALfBNP1wRAUiggq/Hx8Eg4bzJ/aIXM+/q95ps+E7yD5/Q4jqovoFo0wj2xIRV1N3H+gnbfBeHaMAVs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB9008.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(7416014)(376014)(1800799024)(10070799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jaNQDVOP8vYBWWKkpiGp6AQ7KrPC/uRVX3c4qOIAZHZ4q9oq6Y8zZE1zT46a?=
 =?us-ascii?Q?xSEv+WoQa4Gnk4cW+14bDalZrmI1tF0m5D5785gVfUAloEzkVcZszuadu/JE?=
 =?us-ascii?Q?vlGbOsobP+aMNE+KKWWwJ8tENtojwAi3gL5IwJeZjMBLDM0cRZFQAjjWQ++0?=
 =?us-ascii?Q?wHe13yf6U5R1bbh8AbHFznwJXX5eVmY5yXOWoRJROTJ/AVSKovcmdbaYON9E?=
 =?us-ascii?Q?kPYCZKAes0YqQBwY18Jkg8jhZy6zhWdduQM1jikL4McpYvkFT7SxjN9s90kt?=
 =?us-ascii?Q?FS4GdMWOlaRanlqyK/YUG5m9Ckq/3lFiqDKs0GZq9xBHOwkh4NTECrioG3pJ?=
 =?us-ascii?Q?l0IZkZ+B5XARpID5aG9AB+aaJBwzNtMeWilr1O2ZzOSwMZMc3VlirwTZ9zBy?=
 =?us-ascii?Q?hbSB4QD+NojSDXQ7ycOFPrfjPKzhDW8pimKR0223MysDotPRWtrRjvMSQnfv?=
 =?us-ascii?Q?9CK7xXZNi5EC6zhr5QiirfPL4qjCLl5UE1n6Vk9eGGk9qDnQyTtoU3ZB7ofx?=
 =?us-ascii?Q?ZRx515WqFIDCdPzuvbMvNTAEpqcS7mnRVUwJA6GNVyxY/LIt4A3ftoDJlcgW?=
 =?us-ascii?Q?1LBRPjAkDuRsLbd7t/d/hCVXHVA3IlZfxsjh3DfXDMK7QgtI46LWK7ZZpYxC?=
 =?us-ascii?Q?lAA+fVcfBMCBY447UfN3f7RArZc7G0qVGbRkRXCiRAyvglVsQRNGo+z5JBw0?=
 =?us-ascii?Q?vVCNCpY/2VpmX3QlRkBmplBeq2mqNVgNFGv2o630Btc/wCdOkPolpHFH6lYR?=
 =?us-ascii?Q?6xjEU04tDxhOHfy5kf/TyPgPIgyYFoHsDtXcH76na/n4cTkUOK6UhEU1enUC?=
 =?us-ascii?Q?LCUTz/+S86VTv4NZYgm3VPZIhxoNgRv5FIytJ7Snnh8hSRtJfl28v1sd8kFw?=
 =?us-ascii?Q?yacwM5A6wLy3HJY+FCfajYOHsKY5cT9exOIPY8CtOoiw29jj9CnABcvPkN61?=
 =?us-ascii?Q?xxehYVZvIv9kLV68zDdHqoqb9Zsczm40D6JaPm1uYqc2SaYwuYo1U+U7QGas?=
 =?us-ascii?Q?/JbRcAnYiqOufgzjbaEDENHXhF64txCEORp62sK4t70zRsiDOsR79anrHQAi?=
 =?us-ascii?Q?FeEk7mDVRV1TO3kzaH2guHtRdI6g9xrM70CcEALpqrDVhh0s2FItTfecRSfy?=
 =?us-ascii?Q?RRjEsRmzCIy1RLdIWy6oIbgyg6kFqOaHH7aOhKwZ9/P4LcBjnBT+wJvx4Is5?=
 =?us-ascii?Q?1sBdHUB2vw4oT7yzZnRt2oQdVLs3QaEyyaBopXGJKmHrEHjh7jFHThGV+V7r?=
 =?us-ascii?Q?oYjkZucdrWp8yMenXSfih2hJaQW86FfkObIl8C8cAivxy8QEQyLpCX0j/JAl?=
 =?us-ascii?Q?yHrsZn5GRcxX3kGPn4/Nmbd/dXTZh48jmh57mfvutcN+ZKk+K1iUmqYm5OOJ?=
 =?us-ascii?Q?LnkRMejuSd9MYEbt20j3NwlLzZRnoVwaMvg4ZMgiU3qUXSSzUxVbY3kKjRVr?=
 =?us-ascii?Q?1JK3xHJoGMlDC6uXlpyO4Q2u3DCdg9MQg9n4l6EAFoeWC85TcDOrhnanO7/k?=
 =?us-ascii?Q?chhXI1jeGLzvV8gj0my7pFtfKmEjZJTuiwks/95C8q+OBhV78ihuH60Mqlew?=
 =?us-ascii?Q?ySiJeQc6qut0XcribAMG9dKnCHqFXoa7c2+qfSTQ6FQcunisnsnkkLSwuPf9?=
 =?us-ascii?Q?z1N9A77Kv81kWbW0j5Fiq2pQqpI/UE/jEbq79jtUSkSOR05o9EIMH+Rt1bQC?=
 =?us-ascii?Q?ZH85MuIJ4i8+uuTYWyW9xYO1LG1olNVVWp0V/HaVlnqLBrUP6u5qHQvLndRC?=
 =?us-ascii?Q?PiPmDY/2hNANcaBx4nC4hDX0JtVnWiBM8ujxlCKl3jzgiIoDS5o6PtDVM0AT?=
X-MS-Exchange-AntiSpam-MessageData-1: 9ANRWkPqXqv595zjxfpWm2f2Dwe/OMyZeMI=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 263ac218-bd85-4e14-aa6f-08de80f124ec
X-MS-Exchange-CrossTenant-AuthSource: PAWPR08MB9008.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 11:10:32.9412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AxzZZTWbIbCK+fIAxKkLgNNylEG19dYy79fngDCs6fczuf9gBqyTW3/CqDfufkVcSHXmJ4lumEuJdQmjHIUCNr08cLKlMA3+wUzkanVo/1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11361
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4CE2240006
X-Stat-Signature: impfj3tbauy8nj1n1cykmbikdyast73d
X-Rspam-User: 
X-HE-Tag: 1773400248-341350
X-HE-Meta: U2FsdGVkX18hIPF5qPH29C5zYKBh3dWJfQ+nVSNKwNns6lVgwFeecnDooM34/PAscDVG+MD9yZCNVP4GOsjQ3hsLqRLnQ0/d9q9LyWG80dPiVQUyd1cAJBKIjkRQXc1Bx+LH5DfWGU4bPdLWgtCCQEmegx+WGo7eeh7NmhWsBulU3tbet0xo3yZC6Ij6k0qUXFSjCNGu9q1Ojpqb3YYlEqB6rV6mm5nDZfbWA4z2cEh3zruvG+EbT+NNL9bVDph5bBHvFYcQ4iHq0qtB+QSc5nTfHUglNyMNhyTP/62GDGB3JJWAEsH1ay78Nem6V1hq8MujN9CVAWpIfYs2pMUtLqvNbjDT4DTrl/tdnBtTAnRyCpa5yYg5K6PNWddGIoyA0jcOyYBhH1VmVEYRFoYZ195r9QUZgdN4r2j+idVC7VWWPFZLvXN8N+gJs+8cVXzX2h0wBcIfpbNoyUPIMbbTwDIg2dpjRTxIiFTPG6/m7YXBquP2gFWEhIXjCFT3V0baXi3KF6SRL3bawkegY2+u5Azs1cSqEXXy3B/KTpvilTaLrlCJUqpWtl2SpJvtC7eLK72WY+CqMtoyjKIL1mXcZO+QKTPUY0sQacnaIk9vp+5Xq+swyaTMtYnJJS4TwfAo9V8i+wJCzWW2wDmBp/llbytWqGyxgUHQLRGl341PLsC4O4Bg0OKhD+Dwy2PhMyJUhWZTJUk/puZmU8HyjEcCW+aRnkXUJ0cGRz7eQfKANbLDvymTjwKTKa97f28chrZMPmX/TR3mZM/VTT16NpUxk0dMxsHOQhZx7RCXN7UvsqL6H8tENdLJ1afBd1ykW+rsfeg4McCQVN+5JZUJpr3Rs3czxzk6OD/bvE73AZffoOfSyLg6SUK9g8bR9xr1cUzMhB+FNKfy8RDa9d+gsq0GjMWvBX3AGjjVsUM/hBdi7MrX6ivqplsrjLQ0qnvMO81haAMMsxswmCzZEh5+Xi9
 /tNI8DaS
 GF8EZGLaREgdFur1Yr/fsiJpvsfSauL6Ay440LFpWG10TuVHdQ05iQ1Yr3w5PrV4lDi//+8+amcLHLJl+X/A8HSL9gQg3oBPKULquoRVlMpbAWCt7pu1GvTNeXrcqH2Fzie+SRxnqpMkDZq5J3S9D1Sh6Wzvhw4k+mom/DkbcvQDNwFree5e9Z7QAVqWh+tKWfHz9n5ny/mn07XbhIp/1u59LOxhMqC45iPo+2NyfItbEhrbeQtkgqYGEVGWdDT2tviR53+bgJzlref9gfcokRz5aK37BffHc05wuRsk5Xalgze6h/NOesKh3yg6gNDjZsPv5tgv+Y6vMBrV0zAQAx2LDYI01Y4fJ8RU8pTAt6eaqMAX6xQLeY1vn40m5dEa1pq8TP0vdOrLoilTssDZ2emG18JFnvbowkotLLf4QqG32fjOa1bjGG+eALYDWKm5r6gENOY826XKlJnlXmHIPf2D74BIFK5eDcT/lRmBQdyingA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This moves the condition (tid != 1 && !tmp->child_reaper) to after idr
alloc, so it not only covers that first process in pid namespace has pid
1 in case of clone3(set_tid) requesting wrong pid, but also if idr
itself gives wrong pid for some reason.

This could've been the case before this patch, when creating first
process the alloc_pid()->pidfs_add_pid() code path fails, so that the
idr->idr_next is non zero anymore and next process calling to
alloc_pid(), will get 2 as a pid from idr_alloc_cyclic(). Though thanks
to PIDNS_ADDING logic, free_pid() disables further pid allocation in
this case and it does not lead to any real problem.

Note: This is also a preparation for the next patch in the series, which
will introduce an ability of creating init from the task different to
the task which had created the pid namespace. Needed to make sure that
init is always first, even in this new case.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
--
v3: Split from main commit. Merge two checks of ->child_reaper into one.
v4: Update commit message about PIDNS_ADDING.
v5: Add Andrei's review tag.
---
 kernel/pid.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index bb2bb6c16498..fd5c2d4aa349 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -214,12 +214,6 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 			retval = -EINVAL;
 			if (tid < 1 || tid >= pid_max[ns->level - i])
 				goto out_abort;
-			/*
-			 * Also fail if a PID != 1 is requested and
-			 * no PID 1 exists.
-			 */
-			if (tid != 1 && !READ_ONCE(tmp->child_reaper))
-				goto out_abort;
 			retval = -EPERM;
 			if (!checkpoint_restore_ns_capable(tmp->user_ns))
 				goto out_abort;
@@ -299,9 +293,18 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 
 		pid->numbers[i].nr = nr;
 		pid->numbers[i].ns = tmp;
-		tmp = tmp->parent;
 		i--;
 		retried_preload = false;
+
+		/*
+		 * PID 1 (init) must be created first.
+		 */
+		if (!READ_ONCE(tmp->child_reaper) && nr != 1) {
+			retval = -EINVAL;
+			goto out_free;
+		}
+
+		tmp = tmp->parent;
 	}
 
 	/*
-- 
2.53.0


