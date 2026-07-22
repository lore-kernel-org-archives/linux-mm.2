Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 022E3C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3846B0095; Wed, 22 Jul 2026 09:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C266B0096; Wed, 22 Jul 2026 09:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62BD6B0098; Wed, 22 Jul 2026 09:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7ECE06B0095
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:03:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5958801A6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:03:06 +0000 (UTC)
X-FDA: 85016427972.15.C5FD0DE
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021121.outbound.protection.outlook.com [52.101.65.121])
	by imf04.hostedemail.com (Postfix) with ESMTP id F212140011
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:03:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=MjHwugKg;
	spf=pass (imf04.hostedemail.com: domain of christian.gellermann@codasip.com designates 52.101.65.121 as permitted sender) smtp.mailfrom=christian.gellermann@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784725384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4v9/IgDERqVqKcJXgAO44ONXqJsRcHAFHlsh97PBeQ=;
	b=Y75zk6bOk5eNPMO++5A8wvqFITQhU655qZ0eHpTyuUhoCM8x5BNXqJFnAfBMtBJbMrvoI/
	WdsUM2OiazUqNVmDVwJFkegrzjWIlVaJ2qN/ADllmswgxc2SvIgtwWhOFsZq34IF8b/uo4
	AzU5qLtNp8gLmELlr1/Id/WbuSWGiYU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784725384;
	b=so64F35y219e/OebNXZPNn4HR3LiwYnzdlVs+9N4BzCNvDwnVloJ0dyPvmvv69wvLrTVKO
	uucvupm1LAE5S5lPQqTfjOBt7xIFOqQlPTKykqHI7hDxlgNE5Jc02rZpSyDqJg+xfl4XZS
	0y01WYYLC5c5Gs2oUnDrx2WEgj/ggYk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=MjHwugKg;
	spf=pass (imf04.hostedemail.com: domain of christian.gellermann@codasip.com designates 52.101.65.121 as permitted sender) smtp.mailfrom=christian.gellermann@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VGXK1S2dPr65OsoCZYy/Vt+5LlmnAacNjdCsPGtaEpQiFHK9kzeG/ujlWag48AxXGrhxKlFMtXbNVD20swEjM0Skv+laEZfiyHTlU3JukkqB+vVKi+e4lcaZ6WvEp/IUq5FIExx/7wMZ9h0pt1d/psgaRrfwTU1FT7fEpyLFA7m/elhr5q0dVtQdqzBlJPMSd/i9k9m7itwNqhSqzLby+kF0QIS7FHFsQoKc9eOqLEXM/WNJ6mzoaRuokF3pohwIw+H4X+3+g2OyKs7Od9b9aUZorkN1cseFxo/nucIOXPM9dIde8LexmdbK/LnbxHpc+1KJ11gsOAQ/U+cnuaC2rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4v9/IgDERqVqKcJXgAO44ONXqJsRcHAFHlsh97PBeQ=;
 b=FCmsjOnoWosg7E5vowGBl2y0C10eAfGxReMUw6zTVm7SLZNvT5hbQN5Iyw7Y47m+YO0Qlk18I/9c5ndjLS6J5C4wvMj6smgIfbGFbhSCHhAdHv88P4rsgz5Kurr5AvMGsO3ksryrX5p4d+xtobE7kZHh/b2vlpg8rtDcfAMlOb/8qBvUgV3yN5SyFn3+zZmomh604g5EmKQq8UoLzJlu5wcIIAiSetROdx8NyKjKtevUmFarxsM75AOaEDCzdfAIrCxMzTk6U37E/r+yfPy85/FVuLjKxjEXHCmqABgJSbPD59asDs8IZ5jxpM+po6+7pC0Y1g4yhkOAP/fxyK8JZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=codasip.com; dmarc=pass action=none header.from=codasip.com;
 dkim=pass header.d=codasip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codasip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4v9/IgDERqVqKcJXgAO44ONXqJsRcHAFHlsh97PBeQ=;
 b=MjHwugKgM9kirAyUqKlPfQJxqM3xHxKDEKPyvu+6Zjhni8cNelgokG5V29zG49yLv3kjEiC6fVZPMx7u4bVi5qxi0om7bGKloC8tC67H76T1BZdnfP20AVe9IffbwORWzrNR9J9RV1Nm28S6WkBcnOVYY8Yhp9F8mV0/wHcFtf5Hg9ZkkfBGwghqDpzCvfCTZCvGCLyvHW6I23zd4K0ONfdr7eJNtkAAwoGBCjhTShm3WL0oNJRugU1MJp6E0OnYJKa4FzYciZERHUskIaQMDKnjim9AgCu4PjteVvNjrWr3U8TjWMMK+kPslCuKCXul+oLq67fhWB192n1YfCXDWQ==
