Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 288E3FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 11:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C652C6B0005; Mon,  4 May 2026 07:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C15F86B008A; Mon,  4 May 2026 07:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD2D6B008C; Mon,  4 May 2026 07:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 98C606B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:47:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA607120129
	for <linux-mm@kvack.org>; Mon,  4 May 2026 11:47:55 +0000 (UTC)
X-FDA: 84729563310.18.8F31D18
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010054.outbound.protection.outlook.com [52.101.69.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id D47681C000D
	for <linux-mm@kvack.org>; Mon,  4 May 2026 11:47:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=OaFSZt7S;
	dkim=pass header.d=arm.com header.s=selector1 header.b=OaFSZt7S;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.69.54 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777895272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAoxW9nBKu+S+1FoI3NQv7WyEFA8lcHiZj2YXVnDq1I=;
	b=77s8yCTv/QkiZbTG0SIIsNNAdf4ibm7HNTU9pkesLMEe2kyfdlCYIU3QuYDlcN4Qr0pv26
	k7Hk94kmJK89tBV2ymiRaAMmGVc4VAwio3fauq9GihOYMLczZEK30JoqShV/RS/3l5NVzo
	yZOy5bMFjv9IAV5JT34T5UsLqm4JJG8=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777895272; a=rsa-sha256;
	cv=pass;
	b=4tLV3fTtSGXqAiEgURUbYHjaGuMdUwqYSlA9xOwmzg1611e9uWcCxONOREBTYUXNokuglt
	lB2U6j/ZYfUpX8oqpaJWNCJhJkFVfyofeVBzwmHS7DRJNcrhNN6wdOtLnR6bhIsPvWRLQh
	XwlIeR9KeSNHPaME6LGD+RKwGjEgskY=
ARC-Authentication-Results: i=3;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=OaFSZt7S;
	dkim=pass header.d=arm.com header.s=selector1 header.b=OaFSZt7S;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.69.54 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Y/9rBohg9Rg2RfEz43FacEHTcMiertuc+TPphOatqLiTIWvNsc2ovEP47v3nV6tr8XXa/im1smN9pfYxF+o6YM6ikc/S1peVaY0333a9gcseRMZHoMq7IX0VurK01LL2JZIN1R5Bj/f43cpcr1K4I8p+oNblQKGQMbUa2cD7CBjzCkBt3mhxzGwMT3KgOWe5OB28/WQH8JYwvAyYUrpyuIxhaikrpn5EOGo7HPYgxEFaTa7EY5s2jFW709TS0h+1GOu5N/1CYO7zBSj6FAgK/bSgCoZtBkDPioK0lJFDnx7yjkBtP3+IH5agC9EQQDeVlDVte2uMK6tjH4uCvYb/0w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAoxW9nBKu+S+1FoI3NQv7WyEFA8lcHiZj2YXVnDq1I=;
 b=CJIq86txvMZmIaVAUHYDIcolvT6yoCGur2HqN1SqMHs5wlMUgIvubQoxrtIoyWvu4QVC0Hba92goDh2Qs7MXw0O0dSY7SHV1cbdQ9ICAfyJJNbyj5Y9BGfw8sQTpUuMyQ2+WqicC6QaFV+MHNTAShu/uNDUP4fqACUdT9cmHByZDtt8sVsA/pOTRf7kFvC/kAwmMwmxGuDRqryaV6pOneu88Xpl9tJa/kx/KJT4O4PpAQzCC+HZ8vL20gG2mof44sRbyk+cN5gYxvUTCWOZ+9rckuc1PbuS33+OEjRmd/RIZyChMKtmfqkzsNcFGGvsc68t1AghZgzn+LyJYuIN0Pg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAoxW9nBKu+S+1FoI3NQv7WyEFA8lcHiZj2YXVnDq1I=;
 b=OaFSZt7SOfQI9FptREaNWn2XqJucL8Hrkdlodw5eQe8w0AVuGOx3qzJ1Rc3EfHvksG8gGuX6gLtonUfop+D0J5TVJ1Fi2eVECUIAmlhAoNBCszJIgiIZb011qYpfYO2zX3mzKEwLQGOCRXF8GDDuRjuuoloPAtVXqujIo4oLztw=
Received: from DU7P194CA0005.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::32)
 by AS2PR08MB9596.eurprd08.prod.outlook.com (2603:10a6:20b:608::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 4 May
 2026 11:47:44 +0000
Received: from DB1PEPF000509F2.eurprd02.prod.outlook.com
 (2603:10a6:10:553:cafe::ce) by DU7P194CA0005.outlook.office365.com
 (2603:10a6:10:553::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Mon,
 4 May 2026 11:47:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F2.mail.protection.outlook.com (10.167.242.148) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Mon, 4 May 2026 11:47:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QKEwn55kqQAhBCB/RWElx953qst5a6yBvA2nozF7xYnWdPnBRT7jZRU7HCzRuBjW9RLbugbpKNh3xV/msjcIB0Qv4yhqTurv42G323uec+gBsvOPuGzWNoKriXft5SGYmsTY0D9Cb6MeXFnoSSKxXmnLE6cORa2VOPtHK6ty7PSMAudKfl9IsWEz8Fx83mhvKdVTV7wLnLRpJGDRMzpU8TUbJqlaJ3qtjfMGfLb5cFuTZU+gsr2YXrn/xCgN5Blbge3U/M7+OEzC2DooxOMB8OCmazLL/Juns9oba7v0E4RRgfSy8By4NRwi8CPbZWMaq1EovaiNNjY2o5NeCgNnJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAoxW9nBKu+S+1FoI3NQv7WyEFA8lcHiZj2YXVnDq1I=;
 b=VIsOF+UolUlBCp5OChrc0nDDlPUco6zOGQVeQLXyaVX12nAbU/j3yGyos6/+ss3WJVTx9VS8SmNhpRL7vadW7fK+jzjbIboQpY4tvLO13Wd2o/aoxLFLGyIQLA55LWT+2DjtSfxQJNkLvAbV1gLKiOxUlaBKNc97Y8+lFI70lojOTtmT02xBm9gCo3Hj3GBrwb6v7z4uiAksGRzSDGHqEBRVHwBW7WFj217CHewnIbFAk5OHTgCwbx1QvYaA2hfT9pwZ4DtaIY27it36FL9AnnO2OHUt+kIb4Suk0spdQjQ3cSrCNwvF33GRqJxWLIA+3WT/ue8/i8Z3GWk7WCrwFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAoxW9nBKu+S+1FoI3NQv7WyEFA8lcHiZj2YXVnDq1I=;
 b=OaFSZt7SOfQI9FptREaNWn2XqJucL8Hrkdlodw5eQe8w0AVuGOx3qzJ1Rc3EfHvksG8gGuX6gLtonUfop+D0J5TVJ1Fi2eVECUIAmlhAoNBCszJIgiIZb011qYpfYO2zX3mzKEwLQGOCRXF8GDDuRjuuoloPAtVXqujIo4oLztw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PAXPR08MB6494.eurprd08.prod.outlook.com (2603:10a6:102:154::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 11:46:38 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 11:46:38 +0000
Message-ID: <85e85faa-ad56-499d-b97f-bd336ee412cc@arm.com>
Date: Mon, 4 May 2026 17:16:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 34/54] selftests/mm: hmm-tests: add setup of HugeTLB
 pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Luiz Capitulino <luizcap@redhat.com>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-35-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-35-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR01CA0106.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::24) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PAXPR08MB6494:EE_|DB1PEPF000509F2:EE_|AS2PR08MB9596:EE_
X-MS-Office365-Filtering-Correlation-Id: ca004423-f851-486c-e3b0-08dea9d2f3ab
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 NV33F7xqBDn2nCz4pn5iJMRolpFFchu24tOH9paQZFFqPxla7H+dLoZeT7RQ7k/nEf0ZhsKXtJsximC0kPflqjyswbky9fnihtn6CVSAGenUMh4TywT78q0wANLSV0hFxvkzUAA4e7AAjEx8zLGqKyCyYFrjnhegf1O+QV/r/WTx/YTOTMxd31GTFht6kdfIjPMCUxrSdGy3+txG+xBChLG5vXLi4pHvNZe8kW0eL/V/OKq1l/GHmON80NID1BqSFPfcCP+M2Kl/k4YA4TseiEsvgPiseBwF9+GeY16Ob/y3WUnKaGZZ3uz00lhYg5atpYHDt8zPGw0j8CoDbT510jNIGG7Gsxde95jLgr4+9vVibX9NSucgCdLYqTv/UdJa1DaWp2gvHyFmKKl/puXZ650H9OmdjRUnhGDjZYJvLobnYwAFTd5XuaWb/av/Ouq2ODltVrGu/ZdmtS5dGHaLlUr0zM4bM3ZlZ4TWPJaGbZTk91k0I88lGfgCcT+mIbx6oB8D7zlp1VYJhJ+updvzT5FrmxnscS1Vpv2L8panOyZ/EMvTD5WtYAW56Tb+xvpOH1P2XOstzKQ92dx8yEu+WlYZisDCdLI/HyPQEzkk+GKWT1b0M4L2c/KQCzwnNk0o9XIY+UV+Eul0vkrpaM9atGY2pCu71O2YqsuuiWhYrgcYMatlhoScnCjENL8RIlKm
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 McTq2dyFVsxyJdM3yDu+F5fFa4r/YqbWPxoCzrc1pHKzOhNXWqphSjSrRRhm9tOykVHB10qJEbl0QYMIM17PGQrQC7uynnEb55VBOQAXIJH144gV92oAuf2RvY7sJ1frygWhZKds3ZmHZ36vHMHOXyoRoEmvtGe5bOlZ7xKIr8aLB2GQslmzg20geXnYJmGSjA4TJpAZWt8notkK4x0oKSnkz0XfUxvterlSmIx5Wr9VSRfJb/5bbKAgGOfaE0ij+VakmdeKJIvVrCcBdjC6wue42XMGZS8RGZs3lx/9NOr5Ff+W4hilGbs4KCcPMcmve1T5ZZE6TpzVTc3iznuO8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6494
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F2.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	06809161-266a-4d61-61ce-08dea9d2cccf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|14060799003|35042699022|7416014|36860700016|82310400026|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gwCXL2GFLRoLU245Mn3UZy00MKPUTi118bPbk8Hc1s5B59ydAJv0H6sRyXWllWlQNRVE04p71zCyMCFaIkqiFXEE457PNknofSbk0DlRDMD+PWW8w5pJ47DGMADaRE9DgKi2h/dLgH91LoZ34z2A/HhTtedTXBYlldFsqyVGCbaUPcqIASNcNX3DPSmt1pERYnFEHV/na8S7pbvB4qtBecWpmy2zwsAH0XgipP+ZHVX+NVAcw9qcEUtt4zej/Rh0L8mDbuA/NqbObDQS9FY4okihSmlBkfrROAI1Wb8mdwjDFaXvmE1PclsjRJG7ZOJPKL4aIRAnrfh9fvH37JfXf88+lq5EDanP3T1WXUpCLjTfP4NmyDNGqwnAH7oo5ZE9nLywA3yYRvMziXRD2bfwA+JY36KDx2LL6VaQVJLKUvXtNIx1Og77Xz6sa5ruA0GIlDTO1yBScz5Vl+c07WQtoYS5IUNBLY0BBBn1RoabgZSN+Pbp7Yt7Y/CL8T8kQ8X7Q4Ymvme+a5M8PpDMn2LpS4tDKpu6ddWEHrMPmiTTiRpf1cvYFtpU8kMU4C0IX/ydBwZB7k/nezdnfeCNhDew7ZyOi1mqHOIqGmW5jsN36dNMhSzkYKt2M8KmErvPepN4KWb0HhP+sxttT99RccRiaEp07+o8VpfA/jYpqkYpFTO0Zq8r/I2xjumvvk7hJrapy58u0vj/Mg6UFHcBCdxo1+FOWwLRfEZFIgEcAeBhskY=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(14060799003)(35042699022)(7416014)(36860700016)(82310400026)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+CcMm3iCn2b54LTeu0SZLZESBTIENyHLzToCHcd12KjwJSZFx3jKaD8gYj5t1Uk+ceoDPDnQVxUI2j14FqDvx4i7MUazXhDF4sadMtWIat+mxETGxGzLWeIJ7IlpHoedJpImuRQVwSTLgYJiNm+JHvbU62r5eu8/jCi+BSP8DsGzZb4h+T12Osin99jii81Y4/GkYWemG8btP/eGGc28IGvkmAOUWLUO9fxowu8qa8bOHf0PB7XnoWwbwb92y4pV6JDnyT2+yplZiawHtk5GQZn0KC9W9NKi++HYCE09ZUUU7zbMORjCItG73lcQFH1Kiltcyj2oARE3dVGi2uJtzQQIEzf2o4qnIuESwHHGOFotRLHjzOxIe8cVybgF2StIZRGaTkyHLdzulw9ZRdkgIGheG8lRW3y7+f3pme2NhZVer1QTz9i7eeLRnJBu/3u7
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 11:47:42.8482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca004423-f851-486c-e3b0-08dea9d2f3ab
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F2.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9596
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D47681C000D
X-Stat-Signature: kzkrxg3ki6t3axjcspxs8xze7cjo4guh
X-Rspam-User: 
X-HE-Tag: 1777895271-711103
X-HE-Meta: U2FsdGVkX187xPzh7J0Umx9IKytJ4BbSbDiyjQA8ysKTrNXk9Bazpeyx2EmmbQkfSvUVdR0u+kSFnLdr0gelyVt8GaJQUYMhQwpQL1a2LRoxU01RvfJmqF58HfLR7N+TjwACQDujEnuX+yXdGAS3LMiR66aWcvQPwLgSMvCJ2y/R21NWYcxxwPsfu29BWTDJ4zv/JHeilc3dbSMRlaFavdJKkqq6n2+3LC5K3JuZMfrz2qL/5FbcqxH8tDiwbNiTQ8+uPbh81SnVF42jrWfHoU1zhRZwLJVDjwbE5YnOFoHiEPEmB4RGfGLUKbp9A4SnZD2ffHd9pfc67zbTPo63fjUMTDJUrrd4WgHd8Iq0aAMJHPiVSlVd0uWBBGDiRuznSlR9JQiNHlwQ0UDU17suJUf+AcpPPjBU0l1lXiLF0XMPeMNUbDIulM+VMwUqltsXy+fb9TzbDuONo+QArf7vvv6DG+xVXFYxxrkahbye5DQDSdmYQuJ/hdWvnP/UrG0wdz7bMo76oPnGvfdo7soYpNOc+FhPXjGvcC/i1q6umaNhXwtZCb/vStZau57FfQzzQFdm/c/Rn9aTfFu3Yo5faeZund/0UraqjrXEhJLelhaf3dvaXTq8P6iSq8DLtkaV4vviU41MccdwJTYrPqfWuJ4MhAm48R7J1CAPiC2fk8VK+uBqiBhuMpA+tzcA4VWl2YQJjdtXndFggbmJOfGbqzvEP1HFr6yj9e+grREWHW4e1Czm/z15K/nxp1+LqC6JU4yks70OiAioLkMsZaFBXTupHyfvhs91sNuE1omBG8S5Shzn46aOxxe06g3wan/SFrP5E/tBbS1Oul7YMP9zxYwqtImbsg3kAfz5jnEAji8MYswh/UInhbeuv2Zix9ievpFV9CkcZ2iFPaUSJlLgKi1m3MGp7lNumC14VdGnyfNClB+3Lqp4G996NeXEWR9rY/FU1YFq65qIfebFY3f
 8FkZexom
 8o5AIVSy+g88CXv2YELxjRO5kKJieRbouj35M9X0SKRUapAJ1sIRtMuk4a5KaLhhZzJ9JLZRdB7kK1LcbBEdUoLH00klVbijagZdRke+t8jbpdGsIY3+F1amRQTUUBqSliyGiE2matSQ763MaEEUy28xLg1ai5mpiMs7qi+YrD9+OquaFyEY5u8eyfFJ8ND7xwa2C0LVUU55DnvZtpE64WQpCbAdkNt2Rg2py2abi52oRZr4gwjL8H/5cxZ4cIRct8Qoi9ScKgmvXIc0qUkxNoARmrSljlgAjBpthbfLAVbeMcbacUzELGuTpuhJICKcrGX7UctcDo3HwWqIwsx0i1mL4IrV+HfWYJ53fLkTLazbMPahVT9IlR3ijRmJUOSEppsC/+xCuTE+jOYiR3wNcwMccpyds93vzpBpQjrEh934sLHgzsT08T6Ry2sSUB5v40mBv4Yn+3rKnN6VDOd2UlzyjFv55z2vayg4dghK2q4fzt572OWnfSz1kTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hmm-tests skips HugeTLB tests if there are no free huge pages prepared by a
> wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Since kselftest_harness runs fixture setup and the tests in child
> processes, use HUGETLB_SETUP_DEFAULT_PAGES() that defines a constructor
> that runs in the main process and add verification that there are enough
> free huge pages to the tests that use them.
> 
> Replace exit() calls with _exit() to avoid restoring HugeTLB settings in
> the middle of test and use SIGLILL to kill a child process in
> hmm_cow_in_device test to avoid interference with signal handlers in
> hugepage_restore_settings().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  tools/testing/selftests/mm/hmm-tests.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index 409b11cad4bc..70c7ae989c01 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -69,6 +69,9 @@ enum {
>  #ifndef FOLL_LONGTERM
>  #define FOLL_LONGTERM   0x100 /* mapping lifetime is indefinite */
>  #endif
> +
> +HUGETLB_SETUP_DEFAULT_PAGES(1)
> +
>  FIXTURE(hmm)
>  {
>  	int		fd;
> @@ -632,7 +635,7 @@ TEST_F(hmm, anon_write_child)
>  			}
>  
>  			close(child_fd);
> -			exit(0);
> +			_exit(0);
>  		}
>  	}
>  }
> @@ -712,7 +715,7 @@ TEST_F(hmm, anon_write_child_shared)
>  		ASSERT_EQ(ptr[i], -i);
>  
>  	close(child_fd);
> -	exit(0);
> +	_exit(0);
>  }
>  
>  /*
> @@ -784,8 +787,9 @@ TEST_F(hmm, anon_write_hugetlbfs)
>  	int *ptr;
>  	int ret;
>  
> -	if (!default_hsize)
> -		SKIP(return, "Huge page size could not be determined");
> +	if (!hugetlb_free_default_pages())
> +		SKIP(return, "Not enough huge pages");
> +	default_hsize = default_huge_page_size();

default_hsize has already been initialized at declaration above, so this
reassignment seems redundant. Shall we drop this?

>  
>  	size = ALIGN(TWOMEG, default_hsize);
>  	npages = size >> self->page_shift;
> @@ -1564,9 +1568,9 @@ TEST_F(hmm, compound)
>  	unsigned long i;
>  
>  	/* Skip test if we can't allocate a hugetlbfs page. */
> -
> -	if (!default_hsize)
> -		SKIP(return, "Huge page size could not be determined");
> +	if (!hugetlb_free_default_pages())
> +		SKIP(return, "Not enough huge pages");
> +	default_hsize = default_huge_page_size();

Same thing here as well.

>  
>  	size = ALIGN(TWOMEG, default_hsize);
>  	npages = size >> self->page_shift;
> @@ -2025,10 +2029,10 @@ TEST_F(hmm, hmm_cow_in_device)
>  		ptr[i] = i;
>  
>  	/* Terminate child and wait */
> -	EXPECT_EQ(0, kill(pid, SIGTERM));
> +	EXPECT_EQ(0, kill(pid, SIGKILL));
>  	EXPECT_EQ(pid, waitpid(pid, &status, 0));
>  	EXPECT_NE(0, WIFSIGNALED(status));
> -	EXPECT_EQ(SIGTERM, WTERMSIG(status));
> +	EXPECT_EQ(SIGKILL, WTERMSIG(status));
>  
>  	/* Take snapshot to CPU pagetables */
>  	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT, buffer, npages);


