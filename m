Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C31FEC982FB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 19:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137786B0005; Fri, 16 Jan 2026 14:48:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1DE6B0088; Fri, 16 Jan 2026 14:48:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE87F6B0089; Fri, 16 Jan 2026 14:48:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC80A6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:48:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89FAF16022E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:48:49 +0000 (UTC)
X-FDA: 84338864778.22.DBEF2E1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 263EBA000E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:48:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GuHFWy5w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="UYqKhXq/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768592926; a=rsa-sha256;
	cv=pass;
	b=dOGslXwyZr5nx1eEn3J0n88RePQwxlpxj+ojRIjqaUI916Yjap+dgRP5nl7Ga1ErFgIiQ+
	+BhdjNGi1CXYl6ARUqmd1Foq1a7h8Vk1q0pRL6c+poMZxs3FDMoT3sbwBd0i3fuy3i8wdo
	CuQBojCHlr2K8n4HfAqSY9BVnvhRW3g=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GuHFWy5w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="UYqKhXq/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768592926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=00r+NIaq2Wj3urvRopglLWdaAaMY00T0P11/bqX+qow=;
	b=eUyaSUa8NbcU/c+gzMgm9ZJjnPpUR4J2xQfuKJXaVIPMbmanJa5fnWNYks1cE38JcxFNbF
	sxlvMj29Ys/ZjbC7cdfeOV8mTC4gdJtVd3AqUXepfKVlRz7mw99g6kVS9T73nuxW8cDjRb
	vYPQ7mPaptXbaTi9aTr2nwAGiruPhXk=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GDik3n1910595;
	Fri, 16 Jan 2026 19:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=00r+NIaq2Wj3urvRop
	glLWdaAaMY00T0P11/bqX+qow=; b=GuHFWy5wiiXroVUYzdeMNR2I1t7mFyPQTS
	oPqucOqosLwYSCSr5NY6XGWVLyhUYda4+b3AgLpwyRon5XcD5qA9hVWtDahfqW8y
	o1DAlWr7U61YlwzVo0ncBlYsICGzKLXtkljmtZEoMCK8FyEnB0ka+cco3URxs6iK
	J1ACT0NpS/V3D6b6jbv/wZORF9Py+kI8o7U7GZY0mRH1EE9RYwXuvz83txHEWtTD
	ZprDrERNEqth0yEGdDlj4PzekWMmEJWmr0005GVL3XiBv2iUiwkHAK/8fIVLRUCO
	em4bntv1QA1YB+33rdkc8PjtGUKYpii2BcTg6eQSqkIMGA670aug==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7ntpp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 19:48:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GJP8A4032724;
	Fri, 16 Jan 2026 19:48:17 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012008.outbound.protection.outlook.com [40.93.195.8])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7da9mb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 19:48:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lp1nmNiCskSF0hW5NpIjwmhxlpIKWP2nfgd2UzKqiACK2jhv3AX1OnEs4EIwWNTLIJN1D/e6dJwqJ65nzwWkTieLk2/aKNsu0i85un/Jh7KE6+emPgRRUcPcTngXnpe0Q6/b13efaU0t2cgpHyiEJcwHmDROqP1CP3TzSKkpDmwCWBG2Sj3hBYPaFujgc9XLRpVma3TvcOqc4qcQQHKNpdtJdpUsN601CGnK0aktpyB1tL5BYQ6Wz1ZdQ/q2kn4BWLYXmNf+MGHLik2mb+dxl++jriJJ4RvpQtdypbVZUgj0zdMxEf+MhEiS2uBODNqFgihkr60zo44hErcvjpuHdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=00r+NIaq2Wj3urvRopglLWdaAaMY00T0P11/bqX+qow=;
 b=YOe/7iVJPsXpbM3jh11iFv3M1bYQQOyE16xkCYYG/jyO8uFBMiisy2U2BkQGoASsPHkoJbTYRLpHr1qKV/hWeOJuq/njLwhAWtBq1PyMjE79dOF4tW5MOPegEFT01DBLCtEN4Yu/v16r7Nk1mf0zYQ3ClaGJ72BO+o0dXTuk+DzRYpSfKXslzklSdz19eicNweeMDce3RhpzrlDl/RIRZYV+VrqRXvPsCLmB+jx69+GqcQE17fZRYCxVOuWqaPNOIF6l1EF913suRC21uYE2pwM9uWuky0AQk2vioOsO7DWCrlYUNnLGrmeKdFMvUs9FUVACUtOvvmsIgtfm9aH4Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00r+NIaq2Wj3urvRopglLWdaAaMY00T0P11/bqX+qow=;
 b=UYqKhXq/iM9Kfp/SXoHcAOAVfEZyKYV2lh18SgPRMRGiTNs2WvubsLdOcLfIGB/rl2sJLnFc5c2I6RcK01rzWNW9jwy7cZF50A7flZJmt0NC6aGJEaxTLdIpT2Zj1hLpRwkFLoNJKl5nb/DjLllJRiB8xwZHBpxqEEDBU90Q3/M=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB6782.namprd10.prod.outlook.com (2603:10b6:208:42a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.8; Fri, 16 Jan
 2026 19:48:13 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Fri, 16 Jan 2026
 19:48:12 +0000
Date: Fri, 16 Jan 2026 14:48:09 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and
 vms_clear_ptes()
Message-ID: <sa332ryejxztkypor4oykkzqh3dih7lxwiw6nopillqckv2idu@wwkb44qxyi46>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	kernel test robot <lkp@intel.com>, Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, Linux Memory Management List <linux-mm@kvack.org>, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
References: <20260115182720.1691130-9-Liam.Howlett@oracle.com>
 <202601160919.v3GpIeUh-lkp@intel.com>
 <rdkyeoi77thmvujvdi3dgg5c7m243gzqg4vanyyg25he3tblxy@mvvwnlkr55qu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rdkyeoi77thmvujvdi3dgg5c7m243gzqg4vanyyg25he3tblxy@mvvwnlkr55qu>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0226.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB6782:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f136e7e-2de8-4cf5-ce9c-08de55382edb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|13003099007|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lWVk9Dc6EuEwOeOuns/3YVW3iBVYeyGGK8B1LQ9qbqXM7yOQmEurf9pp+lLz?=
 =?us-ascii?Q?qSS3wCB7g0hMgA8MFeZrTTLDKRP0wke7VVMQRv91ZJ5Einx3maMNjXzOHzx7?=
 =?us-ascii?Q?BNh75GRldCcEP3QQOYcwlW3R8t0f7UYULyfbny/EhClsZLhdpAIj/JGN8vbT?=
 =?us-ascii?Q?+RqM6n23VO9/JivzwUf2di9Ebu0FyiwBrZbpKxddAsog6ZM2Qu3eXaAsseTv?=
 =?us-ascii?Q?vDq2H4wnBvilvgImlMsnvhiunYOzskrnBChIsCO9RsR9qW1FIYBGa16j3vRc?=
 =?us-ascii?Q?0DdHFz5TiXtNwPQTtjFCfP0P3xUZL65q8wxHTaYbMftv25PWjaZrpephgc4n?=
 =?us-ascii?Q?J+BloP5J4STQbR4wbrv7a5snJKLRBuSxcEL2o6v7sezJ2Qj1gI2xaMl5+ISH?=
 =?us-ascii?Q?8WNgQDUh0EV0pa3Se6WVL+BSLnp1gKcC7n84+4srC+Rt2zlxIiYOL5geEwXA?=
 =?us-ascii?Q?rZM+xh2n1STi/VjHrq9tdR337X3U1wiwW+POfyvkrKAVCyv+H5IohxoTg5go?=
 =?us-ascii?Q?CoXcAusGpPNZ01VbfVUOOX3+WJAFeboMQjT2nUa9TEvX9BAnAZ321VR9H+3J?=
 =?us-ascii?Q?LsqlN3Q8xTgFDq94cSUmWvbDxs4iOTUmkdPEb6Hy4vO5skSq5qkS2pwc+XzT?=
 =?us-ascii?Q?bFXUO7aGYIcppNKJjpc5LCdteDCwtIC/okBoyFsI0LH7xDs1gKMOjQhJwQW2?=
 =?us-ascii?Q?Nrkj05Ic98Exh6568cVmHyutGM/OTvQT/iYFtpVlTCwhDn6tGfzkuORTTtjb?=
 =?us-ascii?Q?6sPx1SD5iVIbStCGcMJyo/f9IJu961lIvBUVSfLT4v6FWjLYj70H9mVEP+3n?=
 =?us-ascii?Q?Eg0XfRi6ir6bfgwqepkVAjLqAVFao1vxni2qil4tzwmKt7NKyx1AhOLAHF9F?=
 =?us-ascii?Q?N9v/90/Gk3evcYer8HvI9LiogT+u+C91IsfpENxal15XaJI/7FZLJT+EuGaa?=
 =?us-ascii?Q?pzjzvDLtw5V0JXcLIaM08Pw9tXdmxOyVJokTfdz1rrCSpqUdQo8WEAw5rZx4?=
 =?us-ascii?Q?x25XJzgQMmvYhLgKPkxoVAuLHV2ZgAjegf2ZF/m+/Fl93q8aAvBgTW1iA3BZ?=
 =?us-ascii?Q?fN7rgHzN+QeMX5RROAJwCJ8TOlbE7kZsM40+m+65XHeYpckgNalEdL6Cp4VS?=
 =?us-ascii?Q?PowmjgAmHOT7OQPr0IcNywcBm7+CZxaZAXw3ngO4vxr7yCeBYSlVaeM5K8/a?=
 =?us-ascii?Q?UeeCeKzgOTf+Fvw8oQnb8aSB4PXEPa3PdGdUyJOh7BYGQAy806g4USzOZxBF?=
 =?us-ascii?Q?glnfVlsXL/Z4PwuVuj/EZUeGQ80WQ/7EGXRBo85u7SjlwPYh7OG0CFKKNHRo?=
 =?us-ascii?Q?5ro7hTNqPhDuM1G0ZfIWjiDrekYxGxGywDdWJwCTwJ/1hMJRYCrW6CySTGHS?=
 =?us-ascii?Q?L9C/gM39lvxJvlZt5buDrqgyni/TdhQtsTW9gggfm8HWNZloKi6GZ5KOGfEw?=
 =?us-ascii?Q?6+xa0Wpk4EbMlNoM22wT+S99SI7W21b5RwfvwlWLvP/AVRnCVWlAI9xWjO9i?=
 =?us-ascii?Q?aLn7BIgDJRtcVvpo71NtOl9nss2lry0qAVcjVl+heNgIVKdnFv+3+1wqB/qd?=
 =?us-ascii?Q?zH9/Xd5+tH1h1aqF3FzjEs+Ecj1+pL2qnCc76zKjb6hlK2RV+ufOUpAvMPyP?=
 =?us-ascii?Q?RdGZm5xjmeHejGePpPrGE9E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(13003099007)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vvvY2Rc8LAyXyVhTTZgqU0Tl1T2hWnVXiI3hjW3vp375k2VgFNGnFYytmYkV?=
 =?us-ascii?Q?W20LySkLyUtzNmQ2aj1lu/+U1EuA0y7a6Y9TmOkfFeCpzVcFhnUVXbnWtHuM?=
 =?us-ascii?Q?uNfhLHKzG0OQUKQdHz1amsi62iFTpT34txIZxFxQubmbpke2NBAxaQJ8vRhP?=
 =?us-ascii?Q?lTKPOrMKRI2+GC+5ew8ZG9WilTTgkYmg37fiobF+1XLzR8auxc1t0vKaSplB?=
 =?us-ascii?Q?sGcNjwx1536kwHq7b7R4meIK2x4QM2Gw+4XTH7MYpKD5zhdse2pDeFf2zhzc?=
 =?us-ascii?Q?VQY+qFhkTunbdZxyS0lbxosPt1bpkuQoci8tlSXlzNB7kvZ5s1g6WUPqiNhg?=
 =?us-ascii?Q?eR2+i5m3TTWKv/8RKr+aucaaOHHbnXX5pZQ91FlUK2JT9L1akuZI/NdMBSiS?=
 =?us-ascii?Q?W65ziLVjbbmLP3PmIiB23PSOVgaj0FRXFYrK63XKanX3Otig2SPTV3aVUEEX?=
 =?us-ascii?Q?vZMHOySfWcHf3IuMQMWBsfliWX0FcvwfbwSEJdGfjDifdCc4jjPApXuEniSU?=
 =?us-ascii?Q?nFnm/Mpsp1SYW+ouiOjvGzZZDHyDi7W7YRWUxtgo/4myDSn6no8YFMxnBs89?=
 =?us-ascii?Q?I5QdpYHGDfX3Gyy1CUAR0M7wWrVr8hjUyKF9PTHNiwE4IIu2OesdmJGus5u/?=
 =?us-ascii?Q?uF5ylVvqPwPXGox+nTmjiziv0Vq80rGrBUO44F0GI1Lx9iD7l6133W0Y0o5A?=
 =?us-ascii?Q?FyQ9hfEGQ/GxhEDUNITeJHr4J7Gj+ngLX+41s33cO1Bm9Bwxtz+PFB+l1tv/?=
 =?us-ascii?Q?JrGJqmc+gIpyrxBK+6AUiF7DXIlsWEhnW59mNqvBBFV1qDn7XxP4mZZX8YFs?=
 =?us-ascii?Q?qtdeYhn8TQ2YL0vlkYcJcXQRi2D7dQuyyssDAKA+MQQ60DYfPB/ICW7D0xc9?=
 =?us-ascii?Q?YG6s/72VSOKKnjW4MiVXNxB+ZnL3ShWPbq/ECNq16dGqqRsmMYOoTIqFVv2l?=
 =?us-ascii?Q?MzZPLsXiDsHTk6T3r42PPf2aAyNSfpASCEuPl7ShNKROBqx5l/y4k+QLAx7A?=
 =?us-ascii?Q?r9XP3J+bN4QZMeEPzsD9PctIhtrlkqhSpLbigEyaoDMxnPL5/ztma7xcKYUk?=
 =?us-ascii?Q?LVJXsYH4ym85Re7s9H80xCU/FKuGeCPiNw1o/3SYxZO/x71chltPJDauL9qR?=
 =?us-ascii?Q?zLdM3lkQzBmwyPkasSynDr3IpEXqhbZ4j4+3jp0+MWMcmgPHn/5RPd0Nmy4l?=
 =?us-ascii?Q?tjnmr1TWwq09ZAOBs+ySOOT+clnnvBkLkpB7dOmfv32WMTj2kJ0AoFv8UO0B?=
 =?us-ascii?Q?JQeClIcd8moe4dyYR7yo1mwaXlFkqw4SgtYkKTHB2KLYcYQt3XApmSmSQnFA?=
 =?us-ascii?Q?626cxXBGJaCj4iAg9zGYtYiedCbBXCmtzvFxeIoFqlc78QR0WLub+ZPx0BDp?=
 =?us-ascii?Q?eFzFu09SiEMWIShIUpnIqwSFH95yJgMEkcVTnkuUp/zmW339/2pkNBUoueeK?=
 =?us-ascii?Q?jl84tR9l35SrddVNbsSmKxUDxSGx6RZvQ70Vjlt48k5TfM3uHOiwXiGDL7Ax?=
 =?us-ascii?Q?YGFHKPmiUq6J/CvGthgQM7gcC7iOfybvGERqqV7a2ngPuCQebKYFn4MNUkn3?=
 =?us-ascii?Q?c4/mLedlOqLN4x6RTHxQjxkAABot6ES/U7QfEEe9ZBht/cTdEFq4DgYY01xN?=
 =?us-ascii?Q?g/zlqZ8zmwtSbKjRlJ2pcfrst04YMvgp59FaaKOEUAdQKcSoWF6+WIEgLhzp?=
 =?us-ascii?Q?IFeGH0dWMbSkllJgKjap23Bh2ael8qlnx2pkvtjb98qFOcmAQGUzv9nUi3bP?=
 =?us-ascii?Q?Ndd2XIxRVQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/eqx2bbV6L6iIhFI3DoNEGPgLS+t+aBz4pBPcUpTHdxVHsZMN7GQCSO7krkRbPOXzlnCWnM1ccGXlJ7hQqYvcv9xCKt9p4k5Llk6InoRsHQaQsySe1gONRhPrdQwqpX93ui6JKZ3YgbZ2NXCZERzv6DNw0+0rzTfuijegZAnWiDaMWBZNrSqXLUZ3xq/Hnv1UGWstt1DUtxUBEb367uyPxMb1Dyz0LcrOzDCTAzImJ6/bdT0HFh9Ibmm7LKMLT3fAcSOQa7Cqsvg01hIza531Q+4uZqAuEgNYWZRwhAWrMQpYIzQr2pL5diBNVsKIdFGV3+ZvzHf74noNYDPcSqkaTmJFoE2COzqLYo4eT/ZSfbKJNDJmkvVSaZGvvXtgteBl5HfeHxzZ3fJoOhJj1XjwGc4VvfsbTs6i6Den8FKsQl04pgcYhemqx+jlE+SdmTtNiU+2fgIcqvr/dmEaoheeFHqP24NMbZAUhkVcaR2uDsz8dEOJrTKsVw/KHR7paLi7FQ8j+3F7G/qZ/jmGZcpn8MJXwGOB44M2en6yv2QMzHf0WGNN/XXfWs3U/Getu5kLss0ZmAkV9VgJTIsHLCtorE3JFylEB15mjuU1hsthYM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f136e7e-2de8-4cf5-ce9c-08de55382edb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 19:48:12.7050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yqbGrB2B788E3d31AQ8yyFX20YKmt7geA+3Idc9LA9TamWxFnvYzIVPf+HCBHsxKQXcKAA5mWPD4uk8fzCutZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_07,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601160147
X-Proofpoint-GUID: 7A5aF_kOdq8jkHSleE8dRrFvRjipbcqd
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=696a9602 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=CnCJuI1fFdlCtESEyV4A:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDE0NyBTYWx0ZWRfX4srFJN5v9LtX
 3YeOXtYpWmVdRrjtphBTNzX8/0qHSFLrXReHxY76SJPcYZdPUoVyozGNGSZvUqGws+RYTGF6buO
 7LWXLwtWWMkk8ilV/VEyY0EtIK1s+p1mTzxYOSJcT2XEJ0GDXNuUrRzZnQpjJ0TdEBqhBX+JiTd
 /QMtLVPX/UKwBGAP44qFcWRuL4d4T/5CZ2BGOaPpA58kqa7w6h68+BJaDI9cqRobrLrPe8t/Tw4
 tG1o4iVd3g/Bj/WzZPfyeHdB+hYRXYNIs8ObjJXxzFdCugQVJ57nu0HxhtM0Xn5Ts+N+C3xrBN6
 fds/Y6mie/o/+hPtfJTF0Hx88dMjkmUCdRWpUsw5wxj9hNPny3fA0scN7j4SFmPIwRp5lCuNqH7
 2hGHALfh/qkghJv2ERJ9KTrrEjNGAVOX33ly9ywDgpnQMPTML9MWeDFuIqBtPjaAdnBQToKEhsG
 iOLgqvUFBFYtQSTwtOg==
X-Proofpoint-ORIG-GUID: 7A5aF_kOdq8jkHSleE8dRrFvRjipbcqd
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 263EBA000E
X-Stat-Signature: cr6hn61psmrnehgodzwh3jxwr5otnwtq
X-Rspam-User: 
X-HE-Tag: 1768592925-984488
X-HE-Meta: U2FsdGVkX1+tRmb6D0ctXEaVtv5F/Ctx1HVZyM7PbysUxRY4vr81ctWp8dLgm2wVwey29GySC4Ja4xk6WPCctTCPri+NWlK5W9S0QomPDJzUEWmZo3AWrlHqXuZtl6Q98mRZ+gdER71lxsCojhfyxqXqFR2Tu6tKn0LpFW5njnCWvSOOF8K1X9Kgxz8GMAsHjmK84mvhrIGhNWfjFtuH81w42EL/mWIpGHtt7VE1oWfbbeE7an5hY7C2OJK1rFuiyWdydOXLXKXMHll4TehkSDR8A6u7UkJ/RnAvA/ZRVngnnqCBS4N0jetjWbxMIm0rlwdqhjp+bXmNAX2arZJqrI2KV5exdccfU8NwoZ5PQImw320EC4S7G9Qx+UT+XmSHkX3ixA6CNQ7KntF7FGGsAyzXuFRneDMOu8b9XMVXuV6Gvl1XQuhs/yX2V+3rU/V8PWtbqMOgf2ptvIr1m2R8A4Yyp2j+uYPqIa37m1BuQiMGIX6AXRpsz1T7CibPJkiqLn2IgVKCVz0ebNqQW9w2MlMoa8Gp6laHh76tHFJsIn7VAuaEb4JuvMl4zrmdupeD4AVj9FbDHZWKUZdJzj93clMvyQRjtoEfZY8skL0u3ZJla+79T97dNI+X65clDAMBoJNkeDEB8vyNfCk6v8tRN2qAC67LSWHnG0AMIgov5xyaHJpQlgCKbJtU2iD7y9h/R+kwkMjzOxhsBys2N//KwKK5MkX4mrZQATdtIEgscIncT8WF1apGkQA+zNeD6WVWS6/NnKyn0jK2JUhuWjTV9XcpwGm5ZPQzMgJarjJOIXD1hIMrmOOPzEQkXIU/Om68VORrgB0v1MfALndDXlfrGP2q+g4/pzfH4/hJ4CmNNEbgmVh37XO98jG/LWXw06h3qfgUiqBLmkNLzqCpO9tvtlp//1qWXq7MWm6gCvTE5QYTfXO5y7xdy4TdbrGa6fkR2c/g4eE8DoIVNLX9Yb9
 kTt8YPIS
 FD2cF6tPtWG+55xt4z8o1PwptR/ytxYtp+5bMgq0K/gWf7lgiyXHz6sZ2ySHzBQ8FZK6k+bSUvmJYjn9GsUIAvBRaXiba2kTx6kfqysObSK/VOiP7TzIzLM4eilVyJMoZMp3aRFxmDgxmEqy428+y2giIsuPzpB6sGZbrCTGQeWPJx8z5xC5z111hQ+GFsO+QYgXj+G0NZe+shTTkSIS4yEOrO4N2aF5kqGxkHr3RB/caRu4sOB4UHFBhjz3ThQVbOXVSBX4lXLvxKSIoP0iQsjQyJ1JP6841gKrWRNbexEsS0zmZL3u+DJrBJv3zWn5MKCnWETANIuki+OEzksRl4Vh2TJOhbEVNNTmLrhPfYqqmJi01xmhhbD152wj1m9Nt6WHM7Ij1PcUSpfhcAXVRmkrDt8Pwju7vSYtYaTI4Iv9597tSpquWTQ/OEFbVe7XMSU///4qu213QjHNuYiIN3hito2YmKL72nkn8E+7Zi7jyJluUELTM2B47v6dR4uLW3Lap1bM4Elzty9PfFBYN9Lfx8mej4L+Ddn5qUFGYoij1Ach8uKGxT8CuiFdAxF8+65OPAhdKInS5p/hTg+kSY+Yek3DdNKGaeRzzbJ2LeSbyLj4o9rII6HMlK+9U0TxWVzx6ci/4ybrXV7857jNLpxULClQeZEc2jNaZtbxf/j7xqa91sd89lcGxFmWrG2FW7BbIyfrTbqfOX8UOucBypf0n5dHtZXQIBhUCkIMbp1amxQCHsE66+5V1LoMX+WcsnkyMHJJlYo6ern2lLnGaYsV8Or/e1rUIXjKYNlosOEBlrplr4EqCfZxBxACEDUvESokJ+PbU33S9UtKNj7UeFVYAL9zsg92qQbdqOuuc4M06IF3OR5X66oCPi2adjdePRX6b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Liam R. Howlett <Liam.Howlett@oracle.com> [260116 12:55]:
> * kernel test robot <lkp@intel.com> [260115 20:30]:
> > Hi Liam,
> > 
> > kernel test robot noticed the following build errors:
> > 
> > [auto build test ERROR on akpm-mm/mm-everything]
> > [also build test ERROR on linus/master v6.19-rc5 next-20260115]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/mm-mmap-Move-exit_mmap-trace-point/20260116-023126
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> > patch link:    https://lore.kernel.org/r/20260115182720.1691130-9-Liam.Howlett%40oracle.com
> > patch subject: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and vms_clear_ptes()
> > config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20260116/202601160919.v3GpIeUh-lkp@intel.com/config)
> > compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160919.v3GpIeUh-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601160919.v3GpIeUh-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    In file included from mm/filemap.c:54:
> >    In file included from mm/internal.h:23:
> > >> mm/vma.h:176:18: error: use of undeclared identifier 'USER_PGTABLES_CEILING'
> >      176 |         unmap->pg_end = USER_PGTABLES_CEILING;
> >          |                         ^~~~~~~~~~~~~~~~~~~~~
> >    1 error generated.
> > 
> > 
> > vim +/USER_PGTABLES_CEILING +176 mm/vma.h
> > 
> >    169	
> >    170	static inline void unmap_all_init(struct unmap_desc *unmap,
> >    171			struct vma_iterator *vmi, struct vm_area_struct *vma)
> >    172	{
> >    173		unmap->mas = &vmi->mas;
> >    174		unmap->first = vma;
> >    175		unmap->pg_start = FIRST_USER_ADDRESS;
> >  > 176		unmap->pg_end = USER_PGTABLES_CEILING;
> >    177		unmap->vma_start = 0;
> >    178		unmap->vma_end = ULONG_MAX;
> >    179		unmap->tree_end = ULONG_MAX;
> >    180		unmap->tree_reset = vma->vm_end;
> >    181		unmap->mm_wr_locked = false;
> >    182	}
> >    183	
> > 
> 

syz test:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything

--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -46,6 +46,7 @@
 #include <linux/swap.h>
 #include <linux/uprobes.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/pgtable.h>
 
 #include <asm/current.h>
 #include <asm/tlb.h>
 

