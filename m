Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27048C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265186B009E; Tue, 22 Sep 2026 13:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214B46B009F; Tue, 22 Sep 2026 13:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD5F6B00A0; Tue, 22 Sep 2026 13:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA0FF6B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:28:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DACB1605D8
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:28:25 +0000 (UTC)
X-FDA: 85242082170.27.D759E48
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012004.outbound.protection.outlook.com [52.101.48.4])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C80CA0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:28:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tMFN+kRW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790098102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLIBESCgL+1P7ZJfew6WReIZ8MNe7AutBa8ZTYj/pMQ=;
	b=cJOY6KG3JvdX6gj/voURJG2VYZlARx068jk85gFg2F67OYFFkTkvwMpJ6vgHf7Z7TOxPvX
	R4k+WW+whG/XOcWBFDcKWQ9XKDUISwyT93lE6SGgxv8YyH+cNXEQ3J/VPj/lV3Ai1VoGKj
	bvmQcmPlzbsQiiw9S6D9gd93esDG3vM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tMFN+kRW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.4 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790098102;
	b=0YUzK/0KQi3vM8vs+/ko1IMQLYHEqYObaNhr3Rx44W6YLL3bdHy7afzpW35PjCg46G+yGr
	wwwLRPQDDvkoWdb7vbwuONtLNNiFCrI9js0krVW9Xb+mvhS65LBlavxxfY+9GNvQApKGy3
	BjYE9DjKe3/uCtgu78BHykFRB6qhY6s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZHsmH9uA2RyOw142fyjgDVi+YPqXgBCMAaKgV0nsAOKq5/PqC60qC+NsGmKrvFLOi70qEIEbI099UhRCrjFSBO0DsKXP/RgzvxOWxVWX8Mr+EEHc07yxeH6cEU4CxGLbwwRdBjoNvcfE7awHQjoQPqUoGN9Ug8MJEzcdJDGbbHfdMaJFGIZnuPFvGsuDiwHUTCv9SZd/WGsNqIIxAlN0xACX126DZG2x2WllTrUj2ATHe7596cWAYkohjuBUvSUs7GaNVg3+j8q/s3VypEvKxJaCx7ohq+z7AKePc1bx957X8dBj0H9OW+9PJ94R1+N0HpCSS0Zc4bw8RmwoRf0i+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLIBESCgL+1P7ZJfew6WReIZ8MNe7AutBa8ZTYj/pMQ=;
 b=DfO/yPjIzrRsYdn1BXlR8brimV4plDPWf6Pkmxu+E8bckGd57x0r/CP8uwTfbcu1PxutiRLAK5Or5bMoFZe36g+WyoHhObL8trBnDtKNcGAtgTYe/+u2OzArNTp4c1TN9olE/H8iqt8mVTdHgU6i4Fj6KDbcd4aMQt3aZK08rjDNYOHp3ekyuVO9+Sxcm37W6mNeSWhAppCTLo2zeZZHJR6A3n2cim68knnEBbh+jg3wf4TwnduAIrTcSUV33c5V9W67+NogClN4pWLwQzQua/GdoUm0vR1EsJ2Z9kGKis1aBADH4YnysdnTwyLkIniZv5477mvLiRavIZbHj9xWiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLIBESCgL+1P7ZJfew6WReIZ8MNe7AutBa8ZTYj/pMQ=;
 b=tMFN+kRWuZddgjRxStz/vDmHWH/jMLIYSRHZjkMurk43kxy1+tnbr1opomQi/yHbVkA3Ohf0LRJig5ie4m63mRTlMgprdD/t3PpCAT89ovB+x5lqB1VJnGN8HxejUx09hnPLOnCiGrryGd+3+X48v29WhzI9Q32jElsXbMxlwo2NEnQDORK5eBIOkRo0xxXZB+qilNdUcS1D9LrO6DME1MPAtwx6LW5co5ASxPcMjnsrCgz7WN8rlKCOQu25gm/zzFBKXLboQwaOpghffONkcu1IfcPpKdJe+XKGy81W5enI8Pjl2gGtZxZW19SGrR1hAGjca9d7DWtmyomC2RUKqA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6415.namprd12.prod.outlook.com (2603:10b6:8:cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 17:28:14 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 17:28:14 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 22 Sep 2026 13:28:01 -0400
Message-Id: <DLM0T60C8JRD.11L2TBS45DHBU@nvidia.com>
Subject: Re: [PATCH v4 4/4] mm/truncate: clarify return value of
 truncate_inode_partial_folio()
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-ext4@vger.kernel.org>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <hughd@google.com>, <baolin.wang@linux.alibaba.com>,
 <willy@infradead.org>, <jack@suse.cz>, <bfoster@redhat.com>,
 <joannelkoong@gmail.com>, <djwong@kernel.org>, <yi.zhang@huawei.com>,
 <yizhang089@gmail.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
 <wangkefeng.wang@huawei.com>, <yukuai@fnnas.com>
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-5-yi.zhang@huaweicloud.com>
In-Reply-To: <20260922110703.468389-5-yi.zhang@huaweicloud.com>
X-ClientProxiedBy: MN0PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:208:52d::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6415:EE_
X-MS-Office365-Filtering-Correlation-Id: 267d8f26-4980-4912-a49a-08df18cee1be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|18002099003|22082099003|11063799006|56012099006|4143699003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	gPuIWsm5XIH1efTr5hTnXO2BD162hqkQx7PBjcu0obHvtUXha/eO1nymDOI2kTxGBloYTzIjU57ghME2dwausoNW/Y3DiiEhmp8Ke3x403Hn7dOF8Csbn1hQyiogEn8d2D+wWssj/cSKk8q+Vw33IXh9Njq9H/68UOV+ezB2M2AP/HWdzqAbh6JAPna06Q+1XuiCCtt8KlxqmIXCICCH0SK18SVD8XbljzPzRZBqowg/btUTmjeben8ZqCH/CiEU+Leb+JzGxwkrHfJiyzdk7mqrWpMEkNbDxE8zwcIMX7YFZ1Eoup5dcgHdltrQ/byWA3nvxCr+xVamTsqGuQy0HKUO0izvAl6tIauOO8opO0GI0/GY2NcMFoLUq5ODFa4hBaZAeioPkIeHhquXyWuAjWj0j0AnFuAXK2YRnSpVFIK4ShgYdD+SmX5nYV9mw6lJahifZb1HDOD/QADto5IcAOWC/ILbyTQ2x4xaVd07aFWHjasIKOKEBCANcyS5nOCuvU3iHE5GciC6d93QhiB0NUkw00j8SsCwtYdk3W+Q2CTZkKcbdIb5NSMHGlvejIVf5qmye4a14fR223z8/rNPa2TF7yhH2+5eYpbMAKPahEK87wuTAdwQFk567opYuAGZIKD0uP679d876FfRRvMNa8eJSInC39jd8TXEoEiJuaQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDZPd080NmRtWGxEVXZnSlJvcVlFeWRKdzB5VEQ4emxIbk1jbUprSmg4Y2Q4?=
 =?utf-8?B?U2tPaUFNT053dGJtQVkzQkE0T0NQUnlhTjJpWHBGZXZFNlZweVJLbTZnd2t4?=
 =?utf-8?B?TnZDOEN0dkQzb2djMlpuZm93K0E2OFVhNjRjTGxvN21kblAweEpudnlsZlEr?=
 =?utf-8?B?enY2WWtkTmZXaUhpenZPRS9DRVBGVEJLVUhQaE5wQXE5d2oxSnJELy9TOFI0?=
 =?utf-8?B?VW42b2YrU21OSUY5cVllOFBxVW14TnBBYWlKV3Jnd2hXZ0pNMzJiNWwxWWlB?=
 =?utf-8?B?MWN4TUgrU2JqWW9zUThpcGhNVE9rT2R6VEdiaDNSTGxzSWJMZmRVMnJIQ2d5?=
 =?utf-8?B?L280dDE0bkREbDUxQzNaa1RQMUVSelp3SUY4Umw2c0gybDJsVzlZUXcxQzRa?=
 =?utf-8?B?V1h5ZlVDekh2akdHVEVWRUFSeSsrSFlLWFIyMGdGd1ZYWnpqYzdsS01qUFM1?=
 =?utf-8?B?ZUhLbnl4ZGNPdm52SlZualRSNk5Icmt0eEQyVDF3ZWtBOFh2MnFlWXcxM2Ro?=
 =?utf-8?B?WXBXV0hPN2NXL3dsSUU1OXRCU0s2anMvdlNnZ2dWSTFDSStsTDlTWDBYVnU3?=
 =?utf-8?B?dHBDd1JicnQxc3RiYWNPSGh6WHJweXVvdWNkOWw1YUFKN2RaMUdOZHk3Q1pt?=
 =?utf-8?B?QUZWVjlJSGpvUHA3RTRDZXNWaTZWS1hlRnFxaUlmMnBES29oai8xUWNYM1J3?=
 =?utf-8?B?Ym9jcllCNHc1YnRXV0lrMzlwRUw3d0l5b2V0WE5aSnpLNUVFaWZ3UFZuYjJa?=
 =?utf-8?B?amNKYzgveVA4QlB1aHVaT1BZTmtFZmFteE1laHc3WmpxNXVtQ1puNTJubE5a?=
 =?utf-8?B?WWlVcWxVLzdrRkNHZjZxQ3czckZHVFUyZStuY1pKNGEwczlHS3ZuNG1wNzN0?=
 =?utf-8?B?NVMzd0VZdHoyNDE3MEpyNkdhekVTLzk0ZnlpSzBjaXBSa2Y3clhBNlJZVUZI?=
 =?utf-8?B?M1JyZjlqK05Kdk94cEc2YXZIQnNJV3JxV0RiSmVHMUQ1cnNxcEVwMnV3MElZ?=
 =?utf-8?B?WEhMWEhZR1pmZTZRZ2ovUmxxM1lyMkJldG1OZzlwUnZmVW91VjEzMHZmNmJK?=
 =?utf-8?B?eEpYREJwYzk1SGtxQXk5WGRIbkttMkZxQk5LdnczOStub0dQN2xvNDJTaVNS?=
 =?utf-8?B?WDNoRkFMUDZhU3ltaEhhTmZLQzZ5dmx5enlBUWMwdUFTQmNabElIcXhETnJF?=
 =?utf-8?B?TFo4WGJNSlI4VXl4WXg1T2JDakNyL3pCM2JLOWY3bUhBYW44RW16dk0zaGd1?=
 =?utf-8?B?UzV3cDRsc1JiNWNDNjVGNFRhaFZrKzZZK045OWlLYnp3MTlCSkljK3lKdEZ6?=
 =?utf-8?B?Qmg1c2F5aHIwUHVTdm1YZjBQcVAyMUpnZldIQVg3YlNsdTBscVRWV2dSRkVj?=
 =?utf-8?B?YzVKOWRXNlpLamJuQkVveGpGdmUyMjJzRnFIOVFsaVZxVDJUZFpwbWh0WGxQ?=
 =?utf-8?B?M0w2d050MUF4MDh5ZldQWEJjazNRSS9jZ09hSEZTeFZqcFhqZkN5RVVzN2Rv?=
 =?utf-8?B?aGg2RlUwMU5ER3MvRUhROXZPZzZWazAyRGEyaExSS3NpQ2tjc2pVTmJSL3pV?=
 =?utf-8?B?Q01BMEc3dFF6d2srdDhOOFRYOEkzeTd4YlNpNWJhOFJPNVpTdTRSck5jWk5Y?=
 =?utf-8?B?aWM3QW1xbjFuYURUSTdZczViNHo3dXpUdzF6b0t5eTRwVUdJeDFQV1p5cXBh?=
 =?utf-8?B?NkZ4K0cxMW1lUE05WWx4VHhjK0J0RkhjZVRpSTQ1ZG5vOTllSVFNaU56aWVr?=
 =?utf-8?B?cENPVFpIREdjLzdaZ0lFUXhYck56VHViM3BaemZGbmNGTWlOWkU2OWs0WUU0?=
 =?utf-8?B?NURWblVNcE1QbnFpdENaSUt0WUk0NDFJcmEvVWh2dkNWSG1HSDJrYWNIL05p?=
 =?utf-8?B?VzhPQ29uYjR3LzlUandVcFhyKytqR3VDbXg4UzhnM21NZWZYYlZhWlJhOUJh?=
 =?utf-8?B?RkkwYzMwS1FMUVVyZ3F3MEIzeTBTS0I0M0ZvT0VKdEo0UlJMUld0bXRXZ1g4?=
 =?utf-8?B?V0lOQ3pRUHN0WWFjUnlJM08xcGx3bUhIZXlWYUZNVTdRWHJZSTRYeGRscU1p?=
 =?utf-8?B?UjlROVJzcnREbHpnblhoajdiUjEwcTZOTk4wL3RnWk5BLzlFdTFobEFhY0Zz?=
 =?utf-8?B?bnl2dnpNQXZZVmdNcCtRMTg3WUk3Nm9oTFYycFZVdlltOENZKzY2b1lTVWM2?=
 =?utf-8?B?aHkvalV3WjdHNkxySHJPN0xzRUxRbVpHYkdwSHpSNGN6NHNzTENkMEdkNDhX?=
 =?utf-8?B?MXdwbGxZWXc1QUdyMmNkeW9OVkhtQ3NlMGlnd200UW40YXlkWnVlemlBK2xt?=
 =?utf-8?Q?cG+K9fCRN88poN25+F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 267d8f26-4980-4912-a49a-08df18cee1be
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 17:28:14.0624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgUVXlT7U0ghXb+2FxKCFdZ6FpkxnI1UAJ/URKJfhIdfwe0WK6KAvMqL+bs6EaqJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6415
X-Rspam-User: 
X-Stat-Signature: 1uf86wtdb7hgb1wq5nyai6xnizo8sxhe
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C80CA0002
X-HE-Tag: 1790098102-573723
X-HE-Meta: U2FsdGVkX18M/JbWeagp3fOBYpme3NVIzaNIc7lWGx+kCCoGf7OJV3EMVyrjPBi+CZdWi3ZUH9LeAJJFEb3VphsI1zaguGiEcfOEBRA6sIDz07UmvpM16NCrdcTOaWWLT/3hpawhC82bA88AU5q1bdZxwAMbP2Qs4PGBo3WC/wGqy1xTQP2ZSa/TZOLOarxx6kPYpUHR3dMYkTidlONsAmt2SsC55rLCxlZNDmUt1l97ffb9FRHpnKXIOKmh3Qh6Br3NmvPPCTKokGGb2H/FkgGueqp+ZfP3ZQgFus+cgIT0rv4Nn7Pi+iLpSzWIF65lNGorEp8XUGCtYSjyGoMnYqoVDpgGgq6Kaozw7gAlRxkJenUqMOPEfu8gYJZmE8VJtL2477/1MED2GMTHa5opQiT/feE7132WWLUaxUrEhox9ClJr7YlPwJ80ojlrgA2DgHBgUU7ghlfXtF7VOzFR8bpd8Fj9VifQ022asdmN0u4wPZ43lSa4M6CFofQuK5hGYZ+xP7hEW9eS2kNk2QquJgBnL/4qF5sLvr8N/7hmZnB1bWVeckjCBxevu0fEUoBAFgUEI7QFAm4Y/QBwBFxEQhEfj5qmQUMRBZuZn0gj+NMtjyRy0Escr6ooMKri+NEhodGh7tfW5katqbWrgrabXU1tAR4lQgR90IM2Ze8LuXB6012oLm17EQPr2IvKrjAJ0VUid0Y0UcL1vJb4e9dxHzc7BmT8HeHJbHnbne3W65FBi1g068GCr4SyP5zoUsjbJqKxxK4R0xhflYlGdg0NNAyXPDAbaT0ef9E/KrC1hhy6DkerjlijVomAALyyAGJ1z0xfpNmYkotiWIAI+tUT5WCB4pdIPu0BuVBCFWlysIJKNIIuqL4GJg/V9BBkeN2CMSmeO+I+gdbFIj/MsleGOFyBCV50f5gJnTGEjwCCWfjfjBHrP0VKV/N7xgRKJeMlSi0VABRPdOdZe7NRFuM
 96Io2k4p
 T5ONm+4xvgb8U9CxEb2djuZh0EEzc6yGn6jxv5pyAVDCzYqgII/92lmEgvLiajElgyTLd/K7mNsONbDEByLB37q1je2chVbNIMQOCRaF0bHRDhrzLqdakxOjGxDtcbrov6MA1AYzBOi3314SDnQ4QMSiumLMH65s3b8Pew7FvHGJFJvBJEZIk5ZcitYumJ4Y3Lhetrgc8SuxVdTTjlta2rAxh9cjY2CialevbvehFsW8uMtJAv2xrSZSmGRp8C+qNEQjvrHurcXwQRfKbx1lwhmGQJhpMC06rO2I0gbs4n67Up7mnetZg+x65sJnHAjHZXWcku6Osq8oUGapeYTbzr2T3j4p0kw9HOSofkkuUAShBFMyL557ClAQbHVIIgi8IqxyxG7chRumxJUMJO47usaHN5VnKk1cxn4ikMMZzf6nJgAIDj4wrGZwmiSBBd1/5PNAr4MwkQbBkcwfllot3f0VcSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 22, 2026 at 7:07 AM EDT, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
>
> With the earlier rework the callers no longer rely on the return value
> of truncate_inode_partial_folio() to decide whether to adjust the
> truncation range. The pstart/pend out-parameters carry that information
> instead. The callers now only use the return value as a flag indicating
> whether the loop should be reset to pick up newly split sub-folios on
> the shmem path.
>
> Return true if at least one split succeeded, and false otherwise.
> This clarifies the existing confusing return value semantics.
>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/truncate.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>

Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


