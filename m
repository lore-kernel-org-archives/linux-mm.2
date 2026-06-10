Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3ACDCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 12:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B7016B0005; Wed, 10 Jun 2026 08:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267FC6B008A; Wed, 10 Jun 2026 08:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F5A6B008C; Wed, 10 Jun 2026 08:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0127D6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:28:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A4831C2192
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:28:22 +0000 (UTC)
X-FDA: 84863930844.28.D3D6379
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010007.outbound.protection.outlook.com [52.101.61.7])
	by imf02.hostedemail.com (Postfix) with ESMTP id 79C2F8000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:28:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=PB04Gie6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.7 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781094499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5M9n6qDhAxsk+X7Y1Hj6xb3m+sIGhZYHr8FSdbaKfs=;
	b=c1ctSBRzlBETlsHqnXIMZMRz5A2afEmeunm3jy5d+hcxwquBhWYNr9+pg6NBUoMKzy58wq
	Db6HpspjuioDSLvNrblriEfevUIolOROYAmd4BejRVrTenU6wxA9D5M3ukxNcKUazRCF+3
	4JGpRNXvzGGY5+0De77A+tbg/LD0o9Y=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=PB04Gie6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.7 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781094499;
	b=ezZnHsg+jb/qlrn+DKBGZjheX5wp3viwbvVppU3q+lLaWIvEIKXk7mvfmxJIzaENqTmgo1
	cdLzAgWI+7QM+gPOsHDow4YK3Fwi905HSuX2vE0QJuWHf2r5sp3eMyI1+2FAWfodz+wQCT
	m2aqMrCXtjodiMd8N8kK7Lke8GVBf6A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vibl+r+JRgBPAr171PbqM0suHmaaAGaa7TaacP2cVAeeyo/Vbhd7p+prilmihPwQ+7YdrgVshkow2l5ZGaRjLzFc/O4ZxFuGnPsz90KNLDf2gVF9dnG2AJ7Yv6h6vUpVfDZoOaNN0VZqrii3cIh4jrPixaOfGnQOY5vNRl7RhA8HBa8LiOCS5bM2aKoqZYVTge/lXmv9rhR+XgJhTGU1edq4+2hzjwYpGf4Xf1GOrlivWdsh3MQsxSbQ27NYr8eERJgaLBIQO/e1kJ0PLOpgwcAou8ohUTfGxGHe0mfxlgqvke8W9zBm3oEgZiVFK8aVGGUjf9MmzpcbL4RrXsSYGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5M9n6qDhAxsk+X7Y1Hj6xb3m+sIGhZYHr8FSdbaKfs=;
 b=lkccx2jzGnoK+uyVX6Lt8T8bxMcV/abAfBWC4wfO6NeCsQJfA6kRyb2iQzyrAuY0nEAgSFpPfXZaAbYFhhEocPSq8OY0vVNaqKzNN1DlURm3v8YGwxq+0/6gfyfYYynlg5U0YRH6Cr4xKIK6X7/Bpe2ImcvWhi97/JyqXd2XoG2pL57VpGo3lBaygU0CDJNwKw9XadDNVcotQ63nEX81Ub4lDN1fT8ZbHjPPHDE7m+n7xsuoYRnPg7U1tf+UvF2f5/K1K+GzG5UJixjlEkOPpQMLkXksawB1rLvmQPE4ykDaOsuxgSVspwDw1ptNdjNmYXo3KBj0AwYNBhvRq5Tgog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5M9n6qDhAxsk+X7Y1Hj6xb3m+sIGhZYHr8FSdbaKfs=;
 b=PB04Gie6lvKLNlxFAxy/XkGfCtt1w6XTsguKzuJ20weMK6mrYJRx91d8GNUJItoqHYZ/qTmTc/b7fqRdXUJPkvAdZwMFXy/vnCTU/4ZDoUzZyeMfWKDmh0ZL4X/dklz32jCMPeV7gMyd568D/crBUGcAZrMrDy3QkAQ5msnzbG4=
