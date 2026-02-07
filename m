Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F29DEE6B7C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3CDA6B00A9; Sat,  7 Feb 2026 03:17:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04096B00AA; Sat,  7 Feb 2026 03:17:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8E66B00AB; Sat,  7 Feb 2026 03:17:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A65966B00A9
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:17:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FB4CD5CAE
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:17:40 +0000 (UTC)
X-FDA: 84416956680.27.FF86B37
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01D05C0007
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:17:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="XzKMMr/R";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yl9yR2XI;
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770452257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=auM+DLHOtZXYNdWTMHlTd5MiU8ltT3oPkl1cLtoFwag=;
	b=tBHGFPTQCpngLIZQgxqFNS6SwmO5Wl2Bk1sJWqrv+BCFlUrRtpwzpHQXPM7+e7dycZzGDy
	QHx6K5RKyd24p6D+ni2LJUaqqaA+XiEKjHzDh0neTnoKgbYnL2lKpfFnxZUO0mvfXewdgz
	RVA+ylrrrCVzX1FoF6UORDUDxELnb2U=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="XzKMMr/R";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yl9yR2XI;
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770452257; a=rsa-sha256;
	cv=pass;
	b=Z77sb4m/BqL9BFc8ew4obOKpsWdXMgVLb0ihx9K3tR7NDOFlySYd2+Gk+tqksV/S3TDQs8
	MOM0macTqAeXJHZ6I0EAicxwepMhA3ucVSZebQVyegGhk1o8taplFdXGIViq6ConEbMPL6
	JFAQ9tTRtQOO2tVh0Zn/QWUUKVgJlE0=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6177tnmW1076115;
	Sat, 7 Feb 2026 08:17:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=auM+DLHOtZXYNdWTMH
	lTd5MiU8ltT3oPkl1cLtoFwag=; b=XzKMMr/RNH6t3CBG4sL6KpZRl33X1xEjBW
	Zlx8cr/YbrRRgmHEsvzjnvpibBTUzE3RSQaGWoJ/n46IgQlkKUyJjb78kqX6nHRs
	wlw82rQ44OczV1firlld7zHbyIlvc2oYCxjQt4MLSWTZgyU8PDH6hvI4ljSwzqxB
	86896H2R/X9Uj38Rh5URbiBo7prOuAqyZfyV3B+xum5QUP63+GaJcewatBExt4gD
	vqiybwbf42d7+68muyL9uZq68yqdIE0KN1DuyQNtzkvTUCvrJDicoHwQcJsTv1uC
	Bul/6tWJfjnFTRqtM37t6VfTnn6lvAUL/vEvfnc80RTvbf/aV9qQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xfp02vg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Feb 2026 08:17:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6176x2S9006619;
	Sat, 7 Feb 2026 08:17:33 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013051.outbound.protection.outlook.com [40.93.201.51])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uu78g0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Feb 2026 08:17:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XmjcrRFSkwKHo2Mo08JHMeVyxW2nlhIih1XGtvDhXEg6Aif+0myCNrFzyuJ8XnbItCvKgWXbOG4wjTTjdJEq1jcnxw1yz1CbEdABTv6yHyYFnoDq9fAZegAnrsuss1yfFrFwQTZEWZXqi6nxdjIhGXNvNNVWFOUdkcwWf0BiX3TJsk+1ZNyFtySM4tkoMdI8jquf1+NcwzyUYM9T7ohA/xCsmiKItiXUmlsB74NyMh7qd2Nz11mCInqUk0jZ8XVrokjMESN+2dJij+V9xbj9u1T6/xEnPN0gMDuNTlY6DLN1k1NqmwNvev67+8hBUVL8oqdXriKuA3EUT5AH6CH+mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auM+DLHOtZXYNdWTMHlTd5MiU8ltT3oPkl1cLtoFwag=;
 b=DB7IiXN79+Vr2qulqur/erVN/hJ2O9uO06olRuBAWzs8xfpdqLD8y0efkSa6NFKqiCTWo4z5Vrua99syrLujtfW8cDGDPARPYlKc/a6pfnRShuDdQh0o27DcFcgQBo3eZsHxWY09G/9nxvkOWeHeLp0puNUw6Dtp3J2OlVAXsmcr9CuNuDssd6QC7H2OYqqen6+aGfHNwMRrFTPOB/G4y5HqnNsNMlZxhJoUsLUl/P0z5FPWyfGFWUowePw9/iHxAnLNHvvcFepsfTIDKfx/9XUvc8uDG7F0wfEAIehfoNR72+3dr3gtbcDfF+KyN5qUIdPOg+1TRnx3FTOneHi7/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auM+DLHOtZXYNdWTMHlTd5MiU8ltT3oPkl1cLtoFwag=;
 b=yl9yR2XIk6h/ERfRiUVoYLGQNx388hYUsEC8zld7WaKI0uSW35sAybi7D/mISVOvm7P02S3tz09ritUQp5vjtS4Pq4/o28J4QXOdiMYlvfLF85j231ECNR6QDdbSaujhcuhsznsmybnno8dfYPE3aZ/AFREMKiuRM0hDvhpscb8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH8PR10MB6598.namprd10.prod.outlook.com (2603:10b6:510:225::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Sat, 7 Feb
 2026 08:17:29 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.016; Sat, 7 Feb 2026
 08:17:29 +0000
Date: Sat, 7 Feb 2026 08:16:56 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrew Ballance <andrewjballance@gmail.com>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] maple_tree: update mas_next[_range] docs
Message-ID: <6agwmmfv26g2ljxv2cvd5sbskkjgurnu2mhbsg5ssxkdikxpdp@xehzjz57omb7>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <20260118-mas-next-doc-v1-1-827d9f4924ce@google.com>
 <tal36hph2g5azjk33h564bllr2n6bz2xhdw4vcvizkhptedfuq@56chjersnkfe>
 <aXCiv9vOrMTbiJtb@google.com>
 <6fgs2mcvwlitkjza5d7cpu3mk34sqqn53vqazkicyge4gtqt7f@5dvqmpubypip>
 <aYNlvQmpL5FVpGNz@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYNlvQmpL5FVpGNz@google.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0120.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH8PR10MB6598:EE_
