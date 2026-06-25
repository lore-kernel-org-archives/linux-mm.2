Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 032ACCDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34F96B00A8; Thu, 25 Jun 2026 05:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5DD6B00A9; Thu, 25 Jun 2026 05:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BADCB6B00AA; Thu, 25 Jun 2026 05:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9A16B00A8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:27:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C5EEA05D8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:27:10 +0000 (UTC)
X-FDA: 84917906220.06.B94D890
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011030.outbound.protection.outlook.com [40.107.130.30])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1EC2A1C0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:27:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EFihsx+W;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EFihsx+W;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf20.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.30 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782379626;
	b=63cSPIGvPXXcO3DWl+aCu/S/RvqrVM3zmnVG4SEwdyvQgzDzjLiiht3YFwmfvfjv2zMoaL
	iN2co60hFcOuQgt83YYA3k58DQQ6kdtNCZt/4S69EsD2ThqTo2VghF3xojBq3S7pXTKRAT
	3QX6nFPnOe0FLOgr6OA18b2t4Na3IUU=
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782379626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6dvPU4Q8um3WA8TS5L/hp1VLVnlyq8eq0+04sQdNIM=;
	b=gIcSMWIUXLDHjA4FJ2iEIdV29nOn4Og15TInY1/Gq5Rqzqrg/CWhZcYA5pL27OJA+96hAz
	WaQXn84waJUHBTusRBHfdelrbT7lT2sb9rCL91zWpMc16wIekG5EXPXEHR/bXvJNl17rGw
	Sl9kjI6VCCWgnCOjzW2Tlu1MzrmDaqI=
ARC-Authentication-Results: i=3;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EFihsx+W;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EFihsx+W;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf20.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.30 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=P92BktvSZpnDPRP4SEvrRppO5nq6JtjRejvLj6IWG10iCoTS6Cfg7oKtIsMJI9W26QiLkUXMLZ5Pe/c0Gp6I/GnXXZZTvksRoOGHjtQMlTkYkWiku7YFXQCRYnEa3FSPy7yXFopoHXhSOHYGS7t4YIo85Sjt/uSdWZ/nPdrDzsIttWKzPbXkZ2ynWfGoufR5LjqCAtMJkmFli4bGQ3UkhUvDMUcH4882mMkWG12NdJVzWx00ueFNwm8mLOmye66XgRa4bhEDaQcBxccgu+SrW0XPgvlQet4KgRJPlct4FDWzooVkNTTy7VaiH8ISfl1ZCgVpRepL8Ybizross3Ak/Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y6dvPU4Q8um3WA8TS5L/hp1VLVnlyq8eq0+04sQdNIM=;
 b=Tro6+Gx7tC8jNYwEJc3dB6HM6K1rTkoeC+Lf/lSUI9BHMYermPhWzWVJNexWqvwLlncR450tziMt841jXWS8Cb0iAHnC5TEtN8IIFCiOxobV/ZhgmaplCkkO0lkkdzpHP0rwN9UzC9Ahe5AFUd1BHrdI7Wv2NTXbFCrZUEl7+TlWIs0BWOPQIeLsA0DeW2dzgBZpdBu+3zE6hZAUA1Afu/a5gqdEHD04FvYQdMx9ETO6Q98UsDvsF5LFhfICLTYdQxzT5Nkl4gArniy+k9nhmAH++Ide0ceCgHdoEKTnQkseRxx0Q6NGB6i5u7lSfbwHZzOGKnEnAqCMQg8/iqru4g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y6dvPU4Q8um3WA8TS5L/hp1VLVnlyq8eq0+04sQdNIM=;
 b=EFihsx+WuMpwb9A2JltupbGD1pCkPS/G5aojIQHOtJDdtRUEeFKDHPUkCNO7CjNN5N/pkjUXgZOgT5wC9rRZz0l8qsa0gDYXOPnRxT+BW3mjWxek2BFCaog2ccUqkJdszuZVsVCzGF+vwfHprQS6u+OcQhGh4xkKGMI18yEMBP4=
