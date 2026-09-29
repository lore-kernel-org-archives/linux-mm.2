Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D0D8CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 16:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3166B008A; Tue, 29 Sep 2026 12:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166D96B008C; Tue, 29 Sep 2026 12:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B296B0092; Tue, 29 Sep 2026 12:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B66A36B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 12:22:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3351D120584
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:22:46 +0000 (UTC)
X-FDA: 85267318332.03.2017C7B
Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022098.outbound.protection.outlook.com [52.101.96.98])
	by imf02.hostedemail.com (Postfix) with ESMTP id A36858000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:22:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=nq+YAuZk;
	dmarc=pass (policy=none) header.from=garyguo.net;
	spf=pass (imf02.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.98 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790698962;
	b=USbfOuHa+6T6WVA98TznYQG2XQCP4GteR3/QRRPF4X4rpPWXwdeo9RumNtC3/b38T+mEoY
	5M7pYiFA8EhSHFTBPQDrAkltfbG35HGjtbwUCHiqmGFhTNuOXbKGtst0yNJRWfUCPcmmQ1
	Yg49Nd+Ncxv33OWcty1G3nSVn3s/sVU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=nq+YAuZk;
	dmarc=pass (policy=none) header.from=garyguo.net;
	spf=pass (imf02.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.98 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790698962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ufuXTadR9DPcTzh3xS/ESgi+Gktq+/Faf4mTBxAbCFk=;
	b=3Cle6hUVyctkzlUxefyU5Wb0dUEvYgk6Tl4Ge0DMCiz8iKSEp8TUnu3XoYq6dUcu6syE1z
	jTvJapRgpfsozSFivkRx4DPNSvnpsAlFK+JNP1Sqb5ZAXZw4WoJ1R/lXQIPbLLPMqXROXF
	TGKScf073dKBO2LA2sT9W4+rTexm5AQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eC2/f7/8rrZwo4KTrEc+gYUhONDOXpnRRgY7uUKEaHmhc0dM8Lmm2LWo8vg54fNbWqqhAv3Gu5PgzJeFg51ZvSyxxewc1/rmS891u3UAmS3VjjeGnNMWWfKKQoGqb3T05bUTucUhlrYfU3QvYgKLohSNxN7+HBEVmN7VVcgqrxu8XUhMEHbD3NP8qpvZX3j8UVpzs5jWlcGGCSKltHdjUvUg8Ba2hT7gCkrKrC/Qu06CoJX4cn85Q5wywFOMrbnx+ebYQB8dzlIQhERIQ/VUIkNtK/i7bBbHHNXtEZXb/bGQ+vYkHxafkFiPTRdpsvlbm8X26XS5eVTw1qhpZPy0Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ufuXTadR9DPcTzh3xS/ESgi+Gktq+/Faf4mTBxAbCFk=;
 b=O66c9dKJwmTWwnhgHs0rQwNDWu7HwdyQzmBVkHlrFBqsNnNRgYRbIU+SFUCgycBZQwLt8JHhLIOX/KgCi6SCcoIGYhKTFNweDX8wBlO8KGrPeWGFJ05jYaSbvs+aodor6H1vJzNGeZW1E5cLDxwP87Tj5J8ST+oy7liXU29KxdSSBixdMViLK9eeN0BOuhbs1+fvDsDtRwB3ybBdPL/5Z6UGoxHVMKFQVM83uBW3b/KujTCa9wA7IO5XA8tB0kgPhKGHH6rmZel0twBsWECkef5jAEOnvz1WeqNzet6+zGRl/8YTAQ46nhnaxPGSgM735cfmebDnqK/ucBHXjOvoEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ufuXTadR9DPcTzh3xS/ESgi+Gktq+/Faf4mTBxAbCFk=;
 b=nq+YAuZkF2QSnuHPAHFoFnYwkpN7vmOVPaXQQCasuA4/TzVAZE55lOfHGqFnfVZSuyEFOmOLgZc8T3SzelD16YNwgvb2saSa8RW6by+qA2/iHxSOvHvgc9hQzmpNVqOzDm4vwk1vFc6WWjK24LJRXWuGdNKt8l90b7zj5JwjiYc=
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:4ab::19)
 by LO0P265MB3225.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:155::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 16:22:36 +0000
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1]) by LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1%6]) with mapi id 15.21.0451.024; Tue, 29 Sep 2026
 16:22:36 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Sep 2026 17:22:35 +0100
