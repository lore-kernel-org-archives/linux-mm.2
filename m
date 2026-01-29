Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1E6CD6101C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506296B0089; Thu, 29 Jan 2026 09:41:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4862D6B008A; Thu, 29 Jan 2026 09:41:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35E4E6B008C; Thu, 29 Jan 2026 09:41:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 256E96B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:41:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C92A11A0153
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:41:52 +0000 (UTC)
X-FDA: 84385265664.07.CCB0F47
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013070.outbound.protection.outlook.com [40.93.196.70])
	by imf07.hostedemail.com (Postfix) with ESMTP id E34E340004
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:41:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=pjckwvg5;
	spf=pass (imf07.hostedemail.com: domain of bharata@amd.com designates 40.93.196.70 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769697710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3TXnm3YqWala8nESp/YB4DNry5KtX1V6w/Vij00Mnk=;
	b=RFapKMI47gAlcMku2X70l1mbYVgQcVDbfkupSByGxZU0avK/fMtSConSMsIcB1DpaU3QAj
	OYB5Zc1rszOYXDudrIC5ScTjXjoar3E9dvZefYzsGKYjHFUhNRAkH5lPItbucOV3olTJRX
	NxwkemaAGKr2SXMWCHkhaGYw6n3AS9E=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=pjckwvg5;
	spf=pass (imf07.hostedemail.com: domain of bharata@amd.com designates 40.93.196.70 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769697710; a=rsa-sha256;
	cv=pass;
	b=Sqt+1zpIcAtO17cQ0d3C+Lu7HQWezmsMllY8pFpFnCAMzVWuKQBMm1F7mZzeKlma2k54RW
	6Spke6F84CA2kldBs2es3sXUoGZ4RdbMt0VGcmqulMhEBhwYOOwonRYgFOamq6gNLmEj6q
	ivADZWi3CRlPTqn5oZzWa3zf3n7lL00=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fNyw/mWkaN8u1fmRxra1a8ttSmIv44ILJRiGC7BDetDPzkIV1QAqpDB3U5qi0LhBDW1nzSPF5XjP1Xms6H83IY/2rmH6J87U1aG73aDyiRBKqRagVDjZcVVuiRVzRfhQbDB44o0at1PnNPhkIDugKahWAu/85it0UfJkTbAFHihOF8kPPeuJJucTgAf/8hkllDUi2iAyR7iLZOv2DH64vEv6nDWuynDL40qLX8bq6wk6F1/GMXe/rSnMOYSQcrupWgEYvWaUpiob9+gVv9JVfwlFCICTj4C7BEUp+it/sMWOkzKdoYu8kV7t6OD0z37vj1rKgSgAfKUQdKiCHklNpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3TXnm3YqWala8nESp/YB4DNry5KtX1V6w/Vij00Mnk=;
 b=L7Z2+BeOjusLxJdT3Y7snAWNeL6EfalNxkZf9Q1dFtTQUaxBPP6bD5fYwAAI+dicWPKOS5GbcnDSud4YIeMmC0LsPWtDk6QRe+6GkzJOh7IfDAp9jQh0fLBrtfISJ2xZoolTP+q94h0dRP3O9LoRB+myZp5Iwk+mY+IPT+jdvfbj4d1LksHIHQJqnfKeFF3k3jFoqK/9QmuIVI2ZkhQu/jOJCgw6KhrFtJD/DaE8sPWGGdyb4c77pT0y0pw2xtHWJuVQN/WmKe/krZBmeSnfGV4ZKvgACUj5UnglfxdLQMXAUBTYe2CxrFAqKeBhWTb/DQkyPJ68gSEiOfzDNRAthw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3TXnm3YqWala8nESp/YB4DNry5KtX1V6w/Vij00Mnk=;
 b=pjckwvg5ezmGTC3Ur6n4RBpm2ihi5qASE52ThW9l3TfSc4TF9WfUtS2YCr+5vYcxuEIl+Zwe1aFxwzMDhkw518/iVWa8nysV9P2hKTAAJ3erXRtzmyWM8cOKaeY4/DbGXnuFLFayu9e84Sa/NT8js3g9uLyDuxQTb6cTOfC1kDA=
Received: from BY3PR05CA0055.namprd05.prod.outlook.com (2603:10b6:a03:39b::30)
 by SN7PR12MB7884.namprd12.prod.outlook.com (2603:10b6:806:343::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 14:41:42 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:a03:39b:cafe::b9) by BY3PR05CA0055.outlook.office365.com
 (2603:10b6:a03:39b::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.4 via Frontend Transport; Thu,
 29 Jan 2026 14:41:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 14:41:42 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 08:41:33 -0600
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v5 01/10] mm: migrate: Allow misplaced migration without VMA
Date: Thu, 29 Jan 2026 20:10:34 +0530
Message-ID: <20260129144043.231636-2-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|SN7PR12MB7884:EE_
X-MS-Office365-Filtering-Correlation-Id: 326c1adc-eb88-431a-0c0e-08de5f4484b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MlRnmO0fA+i/nWaeLmWxQQnz3gfYzqEyGWycJb+6CTJtwS7TLcrWNWFYPUZu?=
 =?us-ascii?Q?K7A5YCPjsj9g3sypufuX27HcPgfH/ZOifnI2iU0jT6aFiAZlgKVax/BizEqp?=
 =?us-ascii?Q?brum72xvnHUHV9kYTCMnIUR4o6tzwX3WkpuZUK3giiTrZ4FxRNSitN1ZLeGa?=
 =?us-ascii?Q?vZKuj5JbtIRmhRdJNpraAz9oZfe7jlo7OLRbv/NI20xxgWrk1Yz46dpxSsvg?=
 =?us-ascii?Q?cudsfIRyX9jNaTHousHcLzhBc5HQ+J77wPUAXQ7hzCUnNqPRM+HWocfDx47e?=
 =?us-ascii?Q?QnhzxSbqyWJRKD9YYf+PebItrY3iYhQR3KVKyK9Au0uiMF6h3TrRPDDyWUR2?=
 =?us-ascii?Q?g60tYhOVbzVdm2I+Wyt52QRXdeeYHpadmg6uiFLlXrLGtP2Ap+kpZw5h8gkA?=
 =?us-ascii?Q?HTWR9WCUmT5FUtv+/qS1U1HVc3XR9GuQtnPGPu7ByN8XdBDLh28Jmi8U3q5t?=
 =?us-ascii?Q?AZ3yPIGZoAYCkeQr/OUkgvamGLCMqi2RR/QtfKq9Riu+77/GYYosm0BiLDLV?=
 =?us-ascii?Q?0cY8IRAOrEOGRaFZBjelEeglAJTViVNJzbfn5Eq+h0lsUM9dx0jyUQXUBri/?=
 =?us-ascii?Q?Spw2awtLDgpR+tqQ9JF6EoKXGDNYn1lLu69eI65tTGtfmLELaVNsDhtSBXJ6?=
 =?us-ascii?Q?kLg5PcS+OJA8qAGNcWGyndMhmWHWm8wNz6+8IvzNLX6Qeztw0DqmMQc+sZIK?=
 =?us-ascii?Q?39r6hNhx2C4rxGgaWuDL67UIno6Z/PyKBGtf14l3kMejjRoAKKaIwmqWtyfm?=
 =?us-ascii?Q?+MWpX31FvKwbORjYUwQvrDg3qoVVzjqXoYVoJ3nPzJSTiRAvDYL+QWNOmcOo?=
 =?us-ascii?Q?zAnmF/N3eiRlkDAvLy+ywpkTOZUG3kbLsjgibagbC6sOT5RzOQSdrDej86aG?=
 =?us-ascii?Q?HAITeOewDaqrLRVRmUITyN/Xm8Ne1yC4isu1E3Yxondwg3724KzG9iVxYyTJ?=
 =?us-ascii?Q?gQtAIkNdCyN+vEGlHKtirzSGZupFL0dHi46UYS8GGssydar0ZkFmdkeIbe4I?=
 =?us-ascii?Q?l0FXSDuB54BHueBWbJJZCtyOBWWCLAus+7ByjLdNafkTExdyupBMmzR0Whkg?=
 =?us-ascii?Q?0Vsv29nq0sXc+hQgRN4yPamQ5ZfyMGXqBeEYPnd4ukjD1om8Zv3ZMsPSK879?=
 =?us-ascii?Q?tdM8yCdvXDl2mXgq31IGsZpWZPqgUFm2YetFePDcj2/1LM91DoXDmCPl82JX?=
 =?us-ascii?Q?cllwPD9kmcSQPcN9BumryIdQI+G0rjpC3TJb6tIOkFOLqmxEXdgrKsMotA48?=
 =?us-ascii?Q?CBiSeLRdHEuddY9wGAvjQI3ZdO800c9eLm6IKrLbc8Fg2y36uFV7glMdnuoh?=
 =?us-ascii?Q?ddVM+1k05pICbQcXPq7wJTZnnLcnkOyBl0mbQ7McZhuSmyRFI+P5+Nid/uBh?=
 =?us-ascii?Q?ESwqhsX8BL83dXBP1wZ1No5F54ZVCkT0VVBRt9EA1ZnQSyQybnKSBaMpnQdA?=
 =?us-ascii?Q?5OQCJ4A7UZjX3nGMH7JXECOQPQjI8iUEeGGAc+wV8ids6qE2Q3Neak2Qlxjy?=
 =?us-ascii?Q?De4/AcMXgUwIsAe0s0n8XjcBI10XO/35RX149v/NflZx0bhhq4Ro2gy2W04T?=
 =?us-ascii?Q?2hCKRdFlvgXqltNZCiH3ym3GrWIm1R9kJfsrFt0Mx0XXzNLhRaEdDOjBGqqp?=
 =?us-ascii?Q?SFfhAaBeSHyGfrngL35MZMKjZO2GrSzQcx/5m3Ap9UeoURkJBE886ELuV5Wf?=
 =?us-ascii?Q?SYmTsg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:41:42.1340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 326c1adc-eb88-431a-0c0e-08de5f4484b6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7884
X-Stat-Signature: yhyuw3wwyfpt1yhfois9hubc6no8n375
X-Rspamd-Queue-Id: E34E340004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769697709-690056
X-HE-Meta: U2FsdGVkX1+LNf/8d/H3XLKWMREGWNPVdach0RVR3YVWPJyV9OiIVqOCnoAJ9OXFByTzZkhRtqU9+az1RFGsnubtT6d1N2JIhtvV+E+FWzhzMEn/QZ3f2qCV2hgeVPrav58vHNtgO3MWEiLI1aBSmC5gy2VT3f7DADmfspC/7H87Awp02M7N5o+xIN360KCeb70y9NYOxWkeLalrH5iH4S57Ms3F5WSqscCN0Lz6Hm5qBwU2P+Dy8TnLQ35zNcACASCoYdBHxbuYqS/Q/JEbd+63e87INsI4y/6tmHo+K7vsKRe5PLzQGqUM1aYt2YcHmmhSjN5ZJlfhPHtSb6xhZTDFXWKa1O6Db+zyg6DVnhvOrhATEfa66j74Fzw/Xh7db/ttHvpSwMqgzywAtZM/AEffyE57tzx5sBacwLbpQN+MBOd08q7srSXN1Op9Iwsg6eii2Ldo3U8MUvyFD/RiMXdNGIHqtApYZe+uQQpPMB/gZGrp9zmC1VbmzMGUPX6H8JCOa3ba//pkB2IDRYV6FEqAJgdThddq8K2ZPTDy3QLAj7wOz1O3ChyT19aP7wh/7bpWQD/kHVRUT2SdyAL9QLTp2yIMcyh9SN0Oy5DGioI9kyj8KIZOudoR/ysE9L3XsR1/UARD0o/3ariUrgVE7lkQNoltnLU984pZiVCnWyQe9n5HtJc7PZaQ33ORPh8/3vk9ce6NHq71+eaXF5SWcagfi1fFhyIJvNQ5e/+/FGybhCV2Gyjk09dafuYzfCkhmHMHCjDXRsAwW9W518MQq3fPuEdoq1wJH696V2klkXAh7xjStJv1plbFLK0/tER372NtL2hpMtCt8a+2yb1HbIHOAyRFxZwY+/ZZifWb4/CrYJzYJG5YQtaLFDQiXt22hpmoSykUVxlEFCRN73AgAn7roOt8Xa4C+gJz/98B0IuhGl4q22ZlpbjzShoX7bHq4Pzl75vF05/Me/rC4wh
 kceurUXT
 nskwkFd6mXI4MZoC0A4du6tvZTxjeQClajUxKvDnvlNUm1BCFeQew8LMlg9zaTnA18gpuoae1OmNbeI1ayoj9NMQ1Rn8EbrWwpd+ry5QAiYDfG+ly8dPW4HmL7MtkdNJWeKkOSg8C3FvmCyR+1bzx0sooZjUs19jV7WDaaZpvo0bm9JUSyUVVFvBmG/iXOiRJdgMCzVrFImo8T2p8SXrwo+VfmDJj9zBnthHIkvgYnAeGqWJyW7ukQpz6A0m7vO8nB6ctSbE4R75Z3WbCWGYV0DtoqkeWsNZGC79fLZDAVyPbQMPIZcexMIvP/r/gFaMPhRMQivD0JLWHcw5q9ixzMp9BcOi4d3I2ewTOZqlPAa8yD4wiEXHLvxuwMSNb1WwX8yxSRw91szlp/qa8GR68OCcLCBNy+P51sXYZ9imMe2KCmoFi6d6qy1TrWJGUdEYy1ojZb3UXRcLdwM8f22C9gQpeUrQ/vqlFY7X7F4e074nhbCM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want isolation of misplaced folios to work in contexts
where VMA isn't available, typically when performing migrations
from a kernel thread context. In order to prepare for that,
allow migrate_misplaced_folio_prepare() to be called with
a NULL VMA.

When migrate_misplaced_folio_prepare() is called with non-NULL
VMA, it will check if the folio is mapped shared and that requires
holding PTL lock. This path isn't taken when the function is
invoked with NULL VMA (migration outside of process context).
Therefore, when VMA == NULL, migrate_misplaced_folio_prepare()
does not require the caller to hold the PTL.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 mm/migrate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 5169f9717f60..70f8f3ad4fd8 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2652,7 +2652,8 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
 
 /*
  * Prepare for calling migrate_misplaced_folio() by isolating the folio if
- * permitted. Must be called with the PTL still held.
+ * permitted. Must be called with the PTL still held if called with a non-NULL
+ * vma.
  */
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -2669,7 +2670,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
+		if (vma && (vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
 			return -EACCES;
 
 		/*
-- 
2.34.1


