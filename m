Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2876B606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.a=rsa-sha256 header.s=PPS06212021 header.b=cNrEcwT0
Received: by kanga.kvack.org (Postfix)
	id 496276B05B5; Thu, 26 Nov 2026 08:45:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E7E6B05B7; Thu, 26 Nov 2026 08:45:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335866B05B9; Thu, 26 Nov 2026 08:45:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD0A96B05B5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:45:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02BC8C046E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:45:32 +0000 (UTC)
X-FDA: 85477392546.03.3A72D07
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13CF2140032
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:45:13 +0000 (UTC)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQBWnS12718127;
	Thu, 26 Nov 2026 05:44:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=Q7ptCjVpkiI6uTAKI3miM7slGLl0+g5DsyedFHQFY9M=; b=
	cNrEcwT0IkVzBabBNyLxboSdJkQKXf4mavXF89r1TfPLd+4+4k3w5iOTDKvdxlji
	udktaH8AQ4xG4xTc8bR9C3MDvN4s6TCo6xuiHfsukL0Is4GwUTGav0+oSzTFYeF2
	he6QZ/Zr+KvLksWMxtT4R5vKma/pA0D+adKW5sXuzhja/Bw3TUJikEeJsnZCFpmS
	FvJkARZ11olyyFaSzJvofpsLdNdBoBAqqI9J/0u3eAsWE2+OjlkauoUGgKkjBeFZ
	qHZJcxXwLBNbxv0cBt58jc545kxbpvSPB3Idm9bEfSN0PrSPcE38Ep6cRTrF/It0
	7COJCXbyhHvEsMCH+b16Sg==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022141.outbound.protection.outlook.com [40.93.195.141])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4j516wxa1b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 05:44:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EkKrBFM58A5vsyQ0mUc6arlb96dhH0pCpRtHV2g6PTsYSnnkEQ7y0+T23ozrgF86FT9d63wCezeu1gFwCqfTfDjB8cmaE70mvoyXLP32ZXyMy9Jp9Gw1F9JhVvEpaL1BfAP/LdZL+s68YjjWgUzsQdiIv8oaWgL4S3oht3/yicjTiqwo05ov+ZI60T9trUJXp2JqMQPg9GknKkkIBkKZRLBgUpgwABhpCkB3IclorvKCSyAJ3Di6SRV5E5/szhDk4+XSUU0IUojsyo+v+mv5oKcSCEflXjYzTI8/ffya/5ETDQ1BuOd7Qx4JWequtZJlJHo22C3/Z5e4FemFUq0ghw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7ptCjVpkiI6uTAKI3miM7slGLl0+g5DsyedFHQFY9M=;
 b=gsW3whigCHaWXwQCuiAiLwalA6AfZSrfFg+yRrfefpY5Ms6k8/rgjWreg+jkm4pQY1/17Pm+1HE+ugMFTSsHl4H6g+ugjUCJUphgjuXMFrBHvlYW2NkGxOsAG3hn8p5+wfO8pL6MxUM93wfbLolaqit38mm98UGSwhMkMD5ZJGTKerGEK5IKWQftZ469yA29MqOowBkRNCS3XkzJdusW4z29T0pnvkKvuIjWEo6JWLoga7n9sFF2KP4Q9F0e4v1gmZyBFJeBykPuNhIvefPynV9C8i72aOmlpjMk570nxtRKSnupKhsskWTuePJnrDx9I2Tf4k1+aJ5j7kb60StG5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=windriver.com;
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by SJ5PPFD25B21260.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::856) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 13:44:43 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 13:44:43 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <liam@infradead.org>,
        Mike Rapoport <rppt@kernel.org>,
        Huang Ying <ying.huang@linux.alibaba.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, ionut_n2001@yahoo.com,
        sunlightlinux@gmail.com, Ionut Nechita <ionut.nechita@windriver.com>
