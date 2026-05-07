Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A281CCD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 11:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E020E6B0088; Thu,  7 May 2026 07:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3556B008A; Thu,  7 May 2026 07:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B796B008C; Thu,  7 May 2026 07:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7D556B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:37:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 451D4C1D12
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:37:43 +0000 (UTC)
X-FDA: 84740424006.03.30A7810
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013015.outbound.protection.outlook.com [52.101.72.15])
	by imf03.hostedemail.com (Postfix) with ESMTP id E79302000F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:37:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WkjbIrUU;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WkjbIrUU;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf03.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.15 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778153859; a=rsa-sha256;
	cv=pass;
	b=5YbtheeDuq58F/rkML8z32sQMpmxQ8OpV3S30gNsyHgtbQZMJfJeSy1lIdylxCy/yfVwV2
	AkDRsEG/6SY17380Yw0gexoIyz5SvZ8R+OQY6v6eNF4pxSF51/w+xSHxV3MV/ulOUYa7o1
	v192u8xgc/eOHANzkVtSqXEvQsNDEQ8=
ARC-Authentication-Results: i=3;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WkjbIrUU;
	dkim=pass header.d=arm.com header.s=selector1 header.b=WkjbIrUU;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf03.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.15 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778153859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFP6YvhJthxpM/F+a2J5V1I3u56BkTQCM3M6vPjW41g=;
	b=Zz6Pr45dTtj1sMgYv0C201fcR+trwpbpBF1Qy6vY2pBKzTi2v5B0bj5hCq+9urj3xoJKVt
	rsxeUnoqZwvgQdwTDIfJtMzqyoPy77TLzggNYy+j5hk1yv6mE+ITtZhvXA0/27Dr5FB0Qu
	b8+7rQ1Vdf844rybCdmznZOctDtCN7s=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UqVuupH62YHKLK57RTgS6sqM4tIUUwVBIhfRwSX9XQK+JuO2RZzISBMD2IiW22y5hNjbBZf/c6vb0E1joNZv0taf5x1hcndgBj4t5Ls48i8AgHFXTMtiQb8qoyqWfNxMN0zaZitwwKeB1L/WxP7z+9vxG4cdY+XsdMcFriu2aN3UOSA9M0uo+I3FyuV7J2obYhZadYGfPOgHZCZQJ7mE5JI/SbCHu2VEv4o/34GknjGZAP6I4vJN52+mMxFdNCPFDj10QLyPtCg3DJEPX7AJ/Kq2abr3bIZOVvYzElDMwpD3O4/HPmLOA0W50SCFuNr2neH35B/Nxr2wELgztzoXbw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFP6YvhJthxpM/F+a2J5V1I3u56BkTQCM3M6vPjW41g=;
 b=IyuLeWcQ1d70xu9fi/GeWhmfyt456nKWpTjL48+BTyTzliiIgVTGdoJNqsxpclobLTAPbrRUzuqA7I0U454QQgL9+W6dLlg17jKt2vpcmt0BMKu3Mt3IRnt8NYstV70SJtZ5gBipCC2XpPMMQP7bAvQq5R1F/SS+/37+ADEsPMzMR8/VFCm1S1sGLDntt0YEU397RPBj3Fj0LXGnHdIpOIC+aYQFjGx2dp10Gun7kM54UOAxf2ou+D7ILmM1ADEI7GDRMNPdgL76+WN2i4v2O4X2+g60dHCEOuSCQsjFD3cUEoHwBxYZF6eqv19n6KWWCaEnZocrSbC59zNiIf3Q3A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFP6YvhJthxpM/F+a2J5V1I3u56BkTQCM3M6vPjW41g=;
 b=WkjbIrUUbvKV9f/5BwLS0p5dEfgFu/LmjsYVH71dEAmr+odCwLB5fApJ/Qq5H5Ik6e2yVPXbLmzXV5OEzLbgSBwaMVYVD9zKq3ujfP2L/lH9fRONURoJOGRgBt4rq1qzV0so/r1ghKlf8YMMPP8KFfcEAex5z2CKrAODsv5K9AQ=
