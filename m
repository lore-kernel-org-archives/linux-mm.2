Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D471ED6D22A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 14:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B386B0088; Thu, 18 Dec 2025 09:28:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4188C6B0089; Thu, 18 Dec 2025 09:28:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED4F6B008A; Thu, 18 Dec 2025 09:28:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 181216B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:28:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C193056642
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:28:25 +0000 (UTC)
X-FDA: 84232822170.19.D9CA48D
Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022103.outbound.protection.outlook.com [52.101.96.103])
	by imf28.hostedemail.com (Postfix) with ESMTP id C69B2C000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:28:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Sckc9RkZ;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.103 as permitted sender) smtp.mailfrom=gary@garyguo.net
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766068103; a=rsa-sha256;
	cv=pass;
	b=dyScEyD5qQuIKOBaRbu7T7HpcOhB7ILUgjEVy6Ca1tTSZHF95aXNp//1LjhVy33viJvTO/
	6y6g+4jila2FwhYKYN0w9Oh94ZwnlUnEkjrkdXbMQB1zC0GUNd0/z9mNagNB7lCe6JPrBx
	2EWgEdFFA92sfRnsUg93cLlqtvKCMpg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=Sckc9RkZ;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.103 as permitted sender) smtp.mailfrom=gary@garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766068103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4tHieMKFCKv7Fyf9D/fIdyOkw6lIHTzklRfKbhM7oQ=;
	b=B4jIJUquBmXEKaUJLWD46OQzhKozZ3ub3liYX2EhO9kOMndAi3HBRauYGjCeYXL1PD3rEG
	k84NITk9Jhml9qsDWgFqKx3DHqqqwovVjya6huDNQ6PHtl9vucCCS7MadYGzmVAtYJkBcR
	fec/4r+2kYJ66pe2Jn2QopUf//1BjpY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S7Ws13u3K2oJjMYFFtb2e/pg9gIURRzE0eGIHnkJ5VRtOolTiM7r+pavgyzxq0F8RoEkrz+pdqHJUh0r3quPopTkWYpdimIgrRGygsf5H/St02xgS2F01HPw8XRZ7h6uUmnI1+hSyGTB8o+0GHojhdQUbKgAcZGtNcPbUn9dVkp1Xw2JcNUMtqjbM9Q9mdGBVcuBDz0ASKdXhHilxuLq+jrMf+FvTQqgaGV5i98vk6awI2JcvKUo2F90cLGNglTWk3oicuqh8JWsIctVRhxfF61p3WMcnDrXt0drzPZFOwIxjdip9O9fstKuRPkIMlRRy/TTUC69bRAVc18A0B9Cmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4tHieMKFCKv7Fyf9D/fIdyOkw6lIHTzklRfKbhM7oQ=;
 b=oJpjIsqXH+g0P3o6xm6u5OlQxek+SovcbXt5/ZNhorF73ALlpFW/FD5ywIuVjRZ4GZQvRUepjNLcmtNN76g/G+KItejwpsTx/VmhFTerPsnO9D7TA6MKIJIop0QfpnVnwcMTpj1NMShiUBSNAbGR8b4tPj4wya1LMtu/tmoVPVTeF9xhceEmbxDqT6oO+8ut557XrT/dFBjkZ/fwo/A8wyzyMgc0ummSR56zB2quBXJ2J6ET4+1nJZFlT61ib1h4WLxesBgbHTDO2AeBsLWX2eVb53BtR4w+gX/vKlvKMVZRudQc5t3Q85OfPlVzmIfj5UIsXyjMXL1wLFod4w1GNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4tHieMKFCKv7Fyf9D/fIdyOkw6lIHTzklRfKbhM7oQ=;
 b=Sckc9RkZN14v6qq6QivvNjYk2ivVNEGmylM3UgyAZYjRrr9hptBntyWRIca4rOhnJMKEOzqyrbHu5E3uYa6eTKA4Lt4JV61bM0qaqWCIkr+PnL+qIbUTIXK9JDldomU/c9Bst6t4i4AOIRdkZWlE8hU0H2wVCfuHFEe65yxDJ9Y=
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by LO6P265MB6489.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:2de::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 14:28:17 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1d18:b0bb:b18e:594b]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1d18:b0bb:b18e:594b%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 14:28:16 +0000
Date: Thu, 18 Dec 2025 14:27:36 +0000
From: Gary Guo <gary@garyguo.net>
To: David Laight <david.laight.linux@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Boqun Feng
 <boqun.feng@gmail.com>, Joel Fernandes <joel@joelfernandes.org>, "Paul E.
 McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org, Nicholas
 Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Will Deacon <will@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, John Stultz
 <jstultz@google.com>, Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Linus
 Torvalds <torvalds@linux-foundation.org>, Andrew Morton
 <akpm@linux-foundation.org>, Frederic Weisbecker <frederic@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, Ingo Molnar
 <mingo@redhat.com>, Waiman Long <longman@redhat.com>, Mark Rutland
 <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil
 Babka <vbabka@suse.cz>, maged.michael@gmail.com, Mateusz Guzik
 <mjguzik@gmail.com>, Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
 rcu@vger.kernel.org, linux-mm@kvack.org, lkmm@lists.linux.dev, Nikita Popov
 <github@npopov.com>, llvm@lists.linux.dev
