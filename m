Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5527D606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=JLib3Knl;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=JLib3Knl
Received: by kanga.kvack.org (Postfix)
	id 566A16B05B2; Wed, 18 Nov 2026 16:49:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517016B05FA; Wed, 18 Nov 2026 16:49:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DEF16B05FB; Wed, 18 Nov 2026 16:49:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 032136B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:49:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D6571408BB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:49:29 +0000 (UTC)
X-FDA: 85449581658.20.8142ACD
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011040.outbound.protection.outlook.com [52.101.70.40])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4915440003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:49:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=JLib3Knl;
	dkim=pass header.d=arm.com header.s=selector1 header.b=JLib3Knl;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.40 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795038565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fv3VJjpEWYvS7/LP0rPxB9tRVxo1/qO/1eP1hB2c8ng=;
	b=wZvyDLtefQbJ17lEX6D1icayQ85cZYKS0ipjIytQ/u/7Hm8WJi9felAE43LXGtXDTiXTy7
	BqZ+vn4EOmdVri/J0dpRAxSttI6JBDMik5Z5nZ4YTjYa3RdQj/5sVG2GFe+123eyc5Fqy7
	9dhhpw87/3P4J0o5n9W0DTG1FwTVnOg=
ARC-Authentication-Results: i=3;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=JLib3Knl;
	dkim=pass header.d=arm.com header.s=selector1 header.b=JLib3Knl;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.40 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795038565;
	b=5T+mVzjG4riuGOkOVtlCOp//57FdSZLomJprC0LjztY5rarJnjRrPfNzjc+/kDaxnBaAvY
	ySyDXrxwBNPili8YWB/6SzKLfoS7wNtOUKjrEY/Mmtcksc/jMV81zLVr5XHAjSBMM0L5qO
	S4CCzWv8iZZCNggcQxxtPBauhTVMQR4=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=R+FBNCGC62bBP6QKjPGlOEk9mU8VgI8Ckh9XdcX1+b1h+jpiPaWTXVqG5ZBwHwWu7XLUKummkG4NBzj90x41QwHuucWmoFV+fRHn+e1qHCz5g2+uvf47aJpW6150aD+o2NLm6qwBbSmsVLpkWmnnhaOdZEK/P+79haMDLT0Y/ew13mzetTliePKNMfFDfzCCpL4gUaIwLVnrrI7UOnKORymgfus0SiCGboqTJ9k+xhfBcVqY1KRPXkz5dIRcV+8Cq2SZgYMApNaAf9/918fRL0hb1XWkcdwQ2E/OQrOitGN7EJNhuTV41Z0DRsCDivBaF0NWtuW2uML9/9HFFlAdUQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fv3VJjpEWYvS7/LP0rPxB9tRVxo1/qO/1eP1hB2c8ng=;
 b=qH/EpjNcWBxKKR+yEajTgaIp75QR0c3PgfHcPFsViQUc966Kl+Z95gv7Xv9m4nm3Ma8kXYElHfNqRhfhGSaoJwo1yfXT3VuTEqxPCHOMnVZ/klzkIOnyZEwvJhHw42ai6/IppTF8Eq01Wh+vMjimNgQou470lQmfiC3hxqqFuG0VBuOuRv+oCioaXqTmXXWBrre5GuuLCUD9mslfSo3gD3o6nlRAYFdanqIc+iTw9Y2Shy7RxWjb//RwV73GP4WdVgbun6JAphrb2qRGS5BEbODhQwSOV/Wwsrbqta7zAztnKxbtGvZizR9ELkoT2JwsECra+c2Tw6J3ZLd+risw+A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fv3VJjpEWYvS7/LP0rPxB9tRVxo1/qO/1eP1hB2c8ng=;
 b=JLib3KnlPZn1VqS0elIkRGylf78JMUdTQYNuC5qrcnY805Fp/UODt1vdqX8+REcO1ztkuwNpdgMyrG6/izvJLDBuHBBcClbSAO9d5KuN0PMUqBmhl4VnnotkB8w00qhYzRqPGNYfM5oinkvY3LswPZDsZR532eyBzz22CYztcrg=
