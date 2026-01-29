Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00DEFD358D2
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 07:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 307786B0088; Thu, 29 Jan 2026 02:40:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E94B6B0089; Thu, 29 Jan 2026 02:40:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0436B008A; Thu, 29 Jan 2026 02:40:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 096BA6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:40:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C757CC2C74
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:40:43 +0000 (UTC)
X-FDA: 84384204366.26.57E373A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5B5F7C0002
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:40:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gcnVJM7e;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OaCv1X0H;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769672440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9jfUclw+yvPmVIZjheNtO73+AAMxSJHVeZcsaPYEQo=;
	b=UIbsOV2MAa6cGtYLWT086Llmu1aWo7u2vhcBqHE6fV01tk+tKrDLz8wV0amJDYHYGShTYi
	o/KCInR3MwgVNNl8lwurjM5QVeRZIiMJajZCM6FvUZmG/55Yk/U5Ylu/pySk1BAL/KHWhM
	wgm9Z7shF35CXaNA9Y4XqvaOAcwi9X4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gcnVJM7e;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OaCv1X0H;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769672440; a=rsa-sha256;
	cv=pass;
	b=H3UMYn+rHkNWnj+xiJTLmCWiJdVGX0ip0xQuBNfi379oKp05vJd8tBZ+hHqRXILLyEYfyO
	+LIQ8D68QE+kledxmENXsVmz/blXfvUMIOU6tQybrUtNBNu9V7cxdmFaooc1eerqs5EjMt
	Hc6Wkxy2dA+MUzZQZQ2UAxsrJQqEb/M=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60T6RXDs1431695;
	Thu, 29 Jan 2026 07:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=u9jfUclw+yvPmVIZjh
	eNtO73+AAMxSJHVeZcsaPYEQo=; b=gcnVJM7ea8Ue3/3LGmQJlxAp8w4kei3R33
	V9nC7sGgJ3ZklQdyd5l/4/5JFgX8vBC++tzfZ/y+qsp9Cf2lFw/W6UIkrrEApxAa
	FrNvvN8eGVJgA5i+z/NZDBJPhO5gl+q8j/RHGB2FSnHP+REC35al/Pg882P7+SaZ
	UToubiJ8oH13rBWlTYCaiN9D8GqX0H2Su/4YMuUfVNBMcPkanZSoh0WwgNEcAmIA
	Gpp9ZE0L3bnu9/M4um7kwOuuUN/X30jKN2/CKT6pXCSPkGheznTxGPDzDTXiP/dS
	wIjZIYQZlON3TbCXlqgBVsTJNySM0YZ2/ArvnZT1yhxUexxSDwpA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by5dj2em7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 07:40:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60T6YS7S036021;
	Thu, 29 Jan 2026 07:40:34 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011006.outbound.protection.outlook.com [52.101.62.6])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhr9ddd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 07:40:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WXJUjhEFV11m3XjURaJxWDaF73dfP4J2ABwwn/E4M5Lng8xY/YYqyKKPQhImHsZ4tfxsKwzLygGN0tKQbCiZAfK999XEE+EQ8pNgBrYCTRy8IgKJUGQ3SbhWnU23ddvH3QxgvjKfJqmOB2juVg5+ke5nD71fSAeOxB490Yd2CzHAmSxRwpeICF1dq+kpgoQNStNK+2myU+i0ekZRLByZjFekN5AtF+OFH+Y8pixmnWlfGTm5+PmM8tXn+L5aEkgaLMMbri8tVyvNLIlbq9bGpsY0BNxEBCkghc5BOIOkPifC2hpYML+wSElb8raXN7DCuwzDym0A4W3VvUX0YhrAnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u9jfUclw+yvPmVIZjheNtO73+AAMxSJHVeZcsaPYEQo=;
 b=RTckxcy1SRusOx7Zx+9VQlKUkhGpIEA75iRZ0xZRpZUnfceWet6HNBqTzA1UP9D3ZO/Vdv5pYuFDF0AsPszUnWZkQGZPCs6W1YuOCTaBFTP4J/ffnN91lISsHdYow3eS1mhL+zk0kBvYwzUcRzfXDK9/Xbe/Bu2TeYZc8eA043c3yEP5htdoea+Kc/RBMifm2RYBSUwa7VKi84suSr4YnV/RiE7helsvHjWek0yTdgv4Tt1U1vnZABONakANEIBnshTBByHyQEShnx6bpqMF0sGEPlvix64T/Fr78rkkZ4+sp6LWNCLvTmXfVOs3LfK5KAR2dkAUbSiLZJrADldPcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u9jfUclw+yvPmVIZjheNtO73+AAMxSJHVeZcsaPYEQo=;
 b=OaCv1X0Hpu4zUXxbqIknt2ymOlU0IjcsbYFrHLSv6uMJzB6VDh59NOEbwSQPeMRchD+p42p6PNX3FIy3fMBU91ro5ZbKku43pOFsx6fQ1EjMuhpWDTKGLloZStMNyGmIoRCJnGHasoSbxCXIe8Cr608P+44fBmMfvm+lH5I72bc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB4623.namprd10.prod.outlook.com (2603:10b6:a03:2dc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.10; Thu, 29 Jan
 2026 07:40:31 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 07:40:31 +0000
Date: Thu, 29 Jan 2026 16:40:21 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 22/22] mm/slub: cleanup and repurpose some stat items
Message-ID: <aXsO5ROLtJ5jH0dh@hyeyoo>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-22-041323d506f7@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-22-041323d506f7@suse.cz>
X-ClientProxiedBy: SL2P216CA0191.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1a::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB4623:EE_
X-MS-Office365-Filtering-Correlation-Id: 282e14f5-679e-4e61-455f-08de5f09adf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IaZ6PDuUK+NvP4lWqVvY8iqj79ZouNeK9i3SdaUW2VHYlVJA+PRTKaZGETCO?=
 =?us-ascii?Q?wbaR2t8kbQjY4p/NnJ/TNNz6YG6q1xEBTPb1FTtKs92TiHA5HBYsuewRZ8bn?=
 =?us-ascii?Q?eWUG/EuTecYZg0aao4W2ALjEPfYwuDTLDUfZgI24/3KT4RuiKwuR7N4CpLUM?=
 =?us-ascii?Q?1b9M9Kx5gktgoSF/tcI9gXDiDkDlf3A3jwVhiMJ8Jbvd8xfvHsLO4BqHUZK1?=
 =?us-ascii?Q?Z89l0n5shGkeGHOD5f2qizfcjKY5YZCDeWylWugUCOfGQXo0e+wxE9CaXzdW?=
 =?us-ascii?Q?SZCiJamlBZmzW/KsUQ1aaEtFGoFPFr5QmPJjak4odTVerQzyAxVrGQkqyU5K?=
 =?us-ascii?Q?G6jodRst7CoM7W3UoEdV5FZtruXtEwgSW4yXv6aELlny7FnEI747AtIvfOOe?=
 =?us-ascii?Q?4j7Qs+8NiTr6+qsvOcG2gWJMYtOkG6B54m00wbZNoKfILuu/fXC10hnYFUMm?=
 =?us-ascii?Q?Nac6uesJqy4+NMu8k0C3M8D8MmMMaJIjl7rz48ShTSklUl/rnxcL/ESQoo2m?=
 =?us-ascii?Q?dXNU1nPlqlFDzk7AZu0aHBanYNC3gRUAb3H7IkhBtxWDhu1S5p6+MN6qPGYX?=
 =?us-ascii?Q?PtP5VSVe+pxTVTD2/iAm0ELxeXYOjeDfq5q/pQTawnjZR8HXL9YKlNiDLDGR?=
 =?us-ascii?Q?rR93r4XhdgOM0ZKR1tNTqnmx4AbnOaEuhgr4qgX29FISKEiMxIU0JwiLdWn8?=
 =?us-ascii?Q?TecUcjYj9Gri6miHQZOYxD39w1YpryQAxwkw5/2q/sf4LZXj3r7FRDgjTw9K?=
 =?us-ascii?Q?+2kc3P0O8rMPHiHE8jf8Zy1IKOebTxNTiY/PTt7wy1miaGfoqkZ9L9m42fZz?=
 =?us-ascii?Q?3P2+I08ye76n77VfYQPRMwUIZhvS8HOJeyOBqCTY+IJTfEFkIn3GQATE2Yfv?=
 =?us-ascii?Q?PBtNmvLSf/qt3aJBXSg+tSBpC8htj4WkFmEk1pg+B/p5CY/Y2cmCHoHpyQCT?=
 =?us-ascii?Q?RY+JtrttpTl9tVM7hgNmAyuAWFHtSnwscqI2Chb7bnIdH4HsNKJlBZPod9RF?=
 =?us-ascii?Q?ag+jdIVFGW2i0fZt05/Xi1kiVkrY6RBLeKXAAyttpc5+uVVggsvw6ALmlayJ?=
 =?us-ascii?Q?FHFamlr4fwDT8ELIQwmocp44NLgBs9rOXg5hSyw6m2xrDlXFLJGBUga6H0TG?=
 =?us-ascii?Q?hGAr72jY9gicIEM5homXZbzSfUj6NrV27nkWuWBzA5EkIy1Gng7uOC7UFNXv?=
 =?us-ascii?Q?eCxbhiIRt4O76ycjfzvIHouKJePgnvA3Q5J9qcRRn8hV5sTU/9avkyzt2WX8?=
 =?us-ascii?Q?sxt5U+2vKVzrjALWmNZyDcua+C2nj8U3BaWexPqMXQwfgty2nz7rxs6Wcg/B?=
 =?us-ascii?Q?d4qT38GUeQmkJGPrQeNXVkKwhvBDxC+9Z+p4otXkMSSsat5MCGsrn+lLjgBk?=
 =?us-ascii?Q?KTdmUo/f0JrtWwUNypM4Z+YRPdpBXNWnuWjn+fZHLWlCscc3Ab0taccJanFg?=
 =?us-ascii?Q?3Mj4KU+nH/DOiYwd6BgC94mpaVaPBXSRVYXhY6OvFbWQ/+CeGyMv8sErXfAI?=
 =?us-ascii?Q?2thvAKjeV3glhhcZgh/XAqiaN/sCyfTXNkMqUiscVWxcTR1+wswCCWSGB7HG?=
 =?us-ascii?Q?+dvK7T7+OTPCWEBkddE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3BRgP3xtif/bQF6gCxiCy69Tq/QcEPwggHeuRMozKMluJhEKY5TjNOPvbfot?=
 =?us-ascii?Q?p7noMbDQ3F1q3r0Lx2Uz8B1kEbIC20v0hBdKBlZ5vmb62caQyY5HxGTbg/KV?=
 =?us-ascii?Q?PGfYIUMCwC7s4jXQjvQrZLSTtmdxaVg66V9MoK8nXkuO59XYorJCi+iN3cAX?=
 =?us-ascii?Q?j4RO3SsrL9Wvc8uurMDZYNYKUBaH6oUoPo3Mzez8/F8v3k3/Z0o7vsTeFIaw?=
 =?us-ascii?Q?bFLJnlpNz7xR+Ae9aByBLlLGoQllclmVMcB+ejS5hpArA4YrsLbY2qsk2Nz3?=
 =?us-ascii?Q?1MbHBXZ1gHfIJfNlRAurgvjITCUcrhK1MPTJYfpCMhNBuLrIpPlfSEfVU9rz?=
 =?us-ascii?Q?iytHej2fmlt8FmnXeAXddCbiW439IkKOdWKSRHXiLJMQ0RfHobSFBNKKg/XE?=
 =?us-ascii?Q?JD+Rb+yJeZuggEdD6x7AUIOx9+1b+Kuf2z+SOyhiCnqJYTPXjw5rANHX/Ev1?=
 =?us-ascii?Q?Tmm5LQtVPfM0I/Xo0O+McxBz8zcEQ3QTih7g8or2Q65PkNISx1+TNFM5kGXv?=
 =?us-ascii?Q?xlxMUXoHU//d5hwgPBaYmHecoR+RUwBU5JPRkD9K8Uj6wAMIPA0wuptM1G58?=
 =?us-ascii?Q?OV6JqhQw/1wWQQ+J2kRUFjur7PnWcuehOGERRnrXLmom65/ntMFZZ0RFRUBi?=
 =?us-ascii?Q?MlWZBTUxpS0I+CyAGy33bDuXuAClFR4YN03LKnF3ZJCeyNOXhANHKFtXr47o?=
 =?us-ascii?Q?eEgtJq2jx2aKIw+yXQaKNaUDxxbhYY6iQcMECZWqJhOj1j+ZIOT7or6/MBbA?=
 =?us-ascii?Q?MTt1bMqe27KWUarEYm020dxsBPUc5/+UuWxMeDTLfY/vbClZ0IHBnDWy6ZAv?=
 =?us-ascii?Q?+0Hd7waRPCKDrHGsrsRZBhCUzYQX5EoYjiMKba+bUdQExM9pRO9oXzW4/MQy?=
 =?us-ascii?Q?0zuwt2YalSkMHzSpau3MeSYx+mLlKSQ4Ph3RG23b4t9xt0buiicgO5bCyFg8?=
 =?us-ascii?Q?MjIMYbtwG4RuOUGMq8sepSLeDhYeYZ/igOtNjZppR42BbrKiMpQYs2BQIcXQ?=
 =?us-ascii?Q?PBJATkLVKKwj5510VfSUvAIwFkddLR7pSxAjmRF0uzaQea5aDpgkDaDgN8rG?=
 =?us-ascii?Q?9z0WefUguYNdfSfq8QxU8zYZ+3kH1v9GMqC92ZrsDUKRb3Ytmkbds5JNKtFl?=
 =?us-ascii?Q?iC8GRlkj4ToxNysxJVjv2a6OkvH2aG5kZE3o8ag/GDTWHVB5lPl5TM+UqqOh?=
 =?us-ascii?Q?VQJYeVya2FjBWpJBIVJUyexUaGksEqUOXms9xsKQHnXuvEZ49SC/nYrYQyMS?=
 =?us-ascii?Q?qFMeS+xD7K5HFDfnpFbvhUh575gnSTtxGFMlO0Lr3dJ0qevWIb3DBlC9AjWs?=
 =?us-ascii?Q?e61Ci/746mPSuqxWiSZZ5oFGYvJuA3wTmdb4c4dQX9NzeTql7Y/9gl+cWnjy?=
 =?us-ascii?Q?p3u//zIixpEUQg3mxzZMe1FXg3wCNjYlPnN+CbdBItYR041RnlnbhpoKakNb?=
 =?us-ascii?Q?yuht18s30LzdvOvdKlyJRxOXeBw6jcDYzFpPB1AR7ahTdQcC881asp8JmH+r?=
 =?us-ascii?Q?lsMVISyUz03MPndCCem7rjI348a/ZfY61q+uWj2lx7AVBG+oydyQ7udASoi5?=
 =?us-ascii?Q?3KKpdaRkItFzIb+rJvLma365Onugbo2PzbdqJEZRevF5tKQJy/0PMzlSbMMq?=
 =?us-ascii?Q?3YPSd4/SzoGwCwzN/fwkel8fqBUEREPijnnYCuexH/Rj3vNlnn+XgeZq4ief?=
 =?us-ascii?Q?oJTW1Pbni+jCrh/DGJlOk0JQlXJEwxlDPGfc26r1vk3y5K50x1sUbuTNqn6G?=
 =?us-ascii?Q?O9iUF7vLjg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w18hyy4nbx1KeOd+dkxI2ocvVSJLGUuoXfSW0l/ekNXFAPWRbeblrWDDAXreeBa2HgAIKd+DpzXlNriYQbO+PbaFVxn5hLbcecOaXomGVhwoBGtR+NvW5/gmYAVM67835DPDnhfidIaMMCGax/BGE5bdFEbhOQ2xgolHnSz+ox0dKDWWLcBaGlKRZ9sBDKSM7Hem0IY2uDpa/NhMqWNRuE+nqoXu58C+NL2KqhD+yIElwD+jT1cuBTss0XuS4NhEbysMRHq7JWBnFMKMdEkpLvaUHEjjoZtQudIx25DgLlNYoJnnl5jkLCXsUWbF68B2qDqWeRQGe/z6SESYBSSNYLlfbUvKw5LcuuOvdL0PUu6XughnUp5EMCSJ98otnBcgWaw4rvgDpTxWgRma3lO33ugIUGf51dmOa93Wxc51r7W88YBsNjYMatwe1IW4hShwbU+WGM0HV/Dmf/bw5kU0In+B7PT2RtljNrbu9prd2XPW3L3GKNXao2t0yKDWHloqp8Pui4bSsd82w7Cm+vPhNmv8ZcSo6CV8SPO4V3ND+/xVanu4LLq8SOfuEKdNjxwKt0vse+01cbw982pCtady3ubOFPEqNrTebGoOEVrU2FU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 282e14f5-679e-4e61-455f-08de5f09adf3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 07:40:31.2181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8pxqvEjGKMJqTs1gWc8u8pzl8udnOaZ7avAIsMVoVA9UTcUKNUbwqGdCIm2xka9wFSwnNy08hi+619iwvHWrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4623
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_01,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601290044
X-Proofpoint-ORIG-GUID: 13_wVBGG-jHl8bltQtiZwg_6svQuPy9w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA0NSBTYWx0ZWRfX8IiqiL+DcdK5
 1baTZGvUdPQ7K6irCjqgIhD9qGmv+AhkwnOgGDGeq85DChLDcr8EO6smOdvzp1dA0xbcCh1CG2v
 3ouplfcAV2SjB8rmEwDFXBW0h7r5Q2AXmLTEkyVRt/lI5c342W2xD5sOuIn96CzSIYMx1e1lEpZ
 c0lXKaKTJjFkXwbiQ5fn1udkwke1w/bQ2fsX9cA48iTaTB0p4ZYiuDugVuVYWaLOLVNFCxouwz0
 wFRGx5RmY8hFAdzEoSosYwiHboFfdrcNt+ep7CD29aA2ziV6RKDdnj1yZTkHeWY/+xQvMeIqosQ
 F7yuny2+nmIfdtaC41kMNmG3+MAVpnjTJnQssbI0LyGkNgs+f4tj3Yf2pEqIuPJhdRFP8/tzJGp
 EIr4Pg9qVUdtlwVlRx9jUrkJQiPuu88CiWbYj4eobjOUmPtbG2aE8kAOSpncRoWXcvwmRqeIacY
 Y7vKMkYhyyIrc1sdk95BD+lj+b1+EMSbN7rLvdyk=
