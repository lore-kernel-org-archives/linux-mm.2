Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A7FFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 11:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8ADA6B0005; Tue,  5 May 2026 07:28:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3BCF6B0088; Tue,  5 May 2026 07:28:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C035C6B008A; Tue,  5 May 2026 07:28:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB8196B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:28:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 53FBA1C027E
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:28:51 +0000 (UTC)
X-FDA: 84733144062.09.7FA4BBE
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010028.outbound.protection.outlook.com [52.101.84.28])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4545940007
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:28:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=B4cc3ALI;
	dkim=pass header.d=arm.com header.s=selector1 header.b=B4cc3ALI;
	spf=pass (imf11.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.84.28 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777980527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOjzXEc0PrSRWuBcgphpOvVoVg22Tfgi9nnp2xEp0y4=;
	b=QlAaeDGNgpeSaZMvmNComq4XZWiJe4xNvFaVFZvkgyWd8QXeNf1pnjvY+bSiEOFEoKbiZk
	+fW/mu6ltIVqSAVshzob1G8gubkkKWLlroiVZN7u3P07Mj4F+07kk6ll0Ri1RVvRTVK7+f
	byRCT9CAxRX5R+DiBSE7kA4VV4k4Z1Y=
ARC-Authentication-Results: i=3;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=B4cc3ALI;
	dkim=pass header.d=arm.com header.s=selector1 header.b=B4cc3ALI;
	spf=pass (imf11.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.84.28 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777980527; a=rsa-sha256;
	cv=pass;
	b=YxKrkzUqGMKUkKAYVIhgdei5zeZ6F1ZEYTnADVyCuF01YAleyL+rtdE4GZi5Wr4d67tj7T
	OypSpszgq95dtAuhJmkASgMqt7rN91FmG5Jd6JAdv5/iSKkg2NBS3kSp6AWOihhGKUAXzd
	6LHlBsslxX98RGp6sjAwgUpqiWgkdUs=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WhztLOsPlC4/2FQAJTLpjicKEBJtD+pQk8F9b2MsVbUg1RbVSgVNBptZrdUwMy9Hh00AGyrWOhJSH+la/Fgt0l31jJbqYk6ukjtInS5tjtTBQbV9uDrOY8mOWMTg6S/ujqv3En+f3O1p+xHfWe8ZNYz6JLX/Z7npqiLbWjSjw0u76lpULG3Vw9537F+fsZwrvbzOdvwdYNIZO2+Igb49lTG7Ga1eM7lnvMGWmywLMV1HzJuvsotZfA3SgfOMulIyAPvT7q+aaMbMB+hGmO/X+uK4NGWvMCOw9ZWzYKN3QNdIYQqmLYG+utVx0pEQ/I5SA0yPgialNq6SzUjubw/oKA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOjzXEc0PrSRWuBcgphpOvVoVg22Tfgi9nnp2xEp0y4=;
 b=bhzohHQOYaXfW89gYzFkqsErElzyLnoajRa0pz2aqaaJ/2qJKjJpIVnlKFdimlWgSdzKS4jVwmrvhfIWVXAAycSNM6PRrD8pu9i3Xgfq5/0Mc5NxhlPUToIw6+yCRLHVeVVwta++PyyC/LmbM1BDyO/pI318ozitGBAVsoJUnhhui50lRBXD9qm7v++C7WzpLIhpxtndPoWwBfzoJS6vfKKr/5GTTfSH2XTBGiLGMyR1C/X3EKpU6V39jq6j45ZZ1KjjpkzbN+Cp5GJnuaOhPZG44NR7K4H1wKkQ+ZLwwO/jXQWa1Qc9JCiTEawakQfCG7QM8uQ/rzO1z33c26w6XA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOjzXEc0PrSRWuBcgphpOvVoVg22Tfgi9nnp2xEp0y4=;
 b=B4cc3ALId2hvf/mlLUzuFY6EEPdtN1HXe5rf8jSmSUXSxBE8b/s+Itt3yJ7mC/Whb3jMsAsvq4WkcCZbhvWVtOoLVRaQqR2LGu/DFroDe+awGWKan1HmTbf0MKZYyAyxxZF73YGlMjNWR3kaseHyufT3jrdewacl0ULvZgpMoYc=
Received: from AS9PR06CA0520.eurprd06.prod.outlook.com (2603:10a6:20b:49d::23)
 by DBBPR08MB5946.eurprd08.prod.outlook.com (2603:10a6:10:1f6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 11:28:39 +0000
Received: from AM4PEPF00025F9C.EURPRD83.prod.outlook.com
 (2603:10a6:20b:49d:cafe::3d) by AS9PR06CA0520.outlook.office365.com
 (2603:10a6:20b:49d::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Tue,
 5 May 2026 11:28:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9C.mail.protection.outlook.com (10.167.16.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.1 via
 Frontend Transport; Tue, 5 May 2026 11:28:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DLu3DSbaqMpII9IyabbvAc+xxlmYKBbjipWHRMoP4WF3tnZfvz9BSYoCP4KGyoxkVMw/Lke6joqEf4vqpghio+a1O0I/zytDWo97s3O2OGIe+u8Fm44bLda9U7OiOSPuRmwrplo6tWODjLqXxIWpBk5Dktzo7RT7Vlbge2sFyr2WNf5stoPzvfqsjyHxCyRR7PMtnFhNsvyGuOHykRfYyze0jDj3rTUaGco7BOZ+6ANEw2+/nCNU8iKePMB7e+THf9uJo4J9L+73unzom+MnR6cDtxmD/pDMx/i2C3AnuN8Zuuuy1nCjZJrcfw6fVSMCsftNYJ+aeIY1luyQaP0eOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOjzXEc0PrSRWuBcgphpOvVoVg22Tfgi9nnp2xEp0y4=;
 b=igFOCNCMkHgf3uPj38vq4mzfLhIel6lvaBPJAKnTEqYKs8OCplkvQ6Omv0AE4Xs/SgeAmc+lwscNm+1ClZz+coatH6pxLRn0NRh7OSTyS/M3CHHuPwO7mAy3+yxyl8iETuDxF2sIyD9P7wjQ8PYEANcU/+EasfjcSqlh+4u/7ZimEGyiVu84wX9N0CVj6q/KGltCtikNYN2ZfXZakOnXTc+nqVjwSN9vXkbIyY1+w1zXYgj+s+luT+zETmK4EFvPMSzZ5sawyK5pQn3v58p8/keZ61gG5l/w4UNcHFAa5K47UPSVWxHYgaSx1LMnZYe5TOzEyKzxPhkMQTbDqBIvpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOjzXEc0PrSRWuBcgphpOvVoVg22Tfgi9nnp2xEp0y4=;
 b=B4cc3ALId2hvf/mlLUzuFY6EEPdtN1HXe5rf8jSmSUXSxBE8b/s+Itt3yJ7mC/Whb3jMsAsvq4WkcCZbhvWVtOoLVRaQqR2LGu/DFroDe+awGWKan1HmTbf0MKZYyAyxxZF73YGlMjNWR3kaseHyufT3jrdewacl0ULvZgpMoYc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AMBPR08MB11654.eurprd08.prod.outlook.com (2603:10a6:20b:737::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 11:27:35 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 11:27:35 +0000
Message-ID: <8255ff5b-a4a2-4115-948e-9a2198f27167@arm.com>
Date: Tue, 5 May 2026 16:57:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 50/54] selftests/mm: uffd-wp-mremap: add setup of
 HugeTLB pages
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
 <20260428204240.1924129-51-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-51-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0191.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1b6::7) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AMBPR08MB11654:EE_|AM4PEPF00025F9C:EE_|DBBPR08MB5946:EE_
X-MS-Office365-Filtering-Correlation-Id: 554cd7e4-288c-4452-e837-08deaa997487
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 6qpBHcp+ymIW/xn7ItcEq3+78QtBSOEjh5LWjSHombtirlVjiWbjbcH+4WBTcu7P2daENJWR9V5MQ8glIilUTa0OMtG9la2LH+L2Zh1IuW7HIKXnD5izXApX8zhE2MOXff9HoUSBi33OaWMHz662rVkOxSA9R2I7A4ue9bN42xGhTxmFR6VUO/QFP/yWhSNsTzXZU7fqr6VIOA28akBRXI3ZkleCyxUHHibm6X1T7vT9U44I1MP2CQ+9bBbn/f1+UnpemXBEKoAY5b1Po5XVSc/CZ37fXIDj4TaiO6MmEX5u3Rc8wFKpKnW7iQop0gi+cU1QRedKJ+l/xMvsgMebu2zkZAbnlrmO4P+XktP9mjkGH/Ttl/4OReXFGkzRRkn9UURWfLvSi1Lx2iWp6HtmJuwSdvbwQaLB08GvFjcY0AcQSuWWv1775zxmM0YxwyBmIqO+AwFdsvQoTHq5ZxbqH7lx4oyb1JlBkp7kU89QPpLdiWXQV2LmyYBPM1J0XmEYVfowhj++Dg47XmmvQelvjJwGKuS+s9xI1xCw+gBhqU6b6BGY27QRJ4+QqmYAFi664h0Xwre/Q5c4hCzp+sAysGlIsAF0yD/6vkH7DSxZBJ1RJMG7hdawu1GqnAumXIM4QpHIhG3hX2T2Dgg89WbKFQIKhA8uARToxCRImSfhieLQtIf5RmG7jxERXGc7rBQt
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 O/8YD84obmANhQ4thgHBllyUyFtxA/0lmIjf1gw9xB/C7vdGM6JJDAen08ytefAwLRTbDwxpv8kQZs78ai31ev7XBv1NiS4FczbOMbKJ7eBnsEGbVIX9j5B8GUZHxFQm7/1aQgGGmCGFslb0EXt5eHdZGnRFBHkz1hvWMvxZXaa5A2yPAFCYV8msDOMMtjiW6tIhMETJRPFyX0r83zXZtFbw7hX4vttOerRHqLbBYB5wAOa//+p21V4hp92K3REjNTXIlaiLhZL1OhTaXwJZpPYOdNy1vSCJ0y47Yy18EOI/xubmmeD7Y9v4b7VCVfqH6DWG4kX+iOVbo7AmUmHz4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR08MB11654
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F9C.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fb75a950-bf60-45a4-d393-08deaa994dc9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|7416014|376014|1800799024|82310400026|35042699022|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	n26ypGN9/VkssOF27W7vqxGVlaiZ3ssHjZHGwIt8GqFd3Wqf+8vvVoHIlCEgydV+qgGbzdX/PDYUe2zdfKjdTJYUzITbgo1Wa6HaRp60gT+n0yMNxkW2rXj73ZUg7fmXbIb3OSNph7QYR6acCXGKXx8DV7D10KmROP9/9B7cvUHy4l/wPNCrfmDzmmXTj9XuVP0cm7b213jjBrFGlXFCPCZtSow9C7NX232iNOOXXhWlomlpBtmX3FBlUZnhF4PSRTqndmTbFWLHL9p8ewbf9c8MpbIGL3Dbz63ZcKpAkeCe3lDCE62XSfPxaGdKO1ljfiJ1VUcg6MqyhbMlCo3bfpZbUbHqZ/OOyUuZQXpnk21qjlBPn5ePdrOMfmalYU6bRagPtI6gE9PtFSUpHejX/kbNfQEMDz7w/4p9pcPa7KcRyBPFT7QcUc9h+4Bs2uSVCaE69GjzgCb9AzYCF6U/Q9qPGR7hpqVFGGzGflwBiLhgqM2HOc+HCBkmp0f+xwITGZElQLjwDajq5gsSHLgIHnQHspcOIsZVddl65oDUc+pv+trWI6VA4SxZ9cAAXeFM1bxl4AjBrQ0yGJtNQle5cPxF98Jqh+rp+OULBSFaeHK2mQfhSwCU8WEXSPiiiymJ+JJ3zKqY7UUy8gpb+0GVfxfC6kDO9CxDG8JgIlMhxm6gAiUV4YY7daGAE0KDBGKWhOl94vO/KUbGNDj/M8+xrakq9SEi8GW4wQgX5PpyRBs=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(7416014)(376014)(1800799024)(82310400026)(35042699022)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ObyaUWG8wVd5AD7hJLjkj9GqE+0nJEGhhde86/VBtgNLcJn7AsjXD/NL7R5kLwMgOFIKAh7a8/drcoOUP5d/W3Pd5xOMoilt2NTy9Cmw31gveDXKqz0aZ3D8jRQkHL3V9ezHG0jQhCsmhy+alIZwoZHCr0CB2EECOiBZw5ReSExIo1lOcjV9JYRlQA951Azo9v/ir8/lWo/I+3yaBm3HB5G5bCVIZplvRbS8+EJdNxy0/FzvPhZYgW2p5v7UMcWw0G+RwmJH7uLZsLVepjmXTz/smZFg3FZkZvliXQ9aAKdLPZK1LyNj2leIdW4NEF+zWul3vF5KOlMOTxMpi8fY7zelvLVZC6YrvcXTcAYwUwPpeXwO4goqWivuArdo3hjoDnQfcVruqtljWaOGmq6oXjOcLw08ij2C3JVnk1O8Aah5irlUaUUuTIQG/ChDKECf
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 11:28:39.4015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 554cd7e4-288c-4452-e837-08deaa997487
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9C.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5946
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4545940007
X-Stat-Signature: ocozrptejrn9a6px3m7cpfbmi8ydcpof
X-HE-Tag: 1777980527-248967
X-HE-Meta: U2FsdGVkX19v7JL2A61mqMBE7YjpFdZ7zzSVGiotEdtuCCWjH2LZ8Te7tVqIjkyEKllszgVsjBvy9rCNXsHrS4j8tJ6GyWHKFb99DT2nK0afLuUGygMOnz+HIqjzwMW6z2GEKCVjCLHY5lRf8iBpsnSEYgKCfbnlNg5F79Mmp0EOKZzklIoIKthTQ1vvaxAmC+bGphPRvfNbajhJII76cDcLH1YMOCOLOhTjredmHgeTvL9E6hv0taxiENXjv/JqK4MIqe8bsepfqW8rYnLQDcvWHhF5f0Jrtv1KTF/H5/LsvYrraHTpnCbO3XKjKPfFOn6+KG1XFEb7/m4wl9iFsL+/27HT6APRufAwKz0z/Q1nr39hmwwInpycYESa8WdLWesf3hy7UjtJUxEcnNm7e5JtBvAop5K2+NB6V1U9eWWCgPfCrWAse4JXwy65WGIJJYj/wNitxwk1ZPtUlzNniksadiqbhTLJLGcIs+6qBKM69EcitdCJTM8cx+O8Qpr1P5GxP8NVPbtDAeTX/vaiv6CZnG8HofzMnRbqlXW5bo2Z9x/LXSTVuRRBgGw0SRp/l80L9456KdsjcoiJozY2k2+siWyAsF0HBiohNehrASGdRap1nDgBOQxSZD5CHXeQF/MomJwemTH5vROAiFS9xQlSWD5/6ndD+2oc0UCZX4ECs12Bf5rwn2vWhiWf8P4bLeDxKP4sG4uWQzE6ZOwg9imdm+tN4sPEJjMvaI054jfX2c8jXd8ORDk+T6P/U6AAFflc7oGVyzd4HIjUEWrJ9ZiVp5cdoDkLYj/IvcfH0r7kadibv7XCzTYo5VEM8dlwOGbiuLK5wLXVYseySKO6yUU754WnQdBHjCzfQbJg3gN+0AAg8TKJRAu1dt3w/cn6OV0vPItusDhoP4hcetuUzxJiQALJH1zctk2xm8IXleD3/XREPeBI+ZtP+wrsUm248W9KpH9B/dKas+Yckkl
 JRVDTy5Y
 DAd7yZrVPM+2fHuZsK5je4DqQkFWcBJa1cShs1iRgWKecfChLKCeFTLU0vbikX08wwzRoj5fTWi0eRe1SXfc7Ch0jO4vf1JGdKkThUs9W1PxIY+zJVNAe1z30e9U00mcYLez54aO11v8bHRdnA6V5e11hrv9rtOSYnGcS81kC58oRIDhc0EJ8IZymx3YgyFNk6OVp8wTRw0IENx4v96HbjnPzH/TRFWa7GNQiUx8RedJCMBr0Z0Q+LSSHrHWtfbWL5HurUj1gAm6kBBaEoGTjclSw17PVFaV+Bu2oIBcYu7gTGI5JkpQOOv9tJJcCn0SYpjsZWc2xTk1Gu6Es539HamnD6lMh1vMBhhfyhEhMURIcsoL4ueiIDquuyLOH4b9KLsLRhna2IT9y+lg5FDyrIIHTIAlukYXiW2ZKmCpq3yF9v+w80IZ0SQxZt9ffu9limlznkdJTz/JVvfdgod1UQaCw7LJL+VVDuWnuW85UkN/usx2aYRPDU3V6hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> uffd-wp-remap skips HugeTLB tests if there are no free huge pages
> prepared by a wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  tools/testing/selftests/mm/uffd-wp-mremap.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
> index 9d67b11c2f28..f63fe02f404f 100644
> --- a/tools/testing/selftests/mm/uffd-wp-mremap.c
> +++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
> @@ -336,14 +336,14 @@ int main(int argc, char **argv)
>  	struct thp_settings settings;
>  	int i, j, plan = 0;
>  
> +	hugepage_save_settings(true, true);

Since hugetlb_setup below already calls hugepage_save_settings()
internally, perhaps we can change this to hugepage_save_settings(true,
false) or simply keep thp_save_settings()? Otherwise we're saving the
HugeTLB state twice here and it seems redundant.

> +
>  	pagesize = getpagesize();
>  	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
> -	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
> -						    ARRAY_SIZE(hugetlbsizes));
> +	nr_hugetlbsizes = hugetlb_setup(1, hugetlbsizes, ARRAY_SIZE(hugetlbsizes));
>  
>  	/* If THP is supported, save THP settings and initially disable THP. */
>  	if (nr_thpsizes) {
> -		thp_save_settings();
>  		thp_read_settings(&settings);
>  		for (i = 0; i < NR_ORDERS; i++) {
>  			settings.hugepages[i].enabled = THP_NEVER;


