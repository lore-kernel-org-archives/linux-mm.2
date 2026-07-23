Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4CFBC531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 11:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBA876B00A2; Thu, 23 Jul 2026 07:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D92DF6B00A3; Thu, 23 Jul 2026 07:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5BC66B00A4; Thu, 23 Jul 2026 07:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93E456B00A2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:37:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DE9E80473
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:37:48 +0000 (UTC)
X-FDA: 85019841816.17.2226631
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013004.outbound.protection.outlook.com [40.107.162.4])
	by imf18.hostedemail.com (Postfix) with ESMTP id C92D31C000B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:37:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fe+vypdB;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fe+vypdB;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf18.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.4 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784806664;
	b=l56sMpYwfUNj77L/U9KYA6n3hMh7hFZsl/LMZ+wCs91QeTotyYhB2oC2zuXXTzKjZZbzYx
	KWlGT/HXe6WPf7IyndlGT6eadT9K1b29uVkexrqgF+Qr/As0BBCwyWuQ8uLG5WZ5oIIw9r
	VxJWMuxOlfCbQTjmBpW5C3tyrzJuTAY=
ARC-Authentication-Results: i=3;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fe+vypdB;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fe+vypdB;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf18.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.4 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784806664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxnSCuPymICaV0HcnMpdwqgmgvfujqrp17ZYdcuKN1Y=;
	b=Dbe+NQfkm9o5id+BY4IfI/UlGsOVqhnox2mDP3qXXKQFFszJSouryxIgPBejXn9rWOmWEU
	CO1h6GlPdrLdq16n3NO28cuSIAywFQjN/57urrzQt1g6sxefMwSO1pR8yk9uE/Rv+y5/xU
	KMA09FyCrAiPDXJvbCc96MuhkFwCsu0=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HxeMmJ20zKWy5sbG8OFRsXOL6WvlYxv0wlTZG4LCYXa58dd2kBvD8joHNHpKYXy1oM472bXCmGbAA9YX7l4Ef40fv6gCRkB6nCmxf5JGqb8A61Z2BwqPsWoM0EVACz+5cN7QVEgtqZqjWKpGK9rpYoSW30sf0CBEDiM33+bE8KC67sSMHw13nuZOb4OSU2LcMFVtZ0Cf/Kgccj7dDqVDTdu7rxMmtfsgPOZSFDcLDCHr3aKiOZ2SWEelZtDdW01jmbxJjwFw7iGgDhfjaVbbUzXC30r7r+JXQ4bnQ/tXH6c/26qs1G4Gps26OctcybZUG9pDbHDzNmg2rIlkJ4wTTQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxnSCuPymICaV0HcnMpdwqgmgvfujqrp17ZYdcuKN1Y=;
 b=udYxnQ2GhgCxeidYvyjTtfvbuQvXKyYiHYZORM90lyDHb9URVa9uVWzoZCYSVOt2q6ZWHG6Ok1n3ZNWLrf42uNICqIf6Or3tPiiYoDMOkVnsopwJVgeCF1xLoUgNWNVyi6E7Igt11XYqwWKWnUr4nsLeGfMxnKv40w+74BE1r1Ep80bxc8XFz21HQ+mZN0K91MtVj+vAMRxVNhEMUqnAC65p9zmYg/15MPEL5ZoTQX9V4TAY9Y0aFfBREYh5CTMd9JQTSqru68XxFb+A8Libj0iMsLn9wWp81Y9m7WYwqCa82Zg8SeJFmPSnOIFLPzqPn9U24qRyLIAMjLjYsphZMQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxnSCuPymICaV0HcnMpdwqgmgvfujqrp17ZYdcuKN1Y=;
 b=fe+vypdBGwt73pSa/KLrPQWUPqv9nayQ+AofQslJpfLUuZ9PJFKhyikpyr/aQmeynl1xOUG1/a1aANosIWqIAwFxq32Px3TGTjOlLTeuVCiFL0mYmylnyPTOxA0DPXVGZbnIV0KqY+Zu4Om95aR7QiG4BkQnUjhDljWE12Qu6Ug=
