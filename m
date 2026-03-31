Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51BBC109B46F
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 13:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B1D6B0092; Tue, 31 Mar 2026 09:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2946B0095; Tue, 31 Mar 2026 09:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D16D6B0096; Tue, 31 Mar 2026 09:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 288D66B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:52:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB4ACC3DEE
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:52:54 +0000 (UTC)
X-FDA: 84606499068.10.A8DEACF
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013063.outbound.protection.outlook.com [40.107.159.63])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3F56210000C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:52:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="h/cYBPh6";
	dkim=pass header.d=arm.com header.s=selector1 header.b="h/cYBPh6";
	spf=pass (imf05.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.63 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774965171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hkfn52FzhtaVlDQYONeYSIp23QpnYD4hbcwPdsyOd/E=;
	b=Vdy8fSOT9UhMjW20iVLwuUqL1KWFRESy+NDQ7iSmI33JqcplRXzB+sI0RNweNUsxbvYwzY
	EjstdLpenyUKnkFzDgrD+L445gQ7BfxTWvPQLFg1Q9IBskcjnznZZ1/pDbxmxoUdaj64EU
	C1ijksPaxrZURn0lcsLk1UgIzn1Ldcg=
ARC-Authentication-Results: i=3;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="h/cYBPh6";
	dkim=pass header.d=arm.com header.s=selector1 header.b="h/cYBPh6";
	spf=pass (imf05.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.63 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774965171; a=rsa-sha256;
	cv=pass;
	b=4RUEkJeqgKI0Bf5FcMYdtUj2IpEAl7isxf2U4D04mzjyQkE03gJ2OOomDlNjO3cgU9vMja
	14JpsX+RQyMat7e8kFt4dZq3NA1L25PPyjHXBuOSaz195tE52ASXflzULtj4HVkZf1+bCC
	7jdCE0I5nD2v5Pumo9sDJtGr8BKj2Z8=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=eiel5zCUa/znVD470/Z6tm5hVpXxGIcucUwKVd2JNFZTdKCDXWuZt+DYK5agb+ey6Jx9hSj3vJhKGCh2FQLdoEfwC4lyfW3BEnyRPG8z+gqjJrWT/WBgxOT5+5UnOSdfb8pxeVmt2LP+L5pHBFZimW1XN57dGQqzAuYLQD0WCUlC1XNY2WkqppVOHjJpA5/B2FyyG8isGzTGe3aCJSI81lJsRMJBrLNoCQs32ck+16Ciwp3Alt1R2dywP60tLOowh3V3/b9Cc4fsja4aQ1CGCAFOB9Bf576youfcAhHgZ+a24eGvYN3XVQWcdJNli3zGoEnI0JAJXxsjkqa4Gudp5w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hkfn52FzhtaVlDQYONeYSIp23QpnYD4hbcwPdsyOd/E=;
 b=QNCMZ9XcNQ7+71Ek28YWqwNM0k9D6ZmODPmqaROUmuCY40p9J5aMeBhmYUpBODvedeOoJ48qLujqDXDUNFZEH0CsXl7pD7einHoXBa+Zdb+O3eF1DH/44OT4wc7KLV3LYUL37zpOStPvxhtTVAG2JA/QOLcNHyiOgqx8SVVc+Sp0fzIrXyLkxQ9khViHUsDOSUlBpxAUZXrI5COba2rWiVKhZrl2BuZ5PwnhDDywmfnkn9LHk5/6c1mQBab+KQb7fTMBJHViFs2O4z0aAolhuH490rvrh2PDfjEWBrmNHk1ysqWU47y/xm6GxdhvJmyCK2vp/T2yQeQg15SSc4o77A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hkfn52FzhtaVlDQYONeYSIp23QpnYD4hbcwPdsyOd/E=;
 b=h/cYBPh62TRKoyMfDU/z072BD/lvV0ovpQ05OI+9NJrlsHp6VC8LYCBrgRqOfbRxrlsGiLunAJhYq+8lDynLr9IfqapTHhx4H4t8J6wX/CFWs/RSIi3PJ1LOXuJiGZQYV1VItLeBbUBSLjh10Qz0blbMfUG31mNTJcOm5Y+UiEk=
Received: from AM0PR02CA0143.eurprd02.prod.outlook.com (2603:10a6:20b:28d::10)
 by AS8PR08MB10364.eurprd08.prod.outlook.com (2603:10a6:20b:56a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 13:52:37 +0000
Received: from AMS0EPF000001A3.eurprd05.prod.outlook.com
 (2603:10a6:20b:28d:cafe::65) by AM0PR02CA0143.outlook.office365.com
 (2603:10a6:20b:28d::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Tue,
 31 Mar 2026 13:52:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A3.mail.protection.outlook.com (10.167.16.228) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Tue, 31 Mar 2026 13:52:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nSYB1qedqs0Iln7O9ULR4cX4P8/4SX6wdVim+A24xgO+V8XQG4CbZBe4Z8cO9B0i+zOW9y4/7/yoLwWWqX6qSFmDrOS/Z1M4Jd1nNk1ICIQLueTqpJinvOySq6pvIZHH7du5Z2jYs0lyR5l6ZqSlV6iHNJDh4N6xPix+gK4YktQp7Xn1NRqNXW+tx6LXCNhfksjRfd1c/fXbxQqOu+SoumU5UmpYsGbUHYmpnZC+vCkXd89r1HzPTr7zeZjfM+GnF9UmGaRqWPQZCKfY79drOy8f/wbvvZDigc2Brp8gAky3yIW3UipBtJk0TI8OiNTP/YUagl95vKbAYdji4yPoEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hkfn52FzhtaVlDQYONeYSIp23QpnYD4hbcwPdsyOd/E=;
 b=tnhfrAVRtijWEbWDgWgPb0S8/66ik+P3/yt00EWXQ0Cz74rTen+mBrpROu6AsI2SzK7TvSD98lelOBaHzsBURQXY5OVwgJxI+PQKpuHcuntgNutFR7GMpmeziJw+sbR1hlQn9rn0KYghwfpzwYo4d8z9IdIcxowBg5wy/NZuBkHXbqkMmW0n8fl9g3wYK57sDwN7AfIaWohwi1QhhSnkARbKtKbZ6doNvRkZ1bmpIgjvfe28y7CVBRlU3KpTwAinn98pPdWtyeOcC7cX8wyhx3xZWyNCz4SL7iSU5ec9tas8HUZVcmP9wzBz25O2mBixoJ7nq2rYeetp+WoKSpzHBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hkfn52FzhtaVlDQYONeYSIp23QpnYD4hbcwPdsyOd/E=;
 b=h/cYBPh62TRKoyMfDU/z072BD/lvV0ovpQ05OI+9NJrlsHp6VC8LYCBrgRqOfbRxrlsGiLunAJhYq+8lDynLr9IfqapTHhx4H4t8J6wX/CFWs/RSIi3PJ1LOXuJiGZQYV1VItLeBbUBSLjh10Qz0blbMfUG31mNTJcOm5Y+UiEk=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by PAXPR08MB6718.eurprd08.prod.outlook.com (2603:10a6:102:134::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 13:51:32 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%4]) with mapi id 15.20.9745.019; Tue, 31 Mar 2026
 13:51:31 +0000
Message-ID: <341aa416-d4df-4263-86a6-70a8444fe2a7@arm.com>
Date: Tue, 31 Mar 2026 14:51:27 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com
Subject: Re: [PATCH v4 1/3] mm/page_alloc: Optimize free_contig_range()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-2-usama.anjum@arm.com>
 <3b2380d1-e4ca-4e44-b67c-06780354f806@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <3b2380d1-e4ca-4e44-b67c-06780354f806@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0175.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::14) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|PAXPR08MB6718:EE_|AMS0EPF000001A3:EE_|AS8PR08MB10364:EE_
X-MS-Office365-Filtering-Correlation-Id: 62b44051-6cec-4061-cc10-08de8f2cc45f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 fXfg41Io73GQwYjyYUtaZYnECOZTg7Mx6xGestKCPfMqij+3Ai6KQpUcIXnCvG9RcH63Cy0IIxKK1dzyEp9PMaYvvpjIayTYGQKsrpCouWwCxsDT1vikani0AH+CekkMSHR/sgt3VqlhcX4jz8iKXUMHHLOnSShxLGrL7wi396voItnqKA8R+Mj4MZsKQECN7AA3VQxDn07EIeXqAn+fvaymIEXoCGfGpufh6yiuqtnLNCptyNMeFxSlxJNva0y3+ZEK39MfpcZIiHpjaygU6ybuLBIklL0u7MvM+Oz/tontAFent3b53oWisBYLCCsVvHcK0OFtYU0fmVB5mjMcciResNTF1bf5YZ8sXIdBBh5PWRxKiLQhqaaevnTsSG3QklYgInEOSu3ZMI9pAS5mMNLClMavPcLhXqsthtMo79xjjnuWw57jriW4BC9JbGAjtwsRUzK9EEW2OwAtg2SD2UJRi+TnoTjw5wFAIUozVn/Ji7ZMIriuhmFhTvPE+hTdDXnz1W00icxWNYIpcDbycPkXPCt9sWGopxfVHfrKMWbm2vjgi6CGZSlUiEVSSGI7DB80MCG+6zifU9A98lRUIhcFFO21GNRQP51yXjX0WqHDmYkRSbql8/3BSaKxddLY/9184usSA8+u+s4h9x3Sq6NX2bmEWubKWnTQmIM0iRZg1RoGNNcBFuDY3ERolgwGWZhvu0oRFKAd47i+IObK4DN33qk5yVeBrkqyqZQRFEZ5nZwIGDAPZYRCURszonwBt9Azv1TBGAyhkMijLqsGYA==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 P9kZQR9C0Xvb1hgtY52DgVkKIOnLxxPrD8AxNvJONpcz7lNVJ5CckrozyJOJK1FO5suT2PuMqg77Ear4tWe859ttW5W+U4MFyQtJg1QAsv1qThDzoB3FtSuzJsTDz3EI2uklc25HGh9/HJ5e4+TKSkvm50Affh7eqRxzFu6acG8mhaipFmoG0ciqa2th8V1AxQ+rvIV8XgUuricpJvP8W5P565NwrWUYAOCUjhqpJ/oML/ea9D0+/5XBlTL9r5xr+YFiZ1k1TKr60UrwbkRCl+rCMZ5C+d14qqyLZ/I57lsvK3nZEICYjyoX3zSrnOK8YREso6Xs7epuS5dcmZobEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6718
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A3.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	268c7a29-bc08-46e2-f378-08de8f2c9b97
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|14060799003|7416014|35042699022|376014|921020|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	AjucTLdj7WXYqyfG+on3SNjmsr5I5MpMSyXLWSVFWAPU+xcvl/MPz6jGFTs8LnFRU7BEEGS2QrJH4dBbDhpalxF0y4t8mRy/rQhtR52x8kCkQ0AmVCRE3upXgT7JV+u+4mX2I793ciXVibllqf6z8L3E3r1PQRiwVstFEWWrNg3ArxB3QMD1K1ji/2WdpMrK0Lkr2mW+zy6t4mdBvccS9IuIMek4N3Nyp7BzN6ReZsy1lUys9gh/tJ26++1gl3M8dl68gUQQzCPIzaHYTnL9lmfDo6gdSpT4wtJu/L8x6ojp3Q7OXMhWwy07njvptVLIlIMUMtGbMTN7PAeb5clRyK5BAyLjxKjavtT/1kDUXy9iVe1jJE59ywJI6lGT5zYP152Lxjb2hLdnY9KbPYqMxJufid34pUcAAoU+dgSfrHHShmvP8B9w2nrwXrnXfEe9T5rlW7UQ/u/5LeYFJvi5E12YLJC9/jEsGSqBTLlIiRWFKZXyWK7DMCYkxxO6qhKgKgQIFIGebemjnRs8BP2ExnETseyRB7K41hqp8Uryxk7EgI7jtMffSQaFK8IaGmLxlU9kQZMmxSxCpTAxveDCCqjKhfjKur5Usi2MPboEXLFyS7Vp/Wbk6eYeH+ChWVejs27p0ue5KKqAAIgsd1JeJTuwHgEtbqNCUMNREQVz6L6D2QZkHZKop7li//jFCke3GFfDlIb+rAZ6mN+Tw5QlKt+qFfc0cZJQ460kjhhe9b1d2Tku7247bpTaPu3rvClCcA03sio1pEIo5njgIyTf2VVws1Uw6CoggwWp28GwSh7gsZEK9t9XgxlglDMbNRNm
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(14060799003)(7416014)(35042699022)(376014)(921020)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JTBm1c6Q3M5qDe1JXz1bfACEt89PIbz5f6GMF+510JPcr1hEuMCbiQCpjcVozQl0G8vfY9ULG34NKBZOM7RTDsGLSI/tjZL2I168J5y2eVUIY+BirPs0dgZ4Vt5typ2+YOmKYdZJvJY39n9WoltragzBW/KqPDJEsgLhpc9Uy/l0+2m+yLXsp0aCBPZC5RgPdwvocZhjmgwSs3p0XMK6C3J7dNbytaJGxDaKsFKYoj8Jw0rYfprqZvgibjWfNJ+MsMSv3G0/CO8BxQ5jkp0ErU/gGbdmwy1zUajr+iice2sf0/eqa7GSJlQGcR8jBQxRvgQZnjwyuzHFVZfzCLhcBri43W+498LBg5e1z16xv14M7uKM03jMI6POlf3rdSDQi75KPRZsmMUt7EIUjiRsP+YdonLf7doUG11p2xD64csTBywS5wJXYKV1XUE+Y2L0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 13:52:36.8094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b44051-6cec-4061-cc10-08de8f2cc45f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A3.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10364
X-Rspamd-Queue-Id: 3F56210000C
X-Stat-Signature: 8gsc47w8i5cc1kcyn7qa7t7ieaoigk7u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774965166-334553
X-HE-Meta: U2FsdGVkX1//8vL4NyUhx+0nI6mgSbOR0bHY4F/9QRwGcnxN5/abLRxfO+1Vs/158srMVqvXsJNuYTWguyzdEv3XCoP1Yd8hseYVpnAQWfG0JyOuLVV4dFLyrbhY4J435XAVQym3cV08MtunRanlrvFh0lERl9ByJ2GWoQjsj9vHmq9kldFjYN5aB6bUwCNpq1oRVpG4dLDXTDC2IsJIiZEiEbtABbTzRPYoLM6cDkneA6plyZ1/dNPq5m3lQ63Jbb/IWh57Wa9xgTw+VSXariDFnNKYVh1gCKTWk3ZhpSbNlJhjjPZrslE4NF1uxJfzOVmdGDqNIV1YsdmQxJ4+c/GLAtSMIwDMRAxgYHCM4d4KK4+V7adr8snvzLZXydL0wlRsAh9UyW6YvI/U8CjnUkTyXFh88b2OuJ5ZcV5IcgC9lQw+nJtvGjAYj2jSG1Cz7gPmh3JpRG/6MWe/NB/hBcAkrpZp5nZdiUpslEVnc29kl+IyCRRmToi0IPy5hzGqiTe8LWJDe3Hisam3vCPyy/GKcCe4wfyZnqa8EvU1kds8irL8NUJWR/tEE2L06QSrTGEZtCQMxcnZFUZeYweFdxX2Pdedd0CEHrufjhv0bZh9uiTsQAm63zu/n058Jjtz4w2uaRA7gCZyRfgqSjXAAc16uGWZJPv2TJL6Dyj2vGhWpzpFQuqvXd9g8oCWwoqG/OJ12ELG9CPTHmIB74NdVTV7Wo/uEo7bOUm8Ggu3SKLHqpe8WSZCJld4C7ZiHhN4qhWJ2tCV/9AZvAFUZGcVNF+e5lZ0YZ0RrrjWSGPmtgo7xWB6xAHjD+1KHl+0X5cMCYDIozP3Jj0QSpAlu//S32xu0GeSzljsz4kxQzG9YiwnlSGq4d6bYirMerDXT1tMvb22EO0vOM46NRENFtpGR9jiEaCdJw2v2K9w+bpO6NqjRsGvevXEmr8LyxO5/SfIGI6tu6TL5WqvW0QVYpk
 Tl6qp8LW
 jiKMCI4TY0Cr9iMDLs4r+3YZ0PGkK+SQqcZymZY9XX/SUeFRa5B/6odSF3LDctZoaQUTwMtrkyJEoFBZlcK+BbAtRmXDBqi0JCwEAShBUybIQ/LLodHMJcX3DlY3Uk9PrEBZTY6QyyqF5r6nCMlaKM9W4ZybcMvr04kSznmDClrZuVaUxxEI8DQ7BOH+3JxBZv4C4/KLBw/icUgdUEysg3113zaB+md6N/ZGoOB6+CHs9MJTp6wYH0Lwf1hk11iNRlxdFr7PbUO2LngH3rEn+Fau0T7fAl16T5V7l+GqcczFV38sWtshUuVnTd3OELndZkOyKzd3cPk4VADPQz2PrdD0GHAn/0bYdX4D3pDAs3tCngYH4PzBLqMPHinpIgaAIoo1PJPu+t3ulB/oT0eWn/EF+c+/uUpE4SnpEUdXHy0NrFnCvhoPFpDm1vcDshbJmIRi6kSk6Si8auUwJF1tXZh06bPSAz407sjuhOTTHfwZhzou/mtLPpIASeNHYNvxvyQq6M1bvOAap7InV0EHlyYOqR3gX7DWD+0dZ59cr26gcjLT66lXN+EFsm7UN20NmRbSZodwrk0r5uTGgOKKHp4eRsUnrhryq5tQlCyWAOZVWjm6b5dfaMZXadkiknctXXAWJNI1jp2Yqq+5LB0b0TucwoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/03/2026 3:27 pm, Vlastimil Babka (SUSE) wrote:
> On 3/27/26 13:57, Muhammad Usama Anjum wrote:
>> From: Ryan Roberts <ryan.roberts@arm.com>
>>
>> Decompose the range of order-0 pages to be freed into the set of largest
>> possible power-of-2 size and aligned chunks and free them to the pcp or
>> buddy. This improves on the previous approach which freed each order-0
>> page individually in a loop. Testing shows performance to be improved by
>> more than 10x in some cases.
>>
>> Since each page is order-0, we must decrement each page's reference
>> count individually and only consider the page for freeing as part of a
>> high order chunk if the reference count goes to zero. Additionally
>> free_pages_prepare() must be called for each individual order-0 page
>> too, so that the struct page state and global accounting state can be
>> appropriately managed. But once this is done, the resulting high order
>> chunks can be freed as a unit to the pcp or buddy.
>>
>> This significantly speeds up the free operation but also has the side
>> benefit that high order blocks are added to the pcp instead of each page
>> ending up on the pcp order-0 list; memory remains more readily available
>> in high orders.
>>
>> vmalloc will shortly become a user of this new optimized
>> free_contig_range() since it aggressively allocates high order
>> non-compound pages, but then calls split_page() to end up with
>> contiguous order-0 pages. These can now be freed much more efficiently.
>>
>> The execution time of the following function was measured in a server
>> class arm64 machine:
>>
>> static int page_alloc_high_order_test(void)
>> {
>> 	unsigned int order = HPAGE_PMD_ORDER;
>> 	struct page *page;
>> 	int i;
>>
>> 	for (i = 0; i < 100000; i++) {
>> 		page = alloc_pages(GFP_KERNEL, order);
>> 		if (!page)
>> 			return -1;
>> 		split_page(page, order);
>> 		free_contig_range(page_to_pfn(page), 1UL << order);
>> 	}
>>
>> 	return 0;
>> }
>>
>> Execution time before: 4097358 usec
>> Execution time after:   729831 usec
>>
>> Perf trace before:
>>
>>     99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthread
>>             |
>>             ---kthread
>>                0xffffb33c12a26af8
>>                |
>>                |--98.13%--0xffffb33c12a26060
>>                |          |
>>                |          |--97.37%--free_contig_range
>>                |          |          |
>>                |          |          |--94.93%--___free_pages
>>                |          |          |          |
>>                |          |          |          |--55.42%--__free_frozen_pages
>>                |          |          |          |          |
>>                |          |          |          |           --43.20%--free_frozen_page_commit
>>                |          |          |          |                     |
>>                |          |          |          |                      --35.37%--_raw_spin_unlock_irqrestore
>>                |          |          |          |
>>                |          |          |          |--11.53%--_raw_spin_trylock
>>                |          |          |          |
>>                |          |          |          |--8.19%--__preempt_count_dec_and_test
>>                |          |          |          |
>>                |          |          |          |--5.64%--_raw_spin_unlock
>>                |          |          |          |
>>                |          |          |          |--2.37%--__get_pfnblock_flags_mask.isra.0
>>                |          |          |          |
>>                |          |          |           --1.07%--free_frozen_page_commit
>>                |          |          |
>>                |          |           --1.54%--__free_frozen_pages
>>                |          |
>>                |           --0.77%--___free_pages
>>                |
>>                 --0.98%--0xffffb33c12a26078
>>                           alloc_pages_noprof
>>
>> Perf trace after:
>>
>>      8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] __free_contig_range
>>             |
>>             |--5.52%--__free_contig_range
>>             |          |
>>             |          |--5.00%--free_prepared_contig_range
>>             |          |          |
>>             |          |          |--1.43%--__free_frozen_pages
>>             |          |          |          |
>>             |          |          |           --0.51%--free_frozen_page_commit
>>             |          |          |
>>             |          |          |--1.08%--_raw_spin_trylock
>>             |          |          |
>>             |          |           --0.89%--_raw_spin_unlock
>>             |          |
>>             |           --0.52%--free_pages_prepare
>>             |
>>              --2.90%--ret_from_fork
>>                        kthread
>>                        0xffffae1c12abeaf8
>>                        0xffffae1c12abe7a0
>>                        |
>>                         --2.69%--vfree
>>                                   __free_contig_range
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v3:
>> - Move __free_contig_range() to more generic __free_contig_range_common()
>>   which will used to free frozen pages as well
>> - Simplify the loop in __free_contig_range_common()
>> - Rewrite the comment
>>
>> Changes since v2:
>> - Handle different possible section boundries in __free_contig_range()
>> - Drop the TODO
>> - Remove return value from __free_contig_range()
>> - Remove non-functional change from __free_pages_ok()
>>
>> Changes since v1:
>> - Rebase on mm-new
>> - Move FPI_PREPARED check inside __free_pages_prepare() now that
>>   fpi_flags are already being passed.
>> - Add todo (Zi Yan)
>> - Rerun benchmarks
>> - Convert VM_BUG_ON_PAGE() to VM_WARN_ON_ONCE()
>> - Rework order calculation in free_prepared_contig_range() and use
>>   MAX_PAGE_ORDER as high limit instead of pageblock_order as it must
>>   be up to internal __free_frozen_pages() how it frees them
>> ---
>>  include/linux/gfp.h |   2 +
>>  mm/page_alloc.c     | 103 +++++++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 103 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index f82d74a77cad8..7c1f9da7c8e56 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -467,6 +467,8 @@ void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages);
>>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>  #endif
>>  
>> +void __free_contig_range(unsigned long pfn, unsigned long nr_pages);
>> +
>>  DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
>>  
>>  #endif /* __LINUX_GFP_H */
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 75ee81445640b..18a96b51aa0be 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -91,6 +91,9 @@ typedef int __bitwise fpi_t;
>>  /* Free the page without taking locks. Rely on trylock only. */
>>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>>  
>> +/* free_pages_prepare() has already been called for page(s) being freed. */
>> +#define FPI_PREPARED		((__force fpi_t)BIT(3))
>> +
>>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
>>  static DEFINE_MUTEX(pcp_batch_high_lock);
>>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
>> @@ -1310,6 +1313,9 @@ __always_inline bool __free_pages_prepare(struct page *page,
>>  	bool compound = PageCompound(page);
>>  	struct folio *folio = page_folio(page);
>>  
>> +	if (fpi_flags & FPI_PREPARED)
>> +		return true;
>> +
>>  	VM_BUG_ON_PAGE(PageTail(page), page);
>>  
>>  	trace_mm_page_free(page, order);
>> @@ -6784,6 +6790,100 @@ void __init page_alloc_sysctl_init(void)
>>  	register_sysctl_init("vm", page_alloc_sysctl_table);
>>  }
>>  
>> +static void free_prepared_contig_range(struct page *page,
>> +				       unsigned long nr_pages)
>> +{
>> +	while (nr_pages) {
>> +		unsigned int order;
>> +		unsigned long pfn;
>> +
>> +		pfn = page_to_pfn(page);
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
> 
> num_pages_contiguous() starts with an array of struct page pointers,
> presumably all valid, and determines if they are from the same section.
> 
>> +	 */
>> +	for (i = 0; i < nr_pages; i++, page++) {
> 
> Here we do page++ and then trust it to be a valid struct page pointer and
> use that to check if it's valid. But if struct pages are discontigous, we
> might crash on the first dereference? The section checks below won't help in
> this case AFAICS.
I see. So pages/pfns may be from different sections. I've
the solution now. I'll share in next version.

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
>> + */
>> +void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
>> +{
>> +	__free_contig_range_common(pfn, nr_pages, false);
>> +}
>> +EXPORT_SYMBOL(__free_contig_range);
>> +
>>  #ifdef CONFIG_CONTIG_ALLOC
>>  /* Usage: See admin-guide/dynamic-debug-howto.rst */
>>  static void alloc_contig_dump_pages(struct list_head *page_list)
>> @@ -7330,8 +7430,7 @@ void free_contig_range(unsigned long pfn, unsigned long nr_pages)
>>  	if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
>>  		return;
>>  
>> -	for (; nr_pages--; pfn++)
>> -		__free_page(pfn_to_page(pfn));
>> +	__free_contig_range(pfn, nr_pages);
>>  }
>>  EXPORT_SYMBOL(free_contig_range);
>>  #endif /* CONFIG_CONTIG_ALLOC */
> 

-- 
---
Thanks,
Usama


