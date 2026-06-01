Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81BADCD6E5D
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61246B0353; Mon,  1 Jun 2026 08:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11E26B0355; Mon,  1 Jun 2026 08:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA3E6B0356; Mon,  1 Jun 2026 08:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD7C06B0353
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:06:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7ED5D4064F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:06:18 +0000 (UTC)
X-FDA: 84831216036.23.37B3850
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010021.outbound.protection.outlook.com [52.101.69.21])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4CABD2000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:06:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="W/h2Zymk";
	dkim=pass header.d=arm.com header.s=selector1 header.b="W/h2Zymk";
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf31.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.69.21 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1780315574; a=rsa-sha256;
	cv=pass;
	b=Pc6oKjMqd0siHFUTG1bfn6EKnJD0nlEvq+prM7Jt6E2dMApVaB9LN/5t1hXglv5t03Wsdy
	Qr3/VO/z/mjdczFomRa1CbjBY2qatl1huYS+1FPECzlWS0v8TsmTBcqbdZ0pG3BDrktVjC
	nSf3IVfPhf4+fF3y5pKTjD73hEw3hUg=
ARC-Authentication-Results: i=3;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="W/h2Zymk";
	dkim=pass header.d=arm.com header.s=selector1 header.b="W/h2Zymk";
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf31.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.69.21 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780315574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAwtx8iXkBZ35HE+VZNm/0vvO4oCQSSXH+5v98gjC3E=;
	b=XJV6ethcg4Ss99kR8s0cmHYnL+cKSl9Yv8APiCO1eBvlYWLjgeHGvqAg/efjzDWlMJULse
	iTvYEZjfuUNF83J4Zhne40TdECIiyszO04QKcUjAZlgbqm9yC6Q5v1ngDwZwODLUvTqfk4
	lorrVwz+FVQE0WSse0f5uUFHvgeOfuw=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=C81Gy5DQKLpSpVpDVIrwqYGiOlDbFZ6kUNC17MJjMd9ErYfQhYyjZxvlBwD47eFUEg7hOn77C+o8Xma7kJQVOSUxk8bVgudMd8rGVBADP8Gyka8YGLpytx2IewMAp+O/wWNgz1czKlKBOXJ+m0qngenMwJIs2bGAiHzDxFp/LEkmZ3qRpG3R3cRoRMich9xAvQxgN0eosMbebsfGwwJdJNVURw8LPfzcpLf6pQnx2S2FXrb6bLlgxSkPkLWUjAGMukU9OxvIij90yUP2oBKOelkcvu6/FAfQgjOV3r5qXA5WH9D8y28Q+Hhs2ME/2OXJ9mt7SswsvnYQpYSM4g0ZhQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YAwtx8iXkBZ35HE+VZNm/0vvO4oCQSSXH+5v98gjC3E=;
 b=lVDr+D5ppyKgAJsZOSzIVLU1E6yoy17Ed6eQleU1NtHlX4E8WfPja2xtviyArMn0o+pNJISaLx7aOZZEVK4jfnlLdcFpbfUHKs+uGiTaIWp9zlcnq5SomaxdbT0oqJPB3tuheGqYHkdfPmovKzUvEefXwLGwyznrCXCpavkcXP0oeQNQ448XUdOI9mNttzTXaz3LHNjiy7yUAorA8L0Sq/MjB+VoHczFu4Eu+AE8tTDTzMbbTglCWEmy9+RCDcPceZUbd+e80rnweqJ/wecjnblCfSJfRx/el/nPI37Zg++4pSTXCWus9aUvAZ3jKYITDtPF0nMIIUUCXnYilZzbUA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=nvidia.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAwtx8iXkBZ35HE+VZNm/0vvO4oCQSSXH+5v98gjC3E=;
 b=W/h2ZymkgTVFi/r7dSxhibzOg+RVUQuPHBPwmr+v07gJzynNAzhnV6/KrdHXqnGVHvJMOLsLPoyg7XkZyuJ9lKpQXU4AIguc6vAMdo6253t6PSpnHK+2kCEncFVfQCJLM8RenPyvJhgNkVw5Kg/PIc4V83gBV7vWPj+SzTlUP9E=
