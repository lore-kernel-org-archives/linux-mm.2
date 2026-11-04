Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B2B606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 05:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=ALKt7S4I;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=ALKt7S4I
Received: by kanga.kvack.org (Postfix)
	id 6D7626B05B2; Wed,  4 Nov 2026 00:41:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6874C6B05B4; Wed,  4 Nov 2026 00:41:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54DB46B05B5; Wed,  4 Nov 2026 00:41:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 215F76B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:41:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F667160659
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:41:22 +0000 (UTC)
X-FDA: 85396338804.20.9050B17
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011027.outbound.protection.outlook.com [52.101.70.27])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7CA56100004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:41:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ALKt7S4I;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ALKt7S4I;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf14.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.70.27 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793770879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WcQpYwanJ7bUj206eJlqkXYpVnPTFuhjbJjT2AOxBgg=;
	b=0vrg7sI3yITWf31Kg+d/2IxpoJLh+vteRgW+gh4Hl/jKCEgWbd0tkFCmBpuaawIGqwa9GZ
	MLqFu4b9zFQGkNnS/02G0b+b2Pk2QMhzUZk4f2nOwQsu7c9VtZlE02FdBNh/L5pjbYELWM
	/8c/lCeQDX/YJUORaDham5ZA9pmoM38=
ARC-Authentication-Results: i=3;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ALKt7S4I;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ALKt7S4I;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf14.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.70.27 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793770879;
	b=x4WhPkEM2XdicgjBb2+FuJpLyV9kHfEgrbIHJBk5L+MbGIfyBSeOKmSLM1l1WPiqc9ZNwa
	zVeF4Z5Vvcr7IWnyloAyo8sWlAS/kP0Fq8Q9yv8V5HzNeJDsWv4JfYnJBbnLadBVb0N2RF
	vjkPXrAorXgTWtfi9/d4I8BwdTAVa4w=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=T/HwRNwF+ulhrMYY5DZmQz2hbjUP+4qQEYgNC8gma9BgGwijg9QKJMD1To0K/1wcq9bRexCjl/rLrE9eCyBjp+RCfLtQ63Qoa+B0y2w2EKzp/A/1nOih2Be7UdKT5e97sW0NiL8yUAeZCtSS2hJmAmLbrmWx6VMHMhqAiBLzNzcFY3K+uY+f63AUkky+wJmcnfQgmOgtC7fZ3IEpYqhLL9KA7YlWCSwzy0Wc13XDzZjiVafyNYw0qRC7w39nglykEboCyRopyKw9d+SzuiL0LSiIVdLk3qvBuLoZE6bYL0THTFgqRYwOleqPtuvifncs4Ou3+3g8VdHfcWGxodrv8A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcQpYwanJ7bUj206eJlqkXYpVnPTFuhjbJjT2AOxBgg=;
 b=fIiiWGuloBPYpzXt4isDx5prhEMMFeX85ETwWkDWhdrYP5iuQS/FaVMKkcQuNnrxAg0PdgfBZqmauCcYzuT0oLKSUEngUOUhTo0AbfEpXSKZRmUX4vV8rfy4c/3nvz9mDwJ4svfCii8HuJpwt7sB6STeTdkzG5pXDUx9sh4FmHsBlII/czRLtDKQSv3eN7i9jwvYEh1MgdWh+5qAtaTmUVkx8VToLW4vYbyNKZd8y3jcx1QBhCvkjsw0cghX3uXhsQMch25NPjRXfOIohUrmSnCBdzp5JDuEc+at9Vhv1ciPEM0Xb0aAhJgjMqbPFnvyrYlAdoHSADWtpBtoxF5vOA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=toxicpanda.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcQpYwanJ7bUj206eJlqkXYpVnPTFuhjbJjT2AOxBgg=;
 b=ALKt7S4I2E6tFHMBl3oGk94DEVtONSaYIxJHHZULrwU5dyQusxbILGOi2PakAlQeqiNGJtvSZhV0b/g5W0ovWeruhKNQO8bD4CYF9GF9eIjC9NWHtVYcM4hHsus0xeQtIEMibAnH3rrffrVTgZRM0HZXhQ4tEkc9k36ttdLfaDI=