Received: from CWLP265CA0398.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1d6::20)
 by DBBPR08MB6300.eurprd08.prod.outlook.com (2603:10a6:10:209::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Thu, 25 Jun
 2026 09:27:02 +0000
Received: from AMS0EPF0000019A.eurprd05.prod.outlook.com
 (2603:10a6:400:1d6:cafe::d9) by CWLP265CA0398.outlook.office365.com
 (2603:10a6:400:1d6::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.16 via Frontend Transport; Thu,
 25 Jun 2026 09:27:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019A.mail.protection.outlook.com (10.167.16.246) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Thu, 25 Jun 2026 09:27:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hSnAclBfiQK7gJgvOsDrrqB136MC3d5o6FyiDH5XUAhXPth5v0mUGwsGWwJWtk4DZ9KBST7vjGDBk08+5CRF/+ESpZ2vueFQa6OF/vhSRLcb5FNBh8PRZI6+6fuDOxtTXLYGahMoeq3/DXLCqr1blYSEl4BQKaacGeHrY44SuNdf3ziBD8I9JQXz+AKbu/kdyCqnEhP10QJ2AQvFyX36Old7AVjr1A8+s0UCxfskIb6miSR6FcSNZ29+pzxEv10iiEJ1vAGUdLyHlnlm2TZbuq5cN6yq45plbHP5YzUqPTATelPRo9gkDFqig1ErMSL/eSqbfx+7++Shw0N0QbTq2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y6dvPU4Q8um3WA8TS5L/hp1VLVnlyq8eq0+04sQdNIM=;
 b=q4kd/f7ydEJKp2QqecSpdif2rA7QKQKnyDVLw6w3DIUUFNsrl8C4c2QmThvBqtsIADsfFF5bIEXCoZpweP8v0zsL+UopjJ1yi/4oGSa6SGz7C2rSzZBZ9KVYMlXa/6bKB69mOhNymvOXCk/SNVn1bXDv/04MYLNlnfCRaiDAQLQE5nv/G/Iv++shDT2GESGG2IBQJ5oGIZ72u82g6RHk0Ll+x0oWa+eNukB7NLcNAv20Sf0LppLgDyM0jDHr4bkBswcW/dUF8FA1zCycfb+kO2Q8PLRruLRTNb4o+68KthX0vDnUvbRWn0kfPxLWqdW6rHjxFd4vHWEKHO98ibxR5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y6dvPU4Q8um3WA8TS5L/hp1VLVnlyq8eq0+04sQdNIM=;
 b=EFihsx+WuMpwb9A2JltupbGD1pCkPS/G5aojIQHOtJDdtRUEeFKDHPUkCNO7CjNN5N/pkjUXgZOgT5wC9rRZz0l8qsa0gDYXOPnRxT+BW3mjWxek2BFCaog2ccUqkJdszuZVsVCzGF+vwfHprQS6u+OcQhGh4xkKGMI18yEMBP4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by VI1PR08MB5424.eurprd08.prod.outlook.com (2603:10a6:803:136::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Thu, 25 Jun
 2026 09:25:58 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0139.018; Thu, 25 Jun 2026
 09:25:58 +0000
Message-ID: <b46b1a80-cfb4-4cbc-931a-3d0ab194ad29@arm.com>
Date: Thu, 25 Jun 2026 14:55:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: refactor finish_fault
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260624102047.144543-1-sarthak.sharma@arm.com>
 <4f43c837-0f9a-4302-a3d7-f252d84ea390@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <4f43c837-0f9a-4302-a3d7-f252d84ea390@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0074.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::7) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|VI1PR08MB5424:EE_|AMS0EPF0000019A:EE_|DBBPR08MB6300:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e30b92b-0e72-4ac2-a40f-08ded29bea1a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|4143699003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 6gFZYdGDCClk/O93YeZ8pYH4VqUlPbdcYnZTAe85++HGAL/uJXYrBB1tRBEWEBkjL+T7jzy1QLCPOhKOJKWDlicrfHzMCxQVLX0vY0MtAv5C8Rw5FgAa3a3FBKUFNMGKVMilJktZYRc/htVCsstNBCf2tip+jS6tLg14Df1XOyglf/4hOT4xGdx2m7zBe5l/wwXUEmQ50pCS5kQeoipQp9paiY1G70PHWsObnD2sGGlMc5RuSiCQw61uc5VACSzL/CGFgxevi78MZ8U4EBqcKZPxzwm23InssGyC78vWsR4WHBG8D6pzW1rpEpq/y7H+ruY1qv7Zjyv7s+07ad/awSkvE8Uu3lDUoI7cUAVweAp+uoMQYSwuoiAo4vfWEjjUwFNprebYU5H1puvEtmcHN6zB05pEc6BlyoqJD+N99jU7KI4tN6/V9qeJM1yF33vU8COpO33OjYbPhKxgo8zoWILrm7+mR9ZetetoN1KNhMYPEojI/FW6AMuiZgQLMeXCllop8Ap2UU0cK1h//GDZzEg3NfxZCpbBj6o0PP193jVrTYGHDHQ02kCaQ8uEEXb2s0HpT56lTGTnRo/w8rD9uWAIp0aZnbu0HsdhZls8sDwGHGWYiN2jsinVJ6v25fBVKdqoLkdZ2ZIpVsf+DRJGfsaNmYxZ9/EriwhGJ33T9lU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(4143699003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 f8UCcBmXvyie+jQ6SK0OVwVt0dcfWJuDm8IBXBoIGVn6OyK6sDwgnZA+F3pydHM4k/3O2Cj8670C6mIDI4Z2gFL8/zrnXiuKPeB/5FphQ/X12GK6b2zsnz200zXnKEnupbowHYFPPDiLGvJ50cJLWseT/WeVr0od+YL/lUIyj8fCnair1AWdc64gH11Ju62IJrVs3p5PzTKaUdK7P42uctYCXl9eoDy7jCjg+u/5dgtIMfd6wf1IRllXJXNg7P99O+NfRBmJoOlq79GvS8ofnQnCCr3lyjfULhJMgX0rws6b3Lq1QEaXNPIg4rGDgzY5xBuY8Rlg5kELDGJCFyy8Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5424
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019A.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b83090f9-5c25-4b1b-141e-08ded29bc3a6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|1800799024|36860700016|82310400026|376014|7416014|23010399003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NcOCU9S1fqRKqM+BmohF8GvUYJKh3YUDeSux3ywjbSesUuJM4PIw6RoMV4wxctuJgreEpTxP+d0MIegYvAt66SJhXAP65cQzeERSaAOxg99hRtJv03x0gq015HfXdqhTahIGyhpQb1FT1l5495ZVDyNavVWil8RTT+BhrFXEqzE838G8atsj30gPDa7Q/BWzXTVCIZI+zKdRagZ09FrvfixWoGWlpPjaAb1Jz0HMIsb/amPwfcz7l1GmGf6UReeOst1sh6aqctGwEhyT0rvz1wDjhBoiq6J2HYjl4bWsihIRJTiEerjCkB0g52OA1pR77S98GYgT4YFn5SgLMstOBWFeJnxAHp9iW4RTUejRw1C4aBbqOz1DLiD8cjwV/8nVDK1BN7/ymG6crZbuFxC/MHRMsvHT+G6ixZ2O1XiI1FwwCl3G6RWXBrC5kQAsA4+cq+Ak7Bm614CWEUMpd809TD1MiFkhr0ZgTSh07eEUYKubzyPTLD4YdefIWw9P2b1sFMuOqUxNJhJecsVhftSOKy+qvuIF7hB92nxWxrp7hHwJI5xcLFpJ/7Iefc5/BFOMdNUBmN7DQvPe6GZw1EN7gh8QlIs7FGR+XoaNT80TGawCIxFkjXFnirx5XlwmoSOWNXX6O8XIF4+ymktWxjWSXY5kT0gn43OyPVEaVyeSiDuQwO7Cr6FNtzLX02MyCfigwXCAU71HsMa8mi1p4WLgDQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(1800799024)(36860700016)(82310400026)(376014)(7416014)(23010399003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Rhaq+sstLkTaj3HttFv/WHBf5CGVFZ+oFpBAwUpXo0NppVcp+OASRhHm1OhbY4HgQheLpKYuzxT8lp0kmqfSzoolpJVIFm1fewVuHWjsOepPpmuD10jYKUg4XpK3XA8AKRtSo9VWFtL5U3EnNhd82Bt4/EIclrzlWyOCoxozDsLD6X4fjU2M1NMhtIwcnpH3T/hEuqyxSBeLpRi+D9Z2xjZUNBwWJHXtwyfo8MdwDpghVvp+NTI8HHZikPNspEx33EbOEmOWEDr6KsE4J5XRzOWn6XddUtkV9RVJof1BMdAIcSYnJ7Inas6tjR+D31hJpl3NdJrhCJB536Nch6KOK7l9oC4Fs0hlY0Eh/XVLRHKt9bVrS2YSPmCwX5SqfgD1FPDOJuMlPdIgUMv3DZeDcNryoHn0eHGUhTyOUHALV+3OYaWT5sP07vik7sN9oxda
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 09:27:02.1659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e30b92b-0e72-4ac2-a40f-08ded29bea1a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019A.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6300
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1EC2A1C0005
X-Rspam-User: 
X-Stat-Signature: 4tpnfu43x1nuzdpe6ju6np3bjkp5egqm
X-HE-Tag: 1782379625-440409
X-HE-Meta: U2FsdGVkX1+ffja4vbv+PvCD5Y0ur3VSXUgHEFmZrJt6haea7Cya/DfNQQ7VvymC4DZp1cX/aZuoyKb94YTl/JmUYN2HPtFU5ynpYSoG6Clj2kdNfSto0pRFLz/xCxZpbE8dnB1NMIOL7MC+J4/YCFK2EmL1ye6S5pT7fD30nr7rHyIIIDJIdnDPR1Czek/NuM+MgyVTGIULB0gfZv4hFVZEftCYRlHOODN3DFtSjZrks+GUQAbG8O4ZCe57yH12g8ubbg1AO4/Yc5GpIlWklgkaaCjaI0kvNBYT/d+6pKRY8GFhTy8+rZLOH5+4NsqRaCLXf1LhQBOFGiEjTtuUty/px6FYWmxLFaGG2RKwgTL3xZ9M4Au88YD++KJqWRT+ej599kKUyMLmYFC5kRUBs525ssDUlVoSgToopKNtjkIJyd6wpVItuh6L7vNyoPcdrDof8XNxFx4cU4XBacH1mikXyai/y9jWYuCM7HGPblqQ4KQGqgRKi4flk2DhFBxeQIHf12WtyMj6pRgn7DN+k1Ga9+8dhKGd2C3EoHru+p8NP6AETP6qQTG0UbaNblgES4cR7+jBO3viZk/8UUdQlEVG+mvZ7LOg2nAsE2H4vq0B+saaLcse40NWQ5M3/YpLzXcSvJosaIiqE117ws3m958yYB0iMhiPha6zhicaJoQ4/DtNX8RNqwT3RuWYbPerlCWNn8QGuvwJECJ8XnFRBYjbDVR3Ied0Io2A9cUKbchiMnmiD46nfS1XOxGDncZkXGdxaUztRTyZMLS/E0L1pyMYb53kdIr67R7ItAPywUJlz8gB/A2XB8vOgjJsO0Y+LLhxKcRc5R4Kmnv3MWVs5QTnbu3Hw9LjJxE5smfTlvyjyJZfttB6CxPyOHXFlJ2AKuU5HazkcnjoTWdvb845+pGXeZC+QwvyQRZnY1GyIXE2wCqK7rtRfRaaP7m1fRv9cO31/REqmK/PEZ2JAyG
 HagDxLgk
 jC7Eay6kg9WJAPijZpDnbug9IhP7Iv0MoZfMIWeX12kOThgHGdrMD7cb9vSbITT87j0/d1+0g/BmsDKiUTS8yoaziXnX1GCHQCdmc6jf7J/b/QEWBBR3Lf95RSUlOmP684vtupyaR/v+9BRp5Zc7W24PSO3+/4XOob/aKERc2Asa8ppDnQ0EcXZvrtGgIJdQetg5bpAbo0ubdj1iAW/wxTULqAN+3upZSDW+dUDZ9W0ELc/EtF4gZuzLi/RyV6W0/XjFnE6nfTxJ5RADj/er+eDlqzJqDykgHmW9obvcG1IJ1s0G6COJNMpkfWuQSKQSLe/2061jDulUQnDIBAFd2LhZYBNKgoeSPf+3A3aJxF9lkHcqqWfLXPLTdmzvbdZ71YGjFwN1nLGfHUWzEyxL8vcotb/YS0vOpDqqXT1BfDuGutuHjh/U52CGkBF3LWqN6HOIxDpodb0/pq3EPsnHyHGtCXUNP/1yL3yb8Ci8In5KmLrH5Swn+u6EmiFQGIZmwsJFHflvg7DbsULqM7ojWQxW7uM+OCSMmUvo2fxFhwszu3ZxQnEC4Zim8ZJ9IUMN6ug9eSuhvl8tzVVcgpPbD05hGytoET94f1cJzEZnG3q8xSXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David!

On 6/25/26 2:22 PM, David Hildenbrand (Arm) wrote:
> On 6/24/26 12:20, Sarthak Sharma wrote:
>> finish_fault() currently has a goto fallback implementation
>> where we try to map a large folio with PTEs. If that cannot be
>> installed, we goto fallback and go through the fallback mapping
>> path again. This looks weird and is tough to comprehend.
>>
>> Remove the goto fallback implementation and try to map the
>> whole folio if allowed. If the whole folio cannot be mapped,
>> fall back to single page mapping without repeating the whole
>> function.
>>
>> The cleanup of finish_fault() was suggested by David in [1].
>>
>> [1] https://lore.kernel.org/all/3684c55a-6581-4731-b94a-19526f455a1e@kernel.org/
>>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
>> Tested this patch by running mm selftests on baseline and patched 7.1
>> kernels. No regressions were observed.
> 
> This goes into the right direction, but I think we can do better.
> 
> For example, we know that we always have to fallback to a single PTE with
> userfaultfd (incl. not mapping a PMD-sized folio by PMDs).
> 
> Let me find some time to play with this myself.
> 

I intended this patch to be just a refactor to get rid of the goto
fallback mechanism and make the VMA and PTE table bound checks easier to
read.

But yeah I agree that we can work on cases like you mentioned about
userfaultfd. Thanks for the feedback.