Received: from AS4P192CA0031.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:658::24)
 by AS2PR08MB9739.eurprd08.prod.outlook.com (2603:10a6:20b:605::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 12:06:07 +0000
Received: from AM3PEPF0000A79A.eurprd04.prod.outlook.com
 (2603:10a6:20b:658:cafe::15) by AS4P192CA0031.outlook.office365.com
 (2603:10a6:20b:658::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.16 via Frontend Transport; Mon, 1
 Jun 2026 12:06:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79A.mail.protection.outlook.com (10.167.16.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.5 via
 Frontend Transport; Mon, 1 Jun 2026 12:06:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VZrcX3xbUjMD/On4sElS7rfjpLgiAlMJ0YD5IRe+zRvQxIk0VoGG4LGvQJEiHlmwFx8fGkBEIBGt4bZhACaokOveW9Z1m/XtUPOpU/vCovwQqkb5bbmqvowr63l/FxeBQ3erGs5sgsNccjQT7AoPHWbx6I9zf938/G24G3WIj8uYNG7jbXX6Acl2dE0/VGAE32q4xIJMPmha9zubmoP9ifR4MT4Ff89K6PEcg7XEeiAP9AjXkiDacnGStkM3vQEJ3445BRNTfY83AJ7aOtQMQaPQo+7H+mQomSfh65R2GoKWrY1+CFvDCEBxMMoA9VMVnzinorPyblVl9CJ4/314qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YAwtx8iXkBZ35HE+VZNm/0vvO4oCQSSXH+5v98gjC3E=;
 b=wt1RiEtoUx4e1+zavwHmqNKFVbKu0gobFq2IQvCYY5XiIaMz+yFXByQ6vpNFeCqKudsMnzEEflUEikuxq7h4CKEWxLn29/BwXojwrjSD/PELTDl5nJjG+eZrb6PqNflknNyYlULT4GL0LI1shu/fgXu2h1fdEo6c6p812Ggd1pictq3IwtaOBSAmjNvW4yLOQY/A+LLTan5wNi/UjpS0/EMAUB4z+etwOSciPIYcsDfpS53951PHWO9/VNrpBvQK38siWfESP3PuGAmINhKL3Cd29UHLcbc42x/Zl3vjhOFQOYV4oPSOHi2MWggpQkqPexzljB6OPztPATSj6gEevg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAwtx8iXkBZ35HE+VZNm/0vvO4oCQSSXH+5v98gjC3E=;
 b=W/h2ZymkgTVFi/r7dSxhibzOg+RVUQuPHBPwmr+v07gJzynNAzhnV6/KrdHXqnGVHvJMOLsLPoyg7XkZyuJ9lKpQXU4AIguc6vAMdo6253t6PSpnHK+2kCEncFVfQCJLM8RenPyvJhgNkVw5Kg/PIc4V83gBV7vWPj+SzTlUP9E=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PR3PR08MB5644.eurprd08.prod.outlook.com (2603:10a6:102:86::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 12:05:04 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%5]) with mapi id 15.21.0071.014; Mon, 1 Jun 2026
 12:05:04 +0000
Message-ID: <b2265aeb-fbde-45d4-aa4b-fc08dc4fdd28@arm.com>
Date: Mon, 1 Jun 2026 17:34:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] selftests/mm: separate GUP microbenchmarking from
 functional testing
To: John Hubbard <jhubbard@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260527142432.230127-1-sarthak.sharma@arm.com>
 <20260527114752.cf4dd3e1bda93fb8ebab5a76@linux-foundation.org>
 <3b4176f4-e099-490c-a5e2-6a36d00b1207@arm.com>
 <13b63b4f-6a4b-4433-93e8-78035ab62b83@nvidia.com>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <13b63b4f-6a4b-4433-93e8-78035ab62b83@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0009.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:176::13) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PR3PR08MB5644:EE_|AM3PEPF0000A79A:EE_|AS2PR08MB9739:EE_
