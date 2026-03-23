Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E8CEEC01CD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7766B008A; Mon, 23 Mar 2026 07:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8A36B008C; Mon, 23 Mar 2026 07:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4701E6B0092; Mon, 23 Mar 2026 07:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3938A6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:29:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC7F11A0B00
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:29:17 +0000 (UTC)
X-FDA: 84577106754.27.4885D32
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013023.outbound.protection.outlook.com [52.101.83.23])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7B9304000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:29:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=UKToJmyO;
	dkim=pass header.d=arm.com header.s=selector1 header.b=UKToJmyO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.83.23 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774265354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wIHB1oMbWLbe4R0frxOKV9z8n9T+IM7wv6QTVa3Q8M=;
	b=0jqnpTeXgLzIWcr+QpuWzp51hR8jHvCH9tXZIodoHeUToTp51oWoYJb7aI4RRybsXTKMxr
	B0x7U1uq4E2LNCmME3XRh95mKanQifTwC/myZAzJuAgfKTR8PjpRmMo28KRj6fPG328Edp
	X8ps1aUzwI1Uo42yyE+8rkuGeZFbTS8=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774265354; a=rsa-sha256;
	cv=pass;
	b=aBo2GuvCxwl6WQv8PFLByGW9ser9a3cDp7lY1NwPZ8w6rBpZN7yXRqXrJs1OaQrFZmwGZQ
	8fH0dgWV57mQchywRCJGenXgcHb/coW8O9EZ2H6EcGYMmn0tzrcbE5ExaPFt1wEHVNkx7l
	dOB5KtciX/qmRSNhNWTI4qCrOinb/sg=
ARC-Authentication-Results: i=3;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=UKToJmyO;
	dkim=pass header.d=arm.com header.s=selector1 header.b=UKToJmyO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.83.23 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BgToyAL1SH1aKcJZu1wYkqqsGH3iGzp/NR5D7jn1zbqL6ve9rI1xGBurG9NcBWca4YtjgbRtrWKKtOVr/p0XW8zOeNnAE5RQCkMsncRFp08Ywzc2VikGrM/58JLTLIeRtvbkPv1mHmKkON0hzJWWQRtO+PdrVqMzkBchQZdgZFfKhYUGCcj8CCmSFI4/P6SoJa+sM59w0Ve9d3PcPsD7pIoOctZ/gg69B4+QwOwje2YVceOenLdI1gxHFENRdfimDMyQ4NNM+s/pqvVx8xGbyJ4poIByUdEP0asS6CmNUbnMyVBK22c8uj2vzzBsgBlw/BR69PhIc+xwbyCo57/0eQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5wIHB1oMbWLbe4R0frxOKV9z8n9T+IM7wv6QTVa3Q8M=;
 b=a3iERnvI0fLIEvHV4ry07xvqGqrkkf4giz39BG8cxk7aaH5ExAR2jhYqMdtfRkzb8vpmSPurMTUEou3MU3gu5ZLundC4kWi6TgPryMdFfG6lFI/6jaO6cLV4p8aRcpBGoX28bGbJ+hdZT6QVY9ailvYqVCSxqLPDSRzW8XsxwxibttPjTJLG8+zdh8dPZ3hnFsxQwyT5QhycG6IYXG54wUsZ7mbtqDKnEyfMipl+/PuKOAWBr0Z+/scTC/UyjNkyz6eZxiIfZY6WRFYVnXRi76JoMN5rRMxkSfldIIXg1+RvVFq6LdvY5thnRmhT4z4T1UI76/PbxtnpOlISFzd3OQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wIHB1oMbWLbe4R0frxOKV9z8n9T+IM7wv6QTVa3Q8M=;
 b=UKToJmyO559/AtCZ4ftXet1FwiwY+ipH4VjHoeNC8Jal9Nv7MxSmHUgE8KXx4QdxSugT5Xf7s2NClzpLyak3PbCD9i05osPrJ7psTpojmZhCoC4OWRohR2OxehkJnHLiMCuO/uHwKQdyMGe3Tor4KJodYDb2tCjUd1m/mOYrVzc=
