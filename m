Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 617C3CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 17:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC48A8E0009; Mon, 20 Oct 2025 13:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A74EA8E0002; Mon, 20 Oct 2025 13:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 915358E0009; Mon, 20 Oct 2025 13:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76FFA8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:46:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2314A16023F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:46:39 +0000 (UTC)
X-FDA: 84019222518.25.5C6F8EB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id AF116A000D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:46:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=R2JMtTby;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tLBwaV27;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760982395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HmXQLFA3sePioNFDMpXcfwcPIAA+cNtlyI55K4lJ+Ks=;
	b=om+740+ZKKbfsKMuGonYKK9NJJV3KzvBxW6x8b93hfC/WsI3cS3C6BBMXqmFNgCzrBo1Y4
	gt8s59iJBQW/QxD4w9JMFALL361iqhZ484NPigq1MMHCso/vtFrw12gY69dlK6NGmlOXUv
	7Om5YIaTkN1hF0g8IuBxTZsp6ndCUOc=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=R2JMtTby;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tLBwaV27;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760982395; a=rsa-sha256;
	cv=pass;
	b=cCR0H3lLB2mJyZyxOrcV7PX99i9JEVilD5ifHw4FtE6d2otaVFolNH4X9O0f9VlFMwAAz9
	C5iR9sM+REvd90FHjIanhNjfM7VM6OUDoWN2S8xYEJZYQ654y0oU1SGWsTav+gGt4Ctd/6
	zL4L/bp2zdApnvToNYqjFFkNybOV4a4=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59KFjxBH032533;
	Mon, 20 Oct 2025 17:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HmXQLFA3sePioNFDMp
	XcfwcPIAA+cNtlyI55K4lJ+Ks=; b=R2JMtTbyKty9T6c1F2/a8gM5W95inrlRGJ
	yefElrB3I5m+pKcGQbc0E/kE19XvKZMYN3oOnaDUHAZ5T5gYMDMchm4t6TjRan7h
	hY3v6VlrYJ6QEcAzgSux8YqRlnOnUd/Zsgp52hXmwimFvPPOvoNTUkTlj+KmkFXf
	CincCHsXsoDXjAXO8Ujovl9q5Qosd6BG4xYa53j3fdHWkRYtJL1HoKXSxi+otP0C
	HGj54MrgHBCpeqfktZuc5A33cn4Bo5NUPrpP/k0s+j1zk5JzHgnXihaTBBMwb6w4
	PWePe1WcmZT5iW5oBxv02EmdcHeayOO3AZOzcPSU/m8Mo/mmliUQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2wats6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 17:46:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KFsllZ025448;
	Mon, 20 Oct 2025 17:46:27 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011066.outbound.protection.outlook.com [40.107.208.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bay926-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 17:46:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yQyTPlLTLMA6rpYur2XrtnGT6+HqRFefP6dvpXohwVuz3BfcKKh4iUOgcvL5LD9/ZeREmrFlMJDLWV7KNSR/I030U8nFuQ1nI3AINymT8vD8M4BHvcXXxNKbTJHkD/J8MERGJmFKXsDslhKDSY7ip1iwh0jUXTO7uA72xPjP8qzlEuU9pA4jvQmNp45Y+mPVlG2HAG9DuiMl/HHWkItZP0t3nyNg10gkP3iw0ohYpA4QCi5gfQFYwnpk142o9srzDunkM6vlvyCEj3DlxKJLH2i3SQI6EzFFSraWXzSO2VrZruN6pWf94xq62q6UOaMsRD1Nc3aCeIrycvcqWMp/bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmXQLFA3sePioNFDMpXcfwcPIAA+cNtlyI55K4lJ+Ks=;
 b=B/9jTeauMEspbZiMmQgE8z5zQevkPIEwaaozb3wJN2rFTY9doSxHu1uGxINfu257CS4C3OZejK+pOsObtkR8kzryWcgvRclHb7AEjEjsQqz3Eb2Nz/YjgPzpxocYL1KZ6BhzVrVOJiw2dEy1+4l/jfgDlSL+olm5+ySeM3zYwj+cipDK7fxqFwMV8z3/EFdm7AH5b4gbEJsWYntWZ+mVuwSNLUvVmIzRj33HLEwC1BNSuDspnTpUjZonzdJphQY9KEU49tUFDxfEbkTlzYGubfmpEVX0IVUks7jcgsYnC0llkMZorW/KO/iRnEMyKPDchwo6uiBeE9gPwYCHrTV/cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmXQLFA3sePioNFDMpXcfwcPIAA+cNtlyI55K4lJ+Ks=;
 b=tLBwaV27ME2g1mKKgCzrRz8v+1NkwOMc/D8j3aYkS0cWDcySOOJ8MhG8mFoWjdLLqsKsXBT+s0XObX4oTwCQ33H2Ax/SgavetuLH98bwquGaXvW/fXN241W6O7k4V1JpkjKV6I1g0/C2Fx1FUo6QTO0eQwxCHZN5AaxFhoT/u3s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB5920.namprd10.prod.outlook.com (2603:10b6:8:af::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.13; Mon, 20 Oct 2025 17:46:24 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 17:46:24 +0000
Date: Mon, 20 Oct 2025 18:46:21 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: guard is_zero_pfn() calls
 with pte_present()
Message-ID: <749beb24-f38f-42a1-9d7f-64a41de20b8b@lucifer.local>
References: <20251020151111.53561-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020151111.53561-1-lance.yang@linux.dev>
X-ClientProxiedBy: LO4P123CA0683.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: c38d46a0-9511-4a13-508c-08de10009661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PEnadaQOy4aPcfZuKwkjDnMIgWph1dCOa5Zz+ge1t13TqrtQGnDoiDRKpYO/?=
 =?us-ascii?Q?PkI93ekmkyVL/FO/1TbtzjIKe7ZFBhhMVfGJSdIeuQqtznIeFvZjO4kJq01k?=
 =?us-ascii?Q?zZy4P4g46NTTdiX1x6TaK+Y3HMbHrAc6kH/oU14SKmUzJ8ybWgzYEPRHYzMa?=
 =?us-ascii?Q?tnOwJ5POnZVPHSBAh/q6rDViarslxM6zKwXvAbiMn7Hw1/cU8ADFsT9kg+Ka?=
 =?us-ascii?Q?s2sX/OPZfWSjJzo99U7Opp7HozrCGtCGYk20ybUaffqtnPDhcSlsZUEikT5Q?=
 =?us-ascii?Q?MbV6NpJ1M84/7H96XjZORke1/b/3jfV2j+h5NrOe4zhPK3R0iqLtIL8wkdlI?=
 =?us-ascii?Q?2nCO1JH5CoJXk8THb/f9b081rNbG8osGEalhrWRZLEPyOj0ihiyt6eTB8OhY?=
 =?us-ascii?Q?NpGbv3RLCTQEndhboxixPGFNONb+89/YsASn714rI4JNDq0OwIOigjTrsxls?=
 =?us-ascii?Q?5TKl/V5QPd8gHD1XryFvqCjEPUxR8C5BtG9l3l4ch8+nZvbaWcShESIx7tMD?=
 =?us-ascii?Q?pzgbt9BEoiScJRi9+RcncuYT3QO5kzBxhwQnkabw1hqz1CUKAzNi/zx3HeHN?=
 =?us-ascii?Q?/SkI5BPqst58tjn1l02y3vfPB446EVwSh2WoJLIHBOb6OLkc+Avr70XJxqf0?=
 =?us-ascii?Q?t8Q+JCnGvja8STZ63lJzZYIODsYNhnfiHaXPnO+rBLMDIxxI6l+emBdr3M3k?=
 =?us-ascii?Q?fYB6VYYh1kwPXXMXFZ4Cb6OiLqKB6YL46ba8rxmEUHVgmwrSheO4zkn2Q6OK?=
 =?us-ascii?Q?Q2dkE2FS2AWVy8E8rDkkIT90JBV50kNJlwXevYYsRLmQ2IJyjso9opYj0oGo?=
 =?us-ascii?Q?EVGtBFqTqkc+NUHJkFF9rQAaWERcZ/bKYYG9meg+cedxf4wp8gq48Iq9kzQm?=
 =?us-ascii?Q?YES7+TZDgrBMVUDl2U1cgMRdeojJBotEZAo+HFuV6LetscMASUqebKp+t8BQ?=
 =?us-ascii?Q?YOlzQgPKPh84f7NdTUjIUkMqLMAk6rP/sGCPrAlP11mzZf+JbFSpTp91fqH2?=
 =?us-ascii?Q?g8FZ8SuD+Ztht1DtCXrb4XXK8ZRQ1JIxP70F9D1O/eg7KKxGmezTrhn5PvfE?=
 =?us-ascii?Q?sxBNaC1nk7bsBz5+SqEUntXd2m/348E6C27BjEaIFg78ejcQcrzraZqU5C+i?=
 =?us-ascii?Q?USijuhZSoJciTyPUzcPGF5fQ/Vc3rTafP1VZ8NiMYPFsEdGTNfpralL4Z5pG?=
 =?us-ascii?Q?qt6DTqigJwjQK7LBqAV2KmvzeTkTWOwvzysxDvwvwdn5U7Gpl05k606U6drT?=
 =?us-ascii?Q?FQdP0PFWPHdKwsOLXHGoRZFRrLa0dvbXyyo4n2JS4MAWWxNV5plVzimI8/Iu?=
 =?us-ascii?Q?0QzRe16I/7cTuViyLuxZVPpKn9ldC4zsITsrCU86JXoJLOZepHTVMkfcPbYg?=
 =?us-ascii?Q?711Ugo6Eyf8vKJukPw+YqF7NEn4az4LjOkaZtbRtoqcO4u4Q1XGIEv7VZeih?=
 =?us-ascii?Q?l/RRnVRCpjMekC2HoQ7fEnvf/A60R9mi7MNsXUHtQygClQTJ2N/24Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hywO4phYd/nG+qzBneKygSDGySgGkHyGY/GWgB+jifhqtBwg8ds1F8BH5dgf?=
 =?us-ascii?Q?Te8QlnZX4YCI7n24+NuEvT1Fv9GWYxDS0Zy/Xd4lAIc15LPrw+SJmbbyJjOr?=
 =?us-ascii?Q?TNeJRo/iax9A7eK8MlHVOrhV1Tl2rfKnwMLsvnQAQDsAf8+bm+1k/t6WZkyE?=
 =?us-ascii?Q?OtxAclGGhYkYQJ8FDV7nQljAn//Jv5kbvvKcBCP0Rqrq7ewm689GwlMnnPqU?=
 =?us-ascii?Q?joJguuTmQ76f7l1aNp2GFaiDGVO1ttTbGoguorb3RFjZa90nu0qc/F5dGZ74?=
 =?us-ascii?Q?yf9yLtZ0PN1homgJahSAbB5WVBhmNOn0I4jI75B/fA8AlYzRxNp8MHZeeFmm?=
 =?us-ascii?Q?rs2Us2HPFlwdJvC7zcUkI0b9npkbATjefO5tFE+ZURG4mGiUJeTcsQwjzvLf?=
 =?us-ascii?Q?pPWma27nqnEp7+Rg8t1prQVk1uJs/mygivrKHZRxiLvhKwImmzyU8EWNcN5n?=
 =?us-ascii?Q?qxMpg9sR4qECAdSGh1Yslq/OmmSuB9YtJ6HpjIcPmDOElfzLicDkF7NlGMeO?=
 =?us-ascii?Q?glfgxKIWsa2elVODc7HpMuhbOtUEo37JuovbmRQvRJNE/3EkfHQdy9Xn1mtY?=
 =?us-ascii?Q?4ASeRpWoyCOwluqN0Elkj5080ZPULtppC7geNofzsCc+8vVt2yOOWo6IGlyC?=
 =?us-ascii?Q?4zuQdrjY/2WOSciyuwtqlux1S8yPjS02l73moLVyHlWGsaxq7bJSFo3vFKUB?=
 =?us-ascii?Q?IOIzgICzzc/SsA6jLk1l1CBMz77FIpqyO1fg23frtUriWWY97Kk8VK04uG3g?=
 =?us-ascii?Q?kdq9it5CM85kzp7nWmG9hLZn+bl697FPF+LWTZsMvjlz2AZAKs5Rtg3Bxf4y?=
 =?us-ascii?Q?PWKq8rZk05wKJ6yX4M+0Ol970SGLI9QBwKBcQFwmcuDSe8C1FDYvtq3JFjPY?=
 =?us-ascii?Q?xTw6n8SwcHXEPrcMB49TFBnxfeR9inYHQ6MbkRUcrsDY0IwD1OYb6A4E7Swk?=
 =?us-ascii?Q?e7EwuCJSnsjj0usFaRWw82O/2nSubtL5ZHswC8zWhf4OPoSO0Cknti4eX+G1?=
 =?us-ascii?Q?WR46XvY5F/tw+23bJoR+lNvbr5+W+4jDKnMBEmsRRjcpPcYgvVV9k+2kNn+t?=
 =?us-ascii?Q?4v5hWCyHrefqoqsyX2qLmQ1dH2C/lsmO82ZII7WXLQ6AC+x6AgrEOyKTTWIu?=
 =?us-ascii?Q?luvc/AgRHAlJ1Pkfh3wKvsdaGhlffo0DG9waT8PTxqMJjFNtIG0uOxKYXMp8?=
 =?us-ascii?Q?/U2RNmSvArdaj+JPD0tu1sliNOOB88XnCJqf1woKSRarJjCwWM5YwM6YW3qT?=
 =?us-ascii?Q?37jHe0Qg2MEvH0X4bl4EebbvJPOdeLKtpttrV5RXqSFSByT+Ml40rMsqeLBY?=
 =?us-ascii?Q?mkLEzTUl/i4dHvmOkLow5MH7sB14efPt6DOe1gk9nIIUfkTVnzg6U3HjdCNn?=
 =?us-ascii?Q?juxCY31PeHTBjso6JOd2pDYXBd5whEartHUCJIXMNYhjarA5DMD+Yz+RYsvX?=
 =?us-ascii?Q?CRE28/Y8hXHwqerZDN2b5fG93bIrvWdwiJIrz8yB8WiWqd9i4Au7UK7TwxSY?=
 =?us-ascii?Q?1OyLwtkGsAGDM6UPf7Ddh2zkznU46rr/brpbh1OaTJ5vHJnMypXVFLqcppKb?=
 =?us-ascii?Q?4cypCxwFbQ7jnihHwMtMFVLWgQtaJooYug2tLQCicFNeC295DHW6awIjPGk5?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DMVd1+EKVCkGVfvaL/ZDW0dgcgX213oTa8Tdvl5dhqmzMq9n2ZzmP1nHo/+swcFYLwCBDNp2S5cByZXO5adsrpRuYd9j9ym/ws3H7Oy9E7LQ5y1vmx2bh0qpdxs6K6ae1B5QghBehkjna0fhevpmHD31dVTf629mwOhn7h/rwnhOXuMaTHS5jqWBtNYfDmyFQMJzyOMf/aJBA1ilhOqAHNgUABGQn6/Gi7hR9iI9seF2agjNuX/S1UQMmEX/BpcEl/zNVSB1pShKRA3sAy0KYmXvzFTa5sh2LglwHQL32FFQ9cymIOFvacrSmMCi4c4qtd50NGT8RdscMgakmyyA2TfixCgKhzdF6Py7BlUbZSWgnA62BUDCmt8+JpfOjJO4Az8RVw74jf9xW/b1zFtll6L/Rhzgx/WWeDzlP2J4/WhJidsdqFqmELW0545bS3kPpO1AETZOWntfjDC1nrRgCNkKhJL1YVriqAUOL4lpExIGZAqz9O4/FKN3e2YtShfyyjrQzFbqzEUoxpPelKUi/8qxm3sZlmNWHOWnvSuvILFcaRaxujeHKIG0gzXt/K5T9sbDfWzSr++IeyZWhOTCgjNu+S7T6MFrKQrxNHqTRaE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38d46a0-9511-4a13-508c-08de10009661
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 17:46:24.3790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +nzSi7H3YRuXMpIspcU74TKDjE6Iw35XRqEVtGD2N4bI2Ptgo7i7pKa4NKv6D55RzK6h5EYJF5cSaI4SwvNbQsXmroECfFRpE+HDaOwoMqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5920
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510200147
X-Proofpoint-ORIG-GUID: EVM3Oxn9WFQELqUAyoLxL_pUGkVVMSFL
X-Authority-Analysis: v=2.4 cv=Pf3yRyhd c=1 sm=1 tr=0 ts=68f67574 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8
 a=SRrdq9N9AAAA:8 a=pGLkceISAAAA:8 a=GElsPB9jUl91-3LkTnoA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX0eIFkzxxV5je
 tf9BTaTjyqdUWLIlKeeWhcRpvAwB1unZJVohCD11HoOc3q/Y5S/FtnVo+UQyBhPP3ORIyxWfjEF
 PiNfEVIU9KaU4uLJfD8nDxX5FxLTSTHBqxZRcHt2yFeNmh1OQZPxv1kF0QQcO/sODNGgdFOymbP
 JKC2QG4m2oJeW6jmBcNvD5Y79fRmcWETtm2gHItksYaZ0QWEXZtNmfAS5U7BueOwaaAVVW7O+6D
 xGza3RZPTpBbwu8ebiNRtD3+h1Y7hmAtyTmhMg+kRFJ2VNmTAyn8K0DzDotHyKIHkU6hJ/IDgHI
 7mdtutwLW1F5IfP/vAd8cYuYEV0gnYnLEYV92ibIGCH7DDuMTymd70Tatp+maAXMyS1UsnLXOB7
 ALUcf0mBFPhho1knuBKtdN8Ey/Ithw==
X-Proofpoint-GUID: EVM3Oxn9WFQELqUAyoLxL_pUGkVVMSFL
X-Rspam-User: 
X-Rspamd-Queue-Id: AF116A000D
X-Rspamd-Server: rspam03
X-Stat-Signature: u4misaowipkjiyhsbhm8mw4syfp7aijt
X-HE-Tag: 1760982395-16287
X-HE-Meta: U2FsdGVkX19lZBdgLEIZHajLqlDzt/ALbvNuVGGeiRA6vbX/oeF6DZYI2F5d+m2GyoHt8A6FRrae3RYESTZm6Z7P+2Gwa5InFKy+motrKBku9XzMuVUOL5NbDLiEznb8kSamuzThegL+i5ufY8pz4BQEqEOdDTmF7oY6QOaHDRZWY4W3OJrfle8IM6WJg8Jx2xHPoWpedF3fiqhYNquBi5j9eFZHyrFoVVE0+aI6C+A6rFFAHbclogOR5JuFhxnhM3d4iAQk5AtaiqUMafVBBxZ69pwxk8werHDXxnwabxMrkqw54AetTPaZoD54xAggnFK1VBE4rrHjdv7qhw8Ebe4aYOwW/Euw6DiyAAqoatr3a5148XDuGfC3enwoyaKieNPc3YUrep/QqbshdCS7ESZHpcq5YGrSUT7uYjRyYGfQ6qmxGhKkDgz6soJTfugRSyW8mmzg3oTZFS1RvygFyPXt9g9ioDZuzIZ8n7MaTy1zJv0OkjNmgOiFOLF6CQNkIpctfZQ3vqmhwkx1iQEY90FHPlIErb0vrjcs1uUuAsr35bCIBlZVg/M9T2UHvLD0enG4zJPygfr75b5sQnsY9n6BEEz15DQ6AR4w8xecwJL3v7BSwDfCW4/6S4ATTgxgEGq7fASqiIdzx0PbhmP1sGkutwFhfeh/y+wR0r7PCFdg6RUFQ1r+UsdZfZmwNB7sV7ujJ6KlSRGhZDm3xvlDl0e7Wkrob66sL4tbcMwtRyqDD3SQEq9H0oKYo4L3aUorGFR13K7vKR3C/x2NPnmmP6WW2x45tlzsRlKG/xS7yZnU2gy3BKWQKnmFVb/tWOQwLODmOaJjVi4Ri+3//hNDxNFGsaEIdfAx5Ywo7osT2Mdc2LT5KL4+x16imz7lQF1w+AF0HilLxjE0GtjAokco0FaH0+yAIf+N6PPV+F3itmayk/m3bnRHvmxA+AoBodTlB8tz7bdligdomHBwF4z
 YDDcPM/R
 KVTl3e6vTGRVpiJtoCUU444mgTKBi5XbWX1uuwGhcKDHwqT5yPdptH490/GFnia35jHP2c16p3jbUeEThyFtCHWw8RAMQJXTHqi5uaR/yXode4b+hiVA3GlmoBhzZ1ATlhrHrHyZvP3jXwBrGs8pxT2V46UXB4MercMT7TqsQ7ycslYnMqnWGlbfezRDtCkRT2bDBDKw97eR58ukSKhr8DRtcbntfM/ImQpoXmt0Y9AuzEmKFecNZMtmQ21/+thlufiz6xQpPXEkBkzA1qn4WYMW8DiyChuJpFYdkZpaqo00V2iN4S5wa+epnGSBOewstEfJFxx4R2yLjgEyiqyVhOLZbJ6wOGyMM10fRy4cFz4lVwl1soHF2lVdzWgZBZ9x8m+2NV4tnetOOzbt92Tou3WWEf449J44x+DaBJvX9IgA6WG7mXvL7lXGsQcs3RHSxOfwuRglJbtRAehEWBaKWtszr/DUh9v2EBQXVQtE249PCBLPpEk1SUuEjMH9SBCW44nmPOWhqlS7gP5zeYzBBNyQXC4CsI73vRpPA5BArXwjEmBY7G5SyrGBhHACjucPBYM5AYtiZZj11fiqwru31kMIl52RorlcTSUXKUekhTr/3HHajOrI5axY9q/OdSzJGwfaaw19FTDmffXtvsZaL7p6wS7gQOiCp5BU8mjNlUHfqzk7RiQPUpeuQyFbjNnqopyRpn3lY6IovG22EF3CQE7/QIe/94vK9T0j/bi1p7jYjRKlIEiRYr1fUCgAklB8CN9Yn9dlPb0dd5EtjtzmD8I3MC9KHwX+12Fn1MHs6zkODD5phW7CcLklr7fc5pKrNb2j8eqvC4N5TfeVStg9i+7puH2TobQtnmczFfG8L86XNqKwdQTOr/EYS6F8f0wW1ppwB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 11:11:11PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> A non-present entry, like a swap PTE, contains completely different data
> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
> non-present entry, it will spit out a junk PFN.
>
> What if that junk PFN happens to match the zeropage's PFN by sheer
> chance? While really unlikely, this would be really bad if it did.
>
> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
> in khugepaged.c are properly guarded by a pte_present() check.
>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Nico Pache <npache@redhat.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

This LGTM thanks for this, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> Applies against commit a61ca1246ad3 in mm-new.
>
> v2 -> v3:
>  - Collect Reviewed-by from Nico - thanks!
>  - Add a VM_WARN_ON_ONCE() for unexpected PTEs (per David)
>  - Introduce a pte_is_none_or_zero() helper to reduce duplication
>    (per David and Lorenzo)

Wow I hadn't realised David had suggested that too, that was actually both of us
doing that independently by chance lol.

I guess we agree then :)

>  - https://lore.kernel.org/linux-mm/20251017093847.36436-1-lance.yang@linux.dev/
>
> v1 -> v2:
>  - Collect Reviewed-by from Dev, Wei and Baolin - thanks!
>  - Reduce a level of indentation (per Dev)
>  - https://lore.kernel.org/linux-mm/20251016033643.10848-1-lance.yang@linux.dev/
>
>  mm/khugepaged.c | 35 +++++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 14 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d635d821f611..6f2ae2238b5b 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -337,6 +337,13 @@ struct attribute_group khugepaged_attr_group = {
>  };
>  #endif /* CONFIG_SYSFS */
>
> +static bool pte_none_or_zero(pte_t pte)
> +{
> +	if (pte_none(pte))
> +		return true;
> +	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
> +}
> +
>  int hugepage_madvise(struct vm_area_struct *vma,
>  		     vm_flags_t *vm_flags, int advice)
>  {
> @@ -518,6 +525,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>
>  		if (pte_none(pteval))
>  			continue;
> +		VM_WARN_ON_ONCE(!pte_present(pteval));
>  		pfn = pte_pfn(pteval);
>  		if (is_zero_pfn(pfn))
>  			continue;
> @@ -548,8 +556,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, addr += PAGE_SIZE) {
>  		pte_t pteval = ptep_get(_pte);
> -		if (pte_none(pteval) || (pte_present(pteval) &&
> -				is_zero_pfn(pte_pfn(pteval)))) {
> +		if (pte_none_or_zero(pteval)) {
>  			++none_or_zero;
>  			if (!userfaultfd_armed(vma) &&
>  			    (!cc->is_khugepaged ||
> @@ -690,17 +697,17 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>  	     address += nr_ptes * PAGE_SIZE) {
>  		nr_ptes = 1;
>  		pteval = ptep_get(_pte);
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +		if (pte_none_or_zero(pteval)) {
>  			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
> -			if (is_zero_pfn(pte_pfn(pteval))) {
> -				/*
> -				 * ptl mostly unnecessary.
> -				 */
> -				spin_lock(ptl);
> -				ptep_clear(vma->vm_mm, address, _pte);
> -				spin_unlock(ptl);
> -				ksm_might_unmap_zero_page(vma->vm_mm, pteval);
> -			}
> +			if (pte_none(pteval))
> +				continue;
> +			/*
> +			 * ptl mostly unnecessary.
> +			 */
> +			spin_lock(ptl);
> +			ptep_clear(vma->vm_mm, address, _pte);
> +			spin_unlock(ptl);
> +			ksm_might_unmap_zero_page(vma->vm_mm, pteval);
>  		} else {
>  			struct page *src_page = pte_page(pteval);
>
> @@ -794,7 +801,7 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>  		unsigned long src_addr = address + i * PAGE_SIZE;
>  		struct page *src_page;
>
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +		if (pte_none_or_zero(pteval)) {
>  			clear_user_highpage(page, src_addr);
>  			continue;
>  		}
> @@ -1294,7 +1301,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  				goto out_unmap;
>  			}
>  		}
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +		if (pte_none_or_zero(pteval)) {
>  			++none_or_zero;
>  			if (!userfaultfd_armed(vma) &&
>  			    (!cc->is_khugepaged ||
> --
> 2.49.0
>

