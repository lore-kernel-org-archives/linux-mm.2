Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4498CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 10:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B3C6B000C; Thu,  4 Sep 2025 06:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BAB16B000D; Thu,  4 Sep 2025 06:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05BC16B000E; Thu,  4 Sep 2025 06:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E221B6B000C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:47:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F11E1A0AFD
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:47:10 +0000 (UTC)
X-FDA: 83851240620.16.E8E3EFE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id DDE2440008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:47:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ci1o7W0E;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=skvkYFMZ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756982827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s8r2TQ3D1w4Nyru0iZ049QrFNBkXaMr7gXcIUD93kys=;
	b=IKTxw9m75KBD/jxsVYouEtcdJZ7vxJp4/S2kIk1RWsLgsmbb9xjsmsS5rn0/F6YEcAXBbx
	gDmBSCDtQj7+VJu9HN2OpZTJ5H7oOfaWfRITU3jjceaB2eiYKu/T+uI7TL/j/fqge6yPNA
	Mfu5dgfReTqrrG2IONsucbMtCVfCDRE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ci1o7W0E;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=skvkYFMZ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756982827; a=rsa-sha256;
	cv=pass;
	b=g5ByFip7TSWmD1oILYyPFy5SMU5knIPRgoboaKgSt+N7ATWYbxf2bhAf9zdOT2wR1tXjg3
	gamNkZnCLo8yIwlf0tYfzYyLgFiU9rRe748Q2RWJTUT/FSFDjKfFZLbEW77m/cUSZu55rL
	ZaWeaT+6hYFkzuDTFkOG0kciGdaSEwQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584AOuEX002436;
	Thu, 4 Sep 2025 10:47:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=s8r2TQ3D1w4Nyru0iZ
	049QrFNBkXaMr7gXcIUD93kys=; b=ci1o7W0EbJxPbS4K/tbqg+s2SbtbDFwA73
	j2r6T2Vil40Z6+/BJMDzmAytRnCN4O/V7W3mPUlKkGsYwrPidVGOYV5LQcRp/YEE
	WmS/mlrd3CgVo0zA3OXzboyH2Q5hih4NJ6XHIeMdPRzl6TyAZZ1Afrt9YJewVGIa
	oC0nhX4AT8oqFG4IEH+i6Upx4keAqxPWIY+xWmo/FhqZKV3mYaDNLcT1RQbsLUty
	cRXzomzSNhtdVfD3MSEYqJYM5QEFxdSR7TGXZaxX3tz1Y2I4QBvXSCLu78ThkMer
	/Ei7vka4ibpWBvOgLHjsGljn9HNCaVMzKziJUsmgSXc5yZFLcHXQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48y90680yx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 10:47:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5849KYDT040148;
	Thu, 4 Sep 2025 10:47:00 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012060.outbound.protection.outlook.com [52.101.43.60])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhgh7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 10:47:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DRa2HJqiJoI3zXQjM3Feuf99llDvH/jm0/+TclhcR0Q8g9YwEXo+aIQYg93OHccBoXh4ZVk855ULBe6n+0IqFxK0NU9mujeJPlE5Rdea1zx+HRSveHfXFXRtJll307PvHZhRw2AesyKgWE8u8rAkXZa2HBL/lL4rhqcn4SefbVc9Xm6LDNwvRWgIxPjC4dKCPeAz4J+V21YuN4yPy8SUTPVrSQyzGpEpRfphJRgNR59NYln9KKOBv47/S/6cwOnks8pJ3QOpo3+vTIQubZe20GYf2VXikOIfKd8+05oz0rLqOqN+aUZxvFSLkY0q6l06/ANDA0X7dRfppf1N/VL+PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8r2TQ3D1w4Nyru0iZ049QrFNBkXaMr7gXcIUD93kys=;
 b=nmC0dpbco60awfMtvSNM+x7qO5yIL8LLUG/cHxel93SNKpuL+kgmKo2V9CL7ekOypoUTkl3PqAk+C8dLx9o/vegIA08vkWC3nO1rkPd1rHkOmUYEi3o1p8MCioiU7/EJYie4tCIKEionNmGQ20sh8bSuz5RilW8yDz7x434yhz+LHgekUYCs6QZgDsMtjFrP7uSryKJaTCHuBRrhCpqdxdt12HPhR7VrU0Kf+niSudkrEChO615uAtV41zBY2QpZkDeLJtdlvBFaLbp8Gjzp8P53vD2SCexNLkJL0oOyZjNTKExM69iXsJ2LyN8thIr6vhSGBccfwx6GOhMxsplnDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8r2TQ3D1w4Nyru0iZ049QrFNBkXaMr7gXcIUD93kys=;
 b=skvkYFMZimbDkvt4RvioByYKqj4YKvgAHQd2Xx+mrvEv6uRqEyP78f0g8mAZTrPRGsgAnGrDZyo2dC2wILhV1wBkfgFU6tTuReNWtU+7xM+YrAMRtHdvADEtW1SuTp9f+whfT6ddRMT1ZqRaKTa/8o5+NLWGsnnNwaZR/+u+opE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB7026.namprd10.prod.outlook.com (2603:10b6:510:289::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 10:46:57 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 10:46:57 +0000
Date: Thu, 4 Sep 2025 11:46:52 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Joey Pabalinas <joeypabalinas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-mm@kvack.org, Brian Cain <bcain@kernel.org>,
        Kees Cook <kees@kernel.org>
Subject: Re: [PATCH 0/2] change "a mm_struct" to "an mm_struct" in comment
Message-ID: <247f1fb3-6966-4789-8f26-7d4126318c5f@lucifer.local>
References: <cover.1756966290.git.joeypabalinas@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1756966290.git.joeypabalinas@gmail.com>
X-ClientProxiedBy: LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::29) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB7026:EE_
X-MS-Office365-Filtering-Correlation-Id: 40eafcb5-e217-44ee-349a-08ddeba05eae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7lZrbKBsnF0ObNzmx4cjRF4Ihcq9fBAgNo4oSyRxjjXg9tjIl1q+0ApwHiEg?=
 =?us-ascii?Q?kPes9DoB3TQNLBKhROkO7HWYmZFl172EWWIwH0kk3aBXRVXwIXIFM/ANXr4x?=
 =?us-ascii?Q?cuB48AouunwRHt0YVTz7KebyrPJMIsJ/54wSr7aL8mPLY14FZmwJiDETHLNB?=
 =?us-ascii?Q?SBOzwHgWzI9USqnCDiiFZiw/Va+n3TJUykgf3mkyDGoB56yhWFJwHFCgIpUs?=
 =?us-ascii?Q?eZn7KgF1cyfWjBLKryvXzDtPi5+CyW5NsJxQyNnk1l4hhjKjrZnCGlCB0MsC?=
 =?us-ascii?Q?OtYGv0uhrdBFxElnxQ7shNtRFvO3UfFlVOKIzEYiR3goPo67XwjtVLPj6v3q?=
 =?us-ascii?Q?D8lIQbgW5nWL5NGJ2I9b+dtTusFiuO9hlZ9tW5guU2jwdwDcIrDVEL91OT1R?=
 =?us-ascii?Q?WI39IyBaOtoF+u65STRy7xs5hiGOuBkc2bkzwv/duqYunZBf6cVjxPOmHhS3?=
 =?us-ascii?Q?gkzScMRjUB6jQKPIbBx3pYch+idFE2DaZb4fGF5Nq8P3T02IQE4xHIbuuprX?=
 =?us-ascii?Q?hs3UMC24gQ2IrXyQc14eRDZtkYPAJtAvCtq6UX5HuYp6sJ+ZuWcF8P3b8YHU?=
 =?us-ascii?Q?r+xLa16bEtq0RVQPnhE4x7vIlDa4DXM1x/VlcoQnasEcxIAE7B6CSMxKFt4Y?=
 =?us-ascii?Q?OrIRGHXlCrZIBPCm2wKhIeJMBV6m/5kWkVVtLzGXjzh6w49zVBFBo1vzgO2S?=
 =?us-ascii?Q?86xyUmIhDZ5a4JE29UwPg9SncQ/D1lF//8pBHkMor910U5oKlnN7zg0f3mho?=
 =?us-ascii?Q?T5f3PPX213M9dT+KEgnxclpTsfPe/0Gfl2lzfMgNGJT7cksg1tv9kGDVix4c?=
 =?us-ascii?Q?TKBrv/t8eAVGBCMkQ4tgafUWQRKvIcPa1tKWsPMPu6Uy9+ZRSv/fnzYGUKay?=
 =?us-ascii?Q?yTSNHXdt3GfODGj9jKqhxJH1CYZlA3e2LdnSi/b4/FHuHPhlUVHXA0DJ24jc?=
 =?us-ascii?Q?c3th7xuST0ZxD6eyU/EYrv3i0TyvRhcHBo+FMRJDSeVIZNXxqOVyn2JX22+n?=
 =?us-ascii?Q?SgrjPnJQxotcnBgYbt5YeiTK/i/4UeoXCfi9hThlFUwpGZHS0xp5m9Ok6zUz?=
 =?us-ascii?Q?QFTTn16VUwrp4shBqi3nLX6TwZbOTJrd5HE3UmpgRMELqlf3CHgtMr72yl5Q?=
 =?us-ascii?Q?h/jxAFxZo5a3DJX3OaOS6vcScXOoeBpiKYST97Sj+0+LWSUPfGSJL9nBWCqo?=
 =?us-ascii?Q?1nQo9Ba+3mfzB36xfNfyBY8qjX/WpLdIWKraQdtAZiiacS9wnj9aYz6B4SB3?=
 =?us-ascii?Q?nUIWCN8IMD9Kos02FZ+/LjdPPYmTgAFLsvW3MTskXtBs/R5eBN7DTvqbRbbW?=
 =?us-ascii?Q?wGny8JnNI4c4JA3I/sj2ycYFIkKlzl7lyBZNiKwg3CI6n/9HdqMfNp2ZI+mo?=
 =?us-ascii?Q?+kr2lSjQvX1hK951NIhHJ5EI0fmGtX+9hkPfw4COzl5QU51672yxTHrJ/ylz?=
 =?us-ascii?Q?v72ZZcYPzYI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kBFd7sTj/UzsNMUyp7S3mA7kuXF5ERIdXUk8AGkztbuqJZKS/UyLmW/CD0m+?=
 =?us-ascii?Q?9myKYMvXbbXGXQNGzPkeU7dlJ9AFkjQu67OpbonP248DC3v0cK5oz0DAhzQb?=
 =?us-ascii?Q?STEr2tOa1siY3cL3cR/5nfEo2CuJWjDf56w4+jW/87J6VoUWaMP2o1z5KWVL?=
 =?us-ascii?Q?vYCSaivmS15z8WiHHKb8KZOpIyNpPXMTa5uTTnitDHg4+siD4aPiZBQn2AI0?=
 =?us-ascii?Q?/0yR6lGm0pOvl/29Ds9TY726NeDhI3hKWK6qPO/7JuX0ABy3ztWW9xvigc6t?=
 =?us-ascii?Q?XSUvMhQe7av5nGeBA2pNMzJP7XNB5ZDc5fayy3saVI50+64HHyegRlg5Kdcn?=
 =?us-ascii?Q?9FjYYQMl2YuTtG6YMtQWNznM5FRs1k8i7w2BDbp5dTHWaLRTi1lpSk8Ry3w3?=
 =?us-ascii?Q?yKFdadChJJkwujujzXp3K0QpvIwx6RINB3TULGeOwM9bPSWV0aV5A7n0kihb?=
 =?us-ascii?Q?XYr6HeX1073fHmmLmc7ol1NZPXswYHu59eYN1ped2oMtH3gl0PmFVKgiti1k?=
 =?us-ascii?Q?2IBp1JbvmKYHOJaNsxEoug5ktfHbFBez4UQfCW02GmPWsVEaTvTWVBbTmIAb?=
 =?us-ascii?Q?4P9hhTrn7Zk0E2CuzSSm81VNZa7iAucmHm2QdRkk5hXQgZsuDrK8upaNfQIW?=
 =?us-ascii?Q?ClLXttdl5FO0aPwYAzQCEL+TMciMdxnd0eUP5jV5HpFZ4uOzZ8UnSEicsCnM?=
 =?us-ascii?Q?fksQs4RkNbiHC8bnUaTCuA3pu7O9LUUC/FsmuQCiHC/tzxswRi/6oLybBBNm?=
 =?us-ascii?Q?pgo1smaqruHxnOMqr05Jrv4hhbGcPQz63REkxqGapgxWPoMF4uYBKhjirNgn?=
 =?us-ascii?Q?QzUZV+z6Y068iCtGK3gPJU+gPyQcSdB9SQMI2Kh0S+BMVBl5J1ELx9pxo9Qu?=
 =?us-ascii?Q?Fv2Qov7x0vewVEfZ+TAbJGn6moRXfoe6O4sik+53H9gN6mxQzwJzoNYOjn+n?=
 =?us-ascii?Q?SsRjvgDjm5BC6Z+XBRe9SYRh7bFXc/CvxM7TLMoc3ZJiu7170PviBqd2eGl7?=
 =?us-ascii?Q?CsE+xMsxgB7vnspdqBz9TMTRLCTSpppheuT/I97Mrnlf0jSW5U8/qX9RXJZl?=
 =?us-ascii?Q?xdkLZIXEhmRcZAPgB4kNt1BCVUQtDprzXP6JOF19NHIRxBtJzXsbs6yqRaLR?=
 =?us-ascii?Q?KHzGo+8Ca2CNierZg8GltVT7CC7VANQbMvBLPjIlJHxtqo4wZ2nTqKDLdFCx?=
 =?us-ascii?Q?5pDzUYNlngcOefXgvsuhbP4MwcSTfiFYbEnM4vxgRiPRCnXCxPmPvCmr3btk?=
 =?us-ascii?Q?+vuoEl/EQ1prJsli6kQMvSpoKWdSV4PfrVhQy8UNk63kkukY52w8tzs0FXyL?=
 =?us-ascii?Q?Zo9A29AlggNzb2EM3YwlK3VhXJRuU/7LabA02BVf4OQN/MskXZ7WpTc7Nn/f?=
 =?us-ascii?Q?mKBQ915C2m9O4G4KkoKEzRBwIoRpuE2101TtQs0tvHCBaB6GJtAs6Mtu7Eq1?=
 =?us-ascii?Q?2nvLUgT4w6ALDbh0/JHA+0Yp2Q6E13DvYIJnuk/GTAHIjgxbCmoB9JzA3OB1?=
 =?us-ascii?Q?2/oIwLPT9rBtlC/OdBrwol67tJ6zTjLrOdruhc7hur+nAC5jirplmmO3FQk3?=
 =?us-ascii?Q?w+BeXHGz7lK3NFn0FZt+caR0Hng+U5QE7j0GsueM1p/1Xf4DkFf1CWN2HJQP?=
 =?us-ascii?Q?ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jOXCu0R3KY0j70OOqqfUp6aZPz3TM4pHD0RWtCc7bIzrw9US+9JytIYIYZoA0ILe3Ke5QLBkomI7NiNPZ/UtktYFKYfNffB9PdrFKCe6BydtiEbeYFFcf4zPSixoPzAkfKXbv8bS5bdOwsC9fH0dXsBF7Xrf/j2TuD42x881gHGKakT3O8GzmNBY8nFERVfi+OAiaWB1YQZOhoIDa6qdEX5ig9s3mmWEhnTH/ZUgC0gu60gN/K3rmovxhgybgMGV6rw9dCrbGXEwA5Z7PUvLC90R4/ULknVw8WYGxjiGzTnv/hy0SA9Xl7rlk2togiccq8nCO/WjGPEJ9uZFNGF4ZQJ0yIz6DsRB8azIYIcD1RMXZBTaN2ym0hr3fYvvroOAZuB1Bx7gKQ8VkEdBPhN12KFICdXmAchGZmLPo0B6ML6rTaWAaCYWUp8AGZnjJKBV7nFMd5eJigN8Zb9UE+8PZ7sO80+6uuo4GilmjJtmMsNBSBKRRTXVGayV/SgEy61nVgcfuoG/2lt3P+uEr7+VFOv/1rmsCrEZrz75v4jhaNbGD+Q4qd+4mk9u6h7ZI4OeGt5/giSMYro8KzBqCKD++KEeyJf9tBTxzvTTDS/5h3o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40eafcb5-e217-44ee-349a-08ddeba05eae
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 10:46:57.3470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PhFUuQQF+IuTV67k4pFhTr0rFUyDz1r/pt5L+MQI4bfNkup8CUyI4XF+iVe1oD03qpCCmUcMilhHB/kpQaWsDFLdmduFHtA9gu/GrxSqGA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7026
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=767 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040106
X-Authority-Analysis: v=2.4 cv=K+ciHzWI c=1 sm=1 tr=0 ts=68b96e25 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8
 a=KKAkSRfTAAAA:8 a=7CQSdrXTAAAA:8 a=meVymXHHAAAA:8 a=1XWaLZrsAAAA:8
 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=iox4zFpeAAAA:8
 a=37rDS-QxAAAA:8 a=pWZKdc514VPWrlwxs7gA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=cvBusfyB2V15izCimMoJ:22 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=2JgSa4NbpEOStq-L5dxp:22 a=HkZW87K1Qel5hWWM3VKY:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=k1Nq6YrhK2t884LQW06G:22 cc=ntf awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEwMyBTYWx0ZWRfX+h474KHldQsl
 GDoDK1Ktp9e2IO8qv7XqsV4a97HlEW1xDcUm5UConVEVAsC1DBBRWTSS/0EDfVjuRbrlxlctIqP
 WRtlrE75v6P5Aw1YBKdoZ7LsL2GzSMf78daztWmortxvN3QD8Duzoc9ML8YGua0LSxIU83XBA4h
 pVWyN5G9I4HjZ5mVwTbdgEAqndJwdPd5+JZUQEApbZjoj1JaNZG03GEccnyGHwxxQg3SYKBs0wo
 J/7piHe3vBhRiHnN8ZxO/wJZXdlsWUn7UUMY/gkmEGPRzmY5TdyVFEsf03dRnBx46tarLvj2jDE
 ALAhn4GKw+GnQwE3y7SqJzMQV74JwqkwcaMKx8BkURC6PD6M8ItIg3QMZK8XRGUDivrBHkv93RD
 Vp2xYbXXf9jHaprQGJ6/sFRFWnL6sA==
