Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CCADD4117D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105F26B0092; Thu, 15 Jan 2026 07:30:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8016B0095; Thu, 15 Jan 2026 07:30:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB4B6B0096; Thu, 15 Jan 2026 07:30:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC5EE6B0092
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:30:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79510C17F6
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:30:15 +0000 (UTC)
X-FDA: 84334130790.17.5ED6606
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 392F240015
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:30:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WZwz5vyk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pKYh8FQm;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768480212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzKh78YSrTveFScshVcTX/+yATqvdVjY4dZF6IvbK8Y=;
	b=mp90fek1y8A3tbkKMVUSaPE2ZMrJCLA5zLh8v5u3UyMjroOWWoAHEduWxb1zpvV7fcdtu3
	/MZDijMIdNO1PzLZEh2Qni1OBednQ8ylsBbpj1LMZ6oyL/GP/Gw2PRyFxu7kQs3+V80LR1
	aj3NwhN/EDLPWQMNgvmRtaqYbE0auX8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WZwz5vyk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pKYh8FQm;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768480212; a=rsa-sha256;
	cv=pass;
	b=jxJaVjbzNxmR7/a0s1F1w3h1lvuB4ZuzFDDRlbAtB8JcjzWqk3Yv0JKsIWcsmyAwhJF66X
	G9mgF+YXgESz1V9vNj9fBvfNG9qekNfkr8AzWNv/SdF2ZpUTGvMRFW4dxECfQObGRcUmWm
	vfW/MBDN2tTO7byEvB7L8P3bFKFLVZY=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60F9k0fI1362056;
	Thu, 15 Jan 2026 12:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zzKh78YSrTveFScshV
	cTX/+yATqvdVjY4dZF6IvbK8Y=; b=WZwz5vykyHbvr55MPuqpT+6iaQJU+j/5VG
	vR0xPiN1OqDoQNJAwGHePgsApZ8ZY2m/hEySd0FNJtBlvKIxQGbKXuVR0mKzvQgv
	iWCsDWohQNdcRNLJ7YG53FaXSTPakrnKItxc/P74zS87kO19CCsgJ1mKMZItNBZi
	8dPhJNtnBkaYmR5yyzbsLlo9TFuC8N6fktvCoPJk59UIzpFbc0LZKA+hxoSw5fxb
	2/QO36mAS/2jNx3nMjbkhEzEc38PamVC9sEE+Ix9nYM2EehbaXICMPWM42ygtlbo
	d06Zez9lCJHL0oeBrtwQZQhylD9b3q8yQpgyIzB+aTMOQvmuG7Aw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp2wfm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:29:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FC3cmX032734;
	Thu, 15 Jan 2026 12:29:54 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013046.outbound.protection.outlook.com [40.93.201.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7b9kn8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:29:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BFmxk8ClDByMRFcz8QvOy7TuN2BZK5IRF5fRJ/8KEbIx9cuzyq/6Ob/Ni++nbdBx+5OVYsSilWyrO+Jh3v+XSSrIgVclkHADiHBiSsbS5nKmr2e3sbPvkJ5Ax3m5ZHLS16A0jvKgZ5mcXd1V/Ew10LwqHwysxcsm1dm041kSGzWaxNaTSwkjJTIsjkWlx3DyJ9op86RB12CC5kADy4CcPjOE0+geafrSSLGe5lK3WpHKOu1m5viOWUD4hybF6skYxQP4Bnv82trBZxxDxWbrz4Xac7qr5a6PML7/nNLczQmvLg8cUPyaDQAvwSAEtbv/kHrQKj6ydUaiwAmpjnwHNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zzKh78YSrTveFScshVcTX/+yATqvdVjY4dZF6IvbK8Y=;
 b=twJCEt1x42UyM4FdGJQB1YyPdTJ0K3YzH82FrAD7uyd7S+BFie2iUI+iKp4aNVyggoQ8CJ5XIL1sc+SHIfiYmPGeUUn5le1P8ru+HvtRauLEUFwJjspv3Ob+2RP0zGL4LYu6cLwPKZUdzAjJyb9YJhcVZR+SaZVY4gSqIZbfIbdm57XyiiAIWslgmyD3c+pikMaZjL3CHTOhULOj5BRkA72CmeUhuCZiXfJVIqPfsIYeYJ98+pvMdyZE/DVg1El6L8HJp52PyLvDSZd1g995O8vkncKaC8T4gNZiPMkr9tJnT9cwaRaUmNt+M+N0tFrKxzvM5oNqU3I3QNguQ7Q3bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzKh78YSrTveFScshVcTX/+yATqvdVjY4dZF6IvbK8Y=;
 b=pKYh8FQmB82u61RW3QePn8quhzwHZUv3COgwQgaiUiAh21L03OMZiZQZfH+3FGIL+/aizY9INx8Kee9md71zcHaItc3Hzouh+dplaPNpOkCJ0+DrRyxjd/mpPsPtekN7vb3zvybwWYws8OUHyx1pMlOqYibb+++LLmatQVgOHio=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS4PPFAEF42CAE1.namprd10.prod.outlook.com (2603:10b6:f:fc00::d40) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 12:29:51 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 12:29:50 +0000
Date: Thu, 15 Jan 2026 12:29:54 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 12/23] mm/balloon_compaction: remove
 balloon_page_push/pop()