X-MS-Office365-Filtering-Correlation-Id: 765b7960-f151-4aaf-1b3d-08de662155ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kae4sXJXgtqZsDlXeZT0hnc8Ug7k/ahGexCpje9C6m+bDorxnN9L9y1VRZw3?=
 =?us-ascii?Q?0Qwxrl/xb8kyJO5Rp0nwryg29r3n6p3l1qbb5rpcTacBPHb+TVYHTfopfla9?=
 =?us-ascii?Q?v1nhj3DrYQevdEQoGkLuypSMVsfAaDyaFDQLOanuQY2qbZGRNKR30w9BJ1Rv?=
 =?us-ascii?Q?1gpkjZrT1TNiSj2vCLFgLZeHHn2GR8mVpSbUH+EH+5uW7l4TJLdQahgnQTKA?=
 =?us-ascii?Q?ZlF1JlMG2/GFu2olQ+o/Agxd0XoQMHSjBGGQRE3cAYQs54DnFToAypJdjLCR?=
 =?us-ascii?Q?PKo6TZn/haPybBeKHMbstlTkRynViR1wClLjjhT26i0EOpwKPQ+KlHjExxKd?=
 =?us-ascii?Q?rognRqtUttT/dyCa8oklcYSdTkalnZxL0xEOPj8lb1jLO37S8bo5GCYhthcY?=
 =?us-ascii?Q?i1wF3CEwEYb2ZQpLM/SCr7+QosZX6lTsOwWEFoJy9kBK/PTp6CzfMnM4+URu?=
 =?us-ascii?Q?vb0nNZjyYK6y1hfAsVHbHw0eA7T/zOHFT0Y+GsbiwQ6oDwLx4Fqw/qJ7aTAD?=
 =?us-ascii?Q?DPW2+da0KqktBPIpxbuoFEBSsls+mRPaOqX6vcJY4uRuKQdgA7cZjAtYl0x8?=
 =?us-ascii?Q?Iv25BKczf0GZW2P6JwZbwNI2MAELRCD2CdRP55zlAoUJ7OxDtsa1TuxsO6ab?=
 =?us-ascii?Q?1HrDtDYDeDWM3LeN6CkoiJxpk6guARJtucwXjxuHtlzMQbW9l2j04I1VFcAI?=
 =?us-ascii?Q?O5VZGpagR2WJ9qiuTNd+JOFW5FNOHT+L0g80bp2g0bkSBw/eeDaV/37By+E/?=
 =?us-ascii?Q?vzzfJuaSF/yYoVxhkBbsXNrkEAp1mwCyncLhT76ZyO6lEkflITD1YYF1p4Bc?=
 =?us-ascii?Q?pzUyTX0vZAV4xVvFY/kbsoErreLFMbeTmyoNnh20cCkrvqoAxXTJLlKF/uDN?=
 =?us-ascii?Q?oJX8oQr7NbsjwREM4ywZwF5QyDewyi6doaOgHmRmhVAA6Z+ENljKAOwu6zT6?=
 =?us-ascii?Q?4xH4N3VwWdZfs6AOzdEkFJ5Id+S5K2UbOLJkl/dh/QJ5bHNnDD+Z9cChYAcp?=
 =?us-ascii?Q?Yv6Xre88qfD55ZZXOsJnSXTfOBm/Jht5sKVap/MbjgQJSv4IqnOyb7AZ2cdQ?=
 =?us-ascii?Q?w3EeuMDD9SThuCwV8397yJ3VQ3yCKAYxz1EBjpxOC4CExxLGfX0/vZKEUoMO?=
 =?us-ascii?Q?QLtJl8TzykdxRDhuMzG7rfC1n+sZTiZEPSMQRasxj0yzqOD+cYuaHYuzxFYR?=
 =?us-ascii?Q?HI2BJKojShz+dVwunEYuZvSPQ3A8dX2HrkFat0mdCU761mCe/Mga/3At2nio?=
 =?us-ascii?Q?H+8Glj/wJTv0CtGmsXgjAcVXulfu+/I04mRHoGFgdee2iOZ9ytmN76shT1RW?=
 =?us-ascii?Q?HRln+XVPZWH4lYufcYV93WyIH8YzSceKZZ0tAD69HShGeRDzKgZr3s3VlWWZ?=
 =?us-ascii?Q?t5AlO2yy/ujF78QANQkYFnv8F0cwWWgHz2a0FZlp6JdazWB5rK+1Mv/RDT8L?=
 =?us-ascii?Q?GyDGMCr7WKrFm28NqL8wFhSVPO3J25jZwq3EM8Jb0BDj6ZC0BblRNiL++7dg?=
 =?us-ascii?Q?SZFR55LH/NT7By4fUXlhcqIe8255yPbsP+Y3ONShOQOdFn4GT8C+lo9s/5MS?=
 =?us-ascii?Q?ahuEAfBXAkdCOQgEUVE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eynHvWmjVcmt8PdLx6mV66SY/gx7Mzugq6j7IC08uX5ctDD+H8l0BvnUXud6?=
 =?us-ascii?Q?pqv5K6+WM951gi2WlxzjWEOnQ5agToN67ieO4Lt3dlSanHTFZDFAooBpknDM?=
 =?us-ascii?Q?np51OwntcXrYTVUswouhs8Jg8pWHNPwwTUtuGUOGBr0As1pAbknVE+bDr73n?=
 =?us-ascii?Q?swhBNjFIrUJzCEcG4F3D3GX9KSWHnIViTZyaBwPIN6iYf43uUz7Iiqc5YpGk?=
 =?us-ascii?Q?6hWi4mT/eF6azvWz5vrOe3213xz8ayISrJfR6hugbZxAdWxgbOC+/y6XMtGk?=
 =?us-ascii?Q?WYhVl9Mv2ie5yUyyysjrvhwBL9MVdioqBUzdmc/HoMNerIx4CJCoUKbbE5+H?=
 =?us-ascii?Q?VVA1VPWxhtgqmPG4PC/MG8UyNRCrJ1lcRMemDPeo2ekPeNvDneuL+MvCTF7a?=
 =?us-ascii?Q?t6+SFJBIkt+DrJ36sKDvirti1DGNCJTN1NoA/Q5ziJ1obot5su8xZ5i4Iq61?=
 =?us-ascii?Q?qyTGQcoZDLxhNII1h3pXYQH8/fOHKe76JGPqtzNQ4GG8uc8LXgult5PhQeNe?=
 =?us-ascii?Q?NHZgHu3hIDryDfm2nW7vDK4Y/O69TEz19I4O8Jg4Ct3J/N6QKYXYFXGyjqi0?=
 =?us-ascii?Q?9kz8BoKjnJgub/hO6hF1H2Z5BbAHKJDNdgd+5gIKMtZ0WnLv3M2DzQbbC04b?=
 =?us-ascii?Q?gDNQ1jz6ZsljIn9+XIZ6F7165nQOfJgrfk0Pcw/tmWzqiEan5N1ZZkz//ylN?=
 =?us-ascii?Q?fynnTj5+1irVu6epehrE400mutSUXqu9Cj9q8FboJuQAe/H9bvqp3f0MDN+i?=
 =?us-ascii?Q?IMmN6O0twthHeGpbf16zQG7Z+c+sgc9ae77aBP1qzA7V5tiPwOgad0OytAyc?=
 =?us-ascii?Q?mYXlojIZO91Ll5hvXqDBtmmeOAQrHN5O2T6CB5jAcb5EmaslWv+DoeZv/0XA?=
 =?us-ascii?Q?B68QkL9k2Snzk8+4n2Zxv1I5AEhrfnmRKe26paQQ/1s41D6KVfT7/Q6Xhau0?=
 =?us-ascii?Q?z7xhRBL1wuKGrQ5s62vOOWBM426Rm2dgydHh5KwRvGJx/Y1qLHgkPoSgneoi?=
 =?us-ascii?Q?QLY+JP+Eyjjc7dnBplZdIlCysDlQXFNqMIhr9Dj4i7kNjuI1U6wNsHEvBJud?=
 =?us-ascii?Q?EkFLTveYBIC5LtzVLwK0pwlAqMpI1iituYKJW7UOZYqTohDtDXvtvfrzmvs2?=
 =?us-ascii?Q?fMmXBahEGaYxGn8EHvwR1q+1hzuTJhYKYG6uEKrWTthD4Soudaw1yfWupaQw?=
 =?us-ascii?Q?9ei/WvVMXKNv+J88OPVeK6pHmqfjGcdTa4WfMMO2DVI2TUGG8G1wfbSoMM3R?=
 =?us-ascii?Q?LS33xu1mtRwu/7ijRtE8fbqZBXvWeQHUxAluR8ZLFtI5uv9Rl+pCLjwylyiA?=
 =?us-ascii?Q?X+fT25OCqcaoPQyWoWLbuiP0IDTREnX5eAOpKydaxdDS34zGjIIZukAIEZI7?=
 =?us-ascii?Q?iDZBYZ7/VVt88HcRJuUP1RCtKEJwMX6+qvdNVNjpkM/mm3Py8HJCYJsAFXfy?=
 =?us-ascii?Q?dz2ApLS0vYfSSupcn+zbPUnOhOxvtvCf1WxFAjDE/A1vgh7c4Xm+9Oorb8ZZ?=
 =?us-ascii?Q?HfZBFA915IsL/2W+eYYts1Met3NUD/h867G/XXCgQtz9TUADz/+eXXjnhhKJ?=
 =?us-ascii?Q?R7yKXvNeKkvioaQxYLqEiTIP+GP0ZctleNMfN0Sx05oenFaA6Yx2Ie6Zvdb1?=
 =?us-ascii?Q?gHVw/Iwq68X2H2s2KkpcXwnVpxrCb7nFBY8c6bteJWvH0/VuhvkyMjnC05Bw?=
 =?us-ascii?Q?B9HGD6u3At46Hayrldo8iFidjYxQjnlo7dets0ycZOBct1DZB08jV6mcxwY7?=
 =?us-ascii?Q?TnnujEiDSQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NmHVj8KcpX4wjJSwT35LAIKHA3rSAPZCOLMSSa8BWMkzCW4VF3nEwzrWf+/IJtzMm8OS4WilIGKO/sNK+spUuIMPHHrmZ0SVfgGybvT2o+1th2muVs6UnYaWTy1e4B7rNIK/fc1sdLtBx3HOcSTCarvIWuZlvG5qLwklekUbQ0/es0gGUMeNyM2wNsYETzEfgiw3QMjQcqugOjdpR9cILy0Ar08PSRh5S98rDsQCtzd8yL++E5bpnR2f76GlAhUHAlh6xaCnB7quMHyJECi+XP8ZWXVkYX7uAFhdCMqK9UUlDx51nkQVlixY8G4s6djp7xv+0RYqTXK2GIEy1a49K8gqrKhbofiKkLV21HG4VAvFDvL1b/7l85jwspMeBrRzAmGzAi6CP259iEnJQX7/E98Xvp8jSP4Ei1WFqmA57YHkvjE2Q92TRfNwkIWWzBtjxG6a8eSE6+sVXC3AJecNx62K7kvkMrRYojAjDbqYGwiJnAnLeNy7ScjKT3EbQDJvpE1iljWRS7O7fT6ULMJAU2xTGOBt316qH9k0xHYcji4Sf1W875sce86+gVlOpuxdCAzYI+S5+pTrZ7JR9hdjz3I5pWgUZueUDiRwm9dSaYg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 765b7960-f151-4aaf-1b3d-08de662155ce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2026 08:17:29.4930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ix65oXVXhW9tAj+7kxdCfxQkdyOzabjTIMLEwAXS4zAostWuzwTi3kyg64Zz7iRTGdC07usvDC/keREV8t9qcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6598
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602070063
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA3MDA2MyBTYWx0ZWRfXwmmanzjKCb3V
 B02xt8e1SVE4oFxAJmtpZUp4UwZYA32ranuQGnpAjG7uBsqFyL6mANASNCW+RquaUKDU30Lf9hy
 VzLPssEOAbIjBqpR0CrqzMx2kYSljm3jO0ULcQ6g7rKOmnyDndFBLHX7y3e5i8ndxHESFnmGAJg
 HIEvTbxYZN0/UqERuRSz0CO4SruNb4+1yXRhqeAA1azTFGIyBWZT7pl+vkXvHK+1L16gJLY5Gz+
 a7ZFy3mcloN7rNARl1TQIU5ndRGvq+FxyAupRL10M3Ufp2ZxEm2zlZxemH8ID/Y0/zijM9rc2+V
 v8Skyr09vI+VPuuFRBv/Q0+JDs1185seeRXWHqcGUBUc4bipU0xICoO6Szb8Yn8uCJGfdLq4ohV
 YqafESpf86aKMkqQdR0K6XzovjNJ2atM0MEMP8Ml0llasnp37Pcn+g5cmdtkWg9zSOtWIfeXcS0
 3mFOtQJXNKC6uYohcBQ==
