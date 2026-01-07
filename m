Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E6CCF6BF2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D77C6B0096; Wed,  7 Jan 2026 02:21:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AEA26B0098; Wed,  7 Jan 2026 02:21:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CA26B0099; Wed,  7 Jan 2026 02:21:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 103736B0096
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:21:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2C25C08C6
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:21:01 +0000 (UTC)
X-FDA: 84304321122.05.6E5FE91
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5F892120005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:20:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KA0QfEvH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="D/OcX5+c";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767770458; a=rsa-sha256;
	cv=pass;
	b=dcPR5gg7yOnEjGdHtxhyG8egk6vaaoV1og5xzfyV20mwgHtrNhwvf8x+FLRhcTigL5NAP/
	g26Pc782R4u1+76+OiipurPvx7HLfubP2uv9+SLevJ03vMZIPVkkN2qiQz6CM3obifBamj
	wdijSEiF8vs6sLsHFYDzRAd2vIUYJaA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KA0QfEvH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="D/OcX5+c";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767770458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/Evb0mlSQmpt+BweN5HABblkEfv31PrvCEcVxJaFX0=;
	b=1a5Sb9Wg9LMMCNz/feVHT/7zm/exQcDwBMVzV6X/m4PEtI97rTl0hZlHX8sVJhVbwXrYxL
	YF08tdDQvt7v/U8t80OJSv9dwUvR3QCNjf5lNLyVA8Dpre+3O4wUjZ/pgyHQVa1y9nXJcF
	kEayVLb757ruN9L7H6ES0F/VDdKuhck=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6070YO1s798881;
	Wed, 7 Jan 2026 07:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=n/Evb0mlSQmpt+BweN5HABblkEfv31PrvCEcVxJaFX0=; b=
	KA0QfEvH6E4rJnye7vfRrtfv/cTcKFF6pvEH+QhR3kNxQNZcbZPI/PWrJruednZH
	FZasGs/Z5zlxf+IkItdlFJO5+GCXf7YVwO/0+agTITY/TPtfR8eAet0WS6bN1s34
	MKfN61LI7AD4DmydEmQO5x3kQ4LjEooGlSFH4wwZWvSNJTpQfSGiJH875sqHKVRG
	NIs91MpmPBdFTjbmKj1DDD3yvHGciV6gtdU9vFjx5qJwZMNtc+Ij1uwoS4BywdTl
	jPcurAXf1NMfT3QIXylrR3PSzoFM3YSf45xvwZrCEGXqoPi3aUrcukkHXBWuOS2A
	/72t3+kg1vDK7R+8v2NRhQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhc2frahn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60766KHN030734;
	Wed, 7 Jan 2026 07:20:33 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010071.outbound.protection.outlook.com [52.101.56.71])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjdj5yp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kc9WCV+lxI9E3bliW2ekF2po1hrBl2e2nZGR1UbSEy7h6JJynrIwA/82/SNLsbI5jriSXFv74VR+UvhLMy3x3J21MebqxTs1GRDxYK6nUOEtYvtVnJmMuC+dZ2cG0IAgmm0NLpr+n1Ru5dy5LabxHd2pYXgT/Cnl3g1tZVqUDNEKgKAVP2lUwrpRG7uLuTyINws8dYjoV9vhBtgvrfTgHJMlS/PxhhRq2KmeZ6FMZvDUWj9CBAHv7abMSK69U9pp/jnEVN3D2FNxpZOL4RyGK5viMHFnp+emLDQyZvEFrC0KALmAIx7O8wHywhau6ExiRUzEdoeIJu7gFXMEDBh6YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/Evb0mlSQmpt+BweN5HABblkEfv31PrvCEcVxJaFX0=;
 b=oFa/5QnhBIzTeoA3KMZ7BOOUj1WCXOTSDyrRqK6iJH/S6bESBlCFsXVBSFzTjxT1vJe8Ccwcm/GWEBkz5sn1HjjbBt3e/HTN+XdzeLq3Ed9UbICZyOFwdJrYMsnYQpf10juQiG4BE0N7ExkIQf61GU8sYCctoeyQmm2lK7lQp1s+mKNQhTeh7NGbZ2jLYgSBgVzpSIwLelhEw1hJWn01GqmV/JuT3tKZ+oQAJ59CqUNok/tXJNecjt6oDNDHM3wqy7lbXtHI94HYKXIERLQ5Kp4jzaYNOQ2bUAFOLfkyEoT/HPeP7KS7dlr9WXvqrwBQSHAHbjN8/sYeTv/p1zDbbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/Evb0mlSQmpt+BweN5HABblkEfv31PrvCEcVxJaFX0=;
 b=D/OcX5+cH/PMZLAwGc+ZPoSysJHVGeKb3ogQxO3Ma/qoDIlBYrVlloBvLr59VyeApG+GBUS2MmTzTUdk5f4oPok0jiJ2i56L6IS67JdE9HAXPSgq4iL1iiHXDRkYrORNxDbGUq88vsL3SGPSECJz4mnroD704ULNMFZBQDsPQFc=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by LV8PR10MB7750.namprd10.prod.outlook.com (2603:10b6:408:1ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 07:20:30 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 07:20:30 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v11 8/8] mm: folio_zero_user: cache neighbouring pages