Subject: [RFC PATCH 1/1] mm/vmstat: decay pcp->high of isolated CPUs from vmstat_shepherd
Date: Thu, 26 Nov 2026 15:44:10 +0200
Message-ID: <20261126134410.17447-2-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261126134410.17447-1-ionut.nechita@windriver.com>
References: <20261126134410.17447-1-ionut.nechita@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0155.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::39) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|SJ5PPFD25B21260:EE_
X-MS-Office365-Filtering-Correlation-Id: 1edbe4e5-a723-406e-bb82-08df4bc36d27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|52116014|7416014|376014|366016|1800799024|261009223027099003|22082099003|18002099003|10067099003|5023799004|11063799006|261102123227099003|261022105027099003|261028144727099003|261026121527099003|261026140227099003|56012099006|261021123027099003|261021121427099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	5///ZDjzWx8Zumi15cu6zLLFHORqkPKgIybYrZRZ9CSkTg9Fq2SmAHJWnkHKjvORSUKmsrVoRfxrVUYob/uH1WH69MtwkJWu1V9HZVHvyjX8DiZ7cljMO+kA7/vz8s8yJtOurnu+j+nbEz1ZW4wqdgEg4uW8E0gUTjHn0KVvg2vuRqZTjLG7pQtBIIFMoKoyc5/UsrxWLW/C/JA0Fx1ijanCm8zx789J9Pni+t0rD/n5R9kyxuhqXgQET/spQNaUqOdOXsEjOOj7zZeoxj0xKdr0mD0uJeizSwAlpGAQ30xt1VV85DcNcuNsvAS9i84jlH1uHbL/QJ7Htr7Wy+WHaWThOnYn81aJ3Vyhaq4iVYc2QP2M7PLR8ps4QJgNwvWrGAl+sp7uPcQXUg1RugIiFBz9Zt++aaokJvasXokk4kkZS+TnX5s1r5651W0CAxe1Nh5UCDN3q4r6XwdY7xwHBF1aaVVBeERfqNjrUWjyYBg86pga7EEiZIehUv/LDO+jHiVLcXxX1SFRoF/yeTxvh8GEst6PBNJ8tijKjwZkYwpeUgrJpLh0w+oezrzuhN+hBflbrBlYv7lU5vJV4i183wZnLGW2Zn6yNRhDISWF9ifFyOaczsdhXBILZpWWMiDGfT6cSwUocLESaz/pYrhvpNfi2fLOH8PcTC99EFmQcgtPltHDsCEhw8UmeDEdjb0u8gCmIXZIDqHv3cAUcrYfew==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(52116014)(7416014)(376014)(366016)(1800799024)(261009223027099003)(22082099003)(18002099003)(10067099003)(5023799004)(11063799006)(261102123227099003)(261022105027099003)(261028144727099003)(261026121527099003)(261026140227099003)(56012099006)(261021123027099003)(261021121427099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JTx119W5WbK98O1+6yFQRtTnGpqXMmTP8aWwRpQO7LXyHgDbXPtlIeGQbUnC?=
 =?us-ascii?Q?kHLOsBvT4YNefRnaQJlV+8WDWVqMNuuKsRjxpMaQu93ZaNFOxRCjxF1JtVvi?=
 =?us-ascii?Q?8xKgHoAuchSIJILP6SFCLmPLoDYlApAp2B+pbt3aCWZFi/40h3+NtTlveL0G?=
 =?us-ascii?Q?iLWBPWV12Y0zFHjO/swypgD8Ap4hppfzBC7gZj7VRgKJa9Gs8ZWiNBfwPVdM?=
 =?us-ascii?Q?FkFLnQCSITb8eJOwQAdb/9WpzM83Aqhiy8PG8t6Lqc/eIo8qmG25P9Ve4y5I?=
 =?us-ascii?Q?1pyLbHmHo4x8mbCEMpeh/vivKVyIna4C0yz7ueQ0G7LVkhQpxtahgqMA7aNM?=
 =?us-ascii?Q?yL/wWN6JvOfmJlw1uDg4Xa+I07NxZku6sSvY7fyolOD146xQm+ToE+xaqwc7?=
 =?us-ascii?Q?hTpoZUmBCGK5AWntgJfEcrBjgOMPEaFflk4/YboOTMMPVJfrfq1hWHmmU0nO?=
 =?us-ascii?Q?LXRzpTkV9oNbtWATsekxz6yC6yZA44f3uwLLYUOoAjG+XsrD3lnnbxGrhOAQ?=
 =?us-ascii?Q?miaNler1fM4Miu7RkcThdsbaXNZhKPwdEzW9QVSYCbTa6xUnuDFiHutdNUUm?=
 =?us-ascii?Q?xt1/XMF9UWgUzTngFB8nKs2cA9QNT1PhbnCle6FjF6VKY1zO9jrBNpIN5ZMw?=
 =?us-ascii?Q?3t+8QB0uihofv2zR+cp+DvMdkLgQoV31z+pRf83Eg2u8fdqMvpDLpAS7twkp?=
 =?us-ascii?Q?WQUPyAbGUx86SgN2KjClXcIMlJifMdHEt8ccYEOmd24yvRKhDMaSf8nQLxbN?=
 =?us-ascii?Q?jLnUVK2daEaY5ZXbM9nVVAphlCs64Q4eHonhkbFc5HXt7+6ZJb48yZKWBykX?=
 =?us-ascii?Q?8f7P9XAz10W+RRQuci23Dt9MMJE4I3Rco9QFSyG7les8nXxIb7N5/ZksrASm?=
 =?us-ascii?Q?BHRPSy5pgXYi1XybcjQsL7tgA9r4iQlH6lgg1WDsJN4BAgpL34AZjxcWusx7?=
 =?us-ascii?Q?7VLpwGctYAF6Y3KZ5Y/26RyZKDYWRfJ98gS2OPGoZ9r9RdPyjX43vjopUnfL?=
 =?us-ascii?Q?75SM+h76WpXZY71eY+fgeuTRM7N/hbCqv4+M2dGxeughclddOtMcDV9qR4Ek?=
 =?us-ascii?Q?cDf7yv1zPvhyP6UX6w/HneNCptxlHhAlVnyn1kFSvipSa5Se+7roFnklUvci?=
 =?us-ascii?Q?edExh6VZutnrkZHFvGQWqQ2QF388cPNR1vwl5b4PeMJU5dphVK5EptCFAnkO?=
 =?us-ascii?Q?6YVXIVbuSFyGLN6x6/xnjLUh8D7ObAnwSlRPxb5xzeDKx293NxI3R4QSFazO?=
 =?us-ascii?Q?CvhsRoR6kvlRka1haTzZC+aqFra+/KfjGbAyK9h52crhrc5T4dimhW2fgtKh?=
 =?us-ascii?Q?FSYp8gmONCbiRwqMix7x+ctq+T6KXYN4pRUdSCyN6r5tB7x4k8/mppj4MRcD?=
 =?us-ascii?Q?XnrTdCgKRGLcqlblbL2utNxp26iJEl3C22MLR1YXAJeh6ZqhDDDFih/ZGW+q?=
 =?us-ascii?Q?GpuZjT6559z98PEKrAOsOpO6t9cRawf6/7mrIPAdCIRIQTHsi7Il6GZM/CIz?=
 =?us-ascii?Q?vD6S/IByfvU0tyR6qjY9ABfAwT6TwwyMWrmjTl5NnG5iJyChB8mpkoY3XhM7?=
 =?us-ascii?Q?S4ILwQRTRUUlUGhEAyn9ofaz3gfWyW3NB9Wm1aTAsjQ2c65BY1ZYQzCL4XPf?=
 =?us-ascii?Q?xA8VTPZmv2ux8dhLfKlLBl8f7I3zaFH1Mm/hGD518/n0rJIqtiIu3SHpNKYX?=
 =?us-ascii?Q?am4P/jzgznJ+cMbHcumSeqfNEYU4s3GOlhUZy8DTK2pvsBLoyw5Mg4gSguqr?=
 =?us-ascii?Q?FIpot4in6zpjJIu6AvTL6ol7lzpWRn4=3D?=
