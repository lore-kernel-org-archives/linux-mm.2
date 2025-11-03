Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46402CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 15:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3715B8E0098; Mon,  3 Nov 2025 10:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348EA8E005A; Mon,  3 Nov 2025 10:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9FE8E0098; Mon,  3 Nov 2025 10:14:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7638E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:14:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A78F312AB39
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:14:31 +0000 (UTC)
X-FDA: 84069642342.06.E1862D2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0B26CC000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:14:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N7QXWTPL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VSb1LrYT;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762182868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SccokUiwL+o3MfAdIUSileD5iAjZAdWPsEevy1dGIhc=;
	b=3w/6W9pqIszUQY4dOm7Zf+fl5V3aK9ITmrGSKWcJpSXByBczo87yOhdV0fPAK4k9HfTfiT
	pkLlkbwv2MXLiDgpdaCwi4zp6wpsTrkQBUiTcrY8e8zDOcSrNcVNPLnM0qZcJDEQ/PZGr2
	axGqOMD8LhDGTlz3FfUu4if4mAVUnDk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762182868; a=rsa-sha256;
	cv=pass;
	b=ifX9jqT2lE/tZC8KO0S7Z26gJc0gxyBFx747u+BfgxYXwr4cmV8l6V527RXUYNo/kBzudT
	iy5NnNhbJMQ1b4AgoRN7OQiHadmdGzRqqN/RE+9IYAvMoURdR2mn2+8Q3QSyd29DvykCkj
	SIQCQKlRBye1I089WdKUyz2snmIOjH4=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N7QXWTPL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VSb1LrYT;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3FC9bU020699;
	Mon, 3 Nov 2025 15:14:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SccokUiwL+o3MfAdIU
	SileD5iAjZAdWPsEevy1dGIhc=; b=N7QXWTPLnRkq6pa9TeNcjpdUF64fynbAgL
	wVhtaMkflvb+RAlkKZLlN9Sc5hJXMQqeUhkoRpTJZXWRRnNI23S+hJnLDWjoMD+9
	sKTaw/GEOpQmkf5qT/ZqYdAIab6StiCKvwDE5A/vEjIIZ0GuAuqruCB4P+do4qb4
	eGg0sjFwrUy3IQdz2CsNtI/nNUD8aRPiSo6ZQZb86oKUzMFDU9lQEtcpmFMfcE0Y
	kef+dn4Wd7Ri1NyWUaHhJTVQvx0RJL/C8CYB6kzQE2y7W4tJgYlzFtLhe87kVXZ9
	74gYj1NmFKaE3A7hMrFCTKg7AHE5w/ypmfVJMsZSnrciIz1xma9w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6xmyr1vv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 15:14:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3Dj4Na039842;
	Mon, 3 Nov 2025 15:14:17 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013038.outbound.protection.outlook.com [40.93.196.38])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nj1wju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 15:14:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZBkjWuSKUAJIxy+PHGgxy4kEAYvvI6Paz9GGLrT7BwzoheGm9YNsqx5EAAPvNcb8lwPKKml/bk2u9DMUNv1eHkUw1nAT0bfj6vX5HFA805+f05v89nayO3mJRpE4ymJYIchQieBFJ76GSfPSYF0q+NEld1KA0KYJAzgCCmxgWRrdkDCU+BFgHtXYztpKTM+leaud2gsxsuMfc9nu1gi/mwZ7JM0Abdd0te14UYy4Mwe/7kvoTxv62k9+/7DvF5R09yKtS8LvD/YGvDoNEx5UFaY8q+ZsDBbJ7aKijn0U3BXt44bzfvtep06P2vZRdquIjI17IhdH9KfQ/OL9EgA8GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SccokUiwL+o3MfAdIUSileD5iAjZAdWPsEevy1dGIhc=;
 b=NmIcTyBlI5AQgUabhC3ze6/pXqOiR8LS1pp4AqaVlUFW65ryfcjGPW1CsRrJIFPdRUFOh/0OGTaABfXEDeSAAmb2Emcxn1llmo9UC3iiw2yIKybV5Q1VppMPRLqiX0moFzbcsBbNKQXIklZVEYQRS/ioBkRGvCKc8qxaMK0g3En1sbwcoraCWi3rYTo/ReJjzNPmJnSOFbsw6Nvp4LAYt4mlOnQu3X70EhFxgq1/AdFL6zVEg+aK3FCtMCobRVNqc19kCxeDPlTr1a+u3EvJV5IBG/Ooe9kAVFTUND7v9BfgOGfdME+MS+dWIW0J77TeL2enLDmhnwI6dMkVtNl8fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SccokUiwL+o3MfAdIUSileD5iAjZAdWPsEevy1dGIhc=;
 b=VSb1LrYT43i5vjIV5cXhN61X2iIRUqyoI5d1JhIcQtvZjEm+Qu5G2yHcPDWclBapEsKA4nwDHNWDJOzH8CuSjcxu7DOPQ5wO4mi80IiBzs75SFoXvkP9Okv9tlqkRJjdUStyo/cvSXXraYyRR22L6nhmt7yg6/cvTByGsYgR9Fo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7394.namprd10.prod.outlook.com (2603:10b6:610:149::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 15:14:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Mon, 3 Nov 2025
 15:14:13 +0000
Date: Mon, 3 Nov 2025 15:14:11 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 10/16] mm: replace pmd_to_swp_entry() with
 leafent_from_pmd()
