Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBA1C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95086B008A; Wed, 29 Jul 2026 10:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6CA36B0092; Wed, 29 Jul 2026 10:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90E246B00B4; Wed, 29 Jul 2026 10:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD376B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:59:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9E901606A8
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:19:52 +0000 (UTC)
X-FDA: 85041569424.19.CA1F2FD
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011003.outbound.protection.outlook.com [52.101.70.3])
	by imf02.hostedemail.com (Postfix) with ESMTP id BA20680006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:19:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cAKTsYyC;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cAKTsYyC;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf02.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.3 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785323989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tA5hJRs4abyFttA8r2p8mWJ0P+nq4juOy2jNQdd31Zg=;
	b=yGgVwl9Te9YZ5HKH7xgsTViXHESSMtdl1MBMGG3damUTxEWkk65n7p7ME+4xoI6nDNLAMH
	hxZcXYUgxkOgRH7Kf8H27LmPm2Ef/tgdoj/0jgY644bn+qcVR2Vracpcrm70v1C861cmid
	22m0CFNBaBuFer6LcTxuDx2IJaDS24s=
ARC-Authentication-Results: i=3;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cAKTsYyC;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cAKTsYyC;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf02.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.3 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785323989;
	b=zM49W1IDJPJ28I2Z0aI/B/EheqgtqARxI//Rb+UW30gfGE4PtJrGgNiDB2grvatBLyBBOo
	iWprRJkLTety1/W1sXY9RsY5UmnZB4Nxsa8MSsgYL3mVTtJahdZ+VhQlpn3Qeox6S8q+Ru
	XRkH97ZvgXsGoghzX2lEZVY/tnoys+E=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=EmRswu7/9GMDAtAWCFZG/DfOBQkWXg3EVZ+8m+EmimrXMiadZpkQJ2Ldeh8fJ+kJ97fol4S8cImp6R4EEDHNIkzwCtCZ2lgdauL9m0cPB2hwEy3poJo4g6a6L512+gzXJuZPGhMqOuCoxP+QF0bRQYsXVcC0KffdkZWsu7+YTbg+6IYrcCYX0x1VT1Hb0/uqxDt2yoTbqZGgSCbr8ie/UW38ov37OHFw6jmYIVYkkNGk1ty3e6TwRwrfebr/ndaR9QYlBz4I8xwbJYfT7b5t/H9mCkaDUezzuwPYG4Hdr7jhfsd28LN2sAJiOe9kbimKiGkkOwanMbjyJl3AdVaAHg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tA5hJRs4abyFttA8r2p8mWJ0P+nq4juOy2jNQdd31Zg=;
 b=OdIU6VZtJP8f9Dz5dHxUhiSw9lbK67x8qXQzKsJb5ghjOpOAhb3wpQURWagJ8sw5M4Cdw/DUlW3AeJDlRXZpfozHGPk1tIUZW94Ef9Gu1vfKlcfxiUDLvhj3rYiHOj5wGrTq8OHTzQ7MYXuc2R1huCqeB0ctBqhziRFe0TmDzEx6YerJ+AWWjl881Oi85sjAa67XsLjw8NhSmptXD8eCmCCwlr3h/37sCzc7Z+rhtmZnce7jGbQP7cgfaXleUz/l6PCylHL8nWzSE2Zhs7D38jfGnOUV/+U3HTB2BfGcZDKnjFxJA2nS+ZXsp7rb1XHq8iMb4GfxgmXCyTG8ZeVKKg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tA5hJRs4abyFttA8r2p8mWJ0P+nq4juOy2jNQdd31Zg=;
 b=cAKTsYyCJvi89BBRULeNlyaXAT1Du1f1Qs6DT/dj09bCj7hJewETNrAL5z12990CJtchvF0IepKh5JBGoE62p0OTzzybcdfsGohlAN4alOKY64MwjXc2eFSYDAUxG6kpq+MHHbmjdellyj/43eyQz7EfrNqZPMStHi9AGE0wx8I=
