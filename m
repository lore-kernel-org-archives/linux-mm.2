Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC4DACFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 04:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0E746B0012; Sun, 23 Nov 2025 23:05:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBE746B0022; Sun, 23 Nov 2025 23:05:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5F116B0023; Sun, 23 Nov 2025 23:05:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCD266B0012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 23:05:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D16B6139E2E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:05:50 +0000 (UTC)
X-FDA: 84144162060.16.E6299B2
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010018.outbound.protection.outlook.com [52.101.201.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id A0E2D40010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:05:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Ijyla4YR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of bharata@amd.com designates 52.101.201.18 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763957147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3Ei3zUh4jbHQM0LzQS3icPpR8ijq3H1UQ3lSGxEQiE=;
	b=xhZAQFwibuWEcUMEEHDEPF4gxNxQ0i+VdE0tT0rWSbG2VBomsOxiVpbKyBunjm7V8TxI0r
	H6ZPub0nDEEUcTdOW5TyRfY4bMmlz6XTOabG8cLk1TSjGEYLOO/AkY8vvq+ESQejMbc18l
	ppcXjOPDp7bQvqykClSb/O8PDUcLu28=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Ijyla4YR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of bharata@amd.com designates 52.101.201.18 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763957147; a=rsa-sha256;
	cv=pass;
	b=Bry5Ju6EmfooNNR6PrjE0wYSmAbK9K3RZ27BtZVXWEZ1XfofkGejqXDoWFGwEhC+lKDOvD
	RHFbFJGB9lunLb/kO3vQAUiztYMgNKRGT+o+yblJnxNtjhaoO951msuV6n5XZyP4xK/1Uz
	UFpXNA8y7eLKijeUN4JLy8X4iGV3xzA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sn1WYh3rGjm/ULt5r5AkUOagwKU49g1xxoDBS8PiZ1DBzaDLkl6BQ9yReepTxXAppE/wRxFzeGgcD1AMXNCCjhaP5bASTJUtwXmpSbn327w7G0chiK/ltxQlqAaqPDJ45buy0ZCIAf019z8rc7tyL65PiIPRF6AZNCIvQmPn1jcjchuMLmO9mvx3Orx+/jyqi0EiPnkoABq351zztXbtJDPotgXdXQoOvR/HKpLfyZXu9jwEp90cp2Hz//vsnq5ePoSgZql+aP4JQ/tP2KPMEyqhpjFUZ1j2FJlT+dT2Ua2401FXEGAoPN6oGa0xxpXHJPv9Yq7r0lT4obXoPSEr8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G3Ei3zUh4jbHQM0LzQS3icPpR8ijq3H1UQ3lSGxEQiE=;
 b=Ht/TqK1s/AErYl14bBUTRVUCBL1F8ICuHqqiSeLsDQCO8zMB7vIMaLqP7Ib6/+I4fgASgnboOjIn9W3DdMFtnAKNXMqYTqpa86GuAXw53lygl9g4gTi0+MXvm1Rsc7gpJosAcfPqu+YsPNRa2gltZSMX7OTMBsDLxExKEH6My1QAs8jlIMyMySUde2kfvmkk0nSspTHLTabk3iq2uZIUdhbNgOy7Df06doffcd4Hh0hBKQPUp6Ll8gfWa9uhJOZhep2cpOZTGNDZ+YWZAUF4cSZz89xrrnhFkyI3Y7VoO7Fam7kwLG2TuF4bnIpl1BZY6EaJ4r0Ig8QppqbYsu6U7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3Ei3zUh4jbHQM0LzQS3icPpR8ijq3H1UQ3lSGxEQiE=;
 b=Ijyla4YRrBuwGSwZTK84U/fyzMlM9wAI0CaU5dZSd/hdrL0dyf0I82vjGTsal+uRPW17Veft7WkRxfW2ksqeApn+D/1qqmpVtufBZnBnHkisrYK+GXLDB7xUUxpBG0q42xYE45TgNVTWHQaEecZrC8sT+bIOOd6AfVgebORBzQA=
Received: from PH0PR07CA0012.namprd07.prod.outlook.com (2603:10b6:510:5::17)
 by SJ5PPF6785369A4.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::997) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 04:05:41 +0000