X-MS-Office365-Filtering-Correlation-Id: 95c0a2c7-256c-4498-de9d-08debfd6295b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|22082099003|18002099003|56012099006|4143699003|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 0/UCGDkV18pw1rqlCv8/v3c395BjlZi1XIiaKBCfN66Ra7MGSp6D6Q8PsII135EQTkPhTf+mUe31ui+vzK/wX350Wf1VUuG3RdjaoiKdL9T+5Pp7UifYPvKYm7voVLLoZvElkflff6Dnb4fn0Oo06DsjO6tvD9b++Axa2JzcqjDXsCtR5SRgEUUMaVNd05NIcv0zK+AvJz+E7FUG9itLk6WHEb8swToNZWAQ/v9XELV702ykHdRILAFHWFhHU2/DufFwIe+3KnWZhN6WX+uIxx3Tts8fgmAFC4mDcpW69dQtMfGZjG8SiXVWFgf6EUwyWg9DQgy51PwhdxDhXNXjHEQPfejtAMHTRPr/5yeheCG9MKd9Kk/0c1qHDUttMr3w0ZWtjSMmRd0pQ+Rvj1fu+d8ct9VGa7R/z/dYajx7WWXWk07H4/7gFL6dLy8S0JECThwxnhC8eRTr9VD2THaM61hbV1LL8erXzELuNEnXD/WFGiVqvXOoNXSgSQDYn7I9oMFvmKenwI8LEYsq8aJPBROiV3iYtu1ZCvmCFHUSfUfnOlrXXwhgh7qEBzidYgyFMJ0tIXPBPIASAC98hqXDS8XO5mgCWbTtf7uasCZ8aenXmSbdWolhkQ/TY5QCRYcWxZO/Y0+rdlltIoBMsICoA9aka+XCraKF0c5Tj9tCwb8IA+B7E8k4PxYkrDrYJEKLXVpRgIv3EcTnOZiPU/ydUQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(22082099003)(18002099003)(56012099006)(4143699003)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 oUqGST2JVM/UdGTwr2bnCrwo36HB+Hi3jdVCjcMYGHlGzQ13yS1vMWwGSXIS0E1zKz9maokA28ZOG0GaHIoI95Ahh1EkklHzPHcnv6lkFXydU4roonAB97MumFy+5HBKKamnKp5KTgiHWvyRL+AOsr1YKwrc1DErWK9slGTPOBeixZppFt9D5YeGLHyYJWuXcLGlPptyDQOW6vYBdxuEEhURWxwuRWOJ3DMJaBJmYshfYQR87NjZ+jg3nLPTtdumn5jncVUyfVq1rCy2Uobhm2oyA3BAz8BhulmYGUmXVUk15rM8Atsn//m4lHqQo6NuxqU/EHYqjCRXqaNOexKkfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5644
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A79A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c65a5cba-439f-4549-e91d-08debfd6039f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|7416014|376014|1800799024|35042699022|36860700016|82310400026|18002099003|22082099003|56012099006|4143699003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	WzRgc7lnt7gKXubh0BrABrW05+1l/GyzL50WrBfRLErWYYTDsMUtUGFY23Jqj8m2WmHSSzx84ufh4sThG5b+Vka8qYU4RwcL/tRUtTRjCMhkhML+L6OQ0GmNUJz7/I613dHTpmyfzxXolqKvdpt+8l4fNZGOE7EWgt38Qus0uigvtpaK/9UlmidETZIR8G6C4TTPbZcTVVfdAWovVlthqBLrg5cgs2MajIGCgSi0mewOdLrmxtKJnYnak10Xl4VH4Otj7hkJlM37Q762yVzxZey8DbRqyuG/g/rH4u7KaXF75Lk3DU/7l56ViQHkkkJ19ocJCZs2kce8op9rRCW6CBRizH4tR2/f9BuI1w/gY5RKVO4CupHX9cUyupnggz73Y+9aFUAj15eFJ5zhbSxygiAU3VW+GhTUxln9Tl1i7o4ZOitfXnqMoDRSXpfTd1blsLwb03ypegN4EP1kMw2ZPeqC14nREXquTczkAH1Ej87Vs+5/EfR4CJrESdstvRNKwEBqKmgVOG9SdE+GrSaFaxQLADG5mHzfFMQPCdsHxMDwDqNpNpymh7W7JbYsSRS1khc4T36gN/sctjXx9/yaKEmvMpz74aMQgO2I8YpYX4oojrCJZrgTgBcam/r5260O6aPv0gKT+m+TV88UCovi2UOke8oBV6oxGiWEzyd+1xKjptg/xzSERKUm7RYmBflJ0BdWr240+Fz9Lo5ADsvmrg0S86Su4YiQ6nT1P7EKhZg=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(7416014)(376014)(1800799024)(35042699022)(36860700016)(82310400026)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EKTCTmWJHEvcXecrMO1hKdVaYxRttGGs9BP3642dDeaMnWb4fsE6eI+4s9oeJG0H6CmdR+tFFFW2J48mIm4Hwisela8+EsC/jhJYK255VZA0JORRFNbMU5M+yWKiUHSHaolsHAhvhvNboUmiXSJTwO9IRBmldvAz8j1aCyFuN8OD46huxM0xTkUSUX8TrUYLbFY1BvPGAJsKz1RBmL69gQe1aAyOEwWprOnQn1ThkBw/IRC8Di7R84rSgu0G1/6psJwjEMMZMy3gjcoZ0t/G+ljYNdQyhksbDBeoYQpPBWPGnaME6s6Nw5NJL/BagC8CarElzbMokkb0UYvO8JHeN9xcauZMDKpgURkwlnr+huSyoIoyEr17YgUDnUEDuTQ6OIYJKX7aoST2Qwf8O3ExSdN8wc4Wtx5GZxdIZn3KhhWwL5xgtoCuOQ4l/J2fKbs0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 12:06:06.9443
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c0a2c7-256c-4498-de9d-08debfd6295b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9739
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4CABD2000D
X-Stat-Signature: 954oph1fywqken8izmy1wbis7n5geo9x
X-HE-Tag: 1780315574-882255
X-HE-Meta: U2FsdGVkX1/PUG7CG3F+vrb3yztatpsmznD/9xHE20MsDauHsaqzu+g1QQ8Y3FSKgy+ZqGZNcAAM4DSXeGyL0bjlJypVeAsbTBEu+aADD5qDHIm/6HWFGZHl2uoIyJ0OHSDJLcD1mhrFX3P1E9zWe4fAHnzb/n92q8hiy9Tp5FQ+wQgqqmdOWV3pmIwZzCsTsvcGIVWXuVAuI91fynG8N8pu7cFYe8SG70Pt0F34dcO7yvnzrrL08xQs7nfY850+vgIq6CsRgcA7Q4lixztcUBKKAtK3Euu29tg7rQwjovV+Ben7kSEnxu9EYhhWyVNqT71H7S4apdYvsR4K3G5nlMfr70jW9iw074a5kRK98Z+muF/zPRT8xQyr1kMcqbkji/8s+nZNAQ5TTg8r8pCZZXxQZ1xxGKNZ+AV/1iA8quQeHOAQQhflk5mcFnCruoXRddjEpyZowMJAqs21z2XCozZhWrRb32DZ14DH61TYZuqcFv1x9K+RzWTQ2x6Gple30cjc8Z4nqJoPZJ7CYBiVWaVxypMpTz0rQVavnupdWFjmpxBDwhV678pbidSBJESxZ9A6Y8oqhnThfuLM3SsxQ8AEJ/NYG+Ywfp2cgVZ2OD09nr9U86z9kEaIgtjQggPTW1o5oFMxJa1FbT9jBJXe0dPD6LFlP0F9N7wOoBYdjR3ouw734FEx5wI32gJCSuLN0XIPazByfSWH39By/nAthMZ2q6wm7pBuyJ2DafaaagCDQZlI2mERAUsonkri3CmWIuhIzQPHh8wl6JSfo1w8QREKV8FiZ4J5P8gbwPf7IP9IqOXzu6ow5QJkKXvDKZbQOQLU87SVutA3m6lstc7ApiaxSMt5maPVflLfmO027AYjB9TKlk9eeQp0aj6gOEedYmNX0FLVdTREGWPNoPOgrNCoqOqVBb6+P3NIr8Ps2ki5s4ChGq0tFnjsJXw2iAZlYLfFhx8Swk+05/gVQcs
 DEmuWDf7
 +obLOGmvEu+i04JG8xQdgDoS4AdvSFgB/BwtR+nNOa+O1Vlpy3C8MkITVrTxzkbEaHNr/fHtyjDlkx9TH34iuWLwiUGZXKpDfWXPlyh4wNrh+CLZ5HanhHthrTFTtaZcfSEpt75CWKzuWEBvVmXh6eJ3mqxLXObr/y7Duh+WFaiv9UaKNlSbcHX1spZpN5jZmccgJEXLfDp1tgY8IvBEvjS5FgqhwwvT9kT4o3jkSvDOuzWFPpRq2zrt+2ZCdSMTGeBGMPsgWexVj/lxjzrZeGaovM2bSkEW/OAXNCRG4gj6pAvRuAkQMM8G7rmdJFPU1yNccAZs13jETiLo2N0cYGzjBtPaldBPXAXBVb7Bg07mDJzV1gcHSP1T5FQ3QrpQu6vtRdTdZvxLcpJh2B1ZYxVvSm5MwIzklAmGll+MbQoLrBfZRPB9SFakOkUJ3l4qm2DoMVsmnTbDF0UQ99yoVVV3nUWny8a1FiIAoM/E+Sei/MLALoEAtoBE0D+is0IZ3E4UxS5ve4Ehb6DG8aMwrMTTBBprGxsq6XnSE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi John!

