Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B2AD2F352
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF9F6B0005; Tue, 13 Jan 2026 14:19:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96F36B0089; Tue, 13 Jan 2026 14:19:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EE26B008A; Tue, 13 Jan 2026 14:19:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B78A56B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:19:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65A311B245
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:19:52 +0000 (UTC)
X-FDA: 84327905424.28.D31D154
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id A2B86120004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:19:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="RY/elXwd";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TihwLog0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768331988; a=rsa-sha256;
	cv=pass;
	b=pZQWg2mdoKRQGz7DpXUjQyIf/ZiwM5qdTMIZ4cN8XOg3lbt1j+QFnTYv9unF646gc+2yXD
	N0LuBCEUOcHuqyoPQAsnFLu38UlS4iYFv2DnPwXJasndfxSGhi4+PGVa3SkZaFmKApil1m
	gB60gWgpcgnwN1SwaEtF4uKEFlYkbsY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="RY/elXwd";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TihwLog0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768331988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zfo3EL5BYYZIMtNbJS44/U3BTMuSkZnHRpoGOXVEUZ0=;
	b=VCO0WgiyFx2nK8xeGwWhs4zkAW3L6TqDk0B7ya+JwHkuAgMtRZwCC+NedNHmf+OGpAIiZK
	U+6dgK5qecYDMRQGs7b4GwiefAip02pPhZose9/lgkVcgT7fLtO8MwbcmjhKohSHa3n688
	UP68SDC7JkrFiIlS2nJ/BbeVz5QHpCI=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DGCTe82753320;
	Tue, 13 Jan 2026 19:19:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zfo3EL5BYYZIMtNbJS
	44/U3BTMuSkZnHRpoGOXVEUZ0=; b=RY/elXwdo+3wsQEmwlw6XPXg17LTgtB9yq
	Nga9kByqG6YtT7Wbtn5Xe7xJ2dIhNpNKjRVRPcRQ/LkehpHKQyZnL8Q59JT1ZWP+
	WewPJUI/5PggEQv0x+RaJu6+DeLAjGAm9H+atB65Uys9BvTo+t5ln/t6Ou4cmezj
	r1wLnEMBvDcnE4z9MSJanGrFmFPMnL1xjdl5bP4py4C9w0jUtqIJWyLd6Zd/hBFC
	Tv7QH53OC6Yc17nXUdpQGdyzcUVELxcdGHtISl0dqwCd7frLSjyKtb3FYz9ypgme
	rpWmBWKymEWVER6iBIpOKekhFLaeAasX6Eb69REtmVX1TwUT0e3A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgm1s1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 19:19:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60DI8puN004868;
	Tue, 13 Jan 2026 19:19:34 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010069.outbound.protection.outlook.com [52.101.61.69])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd793xux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 19:19:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LmN40p2xlnf0qAsoM79l63SctKPj2a0yALl/HLo2xF1rpvMQDOeRTtnyGZAfPrzfc3F5SnE8xFwYYQEw2tQWS8xmuG/T0Z0psJjD0voaceYVgXNcyTFmGgi87Uh6Xp8MYelHEyMNrAK2FAv4IP6RT3oJxxvHJBNj9q4rbiRfN6QdRKHksjTLzZGdZsps/onWWRGHmpA2TppGqzGVnh+pgEyJ6PwAtMlgz6qfJmK867s7TxD94XeSRYRSboThlJKk6gBaYsBwXmSEzOBC96aQtvwPQT/RF7k/CVA4eRsSSZmwW/8DlNLtdIFg5fh5rPXXB9ZxoWgbuJxaijYup8Bp5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zfo3EL5BYYZIMtNbJS44/U3BTMuSkZnHRpoGOXVEUZ0=;
 b=E7UtG62FH+HvEG3MD/L1vQcvYRgNQToMrDBcYweVOMa25YGNADLp81ISfBKH+ANueF7PB4W9zD+rs7QJyWJ3Vh2wY9L/3LXAIQ5ffCgG7WIclMguIx6r7BZdTjYzO4sK6Apqhz/3z9bZv8i1grBBuavayIMy05GAWRX/516WQ9sXGEwf+M5THnMpGxMEHm7IA7b5C44UN5jINgeFG/m6o0Mt0zrQMYKHfR7TT5UhBZe4vVmfc6kYWJoC0GPXDCXVaSlMibdy0QueVSwA0zHK3ZuU+QfzbdTCbmDWEQohrDLYq98sCDnRE09X8HGHmP6YMJqrrmiCzhizbs/wuAss5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfo3EL5BYYZIMtNbJS44/U3BTMuSkZnHRpoGOXVEUZ0=;
 b=TihwLog0bN86EzFiUN87L89ecWqskMqcjii7LZZdT6d+3MVBlX30OTBDLzOQ637QPI/uzo1h0J4hoE6wdcF+NA5a253MMZZmVSxXvNp7eUPehvz2RGHHn72YtJj+KDTxF68xS/oynl1utb71vrfQGG9szYxUDfaXEr/t7W9aR54=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BL3PR10MB6211.namprd10.prod.outlook.com (2603:10b6:208:3bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 19:19:30 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Tue, 13 Jan 2026
 19:19:30 +0000
Date: Tue, 13 Jan 2026 14:19:26 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 4/9] mm/memory: Add tree limit to free_pgtables()
Message-ID: <indhodowx3xwouam7l2lumqr7s4srupv7pdnaobmuaucljtpim@vxdepizcnxcg>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-5-Liam.Howlett@oracle.com>
 <11f35ae6-2891-44cd-a670-92ef2151b885@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11f35ae6-2891-44cd-a670-92ef2151b885@redhat.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0156.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BL3PR10MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: b2ff1737-4560-481b-381a-08de52d8acdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007|27256017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xTibpy9Ps/FXqns6xhTJ6ztzNJSEC+8Hmgk11opxYtJN0wTRJ6oR+7SHeuzy?=
 =?us-ascii?Q?cI7YjwS9vPuAPRBLF3CrsH+cjw7bv9gsP2Ewz/GV3IpWbEJUmW43FbLSWxc4?=
 =?us-ascii?Q?3EZCHQc+SJ/EIPrnHHmEV7XzKEWnsJj1aNFvzVqZbLLzsvz7EMOxPPcjaNzc?=
 =?us-ascii?Q?CPj1AVonotoIsfFQZB8wN/nlY9yzSANKtgTTPLkQRNJMGRd2CAQZnN54T2rB?=
 =?us-ascii?Q?IV+hMqVzrIzh8NUHwS1Opw6ZK5fS6Q/NFScsHHbbBP1Y2AODqLlaAFBC5kSB?=
 =?us-ascii?Q?9BGb2y0Pm24PWMBHD1+/ZPZSKuNlTT03geEH5ExdHyeYLFCrAgHanUfPfJ/F?=
 =?us-ascii?Q?opnsTrYK0tmuj2da64sDkTMujYbA/QdcIbyvMkYCN8bC75CRzXgpb93rxHl6?=
 =?us-ascii?Q?2bY5G9XkvxUsO+ihYdt6buI+pvGmxp8J2zmZQSasN9T4sZdfMrPRW6kT1k0c?=
 =?us-ascii?Q?QOk6SC86UoF3MDrQXqzWINI6LKabncaXICMLKen7HgwS4iv2kt1gxddTb//t?=
 =?us-ascii?Q?4fPwFckYOFN+wHzZyfBvqQDZ3XxGi9LsXOCrZAj0sPaNecXUelPCZ0dar1X5?=
 =?us-ascii?Q?MfBKdGteCOu1Hvq23VYdIyFh2Swo8aPZ3hSmqZnwGdDp42M/vbSW28wKcdkK?=
 =?us-ascii?Q?cktEUKsAXwsfvM1StSQAb7SlPfhMFqGZ5yzzOdXCe/FS44hZKt55SUIuFqkb?=
 =?us-ascii?Q?J+rirdrbzdF/DADwaKloqvaJUbTayqmIqlWYBSBeEijHmediWBbyzBdI9hc1?=
 =?us-ascii?Q?XcuNJYP8YJesi/JR4wgSLgEpV6ZMONc2aorV6hmVz4q+Tlgartl6rFWysW59?=
 =?us-ascii?Q?mfKZxIQnpPmRYsYh7MJG+FCy/pqnPY0iU5aZsAwyPVER4Yt65P0llXOSRLP5?=
 =?us-ascii?Q?crgFg58ze5SPESPr8E/Zch+pnCv+Ia+DU09hOUg+Xpi+KXSlu65DBHtc+EO+?=
 =?us-ascii?Q?X0yheTBeH0EihYGC7f2r7aSwOxJx8gOG2V3sY9pGzcZ3l9ZdWH2LtT7YF5p1?=
 =?us-ascii?Q?ldcPvWFKjW4U67hGYkkwP56ZR280xnyQWbfYD1G5PAUeS4lYY+TSnFJqdaTT?=
 =?us-ascii?Q?g7BpryXAmHno1rEEPLEu6YCPyZj5Hnb/RnFQYid+l0bLVwNnW+b/ipPR9eYv?=
 =?us-ascii?Q?XxKz5XOwyAerPnkn8UilEUIe4UzjpQszHohowzVFrjokixoHsagiGOZBPLfq?=
 =?us-ascii?Q?GUXARjB9nZgn2Eq6BMWqrtTFQ6DbB4AO8W9UnKHJITxKrSfBr7g72g5HXgSS?=
 =?us-ascii?Q?RgtUROjk9OSmRCK6kTVbm1jGChgK59+U7jhwaQ5byI1NbuDiXIQ8T+lX5L6/?=
 =?us-ascii?Q?KDEGIhNmHk/46PELhxXNfW46ZowRvnXit8Bl+c+nekZITWoN3yoZ3LHkoYHc?=
 =?us-ascii?Q?axSoY5/iKNrJeAx46XlGl6F4dKXASM0kiOgFujfF5GJgupaA2eyQgKFP+F75?=
 =?us-ascii?Q?o8kY6polmdV7NJ/hQYbXP+88vf9yxslYHvySww1QIP5KHd1STJSbHPxh+jJr?=
 =?us-ascii?Q?F5olS7rq/bTgkF8kE0HNlNomIYVvQB19Iwgg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c+hqncwfYyJIfaU/CBJttCQHYbM6kXbLsiZ4tzsEutSieG3PR8KiZHeLhfWE?=
 =?us-ascii?Q?Eb5LsUgfQHT3gELfLNB4JBcRsNkj28L8S0mnFXYkl6J7pz/C7zsIMknFBiWC?=
 =?us-ascii?Q?JHO2cH7xzmMiCmYxA24XqW22U43gnOw23jON01axg/Tf2tXvuAEkFwE4xhSQ?=
 =?us-ascii?Q?H5BFcV1rznF3yJ+YZv10kr5OJkwmXJ+AmWJvc98NYlN3bpBhqYsxgWPRQCSr?=
 =?us-ascii?Q?fii7ieyLEfxpj9hyZETmKIbi7dtOrWUXKHMyuehEQSP6WMZ6wWF9CgHVU2h7?=
 =?us-ascii?Q?BRdhxvr9LABgSsiX/tL4Z0v75R06kYlfovGATDCZO/6YTpeWs4G9Uw0CjLV9?=
 =?us-ascii?Q?/z7G9j4BztlGT9MSF+0v0Zt6Wz6p5f/tzz+aehHULQ2pxtZGHdjKEU5Jf0X+?=
 =?us-ascii?Q?loG5Xmp/atKaQHPt4pcIWIFUafmm14gVPjyTKQRo0DPMGE1mP336afl2IcrU?=
 =?us-ascii?Q?hNqh4m+Ct+4XSAxVqK/BFldWPshh5Cbf2DbdpXbKmfHNGt+nCbF4l2BaaLLY?=
 =?us-ascii?Q?HCKMr3spnqU2aTrgXfMmSHcd/daP0O+jXk3O62SL8OJG8sxUxgWcXxrhGr2o?=
 =?us-ascii?Q?JMWFT4/svYZcry0Cl1vsJuJRWkV6w+oYs1JpB9PSf57c7vIpSVdlv2/qDS6C?=
 =?us-ascii?Q?fAQP+5D1HzP8P/iTEQ6rk0OPjtGZ8eYdFtrsiMeoLU8zleZttjABqNmzHSig?=
 =?us-ascii?Q?GeqcmG8o42Y71H7Lf9X4IlmjePB4S2ztKArHwkTzbVoCxu9FQmQ14lDKgw1k?=
 =?us-ascii?Q?E3cVWIBufuXu2+Msh49lIQCNj8F9LGpjXhcQ3uD0ckKwncTMPjeXKltlkAuQ?=
 =?us-ascii?Q?15PlJqozyUKhA0/g3SSyngCsEdZpCFGki5s6m/jFWHxWczG42hwdGpc63atE?=
 =?us-ascii?Q?SNLfWJ2tkKH2osKBSM3ul51s9KtXpKM7n7HHRciZEby6i8Go72Avym61PW/X?=
 =?us-ascii?Q?/XBK4DzjqQQ0JBVM5HsJGdAbh4fCD2+pfmbyDEI5p+0AP0mRbX6i6ykcTv5A?=
 =?us-ascii?Q?L3f/Qagj0DL5Rx6NAT1E+jOcqji1T4lsGr4ddYrDpm5QVnJmny1LTQJ3XVhk?=
 =?us-ascii?Q?tB6ON2NRyJMidksK/V1usnB95OS1CXjPWPrXY16sAm+DXnyJTZHFlukqQuxb?=
 =?us-ascii?Q?HjR8jyHbQteie00nWoTlOIKZxJR/fUdS4oNJiO9uu7RV3zUehEfH93CU4+lD?=
 =?us-ascii?Q?dw12sNX/GNzilatfSvt/0VUeb7uNaWnnEE+6JeQzN0GwauCrO6fEs9FXbYuV?=
 =?us-ascii?Q?/3T8bXFFciwI2I1RwrioarXhxv09ggMr8Vqzu87MZdXfiHUccEOQlvdJjphQ?=
 =?us-ascii?Q?juU9JkWRdcZgJwdHzMtuUENRPfrm1ZmWZbHtbhKaIdUfJNc9OalodvaUn4e7?=
 =?us-ascii?Q?irhW+qGH+K+HMjU1qi7XE71kntKpllr98JeyASxcMcL/xuCA/StKCSmHP1nJ?=
 =?us-ascii?Q?9/JkX2b8aB0b3eZMp53+a1efRsyOm0QDjx1+HUTL2g/ZW0WXyhJ8lFtc1Ni7?=
 =?us-ascii?Q?DopReLgAZuZJhBkIW5o77UN2PmnsO0sU7VEn3+GLqOhUQNN3XAdiODBRi3OY?=
 =?us-ascii?Q?1iIhJ5cD5W9YK9vSwSImcZUOxumoInzMjFP6DxepVQKL5OCtbPCX53qNBj2e?=
 =?us-ascii?Q?LPxCAcuMopE3kZB6Q5AAaom4vtIu6CmNuG4nBtU0VyXMz7YTqpmgDh5F142k?=
 =?us-ascii?Q?Pcmd2Y4XwPgEdvBsm0uJBZ01gaLwagz3DuSzVPbHlsok6JnRPF1QZB5cI6Fh?=
 =?us-ascii?Q?yutjaTsc0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mJ55Ej+Y0PipP0/fJpUEghtG/OBuz/QxPDgBOzt7NWfqGWP42O93440E3+unfAMIa1ZV5HbkTl5wF3id6HN5AqowpviotvR8wLG1NH/h4SEjM3Wb3wzBPTct9qpc5LQZ8uWold2t/UT567hsM/GozQIsdv3PKim51YfVyK1UGmAZMJWp6CxWSgFpywkAFu36Xqr3yDgm3H5IiQ9eav8TWhfQdw9INVy6oA07k/9Og44CQ1QuvBOAvxovzqXAepBWIrEYEf9sz7Fyh0NvjJWi5ImmwMbpV7tk7eef2XXEmZ4JHgm4rH/2/LDXRc5GSw7B/4Jj/tLT2lBo5d3pkpN/ArNInSJafMr8K4q3DpF++tIa54izuf9UDJCclUMKiXczlp2Wq6DS4aBr3K5ajV8SMb3DDOv0gpDTowBVNqlrGW1VoFsJyXlo8Sn2h20SVvvXJUiz8aP9g8ARCD2MuGuhG7C2+qdFKcTOfCe1qyNF5akJWA74C61wDRVKYmAz/YVMzKyXa335UOcutpTU1vAHaKkIw51MOQbH1jfvYEOWhjQo+f5Bzm8JIt2sIo282FZHlOAfqhbwMhw6dpy0ykiRwPmyN66YATFw+zn1r4bO1wo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ff1737-4560-481b-381a-08de52d8acdd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 19:19:30.0679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5KRBjemGozTlHmbTk8jI5L/vZpgzLVjf4fKdg5k5EorjLvSFoHV2jVM4xp+zCUI39XIrmOOgVIafSsoD936tLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=904 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601130161
