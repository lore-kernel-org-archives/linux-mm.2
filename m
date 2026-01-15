Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D609BD44C46
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 13:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2442C6B0089; Thu, 15 Jan 2026 08:46:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EEDA6B008A; Thu, 15 Jan 2026 08:46:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055AE6B008C; Thu, 15 Jan 2026 08:46:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E51246B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:45:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EB901A0349
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:45:59 +0000 (UTC)
X-FDA: 84334321638.23.E9ECF44
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 24690A0015
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:45:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mJmlJ5Hq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RlgYpsKW;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768484756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvQ4yEZKCe0Id9bcEzGzbXVE7GAjOJVEPO7Y2EJyfnQ=;
	b=QlAsea+ef4IWLrTYHIe4S5GGYwNJTSwo2A7lTE3jD6KkJ6l7Kzq9E/FFokUEjpltkBZiBm
	nxeTMsbYg49SQhgGNI3cm/+NKH0BAqkbGawGVH3eJ8TClUsJ9j/qJ2qyBPVafYSrSNZVGo
	g046D/5D3PdvUlwZ2JhNtsQPGM9kzqg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mJmlJ5Hq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RlgYpsKW;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768484756; a=rsa-sha256;
	cv=pass;
	b=Nv8Iq3jgqXD6kHYzzzRTSEUtcA83JiQy9aFBLxLb8IAQldJuii06vOFqgDu2VipEIrP3nL
	mEz3FwNHh/aBpbW1cswXJt8E6XIzd+WL88NWix8IaOCKgTHZet3C0LbgRGdfTmywZfMD1Y
	eN0TwwJtkSpHGyOzu5Y4ImkZtdeLlh0=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FAcn1O2811664;
	Thu, 15 Jan 2026 13:45:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jvQ4yEZKCe0Id9bcEz
	GzbXVE7GAjOJVEPO7Y2EJyfnQ=; b=mJmlJ5Hq3JAwqtxi6MMbg/Mp5+FsPX8V0h
	dwa9Rp5j4KL20gvaou47h5hYL2WuIEmUBoalU4QUIStPnDKXbKjdomfuIM0UFTFf
	/BBcEdvhVUMocVFJfQ8seItkEwElGshMBc0Zrrfl19jW0Kp/fnOS5pf3o7FSbfLS
	3VuCZSW+ufQFaxAbHKDZ9NRQ3HUTQT/c5qOv3hydmBoZ2wv/V05JGBr/2yi+yR2w
	tu3X8PeKYWWx10BMJxoHzoWnmO4yfZTkBp1faQZpF1qSfECVvbx4UatwnYWjczJY
	Edw//33LC5bCbvIQfBSyJdHFBZoZbNi4rOL5nuAaC7W4BnJzOmBQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nr03v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 13:45:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FDgdTc033952;
	Thu, 15 Jan 2026 13:45:39 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010018.outbound.protection.outlook.com [40.93.198.18])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bbmh5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 13:45:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=szrUKLqWlUh6XZ1h8ZXkVMKW2VgatNGzOnyZkWrxt3VPk2jUmFCHfoefoha/hH8k4zr9mnh+T7sPk4arguv2Se0U5xyF5EzdK9cKg1IDT5vaHJGhyf84YmQUDDk9sT/ZyZH1dwak0m0Uk3tcx0FL08hmI0+z8XzulpWTx8JPSg9h3hmm8sgybQ+qcYAS8AVSXJ5XZAKF92klHM3eoP+CbqnhVOxtVaLrKjvET4UEZ6ddkqUwsf1LTGTOW3g4XcNaSDKeXvu9tyrNR4DY6aPHf8ElwTzYcfCsem7aj2t7BhZ9Edc5glCsH2U3TEYyDkk7eg7hNyMIy+lwuAKg4AMivQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jvQ4yEZKCe0Id9bcEzGzbXVE7GAjOJVEPO7Y2EJyfnQ=;
 b=l+10OfOpGVV3Y483grqCnbwvPmztvQ5V6ZreCGeCk/KxmL3BsDIyQ4LgVHwINO30XQAponvPW8aTA6ToJpDxabmFiaekMRgIh4FC8SBuGQivLYfU3c0cqLCnU5krIybzlJ28sAe7zTjxBQbkp79LfOgA2W/6aTvlwhuMstgRCJCBebI8F+XWCIQAzNqfFhHKtgvYtBXdDlmIfkbjdLYZot94uQeyln7XXDvJMYKF7NZG8j3mz30yOtiWd+n136CLRHnrQWeZjqLDOa2AW6XGeWHgWRgm4tkNeqWzvvi2/s2nMj4FnA0/l1FNHQ7GFV6t8f7sXdoehMnNHMp6cMy5mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvQ4yEZKCe0Id9bcEzGzbXVE7GAjOJVEPO7Y2EJyfnQ=;
 b=RlgYpsKWLiKRbR/wy0mi2eKr94lzaMZe8u25vv0l5XptxezhpPaZ0fo7Mg1VVjcZ5LNxllJpSrqRxlHRSPaYGoxB6Np5CaSuWfjL0Z0uGn643nZ2j3bObk3o+C+WJ2yTwqV5dKKuWb5rWIYRQ2s838EniOPOVLa1zsJQ1Sl+ODk=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CY8PR10MB6908.namprd10.prod.outlook.com (2603:10b6:930:87::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Thu, 15 Jan
 2026 13:45:36 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 13:45:34 +0000
Date: Thu, 15 Jan 2026 13:45:37 +0000
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
Subject: Re: [PATCH v2 19/23] mm: rename balloon_compaction.(c|h) to
 balloon.(c|h)
Message-ID: <109b8f7c-7a00-40e0-a48b-b3e4e30948b6@lucifer.local>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-20-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115092015.3928975-20-david@kernel.org>
X-ClientProxiedBy: LO4P265CA0326.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CY8PR10MB6908:EE_
X-MS-Office365-Filtering-Correlation-Id: cc7bd71c-857d-463b-d602-08de543c5ba0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wRpPgi9SNNgFlLjOx+3Qr3RveKSVPuR2EUBqnVWRYrOMotBECZBGMe0NGDHt?=
 =?us-ascii?Q?i7dX2LKV0331AzzMwzJa7WNQsS8WQEzQqKpwAGKq+QkZJXGqSMi9QXQYkv5e?=
 =?us-ascii?Q?+mRrXOz+ysZ6WJ/qUiKl5wpFx3EqoQbvAd0QzOdvqJheKYI+wfLdrAfasM6u?=
 =?us-ascii?Q?PfYvt1CESdsAes+zc7s8FvVOV1v7WK48Wy9Sq84y1NuCmxl/+e0GQcvRPo6N?=
 =?us-ascii?Q?wV/Qd4a5QNzjnhfaHx7fjaSSETyhEp/Yvqiurf5DUEBg3nwPgDhk1CcZFjxC?=
 =?us-ascii?Q?Lho0Zlv+CLTh/8kcRz9P1ndwqzGp+qqMWc2/eYD1+myPX0CWikGNBUZ2kmso?=
 =?us-ascii?Q?j33xA4GHl7i+aN2Wg6BqKnxjypobcjYOyazAHf570A2If3iqM9ILIpr6wFbi?=
 =?us-ascii?Q?Dhzg3+0iEgu2KdTvNAO0wDO9P89gBtVhERCGspBF4ydUiFALx26osaiwyZev?=
 =?us-ascii?Q?W3KfElEq5VqOpPxo4UUzPtLM98ZsyfCgRpF35mUMW2Iu5Mwo1YryPdun7l4A?=
 =?us-ascii?Q?187Z3qVh4yHnkGx42NPObf+wOK8C6SP9J2tLcmaiKms0koXe6W662oQL0qll?=
 =?us-ascii?Q?/hmXMe8MWWAxTIOOwgVmhzZrm4WJlfYDSZAPo8khdrufX7q2OuOxp4vd+jKH?=
 =?us-ascii?Q?ecwOeSc4TmavROrgxJzVgEQEtR5YoDM9BLE1610ZkfhAVUiUco7DUdUoChue?=
 =?us-ascii?Q?GTojXbf/JR+0l/YkK/1JL98FDclGOvIZexG+4NMuABDFTAK/Js/mQTrp2cOk?=
 =?us-ascii?Q?N6R/aRnY5C6i5b10oMetV4AZHZxPrJvxF4pzQu37XrZsAWl0Q7cQvL63opK0?=
 =?us-ascii?Q?v+v0VuvQfMOTrP6LdDq2KpvU3izGpswpWkIo9hOxydoUbsZEH4G0/O0rU3+B?=
 =?us-ascii?Q?9LDZiWegfEP4+MVvf1IMNYpSUUtfWnHiNjfz+rMWUT6uNmTJlTV5GiTgsfKg?=
 =?us-ascii?Q?/7lOcU2KSmB8AorQ0lyolV32B8ZvutQTKi6EZdyTlJITOv+Ew5uYyh6g2MNJ?=
 =?us-ascii?Q?9fwQezU1GboUbRSfsPWXhfzup3XKLSQaGvpAAhwGJM2Weap8pXt/o6azgGEc?=
 =?us-ascii?Q?iFtZNvCJI+a4YJCj3wRx1XppId2C77TRuvyfkW3/HneJF36sBtAYuhrf/Xq4?=
 =?us-ascii?Q?FOWzEbnBEtKKUGgQnli79L5XGrpQ7jKEvz8QC86DMgRcyB5tAUoC3o2//Z+e?=
 =?us-ascii?Q?rKL0gQdgxBU2VSpc8jDi2rbgw8fAkjlLURFus4k/bzoJWXbsnUCdaYGGPzMJ?=
 =?us-ascii?Q?J2N+kFV2N5qlL3tkr+ZMMAnTigxVXQs8aja16EUHzI5j95SEjXkbR6mqCt+w?=
 =?us-ascii?Q?rBxtOxWMCbbVrKBt2HykXKWT9UerNG0bjOWcWdT6OI8uUrId64PnHFROi/Ba?=
 =?us-ascii?Q?6wCR5YC1Wp3N8agogU1GNyjHLdaDnq/YGSh91SIUkbbIxuQSiIRI1GVumRy1?=
 =?us-ascii?Q?af4oIB7V2dEZZUYTzdfXmdhwysRyzUrzUxjIpudtIRb+abtlNe7LSYxF5mfC?=
 =?us-ascii?Q?XxON/ULE0ot7tEnOEVKlTQxHRUoKaLz4lHJfGHr322KWipsNACpKVoTqKsFF?=
 =?us-ascii?Q?juH58t1aPzir4wav1oA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rud+lZ/YE2XUSG2G31GwUaNHBh3g0rut7WtX6JLYBximpFSFhfKnO9HCty3u?=
 =?us-ascii?Q?j5ap4JK3E2jNTaONgoFUjfFSdpNpyv5w1S/I6o+awsVekI7oe3TOajU50iai?=
 =?us-ascii?Q?s76cvThIW8uSigOXTwYSSQarKoEoHpBooINWbOv9isANVAqVKd1WHjGbJC1p?=
 =?us-ascii?Q?F9vqynzf8Er/Fb9aA+yqiw3UBHS0TiL2AzXXZ1CAzXdPTfyfvlyVgv8KSDa6?=
 =?us-ascii?Q?rff+oLaTFlf383qojCrrbLJjA9ajsX5Z+jSzNWcrw2MypQVRyNT7nxij1IlW?=
 =?us-ascii?Q?8ZC/yiaRng0PjiPqZPYC8xynMc+fq8xJFWR4NLZuWwyZLLHZIuj2EB0TEQ0G?=
 =?us-ascii?Q?kp5i4EvtPj1Jw7dCCr+l7IPfxfwBgiwr+khvpX+g/dZIsXS2+NLGCb2xlipk?=
 =?us-ascii?Q?FhNr2zAdaKe10qgL6oW55blR2NJG5cM2DLuP0dLhILS/nRsBz2GYOYj9PrZZ?=
 =?us-ascii?Q?JLBuqwQfUCKtiapiDJ7RJK102zsN1uNRKdGcNW1EEJiUThuR54vHRFyK35n1?=
 =?us-ascii?Q?m+I3OkkSrOut374aVYPeQzTiYdz6MrxScYMKlZRoNArVACEOcvrQPtPNcVRd?=
 =?us-ascii?Q?RRpRbYtjlws3bxrhL+4Vly0J+FbhXB56+nphLmQvwHQI4Lo7lXGJhfRlpAGD?=
 =?us-ascii?Q?+WuFvoGwdaiQRHA4EL9PJJQhDFYBM4tbVWuhn2Qs92dSx/IIBag7LE6tMrho?=
 =?us-ascii?Q?Tom9Qu0JHcJTtkwoemmD3HdAsOGWu++k9EmirdP+ShA/cnVLcN7dg9qSHQbO?=
 =?us-ascii?Q?tc8//lF2hkHKPaXEgA5X/8fAXMCRCa8kmVzAc38DaWC3LD60tfHA2gd4c+bO?=
 =?us-ascii?Q?P8a24HtXMrgdeSIk+3ARl1hfeiAUz6Ea2ng5BoesGj8wekiFttXgPcOP3nK4?=
 =?us-ascii?Q?Y6t51p2zt7prr3MD9LBpQI0eX3BqOd0um+sdHrSK4JBcD10yVsdGz4s5ZYVD?=
 =?us-ascii?Q?qlMB00w6lNYOXnO5w9hEPg7r6hRPvDzeJyiOnjppI+Yb/R6pYmbRBEL4vVLU?=
 =?us-ascii?Q?GV5v3tEaz4yEPc88W5SmQmn+fLPkIBjgSLoXTXMaG3VattYNM2NVr13Yq66Z?=
 =?us-ascii?Q?aoeG+9Pi67++18M0fd7Sp4cF87bABtOhpAGP7i09svUkGVYHinrNbKSL4r6N?=
 =?us-ascii?Q?N4Y3wzxPWgiR0ytEzBD9RV/HZcrw+Tj22GTDzDh2ywuaZnwshqIHDM7UZMLk?=
 =?us-ascii?Q?F750EAhUDaBKu6+XOBHRuLe7ZOgAeDKj1zHVSNfGmXu01/ZJv/AOI+ED50/u?=
 =?us-ascii?Q?ow3gMuwaNaAG5SiHFaF5W/tjMeODnSWyaeZTxTXyo/gFsK+Nz1ZQpua8H75L?=
 =?us-ascii?Q?KNnkd0L3GDXs+CiqaP44mizDb2J2BDRGaZZJlyXQI2RWkzHfzAteeta/Gg6j?=
 =?us-ascii?Q?7rPr80/8VsygXDmlv3pOFgGNBVRJFAIhM+wlcdX3CF3s4RMTa5QKiBXe30CJ?=
 =?us-ascii?Q?TleHuV2EmYFYYtljiT64QcGSuxCFq79Lytd6GZorchLLMrLfbROhEFP0AqAU?=
 =?us-ascii?Q?qiP8uwi22Xy5gXZsXIH038wc4Ozc2Ondr7VDy4jqmYj2OzhsWceBWTDY7F8I?=
 =?us-ascii?Q?Fjdx++/cXMtQyNJQ0RtaJrjFE3x6kzrZFbJoBRFha2QJ9czc80YH10Pj6dhu?=
 =?us-ascii?Q?iEZ0aYdasl8qYYg84A5uN87B7c4QEQGPOBa0qlXiOpMuZsE1hjNEdNmk+EkH?=
 =?us-ascii?Q?GAsZsdmcPlLBJW1gDjdCX2HvWHQUvKUUR1/7RTPlEc0gKegmhALfKIv8v0JJ?=
 =?us-ascii?Q?os8fcVqaenCRPMewvGoRQ7MoWZsM1jo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vJkewGqrxtzwKvTboE/5SiD1evA5QzmB1inKFnTuLh5E259lb1Kk4Kp+FU4VF7xo3lCXWjU/C4BsxdCC1XBTbmT+3lYSQYv+EA4vBCCC6BWieXP7wDz9x4BnLZMd1sEim0aU7K+J7wWODIdqZzCeWkwfvPggM2/lLMGbIiIDOxlLdd+FjSTvbalAfLqiGJBW1jtkMPD8Wk4Faot0ztRIiQ/G3xF1ognM0JtyNVGiE7kZzjzGnFiOVxVMCbEsLksL8Tg4YPzBMTOhn5LuF8Fdt4BwLcfvzPZ6XCGCFrAMz8/TY75WIziBJL+N4M6StPPzsXUn3SHuUYuOrbfuGHCg8k6xP5FOQpZJg7A0PjrUjLQFMkMBlsqQYbZuVF2ylp/xAnQ/EtGm5Dq+prZsKGiE4civ6+zLh4wT1tsMQKsRrXLAdDRoQeGnHEaJQUAxh4eR9M72imwEu8OORuwzmxm5KR98jhvcO2bSwoxQ7pRD2i2BP1Jr8rSzss0P2Ko9YaJ8ny4umaWAXtj4mJ8KvAXPoHvhFZiSANdKWn+hzgTC0CO+oAkJmfBvFJGIOJpYxxD8ki/zSR2ZfOJPWq93+ftEgPBitaoETBFoQl7GinQdZF0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7bd71c-857d-463b-d602-08de543c5ba0
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 13:45:34.6837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZUmEguN7KSdS5kOrsSZfEdwoDG+fC31KLlJHdUfsIIYyaF+6hteo+csD2aU76C4pX2e4cFXPBv3iVMhZ5Sr53KWhy/xq5Qw+eX//E3ddp9Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6908
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_04,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150102
X-Proofpoint-GUID: sRGelpxb5s00MJ7fAHvIDM8X7wVKrgp_
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=6968ef84 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=YtWJq6x_0QH-J-6snmsA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDEwMiBTYWx0ZWRfX7ASxyhEuhCr2
 Rct+37C2zAvTD425WQQBQsvYJavzN5+gMC6qtMfFMGd123LhbfPNSmn06VYMNTzEykspdiOwrRo
 PO77lodgLskkB3iiuqvPq8E4rytmhdTatN81nHzKpc0Kgv2xU/9xgmRF21dLjxly/a+FM+Uamy9
 XeCPoo160FTMDJNjOxzU/oNwoIW37FHNtPaCANnbRs9Cm380kZ35i3u9LAm5kI7yW5/hKIp6dpu
 MFeMy2KtkLLvW8x2wTNQVazS71EDb/1ZD338825HptOfBnE3ZaJMeoX6Hil0O7pXX3g9O2PIOSC
 nbxHrhyzQMmNLALyAWWerKASyDC5mHTc/fZUnF1m0PkY/FF2ZxSd5XjqPHxpFD4PWGfrdnLC+hB
 w6cm1QnUJpKwF2LRn4DUgU/Bkv5nh6hjsxrQjNJNmdJfZrqyxQl48GM/9wwe6XSKLA4SG3xSReB
 PyI+8fu9pEQrfben3bw==
X-Proofpoint-ORIG-GUID: sRGelpxb5s00MJ7fAHvIDM8X7wVKrgp_
X-Rspamd-Queue-Id: 24690A0015
X-Stat-Signature: 87mjmae4bkeci1p3nhj8pgf73w8oa1ne
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768484755-186007
X-HE-Meta: U2FsdGVkX19UXPd8u0R34HTQzn9lyCVWxbunRQNsCOuoby9Ex9FVgwmFlSUL+nh/FaQQ5D0oztjk5lO8Vrkq10n3c5cl1UAmAjepO+0prksUarMRhFVIGAd9KxdPSD6QzT2xRGkRmB0QDI2FXjW39ZfWF4FOQO0KzdA3AAF+rElxKbb9Ju/Gw06w70CdtG9Lc8W0bjR31SauIWpwPAum7Q4tJhWRZJgDu3+qTdHYYulF1kYokm5isQN3oTKKx5PdHgJUiQAuhRkcSI6BITR1qq6RTPKO00WrLy6Symj1Zu7u2kyENByJV6sE6hFk0rW7YiRxHFCcMdRj2rkUsMoLPAadf4iqtTprM59pTbsnpTkC+fZU/5R+CAj4ma+KXi679uhxbIXeY910vsN5Tw6FcVUG6yOY1HWn3pCHh+Owzb+beHDt3ySq+Ny7BaHRLsQTOerkG90pfIUDrvTrlwqiva2jrO8/xJimOSyI/E5ln1qg35L86SbVkmHFl/FEuFmsl5CQ9KpEpF6nGPDJvfsM028WZbLVjfeOM/s1GgcjvxxOfRGLWwhpJAQWsdkCFQHiBdQ7His/Q94dc3KYbLLu657Jf9P8SL10fmrKsYuNVC+XydXxFSGLAhLH3JHyJnCgGhIy9sbMJ3me9/jRf1vCvkq6BgluxljBALIn28HCA7JARKYfMzmmPyRcxlJF8aGL/zTr7oSwlmM4GDC2F0wg50rv6H19cb3Sz8cbZiNr/fmewSNi0fAjQDxI2cDyXvFvxkOwsBy7jN60asncL+z+TDTFEbiAIlBS82sCcSUmBA92iCHLA7K17DgBJh3goDWLHXmFDHBtDxVEy8MnRVmNEDAEove+IeqQLYr5+mAyIPCf6xr1bTRYjKL9k6z3RtseEfNzg9xkgTyV/aBXBNLVn3fFdFvCHAzDQpiVkfepVUeknr0fe42gY65YVu/5TkcBJ8IV60Wu7p/NdmEIoW+
 4YUJbofw
 pypz31Ux4KEE3a11hzxt3WoNYbKwRFMOywVmTrQJVhJ7NC8BYR8aYM4C6FwR2Vmr7u8EFxR+mn8sEk1OcuZQfJ9cw9X0sqPltCnSNKdYCDdJrDK0bgSSgIoq5/lHnhvzW9gGjf+fRCExedzne9y0LKF+bx0MNqO1HJE+mlOSFAagvMvEil7KhKHBTVC1fzcQOtP7l397kLF/U37QSJdPWtQd9hTfiQpu5kDV9WGRl7Tr6fAy8VIIlJ7eAjQeTyE0zwja5rQsy2hO9atL6pkEcivW+ijrIIaqvVmtTKwwvRE2HokpctAwjSJexWAMJCI3U3k8vfBqX4MMN7xsLzwas6bZW4L0qwOvKsgT0bHp17Wuw8EMWtKWkUX3sVp5Vm6nhLvqEVBXWXxjLeOO8TCZcNvXJbytDh97RZXohI42QvrIvtYaUIhwL5hcT27LDd/aiN2K1uipuQXQiXU/RQNaEKIz3S65DOZTTchK0q0BhW3vYv+VhV+8WHUvqUgN+LxILmKeUsVUgBvMsQDee3rVX+qqC/jg1Y1z8oMrwtlfGBEsbfmYDoVO+MfRF1ihdltm+255dy2BicuXl4ZWJLCmDsZg1glRjqlLr6uHUVJ3XA2JlVUw95Z2YKzDqp3Aerx3SpUVGoyoM79Ykz0wCV48WAtqgeBpU6sSYY9RP3DRnSX6c9rgDhbQOV6nVvQUXwIdC+ldK1DxBb3Kpygas6SDwhc41/+J5urmz8LPBuEQ34NZ//dD2FpJlgKEDgCgAvqxM9yrbZsXEKf0BlTs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 10:20:09AM +0100, David Hildenbrand (Red Hat) wrote:
> Even without CONFIG_BALLOON_COMPACTION this infrastructure implements
> basic list and page management for a memory balloon.
>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

Seems sensible so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  Documentation/core-api/mm-api.rst                 |  2 +-
>  MAINTAINERS                                       |  4 ++--
>  arch/powerpc/platforms/pseries/cmm.c              |  2 +-
>  drivers/misc/vmw_balloon.c                        |  2 +-
>  drivers/virtio/virtio_balloon.c                   |  2 +-
>  include/linux/{balloon_compaction.h => balloon.h} | 11 +++++------
>  mm/Makefile                                       |  2 +-
>  mm/{balloon_compaction.c => balloon.c}            |  7 +++----
>  8 files changed, 15 insertions(+), 17 deletions(-)
>  rename include/linux/{balloon_compaction.h => balloon.h} (92%)
>  rename mm/{balloon_compaction.c => balloon.c} (98%)
>
> diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
> index 68193a4cfcf52..aabdd3cba58e8 100644
> --- a/Documentation/core-api/mm-api.rst
> +++ b/Documentation/core-api/mm-api.rst
> @@ -130,5 +130,5 @@ More Memory Management Functions
>  .. kernel-doc:: mm/vmscan.c
>  .. kernel-doc:: mm/memory_hotplug.c
>  .. kernel-doc:: mm/mmu_notifier.c
> -.. kernel-doc:: mm/balloon_compaction.c
> +.. kernel-doc:: mm/balloon.c
>  .. kernel-doc:: mm/huge_memory.c
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0d044a58cbfe0..de8f89ca1149f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -27536,9 +27536,9 @@ M:	David Hildenbrand <david@kernel.org>
>  L:	virtualization@lists.linux.dev
>  S:	Maintained
>  F:	drivers/virtio/virtio_balloon.c
> -F:	include/linux/balloon_compaction.h
> +F:	include/linux/balloon.h
>  F:	include/uapi/linux/virtio_balloon.h
> -F:	mm/balloon_compaction.c
> +F:	mm/balloon.c
>
>  VIRTIO BLOCK AND SCSI DRIVERS
>  M:	"Michael S. Tsirkin" <mst@redhat.com>
> diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
> index 7fd8b3d7e7637..7a3c4922685ab 100644
> --- a/arch/powerpc/platforms/pseries/cmm.c
> +++ b/arch/powerpc/platforms/pseries/cmm.c
> @@ -19,7 +19,7 @@
>  #include <linux/stringify.h>
>  #include <linux/swap.h>
>  #include <linux/device.h>
> -#include <linux/balloon_compaction.h>
> +#include <linux/balloon.h>
>  #include <asm/firmware.h>
>  #include <asm/hvcall.h>
>  #include <asm/mmu.h>
> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> index 53e9335b6718c..7fd3f709108c2 100644
> --- a/drivers/misc/vmw_balloon.c
> +++ b/drivers/misc/vmw_balloon.c
> @@ -29,7 +29,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
> -#include <linux/balloon_compaction.h>
> +#include <linux/balloon.h>
>  #include <linux/vmw_vmci_defs.h>
>  #include <linux/vmw_vmci_api.h>
>  #include <asm/hypervisor.h>
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 6ae00de78b61b..de8041c3285a1 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -13,7 +13,7 @@
>  #include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> -#include <linux/balloon_compaction.h>
> +#include <linux/balloon.h>
>  #include <linux/oom.h>
>  #include <linux/wait.h>
>  #include <linux/mm.h>
> diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon.h
> similarity index 92%
> rename from include/linux/balloon_compaction.h
> rename to include/linux/balloon.h
> index 7757e0e314fdb..82585542300d6 100644
> --- a/include/linux/balloon_compaction.h
> +++ b/include/linux/balloon.h
> @@ -1,8 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  /*
> - * include/linux/balloon_compaction.h
> - *
> - * Common interface definitions for making balloon pages movable by compaction.
> + * Common interface for implementing a memory balloon, including support
> + * for migration of pages inflated in a memory balloon.
>   *
>   * Balloon page migration makes use of the general "movable_ops page migration"
>   * feature.
> @@ -35,8 +34,8 @@
>   *
>   * Copyright (C) 2012, Red Hat, Inc.  Rafael Aquini <aquini@redhat.com>
>   */
> -#ifndef _LINUX_BALLOON_COMPACTION_H
> -#define _LINUX_BALLOON_COMPACTION_H
> +#ifndef _LINUX_BALLOON_H
> +#define _LINUX_BALLOON_H
>  #include <linux/pagemap.h>
>  #include <linux/page-flags.h>
>  #include <linux/migrate.h>
> @@ -75,4 +74,4 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
>  	balloon->migratepage = NULL;
>  	balloon->adjust_managed_page_count = false;
>  }
> -#endif /* _LINUX_BALLOON_COMPACTION_H */
> +#endif /* _LINUX_BALLOON_H */
> diff --git a/mm/Makefile b/mm/Makefile
> index 9175f8cc65658..1e31e0a528dc1 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -122,7 +122,7 @@ obj-$(CONFIG_CMA)	+= cma.o
>  obj-$(CONFIG_NUMA) += numa.o
>  obj-$(CONFIG_NUMA_MEMBLKS) += numa_memblks.o
>  obj-$(CONFIG_NUMA_EMU) += numa_emulation.o
> -obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
> +obj-$(CONFIG_MEMORY_BALLOON) += balloon.o
>  obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
>  obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
>  obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
> diff --git a/mm/balloon_compaction.c b/mm/balloon.c
> similarity index 98%
> rename from mm/balloon_compaction.c
> rename to mm/balloon.c
> index f41e4a179a431..5734dae81e318 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon.c
> @@ -1,15 +1,14 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - * mm/balloon_compaction.c
> - *
> - * Common interface for making balloon pages movable by compaction.
> + * Common interface for implementing a memory balloon, including support
> + * for migration of pages inflated in a memory balloon.
>   *
>   * Copyright (C) 2012, Red Hat, Inc.  Rafael Aquini <aquini@redhat.com>
>   */
>  #include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <linux/export.h>
> -#include <linux/balloon_compaction.h>
> +#include <linux/balloon.h>
>
>  /*
>   * Lock protecting the balloon_dev_info of all devices. We don't really
> --
> 2.52.0
>

