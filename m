Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10BEACD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 11:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760E36B0088; Thu,  7 May 2026 07:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738676B008A; Thu,  7 May 2026 07:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628866B008C; Thu,  7 May 2026 07:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 53BC06B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:52:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDBE8C1D01
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:52:17 +0000 (UTC)
X-FDA: 84740460714.16.9ED7091
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011051.outbound.protection.outlook.com [40.107.130.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2FDAA1A0012
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:52:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="OJSsVPz/";
	dkim=pass header.d=arm.com header.s=selector1 header.b="OJSsVPz/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.51 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778154734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rt9qrD0Nsck3qnSWQdM5BN62cy7OEVHsoYHl4FUA5U4=;
	b=Z00eRoHYSgfnVnr7vX8c4IDEKXo7PFmOEeQaA2pcKxAG0dgLT70y0XOWaN4/CfsmZnzTfG
	iwwGnC3QFF5fUzwJ2FC7Cb6aX4oxX4HE89SU4Pov/5EDPEeyfAlppiGmZwlBACixojuXmh
	6iDbSapQUVtEI6kXUq3oqSkAeQETluY=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778154734; a=rsa-sha256;
	cv=pass;
	b=emwoxIspLzvK5+cC2BoIdP2h5giExZMNFwJmWSjg4iMB1cku85vmghCo5QL7EqwuFHaiIc
	RVwClES9xwp3ORHzGfClE5YaPf/oOXmaWOSwXbVenfUUrW2an61bs6JOzyGAvrNjcER6ym
	Gzv00i1hmBXGEFg2HlH8m43/7WPXB2s=
ARC-Authentication-Results: i=3;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="OJSsVPz/";
	dkim=pass header.d=arm.com header.s=selector1 header.b="OJSsVPz/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.51 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yDcrMhb2c30MydnPpJL1OEn4LSSFRgdWpjE/GYnl8P/uo/8i63YBEmkRgjZ6I4ZTLAjhi4Pz7sqA89C80dT7OLDhw3ThoqBFNmHcbw6Y7Jlm8w9pyNQToQs1Fxt+cOJhmhuJPtKcKh3uVi+Hb0pVzNKvChmWMddJMXgZSpE6Zc5ZSpeIuonM49PvTIZga/x20eSa1e953/Fymx7W5fVKZV0LjQ5oxdh+KTLhI2zWp6HE60VjqYGDJY9QbJh0ZUJDLq0Nc/yMJOmQ6E7i3fTxTQzwZQpTwHodN6+b89kcN8he5fYOKYRpP0wDePyJYm45sSnTAfeWAm7J/RLN59gSsQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rt9qrD0Nsck3qnSWQdM5BN62cy7OEVHsoYHl4FUA5U4=;
 b=LBKp+G5cZ9UCDLcVPdJAWtg7tdZNY+N48JIh22LRy4m3qWo/HJhOQnRaDkAYt4bG0HADnkTuyYn1SePxpeCMDFxz2emsXPq0G+G2G4c/GZpoDw2nRZ28p8KxQkv7DShs6iRzU2bSjNSPqRfqnDxT0A8HVwdTiHHSb8GO8t+ubpY8dizcik74N5BPZyqMBAjw1Zhyn8tnraLR/0aHT06og4ToPk80/EfihvTXqsz9uj4LXGpZ7BNjykP8Kg3v1xCDG9ecZPbv1tsiTv7WLqK7KkYiUJVhW5Keru7YmcnTfW7KKJ1C4cM3VMOrOfY5GLvmB3MjVYDQejwQxRpAE0qywA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rt9qrD0Nsck3qnSWQdM5BN62cy7OEVHsoYHl4FUA5U4=;
 b=OJSsVPz/iPD075PMABXSse9rNnS6DL3V7CTuNGmWlXMMSZ367AT0vVju9TbkLyOmQaEZzoCR35ESAYn9m9VLgF/avou7+38ew2hwJdhnk2vFtf0uoFMxUrFA9gUXEB4dBgTo70hiqMa64YJpio3gC8/CkljhzTkherdK/pME7NI=
Received: from DU2PR04CA0354.eurprd04.prod.outlook.com (2603:10a6:10:2b4::7)
 by DU0PR08MB9874.eurprd08.prod.outlook.com (2603:10a6:10:422::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 11:52:08 +0000
Received: from DB1PEPF000509E6.eurprd03.prod.outlook.com
 (2603:10a6:10:2b4:cafe::2d) by DU2PR04CA0354.outlook.office365.com
 (2603:10a6:10:2b4::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.17 via Frontend Transport; Thu,
 7 May 2026 11:52:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E6.mail.protection.outlook.com (10.167.242.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.22
 via Frontend Transport; Thu, 7 May 2026 11:52:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sENYMQzORetCNFm0ThE6Ojg1Q2ESDdRf/JU3lw3w+y/DfqAiHP6MdQX9269xru3njw0mtzBZVwcrTV6tRzUnWfgvlJxR2Ie8oEwDEdv92U9L5M328tdD7/1lhrZDQU0jAhyDTqLUAqLD8IPnDCmHdKbxyj26+yzJ1tlPbfkGm18y4RYBEYQ4ZT0rxgbzGeHQU4H3n0GI2EGWsvz0AVHaOp4Qs38jt+gtonJ/lpaC0tmdmQXnN3tmrBswnEzRB3bP08L2Xr/MNUwGXMJbNRYpqSRgQA29j8zIbJz4yEwdpgrp9y3Zx5JAbdAw9EHIixqY7nghUjvAXXWRDUoZLd0hEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rt9qrD0Nsck3qnSWQdM5BN62cy7OEVHsoYHl4FUA5U4=;
 b=UT/eXxNimoXRdlB7i2NhiaxNOv84K8uL7VIfvB6Uf8M9+oWh0cdEUwnSWYPMaR3GaVgZcehoN+u/RyvT9TfC1xvkwsjzRz7bJOKLTu09MXumj/p4zsOu/N1+/4fVx9fRov71vj3Aaakgfi3LPrQLICuTKgMieYIdNnpozTa8lQ6u5//grQcnM2p9hUQ4mUQHbyMit868KS8sAYkLqobRnQsUXAfChGadi6X9CotkjnEB1XUdkjLpiEW8bho+j/qOeonJuw6sGq/UhPjrn231cXaTDtXX1YYhxNY6qgzXEl623ITq2Tse6aStMoVp1Vzx8p+XOgQNE+R5yV6bORrn4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rt9qrD0Nsck3qnSWQdM5BN62cy7OEVHsoYHl4FUA5U4=;
 b=OJSsVPz/iPD075PMABXSse9rNnS6DL3V7CTuNGmWlXMMSZ367AT0vVju9TbkLyOmQaEZzoCR35ESAYn9m9VLgF/avou7+38ew2hwJdhnk2vFtf0uoFMxUrFA9gUXEB4dBgTo70hiqMa64YJpio3gC8/CkljhzTkherdK/pME7NI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PR3PR08MB5724.eurprd08.prod.outlook.com (2603:10a6:102:85::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 11:51:02 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 11:51:02 +0000
Message-ID: <b2457eab-9ebb-46b9-8938-e9ef3b3bcc9f@arm.com>
Date: Thu, 7 May 2026 17:20:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 47/54] selftests/mm: thuge-gen: add setup of HugeTLB
 pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Luiz Capitulino <luizcap@redhat.com>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-48-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-48-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0P287CA0012.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:d9::11) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PR3PR08MB5724:EE_|DB1PEPF000509E6:EE_|DU0PR08MB9874:EE_
X-MS-Office365-Filtering-Correlation-Id: b87af477-add3-4b44-4aac-08deac2f110d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 ZgSHy7y/8HdjQu3XgEWjYPFxEwCw17BX/gLLYA+MfQw2bu67drEQwGpf97IkFLmu60Q8+8W7SVKT6cJpjdsTFgZNYopjT5iUA0kTn6Pj8VRnUtZe6hF89NJSnjHU9nY2PSzQsjVxY+AF4fRGEh+t9+y1Yo6MHQCD6nod1SxNn8sRWBoZ8rCSCtIXlfAKzN544cEVABMs+bZA+bQX58szfW/tlUuGxPN8K+lAN/5iURelShlNb5lW+VDuFM403MRvehrR3VJpdyCi0N5k0HWFIyGejmcfK0ln3dM7bEWVvS6ZIt8D6V1kdCCV//bd9Iv+wzGqZK9wBt/TOuFtbpQ/3buvQF3vPT263GQUvdRFmwR4eQ1XSF84W0VcHXhndvAAYk1qSoq4ERTMPhraIovI35MYCsh7binMqWCxfLOFrvDgQNpOI1D5Sk0cPMayxlpcoOZWvlEZZK8carSkkbHYf9VOTs4y+cLv/IH4+E+yt1FP6PNli82QDkHBKsLEhgNKgICxzgfVqVaf8GrkAZcNj08BKyc7m4Be43XmSCkB4b1Mjra6NI59nUUvr8vdCIjl/VJCcewsMqxVJirvg2+GZmti0DBtBn/6eGWp6IgDZLVTcsj48m2Fr/C/qDdAdco4iuhwfsmCy+PtTQn3uwvoWDyKppjj++erTrGPIrTZLtpRClRlOezJWVu3OYqTvQUC
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 wRVxFMtgOppCTCtDIyj4PuaLDlT7oKi/8s/oUbshdO5AsNMJ8oe0IKKbAa6jbrxufj7rwW022y5IUR93yW4pOjjDOC18ba/uSqQaDLRE+NCLhS4Ozu3fdTb9iNr8D011lUsuu1kzNirtKBz1xo05y09PbfEbJAWsAizujW6pdsoxlGsx0leHkmBOOQuQCyiUEgx4ZikskGhq8cmMdwyYT4ERIkyVq9UmLIt8/Ght2QICf2nLWrdrzqv0i4/MPV0nz7jjQdpnJD1NOcUxRlEPu2XejxXkaUFfbMp0IW03eLUbTmZH60xE5nn6877NjmRe1fXkP7TzB3Ffv0JfDPZ+Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5724
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E6.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c6c6f6bf-c17b-4449-c043-08deac2ee9aa
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|7416014|82310400026|14060799003|35042699022|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	O9MjLEKtEz6859XfnbMbuDE5LyDuig4nB+pLAdiEG2njpJp+4F8KW86OpYTNmSse6tjW6nPg46SZfYBd3EyXnu9/QUONZxz2xItgbzrkoX/oWhvFA7ITmRvRsyrebsYy4rDIjuZB7SerIYadz5PVK6fVKKLke5hLXNU/5U/sJL8LRxg5VAWnKw4y5gksC8ly1Ks3GDF7r70KmT3ejVA0HCq2w/3ufCTlZRIBPA7dQ/lPY1USPC2oym3/iJYeyMwnoQramc056fAn4tlkFwcRy57LxD3YlwPSMqaeTyBJdwtaFsraLREKgZpoa5N4hGTLHOznPk52dCZoom0dNDe9F1tHQAdt3HmhhETrOKilrR9tulAaQxJ5S+2AHNR9mynp5vcgGJES66k9NsayVTCXQiEnNLufQqO0CVlKiZDGWYzmNogeYyfAOET1ZWwcNcuEZGoa7CHEOoJC6f5rorVCaOhSyYYpUea8KEixrBcvZEViorTTrL4LoraqhpUgU2noqGc3aGcU4uLxmq6QaSB3b6YjyoxzzGNwYRC/6upp/q1r8UlJxURSn/0/tGQzqDtBkhMBebnq2m7umSnRIJcTb3G651bbgWrhRpYyQakpwOBY1uaog7hWfjIVQDkMJPn3GMDhhLlKW8NBsbwQLa0y0FqDeUsZKUYIBADZUF+aSF8n18borhPhylrSs5lUItmTwHAzgMafSC0KQLrY0eLcr9BBRbze6N++66Nr0nukX/s=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(7416014)(82310400026)(14060799003)(35042699022)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QcNL9sZabVkC98fPsIMwIo+yDUG6U4fOI9RBpEg8ERmvdXDOGGK7gqKRVVClxlIu0FatJ5kUmU878VTj+FSUdT1OfuHA7gCfQ8WBMjxS4Jqkp3Gk2ZKSTMZlWhG4YlDs9sdNi7EvU9WQIngpzsi0QuKsRr2DfnfNry0CKW93U0tySDpYomjjb4i0A/b+0V16pj8AINGalgQoiBrd6/01vv0J+gts0FDNgPdHYtIEknTfmVzGW+7P9L9NsVz6BIB5cTeOvrX+I3KXrQR9axhHjfHEmzOIT1KEGcLTkJFrI4nkmEGE3TUBAPaOlhqitstljbFFYE6zzfpDXMVYjOKlYF9dBfzmSDE93K+fZyfmVsIRGqgieLDF5H0FO2JT6Kv0hXOeJ7QORMQNtKOdY7hkcZRvVKZz0GV/6J9bbbvCxboqpExYZ+4GV+f6I5eByRfD
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 11:52:08.1694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b87af477-add3-4b44-4aac-08deac2f110d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E6.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9874
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FDAA1A0012
X-Rspamd-Server: rspam04
X-Stat-Signature: tg5uxos6kxccauphzjimoaf4k1yrsq3z
X-HE-Tag: 1778154733-14515
X-HE-Meta: U2FsdGVkX1/4tDSVU3aC29h4BsGcFqJFT89zwHDksI7K4TR6mXp4ctqecpXtXvK/Rj8UsmgLojUz5y7Il0KwyLDQehYDK6pV1Ah2RD2Rme1UgdCONO3ySwoJ0D2izpb2YIkbVy1+0J3SB30/NWDy/N6+ZW3jlJM6frVGoBDFKvTvSuA33vB1E0IIVe/iqZ1Xf8Icvx5vj7yvTPUxqbp0yTYEbYfxf8gk3d0myhXaS0szuZhYio/jsHRjyEwNey3cHS+01v7Tkeiz3Dpbqasc3I0yL/FAY80KkLN0OPrID6S50BaJwkuD3d4X8PJ6TJ9YibF0nf+0b/V3IZZpZEDxEKtchx/M2/KlsuX+HescUI2AaPaoa2M2n8OedIwQlgG5IVAiNtqM7fv1n/BcRJXKHzX8kPp4bSLZBT1LTZcJje0juO8VLMtPVaaoGFu5Tx78QF/diO7rH+LPDq5g4F3X+LbxABBHY+MYjG54xSeo8Ek+768TBGcLbfzTF6UCxGoSKWu6E0vxXzgLvB2Ckpu4wtXMkdEnt2vXWAFqFn5Pi9QmbTZTtUaP6AbP7xiKicRA9m1/gDsR78eDLhIYOirsD9Log2tyMaSdih+gQPU39ILUoxLwCfIj7r0kuibvWR5wClPTvb6BUMVN9SZVCjKgEaWkXLAImmqYfYbmgPeAkuXj+CE4W0QFf+nRYCjA779f8Qsnh0VbV3LhkXS7RuhYm4GAStB5GatiPMDzPICjrspUohxOvwKQlLG1C5GomRZR45PpN+JUoNxHMqYTsq78VN2SyhI7+byaKJwc+7aSzurwsFIvtpXyfvc2AFM3FFyilOb/8oufFTw1DcuEhLGGgouJ5g8AWkZJ4QAkeJ4qCvR46cXI17BpaYbQWrWRMdINcG5v5+o5EVCQTPOaxlBZp5Hlc8qoR7+xIahKiLgrNSHWkSTkKH2ukzrXueTu6nT5LKADiiEOn2oa9qfqIkX
 3Ic6Zq2i
 arYGnfiOXDwvp/9+SNLXXlhOS9z1mvVXTCX+YwFw7XDdEXcj0WK6k6lrHpFcM14eDcbVg3RHiemde3snjtrqWCXwkxDqokiwHHMm0KAU9nquVHshTQCr4f4A+LG53nWIc6alPyQhazLx0o5SLAUwkUkBG1LWhDqTw5zJYFCyfTNtIr6F2+/H1RbOpQQyPkoEcp5PqssjScV7rVypYRT01bgMow61QfZgA0gZhSDOVS6JzyTORYpi8VxQyKMg/W1QS7jjnKozAIYl/gDvcdx1x/BwxHSr1KCBVjb2NfjHyFnivrI/eTKfuKA0A/yBY/L6lpdQEMX+XUmkL1gBp4Sp7whxENHa3uOPASyjg26+1170lUvaFNqqcIfQ65AmVvKA487hev6MNX4OKxk6n9Rqx+aJtk9auyIQGnzqV+jDdJKWyNI+fpgfGqFN0Bg4GYvo83Zsm5c934Q1TJGLMw0K2ioz/Fsa1DfT68JC5WAXiLuWJqmL+1dn3aartV9hEWCGobswKynFnJPdUeJzMh5xqq4HnFr7vCa1LKR2qhei/Fcpz875ybsZ5JzdaK6BhXDMjDJacbICqLK07hrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> thuge-gen skips tests if there are no free huge pages prepared by a wrapper
> script and shm liimts in proc are too low.
> 
> Replace custom detection of huge pages with the library functions and add
> setup of HugeTLB pages and shm limits to the test and make sure that the
> original settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

I have run the test before and after applying the patch. Before the
patch, all test sizes were skipped because hugepages were not
preallocated. After the patch, the test correctly allocates the required
hugepages and all tests pass, with the original settings restored at exit.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

