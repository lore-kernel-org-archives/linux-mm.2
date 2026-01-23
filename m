Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CDF0D3EE98
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727796B03E0; Fri, 23 Jan 2026 01:24:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB1B6B03E2; Fri, 23 Jan 2026 01:24:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC766B03E3; Fri, 23 Jan 2026 01:24:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0A36B03E0
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:24:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1870F1AF704
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:24:39 +0000 (UTC)
X-FDA: 84362239878.30.49130D3
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012002.outbound.protection.outlook.com [52.101.53.2])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C8FB1C000A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:24:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ieKu6Adc;
	spf=pass (imf21.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.53.2 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769149476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjEfkjDT5lAYEix+jL7EaCQjlu60kwgYU6Gs+ldKJpQ=;
	b=eVvgTP2vFAec9FCLTA24Idovaum4o2iw6Aepu7g/J3DKtskYqsikS94N9awynY4o1cS5QF
	AOtIEl10sMgcDss1WGGtzsBdTVEN85gMLfNoc94DotF4i9IDyngCX5f4nOZv3XLJoHGD20
	w4vHlJUm9BxrjCjzh0+9F7ChgGj5KME=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ieKu6Adc;
	spf=pass (imf21.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.53.2 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769149476; a=rsa-sha256;
	cv=pass;
	b=D3W+wzbvga4K6PdoV/oHeYktwQBviHpw2pTujgo59u2PFKhipTiYHIh6E1SFbLSaM6ZecK
	xwsQW87YAeI/haHb8QIeUG7WgvwZtBFREOSQ51V0YG0e+QbTiR0CSCABMYA49gtN8GgBPu
	j4BUE2rQwvZU02Is1N9zqgf0hGnTJcA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hjeoXlr2NBKi0m+R3ZdFyeBHx9Y0Zq/t8x1QS44kk30bpNSEOkeZztQTDLIc2rJVBfHrJrdp7r1zZJDVnzGnhc2v1Bg401ymU7zzmE64fLYvinllcrqMfg5fLgWyvDOnQKQoY0eyHIMw/KT0Llxqpt4DuYymcMmcWKBtQRRfUCu1VDTkrnOIQHSmOGBdidpWra/rpyYTBL6NquI9mh9HLn2WYVDb88Sf7uRelZG/Ib8uM/pWAW2nodjsHmPi21a+Ht1bhFst5w2H6ooG9Qg5plCDqLOPjhg+651TgVB6y60HcFsRWdeEGkVLeBHTClmmMVrNzkngdFmSAaDUXPb1Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjEfkjDT5lAYEix+jL7EaCQjlu60kwgYU6Gs+ldKJpQ=;
 b=RAJa9n0UyGbZWQFP+6hIZi3YBz/obt7yrfsMzEe0R5LHdjBX8Li2rwfrOkgxBCf6DR9t72rnOT4wVXWpFLY6hMJqbW71s9Hw/A0WPJFmsxTkH5Cy/ORyHpC7Rw2DxhhKmlIJx/Na1m8GfXulWVMCPlMBjr8UJ8hO8pANMkqELCQPWi9eEgYK072+iJ6Gm7I4s5zBCaAyh3NnmC90RrZCl/iC1+/VPxc/YXQRHkshQ177BCsoG08Waywk5sDsb3C10MdMqS6BVh1PjF0+pgxa1keFFILSSMlOzGCbtopigyshG5RJ03+U1pEl/iNOsYlpFYIus/uDA3adjX+K/Crpng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjEfkjDT5lAYEix+jL7EaCQjlu60kwgYU6Gs+ldKJpQ=;
 b=ieKu6AdclEOWsPltTBtZVktn4/asI7tw1EQO22ZG8QDX0xlsb8IMHsE0hMdqxuW7CF7WhQFt+C5YeMNxy/BhOkR2Q6ctFqiHSYU5lzWUFU8AorVMbo6xjY+7B57zJ4CEob3CVl1h1koCTBCUp8CwEStU+zq7NsQEwJBCRnaKD58w3jXhad7qSJBudwvemS3kDp6yPNrKkdQfq0kgRo5Ygyx4sVzYSp2DpMM8XaeG0NsQ0tB2CyXI1FWH6PbSplSgM5eqB3hgPDSNaqrrOOmZECLWyDLPVajs0AGOaAOwcCnv4VMsVw1qoYLJUtoTxFhH1FqD5NSbOhI4xYakK4MOEw==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 SJ5PPF01781787B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::986) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Fri, 23 Jan
 2026 06:24:32 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 06:24:32 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH v3 11/13] mm/util: Add flag to track device private pages in page snapshots