Received: from AM7P192MB0787.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:17c::14)
 by GV1P192MB1739.EURP192.PROD.OUTLOOK.COM (2603:10a6:150:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 13:02:56 +0000
Received: from AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 ([fe80::c1d1:f20d:9fb5:72d3]) by AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 ([fe80::c1d1:f20d:9fb5:72d3%7]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 13:02:56 +0000
From: Chris Gellermann <christian.gellermann@codasip.com>
To: christian.gellermann@codasip.com
Cc: akpm@linux-foundation.org,
	brauner@kernel.org,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] selftests/mm: Fix potential wild pointer access of getline due to missing init
Date: Wed, 22 Jul 2026 15:02:46 +0200
Message-ID: <20260722130246.2135563-3-christian.gellermann@codasip.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722130246.2135563-1-christian.gellermann@codasip.com>
References: <20260526113848.530105-1-christian.gellermann@codasip.com>
 <20260722130246.2135563-1-christian.gellermann@codasip.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0162.eurprd09.prod.outlook.com
 (2603:10a6:800:120::16) To AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:17c::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM7P192MB0787:EE_|GV1P192MB1739:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b01d4b8-7faa-4d09-fcf4-08dee7f18c70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|10070799003|6133799003|22082099003|18002099003|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	NOZmYjcU7azAu41rpI0QBGPkCu15pHM4Zr40Jtujr+znHNsYkjVu+gf0oVI/GqOjX/NJBLIRxMLf+Lbn4SS4mCrRXSCu6f54bhegB5TuKVpeVohoVXWguivdRhPQj3iOFxGnRiofTpo+ORFE8+UwqaCex2PNtYFwhHwEd6fHQBCWeyc3xRGPw/C+ZqtB/oo9QHe79b6lIyykorS4DFImUb7ZDTskdRcOV/iNZyzVxaVaiLoHX+1uYTTbvfdVxQJBfVKvRZireQmiVVsDWNmu4Ren3I+7nm3VFz7/ZSUh76jqqHqrthL1Rb3+Wm/7f5mPHmF+U326zfcAk9eibI1U7ZpQNpzNnisMhOsqqNtOxbiMbe0I+XoDaTdU7htXQkRaWrJ6GUstX8mZNQPByzdunWiGtA6IDBvaHkjEvYq5MgziH4+AnqshwXPgt+2U+UcUuDdk1mTNXGHOB9EXhkquBs6xPS/7zFStFVQLCJlOVRj5x4yPvSkcPtVPMzQvlPxySRzRLCFDyKG67NQN+ZOC2JlcEltLLcYN/wau5MYscO3xv+G6IhoIz6q+/RoG1vlWMiWgkKP1lKGTVmxr436wbL0/6NppAwJcnF/xQcY7+9PQnnyTaGGTzpo8Yed2PsdcgijMMmcpRAAA3MjnRhsvb7+NHWY7yRRZdAZABjvGc6g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7P192MB0787.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(10070799003)(6133799003)(22082099003)(18002099003)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GYe63CZ2KDhS6WZnWV+w2sAYiz/FRVc1UGvOQ/CBzYQWpCGSuWBarBSHej9o?=
 =?us-ascii?Q?3xWqUDl/TN5GlSMEsywhe2HtRRZFMbKjFndMoPfKiTQDQGy0t4u8ZSI8R8mO?=
 =?us-ascii?Q?n/JTC/XNnS3hcTzY09Paj5Qfc757ijz9kmQ113mMSDeaVPBY4knb97Mbul4v?=
 =?us-ascii?Q?WykCURnhKXaR6o8ATw5OZ3+gCqf/LYze+iPKp8R5T81VNLEt7PKdI7v+t7vo?=
 =?us-ascii?Q?oS/9Pojgq+Wx05mek4XrfG2HuZvm0/QAS7lUzSUhIn6DYgmNfngLg6T86HHD?=
 =?us-ascii?Q?5c7kVJuNh4XR6RwHQiK7fxXNuou9/nUkdeZuoiHqPr0YA88N83p5gBwQWjVi?=
 =?us-ascii?Q?90YhXA1/XZOvn5C9rVcmhYnR4Vl9CBNpzWcPpvdKqB0ev3V7FdpQanT1mu7T?=
 =?us-ascii?Q?2SjUZrb5zOsHrEiwy9FqWPTkaQlLjwOt13GNDQswGoTPHueiskbnLVdJzmIP?=
 =?us-ascii?Q?I27asAifwDovG+UCKBxwZv4Rp4cypVr37SZwulR9O0k5E+fZcfw1LeugNAjZ?=
 =?us-ascii?Q?5XuJmaYTjhVTm83tcJXs3z8JWHpH/Bfp3yQyTUcDS3eaIr+GYFW3G6IpLSr2?=
 =?us-ascii?Q?KJp5/iPMpyLCemCoZUZ7aJBqqwQgnBdRTUo8xchRv7w4uaPWy7rnlLtM2mB9?=
 =?us-ascii?Q?wvaOG4KO1I3CeRUGdwDuS1cG5U85Jp5Z2jwaT/1VTcHCJN6sF98Wi4oA2Lij?=
 =?us-ascii?Q?FAKl5z1l9OWvHGjImW+ab7aTZWxHwZDKrGTO0Nc7agyLO2mgES/+SoCKHEu/?=
 =?us-ascii?Q?VevypoLdlGkGGPQjqhDClXelZ2ZFcM+PDHkqjtTp5UfLnI6RKsodK4jCV818?=
 =?us-ascii?Q?V0h65P5MuqQuEAnW63pWgswnP5Ndbd+roUYbmmp0iU7rI6XK7DjvIy9hG3om?=
 =?us-ascii?Q?U+uoWkNUt18vN1ypW/kbk+zwDDYdO1+fkmwMY7hxKDv+XT2viGv4eAndXXCU?=
 =?us-ascii?Q?4z4UDtlbl1XEYNqPPUk4dpMRtq4E3bSaapCFu/HSAisjfxURFerhPpmVZWD0?=
 =?us-ascii?Q?u0yyHjiEPGbco8ZfP73a61R9IlZRh2Ogd445flT9LTgC1T9+yI+I/Lfknge2?=
 =?us-ascii?Q?K4nQm5S8kunvcvPXBrEGJEVnNCTn+LpGFImug7sc25jtV51uVnHxn+7p+nRD?=
 =?us-ascii?Q?GvT8cwmV87Al/djEjiJ80jMxW597HEiWLRsuGa3gjML3ASbMOv3yOexDThgJ?=
 =?us-ascii?Q?Vp2R0aLTJHdEQ7tgqm5ELkKf5RIc6qNTDZ0lEK+BwdkYUG7rml55JiVeSA2T?=
 =?us-ascii?Q?hEEferW7H04BI7SYkxrQtQN1gU/j+O1Lj1qQ/1mx3hOC9YiKUb76JEcRegk2?=
 =?us-ascii?Q?A/lFsyjEnSWyOeVVR7GX19j9uRtzkQd1J38SAtgR2j3zuzHW+v9tPPJVivnD?=
 =?us-ascii?Q?EOguhewAGHRkiPZmNSBq52nxPL3GJ0kVpUoNDSQWZ6Ziq2DfPxO6afkpUQxj?=
 =?us-ascii?Q?G1L+527dmZ1z8UCg70/OTBe23bnabzLHmKk/P1JXKiH1PFR4MNJDaDI2uDoU?=
 =?us-ascii?Q?bySGPpGEBw8SFEfFMLMmNppkNoUpajxE5WWWFdDETyNyTtwwt9XSL2sTAqlM?=
 =?us-ascii?Q?StekVvKQpF58z15rwDERJB9cV3qmP4VJffLCA9hpOZxUUqVV7eCoFdNO1glr?=
 =?us-ascii?Q?cmU3ZZGNuwyHzzQ//ZeS98kxTmc0whvuxf1QbxFRwnsnq0QF2bB0Dfkpqvz3?=
 =?us-ascii?Q?DNRn5LzKQs3ORkj5FNDIdrxDt+5OjCzIRuYXcY2hyR4RVEGDL4cmwdJmfDY7?=
 =?us-ascii?Q?ndlzH9A8Qs7LvaBnCDEQssdGz7diTNaqIiEswD47nZm73ivmhzquX9FcR+Up?=
X-MS-Exchange-AntiSpam-MessageData-1: kRm01DhlNjmATTtqvWveCrqn7kwNijVAIEI=
X-OriginatorOrg: codasip.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b01d4b8-7faa-4d09-fcf4-08dee7f18c70
X-MS-Exchange-CrossTenant-AuthSource: AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 13:02:56.3634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d91ffef-bb81-4cbd-b9b8-552583685f20
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x3i2JvjXOdVeBoil/ntHkx8YqO2Wv2feBwz5XR+y81PW9HQXxSKXA3T4tqSj+xmJESTltCVFmLWXwiIigK6VgSf4YfyBAoeRiTKyQRZcdZ/wHSErzndW33tTaihFPFdC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P192MB1739
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F212140011
X-Stat-Signature: cokxcg8ae56wbfnnknmi391pmw8qfnzt
X-Rspam-User: 
X-HE-Tag: 1784725383-830980
X-HE-Meta: U2FsdGVkX1+7x/2dK2EE1aFMHwoFmnbVubEAjVzIWEG5LBIwo9MW773x1bhigb8P8umyXmEyXygmJgXW3l8hWuRaMv10lYfS8j7eIz5OyrOqnY3SPAqqqKpLl4knck0HodUoXtEIjneqbkfJQcXxSyyQsdOE6+U52sfu71an4ixeH8vY9+fPM0Dn+/ctBXzCDd/tSiWp7/ZxfEYD6rL4rr70arB9XnXmtNLxTuCNBlkNRai0zfksgY/KsSBUsqtVuIeLTFv2P2t0Qe/cOYjdq7RQoHnJr1AoumgHoXJFGoHXCkwS7j1EJ0PFCThkah+eZHXq0h/AzpiIrVpvczzcHZnWwfi27svgAkXbrmeciw9WXCbxARp4A90anqdoMwNGUahwTaCU0OWvnuR+jL8a+RdN8HCnIihtnaHPwY3ZJDbTevKXm6+N01we2JXSagcLRN72X7foEnHq104F9VOOIDQpbpKpOjOboZlZHJJUwhMDHwLphEZDLkEm6/YAL4Mnrb61+t1c8fzWQbgjeF2OE0dFBG37ca11oO0awaTyD8v+OxdEDEmC/hF/g7ej7bTAY4qyxGiPhELfHP8+m3Q+hPzi3kbOMS1YgKScdhPYzyJFtzZqQuT/u5bl5y7lVTd0AmrsPtopw4RDjgj0iHfFGYU1VN5dRYGQ0nTka5uITNFScgAgaBzOKs9iC3o5oOuxdSkmSZOflBz/vfe+mwy34+r1H8QbctajUCH1C+HND3LUdZDo1dkUbFQfTES693LlJgfJnBgDKTCsbTRGihuefsuxQEM/ZSMmBkilwCIB4zafwFZGZIwHrSSbulgTabaVJ/Q4NYu/9fyCtwq3CUgfJJQeK7gQqx+k2FL7+8zeDoXitP03VUKXIcTCVBPiORgqSzzxsq0STXFCZVDeABICUudHJLgI2yEo9CEt3sW90jXSMqeJDhKipQ3TiSHyIPG+cdT/JspzllLU/Z3OA8T
 z5Z/diJ0
 L68HtYRBIay5lWiEFF11SjoHGsyXWO3l+W21R7t6IP/af6UeaFoCUGQn5OsEIpPF8znqPP1e8wIqRUqnzJpqD5ub+O0ycASk7figax6xHfqfCuxcyxw8ZEwGclEkqxUfxPH1AdCEuPNDzLYscfumLENjZUWdx3Iv+IoV9BJT1v5bZhgbf/Nf2A6k2YTvLBxmHK6uGBxhwyx5mTF//S9JwkFvNpN7TuRqksy7TdwLi2bY1XgaOzlaV7FSNlarlMIrn1HmfL9pcGY9VHo84xEg1Jx+p2Qc0p3cd6dcA2JiGEnIB4z0GMmYWr53Fg2edHMnT7ETxTwTTB/NpA5o0aJGuk7B9twsgXGqkZSgeQuz1gsOgrjXq84lMz89CO1j4Zh/XdataGIP7ohM35GrDFMiBMRchUucAlAn0uTcN/TIxPaUSpyMTkera2UwpxsvnnwiNtrwFDkuLqk1P8N7dhLuzswzWRCjc35tXr/suQ98ND6Dn8t38H9AAOCZGPmWWyLL6/cHqU6tDBQSVT1Q/c0GsmON/MGtE3t46HSWi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is another occurrence of using getline where the code assumes that
getline allocates memory to store the line, but the pointer passed to
it is uninitialized and potentially a non-null pointer. This
violates the Open Group Spec[1] and caused a segfault in a similar
situation in selftest/clone3/clone3_set_tid. Fix it by initializing the
line pointer to NULL.

The issue has been found by simply grepping through the selftest code
after running into the issue in clone3_set_tid. Whether it segfaults in
its current state is unknown to me. But it's good to be addressed due to
defensive reasons.

[1] https://pubs.opengroup.org/onlinepubs/9799919799/functions/getline.html

Fixes: 26b4224d9961 ("selftests: expanding more mlock selftest")
Cc: stable@vger.kernel.org
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
---
 tools/testing/selftests/mm/mlock-random-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mlock-random-test.c b/tools/testing/selftests/mm/mlock-random-test.c
index 9d349c151360..16294bc7dae6 100644
--- a/tools/testing/selftests/mm/mlock-random-test.c
+++ b/tools/testing/selftests/mm/mlock-random-test.c
@@ -84,7 +84,7 @@ int get_proc_locked_vm_size(void)
 int get_proc_page_size(unsigned long addr)
 {
 	FILE *smaps;
-	char *line;
+	char *line = NULL;
 	unsigned long mmupage_size = 0;
 	size_t size;
 
-- 
2.47.3