Message-ID: <20539e28-d646-4ad3-a593-b60b368be449@lucifer.local>
References: <38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes@oracle.com>
 <202511032203.LAN8NcTM-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511032203.LAN8NcTM-lkp@intel.com>
X-ClientProxiedBy: LO3P123CA0020.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7394:EE_
X-MS-Office365-Filtering-Correlation-Id: d0f61267-56fc-459b-a0f5-08de1aeba5c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V55ydN0d74dRWtfx8sNXDZQyhkjqU+TTLI/sc0WPSDoY5X7HyuKyHqySFrHO?=
 =?us-ascii?Q?qFg3+X+RPyKvQXgWqVl/NPv0tIz2md+LPJrYxk7N4K5q0m2+KGPCyuuJ9Zaf?=
 =?us-ascii?Q?SNNDRdkEU0Sdsn1OQWT6wiFYmVyLNFOT6JP+ZBB8zmB53M+yEtHqeHTpbpTd?=
 =?us-ascii?Q?5/kwKNupMjvYydMJ2taPtufvxpVMgRuCNxhitx38uRdCcrJrucfMOGwngpYA?=
 =?us-ascii?Q?kxvr+hHpS/bumFRikPrZ3pKJraWd/P1tyXIT+jwipie58qI8Q9CVS6VKjdPZ?=
 =?us-ascii?Q?PoigSYctf4xtFA5ur2ytUQTlijW+yDfwUqn3Cl6gTAFvc+33YuyNehLPlYxd?=
 =?us-ascii?Q?XsGoYqybgkThK3xfPQzV6taPrKnV66qAFPVGorBOCvRXgzuHSMLbH58RD7Nh?=
 =?us-ascii?Q?POZtTJ2arw/M1HHz4yQEGgVEjK5Jk1Oe2e7C0UuLRRg2Tvbt54C4IL/dcS5f?=
 =?us-ascii?Q?gEGT7+ay/89Lab+8k693omv89/jspM3eJvlzREbw2NGNAF6zJBT+5wfyJUzf?=
 =?us-ascii?Q?Z32P36YwQMG5S4J3w+SAYYpEcuHwPwvAKSZcPWjO9gR0fu8N0qrTczLBSUx9?=
 =?us-ascii?Q?z+wrasWpmagVrnN9sVfiJMUc6c7iMVEkLZdpeuJAGKb/P5wP+3Ulw09mhCkP?=
 =?us-ascii?Q?a6pTwVVbwS4s17KLPmSVjDv6wSBO+c/a0cxf6SFpSSl2ux8z2s5CdMoVanUu?=
 =?us-ascii?Q?5IOAMfZR2qoFgfFKwevaMcxxgZc9ITWkXGAO/TxLE2Wxl+T3/E6Dl1MWrHGh?=
 =?us-ascii?Q?ghpA0z8xpCNCjZ0pDHvhhEdFUBhiTyy48pZ6DVtxmbAGutUtoEvjrGh49jmL?=
 =?us-ascii?Q?FO/sVwbo1TfUoEtZu24ouubooeZzhvBuEyNmzxXbLkM6w43g3lhxOkGuyi6+?=
 =?us-ascii?Q?fdjJWZmU+fANPp5O+pamAalH/S8ihvDnx1oLMPxmkKdz+GLsg568EGWpx7mo?=
 =?us-ascii?Q?Lx1EXPzclkSck1uI7yi5ZX8fsgKTuYMyvOJffHOvqRs4GVrkZDGfE4k/wIaV?=
 =?us-ascii?Q?eGcQXxibspmd6Cu6KzZa5SKuWu5xSM3Cs7aThHXBQwvCxToiTbBXBuucuCst?=
 =?us-ascii?Q?sNt3nI8jZ2YNsD+/S9M2XQUZvVP+0xHBupLx6oaAKv9tDde4AUczDIjm85/9?=
 =?us-ascii?Q?8q//tadAwTwzWguHvlMPlt26tV75100/NtvXa+ZRIyJaCxsJfAjqDMYVup6x?=
 =?us-ascii?Q?GTwF6Q57QSww/Dj2z25jp8YM8Nxs/U+p+MW/0HPJapzGXNTCcWJqndhKtU6a?=
 =?us-ascii?Q?nf9yvs3WrTlo5p5HpT4ZqyHkpAMP9tJuOMt/KWVPb9s7Ir/fvozGCduVD80i?=
 =?us-ascii?Q?MAGCIlXYQ9LnIkNLtRGmuzdYARySPtFsA1Y6C2fVeC+Lf+oOWcGdxOE+6fCX?=
 =?us-ascii?Q?vJUwgyVJeDPg4AklVd7dLk+igJ60tD0KoOigapkSxKxYTHpZ8otnz8XcJ7G4?=
 =?us-ascii?Q?Pbd7IaxSr+0uT9m7MQsi+HV/H+1tIPQxspJvPtJwdhE5V7gFqPzJhw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CvJe9b7WUFEKV0tovLL5mC2qJbj1KfbnCUUxMDl0udNElDTSTsbF4XjQwiIl?=
 =?us-ascii?Q?wQbkbC5o5hBoP0wz3UXMbSDdiSwd3FL257FVCQoPK/VX3uhW0CjcbXurcecH?=
 =?us-ascii?Q?rXlqxpvbGufRRlJHOM6Fci6V3K72V+bcU8F9kQgEul68MY1/08GfjaULvgMy?=
 =?us-ascii?Q?Nby/50M9NbTZ5xze1MO4HKlgm2Y+OcURWJdCaRZnLQm1XVUwxQvR1V7PPXWl?=
 =?us-ascii?Q?1fWQhOYpYbEEbS4/G7aeeLfDqt+LRAc3slKoxEjbPqgxDSXKx1RjlbXQWv1P?=
 =?us-ascii?Q?43xOC1IvT+3dfkWAW67vOLVKeBt+4RiSWFNF4K1JPxCTSGi3W+iDzhdFB5Ui?=
 =?us-ascii?Q?ac0wG5eVqLrZwFZ2Huewf6zsZOdUWipLSj+6SN0NhwcneexBrUN3CxjZi/WX?=
 =?us-ascii?Q?VoSXqstZ1uTW5J2ecwaaVuIcH/J5TQSUapjVb40gcyUweRaWuH6lM7Qn3xyI?=
 =?us-ascii?Q?5BHsg7SucbX+Iql8HRP6w9wr/kOWfYoXRf1re3vfehiulkMSVNIhw3ATprA1?=
 =?us-ascii?Q?iOyKt52DLCFcw2e9gwWyQSiEDiVBRS5/vWKocIEQHiwAmB7uZ6UajhpkXyCq?=
 =?us-ascii?Q?A79VULCdnmf15F5CVylh2yG/cZBhqsjtte/V/eG9vlK92ry4DJkfGzLD4DV+?=
 =?us-ascii?Q?8VRr/GgL6bLfaza0LlxMKvLvCcDgpuH1QMr1NQhl3DL9kS/RPZFhI9ISlyHA?=
 =?us-ascii?Q?7KIyX2beRB/nIxWLyNmJiLeSnkUwzEA0hN2ods0AoTdQ+WfzTusCcYwJL9Lj?=
 =?us-ascii?Q?reDmgOrPIc1L2VAc3IraElXvVh4mcnc9I1m4ERCcG+DH5mIy0Vxizmy4CyGv?=
 =?us-ascii?Q?eAYkCiA+UfogoCCXUnkAcEp7hIBPYloBbPkQglVj6Afw7kmbdsvwxjx+b5DW?=
 =?us-ascii?Q?oN3qMWbV0KlyqMdztQeGB1K8qh9G24UbvH/zVmBf05X8gGAZ19bsVI4dqaKX?=
 =?us-ascii?Q?PQy3dzrirMRy0M1I+Jx+0Nk57rg+bpBbnrlvgZqX/2WJyFkrVMlk9O/D43dH?=
 =?us-ascii?Q?M0A8d7YKKlcX7wmpsWmbNzT9bYhysw3UuxkYx0gNYxgRfiMUXFDKWv6fSHou?=
 =?us-ascii?Q?3rpc77vy7YSLKR8bLVeLW7TCgQ0i5uS4e5GzbpIwWMb+B9qyQ6VWhEv61tq/?=
 =?us-ascii?Q?XOSc0pist/HyWXLtKT2sJxRvgzKTEn5Muotx0erAbokPu40bBGjJ0wpBy5nt?=
 =?us-ascii?Q?9kYJotjxZx9C7T4suJ5zHUGoArhwgVCB9xRrXuAiMt1Pbxg31MsYJTX2aYww?=
 =?us-ascii?Q?Hj6N4N7KrV/j7i+RdTJtlP6BMDeaYFsKqV7qusGGiLpLHulW0h4YMMJOsi6k?=
 =?us-ascii?Q?HDLOL41do97sA4EbvXA5XQgVOdFcFbVd67cJ256DAZNYA51CWoN4IVnm7tHE?=
 =?us-ascii?Q?HNSZLn6vzw6/5t3cBTHQy4OKKaU93dA/5KGP7XXmmy0H9bncC7ME3BJVXkKB?=
 =?us-ascii?Q?Di2if+zJIkCIScsR54bHpRoVCKFF5UC8G2FODUW4fHrSNVY1yCgy1h+JhTPy?=
 =?us-ascii?Q?4TJpwtKXU7C+br6RBVQLJ3BAdsGHFGV0L3lRqqzFpxomciWyGSLBJXpyo/KG?=
 =?us-ascii?Q?8ah7L3DElgW6R8kPcjrXpfojyr9OhTUUzL9u2ZxdmcIkUypZehZKPKTnhGpV?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sE7D0rwbuUwhB1nvC5b1QquFn9ffKeOHoPdjRzgH3VJ69ARuksHy8+VYeI0Z3nxzsbl5D9StyogYLsCbV1buuluEAIBfOoUiGPMdMc8OE9GfRuUkOCoteD+XeCDY2086sm7SRNJAO/sqda4+Q0qkXZGaFm/FAhYiSByFjuQ7YAGWOD4hTNpfM8YGnXyST0XGeq3n6mkdv+DJEHvepdHCUSkTaKOD1m5rOsZzqCohcSC/eFuuck2CEn4RZttge3G7yH8zdi7jf9/P8vnD1srYLW1tUPX0NF0cf3bis3GZmvPPahTiSzAPP8c4QaQ3VcTfkYM3BaD6QMpO89Z0j2tiB/rS5ZstHiuP/e8mkoF1F+pO5IsRq1unI8JeMj5OaTLw2aJv4gEGJIXwRm+IETw0ezvt/CkugZ+8Fi61Si1WBKtsDaFGUiJM2ZfPS2HhX9PcfJwc0YSi4HUIUJQVBUqCYS8+R91wYkswhBmyLPwF5/UeRBQdE1JjRIg2FV4JrFw4Dne1Dkc7HeQdvWl5RnYrS9Zfsnif8vjvwQ+lhMv5fuG2cEtn9HixaIGYFg1CwdUfU8ub10YU+z/Bg9jowaTKoDiZ+hbB5g+y5QKusPCpUrY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f61267-56fc-459b-a0f5-08de1aeba5c7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 15:14:13.5840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w5wpRlyEHsmjIUfPtqW2sFd+low94IgBfVFtncKMUKMw8BnKqufYh8ZywOYzr62fKfXMwXyEc2xgPEXJlKk5PJdXDsBb5EnD3E8NoQbWklc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7394
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_02,2025-11-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030137
X-Proofpoint-GUID: d8LAmV532AusDDXTp8Y1o88Yc48UPvB0
X-Authority-Analysis: v=2.4 cv=Ts3rRTXh c=1 sm=1 tr=0 ts=6908c6ca b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=i3X5FwGiAAAA:8
 a=QyXUC8HyAAAA:8 a=c_-3_FTLrB-Klba26VsA:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:12124