Received: from CW1P123CA0010.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:293::12)
 by AS8PR08MB8900.eurprd08.prod.outlook.com (2603:10a6:20b:5b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 11:37:31 +0000
Received: from AM1PEPF000252DE.eurprd07.prod.outlook.com
 (2603:10a6:400:293:cafe::b8) by CW1P123CA0010.outlook.office365.com
 (2603:10a6:400:293::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.17 via Frontend Transport; Thu,
 7 May 2026 11:37:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DE.mail.protection.outlook.com (10.167.16.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Thu, 7 May 2026 11:37:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xLtb1LrzG0KQaGCRlCIi4jq5qbUAaq0k2PMdR7eQ7O8+j/eGkPQd5nYtGvl7MnQ3p63HVnRnfBE/RlX5Hg6dgVVqHlXm7aeKY61eEhTOJk1OokxuVJw2nX1VQAw+A+hplQ0kNh23+ZD+DGZZtZfHmnjl3WCZuqccUS7lwlwZ8BGq/M4qfNm8lJ7PYKidHXhF9dW9KSuz4TVoPiuiMQ7wK2Or0QJzm5kCscBxTMUvizSXk43gW1PWiS4uvaaM5KNxVlWfBmnjADDbY85WQvr/Ue5p0VIfKr5lBZtTLtUJjXmHJLg6ls+l+xf38/p15ROj/5Mxu9zYEe0pZef4bF/NYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFP6YvhJthxpM/F+a2J5V1I3u56BkTQCM3M6vPjW41g=;
 b=AEWO4xEitTlMhPcxwHPmXu/6IL0XmA0yJnxeCjcs3e1tAVzTNU89Q25Q3+yE/8EC8/NIJXWtGwoFQPAHCw64fnZBaI8JU3IyHyfsXydJwamKYLESxft4T0kBEe54tnwc6Cj616DiiqWE5APdOPKWgPWXnIW2/TqPFArhA+NGy5i4spOLT3L7i1ySgpEdLvvSdDteNl5nkmnY6tnbXA2PgB7dQwNt138SYlgK3kZZAMMfjbrpfwpz9/GbUeApOSMC6iWEatE0aMHNGWt/bAqLEGBaXaxpDDnqN+OYwodpBVYuK4kjCx29x2PXc7rW6ahmAwtzvWjI+7nB1Kqgm8qgSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFP6YvhJthxpM/F+a2J5V1I3u56BkTQCM3M6vPjW41g=;
 b=WkjbIrUUbvKV9f/5BwLS0p5dEfgFu/LmjsYVH71dEAmr+odCwLB5fApJ/Qq5H5Ik6e2yVPXbLmzXV5OEzLbgSBwaMVYVD9zKq3ujfP2L/lH9fRONURoJOGRgBt4rq1qzV0so/r1ghKlf8YMMPP8KFfcEAex5z2CKrAODsv5K9AQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AS8PR08MB8657.eurprd08.prod.outlook.com (2603:10a6:20b:565::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 11:36:27 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 11:36:27 +0000
Message-ID: <5102f1d4-e098-4a88-b4e0-ef693540e5ec@arm.com>
Date: Thu, 7 May 2026 17:06:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 44/54] selftests/mm: migration: add setup of HugeTLB
 pages
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
 <20260428204240.1924129-45-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-45-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0227.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1f3::14) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AS8PR08MB8657:EE_|AM1PEPF000252DE:EE_|AS8PR08MB8900:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f628d81-be32-4a72-3f64-08deac2d060b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 W0ODK2NC/YxbGxu0ZgcQWP1Z8X/8nfu9cnrelgf1BFyTrkjVSs4RK4rgyGSuCljlyQoIBOvjMf/Bx9BH1ddsbAEn40tOzk0sD2st8PdGoPO6s5gbjedSsOBLssFRrORpGCYENYHAiQqD6AzA1wFEAJBv1ddNwl0CxwoaP5g8P7SD4V9hFzfLze771ePCwFC1wvxHuttfwDd4WOnOJGPMmuDJMVdifNPzTzInh5aWtG7uSkWrfAhTrcxcrs88F+yyw7wngZeuwxDozRTf4g9bgupjPAqiqVubiNMed1QT1NWZDD89hCsYhUHMGi+XaoC2jtiDkBndQ+L/en3BjyHeRNoON4bn7Z6e7nyJ0ZUKq7Z58FJSsbYqlgxVYrRQlOxB+wARaJvx6eMH1ogvjuSY98j1pVshvPwQORErGoxXidAYRD+ptnoMt3q8y8uSCw1dvhzvDXFITfqg+/6rzqjY2QqD5vavwVPxsSaOr1FwtzD24LOk/O5Slswq6vUNy1dNeyu9TyuXU/QC2SdT9yA8jlWCrBNP1UFMJLoMYKYgLLXNNYesNilHc5q7i/reIDlWpFIF38vn95+n77wLUsbUdxQa1/NCLvs0dj0t3EgBPWi7z093aEbFQyBpXJMdNar3Tx7Vd67eygg1wY4vbum04s838JBpu1p0UggVUxYhhNcxhdsYNz4NhD+bCP056/fH
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 JrXtb+TZP8RXKd2eLTswViTvqNd6Ua6FAruVz+EwePnA1UYZUq+DfEqe/Nd/a2FcF/eEQ++L1IKaxpjEV3Ja5kT4Qefm+vg5+DvK77lfS4tswHEJmtyYZCYGl8d+6Pp0/CJNRSMAH1X5FS5CjeZm9wrnBInvgAdrJ3h0clvEJ4SyFGWehsyo2y1m2XPJg7FoeNnALQQh4IZ7HIf45fkmignNx3MU6sH7GtwsUmBvBrzD6Pv6DgrBCOoOwWIm6/DuArumJpMFclL3pKRwzqiCyqQds6BfBrqBW3lzADIywAWPJkdyxAMA1T1jW6yooPxhwqAiRzqylmYm/5WFCnV7xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8657
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	580e0434-9aec-4fbd-80d6-08deac2ce001
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|14060799003|7416014|82310400026|35042699022|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	vMDlb7A4SaU6C2AZtNfesP0fKJUkXGVjyIlx7BsmJQZ7YuGKZfaxRzcKPTsFeEucrjk4t780zxTjIJTc50z4hDbIcg/7oU6yfAoN3haNalAw832kleGtOJjFV5Do/AmD5tcHLruvBwbg8v1z2lVW1IAUh01+4iOnOyFUX0/1O+fl5aaf068iHF1jAEiY22lp+OjAGU7EYu5L0g4q+LfRrxn9XNKSWk+cw8dOgLLTfmx0NDhlD80/B2x/EohejHxEFWgKskWrf1wAlVlzHCzs3E4vG8yC+a3PPXxxXxQwrx2Ngf7qRRBHwdBLAFsFE+w6D9soSTRW99rfWpon6r9OVK2URS81jyHRv8tzQgNLafAKh4UN5esObHCdS0pG/rRItJnja/0IqlHl719h80VmVO2M8QIi2BOVp5uUfrK6tCZpGD5CXVjbHniZEccp/brPIJqnPc8BDEdoNr50T9pkDsDd9ATsjfBA1r/DYikKTfOZGEa9RBMwD0QbaW/RRh64v2vnlsCUVaXPa7WJQxT2kYuZO2X4dm0PjASxTz51d6bRPrOeaLWmQyMbVUWwpD4Alqn6KwcGyS56DJInzB4eG4Tz69Ar7nVpJt3GD/On3A6/RWDa2aVh5gkg++d/IDZgQIMwxKgOQNYq3d76/fppDZyoCApqvkVqg3+UDi25g8853yBZB0/gMuulF1PVQktYD8mQtZATOMTEVZ/M8zr245Zp/zIon+3sbfas2ZSnykE=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(14060799003)(7416014)(82310400026)(35042699022)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jJeAiOivULidkW80WKEGVuMqRENf0e7u2iVFFDv73s+uaXj1pjrZLZmRq4RX4lY7iKHQd1nHp2SJL9NnACJOfaZFnN+WRF2r4WzPdSeOIICcnT7zClpCcZGbxCu2038MTUscGUx0k023DYA28INhw1AgY2O1lEdMHfFYd7Nk2goBR/57AhbzmXLG77sdKRI2T9smACH8uxDNQXmsRLTZe2CYFTfGzy8EVnr7wnfXpYll+2sz3WaKXUUB8Ls16ESS/EEFXBlF4p3bno8HpuXkAYwloLhFW3vrFOcjSym0pJVtx5lJpKjay7tC+mZ/LopIOLpohp7F3sud/488We8hKeky77K1cXrc09+m8m2xcT4l7xfJSFeaVdzr4ukYmTZf71MQBEGuWF762k9pshqt+niByVXhQ9s2MarR6BLrlEtKKbc7zrJwNgsIDqrDA44I
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 11:37:30.7209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f628d81-be32-4a72-3f64-08deac2d060b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DE.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8900
X-Stat-Signature: prnzakesq3u81q8sp9piymbrcq9q8wfb
X-Rspam-User: 
X-Rspamd-Queue-Id: E79302000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1778153858-518167
X-HE-Meta: U2FsdGVkX19hBONJeuRl3h5z6joE4bPLXD4tyiossgKqxLSfo6GGU1sB0B5+H+pUciF+siMekDm2uEDCkvyYNNiCXvtSrgjijyQPWG3FSHZY7Y4uc3WdWQQaLoSzKFl1EbRGPOgorvjAKWIuK9scThL1xZB+4bp+yGNePd8uByS5oCbkkG7edu2b+h4UnZoInPCach0wXiZXlvV6ITQXyY9s1i8WB10z0X0Lr2uF2skHXfCr1FHXaV02oAe2W7IApcJjFeroCckGSV403fDA3HsfYqGxqLm8kO1EAiIuLdYgg0UBGKTTxaLu3JWKaHajvrXii7/fXdLwf/yWOPLNC8ERnBfLE1UtgwdwrjWLkBiinzgRTmDKcSolwOYeYFkeha+Jfb4/YuyYeY803u81TOnzXwn6yT093XHDUB5hmQi6endTtH/RAeM07f6pBe4GFtU0Z8mVHujNEuWmcy/dWF4EoQ1EQgpbytYzbeHRjxTK8Jc69322N2oqCxO4q0UR/4DKfskg+WKBFR7bn5VMPOsAyop+0g2ZtZgYLkdtQBfPgzf2WQldvXhmoDQ05dmhFLTBFT/KgQVuy2z1Gw9BQqsOw52WyE5p7lHEk2aPIuiaO2e9Mo1ESco2UIxTuyWLrrLVK2P5xqSatxFk0SrcnmreUxttJgKxcpxLLjvJxoQCw7st3xxvRjYx2Jfxkp3nPSgei+6spKFQEqSayJCQM5lS6/lAveeVPaqCdudGmMosJq+5f9JqoLUL+d8go/pOQS866YbG7a5jMOQisegrq/tHNwlKtc6SX2zKs015HAnheQmGZh4wYDOMbGIduQp6G8OTC28NxnrerfzB8lrsIJoQZVcBmUwsKwHWvTOxEM5Yf4FyEfpMO2hxIlajDJghjQXvxY30t24gu6thMNqtJJuXuPZZyCX57jv9RaKDAVkNjtY2wVUYWq9RDK70PcJzrZk5ASCbVDxoDiHJOtv
 dWfDV4cg
 /c9wCQjwkGemWnWm9IS4oZ+OniWrnv/6c8Dw+vgxtR5EBPPfnCLv59g1skAdKMTk6QYJNOa2FlnrsyvnkbPLHVbEIRmPA49NadOepS4xZyDX2penR7XsjMayuJZ/CPpkaWPEJKFTr8X6mXHThW4eJWavZj73BSlGxyiTlI8g5jy+LFZW0Cf7kBmBIVJhs6v5z2PaEzjzC/koz82TcsJbc2Oezq1Bhty9gQk27p/q96LPNU292DSu5euyraFvmEaUOxeisCZTDQGKZmY0Gnd2seQVZkEcJPW6pxRmWPlpFn57QQipRduNkexz84EaEsbw7PCN8MCpmvSnhGeLBLf7ZiX1tMTCS1G9v/hp1xGbICm649UlBm3svwzdfWxP2xiXQ5/mg3AhlU4LXgD8X06u3vy9i/pWYM8kLom8f6GBFShvuZmMtMdSs+NeBO3sglh5KZFpMg99WP8cmTKAjOEBqboNAFbMy3orBDdioMVRw7My5y6OAVTUNSc4rjWxhnMkQiB0H6NClyol85hhD5zXZfK8u/2bjDYuflriEtb2gdVwDGXUib9ZYc1+wjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> migration skips HugeTLB tests if there are no free huge pages
> prepared by a wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Since kselftest_harness runs fixture setup and the tests in child
> processes, use HUGETLB_SETUP_DEFAULT_PAGES() that defines a constructor
> that runs in the main process and add verification that there are enough
> free huge pages to the tests that use them.
> 
> Reset signal handlers to defaults in FIXTURE_SETUP() so that sending
> SIGTERM and SIGHUP during the tests won't cause restoration of HugeTLB
> settings.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I have run the test before and after applying the patch. Before the
patch, the hugetlb subtests failed with MAP_FAILED because hugepages
were not preallocated. After the patch, those subtests correctly
allocate the required hugepages and pass successfully, restoring the
original settings at exit.

Tested-by: Sarthak Sharma sarthak.sharma@arm.com

> ---
>  tools/testing/selftests/mm/migration.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index 0212cd5bde6e..f212c1b06455 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -23,6 +23,8 @@
>  #define MAX_RETRIES	100
>  #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
>  
> +HUGETLB_SETUP_DEFAULT_PAGES(1)
> +
>  FIXTURE(migration)
>  {
>  	pthread_t *threads;
> @@ -32,10 +34,21 @@ FIXTURE(migration)
>  	int n2;
>  };
>  
> +static void reset_signals(void)
> +{
> +	struct sigaction sa = { .sa_handler = SIG_DFL };
> +
> +	sigemptyset(&sa.sa_mask);
> +	sigaction(SIGTERM, &sa, NULL);
> +	sigaction(SIGHUP, &sa, NULL);
> +}
> +
>  FIXTURE_SETUP(migration)
>  {
>  	int n;
>  
> +	reset_signals();
> +
>  	if (numa_available() < 0)
>  		SKIP(return, "NUMA not available");
>  	self->nthreads = numa_num_task_cpus() - 2;
> @@ -271,6 +284,9 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
>  	if (!hugepage_size)
>  		SKIP(return, "Reading HugeTLB pagesize failed\n");
>  
> +	if (hugetlb_free_default_pages() < 1)
> +		SKIP(return, "Not enough huge pages\n");
> +
>  	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
>  		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
>  	ASSERT_NE(ptr, MAP_FAILED);
> @@ -299,6 +315,9 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>  	if (!hugepage_size)
>  		SKIP(return, "Reading HugeTLB pagesize failed\n");
>  
> +	if (hugetlb_free_default_pages() < 1)
> +		SKIP(return, "Not enough huge pages\n");
> +
>  	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
>  		MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
>  	ASSERT_NE(ptr, MAP_FAILED);


