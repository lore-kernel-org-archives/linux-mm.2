Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BECB8D47CD3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8C66B0089; Fri, 16 Jan 2026 05:46:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D595E6B008A; Fri, 16 Jan 2026 05:46:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6C56B008C; Fri, 16 Jan 2026 05:46:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF3E36B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:46:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6338359ABA
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:46:21 +0000 (UTC)
X-FDA: 84337497762.29.41DA345
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 21BCC140007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:46:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HOGmUG4J;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ECePz3lI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768560378; a=rsa-sha256;
	cv=pass;
	b=kYLFn75/f7yZJiPYZ1A21fl7bJh5HaVbVKcZjCHucUrBaGVrDe9cSPOsrccMDFZoD31MVI
	raDZOu/aoaONCNR9vpLlGyEXBxHZPczEMavFWnv+nTaCNNTa2QZNrpIzdopBnv804G4W1n
	TANB/3wBwM0rRvZJA2mgJYw2OcOunQE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HOGmUG4J;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ECePz3lI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768560378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aivDbXmNjCxLY0CnCU6uAbUW45Rc7SeM9klTe9bIMa8=;
	b=S9eOGbJIugdbHyxI/fY/zXSuSTtXQCspvGyLaq8bRo6kvmx80THx7gEnFYJweqFXxQYnZO
	xT/Xz5Rc28YL+TFuUk48vK2goMYtxDZS0IOL1yUhQtZPi9reUf/wfQFaY2a4e3sUFoXJhe
	T++QybHbr0p9SQypgYdSC1D0yoIv77g=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60G402xT2251198;
	Fri, 16 Jan 2026 10:46:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=aivDbXmNjCxLY0CnCU
	6uAbUW45Rc7SeM9klTe9bIMa8=; b=HOGmUG4JkrtzCsarouARQERMuMInlfSmSS
	x94+jdO91NNBmHq8hYDz0jEDXCGLYgjLSHDSl9LQ9+iRYydSk2Z9bdOu+K/5F8DV
	xNr6cHR0+WvjBeqnMimqHsc3niCF/7OMPFH66Zr7Q7eZ7/PhiZkzx706rOV3P4md
	y6Q2IIDg/7IkdACheTty4k3fkohJT0HjcUdHLUh+QH4HUBLAHh0LdCxFUmuQK6JQ
	UZFH2fqSzNAbmUsl14GTgI2DQ5eujqOCwpPf25TccfWzOX5jaqWMcLiCzqw/35c6
	sXTgHHf04m/X8JouXX2c+4RIN1m8nVQtOHSJEC3M4rMIZz5Sxxtw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgsrf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 10:46:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GA1D8N029164;
	Fri, 16 Jan 2026 10:46:11 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011011.outbound.protection.outlook.com [40.107.208.11])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7phmfb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 10:46:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U19SG8bMvIDaS37h2MjHYXAWGcFuLhb0Am9swJkN6e3/thp/GC8WUMc+TDgou4u1DurQDWNwS0qoUUGzx7uKxBR/GqqFGjsW2aCW8K1o7YDEgNHdzCd4xY41aJIlY9BEdpdS1H72bBoPBv3XwUwm8cLpbgbXovTwffqxh/rKupth0Xb/klJvHnEQ98Oqv4Al15XGbapU0YiQLA4kOVPz1nev/xGVlVAPF/ARc68EWbeevv5ljY70YVbb1uZV7HjD19XHNeSbsMzoHDavHkfR/6yUJlO0DxPSIDw0G65KY0nuk9p2xjerGJY3Ca4713auFM87OzRzqbaxXyB9SC/MKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aivDbXmNjCxLY0CnCU6uAbUW45Rc7SeM9klTe9bIMa8=;
 b=K0aJQhHUCY6u1DkXbGcm9qFjhAhLv/IcipozgCap7yQsAu1cnxZfJ9aAZ/oQR01YCCyxtNr9H1841rA0oy6o6IlnOnJdwSE9SMTMTW2Uuwb5LixYCj2mtfVfe2qVq+4dWIwffLfKk3vsTePMS7mA8ULBNSnwHbfHD6oUTGfg4WEN/k9gGOCC24vrawcGaIFmUl852vcbBmXVEvds3+myBaZnlgacLpR7Vn7b4/KW5xhy+p4qNvfHrblIzxcv9x0ddfJ9EbtuybXquM4Au2kf87NbrWze9wr8YBFJtIWBc5CjYPZ46RhEu4ZY4UfhuuxY0t7EIPWl9EbjkQGg7obZPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aivDbXmNjCxLY0CnCU6uAbUW45Rc7SeM9klTe9bIMa8=;
 b=ECePz3lIMP476l320WuBXpNAZ2be6K4baED6ecgtlzz4PYoxBOLuOQ5kfu8kalO5lVSYxZI5JtLUNb0Emuk7HCJRH4KFSarqs55eH5+HybhZlbTldX6LBrV/vTsdPseaGRwjhrsfIRs+YmN4i7PE6UwYVFCuUR6iO6nq656va4c=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SJ0PR10MB5765.namprd10.prod.outlook.com (2603:10b6:a03:3ed::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 10:46:08 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 10:46:08 +0000
Date: Fri, 16 Jan 2026 10:46:09 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] add and use vma_assert_stabilised() helper
Message-ID: <ab3b1b0e-8add-482a-b0bb-728d28033eac@lucifer.local>
References: <cover.1768558900.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768558900.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO2P265CA0482.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::7) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SJ0PR10MB5765:EE_
X-MS-Office365-Filtering-Correlation-Id: b118c08b-ece9-4d1a-ad3c-08de54ec74a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B3sFaKXKNO+FvgITjbUYIrU97kUSKKNJSeySoz8pzmTiEbUpBq40GGR549tC?=
 =?us-ascii?Q?d/bE05yL2t6RT8qgzF35F+ERgZAiWudMicU69dRbF7uIG8UhJNPhG/OZRHFk?=
 =?us-ascii?Q?Rh04YiAfcbxwfKXj2VjVGYK/bFfeCJ5W/q1M39RxzxNqv0Mx0V43Fg9JuggU?=
 =?us-ascii?Q?2Z8f78GgAF+WPVihke1dNsFdVEHhkGi6VCFbHlmob2iO7ySqzoeFpiYD1J+C?=
 =?us-ascii?Q?W1S77LlI9rUkcGnZPnSNs79nex4BRwOltesrp39siPdcxfMzoCq/fFbB5QkX?=
 =?us-ascii?Q?2jSXINbDv50/CptppUQIpIifwjjwLtHr/YMljJY3TVdaGvqQPpqqPCdPNWqA?=
 =?us-ascii?Q?NdqNh+e44yiYziA0Xrzg5vlj+RM2VbfRGFKo0Ir2T+bdQailGsnMMwWlarof?=
 =?us-ascii?Q?NH89EtECriwsO+5OP8Fu9cHFHJOetltgc1EJ0iIbwv7Oa4ImxzFOYv81H68Z?=
 =?us-ascii?Q?dUL9FMXKIct9YynpR5eqTnqAVg2CTZrFROjN2HPQyZNeriKLcl8EEe2Rntjc?=
 =?us-ascii?Q?4R5iwGDnKTIBLw7HvZLFDhbuqhQGrzClcrVcWfg4DPkND212WKbvg8P58Ysc?=
 =?us-ascii?Q?bYQMnn+R/8QIFG8qbL6M7AhqttJHAA0kuxUwJWGQTuhqYVEUWUof/yZQHp8H?=
 =?us-ascii?Q?VbQAbIJh06f0xyXKp6/N4ztknAZPAvLsEaNzld5Ir9dhW9BW403MbFqUjcR/?=
 =?us-ascii?Q?VQgCPl4ICH1MZdB+ZCT5RHL8sIY5h8SkrSfEq0tc5H3rjoSK0tLF7IDQiCRo?=
 =?us-ascii?Q?eIeFuFksauKqSV8M8sp7k9t7/vtaLzsizumEgKESAkMtIyS4POeCsFibUxis?=
 =?us-ascii?Q?iPR78Ns4FQbe7H0PxIwJXkoDENiZL7Hf2vaqWmscwipaulGalYgqKS39wrvf?=
 =?us-ascii?Q?yQBrVhTy8BniB1C0f9T45Agdw9O0flfbTa6evM8Ilfg4Ueyru9SEMsMZROs0?=
 =?us-ascii?Q?FM7/DsP4s/oAyag+hr1XXmqOWZ0/c13tLEeDiC5vCAdhjdsLIBjbVmTQmBK/?=
 =?us-ascii?Q?JmZGjtu+D2P6sRMf1uhhNf7V2A+NxROaIW1jpRXiucJotQLnPKTDAs0uXBc9?=
 =?us-ascii?Q?LfBwNtY9AByGEGHc9uTk7GsZjQ7nj3Fir9ubkcIouUwyIGl+/yLA9T1sQYoD?=
 =?us-ascii?Q?3VgzbZ4uhFj4bMCt2N1zVajlqJLYtd9TJ8fdn8cbqRazi18RpwJREEMyOMcM?=
 =?us-ascii?Q?Ct07F1xo0BMMg5/CJ8gsanVNarZr4eeC0NI4WYNSKc0Sxv1G/mHPyW9RtKs2?=
 =?us-ascii?Q?ltO3lwfBAEDJQxXjWVLn9bK3O3ZoMm47M0Re7o0rKlCstklRtjVIc4lqBoXM?=
 =?us-ascii?Q?/1wITYlMpGzQvfSYKLubwFgQTsTrA+TRZt6DsQCyHahmgI5xKsAZfJMJbkTJ?=
 =?us-ascii?Q?fNhylS2MM4ZhkWehOeUKQv+gjzLwm1XNX3wrI/N92y4/uk6z52nMFLjZSBGF?=
 =?us-ascii?Q?qgBa5bmNoKe1btScxYlDvoR8NTm73HMPjfZ0X+8Vgp82gnzkCdPWNaGTo4gF?=
 =?us-ascii?Q?mgBnb2lCJBnpvj5yS74+rENpNy4Aexy3gPltlZbWVAqdIfQLkuyW6IDpm4ud?=
 =?us-ascii?Q?jqDI6GbLguFx6QveVDY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3oDCLz50N/IzxroQKPH9PiD1EvbfPU9qgakTZhQAs58y46XCb5brZjBDJZiE?=
 =?us-ascii?Q?ODz+VNbE6MrtUxzBGUHvfZ04RJjEgWDj04G/v+JZ0Oyiv9NQj0uE8g3L4rtP?=
 =?us-ascii?Q?hnU36FYqyRLFBuxbmANxfWE+ZqqrRRWyzDZ78PQ3VYEtXa8FgNFZHmnru48S?=
 =?us-ascii?Q?meRN2AHyN+9QZbYLshj4ezgEyFeDMX6qnwchPl5VSZpxv0R8uLaEw7b0a0O3?=
 =?us-ascii?Q?TVF2PBEyiXhWFw8a6Ke7yoIFgZ2cFDHtuPB+UjwVlbt0pvkPZQj0jt5xrt5O?=
 =?us-ascii?Q?9hw8Cg0JURvwQHQ8ZckmI3/wKvqL/U7ND8u0LDGWmUsYK5JY5SmvAvpII7J9?=
 =?us-ascii?Q?3w0pPXni8wQh1T1l16HlefeKPwT7KBp91F3yfVq+sWZN501OwQ0UzO4M1106?=
 =?us-ascii?Q?bO4GwYZ03hLQDYAZ5gI7tWlrecdz0zWhjOtSCdki3TtpytplQyUwIPt5RCzX?=
 =?us-ascii?Q?NA35gGge+LNeKtXx6OUuAld14ZeEyRfV2KsrSB54j4VO7aIVdYH3uzNEUHlV?=
 =?us-ascii?Q?Fem3OfzRObeYyf9ecpTGqSPiLN7Km0CckR70d8vq5r5Afn+zQt4slBXn4RP2?=
 =?us-ascii?Q?f7yHECK9lUGYtaEARD18oUyxTd+EgNuxI3nQBkq+piI6/o6PsshGEGzmIET3?=
 =?us-ascii?Q?OQ1Q/ckC1czeUK+z1J431UvMZXoBUayCgAm0wMup/rEw0iumFumw/HZI0KCw?=
 =?us-ascii?Q?Cx1qf9RwMyYRK0WZM7Z4HloC5rs+bG7GNRq4dT/xSJjkHxWP3PjFdHmlL7aM?=
 =?us-ascii?Q?UKLpZJ9PdeCLtl4pdE+6AtF6Vzt220AFt+2YINxdfOsNbSIrl9Gkk+XjXmYe?=
 =?us-ascii?Q?oANbVJEgOLj75asVEx3IHErO4D4tTJnjuE7EP3ue5i+YQHWn3D7iVI1P75Ok?=
 =?us-ascii?Q?OZDg0iI0+xGUdPcyx70aBI37yRPMzPYh8jpBtLZWaOBd2D1q2Th7cg8s9Nlv?=
 =?us-ascii?Q?zvQ2jC5EyH1gbQ3w6aucOmAhZNGpqF+g9fQYb3Zot4pVGhsmUrP9vwUM1SO0?=
 =?us-ascii?Q?NY30poQivrfdWvdc9eN6uCljRHvu4zXlpGHR7ibPfqzIZ5y3eB+MZ8ksms1N?=
 =?us-ascii?Q?pALVRi186vsmIFsLImL23OEhilfJp9Jed0xip8rdERKdgKg0+QJoYIs9qa4d?=
 =?us-ascii?Q?14tdpeFNWLqF+9MkXPTyhYZaoIjHSNwyfYlk5CDUk4+Bw011qqirssh29c8s?=
 =?us-ascii?Q?iZ9a0hOzSuYkONilZCNTHU59f+3vqWRaS8mImoroRUPl6ZioPG+A5vq8Ne3n?=
 =?us-ascii?Q?+AozGeVa7eNlr74CNcUMcmS6B3LvUD1t5jI4zT9fDvI2h1tq6QnjiIBjxrEP?=
 =?us-ascii?Q?mOAnDNce0iJn6fbxuZPIWSdFu6HEcwoAsEjxuh7xUm4k9zHst6qlU+V63TrH?=
 =?us-ascii?Q?pUmeSljvvO9LSF1KiBRuPfHoALzCk5hCAKWIUmii/YOUXZjFCo1vmYLi7S8U?=
 =?us-ascii?Q?UODAwTc5UCGSDDP5OXZ6+sl4YDwASsDr9X3eOnioFgGvGSUc9cGpw/MQ+W+k?=
 =?us-ascii?Q?apcHWEk1OOv3b/S/H16mFMLXwqa5ZPpST1/1wT1+2f5Y94p0eSKJGfSbyVKX?=
 =?us-ascii?Q?y9zUd19yE7YShBQWfquTh/vU3owfmwlIAQhwB9VW00CgKcuqDX/YPoB0AiH9?=
 =?us-ascii?Q?EzRJxbHVnNlBcdwS5v3sqw/V6zk+ed2LTZTuBxNERiX2CkFjc8CsUhWBsnnd?=
 =?us-ascii?Q?A5pFNy+lgYtbVFBm9phObzMO1xuv49YgESiBYX/KJVW5/R51JSzj/3Rzsuqb?=
 =?us-ascii?Q?nyMU0hEgYREq84K0QeXN02clsAplkpA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ooUCTdFCb3WPeYI9jhyL2q3hMk7WSHeIzynEZCvNzn/9kLRdhczDz9rr649ySCafS9YQoFwZx4ImDcSyvfGR1jwGAiiH7sLg6gXxE1q/uhwPBZWilk9pnKddln8IoiLKOeMWscH6MnE2MbC7vVwagO7BSrk2XkhXcaFQ+EYwJBbZNJ5cjnvhdNuc/w8Tmn5qla7aNFTEEXtgPDKRsNw/MQti3p30Ykl+XHB3Q/VvmiEn+NNKthF54sQvW5zlr3lnOuoGm5LXN3cvnNnZ2ooKxLy/W+0Nt/csp0AEpHBKe2wqdrB1kzk9cFnDjkyDkBjJgpMmIJIeixh0ISpxPlt4+nkij2D3rTiqlUKwcFKgLhaSreC81ZQh7nLwx7naRiqMJJFFchd4Vsajn9C6KgrseKBDvalDE9sIoFRITuHEQZ4ygCITVJ4zr1fskI8tnSOYMezKrfiW6Z0L9gEBn9p54ZtL4eotX15HuWa8vB8NG7wqZsHsJQYsRaEmFKG+IFAT8Dx23p4p7fOpaL+LOe7S1JCk+1a6hU4NVH98WKS6ogwvuhZnfIaXoBWV/+7N+UP9+LpQmoam4cihkSuGPblpXTkXsM+6pNxs9I9Nn0cN+qw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b118c08b-ece9-4d1a-ad3c-08de54ec74a7
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 10:46:08.0282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gNELWIgHmpNVpZ0Kx9eay9JZy3zsPEBQoJUOc/GOUOYHZEgpWGuL0V2+Jz4i/UNXqbsnNg9+ksLGi/YBF4myzNPy+CrurbHgXwPjw6frqV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=760 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160079
X-Proofpoint-GUID: r8pnu3Ibk0b_0g-BDY-A5oJNyWaKBOBt
X-Proofpoint-ORIG-GUID: r8pnu3Ibk0b_0g-BDY-A5oJNyWaKBOBt
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=696a16f5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=_Rhai4V7laVccOtZnXEA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA4MCBTYWx0ZWRfXxsUTurOsE0zW
 P0898aPPlXsNtC+RWThAL6gJvrfHu+n37V3p0ALIQ0d4nubBUrAWBViHwNNkAR2G4YTwdcTUYuu
 kXbxXhawTNbkWd2tz3S59qRwGifGZzXZjK+Z1Bno8rAPw4ZcOwKmYe2cheXUMY+/6QTI6YafTpF
 fTU4fNVd3P4nTJSRIjA862TWxNoqtFpWg2rwrrGf9IKZ3QbBeFwOAowjuHfQ0iLEiR/YbwbRctx
 QvVyfoSlewpvfrgeOU9sL7ijL932Ey7Zcwe+wayTi/2CdsxBLeU1Z1wH66yE/LQcqyEYXVImOpj
 9Sx7p41Bkm7qTrf6p4ej5nmw9gZ7xaK1WnWdskiiZfxbrqFXyGGsAct5H5TJrUDXgHEhZdL5ke7
 b+sVLKQ3QHyNV9MWHEmJ2xmJX1glDB66QPXik7HFPXN9ogSzIaM7HTzLcRVfBPIOS7CbLyc/ZNu
 5IZGq1q6WfX0xo7718+XmLT8oANlwLuSInrZTZUQ=
