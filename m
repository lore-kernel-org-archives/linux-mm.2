Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6878AC5CFDB
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3AE6B00A4; Tue, 11 Aug 2026 07:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CBD76B00A5; Tue, 11 Aug 2026 07:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB5A6B00A6; Tue, 11 Aug 2026 07:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20A086B00A4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:26:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A5131403C4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:26:08 +0000 (UTC)
X-FDA: 85088759616.02.F8961F5
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011024.outbound.protection.outlook.com [52.101.70.24])
	by imf04.hostedemail.com (Postfix) with ESMTP id A341A40004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:26:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZDqaLm7g;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZDqaLm7g;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.24 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786447565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Upa8H8lYci2AEeo5pg4WAAxc+FTB6t5I5dTvHmgOG8=;
	b=o0kdfcJ3YihGIVnEqXAzLcELyhj5VcPtEmdDSlkozVvOEpvAy7NOIa4vHxnVuxIJLYZ7/i
	zbxaVGVlyTLzqGV47WFh9MBXPulvgfcVSJmXhCuHhU4jdIr9zZAyrChX+eFTc9S6qG1rQ5
	BKtna9esXBdfUazc5WsQQrfmbLxDqS8=
ARC-Authentication-Results: i=3;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZDqaLm7g;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZDqaLm7g;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.24 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786447565;
	b=FhNDpNYnUKSIrab5GJbqY2TqNphMxyEdX87d1AUencp937jPXs+wxyVgddAgC9RPdNG2xp
	dRfySPAeROt+QNTtdj1KEqo5XKOLq3HFlIX5xEpk2l0QAiSS3Jcj+SiAJlJk2IJMhjmRMt
	bV4Dv9Z6EJoA5q392AN9zHS12rgfClk=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=LR8XLs2K7Av+AN8MFbA38rp+OtYJPybhHowexY5/w4ouSFJJ7P/yP3vj7Cm2IeTMlZUj1pQ0O/2xjCMBBxbLjGLOU55YHqcINNoh6I/SyXT2Vo8NviLhu9ja9UKLZ/MUPzP2Kz1b2WXJPpwW1Fxm68JpYbJBXvmvh3sW1r9D4hLkQDayxSjkruAHPxmAnkffcN1lRWpMdfWrzDgEFtzrarXmMiFXblxTSucUPpQetKHzyHdwmnPeiPOsTpNg73awK3ttMZ8tT/0KkdliCas5KKrRIIfbM4WvDorehZIAmpcMl1cijjZcpJUC9+61eQBB5En17HO8PVWcxM2YYaNCcA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Upa8H8lYci2AEeo5pg4WAAxc+FTB6t5I5dTvHmgOG8=;
 b=arhJojw6f6UGnxzfNGNedm3EQ31RL+LDDUtCFjgoxJgxH0RGYktGR8/+2qcqTfubb1JHgR8nHmVO9oOC4zjDWAJq81J1hXJ8TQRMZU/Xd+qMZVtX6Szi1NvtBpGif7CZRlZt06G5UJU3ijGMpdRGZRgKDjDJjDAV0achaWfQ8bXAMxQICwThYJ6+MhlbSbWpy5cT7ZXJ5iJz8Ql3kzozGUMZcYJbC09tm/1mI8nOia3fX5Ed/jQGw0p6HjBIJhV8g3q2fZIvxwKbDG0HTiroHKak2ZXnLMQ0iNBOJgkEXbBp42CIW9wEmUCx91ZFp/Y5npRVsUrr0W7dnu36MqtQ2A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Upa8H8lYci2AEeo5pg4WAAxc+FTB6t5I5dTvHmgOG8=;
 b=ZDqaLm7gWhUITSg3PvlCRuHDeaF0jtytI9AB0HVCOFjQL41efiVP1AEJKscTP+JFRYc3f4vwBxX6ZAv4Y4PTsCJUFq4gLgyuAFM1k5WCHt84HzI07ZD2DqdbEand2v5A73ThSJ6I32hkVU7sgGurUuuZJ0gjrk4FBCJjr8mRbic=
