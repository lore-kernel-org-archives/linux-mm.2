Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1709AC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3737B6B0098; Wed, 15 Jul 2026 14:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34C716B0099; Wed, 15 Jul 2026 14:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17AAC6B009B; Wed, 15 Jul 2026 14:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD4A26B0098
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:05:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 473AC14029F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:55 +0000 (UTC)
X-FDA: 84991789470.01.B4B5082
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020141.outbound.protection.outlook.com [52.101.201.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5DD7120002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=BP2uW6Bm;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fKHtFe2JRdiFgYL/hT6/kLrYk/Tcs7+w/tnxoXje3+U=;
	b=26hwVv9Y2lBly4jBOtp7WFQGelh6DduLKSzYr8xlUvrIihMMGk+/doAA0Wdjt6jg5mijhH
	yuW4DRVB+GsfF/4zFUwrLmHewUdtnIXLSRxMbALNqN2PHobktrSdu0h+JWQ5GUQuJRxBAn
	6zvGVaeDKCpWA7AYmliy/bWKrcpKdgo=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=BP2uW6Bm;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138752;
	b=uwFs73O5gjet+Bzs7SAgYiS2917K8z6ciH/8K/0L4DeHfastMS+axoQiQd/YSuDVh4JefK
	lHJmYeV/bV6mInpGbcNwyqSqZwOkEW7OE0utmZbskDpZlFYkIIcitNbhZKQAgLvKVY7oso
	c7TgJs+GF1KO8XtXHBHLPgFBKy7UO6Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OKdAceXhiCgqsSSFz5htt62NP4YcvKijVthAUtPedP4DiKhHExKkai86muNYbDPD/3ddTkrpxEBmEcvic95UJDVMdBUhDt+5+Nv5+6YjM6Ad26jwm1BCaRjH9bE65V2AbIH1evNpMUrRCyKOtvHieqnQjZHD3YwBUROECX1tcpbmS019uAlxGR1nZK2GFQT+gSnn6sT4o+4O/F6spNrBblSgvlZHflmQOp4liWlpZhPiRU6cl0J6HsaRKngdNl668nBH8kgqsBl2MDdT4OG8r22LewkQ5GcWq36mo74iMoJDp2Sei7BvdguKpHnfod+KmdZeTdVH8O77aR/kobOX/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKHtFe2JRdiFgYL/hT6/kLrYk/Tcs7+w/tnxoXje3+U=;
 b=oI/wgCuWi/tZlenEp4cITk2FbRdnjGN1uVHmJ5I2Tlmxx/tJ+5AGiaYmX/lsyguf4IWDKGwlvkfHOJORp/RGA3pC9jrtr8CjbTZfaR8/E7x93UUvNyTfngU+Cy9zcmpRneUEuAcF6UVjf/fCJESzrrvlV+SdGVHth3kSLJS1tepHqnO1zrgwam1zqxDaqHVYn1BNuY7PHjz+EbP9mLuF1RUGpAWFJ3SBSJkZW5k7RFIfo1GqBNPd5H1DUj4gHfUpVV5iuk6FYy7Xztu1ISK8n2DNjJHLT7TkPEvK14xekDi0h59vqARJ+3eDW//dy/zKg68Wk2roFRKdEFZDHOkpxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKHtFe2JRdiFgYL/hT6/kLrYk/Tcs7+w/tnxoXje3+U=;
 b=BP2uW6Bmd6es7861eHkuUYqo/meHoQIG+ReTVAwAYQEn4O/yHIPYU55FUyktx7E5LbPqaHI04ZZBMe7qUKtcL1ywZg0PLwHAKUO+NqJvWvIRkbfDB2csK922EJfKHKX4oMSn8/CARCW0Yu+73RSUY8dCvw5Vhveq38OAakBsCXc=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 LV2PR01MB7767.prod.exchangelabs.com (2603:10b6:408:170::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.10; Wed, 15 Jul 2026 18:05:42 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:42 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 08/16] arm64: kasan: sync up kasan shadow area page table
Date: Wed, 15 Jul 2026 11:04:10 -0700
Message-ID: <20260715180455.515692-9-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYZPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:930:89::18) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|LV2PR01MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: 9042f7e0-994b-4322-362d-08dee29baf4d
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|11063799006|56012099006|10067099003|22082099003|55112099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	/xEU/x1rDAVUJnpNMu92877BYkqXJ0CGc6EUEQs4vYyZWl3cEJJvH1tjvjG76k4gFv+nP6lsjvzCSxqGubdodLVYcN7VdnRg02z29IjTSlBRlCFteIopvaY847eTeFFGRX5DDuHIjRL5EVSlaVr40qQ4HDJ4Qs+oGFAgaVIkdSkGLoEO4sx2pefsYbskSOZkLRPWUPszQf3sCVIDMiK4FWtXMkXDFby5BH+kk3w/QsafxfHVhl/RxfRlHZ49CtPfa8b+BsqcvNf0KDhuiFAgkbq04tA6L1jqGRNhFb8c2KDKrlBWqHohIb2O4GsOWLKdH2Ej7FeP3gUlmQb5930Di2UBxiBdVPiWP1RdmQibaxo3sxOgNMiSbwTG104UMsoXya6VPq0JGIojSixCV/kF2NDlOazGBcmXFvYcAHCIFxfW9VjfVMchXIiRLnJPkBMiCdwffZKVtcetDs604C4ujmg0gT5GPf/m1knsOoVN3Bkwx0wLKvaFMFMbWh5/lvhvhedcYA3AorXlek6hAEQkIVYx8hHVj2bGEOpb1/RukUJoLXnfIlR/ongFjqpC/bsZzPrv35N/Z9EJEWJEWIXjjeENnluMV0K6EusVbqyUuBe7Z4/FkoLnSSdeej9W7eKdRYZqBhzI8ywyp9JBTLvJ9OPGPDoosLkZ7dxf2SC9fptjpIvX+QJbe4O8ZlE39QviH2n2gooTZx1pQpSFXERPug==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(11063799006)(56012099006)(10067099003)(22082099003)(55112099003)(18002099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z9mGosFjWDo427XvGmSO9sM3LDL87roj1xKAOWiUO5z9c8eYPS/X6NQp4AAc?=
 =?us-ascii?Q?xB9lwfj3kn5XrvJZHAyBwA1psowLhTpFLeG5Maib4RXBMY4yKGuud76ResFT?=
 =?us-ascii?Q?LyP9s26JONjPeGtXGxnLgBY2doJAyD1dkoFulIpNE7iDwlLrOyZF8sI/t6T+?=
 =?us-ascii?Q?FCinKtKjGwCgwokHB5kC0l9x1NQaAJjqWgWcxK9CfAiIFlz1TTw8+suVu4yh?=
 =?us-ascii?Q?4fV4CzxMliydDIR+0RBw0lq/GJeVJSk/KypFL2BvoN8hSzQOehaFdMAG9hvZ?=
 =?us-ascii?Q?omonlDAFKJOsI3UZUbiEowgwQqnMf3LhEFqOxwoBGaTevewfxtfMn9drLrUc?=
 =?us-ascii?Q?27TENKAC1pvM3gdax1dEK429Ri0oC998mvtLd+YdfX5VcGAls/vq9h03FW5i?=
 =?us-ascii?Q?IB4FlMqnKjQ4dcHEkkqhpHEqh9xdl6QY6L4hV/kAb0n8QrOCTYZudbfquGeq?=
 =?us-ascii?Q?C6AnZRYFtqptRPISBVPYtGu3GdPTvQ4UM4VwifjRQPiqbTw+tRFY5DnuEEJ1?=
 =?us-ascii?Q?mnzGr4t0ISSG42d09el4w8qaOfjuWvp1Bi3KAOj6RMLKDaTeuk43rWW8VVK2?=
 =?us-ascii?Q?cH69cycJxd5NKIUg9gB1KBIyaytqHAlJAEyf6ICdq4gNv6SRySCLKdHEkdcY?=
 =?us-ascii?Q?UiNPXp/W/zw6EgI3FPRG7Xf58Ez7hol769QryfYwXMjNuxyc58o8TTGuzYZp?=
 =?us-ascii?Q?cq9tfpzJqGpBufRmbyknkJk+Ktoe2EkciNkFJATdPja6mMpy69pnr+4W/33Q?=
 =?us-ascii?Q?B+wTZNkgSFU7sEewhI5R0AkdG4GnvYfORFxj5nrXaRrBLg7Q9kT9I9LtzYgz?=
 =?us-ascii?Q?PHKACuwlC8LUaR6wpRJmZfjg66DxWinjNESUCnm3DATuczWUOJnVFHztc63T?=
 =?us-ascii?Q?LXjPz8gi1UFZ7mV1Y6IB88euDdpyUcvAYWLfUU/N8UWaB9oGEfO0+ik2In4b?=
 =?us-ascii?Q?D0nz6mt/9FNVZsH8mKtDITy6npTeApYS10nagmff+R9JNrTwr8WorwrIM7nE?=
 =?us-ascii?Q?UUVaJog57omtf34zS7tzzP1+6Ha+HTgTH9NaXAcE5Nnupx1iz2omSbqzmU6F?=
 =?us-ascii?Q?C6jo6lNKVDqIx2gKkdTHt4wspcYYhGRFdGo54lg570Dg77ObpDX1Any1EUCW?=
 =?us-ascii?Q?BXFv8oNRIzrlTpYrJGnaoWuEDQH03gB6qBFo59lBJ9OaXn/QpKgYmxrzuhiV?=
 =?us-ascii?Q?5Svt75LdpjOKOJfao2lANpDAxRo1zXiq48w9N0EI3cIBuRtKgWZGsWnm7gA7?=
 =?us-ascii?Q?jlyNqBmRtVFqUTwneITprfN7YGkGUxUaen5XsvolWWICq7q4qbgjjE4A9Jtl?=
 =?us-ascii?Q?rXhbKogvCNMoYI6Y7ZcVSYQBG1sS9fDP87I7t8SVK4vKEp74N/9yplGCLoiR?=
 =?us-ascii?Q?+/gqbh47C8pGhChOZwBvQnYGBZ/WkoViMKsD2JjYOPkf5GJybYWPGw9L6c22?=
 =?us-ascii?Q?taTAsrCL+LJJWhJxhs0Vc8wQTvOU5j5CdC/0Q57pSHTUfN0o9FNDGh/UyFMo?=
 =?us-ascii?Q?LEiXEaAckBlKDvh7Yj4Thj/lqjjVX7Jr350ClxDA+ayNGZa8N+8M6nlCpDZP?=
 =?us-ascii?Q?UEd11G78Uu+Iw48APiJAqJD0qFkRQg1u8mTk4L6Au5zjsiferbuZxzOev2IF?=
 =?us-ascii?Q?ywvDpn9fDJrjc9kZWvghtnMdaP1lE6LIfSKqVbepRtjgOLncZ3mwOvNDkyrI?=
 =?us-ascii?Q?s6Y9O4bNDIIz8fn+0lqQZclAkk/seuGqq6QZFm7Til8cD6vH3MtVDUJilM+A?=
 =?us-ascii?Q?fFpyKK7e4bXLb3oulrCRr02ypm8o0GU=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9042f7e0-994b-4322-362d-08dee29baf4d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:42.3502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wUrsDlyGSD/Xluqf7sFBryFFSvrsTOMI4RfjijX8FlGjKc3xIr8tZgLk3PqNWoTla+HLKTLtWMqeQ9ww+nlsQN9EVXqvgJdwwHZZlULfl0U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7767
X-Rspamd-Queue-Id: 5DD7120002
X-Stat-Signature: c9ycxdcpc3pq1p1qyynd1nja13jb4wa8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784138752-614865
X-HE-Meta: U2FsdGVkX18YjcCL7qwtaQPcVfaXmoJFRhrCFRd+3B3T6ywqMPVImISowxAZ0X05JqCtJDQQctSy2hNQsLUixr6D11dZD/L+e3yC9yVT/+6vaBgYeYIBYW3DfLHE/R/otUteTN/ZOySqCzsg9ek4NJ6UxawV/a0RWPyINLoSkr/NBxW30ZN4Xv7chpSQc4gCLELR+8Z2urgTARUxRp+HXBfL0Q3YBHjpyZQhhUfu2tplRzpukyV3rklwr4yozsEDy+7T0nRio81k6SurAS1MEfijtqPrQqbVWpINutx4KlfhPMpSY6HCQ/pSM2qxV0dUH4lQa55OMGAU2kgpSVl+TysmhOWfTf7ZP4otW+hU7fz1OpvlrN/TLgHpQIC0kSMrNt7/EIkmx9Pu2B3HE/lXPc74tPbcds6PixVnihIHi09DRZ5PDV8ZilAUU70bJJi3kOruO/xkNfTCKqsJ9XpEy0WviWKGcpR3YRFv560MJ6tSfcXdwxvyyR1A5Rut3APv0XR5ju4Op6UAdogf6VxnykMevXopN7g3RMQpR4r7uB3HTfoE3+SFcowwpq8nHu2MeNQFRg8BuGkQG8fD0kmg09+ujpyG3sNBpyaw0HCfGW1nYM9bPwHeET8jJbjLvk9iwxSI0IwtcsQBQMQOJAvhf8yJ2mAbigGgt/g1E6GWBtFX21k0nY9YjiOp6dVFDes1kH9qbEzpuEM+VcOkOPv4+NXsXwR81gzzvo/rwDuz4s57CbJSegD6rqozpNusrQbBupj1pFBY5xcOaqaDgFMwnPhVftdPyqoDZFoNvZ+g3uPsQnmV1Q0idnLidw0ve5YMJTR6m9ybUs2cvxjMzrd2xOY9pfZL6jmwLqp4L7+r4UwR71zpVeqYeZwGOagLFWf/+UhhsjHCJqVfghteUt3fyKydODC5aKRw8LQIm3GuovGpsIrjKw1Y14UclgjvOn7zQyHcfFcbnimxZ8R/V4u
 +K3QjxFL
 xfm515M38FRP4j0CSVWwbyizm9ncCmg7UpLbP2reA9J8Lh2t8fPv0QKChEWbAYN4fhbQomvWLjFaZ8ZQPr1Lrbu/kL4+R3IShHho+ruwoW+AmZZ5Gz0R/RJQJP8/6t/0J2aVfiVYHr7elG5EYl9n8KI9kgdyKL/f6Czg971dnIx3a2y7AZqJOsALXdh+A31a93VI/vnUnHlynki11+6Dfgg0jIvvLaQKki83oarRo9tuWwoZVNuwpXRrwCB5qOXDwvHDi0h4M/wHcABul2bblgCq8pZyGwoLGA7JB1HBdp+RhLVEj7BSlWF4Ot2oNm1Ojb+M59y1wpnAS6apMazmZ4W5KN6EcKWxJpsVxLwKBzdZZRLPwrCXyD6I2QFBFKQcKhQn43BR2dlkD4MmAZI2Q1URaCNWoBcDET/xGD1AdZAUxon5a48+xi2MPjNyCKNrhcAwZYrpL07AKiGTlbaRuaadocjS+EqBFT250Wh3R7WncaDln2UJwruw+Itzl1mRpw8Sq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allocating vmalloc and percpu needs to populate kasan shadow area page
table, needs to sync up to percpu page table.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/mm/kasan_init.c | 45 ++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 3fcad956fdf7..960020343760 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -60,13 +60,14 @@ static phys_addr_t __init kasan_alloc_raw_page(int node)
 }
 
 static pte_t *__init kasan_pte_offset(pmd_t *pmdp, unsigned long addr, int node,
-				      bool early)
+				      bool early, pgtbl_mod_mask *mask)
 {
 	if (pmd_none(READ_ONCE(*pmdp))) {
 		phys_addr_t pte_phys = early ?
 				__pa_symbol(kasan_early_shadow_pte)
 					: kasan_alloc_zeroed_page(node);
 		__pmd_populate(pmdp, pte_phys, PMD_TYPE_TABLE);
+		*mask |= PGTBL_PMD_MODIFIED;
 	}
 
 	return early ? pte_offset_kimg(pmdp, addr)
@@ -74,49 +75,53 @@ static pte_t *__init kasan_pte_offset(pmd_t *pmdp, unsigned long addr, int node,
 }
 
 static pmd_t *__init kasan_pmd_offset(pud_t *pudp, unsigned long addr, int node,
-				      bool early)
+				      bool early, pgtbl_mod_mask *mask)
 {
 	if (pud_none(READ_ONCE(*pudp))) {
 		phys_addr_t pmd_phys = early ?
 				__pa_symbol(kasan_early_shadow_pmd)
 					: kasan_alloc_zeroed_page(node);
 		__pud_populate(pudp, pmd_phys, PUD_TYPE_TABLE);
+		*mask |= PGTBL_PUD_MODIFIED;
 	}
 
 	return early ? pmd_offset_kimg(pudp, addr) : pmd_offset(pudp, addr);
 }
 
 static pud_t *__init kasan_pud_offset(p4d_t *p4dp, unsigned long addr, int node,
-				      bool early)
+				      bool early, pgtbl_mod_mask *mask)
 {
 	if (p4d_none(READ_ONCE(*p4dp))) {
 		phys_addr_t pud_phys = early ?
 				__pa_symbol(kasan_early_shadow_pud)
 					: kasan_alloc_zeroed_page(node);
 		__p4d_populate(p4dp, pud_phys, P4D_TYPE_TABLE);
+		*mask |= PGTBL_P4D_MODIFIED;
 	}
 
 	return early ? pud_offset_kimg(p4dp, addr) : pud_offset(p4dp, addr);
 }
 
 static p4d_t *__init kasan_p4d_offset(pgd_t *pgdp, unsigned long addr, int node,
-				      bool early)
+				      bool early, pgtbl_mod_mask *mask)
 {
 	if (pgd_none(READ_ONCE(*pgdp))) {
 		phys_addr_t p4d_phys = early ?
 				__pa_symbol(kasan_early_shadow_p4d)
 					: kasan_alloc_zeroed_page(node);
 		__pgd_populate(pgdp, p4d_phys, PGD_TYPE_TABLE);
+		*mask |= PGTBL_PGD_MODIFIED;
 	}
 
 	return early ? p4d_offset_kimg(pgdp, addr) : p4d_offset(pgdp, addr);
 }
 
 static void __init kasan_pte_populate(pmd_t *pmdp, unsigned long addr,
-				      unsigned long end, int node, bool early)
+				      unsigned long end, int node, bool early,
+				      pgtbl_mod_mask *mask)
 {
 	unsigned long next;
-	pte_t *ptep = kasan_pte_offset(pmdp, addr, node, early);
+	pte_t *ptep = kasan_pte_offset(pmdp, addr, node, early, mask);
 
 	do {
 		phys_addr_t page_phys = early ?
@@ -130,38 +135,41 @@ static void __init kasan_pte_populate(pmd_t *pmdp, unsigned long addr,
 }
 
 static void __init kasan_pmd_populate(pud_t *pudp, unsigned long addr,
-				      unsigned long end, int node, bool early)
+				      unsigned long end, int node, bool early,
+				      pgtbl_mod_mask *mask)
 {
 	unsigned long next;
-	pmd_t *pmdp = kasan_pmd_offset(pudp, addr, node, early);
+	pmd_t *pmdp = kasan_pmd_offset(pudp, addr, node, early, mask);
 
 	do {
 		next = pmd_addr_end(addr, end);
-		kasan_pte_populate(pmdp, addr, next, node, early);
+		kasan_pte_populate(pmdp, addr, next, node, early, mask);
 	} while (pmdp++, addr = next, addr != end && pmd_none(READ_ONCE(*pmdp)));
 }
 
 static void __init kasan_pud_populate(p4d_t *p4dp, unsigned long addr,
-				      unsigned long end, int node, bool early)
+				      unsigned long end, int node, bool early,
+				      pgtbl_mod_mask *mask)
 {
 	unsigned long next;
-	pud_t *pudp = kasan_pud_offset(p4dp, addr, node, early);
+	pud_t *pudp = kasan_pud_offset(p4dp, addr, node, early, mask);
 
 	do {
 		next = pud_addr_end(addr, end);
-		kasan_pmd_populate(pudp, addr, next, node, early);
+		kasan_pmd_populate(pudp, addr, next, node, early, mask);
 	} while (pudp++, addr = next, addr != end && pud_none(READ_ONCE(*pudp)));
 }
 
 static void __init kasan_p4d_populate(pgd_t *pgdp, unsigned long addr,
-				      unsigned long end, int node, bool early)
+				      unsigned long end, int node, bool early,
+				      pgtbl_mod_mask *mask)
 {
 	unsigned long next;
-	p4d_t *p4dp = kasan_p4d_offset(pgdp, addr, node, early);
+	p4d_t *p4dp = kasan_p4d_offset(pgdp, addr, node, early, mask);
 
 	do {
 		next = p4d_addr_end(addr, end);
-		kasan_pud_populate(p4dp, addr, next, node, early);
+		kasan_pud_populate(p4dp, addr, next, node, early, mask);
 	} while (p4dp++, addr = next, addr != end && p4d_none(READ_ONCE(*p4dp)));
 }
 
@@ -170,12 +178,17 @@ static void __init kasan_pgd_populate(unsigned long addr, unsigned long end,
 {
 	unsigned long next;
 	pgd_t *pgdp;
+	pgtbl_mod_mask mask = 0;
+	unsigned long start = addr;
 
 	pgdp = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
-		kasan_p4d_populate(pgdp, addr, next, node, early);
+		kasan_p4d_populate(pgdp, addr, next, node, early, &mask);
 	} while (pgdp++, addr = next, addr != end);
+
+	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
+		arch_sync_kernel_mappings(start, end);
 }
 
 #if defined(CONFIG_ARM64_64K_PAGES) || CONFIG_PGTABLE_LEVELS > 4
-- 
2.47.0