Received: from SN1PEPF000252A0.namprd05.prod.outlook.com
 (2603:10b6:510:5:cafe::34) by PH0PR07CA0012.outlook.office365.com
 (2603:10b6:510:5::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.17 via Frontend Transport; Mon,
 24 Nov 2025 04:05:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SN1PEPF000252A0.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Mon, 24 Nov 2025 04:05:40 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Sun, 23 Nov
 2025 22:05:40 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 23 Nov
 2025 22:05:40 -0600
Received: from [10.252.223.214] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sun, 23 Nov 2025 20:05:36 -0800
Message-ID: <77fcc8e7-9c6d-431c-ab4d-7b28a708ad1c@amd.com>
Date: Mon, 24 Nov 2025 09:35:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Linux Memory Hotness and Promotion] Notes from November 20, 2025
To: David Rientjes <rientjes@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Fan Ni <nifan.cxl@gmail.com>, Gregory Price <gourry@gourry.net>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, SeongJae Park
	<sj@kernel.org>, Wei Xu <weixugc@google.com>, Xuezheng Chu
	<xuezhengchu@huawei.com>, Yiannis Nikolakopoulos <yiannis@zptcorp.com>, "Zi
 Yan" <ziy@nvidia.com>
CC: <linux-mm@kvack.org>
References: <58dcd4db-a923-0d5d-37eb-1a539f1f275d@google.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <58dcd4db-a923-0d5d-37eb-1a539f1f275d@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: bharata@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A0:EE_|SJ5PPF6785369A4:EE_
X-MS-Office365-Filtering-Correlation-Id: 91e0be14-93ce-40c8-cd98-08de2b0ebb86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NElvSjhXbTA2R2IyR1VmYjZYTEtuelJpR052UDhacGkvYlJqbXZaNVFhd01r?=
 =?utf-8?B?aElBTGkwbkxDbitjNXREejY4MDhkdWxlT0lNczRUWFJtbUo0cTVVV2MwSUlJ?=
 =?utf-8?B?UkJxOStNUGYvY05pREkvK01RbDNwYjhpWFhrWmMwSGVQYy9RNWZ5Q0JneVBR?=
 =?utf-8?B?clZWdEI0c3dKa0VBSGRIRURlQXZKRG1LWVptRlJocXFjeDFlWWZTellOa3Uw?=
 =?utf-8?B?bnZSaWliSldrL2VFSnNXK09Zc2Rrbi9ockRXYlNXcHZQUWM2QTcrVUlNMDVS?=
 =?utf-8?B?MFdPcDRaTGNZREE4Mkx2UHZLM2VCTDZUb3hvRzZmck9QSENRMHlEbVloNHE3?=
 =?utf-8?B?cHVSaGRVcXlNbnV5akh5RE1FVjh6ajBMSVJzRDhvNCtpSlJFQnloaVRiWkJJ?=
 =?utf-8?B?Qm9kZENnSlRmVERnUmxYUFQ0SlU5bStDTmRlSC9selFPb3NmZWdISWIyM0cx?=
 =?utf-8?B?TGRWbzN1d3lTcWx4QzFZOGlaQWJMcng1ajdES2NzdXJwbEhjZWtBMDBQMEZj?=
 =?utf-8?B?bWQyY0lRTHcvb1NZajdOekQ4eWp5eUFoTi95SW9ST1JxTXA2dzhpYlNxNjRO?=
 =?utf-8?B?VHNYN2NFcVlmUGxEZ1FFN2NKZ0FKUEowRm1Lb2hMU0F3NGM3Tkk0YlRYUDg0?=
 =?utf-8?B?aUY3VFFZbElwZ2NYTU1yb2xKeVcwTXE0ZkVmTlYrV2JqZjh4Zld2bXRHcjZX?=
 =?utf-8?B?STA4ajlKcDFvRzkzbUowVkhCZElKcE8yaCtGQ0sweHcyOUJJVEZMbHZZSHo1?=
 =?utf-8?B?eXV1VzNhcXhPdW1CLzR4SEUrSnhUaGZTN0E4OU5qd0N2K0d2aW91dXp0eDk5?=
 =?utf-8?B?Vmt2YWtMTnU4STR4QTArRlpZdFBWeTZBOWw2UmErbTRYU3FkWXRZdlN2TW1O?=
 =?utf-8?B?ZmQ1VUkxbnZtM201cDZJdlMwREdDWkltdHBqMXBHUVVYa3pKa2pRUWVXdjBZ?=
 =?utf-8?B?ZktabnUxOGhFMmtQNDhkeFJ0TUczVnhjR2p3UXR5RmkxeHBzaUwyeDNzNm5E?=
 =?utf-8?B?UlRQaXJhSUx1WnpqeG83QndKQjBGQkI1c1ZsSEM5cW1XeEIxbWFCUmo2VGhK?=
 =?utf-8?B?S2NGam1UWXM2cWd4NjRwaDZZQ1hxSzZDOWJNNG5HVE9FZ2k1NUh0YTdLSUJS?=
 =?utf-8?B?bCtMekNJQjBSN0pVaU1SUzExak0yNWRCcTd6VnVDeVBYQkpDb1NDY1d6T09L?=
 =?utf-8?B?Q25uNEI2V0NRQ2xEWStxczZhQmRuS25pbS94UGJEL29IdmVZRjFEb3kwT1JY?=
 =?utf-8?B?ZWk5V09GcTJMeDUrWWVhaldqN3MrZE92TVp4Szgvd1IvUGFqSDdqaWJTRkVF?=
 =?utf-8?B?cWdMUGdHYkQ5VUNxb2EwNUhrQ215L1U4d0pXK2FrTmhiMlNZaUh3aXRxUXRN?=
 =?utf-8?B?cW5ZMGRnYThwNjRZS21reDJzRlRTb00vYmdCcVh3WUdSNURvWDZkRFR6T1k1?=
 =?utf-8?B?WEVyNm05dHNzWEtaM2V1RGRVdGhLanN4UlNKajhKdWNlL0tMUHl6blFrQWRw?=
 =?utf-8?B?UlY1ajBCTUlGbjhiWlN4SVVUUzFwYjhYcE5vd0FZYTNJaVp4Y3RTNVNoMWZJ?=
 =?utf-8?B?Z1FXOURrNmUxQXJTcGluRDA5TG9aamx0M3dmY1JESHgzRGZYT0orcVIyTzhq?=
 =?utf-8?B?a0lmNmhBL3Rha0VYeXRjNzFqNUFSMDQyeVpWck85SEZubjNZMTB4bnA2VVFZ?=
 =?utf-8?B?bGhZZmpkbUVrUW5mK29OZG0vNzkrNDNHcHBiRkNYTGdRT2tLT3ZSbXJwV0gv?=
 =?utf-8?B?N2NyVXZrVUpNOTVSb3J4TU13TUlJQ2NzV3drOUw5b0ZHRWpvQUY5RFRsUjI4?=
 =?utf-8?B?TmVoT2JKUGNzUVhhbllqN0VvOTdqdXI5TlZkOVBJU0xyMnJ4ajIyNGVNeits?=
 =?utf-8?B?WUpESUFpVDl2YUtHQXZyNkNrVmYrRXhZcEpSaU9TcHdiZWhpZ2hqVVh2VnZm?=
 =?utf-8?B?SjNubFF0UUk3NUZYN01KdTNES25rbkoySHdlWm5GNzhBVWt0OXpxNjJJc0dI?=
 =?utf-8?B?a3BwUzVmN3BsZXljNVQxZFBiMTdlOVV2QzRhaVpLUGQwZnRsNDFPRDB5Rmhw?=
 =?utf-8?B?OVJJQm5GczRIdU9zdXhBRHpRazh5RS9pRXBJN05lNWVPY0xnVWsvS0dSTTZG?=
 =?utf-8?Q?rPVQH8ebgcYuc0BroJty3rhZQ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 04:05:40.8233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e0be14-93ce-40c8-cd98-08de2b0ebb86
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF6785369A4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A0E2D40010
X-Stat-Signature: nko5se6ufjiy4tg64k11fhdzxktatxub
X-Rspam-User: 
X-HE-Tag: 1763957147-690627
X-HE-Meta: U2FsdGVkX1+0BqXyCIJNKIMnAa6OpapE+NRAXmGuJzCcN2uvDyQjZcBiXlbFBicEdyS7gKrIRlBEC0q1WRd9HM217MXE1rZGRYGTwlQTdzEP/kWzbqSXD22xM2skTpRmPCoVn9KcOnPJU2Dm4OwimcNtUAhiJ/kTbOl/QnCUUgSKSBIWUMSp9+T7+IfUhIwpnt0wDiF1t7T/pVjLu6j+8FZQKyIBdHecKdyvHt8wIv7AcFYguKL6m+5GfZOdfrp0F2rC3aZOG/KGtDFxOtnTLtE4yH1SGT2LUxM/2g+Q7OMoQZhLeiqr3sd4mDmyWK+KaX6krLUGgDvIyg2m/ybdehSWq4BpKFB9RO0MM8AcnqmpJEfeCFtIaiLNaiM3XWfm6JbxqQcrTEae63E6BQfgcckE8gG6VwwJ0Vl0qtKuBSAj0cCeoMbvfGovlrOVFG77DUWTTjRXqWI2aStdUY5e2Ry3NOXB6qPvdKixvUgvTaGKt9t/omNgq6/Pcdx3N1e1TKC93hlC5iKKO7A1SWDlCqHfwIwVUd1iPpwnZ3MDKnwAu51QT90r2ACUFnhe1HCCL1bF/IY1bwHdn4fP6CfNvE8mfwp6WylxTZM8Z03SSirZE8L6Y53Mf8zsX1p7XlzvwMDH9keNrowvEhCR/d36fksZhUubDB91yN0PyfDAxLjg1idsmyooL8Ovt48RLQ+ZEdN7wyWjYg9h4JttPUr2JnBy6rF6/Hjg2sCo6eN3+CRdsWYy6yiaV7ekbjw75jtAIQkW9qQ4fV+fbBMCeoZOqIkVywsvX5WOpgZmcJAFpZzL7PCzy6WQ+4w+9oixqRx6UphZhaiiBtKvrcnX6BuMH+3a9xsEu2D2bxoEedlNtxCfns4zpUwFW81k9gCUmW+leHQhJgJYbDQKrjlR17j2j0YfureHme/Ywq4PQO3TSWm0iYzEXwVPbnTO/3Jr5Df9ccSSc+SXk0K5b/QogAX
 Hyu762eo
 bYx/esiS8pSz+14zT2ceUtzN1GCNKyPxVStjUqSpdUIz1lBYwqmsHKGHMaIJkdvn1j0rSjhIxnCCyhNd/NHsE96pnV8+mYHszOrRJb0H26W+OikeRUQcR/6mJPhaDrN8w1XmzZUXv+HZlH7OxI5rvutZlXgUT46fsanHUPmFnk/6bQBQLLZyj76C2BVt+C9hvMUAe8F6+KLPbLrbfMrzTKDDz08NyiEofxIJqGxcYBJHz0QLUKgm3QuKRCxO8NKD8sYRM8eiuRV2XEYidEjHDxdSauzGKYZz/Rd5YLrScB/OJ2G+7p/oqZta3dmL2rRc6Cz1rXQnHqjAx6uYX6w2tQEQiAAfSj/y3hL0RXq42O3/JB9V7sQkqVHrHxT7kTiepuQ74xelHYQfD2I/QC6DpNObdWz4UeRs+Hj757SFe1BOi58FK/H3LVHtZK2ocjRGgexsfBfUeyOLg6UcQDkpSc/98W1HHTPjTriKO60pn67k0bzQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24-Nov-25 8:34 AM, David Rientjes wrote:
> Hi everybody,
> 
> Here are the notes from the last Linux Memory Hotness and Promotion call
> that happened on Thursday, November 20.  Thanks to everybody who was 
> involved!
> 
> These notes are intended to bring people up to speed who could not attend 
> the call as well as keep the conversation going in between meetings.
> 
> ----->o-----
> Bharata updated that he had a set of results for the scenario that 
> involves promotion upstream, he posted this as a reply to his RFC v3.  Any 
> feedback on that series or proposed benchmarks to run would be very 
> useful.  He was also thinking about consolidating all the tunables in 
> sysfs into a sub directory rather than have them in the parent directory 
> for MM.  I suggested this may also start out in debugfs until the APIs 
> become more stable.

Sure.

> 
> Bharata was also planning on redoing the NUMAB2 support so that its 
> cleaner and the page movement ratelimiting and associated logic is 
> separated, which enables using faults as a source.  He's also planning on 
> using folio_mark_accessed() as a source of hotness to cover promotion of 
> unmapped file folios.  He'll be writing a dedicated microbenchmark for 
> testing of this.  He'll also be investing additional benchmarks for the 
> overall series as a whole.
> 
> ----->o-----
> Jonathan Cameron asked what the general feel was about the memory 
> overhead: currently this tracking requires ~2GB per 1TB.  Wei Xu noted 
> that Google is taking a similar approach but with one byte per page in 
> page flags.  If just for promotion purposes, we likely don't need eight 
> bytes per page.  Even NUMA Balancing does not use eight bytes per page.  
> Jonathan said it currently uses 33 bits per page so some shrinkage might 
> be possible.  Wei said promotion still requires the per-pfn scan which can 
> be expensive.