Date: Fri, 23 Jan 2026 17:23:07 +1100
Message-Id: <20260123062309.23090-12-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123062309.23090-1-jniethe@nvidia.com>
References: <20260123062309.23090-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:a03:505::16) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|SJ5PPF01781787B:EE_
X-MS-Office365-Filtering-Correlation-Id: 94162de9-409b-4f38-8ac3-08de5a48120b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D6fnLVcgWVjE5JFH7T0EwAPsXWiSJcAFJ//7pvodwAfgQtxZCqnwl8KyM8BQ?=
 =?us-ascii?Q?O1YvrhLcX2RiUcFTwat5klDPa+DGZKZQkH48P5buflS8cfWcd61NKMzlYFK3?=
 =?us-ascii?Q?OOpC9pPj4Sk2WALNicm2+lRSi5gHiczAdIKLsJ7MLpxhqopCHGtm3B2dHQrW?=
 =?us-ascii?Q?a4QDpYd4pJKnpX3papLsxi5OOVnmDU3WCPnBDBLM0PA4MZiNby+kch+biDq/?=
 =?us-ascii?Q?znoIZZSHwFFW/CvBgdjeujVmddKWCwvYjU8FVCrZkqAFXqVzc1aAZywBiXG+?=
 =?us-ascii?Q?wTrJxYhFmgI/kenUJMQ+49Mbq/HE22xuWF1pqh6JsXDR1qmVwjW7QflcDvGq?=
 =?us-ascii?Q?2USAXVusXKpIYuEXrDldEFDIwwFXwB3wqy1qdYzLqDuwgFZTyT1Uz03+vVGb?=
 =?us-ascii?Q?MpXopl0kb8GQyLN7wp4yt85f8mNbxXLVe2A6V2rluhk4aXFTJt2HFi8dDwLw?=
 =?us-ascii?Q?5VILEylM29uZ20JE5V0NQoajL7V3CX8hfhFWEiHYb/e2rc8afBj8V2FMbSLy?=
 =?us-ascii?Q?r1Mq2GzKlZONPESe1Pivveb6JBtd8jEhwmmZ1eq44iaP329PSOVa4niZmXaX?=
 =?us-ascii?Q?0yz4WRdnhWC0meW15FyWQsSezadUrbElSDeq9Xiq2U+lP0wMXDrVnEY/+F7J?=
 =?us-ascii?Q?eALuglsIDWTGi7EZen6MeoJjrVCDlVF5trnoZdtRLP0RbkjKAwRicQ2BJVaJ?=
 =?us-ascii?Q?sIihp3yB3CjzKLgeyTYkcrGfeIOIceCpMV+vxhE6KXKwTUuL6ueHrqkFfZMX?=
 =?us-ascii?Q?O43URR+xzn2y+C4p+P3T8C/VJd9fU2jxUB+g6hyeiEf2HJQxK6BB/nBpQs94?=
 =?us-ascii?Q?ee/4cLmqWdqttix0Pw8KpiNvsS0W9F+gJmEElvmCkYtbAgm6FmSHkVz5jtVF?=
 =?us-ascii?Q?RIri5p2zcmcV9C5PqksRiY26jLvdmRcXIDPxfggQQOBlDUlSl1DJZijjDj+I?=
 =?us-ascii?Q?mw5zpTWvfOWB+gdM7LQbSzfdmrBH/CnmXngPTjLyMfvnUdHTlBF4c7B3WBVX?=
 =?us-ascii?Q?afk0Egzkc8ibIMOLhGv6CPcFMVlrMy4DmUVMM1VMpPL4FwPwoUnj2tlImfiD?=
 =?us-ascii?Q?7I6ltR9LtUABEW8ki8wUZ7Wr6flxMex7NKZRO3+1w82n7TqyitiR/Dk8C1pr?=
 =?us-ascii?Q?U5x60DUCFBb4PDklHlVJ27nuLPYbnA7WEOwwfEMloTaPqvIwT7AeAEM8DaJ/?=
 =?us-ascii?Q?JHy0PZ7n0L9Wb+OQYioSSHTRDRKzaal7dTQ1Q80OoeJSEhNx5keiLahKLKrs?=
 =?us-ascii?Q?FOkmMTO/a+4VO1X0h7WVnHoVN1bOfMMeZaSPctioq6fkg6ygmrHySTGQTNQ5?=
 =?us-ascii?Q?JPRklmWZ991tiniOQ21WI8tYRdEgm/CgLE/bUgguXzLAeHhPaMoXRa1Bj64U?=
 =?us-ascii?Q?TF3aFi2QD3r9/EwLCZj5nGjyH7stlZINgwnjlQ1C8fcV7iJlnWLDo0j9MEZl?=
 =?us-ascii?Q?TLfT6rLhqP3pJs0HBSuAASiHC8yH75Vk23MnQYaf2Eb/mPyTB5RNyrTF/f3U?=
 =?us-ascii?Q?WBuAPvauAJvK5zA+dpDNm+dOrt5gxe11GYOn2pS5Tus38lo6MLnESk4Q9Nfr?=
 =?us-ascii?Q?OHKOQtkznpAc/6pSbqY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qKLHYnii+e4TjT3e3XHRQdLEUkSPOYnpthYpI0ndy28OdrBVwf4QH1nc6bja?=
 =?us-ascii?Q?8HHjNe3ihlmf268KGkQ+0QEnjm9vu4F2AMu03pbIbJv6qKqAyMs+X029HxzF?=
 =?us-ascii?Q?GNxlQb/F0SZtFDtZ1zrGtj9XonBxMeqa6d9y65P06Zs8APckQz2pJFtey26p?=
 =?us-ascii?Q?H8J3JlOQKB1dl5rpSJb4Vul93FLs8CklP3muyorLQyVQsAWuRGeN5N+p/lNP?=
 =?us-ascii?Q?KlgXmNP1fg8xEtyO4LAMtemrnkNtUQrI+AK7/xO358uCA0Jn5IPZlO30dIeL?=
 =?us-ascii?Q?CveEvv8c0pgl/6FF0BTky5pNaeUXAsbgdw1Mn1lvGgWQJJA1pmNs5wHqU3ub?=
 =?us-ascii?Q?F+pOiBv4OQy6fHiLyltG3id3kwUNCN3z3obgI+axWm1oapLbJNgEaXYLd6sc?=
 =?us-ascii?Q?FOe1VRP6rcMl4BUIzawwdbCiHqfamUse46rpIfhkfECHWR4Zu1MLFJHvu65s?=
 =?us-ascii?Q?SXy5WaMw0ZUYRtgRNquPGRDULlMR+sAEJQejQZQDg0xg5gTrcKd+UJejRAO7?=
 =?us-ascii?Q?7PfF6tQxHZ93gaxihDdNlWklx3U66uyQrk/GrHe/EsFcSww2guG+yALfeNw2?=
 =?us-ascii?Q?sQFb/MGxALcLUK52pfTHQbFEITN0abKKAGSB465GQfov4LrLg70S7jJksp/V?=
 =?us-ascii?Q?bGt8p4GABRIs/XwTmDoF+sCaxTjMLQ1Dto7nxMoKdyzrM+6O0N7HF4Fqh2ar?=
 =?us-ascii?Q?i//l+7ryDGosd/durKgR+vJJg+D96jPnKqRFenaxxgc+p7E4jb8u8Ixsha9f?=
 =?us-ascii?Q?Sx5uuR11+7Y5J0hcZHR7l6Kd1EUcd3D6rqi1YBFG5AinCcjox9VTRdh2ekxG?=
 =?us-ascii?Q?/JlsPGQ7luPcX+I7c/514NhViap3LaWmENTV6xNxPjSuS8cFDI+sd4kIWKJi?=
 =?us-ascii?Q?qYuSELl5G4lLysk6NcIZQSGGQSS336c7KQZ3cCr2FKQJ0RIJlcWiUQRXwhEE?=
 =?us-ascii?Q?Tlx7KbOlIxKil+STCmUJsCz9E0tKp0Mu5ngTEoDN6f69pKMkMcW4Tb25dI1b?=
 =?us-ascii?Q?BWiRqy0pLcNMJnAjTjczJSIZDKzMi0b1nMx7jeieim1EnOulXT3pxEd/tVA2?=
 =?us-ascii?Q?nSW/4oL4jGj9jgId3msDJC3c6pr8Ph4vsxKgR8ZjL2jcRrhzKZ/4mW1E/mEK?=
 =?us-ascii?Q?swj5Jbn7owj018Vweb/YxknNuK3On0oy3USL7uKb7E/MzTz/KU2taUgsOPE1?=
 =?us-ascii?Q?TcfmWxFnMcmUYW2TrF+u3Ee31DFib30S87MwAAb66nBYHRdMwOz2kqGAhnxo?=
 =?us-ascii?Q?COjQUd43K+YHKp4789PU8VbhXL1ojNLDos7xq6R+LZV4SpSbpUfbsr4tb/fd?=
 =?us-ascii?Q?BVUP+jyB2uytJStCsl4RsApy3crk5Fcy4MY/ufK/08eL/MIsC3O8j1jDXJYj?=
 =?us-ascii?Q?TzPt41amnX4ebn/L6HsyO47fGMgwCnDE7Rd8CgY3QNmjm8TmUnHxzjAcuO8O?=
 =?us-ascii?Q?5s1ccHEG6dtlUAmbWQLyoLxnSSADZ0Q3S1u6McCT3OX+odZuf5rdKfPHROkR?=
 =?us-ascii?Q?aIlZMSiW6RBuZQqWWVJfAY1Wj60UkQPXvaKCl4gahlYC/koBMAuOhPT7miBi?=
 =?us-ascii?Q?KgqfFue6YxyuG140uwoCci6GgkUpLLlHjsV+pJauaaJ5gYddH3titR+0KV0b?=
 =?us-ascii?Q?ojJBjvpVGuQYkSeX7efOO0sPLUyCo3i1uk00ZQluYX+o1truRc4jn9b687pK?=
 =?us-ascii?Q?35b8DY8lu5bCZfVlUc92fAPfduHFf70GOXwPUTSLMepkYMhlBB9qL0QE0gVE?=
 =?us-ascii?Q?lPIrb8I5IQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94162de9-409b-4f38-8ac3-08de5a48120b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 06:24:32.4240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s0A4hRW4veRuHSel+bWjG0qJn2jT7HEx0yZ+vlzwqltqHoguIHrqnpXO+hVWe11zIq1/xspfXTCJUs03wQt0LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF01781787B
