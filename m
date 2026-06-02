Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24002CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742FA6B0005; Tue,  2 Jun 2026 11:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719576B0088; Tue,  2 Jun 2026 11:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62FFF6B008C; Tue,  2 Jun 2026 11:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 545386B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:02:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDF121409A9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:02:51 +0000 (UTC)
X-FDA: 84835289742.24.4E1DACB
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010051.outbound.protection.outlook.com [40.93.198.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id E181CC0006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:02:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rFA2qOLm;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780412569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jr1r4vUXZ2xIV63T7aI46rwVUTkG9r3KrlCXoXMHpEE=;
	b=RUztLStG/Xog0GEfyWSQIFojzsVUr/ort9rs3zXW5KRMLJGcjyeGuNTqYa/5kXVGWjctQm
	oqKaolcxWjlus4E8pjg4u+EX7vUwidBgHKT+WRYjKXJOOYPxTX/bOsGZWfd0zzjuM8peH8
	+ZlZ4aZh8F7M0dzPQY9/D2xUvrgDDnM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780412569;
	b=PEhkagYG4Ezdftw1aCKCZGuOYR7BT2wr4AcyTSZqrCEEQCu8yNswg8Au4HLGF8+hv2Cy9k
	1WAVNtGFYgTybgX0p2yEpmep6H8JCtK9pi91GUxDMfICMCEosRpoxfJaWKSJ4tpaoKgxoU
	0ORVw90QwMqJDdaOIRtXpNcw8ZQH28o=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rFA2qOLm;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ibtlaoe8H/AiCNwJFk6OiRsy0vrPYNRM1IOgilzZDCWgCUAL9QmBrVM5ZVG5wjSH0x5hCf5DJnzFZKXz+8D2f1RVC0/B6/9P8C5pUN+M5QkMY5LLD6skVODWbhOKgrzDneSXvf+2eV6JgTtwfS607EIVg1Us8y/KU1YaCZQUyAsMHCdWFhXyh1Q69YRK6cEVRvYCv2GHlqUHLZxXyBQJvskC9BerZwMilwowM1nNjCTWODUPYbyaMvQMQkCnp9zWDbf7o/2P1g7eOv2AtsVHWu4kH/UP8RAZAzniw8W+wW5URapRp0itbqMCcwEYg525cUUYqudH4JCLtaBezCFwlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jr1r4vUXZ2xIV63T7aI46rwVUTkG9r3KrlCXoXMHpEE=;
 b=ecidvm/s25b8ujt6zPnrgLVxjsMMBVnwciUnePJtLF2dr5ZUadqydWSmFwieO+2dnPVArmWlUSpKgeE/tpUSuO5q1Ct3U68zEr7aM7hUGPLxy4JJUNUutsRSE2FLMe6Z20X9eTD+3LnVANj0mt1XPB+syI1TDqM/i6XuTSALJOR8pO5Sc2JYHX7XAikXUemSz43fhv2r6DBH07vBE9yoy/JSq6FLKe7dKYHjyxTI5L7BtiiwIfEOY9lr0D4g9FQ8rtZ35FGqnySdAAnB/ARUUKj6zeAbYRgZe/XxOC8wo5p2NWe5eFAuNiWddhfMgKPs5QL2dqhUky0KGudV0c27uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jr1r4vUXZ2xIV63T7aI46rwVUTkG9r3KrlCXoXMHpEE=;
 b=rFA2qOLmSraBrDMO1DUVIssCxZ8cEy0d1sCHXCwMJqAq9b4ROxptZeHA5xgBhO85A97BdlsoCtUuCOTNiS6raLIOvCb7yXasHrT5m8BzO7YUYpVdzBr6Fevz0XTOmVWzV6J1phDImPDIK0Yhp9Rk0lkh5u1RfSnEDXlKEDn/CxdYpoNtf6J8mxTEgQlP8iW+wkSM/9HPWloLGB6OD0MDraEz/EcG3ismF+oeYqiF9vSk72skXtsBWScYe5uoO2AhXSiknEhZJPCxiP/K54HbypdWf6xHPhD75U1BiHT6oveoIxY6ynt5nyPvV1m6yx8mYPLBI41Dd3j2k5rxF/VIiw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4269.namprd12.prod.outlook.com (2603:10b6:208:1d4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.19; Tue, 2 Jun 2026 15:02:43 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0071.014; Tue, 2 Jun 2026
 15:02:43 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Liu Shixin <liushixin2@huawei.com>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v2] mm: page_isolation: avoid unsafe folio reads while
 scanning compound pages
Date: Tue, 02 Jun 2026 11:02:41 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <34F0943E-4ACD-4655-B9B8-41F658FCDB7E@nvidia.com>
In-Reply-To: <20260602130755.38794-1-kaitao.cheng@linux.dev>
References: <20260602130755.38794-1-kaitao.cheng@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:408:e7::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4269:EE_
X-MS-Office365-Filtering-Correlation-Id: 97d4e2dd-f32c-4eec-8fe8-08dec0b7ffc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099006|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info:
	0e8MbgldGK12WYef8wJRD/LOe/LmF8/HxIxh+TsLVpVuq6e/7Jg0NRXacZZeF3TzcSTUS6wBs9s2skKI4NO1bjgS1QP5qcqztvkzE2D+jqOqq0XmIMmSPlUYPuClaWerm+71gMFsrUrX5Tquh8zO8O60PMPku7GXHn+9GezIW3wg/Lg/JkskmeWIwONCjVUk9jqW2CFWsHA1HjeQGghfYt4Gwrr0MgCxm2gdSnhvIEIOdV6K3I62IBrONRi7gHKvgczNDskORCRBYr9wsCQxNLAmwmV6vI84wgnd/kWoOmLmNYKtEpH8eirOL/SDXn+VecdQyblqg4XfTg60GuQycr9EaFXpxPAl0KkVs/6+RofigbTgC1ryPVM+d8rY3orGnceYqLKybtCcciUMcaS1uZSJgo6qwnELCOz/F7g8dCYLE8uN3zZEbH7CLX+pMK+6z0wmIrwJXlijA2AcmXZSbd6F8TYRExUnqfvjlF3tme9r9D3uUmeAQRCLep2GFwuICQFKMxvoKTltoMDJOR604A9qNB7+RMc+bnT6PipCmSN21n5j2zj6V7t8MyutMBmvP72A9T0VBU9ILkIZ9WJEWEh4P0NENnbGaAvQZDfssmoY2LDyTwhWcNt0l3ai8Nvy6kEe6cJsf7o1u3wjcUH4m1e6B9chCulQ3+8YrHDJqy5MBbjjOX7JQ0WQSdEnLoGK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099006)(6133799003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8e2UsesIoWGwVwiHozWCLZbCWlUBmfnD9cSXPvAsM+iEnIx4M6uH0jBbcH+e?=
 =?us-ascii?Q?v1kVPiNQ9fF0WnNYx4DYh7okYUE/gIFB7QQpmiAiJ902CQ2hn4qshs9h7e6Y?=
 =?us-ascii?Q?he0zFW1LfO6tzywdpksbNDOLqzdyDGIU1Q51WULNFc7UxO+vDmxT94Z6mMjy?=
 =?us-ascii?Q?UR4X/N+dktr0fgTIUWg8nN7U0WBdTDJQkQvjPRczpdgXG2ta2S93SPQCl7fn?=
 =?us-ascii?Q?O1wpuH9C48W1QlTxfnKw8b6IIX64vsmlyaD+XurT0Qkkh8gjUppOahqWR4D4?=
 =?us-ascii?Q?bf/srER1hWxu6/I7MONrwjvKjv2uXiw86c9EXcijSrH8rypOF41EWIcPHGvc?=
 =?us-ascii?Q?AvebcxEsA4e29t3e2w5MoNvns53TXyClfAU8t/9fSlLATrvsp4vUrzj3aTaR?=
 =?us-ascii?Q?HyhvmZuLoVyilVaqg6rML9IJZwAbdoHJLNLy6utSsYxyzZa+tMba387d/erz?=
 =?us-ascii?Q?9a28FT8Ujxph5RCR/09koL4BMFhVgvu/aQyvxmr7rlWdEuTgFmWYUpM6jEOR?=
 =?us-ascii?Q?zUzAVJbaFP/paNfxBywNyI2lD2WY2AT+3h2plg/9nqSgftmzOKN7gCtF/sLL?=
 =?us-ascii?Q?sYiVfD3YRUHJc6BX3Nb2WW0WOxxyhAmAP4762NIg5T5k1SkTTwmXYL316m/C?=
 =?us-ascii?Q?l02Vi3NafcRFNu8JxefKANEhruNQqtyf0mhYpiGQuVON7Y0OVFoSa/pp9TLf?=
 =?us-ascii?Q?LZPZWLdsL67+FCDmv9F+nv7ImPRP1BUqqSkmHxz9zESwYi2NNhAfoiWjOjcy?=
 =?us-ascii?Q?r6RAcLC5oevV6h4/Q6L102klOG7cQt19lvu8wWX6WmZhgkqUw1fuA64evLGk?=
 =?us-ascii?Q?aaEm/q36l2Rsxro6p+6X+JhPJQOcPVy/wm9Gs9dECDOl7Ou5KdKA7YY/3aPK?=
 =?us-ascii?Q?v69Hgs0IshX9CFJEfP3U/cmK8nAT9vqS3XmUXYCzCqPgjeQW+poaNYAbs7a/?=
 =?us-ascii?Q?wiD6iQUpAnhT1gNVAImxpLipQxDn5xNUdvJROOcNQ3xvjF6jtky6BJHp9o/b?=
 =?us-ascii?Q?MBpG6tp9trOe3p9xQPVNLc+rOsA9Y4kDFvUV1BWb5WafQzeQBUMQKAskj+Ln?=
 =?us-ascii?Q?yGIGyCx4/f5KZzmP0Dl9bDhkaX39HpiGtG7usbA2jpc9+B1H7YssES7EOFvt?=
 =?us-ascii?Q?WkdaDAxAVWYd4SUOp9hQK5K5u9vrfcY3rjB9P4g6yltFIY4NKS1R4jlwYzv3?=
 =?us-ascii?Q?sfaFwVM3BCOgswcI3arKvFSPLp7OUnZG/D3IVcTLNlxubu1RTSEEhdy+6VPc?=
 =?us-ascii?Q?SALZZh9UvlvJpZfUVDZL8LEwSZODSqjBOKjlQrsDJKvGiMlm3ypq3qttnHs1?=
 =?us-ascii?Q?biuM4uXSdBuRH6Z/caXMB1+5yA/3w2//M6r/xlYMnjw481XEPDKyp1nTlpFz?=
 =?us-ascii?Q?OpXLu4CI6NkovDNhffhb+ggdc73lzCNPU4Bo95D5N2aTuKIvgzmo+N4WF/j1?=
 =?us-ascii?Q?/Z/PM5bmlBxm4tGFW8bH+NSR4UCUIU65lL8pJxwJEWjhABkTDOZjhmNRkpzK?=
 =?us-ascii?Q?3Wad5Rc9qBTDlGMUqMDvGB9T61zyRSSJr7jC92tJGCOaONig5aV8W1B9cxkG?=
 =?us-ascii?Q?lmMo0gNojEdsUvcXGYL2ou/IbkgGK35fhTpVu+1rpFfaF8KtAepAvns+kVO5?=
 =?us-ascii?Q?3sMkM7vfs5Dslu07pE6T1Opq/BOWwO5r/LUcWxr3MYVhM+nKp3Bmhm95oSVi?=
 =?us-ascii?Q?Ujog09Vcmnle2100Rs3HvFPtrYBf5fSlTtjuyFOq+D/cTzpb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d4e2dd-f32c-4eec-8fe8-08dec0b7ffc4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 15:02:43.8048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Whan/CBGpirc3qOV5UIri1HWeE0EPWkMN6Modfu6heQz/4T4JdEWCBiZu+N5cmjP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4269
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E181CC0006
X-Stat-Signature: jk6x3qsamuxybouej571jxbxko5t1ia3
X-HE-Tag: 1780412568-595171
X-HE-Meta: U2FsdGVkX19F2XKPXGdkQaCMnC//eKlt2MfAzN0TYfPgk1JrKi/VXP/NcgG+il0PH7tXfVE8WSK7zFTz1Z2PNcljeeFy9DoUSwmp3V4jnBdVxdua+dK8guf8JX26KSjPB6pHg0f9SHhPzBHEvPd+dhqHr0nddnrBGiW4X2kswJkuisFbw0mSr5lPjDJIesXdMZzviDrtOBrEMNaV/0Q5NtKWkQSk6OHawPorXKvuhf439nmYADupME51CMnSWeI/xEZfKOj+rGbHHcSSrp6XhkSH8YqW9kqsKCewuiyRUknsbFgWmrPt4g7Q903gB8luzvRKNJt5n1QoM/VhktvqLkVdWeKLBA1MsXvDHGY6F+nCKZosK8hYkHb4xVJUa5eSEN/P8WOP9J/YlGSjLSUVfPs3V0j5fNEJgQsuF1pu/p0Cr7zrKG0XBowEMeO+gHZnODkgOcpt5H+hSB2MDePrvMpZguYPbcW8SSy21mS7wvi/WiQY0C+0neLYGirsZdjz/+HhliZ+Rrb1oQ/aXhzaUnsvd8K003yMx2UaoBfxS7QCERUVspZlKkxqnNbYfIAJLAzanFS0xNE4ul/3Q6TszTKfGQflgYXiX2awbBEeg3KAuE2fqaHAvHDjnaY1B73e4fJMYDYNJyXSZfhoovmsqCNbC1dhfAYlsdWHFIj3f4cWpY/FujdeIyj1eVgfX8KfIyar0xjG9Ufz+0AddnyV8sQSRBxZ8z+2CnCIxju58kCvsl7JKn1TmDkmXuRgZjCPvMLxQM/glASc/I24IoWNAn/38RBy9keqmVtS2tCoYjIsRCtetekA7yjFObJwKv2UESyxdbiAWnCpz5uRlClpS9sEy06XQ4FeznWiY8rg/0nGZqBkepnhQMpiZDPP6+9kaCc2YtAZvrzultDzgRYfhCMQIPFPnPqeHM5rn26RcRUoDTkMRk8dLFr7iP2R7j5KwIGYVXrKZC6rfJl5zzF
 3JBcbxCM
 R9h/7oLXR0Lfd1cLy3U538HPwIFH1qUWgjycQfXWOSuP7rQCw4qEQDw/qx9pION1AqjFfSwJ79tsVMkaVP8zJMdUxFNuVyES+Rkv4oeogwyBKmRZkOhpghMpBwiStUdf9MbhUsD64/btLIl39Q1iN2s+IxAfTlhixSOVp2bFyfoNY1QrGYZdwvYFyUslfdQyoxiNWrZcDgBVp6ElbsZYE2DcL1P66neBxDJbpVI4Y9VYltEX37OrgfHzn9zz5NwBuyjzX5jM+45mDHd6nmuOTxpoB5wSyD9BY1Foh/scMmUJMPseznsOeAtpx2BCC+5SLJFJEqElm+9C4VHkJMm496jKkoLGZF/+RwhgxP14mG+FUpQeagzICFLiwVs9YTc2TF7SmLXMtZzTJmekbmJQJgekIAG4NgxQ7y8ImXfj+oLwm1etPIvdlZBKvkTlZoR8B5sak69SjozxTIKk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Jun 2026, at 9:07, Kaitao Cheng wrote:

> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>
> page_is_unmovable() can inspect compound pages without holding a folio
> reference or any lock. The folio can therefore be freed, split or reuse=
d
> while the scanner is still looking at it.
>
> The existing HugeTLB handling already avoids folio_hstate() for this
> reason, but it still derives the hstate from folio_size() and later
> derives the scan step from folio_nr_pages() and folio_page_idx().
> These helpers rely on the folio still being a valid folio head. If
> the folio changed concurrently, the scanner can read inconsistent folio=

> metadata and compute a wrong step. In the worst case, folio_nr_pages()
> can return 1 for what used to be a tail page and the subtraction from
> folio_page_idx() can underflow.
>
> There is a similar issue for non-Hugetlb compound pages: folio_test_lru=
()
> expects a valid folio. If the previously observed head page has been
> reused as a tail page of another compound page, the folio flag checks
> can trigger VM_BUG_ON_PGFLAGS().
>
> Read the compound order once with compound_order(), reject obviously
> bogus orders, and derive the hstate and scan step from that order
> instead of querying folio size information again. Also use PageLRU(page=
),
> which is safe for the page being scanned, instead of folio_test_lru()
> on a potentially stale folio pointer.
>
> Treat an unknown HugeTLB hstate as unmovable so the scanner does not tr=
y
> to skip over an unstable HugeTLB folio.
>
> Fixes: a0a9f2180b90 ("mm: page_isolation: avoid calling folio_hstate() =
without hugetlb_lock")
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
> Changes in v2:
> - Avoid unsafe folio metadata reads in the unlocked scanner by deriving=

>   the hstate and scan step from compound_order(). (David Hildenbrand,
>   Andrew Morton)
> - Treat invalid compound orders or unknown HugeTLB hstates as unmovable=
=2E
> - Use PageLRU(page) instead of folio_test_lru(folio) to avoid folio fla=
g
>   checks on a stale folio pointer. ()
> - Update the commit log (David Hildenbrand)
>
> Link to v1:
> https://lore.kernel.org/all/20260519121646.40833-1-kaitao.cheng@linux.d=
ev/
>
> ---
>  mm/page_isolation.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index 7a9d631945a3..32ce8a7d9df3 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -41,8 +41,14 @@ bool page_is_unmovable(struct zone *zone, struct pag=
e *page,
>  	 * We need not scan over tail pages because we don't
>  	 * handle each tail page individually in migration.
>  	 */
> -	if (PageHuge(page) || PageCompound(page)) {
> +	if (PageCompound(page)) {
>  		struct folio *folio =3D page_folio(page);
> +		unsigned long nr_pages, pfn;
> +		unsigned int order;
> +
> +		order =3D compound_order(&folio->page);
> +		if (order > MAX_FOLIO_ORDER)
> +			return true;
>
>  		if (folio_test_hugetlb(folio)) {
>  			struct hstate *h;
> @@ -54,15 +60,16 @@ bool page_is_unmovable(struct zone *zone, struct pa=
ge *page,
>  			 * The huge page may be freed so can not
>  			 * use folio_hstate() directly.
>  			 */
> -			h =3D size_to_hstate(folio_size(folio));
> -			if (h && !hugepage_migration_supported(h))
> +			h =3D size_to_hstate(PAGE_SIZE << order);
> +			if (!h || !hugepage_migration_supported(h))
>  				return true;
> -
> -		} else if (!folio_test_lru(folio)) {
> +		} else if (!PageLRU(page)) {
>  			return true;
>  		}
>
> -		*step =3D folio_nr_pages(folio) - folio_page_idx(folio, page);
> +		nr_pages =3D 1UL << order;
> +		pfn =3D page_to_pfn(page);
> +		*step =3D (pfn | (nr_pages - 1)) + 1 - pfn;
>  		return false;
>  	}

LGTM. Thanks.

Just a comment, order can be dropped and use
nr_pages =3D compound_nr(&folio->page) instead:
1. order > MAX_FOLIO_ORDER -> nr_pages > MAX_FOLIO_NR_PAGES
2. PAGE_SIZE << order -> PAGE_SIZE * nr_pages.
But it is not worth a new version.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