Message-Id: <DLRXSVQZP07Z.3QSBVR1B2JO9S@garyguo.net>
Cc: "Paul E . McKenney" <paulmck@kernel.org>,
 <linux-kernel@vger.kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>, "Joel
 Fernandes" <joel@joelfernandes.org>, "Alan Stern"
 <stern@rowland.harvard.edu>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Will Deacon" <will@kernel.org>, "Peter Zijlstra"
 <peterz@infradead.org>, "John Stultz" <jstultz@google.com>, "Frederic
 Weisbecker" <frederic@kernel.org>, "Josh Triplett" <josh@joshtriplett.org>,
 "Uladzislau Rezki" <urezki@gmail.com>, "Steven Rostedt"
 <rostedt@goodmis.org>, "Lai Jiangshan" <jiangshanlai@gmail.com>, "Zqiang"
 <qiang.zhang1211@gmail.com>, "Ingo Molnar" <mingo@redhat.com>, "Waiman
 Long" <longman@redhat.com>, "Mark Rutland" <mark.rutland@arm.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, "Vlastimil Babka" <vbabka@suse.cz>,
 <maged.michael@gmail.com>, "Mateusz Guzik" <mjguzik@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, <rcu@vger.kernel.org>, <linux-mm@kvack.org>,
 <lkmm@lists.linux.dev>, "Nikita Popov" <github@npopov.com>,
 <llvm@lists.linux.dev>
Subject: Re: [PATCH hazptr 2/4] compiler.h: Introduce ptr_eq() to preserve
 address dependency
From: "Gary Guo" <gary@garyguo.net>
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Linus Torvalds"
 <torvalds@linux-foundation.org>
X-Mailer: aerc 0.22.0
References: <20260927155134.4740-1-mathieu.desnoyers@efficios.com>
 <20260927155134.4740-3-mathieu.desnoyers@efficios.com>
 <CAHk-=wgQyCdrWH3ZuSajOxZqiups6jYbPtqY8JR8OeS7yi49Mg@mail.gmail.com>
 <133ca8de-cf30-4bf5-9539-d0b73e347b22@efficios.com>
 <CAHk-=wi7BkCuzMe_zWi6KHUs09UQWJpCVNvuFg5wh_CAu5dgow@mail.gmail.com>
 <5a695b14-d25d-4c11-87f4-83c8d299d79f@efficios.com>
