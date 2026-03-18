Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3101D103E195
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C30C6B0270; Wed, 18 Mar 2026 11:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 474206B0272; Wed, 18 Mar 2026 11:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33C786B0273; Wed, 18 Mar 2026 11:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 21ED96B0270
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:10:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D23A41607F5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:10:56 +0000 (UTC)
X-FDA: 84559521312.20.DF5356D
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012068.outbound.protection.outlook.com [52.101.48.68])
	by imf14.hostedemail.com (Postfix) with ESMTP id D493C100005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:10:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=X8b92VU0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773846654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCozF4TumMwOms9OqQxOoUEHlGbfrZtREKPghz2vWDc=;
	b=OY7AfooBwBS7csXzLq+Bf4k1kPOg+mminiwEBOCoEwCMtI/d7FMDFF5mu3Em7/pHJaD1BJ
	o08owT8qrelVqkwBQnxE0vRtA+GBkiWlOBWl+FoZcyNsvQpQyhMbH7fP0+MEf2FaR3USb0
	okIVoMh8uZDro3FyUlJUBtHY/F7a1Jo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=X8b92VU0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773846654; a=rsa-sha256;
	cv=pass;
	b=bVOJVM4YWrR0bpvFyVtXtRZV1YgmU5fkly7CgvzQrz0LgdSz/0I7cF/SciKUSDUQYni2qf
	Eb4VoGoHS3SJza7b2hvajZmmWHyOZ1PHIkWO0t0ANClypn0TFSm2agUQUpxrM543LcrdS5
	ukBvyatex/0vkFxSDPYaEIgFs/XF/KY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HnnzoC1CmUfy7lObUXm5gXrw+wu0qTkIwwrQxtqlI2ZYXU1dZPbWt7mbaDjUKz1G8KyNYQt6m2ptHGLYNKHh6yuqJbcL8if1g4+qHp5b5khS36kkj5D21TtgEbpYdhakNJiFXvcCWh4wNMjp+DTQUEImNBBdBY1YVGbE4Y94pbGq0A7FcF4bkBolSYnx7SsG69zbJ4rjayObXc9NoHmBIlhngTqR+woO6DLui6o96ehHrT4k5lsxUdqn91w2CJZ1QbswMG6hcpB6qEaynC1he817qtomMK7h37iKX50tYle9oDz3bBaCwEdEZd6Vwx+GVMrQQlAzt++UNLOg0MY4TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCozF4TumMwOms9OqQxOoUEHlGbfrZtREKPghz2vWDc=;
 b=poqTfbW/365BwJPFUa20Vk7UWJVweEl6BLthsH3VAw0kvrfsGYng4G98GOrI85Xh/HEGm399oRWqeobUSp0gsAx1l4qoECgVd+ZP5EgohgAQKtpi0bzWcCr64LZb4cS7hIeNvFKFTYSMVnaIVzxDcWB2DcM0x0YtdNH3EPmPMNO5r7ipYNBA7U99wPxS67QDiji/NQjUANouGc7XwZD4pewf36KtQywikeOU3wnku8itbbRwYN76TsCT0bAbJHtGzK+9eLY9IpynopQM4XfHOtT6B051kAaSU3hPrQu2NHb1BbCycreVGibiUewjqtKNq59v22dsgRmOZxGCS4pKCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCozF4TumMwOms9OqQxOoUEHlGbfrZtREKPghz2vWDc=;
 b=X8b92VU0g9AUhRy2o2c9YhOWQJH+lfQwbscVo6lyVdtQp/JPULrYOnBrbQA3D4pFEx5mSkZr5DtTh4PX+t9SDXY4QHoTCZtZo93tnj8gLA4APusVj0RSp5XIUOXDcmRIjvUF/pOpdMaD+D69Uw6yptcyNsLjT5+h+nOP9+pp7ibSBgv67FPOcHqFilXVBOeuiwWMUep1m9dJ2j5nxsIY2WMrTxcy5n3UsUhDqvI1KGaoYFhzB0AKUHX/GfvZNFRqrblN2EopQHSmWYcjUHrYQpkFWd3ZEbf+YA3khzZmaIfLW6/bzHCp9K8W6yNKb/OKZzz6D3skwX5QVx0x0VwGGQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN6PR12MB8514.namprd12.prod.outlook.com (2603:10b6:208:474::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 15:10:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Wed, 18 Mar 2026
 15:10:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
 Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
Date: Wed, 18 Mar 2026 11:10:34 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
In-Reply-To: <20260317141534.815634-3-mclapinski@google.com>
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0283.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN6PR12MB8514:EE_
X-MS-Office365-Filtering-Correlation-Id: a6b08ea5-92e4-435a-ad74-08de85008418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	M6O0qj+iauFbiOYhFz7Dg9jBaywA+qzZMWjnRPpe6n4zGUlCnM0Ev2dJNHwDob1EaGGqMYb0PtXySR+/83tS1iOEePj3or4bFLuzbo9BoTKu7XZUVTtMpkzRBMZW0d6dyVO3lSq2C52zYRr5sY0MTlCWusag8WwSmDkcULouHJnybt/VoLxO69cgEvdXQMnUZid7lVFZqU5P5QB/HtZSB1KwFdtacC5VH0qgSLd/RTSxUTlupRkHzn17hagspw95IdMqFPx5oH+i6gGV0+l6SQZN0BjDLle8pLKZZWX4P4KqjbK96VEgrjXpp7ftI6v18/ne+QuMHmwB2AMQJ+z8a9ZJcQUpBtTwZ1Fl8+uwhOIFuUf3feI1jxbe8Dche0rmA5aqdteyHfTLIVtSSkLYmHmWO5Kq1AYsU/ApMCY5f6+7dU9x6aIVapav6QH/0/b7LkldVOeRnlgDOe66lI1suDIo1lm/EOjp8rlX01E6ALzjSnUFgcXE+UO1th0WweZvH0Fo7L6DoMjThjf8AOdypm35OFOkk6uGLpuT6/4d/I4glL8MdQd2b+zlbLzjWcn988JRleBhotbEUR6ivGGD6C1XWrCsrj49YVlq2RTZMr4QCJojFQC8CgKleuqlLeIPDtHkcox4dLawIEu47gpYFSZL+6HE5l8uguHD2p9GbmYYGjQc1qnbvUgDNLIJKNoqSmKfmVuCoS0/SmHWmuqauE0DyJtfEwxH9NAGl7vFdpE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1M3TrqRS1gYHgAzfVEw8AVHKmQ2qkkHEO9SSmTE967jnmEuWf/8HSQQCWmWw?=
 =?us-ascii?Q?p0g1Ofsk5kes8tho8A/DKO2ZO9G+M5KGEEU1XEvlysicnkSWR9tmNIpPykKF?=
 =?us-ascii?Q?IbUGCucw5dWevQc+MwZ9FwECZIhgodjYa4y/U67CJCmLdYGbezCYldcr/cSS?=
 =?us-ascii?Q?GXnJygvGNFHRxHC5Tgk5jAGEKDDO2rgLPllgxveeBZu+FaoM+p6TjB51WmkW?=
 =?us-ascii?Q?mCSdjTlN6664EIhRlhqE2Ilb4XCSDpLlirIIKKsLCZrUEgLWyA8RnbRf6Aw3?=
 =?us-ascii?Q?Lwj4y9N79PU9L9Q59JpWJGSrDmpvtSm4mS7R8h1AwXOcAREcl2pTVmE34HZS?=
 =?us-ascii?Q?Ihqr08fNjl6Fz4R26svFBizs5jwgjyfZ9d1iFx86SqQSOZ0YjnQfo55H1JtG?=
 =?us-ascii?Q?bZ8QzGMwB7lgG3wtXzrw2Vm0KfTeozInhxszXmp2MJ4x9wfwAKAyGrLsHiNn?=
 =?us-ascii?Q?2Ym1Fga5RGSkCwZaWu9hbmAcxnP+jOHFG2QLriYde2wlhskzmqa1xNznYtOK?=
 =?us-ascii?Q?6NX+D2E/2NUWhhaw01UogrsobQUGs5uLbRZzX400NkdiPXo1MmHWpUWkt5rQ?=
 =?us-ascii?Q?x0FKT9PDP2hUvpX/hFzTG9LGYlUVZz7hznFdP29eU73qXxXTb1eKAr3a93z7?=
 =?us-ascii?Q?eZc5NZlJC702Co3dIyIESNnHrQuX6VM+xrfUbvq2//kRoUg9+r1XMikD6UuV?=
 =?us-ascii?Q?5lX7/0iI5Cl75E9bQt5KyQZwcoPFa24uJhEtMPXg6ZLKcCKNcIpkBjIjnSvm?=
 =?us-ascii?Q?b2YVW18Gf3OTwg3Y2JYMo9tJ30Y+xb0G6CC4/stLZ//9eogCz5Er+QqaFh9k?=
 =?us-ascii?Q?N23fFGZ94fYcze46rJEz/V3pAPTlEzK3ZHaTsn8ueTuaYzIpepsDtmkPKoPw?=
 =?us-ascii?Q?hnQroH978+X4ysY6dKsNeEH0JfnMJKx189lxqJOKW5S+xOsT25CUAVN6arzR?=
 =?us-ascii?Q?5EEUnzkyZ+fcV8b1af/NZ9eyi7xtUwc544iSp1tstoSmW3pZaL9hXZscAsfX?=
 =?us-ascii?Q?AzD/KfJq6tpdB1Lnu7odRN4CZc+2PojiweJYsxnu30NbHXzFsPJrY7BDsShN?=
 =?us-ascii?Q?MaHVREkt2yXuaQJw9MG3fNNOBQhtwEv+LRGsVkfdEeSFT8dBzgwdl8hmaTDy?=
 =?us-ascii?Q?I0SjlFxGARKs8Y7Y1r39BxQKjhC7MCQm4K8bFcQYzCA9feF6sMFnRP+7+XpI?=
 =?us-ascii?Q?084MlKiEqOm0lGqCUJ4SxnPfUAbAZhNoz4iSpry2NxAvdBuQfWD9d7/wBH0z?=
 =?us-ascii?Q?Rx2AcvYWYeemf3RPikaQoTOn0cpnp5dmkPP51fyE70ty492WalRMfZwyPxsZ?=
 =?us-ascii?Q?puQYvD0Y2Z6fKXwzw4KdnuM6rxelVtOZdowr4G8a9J7MZjwmq6KWl6orCPDC?=
 =?us-ascii?Q?Ke0IP9uarJQd8ShEE/o7RttCDo2pl6Qaj8GMm10DWjk8IAR2XIkDHhz0dHaG?=
 =?us-ascii?Q?rDC+U/c0CGw81Wy5JLovNUvw7SdKmQZdFWAQ+Yqu8edrjhpLPbKoKU6vFTOZ?=
 =?us-ascii?Q?+rsHBYLz0nf45Y0bOZWQrqFUqjmfeNgmQS8jkIUL/M1FcYHd1w6rgR0+1MEj?=
 =?us-ascii?Q?+GoGuR88NXOwRWqpW5HV8hpqbMQQjU9UxEJmrj+C2PzV2e5nUxJXMyDTdRsL?=
 =?us-ascii?Q?hZktjm98WzRF9tOHxo6EeB0iyGx0s1lh28pwiYpX1GbE/87wrG5pxGikTMRm?=
 =?us-ascii?Q?kVnpyjpWUwodk3KlO6frIjHoBIKUnxA7hflUn94k9lY1RZGo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6b08ea5-92e4-435a-ad74-08de85008418
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 15:10:39.7326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IHcEhYH2tV7gSsiZLDhZH0PlUEiv4td9Yt+fVeRJtH+GNmNcjmNPyFezhyy74/6h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8514
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D493C100005
X-Stat-Signature: zzt1geix31wrdf5e1rwaax85sp7pz7dr
X-Rspam-User: 
X-HE-Tag: 1773846653-494860
X-HE-Meta: U2FsdGVkX1+1hYppZajRyH0ZpxOmHd7sHyBya5MmnC3ybgqwu/qeo63iJsed+XpE/yf4wsiy+04N/oMdmZgYN8MZMUArlk9mzzMvyxl+HcO9TFSUqKJBywzrGyQ4C9LLMuMUl5PNnd4Lu35mksrdRzRnAwlLLpyu5XPdPkJyuIOt9ostCz+WhU1HT6C4eelTJGUd4Rv2YlHjsZd3ucq4ipmR5WmgeucQxNETmi5bV6bjtr+mPz7igLPtJS86bX7WksQ6wa5StFvBKmXjW5Lpl6AOYHWd/PMs3Jo76Z/Qpa3XkcrLso+7ovKh6E1rzirWVgKyzuu94oss7uLk7YLQ/A5TwEuK+HYQlhJrbnCbeidU+NAKWSo5hDujkzjiZoEYkUMBH3qHk7OfHRNWfnpR6kwwUWYQYdT8ZRfRY7Z+di6jxYSVdpoPHx9d6Eo5ud5nLwgS7H4m4NgeGmcUDYMD3pC6S3xt2hsDf+8tkOniBoBw3QsQS3b5oUQAodLfCfIrvfDHgccRU6mtmX1ZtEmyUylUCa6ojSRWWneUNHMbKIBlCWnowMm9Jemb+CNKfzf6yy9izl8XkQsy3FG7SK5NZGhcGgphj+Lw4Csc1mxegEBDrjorUt+iZ4Fka784ERLuR62gOlkLvqp+ZlGHfm5QEStYBgHR1HsCcC0NSqxHgio98nVS8gRJsRKCba0RICT8ZE2OjhlFIfRG8Zy2O16j3XFIFMawEL+xUxN8l9g91E9/L2cKz0YL8fVUkn0a/DFyXKA7cmuL5aysNZsgo43xSUgRQ8arRIEuf+S5hqV5z2DNkqTd0sLfphaSjwt4j295SvrcyKQgLr5NYuymsngCogVTF8mBJMdRjM7CTD+2RT5IZQftE9wWYABRixsZxW0N63JFiSyP7cI8hA8ikxesdY8rcujL8SV5YJ2GYHDVtWB5qRDx2kzlJSJFwCIsU2dV/4kEpHLA08egPIqS7YK
 21lGkEs9
 SUyGXzYwNTbCQOd7uWsDw+dTHED6HZ0IFlxMR4gheb5ooeKGQ7I5SOlTD3Nwkb6dgZl8CwnmV8eZhteaxf7LrEUu0Accn1XYnGRgHWtHklSBfRQ2TDeZkEi7HXLykW/MjAhVeUnp9Vn6pRjcxcsBTADljEZDVElaqcA8qqfwdLJoDRc+QX/dRymgKWTuCSsvnIEO2zEFr8LrtQniLwRw9MpYWbQhPwpVdtDb00GJxo+LppcH4rhQW0JX6qAgGFoQ6lfI7rzmk8zJQmQihQ9azrYVFMrfJa2JiX13jYWN5o0H84zTb4Dyt05qz2Keg3GF2TLAnQSCrCoRCD4+KVB20sEJCAPto2uzWvd1StWUupz3jVaBNB/b/h1qm9PB/mM1wlpUx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Mar 2026, at 10:15, Michal Clapinski wrote:

> Currently, if DEFERRED is enabled, kho_release_scratch will initialize
> the struct pages and set migratetype of kho scratch. Unless the whole
> scratch fit below first_deferred_pfn, some of that will be overwritten
> either by deferred_init_pages or memmap_init_reserved_pages.
>
> To fix it, I modified kho_release_scratch to only set the migratetype
> on already initialized pages. Then, modified init_pageblock_migratetype
> to set the migratetype to CMA if the page is located inside scratch.
>
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> ---
>  include/linux/memblock.h           |  2 --
>  kernel/liveupdate/kexec_handover.c | 10 ++++++----
>  mm/memblock.c                      | 22 ----------------------
>  mm/page_alloc.c                    |  7 +++++++
>  4 files changed, 13 insertions(+), 28 deletions(-)
>

<snip>

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee81f5c67c18..5ca078dde61d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -55,6 +55,7 @@
>  #include <linux/cacheinfo.h>
>  #include <linux/pgalloc_tag.h>
>  #include <linux/mmzone_lock.h>
> +#include <linux/kexec_handover.h>
>  #include <asm/div64.h>
>  #include "internal.h"
>  #include "shuffle.h"
> @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(struct page *page,
>  		     migratetype < MIGRATE_PCPTYPES))
>  		migratetype = MIGRATE_UNMOVABLE;
>
> +	/*
> +	 * Mark KHO scratch as CMA so no unmovable allocations are made there.
> +	 */
> +	if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
> +		migratetype = MIGRATE_CMA;
> +

If this is only for deferred init code, why not put it in deferred_free_pages()?
Otherwise, all init_pageblock_migratetype() callers need to pay the penalty
of traversing kho_scratch array.


>  	flags = migratetype;
>
>  #ifdef CONFIG_MEMORY_ISOLATION



Best Regards,
Yan, Zi

