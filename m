Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D2ACD3436
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635A76B0092; Wed,  6 May 2026 05:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B87F6B0093; Wed,  6 May 2026 05:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431C46B0095; Wed,  6 May 2026 05:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE396B0092
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:04:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE0DA4075D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:04:22 +0000 (UTC)
X-FDA: 84736408764.05.1310913
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011021.outbound.protection.outlook.com [52.101.70.21])
	by imf26.hostedemail.com (Postfix) with ESMTP id F212B140004
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:04:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=S1i4z70e;
	dkim=pass header.d=arm.com header.s=selector1 header.b=S1i4z70e;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.70.21 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778058259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wdFJczdn/Ohjs20vZffoVp3d8HM31N8Z+cictB+Z7Ss=;
	b=g33D3x08qR+/YiB3D++jromMZ+ZDYaIfbLBqu8rFemxfmMvmu3xgWZ5bm7NgGE/T4lwULf
	dOoK8/UheYfdg4GDYf87QinGw9Jg5dAzfG/3qjgVWOPaFw07HgRhwyNbaMDnXHuaTxgtQ/
	iFLzrF2gOevVir3ivGLqs5z6Y98xU34=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778058259; a=rsa-sha256;
	cv=pass;
	b=Svnf8dU9gzpjBvOKvbc4lnHIdlM3Z/ptlLh1Ngc8ue1jaMEhe7JhJ32aMWpxqg3G3bC1ml
	Q0xOczjFVoM8gTibujXPY7lBD89g8fV9cHEE2rKK4GXUYO5/JxLlev4Pk0PcuMJX9j/fxd
	Etg20qExoZdX25XWm506znQBCC/Aa2A=
ARC-Authentication-Results: i=3;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=S1i4z70e;
	dkim=pass header.d=arm.com header.s=selector1 header.b=S1i4z70e;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.70.21 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JldKN2bXf9OR6Ya6CDqPCjuNWGQQZmON7KACaJa1Op9tQEQgANrqh5bOXLFefQ9IstCRUbzqNxMz7L589XVp6aUbdASW/CaBSwYlmIW1z/mb0erxuHBJ5U0F3IFfXAJOMl/DiJSecgFAoxFtp6abIIBXiXD7eHVzHqgDTg5kVA/4bOXYOjsO5Bd0hyVDDK6dRZmkb51yKhxy4GXrE9RdX9FcAA6YFXC2uU6F3dHtZC9ljeevLhF/eEVAokUQKYTEssZXOW+GKkwTNY3pv6q9wHkRG/Wg7bfunkUDdLJvQoMxGxiRi3kUS0x6Ic0RIjhwLh2b/x7mCpUAVSzGYx6zjg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdFJczdn/Ohjs20vZffoVp3d8HM31N8Z+cictB+Z7Ss=;
 b=VN4J4qyK9j0gu2m3ILt6YEvCZ93H8g0kGDYb7ytFZXeThRc6r+3ZgvjZFi2ftcl6712VN7tFHChOuaV9+OqQZsS2/96m1mVZ59eeIy/fKWFl8lNt9pW98E2Ja6Rgm6qsQxmR3UHIG7QDBTPDHeDE9fhs/0fx3Wc9/23Q1uVStl+VyIUz3zN3k00YSHWPzqVD8Z6PntOyx/8eornNeUfMgNx2+OJaGkKJ1m/EP5N3uog1G3e7YtjJR3yVsew1NR/PSQC+585mOxhcNO54qAGtkEowlYnooVuH5uU+0qu0jPcBmI9WDQrA/bbPtYXYjl8hOReyP5mWU+LM5emzh5uSlw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdFJczdn/Ohjs20vZffoVp3d8HM31N8Z+cictB+Z7Ss=;
 b=S1i4z70eQRoXkLo0rT7YqWA7PBB1vk63P1QhXr1I2EnYmVye5TNs/P+hEDOO2BJ9YoHWrYVuHC+SEpxbLDZNqhy5rjZ+fRI81QfyqPikC4EpzhG+RRBRNqbTC3GDqNiX49QTIVJDsxEMR49DMC6rMcLwFDWlJ4+8WScKmi0x2vw=