In-Reply-To: <5a695b14-d25d-4c11-87f4-83c8d299d79f@efficios.com>
X-ClientProxiedBy: LO4P123CA0620.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::16) To LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:4ab::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOAP265MB8560:EE_|LO0P265MB3225:EE_
X-MS-Office365-Filtering-Correlation-Id: 56d70115-dc68-4d56-ba6b-08df1e45dfd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|23010399003|366016|1800799024|4143699003|56012099006|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	bhwN+3r2LpDKOEjduI7sg31tXXt2h8hrOJcV69LoN2p/V0T7vL8SYItUsLw9OoncgP1bS6BQXI+RH72LAWqEvcKMvK+W5/6/W/GVlXJ1MRFJCoCyILAPbzDsBpJliJ6h/HRxSnSzn688n9BJ6Mpl1TQDFPOXJBiLeFLZkhQCfPkdqMLRIl619NJ2FVGdm6XoSlT9UE+dqSJ+Me6WWiSyH9WYr8F9xH0q/2HYjdLHh5byHvyFYXlRtKt85zYjXp4he5kHcvZaqH2wM1sfSaUs/ag8LcFcLq74p8gsDjRDiXMGR2SC1YTX1r7lubFfZN7rE+s9gk+t2n1nAwxhzFi8zNy+fE4R6kqsNXt3Y5UhpyJa71sFBJ3B645JEcd334urR9+7ylRwEM+8eFFL3iGM8Zwj2yTbxynpwd0MgvAx0/J1kVBMUXg+P14pIzi9NvvsQ9cEF8XBdJTeFpaJP7M/iVJjwYYjskE4irlofCI6AhrRHUQr1HKzq+X2uuqZqyU2wKAfY/S+pVpprTeVfr8KldR0EDyhWEYfmhyQ3+V9J4eLMFErz2vMp4jqean+H6JmhSn9DJ/3XkavTCmofx3IkmrWr2UIboXXHvW4WeeQiFCql6YGjRGU1RxLypIJ5bSXhPonYXOiYbn7NtrzFTAiss05Oh6wl1bfB1uHxJg1p+Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(23010399003)(366016)(1800799024)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHFsK0wzYzBEbTNNczJFZ2NqQUFVS2lManNSbjJXNElQVjRXQmxCNTFLd3VZ?=
 =?utf-8?B?ODFSdk1vTUpDYW1nbUFRR2NsN2RUa0VGRlk2OTBoVGpVK2FjUjhjcG4wVndJ?=
 =?utf-8?B?WXF1R3F3bjQ2V2lCNUtHZVZFMm80TFpmVEkvYlJneUdNMXhlbHRuaGZNMnlD?=
 =?utf-8?B?WSttcEF2TkxYR242bm1NS25kTFJHTFJBRTVZOGtsS3d0bHN0b3R5N0YxRGt6?=
 =?utf-8?B?NkJSeUd2dFgwT1o3S3dCUkMrMlBHemhXK3dCeFk0VXBiQUcvNmtrbUY5UU03?=
 =?utf-8?B?VkRXZkdkNGRHYnZuN1BWOHRQSHNkeGJPY1BEdDB3dXN6R3ZJM3J1ZVZnWTFk?=
 =?utf-8?B?bkFaNk00Z296MFVod0Y3WUNCYWhxR2Z2ZTA5V2IyQUJNblB0emsyS05Keldn?=
 =?utf-8?B?SFZaSmJyZ0NMV2pBMW1WcjQwK2x5OWNqbU8wY0oza1JmRnVTZW1QV0NMMWhW?=
 =?utf-8?B?WVFCNVl5VHd3Ry80bWdEMHZCWFBRMjc0OUJaT1YySGNoM3NsWTdPUEY4WXJ1?=
 =?utf-8?B?QWJuSHk4WitmTlJmK013aTZuOFFGcTBQUUhZODBrK3BvL01yam5TNnd4clcy?=
 =?utf-8?B?VFVzdUFXSUVHMVVtTzJSRktYRXd6cnRubXhUWVF4ZmJUZ0Q5SnZ1QkpPdmlk?=
 =?utf-8?B?d1RXYzdtdS9ybTdUNHhJRWwxVG96L3FRN2twZ3U1c3J5SmozeTNDcVZtc1NW?=
 =?utf-8?B?K2JHbm9jckdDVW5RcUE3Wlp2K3RERkxOZzVLb3IzU3JxS0RTc3lieGN4SUcr?=
 =?utf-8?B?aUNXOEt5OFU3a01DdWJXQXdaMmRKbHBwOVlNa292anQ1TytlR3JuQXcyaWZa?=
 =?utf-8?B?LzBad2JPdVdib0Vhd3lmWFIxSDZvcWYvb3ByMmNvVWNSNndsaGVqTXE1dGVt?=
 =?utf-8?B?MCsvWFFGMC9vTlhzRHo2WVdZL3dqR2xackVpNHVKM0ZwMmFxczIyU0J1SUR4?=
 =?utf-8?B?WWpucm1pMEo5bUpRWXRySTIvVHRJN0RWQWErSmRNMlUvTGZjamp5alFjeFZY?=
 =?utf-8?B?dlVXUnloODFEaUNhckRVU21YSnlFSlNVWGsxTDhjU0dsdmRHUC9MVHhKR1lx?=
 =?utf-8?B?OGQ4UGNkTnVtdmJMa1pPV2pwK3hRbmRhVXdrV05ZV05YcVhZZ2hBOVBVYlVV?=
 =?utf-8?B?Vmxod3hBajlhYnZHYVZuMW1zNlBkSG9Ebm5rSERtMHBlNmVqVWxTMjN6b0pW?=
 =?utf-8?B?eEhxN0VQYzF0R2FkWkpJRGlDN2tmcmFYWDhKOUhLbFdqWlgvZWl1MDhXeW5Y?=
 =?utf-8?B?WUk5QnJaaTFGRTZtUzFhY2I2UW1Fand1TkhYTHBjWWRJc3JBUmd6Y3p0R2Z0?=
 =?utf-8?B?TGxvUFg1aW1OTndabndpOThFMFExejF4L095N2ZqUng1ZnRaTjFFbXZGNXdk?=
 =?utf-8?B?YTJRQUxzNnFqOFNZNjJicUtHd0V5SUVsTUxYYVpVWEUvRy9UNy9wb3NpVUlR?=
 =?utf-8?B?RVhDaHJmVEZlODRxMnd5eitGaTF6MzB3cmNYcTZCcDh1WWloT0lCVzVuREJH?=
 =?utf-8?B?dTF6WjBzckJrbnc3TkdJdVFYaWdzSDhMeWQxek0ya3Y3Ky80VVRUMjFHOWl0?=
 =?utf-8?B?bVhYNDQ3c256bnI0dGZIMkQ5Q0FXZzJjSnhjWnkrQ0dkUE9MK25PMTlMNDBK?=
 =?utf-8?B?REJ3d0NJS1E0MU01dG05S2E5QWx4UmVzNXNtdElGWTFzOHFORzcxK212Q0l3?=
 =?utf-8?B?YWtDRVhRMVpmYzYyd2x0S29sMmNxTWJ6Y2x4bFlXem40TkJ1WDdrWmtWQXdE?=
 =?utf-8?B?eEpIQ3ZiNlBCN3ZEdVEvVFpIelBWdjRhWnloNU9TRzA4NEFTWU1uUzRHUkFw?=
 =?utf-8?B?WmxHeTYvNU1NMStYckdGdXpjNThFdUgvRUE1QWR4dCtBTkxVZmkxcStyM3Ez?=
 =?utf-8?B?VGh5VUtzdTQ1STkrZmZhU2UyRVRkY2FDeFZpUmVpV242VXF3d3VSVjU1TTBH?=
 =?utf-8?B?cGRrU0RGR3cxdlRuOVpHOHFGR1ljbDczZE8rQm8vcG54UmtaOWRqTzgyS0oz?=
 =?utf-8?B?eWZ5bmU5VDdxMEwzYWQ2QlY2c2FPLys5WE5RLzdha0FCR3gwQ3Y1SjhTWnBv?=
 =?utf-8?B?bGdqdXo2MjdjV2xndVNraEEwbXJVMlllWTVVNmdzbjM2K0ltaTFNV2g5WExQ?=
 =?utf-8?B?V21KN1hVS01WamdDbHBrTmZFNXNLV0dWOGw2QVF6WkdQT2MvN2FhV3FoVzVR?=
 =?utf-8?B?SWI2TzdJTytKSnkzaGlhbGNOMk9jYXN0SmZ2M2pyeldyTDJqNjBrWGV1S0th?=
 =?utf-8?B?VTF6YXFYNDMwQUM2L1NTU2h6bzlRYWZlNEdvaU5aVG1WR0JEKzlMQU1jTzF1?=
 =?utf-8?B?anh1TGUvWVBBeVF3bzZZdGRWV1hzOTk1QVBwai9YaHVFeHN6Y0VwZz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d70115-dc68-4d56-ba6b-08df1e45dfd6
