Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F569109B470
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 13:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978E56B0095; Tue, 31 Mar 2026 09:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9509C6B0096; Tue, 31 Mar 2026 09:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F8A6B0098; Tue, 31 Mar 2026 09:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72A446B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:53:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 289DE8959E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:53:35 +0000 (UTC)
X-FDA: 84606500790.24.77008B0
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013066.outbound.protection.outlook.com [40.107.162.66])
	by imf08.hostedemail.com (Postfix) with ESMTP id 58E7C16000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:53:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=BVfVBaIR;
	dkim=pass header.d=arm.com header.s=selector1 header.b=BVfVBaIR;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf08.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.66 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774965211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeB47XU79pdpnc9/PeYz3ejwkjvCuQ086xN6ItOBo18=;
	b=iqMX2Skl9zgtvWJwsa9qxZl+LsgfLqnVlLZABzV84iiioITULA1KfCASPukCC66j7RJMjY
	tMrDRuEWmzLbkOk17uf7kaa0ppDCRbCVSbxQyxRaQ/uLhbJDxxsBsbah1DhltAC9TQZ2LZ
	Uma49KALqgr5qi9kT2kz526VD3rGk4M=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774965211; a=rsa-sha256;
	cv=pass;
	b=26bnzD9jOr/tpIY2HQCGFLq5vxjr0ihxfC3gLQr5qKRXXrdiJgvdQ1QYjaRyW6Gjj/pNg4
	cFSSTIT8hlvmRoMslBtWsnJpQlX9UlX0q338ZLLoJifgEFV1gDAEFEAVqW0CSA+dI72T08
	XSRIAA8TqgqP79fr/Aq4lj8abCNMS0M=
ARC-Authentication-Results: i=3;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=BVfVBaIR;
	dkim=pass header.d=arm.com header.s=selector1 header.b=BVfVBaIR;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf08.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.66 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=d8mm3uuiRaglCOB5WjP2GvcduWWbGmk+dTy+ypVzDtQeuR/MwICEy9AT9fvp4xHKj7m4u34TzZVBEHxekS2LDM7950vrt5bp4uTnk91ArgfFGCwkHltrAwRCGTXdRDtyGfvh6TjL2kpDo5YvSQ1FdmTjAP7uCkgBddgxn/VWLO1IErZEQHNOQSRZJwxdeumGhwNcusn2Z+5ou57uC/DxNXZiEqhX3/AA+K3PRBa1HdfQgKYOmgBkbGBPg18dRKvog4KaWTom1EU4miJMQdbsCUX+geOrGqigpFq/A00sslbo5f3Hs2uO2rPBbvUPrmoctcaX1/xQVKKMWZa5JtnE+w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeB47XU79pdpnc9/PeYz3ejwkjvCuQ086xN6ItOBo18=;
 b=drMzDOZ7bR2IMsqBVzH1QcGHK+V4h8/1X4jtfhNLviFDs5On3PsnpzMabP+fFGnQ2kVe57fTpJiWl+amP5hBTw1+stDAHzVY9PPpGazKWIsGLyp7vBGs4N6RMzd3PIBEY6dO+245IYMnjV3P1dAJMkiGl38VcmY2Upz6NXC9tAZFy2GtSedkqQQ/Flqy7D9WVj/LiR0Jivgx/FjtVyO8FYx6FVLy4nxgC5t6VAnb7woms638oBMxD7CqJZF4MgXFbirZQceFacMzW/B/MvMR6G84JF0RqOhbdzGDHUmeYj77n8YlrBLVNNNdemljNV8CQINMovlcbF0dll1T/HohqQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeB47XU79pdpnc9/PeYz3ejwkjvCuQ086xN6ItOBo18=;
 b=BVfVBaIRzbKa1cqRqMQwzWq52LzD+iZ/y1aeAkRJVz4d64i2rg+8lfuFDYNT/bvy2T7xbIKXVDmvp+rxlgLOnr/jtDZxmudFVFnsn9rs8fDa06tqEVbboWCnEay1e/25utxY1f7recvV9Gqukg987gFgKcjNSbirFEl9Bthf6sc=