Received: from AS4PR10CA0020.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5d8::10)
 by DB5PR08MB10023.eurprd08.prod.outlook.com (2603:10a6:10:4a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:41:07 +0000
Received: from AM2PEPF00070CF3.eurprd02.prod.outlook.com
 (2603:10a6:20b:5d8:cafe::35) by AS4PR10CA0020.outlook.office365.com
 (2603:10a6:20b:5d8::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:41:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF00070CF3.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.5
 via Frontend Transport; Wed, 4 Nov 2026 05:41:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k7FADICNsRypWSsvv3/pQCQIj0bH1Nr+xVZxo6AGZlwSBPLoTa+WQA33G/3KHXIoQ6LBr9mHpzgh+l6whcEyM6R5WS28h1Bsi33ewlrM8D35LfIds0VfenXl//tyvuOZn2oSpyhSfUfz6/lRNlmyvdxFQCeF+J3LzdRfIOE6w0Q8/dYXh0/oxn0gXW2DczWgDmLnImjcxY3TIo548nzOjezpqB14evZ2oOPXYRJ4+omhdh8pgnWqWyQ1sw0O0Hl+s85m84S2ZWl+71qqbjxzG2TtV8Lryo0I+YXAhcVK5CzZ7R8RYEzSRjjkohaVi/tsdhc0evYiiyN/jLKZtOjtJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcQpYwanJ7bUj206eJlqkXYpVnPTFuhjbJjT2AOxBgg=;
 b=IMmHzKJFxgo06oy1iIqdsuz3EBeOnkTB80UFgeqVOnSzBwf7oV31I2GtAW6F2QlIT6/7Xl1m9D1mRnb51uLw7fJZ4SZxeyyQQzIiCsJF1auaFjR+UY6C2AAF32Cb6sdD6YrxROtP+YMQcWI5yDMDxL7mJVDWD+D7ReiPoRQ/BU7FoXHkGpGHKR+8zgZHZnzmi51Yv63okn1uPdVfc5YD7k+yrzeF1QkIdVzfYGq29TL2qtLI3yvigfRA8/LCUPqkpQCRpaFFREUBJ2rFBWeanGs1KIRUCKeLMVRp742bBEaTcgzUG/Klf38vD4zo1bmGzYBHOuzIf8k3QXFxIubFWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcQpYwanJ7bUj206eJlqkXYpVnPTFuhjbJjT2AOxBgg=;
 b=ALKt7S4I2E6tFHMBl3oGk94DEVtONSaYIxJHHZULrwU5dyQusxbILGOi2PakAlQeqiNGJtvSZhV0b/g5W0ovWeruhKNQO8bD4CYF9GF9eIjC9NWHtVYcM4hHsus0xeQtIEMibAnH3rrffrVTgZRM0HZXhQ4tEkc9k36ttdLfaDI=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB10836.eurprd08.prod.outlook.com
 (2603:10a6:150:155::20) by PAVPR08MB9209.eurprd08.prod.outlook.com
 (2603:10a6:102:30a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Wed, 4 Nov
 2026 05:40:34 +0000
Received: from GVXPR08MB10836.eurprd08.prod.outlook.com
 ([fe80::fcc0:530a:ca06:5038]) by GVXPR08MB10836.eurprd08.prod.outlook.com
 ([fe80::fcc0:530a:ca06:5038%5]) with mapi id 15.21.0569.011; Wed, 4 Nov 2026
 05:40:34 +0000
Message-ID: <e2d956e8-4520-4e84-874f-28b5f0a54882@arm.com>
Date: Wed, 4 Nov 2026 11:10:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] selftests/mm: test mremap() with an old size of 0
To: Josef Bacik <josef@toxicpanda.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
 <20261102-b4-mremap-pre-split-v2-5-d281dd11ad7d@toxicpanda.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261102-b4-mremap-pre-split-v2-5-d281dd11ad7d@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PN4P287CA0107.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:276::10) To GVXPR08MB10836.eurprd08.prod.outlook.com
 (2603:10a6:150:155::20)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB10836:EE_|PAVPR08MB9209:EE_|AM2PEPF00070CF3:EE_|DB5PR08MB10023:EE_
X-MS-Office365-Filtering-Correlation-Id: d529b37d-8d8c-4734-d08b-08df3a363908
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|10070799003|6133799003|10067099003|22082099003|18002099003|261102123227099003|11063799006|4143699003|261026140227099003|261026121527099003|261022105027099003|261022075727099003|261028144727099003|261009223027099003|261021121427099003|261021123027099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 THWcABwJA77viZDNSzPpDCB/r6OvO7CyGE0y2gdjaoLEXn43Zy5JAZqGbtBZwI6SyjTgqsGzI/R2tzl2zBgD5Zpf1S/H43SyUO7Mt5IKXpwe0DEamV5TIN22XD8ITuXLXJOcpStVKuYBwAdYiVASyxthKt2Wc+uZv99Mm9Tf4P9jBzecFlpFpxMFyl0DA6DsU/ExA8qwXb5xjEw71vjiIjrQTP0ntmoidrT3IPrZtzBQ72Ymp3nL4petNbgUrYelV6RIsf4//7nDwJe6Tf+PLiktQbDX226b+icMDtt4/zGMTgYnecAQ1G+bhDzOKZogSMs+hiUT6GDFHCL10WsQ5R6u9g2zVYEs0+sUDndHrYo0e0tclbSGyk7Qo8KqRMYlA+QTG39/UetCkCoZPcaRzfS+uaascQTa2vb1wxW8aYshvj8Wr1iPgtveRZyDQCoZh17C0WFDQu5xYPvYPtrsJlBy0HQ8+D5UmRCv8++p2LQByMfspyeE0Ssp+VdzQdzUiFZ5p227EdTXG7NPJxL5AbB+dbd1vyIyCq2s1qSGSPMShXFpMdylPhnG08RMTGyoi4gQpPPYEUgptd4oxJijvjtLg1A/wst3XJAZQVsSq7w=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB10836.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(10070799003)(6133799003)(10067099003)(22082099003)(18002099003)(261102123227099003)(11063799006)(4143699003)(261026140227099003)(261026121527099003)(261022105027099003)(261022075727099003)(261028144727099003)(261009223027099003)(261021121427099003)(261021123027099003)(56012099006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 CrHd9DsjRE0yjh8hefCDrhSK8m05u9X/CDCaCbRWl7WLh2iv7pHu9Qemdrh6kzHadTICwCVtTfN37e6cjVv7mpY0eyrrU0htSzGgz88thLytODdMR855uWOv/gU2twNrSvg3H0mV3AVG+3AJ/eAqrZUHpqoWsTrLAMUN3RZFNoO4FNBUUMvtl2AgorJ8BpG4AgBTp1XE3nioaF2kUJ4pa6PnfMEobI6WPkIj44TJEGr0rwk/XR5+iimZWX8rUvau9VyVWurICM/sebB8/o7jC9PbPY40dAOAFjWU1vl/lq4X3sgt5+4UDAGwx8EYifFEa03eNNNrk9CKIpyMKKfcQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9209
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF00070CF3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a45c2134-5ff0-472f-b654-08df3a36254d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|23010399003|14060799003|7416014|376014|82310400026|1800799024|261022075727099003|261022105027099003|261021123027099003|261021121427099003|261009223027099003|261028144727099003|261026140227099003|261026121527099003|11063799006|4143699003|10067099003|261102123227099003|6133799003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	WiemUb6nW2cX+YNGw1DnfiDVThiQmjzVmKGNxB12YyUW9HyPj02E07ggbokqoi3okPOcfdu2vX30KngNig/5aicle0WhFPv4KMdeks41J59zLy+f3CSdBaq4pSJZbt6mEWxu1xrXtEEKU72isepELIvpvw9zGrfkZ3/vWdLhkFopyL6wf7zPNnIKbqIkPE4eJE59FY8jzbXj5f+hsRYwQIz6dzDAR9boU3M9DWtgDjP4sAivDOCA1ug7+8g5xdrcdq30Qv4Iro4dMwldq18hzUIl9EpIqN5HX1ziwVLXgjbvieP8FqdWN0Ttl6shxJrPJpK9+OK8Q9e3aozwYQpMt/8azObmY9ORltcsphNvlTh83uPdG0mp+PYZMbtBx+Uu2yothSVBiyYLGLTL4KpGTJkQpsCp3ZBXY1C7fkfnhRGGz9Gql3fv0D87RQ2qVhNEWZxr5Nw4oIFC0cK6PYnAjAPWXMlQ1wXzmM39Y3gXj4Kfly0cHhbCRU4OgkS3dWI2xWzlKG6NcZIalkTSwAc8GtlRMYIhMxmEoImeUWWX6lCMtx+Ot/JfGs7nq/cX2UOuMOMgTHxvqutUN4JfL3pbl/np6ZLcHL/nOndy7gawtL+YfARV02Wnk/yrEh3sC726R89GR1cOdsZAUN9C7j9z8w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(23010399003)(14060799003)(7416014)(376014)(82310400026)(1800799024)(261022075727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261009223027099003)(261028144727099003)(261026140227099003)(261026121527099003)(11063799006)(4143699003)(10067099003)(261102123227099003)(6133799003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YBGPzNwjAkV4HjKB5XStl0zkLtRkqryTtQM3jECUZS61Jg0kWai0/bm9lGev3/jjQJ6w/1s9fn9/oo337aOEBXZptMmzIfWur37X6altxytZPZTtsW2ZDpC5/+m0ufPO3RpCcRhWlnVujE3tJJIffcnytdpXOhWd7zJJH92Wwt96HxhCmo68ags0yBl+ASXBMy4kmLRCfzYsfXI67F3fr2GvTmf1rTjcr8eoRJ6mg0jqYgZFGFyhv9P8lX4oO3lFQmqNRR4Cx9pyfcF+HmCelCZwZ88YG7Dn+9WSQu+U/tf6xEKjS6G4h2FAOzY+PqiBJYXDrCgZQIv8SXGP1A5fExbRo1RljGYpmpPT7LGoPqG/InpBZ3uVp+vCOiblwzij78X/ixpMIM6KJVl4MEuoh/6LR//2+Tf68yz1SAR7zC5HJNnRtGk61i1b+4rt82VI
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:41:06.8443
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d529b37d-8d8c-4734-d08b-08df3a363908
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF00070CF3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10023
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7CA56100004
X-Stat-Signature: j1dmfsg4t4g9u59wedkitz5qm888t9ys
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793770878-238030
X-HE-Meta: U2FsdGVkX19L5gzuTIkSFyy5hjtGfe+WBD7obIMTmRi4v+hzxCwra01FZok/NAm9Yu+SDYj5rnhsXRnglpIW0ZfuZ5h4TsZabQAd4DZC0Vriftr9aXhKCbkfCx6yKqL3N01V+RCq5887e1TmWINdgAlM9hkfD6cKeSk10pXAuUdzuEOE2mB/2TWE+7rua8fNZ0AlNQuNXZsZmDRsoFqKYAMujuikrr3BApFarG7hhD50I9SqjYtSXPLt3wGi7RsppTD2pqx8aDMam2TSnnzsrPezC+7XrwId1GoOl5+nQZqR0p816e85LPEBmGoaIYZapk0D1dDTkdm/l92WBAftjU4cZBoj0SMOLXOfKhPiAa6J6yB4GQU5t5e5tV0NS/DUh6RQaY3ceuBuSup5d8jyx7/lzIUyuHlhkBfkrZYLwRzLzzmljTttHLEG+y4HDxlfJGbNOPctUz8cLt5YNIpdkzrgHJ3quKwtLI9Ypo9vIt7RoqIKVTYhis34Xwe7kMgE+w1E2g+V3ydZaJMFr1ZvwY3cCQG8YIv+bbrFXJpWDoLNHZ2sq6fNKaDBuQ1TR80IVUP+oEVfVzyHSd8AcK78Bc4xbn0SGCMoaxcGCzQZwJVasc/Dz1SxYNNTi0w/SVDxj3S+3Rb4WSjA9RJlMElRLlBtlTr7hSlZv4EysRp0pHxGAkKTSLs06WTvd8LAuwPfbrcRN+bM8SckdoRRvaYxqLj+FxmDso5ae1oUIPrp22gTxctAmKnuxdx9DwLR6KZUGr9Q5t2YNQ5jEgVg0WMaf7I1PRqtByikxa4O8w2FyGb31LTVWOSFeh+7sukO/B0FRELhh7imLRKaMsjUdCyqiuXJQXE6qzt6CHI51aiGiwa/45oz5PeO1zvFU4M0O58pVTFndj39SP2E/ku+4SFc67QA8YSs9/UkdSZsAerRA9ViQXLbZ1G++G7vf/o7Jc//wLE+HKDS1Muj8LvT67A
 qcjOgrUO
 nPDcnn5oFEWPVGeseqnctY5rqQ0Sw7CcLejzAWUiOguMNSX2fO1EAJ8VwmAihpWGUuiiuLATiVs/TJAgWA3xg2WrVTqht19ZVK/nk14Ey5TnT/tTmKw7S9K0l2IZ7dOEY+aJ1tOjfXe0PCLo1Nd/Ikna5IErkh2HggAhulm4BwRXRE4gG2EusXmyBx7M5U3aIOjGwKEMeKuQbTr8Pcby2EM+G1k89heBlSGMv/VzK6oxCzKt/mX7ox50e8n96hHiCrfLhEQu9mvmlVBvk8+W6by1njjFM8BihiqIVEQ+usgZ+spT7eCBXuvEZtwv7GQS3yGGdwHtLtGMXlIMX58MpHMH42dh12wCDaq3zrE0wdPzyn/+vlYjrFv8plsVkVI5F4PhC6W6XuuIcvQ/EVI+lmCRgzzpyD9ZJiHtfy6OkU742jh5ierphlLVDxGwhFzU4y5Vw65jM7+uNBaPGwG1gzgZIeMNL0L8oDtP4LCzOa+GcV5490Kg4tQQQsogsSB1l6t6z6XLEi+Oh7q1MRPYCkLn4Gx2K/+myzS3b86jhjV+RC78tPsWee0oaJNDSL03zuLKljH/6gslejL6s6jX5jmCr2qtvLd26qQeC1YgEdCoS715jqVc/AFh8ncUJ3hsAfuUUy4rUDUR3C14+nN7+udXzyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Josef!

On 11/3/26 5:16 AM, Josef Bacik wrote:
> mremap() with an old size of 0 duplicates a shared mapping, and mremap_te=
st
> has no case for it.
>
> Duplicate a shared anonymous mapping, once from its start and once from t=
he
> middle. Check that the source and the duplicate are mapped by one VMA eac=
h
> and that they show the same pages.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

I have a few nits on this patch. Since it contains some things that my
series [1] is changing, could you fold them in here?

>   tools/testing/selftests/mm/mremap_test.c | 52 +++++++++++++++++++++++++=
++++++-
>   1 file changed, 51 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/sel=
ftests/mm/mremap_test.c
> index 31b484517bda..92960fff9537 100644
> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -603,6 +603,54 @@ static void mremap_shrink_multiple_vmas(unsigned lon=
g page_size,
>                                     inplace ? " [inplace]" : "");
>   }
>
> +/*
> + * An old size of 0 duplicates a shared mapping: the pages show up at a =
second
> + * address, and the mapping they were taken from stays as it is.
> + */
> +static void mremap_duplicate_shared(FILE *maps_fp, unsigned long page_si=
ze,
> +                                 unsigned long offset)
> +{
> +     char *test_name =3D "mremap duplicate shared mapping";
> +     const size_t size =3D 3 * page_size;
> +     const size_t dup_size =3D size - offset;
> +     char *dup =3D MAP_FAILED;
> +     bool success =3D false;
> +     char *ptr;
> +
> +     ptr =3D mmap(NULL, size, PROT_READ | PROT_WRITE,
> +                MAP_SHARED | MAP_ANON, -1, 0);
> +     if (ptr =3D=3D MAP_FAILED) {
> +             perror("mmap");

ksft_perror() here instead of perror().

> +             goto out;
> +     }
> +     memset(ptr, 'a', size);
> +
> +     dup =3D mremap(ptr + offset, 0, dup_size, MREMAP_MAYMOVE);
> +     if (dup =3D=3D MAP_FAILED) {
> +             perror("mremap");

Same here

> +             goto out_unmap;
> +     }
> +
> +     /* Both are mapped, each by a single VMA. */
> +     if (!is_ptr_mapped(maps_fp, ptr, size) ||
> +         !is_ptr_mapped(maps_fp, dup, dup_size))
> +             goto out_unmap;
> +
> +     /* They show the same pages. */
> +     ptr[offset] =3D 'b';
> +     dup[dup_size - 1] =3D 'c';
> +     success =3D dup[0] =3D=3D 'b' && ptr[size - 1] =3D=3D 'c' && ptr[0]=
 !=3D 'c';
> +
> +out_unmap:
> +     if (dup !=3D MAP_FAILED && munmap(dup, dup_size))
> +             perror("munmap dup");
> +     if (munmap(ptr, size))
> +             perror("munmap src");

There's no need to report an error if munmap fails in cleanup.

It could be something like:

        if (dup !=3D MAP_FAILED)
                munmap(dup, dup_size);
        munmap(ptr,size);

> +out:
> +     ksft_test_result(success, "%s%s\n", test_name,
> +                      offset ? " [from the middle]" : "");
> +}
> +
>   static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
>                                           unsigned long page_size,
>                                           bool dont_unmap)
> @@ -1248,7 +1296,7 @@ int main(int argc, char **argv)
>       char *rand_addr;
>       size_t rand_size;
>       int num_expand_tests =3D 2;
> -     int num_misc_tests =3D 9;
> +     int num_misc_tests =3D 11;
>       struct test test_cases[MAX_TEST] =3D {};
>       struct test perf_test_cases[MAX_PERF_TEST];
>       int page_size;
> @@ -1385,6 +1433,8 @@ int main(int argc, char **argv)
>       mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunm=
ap=3D */ false);
>       mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunm=
ap=3D */ true);
>       mremap_move_multi_invalid_vmas(maps_fp, page_size);
> +     mremap_duplicate_shared(maps_fp, page_size, 0);
> +     mremap_duplicate_shared(maps_fp, page_size, page_size);
>
>       fclose(maps_fp);
>
>

[1]
https://lore.kernel.org/all/20261102100211.141831-1-sarthak.sharma@arm.com/
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

