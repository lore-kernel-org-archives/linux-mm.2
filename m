Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 556B9D6261F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8946B0184; Thu, 22 Jan 2026 07:50:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5D86B0188; Thu, 22 Jan 2026 07:50:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE546B0184; Thu, 22 Jan 2026 07:50:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7B2E6B0187
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:50:57 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6A3813A361
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:50:57 +0000 (UTC)
X-FDA: 84359584554.12.4AB4400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 22B3F180007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:50:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RBbX4mwf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bViz9nIG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086254; a=rsa-sha256;
	cv=pass;
	b=4pJ+8HOJ84ew887r4cPm8qIBAoLM0aKpJDXJc2UH40do70xw7aPy7qFiXjl5cHgiAlZkRO
	4yJZCLuTV+OkKxqIMWSWfxz4pi/AA+8vV8PM3Gf2ykHnbr8YXUp2VvZWlXyL21Ch/aQnzq
	ZnH9PTEcUrafFTeuAZekV6SoPEvcj7Q=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RBbX4mwf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bViz9nIG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8+mmP1U02Omf0Sy4YS+DkiqRVJ4tarmQ2ZXql+QKsw=;
	b=JWoHMZgtcWIdkn2snpah6zRRkO/IXhUfdTy7tzDoZU9oRMpTWpZPrkCYqUdMuQ+/NQSIYS
	aQkXf0Ip/C2dgmqV27Vj3hdOOC+glmlX7uvaSBBNav2z0ZCB3WpRn+Zkh+st0r/JqtOdbZ
	T5IxJG/UX+7flFasv1+CM5vzPwH+IWQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LNFdKZ3029196;
	Thu, 22 Jan 2026 12:50:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=a8+mmP1U02Omf0Sy4YS+DkiqRVJ4tarmQ2ZXql+QKsw=; b=
	RBbX4mwfBeVBWmfO8saj+GUXsLRh4Bohe2QNMniu6hQk6LmkQ9Rv5mLMJQnsJRD7
	p+frFEBg3H4ehL4As6pYGmzAQARY+qeY7eMf3nTqBolbbR/zx9sK8+VO24EUvmIZ
	iM97r4XorkLYqYQZNKa19Kv+aNdeBpD/5fLcko7jCe1DUjDepDjmu47WVesMVcF3
	QiXw2ixLLSdzuocHvpOeeMy2K9BqP7LhgUmKGS5gzFXleOM1MjF6q6RpgLOT0CK0
	Zhe74a3V1UsIUBK/tOw0179EPFe/WNS+Av2bVd0cd9CGASq+IsJWEZmXMyiyvEDS
	wO4VYgHl7DQB9FGvNBX94w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vynam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MCCv6r018032;
	Thu, 22 Jan 2026 12:50:42 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010024.outbound.protection.outlook.com [52.101.46.24])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vcss8v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CIxK9TuHloDYkeYokoMXFd25VC5V4vPwhv4daTYZkhCm+mkH/My62vumOXenH7WSXilRaN877FUJLYyqgLvWWTwk/LIifSBI0p327BEWtAFUkXXXV8rKo2bFH5HGxo41VeoBoTMIw5ok1h4mp4AxibhltbX1gpNV/TGCr3H8Xlva2wnvmJ9EBP0fXIpx926XKC9ynJxuytg8DtNZYHYEl8n3I2eaPbuko/5QtdRjJfioKSq09f1sLGS9NyaSsIKAcfvPqezh54swgU7tfg9fQDxdjbNwqMyYm5VH800ZgRGaYGO/CRpK3Vq2w79+MohHrZP+n2N5G9NkWoov07uZtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8+mmP1U02Omf0Sy4YS+DkiqRVJ4tarmQ2ZXql+QKsw=;
 b=HCRj3jm/WdTTK4AxFG33qWoROo6mKJjaNjcUAgp9exFxdm1TC5jwoGW9K3AdTkka5xe0fN3ZiOOBL96nzE1Riwxrgblcx6J04w5E3QwHUn1UXF75f5oieGIBEBIO1dPEm2Ql1iqG4YD+XtJ9T7i0g5B3hLXFNOfdr/0aUuluKYFRID/dLBsZxSyB49VF0tDcyvFURZ1IIPPvdildkopRnbB/2HvLVOzPh8riId8AbhJ6S8RpvAFKNnYP99rtPIj2QzA2++mQoMi6L0sJLBPhAqrBhEPjH4AB+0tzbzc/5yg8rAvDFkzWiVRZ3kRP35TpYSaN6A5FgiX+DYua6CGg0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8+mmP1U02Omf0Sy4YS+DkiqRVJ4tarmQ2ZXql+QKsw=;
 b=bViz9nIGTUWQWsy/usQFipM8dTPxgFE2neFV6WU2RPaNJVqD9IsvZgiEP5frVLF2cpiFVpT+d1qwISnLxj5s3cLLKEy/lBbADdMQPMqJxDuvHf4HwKe0wy4NUqd6Lv1VrHzYkzEoMMNY5ao6OXgEJD4CJJvqQ/IiBV7Gjo6eATw=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB7904.namprd10.prod.outlook.com (2603:10b6:8:1b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 12:50:38 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 12:50:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3 4/8] mm/vma: add+use vma lockdep acquire/release defines