X-Stat-Signature: ufxtzwgg94wb1wsstqzsfifrubh5x8gh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4C8FB1C000A
X-HE-Tag: 1769149476-99949
X-HE-Meta: U2FsdGVkX18FS7+3EjWYZpFGhMcxduG7rLMB+2COg1jZirDMNRG8ozfKBY3hFTjmq40vboMf1qvTCEt9ZB6TjCQx7kGVem2gATFtpY4yAQMgT+4OAiDBuMlew8iBP2OuHDFCVN44kBs0HP4MBjB72qWVRbVpHhcZxqvF52/kJ00skUR3RcDL009CPbAuwGL4z11FDmLg/th6qzogulr/hDVHImsjU0H4z6Q43rGijY4mW2yBcqYjRYMWIQl6bPB8ON3JuCzyjK/cb0Sp8iDsEpxU8wzgWZrIF7BVI0yI32sENq8Vy3kMhnxWy1PlWidGzszEdraBiFjcsdHkyII8NUmEvJ0BSXCWJyPgEao9nDTpJp6QRWG+QY6Tk1y4/WDj/xGYPgp9Q8ayt6NiDSad8v53LjBkzDZhEILRQK3NtinqdB0vJE1M30Ft/9z293bVb2AyppYr0uCRbrA8CXYNMkQeIa4TgBOZ3BcSrmaA2lZMPXdgweKPrDqGuh8+eH0ddhg9fb/USO3yjfUQJPC7sNNgRypWEGHs6SlUc2jCg+OHH3PNNMTttgNyp1U/zzgJKUgp+4by8AxUm48K96ty+CdSZnFtQVf76mxzYSYcD7XWPmWwory+g4pYGJAyLPCfDjSenB96sWOIVBCcbO4ZeolIGwxZmKL7T9N7KfU7qE0JtB4kyC1yupsJWXphwdafGnLGy7UsDIh0abJ339jZzH/VhnP/zmDbDoOE12cz8C/rJFr/HcBCRSMFeeac//xA0X8c4VAcQFQ3BzHGkmwOrhw51r0VjZOdX6HmlhG83PN6/d2ChOrWkFzt/HKJa15ke0m0lCTCPd5YqVtrnrNb+M+5tr9eAAUH5eigTLQKIXd7AzkYLuz0hVtgUMF2buFvlYJ8H3vVXo1rev696Mwx+WTG9uAzkd/5MThCdnmWwbiCjTNVcqdN0biBOHhUTE229kPzeChYx1R9CG1Duca
 7zaINHHg
 IyC+B0AGXIkNgwLvIaWlvzhzaGMHYZIxcRk5yKbJdvU2acyYuxk9vBO0U8xws3Niu0rHRsrA+01fao0tKwmFZrVvJGeYIb1K0ThRfED3nCr2HomR7x+NBo9SNODuRPPU0dReK+Z1dyTpIpeQqOtz3THz6FroipacIqT9u/Wz+X67ahOrACyQSzUgXdJLyxAhMgEOjfssgZEUwFBLzKuV/8mwFiqWIoIG8wUCWSax0fGvHq8kocSoJZmx2NJh6lI/3LTxvtaJ9INRi2+4XnMl5sqHBX3/rIOHavqT4AoslYX92vgjs5/g+iYgxHZ3XAfPutneLiqVzcOQja23E8hvI1QW2b1qG0JfazQ1M8kXFiWOatdbo1vpAl1RJ+IbZ/3nHqoJ9qgePZRV/c+2aqNwJGZp94fZqTl2JddKi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal pfns and must be handled separately.

