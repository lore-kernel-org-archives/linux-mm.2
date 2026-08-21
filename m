Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE9FC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B1A6B0095; Fri, 21 Aug 2026 15:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F22D6B009B; Fri, 21 Aug 2026 15:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A9B6B00A2; Fri, 21 Aug 2026 15:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 277CE6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:54:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BCF111601A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:54:47 +0000 (UTC)
X-FDA: 85126329414.07.E1173A2
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010006.outbound.protection.outlook.com [52.101.56.6])
	by imf26.hostedemail.com (Postfix) with ESMTP id E203414000E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:54:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OBgX2QV4;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787342085;
	b=10k9UsiARHdIdJ7zEvN8z4xrzK+eK/21/j//8z1sTITkacj6Q+7A4lwvzCnlTlPDaC1ett
	Z2xMPmngh7uEi73EWEbr6QM+eo5S5+NPudz/Zk/fUFYFuXgr49ao5cI7UX0n6/iDDQaQzr
	9T9qAVddar2hapA9E8QxvmR37AyXGS8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OBgX2QV4;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787342085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kfn2XNUnQhNk/50hnbJn7Uq+DCj9mkY9VT491kqh7fo=;
	b=PtFCACJclS7jZA1GU0VvHB2PAYNLwATSqk7gjI26mszcQ9OjdP0RhQDYRhaCgqk3rdKujL
	XFiJnt4Xo7G+4QihqD2zL6C6pjGH/vt1eUjHrwNwYY8nKSpBfc8XPcfjjI2Wkc6CW9BnJO
	SFYTsOv+dEetXG0yf8hvjdnNpPBph/4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYaHQwPm2YUN6tw8igfuHunT1i7oWZId+QPyyW5JAoiDD9gDDDQS5xaHzTJKJjtm5gED9WEVCjrCpc3bVuu5fIrK8Rojl61mAYCO8Se/2OMnlWeuNIZXQApPiUAM06A1WT0R3gla+eKLKaPkS2LfO39/fpW6x7aMPC4aFSvNyeJGNh/vFdlkrYzRUwvbSg8OVmt/v4tWdfHqawjXyE3+dkJMPWg4UQyrzYo0LXOUoK8aAzCOGj042XNWPs5LZz5EMJAXU3WqDk523dNQ0DjWY1AiKk4ZQcKIdfuXBnGeuX6KcMOk9j3tGNxVwI3/c6eGPu80KD8zVkyw60EXMElwNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kfn2XNUnQhNk/50hnbJn7Uq+DCj9mkY9VT491kqh7fo=;
 b=OGbj1ki32MidXRGVCMcKnnwnYZDRm3T24pyWCv1IICTN5IgifD48wgaX4VaNmRjX6gP4PBcy9n8V5gp0AwOq62WpSUX2inkCQ2Wt9j+tSShpnTFGQXq6jmACi7SrxMkuNftpxQKLCNi48s48EGbOhSjIpYwj5LcSgZ9sQrWbj5oJBxUMw8ItzURbe65W3IBQsBczyELA1ejQ0I+KGbiVNhUupssbGK+hENBeCjJyyVw5MSXBIf93OR1CwdyNGTX39IZdNvjp5gCgoYj2VIvSlyCONM0MdPDHvP0rr/apIgcT4tbrePdOTH2kHLMfvSnbe1/7NLapn0+u3dSl8VxXuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kfn2XNUnQhNk/50hnbJn7Uq+DCj9mkY9VT491kqh7fo=;
 b=OBgX2QV4tgKu7Vz9jAjdMDG6TCEhtDile2mmKr5Z3aBOdcoinSmNVX82ePxfznPg1Bwh6Ew/SbGwN47bCxbnhLXToHn/2hjv1pL0JMCSYUVI7ecFOw0lvYq+ual553ZdjaXyRobJYlkKiQAV8TlTrj5rAihlgF5RySmCn6H1RsvXtKSFHmnBNgI0rn/YP6HI7NTytfQJvgvf9sa477Nw8Qftj6k8mcg0JK9Hk/kNYDUAg37g1pfEKeHzHj80ttQHHjtPvIlkkfLwvCls/XeQB428e+3mt0Nybk1VWMhLdUNOcswNWjZkwCp8x6slQMnj40CObmUbWRiUQvH0fqiTvg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by EAYPR12MB999157.namprd12.prod.outlook.com (2603:10b6:303:2bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Fri, 21 Aug
 2026 19:54:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 19:54:34 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 21 Aug 2026 15:54:33 -0400
Message-Id: <DKUVVX548398.14M8UJYNA7BC7@nvidia.com>
Subject: Re: [PATCH v2 2/2] mm/page_isolation: guard compound_order()
 against racing
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
 <wangkefeng.wang@huawei.com>
To: "Qi Xi" <xiqi2@huawei.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260821025501.2752563-1-xiqi2@huawei.com>
 <20260821025501.2752563-3-xiqi2@huawei.com>
In-Reply-To: <20260821025501.2752563-3-xiqi2@huawei.com>
X-ClientProxiedBy: YQ1P288CA0020.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|EAYPR12MB999157:EE_
X-MS-Office365-Filtering-Correlation-Id: 6311d4e3-6a3e-4d90-b60e-08deffbe0638
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Jjt759l0Awr+3Rr/TApGNeEAmscQ6aiebV/yfhTlZe1E4Z9lPTXhTzcWV5p+GSR2DpkwZEVdTLzezbE9crX3EJWhWbb58nRqPD1HXRGht9pMUuUGhl70dKGgI7k33TFbIPAWBgYmDnjyyngTz/Gn4D7f7GS+23i/Jd2sSM3PW2dFRkKcTgxSxkoXg4Iex81DGmimJWXyB9RX7nlkkWriu4b+wuqABPx7PyDtCVI53ST4y90WnviSAbWNayuiPJFi0OXxur1FNvdbIKzo4xDl2jai6a/gU0qZYeZml34X8HTEN6XSn+Y7kWJQ9F5fMXE1Bjdz+tLXNYB05OgxpzJHF/Et1s6wjJH69Cu5xwTh79IdPyzcdsfFr/BPRZWPHUMYLII7oJhpoHCYCutUtJpHA33V6LsO1Uk2Apz4sKE6+U0B/SoB4ivNoBtzBjT3LAyMTSKLGyyC8xpW2O2iD1wuEm9YgKYYrGHFSEahF8OaB9OB8uDjVcLJpIC2XQLnOjybcf1up/g08eL+vsSkePS0SGmOlUmbbqyXgOIUVy5PqqR9NN1SS6W1EPHq55EUitSfiJlrE0TvldddtkgU8gwfIcvKK5cvqhGXuJx0Q2mGHtcIngX9tnropvHRNrez2dPQn5B3r8BlvJdFhZtQJ7TtGaPTZG3jPDi5YS8WCr2fMJw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VCtkRk95M01VVWNuTmpycnNHbXdiQkVDOVlSbzlnYjB1dng0WmRta095NHdX?=
 =?utf-8?B?VjlocTl6eTFhQ2toMHdpL2ora3Blc1ZRTng5VG1FV1FmUHA1N1lRelppcmtS?=
 =?utf-8?B?eGNWMEFqaW5CVENrWWJHZTY3SnQyRnh2QlBtcW1JeFBFQThlKy9xREs0OTEv?=
 =?utf-8?B?MHh2bjV5M3Z0ZDU3Z25iNkt6SGltclg1LzhMV2lOb1VFTkM1NDRXRDBLZXlH?=
 =?utf-8?B?YXRncjdxaVhKbWJlcmtPd0p0bVRCalQxZDF3UUFVd2UxNE13RU0zcTljL0RZ?=
 =?utf-8?B?VG5LR014NFdjb0xQeWxhWE1mRGU4T1k2WEd6bXV0cG9ZcXlTSXozS0g0UjBz?=
 =?utf-8?B?MVFFTGs0OHFabTQxR251QXJVVmF2V1N0QWp4ZEh6T2V0SlZabytYSnZCMGZt?=
 =?utf-8?B?aG1kNDkrc3o3WnExN1ZpVW84Y3VVY2llbzFBbzhydDczUHVITXlneDBjU1lT?=
 =?utf-8?B?NHZXdU12K3pkM2hyeThpZEJRSTNqY3d0MXhuQVlObnBvNkZTZldlbEthc1pN?=
 =?utf-8?B?TEpnaithemhwMHd2ckE5bTRmVGhVK1NHc3BxbjFYQ0hySWhoRzlKYUpvaEUv?=
 =?utf-8?B?d0t5bnF6YnhiZGJ4ak9DQkQ4NDM2bG9XaUt1NWh2TzU1bGFQRUpZZlNQVS9G?=
 =?utf-8?B?YXRvb0MvTHJzTTIxTWh3Y3E1cUJtUjBBbkNXS0s0emhZQWhSRXppdExTZGR4?=
 =?utf-8?B?WWJnbEl2ZWFJV1RLRmcrQVA0TVZ1VmIzRENpWXBhYlhGR1k0TVVISEJjVDdK?=
 =?utf-8?B?OEZDQzlvMHRYUWhGQVVMeG11NmFYdlBDdDZISHR4VktDTzd1Yml3alcyUHc0?=
 =?utf-8?B?eGRtd0pBOEJJWmpqQkpjTFAwTHFsU3BCTnJRRVdDVFBuRVJlODVYSkF4eXJr?=
 =?utf-8?B?aHhncTRTdHZJdlh5M2h3ZW81RTRXVDFOVWl4ZEJHMURNalBJcWpsbWRqL3BY?=
 =?utf-8?B?UnJrRUFSZEJ4M0lTOEh2Ull6eElTVXVXN1I1cG1lRk5aNTRXQ1ZSZzBIbnRO?=
 =?utf-8?B?K0d0Zm9OOTFzcHMwTGx4aFdtMGZkcm5UeG1yVmJDUFU2WlBsdjdkYUo4WHI4?=
 =?utf-8?B?YUJlNVlhQWV5MlJ4NUVTbjNZNkdlanhBZ3l4cWZyQTlxanFzMS9XT2FTNjZN?=
 =?utf-8?B?UUJLMGRpN2o3Wld1YmRKdk9NVDNETTdKbE9DNHhMblN1MmVZT1FidkM5dHRM?=
 =?utf-8?B?RHpiVDBLTE1WajFIM3k5azVSVkNuL3NrL1hQaTlSNWVQZTFMcy83QUJNQXFt?=
 =?utf-8?B?NTQyT2c4WVdFUFVHbUM1SU9uMDl0QnNmM1NyUzFZanBSUFBkVEZIVW1hRGdy?=
 =?utf-8?B?VzFWby9RSjV0YWdhZ1VlR3p4VUY4di9UUzF6OXlSTnptMXdIdHlDcGRHdTFp?=
 =?utf-8?B?U0NjSXVreGY0Y3FnUGExS25CdWZlM3JSeWpqaWtRWWNSVlYxOURKSzZNNWtl?=
 =?utf-8?B?N2hJVS8rOXR3UXQ1SGhBV1FDeFh0WU9vZU9LODd5SmtVQVFBVnU0QVdvMmlZ?=
 =?utf-8?B?UWRkMWV2bFlwVklGSEhFdUFJNi8vMy9ERGR0RTI3WWNmbFRWU1k1Y2VralM3?=
 =?utf-8?B?eWFobVY0OXRvdFdlWHFKYjN6b2UwRGJwcGw0R3J2L2o2YW1CUTVMNXp2VTNt?=
 =?utf-8?B?QlNNQ0l2d0pLTTJrSXFBYUtPeDUvSnhMK080NmN4TERVNEM0c01WY1J1c1JQ?=
 =?utf-8?B?R2J5aGhhb0wxUVFHck5UOUJRcklCQmdGSisvMjhHNUhjdkRVRzZ2NWFNOUFk?=
 =?utf-8?B?Um9PM3BDaiswWEZkNjV3alI5SXF1UHNPQTltUytDUHFvR0JESml6ZjMzbjhF?=
 =?utf-8?B?c2NPTlZTNzdzaVZRNFFPalpYcGhRbjNrNDJhSmhuRDZVaHFORFNOR0d3OXN3?=
 =?utf-8?B?NXRnb3NzWm5mWkhBWThWWGpXWDk2VnkreWhEQWJRenZQYktMR0NQYUtwRTN1?=
 =?utf-8?B?R2VoeXhWbUpGOXpSSzJqNER0alBVVE5ISFA5bFZRdmNPR1U2TnM5OG9Cbkx0?=
 =?utf-8?B?K2Nua1h2blRvb1JGcC81Mm5UOVhVQTJtN2RGazNTMnRlWVRVR0hEa0IwN01q?=
 =?utf-8?B?Qm1QckxVM0pvcEZnYTNidHk3dFFPRDdBSVp3QUx0QTFQOFZ6RFhoM3ZWb1R0?=
 =?utf-8?B?ajRJQUlRU3ZMZENPRU1RbzU4QXhWWmYzajRWZmNnd0JuVTZyOFFZcndoYVll?=
 =?utf-8?B?R00wTTBXZUNuZ1BKaGxnYVdhNWVlWEpITG9GQ0FwL2oxKys1SmEzQ3BxQ2pN?=
 =?utf-8?B?TjZlTEwrdk12ZWN2dWQxV2tKN1FxVTNJU0ttaEhsUlRlSENQQlpKOVVJYnNO?=
 =?utf-8?Q?AIILZKnb9yeUrkZNZt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6311d4e3-6a3e-4d90-b60e-08deffbe0638
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 19:54:34.7639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TTpIOzgIqRXCV3GCwZ69fA3ES7d+BUR0zrmG8mG08W1L4HKDRMbYhVKLyoH6THMA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR12MB999157
X-Rspamd-Queue-Id: E203414000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4dfjhwfnzoxzy6qqeb6yjbiy1zy9cnbe
X-HE-Tag: 1787342084-809973
X-HE-Meta: U2FsdGVkX181j4R2/iQ0oTUG4rbUzupPQSJ/OWTfEaTu2pATwEiHawuumfCoSsXjpWtz4y+tP/Uvf1nb4wseWtRUQ3BkeyCu2uA9BnHfv9egNkQVDiiBMWd596XkpGnjJ+engZxY2LxM9xThSP4ocHpB+tuWwS6/I5pmFEUy+AcVr2gB0xiZCzG/Dmb6Y7heA8IqL3DUt6dbMtWds90NF+XmJflgZCb2Y01yvH9yFJeVe9V+tevm9+Qf+InPae+I4yUL/9x6Pa5rYFnPukrQffWJeV/kPNA2fQqY+21PtrwwcI2JaYal0EbhEXiijYov0puvIpIp/Qk2wYkjvaEooGBuZ8Uw92sKSKIC+zFbRHbvSS91KZSRsRefAB/qGSUiMU7Ie8h4jTc6+kt/Oaq3zDavcq1X0S7EVIKqZAPZVBaMsW7IsuoaeVkOboE5RhY3yb1Z2PmoBf25ez3yoXJOQW40meTFZxpjjoovFnfBM/L32UdvMy72+GfgaEqNBjklB56Ylb0XvNPL/yjtumywFBl1OPQgXffF0xLSIRa5SyG76Ma6YETgGv134ucJBK32/9T94Xi63Bm/fRAtMxWOiTRIlkA9KEr6Zeth8NuzuB9+BJOHQ9vkBpM/kujBLJQQBga4BAnKNzPISuu+6dNVbNtxus1lIfLQ9LcivLoCPIUjKEOna64ucT5bS2nX7QXRAiOklXrUdulH+XR7c5IucIhM2jiyBfmu4eHZl4+gf4fqSQU/OWttXzAPUv1A/n31rGjPuEUYQjo5FdHGO5kbAo7kMse9NETECP1DpGkGFz1mVqASlX+lT7ks62QY7qvSSmG8F4zTmnUREiBxMta7crih/ZnGjltT089QtHDE/MIgz/gor88TZlkTjtK2DZYLa4tC0HYt7JlaQmG3JKuXXrmB9ex1QzytqQ5vODHN7IMGaFcXGb65xtSAoMcyAGU9jkmoDpimRaKUAPC23p4
 bOaMXb6i
 c7usQbkT3rTFbCb1Bt+AjgdXjmPhnXbrRQ8RwdO3U8Ziiv47El0uvrne5PB5rDvi13ia9tyfY/SXMn58ywmTaSVKv9YH6WNq30q2oEWAE8hUhWN5KVqldkV6Umh6UQkiai0+M9VFCFeSPX2ebCY/1mZUPxJ8vCQ6DuTRZDzPjHyz+SA32Z3DFMdwMR2OCN/zZYuDRBdL/VlIpqnjLE0kjR65+shsx9aPwZd7sBDbqR2C06q3G6sUF8Q61PgBZeJi9mQRmTTvn+8kYYot/0HCfy0netKTWsdWgRCmcYlSncZwF9fPPJ/oIs+EMIflZUpNWDxfhICFjzdjEt2JdY4PajD50hVfOL0mKKSbKygvBB3HBLHHQMjeVXAq0Q8zvUeyrytMWYlJ+BFOLn9y5peNmxIVlQGybB2nHXytkdODNldbE+SbPeVgxemdjzzOcH8u7G6reeeIGDhc3ecGTZstlWZ38Uu2sM0RGQDdqrbYj1CHITGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 10:55 PM EDT, Qi Xi wrote:
> The PageCompound branch reads compound_head() without holding a reference=
.
> A racing split or free can cause compound_head() to return a stale pointe=
r,
> and compound_nr() reads the order from that stale head, leading to
> out-of-range shifts and making the skip distance meaningless.
>
> Read the order explicitly with compound_order() and validate it is within
> MAX_FOLIO_ORDER before shifting. Also verify the derived head_pfn against
> the legitimate pfn: the head must not be past pfn, must be aligned to
> nr_pages, and pfn must fall within the compound page. Bail out with
> -EBUSY if any check fails.
>
> Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granu=
larity")
> Cc: stable@vger.kernel.org
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> ---
>  mm/page_isolation.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