X-Proofpoint-GUID: k9FDmyiZNKoRfQrQTQDmhFSNC7I4tsiA
X-Proofpoint-ORIG-GUID: k9FDmyiZNKoRfQrQTQDmhFSNC7I4tsiA
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=69669ac7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=k6xF7XjQb-CQ-97lgVkA:9 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE2MSBTYWx0ZWRfXwBFzYPdp1jtz
 Ys38qVGbs9VrgkHubHdyqztdzWtQQqjDLmGsvm5XPgi4lYl94PVJUpySrOka6iT5YTf4kiymAWi
 xfGJI/vFyyQG7NM6Si50AT4xz164tCjlpQf3pAKdHVwP0HmpKTXZIUD7mgs47P4s/OMwBs/KvkN
 29SN9uCNcKJuZ62pdVIMiLE8WNtkPmmgQbYLTHirUlQrHKJuMcppWkrqnC53eKjYrRMrHxEfgFm
 gO6zdBbE+j2YZsC8dXMJTGECcG6ifxNaICbizwXbA3RFEv09nADxyRDQeFjl5OnwOQmOkxiB6wP
 WiEXy8mV1PKbPL5hWGk+Ru7QNrumuGbGSZxlvq4LchM5NldnoogLosGwnAtfPWQUtqZGCVEwICJ
 oRsRvPLNk/sLjYvguJ7YSYDJJS3nnNFz0Hvsn/P3VZnc+u8zvbsNa/i+YZb/LJSJYL0opt4mwgs
 8LxWBlcQcezb8mZOc5g==
