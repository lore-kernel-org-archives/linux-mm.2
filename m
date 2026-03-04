Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99EBCEF8FEA
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A9F26B009F; Wed,  4 Mar 2026 08:43:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049EA6B00A9; Wed,  4 Mar 2026 08:43:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4DB66B00AA; Wed,  4 Mar 2026 08:43:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D64616B009F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:43:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A93661B82DF
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:43:23 +0000 (UTC)
X-FDA: 84508497486.13.6D6392B
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010012.outbound.protection.outlook.com [52.101.56.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id CF08B180018
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:43:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DF+un22w;
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.12 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGN0nZZccOhWLqx0Cd756ZTKVvP0Qbq/CCAlWH9TDrs=;
	b=h9uGuGG9yWX/zkPubC88oI7RqO3jq3Wzdob9i8mN7s77djiGJ6a+RVt2w48EY5Jy+DEKlW
	SKvbtaXx/BkYa/p1YJYF+5mSuJaCykon9Fe9zAlKcuxccpgS9YUQT4Td428kGrvC/CuWNC
	+jhtHakWwULgwZW1EpyjkkdGGbEVcOA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DF+un22w;
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.12 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772631801; a=rsa-sha256;
	cv=pass;
	b=IXxh0+G551S2SsTcnaaeAhwI1aqDFbzbghqSGCoNu04O/0CUseDlRktgxv8QuHWlxqIvoh
	Z0EDq3U70UwTSdBnepN8C78fLOMIW5mxI0vVlzOQ22avTvoJsbN+MHyW8l7FNTv5UPFRDR
	1OqUv+XQVk8IxA2/v1JOlUtH2ze8sDs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ghlpcex+gsy9QpBcUwlkDef08BSHqc7hZhxImOQ/PzhDryuqwY9HXNQDxC/MK3ROG67oeMpda6hDK8IJtmAgKQ/33sSibhEz9gjOTfSRKyAEfwtH5viSNhoUpo+vDDmV/+RBDuFm28EqWs4ZhqfRk+x0B711yOtOoT4mlX0hk1Oy9RNmrNJhuYbB7gGBvmWRBRH/bikUwQr3s7XV14IAuyWLIt0qgABT4etapeeNshB6Lxd3Oa49ips5nSjVqqjFqjt5gT8IsbwfI0xbmx2o7rouUM1JbvEGp0HeijMSGBctRWQEAJNZayYWnqMvBLo/H5HkT6aPNs1GxQnGLwmDiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mGN0nZZccOhWLqx0Cd756ZTKVvP0Qbq/CCAlWH9TDrs=;
 b=PRL4GqIG93agUA84klqDdK4pSrIXHhvnaJmgeE+N8zo1NrCUaoDcADMKB3OIwWFs12vVlXcslE0FG6Q2uFKifJNMmXkWbt9qbEK7AWh98xNS2OyOswsVgP40Gy/POdH/ApcrqoKZZBJwBf2kwefcPDwmRDTt4s+in4FbBEBzBX3DYypsceHf0fBOqgvHiiR84tTgDO0x1v3Ou0UFoe1gbHbxs20bI3uneuqmtJbio8z1+bQZT8UHtvguaXGa/gWEZLY4zJZ6Pp/7XnTsDe2eqYbWZ+LhXikDF+PR18teA8LIw/2MArMB9l77PzZjPIm5MaN7gzYNTOedEVfg334ONg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGN0nZZccOhWLqx0Cd756ZTKVvP0Qbq/CCAlWH9TDrs=;
 b=DF+un22wi30E7kHGq9jXwWgyFgA/sMCD+MWWJzHUJuUEMzm/cVP29YYw1l1Bq9+KpoGg1q9VCXCjDLrz2xwXXdsbIdswydZVOmmi4jv/exT55bSmQFL+2sn0P/74G8Zyk20HpbukQdVLLdIIHlo1V5tBSu5Dn5v1+lPLLMCNd9ntfniQ27rCp8tpnrSTpzEUaWCeIKKkS/ohMaVsI+NivqL5AbGBIy4LWPs4P8hU70ED92K+VA6vYJUs3bwmrcEmYtqyVnfPS4KqOi9ZjwBLXkOc280QlGsQ96O2eGkc0huENtG3bljDk3lCeKtwHpLVbDMuDHTNyVquJrjYq4nUgQ==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB5885.namprd12.prod.outlook.com (2603:10b6:8:78::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 13:43:15 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 13:43:14 +0000
Date: Wed, 4 Mar 2026 09:43:13 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Piotr Jaroszynski <pjaroszynski@nvidia.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Breno Leitao <leitao@debian.org>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
Message-ID: <20260304134313.GM972761@nvidia.com>
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
 <aagUtDTca5d0le2Y@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aagUtDTca5d0le2Y@arm.com>
X-ClientProxiedBy: BN9PR03CA0579.namprd03.prod.outlook.com
 (2603:10b6:408:10d::14) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB5885:EE_
X-MS-Office365-Filtering-Correlation-Id: 47151244-e48d-4922-8b2e-08de79f3fc21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	VTwITt/rCb1sOAHT0Ynn2+VJlaeE2qnODRDuz4nO/cg1iRsN09b+xUNGEHPZVWp+6aD5lGVdx+XeGoIPFfcNJRRBvmokGRy8vmb7NEF58FYoQtGoj3+KOeSEhEUG4iohsHrkl9iHW2wVEwEe3rKqI90pDeblgaAuiz0M0DrxVDGkxy9WXgd9Wfd3KLvHWG5lPhY5LDESuvpeDCp3F7gszCM5S1Cr/45FEOeR6ScppLNckfyPNlHOmhCq5iOyocy8DItaU/yjTDdPh0p6QyWV3U4SHfnQr+pfpyadERvu0orPkoXedW+dgPDEJQG6eHkG9BJ63Oa03DSI2RW98L8POYtCPJrRZht4aiCEQ1IccdK1wQirVCEqPg6MqwMsL50EV5Nu4V5rh8LHR37RTRVv5DBnxrw5mXkPcD8zT3AmrDlTFbM/Vu76qybsg08HoJ3PUqSU51OvnMKnNYDbKwga8QE7+eZ8tnD9JyNZ2Ub0curUWrISU3Du8oZHVWZLWAGRklacl4DNl238HcMIjQBWnqfGrkHn+g0qvRXRH2Zv3tY0VMSm0BwclKXKi5j6FBAnHI8iRcebdEmkYxbrhHK/G51aL/bytTGSt7Sv3AcQ7GpuxnL7OBb/BsH9u9zPrv84xN//7uM01rByj7MLxREDOmXwvIGSB1YDHbj5Rx2NfrqvI3FiW2LLB97uQvbkEVFv3U8Cxmzo+J6ISMDGdw44Bz4OgkM1EcNaQkJFfXLUBx4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rVEqStyp/N8odAJvn5daGOEB876GNimnHCt4XW7H+Yy1fkxayZI2w2TiFH3d?=
 =?us-ascii?Q?yVLhcawX80qZJ3M4VeCkyMM/Yy2jhGxUe6C1nV8kgiNKe9LElGcDpWN1cwCD?=
 =?us-ascii?Q?58hL92V9txtC0hqWeds5VwJMbOBlJhcJCINP1seFw+RSpML+d/gqEnewjpEf?=
 =?us-ascii?Q?2AE5vIlmtybBJC8EtP/WsHkW5pZXfyVD+SnvrzSVxwb9QznzqzUBxIkW5yWq?=
 =?us-ascii?Q?mBkrNtWHaMvrh9TmSKFcwn3sJE5wGY+kUb0CLw4H02oX9uG9eGuHdT+pBjUM?=
 =?us-ascii?Q?KUs6zaIloUpW2HN2UfDe5Z1zJpRsi/mrPjipYBGcwSVwUTbTfKY/HRrl2Fsb?=
 =?us-ascii?Q?fICrnqTYRfZIgkipdZj5RHYnSlllugY/KqSYJvIMnVQ4Oc/TnygfYqPEBjEz?=
 =?us-ascii?Q?wnYHQzrPriktKBkeWTwe6txtqpZ82CYaVUH0bmY7VTYDPJjHxQelw5hdmKcH?=
 =?us-ascii?Q?wxv3HHhsXxcu5MdMY2OHgoL52o4jeFH5wxzBLhvHtuThE1Npe2AUlV2U17Az?=
 =?us-ascii?Q?EfC28HrPK8ubfZrAUKd8cilB1ZHhE0R3Imd5oYa06rEOBccM8zqhLqFkTJ6B?=
 =?us-ascii?Q?JLfTVcAuVblaCF9VAFCqDtY8GB7S5Du77kEtfK3LtjImwAZAayzS4JXgTAhm?=
 =?us-ascii?Q?j1RJtXqQf8Z73xZ41G1xFE11EugF9uJzDO9H0cuX5xtF7FKi7r1V6luUsONg?=
 =?us-ascii?Q?8CM2qv1jmbS66fa6vwTeM7PlmIV9WF9FbedAbIU/pmES3QYTqP+VzIig4bNQ?=
 =?us-ascii?Q?ofc2axrgaDke1Xjsj0CgEy8Kz6YGF/GpEoulCNsu1/Kpak78JPw86g4fn4cy?=
 =?us-ascii?Q?q2b9ttLY9ALwv61AUgJp1DC6vmCu7EwnY2S6y7+/QDx4UV6ZS/vwGbHjdm+c?=
 =?us-ascii?Q?m+DuKk6Ie5/3lYejuFjSMFnxudrJGb1yQejP7ivNvNvsrb9Xy7ujcLMNObcV?=
 =?us-ascii?Q?xRaKsqa3xPcAfdeMKSbL3O+S2Q2ITu2F+R/wAXHw73NhE0BVb213J94fzlNt?=
 =?us-ascii?Q?60EXh2r4HJu1nJjcykcEBgC3Mas+Hl4Y3UxLdYc75wGcIhGuMur8mrkwjj7s?=
 =?us-ascii?Q?u/Ve0aAJWrpNNFlihgQ8UTdZCR1jnGhRFLz1+flmD/aeZGo6r2NUWzhzoQqZ?=
 =?us-ascii?Q?FejvqNHJCluZ/Qs0k1VbZmPybnhZfUY4CHD9RJA42l+XRDUxhIUmBm88ho0Y?=
 =?us-ascii?Q?LzKAE6jARKyl2vLMZVGgQKu5jI7CFk3DTGEGBwxtPPVB+CWOYOVgGNYDf1uC?=
 =?us-ascii?Q?zl/0/i9TC70HK9q76vgP1/lo5u/Bao5q3feIok/p9bM75IPFTms0Kx8G0Cke?=
 =?us-ascii?Q?AdN+vqqsgf1lESO3Nn++KhaTIxIfAhlqSRNWBHa+J+ECfcmC9RB7zyjBjXd/?=
 =?us-ascii?Q?CKFBIzGXBIDk4L/4kZLveTeXAP5pLZK76H9aEUNd8yWAzhOo+rm2QQs+Vb9A?=
 =?us-ascii?Q?iEF7k8e3d91ORfS1Y2NHShGJkHi22M1CRA4qMKl8Akd9uiumkmMGpUsTiwDW?=
 =?us-ascii?Q?XpaV+J0ccZyrFmT8bsALghRQtvEFbpVYHxgGNlYEPY86SSAsO7mAna1EqQEc?=
 =?us-ascii?Q?QjzEusT+rLCBiEtMxOyWzG38wlJMqobNIZundxa85jb9RotM+T3QnMK4qymW?=
 =?us-ascii?Q?aYsAyk2aMX90V1ki1ttk2rP9+y0hQhcXYhVFGZ3lT2sa/b71uRc9oLirWdNB?=
 =?us-ascii?Q?Mg5g9ge9FZifWpXsTMxtbTQERx6RnGEoPKM2Y5/QzYRiOv3TtOc65oZxfhmV?=
 =?us-ascii?Q?w9GvWCkUew=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47151244-e48d-4922-8b2e-08de79f3fc21
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 13:43:14.8981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LEIwcHkEpQplBw10VuGH/6g95XBNOceK2MODZSleL+F5DUmOFGqWZGfnAgc5ohXO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5885
X-Stat-Signature: n4b6o59483nkh3zwxmhtd9cni17gnarr
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: CF08B180018
X-HE-Tag: 1772631800-223938
X-HE-Meta: U2FsdGVkX1/CGlGa3prVzSC7o9SSZhhFg5nwTGUoNwATepBNLFCL/ZAjgWXJEbqXLENSzGBdPvtia/wXPyU1MrnA3OnquAL26362J66mrWdWrCLnaTNFxOGexwbQetVeid2WEmCee5e1AB4oPVtAt3TrH8snkNvtYhkZWOkfPJSGA+amzz4IZGY4RxO/477FVEfbcNHhx+vU6xrznUjzZBdsDmKRz5i5PWPB3LzpJvOlMNQtbJzG/syIj14s+qZ+LWqx0lLGdG5FvRqYXmgF6WEpBuS7iwFSFZA/EKvtKri+kaxihkgaED7QsVavQrWY+Uo7mD653D7+BAJY2+R8ZJSN4IDanSgardBNSogqOyWay6h4sNJBEM3yA1r9hBHARGk71szxWuGtNWOa2IlGeGU50nEJWRW2Z+KZjwJt7cYmsKmOE9WssaSYQHVaYEYeep2aKFXp+nmR4TsQLcQWJWsmGaQcAlVK1XlDnk+WN9/S1/Eg7eWZd6lkv1aOKU2IvonLhwp4wde26ADnJUDiX9j/Z4IpQTuFAmNeAIAnqf5DhfrgB7H+KUZEP8XEkAdEpXNiY8uPfcTgtHb1wFTmx++N4UkHWjrLp/FDREIuM/fS6+sNUjmzUzjvwbTHweknMfXOg+KVG7GQ7hbLk9MkHS1290lgxDf8S4Bcuzwrz4fEThYx5AdsFDXsjSyXadtn5bE3gwTkK8w8s2fZpoSl51gPGqw+LBANNRGjiePnta59T5HBBOyIrNG/Vb5SdB6ezrD9TrVRLUZ8KQa9ZJuqpuK6643/NgHke+g/RFqxVN/BxEwUM7mk1DVppA0pxKttEllXxKxBgmHbKrmu5JwaPOYpM7w6bA2o+q+5+JZ2KiDG+LVZ33qYP1DwgBMKXwqopP88oGRpqAlXg07Y9QEmYSzNTj25ncF+jtQn1o0H1GWzR4ErfjPq8wF64BRP2CNJQshfTEkuTq5gfdZ1Irb
 8p6sdi+u
 bc4yQcGsL58UMhIx72wAv8wLw0cFrkmbMisdwjL4Qs+WsboGGHxN1A+bNbLkeE80y/UudtUWAiBsJkbRUU6KlcoTNPA6aK9KcUH4k85+cU2w5YEWU1H5pGlDhvLvJGRL8rTB3Tl/3XMVx/EuDvkfhXNrxnZe9j/v4VFp09oT1mrWy9+e6horQ3Z9B+0ETPTJQSK15Rhw3B8KXkOWyuMsfal4tCWaAi3SSMxaY7NR4zA/Df7NpIQhyFfbLeAZRCPl1cUo7Tmv0ZKfKhtnbHddI63rABvcPGdONFWYnrYhHZBNPvATI2E2HrYEfL6gv010W/7AUUBEQl1mlf1bVG3LI8Q9Jkhvq0uNUJ1y7ZzHkGhEzVVIYxTB2A5lJfGVnSZadoU2oxpg/Dh2otkTcsYNbmoUC3pY02FDHV0fnnqBLavrGhuNGAnmN0MLjAXXp1/n4vAT+a9wibialoMA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 11:17:08AM +0000, Catalin Marinas wrote:
> > @@ -399,13 +416,35 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
> >  	int i;
> >  
> >  	/*
> > -	 * Gather the access/dirty bits for the contiguous range. If nothing has
> > -	 * changed, its a noop.
> > +	 * Check whether all sub-PTEs in the CONT block already have the
> > +	 * requested access flags, using raw per-PTE values rather than the
> > +	 * gathered ptep_get() view.
> > +	 *
> > +	 * ptep_get() gathers AF/dirty state across the whole CONT block,
> > +	 * which is correct for CPU TLB semantics: with FEAT_HAFDBS the
> > +	 * hardware may set AF/dirty on any sub-PTE and the CPU TLB treats
> > +	 * the gathered result as authoritative for the entire range. But an
> > +	 * SMMU without HTTU (or with HA/HD disabled in CD.TCR) evaluates
> > +	 * each descriptor individually and will keep faulting on the target
> > +	 * sub-PTE if its flags haven't actually been updated. Gathering can
> > +	 * therefore cause false no-ops when only a sibling has been updated:
> > +	 *  - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
> > +	 *  - read faults:  target still lacks PTE_AF
> > +	 *
> > +	 * Per Arm ARM (DDI 0487) D8.7.1, any sub-PTE in a CONT range may
> > +	 * become the effective cached translation, so all entries must have
> > +	 * consistent attributes. Check the full CONT block before returning
> > +	 * no-op, and when any sub-PTE mismatches, proceed to update the whole
> > +	 * range.
> >  	 */
> > -	orig_pte = pte_mknoncont(ptep_get(ptep));
> > -	if (pte_val(orig_pte) == pte_val(entry))
> > +	if (contpte_all_subptes_match_access_flags(ptep, entry))
> >  		return 0;
> 
> Actually, do we need to loop over all the ptes? I think it sufficient to
> only check the one at ptep since it is the one that triggered the
> fault.

With CONT we should not be thinking "the one that triggered the
fault".

The PTE that triggered the fault is the PTE that the HW happened to
load into the TLB, we cannot assume it is the sub PTE we are faulting
at. For instance it could be a sub PTE for a completely unrelated
access at a different VA that got cached.

Again, the requirement here is that a fault on a CONT PTE must fix all
the access flags to be consistent or fail. It cannot resume the fault
and leave the sub PTEs inconsistent as the HW is always allowed to
load the RDONLY one for any access to the CONT.

Jason

