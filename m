Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E734CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8478E0016; Tue,  9 Sep 2025 15:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41A68E0001; Tue,  9 Sep 2025 15:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3088E0016; Tue,  9 Sep 2025 15:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 777688E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:11:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EB4B1605D1
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:11:22 +0000 (UTC)
X-FDA: 83870655204.26.66671E5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id B4A4FA0012
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:11:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gnPafKCM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WOe1d5LB;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757445078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYMschXM4hT5QdirT9F/P5bF0eCuwcLYsf6f7qx/3nQ=;
	b=RYduVFlqAxOpRP4VrhsAhhZghYlXOIG/REU24bqrnZiI16mOXDDR3exHHNJPG9KVGH25wH
	JIl9rbfEYyJEnHql3T3IttwXkgNTTmeD1en/D9NA5BYZg6fOOD4aDckCyzGO/9X1TEFsbO
	PGBAPHdZ1w/xYx8fWrt9mR1s+Sb5RoQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757445078; a=rsa-sha256;
	cv=pass;
	b=uk/uN+FiWm52XMvyOV607OV9bbmBPqAHwL5BktdH8vJHo9uNlMQ4TmkhDexUW7eHPj1PAB
	qFXJoSpBm7s4HuAZhbl3ynzLhPgeOgXoVL97xBxvR2Rus/TxZBWmxWEp+Jzvv8p4e8wC1x
	+zWUVaSxkViSRSxLhSxqD9L0THhTFgI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gnPafKCM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WOe1d5LB;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589FtfBY020235;
	Tue, 9 Sep 2025 19:11:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xYMschXM4hT5QdirT9F/P5bF0eCuwcLYsf6f7qx/3nQ=; b=
	gnPafKCM4v0U/0lJE20D8rkP9tNEalFYl2eXv4qr9csrh5GBoYrTopjukv6gPN4V
	tvhaHzZLq+ZwGYiVeyHVZv5gQC8V8QhrVozyczpAIQzA6TUKW0Ah+wsW060PIA7T
	hGYjTdEgksvcNeodCD1HuBhgL9Q+L1ybTCfBwpL4rFbmfUEpWQSXRM2vjbpscq51
	LeOWdANCXRnxyyCsE6sEhouf0lz+wVQaCEgFhtZHh9UFNkPlBWO8tH1Wz85lJxBt
	RFTIeHeVmZIP1JSdex+YrCHpT7JPNVyRbeFFmXy0NSWrMm655w3IqEpaHFRs/wTp
	4da1HGTFalNDzDJ6FDUMLQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shtjg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:11:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589I9elj002808;
	Tue, 9 Sep 2025 19:11:09 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010049.outbound.protection.outlook.com [52.101.46.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdgj32x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:11:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mnJ4StFdzugkM6ZQauOUEh1mCHKrSrdm7aM3nPZoZngb87mftQXBKEyWDrO94rSlYrqQfWCHujcCAlRry1R0bf8JRlIWZwU17S5cza7vrqD5zeTniXhAaPMuj41W4gkbwEklu6oOreqhcjosQXh4BIF42IZ7RGfIrFokEZWVb7WwTT6jDJIoCQAqqBJfl3/3GnVO69mWTCTpXk0zqf2zoZ0iE3IMXnCCdZof5GqWGRe+sYvwm+9whGM0KS8iR6RGuMgI2QBUcboRnUxQtUrzVBzgLMVKVRqPs7CPdkodIWCUiYGyv+GaCBUNA6upxCnrOD40+B620tTWvpg6CDnl3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xYMschXM4hT5QdirT9F/P5bF0eCuwcLYsf6f7qx/3nQ=;
 b=YFkkelKURYL+hCVXlm+bcQ0vqf2eQRjAiorIkonI0yPcfv6TBXmuxOflaV2GG6D2ah6DfNllEdzs7U4Gf9qbf/M3WR6lvpwEiQxO+21EJAIDD5wm2azCNQG3dCVHv9C/urA4FvZM5mqxkUWEbL3guy9CTKR8NC6t0BjJgaCYWuiFS7y3zEuuo9q7z94F7tphZwJiTEhpzsVjCEvQ85e4lzNKbfawR/HSh70o3ygW/Q2THkwIuO6NRG+moRFbce3vtEzX7l6bVFj0t1kohb9b4WlCtIO4lOYFN7QsXZ7Gmu/kaRnYXWQjUy614S1YhPgKk/NnuiUobZBlxV8Erqcc6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYMschXM4hT5QdirT9F/P5bF0eCuwcLYsf6f7qx/3nQ=;
 b=WOe1d5LBbYSpyzsBqFKsI79HCnaZ7PTIGp04HoUgN16nro0qeGKYHv3NshLcEwiBBoSvVFqoK6x7k6EPCItoFhlhoov5ehXviB1d2prRdAXnjgJxT9RaEc9flK74eqciyJQuXjskILUYG/ktudWGnAQRz3UTFTOMvj3MVQkAoqs=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB6740.namprd10.prod.outlook.com (2603:10b6:610:144::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 19:10:04 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 19:10:04 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v1 6/9] mm: Change dup_mmap() recovery
Date: Tue,  9 Sep 2025 15:09:42 -0400
Message-ID: <20250909190945.1030905-7-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0480.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB6740:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a3427d6-c5fb-4d15-b4ef-08ddefd47b4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WrAD13X7dykpu1NOA4ZAYiwPoFyGS+kEt2G4TSZ+s0SJnzsmoC9CR9OLI65t?=
 =?us-ascii?Q?3mIKq1gMOSBOfStf+XHsMwWxvYdtny8HEvWOWTbLNtqBJZ0eEW+9HU6bj5p/?=
 =?us-ascii?Q?kyY8H3wIlbybpg/MjH4SHr/Ov2XxcjZzCwh88yvnNjLGxKZm9eI+TEM2y4Pj?=
 =?us-ascii?Q?P/BovjjRajcNRjnXL0llEFOEVAmvdFmEkU0YAAuLxzcLS+XPE0fyAN2f0CQC?=
 =?us-ascii?Q?kY2/Osvl4HaTa4j+QEoWQPXW9mzN2Dp/rT8/dwXetaaqHMlZeEbP4O0vEf4y?=
 =?us-ascii?Q?V8fyAGspTjtd3a90zKZnI4Qz2qHhiA2pTbE4Cn11XKw9EpZWjXm27fC+yCKu?=
 =?us-ascii?Q?2QN36hL/FLdAc6KglamtJGZMM6vDO0mj8CsdMWeYUYymSJnKMekaDUzSSsNx?=
 =?us-ascii?Q?hV98tAlLNHHsRDPPZAGTyqVYvnoSiC+ytRTP+ohC/YE0mnJxsK877wMgfTrK?=
 =?us-ascii?Q?ramQuKvn1N53AabNlC1gpppWF3MULCxuHBbbqQQz3DUenbgLuQtlaeUkbGsi?=
 =?us-ascii?Q?8F07o0KLViUR2qdOcIAO/Sk5KT1YHa7Seu/KrnRm00tbi4r88AiJapF+L0uk?=
 =?us-ascii?Q?j8Lok71DfjqM/G2efmftn2/JJkReaUw6SDgOJ2hD9e/J7VWDkFjzUDhyfaY4?=
 =?us-ascii?Q?07JH+sleQE8dJdl6hiCn8Qaqskf5M/wri2smJd7y3TU1gBOq4sXP7FZNi7T0?=
 =?us-ascii?Q?m+8U6nOZW+Mmza+3fZrXk4fRZg8FlnC6bfF/g9Bn46H08iISQAckROnP9xDr?=
 =?us-ascii?Q?LfVZR+RErpkIQr1YbvGRX31jdGiH7W8CxV5SAKRCuYVVNN4PPYswYEQPWjco?=
 =?us-ascii?Q?cI4/dH8UmF0GSUdSc8Wi9WPT45U1OwTio1SDzyfvgKMok+D/6/1BSi5zft6n?=
 =?us-ascii?Q?p1ghSo88gRHGFF4C/S5bRlkO1q5+y5Kl1KV+hLht85OudefSiXPmUOLROpWs?=
 =?us-ascii?Q?jNlJb4JwiFr/Ima5jrPz7RODDX/kPfwpyxyeW8eGNrmQ6rF+sxnZlky5rP7E?=
 =?us-ascii?Q?0J4BI+nqBpvqze8v5VJhytOx6jhuT7+Pg/4uUR/ZaOINgQQcY+v+uINgs/BH?=
 =?us-ascii?Q?76rQfFzTgIVOcGj3bsJxHZeu0KbKo0vjsQkjVlnDTzDxoN83Mv6Ar/5BxTBG?=
 =?us-ascii?Q?Db7avSOgETeKaINYZEn7T2y6UMVqCKj6TE6hJaaHG2VZUzb8t1Sj+DTskHqw?=
 =?us-ascii?Q?ifdivDCSqhdnGAYJokJ1rx3MO5riFxl1jDhRW61vumJjqD+/tIR0S+MD8/ud?=
 =?us-ascii?Q?z00fnb57IpBWuIxxQ4H4R4qZ9/yH40qmPK8phMTe5EBiBfi0bCyHSwzQFXhW?=
 =?us-ascii?Q?ATRjvUDG6nh2+rEtSxe39MtucZyL9Y1SJAMtecbU1Qh3NUCDtLFNFqlZbHAd?=
 =?us-ascii?Q?pDWz3CoIYWBG2rUycfCh0zDEiANHnVV/UQ8J3gtwDFxXOOdrI3ladTY+q3ib?=
 =?us-ascii?Q?RVIRvuTLTKg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?axjcLjd+vGelJbLRPXVAl0pfzm3zWVZ4iNMHONnBO8mUdeLv6ksIMy7h+K3c?=
 =?us-ascii?Q?yXmfzA2tjtNUrVjc/pTu5B6b3WYJOhloP4wySTfCllv5c9NvJqAW0M0u5npb?=
 =?us-ascii?Q?S2eIEQSjDYnfjFUQdVBpCfjhfw24FqeLxskjEjyuXy5j47/604O8i66RuChO?=
 =?us-ascii?Q?bGuc/PLFSK4YD+vMTQM3a+C+fsAxP9PpXgsrFW0aZz0lmDRveTIVrpQLa8RX?=
 =?us-ascii?Q?7IA0gj4zq31h9HpuFTrfUcfq4A8wj+0slfqAM+MA2T6IcXNLOCPuVYLCzudI?=
 =?us-ascii?Q?CboQny3L12VFxEny3oTdpsrL6ylfU3Ry1S6+yK9RLcwCRYf7iWmqNxcR6j5l?=
 =?us-ascii?Q?yJMbwVWZDbin3FRFxwoX/hVT4X4W+O7XyC7dEZ5AL1d555EaproShSn1zILh?=
 =?us-ascii?Q?es5+IWJBZCUNS2BG7uV4x3+vU++FnOsHkXh5o5Byvn/7NmQ4mbh3SRafEH8b?=
 =?us-ascii?Q?QZR4diYmYH3VnUIdR6BruCEmLC6wTAqRR4VgSMLJnNzvYMTpYIbqQaYBeZEV?=
 =?us-ascii?Q?/6r+8/oxrbJxsl6vzo5FmxcsDQWiXSHOLNCvkTSdbHBMABZDomKUiQlgsQ2Z?=
 =?us-ascii?Q?wGcAYtK/53dvjmmdpS1TS0kg2MN+56sTlXYrp+ArGSVK0xh9r4/WRWlIBnP9?=
 =?us-ascii?Q?Tyz+Yext4w8ja6UXb7o3JDnnoRjUaaVBo4oIkiTxn2/DIkuLPNPOpd6vjfyT?=
 =?us-ascii?Q?lATf4FO0+VdTbR1khC4yHTOd3cbkJMFQXW5oe8m9H0+HPInheY/3lUqqZBtl?=
 =?us-ascii?Q?Zu4znab/2FCRGQLT1e3L23AoYt0+SVZCinUNeuqahlDoRRenb2Eko7e+lbvO?=
 =?us-ascii?Q?EjBzj4oj4Q51IVNmLuqpaQ9d6ptWFkVnZNK3pAI9lNGLswgcYsXEruMXhpOM?=
 =?us-ascii?Q?E0rM1PQRZoNkIGYHuL5ryjdfP3TssGAfi71wViH9Z4POzeg1pOBNR/9nQhrf?=
 =?us-ascii?Q?lIaOpqjG1j+pS7Di4+7DmeCwrAz0hn3eUnfzZqf1KGP55BdUoEtSfLwr9XQf?=
 =?us-ascii?Q?OwAYnMbVv/SlekEKRWQPins//vykQEtc174WugcAcp/3/zsBZcrHQdmD9tVz?=
 =?us-ascii?Q?Tzf4UCwLHadgeQcHuA00RRJSZ1GwKgCZY69X3HtuCJDkkzB3Wl4AGTY1AGas?=
 =?us-ascii?Q?VElTcnBUTEgdsEBR1WdecwfijgLEx9jJPTruKe3LV5gacFFcc1Qb1Ggm5WFw?=
 =?us-ascii?Q?71+0TfzWm3C7NXldOzOntyniTSu7AG1v2LAYEbFyZXLZeaQ9EEC1BdvCAbE9?=
 =?us-ascii?Q?j7KsUO8Ht7lKOwpRE4jfARgwj7t5/jVRhwg9lB6+Y7ZoSw/Ei6D9OHPIAo1F?=
 =?us-ascii?Q?47zNyeHWIJq4Ik1kD6Eh2GL1VALdPnoWfTQkoSpjLAto7IYHg3ngNrcwY2vl?=
 =?us-ascii?Q?AODmZm9Hw0dOOP/2TB/SDIEef/YJbiVq/v2I8xqQw8060ywDyiWO9WhsqYVk?=
 =?us-ascii?Q?hPB3dza7iwUNbipDwpbOs0dHpcHcSym5oSIRCUvSHbggQS3ugq8TDouvXg5l?=
 =?us-ascii?Q?QQ4I+ns71NrkSjm0TkNohrZKaYR7ErsCXw9SBcZmIUFVqeDjrXsSWf4vGtT5?=
 =?us-ascii?Q?/xb0hIf15s9P8y50ueOK7xbnX2G7JYI/RqlRtutPsFy9VML/vrdWcXfochHK?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+efqXQzmacN9YxVmqtgeBJMGy2Je8WObDkdZDS8t5OOss7jo+WvC6WI1C3hK+Xu6iGF5B3VCqxpoav3a6OkSnRgEdbw3yGrR2Rx83SsVVnj4HbEo38iMI7LCY3PXULMWCYTw8xwy9jX30kE8pzhANL16Wf3sap6mSP/KYgA/LBRNO9PapIwUVoSSTOWDIzCYCjnXi3txjKuoLHh+FBEbFkwtF1y25F6iZrukYUVGqSiDnwYcqAyZGmIXWe7U4Y5/yaJe9W7HDTrwvIEjLhnNZ4opNimLsTlNguUNLGzViszOM1mSL9gA1MsY+aJXEjuWewfCxGOkzz6c3rAgKI34YrRK7OxB9aKAZd551LQx67HAIBwffARIB/S/FllMT4Nu8tuxq4+EzYEdxVJBVeln9UMwY2/fczIi23PqU3MExGi7BOKfnskrasOL75JlhMKgXwRGryJuRPyk3eo3lVHcfDWHjhyGMUkqckmRjyYai47fs1RMCJbXJExo1KcgGa8nGyDdf6WLHYdzmq6WhszXHSIlivLVwHZt/zoGmqkszq9x4gejw7GSMCYpzGJg5mZh2PqXGXj1QM/i4OMhGNHp7R7gw+H1z6lsFpU3IjI40gk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a3427d6-c5fb-4d15-b4ef-08ddefd47b4c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 19:10:03.9730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJlsfepbdA80qtNGrxgV8xhj/AMcmdy04dWV1M4vDsSgUDZB60gKhD3i1vD/LPZtZKX8fnA+l/o2rrQP8cFWIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6740
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090188
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c07bcd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=GSebvwEjJFBsbC99ckQA:9 cc=ntf
 awl=host:12084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX7KPJF1wK6PFe
 xckOOY22Q08vQtZyNEALN7uwoeQBMWrJqcwkXLNzFDGuYcQdGPC0elJxeywfbhAknrGOKx/lSA7
 5jVMTMzxm0jc7nM180+vJT7foZWjA3YwgoIO+e6/L4d5dCRPsdF1h6D/RAnPba5dk/9M0dS5Af1
 BWoU7hj27UPAmvIyFI+o6bDl62JQ3haQagsRpIlWNESPVz8IAHDsFivzW/7YWFJ0r62l241JI5s
 yigwrX4XY1481/+9SI6rk2BcwrXKy84dlWjl1UDbn/uzq5hv4lsqVuKHTorgxOATK5Ud6JHtiNi
 oqvibdLAlWWUTNv9lUpX4j8kFMV7ArMaEJ8VUYHyDrYGPttOAtEDE1q9mI40q8+77jyCDK/kddU
 UoCKyPaN69QLs/rOerJPSS2MNF/zTw==
X-Proofpoint-GUID: DeUDRDHm8OZXHwh7FAn5YkedGW9xGfQ-
X-Proofpoint-ORIG-GUID: DeUDRDHm8OZXHwh7FAn5YkedGW9xGfQ-
X-Stat-Signature: pdkuwpy88rbipsf7msw455ezko3w1bec
X-Rspam-User: 
X-Rspamd-Queue-Id: B4A4FA0012
X-Rspamd-Server: rspam10
X-HE-Tag: 1757445078-659689
X-HE-Meta: U2FsdGVkX18xVYylEKhA4bdLLa1V0D7RoRdRG8YurDqdjT9gEsMpnnkko1uDuhHx/oK9X3Ro68FxeTuSjeod6fnOX0bXqD7Id+4e1WyF2SxAD1cGzuomMrOi1rLChvcDU6tyLN5SVaRXwQvhihFS95VJaJ2voFgihAFW+AYd+aYBuzU4grMthdzZEAhoyUeGTYm8hb2lNYGLRQdAjKzuqZmuZcLdGgIucDfb2eN6qPVKPD10VOQAVBFJBv8QC/JryUcX1NNr9/ClVegx68hPV7IPBUABH1yCqOdTFzNVg3sCfLxj0GOAAT0fl14beAKBRQpaGQV9jU7S4E8btMeTrnX1ZcQKWMN33u8J4iONWFp6f9g7AhVGgiPQMHOqlG26KpcRuAlpxvG/FsCWCma+PoRu3uE9HI2qtHEOV31kjDoqxlJsjaf243YJaKWKWaUklINpFzlFV1FGG/mFxZqNn9W3753QqSWW+lbB0kyuwAg7bjIn2g0h/nFiZjPcDVwTdjYtgfiY/Y3ahgn2lEr8x+g7MWRTZ5xOzq3UGvSnIWAc8kKjZaI9UnZl44lQBq9JtwegWBJERtFLCvJYtAOmByWbN1wh0C0KDW1NU/Wc39SBKjHO9AdfQRp/sis00kNVkixeKihqOPSkgdHsqzc9C2XrKO03+1pTP0/oY1+R8gJHNJiDJfm1ZIJOM9J5OcTv72sIqr6pORKDIaWzUC3xNaprbfBeyqLffEie1mvQTMwqKUO1S0d6UtiPvZSPTMthHLXCqm8HBBSyCPS0aazVZPPCQ40wOXAxwPm4YaRgXiaqBXXJvN0pT0Rk5quWiZcG2EZw5GkfQkU/kn9uKibQtVlXrj7C59271uppzkqN8RDMUUE+Gy0LFjcuQgbvVsEIz621PKvVvGaqEo6ed7Z9LXORGydlBJrKG06+v/wdycBvDnbysIglnKFPDG4XuRWMfaxrCjmkEnm6Er2SBK/
 12YIYL/E
 xPD0NPFcG+zYNxVagE+HWTHubrxK1mnQqv+abv8gMI/BIPpX/3mSnrZ88M6opyv9wZlAAqeApEDKLMXppVNWK89AiyeycMcV0Fx646P/kuOf8GKNss+/b9/sJAmnHEBVi+f3W7HMUPHm7b4ooXupzK6K0mHlktRlBhTIZQEfREdS7uUXez/r3v08nElZxo5rIgOE1XPisN64kOTJ4QDWQ1ogcoHdWCI8UuOugDrHd3vWnAxox8CcxA00P/w47YtAumxj75tonhgR4SU7E4bXbmvVtFkcc/vFuOgw1Xy37Gs/V0jHhq7O/KtODzO3k82mHNG+jllpO3GbO4tJdJX3c8GJ1Fx9EOuCDcT4uqXIRh02jXNW+XlOZ0vukRjWI83GUlzad51gQTyeegH/UHT6BealAYVGzETmJ2qhzMmLBKQa+GdIJUCd2TH/gkuIuNvn8lAOHjBbGpEeeyTwF5cLVTawi3NwFyx5s38gGh1DRf5507xGPyqf9dLWxtnERGSLtUO+cooHX80IPgXaJtKV3Pw3LG7rOj3cXy6Leac/qqOtnXr1dEiK+0cShOtPQIfQ0iQqCKEAppovykzfPaJp7YIl3VrwXGo1cGkYH613x/UuZEwfDCjA/1BzSgdfPKpxj5Rl3q1wmx0IQDJlg3osmeTY/xWMmCEJUeS0kofGP94ojqZolDK7aMpqlTY8dJHcNqAD82/5qQ8sWYpvLRT0HWHhu+yxATGi5v8rdo85OiPaCJei8SRQ9HoysX9sgIq4iTjxVlsVVJcNlA6oCjpWKRDa2lbZmAErnoClAab0/MsQXToPI5btolSYhlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the dup_mmap() fails during the vma duplication or setup, don't
write the XA_ZERO entry in the vma tree.  Instead, destroy the tree and
free the new resources, leaving an empty vma tree.

Using XA_ZERO introduced races where the vma could be found between
dup_mmap() dropping all locks and exit_mmap() taking the locks.  The
race can occur because the mm can be reached through the other trees
via successfully copied vmas and other methods such as the swapoff code.

XA_ZERO was marking the location to stop vma removal and pagetable
freeing.  The newly created arguments to the unmap_vmas() and
free_pgtables() serve this function.

Replacing the XA_ZERO entry use with the new argument list also means
the checks for xa_is_zero() are no longer necessary so these are also
removed.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/memory.c |  6 +-----
 mm/mmap.c   | 42 +++++++++++++++++++++++++++++++-----------
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 24716b3713f66..829cd94950182 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -408,8 +408,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 * be 0.  This will underflow and is okay.
 		 */
 		next = mas_find(mas, tree_max - 1);
-		if (unlikely(xa_is_zero(next)))
-			next = NULL;
 
 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
@@ -428,8 +426,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
 			next = mas_find(mas, tree_max - 1);
-			if (unlikely(xa_is_zero(next)))
-				next = NULL;
 			if (mm_wr_locked)
 				vma_start_write(vma);
 			unlink_anon_vmas(vma);
@@ -2129,7 +2125,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 				 mm_wr_locked);
 		hugetlb_zap_end(vma, &details);
 		vma = mas_find(mas, tree_end - 1);
