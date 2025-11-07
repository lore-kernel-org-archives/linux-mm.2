Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B200CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 19:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DE08E0005; Fri,  7 Nov 2025 14:12:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE008E0002; Fri,  7 Nov 2025 14:12:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E7B8E0005; Fri,  7 Nov 2025 14:12:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE0E48E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 14:12:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A84D312CDB6
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 19:12:41 +0000 (UTC)
X-FDA: 84084757722.26.E80BC34
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 101DC4000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 19:12:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g+jV0zT0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VukVS+EL;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762542758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LYPN+Fo0Uw4/A6JwFUx45jzyoTdhvTMfzYspdRgIbM=;
	b=efck1sdWpAWuomw36EB/ZEybDnf/R1AXJg1dg9uv+8wNBh26aCzjp7YPQRpp2Od0Z83yZ3
	oVjiQkPNGDeEobdz8ptZBphp3pi45mxhC7sZ1pOIR/L7vSxvVRV554rZlVuwCIaINTRUEc
	TAY5q+2zWoiS2TK/24pF0YpSAGyJ53o=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g+jV0zT0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VukVS+EL;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762542758; a=rsa-sha256;
	cv=pass;
	b=RVQxbp8Y8cYFGaNFwi1yB+yftAD3Kq4DH58fUmD7K8Ljr3NHKhTEIpxMwY/iwLoOpoRaWE
	gbgFWWXRpbVzgBS2/jXDlJ7KS4RH5MeTtZCUm/lgiudLoEznb5n318rpPJDw1TPI6b2hSz
	Wjm5Sp9HXt1gegLQyUrJlmjH5Hzrj6k=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7IVY8r029258;
	Fri, 7 Nov 2025 19:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8LYPN+Fo0Uw4/A6JwF
	Ux45jzyoTdhvTMfzYspdRgIbM=; b=g+jV0zT0RZdJkelK1gxEM9d62zgO9fK58U
	ZA6uY2qV9h/g3f38rjyEErZnR9ib5EOss1vtbrXETE5JARR2FM2bL5TaW9DBO0nC
	JGMte8q0lS7k//0odSbobK0fmHD9/M22xiAZi+c+QfstZpVR/GdnPRq+sXSV8CfO
	DYNsrvoO6/lCgt8i26ywc4W2oY/nq7ugjzj7dfQKZtjGA1+xPl3/m/yXitxkqqGg
	6D2fXttEfeuX6wY0Bg32SpFGj5V86IBh0LLl7AlbqJ+hTmijCRPYE81A+TmO8VYo
	qyJPm7DHiAp6kVdUottvAzyx77ETRl4pvOhm4W6soFuLNS2jYhDA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a9ngpr55n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 19:12:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7HZdQ9014994;
	Fri, 7 Nov 2025 19:12:23 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ndx04v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 19:12:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EEEkxcbGPqqdTKV1mFQUA4acZh1mGvABfet59jd0wRxIaZkLmk57d4VVMQaIz/6FREot5eHSRKInpjVY8HKF2kC0HXv2090mk9NkJEov2yOI8Vn6r8GSDYLXdiP9UFWHNFOHL32EgDwHhIVu5XbtGbD3a2b5OgsBm3P71EznK7SflN69YArTIfyzNsPuPc7LWRIL/GcNHHhtgoFJPYVY8v2teAIxODq4Pcy1sp1li00Cw4Nx1bIDH/84NbdPvTVCfO67Tn4rNb/X4Izw3qrMfqcKZW87rS03Sh8yL4sMy38ah+owoRdDLhcAqS8WeRAz/bPnn5/Fw/KFck8LpJ8KQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8LYPN+Fo0Uw4/A6JwFUx45jzyoTdhvTMfzYspdRgIbM=;
 b=EwGIeri7Nl7ey3e5qpbxzKdWtkNg/cWI4KZ0EOrwWG3ehbHfLi+ADuuCqy57NsMlvQUgNC0rKxDDo7j7sD+fyYeZZZZrJulBwuy6ZhWzBVn0yqUJSBZ7WUBRgVbvwgLdLO+P4xvTXQHT6QXfUfqTQnp2luf8Aq0VsjUyhJQzxtV+wxn6JD3K3FoC7adwX6J9k8Kh/dil3PIPrzvtMLU9pEewfKXHhRsuWYnrj8kocZfaMeUURjhzv4sWdSwha2tKi2rZT2tIGT712IeSPZ/vPvB8D8+MlJNwSXpPaYTIaweKAEyKzXyUa0H9pDIeWpFIIdqtwjl3Wlg77hIC5oGlxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8LYPN+Fo0Uw4/A6JwFUx45jzyoTdhvTMfzYspdRgIbM=;
 b=VukVS+ELa2F3J8RFxKrR6hpZvz1W0QVasb43GD0p6COGtJQdTZNPUmdSoV8rMUnJU7ruHxXfmlWkjLuCmb6o84ueXoxNuR0DDQv1X0vOHWatq8w17pDE+3AeYJPN/4W0k74rBtnl8lECG3bc9HgsTmjVTZSAuuumwf54lH3fzEc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY5PR10MB6190.namprd10.prod.outlook.com (2603:10b6:930:32::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Fri, 7 Nov
 2025 19:12:21 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 19:12:21 +0000
Date: Fri, 7 Nov 2025 14:12:15 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>
Subject: Re: [PATCH 1/2] mm: Add vma_start_write_killable()
Message-ID: <y65tizaazalluqyo6txkcyary64pn2z33v4j5l3j2d5hwrrov6@b556fhbtjvbz>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>
References: <20251103180348.3368668-1-willy@infradead.org>
 <20251103180348.3368668-2-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103180348.3368668-2-willy@infradead.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YQZPR01CA0023.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY5PR10MB6190:EE_
X-MS-Office365-Filtering-Correlation-Id: 43730563-7cb4-478a-0090-08de1e319333
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VXy0CDd1AmsLkPcY4koeq5zsDBL/rUlL9BvS75zx9taxy7PZSw0fVHwQcXOy?=
 =?us-ascii?Q?TxhrXjbqt5gn6rIJAIVlN+VpJbiGm9r18wjZs2M2Tfg47v9JnB+gGbQOqO4K?=
 =?us-ascii?Q?C4YFgXV/dQ41SCawV3mPCLZDpXarqSQh2rODCe/BrdGGGBzAQNDkDozVwh/u?=
 =?us-ascii?Q?282JRLO+g6iCUZUBa864bOXCi+K3jrOmfB6CxhoKFfjACuqa0D8h7bvuL4wz?=
 =?us-ascii?Q?0yqydj4lfTSsYwQiRMzBLr+I2vw79NMmtAZzEWBaEWH0rMs54ab5+co5yAXJ?=
 =?us-ascii?Q?5NN9HtbPn/Rk34ZKo7YZO5YRnK5KYtqtTKwQbmcZsl7FMifxYPJfHwo7KBSO?=
 =?us-ascii?Q?7SAP4zBBC9QphZ+WgvLFqTLvcAP1Umg/vNHxp9DIEDymNXL5VpY2jgVO8g4w?=
 =?us-ascii?Q?odUKhpI1AWUO9FICDuO9GNWsksnhSjFi/ANcqSf47txEqc/xN1cne/axwvv1?=
 =?us-ascii?Q?qv9RpYH3DYysxi3qZBhTMHBL8nnPBVOvZUW4QvgtrmYWt7qy7Nme9Xf12oKb?=
 =?us-ascii?Q?w/p9WbRgSO+PYcCcRGiTfqulhAo32qzaktmXua9B1thd9HenWw/9Elh3gFJL?=
 =?us-ascii?Q?fr+12+TvXKIPj0dmqegkmfTONGitBJPQ/RkX5hnr0MTPHj77KpYb41hrJtJ9?=
 =?us-ascii?Q?Ge9IcBWn9UriDalUQcyA7NBcIesHrkRjjW0JG+pftW7O0LRo9P1jiTXC88fX?=
 =?us-ascii?Q?ebG/EnxiCOYVeTge/yCL2/kGzosn+7r+h5FYdY6KikFwpirHRJuTU6c0U9MB?=
 =?us-ascii?Q?b7wa+LaLTC9ciDNcgwKjERF++PT7FUym07uQA/YPDkEeemZPD2cI6lfX7IWZ?=
 =?us-ascii?Q?7OQFw3lEPhjqzrAUCOt8rs+TCd70BhCKPN5oUtjAgbOEYCFTjAFjVsWwLOC0?=
 =?us-ascii?Q?ukJ2NYi0BW5kMJO9yE2gmAfVLbESiir8dhDVavUTmR+/sCK8sSuOYcciyuGX?=
 =?us-ascii?Q?trGNEFN0+WiWapdLxEvygKWKjCjAOj6LH1fGhIneawXk0a1G8O5wI/DlD7H3?=
 =?us-ascii?Q?JgPnwPLrhuK9Cph29qUwKR8WDZu1c9aDsWMPLJ9O4g9INVax6H0Zc7EfwVWq?=
 =?us-ascii?Q?tGP8VseASgSUZoNMdLPk9P7J0OIseQj4TrEk8PCNAYjbqcxy3SerPzYLFH6x?=
 =?us-ascii?Q?tnzb79CWpxg9cWhH5tPF6f8ExA6x3JUDw08lvaltdgFsbpJlqXw5LzhfU5fa?=
 =?us-ascii?Q?sY69oE0UeRS1fAzuj+3tiHkwAO5q3A1TyN6BFKtPfPK923bZoErk5kO3j70W?=
 =?us-ascii?Q?+PGbB90PRzB8Ov9AOCCz/QgeVn8EMGcRUcyb1QArv3J3iHVyylfHZ7tw3Ix8?=
 =?us-ascii?Q?o55F8bJlkcpAMPi1Rx6AmsCW5sv6L1uwAVa0P4QGwbFlsIHL2YdU2gjswDUI?=
 =?us-ascii?Q?Zfb5WRJYGkcyXbmriTrPFM6E3s9MwG4cq+SiqMckm/7AzVjDsTzN68cIxSw/?=
 =?us-ascii?Q?pkgtfEYVdUusK9eTCbXaj/872xeWCumS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kVxQehKXC7//rA+s/uxCL/gySCrrZiZEexsmfDHg2XHZN617zYdYZQFFA13e?=
 =?us-ascii?Q?MEppBssrG+3AIjHZJkKlTlgEYF2/B1f99DVL6raX9gciiuM3ekrJyF/ndBEG?=
 =?us-ascii?Q?5VgaUO0I1iOgncURih177YrKOrWsXN0uNv5LbVmyXbg/SFbkdBuscZilSLb7?=
 =?us-ascii?Q?jk5C7LkL8iHIswN7tR/dPi1tobkfUMuv0e8K2a4IGTD6dBSYV+TqS40INdnJ?=
 =?us-ascii?Q?gjmmpfIg+ygG6VHCWxehWsb2zwtbdlPxARvbS2NVo6OoVhPlQYYd5JGRLSov?=
 =?us-ascii?Q?06G21GYD94txoB7usDJkALN1wmSA74wCs0BDD42vMqHY/Ol74Espprww6ZKc?=
 =?us-ascii?Q?eZfcW2itIiLBTqWKEEuB0KTKRDFvfJPKeMbP/FZfx36WQNYjfP10TfEZJm+a?=
 =?us-ascii?Q?ncRi+jPQANt4aKAQGQXEq77TrK5TgwXsfLgp2P5gBP8mG/tatf/jfuGZGTBj?=
 =?us-ascii?Q?AJVLDwTBZCPhiywCvpRlvLZP6tB1ft/8Ii6gJLmEshgniyxUmOq3O8lZBcTy?=
 =?us-ascii?Q?3NpXZ0maDn2FJRUhct/TDgdI29CIpKFx1Pn6f8BFKo40HDhAhHA2ihpUXwKb?=
 =?us-ascii?Q?bKMCrQ4wybZhg/zE0MRb+A81PxhE2+49eGWQMbhMPIqx02orkNsMBmwMfWTn?=
 =?us-ascii?Q?DnZBEGGaHaA7KemWzv/3bsoP+xeaGcb3hgQpe8BalYbN/X7TDtA2APust4QA?=
 =?us-ascii?Q?BfB6WHYEvOMVq19eaD5OPOWpUAJRhAY8AnPUAaze+PaL6I+SJZUqdn4xjILI?=
 =?us-ascii?Q?Hv10ijTaqXiz/DMSUKm4tncsVnM484N89kMP3AhxaXwJYpig5ReDUnlBcQ0Y?=
 =?us-ascii?Q?GQHOwaehDOYEWisdL9266+ZNiQZ2aJzfOllkVcLPFhC4rQLo3W+sbQj2DNoF?=
 =?us-ascii?Q?P9PeEG1naMvW77X6YUjx+m+8TRwI00WNG3jqTueuX/1W68SPVl6kXNZ34bw4?=
 =?us-ascii?Q?o1jqCwDyVDq77hGwN+QVhjlt1O1zKvITly7nn+SdBpXGBounPwQJslqrjk/I?=
 =?us-ascii?Q?JgYU5Qy2ka3d2vIBkSvz7zS2a4eqZWxD3k3VEz2X6dRu3L6YgQqraVkFbQV/?=
 =?us-ascii?Q?GsFg9hxAMC5njvuHp+tGzvDq3sgt1TPyaENkgjUyZ8S10cOCSVsTZUAyjD4d?=
 =?us-ascii?Q?7UxJrwWk0is9GgfXnU8yEdtxUo9avf0vcOZSLFm3gAXt3R7wC9b5klopBUfR?=
 =?us-ascii?Q?pyPVYaNWNtSgEQE6Ve/HqQuE1iSo/r4dKZBJV5TdFD5AGIIxsCxqHWF8Z+Mr?=
 =?us-ascii?Q?wdyQQvGv1/2R92snfBwH+XHd8IXfeTPTivIq6h5TFVdcLAAINeXzpmmR4JQV?=
 =?us-ascii?Q?0SeLeG38wFXsuvprrWw4G0qCX5DmRtmp/WZk6UU8Q0YLrZZS3fVl03iDjdN1?=
 =?us-ascii?Q?cXG+X6HK0PUFuGx9yasoHghuP6i8nsx764paAf8BxEAieB2X4M/Dr0NEUZ2D?=
 =?us-ascii?Q?H0m+dwPADLQgiXZ3HYy5kmH2xpVlr0dL2Gujy9vndqFQaanIASui+100IrW0?=
 =?us-ascii?Q?Njqm4hdgNxd3siyrcrBIZ7uVIUeLXE2L3Md+eRk2tIkc0I9qETA/IYB4Zp+j?=
 =?us-ascii?Q?bqt5hPZPFjIGTrDchjMb5Cu1s4WC5GO+SjobO6BVQ5/vtRJkSF0GjgxfmEs1?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WSUxDRGXOhyOXKXRzXKbudXac+wqXllxjpJJt4Jy8C6jCex3HRyDiqDNKD1P7s4lLx6MXrPbie4snBfNTvJtSQUsiXsfbCy4Ns7AnP3pHi7POyhqgVBy9RUBnjKOtSxy6kEraQbIEDwwSmER9aXgxuY5L9Fzma+u3qOjmbg8uIlvhV4VCGH/RQmTweAUT6nBgtZwDXFN48ZclbBw0fH18pqYs/86q6EcgWtB3/NpCf7zC1Agdpagj75pBg74pJ4peamJskRoari9edINrJ8Fw7sBryyhyq+JiLB6gY52BOUwi8vAS2aHqnZmVe0yxj+E/KDZEKKS3UrrgaVXahs6Hbpp20MG6epA1a8QLqvdnfnXXr/4P/Xl3pl+lctAP0ebOOunyULTOXVNGlFcDNZ28RPzElhYo8Lt+EIi88jamMk4jScjRt2LDuI8Oolu49drK4pUvp/1WesBG3iJFi8+aLA0fmODwHL8PqyYOegDhzGDr5GEKUt1pkHFh021L9UmMa2m99UY05PB/H6xyFwkdyakMU40mEuoAMlcJ0+7j+MEr3kroSykkhPCSYfw6Nl1nFzUUmSWYLXvQ8K+lOwzMlK11bO3In/xekeOGgdk/0w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43730563-7cb4-478a-0090-08de1e319333
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 19:12:20.8793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gr7h/6XS8ytzolZzzKRUT7cL/XZsZeHPcvIE5b7POBocDJoYpzIPPWS5xUXEEN8VNFwSEaI3zDLieJjtQ7MAyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070158
X-Proofpoint-ORIG-GUID: YhKl-NW5eqDoimkL18U5HvrVe2pMCtzQ
X-Authority-Analysis: v=2.4 cv=dNirWeZb c=1 sm=1 tr=0 ts=690e4498 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=qF069GrurSCo1xh_kLgA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA3MDE0OCBTYWx0ZWRfX19MEbiBhVCct
 fhO/4Pm0d3ikcJ7NLlB+hdWWJuX3zR9eliErhLquqiqnc86B+XIv6T5rgpFHN/1VQw3s4B76NCL
 iEpDrDEFx2xWtLpCt9xr+whxevmE5cr8rrB++w657NQX7mdIpkidlvKIJUHu5DCGyJpEiK3M9Fl
 OxbUNh4ENw/pG8WQVVkWXrTWh5HSs5vVA9VZBSGlJUD//4jFHJx0MLJdRVScN8Dt8GI7AjsilM1
 wLhCHprBDIipEqTuqEf03g8NH2uDBaUgugiPRw8X8Ml3jB1wrlB9TOdCTn7SivyyYNyShsHYTpY
 2vpFHirITId0nlCz2LomWs1+UOk55BRwJUK7HVDmGhT2vnCSFr/XUmMwbDIei/YCMYeYtHZJd0x
 KC1OLqbrgj3jaXvBrHMji8N2KN/OFA==
X-Proofpoint-GUID: YhKl-NW5eqDoimkL18U5HvrVe2pMCtzQ
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 101DC4000F
X-Stat-Signature: cc8efzqi3qx3uondnx73fwd358zjegt3
X-Rspam-User: 
X-HE-Tag: 1762542757-994409
X-HE-Meta: U2FsdGVkX1+RJB8lBLKz2MMrmR+S0CzdmniYPQagZ4f1QO/KUNT5Kz4J9QmfHqaZbmdKcA2YgfFZddO5aTnthM+r8IW1AqGzJgVVktsS9eDpyQhrFggcKy25JlmHUVKoMqxzphHT0rI90g/cVISqEVAe9Cn5OkQRVrQL2qtguw++wajRy5STgaaiCkfh2iD8T1U3usDDRhJTCm1/Fu9XSx+z2z4b3uier8alt8n7aYyT6QNzk61z8AFbMbWHd5aVwZVMtvS4Y6w+wUb2sSG6rPcYNYaOExlUD8mRjqXuQV5Xwq68/IUrp/he3Jk1mbDNDfmDouFz2iTqsJWmTV0I/nRDwi/8zn7YLhkaHL2EybfaycaiMr819glv3ZUGFI+JPc41dY1/4fsJECKvMeDrDeuiJN9ajxSL+fcOUtjdRecP8RRO8GaCK1B5P7UWbWWWd3SO8xkWrg7jezZQ9IdXIE9MO8ZrmY+tIxdNWYiCEU5wjW/6WMA1l0WB4VaxqEj2pNuGFLEMSsrcXvexPXS6wIaDFf+0X+CzRk2COhbJvRMa45b5HVU3guyFk2FBLWHd45FyLwiEpSSRpzQ3mSB49gRIICwyKYSbmA/ualjXkpLK8muXzMHFttSJHWD70BsULe5ENQqfs+JNaZA7obOQEjyG/c88eTjOsgaQV7sJ+eU82Tnp3I4AIBslodBehPL2EX3whTmvemDRjw+yiFAKhbcy7jpCNrXvYZM8EZ9m9UpN8EDSfpYa/omHnbinZSwWKGsKAwEaak6xh2MgQ9t+GcBd6E1DpYkDsZIdu7m3S0Brxc81+4/XpllCOpphViFaFaYpnLQhLC4/Sv4U98qt35LxzA7jR6J7+ot233h5G6iM51o8VpFoF1p0EU4woowE2ReEAxiT78uhAok0G239sB2TqZ2Zr0lFqvqInMCmRmAYzOO1t67pQTe/er5EwYhz7+2LZzK2LNEkptz4tVr
 1uWg2/eA
 /DHqKWmokQdsag+u6HIpqsn1JwNkrQfrxaqAv6DOAvXgf6GJ3Odv6OVmfW6qbOxuL4LYEqc/5Nq/jXn+Nws7q9g2w7fv/32I9q2XHSZlmJFUbAeqYEZPFtjKexnOjYTXJQz525NZNuKGpEoya9363tWV56ZmoKM56MuOZ1JVtdvT4579XC6y8IpEW6/MF9awXNvgcqGAxtKEcQL2ubsoAVafFTlioCRLuyg4JFS3cz8Mk7YsjBwoH/nwA1E/7XOVapdePsMOEi3DX4wzqvoogU8W49yDlSRKilqsK7jdBeRwvQ6kK/6JziwRtjurB7/fBvmPBHGKwiD2dKkUBCE8l86qpFT7SFPrVDNuiJX6Oxweftc24HfYGHl3yBF4MFh2wv4rEVgGTWSsjdr1NpOVjthcUh1g5YNQYjLKt9TPGIPPhl8+cs+rvNN/NuF5XQEMZxn+kkuASaKJbU5GtLyJsQlLaPl+yfTKJ+z8EQrjHXLp/nKrbIHZt+6uX14c0WeNI2OOZjXPSnMebSBVp3YJQx1Ve5fXAGFexlRcz2R9aoGR5B35u4UPZEj6FeTYRDp58aPO1N4yTviiP181eboGJf/GFX2/HORhue/A647+BHjWK67l1/vUVaWEIqlGIgJvBNWzJEZFewmy5wkqJpO15UBRG9sCudGZLp2/qnNPTJ3AaL0bC8OVCDRmsXcLQGkwCTOLyjq8N8MrLX1Vfk/YxrnKKWhtm4LoiJW7cx88djpzDt3gH6WrjwVdHEJ+wVGAJJM++Lb6qxZ2ccjD9s8AekWTHb74zp+0o7hlh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Matthew Wilcox (Oracle) <willy@infradead.org> [251103 13:04]:
> The vma can be held read-locked for a substantial period of time, eg if
> memory allocation needs to go into reclaim.  It's useful to be able to
> send fatal signals to threads which are waiting for the write lock.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/mmap_lock.h        | 31 +++++++++++++++++++++++++++++--
>  mm/mmap_lock.c                   | 27 ++++++++++++++++++---------
>  tools/testing/vma/vma_internal.h |  8 ++++++++
>  3 files changed, 55 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 2c9fffa58714..b198d6443355 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -195,7 +195,8 @@ static bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_l
>  	return (vma->vm_lock_seq == *mm_lock_seq);
>  }
>  
> -void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq);
> +int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> +		int state);
>  
>  /*
>   * Begin writing to a VMA.
> @@ -209,7 +210,30 @@ static inline void vma_start_write(struct vm_area_struct *vma)
>  	if (__is_vma_write_locked(vma, &mm_lock_seq))
>  		return;
>  
> -	__vma_start_write(vma, mm_lock_seq);
> +	__vma_start_write(vma, mm_lock_seq, TASK_UNINTERRUPTIBLE);
> +}
> +
> +/**
> + * vma_start_write_killable - Begin writing to a VMA.
> + * @vma: The VMA we are going to modify.
> + *
> + * Exclude concurrent readers under the per-VMA lock until the currently
> + * write-locked mmap_lock is dropped or downgraded.
> + *
> + * Context: May sleep while waiting for readers to drop the vma read lock.
> + * Caller must already hold the mmap_lock for write.
> + *
> + * Return: 0 for a successful acquisition.  -EINTR if a fatal signal was
> + * received.
> + */
> +static inline
> +int __must_check vma_start_write_killable(struct vm_area_struct *vma)
> +{
> +	unsigned int mm_lock_seq;
> +
> +	if (__is_vma_write_locked(vma, &mm_lock_seq))
> +		return 0;
> +	return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
>  }
>  
>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> @@ -286,6 +310,9 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  		{ return NULL; }
>  static inline void vma_end_read(struct vm_area_struct *vma) {}
>  static inline void vma_start_write(struct vm_area_struct *vma) {}
> +static inline
> +int __must_check vma_start_write_killable(struct vm_area_struct *vma)
> +{ return 0; }
>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
>  		{ mmap_assert_write_locked(vma->vm_mm); }
>  static inline void vma_assert_attached(struct vm_area_struct *vma) {}
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 0a0db5849b8e..dbaa6376a870 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -45,8 +45,10 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>  
>  #ifdef CONFIG_MMU
>  #ifdef CONFIG_PER_VMA_LOCK
> -static inline bool __vma_enter_locked(struct vm_area_struct *vma, bool detaching)
> +static inline int __vma_enter_locked(struct vm_area_struct *vma,
> +		bool detaching, int state)
>  {
> +	int err;
>  	unsigned int tgt_refcnt = VMA_LOCK_OFFSET;
>  
>  	/* Additional refcnt if the vma is attached. */
> @@ -58,15 +60,17 @@ static inline bool __vma_enter_locked(struct vm_area_struct *vma, bool detaching
>  	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
>  	 */
>  	if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> -		return false;
> +		return 0;
>  
>  	rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
> -	rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
> +	err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
>  		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
> -		   TASK_UNINTERRUPTIBLE);
> +		   state);
> +	if (err)
> +		return err;
>  	lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
>  
> -	return true;
> +	return 1;
>  }
>  
>  static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
> @@ -75,16 +79,19 @@ static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
>  	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>  }
>  
> -void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq)
> +int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> +		int state)
>  {
> -	bool locked;
> +	int locked;
>  
>  	/*
>  	 * __vma_enter_locked() returns false immediately if the vma is not
>  	 * attached, otherwise it waits until refcnt is indicating that vma
>  	 * is attached with no readers.
>  	 */
> -	locked = __vma_enter_locked(vma, false);
> +	locked = __vma_enter_locked(vma, false, state);
> +	if (locked < 0)
> +		return locked;
>  
>  	/*
>  	 * We should use WRITE_ONCE() here because we can have concurrent reads
> @@ -100,6 +107,8 @@ void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq)
>  		__vma_exit_locked(vma, &detached);
>  		WARN_ON_ONCE(detached); /* vma should remain attached */
>  	}
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(__vma_start_write);
>  
> @@ -118,7 +127,7 @@ void vma_mark_detached(struct vm_area_struct *vma)
>  	 */
>  	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
>  		/* Wait until vma is detached with no readers. */
> -		if (__vma_enter_locked(vma, true)) {
> +		if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
>  			bool detached;
>  
>  			__vma_exit_locked(vma, &detached);
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index dc976a285ad2..917062cfbc69 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -844,6 +844,14 @@ static inline void vma_start_write(struct vm_area_struct *vma)
>  	vma->vm_lock_seq++;
>  }
>  
> +static inline __must_check
> +int vma_start_write_killable(struct vm_area_struct *vma)
> +{
> +	/* Used to indicate to tests that a write operation has begun. */
> +	vma->vm_lock_seq++;
> +	return 0;
> +}
> +
>  static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
>  					 unsigned long start,
>  					 unsigned long end,
> -- 
> 2.47.2
> 

