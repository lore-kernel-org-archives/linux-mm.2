Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C96F460A2618
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=KKCV8xwO;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=KKCV8xwO
Received: by kanga.kvack.org (Postfix)
	id 3D3E76B05F8; Wed, 18 Nov 2026 16:42:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383F16B05F9; Wed, 18 Nov 2026 16:42:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C176B05FA; Wed, 18 Nov 2026 16:42:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8A046B05F8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:42:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59D7E1C41B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:42:31 +0000 (UTC)
X-FDA: 85449564102.24.D5BDB44
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011026.outbound.protection.outlook.com [40.107.130.26])
	by imf13.hostedemail.com (Postfix) with ESMTP id 127B420003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:42:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KKCV8xwO;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KKCV8xwO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.26 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795038147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWkougLfY8DBu/z7WG2F7sgZM3/v0HMzoh0y03bZqiE=;
	b=JW7Hs3N9lBUp1DajbTLAS9IQkoScQPK96yHEPXfbbpqWblSwqkufPXKD+EXk21R1Fr4WiN
	xc9Ac7TqCdWnMkSDgNTWFdCF8o9qx/ZtcZghWOOr0vNiFlxySSvAaO1lI2O3xYDpZ1YM41
	sxICQ2DS4846SbwRKQOM+kX19GU1Q4w=
ARC-Authentication-Results: i=3;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KKCV8xwO;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KKCV8xwO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.26 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795038147;
	b=bZ8zWWZZD4A/dHb0hELbtYGGr9hZyfO1wx+FdtU6yQXRZ8hxTXXsI0w9th9KtoNYRldtm8
	oLA1iMG2km5tbzm6SR8vC9dMnLaqaO91hBYWXXSbrmOVOmHEFpLk8qMdoGxmYMBlRiAwL+
	F6DvxlpzZMECacnX9YWHO29Kg/bfHZs=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WOdyakrMeDLsk/6pW/kszbIXTec4jL6PMT/N5gGALKoyBJfRH5rKDydo1/HemTwQqm05XBluImCrO/e5sZky64UJkQIbJHpezKWe7DZAiqfirL073lzCkoWdhYZz3cXhHNQG3Nez8j9iAz4yjOxNGR8eNAhGuly8yFs8bGUBf5xfsU6NbOpLxnzb21kZ/Vbt4I7j0FsEwM24OJ3RckIgblOVXuTPzmsI0oFxDwk8VIF+OV3lxQ3wjDC63WoclHrADTwgH+vsa++qKpcV3zPtZckqdE51otDkZgwPLGYwjT4DVqhKu0XrevAS4YBRzBp7wDMvz5l9Zu1xgzaw2XBkzA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWkougLfY8DBu/z7WG2F7sgZM3/v0HMzoh0y03bZqiE=;
 b=nAawEQXitKJUGga4DF2UVoqBydOVBqGWCcddvpIAplsJwTfUNlZMStH1WmYrl+t82vew11q2XisZnsU0F6ETy2oJhnw1WRZpwFjGy5Yr5jrdHcF1sj3cN7tAw7M1pIUGt2PFFk+XNAUehnnYVXGFQVYKS6jXSTKj79XKkNYluyafa8tixEnc5EcvG80PGDNhd23662femXRDrNfaN7dVwLjsqrSXNFvk2qoxmK1jrRE+9rzm4n3mCoU5cwhQkGuQMYGLdzzxiQ5wlhhUZO4SfxSiXyE/dIKceDoZnCRvnKk9H7fObZClmaUNt4w9SpF1F5ky6WvcM4pA6hFCLYcuQw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWkougLfY8DBu/z7WG2F7sgZM3/v0HMzoh0y03bZqiE=;
 b=KKCV8xwOwHfsUyt8ejeT4EufBv68xUd9JaM7fpJgnh9CDx0tOBAI7+CeDuUWQHAjIuu5blR3C4kEtmuulrtpkyVyNoLwNyH08vZB7a4MJmL26sMBJtVy10WUifTzuBAMqFUd35iDHDXA6dBURv3SoLCC0APwUQJjTev4e2+O7FI=
