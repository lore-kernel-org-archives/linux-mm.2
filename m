Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76CBB606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=codasip.com header.i=@codasip.com header.a=rsa-sha256 header.s=selector1 header.b=MxKrXeO0
Received: by kanga.kvack.org (Postfix)
	id 794C76B05BA; Mon,  2 Nov 2026 04:14:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745936B05BB; Mon,  2 Nov 2026 04:14:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D416B05BC; Mon,  2 Nov 2026 04:14:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F91D6B05BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:14:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C5F01C460D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:14:28 +0000 (UTC)
X-FDA: 85389618216.21.6E367C4
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023135.outbound.protection.outlook.com [40.107.159.135])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2B68E20009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:14:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=MxKrXeO0;
	spf=pass (imf13.hostedemail.com: domain of florian.schmaus@codasip.com designates 40.107.159.135 as permitted sender) smtp.mailfrom=florian.schmaus@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793610865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nnHRvqaJk71jOU8RlMHhwlCr51KFTPsjIznwGDn90eA=;
	b=miozncgCOAK+EXU4JiJUamKh1CaBT2fq47IpLob6LLHVt0RgWhFymQpos8zOdmvBsM2Avc
	BFlmXLbF7+BNo3WgdawyapbJL/HNu7hW439MsaKroZYj2935DSxNfFx3TJGnZ/TOP7/b9z
	xNDQzCfrh/Nc1ROz+F6/QqXD3EF8RwY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793610865;
	b=MDxA/xVaW3PiH5YVZFJTHkd9A0k8RL7rUvtNYuFrGZDqV/MvbvYDxS1jseDMdYFUbOuwHC
	4cFGZC5zVFlO6j5sQsl3a0rIOnq55Ss1S+G4RQTDtREgcFqUqPmge+Ja7VQcZMeNjNNMsV
	kAZiTBKbEFLqXzrMt/SD8rHyeTAl2n4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=MxKrXeO0;
	spf=pass (imf13.hostedemail.com: domain of florian.schmaus@codasip.com designates 40.107.159.135 as permitted sender) smtp.mailfrom=florian.schmaus@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ixHUGWGsXPL20dbgYOodBf72Pl8jtT9+UkeD5ARzgjCu+LqkGl7lN/huP0pe37LEC6ROxq6KH1I9eUl4zOUK92bGuxIAGo/oOfAoSi51kOxrPhoUWKEQWgM9KzPX69RXarf2t7HqTvHN9a/QSzO0URnxcn9J35bmGXJrBRzWFYK87SNZkm5Iu4/2ms3Xw05xLjTYgxKan6OMymJdkLBp9bWk0sO2IWpEVuyzVFQoyKqREioGtdcZJE/2hmEYgOfl6+/iZzFiou37U7L7cwI5PGlE9rb8vB2JjnC08KtRxHd2yF07+xRUUQ3GJYgBiC2ChL4A8QIcbEUMvQb8ttOLYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nnHRvqaJk71jOU8RlMHhwlCr51KFTPsjIznwGDn90eA=;
 b=Q9AiIMjP6Tx8+zKgG8H9Fmp8oT4xwl2CKC2Bw4/198elTHDOV5xrZrzlQz2uwdM9tahkbt3t5lWwVrFkcytKP/XRRq90ktS7mxKQPhpKhq4In5FcTzpc0SxKAM36pFIGxSUdo3QKYds0mSVzf86Onq1VFx2+SFrFRxkxvTn5fSRFSF+iEmYh+URitVG8f2tk43oJBK/RktZXbUdJOtG22qIFxzMsCz5izRv68a33qOddr8V7cRwcofISQn8AzZQ+MkfszRUIknbswFsESPmuX18f3Sc7n/wpmDMHIyL8iwgL3q6WDlqcM3YZCDTo8Ua9psVRksY256pOxpNgjVqTzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=codasip.com; dmarc=pass action=none header.from=codasip.com;
 dkim=pass header.d=codasip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codasip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nnHRvqaJk71jOU8RlMHhwlCr51KFTPsjIznwGDn90eA=;
 b=MxKrXeO0FLh5YCcS1RCNAbomHT6VLyzr+ZR+V+q4GGHHnOhIwQCst8jQH3Czirk4+jJr0JAmg7Gk+7VzGq5cw9UrtYDYwNCAjhaSMtt4wPwtNymucrIcJ7h2nsFp+DLyPiJclWTTTP3q8sGogu6fdEHIC0UQI08Px5e6Tw2lHd+RlCV6g7CBSsB81FXNzzZr3vHuvflqw7bmNC+sSEYCdUKzUo+5aBzq2QyXQVxEgiVVOgRwNpaRIwY4di5mjIUi9MLZf53FH9D7FJ6hLmguwVfaTV/E4rJsZs6zcLCCdMQRh/wA2dVBLiXZipTeQbACLXAWsaXB6heFU08g2NfhxQ==
