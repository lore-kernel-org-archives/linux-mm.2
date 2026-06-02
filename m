Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B88CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07FA26B03D6; Tue,  2 Jun 2026 04:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030136B03D8; Tue,  2 Jun 2026 04:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38D86B03DA; Tue,  2 Jun 2026 04:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D07A26B03D6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:56:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7AFFE162C63
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:56:40 +0000 (UTC)
X-FDA: 84834366960.30.A8FDEC2
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010042.outbound.protection.outlook.com [52.101.84.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 686B580004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:56:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="fCBP7/P9";
	dkim=pass header.d=arm.com header.s=selector1 header.b="fCBP7/P9";
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf30.hostedemail.com: domain of Suzuki.Poulose@arm.com designates 52.101.84.42 as permitted sender) smtp.mailfrom=Suzuki.Poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780390596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVwClNW1C28VWmcLqOPYP3dNcsalNIEvmji0moK6wFQ=;
	b=sTwpuy4HePsVFEIc4KmWHTnHMP/l/hrHiGLxDU7kr/anuCOzsoySB+uQqQg9tSzvZi9JCU
	SKlO0Cau9s6CqPvQLc9uU46QqrdZHBKe292Qt9hqf22CpPJr/EVNBWcK10JF68lxmII9C4
	NnfOWLcjxmxp+NElw3HJEzcvgmIKumE=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="fCBP7/P9";
	dkim=pass header.d=arm.com header.s=selector1 header.b="fCBP7/P9";
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf30.hostedemail.com: domain of Suzuki.Poulose@arm.com designates 52.101.84.42 as permitted sender) smtp.mailfrom=Suzuki.Poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780390596;
	b=7I2rmVHUC/vyq2kKHAuMHdIfRcQwKj+G89CAHLSQoyZ2lR/hPyI8F7FNMn+FDX40HzgWmH
	qL3d3O1yq1sK1F00HgFYWuckWoCdYjnU6A5P767v8qHNKHiladbnyVsogSCplkY8GsbHdg
	ZbE4B0w4EhmcP2e5x35gcNuPJ3nRQys=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xAY1cjlxKNFUJxDbBYC7Ag6z4XM3KgT9Ulyy/5Q+wN9Zz+vkrI6dzXb6Qkq/UgytYSFnfUSiIx5FjTqwT+Xd+yBf9XZQRaUCvkHVWfoncGrZsXCkhnDl+/Egw3loj6g7+UUO4OepsGuKHl2/dFeUvwstyGwx1l2pi9HxllTXmhb1X++AOyDUvoLwBls9QRIMz+xBz6tJPD9i2SzbH8ugOdT7i6Nmkx2fKZgQM8qFdpdDC21egjlv4Udsn2pCCt6Dc5SFIrprNbW6yARxyVVt/PuDTiUqq95Zx+czD0UQFwSXjZb5hr7ChS0MyqHruzlgUOF8vRws/zYrgXYQTx9J1A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVwClNW1C28VWmcLqOPYP3dNcsalNIEvmji0moK6wFQ=;
 b=GiTVWkUfvX88qheorEAiyAjuDE8d5krFD6BaBI8jFuqfk42DJ43l17d8DCFCosvVqzbr2WZuCObmEsV3ym6S6/Iog3Ae0p6kP4s/jOmJ8N8N3egP5pTrVvw6uvpVXfLHQa6/YTUoq0EEiY3/Fc/X8bWKac6CurgeEWErV2ck280G8fFoTweRG03bOe/6b+ZRV/1AZTmJUXRoeuvS04rJd2EaLk/vYiWDi2T6Qr0ezjAR8VDrCpalRvoA/sn3wRAmk2ymOwALCXRKswVFV6xTzgVYIsyuO85KzGag0rja5OLCRihgLX7TpAc86Foy4AqkACdx1fyCzco8vuNfGFy84w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVwClNW1C28VWmcLqOPYP3dNcsalNIEvmji0moK6wFQ=;
 b=fCBP7/P9JBiWxn2Ow0lMXElILKVU7P0OKTYpukXcozapDVUjVkBM3sefZ7MobdsfUHqiZ7RoOjrZZ4/YH/gZaRAnwFEzWEPrl8j+1tlar5jlMJOFp2+tGeYYp7Qqr+HspF4WikVizPYpFnLYUnQs05TplnoSSybRQGHXkyRF2cc=