Received: from CWLP265CA0535.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:18d::7)
 by VI0PR08MB11688.eurprd08.prod.outlook.com (2603:10a6:800:325::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.25; Mon, 23 Mar
 2026 11:29:05 +0000
Received: from AMS1EPF00000090.eurprd05.prod.outlook.com
 (2603:10a6:400:18d:cafe::e5) by CWLP265CA0535.outlook.office365.com
 (2603:10a6:400:18d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 11:29:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000090.mail.protection.outlook.com (10.167.242.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Mon, 23 Mar 2026 11:29:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qPsglizUqImfUki2JrNWCljeEfstRfY85cG2jAy7VW2NCkDxr0Y4aG7QzQb6OMuBRbkl4QuyQzx6bKxt9pWMDPu6+oINwhOQgOa1pqdz4qhuOANUTiRa07X4pRjtW9iKeiHzD+GDbtUG3Ah5OZKIAg+f47jh1eVcNXgQx4MJ8f2DulCcvKL5Bajtt8uvoxOHQgA2shlV98lGjuvWiEKsrXWUTAbh4xaXRRwQappKaAG10Q+7ENTZPY6mwrM7d7UKU52ex3nsR/UMNeyCoVUdxzIZKpXdi+aQGNlyMGZnjQiaetRimtKeee4VRYA+IpIan2BPCQrze4lz4hUYxG6pLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5wIHB1oMbWLbe4R0frxOKV9z8n9T+IM7wv6QTVa3Q8M=;
 b=FG9hpq8pMSZ5kDLD5UiBReEDnAWWWU3eprMqQASHq3DKoH/20lUy0PGpJ/yqEeOOW7f0pJ1nCm97EpMFP53RrKHESuSg/7yYr7KLlwvu/7cf/xH0jZMZYvJYmxzkGvP5oo0utn8sBBw8K4sLz3BNWg1si4dUBqqD+JAVNbyCWNO5Et6X4qMpP9WmdONf3D1Vr36b+ho8KMBO6zrnYuEJ59FfmvBmw1PIOjd1IgdnyovqChIBl2JWlHh5qLDe5YIsTmirQ6WjROsZkuTMPsD6dAFw7qvWme4TgtNGgJVk4I8TPHYHGj+ksbWEU5rl0XKC9af0P6YPTt+0Ts1NaHsr2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wIHB1oMbWLbe4R0frxOKV9z8n9T+IM7wv6QTVa3Q8M=;
 b=UKToJmyO559/AtCZ4ftXet1FwiwY+ipH4VjHoeNC8Jal9Nv7MxSmHUgE8KXx4QdxSugT5Xf7s2NClzpLyak3PbCD9i05osPrJ7psTpojmZhCoC4OWRohR2OxehkJnHLiMCuO/uHwKQdyMGe3Tor4KJodYDb2tCjUd1m/mOYrVzc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by DBAPR08MB5765.eurprd08.prod.outlook.com (2603:10a6:10:1ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 11:28:01 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%4]) with mapi id 15.20.9632.017; Mon, 23 Mar 2026
 11:28:01 +0000
Message-ID: <4bb7285e-9303-4723-96e6-9c3fdbee7c38@arm.com>
Date: Mon, 23 Mar 2026 11:28:00 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
Subject: Re: [PATCH v2 2/3] vmalloc: Optimize vfree
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-3-usama.anjum@arm.com>
 <e59ab258-7331-412c-b490-657e32ec1fe0@kernel.org>
 <b7959d34-6e7d-45c2-a674-f32afd057068@kernel.org>
 <38379a16-d596-4266-ac3b-1dbee5356add@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <38379a16-d596-4266-ac3b-1dbee5356add@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0085.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:349::11) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|DBAPR08MB5765:EE_|AMS1EPF00000090:EE_|VI0PR08MB11688:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b3d7dc9-748a-4ba6-750f-08de88cf63f8
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 /EOHQ6XfIozj8prrwgd4u639YtzLRzm138D3jw9Y1s9kvxekvq0zjz/r8eD6rP50Jo9TxSlnLZcMxG7qXonPuvKsX6eq7s5au+pLHUZZ9VN2WnZguOoSkP6sD00f+xHU3lTHC4famglX3yXdyYmINazq3YuM24fR2umyEQmY5pVCoxdpHyS6H0mzJephYSy3zkK3ncTn1A5/3TDiu4GREueygsBGMntWKhwUnKzQybRZ5QxmXCO623Tj3RH2WbPWAFgEtteHY/FsuG2kctQI7RlJxCoYKKWdu0zwfDvHPZqg6uWr75jRknnJAOoOye3+Qvrfv5doE2XRbwaTU5JanvEifcrK4Cnno+A1Uz7g0un+3Oo9YBbLiEexvQ9O3eU9wNjnuQcAAT8sxmhqnq+i09VgUBN5x6AE/epPpscwVAyiu54WOEOUjpJYNxvQeQJYlgpXRz9F8286tfFQjfBHKYr24U5+hEoa1pADyjn7/xzEUsy7FsZbik102Wr8kvmaRk4vscrOxzH0cmWtSl9Sz8M2nqL5ti3XeJLJIIJEQRjpC/GzIzR1uz8rFogMVG9H4SDUBBSR64M9zODjyJwNt2PoPKUl7DBq7iO1f6i4RpwNiYh7REUbRhYw8KZRONG0LbQN5sgO3JtNs2BksHF5aByWoXzW8u0EaJ93KXGLTYI09UPADa1+v6UsatiZjg3JNOxQnz26UZAbfWE6hJT7vTbEfuk8OK7NqPJY5yjd3Rc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 Kz3kQWsZ1LUIU/7I4yq48/ug9NWP0tGpyUGjYhC8JKNgIXjc6j8nbs75hT6vG1vrg1WeG7641MVezC7ILh6tFSMK1y13UB79WqAt76x4sMIBjDbJUBfGpRqjVgryEhleJOlVAzITspawTEiu5DyKxz6k8AJ5FTJ2GqaWEoV/mY4d+atoxF/4lOVb2TPccDhUOZEoaysIayeJVl7yIgds8T7rBmIDagO42tLFNYk4zM3f+J9B3qFh94YahwZvMP95D5jLvYfQGdQEvBXl0UHswrLjpNWW+VKy7HQuNeU9z2E9JfRoraecli6/ZEoX8UG0PYJrOyFNHHn8eM7coIrL8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5765
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000090.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0b8fcfea-98c9-4fd0-0138-08de88cf3e09
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700016|30052699003|376014|14060799003|35042699022|82310400026|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ybYrW5SPpW72ejJ6mo7MA/RGcoOfHYLcW/gq1QNG+9M4Zh2RkCbUmiuHN3Sr/GLTJ6fJBWuUvDBhRAB4d8h++M3wBrVCP54jly1olWAif3GR4EobgOUG6PVeix7QmPkIwaErYOHK9uOYwAjYJjH8u7SYroMI+FtsvRIBrJJjNLoNzhbNrd3An+7Widq+yScltjo6xVCvPcuSgFU9f9Sx5pPR8SfO522+GhfekoXDHjfmjMUwtwbRm4T18je8zymBUNahLYvZ7XETBV5U2jFAmOSaETphEYgsXk7gj4p7nbZYGn00OMw9xUR8KqViGHKfnezklTepUP8evF2uBbIEKfZG9vaYFqzuwowH9gKDJjihwlf31GkM9/gLvtACl5m9TzFgDVRFGpzRSuMjWpv7W3uyrQ9+W8xeD6pb19cOGYZSxvUWAN6ZSFJ/HhpbmO9uMQdYudvDqgy9wkbEO6fZefpkkaaSBaFQIXGzBBSkahSj5wAraB03s/zUbZ/oQ/Efr9IxMM7KA5sDMPo73kwKZcS/AjFcgGQnX5SUFaujC+9UgydiATZd+rL13bzLxaCAK8/uBa5JVD3up+4v1WcNxeBwJDM6lt28Sv9N07sxQ9aM0S/A94bmMD483P2ZBk8udYVq+A9Nvs0gkmDYvORjlFE96XCHjqFgQ8bT/9bGkrQonAyBtlWBQKK1bOhV40T0pw50dmKxNU8btHDa9hTwCn2xqDjOZ2uxHO9qPleUxrMQUmcR27wW2aOBREd/tLinKbdXuIq/XpReLIO5KMV+LA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700016)(30052699003)(376014)(14060799003)(35042699022)(82310400026)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Dlj0oVE2kTn/S26TJ9yky4+aO33lyhPY0KJJf8S1EJed7XdNuikmubK2GbssfjAL+SMWtHcf1wVEKb/rxi6SFmJ9vniSVhYCjj/r5Bl+2BvxuYsjAaXEZDAApiiWRgJIgk4guq0iS7tckQSx20U+STRhMuGZqbXBaZ8NVT/McwuM1bUjlJs4XSpwWhJmMuo2SeZbg1WoYxWcLJ21NXdMHRRxIh58P15k9sljVbXQB4zBHAOlaxEWeIA86fGfHYbTA7DmXmrkAGh79K0Gg1JGOlN1k0QK9uJWpVw/QVebu3LCH8ITUnBEJwhu159EbgHkFMDNRT84D80L0f52HfINFw/NA9qmj/GeCJEa9nNVT6DSBjaD6ldI60iQYGTk5LhncxtHwCKOVEJts7zDZnPTrGrwZ9GHTwV8aKm7rumwGnWgILcesk9cyP/H97GGczIS
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 11:29:04.9004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b3d7dc9-748a-4ba6-750f-08de88cf63f8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000090.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11688
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7B9304000D
X-Stat-Signature: rtjzomfbpecyqc5bisfb4ebmh55hkoan
X-Rspam-User: 
X-HE-Tag: 1774265353-181941
X-HE-Meta: U2FsdGVkX1/inIeyFbeLiIcnkkmck6x0ODwfN5hJm82stj//9pExhgDcZovd60IzxLEny29EYzSzc4H4JlLlcecsFojEqG/BJFKXN+Ha7nVj7gjQoB0q3MfpEl+EwOY7RyL2rZID1fDYNkeA7kNgwmqqla5hf9LMsMPB4+KKaa9AmEjJBQ5/7jioxL2XsXa2o2iBWH8yPEFJs0cONKF7KUU4F+g9jq1lSLIMBza7Ih2LB1WCID97U/lqgqHg2gBsDQgHpPSwQzIFlhcYbQkh98ZEYvXAyLvP1lZ+4lgACz8YpsixKzpudkrDeBmsaYq0gJv7VYv6lWoG2OYLQ1pqupsePkLnBF3wNVcvqTR2andvJA+CkRxByKvG9qDlsHGPTIEiyVrXpk0T/1N7xeICcxfED9/gEe4Jas7wnNrhOFqoNYBOatvOS8im3V5hRAeB3Koa87xzIDFxELwHFSsaVKtcdC0HbM9YSnjUDBIUERcH9L7foNd7BARexpFCkSCostotV/uDHG1OrNTBRdes58fgHFavwnGNBoJqOWqyodYXceBXC5ZN7+zVLW/7G6FVJa9oKQdojAKWvJylMfgX/sjDzAqSR3Wvh65E4bHEyOAUigBzDlphnMxahgA0OqBu+Licich8TfSHdzThWEnjTQPYVo1tDbl2TCpKfTHFPEzz0MUvmGDqq8l/+1Hp9B/455bNc7GPQ5hAhVHwlnNDzjndH1zeZNaQu83ecsTkMh4tSGebVA+m/2cnRN0igJbS8QovOa016TYj/eWA32QR/5CdhbYFYUrQYxVY6EP3UOfzOxplfRp1Sfpc5V+CuXbR9FHmC04+6bmgtp1e9H0LV3uh0Conpiosyrds46ijDzBDF2c1xo9pOsm6Rl1x7RBBYGqwyIFnyJ3C4e3IYC66FvySv+aGKsJcuxBydAdPgZYg95VSHtxd/vQOhGcwG7DoQGIkFq3QJeG8y2+jp/a
 Sq7ZkHl3
 KDLXQgMfhv5GqafxCgA5h86p7MxoLlQ0hAOT4dHJslwjuMI588D4ZgqBz5U24E6EirAzkZTp7sOr0BTB+YTmgV2BTHZ3ATvKlLUECY/pYscLXpMz3BzeevlQi26R6IIKmMqjHvMaiLPMZGc01/isjtI05WooIuyFcrMw4EpMJAeUv3juppnLen0ioV92hsGzl8hItUuba1ILoVNlWncMl6KJe25Q6RzTyfIW/PkYu4P/Ifw+GHcFCvyfH+GLcRIZKAaAsn9Y5L3J+Li6171q78VMkCiwzaJB6SGPBzCyK9KZj5xLvSDQHuZotl/yCg2sJ7HeSO9hCILxAb6rL2LuGgRverPu0DTdCSrDWNNnhiW7cYUPYAQZx1bBZiD/YkzgclfTgVVmPHSQIvDCAnmETDSpOggSCyALtrqen5pOwa+SXXB4gjC2ZZZliXze46Su24vHzOR/Lr3/X5SsPYKCV/JhurnIAw4KK+ZTI+AbhZVS5bIpAbn8p23Pcx9TuM6zdTOg3yBa3wUPXcKO6AhYAjADOec3aACbsSi25vKZ8dvd9pTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/03/2026 2:33 pm, Vlastimil Babka (SUSE) wrote:
> On 3/20/26 09:39, David Hildenbrand (Arm) wrote:
>> On 3/16/26 16:49, Vlastimil Babka wrote:
>>>>  mm/vmalloc.c | 34 +++++++++++++++++++++++++---------
>>>>  1 file changed, 25 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>>> index c607307c657a6..8b935395fb068 100644
>>>> --- a/mm/vmalloc.c
>>>> +++ b/mm/vmalloc.c
>>>> @@ -3459,18 +3459,34 @@ void vfree(const void *addr)
>>>>  
>>>>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>>>>  		vm_reset_perms(vm);
>>>> -	for (i = 0; i < vm->nr_pages; i++) {
>>>> -		struct page *page = vm->pages[i];
>>>> +
>>>> +	if (vm->nr_pages) {
>>>> +		bool account = !(vm->flags & VM_MAP_PUT_PAGES);
>>>> +		unsigned long start_pfn, pfn;
>>>> +		struct page *page = vm->pages[0];
>>>> +		int nr = 1;
>>>>  
>>>>  		BUG_ON(!page);
>>>> -		/*
>>>> -		 * High-order allocs for huge vmallocs are split, so
>>>> -		 * can be freed as an array of order-0 allocations
>>>> -		 */
>>>> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
>>>> +		start_pfn = page_to_pfn(page);
>>>> +		if (account)
>>>>  			mod_lruvec_page_state(page, NR_VMALLOC, -1);
>>>> -		__free_page(page);
>>>> -		cond_resched();
>>>> +
>>>> +		for (i = 1; i < vm->nr_pages; i++) {
>>>> +			page = vm->pages[i];
>>>> +			BUG_ON(!page);
>>>
>>> We shouldn't be adding BUG_ON()'s. Rather demote also the pre-existing one
>>> to VM_WARN_ON_ONCE() and skip gracefully.
>>>
>>>> +			if (account)
>>>> +				mod_lruvec_page_state(page, NR_VMALLOC, -1);
>>>
>>> I think we should be able to batch this too to use "nr"?
>>
>> Are we sure that pages cannot cross nodes etc? It could happen that we
>> have a contig range that spans zones/nodes/etc ...
> 
> Hmm single order-3 allocation can't but we could be unlucky and get the last
> order-3 from zone X and first order-3 from adjacent zone Y.
> In that case the loop would need to also check same zone/node.
> 
>> Anyhow, should we try to decouple both things, providing a
>> core-mm function to do the page freeing?
>>
>> We do have something similar, optimized unpinning of large folios,
>> in unpin_user_pages_dirty_lock(). This here is a bit different.
>>
>>
>> So what I am thinking about for this code here to do:
>>
>> 	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
>> 		for (i = 0; i < vm->nr_pages; i++)
>> 			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
>> 	}
>> 	free_pages_bulk(vm->pages, vm->nr_pages);
>>
>>
>> We could optimize the first loop to do batching where possible as well.
>>
>>
>> free_pages_bulk() would match alloc_pages_bulk()
>>
>> 	void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>>
>> Internally we'd do the contig handling.
>>
>> Was that already discussed?
> 
> AFAIU some of Zi's replies hinted at this direction. It would make sense, yeah.

I'm updating and will send next version.

Thanks,
Usama