X-MS-Exchange-CrossTenant-AuthSource: LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 16:22:36.7559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bIL9xwM0Jsdsd+awx6FFg4OVCyavW5i8KhM2h/IQtyYhnB/2MXwcznxhDrlCw4aBDNKIKHQ8HzraJMU8zYbPhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB3225
X-Rspamd-Server: rspam06
X-Stat-Signature: qx5wjhiaxy1ji7ctckgnmx3zcd3g5ack
X-Rspam-User: 
X-Rspamd-Queue-Id: A36858000A
X-HE-Tag: 1790698960-982851
X-HE-Meta: U2FsdGVkX18/bASDbmpyYeOLdX21kxFQpOfmx8oQk3fkAvCGEo6eXBiuACcsHkZGFVZQsGFXVuC3btmbYqU2lBeQKPt2f83wKPmTtJmeFWvWbfaXAfZ5t9Fzvvi5J95hKLdVfk1Ya0YF13ZMBXqnhfC2UmifUEPynoWU/2zUVUUyJv0/Mj6sw26VvW1Z0SMYmo5rf7EvC1wFv6mn+PSeojgcB0bvv5QPx2SzSAfXGF1G42A5x4Q/Mb2WDPru3hAK6O2Qn8c+dgy+igItEREQt/njJ9rEfrF8v9AokmfKngykdLq5AnwE+W9RHcg2LmNAxhHnN7FQdgHCmzvF/vEHbMsR6E3AQ+t5FBg5N39RlaTW5JyEiyaTcP8ZRnO1LkmtAzO31PCTPOJzmhH1skMF564fZRcTfNA63ZaZx9KgOHctXNo/W9B0Bvspg9u0sfi8tOHZrjh/Ca4MYjAVykjJnL8LCEikB8mgHQIe2wk2Zcxn18IqiiKfyZ86hjCLCxpOtfUwEuaXM1rlGslEJFbfBFamJUcEIGfDTO3E10OBEQhYt5w364HW/zU1UNS2uKwZdfialPpvMuRcvSrEeXg27Aq7+6BowD2WpN6EDD1hxPRf2M+jm2v1VQCoE+/Y8nEM+b/4P9qvFdGdq95NvGnP/mTka7/7D0DZ2HlQyR0+4avKH7ysQi86YeOYkR5bjmc5lti72TXnDL1uNdWzCbXW/atR+6E7QoYPH1sM25714wMXNydcg1uABdTRAg3v9O9phuNkl7xbBhJ16c2xr7+MmO8Hz7Ubwohf/Ywm8JOgqxpYgFhrlbXMpd8CUnfGKqa+mRIjp6wzccLKfRHOtPvpK3bHq3TK94ySmEuAauIh99QzDP2VXJej6akxPB/Vl0n6wzFaW0qzQZ0+Y8QfZMPmv65CQMnZVAyqDDFTn3iIk6Ab6ZgEC9nXGXu8lprHWfey7G2yVn+6RL8JHiosKPQ
 vAYNlR3z
 CyQXAh0T+UJs/4ndYzGAB19wmaF3URvXMM8aIMLbXcbnZ3DdJjXr/5Lr85kOE0+TRivJXxLMFDf3KXnzKcR0onr/aZwvCzYD8ntC0z76xiySv1tq+LXEjpTAA+5vU+nGPlhg6zgFNzvGJCnwTq3dYZ/+SJ+vThIJASqvJ5O+GJrxzxCjVQNTqHrgMpa3gYKQn/0Qkc8BPIPkj7QLBBOjiHx2/hASRQiDoVy/lybP24/9h2DdsQ7v6itDbJnTZCKy4jPRuZ86wdmo7bWI4CcAqljYBd9MncIE7C5ZR+/vjFBYc59zCD0hNEvndvcjOp2LnO+Mo75KSKQMYfNzj4gS3Qz+NE5U3aW4al12LWVQ+KNtEmz/8NJiIN50PpY2fg+6JPgaawufDdDID0Zf0PoQ6f8VxZ8ytGxyeQvgD+Mu5VKEZcEo0ErE39HPB+Ftrcub2mm0IFaPwDYhtZouNRhw7gIZsMhQ/t3eCy72+77amYCIY7vg52uKiATQoG87ZnBH9/2db21f2OW7RZwYROi5ID7FmdEECwuNJZkgn6m1y4HNa3VcOibL1lpXReXb+h8YnaHxS+mZpMlVRp1o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 29, 2026 at 4:42 PM BST, Mathieu Desnoyers wrote:
> On 2026-09-29 11:16, Linus Torvalds wrote:
>> On Tue, 29 Sept 2026 at 08:04, Mathieu Desnoyers
>> <mathieu.desnoyers@efficios.com> wrote:
>>>
>>> I agree that doing it in asm would generate better code. Also, I've
>>> been told that clang now preserves the address dependency in this
>>> scenario, so perhaps we'd want to use preprocessor conditionals to
>>> select how to implement ptr_eq based on:
>>>
>>> - architecture (allowing asm implementation overrides),
>>> - compiler (e.g. if compiler is clang >=3D version X, just do a plain
>>>     comparison). Likewise for gcc if it ever decides to fix this
>>>     behavior.
>>>
>>> I think this "hide var" hack is a fallback which can be used as a
>>> starting point, and then we can specialize based on architecture and
>>> compiler.
>>>
>>> Or do you prefer this in a different order ?
>>=20
>> Oh, if there's some sane way to tell that the compiler already honors
>> address dependencies, then that should be done first and the whole
>> thing should just become a simple
>>=20
>>   (a) =3D=3D (b)
>>=20
>> for that situation - allowing the compiler then the freedom to do
>> whatever (which can involve not using a register at all, but a compare
>> to memory, or whatever - the compiler might have reasons to avoid the
>> 'cmp' and use another sequence entirely)
>
> For the records, here is the relevant compiler discussion:
>
> https://github.com/llvm/llvm-project/issues/34577
>
> and it seems like they still have unfixed scenarios,
> which may or may not affect the hazptr use-case:
>
> https://github.com/llvm/llvm-project/issues/220206
>
> Considering this, I would not be inclined to jump to the conclusion
> that using the compiler compare for hazptr acquire load/test/reload
> is safe today without a careful analysis.

Out of the existing cases I think the only problematic one for hazptr is th=
e
comparison against costant global. Which isn't going to be a problem for us=
ers
that don't depend on a fixed adress.

But it might be a problem for the lockdep case.

If we use inline asm for ptr_eq I think there's very little optimization
potentials left for compilers, so I think unconditionally using asm would b=
e
fine.

Best,
Gary


