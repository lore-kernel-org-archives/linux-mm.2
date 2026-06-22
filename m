Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8ECCDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375E76B00AE; Mon, 22 Jun 2026 06:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324F46B00B0; Mon, 22 Jun 2026 06:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDCF6B00B1; Mon, 22 Jun 2026 06:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E20956B00AE
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:04:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6745C8FE08
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:04:00 +0000 (UTC)
X-FDA: 84907112640.03.73BF688
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010011.outbound.protection.outlook.com [52.101.201.11])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F68CA0008
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:03:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JJWVgDdW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.11 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3evS3VzYp4BwjqPPu3MHdkTGH2pYc+YL2ehIm8IgBHY=;
	b=4GOa0jDs+/Ko5rz/q/1UBE2OeXV15FJFjnKAgH08UAGNpSPBSyykCGwKRGCGCHGEa7lcOs
	BZPxyBxWng/DdhezlXd80NA7ecERSBhPi/aqRxBOgxWinfxiptWlPQHhyjrz+kOx7wwvlF
	f/GhSbP+fW85Jn8p6WAigBiSI0mbY4Y=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JJWVgDdW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.11 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782122637;
	b=45sTaWi2F82qiu7S9NoX8Fsd7hOE2JoE7igmeIpDd58h7PUnW+Z4A36ICBsvSWgv2sPPuu
	tJrM3EsQmMxclcA57huFNRg4Qvn7luJFcUw5krtMrR/OwIiMv1ev9jg49BAGl5fIYMb+xV
	Glr+/p9evJO3DZc8UFsuLia0ZvcsbPE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ffCWt3pBMpR6cSxg0Yia8YC6UrBDHnw8lHCba0wX70GZOIa9wMqE67y8rQqHLAvDZLcLdmseJye+PvB7JGqa8SX4yd85uMNG1jo+uaEYS4Iq8XO1B207YhjrWqUR9dYZhT2iTphAh0pnkB6rS4ZrxwllxyOXio/2nYPhWqOW2ckJIUD3I7cY5FegbHJbHlMIRi6R5USEHhxiEPfvTBvbw75Zl+saSmHZbcPvONAGBn4KDF3TWNNjmSn3m+QF+kWc+O9+bwo8Dukxsyg+sdMASNiMATY/RKxbaeHwz8ktJSofdHixQcPKVb7UiqjXxwrzOT48Nm3nh3n1rLvRMbccyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3evS3VzYp4BwjqPPu3MHdkTGH2pYc+YL2ehIm8IgBHY=;
 b=N03iOsoEFTBks4/NojQMx7pr/oKb1iDGvDB8aXxtLHIkthyexi5LTanDrgY6nrir7k817Z4jbDNU0/1JuSyH9tMc2De4k+hbNHcYSpewYasPFgQN+U8NKX/ydwAjzs/UuY4FOBBgvv1I/avA1JPCSL1BIqXYoIGu8L4s6NzoEuch/olTrTusBRzgqZRq+d25ZHX5zICUekcAb/pcpwvhINwjqCag6vIZ1pC4MPJ4TAj7x1ySYRzXdZ5w+txk1WdKaoLGUovN+NJtIH+RyMr8My5kqv/cKeLtYRX5XZbXX7Xk/HfpXyEotumd1WFASeLmGc7McCfdHMSA2Gppvo+GSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3evS3VzYp4BwjqPPu3MHdkTGH2pYc+YL2ehIm8IgBHY=;
 b=JJWVgDdWgXZkrSopk8CVnHsK4D7RLos26loXETPPPlMuEtyxAiGHoze7pctqWrpXm8JwtGHCfglaOFX6vDnDlQQivRXTW0lhYtv4yncdUQ/Lq0+xF5yQt4YXoryGaVEwWeq+vtt8Bqlic3m18cNGxG4y4FUKcaIuPwT3P7Zl2FE=
