Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14135D1119B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 21:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CAA66B0012; Wed, 26 Nov 2025 16:06:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2456B0023; Wed, 26 Nov 2025 16:06:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5918D6B0024; Wed, 26 Nov 2025 16:06:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 46F986B0012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:06:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F316BBB442
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:06:43 +0000 (UTC)
X-FDA: 84153992286.29.0AE8418
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012055.outbound.protection.outlook.com [40.93.195.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1D54012001F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:06:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="QU/RwDPe";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764191201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmYDoJ/TfaNmO6V4XeGzkbZgXkRGmkXlzitbV4Trdok=;
	b=PZAvQq6CL42oL5DEekFJNluBvsF7ETX//OGIT6s3awa8WwPdPwKGOM8+gjsToOEdyrJTRF
	gycCHCBx69aQKymyw46QkzyP/u0jqG4R/7TcgiV9cOS55PIWo6tYOPmWr2sq2z8/KarwN/
	uIQngMzxFO1oQ7CGWTqKtUmiLT8OnHw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764191201; a=rsa-sha256;
	cv=pass;
	b=FLfYLEWslVmahlkKO1p9FoFV78gvTczUkgHyUdEOyRmNHdUYsd401seuJrY1K6JqxZIcgN
	s7ln6u0tsCSCJEzpCtod+qpruI5HIfGgNyoxYYzAIafKy2Q9Yjs2Jyxz3ptF08czX/xy2s
	by49dnMifaVFdbyoVleyXgMG3pwo8Tg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="QU/RwDPe";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mZQ9mq1QjJND5M9oHNVMjRo7v49RJZHGYkJq7xlJajrPvQ/7sj7iOGnBSrCJi5JnxGxS2g0qHxyGpx7L49Yh0M1FLv+Hui5SHpdpym1ftY5RzgxzjD4Ia5COJET3iwrxI6ElU/SPFYwBjPgXyOqx+YXGeZpghG6u9P/0TZVo7AQQzw9fcf4BAtrWwg3gCDgl4QnZIji8SBRm0bBW1w0Y63zrusto2M1B/ZM78npNdVPtb1NnPYy+T6C2Uyx/BCynOyJ1CEFx/qI6cQV/lH00IuS5luMgLXv/uFyqRzXPGbwXDHx4wvBYiJ9djWDYCOSEUg0BvpRtrbyN2I06tojH6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JmYDoJ/TfaNmO6V4XeGzkbZgXkRGmkXlzitbV4Trdok=;
 b=VxkBO5xde1qVXFVJe3Bg3X31oq6bdb8hKt+aGXZPybYczcG9lnaoCj3z3CQUZN6W6XDLrLv9Y0lyM7qkxRZW+nXIc7rzy7hn765GnDxuHWn/6cCrFM8Bw0mIgoqCUuiu+dVC59jTHdAQPNGTXInPUcBAWEwfWM8nJj0pnxZqisoOp+KzmOnna/krH7qazRfNSjZcKlJe8vnhrJmCjG7rS5nvKo60mK5vgFwNskl3dx6Y83xZt5B03tfwn4ONc+PVfrI9ZHNI5GKJfkhbiYb2jFV8TI33WtArU5O1mlluAE+IPHAZ5/MgXj7NK2BvovMHC822WKeby2e5cnuexFIn+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JmYDoJ/TfaNmO6V4XeGzkbZgXkRGmkXlzitbV4Trdok=;
 b=QU/RwDPeh7w5VdKyl6Ehl3nFZHNB2Pp5xSqZNAJrC6Db8pbPfNWOhFolXKxIbnSjJCC1Qo9f7Bzo0kr4W8MUKoA587MB7pFzMeLM4jeB9m9zXfhWdde5ndNVjqyiG4uTeiv+dp0J4M3OvsRoCL2UT+rBertZvYfWvy4L3/pNsPuOAZNomvsD0LwSoQUf/4gQRbT0s322a7AJQ/2LijnxJkBAM1BnTfWmUqcsg3ki74wTd+zsLNQ3B7ktdZuwa7aieEQWu+OgP4qdLuYLmE+X7iTgQYK2cx7u+lM285lsvWLASwFAniZzbHJw103UCJH6+XXyXw7e4TabSLz3AmVJOQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB7010.namprd12.prod.outlook.com (2603:10b6:510:21c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Wed, 26 Nov
 2025 21:06:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.012; Wed, 26 Nov 2025
 21:06:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/4] mm/huge_memory: replace can_split_folio() with direct refcount calculation
Date: Wed, 26 Nov 2025 16:06:16 -0500
Message-ID: <20251126210618.1971206-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126210618.1971206-1-ziy@nvidia.com>
References: <20251126210618.1971206-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB7010:EE_
X-MS-Office365-Filtering-Correlation-Id: d1fb6d7f-5eb5-473f-3017-08de2d2fa98d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fiR2jOF7DjC0gepzfR25SHTYaezMq0FkdQiweB0/Norihn9wvI3+S9MKg6kX?=
 =?us-ascii?Q?KQf+mp2QzH6YYHZQgcWkKRCGAH19zIZuYdSUmk9grggqmpWJHWeHcx6Ycu9g?=
 =?us-ascii?Q?UEcHTVN9UqmBd9U3eqsOkUPIOaoZ/J8641VNyNnbySQS2q78LXq2XPHGwoZL?=
 =?us-ascii?Q?q8X1pR+dcEjLjulX1q03o56fk6TL6+dRPzj45Mj0ufbwmzNuVLHa3y/Qwtsj?=
 =?us-ascii?Q?LZ1i3grzWVXPLNYJCDfOvsjwku7t+3j/9jOmWNf4PO6UehNeRzZDwBsDr7xa?=
 =?us-ascii?Q?IxS/b+o3tOdWHE8eWOG4UtVNf9/mxD4PxrfCoZqMvT7mfj/WdmAhd8HtMfqJ?=
 =?us-ascii?Q?P2F1jf5E8Wjk4K1wOOemdK+XpmyZpmBJRzcB03CRHr6w1J/qNyX0vF9gL1EH?=
 =?us-ascii?Q?on0i+m/7IsXTL8ZskQgw5gsI3t4xgAI0s6SHV2NMaUJqEUnAb0gLqH0KSG/U?=
 =?us-ascii?Q?i3j2VrDpmLMsx3CvIrgFMh92IyClPdPEBow37kYTzhYvJhOWOxfj/scpcycK?=
 =?us-ascii?Q?xZvMxHbgb7O1R7jiHTwIxLYalK2N0ou1hoCh+l23QYaARNItVbD6MguJmzO7?=
 =?us-ascii?Q?0ZWLMSBiwyhw4/CgaRQZM0N8Md0Xrag3y4pZ3kBbAAvpWJP7k5qqDsMv3VIL?=
 =?us-ascii?Q?ceDBHmnjDs2AudOfYYGX4RvwRWraqn6xb/AilW2zCmMFpOmNF0lCCry6grld?=
 =?us-ascii?Q?GGWkV99uY2VAhCYdXrAcSnuS0vXgFfikX8fMOXhmra7XIZwjbQRnLptX46En?=
 =?us-ascii?Q?Ei1s+TZcU/8LGxg2sKIry2TTTbyqAhW9tE2lConKdX56up20YjvOJLgi7Dye?=
 =?us-ascii?Q?UI6rRSIqmpLjBEnLejmakHfSjUgR5Z41EXxCk3pvnSIM30i2F7/sEePW9qFJ?=
 =?us-ascii?Q?5i14uzf/bfnxuHL8D9Gk/IfXkH2kmUhjqlVjouiEw2Ajok7buD4BocHRpBXF?=
 =?us-ascii?Q?4xF8hHxV3dm3Xtf5GBZkaczQIKWfQKe1HgLhLULrefNLUjqzhEeEAKQjdriE?=
 =?us-ascii?Q?clgXdEoiPrEagwrBHdCBdXxiS7/DA5L5cI0AWkS6v3XSXKbBg6djQf9VCW7S?=
 =?us-ascii?Q?rooHX8QQlAY/fyduwvSCEoNI7RqmvyiUsWvfotNoRLYJmfl6R47yb7eDq2Nz?=
 =?us-ascii?Q?XMy7A9Ait7HdfkUpWBj9ec/h5unOmbFEsiZdvXDhFhERzzjkPImd9oLZpULN?=
 =?us-ascii?Q?wtuoaaGkLOPV6mW2IGQAzL3f/31B4VCzmGmz7w8HREz+gSuILDSfqJUk/0Zs?=
 =?us-ascii?Q?4hageRVKA3gSS8muj+PHXg7oN+kf+eZ6judE1R5b9U2HXs2oA+btu3EXgOZD?=
 =?us-ascii?Q?QxFFtTE26ZG1Roz9b9gP+i3Qhdy2I9Xqfpb++lp5iIhZzDmQ7ODxRHY7IUzg?=
 =?us-ascii?Q?E0FcpilwZpVBG/S1Ajq2A9Y5mv4in9y0hhQ4mKvNUoNFP0rdpOwHEaxqBwJD?=
 =?us-ascii?Q?qj8EJfsduNKlgP8nKkDhshwaS8WSWabb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5kDCjOn5Pilj/wFuBHZePULFYDbu5hgizcG9O+DHXDGW6vQVHqsM6FVCCb9i?=
 =?us-ascii?Q?K1HAvRwPmisd/+VNbQXv7DIzYCui2TQQik2vPtd0XVxP12AljFsFdBhATikS?=
 =?us-ascii?Q?omAJw3cZ9wUD7rqXevDhSy56JiwSPgu5+l4i0z5bJcaR074vmz+knJsCHvvw?=
 =?us-ascii?Q?8reJFOVkXQAaCNmq9N+0QtbxqYasbkdNSMXXd5uKn/cHstcR7oqDkIXI/9Rv?=
 =?us-ascii?Q?5IzemXVcjxK3cG8iuOyaAkk3t/3PS5M76CsxL9/HXwgrXN1cqWz5ZY/N9cpB?=
 =?us-ascii?Q?itgw30j4TYK3AVUWY1b1fpbDtG4VeQvN9In3xtBGkCmr6iKM7FlIyU9Aopu2?=
 =?us-ascii?Q?U7bey8K9zU2eZvFAr7hktnjiAlm3b4nxh093d5odL3PakBFjOvQiS4XVK9QI?=
 =?us-ascii?Q?UnW6Qg1Y9nbw+myqTemyDq32pUXtNWTu7JfDMSPA3grQ/NG+cap1bbNWbgIe?=
 =?us-ascii?Q?m1MK/9L8U6/vta8NWDbgblovw4UA9ifl8+elCpllbpNFS9tMbbabUK2jQMOh?=
 =?us-ascii?Q?cqahulZIxCZrJmYrmkJccWYzAPRGSXMJXNQMh3kTCVvYEu9o3ujycTl3uCF8?=
 =?us-ascii?Q?9cDEKAASAjaPnfS+yYq0rNIwH/elO6TKWaYrkJs4M52/uHlHQm8qJB30r2l2?=
 =?us-ascii?Q?z34gLyjRsUcAA5MeP46n0WfpYCgWUB559gaxE3x3RFq/LkgzZ21RPyEaslxJ?=
 =?us-ascii?Q?WqcZoq6b4QUsSQbJ8KGPbtDqDCXmzrHPn242gRzNbFTXIzWi96f0Cpe8pt7y?=
 =?us-ascii?Q?a3g43rBAEXRoSTcIFxB9anwKMRw1z5eVnu4DHLWbwS3haB4McKfjStbIksAK?=
 =?us-ascii?Q?seIhqpq5s546PsyA87tWeQNKc+IdJXCPrmF7PaZ2TDF7JM1k2hkgf3OK1ttk?=
 =?us-ascii?Q?ZS7Upr6bhd4jJATs1buXQuXU7t45qitXLHPM1lEwaYUuorp/mO6g6rxwEFCu?=
 =?us-ascii?Q?ufNQ+f87VA1j6NAPYfh7/14EV/VxZMyzQGQfdHd4l54NBAjsOV6bA85nkcRK?=
 =?us-ascii?Q?HGRhAiln/hOaXCbuyJCpPrBodNJPAiPdMI/f1qIBsMJLifcFfpetwg7xsnWw?=
 =?us-ascii?Q?xe3zF6i/SUYab+SAIg93ymWWmviGLH71w25JHK8bfl/hY5o3ubHeKCe9xjwb?=
 =?us-ascii?Q?ws+qHyiDHo8V2VqVlypCHE+iudlqjCB7Y3YEW0h8464ZXlrZteHBOHVNT4do?=
 =?us-ascii?Q?JN5jv6R4daoDlMWjMb844DiqCObcUkSo5bXUqJDiSuGeNqpBcaEPa3axIMb7?=
 =?us-ascii?Q?rAjJl0D/hjeTpehopoCQzXszVsI+iq0ljUC0acgVpMyI69d56SpzEgoJRxWt?=
 =?us-ascii?Q?3lOdjmwGbeGTTjZh8THV2Vqa2Ida9V/Z0Eg5sMuzdk0cqTxIsukTKB4mD+dm?=
 =?us-ascii?Q?tIdhPwCakXggYETAWb/ZUmvca0yEe4FtZMGL4cAhryFA7DZy5cJkr1/q7j3q?=
 =?us-ascii?Q?WbZwyDVoPqdw0gGMDFjgSWcn30QkupEF66JKRi0r9wB44EJujVZ5ljgIkAsf?=
 =?us-ascii?Q?lRZkOJnbSXqkw6H4sYI/eok05h1Mg1ZH3p8mbXIVcuQoEQ7ZBCjE85UYFBky?=
 =?us-ascii?Q?y0RF8jSYQXq8hlmYQi7TzogKg1mRk2zv7CWVl5xR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1fb6d7f-5eb5-473f-3017-08de2d2fa98d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 21:06:26.5763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n6aBf5l9m2gJD2if7YAHkzSn30RMsshJcZDImf7g9PKtpq+9zi7Iz4gH7O3htQVZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7010
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1D54012001F
X-Stat-Signature: inzeanaqe43qpu7ig3gsbgf6bn85ike3
X-Rspam-User: 
X-HE-Tag: 1764191200-149523
X-HE-Meta: U2FsdGVkX1+PzsTBXFgIk7/rJm00TOq01iZtsFK/ki8xRqGlTf9r92Kdrn8kVMr2/u8PleZQP4klCDY+Bn8Xvotw6Ye1DGYLU0KwYTxntmVrp9bCS3Xf9F84m228c7yB7gvXF1OchNDME+jZgo0I2qzuJBjOpTtBXTTZwTcCHBxqPU1N5oe8BcGBCGlalOHWuVWCi00WF2ZhobsrNvijMb65xE01md7+Vp5J+V/cmuzA3Az4An/ljDC5TRJjD60gWGA8897+VoAf3/kBhtAHM6Ne3N7qwiKlrV/9gyidFeZ7P2sMTdL0wYeGd3Ebc1YCKjG26sUsuuIGMsS7p2gWA5em74A3YONp9GqdOvs3p2J+ceFPorAyzEPvIgLa7Xm8VCzrQ7J0xiCYxWj1uA1pHnj9z26JXq20HzUyMropyDjnUcvAlv261qQfdU9gmFVFpV326VeW0BSe7KOt4fNfP4FYizonsQsfGgxtTTRwNZO6fD+OVmfJTSstWPAMasg7tyqq0T885SWmz30LZoNgkpQIVbGD2hZfqTfu6eTjqvbcR60TOIg77ApiQ0UQgLozkZA7lPKvJga9h5qZmThu/p9/8YWWjJkp5gUzpwpWKcohqiHZWd3Q2vPD+pvTEccQ5uCqrsYA/N2xXYMnIgQwT34MSkLFJvPDfTOXnnHeNSUDZybeVx+5b5ahwj6VeEtcv9QMRQn+MaljiujPVKbJWRsVWc1m4HRteW3YiLLc9ny3/ZjvIP7OVI47DpoEH/nI/FJ+yofoRXQUla9r5wNwP5Wf9Pf92lrJx74ypMd6fcwCaAtPyKROl0C/H+5QQQ9s0shUcNF8a38G94FnZ7nu6iXXCr37jlXtdLgzqTuTgF0S4JGHarR0Zn+w3EJfcTZdjW+yqs9CRXQ+IV92Ed2AJz9yUXQ5MLlrsMVhDKQXcK9lXzeHY8CFZLxcXSWidlKrv05TPH8NKPrIkt8pavu
 CqfADfy/
 orpnq3ZLky9eq9g8WGuq0HynWbu4X9I0A4LoQpxXJQ2tiBx0NxRTwQHBZ1owNyNTjxwb/SxLwcfU+KbWgFaFy0jFgGuaWi5Ng/ch1N878TBDZK+PMqVjINY2k7BOdUKvuBe4cHUvRe77pVphB0kVUOH2d3a7esThMxcqMgjz3i/5L71SQV1nSNRHMLeGXYUCwb85Z4bvrWsVdnfD9cbzpyiBEzHP+lSjNiF0cdVWScn8GLtB9405V4/yaH23aTqUFZ7etx3fipnL5IeEIRYCLRMxdbOlp7m8zbiNIDwDvP0Uhzge4ym9BppZDoMTDVmZhE4vLW482XfUU9gyOL50JjDMJTNqeNg8Lv7lFihGVRwipoN6ySsHrmBezUwWhN/sFKEMyvsnkS0hyGFV2enMwyBM7s/W9GwyewT5jOpWRG3/3BlWtF6DjP4PqT1Qb4BLU9/zCoVigdIU5I0wk27/2UvSxTAtvQoq+xGGKAiEpbtDhESbxIGSUP2HT61vi10zxX3FV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

can_split_folio() is just a refcount comparison, making sure only the
split caller holds an extra pin. Open code it with
folio_expected_ref_count() != folio_ref_count() - 1. For the extra_pins
used by folio_ref_freeze(), add folio_cache_ref_count() to calculate it.
Also replace folio_expected_ref_count() with folio_cache_ref_count() used
by folio_ref_unfreeze(), since they are returning the same values when
a folio is frozen and folio_cache_ref_count() does not have unnecessary
folio_mapcount() in its implementation.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/huge_mm.h |  1 -
 mm/huge_memory.c        | 52 ++++++++++++++++-------------------------
 mm/vmscan.c             |  3 ++-
 3 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 66105a90b4c3..8a52e20387b0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -369,7 +369,6 @@ enum split_type {
 	SPLIT_TYPE_NON_UNIFORM,
 };
 
-bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8c2516ac9ce7..5ce00d53b19e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3455,23 +3455,6 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
 	}
 }
 
