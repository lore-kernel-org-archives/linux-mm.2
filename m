Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B77C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 22:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE5216B0088; Wed, 26 Aug 2026 18:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95936B008A; Wed, 26 Aug 2026 18:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B84F66B008C; Wed, 26 Aug 2026 18:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89C7A6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:17:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6491C01C0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:17:32 +0000 (UTC)
X-FDA: 85144833144.23.FE66712
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012063.outbound.protection.outlook.com [40.107.209.63])
	by imf30.hostedemail.com (Postfix) with ESMTP id B1EDE80004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:17:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="ltjjZ+v/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf30.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.209.63 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787782650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCXjL6wviLhhXmLFX/1ji0v98He7HXMnq3WlETaV1LE=;
	b=SH8SFoynoY4MkbAT8j9XDPaPAxnC5qXDhOr2k1L4PcQD2IbgiNzQjwsiY+gN/VfnL68Wqv
	l+0iSx3mYrb/gDPjDh3UIus83iI1QzXKKEDrEQwRBwcp+6nm1zwDS9+YhpzTgFbUN2Tsko
	8ufqZibcoRERRexQtNYLiZba9KFJNPE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787782650;
	b=LW5FBCeB3JdXC17+Oo5ZHhEE/ThJ+RXAAOfErrnrQcjt73iSWNi2tIkrzlIglWcoQEQqt6
	W8Ry3DvS3P6OYRSuAPDBUYQUA0OKJNcf8hUY4dHlHk0MZgveTNmf+wtPYcsf0BOlVV42O/
	ssEWryZ/v5hlmMGPTt50Gg/edaT/Mgc=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="ltjjZ+v/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf30.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.209.63 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PwSHp7bohqzFyowJKX+2b9FKUPm5KlwYHHxbollJobMhaPrceWaBwqd19KTzwwXlg9yd9osq/YRLtjvBuK/bKShDVb0fCzdhZQd7BLpIIirUZhDCCYFE+mol68eQWpu1zIJW/WF0aNpGoUPM8vS/kMc6avZwjOsDzPOk1O7dhEjuRgugr3QN/leRUuUMJk/ul3nCPi4dmUefv1LyHpfMTO2AYwV8Svg4Cm6KAd+7U8rNJ57gqUFM5Kl1KzHzaUrkRu1GY6r7KKPfYongKC1NaevpXi5LhWVvDZfVmktG8rXNHE0D9A/Eo4NQJ9no9qnX+bcVyIoNsCyhPW+kmp52Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tCXjL6wviLhhXmLFX/1ji0v98He7HXMnq3WlETaV1LE=;
 b=afWGQwZvH4sfDqfirZNx+PRHM23JVlWJTRp2vPTUMKpFOfWcP8alWGGC+rB3Fr5OiOuV19iWGmTOq5OBUcY/RMldRHOolv11DjSh4VFn7/G2x1whv2Iqi0qKkc/wgIjWG71/bKy87Zz2T9wAF2xlQHCjfM1K0Cfc8uWoIaHnd7TN20dXaEXSBsEe9lrnIHbepB5RtuoTVyrb1JLQ29C+CDotheRTYQjduZ92aMdFK6Cv87abT7yc8fTo97EaK/kDr7td1b+8ElJC5saOe3N62J8UygfrpR/nQM+nTQg5I9UvcPMBRUZ0ySBa6Sv47+7B+S5lUNQmjFFR/tS1F2Xkog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 149.199.90.133) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCXjL6wviLhhXmLFX/1ji0v98He7HXMnq3WlETaV1LE=;
 b=ltjjZ+v/Df/OYSwqGQI9u0jB4rRu8gzSnkqlKVycOu68aYrv/Sy8JtYHdx+vfOR9MN7Iwo74iET36q/TQF0Cb3vGai9GwgRsai5vMTa23AR9f8ZASxoEHcsgygZYZST1YasGwYvt4/KjRzOR0aobw7iVKeomynaNdy/x4E/EPUU=