Received: from AS4P190CA0030.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d0::20)
 by DB9PR08MB7724.eurprd08.prod.outlook.com (2603:10a6:10:393::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Wed, 18 Nov
 2026 21:42:19 +0000
Received: from AMS0EPF00000568.eurprd02.prod.outlook.com
 (2603:10a6:20b:5d0:cafe::20) by AS4P190CA0030.outlook.office365.com
 (2603:10a6:20b:5d0::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Wed,
 18 Nov 2026 21:42:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000568.mail.protection.outlook.com (10.167.242.118) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4
 via Frontend Transport; Wed, 18 Nov 2026 21:42:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XAqA/pr6WB8BIbERXYfdJmKVzu5YPoHq5rMSQ6/X6ph8kTiafLZVgdPQvNzXwxyn4NDwD13Lan3uqXcywBpsgXZXJ8L9RnHRUsstznE6DM5t5dl33yOOnbepRGPi4GJ4kDIOwEWMKe25YZctiIqUDtO13svWSycQ5yPXjz/1EV5xi7+USpldG9uP/fu4XCgzNAffLWRErZlq1JdqKzIWimNc1XAL1wB5DtA3CCyRgkj5qfK2g2oIpC1VnmNFVRvjiiiDZ4ABW4GTjH8M/83bgUkDLf9U9bycn+i+DfUU3tAPSZgtIMohukrHDCyN/iBjVi9IsJqljl0AoU75y3TvjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWkougLfY8DBu/z7WG2F7sgZM3/v0HMzoh0y03bZqiE=;
 b=NUTvhx2ZNG6Um0O0lk+ZRmyeH3Y5gFt76ZUb+wqVA7r73Z1FI1mj4qdC+V3iJsWNqvo8pBHEWPEARch0Ca69h/R+pD6XHYL6LmIIpTn8dSxuj6PIY9w2dV6+hMkR3wwK5K4YWoJpyhjwzSkf4buVk9gLy95RUzGiRnijDqyamg3r6AYBeSX+dYNB/MFybMlqPLRNgxuqpknDpyGC2hk1NFltyzeYgcM+5RsqWzuujkTxZwXsf0p7gf2ApZHlbXWnuvL6+1ZYGCnM53NJcv8Yr4JQV87WHqoeqmM/T1ES8lO6BTd+6M9brmZ38OoRWg+jNfwGmKlKirIWUz9JI3fisQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWkougLfY8DBu/z7WG2F7sgZM3/v0HMzoh0y03bZqiE=;
 b=KKCV8xwOwHfsUyt8ejeT4EufBv68xUd9JaM7fpJgnh9CDx0tOBAI7+CeDuUWQHAjIuu5blR3C4kEtmuulrtpkyVyNoLwNyH08vZB7a4MJmL26sMBJtVy10WUifTzuBAMqFUd35iDHDXA6dBURv3SoLCC0APwUQJjTev4e2+O7FI=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV2PR08MB9229.eurprd08.prod.outlook.com (2603:10a6:150:d5::21)
 by DB9PR08MB9828.eurprd08.prod.outlook.com (2603:10a6:10:45f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Wed, 18 Nov
 2026 21:41:44 +0000
Received: from GV2PR08MB9229.eurprd08.prod.outlook.com
 ([fe80::4dea:4c1:9d33:db7f]) by GV2PR08MB9229.eurprd08.prod.outlook.com
 ([fe80::4dea:4c1:9d33:db7f%7]) with mapi id 15.21.0615.009; Wed, 18 Nov 2026
 21:41:43 +0000
Message-ID: <959a843d-f579-4aa7-8299-c6e9c5d03812@arm.com>
Date: Wed, 18 Nov 2026 21:41:41 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Zi Yan <ziy@nvidia.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Samuel Holland <samuel.holland@sifive.com>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/9] mm: distinguish HW PTE pointers from SW PTE value
 pointers
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <avtAQCkvRr1xkxMF@arm.com>
Content-Language: en-US
From: Muhammad Usama Anjum <usama.anjum@arm.com>
In-Reply-To: <avtAQCkvRr1xkxMF@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0366.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::11) To GV2PR08MB9229.eurprd08.prod.outlook.com
 (2603:10a6:150:d5::21)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV2PR08MB9229:EE_|DB9PR08MB9828:EE_|AMS0EPF00000568:EE_|DB9PR08MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: bdcc6a8e-d352-48b4-6ac5-08df45bcd1ca
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|22082099003|18002099003|6133799003|3023799007|261028144727099003|56012099006|4143699003|11063799006|261026140227099003|261102123227099003|261026121527099003|261022105027099003|261021123027099003|261021121427099003|261022075727099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 l3P0q8zyjDOhnDMdWr4OjxOkPek2/d6R7l73n2dxMg1nhGnxUxMpXwfUN+TP7DWHTf6qkeCwEIRu/elBqSMUWm+u6LGJTNc2Ep5lUfAHHbtC7nugeD60U9n/sjqyKl90SX8eClA4zknHGsylw7xLSKX8cJ6v+NmpE1yxyWnAJWBfmfcv9tnNuNnAqP8OFhFT/JKy0skit1m/tuESwXPIg9inYwP+iMBvshceQKaTV1AnILH7fmFyWHXVH6bvDkFS5GOMi5gTY3EiulyDipqpifbnoUTsOxhJNvTg+1WaKQ6vh33hBiuY+vyXR1qZkUiaIEsxgpQu/BKHJ892TqyDAOtJmf1folRCw7+h2y+CF1UciuNQ43rzTh7F1dJza3IZXs/Alv3hxtnY4n6XFYRJenztFKMNLzl4hWpbC5P8JEgCTZykmlR8b7egrrIhnxAX5SZZWtdWj/DlR8pMOXCZoL3974rGDD2t/nPf8miV2lAiSAgrZHzj6mtnAwQW063fpPB2weyxEuBmrZUwFi/pRVlcK8KWOj1bXi8WMFvVuGJCCwOp2k3pXzhyQGj8Bc5uGsucUGynJ+nTfgXLH1fEgbYa9oqCvi5ZhQfETIfGlQc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR08MB9229.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(6133799003)(3023799007)(261028144727099003)(56012099006)(4143699003)(11063799006)(261026140227099003)(261102123227099003)(261026121527099003)(261022105027099003)(261021123027099003)(261021121427099003)(261022075727099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 u3iQJ3ZkHpXIb4elOaAy+2lusnBVKbeXa1M1X9Px+5c290cjp6T17sL2D3E/UMKPteER4ch6TyW2nXvxSbW9KR/RxfGC3NfGk1RmSbiZNanal63MY7cA/p0ZkqoNsGY8w78DrrQvnH+RNOuaEdBdFAzXkA8hNOPpRjgafzqnAFicnRpKa1MTkW4AGqZpAjORNNShAL5soAHhdh7Av6wMxpWSQRU6yxEMuJDFGo7vTHLgMBP4YLXeogQ5+CLlodq5AZwuW9FsxId2IJ0rYuAS9u2WylLsAryjGxsLlqJnqFALE/HrLtQRk5IJCBH7tPyJ1M5RNEZhAl9T/2O8vfFAUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9828
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000568.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1962b341-d478-4c3a-cea1-08df45bcbca1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700016|82310400026|14060799003|35042699022|23010399003|18002099003|22082099003|261009223027099003|6133799003|3023799007|13003099007|11063799006|4143699003|56012099006|261102123227099003|10067099003|261026121527099003|261026140227099003|261022075727099003|261028144727099003|261021121427099003|261022105027099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	PRoI86T+ONOOgXMjPnfxy3Zssm8/O2RF7n6luSS1iIl4w5LznUVZscSSJH+SUxtPoLO7IGyYQLwnZ8WGE8TTsAOxD7PCapaaRwGdjAsacE99mbqfNdxR6r9lztLfJeTCf2WqV3aEIvvVTv0TFMSDKs7o+UAy+WJcdhl1+WWoDtdGFPSEZd7/i+d0toYzJYeRDS9Dx6ENHNlNYUSQZ8i1l9wZj2+lK5Lt1m7yXamVuY/j05D0DJGtTiadXCFFwbSRlX04KQj7PJAZXm37eWZqDq+REvVc9FA3Zx7uyQO4H1Yol3DZ1P7sN0E2E2ASJjyRtow2DX1VLNhIE/x97bkcRj4pgKLvay6kD2XZ3xSf26XSbHBnANU39Gd0FMM2Y0arc5bxv3FLIR+WVNURxhW5DdImiiBBgQpyeSPo0sCLoHGHSeBwbjsW/rr+rSNrhYIBzodBoelXXwb+pb8P9BTu/5GifDqc92QZVtpNOaN8uO4G4+3Jq/qjhD+mqx4qwvhvC8ncvS3uRDGaDd3Myk9PtijDistct6p266VS5U5PTM4sWgWtOzd4G+J5nYmJIVb7iRIP7LtPgMyIEYIxtRxSQICb0uqujqUYW/WWAE+6LIateJoFMFjHXFTW3tVOaXC6QdNrz+VTIOTRDn/cXQV4Ng==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700016)(82310400026)(14060799003)(35042699022)(23010399003)(18002099003)(22082099003)(261009223027099003)(6133799003)(3023799007)(13003099007)(11063799006)(4143699003)(56012099006)(261102123227099003)(10067099003)(261026121527099003)(261026140227099003)(261022075727099003)(261028144727099003)(261021121427099003)(261022105027099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	R+LssrseZTZoeqW9j/43RnvxG5Qv3banTtyuccdEjGKMwjNVrslgzTnN1DcsNU3TPx4FbnN7oJnI3KabrsxtKPijz2Qh93uNB/FEO6lC40LOcElBLYRLYcB/EbEPrVkeWJbcyuauUUBlEJ+mDBRc21lqKjwoNDchpljtqOIV/Ykh9reHePOzyrLrlg+4C044GfCF8BDbT7+Z67woUZobhORuPjf8FheTk/GlKZ3cBS4zZkcw8YiYV5nsMWjW8UVDQcxLqSFDyMOJnelVGAttJ60rGxgqvrhjTs2o4/SgsYZh2HXK6nA9fZTFdvqFQsIWTFavGYN0d+oM//t0iBcB6A/BMQlqWUAv4Jvhswn87oPNudIw4GnrT4atQumtaG9I6c2Su2LsyFpkOOc27fQ0Ma+P0STmFX7kiA74ORwvz5v9hnpmtLObjFBTVbNgvGyV
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 21:42:18.4802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdcc6a8e-d352-48b4-6ac5-08df45bcd1ca
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000568.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7724
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 127B420003
X-Stat-Signature: geukfexsrtcw8yu1tgzezypw5nnjyjc9
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795038146-757597
X-HE-Meta: U2FsdGVkX1+nP2FMk9Oj1jUvgJrXbkz6Ss3dZxUi4cpTFBFwr3AKe+ZuIEfQ9IZGn9k3DnuzIE6WbAwNUxjE6Iu1lQpyjknLGTzGBu6vsRTlVyCPEkMvLM5fNCyraE7XrtkghjQyyRFbnX3BnRRnLyds12VSsLRBgMnWtZ+RWmS2nJie58DTd1q6TBojlCOaJ/2aQ0G8z+s87Oqt/A/kruJEr1taAAXPcRjrS3BJBbR++lBXzpbiRwVUF6E1FeuAqYdG4/cBC6smJcMGSp52ceFjt2CxTrc7cKloxNfKYkS/CTKEflKIyURjtU3+XukI2IfsywHySd2lXyb2NnFtwaK3RnnouFW+ABnbB1zB+bpc5J3K4m08hH/vppQkIQYamzf5jAAVcswheqiZ3mL1ckgV7/g8G3Gogn/LqsKSCwMkbDGyFYRnOwuW7Q4zRObeZE4Owm1QVxu7XNFvJ52lgB3yQDSsRC+9UVXuE3t8bbRLy5bp5MFgK2a5gVBKQFu90ud6o/lPb/icyveCaS2gYBWt1pSFIU26huXQlYxUIlyrlCL+vUMGeqzwP4/q+2BYp3IGY3KQUvuksrpeJN8rOuhb94WxSilyzUieePHr2PhyNhpHuDfbr/6CYYww3zCT2c/FlXm4NDOo21BBTAve9gxStzw1W9pmxOPEpH9P1ylzv8WWOqOJ0g9rCyw/2rXgL9kU8yW8ub5yu7kHVR7hgViImv2XjNggyA9j7jnovj3PcXqNxe5AgPLFq46CgktoqyyZKuS8bfNb4qLGKAlitj2EGlaiDFAKL630/l80sCiTzJWOfrsm783O3vMUGgLGERTnpO03BtavDdJdMAFJEBRekJcb6S6kcick9FRx1iTrSFMix2W7ttcgIA4eBSilaTXQTVj6ODRtsQTH9zSJ6RkBOMIaYPwXUoKgzMjfp9I13dXWnhG+ogqTzA24qVuwfu3kloRASOkmZ/bhz5S
 ww8HeI0Y
 RT/DDUvJWMzk4awdcxomhnIek6PjEtNYewu8twylJM/erPXjHiLiVcF9wPoCHOh6IuNhcwgZX/zZR1JknHmaDoQGRjbIXm+rmVTe0xHCY+IWMANPZYWVITSuMpcJ9y8e3IuwP9TeyPP9ll+5W6XunsU93iaxm8/UdYCDQNfeqSIpLcoRVo/sr7zZX2FdUFHXGiqigIPWweYOYGl6pJn3vnbnmAk+QvnwzX512yOfJa/jCOjDe58Ug49H6On54110+LEVskTzLmAocXt2HMYApX9Bj9ds2VYihG5u6s+FSgNGMfAW/oFAj084zcSVj/q6ZIvTOmfprZV75ysuz7KB4ZnpljRHoU7qGl4jIIWc6FqgLDSNOh15GhqUxGT60CcthurF3kkOQnskboxznjeMkcHOusNX9sF5eU2b4ncsO4f3/Suw7N2HuNLD0RdKW/AGww1bIPnwe3Uc5ActHKNK49lqcfr6A1B4YPKahRC1OgaSoOrToeSiRbeWoCwbsDsNTO71BRC7V6FYjLcexkomGB5IKy8Z1pIIk6EKUi0aBo3RxqRPK2OHTU61mIjcOirzzsbkXM87RrGZdRbzryYqTb3dW+CDnEtJMknuZm4hdilNMFEPUmvMHfcM7Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 16/11/2026 5:41 pm, Catalin Marinas wrote:
> Hi Usama,
> 
> (trimmed the Cc list, some lists reject it as too many recipients)
> 
> On Tue, Sep 22, 2026 at 06:12:28PM +0100, Muhammad Usama Anjum wrote:
>> pte_t currently describes both a software PTE value and an element stored
>> in a PTE table. Consequently, pte_t * can point either to a software PTE
>> value, often a stack copy, or to a PTE-table slot. The compiler cannot
>> distinguish these cases. A value pointer can therefore be passed to an
>> interface that expects table storage, while table storage can be read by
>> direct dereference instead of the architecture accessor.
>>
>> This series begins a staged conversion at the PTE level. It introduces
>> hw_pte_t as the element type for PTE-table storage and converts generic
>> MM to use hw_pte_t *. Software PTE values remain pte_t. Interfaces that
>> intentionally return a value through pte_t *, such as install_pte,
>> remain value interfaces; the relevant parameters are named ptentp to
>> make that distinction explicit.
> 
> [...]
> 
>> PMD, PUD, P4D and PGD storage are deliberately out of scope. They can be
>> converted in later series after the PTE boundary is agreed, avoiding the
>> PMD-specific cases that made an all-level conversion difficult to
>> review.
> 
> I looked at this (and the arm64 counterpart) and I'm not fully convinced
> it's worth the effort (but I won't oppose it if the mm folk decide to go
> this route).

I've found direct interest from s390 as well as arm64 devs other than us.
We all want a sustainable solution.

> 
> First, I'd like to see all such on-stack p*d pointers addressed as a
> prerequisite (e.g. fix pmd_populate() in __split_huge_zero_page_pmd()).
> If for some reason we deem pmd not fixable, I don't like half (or
> quarter) baked solutions just addressing the pte.