Message-ID: <ac3a04ba-6a33-44fa-8269-79317f961e08@lucifer.local>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-13-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115092015.3928975-13-david@kernel.org>
X-ClientProxiedBy: LO4P265CA0326.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS4PPFAEF42CAE1:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fb936e6-b05c-41c1-5ce4-08de5431c75c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ie5RVs/v8lfIh91c0MIMiEahChuvhxwPv2UzS+fhvtXo0gbLQAoXqQ5HD/Nm?=
 =?us-ascii?Q?hr7r+INfA/oLXw8ULprHECoXlxpizq7E7xBAktKKj+/+tj6uqq6ZPpWLNZWZ?=
 =?us-ascii?Q?GJY8nesekjxqQnNrOe6A7SEvGyOgWtWLh9nnwejWVs3xPgBtemxXCTUVmiKt?=
 =?us-ascii?Q?rfR9T1dHxRzusP0TsP4kptehq8hdDq18aljVXzvQNUsaVRmuz/O0qC8g8EyX?=
 =?us-ascii?Q?tn+JkWAZmpiOkXtcjEUw6ILBUmLl03FVrqelxP+7ZWKFrODLLePpyycIuQAK?=
 =?us-ascii?Q?5C3Ui426N4Lf1hxyrdZ44Vchcmy55MuoNzIfWpfs9jCe6Np2Gm9KoOFvI8pZ?=
 =?us-ascii?Q?gBin2GnoajwyO9mQkOTqypAxuQXq1MXj8upSkum/UM2PgexGde7WKOCVC+I3?=
 =?us-ascii?Q?MQebJNUmSUhOnCXcgUG04TCCV/B9W1l4/Fo3/SLIaTrnbf+TR32cO56eLPw+?=
 =?us-ascii?Q?B5675LEOYe93A54ga6VbVauJMsQHRZNXx0pAQyPXlx+njkSsl2mkfXgbWMCR?=
 =?us-ascii?Q?R+RvtW29LVfRVLlyiBMiJJVmrdMNAVF2WCoxlV3rNqlEoT9WO/Gv64lEtrLg?=
 =?us-ascii?Q?llqCc3fTimyVC+jqnKWEAmn90r8SBeCv/cEWkQE6bt35b1ySodHuJ9NM6FV/?=
 =?us-ascii?Q?6YgeBRoqlb/bBdsSkfYXDg+jtuGs+Go94+BS13CiNnAlJQsJAD06V8x44WhT?=
 =?us-ascii?Q?LQ7L1HJZEIT14OPBA9XloVdAOcNwPz3UdULKuMoeS/09bai5gvNtNLKTN4FT?=
 =?us-ascii?Q?sGzb+b4vRKKtj2JwbLhQI+8KMfXhDIzki6+bTNyaYiVCELE35MijtuBApYwM?=
 =?us-ascii?Q?Nrg5F+swTb6gcOIz8kCgn/aTTrcdcAFL08/m8e0g4i277xRlehTw2et+aq1W?=
 =?us-ascii?Q?bmPQW1YzXO+h4l7zAcGLA8h3Rwyj8ler+HKC5fbDsvUFMqitp5ujq7xepen+?=
 =?us-ascii?Q?EsHRPPkWhq8bqy7QV2gECA2+WkIC/8A3QG3OxwHOGQLQbtYARIJElm7zxAvg?=
 =?us-ascii?Q?Tkza0G2DZcAeGcAgLmfmVTT64GOklkQYLjdNLjMnV/g29X6WdLVX7zbSKos9?=
 =?us-ascii?Q?2qk2jHeMX2R7seCtSaQ1Q9LWDj2DXbl2D06yPMn6S0wD4O57L1lhnrN0ms4w?=
 =?us-ascii?Q?zffisbq4CRWwKXR2c5jYoYFacDp9ZGDLXFA8Lq6ZGFRW5UcZ+eFsaDuwnd8W?=
 =?us-ascii?Q?6aTYEiuT8KA5+meua5AeEZvpPhv0B42QfHCnPcWohVZTauXUs15g6gPNTXNZ?=
 =?us-ascii?Q?x+PC5r8Ct2Dh5wwpPhDlvdrQ8k+vKlGUgvqUMHVDvNenMA13ELo2nJHJnA5y?=
 =?us-ascii?Q?7lddXT1lpiZWfP+OhAP8HEdomhHOjMYl0iFL/WF5pc7RNnhKl8DqrJwdKZda?=
 =?us-ascii?Q?QMAX7JZawSJJDAz5NgbSn2MkuAnWe+CcQwcg8aKc9RCRFrdtrg0h9XcI5m3+?=
 =?us-ascii?Q?AdPdPxbv7DWID6zFal4I3PcuqHLKHT1nJBI5F4cWGR/I0L+xQi29CbTT3dNC?=
 =?us-ascii?Q?iF8tHEOplJ53Y+tY/8erDE7lNi8be7cdUYWR5b6l2vygbyhYJa9n0Xwh4gsq?=
 =?us-ascii?Q?LaZmkWs4/+blk80xiAs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Pu3awRZf4JQcd9Te1naHs8jOlCqEYPk/V0/UkK98/Fq+C5jxYLICD1KKGC8j?=
 =?us-ascii?Q?0zaq80O5fkxtVzm4tXZOe4saRvr5e8QbVdThTGI68MSe+aPINrHhxqBMbsKw?=
 =?us-ascii?Q?GaCvspiMB50Kr/36aTpY1IhiL8itpgqtv8V0UmQ8x4L/nwf8xbSs1/tY+k0/?=
 =?us-ascii?Q?Jtfhb8jrdwlmXW9WZyopCzPkzJpEk3WUJBhJe+7DLOrmz9n/hzUJd/TBMrMw?=
 =?us-ascii?Q?ThhFDcEDpFPmBd1Y/b2Kbk5pLDHaHPREKsa2uNFHGcZAeH5pMJsRirqfIOuQ?=
 =?us-ascii?Q?rzDilwBDwCq1pFSrkwi0rNvGLH2c9mi8YCoHKRfL1I0P7cDnkNt/0+jDn4WS?=
 =?us-ascii?Q?piWKDh6j6rmHkbiEcj935qUeV+mAfYcyQePAculScS8CJcH10QAynBWTyC/q?=
 =?us-ascii?Q?3sCA1PtLWvCBdIwN72cJcJ4iUNBuaBPnRI0MZjf3TUgCgoFXacy1yGnYi9Qp?=
 =?us-ascii?Q?zkvRC+/dGbxPsCCJen2JHt/YwYl+FaMp8L5WiIh/gPT8/Rp4ENIclEm7i6ZJ?=
 =?us-ascii?Q?Q+SRlqKNdN7r+zBradVtVKMeZ4yVu0E65f29mCgOX65z/Ww9rvIVBo0BqbqK?=
 =?us-ascii?Q?hY5K8nBh5fitOtp28FAXQxmxY4VcuVkH5B5UWqLGw8DufhViMSg6UTvcwraR?=
 =?us-ascii?Q?SRiAo5JI33RUrDDSnMZCkn4a5GXgJbrc66kxmAi3S0N4wu69VKu97NiO8snP?=
 =?us-ascii?Q?FZ96hpJgOXbO4fP6T80NpTSAn7sG5e89F0fp6AhQoq7NOrn3k2ZYP7ttJYeG?=
 =?us-ascii?Q?ZMQxzlev1m3spU2HbJg/8k8j2yUkEg197gxox1jg69JxyPSn+wMC+YNLEGO+?=
 =?us-ascii?Q?7ig0JLUvfqz0vQQRU08KL5x0Mu8nPYxaof8HoHtCLby/9cwrG+5mmO2aKeVW?=
 =?us-ascii?Q?Vrd4QToCWTVNpkaO1Is5KGHraXhI0IBMiF5KMddUXdmzz3bJLlHaLsnft08m?=
 =?us-ascii?Q?gEyKJWJ1D6IqJEP4U/3NVjerX3Telfq3MJT8PFa5Jm6pmPTC4KHVb3llJIlq?=
 =?us-ascii?Q?KOnt3IJFuMoow/8YyGQoGKCioFxv8xTJAimGrYYrGYkGRYB7RuSzLSEKu7Ay?=
 =?us-ascii?Q?4Aj08REHXVOsSOvrKxhh6N9ZeLF0HTkkUpmVN3tKPyFrroYvF2r/xRNIjbMB?=
 =?us-ascii?Q?T1ycn+jIg7Q3LycR+YHFRJQ3OacEnSai9R3XL6Bd9ea0rHtp6IIpcFWzYh3L?=
 =?us-ascii?Q?dLrAefiw/OrmHWb0frJi0jU6TPb4NErJsrw/OSnrRcmbfyoHsuJQn1cehq8l?=
 =?us-ascii?Q?HbVJKetyd5MN2IZc3i33UFIA5C+2tmvYpziMfp3Wq1LMHtTM3dWbpsQ4h9EZ?=
 =?us-ascii?Q?5E6pBpWEZWE2EFQ8uUAR8XPrzfIH4MCD+XqtrE/vcb/hHslIe56A5370+SZ+?=
 =?us-ascii?Q?zKQS+sbey6SdSC/Gd4sfw9SemzInp4ycKN+T+j3L3IBOvF9AuX02K2KXqzMT?=
 =?us-ascii?Q?UtZ4WYSHuPAapQc69h6KvhZFGwmwU3sH+k2vUgo31xs0ytIfU2QlFdvMDgOi?=
 =?us-ascii?Q?tuj3m3FGoK4Kl5bqFEHHzrizltMyfVh9zRYz8ypo8yx27HwkFXnCOsdXpSWI?=
 =?us-ascii?Q?AJUnqcywImSiFthh2ePsoDYzhqxKPHESn5XKjSZ7AjtT/019Gah1H4Jp/Dd7?=
 =?us-ascii?Q?S2u0vqFIA5p5wWxJdVXUIBmixE7JyvbI8rlLl4l8YJllhxY15azyre/iQRi2?=
 =?us-ascii?Q?lYIT8GeWvG9coJa7folJdszCT69Ec2bhRBEfx7GDp7zGc7/DGctDeZjCR34E?=
 =?us-ascii?Q?wuPubiQom5OpdlFncIVzScNW6PR+D6g=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dUdVF38SrICO7c5Kyj76Oohns+TAWRIYAtgm/oAOsrw2eF8gJ7ieRMpsg4/jILSMXtdnT1kxdcnKy5+Fmxhk+dCs99zvwLPEPFCz+GKeDjKFsVDZxWF25yhfcAlR4gkBvPsrnEroe5JBI/ae6hODddwb1kifr/UbBjUJmiC60mfNRfAewjBWqpiKM8UhE/E9CM4VIEsQe1a8fA6J2WGARF6+rViM4kU/0WTZS/fD1LCV8uNhVUHr7Ojz2r01ZsFeCJok1ceztMO/x6e2tqkgeXIzfRajXMLHVUG/d9jKKBWhv6AlywWjJRuTXUEUCsNw1V/uCfcyhRyMotF8v4H5zd1W/KwmZP2/zVSXaO5lk4lkMSJJGqr5WO8SP7ZaFD3Y2iV8qfLUiPUu2VpNM0YgRiMZUFwHEawDY2uAQ9leCrjn9WSUTJaQJr0EHk7YQMt8X3k6CgSyhrKXjlQwPm8V5tcTqEVtLOIlt7S405VOhF18Ymn1YMccBDiGycJ/Nxfyc1QPyKX3xvTgkqhRy2OgEoGvX+sqjNkJQepspEEuWqm1QmdyT6mB9dPU3EC604wq1dDVNohHRbZY9Jte4LFv5A89NkYaBIxX1yShIpDDrvM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb936e6-b05c-41c1-5ce4-08de5431c75c
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 12:29:50.8870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +voU9oLZZdFI/ifUmtrV0TivxZX9m9bv1gGYFpQ5SXVVJWl2P0vzg+cGr7EBwQbjcBNc0AmxFGBjSL3BYPfXHsOb9lgTlR6JjXsP4X0WVLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFAEF42CAE1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA5MiBTYWx0ZWRfX/NJLS492Hc1d
 BUrVHXN3opAkfJmtRhX/iKCXkxldwQx4mtg1bAl0Bwd+3bOsjB5KEyqE2sZHCNH0L3jcNRHj71F
 ySFZkxMrz06ucE27w1k7R826zo60IHAG7sYOvvxo29YY+2jRK3Dr/vGA4Xa2mlRD4TchDIKGS8j
 8vdUeYIZhhPFPS2pckbNLs17ykBHoBEuxqIcbiaJmDgvc+l93VbfEDnW2Jm+JVNj+RhOhfgLFJ9
 NStiIJm8iJf1CNCK8jzlbxd1WFRViNnwzUdOgqkbLna+wTESChxTgQlrV88pr3zF/AoJs3dt4ED
 hTU+Oq38NG+9SyHdW4CU96kmzhqYZi4JiLDFe9cNBgX5qmeRw5FL7J57yJ1ho/2s+jaH3SrTGfJ
 EZwzwbrROhzkBPwCTwQCDNymMdPSVjv0e4363ZI8CM1jb7CLiM0LXS31ivv5ubv6VTKdusYdSSZ
 oTQaBRFc2eCAWlmlixw==