Received: from DU2PR04CA0160.eurprd04.prod.outlook.com (2603:10a6:10:2b0::15)
 by DB4PR08MB10343.eurprd08.prod.outlook.com (2603:10a6:10:3fd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 13:53:24 +0000
Received: from DU2PEPF00028D13.eurprd03.prod.outlook.com
 (2603:10a6:10:2b0:cafe::1b) by DU2PR04CA0160.outlook.office365.com
 (2603:10a6:10:2b0::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Tue,
 31 Mar 2026 13:53:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D13.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Tue, 31 Mar 2026 13:53:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+cqzgk650PBdmz48IkYrtCyOgVgdvcxjPig6jXdGaBT+99pHCJ9wJYbnjOlGRWJ9wCcSxtwzStfnP/YkWvFNiEfucoQIC42FZ3SlQMbSDE3ZQPkeNqrrQ9+Wb8a+0X2SFVD0yvP0fQVYVM54rdfs2t9UYwHEga912mCS292RDdxaIXgS7Zwwm4Sy52jfPHxnnZyhkWV3WGUdU5j6QgnxWRZYrTjLTibq2ZeOi8GSZtkY8zJ/3X4Y8IXH8C5uPTwFgidK+2ofPnnF90DrizIjNR17vpLO6pFERN1mZ37czcc1HMMLp9XFe/N3EwP0GP6Ky6UOR6hgOvXa2OVUqEfeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeB47XU79pdpnc9/PeYz3ejwkjvCuQ086xN6ItOBo18=;
 b=FkVyetQ+zHf8WVS6N3Bf+7HtGkW9uaRDpDpc+f7CZZBSmoNkjSV8ZmnJgZUKi/2JjJyPbpJkZhROyi9sC8KfezT1FW6jKQU+rP3Di34sYksLgL4x8aAoGYihgae71PCbuWn8nTHqJLFRbRNi0oUWlp6R6ilX5mWBg+K7qh6fWFSMKv4Nhs6m4eTO/8c/r33VgC39mz1CVrKEZIFh3zE8OI4W0Omw4BhSJ9ovjEx7rv9XkXDWuM0X8k2dkzp0ANF6f39U0Aq1HzQY8ED5f9OGzGvwDDN5qdQoK4rCrv/Aq3eThkoqM1n/Y0ycxSUDvlgwK2YGyvULeAUXMRSnsE8DOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeB47XU79pdpnc9/PeYz3ejwkjvCuQ086xN6ItOBo18=;
 b=BVfVBaIRzbKa1cqRqMQwzWq52LzD+iZ/y1aeAkRJVz4d64i2rg+8lfuFDYNT/bvy2T7xbIKXVDmvp+rxlgLOnr/jtDZxmudFVFnsn9rs8fDa06tqEVbboWCnEay1e/25utxY1f7recvV9Gqukg987gFgKcjNSbirFEl9Bthf6sc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by PAXPR08MB6718.eurprd08.prod.outlook.com (2603:10a6:102:134::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 13:52:21 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%4]) with mapi id 15.20.9745.019; Tue, 31 Mar 2026
 13:52:21 +0000
Message-ID: <6e2c9ff4-5c2f-4741-80ad-9ca2147c9689@arm.com>
Date: Tue, 31 Mar 2026 14:52:19 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com
Subject: Re: [PATCH v4 1/3] mm/page_alloc: Optimize free_contig_range()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-2-usama.anjum@arm.com>
 <8b3eae05-046a-4413-ae56-f70e1b1dfc83@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <8b3eae05-046a-4413-ae56-f70e1b1dfc83@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0167.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::12) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|PAXPR08MB6718:EE_|DU2PEPF00028D13:EE_|DB4PR08MB10343:EE_