X-Exchange-RoutingPolicyChecked:
	SiCmQsokmj6ZZCFBk5ddeOIKjjl6gJVMkwaa62KJrxuVjN5F5W7h8MKDl3muUsAbOQA3A8xYon+YiucRfGkZiJG0yP7fZ5OlJhUJYRTkJ/HcDKZsV1gIXDhqD+JxlKdOQ5V6WVThB/GdX3dGcaoI6kU7g3fATL3mwC2oQRS2KSZS1nPOD9UJ8B7edbXUEuQirNtUrh9mhTbr3497Po1nZR7YRPEFCIMys0XICyP9lgVs1VyilNGYQv5DTqLZ6PkfTT0MxzcwnhiSsiOySAf+CfvMV7XCPebS/TkQP4RLS1SGJjBFVwM739k+5VOKK1zL/H3VIPuR+Mps3q3PA/Guvw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1edbe4e5-a723-406e-bb82-08df4bc36d27
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 13:44:43.2723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zm7WeEYYJpFqW1MiL4+ticb9BQWdAQdaTEPelK8gf6lLHdqBLojiLpjPVybefdE8cP2dr+4SO0t6hgwaDHBjCqAueW6dE/2QB3LiopiaBsQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD25B21260
X-Proofpoint-ORIG-GUID: N1zJhX8MjrFcV12SC9BrEsro9ral7TjR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDA1MyBTYWx0ZWRfX01vfWfaXgc1U
 xT578/5aLaCgBqRut7IWJGmQw0kdesbd8ZAVFHWSe+mTSpGfgq4m5GXOaOVEDXfBSRRB7anqOD0
 rVQpcIwAks7zqng2O/9QM+GjSGk9mgnYbSCD5ju7TWslu6yceak0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDA1MyBTYWx0ZWRfX7ynQ55t7/5Ld
 EmqeU7an+eaJJUCGsgcmoQNqHUQxdw1p0l527DbvzsyTHWOVbuC+c9rXNKSjrncJsqVvWcFhVFO
 FD9PfQs15IK0YtBmzRor1f+EyJKR82ZUdlKU8aZ415+WWCN875SFAtT1HnI6C2hH2k5PoXXCNJV
 XXkI3uwDLM1anv9yuf9TXnjxcXrK59ekYpWosVYVuNhy8XFWD6rPjJY/+IKzpcsRcd7nrhiC6OG
 XlReU0fDPE+ztV/kq7VLyqr1H9WuhxTCORFMIqvG5OTowB3VWBzfMkU9lecXh8Ecx7yyvlb5Gy5
 dPX/Q1IpxvwdZ+vrmzIAVarb2P9rMAn4FrScg7s5CRtpPojXcRDf3KkvRXJaczVACXB+0DWW5nU
 SrcfQKF7NjyUSFJkxtOCaB2YoEMZByxKyvkh1j2DtJeo61jnJer3G7gF1LvniDuUFM/BMUWZNhC
 IViVnOWOZnhcm9zB8yA==
