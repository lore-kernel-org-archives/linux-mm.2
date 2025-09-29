Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A32CAC5B9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 15:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECA308E0029; Mon, 29 Sep 2025 11:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0248E0002; Mon, 29 Sep 2025 11:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8FBD8E0029; Mon, 29 Sep 2025 11:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C79A78E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:20:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D015B957B
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:20:38 +0000 (UTC)
X-FDA: 83942649756.08.F509CE4
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010016.outbound.protection.outlook.com [52.101.46.16])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8CD0C10000C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:20:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fq9z+ofD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759159235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5htbbp4Ycx4/IC+AXP9+VSATZMoK+7Vl4+nCodaqck=;
	b=Wv2tq1ruEhRfww0A+LVp7J2WotwLUtVavkaxLCFHBG+HYlvG1UWxen23eppWah2CyTBSIf
	S21T2datvRAjTB7XDIzj7SWphqEDUeEj9x43OpcXN5YXZV0CylTh8wuxoWwBFVnaVdZL6T
	Di1aGkePZ0IpS7qhxcQwSTC8Y3qmaVY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759159235; a=rsa-sha256;
	cv=pass;
	b=BoNaXLrUDPGP0CzgxHXWj/Wuy80CaYRlQGlVzm96NwSvO84m+msq59u/iZwolwHhBVchW+
	ctyu9Yz9KFAXh/Fe+4JX/ePATjfiR7Ix3WeQD6PPwG7RRVYOJDirVTakJBGFW7M/l2FdI9
	2fxztAs+SC24eZfj7BBnKa41WLZLkHk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fq9z+ofD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yJdxdFfX9h/JrPAMRgDiwypm1YD9aeKxPdf1LELLN6P60t19UcHkL9ku/TihTx5yp5y9L5cIJnRY/uE8LDHg/oD9aY2dcC6jBRF9eTPoAg+aIh0liGDFU/5tMUN5V1hnR9FmennoQNec+dlm3Wo/9TesoGOTpIAOOYx/L3pCbvsC29rQ74ekYFJCspFctUPeeHvkABwWZsRrN/SnujVLje8t2LaO7j874HoQO1HmxkkuBWlL9PNN1yeOklyOe0ebRJPvzszLk1kGqDSu9yUMcNlcvx99Bnu4SuLdl1bRGa4XAT40U35wMYp3g+erR8qJa224Y2Tr2hhWGAahbcRryg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5htbbp4Ycx4/IC+AXP9+VSATZMoK+7Vl4+nCodaqck=;
 b=iT5xASNKYBZmeH+EPfoLHNLwTCcWFFXrOaD6LVx+WRzGKWJ6hpybkCSSH6pCUZ53Kl9qZ5gHoWPNMl/K5zCxVfGmFLeK77GPfZkeOw+viGDxaOiWKc+MCqwzfZUO3aKOCGA3COANEazhCMcZlg51F6gzzYBDMQx+f64DzpCoV+qaY08dlEDDrpt+qiOMqsqn59J7HKSjJR3diAh/ui+Hv+MUr3q9HL0FcyQj5YAye6FzvVmdWjSEfF1uFgSgestom/Q3o1Q6EeT8clA1JFubVtiIcmOI0So2VIH1oIoEw5Uorox5FL0wmLaDtpDTQeXkuQ4rxfr7iGqD2SvCU799rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5htbbp4Ycx4/IC+AXP9+VSATZMoK+7Vl4+nCodaqck=;
 b=fq9z+ofDeCStI8MHIrGH8diviwX6sNiqyPxKSsqtHw00e0X9lB/B8vC8DgEFFOFHIXXZ9wqqgdWRQhe/xGXBJLqinGHqIc6rykEVGJK6oZOdrbQjvMkeJi1T8daVKkg8XfFdfm7yRk6CG6JX7EtHk9jyNsefyzu45JIr7d/UGnXs8SAsGw/rB1OMErRTCOWVeAZ4EEQs8r5PDvxTNsWbdgY1TI7kSyZP00fe/zXHQ3MKRma6uAdWsP0Ul8v7hm2zmwR+IpCykneyaLACRHpgdxe+sPeCVoZneyRBJQaWxat5RZZBGSdHoajLv4RWVuf8mYlG5I5jP+YovasJ3tqHEA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB8123.namprd12.prod.outlook.com (2603:10b6:510:2bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Mon, 29 Sep
 2025 15:20:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 15:20:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: David Hildenbrand <david@redhat.com>,
 Luis Chamberlain <mcgrof@kernel.org>,
 syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, linmiaohe@huawei.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nao.horiguchi@gmail.com,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
Date: Mon, 29 Sep 2025 11:20:27 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <CB2E9455-480C-438F-982A-AFCA1051BBDF@nvidia.com>
In-Reply-To: <w2kwxcd6br6h4tdn6xigtuf73qklt6jhxvhtcwp7idugycgxlv@vqjx26vrnwu5>
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
 <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
 <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
 <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com>
 <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
 <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com>
 <w2kwxcd6br6h4tdn6xigtuf73qklt6jhxvhtcwp7idugycgxlv@vqjx26vrnwu5>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: 0671cd7a-f5a9-46ed-86ee-08ddff6bb9f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XZR7iM6cgy+s/Bjvcqo1FPxmcTbjEabfSbAmfPfkHQXxdrgWhJopPHphCr3+?=
 =?us-ascii?Q?Wd7Ez9sGJ0mdgybTErbRkUl3p6nBNtprWCJbrPu3vN3tAKMZZR5WLjznZQRf?=
 =?us-ascii?Q?4sH6STksdQPp9tD3u7AXmvpClxOVJSEbt3UuQZZgcqqvyd15l7WXgI/h0afj?=
 =?us-ascii?Q?AGE4uDkYoiatGXZ9edmM9oDYtCVbtprBagAN8bdI3xRaFfrAnkBC/WjHFmzP?=
 =?us-ascii?Q?Y0GC48Gn5xl9ESzoF9d/SV+KbY7kIWUCc6qy6/79jaqGv3MyYDTM6e7/FuVX?=
 =?us-ascii?Q?NrQQxo3gRuroF5gkdaXfaDn6r+s2WA2atst0rMacQwaGNt0GzSsYG3QqbdPu?=
 =?us-ascii?Q?HO3+db98KZIjiYKompfzGvAjfMxDRWLYhmqH3pa45oCR5Z+FCd9ON6gXiKDg?=
 =?us-ascii?Q?zYBdAqHGnpdhyKV3n/TSSZ5wIpuUJvsn9dBgpjh6eg4XiZQn7wQ0MLga/uf+?=
 =?us-ascii?Q?NJrqp/QL7DgiQn3ql+iqHPNTEluBJCOnSPtsj+N3qQ5nSyokgGiaX3R4GjHP?=
 =?us-ascii?Q?Li8lHzPyrtoowbONbisrZd8tYjeCxQpj6MIxEgKC22ektsbMCUjVIfCmbx1b?=
 =?us-ascii?Q?zJQvZZdT+0VuxGtxC427vi0uUwDhvxCvag3Gt+eFupnN7yi9Xi4WKe1AMxQt?=
 =?us-ascii?Q?93kpIuAN7gp61O1YedXQOpDKaqCJ7p4txvg8DGreKHfOsQ4Gwr9HxyfNKDvW?=
 =?us-ascii?Q?PCeNKlTluIfGsZAr9cciGw8P8VkQTMV2rCK1qm8YDzbK4YXXiVaM874iSGmZ?=
 =?us-ascii?Q?MMKoBTS4KjpgiInkYeWWYrZlvylYnNH7NBNeZj0ayCBKUrPwIu6a/3lwXaXZ?=
 =?us-ascii?Q?w+GWiAudmsRkHhnMIY0zxMc5hJIoIbN1+GVTBzNuUZ29cFya08/gTIEQN8dx?=
 =?us-ascii?Q?hz0HK0A4JI5dvGIUy9WmKXGVYw5ZxsRoCxX6SScISUXdzZyFNfahwHBrUkTV?=
 =?us-ascii?Q?YvfqWyYIhIAn5kR3nwCLoRBmuSBABYh/nOMeFEU3jphknCRUBQHrrTs9F4ql?=
 =?us-ascii?Q?PZcYGEJ8e7cT00Iwqza+ZD8TcR+nyZnfrdaXQj6ZGyMH7wFYsi2EYAolPMo9?=
 =?us-ascii?Q?buyn6DbATu9WO+BMCrgOCRvt13V/LLuVdpWwcY5XOAU3gma0Ek1MrPjML49o?=
 =?us-ascii?Q?wUqliQbG4YAp0OO9A7vngH11FnvztXCre4LX8L3dAtFHwIs5q8rwJL2//gmg?=
 =?us-ascii?Q?sO7JFCuvXEHpz59qpHBAP6Wly7uO/vOjsCjM4nUgOAEz5eoJu1CW09NYX4xv?=
 =?us-ascii?Q?3HfghHpD4dhzQ0F5UnxiK5Y4dlKjH735BX7PLP90IAAPm6S//9+p45bTqeCG?=
 =?us-ascii?Q?0puRBQwaF2AXgIQPVhJGx4nJgV6Zg6CK/we4ZtMcm4RN3uovIuENeaBhI6TS?=
 =?us-ascii?Q?zgZWVhG6hKJDQvctJce8IdLMoq9/V2Z+V8neXolCQ6B88339/Ok8JuUMNoOZ?=
 =?us-ascii?Q?Yu3diKKv2Z4iYQAkA1AchZ+ynv8qjjXj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iruELbQCTl0dyN4VLgdOwWFn/AEwP7ze/fyEha9yiNNjWmJW2JR0BBCoaQek?=
 =?us-ascii?Q?uWSXsZ/uD14QcVyg0lBUj6/JKJFrUOpVuzwY6wVWhdx1wM+AO1JH9cS5JXdu?=
 =?us-ascii?Q?P/scDHLGraA38C/6jWK/OZnqMjBI3pM+bjMslhxqH00zUWoSfxrdlPSCzZqd?=
 =?us-ascii?Q?I0FM3KJM9HtdPth64g45b23OmLvOBsmnew4EK3yWbpYELyd8wR2OnkPK+6Pa?=
 =?us-ascii?Q?j/JAm44YF1ci0kDszYTGWJ7zqxLI+tFcwAwWBvZ9nOSSAS8xTsA+I5ME14Vr?=
 =?us-ascii?Q?hWKtbdjAengqH7EZWF3Idc+9yR18P4EKVhNeHr8Fg5j2Dd0NNETHz5a4Kqhw?=
 =?us-ascii?Q?GLDP1Aw7d3DUtR7WrWvupsgqhPNmwe1JcmYtbKFyF1Dq+W+6mEjTqeByxkKp?=
 =?us-ascii?Q?htxIuETzezbnj3F6HKKHj0c7bpPMqcokAKDcADCjhpLNu+vVN/g/FA57TpqX?=
 =?us-ascii?Q?+6McaB0qOj7OhGJ/FbSr2vhb2lIuaCdb5Mv9CjvWDE8rs21/q2r7Y8M3kHoT?=
 =?us-ascii?Q?ddnNxt0GKHdypcZC6dk317v/xqXB220tyHZFwwNLka9iPyGo6c0Y8sHSlcXq?=
 =?us-ascii?Q?Q/Ybx/+2jd93aq/UimPpYLAB09siLgHwsKY6XH8D/l3atAzDCGfRDVtcalBC?=
 =?us-ascii?Q?VdEQA++z+fU/+jxoSKdRQlmPQ3fG6I8fxvCUg8n6CmovHgBo4C03KxbR9rBd?=
 =?us-ascii?Q?yF3e3Hijtg8+kRXtut40f5jAiI9wFNziUwU2/Q1/UgMWLIkj4hgJGjPXWX/s?=
 =?us-ascii?Q?/VXOMMrpuWFjkKYuNuifc7TaOj1/7c/dS+7dzRSpWm3Ld2kiQoDvRwrQ/eD7?=
 =?us-ascii?Q?L2me6NQHqQ0xww3TjWAZfUPHt2GztX3+WwLUmFkNVijK5xg/e9hVCUBzg5Jz?=
 =?us-ascii?Q?z/hMLE9judCJKWhYpSuURWLpeTYVr5K7guJOF9czei0PrK6q2onF44d/VJbf?=
 =?us-ascii?Q?mFvdGuzt47396eKj1B43U6Tv9soYgfjRkB4PHVZTiq3TlMkPIHAFjZhW1P40?=
 =?us-ascii?Q?T5SHcb18yF170tgpMQdmNzNH7aybr+aYWcv08xGlFORG2xUClzi0PHPaAhGH?=
 =?us-ascii?Q?keFf7UYDDvRJKqK0E18Khx/57+HPFN7WnLHZ7dbgbQJithjKlY7NmUOg8eNs?=
 =?us-ascii?Q?e4WlG0of7bFAYm8ILyyVT/hNhPW+xkk48hzyVSeCdAHksi5dGnxSiW503yDI?=
 =?us-ascii?Q?bM2GwHRfIdNndKIN9GT1jCa1WDKv5zIrL20kHdkXBY/BxQzgXDlLdHOmjYsK?=
 =?us-ascii?Q?E568HqHNT25bm0ewE3UFZn4CCytaPvFBgxewnKI95nLWZqcq/pTXgyG7UiGy?=
 =?us-ascii?Q?lvXD10JBzTpkxuAzS437PXmFI+gkmL80O5Y5kRGN9sqKasHRmGlz/XyL62Ve?=
 =?us-ascii?Q?j4Z5I49gXA9NdYW4zVyYaqw43GfbDmYvtCdcktOXjZk9gJE/hAtMG/zn4ujf?=
 =?us-ascii?Q?Af2e4YWGXV3yF43DsQgVKdySSt0dXHVnvTRlEE/NiuUtMHkF7v7PMIbB6Nq4?=
 =?us-ascii?Q?xamuSiYBbefwTPWqrAxKbXK2y7xQ4CV5sYJ0js4s1UZZi3BIJ31/EgGRaSY5?=
 =?us-ascii?Q?09bkPyVvcd5YkkyzuRc9xtFqQzK2TBRHiEevzNQV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0671cd7a-f5a9-46ed-86ee-08ddff6bb9f5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 15:20:30.4378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oAkztPUKK80YK7Sot8IoQL4IVdw4pFnvFDKAkCv2LBLztAk0RLqhgXKt8K6ITsSi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8123
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8CD0C10000C
X-Stat-Signature: zm6ciwzdpphn5meayaq6prq1mtq5eubb
X-Rspam-User: 
X-HE-Tag: 1759159235-220999
X-HE-Meta: U2FsdGVkX1+cv0j2sfyBn9lFKvmUNH2nNRxdDRzxtYPEKtRwYBje8Yis9OABNh4XGbgY1F3irxAsg2uT0tzCT//9xuZ/Ic6KpK87aUr9W6Wd3/BOVfoFEHN7LAnhQsTEp0a9nNqws7qLYMzR6CLVx3teEF/YTyMd/JY39ObRK2Es+S0SOZx+T0ZWr+X6L+05eRQ300vDfmoUoB9HHu38jMnsd+uFdmRuk+aRgJapqTC/tfIs85nY7pEUljcs9yPUIaeg4VGn9J76yH4Heazn555TUW8IXlhKDGYcsnEkEqV9yqt2EWM5l09m6Cowu32WkO73AFlTkruSUa2jG11Uv/2uaZSiuncoTe0KGQ5rSvl+SPqJPbr+SizaDfRYWlY8uQAe0Yn89fAQUMIK4lNPntgBYApHEaP9n0hPyBF5BDcY7XFf7xhQvLaV7Z2pfGkJMvYVRf59f74A90pH2B061hNdy/2k8awwSyKVC+OHLudK6pLHmWGNEKnp8aFaTX9NQWQOpEy5XsM2a9sptadwUGEulV6DP8IWFs7IKIodLpp5nLosupjfWqE/6+Bci7Yn7lWvBf6TKyeaQf701so5WhsNCMVoh+1+26VDSlS95l9qSAzS7Poj/nTIKwDgWoUhhviu26XH2G2xZ7OhPR3w8kC97H1qGTz1uOVP1dObV1fvRdTWg2oM6YDa6YGF+jGWA/ONIq+Nii5z92Ace2s+eYetCy1A1pCAlyZ2QxiQUzaFnFldUWvv975MGlLD+PIUrsEFZy1nkZiNSOZIHP4jyTsXQWOkmsJVMvRtP8tvX9ywRl57Ct2ZA+PxABMSprzTf6Sf9mCGbe4RQvk1sQtJE1OoVK2sLAWxOjPJFhPLGJm6ZxVCZRADPflYkl+lueJCdljEjxceUs9PobY1Sx/2wcyoO2B8YtSHkhqE1fglttRNAg9Kj3wlRWPpNYHOOo4NCxWlH7lVlqw/PmrHVgB
 OjLQ+JL7
 ZaDSLPbapIoVdiNVUoF3rmUMUfNx7bUKCy2VKa08czfyjuFEwln+Pugo9NeFDOHNgtX3jzqLOecBWq+zThh0IPmvJlVeh67K1Up6UKu2PkWOi5o/F52UTTdrRznj99JBdZ3m7P2ZBT3LROZhsy/EMuxiVj8tsmS7UBYTy1ZVAZmw4J2vI34kbuKCWJVoJUffqwbrp3D8qpvtPJ6U9rDseDIYl2Rb2cqjEI0yXr6HBhrQJR2hUi4pr448l2myRU95rSaTRQwfh5gmMDociMaTOMTblkBAd3GnZjo10aYzdAUypLcaOqs2+fw4Rj8BZD7Gk6vjTt6foeb9lpJEWbfv7PFBJHSGzVgcOug3pAqe9sMoVgV11MnrD8k82xcG4yHqELvpO0oKjF/Rh/8kMLbf2IQggctYfOWIuqgPPFWwTVMZEezW2ANiupEn+matHBfDIl9kD+IcFsklqOnX1AJtHwk1JavGWm1llbLnT68Ja4amh7vjZDmGiDhY5ypqT/8YXKe8tpZ7ccvl2EcrVvu/U/mHzVbWfHqCuhwzvEbVD2ne7LE+vdrCsAAybBaU/OY4J7ruF159lJTNkaA2aAB++GLqt4Qz1qp8CiBMZXm+sTOTjnvDWp/HGZmM9iNLXn4xqs/wVr5jXBKC7M6A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Sep 2025, at 7:08, Pankaj Raghav (Samsung) wrote:

>>
>> I want to change all the split functions in huge_mm.h and provide
>> mapping_min_folio_order() to try_folio_split() in truncate_inode_parti=
al_folio().
>>
>> Something like below:
>>
>> 1. no split function will change the given order;
>> 2. __folio_split() will no longer give VM_WARN_ONCE when provided new_=
order
>> is smaller than mapping_min_folio_order().
>>
>> In this way, for an LBS folio that cannot be split to order 0, split
>> functions will return -EINVAL to tell caller that the folio cannot
>> be split. The caller is supposed to handle the split failure.
>
> IIUC, we will remove warn on once but just return -EINVAL in __folio_sp=
lit()
> function if new_order < min_order like this:
> ...
> 		min_order =3D mapping_min_folio_order(folio->mapping);
> 		if (new_order < min_order) {
> -			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",
> -				     min_order);
> 			ret =3D -EINVAL;
> 			goto out;
> 		}
> ...
>>
>> WDYT?
>>
> I think it should be fine as along as we return an error if someone is
> trying to split < min_order for file-backed folios.
>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index f327d62fc985..e15c3ca07e33 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -387,34 +387,16 @@ int folio_split(struct folio *folio, unsigned in=
t new_order, struct page *page,
>>   * Return: 0: split is successful, otherwise split failed.
>>   */
>>  static inline int try_folio_split(struct folio *folio, struct page *p=
age,
>> -		struct list_head *list)
>> +		struct list_head *list, unsigned int order)
>>  {

OK, I will send a proper patch to fix this. Thanks.

Best Regards,
Yan, Zi