On 5/30/26 1:04 AM, John Hubbard wrote:
> On 5/28/26 10:57 PM, Sarthak Sharma wrote:
>> On 5/28/26 12:17 AM, Andrew Morton wrote:
>>> On Wed, 27 May 2026 19:54:27 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:
> ...
>> Thanks! I went through Sashiko's review.
>>
>> Both the points are valid but look very minor to me: one is a temporary
>> x86 build issue fixed by the next patch and the other is stricter
> 
> This is the sort of claim that an AI will make, in kernel code: "it's
> just a temporary build issue". I've seen this happen during sessions
> when I'm interrogating an AI about something.
> 
> Don't be misled by AI's evaluations, as unless it is guided very
> firmly (sashiko for example has fairly firm guidance, although still
> a work in progress) it will provide routinely terrible advice about
> how to deal with the kernel.
> 
> I'm sure we have something in the "how to contribute" docs that
> explain that patchsets must be bisectable and that there are no
> "minor" build "issues"!
> 
> I'd request that you study those docs and the surrounding ones,
> it won't take long and it will help immunize you against the
> various AI suggestions that seem to be unavoidable problems in
> 2026.
> 
> thanks,

Thanks for the guidance. You're right, I shouldn't have called it a
minor issue just because it was fixed in the next patch.

I have sent a fixup that moves the Makefile hunk from patch 3 to patch
2, so every patch is buildable on its own. If I need to send a v5 after
reviewer feedback, I'll fold this fixup into patch 2 directly.