NUMAB does the promotion at detection time and hence it has no need to
store information like target NID. When you want to do batched migration,
which is separated from the detection mechanism (preferably using a
dedicated migration thread), we need additional space to store all the
required data for hot page promotion.

Here is how I am using currently:

NID - 10 bits which is the max that CONFIG_NODES_SHIFT can have.
frequency - 3 bits to capture 8 different accesses
time - 19 bits to  accommodate 8.73s time window at 1000HZ.
ready bit - 1 bit to mark the page as ready for migration.

I can probably fit everything within 32 bits as NID can be reduced at least
by 2 bits. However I used "unsigned long" so that atomic bit operations
to update the hotness parameters become seamless with machine word size.

Regarding per-PFN scanning, currently I am scanning PFNs mem_section-wise
and hence it should be possible to completely skip those sections which
haven't been marked as containing hot pages completely. I will try to add
this optimization in my next iteration. Despite this, the concern if scanning
thread (kmigrated) will get to all the hot pages in time is still a question.
At least in my pathological testcases which generate a lot of hot pages, it
is not coming out as a problem.

> 
> Wei said there would be one data structure with the information so we can 
> do atomic updates on the hot metadata and then there is a much smaller 
> data structure that tracks which pages to promote.

Yes, that's what I had in my previous version of the patchset with hash
and heap. However these are the issues:

- Multiple data structures, more space requirement.
- Cost of keeping both data structures in sync as frequent updates are
  needed for hotness parameters.
- Needs dynamic allocation of hot page records which is troublesome for
  large amounts of hot page records.

Wei - I know you have often given inputs on efficient data organization
but it would help if you can be more verbose on what kind of data
organization would be optimal given the issues I have highlighted.

> 
> Raghu noted that in discussion with Bharata that it was pointed out that 
> the tracking of memory here is only necessary for the low tier since that 
> memory is the only viable set of pages to promote.  Jonathan noted that 
> may be the majority of system memory.  The metadata itself is only stored 
> in top tier memory, which is expensive.
> 
> ----->o-----
> We discussed the benchmarks that we should use for evaluation of all of 
> these approaches.  SeongJae noted that he had no specific benchmark in 
> mind but we should discuss the access pattern the benchmark should have.  
> This should have some temporal access patterns but also have different 
> hotness in different locations of memory; secondly, the pattern should 
> change during runtime.
> 
> Jonathan said there's been a heavy reliance on memcached but that's not 
> ideal because it's too predictable; we actually need the opposite of this.  
> I noted that I've had some success running specjbb and redis workloads.  
> Redis is interesting because it does not always observe spatial locality.
> 
> Yiannis noted one of the challenges with specint is that the duration of 
> the benchmark itself is not long enough to assess optimal placement logic.  
> Wei agreed with this, the benchmark would need to run for a long time.  
> Yiannis further mentioned that these can be used to over-subscribe cores, 
> however, the induce pressure (and consume bandwidth).
> 
> ----->o-----
> Raghu updated on his patch series to use the LRU gen scan API which 
> iterates through a single mm, this provides more control over the memory 
> that is being iterated.  He was working through some issues in the patch 
> series and may need to reach out to Kinsey for discussion on klruscand.  
> Jonathan also provided some feedback on the mailing list.
> 
> Raghu asked Kinsey if it would be possible to have an API that scanned a 
> single mm; Kinsey said yes, this was similar to what was being thought 
> about internally.  Raghu said this would be useful for integration.
> 
> Wei asked Raghu if his series will integrate the scanning and promotion 
> together so that when a page is identified we can promote right away.  
> Raghu said this was implemented like NUMAB but does not happen after a 
> single access.  There is a separate migration thread.
> 
> Jonathan asked if we necessarily care if we lose some information; if 
> there is a ton of memory to promote, we can't migrate everything, so do we 
> care if some hotness information is actually lost?  Wei suggested that we 
> must have a mechanism for promoting the hottest pages, not just hot pages, 
> so some amount of history is required.  Jonathan said that if everything 
> was insanely hot and we lose some information it would readily reappear 
> again.  Raghu's patch series only uses a single bit from page flags, Wei 
> suggested extending this.

In my previous approach (which had a list of hottest pages in the form of
a heap) and also in the current approach (kmigrated scanning for hot PFNs)
the migrator thread can use dynamic frequency and time threshold values
to filter out hottest pages from hot pages.

Regards,
Bharata.