X-Rspam-User: 
X-Stat-Signature: i3ezcajpa3e6phhyrjzyss7nr96p8aw4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 21BCC140007
X-HE-Tag: 1768560377-204064
X-HE-Meta: U2FsdGVkX1/st/akLdwPygU8iMmrWJF5AOEfgLsLI00hHZeAfU8jDTPb24KhRtREmiCzn9g8qZ0qpMsYcRCD1L7PXfH8l6ZQAHQ2DhqQzyvVzWxoSiqQNDP+vy+sVLmzAC4V9GF9F7kNwcFsiy/KdFjjJhYgD3fF785MvATFSUSJvv+sEzPzlvXAs2RWE0vxiPSfGxJhR7QKBMPj/kNT5/bo0jP81hIREjKH02VpYe78Y0XLGcQpZ+idk5NR0KI1dsB1I05qbRtGhOsLW0w4P7TUNIzCHVFpzJ0Ec7qVgDbU2V6yV+oq47HXLnyMst6h3iqdTIF/LWGtBsY1rFDeO6Esi9PNR0dcgWp0i9E61eq4dWcc/6QkqTNUSvt4g6Kr90Nidd9CIJ9DzCnLWJ2beFHGT0qfjA9iCPXYrb99ADGhRDUPZC1JL9R7Op0H7h6hPqCFcwC/cF+VGRsK6sf+dV78V4mfoXcDiPHREy8V60PUdOnPZGIkOhP233/3QDNAH98IkjFirYmcAwPwatZfESMYSt0MA81kmfAEc2wpofRtfxYIRuhtIEE9KGMBiZ8AybnGj/AEEa6xD5MbYbkNmhwxX8ohuRodwmlR2WswYqCIX9hSZte1mLEL1rKVg/U93vGal8Sh+F3L19bVvksBCGeeJNUhkc0QeMyF5dfjLPRGcXsVkbJTa6NZEszTKnZ+KEOqcFVVD7VZIYn7xMAjZKWat6sLz3jfH2UFdTP1BEmY6pKW8go7Pl+Eu2EPsTMa8lKeutcQU4v7IC1E+HSwVxp3ltjmkYYBI/j1X5zH+1XepwcP49nRaG/tgQdHnz3T9B3Im3G69OyB0UcLPjYZPzYQtdSfTnpiep5HvjW9hevlP7etrMX88VQOVK7WjQ4SiYBfoiT5LWe5ON3/UskTIxdJXTWkfTAn0oxV+SHxatgXB9k6CorecE35m7OCHHu3Onn2hWhMxnOQTmKpWWW
 4TQQW7+O
 NaQr3aXELYv10LPEtuQiXbI5FJSU+uLlqlISIgh9DwJsOpusL3ezcVRSE7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK sorry to do the extremely annoying pattern of 'immediate resend' but... :)

