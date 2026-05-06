Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5233CD3436
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2836B0005; Wed,  6 May 2026 05:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7AF66B0088; Wed,  6 May 2026 05:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D691B6B008A; Wed,  6 May 2026 05:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2F736B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:14:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AA53160694
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:14:28 +0000 (UTC)
X-FDA: 84736434216.29.27A7EEE
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013010.outbound.protection.outlook.com [52.101.72.10])
	by imf02.hostedemail.com (Postfix) with ESMTP id BB80B8000B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:14:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=M7Gl84Se;
	dkim=pass header.d=arm.com header.s=selector1 header.b=M7Gl84Se;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf02.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.10 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778058865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHmVQebsm4rI7kRZVIei2hsBcnM71YQD2hAVEOdcbfY=;
	b=1K9JqrWDT2Bekm8yj8PH2Gvf7yvvxpgGSRCOjrjUmH8WFJB2NVoaUSZrAszfn6ecAVA0bL
	e63PNHSY4AaKqSzSlb3HknjLAzfPbMIwPNufgRKXg/v2s9U5HUpQbx8nq12FkdyfPpyTkY
	3Nq0IrI2h8mihOSE94YfAdHzxw/r7wc=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778058865; a=rsa-sha256;
	cv=pass;
	b=2cFbt2LuZwZMtx7ZhckIANqSUJv7TQRp75rviX7ZVlml0s07j2J5T6L+F8btXNixHwRYMO
	9EdNAPgDor86An1gliNc0xpTAZZJKuCy7wV7tVwdv7Iqv/XukagbCClkl62FB7XgaCwetL
	5D535tcaSFfxm4faa4CpAazo5E9MutM=
ARC-Authentication-Results: i=3;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=M7Gl84Se;
	dkim=pass header.d=arm.com header.s=selector1 header.b=M7Gl84Se;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf02.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.10 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=zM4etLyvyMP+MgwET5zn4/totQNAJx597zxK+Xsg2nf+BYFhOeIbXH+sn6AIqugimGQgUg3l2lyGvDfHr6IkRKSS79KPDZaknZMMLYyJuakkBefqRH1TDbbZocELqxjV4YwDA7jR3mREDIXrCpkTCW9ag/i/T7uAoxnJ5GY55KV6r8hLjntFYaI/4TZ5lAU+/O0uyn8qR3dR819juJm7xu2M0z2FxjhG2Bhy2zZv9cfL+gHp1UPy5Bg8K4HsG2di56VyyvBjdCvod+ZsnZYrvNXeY1tr/fTGsSpbC0BVeIjWV3shKAWGyNJxGuSw/ufdz7dWZq5RGJDsZ0q1lrPRUQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHmVQebsm4rI7kRZVIei2hsBcnM71YQD2hAVEOdcbfY=;
 b=zCPVtvT1JVCnVrYFeh/+pd6ajgFPbT2YPq5Bs4+D7jjPBrPTymJ/qynSA4epcMQwSPjRzrj/oebaIbsos9nzofJh0NuBIMIuBNqh5f4OBKLVWyIrPAKomvhaHmU02Ucbz6eiZPaxlmp+kOktw7xdrbGR6mzGXIjlYANnCJY3wWoa7nssiB/UzqcYlb+PJ7Ae3lYuGn8kKDL8GTuxFMP0X5/JajJHrfv1EafGLdUVRA5moJEHB/d8IIVkOreYzc4SlSJSYEzEyr5ruYnTxYO/Cwj1op753psbTBr/MW96nqANtd2uzFS6b9acGiJv3a3YYAJZ8ezdMXNyu6j3+52wZg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHmVQebsm4rI7kRZVIei2hsBcnM71YQD2hAVEOdcbfY=;
 b=M7Gl84SeGQKWS4t1LwkW+wjRutw5ENuDSg+0/F2p2Zoh51GXAkkKfDhd2C3fNPc+Jkc3HCxw+520YjVM9/WXpDJVUpjoccYgAWCzc3BqFRLiJBd05u6ydhqd1kkIfxF9QKTHL5MFuU2GMS4mM79yl3MIQb6U9WIgNfXimuG38RI=