Date: Tue,  6 Jan 2026 23:20:09 -0800
Message-Id: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0046.namprd04.prod.outlook.com
 (2603:10b6:303:6a::21) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|LV8PR10MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: f9fa1355-93e3-4e6e-d39b-08de4dbd3d49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rbUTHgxS/5q73b1d1EuMUNg9siNKVhUq/7RttilBsMYkDsejDa/xeNk6LVl2?=
 =?us-ascii?Q?Ft60Ug4kX8usKhpRXFXLjwr+m2Bctus3e3q1wgu/vgVybp3VK7Zxz7MTFDi0?=
 =?us-ascii?Q?ASUMig/ZhySamZ6DluSSemv3W+AUgOnWYAPIg38FscIUIDf2k5vd2C1uRG6X?=
 =?us-ascii?Q?893pyGaMpem+bTurjRUClPdsYR9msVvc5oDVM0e2cMBESGKkFL+gh2c7AE6M?=
 =?us-ascii?Q?sPGkqm+m9nGmVOpcXpOL7ss6GN0aMuEzjSykNxnLhXxt7fi/wHtePds3KuN1?=
 =?us-ascii?Q?Qmb1edBcokNwPSuCC7URoDyDcWSe9XDN8nRyR7Xiwmri4SUyaLQk9U/7XMjw?=
 =?us-ascii?Q?thsOxa3UniyHvDM4vCuB7qDu3ZCYQI10WtF/fvKHl3GZLh6l8WYAG1iNB4v8?=
 =?us-ascii?Q?QjNt3olGLgm40ZnmAvtnwCZ1QoYqJbIIT5A2ZjSNFjvxSccAEX6smqyYEayu?=
 =?us-ascii?Q?FvtZ2xjBEnWbHex6Q9vOxPoyxt+Jhy4f3rY6940sGJFDJKVHoDSHvJODpVru?=
 =?us-ascii?Q?0l/v+1rtmBO3ZuGZ24kKmWVpd3amtjiaMopibjVHYWYBphID3HwqZIUDKGzN?=
 =?us-ascii?Q?UTOeLQBqZ2fx8v0rAsX0KC4+QEgbRONW3A1K1RXl+XXNCLjzhZntyqLyvIjH?=
 =?us-ascii?Q?YwN86psHwhTCjn3XNyaQEPQTIJAmjN4SXAFTETEhA4H3Bm9J2w5PJj3SDDAW?=
 =?us-ascii?Q?oJxxQhpVQ6x7lF+312gM6onC7Zq1uoRFuwwS2Qer3Mvju0LrdRom8mkLEyYn?=
 =?us-ascii?Q?m9xfZ5rPOdFx/01nj5oyi+YvmevS3pkUeB9gGVbFWNYbz3WVCuwUQ1UYXY0a?=
 =?us-ascii?Q?tGufCsYFNGLmDTq91UmTNMCxhs/BYxW6NagcV0dHqkF052hYbt/fa0JcTAuY?=
 =?us-ascii?Q?uDHmkiJ2TCIFsN6zi8bmFsDZrA1vYMxl7EItszjBZR3seabi1IqG7a77g03g?=
 =?us-ascii?Q?4xI/U6aDkeciijFrTnJC7vBCBX1GuMm9Pik698Mo5GbnwxybdFuVRxj/hjpk?=
 =?us-ascii?Q?HSwzkeJhHCDkG3zEKdrzBhzQrmZMF1dw6Y46gASQFLGXQALU2wAR8OHiaNiq?=
 =?us-ascii?Q?IiKaFrW73YSED0EUe+B3OrAQJ+rQe6blhW1TnQjzXu1Zs70ntRcuq/1/p0AI?=
 =?us-ascii?Q?6NEJ4FCDB4KevDuG/ZlrHaDB1iMTNhvoydGaezisEBz3ngYzwvjM+UbX/p62?=
 =?us-ascii?Q?Za8o/e5QW4UeN8T4WHhvU4IJ6uFb+7wpQDYjVBH0v0wBDlvLU/MqUUqBj5Qb?=
 =?us-ascii?Q?bQSBENgOrHKvRdnHR8n8W7RaGYe+Dz0UDggEkd+U9y+Baa91dG7Ojp5Vwg1l?=
 =?us-ascii?Q?pyl6Ap9O7SK9qjJY9281F727KJSnPcwJnfPor+gusY1zh27W9T2Zf3M69PY2?=
 =?us-ascii?Q?GafRd94kusheBwRc3AN7gudrtYSa41wenS9oqXaG7L6A+VVx8AfwSSb1iBOK?=
 =?us-ascii?Q?izlN0SP+dOxjTxwqoXfCMJ/T9AwJ35MV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y6XnXZ5JHqOeJ0lb7Ft7eioW0ZNj8isw5FULWEuRPWntPGvD1rd7pbPdsYjW?=
 =?us-ascii?Q?VDGf43e4nDfw0o+nKX0E/rJCn72blHCO5b4m4Ozm4cIVPCOxdHo12b8aksFy?=
 =?us-ascii?Q?RLQexWg6PVk7owhXg11xz1nw4ZreuOIhLwtcWnTONY4Ze0gI1LqNxE2h3ZaS?=
 =?us-ascii?Q?WD1OONLRJliwrQVbeVdtQKzb3Jqx/n2WOEAaF/kzHTh2L59ZgNJwiB6pRDDO?=
 =?us-ascii?Q?5UK3XRM5ZyXhGihZDDms6W+QZOTQ/Qi7QDTI66l6lgO7sz7uArEV8BQimxtC?=
 =?us-ascii?Q?zv+SKRT65cYNXIxf9Tsjv/6mBBBOv3q4A8ZKWtz5dvDlm16BwKRC1+UrP5ny?=
 =?us-ascii?Q?5v7nGl4cXkIoYsu76pZkjdeGsgYhwhAIKwpyl86QxfJT3h/prmGR4n64sKNs?=
 =?us-ascii?Q?V3bjm3zDUhCfQyFFCyC+1sRzDi1McUASOMCnSV9ttRYpcBVVYk2SG06tMQh7?=
 =?us-ascii?Q?1OUhZy2q7leZdXA2ooPxkf02JKj/QzMeJ/mQVTHeXnDJZkCAsaHrr86TPBey?=
 =?us-ascii?Q?OS8ss/IRLznBDd/hp75XLoPfToz2z/TfolRmG/sqqyAa5G0gFvOmURbh4Et+?=
 =?us-ascii?Q?iQQEYq/KzsOwxmb3F5HdiY5zysZctQqKugsp3KzBnyy0e13fNk6eSgBK9ewu?=
 =?us-ascii?Q?fD1So+DzUJ9G1INAArQRn93lVrm8AjwkQ6P+NE/ppoxvGguCCqTkIN/a7ENw?=
 =?us-ascii?Q?DHVc9KDfEyu3MApszlQRGn+S5EGq4WgcZPaHSGPd+aXQAWrOhkN9/H/OgUHQ?=
 =?us-ascii?Q?VySv7zS8YrKTRf+Kfet99NAFUhrA1s6k8FOr46IKtLy8MqlyekSCcr9a+TZW?=
 =?us-ascii?Q?PIhJqTXJJGgpTR604Xu3BwrSVd16yGHstG0p5qmy7xg9icmF4k35keIuBetw?=
 =?us-ascii?Q?BJmIYtOgWbHBTzSPT6GbHufnNovlGuM1OuSMMJ+c+0dcIbIfa1UH03qAYEdC?=
 =?us-ascii?Q?WkeBMKlLLdf4LKbh2vgbHgPvptcAudZw/xK47OnyEF7bAbJrtJ1Z2dBReVeY?=
 =?us-ascii?Q?twIBGDl+d62HOEbqdv2fCluS0WvHQWFUL0RNfQ726sGpAkyiVAQQqBDlyN3w?=
 =?us-ascii?Q?dOhwdO/QHlSBR0eQ9FINrj4VjsyJMRyU3CQ3tjiVIYJtgO5GcYXa67qZimzd?=
 =?us-ascii?Q?AL87ZDgFlQ2H/XskIZpslnSAy+j/MiN+34SZ0MeCVkDGtA6DPjmybXeYZKMK?=
 =?us-ascii?Q?B9IHK7YXsJULRuldxC1gFT4z/ZR9HomehINdrd7PzJ5b+FN4oUdOeL+Yl/4H?=
 =?us-ascii?Q?Hfoq6f+jHcojSGe2nweTjQvU1G3IZiA0AlCCKC9UQMrsJc0/SsGvnaJ1Z1Qa?=
 =?us-ascii?Q?b57/asODAubOS7R695l2kC759lFQB4F3RkhZrqbkvsxcrJ6e4AmkSqno0T9j?=
 =?us-ascii?Q?c5sy+lu59WDxQ3GsOifnosm+gwRKt2+J1wn38p3dPLIAuMGlMJJK8Eg98K0o?=
 =?us-ascii?Q?c+2PfvLTwYjuZNmoyMpqcfq3TPc6cHd2u0Xp+nN8o7NGUQn7JyTzpfTU1H4e?=
 =?us-ascii?Q?kROnK1HdaGT1t96a7RsTiFjJ9y3eehfl4zOoKwLDLP46Ct/Hbs9+7ckR2rGQ?=
 =?us-ascii?Q?l7po/Mobaem1GqNGKtJcbrmZaPEmeHfkZUEdfGHWkwCbEv6ueji1f2wO14gX?=
 =?us-ascii?Q?qqZY0UXzB6h7rv/TwD0BTL67SwEijU8FzARW+XO/DAo0K9p/x3eOYfS6v4q/?=
 =?us-ascii?Q?SilZcBDWYzTDFl05zzjmYLmoXHnFkgWLRTUx3Lb2pLBI3HTk0LfTTRmRvxuG?=
 =?us-ascii?Q?F8VJoUeV8o2ABz54cUJJc83YzDEbY78=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SwYWagpKpoPw6uS/E8QOMrWMxGafUHptdbpR3ODsBuOHR5SjFKwkIHVsDGg3MX/efwB77kDHZpal2NQ5Cdatdu2OOs9DWG+iuIFiGi0STvYrFNF1EZlj0PwQ9v6enAuoyRAWGmZdLFpJT7XuPrnSuFjI09s24ILhq37F9xeknwEEtM67Mr3YYrnJs9suR+7D+eDR41wBuslSMB7Va1KmbLQ9XQ+EFbTSmL5+iuAJC+mh+Edh68mHwkimS/OHrFFeruj6sMZGaLzqEYevdiGCpy01fE8ikmvo5OXMnuL97CWafz2GfePnTvXSKOFk3n4bto9wfWpXDMQ0I3mkFpM6Wmt0vRFRydx7myTtpiGIvOCZ4yaWFv050lp3MnjdXBHpDuieJgoML9LW6vakU1Aso+ZMA7yuamlzoIkIZEORHpAdR4OOYtx1HXsXcpzeU/6lGelmCTXNZ2Jt29IexXqSFsSFC0Crp193hWWYlqc4gP07E4qTypMg2+oJFYtxNrPpsEsCWMoRbgrb7JOgcVqhyLiScPgedNR1NVVsASZiwwT6p+iSW+SagoJt7Gr7I8G5UrRhJyGCGLw90emD74b/fqR99bM2lENAD8LNOoyD+cs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9fa1355-93e3-4e6e-d39b-08de4dbd3d49
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 07:20:30.6674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZzU20i8FwFIxpxTQEsXxwPIT57CYK43tljOlVgRIrJdTofELKRT+p8FXxsInrZFxCpA7/RBdO8aDsG7fm8LqlcQa9vKv6SLQMaGITImTW30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070058
X-Proofpoint-GUID: dNxKxpyxZPyhNt-v2j-rWhBgM5awZctD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA1OCBTYWx0ZWRfX5iH41c/AMd7p
 0a0Bl1K+nM2E/wBAxdHbs463tY5QN4IQzwd9vJ47MPmym+lMsOukGLOq7ewuGYu+bCvkTEh6IcH
 d7Dbfi3wawDovLpg+PRq7DEU9GinyqNW76NL45VPbRNkrVWRkZPtZuDRO1QDVw0z3VJp0U2lQ8r
 aFyrMI8bsa1dlZ4sMQyCvtKWJqDrsEAokO+2VCZ8NoHm+23y+FiVYwV8w5aMv8mj35RatRscTFz
 L0oMX6FsuewDFNoPmfzJVnMRMGt47/g4LbSsHmTnB8INm2QqKDXfVic/YGvqhlJzvh1PvlPTgF5
 I0oSSAqj5DDgpRsBK6yhTirv6cI2Y68XRbZQi74jkhKpkUa1AKicrbF+vg6gwdiQXKBlGMoffO7
 zroYfYjS1uODLK9PYxVLxkPgGGRGq25gjGeFvIXRLrHzNIcmVF+ZHMnw46ovmSdoZcAakCVV4LG
 C3oSUrSgl/aP1gyBH7kSnMEHH1rOjmrJac2Au1AY=