X-Proofpoint-GUID: gExIVj5bKJ9jyqe5394xRIs5m9b0mcJS
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=6968ddc3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=S8wCikTqho2cSWVGLLEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: gExIVj5bKJ9jyqe5394xRIs5m9b0mcJS
X-Rspamd-Queue-Id: 392F240015
X-Stat-Signature: zztahyk6czgkcqku39rce5u5h67ughd7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768480212-410330
X-HE-Meta: U2FsdGVkX1/jTmWu92zbDEHqSnd6x3bl2f/9dPrV3+lzBIqs8zJGGXqliFGVxsS5hbx2raBjTe0XQi6CPTlQNi38FTDb+SZvzY2cQL8q4QWFUB6+dhgxtzUBfVIZK4yebZoAfj4xEMrPEFy6NPdUiwYgRx9+nXeH0YKNHLxrOyVqy39gR/mPTU1vO/ymmAOH5cKVRnxWkrW0BSg8gmvs19JFz35A/YYo2YMTHkTkihValfwuQeP7+dP/+Iq+/UdvAiJalRkvVPJyPtm7/NUHfs7RHNHH/ae+GRCW9aWa0T8y9rxmn78owcMwtzPNoy63ehjySI3p6cO2Xkp6pcuJjCUgRN/nxrkafydjjmanGjBxJyIbxjF57spmprqZuyMXoLgQb/WXz51G0b6qxVQ2K1KAQ0XAI1UZT9x+KOWGC6fujppNORguW0GhdnVH5XlIh91FXottKJWvrv9QCtlbtgv0fa1F3+EO7920JQhkyQ5zoPU0CPEX8dOxsLQxksirh1bAl7UZ4PYwIXGYBhunpX6u3oM0pr7CCmy8yoddC2PaCXilGL5Fi7EWriS7dChIn+dA9ZdMiNRj6FKlmx8SjPPwRooH/fSAbLLdeTAG+8vTKe6ldfjmhftOQdX6e9BJX4AiKDt5SnkFKUVrR2rqhYUXYDI5tVZYO7KJzjHDGLvKrNgp3zDDOrJiRvgYTeozUjznrd6nlsUOlqI5ASlswwld9im5ZUPGqFAXWDy8z6xJPv/+XSrXV+rlALZbswFlPQ512obWLXb+fT1HAZs5bLzfiREPJjahYfA6km+RhWcwpeh+q+xdkZrQazXLx8xxi9cwlpqfjOCoL9jsAsg8SREaUxlCpggTdSuUaz/gyzzBXdelcF7K5QmYXuFwbQsY+qmpMmddl3jyTX7Yh8UPUfw3k7HDXrZedM37VewyMAkSkskTIqe2/cn/ftrJWDTeU7vUQ2476Ml/NL8p08Q
 HgtFWYVo
 DwjOlgKP7/jFD3Gh8exPWTUlrQfNpUVbWm28bheJ25WpEAqcT/zQ8eT0ATAP9nQF1YpcsiD540akMlHb/Pn7m7KSs4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 10:20:02AM +0100, David Hildenbrand (Red Hat) wrote:
> Let's remove these helpers as they are unused now.
>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

OK exactly as asked in the last patch you do deliver :))

So good riddance to this and:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/balloon_compaction.h | 30 ------------------------------
>  mm/balloon_compaction.c            |  5 ++---
>  2 files changed, 2 insertions(+), 33 deletions(-)
>
> diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
> index 1452ea0635245..e5451cf1f6589 100644
> --- a/include/linux/balloon_compaction.h
> +++ b/include/linux/balloon_compaction.h
> @@ -126,34 +126,4 @@ static inline void balloon_page_finalize(struct page *page)
>  		set_page_private(page, 0);
>  	/* PageOffline is sticky until the page is freed to the buddy. */
>  }
> -
> -/*
> - * balloon_page_push - insert a page into a page list.
> - * @head : pointer to list
> - * @page : page to be added
> - *
> - * Caller must ensure the page is private and protect the list.
> - */
> -static inline void balloon_page_push(struct list_head *pages, struct page *page)
> -{
> -	list_add(&page->lru, pages);
> -}
> -
> -/*
> - * balloon_page_pop - remove a page from a page list.
> - * @head : pointer to list
> - * @page : page to be added
> - *
> - * Caller must ensure the page is private and protect the list.
> - */
> -static inline struct page *balloon_page_pop(struct list_head *pages)
> -{
> -	struct page *page = list_first_entry_or_null(pages, struct page, lru);
> -
> -	if (!page)
> -		return NULL;
> -
> -	list_del(&page->lru);
> -	return page;
> -}
>  #endif /* _LINUX_BALLOON_COMPACTION_H */
> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index c44e0b62203cc..90b2d61a593b7 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -128,9 +128,8 @@ EXPORT_SYMBOL_GPL(balloon_page_alloc);
>   * Drivers must call this function to properly enqueue a new allocated balloon
>   * page before definitively removing the page from the guest system.
>   *
> - * Drivers must not call balloon_page_enqueue on pages that have been pushed to
> - * a list with balloon_page_push before removing them with balloon_page_pop. To
> - * enqueue a list of pages, use balloon_page_list_enqueue instead.
> + * Drivers must not enqueue pages while page->lru is still in
> + * use, and must not use page->lru until a page was unqueued again.
>   */
>  void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
>  			  struct page *page)
> --
> 2.52.0
>