X-MS-Office365-Filtering-Correlation-Id: 35a9ba70-a3ac-4bcb-a2bc-08de8f2ce0a2
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 WnTCmYquqOvBDTFC6uD6d31XgpiWbAUwu/OFrKHGj13X+SZIbUiwz0Lhj8X2zR1jfcS/IMgdUgRJtHIDtZte2wpk06egN5Rc99UqKG3jihqha5S0FbhceZ+mgKWvPKQEWu8fj+qzjoDj0T3xzo58aFD2DyTWz9iG+ewx7AtW2VaQcTMlwaqGMHK8TH29numA0JurVT5BfENaCvcjCA44a9rM8Y1uCHsSj3vcGM/SmPH8UXY9bIYa/rOVpccBEl7n9EYgMpkx0CMDjhplHP0qWH2vXQMFbqidp8C3jFse+ddivzWjJnfW9AUCDhQBtykTCbmR+pNH3MX3SJzYzD/3WXMRvIY11Z8Y40zUl5DlqC3aPJ4Mn00CRIjOZEGBB18kLWKExFTvC/78c8plvs7/oEfAPYvpWMcoixourAx+x6euAGADu8YKZE6wAHkOCvcUG5muuTFkYPJ+XQm4/YtuENkY9ZURMbR+r+mbamtaHCIq7ohve3ojNa5nRy+WzERpvK0Z4bFWToHSvFZsu3vmecpjyeOg8Cu4uCKEh0F12wEe+RPWj9+isylFNXh1Jgkoj7SMmwUR4Mwyk9pUJmrj16X5vQgwAuK83t8TTexEDGhgy9GGTkKHVxYKJHssKGd6P2eP7Fclx19ZTjpIVTlL6KSo5BCRxEabluIIwwSA3lg8HjsyKfBAL+GkehpJ9++ikw8gHspu16tIfCpTWxyNxF780VapUapf1TrzXCd55Vzgg10R75u5k1bhqB2CfYzlLPOcxYwxL3ldCqFNNw4h9A==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 sr5QJC6ZqgkTSFI+3yQCdWIqi1vVrSpERC3gCabB2YT/egbn8OmNkaJLUXI5oPzp98R3YpWRR9eGPKXoeMXfvEBdAHSlRbpcDAWMt4WXwCyOHq5sueduYTAKfOzPQu+zJz9hVfhvHRBPe+ABRxQIWGz5Nbjd6KHEJvQiiUWKC+RC2d1xahdOLE4VONCSyJ864QQ39onf/A071h/4KqdmLnUHs3/sdSidPiXjFPUm1IsVs62F+JXWFQFhnFO/mYEw5i4lFcsdHUw7JMVJQyaVaXRs8Lbtpwfp+lrpldgMpwMEWk1UqwJHaClJ5nIYyYhfBoMVwJhFeoS34TRy48R2Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6718
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D13.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b31be0de-352f-4737-292a-08de8f2cbab2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|35042699022|14060799003|36860700016|7416014|376014|22082099003|18002099003|56012099003|921020;
X-Microsoft-Antispam-Message-Info:
	nhtMeQhNizmPFOryxcxFl1X+Er637NDF7Icn4G34T+X52jLYZOIYvFSwFqOCDFxxfYMBmLxPW8WYV3BDpqCMh6OdKXw2GZ+aoUJ0JgFw1oJElxs6oGjcWjc/d+G5SrEhNyeEHshj+jpLz3vhNzZupI0/B6DAeZ7Cdm3e0SfT4nYmur61+/fns+tIV6rqnips7GnLAZOYsg/VKb2OWFHqsHuH0bjFDjtvgHXpYAzbS3El2G0OhE9UdXKfZ720nwIKWUQPD+QGd0nwh6zXgq1fr02U8L0nxs1Nyvw4QtEGVlMrflwcx9fvaSrWt0ZkT8Iot2hnKDtwQr9ICWHW7yTECj0eN+H16eAvXBb5p7o5PU19Jveq+I+pZ1Yg97z2CK80il63YHuGb5J12Xu/CSpy1RV+SXa1bPRvLS86eewbOX9AU6w1AHsR61HbJXpv9FZ38qwEMg9EvEvvTFk/9af3zlJx1bCKj5CqgocJMjipw9y6cXmZccD/EZWq9jGs2sB8cytCynSxO1XifiqQSoD5+mgSX7Ret+1dkNR+94pfybUzqW2zv2ue0DP97Xb7LNjxtWJlGFbfFDZ3hXmIfPQtRov3pzMRmMPE+MVv1agpi5zm5FqQ9yILhMLTWFjxeMnPeWyD4eBqtv9c9X5OmJinIEn4AuxfOrPb/LBKvdht+VsDwM+vu9A90NOWTqJciIDMB8bYIgtmNEDm1LpEkr1uRGiCrh94V7Wvz3FWxSmDO0Gi+RHcnL7HwsdLBKt57ux2f0gjWTH3uTE7p3EWM8uNCQ9Eoac1bgMYPFSE+YmCAVCeNOl4Vph6tBNiDWeg2nDe
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(35042699022)(14060799003)(36860700016)(7416014)(376014)(22082099003)(18002099003)(56012099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SRy17DoTzeQhc6cw6PKewWHYxFrDYyH2qFSLZbiDmXMZ62pWYUxjRMLd5Bwnpfj+K9yQZgwJzzcgjdurQz934EZ+M95HN8HCAmgcIdH7YDPt9w1KCXk4oI6YDxLrkDsZP/HwYnue5HC8u3wsOTB67QuLkRZjgm/ztlnIEA8hHaFU5XqCihnkpYULY3t+DAWZLbd3zZ1GjIHWEqewhCrn69fNubKiJE56RVYMED00cSNUf0Ncdp3GpGroPaXvYJ9gugsKX/A0KxNoUgdCQZL+6Cu+8MytAxarrY8QuT1zud/2YBlmPBt224pt5nYjyBcPnCzvBxosfKdQiuhrDOEC6Lu2Z1MI4pBHVp9svGhl0WgC8jqYpSx/blNTXtjL8a1fy2czwTQjp98ZfeNRwLl/3hOmfJV3VmOaaaDJyB1L+j1Nok76LwXN18uQ3KPWkn8q
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 13:53:24.2287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a9ba70-a3ac-4bcb-a2bc-08de8f2ce0a2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D13.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB10343
X-Rspamd-Queue-Id: 58E7C16000A
X-Stat-Signature: kkwkd3rdzx6kpna7m4wie36rw3e6g1w4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774965211-757422
X-HE-Meta: U2FsdGVkX1//5N7Y/BKet1Bi90GGpUHVGybI0MwzPxB8kNL6pBEkqhNWHf+9ThOBKvW7syb+pHk4QiNeATuJCo5G1l9jm0dnpsZifb2zv3n5Len5bVb1GwZXqCqwb1KzV+hMx867DCr+w4ZIMvrb//5KKOOQIxmQ/HvnWid4tMpH/ZIbvPV91xXllOdtyW/HvOpxLEuuMD0YGShOSc1RbBp2v6MJ5OYnn5cUf/qTJmyHlS91t6LAF+gQXjLaTd9TgrxDy1f75mFIPxMSMfaWoSbzTmmEyXNQaZYYyXrmBqG8iImUGd6NRlR7zLGw3L7rptn6hdFVA/B5i8iNmotXtyuc2uI0Vx5emavejL1+opU7MKPRJLuO3kh6B/YpJWWvkFC4bUX7xcl1sCo6wsDvbz9rthzddPQv+2WQunrSpasXNwln04L677NZ+yds4AqIKcp2sCe7vLMS09lHLxrvI5nkyJv0K9DtSebd06j/psKC7Ok1H/JolgR4tfdJJFWuM7B+BDalJrufcLrTuoT9BMmIo1e6Fhx9PyNDxTPJiJ62VMuOwQhuigTqZiCL78rf8ep+rcGcCvjOObR7q2ld7WhBupxuwzNXZMEKRBJdz0BAsMiO7pkTsGujpQ5bezkTJqpHQ3lL+0ghRlQmOEWVo1qd0a0OrymrZ+E5tNtlrqsvsuqHUaxmqMEG4A4ipUw7pCkeRklUWOoFRh+FmravHyDCwtcS/0+Obo+kWnV4i8YCP/40bV02gnSL4xVAmfIWUcJuklTA7U2BtAVi7G8OFWWfQ1M4bNv04yg4Bx+C/EWIZIzgryaXlGpGOIjnXukKUfbq+Hgo35e/ukqeg/TKasqxha7vjS+64TKGWc6ctRZu0qdUdMKmMLPNBL5ZKGmgNVpTVNnVBJpN8CNGel/qMYW2lUHVg9dSTDhcu918Hs8NPU8l0KVRswXY5YJIwQbFWTchMubSvNEE6F2XftZ
 tn/oxuJK
 xVj4mFpb5MfOcHPPmw0LDcpJq7+igPU/6BRkkfT2Un94EZ/LEqShh7pAvEfDZLdjqt7p7RrEtFAOppx4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/03/2026 3:33 pm, David Hildenbrand (Arm) wrote:
>>  
>> +static void free_prepared_contig_range(struct page *page,
>> +				       unsigned long nr_pages)
> 
> Prefer two-tab indent in MM land.
> 
>> +{
>> +	while (nr_pages) {
>> +		unsigned int order;
>> +		unsigned long pfn;
>> +
>> +		pfn = page_to_pfn(page);
> 
> I'd just do above
> 
> 	const unsigned long pfn = page_to_pfn(page);
> 	unsigned long order;
> 
>> +		/* We are limited by the largest buddy order. */
>> +		order = pfn ? __ffs(pfn) : MAX_PAGE_ORDER;
>> +		/* Don't exceed the number of pages to free. */
>> +		order = min_t(unsigned int, order, ilog2(nr_pages));
>> +		order = min_t(unsigned int, order, MAX_PAGE_ORDER);
>> +
>> +		/*
>> +		 * Free the chunk as a single block. Our caller has already
>> +		 * called free_pages_prepare() for each order-0 page.
>> +		 */
>> +		__free_frozen_pages(page, order, FPI_PREPARED);
>> +
>> +		page += 1UL << order;
>> +		nr_pages -= 1UL << order;
>> +	}
>> +}
>> +
>> +static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages,
>> +				       bool is_frozen)
> 
> Dito.
> 
>> +{
>> +	struct page *page = pfn_to_page(pfn);
>> +	struct page *start = NULL;
>> +	unsigned long start_sec;
>> +	bool can_free = true;
>> +	unsigned long i;
>> +
>> +	/*
>> +	 * Contiguous PFNs might not have a contiguous "struct pages" in some
>> +	 * kernel config. Therefore, check memdesc_section(), and stop batching
>> +	 * once it changes, see num_pages_contiguous().
>> +	 */
>> +	for (i = 0; i < nr_pages; i++, page++) {
> 
> As Vlasta says, page++ needs a thought. (you have to redo the
> pfn_to_page with the next pfn in case the section changes).
It'll be fixed in the next version along with other mentioned nits.


> 
>> +		VM_WARN_ON_ONCE(PageHead(page));
>> +		VM_WARN_ON_ONCE(PageTail(page));
>> +
>> +		if (!is_frozen)
>> +			can_free = put_page_testzero(page);
>> +
>> +		if (can_free)
>> +			can_free = free_pages_prepare(page, 0);
>> +
>> +		if (!can_free) {
>> +			if (start) {
>> +				free_prepared_contig_range(start, page - start);
>> +				start = NULL;
>> +			}
>> +			continue;
>> +		}
>> +
>> +		if (start && memdesc_section(page->flags) != start_sec) {
>> +			free_prepared_contig_range(start, page - start);
>> +			start = page;
>> +			start_sec = memdesc_section(page->flags);
>> +		} else if (!start) {
>> +			start = page;
>> +			start_sec = memdesc_section(page->flags);
>> +		}
>> +	}
>> +
>> +	if (start)
>> +		free_prepared_contig_range(start, page - start);
>> +}
>> +
>> +/**
>> + * __free_contig_range - Free contiguous range of order-0 pages.
>> + * @pfn: Page frame number of the first page in the range.
>> + * @nr_pages: Number of pages to free.
>> + *
>> + * For each order-0 struct page in the physically contiguous range, put a
>> + * reference. Free any page who's reference count falls to zero. The
>> + * implementation is functionally equivalent to, but significantly faster than
>> + * calling __free_page() for each struct page in a loop.
>> + *
>> + * Memory allocated with alloc_pages(order>=1) then subsequently split to
>> + * order-0 with split_page() is an example of appropriate contiguous pages that
>> + * can be freed with this API.
>> + *
>> + * Context: May be called in interrupt context or while holding a normal
>> + * spinlock, but not in NMI context or while holding a raw spinlock.
> 
> Interesting that we didn't have a cond_resched() somewhere in there.
> 
> 

-- 
---
Thanks,
Usama