Add a new flag PAGE_SNAPSHOT_DEVICE_PRIVATE to track when the pfn of a
page snapshot is a device private page.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
v1:
  - No change
v2:
  - No change
v3:
  - No change
---
 fs/proc/page.c     | 6 ++++--
 include/linux/mm.h | 7 ++++---
 mm/util.c          | 3 +++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index f9b2c2c906cd..adca0e681442 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -191,10 +191,12 @@ u64 stable_page_flags(const struct page *page)
 	         folio_test_large_rmappable(folio)) {
 		/* Note: we indicate any THPs here, not just PMD-sized ones */
 		u |= 1 << KPF_THP;
-	} else if (is_huge_zero_pfn(ps.pfn)) {
+	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE) &&
+		   is_huge_zero_pfn(ps.pfn)) {
 		u |= 1 << KPF_ZERO_PAGE;
 		u |= 1 << KPF_THP;
-	} else if (is_zero_pfn(ps.pfn)) {
+	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE)
+		   && is_zero_pfn(ps.pfn)) {
 		u |= 1 << KPF_ZERO_PAGE;
 	}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f959d8ca4b4..9fe63fc38155 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4623,9 +4623,10 @@ static inline bool page_pool_page_is_pp(const struct page *page)
 }
 #endif
 
-#define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
-#define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
-#define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
+#define PAGE_SNAPSHOT_FAITHFUL		(1 << 0)
+#define PAGE_SNAPSHOT_PG_BUDDY		(1 << 1)
+#define PAGE_SNAPSHOT_PG_IDLE		(1 << 2)
+#define PAGE_SNAPSHOT_DEVICE_PRIVATE	(1 << 3)
 
 struct page_snapshot {
 	struct folio folio_snapshot;
diff --git a/mm/util.c b/mm/util.c
index 97cae40c0209..65e3f1a97d76 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1218,6 +1218,9 @@ static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
 
 	if (folio_test_idle(folio))
 		ps->flags |= PAGE_SNAPSHOT_PG_IDLE;
+
+	if (is_device_private_page(page))
+		ps->flags |= PAGE_SNAPSHOT_DEVICE_PRIVATE;
 }
 
 /**
-- 
2.34.1