Received: from DU2P250CA0028.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:231::33)
 by AS2PR08MB10156.eurprd08.prod.outlook.com (2603:10a6:20b:64e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 21:49:20 +0000
Received: from DB1PEPF000509F8.eurprd02.prod.outlook.com
 (2603:10a6:10:231:cafe::11) by DU2P250CA0028.outlook.office365.com
 (2603:10a6:10:231::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Wed,
 18 Nov 2026 21:49:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F8.mail.protection.outlook.com (10.167.242.154) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.5
 via Frontend Transport; Wed, 18 Nov 2026 21:49:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q2u19dPfOrn9LA+bPT+OloTtq+BBKpXoqkLubqtGY1z68I3GdE1D7X69uS4iO7wVjLiN6MzoAPbHqYpXZyqUhnQCoNsKERJiDrTozvYHxgboBFUaNbdO0oa7Z0ZmY/M6dOnvAZf0lAMp0/HxvOF3UhrLgIbCZ//Q+S9FH+o4Ao/uCCwlDe/jku30oKnaivoG4eUKFs7QYApBSS0Xie08B7AD8S0P/V1QfYhz+ZaMHuwNK5uP96kbZvoOmY+FUvbHIeq/OqRr6zFevc/N0GXv0jrK//X60yQsxZcl+JMwMr0/IdzvneiRt6QMjp6DJ1+pzH4Ml1Qx4y1GX753j4v3xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fv3VJjpEWYvS7/LP0rPxB9tRVxo1/qO/1eP1hB2c8ng=;
 b=UsQwJ/vmiyoTgdHZO7Nvs5iMhuBjkE4JNa7/QlOeys+1JoZRQu2Kpb3pwKbioexAM6Suj7jRe+hFxgJfGn8E4Oyp5HriOTkx4bkA0EiE2/NRo2zwcNx/UNLi1Xv/5wlUDPwQQGIlFh3MmrUblKG0Shge9LwR6sUt9i+n1J5kDEou4zd1y5e5HIrWqnDhxpSGhvtlu/4kwN/YB9XoZqA4UEy7Kl0Iv5FeTRpIvE0Zf93J+LpuYqDm/Ho7N2Bx2WpIX7NFCDPcrl0rzFmIb1Ip4g4BR62+1FKn7Cp8yfNB0CZXCSUTz3NwUf/Ms5S825/9Dzbw66qEHFDEsZTLn3Ambg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fv3VJjpEWYvS7/LP0rPxB9tRVxo1/qO/1eP1hB2c8ng=;
 b=JLib3KnlPZn1VqS0elIkRGylf78JMUdTQYNuC5qrcnY805Fp/UODt1vdqX8+REcO1ztkuwNpdgMyrG6/izvJLDBuHBBcClbSAO9d5KuN0PMUqBmhl4VnnotkB8w00qhYzRqPGNYfM5oinkvY3LswPZDsZR532eyBzz22CYztcrg=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV2PR08MB9229.eurprd08.prod.outlook.com (2603:10a6:150:d5::21)
 by DB9PR08MB9828.eurprd08.prod.outlook.com (2603:10a6:10:45f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Wed, 18 Nov
 2026 21:48:46 +0000
Received: from GV2PR08MB9229.eurprd08.prod.outlook.com
 ([fe80::4dea:4c1:9d33:db7f]) by GV2PR08MB9229.eurprd08.prod.outlook.com
 ([fe80::4dea:4c1:9d33:db7f%7]) with mapi id 15.21.0615.009; Wed, 18 Nov 2026
 21:48:46 +0000
Message-ID: <2a84fa4f-655d-4c4d-b6ad-b2ee9d37d972@arm.com>
Date: Wed, 18 Nov 2026 21:48:45 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Zi Yan <ziy@nvidia.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Samuel Holland <samuel.holland@sifive.com>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/9] mm: distinguish HW PTE pointers from SW PTE value
 pointers
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <avtAQCkvRr1xkxMF@arm.com> <5a6f351e-0a68-4bbf-a9fc-5bb39d8439a4@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <5a6f351e-0a68-4bbf-a9fc-5bb39d8439a4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0368.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::13) To GV2PR08MB9229.eurprd08.prod.outlook.com
 (2603:10a6:150:d5::21)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV2PR08MB9229:EE_|DB9PR08MB9828:EE_|DB1PEPF000509F8:EE_|AS2PR08MB10156:EE_
X-MS-Office365-Filtering-Correlation-Id: e49d3fbf-58b3-487c-b17d-08df45bdccb6
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|22082099003|18002099003|6133799003|3023799007|261028144727099003|56012099006|4143699003|11063799006|261026140227099003|261102123227099003|261026121527099003|261021135927099003|261022105027099003|261021123027099003|261021121427099003|261022075727099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 E/y3NBWXwZW5kX8KKqp07dhXrq33EFukUT2JqQQblEhxVX4a90MV5/qbddmuiwXFWBsR9ecPG/LYYd1dC9eiTj8NC75RoBU6prAe+FY5m9wNjhkaATYEeUfU7t2bhs2y5P2wG4U/f7Ga8X9QYncd1PZ91P/MITBD6xSMdd6f6o6HgeY9N58CUn8JG8pjVlxEb6h+L+q4PQ2WiWDlWE6ZiYru2dgoQq1jMO3WG4C9zzUDoVIxA3rIBG5KH4ujdlx4c0ZPbMpENpP657FuiBHRnLwOkEOvv7EwHy+qqe/YhKCM5Eo4enDBpaorzMVk3r2kOefJ4k2VL/znoq4KuuX++NUptVodxBLlTrRA9hjDYygtOZimJ4bVaqNTk74+AokLqBTGqHeEFpXZQRgC1nhTNbiCdmYhO3pECP6zFaWevjbqMh+yh2wXma5mRHqEHnxRXclQlht7jZ/2wvS9uCxz40yrmkmj8hcuAZXAo/1mnfiGgBiMSYQhYXPEim535bH9NJX/RvshKjOvh9aoeleTQzYx6lYEPJtBnDp26Xv/mhhf79nxJSn3zpffgAWffDn219gJr0E8+mZucBGL2aq96cC71VUUHb8E5B05QVI4UKpYeFXzaZncadHRgyqxSF5D36kMY2s7t7I+S4Vvn3sWucu2U1wRwqs7M6CYWK9Wn8c=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR08MB9229.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(6133799003)(3023799007)(261028144727099003)(56012099006)(4143699003)(11063799006)(261026140227099003)(261102123227099003)(261026121527099003)(261021135927099003)(261022105027099003)(261021123027099003)(261021121427099003)(261022075727099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 zUftiiIUt6TqgahAzA952imQ2i9aF59Iw57pXlwMtRBJrKTR3zOFUkHFlGn4ueXmdybDVM9IiyP1m/v86P8HNm739pe4yICDqrf7G0wnVEuxlfZ/EZ2O1J4UjkL08eaeeixnffoEoQSHiUj+c4qih7hufbVqcozurUOXifkthv9neR0U7ogcPcM0c7ABPQLk4I6yTh+L2LRNGVKhfghqWZcb1OpSyzFdTcWoDuDU3STJeSH17nS8aaV2KKFNEA/YjVetAkUckRekhEeKObxvDBoqKLEkhv12vbTxukmE49ONyiPMhBdlp2kiNFSaiBWxK4ZyT70rbpXRQmTTWVIsSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9828
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F8.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8a651e6d-5b94-4d72-d4c8-08df45bdb8ff
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|14060799003|36860700016|376014|35042699022|7416014|22082099003|18002099003|6133799003|261009223027099003|3023799007|4143699003|261022075727099003|11063799006|56012099006|261102123227099003|10067099003|261021135927099003|261022105027099003|261021121427099003|261026121527099003|261028144727099003|261026140227099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	2hV7WztJQVWh+mBG5+JfK6fR9vbo4i62lOggvBoxwY6nOuwJcWqKfq9W9+EAh3MXOqZYlrh6XiNawnytaJZJR4ji+/tp4HdA4Yq0YZJwqX9moKQMBeAqVK0LdpnGABSIJllrKDd74gDVA1deUFUR0X8PD40n6t1kiAVUYYSCiQ7tjgC0qS9d6AJkQIEfQkJJCg8IBPLJH4k66PlwhRKOhziqucXrytn5qzfDyMiFRfZwhD4d5f7N5sLukSSI9cUcJV+wdro5nqxgh5ob30+WtrwQ8AQ/kaByvpqA3gzHgxZDT7pvzAdW6/uV9cUfBX/0e1GZV4eBNyFUZMwk/3padY+lO8uSOawuYr2kt4FYoYz/7MN/4+xZA8YD4TSQW2LWkX6siofY2wMZbMgQYcqkIsnyvpsaM5/OReEol330atKz4V6hx9vjsqvqxamSHvEpTV8wnkNODVbxZwMRviM/PXhsG+hyYSt7nIYWOS6n6TcwYf6h6EQb+TtFyBEgtfLq8eynHGVo/AXz9Tk65vM/oo7Fv+BHCwOiY/rd/XyR7PH2AaBhZ2gZqIzKkc3fLArTciVvU0hjkycUZzeCd+UBQ1BnEE4pBpFWL67ig6bUif+UtXxZHVTNGMjQpQqjVIou3ftV81pQQGyGsa01qf75XlGeybbZ6pCi4Hnpx7S+EWniRxChQlxb3XicfOyMiaOfmjurJKKnMnQYsee0freIFg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(14060799003)(36860700016)(376014)(35042699022)(7416014)(22082099003)(18002099003)(6133799003)(261009223027099003)(3023799007)(4143699003)(261022075727099003)(11063799006)(56012099006)(261102123227099003)(10067099003)(261021135927099003)(261022105027099003)(261021121427099003)(261026121527099003)(261028144727099003)(261026140227099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	o4QX4L3hCZKPxRoKcgmfPKytdMhBuDRUTuMKs3aTQttd6+tg53+NzuZiRoemL3grqLUMtGw/ZAwZfSn3SNItx/ijA+Gguf2V7Xh8oSyOZ9FtN0/Y+y2xqkhFdovJ6+U2gWJuYH9/0HclpTiorxIZ/qbUBYJoww2JojCRCdkh+ipPqpbH15E8XFiAdZ516qbgzNjUyZn/Fc7MWNvwTrlWXrUIWZTzFiAzDinafOAhvA/CJIXllaUiCiJ2kGum0vbuJteFkxonaof5D7kTnEYn66wcpOkEvsWUwmkFgWEAk7dubvx1QeEPbz+PAJJxa2mDJE5IxMHB+Mp4awe7rj9w8TYWSezwChK4D1fsulnEgH5J9KblGTi8xH9YonaSD3u5yIxaPDpDGBWcAD8gcQE/t+xDhDSxntyP7GGrbjQgAFlK1b0O2Xhk17+825uUQhdy
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 21:49:19.4303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e49d3fbf-58b3-487c-b17d-08df45bdccb6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F8.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10156
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4915440003
X-Stat-Signature: 439cgedwzzkskypi9pszrq1emjcsj4gs
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795038565-937614
X-HE-Meta: U2FsdGVkX19vkzKu1wuGysX0bQV77KbP40ntETFYBLanmIMlG4V0+1tQ4DJ3a+4CRc8fUS/t9LUSjKuXNpxMmNlxAxu/PDvfNJF2Q5jox1O71rbK3F4tHLyxB+yhcjjc4voUJqtCGdVUGNLvBIJdPTU+mTsBt8PL85UNLwxEDk0J7OBax5nqkfQFGfIpll/r7yLteVbobZ1tR23hmUcDGznZc0g/tD7Ysaysot8nQxa5BCgB6KALLJdTf7iIF3PXZMesMHnVne2j3vwYoPpWYZHZVGODSDle3l0lp5gR5itiWxxeBw+8g9yf9tjyDx7QgTdtB/Y9frLVKb7hQTmz8QoBlNnj2K+IRLP4pKx28hul2JWlKX+2x69jhEz1N3a+a9Ui7r5n0V1NHpM4vkQ8nPUTL8dqGCm4zhrSSCDg6Er9FhJzt/cgIZ2JXE87SMheabDSgLK1uhnA6b50vKLGqI1s3vssvzu2tw55gyam9DCDqvTDS3eQsen9djxHsL1hXmGw4oCKRPEJ/q6PDZGXLGLDyvqiDUZ1vL8BAH+w75Rsr86yor4ZQ8/m6sdRHR/jm9irSW74btep/AQ44al1bPjXlx2kdYyEjmaqsg564tQwuHDV9lnBjVAYcBqEMidkbdbqaCBp51xjNvGs5cCCUOnYxk02XG6Cx7c1OG+JNNm5wh0jrdKtzHOVttRbp3nWJDFhCFmw/ZjR9SGjQKHzGLx0sE46J8BiAuDxKjor1cHhQJLIFhpAkcbnkS8jQur4aV716qgxA49/Ph0BtNrF2yMfZs21iBjb0e2+pkOqonJ7DI4uFP/f1lhEWWNFocYAd1vOnD2Lm+AVkOeHignzOcNuxnAKSsMjd71/unKjQNhxmz9DLAYifnWOixliKggZWqmP4yzNgAvXAp3+QXekYiibgVgcsmILbToLfSc3N6EwTWFC5ZITQtfTgpAicA5GAX/5nveykeGrNa2DZqh
 qwyf0OVl
 RRaJjgSXPEXy08mEIIf02jvNynzG2AsQ7GZ71Sa/ajiJJbf1NRu4ayC1E7hRtfksGAs8Z+8BYWyd05k6ZYkK5D8tozUCxZOXDAQWuh/amehp4xzKWkaeGDbMXu14y0clz4c6wa2rQzyT3+0LsLMyu6SQ2mQjFWLgaPQB8Y8kWohBlHp8b18Z8dxxaZNkLKRwVyoqh3XKBEN9dWQS3gJ6AGtonhOe/KZse5ZY3Hvx1PVwGhoIvFewKh7P8YvwLG6A1ZleesSKUp2KcLiPDsHu8zEmC0EDyD2BMDPdIPY5Uz6um+IaPcQ+zADt8u5qo6ElgrFpptX3f1SWdm8R1uwN3MPtmKGF/MQgvBepCk2lbncmkwUMyjg4ZHfOfL//BoU/yKiJosUxdKDFLZEouxT2sLavblhNbLeGLKJ29wlqJdWSAWAelWd3PuFfjZJvrCqDjDcR6y5w2ICCw005jUVVlBiWvJ8C3sz8oSGinyaOXfDpuWV07qTIkB1oTEyXdx66htJux0Uvbo2ugMX8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 16/11/2026 6:18 pm, David Hildenbrand (Arm) wrote:
> On 11/16/26 18:41, Catalin Marinas wrote:
>> Hi Usama,
>>
> Hi,
> 
> David here :)
> 
>> (trimmed the Cc list, some lists reject it as too many recipients)
>>
>> On Tue, Sep 22, 2026 at 06:12:28PM +0100, Muhammad Usama Anjum wrote:
>>> pte_t currently describes both a software PTE value and an element stored
>>> in a PTE table. Consequently, pte_t * can point either to a software PTE
>>> value, often a stack copy, or to a PTE-table slot. The compiler cannot
>>> distinguish these cases. A value pointer can therefore be passed to an
>>> interface that expects table storage, while table storage can be read by
>>> direct dereference instead of the architecture accessor.
>>>
>>> This series begins a staged conversion at the PTE level. It introduces
>>> hw_pte_t as the element type for PTE-table storage and converts generic
>>> MM to use hw_pte_t *. Software PTE values remain pte_t. Interfaces that
>>> intentionally return a value through pte_t *, such as install_pte,
>>> remain value interfaces; the relevant parameters are named ptentp to
>>> make that distinction explicit.
>>
>> [...]
>>
>>> PMD, PUD, P4D and PGD storage are deliberately out of scope. They can be
>>> converted in later series after the PTE boundary is agreed, avoiding the
>>> PMD-specific cases that made an all-level conversion difficult to
>>> review.
>>
>> I looked at this (and the arm64 counterpart) and I'm not fully convinced
>> it's worth the effort (but I won't oppose it if the mm folk decide to go
>> this route).
> 
> I think this is the right thing to do to get type safety.
> 
>>
>> First, I'd like to see all such on-stack p*d pointers addressed as a
>> prerequisite (e.g. fix pmd_populate() in __split_huge_zero_page_pmd()).
>> If for some reason we deem pmd not fixable, I don't like half (or
>> quarter) baked solutions just addressing the pte.
> 
> IIRC doing the full PxD conversion is quite big; doens't make sense to post
> these on the list and instead move stepwise.
> 
> Agreed that it would be nice to get rid of all stack usage first.
> 
>>
>> Second, we could add a run-time page table check, at least for pmd/pte.
>> Something like below, gated by CONFIG_PAGE_TABLE_CHECK or
>> CONFIG_DEBUG_VM (untested and not entirely sure about using
>> PageTable()):
>>
>> static inline void pgtable_ptr_check(struct mm_struct *mm, const void *p)
>> {
>> 	if (object_is_on_stack(p)) {
>> 		WARN_ON_ONCE(1);
>> 		return;
>> 	}
>> 	if (mm != &init_mm && virt_addr_valid(p))
>> 		WARN_ON_ONCE(!PageTable(virt_to_page(p)));
>> }
>>
>> You already have some coccinelle patches to make the conversion. Could
>> we turn them into a coccicheck to detect new uses? With LLM reviews like
>> Sashiko, we can probably catch new uses violating the requirement (we
>> need to document it).
>>
>> LLMs and coccicheck won't catch all abuses nor does this series prevent
>> one from declaring hw_pte_t on the stack.
>>
>> Once the above are in place, I'd look again at these patches and see
>> whether they improve code clarity and are worth the churn.
>>
>> Maybe an argument in favour of these patchsets is future dynamic support
>> for FEAT_D128, we'd need to separate the software representation of a
>> pte from the hardware one but we've done this before (arm32 non-LPAE has
>> different representations).
> 
> Exactly; we'll need this and go one step further and disallow any ptep++ to
> instead route this through helpers.

