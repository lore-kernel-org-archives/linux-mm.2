Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 174F8FF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 06:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348726B0088; Tue, 28 Apr 2026 02:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D44E6B008A; Tue, 28 Apr 2026 02:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14ECB6B008C; Tue, 28 Apr 2026 02:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9FAC6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:35:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F1298BBD6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:35:52 +0000 (UTC)
X-FDA: 84707004144.09.2A026F6
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013016.outbound.protection.outlook.com [52.101.72.16])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1DB76140002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:35:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=hjj39yF6;
	dkim=pass header.d=arm.com header.s=selector1 header.b=hjj39yF6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.16 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777358148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IU6gxJonDogyBuLtLrTcK1eXNyqGnbXbncAypgq4Ues=;
	b=FnPSx5/+tjb9lOVWNqHjFc/ioMu+LTI4IiCypePfCkO113qzB6RT1Ts3wy2/EVxyK99fEM
	PSyP70gP7Sexv3fd/R0IMMbNxgpdpKxN/lmIEJEbznefg51kSITTFHxv5L7fQhxHbC+yZb
	RVPIDCbjWF7ZOe56docV4g24c3BoiP4=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777358148; a=rsa-sha256;
	cv=pass;
	b=b4BAkREPDhdcP2t4s3yZlNd5zxzDKODalgFtmP2l7OtR0RvkFk3J0u91WIXxGA8hX+RWhn
	l76Hf11/xM178pdd8VrxX/vJA5riUvz9lOeUdwrjbVyxiH8sOrhZjTGuVlQT+RmgD1c8mI
	tkJs40DyXTXgg0ABMJg/CcK8MjoCte8=
ARC-Authentication-Results: i=3;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=hjj39yF6;
	dkim=pass header.d=arm.com header.s=selector1 header.b=hjj39yF6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.16 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ivAaFMs8YE6USsbhFopGGhHZiYGnBcUB71l/U/lZd10DsSfJdoRJ5gfEoeXi6s/IRQHs4llNjKh2/5q3H5NewWprdI94NNecrnh9eqEAmr0lVgJOr7cd6bhU933tzGZ12L9Tw4ykeR0dRoIaN3iI4XvHzSe0svVKNp0OMTJN0YvyqPQXjxFNTB8N/L1R0NIi/phUjxGB/rBlYukJ+9zt/zaJlXT+7sC5XJ1eE7LURqLhv30xm+qzT8X/bxO0F4gfu19qrdvShNOv9X1asfeIJZQ9LpLRmDAgZaahAvv7H8Mw6rb9LwQOjm1HlcL3RwM8soO2EVMLJJtMtWJd7RAEwA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IU6gxJonDogyBuLtLrTcK1eXNyqGnbXbncAypgq4Ues=;
 b=mv/WFAYaZc4scNjIVfHgwodB6gH+LogMIOGyBjPLS54qY1VzOGcWikkXM9ZTE+7W5W4spOn3gsJbwTSg/PTW9/NAL1gw/Gm24odRBQeyMG35sCoyf5yye8m6N5D3LQiZwphj4n4iOWzcFC90Y7NIDACTyc9oNmJ7uwBJ12gH5emim6LfLLSqOKswCvpqaqM5nUJW0yGgk/Af0xIMbzRJLovjlbIPzCZQgLOgoM7Zj6AxUw3fjfw/NW64ivVkLCecLfn6IFy3AI2IRH0dRniQkFdjQbMH38KbFxTQ9Q7T+YnoK6GUYrtCl4FuOMqi6TMEL6wdevvXsZpv71BEs10MIg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IU6gxJonDogyBuLtLrTcK1eXNyqGnbXbncAypgq4Ues=;
 b=hjj39yF6THe7m8NnOuSB3ZkD06zXC/xMF63nGIZkeT6l/dvwV28YKjNBBoqArCy6lKJp18EUeeQva6+XOb47gz8E5IY4xsQMHSSuQUYwDlncLNsOD5y2YY5dUk9bkHp3ZvYe3+gz0fjCNfLq0O4hlLCMtOs/F/D+WfMjM2pIRoA=
