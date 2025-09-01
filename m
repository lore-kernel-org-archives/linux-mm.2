Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30BBFCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0792A8E0005; Mon,  1 Sep 2025 16:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028EA8E0001; Mon,  1 Sep 2025 16:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C7B8E0005; Mon,  1 Sep 2025 16:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE1C68E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:31:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92339BC547
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:31:52 +0000 (UTC)
X-FDA: 83841827664.26.46F1505
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010015.outbound.protection.outlook.com [52.101.69.15])
	by imf08.hostedemail.com (Postfix) with ESMTP id B515C160013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:31:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WHx8Pr6c;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WHx8Pr6c;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf08.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.69.15 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756758709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQ2x+3MS5gDTxu8o3VSwltrsVoMV6pB5dJN3oNHyH3o=;
	b=eYCu44obcTZ6iFsmwWMpN5cWzoguOkqBcdEvjtcZ48aALkFcA6bCk8BETGL1x9bfp/ukDQ
	w8O/9kxe6KsHleyYxSLjIG9DNcjbMUgpA7Xl68/1CF4p/cmU2kfzBrA5QUrfVCJUeYliYh
	j4BfJ319mGNVyoG9v8aIomXiLXm/agg=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1756758709; a=rsa-sha256;
	cv=pass;
	b=yLIMD0/uDs/zKltbwmLCrobuL6ZLV41TJJZvA38Hu912BDXLnuMmoYT12DOPMXc6IFE7as
	6iljB63Gp3v6FJGThKvnc8jBS8oomu7XndtAot1TGBgEx2i8dE40BajB2kmAOb8MTsyB6P
	uMYfAu0Ukl936WyPDbnmyJ6rom8y/Zo=
ARC-Authentication-Results: i=3;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WHx8Pr6c;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WHx8Pr6c;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf08.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.69.15 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wJ9yO6sgVbQSCeuSwi5RZY/fflBjufDVtR0CP0Jkf2o1fvEn6QOhSiL/cGgSdEvzZqZCT3C3oGCLGSMum0NgDZXGZ02a5I8w7sYOJjJiACcZnqAjFJ0RSHYmwnr6/SDnfwepQH6my1mRHTTYY4BWWobvg5kstrnSwNDik4xUPKn7SpimlZW2mrXo++PAbMtjT4AezDvqWx07MVKGBH6pUjv6YGckrYvKeT1RDr+D+hv1sBVWjaHhe5FcpqMgzZsuQNISue9QwVcZFb7FXGuTRMEU8Tc1rB1uSPXN2XWCDPp2tIRugeB7/EpRfiQ44fMBpw9ANgvQPArQc/re6gKxyw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQ2x+3MS5gDTxu8o3VSwltrsVoMV6pB5dJN3oNHyH3o=;
 b=pZa0TMIfrEHOnDRvOvkuL7LYxwTG2FJORkHuD7xxENQ8YNBLnJnOkTy4cFq/9xLu31yx3l2FvzY6PHkTtYZzSBTzkvR53jvHJ+aqseufq3+6JjbKbYdWHpjjqSfJerGdQSLQMv0x5JSL4tJKJJ3eavgMQzMXYkxW875XByEDfKj86Y3rcvmW/mPjli05Mdu7aO7VW9ZQ+Y5QMxZBv7Qb8mu4Mk27h3rqurdPRlp08GCajzthAVjP0vvpC91L684miv+q1SrZUIjkUF7kUhodw6N8IGok/nQe5Hn8+hpUPFMXUINkGYUDRUpxJZtBM++AN/GUw22l3tRhmsDV370koQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQ2x+3MS5gDTxu8o3VSwltrsVoMV6pB5dJN3oNHyH3o=;
 b=WHx8Pr6cOU+4DGs6Ctdt8tnVWABHyeKZbmDR5DnOLut34ALCD1zUB8s/MljI3E7KSOI7+XdE0+CuiAFcVcIEuKV5HZ0TmxJ1lwsLwEyyY39xcESKaUzXknV2ddFXQ+paAvTlhMwx9DfAo++m/S4IZDA3+1JNa35qbcIf9j2LWy0=