Received: from CH5P221CA0018.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::13)
 by CH1PPFF5B95D789.namprd12.prod.outlook.com (2603:10b6:61f:fc00::62a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Wed, 26 Aug
 2026 22:17:19 +0000
Received: from CH2PEPF00000146.namprd02.prod.outlook.com
 (2603:10b6:610:1f2:cafe::2d) by CH5P221CA0018.outlook.office365.com
 (2603:10b6:610:1f2::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Wed,
 26 Aug 2026 22:17:19 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 149.199.90.133) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 amd.com discourages use of 149.199.90.133 as permitted sender)
Received: from satlexmb07.amd.com (149.199.90.133) by
 CH2PEPF00000146.mail.protection.outlook.com (10.167.244.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Wed, 26 Aug 2026 22:17:19 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 26 Aug
 2026 17:17:16 -0500
Date: Wed, 26 Aug 2026 17:17:01 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, <aik@amd.com>,
	<andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>, <brauner@kernel.org>,
	<chao.p.peng@linux.intel.com>, <david@kernel.org>, <jmattson@google.com>,
	<jthoughton@google.com>, <oupton@kernel.org>, <pankaj.gupta@amd.com>,
	<qperret@google.com>, <rick.p.edgecombe@intel.com>, <rientjes@google.com>,
	<shivankg@amd.com>, <steven.price@arm.com>, <willy@infradead.org>,
	<wyihan@google.com>, <yan.y.zhao@intel.com>, <forkloop@google.com>,
	<pratyush@kernel.org>, <suzuki.poulose@arm.com>, <aneesh.kumar@kernel.org>,
	<liam@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, "Vishal
 Annapurve" <vannapurve@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
	<axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau
	<kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe
	<jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
	<peterx@redhat.com>, <tarunsahu@google.com>, Fuad Tabba
	<fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-coco@lists.linux.dev>
Subject: Re: [PATCH v11 15/46] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
Message-ID: <mtbqvvvpwbzybgy6z47lwui6ag53kyubub3hkczui7u72zxesl@lnwsglrgwl5p>
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
 <20260826-gmem-inplace-conversion-v11-15-0a15d8a799aa@google.com>
 <ao9CKMXAX-hScRSa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ao9CKMXAX-hScRSa@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000146:EE_|CH1PPFF5B95D789:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a271f5a-c65c-4069-01b6-08df03bfcb27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|23010399003|1800799024|82310400026|10067099003|56012099006|4143699003|6133799003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GvbEPnHGbk3m6zx2TFicCQAzZX3vfIV25qhgZIyfzbnmOsVOQ8IWGUsUlVOyBcGmS25efMLqYWgEly7Sp3MyRDlqBlYSehrXvkjyyzDCWeQV3hhO3H3ngOIJkjGqiGOGjS4e3qATv8s0KmDsfFywnm4sCOZZAV5VM9Fk8Tjh6AIudoWI5DjNXIld0DJZWy+JAAPqoVZZGJXjQHKmw+mbM+5EWyVgbLVyyC/Rc+PyaBpVXbBnp4k11s2mGWrZKvs+Kx9JvvfMYYLiUjV13K+nlErfNYSiwj8wrMrUGB0IhGsmfWaWqiSlb0kT44K31KhJHkkD1R6MZNj7rrQU+BftV1ZOC//CJ9rw8PxC0nT5NO9tzw4Fd6bda9I9I1B2TlgbmPE8af5P0QodRTAuwA0mvmEDHY35PTCVBscklO1DOMuJFjY2Qb0kUJcIhWJ4rDU2KohfnslbA5ecLOkRLFg21jWCV8WdEQNqTvgstIni4gXOUfH0QwTTKBxDMQn1adWdppKFhDu/bG6YSRbKE5oJPh/BASh46JZTAB4DeCwr1NjJ7dzDRXUK8oAexhoAag/wbm9kQuxNZRQ+JpEm/GsYMbQBDoOZ4eCStRkAkGamyc34BcoQYMmz7l2SYiavFgtBINikzgmRqqs4hUfnFgBIbxsC4HVrqvOrIkcDdiHK3q59qHnrLhKpDhDTVAt8WbXaTguBpIRMIEJk3lBoaz43zw==
X-Forefront-Antispam-Report:
	CIP:149.199.90.133;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:unknown-90-133.xilinx.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(23010399003)(1800799024)(82310400026)(10067099003)(56012099006)(4143699003)(6133799003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ttyRbOGGvgsMKUmgLArQ39vmk40u9L4bEiphl+3pJZKnFJv0yxOC3phiq/hHz4QlKiUrE4aYSILGSL6aDhpL6kK2S4z5gfAxcO5FyXMFrX1Pyz7KrofbV0AATVOIK0J9DosP6PIbTBhi0s4C3zRRgriMMbPv5jsZBCXfVBbtyrsoPMSYZ9obua0x3mmAQ2jTFx/Io8igr7jmnJ5lA/d2VBPcbTg6LjZXI6pKTOC4vttRb8RF7dudIrb2h/HQeod2tsD88zLNjYRRep+Ay67FcN3JFtjjUm9XUUeMCNTt7GbTAyM3QBXKcmdCiyv0QprCYzasLKV+m2u4bGQYiCeYM/0gAh3oyAmcLrrCSyeDTnU8n0pNgfTbOmLnpJjiJb3rW5yPQ5SbBgp9dFGXe6cqbV30+hd2HjgkZys54APmsuKkQzwnMVBiLD6UJwVBlvAp
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 22:17:19.0694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a271f5a-c65c-4069-01b6-08df03bfcb27
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[149.199.90.133];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000146.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFF5B95D789
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B1EDE80004
X-Stat-Signature: p33my1gw16r3a7rxcufwfk3iduceobhn
X-Rspam-User: 
X-HE-Tag: 1787782649-815405
X-HE-Meta: U2FsdGVkX1+SzJ9P0B2guYxBVG1CnO7hdKKeYhiAB+Bz8UeAqa/nN7F9A1cl+x3rrjNh2mnS4LC+bPs7Bna/OO2uVrMW632gO2FpqVgOCHMeXSURoq7hYXg3eYi3SsPitCMKHHKhb3ixBXnxQ4iZgVIS4Cf4xVJWghNbd3/9PmALGhTqOksS+iSkpvGWTtYBwyhlBjiBU5Yes2JMeBcPWIvDKQ5a0tk5APXY0XG02atZR9Y30CQ80Vi3WRYRFWvmfEGHop0Kim/fl3vJ9rYohmTTNg27mEmmCvBJW+99lfJBhz2yuXejZsYBd8FNysbQHF/8Au0xGyTV2l5JKRKHOizS1dbtfEFWGGQ/ww8FtjOhbW0E7DZbJpDWLDMZfV0kdj2eGlSv+jzdSvQaP1hd+PMJ/PDHovDbmmWkjhHYHv3E6J0StIww/ueUcWKNGIbnA1I/An/hlxO1tNEp0qX5YAC6YbUEuDx8Pm2XYbN61s5lh33peq0n8nr5HHoRFoGgAQuz2fUscYCBq+RlzLOY497tdKHf3s+AE7E24WZ5tQnzw2dRaz0nHM5RXDDrWfo/jm8+diUpBIVwmHwXYG76cLN+XIk9zlQ36uUx8Pp+AXibSlnIRCm7lqAXipAVlIMwnzhg76umFj+K2EMvC2ihwQnvR2cElVx6aa1mrmS+9TbQLl1xxEhbKSOOg86T7Jn7zdHDU7J45vKHgHKr3OJ6Hh6lMbhqBYnkMcLEqvmPwc0N+LTStportVwWRYdl+Ht+HqSJ8wCAiQGKBfuqIn9RdVCxzg8Kzly0ObIexQe8FZhx0unbFV5Yb0NxAK2fnKGUKDhfsgC6v0jYsbSOrM4MGdHxWcDwpjqmt6K9LJTnZgTa4lO9OVmFngNL7oAmMDlk8UzRjZD1xzDV6dBAppzYOJgp3mjc7phMXJ0VPuZfMlr1FAoP9KCgDV8+hD33LICitQFA62Gh+SnPZziy3Du
 dJ6+t4pI
 0nW5HaF4OiRIpFiyuM/ad+F45VlRiMMgo5Vze4HiTX38o6Ieoz8tFrGgQPck5lbI4hug+iMcxKiPnfOB/XYlQJwsxt0tBFjg+KGYPUseQEmOEVtBX3UZ0eCBXwkLkLao3mWGT0LEBvTddFtpzhqn/9fpJclq4qc4tWloULjDeCMlAUGmC98miKTd4D9QWqmuMhJAYw57oxGrQec6hks5gQ27FVwiNHB4hU7AgZ2CK3xxkZ2pIWZ1Rf5CuvyG+uRW3bGf5Iypbep4CrJChXDN0uZz/lrVxagHC0ZST6/TryM18zAbOkloPQ7Nsg+G25Z1X0M41RAHOOd6i2lc6uUmZBPK73RlhQKYwU6Cozvssm9kQdZusfxAfKw0nJHblH9hWAPCkWwb/nRd8xbzG5jVR1PC9er1XUy4DtyOrC67yd9+AKf0JYFQ5ot/z7qmT65KyZ/kY1Zgc8tqNYJWjh/MVMmWGKng3YzFjzzd1VLkdu++peGIsBOCjZxB2DirqPyIqihn0R5ByjvhOkdo8bp/of88BFQXqGDNoSSnscqvNpbtzQo9YrDnuFOvEhUh9T7uvoVMvezhOFuENTSycTVVvY7/yEcVW1GRkczrlJc3z2oi9acrRGeN0C6IcMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 12:44:40PM -0700, Sean Christopherson wrote:
> On Wed, Aug 26, 2026, Ackerley Tng wrote:
> > Omit support for calling the arch hook to make private, since SNP, the only
> > implementer of the arch make-private hook today, would actually prefer
> > making private only just before faulting memory into the NPTs.
> > 
> > Calling the make-private arch hook would require iterating both bindings
> > and the filemap to find the intersection of bindings and allocated
> > folios.
> 
> Why would KVM need to iterate over the bindings?  Only the RMP needs to be updated,
> whether or not the RMP is currently reachable is irrelevant, no?
> 
> Subsequent calls to kvm_arch_gmem_make_private() from kvm_gmem_get_pfn() would be
> superfluous, but that's already possible, e.g. if an NPT mappings is removed for
> whatever reason.
> 
> > On top of that, SNP would need to figure out whether to actually
> > make private based on whether the memory is about to be faulted, or
> > whether it is a conversion.
> 
> This is a non-issue, no?  As above, sev_gmem_make_private() already bails early
> if the page is already assigned in the RMP.
> 
> I don't care terribly about how SNP handles this, but I do want accurate reasoning
> and justification so that if/when we revisit any of this in the future, we can make
> informed decisions.  Because unless I'm missing something, this is an optimization
> choice (eager vs. lazy to-private conversions), not a complexity tradeoff, and it's
> not clear to me how we decided the lazy approach would provide better performance.

I'm not sure it was discussed in this context, but there was some past
discussion around preallocation (i.e. "should we call make-private arch
hooks at allocation time to allow for faster boot for prealloc guests"
and then that ran into the TDX side of things where that would
necessarily entail pre-mapping into the sEPT as well, so
KVM_PRE_FAULT_MEMORY ended up being the interface we adopted for this
purpose.

Since then, KVM_PRE_FAULT_MEMORY was added on the QEMU side and gets
called after all conversions for both SNP/TDX, and even without
preallocation it's a decent performance boost to SNP. If we were to
switch to pre-calling the make-private arch hook then the
KVM_PRE_FAULT_MEMORY call because partly redundant and in practice we'd
probably see a small performance loss.

So there's real performance differences here but it's sort of been
addressed through a solution that offers additional performance
benefits on top so there's no longer as much to be gained here I think.

But I guess that's a moot point...

> 
> > Calling the make-shared arch hook and not the make-private arch hook does
> > leak SNP-specific details into guest_memfd (as in, why only make-shared
> > during conversions but not make-private?), but the additional complexity is
> > not worth taking on until guest_memfd has a user actually requiring an arch
> > make-private call.
> 
> ...
> 
> > +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
> > +{
> > +	struct folio_batch fbatch;
> > +	pgoff_t next = start;
> > +	int i;
> > +
> > +	folio_batch_init(&fbatch);
> > +	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> > +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> > +			struct folio *folio = fbatch.folios[i];
> > +			pgoff_t start_index, end_index;
> > +			kvm_pfn_t start_pfn;
> > +			kvm_pfn_t nr_pages;
> > +
> > +			start_index = max(start, folio->index);
> > +			end_index = min(end, folio_next_index(folio));
> > +			/*
> > +			 * end_index is either in folio or points to
> > +			 * the first page of the next folio. Hence,
> > +			 * all pages in range [start_index, end_index)
> > +			 * are contiguous.
> > +			 */
> > +			start_pfn = folio_file_pfn(folio, start_index);
> > +			nr_pages = end_index - start_index;
> > +
> > +			kvm_arch_gmem_make_shared(start_pfn, nr_pages);
> > +		}
> > +
> > +		folio_batch_release(&fbatch);
> > +		cond_resched();
> > +	}
> > +}
> > +#else
> > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) {}
> > +#endif
> > +
> >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >  				     size_t nr_pages, uint64_t attrs,
> >  				     pgoff_t *err_index)
> > @@ -624,7 +661,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >  
> >  	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
> >  	kvm_gmem_invalidate_start(inode, start, end, filter);
> > +
> > +	if (!to_private && kvm_arch_has_gmem_convert())
> > +		kvm_gmem_make_shared(inode, start, end);
> > +
> >  	mas_store_prealloc(&mas, xa_mk_value(attrs));
> > +
> >  	kvm_gmem_invalidate_end(inode, start, end);
> 
> The real reason I responded...
> 
> Thinking about the Secure AVIC mess made me realize zapping NPTs for SNP VMs isn't
> strictly necessary in this path.  The PFN isn't changing, just the attributes, and
> that's (obviously) tracked in the RMP.  KVM doesn't need to zap SPTEs to induce a
> fault, because the mismatched C-bit vs. RMP status will cause an #NPF(RMP), and
> AFAICT kvm_mmu_page_fault() will do the right thing.  A misbehaving guest could
> continue to access the shared data (assuming we stick with lazy conversions), but
> that should be fine?  E.g. it's not really any different than implicit conversions.

