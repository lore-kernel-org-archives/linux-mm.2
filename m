Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A29C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 04:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8EAB6B008A; Wed, 19 Aug 2026 00:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40156B008C; Wed, 19 Aug 2026 00:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9073F6B0092; Wed, 19 Aug 2026 00:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52E9A6B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:05:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2F29A2F46
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:05:29 +0000 (UTC)
X-FDA: 85116679578.16.FE779D1
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013003.outbound.protection.outlook.com [40.107.162.3])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8E2A440002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:05:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ql5hFeoB;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ql5hFeoB;
	spf=pass (imf04.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.162.3 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787112326;
	b=58mx4tOKe0b4bbRxJY/7suzCb8BZHvmsdDnp7g73NLNTPWa9Sq1h6/72eS3fbgPYFS8p3s
	+8UcUtcb6oExL/RVrskfXPX57esKBxQGEIJ7GUkV1d9aaZsvyCgDz9JjwnRl1exFGyNsJV
	eGLWcmYG8n6WAubCfFtPsqokhK3CnPg=
ARC-Authentication-Results: i=3;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ql5hFeoB;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ql5hFeoB;
	spf=pass (imf04.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.162.3 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787112326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXx8hWbYgeo5WeghKjbKiVctait/wTVV8zSCyxlgsVQ=;
	b=qoN6hU6QB88CzXRECMVYSzDXPLXiIrtnOKz7NOEp1RWI+Vof1eFUc08s+LGYTNMIlKMe8l
	YHP2uyLnm/s/Y34fscgXU3PbAMT4QxwowU5+Q6KjtQGpgYjqn4y5Ky7ZqPxGnZI2YdhBzZ
	FbtwVcro9PIKs7RMIN9yBXfnOvB9mGA=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rqLZmcUDs+T/bYddx7TtKn420OMkH9zWBu5tpM7Lk1JcqdCLiz4MxKJIt0YgD5iJBOKGpiX7zenfw2JXYjOsMbF7v06J6S2dfIGY+J4GGI8nO3XtkxIMU3A2ez7NwQIA7sN5Li3Hkyf9K6oEfdn900kJuhkGIDaVedmrw8WBsmy8m8qwbG3vcxOudfwpVT9U6eHGJKTc5ZcP91NYkve0UErUEdYHz1+8Qkp0yNcTP8VgH2FPqpVz7pyXyehGdR+UmbIghAngAqGoBypnqx3vdalXy+kLFV/gz/O0nwFffNNi/QHPM33TM1mjOy5jLLsQQZktORKrzv2NNx/7oSwwuQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXx8hWbYgeo5WeghKjbKiVctait/wTVV8zSCyxlgsVQ=;
 b=FkNs6BMr1r/W2ErkCuasEKZ2+3KheKyV4Vxg0EIFuahlIjNFGq2UvyS/0dD4WChwFcnUBU5liF5fsJlXzO3d/Sr2cH3yZQjl5vCBtrOFtGMpfiQ7STczoLGfjQQbkbS5OFuu1o+ffT37HZG0OregagwsFPoRTUfgtHVMNBnMKO97a/8BRiPLjm5ZFbSow6Ygz53v6wSqx/WyhHU4RF9CRGlsOOr0mrkEogmKcwqsFtaYcFubO64vOELE9/o5xQUkFZBJXI7hZNcMeOdE6IaanjLQWBAmZLgHl6GE4m+KGQ/CLNT5HykLo6rekTaCnWhtPcWNBee38p2gWDB/9dFYzg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXx8hWbYgeo5WeghKjbKiVctait/wTVV8zSCyxlgsVQ=;
 b=ql5hFeoBN2tkXdgHYNd+qqhnI0tcBxANlf16XcYazDCFuGtKo3lsXfIRPhbdK6IDICY4atJAiOk8abuhanJhCbYX6GVh7rEInZZU86o86B/MGCy9EFa59rr13ivhLDL05PkLiKXkXfsckr84PuEshR7xDDZEsrfJe3LkG7a2Xwo=
Received: from DB9PR02CA0022.eurprd02.prod.outlook.com (2603:10a6:10:1d9::27)
 by VI0PR08MB11478.eurprd08.prod.outlook.com (2603:10a6:800:2fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Wed, 19 Aug
 2026 04:05:18 +0000
Received: from DB1PEPF00050A00.eurprd03.prod.outlook.com
 (2603:10a6:10:1d9:cafe::85) by DB9PR02CA0022.outlook.office365.com
 (2603:10a6:10:1d9::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Wed, 19
 Aug 2026 04:05:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00050A00.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3
 via Frontend Transport; Wed, 19 Aug 2026 04:05:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SXWGcpggR4aEwO3/LG5CEpc086OlIG2e/UVivzVSLsFKtOATC3RryXAuGhj5ML1MPaUq7gRt7swfLLpZfMkT1PcUMMAZxEqpwQSI8dRvdqchw0Ci8QAkt7Ief+mOfVHt9B5sTQCWI//hjsOTxo1b8t1oKSjHkEXr5GcwH/m6iJc/KsPVpMUicWEVrCKwS3prUs5i8aP9ykXGvUtlNAcIC8iGl5aG+ipJ1hl/ldKArBSL7uhAU0sB3LnLd0X8lII5YDF/vJCEZOHHnE1RVdCFjrz6J5vyR4lBDPGiI5OedQQu9JYMONKPeZCNN1twsC9bAowr3nPX5urmZMrbnDQhsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXx8hWbYgeo5WeghKjbKiVctait/wTVV8zSCyxlgsVQ=;
 b=wrF0JzmRLO/43PYYnrPLbtJpsfuSHxm3HqB/2L6IWqbPGSZKg0M/KahUbT7xm+tA0ybkxV47rnJtqN4YUOO7gRGRapdZZzQw2srHWNBJavrUiNTXlCxqsQwDyu9nwavJG6l1Sm6W5rDj5UxU9522zg+QCJpghvdLwClgHWkoWBTVKqJxb0JWm0NypDPm9QlkXvZ8okbDT/d6B0Fu7H4HGu1xkXkYNZpN1sBSiaEmR3LKZAACQQKdEkYOvQXjCd9V7MV+KkMg3SrcDKrgnLILGTNIl1FxG7cAyhAccoI9cO4R8Ng2E9/CoZbDQyXoWbLI66rQk3vNIwuWsnksLrZ+WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXx8hWbYgeo5WeghKjbKiVctait/wTVV8zSCyxlgsVQ=;
 b=ql5hFeoBN2tkXdgHYNd+qqhnI0tcBxANlf16XcYazDCFuGtKo3lsXfIRPhbdK6IDICY4atJAiOk8abuhanJhCbYX6GVh7rEInZZU86o86B/MGCy9EFa59rr13ivhLDL05PkLiKXkXfsckr84PuEshR7xDDZEsrfJe3LkG7a2Xwo=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AMBPR08MB11961.eurprd08.prod.outlook.com (2603:10a6:20b:777::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 04:04:46 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 04:04:45 +0000
Message-ID: <9efc3c26-61fd-4bf4-bc0a-cb3e4b6120cc@arm.com>
Date: Wed, 19 Aug 2026 09:34:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix unchecked ftruncate return value in
 soft-dirty test
To: Anshuman <anshumantewari123@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260818133206.39503-1-anshumantewari123@gmail.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260818133206.39503-1-anshumantewari123@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0355.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:219::15) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AMBPR08MB11961:EE_|DB1PEPF00050A00:EE_|VI0PR08MB11478:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f89db74-6cb5-4388-ca0f-08defda714b2
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|56012099006|6133799003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 KGaB8TqW5xSI0ay3OstdLGGzYyn6/nHbUMEHgkGneS5fQNJdVozN6cJLF64GtrR7mWjIbRUn3dMZP2zeETMe+1vqqv8He5/SX9A7mFnXTimzATRQ3/uXt0ykdysuKSWf8Mpajvt1ItAYppfY0cXYRfo4bBi6o9mKC6cSA58fHODrHSaPD9JqyNPfmMKboDmmRefE8CrMVwhxNsVBa32U3KC9q1czIJi4AeQqPxHjLysJyb4mgdQ0aUARmB9YPKYYX0mHXwQ+lUNBeuipANvq6ZY0QIDHaeDqbkYYkd7jipCPNUyf2UrQE522dU+oaOJkjclA/RCIlA3G5qdGQRORzvlPjW9a35HjP2TAT1t7+CTHVMovlW5iEi6YvN0FAM7Nz9qGV9FuV2vedqA7O4w0fdushC/MlZJ4mjc2haCTCs1MFEi6H3upHISSVtXkhj7yIiZw8pgSzL++yry0AAqMaOB0tsVgGYI2wB1FpK/wgNwmsB4t1bJWKGzRveEUZNE/Uv6VQwsC+bmIUmbj+/A3os5ooaXrycxsK9juAH+kEmY3ZywABp5O+QI00pjYJqs1IIyoO+tf4SL6HFDExhxQR1cqpVl+N5H63eCGXANPondDAgt5l3P9oU/wPNWUqwmruuiLjlvkBMToTQkKtQUxwLTEE9LSdIBeCjh25U1oFIw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 qrgkDPz5nZnuivK5CJ3zdg+GpNhtlCpjaPetoTrQv3D2h8x4mVS/+bMbTMi7fCz8SlDiFRGbnCdzBbIK6m1eNeaP2J/eDHDHJS5JSp9JvDWLDywbiO9boMcpc2+3WtoGpT6X2wO8xQnWLRb7ruTyYgMtnDxbNth8pLx6bPbeUD5Hd0vXojFKbbfWtLzLLhM3mSgbySHlCaij9bjpo2VKT/OUvL3CzgedSt0bE0kLpPob/jAO+QR3GkO6EX+dvoUeAPOVYEOIYqfRWR/6Yh9SQ+rovSwR+6xUg6XNPu4vY/plf31LbRvAvqeD+iFV3UXDwtpn+wQilOHac4d243vB7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR08MB11961
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00050A00.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7a9b9072-f010-43fc-c637-08defda7011c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|35042699022|23010399003|1800799024|376014|82310400026|10067099003|56012099006|6133799003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2DBrvZzF7Smue9wDcITY49r6TQYIxiXYdwfRHowxzFjvG4gCVQwdqyDXmLPcH/F7tq3CbbaD/1tXQCdTAvgwZWGicXoNt/lHGdPvpt1UlDFYF6cWO1q8Xo5+AJy0P5ghrfQaHNCTFsFoDTfxpFZ/kponypX80DOXUMv/lKEIpQv0VzaCB0iw1gzcxVZXDh6pjIqmHpMgQ8Cz+CkBM0NzY0VxDAGB2tQzhMghlt8bqEzXJUJsNXCqOQGuPx8v9bPGz2xRKI1ugf9BpkwvAmJnN45GPstdT6ja/oh2RoARDTApDMJ7siyNpY4iG0B8dKYZMmcbxMX+FgvreWcEIoj+WJJUsfM/bu1HoF1ZLMbogCilAweJtnGrJG5OWlshUAu9xsBCrW6tFeI9WpAqdcwP5OO0h3H2XVIHNjNWvVDlN6cLBU9JO4BZ0lI/AZlCCrZyo4kNgH9rQAXIs2Ok6nWjMhSShWWmcsz74KwgPGAzCjnD2jZlxHKtVGMn2GTLIM0qY7994ZdWupQiPaUbWsYqKjxPrN8TBs5Uay47NbrDl0XOC2AaSYxW5ZbLqxbhDZIRY/LS/vZsW8hFTg5hJkoQWgH2QQKyi2YlfMjdR6cjg2XTOo11Gz/nHjm+gZuAKQrQhwdxYTDxJAtZcfQe2Urt6PjSm5j26VpYZKYy8jyBGkKdnGSQwND6wA/fJqYfT9RzP15sTLZfYyQmrRNYARmS3g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(35042699022)(23010399003)(1800799024)(376014)(82310400026)(10067099003)(56012099006)(6133799003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bk23I28hhPxX7+IcefXu7rarAL1cLbFdpnwmimdEHxY4bjmueHgwt98kJ+2HNVPKDU6ongAoGKoyk0UZiV7yXf4RqLXaFNdTCK3GzPwXYUcsX1UQLzfP9hdTUyI1qWcfEFHIYZl5zRtiroOu6mMuE44+e1vChYRjTBtPEgsldGJHpaBQoGaGEQ8/9XCXW6boAZ2J6s+RzbmeARYsqPFlCNpdcf5P7vIBcBLm0d9rH/X6vSwNzRtJCdJ2jxy2/I9iH5C6lLTKI9/9BI/vJbJRNXErAgnQNBXTW1siLNfum7dNEMtNN4Id7eB7kJOH5gw6bd+7Cfu1kCZ053ogLSmL6dQRoC6QSWBLXVa+cQ19TIt6BBOFN9n2Xp2swd1Bh7OOH1qVNGTadFYo4QZk6cu+9lj6HB7gbglQRQwJbRSjpw83PzUVErlE7WO3/blxdA5X
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 04:05:18.0640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f89db74-6cb5-4388-ca0f-08defda714b2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00050A00.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11478
X-Rspamd-Queue-Id: 8E2A440002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: sf8coxn38wf9zqjitqqzbgbytrshnzii
X-HE-Tag: 1787112325-951037
X-HE-Meta: U2FsdGVkX1/WdaIFmxKlL8qcjgB5XpfYKI39AQ6I9OvNmPdNmxSynOQORWGNXE6xhwldLqgGju8kFxoCD29zyMNMa2gR7kAIgyc57AWiiALAtVEVq1d1QiAXy/QeA2dobAjzxCRatqtetiBiYmecJfL8t+350ooWawdFwvkLn1TDd5TpJf2bsfW28XGOJ8f18FFC/ta5gLkx9AB6lCAo/n0axT9xIYxDYosFZKQIuJ8EC/xq7BfFu6uwuauhPgB9zYN6oPPywK35NykI+n6dtyoLZl9luQc3NCV4P7qx8hlJEsQ/sRsSaJYmdSRFLNwsI355SfxT3dvya/qJFeLb2o025Wa80DojFCa8//qQ7BEfM31b4JanhkF+YKzxVah1Ef5WiDsob3CVn8gAFJ6ovRjsRY0YxP1rMdjCcXBO+39B9wAgRAdMhe4fnJouLHYL0hXyL1agT8Q3+o+OMGdyM9HitjpLzb2u4XSyX0EdmugUjn5CUL7rwIaK/Ky7sbE1myNWOgMbDhfO2qh4mNNxE/OI2ps5SewZDOMWrbfOJitxInD9vSU0SPwrBJJC8V9MQcNGf9ez5j175wCQaLHsr347zztGdTplceZanvibjEW5I6dQcisL0qrQSq/zo5olT99V6y/c4J89FUG58y9q9ab466xbQNUloMWmlUoItkqcO4RSSuQ/G+XDJxfeLOJW9aqXlQc3Rcb50OdZl/T8wa5nSEqGz3ArMxUHMpbzc+Xr7uFrfrwE9rHKMNvurv5nciAAcfkezba7uEfC91jL/LF4TVoJA8idAQlPAQq23JpPciM+DihpXhdeBf5BEpjZmH9j/dg8XudQ0oYshSFP2Zhs6kszHJu7wwNk/9fo4smWgI/z+YKNt8T9sBikwHjIqN0fLfs4nYdf0SOHcy8JakUPGtMj/gTZ4Q+6XKcAcbAJwtDmFnuZz+8b8Tjmv/p3TDzQuzjNnExnEx6nO2P
 896uKUDA
 EAZA33CmacAUW7ajkTys5+62StAu1C4Da5fiwnAbKj+yE8xG1Oi3pLN6tdQj82UA0sFxL2mhpZejKA1xAIhM2BS0uMNkmAQUIMbpLOzmBA1da99E70HtceJt9cMUQMDaRpI0q+nYKEA38xcMgc5nWaYpuxBFZBgIoDL43wOqfGYGC1guXy4qVRA5aTiE6ayqwVuhQ/75LFpuSuzDunzOPnbN6tVfO6ET0Gal97LdvwWlnLV5oBICOkN2qfsVCwg0GsqLeQ4sm2cyGb454y9ctEK9thziDsoBvSvlR12yH03kVkNU1Nu77KxB3F2iz1rWTKNVE36cMGmtwjErfX/iPa2DAS254FHObTbMGOQ6Ox3f0mrml5gUgyG5XVC7lO4l81W4Xek7ore8d8HguifSqbwqW4Vao7AHPnwob/Wg/K2E53tO0vzWG+hr2FC0FcKNv3lXGekEa2kpdZLOTphKrC/cR3PXnciPl+SnoGChMM9oeSBp08bW5YOXoxgcoRxK6KAgMsRGzrKjpFqoBp5CQmmKC9RW+tV+xlNdsCh79ViJfVVZ+EIVCBf0rl0gb+tf9YoTUjKEC6zLtWV7qdzJ3d265uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/18/26 7:02 PM, Anshuman wrote:
> test_mprotect() calls ftruncate() to resize the backing file
> before mmap()'ing it, but never checks the return value. If
> ftruncate() fails, the file may remain shorter than the requested
> mapping size. The subsequent mmap() with MAP_SHARED can still
> succeed in this case, but the very next line writes directly into
> the mapped memory (*map = 1), which can trigger SIGBUS if the
> mapping extends beyond the actual file size.
> 
> Check the return value and fail cleanly with ksft_exit_fail_msg() if
> ftruncate() fails, matching the error-handling style already used
> for the mmap() call immediately below it.
> 
> Signed-off-by: Anshuman <anshumantewari123@gmail.com>
> ---

Looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

>  tools/testing/selftests/mm/soft-dirty.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
> index fb1864a68..a52ef79dd 100644
> --- a/tools/testing/selftests/mm/soft-dirty.c
> +++ b/tools/testing/selftests/mm/soft-dirty.c
> @@ -152,7 +152,8 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
>  			return;
>  		}
>  		unlink(fname);
> -		ftruncate(test_fd, pagesize);
> +		if (ftruncate(test_fd, pagesize) != 0)
> +			ksft_exit_fail_msg("ftruncate failed\n");
>  		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
>  			   MAP_SHARED, test_fd, 0);
>  		if (map == MAP_FAILED)