Only pmd pointers conversions may require careful review and some discussion.
Other remaining p*d would be straight forward again. I think if I convert
everything, we'll have 30-35 patches for generic side only. It would a little
time consuming to rebase that again and again.

I think, a simpler plan can be to post the pmd pointer conversion series
as well  in the open to get better acceptance of this overall effort.

> 
> Second, we could add a run-time page table check, at least for pmd/pte.
> Something like below, gated by CONFIG_PAGE_TABLE_CHECK or
> CONFIG_DEBUG_VM (untested and not entirely sure about using
> PageTable()):
> 
> static inline void pgtable_ptr_check(struct mm_struct *mm, const void *p)
> {
> 	if (object_is_on_stack(p)) {
> 		WARN_ON_ONCE(1);
> 		return;
> 	}
> 	if (mm != &init_mm && virt_addr_valid(p))
> 		WARN_ON_ONCE(!PageTable(virt_to_page(p)));
> }

s390 already has CONFIG_STRICT_MM_TYPECHECKS, but that only provides type
checking for page-table values. It cannot distinguish a pointer to
page-table storage from a pointer to a copied value. Consequently, direct
dereferences still appear in generic code and can bypass s390’s
architecture-specific handling. They have been trying to fix [1] differently.

RISC-V has independently encountered the same problem. Some RISC-V
platforms must transform page-table entries whenever they are read from
or written to hardware page tables, so generic code must consistently
use the architecture accessors. They were trying to fix it [2].