Received: from DB9PR06CA0028.eurprd06.prod.outlook.com (2603:10a6:10:1db::33)
 by AMBPR08MB11589.eurprd08.prod.outlook.com (2603:10a6:20b:6ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 09:04:13 +0000
Received: from DU6PEPF0000B622.eurprd02.prod.outlook.com
 (2603:10a6:10:1db:cafe::9a) by DB9PR06CA0028.outlook.office365.com
 (2603:10a6:10:1db::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.15 via Frontend Transport; Wed,
 6 May 2026 09:04:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B622.mail.protection.outlook.com (10.167.8.139) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Wed, 6 May 2026 09:04:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fsiyRK8mBcOJDNM3ps8NMIhHkesBUL55j/H58BiQ66Z4bhW4xWTa1SnSW3PKX3O88Oe6BoA8jBztzHBb3xmLNp4SWrcZvWSe7gyZbxlj+lhDK+fIBSVe5ztRxt7qpzLuLb7/fRuBPfVl435GGQ7koBeo//F9pfYtr4P2/Wpdm9Cb37ws3gSmrNeZv2k+v88ou3sYZqkNx1Cg6koRbNP9T1jgPZrQPW4bx41XwvdH2yN3LlfxMT9KvJv6x6VfSSRCR0r2jMkADMxyfsEW0x7TdA83uTkTYAJtygsXcKT4SRxiV8K3668dhN2k6mPDs2aosrw2KV0fvc0IZfW9eQRDrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdFJczdn/Ohjs20vZffoVp3d8HM31N8Z+cictB+Z7Ss=;
 b=NT1qkiGoIBiam/dWR0gEWLyIxZ6C/JaoGJIW9isDMK0Q8dozEMHc6wBd8kQykLZk623r8hqJbsnMDH68GTHs4shw2ce4rkcr8tM2v9M1wjKzjg37rw/ajTfhM5zgE/OnWx7fl1Vz/DlMQ31g0arBeU+tT/8rxtI/cmPFMhWAWEcQqvmF2S+LGZBiCehiSD9U1TAymHAhuysLxQmgDbHr8DAsxmv4QvX1dvV90+r7732F1+31sQni0FJA7Lxtk0DXQZ5aplKnU09IarLyzRJzLYOhZYv2QjKnxY+N7Bh+f6sB6HLekHgTIAnHg+mi6GY+qiqo3fDx+VzWsXpDkJDRxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdFJczdn/Ohjs20vZffoVp3d8HM31N8Z+cictB+Z7Ss=;
 b=S1i4z70eQRoXkLo0rT7YqWA7PBB1vk63P1QhXr1I2EnYmVye5TNs/P+hEDOO2BJ9YoHWrYVuHC+SEpxbLDZNqhy5rjZ+fRI81QfyqPikC4EpzhG+RRBRNqbTC3GDqNiX49QTIVJDsxEMR49DMC6rMcLwFDWlJ4+8WScKmi0x2vw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AS8PR08MB6486.eurprd08.prod.outlook.com (2603:10a6:20b:33c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 09:03:06 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 09:03:06 +0000
Message-ID: <55d8222f-4c87-4c80-90fb-86c3d6c6638d@arm.com>
Date: Wed, 6 May 2026 14:32:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 20/54] selftests/mm: va_high_addr_switch: use kselftest
 framework
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
 <20260428204240.1924129-21-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-21-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0047.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:175::9) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AS8PR08MB6486:EE_|DU6PEPF0000B622:EE_|AMBPR08MB11589:EE_
X-MS-Office365-Filtering-Correlation-Id: 5725ff9e-9618-43ac-87ff-08deab4e714f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 +WZD9D+w0D0SALeO3OXcr+/MGqeYOMt5iibGcL46GYS5vzFtAEzLD3aJkejbjKDzI5rqm6cJ+byt0A97zYkVaXIKLOR6gVeAgIBb9PTtkj5uztyd34M1fVc8NdpvmyQ1sAMnySMn+CiJZh+74orNp+RGzfDOO2d1LPd1JfcF+NvipXG37nbi8Ui6tOrrC17qVt5UAZOcjL1PKDMSzfPiooIwISgZY+Ch41t2DFjx4fHq8cq7tE+E3JA6ct2JWENyUCT32eEJ8xZenLqcC0vRxJs49gTA00eXRhIKD2TkfZf0UzEWQylpMbbDnBgy7nbC3A2/9tdFIMtpnglkYF4SwkEyYrQ77dHo3dY75v7tYuHmLlUXg88NNxI2qEsbLDuMnreZw0g7jjTKovALmo52YC2wRWj8WckYRF2zCHQvDQQEDRhRScJrh9l7akSpyt7uMSUVdiY+3uOf3bLAS9HKsbCWV52HUrYAzvbA/fMDjw1ckX0V7Wl7f30QuKjsS5nu8oOmVxIDPw4cDm2n97NHZ9J8rsh1BsCphJ7hu+QL7NvHlaglDvFWbFu8bY06/sJsWG7GSHNHhJX0RrL60jccb4grw1cSe/xVhPbvmzZJl5xLXLjVXcWlj2wjD3ihaYQ90zYRS89xEG3CesE/n04ZSVDbGTNrgY0Mqs+ru2vmec9lqDZkA5Oqn0MfZbYM0umw
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 FA4VY7pcADTNklVTcsw54vGXivd4cTVmpazcLVjbwvFor0CYWCZ7zhUjMUK1Ma6cQLSy4mUDv308fESLeUCOUXdMntdBttQzDp0BqJmG8r8tjeiC+dF6xLXeGJsQ+jHNFoBRBqhdakQbVMG7xKMRFgybuehKp21rzafKTL9/iRMg3DDOX7hJaNqEe/uBP/W4ppOBX/RF6Y25TXi0/A/JCR6qHb0CoE275oQOYMcREUk2OnLDYml0wZh97o5PmQ96CXzEgB28QOyP+Ijg78sECFDC3q0HWI1r1zWjqFW3ZHxYCMRFgYGSrbo5evKA0a5mijFBTnOKRcKVnZCqi0bGmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B622.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6a330248-e438-43be-98ac-08deab4e4950
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|82310400026|1800799024|35042699022|14060799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	vndYM0YLrMwbn/das65jlshCCtwpPM3bGmVn4obmESzuZJQCnrq3D765w14AG0WjDcpZ43Ohq1jzT+k0e7rkmGBH6i+JAjxM0mIzaU0YbJYCRqp7Jy4cEoK/kgkyfg3bTcJZTPAVowu9QUtT3TkKBhTMGg6kqtsCuooxx2ZJ6Hl+BoFwOItPl0oRn0TflRfQRD5lFX7/PcaigYtx7DyBCa/pRIvrgtGGh/EEU4LnoDQAvHXaHMtMrykdV4sLTaqVpE3dP+FpsBbr2PZS6rtaTPwe+7pwKHIYl+11mYGyLubVcHLES3rRkFKOU+uiFjrGsxxmrn8V0/RjZBoeusJZlDYA5HwlibZZnOmeFjHO77u3fA3Pl1ak6soA39YGBbabQ94ciMA4c3Nec7BoQvWg5QwXcVnDiJspTgv1YepzDOwLG/WhCXuZJOdKmDROijZsrZ73iLbKSQ2ErchJUms07epewWV8xbLlJ3hCmBEMYMXJMSNv3UPtYzHzgHAOz1mJv91FCumJazlzGjbipx7xWS5ByP2kfyWxWsuFv/ihhYpE9xd4jzU8NEKKCF/WHti0x+q9Kmr89zMOZPoqTvK+84SEYVexhNPyGFHE567SvgQ62my2B4XVhNHf0nUmLnJDMUqW1EYx8LW6Qy6/xBIxzz7yGIr7AoNuwzfuLhQs3oVek9DZgaQVYXJPAraS0gOirGJvus1wepU93bMIrMwZCN4e/weoqvupmYAA0illAeo=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(82310400026)(1800799024)(35042699022)(14060799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3LZs7zkHGThnebw/6z5YZQjeAWSiLMnK/VyGoCV57V40wXyNUi1LiLx5e6XLC0Bintu/k5HDdSMeBahqP7gqW09L7EBZbSNWDxsqWpgglOQ8LwB9zi0Vdbg/gfajAI3bnX3oKaFYdhPgnseH0XLDpK6cEYfb5IXSi5HXk+M6BbXAzWj5JsfGdvS2oefCipzk5EQapCoqq43E9IJssH4q1CfAQ75chB3/T/RshZC5/hMRNv4bUDQXbXf7JEP08yXiO3wP3ru7477DOeSzdiRwl3JrbpUjWZG1LEGQ7TJnHJaHrVE8HnbRFcEkMvE3mk9nR0lzI+Fgxt/3dn3mn4t6b+q18l4OFtzSN+mEmPE4JOJmGRUMZFLPjsrsHBIrOz9OOjtX5+9UAuABHUSqXJrvvbL6czoSqrnmdl0FoPmdWe2xte7wkggWuZ0wDSMx/MmM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 09:04:12.9037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5725ff9e-9618-43ac-87ff-08deab4e714f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B622.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR08MB11589
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F212B140004
X-Stat-Signature: 95mqkohwr6t3rgmyc95d8bn3atd7mcr9
X-Rspam-User: 
X-HE-Tag: 1778058258-395
X-HE-Meta: U2FsdGVkX1/eqZ6goYz3p3geZnZ8eXBa5KAQ/PLCLGKRWmSP73JG27/cWsjH82V/pgxp0HH/XOZk6biD5lDa2BIGWyHByy2a3ghNu2WK0MiQVYJdTV2pZlYMLStP1D/QKa8dHvOZX91gj/ErgbSexjhMomp3yonjv90J9S5ww2DTQ8qPZ/J9mZGB8Bipb0QXEzGZFTtPE7UYevpCKYeW0qiAnUBwO2W9KtJY0jNUX8DXFerPNkSPKpWJ7Qt/bQgOBRkjo897Adf41rIgNCpb2Z8vbazXxjTkYWcsm5A10Pr7iB9+W1C30qtnRL0Ouw+NZx++yu95BzQo+RKaVXbRUG9e3kSe2IiZDnSCPqenBDW8Pr+N//adtW6XwTzcJTXK7rLZ67V9pEWRQU/KZoYOC+ArTumG1aiTmXxtCVUgMwXiZzvk4tLehCVc/eAFWq+sB0OHAEQyJdPw4fN1mJfd4eo1iK5/qq/+tcPDYjHpCdV+s/iLdXebw4zm+UK9wBMeJ7XhbsoZq71iNZwF6pMKHyaTwrEbLJdySTrHtbQx1O48nHeqexSza7gyfN4YFuPgnNJuBYItirO17u7Of1uZrL3ca5Wsw0ipf2G+AIY1jjb5DmEyFlTflRG4cyFnqFrwPXDqQTiIA58DlOUEMhPN4jXLcUTOZCyqaR9sZ7ZMPp0hcV3L2YG6vBYm3fVfiH/LgN4p1w9UPFWL5zhMaP2Z+6/smvAe4Mf4hSeBlLvj9nGgDBzTNlti5GZ8OwY4gx9235f0z8OLU/FjNk0Kcnakn5Ujk+Ugx5+z3ydTc6Ehk2CwQOVVScDdoHex7Q/PBYHxj5OXrdIjBgW2hv65DQSIscR83rn5YOR3B0904XyNVP0Nxz3sFz/f8/J2wXgVks8TQkLzNyUaYqs4Ntq8f3H0vbSaAi+rikKLhE5RGMKyaS0DokCSjxnsk8bDtGqFn0bnr7C7gMRBOLGlrSeWZNq
 6MHpf4nA
 TKWpx4ZLmHAEWMbrktOoOYEnob2P2eYLkvZjpFaZINrRUQYcvxqnyZywC00iZT79c39fg2x/9Hp3bLtThICP3URpv3nh9Iv+1yCWvsu5T0UXqv6oLSWDOfuOfQq78TKAzdVsdn373hUPw1LBtpLpfOsM32Z8YDGJBbbj590hKrA6i81cCSmhjJXHaD72yEFNItFyDAXNbyL2NzjPJOBjVXEzdiLNaMVJdxVVrYUT1wQAhezCEZlFJeen4IgjjWgIzw+8KqC9hRBPfvMtaDTJVLZTHS8BfEDcwE6xu9CJpRJXndySrMuld1PTG+2GAI1wYmlILgjJ38EnQk6nKR4Yv4J9iqzvBY8mE33oQyXXSbGQE9/IyZ/l2Zawca7kXbWExYecGN7LyPNea67wA66Dho+ibilLRuAC75aLPXFKiZzjThMJiyqhNjLPJWwGE6EMaXtaKIen49vUBQ6HkfB6nM+LdzXsXkMRsaus+9uYzWRc1E88qdA0/D5qfKGewbX1bJuINrhHWF46rQNwvTxpt7o9jPG+PMm7xm2S+YNqmRS/xhi4qUCNvuC0/jswcwjgF4WNauf/I/5hoHgFx0/WDKPlVi1I/J3ID9gh6QtwTAOOLf/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Convert va_high_addr_switch test to use kselftest framework for
> reporting and tracking successful and failing runs.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I have run this test before and after applying the patch. It correctly
converts the test output into KTAP format with no change in results.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  .../selftests/mm/va_high_addr_switch.c        | 41 +++++++++----------
>  1 file changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
> index 51401e081b20..5d38735ea60e 100644
> --- a/tools/testing/selftests/mm/va_high_addr_switch.c
> +++ b/tools/testing/selftests/mm/va_high_addr_switch.c
> @@ -257,40 +257,35 @@ void testcases_init(void)
>  	switch_hint = addr_switch_hint;
>  }
>  
> -static int run_test(struct testcase *test, int count)
> +static void run_test(struct testcase *test, int count)
>  {
>  	void *p;
> -	int i, ret = KSFT_PASS;
> +	int i;
>  
>  	for (i = 0; i < count; i++) {
>  		struct testcase *t = test + i;
>  
>  		p = mmap(t->addr, t->size, PROT_READ | PROT_WRITE, t->flags, -1, 0);
> -
> -		printf("%s: %p - ", t->msg, p);
> -
>  		if (p == MAP_FAILED) {
> -			printf("FAILED\n");
> -			ret = KSFT_FAIL;
> +			ksft_perror("MAP_FAILED");
> +			ksft_test_result_fail("%s\n", t->msg);
>  			continue;
>  		}
>  
>  		if (t->low_addr_required && p >= (void *)(switch_hint)) {
> -			printf("FAILED\n");
> -			ret = KSFT_FAIL;
> +			ksft_print_msg("%p not below switch hint\n", p);
> +			ksft_test_result_fail("%s\n", t->msg);
>  		} else {
>  			/*
>  			 * Do a dereference of the address returned so that we catch
>  			 * bugs in page fault handling
>  			 */
>  			memset(p, 0, t->size);
> -			printf("OK\n");
> +			ksft_test_result_pass("%s\n", t->msg);
>  		}
>  		if (!t->keep_mapped)
>  			munmap(p, t->size);
>  	}
> -
> -	return ret;
>  }
>  
>  #ifdef __aarch64__
> @@ -322,19 +317,23 @@ static int supported_arch(void)
>  
>  int main(int argc, char **argv)
>  {
> -	int ret, hugetlb_ret = KSFT_PASS;
> +	bool run_hugetlb = false;
> +
> +	ksft_print_header();
>  
>  	if (!supported_arch())
> -		return KSFT_SKIP;
> +		ksft_exit_skip("Architecture not supported\n");
> +
> +	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
> +		run_hugetlb = true;
>  
>  	testcases_init();
>  
> -	ret = run_test(testcases, sz_testcases);
> -	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
> -		hugetlb_ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
> +	ksft_set_plan(sz_testcases + (run_hugetlb ? sz_hugetlb_testcases : 0));
> +
> +	run_test(testcases, sz_testcases);
> +	if (run_hugetlb)
> +		run_test(hugetlb_testcases, sz_hugetlb_testcases);
>  
> -	if (ret == KSFT_PASS && hugetlb_ret == KSFT_PASS)
> -		return KSFT_PASS;
> -	else
> -		return KSFT_FAIL;
> +	ksft_finished();
>  }