Received: from MN2PR15CA0042.namprd15.prod.outlook.com (2603:10b6:208:237::11)
 by DM4PR12MB8452.namprd12.prod.outlook.com (2603:10b6:8:184::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Wed, 10 Jun
 2026 12:28:07 +0000
Received: from BL02EPF0001A104.namprd05.prod.outlook.com
 (2603:10b6:208:237:cafe::8) by MN2PR15CA0042.outlook.office365.com
 (2603:10b6:208:237::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.12 via Frontend Transport; Wed,
 10 Jun 2026 12:28:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A104.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Wed, 10 Jun 2026 12:28:07 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 10 Jun
 2026 07:27:55 -0500
From: Shivank Garg <shivankg@amd.com>
To: <kmanaouil.dev@gmail.com>
CC: <Frank.li@nxp.com>, <Jonathan.Cameron@huawei.com>,
	<Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>,
	<aneesh.kumar@kernel.org>, <apopple@nvidia.com>, <bharata@amd.com>,
	<byungchul@sk.com>, <dave.hansen@intel.com>, <dave@stgolabs.net>,
	<david@kernel.org>, <djbw@kernel.org>, <gourry@gourry.net>,
	<hannes@cmpxchg.org>, <jhubbard@nvidia.com>, <jic23@kernel.org>,
	<joshua.hahnjy@gmail.com>, <kinseyho@google.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <ljs@kernel.org>,
	<matthew.brost@intel.com>, <mhocko@suse.com>, <nathan.lynch@amd.com>,
	<nifan.cxl@gmail.com>, <peterx@redhat.com>, <rakie.kim@sk.com>,
	<riel@surriel.com>, <rientjes@google.com>, <rkodsara@amd.com>,
	<rppt@kernel.org>, <shakeel.butt@linux.dev>, <shivankg@amd.com>,
	<sj@kernel.org>, <stalexan@redhat.com>, <surenb@google.com>, <tj@kernel.org>,
	<vbabka@kernel.org>, <vkoul@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
Subject:
Date: Wed, 10 Jun 2026 12:26:54 +0000
Message-ID: <20260610122652.129407-3-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260609161742.phipg7eid3yy4j7f@wrangler>
References: <20260609161742.phipg7eid3yy4j7f@wrangler>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A104:EE_|DM4PR12MB8452:EE_
X-MS-Office365-Filtering-Correlation-Id: c3097c9d-f895-4089-a8c5-08dec6ebb9fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|7416014|376014|82310400026|1800799024|11063799006|56012099006|18002099003|6133799003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	/6CcQT15UMYu6eUWLSpzzgqEVKPI5+SIKYl7nl5iqTAXZHXUSYuntQlw8AsWMqVN6+z1QE6Fa3o2rSC2FjkW7gTihSoVo3CZufayrEm7bR7jFfEqoKH/xHYpXBObmHnIf4d+qMYYg+Iy478Utunxi0PSGjvTJ8HQwtj7eOYx+Ba9gGfcC7GBNdZa9UXIZFcx0hRnSxk+Ez/7TtH3VenikakgfnzT6Z/yE+kFY7G4hUwZNVMDExz5f8NpWBW/8Kd+SwSntsywEPyyWk+3E2SRaYSKB0FyeZkuSClqmXuD/oFnnWGtWNSQRaA7+E15xRFNccimFP/vSjYPKRPlT0KbcDIDilcdm5ggv8rStluKmcYBwMKzXwfV6gQt+oCA/Hfm6OAg4/lwKXrJw04y9pyXy9+H4snYLw8Enq8ZYi5szB8Uu1Umn5JS2vDGHCl8nV9jvZ0xqBBCSQVV+MtDhJYJgVbXEahOF1vYrrBeHcQBXJa8otCQTgsYoFQ9E7CGIjwS0tThETRjCJ5/j+1K9q7v/sSKmmOMu4wWBO7x5fz4WHhMGAl9KSihn6VBt9I8bi6kqvMnkWqA3OjG2S0b27u00ronn2hlIztmGtbkrca8WcPOiJUR7FQPWKqWj0cbew4/0e9q++6HdIURYJzdKwwjwI9X01KxVzsZ/Bi3nYblN2Ps1I2evt2Dbyxhc8vrxNfuDfa6QDm+4oWhYBY7aiPpikFY/NeJPHKuALuO4tjR7L8=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(7416014)(376014)(82310400026)(1800799024)(11063799006)(56012099006)(18002099003)(6133799003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ewXR1Fgfw5e/uuPGb0i5IPu7Jq4eUo/3unhIYhNP7BZ38qX1bcHmFk6M1nphsYFMwvb+GignrpkOUS0YGlOMwfC2PQtHelDN1BCSrw/wxqk+CTAl7mbJbjZ8efW5b2OC7UEJFfAOyn2Xuu+u8JLCX4A3Hs4W0WIjQaAZH9bS9ROvtmXCquD7dSDs+EcQ4IDH4QxaMFATWuovbDFWF8UKk1tkrMQ1QvLeV/2M7k/8HsGMG1erFn38cxIamrMB9fIall/5OXo9GpilYqGMJ4+WS+QrbFoxGkdAHGFZgj/HZQvj+jNnAOfXLRgVRsB8pnaQRiStX94l5m60swKZJOd0HhgzEN1g4QqiglGgcvR+LD3FGefkvbs3onNDuYeGqut4ASsiyr+D6mrliAvCWWnuBcD2j+tsLCCTtRoAyDr3C8x8PGOcYtSoA/PKYitNorHf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 12:28:07.2652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3097c9d-f895-4089-a8c5-08dec6ebb9fb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A104.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8452
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 79C2F8000B
X-Stat-Signature: dnay5t75bhwu1qrj37umfec7tne86w4g
X-Rspam-User: 
X-HE-Tag: 1781094499-763072
X-HE-Meta: U2FsdGVkX1/wF5+U7TiWdB4HuFrf5pJ/rA0JVeYbc7bl6TnpbAtql0IPtugwu3yoV646LW7OKyfmoqdFv4lM4kooMV1UESYW43153WmfmgBYwAS/pjT6K08iNCkE/Vr6Kud9nclHUNg3f9SaDbKLN2SdRcgIDgfEfBUtf4Y/jeGap5GC8XuFji6Hqimy8Z9Wtm7to6oRws1Tql3XfBVLrhdp4+XWXw9mV8HwJpOY3NMqsGvqC4PSwgqMOtn1Er8mn1nvlYKCSHEQnlFkzJDFSi/bvjRbaghF8/qbXE66JHXydWV88QY/E4+4NPrSu6NxeDFJHY0VhE2x+eA+RYi/x7ghCYHF5As4FKXzhwP5Ek1cYOktd4im5+fQfvveTK0bZF5Y/UsTYw2wrzUeSlzRFgqMNGvTeQDPa5sRwxL3bIqGv7SLyekzPZVJ6dRRxQIxqPFyM+jKAna53BZ41Ng5mWfd/hSZL0yz8CO/mdI5Vxj/YbtGr1pf8pVAkJPBsJ2Cz5KX70xNo41LWyde2Sh1E0TmqXltpHDPA47j1ElOUuA6IQG2Ew4SUkffbclL3AB7lB7G0RGKqcjf62uMQl7A74wsyjXz95GB2cDmFiHh42JXRq31sU9vYmafMWvdl6xL4ZgEGOxnzpkirCuRxnuOVPtv35LAUWWJUfV4xE/wTZBgWujvxAvHpFwY4F9vRAfJvt659KmX/EmuXjA01G1tJaMvf5vCQHuSVhQTwX1f2s6FTxAjIswi1Ag4qeloNDDFHw42RHrjkzaF5Nh+RvxCVgcrTdqq/6GkC2lEsqYToPE919g6Hc+g46ZQuvAtJNqZujRFbvE72GJkg/504c38+Z5bRWcAsT+ofcSBLsvLsf4q6sbcP/7USyyvTA9XNrrVY0L6VPq6GY52+CTDSk/s1fqg515wrZJ9GiNac45zIU3tdkSO8JjhiJX+Ga1k0m96gCRHF/p0x/OQYQmfgJa
 HgCBNIv4
 AP5RLlIwbcwv2uT0K45k9sJYz8FwXxrzWbqMum9a5xf87G4YOiiVdqXDYl6pvPBwZlCV0+NjblqD1S/or5LAE+et8o5PukOE7DWPMpy9a78mrFkck0Ok05PVKXxfwUnj8GAFkj5CbIxCVSyTM1JxBpBgdmetb3fHMK76KXZ3oQXdXBZSvnauj23pbCNhmRmVevrlGhkYVkfx3OK17dR/d+JqZOzcwd02ITsC1dDOrXrlY/8/+eVTAXd9QYhBkX7TX5R0sybmkQJkR2/5qG/Ks9oKuZbpAMtxWq30lTQ8XBnl3i2X+RDtFDe3kvVyICummM28rElCjeg/6KoiqqB0q+cQkZj8hvP6n5QZ7FSrFcLZqYDQVLLYoi3hmhf/fpFwErwk5fG8O1+rBWN5mEnC8RTsCzjBBW1QRHb2higlpNnOq7m0W+yyY2Wec4DJ2f4jVs9nBGSJKq3QRFmL7EbqO2Jioxwdmw5qOPQtvxA4kvjoDVmqW16z7QJ0IiNskSQIQfQyE/mlpazMDWWIe4quZOyinDCBogpYFOlMkPblfS220V5QqprJHwBn9gcSgZjGh2Q1cNWDeV2YgMyie2FvR+sEJoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

...
> I'm still testing, but the initial implementation I wrote with
> DMAEngine had too much overhead because of the sgtable allocations
> and the conversion between kernel scatterlists to device descriptors.
> So I entirely bypassed the DMAEngine API by directly passing the folios
> lists to the driver.
> 
> I know it depends on the use case. If you just want to offload with no
> latency requirements, then DMAEngine is fine, but if the goal is to
> achieve high bandwidth with minimal latency, then it's a problem.
> 
> Another example, if you have to do several independent copies of 256 or
> 512 4KiB pages in a short period of time, there will to much stress on
> sgtable allocations.
> 
> Another problem for low latency is DMA mapping.
> 
> Anyway, I need to collect more numbers. I will try to share my insights
> with idxd asap.

Thanks, looking forward to those insights and numbers.

An IDXD specific implementation is good for experimentation, but
for upstream path, I think this would be hard to maintain and add duplicate
logic. The cleanest approch is the DMA_MEMCPY_SG API. So, a single offload
driver can drive any engine that implements it. dmaengine_prep_dma_memcpy_sg()
submits a whole src/dst scatterlist as one transaction, which cuts the
per-descriptor setup overhead that dominates for 4KB pages.

I've added a patch for dmaengine_prep_dma_memcpy_sg(), Could you look into
wiring up device_prep_dma_memcpy_sg hook in the IDXD?

This will keep it generic and address the bandwidth/latency problem for
small transfers.

Best Regards,
Shivank

---

From d60e4dcd58552cbc6c7ecee37df9e216ab0c5a4f Mon Sep 17 00:00:00 2001
From: Shivank Garg <shivankg@amd.com>
Date: Sun, 17 May 2026 18:19:10 +0000
Subject: [PATCH] dmaengine: add DMA_MEMCPY_SG transaction type

Currently, a client that wants to copy N (src, dst, len) tuples call
dmaengine_prep_dma_memcpy() N times, allocating N independent
dma_async_tx_descriptor. The provider has to treat them as independent
transactions, even when the underlying hardware can program them as
one descriptor group with a single completion. This overheads
are dominant for page size like 4KB.

To reduce this overheads, add DMA_MEMCPY_SG and the matching
device_prep_dma_memcpy_sg() callback taking paired src and dst
scatterlists, plus the dmaengine_prep_dma_memcpy_sg() inline wrapper.
The provider walks both lists in lockstep and retires the whole batch
as one async tx.

This API was removed by commit 0cae04373b77 ("dmaengine: remove
DMA_MEMCPY_SG once again") for lack of in-tree users. The user
this time is the page-migration copy offload driver.

Suggested-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 .../driver-api/dmaengine/provider.rst         |  7 ++++
 drivers/dma/dmaengine.c                       |  1 +
 include/linux/dmaengine.h                     | 36 +++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/Documentation/driver-api/dmaengine/provider.rst b/Documentation/driver-api/dmaengine/provider.rst
index f4ed98f701c9..fc3cab78e61a 100644
--- a/Documentation/driver-api/dmaengine/provider.rst
+++ b/Documentation/driver-api/dmaengine/provider.rst
@@ -175,6 +175,13 @@ Currently, the types available are:
     ``glReadPixels()``, which might require a verbatim copy of a huge
     framebuffer from local device memory onto host memory.
 
+- DMA_MEMCPY_SG
+
+  - The device is able to do  memory to memory scatter-gather transfers.
+
+  - This takes pair of src and dst scatterlists and retires the whole batch
+    as one async tx.
+
 - DMA_XOR
 
   - The device is able to perform XOR operations on memory areas
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 405bd2fbb4a3..665e00a96c8f 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1197,6 +1197,7 @@ int dma_async_device_register(struct dma_device *device)
 }
 
 	CHECK_CAP(dma_memcpy,      DMA_MEMCPY);
+	CHECK_CAP(dma_memcpy_sg,   DMA_MEMCPY_SG);
 	CHECK_CAP(dma_xor,         DMA_XOR);
 	CHECK_CAP(dma_xor_val,     DMA_XOR_VAL);
 	CHECK_CAP(dma_pq,          DMA_PQ);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index b3d251c9734e..9378e7a7803a 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -50,6 +50,7 @@ enum dma_status {
  */
 enum dma_transaction_type {
 	DMA_MEMCPY,
+	DMA_MEMCPY_SG,
 	DMA_XOR,
 	DMA_PQ,
 	DMA_XOR_VAL,
@@ -824,6 +825,7 @@ struct dma_filter {
  * @device_router_config: optional callback for DMA router configuration
  * @device_free_chan_resources: release DMA channel's resources
  * @device_prep_dma_memcpy: prepares a memcpy operation
+ * @device_prep_dma_memcpy_sg: prepares a memcpy operation over a scatter list
  * @device_prep_dma_xor: prepares a xor operation
  * @device_prep_dma_xor_val: prepares a xor validation operation
  * @device_prep_dma_pq: prepares a pq operation
@@ -903,6 +905,11 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_memcpy)(
 		struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
 		size_t len, unsigned long flags);
+	struct dma_async_tx_descriptor *(*device_prep_dma_memcpy_sg)(
+		struct dma_chan *chan,
+		struct scatterlist *dst_sg, unsigned int dst_nents,
+		struct scatterlist *src_sg, unsigned int src_nents,
+		unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_xor)(
 		struct dma_chan *chan, dma_addr_t dst, dma_addr_t *src,
 		unsigned int src_cnt, size_t len, unsigned long flags);
@@ -1091,6 +1098,35 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_memcpy(
 						    len, flags);
 }
 
+/**
+ * dmaengine_prep_dma_memcpy_sg - Prepare a scatter-gather memcpy
+ * @chan: The channel to prepare on
+ * @dst_sg: Destination scatterlist
+ * @dst_nents: Number of mapped entries in @dst_sg
+ * @src_sg: Source scatterlist
+ * @src_nents: Number of mapped entries in @src_sg
+ * @flags: Dmaengine flags (e.g. DMA_PREP_INTERRUPT, DMA_CTRL_ACK)
+ *
+ * Submit a batch of memcpy operations described by two scatterlists as
+ * a single async transaction. All segments retire as one tx with one
+ * completion.
+ *
+ * Returns NULL if the channel does not implement this operation.
+ */
+static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_memcpy_sg(
+		struct dma_chan *chan,
+		struct scatterlist *dst_sg, unsigned int dst_nents,
+		struct scatterlist *src_sg, unsigned int src_nents,
+		unsigned long flags)
+{
+	if (!chan || !chan->device ||
+	    !chan->device->device_prep_dma_memcpy_sg)
+		return NULL;
+
+	return chan->device->device_prep_dma_memcpy_sg(chan,
+			dst_sg, dst_nents, src_sg, src_nents, flags);
+}
+
 static inline bool dmaengine_is_metadata_mode_supported(struct dma_chan *chan,
 		enum dma_desc_metadata_mode mode)
 {
-- 
2.43.0