-	} while (vma && likely(!xa_is_zero(vma)));
+	} while (vma);
 	mmu_notifier_invalidate_range_end(&range);
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 0f4808f135fe6..aa4770b8d7f1e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1288,7 +1288,7 @@ void exit_mmap(struct mm_struct *mm)
 	arch_exit_mmap(mm);
 
 	vma = vma_next(&vmi);
-	if (!vma || unlikely(xa_is_zero(vma))) {
+	if (!vma) {
 		/* Can happen if dup_mmap() received an OOM */
 		mmap_read_unlock(mm);
 		mmap_write_lock(mm);
@@ -1858,20 +1858,40 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		ksm_fork(mm, oldmm);
 		khugepaged_fork(mm, oldmm);
 	} else {
+		unsigned long max;
 
 		/*
-		 * The entire maple tree has already been duplicated. If the
-		 * mmap duplication fails, mark the failure point with
-		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
-		 * stop releasing VMAs that have not been duplicated after this
-		 * point.
+		 * The entire maple tree has already been duplicated, but
+		 * replacing the vmas failed at mpnt (which could be NULL if
+		 * all were allocated but the last vma was not fully set up).
+		 * Use the start address of the failure point to clean up the
+		 * partially initialized tree.
 		 */
-		if (mpnt) {
-			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
-			mas_store(&vmi.mas, XA_ZERO_ENTRY);
-			/* Avoid OOM iterating a broken tree */
-			mm_flags_set(MMF_OOM_SKIP, mm);
+		if (!mm->map_count) {
+			/* zero vmas were written to the new tree. */
+			max = 0;
+		} else if (mpnt) {
+			/* partial tree failure */
+			max = mpnt->vm_start;
+		} else {
+			/* All vmas were written to the new tree */
+			max = ULONG_MAX;
 		}
+
+		/* Hide mm from oom killer because the memory is being freed */
+		mm_flags_set(MMF_OOM_SKIP, mm);
+		if (max) {
+			vma_iter_set(&vmi, 0);
+			tmp = vma_next(&vmi);
+			flush_cache_mm(mm);
+			unmap_region(&vmi.mas, /* vma = */ tmp,
+				     /*vma_min = */ 0, /* vma_max = */ max,
+				     /* pg_max = */ max, /* prev = */ NULL,
+				     /* next = */ NULL);
+			charge = tear_down_vmas(mm, &vmi, tmp, max);
+			vm_unacct_memory(charge);
+		}
+		__mt_destroy(&mm->mm_mt);
 		/*
 		 * The mm_struct is going to exit, but the locks will be dropped
 		 * first.  Set the mm_struct as unstable is advisable as it is
-- 
2.47.2


