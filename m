Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37DFCA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80856B0088; Wed,  7 Oct 2026 07:15:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31A26B008C; Wed,  7 Oct 2026 07:15:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8F66B0092; Wed,  7 Oct 2026 07:15:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5EF6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:15:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB856A01AE
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:15:14 +0000 (UTC)
X-FDA: 85295573748.09.A72FE8C
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011071.outbound.protection.outlook.com [52.101.62.71])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB435C0010
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:15:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DilbTd46;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791371712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rAWjvEwC8G4MkppJf1b/VCkcASjryyiYlkvSt5LKzF4=;
	b=Nbht4eoW+1LqT1l7/s3qHL/aQPttqbl3mNuqJAP88dBJyNXn2ZHNOhnr9QfinrWNDV8BMh
	iXkCW2AtqQtUgginWRmrhLNWH7SEmUroqlnMgQLgAa3bSIq6ImqfcB8jOdrk7X3WgY/pwp
	6N8frLywHMvqPjzXZlxW7PGrTXaObVs=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DilbTd46;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791371712;
	b=fsTihGudzvLzTmeJUillOVdo+g/J24J2q86wNsTaNbGJAuS9gi+iIsznqEWRR2I1IgC8xs
	u+it3IRIcwojIj+dt7P65K/hrxg5oMJ8ln2jchwHbTr6TQQ1qQLMKKiBqM9O/ptDagIUQz
	kN65ZB+UcrW3ryyKEF8I7jXKx9h12YM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DOhHxXiBRkBuw1QLYPmHT4Hhg5i3CwM5fmJgQqLsLlcgLDIIiinNEbtDg/Qfz9M3f2AVAafAn5RnEO2ohdRxzLtKY7uXQpybNc6XgbZWab7UbfDDaNBMWZEKMRbYuHSWinm/aIzftx7ReSe9n+Yt22eNK6jauPqmYdKQndnvFg0EkrCOfGpyAqMyUt4bMZwVUi2//mnJZnXs0puefc2s2lkJFlkhwve6plAvU5VaFYDLAWFSDAXyN3ZmnzyonAYKEU1MRqgGWTrgCEIuDEXX+xNRY03xwmoYITgxFOFhXq6VyGInxmpGQq6hLDtC6n5Ac55esLi5u+AdD4MtBNLg0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rAWjvEwC8G4MkppJf1b/VCkcASjryyiYlkvSt5LKzF4=;
 b=MpQOs/BLei7xQJlAOE3+U7gvg8ha25HUSbvojcktN8zRRLyH7vlTpCi+h5nnVisNgDxtGADaXbl2Syz2rs/3LiKdlRZ4rSo08uSo8SuNtnANTfEw+E69Ic9rmy/oELeP7s0kbaNG5kS5vBtvfpD6FyNi1fc89/dN5WQTZm5VLZSDjrh+397IQ8XYeSGm3yXwqO6hTIIcwtBa1w2kBtBNE6RyvBdRTuz+HmgOWiNxWgDQ2qRPmlbc26ygiH4m9oLhhhZlUGmiPwUFF06zJ4fyY5/ak0VIdwwk8MJaCcZt+TOMqowyNwqnozS6LA1JW99L/LghWi3aiKvoZSAmJHPguA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAWjvEwC8G4MkppJf1b/VCkcASjryyiYlkvSt5LKzF4=;
 b=DilbTd46l8JC7eel9I2srpulVlgc8n2r5C0fmBUpJfij/TxNLpvgS5L6Xunf7FHOTUbF3cfSpWFdrxEDnYyjVj8L4D8pf6fhmrFbbnvwShxFJKLbiuYBZGti0vFGlz3r4Ro4X0odo+iSjhStgyMy6eyPl2a4irOHlZg1o/Ik5VUCHruQ0MbJtPs01x1CzmtCv4RMOU6dguEKjisGjCo13tSJukyDZvrsVzL8SQ8HG0kmuM7sHHsOnQHtS0xRL66H15K0ByQXmHrhWWlvMGvvQRc77OOxLiRyVSSv4wemIgqsHcESd3lr6HA7eK06bgJeURKqGOueD0HMsckduakmDg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Wed, 7 Oct
 2026 11:15:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Wed, 7 Oct 2026
 11:15:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 Oct 2026 07:14:58 -0400
