Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 466F0606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=h9yowQd5
Received: by kanga.kvack.org (Postfix)
	id 6A27C6B05B2; Thu, 29 Oct 2026 23:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A826B05B3; Thu, 29 Oct 2026 23:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5905C6B05B4; Thu, 29 Oct 2026 23:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BD576B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:45:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AF31160332
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:45:13 +0000 (UTC)
X-FDA: 85377902106.15.4BA2C2A
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	by imf16.hostedemail.com (Postfix) with ESMTP id 08549180002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:45:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=h9yowQd5;
	spf=pass (imf16.hostedemail.com: domain of bharata@amd.com designates 40.93.201.38 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793331910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IikUAO8lSmNSAkvhUkTrh9Ju9HI1G1d2+VF79RdPZh4=;
	b=aaAo8vPuG5cBTKHnPOm5CU9bbTRJEHr9BePjiCt6e8Q6nidn4Sb2/Jf9jDhUgXQI7QSrMH
	70oeme8KXeSX8CqfecSkID6Ze58djhpuiMFW5oiDGTtGoNIvauuRbafODy2615mfx8D13q
	PslkiylrgMHAErXF6Js8LMqIfXPgMVg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793331910;
	b=VdZ9RH3K44fYHPW4fzbhMdF1I1jyWfaSBiXU7kDh739zoD9+5YBuliywejvIwf5bUGnknP
	fLAJ8v+SDhQoxopxAOq02i7SW2txlVKR+cp/f/ySWklOfd6iSnobI0n+IXYbQtV6iqvkem
	YuzUZHStScZNM3CcXQgd3LAGZLmeC/E=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=h9yowQd5;
	spf=pass (imf16.hostedemail.com: domain of bharata@amd.com designates 40.93.201.38 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wZC6iE4zn/trnSrz8oDKWUMrNxhkpYVnkJ2IYYclzNUV4WGUUeGzgRF2dP8aXW25RjmhWtjFtIW9aGudSKBgXeNDjoyyElD2937hbe5MQOjkClD/J+NJxfCL0UuxeRd6u82h6u+yJXduVAiclaA0Yx8VdgJEK0jaM2vpYxmjjBMfr61HGXu1p2djc6QduVWpszE49QdMRK33KACl9XssrMrubIRVs9meM1WpgHP3tlXOZllQ8cCMUFFEMlahQaRG40pD78R0Mj2JPkOvaGshGkfq0RjC88n+m9PFbq3EnnUuxzTkEt5spViNGEcUg7K9Js50k0TMFNvjFHiodNfDTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IikUAO8lSmNSAkvhUkTrh9Ju9HI1G1d2+VF79RdPZh4=;
 b=ghiRmtpVejJsLUwmoFJiAXlZ09lxRlL6DLlyKlxYDeBqbeopcGZIzwEIg4yYHZVAkpjrT0V3XSw32SSwZB8jLkpOO6BnvTfLytvkUykVYNOFTLZOXO5EJQSiUAIHI5fIPN18mPMDGYcVoTWcnTKEhQ9s7UAD6eV8WsXcd7YOdpZYg27uz0irOoy4RQZR04b+SG+xxrJQkwFiZ0w4knWeiDiy+z1kfHMd7RavGiZDA+4U7AwNAdtMujrv5ybbQX2pz7H9DwUbSX6oGCZ0d7qWrrQ7slclJBBN7v8eSAxru0uLheHCMiWmzrQE42xfa3emhriNQ0FdOoAL+WOzYXT+Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=bytedance.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IikUAO8lSmNSAkvhUkTrh9Ju9HI1G1d2+VF79RdPZh4=;
 b=h9yowQd5RFO57r3Y1TK82DNALJkPb+BXstHYz/RhhD97ccO9ktaLFOMukJ3kcAKFRlG53my2TQS9Q/AzC0t8HrIRTCxMZ1c7rUqgOncPk+dH0pU+qKed5aysZeXOWxyjzkwbMh1GlZkaaMhrTwIDgBsEiWkVUfouTvjOEpXFURY=
Received: from BY5PR04CA0027.namprd04.prod.outlook.com (2603:10b6:a03:1d0::37)
 by BL4PR12MB9507.namprd12.prod.outlook.com (2603:10b6:208:58d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Fri, 30 Oct
 2026 03:45:05 +0000
Received: from SJ1PEPF0000231A.namprd03.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::30) by BY5PR04CA0027.outlook.office365.com
 (2603:10b6:a03:1d0::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.8 via Frontend Transport; Fri, 30
 Oct 2026 03:45:04 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF0000231A.mail.protection.outlook.com (10.167.242.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Fri, 30 Oct 2026 03:45:04 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 29 Oct
 2026 22:45:03 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 29 Oct
 2026 22:45:03 -0500
Received: from [10.136.40.60] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Thu, 29 Oct 2026 22:44:58 -0500
Message-ID: <c9cf96bf-f3b1-47da-b22a-9600b5fb01be@amd.com>
Date: Fri, 30 Oct 2026 09:14:57 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] sched/numa: make free-space tiering promotion
 bypass configurable
To: Li Zhe <lizhe.67@bytedance.com>, <akpm@linux-foundation.org>,
	<bsegall@google.com>, <david@kernel.org>, <dietmar.eggemann@arm.com>,
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>,
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>,
	<mingo@redhat.com>, <peterz@infradead.org>, <rostedt@goodmis.org>,
	<vincent.guittot@linaro.org>, <vschneid@redhat.com>, <ziy@nvidia.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20261028041253.74839-1-lizhe.67@bytedance.com>
 <20261028041253.74839-2-lizhe.67@bytedance.com>
 <0676993f-c04c-4e4e-9f8d-1650c8fd6d6e@amd.com>
 <010b2b6c-8f1b-4c3b-913f-cc2e8b957759@bytedance.com>
 <a6bcd771-fcf7-4fe4-8c21-5e65bd579de7@amd.com>
 <1bab234e-8914-4694-b0aa-f265fa49c6d3@bytedance.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <1bab234e-8914-4694-b0aa-f265fa49c6d3@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231A:EE_|BL4PR12MB9507:EE_
X-MS-Office365-Filtering-Correlation-Id: 306498a5-3563-4331-8617-08df36382ee0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|36860700016|82310400026|921020|4143699003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261021123027099003|261021121427099003|261022105027099003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	GdzPgUNKan1dEr+SsMKZvP4L1DAy+brnTdNfyIuXAzv2lMsnjFqInjDQJosTKH7E8dvxaunECqK9AxIJgSbDv7Z60qt296RRYwqBnVh6wsWPLH1sOQqkfR8HjscysamM30mrnXo7gQeRZMctj7XEaHOVk0vqYyY57o3mIuqaF8hHEb7vBpsuqexM4KiYuzLUTXS6H7MFbTskI3kZuOYocHp34r1Fs6HXZw20LpSsEInitFKbqytXFnRghbsVA+wPw0vFO8a7hg0Y0M0EEWoPj0fTFjNAneVcO/M4QWFun+OaXaAC9zqx/9iJo20Lb8hPgXWCjv4hCj86Zy2GPJe1JNTemIobz+VlpnWyKdKUfaF5Li1TGOGLPx2vgzDkOWxJnXE71v9PaWII3hS0zcMOKYcTgNYXSH0eIhOTHdslfiGiS5sn4Ral68w2FRvQZFmnfYujJ8jfGFlPB7w+svXn4uNAXxA0h8OQSG81D16xejYRGEweOKGBxZa3AdEFfi+i2WctkLJ1CMcrt+QKY/WDgtxPXeSeJD7HKJ/OeQNrGYaDGfsGXKR4aknAkUy5oBwwrjeQmmXK+FDwhWCGBxFGFrMWwRJbnG1JjasGIYEuuJyKeNqhLKu3DpCmkLVr2KiiYojGd46FVtaf7oluZDLxn1pbaUsZ74d14vFmREfCjzK0HNHEG3BJtRv496uK6kI0Z4PRleFsD//87zA7uA0yGeC9YCcxanGVnEO0ejOlIZiHzcEJDiqdhZmgky3AtVFo
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(36860700016)(82310400026)(921020)(4143699003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261022105027099003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iZjg/17YPA5A84SHf7aDRDN2/YVjvn04u2f6PkmtGTyO0QntStciLuNEd/VDlCSVcA4smx2FBh9UabTTYNYYxHsMMzymUOtjaJNp5MFuhpa/FVBgCPPNe3GWdFdFaFjdUYjfw8UdttKZts0kB9nwlpJwksqQNK8jc2wP5SbDrbC6c2BmcnBUDUXv7yegTFvPgHbTjirY1naK3lhR9FRYv4NmOmPQrmtKdKDitRYcA/p6LZV2J06jTT+5vHtPhCqxianwAfXD6mHQx49EldupyQHvNFNYlBsCE6ofhfjZlUeE6JGWJCP7ARLZrpUAizLEBR3nEh+fCo+flfzL4l8Zjuqy9VIWk8aLVLvllTjYYZO+68cYKZh4KbJkOZhshBtqWPS3SwUjyJOl2tvRKqBSAkS8v97kUcRo5F8lczUw/NVpYvw/+MmTs2TPUbYE7eb1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 03:45:04.1161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 306498a5-3563-4331-8617-08df36382ee0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9507
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 08549180002
X-Stat-Signature: g3nms1pr1us771q35oe8fgxywgbd1xnq
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793331909-168879
X-HE-Meta: U2FsdGVkX19TTtyEUGem9JG5FLvo/ADXfzSAFDXk21DHQvysLuwXKAVZKPlh4o9blTmy4SIlUZ/d2aXiNL0kUl7fqGyTFKAXEPPLnxh55dbA8/Q1iD5A+fDVIe8rBvND41Nz2i8NonX3BrK+wFYPMxcFn/9Ay1KKZftXegQizJC/LZ/Fid1Ggx7vX7oBZKQL5mrUcsn54/PRZn7FGsIPuVvBuSlg6B0fjVkqiOUu5asKLHwSAG1phivbD/uZZ5is1xPwygfRR+PmWW1ByiOVGobbHn0pw0T5cWrN3j+kggrI/s/UA6z5KI0t0mu1FZ3/0/bC+VU7gfUJ0ljhDGz6EmEPQVS4ARn+msoSLdf5XwBsbMfw0KWlU46cgKa/xmQI4PwldzaU21CdnokAnYFsGuHTLWPEcUADcAKdL0eMWiW1Wd5Ur4dVLuOgdU8NAN9Jpe7b8138dQrwfOW2EgAnbsG1qO49Roc9NcxapNSURYZ/UxDBy57qP89K68W+MgkdbrsiTTTNNl4J7fpewj3QjIcnDf5gMUAfi/qmRQ/n6C1PSAsVITNEzYvK2zydL2jorjVHbgPlGLEo1EBUfGauIPY+aEbm+/kW5xp7itrw0O0S7OKO9mtBwYuS/6EIoIH/OL11UzztVW6jPL8H7n2k9sZfEWYfhWtmX9YWhq1Kz7hniNVV4iAUTF2LCCud6AmIMW1ShgER5Ewp0kbWZhGALmWiIpdrHwniBUW2Mp8Y1ENyFG+uzLuRqBtyykINRYWrdJcKijksGuaD7pCcAc8nc3z0trCOaBc9iIDr0xUr9CoprQUB5n4desUSisX3fXdBpSkGLCl9ybzVWHBsNHGg+IUPDJK/eCzoUD+cZn60VbhzBYLfdRjOqnDQIoQzZLbVq4JoGGEocOG/zhZM5DAL3dXHhHx8Egeg+2w5aRdZsjE3jui7bgCNz/oZONpnrGlTMsD2yZKiVVLVNrgBvI4
 3kB2f/cM
 E1lZ/Daanw6OoKRrLhxBRtVsYtb3izP9GMhAywyzuDYywF/p883P18dvWXv3U6BkYiA0sjbXWD26W7X35/9f2qfsKjcosVcAI+zbzeGuubvZWeGhzQf8YOVbkTzpp8yyC9IK0wOIfJOT9wqEih7zcSEeu3NKwx9xdA096aXYkgxCf8Imj5nFYMFxdWD6SFeWhiA5zVbRL1f3nlK5nuZUdGrTtErOM+Y1hYzKtEWZatmRVHsIcUl9zsIQs1ERlJ0yI0J5+UcGjPMOHHrgjzLEEEmX6rAA9iSy23Wv9yZtCD2GU1fCPeVH8kurgq38A8AKROL0s1KYJJT5FDwh4kRu0lBkrLqTOX74uX3YpWOpNWmqAiK4UQReCa04MSt0r00bT/Gl8NYycVtwhZjznqRVTX/BIEzcevAgYHygCp3z6OvY/+5fD0v76Zs4MSfF5QSV639IUzLnM8PpXj8CR+uy1AJxlSbxSqT4cHh2JtxSuDmr2aFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 29-Oct-26 5:03 PM, Li Zhe wrote:
> Yes, the case I am trying to cover is closer to the non-overcommitted
> case.  We do have deployments where memory is intentionally placed across
> DRAM and CXL memory, instead of relying only on natural spillover from a
> full top tier.
> 
> For example, the orchestration layer may want a cgroup to use a planned
> DRAM/CXL ratio, so that DRAM capacity remains available for later
> placement decisions or other workloads.
> 
> In such setups, the top tier can still have free space, but we may not
> want short cold accesses to refill it simply because the free-space
> bypass is available.  The intent of this patch is to let those
> deployments keep using the existing hotness and rate-limit checks even
> when there is top-tier headroom.

Thanks for this information about the deployment model. This is a useful
conclusion to reach.

Regards,
Bharata.