Agreed, after the current series, we can easily make hw_pte_t opaque like the
following (or in even better way if we spend some more time thinking about it):

diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
index ee4eace5c3e1c..9898c0613e170 100644
--- a/include/linux/pgtable_types.h
+++ b/include/linux/pgtable_types.h
@@ -7,17 +7,38 @@
 #ifndef __ASSEMBLY__
 
 #ifdef CONFIG_ARCH_HAS_HW_PTE_T
-typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
+typedef struct __hw_pte_t hw_pte_t;
+typedef struct { pte_t __pte; } __hw_pte_storage_t;
 #define __pte_from_hw(pte)	((pte).__pte)
 
 #define hw_pte_val(x)  pte_val((x).__pte)
 #else
 #define hw_pte_t pte_t
+typedef pte_t __hw_pte_storage_t;
 #define __pte_from_hw(pte)	(pte)
 
 #define hw_pte_val(x)  pte_val(x)
 #endif
 
+static inline hw_pte_t *ptep_advance(hw_pte_t *ptep, long nr)
+{
+	return (hw_pte_t *)((__hw_pte_storage_t *)ptep + nr);
+}
+
+static inline hw_pte_t *ptep_align_down(hw_pte_t *ptep, unsigned long nr)
+{
+	unsigned long size = sizeof(__hw_pte_storage_t) * nr;
+
+	return (hw_pte_t *)((unsigned long)ptep & ~(size - 1));
+}
+
+static inline long ptep_diff(const hw_pte_t *ptep,
+		const hw_pte_t *start_ptep)
+{
+	return (const __hw_pte_storage_t *)ptep -
+		(const __hw_pte_storage_t *)start_ptep;
+}
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _LINUX_PGTABLE_TYPES_H */


-- 
Thanks,
Usama