X-Authority-Analysis: v=2.4 cv=KtVAGGWN c=1 sm=1 tr=0 ts=695e0942 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=LhKAmCKuLmOf4y2dLz8A:9 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: dNxKxpyxZPyhNt-v2j-rWhBgM5awZctD
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F892120005
X-Stat-Signature: huqbp46b1wfs4uygbecc3qtgohgssjy3
X-Rspam-User: 
X-HE-Tag: 1767770458-839802
X-HE-Meta: U2FsdGVkX1/xJeq7wlQGPjeVZL+l4q6/iMYGED1Cv4WLryWLHH17i+QjM1bq9SptCwbgbFKWmhyy8OnEfeMX/KkIz8D1zUQP6Oe/rpNQDzJzPR96jHTXj4KKH7oeFxmp9LJTv2hk3QT/uu8mEMPJ5JCBGsZ460cq3V/8rkYvVmvTgtOuujNxdI4mhavF/yf9wHdto+wz2+DEKr+RMp6BWn+6QMHcy99+oD2xVTs2ATMCHLv4qc+dyhoUZYkhhl8OluFS7TcfMfWQogznyn8rmljWea0my0XXmoxAhqE47gRAtQT1tTGY+/ZpO1J+vuWWGEIDBC9KNJsln8Ng3VKylEEXuVRgmMiBa1oPEmysP6gOOQ+INj9NtkzXHgPOnndON7xBAhF/kj4sva/OzdTGHTjWlAZthbkMgejnL2D8Y1zRA2S7v7RDfJXTIDSM7AqQBsncSCNXbGuvzbVPxUAstZC9W7wm4v2R5XGR/1yEEyc4KtgBP+V+zu6e+3iMfYuIIeamdaAKqnkpQ9R9hziQwDBIFPIPBpAdMlHXGhrsvPS4n53cMibvktp2HmJZZ1Z3U6+FNJVZZ7R3oeK8EVc44HtZni9imef2CViYkaOSySSvnQr+tD2XQdgJRTydMGNWMswwDV/+khhAtvrSzkKN+exmHSlZiBYEGPKqXPcBHHDhQVIKl+edXNmkZ2WjVSxvsg4wPQtfzDTtYv8MxNvfTjRUIVNjyVLzjTAGPck1CVwQYRka9PZqxGW0OiipuqVRMPE6uv9lggFaQDR3iYT89RRwli/kkyBBTBZNIx8E3ckq5SUOCKb0vJGPhjpiiAiomm+AsVTOJzL+J8WjpbNpTHVK1wiIShqSP+mU5lrS+c9fDAIZRk+nwSu80/k5KHZ/h/+WV8Dkc+LHVk9Mj2rcHt8oHm3DALc3OMI6oYDyuLQSSH4Z5NzZSNrF85bIENtdOmokttIxT1juXBCgZ2o
 wtjbZ5M8
 AeyF31GimK/LwUDqXoAkQ0Ar4XlZAp6yHBHor+53TXwfYEWCPwte9mP9zMqBrHxbiz4lV6yV/P1/3Ys/PkIsBMqOMiZq6tNc+3ab2tdFRh+KAH+c7U0Js5afGIoloiJY8S+tV7GdvySq/rDSbZkzEU3NTMui+Hpl+aQjk6iEiJARKIkylOJJR4fN/MFDbmKAYVr9nslKK6VTSgdmi45iBCr9jBGg5JVD0rLfLowEiQJoNHOcsGiKAWcRzB5ap/KeVSY5ElxksJiiZttfrqucmycjO8wOQOPcOYH3Wbb6IWQvL6GFtwKObYZpOEVWJv+M03cteECIo5YhlnIMDQlQvpfYxZ7o2MnoOH/e5aQgfNZOsUq44xwG/Tf/j0Kz0zBdyIFtT9lJmM+YBOtg08jgtL0JvB027JX9PDWpSGb6XG+LkcKCP0QBEZMr4rGkmR59ifLa2K8oMdXh8krcva5OFsN35XuIuzDhi2Lar/8Zw6zPP8s/5ZlFaJq+OmcwdFG/0KJzi/aeeGnCvly6vAzAJJsaXUQ+yz7ykNPEnpt+YP2L+/e8Vt9UGTmvtwkW0QdUXtW9GyKoxKOyHMuqDy3so4T7/p6caIcUjCy+c/eSmy06XRBSTF6k6tDiWHLA0qXmOFuH0ZL8j/QBLtn6I2V/bTWDgV/9GGRt9paO2r6cZbO6FJvg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_zero_user() does straight zeroing without caring about
