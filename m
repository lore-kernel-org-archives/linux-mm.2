Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14139109C022
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34DF96B0089; Wed, 25 Mar 2026 10:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326016B008C; Wed, 25 Mar 2026 10:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDAB6B0092; Wed, 25 Mar 2026 10:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA546B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:27:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D16391A091B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:27:43 +0000 (UTC)
X-FDA: 84584814006.03.1361C52
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011018.outbound.protection.outlook.com [40.107.130.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id 004CF120015
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:27:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=p4TybNw7;
	dkim=pass header.d=arm.com header.s=selector1 header.b=p4TybNw7;
	spf=pass (imf29.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.18 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Authentication-Results: i=3;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=p4TybNw7;
	dkim=pass header.d=arm.com header.s=selector1 header.b=p4TybNw7;
	spf=pass (imf29.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.18 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774448860; a=rsa-sha256;
	cv=pass;
	b=B318YAElL6XhFOBZwPernS0/0lpi5ec8/6sq3IETTdsrJT9kjvfpevDaP7h3oEY5/nm0zQ
	gprw4srHH0YaAzy04s/0wf+slk2CQ80O4GyVes73uKZnLw4p56J8DwGJae3hEKn3ctrAwV
	N22+YyLGe1s70turYersmqeDQsd6Pp0=
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aXHZXf+ZdIiAdDnmaW/AA/NP16bP+Lzb3wGBMLQTJK8=;
	b=BXrOlZ/z8WdHeD5EkQTsusm2hVbo7eQzSwTONm2MFw3oE2FPJeD3saLXLbBx1P3fB3pGeX
	ieDksvUyy4u23B1Jt50j1gXQS5Chu6hOa2Ui/8MfiDw8P9M7K259lyRhtXE7oyPkSFUWfF
	iVqBM9MK2lf9R+QngeuROi3iXFqq3o4=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SOPsTSMHy8JmWqDBTdNMo0yP2FnzRB7MWssaRMN4o0A9EtY5k/TA75MFfnhx6kWLuAYp535q0BKUsTj3OI+8i5whdMh4uHCvUKEzTP6LR9G8+J6iCgAfrhKP+Yk9jJ51llsEeNcQG4IAwfGsFXHqrNgL2g+WrSRybRakrG8uvOkBSVxVoZb+xZ4jci8bOSz1QBwSTLpwp0PbtfEAuQTzxaTL8FCQyejcvwZvj2jeGf5RzTBTFIv95yCMKeQjsIgkiaJN/LUmsJ4WpZioULSTIcefZ4BL4t7tUazCl9BLTniOQ6SsAn3ppTpY0BR7+20UMocD+5rfd6XLY13z6J0s6A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aXHZXf+ZdIiAdDnmaW/AA/NP16bP+Lzb3wGBMLQTJK8=;
 b=aPf5BjzhAajSGCBHOxRO6DNANUCmALMluK3uJDYiHEIXaiT+qLiwipYsRNlC7m+ZT2lM3iyixK2eIYkDjV6nIHnid7STze0buh1CM0Qm+LR6Mrqe458tT/0dWbmSHPBII+eP/8cEgG4Fgc0EiwAbbHAChLHhgRg0vzko64UBRpIBHo3Xw8X5mC8N3PXwX5j7RInkn1XPdbBCXrNkQlIQqSfxs+5iI47aCGF5TDzwNAC/qJy6JUcWd4shwQ+EARhiZHYUmH+tXaHSCil9XilM42V0RUS7s22BDw+cWe0Lq1j60Ju+wfsh5t5C/4A/yowR4HciA0tT+PLFP44kggOKfg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXHZXf+ZdIiAdDnmaW/AA/NP16bP+Lzb3wGBMLQTJK8=;
 b=p4TybNw7FOz6XYVePglsA/ijLDRNRWdmlWUFcd/Kf5ylU7inUisO/RB1dN62X6VUiy+Fuq5+tQoom9wQKLzVyJFUtTNDZZ8QT+YSlh7/HDtpSf9JLfDHhYiASWHSuzBp+/7xrjsyG7nf3wHS8NRhq2+8N9vmT35th7ivfnKF0S0=
Received: from DUZPR01CA0306.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::16) by PAXPR08MB7351.eurprd08.prod.outlook.com
 (2603:10a6:102:229::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Wed, 25 Mar
 2026 14:27:32 +0000
Received: from DB5PEPF00014B9E.eurprd02.prod.outlook.com
 (2603:10a6:10:4b7:cafe::1b) by DUZPR01CA0306.outlook.office365.com
 (2603:10a6:10:4b7::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Wed,
 25 Mar 2026 14:27:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9E.mail.protection.outlook.com (10.167.8.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Wed, 25 Mar 2026 14:27:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a/htAsAwtKo/Tdf2Kfjy3DEfdNQA4AAYBrFoWNMG4TZ5LddNGrHciDECwhh4hViI+JbTp0XU0J/wCBzz1SJD/XCiglbt5cY4qXl8QmifmC83DOlV4CpTzEDwYD3rsNKRM7mhuxe21s0LJFazRLAHJp0ss0Tx9rCo/NOfSI6hvQNGOrEG2U1gipupcp6BHkoiPSlQAj40B2eEELDpWdBN6dq4VtL9xvsY6hh/3lt4tZx8pM2E9v+MJz/dSeWrc2x3iW041z+vCOX0liM3N4oKd+WhQmFgsxIy1MpATcjlmfvJ0snaJcSVSpAfdN00iUN8VuuNwaq68rcUhmxU/zAATg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aXHZXf+ZdIiAdDnmaW/AA/NP16bP+Lzb3wGBMLQTJK8=;
 b=gHk8p1A80lC6MVzum2C7Iz9SNiT3RN4f97Pojkd70KYT9dnlgZ52xd9JcM6mcbMdWcQC8vEwiTbrJPGWDchSFcHs3FYyDpQF1CGQYoT/jJ9wh+X6H3xoEgVToRfV2lzAAFLL8v1horB79Z0M6UXUQP+hM5vYlABdRhELZ8Cebz6Dh7osYHX4zeWVZW8nqw4MNPTnFjHVTzX+ee7RaUKZjKLVUv9yDACZ07s2k0KGW6yLWYU2uTpxHGCjkYdf+eom7hvStT723mauYJ3vYQQ4Xye4PERYw/7qeu5WAx4p4vnnVCId8p0PKWH6Hehkm10+tYn9A/kGoOdcso7PH9eAGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXHZXf+ZdIiAdDnmaW/AA/NP16bP+Lzb3wGBMLQTJK8=;
 b=p4TybNw7FOz6XYVePglsA/ijLDRNRWdmlWUFcd/Kf5ylU7inUisO/RB1dN62X6VUiy+Fuq5+tQoom9wQKLzVyJFUtTNDZZ8QT+YSlh7/HDtpSf9JLfDHhYiASWHSuzBp+/7xrjsyG7nf3wHS8NRhq2+8N9vmT35th7ivfnKF0S0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by DBAPR08MB5830.eurprd08.prod.outlook.com (2603:10a6:10:1a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 14:26:25 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%4]) with mapi id 15.20.9632.017; Wed, 25 Mar 2026
 14:26:25 +0000
Message-ID: <80dc24d6-944c-46d8-a692-24a9be408a59@arm.com>
Date: Wed, 25 Mar 2026 14:26:24 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v3 2/3] vmalloc: Optimize vfree
To: "David Hildenbrand (Arm)" <david@kernel.org>
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-3-usama.anjum@arm.com>
 <e5d4e527-5e81-4713-a145-c87100973bea@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <e5d4e527-5e81-4713-a145-c87100973bea@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0566.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::16) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|DBAPR08MB5830:EE_|DB5PEPF00014B9E:EE_|PAXPR08MB7351:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e4a2dd4-ed94-4a8c-786a-08de8a7aa5ff
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 TxVF8+mdYQd+1TD+y4ID7SVxfxnVAXhXfpfEG6Y3nG3qcuyOVdPjML67Zi39kEyWqlfjuIzAU9OoMEVqFBMB3JuUrdWunPlIImOw8M0EOHcLPy9Y7iGZKf1GSmfvdwOk+mKzq1r+Sn9XmuUggclXb3c/bdP3y951PDRIh4IBr9n79gIG9pfCs1Ns/fjviTQUc9ysgh4nM0J9pyoGtpEWavAOAWcaZPDRr2P4E3EWRqZegqQ4HHV0O3N+3JQo8ZS3IHfNTzVOPuoW2m7L3YM1PwlK9fPD1CumrogpLBJdbCheqjQy3ap82UlTiNpUOMCc8YVXLgVfirbh+4dB7nsj5jqWew4shcJO8/f94mdJj9svKOApE3EKrexqrd/YZyoim/p9lfHZl531k0uorVcZD+OZ9JRr4hmmPfrkGsrk3fV5UMAaiitvIRHjBwftPmeHadi9b/3a3jTG7IEcpZjUyGDhgGzLpbSF0j2booMoBosrkkhNOI+v36M4VCB00cPbum5YcrnTX8kovgI6h8hPNlqtYK271SWIJpG4HZg6r64DX8RVvs56ppw4gSpxh4kUrcWvAnH5cUKgmldtCH0kVAJzqrldZm6n87ICSdlAL/iLHVzy/S5OpuU3js2NzSOFagicsgFWwh2o4SsQbxat72JZZ1/O4uII57sne9Lr0StnRggEqLsgKk5fcpXso8Ip
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 JXwcJoEgUU2+X3c3H3O56hG8/ueLB+8Sdz8WkYKygC78PpfJPtg7N2TO3Lqg2DJ+rkWZ2AdwkCyLtBVGp2C6PokrAKDEZUyNIyXpT649LzKa0384Rjjz24h9toAzYFHcMHpICbTYuuB+7S56luUfvL6gtzODw7JsUOoC5/tV5b8OSTC9x5Tw6dTAmWOzMH9xgos24YBRyRKk7yfuhkvcm36PivzSPYFqtBF8q/gR1y7wLR+pyxSgPb2EEx1G9Vv9SQWcjYMKqU9FzlLjmsi9DkBEyNqPwsGGss4+IlkxM7XWmsGLOY29a6reFM+82WZ22Hm0sihOt+DpW0ftLZ3tLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5830
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9E.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9789627c-1824-4218-4bbf-08de8a7a7ef3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|7416014|36860700016|82310400026|1800799024|35042699022|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JKhVIL2TMCqVyxpIfBvWH+n7u+xRbxLISKipRtQ8lOeSos2mXLKJ4W2qbw62XOsq/2pZAGDk1WPeRAR170Thv3gDGcjdPDENLsb0b0fJbqbVD5LSNIoz+1bfAFKjEuIHZDHvE2p2KMkJm0Tn8SfjiwfPlsROWxNG7Rb0OkYfc7M+M4tLNDLSZfTKj8OU/Gr2+7SMyiIKCuhwQmgP8RTHTKY+eynQvlv1DStz/ncoKBPobpB3M71hjFTPKKGizrTeuw7ueMJJBhuiT9SZ2hDMdf6Z2VFiPl1HiALq+xNYWEcLVTvyAhGEXXbTau4/3CMQgrTgl4FC0K9iyHZVT3r80aUTZhVL2KqIjm5dfaCVZVAkU0sgxZyh8Yc5GH3Udzi9SNTQSQwolU0RzhRmJtkyJQ0VG2UBE8nUmKJjbKBQ066yydioxGAisb/6PIK6ls7iDlvamFpPqVT+MTDmkgYBT2ofjAVrAy4mmx6d7Y1DLaVQSol+EW8GxHMfmcrziiaxPzycA3LJbrJMgyyM7oyboPZRtgNpb4iDoW0V1PClTYB2zL94vVChvAxZQ83vbQPvdDPhfkA3DMDE8fCz3yEzijwWYa1zCDXTSGTDXdurhuLsZOc6NlyqCIm2TJU2KnMF18CsUREtsNTmPQb13sideooCvrw1W20o+HfJewY4NnvsFPB+ibB7cBTf57uzpky09848k31fr/a3Olx3L4gAFvJ4aohx47PO2oSYJxRAT50=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(7416014)(36860700016)(82310400026)(1800799024)(35042699022)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	T8US9uYWuq/74INXq2IcDrj0WngfeAzDstGEpanUKBoZrBIpWL45CFHa4f31lCq8QW8NUw1OShIt16Z1Ait7nqjsGD7hkahstgDmj/2dUOh24jJG19Ex96AeQDrn3ihhiVfcmHMmeUvEK0WRRk3JeaJZbGCI5dFPpgLMovMFFO8T6lC6Vnn4iNrGwP3OFitc9xTS6S7WAyxk5WSA2SxSjIDx9eXheS45gHWqvI6S0VBO+vBJCHCOUNMQkJX+/Nuh86kDqIxYSlJDTQFzEUZ2S02tJoWMlT/oSDxuiAmwyjABaU3K3fHqtovgrJZvu2SPmF6zRwLsWyT9pKQcC5siVTdjo62vtxVcj5V1c++rYvdk8hih9fTT0JMdnvf2KmJlsVBfkd0OKfr0/aRDRKuhL0zsJ7aUaEVAnUb8i4A0+m9w/gQ1+7flzYSNb5Q4dld0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 14:27:30.7728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4a2dd4-ed94-4a8c-786a-08de8a7aa5ff
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9E.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7351
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 004CF120015
X-Stat-Signature: pqtmej49q1ku9gfzh161y39duk6grhgk
X-Rspam-User: 
X-HE-Tag: 1774448859-779107
X-HE-Meta: U2FsdGVkX19kQQWLrDvmgH1F7onGnfwX7AuG2TtCVQzn/nESXPWZd2qfsX2EzSwkj6ic6VTcZVu+4GFDHLMLXu2gdfAZEKKD1ulS/krcJm4cUJds3AHyMezaCPC7AyZ8xv4w2bQV3WL7ovu5yWNbIV4LE4f95XNiS9lelmSESphUfVrlWod9q3lUh0knm4fyUX3aeRRpCcI+p9FE42a2cCg8S5F4/2L8UNXIDOXWfuD8+hZm2oJnp0OiURCL52Vg9LCdKn/RueaOHp9U5AAIUgh/ULzZBijQvNKW/UYRF2UOvaVG7J6oTtOinP9xVFIKJNZYo3kLQIzgYVWwwPFapeLNWRWu3S/dvE/rVUP5vg1Yl7su2NzdM7t0qJhkdckQcznz/CfjVqfW81gxKd1epy0MtzotAUup6wI9VhXgYOJaeYv52TTn8MWraqTx3QbvgECiVg7nIXw0302+eT9UnIyYh2MCnf+0pYkZASTJn8WFudOo1QL6MutbUe0efMV9u2jE4ssi1WPF+IgxX9lpNgy6YTWzVxJzbt1hpv6l8CtAUdGZTdIMh6o1pkXB99gSttogBfmf2qLZGAcqTzlzq2j5RgDLyMhU0vOEcX0JxZX8OTuqrN+T12eLIYnqQKVq+0NfzqE477msoDhVmX2WBONVw2tRjX/BCvjE2pSCsrxEcSuoow3dAiMI4wUUiFA4tOxi7aji/tEIpQE1ANBlBKqoS4FFfBnI14nJT/laGKOZI/qxJLDPHcq/Kg97zxXuMqo7VWH8w1Bk9RoaGMeqD41iRz04JocVmC4oQm9hxbVvVyD29w3r+DuVjnY/2pmLJyMK/8VylP5DktcN0qm3cvKE87vcFRPvWROK40x0ekom5MQ4NoMoxmy2Z51qhefxBoGqfsazkxqDWwtOmHwlZMTMe1ZzxxaePHiIvvb4LLh5YCjeb6tvTmGJO4TOSe1ZFA3+b6MwGLlEc65AazJ
 N0rQMwJU
 Rnfc7eiX0SS92eHfJs/SJf/RqLJEt3c4inALhTLDHrGg5DmC/85/CVpLtTOIUMge0HnrA6JTKZrea233lDUbxVUrihSEck3hi58L6QxQpcMBPWNr67e66PRfv4Zf/woEyLGXOOLk8gd3/bO4L8+SpG1QUN17UJGsSA59h6zUyGUFLI4tXLuLMOqcHl78/u6Ipzb6j7eNcC/8iEyR3hjumVHuesXjJ1cDurTcPwUHdEidkCEztv0lEtxt1rCEiyKJxsbM5l4JIZR+FBcpJMpOQNR7n4iqRO7rTlkpTti4u4bwVZQe048uG/qkn/2s7ZGbW8rqDhLUMddzMhCxlQ2npKicEPSvPRjvUo0mZ/35I5JOZWHIfbJe0pmm553Z+3N9nvT5pM2onj32EfqVuD+SLX9Qz9q3edTp+8Qtjl/w8LV8nFM9458j8PummsINM2jss8d2y2QzTVJBMddwGyCd1Pf0lCUuUg0h5BKi+IfAYY1v+9X2RZAj4G/UC45KTtut4MKV235QOiCY7SwwD5lyr3OE9RvffdYyf93owTJcg/Ak7sabvRhtRA/U6jj91U2urav6me6BMOpapNZybdpFpBOyPMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/03/2026 10:05 am, David Hildenbrand (Arm) wrote:
> On 3/24/26 14:35, Muhammad Usama Anjum wrote:
>> From: Ryan Roberts <ryan.roberts@arm.com>
>>
>> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
>> must immediately split_page() to order-0 so that it remains compatible
>> with users that want to access the underlying struct page.
>> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
>> allocator") recently made it much more likely for vmalloc to allocate
>> high order pages which are subsequently split to order-0.
>>
>> Unfortunately this had the side effect of causing performance
>> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
>> benchmarks). See Closes: tag. This happens because the high order pages
>> must be gotten from the buddy but then because they are split to
>> order-0, when they are freed they are freed to the order-0 pcp.
>> Previously allocation was for order-0 pages so they were recycled from
>> the pcp.
>>
>> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
>> that it also frees that order-3 page to the order-3 pcp, then the
>> regression could be removed.
>>
>> So let's do exactly that; use the new __free_contig_range() API to
>> batch-free contiguous ranges of pfns. This not only removes the
>> regression, but significantly improves performance of vfree beyond the
>> baseline.
>>
>> A selection of test_vmalloc benchmarks running on arm64 server class
>> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
>> large order pages from buddy allocator") was added in v6.19-rc1 where we
>> see regressions. Then with this change performance is much better. (>0
>> is faster, <0 is slower, (R)/(I) = statistically significant
>> Regression/Improvement):
>>
>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
>> +=================+==========================================================+===================+====================+
>> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
>> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
>> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
>> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
>> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
>> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
>> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
>> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
>> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
>> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
>> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
>> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
>> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
>> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
>> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
>> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
>> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
>> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
>> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>
>> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
>> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v2:
>> - Remove BUG_ON in favour of simple implementation as this has never
>>   been seen to output any bug in the past as well
>> - Move the free loop to separate function, free_pages_bulk()
>> - Update stats, lruvec_stat in separate loop
>>
>> Changes since v1:
>> - Rebase on mm-new
>> - Rerun benchmarks
>>
>> Made-with: Cursor
>> ---
>>  include/linux/gfp.h |  2 ++
>>  mm/page_alloc.c     | 23 +++++++++++++++++++++++
>>  mm/vmalloc.c        | 16 +++++-----------
>>  3 files changed, 30 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index 7c1f9da7c8e56..71f9097ab99a0 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>  				struct page **page_array);
>>  #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
>>  
>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
>> +
>>  unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>>  				unsigned long nr_pages,
>>  				struct page **page_array);
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index eedce9a30eb7e..250cc07e547b8 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5175,6 +5175,29 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>  }
>>  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
>>  
> 
> Can we add some kerneldoc describing call context etc?
Yes, I'll add short kerneldoc here.
> 
>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>> +{
>> +	unsigned long start_pfn = 0, pfn;
>> +	unsigned long i, nr_contig = 0;
>> +
>> +	for (i = 0; i < nr_pages; i++) {
>> +		pfn = page_to_pfn(page_array[i]);
>> +		if (!nr_contig) {
>> +			start_pfn = pfn;
>> +			nr_contig = 1;
>> +		} else if (start_pfn + nr_contig != pfn) {
>> +			__free_contig_range(start_pfn, nr_contig);
>> +			start_pfn = pfn;
>> +			nr_contig = 1;
>> +			cond_resched();
>> +		} else {
>> +			nr_contig++;
>> +		}
>> +	}
> 
> Could we use num_pages_contiguous() here?
> 
> while (nr_pages) {
> 	unsigned long nr_contig_pages = num_pages_contiguous(page_array, nr_pages);
> 
> 	__free_contig_range(pfn_to_page(*page_array), nr_contig_pages);
> 	
> 	nr_pages -= nr_contig;
> 	page_array += nr_contig;
> 	cond_resched();
> }
> 
> Something like that?
__free_contig_range() is already checking for the sections. If
num_pages_contiguous() is called here, it'll cause the duplication
of the section check.

> 
>> +	if (nr_contig)
>> +		__free_contig_range(start_pfn, nr_contig);
>> +}
>> +
>>  /*
>>   * This is the 'heart' of the zoned buddy allocator.
>>   */
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index c607307c657a6..e9b3d6451e48b 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3459,19 +3459,13 @@ void vfree(const void *addr)
>>  
>>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>>  		vm_reset_perms(vm);
>> -	for (i = 0; i < vm->nr_pages; i++) {
>> -		struct page *page = vm->pages[i];
>>  
>> -		BUG_ON(!page);
>> -		/*
>> -		 * High-order allocs for huge vmallocs are split, so
>> -		 * can be freed as an array of order-0 allocations
>> -		 */
>> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
>> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);
>> -		__free_page(page);
>> -		cond_resched();
>> +	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
>> +		for (i = 0; i < vm->nr_pages; i++)
>> +			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
>>  	}
>> +	free_pages_bulk(vm->pages, vm->nr_pages);
>> +
>>  	kvfree(vm->pages);
>>  	kfree(vm);
>>  }
> 
> 


