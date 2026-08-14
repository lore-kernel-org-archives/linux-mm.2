Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 741FCC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 06:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AFA46B061C; Fri, 14 Aug 2026 02:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066D86B061D; Fri, 14 Aug 2026 02:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F0E6B061E; Fri, 14 Aug 2026 02:14:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C221D6B061C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:14:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F702A0391
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:14:59 +0000 (UTC)
X-FDA: 85098861918.30.B52C9B2
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013022.outbound.protection.outlook.com [52.101.72.22])
	by imf20.hostedemail.com (Postfix) with ESMTP id 39D9A1C0007
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:14:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=TSzGRwUP;
	dkim=pass header.d=arm.com header.s=selector1 header.b=TSzGRwUP;
	spf=pass (imf20.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.22 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786688095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7E8mQTQkszrL3pdGu55t6tAcNsZwADSBGU2Mse1nKbg=;
	b=AQtJkGvbD3CZ8zki1kk5wyfGmdIhFz4XJXN047Gft80g5KeyOjvfoY2Kh7iq+qq1pXYP3P
	5zU7yOOnMW/x5GouUqbWHtSCMtsqioIEH278SaYd49pV2P3+7hZb2rULKPq2ecvwOcDwka
	IswMBJ3c2sB87JV/sA1sAePa/n6FYo4=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786688095;
	b=CR3wtFQ33LXRlfZJfDpam1NuYXtgNlUriQKr+53A4JuoBZ0KPlcRB7IX/7S2JIxmxuBG9N
	GLZYbkLxyKk0vHPL+9vFuAo4eS57+q/4oMdBFMKYi8Ft8nAI5wRzIpqUmirrozHCevHk8A
	SjI3fkVwIK9tNSLRYDfEwqMfwAojptA=
ARC-Authentication-Results: i=3;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=TSzGRwUP;
	dkim=pass header.d=arm.com header.s=selector1 header.b=TSzGRwUP;
	spf=pass (imf20.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.22 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=RE1QFum6p2aHmcEwifuonQRwNdNQQLPhCTV4GBlVAUys+XLysdyfFThGn255C4oekUYy/2xTV1U2nrcoDSxjw/wdTF4WTZCBlovXyHxLMDiCFNfRhEMwv75GJ5G1vTuA9G2KPvRJbf9wnRpiBomQB0AHiKX4RsNkiIkcnwkEZ7QaM3ektfHdzhj0bekA18mOd8+/trfLgaPJb3GHNp7lt7WZ6PowyXptQczGt6j97zq0cfrdTi3hLQG4b6J81RCTXy9AxEU5GZIrGdkyrn3n3ktm8t15h40GXki5FFfulY4HLb3sr7ExFU5cnmz7EPUTDG4s0cwlFQMmVUgY8JxaUQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7E8mQTQkszrL3pdGu55t6tAcNsZwADSBGU2Mse1nKbg=;
 b=aP4RHr86FxJoJDuTzmEUe0dikzwxofHi+O5onxkhRsQtyhPRtS/CzNGDRcKfB7XTV+rTTK7HGuhljRvveJtkhYjX4HeBd/emJUxDaz6KEAWZz3nGcHfUMwU+lt2iMLGavCO56TiXPgCFcnxuIokiqqnowbqT5m3mRzrxxNwos2qQts/TGm478XWM+DW5u7e3qqRDntheluQcUWtTigF16dyY4OF3KebxmPvB0l60NzUSzDOT/H5Frp4fgqsLjGfYrow+yah8LTpd/2HOTeLRPhMa4mBp3BJ81Fb2PUcc7AodoNAlRweiU+gDfgvlkcfQlRie5423JVcJvSkswjlzXA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kylinos.cn smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7E8mQTQkszrL3pdGu55t6tAcNsZwADSBGU2Mse1nKbg=;
 b=TSzGRwUPFqTu32ntuvFCLq0VAgHxwtTiLhk11ru1yNYpyiMTUJsSo+HJkfxF5C0hqYsfsa57H0cJ5tDDhtQdKDRguqNGRHx4QYcR74ZyZV4tslzzPyyepbblpi/pKEI+9B/Fh8jbZEfmc6KWZOX8DkILcbqXYfH5CQl7TmudlS8=
Received: from AS9PR05CA0349.eurprd05.prod.outlook.com (2603:10a6:20b:490::33)
 by AS2PR08MB9690.eurprd08.prod.outlook.com (2603:10a6:20b:606::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.16; Fri, 14 Aug
 2026 06:14:38 +0000
Received: from AM2PEPF0001C713.eurprd05.prod.outlook.com
 (2603:10a6:20b:490:cafe::4a) by AS9PR05CA0349.outlook.office365.com
 (2603:10a6:20b:490::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.16 via Frontend Transport; Fri,
 14 Aug 2026 06:14:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C713.mail.protection.outlook.com (10.167.16.183) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3
 via Frontend Transport; Fri, 14 Aug 2026 06:14:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qADItRFIrBd+lgu5HART9WRspx9P7zccHFpKbD5MKQaFGhuLdeAXucyM53HMUUo+THWTzdmiePauAKWC59QlmrsiCD9XamOYFyFlf8CtZdhnEYE2akBBsEEL6Ze+4DfxMGEVK4wcKSYuVKVnoG8qiVtZ+coP8m9GRJ4Fc8ikSnw1T/NnJjEgXtGUc+VxRNEZPDPGzyPIBsYv2/609kQJ5iBUKqtRAvFyKzwe9+39rBz8BLNAbdZJxHEdxpIQNTksvC6ahQv9mmyPjMnWbrf9I6SUSx/oAVyweZJn1u11JPUgjcssDJIu/ETjTm6vzzX9/YEmNDpTgNQtxDcH4zKLTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7E8mQTQkszrL3pdGu55t6tAcNsZwADSBGU2Mse1nKbg=;
 b=Cde/t1DY5JponK7NdHfTha9SPZluvCuyo3j/LTEBgwJWUUryYVyBOPdNot2GubSo3BG8yChc9PLawiPZrM/QJMXi7gXOo2X0ERe0TNdEDXTdGZL42um6s2sImLajIg5len6MoSjZReKbUAOgsDHalKIZrBjxWAuJ09PEIPovETwtMt24KKQjSskOdkTlrcRJVdYSv2rnHWHv9yzXhP5N3mfmCB9dH+xru6oC8Bqg02xW2AwgEbtbnqPimKDUxUHa3ulUn/UzZBIPMw3XtsRMnnQIZmpy1Id/uuYwcH6qjrellbY3oyGfP8eRZuwL3wcyKZBjFHvQVqQULZVhVzCvxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7E8mQTQkszrL3pdGu55t6tAcNsZwADSBGU2Mse1nKbg=;
 b=TSzGRwUPFqTu32ntuvFCLq0VAgHxwtTiLhk11ru1yNYpyiMTUJsSo+HJkfxF5C0hqYsfsa57H0cJ5tDDhtQdKDRguqNGRHx4QYcR74ZyZV4tslzzPyyepbblpi/pKEI+9B/Fh8jbZEfmc6KWZOX8DkILcbqXYfH5CQl7TmudlS8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS2PR08MB9200.eurprd08.prod.outlook.com (2603:10a6:20b:59f::9)
 by DB9PR08MB11243.eurprd08.prod.outlook.com (2603:10a6:10:5e2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Fri, 14 Aug
 2026 06:14:04 +0000
Received: from AS2PR08MB9200.eurprd08.prod.outlook.com
 ([fe80::e16d:9c1a:8c8a:377d]) by AS2PR08MB9200.eurprd08.prod.outlook.com
 ([fe80::e16d:9c1a:8c8a:377d%5]) with mapi id 15.21.0315.014; Fri, 14 Aug 2026
 06:14:03 +0000
Message-ID: <0783c494-09c1-4905-803d-c4f489d9b2aa@arm.com>
Date: Fri, 14 Aug 2026 11:43:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] selftests/mm: emit TAP header in uffd-wp-mremap
To: Song Hu <husong@kylinos.cn>, linux-mm@kvack.org, akpm@linux-foundation.org
Cc: shuah@kernel.org, david@kernel.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 peterx@redhat.com, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260812120821.523860-1-husong@kylinos.cn>
 <20260812120821.523860-2-husong@kylinos.cn>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260812120821.523860-2-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0299.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:220::11) To AS2PR08MB9200.eurprd08.prod.outlook.com
 (2603:10a6:20b:59f::9)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS2PR08MB9200:EE_|DB9PR08MB11243:EE_|AM2PEPF0001C713:EE_|AS2PR08MB9690:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cd6e78f-dd69-4f96-4796-08def9cb5191
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|6133799003|3023799007|56012099006|10067099003|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 crdiHlPJmol5+1RZXd1F1b3KXgHGaVyHQwRKkd/Cnwdmm/ufbwt2BtTqF4HKg6A2UARJqczJM/QpcrgaIetwbtzC+75p0nfIh2puvP1jAfODzxjLme/e8zbl1zlw1rqPW5spx17EWk8x6T2LD2ptQYzMi+s1+2922GUkTx8I2RxgT+ZX6sD6FiRV3QfKmutT3QlNwv7RKIVYIgEaV6A9hhlDgFU0ka0Kn8+a1FIwkew44UPYF20/bRSyE29gZGaHkkn48H83NDVZN/fmmFdnKghins1YFyRrfQz01aIISd4Pe9okzIAxFSK5U40YJV2wQtTRQxNMtYcF/dpuCduU925I5TrUQ2fJifSz3n8LYqOh/mZ9533wg00l+bKpSZz0gnKFodjGhQdgaRB1ZkeU3OqUvfDUuse20U7NrmWLbzVY59Kd8vbn6x/8SCpMx+UevTIgPqsKpoKUeMyK/1uvVBBi9zIgonU/PlLXHjNzI3n3ISJCKOpYSS/AYFhoK/qMRSmS4pFXoXiXe4+87F8zw3cLNR/G5jbYk1lWt+LBwT//CriMXJogDdW5yyYHXFeEhYpJNdhQi0OhbgsgfnNbr70ug2HJTYAepsTXpMZQgS2jH4rqQKVQpz7uqNhMd2gahcc00aL9hDnH3EcTkfMvPymwJ/cefeoNKOdSHNzuP5A=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9200.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(6133799003)(3023799007)(56012099006)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 XrdAgCC0Qv5dklsBF7+W7ethSHbA7AIYmoBesUE3AH/UH1nv1bbQRFvURk2RSzL41dUNhsUx4+lOBd2biC6UOqpgaY3eBNMO97yVa7HpAhiqzMzXig+rQaTfXGTslMUn1J0XiHQZKH0EvZ+J1wpdttG6mkwQg3bbSN5rd6cCrdK/sFmKzFJewU8+UxhlSxuTxsOFiMGrC9QjtVBkFIVeKDZg5MJYEArqEITSgyDQ2QVRjPuhwlEI0/0X+0DQAmbqBQjOU6Py8/9cmzSX9ryryACFcK/mUu2Zecsy7fT/w07iUm06NPZ+Ck2Jf2AWEGsY8DHICfFogPCIjAMepAbTig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11243
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C713.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6cc68984-2990-4084-4b6d-08def9cb3cd7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|14060799003|1800799024|82310400026|35042699022|376014|23010399003|36860700016|22082099003|18002099003|56012099006|3023799007|6133799003|10067099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	+vxE8Ch00JrSAGR3mxHZPBNu+ORjs31buBoihyrW0bL7uivcSqI2SlmuzKfxVwaMLq7t2cTpAaK8qF7lZK0tufaSB6R7TINStT2NqUrbvRYQLXtZK1BEev11+tmmyxU9ncBwS2RCHlpF79li/xyjfhSjcM2W4QkBu8jqWglJy0zfm5AGuegX9iQaq1S9+/flKaldhK9/PjhpAzECi8SBjsY35lNLd4GsZrxDDXXJNk9LO981MGEDWt9a3itao8GPkHR0DvQF7X3jmY93ixVYu8O1QTV/lt2ilroa9II/vC97JwKiL3MZzq+4XhR5P8y37D9JxLnm3iG5Tm2QO8DvlbuMe13jCER1FrMSb8MHrp1qxRBdRP+bwkN2f3PDGuvN8Ryj96/XgCGOilh177o1Pbwz4qncegoSsptESWilgpwBA9SPyIybRC3VhZAuxax6xE86gdwtjGgJCd+pLvaFbmzoE8yfGlTShruWDTOivGVgAv/viW0aC9TFBsoekRJip7WQ8+cArroSnHLdGr8GcIK4GJo9QYldX0X6MVT/gb0DSwRkyXm5fDPQPdqpPn3zQYUeiIRO921W5ey2IMxUVBmrXTR1SLM4k7v3IPWpzu3GvwQ9UvSvJrj4HfU0ihdwpqytli4eGyAsf6d3Zxw112nF9Rm8YPWchXM5ziJ4sLcCwYaRs7jElQtF1uCUdfO1HbKtYncjbn5SZA9RzVV+xA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(14060799003)(1800799024)(82310400026)(35042699022)(376014)(23010399003)(36860700016)(22082099003)(18002099003)(56012099006)(3023799007)(6133799003)(10067099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7FHiVaP8fav/Nm7Lb+oeN7JhQwXTOP9hGBYVfQ8Iq6a96JSsuHANSop5sypskwRrl4FDTJs74JZIqNfX8H7AxVtNP/taJBj7KnPKBN7S6zMABbp8sKqzFQ0mDEuXa9v1ymlpOGs1bBP24zcnveds1pg58EmZ4DHUgSsMNhxOoUQQwFh/U5fdFSKDV6XBsY9eaTrL5K7ajPiloNs/so993DJ5ytVsWwR/khQ3jzxNIpQQ+0eeSIDuaq3s0zLqI3xgOZDzJ2AxGowATPyktKpjXcr7B42912Z2peWPke+BegAdDFDK3pLLLHamGCBOuWRHL8sdMkTf8u10GoeXrqF9B9qbzMueJmLQ9s9TFIS2tgWOhfUXaDnB+xxy6sCqqbtYrDI4hThgCtT2td/iD4/ZYKbLFOh1NLP0iE4c07SkK8res/MDL96HiDLu+8RInx6X
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 06:14:37.4412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd6e78f-dd69-4f96-4796-08def9cb5191
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C713.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9690
X-Rspam-User: 
X-Stat-Signature: egn8w85ghawdmgyrgzz8ukx7yorxmtib
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 39D9A1C0007
X-HE-Tag: 1786688095-32956
X-HE-Meta: U2FsdGVkX1++0Jg61m62iERK2L8Ei68WAhSaidpRajvAoOeBTn5uWTQbLTrCmJRFzCcKEbM4lTp98oaE2mKnJc7dNLSoFI6SHzzy2rzeuVNIe0ej1XDzR8RJmynmMGWKKCg3X8HTshuJF6Dlz7Q+1wNC3Nig0qy3r9LlHvCVVLHlvgb6cC+LVgo03o+GoyhDseyTLnhfs1n7Avb8VlLvXo/QpuwvVWaFTmK+AuwqH1bS2F6IDnbR5nEUhc3oEr3K66C81qfGuttiZimkfY8UEIzRrJg2pp8l0xKVWCGZy+Y8UXPfKzg0lPWz4f6c7RymS+IDUcor7vg+zCX8UUn2/ArQmgO+a6Zb1qrOzq4S+l8fbMWTfl7rxldnsy/6T5I36MGn9Z2T8wuW5LRl8oCLMXVMbhsOpKtHwZPYILUeHf0g1+gGVKGR8WH4FdtpL2yPZwhfvJS/f0wQJYvMk7ntKU+gOudJ+bSvf9gDwks4tknGc+NMTK+AuTYLgzyIEqzP9SnLW3/tM1L4J6A6t22+aJbdfs0s82NfMxEqYfIP3T4tAJMP4i5z5t+9OsGZENagAvZQFc4T7Y/+vyHVk05wRztxnI3cCDRRJ4iAm5Cjmqhq+r9Kno//mCJWkdIy699dSc2QyP/9BIE0vA0Bw5VzzBcJheDAHQRzcgExGllitScBzxFfXL1k4GRAQ8Rmd0UTMBoaF9kPorWrrTRxh84dPn73w4cwbPtXTo3KHihvo2OwiJk50cyuehSEMVmUfU4eajH3l7u0H5E5SPFrcACgr1UPCfYWhkMQD0oPxUnhzp4FVtVDA0QCbDONgXaSJrPxr1zg3rnJzc39g1Fo82i58wcgZBBFdGoEJMSm7qmynTzdlg4/7KDcKl2O4s+suMsvA+pmk80aFfsOFWeWpYItJIhzzSrSMeTEZiKfjMYNtdXSBNZUrRlHY+aiBuF7h3Yuz9VQ38bZJU1vi20YbDk
 23vXIOnB
 uylP9Tc77I2k/JYVReeQ6ApnHUeWeyVuPmfEpqqtoTgjbmweeYIG/6hAKkaKLZ3vD7RL3KFEcwNz0TJm2DBEtdEj2yuXya07gyhbcIIE2EHnklmOVbRzhOB8WySE4L2O0c+fAQl0gFZ0YWL+X82OY4OVT2shoyNUNpaOa4ruvR/XZFg4zJfSSTW47v6D1l5GPoFSc4JeoG0wPkDWs9w5gJ50fk8qPw7fqG3BlP7YodyME9M1nLjOA4b7hWbX6h59704/usRnjZv1nyyxlYuH4OXN7tyGD08PeUtslziMMKdYzICErqGE/o0x5NpSM6e1tSw48jZGJaQA2nUi0eS5c5ybusFUsjXWoUKIEhIIALsOmYgTpcAo9dM2DVs/ga5jrty2R7aLXCNGi//zrEvrfjxBmwhLUunTAMYnikIrX46t8Nf5JvjekEeC/PNQ8uEkB5QvKFycUunpmQwgKmjYmXA3IvRJwT4ieovvg7XgkfFCNqLyymBSVYouX19nhE8QxbVOMxxBv5IcrmCIkw51RrC/2Wz4s281pq0xZlz6MvaOaV6Pwo4nvzeTsJhFwbAo8w7Uf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/12/26 5:38 PM, Song Hu wrote:
> uffd-wp-mremap calls ksft_set_plan() with no preceding ksft_print_header(),
> so the "TAP version 13" line is never emitted and the output is not valid
> KTAP.  The sibling uffd tests (uffd-stress, uffd-unit-tests) print the
> header first; do the same.
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
Looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