temporal locality for caches.

This replaced commit c6ddfb6c5890 ("mm, clear_huge_page: move order
algorithm into a separate function") where we cleared a page at a
time converging to the faulting page from the left and the right.

To retain limited temporal locality, split the clearing in three
parts: the faulting page and its immediate neighbourhood, and the
regions on its left and right. We clear the local neighbourhood last
to maximize chances of it sticking around in the cache.

Performance
===

AMD Genoa (EPYC 9J14, cpus=2 sockets * 96 cores * 2 threads,
           memory=2.2 TB, L1d=16K/thread, L2=512K/thread, L3=2MB/thread)

vm-scalability/anon-w-seq-hugetlb: this workload runs with 384 processes
(one for each CPU) each zeroing anonymously mapped hugetlb memory which
is then accessed sequentially.
                                stime                utime

  discontiguous-page      1739.93 ( +- 6.15% )  1016.61 ( +- 4.75% )
  contiguous-page         1853.70 ( +- 2.51% )  1187.13 ( +- 3.50% )
  batched-pages           1756.75 ( +- 2.98% )  1133.32 ( +- 4.89% )
  neighbourhood-last      1725.18 ( +- 4.59% )  1123.78 ( +- 7.38% )

Both stime and utime largely respond somewhat expectedly. There is a
fair amount of run to run variation but the general trend is that the
stime drops and utime increases. There are a few oddities, like
contiguous-page performing very differently from batched-pages.

As such this is likely an uncommon pattern where we saturate the memory
bandwidth (since all CPUs are running the test) and at the same time
are cache constrained because we access the entire region.

Kernel make (make -j 12 bzImage):

                              stime                  utime

  discontiguous-page      199.29 ( +- 0.63% )   1431.67 ( +- .04% )
  contiguous-page         193.76 ( +- 0.58% )   1433.60 ( +- .05% )
  batched-pages           193.92 ( +- 0.76% )   1431.04 ( +- .08% )
  neighbourhood-last      194.46 ( +- 0.68% )   1431.51 ( +- .06% )

For make the utime stays relatively flat with a fairly small (-2.4%)
improvement in the stime.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 mm/memory.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 49e7154121f5..a27ef2eb92db 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7262,6 +7262,15 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
 	}
 }
 