X-Proofpoint-GUID: 5dWu2XbI052oL0Zv2s9Cm-2YwGyhlsc6
X-Authority-Analysis: v=2.4 cv=V8xwEOni c=1 sm=1 tr=0 ts=6986f51e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=1XWaLZrsAAAA:8
 a=zsNF9E_zTQ8Z5PZ5LdYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 5dWu2XbI052oL0Zv2s9Cm-2YwGyhlsc6
X-Stat-Signature: n8zhcneh9ts5d5msii3pj8ydmyewwxg4
X-Rspamd-Queue-Id: 01D05C0007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770452256-460220
X-HE-Meta: U2FsdGVkX19H5MbZCcDtFI9CmLBQ1myoYyVQETRxSQvn3kurlxYb1iWxlECAVY+hTHoNIc/wveoV/VK/fDOUUBzD4qowzbfi7fVxrtHMZFGA0/Bfl7qGSMeiUSICbXNDkL1xfnLystvro/ogdcUe9/DJqJQEvVHUMm55XBTary3bk54e9tu7PXYRz1xjbpnG62NMA/nvIw6Aogk+gPKGQXXLje6+9cbm+MipAxJSeciE1nP5FQyzmBhg3N0D6BTWZstYEbmSzvH4wsG27Zm5qTUc73Gr67WU4648m75OalhHPQT6ywzy4Wr9sLbGJgLvUXMBp7DGuWITUYlxkILhNZN0R+OTmGhnLxQv3yn6bnpZCtXbagp6vVRElr7kxBwoit1LYD4q9maDEHxTgZtK2bbeNUkVarQmPcigJ9/Vghv4qWDrE0+tyDf1aNXVHhL3ane1Pet5J0T7exk0MbngNuBu20J3zmve7jY1DdBJgDIB1GnPDN1qEAhqLsYY8nhbdYswtbNjp5g98QBULT2xnTZrxl+DJG7mrjqhhmKfKpmAbMsiQXiW4hKM7BAFUIxVaOowqn+t1GkbIMZa2p9MxUJrjPCcQadBbdGusOH3TLaHQGOk0E4szH+pisgyrBfuqJpFeigdV+ownQy7miqoTebfe6wMJZdCzKEkZJgMVOTV8qLTp1vduAUrulGkHLMwtp2aPj/YCoN1F0G72EifChbBPh95EyxaZ3VHhSVMt+Uw9jj87nmCgm5/UQMIbJUg9Xx6Lava5Vgcw5OEH7Ki0i3B4NaU5SGkgI3kPli7yfH7BHpcUFHTFXcDBvUNQGSvpxwHLXBVGCcPX7bz69r3Z+ZbZORqHvL3TyV9T6jeKGjyH/knskG3hMFJIdUY3C5TIq2/sWgmCM1lJTMkkFzwlIvdobunIwAAsSiTrVeh+ysquL6UPlKWVWrMS33yzV1i0jOJIbWQ+XDTEO5MsDI
 8wGZNHDo
 W5Jc1yFJh+DPtaqtiagnGabKFQ9x/TaaB4eC72AvmsAIIjrV8EkO9ch6fAb2gTDyoMPuu1P5M3i3AR/SdWqp8+jSiylySs/6HsGeSJdOTjT4N3KKz9qEr+Efuavl6rHUeJ5uaz2YUZJMn69YzAubKzDWgQPdBghBwbJZaNGG4QxxvA2Db2NiIEaTNVUboYremId6sAohqQp9tlCJkjf8ubcx6PKWx4HIy3MGnsL4X/bnqufpG8T4+QK6jIBwM//ZlvrPUUmIVPB0Th56B+9Oue9eWxEH7qKgIVf2Nas2PCTn05hEqbJZSEQ7LAczA9/juIlZIDueuT3JScNyYZgXPWDyZ9M11xVyru3ubLtggkPzIRkAdOyhW5IepFSg+G9MyoNOqMi54sHrQnfrQN8Nsm506wRDC8gQspCYkJ+s/F+LHTJ0srT2yrU/2fdfbU1t44Nwpzo7BWsVZhLncGBW+IvwRcPvegazSlKu3SzeP/ks4r9W8+hZdVOwrVH1oswFJpR823Ih6lbXR+uCC6kWhUNufYCrpe23ezoQUNnx8s8XeNoZ8I/baqaxlBZu17FPHMEaFRPDU0w8seKSFNfPKuy/7gp94LKVKfJ/S9ku6/9lpIPQZcapyXmPOR8atzOMKhoxRNpCMiLw+EcUPneQHIEYG2vRkqgMAw7Lx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Alice Ryhl <aliceryhl@google.com> [260204 15:29]:
> On Mon, Jan 26, 2026 at 03:20:17PM -0500, Liam R. Howlett wrote:
> > * Alice Ryhl <aliceryhl@google.com> [260121 04:56]:
> > > On Tue, Jan 20, 2026 at 12:54:47PM -0500, Liam R. Howlett wrote:
> > > > * Alice Ryhl <aliceryhl@google.com> [260118 06:00]:
> > > > > If you read the docs, it sounds like the difference between these
> > > > > functions is whether mas->index and mas->last are updated. However, if
> > > > > you read the implementation, you will instead find that the difference
> > > > > is whether NULL entries are skipped.
> > > > 
> > > > This is not the intent.
> > > > 
> > > > mas_ should return special values including the XA_ZERO_ENTRY.
> > > > 
> > > > mas_next() should get the next non-NULL value.
> > > > 
> > > > mas_next_range() should advance the maple state to the next range,
> > > > regardless of what is in the range (NULL, special, or a regular entry).
> > > > 
> > > > Both should update the mas->index and mas->last values, if it moves
> > > > (ie, no error state is encountered).
> > > 
> > > I guess I'm a bit confused about the difference between XA_ZERO_ENTRY
> > > and returning NULL. Isn't the case where we return NULL when a slot has
> > > been reserved but not inserted yet?
> > 
> > mas_ will return the special entries.
> > 
> > mtree_ will return NULL on special entries.  I think this is just
> > mtree_load().
> > 
> > If you want to use your own locking and use mas_, then you can filter
> > out the special entries yourself.
> > 
> > If you want to use the normal api, then the special entries are filtered
> > for you.
> > 
> > This way you can mix/match the apis but the noral api still remains
> > simple to use - even if there are advanced users that mixed in.
> > 
> > The idea is that if you're using the advanced interface and storing
> > special entries, then you probably want to do something different on
> > those entries - at least sometimes.
> > 
> > > 
> > > Like the docs, you use "get" vs "advance" wording here, but I don't
> > > think there's any difference behavior-wise? Is one intended?
> > 
> > On return type, no, there isn't a difference.  The difference is where
> > the mas points in the end (mas->offset, mas->index, mas->last).
> > 
> > If a NULL is encountered bu mas_next(), then we proceed to the next slot
> > (which must have a value, if there is a next slot).  So, mas_next() will
> > always return the next entry until there is not a next entry - then it
> > returns NULL.  Note that mas_next() takes an 'end' value where we'll
> > stop advancing slots regardless if there are values.
> > 
> > If a NULL is encountered by mas_next_range(), then we return the NULL.
> > So, in this way, we can move to the next range even if it's NULL.
> > 
> > I hope this makes the difference more clear?
> 
> Yes.
> 
> But I guess the docs should still need to be updated? Right now, both of
> them say "Can return the zero entry.", but one of them can't because it
> skips them.

Neither of the ones you are updating should skip the zero entry as they
are both the advanced interface.