Received: from BN0PR07CA0003.namprd07.prod.outlook.com (2603:10b6:408:141::15)
 by SA1PR12MB7223.namprd12.prod.outlook.com (2603:10b6:806:2bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.21; Mon, 22 Jun
 2026 10:03:45 +0000
Received: from BN2PEPF000044A1.namprd02.prod.outlook.com
 (2603:10b6:408:141:cafe::a9) by BN0PR07CA0003.outlook.office365.com
 (2603:10b6:408:141::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.19 via Frontend Transport; Mon,
 22 Jun 2026 10:03:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A1.mail.protection.outlook.com (10.167.243.152) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.159.10 via Frontend Transport; Mon, 22 Jun 2026 10:03:45 +0000
Received: from [10.128.114.94] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 22 Jun
 2026 05:03:34 -0500
Message-ID: <054690e9-9113-49a6-844b-79d85045a3db@amd.com>
Date: Mon, 22 Jun 2026 15:33:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] drivers/migrate_offload: add DMA batch copy driver
 (dcbm)
To: Karim Manaouil <kmanaouil.dev@gmail.com>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <kinseyho@google.com>,
	<weixugc@google.com>, <ljs@kernel.org>, <Liam.Howlett@oracle.com>,
	<vbabka@kernel.org>, <willy@infradead.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <dave@stgolabs.net>, <Jonathan.Cameron@huawei.com>,
	<rkodsara@amd.com>, <vkoul@kernel.org>, <bharata@amd.com>, <sj@kernel.org>,
	<rientjes@google.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<dave.hansen@intel.com>, <hannes@cmpxchg.org>, <jhubbard@nvidia.com>,
	<peterx@redhat.com>, <riel@surriel.com>, <shakeel.butt@linux.dev>,
	<stalexan@redhat.com>, <tj@kernel.org>, <nifan.cxl@gmail.com>,
	<jic23@kernel.org>, <aneesh.kumar@kernel.org>, <nathan.lynch@amd.com>,
	<Frank.li@nxp.com>, <djbw@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-14-shivankg@amd.com>
 <20260619160725.lfcxrbj5go67qy6u@wrangler>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260619160725.lfcxrbj5go67qy6u@wrangler>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A1:EE_|SA1PR12MB7223:EE_
X-MS-Office365-Filtering-Correlation-Id: b7e435ef-f0ca-49d6-9c8e-08ded0458c4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|23010399003|82310400026|7416014|376014|22082099003|4143699003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	ghe90NWyNHd1mRsS+1qEwBMOaXNipXWNt/WJmK0PmCqeaRMcN7ri6qV97SMmK/IuoXDTvhX98iEqt8GRrNJbavX7hfJ3D+VzvCUIXrRM6S3RQ2L6n3W8DFw1NJe+5CQk/mIMJszW2l1q7X9zIJ/0YLpZUbys0+qTfeLkwB7yx171UlkvnYloMfn2h4mTXZ0Tr/BzQX9Wn2fWiZv1C0EFFd0no0fxh8hWMZuXuxZYhz+P5pfYT9hH7ds1J1bwC5qurBdkCnrCFauX64T/5HZlTaYvziAH7FlNkNtHQcxxPozTlyZ/b+0WQUwtTPo/rXSLxelJspttczM++mMscflpVEM1g/lnk3a3dvoboD+T6AGWVNb7MpkXDtL7LGwUWiW9Uz1NH9Jza85jkIRhPFtdHU3YMvsK01kOtbqnyY8FKsi1VFY1X8ADWq8++G9dH1dScf6btKgKIhfw9+TWaxYJTOQ5wsAv9JfZX6pGIzSq6LVpXtcvgO/mfrFMtMfNIgGU/qdMwnP1CHtUvuOepDVywEoDMOiNJz7pYV+jqPE5rJa46Eb86sjyeelqbaPw5hb8Rl146pCzct6noD9wNBsSbLOVnPza4z/6+ORZtgblTxkaMlpy56jeazYIS3LewaQYetHH1P3+YmJtBjDu3dluocyqVgrXLVQ656wYMg6/hp4EqvpRKEr7BS6wn/6pNF1GKvs+7ZX6BIY4mSQluvxhAQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(23010399003)(82310400026)(7416014)(376014)(22082099003)(4143699003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	89BC22yfbQ4cp/TOlts4raiKo6M8y46/ruT1cbIyozAL+J3OTlPXRu6C8nTCM6hbwOLkl2SghWo5RYDHxWeh1mygnH6iEDHm2TtB7XEvgqBg5kpCVy5nFl3cqvZeMm0RtT5a0XFIepyJXucggrwpHyHkOZYTkaMgHRfBR+8cZqAiJeudh91GzJFUVvOqC2rAxMyUrWCfPxaixogcb85YoyvecAXed83Ijl6611Hkfra8s2qR9/UzclXgqk0+rVDgxWOm1Pim5DaJasCXs+fRFgSiVrkN0Jak99ST8CreJsBFhy8zMMgEtj2UP5pAmJ9PjQkil6fBrqx7titDmpsQvfdtH/QKSdQ1EaS3OGtjyOPgX716ixivXHcIB+9Xq3quyskn7FTSp7Y1pAEp02EpYDdCtQy022/iEsG28GkC+axDLfiobx7v4vsaXVwtklaO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 10:03:45.7850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7e435ef-f0ca-49d6-9c8e-08ded0458c4b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7223
X-Rspamd-Queue-Id: 3F68CA0008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: w8sew5fuc8cohkahj574q7ppe7daitrs
X-HE-Tag: 1782122637-182669
X-HE-Meta: U2FsdGVkX1+ryI05h01ETRnESLT6BQgYTA5+ZKEHn8g0oxemU2uwbPQNfVlO754SD+2D16VAyMfOavoUDL46ndKfTUj++4g9gE88d9J7ARh73pDTnehyzNH0AXjUZyusOENYjcWEgSuvadMlztgPdpAfbmq1msEK2oj76lvIHN6jmuclFmFoEMah+OOwVDfnF4CT4Qyvn3/xFS7OlJB8MfCfKHZ6oIlcwMTsP01xswJ1BXn/Qmzfjwy2upMXU/0CnEgqpnnUG8oIwJkp51M0qz6val/p1PvdflMzchyOugQCXSXbiMULuTz4QNhfIUkKf7PRWYHsuTHpzslhPEzdWOLmyVRcSgfdGmGnRAyg//ubwNPQf8eaTVSWd8MAxFBoVooM7OAUDR792Zimek1EYzfCkUEs4gJ9I2ZkASF+IEerGtKoVkMYxMeDL+bUOssxs8j4hNDsvE/9o/mOMyCCO1+nUcc8uVAhP2jTF2mw3tVYwXBok+eBgLSFzQ1Y4m2dC/JboQ7PHa+V19edvctAaWOk6MoEZzbJQs6srDuUw0m0j5VFjsrysto+uomQt4oj03Jo1M2o2i4IV2t7IC7V7wV7n1zTbv9tk71YFkP83Ql3w0VkSK3Z02aL3k2Xg1zRiGjPDy1KBeTF1clMcS9FScezfNYJ2b9XTTaXBA299dGLQueroZ1IFlCGxUtAqihgpLiIW4icSVDDU0usqvm7HOyIcSZaaohabzquG6r1DXSilkZg+4aP3VVRZE9Lqr10uBz0GyPnMeKuLazKrMI2x92SFeIg6FZLmAuJGVcuySXEy2NlDqazwEE23leP8WRGrVEvNwJQTM90JFQrIh2p8JPEZV/sr3tFEB5EmcAG8z8fgK0+su8Cd59Ij7twBoXBWgcFurvw1J6nY8REK5PBVwx5En9z/k0QSMaHlGQ15D0Dbyq1PYQI1RIVxNY/nw9enbOtsdX+R5tOBh2W8nr
 b6cmhU2S
 DaZe0hSkO6ypNgpLGVPDJUXT8Ir9Q5i8Q4ebHMPfTU/zJpVAhP/1QftwvKjwPPM5mil1RtW7qRAm7g+4pW8bH5W6qdq4xPKAoEfVxkO6NnD6qJBFrXHDpNIuk6PuUOwZ9Vf8bQv9pZdBWU/yWnFKdNAann493zmT21ifok1MSQWsOGsqYTDRN4DgwbHIo6olHRT/5BgqTisMlCaLuFyYfKk67bM/emXe2pjxU/lYU2PvRasUWICDUB4xxRaaYFQbRGGkjchrwLW9TqH3215J8ga5MmSy/xkQv08rMGudQgvC4B74VAfMi+8NMsXRGqmt5BuLoKkJjpI5M+pijWgnIMnvRucBhqpIJE+fgBnTQghAvp28v6n7ZXoq0+7YtD8dRbsiwAOpV+7P+44Dp2qVnUPusEWpcFYJsq/BQkE/774il132iOZ2j9TkeaFIcrkwyl8UtsCaj6XegjBOhq/epLrn1e4PDKXbmrAjYVVjXIn2jh7rIsaz56BkldK8goKXoTT3XGLh/gx04KDZVX+QGiOd1eIYqJN4wP1nQlfZZ3W9fvCh/b/9oGzOmETtSOefACiS/xr3DcwHdDVHIbw/v3aSDpMaeKC3bqc3VAaoZUNZgEyOvSZT5ALdDlRQgYr4MEZXNJ3/xIssxW8S0gDLulsiXbFtXhYKafXwzi3JrVc8iN0gHw86jPYeDjuWF71D+Uzj9z5L23FJH59M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/19/2026 9:37 PM, Karim Manaouil wrote:
> [You don't often get email from kmanaouil.dev@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> Hi again Shivank,
> 
> I just got some time to resume testing this on Intel Sapphire Rapids and
> something caught my attention, below
> 
> On Tue, Apr 28, 2026 at 03:50:49PM +0000, Shivank Garg wrote:
>> +static int submit_dma_transfers(struct dma_work *work)
>> +{
>> +     struct scatterlist *sg_src, *sg_dst;
>> +     struct dma_async_tx_descriptor *tx;
>> +     unsigned long flags = DMA_CTRL_ACK;
>> +     dma_cookie_t cookie;
>> +     int i;
>> +
>> +     atomic_set(&work->pending, 1);
>> +
>> +     sg_src = work->src_sgt->sgl;
>> +     sg_dst = work->dst_sgt->sgl;
>> +     for_each_sgtable_dma_sg(work->src_sgt, sg_src, i) {
>> +             if (i == work->src_sgt->nents - 1)
>> +                     flags |= DMA_PREP_INTERRUPT;
>> +
>> +             tx = dmaengine_prep_dma_memcpy(work->chan,
>> +                             sg_dma_address(sg_dst),
>> +                             sg_dma_address(sg_src),
>> +                             sg_dma_len(sg_src), flags);
>> +             if (!tx) {
>> +                     atomic_set(&work->pending, 0);
>> +                     return -EIO;
>> +             }
>> +
>> +             if (i == work->src_sgt->nents - 1) {
>> +                     tx->callback = dma_completion_callback;
>> +                     tx->callback_param = work;
>> +             }
>> +
> 
> Here, you are submitting the descriptors one after the other and only
> the last descriptor has a callback, which in theory sounds correct as
> you expect the DMA engine to complete the descriptors in the same order
> they were submitted. However, in reality that's not really gauranteed.
> 
> Intel DSA in particular can complete descriptors out of order. That
> means, the last descriptor submitted may not necessarily be the last
> descriptors that completes. In that case, you will return in
> folios_copy_dma() before the copy truly completes for all the folios.
> 
> For correctness, we have to add a callback to every descriptor and
> initialize work->pending to the number of descriptors submitted then
> every time a descriptor completes, you call atomic_dec(&work->pending)
> and only complete the completion the moment it reaches zero.
> 
> Btw, waiting for an interrupt adds massive scheduling overhead. If we
> also add the logic above, it'll get even worse. In my measurements, this
> can easily add up to 6ms, by which CPU page copy have easily completed
> the entire copy, which again adds to the list of latency concerns I
> raised in my other reply.

Thanks Karim for catching this.
I was not aware that descriptor chaining was not applicable for DSA.

Going forward, implementing the device_prep_dma_memcpy_sg() fixes this
broken assumption. So client will issue single transaction and see single
completion for whole batch. The ordering/correctness will become provider's
responsibility.

Thanks,
Shivank

