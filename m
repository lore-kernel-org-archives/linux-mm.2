Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 346AEF3382A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 818B56B0005; Tue, 17 Mar 2026 05:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C92A6B0088; Tue, 17 Mar 2026 05:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A866B0089; Tue, 17 Mar 2026 05:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AC556B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:37:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC7771605AA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:37:47 +0000 (UTC)
X-FDA: 84555052974.28.7A944FB
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011035.outbound.protection.outlook.com [40.107.130.35])
	by imf12.hostedemail.com (Postfix) with ESMTP id 141D64000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:37:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CL4tKFT7;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CL4tKFT7;
	spf=pass (imf12.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.35 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+/i0iHvXd563yt2exmsCdrr/cblbOQyANCYps3eMgE=;
	b=BoO8GupIaxrfq9Gv8Pa7rWp+2y2kPNKSGWssVFGypCrGl3BzEYxeK+tBY4moGQ9I5WHewX
	r595flrCfD05BSe09wwdlqdefP+vT8krIOeFchNAFMLqdszh5YsmDnrk1U6TJYffMezYiO
	/zbzbQEgiz1a1aoxCd+e82OmRFQMCvo=
ARC-Authentication-Results: i=3;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CL4tKFT7;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CL4tKFT7;
	spf=pass (imf12.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.35 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1773740264; a=rsa-sha256;
	cv=pass;
	b=GmXl+NHmPkn3UfFSNSSvCGhbh/KOPGpP7fdENDcV3NacPBXxWAMwRaGHd1cT0LyUcucpja
	MqWB94htCX8jQ0E7OQAEeKwCS5mppPlGdD4/+BuJVeZRzC2tXuaN4eUB5ATJfJ3pelO2i+
	cI+FCzS7ZRDPMKtstZNP55ZvhqxAmRQ=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=MySa4GI5m0bCwMuCryYdfPX09LngEvpr5HTYgF+Ig5yIqHJkKMMafZesEYBxrZHFZrGL6FGYKLl7W4aW4cTci+OcjlMWbkZo7xuxslPIheJIPnPNkk8BkJSpL/XxHjiWeyaEqVKvb+UCzYkC4A5I4SoDK4ILAnVNVy/R6opDZWmvrTMZ43ElbpGl0skCBF3vi7BKHskAva7hVIMjL/nwV1M1c0TxTvrl/nbAklTUm4pQz2P55qoiN+0pCRSp+Umgp4FA/mQV5WCympdoUvaYjMB5BseBLFShYm8yd9ENSVxLGBgBxOLI0ZCL84Yq6LVtw3+ovZv/n5GP8oNSvzdXSw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+/i0iHvXd563yt2exmsCdrr/cblbOQyANCYps3eMgE=;
 b=Jjpqyfi+LayLBVyBfuwWTKCEq5VmAWSh7stSfwqO4LFV9NIv/wya5byWQ7UlqVzMhMJEBqm2p7CyvOGCfDmYpB6jEd8aBL7ddstOp3e/G0O70W3qcE5bsFdf1ciKGFYZFS801SJY75O9UgCf7QzGMLFoSnELoc8aJiAmC7wEJ7H6fxiqLFyj9CLbyoMLGpoXvbvinkrbOMOtU0r8pA5m48RgwpoBEcN+eW69L+4Pwm1DPAooJ/cueej327bjbzt7j09jIfnIcQGynCAWbrUaIXCrdqzMw+i/Mzqb5Mr/o4rLkCcULBSfSy0cW3IvE+kD9p4wolEOqvphs73doiJMtA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+/i0iHvXd563yt2exmsCdrr/cblbOQyANCYps3eMgE=;
 b=CL4tKFT75lxJiueb6tv7tJKKwsTlIh5M1bX4egtA+SUufQfRKX29oWkmH5YIFwALjMleDp5qp6IR/rv2eQIwM2XXR72GOvZ85B1QeTTxR9QAGxbs9oESwe9LrxlOU/LPdxg+aIwZIG7hrXVdB6m8QRY0oHkUzkxvuF6b7ncCMnE=
Received: from PAZP264CA0142.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1f8::8)
 by PAWPR08MB9495.eurprd08.prod.outlook.com (2603:10a6:102:2eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 09:37:37 +0000
Received: from AM4PEPF00025F95.EURPRD83.prod.outlook.com
 (2603:10a6:102:1f8:cafe::ef) by PAZP264CA0142.outlook.office365.com
 (2603:10a6:102:1f8::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 09:37:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F95.mail.protection.outlook.com (10.167.16.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.0 via
 Frontend Transport; Tue, 17 Mar 2026 09:37:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z49iaRJNSbC1ApELenOjenXHgEgFXXQ7eJDUlxCaWsSNDEC3jA1YIRdpB1X2soe8MMRtYvFapCpF8cb/JAQ1Agt0law5NJHa6BNikDZihRQ24/qYyWlSIwcIrd3Jazj4bBEq1lWisaJEfqkP/6e0mZqrdfxMwD3rG1KNfoVkwe68T77zy9i09Tyxp/mwjo2qK/c+KvwtB34G8WhlfZ3/gHIhq2uat1ThGD+QVBziv8QKdyiaSFVLo5be6KWRvFBrz40SGw7c+Womn6kvCWUMnLO+7S0a4D5c0HuRMKN2WgKHjM5ua7Fpnsmc0o0AXrSq55ns5CWCUxt1HCSTXJwSbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+/i0iHvXd563yt2exmsCdrr/cblbOQyANCYps3eMgE=;
 b=p0BwBITgMvLcn78CqsykS1r2w+AdIlsa0ZrTK8LMoNXZoR4/LtgcmzRlDeUHJXEvvVlKm8YpZUG0nNmShPsZEBa1JBmk2C5rHZ3oHCpszoC3lPQwiS5tlpCBk2jUNkpU5a94xqeYQ34XmPl99chgvNUKO6b46CIbqL81quiO/URab3Dg5xQ6xiYb4PB4Jz1+yPgGYtGj41LUHfwn+8zxrzTThf+zSwEUpJPBCBobpJufhkatw32DZth0cUWJITYnSv2tey48WiPKOopbX6Ur+cbC4giaNwFTf8ze4FkjPAa8gXVRQRNppFd9TPtMokcdK/It6wlHR0oSUF5zWqy2/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+/i0iHvXd563yt2exmsCdrr/cblbOQyANCYps3eMgE=;
 b=CL4tKFT75lxJiueb6tv7tJKKwsTlIh5M1bX4egtA+SUufQfRKX29oWkmH5YIFwALjMleDp5qp6IR/rv2eQIwM2XXR72GOvZ85B1QeTTxR9QAGxbs9oESwe9LrxlOU/LPdxg+aIwZIG7hrXVdB6m8QRY0oHkUzkxvuF6b7ncCMnE=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by GV2PR08MB11692.eurprd08.prod.outlook.com (2603:10a6:150:300::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 09:36:29 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.20.9678.023; Tue, 17 Mar 2026
 09:36:28 +0000
Message-ID: <0174cb12-f504-430a-8909-9361f5217bb9@arm.com>
Date: Tue, 17 Mar 2026 09:36:26 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com
Subject: Re: [PATCH v2 2/3] vmalloc: Optimize vfree
To: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-3-usama.anjum@arm.com>
 <e59ab258-7331-412c-b490-657e32ec1fe0@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <e59ab258-7331-412c-b490-657e32ec1fe0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0368.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::13) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|GV2PR08MB11692:EE_|AM4PEPF00025F95:EE_|PAWPR08MB9495:EE_
X-MS-Office365-Filtering-Correlation-Id: 16355e4d-95c2-4185-964c-08de8408d144
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 IyQYoJAyyDKb5N1XjC0wvT/J1xigz6Rzv5TwMPSKwbuaeKvPNDNpVzbbu7wKIGFe3SYkb9Jg3aHqO9CSx9HShayUV2LEL1l7lejy+mqLUt1qcFWQVUsbffuABDnEPKMso1vGl8Qxl1fwAcMxnvZU+0z7jgbCE16s+SNzcLrfs133x0BbI4Z1hxtIGpPQ+/VY62qx4hNLczoMrOjxHt2K0j7lV7tZolmoMO2jxFC6rnyUN1br85zz2jhg7ux8fOdMWrCT5/79rtCteQYxi2XXz2ddIiZMPmvAujDvXgvXcicLVxyn3nCBE4y9NW2te4bkjbuHpwfXFpet6Zwniu9WTgi/9AymMwKcjgcOQbFzgnRCKcORuGO87hx1i6gURlEhiAWqRiAw6oyUIBhJNPmHzemEisyAIhhAszRQyWcqXcnsigWE+YuH/byHkOgUfwn1e/nHuUMudBTQBnHrEPLADuHhoSHPbh0dsOuuJrGVLndvHZ62++A3FuCq6fCiXB5HxsiKVxpbKRMVDU9jqe0BMGR4MoXRMDC7/Wv7+2d+1r1t7RTp+uvnUzG/Z8P1j6+MxsJcv1d2pCLy1msLwui0Z67/cKGjF0iR76UyxfB7avKCFFeJiF+c3IMaDjcsRDr11uE3D6eAB8XWGVcor9+4Z8pmtmF3C2bSISsltzq6cdgWV5Y4U0Eor2iPaTNiRjtvGksSwFhADtsYOkZK4fbYmKZ3KAe3pW6PNNWfqNxTywFaOxlPw365G/y8jC+goeLW6rjHl7QbXKIR4IyuCuc7d2upCyfl3ljvUERlyWilIIM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 rp+n4yN9YmvT0nu93/9vZB1CW2Qbf3MKOIx2yaSQchxdsXvV62GyGysC/xVyq3+1IUhRmjKOPB+2KW5Qy75oaaFU3EI/BvVWy0aG8hN5yNltBMhf7qRCSirSk8ZkYMaPSiqV8Pn6uk2QHCIzP3D7Vv8rffst3jDg5kYlPdSgjDX4L7c4rhXH0vMOJcCDOxALS6ZMgrC0nSp+gbLE/63EdH0rF4DuuSQgdOSADUnXu6aYvAlqodetmfyLfy0d97qDTzsp+I4+/9ylG2/pCGDxHOEvOv3z2AOXNemK0A1D/s+Ukuf3ap83WvlTcvHfRpyhL3H7y9L1DOMfxRWAwx101A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11692
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F95.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a13510fb-50df-4443-c226-08de8408aa25
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|35042699022|82310400026|1800799024|36860700016|14060799003|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	uI781ZrYIThbqksSWeZtH/AZfBiPKMzOEohgk5DfkSxskm4m55Ok5ttwzBRxUJd0/nZkYPdh/HtKCw2oQfHVjJ0X2Ab74Jtb2EUZ3mGTu599fi4KzzqyKC6D4RB6+KnY73MUrCAxJvwlNzKBitc0G147E+vvzoP+fTY3+5ZnP/suTNM7cXNGmTOeENuxmADrOo1u+wwIeLq3/7TBTdFKKvvSoOLs/VNqcvrKPV8LJvc67UJXjAXOelK4o0BUWWbz5Ph6YOnZGcu6FqgTzENObBT92EXsI/pR/qChev6X797unlKEl2psEWISRB1c9TffLdiIl5a0Q6AaXVBqkcddV02nf/H7pmG/Z15Q/i55/6OovLyreacAOSzvMyeF4N6VFF7jixC3wvp2XYfYzhsxCYu9L8yydLfpKpVmkCDA22TL6Aw6eDqlHptaeNB6pfM5w4mzYjfu1dzVNRAkcG9P37QWxeml+rNj5B1LxIr6f7DUX+kJVpz6GlbFPj2TSejO04hDtotAQC13UkfNwVGMKVGu49Mbo6Ofu+bO3ov7F4HD+tQ6HE/iDjQA6s7Y4AjeV6tSbQgrpDSQLFMWKFCNBtogZU3IrMCNV81uWD9QWFRuo1W+DskHSQo7kfBNBAwfmgw7OvMEkBNA3nEPauLdK193Gm465zsLgC8KP76LgSMwTssG3yPjjjfZwz6r0GdSkn56bt9m7/OXuNM4HKngDx+xf/CojQx2QvCVxn6VeJvvUOJ28CmEUEzNjrzvtKZmZGRNRsmsA6014S4bOgs4BjT0eW8NwCLHuOsrbdC0ouv8veBJ740qFRHW86qJRnNpgrRxdSxnzIl+I9VV1YlyEA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(35042699022)(82310400026)(1800799024)(36860700016)(14060799003)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gt2AaN8/CPseWepbfSJoxarmpi6fuD9M1ZnKY58BVTInoNIKk1pkRItn+KuJ8Kl7L8wdLxUKJGcJer7eY2PbvJmKUXI6yJqx1SoM3srnC5pOMZf/uztqaN+2G0q9AxZjRYPFoDQ5PTiQ66GY/bDotkyPcTnf/I5lP5G/8XxJ0AKIftr6PWDvZpwnrdoJcUBOpomacOm1Sna1I5eGMmC1OGxb0fNQR83lKpUYbJX6b/JdIydS54Aa/RNikG+QXBp4Ltu1NcZFfVkz6dZexJREQTFvzu5LaAmRioAMXV6nBCuDS6bDkvMDe9KsFynLMPUZjawGP/gniYotKYChOprFAYerpaa6j9PiaAFawLNUFMT89e10QMLa15T1GI9fFMZM85qYYrgE/RXvv0zjA3ZeXyltvqsKIGmJA3TbLD+R/84PRnP6qsDSqmGAV+FuBFcI
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 09:37:33.7603
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16355e4d-95c2-4185-964c-08de8408d144
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F95.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9495
X-Rspamd-Queue-Id: 141D64000F
X-Stat-Signature: h4cxjqp7razmr9ehqgc9j4hzes8npx99
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773740263-361511
X-HE-Meta: U2FsdGVkX1/OC4KokZfErvCQe1/UFROFnHCqLne0sqAJrxOZggr2aRlp6nbfcgSF8VxkWNiQKtS2OTgpPsk5J6z0Zd537Engw0n70sIvWny+ksyMN7p/RMPVM4qRlw390JmB2GaL9OtssnTyKBVOJbm7/AEmQT1sOah9Zs10alKdy9S4h94nDzpKTNoBYEIoBeIpPjtXqhPaZu3uPUbnBJ3tSLTrcgsLuSS8jIudSSm0kTANmqWrFHvbecs5apY47bkvEQPNJbJuOsSaNFaHkTlut2mKfEoAGbJ5LYHRWb6yN7eNueov6GUgvttNrSsgRSdYx8NTYdcXuNcML1meNrG69Hm5YBu2wlT555doKOQiF/PunXSLSC73G29mzaBa3OaZw1pohGrFyCd+FA3W8+M7nOcG6HI15qDkYbk1rTQpY7ltD4susKDPYikU72XjPqWfgq2Jwy98ddsLPN3V8Gg60IfU0CtGWKtkNCBFmvahNCaitP5HWMw3DfXFVZ7Cell8PrK61ddGou3Bff5zliOslNtuHXuJdnCqUwCwf2ytUYsXLqkCdNu/LL48vuYdZjkqPLf69o5AdVUyOiBIpdyxpSCkSmOyMTE0neEIKYEInS/HXpY4kt3uXac61lI2yGw/qvRVgQvpI0r0wdAJIsZvvV/aGUeSTEkcvx6bAkIXd/Q6r5NMHklkvity6jTBhKmZByw8G0oTGBxjYcAWb8pJyaJU8oVvaa9v7nbr5BnPnoWbStLe3XsvJqgENRGW1uvzlvMOwJydfSFLoQpMPaRistSXSyoSxDh5lOOXbsuk57l1IyDI2tdP9qYV3LSAMQGp7Cp4xS4cYoH1clDknEtdOcLHV4LzK9Qd1Y3+Sk8y5ZrDJ+7UGm/JQFc4A3zwxOeaZfekClr9t9cGSlHFgYZOsr2ZAF58WUrZDL3s5FUkT0COMN2E7Nl7cqo6NWxl6OKRaYrMhh9kTAyYIO9
 7Dmmnh4U
 0U2N1pqvJBt23nVc/uZ5FIDF67g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/03/2026 3:49 pm, Vlastimil Babka wrote:
> On 3/16/26 12:31, Muhammad Usama Anjum wrote:
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
>> Changes since v1:
>> - Rebase on mm-new
>> - Rerun benchmarks
>> ---
>>  mm/vmalloc.c | 34 +++++++++++++++++++++++++---------
>>  1 file changed, 25 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index c607307c657a6..8b935395fb068 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3459,18 +3459,34 @@ void vfree(const void *addr)
>>  
>>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>>  		vm_reset_perms(vm);
>> -	for (i = 0; i < vm->nr_pages; i++) {
>> -		struct page *page = vm->pages[i];
>> +
>> +	if (vm->nr_pages) {
>> +		bool account = !(vm->flags & VM_MAP_PUT_PAGES);
>> +		unsigned long start_pfn, pfn;
>> +		struct page *page = vm->pages[0];
>> +		int nr = 1;
>>  
>>  		BUG_ON(!page);
>> -		/*
>> -		 * High-order allocs for huge vmallocs are split, so
>> -		 * can be freed as an array of order-0 allocations
>> -		 */
>> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
>> +		start_pfn = page_to_pfn(page);
>> +		if (account)
>>  			mod_lruvec_page_state(page, NR_VMALLOC, -1);
>> -		__free_page(page);
>> -		cond_resched();
>> +
>> +		for (i = 1; i < vm->nr_pages; i++) {
>> +			page = vm->pages[i];
>> +			BUG_ON(!page);
> 
> We shouldn't be adding BUG_ON()'s. Rather demote also the pre-existing one
> to VM_WARN_ON_ONCE() and skip gracefully.
Sure, I'll replace it with WARN_ON_ONE() instead which returns the condition
result as well for easier skip logic.

> 
>> +			if (account)
>> +				mod_lruvec_page_state(page, NR_VMALLOC, -1);
> 
> I think we should be able to batch this too to use "nr"?
Yes, I'll update in the next version.

> 
>> +			pfn = page_to_pfn(page);
>> +			if (start_pfn + nr == pfn) {
>> +				nr++;
>> +				continue;
>> +			}
>> +			__free_contig_range(start_pfn, nr);
>> +			start_pfn = pfn;
>> +			nr = 1;
>> +			cond_resched();> +		}
>> +		__free_contig_range(start_pfn, nr);
>>  	}
>>  	kvfree(vm->pages);
>>  	kfree(vm);
> 


