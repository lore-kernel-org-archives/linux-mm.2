Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E594CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 07:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1A066B0088; Thu, 30 Apr 2026 03:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2136B008A; Thu, 30 Apr 2026 03:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9216B008C; Thu, 30 Apr 2026 03:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0E76B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:58:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61D811B9C0E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:58:36 +0000 (UTC)
X-FDA: 84714470232.17.8E930CF
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011029.outbound.protection.outlook.com [52.101.70.29])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6BCF810000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:58:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o9kgwo2K;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o9kgwo2K;
	spf=pass (imf14.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.70.29 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777535912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HvuwPg048xpLtmWVkp8j2VBvIEao02Y18I+j4v3peuA=;
	b=EnE4Vlgkm2y3OZWZWcGoIEjbOZFOvilHPpl4TJIeRYg6kqrRCuiBvKRcMlGKbSon6UoGUe
	2K7Y2qAGzM2DdqIaVc4VtpvB5BuX4iKvYcND36Z6oINUtFoWoiiR/Lwxn9UbAOOQ3ZRfuN
	5eRkJL10eXua+8VfIHve3+knbARxxBE=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777535912; a=rsa-sha256;
	cv=pass;
	b=JFSQhLiEnZU3Xi0oWyd/Zc2FQjW68NlFom80xpCH+CTE0SjTOe6fYskSZm2CS1zfC0wWeo
	dP0ZckAKGj70LLoJlTnlYUSsV2RVtuE1hVDy0VKHKgiQPfCwl9WTiRzhaYPCz080fqKzl4
	+/Ccgvi0RaXVOKeTxiqbF1p1BcrIwys=
ARC-Authentication-Results: i=3;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o9kgwo2K;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o9kgwo2K;
	spf=pass (imf14.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.70.29 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=elFv1tmlbBECC4mSQZfq4j0ckrCGkusTiwwyOSiaLqZ6EjFHS2DKdyj9vJAHnYJIPMZf87FAvRbxACXwFi/2TDpAyOSBoZ2qbTd+ajVnOCQaL2gWJQ7FlLIpkNGNySVu3VKWZZvWQlhuZsCOy9v/YTwGnKLUrcnAZmLOhkz1bO7SHgZPNbixE/4CJDpveWuORGBhCNM8swDC5nN3BS7Zh8dxZiwZP53PYBqZVwVfrtx/a4Pbo4s1TS+qza0NSyZ7qrgVrau8LVzaZ+2rWRkK3LM91ycQ6t6Zl3vkuJU9BRvQivcn+d/N/ZjtBFmomb0hSDSPIXiq305alkHq2tkTCw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvuwPg048xpLtmWVkp8j2VBvIEao02Y18I+j4v3peuA=;
 b=jCc0v8/3eJu3AX7i3xFB92Yhh3Nq9scSwuVqYRvfPrtCw4l+51SnTkfVIDGJVKzmpIp/9Wyxl51Ai1cY7qE7D5zPDBeCoc/uWHrh9t2AsH6mYcZ7J1DJECgZ9sNEAObNO0iio1E8u0dugt9V5E8hd/gPTfnaOd908d8EdP3w8pHnDYtVMsVHOLm06Sy39ANtRXGp3ogDk8JslaRtcr3SjCQmKLvU/BXaLcw/htotUZi8ulfSZOK6cRW9sE9nV6h4eK+n3b+sWzmzYuX8d2C2e3YDMoBF3qvAlay7Ohk5WAx2wu9S+b4YoqsVDoOHTFriHZ2bOhasFJF/lzMQXb9vUg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvuwPg048xpLtmWVkp8j2VBvIEao02Y18I+j4v3peuA=;
 b=o9kgwo2KKNeaDF1NFhC30reiWwJnkYcFcO6vDBns1u4sZwY/zquUix5nIXf5UrrpqGDYiYnppRSiw3zlQAsaBQIJt4f12svi/Fbqxn4XbGutcUwzHbm+RBCwH3zSC92i05PEFs2LuCTSSJF8CDMMq0whBL4k4RzyuBY5ySIASj0=
Received: from DUZPR01CA0245.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::25) by AS2PR08MB9074.eurprd08.prod.outlook.com
 (2603:10a6:20b:5fc::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 07:58:23 +0000
Received: from DB5PEPF00014B9D.eurprd02.prod.outlook.com
 (2603:10a6:10:4b5:cafe::aa) by DUZPR01CA0245.outlook.office365.com
 (2603:10a6:10:4b5::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.30 via Frontend Transport; Thu,
 30 Apr 2026 07:58:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9D.mail.protection.outlook.com (10.167.8.164) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Thu, 30 Apr 2026 07:58:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JWkeQpxK7rG2p7p3bWxx1dS7IZzI3rS6UXcUQRIN+e9TESwfG6Vb+DRZOuGN8RfgFDqNf1BFvysh+v54GQ04KorA/kmVWj/DKpDL98y275MCp2MR6lSQYsiVbHsAEJOjfr3tLfacgVpF8JPO7Z6ZNUFo0VXmSxIyrQVMC4s5XpCqKiN4YpTBLV+EHCCGzG+Z7ttKpRUOU6SN4zNEhY9Nsm68jgJrOeYuK+zqxaxcEEIDRBpT1g5Q+sBjsu+OxBrr1FpJMc5wc0MSxxdEvNiyl4BNmJnS0YeNkBUdn5YBQ0DJpCkcM0qVZcpD1zULV55V/BBE8hHEr3B16ND6k9Sp7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvuwPg048xpLtmWVkp8j2VBvIEao02Y18I+j4v3peuA=;
 b=pl4/vp6oW/CgB0zszVvPz0/MkYwz+lF51BoiIKuX4XvwjVV6j7/RXZaYavRU8zmct8ZMsKZKekc0LqDHddaCo5NXL1A0fbXOTXDJjUwpIzHdTlh8UVq5KNnaAGNpJoB8ElsmmicZn2vc8O1q6Kuk738H17SpkFm1Ug4Zn19YiTgonfA/M3zc3tgj/zS8UpwniAulGVo06ory1RMWypFe0OUuqhQIrxMR9y+ln32MtyNDw5XbU7+KmrJw+sYtIwPnRC4KylYWNUG8O7Og+FUYbLRYde5p75mu1SWdStdVzivOC3IXkcibWA5hmG7lf4qkNFjLt6yNPsLuHndNVruytw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvuwPg048xpLtmWVkp8j2VBvIEao02Y18I+j4v3peuA=;
 b=o9kgwo2KKNeaDF1NFhC30reiWwJnkYcFcO6vDBns1u4sZwY/zquUix5nIXf5UrrpqGDYiYnppRSiw3zlQAsaBQIJt4f12svi/Fbqxn4XbGutcUwzHbm+RBCwH3zSC92i05PEFs2LuCTSSJF8CDMMq0whBL4k4RzyuBY5ySIASj0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DU4PR08MB11835.eurprd08.prod.outlook.com (2603:10a6:10:641::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.19; Thu, 30 Apr
 2026 07:57:20 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 07:57:19 +0000
Message-ID: <3ee25654-2d3a-4c59-8ddd-2228c405329d@arm.com>
Date: Thu, 30 Apr 2026 13:27:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 21/54] selftests/mm: add atexit() and signal handlers
 to thp_settings
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
 <20260428204240.1924129-22-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-22-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0092.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d4::8) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DU4PR08MB11835:EE_|DB5PEPF00014B9D:EE_|AS2PR08MB9074:EE_
X-MS-Office365-Filtering-Correlation-Id: 43e4521e-c33b-4634-f74d-08dea68e40b3
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 0rggnlYEKRLxiXcZjre0g3ciMkm9/HMKt8twhS7h4c+V9fcT40RqcR0GoxSyMwgGtXA3elQDXIc+5NMPLf3eRNN6RB1pyrhudjNKCUcNtTG+b4p0V5HoTvu82NTDvjfPvTvhrgIT0URxpBoritkLVC0jKfOzW+wwlLlkrsKLDHlhjgoyQ3VX1J9/0XKek8/Gj3AXzw35cJGc8bxZ4YULbdK1VlsLVYXOznD0myKADiOvpwkUU+n8Sn0Ez1XHLpqp5W3xSDaRCSQrJco8M+2FYFIpzWRRFNmXFwzCk7/4hSSKDyvGyWCXnlTxDfpGcGNeTWMsvvAFZZ70mcdqLcsQqTHRh0AuPQHluIkk7PSi/6r9IR0+g8fcIFX1J/thOHcx7S/9xSD8B5lRx7Tt20HTJdtfLI+ATky/tu3P9BsaZSunn4mfcrnMTHpgclbqpijcvDc0u3/o0xYE+zLdAfvBDZ2FRwjjjpk24iglX4k5pzER63qGWpsHhIarmwZVbbIrdoFEeW7vT+R+tiS3iZWMiHXAJ+189Y2CAdJR7FSDH4GthG+IXFF0M/I7j8vxqWhcbClLs5iofBLKYdvj0TeM2S7DT7SY3/+Ri1Jv8r1c4uu5S8RYEmiOrGqf2eNMB5axLjOt9sPBbCudsC/8VgKo4y5DFVzEakuAAsFqrUIAVn3ZGbopIJIi7JG+qIzfSOhnlstcapVR31xDrFs8UQNk7hpe2eHywVCSUnWiGQzXmBU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 pJWq8ZOQS1EzCLeA5r98L40FI/MTxH9zwVLFA83BcsEUhESkLGXkBZYfXtPi5ytjC8TpUnYNV1h+2B0N5UjxmL8iycvvicv0Kyr72w/YgKmpfiXZHxMQEdZCVbnbujFU8/tC406xAzJK7D4OYioNVCvWWzFq60+f8KFAUBxdzQhbrY0Zn1fjuk3es9/8S+UZYI+VLncjGyGW3fANgY4MCGU7SWP+l3Eb2b1XRyCSAapfy4ATYvQpK06aNDn/KiFWgtyfsZm8wHO39z47W+qUlDTWRaoFMQOVbOtAbwfVzaef3KC+EiMEWxb56Pe8Vmwr4bZ+o7++LNL6umBHZA+i4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11835
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	68116cc5-ea76-4c66-cf77-08dea68e1aa9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|35042699022|1800799024|36860700016|14060799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	vZzN+TlQXs9UvK8128SjVXXLBBOXoUwItjeCFi3c+2KVXq0Iw8saU5t8wdQ3X+fxR18BoxPJw41c1JDN7TsQ+e0pdE6gG5Rgi+8z/y6XX3z89FwIUFlBz3g8fa5Uy0K8W2R2SLqfJD6yhXVphLh5Bv5JEm6HNedXLDFuqZLKUidvv5w3vREzqj2MGwFhFOLQVMQyHQKL0LmWJt/aoQzNTwT2SsHLkBZxUYlaizC/lynC7zaW5FZ+7kFQvCLhnjbjYht+DZFznUVv9tD1iZ3pndeLHI7Zt7QCujD+FnkW7A0xR8unnvxkD14FlcJGCUppARbnR35ISn5vn1H6KY3INGx4jhPwUzbZYcZF/vr+ph3K6hQZ54g+esaLi9hNVqg2Iojxo40N0B6GRAj4dflWpPQXdO/Z9ARUUzZ226GORUTMKKTKivGtfH6zRuyZFXa9FLT0NP+eHPHHy1KnLIr3IeTebV8MhXfPPqm1MIAEX127t6JsKtNQ4R6hymu2d7MuWFvNIMZpjtWmcr+WgptksAYnAGJjP+3ZXb7DmgYOf8DpIxN/3S1B3wGOTsxCQNxqV0b2mQRmg6z9Sj4+552aHxp2WHGkdAGpRtP9NwLoN3fPjnpMKBLoxcAr4ytTGKAa7cUTBARflEJBBzqDxs0Vb/NwbgAnavOkUoeqOnwaEAc70vJj0wy76Nni/Kk5BDdRKEbNAXgCuFrrO+p/bTF/8PI4wZqzGwShw8OfwfolYCXKBLneBQcYJpPivCjjXqWUyGlmhxyekvbclrKmAtY5bA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(35042699022)(1800799024)(36860700016)(14060799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DcjmPSMOwP9RoOnOCYs8ZmeCL/RdiJPtb0RqgXCB9biAkmeYC8TkFCJn9glHKIBjQumE10t9xNcG8eDeDXYGHPMM+GVFvrr5L1zG3F8jyWsYa8JUS4ViJCbSOCw/CQ2OPwttgkJuK5Awx7+2olU86nMENdaVggWadMtIKDQdKDK8rS63f0ieHP06MqOzgBRWLmbRU0F116vDM9u6QNtxpZUECIIShDqyKkKziKxuzDzsZ7qVqh3owH07DEDffZWeOyXpTqQf3e3W0roSaT49evAHLnyAJWmrtapX/94//Jn0flLReBsbLWuyzr+GTpJ8hrR4x+nwYpnvQ4c7ZvB0+C5U1UnYSHbMTI3q1KpbJF2bjY98Ih9yU/n4ZYxEutar2t3uq8v4zl7KBSvGLWaDeF/g7wolpWRhJog6YXxlc2vzWqsGUFACnRek2gsiF+Nd
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 07:58:23.3232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43e4521e-c33b-4634-f74d-08dea68e40b3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9074
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6BCF810000D
X-Rspam-User: 
X-Stat-Signature: qo4e65qax8p87ypmeg1xysx59a1zuq15
X-HE-Tag: 1777535912-430213
X-HE-Meta: U2FsdGVkX1+KmfV5/YImKYvt0BZyQNZ9EJxzPa81kHxwerAr6PPwSpMvgGax7r5LwkgHNYp4qHBWKSpggoaIinQuXDVXluLJoKNH9TgTN/Lc49c8dAnkJGwxeLN0sOOL0ZYFoycurYxGZqeSzHbSKGejQHKuBJiMXuhql8+0uKrkxH8Uc68KXo4tjsd2vFLsJRKB890K1HxlmggX3GapE8dzLLGVYlaWcKrnnym4p1thkwJwOt9X0GFju83FvECzawTUhC6rgDl8Q/rjMm/NxJWq06mFfu032zPTLh9bNSI9HL5f0tf2yXXmcuWAwrD03zvGRoD7V0j7XYGQBOXzJbYSBtikMdPD4Z1CITb2p126LwUzxwgnZBvUKpAIgNgwLPy80D9DeMWYtP3LqGzcGXyHC6KUeWR4Uvg+xmA/yMFFhmS7Hl2RS7S/0VRdXL1CF5ZnKN1XPuNjYkE1nNrI9GxIQO+JntOa9nw7zOkWW4yw50GNbrRiiWEVEzYa7gNW+tbIQYdqiAK48j1N5wO/4TqFpjeuy6CEnmHf0OOs8PczradIFxxLgcE1naP5NaFHIoMoeVQFO0oZn/zut6jvm/WjfdouZg0jQaNofWDQJ2v0GLQgGA5nx5oKZ6DeCjfNIir9tVqptWKnLAsO4LQNK1UxwUwsWQsuqxZagBv+NAvvux+v0FAZ2q+5d3mTQG/ArrzydT1/99TtKLfFszabNrGlnBe+rEsbAXt1AtYTTILkzePOGl+905ODWQ9djwvGgUyHlTRbKd0NbCuqEnAZmTtsHju2hJnyDvIalFD55UH7yP6MFiIcvzRku7DZ2exIsfZ02YPt5mpewLQKEsJbu0orjcE0sut2udpbPFvCA920WSgn77nbf9gw6L00ZHUW6/qlsGr2SMuPQc1NDWBGk/2EJljn+5xuY2Bxer44QJJCZ4UA/6QpWaYs+DLHwRzNCGBKzVjQOXJtK4tP0Ub
 x8psje3q
 x683+Z1emyrqv2YQ5F2fVIjqj9TGeQHKRYNqEq0LMyqRji7Ni1eC2g+648uhukZcRaQUvRJa0yJUTkN++7iYY7opDN+heWXGE79MXFkxyrh7X4KAD6rac1bwxnvtUnrwfkQuxm6PP0lOIqR+1s26xnigMNHrl8BuQumh8tat0+/sttfA7O7+w+0zdnrYZbsOUsXgGUPa3fAODm9Fq0Ny5RmldhNbaDWoxNKqwcl3Rp8w75IqLnMs9VWyov8DaY77z2vM6aAk+SSi1YO4zjp/aHaSWilW9P7R8V38vJf4Vb6HRn8A0+bcKBPYNXsAjVLFQan1KJB21tm9LTXPtrpv0pkMTKmOyn9myYmHahinvImUyG6rIqSXLJZXG0apTuSDzQCzZJxqBtpD80L8wNgzOsMPvlLlCKakRT3jEa5L45EiRoCbGY/V88/nJWIrhPKYQb2SlUNnj7xTMyfFcCVut9scqMy3B5spMrD15Je+ltEZb5CU1vCxVgCYikBHJU+44EeMUtbKJcTL1tLbXaa1oi1ET1sPW2locux5OIAcchHPF6Ottt7Dk8p+AsXXx3aiWZx0Q4Oo71bcNQIdGol171EzkCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> khugepaged registers atexit() and signal handlers that ensure that THP
> settings are restored regardless of how the test exited.
> 
> Make these handlers available for all users of thp_settings.
> 
> The call to thp_save_settings() installs thp_restore_settings as the
> atexit() callback and makes sure that signals that kill a process would
> still call exit() and atexit() callback.
> 
> Update child process in tests using thp_settings to use _exit() instead
> of exit() to avoid altering THP settings in the middle of a test.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

I ran the modified mm selftests after applying this patch and the THP
settings are being correctly restored to their original values both on
normal exit and when the test is being interrupted with Ctrl + C.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