X-Proofpoint-ORIG-GUID: d8LAmV532AusDDXTp8Y1o88Yc48UPvB0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDEzNSBTYWx0ZWRfX0TsXQvesqmmn
 xH7wRDpCJffHcNQ881J+rbfk5E6d9cCn7S28XXFMXcBONZ2/JBW5Wk4/jqUZ9pG1Zyk9tA3oMJk
 q1StuyokxLu4Kd+Z0JH+CVJs6PC5OdkyCLS1/lh1W8Afb7sV5RGLLI+HGtBdI4tPxkTlxLdtWbt
 lDNV8fzKkWjAPFajiItlTlvs7pqoQbKRQnvQctSu+jEnbcdcFU45znMIgXUptxxgYG4K0KjEYT/
 PTle/tcIauO9Q0r1c2tfYeUytATSroImBagZWpNEKv8Ikb8D+7wDNTqQLMYHPwgDFOwvGuMzE9t
 OIxCO0DpN4UcidKZb4XFwvUA3RnflIz2aOe4CDXL83MUHl8rMt4SfpftQf9qEzuBAGCL9buVsdV
 9JRHzL6MPKLy+RdWT7Aw/ovmFkpHbArJ6A3bzKh1YAcCeaPQkQ0=
X-Stat-Signature: pu7xytjsafqq9refdywg7kt9wgzystdk
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B26CC000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1762182867-556864
X-HE-Meta: U2FsdGVkX1/Tjkjnjyn9OXHbS+kIL1mZqk7DbMSUHQ5WTCo17jvy7c43fV28yk+q3zEMA8K0S6I1Zw4//Rx1gWHzzChAlhAlzFKDEddhgc3+VTjZ9tvggR7lVuBqr7bVIO8GOQaRzp4Sm9XmI7flSUCjFR2pkfYUBiy9jgcDvJQtGXwhDilU6lZ+/HnNGPbFLXxPTWDkppFeJamwilYDayP0xuJWLxhHNfIIKr/NenvR7gGrkDf+LILDtcSwOH9PD2pF2oye3mZtf49mAU7CKmf2s7VEZGRCcFCEXkOxZe5RdHpjxIXJByr/8IhC02kQC3oKSTBq0VUH8kfewqhHfOdqJ4Gx7cHHSLlw3JzogsapGmCsL5l8+TKE669zk0DMM9NzzvwBiSVSG6Qc7wvfaWn+D7m8fNM2tqEgU0M6On+jB4sH7q/m/gimWIyaAboq+SGjETwo/0ZrWFtVG04FMFRNDF40wK3drThiMEQcvpJSJ96RYEwSVzAtCIJXLoOeZ6SrOKtzbX/fsYIWq7GdRHaio/cO4eAuNWrVeUYTc0TY44e9id77n9XcjArmLJ4WITkRrUxIa6TFYKLoIetrTULB9lHuX7e6wppV8o3F98dudu6Uxqsv4eue8m7nN7xtqEp/MEA3D4CIwyjQJEDRhkplU8SALwn/F5FpW3IScxvaQmft8t6Z3AJ5C7C9WgClbzEYpWUJln/r0GKxMT1wNJj5uTwAZhWtlGqkoNkbe0VbBvgYEd2q003kBFNw0jY+SHrWyhy7GFIsE7qakN0iT7IDdxQJs9RpAIJH5sxdYuxLSfLHsWT7yck1pbPLcoQq8D3mve9Tpcys+7SdN49zPab2OQelmgxPUNcu7OY4RiOwUF7NaOkin0JYB4fIaO+OwTathTju/Po/JUmi+LuH6RPhWmQgPWi2cwSpZA/CQL+WA4VshIzzY32d2Fc1T0qyymNMJ9H5TfxTAH2UZgk
 sAc4p9Sr
 ZRZO7KiyoYo9fvmDAO196fGWZ1/709RJQOVkk52WueeOT8rCOp+qbyQFV+eN4dt8/QOwLZpAdZvUS9NEIRufeL4OHSGiTkbzooYNr5kVJlUOZhZE/YpbvM4xHU5AaZjRPubzLT6U9aK/OsiUxHn39ePGDJzuPefQm6IHSJMMXf9XYOPahiSi5biROhLDDgEoQqruAaiTPfXbCNqrlfPWu4jRltooYkG6hM8ou1TAhGZOd4hDawhLemWi7EyxTLI2+ehfZPNEzXWtVVvT7F8xdv10VMiIgvKEHOIrKWbv1rs/+Pb0WPJDPzMOyGZObYk11OZuzdui5Dc9P6WGcqQNcY+JDmA0o9r7p8M8/ljtOYAtWseAqcofvvtAg8fCTXbjxg4Tu3nrziCtGhL38W4QmMNHE+5fGdg0F45YrlHMsFcu3IQvPF6ZrpQ8F/o5DV4RYJTwX32Xl3UTPAIOTAO5z96knLLZSiBFkOgDT7LLYAU9hqMrZEPVmjrUY6u3SqY5CdgOMRp7+ITzhD2d4qc5BSqkdvmaQpy+ldFdlt6qsnkplP6OC7k5jfKqM/5/BWfw0egbW10nPVR43SnpSc1+RosiqaBQNWeej/rlgcXH0vLMPI2BpF617VVqloF5HrQ4xbJpB3DGMgExaYFRCxHDzFCAwK9QUX+hAD22JcmsLb3WND2GUvgK2tDeqOU3lKYmz6yrkL8xgzxMITKlazGw0126uRlLXbYG52rbqUFwl0Tw0wZ2Ys/ZpEYRV9ziWfbUDLXa3uti+FHTKaCVa5RF7QTuRdvSqvMC1XaxtrrkT8pUXGC9ZuiiA/u4ZiLEwgVgKpV3m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 11:01:09PM +0800, kernel test robot wrote:
> Hi Lorenzo,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on akpm-mm/mm-everything]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-correctly-handle-UFFD-PTE-markers/20251103-204118
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes%40oracle.com
> patch subject: [PATCH 10/16] mm: replace pmd_to_swp_entry() with leafent_from_pmd()
> config: openrisc-allnoconfig (https://download.01.org/0day-ci/archive/20251103/202511032203.LAN8NcTM-lkp@intel.com/config)
> compiler: or1k-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251103/202511032203.LAN8NcTM-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511032203.LAN8NcTM-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    In file included from include/linux/mm_inline.h:11,
>                     from kernel/fork.c:46:
>    include/linux/leafops.h: In function 'leafent_from_pmd':
> >> include/linux/leafops.h:111:22: error: implicit declaration of function '__pmd_to_swp_entry'; did you mean 'pte_to_swp_entry'? [-Wimplicit-function-declaration]
>      111 |         arch_entry = __pmd_to_swp_entry(pmd);
>          |                      ^~~~~~~~~~~~~~~~~~
>          |                      pte_to_swp_entry

Yeah this needs some #ifdeffery around CONFIG_ARCH_ENABLE_THP_MIGRATION.

Probably different arches do different things in terms of defining/not defining
this.

Will send fix-patch...

> >> include/linux/leafops.h:111:22: error: incompatible types when assigning to type 'leaf_entry_t' {aka 'swp_entry_t'} from type 'int'
> --
>    In file included from include/linux/leafops.h:6,
>                     from include/linux/migrate.h:9,
>                     from mm/folio-compat.c:7:
>    include/linux/swapops.h: In function 'swp_entry':
> >> include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
>       27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
>          |                                              ^~~~~~~~~~~~~~~~~~~
>    include/linux/swapops.h:90:28: note: in expansion of macro 'SWP_TYPE_SHIFT'
>       90 |         ret.val = (type << SWP_TYPE_SHIFT) | (offset & SWP_OFFSET_MASK);
>          |                            ^~~~~~~~~~~~~~
>    include/linux/swapops.h:27:46: note: each undeclared identifier is reported only once for each function it appears in
>       27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
>          |                                              ^~~~~~~~~~~~~~~~~~~
>    include/linux/swapops.h:90:28: note: in expansion of macro 'SWP_TYPE_SHIFT'
>       90 |         ret.val = (type << SWP_TYPE_SHIFT) | (offset & SWP_OFFSET_MASK);
>          |                            ^~~~~~~~~~~~~~
>    include/linux/swapops.h: In function 'swp_type':
> >> include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
>       27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
>          |                                              ^~~~~~~~~~~~~~~~~~~
>    include/linux/swapops.h:100:30: note: in expansion of macro 'SWP_TYPE_SHIFT'
>      100 |         return (entry.val >> SWP_TYPE_SHIFT);
>          |                              ^~~~~~~~~~~~~~
>    include/linux/swapops.h: In function 'swp_offset':
> >> include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
>       27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
>          |                                              ^~~~~~~~~~~~~~~~~~~
>    include/linux/swapops.h:28:34: note: in expansion of macro 'SWP_TYPE_SHIFT'
>       28 | #define SWP_OFFSET_MASK ((1UL << SWP_TYPE_SHIFT) - 1)
>          |                                  ^~~~~~~~~~~~~~
>    include/linux/swapops.h:109:28: note: in expansion of macro 'SWP_OFFSET_MASK'
>      109 |         return entry.val & SWP_OFFSET_MASK;
>          |                            ^~~~~~~~~~~~~~~
>    In file included from include/linux/bits.h:5,
>                     from include/linux/ratelimit_types.h:5,
>                     from include/linux/printk.h:9,
>                     from include/asm-generic/bug.h:22,
>                     from arch/openrisc/include/asm/bug.h:5,
>                     from include/linux/bug.h:5,
>                     from include/linux/mmdebug.h:5,
>                     from include/linux/mm.h:6,
>                     from include/linux/migrate.h:5:
>    include/linux/swapops.h: In function 'swp_offset_pfn':
> >> include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
>       27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
>          |                                              ^~~~~~~~~~~~~~~~~~~
>    include/vdso/bits.h:7:44: note: in definition of macro 'BIT'
>        7 | #define BIT(nr)                 (UL(1) << (nr))
>          |                                            ^~
>    include/linux/minmax.h:89:9: note: in expansion of macro '__cmp_once_unique'
>       89 |         __cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
>          |         ^~~~~~~~~~~~~~~~~
>    include/linux/minmax.h:161:27: note: in expansion of macro '__cmp_once'
>      161 | #define min_t(type, x, y) __cmp_once(min, type, x, y)
>          |                           ^~~~~~~~~~
>    include/linux/swapops.h:38:33: note: in expansion of macro 'min_t'
>       38 | #define SWP_PFN_BITS            min_t(int, \
>          |                                 ^~~~~
>    include/linux/swapops.h:40:39: note: in expansion of macro 'SWP_TYPE_SHIFT'
>       40 |                                       SWP_TYPE_SHIFT)
>          |                                       ^~~~~~~~~~~~~~
>    include/linux/swapops.h:42:38: note: in expansion of macro 'SWP_PFN_BITS'
>       42 | #define SWP_PFN_MASK            (BIT(SWP_PFN_BITS) - 1)
>          |                                      ^~~~~~~~~~~~
>    include/linux/swapops.h:120:36: note: in expansion of macro 'SWP_PFN_MASK'
>      120 |         return swp_offset(entry) & SWP_PFN_MASK;
>          |                                    ^~~~~~~~~~~~
>    include/linux/swapops.h: In function 'make_pte_marker_entry':
> >> include/linux/swapops.h:395:26: error: 'SWP_PTE_MARKER' undeclared (first use in this function)
>      395 |         return swp_entry(SWP_PTE_MARKER, marker);
>          |                          ^~~~~~~~~~~~~~
>    In file included from <command-line>:
>    include/linux/swapops.h: In function 'is_pfn_swap_entry':
> >> include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
>       27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
>          |                                              ^~~~~~~~~~~~~~~~~~~
>    include/linux/compiler_types.h:577:23: note: in definition of macro '__compiletime_assert'
>      577 |                 if (!(condition))                                       \
>          |                       ^~~~~~~~~
>    include/linux/compiler_types.h:597:9: note: in expansion of macro '_compiletime_assert'
>      597 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>          |         ^~~~~~~~~~~~~~~~~~~
>    include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>       39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>          |                                     ^~~~~~~~~~~~~~~~~~
>    include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>       50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>          |         ^~~~~~~~~~~~~~~~
>    include/linux/swapops.h:448:9: note: in expansion of macro 'BUILD_BUG_ON'
>      448 |         BUILD_BUG_ON(SWP_TYPE_SHIFT < SWP_PFN_BITS);
>          |         ^~~~~~~~~~~~
>    include/linux/swapops.h:448:22: note: in expansion of macro 'SWP_TYPE_SHIFT'
>      448 |         BUILD_BUG_ON(SWP_TYPE_SHIFT < SWP_PFN_BITS);
>          |                      ^~~~~~~~~~~~~~
>    include/linux/swapops.h: In function 'non_swap_entry':
>    include/linux/swapops.h:491:35: error: 'MAX_SWAPFILES' undeclared (first use in this function); did you mean 'S_SWAPFILE'?
>      491 |         return swp_type(entry) >= MAX_SWAPFILES;
>          |                                   ^~~~~~~~~~~~~
>          |                                   S_SWAPFILE
>    include/linux/leafops.h: In function 'leafent_from_pmd':
> >> include/linux/leafops.h:111:22: error: implicit declaration of function '__pmd_to_swp_entry'; did you mean 'pte_to_swp_entry'? [-Wimplicit-function-declaration]
>      111 |         arch_entry = __pmd_to_swp_entry(pmd);
>          |                      ^~~~~~~~~~~~~~~~~~
>          |                      pte_to_swp_entry
> >> include/linux/leafops.h:111:22: error: incompatible types when assigning to type 'leaf_entry_t' {aka 'swp_entry_t'} from type 'int'
>
>
> vim +111 include/linux/leafops.h
>
>     90
>     91	/**
>     92	 * leafent_from_pmd() - Obtain a leaf entry from a PMD entry.
>     93	 * @pmd: PMD entry.
>     94	 *
>     95	 * If @pmd is present (therefore not a leaf entry) the function returns an empty
>     96	 * leaf entry. Otherwise, it returns a leaf entry.
>     97	 *
>     98	 * Returns: Leaf entry.
>     99	 */
>    100	static inline leaf_entry_t leafent_from_pmd(pmd_t pmd)
>    101	{
>    102		leaf_entry_t arch_entry;
>    103
>    104		if (pmd_present(pmd))
>    105			return leafent_mk_none();
>    106
>    107		if (pmd_swp_soft_dirty(pmd))
>    108			pmd = pmd_swp_clear_soft_dirty(pmd);
>    109		if (pmd_swp_uffd_wp(pmd))
>    110			pmd = pmd_swp_clear_uffd_wp(pmd);
>  > 111		arch_entry = __pmd_to_swp_entry(pmd);
>    112
>    113		/* Temporary until swp_entry_t eliminated. */
>    114		return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
>    115	}
>    116
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