Received: from DUZPR01CA0029.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::18) by VI0PR08MB10760.eurprd08.prod.outlook.com
 (2603:10a6:800:20d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 09:14:13 +0000
Received: from DB1PEPF000509E6.eurprd03.prod.outlook.com
 (2603:10a6:10:46b:cafe::92) by DUZPR01CA0029.outlook.office365.com
 (2603:10a6:10:46b::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.15 via Frontend Transport; Wed,
 6 May 2026 09:14:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E6.mail.protection.outlook.com (10.167.242.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.22
 via Frontend Transport; Wed, 6 May 2026 09:14:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ROhaIFV6jD/Pvg0R5GrPy2DZRSPRfsoD6ZzDkBuj/NFq53ppKJ5lfnROCMyzhawxFALRl7rJYb5XWQJoYJF6kAfDo+FpIXst7yOdciZQliSp/bG9vD4OH0K3P69wHuqBYnTeRFsVEeBaID6+Gf7VFoUPEsbQaoRwyPP42jo1gUc01VCeMZGZPU6tb0u/RipGV5Wb7IvXwXkbERY0B2SV9FXaktMOE9oizVSPbmXQOJEMXo0uleIj4XBSRCiU+zR1nmG5zMHEiK23J/EQe11gtXyhjUhJNhECIdKNvTgmyiyisPx285Ifq4gn1itKNcYNhhK1AxOe0UjcQYH3THZ4Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHmVQebsm4rI7kRZVIei2hsBcnM71YQD2hAVEOdcbfY=;
 b=UFOn3tuvaWm4IIfM+QuLra8twXu6in2gpouE5vDhHY8S+vSy9apDUBQwPYB94ywMDWnSFUzlsHVg/yf1bKGF7UXN2Z4JKShohMyuOgmxllKsC88oonV6i4nNsu6Ed2lpuQ/qmPweCR9hr/cWXQcTzG7b83NvBTtIsH6RQzLFs8iUO3JdO7SNwj0g74E1H4m8fPixmPCQ5YPizjAfsCLNHXJQ7ZrA6FXbDI02JJcJdqt/XPjTHyxfiJj17w3pwVKV76gAPo5XTpKROT6RUXUPbLMHDFYG2+libQ0H+iLrwf7nvrIWwOeMYb7rlIeeKxoXGblKmdFuVGC2M/wLUMYBaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHmVQebsm4rI7kRZVIei2hsBcnM71YQD2hAVEOdcbfY=;
 b=M7Gl84SeGQKWS4t1LwkW+wjRutw5ENuDSg+0/F2p2Zoh51GXAkkKfDhd2C3fNPc+Jkc3HCxw+520YjVM9/WXpDJVUpjoccYgAWCzc3BqFRLiJBd05u6ydhqd1kkIfxF9QKTHL5MFuU2GMS4mM79yl3MIQb6U9WIgNfXimuG38RI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AS2PR08MB10227.eurprd08.prod.outlook.com (2603:10a6:20b:647::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 09:13:08 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 09:13:08 +0000
Message-ID: <8e3f3a91-7683-42bc-882d-6769d7e2dd5b@arm.com>
Date: Wed, 6 May 2026 14:42:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 22/54] selftests/mm: rename thp_settings.[ch] to
 hugepage_settings.[ch]
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
 <20260428204240.1924129-23-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-23-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0059.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d3::10) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AS2PR08MB10227:EE_|DB1PEPF000509E6:EE_|VI0PR08MB10760:EE_
X-MS-Office365-Filtering-Correlation-Id: a9f4bc78-9129-4d7e-a1b4-08deab4fd6de
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 AErFtIGilYz951fF6qlZe4MMX2/PY1BvVWEod+mrz61f3L1j1WJO3SU16Zg4i1fWqyy7jSPDTxsSE2Mxzbp3O1eMbXTsMYNx9qL+kkQFAHjXv/zzvZUGuArNuzJ7l0HtCYZypUK7b4PlIyl56CGKmMJnMZy7H9cAmNznWsUkuO8FIxkvWXX4L85LidNayhk5W85zaK3e4MzSC9/c+iZyUhKarg2OCw2JSLNQUvrmj0o0QOv4tJw0GHrPskQ8FGz+oMsNhV+tadcrrBPqxT8/UTpcXfARmxhZAGcGpvJHAIdLsxVtJ6JEboIJs3WBtjaH6mGFwZgBD0sjfbhwlZxP1l8fCG02R5D+i5bLrLLNh/nF9RKoSicaPQtwhjRhu4p/tgFx68NwLJOu31V0vvzBh9aJxyRnv4Vdb4n8VP3UcMWIyLTev8KsqsnADWilIM9Kwqj4Hu1j6Z5eIpuTuxX45+R54h8rgBWYPqS6BGmFjg2A7tSMhiOjLQsdxm7zdGfd8rxkWCZDCiYvImgyV5asaP3h+kFsMRol3/8iuPVDfdkISjHuyZnrCh6Ay+EFzluF+YoAPSmMrcksK59f59Wj7GyR4BMvnXfRHEgILKk0z81yBoQpqsjLOske6aAwHEcZ6wPuH5oNLuAzcNnRQmgsm1KPEUl5LZMqhD9QbfNbboBdepqnuHx0+f4qys/d7R7K
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 LFUH4gclBNopNvGutSOEkhzklvYsDg10JRWEh6E7jKYzurI7YSJI7t/v/ce69r8aPvOMOMwgR0rJHiSWTTu4jtUAwwLcEIIA6ON6Uuz5TbZVDXATTa/hHj1XKuO0i4joKjfj86w/gONMM5+MoJAf4EQYkbRPm8hPSIsDod8HBYaY27SwGv4323LkJiaNon7mYRN9gSOmUcmpjFFfJOWTmTfAd/iZ+i15MdYV3Xkk3CAZdGOnZAb4cmCRr7YEmp0njPMu6U8Tt4h+fh5AHp/zbAEwc6ZMloNWAEMTBbQrVS+p9tA7Vv0K4i9hCvpu5P1x3GrZosEONaH5flW03ZPVJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10227
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E6.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9bfa2587-1798-408c-162a-08deab4fb03a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|35042699022|82310400026|14060799003|1800799024|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MceZQMNPoZ7ic74rkU3t9IGUs1YVHBR78JI2xznFOWXG3/+uU4tMIGN+R+KNK6kyXPOyhaaZEIcLRTO04kKCRskm5zAoiO/KRAH7fOL39D9mNx0hatWYWQuaF6DJmq3SPGjOvquXknHmLQXmKMQg1knLpk+3DF62mE2PXzQL6S70Aekkj2whL5RSTmc8zxaWUl20+c63axhxHQxexuPBVCmCef8UK/WsV/IDOD/pnRAi9gKNW+FfVwPjAse8ASBj76qzGI1mVbFyTiwbWfx3PTgIGowg7IOEl30TwNJ+GVJVAJa7exLPjiZXVx/B2Xu+vBADWRbrieg31BedPw+6Uc42qApVtG7Hrm5aEwSPq3kS+zUcRYiL2RRlL9vtEi491+djXT/0ZzanjMETQsS7krBMeZk8D9O2ivlohHjd1u7BADHeKC+pFIUSR7EiFYjibjwUvHCIQSPcjsW6mhKzWyG85bHVTUFfWMznEAOflTdjlNri3aUdSrNq8fBsEdOKOVu+3+OX7poqXT1fA4Yx1iW4ma7/RTgclmWNiPZR01l1l+bjP9iGkdlzkR4NkKcv4lsvM2PsR/gkpikLTv39eCyypHCcMcE69+SkZvdGmr7G5LIw5nsVY7DF1GMLH0rOSp9G7vURCTBIounOSY1Dq0H3ApBa+djRgcICYriWLUiodccc4fwRTkFM43nRcpoerUJr0LPf1DMjrF6+2Uvt9qOW7bILGRH9JdLJmfQ7ZSk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(35042699022)(82310400026)(14060799003)(1800799024)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sIdPzEL+GY3EDzzZygNEMFF/B4fuA83WVg86c/esUQrJe8B5HjKpxSPD948zi5Yyhe3nL4Q/te7u5ChCS6GA1nquWJm8djC6Wq3UVykkDAgmdmKEKXBC/v3bVLSam1oubjRRePqOZS3N83+mPQuvmiMUbnlumdeKoRdlyM8viLZfVRjclppt+grRajr1edwVxKzDWOC2AOSjsGI6jlKFQEKQKKngVoGXk4VejWFfiZUtJCBxBl4FRlvQPvkwrF9otX7ZVBVoakGTUrjnGz0RagT18iayWi8THHJRH4UNLYtdAJZ0hvvgSfYxVB4W9dg/KaC+i21IZg/5/4X1xFkCaJDx2t/+Xhx8aHJv3n06xxxkqCKlpQY8dmnGOUYbq0c9gea2GDUP/xGtx7phe3MIC2b1xunGklNYIa23RLgH3dgR+w8A8zZaRqf8kjKVMC+7
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 09:14:12.7662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f4bc78-9129-4d7e-a1b4-08deab4fd6de
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E6.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10760
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BB80B8000B
X-Stat-Signature: xmhwce5ruc18j3dk3qcg8zby755w94q7
X-Rspam-User: 
X-HE-Tag: 1778058864-308975
X-HE-Meta: U2FsdGVkX18e6SZLmN9FpH3e3eCdJvMaIVXIw9qCHuwkr7P+6oUvxJl+3PEOXT0vY926gZcx5wwLRQ8gegDAuzGnUpH7DuZo3Vv+0wvpsLw1ifdvkubVG229sDe65JwUk4eRaOfxbZiGjdx07W3s4YPrQMj1I16IkNx7hkdhdwAURwKKjwsGIbLtOackpcnbLi+pJSwd4xdl+A0FIWUN9cwToo6QpVJiPZ4vyRT47kFoIPec+imsdk7I5/jcgX/1r/AOLi+B61MnGnKbOq/Igsge/8fvztefgDgIkvWh6n5e2No/DsZIVcHUSFEIJmfhS4hFEkVeQfn2dsRcyCPL/9Y3wRErJVjPursnoEOD2bvi2To5Sj3TOetcZhcgjZWzQCArDrYp804mzNhgMy+0jRpC1JYntEGa7VNWgNNwSmvop1jF73d9EI+T/Ie0wfsXtPl+Z4KVQ+YwOrBNjm+oLmk+JxK+atd+Kvxv7mP9KzNDw/x+yc0k2KSgjbMnAUfprTVKXgiZL2OcFqP/kFECoGKCCYpEXnQO+9mvP/bHvQ9DR5b7sQ0VoO3lUu5dn41/EY7fobfYTJH0rNCkXdqamTvIq7g2pS7uq3JaZBOvoMotBVnB9RNRQmj4Vw+le+/B85sOSFH8i1NwW/9Ercasd6t5ARuntrOK6mTCrTaLF7p/P9j1ptZSIsaYMpjZt9J7F3ajBcHuIJtmc8/IaimutzDqBdWPeO5Ex3HRlN2RosLW+nb4cWdRtxDsHOu9WRPYAGzzLIUDDFxQBMuXTdmi5c/xZ+kKSbD0aObfJwK6C6upFHP4exRmZi7rlHs7UBp2w8UjFdufKOWA0rKLGxzTAplGSmKfTMgUPjqR0tyGHroRAu1t/Tr+TyIbIkFbyN/6Iw1Ys5FCS9vvfxeCMM+7TyjH8n+A+0VOHiQkVknBqThhx55b4uncvjw8onoqzvWM4Hq5DWY6syMfAykKR2P
 4ICNioQr
 +IMwMiWh/0WHnBCOCzL05gB9Zwpv601hl9y4ctmEG5Hu/MD8Pt6FeN5/oLLMaplQve9+Bi26LxhPC571L179vAsg6RYIFus/jJjwKdER87pcHq1s24f11zBMqblbSfCuyvkjno20chTfxTbM2atgKh8HD8cQgAZDMAQt9oRJnO2hprIhNqSvMWFWXAl8LHKrPsN+aig6bgcZhJEu5uZxgabUfQPAos4BOBd/bPllmuu7PoD6fBageZYkfEredVNUl5jCRAoVJ1PZMGxcWa8AnrmRkTqAatqxcRBTTfAuKdNYrd0i6YhqSeKukCQ6xS/lnINn749oeHieebMEC2rF1Jh5ZMoCHmXQW2JHpBtZQpSvtUkKBvFVMEGOGrr3S5h/y309/EDeJPjQ9alKsphCvxK3gDO9MN6oQp6NoRJCFdhqdHle9YS3JdvGEpnIxY7myJgl+zojPO/6iEYKLZV8ACyUJ9sej13GhTn12pYbv+2fsCLs6b4mTexR8t53lYusGXV+mtERrnF2Ssm2pzWw4Kzd9Nit4sC7cQE6Emo7Uq/Kp03FFp2vyIhMj7McyUGleQavS+EVZJwND9MwegMjlI9r696opVEjZOwYnAJrIWom60FE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> ... for upcoming addition of HugeTLB helpers.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/Makefile                           | 4 ++--
>  tools/testing/selftests/mm/cow.c                              | 2 +-
>  tools/testing/selftests/mm/folio_split_race_test.c            | 2 +-
>  tools/testing/selftests/mm/guard-regions.c                    | 2 +-
>  .../selftests/mm/{thp_settings.c => hugepage_settings.c}      | 2 +-
>  .../selftests/mm/{thp_settings.h => hugepage_settings.h}      | 0
>  tools/testing/selftests/mm/khugepaged.c                       | 2 +-
>  tools/testing/selftests/mm/ksm_tests.c                        | 2 +-
>  tools/testing/selftests/mm/migration.c                        | 2 +-
>  tools/testing/selftests/mm/prctl_thp_disable.c                | 2 +-
>  tools/testing/selftests/mm/soft-dirty.c                       | 2 +-
>  tools/testing/selftests/mm/split_huge_page_test.c             | 2 +-
>  tools/testing/selftests/mm/transhuge-stress.c                 | 2 +-
>  tools/testing/selftests/mm/uffd-wp-mremap.c                   | 2 +-
>  14 files changed, 14 insertions(+), 14 deletions(-)
>  rename tools/testing/selftests/mm/{thp_settings.c => hugepage_settings.c} (99%)
>  rename tools/testing/selftests/mm/{thp_settings.h => hugepage_settings.h} (100%)
> 
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index a6955660a806..a1d103b38485 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -186,8 +186,8 @@ TEST_FILES += write_hugetlb_memory.sh
>  
>  include ../lib.mk
>  
> -$(TEST_GEN_PROGS): vm_util.c thp_settings.c
> -$(TEST_GEN_FILES): vm_util.c thp_settings.c
> +$(TEST_GEN_PROGS): vm_util.c hugepage_settings.c
> +$(TEST_GEN_FILES): vm_util.c hugepage_settings.c
>  
>  $(OUTPUT)/uffd-stress: uffd-common.c
>  $(OUTPUT)/uffd-unit-tests: uffd-common.c
> diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
> index 6abdcb30aba8..4321f4208fe3 100644
> --- a/tools/testing/selftests/mm/cow.c
> +++ b/tools/testing/selftests/mm/cow.c
> @@ -29,7 +29,7 @@
>  #include "../../../../mm/gup_test.h"
>  #include "kselftest.h"
>  #include "vm_util.h"
> -#include "thp_settings.h"
> +#include "hugepage_settings.h"
>  
>  static size_t pagesize;
>  static int pagemap_fd;
> diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
> index ff026f183ac7..7ede4793c778 100644
> --- a/tools/testing/selftests/mm/folio_split_race_test.c
> +++ b/tools/testing/selftests/mm/folio_split_race_test.c
> @@ -25,7 +25,7 @@
>  #include <unistd.h>
>  #include "vm_util.h"
>  #include "kselftest.h"
> -#include "thp_settings.h"
> +#include "hugepage_settings.h"
>  
>  uint64_t page_size;
>  uint64_t pmd_pagesize;
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index 48e8b1539be3..feb50b415f52 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -21,7 +21,7 @@
>  #include <sys/uio.h>
>  #include <unistd.h>
>  #include "vm_util.h"
> -#include "thp_settings.h"
> +#include "hugepage_settings.h"
>  
>  #include "../pidfd/pidfd.h"
>  
> diff --git a/tools/testing/selftests/mm/thp_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> similarity index 99%
> rename from tools/testing/selftests/mm/thp_settings.c
> rename to tools/testing/selftests/mm/hugepage_settings.c
> index f38ba8a27b30..87ecb309b430 100644
> --- a/tools/testing/selftests/mm/thp_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -8,7 +8,7 @@
>  #include <unistd.h>
>  
>  #include "vm_util.h"
> -#include "thp_settings.h"
> +#include "hugepage_settings.h"
>  
>  #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
>  #define MAX_SETTINGS_DEPTH 4
> diff --git a/tools/testing/selftests/mm/thp_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
> similarity index 100%
> rename from tools/testing/selftests/mm/thp_settings.h
> rename to tools/testing/selftests/mm/hugepage_settings.h
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index ef3b6464ff3f..7563d7600ce7 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -22,7 +22,7 @@
>  #include "linux/magic.h"
>  
>  #include "vm_util.h"
> -#include "thp_settings.h"
> +#include "hugepage_settings.h"
>  
>  #define BASE_ADDR ((void *)(1UL << 30))
>  static unsigned long hpage_pmd_size;
> diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
> index 752a2c0d06ab..fb355f869401 100644
> --- a/tools/testing/selftests/mm/ksm_tests.c
> +++ b/tools/testing/selftests/mm/ksm_tests.c
> @@ -15,7 +15,7 @@
>  #include "kselftest.h"
>  #include <include/vdso/time64.h>
>  #include "vm_util.h"
> -#include "thp_settings.h"
> +#include "hugepage_settings.h"
>  
>  #define KSM_SYSFS_PATH "/sys/kernel/mm/ksm/"
>  #define KSM_FP(s) (KSM_SYSFS_PATH s)
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index 76e380b74658..0212cd5bde6e 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -5,7 +5,7 @@
>   */
>  
>  #include "kselftest_harness.h"
> -#include "thp_settings.h"
> +#include "hugepage_settings.h"
>  
>  #include <strings.h>
>  #include <pthread.h>
> diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
> index ca27200596a4..d8d9d1de57b8 100644
> --- a/tools/testing/selftests/mm/prctl_thp_disable.c
> +++ b/tools/testing/selftests/mm/prctl_thp_disable.c
> @@ -14,7 +14,7 @@
>  #include <sys/wait.h>
>  
>  #include "kselftest_harness.h"
> -#include "thp_settings.h"
> +#include "hugepage_settings.h"
>  #include "vm_util.h"
>  
>  #ifndef PR_THP_DISABLE_EXCEPT_ADVISED
> diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
> index bcfcac99b436..c426c4636ef5 100644
> --- a/tools/testing/selftests/mm/soft-dirty.c
> +++ b/tools/testing/selftests/mm/soft-dirty.c
> @@ -9,7 +9,7 @@
>  
>  #include "kselftest.h"
>  #include "vm_util.h"
> -#include "thp_settings.h"
> +#include "hugepage_settings.h"
>  
>  #define PAGEMAP_FILE_PATH "/proc/self/pagemap"
>  #define TEST_ITERATIONS 10000
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 500d07c4938b..cc99294bdd5a 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -21,7 +21,7 @@
>  #include <time.h>
>  #include "vm_util.h"
>  #include "kselftest.h"
> -#include "thp_settings.h"
> +#include "hugepage_settings.h"
>  
>  uint64_t pagesize;
>  unsigned int pageshift;
> diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
> index 7a9f1035099b..8eb0c5630e7e 100644
> --- a/tools/testing/selftests/mm/transhuge-stress.c
> +++ b/tools/testing/selftests/mm/transhuge-stress.c
> @@ -17,7 +17,7 @@
>  #include <sys/mman.h>
>  #include "vm_util.h"
>  #include "kselftest.h"
> -#include "thp_settings.h"
> +#include "hugepage_settings.h"
>  
>  int backing_fd = -1;
>  int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
> diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
> index 516c35d236e1..9d67b11c2f28 100644
> --- a/tools/testing/selftests/mm/uffd-wp-mremap.c
> +++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
> @@ -8,7 +8,7 @@
>  #include <linux/mman.h>
>  #include <sys/mman.h>
>  #include "kselftest.h"
> -#include "thp_settings.h"
> +#include "hugepage_settings.h"
>  #include "uffd-common.h"
>  
>  static int pagemap_fd;


