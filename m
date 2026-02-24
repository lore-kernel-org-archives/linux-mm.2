Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD4DF3C9AF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1AD6B008A; Tue, 24 Feb 2026 11:49:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E216B008C; Tue, 24 Feb 2026 11:49:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01F06B0092; Tue, 24 Feb 2026 11:49:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0746B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:49:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2275B1B58D1
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:49:15 +0000 (UTC)
X-FDA: 84479935470.12.E0215D8
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022080.outbound.protection.outlook.com [52.101.66.80])
	by imf28.hostedemail.com (Postfix) with ESMTP id 417D7C0013
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:49:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=t+ireVqX;
	spf=pass (imf28.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.66.80 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771951752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+h+fJJj2qcjxqpbeeQozlOfGnSOz6O/gGb/Jiaq1mh8=;
	b=ZVzIwZeIe/f0nejuqy+0wzoX/2/YQsMNEeM3DhUlfu1ej8Z6sRAqjsldN4OaFQdPDFL7jQ
	qn7y21DkEIW24yLFBDaeEONz6Vk3d1qNJik8P4GsvAfvpMfd5vXYK/fJxmikUq/D7pUFky
	CSMJ8qX2umD/hKpeP5zxSTHLME+2wG8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=t+ireVqX;
	spf=pass (imf28.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.66.80 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771951752; a=rsa-sha256;
	cv=pass;
	b=Rm/lDv6cOuZy5LMUeroHpJvD2UmukgS49cRB/hJPmfaKo8V8kZhwmHVaDzaWkgnBO3mAdd
	i7h6hsCdIiG0LWl+Z0FSE0sgk6fr092QG1HSdQBJ5opgD7xuWOFC7yTsSnqkkSkQglXDqN
	Vm89N6knh3NdM/qdOwQLoQjgDmV9jac=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dXF/hEtwRBGHcFZeg5e+EU9GQ3np7UhHVoj+sUqz/6g45ZZmi/a0goYQSGeYpsfX+jfHdA3ymegGRiXCoW31dYd5mQbqgK1RtQPH6BLaIbry4+PwbaRGcl5gPv+m58FVt22/PTXt2cz6qCl0jDtPOq/+I6kKGtJdQS5k91E8ow8V+eFzJee/xW7hv+sLf6C4JgC5WFaisza+kBtoQINA8JcQgGvcoPw+pZrj+UwA/hGV19crmgHh2o4ZY7Vq9h8n8wnKrTvVUsfsFrBWNM4qEvVe7BuKg0yZqCW19RJww/p47sQwhdcivI78wpRzvjpkt+IKrTEvKJqF+fARg+GH8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+h+fJJj2qcjxqpbeeQozlOfGnSOz6O/gGb/Jiaq1mh8=;
 b=govLalXBPQ6AmUExgoB+GZcIH1fc6rHWlcXuPmUF537jIJfVA1Rv6Gsyo83dkH334ucl4P0AXEofglF68Ep+h8wicDAKYlVXX9aMq5qqDtJYqSmfzBkbk4IK/uHDxiLJdDjKk0+tIxS+nbx0/lrC87AZBEu/OItYNqTz4yK6ajoxCg5qpVb0XmE9fAucNUuh+n6oLnyKQHlOism+rrzpSg3gEtzOOSAeIg1dR9yHYI2fJGcSI4Ynh/Sts/D6SV3407BqudMm2mXtfeGIZkL5MAOCYnQNSjsBa5PjgfeDHRkoZux9IpWvUlienoUpzIvBrxLy/94yVEeWyD3XF+k4Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+h+fJJj2qcjxqpbeeQozlOfGnSOz6O/gGb/Jiaq1mh8=;
 b=t+ireVqXXZxejTImvIwWMG0tp7fa8xEyZ5G8C54b5ArJ9Mr4voBnyjSOQxtjTExB4mtamPMhleH7wmfQ3G6WY6UecIF/MiraPwAl4ZS068EkSodwb4OBaq88pFuk4NXvXwmbgPMGYlASRmAtj4rDPdcToSLcdKuqhNjzowFWcYBFLL8KjNVzmH0M7zEM8P2eoctH99njGZYRNndWuXBwYqBQwsAaZ+gEIynO4jXG0CBP06Gk4uivrgL97veBXhR21jgkidZ8zs+POX8BOZ5SYatpS0Au24pWyL3rwVouQr6wWMcSVRknSfDI37LNcPdpKuURBgy78Dn2GBJdhToDig==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by DU0PR08MB7763.eurprd08.prod.outlook.com (2603:10a6:10:3b9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 16:49:07 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 16:49:07 +0000
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
Subject: [PATCH v3 2/4] pid: check init is created first after idr alloc
Date: Tue, 24 Feb 2026 17:47:53 +0100
Message-ID: <20260224164852.306583-3-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::14) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|DU0PR08MB7763:EE_
X-MS-Office365-Filtering-Correlation-Id: 895f31a8-11cb-4cff-3d6c-08de73c4a03c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|7416014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7C1A+ibwdR02wQuleYGws3bhLtPnOrluZ3AzE32Pw4C3FrGYTxS38JunXEVP?=
 =?us-ascii?Q?6OJU+7jvANzBAOeQIgp2oWut8WTX5UqWLBz8lUDHomIxsZFbN4zZalcIm6Si?=
 =?us-ascii?Q?2Lw5GOTFqPJHaegP5OzzRRJWdH2smXptwiwMBWZ38Y1s8GgtoGX0S49ez4l6?=
 =?us-ascii?Q?WTGWD3y53mCI0OvP7W0vyDZw5qFiemlptVp7/fW+uXcygZS+XZgkyqGNe6fN?=
 =?us-ascii?Q?JV4pWQ/l35N/OX0+tNzwjVQZLF4MvyROB8rfTmNRxk0oFO2dpgkJj24lKJZj?=
 =?us-ascii?Q?WODvjBGd5X1BqC/RB0rX7etQk6cyURPRc5EpfNG8Y64ryibPXhsAAWaUvb21?=
 =?us-ascii?Q?Rt/9I/vm/fnUIizphSzhqseSC+x5xqc1TDrdVQrYjO3PsnwtsjMPNqmESzPp?=
 =?us-ascii?Q?ONNNU/KCH8mnRPj4wfwi5kQ+aPGmvw8ob/w80qOhwlvv0Grg/tJzEPDEFaq4?=
 =?us-ascii?Q?xgY9qjQ9bkXJcj+6LGNlcQ4FyYbpxU8GrL/IYRA9ZR1NnR/oro3XVJks1uCp?=
 =?us-ascii?Q?gCXr8nQYZffwcCqTMrzt4nfiBJoyNnzp15VoR9tMaR2ZzojyAcvtMHqKflNp?=
 =?us-ascii?Q?eUDyABkWG4C5VrNwZj+Epit+1KnQ28WAc6zCtLFD1NbtOsh5OS+Kq4YI/N5p?=
 =?us-ascii?Q?HRLMo7w3Ww0+KHEsZeEzuZiCb2eJfzua1odw3BTBAhRQ3Onpm6BsCvHNZYtb?=
 =?us-ascii?Q?E0VNVFbtjXGbeMFuAlSCO6c7zgX/3DUnMeHE/RDlMgZAZWtzTVvCsF8jtZ57?=
 =?us-ascii?Q?7hwhXP98+6/D/6hl0HVrBM9HZOrGPcEW9Pq5wCA64mliu8OZaVapkfTdXQZy?=
 =?us-ascii?Q?iMCsNAoVLau9m3Y42Yrcn3AlimtPE8xD80bG5am68rqhsgdS/Wr/bnLrXPGC?=
 =?us-ascii?Q?5uvstiuPCLsQFNQ+9FkVJVBWhneIosrM1+uXE82S8JQ31K9gACNqn/ralUiU?=
 =?us-ascii?Q?A6NrZaE8FR1axu8ys9HEfVVz8Tua7PGbBSeJpeEtPQfWd1a6tkfxOz2Ah1Pl?=
 =?us-ascii?Q?ZXMYKJD0oXi1JENntdyHNBAED5g/pO4KZd92iYtJZVkCBl88BFsuiK/ZzIEU?=
 =?us-ascii?Q?ltFXZlQ1y+Pa/du7/YROUfLDIDYQygeNpBEjIuaWT52HATiBoBUcvCHoAf6S?=
 =?us-ascii?Q?sDX2mf93AFMP4SmHRmFPAdydxz2JzAhjNsiHtDcodP320IzggimCLWu0ON8E?=
 =?us-ascii?Q?d4FWAn0v79XaaMTRbryIeAYsB2wxyt+OZpbenhVwTX+MZ6Kekpi19O1D9IhF?=
 =?us-ascii?Q?0zL4A491vBJTgHRqaL43qm3gDTH2+cRjPsh7KBm9WWPFkw0x7hMGEiot+9F7?=
 =?us-ascii?Q?8zLKF3ek5os7Ckmf9fbuF2AAvlP7J05GhrorzfiQ5n9VQ2/savJZqxZ8PGW4?=
 =?us-ascii?Q?acPNlZAn5lhVsVhBvkAhnR3yM87iGSrQ5CogoDqTA2fy6kuepZr+ZbSBCI6N?=
 =?us-ascii?Q?Wz3R55BU5UILojLZGM3z28lvDVNNOlgYRguBgHwxzn81FxX6HJ0mrCET3h/M?=
 =?us-ascii?Q?rWO0CZyMLEN3PYY6R4UaC4RdkyN7AVKq48R6tW1SLLsULW717WvjamUOLjfN?=
 =?us-ascii?Q?oVEtQBUSxOuWrYFn8/Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(7416014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kZduIg62TjWzdnHGZdj4VaXW3talbwLcLh49GLHOjE1WfKXqdydE53ImEOlo?=
 =?us-ascii?Q?NICfWLUmnWJ4p+5m7IrrHOa7dnLGa5LB05RJJRhI8rtsZWueyMvkqVEoqWTZ?=
 =?us-ascii?Q?ZNtv+VSRNXW7g5bFzq6Fq4OQQwnaIfGG5fVFp7hLZiVTbE+IxueWXeO+9oCh?=
 =?us-ascii?Q?96Qq6rtso7g2g5xR47LslVTnp/+AUAlpE7yQf1tZecgWU3ntbuqcuBz6dv2O?=
 =?us-ascii?Q?y6zFHZctcLdvyXINVR/ul+JyKUA96exMGWfZ9k0OEQFehDLuQ+PL+DJM1ebP?=
 =?us-ascii?Q?It4ZGtdXsCwIJYObbMcFZkEsLFvxqzSMmIM4ENG4jfGfalc7C+r+WafABvKW?=
 =?us-ascii?Q?oiMgGhVOY94z/deh+5H1sV1IWGcUR2ZwdRZ3MpiZMqJIsGK/KxUcm/pIQBFh?=
 =?us-ascii?Q?SMMCxoPifqUgiCz/YQyEbNktAsZYdPGK5ZptQqiNg3A5fCf6LYpFgMgK9hat?=
 =?us-ascii?Q?xI0w+LxEcruY7odscksy4WhPdwcskT3r3RQEU08qalUMygt05w7U6hDHhNRo?=
 =?us-ascii?Q?hsFJUITj7tsHQsQli63lgH1X7JXAOyHZ8kTJlpWsnn8y1biSLih4426fmhbj?=
 =?us-ascii?Q?83w3fGohnw9f4t4lhiuSi7e0qtgg2KygGQ/sRSxIvujYOQJGIUrpipYC+Ue0?=
 =?us-ascii?Q?NdpOhRpaMr+ZO2YbVegs5NrQrWNDNY/BEZvJEKjNVCCHKcKGBdo8Gnd0gCLN?=
 =?us-ascii?Q?jbm3RmewKHQjvGxvUP6mjwLtNUE4OQJZjY2CUESArAfsr5PKYhuERZ5DwbTd?=
 =?us-ascii?Q?UKRkdjP4iIoM269nuaMLMyEn6u4Q4CZP/g3W60rnyTrLH+Ql7CewUcUxtOFx?=
 =?us-ascii?Q?oUyRm9VYWDe2ditvGB0vf4Q+P1b0Gd+pAtHiyxF8DxqRFxTYPNZHAQbR4j/g?=
 =?us-ascii?Q?Gt/xT8b+Bbi6DRIQ7lV/XUMtY+tZKsdCwOVmIiHTrgC4v97xUj8EbyUrEerY?=
 =?us-ascii?Q?1dAvCD1hAvZZICRcnnQ+WI/ObeYyVq/ZRqqR+UIn0dbicpg9VKeRbZt4PK68?=
 =?us-ascii?Q?puWMmRqsz5NLZD4jIqGRXgW0bAvatZMaTELvsLL1Pjp0CTt4iGH/tcP72pAK?=
 =?us-ascii?Q?gh3tWEhkMSin2Zv87BuS03TINbQ+YTltAv3WS+sJ9N6aeKBUDx+3f1mwmogv?=
 =?us-ascii?Q?Qd6vJXY+iYna+2dxJIZsafCEKLFtDwteCdAOMXFPth2eNyL9MiQ6QkCFLlUw?=
 =?us-ascii?Q?9QIFD8UJfZhpO7I8W6lsQX3F3MLR/P5u22bFw+vwgnLZmes1miFbWuKN9t8F?=
 =?us-ascii?Q?XDSlkE7I4hVFfqMDpEmCHfjJMS+1USHaiAD3+DR6GXmU08t4idVXUkwo03TP?=
 =?us-ascii?Q?HMg5JUq7wAuYEVEnhzbK2Th21USpFH15JrEiLCHFgsR2y2ECV9/96o5ikjAZ?=
 =?us-ascii?Q?xa9Ab6nk9Q5JMt4qKusl/ddfAuA1GT/lrDjy9Y61+jud8xamvxGvfweyOt48?=
 =?us-ascii?Q?SE9wTfLab1d/xHxofB0BIjWFseH1Up19OJReP/jMKbPs7yAYRQeLA8EEheWd?=
 =?us-ascii?Q?g2JiRioRngjhhQC9ypIxdbw9JR2MT9Va1v1cu53ZIAkJk3rbidOPcu6M3qoD?=
 =?us-ascii?Q?E5GztPoBAltqhuRLbEbBi+/U5UxoH6UCr7inPgE9htgDvMTtXXjoapfR+NMC?=
 =?us-ascii?Q?Li44SFglqQzFVc9vV/0nOVnWw+hXnzqdZCdsvz8HPprthGW6rZKUO6/13Ko0?=
 =?us-ascii?Q?5dcX2ycN+xRkLq2UZqFl7WOBdWz/iltcbSYTfF29k07SxgfKTdipXz7voDi6?=
 =?us-ascii?Q?0vfG5IcREDf7d6jevhfhu0sqSgYUtnUWzsJSZ6LR7JTbr4sySn1JzrNRXC79?=
X-MS-Exchange-AntiSpam-MessageData-1: 5N4p3jojd5fFGjGH3HNwNjR/qAkHU472Q5w=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 895f31a8-11cb-4cff-3d6c-08de73c4a03c
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 16:49:07.3261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NoprJHpLHnBuebubWgy2LCoD2Nu+M8qa+/aQd7BL7RsWWOGuKOdRM+naKEycYRA3JOMqq2M+0u+Y6BFOJrPp44Gorjjg7AMdfhhGKzVmWSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7763
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 417D7C0013
X-Stat-Signature: mn6xnaxkx5rrdzwbmp8a445fwegy5ub8
X-HE-Tag: 1771951752-895271
X-HE-Meta: U2FsdGVkX18g1kJIpOsaKojcU57xq/T3/8/XzQxE/s1ne4OcDaEMgpMfD5WGHpwb1PRG8GaMWNVgPpXFDqkIuE2H8yZ8crlZJao1lFPvvU91iMWilXiiaxTX1g4jJsOjv3oCVGmBwV0CcTvX/UM/HHE+FFtMwcj5UaESOScUwQSVsT4Kq/fSyFd/0BjNyh9WOlMcrOiNYdDS5dwkzwV5RblSlnbonNw9Nzcfl43r+f0NQIkk7+eF+QoHocTHrdfG1XQBLyck34fqRcX5www/6sdJHRHbSNzWAYvAvJd74F+fRj+EzEMFLdmlSV3vmrf6N6Ak16TbH1OWwDg607ZUlgPJxyN5oAF0C+zVvgI0cyXImtIRLdjMzi67Z3fpQ3JTe6L+SZKSFEmb7hXcMkzyt2t9YeT2ZbFSKhZVQ3NKDl+oxv0HR5NuTboOq2AS2oBKe/6nLnCqZrgs9UGt/KjHXX5+5twU3lc5++zQQ0RKRHijRKUf+pzz7n2QT14VP0tU44vVzF+C0Dge86pbG/qCsZ0FKBqBBSDgb+2kmrosfKXss2HtMrfFB0Kc76l/Fl/ehoynK4u2G5NpPEf9uNXPc0uqAZqNFWkqQ+cNFxvX54AyoCscNmu4XtHA5R47FMbo+1lp7N2acBbbHmDUYWv3uNphOpsbSBIUx4Ikw8yXK0UvqXRp4+kHRzvu3r6FSXjjrL6ljqQPjZPaJ7DVJQkQF1DnWO0SDcfmrLsubnC2kcMLy1lynHOSEFQ1lGkY4J9b1qTGCqQJF8YANq9xQTtbfoCQp4dPHXQNdno28kHHAFEOHXxu74Jk+f3xT6O2WsCzzUga4wwsu+BjamRcVF3pVPuHbR65eU63GwOx/hJDKrw/pFIJGuCZqhTNG7cCVttheIyoR7eEJnWCThzjKOG6ZYfe2NlJDKP7DP5NekTvvrkY4zf4ramIP6Fiw4DSyU3d8mqSj2t7gG9WBuKO5t5
 nJ1n5iKY
 4jRdVlQW62NbaU92BaAqKh4/5hcY7olkXidUTfLqG3oJ860pSEdS3n2ByEETyk4P7/xp4dUTwIkYM4WEEiuDjPlt4Xa24VTEtJBtGV5ztTFVHSzwn1gqV8oZarPgstq0BO6BJLZPuyd0KwLMrQbFiVnNowLlVNXKiDYsWc5B4Ey9loywyiwkrRwN9PvV2A9+a0Lh7a7qQk7djs7pVCq3ucpIO3a6rNeSPT0xYiTdMbpCGEQ18n91bWfRw0X4yyfH4g5JcNubKVL1Xof7KoOO3Aj+piR63GQWN0RqBf6zafWWeuc9GtA7nAUONf+6/lQewT9fOQGHYVLlEu2SPSnJI/PxfiJFSDczAsH61Dlb1lsppIkns5CkOy90+4iSQQ7EVAr17f/d258hO47CMMblyZuNTZ3+aOXzlOauRKcLi1HV5d7V810sY/sCFScQat0kCQbADDu3iq1TXa53yTTSmzg8LQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
alloc_pid(), will get 2 as a pid from idr_alloc_cyclic(). Effectively
leading to init-less pid namespace, which is a bug.

Note: This is also a preparation for the next patch in the series, which
will introduce an ability of creating init from the task different to
the task which had created the pid namespace. Needed to make sure that
init is always first, even in this new case.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
--
v3: Split from main commit. Merge two checks of ->child_reaper into one.
---
 kernel/pid.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 76c2744493e2..ebf013f35cb3 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -215,12 +215,6 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
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
@@ -296,9 +290,18 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 
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