X-Rspamd-Queue-Id: A2B86120004
X-Rspamd-Server: rspam06
X-Stat-Signature: 8onpipk7ku5b59u3ffztyroigrpuziwg
X-Rspam-User: 
X-HE-Tag: 1768331988-739653
X-HE-Meta: U2FsdGVkX1+SY3lK+b1CFF/3n5GjehWeQZRywZq4PPmXZL5ynAl8s0tO7IJwjz6TpAlqDIcH5J7hgm3z9oj63c8DF292/DKEMaC5rnC26BEGPBNXbIyrRxfYGMUjKgK0IvexO66EpztErzm77euphXBqfw+Gx4CvMRWXdFfxO/q5hCoh6yyjqcIx/DYrvoTpD938JdKeclHdHhY50UDTj5LqwYEr4gmDPrAsJJp2X7oKQaXS8tfIXb2TwBTDhcaQwZB27G3aE1I7SCWje1fthsbbu/E3HY1FohkXm+cUJZF/i+cQPCHMuBm/cbvatCEMqWZdN97Bc6GQBCu5DyFvG+xrPNxTi/yX5Fm+23Q6RR5nOYFhft28lK3+tVya6rZrNkZad6QywRmD9X190mbvlXoVz17Zi5Jf67wcAcpMY6KX9I0vhkUxJqjMJi79mUZfGZRFsI2dD9XeOET226CrV3dN+VjYnmlCkPqpf7bc4zccpu+NrL3eEF3XxSOuxNk4NSMOGE150GH7VsxK3IyVsONqwwivuOOuzL4Y7K7xz7rvg34/9om4EWcM82GIIA+mCyJ/TTPsSHo25tWmpgPQRJVvme3tXpNHPhSiAZK1Dy8vp8PQdFm4nmpya0unORf+9rjdlGnTC+xYXgMIWnPkM6/DqMdmiNFBNCoXGtPIwAlqEBypXHDJMvdpXFBaD1J5BMUZpfIeNFqWHayijUqnazdPiQ8nVWHoTDkpX08ACMUPAd0y9ZcY69Nen7AxtNpJzXst+VNQlGy8icKKJ/Rpz1ecxh+Et5t8u8FC5HGsq7l5aplzvnaLYu1TDRi6XNnMGNuUSaEANyefCD/0d7QhGUMEujf8bCdTEj19AKtFWlpdtI6wcL3HS4BTC/Dl7Jct1tioboCd1yNpmJCwecezFjbTQrlH2KRGcGBdwVmhF1xqoqaJupRJeXCl/pBSEy6X4exN6ZegRY6OGVyOE9z
 CB9AGXSw
 cQwyh4JXVkY2kYmceU+IMmalrjkgnDDXdluPVvvJMY8nloOfiS+6Njn7mclyoj+JdaGmUjBZJaUO6ZWaX26IlDI0NUZnsFvl+g0dQ4mAyD8RPf3+WIAB6ymrG6NZuoFo3lTl/wOKyEgs45MvGkFT9SI2b/EMGwGfeC/hidYl9hKs9Wc5mTxBuYNaYDKK7ln4m8GjxcxwSFsSLjZRuyWXZdk0MiUfgaFKJ0+wOzByogUS6y9/Z70EyczMS1KSrUSPWcn1zSFNBWBJKq9JqV+eOS6vut5i5OHdtNXdgJBCtDhc623HQWk6E9J9okTw2mF2G8XZB0L6hfK9QrgBPAmFHw0inrOCgrNOFjHQ7u/WJhzgAiDqY1pgVUAP8O2Fz4HrrQGOBuxUscM8OryWtU8QZEBSwP35IXCO0vZMGazeBodjwf54+TfOJlL2/6uzXcXCnw76AAol7cyr/mzbS2ZHf7zUHnfab3M5MW9Oja2w1/zro9+9DUd07KvvFoM1bsXvSElzSsflfgJzwm9GDf12zmPNIfiqvDGw8kK/4khtBO7hUwZ0A33b3dJJJ26zxxUGGUWGtbpbcZp/dlbiQVvkrI5zthfegh/AbLs+9L7T7lGukE5CTs8VquV5l6umultGi5IjEMw4z71L+/v1eA7fkWzN91BuPdLSgS8X1Uj0e4aVgy86qBSXRNNuLkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand <david@redhat.com> [250911 05:24]:
> > +/*
> > + * free_pgtables() - Free a range of page tables
> > + * @tlb: The mmu gather
> > + * @mas: The maple state
> > + * @vma: The first vma
> > + * @floor: The lowest page table address
> > + * @ceiling: The highest page table address
> > + * @tree_max: The highest tree search address
> > + * @mm_wr_locked: boolean indicating if the mm is write locked
> 
> I'm sure there is a good reason why we don't call this stuff here
> 
> floor -> start
> ceiling -> end
> tree_max -> tree_end

It may not be the tree end.  The floor and ceiling names were here
before I arrived.  I think the floor and ceiling comes from the arch
definition part: USER_PGTABLES_CEILING, for example.

