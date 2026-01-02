Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF43FA3752
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 15:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B366B0088; Fri,  2 Jan 2026 10:49:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC066B0089; Fri,  2 Jan 2026 10:49:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068D56B008A; Fri,  2 Jan 2026 10:49:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E68196B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 10:49:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E2101B7AA
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:49:51 +0000 (UTC)
X-FDA: 84287459382.14.35AFDBB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1D15BA0009
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:49:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C9VpfDCB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZpVkXOD3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767368988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1fmlUOOHCl7qCRrYvT6JqVNaFB6PQNMlRGM2ogdJDE=;
	b=kx40aL/69Z6dyhTtAqDKOIgQcVmupkooPmSyKuJwj/g2EaQ/0/1DszZnIhAPrQtT7bp9wD
	G5A2Pz+3rrMMrtyvs+O24wMy9tq6QdrpYw2yAehiP/GDpXfYbSKuRdL7x64ydF7WcGPHgO
	imQg17v47pHQxRyByGZCe5gGqwEp7QE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767368988; a=rsa-sha256;
	cv=pass;
	b=uB+lfzl89wwnMJEN/0oxmDVQA5zXp0M8n/lFqDrzscAwk7NDurGpe6FcYJ2POOmKBxYgJ1
	IyhZao7I0MsioYNmTlu1pI96o3dEpahPvUM2KxnAtqs5hRucA3fYsRaaJcPEv3/Nyd2aX1
	mQAwRBqk7AEXFVwIHOPn8FRbbUhp1g4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C9VpfDCB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZpVkXOD3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 602BuqGW2742087;
	Fri, 2 Jan 2026 15:49:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=z1fmlUOOHCl7qCRrYv
	T6JqVNaFB6PQNMlRGM2ogdJDE=; b=C9VpfDCBbJBn6S2L+JJx7+La98t5AFIZmH
	oKqPw7ZUtl+py4bpRNmpsG5SZu24eNSYhiYQP2V4Trg43u0B/vY4luTAh6oY9erw
	YU0heA3iIdbmPqXan+XEDfAXnQd1Clb4k/jAZkchsVldqHOy5Bk5zirwaGc4QFnx
	GwRy+q4eUu4vfIDGGkVUsthwqRzZu7Lq2pqkf3UQ6dvuuPk/cQkrAcQOOde7R7ov
	9pFOOdCvRHRKpDFAALCzMuw4nKdY0eYAOntHToCXlIPCMiAM+9bZTUO5BEXhlrGl
	SGpmi8XhBD90hlnExq4JvVq+LhiDE+IyQsY2T379WqeBtK/Dj7UQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba80pw6fe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 15:49:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 602EK9vb039057;
	Fri, 2 Jan 2026 15:49:41 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013010.outbound.protection.outlook.com [40.93.201.10])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5w9x8nf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 15:49:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=djFGB4SXqD5jzdc800xEh+9WVXXO4js60tO4Ex3mmhrQg2BCmIBY7Btidvt2mbPyOzx7w/hXOXzKSEFRs+1Rlr6Dl9pysBboEL9xOHmw71CwwD/L00RTAIFprWwlewkSetiZjGkloiN/hvq/p0/x7q6KY/iIFd/fePQVX1ggMHncjmLsndsoM3qi7fOATw8DaJEcRfi30s0X4kfftlOSk+7qrpyKQmu9erRdNeKj6cp3P+XJqSyxge7RYsiAsuXS0Jb+qSMWI+Ic0Y2bCMDEjWuUyP0pq8W1RhgIudfrQSkkvUXP8/DQ4cj/KvYbXV9dA9vmYYKed1q+7eLIrxhk3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z1fmlUOOHCl7qCRrYvT6JqVNaFB6PQNMlRGM2ogdJDE=;
 b=h2MATd/WPtYP/erFN9E2bcLsovUOY3c3j557BWNGdTQU1Ff474CXDmQZNDc6Muw4RZkGNtIeUCZn8AqGvy+MK4JofY11G8YBr9vZKt4MHeSJURyf2KBNjcE7tJ5dQZ+02A2E+q1d1bOsVnSfQDGU3apAsvDXufQMVzllzMcPJp3JmmoipmZN+L7L5qBv6/x+4HKdEU0O2xdP19Oq233C5YBpsGKY/L9bOL7VL/g7/w1Nit77JW7HT1BfmEDyOmofcpYDz9dclVWm9VjhTZxH96a+sLRGLhe3TU3tRW1MY6GwXVF1fXwtn3ItAClqWbNzNl1MLBKnRUITY0Zvjyj2WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1fmlUOOHCl7qCRrYvT6JqVNaFB6PQNMlRGM2ogdJDE=;
 b=ZpVkXOD3V/oweMszUswLQJg1JjEXyiSksvAL2M1MTDLP6FmEVddhLqDOZodzcszHw7G3YJZ5rmElmFC3Avh0qTicncTpC0YpANaibjRndGNbUhgSrie+8X56Br53JBcy0HDrUyy/wNLwQlJ/ap2qnHcYvuAl/eSOv4FcsOpT1fo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8253.namprd10.prod.outlook.com (2603:10b6:208:561::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 15:49:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 15:49:38 +0000
Date: Fri, 2 Jan 2026 15:49:40 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com,
        syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Message-ID: <ee25bfdf-17b7-432e-adcd-42d104dcca86@lucifer.local>
References: <aVTJt9M-A1BL8w5O@hyeyoo>
 <20260101130906.839504-1-aha310510@gmail.com>
 <aVZ6b2ri1iRpM-7y@hyeyoo>
 <CAO9qdTEzgQQgV8HixsckHhOd5OgRk=_wRRaRbq4d5wJADMrAzg@mail.gmail.com>
 <794095b5-e9ee-4fff-8e3a-1e6b98e670a2@lucifer.local>
 <dd304877-1010-462d-bdf8-9d824250a05c@kernel.org>
 <9306c37f-bc7a-4a7f-931d-452ef6aad358@lucifer.local>
 <aVd-UZQGW4ltH6hY@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVd-UZQGW4ltH6hY@hyeyoo>
X-ClientProxiedBy: LO6P123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8253:EE_
X-MS-Office365-Filtering-Correlation-Id: f3e68dd3-1424-467f-8dff-08de4a16892c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?emzskYYdohLTcDs1hIecz2ungh/yrHdEvlxKCTjUpK6vMXNXYNfSSW4kQPAt?=
 =?us-ascii?Q?R4nEQ7d+TmvY3farQkTKyUfoWfNx4nCsIBkAJ0LZEsZaDu0eKh5CMsGf+Jqh?=
 =?us-ascii?Q?kmzxDKYE3i0QGZQ2VRx1C3gnWlRz9Rr8T4qXLomAYO5Xf1sw4bSaLkYcK2ty?=
 =?us-ascii?Q?APG/u09GwR5eBfIYmTwh0bNxXPqkmlC72Hr14dorrZkAs7Fb9++l3b+/LSyL?=
 =?us-ascii?Q?KWvyGZtAm1tJCiyKm8H043QQI4RHvFF8//ww5kqo/lK1SGZrUwOKt6Ph9oYR?=
 =?us-ascii?Q?AHip15x81oBFBDorINk1TEd/drybRZWk9lJmOXjnTRTwPtwVn1smiGvk8aQg?=
 =?us-ascii?Q?r2Uz02miOhSU3ToK8ebgxirtmnJXapPm2QXR9AUYQvArstH8nT7jz+DUU1tV?=
 =?us-ascii?Q?MIMyklgX8ZofDTBoaUudP4CbzkBODm/F0JnqFRAhCCsXWCm6KhVzpFVV/XAA?=
 =?us-ascii?Q?cC5bcsHaNpy0sar/DCPmXvWEeibZs0qhrgks8Sf4u4efcq12BNo2FDrOPSfr?=
 =?us-ascii?Q?H93dZ93vZNOcK8LLZiadAvw0d3JpFuz4cM+XF7asE7mufRU9YduzSnECfop9?=
 =?us-ascii?Q?9qG72MVUyunSl/MfwI6wJpyKb+2EGDkAUw3/nuWb/zsaw1JdtxCmVIpLkgs9?=
 =?us-ascii?Q?ufbVWlEFgEhnBbtJW8nEUSj/aW3uaT0Z8Ox2R3IqN7zGHvR81qtl3gkbSxgT?=
 =?us-ascii?Q?633JbS37BhHF/a0vaJVNcXuUy2HFDTkKCq/gLac7WWRvOZ19Ez/2gu3Tbn1k?=
 =?us-ascii?Q?HXifC7lY/NLHit/TtnkS4NhtClEJBfFz8Jpzk/zVsojhcWBBPL1hUoYJxJec?=
 =?us-ascii?Q?dcNq8UZzHLt0gLHh/6h+Ka6MTkqhY0+a+wSZalxon+E3lDv0FMz/5Las0JyD?=
 =?us-ascii?Q?eqtJXNG6QmsDUkkDrwxX2uQEo3TTA10rA8EHlnT9tCrFteACkzL+pe+QAizc?=
 =?us-ascii?Q?KyK9cIFIGB9GnrJbrTm85lhq1luGFFFAo2v+YuL6qMar5Lo+5Li5g231gmfX?=
 =?us-ascii?Q?NK5EhvNm3meY+2g0uR0/5liq/3bMJuD/QLg+TKkLnzfufbsEp165qN2I9Kgr?=
 =?us-ascii?Q?bVRJWyQxvRKkkeo068ya39+q4uNxzuzWF62ri8xIPnfntQ8oRAIhIX6HvIeU?=
 =?us-ascii?Q?wEIJViyyL3VdBnWNf900R8nanHRYZH2Y+pSYD7JOwA/N1O10Ts+rmhsjBgHE?=
 =?us-ascii?Q?lukI8M+gtiM5SIsaN399WVHGrnj4Nos0cw1MNzSjI8uCYd8EDPC57BdVBS3w?=
 =?us-ascii?Q?AveZBEfhLpaLpxpzdKTTXMrRWX0XfcTmedk+idTHBj2IuFQnf1/TI/mgWHrf?=
 =?us-ascii?Q?Tj9vCC6XMZgrQI5EPv+iY/o5R2SXNzuuwCKlHPbRTxSFTm+RFWQT71mudfKc?=
 =?us-ascii?Q?7rxK96QnU5E1GAkSwO6i87CO+IsBmdQ349OD7G76EZAKuKJh6R7eudZdz1PM?=
 =?us-ascii?Q?oPhz4DMd0L5flgb38q2Osx40wNvodaek?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s7GNI7/8O+doReMiaz5hw5ocxznMRZVLxNnjBgWwqBQo/6z/ENI0rIoFLqu2?=
 =?us-ascii?Q?mpPb8JQYjEeGa2MpDI3dABSIKpJXQMabVOJTTYXuin/t2hLlEtUXvdo4N1nj?=
 =?us-ascii?Q?xONPzpw5HUf1pVBb9pb5Xr61IBNQ00pkvfjt0onKpQg/OcHVF5YF7fKBlx18?=
 =?us-ascii?Q?y61OLnDgw2+GT2DNDpKAFxEtBJBs0M3m0dJHVbolrKvp9ol5V7AIpQdO/62a?=
 =?us-ascii?Q?gWCEV28XYlc4R8UGkv77aZuGAtXVWBWNZ+zpsCabvjvumzD89pWM+x640pC5?=
 =?us-ascii?Q?ObGEYMnZfmZrZDHm2MFm2bU3KOE8eK5erfjhvBoHpCXsBN8DCy0xjW0Tk/Kd?=
 =?us-ascii?Q?l2GT2DaLH+001Wlm9PgcH4Tjj5FrTf1VYyp6jGFhywL1klv42XcHLnihDbT3?=
 =?us-ascii?Q?r0VxAWFTXmwd+o2vi5iTc2CLYFXKpt6xVDJoH0TorWV85rRlBRVYoijbkYxL?=
 =?us-ascii?Q?hyYPzgqCY7JLxyJmzcdbJoifNZUVixu2THBhxQ/dzYnYrXbWj4IJN/jqX1sN?=
 =?us-ascii?Q?K3l8AbnVLZg0jyHovmuq81soT4PbTXBIXUiPb0PnluWOs2bKmUupZgpZAxtn?=
 =?us-ascii?Q?ORfdUpzS8prxNavzW3AnYazWlzQxCDUrFyV0ZEZe6OTauPExWNbSZfE9yR3z?=
 =?us-ascii?Q?XtmdZWuBVc6h/GaquUCpzHUxcX4NCSgYhRUlvS4NJ/oJBAnEHNKWXddtqgaN?=
 =?us-ascii?Q?P4TXZ8ju2DNSla61ZLhfVmVNgUKm2oUTeOL3SlK3ugXW/Dyr8WPXQKdpeXNe?=
 =?us-ascii?Q?yIqTA+Ush+f4Gct6UgIGi8SrL2uHzkx4XBNjmW52ThJaQyjTKBKz8jbt2mxt?=
 =?us-ascii?Q?9lWtcov5rgcDMFuxj1P1+nWMTl5Fx+IgIpryxhE9bbMFEFQ8IsMi5HMR7IdX?=
 =?us-ascii?Q?jfcW1dnVIfs7Fb8b23c/hEU/7VcWDocoSQ7MGcVPzh4PsTgtmffBb/gBqBDF?=
 =?us-ascii?Q?G2XbevYJ8GivAj1/M1UDAcMvCQdKq4g/Tk/+L7nCJL6SgoeA3lA8vLG353BX?=
 =?us-ascii?Q?IIaFYYgKrL96qD8fTcK10eJcmP+1uJbKYsSJlsMtrsP77ALN8JpKVBedGcxY?=
 =?us-ascii?Q?CP3G0DYmoPCpkuHkng2z2SQaSuWWkM5z0MHl4GVSzq/9tJg6ukS/VwBxLUS5?=
 =?us-ascii?Q?nSLP3ZHqcxreJtOH5YzTfSCGvjopn7XS9uqpBbOXOYC+U2bDHbDJznKbCDuX?=
 =?us-ascii?Q?NlBb2xFQUf9m2jCO3u2p0ZwmlOOckk5CwohcpXKe7Np/XlfVhKPDhQRx7s7B?=
 =?us-ascii?Q?hViQtKOpKPor6MT4yl7R0odoRF6CGeqKdUmYLwRX4+Fpx+Wh8rJlsbFxbvLP?=
 =?us-ascii?Q?WtNRNbiTtFXfqaRjV5oE3/XTxp/+s0b0BUff5Z5WF2iRfMaBJ/WEeS5CyBxc?=
 =?us-ascii?Q?wusL1FeDLXaNIwVjeSGiGTXfU0t0jiBiYszdFt8AqKC4RxVulef2ouiWdR/W?=
 =?us-ascii?Q?z2s1LsLfdahG0Fu/O/NKP0X1c6LQYpHRf3fMNTFJjhAhv97YVbpKi58FcQay?=
 =?us-ascii?Q?G//HqKRea3ATJD1Wn+2MSNQ6YZmumM5frYBV8kSqk/LkyVex5V9rd7zlpV/g?=
 =?us-ascii?Q?TvE3zMS7xAcqzrImB+28mIs02NPRIxQOx/Peef5b2TuVzCpy7a4PF6HfRF0i?=
 =?us-ascii?Q?TdEjA+lqkdoRsUJArzrLALyB1OgfqvSTH8XCRCRMbcwvbP8V1b3Il/c8Omuc?=
 =?us-ascii?Q?6jIjEHvR0xKcJ5t6F2WXaUcyhXxkJ2ge8F8D1kVA3EbwGZ6ySWS59XwxkMzf?=
 =?us-ascii?Q?vwIJcrqiLkLD6kDPhPgk1GsOwGSc+hE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RDnufCMyqm4Gq5B3h/Uhav2UCl2zGTvpVKVPIlg/8NK6U8W4crndbJ1YM37CuAxfQm/9XQaUErP9jxsKgVF08rGEEcJZRNILsDNLiIuXwlMke45aDmHemotCRNqYzjKweDuIbv12ayDsWFa6dTTx3WJDasEMaVanocLAHL2HUmmknHFvIZ97ahOcAs4pBtYHvfK4doI+MIjgEwaqgrg2AhzPRjNssHfsvgVJDkiIT//ccZUf0EfhrEJ4xUV6djcFZ1d804mY/TIECWY3NDSShUDysyK47okV6Vxo1nSjYvbYdWfN36UuZ6p+Dq4ieJlltccGRjHGqVDLyouZjd5jgOa/E2FRlP/q4A4YMeQZGndpkn0gwnAbRSKgWyYih0xC0jP17r2qKXgi5QpqO3LuS7QxMSkNWsQnGHFf9IXsS5vIIz889dqJPzvHRWAOIxl458n69cyA37e83pw6IyU1yjizP2ueZmb78t91d+8O59NnwuDXIof84WzAK/zKWGf6ndXC9CzJlJC7+HQ6DOTSW/QlTmn1/LVJi/5CY07nPM4oiBuO+XHOLh9PdBbqvGhR4Yk1F4ersUnBBzCFfQ34UotSRtVdl58089NL5MZVPHs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e68dd3-1424-467f-8dff-08de4a16892c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 15:49:38.5650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N6aguG4Ss7uvtGI0Goh1dcGoKEwpKAEHH6El5OYEYr9jGq+cp4P+fqXUoKpTfZ2H9LNZ0C6nz9/UzDwqunemgRPB+y7YZuOtRhuNn+/PqgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8253
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_02,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=996
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601020141
X-Proofpoint-ORIG-GUID: EKsvCfftYxgXLTZEQuioRmt8tA3hDNRy
X-Proofpoint-GUID: EKsvCfftYxgXLTZEQuioRmt8tA3hDNRy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDE0MSBTYWx0ZWRfXwRJiGl/iGwRU
 P/u+y6uCMmvM44gw3/LP+OylQ4oKFIsRIRJosHxwRQOqV4WY2qJ78G9zkZ6UYPtD8YmwNZLVfpE
 t+6LK1/RMf8E1IFi0bI1ktNq1MeQhTVakZgWb2TR9IDKClZkGtXQS1fUQQqCzBcbzom3/uFiVgp
 psFbNkVQfamDL4Kfp1flfsw8KVpqSjN8jtYfvJViEEA1/VbmuWPsNOBv4ScZqs32jrp5+4vuceB
 obtUf1Wv6Jv6/LhV6OcFlH1DaRMp4yqwW6LL9g8mxIG3KhNucg0E0BMzuL7K5SsQrZ2QeLUnBe2
 1dFRm+5MWji00AbuofA0fdcis52BY/zCI6uqCLa5u+IpqmHAsO4SPbPHWne6AtJscvGdYWm3wt4
 rZ3+ni3cnAmQD0oEpl2BvndeIJmIzz+QOzivUJEXeJRi8zKCEsD5ZXLOpDQL6QvelEaYQY2Ycez
 MICRGYFi+Y8I99/1IaQ==
X-Authority-Analysis: v=2.4 cv=RY2dyltv c=1 sm=1 tr=0 ts=6957e915 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=2C4injTLmrmYa46b_KIA:9 a=CjuIK1q_8ugA:10
X-Stat-Signature: hgs8uh5og6wzjinjuwbimi6qy6bj39ni
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D15BA0009
X-Rspam-User: 
X-HE-Tag: 1767368987-465837
X-HE-Meta: U2FsdGVkX18q/Slg8G/frJjU4mH3otJc4J35ZzONuQynftW7dRv0NOqdk6/KIO+r5t2zTEoVGofPMJo2YG0X6TyNiKnSYi4IV5ajnpdTqx2FhSwlKyn4ccGdZJd77SoRDrXlfA3e4pEJkAOfvETTgQ9MwK+ZbbD5rNghdu9bNfXQbmMCAptnxNYBfakI41zY7o4bKGIrKLmMatuFhivr+ZkgwduaWrNvQsUbrK3GS9LPU1C1yY8ykigmpa4Wu9bNwnj8J9J5fIyGj155OKZ0dC5RM6PLXPrwx1FflXDKWyRkC9NGUTkm/qAeFMb+NNrRcbvrolLo/90dqxJ9K2Z7BPJjwawEzVbX+neJoyLfBlj8MgjoMMndyF08xYMKvwtO/PZGYqTg8eBT1BGVUBaOXtbLNx+EpC4iFuxlt0YwFYJ/7oujhvA2xDz8tA1cLpLnmCLoaaJRU6sBaoV9MWiPF6EsifEV1tG4oqYXG2/+4o9gNLki7Httx4ATg+E3iocuH4P+hywDlLfuOCelc/i/RkXEIz28pcNQJXccN3TJ83HyitFgcnAGhpeRTJMQ4WjY3Oo1xWbm+vH8wta8U8qd0VuTPvX6C4tB6CIZ0kqCxgOtq29jGmNquxtoLMhK6OLOP2oDsQ4xGN+FoRwnTbtb5EEIKch7nUj7pJb46frykF8X+ihMe/sTig4JyLRRFeJcybbn3lJZ0GfLRSG+ISDufC8Meuho56/cxXyKBJnvpEvdriwLd1InkjDe1ANfLGBr6NFHImCJgjoJsSeNOsTiV6eTsKor7DhsuLbJ+j4mmJykDE2v8JRubvne1cO0zbDs5kRTh3gzTg2zAcrQ5AGeCcRNYgRaY/4/2YDtHu298UazgX5GdvZhJ+/FFs4YMjFmrmE9Hqpd5r3+gkwV09Krs+DAje6zmZ2YMpYXzd54al0Ak+1vXmVWo/r1rewjstxEN8gD1A3DnSYAdUQ8TqI
 H2x1NqyY
 vrdAPEEInUf1jqGeiCBZvDXFmdiRLACFlpn6/gEnlpYbvQjWBzB+sqLH0QBYivihP7OwYsiSeUGuaXPCI52mv7q0Y2Jdg/I32ai4neSGabv0r9lhl0x7FaIw5UDWOjV7MCk35GBBgDAr8VngeehSbpxrpVX4NdJZdvS2SVl48m2yo8QVxuxjQpfHBSllTtwjXCJ/X8lLlxhOudtHclN7xcI5FMDGGDGeSku7KX+Hm075kUyM2weRBvXYJpNrPxxVGIRdGjMAyep4RRDLIxIcCltoimW934vRjPJCQIHZX44nTcxN/nW+u2S3JX9O/QmTJLkCVc8rZb5uoMiV5A1SlA2NC5eHWNSKJE9ADCawkW7FsY+ZIRDEjTkRQ8YgpDZmV34nXoLns1tzB+pnPNRxLCWoA3mUSWzQEULOADwNYr8/4BKNiDP/6s2uOMxi2bfe+JWZf3OkpnsbVcEy1KqAkXYWf71lb4RlTJENFrw13LJ5x+3eKnpUwl7erZ9ntoWhqW54ubiC63RSqG9+r9TrlRziTstbSMajx1pu/r+CFNkcsdqMkaTKvcBdJTPYXRgm9PALcg18uN8jDQs2ZIA7aVA2FmE9LDYIOHBcQuI0xoC2X2xaxYuw7VWiSiT53TLcBrJwizrbwyG3wuE4i/UOv1PErql5hRpOS6D4dpBA4npDtQb6EfJirpwR7ubw5DdwfefVjskfdc1yQgCyeC7ZlZWqd9z1HunbdKSJBti5o2IiI09rdEpa/i0Xgl+su8ZG7O2dO3n/0moIPVI4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 02, 2026 at 05:14:09PM +0900, Harry Yoo wrote:
> On Thu, Jan 01, 2026 at 09:28:46PM +0000, Lorenzo Stoakes wrote:
> > On Thu, Jan 01, 2026 at 06:06:23PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 1/1/26 17:32, Lorenzo Stoakes wrote:
> > > > On Thu, Jan 01, 2026 at 11:30:52PM +0900, Jeongjun Park wrote:
> > > > >
> > > > > Based on my testing, I found that the WARNING starts from commit
> > > > > d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs"),
> > > > > which is right after commit 2cf442d74216 ("mm/mremap: clean up mlock
> > > > > populate behavior") in Lorenzo's mremap-related patch series.
> > > >
> > > > OK let me take a look.
> > >
> > > Trying to make sense of the reproducer and how bpf comes into play ... I
> > > assume BPF is only used to install a uprobe.
> > >
> > > We seem to create a file0 and register a uprobe on it.
> > >
> > > We then mmap() that file with PROT_NONE. We should end up in uprobe_mmap()
> > > and trigger a COW fault -> allocate an anon_vma.
> > >
> > > So likely the bpf magic is only there to allocate an anon_vma for a
> > > PROT_NONE region.
> > >
> > > But it's all a bit confusing ... :)
> > >
> > > --
> > > Cheers
> > >
> > > David
> >
> > OK I had a huge reply going through all of Jeongjun's stuff (thanks for
> > reporting!) but then got stuck into theories and highways and byways... all the
> > while I couldn't repro.
> >
> > Well now I can repro reliably, finally!
> >
>
> Great! still not sure why I can't still repro :P
>
> The most viable theory from me is:
>
> When we call mremap() and move VMA A into new range that fits into
> the gap between two VMAs:
>
> [ prev ][ new range ][ next ]
>
> Let's say prev and next don't have anon_vma, then
> we're supposed to link prev VMA to VMA A's anon_vma.
>
> But looking at vma_merge_new_range():
> > int vma_expand(struct vma_merge_struct *vmg)
> > {
> >         struct vm_area_struct *anon_dup = NULL;
> >         bool remove_next = false;
> >         struct vm_area_struct *target = vmg->target;
> >         struct vm_area_struct *next = vmg->next;
> >         vm_flags_t sticky_flags;
> >
> >         sticky_flags = vmg->vm_flags & VM_STICKY;
> >         sticky_flags |= target->vm_flags & VM_STICKY;
> >
> >         VM_WARN_ON_VMG(!target, vmg);
> >
> >         mmap_assert_write_locked(vmg->mm);
> >
> >         vma_start_write(target);
> >         if (next && (target != next) && (vmg->end == next->vm_end)) {
> >                 int ret;
> >
> >                 sticky_flags |= next->vm_flags & VM_STICKY;
> >                 remove_next = true;
> >                 /* This should already have been checked by this point. */
> >                 VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> >                 vma_start_write(next);
> >                 /*
> >                  * In this case we don't report OOM, so vmg->give_up_on_mm is
> >                  * safe.
> >                  */
> >                 ret = dup_anon_vma(target, next, &anon_dup);
>
> For 3-way merge, here we're passing target (prev) and next...
>
> >                 if (ret)
> >                         return ret;
> >         }
>
> In dup_anon_vma():
> > /*
> >  * dup_anon_vma() - Helper function to duplicate anon_vma on VMA merge in the
> >  * instance that the destination VMA has no anon_vma but the source does.
> >  *
> >  * @dst: The destination VMA
> >  * @src: The source VMA
> >  * @dup: Pointer to the destination VMA when successful.
> >  *
> >  * Returns: 0 on success.
> >  */
> > static int dup_anon_vma(struct vm_area_struct *dst,
> >                         struct vm_area_struct *src, struct vm_area_struct **dup)
> > {
> >         /*
> >          * There are three cases to consider for correctly propagating
> >          * anon_vma's on merge.
> >          *
> >          * The first is trivial - neither VMA has anon_vma, we need not do
> >          * anything.
> >          *
> >          * The second where both have anon_vma is also a no-op, as they must
> >          * then be the same, so there is simply nothing to copy.
> >          *
> >          * Here we cover the third - if the destination VMA has no anon_vma,
> >          * that is it is unfaulted, we need to ensure that the newly merged
> >          * range is referenced by the anon_vma's of the source.
> >          */
> >         if (src->anon_vma && !dst->anon_vma) {
> >                 int ret;
>
> I think the "src" is supposed to be VMA A that has anon_vma,
> but we passed "next" that is unfaulted, so we don't link "src" vma to
> the anon_vma because both "src" and "dst" don't have anon_vma.

That is nearly it, actually well done! You are smart :)

I am going to give a full explanation in a little while because I've
discovered the root cause and have a fix.

It's a bit fiddly and want to be thorough.

>
> BUT we reuse the anon_vma anyway, and by the time we call
> dontunmap_complete(), the anon_vma gets freed because its
> rbtree is empty (which isn't supposed to be empty because
> we should have linked prev to the anon_vma).
>
> Does this theory make sense, or am I confused again and my brain is
> misfunctioning :)
>
> >
> >                 vma_assert_write_locked(dst);
> >                 dst->anon_vma = src->anon_vma;
> >                 ret = anon_vma_clone(dst, src);
> >                 if (ret)
> >                         return ret;
> >
> >                 *dup = dst;
> >         }
> >
> >         return 0;
> > }
>
> --
> Cheers,
> Harry / Hyeonggon

Cheers, Lorenzo