X-Authority-Analysis: v=2.4 cv=bofZl0ai c=1 sm=1 tr=0 ts=6b0837ce cx=c_pps
 a=grR+JLqVfS8Y5b128bbGRQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8
 a=seCoRrK0zK8FCnRam7gA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: N1zJhX8MjrFcV12SC9BrEsro9ral7TjR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_03,2026-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260053
X-HE-Tag: 1795700713-716751
X-HE-Meta: U2FsdGVkX19HvSes80Mxu/gci9zRcVoUpMEsrDLkjW9hc9xacsNq6cIoFIPx7EZwhsx9fyZRRRmSg35YeGYlHRFjcFoo6JzjVDno6MmJGrbCV9nGR3fLla47dT7H6qzabAO1qnx9ZgYs59EYazeiUyk97rT5g98i2AdXD7nf2MXfBTZwYlAMkNw+MVq1RWt3m7Wkrz6Ai1poAObv6HCR6YH4HmlKk48deVsdfSrbXMmNNLls+orLjtDkl50qm5QvM+u25SSQCeDtN6f0uuunLJGf49Y/3c1UZy/EmuuZL6MjPTYa+NauPJa7DZo3BOysH42ZIkIDcDaZ72nJnjoOjjKsL622UrolJpaXvxJOXJrkT9IVbIqH1m6ILlBMLJrYzWp5B342ljkBspglQd8/BYZ1F7NwIXGxAVxL80wIqqaQ3Dwl0wEKWPgHuQJ94mI7Nnz/fjkoHrNQgMMop2aNIm0ZSm0Q/cqz/34Vs0Ddq3/+UOGvSF3JCXUToDc2GRiZKAuy2QjWW51Hxxa0zvTeogQnQtbgV3LTzuLX9UClmnkdIKPpgptNE+zfxWA8I/vs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ionut Nechita <ionut.nechita@windriver.com>

