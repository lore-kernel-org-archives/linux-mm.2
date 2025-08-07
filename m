Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93622C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2603D6B00C1; Thu,  7 Aug 2025 15:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237686B00C2; Thu,  7 Aug 2025 15:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FF546B00C3; Thu,  7 Aug 2025 15:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 001E86B00C1
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:22:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 904DD13785A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:22:28 +0000 (UTC)
X-FDA: 83750932776.28.29DE723
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2230E140008
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:22:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Orfc/Ia4";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Lcd+wc/u";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754594545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tN+Q0WirrYouq2tr81of3H1t/wQwgPsVyeEMyFYQR4s=;
	b=Z4kl4pjyjExAt4mjGpl8psb3eYGU07ExbA+dATveedC/kOiiPHLFaqwK+52QgcOzZ1Gg2Q
	yQ+KFjwVZ3NXux+H9MPJIJhS/5OX15MVulcHHB+3/FV+EcuJJPPvAHjneD6U8nmtWDG6lL
	TA5L8RXLqaMu3rG/1/uSmabvUdNgw8U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754594545; a=rsa-sha256;
	cv=pass;
	b=cTW7pCrl2+Xjp/Jye5Z1laSGfK0nmW+inxMJ9Z96iyeCrEwmaoSnlx4dAmB0Q2El1fDA2w
	5bo4EA8na9Ur4La6A0qfDR6CbIfHg8PGz2HgmhCigtAqZb0Ix7bKUgADAFTImh7Cz6iEFb
	68fPkz4queDtNBHNwu60S8DRnGnGVO4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Orfc/Ia4";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Lcd+wc/u";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577HC89T019450;
	Thu, 7 Aug 2025 19:22:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=tN+Q0WirrYouq2tr81
	of3H1t/wQwgPsVyeEMyFYQR4s=; b=Orfc/Ia4QVjzXmFd+5HXsDVd2MZDFvereZ
	E+dsvRMgQbkKmfMi3/vAAzkzalpUykDRuLGHXY1EdxXbmcEN+EUvrdmnm6uI/CR7
	y18Y147Eo34pjPHOfef4dFHdCZFXCzrNYv66D1l7TL2caX1FQWfqP/XxSXa7DO7Z
	ka0ZJmhCnZ/91jRO7otx9jGHR4etKE58bFzts+aLbcXny5iDJIX1zRIO88wk8hnF
	+nd/RSBYlEqEcB2rndARgDPW30dwDklYz4JskAqDqmZaZQ2YoyTKqVvX21YzdVt9
	+4ZthXW8sTYonc0GFMM9m8EAFVoNcjaxY7ycvOJRrGPMsrXaySRg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvg4vv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 19:22:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577JBGnI027065;
	Thu, 7 Aug 2025 19:22:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2044.outbound.protection.outlook.com [40.107.212.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwpu94u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 19:22:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DScvX1nPQaWtM21/IJPmT+78QqplFAUdRTUep4c1gfZuqvcL4LrOtLKEHYMSWPGHk/sL1BTsG7MslZQDEweg9OoCoVmllbN33hqfRJ2bb+olu79EF5ZvZfmezxeY378+hYbMfj/hdcLAapOKdj5R3KaSL6EHWrwfnBDUV/geQcaBk7o7Nhf1bEXYwhod9nmL7DI086UHTqjUA38hezQkbnPNqLlxkNB7VmtEbQaXaRqQgZjFmKjkPAm9b1Q/3QPrjViZQckh5rJCiR8rR2PxuQ/lZxdGjQ1/GhMontSEKUD5bxoBzRbjmCY0M+Sn1MNQd7N58WgN60te3jPB4wuEYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tN+Q0WirrYouq2tr81of3H1t/wQwgPsVyeEMyFYQR4s=;
 b=l6k8FyqUy3NDz5jIbrdj4nn+JxthxxzlpAhqyJynbRRWA9ForNapmC4W0lAsxwd0movYRxGFOVYM71/x/DJUC3+9loL9C0W8/ozRAgwnIW7WjMZ1bJ4cVBP7ko/jP1k1yE5J/onI4JH4nbEbRsVqx1VC+6VMBu5OcWTlC+iYNe0K7gH+5CoyVVYLMMmLNsvtiPlp3yhbNxOlu7k3ykaUx6p/dLLv84BjckzZg/tRyjtKd6Wj46IiRzgSEEyqEdUTnTFVFSPPgiqW0wCmIZ355J2Zs97U+ugTA2vhZQs9/IB+HEJ94nqClLyCGZlRiWIi87v00CsW/T03G7ZdjlXyfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tN+Q0WirrYouq2tr81of3H1t/wQwgPsVyeEMyFYQR4s=;
 b=Lcd+wc/ulGaXwcowEv/vQJ7zJh5n3wof+l2N+KO4+86NoA1t/UQZHXAg7sEthh5lC2NeoJDmH4KuVJc50v9XOiVXv33Zf2PbhK8mqKz6aYxVwL2Q6NFp6SXIscG+jfCiPYSCAuHx6tqtKqUtuYYeEs/RqbZGsnPUydyenGvu/Ow=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF612E8E8B0.namprd10.prod.outlook.com (2603:10b6:f:fc00::c2c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Thu, 7 Aug
 2025 19:22:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 19:22:13 +0000
Date: Thu, 7 Aug 2025 20:22:10 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
Message-ID: <c556f29b-fffb-48d2-beda-a9e2b70aa4a4@lucifer.local>
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <ujfeyn2awquoc4pc7qxcnavgqcu57kvmdb66x2hyaeoiasq3w4@u5qlyyklfrld>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ujfeyn2awquoc4pc7qxcnavgqcu57kvmdb66x2hyaeoiasq3w4@u5qlyyklfrld>
X-ClientProxiedBy: LO4P302CA0035.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF612E8E8B0:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c37d528-f39e-4a13-e9aa-08ddd5e7b692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kl97ioqrK7ZQZu0Qc36EO0k5cfZlmaZOPoIjMpvNsnzkTHWWGeJDLtGn7a8X?=
 =?us-ascii?Q?/9iprx4Im93ZmZwpLc1I6kkVi8pPfkFASyzv5k2ndZo6XxIW6X803F9lm7Jj?=
 =?us-ascii?Q?fGV+l9x6V2cFRWN3EnvfhZzJ21kpEWqnDYRj0f1lIoK44Mso55ZEGwesNijM?=
 =?us-ascii?Q?UleW09iab3b6/cVOyVPunG/CJkB7o2Qpfvv8iUCWWkyvcqD+dLwxLCrk/PKh?=
 =?us-ascii?Q?0u0D0x8hM1x5OZmYuoAyzrn/aMr6p2KbcOQQXofHtQdIR7QJNTgk3GlfbRzS?=
 =?us-ascii?Q?vShERLBCJSNxvQoxKO+wPHyiMMI7nNrR1uiaxK7yadjRoWd7hE6aJZokCGA4?=
 =?us-ascii?Q?MrG0xVp1nj2deMFVsrWazgcrXcct328QF+DShODlMQl8fgAo4H8mFbtl+LPw?=
 =?us-ascii?Q?jsXOtHwtXdBBxWc0vCSOAz23Z3GBtrN5AKf5t8JRG7mDW7nnTjZkT+q9/R3n?=
 =?us-ascii?Q?EDFfD8TickxcvkfmLtk4nSonWISR5/7edXAUU+BO9aSvMIc81Zoj/kYv5udp?=
 =?us-ascii?Q?GH8ubZTysYRBZspw0edcX6ktANahqrxKE0cKEKGWYkYolhyOnex88jfRWPjq?=
 =?us-ascii?Q?Wn9YEjPJkswkiqtvNR7x0kEi1ic5eQjrKr9IH6mohFbT8jQIK9V2CmwpXMKH?=
 =?us-ascii?Q?DzAYps0AX3nqkKB5SkwouPD8j9VwKTjz3xG4K+G4hvRpszZiYQRdgAq/iDIi?=
 =?us-ascii?Q?N1kG/S2JaqQZgAqCG0JluS5xUlAw8uKRjttXSMm5qtaEn6iWArxx590cqK/6?=
 =?us-ascii?Q?kCGVB4reYkshV0NtPGIMcslgedOdXnQuAzpusnCKNY8ka1ZlBuV//fDMcXyC?=
 =?us-ascii?Q?i4FPb1NOExI1r0xHJwWvqK80tJz/aCdWeP99KyxDISY7CL7CzCON5L15udnn?=
 =?us-ascii?Q?pepCliIcCcvSpkuCzFtwMDni5eNNG5HrG0noj7YoiviGrPB7Qs2Am2ME4ghf?=
 =?us-ascii?Q?QkNGP3qQJuBeSBR6gMTVQZwWCU92OeRdN9gQDKknHiNB7Dy6/bftYSGhGLqj?=
 =?us-ascii?Q?BKfUtzt97AIw1Pu8DR0hE1eeeCqpqBk1ig1z3IalX0vnnMvvuiYvvcc5GS/4?=
 =?us-ascii?Q?RXnCLiYo9aOaBna5KaULh4HlLDKLBwYdiKkJIVyGHgvG1zEeyxwHiT+XdDQI?=
 =?us-ascii?Q?qhMfdlhG9LxiC+19Ne1Oq1A6mSYY3qZeM1OFIDvitEUyALc5k/tsSXVE/y6s?=
 =?us-ascii?Q?hlswxSEv7vv++S7SMTqRg89zhSChVN5aJI027hVa2abIwEPDy4ff7iefDfY4?=
 =?us-ascii?Q?VzfiIoEbnHHdfXRn6LfwnurarE3sv1PNiCES7Qh0Zp5RLA43bG25++N4EVjF?=
 =?us-ascii?Q?M7+EhCxf/m0Ml4s1Zxshrn3T5VawR2wQ6BtU92nCh7vIzB0qIw1hqoHG+r5u?=
 =?us-ascii?Q?W8HHO7GrxKgdJJMNmUDDolmLjjm8lUG/wnECtowSSEPMCLLvdAQbarY+lLoU?=
 =?us-ascii?Q?mJ1iCAITET8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mdFlUbyIKlbrT1wiE+PcKGiUKs64oDsYHcOBm13Paot7fHvfqW99BL6Sj5p7?=
 =?us-ascii?Q?AZsmLlELVS5RLgDhW1nhH2LrEDcmLpLuFjg2mX5hslGsPUbTd8Bo0upoSzPW?=
 =?us-ascii?Q?rwt9oSj0zEpuvsmrfUhHLresJ4DGIy5zlInDDHcjcqSBCFd4mR32qxL2/Y00?=
 =?us-ascii?Q?wfo05BmbPCH948Qq3OSRbOxLDCOKjryNiZ6Z3k8QkFmrgmGPT73vEyNJQ7wf?=
 =?us-ascii?Q?MoG0RY56G4zTrW7AxI/+D/LyOuqjuS+OjmVb6RnQIDdmjGJZRA1kOO0auSEN?=
 =?us-ascii?Q?CgN6xzdnJgtg38y0VVdqQUs+SK2uHLQgT70qdcaI2VNAh9U7D+DSyQsXScBL?=
 =?us-ascii?Q?jQ9AmudqPKhfv13dmjevuX63t0jbAN63XDtmpHHiu9H+hVNy1RMeRExSegte?=
 =?us-ascii?Q?3UhuYZ6+uMeos/4Cxh/goZkaVKnBIP9hWKNYPJ8kQTynWMubOMWzIeEU5BbV?=
 =?us-ascii?Q?D5S+9VJb+ZHipg1CKPiy4XmI+Pqn5ckFb50l3uPQ4RkzdCkVBTVZRe/aSEZC?=
 =?us-ascii?Q?eZ94gc1FrrV910Mu4pnUul7O1YLb+2gVrAMlj4SjltUVOS6sxOjj8Xc9M0nh?=
 =?us-ascii?Q?U0LbkfA3pYF1ldYBoKNkSbTe8nIydZPh2tHwOgL4qpY136ypAlQU8Q7OWqYK?=
 =?us-ascii?Q?rN6REMNbZdaWthGsb1rOgMI4Houy1QScVn9JXCw4+7ZkH4mgFV8WXIk+RPbB?=
 =?us-ascii?Q?N1mA1TkmfWJQpZ+LCw9Ph9JBoHzbmW9kYM8oRAyDZASoJjtBuReicDldl7CR?=
 =?us-ascii?Q?N21z021GIPmmd8dQt5WNpNgzfl3K+ls26LLNjmj+aLfm8BxdwpNGbI0u+zfC?=
 =?us-ascii?Q?7UegQJxhuokicwZIJshTwqZXrra5T6GPYVUsE1QFevheRvWiHZbjVHY24PgM?=
 =?us-ascii?Q?6aj03uHh50n3yLqzGlFIG8jQFPG++IqVfYor3HPnMhIIgahJoR8dkoq7Ngxt?=
 =?us-ascii?Q?lRLy2/7Xh7nubfHQuYN0P1h1mIV7LC/db6Y9TwYpv0x2+YrALEEhbliAifRu?=
 =?us-ascii?Q?XitMzZ9XNk1KuxMf3XuJEV63pN/ErvATdupmV0AcnynkIHTEJ78Z/PGZcyyp?=
 =?us-ascii?Q?Xv4B/Quz1thhW1XIDF73BYlQ+Uhvg2p4cQI8CyRIfrG/QSBIkyV4V8e8Y0EI?=
 =?us-ascii?Q?KZBWsNTJKIQT3btlNQrGAulqbhyp+gTnxwV+vlwdklBp34g0LW718m3fm98a?=
 =?us-ascii?Q?0W1uu45uPauYgbYn135hyjCrwDdl9hFxJtVfWYGNSW4KeJ9f2NrKuslHX7CA?=
 =?us-ascii?Q?dTbPaUW/nccKLQOq3UuwLtGf8dtxDaqfMc69s7C96Reh8GNxCo8T078qlxMC?=
 =?us-ascii?Q?uKQ2cHpKjBQE717Mvjz+gyJPdcUwC7ZUi8J5kwPGAyRdjUkm8Qs9uG/kixKg?=
 =?us-ascii?Q?+OeGboBpp3Ownd7OgNShKYoRKVJRR2qW9q6Z23pISwRWEXzy8NBp7AHQwTu/?=
 =?us-ascii?Q?Ja8uN1LT6itEg8buJALout+0UuH6W0fhJm5TEAQCCVcd4Yn/M/gA6tT+nNNb?=
 =?us-ascii?Q?17UlcPbykjiZyIlrCeoZGPrBQfzsoyfxKoJ6/Oz1sCfDvxVIq80uxdo8Tga9?=
 =?us-ascii?Q?OoJR4qgjFnVMbDJhNNvPQzBEnCSHNPTLDY/guC3Sl7aG9fC/KnIfR5LCp3eV?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0rBCpqVi39gRTitYQu3xVSAsmykDJueoG8DnBSez/DFRPnnNt6/BDjhU3yxseIMidL+nOccQpDe3hjLKLwOlGjdA4bqlAyOOraBVfcyV7VcWWhgQ80cHQeEL93N86XfiamkvrKjUM26Ej21AkmIYrnR5F7k51fORznpVmKlv8/Oygh8QqotFjq9eXtH6YV757j0PrSkoczEcqxf5leHcJXBwESRRySEUd27jXNpZiJVdtERbr+jLqjugcAlJdyT2A6mX36tBJzz4I6WeBhstffc3ZGcroAv5k4Lq9mHhg4tpQJRUlvhPulEDqNxr2gY3VXGzDrJl+3GY/AX2ARDA8Z6mBZZhb7Wog3+bb6lITAgoGJw3IR8YmQseFmNI0/dyn4oh1xx3fUjxs80N8SALMrsPwqDo1ABfAtQ8ivwqijzPDCJmMoo7cadCGLoEUn9SyhOj9lhpDT7M4TY1BfNUqJJgOMQiqv+ZfUiFmPYTxtYcaZdqeKKoDjhWBkrUPkh+89AZD309xvGu5z3fUzmvLXvcTzUOfmdyMMoH50E1n+2PSpvrV6D7uUa5EK+ypv8JqRjERMF2Yz590ZgcJjH00vszCPD2wYvrr6l83DSpwmE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c37d528-f39e-4a13-e9aa-08ddd5e7b692
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 19:22:13.4287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sK/PGoAykd5vTyNPN0LYG3xaJ/cSLHFnaABgZIkvPlbcXpx1ocbUOEzzc/9xbc/BrusKEMrq6aKsEPe7r2EIQNgzd3DPq9NerIxKYMI0ms4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF612E8E8B0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508070158
X-Proofpoint-ORIG-GUID: puzouZvaxOv98kef3c8Qs1B45nmMwVQq
X-Proofpoint-GUID: puzouZvaxOv98kef3c8Qs1B45nmMwVQq
X-Authority-Analysis: v=2.4 cv=QORoRhLL c=1 sm=1 tr=0 ts=6894fce9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=yPCof4ZbAAAA:8 a=fYk6R1corx7ml0Yr8uEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDE1OSBTYWx0ZWRfX1j5aSOZ8lnl3
 KEW6Z85ZPjZ4JcwBsaetb5QCkYHcei9iW8V/WQcsMwHYsoSzGKEw06yZRXuQ+1/0f1SIBdnr3kr
 YKzRzvhk4LqYjGVU8+j1ovI+liMY1FLaI6LBdv2LnJqh5dZX2mBbpyDRUWNcVAMSUFekdMeydVm
 ZLyKfz90ZLv2EMwJ64m3/8cGqEaTSxdbq7ei+25ojPUmaaqGgsyhUpe4ew88ylPGC4I06NmdMsp
 ubIra/HnoI0NXuDADwW4kRsmDd1rgoqTYc9f3ZUc7Pkw6Cn1EG4HsgW4e9+TZuIr7DsIUCbUsIQ
 9kl/8X17Q/vKB+mUC6bfXr5/R6v9x4rmzHHmEQWyAdY1y7tqP+kOnwalnm5g1HLLrBlvEhoSfQU
 GcEH++fEJYM+sKdFY1Tdgh8R+MbCZO922SgnJWCyoSzN759NoeAFrbpLW6BBEfshlPPGrbb6
X-Stat-Signature: g4q36zrtp9zsyj8sqzzgi17eaqsqdgdt
X-Rspamd-Queue-Id: 2230E140008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754594544-281286
X-HE-Meta: U2FsdGVkX19FgchXwYU14eQ/3cg+kI20gQUdi9aSxqjvSvwH5CxHfQoHW+2G/gWPEjms8rlZvLIZF0JtFNG5kPiDlqf9/JWVGrdfIeyEoVkCuww6sbU1+kRV5egBVbdJkxUD66Xm38U45L7P6kK9WQcpaXqPCl9LT9jyw3rdMgp0hCgJCaAnp07iHna52Nwk2H/0m4JbA4lisxsD7MqWO42d2AVNjZ45cI9hemQLNfTLSuYOw9z4VLmlk4OnsSiYfN5WN0JrRcOMXWvfOxx+fIJvSbOyh/A5nq/TA4RaQArvfIYYbc5Yb0hXAGOtKg/cDXNtUHNfgmwyFHwwNgCC7m0vHd7ryJY1CdjpCWocBPDCcIDVVrs/fsSQM3K5j8aDf1gxONvBfmV9zubzmWCcnA3fWezCRWM9zTaLLfug1SuKevpa4AK1WDwwP4F7QON9U9Qgwo/SyXJCLZvyzmCeH6HXjiNOCZZp4hohOI5e8h7vOVY9PcO/5gXX3+/PKYlGFuaEkxjbOAHYrgnAoHv6iZmoiDR2h6AVAaEZZKVkQUV/nU2qXBLl7m0qZiWg+g5LAX+FEaEcebFeqk1scXPYsPyebeE81hAgTMco/DtqMEVNN64mmy44+idEJ7zJkqeH3ejZawN/QB/+wKKG2d2lnbofosPHN452R6Hb6aK68a0p3f1ztrq+zzHwcKt8ZDp2yB4idzRf21+cl2SuMWABWBjo3SVKQxlhxY27yUIyvj2Z3DA31wjrNfp+LIlQOHB9J5b4nVvUiE2kLwc4aF/IBYcI39jRgTE1YRBT/kTSaXnSMt6xseYnkyVetDqpV7tAQS27XhCvfx98Mj8hni3+rm4lQGXfXTNtlQh44Syp9HDd+ScmYOZhr3/04dqC8mJ1rPNsBminQHx8GC1R8Eo+VH0sy5uQXKxnP8msskLX5+Y/lirja25aCJFrM1Rh8XvSgJe6lM/hOQgVZBDCS+K
 GUuvnAo/
 6ADwstI0EXPoDHTD/wQflpLg/LjTaS8TWANNaD6SszJtBxhpAJBvSDssNnb7Sv4s3yezTP/GIMQlYM7RFgScCCjz1cJTcVPv+nVry41N3bOmL//tPZ4uLLUZz4cIBExsVEuw+LqwxW1J8MW0+kT2Yt0m5mwPt3EXQxPKplvGK7cwcPYFrkITdJKkOumTocXkInpBxUhj+kch+0TZPWf+jsvOBGxwaHPZ7O0n0h5rgblL+MsMZdVnBcOuAJn7MEu5WA1DQi49289MOCXGJ5yWxUup9STZuggpYDkSCPiO9e82hTMPU6kZSeoxg/TLZ0v3UeH/8qtZTqSWB6jCKDf7vO4EWHFVZngkrPlAsll5HnQqMt5BZZ3hvAQGe8K2Xs5LzdjUevbmkacmx33fPJTA0T2epAZU+1AaHO7RqQtjpOlsKRzlIVgJMjJjeNKX6c6VgJBKCam0sQxCSzkpwMbPGAi/FZIOQANn1npOSang0GfhKb+iV4Y+2yv88D3ukmPpQGZm5frZPgyQX4NEB78TfP5WstpIV6x+MGAsolRbdHj+h+2LG24qu+FAloFX1J01ltqQPgdE59wCGYvF6kA3Ln1z7BbEbauR1mKcCGTO1hd/rwoGl4mLyd27yGnMlxbd3n5G6Qh9N41d+vK7qEbDDTkKjezos9rGXiQ15Cl9/8rOknetjABtGoenkVN5XoAyfuEQ8qdOga1Xf0qBx7qDFmJjIxCU48EEG4mX0t4lMWOH4ndr/kwIJr8YzVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 08:14:09PM +0100, Pedro Falcato wrote:
> On Thu, Aug 07, 2025 at 07:58:19PM +0100, Lorenzo Stoakes wrote:
> > It was discovered in the attached report that commit f822a9a81a31 ("mm:
> > optimize mremap() by PTE batching") introduced a significant performance
> > regression on a number of metrics on x86-64, most notably
> > stress-ng.bigheap.realloc_calls_per_sec - indicating a 37.3% regression in
> > number of mremap() calls per second.
> >
> > I was able to reproduce this locally on an intel x86-64 raptor lake system,
> > noting an average of 143,857 realloc calls/sec (with a stddev of 4,531 or
> > 3.1%) prior to this patch being applied, and 81,503 afterwards (stddev of
> > 2,131 or 2.6%) - a 43.3% regression.
> >
> > During testing I was able to determine that there was no meaningful
> > difference in efforts to optimise the folio_pte_batch() operation, nor
> > checking folio_test_large().
> >
> > This is within expectation, as a regression this large is likely to
> > indicate we are accessing memory that is not yet in a cache line (and
> > perhaps may even cause a main memory fetch).
> >
> > The expectation by those discussing this from the start was that
> > vm_normal_folio() (invoked by mremap_folio_pte_batch()) would likely be the
> > culprit due to having to retrieve memory from the vmemmap (which mremap()
> > page table moves does not otherwise do, meaning this is inevitably cold
> > memory).
> >
> > I was able to definitively determine that this theory is indeed correct and
> > the cause of the issue.
> >
> > The solution is to restore part of an approach previously discarded on
> > review, that is to invoke pte_batch_hint() which explicitly determines,
> > through reference to the PTE alone (thus no vmemmap lookup), what the PTE
> > batch size may be.
> >
> > On platforms other than arm64 this is currently hardcoded to return 1, so
> > this naturally resolves the issue for x86-64, and for arm64 introduces
> > little to no overhead as the pte cache line will be hot.
> >
> > With this patch applied, we move from 81,503 realloc calls/sec to
> > 138,701 (stddev of 496.1 or 0.4%), which is a -3.6% regression, however
> > accounting for the variance in the original result, this is broadly
> > restoring performance to its prior state.
> >
>
> So, do we still have a regression then? If so, do we have any idea why?

It's within 1 stddev of the original results, so I'd say it's possibly
noise.

Let's see what the bots say. If there's something else we can obviously
take a look, I think Jann's point about cold cache is the key point here,
and the delta here is indicative.

>
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202508071609.4e743d7c-lkp@intel.com
> > Fixes: f822a9a81a31 ("mm: optimize mremap() by PTE batching")
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Fix looks great, thanks!
>
> Acked-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
> --
> Pedro

Cheers, Lorenzo

