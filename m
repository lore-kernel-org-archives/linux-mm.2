Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3EDB606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uJ2V7Mre
Received: by kanga.kvack.org (Postfix)
	id BF6186B05BC; Tue, 10 Nov 2026 12:08:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE4F6B05BD; Tue, 10 Nov 2026 12:08:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96116B05C3; Tue, 10 Nov 2026 12:08:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B97B6B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:08:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0942B1409FA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:08:00 +0000 (UTC)
X-FDA: 85419841920.21.739E1FE
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011061.outbound.protection.outlook.com [52.101.52.61])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3A066C0011
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:07:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uJ2V7Mre;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794330477;
	b=dUhOaAaJtCmEjDLCziNYVtWrTwwIsjgqLKeMyrGIC1mePLrONiaXGyiNyxPcdtI1xlZscV
	8VybpXrNPaWzJQj/FL8sxXffREBXA65qQ8uIfe9GVbzamjryPKBLNDPl//4qNweix9ioHK
	yzaGGa4q8adCIdyVFtpXTGdgIl3MOrQ=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uJ2V7Mre;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794330477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjfwBwSmtkY9nfGgM0uqUFNDpVYLX8qmebOZlXfwnlc=;
	b=jdZTqKf+teaVWfwbIdwLvsKsPGPG+DCLsyxOQP+tFvC0OkHjLWO5Bt7LG1rEeRm1xWnhYs
	bZhV61Bxqtwbxto0xSPE9UbEdGtVJU6EcUr1Brkf47QFnLU2VQuNDeSXkxnVF5U7/GY7zx
	meCbMP7xvhQqkXTxP+rsSJO2/ypdUQc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pWzip2wHoW6vQO52wcxOp92TaQg4X5egcuGevQn8dbl0Q6CVfaQhvdfuVLW2d6oLDxH9cVxyvDMl/7X4vClFArbDxIfuJKuHCivAfi5P8Qnhks53AaAVqs74ic+knMPjGIDWhcB/OFYm9bckSV5u/8f+P8suqzdYy9DAZX8moyA4trpBiH79+ZFYJxzllKUzYBEfAlbpaXphqZMS3ynExlXCvypr49RctUU9YlNMF7Ykyk3KXWaux9dQx/RcvUHUdUo1G6y0vH7aWEs6FRJGWUuG+ToJIwABuo0DVdrAVnlxJXGe0imGzO5xT3X7Vt7GsohIhzBjBRDIg6GPlKYl3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TjfwBwSmtkY9nfGgM0uqUFNDpVYLX8qmebOZlXfwnlc=;
 b=SEZmsVWDllz3e2iESmNuDuS5EY7MZ8zp3tNk+ITtPUD0XEK/S/87iKfioXZwEF/Qb6z8HlslTgh21TDhiyYh5qjDEvJKfreR8aVo6KCNcKTOgupBR4pma//pMJX1NjC6dbH1lGfP0RP6rweMxlFOQhnafslPQeenQSqAo+1o4q/OpoRj212EcBGFU1tbKR5hSBDcOJBf3YbE1DxTrOduA4xQnKBG7hNcIBEsbp6G/dKhLs+2iXamq8Nwa0UCKMUbI4QQhq0pzJxSQiG/e+rn9WHEZfwh3GxEMvID3EuSh+mX6z4dpbHgZA12R6Es6cG6atfLHkF9QdCMLPGnUaBHBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjfwBwSmtkY9nfGgM0uqUFNDpVYLX8qmebOZlXfwnlc=;
 b=uJ2V7Mre8SuFAxq1GKF1Elew902iW3bbpnOlwXRTZZ2UWeCbo0CifG9pjwFOxHhJbIr+AXLXjvARBSAFdqoxDsMlxroCnMTMIE4NZ/ZMikDShhMtqxLZXYMU5BF70muftSZN8Ad7j4wdfk0j3LcyxoGLBFTYqqrDGMNzs+Y+Ig569M5quDhSTupXs+OMRHqxZ2qkQOWrwkslA7pat1dcj6R7oBWlUUHAWvTctTizKNeLPKA8Vm6o347leMRePn9XQhozPihqs6PjoF9t/+8xkWjMfHCLuLKPURaWgyW+3zpiotAOW/EA+uLj1bmXvhl6KBHY/wwpG4TGi0TyNq6ncQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB8864.namprd12.prod.outlook.com (2603:10b6:208:485::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 17:07:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 17:07:49 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
Date: Tue, 10 Nov 2026 12:07:47 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <B605494D-6ED4-45C1-B618-30458A69C91A@nvidia.com>
In-Reply-To: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0442.namprd03.prod.outlook.com
 (2603:10b6:408:113::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB8864:EE_
X-MS-Office365-Filtering-Correlation-Id: b9a1f30a-dad7-480b-4fdd-08df3f4d262d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|261009223027099003|10067099003|261022105027099003|261026140227099003|261026121527099003|261021123027099003|261028144727099003|261021121427099003|261102123227099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DckJTm7H91DLE2Z+19e7XB4igaH3zpToFD6vAy3qw2VLII/GKTbTYDXdDwhdetXhosyC8dogSaFEs3feUzFvkCjEW/lIBrV2gvcJMSmOf1m4iA4tEgOUAD0qKa0cZa0OLWtsLPMkzTqZNkv4XzCxzm3OiAmbXxmK6VAoSImF89MQN7nWMXw6OTNExSVQgjbudv12KUuaO+ftGWxjaByhvR13f3vO1ojlSJfFiBo7iJo+wN/1HLQAi99z3QT/4XVleflPFLcIRGtXrPwxEynMJDxIJdJR+8tLrIZwmNgN29dUsohvdB0ZS+zTLxSNk1sdgY+eS+ot2T850KXZ8ofTDBXg3kPHzICC4L3fT2bdS7e9XFZfNQVZGtnjnPnnoUuCqUXfYKKILW1YHUfAJnlmw/0SoNmElm+pbnONOC5IEqFJ7/flkBwBbCeEfTkhVyNtUA8kCX6HRIWgOKMF4IaL/GXLPwcYTo3NYxvQrNU7M0yPOBCN6plL3r+p3zH6BQwtxTyJhat9nNz70WCrQvrSLxIVqtl0SMx2O4Ci4oRwMF9ZQoxOjy2RC5vuoiQaPbB3OfMLD63YiQmGyiDL7M6aKNxuLOxnuuS3Xhvgb5VtYxsU13fR70cOBhzk2Zd6IvikJ0duYPiXuFTY4uk3pC5+YbD7crfTG8yoDaQmFnZfQ48=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(261009223027099003)(10067099003)(261022105027099003)(261026140227099003)(261026121527099003)(261021123027099003)(261028144727099003)(261021121427099003)(261102123227099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5uM3i/G/UA2yz17cPFkPEvlnBgpuIij92FmQLx0xxF1NgxzbwtZ/xFnIrzx6?=
 =?us-ascii?Q?jE6/V0yvugKEo5DC79vXFEUmisaQG7ou/OGW0dQr7nf8EsOh29Fe26YGUd93?=
 =?us-ascii?Q?5sip9CnWxPtgbjCvhLXvpV9Z1oq5tvFF6z3TVYKXJQfCpYTHA0Jxz8nH7vvy?=
 =?us-ascii?Q?r0RcDAC/KI6042P1w6/x0iBooTXBKk3Ak9NUEDPRsoWYRv7rSFwxxn6JHq1k?=
 =?us-ascii?Q?7tDoJtydUpp7IIjV6DhcIXSyD9nYi5BmJfUxvyBTNFz9w9iaPCJpSJuI9a7U?=
 =?us-ascii?Q?RSR9awdc54TLSbJqLenyiZoSN4K74ixjkiGK7TNNUYyGB+N7rTu5jWTgfcqL?=
 =?us-ascii?Q?zn5U7/Ez82WhcZgS6sFLM6r6R9kh6pfKsMbi1Os95hNMIp9TuOR0s66OJqTS?=
 =?us-ascii?Q?KMAo2AloQoCq+2dUmk21clghO4V2rMpobIz1VYtysIVCNsuH1jajcmDHndIp?=
 =?us-ascii?Q?YY1WYIZtBjXaZM92PJyyQ1a/I9gx7PSBMBSEGSYdNdleWxyhKhiUPWzCuGzb?=
 =?us-ascii?Q?vQ2yv2jPM93dxJvA7f16l8Bfjc15u4cxLeA4lZ1XHC6H2nf73mock0HaBI4D?=
 =?us-ascii?Q?LHG4wZEtyKa8MzNVH9H6KOrm0/0tMWfW7hpbNpnpTKM/SRXfV4eGJRHxLQIi?=
 =?us-ascii?Q?acdKriqgRIG49Wz9vefxYRJbIH6tDyun0U1zdb2c7GVZU/bDuhFV6tfLx5Z2?=
 =?us-ascii?Q?YmQwlL+BfLc99qM8ENkxndfNNjc9DAzL8gOlrfcPIUxpTvrNlZDnNACXRTLv?=
 =?us-ascii?Q?OjiMiaKPkkmyfgGcFK4/XiiNWypjK6o8LSQrbpJb7jo+NG0VtM1ylTK3ln5D?=
 =?us-ascii?Q?HTygXkekkU12TSWaXMYshz9ruCrrtoBCjfn1R5tY1nlwcrc42RtWojsoWPiC?=
 =?us-ascii?Q?DwgRINEBkRXWYRKX2sLw2Dp/1Hea1aPHS9P7ANZ597qo3R26446MPEGkUlub?=
 =?us-ascii?Q?+KrRBsaeuxiHLr7fkYRglJETCcTe8nHmZdcUo4Kme+NXH9VkRYkfD2X0vVTa?=
 =?us-ascii?Q?tlL255FbxCnBt4xqJ196X+u+tvO5TRD7t1Dif6P1jW0XeoR27ebm5Aav2DPz?=
 =?us-ascii?Q?J+BpPiGgdT9yk83p3euHoULjtnVmMZLT2bJiGbtQxrRNkrb7troxG4aeqwl4?=
 =?us-ascii?Q?o3/BMLQzVaV2P8bIUEHj07I0XOYU1NbC8Ir1KwChiP7wQtIEAL6bf0epMcn9?=
 =?us-ascii?Q?ZRFEKZhrzVFv6azgqppFciX7oPYCjujglQgRCiC+3M5ASlefbY5iujClDAIO?=
 =?us-ascii?Q?15Dy8MEYXj9GrAPRdI7rFBWvGkSxNDEGU8q85ne7E681HUyAYovwrZs7YX2Z?=
 =?us-ascii?Q?vmtXvfYx6dWi1tT2iv8bmXJf78Za2iDlAJ4SOiexviMvCsML6ucqFYv9D5fV?=
 =?us-ascii?Q?X7BxYAAXs0+Vj1C6kOdpPA+KD6MpB90+D6HrYtxojEWj6Nxvmjabi0I6mxIg?=
 =?us-ascii?Q?GqNwjn+BeoyLGj48SsJ/SlPZNzLrYZe6rK/QTVMORWZ8JqaQdPUU1Hvsfne6?=
 =?us-ascii?Q?pzQ1MQVh7pWI8z9d33wepLpDyKd/uORyxZdQJPlV9EPKkNTJED9heke8wn8k?=
 =?us-ascii?Q?HAfdxPg7ZWNUiXnHxgbfqwL+iVYYMQYShvj5QeyjjUiEUZQLTo8iNZyJIq/g?=
 =?us-ascii?Q?3kVLAdjD7HQ6sjo4B6J+pqFM+ZLTNA/y3J+KLr+gNTfjXdkoXvChYgBRhlgP?=
 =?us-ascii?Q?T2CwhXGELeOlz/rBFFY0Ahr5ZZQ/7N9qPct5vhxTZ6AGgq7w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a1f30a-dad7-480b-4fdd-08df3f4d262d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 17:07:49.6525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sV27MXoR67FX9bfhxGF5nxRPnJri23sadE31HTtWZVOgC7dFOkRiDXM+WuoQKame
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8864
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3A066C0011
X-Stat-Signature: 3mwoyws8s9j9t3aef1fgng6m6c331dsa
X-Rspam-User: 
X-HE-Tag: 1794330477-36076
X-HE-Meta: U2FsdGVkX1/7L5mW8yFxfTvILN7bY6weYsm9WM/S/eoVtxA/LuTvcNjNr4zX3Ozvd8GP6MqCFbw7bM44rZT+UB+CLAHuPBbt09adqdfARqPvBXzhClg819BlRV6v+SIoJ4ZpAN3FD1/fqTXFgInyZiWf2kb7hqgHgEU0q6xSRLcPIbSqU+a0sk4Kh9jWf11BqQf1giDN7nApmoh8dyqGJYSPt75BgKmGoBR2Ogzs9ZiNLH3yNUqdbXSXiX6YoyOsjfSgXPdkNOiftfds4083whZIUTGRsQozKEDq+ErOvxhfePAhH697a/n6hZpK/cgBn2HOGCv9JC8+HHt7R/MxGw3JNy1VfIc7Mr5YjWSH7fDBq7w6dcYo633nzswnV9AjbO9Tun4xTbXALyQ7r8ztk+e6plHiUQmyAiXmU+B2pdA5bLD+vnFWLpxb9TZyxhfAYe2l8ZS1MRuWTmZ49JVXQsS0nwGJCAptFVLXGbEWGdqM0btm8lhP3/DgLY6Kcq+ma+/iJKGbgjYOsg2R4255JJJIgr2WwuifosBqyYoPgdlWbbvWdEZEOAtgcWQ8yR3Pl2f0/vY+lRzerXH9qp/cOZYzsMIx5892KcCPsBwE/JrsHQJGT3TNz1pWs+3xIc+xdOgJTbYcKGy/IPhzLZQoUFiDz+wR/VlhnzVa+QdyAi7uMbZAVTQoVLo5EGA2TljAdu+Boe2m715ZkI7OJZ8nZhKm4Q1xqdsHN5ZiIszT74RlOoNL3QMxy8UoPAibRDjEYHHwfxjsx1iBKE+VYlfDjZlrxIY9sRSgce5WhKHq4C6P4yittBR9VieuZWVbLXBeG6giiHA9avUQ5QwVPTvRo4fN06oHfmix3Z6D8BuJEdfTvm5Nj+knzigNu8sonCr8bXFcgZlHKb3B/EDQeji0eSPUarff9iJpHrB34JQWDI5tfe1CqDFjSrBokuisabXA3LYCvmZnZBb37ADaixV
 CCTQkxJX
 q1oDBFWKLrl463dGGm7nmLSQaKBAW0T7Ni+usmzif4soKPZ6v4KC1HE0ggweLI6DxgyDNsnIOTAYo2Fht++5tZnnSMD33xsKf+Dr8UwUATYdmI/3LKYcQbIt8yK2af6M0b/NvIkxFdKbVipgm04vE8qt8dVSzmvqsA5Rmlw/fjryvew2LIFwRQwT2+pIAk1Bt5HkuL11xxlErkqGelJrvdzx5obEQT4ninwzq6l+rw8lzcwWmwmi2V+tG+mYmUvwDmMJKoFtkIwP9TRRJCLIUlXz4VnpoI1em7k0DQBA2fqFKbhvCsMuNWzQbVXUcs4yniwPrL9zzRWgvEzpAgohfgYQOlRwHVly+NN4GSMFoV/xrFCpHGN8F8UWzjUo9Ts9YkK09YRDEcS0RN9heZGirbWoZDy+dSXxAqhUZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10 Nov 2026, at 7:03, Lorenzo Stoakes (ARM) wrote:

> Given the current throughput in the kernel resulting from AI-generated
> series, I unfortunately lack the bandwidth to generally be able to offer
> review except in those areas I maintain.
>
> I have separated the patches into areas maintained by David, Andrew, and
> Alice + Danilo, so each can take the patches relevant to the subsystems,
> for convenience.
>
> Apologies for doing this, but given the current trends I'd like to do
> something to make my inbox a little more manageable :)

Thank you for all your work. Yeah, your inbox size shrinks but is never
going to be empty. ;)

>
> Also add a CREDITS entry for THP, as, since Zi's rightful and well-earned
> appointment as co-maintainer there, I have no fear of needing to step in
> there, and so would like to record my time in that role.

Thank you for the kind words.

Acked-by: Zi Yan <ziy@nvidia.com>

>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Lorenzo Stoakes (ARM) (4):
>       MAINTAINERS: Remove myself from MM core reviewership
>       MAINTAINERS: Remove myself from MM misc, reclaim reviewership
>       MAINTAINERS: Remove myself from MM rust reviewerships
>       CREDITS: add entry for THP maintenance
>
>  CREDITS     | 6 ++++++
>  MAINTAINERS | 5 -----
>  2 files changed, 6 insertions(+), 5 deletions(-)
> ---
> base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9
> change-id: 20261110-drop-reviewerships-264c745b11b5
>


Best Regards,
Yan, Zi

