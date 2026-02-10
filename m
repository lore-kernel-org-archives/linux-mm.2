Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D25FEA3F16
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 08:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2E26B0005; Tue, 10 Feb 2026 03:19:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350246B0088; Tue, 10 Feb 2026 03:19:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2079C6B0089; Tue, 10 Feb 2026 03:19:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB2E6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:19:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87B8358D36
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:19:25 +0000 (UTC)
X-FDA: 84427847490.20.9255A4D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0F723C0002
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:19:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nx0YuRLL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cWZkXdwv;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770711562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Kpj7hN6uuWbz7G2MAo3VfBNAcsC/cI/6LXGyqtwsRNI=;
	b=PYfpcXlvEtZ5KwJi9Ayz3YQ5NTI+5TS9cLiHvZgwOuBnVrMxbY1sa/2RNhGwJWNc59sIiw
	KV7rRmN+BDYuHRpurTWRccoFzgjoc9TZU/Qmrqi5r93wO2J8whp3b0fFSHxQ4BcmvbAz0w
	vH+Zk/PSJUr+w3jmj8BfA5flV+S4wuM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nx0YuRLL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cWZkXdwv;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770711562; a=rsa-sha256;
	cv=pass;
	b=NoAhhHBkYiVDcdQtq9AU8ThdCZprK7XNjF63wtJhjhDaKo306NujrcRTe09fLU0kCrm+ZG
	xJuMkftOPjyo0yDGvztGesvwXiqr/fOoYATYZlxX815EF0B3HKSTuB4UAmCGVw/EG8sRM2
	XjLUCKr9T1yo8XsYeQjcPAjNQo63yUc=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A2KhhL2790967;
	Tue, 10 Feb 2026 08:19:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Kpj7hN6uuWbz7G2M
	Ao3VfBNAcsC/cI/6LXGyqtwsRNI=; b=Nx0YuRLLiGaUiKpc2hf2B+6uiXPw5aOB
	Wne2A9/WpRmHUnea6skE7Ki2U1SBixnNesfstwM6p1NCsQvNrHAiR6BbY2E2REJ6
	ZHy3gUWhj7ULLAmf8AEg6760lYO/5ai0Gs8BxmJ0NfMpyyBwwklJxRG/Wj0/WJAU
	MMxUsVoT29CLCFwmQQkIt8wyuyQuBFPQ2PLEwewILYNP8AtE7qfThk+R6IoKachi
	5uwKjYP2hfwI+g4hVMXQPOMwjEBVvIbSQQA6i8pmyXFuZK0GoOCvjOhdhcyyKtil
	5CghmCN5XoLZ1BH5FtC0VL/JDONaPvjoQabId+Im88t5coIVLt/G+Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xhubh7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 08:19:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61A7FKZJ033591;
	Tue, 10 Feb 2026 08:19:13 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010006.outbound.protection.outlook.com [52.101.193.6])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c7ctyra4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 08:19:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oWnKsIJHRSpofjB4HGICRuZMkkQIWCGZ9eVcJ/YZFzW8oVSpFTJHmyqdjdyz8gq4TdMynG+jpWCm0MYlagoXB8WFedHSyZH1SQXvUw56B42TDGuUgiInKHlUeRd+dfdl1UIgdgUeyYeykPa7Oo93GoRhVW6+yztkjGMwZWyL/lhIQd97OxucKkDok89N8QP8sIzvxSZbdpUyJz8mUkm1U1bX6UWZOtIu45VrjPLjw/P0T7Oz3gsn0ksZT7YcOUgG1KI60z6f3rybu466hDk0FuAhr+x2YHTPgfSF4ePpRDMFL8u2Y65onMch8vFtw9ks4odkG/Vqputr30xTHnAyzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kpj7hN6uuWbz7G2MAo3VfBNAcsC/cI/6LXGyqtwsRNI=;
 b=Bl0GM3J63VBlr2G4IK31qp+ypBg/9sBTlJ4VQrERPrhp/6dXYbmhrBYFWFZ4yaKpEaN1AVGiFbZtAQz2WvFpgj6E6U9GkIRv4zCXDUf+/6PP+NyjU3D32q9h/12mrua+UbovzNUb1oDvVGcOFOHWTjWrY7MI0XeFcAnVWiPyCjZW88BoMt6T9dmykXzZOFXKFytm/N3WTat9FrEewMXPxnydL6JQTB7+wQWM0pdfNRQSxvtmSSq8EQmYkeYgkaI59ykIbBEWxC4YU1Sl8VWW+uCFIPT3kpmO6VPNnwtOCnIKzqaX4L/hS3fkw+w7+NscSDhrCXR4ZAw+Z7Ke/qK2hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kpj7hN6uuWbz7G2MAo3VfBNAcsC/cI/6LXGyqtwsRNI=;
 b=cWZkXdwvO7oeK2p5oFbvszn9QtBwZ3qCPgF5Gp9X0T8fC/dWATgaEbth/zeh9kJi0iKLb1mtoHVPokv0xGtAqHI9eLCUNa+V1lJ6zlPsbBFit9yc8QM4kJMQgX4vyhmvYyrraDZHcEheIuzwsINWH+r5kcEYnjegbI5/Zuakx5Q=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BLAPR10MB4961.namprd10.prod.outlook.com (2603:10b6:208:332::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Tue, 10 Feb
 2026 08:19:10 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 08:19:10 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Alexei Starovoitov <ast@kernel.org>,
        Hao Li <hao.li@linux.dev>, linux-mm@kvack.org
Subject: [PATCH V2 0/2] fix lockdep warnings with kmalloc_nolock()
Date: Tue, 10 Feb 2026 17:18:58 +0900
Message-ID: <20260210081900.329447-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0150.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BLAPR10MB4961:EE_
X-MS-Office365-Filtering-Correlation-Id: 35171629-2d10-4c8d-4093-08de687d1105
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?skg0WkFz+HXWiGEtSLOWtDYYMxWZFXX3z/4K3An5y/cVjFkCBObgE/HMABF8?=
 =?us-ascii?Q?vi8/0SjGPFzc7Ve/VRNKjoBQxx8uiv42zdK9DOhh2Wf9HOL3UFXbT7ASYDOl?=
 =?us-ascii?Q?8sYHN2+wymUcePKcwwlkyLeeXYfvqQbFj6UHfK635wSYT45Gz1tp7GHXwQaU?=
 =?us-ascii?Q?Ou0jPb7o/8NBOd+dZFzBSS4mu7xwCFJVzKlMq832WAHQ4uixSTrSYxLTHdbE?=
 =?us-ascii?Q?4gsjxY6Df8XUDk0hvUESinKSL+VazxdRremaCeB9iKGLUzfe5bOs7BhhrKa/?=
 =?us-ascii?Q?+St8NM1HilhIFnn6268TnpQRl3otfwAXVulC4XhADH2k92qJNnYAlOBZeUQK?=
 =?us-ascii?Q?PZ/ja71q8rkPnQuZ0EKjeHI5q1os8N8Z5Zl4bCTtC9WtS5IBSJFWi5G00Ryy?=
 =?us-ascii?Q?NHxnc974gZTxxcIftISRHgxo/R4CdNPXbsCTIQmoT/dSNwuVhuJ/8XHkjMml?=
 =?us-ascii?Q?E5yi8B7ao4eCdkGRmY/B4eGsMaqEdWcV4UHAs3ZUragIaf2n5lZMydMNTuj2?=
 =?us-ascii?Q?5tPtTuVz5ja9fL1YaBQWV8DGK0wC07OIwQkbPB80VtrfETdW5jcTyXoSoMrT?=
 =?us-ascii?Q?Qx/fEW2xKZcm8vwRtJwyQGhXuA4dIHFqxFn6tRGWF3wERlSDPb/Xb1LkFJKD?=
 =?us-ascii?Q?GCIlcFIyyPafQud3YynelfBhaDuzvuC3Rf1ekT5sePqzPZeZT8uEmH6bnsxo?=
 =?us-ascii?Q?4kM1RS5AoM0rDJdrjinfqjgtNhoa8b3066fn0qXDXue2DOpSnuvuOlEqnhSz?=
 =?us-ascii?Q?tpGcvfi7glcEVLsDQ9tz2rh+n5cFS0F9NbpX6571G98k5vQkc3wbce2+mADR?=
 =?us-ascii?Q?tbXgfu52e2n5UiftdBjMTY03p8wl+Xwfy6UKpGmO1eVU609zodgu0Qn+Bnev?=
 =?us-ascii?Q?zbCYCR5nwtebehzlu4Q1RbDnglyWrhKf6AUZAzkYNRByv7AmtwV6Dkz1u59O?=
 =?us-ascii?Q?zMZPsTqrntVakrq45BG6HXiG5U09azUauol6Fuu2ya2CPJHI3Ih6HY2JLhXi?=
 =?us-ascii?Q?3WZddzldngZDcw2PwiX1ZA5Si/ULyv76q4sUssN/R3NbqBsUyoOFhPe6T+84?=
 =?us-ascii?Q?DSwXOGlnKVDg9sxWfau+AA1qTwRRVfBeT1d/hyKJmFrvxErRdiYeLGYFp8Ky?=
 =?us-ascii?Q?BGQZPtvMRKBF4DltU2rbmyM6WrkZzPz6UmYaSJXnmaXyFY4dmQyQ1W6WvQd/?=
 =?us-ascii?Q?H64/9MwCEIE3GNzXgy0r8B/ofNg6TXvSa29sTEFtXOCuWtZ8Sunrhs1UjKXF?=
 =?us-ascii?Q?16YXka0C91JcgSZMGEeNr12yvVLKRdvpQ+hu57Q9Sd0EGbCtK+S31G0iIrrI?=
 =?us-ascii?Q?oNfjBbNtGkNQfN9XcbOtF6beYxh2DppelzmQTooDkciWdtSdvAZ0Iedy2Z9v?=
 =?us-ascii?Q?2sEMO775x9eNF7QarzMRfzfV/tGOgJcMraKB1UJjaa+heu9LRftHWHZZkH0B?=
 =?us-ascii?Q?E87zZNVvsDQmJ0wf0XzbmhVRtH0TkN/9hvNOQng67rDE47QCaFSzaHhrcz6G?=
 =?us-ascii?Q?EzgruyqFrvUuL0WW/si2Q53VP/QIYdwpZeJL4jrnBnd7oOb5+/RltYMXugzo?=
 =?us-ascii?Q?zISyzct55touAfdkOkw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VaVhSzNRRl9Lp+ztMZOYMZyma88JVObPuFBArq/db2YScKaHcej28LV19gjt?=
 =?us-ascii?Q?N/OprJ235i326o3C/KI1hHSHFCRTjWAChKyGDRJU3wLQwRdqHj0OAgpwbgtz?=
 =?us-ascii?Q?86PV3rLBGDzprlz7/sj1Jz82xmBHCaYi3AaN6wnJ0mc0ioGpBPi3MBb1yITp?=
 =?us-ascii?Q?lldrpN66zhOjTOsMABx8YxLhLcm85fkxlCQCl84qdyaTO4AnDW4NispD4qSQ?=
 =?us-ascii?Q?8reQ1NZzsWleiS3o+Ro9a67pxp8OyjLK3gvoBefjWPqpGLOAeQE/03rwrDRv?=
 =?us-ascii?Q?DccZYuPlhz8N2i1QonHCv/TDw95oBFPl7z7E4VMS1VlLTDnvTL3Qy/WRzXcI?=
 =?us-ascii?Q?e6n+dBuoTf/uijZkvZ/ubpvtKFpfMJUqabVs6C6rTO8ziJRZBUnK8Ic8mCSd?=
 =?us-ascii?Q?YqWjp5uGcclpD4Ksg+jPWfjpsfxZaQIDIGfIxrZ5q8QihWkXZqPst6oHDIsV?=
 =?us-ascii?Q?mQ0K0/J5i/P0UNwFmn9nfCllI4/oLQO8WSL+3IU5zgTq235paKDKvTAxDgJX?=
 =?us-ascii?Q?Fj8VYVyDouHB04a7JENgKwYF9k9tzX4dXLbQjlqAu6/uasyCQSLX+Q/YSScv?=
 =?us-ascii?Q?jtA2ob5bJUpp2uMfgX7eihgGyWw5zvKZRp8acEi8TzDGOiqTSmxepDgUvHYm?=
 =?us-ascii?Q?L0mhC1vjdIMkN2AsA76XebM1lJIjeTSLN2CvFVIzsmT3l3ruSqhsWuSJICB4?=
 =?us-ascii?Q?mA6ULi9ZLoudyCemPVT3V4nqcMnNXK6c/LyBbCoHwJINhIZVOVk42SJm5kwq?=
 =?us-ascii?Q?sf4OqfNDMeMITnpTWz0rj6zUvBMcArugTJxD9zM5wVZ+p8rPTieUS1fc7IzK?=
 =?us-ascii?Q?JHLWzY3tZpkf7jPqttofkza9yFclMlab14L5UT2z8tCBi3jAMqaB41EIHYDQ?=
 =?us-ascii?Q?UcekRh/X4oKCrI/IeSgexlY9orA8/yqZca3dEfEbsc8yvJ75lnuL4FxPjSNY?=
 =?us-ascii?Q?xs29N4ENNJWzHjjyU1bPdwuXB0KXZmHZ1i2F59b6/TaxheKlQMgwa6wTxUIO?=
 =?us-ascii?Q?KTos8ZcEx3rxpfH34V2l044TG539jnoy7mzgPcYh8VOARfS/8wn7CxsTMenl?=
 =?us-ascii?Q?rRO0j/HjRO6KIrTa4qSeaLrEPF1zAqOK06fIXI0Kk3txF/izbuRMYrNXjsJ/?=
 =?us-ascii?Q?Vl5NHQwCUzpKLED1sN96qJrEcMuincuW0pj5OQ/T29GfgNrHDw3ideAJ6Nin?=
 =?us-ascii?Q?0iWmwzqhWQQa4uL9/VjKtSv9c+IITCwuGe8XTVxpH2vabgeZOFLihIRcYpwz?=
 =?us-ascii?Q?q4yqquHVWGNKabLf9bNuPZQGRXliJStiRRlII90ojaZPtoLigoJJuKk8Ut6x?=
 =?us-ascii?Q?txSD41WuykUkRom0AZ8OboWjrQ+U6+AaFc5pXl9LxqxY/vi+3AoBRLjPJ8Ev?=
 =?us-ascii?Q?WNmC6BFlBV6BUm8QemlHnrNyQrKmiN3hD03wAeOgZQI/USSO/+/4QL+WZDJT?=
 =?us-ascii?Q?ViYCKs0P0rV6Sig+EQ/FKZAKtmbTiaqcQGvU1tW1LBSR7g+HAn0yJtMLy5go?=
 =?us-ascii?Q?gqNpWm4iVzf2mbcKzzH0TYoceGNxzatrjMug14p17Y9q8Eoxmjw1VHs80VV2?=
 =?us-ascii?Q?CgHOG6CS3ZK5qP8r0D4rH7Kgm5lfq2wLuZ8G4nDxXXwil64EIxpuXxWFkJHD?=
 =?us-ascii?Q?xA+KJ7d4TScqaRzMiO3fYjlp5iHuI1Pz+mmAPfh7UZxyPQFzJoskkg0ZP0Zn?=
 =?us-ascii?Q?fYl0CPxHmQoQd2/eL/ze5k3H9dHfNGNfwvyeyTODcZCIBzXYYkV2E6X9ZIYB?=
 =?us-ascii?Q?ETEFCCbAuQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u+I+DHWMk+GuW8285ZE68n+hgFR5LFWBVPvEsDcg/Ll1UH8qPiBts9pXiNXOKdQx2pE0CvQKxcFxgkM/5hk+faONPV0apUu0mL8q7OTTbFZHclYh6I4PIPFruclMA28cz9ic0Saxm3kExT6930bto/vSgGuxxP2v+4KIEbdtOHJ+R0Q3cNDNjW6PqBCV1uYyREJloaug0jQ7GVSRYOJue/4oq8ZN17JlmSNuNOnTc+2s3/e2GuL/i+JqoiifwjDFjhRXhXl2VYkCUjH+zmemgnuqZzaoI4AXibUXg5GlUINMcsXnT9dLJ3HkOkVRJ1F7bVj9ZU+Rk2+ChnJI14juRc03T40SdLYM04YMvDbrRWxfVS3VbngU5djFwHU2atE5sWlIq59bi5StCVOwKek9W3PcpRKiQ2Ys0qW7A7fznNuVbgJFwuo4e950RZigcMpvKwoe3P8N97ZCu0YBawOU9mfgC8wQE363rTCV5KOLnoCDRee0GW+ZF4lrnWYXfcSLUNOpxXn4FDaLwwCtvbncLE96wKTidWpqaLEyHSRVE7z+QJ4W8OgY1+FR6VjICZNSJgbAMD4geZ84GGOu6TWJqthJ/ftIP26Wwln9qDit0B4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35171629-2d10-4c8d-4093-08de687d1105
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 08:19:10.2529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lj2lNK/A2FbnFHQl/iBpvfQHozaDQ2Eoo9y+dWs7d5+iBzL7yVX3X+RK/DGoybPLzVmZxcRCY5xoPh7eL/1SmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602100069
X-Proofpoint-GUID: Cjg7mOReAkZK2U7GVCli0oRj6x8YKOY8
X-Authority-Analysis: v=2.4 cv=FIsWBuos c=1 sm=1 tr=0 ts=698aea01 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=nw9Opk7K0CuQmzsBUiwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDA2OSBTYWx0ZWRfX56DRhQT0xQOg
 b5avswr3hp9ItGjjmuvk25tWOHJHuaznA+4ZZE4g+jbOUkhL0nDE3olACb+q4U+fmIIsmjthvEV
 JnJZCbOBZO3oHkWAcGQ4Y+YtTlrOR0nCuy7f8x5pqza/0I3iTOEvS+UlIyKuxFDJ+B6+7x2cux1
 HJYiDoExsWWrk2VWwfcZzfDJzqt+isRB70mCBmg37cefIrsUX7PMGapxTBSyuAdh+FXMC7miiKY
 sG1M4CcGHqP6q45JS3CkM2kpJQMX/8zKe7wjp3F8l05aQYGhnr4FCrjreBTl+cScobY2UwqvJq2
 dYMqmMWxdXoo0PUi1FAgVTc6w2w1T8lWcD3j5XwN2bWYLq5E3uwSv9jtgF/YX5H0hLxMMFc+H4P
 OwVQVW48uor/51EICniMrRXDrgOQiMBLGWZAhdnyh6XEu0siZdtsUfQUvsKcmpZ/RlGtkhMUafY
 4ijYt0hkmOIJ61ONgUA==
X-Proofpoint-ORIG-GUID: Cjg7mOReAkZK2U7GVCli0oRj6x8YKOY8
X-Rspamd-Server: rspam12
X-Stat-Signature: zk5k6kd3n64nqwq8j8cr635hugwohwx4
X-Rspamd-Queue-Id: 0F723C0002
X-Rspam-User: 
X-HE-Tag: 1770711561-701014
X-HE-Meta: U2FsdGVkX1+Lo1iTlBykzwCRFyt2upYXNrDmaeVnrZAuRBBZ+UMXF8szM/vxU/7paizeOva3QFNJHvnaFNvfOhn3l3Q86KqQuuDrD9ULyuiDCR7ksyeEe6F9k5c5QxEUUMRaneIpZcVQ//7haTG9E2nKrccorPECKCY7l3saKKIBP7/05QzoBY8DKZJ8WDkXRr5qiQQiuYXz7bUcD3W/QDoabr7b0rPC1UYH7AE7cF2f7BpxapfZubSw0HSQH0YLbabqmSkvW/Mw2XikHLKGzXKIkYMHaLAxlv+oulEF7XdnjxMbzbsajcKxulZQHnkxalcI6FWid04rE6Ky+ig+geoaU6JEXpaYa9EhFajdp05AbrnATcqUuBdyjK+KW1ljDVfT5Ao6GqdJHux9L9dnCuYg3acpV8bdjz4K2pDCLPXBMpeRv1O9RDfQBczx1dFFOViTtVgKFe8c8vPdbNvP4dqB9d9+mDidxBGBBGFiKMjIipoQyiBu4vZ0qPdM22jZSvEMdUG/ZCJnNwmCSROhB2usGf4EtaZ9ownu1fJfCIbHmSuMEPyXpdhJ4V/kgrD4/TOceqQMu8lOwnTRwNJ8ak0TgqA21uYU7ZJNUIYLBilEOc3761+HR4GHyjod+r3OXek9MZXkyAxaFiU4ipWIucHF+ZQ5ncYJEkjeA3iDmgg0XAfHnxTkN/bssg8hBvLd+8llqL2uPg+Wb/t/8tMyczt8/9aqIe3cBlYNOvPIWGj4S5BwBP810lMKczPAaM0XICDLqawb135eV3MPweOCbEzzLFurk8GBZfj2GPVLxaRRHLNRg0oChMY6azVxb/WApMxgzQtoLac07zj8p3hM/paYIm54kIr0iTyh0k9Bq3e+ZxsEw2uFj+UKgZ2IVEcvMTwmm7xMmvCz9jn5KhRhPdSN4a3M+50tyuoREA9sMmQ7g8JFcZyvrvri08M8g+FKw5jK1eKY41CdcrKLAi0
 tJ/gS+r6
 b+GgF+Kl8chOTsDKtt7xxcLZtxnW/GJ5b7XXt+NrOVQHLSbwk1sD9u5e/cEmNVBpV1zLgSZ4A/41S/fsR7bUCTaBj60X1diX6AHrExroyinFzJo49TmlXz2ClqOQcQNs7/FY6fccjfE+bdSGe+h8DvVM71Dzjjeoxj7We6KYKJveLNWJ/YzGMf184EFlS6+l+bunYMINSEFwrarFYA4WAkK4yykRvSrXmRQhNtPClYgKqJUX8wLqIwfIZlI3pd8WhAjUdQhuOZ71se+YV5A19lWxZBVVkzx0SC4NaurZJCwiftYS/LluUgg8WFspypCeNjuExEE9zb+f47b6iJJ3xE63GXF3pXbPPGP8UbKrjI68tA0N3/LxiM+Tdgyi+e8olF+KxA5LlcJZ/Ir4fK76sYzA3rkQem1jc+KaFJUHO9UDOWAV2VFfQg2cWm4b/GF4NszpZNbQjM/iporKtOELMK5vPaQfew3M2Jihiv+FzU+EudUOephGA6rKGinAlJ15AT5oo5AqW+AawLpRIQzUvv9F2A6SP9t2YFLD8KKeBqCgn1qwNxH/g5R884EaAm099cWk730yh7BuH/ItsTD84dKc2YRfJMn1X2bMspx+/bJTbq3QQw/wg4GxTCb7dyoffhRMq65LpavE0FLzucdhntL5nz8DlJ83jDjgqtxqrOQOhses=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, I've observed two lockdep warnings while testing
kmalloc_nolock() in NMI:

  1. Accessing current->mems_allowed_seq seqlock in NMI isn't safe
     and lockdep complains.

  2. w/ CONFIG_SLAB_FREELIST_RANDOM, get_random_u32() acquires
     a local_lock, which isn't safe in NMI and could cause a deadlock.

Let's fix them.

Note: This is based on the latest slab/for-next. It wasn't clear to me
if I should base it on slab/for-next or slab/for-next-fixes,
because the merge window has started, this series needs some exposure
in -next, and the patches in slab/for-next might land in mainline
in the meantime.

But the conflict resolution should be trivial even if it should have
been based on slab/for-next-fixes.

v1 -> v2:
  - Patch 1: per Vlastimil's suggestion, do not access
    current->mems_allowed_seq and avoid retry if !allow_spin,
    rather than returning NULL.

v1: https://lore.kernel.org/linux-mm/20260206171348.35886-1-harry.yoo@oracle.com

Harry Yoo (2):
  mm/slab: do not access current->mems_allowed_seq if !allow_spin
  mm/slab: use prandom if !allow_spin

 mm/slub.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)


base-commit: f6ed7e47c1fc78e78c9bfeb668b1ad9ba5c58120

-- 
2.43.0