Message-Id: <DLYK9PJNVLLJ.1F4XDVVRUIQ4@nvidia.com>
Subject: Re: [PATCH v2] mm/khugepaged: flush deferred unmaps before dropping
 a failed folio
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 <outbounddisclosures@openai.com>, <stable@vger.kernel.org>
To: "Kyle Zeng" <kylebot@openai.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261007041001.43181-1-kylebot@openai.com>
In-Reply-To: <20261007041001.43181-1-kylebot@openai.com>
X-ClientProxiedBy: YQZPR01CA0180.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6383:EE_
X-MS-Office365-Filtering-Correlation-Id: 858e7d16-6fda-41f5-785d-08df24643a04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	1l4pqnsED/i/ePkul/4pC9smpgKi9r40Z5K9Opl/+qNnKllKK3nPoE3FVidma5wLe26rc2KpGvG8ZDd0lGVuD9GiUDmRnPonK+U8i6w2GlboXFNxWSgcKmSiY0/G0z05B+VsFEp2suVkbCBDF7Jv4mmCfsAVsogWx67ixYWntVIYHnGXmm6lZmVcmPDN0SoVXNZbnWAUhFIW7dqkOKSQ/4nwyqIpOxs8VSIkcl1L6AailAHxAE6SPGCxB6EdCnsZMhD8p3L4Ts03U4estUJX97X6nodnJnxvtDWrm9C4OFxoCN4JhiSw0PeObiTMSp+AWOaRA2TADuIS5CNGaniSB7kKeELUwRZZvBIob2tyLg346FaV8lN4oSsSGveZlmKMuRVGtEOi7aTPvNW+fTVdxYD+nLk29dlrL41DXtHXQER+wQbe33OAxmlGv2HT7uAoKiqCN/4Euv+772Ozb5G32NmuMeU3reD4/qh3iTjCu/eJM9vyBbfu9Lpuz/eakjEqB4H5PUzpZbVVNb7nvg5iPDjZasWFgYWJFyG5iQH3tL9ajloQq/gMJPudTgfkYQ4bQ4BbQcGWNJ0z7FGbR39OmkA7dAdwOVIsW9ZlYa3+gjEPd8V/eFoeFX1Qf5HSNoMtQZ04ji/o915dxoG5GITEv2rzvNbKtnnmBPbxY6Ejdqc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTdZZEVXNitNSGlnM2NXemQ0R1FEditwWTZsTW5lM0JYdUZwMk9URkF4UVhr?=
 =?utf-8?B?Q25FQjhtOXhmSmZmcmd4YXpzbjJLTG9URTJMWE1yc0Y5anFjUWlQckNOWmNx?=
 =?utf-8?B?aDFxM1prWHBGNlloRXlMTHpxZnk5dnRTZllGYkw1VllsVHc4WWFsaG9wdzVi?=
 =?utf-8?B?NEVCNlBiK01LZEQrZDYyTllqaFJVSjg2eWVtZmFjbWVVTldMaWU1UjRncVNC?=
 =?utf-8?B?eWFGSkd3QkZ3RjVWcGZhWkZUbm1RS2NCeVdxY211d29GRFZoZkN4RG56M1Az?=
 =?utf-8?B?WU45UW5oOXdqQkZnVXFJVjhFQmsreDBVK1V0NmtMc1NKYWpONzdtVmdtSi9I?=
 =?utf-8?B?WnQ4OEtzaDV3Y2dTam1zNEYwcmM0R1dZZEM1RS9VeFVoU1ZSdzhUdll0R3pu?=
 =?utf-8?B?ZnJRakdiK0VkKzJUUzFuTjB6K3NmS2kvdHl4NWRYRVRyVE1OT0ZFUUllRzZL?=
 =?utf-8?B?M0VjNGNWQmdUSEJOaTAyZndxK0k2ZWFzMXh4NDMzNkJKNmd2dWxCZHBJaUFU?=
 =?utf-8?B?RnNJQkdWaUNEQlFxdlFkQWRITEJ6cjZZdzVFKzhXRHZMajJxNlIxTEpwdWhP?=
 =?utf-8?B?d2JDVWpBcXBEb0kzaWh1eDBvNllaY2F3d2dwa1dEalJRNkdKeWUyNWxnY3NF?=
 =?utf-8?B?a2dwY3h5L3o0V3dubXc4Q3QzQTM1NTZENkM5ejF0TXo1QThTbTE5SmxmTUVK?=
 =?utf-8?B?c3liSzB1Ri9QcGpIai9GQUhoYVZJbldaeWJSNkZpYmFUUFA1bDU3UEJCNFVt?=
 =?utf-8?B?QUhtbCttUUxWcFRLSlJLcHN4cFlzTk1MeU45T0hkT2lIRnNWanJhTnpjVWF5?=
 =?utf-8?B?NmVFaVp3c0tBMUtqN1B5NWFjbktxaXp2L1ZWZG9kS1hlMFR2YVYxdEJSa2VD?=
 =?utf-8?B?a1RMRUl4MFBhcUNkSjFYMW42TGYxRS9DUzdRczcwMHRhZ2E4dlIrcnBkQmQv?=
 =?utf-8?B?REpNOWZ3OENlRXlNRUR0cXpJRUhKMnMrSmwvUVZKTEYvTXBKcVNqbnl3ekVw?=
 =?utf-8?B?a3lweXZEQ3dpenluaW4vZk15L2xHL3JQd3ExeHFic0paRGZJM2N3L1FWaGxs?=
 =?utf-8?B?UE1pdmcrU2lFczVGZXhLNFE5dkpvSFNQK2lJZkhXM0EzUGNUR1JNZ09iUHZn?=
 =?utf-8?B?YzJMTGJ6cmdZZzJEdTFJdHEzVndYQWRmb3c2MGVwN29tQ2NBWWZWYjZQNStw?=
 =?utf-8?B?N1Jrb0kvRklRQXZkYWcwcUt5L1o2SGpDY3B6QmgrS3FYMkFtb1lkbStha3JG?=
 =?utf-8?B?RlZjdHdYYXh0azYwcUtwdk9YRWxzT2xXZXc2eFRzeUx4OWZLWFFGbkxoWTJJ?=
 =?utf-8?B?TGZuSU83MTNOS0ZScVB5L0RPK1hRZHZ6R0pMczRYOU5ZQUxMRzVtOUFyWkNC?=
 =?utf-8?B?N3FPNTB0MVdpdGpoa0srRjg1YTFUNFN0VW1qYjdmRUNJb2wzT05Hd211SEtI?=
 =?utf-8?B?M0pNdjlXWE1Cb21WTGUwZjhLMkU2c2RoYktBMmZCRStuN0lFV28wc3ZyZ1Rj?=
 =?utf-8?B?WkE3M2diajEwMTJ2S0YrS1gzWDF1dFhKaTFHRWd5K1BSeGlVSDZGL2tucVRz?=
 =?utf-8?B?dksycHFZaTRKS1dvN1FTMG5yUXlFNG9IZWNld2ZSOURmWGlJZmtkY012N0Za?=
 =?utf-8?B?cE9QZ2tWZGhySGRVY1NBd3ZoSmZnR1o4REtxdEEzMVFXVFBlY0NvcnFoMlFu?=
 =?utf-8?B?Rm02MTBRa0hybGNYZWc1TUMzTzg4NU9zVW5yaGFQLzVCUEs4WDM5NHNmVTJl?=
 =?utf-8?B?emozNzEyR0RLUC8rSFBPdlRNSGc0WmV3VHBPejVUZnBMSEZkNmk1b1FIbFhR?=
 =?utf-8?B?b1VybHRtNDRobEhyYmxaZFltNUNTZ1hIaS9VWGFEUnlBQ3VsSDh2V1F2V3hl?=
 =?utf-8?B?NFphZmRCdXN1YVlHNnZEOFpFUDZiSWVsa2dQeWRJM2EzeVR4Y0NIRTZRVmYr?=
 =?utf-8?B?cm5ha2ZCRGV5b05mR0tQOFhRSWx6NWhGejFpeW5hazRnaC9Vcmo5RkRpS1JD?=
 =?utf-8?B?WE1WVjRGQnhZcUIvdUFEZ2FuUFE2Qi9yM0ZiTUdaeFZGQTBraHUzakcycWlr?=
 =?utf-8?B?ZWhMYXZjSmV3SGgzQzcvb0pZekZ4MXhmdno3dUhnUnpZdVcyVTJLNHhlU1pW?=
 =?utf-8?B?c3RzWjU2bVFTTnRISVZqdEdUaUFWV2RnaGxZMCt1NEVjRlRvclc2ZkJzbmE4?=
 =?utf-8?B?aVc5aGpraHNSdWRtNG9zVVdkeDFURGhwaXZweGZYTkFKQ0ZMZHhhT1lVdy80?=
 =?utf-8?B?RzkvTTFQMktJOWQ1K1BuM3F1Uzh6QkNrbXhQTlBtZ1hGbjVyTFlMMmdPRXhh?=
 =?utf-8?Q?+43uxZVlFaHKvdW+1u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 858e7d16-6fda-41f5-785d-08df24643a04
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 11:15:00.0149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vGjwIJ3I7BvuIosAJBOCk5Ghl3yPW2MvMPD48ll+9/eT5SQIisfuBTZAvta8XoGn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CB435C0010
X-Rspam-User: 
X-Stat-Signature: 35iy9srf95cgs4571skjuhic1eoccqti
X-HE-Tag: 1791371711-356475
X-HE-Meta: U2FsdGVkX198KP3Odwq7TYK8cHx8dE7D8Mr9iANgR/49juxncNB6jp+TMbBpmJ8BuFBpy3UJIM0luahk6t2QEPDUaqGsFFFojQtpkBfOpHxbtoGXgIpTcnXr+eUQ4W7H59iANUhgfV+zJUHTq+bMDB5Kf3eTrzzZCOZiTmvH9Z7/V0m5U1aQCJImNx7aYeILTVbDQ+6l2jkg6MzOP+AAX3YD18GvDnuznAG+9Wu64umyIxfXe7mSNvYBJs7428o3x3yZcGmT4VNMsDGVgVoi/emQPaZGq6ZzDPL5UmQsYqMsQDF9Il9ZvEbk4mjMRN43mSjS78Hpy+TW7/Hk1VDcD2aZCzTFe2ZLIDdI2CIPjkB6zcuiYXitiREkoTg2xYLTO945sjifBaG7b7UHTNWdTxim5Hdmbyrm1GCylH0yOQ1SWrPWDCzWbbAjh9nxRp2tZdP0nx7wWMpdg/3PvDG15Dq6AP+yb+Plni6KmMV9rg2hyEgtPYYaSfXEEGyRO3YtAnmC3M435vKGrfk31sxApIZm0XF9Cz74yDsvfI69Qvne/WTdD/AYTGA4Sb08RyrG5vBEw8He9UwIj09rRjT7iEAsQ8pzlDCaB0V+KXanWXfZ47gAIVxvr+3A879J0gkuvtBNtoY+eaMZqASi5ohxLHA3agK45HpFJ8zMYUrMN/+fBSFi8iPeuK1xrootkgCMzXRKgELoaTPjVGURB3NjSSBKNeqyO402lQKkSy8t9CYHseFnE7p7H2inHgSdDqOWa2wuyF5Vmh1eyxhIEz0kbx8vrZaeQfF3TBk1eGwPjHF62PkxJI22AZ3PspdP1C8J+qXATbuFACLoJb9QStUmnEcSJDhS4US8BDZ4+jNoImR0xhbPlFmVqrkiSHbbRwBV6yyUynQj0FLnzWA6oUDPUYNSgDry8CAovMaLBHJ9yuyOWBGTsDnQW5Rdc5UPXpJcYHm5WFBtdG6bri7Eljh
 UJst/8uI
 er/gkiF2MAA7AlZ/+Nx/tNyEcWkd/pSYbCAev/M28AAfHwDGcBZ03x8yaQIxTFhsqSVrLzm6GWJpKsvhNNcHD1gZn50H8OkS+1gGw+P82LPSgNO38OxUYAm2hNUoVOG9LsPzRK+5gXJaBuLD+YNOa5+229q7yxKIEOqpnf+srv8Z6htfUQZa+0cg5IeUxXnEHSUf1/ybeLvYwti5nazt3/asT7+Pmy8CpQxR3DUak1v4JY+DvUc/tRK7U4/hRdzlu5uS1GULeu4WQEa4/xTGzrVt4Kgo0JGmt9rWffnYNXhryvQEUUs8AcTeBDS3kiNueABNI24O9Q2NcKrHJsVxFKq+M5oTd50X3uoB/eRoTB8D8PK9Y0tYyHtCrp1D3/GM57ZYSYp/alHOyJs3Fq4OsaD1qZ4ZRJdL/tD7oxdM5Kw+5XYicheQ1aPZcAyA0X61ZJWi6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Oct 7, 2026 at 12:10 AM EDT, Kyle Zeng wrote:
> collapse_file() can fail its reference-count or dirty-folio check after
> unmapping with TTU_BATCH_FLUSH.  Both paths put back the isolated folio,
> then unlock it and drop the lookup reference before reaching the common
> try_to_unmap_flush().
>
> The page-cache reference does not keep the folio stable once the lock is
> released.  Another collapse can replace and free it.  With its PTEs
> already gone, that collapse cannot flush the first task's per-task TLB
> batch, and retract_page_tables() skips short or unaligned VMAs.  A CPU
> can therefore retain a user translation to the freed folio.  This has
> been reproduced with unprivileged MADV_COLLAPSE on a memfd.
>
> Flush at out_unlock while the lookup reference and folio lock are still
> held.  The common flush continues to cover the accumulated pagelist on
> both success and rollback, preserving batching on successful collapses.
>
> Fixes: 6d9df8a5889c ("mm/thp: collapse_file() do try_to_unmap(TTU_BATCH_F=
LUSH)")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Kyle Zeng <kylebot@openai.com>
> ---
> Changes in v2:
> - Use Assisted-by: LLM.
> - Explain that the common flush is a no-op after out_unlock flushes.
>
>  mm/khugepaged.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


