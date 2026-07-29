Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34825C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 17:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BCC6B00A0; Wed, 29 Jul 2026 13:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73DD6B00A3; Wed, 29 Jul 2026 13:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14A26B00A9; Wed, 29 Jul 2026 13:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EEB56B00A0
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:04:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06A1414021B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:04:36 +0000 (UTC)
X-FDA: 85042438152.21.9914D51
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013037.outbound.protection.outlook.com [52.101.72.37])
	by imf01.hostedemail.com (Postfix) with ESMTP id C25794000C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:04:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=BncRAtb1;
	dkim=pass header.d=arm.com header.s=selector1 header.b=BncRAtb1;
	spf=pass (imf01.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.72.37 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785344672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PbbUS/qk5aVVW1vC8+CkjZ6Px4apThCtOkwiM7lkMQk=;
	b=HZTEwQuFE5av+6B7S4UnPqc64e3bSed/reS6PljQTu4SPV7JN1fzKyh+FnZ9N6/Y0lLeZb
	C+9NLzv61bLDpYCIGu8IFByYEeZxZrXbtR3H624lID5bcLa3BPXoPfGbiMBrv7wU8YAg+e
	bBXBps+yqsktgi9qKHBQtuHmbnMdedI=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785344672;
	b=4UP0XWSvf41UhrlyHxOq7mVy/1P+OZFoV+WKiCAeVZa2YIcO/nfSod/aHJDgSSJz1LHOl8
	r3MKk3y2daW/0Jq79fKGrlyRNZT1WBECorVLiQyJvNWlP6HzbKu226IgmNRR4fI+o6rtm2
	6/N1C4iM7nxjONu/uOh8OjwZGG3G82o=
ARC-Authentication-Results: i=3;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=BncRAtb1;
	dkim=pass header.d=arm.com header.s=selector1 header.b=BncRAtb1;
	spf=pass (imf01.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.72.37 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NmDnOTYzQKdlDmLOueJT/hHtzqxVh0I5we3J8aFCT9jDLn7+8+Uoz3cigQWlTpBx5HRs0yoyCS0cXNQMW50t5S+56L4G1khCVHdVW5/21N3OH4gA5AbC1RDP2llHU0XtYVqTwgutaE+qjwPxaTn10YQ7cAFR8DVcwc0tV2jQj8NfOWJwjOB6Dt3XNcy5mCdMnFfP8ugQu+zrP5xHDauzCjQKztHztHCCBU9OO8Ovcp5X6NXIWW8QafVsgo5TBMfdogfDi6fV9UIudfea6F25DIzVWXH6guGZCAzVgcwjPwWZqc9B1KxZxUXOb+xJg7rRKCatCxfQ0D9KJAgskwfU9w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbbUS/qk5aVVW1vC8+CkjZ6Px4apThCtOkwiM7lkMQk=;
 b=f2xFDZA3UPyvngFDD/STe3RXTpQOVspNn6JE3vNWTs8noJ4YKFe4YahPycpku7fPOHenG/nbqRyV8v81tkdRERUZWu9JsegXS4p44Wv8M4swK6BF4Mwvp3Y8sjuE6/7AoOXqie97R2VMcMYoxs7aDP40KO/uCPdvHRfff+pHJYeuY3sQyRlpya6r3Vu7k0iiX7upBpdyu93ZjCoHvi6TdUh6cFmyC6dd/b8Cu/9XqWFZlKd4uvmAqCUfVtEEn+1GGdyaredG5JwYwKkRB2FhWD5c7y3DiwQ6+YQZLmEoAh4qp6x5GxWcKGwTLFxwyaKBGJ0IGfMqLLQuKeQMRqaqRg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=suse.de smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbbUS/qk5aVVW1vC8+CkjZ6Px4apThCtOkwiM7lkMQk=;
 b=BncRAtb1wxWuxlYq3hw2v/M+04GjdKg+y4JuhjiTTj6i7XFl/6Jgw2fj+4b0moZKpngDIgLO6TQajpcJFf7aQKeCWM0Dyr1FxXKWsS/BxLIciiQgFsBGYHYVGXc59i+87QMOgh3eg+DLAUo73vT/abtt5OLSRIIXj/lENHQ9qeY=
Received: from DU7PR01CA0023.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::20) by DU4PR08MB11101.eurprd08.prod.outlook.com
 (2603:10a6:10:576::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 17:04:26 +0000
Received: from DU6PEPF0000A7E1.eurprd02.prod.outlook.com
 (2603:10a6:10:50f:cafe::36) by DU7PR01CA0023.outlook.office365.com
 (2603:10a6:10:50f::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Wed,
 29 Jul 2026 17:04:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E1.mail.protection.outlook.com (10.167.8.40) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5 via
 Frontend Transport; Wed, 29 Jul 2026 17:04:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xahEWMRLnwid9CUeH2xMEOsP0mG5mVIig03K9CrPeXgnE2GOpBr+kyZG+F2d35nN7dR9xvnXrP7djuCDDm0yGzzPCPLmwN9HVJRprqNsY1afrMOM76IATPc6Bx7cxzusYrxGi0huWmRQGSfB0QfwawPJIKbKFggt3SIihvOynDbEk3eLLBRhW2rqGskNlTyPWDq8w218z4dshXjQG7JrtiCZb8UUmiCp9IeCf02pp5vMYisEfl/Fqb9WAWkRqg1ftPnNj9ppDIsf9Q6yGfC8fiNJoUKPfwXfvqkzxfOvFUxsmrsXu6aIvBBVboUs/a/ltqbKrpSiLr2Tbuo+ui5Ynw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbbUS/qk5aVVW1vC8+CkjZ6Px4apThCtOkwiM7lkMQk=;
 b=O/164cDNkIYfZ57+OU0eVLSYvhlM5ZSK1fDakvR237cxTdJV425e5h40oM0+vWNWTYYZbjS2OvWO1AwvWygrxMBzG+ve9IVN63Qhel7K8uGgreqLZI/laB970xYq/Xnv3k6qIohwLrGyn85FCaC0O5tBWx1IcDyuQtd4HwwoU0YnPOX9oqrN4gFotW/HHWygtNEzbgx7cniww0Dz6kHuixHYY1RiZxaM3z4S5QTYNUjH6fy5mvJNpJuQ6fgPcNbXpY5xk2fXVvexrXE7I9tC2S7p7aDARcljsa4nhrjA8kxpcNWfdxBXYzmwgly8WQqD4llBzx2j+05RCCurppSevQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbbUS/qk5aVVW1vC8+CkjZ6Px4apThCtOkwiM7lkMQk=;
 b=BncRAtb1wxWuxlYq3hw2v/M+04GjdKg+y4JuhjiTTj6i7XFl/6Jgw2fj+4b0moZKpngDIgLO6TQajpcJFf7aQKeCWM0Dyr1FxXKWsS/BxLIciiQgFsBGYHYVGXc59i+87QMOgh3eg+DLAUo73vT/abtt5OLSRIIXj/lENHQ9qeY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by FRRPR08MB11966.eurprd08.prod.outlook.com (2603:10a6:d10:1d0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 17:03:24 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 17:03:23 +0000
Message-ID: <e0f68f91-629a-4aa7-bad9-11ef7dafce4d@arm.com>
Date: Wed, 29 Jul 2026 18:03:19 +0100
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
 David Hildenbrand <david@kernel.org>,
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
 ziy@nvidia.com, agordeev@linux.ibm.com, ryan.roberts@arm.com,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH RFC 09/11] misc/sgi-gru: use ptep_get() for page-table
 reads
To: Pedro Falcato <pfalcato@suse.de>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-10-usama.anjum@arm.com>
 <amnxCmFU40QQaxTx@pedro-suse.lan>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <amnxCmFU40QQaxTx@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0023.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::15) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|FRRPR08MB11966:EE_|DU6PEPF0000A7E1:EE_|DU4PR08MB11101:EE_
X-MS-Office365-Filtering-Correlation-Id: 37141c21-a2fe-40d9-70d3-08deed937228
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|4143699003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 DaJWhsTZTSxcIZbwinfD8XxtPw/2f++czvjbD1W4bd4XreSaU6D3188u9w9GWQdT1JXBI8k6WeoGO6ebdA1+x5ERQkgaS+IvsRPUFarLXoyLSoHZCSpfHIwd8F8MDWoNeQ1ES6E/mzkjlk9uqRqSUEnOeLxSkLZi6rsNJwpm6ua931PyYrgJVmT6wev4vTkMgr6syRqwCjlvl016KdBkPiyWoyKxZXNeor7nen405U+6SC5mEjJpEHoT80H3kzt3gxPjjZbNpd4hPE5DyqouQQ/VsqiaVT4B5FfF36BO841Sp/Xl1P8QhSFShghy3xRKonzeQ6A/ywt8H9Xc7keLkphSLfy4PtFSq3IQ9cNDuKln6Hvy3wazEyx/gr/sfCYkTZxE2WgTQ2sOWSeZfWA0h0Bs//n0R4D2bofUttfS5x1z/oSEZO66wztXTfYvOjSF4x+5WgQMtt44LAKW9yT0uqPjlfJb31GONqzqwi6bX+GqpqX9cYgrlXmoVI+N1K5HndLAeojNGxA1aOc+48bNI+LQ644ttsRtlgno3Kz2zTeOy2B2aSZkC+ecrjfht61nUE2Ky3+IWsStwYWvifvhWPtHsv2iZXgW/f3/PHUR8FXVam5L1/5xsQl5FIGgf0hMGGNYQ2A4WaTk1Pb40YB1BVCnjNZIvY4oAW6YwLT8GW4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(4143699003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 ZiugpGqFJussUsX96Dr0qNIxsdKxjJBS2tE8DuDcDfFRexZmwdjfLQBMcHCaqX8OW1QUx7kPU5UoDm0xLd+5To+L1Lwby9UJzIjM7tj6tA5Gw+zuycwLiOY/6k46sQqIznBHfE1A0FGGTlp4WsiYDINkUezqpj2bXuRimKRIR8fvUQKmBSt1LLeBmJQ2za0zrmj0rciHYG5LhQEQzEyqn2YhvwKI5abL5D/+qqH+vCRW9DPPMD/dKpxd8el7hfi9uzaC51A5QUOe3GYui2sBAzf/m04Y5tcPJZU+DTlZbZmqZ/j2M/F5BLeLb4tlW6TNh/xL4+oFjqd9nq4+N9gbjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRRPR08MB11966
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E1.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e588c869-dbac-40f5-682d-08deed934bdf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|14060799003|7416014|376014|23010399003|82310400026|36860700016|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HZfv24VYe2JXYJAVJ8cbRwULxYvRmalqgSIXDe+knxEVlgHAPn9PPAf7kwpuL2ydxaiYsToXHlAkBS0LLuUKzr6nueoTKcHRPlCscEzoHwtnrm4ZNVHtjxcwYzGoB6WAVI4gTES5V6J9EmIBlLY8NSIIYlR8LmBLgDduZZojsn+7VGMv7irEFiSoEgoIAhiOGx5pJrJIxWMbpEsQoep7yRtrOVB9UJg5KewP/dARA0RQGrt0A0kuGvyrcTGbBDC83rHvkS5JNzq+Jh1T8z3Gnhkw8OBdxHzf06nkf73xC1WRYuetSD4Udb4jIKKNhY3KOh8F7iVmr9ateNzuV50BamA/dLDrabuDQvoZyLW4tgArGvIEj3wdiHMvJspE45X9YANv0OxzY6PSOipCQuXD4P3Qn+u79XXXVBP11nQYW4IO5mvrftVB5S4tKrUbL7U7vzxw8w3umcj58TMkUsPeihGI1QKx+laLMHAa/Rwne4jdaktvund2DCX129NZoR3GCYwuC0waE384Cdv1hdOJ6hcZ8QG5n/r98HfJH0AyUtF4cfDzPNAsT09pGrBHIuawEEhqXQ60Oq/8yzx1Ct7mWTUqwfnvM9qo1upZXE0DB3U+ZiABJdnAWT8TdsY2JJd/QnUo8SJQDgaGtdLRRT4HWxxHDS9jzq7ugfLO2LwIS66DeqnLIHFjboOHcRlllKB148X/q0MFK/9a6Ce3Nsb8hQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(14060799003)(7416014)(376014)(23010399003)(82310400026)(36860700016)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rVI+erN+tDK1bV2DaYVwEmRJDr4VXLVJC5i79Kwb6sY1tPpWPXDqyUvP/xGW2XsYbrI+7Wwi2BotLdlKPoK9b3n/U3Xl2foE2DFyjt+FCP46rO0Amkyn6h47Sgz2sqnuHI9loq0WbH19gPc+hxNxudzSfRRHOUW6vYyByqqbsq61kJzPy1RIjrjh8haoNQr5uUiQDCN518XDGA85hrv+CaQkKIj5ON3Q/fosJjMkX4lA5OU6W2iHLJUjz7wGYwts8jKk8vVybK+CL9aPF2+mNnzVXByXoH8iSxQIR6UShOdPnVt8EAtAyhS4LbxwtwTMnJNVVJO8nLEOf1Cz0eeIlyRjIO6c33byzt2IWrDNksjzAFpYRANtjC9ItlXIYppOcCXRWmciPDCiIDth7BHg5Vafj95ym4Z+Bs5+vT7lY8fwr4K4ZhzRH7o9McHNO91R
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 17:04:26.3745
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37141c21-a2fe-40d9-70d3-08deed937228
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E1.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11101
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C25794000C
X-Stat-Signature: w7j6s3ttsmnppffztxhuoahpm4uqu4qc
X-Rspam-User: 
X-HE-Tag: 1785344671-638665
X-HE-Meta: U2FsdGVkX1+j4IrdIljJ0xx6MrwfTpjMbULQmdQssQmGeJhARxUdwmfOh0Pld5CGAFdZC6d3rwueTJ1RA1Nszz4/LfyH5Nnm+XxAu615ggQY2A3StGh4b+/pfPtqVQ6B0a8VO/UsrGf3KKXGAvVa21Ryr2PDOyaUwJX6S82+JSRx9+TKEOY4JIX7FhC9ffuHuC5eSJRQzsV6KKOW2NRMQy0nuX2zHYMgOOZ2gKxLU2NdoZJxGVeRLXEnawF33ctMk20KznanGKvErRreQ8KLmnly2Z2tO+E1YXDtxXF9iPxl9fvj461cGIFxUv2L5uOrpjFHy0437gBNttXSpETj5o0y0f0yAMsQNXDJCe5FBkCOMsqWdDvQAD57qpMpRAmHNZG1pwdPHucG1AvSgqvvod2nCpgY7wv6sercXVeNYo/aItVNJ6iDEoMM4QkvBghAftMYyCXv+/tIkQB2inuIZkm7C3bD1miulNbw1p6AT5gUTdJQMRiEU3BpZPI3TrwQJikbDvYaGV2iL9TtppneEwTyylWj07khr5bMk0OJ27zQkXMERE+XyVKzVqRm0RJKNiCkZMxQb9RpN2u2VnKNq7qNj//naODGVVJ8SW8m2yBqkzVeIIYbh60ohDVdt+uS55EbOU7bDetXyHR9FVdbnKG2xVLaWYUDgGlGZd8uJWZTSS5cK8cJ4cs586Z531AjLFxPv2jiOZu6wXtW9wL58pGJtrCQc6ZAkHp3UK4Ewfy1gm6l5q1Q5P98vo6exNJqLIIZz8j23acSo7U24Lbqdj202yPtsRfDFh54G2NGFQp/2SpAYNyorxh08jGqJcyW2XtKaF5zIt9+CMaylpaHrdtTMV5HNM3gScY1qUnBdIPyCWiC/rc/W1HG+j+8bdwpJWEWv+9BrX4fdU7Fx212xKFJjTXoDjAw3cLBYVRUyOfhvfm4pSV+1GR5LefF+pFJxMm4/KJzUUKxkeLt9x6
 V+R+UrRq
 xcrdninUU3GbQ5vuRDWn+SMJzQo4TZkbYfE41zRCIwxAbbUBUkT8AtO5E/WySWgD9fm2kKnyw6jecE47b/21sqvJsOh5qn/mjhYp/objDMhldCcTLytkbImkkWvn1+c+cQOTLBStytd+AjqWUJUkjEOEefSeypFMnMbvzuNr98Q2vVuQwf3b1PAKgIWWIZPgqSjaFsjYB3Ati0OpdNktWO9+KkJ1ycAy4nMpt9ND9iwW+P3PjHCrqhPybPbSVN0FwHzY7Z+OqJoxgtZsuTE+At4BjA0PqJdhT53YlGfa+tgUyZkT6mNs53dSYzO5rQnUpGbLz5Ga2RwoxRxzzu+jivZO1k2AXEdvoJzQZKmCB784jOQbZBChbpquLl3K0JIFQ9aHKwVWm0DygDP8hI4PTfZCyg5FRCfiUJ/U2Rv/yd1sEWF3CnPU3Nnl+jRTPmaP9OGXOP2pTcxM+MeOftfbA7XPDYqMmYdPWpzkNpi9RTJSGfwHbgE09q1aM+MycgP93QcSPFBroAJfunkYlPqeUf2jhjA5RJlWKEGX1p7sZPVv9i+WOqeUmGJyH1KKb4OMgTyzCYVuN2lFXPruiS4ShikQggRqpIb5CLk06b/l/x+p6hxkEfG7Y8HsI23g2zdsXgSRj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/07/2026 1:36 pm, Pedro Falcato wrote:
> On Mon, Jul 27, 2026 at 05:47:00PM +0100, Muhammad Usama Anjum wrote:
>> A leaf PMD is being read through ptep_get() by treating the PMD address
>> as PTE-sized table storage. ptep_get() now accepts hw_pte_t *, so update
>> the cast accordingly.
>>
>> pte_offset_kernel() also returns hw_pte_t *. Get pte_t value by calling
>> ptep_get().
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  drivers/misc/sgi-gru/grufault.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
>> index 3557d78ee47a2..ff89d34ad2aa4 100644
>> --- a/drivers/misc/sgi-gru/grufault.c
>> +++ b/drivers/misc/sgi-gru/grufault.c
>> @@ -228,10 +228,10 @@ static int atomic_pte_lookup(struct vm_area_struct *vma, unsigned long vaddr,
>>  		goto err;
>>  #ifdef CONFIG_X86_64
>>  	if (unlikely(pmd_leaf(*pmdp)))
>> -		pte = ptep_get((pte_t *)pmdp);
>> +		pte = ptep_get((hw_pte_t *)pmdp);
>>  	else
>>  #endif
>> -		pte = *pte_offset_kernel(pmdp, vaddr);
>> +		pte = ptep_get(pte_offset_kernel(pmdp, vaddr));
>>  
>>  	if (unlikely(!pte_present(pte) ||
>>  		     (write && (!pte_write(pte) || !pte_dirty(pte)))))
> 
> This code is super, super broken. Can we remove this ASAP? For starters,
> we're using is_vm_hugetlb_page() to detect page shift, the code does not
> grab refs on the pages, uses pte_offset_kernel() on user page tables,
> does not handle PUD-level hugepages, does not handle PMD-level hugepages on !x86_64,
> does not hold page table locks nor check for pte table retraction, etc
> 
> I don't think I need to go on.
This and parisc both have dead code. I'll send separate patches to remove
dead code.

-- 
Thanks,
Usama


