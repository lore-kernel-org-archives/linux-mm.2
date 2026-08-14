Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D095C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 10:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25776B0673; Fri, 14 Aug 2026 06:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6DD6B0675; Fri, 14 Aug 2026 06:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D580A6B0676; Fri, 14 Aug 2026 06:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6B616B0673
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:01:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 485F81A040F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:01:42 +0000 (UTC)
X-FDA: 85099433244.13.30E4C13
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013006.outbound.protection.outlook.com [40.107.159.6])
	by imf31.hostedemail.com (Postfix) with ESMTP id 36F582000B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:01:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=VcD0AvbB;
	dkim=pass header.d=arm.com header.s=selector1 header.b=VcD0AvbB;
	spf=pass (imf31.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.6 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786701698;
	b=sNKy4foVEPdWPVvdcJl4WIsjXR4b0jBI2l0ioCujkHggxA5HDYqffszSf2qzqlEHz3ZGw1
	kjFJgJksob17lmH5jWMPVC97mpQV/MjCTgPOm3XRTD5MF7LCplfnj53Kotfddi/aIdpAVm
	3Sq84cLL/HtIN+hascZY+yieBPcmySs=
ARC-Authentication-Results: i=3;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=VcD0AvbB;
	dkim=pass header.d=arm.com header.s=selector1 header.b=VcD0AvbB;
	spf=pass (imf31.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.6 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786701698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P342ho8n2BxRFWU9uQePKPO8YipOa44GuHloJ0IQzng=;
	b=Y0BRUcNUOEqTA7WvNyleV3ws2mTiJuaY/L0NeoYurGrZVNYssb+jKTKdGwtLjOKA1cs3qE
	m0tPIaBDep6O/g9VocvY1ZZ8eXWXbjveWon7q7M8mOumV335IRNbjVBEXh90vlSVR92Yb8
	bNKHiRPFu8mmAvDpGUGlG4HqegHDi8U=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=v/atSUU4Xpum7aLAYCn3nfVXyvWRGW2Kk9bDsP2kmq/sD1WWpdH2mH5hYbe0db82cppywfkclcfnrrpyti1X2KBKMKu2U7LaSIqt417rLl4uRyJ/59ZOe2JkAuPNFvNLyIt19fhSiJtGnpWhIbDvq+N25OC75yQWY6hYg0gEeSZuBU2M+ch6Mq9SVFDCQhRwNpJafVFFNZasmIHLSgCKb9zawVMzc4W+7U73KU2M5qjxTXBiF0pMp9GWdX0nQySlxcYPPkUOHnXHcIEjbFZGjF5CtyFgeyRJTEGk2tP7CoPhGFJzmZsveEr2z8PBYxPJop+Kw3sBKmkfMP7szEaWAg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P342ho8n2BxRFWU9uQePKPO8YipOa44GuHloJ0IQzng=;
 b=f7jET3/4flXAfn2yRN7BVO3s5FHcnOYdYnenxyyq7lRtaOFOGkOpQAptJDQ7icwnyZMzuYE+cXLIe0WRaziFdEqkBKgGGCYweJCHqa/M9qfKoYJtU2XoAoxNYBrCMCinrFC+hau0nD8DlrYaNZXqn1bp/MSfyGm40S3GWP1iLdyMKjl99mKvTmX7Lq5Duy8vemrcQP2SlbPL58P5hIcIa4B7lLi/2ZOulbnvdwk+fvpUYbtBPmgH9tloJezqm+1ZWiindye+Ym5Ltgu7Heo2asvJ6AQb6nAEX3lm+E15SqsQjPf+X0i7g7TJYa+UOYD2Jl8JMxVdWdml9fA5IJ8ymg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=shutemov.name smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P342ho8n2BxRFWU9uQePKPO8YipOa44GuHloJ0IQzng=;
 b=VcD0AvbBbTUteIDbcjL2NCYxe6YHgexp5jxUlVEEdVNoltzTKRY/t9+MXm8INsX3AuD+P+c4SAcwxLwvuPdkabVDq4XR3C2kn4oFJjF65Dk1E+U1shfIyF1yxy9kKjx/f62mpNt5ZbSN4OL43cBU4Wp+nT/q+C+AfP7y+F+GNjI=
Received: from AS4P195CA0025.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5d6::20)
 by VI0PR08MB163015.eurprd08.prod.outlook.com (2603:10a6:800:367::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Fri, 14 Aug
 2026 10:01:31 +0000
Received: from AM1PEPF000252DB.eurprd07.prod.outlook.com
 (2603:10a6:20b:5d6:cafe::19) by AS4P195CA0025.outlook.office365.com
 (2603:10a6:20b:5d6::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.16 via Frontend Transport; Fri,
 14 Aug 2026 10:01:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DB.mail.protection.outlook.com (10.167.16.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3
 via Frontend Transport; Fri, 14 Aug 2026 10:01:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x/bH4SK5oeiy4jFP2rT3AnBi0B6i0BCaMd9+9mQRDJ5uxlubBrW45LwsJRo4SZGXLrTmivpD4l1wZplDFztHwhXTPpZhRAabQtbcdkVSiz8QerpxkChHQdNLNQy8TnIPpJo2OnuTmIUAAJCcuPYrYlt3lYyRqDAratSJgVWKJxRcQ2Or8D3phXPiJ14A1JjFDTuGrYAOWqxwSmDRbor4/d/M/Tr2r5XUFECp1E5FiFXXqDl9ExAtFmrMw259O9gOWOvKVvjMuJ4q1pjB52Bsc9up9KbZ6gb7OxUmH+/dNcQsbd6i4ukL1oeavh273Ll7EgjLwg6fRGcN8yXevBOm5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P342ho8n2BxRFWU9uQePKPO8YipOa44GuHloJ0IQzng=;
 b=IYu9DVh5uGmBrhgPdaQpwb8+bUxnaaQpCJetxkEVN5bNLcSLoAz9+pZB7aQfRgA/bMX+Odu/zyF1KBGA6Y1qzcTk5xcWTiIa1sPTF2lyca/dTuHNWvJPy+9vPyyGioWEaVMPy42PIjki5+y6IfJwxjOddBEP7tr8U7j7L9qud2ehgUFbWcqvznbELQCOgilu8QU53fcKO1JgSIMA0QCIkpsUcngLlNwE56OdiYoWVc8E44uFSe0JslpDVgRuYXSNPtN9xQgnBo+tW1oSYRX6lAOTcmMsIPb8bOrpCn61slQLyjlXQBWmm07Chk8S4fW6nErj1vR30iOLMKTo88eCNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P342ho8n2BxRFWU9uQePKPO8YipOa44GuHloJ0IQzng=;
 b=VcD0AvbBbTUteIDbcjL2NCYxe6YHgexp5jxUlVEEdVNoltzTKRY/t9+MXm8INsX3AuD+P+c4SAcwxLwvuPdkabVDq4XR3C2kn4oFJjF65Dk1E+U1shfIyF1yxy9kKjx/f62mpNt5ZbSN4OL43cBU4Wp+nT/q+C+AfP7y+F+GNjI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by AS8PR08MB9018.eurprd08.prod.outlook.com (2603:10a6:20b:5b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Fri, 14 Aug
 2026 10:00:57 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%2]) with mapi id 15.21.0315.014; Fri, 14 Aug 2026
 10:00:56 +0000
Message-ID: <7e109334-f3f8-40dd-8215-6c5184468d32@arm.com>
Date: Fri, 14 Aug 2026 11:00:54 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev,
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com,
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev,
 vbabka@kernel.org, ziy@nvidia.com, agordeev@linux.ibm.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, kas@kernel.org
Subject: Re: [PATCH v3 05/18] selftests/mm: keep khugepaged out of the swapout
 the swap cases set up
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, nico.pache@linux.dev
References: <20260812132304.199287-1-kirill@shutemov.name>
 <20260812132304.199287-6-kirill@shutemov.name>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260812132304.199287-6-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0522.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::8) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|AS8PR08MB9018:EE_|AM1PEPF000252DB:EE_|VI0PR08MB163015:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d954588-2e32-4733-e65b-08def9eb03c1
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|6133799003|56012099006|11063799006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 LZKbxbrfaU+N/1/gfDTo3/8hNHwBCd8BUyagHtWTrt/IxH6/J/+0NcdTRO/F1Ica3xFCF5oCzUGN5lUk9QVqiS3umVQdqxfNC8s6ljHXt+Oz6sFcXXs13g0IfN88wczAnDgXlHzZbiJf8a7L/Qwv8e9pua702plPPJnFiwEyuB5yJroDSHq7ozgLSF6jAgdcMivCJRaH+XV0wNwVGQs8+RSW2RFoKQMtyk/AzAd6hRoYPsK7BF0sIx90z6bVemidqPBCwcEcpcrXz6M2iyMUNWY5WX3FdMab9XTawkCOyT2RmIci2RuJc/iBf6QAD8yA4zZTIr851xRfRyHp4YQ/FcqSw50sN517lwhXusNIJduCNAOKmJ6JpUnnUFs2SCQP4JxeiXw1ZPs8riU+hyuRFRU3WJZLaihZngLR9oTy8cXRDuHvYoLZR7ubp0JsuSXjLk6Wd1R3bQ5vMUp8FIQhdgSt61TcXG5OFv0W3gthAD3ZGrJqxqDAm16ZsaM5a9/jVwsc9bUL5ogVaOd6DwuVgvRC0sR/UZfPhRFYIfLpUXUWcznm6KY10+T1GLyNP7VTtkdR6xcExIFITXn1Hg+LE80auSpyL4GGjqO8E/A6g8X54sN90H9GxC3TRAqBxw1cgXCiwaL/ZMm5R9E4qbYIPWlaBKmmyATqXPtDuH6mW6I=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(6133799003)(56012099006)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 T78AIWT7mfg2b7gBffwIKbXQ26dNTZFvqGcyGRzgNSd2HO4OH7FW3vhRlPx3rw5arGBiy+775nVN7jPdqMFksDbrdGB9MEKR/UKFTB2+GFuyVygMbtN0irrGpEpVwMpv8I63T++Ur6Ey0zuUC68NT24SRIVQeawuM8OhAhySSdb+7B0zYN19z48gnts++8aw9RkgZ+nKYfJAqxZoMGz9/uwwlEfdjK9xCbkpTF1hmWqwPg8Ww2ilUCqZcrWHwYYmAbhPCqzsB748YgWZ5Yj8FaT75b2kZBoggcYaXhCVqDMTcR7DO0/5eDNpLZ7fnhIQXjn6IkJPaIsTKw9XoChVqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9018
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f052744e-ee4b-483e-ce82-08def9eaeed7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|14060799003|23010399003|7416014|1800799024|35042699022|36860700016|18002099003|22082099003|56012099006|6133799003|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	IVnYmnE3x6ridmrrn5foeeCfs0Ai3pW7SZWayx1ZNNQaeEv9J2KlxKm11mjwA12p2j3N2sG07EySUmsaLu6Z3uya0XYD8I4l6hS3Jsm+JCv/gxzciYP4T5eu+iNonryCffk74RnViD+7+R7l9fDUx1E4w3ko1pC+fItRGaKVipMf71IL1z6okf4YYRZ403fFpP+6tRjTPfXVSMtXRjS3GxkxArjcLgbj5YXdDyydIqw+YA1lcpQCtKeCaYDb7kQIXr80QE7YJgCP8iLIrRvuwXeODS//hQXFUOz7e2syrGHB79lp14+oENuIIoUSMKZXiUECkp2SAFoZ8ZFdJ9NupbzgU/REXIw0dBRHg0T5qQP505XuiL2tfaDltdRu4ur+Wge3GUxv83fPY5qJ5flCtrCOkft+p1Z+Dgp1bHtBwteR2jxcge91zZfQiZ5zkTOX8VcNDWf9Svisj7alUnuLID1t1TW/1KBuSWQvTHPo/H2f3PbpZuYXOmNGqyVarw41xUqz9sb3hrL1ftm1gAuwpYV63E4cBSxgYog0qEicAzIaW81UjiImU0hmQeZ73lErsPufa0y0GDhaZCp3cTfJEyILCl+XmLVefS4zIrBVaOYbWHUpLLDm748R1KadJ57zk+73ZBA2PI0V9wOUAJV/FGQ87B6EA73T/vKEzY/doWz5b74NCw4f3lvA8N5MV/iTZejFEhgk8wVWgydeHsILqA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(14060799003)(23010399003)(7416014)(1800799024)(35042699022)(36860700016)(18002099003)(22082099003)(56012099006)(6133799003)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LVztdH4WmabOebpUqqW0LOpLxP4Yzl7WYXKS2d1+0ThnvrO8jMC8OXddJ7xsyF/wchJFdCUoXQ7Q0CJXDOosTsAVr2o50/P+hVQre3oNN/hbPDJjsKrOwH+MuguD7M09X+41+E5IEhr5L/QZLK8R6Jo3fAAdXjM+BDuwkXZ4NrJgLLPD4UzmmPXGApGzcQkrZd8/LQ0ujW2RvCGMCT+fvubQKC/QZMW/KQNULh2I5g9lVTWIRLW+/ZmzE21B/ZVY4pGYjILL+tQizYMhEBMy4dTxayEKnDtw9yx3tkp4AHQ3p0j+Whg75QTvnBbJPKLSY1SLEGfO5inAZKJdwLH4U9tMS/eBRKpm7RRUfCzfJhP7/TtJ+19qKusRYgm9dRBV0WHshAtu3ZOW5omT5l0rjfhFT1CaGQK8uEl1u+UMsviP1QsyvPsymArrdcNTeXBk
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 10:01:30.7783
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d954588-2e32-4733-e65b-08def9eb03c1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB163015
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 36F582000B
X-Stat-Signature: fw8611z3zybw9wgi9ijf9oor7nhmxtwj
X-HE-Tag: 1786701698-296622
X-HE-Meta: U2FsdGVkX18ERZy3+HcWCilLWzJYaS91ARTdn0hWttARrJV6tB/LbKKiembcafGfKRxDeBCfXT9xhQ5XukLQiHt4Ur7Pcvk8f0rRb5CktQnDoJco6YYQIozQjdZt6keMLYvjVoAZrm21+K+1VfzJfc+3XKnoF1f23bj/11JmJ4I1hugNupS0ZY19iz99wc6wX5s+REQx08npG7pKGxzhjsVc5FTSBmZpW5yx92s4e31XG9wyTxUANDrpjTj2iKqtKbIzcvhDPROdLp7pr0rDKra2Ov//hILyTpK6F33RARRWscfRHGZ2ifsEAXOzx7AwmkkuXxjA96IgDah7ia57SfxqZGQFDwz21js9A4MFQrZjNtFGU0MVk8X5Ho6K6C0NlVJ51Aal/aF1jMjqHSV4qJipJi1g2xt4JKUcrmOWmQwv3PK/0ePgBT1ux3FYafc4pJrq0tSUgdo/rHUTKjOJQPDrHPhb0WZYbEjkiBkNqG0Pgz/PzxDRnpIuL/yg2PUwp+isqJY/Rng7AvKdgg1pUObZDTpVAVdRpcNhS2QvM6QkAQVUhuR4fppxBR/lFbkGJBmlqiYQvrDSREpwgAIdkPZtc150CYkIIn4jQ711pKNWNiCpTdLYQ7TWX2+o+AlszZYisIWvDc+FImbYoBgzkyAQV+NlTw957+KPyAY0ALG+89AxeiKFNmaUFsuSZQOSl7WK8s0LGiB3QuPXvcs3NMUb69V0Inbnj4W6RWRkUDgtzZJxxVuKUADR0sTcxgzybnBzza57mFfxCX0SpIe57TYA7nz+3GcZnCJLEnmSFrlBgUWCQv0iU0P83dpSkyEw+rqvWhS3ZYOwVgW/DiCHTXlmft2y7MsOaFL+eXHLMuijOQ90Q7ltpNB8YCaWq426Qnopbgur3TW/AJM//O2nRh12W2FArWtMZd4wQoCp7HLSpsl8y5PGz3/lhEzxwSAaHfxnYszfUPMvbdZfZJK
 Wq04Wzfb
 MdNgsc3gdJiGE6+DCrVVkZown+E1B8JODthfkhKqnEV1yd+EinKyMBZyfTf5Mu2pkski+9ix2GSWR/hrGE3D9sB6ElHMYxEqV3pTinZfCl8gqJjHrQMfp7yD6yB6K6OgeOE50NGLZPFBK8uOZeg6Yy7+Z3/MnmRTsylqJLVRY0SenbqTPBKXTaYDke0uygPJFhjzZMhHWBDFDeuF3wYsaGDj2hgA7nhMd/KSWPoh5kte95jHmkxZIL5JG7MxlYNZov2ooadBlAj2fyMrUBScS7muH19/OLUwNs7+wCVoh0GQftHCNMl4ZGzXi0LWnqygpugvLhe2CWCFcXnzzsv1d15Puew57BvZSdQZtKHwK5Oo4W2CgXVfa+QeTYQyEOi/kxO6IMtabtBecyYF24lcIG9o6VEzI0pD6Io6/ZLg5QuUYTCP6SzV03xoUYcPqnbsU+mf7bXgbFnDNCYFCeucHLToGTsA21BcumLGGZWHz8h9xVpuiJr/yrC6Ve+isKNVxfv8JppjEPM6x2SFhQ2qnjZuvD/HMz59x2pnNAyF2z2BlCpFlRQKs5UarGUlqc3fm7jnNDzwfFA9mF35JU0zPNQ+/28k4g+zwoALN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/08/2026 2:22 pm, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_swapin_single_pte() and collapse_max_ptes_swap() page a range out
> and then require smaps to report exactly the count they asked for.  Two
> things keep it from arriving.  MADV_PAGEOUT is best effort, so the count
> often turns up a moment late.  And wait_for_scan() leaves MADV_HUGEPAGE
> behind, so khugepaged is still working on the range: collapsing one with up
> to max_ptes_swap pages swapped out means reading them back in, and the
> daemon empties the swap as fast as the case fills it.  On arm64 with 64K
> pages, where max_ptes_swap is 1024 pages, that is 64M a step and the case
> loses:
> 
>   # Swapout 1024 of 8192 pages... Fail
>   not ok 10 collapse_max_ptes_swap
> 
> Ask again for up to two seconds, with the range held out of the daemon's
> reach while asking.  The collapse each case runs next puts MADV_HUGEPAGE
> back, so only the setup is affected.
> 
> If the pages still will not go, skip.  is_swap_enabled() covers a machine
> with no swap; what is left -- swap too small, full, capped by a memcg, busy
> with writeback -- is not the kernel under test refusing.  An error from
> madvise() itself still ends the run.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 53 +++++++++++++++++++------
>  1 file changed, 41 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index c049ac997def..8458cd2ff0df 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -241,6 +241,41 @@ static bool check_swap(void *addr, unsigned long size)
>  	return swap;
>  }
>  
> +/*
> + * Page the range out and wait for the swap count to say so.
> + *
> + * Two things get in the way.  MADV_PAGEOUT is best effort:
> + * shrink_folio_list() leaves a folio alone when it cannot reclaim it right
> + * away, and one still under writeback from an earlier pageout is the common
> + * case, so the count the caller asks for arrives a moment later.  And a range
> + * an earlier collapse left MADV_HUGEPAGE is one khugepaged is still working
> + * on: collapsing a range with up to max_ptes_swap pages swapped out means
> + * reading those pages back in, so the daemon undoes the pageout as fast as it
> + * is asked for.  Keep the range out of its reach; the collapse the caller runs
> + * next puts MADV_HUGEPAGE back.
> + *
> + * Failing to get the pages out is the machine's answer, not the kernel's --
> + * swap too small, swap full, a memcg cap, a folio still under writeback -- so
> + * callers skip rather than fail.  An error from madvise() is different, and
> + * ends the run here.
> + */
> +static bool swapout_range(void *p, unsigned long size)
> +{
> +	int i;
> +
> +	if (madvise(p, size, MADV_NOHUGEPAGE))
> +		ksft_exit_fail_perror("madvise(MADV_NOHUGEPAGE)");
> +
> +	for (i = 0; i < 40; i++) {
> +		if (madvise(p, size, MADV_PAGEOUT))
> +			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
> +		if (check_swap(p, size))
> +			return true;
> +		usleep(50 * 1000);
> +	}
> +	return false;
> +}
> +
>  static void *alloc_mapping(int nr)
>  {
>  	void *p;
> @@ -855,12 +890,10 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
>  	p = ops->setup_area(1);
>  	ops->fault(p, 0, hpage_pmd_size);
>  
> -	if (madvise(p, page_size, MADV_PAGEOUT))
> -		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
> -	if (check_swap(p, page_size)) {
> +	if (swapout_range(p, page_size)) {
>  		success("OK");
>  	} else {
> -		fail("Fail");
> +		skip("Could not swap out");
>  		goto out;
>  	}
>  
> @@ -887,12 +920,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>  	p = ops->setup_area(1);
>  	ops->fault(p, 0, hpage_pmd_size);
>  
> -	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
> -		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
> -	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
> +	if (swapout_range(p, (max_ptes_swap + 1) * page_size)) {
>  		success("OK");
>  	} else {
> -		fail("Fail");
> +		skip("Could not swap out");
>  		goto out;
>  	}
>  
> @@ -904,12 +935,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>  		ops->fault(p, 0, hpage_pmd_size);
>  		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
>  		       hpage_pmd_nr);
> -		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT))
> -			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
> -		if (check_swap(p, max_ptes_swap * page_size)) {
> +		if (swapout_range(p, max_ptes_swap * page_size)) {
>  			success("OK");
>  		} else {
> -			fail("Fail");
> +			skip("Could not swap out");
>  			goto out;
>  		}
>  

Reviewed-by: Muhammad Usama Anjum <usama.anju@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>

-- 
Thanks,
Usama