Received: from AM9P192MB0983.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:1f4::5)
 by DB9P192MB2500.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:5c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 09:14:18 +0000
Received: from AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 ([fe80::f0e5:8465:302:9a9c]) by AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 ([fe80::f0e5:8465:302:9a9c%4]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 09:14:17 +0000
From: Florian Schmaus <florian.schmaus@codasip.com>
Date: Mon, 02 Nov 2026 10:14:10 +0100
Subject: [PATCH v2] test_maple_tree: test maple_range_64 node below the
 root in RCU mode
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-maple-tree-fix-slab-corruption-v2-1-d0037f04ecd6@codasip.com>
X-B4-Tracking: v=1; b=H4sIAGFU6GoC/42OTQ6CMBBGr0K6dkynCggr72FYlHaQGqBNW4iGc
 HcLXsDlS973s7JA3lBgdbYyT4sJxk4JxCljqpfTk8DoxExwUSDHHEbpBoLoiaAzbwiDbEFZ72c
 XUxQ0dry65QI15iyVOE9JOwYezY/D3L5Ixb11N3oTovWf48GCu/f32ILAAQuuq7IrL/yq7spqG
 Yw7KzuyZtu2L8xBt3LgAAAA
X-Change-ID: 20261015-maple-tree-fix-slab-corruption-d1f098521d15
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>
Cc: Dimitris Charisis <dchar@cslab.ece.ntua.gr>, 
 linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, Florian Schmaus <florian.schmaus@codasip.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3480;
 i=florian.schmaus@codasip.com; h=from:subject:message-id;
 bh=UPMTX8FAZNy5Ih1PQTbeava2ZUO8sm0V4vW7JpUQsyQ=;
 b=owGbwMvMwMWoZLn8xddWhSDG02pJDFkvQjI4OfcXi55XmKsxL9mHf0cef2ZJ67ad7rfveK163
 2ei8a+uk3E9CwMjF8NMMUWW6aWs860U7zzMfvJ7HcwgViaQKdIiDQxAwMLAl5uYV2qkY6Rnqm2o
 Zwhk6BjFQ+T0GDQyi4tLU4t00wqKHPLySxJLMvPzivXyC1LzCtIL9NIy00oyMvKLilOBRujlpZZ
 YmpubGphauhk7Ghm6OLsamjm5mrg5OboaGRlbOpq7WriZWpgaGZgaMXBxCsBcc3YW+/+aUO4Poo
 ua/kSdfvk199uJ8Al+S9SnL/nLt/XTylJZ1biXxs8FeotOTtC4u2yS4lVP8V9hrnNqY82PHe188
 vznH/YNPyNyzdaG8bFmmsVmhfqcmLeQZ/4Pee9nm8xOXFLK+Di3yk5OeIabwCqGw8/ajtmpMq6a
 ONH/4HL3TR2bJ74Uu/z+6JYd15/Xv2DZ6pP0mNX1X/o2meVrGRwsF09ZO01v7j9bw/P2hfHlV5P
 jdzs9Fq568q3ySr7YvNAXuq+fqF10DUg9cXv+cvnaBYHsNx54pm+f3SeknifMscrLzXbbWZ3YkK
 CWJWeKbk3gd55l68Ggcj4gKcPlQNbs+EJ9F97P8kmXtZrk37On6pUBAA==
X-Developer-Key: i=florian.schmaus@codasip.com; a=openpgp;
 fpr=1357B01865B2503C18453D208CAC2A9678548E35
X-ClientProxiedBy: FR4P281CA0209.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::8) To AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:1f4::5)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9P192MB0983:EE_|DB9P192MB2500:EE_
X-MS-Office365-Filtering-Correlation-Id: 55cbe5ab-150f-4fde-b3e7-08df38c1abfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|1800799024|366016|23010399003|6133799003|10067099003|18002099003|56012099006|261022105027099003|261022075727099003|261026140227099003|261009223027099003|261028144727099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	pWV08I3EbNz3O904wDEvgXI3VJ7UpoioxxB9PfW6y1KKpsYiBDaVLu1daSRZM7KF4XtWlrQLaxDxBNOmqdBgrOj5XjzGbHcUVbOAbNTLxUHQkqSlf0CNVaczaUc+acRsHTpMPy6L+KxrpsEJgThyQk9qASnLHmphkcxgiEnpEq+Oa2yPLbmJaU5l6DEwo2jdb69VzOI6tOwnCUedIuvtbcVgeVJv8IlhX51qGCmZRpOy+qk4bVRp3jKzUQRMbt0YmZIpmnVOsgaNSr8o/q54H0oWtjwwAisdGhuyKDGv1dyGh2pOjn3uxQ82Gt57TmKDUZamM5SRHaGbP8Bl5KBN7Cs94NfadA3IpgdLeaPVwm1IU6uqJyD3tbx/KDhgc8eYKV2iNn3iacjCyV5t0WGY/PA1tdbEwOhcHolCJunRShijhfWz7buZNdQLTkp8zRNAjOdwuwpqnyW+DPC5iVKtS2XxhqsiDSIullLMoQhQ+x927XEcOCAhE3A/q/xHP2ScZzyjVegt+13Ohz83iEhTolupJ2zVKu4BiMvExDSIJNRjM6nWwg+Hi+ZrkP9DddAcbCR2BmGBKA/tqRVZK69sVCqjWRrgaxUNUNLoda5yKik=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P192MB0983.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(1800799024)(366016)(23010399003)(6133799003)(10067099003)(18002099003)(56012099006)(261022105027099003)(261022075727099003)(261026140227099003)(261009223027099003)(261028144727099003)(261021121427099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d01lM241S1ZpdVNHTUlkait4OU9wb3JPOU5uUWFKeVJnd1VveFRaaDRRRk1j?=
 =?utf-8?B?dCtIUFhOQUh5L21OTXNOZVAxSmY1SWJnODFoQ0hwWXkwbDdOQ1p3UnA1RFp3?=
 =?utf-8?B?ZFV2R3c1ODdDa2ptTS9lZWFDR0MyTExsS3k4cmovVG5iQnpodVc4MmswaGMx?=
 =?utf-8?B?eGNORDZVVWl4bUFxeFBUSW94WDVaOGtna2l3Y01wUnBwb1R6K05nMG9BTjQr?=
 =?utf-8?B?WHh0MnlncmxDVTNZZys4ellzNkM5L1pjVW92Wm43K3M2NEZWeVFHS1hjSzVJ?=
 =?utf-8?B?eEZMeVF0OGFPbUVDeU5COCtQb1RYSFNxSXBrRjZqTzFaVTFMclFINkVtQ05v?=
 =?utf-8?B?V2U4eTVWTHd0Z0hUUmpsOGpTUC9BRkFsYTcvRVZkYjY4YUY5ZkhSc3B6U0Jw?=
 =?utf-8?B?d2Y1dUEzbUkxUC9NNHNHNzNXVnFwbzRoM2tWdVBVUy9ON3RpQzNyalpZSUZo?=
 =?utf-8?B?QmxvYVdpNGxBQk1nbkFYZHRLNVZSRDhPODhCNk9MV1RsaE1CMFk3Ukw0c3h3?=
 =?utf-8?B?SnlJeGF0b01xeTFLRk5MbFQrMFFVZnZFWFNKMXhWd2s4T3ozdEVQUmpnRVZS?=
 =?utf-8?B?QnBCNEcyUlV3T21FZzJ3QUU1ZmVlS2RkL1U5Zm5XbHR6aE9nb3BUN3VhNm5W?=
 =?utf-8?B?WXc1MUQ1UzRNWVhydGFsL3ZiLzYvWkNhQjNWbFpIbTZrcGVRQVlVbmtUM0Rr?=
 =?utf-8?B?alU2TkZWN1o0cmNvZCs5Rkh4YWpEVm92TDFTQ0RoRkVqQTE2WnBsMUxqeThS?=
 =?utf-8?B?eTM4REFNbCtLcFdoaTBYaC9GcWIyQWUreVlKb2RlbFhFdTRZbFRydnFpY3Zz?=
 =?utf-8?B?dnJESy8xRUdEbE5UZ09ZSU5zemN0TW9FLzFBakpkWVYzRHd3Y0s0RHdTZGM5?=
 =?utf-8?B?SnU0M1BzUlA5R3VlVEI2VzFueG9iUXJONlFoT0U2SGpmY2gyTUlpM1NMVTR5?=
 =?utf-8?B?RDNjdUhrOC90YStEY09BSTZFVDNtOC9kdlRyUDJEbW1kNzdTSXpCZ2tEVEQ2?=
 =?utf-8?B?eFBnRjNLYkxuQlpYL3pZSVFoMTUrazlQczdSdndyYkxRcE1ISHdKRFVQNHA2?=
 =?utf-8?B?NFBOZmhwa2xyZUhNSkkwZ1N2UU16N3U3OGxCMmpOQk9zWTlxYVN0RjlVVGVx?=
 =?utf-8?B?YUREQjE0NU5Za0s2YzBSZGpSdmMwVTlzRkZjVHdRekZZUWtPRGppRUt6RVdO?=
 =?utf-8?B?VWV6VzlERVVXUUxqeEo1UUdIOERvNTVXcXNTZW1MVUtOTE9hRWVQRmd1NTVr?=
 =?utf-8?B?cUs2bWJhV2hGK0lseUQrZ1EvUGRwZ1FxN2dFZW9OaGZ2V3ZmZVFzOGRSVzRS?=
 =?utf-8?B?SXBNVjdYYVd3L0VzamtYbFN4aXVrZXZIL09wekFmK05lbHZybGVHaFJLYU4y?=
 =?utf-8?B?M3BXUkZMYUJWOVAzeURvVU9PWVlyZmVha3FML0FRS1NvbWV1VW9OVHZLaERX?=
 =?utf-8?B?eG1ZbTBVMXo3REdEQ2IxOXVmUlZGajQzMUZUUEhCODc3SjBnUmJlWWk0bUg3?=
 =?utf-8?B?eXJySFRxZmFqNGtKT1VQck1IUkxwS0w3YzE5UHJOV3VjMUs1ZWJjUkIvblZt?=
 =?utf-8?B?VnNBa3pxaXpPcWdnVmlGSG9za3pkMS9kSFl2N1k2QTZWdmsrVEZWMmhua01M?=
 =?utf-8?B?Y0ZsS0JsSDZHR1VnZWVkSjJic1IyS1JOY2pJckF2M3JVVng0TkI2RUx0SHNV?=
 =?utf-8?B?OHB6V3U5azJjQlQ0SW9mNkM2a2k5eTgzSW9qM0NMdi95NCthQXVoNTR3djBZ?=
 =?utf-8?B?K3RwVXFnWkNWUTlIVWpnYU5CUFR6Qjh1MERnREVWQ1ZKQ3Jpajc5YWF0RUY4?=
 =?utf-8?B?K0NCMTRtb2lrMWNtUy9idElUNkh4dnFWRzJmalNuSGNVL3pwRzJGc1o4eTlp?=
 =?utf-8?B?Mi9GbUhUZkpIVk9HZVVqWXdJaG42OW9HNk9ab2ZtTS9tL1crYzhRYlkyR1RR?=
 =?utf-8?B?SjIwVzA0WldjVXJCNG80RkNxUWxITEJoNnl0Y1BWa2dlaU1rTDMvdThVS3di?=
 =?utf-8?B?MWNGZTZ6emZXMXl3ajFGZk03REZ5TmFUcW9xRm85TkR4UjFsSlpocGlJTURO?=
 =?utf-8?B?ZXgzcktVeXRFR3JkRjFtRldnUE04Z3lVS0hJSjJhQlBCSUtpQlBLSm9WVVdZ?=
 =?utf-8?B?MjVscU1WamVKR2VhTVRDRExMTVQ1RGFRaUJRVHQxd3BlVkJTNENOZEZ1YmlW?=
 =?utf-8?B?SXZKQ3N4YURNZ1g5U2RQditoNU9pR0VVUWhzbXBXZUhpNmpqeHNQYk00aS9r?=
 =?utf-8?B?aG42KzZtUlhweDNoU3dxTGc1WDlsUDdrVjdlVzlNYzFCemRBMEs0dCtHMWJJ?=
 =?utf-8?B?SWxuRFBacXZsTmlsYjEwNVZsbzE5cTRLUlRkNXc3ZWNqU2pGWHZzdEhKaFpE?=
 =?utf-8?Q?n7qnH40LPffW6JUJTNC9veL4xdIi8PeWCyoLF7B1keuIE?=
X-MS-Exchange-AntiSpam-MessageData-1: Qb6dzw83H2oy5E6XBN/9LmgagYNoWrRI44E=
X-OriginatorOrg: codasip.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55cbe5ab-150f-4fde-b3e7-08df38c1abfe
X-MS-Exchange-CrossTenant-AuthSource: AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 09:14:17.6571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d91ffef-bb81-4cbd-b9b8-552583685f20
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jlBuQB9R4AhGEdEbUcJOqVDdwoLtxOy2iBFX7YQ+ljbpIevIdul6iMu8V1zz8ZzfcLFXTNRurH9am4P6aCvcED8jc7baY+MB0uJBilGxBuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P192MB2500
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B68E20009
X-Stat-Signature: 3myjijc4fnd5fqmhotdbwzxhdkssrj65
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793610865-361832
X-HE-Meta: U2FsdGVkX1/zGW0UbQWrXskpyai5HErwINDquD47ByakvBexma9dA9YEzEUgqTRJfH/h0g4KReiBqv7jdCzfq4LMFvBgIXVVQmaTxMzF4nwMK83vE0NwzhpdNA7bwvhglfzc7mGLBSoa9tyLeZ4quRp874RsTVaDXtbQ2wD7wJvafvmjn6b8+ibwzQwGdYtoOabQzfm4MNDqNEoeoR4e4lW8m84QrHeIA6G//H/I6kBZ6OmyIWlNjAmwb6H+dXb3hY0LJgnxzLWOTyoe+u+h5Ty5BlMVQhroQ8GFp4iN3a592i0+NVMV+ie3CuAt41C8yfchRsiLlkoD1DECVaCbFvr+NUp2LXdqjHGAZ1lL22E2B3vSLNdz7eWvG1KFgPXgRTUs21MXi9Paz499rhEl/THImNCTq3Ts0N+3t+CvvFiMEO0Zq5gpjcLTc9MT6ODC4tTv2ubamS8G0P0smsQNZLkuP6l2bDmk+m+8+C3a4ifOijwkRz3tdCgf+zHYuaJjVsYZTbT1+rRp4s+70u3FncuAVfOr6ixa0vgbmWE0NGK6uo+LNYYYCxN3DXJSsGgT1Zf5j6klrWltiRXFXNC8d7YKVP66R0WbGFN9Sy99/iAU4mahwcAvQNC9ku+KYSqzEzmN9iB+aAiMSlgAyMrFCIcjIH+46hiw/iJa3Tn+AOp6bP8EciYyfMokjUqdMrahyJqw82RNPlenWEqDE+6dCON/BdawuBwxwtXrpUU2pkWdDBmpSvuMWx2Ub3Z8dLD2F2El17ZGKzISkZcBMgapAEnLhrJA2AT7n4t0ej6KrHGvIS2m3gen7ebLz1Hpz/a3AXL58wnSwKuKdOM9J5stL8Gr8D+bWSDPXKNgsuvMHDA8AN5JrxTgdIfOsbltm5p+P3/ZQeSDYfoLxVs0ANLqHH/33sYm3WXr1e098hWK5LlqtcV/ycpTPPrYyn6CiSmyAXae12BnbaKzXNznKxA
 SITY0jvX
 ZogvIssvKl1EnyzgoYh0LLzghF1BYrkamxbZupqdcRxOwqtEL6jUgwHw6ccYfsizHQlYZlCNRRx1QFuvY5NFlC7bf4BZ8Ar7iDFpkBhAd8Qdp7CR5x8gE0pHLh12eVM5oWihDXjcdmemAUY1hSkmtj1FLwk06MuUdK+AyIAoxOYDKkq+weANQ888upBaMqdrzLeYiqHOwiet+XWUig/VpQCnE0MgW0M2oWEOxpWTL/GZh+/Znh3BiPAbZMkNge+8fjUZO0g81kntm5wvaRjFHXOid1QL03AVeLwhERf+Wmu8GX+xgoqwr4essxhbBOwJDtWqqFRRIHdOO2B2ErZUbzDKNO1wz35SdaEVWRxyHNlRHrazgxazHSHOSFp1Wvx1wmpdvrUIiW9o/v/rOgWd8NzoB5AU96zlYwPhkY6G21ahV/gxdCchdBffZLughIRz8I6P0wzX1kXW1I+V2P57SMp2XyXilUhNj5dg/fvShVNmGifWjx0frW/bzAZCnFgCuCTAAW15PDS5KBt6rDPBWPjDLPDTye2pqq6obZgPOf4ioCo+Apa/E1gng+CcT7/FxIg48FJyETVKOCUmcWZC5/1YdYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit baed735a956f ("maple_tree: fix maple_range_64 crashes in RCU
mode") fixed mt_free_walk() taking the metadata in the last slot of a
maple_range_64 node with 15 children for a child node.  The bug only
affects nodes at least two levels above the leaves.  The test added
along with the fix, check_range64_in_rcu(), uses a height 3 tree, in
which the root is the only such node.

The height 3 tree only exposes the bug because the same commit also
removed mt_clear_meta(), which used to clear the metadata of the root.
On the code before that commit, the bug is only reachable below the
root, and the height 3 tree is destroyed without a crash.  If the
metadata of the root were cleared again, the existing test would no
longer detect the bug.

Add a height 4 tree in which a child of the root has 15 children and
keeps its metadata in the last slot.  5191 insertions produce such a
tree on a 64-bit build.  Destroying it crashes without the
mt_free_walk() fix, with or without mt_clear_meta().  For example, on
the code before the fix, the userspace test harness reports:

  lib/maple_tree.c:4755:27: runtime error: member access within
  misaligned address 0x00000000000e for type 'struct maple_node'

Signed-off-by: Florian Schmaus <florian.schmaus@codasip.com>
---
v1 of this series fixed two bugs when freeing RCU-mode maple trees. Both
are now fixed in mainline by Dimitris' commit baed735a956f ("maple_tree:
fix maple_range_64 crashes in RCU mode"), so only the height 4 test case
remains, which I offered to send as a follow-up in [1]. It now extends
check_range64_in_rcu().

Testing: the userspace test harness (tools/testing/radix-tree) passes
on x86_64 with ASan and UBSan, and on s390x (big-endian) under
qemu-user with UBSan. On both, the new case fails without the
mt_free_walk() fix, with or without mt_clear_meta(), while the
existing height 3 case only fails once mt_clear_meta() is gone.

1: https://lore.kernel.org/all/46073a08-20fd-465e-86e8-9c358787f9b3@codasip.com/
---
Changes in v2:
- Drop the two fixes, superseded by commit baed735a956f ("maple_tree:
  fix maple_range_64 crashes in RCU mode").
- Rebase onto current mainline.
- Add the height 4 case to check_range64_in_rcu() instead of a separate
  check_rcu_destroy(), using its insertion pattern (5191 entries).
- Drop the full root case, which check_range64_in_rcu() already covers.
- Link to v1: https://patch.msgid.link/20261015-maple-tree-fix-slab-corruption-v1-0-160d97f7304c@codasip.com
---
 lib/test_maple_tree.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index fb40e193a3cb..121f521e263f 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -3738,6 +3738,19 @@ static noinline void __init check_range64_in_rcu(struct maple_tree *mt)
 
 	mtree_destroy(mt);
 	rcu_barrier();
+
+	nr_entries = 5191; /* Height 4. Root child has 15 children + metadata */
+
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+
+	for (i = 0; i < nr_entries; i++) {
+		MT_BUG_ON(mt, mtree_test_insert_range(mt, i*10, i*10 + 9,
+						      xa_mk_value(i)));
+	}
+
+	mtree_destroy(mt);
+	rcu_barrier();
 }
 
 static DEFINE_MTREE(tree);

---
base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
change-id: 20261015-maple-tree-fix-slab-corruption-d1f098521d15

Best regards,
--  
Florian Schmaus <florian.schmaus@codasip.com>