X-Proofpoint-GUID: yPsYa39TXgbIA9TehihqzWuk8twkZEyJ
X-Proofpoint-ORIG-GUID: yPsYa39TXgbIA9TehihqzWuk8twkZEyJ
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DDE2440008
X-Stat-Signature: owzt4qdf74dwhc9njqn1da8ho5z6kq6k
X-Rspam-User: 
X-HE-Tag: 1756982826-572837
X-HE-Meta: U2FsdGVkX18s0pf0s3JEys0EawvZn1tGL2J1H9FxsUt1ifGJNmAmLCSwCQlT25N42V7XswJhiI5g5nt3VgZoPwycIQeHWDiNCm3SYbn51D2NPyGhvd5MgcXh0RIEncP0rIZXKMrpR79c6eRa5H9CjdQiqDognVTbHxcb6fXdmxgSfVD21UlLdtQnnkE79qldWx68rNmPZF1d3dDHpghDyw8+6rMXCFiOYwrQQ9jiyRrMsIp2l164zkduhsM5TJDJaIzxbFVjiknI8hvwgzoarUVz5pc0+nk0NN+FY0sXAYkR865/aX8b/45gvSZNhx1qm1L6rTI/e3QbdvHz3rzpL0yztq1rMLtzbLNw7/GDU+WUuR0p8d0rFdsv5wFrjdsbi4kkFCxyxwg221vOYWfGWiYGrTyG19v613CiZXwy65mZGsIOAYdUAO3LX8AfXDvZRMIqYKIvG1Do78RZwFACM76ifJ8SJUOmRjKmaQtxB3UHEv/NySmRfkFR+AUvsmbjwmeLnILk4Huhw4ccYShqz/Q/A9Suhp/rfi+mhWmiZce6zoVQpN32BnkDEbvfCBCSxyABwJ+fbt7oUgxJo3jmpOgUu/iyENB7cwRd0gPRzsV24GaovO2nkF7c+1/ZkwVvKKikAOd6nRRe7+5Xdy/Jak7Wjnaf/yygN9Y/0XY4nMZb0jxRlcmhM6JPTVhcQnbPOYC3MvAgnYld1IimJ+sPX29Q/XFybLRHmWdFUA3Lf4J5FoT6wKRDQHoApqmI+4Tka4pANLI4zjyuyFFwIKkb7DUw8tan26NzN1E9l09JYbgD8gFp/ZPEsa0Y0OVLaXXzeqUpfeS75hl4sSFqm7UiItdclafJ1GduNbWUe8wyJl0VcEJDba6h282Ue/M6vgjZpp+3RBobq3JReLWJjOHbxwBT49KE/26TFK4vON6Zh2RCLsq7Q5F7lGv2udxXhEq5FqKYgYcXOZ4EwyEXlRU
 tuYZQudD
 RUTS/vHL5+VFXIavZLH4stFPGKg8l0HR94xy37C2wT00UzTJXnQe0d5IoTm653td1lf70fu+hpcx12b1tuxFw7cjLAEqmpai5ppDZ5Q1F7ajwsO2Wkn2CG3jT/dqmQY03PFV8ZRA8xdJwrPKJM165Zs0Q+RXrVE3ME3Xvu0vKws22X0SAJJX/+eWpqrci/iOlwX4+dpB10fo1MfL69IrMya74554DUTdzEQW8RDyKGAPMFMAPcxpzfKIoRDpeBACo1AtEdX3FTWTY6FQub/SByRA4a8Chsw2V39TRVVFZ0jyy2514WS5wUQdGtk/Dpcad41rtA6Sb0lVR5FBK3EwYevquIEYB+KQpceCayOX5LnS1KCSQLvhy1i+Er0D5Qb1EAZgzzLPBdPas6jIGzU5xMgWbyYTbNpdisvq2X8PRblVqWocEZDzYwVw4ZqNU2BJIp3P4ECN5RvjFNJA/3ndSSNQ1HGfv0r2eOAtNCBvO0gsL7+Y7oH98zMZTS2CxJmMfhi+nXDOAGiam5GfGKgbhKBlHNuDGncimv5Io1I29RoLQnPZzAJsVBBMhzMsHAGDorcbyc8wQfFLB1GY83Na0bI5vvbXkQIQCf7P+TPSuvIXxWU0iQyls8iExybNHt3iGnMuew1UOURTL4Zns4ZMC7nrVYaCNhcf7PldYncAF+KWx7KPjYyHGdCMetq7B9WmN07VKuPv69ou6jBmsWWKdZFOzKNZ+NR//ELwrvb798RYOFRODUJEhWPMJn15e67s6H0UmxyckPVgNYIGSVj7bdnVwjkKoOiumYPB2IFUaG01994TmmdKdLRbRVg/G4QrlsFHiWUCMbk2oIYbEyRy9hlS8bJ8dDctRotlxIrs+oixxsXeeSt1OC9Xq31XzAr5yZrK7eQAEbqg5lwdZPI4nOOlYjsa7Lba5Z9Cp2B/DPRjHySxj2y008mRg8eNWhJpzL/kQqgeM3pk3alIU2Z/e9Lp9m2cm
 +MNUwom/
 1fCW4ZH+9TEGm4zM/4k+RRou2MPK2GwRmkPYQQhPdHsMHSa2P3JoTn3QdJQ3umQ9Y1k4+G0OxhgWEn50fQ2QPqT+2bfMAikjSsIz6FfjWEEI0YG8kfTrk2+DR4eyMCnfZ3t1Ux/z+3HELfB7dqJZnNYDyvXMMGDwflXSg+rf3YEiiHIOPilDMwHMTUnKrKHHCkU0IDkZXVjHdKo2T4YV+EvKVdvlHxN5JqsryuOOcKBqFTP9McIB7bLspp/JTwmBkxWmmumnaJsS2vbg+m8HoBn0ZRPb3o7S/h0sRVJoHhw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 08:23:24PM -1000, Joey Pabalinas wrote:
> The correct english is "an mm_struct" which is used everywhere else
> in the kernel.

Hi Joey, this doesn't really warrant a patch, it's just not important and there
isn't great RoI on the churcn here. It is also very silly to make this two
patches, it should only be one.

Also please do run scripts/get_maintainers.pl when you're doing this, Kees is on
the list but he is joined by many esteemed kernel colleagues ;))

Ingo Molnar <mingo@redhat.com> (maintainer:SCHEDULER)
Peter Zijlstra <peterz@infradead.org> (maintainer:SCHEDULER)
Juri Lelli <juri.lelli@redhat.com> (maintainer:SCHEDULER)
Vincent Guittot <vincent.guittot@linaro.org> (maintainer:SCHEDULER)
Dietmar Eggemann <dietmar.eggemann@arm.com> (reviewer:SCHEDULER)
Steven Rostedt <rostedt@goodmis.org> (reviewer:SCHEDULER)
Ben Segall <bsegall@google.com> (reviewer:SCHEDULER)
Mel Gorman <mgorman@suse.de> (reviewer:SCHEDULER)
Valentin Schneider <vschneid@redhat.com> (reviewer:SCHEDULER)
Kees Cook <kees@kernel.org> (maintainer:EXEC & BINFMT API, ELF)
Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MANAGEMENT - CORE)
David Hildenbrand <david@redhat.com> (maintainer:MEMORY MANAGEMENT - CORE)
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> (reviewer:MEMORY MANAGEMENT - CORE)
"Liam R. Howlett" <Liam.Howlett@oracle.com> (reviewer:MEMORY MANAGEMENT - CORE)
Vlastimil Babka <vbabka@suse.cz> (reviewer:MEMORY MANAGEMENT - CORE)
Mike Rapoport <rppt@kernel.org> (reviewer:MEMORY MANAGEMENT - CORE)
Suren Baghdasaryan <surenb@google.com> (reviewer:MEMORY MANAGEMENT - CORE)
Michal Hocko <mhocko@suse.com> (reviewer:MEMORY MANAGEMENT - CORE)
Brian Cain <bcain@kernel.org> (maintainer:QUALCOMM HEXAGON ARCHITECTURE)
linux-kernel@vger.kernel.org (open list:SCHEDULER)
linux-mm@kvack.org (open list:EXEC & BINFMT API, ELF)
linux-hexagon@vger.kernel.org (open list:QUALCOMM HEXAGON ARCHITECTURE)
EXEC & BINFMT API, ELF status: Supported
QUALCOMM HEXAGON ARCHITECTURE status: Supported

>
> Joey Pabalinas (2):
>   Hexagon: change "a mm_struct" to "an mm_struct" in comment
>   fork: change "a mm_struct" to "an mm_struct" in comment
>
>  arch/hexagon/include/asm/mmu.h | 2 +-
>  kernel/fork.c                  | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> --
> Cheers,
> Joey Pabalinas
>
>
>

So yeah I don't think we should take this, sorry! :(

Cheers, Lorenzo