These requirements are therefore not specific to arm64. The aim of this
work is to provide architecture interfaces for manipulating page-table
storage correctly and to make accidental bypasses compile-time errors.
Architectures that do not require special handling can retain the generic
representation and trivial accessor implementations.

> 
> You already have some coccinelle patches to make the conversion. Could
> we turn them into a coccicheck to detect new uses? With LLM reviews like
> Sashiko, we can probably catch new uses violating the requirement (we
> need to document it).

Coccinelle can identify common syntax, but cannot reliably distinguish the     
meaning of two pointers when both are pte_t *.

> 
> LLMs and coccicheck won't catch all abuses nor does this series prevent
> one from declaring hw_pte_t on the stack.

By using Coccinelle and LLMs we can still get regressions which arch-es
have been doing over the year.

hw_pte_t * makes accidental violations compilation errors in every build.                                                                                          
Deliberately declaring hw_pte_t on the stack remains possible, but is explicit                                                                                     
and reviewable. (RFC of this series has info on why we aren't using opaque
objects.)

> 
> Once the above are in place, I'd look again at these patches and see
> whether they improve code clarity and are worth the churn.
> 
> Maybe an argument in favour of these patchsets is future dynamic support
> for FEAT_D128, we'd need to separate the software representation of a
> pte from the hardware one but we've done this before (arm32 non-LPAE has
> different representations).

Yes, that's also the big motivation of this work. We don't want to depend on
the config options to turn on/off features. Arch should be able to turn on/off
code based on the cpu features.
> 
> That said, patch 2 (naming the software PTE value pointers ptentp) could
> go in independently. Same for David's suggestion on patch 5 to replace
> the huge_ptep_clear_flush() stub with a plain declaration.
> 
> Thanks.
> 

This is one time churn for multiple kinds of benefits.

[1] https://lore.kernel.org/linux-s390/e50fb51d-72ac-4ace-b532-5cf32ecd80f1@kernel.org
[2] https://lore.kernel.org/all/20251113014656.2605447-7-samuel.holland@sifive.com/

-- 
Thanks,
Usama