I realised there's another silly issue here, I will have some caffeine, fix
up, and do a resend.

All - please disregard this series :>))

Cheers, Lorenzo


On Fri, Jan 16, 2026 at 10:27:46AM +0000, Lorenzo Stoakes wrote:
> Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
> be changed underneath us. This will be the case if EITHER the VMA lock or
> the mmap lock is held.
>
> We already open-code this in two places - anon_vma_name() in mm/madvise.c
> and vma_flag_set_atomic() in include/linux/mm.h.
>
> This series adds a number of pre-requisite predicates and adds
> vma_assert_stablisied() which can be used in these callsites instead.
>
> However the asserts implemented there subtly wrong - if CONFIG_PER_VMA_LOCK
> is not implemented and the mmap lock is not held, then we don't actually
> assert anything.
>
> Since this is an assert that only fires when CONFIG_DEBUG_VM is set and the
> test bots will largely be running with CONFIG_PER_VMA_LOCK set, this is
> likely in practice not a real-world issue.
>
> In any case, this series additionally fixes this issue.
>
> As part of this change we also reduce duplication of code in VMA lock
> asserts.
>
> This change also lays the foundation for future series to add this assert
> in further appropriate places to account for us now living in a world where
> a VMA may be stablised by either lock.
>
> Lorenzo Stoakes (2):
>   mm/vma: add vma_is_*_locked() helpers
>   mm: add + use vma_is_stabilised(), vma_assert_stabilised() helpers
>
>  include/linux/mm.h        |  4 +--
>  include/linux/mmap_lock.h | 55 +++++++++++++++++++++++++++++++++------
>  mm/madvise.c              |  4 +--
>  3 files changed, 49 insertions(+), 14 deletions(-)
>
> --
> 2.52.0