Subject: Re: [RFC PATCH v4 1/4] compiler.h: Introduce ptr_eq() to preserve
 address dependency
Message-ID: <20251218142736.464b7a4a.gary@garyguo.net>
In-Reply-To: <20251218090313.33923750@pumpkin>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
	<20251218014531.3793471-2-mathieu.desnoyers@efficios.com>
	<20251218090313.33923750@pumpkin>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0483.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::20) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|LO6P265MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: 11fb108d-7735-4e79-ba37-08de3e41af2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QTDsozFAifBzHMgtbpPsLiaEPxhADVNlygKiGyYzkuda2qafeh/eX+uLs/pV?=
 =?us-ascii?Q?H/ymfuQd6jYgZkerq18zhpeUciBwZ8saWQOd3JEfdAs/of8wQF2uH0Lir6Q8?=
 =?us-ascii?Q?6gRezEQxagWwq0WWVrF88cGMPuSSoP3HPGKCbT6RKE6Z8VYpijI+Ndi7kXWY?=
 =?us-ascii?Q?vkd3jprKeRHHXeiunCF1cuZzi+h0YrnGiu+p8ip0WF+DsAMqml95oJOPjNOZ?=
 =?us-ascii?Q?D1gAIZaP77rcLs/ZCtmbwsBdq2pIiT7XRK9NOAMCX+/RVDrECMutrvzQIO0s?=
 =?us-ascii?Q?Gx+Sdm96TMIpAy3lPUVec04kZ0y0rlWII22XRAbmWlefXQFd18ZzoyRuNd/q?=
 =?us-ascii?Q?uWmsz21RssyP+XJohfJuK9E5WtHlXSeSbfcEWHxPHnjeSljUQP4kivYaVcr8?=
 =?us-ascii?Q?RWhWcFoaD1AI+smjzxI5roF3qftvvWNtvFR4aPzNpsBhHZssH53BbYi7COG4?=
 =?us-ascii?Q?eid1hD/tPXpsdhhrclnhK3NK7py4SKDlpB+wa6UnlZPesU1glnaN9Kx8sNMv?=
 =?us-ascii?Q?MAI5SOtbBf2Pz5VIlw3OFkw7xkuypNLS82A3QXNrFCV8AkDVr13DDeTYuBEY?=
 =?us-ascii?Q?7l8LvBOUXB7/eTIf4JZ/xjuX+G2XY1EMxsz1MtGhvb17WKIYvcxAQhHOCTRI?=
 =?us-ascii?Q?n68iE6YmWzQu/N8SY3mCnyxT8hU4SVCYuikD/3x6qtBa4M0J+u9RZnmyb51z?=
 =?us-ascii?Q?p1N3BqpzbnhSJy743zONb8to3WdUtKcahMinAD0uUun8j5Uq/bL6cT3S2h7I?=
 =?us-ascii?Q?sMGN+35cZmYxWQSrIJabJ4wSAVeE6dQ3UH725QqWn/ZGl2HsaFBgauhtMed7?=
 =?us-ascii?Q?EQimE0VIfdFWm9IbO7MJQQReB3FpBFGhou8AQ2bd+uqDzxC0C5BzgegPIChY?=
 =?us-ascii?Q?1iC0XwUhTLg8kt9Rp71JUHnBzeajhaR+Ojir7LwM8AW5NyEksTsHfrncgDX/?=
 =?us-ascii?Q?w3L3a8lMfXZ4l3hJlKIovSv8+ZLYXL722/f0CKjO3TKAeNe8a+Srojng8guN?=
 =?us-ascii?Q?4I+OQij1QMk6ELxB56+DbwUgHEwLMXQrMcMqMtJnInFUZOhDwFNloy3osdVO?=
 =?us-ascii?Q?lMSRSHp+ZRbmY40d2rTmUnIgeWrX4dERL+/JMm5vHPPRUPOthKu2vd4+wWCh?=
 =?us-ascii?Q?09ShSv4X04xWKPYz+ygwrfg0tPopiBl4/GKsVuTaRFHmcY+Dv5zuRsUt7f0R?=
 =?us-ascii?Q?23DZNS9Yi0YnGALFhdNhGkA3aXdXEeHguSe6IvW+9YZBcH/Gg/ilo+aYi5NE?=
 =?us-ascii?Q?rO3EgozFkojXd+/ADjyb3RVko94mPQmGhlpQD3OeA6IMMG+VQVaaWtetRI3W?=
 =?us-ascii?Q?2NflqL3msFiZTg4W1sXjceurni51UuNDYGfLw6esQGOAXarKl5Xp3/Y9CJFo?=
 =?us-ascii?Q?OvePhoQszEMbO6ckdlaTZHRFVeoHdthMhFFvkA9LBXVDLOKMb0R5jPG2GJjw?=
 =?us-ascii?Q?ie3DldD52j/oB5X7/Kw3QVVvmz29DT69?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(10070799003)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5JQGrdgKFmD85RLtsQ+K7vN/TF0ZMwJSs/4RztSrX+SkhcDHTniWa/d3hcn4?=
 =?us-ascii?Q?vj77uCIs4bDUeLH9znZzNbqZxr6X4T6k+7WrDKf/hhc/j09aygeiiOZ5bQmw?=
 =?us-ascii?Q?Kw7tPTagbJKtk2tDvNDhJ3DiTQx/F24A/IdAumifA6fmt0zv/b6+4UWTE/M4?=
 =?us-ascii?Q?k4VpgCBodUZZXxhq9EJJCIbU6FfC566vJbKSXQuubYirmgZqQ0CiQxmITK/Y?=
 =?us-ascii?Q?4lFNXpS9YAfjqghzCSgBuPlPGERSP5xfPmU+zRJJWjV0oXrlc9Ld9fDR9Us+?=
 =?us-ascii?Q?G/9rP7Dd/MTjypt3j45Yo0nUqzxbyIOpgP4WJlrAYz95CqFoBkki+R+RYp6T?=
 =?us-ascii?Q?zN7aEMbryEVDZFdDIY7Q8kpn6N3jXiqEJlTwlYH4y38/jPkruWStm817uphg?=
 =?us-ascii?Q?kxPjoyK53ulsvR0NtnFfM+msK2RE50XJNQ5uRp1SgkYvOn4oTv/CQ2CyFq3U?=
 =?us-ascii?Q?n5NW3MhdvRWxXrVBXxWQkVRUoV1z5owFyCAzIpSurDkFGHifE60kTkavYgEJ?=
 =?us-ascii?Q?d9diRy1YBUfeFDXkljwUjSXnHgRvgHhM8UWVbIkTws/pCXqwX19OPE+pzIbC?=
 =?us-ascii?Q?89AeVI8z3vRsrKl6UjfVLhyAqtEMKxMtJM1HVKp4UEjbGDD0KaGQ3j/enLTs?=
 =?us-ascii?Q?m/ibGPpKYpECQtWB60pP0WWpehSrzaZzAUDp55IAXpqACD+YL4nROYdDlm6i?=
 =?us-ascii?Q?tUbWHrDw4EjhcP4Nml8S9hx6DwwhGTL5xxZvjthNabBaMywyxaZf++fGZ0K8?=
 =?us-ascii?Q?5NNEKznQOTSStj4Hp/CK0RPTEv165vrq3grfUuVfQ64sbJ5i45/jMaRinMEK?=
 =?us-ascii?Q?PEgLTBmbmGja6eq/FRjCjdjjfhDmHeiQCg9aVAtgzul9vJ5FFWIAVwHTBd3C?=
 =?us-ascii?Q?T/gXf2PEE1PJrLfb3S8UZ5GCm4OgpXu6NTtNx9dnDM9yBzKHSS014oNsxv8u?=
 =?us-ascii?Q?UizKszvSwKYczXKzD0zp7PlZqn15twyL5RlvkB3jXC6LlJUU3xU5CqDQjVN6?=
 =?us-ascii?Q?WGqnuOZYKlU26u5oIQklY0kp6rlU7ojj6ZTXnw9cTvEbWy62D9zPf/5NX1EV?=
 =?us-ascii?Q?WBgdo+xzE4goxBA0IvutOrUNmC0uxF/tAArfGG6kwOtdoQHQ9djhjxk8kbCH?=
 =?us-ascii?Q?FvT+UxG7D+FD0P6IpAf7EP2FgXn4UVx0+T6yq7k/bOneiyU0RjR2O4SrEcT6?=
 =?us-ascii?Q?B1hsDm/M96+tMUSldyIGftnReIurdw30eXJqbHegtMqv0Up1ab4ACHLIpF2F?=
 =?us-ascii?Q?Bmk7X3eU9f6zR+QVX7iK6xRoCeZ2mZYzDjN4FYhZoDiXoO///j3Xwkg+DoTY?=
 =?us-ascii?Q?N9oPdyPgnQ/x5fWUgBaamw2ZZKv7yKjlegl1DaVm6Rhmbyi6MS90yMIP4qKx?=
 =?us-ascii?Q?nYDc7arL4i1JL6+V4SgC1D4VceX0GiyWjn//WRm7pwg4a8wBtbhcrDEa7hW2?=
 =?us-ascii?Q?DWKpmJJhMp6sYcKzwTBSjOyEy3oC7XdNkTJxFD30PRTq+nMxAdQP1DwDbsq7?=
 =?us-ascii?Q?WoQbcb/HgYnihPT5cKXGh2kEU2xgpNVKt4nMhf5H+MoVpDT4tw+Acr8v4bsN?=
 =?us-ascii?Q?wOrZnWF23eQaR9DVHbjAS9uaFdR9N4GVsTPB6w7X?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 11fb108d-7735-4e79-ba37-08de3e41af2e
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 14:28:16.7612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRhnjltnJ1yXQz/GBb+mz636vIUlPKLQdbZUvLXwegwKFJ5ouo/qYkL+hWAUSmn8KRTe/qSBzrsb2BpzV+6Tkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO6P265MB6489
X-Rspamd-Queue-Id: C69B2C000B
X-Rspamd-Server: rspam03
X-Stat-Signature: 5wc9i9dymqi9bbrqipbofo4dbidxwtwk
X-Rspam-User: 
X-HE-Tag: 1766068102-843157
X-HE-Meta: U2FsdGVkX19BWof/0igKAp0lvPUgyO0cEfVLPIUd7b35I53V2QIf5KygLhpHmaW0RPax6QvAYg7nmmEiO1NLyNzQndhCO12QlTVYe2hUJPsv7xf+Vm8q026m+RE2D0UBY633ivt+JJoiucfjdvYApCqZbM0658rqsLfU+EjqR4us1ATpcYQFaeYmuec6EAghcrASsDmGOEFPYnirrUa+++GIUn8aqjtXyIyM9E4EpyyuhU46P7EoaLNbf7Qrmx8fUpFYl2W66MgAQx8qqtatGM+rML9dp4E9qqSNZdq8d1SkGQEGwIKRtSYNG8XXuo6xTPuUaoDSiZGpGZL3CXB3EWuP1GFzvbJV9Qr+n27BDYkqsbpTK3ZIbmfNr3b7hvd/MTUWCJuRo5XnRqDfDp3Oh0uGKFAXwJYnI4atgOZx3BH1S4Vm5vVEPktklccGUEgm0yLKTh/2Kg8zDLaRqsall1Ukzs0rq7D4m4SKv+5tv1iyNMyk4l5a0p1+tM+nFwbVByd+8B3NzbH+Uf+sGp2Hi+hSqsxvtRqCS3lg35DkwyR3KdP6sWbzIw4A2iOuDT5rNIBgN+eVvBB30aI9nnQDOMxu4YnCNm/VxW3Hn6vI2PLETmtvnUp7prG9PaN7CF/R75ho6lKM5wid3kzoT+wVuXiq6Ki7BjoNPY1RFDxLa1dAxmpD2NzbbgV/ulScUpx20RTHI1AaTFY7IPfhiUqHIh5+OwackEpdEygVXpmejSJ4cZOsCIBWCyAb6r+gzc2DupyHyAjzKf4fD4/wmbyuXd9JqRmHJjzYF3wBpPl6wLJVcAb6x1XDdUSq56lY+wJWra//Qp0GO0gFdFMBlbAbNmIpTFCj0UMgb5yRVglowbVdQmGhs37N8GP47VHi16G5ZZP4pGECVZarFi/TX1c/QiT4bICOJourxaPNwFtFFrl0soJhpvFLLmnKScEkbb0Nckav/+DmP+x0fuNIbmb
 Q5KQeBUQ
 h+pSVBZrH9G989OfOWi/qK2aiE1YJzozJhY3WX0Ljlsz5qS4upizyB4LANZrbw8SL9MGWXVgNMPgxg4pnmTzAl1VtN60h8zsgh2lD8dkuq2Kj206zDa6R+7LmMg3aYI6G6wxpfiMjrPV2hwDjgz190JJ6kITkuOeP4oOpkOIMzjVGh6BqNuCNkvRgcmty87bRCYh81zcOPNsPLlFnq3evsspyh8tgTsTjdwo6MeARTLN0VGJ5qDx2ZKu+rLWEaeYxm6A+la1uKlivQr63bMx6NsP3S+qidnjG82TuyN8qZ5GUG3cJnNNXQ1OPBdQCZWiSUkmEpQhzrW/SqHp2DFSZBRs4N9VBgkhF2QUP/BRrE9NbQ/1/fF2z7IigDi9dDV2wdjMRmqjvktUPy2qhr04Gjw8PvlejvmipzD4LuckbGiQ8k1kF2CNCUnHv5VYV0dIVGl9hmlwz+SCKORKjw9SxJKSZU8ZyuxlFcbaW3LZ0b6JrpG6s3Kj+2/jwSR2J977JV4qsB5h0aWgnexap1hYkVlw5JbUzQM1LZzqlGVAe25Xh+IECfBjj31ZTi6M3hL+f7ZZ4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 09:03:13 +0000