Received: from DB8PR04CA0014.eurprd04.prod.outlook.com (2603:10a6:10:110::24)
 by AS4PR08MB8021.eurprd08.prod.outlook.com (2603:10a6:20b:584::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 08:56:30 +0000
Received: from DB1PEPF000509E4.eurprd03.prod.outlook.com
 (2603:10a6:10:110:cafe::40) by DB8PR04CA0014.outlook.office365.com
 (2603:10a6:10:110::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.16 via Frontend Transport; Tue, 2
 Jun 2026 08:56:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E4.mail.protection.outlook.com (10.167.242.54) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Tue, 2 Jun 2026 08:56:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VQR5RYTqRu/iEVCDiLVM3CUoRVDfbz+xfTell7jAUqOb5QAhfhr2Oo6fbY0XunuQ1gZnPMTBK8/Vyt6E3B6ekE8dN57qcn9ExD4rGf+nGXNQTyIHHrSG+O6ESwqXBt3jIJG19Is2Vt9uP6+ZdxR+kQctizrljwKYiu2G3Lj+MOB4Y5gKKHtQVziiYnxaTI9HXtNxQCA5ZZhZm2ewsLfAPBXey7XFqXc2z3xL0ZXz0ZHcLgEj7n/EuJXI3QF4kOTF6oOzhgiPKR9gy/Ute4K4Hrq17nlb3DqWmfu14IFGaTc6kpM0G12YnR0ASrpDIj7xspBgrK+ZLkP4y99tA5utmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVwClNW1C28VWmcLqOPYP3dNcsalNIEvmji0moK6wFQ=;
 b=DO84yBwzs1VE7D1qC9BMHqa8jVykTJoIc9SB7QfFtYl++7OSHLAdMTQ8gF9jrVqqZ+e0O7VmKx3GUuiqSAqbeBycEtrugjqTX7psiW2+z6t5GTGvaUlHShA7IYDSSYWMi6lXqekeA8NWrsnNEXCA1n9Go5zUkoX1VPAyKtb0XueHVA7xrJB6s6DlfhmVb66PVnNEKeo2RkgN6lbi9qBL81Q2GOJDlDi77WLxbWvuCbDEIZgahIy+qltGIvz4z3mR2eE8kU/hFLZu0HTj2E6aQ8aUU7Xk3feopGWDmCCxUgUVsI7Y24Vg7AoB43a7WkTumWx+Ia7hhmD0MXI+LGlfVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVwClNW1C28VWmcLqOPYP3dNcsalNIEvmji0moK6wFQ=;
 b=fCBP7/P9JBiWxn2Ow0lMXElILKVU7P0OKTYpukXcozapDVUjVkBM3sefZ7MobdsfUHqiZ7RoOjrZZ4/YH/gZaRAnwFEzWEPrl8j+1tlar5jlMJOFp2+tGeYYp7Qqr+HspF4WikVizPYpFnLYUnQs05TplnoSSybRQGHXkyRF2cc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by MRWPR08MB11233.eurprd08.prod.outlook.com (2603:10a6:501:77::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Tue, 2 Jun 2026
 08:55:23 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0071.015; Tue, 2 Jun 2026
 08:55:23 +0000
Message-ID: <d01cf1ec-b85d-4af6-9810-8107c0e2a4ec@arm.com>
Date: Tue, 2 Jun 2026 09:55:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/42] KVM: guest_memfd: Only prepare folios for
 private pages
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, ira.weiny@intel.com, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-7-2f0fae496530@google.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-7-2f0fae496530@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0068.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::19) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|MRWPR08MB11233:EE_|DB1PEPF000509E4:EE_|AS4PR08MB8021:EE_
X-MS-Office365-Filtering-Correlation-Id: ae640d87-9e1b-4be2-184d-08dec084d6b9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|921020|6133799003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 v6/0WQ1SY7DeVMI4I+EJffATgPHldttYpxXsN6mQw6I912HTijslXGnz3yupVZZAplfwNmFzRpUW8zn5E/SFETfbCXVAxPBjh35C9Ue1Saud3vKLwr4AdvfEWXSuE/8S8PBiSnmea78bX4/LmMhaAVonow7lFHI5ACiwRMbSfinIYVjV2u/lHbFRYKMn6ut6aydSXFSG0dGrK5XwmB8KUwgsybQ3hAjjp5psDEN5vVhNEN30wOzq4zZdZafJzXfMTqjfUtqcxaT6xVBcrGfAF/A4TvWHaTlGHuuxQZSkf3DX9ZQ9YWIDY+8RYFPzxHSZNVdoroPLjyaLMOfgMIpIYiPjVKk6x+YrqIeIp95t8u+6fe1t35U6WbhV+UsVg+p1406H59tbJVnVxKs/lIS72wLCV20+ei0JG3JngdSoR8+FtYQS06riFAV1FiHcF81exs+gcpeceFmq3ihIZGp2Cbqs/OnZN7jfyeaE+Lcbk9pqvkL3cEHMICMeSQT5eQ/7dTlKl8YaeF9SxxiHVwm+b0dC4lpN/y1mUZ81nfPr2UocNRkwj1GzabvhcpARWmTITqbX4iQek2ZRf/rdz6zRygP4U4xvhUMuo47z2LBAd/OQ7nSNfM+GKlxi1K1/WS1lygWWv60e7Qvht7UN+UBarHsg8CRIrlE+AUtFUiwq9+QfVJX0oWM/ugOZeqPKlj/gmuRJAsZUC0dwzC7M+e5usTlrne9T71IDMkFAIG2mPu4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(921020)(6133799003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 GByEX+eaNY4Q3Al2OokcgbQT1ysLTTzFdZ3NthqXj1eiKk6Jz2XpO3WF4LjNSy5zMVHso25AwRXJP0bK8mQo+ejItzJ044LmIV/IsNQ3T7EetDkRzDxYmBck8UVkOzSKcHcvOVgrnt4aYlxBiCRkCoJ/+ikqHgiyn4oafCY52e7D8dZwcO8czC8wNyN/flIzHkK8njaq9qTmi9tXQlJf5Q5FUNx4mTc2wsxuinAq/dWY+4JsibdwlWBmKWtjffDljLDA3rL8Y8RQYjkZlY228hP61QOMOjrLKf9kmJrEBt3sAy8p8I5i+R/3gKPqBFPJfH5qanBi8N2XUIiGXhQv7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR08MB11233
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E4.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	46102edf-a740-46f7-cd03-08dec084ae70
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|82310400026|14060799003|36860700016|376014|7416014|921020|56012099006|11063799006|6133799003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	is3iPnQSiv3YPPy/NmptZHalhF97CmufLyfcEjvV6ugXcx8dSMSy7y5jTgrT9I7Oso665E7ZrCljQ3vAP3WoAY/lVodKoWxVtrJeA+nr2sGU0cw240HHKBwIV2fwGxp57CzHqD9Px68DzoZxqpqAi8mBCQpwilYxd/rCPoSr7CUVG2HKTyp3vhk1QO3uw1he6Uq7WUT5J9wn2nRjsN7euvIhLN9LYQGekvw0wXrdvpLN4Ite6rTzdN++yiwuJ9Di+Tp0zP/xlVivul1qaB/H1hAOXTMdQbdUyWR4IAIjehcWfLMAQdi79BcPi2rthVUcfY7BIbX0O461T9pJrhf1pBySZUZPLeKpJADdTClLfg40hId+Wqf48bBdDp5m3B62SfuL+VKdk14qycLCqET1TI+aFCq0s++Hks+TpxEHMzwYXb5apWPrWmU+x3ZHUqrOmEV/rfYQct1qAjnk/PkU0p+eZ6MWqOhFPhfRsFbeVYK0rtqEczxs+PFgMbBVlVv2GRohnS7m5bVAUoDH0zBGeWtyokRrsjSTYwwR2WxitP1m59ac427n0vyqtGKhsJUcUBvRtYHWzEtm8FHNn7i1yfWVufv5DfPv9I9Q2sbpoZDQ2DAqwoA6+3DcI+EIKM55RbCaWPQVyidHegbGPSJW84GCA9cVH1EyqEdiwgqFGy93Dscxs1xNJfJymrMd0czb4sky3NrtUyaB11TodCP+5l1Xc4xJ6vn5GGEx7ptqke3bSB5IbyvRsijhSF7YYP83baZUJQ3qQsM/24AMd2FNwQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(82310400026)(14060799003)(36860700016)(376014)(7416014)(921020)(56012099006)(11063799006)(6133799003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hFWI8TShHuBCMEQHn/4o86gvet5mogDUwhd7JB83cPDczrB5/RIej2FIpxXLjm7eWR3tjniyDWWRjCIYQP/bgZOTKV4CRJJ1+fxHWTUiExQTGTvFFsIsrymn41MuV+cyIZQF+L8cgBXFxk4wgcHceOty2eIW31mTfh/IxFmB8kGf5ofkM6caIlFU5+RDGj2a4vUvtinCt48ED3wlZ/o8LmNjBxRF1QNQgiLAT7sOmLmdjEnbURCR6R+j+P8szQZWkh5XBw+kDLGqBBb1MZG6JDWQL4l0+uN17bBOWmRP9VvkGpHVdT4CMYUIDIaXItZtQZz0Q4VRhsnJLTtfXymZDL4So+rRgJNKE9ASo/tEWl0PT55MF4XT0gCfQspZpFMAHQn62oVpuXDj/fHr77wVHLP6J9FeGs84K4VKYANQ2twJ6u2nYCw16fMKL5dxyqCy
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 08:56:30.3169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae640d87-9e1b-4be2-184d-08dec084d6b9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E4.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8021
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 686B580004
X-Stat-Signature: 8nbcm3qkqqye7qtpek5864bjqoh8zshb
X-Rspam-User: 
X-HE-Tag: 1780390596-816015
X-HE-Meta: U2FsdGVkX19xiWdyWkgi8Uns3iwB1Caq0TrmyPu7jAxnPycmkLMir3nNJ/bTaPiGg9Ej/dzY/9tRxF3b2M8u0jlOGfSX/7oEENOOZHoCS3kpazZucPs7hmzIs/1GC1BT/M2MJGNhR1lTKfAvOS3Lpy2Ic6q80erP63wcss3POEyd+k+7+I7hwAe44spxntmUqWTfgx57oonut0Tx165xdeKnjMwY8KIbaPWWdvcdptoifyqoYeRF0GwVdgzT9gZjj8MA2AU4MGy9WyqeAgrWJ+BkaIY+8mkyfniBzZXS7Hq83vhcaA2+gZxevrd2Jc41gutN0qoMVzD7YfXd+ZaGML6xP8muuVJI7lIk3Ma+OU5SKfxAK7NVcFUWyJbgOmfTHSrugRKJ9eETCjuDCpCX+Dxd8wwNVj8KOjn9Wj/+/Zd1cR5du+IR5sDxX2D+lTGIWH78UWzXbFXChywsKWjIdkawgabnNe9wKHeCvUqGHQfdSB6MiWgCfLBvai/hm9GZ78OarUcDFPxwcAGPp0ahMTxDgcJ6LOlTlzqiShz+MHMq/cK8+Ta/FbrqOvvL/HwdPIpJR9GIyS/v1K+hkCsYL93LJOCBFCQwnGjUKBFigN+MVIBdEta8psIAT86cXMLRBsTQRneE1+BIDJf8SDaFBMhFV76/s3uAnQBj+eV1S3rpODPZ2T5GrXw/iIpHTfcXRkwuQw6IkkNd4S5g8ydvcvhsRQ7AXVOI6vh2/PU+BAzc1vkm4NV1B7FIgUD50HtPgsSOAwozx7w0d8ZgCMyi/qzCnLIB9KaBK95crgyOUkOkbd/kwnS9wjY8uulWLAmWuP/u9onbnZ8wPig2ODrovAzZdIg/ij8bcIps4Fl3H3BvdBYj/Kmyleaqz9ai1aDnb7oO+9kn51TRJAzfLMPW6SDmB0IyMyZ+VxWpftDGfPMpEFZUjni57ar4MFx+J9Dn0KAr31qkfUuCpIJEgPq
 +O2Xa3yU
 x7S3K1XNj3ccvEsLkPFFatXtpV2z7F6klC0FaVe7WGzGyJedM23IqwvMjHrdjExu8GCDPPB+7yDn3T9+umJcyLFCoggLwMKzWPLER10oSG3CIjTICE0zeNAc82GOKROH/bWrOjNQnH9pbzYA2r+t6hEdS5ZtTeXq/jV2PULdH0uSriHdLG7kiVVvtSAASJMZZvuBm/Ue/QO9sfuX7AEtJsmbGomcyE37v1E4Q0U99ORCVhzC96jg5ZIBPz6bPXaAtpfPCgpcbD6+jW4T2oEXdADS2Lcl/tcuvzsYNJjRv5vKxCk3rQAkVH1GbD07CBpEzFNE0DPdONXHnssggKgU4ZYNkAkg/dCBzVx/fP3RzHi7739y/X50jhh6pdNzhf1UbgnSe/KhSKZZ7EXdunlyD8XhZ53IwGhDsFWXy6gHjTMDrdRxi1SoSzc+VcG5s7SRC+jtt+W0qNyL76auiKLEKBQ7D6JXRkb1eP4dWOYJns+2pwjhTQ2qgiLk7uzqzJrXrM+b1iL7WOM6kr2uu2/ngnKbVTLXgChAc3CCzCgzRvmHZD9U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/05/2026 01:17, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> All-shared guest_memfd used to be only supported for non-CoCo VMs where
> preparation doesn't apply. INIT_SHARED is about to be supported for
> non-CoCo VMs in a later patch in this series.

nit: s/non-CoCo/CoCo ?

> 
> In addition, KVM_SET_MEMORY_ATTRIBUTES2 is about to be supported in
> guest_memfd in a later patch in this series.
> 
> This means that the kvm fault handler may now call kvm_gmem_get_pfn() on a
> shared folio for a CoCo VM where preparation applies.
> 
> Add a check to make sure that preparation is only performed for private
> folios.
> 
> Preparation will be undone on freeing (see kvm_gmem_free_folio()) and on
> conversion to shared.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

nit: Missing Co-Developed-by: ?

> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>   virt/kvm/guest_memfd.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 78e5435967341..adf57a3a1f5dd 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -894,6 +894,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   		     int *max_order)
>   {
>   	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> +	struct inode *inode;
>   	struct folio *folio;
>   	int r = 0;
>   
> @@ -901,7 +902,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   	if (!file)
>   		return -EFAULT;
>   
> -	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
> +	inode = file_inode(file);
> +	filemap_invalidate_lock_shared(inode->i_mapping);
>   
>   	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
>   	if (IS_ERR(folio)) {
> @@ -914,7 +916,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   		folio_mark_uptodate(folio);
>   	}
>   
> -	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> +	if (kvm_gmem_is_private_mem(inode, index))

Don't we need to make sure the entire folio is private ? Not just the 
page at the index ?
	if (kvm_gmem_range_is_private(, index, folio_nr_pages(folio)) ?

Suzuki

> +		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>   
>   	folio_unlock(folio);
>   
> @@ -924,7 +927,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   		folio_put(folio);
>   
>   out:
> -	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
> +	filemap_invalidate_unlock_shared(inode->i_mapping);
>   	return r;
>   }
>   EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
> 