Received: from CWLP265CA0450.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1b7::23)
 by MI3PR08MB11908.eurprd08.prod.outlook.com (2603:10a6:290:74::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 06:35:42 +0000
Received: from AMS1EPF0000004E.eurprd04.prod.outlook.com
 (2603:10a6:400:1b7:cafe::3) by CWLP265CA0450.outlook.office365.com
 (2603:10a6:400:1b7::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Tue,
 28 Apr 2026 06:35:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004E.mail.protection.outlook.com (10.167.16.139) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Tue, 28 Apr 2026 06:35:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jgTl+lMlXSSIF67Dk5xsXuFnAw4TXjoJlQjf3QR9WVsCTFI0O7YTYx32dO5ZEMS6VXYQJv8ICbVg3V6BNmOfflsy4t585daJuGuh3umgoVc0l9iO0zqpLYgOtezwBk4bwTwIzujaCCCWuX5A1UAYYhNJBEXawCLkPciSsALNB6XtaynYvgNuZOX/qNqkqygRt8ERoo5Bipou97OeIw88E0Rz6HJgUPlCZXwYukBzkt3tv6OdzhT1EwFLQ+zTJznIu7XSrKLucwK0KEpJdX5gfNzXdGwwaHLaowVIRvLT1mSZKmEKGT09FjiIVX7KSJfR8SWS+rlqlzaV3YkkPgk4mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IU6gxJonDogyBuLtLrTcK1eXNyqGnbXbncAypgq4Ues=;
 b=AXfvyDU4g9zt81fm63/K1n9XvE5Qb6B9tQI4AWUAwpl6e5bGk1X78UveQ4Nvi6rTruZTfVe7rMrwXfOXkMRM0c1YPSxEfRuND7SYp5lF3iHb3k8GruISR1b9CsXugLwhpNx0HnVdAJBI1CukJ5oOKz8NEUOZgad7MgTDTCfvDW3u8H5F2xFdMLJyJT4D1l95zvaRGVV1BQeXJars1iNDZEHRtpsg4a0+KGnAr19mI6gkXTAz8lCpeGRp+vCC5wy9HMadHI+DuYZnHlrJDaFZXPaGabBCAhkg+uIPHA8IX354eTREANR2mryZEl3RqFQfpY/21oLx9BmyX43ttlFLyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IU6gxJonDogyBuLtLrTcK1eXNyqGnbXbncAypgq4Ues=;
 b=hjj39yF6THe7m8NnOuSB3ZkD06zXC/xMF63nGIZkeT6l/dvwV28YKjNBBoqArCy6lKJp18EUeeQva6+XOb47gz8E5IY4xsQMHSSuQUYwDlncLNsOD5y2YY5dUk9bkHp3ZvYe3+gz0fjCNfLq0O4hlLCMtOs/F/D+WfMjM2pIRoA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by GV1PR08MB10907.eurprd08.prod.outlook.com (2603:10a6:150:1ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 06:34:34 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 06:34:34 +0000
Message-ID: <9f866cae-4850-416e-9d4f-4ee00dd197f1@arm.com>
Date: Tue, 28 Apr 2026 12:04:25 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/53] selftests/mm: hugetlb-read-hwpoison: use
 kselftest framework
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-12-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260418105539.1261536-12-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0125.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1d5::16) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|GV1PR08MB10907:EE_|AMS1EPF0000004E:EE_|MI3PR08MB11908:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fd8979c-6c3d-46c4-ba18-08dea4f05e94
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 KYMJ+ZhDws+lY1Wc/IExugrcGQqdiuoJAouYZgEjQ9cKmXAvFz67msxrACh9Uw30zStyX3RD3aPxF1hwZBQHXVPKvQNzcJc6r0rEwc6kF9hGKdnafCOoE5IoMTK7hWYdqLlICrzLKcvogWf2pFwxR8ATXkhYgECwt1QYoAzoAowvMiq0Cz/zpJ9GGODBGHTP/2qDa2QxXgBfiaRA9zCUAKKYC5kFXGxDETiVpdU7OSXHgfd5AY3g11xJhsRRV4BkpUPXe6D63lA2HBdjLozS3Gx12QBP1BuFTliXl3U/91uFnjQ2b1JIeB2PDzxBE50eGakQXL/2DWpocc+1+wUJyo0uHyzERe0KF3wQVUznh2wkU/gndxzd8I+VkZjGHuf11Xkv7ubEFLoIHvdy6+L0D0vqar+IG9fuW4aBglUgY0Swst1uTze3QfKPCa5LSlZtuT4kKriPvbu5/K9fZrSnrNVVnFHzqwl9+UxLJ861DxU+JvCRqYIYV5m/3bayHzfsdxy0VLY3W+KZRaSscpVszuK2EG+oq0Hjti8/PW3/qIzukRhJie7Xb1AkUglzIjV0syblbzS9cFpptj0IputE2hsr29WF7Ac77/jpeFwVoItjqeIA+DuviiDXzXygBcN6aAJXUm8dgM/2Tp/Q3E646secsemOcDy7SGZF+i2ya8cnJH9eYDv6LYVsWCNaFNF3lyKnLKA5eRw45CV1QQfRFndVaTrjxLP5K0sfO3L6eMA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 enmaGC0cEVqx0CsRXaJcF8FB8/yKUUaSUQZtYVMlSxIARjUlBgWQNJW0bJSnitVb1chsP+8wXnhO4zTBh419jj27oc5Vkd3hI4lz9k8N5FcJXjZrTsd111QTWPsFamL37Z48rU+QW+sPKuRQ72x2hBFzkk6A/trr7cg1nDf1EmX6ISTS03ZdwtnX2r0WDhm9N2expU5BHq77I+3qrb7FylLXZFUAMMCEFdccmxTveQnLbbIgVQSQ/XvnDCxhbFe4b4JBj+Zj6BIqZb8LYXv3SjbJw7cOAZK3Xolpsxe3FBz6Q73JkkLfku5qGQQL349rjZSuIvuxxj9CpYcZK319Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10907
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a84d8ff5-9bfa-43c6-468a-08dea4f035d3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|36860700016|14060799003|82310400026|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KuY2ABOQkEjgSBZoPxsIkPTqbfzP9hUhuqVc7jIsoDmzrkoMXFV/IB0B7bp7afxopKCGv2ABAllOBWf/U1WjZe/jhsbMT4FVyzK5i3wYQDws1c6pqrDFSOQAvjN7NAErrYs3GmSnC6uKTvsR9oJU+x30SClVrr+p4v8z8Kbj83YqmVgrua3NZdVzBkZy7wOqxCOdH92yxlE5bBNbfrJogFhJg7AuV6Xx3X8P1x+VSB7X79PO2o17uugvVfXpFud5oKvlu748vC6OqXb+PbqCBdEqj4kMTRcBVltU53tMnx8amLeX62v63AHM26uRpTmjHYSlusROzf2ni5nmXC/O6ldjF7TL//hlCH9PwOpoFjRE8dNTZy0ImUlgjy0WqJ1z1Z827FYCRfnAc8k+Kxj3ZeJawEiUlOwluK5QAeb/Fcw8dMI+AFod0Mqzd5rFE1y9BYHMoYUGrWcrq/d0G/XyAywsuHDZXRUK5oZq5LjBGQbez0Q2yVEUqRFowRPviqQZzHEHdkr/yhw2EVhdwVGSv7gpva8dzv3+zzfRl3IFK+/Y8q7mT3w6CEdcoEePE4oL8HwVR+emgqNiPD2s1M7y280eahvpLmkTjPsJ1MA7ckyzc9KicH9D4wQ8mT47lW+uWKMPBDqAMWFNvG03bOv8+vVj6nYGw8f2oNGILyIM9NLMGlubRJAU9f5Aphz3D4Td5ZLgHQXyIUebUFW9gpdK4oei8h41fgiRPicUCy7ro533+z5c7lL0PtkDrnHSUwiI6UO4gga8vk4VVzWbKvsnjQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(36860700016)(14060799003)(82310400026)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rKn3PgwhI6nWtyQa0Gy8CCAeaAfNDuAAjbLQPk+uLfWg0asgnodELPsTaO7RYWKVT1elz5wyHpjam0d8exuNfB++VdEyvHNScjaMRELt4rZwAavFZ97IMMzzWiWRZBvaQDYauFDhS5BxqZ1gB4oPQHLWkuk6g0uF2JFd1q4gU/0jx/ECUzdoJXcwDU+34g0bAlIET3ZVNRZJohz8ymbUTZoeXd+/qqk06oLgR4hGExbNVSHBCZNje3k8V4nK7LYvnkn6cXPo0VyoKQkc6/7urbgRZnCUMQXv5Nxiz9dnMJwNn6Bi5hO1P4gD/g5sSQ9tHIfQymgUGhCU04cKZYef0UzPZ52oR/rkowNj1rAYp12Xz3wFzT25NHV7vQC+FgmFuUK4uGxCbB7SiDcCha+fVfbeiuqCZIcj6jQQCBRdTkoy9yg1B+D3WqUEASCzWpzb
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 06:35:41.8116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fd8979c-6c3d-46c4-ba18-08dea4f05e94
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MI3PR08MB11908
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DB76140002
X-Rspamd-Server: rspam04
X-Stat-Signature: kgzdsk9u7r4hn9qezhopasurfojiehry
X-HE-Tag: 1777358147-907055
X-HE-Meta: U2FsdGVkX19h/4FciueC/OAx0wHvSkLNSmZ7y80Jb45HssEKtRucdph3QVLUSXI6mubCmwmUf8YiD4WM2HN2EX9rLrqry9/+tOPcbVn5Pm/qc8QV9qKXkqnAXMI6iGT0hPDxNgJhUarTvnvMeExRM48MZSx6OOKQtcH+BUmEUS0B8rXr3ZT5UfgrPDQkr417ZNL53xTGHh2s32ie90k3VK4yb1otu5Cb30pJUunAQM9ttohk9JQ7y8xEJ4/WI8C/hDGMfJywG6pnwFnb974bFMIRag/kwSmUg052/G5curP98cGh9ZoXVIriBBIIPzfmo0T9rQcO2MKHB/mbTCi4ZhRZjLiUDKvZiVj2l8I+3Oq6sMoPIkkFoqPrEKAoEazFJ8i8rTrjphcfzXTeP0+Y0n0kFyw1Wv3TmAML0mQcpyC8ad5X5twBbRqbYv5ic4Np8bTn98tIuo5O+RX0173jfeBDWZHSv41Sx0SgylEa+51uEtzZsiSZZKJLVBQO2Z+di0u7cFqHOksWzD5FSKGSap8ezbjC2squJyP4lT7/5r3JPgX9m9+ExxnNPdnbEmvo9IPyeI88eKhb10u8giJ1gHqM8f3rFL5lMHXxGiTVEUkySLrSW6Buea5aZQt+itygUmFCD1wNVhvHTxZJfas4jgv/UNrWQ5ovGT29w8wAjCKNHmm4raOldkPbVWGathAGmky7yO79N4orp6AaqhQQfSh/AC7uz19d+DGkklQU6Zx3qn3AnqpNbAiFtsvjZw+O+P4GxpWcIG6gRyV6OyTmLOzPfORkEu+Iq4SWBiIlvJGTxAgiluHDKBZ5lhS2hswXRi4JLtqefq51zL6sx6azkqiuJJEGoL2XSfNcKhNVV4/FQNswbHpEqNcLbZVNK7SRgLD6I25t2G9B9bq6GiC8+x4TOatg/Vdl1TP4fQPHICyC9SdF5lw6+VOmoJhleN1OO9q9faIMvKjSPsS6I7O
 rboKs8m0
 gbJerp36NOd4G6LheW262Z76KJuvFu5A3bXygt9zUhg+152OoY5nR9QTR3wmWqqYeKxv5qHrstqiUqPr8cVDaru8fFjTVPJ0+nlJjO6AKeI+WBTTOIXFvUKkKucOgzwQhm8xqUGU7xlNC3KjaWFxZSrEF0hhjCX/UeZ0Up1zNFbna2ErLUtNaO/MfiVEGT6O5SlIZybZYoKYt2WDz04KQTZaE+WTcA1t0t6ATLFAz4rmEL4llay2jPszdgFgsXLfiQv+EBpkBwSlRHbGYwKe1atTrhaJbKwAM6rXIF2TtnT+egzqQFCbxQjwNm5EXM6lvEnS/DQCpzoFRMnL5f4ohpIejqa1NXQ+vTHTeIAkJQT5SRmbWu0sv7UEIqO1qmzfbxAc4n8H0eU0SzvEjk7+SXjhqaibzrI0kee8W+sT6PXZgee91k5SzSgbDIQ0HysSopKKfyC9/r3Bn+8KCMgjwa2tnN6vayRQtioGQZMQbci4NZfB/xpl02b8ytwdWT6AMYKnAIdaitWuhSOIdIImMtqhLRHIEAU3di83Ecvt/OdXnnKzJD7BAeL81hWTb36M0fs++dATUptreRGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/18/26 4:24 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Convert hugetlb-read-hwpoison test to use kselftest framework for
> reporting and tracking successful and failing runs.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Reviewed by: Donet Tom <donettom@linux.ibm.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

I ran the test before and after applying the patch. The patch
correctly formats the output according to KTAP format with no change in
results.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

>  .../selftests/mm/hugetlb-read-hwpoison.c      | 118 +++++++++---------
>  1 file changed, 57 insertions(+), 61 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
> index 6bbf15f78061..01cd5465e0f8 100644
> --- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
> +++ b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
> @@ -13,9 +13,7 @@
>  #include <signal.h>
>  
>  #include "kselftest.h"
> -
> -#define PREFIX " ... "
> -#define ERROR_PREFIX " !!! "
> +#include "vm_util.h"
>  
>  #define MAX_WRITE_READ_CHUNK_SIZE (getpagesize() * 16)
>  #define MAX(a, b) (((a) > (b)) ? (a) : (b))
> @@ -26,17 +24,22 @@ enum test_status {
>  	TEST_SKIPPED = 2,
>  };
>  
> -static char *status_to_str(enum test_status status)
> +static void report_status(enum test_status status, const char *test_name,
> +			  size_t chunk_size)
>  {
>  	switch (status) {
>  	case TEST_PASSED:
> -		return "TEST_PASSED";
> +		ksft_test_result_pass("%s chunk_size=0x%lx\n",
> +				      test_name, chunk_size);
> +		break;
>  	case TEST_FAILED:
> -		return "TEST_FAILED";
> +		ksft_test_result_fail("%s chunk_size=0x%lx\n",
> +				      test_name, chunk_size);
> +		break;
>  	case TEST_SKIPPED:
> -		return "TEST_SKIPPED";
> -	default:
> -		return "TEST_???";
> +		ksft_test_result_skip("%s chunk_size=0x%lx\n",
> +				      test_name, chunk_size);
> +		break;
>  	}
>  }
>  
> @@ -59,8 +62,8 @@ static bool verify_chunk(char *buf, size_t len, char val)
>  
>  	for (i = 0; i < len; ++i) {
>  		if (buf[i] != val) {
> -			printf(PREFIX ERROR_PREFIX "check fail: buf[%lu] = %u != %u\n",
> -				i, buf[i], val);
> +			ksft_print_msg("check fail: buf[%lu] = %u != %u\n",
> +				       i, buf[i], val);
>  			return false;
>  		}
>  	}
> @@ -76,21 +79,21 @@ static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
>  	ssize_t total_ret_count = 0;
>  	char val = offset / wr_chunk_size + offset % wr_chunk_size;
>  
> -	printf(PREFIX PREFIX "init val=%u with offset=0x%lx\n", val, offset);
> -	printf(PREFIX PREFIX "expect to read 0x%lx bytes of data in total\n",
> -	       expected);
> +	ksft_print_msg("init val=%u with offset=0x%lx\n", val, offset);
> +	ksft_print_msg("expect to read 0x%lx bytes of data in total\n",
> +		       expected);
>  	if (lseek(fd, offset, SEEK_SET) < 0) {
> -		perror(PREFIX ERROR_PREFIX "seek failed");
> +		ksft_perror("seek failed");
>  		return false;
>  	}
>  
>  	while (offset + total_ret_count < len) {
>  		ret_count = read(fd, buf, wr_chunk_size);
>  		if (ret_count == 0) {
> -			printf(PREFIX PREFIX "read reach end of the file\n");
> +			ksft_print_msg("read reach end of the file\n");
>  			break;
>  		} else if (ret_count < 0) {
> -			perror(PREFIX ERROR_PREFIX "read failed");
> +			ksft_perror("read failed");
>  			break;
>  		}
>  		++val;
> @@ -99,8 +102,8 @@ static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
>  
>  		total_ret_count += ret_count;
>  	}
> -	printf(PREFIX PREFIX "actually read 0x%lx bytes of data in total\n",
> -	       total_ret_count);
> +	ksft_print_msg("actually read 0x%lx bytes of data in total\n",
> +		       total_ret_count);
>  
>  	return total_ret_count == expected;
>  }
> @@ -113,15 +116,15 @@ static bool read_hugepage_filemap(int fd, size_t len,
>  	ssize_t total_ret_count = 0;
>  	char val = 0;
>  
> -	printf(PREFIX PREFIX "expect to read 0x%lx bytes of data in total\n",
> -	       expected);
> +	ksft_print_msg("expect to read 0x%lx bytes of data in total\n",
> +		       expected);
>  	while (total_ret_count < len) {
>  		ret_count = read(fd, buf, wr_chunk_size);
>  		if (ret_count == 0) {
> -			printf(PREFIX PREFIX "read reach end of the file\n");
> +			ksft_print_msg("read reach end of the file\n");
>  			break;
>  		} else if (ret_count < 0) {
> -			perror(PREFIX ERROR_PREFIX "read failed");
> +			ksft_perror("read failed");
>  			break;
>  		}
>  		++val;
> @@ -130,8 +133,8 @@ static bool read_hugepage_filemap(int fd, size_t len,
>  
>  		total_ret_count += ret_count;
>  	}
> -	printf(PREFIX PREFIX "actually read 0x%lx bytes of data in total\n",
> -	       total_ret_count);
> +	ksft_print_msg("actually read 0x%lx bytes of data in total\n",
> +		       total_ret_count);
>  
>  	return total_ret_count == expected;
>  }
> @@ -143,14 +146,14 @@ test_hugetlb_read(int fd, size_t len, size_t wr_chunk_size)
>  	char *filemap = NULL;
>  
>  	if (ftruncate(fd, len) < 0) {
> -		perror(PREFIX ERROR_PREFIX "ftruncate failed");
> +		ksft_perror("ftruncate failed");
>  		return status;
>  	}
>  
>  	filemap = mmap(NULL, len, PROT_READ | PROT_WRITE,
>  		       MAP_SHARED | MAP_POPULATE, fd, 0);
>  	if (filemap == MAP_FAILED) {
> -		perror(PREFIX ERROR_PREFIX "mmap for primary mapping failed");
> +		ksft_perror("mmap for primary mapping failed");
>  		goto done;
>  	}
>  
> @@ -163,7 +166,7 @@ test_hugetlb_read(int fd, size_t len, size_t wr_chunk_size)
>  	munmap(filemap, len);
>  done:
>  	if (ftruncate(fd, 0) < 0) {
> -		perror(PREFIX ERROR_PREFIX "ftruncate back to 0 failed");
> +		ksft_perror("ftruncate back to 0 failed");
>  		status = TEST_FAILED;
>  	}
>  
> @@ -180,14 +183,14 @@ test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
>  	const unsigned long pagesize = getpagesize();
>  
>  	if (ftruncate(fd, len) < 0) {
> -		perror(PREFIX ERROR_PREFIX "ftruncate failed");
> +		ksft_perror("ftruncate failed");
>  		return status;
>  	}
>  
>  	filemap = mmap(NULL, len, PROT_READ | PROT_WRITE,
>  		       MAP_SHARED | MAP_POPULATE, fd, 0);
>  	if (filemap == MAP_FAILED) {
> -		perror(PREFIX ERROR_PREFIX "mmap for primary mapping failed");
> +		ksft_perror("mmap for primary mapping failed");
>  		goto done;
>  	}
>  
> @@ -202,7 +205,7 @@ test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
>  	 */
>  	hwp_addr = filemap + len / 2 + pagesize;
>  	if (madvise(hwp_addr, pagesize, MADV_HWPOISON) < 0) {
> -		perror(PREFIX ERROR_PREFIX "MADV_HWPOISON failed");
> +		ksft_perror("MADV_HWPOISON failed");
>  		goto unmap;
>  	}
>  
> @@ -229,7 +232,7 @@ test_hugetlb_read_hwpoison(int fd, size_t len, size_t wr_chunk_size,
>  	munmap(filemap, len);
>  done:
>  	if (ftruncate(fd, 0) < 0) {
> -		perror(PREFIX ERROR_PREFIX "ftruncate back to 0 failed");
> +		ksft_perror("ftruncate back to 0 failed");
>  		status = TEST_FAILED;
>  	}
>  
> @@ -242,17 +245,17 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
>  
>  	fd = memfd_create("hugetlb_tmp", MFD_HUGETLB);
>  	if (fd < 0) {
> -		perror(PREFIX ERROR_PREFIX "could not open hugetlbfs file");
> +		ksft_perror("could not open hugetlbfs file");
>  		return -1;
>  	}
>  
>  	memset(file_stat, 0, sizeof(*file_stat));
>  	if (fstatfs(fd, file_stat)) {
> -		perror(PREFIX ERROR_PREFIX "fstatfs failed");
> +		ksft_perror("fstatfs failed");
>  		goto close;
>  	}
>  	if (file_stat->f_type != HUGETLBFS_MAGIC) {
> -		printf(PREFIX ERROR_PREFIX "not hugetlbfs file\n");
> +		ksft_print_msg("not hugetlbfs file\n");
>  		goto close;
>  	}
>  
> @@ -264,7 +267,7 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
>  
>  static void sigbus_handler(int sig)
>  {
> -	printf(PREFIX "received SIGBUS\n");
> +	ksft_print_msg("received SIGBUS\n");
>  }
>  
>  int main(void)
> @@ -279,51 +282,44 @@ int main(void)
>  	};
>  	size_t i;
>  
> +	ksft_print_header();
> +	ksft_set_plan(ARRAY_SIZE(wr_chunk_sizes) * 3);
> +
>  	signal(SIGBUS, sigbus_handler);
>  	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
> -		printf("Write/read chunk size=0x%lx\n",
> -		       wr_chunk_sizes[i]);
> +		ksft_print_msg("Write/read chunk size=0x%lx\n",
> +			       wr_chunk_sizes[i]);
>  
>  		fd = create_hugetlbfs_file(&file_stat);
>  		if (fd < 0)
> -			goto create_failure;
> -		printf(PREFIX "HugeTLB read regression test...\n");
> +			ksft_exit_fail_msg("Failed to create hugetlbfs file\n");
> +
>  		status = test_hugetlb_read(fd, file_stat.f_bsize,
>  					   wr_chunk_sizes[i]);
> -		printf(PREFIX "HugeTLB read regression test...%s\n",
> -		       status_to_str(status));
>  		close(fd);
> -		if (status == TEST_FAILED)
> -			return -1;
> +		report_status(status, "HugeTLB read regression",
> +			      wr_chunk_sizes[i]);
>  
>  		fd = create_hugetlbfs_file(&file_stat);
>  		if (fd < 0)
> -			goto create_failure;
> -		printf(PREFIX "HugeTLB read HWPOISON test...\n");
> +			ksft_exit_fail_msg("Failed to create hugetlbfs file\n");
> +
>  		status = test_hugetlb_read_hwpoison(fd, file_stat.f_bsize,
>  						    wr_chunk_sizes[i], false);
> -		printf(PREFIX "HugeTLB read HWPOISON test...%s\n",
> -		       status_to_str(status));
>  		close(fd);
> -		if (status == TEST_FAILED)
> -			return -1;
> +		report_status(status, "HugeTLB read HWPOISON",
> +			      wr_chunk_sizes[i]);
>  
>  		fd = create_hugetlbfs_file(&file_stat);
>  		if (fd < 0)
> -			goto create_failure;
> -		printf(PREFIX "HugeTLB seek then read HWPOISON test...\n");
> +			ksft_exit_fail_msg("Failed to create hugetlbfs file\n");
> +
>  		status = test_hugetlb_read_hwpoison(fd, file_stat.f_bsize,
>  						    wr_chunk_sizes[i], true);
> -		printf(PREFIX "HugeTLB seek then read HWPOISON test...%s\n",
> -		       status_to_str(status));
>  		close(fd);
> -		if (status == TEST_FAILED)
> -			return -1;
> +		report_status(status, "HugeTLB seek then read HWPOISON",
> +			      wr_chunk_sizes[i]);
>  	}
>  
> -	return 0;
> -
> -create_failure:
> -	printf(ERROR_PREFIX "Abort test: failed to create hugetlbfs file\n");
> -	return -1;
> +	ksft_finished();
>  }