David Laight <david.laight.linux@gmail.com> wrote:

> On Wed, 17 Dec 2025 20:45:28 -0500
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> > index 5b45ea7dff3e..c5ca3b54c112 100644
> > --- a/include/linux/compiler.h
> > +++ b/include/linux/compiler.h
> > @@ -163,6 +163,69 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
> >  	__asm__ ("" : "=r" (var) : "0" (var))
> >  #endif
> >  
> > +/*
> > + * Compare two addresses while preserving the address dependencies for
> > + * later use of the address. It should be used when comparing an address
> > + * returned by rcu_dereference().
> > + *
> > + * This is needed to prevent the compiler CSE and SSA GVN optimizations
> > + * from using @a (or @b) in places where the source refers to @b (or @a)
> > + * based on the fact that after the comparison, the two are known to be
> > + * equal, which does not preserve address dependencies and allows the
> > + * following misordering speculations:
> > + *
> > + * - If @b is a constant, the compiler can issue the loads which depend
> > + *   on @a before loading @a.
> > + * - If @b is a register populated by a prior load, weakly-ordered
> > + *   CPUs can speculate loads which depend on @a before loading @a.
> > + *
> > + * The same logic applies with @a and @b swapped.
> > + *
> > + * Return value: true if pointers are equal, false otherwise.
> > + *
> > + * The compiler barrier() is ineffective at fixing this issue. It does
> > + * not prevent the compiler CSE from losing the address dependency:
> > + *
> > + * int fct_2_volatile_barriers(void)
> > + * {
> > + *     int *a, *b;
> > + *
> > + *     do {
> > + *         a = READ_ONCE(p);
> > + *         asm volatile ("" : : : "memory");
> > + *         b = READ_ONCE(p);
> > + *     } while (a != b);
> > + *     asm volatile ("" : : : "memory");  <-- barrier()
> > + *     return *b;
> > + * }
> > + *
> > + * With gcc 14.2 (arm64):
> > + *
> > + * fct_2_volatile_barriers:
> > + *         adrp    x0, .LANCHOR0
> > + *         add     x0, x0, :lo12:.LANCHOR0
> > + * .L2:
> > + *         ldr     x1, [x0]  <-- x1 populated by first load.
> > + *         ldr     x2, [x0]
> > + *         cmp     x1, x2
> > + *         bne     .L2
> > + *         ldr     w0, [x1]  <-- x1 is used for access which should depend on b.
> > + *         ret
> > + *
> > + * On weakly-ordered architectures, this lets CPU speculation use the
> > + * result from the first load to speculate "ldr w0, [x1]" before
> > + * "ldr x2, [x0]".
> > + * Based on the RCU documentation, the control dependency does not
> > + * prevent the CPU from speculating loads.  
> 
> I'm not sure that example (of something that doesn't work) is really necessary.
> The simple example of, given:
> 	return a == b ? *a : 0;
> the generated code might speculatively dereference 'b' (not a) before returning
> zero when the pointers are different.

I'm not sure I understand what you're saying.

`b` cannot be speculatively dereferenced by the compiler in code-path
where pointers are different, as the compiler cannot ascertain that it is
valid.

The speculative execution on the processor side *does not* matter here as
it needs to honour address dependency (unless you're Alpha, which is why we
add a `mb()` in each `READ_ONCE`).

Best,
Gary