Received: from AS4P191CA0033.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:657::20)
 by AS2PR08MB8747.eurprd08.prod.outlook.com (2603:10a6:20b:55f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 11:25:57 +0000
Received: from AMS0EPF000001A9.eurprd05.prod.outlook.com
 (2603:10a6:20b:657:cafe::7a) by AS4P191CA0033.outlook.office365.com
 (2603:10a6:20b:657::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Tue,
 11 Aug 2026 11:25:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A9.mail.protection.outlook.com (10.167.16.149) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Tue, 11 Aug 2026 11:25:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rfpSa1oKx33iClOdPa8JCMayv6kb2mS5cLSdASv8gqPN7G9jRNvNZr0BRV4nAn6sr7qPWueIE9ojHmSandXoWV6JVIpWCGw0mabIwDi3hHXaLXz/d09eY9YS/qmXGiad6Nx7LwvsP3kdsAo4tvgS/k3HhLmg2aGodcwlkU1qKK2+WtV5Z5feAlL1aVtakk4g/bMK/rfm4u6YKvP7XXcz9/i8d0vgwi39NfSQ1znyncgm9lObFdDx6hgSgY61WahCZgSNmpzHZZeo5EpCJhHGjpN3AhYm7QSKGEWktVwtPMb8mZ/r7AU9IqrFuiWeqKZGgdDb0JOBgfrWxcD4VVqDPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Upa8H8lYci2AEeo5pg4WAAxc+FTB6t5I5dTvHmgOG8=;
 b=wPp6P2gJ4yNQDU7fWUD1/g6d6JagwvLy15xCBXNctqNPVJNxT71iw0065K7P6c05Yufxg2vVpUuu1t5vH85kR7TRcPvqyfqE4PpXf6TAwLs89iK9hg0BqavgDwN8+AFGzg+osrO2SGItVo/uJYHvmGhmr1GRm5CljI++dqBRw+wB0W+Td9dzJ9gI8qkjy1cSs7hPwJtlQDELDD7lUnOQFut0LFcDCBf3Y/x99uqfZF2ujpT45Smb/nAIPnrxA1r7ex+SOUNkIqhY2cmz+HO2/YWS3qbYInruq9XQi0dBfnhbKn5vsoPQbFeEi7DmozIPRLvwFmokHwABpcYYEaWsiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Upa8H8lYci2AEeo5pg4WAAxc+FTB6t5I5dTvHmgOG8=;
 b=ZDqaLm7gWhUITSg3PvlCRuHDeaF0jtytI9AB0HVCOFjQL41efiVP1AEJKscTP+JFRYc3f4vwBxX6ZAv4Y4PTsCJUFq4gLgyuAFM1k5WCHt84HzI07ZD2DqdbEand2v5A73ThSJ6I32hkVU7sgGurUuuZJ0gjrk4FBCJjr8mRbic=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by GV1PR08MB8033.eurprd08.prod.outlook.com (2603:10a6:150:9a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 11:25:13 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 11:25:11 +0000
Message-ID: <85286df7-363a-4671-bce8-8157ae5c8f02@arm.com>
Date: Tue, 11 Aug 2026 12:25:08 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 2/9] mm: make hw_pte_t visible to generic PTE interfaces
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 David Hildenbrand <david@kernel.org>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-3-usama.anjum@arm.com>
 <7xbai2nyu6nuyr6otqv556dnphpgwaqsmvwkqwoqwbh5nvj3ns@ddy5ezgvb7w3>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <7xbai2nyu6nuyr6otqv556dnphpgwaqsmvwkqwoqwbh5nvj3ns@ddy5ezgvb7w3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0164.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::13) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|GV1PR08MB8033:EE_|AMS0EPF000001A9:EE_|AS2PR08MB8747:EE_
X-MS-Office365-Filtering-Correlation-Id: b28951d4-3669-499f-4352-08def79b5085
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|56012099006|10067099003|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 S6S52yYdxtDtrbu3+R3LqA1hBff1nj/2rLzT9GQ0+Ov8ipkmk0O3mjgrS/DUQ1/AFHfZWm9IZqKqqBU43nupYPXdHctB4A1PEZb9VDmjzZVISz3QfTXgSdr/68htGFhRc/j48gtQ4l6+L4ZW1nZja24rc6nWlSCYCtCWwtrMSs9R7h+dNpcLi2YgHViFI9Py9PcceBHI2y1hbD3tgIm9e45D/TvCqL/DDHF12QMIcti8yIvgdyO09z7AYYF74iZeACzU7uBne+6EXxl5OTZFg6QDzYUP73s7GSAEpT8D0uC32vGvMHjG8m+SK/kgAzP+Nmx82vnMrK3xq8uA+VWijeEIKRH0QxmnSwYsuk1AtsGokPKiK6I6K7ncpwqGz621yibL1B1X/TtMxwipICwYVw/YV+fP2FF6t2BPeh9+LOL+/jJ5P4Q0nEQm8VGkWH7CqIW3RZfdDrfhmWwygRbb4FGuEulKGS0Zb9XSJgqJ/zyiqn5W4UNQbXYIOTge5Vv9t0ogYUJ+UEirnawh/Dtsl7J7crALwP6tP+AkARGX3R1W7ZcuiL99OIu2CO3DNYis4WRH+XIaGeh4GtZWlHcy/Q/iSOzNy8TKPbP6PMGBNW2rO6bfWb0+8p3gurQ1AfDE8vOseTc5WWE/ndAm09GMDOSotmNmMi7644PyBtk9BhE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(56012099006)(10067099003)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 HcK3rNnbwnlUGSwsDidSABGG1HQSoO72TkmhaC28ctmrJg8jVmz1OTzbiHJyHscmR1RSZ/MVJf3UF+V1Dje2C1z7jQczHvpZZk9NqnA1pIaWUyQ0NJGWUP8OQZQ7BxNR+CvvvJU4JV3+pgE+pVX/LgqCg/GXYo9PNipkTyJMz9mRgXBJrvoOJFLveHRnnNj6ydDRiY+xZEs2n9JOMvPO5HLQY82ufTlmcOJ3FL9PskIALGq/04QKaGj1BuKnnTOeCwktvBeWr/VO5+ier2emXtvzMh/0Yd8zfkfTpnuAfv7qGuIggIUVnYNjisH2v/7Pxh+mGQifH9TryIJK1GhcFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8033
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A9.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	eedea4c3-0f48-4936-b2b9-08def79b350b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|35042699022|23010399003|1800799024|82310400026|7416014|376014|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6KeX0Y8hlJ6T8DzdMW1+mLWuzvKwSvsLtVaM1FZSBYQFe2/wJ9AM2jY6ZKYld4Xl2hdLlFmzsPGUB5r4A4gd7B3BDO7zfp+pOAwufqbeXfYmrHSUmyqnHgYGKQTtPxLxVvlkmrZV6SHU2W4jdHN5JitLujQKDD98cTOrNXmnw2rMrGNzhPel/sMCrrxUOwcDyNJzMhjNvTihybUfZEVVS6KX6L7TIuHg6Hrt5ougauduq1FrBUL+6J76wEjtl/xKDnxve5EXBb7d1FXkUSfEgNgAHCwP0vZIRt40S4BHfeSviAlN4pxqH2tUK41SRVj5I7A6f+xUG9WT0yFTvXowhCvXxrlE3eD+2PiLSAOujzLikwzfHMtN9knYkKcDtMFMcq+/iqei+pN0DkXdGTnlV5+aILrwkI5aQvTaP5+NzPWrhEmc3B+TO+4dcPLY1VlERE1j70QDf71kHs4R3st0+eZpsjxeFEOV3sxJo8/V+bdpg8iT81OrvEvWHFyrFBPyta3aIdfh0/WyiKDrN2Lp0d8WTKmHlQFnlvDseOO3dPGPLGROGxMiC/xqCne8h2QWiQKpjdh3pJipAoo3nL0btv/sUspBv1jsoWkKSEk8X3xlhoLcq4AWhm3rWFtoTS3eh1ZCxS7IbIcbzCEVnAAXUrXMliI1AAoko08NSYK6d4Fj3BLijKjNKhwfbDVCGGcgRmz0pcNOwhIIpwUuMdFgsg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(35042699022)(23010399003)(1800799024)(82310400026)(7416014)(376014)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PpJWUGBI0WXngUjmkkmjZ8b9gVABqPlGGdB9in5/n5SVZR/asrpHB7LtoHfG4dL4AjWVyKTXpsEwcsX+jvKJYl51kZwclhNMX8lZECOJjm1ho6qMO3JWlgYLZbH1Fq9uRoCjmRSkf89Wu5QQgQiJQn7NgXUp1gxZDG+bm7d6kU7ubZhtxXLe55hhalbMJFecFRP3KRfX1w+j6xBke2NFN/V2E7odXBw/sjlfrNmeBofeAKv/j7gH42MDjAGWfA8EQwUOF8zhAC42fhaPcfmtjCYKn4wJElqHNc37lF105kHubkPzm7VB2ryGNn/JgYeP0MlcOcYG1Dn5KUpILs7lTmk+Xjb5U9iSSjI4JApKKGTiYPMVqrcCIQYYHQEHa09ZjxJEZjARr7DDEpsYzqGq0xo6ca/UhZFYZtmedtQ2phr8KIsEK0Kbi9zCAxauV+9Z
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 11:25:57.5424
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b28951d4-3669-499f-4352-08def79b5085
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A9.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8747
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A341A40004
X-Stat-Signature: d7i8piccfw84krfw7gm4w9fca3ru9nwo
X-Rspam-User: 
X-HE-Tag: 1786447564-921982
X-HE-Meta: U2FsdGVkX1/l+Tq8iL34Q5CBg8il0LupXUjegCPCOSbOd4ZHrZnyd+n8EIWDnao7dtBDjkqF3Gnua2633mgNNoJgye86VOW/MSaFxma6IO5qsxDTcThsRj4DcB2d58UE9EQ4OdXJDLBFo/0s/IvNpWjhSLhUt5uZ3TY90rh0Cb8YHHRN/W4G5HL6D5MXAxCTtNe4PbOiyoZ57nAFms/J4vP/hZawPGigHbeurtSmoNWxSKY9mgoxSw9PWgo0y8/qmEAcmELbSmcGVgp3lWFw9PlmYam+qnHIVMpSEbbEBOm3gTY4D9RqTPF11xgX3BBNpKAUUbrQhUs8bvd4/WrTyjtXbFmKSYdYvBfLB+tL8af/KHmZls7KRBVUV4WNqe5+Bc3i2/P60DBxWhjA5uChVaxtOv+HDTEJb+tyklTVsFiEd7BLf3uHXsbD4d4cur+Q9pS2CurTchSOukvKvjCFLd7rpfUBFcjCx0hnHaEHx0qJ4M2ZHieSIjz01cPHR8wfoumjQQBNxb95sNpMgl8fDDgWMevJDotsyAtSPMS7D9V+UWvarOr/qTOLWDlP2IDGXuM+Dp73AjoIjwaMlupFUd+tTDzyl4IVodBhzFm+RmEiZn9JQe8+pcgHb/xcY+llvvpES2qrR7kVZ/cp5UrqkDirCJS6RPpicXcSxtkfJJujd7t4qxm06oXBKNmHH03RU4NfulIbBK0DaLih2wXCLXI/y4E9bVkaCr94L9Pf2MgvM6klq0APexi2F5d8fZvhZKsGFv6hhOeyGjjwyDnoixOiOzACLV+ZFqQLfG/eoeMjfcYC+fEdsVF5TqHersin4P41k4FdheTgt0dLpBJnns2Bpfdrtqa39YaLx01bGc7cPfz/QurN9EPnCQvjjv1Nily7cA3SIUoqrvNCJz4Q3MS9/ue/9BhegIKQJT1LBz7AAINGEaMMf/TfLZndi5ynCWV5XwkRzOxJMYTY4Cl
 HwBjhG5o
 1+AqOKoQ4l4D2ise9fbYWZKz+NnjrtwYBZbt+f3HRAB++DD9UE++WcP0BxsIT6VnbVU25HowXlZpBQJs3WK+eYvDLAazX4QJN120ebzoxJOts4Bay0XYSbpFzQ6m7Hfbv1EKvNCb5DB/Vvyov5cdcqVuslS058clRgJvZdLt2GxkFiVsPKQuOanPIXo5q6wCeVKPwRyQLTZ8Bfc1ZD/HFeSug+T8MckJyig9djCb1RTiLpI6oT7U9TyDtzRauRG/rOOd96M+xHTrwU8MVSu7UnIJawsH3d8pXpJzBetB2l0sCWcCFaTGPwdB7nhjPkht/B37Es9MQmLfxE9QoqCYC33pHUsVYAVq14b6yPQlgLRjjTh67F16el/qAvBFnVrcapYjSUQ5dR8DMbTk5E0Z2bcBAIF9xueN1fC413VvQP0f4QJMANCMeuV/iIF+t3nr874NMqZW+tvq+rUxsxh7s5WpYTE43z4gJkEPN4OM5bcmYFLqGb0KzEzyc5s+fodjsbMWRAkq4sHi++lvKI0Ao/b1luys64RH4hvUfTgMPT5Nx+zkAXraD8oy5Mft4rTIeMbhRcHkObnjIsndMWMRC4KAAf4Wh+qcpkXtM2HNiSkZA8iDLl+6RxcWqj8OPq8O7tQ7O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/08/2026 11:15 am, Anshuman Khandual wrote:
> On Thu, Aug 06, 2026 at 09:38:40AM +0100, Muhammad Usama Anjum wrote:
>> Later conversions use hw_pte_t in page-table checking, generic page-table
>> helpers, and vmalloc interfaces. Include linux/pgtable_types.h from the
>> headers that declare those interfaces before changing their types.
>>
>> For vmalloc.h, replace the direct asm/page.h include with
>> linux/pgtable_types.h. The latter includes asm/page.h, so pgprot_t remains
>> available. It also provides either the default alias or the opted-in
>> hw_pte_t wrapper.
> 
> Stand-alone header file updates are not ideal. Why cannot these changes be
> folded in, where hw_pte_t gets used first time ever in the above mentioned
> places.
That's correct. This patch should be merged with the 3/9 patch. But that patch
is already too much big as it was generated with the help of Coccinelle. So I
kept it separate.

Do you still think we should merge it as its a special case?

> 
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since RFC v1:
>> - Clarify that the header provides both generic hw_pte_t definitions.
>> ---
>>  include/linux/page_table_check.h | 2 ++
>>  include/linux/pgtable.h          | 1 +
>>  include/linux/vmalloc.h          | 2 +-
>>  3 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
>> index 12268a32e8be1..12ee6d16ad339 100644
>> --- a/include/linux/page_table_check.h
>> +++ b/include/linux/page_table_check.h
>> @@ -7,6 +7,8 @@
>>  #ifndef __LINUX_PAGE_TABLE_CHECK_H
>>  #define __LINUX_PAGE_TABLE_CHECK_H
>>  
>> +#include <linux/pgtable_types.h>
>> +
>>  #ifdef CONFIG_PAGE_TABLE_CHECK
>>  #include <linux/jump_label.h>
>>  
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 8c093c119e5a8..cf595608cc4c4 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -4,6 +4,7 @@
>>  
>>  #include <linux/pfn.h>
>>  #include <asm/pgtable.h>
>> +#include <linux/pgtable_types.h>
>>  
>>  #define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
>>  #define PUD_ORDER	(PUD_SHIFT - PAGE_SHIFT)
>> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
>> index aed121d729b01..b068e6ade4207 100644
>> --- a/include/linux/vmalloc.h
>> +++ b/include/linux/vmalloc.h
>> @@ -8,7 +8,7 @@
>>  #include <linux/init.h>
>>  #include <linux/list.h>
>>  #include <linux/llist.h>
>> -#include <asm/page.h>		/* pgprot_t */
>> +#include <linux/pgtable_types.h>	/* pgprot_t, hw_pte_t */
>>  #include <linux/rbtree.h>
>>  #include <linux/overflow.h>
>>  
>> -- 
>> 2.47.3
>>

-- 
Thanks,
Usama