Received: from AS4P195CA0013.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5e2::16)
 by VI1PR08MB5486.eurprd08.prod.outlook.com (2603:10a6:803:13b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.13; Wed, 29 Jul
 2026 11:19:43 +0000
Received: from AM3PEPF0000A79B.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e2:cafe::6a) by AS4P195CA0013.outlook.office365.com
 (2603:10a6:20b:5e2::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.13 via Frontend Transport; Wed,
 29 Jul 2026 11:19:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79B.mail.protection.outlook.com (10.167.16.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Wed, 29 Jul 2026 11:19:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q7WgcR/LWYicAKnfCYkqhAxH/8QLhwWt0mBo9r/enBWPPh8QUY8I6bfvwP0ooXxfAkBrQSbgshnUPlyQfmL0RkeZwtW07oE0Ur7V2CQNgOwXxWyeo1On4OoV6NtP3DszGHI351wn4SbdfVrqvrj+49p2jkY/B59p2Hww2Ahs2sASuOh7O86+DLIrWy1kIhwsMd/ydnSkQpCmlgDvVyNb5k5rfxivzX7cV4yMVdKSN+s9g8E1/uhxtbdvrlJmofIweRABWOpvxgHHDUe56Ub0Th4IKLcjF0AEsk7Y0+rh8GNY2YYsbw/esntIL7V0oG6EX8pmbQPqcUw9bOHVyhU5bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tA5hJRs4abyFttA8r2p8mWJ0P+nq4juOy2jNQdd31Zg=;
 b=oP/QWO708nQhTnlTLVvnBqq2WaTsjo/hIzKdmAY+9Q686im03WB0VND2SJVDB6LjRX+SyCismggg3zy9is0fXmKCHI/mUu0Gq6rwUEr4Egb9iLsDIYedG9CZ8iRi7RZpk756Qt1HWjDzEd8TMplKZTmeuVsWl/eNQCkejQAWyjnb8f+LmwTfQiTVl84+67qiB9hkbOnG1WiMHroFhVez5G5PIW5dcgLHUhAcs4JCf2qAnaQX12xB1OIN0920TBSfJl/8qYmdFy1hv5oqzK0MiI7m3Cw659ejtQAikFcBaLSyDmp5WP5XJA7mfMqt7bj8cX/mossPVtZZLsiBQECZ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tA5hJRs4abyFttA8r2p8mWJ0P+nq4juOy2jNQdd31Zg=;
 b=cAKTsYyCJvi89BBRULeNlyaXAT1Du1f1Qs6DT/dj09bCj7hJewETNrAL5z12990CJtchvF0IepKh5JBGoE62p0OTzzybcdfsGohlAN4alOKY64MwjXc2eFSYDAUxG6kpq+MHHbmjdellyj/43eyQz7EfrNqZPMStHi9AGE0wx8I=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by DB4PR08MB7934.eurprd08.prod.outlook.com (2603:10a6:10:37a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 11:18:34 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 11:18:34 +0000
Message-ID: <95aa9672-227d-4b8a-944a-0c2e8ae2a2bf@arm.com>
Date: Wed, 29 Jul 2026 12:18:30 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
 ryan.roberts@arm.com
Subject: Re: [PATCH RFC 00/11] mm: distinguish PTE table storage from PTE
 values
To: "David Hildenbrand (Arm)" <david@kernel.org>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <2c19247e-bee6-45f4-a353-2fcc60db26e6@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <2c19247e-bee6-45f4-a353-2fcc60db26e6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0083.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::16) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|DB4PR08MB7934:EE_|AM3PEPF0000A79B:EE_|VI1PR08MB5486:EE_
X-MS-Office365-Filtering-Correlation-Id: b8cf6adb-c1c6-45a7-a274-08deed634982
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|3023799007|10067099003|11063799006|56012099006|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 27ae1LjLEY50Z5EeRP7Q/q8tSSDc9SWmwFku9CV+TuJxRC/nFYM5Jr4E1CXYMHU/ZDr3iu57/AT8qEOAsb1EoDLYsSCdekLderjOK9ZJWXOkSO96s+IO+/KNnUocpuAwHMM8Tde1g3xTv7C3Cp01lgz70pdGbUL2z0+SP+rYng9orBlFMdwkBrRj8C+zt0LPK1LzZPivrHk8RYzRMoqgbwBDgL8WSAGRRPDpoTrrvoEm8FntMlB0fI9QOeMcTLYZXWCcsQHpSEUrcdCjcEAGNmHhp8cMmhbDOAeNwGoq3dds3VNK08aJWypO/mfWgOpN4tuyC7u/F726D975zInW9Lpjz0GJc0FXFOezWT+4usVgsp1hVFcH/KHWO5SJcQ8eclAvIZWdsS77Fpca7b7bYwxIfQrGc6nBfk0xpUskI7xcF2IR+edx3E/7+nKKSvjJCV+zLeV3Pzums3OlxT0GxIzflSGjn3Q28OTXzcM0FhMiiASmzmFM0LF4U9JzZYOjx6pVLByw7EabVCFj2WltV1Mt6H5tx/sYv6SJ4f4+aWGR6GLCz8qmMyXAq87HK5pYtRSW+n6r2dTTOA7U7t8NP8HLcyw0Vj1lxcVnvGGYBXrFE6YfRPuqm//VQYku3govXRDPbYFujs/waXrR8dLAIQVhoaW0r+BWErgk8mCItDI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(3023799007)(10067099003)(11063799006)(56012099006)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 lV+HJ3ueJ2l5y5elCQJJX+s5SoHR2sZNm8scKNnl+TD7Q58qMBWpAORO2HrVTnB/C5K5/frWnR15M1ITLwnQ3a7O5ttKw2ZxLSh9ScpEM/ahj1HxAdNMUvI4phWkY6C4D06Mzc3MdyMi5g2GvkyjbAgqaK7iVLiOvpKic3k5oHryBCBRH0jbZV8VOgAtomn7bphr9mHvW91DArgzhW3QgnEuQ2CV3bVTfSvCAfInbWAbkJNSfoQV50/apIQzYR1k0k2LRwxJ0UAj8nOXOXZvVcNVX3XHhxgruJrl8/DLtJGJ9lwZ5bVUdcvU7WDHJrWAwV0eTG8oO04qFstnUsQcmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB7934
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3c456dad-cd1f-477b-55a0-08deed6320c9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|1800799024|376014|36860700016|23010399003|14060799003|35042699022|6133799003|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	RK+jlwp17Td3LKdcch5EeA8Flg5eO4o5kcv/QznaPPjesm9xkZhax13vzqqR+z81UlcGsEzoPRsjIdcBI4KotbjjK/+Pr0p1LvKsIJFxKtfT+vsIVhJ0A1kaMqQ3MO0HJ37irayzR0aYNzKjTrt9GBzxJC93Wd+dwAWjnAjoQk/i3YW9yfLNCJ5Y2P+Ssu6rxX3EGtkLTT4unP4ryWgyKEHqvQv+Z9C9lW1ZNI6PjSSmajkug8VZ0C8SHqL9Vyee6l7UwuCCWEsyGTJrbNVI+hx1E1YI5Cbyr2l/MlSrWEbSGV6WmsmvKP8fezVp1x7P5cLFGTka22HpHjSna7nk9fPZG0mNfQwT/B7/OXGp95efLcMnvOfNb5lQhpikeR/pD6FA5F0vOuNhIL6NLp/Elr2zPHCkUdwgjVdaOJZ4pVPf0TmIoLP4OidF1yTKeumFoY3Oc7ldMa7eBvyaLGl9E4lunbdCYQi3vSRJOcfkx4ZjB57RbkaC3OuuPyruIzYz9udkTeBGFlk9Ki0NfTjeYfbO8PemryvhV9sauXJPveFarVbuFrxCy0BFz4FKHt1eBQmR0En5ZM1xOknXBePZPFL3OreKAwwi46JVgCKK58XMlF9fdQG7QC2NlbVFj2MB/BhoD3KH2NFAgNErLSHkQN9YfgJRnQ45/MlmXiIMbIBOrTzr8d27JR71rRp5nR+p9V834gTyklpQn+aYSB1NpA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(1800799024)(376014)(36860700016)(23010399003)(14060799003)(35042699022)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	litdzrqOq8Nxahz/S3FEcPDCCS1sl7CMLd4hW0uuGbAi8HuO53YaqNKhCX32+1AKdRioMNVMCZsjbCg1GVJYDegMs237ON1GpZqjWhC8QV0077B1Yqn4S8DWIwIMoS6+oPmnoAeVoHhW0LUO8m0Qzc4pvY5JaOFA82YClCS9UTC58VIDCqNG4iIlZ9P0Njm0mw3nGiPm/QXms1gpiwJsmDz1pF0d7f6cfe/t7cnEvSawbsqHEao/Xd2qfO15T8b19oBuzhv2NOOvxry8VKJP38uiYTaRVrdmlclY+x27c/9+kEuNvmhrqHxVz9R02z8uC7HvIac5XRKgSvy5YU+N71MVWgm18aMnFxQ262FUnkBvnoPxoPEouRhZVRjpaC2nKZmrI8x9cI4XCzlcwQyIMTtfSHZ2WDj1jAvV6JBlOyw4V24tYk+wMsOWoHT0t5mp
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 11:19:42.3355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8cf6adb-c1c6-45a7-a274-08deed634982
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5486
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA20680006
X-Rspam-User: 
X-Stat-Signature: p6sf9fo5yhdudr5yb6zi9kj8w5r9ixcm
X-HE-Tag: 1785323988-131072
X-HE-Meta: U2FsdGVkX19RM35wJKerqs1pqmvlqghC+g1R6cr2svoTqSu3wsVvlzSJx6J+yxZUpSMCJHvIwtMyQZ2LtDrLdQfcPr2C7Olcf3pjU/oTGra05UAT9vyQjHGmpND+tohvdMB5sMdWBwzZtjNvoGDUyHlcoMuiJ5sLlVFB7Q3MQe5cr5TbjJHtgxmruajOvgbpsWuEUnbeVs6pOip2RDSBFXyNOZexjKEXUTZSlj5Nbb6fGiWeXW4Rd0W8gZsonVYewcEP9AR+dIE72NbIXMXZCPAbEcs8zPBrgWf+X8IiqPLwcTMGiO2qCqOVvMP9q0m2HGi8fUqrwYPcbxDFNdYStfsyMPWmleqP9dWPGcB+44VeHTvgcpgl6QNmURVPP/dOsdKsKopFaHiAtG+cp46l3fYRhJHhSdoehF9M1QjxnTSbS7GVwRAjiTUPYeE0fwD/8ZVFhnuUi3gl98Nhbvp7TYV7wJukt7XhbAt9RH/Dms13tdYG47L5ehJGexZDF0MBcMEgk7wj6y/OMu/1Gh+v7vidrm0wmtRO0VZhuzLQwzhLj2/LjuxaDos6OBoS64i04pWYnrp8pqIJcjt/doUDMwcAO+VibP4I6siStjGPjn7Zm7OvduDsK1YtiaqLBaqfASuESvHiQxTwuGXyRxUwYz20gZsTL51JRa0ukpLs2ZRrowopMaRjkNe3y+xm5V7TSzgvtlz2+xkz+edMVN2MwDrMJseAW+YVUQ0DK8xdJDauhgYYS7EBjiCZcscYx3KNf1iGCp4vByHkgA6ZHp/VDYLODaqXCuOyzw3IWqWK7S+lFcHQhSXtiPjtch6iLCdEIALlS8PoVE1rkZw89zxwFoPtd1Hw1JVKjgtOLpG0/SVInZHyRsce+jwpR3J9BckKnlKZ+Wb4dU1QpkykekPH7gelz/U1aJNXCqVY1+z8unXH2F0QpjoKZBIO1dH2si/JBydYi+7dRWqMdR6wG+i
 trjRn+Y3
 Lt+jzZ8/e6h+dvZ8QOYq+6OaJn+gwWCgNRmm9Ry6cWpOJmTNAv95jF7oAPzfG8zXqHitY+oslbhDN1f0htlbr7VkZ2BZULPV53txHkmJjfWjpk+1Lr877SUkQQdZd8scS4e80TuGvjV6b3bFsPu7nmOqs0k2JyyStP/wWd3MeXNw/9BFjt0bYtRvPrvcL6PgETV2M/lGLM9GUtNCeCfrngOQBufp9AdTPRQuaZZ63tmXYKow4+Nbep4Fc6t6EvLYphwNdbzep8OsOa6a0j+/p6MvOLnir7R2zBntZb0SjJZVEI5FE5WOVzYMJh7r04X5kRbRN0hkvxHvKyz+AotQB1lljOzKZREkCZPDGxN2m0XjIcgzwHM/0dlbbofvzRea1+NhYusCgBGeWG7Dqp7GCYAjtT2uNlTsPx9qTkhh2jzKo8xO6P2VPFQNqh97fl7GWU6GHQ0xwjwYyPpAeZkPFW3QdGjAapiWSY2tNMHuuWQKHMfXquErMEVNXXMp35eHNfqcqE7YwT97ldc8DaYIVIxRUyrWDB/TGKiijVG1rBkEaIyY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28/07/2026 8:26 pm, David Hildenbrand (Arm) wrote:
> On 7/27/26 18:46, Muhammad Usama Anjum wrote:
>> Hi,
>>
>> pte_t currently describes both a logical PTE value and an element stored in
>> a PTE table. Consequently, pte_t * can point either to a standalone value,
>> often a stack copy, or to a PTE-table slot. The compiler cannot distinguish
>> these cases. A value pointer can therefore be passed to an interface that
>> expects table storage, while table storage can be read by direct
>> dereference instead of the architecture accessor.
>>
>> This series begins a staged conversion at the PTE level. It introduces
>> hw_pte_t as the element type for PTE-table storage and converts generic MM
>> to use hw_pte_t *. Logical PTE values remain pte_t. Interfaces that
>> intentionally return a value through pte_t *, such as install_pte, remain
>> value interfaces; the relevant parameters are named ptentp to make that
>> distinction explicit.
>>
>> The generic definition aliases hw_pte_t to pte_t, so this series preserves
>> the representation and behaviour of every architecture. ptep_get() keeps
>> its existing READ_ONCE() semantics and converts the stored element through
>> __pte_from_hw(). An architecture can later define a distinct hw_pte_t and
>> convert its PTE interfaces to make the distinction compiler-enforced.
>> Architecture PTE implementations and most architecture code are
>> deliberately left for those later opt-in conversions.
>>
>> Here, hw_pte_t identifies PTE-table storage rather than table lifetime:
>> complete PTE tables use hw_pte_t whether or not they are currently linked
>> into a page-table hierarchy, while standalone copied values use pte_t. The
>> distinction between complete but unlinked tables and hardware-reachable
>> tables was raised during discussion and remains an important point for
>> review.
>>
>> PMD, PUD, P4D and PGD storage are deliberately out of scope. They can be
>> converted in later series after the PTE boundary is agreed, avoiding the
>> PMD-specific cases that made an all-level conversion difficult to review.
>>
>> Most mechanical pointer conversions were generated with the Coccinelle
>> script included below, then audited and fixed by hand.
>>
>> This series does not add a second ptep_get_once() accessor and does not
>> remove or replace STRICT_MM_TYPECHECKS.
> 
> Do you have a pointer at the arm64 part, so people can get a feeling for how an
> actual hw_pte_t implementation can look like.
I've the patches here [1] for arm64 conversion which I used to find usages
in generic code which I missed during development.

[1] https://github.com/musamaanjum/linux/commits/pte0_arm/

I could have posted these patches alongside the generic conversion. But I
thought it would be best to convert generic side first. Please feel free
to let me know if next series should have arm64 side conversion as well.

-- 
Thanks,
Usama