X-Authority-Analysis: v=2.4 cv=IrsTsb/g c=1 sm=1 tr=0 ts=697b0ef2 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=3XPRvzdtEcMrkblgAfAA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12104
X-Proofpoint-GUID: 13_wVBGG-jHl8bltQtiZwg_6svQuPy9w
X-Stat-Signature: q7sf3frhptuemcd9peyhconuu9k1u738
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5B5F7C0002
X-HE-Tag: 1769672440-600364
X-HE-Meta: U2FsdGVkX1+3NzYAecvZzzpY9nFvYYT6pnU8ZanShCB45owpzywM2N8Gqk5GC0ONYx6ZVpyyFpx/Z7G27cSQW1FK8qrbEit9h6ePgVdefpzB/wRrnOm2Sy71tq0gawDXxjRq0tFRuPeqwNidHI3jqk7zRxz1KTyLyw3W2N1t/mMGwrdWw6vINtnpo805g815MuvT03cRibn0PVY40Dw/vUGJXhB0JyZOs+e95J2kzFZiLGucho5niVkY0jLVxJdVC+upk6ngfmIfkXd/ydI2znlXDhuVscFmq/KPnQW0aATsSuf/D405X5MIkUQXphTCTDSGKPeNC3HoEPXnQ61wI1Fret2FFoSnPV4H5WGBAvVK8GG7KY1SU1JUlwFRdcw2OZSkXXBbnf9ova4ZMHZ6tdMEbIbDBZU2P19/9gmJkKxf9XT+c53YPJDXE/G7RnkMtqwqvE3ajBVKIMoagWqcH8aLPaa3GlYGP57nkxQ/lgHmOQuczE0A2SAASuQK7Cvz+q7rytRFjVHqE+Q9GlhKQmQO3xNWjqEOsejgu0m1E+JII/h0whbEMM0EATe8nVeQppnVY5RDAfgmAcRsovEa4W9Kbk3pmCQmD5vKeO4Vh42NJBXJbhr+Zu+h2SRJrfx7+ZZ5sy+JEp2IAR069iqX4EZlTOtxTKJZyX4ECbsAS55pY3PQu6UaHKY2IDmQ6eCftIxtgnWjQd/XXytYDghEG0vvl014aNooVMJEAdaU5v/cUAEsq+9d4hAtfkJYBgABQ5yqTdYwaeozuUTHpvVuUxG0jIxbdwTe/p27m+MTHE3OP/80l7myH2+maPFC70aFcS/tW9JwxMxNczITg8aZnL1As123cuQt5mqn/sAzpfTJhEAvDYQe47gbR06HpWqoleUBMBkJOeYHMGhA1wznE44J6F01Nkb/BEtv5WE4m3smpE0OK52qlF3Ledc+/X7Ns5TsZQ1yQdZGdXxqOCp
 CqnAUbqU
 UgHGBoYpcHKy8xS4hW6MQ+tOsdEq08L51yi12vakDd7VwRuYXvRW2vdLgAiOhXJMDL4r/rFQ35qeonmjB7yP6Ry8eDIBOIW9qKnc93l3Q3K0RxlI8UqQswajmEH2jxe8AlUAYLreFCcIQzzlbA2uf2g7bteoiBpN+EHsTYxdkK5bzCL7MhOCj6creQkFXtbnT1lb9tsJxz8+Sxpd1UsDYfZWW6Uq7VsDlos0CyitLeiiRlyuiyP77Cs1OSXn+IvMHIG2Xlby8dFApqg3x1Yr4Sy0bkcl514VNFLKG0YXmwFXuhwb5Ne/IXcTq6Tn8rl6NGAaXdGFYOGNEYNwV0OtOyOufvo4DE9iiJfz3nIQyQq88ijf+VUrGQmRYqq/8PplbOkZkJf4XP1rfFjcanbHlC1MyuxF6k/g5E9Pl5cywYxMHcZOk5uZfzZVG6TYhzdLfEpDRN7ES3qPs+1cW3oO/GA1FHVuxBOEeKXxv3lstEUPm6IRpXgCeoyHwoPTh4cmHM4VCbLbihHyGRjUi2zxeqWVLuxHmdcSgQT00LJZgaGQEf8Vh4bJUevGU1Z5X40d53aomJJIAv5M4/hdJW+lov2phGk4hQhKdh13+wkZQxswIH0C0PhDRr8/H69FhxlognXtoZruJtn/7hiRqTIlk1a0hfWRek5KHImbFhKECi+E92Ajh6a5Tl2h1Ww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 07:53:00AM +0100, Vlastimil Babka wrote:
> A number of stat items related to cpu slabs became unused, remove them.
> 
> Two of those were ALLOC_FASTPATH and FREE_FASTPATH. But instead of
> removing those, use them instead of ALLOC_PCS and FREE_PCS, since
> sheaves are the new (and only) fastpaths, Remove the recently added
> _PCS variants instead.
> 
> Change where FREE_SLOWPATH is counted so that it only counts freeing of
> objects by slab users that (for whatever reason) do not go to a percpu
> sheaf, and not all (including internal) callers of __slab_free(). Thus
> sheaf flushing (already counted by SHEAF_FLUSH) does not affect
> FREE_SLOWPATH anymore. This matches how ALLOC_SLOWPATH doesn't count
> sheaf refills (counted by SHEAF_REFILL).
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

