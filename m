Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA9AECCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 19:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0014E8E000A; Mon, 20 Oct 2025 15:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1B808E0002; Mon, 20 Oct 2025 15:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09F58E000A; Mon, 20 Oct 2025 15:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D044C8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:15:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A959118810
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:15:45 +0000 (UTC)
X-FDA: 84019447050.06.D74C59D
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011038.outbound.protection.outlook.com [40.107.208.38])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9177DC0009
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:15:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dFncEEeV;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760987742; a=rsa-sha256;
	cv=pass;
	b=6+m/xd+OgOrPYQSfSpCQTaU33C62t41oOCSzvcRx8i2334OzbbGLO2sHEbgOd2AvDZhFQU
	Q8F/ubC1CG7IgfVrdjTPq6v5e8CZ0xoGVZF9D95oBPqnco1irWi4Sjbe+a0dp5c8AZGG8j
	HWrvCyqMxllY2sRad1Wsev2o04FLXFY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dFncEEeV;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760987742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nh5RgM2kL16QEcE2X7GWVulUIS4+98J/JmNSPUtvevQ=;
	b=wpbOHtoAqbZlOxAcRqlw9LGXFiqNROjK8Ix7JVCPJxgBpTRU4grhhY+hnd8Mn/kib/mCK2
	VQu51M8Tklpvk9AfKwqFdbhPRF8opFvrTaYxGDGAFjbET3OdVUuCt573D43xk+a7mhZGhY
	Ziz2DqzDadmkVr/2qTV8wnTuerINezw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nbw0LVpkNKQ5DFFR2ddOes7NiNAdS9hdtBid4zXgxw3TM61xENqOZneBohazCKNZRQDayQ8dAGJM8ZL6M61ALxaLJwYsp3KDIeHd4k6McYHf9fmzbh0kipw0lRo+tWjskdF2NutoyqzJXmn7CsMeuZa7RuTyIB2m4YSdzboOY8dJt2o+KuVk7wZYfZ+SaRVU5Ka6kZPsCGIIHyPmfTopxyTmjOktDiLQ3px6aR+B8FuFQ/B9MJzNBts5A7g/b4v6vQtBOA8J4hbktAsLcTaFGmxrBX0CvLK191MlA+MvZ9/tkcFm01lYGAQsBncv8y9nf4M2V3vMAN9NMTxrUGm+GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nh5RgM2kL16QEcE2X7GWVulUIS4+98J/JmNSPUtvevQ=;
 b=tqxXYXtBNbe//12kUdqZm/k5zu4SSEJGqauHraJQMZ5BRsfrNWS905/EwpBprSC4y+HJVa/qg4iLD+1F/XC59Z7thMGUpp7CtUayoSv2hGe5+lxq7foPn3k0YsMmMh5OCkaP22VfFdG6MyhZTNpJ9neikCj/sxMCUIec/CSNXbUYwRZXoyk7Uy9BN9q+LBZ8buZ7+cPH1i5/q/V7dZFsKRxa6bjsdxkviYOZS6FbZX1ASSuePOtyWx6MV5dutqy4XTJzibdThKMnGykNKgNJiBZ/Yo1JNJwaudHlItJZ7wLe3HLn56482Wboa2lIU87ENH7lWgBZfIeqQpxjanC+zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nh5RgM2kL16QEcE2X7GWVulUIS4+98J/JmNSPUtvevQ=;
 b=dFncEEeVQmbKEkRaqu/Jiojef8QbhOlLe8A6nB1+bMpBVKFcEozLo7f6fCafTJ0XgiWhWO9soptfBFnK9ZvhGAJWSaSYp9EYsjWJt31l/DZWr48K7Jw25cG4rmW9xYAYqKKUyKHaH7/DwdhAwM9TI3HPIqysisNJNaJ5CaOPF+Na8gRe/K8+GpXAk2jYUKRQ4DPX8iGmkJ3oGzvYNDh6AA8l+XkUIVbTd1TN3cUYhTuwaFbT3QeYdkcAUQ7RE9fLExiPvyXhanMxvGP1rVKxL1Yf1G3v08yRWC0qn5kJTfNpfoQ+baOoCF+isrqQRbVYGCU/6w1oeV+5yoacQqEp0A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BY5PR12MB4196.namprd12.prod.outlook.com (2603:10b6:a03:205::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 19:15:37 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 19:15:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>, David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org
Subject: Re: [RFC PATCH] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Date: Mon, 20 Oct 2025 15:15:34 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <609E7E01-33A6-4931-AC89-1F4B2944FB64@nvidia.com>
In-Reply-To: <aPZ0OKx_VnQ4H_w1@gourry-fedora-PF4VCD3F>
References: <20251020170615.1000819-1-gourry@gourry.net>
 <487730c6-423a-4a03-a668-9b9ff92a5cfb@redhat.com>
 <aPZ0OKx_VnQ4H_w1@gourry-fedora-PF4VCD3F>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0004.namprd08.prod.outlook.com
 (2603:10b6:208:239::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BY5PR12MB4196:EE_
X-MS-Office365-Filtering-Correlation-Id: d167cce4-0231-4c3b-21e1-08de100d0c74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DUwk6EYsERTTp+U/VdJXMB0MXjhnNtMSS9lGU8g5TNyxqewMH1PZfjrscDff?=
 =?us-ascii?Q?Y/Gb5TaGl16CK3vhn6AunbP0283GtbUk4ywIRMeq6KoSMuaGyBqRoliYZRdO?=
 =?us-ascii?Q?LYayGUuudknSOtim1iYTFNeta4BEnPq0jQwZtjXpsLTJ4qNVpGpZp+x848p9?=
 =?us-ascii?Q?IIzxGOFk0r0i6FnkdoOymIuYxSJYgEqLuxccAU/9SgIymxMheq1t5zgklCjS?=
 =?us-ascii?Q?E4hUip9GtMtX3VVy8F6IBVZZoCp/855M5e/fm/WqHlSgZR+zSFkXgc7U8ora?=
 =?us-ascii?Q?HO1z2rJAeVkiLm/Svfgfzux23BXCNyfAKFERcJMIQkJK6xZ82PfbJPWx+Eo2?=
 =?us-ascii?Q?ZhR1YPvUZ84Yq3Nqszr8e+b89/bvfMxlNEJ9/ozYZU+B/JvSW4JL6bH8NV/D?=
 =?us-ascii?Q?0JGBqazcso+w7tEFks2AlnCrvAFCx59SrzJCSj9/B7nCzHSxnsDVhueOtkE0?=
 =?us-ascii?Q?QeeUOspxBrv7kVrpjUWFUCwS95hnl9ZwjaOZN+6cRu06VFXk8kbsWKdg1Zvs?=
 =?us-ascii?Q?xepiH/eIog5UtOOK6Ap3tFQluwD8nR6pmGUuqQjkxn+ikUG0joykBkPbQeCk?=
 =?us-ascii?Q?3ZCnJIDEyYuPr39gc4UMnxl97q+EuOtIpZQsvzPn/1QILn3HfW4Wt+vg/NZW?=
 =?us-ascii?Q?YJi60SjMb1vmPo7VBzCFFzQHzHb0MSz/IoXTY2JMPqk4e+E6NhYSgB3/axqK?=
 =?us-ascii?Q?ui3tdtS8YTE9s6fewOtXDeTLrlqribDzj619FsbHd2dgRxyCt0nJSTlaVlhl?=
 =?us-ascii?Q?gtfLBkmqm5WHnTU3lW5wevOUDhvRO4jMCGWbIuQPgouJUoTrmsa/dt2yh5jO?=
 =?us-ascii?Q?jdT5WqfDho2+hxhCztLTsX3aw6RLl0fpNbdxxBSwEEAUWDjfDURdnvDDoGcT?=
 =?us-ascii?Q?PViH0JiZ63YM3GmGVBxKCjKqMefvkE+Tiku2/yaJ5o7FFXWlxcJta9d4R50I?=
 =?us-ascii?Q?PMS4WC2GVeL+ugloyK0LHB5q4wjTvdmS+sE8lV7hZx69+DuL39Su0ATYhOZK?=
 =?us-ascii?Q?auJJXNfba/nVZ54G05eSCvpHWJiW62QHiHhcmhiRTzmMCTcJ2lbAGg+ZoYwe?=
 =?us-ascii?Q?sAdzFVAdde9AbJsx9Az7grORR+lo1cMwv5kOXd+JeCULJ3zY6ZV12nUWvdSa?=
 =?us-ascii?Q?SykJ7j86e6IZu42ULlMU1kTaV3MQoNQ5asM/HS81dY0IZx9Wtcns3/IG48wN?=
 =?us-ascii?Q?JJfXP/UUDFgyCUkKVvsmAM49UdMYbYD8/1xl+bRdPpjvIFBiappFZ31y6Pkd?=
 =?us-ascii?Q?29H63wCeISSHFZYJTi9APUBg7QnKe40FtvpmgyCq+zzNXmpSySa7wLa9utcX?=
 =?us-ascii?Q?pGk5JwY5eHvwkyM4w5okEacW2sFwhWmi5W/nO95J/5v7lmFv4K0RHwNcRkgW?=
 =?us-ascii?Q?vgSWZd009u6ckrn7oVmhHMtaEBiHKImOD0LKjZ5UBKwHea4gkFc3DAc46hAf?=
 =?us-ascii?Q?EH/FbUFo46lAJ0FCBzGeFGa+lq7Ozj3o?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7QowxOwwL/ZcK4qPjxV2x31XBgZ7WNbf0EcUPSRs05G+CMo+q6YPEtt9EF1d?=
 =?us-ascii?Q?yCNj7M8xJ7YsY63Bi+KIdwHRmw5x1DioAZ7G7feTOMgMOZCBQOhYD+tV7bi8?=
 =?us-ascii?Q?bb/AiwbdpcKZEIYwNyATV4yFe5Jnv6qsDon3cWhtXO3n5O8IPDogng46H/7X?=
 =?us-ascii?Q?w3akapZdxxQcEuS/YXe58/Vq7JnQw5hp/E+s/u0bqy5F9y/H5az/58IeIQTY?=
 =?us-ascii?Q?BbslILBAJ9Mbx8HM2d/8mRLewKDtVFFaF+AveFVebpl2tHLgmSKtnxiqdyxy?=
 =?us-ascii?Q?SUkui2p0CTNgcxDQgDpedB46imyGjraY0yhsJ2ygOsPZGvWsGETLbQ/AVKwu?=
 =?us-ascii?Q?A4A6YU0K3Y1hH6YX22qFhACZYXwaNS3hqJ5H7eQ4qA3zMoD5F0W+VOa0+HAI?=
 =?us-ascii?Q?8OMjr97e1Y+Ms0IKRNaqNyBf5/McjUbnBa8cjLvY0ipArC0DSJzRv1Og1OLE?=
 =?us-ascii?Q?7xTP4moIXxawjSciX2a5G5KMi9vkrjUSiGtpkpCDGwug4HEmSLV8vSQtBX0P?=
 =?us-ascii?Q?SP23phoceNJxV7cY85RXCQEFtu3czxZowKEFDOPRhPcY0cagyN/noRnbgon+?=
 =?us-ascii?Q?X1ormsSYZF9s2EAVtc8BXNVMJbnvITnh81XNCkT+V3JkzmRbFCIA0AUKPUL8?=
 =?us-ascii?Q?hvIaka5l+IAKKFN/9gaCs/UrbibLDCx6oeeFjhbj78H5wM1h+X6EHaSDRPGs?=
 =?us-ascii?Q?jIw4R+/EAmFMYl239WK3+C0bTX6+vep4wqtuwuV/12Vv6CFywUwm52gvja1c?=
 =?us-ascii?Q?FkJKdx/14EeeqgHl2QyHlEVOHf/9VVf1X2gmumQoB9e+F0JmOUMpaUcgeJ0s?=
 =?us-ascii?Q?UYnEL5xvHrz+4WxZdidassLQ3W65Y5jhi60jknkfybb4+OK9LRNoas1xqmEP?=
 =?us-ascii?Q?E3hjSTxHg4e4S7iO7qbob/OAh4UZ8dr6ZIC0oaKOYDsVn5JFlHxCIIotpCzd?=
 =?us-ascii?Q?WgXUUQWXi2r0kD/rX4t71g21BW8EK7j3pK/BcUM/Go6zt3Bf6VRyeDk65R8O?=
 =?us-ascii?Q?pKaizFmToCMTiden3Y+ATEyxkGwCHQ1NMDeT+wUgdVlZVj4b/kiCljGGWYK+?=
 =?us-ascii?Q?7jRrBP85+eluhHby9DcS2VwLp+hWmtRoKd3Hz6gTKj+ld0EDhb6Ol1sB/8eW?=
 =?us-ascii?Q?oyqGiHMgu5vRR4c1oPvuTp2de1JH+9Ff3LilXHfaz4992bDrW2PofAo8Lw+O?=
 =?us-ascii?Q?gCfru3NbtF52pXP/RjUajI/8/CFmr1hbWzWEj28uMC4Rn/IlR3yjrNb83Wt0?=
 =?us-ascii?Q?ytigmH3UVFNuR4F2tWNaAX3JtRollnHyJmPJYzNb/LfB7NSwewyEVl1w7VU8?=
 =?us-ascii?Q?H0zbJ+/KFBawegg3SJVvKZeSi7hPo4hbB5ICTBtpIX4aIPy20pcFMFbGR4r6?=
 =?us-ascii?Q?4km3y4nkmZVHeh5bYf1LELccywzSxnl45WUnafUhmILAWE6/ALHmXQ588hj/?=
 =?us-ascii?Q?xqdESdgNonIQe4iYhN8HR3yh3bIinsYmBNIWVRhlh6XMBe02fL8wQUDTcUmq?=
 =?us-ascii?Q?9Acr4kevsX9p0nt0yFVL8+u37DK5QTWii4Lk68FaAC5Y7/MXibdPgS/WR3RX?=
 =?us-ascii?Q?emdSvJ5y7Wj9XL+d+CFK/IBlMacbvnoUqYkVkqRm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d167cce4-0231-4c3b-21e1-08de100d0c74
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 19:15:36.3886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcohUOMlh2kryx2e5tU487HI+2hpXOXr0pcXwdFbtOg5Tw1wjDJqs8jbX6Q45g2T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4196
X-Rspam-User: 
X-Stat-Signature: r7o6qepfuumnhphpmhjjmfe1aa8oqsct
X-Rspamd-Queue-Id: 9177DC0009
X-Rspamd-Server: rspam09
X-HE-Tag: 1760987742-552086
X-HE-Meta: U2FsdGVkX18sta0x0Jyc1c+AX8mJbX8Fiixk44nWK6D5cCjMzK0eKWUiiqkKrUHcS7nodnvph9YFcRKdvwxxZrRF3pmYWL9ZJjNqaHTAOaomMxs4ZpYrKrYqGdwCCTkTm2wfHcxRXi6OgA/+Tr/WXWNhQWMNLFRFC+1kqQQk0pUi3rCgwOTyPx4C48YHN3GPCPoCVeMaHsZ/37zGrgXOMDCGd7g9hMGHEEghkYo5F6FNDnTuqKc4TYzyb+q9cwVrH0/dvGLc4m8sNeuG8uBILAdLNtI1rr9nsR5glYZmSsvP2a19POqt2uyEoMEoTykOQEcYWrUJeVpHq1NGucB3NsLQB/VVaF0VjSUHqUa256M+6BxipY/HU4EfYxfI8eSTfV+Qu5DNDd8z73iyqO91qW+BvV3s3tl/FNQH4iNmokUGll+FNYxGh6uEoChlkpvXwgXoFX4iMowdERl8TvL80ZCki0LtET3R5eEHZV+QqZ5IBImd0oqVeRVGOLKq+SCB9wmt1/W0k/RRq7N5NNuZR67f5Od0XLUsMOEHDFUwci4PNHcsnP16JfhHLpgD0ByrpvUXgnzgj6zUgHp3kgUtIXhM40Mz6QOZhs8w71Gbh/vWTBGLaW1tKUddQBS5hIiVOIaYd70qSutdWyq4esR/PQMFutUI7KnWpbZJgk11GkqiVsCurnJ4xmbj8EHDcuhm4o3SnONHDl+H5v4BG/uczXjGRkIYTRhD2VnWiYHUFzZP9xFjMb5TEx7Qq9PV7JvSE+sKKgK23SE5lAowy6dTYDoa8vrQzFMaE+dzf6aeQpZorhFiITHoAKRqgeiI9FZhZx2u2VxweOaOYhiHO4eHmqlVXy4pghZnHBb0VyVC9WZ0UuCSnzr365Jwi4kUIC2zVN+zteedM+x6VRV7A1F0vEkXwtCxM639+CVmLT8QlRr9D4AIKCXgFHdrQ41YiHGOcbsFFMl4acgA3QXJ9/s
 flbByQaA
 DlR57sz6s2nM167TSJGtblZj4OK7/DNdNho7whtwHh31FEvtpgI4UtU7jOcKGP1JZgPtLkZhVqa3zx5KAh98uacAIW9J9G229l6WfONoGJuaMuWd8EQCnnLmtRKmbJyce6DObmSlWFaiBa4Ebx9FcLXwWZINmn2JQbInVerGdnxmjMzUIaUHvoMb2qhWVvEi/lS8KC///g3ixwX5pNmsLUbilEO4uPRRUe292lw2dcr8EdgQAWbkicND2iUe48i2lrRO6wnLPxzn4z6yEggsCxi8fZP9v7WOw5NTk5uL6wr414N+DUt7Hl+ioQ1uSVrh03AJkz4DmdaMRV1s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Oct 2025, at 13:41, Gregory Price wrote:

> On Mon, Oct 20, 2025 at 07:24:04PM +0200, David Hildenbrand wrote:
>> On 20.10.25 19:06, Gregory Price wrote:
>>
>> Do we really need the folio_hugetlb_migratable() check?
>> This code is completely racy.
>
> My thought was it's better to check if any *one* folio in the bunch is
> non-migratable, it's better to never even call compaction in the first
> place.  But you're right, this is racy.
>
> In one race, the compaction code will just fail if this bit gets set
> between now and the isolate call in folio_isolate_hugetlb() - resulting
> in searching the next block anyway.  So that seemed ok?
>
> In the other race, the bit becomes un-set and we skip a block that might
> otherwise be valid.
>
> I can drop this check, it's just an optimistic optimization anyway.
>
> I should also probably check CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION here
> regardless, since we should skip compaction if migration isn't possible.
>
>>> folio_nr_pages() should be fine AFAIKT (no
>> VM_WARN_ON() etc), not sure about folio_test_hugetlb_migratable().
>
> will change, and will check/change based on above thoughts.

If it is racy, could folio_order() or folio_nr_pages() return a bogusly
large and cause a wrong result?

In isolate_migratepages_block(), compound_order(page) is used and checked
against MAX_PAGE_ORDER to avoid a bogus page order. I wonder if we should
use the same pattern here.

Basically, what is the right way of checking a folio order without lock?
Should we have a standardized helper function for that?

--
Best Regards,
Yan, Zi

