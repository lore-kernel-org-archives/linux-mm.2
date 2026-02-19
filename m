Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E75E9A05A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 19:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891B96B0005; Thu, 19 Feb 2026 14:28:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F106B008A; Thu, 19 Feb 2026 14:28:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5DD6B008C; Thu, 19 Feb 2026 14:28:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58CAE6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 14:28:52 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27E5B1B5998
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:28:51 +0000 (UTC)
X-FDA: 84462193662.25.96FC0E3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id D98324000D
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:28:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CkRl9s0R;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=affcj3ZQ;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771529328; a=rsa-sha256;
	cv=pass;
	b=2hmI7M6NHUtH3l0+undjap6SHwhug6N2bw/ZYG7Q0A5JgeKP6mAhbtGrgywMTW/6/2C72Y
	CLKH+67w5o07Q5Z9Z0CwnA9A2yEg3LUlQzkBTJyygTLosjcx1ZrZjIGtupUEtA5CC8UeIt
	InLBS0hME531jtS/00N1Y62O53mvJjg=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CkRl9s0R;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=affcj3ZQ;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771529328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dCqJBg0HJUwWZ1LrYBIATiY1p+r40I1150bEHSY3clU=;
	b=MMdDdmfTgkB8JRPihl8a8M0j5yRMdBoblnwwEWx7dBCZK4CLmKWbP6h815b4JmBoRbsyxh
	YTmfJ012WXwonPi51tboDFs8Ot1kUzLr7N6nb4Zh3GVViUEU+kY4i5u/YvqH/6Kf1TZK4N
	sxRvjMwk/sYBTpobHAyfFUJcs9vd8c0=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JJCkLD1118261;
	Thu, 19 Feb 2026 19:28:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:message-id:mime-version:subject:to; s=
	corp-2025-04-25; bh=dCqJBg0HJUwWZ1LrYBIATiY1p+r40I1150bEHSY3clU=; b=
	CkRl9s0RvG3gE/FoANyKMqXq4ze26UoZ4aIvAsgQaE2tAG4ZNy0sHYHCWhGXxL95
	4PbXo50NjKHb20nTmSKK+Rn9+pFJ75Dg4w+qs+VX+7eTrz/Do5wXJXxCP9dSCYc6
	IfMSwUYui3s2wo92iY9p3ih5f+s2fvICUcVMb7itqcuhIcVObBjl4qnz50uwnVLC
	lWNSI9gSkDIlCO6CShZfeCNSsAW4vEdiae66AgAW3QHlzN5mGWHWcrauE3v7zBmZ
	zA2+N914ExalNdNnFvZRCehFvvvSHMeWw15fP10N/PYHTjOQPMg+wUg4qeNLTgsd
	EgzBxCTo1VY8yV4cUDvhfA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0wr2yk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 19:28:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61JI8pS4009970;
	Thu, 19 Feb 2026 19:28:39 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010056.outbound.protection.outlook.com [52.101.46.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb2buh5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 19:28:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dT6BMuXbF79uw5AlLm3FXv0UEQyRDv0XSvY2hNhDJuYxa7y4Ty/7OQ50VyKdIgfrmPdbzg8GfwsL0VTj4cKrd3u5c2L4BDTze05XbjQbU84WSQAGR0lRfRjbzc4jHYCOuGSzJyFyBgmioBcSU3+JMJDjo2srkf60zA1kv0kq4T3SANnjjoo4THrHkWigYA8okuW1W7Sz7g3x4zWjVESeGPcUMkvSur/aPrSScR7OClrGRf4zLoGJPAzQgeiyHm41A/OP/tW0WmHWLhO4Mho+uHCbq+U1JyIOOkQknHLmw+oGViWV+tBfhfuo+ZhMzNXY0scRYQY5DQHNqKCX9oiuWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dCqJBg0HJUwWZ1LrYBIATiY1p+r40I1150bEHSY3clU=;
 b=RrVp0ICHnCvZ769fwIvGc5KQlAb644/DeJCXkYtmxGeRR7QmrHiPYhsv8BuaRa9OZ+jCgxfro2IUFv/pNtVahz/NELxgSYLaVzv1iEFvvIz2tH4YyfAuXCLi62QinVPmV62PSA0FH41His8c5IQHrBqYNiYcH+h6t/aYuEYk4zkmoYmVIQd1dotTOzDoU9P3rh9JRn0Z8L7dkCATHl6G856ZADKCsz/cILylhIeh76ti2yUS6mONqbSJ9fyaRZmYXBD1uB9OLKLQfjVf9anay9kOPe2YUOCxKjPH0DtmVJ2SkXzszkT8EbjwHPaSnzcjP7TEk2AGjSEzsDg4zRdQtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dCqJBg0HJUwWZ1LrYBIATiY1p+r40I1150bEHSY3clU=;
 b=affcj3ZQPIlIwJymxgQDZN9+jLdUEil5yHjr1lVO5QjKHNmJ8bPmROW2LDgldEeZLudtXUu3hfx8/gm3lO1YmayXWliHs8xtZTjyGns51Q7lFnqsDBoNGa8pwoXZTvPRiVNaJ/0gIGYadUOG2Y447EdD9SEFm2RjdIHW4GbFKHA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8562.namprd10.prod.outlook.com (2603:10b6:208:57a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 19 Feb
 2026 19:28:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Thu, 19 Feb 2026
 19:28:36 +0000
Date: Thu, 19 Feb 2026 19:28:34 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Ryan Roberts <ryan.roberts@arm.com>,
        Harry Yoo <harry.yoo@oracle.com>, Rik van Riel <riel@surriel.com>,
        Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>,
        Barry Song <baohua@kernel.org>
Subject: [LSM/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
Message-ID: <8aa41d47-ee41-4af1-a334-587a34fe865d@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: LO6P123CA0014.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8562:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c374819-da93-4ec9-9a7e-08de6fed13a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dU0AzMkib+LsU6a0L5EP/Vlh0Xvp6oO6wiVeOPn1h/+Wt3lJZ15IloGFLNpi?=
 =?us-ascii?Q?qFV+2RK2eGNCgWqGkCZTGt2HiKBbMi72lbDR0KPOa3ndW/xV8AHaZigeeyoT?=
 =?us-ascii?Q?0HD4iIlfNaw8WgOqiWuTbJFECnPjymLXWg7yFfEljg0NCLURYtTd5G66K4Cw?=
 =?us-ascii?Q?avOKQovDK/dqWiukMyI4MYUo64nnItFi9KjKMScLk31BnQ4MW3KQeXC+XmEs?=
 =?us-ascii?Q?pb/HhA3OSm+df+yh7WWM1OqoyBoS/iUbFjyQCqgtBir3Jz7eQWOSI5S9kh5n?=
 =?us-ascii?Q?DcHo6gv56D9zFg+Xzwe1oLjfjnDlhznaFyKN7vugr80QON0RDJpf+b2NEwRP?=
 =?us-ascii?Q?4OqDbi0tfBzauhog/jFgGaB0elUmTKP9qPbzb4wiNyl+nf3idAYT6CrpIfRV?=
 =?us-ascii?Q?4bbi+wb7CRRDrQHk9r9bOoejZGERNIOxcpf8XDuhmpH+4PSUc/fxjl+SUkm2?=
 =?us-ascii?Q?Xm5hX9Y9HT43eIcAFUQi+KEuI4c8VRJsR/SpXpm+rSneP9YWfmwZ5jYb6XFm?=
 =?us-ascii?Q?qpiarngeEYzKb9U8VdP86YnVXoIr2TObm01cgLal3wFfm4fe1drNp9PXwkdv?=
 =?us-ascii?Q?N07wuUXstQe08hvvzPNwbx8I+oadeAERC8gd85vTekzGqlvwS6Q5lZb5DZEM?=
 =?us-ascii?Q?+c09cjq4bREe3pciThG8Fd26W+B912vmOgckvNR7iMBEqQE8px96WyhJFLnI?=
 =?us-ascii?Q?3LO0q5ueYtAH6LPVbZgeTF7KqvjXr18LUEqoWZk8gnagQIAjxM3enYFo3sB+?=
 =?us-ascii?Q?PyjeFVOZvgXZan2xlw/cvipx0vXj/agTRNu4gG8amP96eTXMLAygWVmDOPfb?=
 =?us-ascii?Q?E/BVIedV7k2V3jMNMl7uYsNgrQBx0y9WspDuj8hF21BHDZ2QhnjyTsfBIiZA?=
 =?us-ascii?Q?rBrrpN5yoXDEBCDIuNddeLvI+HV0rtCvFCaDypR9ztpXzv3FwmTmthBVtafZ?=
 =?us-ascii?Q?LsARVKsYMB1MEZ73wgTbd7jvNz7dCC/LSWbUvf3YORIyIevco+5vdgUGke6T?=
 =?us-ascii?Q?00tnLYZi8hM+CBLL5fgw/p2irg7Kymi+j4g12byickri8krknOJ97HcgMRvt?=
 =?us-ascii?Q?81pfzol5aLN2D0i4mMxdCtFKJ8UeHJvf7e1lH+wNfUab9wxWVgZRf8o8aK62?=
 =?us-ascii?Q?HFlQuqH5998Ys4SmO4y4rAbKXHbSsQMbxr1RoIPFGIog/PSAAb+gHAlQkWyG?=
 =?us-ascii?Q?C6xepSQZyJszZ2tWLuUVKyZUvKq3ujxfjFauJ8lmCIf9um4yGE1MHF8TsBxx?=
 =?us-ascii?Q?N8KRQiB7kucByRYfUJJCDN96pRyTLeKg7fgkBOzSD/thlfqoCkUCTUr2GcOB?=
 =?us-ascii?Q?4uK9EgRKntAT51OpZ5r3GJuZr26V1EVgJm6wYNKU4GwpuVhvCuJG9EsbBgvH?=
 =?us-ascii?Q?w08Raohsy7F9vYewTf/vITfD5iuYjSwnFCHqFrJ0GbaGg7qvMaDxpPBrlHiS?=
 =?us-ascii?Q?794joIDimpo+q3TzQyBJ8LxmAq0qQVciFqMTcjrfSX2YtgXzYDdpZkqLkuVj?=
 =?us-ascii?Q?pypD29ge50pn8wZhSAxabMqUo0rV65mZustJB8GL4XH4ODXkW1+sHJry8GYU?=
 =?us-ascii?Q?5WJFeZvaZhqYm/GqvMho5DMItPUNRza0bZ1DKt8b?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+0u9apxbT7e/tueUJLCwCMUiHCKj3pJ5xUbLsyZs0Z9OVD4opH4TstKJwUVj?=
 =?us-ascii?Q?VMo6AreJBD0rvuIQ8dWKyj73A+gMxY4hlfAmHw0/DaMRDX3PFQVoP2NsT0Vg?=
 =?us-ascii?Q?inYTub9AfGCDKstdiHZAx2Eg5NxeWn4WsADW7l0G8sqPcZVMMHkjklyPcyqA?=
 =?us-ascii?Q?1ugy/0pBnMlsdYxwVkH69RABdjNHOAQBPm94E34XnL7fX7nTaEaQLuqxi42n?=
 =?us-ascii?Q?cjK7RGHq6x4QCSjfzcLpYW5+QV+RhWSBlgjXbWAd1vjTYnMsYqeKwhwxDTJK?=
 =?us-ascii?Q?VVmj7qjIHn+xxRqBWpwxO+MM7/0z+RDZnVqeVh/Z/kd/0ZXo9vp7milwIM/5?=
 =?us-ascii?Q?hL6K1EpMqRRdHl9t1y7Yv05o1tKPF/O2l8abQHFdHTH8MggSHxyQT7oqljrn?=
 =?us-ascii?Q?MKULrn0QW2RTndt5ncbuCHorHzH8gcKRHDJQJ11BQPeSnMeN7t2NROoyi/Bm?=
 =?us-ascii?Q?h6wU3qVPQq+1lOprCsLqfHeOG0z533C4z2oj0kpL8bOyZNtkedIMaUriRQm4?=
 =?us-ascii?Q?OGzOHPoSCfZGy0IvkhV4fNbTXLF8HMyMQKzaQttng/gdcKnSCct3c9puMcPh?=
 =?us-ascii?Q?WYrW6CE5FdaJhQe7SdZGBnMEYhBdX9GAECL6NcF/65PR5WW4kH4Jiuk+HpJ0?=
 =?us-ascii?Q?zg1VTnHT+Q1DSGoz5MnpG/qh3NWxsyc9SuCnyiPe+uWCwW/iwWeElI0SnU7V?=
 =?us-ascii?Q?himy4I7rEvjFOyCfiGU0ehXg3yOxlrbB28JGyN92BmSS0gCsImGayBgSBxI7?=
 =?us-ascii?Q?fej91OXFj8L7a94LZWNtrVswvfUn7gJvEKeTN1IGFeUkvDDUTunNsvNDI9OJ?=
 =?us-ascii?Q?y1hzveJ69H/zmjfa4HY9QHjq4kB1jhzPwdAI7jBWlvIKWv+M81NQYQNITuBB?=
 =?us-ascii?Q?pqhL2vfjV8JcfRrlVlWWMiNLmMsDJI1FqfkrWb7cdvCHz6fs/RpfPpgzwjJT?=
 =?us-ascii?Q?vVVWDWGtWn3UL7VqQ2wdzhvEP+uLWaIJdknMGkOH3goXcmPHKmvGDWPvojjK?=
 =?us-ascii?Q?WP2vKBxP1xhun56kuX7peWNs7LLq1CeJaQvwiq/+GD8A6xfcmXebxC8g0nk0?=
 =?us-ascii?Q?O3ObJo/LTBYvy/E988CpBdxyEHWVZa8Z3tAueox6BifNDWgzihoX1mIm5VBR?=
 =?us-ascii?Q?ybb7ICp7ufuumS9Or67LYCVmFF2TkzQWeHjIkvKYpcAg/jnQSSfYVN5HQdK+?=
 =?us-ascii?Q?YYJv8UmzPvbf/6qa0BFFe5Wiowq3kV5FKGyp6Xplbm9SVHNcnq4A1ocXfo6H?=
 =?us-ascii?Q?BvOJE7DADFtFgUmivxluZweCQh3yAiuZqw7WK/fnbDLnt+Ia25l8qIdmi6Mx?=
 =?us-ascii?Q?ImgMf7xJsRYjJWjvxDbUbzZb6DB9P6cnbEMBUZS9nU4/zmdGQCgfNz8lMcks?=
 =?us-ascii?Q?oIYW+Z9H3aay8uINwv4Uw/VLX72LeUWy+2AMHUchoKMPQNabPAxdVMjOBQlW?=
 =?us-ascii?Q?XKP5SAzW2sjuH4M3lTdH/LH+P85SOG5fIBk4sABVZkcTRtalCKH/mMpq8w9Z?=
 =?us-ascii?Q?3bmUKUHFRAMWXObObPuUO2HAMDXBG6FfwIZ4OhhkjVh0BGsQwWPPZ4RM1j4w?=
 =?us-ascii?Q?djcDeUTNxS1kR2jNuWJScfLZqX6PJBQW4bpifi6ufp+d0DdNsqgk9iFX6VWo?=
 =?us-ascii?Q?dsjh7/+JCxY/7kwU2Hs56Cf910EHbna5QeYsLuswWLwK+rVDpa7Zo1El5n57?=
 =?us-ascii?Q?wqo77J6It34hCLZOTucOWy8+WsRzwFvZVTH1UYn7biyEUEJ5nV3mCCAisHBd?=
 =?us-ascii?Q?TyZ4NEucYcH0U8pSSOjVrLcrQpPdJrM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cv3jVTN0lzWJI7yBJkjYdD6A0tpiQY7/7ogf2SKv7ZkUve2eGyVSzUy3A/PJChZd0LIEUt5tNLzKXJ1cypPCIB6nkhy92MgmaebPNLp8q9akcYLe4byaraJ5U+bI0N07EiK834sBI6tYoIS7ic6SWFjBAhCpNyZ4QI3PhJCNgyw4wBpLKJUW/GWy/chgC24lGlyCD9zQ6cCP4HqwNVljxnE7U4H+Bz1x/FAmplwp6Ood12phtl6LFhQX/F/e9VSqXaQ0H3OxxmThYQbm1sx+REaq1E8ph5puPlp3XERq5p2Bmm76vx0Z1ICwdiQUCj1x8ynPHSPzDzGA+FynlK79nQFAGjmS5P1F7lX+3794KRvuZ2FktOfGRSV4xDuRG4FPoPZR9W6eQ1Am6c8YCmXPtOKHfy5Lksayo11tfCPjrCEwx8vz2lLGHYvWqcLSRfNr267KTwfRhGpVkpEORSRCvvYqdFQKp3rHRdBXKZbkxBqt9TybOll8+WRYnCgpg8Iu4aoLT+J6SI4WQ9THhNYBUKCQWs9iW98GMRu/ZJtCjxV3GwK6nIGb/+kO+uySlY/jOSXh1bB1VJOxvemtk608tkwO8Jjnf5ZP3DAnYdnBboQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c374819-da93-4ec9-9a7e-08de6fed13a9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 19:28:36.2333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGD1vg9VHoP0XlSzBLn/zywzkSxt5vHMH7AdZ8OJmkOCLHSLUi8r8pjIINSiWsju4MlV/RnpPR/0Y5OuEUwEC8IKHEJOPcrvgB8RMLB66fc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_04,2026-02-19_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602190177
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDE3NyBTYWx0ZWRfX/dh6lmt12Cnl
 tjocf8Y6HtkUsoWyrnf6QtXXSpCQryGhhsiTn8JKaq7N2vuJA0af6NgimSOHPODNRK0Hnu+tS6D
 2SbhwI1cdnJE5ZGlxyzv6N9TCQMr7m7HLKETnnr052GIRKoTYbCywG7iYJZTV07gKK4lkUska1Q
 w67OVoZ44IuBjNhMQb0zE92+xnB0kEtrAuKCZnCC8gqKs+w5w9DnPYsSCkEBGpXU2s7m/9s6jed
 x4zz5geIE0LERm4GnhmM+i+IXcZILmF3ftl/VOSYAGSgRZ+CyTsOn6rJOcACUV8zGlX1J4fmREe
 MCS/0MkOlIDiluSVF1YfRPDc3SW1h7uuKYD+p5iSJ/n/05EfnXiG95LXLUFBGavYNh6rejl8Gx6
 fX7LAlz43UKRnX4TA0tt5nYqkXA1fY/99fijJ5lmIIdSjjd9yTxlKkXxW+iUvmAhx2RXPDI1TqL
 fAzzU/bqBE61/ouWBsrkaA2jfKkcmMSDyQUTQqWA=
X-Authority-Analysis: v=2.4 cv=ZMfaWH7b c=1 sm=1 tr=0 ts=69976468 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=yLjddgGIXhcoLGbBUYgA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13813
X-Proofpoint-ORIG-GUID: L6D2iMyWFqa0SpNCoxVshMs5WZQs4uaT
X-Proofpoint-GUID: L6D2iMyWFqa0SpNCoxVshMs5WZQs4uaT
X-Rspamd-Queue-Id: D98324000D
X-Stat-Signature: 44wcb18cjesiie4fppojmzihdima9r34
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771529327-405847
X-HE-Meta: U2FsdGVkX19nI67z2wVZSDBXdv1cNyrntFSddZHcWr5I1IpnIiYx/D3PZkeVcOse4hRezbHBkkk/ttz9d1idXxFAMXJISzbdrrymQI5K1SB91h0wf7k27IYeyxvYJeWtiWgirnz7/fnZFN19nO/ucEx1Braz16ScajWDoqHQwIhBGUITLgm6dH2t5p9g7AAXMv64JDnMIVJsbU3zFel3SHOzKh1fXu5LviJJhrcnALPzb1oS5sjxS4MuFb6mf2NdMACSwrKJmK7llQ5rCRNLoHNpcRjym4J5b49ksCf3JN8E6rqkRFdAI3+RZ7Dfr6Ea3xu9gP3mhk+9c0jFVGaZPSMQ+LzDL25Z7+lA6kW1rTVC5ueIxdRg/KIpKOe4KCt7zQBKXwOjB3Y7lVbgyX1PeECKxi/Vqvfgs1wlZSbVR+rL7hM3MgVKbHhP3pICM4segOro/zLinmvwh4u50l0y7xouml1lfKRMM0pSkTbjwlzjWhGrBJTQ/rFmj0Mml1pbwcBfOxW6Qcj4gDbx8UYc/6NW+FDfpZM8w2eXxr6BhR5t5xMrwaO9db6bvzY9QJlI1VV7084BX6B4zpYYrJ0iPVbi39YSrW7jCj3wZzE/gSmR81yfmlcdKc3nmv928xEv/CnApBu+nvTHvJ7bIFRYFWEcsX+vPx4r9PL2M01qCQ1O1Un+xY+4+TrFhoL/j6/27PUTXYlSLMuwDCKHfeaiUOvcpsMMYoyZO+1XM6sJHrstfULUV0zhzdydtiS6Zcn7XiBsAZutC1BkeTctrmqUzXaOd4tozbnw+xa3R5jeXqAeWmeefzIbnMJR1myiCE9hjiCkQ15r5YqTDIJQh70+qamd+8POHM8IzwCVbz0CmXxhACax6CqeQTMuXfT5j8LJMClpFhPBUiiyL0Tu0zB3LX5v2ssCl6RbrnEygftb7PeecAKmcBoOtypJz4XaxzPBGBRzd9gdqYfMtigG/Jo
 bx5HmaO+
 +nyY79xWgxv665Cjs+VKpUrwKW7Heip6wWflxvMGuwSIr5rnhuHD6gmJpNeMgF04QBaBG7qnTHPt9rESkmsByTk8NS+kGodt9xYv929d7hkzHOHPZucYd8y4ysh9oM0RcWevd/mm9j+AuWyIXXV0Cd6ztRIQDM/JeU0qz6aVS+GaV/P0Z3A4H6xzoIcL+zxzi4ZvNYXwMsStk159Yo/qZ7XXaDbngF9boRe4z70H6T19wj52ZoThuC7rKo/9sthvsuEns2+wmrdv8wIAzAd9fns9vVanZVR+uGQFI3h+pdV+4Osx2B1UiUiPf/Ynv2xYbs9I98pGELKXkcPgMwh69NrDU0nxX0bECRPLJjedkp4zj6EzboSB2KGUc92Rh7wYVotpHcbVLJ6lgWdsbszrnnugVdwRxzu2qqNGyrXRKCAPz1GYzAxSniTfA/jPsPRAKrwe69Y81RbWwhgLddxdjYmWZRInY5kJSyK3emX2VfNVM9CurFRzb0afFceGS6O708UgD7E/ezjeCgDHaqf3xdvWRGKZvnG/QUSx69qpf2h5ZQuYflfDJyBlnu+8ICeAYnEHhvkJOsbVY5rjvRH3gzn5UnSTjZHADW/t+RgqNnyU5bKSh8jArtCD4E1ZYPp7uVUjDDd3knUQIlHgulSN3DPf+M0s+KOyy6b59XalcW36M4qZrlN7PdmylTqaVzy3IM6tWiln6YC0RoCxU8rPFQoXq8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we track the reverse mapping between folios and VMAs at a VMA level,
utilising a complicated and confusing combination of anon_vma objects and
anon_vma_chain's linking them, which must be updated when VMAs are split,
merged, remapped or forked.

It's further complicated by various optimisations intended to avoid scalability
issues in locking and memory allocation.

I have done recent work to improve the situation [0] which has also lead to a
reported improvement in lock scalability [1], but fundamentally the situation
remains the same.

The logic is actually, when you think hard enough about it, is a fairly
reasonable means of implementing the reverse mapping at a VMA level.

It is, however, a very broken abstraction as it stands. In order to work with
the logic, you have to essentially keep a broad understanding of the entire
implementation in your head at one time - that is, not much is really
abstracted.

This results in confusion, mistakes, and bit rot. It's also very time-consuming
to work with - personally I've gone to the lengths of writing a private set of
slides for myself on the topic as a reminder each time I come back to it.

There are also issues with lock scalability - the use of interval trees to
maintain a connection between an anon_vma and AVCs connected to VMAs requires
that a lock must be held across the entire 'CoW hierarchy' of parent and child
VMAs whenever performing an rmap walk or performing a merge, split, remap or
fork.

This is because we tear down all interval tree mappings and reestablish them
each time we might see changes in VMA geometry. This is an issue Barry Song
identified as problematic in a real world use case [2].

So what do we do to improve the situation?

Recently I have been working on an experimental new approach to the anonymous
reverse mapping, in which we instead track anonymous remaps, and then use the
VMA's virtual page offset to locate VMAs from the folio.

I have got the implementation working to the point where it tracks the exact
same VMAs as the anon_vma implementation, and it seems a lot of it can be done
under RCU.

It avoids the need to maintain expensive mappings at a VMA level, though it
incurs a cost in tracking remaps, and MAP_PRIVATE files are very much a TODO
(they maintain a file vma->vm_pgoff, even when CoW'd, so the remap tracking is
pretty sub-optimal).

I am investigating whether I can change how MAP_PRIVATE file-backed mappings
work to avoid this issue, and will be developing tests to see how lock
scalability, throughput and memory usage compare to the anon_vma approach under
different workloads.

This experiment may or may not work out, either way it will be interesting to
discuss it.

By the time LSF/MM comes around I may even have already decided on a different
approach but that's what makes things interesting :)

[0]:https://lore.kernel.org/all/cover.1767711638.git.lorenzo.stoakes@oracle.com/
[1]:https://lore.kernel.org/all/202602061747.855f053f-lkp@intel.com/
[2]:https://lore.kernel.org/linux-mm/CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com/

Cheers, Lorenzo