-/* Racy check whether the huge page can be split */
-bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
-{
-	int extra_pins;
-
-	/* Additional pins from page cache */
-	if (folio_test_anon(folio))
-		extra_pins = folio_test_swapcache(folio) ?
-				folio_nr_pages(folio) : 0;
-	else
-		extra_pins = folio_nr_pages(folio);
-	if (pextra_pins)
-		*pextra_pins = extra_pins;
-	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins -
-					caller_pins;
-}
-
 static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
 {
 	for (; nr_pages; page++, nr_pages--)
@@ -3767,11 +3750,19 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	return 0;
 }
 
+/* Number of folio references from the pagecache or the swapcache. */
+static unsigned int folio_cache_ref_count(const struct folio *folio)
+{
+	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
+		return 0;
+	return folio_nr_pages(folio);
+}
+
 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
 					     struct page *split_at, struct xa_state *xas,
 					     struct address_space *mapping, bool do_lru,
 					     struct list_head *list, enum split_type split_type,
-					     pgoff_t end, int *nr_shmem_dropped, int extra_pins)
+					     pgoff_t end, int *nr_shmem_dropped)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
@@ -3782,10 +3773,9 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	VM_WARN_ON_ONCE(!mapping && end);
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	ds_queue = folio_split_queue_lock(folio);
-	if (folio_ref_freeze(folio, 1 + extra_pins)) {
+	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
-		int expected_refs;
 
 		if (old_order > 1) {
 			if (!list_empty(&folio->_deferred_list)) {
@@ -3853,8 +3843,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 			zone_device_private_split_cb(folio, new_folio);
 
-			expected_refs = folio_expected_ref_count(new_folio) + 1;
-			folio_ref_unfreeze(new_folio, expected_refs);
+			folio_ref_unfreeze(new_folio,
+					   folio_cache_ref_count(new_folio) + 1);
 
 			if (do_lru)
 				lru_add_split_folio(folio, new_folio, lruvec, list);
@@ -3897,8 +3887,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		 * Otherwise, a parallel folio_try_get() can grab @folio
 		 * and its caller can see stale page cache entries.
 		 */
-		expected_refs = folio_expected_ref_count(folio) + 1;
-		folio_ref_unfreeze(folio, expected_refs);
+		folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
 
 		if (do_lru)
 			unlock_page_lruvec(lruvec);
@@ -3947,7 +3936,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	int remap_flags = 0;
-	int extra_pins, ret;
+	int ret;
 	pgoff_t end = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4028,7 +4017,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	 * Racy check if we can split the page, before unmap_folio() will
 	 * split PMDs
 	 */
-	if (!can_split_folio(folio, 1, &extra_pins)) {
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -4051,8 +4040,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 
 	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end, &nr_shmem_dropped,
-						extra_pins);
+						true, list, split_type, end, &nr_shmem_dropped);
 fail:
 	if (mapping)
 		xas_unlock(&xas);
@@ -4126,20 +4114,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
-	int extra_pins, ret = 0;
+	int ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	if (!can_split_folio(folio, 1, &extra_pins))
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
 	local_irq_disable();
 	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
 						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
-						0, NULL, extra_pins);
+						0, NULL);
 	local_irq_enable();
 	return ret;
 }
@@ -4632,7 +4620,7 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		 * can be split or not. So skip the check here.
 		 */
 		if (!folio_test_private(folio) &&
-		    !can_split_folio(folio, 0, NULL))
+		    folio_expected_ref_count(folio) != folio_ref_count(folio))
 			goto next;
 
 		if (!folio_trylock(folio))
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 92980b072121..3b85652a42b9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1284,7 +1284,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 					goto keep_locked;
 				if (folio_test_large(folio)) {
 					/* cannot split folio, skip it */
-					if (!can_split_folio(folio, 1, NULL))
+					if (folio_expected_ref_count(folio) !=
+					    folio_ref_count(folio) - 1)
 						goto activate_locked;
 					/*
 					 * Split partially mapped folios right away.
-- 
2.51.0