Date: Thu, 22 Jan 2026 12:50:24 +0000
Message-ID: <4703b7320796908b9a0827c3d42d74d11b703714.1769085814.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
References: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0478.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::15) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: 184a826e-90b3-4a88-39fa-08de59b4d7d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BTtwIGpflOckZDSKdGYvXahTDyNgfyEjDK3c8+Gl0eVV62qt3AtQ2A6UWIni?=
 =?us-ascii?Q?BgntUMOJtgFOU8a0PH6Tl2XdQzEfz/ZIyQxyWubCG0R4NAvs5/xjbKg2eWyT?=
 =?us-ascii?Q?5w7RtUAuU1DXyfdMP5i35OfdapoEDc/wA1PpMZPq2OUc/p7pMgelQMhyB7su?=
 =?us-ascii?Q?5rlc0sopz031TxYXAYGSHwks5bH2s2Mpo2dRVhsbRwvUSA/LU9qhiCdQzNQ7?=
 =?us-ascii?Q?nsdICUzjUIwCgy+G1r9Eti919qbKiPNCTl49/ze3km9rTn8r7f2Vk0d8Jn2r?=
 =?us-ascii?Q?LWUOCBI3OebrBZHH3V8p4IWQi7PlIy6fFGdg+dY9N8VL//DAhWZjgfu5k4XC?=
 =?us-ascii?Q?QYTVYgxyLvcVjOVjzTNXQlscm+Tm6EUW2fpXYhHb7wU3TpQ4tPxrjsOfgMba?=
 =?us-ascii?Q?wCb6lkUXUTOeHbCmKN87aWZzisGh30TtNYGXR22+MoGZSz4KqQHPsQxG9PTX?=
 =?us-ascii?Q?1ANQCigf9AGaefShAyXq3WRZZcQ3zS46EVqo4EcpPYuSXxngNXStzYZ9yM6V?=
 =?us-ascii?Q?+7L81/29AQtCKbGo5Gfht2zzBaEbIW7S6o0rlanNnPLILcAB9QJ6Wuf5rxzK?=
 =?us-ascii?Q?EDQ5FJ/jGI58DtNf7+BNoWDAHXQ1eGbv60plQZ7ZhrpNTcE+ULtrnU2zI9zm?=
 =?us-ascii?Q?Ci1bA0R/zol95tEfMzvgMLmW/eL7OwTarnTlIvUOR6ZSd9ca72izt6WpDL7A?=
 =?us-ascii?Q?MNwElEqIaKe3t4asGNnCg7+MiJ77tIL8K9IoLsvDVU1hlu9It5BwB5oMDTx6?=
 =?us-ascii?Q?EgB4sTtK0kgdgR8KWi3LWzHdrrlkufOgYkHV/IFvMZXGm+EEpsKB5dd4vOcv?=
 =?us-ascii?Q?BQET1HRC6+pFDzUcoHlrj03Z3VF6AQ7fzDrpFnenM+wwM4bC/yMhFYFjXI3P?=
 =?us-ascii?Q?lLlpJmvXf/Yk47fekmiHg2CxdC698Pm3QXFQNh80nGfAyaVgxICFq/0rzMh6?=
 =?us-ascii?Q?wh8tCIB7R7LVEitlIUQB2T3vqlGJ2T7gqm1OFO8Lwgta8BNrOQuVJkQQ3mL5?=
 =?us-ascii?Q?Bjpa//F6eTremu9wdhKSw4zFj7JtfTVzjK0AC0SIjCvls2+LYGay1/ezjF2H?=
 =?us-ascii?Q?fnohJ7sv+rTLrZTocss6Ol69g0SkBxA7tN9x0Iti8mp7gWz43CyrzWc44x+S?=
 =?us-ascii?Q?yMroUkDkwUITXAlC+ZzJpxQP8E1oSUPH1k1i0V8j0vcRCa1wGX4wv+vrkacy?=
 =?us-ascii?Q?GhaidJOPmsSGQwNxuIbkLq02DoV0JJbHmoxSSCA8YRM/cewqpBR5nXALMr8E?=
 =?us-ascii?Q?LxKGaVmmNPYEZDj3zwPELytj5LzWCeCmpRN/oA1mS/TlCETDl0UR4HaO1Tbt?=
 =?us-ascii?Q?ATeSY2kxvoFjVJHhiLs7UW0mifHykIa2w6uo2vtC3hP+q5jz1aPhCxZi/7gE?=
 =?us-ascii?Q?d0YihR7CwzIJ78yww10JJGMzdGtkUguK/ONcVVtLzG4SO0mtAQBRgmSD3dwU?=
 =?us-ascii?Q?37gB1yEmMoqO5KXmy0okur6XpoB2gT29fM8nDzT3NGqEvIPvn2r/zwNH7DDb?=
 =?us-ascii?Q?C0OQyBnv9C9F38+2oO8oiBduz4oS3hki/Afgg95u8dWY7wB2a7ozKv3ofA3K?=
 =?us-ascii?Q?ia6xmBN415OSOdUMOzU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gbyHGFasGtwnoGWPBCKV+wocZSWsl1IgVg1EIl/aw8pLZp0g/1aRAjEmUF+Z?=
 =?us-ascii?Q?euKl/jOnV+5BPvrrK+Hp+78UBFTq+thgEsZHsxHKEzPtZehGiB9YUMH/Fzw8?=
 =?us-ascii?Q?lb/Q7Xe8OSioX317OxI/XP91+A86Dmqz3kjLdeQVW78LpI0hCK7FETur+Swq?=
 =?us-ascii?Q?TVnrVHnBX9+UtZ/N2XK8n82KB4avlxPKakIuu+XQwaxho48gMkS7dkg09a7g?=
 =?us-ascii?Q?rn4PDA9HpNVeIJIMwMHiM9L208LBrgA4RQDZcjlvSJQCLqWOk0MjeKvBDsgY?=
 =?us-ascii?Q?QTl+WMUilZD2l9ObFWA9QWCUW5Zp7hZw4brhCdvFJAIM7jLP9Hr5sYsUDKh6?=
 =?us-ascii?Q?jLYz/fG/DAzwtDMOYIxJOaFZQRt9wPASYEZsqIfzZAd4fmi5LU0Ba7M49vhu?=
 =?us-ascii?Q?GdzJK0UoRM+mZXwrRtE5EOqW/OJZ4kHIgzb2aiMjoRdtoHcwY8YbHWsZX9o+?=
 =?us-ascii?Q?7pU8YLn2Opwhftd7zsdS3Grs3F1fBI+YMmgyp9u0c3Hdr0GLaODdeF05M+91?=
 =?us-ascii?Q?+6+UyfCJCYqAQE1crzDp99xPfDxxDRN0Xcu/AqxfIKy2Y0hZq2fmPxJOHs7M?=
 =?us-ascii?Q?jjlEuSkK2lLLIssGm6HoLSuOFuwEWlVMYcpH7X1E8U2x695GILZNtl/w4Vmf?=
 =?us-ascii?Q?cBAIaGZMJcBI2iGzr1K418cGbonerHTeRDKQNiU26b1qy7yYeFh5yykA0awa?=
 =?us-ascii?Q?D0osnbsS85Z8YlGIN2etKvXWaZCtstI7i+M0mNsssxLX+IvBPGKGwGQEYCgK?=
 =?us-ascii?Q?3ucFql3w3n0/nSBX/qEFxrmHdBEDMdYqdCBF2xgf/66zg7eIWYN+0m9eKxzk?=
 =?us-ascii?Q?r/JMTuxjZZSFyfn5Da9d21AeqmMDQH6vGdgl6NwfBwjT3fX6WHo1lWPxGBNP?=
 =?us-ascii?Q?nXp4RXTnsH+SSOhjCKJRlPow+gLvzqTqayVMzJMc5ZZ882mNr4IFdWODDykr?=
 =?us-ascii?Q?VCYvmkFaI2LZB8skyXqlVJ/SUOkYZBeH4rcb1opkKBrK6tRxflw2KYcCF1Xq?=
 =?us-ascii?Q?OSudO4yc11LrXbPSFUKJIBBGwMK+feVyEu1tyXL04unbOk2PNPY8IxgTS7a5?=
 =?us-ascii?Q?de2DGk3aQlNd7cS/Y47+RAnXysDyU6XOWACs1VT7tANxAIBMyw7Sh6b6hxiq?=
 =?us-ascii?Q?NIRi6icBYjXTldlFWKyv/qikeVyRnxzYjpOImM+gQDe3x91SMr58IlCNURSz?=
 =?us-ascii?Q?ZvclDRwBYoFEzMbcO2Ng2HQ+btVNIsIaccpIpUy8ImWg87f2biOCGm6eh0/N?=
 =?us-ascii?Q?k+kz+6MVhV/7ZVCkg3MeW+BosQYRYE4Ajf4SDGNnaBhU8qMRcXJMZ2ZhxCY2?=
 =?us-ascii?Q?2HYqHme3CTV5DO4QBpkRqnLDE3PPiAID+jXgzlVGDL3S0QhEn5n3Kd+GX8gr?=
 =?us-ascii?Q?FeR77ZWA+JhcyDOS2F2TjYnXMmrdnauqKz+KvQpDduC5bTXHuENdZqtNNhJe?=
 =?us-ascii?Q?obHEn0T6zc74W84vbpLKEd4SuzQUZP8aAem6a5qYSDEhO6ixadSzNN+3bInz?=
 =?us-ascii?Q?EJbyx2lq7OYYb6HTau4m8jbxt0zZnphqHj+Trs5fOSxC6cmPMvJ78dQ1Qwbl?=
 =?us-ascii?Q?h0u9xxnefperg8EjeHzGGdFOPEpaNbAaa6q9/y8WNxQZ179zqmsDTSMDTogV?=
 =?us-ascii?Q?6+Wpgj7EJFjlc9+zmsVtueBRiIzBzq3pdyzl2dvYz5mv47F2WqY2+Aji/lrB?=
 =?us-ascii?Q?3cHADyMyJoqsn+KPJLhI/XnnZhoUlFx/6LTYAIJtz/1euKt2UXXZUhg3KILp?=
 =?us-ascii?Q?v8ekDOm+glt8fgYT5YImXmK0g8HJRoE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GH45gXZiy5UXlzpz7dOfJn9xjdYjA1zBPH1R/qcLvblRigRzGOYmtDxvwLn4esOpCf4P7jMArIcv1MGRlPktosiGflgdVfR9F2ZXlTYMLt3liSy9V0IjChGyvdLx3UITuGjJiDyig5Kf7Mm+u+ZmiRX/ki+v9OO5mmTQx540jNl5qw3HIBKV8aFrY3QEGbzTBwFgZgHXAeOYdTLXGyZmWzE2ZUmXOax4iuyzGWdJXqL11LSigVkafrMQJiHVyomRfwGY/bh6LwR6cq/VKrr0sO1Q0Glru4j9a6gtM9bwlv3+1WTVey7jVNECwwEo/vnB+glJFXx3FdF7SMnnpI6n00Z9E3S4znjbwZ7EjWTRcPhg9nhvgEJbwQYVI+MNJ/6szahPV+3XDFlxqRpwsI+km2f8UdoHQUt8scIwNwclRSjpHLpEF6pfp59ffnZUs6is9PBGzBgnbRA/R+0vbxVYewOSHpzaG/xgHCilV38LLXgSbntdjm0P90KfQ2+l78hjy2BKRCqc6KuYtCJzeNlKR1NGE++XwLzUno2pOPLK0h8l+BiGMyZtc4wx5wCaBbEhbbpFDoTOc8+6lCYHMjXcJnoBkq+7wnYKV5DVsvQkZyI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 184a826e-90b3-4a88-39fa-08de59b4d7d8
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 12:50:38.5541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vtkcVrz+KQWBu3Cep4JOcWWUd0dZbdgaMYG8O5VdM5WgKlLHlJenuzVG2WMcuGh5vYG9nSlkjnqekNxF5ytu01HH27CwtllbKWRx1OoaMTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220095
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=69721d22 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=nIt71nLUYc_4VLb9du8A:9
X-Proofpoint-GUID: E9tLX0JN06VmVQHX3OJwfXEPTxRum-3-
X-Proofpoint-ORIG-GUID: E9tLX0JN06VmVQHX3OJwfXEPTxRum-3-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX+C5fq4YoZQS+
 Uu1hZkUIHa9KECXCQxzrUTSAzGCrvwbOstqYosarSMnJ5wDORry6x7hV6+UJR1gSNefWxif1rv1
 +oBuam7SpT+K8VflQObzebqVCnvoSn3ywBW9IdcCF9Rosw4J3TbpZxfEaRxA3KjZ7SV4NT61iCJ
 1+oR+s83mIJDtAYaex7OezXeR9K6niKL3UCpPtc8bA6FNdqzhnVx0n4XRo822GH/GcJ2GgCYJrj
 cw6n5v0DXullQIFF6E1GIQ+KAq+wyIWlpSx4yi9p/Go3Pl/sfISmf2luoaVMII7/7AHhBKEl3eI
 WSLhY9ZfoxHoQAbfOlnezeNj0yjG+D4X7ccJAWclyFsBYF5JvhSLWMiLd+FSU67KgHoaoBOXM4c
 E0PiyFDNFwsDqg2ZxKzJT/RcpFR9EJs/awGD1mmkDc2ZGmICN4WQp8PRr+yfBf8kAn/5v55IV9X
 HXjclsY/CHgfyTgmchQ==
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 22B3F180007
X-Stat-Signature: wuz546udhsqr7iqrdntyk5me6nbf4adc
X-HE-Tag: 1769086253-202829
X-HE-Meta: U2FsdGVkX199+PU9wt6APXgww5r6PGdOdwXOZr6rdgBKd9O0oQdUd20cDjRGJgx8HQVpwjlRIO1vxkxeSw2UHdsG3FUlajIorM8cLBBjJV/Gc1SaOqV7qP6VktFGuGa2M+8grAJOrv2JTmhJg2ygCTrCHALgzmuFkzQcBaJsm988wjkpP7kXEjEGmAjV6U2+tkds/KzB9FxUSxoYseRGRZyDRkx77z0GUqXjcPWhewSX0RIBgOFwP0rhsjf+b/QGotReat7a/ykRrr07Is3vCET395gS1p4gfU6aaeaZfBnKGXX39CZ3uxtkEVTPM2kzdX0E/KjOYcE+yHe2Y6g9KTAsaWgI5SnoxAljWWZgT5pc2mmbP7cCmt9ROvBgctmKTHXRzOdc1Bop/efVIWiUvOfWJAN/C/8yZqUZnHijKfdrd2Ts0fYBHF8rEOR69NIJLZgRXCMWaRfBLLI9rKs405P3GuFxvDxY9rqlQCTuyQajOvOmykFLasOQbi6r/FAZg91AQHxLfUiqw58dz9myqY2egubl+vsHAqRs6NlB+IBts/dOkz2JvfC1djhQ95s0zqlX0wPZKjgYkfq6LLFBjLGbLMs43IkthnLiOpVFxQkA75MF+mUyZ722gYKI0EHGEkCogrxrhFEkC0c2UZkdceu0AGDwrFRyklbmGqj3TVE9o/u1bebRVzkTSuJuQmT93iGyRdzDAPsXZelDqENr0I5+L541i5qjJr5Yl2XEBEzCLVrCOnExavy9v6aRkxlYrggyWkQSK0DfQmmH7YJnvEAAGQGXPUx1E6J4JTRDLE3SopDMJ9BDIDI2UPSXWTCVABCTESWi1SqCPn3plcr/L4KCkebD9NfDpCm7qFNo3k5I3IkfuHAocLtqdbUDou46cwxPMYn+HCwDIyV7VN6Qb7J+3DyIe7n+Xg1Zgia/MlJYPdxxykuAwn0P0Z0pWjnIs17077yWG5bwo9CDNdM
 qzSeLVyv
 yexAikRF3jVFKN0qeL7COiVmrzEb2Ot89eB72d3Zx+L9+H+Z1VvawEUOsYum/aSZpPzS1kHV40mFyFb8dOlYc22bI8ABoKu89x9g9iiP7fqlV09neBkxHtKLhdTEuLWwXq1AgDJEheJqWI2GYal2zM+qgbsXHirnYNqtfPpVLXyyG44CVkmjq1CFjSZaN4Qsmcpnp58I/dtzybKXYvCSxxvu4hEEwwx4X8V6cmFqMhebU9jCeM1sNdFYUQvDkyn6Ba4EsEp8Ub6P7FEauOV5TTcMRWAlGjFkEH0U2KCEaLCOulA2dbNLFQ7fdVKz73TYGRAcR7cjn2ErfF1JKbTrDufCCd/cSioNV9Anlx008G5IwKvel91RRuvI6EnOZ8oD6mby07+Kh60qERoUu2L1tvjAF59QigJghIAYSaXfFbWCmf/Xl6wyTNYrZSJ3I5qs9EH5AedyowZjeNSYZFTWKqRvnVOR56CO7POOojABm9qWYkJKFSOT3MOZ77qNZrSctkp6/IfCNC5dhMimFnriT/yHrATLkVbEIXsvwyMDuEaNxjeCKSTLX2QddcgXUpUZbG01CRp9eay9MeYic2yzsZROkjss3+jQvU7elSGwOVayoa92/6smaAR+IswB3Zcehi++Fw8PySMrMq5uPJ3R37w6DKpaIJV8lkvsyWPmP4UbMgVqaTHruKKHeuI9InJ6D97J9p/hZM1eaNJ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The code is littered with inscrutable and duplicative lockdep incantations,