I think this should work in theory...

zapping NPTs means the vCPUs will keep retrying until they get the page first
vCPU that faulted is trying to grab from gmem. If we don't zap, then they will
instead be racing with the first vCPU, and if they lose they will be
generating implicit page faults that trigger conversions back to shared,
and most likely the first vCPU will re-trigger an implicit shared->private
conversion when it does PVALIDATE. Worst case, the guest fails PVALIDATE
due to racing with itself.

It's a bit chaotic, but it shouldn't break anything other than the guest, and
it's only something we'd generally expect for buggy/malicious guests anyway.

However...

> 
> In other words, couldn't we do this (as an on-top optimization)?  The only wrinkle
> I can think of is that it could delay reconstituion of a hugepage, especially if
> we opted for eager conversion (because the guest wouldn't hit #NPFs to trigger the
> hugepage promotion).
> 
> diff --git arch/x86/kvm/mmu/mmu.c arch/x86/kvm/mmu/mmu.c
> index 62f751952ad8..61f3e270ab61 100644
> --- arch/x86/kvm/mmu/mmu.c
> +++ arch/x86/kvm/mmu/mmu.c
> @@ -1670,6 +1670,7 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
>  
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
> +       unsigned long shared_private =  KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
>         bool flush = false;
>  
>         /*
> @@ -1683,6 +1684,10 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>         lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
>                             lockdep_is_held(&kvm->slots_lock));
>  
> +       if (gmem_in_place_conversion && !kvm_has_mirrored_tdp(kvm) &&
> +           ((range->attr_filter & shared_private) != shared_private))
> +               return false;
> +

This path would also trigger for hole-punching, where we would want to
zap the NPT entries. So we might need to adjust the logic for more than
just shared vs. private to account for that.

-Mike

>         if (kvm_memslots_have_rmaps(kvm))
>                 flush = __kvm_rmap_zap_gfn_range(kvm, range->slot,
>                                                  range->start, range->end,

