Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2292ECD3436
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE2B6B0005; Wed,  6 May 2026 05:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49EE66B0088; Wed,  6 May 2026 05:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366F86B008A; Wed,  6 May 2026 05:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 206B96B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:25:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4C02160739
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:25:11 +0000 (UTC)
X-FDA: 84736461222.08.982C948
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013021.outbound.protection.outlook.com [52.101.72.21])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1ACE08000E
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:25:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="U6fKl/9s";
	dkim=pass header.d=arm.com header.s=selector1 header.b="U6fKl/9s";
	spf=pass (imf30.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.21 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778059508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PF8xbkF1f29S0Ic+T20p5AQKegZlB38/fmLetIe4O5E=;
	b=FNVVRDcIDLNqrZKjf6dgDkgmKEsT5lADe7VJSRYyX1T1LFnam3wm9xo04/MIPSmMqCPPzH
	HDgTvQUbTBfvhH5SnsaBEI+TY1ccZBIt5YpLPZ/KR39mNUnhNDtGilTk0fpR5LMGNf5fEv
	1lh3BqwVyIk5KYF3UdtVp6ow+4Jo4Vk=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778059508; a=rsa-sha256;
	cv=pass;
	b=sKNH8NA6sbETcrTxLy8OsuqbYqjuVhLBRKTT7MGaHT8osHjQXCKLDNNJDyV/u4+sQk2k3d
	Pe2bteeZow7/+wd8sB6Vs0EyEVmthtLE5KgPP81hnuXBjTbBQsuY1kxdZ0Nfjvdpa83as8
	tXPhHKXOM0/i9ZG0kdvZPmQqAvqGN3c=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="U6fKl/9s";
	dkim=pass header.d=arm.com header.s=selector1 header.b="U6fKl/9s";
	spf=pass (imf30.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.21 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=s0GUNzWEOhb+FaEm3vhRkHLcjikNrXb5AAF+1ViZbPIlMz2kgVZutyfFpSZukHusfjnh0ko07qPmdfgzQ7/EGTK/ZFbqMrZhRE+sdFEsem4muXFxo6IHO28mEg94w9yM8CrgxwHaPbiTw6RrKhpun5DHHhJO91lW/9TpfZM/eZBn1k0ntekBHm86cKTAT4+N7PEpFA4FFZ0Ik1t93FicuOFoXzxzqwXlZNqwBXvQlzDejZG+gdVdKl8UFc2HQwMIydkaONf3wZDQTt6ESKW+GLzjyoQayC1qc0ZBdyWDyfs51njvvotQWbSJzVzog9oWPy0uDiZobz1GfWsd8Bn6sA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PF8xbkF1f29S0Ic+T20p5AQKegZlB38/fmLetIe4O5E=;
 b=YteiekAnYiDfBsWOUBDJROMLw0SzVM9Z6HE5Pju7OX9FWDOklC+FV2dFChYCzCanGfeRqH8FjQoinVvQVNAKzs+r9yOTinao1J1/+FNeTmTuQswXXxvBsi+XkPlKs9QdqbTFJDH0JkCpa5cnfoqSM/kB/bFtS7mZkZlutJUwRsv7mMXqiAnsDOxh/KpMdr3fZ9TYTuqi2WkIpX2mnLllLhNra9VaemIFV1y3m9K+wKI0dZUN9vFf/ee6aONH2CaCErfP1/rxIetOLW0hYfy55xjlONB/F4ET8BTH9DRnDE3xQVfEgNj5LDJT5IBfG+2vRDQG7lMMXIk56lkNO3CZPA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PF8xbkF1f29S0Ic+T20p5AQKegZlB38/fmLetIe4O5E=;
 b=U6fKl/9s4pi/IocfMLBUEdLv0LZQd2r+CDzrvocxXrZto+iJ5HWteYAo/SaQrP8swyxPf3NUA7633rb46LadcAGVP1va9wiXmx4hmuyo1uBHLObnSFUYbtK497EqNsC1BYDwxfY2HKArrLod8wkKsR5n41rxYXKMj1wEv6bBmPA=
Received: from AS4P192CA0047.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:658::19)
 by PAWPR08MB11488.eurprd08.prod.outlook.com (2603:10a6:102:50a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 09:25:02 +0000
Received: from AMS1EPF0000004B.eurprd04.prod.outlook.com
 (2603:10a6:20b:658:cafe::91) by AS4P192CA0047.outlook.office365.com
 (2603:10a6:20b:658::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.15 via Frontend Transport; Wed,
 6 May 2026 09:25:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004B.mail.protection.outlook.com (10.167.16.136) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Wed, 6 May 2026 09:25:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VCcIVVqtnP2Q19Ir3SlYQbZIJdSLVD0Z8eBtthZuXpiHWbIGEf9A5zUDwDPGgxJkBFIxmq4mgMEGlIUmOlOAudwv+8+iC8G0prUuHie+IXgRqdBQP+cW8mgwdlhSxyH+vMo3Mg1ru1YsO4/Rl+Q7fYR+xgU0ljm5MlOTNhOwDilRiiuantB7IcOYlOB4Yo+e6/76cyBP/TIwsKgd0mP1d7Aw5W6wTvBUzFrUUny8BuVq6zFQd2kNvTS8xmLt7ANUw7FqYhCkbKMh01xii5wXQ39BRphPPeQzkKaOisZQ+UEsyEQH5rxPI376A/KL5guI06nW+GpHC0mHMmeU14SxHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PF8xbkF1f29S0Ic+T20p5AQKegZlB38/fmLetIe4O5E=;
 b=YHR2XbREB6Pop5gY21WEQi1zykF2Kw74pCOectiX7MPKGjywxAEAOv86w+dmErk1vvyD/wx740MEizliOW4F/OTUzCyqmbj55zf4tdYpgGbCwqIFWI5Q4SkpyQpOp4xhOH+f/oDnqBu0fgQpnLfQkmIQkEUvYRtu3lup8r9aOAAmm1U3H034Mn1TCLqdgWVC6uEpPOvKx91+EF0XrQXoB48FFviW7OMWceFHAOMzttwHfq9WskUOViyZ/BOLrlIHrmCzLSORANWOiiaNNk9iOxcFIVV2vb+MKzRlLyc3bQUuN2jB8i6IEVIJBM+YIZJaL/l8JGwHASxgq1JbUW0FBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PF8xbkF1f29S0Ic+T20p5AQKegZlB38/fmLetIe4O5E=;
 b=U6fKl/9s4pi/IocfMLBUEdLv0LZQd2r+CDzrvocxXrZto+iJ5HWteYAo/SaQrP8swyxPf3NUA7633rb46LadcAGVP1va9wiXmx4hmuyo1uBHLObnSFUYbtK497EqNsC1BYDwxfY2HKArrLod8wkKsR5n41rxYXKMj1wEv6bBmPA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PAVPR08MB9770.eurprd08.prod.outlook.com (2603:10a6:102:31e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 09:23:57 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 09:23:57 +0000
Message-ID: <45f58d3f-ce7e-458f-a986-0de9572c1667@arm.com>
Date: Wed, 6 May 2026 14:53:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 24/54] selftests/mm: hugepage_settings: use unsigned
 long in detect_hugetlb_page_size
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
 <20260428204240.1924129-25-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-25-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0054.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::6) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PAVPR08MB9770:EE_|AMS1EPF0000004B:EE_|PAWPR08MB11488:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d929fa8-f7f9-49c0-8734-08deab515998
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 XuWxdEbf2eklGadKIlSPAsHsF4SfCJLwyaSQdsUR4wgw3mVSWqaKexURct/dVfa/UJYxDV+WYrBxkxt10f8fFngOmneSG0eQD7Vtpvh2frVq9n/+G1hdsu0JY5F94A7CBj3nPj03FWI70PsLBnQxENA/N5kF9fkUk9rzsda/2upWcOUTFR/jG4h4sPAsKbodN0W+DP8yom4Dw1W4oQUi5zZU6lCXSWXzInfK+ZapNiornMEvHs6t4badf96QXHZfSXN/J9tyAa20Gx/DqMcf3hi8Gixvsh/9pXc/wxFPPzt3gD+1YyJwAjaMzCsNlahwEmhBgBY5y78mIlOc/+QY4D9ffmTVFP0Z/bHkq0wZOnjt9x2eUvzbg/8lFgSKTb/C4mDHvuLRgYJJqMpKYHteaZTh5bHetehBUJyF49E8w5OdQwYigvQUrIzcB8yvsFgktLBXpw0q+4gAq073tqo3o/UAGEwXsg1hkx7tsB3K/I1ZrF2hNLL8X1fwj4Z4k+/tnlwyssD924pfjDZbOV/STdj2OgUJV5iOiC65JlHBwTshigy8lSU47CqTA1y8YYocuH9WAs0D3OptDc3X3OHKWktNG0BQ1y3gKAOCUk/LavSUmhcC7Sucg0vNB4TEiZHaBLgiaODNgAY3fGNbs88IymSHHPvx2lI/8W5lYbZpTyfA5GqxVUDjolcSBmtLa41B
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 dEhfrblY7b5YkcYdH0ZhgA7H57nT13eQ/GQE25KVyV0LKxPNYwmKSL/rslV+Gkn+3/L+8jOnleUuChE1MQYmyzn3XHHmc3w+ogl7Eq0KhbnBk4H30QzyLb25hqqagp7gJZvAVFb2+lR1SmQBzLI4jVXO6Nodp2eiB70vwZ55G5DvLQAmiFVEVajSicmgDskOvjYiORdSG1g+Cps1v1Tqkfz/ZaHhwVWVvGYF+0YuKykD/3bJ5skrcjfxcFVO8vdpUeRaehBiFcCQy/stXZvy4R4XUgmh+uiIZ3xKH8ODQl5UhdfIJ75ZHz7GKns0NTgE66soTDRYFFzsAzA6x1answ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9770
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d5c3b6e3-21c2-4f03-f8b3-08deab5132f8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|35042699022|1800799024|36860700016|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GlBnZIIor02hJVgfyLu2+fNDvaegWN4x5F+wfiE5cP0p3ZGZ7/N9tD+jZTDx0wP1QwYajOZc95uoLxst1UbFErehzHFezXp8hqG55rnA60xcUZjEzZAkZVArwDn+/hSLYMSO8x5ajQ3NTMY5wKmlj8PpE9RSgmRvCXI9NHTakX+M68bMrD2GqxOpCYimeOLj/h2KM4MD1jSc2ix+1d7yd633TrFlfnj56G5o2Dv8vepXjS/ueKDyCnFzXIPV5jrjIveU3vwvZ4WJxjtuibjvHW6ov1nmGRiSSR+ni2iz2BALnm7xAbSnoHmbB+kQ/SWgcyT2b3K0rE/wICyj8iQE/DVyl3wD5FIZ5vHmdV7cDW843GL73jJWhPivzd+DRDdYlr19UryEcqXJm24nyEEhB3ZiPzGTz2IVLLKkLkpheK/q/atmUuUDZrt1OvHm1Tq9LE5w0ZLwgvilTNxgloDDSHWAujgyZpvnQtrI2iyLTIFzRg6PzjjVFz9iEoJfOVy3ea1xy1XZ3V1Er48wS2BeCsF7LtTamjT3EMMGKLR1exR2HTuhqCSEWhTf5R0Rpfz1ZXkC9qL+8BCpQe3vAgVqzLCCYqLaQFQONfQQfVQzuOmsRJuQrUKHKNEp4vmy/jU2lZKURowi/eooCSyU29hB+6TZ5TNyuCRRJNpOwLuq+n+60s3b3AhoB7ygPMw/4Mv/YpUuhb82n3OMs7XtqGZL/1YlAz9tHpbwzQC12RaL+ho=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(35042699022)(1800799024)(36860700016)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3eS4wofNqjhEtF2EnkFDdo4SJJnRDeNCmw/uFOjoI3GfbksHZcwitnJltyUJSw6tRqJRMskoSxiHz6vA/Vf7sn/gBho8eFgBwGTWerQtXGkd4n5WdN93WmXTpQ6NsrVfFGxPOcygDUcVnsNMDaBseMwxpN82h52D+P7Z05eSB/hBcgsO3ym9OEjcQLlHPidtqrXpJMyYUnfLdYRwaN+qjGUglrvCv4ChDlcM5EZQwMLq7rOv+lt5ZX9ufpzwkcMW8y2ZNQxsUGV95mMwU/pqXVpg8sCV0OZUcnOdv14dgKgmbPsQ7l3E7ZOdqrQ/Wco9TbjYZDfC/Zl4sF0Mdn5sGfvT/oZZ9rQIS1n4mOeOgLn1amsthBcs4O/H0XJ9m5YfBoPVbs8BCDc0cfVActHJQwTsHhFcnKkK9/bKmraioipzDWZ48fUQlhbRDc+sYjP9
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 09:25:01.6112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d929fa8-f7f9-49c0-8734-08deab515998
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11488
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1ACE08000E
X-Rspam-User: 
X-Stat-Signature: dp6fyhksefojph3sdtsxu9fyt7yd1sft
X-HE-Tag: 1778059507-634628
X-HE-Meta: U2FsdGVkX19ICi7UoC0C8kyv+A5SSxlsHRUHS4HMhM6yHxvae8KtUQKGLhOQrvxD8UBY3xNRxfDvS+3/U9EIPnc5b+GKgUDmW0XQy8o3jo+Oh6TnJotDzh7rIJDgomx0aDKUzKL47IJYlxVX5pSWdbip/8vWt8fPHR0sK+0TTeBUJa/xgQ1+ro9U0yggEYd56w5U01I4ErMCiqZwbK+Z6pLBKPai8onPLT9eqOjCoEKZ1DiuOWULI7NzZUrZ20fpC4KuQTiHny9ZY3pqijfCK4tcu7DJk7T0vSduWe+r2IUJMfZedcXOzF1MwJtMVJtpzM/zs4ZLyZzykIyoztewTnzC19xq4aHGfrTZDuDBVc8EhwgD5c6CTbOgK+Xbqi0LtML2sMYu0QcXaGb96kcTus18Z3fYS61arBi0EZfYy5KrXk19z3015o/O5XdsnxbiGi8+bJY292u5H4SqiGNY2SLE4GWpivXOAAed8Mn96SvjtfC4nhfiM7KuaYCzXjCfwep7E/cnk0OOKvCxzzbNF3dRl3AZm7W5CT5QO3SrzsRHVhMUqNPh4GviLdXPsC1guHJ7XLjJaocELo/ssZjmKr25RIOs52R6wl/CAz+4tC/nJCxBWjEvY9ZYDiWO+JnL79aYTJvyhLHSIvIiuhfJiOSfqzEn6OpMNfl9UFjsJWGZVjac1B4Annt4GzmmzzPkDj3ad68zecKdYTfdYs4hXHonV0NgrH5ogKaAU3JdiyGaupXn+Bq6YwnVNKBWsKVvubq9RIYf0yGrhyfi6Jsm+gsillpLalt6jGGg3OjeK3d5Yzf2gP8Vy+30Xn7DrMYI2pN5e9ocxERW4y6/1NCoTP6bHYqXoFVAKzaiKgPXGa5B+N8ksuyQCXgG/fNcevssuB0vjlgSPBtp/qqsKbPLYUVHFYJfz8wXctz73x+25wp4sObwWuD6nDHdZxGXGwKlYmHdPjfIrV55FWLAI6+
 1N7hhDYW
 CNNdsB2Qv0vjCNzonoa+LWAyxuUB+bUQG6E4a6gWbTrSAdUQ4NQhzE0BxSAjzk4BMgZ8+NJzfln8518KnNRngY/fQLiBPCRNgw4nN/3iHhqC0zoS9sL9Bq4oXXpzcN8L5IkXFimDQt+7svI39ptnblQsV2Wq5oBio0YhSVohlaf+Av5GNEg4/fPbXlxqjaCbgiSE6TKyplLmNMZy87zvyiTWmehUPb8sSBUUR3QNZCzkfpyBUR9rHCCm6qd/DLDsVJBxTGGp81yphW9kNV1HKrhYkwcxshgxD1JWwtayKM4N/YfQsDepRa1h2m/K4LPWSS2/glGqy3Pqt4D50ygrdAUsLGZKOp81HyzzXcwLjpKWhNT6A1eSurL6djNCfvHugp310vrF/ovxYjoHcXX0MUCuX4W+FjdjNaHUEF0M5FX2OCmiG1gBOF0N78/nfLFfCJ1viXVz5Qn3CCcKPl7sT+WFB5FX1yhKDO31KdGI20cOSSiatnThlMrpcSId7ApRDX0s6O3vObedrH1UtVxeeSxjSH3hiiimRvUKaQabHVp0VjYz5RIS0t8RgaLUGkR+86Tb34m4X6GIoKz9oFAD2WyfxPlghWaim6I1HrZ3UIqviwqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> ... instead of size_t to avoid type mismatch in 32 and 64 bit builds.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/hugepage_settings.c | 2 +-
>  tools/testing/selftests/mm/hugepage_settings.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index ebaa621c45c6..8f563315b1fc 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -399,7 +399,7 @@ bool thp_is_enabled(void)
>  	return mode == 1 || mode == 3;
>  }
>  
> -int detect_hugetlb_page_sizes(size_t sizes[], int max)
> +int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
>  {
>  	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
>  	int count = 0;
> diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
> index 320b97e768e8..9357d07e6c1b 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.h
> +++ b/tools/testing/selftests/mm/hugepage_settings.h
> @@ -90,7 +90,7 @@ bool thp_is_enabled(void);
>  
>  /* HugeTLB */
>  
> -int detect_hugetlb_page_sizes(size_t sizes[], int max);
> +int detect_hugetlb_page_sizes(unsigned long sizes[], int max);
>  unsigned long default_huge_page_size(void);
>  unsigned long get_free_hugepages(void);
>  