+/*
+ * When zeroing a folio, we want to differentiate between pages in the
+ * vicinity of the faulting address where we have spatial and temporal
+ * locality, and those far away where we don't.
+ *
+ * Use a radius of 2 for determining the local neighbourhood.
+ */
+#define FOLIO_ZERO_LOCALITY_RADIUS	2
+
 /**
  * folio_zero_user - Zero a folio which will be mapped to userspace.
  * @folio: The folio to zero.
@@ -7269,10 +7278,36 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
-	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
+	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
+	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
+	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
+	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
+	struct range r[3];
+	int i;
 
-	clear_contig_highpages(folio_page(folio, 0),
-				base_addr, folio_nr_pages(folio));
+	/*
+	 * Faulting page and its immediate neighbourhood. Will be cleared at the
+	 * end to keep its cachelines hot.
+	 */
+	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
+			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
+
+	/* Region to the left of the fault */
+	r[1] = DEFINE_RANGE(pg.start,
+			    clamp_t(s64, r[2].start - 1, pg.start - 1, r[2].start));
+
+	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
+	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end + 1, r[2].end, pg.end + 1),
+			    pg.end);
+
+	for (i = 0; i < ARRAY_SIZE(r); i++) {
+		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
+		const unsigned int nr_pages = range_len(&r[i]);
+		struct page *page = folio_page(folio, r[i].start);
+
+		if (nr_pages > 0)
+			clear_contig_highpages(page, addr, nr_pages);
+	}
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-- 
2.31.1