Received: from AM9P193CA0002.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::7)
 by PAVPR08MB9770.eurprd08.prod.outlook.com (2603:10a6:102:31e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 11:37:36 +0000
Received: from AM4PEPF00027A65.eurprd04.prod.outlook.com
 (2603:10a6:20b:21e:cafe::d) by AM9P193CA0002.outlook.office365.com
 (2603:10a6:20b:21e::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 11:37:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A65.mail.protection.outlook.com (10.167.16.86) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Thu, 23 Jul 2026 11:37:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vsPGJlRQPyJJ77CnzablLLhVTr2NP4O42UPNrxWxejh8cxK1lUc/mef6gILP1qHgBJbjAO+0Wu74c9bIrsr08yBPzQfAqdtni+SWJEa8aBu29z7XxX0VbLp0rFvJoDJqdak2Psr1zt+maRTw126Luz+sFs6di7DKbgf9HABpEUmL/J2TJT2zY+FA2LIlBiiIcLWOf3n1/SQiyKGoanxPakx+SH/kSEb8OYgpw2NAeSJ/7xegQbT/q7NHUesx9ONmcD/1Q2eucBS3rsBjjfVCb2ir0sCTm7ZB2q+xTTXA3xWTbU7j+U5X3lt3qts4QI9X0iO5NN1wwGMcKiSHFpoROg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxnSCuPymICaV0HcnMpdwqgmgvfujqrp17ZYdcuKN1Y=;
 b=yNZ254A28se8vTMHbNaNCeou69K6vrWk5e0PBI3GWxInqOKO78p5AC5LyeZrZd0Igt+L19/qBcdDw6IBqjKnES7L7WxSk4XKTqks1Uaxp1nPwkHyd4Vf8spzyXNdIO9k89XE7imnBOQ+ZsXZRvB5WaynGTLKuKb4hf7hmR8aAD4bIH2CxKLbWFS8D+Q1vQ5fo4Yi81PuiTmpVdD0S1LtewcrkokVOI2+cY6M9DHdUdsuxhYhYLGQC/v8ONAiV8m1mZ5ZHL0orzBVxHubErjFwZH163sVCo+1AABeJlJ8iSqfqxUisT/ZpVAIYN1s7N7fs7DNk3T6qGSKV+R7NJg7hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxnSCuPymICaV0HcnMpdwqgmgvfujqrp17ZYdcuKN1Y=;
 b=fe+vypdBGwt73pSa/KLrPQWUPqv9nayQ+AofQslJpfLUuZ9PJFKhyikpyr/aQmeynl1xOUG1/a1aANosIWqIAwFxq32Px3TGTjOlLTeuVCiFL0mYmylnyPTOxA0DPXVGZbnIV0KqY+Zu4Om95aR7QiG4BkQnUjhDljWE12Qu6Ug=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AM8PR08MB6580.eurprd08.prod.outlook.com (2603:10a6:20b:369::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 11:36:31 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 11:36:30 +0000
Message-ID: <57f8415d-b80b-46fa-af1f-ad4a727e1582@arm.com>
Date: Thu, 23 Jul 2026 12:36:28 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com
Subject: Re: [PATCH RESEND v1 3/5] selftests/mm: skip khugepaged swap tests
 without swap
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260722091219.61504-1-usama.anjum@arm.com>
 <20260722091219.61504-4-usama.anjum@arm.com>
 <9bb01e21-159a-427c-9d64-5db7070f0209@arm.com>
 <5af250ab-6a52-48d3-bd50-64e8ddd99915@arm.com>
 <188a0acc-dd03-443c-8e1f-329a4dddcd5f@arm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <188a0acc-dd03-443c-8e1f-329a4dddcd5f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0045.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::20) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AM8PR08MB6580:EE_|AM4PEPF00027A65:EE_|PAVPR08MB9770:EE_
X-MS-Office365-Filtering-Correlation-Id: bac64787-3a84-416d-1b25-08dee8aeca87
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|921020|6133799003|5023799004|11063799006|4143699003|56012099006|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 H1xtRovmbyE+8RO0FPX0nciGbhedJl41GTUU+q2SrEU/O7bI6b8FiCZ8Sm+OvugQhlxCjDaQLDl5gUDwupoZ8Cke7fFf45Jx0gThHK8Bdo2tSJXcAeXMBFbMqS63wMxVNe0p4FlcWRageCwTxxwXVZb99z7LHvGZZTFZEQh3cbZrH3WUEYsZYSFOHzUdVkJLxN923B+EBRpMBSRUOxoH3ArKXBEyC2xVCu7hvQUCNu4FwYXoCdcibPVIWXgyKmDqxYIruSohsvYnahW10fPiu2mvxJ/0vxK09Qxn9cCpVF8pKY896cCwgnjA92kyqnteT6lw31JrbZKH090LDiJf6TlPDXJH07M+JMpLesUEBQBFr1zLFnv85YzVuL82ZZWZo6JK0NPsuPNMcT5bcBbM0vpoiDYBVAkdmjKEP0Uhohdnh3lAgvP5kIqaymfsXvqMOJt92RTvRo6EgFNvTPCJmA2+3q0ZcF1MtVdXwxgTXWNEIPD47qXDV3oVlKu5QGGX7U8PLm8IJQf9rGmxLiuNYsb5o4Wu5MZgqEMDV04TdpCq8K4J/j6fFCved8rPfo/35gQOzS+WlYKNgqN+1/i/+gKvnsGLImb70v02flB4x2JDs85YzIcpOS6jiGfVqMbdHhA9grSrWokKR2Vc4SJI5+fI8RlTS7wyEj67dgOwpclW7zrVcEGZgn5AfVu39R4mfXkcnodN0laeC9idmoIseQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(921020)(6133799003)(5023799004)(11063799006)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 ivz5qaVbV8BenLOGv6IqF1Ub5hRYkmwJwWHR2G6z1byJbu3zAca5NRywWQCI4JD7UmQPmuWiBcgLWKpGFU1JF5SuGKoeSjBIBxsNGxE4Ux1RkvGF1h9zl+1z1ovt+fUmVxygJ4Lkjru/f3fAYVCndK68Jm4wwDHOhwdDDKHhpmxxpP9G57ixuJjvkd+1V4nVVE/LBy/oNg6mdRttGTxwEN1Ee6kBw0vpeRSyZQA/LVpBCBErgJrYmgsKFUiTpGhONuVSI9LbXQhW0tiHpS5dK09sGibld35S4ldmZeIruI3zf69r2fDA2U5OIbJ1P81qxem8ZRUXYU+gJEiTvDPuNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6580
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A65.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	799e756e-16f0-41ed-6fec-08dee8aea38b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|7416014|376014|82310400026|1800799024|14060799003|35042699022|921020|6133799003|56012099006|11063799006|5023799004|4143699003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	B6FGUJlPr1ENIE/jDo2fyEn+uKSJBnNJUXEgk2n4ubruv0sAz9IpHxZkAx2Q4tJiPoSLB+n2fhN6xcjz2+I325yvfHhgM/bG87cENKV6CjZzKqN2jvBevVha/hLh02BcVU8SgO0F2EPqmiwE5GpbvHUjMxr53sZ4XECB5Vf8iRuXnWSChs8IxdntqSc/U3xcdQMORjmUVo2jA5A1xf79cuTAmfbO1aRvioLVP0DGKYDF06x9w2Rqmpf1mgOJwgAWvvr9iNzXlUhwk8xw9kL4ayZJtk+gFkp145mGJmJHJUcp0+hiYamLszo1fAVdNis+mSHtWX3YFqF8WDvJd+qRkKlkUYhaHdwM+w5+LrcYsvcbR9cXGF54ld/P6STBCNzseqT7pHzu7wsRZGqYDy3dcCF/MeZhvhQEM0p4eVWsbVoV0n6S0gfpSVB6rPu0F9fyUtI8X733pewxhNf4u0/+U7aGFhiN+a+1NmPkiYPEZG358uVDWTFinyu5TQ0NtPm6ecQTWuCHx6KqpkIg4MF6wfS+xc/FKIjfzkLbScztVPMh3KBBmN5Yc/MLWXbMGowj+hIaKa0FA2fUhh+1R5RsnYX+HMNs/9f69/JUvsdpo/Fq4puw7f9OZ4slyFv0kpQ1ps5IRywiI0SRQZeDBykR1Z+rQnk4gEN7Om4jGbyC1AxQaXTdGOTyiZIh6/MIv0PnyEX50FY5mQsBdUGBZJ26t9OnXKIf1bGKEsmjODu0dR3y0Aaggjvx15RIvXr3WxSX
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(7416014)(376014)(82310400026)(1800799024)(14060799003)(35042699022)(921020)(6133799003)(56012099006)(11063799006)(5023799004)(4143699003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aUZRSEH9J5CVywGHvNjJw6nmnxE9o4GqgakjRULbnuKQIpetaRNWPQdPYCSx/58eGt8iJsSYkExDE0q+UxemlsYpXxztsXN+WZRfEiXhnBDBnz+ANOJJYQBMIBp5bOLi9vpClr3z9TcQznRAcOiAfgiMOpmBCjbh2Y+g96RR2SaY7pQp2FWP1foCiM/XLms/QYVuSdUFLIZWRKsvIryiiJevPud4db1tKRi0Sri7AkvuxPfavFGBcev6b8+7s+9Uo9/nqmrnaDkuy+ExoNn3zAPj2bj34VwnvnMBxFww3kS8trk9gExxdvGqm9dYdNNUzepHp7AsLVW3UD+z6kdqTTM6PnaQYSeEUJ4+CeZwqtGPMA40+IcZt3FW1hX8jNARJ6fz+GSSni1twj97+kIBuwufpJPuU1MucSPcUPpcxomQe2/lPb+pmY3vkmIMeFLT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 11:37:35.2024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bac64787-3a84-416d-1b25-08dee8aeca87
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A65.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9770
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C92D31C000B
X-Stat-Signature: kn4tn4g9gs6xwe78d3s5qwe5aab4any8
X-Rspam-User: 
X-HE-Tag: 1784806663-745997
X-HE-Meta: U2FsdGVkX18+5BMBvzxhCPQh/hT4LHdbtPdBP/OhcgmleEE8hWoW0ReOnBBiTFAy0SKAVExSn9uK42/KKr6eiOrvQQAqPQVI4aF+Z6nwZVEe4+78/bjKdOsVk9Xj9CBEMKWBrqrDu3Tth4upq2PSXCSFW99XozAXx8QTqn+iix7Yw2QD+i59YlXxZGAC8L7pdA5QzjcrTspMydsNfJN0fxGw2z77sO9oRPPNeEG2jSOsR/3bm1MBYriipqTXUS/rfHnQwdr5bBOGaaBaU5ABBksITkdZtlQiGWNiUXS+GUh7BaVGp6BvkIQf3srGWst8qmSfoLdTJ1oLQaEW9ko7coQs8lVYjaZaS5aoXzVHf0HZ27v49msscdITTDuWcZVsnpPscg673X4TtCGkXE1cpS8KzaCtoNrUmZ5NMax5X5HK57CfayVwwgrII1kplt8sUacdBzTgRIidvlyCAynwmoTj/yEbZ43P2WqJJ7XIg8TVgq7zEERe54okNc0b98KmCaG12VIPUMpAvFYllaLMgsT/Yemc2gBtq6dHB+stEIFtRnp8hcwmTD9Scn638uduwuDRYg6Es+fwAPHyK3sMeUf81OM27xF887ey41PcoiABDQaxO7+aKOFFCaqZLscFNL5e/rqsk6puUqHXVz5O2lOV+un9GbeYMqbfBNC4rn78QRdTFmIPfHjzJvCZingDqxOFX8dPRNd05fl8tz1ndx+tIDkjP/xXs69vSGvu9p38/6ysHKQ77TL1d3NEiBVOB/0U7mQ899pbJh57BI7oVoGmJSBmt2Ih1R6suPIWkwMqQnAskIIn+/P6vk2JBqBDMAHuA3wgZ4Ff0dPwYe8ecU2aYNZC9uYijoW3mcMtgvrfijHh2Ta8/0NsUR6Bcb2Q9qIm4weRRMDwqVCub19a9lQiHhrMiru4VLwf0KpiRZLlbSqYaKOlFgmCwdPPTi8eCRiYHYCGneXwMt9gfLy
 /uMv4BCp
 Zk46KbRbIeMwJxwX7W0SWJjU3obYp/0lWxCmAeYCkU70kLyp2ou1W2UdsQyDt/FrJMA8BXdo987RRXDCPVK78CivK7vF++MEVZlGUr0NgH5tQaZ0vTs+PYTjQ4/Btb6CfOk6UgFt2BYblIPsGE8Wpwspo+1jibsmdLmUhFiac4nSQQnAe0zPawoGOeW151VQgEZSAa69R8dSzpszCGpRCI7m781R2ANFBxz17z78YB0ePeAWzBDiu4a6fAg+yZZwIzixF8dmFPTLPtGunzuqLsyeDiL11YSIkyhdlaRwpfYCNmjJgQlOxIptt6IlmwaLlebwDLAg4wb8V8u8wDc2GidrUPcMlMskRKVvaeICeksC0H5ttQSCcNIXVZ9yioX7yQinxyXF8bx1NpDLKtCIKsMzpRz5WUZHLbzksLHWC9Mo3mBdN1+gKTICYzsk6Cmjn9KS53uDJIi/iCMFEd2lKs/ESYY1KV/R+yD/iOP5reMNIeWFRQveoO5vqJA0sSqK10xmvUZ2LAuy2Lzg70FHho8QVy5I7RFpuA6bcXfzeTrJCY3ECP6UNnQS2KoW53fEjUFHA+R17IZLr2S3PE0o+AXwrH+iBkFVVREmUAERhM5W5IA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/07/2026 6:08 am, Sarthak Sharma wrote:
> 
> 
> On 7/22/26 7:35 PM, Muhammad Usama Anjum wrote:
>> Hi,
>>
>> Thank you for review.
>>
>> On 22/07/2026 1:16 pm, Sarthak Sharma wrote:
>>> Hi Usama!
>>>
>>> On 7/22/26 2:41 PM, Muhammad Usama Anjum wrote:
>>>> collapse_swapin_single_pte and collapse_max_ptes_swap require
>>>> MADV_PAGEOUT to replace anonymous pages with swap entries.  On swapless
>>>> systems there is no backing store with which to create those entries, so
>>>> check_swap() reports missing setup rather than broken khugepaged behavior.
>>>>
>>>> Swapless configurations are common on Android and other constrained
>>>> test devices.  Failing these cases obscures actionable results from the
>>>> rest of the khugepaged suite.
>>>>
>>>> Check /proc/swaps before either swap-dependent case and skip when no
>>>> active swap area exists.  With swap present, retain the existing
>>>> MADV_PAGEOUT and swap-entry assertions unchanged.
>>>>
>>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>>> ---
>>>>  tools/testing/selftests/mm/khugepaged.c | 34 +++++++++++++++++++++++++
>>>>  1 file changed, 34 insertions(+)
>>>>
>>>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
>>>> index 10e8dedcb087d..a152cec59fcbd 100644
>>>> --- a/tools/testing/selftests/mm/khugepaged.c
>>>> +++ b/tools/testing/selftests/mm/khugepaged.c
>>>> @@ -100,6 +100,28 @@ static void skip(const char *msg)
>>>>  	exit_status = KSFT_SKIP;
>>>>  }
>>>>  
>>>> +static bool is_swap_enabled(void)
>>>> +{
>>>> +	char buf[MAX_LINE_LENGTH];
>>>> +	FILE *file;
>>>> +	bool enabled = false;
>>>> +
>>>> +	file = fopen("/proc/swaps", "r");
>>>> +	if (!file)
>>>> +		return false;
>>>> +
>>>> +	if (!fgets(buf, sizeof(buf), file))
>>>> +		goto out;
>>>> +
>>>> +	/* Check for first active swap entry. */
>>>> +	if (fgets(buf, sizeof(buf), file))
>>>> +		enabled = true;
>>>> +
>>>> +out:
>>>> +	fclose(file);
>>>> +	return enabled;
>>>> +}
>>>> +
>>>>  static void save_settings(void)
>>>>  {
>>>>  	ksft_print_msg("Save THP and khugepaged settings...");
>>>> @@ -734,6 +756,12 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
>>>>  {
>>>>  	void *p;
>>>>  
>>>> +	if (!is_swap_enabled()) {
>>>> +		skip("No active swap");
>>>
>>> Can we prefix this skip message with a #, as recommended for KTAP
>>> output? Right now it is printing like this:
>> It looks like `skip()` is not being prefixed with `#` in this test
>> because of how it is currently used.
>>
>> The `skip()` helper itself should probably be fixed, but that can be
>> handled in a separate follow-up patch. This test is not fully
>> TAP-compliant at the moment: the normal pass/fail output appears to be
>> compliant, while the skip-related messages are not. Would it make sense
>> to address that separately from this series?
> 
> I think there's nothing wrong with the skip() helper. Normal pass/fail
> output appears to be TAP compliant because there's a ksft_print_msg(...)
> call before calling pass()/fail() helpers. If we move the
> ksft_print_msg() line before the is_swap_enabled() check, we'll get
> output which is TAP compliant, something like this:
Makes sense. I'll fix it in the next version.

> 
> # Run test: collapse_swapin_single_pte (khugepaged:anon)
> # Swapout one page... No active swap
> ok 16 # SKIP collapse_swapin_single_pte
> #
> # Run test: collapse_swapin_single_pte (madvise:anon)
> # Swapout one page... No active swap
> ok 17 # SKIP collapse_swapin_single_pte
> #
> # Run test: collapse_max_ptes_swap (khugepaged:anon)
> # Swapout 65 of 512 pages... No active swap
> ok 18 # SKIP collapse_max_ptes_swap
> #
> # Run test: collapse_max_ptes_swap (madvise:anon)
> # Swapout 65 of 512 pages... No active swap
> ok 19 # SKIP collapse_max_ptes_swap
> 
>>
>> Also when we run the whole mm suite using ./run_vmtests.sh, it appends an extra
>> # in start of the output which we get by running normal test directly. Its
>> controversial already that we are applying TAP styling to suite level and test
>> level as well. So non-compliant skip in this test makes overall output
>> compliant.>
>>>
>>> # Run test: collapse_swapin_single_pte (khugepaged:anon)
>>>  No active swap
>>> ok 16 # SKIP collapse_swapin_single_pte
>>> #
>>> # Run test: collapse_swapin_single_pte (madvise:anon)
>>>  No active swap
>>> ok 17 # SKIP collapse_swapin_single_pte
>>> #
>>> # Run test: collapse_max_ptes_swap (khugepaged:anon)
>>>  No active swap
>>> ok 18 # SKIP collapse_max_ptes_swap
>>> #
>>> # Run test: collapse_max_ptes_swap (madvise:anon)
>>>  No active swap
>>>
>>>
>>>> +		ksft_test_result_report(exit_status, "%s\n", __func__);
>>>> +		return;
>>>> +	}
>>>> +
>>>>  	p = ops->setup_area(1);
>>>>  	ops->fault(p, 0, hpage_pmd_size);
>>>>  
>>>> @@ -760,6 +788,12 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>>>>  	int max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap");
>>>>  	void *p;
>>>>  
>>>> +	if (!is_swap_enabled()) {
>>>> +		skip("No active swap");
>>>
>>> Same here.
>>>
>>>> +		ksft_test_result_report(exit_status, "%s\n", __func__);
>>>> +		return;
>>>> +	}
>>>> +
>>>>  	p = ops->setup_area(1);
>>>>  	ops->fault(p, 0, hpage_pmd_size);
>>>>  
>>>
>>
> 

-- 
Thanks,
Usama