replace these with defines which explain what is going on and add
commentary to explain what we're doing.

If lockdep is disabled these become no-ops. We must use defines so _RET_IP_
remains meaningful.

These are self-documenting and aid readability of the code.

Additionally, instead of using the confusing rwsem_*() form for something
that is emphatically not an rwsem, we instead explicitly use
lock_[acquired, release]_shared/exclusive() lockdep invocations since we
are doing something rather custom here and these make more sense to use.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 35 ++++++++++++++++++++++++++++++++---
 mm/mmap_lock.c            | 10 +++++-----
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 0b3614aadbb4..da63b1be6ec0 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -78,6 +78,36 @@ static inline void mmap_assert_write_locked(const struct mm_struct *mm)
 
 #ifdef CONFIG_PER_VMA_LOCK
 
+/*
+ * VMA locks do not behave like most ordinary locks found in the kernel, so we
+ * cannot quite have full lockdep tracking in the way we would ideally prefer.
+ *
+ * Read locks act as shared locks which exclude an exclusive lock being
+ * taken. We therefore mark these accordingly on read lock acquire/release.
+ *
+ * Write locks are acquired exclusively per-VMA, but released in a shared
+ * fashion, that is upon vma_end_write_all(), we update the mmap's seqcount such
+ * that write lock is de-acquired.
+ *
+ * We therefore cannot track write locks per-VMA, nor do we try. Mitigating this
+ * is the fact that, of course, we do lockdep-track the mmap lock rwsem.
+ *
+ * We do, however, want to indicate that during either acquisition of a VMA
+ * write lock or detachment of a VMA that we require the lock held be exclusive,
+ * so we utilise lockdep to do so.
+ */
+#define __vma_lockdep_acquire_read(vma) \
+	lock_acquire_shared(&vma->vmlock_dep_map, 0, 1, NULL, _RET_IP_)
+#define __vma_lockdep_release_read(vma) \
+	lock_release(&vma->vmlock_dep_map, _RET_IP_)
+#define __vma_lockdep_acquire_exclusive(vma) \
+	lock_acquire_exclusive(&vma->vmlock_dep_map, 0, 0, NULL, _RET_IP_)
+#define __vma_lockdep_release_exclusive(vma) \
+	lock_release(&vma->vmlock_dep_map, _RET_IP_)
+/* Only meaningful if CONFIG_LOCK_STAT is defined. */
+#define __vma_lockdep_stat_mark_acquired(vma) \
+	lock_acquired(&vma->vmlock_dep_map, _RET_IP_)
+
 static inline void mm_lock_seqcount_init(struct mm_struct *mm)
 {
 	seqcount_init(&mm->mm_lock_seq);
@@ -176,8 +206,7 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
 	int refcnt;
 	bool detached;
 
-	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
-
+	__vma_lockdep_release_read(vma);
 	detached = __vma_refcount_put(vma, &refcnt);
 	/*
 	 * __vma_enter_locked() may be sleeping waiting for readers to drop
@@ -203,7 +232,7 @@ static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int
 							      VM_REFCNT_LIMIT)))
 		return false;
 
-	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
+	__vma_lockdep_acquire_read(vma);
 	return true;
 }
 
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index ebacb57e5f16..9563bfb051f4 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -72,7 +72,7 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
 		return 0;
 
-	rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
+	__vma_lockdep_acquire_exclusive(vma);
 	err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
@@ -85,10 +85,10 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 			WARN_ON_ONCE(!detaching);
 			err = 0;
 		}
-		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
+		__vma_lockdep_release_exclusive(vma);
 		return err;
 	}
-	lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
+	__vma_lockdep_stat_mark_acquired(vma);
 
 	return 1;
 }
@@ -97,7 +97,7 @@ static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
 {
 	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
 					  &vma->vm_refcnt);
-	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
+	__vma_lockdep_release_exclusive(vma);
 }
 
 int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
@@ -199,7 +199,7 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 		goto err;
 	}
 
-	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
+	__vma_lockdep_acquire_read(vma);
 
 	if (unlikely(vma->vm_mm != mm))
 		goto err_unstable;
-- 
2.52.0