Since commit be5e015d107d ("vmstat: skip periodic vmstat update for
isolated CPUs"), vmstat_shepherd() never queues vmstat_update() on
isolated CPUs, and quiet_vmstat() only folds the counters with
refresh_cpu_vm_stats(false).

Commit 51a755c56dc0 ("mm: tune PCP high automatically") later made
pcp->high grow on demand, up to roughly 1/8 of the zone's managed
memory spread over the node's CPUs, and relies on decay_pcp_high(),
called from refresh_cpu_vm_stats(true), to shrink it again and to give
back the pages cached above it. That path never runs on isolated CPUs.

As a result, once a workload on an isolated (nohz_full) CPU has frees
that push pcp->high up, both pcp->high and the pages on the pcp lists
stay there for good, even after the workload is gone. Those pages are
neither counted in MemFree/MemAvailable nor attributed in
/proc/allocinfo, so the memory looks lost.

On a single-node, 64-CPU Sapphire Rapids system (256 GB) running a
PREEMPT_RT kernel with nohz_full=1-31,33-63 and a containerized telco
workload, about 28 GiB ended up on the pcp lists of the isolated CPUs
(pcp->count close to pcp->high_max on most of them) after 8 days of
uptime and showed up as unaccounted kernel memory. Lowering
vm.percpu_pagelist_high_fraction lowered pcp->high but left idle
isolated CPUs holding 300-450 MiB each; only drain_all_pages() gave the
memory back (MemFree went from 126.5 to 154.5 GiB, MemAvailable from
157 to 185 GiB).

Do the decay remotely: for isolated CPUs, let vmstat_shepherd(), which
runs on a housekeeping CPU, call decay_pcp_high() on their pagesets.
decay_pcp_high() now takes pcp->lock while it adjusts pcp->high, as the
pageset may belong to a remote CPU; the draining part already took it.
Remote pcp access under pcp->lock is already done by drain_pages_zone().

To keep the interference on isolated CPUs minimal, the remote pcp->lock
is only taken when pcp->high is above high_min or pcp->count is above
pcp->high, which is only the case after auto-tuning raised pcp->high.

Fixes: 51a755c56dc0 ("mm: tune PCP high automatically")
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
---
 mm/page_alloc.c | 43 +++++++++++++++++++++++++++++++++++++++++--
 mm/page_alloc.h |  1 +
 mm/vmstat.c     | 14 ++++++++++----
 3 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ce44b8fc4..aa9904eaf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2586,8 +2586,13 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	int high_min, to_drain, to_drain_batched, batch;
 	bool todo = false;
 
-	high_min = READ_ONCE(pcp->high_min);
-	batch = READ_ONCE(pcp->batch);
+	/*
+	 * pcp->lock is taken because the pageset may belong to a remote CPU,
+	 * see decay_pcp_high_cpu().
+	 */
+	pcp_spin_lock_nopin(pcp);
+	high_min = pcp->high_min;
+	batch = pcp->batch;
 	/*
 	 * Decrease pcp->high periodically to try to free possible
 	 * idle PCP pages.  And, avoid to free too many pages to
@@ -2601,6 +2606,7 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	}
 
 	to_drain = pcp->count - pcp->high;
+	pcp_spin_unlock_nopin(pcp);
 	while (to_drain > 0) {
 		to_drain_batched = min(to_drain, batch);
 		pcp_spin_lock_nopin(pcp);
@@ -2614,6 +2620,39 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	return todo;
 }
 
+/*
+ * Isolated CPUs are skipped by vmstat_shepherd() and therefore never run
+ * vmstat_update(), which is the only caller of decay_pcp_high() for the
+ * local pagesets.  Once PCP auto-tuning has raised pcp->high on such a CPU,
+ * neither pcp->high nor the pages cached above high_min are ever given back,
+ * and they are not accounted as free memory either.
+ *
+ * Decay the pagesets of @cpu remotely instead.  This is called from the
+ * housekeeping CPU running vmstat_shepherd() and only takes the remote
+ * pcp->lock when there is something to do, so an isolated CPU whose
+ * pagesets are at or below high_min sees no interference.
+ */
+void decay_pcp_high_cpu(unsigned int cpu)
+{
+	struct zone *zone;
+
+	for_each_populated_zone(zone) {
+		struct per_cpu_pages *pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+
+		/*
+		 * Lockless peek to avoid taking the remote pcp->lock when
+		 * there is nothing to decay; a stale value only delays the
+		 * decay until the next vmstat_shepherd() run.
+		 */
+		if (data_race(pcp->high <= pcp->high_min &&
+			      pcp->count <= pcp->high))
+			continue;
+
+		decay_pcp_high(zone, pcp);
+		cond_resched();
+	}
+}
+
 #ifdef CONFIG_NUMA
 /*
  * Called from the vmstat counter updater to drain pagesets of this
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 58386512e..85cd958cc 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -334,6 +334,7 @@ static inline int gfp_migratetype(const gfp_t gfp_flags)
 #undef GFP_MOVABLE_SHIFT
 
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
+void decay_pcp_high_cpu(unsigned int cpu);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_all_pages(struct zone *zone);
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index c6beac6be..5742ca508 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2148,6 +2148,7 @@ static void vmstat_shepherd(struct work_struct *w)
 	/* Check processors whose vmstat worker threads have been disabled */
 	for_each_online_cpu(cpu) {
 		struct delayed_work *dw = &per_cpu(vmstat_work, cpu);
+		bool isolated;
 
 		/*
 		 * In kernel users of vmstat counters either require the precise value and
@@ -2161,13 +2162,18 @@ static void vmstat_shepherd(struct work_struct *w)
 		 * for all isolated CPUs to avoid interference with the isolated workload.
 		 */
 		scoped_guard(rcu) {
-			if (cpu_is_isolated(cpu))
-				continue;
-
-			if (!work_busy(&dw->work) && need_update(cpu))
+			isolated = cpu_is_isolated(cpu);
+			if (!isolated && !work_busy(&dw->work) && need_update(cpu))
 				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
 		}
 
+		/*
+		 * Isolated CPUs never run vmstat_update(), so the pcp->high
+		 * decay it performs has to be done remotely from here.
+		 */
+		if (isolated)
+			decay_pcp_high_cpu(cpu);
+
 		cond_resched();
 	}
 	cpus_read_unlock();
-- 
2.55.0