Received: from AM8P190CA0024.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::29)
 by AS8PR08MB6264.eurprd08.prod.outlook.com (2603:10a6:20b:29a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 20:31:42 +0000
Received: from AM2PEPF0001C711.eurprd05.prod.outlook.com
 (2603:10a6:20b:219:cafe::ca) by AM8P190CA0024.outlook.office365.com
 (2603:10a6:20b:219::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 20:31:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C711.mail.protection.outlook.com (10.167.16.181) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.14
 via Frontend Transport; Mon, 1 Sep 2025 20:31:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OsbY1qLniVFJfT19teZWxfoIvTi3PCiF1TOjppICSy8Z8FxcbRbNhj99IXf2BkrdKLyvHKX2rTkz7AU98zI8gXd8WNzwUyk4A2smH14cqJcmEld7VzrVIEvJfQq1TqAOIXGaMimKVwVM4uzaBnt/Q9tmE1VuIzIgCEVfSaIJ324OK+dxKUrQPBCnETfwPUAmDlIbU5Vy/aQ69BdvfS8n/PiQ13f3WvejzqWGv1b6zqUGqdrekrCyZW/kXm+2mIoLdd5fa467haMrWaPawGj4Rqs209+urFs9utXNaI81nWbaSI+3AvIcY6u+wU3YN1DAYRV+aSKTMc2f4e32YAE/mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQ2x+3MS5gDTxu8o3VSwltrsVoMV6pB5dJN3oNHyH3o=;
 b=gimZ21igAOFvrEM1o0N8zOFTC6NZh1XEehVbPMHjZGYuVGhjYXw/2SamXVKY2q/OAnK6odC6W9X9hUG7O/DYRj8VZmS0BvpstwSzdiVJMolfWco7S6l7IWd9VvdFCbQCoQh1cH/5nkdWamnToAaCXYF854yP11ro37lEtSO/RhcTcF18/0epGf5LbVFmS7GpjxI1IyUNUCIatY6G3v3EZjXPDjgSCaCO/BF83HNh4knZYRep2pPtV66f/OMKqrA23vfsOZJrTTKVLSy5LkFxY7IjCc/MFuc2jghzXcIW0uF3gx009qBNBC1oSga6UdM+oH3k2F7mZpLXlToYdSg+Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQ2x+3MS5gDTxu8o3VSwltrsVoMV6pB5dJN3oNHyH3o=;
 b=WHx8Pr6cOU+4DGs6Ctdt8tnVWABHyeKZbmDR5DnOLut34ALCD1zUB8s/MljI3E7KSOI7+XdE0+CuiAFcVcIEuKV5HZ0TmxJ1lwsLwEyyY39xcESKaUzXknV2ddFXQ+paAvTlhMwx9DfAo++m/S4IZDA3+1JNa35qbcIf9j2LWy0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by PA4PR08MB6032.eurprd08.prod.outlook.com
 (2603:10a6:102:e4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 20:31:08 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9073.021; Mon, 1 Sep 2025
 20:31:07 +0000
Date: Mon, 1 Sep 2025 21:31:04 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
	catalin.marinas@arm.com, will@kernel.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 1/2] kasan/hw-tags: introduce kasan.write_only option
Message-ID: <aLYCiE6lGlIkIJX+@e129823.arm.com>
References: <20250901104623.402172-1-yeoreum.yun@arm.com>
 <20250901104623.402172-2-yeoreum.yun@arm.com>
 <20250901122316.6b7d8d7fdcf03bdb2aa4960a@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901122316.6b7d8d7fdcf03bdb2aa4960a@linux-foundation.org>
X-ClientProxiedBy: LO4P123CA0372.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::17) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|PA4PR08MB6032:EE_|AM2PEPF0001C711:EE_|AS8PR08MB6264:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c75e5ae-5eb1-4fd3-a9b7-08dde9968f3d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?qVWHHSMqV7xnFfvFuePmwQobxJ0fDBBNs2LTo1iXKox2tGScR5n1f7p47/qX?=
 =?us-ascii?Q?IbElvk8EzBVqOEJklZq2WDnjG5IDnmziNebY0ofvXasQVzDHdJJSqqlVBuYg?=
 =?us-ascii?Q?XyLFsvJSZgKvK7FK869T2fbxQBQ99mvtxyjI5r2Neihs4DT3veNrxc+upz1c?=
 =?us-ascii?Q?C9O0UJzzWBjeXKDXp7kfHWQVnRrjDe1IN89KdI1xtzOvsuUQGUztKnW+WqKE?=
 =?us-ascii?Q?unfKOno3St5q+FngmmCOnLDi6tyjky1cooOxNZPfTvwXjSbo7SwM7xfFt3En?=
 =?us-ascii?Q?DCwOObbUTdSu57dcMXfvNkRr7WzeGe522aqtJ2fAPpzjBso8aQlLTmCruqHp?=
 =?us-ascii?Q?gPshAebmp92zulndtAtOie1Xm2ZJqE9J1f8SnVCXRLGlL4Vh0w5352500fnq?=
 =?us-ascii?Q?wsFzRTfHIY4PSDT/v55Ffbr5T5XvXlRpP0YfzNiejbZPdeuYTgxpznarnAr3?=
 =?us-ascii?Q?eXYIqeCtjyW5FKsyMKpujPXrMOPZQhL7U8kSzN02kDAkupSgYJVPo/O11Nap?=
 =?us-ascii?Q?2n7aBX/yUtuV0h1YZy/oIldryj8bEeUA9CRXwUEp30AUDz7umR1PS8Ln6rwA?=
 =?us-ascii?Q?low2+tJ5O4ArwwPh81y5G1YWPKVzjCUEwIpQpmGZUN8MYEzQLaj4NIpsTxFz?=
 =?us-ascii?Q?KKWDQhk37xlqaJGciJF+2TeVVREgMw9M2QitZ+t8dpWvxMlXmYXVgm1qaJbq?=
 =?us-ascii?Q?48I1HlVsdYb5h2koYww51rx9WvsaOdHOWvW6NdEteSDnOqsYqtsq5Dg+wXcR?=
 =?us-ascii?Q?VFNY0udw44CeMWEOrxL4C2VYpgu06sC0tM5Edmf4z4bcLDCMmb2JMsTProlF?=
 =?us-ascii?Q?d1nHw6vKJEH4b3/DYt/7q7ILDx8XpEeE26EL9CanM2liSJb/UCjOoGbqoZP2?=
 =?us-ascii?Q?fHg9WEIv8gCJZzkfsoKc3frkvisvlGMra/cWF1BKU2NNS84+m9GTiexwix0R?=
 =?us-ascii?Q?0XqePG6AGuw7pAcEy3jaBgpOVFNiNyvdss2b3M1HPM1H88ulLZLpGXH6swjG?=
 =?us-ascii?Q?iNmVQvGmz9avciqsvXAlyqxXTnPFDJb9r/W2WWCmnJE6+UAkY9s/OTa0rl3N?=
 =?us-ascii?Q?OaRyA3OqyZ1VEcuI703V7TSAFKY2aEPi10OlsAfIZoDx9oecVCanfsmtneA+?=
 =?us-ascii?Q?Ncf0PkzCCd4jiniGsoacxkrrF/us0RRVoupBwL27ysltH0+MGq5m5Q7F1lwS?=
 =?us-ascii?Q?JLuczMlAK8CAQm77kvPC2R74Foyv+gIe6zDW6+NTZm5wmuZBgmaJBxPa0aLW?=
 =?us-ascii?Q?gv6CSotYMR+pyDAoFrN3jkPBbXlHE8OvGviL5Y5zVBMN848rDdWqoubjk9uG?=
 =?us-ascii?Q?NM7o6Xhr8oLlfBgGvogK5+gCOMJ9PcPvJ8u23ZyCd8Agm1Rjg2bNRdM4lUbb?=
 =?us-ascii?Q?Od6ddzqfsOJylYf2BGQbeu9ZwLmQeM+EVk0VY13BHgSRiiilzqhEvUmJGpwA?=
 =?us-ascii?Q?QxHMJ3eWQ7w=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6032
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C711.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9acceecf-0116-4269-693c-08dde9967aec
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|7416014|35042699022|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uRoGsnXionhzUX2Bo+Mv/Hcd0Wc8LPIi+GneEN+KvDzQ3UIYUkGMnAcfwCru?=
 =?us-ascii?Q?VU7qVYUYN1zxtSsnxvRELH52YBo3UEWqkFgHvddkx6YUQ0xAz91YoD0DfCKA?=
 =?us-ascii?Q?+57UMd7EgB+vB52r9LYcoK5bjMzEO1+Zffx7duaJuyiZghLG4mcjqNPUPRCU?=
 =?us-ascii?Q?au0KX03VY679cLYKu5Huu5Cys/rWlYrZxnPARTfrQz5s4faIneaX3wta8yEk?=
 =?us-ascii?Q?w0h0PXHRqe2vNS2bAq75rs3wIVCq45kcpDjI2vytnOGzhpt3/MT3zJECcaNb?=
 =?us-ascii?Q?LLFcucJuhIRvbViUlWgn3XoUa5HZUTrDWLoV0ng7j6XC1dYjDu6cqupeCpjY?=
 =?us-ascii?Q?8i8TmwQXmUd3Aejr0cs7YDkMouQFZBLlaUAV2ekDWjcEYNFq7ms11Cpv4gKc?=
 =?us-ascii?Q?WY6/kkI2bqh+n7E3LaBEjDp8Y7kaY9WWHa+gqyt7icu9plS6ZBwvfAhqQHPh?=
 =?us-ascii?Q?2VHLTjh4Zr/tN7VRMcPDnU4n5kybivQnkKaIH9ARfZPNCIJeK3SyQUnDpnL4?=
 =?us-ascii?Q?dEr+kjxLXgjjsMtLITAZh2O2A8RCQs1ySYwYABB1Gn7fqq2EUFAOHixd8mQx?=
 =?us-ascii?Q?MQO8hq0EorvV5ZvydJ/3ozbPvKVvQ9m+wH/3L9oMuopPjmN37x/GLv83J4cO?=
 =?us-ascii?Q?RUIvLbBpzYF+kE+/xc2QnnjEJVXxECJIWUya/2qm6Ln3BIcevJe/Clf9CBcr?=
 =?us-ascii?Q?fx0tq53sdK/YkP3siEm7wJ8h9D/iIJVsz/c/OKZCwJDc7UBtKRmExbE2TtOW?=
 =?us-ascii?Q?+PJbe8qvLiv5EVXDMz/LKJewTz1xuwpoUHgQpPZ8ttU1CcNazjeZ7iyN0TBa?=
 =?us-ascii?Q?vCi5tvan5ct/0cPrz8JMcJ0KUOi6mbH+RQfPTopYDls28VsW3/MWYU5xj3su?=
 =?us-ascii?Q?iAY+UNxpeVQ2LBaDFPu4RAZ8P9VgFGG2hihoBfwrmhS2vNyg+3M+sBSKHNGZ?=
 =?us-ascii?Q?PPwOrBwcN1jIajHU9Mcg8EzSUp5OxiIxBhv+UpY6lcNF+rwSbg2ouaXQS3QP?=
 =?us-ascii?Q?3FwTnpfo3EFwp+5XY5LdHCCCqFkJtJsfp4bt7zOoULM+UxPlT8tLGjI4HTma?=
 =?us-ascii?Q?K5Wg1jY9EkepnB3PnYgYtaDKBoFD0rd7Lo5WPwlaQYrXhObF0oERCbUCjs5T?=
 =?us-ascii?Q?8SBXMe9171PQ6l7fF449F1fWSH7V32q0c+QgIsKAkxbxOCbl/4J68SuvX1zx?=
 =?us-ascii?Q?tseO5ualJq8GirQ6gIP5a5juhC0Zk11LUTq0MhF33jvGCkw29bZkQsreVVK1?=
 =?us-ascii?Q?j7EwVPz4xz6qrQGEs8WF1ysyy/wwn5JzOEhAcnsKpXxwck7SUaQ4kDiWs4W5?=
 =?us-ascii?Q?E7TCPkO/l61okGNvP6Yz8i/ekg1OzhwDEoyFMkI1KY3dfgcTs5Z7s32CdfTd?=
 =?us-ascii?Q?m5Q5f7WGiju79JHxFAKnVjpU3PbogUKSUw2USluqDXeve5itcgT5Qz5Hk2rT?=
 =?us-ascii?Q?NyhGfQvl5+QxS9wbazUrhjvUV5qIXVQqPk5cgNEU9VFr/t9jXrBORqfMuMrx?=
 =?us-ascii?Q?DXwN4M5xXcN22cZINlyRrNiqcSydLZHv27Yt?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(7416014)(35042699022)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 20:31:41.3157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c75e5ae-5eb1-4fd3-a9b7-08dde9968f3d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C711.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6264
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B515C160013
X-Stat-Signature: e9sze4syomu7r3e3ejonmu13afxqu8gj
X-Rspam-User: 
X-HE-Tag: 1756758708-82512
X-HE-Meta: U2FsdGVkX1/OhKPyIfVbn0fgkTZ66sLZ3RZY93+L4D0zRwS+vIf2R97+lTsJg3WT2bLqZIzz0zKmTaQPY6AXjYwuzz5jK+we+MPfZQxfgd4RH4CtlezJPBwlKb0coCLTtd/4DKCFlUAtkkhEcBJkpme+d0D8GHG1LJYAKc96grQbjZKB3Dz9bNqdlQ4pVKEN40iwobky6AuGWAIJlVM30Gc6W4eS697vQyy0Kd6Y8DpRVWrQ6UXBM7H5/1fKTxVxFA09cNFXy/BkU2hpFm4S1oZdJiOfd+FIf+l6ehNMlSmiLpsFjb/Q3hcROmzRuKRmL/BjHCzCRLMtyzuF625JZN4iGv71IM20CgxeLQuRHa7X6qpYXBOxQf+D7grEK6nJLrLKSqoGJRPdX8xRX3nQ5vlhTn5mFcF1X6ncQ5te6ZRlcmpO9RwMSIQ/zUGNGG3QRiCEw9nHOQovA8b15uxow/hrw81kcv6zZQgGDbiq72RWDTpfZzwltweBzZikXJH624Rx333Ad7fPNBfp2qNiIxPRmhyP1Bv1nY+HL11sn01GjI+JiQ7dHGmOQ8bjwn80Z1FWAmVEPh8wK1X3paKU1j2U2z0rgccC7ZUFtjzr3AXkeHDA1vLs7h9EePQT2uWgiSCUFy84J+a2OXP1CO3QjwPkAKqcKmdu/LgPtym+CmL/S3ljGSKzoPFCzjuZE7lxGnTZedafaFqgCbHzZBkVTLL8UduuOIQxtAf26W9D+m0F5FfZrX3hWYbdTC8kN35UHY5/K48CAkCr8IF2GKlET75L2wKtw06nGlBXGctWQGlTURm1sPvYfxWL1RB3I3gyxLQgToCyFyEHLbdfXhGDIFb7qRi6Jf7ppCnFEXeGXBVCDDYUa8mFflkSpWfMHVtBWUtJgrpjEo5wHJArMww9RHhfqT8Oiwy6LCEWHgICx9fgxtYZ1ePbRY5Y8k4OG8+OEwa7kNteHVsRQmXj3P9
 k+ghOoFw
 nFfnp+xqNFrPfl5SGhbkSPmGES6tkLoTwfsPI3FUq2w5JbhXnd411Cb9OByAtVE5sHbabRUbjxLbDztucLsgeWq8314ZbfSPtchxv20KUe+T4pQ3gAHz7CFYCX4m0JVJb7auvYkjKFmi+v3DlG0C3P6Bw+/iopSILB09TerdYazd58SRGxLOJepn3wHSqwc0IA3TrxZEteuKuvLZN0bpo0O4O6jmEaqiD7Ezudst/Dzvl88J2rJ+fxWqmQ3bg/q8FtJP2ILfPwI2g3wfXchH1UIK/4fR21PzpK5nDg6tJu6BdMk8RNtBlUH1p0DItr0P+dqzd7hAwDh0ZM5vWudOoMZXVQ/dT4TbMjjDFFx2jleIc8W0zyqVb5Fo0xxZSyF+6I+mrfxQ9akck3meoz7jMD4pdIdOze8AlFiSgJKuym77erHtK0ZeAvxn23a8332boPx6ISqQOEUj5hs+HgBg0dt2dt7AdznOftDRv0O3Jh2yCk9FKqHT2MZcotk9adatPCsivv4tDbVNYPy6+tSltPuJ8wMl/QQ59Qs6wilnCJYH9zWDPVFY5GgH29gpl5a0JWAkt/mIrL4ICp2aae7UKXNG6Pd35sOdzt7ijDpNZvYYno+muDwCKJIFhgx4+LCudahAybqsa4tkFnke4uIDhsfeaFfelWrlSfj3i0OaN1jmjjKtc/xVroJ2AoSzNjFMpovKfXg/9bYxW8IT/635hRhUpP9mFLetN5zhzSux0lePeA4tfJzlxbmL9RkZNMU8HebE4xWU80BRuWKUjOgaRp5if3lBr7wkmsEcBrIjGLvVnvYGG2v8JHD8nvqCsRlkDRrJwVgc6vcss0srU1fkHQSws7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon,  1 Sep 2025 11:46:22 +0100 Yeoreum Yun <yeoreum.yun@arm.com> wrote:
>
> > Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
> > raise of tag check fault on store operation only.
> > Introcude KASAN write only mode based on this feature.
> >
> > KASAN write only mode restricts KASAN checks operation for write only and
> > omits the checks for fetch/read operations when accessing memory.
> > So it might be used not only debugging enviroment but also normal
> > enviroment to check memory safty.
> >
> > This features can be controlled with "kasan.write_only" arguments.
> > When "kasan.write_only=on", KASAN checks write operation only otherwise
> > KASAN checks all operations.
> >
> > This changes the MTE_STORE_ONLY feature as BOOT_CPU_FEATURE like
> > ARM64_MTE_ASYMM so that makes it initialise in kasan_init_hw_tags()
> > with other function together.
> >
> > ...
> >
> >
> > -	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
> > +	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s, write_only=%s\n",
> >  		kasan_mode_info(),
>
> This lost the closing ")" in the printk control string.  I fixed that
> up while resolving rejects.

Oops.. Thanks and Sorry for my mistake :( ...

--
Sincerely,
Yeoreum Yun

