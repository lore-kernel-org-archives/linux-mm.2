Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A158CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 683966B0093; Mon, 25 May 2026 02:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65AA46B0095; Mon, 25 May 2026 02:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5493C6B0096; Mon, 25 May 2026 02:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4440A6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:15:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87B30A0165
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:15:04 +0000 (UTC)
X-FDA: 84804929328.19.3404BC8
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013003.outbound.protection.outlook.com [40.107.162.3])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4C35740003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:15:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kHE3tUpZ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kHE3tUpZ;
	arc=reject ("cv is fail on i=2");
	spf=pass (imf11.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.162.3 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779689701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xuVyQO21pkKyzGYvd58ZnTfRCZD/90PQcn0sEGBSP1k=;
	b=UGzHQkmhU0RCVOT43obouupc9xam8Je72WmXLH+BDqb53bJTqw5xA25ozYYU9TmK9W1/Vm
	Cc+KtNGIIL7qcURp0XLytiRlmtSnVMuiIP3+3mwrmzAuFYu/Sg0KgxPmhg54vMXTNFbiM7
	fdRl8w21agPTaaFQVPXsO7uzgRsk498=
ARC-Authentication-Results: i=3;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kHE3tUpZ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kHE3tUpZ;
	arc=reject ("cv is fail on i=2");
	spf=pass (imf11.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.162.3 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1779689701; a=rsa-sha256;
	cv=fail;
	b=yrdC/FDiNxhM9eJjzl3ZJkKKQyyUONZ3fr/6gKbINF8AxxIW9Qw7L+M0pz3dnRN+55RTq2
	QvVEintcs7ayEWKPns9PQGmcHGgewPRE3oEc8O9qAYgUjm6flR8PUGFhLI6O4FFtq8ZThW
	Fa8hUf40+9nynH6HtDtqKcYYBct8yIY=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=FGjDIc+JOG6i3VpDt9gX+8OIsf9TFQEHa7XzBvtJPINvb+OBWCMN+vybHD13JZfcVgt1SawqsHSfOHEdtnTT169c+XK5ZXwexcv7NJf14ZWGJJn2zXFv7J2lf6j6BSBBpbSDfatQRBDCJZiFevl8/V1ir+h5RMKbf+y30iEl1LHzeAG7eUKIh0SHiAra6QwM5ECpriGpPDZ6SWujk2vqt7GABgVeZxSUcxtxI04IhWPKFp7u5FalzYkMt/zI1ljiirRVextRL7hU2SBDVQ7wpAmjCGcajwXu3PUkZSc77PogFaCNhEa/znZG2/O9qG8xCoTr0idnwwO6Om/UAKTVKQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuVyQO21pkKyzGYvd58ZnTfRCZD/90PQcn0sEGBSP1k=;
 b=U3LTooV7DVPil+1G/XzQkshi9yrX8EoLP2u32kuycwpUOCay79txhK+0/zQpdPu86n9D3MD864B7Ipo/ay40pSp7BPoqVSt9fdHI4CyOaQCXySvcqlGH3csh6ekyblv6wiKDH9XY+/VRKuv3pfP8X99eWUEhVUVs16pyD/Z14UhKEYS+XI259iDsN04vJcSGGH1gtlhRh4EclN+FzG+hSZW7pt/WFO3HGJap5C9SNf9zZESDQNXPfIYGZ5/j66DUc/4nSFvZ6ZzMvC9c316s3fzpvIjFa7FXco5tzx/ehclMOxlWowt8dA/ofBUg0MBxdYW5w/MTBp6tM/q2UEMG+Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuVyQO21pkKyzGYvd58ZnTfRCZD/90PQcn0sEGBSP1k=;
 b=kHE3tUpZQxZOvqN+jL0S4wqNPrAicqiXsrsqZkNYf0+HBNm4/4dh3c3zhVTfVh3FVGTLJBTyKbJ64+ABZoWIrehT1rBHFcs0468K89uE797c6fV6RPIsTOL/gzBVEPChibk0KcRtv7Ie12F1pVOqikBW3weCDrI10I/G0wiVJy4=
Received: from DB9PR02CA0013.eurprd02.prod.outlook.com (2603:10a6:10:1d9::18)
 by GV2PR08MB11442.eurprd08.prod.outlook.com (2603:10a6:150:2cb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.19; Mon, 25 May
 2026 06:14:53 +0000
Received: from DU2PEPF00028D12.eurprd03.prod.outlook.com
 (2603:10a6:10:1d9:cafe::8e) by DB9PR02CA0013.outlook.office365.com
 (2603:10a6:10:1d9::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.20 via Frontend Transport; Mon, 25
 May 2026 06:14:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D12.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Mon, 25 May 2026 06:14:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WscfrDPIfYYI1HleC75jTJxm0I5dr2V0TLWGmP/fE+kMaJN4YhoeGAT8huqcudguXg/KL1Jbce2RSx6UmBr8V6sH9NJKLSkyqojLulHy/tUHaxYYz+sU33t61hnqIbWGeQLoMxtXn02lIdpGzObJ634OZLhgJsE5plRQfWZnSC1dd6rPVuhv+zwPlrFtKm8QCsJrVyd7KQA6yqTfna+4ql1QzXYnRLikuOn29H48srAXAo11twg8iZy7zh5dMpZsHbyGr1QmGRGmuKAzY6vGmbteSWwbAYeX7Dex33XleaCmy+fDOfgo7aTIttVopY/plqK3X5oSoT2N/B/GnYJGVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuVyQO21pkKyzGYvd58ZnTfRCZD/90PQcn0sEGBSP1k=;
 b=ikYbUbeFe1GtCLWN0JkecLt43+T/PsAw1Xe2kmnUroHHFFx1rXJYhutZZi0BJrQHI7c0oanX/hBwAc++uUSqfI3pJuIXrtdfmAtwbfqQxZ+QOYQevwYX76BF85axfZw2BILb99gC1pdZ8Cf2UZDkNAWQ5exkVoAjubuGffu2PCTPOy+1C+UUQSvA2kfr3XiNhqKP3EgQengXwCsZH+TRSp6K3nkVFv1BPKztV1gw4vIhjVTBUezDX1lmf9IjHbZAmSJXqd2eNcZjnCzIkXI///OonTgGOPfjRF6Zi13F2rHSuDrFhPRMvMLk4cepnMCM3vXwaQQvLQMZtikxHM90jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuVyQO21pkKyzGYvd58ZnTfRCZD/90PQcn0sEGBSP1k=;
 b=kHE3tUpZQxZOvqN+jL0S4wqNPrAicqiXsrsqZkNYf0+HBNm4/4dh3c3zhVTfVh3FVGTLJBTyKbJ64+ABZoWIrehT1rBHFcs0468K89uE797c6fV6RPIsTOL/gzBVEPChibk0KcRtv7Ie12F1pVOqikBW3weCDrI10I/G0wiVJy4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DB9PR08MB6651.eurprd08.prod.outlook.com (2603:10a6:10:26e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.19; Mon, 25 May
 2026 06:13:46 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%5]) with mapi id 15.21.0048.016; Mon, 25 May 2026
 06:13:46 +0000
Message-ID: <8992b3c0-a2af-436e-a50f-3729cf589d09@arm.com>
Date: Mon, 25 May 2026 11:43:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] tools/lib/mm: move hugepage_settings out of
 selftests
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Mark Brown <broonie@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260521111801.173019-1-sarthak.sharma@arm.com>
 <20260521111801.173019-3-sarthak.sharma@arm.com>
 <177964236208.4000040.6637433432678119173.b4-review@b4>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <177964236208.4000040.6637433432678119173.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0026.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:17a::9) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DB9PR08MB6651:EE_|DU2PEPF00028D12:EE_|GV2PR08MB11442:EE_
X-MS-Office365-Filtering-Correlation-Id: a318d17a-387a-4acb-8ca3-08deba24ef1c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003|3023799007|4143699003|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 wZrPkLadTV3TvaARsDfL9rpF+jy1/LVEs56Ohbkx/JtO29fUjb32pb8HN8oLUGdYM29zsITJYFO39TwtMbiMWmbRIvCOAc4yjQvKkSX8uBxVy568ez5mIE6tnEBqOk0hg5GAPwtheu7aWrCj5okYd3Om/uhgbYw9I2YKvduBydcP3hdHmqfqfWUUthaA54vyruW6Bd6v3p2e1JDOkVZ2eZPXkqbs9iiSxHd2hfPtZoMZuEdqyXfwRH2NdjXUauiNKLOMzhlf/9JogrJn0em+Km8ODeD0xR2kb3St50NjQ78XJAYx7CIxlVgCtCpEWz3qWlHDlOrd7Auu5kHLJ3he6oRo+2+uLJb4pXiYGpnbvGh0dBKJrNPmsiz3BfEGMGC63g9EfnPQ/16jJI+YToi2NXCvNWONt/VgCAytrTbLyxymEF/QPYr04mqFk9+0RRPWvDQbT6otD1YnBt/aPkijoTScgFV0Jrx3dbNc4P1Q/yYE7GBBzd5NBCQY60L5UKmWX7Tt5fX2PhwaGUYN4tdOfyzmCBXSaQWM5R2Q49JiwWwJCXXyGQl8ou/Gbs38Qygdd6i4Blsj5Sj9eHpXZLSu1xWS8c2I1XiMY5Igo06v0fFxfGp8QzUTdea8uI7DvocNpk8cW9J24G5vxAjg6vWukSaKbHDuR6qNKoZMKlKMhqaOmuiHSWOt/fQLpwz+V5SF
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003)(3023799007)(4143699003)(6133799003)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 WjgIrMAoa14JtxvpthPeurnlj81vkrWBW4+QxioC5v0yDGl+kWBuU00v8GgiAUZFUoNCK/hhkP7jzoeyOVK+aaIGLHEkkvJrXHhrZc6X0XncK6s01kIABkOGIPjAK5PtGt2RQX5wCHkOKCk+/hJRyTg/sIWaQ521FVCOZIvUewF5rkQ8OJqKBBgPcZVe23k12UDxv17JC1YSWqsRNKaLsas6vGyS1IQ5Ef07tzeLc1MStzbewqvRS/OqMNOYFPPYahcj37THwFl8hp7fjQ5RM0hVh8XzEoFwFmVNPDIR/trin1z2eD1+mkR6+1Q6I5mhJ8dWs3EmcCI9NEunIbafEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6651
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d0cea919-6cc3-4949-37f9-08deba24c784
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|7416014|35042699022|82310400026|376014|36860700016|6133799003|11063799006|4143699003|3023799007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JjVVtwOeMwZDRBJkfeofrY7q+n9qKD+u/3zpih34VbYxwJGkuaViA5vAyXHy2wX+obSklBoWeKqKgLq4+FQX19hJc+8MYWyoqdhqm9nPykfJ13CQ0eXhN27oqtrfQPjqKlKYUAUuGNKTNQLjqaqhtNu2+yerBnxwAzPMWPLCZYXzRG3B4F0pyUC+ekMSqFFvmEg8BpADI0+572gG+B42AGzNYMtJKc//z4wUNa9yJOFRt2aAq4Edbewh69bY9zKK2ve9V0dZ/PUHwgtWlkEvx0Dt8Q6XxM13CwNzivBDno7bm9TimMslquCD3p664WoU14zWL3rYVVpOld59IHFMCGDEnVMdYxeg3U4q56U29XWchW/mb6fP1cMAOhGrU2TIMWBDJr3rfwl0a/nhkDv6YGElqxfzNdNnSizWqi/zD6iK0kR/02uKvJluRnblns76VQd6cEw9rXDhySjgfA/qZSw3Lv2zXtcc8AW9dKW9tDDMPnvhNEIP13ErPDVuAlyfVk9FO0cOgryLBYHHaK3Bglbw1ZqADNEG1P+XPZ2E9TlAY6NjgZBD+BZCfRrxXyZGbQIRHfS++83kEBEgVIFaILMwT4k20lP9D3QFHF6tMp75varlbNYyHPnNgLx1Zj1rLlQtXDOF3PIM7e8jPHkL3Q2O4ySI9FCVO0CwxixAuh3+atIkwx2NaYsuaVQsWBgzGR8URK8Smdyhvgkh8lkQxjvecG65ilm/0E1B10hmxzM=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(7416014)(35042699022)(82310400026)(376014)(36860700016)(6133799003)(11063799006)(4143699003)(3023799007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vj1Ep/IYtmS77+NJvs1bccUqjEhYkTDOM54s2ZRfywXMmJpOdSPJWuBu2CyxvvzUMR0y1NqGVKj6UH6Ezr2k5aH8rqe6mgsP4oALYE50quDiDAdoqPuAJqhIbJt1tP/MaxWKL0u41kyErhh9mjRCV06JodH6hNWldVh+22xSKB4xIYzuVXV1oQriDXDx8QYwm4GK5yCs0ZAhxRweHx0uGv/6rEk1C1jvNiCCiWcUk515Ch0aHrFEO3qI0JH2AP++J5LmWSw9S0kaFVqdEpqA9lwATjcqHarXSygaFoZo9aY1/lZ8pNrx0is2/+WbvQ63Mp3x2ogMg3Tp/CvoPJ5HSL7JaMHaLIa2UnWVZDnw+JV82DERRo9euyRvTXhJNUEJoSBimYYiIc4B2RtL9v6YJypjdXMO+OTme1cyLbGSYQxJuKeRe37JwaFC5k6sIHdU
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2026 06:14:52.5371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a318d17a-387a-4acb-8ca3-08deba24ef1c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11442
X-Stat-Signature: whupo46fq46k5q3ppr8pauicpcd6kiir
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4C35740003
X-HE-Tag: 1779689700-817202
X-HE-Meta: U2FsdGVkX19zojx5YKWPgckx++tGumvC5fzysVxr9dvd5ohCI/WzBLMlowKkOqpgfYwfJb7lBfLRyQ9vzwv9YGcbljxCfS7xmrlzgNyD80H6ik89EmXIEB8QuQAwAjOWJff8gmkIE673cGgftucMgLBsOkVnlG4jHlwDnVZsd8geZWRmZZAlSZSRR1pHNwoiQrl1oWiddHJCeZxKPnrTzRkLMpmBpkCpR905myype8aw2NzKBMrCfe7WuUkhqlAH9PZebe4vD5SWg86uH1w0KqK91F2aq42ggFeBfinYQCetJJb2wKQ8ZBFYGr8K5DeRyyhwvntu7gvojLUHzgBQBLlGFPHCu92YH72GbRPNH8tRG/SpY71N9jYPaaXTL9tikQs1G0zKU+0wAjWeBXU++NpQEtl6vNdEQyYtzdEf6z/VRJYhPXDHxxftRLLt0oRBajmPvyM5o6XXFSryLBNSRbefhq69SZJ09ImDd0vJLse8VmPQspIj7vY2GlQnv5y6BKVYDvYb5JdtjDQr02zerK+d3nFJe+w/nCSgmy+pYbRWH47ORKrf8ponVXdiup4GG/9Og7tLVVu4env6yMlpv14vEOKl6oj6h8r5ZJBozJewJ47tubvNgGFy70bxRP4IObj1tyf+9pxepU5y+tDMTg711kXuE0VxezEsR7uTYk/Z1aUmryzXeOWYaYK3ZrDGvTbenS/MsiOO+BbHkyOVJpnhG/wRzzelBMzXzoCWyny+HfZ8QgDyKbJmGt4ONP9o/OD2tAUa+TYgncHNapewrdZBwqbyJaNul2EWYmPUs+Jsz3BHRJXP8R2yf0mflZFGQwOHlN7bk+Z9LFaQZpapUm+GFzWsxLr1mtKP4tMczEbCCdFnTguzLDYeu17VrUMPKG33Oe/+KuAX2lXlsI2fCKDUXNrr/i/3N6iaIJrDDjL+1me2v0uAssY17ASXRovMcfwhs6TX0B2QENuOWo7
 I/Mk7SxA
 oiuvKKsV6BuOCqpk6ycrgetG1rLtKS9o2IxdGRZv2u5ZKyC2kbeUskctG+4JWv8uJzSatAnPGtMVibmQjmNg+WiDtr26PPDe3Onpmg6JW7FNnEWN5BcUKeCeUx/YMkKw8qNlMu5erqXLpCXn/EriEqlVGuFnnTbH7O7WWw+DxuwlNedQwZ7AUVoiaZ3/VE2gey01y5uZSlzlRh51g3F+hPKxjaoBZt8PQbSXKPelgLvHsCaZetE4Y6rVMEZd5PkTALTZnyc7HC2R4XE3CpVMXxWv77GS1LXCE6jakUQviGK1z4BPRNsEHczBuWmI/4BOErW6CRkMRfh3ZuWdcI7jJKHIVLmj225BOkQ2n5aKvl/VXfy4KkBSKvwJBLuN/aqLkV/KNUzUYp+kpqg6s0fUgMKV4NddIAUtZ66AeVzd5BeJrpnrEqZ5Lgu+nYc0vvZVhfDU8rhlPaaW+DpC+L3T6m+d4IqzR4hwjo1+I7D2zsPYc5uc+QZdHTIMi+7baSqpepVL/NzLOjFBj//3pitg4GDqrxwPt7wmKbY4AxUJjWAnkUw92GnoM8As5AIFxtrBAgX3+MaWXGJRZBAOWVAuvGOT1PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 5/24/26 10:36 PM, Mike Rapoport wrote:
> On Thu, 21 May 2026 16:47:59 +0530, Sarthak Sharma <sarthak.sharma@arm.com> wrote:
> 
> Hi Sarthak,
> 
>>
>> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/lib/mm/hugepage_settings.c
>> similarity index 98%
>> rename from tools/testing/selftests/mm/hugepage_settings.c
>> rename to tools/lib/mm/hugepage_settings.c
>> index 5e947abb7425..b08b27776fc5 100644
>> --- a/tools/testing/selftests/mm/hugepage_settings.c
>> +++ b/tools/lib/mm/hugepage_settings.c
>> @@ -383,8 +387,6 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
>>  		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
>>  			continue;
>>  		sizes[count++] = kb * 1024;
>> -		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
>> -			       kb);
> 
> I believe this message is useful for debugging.

I removed this because hugepage_settings.c is now moving out of
selftests, and converting the ksft_print_msg() calls to plain printf()
would break TAP output for selftests.

I can add these diagnostic lines back, but since this is now a shared
helper, in order to preserve TAP compatibility, I'll have to do a
fprintf(stderr, "# ..."). I feel this would look a bit odd from a
non-selftest invocation though.

Another option is to add a logging hook so selftests can wire this to
ksft_print_msg() while non-selftest users can use normal stderr, but
that feels too much for 2 print statements and would extend the scope of
this series.

Please let me know if you have a preference here.

> 
>> @@ -503,7 +505,6 @@ unsigned long hugetlb_setup(unsigned long nr, unsigned long sizes[],
>>  		return 0;
>>  
>>  	if (nr_enabled > max) {
>> -		ksft_print_msg("detected %d huge page sizes, will only test %d\n", nr_enabled, max);
> 
> And this one as well.
> 
>>
>> diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
>> index de0633f9a7e5..7c58506c0aa7 100644
>> --- a/tools/testing/selftests/mm/compaction_test.c
>> +++ b/tools/testing/selftests/mm/compaction_test.c
>> @@ -15,9 +15,9 @@
>>  #include <errno.h>
>>  #include <unistd.h>
>>  #include <string.h>
>> +#include <mm/hugepage_settings.h>
> 
> As with file_utils.h this can also go to vm_utils.h IMHO.

Yeah I can do this for files that already include vm_util.h.

