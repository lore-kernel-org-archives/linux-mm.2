Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46F5EC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1756B00C0; Wed, 21 Jan 2026 11:57:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A51366B00C1; Wed, 21 Jan 2026 11:57:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5306B00C2; Wed, 21 Jan 2026 11:57:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A70C6B00C0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46FD18C65A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:11 +0000 (UTC)
X-FDA: 84356576262.26.8D4C38D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id D269A40006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sCaTEmlY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iJnR2Xhg;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014627; a=rsa-sha256;
	cv=pass;
	b=1d9q1NjX9kBEeFuXuggc6TfYPqoDuKhUteejwxTbu1lwAA4H50E82W3D4dXv3Xzg411YOD
	lkhOlD0Idb7ruPsRpKx0qesiAx6aWCV9BT590YL+Jps/XhuQ/5PMzZV4pfAM3o+lljd2ut
	gu+wy0eZZ/KY3STu4KrxCS/34s657Xg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sCaTEmlY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iJnR2Xhg;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m31wVm3xrbms261iI6YNla3eOFHUlW1kVlFsSJ3MWFs=;
	b=RX+nogiyeS8/1EDQ0bNxOKC+1DRvJ0cZrve1UhyY4gYo2ZZAWN7whAxsnj8BMRS5C53y/L
	REzu3gSmgc71tJH6/NM+Vk3QRaNY7XHSi1gtbs2VFsyal7tNIfJR06PpqMZBWl1ozYT3Wv
	b9FU/h+XzwzKMeVPfli5Ws1jiMRhfM0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LE6JZM3418790;
	Wed, 21 Jan 2026 16:57:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=m31wVm3xrbms261iI6YNla3eOFHUlW1kVlFsSJ3MWFs=; b=
	sCaTEmlYlDwUpOPtCV8spKgQ4GIG2//XNy2xFDCDtaYiGdb9mx1Yly77D8wUEMXY
	yBakl9bj0tBul8rZnrjzb1Jv5J8wGoFAq6v8tss6+coH2TgoBG5ko4SUDTCiOzi0
	vtmNINdJsVjblA5EeglCXM85kP8Lv9ehzy4BNg1+ccKsl6dZt7y8PGKb+6sPOejo
	n1TtYEScXgUsExCNY0mWQ0ijiau51E344jmP6Fy22GZsCBZZ3KEn/Ji+/JXNvaj7
	GzlBfF3LzXpLphsUau/19daweCJPIPPe6yHwZ84egeMDIPwn7UOF/6utrIj4Gwwi
	L1ZqUT/BZovrkpJFMxaMaA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9pe6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGSYS8018292;
	Wed, 21 Jan 2026 16:57:00 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011028.outbound.protection.outlook.com [52.101.62.28])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbhgmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mtGIAizqq0j9q6yHWWWncXHJkcvi6T03oYxdCTvVvkbAsThTxkWybXWiPJoZP26J5G5gWDQV7HjMlMDH56kiQY3W9n9RJSebjf5kgl5xDkhcpTZ9KuCWgbTILL+xzoat6F9XZO1rF4Y7/1kcqNDyoVfiz7AKQjzX3kPc/gtGKJa3cwUcyfMAwcWm56f3Krq/O4byvGWayXqZWc376qRK3NbCCEuJalA5U4pDlBsrXZ4jwr9wAC4ZOcHUcpa2O+9Ht/iXsynTnwSXhbMkRZftwl3biYl3UennQ/W1dp0WyKNdRnn47GjPqS1+/+5WjEcaPY6NNKUaq1VvLEO0cEbHWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m31wVm3xrbms261iI6YNla3eOFHUlW1kVlFsSJ3MWFs=;
 b=bnor+quQ0O1APOXWykTS4Wt2q+DwMdNo5pfoiJBH1ZLeLp2xdN+xXqz1f6cKyo0ZTgHsdc1KxswZMTBrOKdhxL+6/1ZfTAS8oYkyauRNSkI6324vCk2143fYsz3ReHqQVkPl+wfvapQ4/0hnf/H9NMSQ46v1NP7PgQpIWZHJbAPdD2HEgA0VF5wLz2Y6iAGf9/PowHRjMrX1oVmWhsjrLgIisP9PBbUOiOXk8vCc8SZPe4ol8TPCoA2E0aLX5KRISU6F83xst4YAhxzmbRB053NWVy7LP+OmjoLfWyfXqy06c9P3o+SSPmQws2HGsUtcck2FHhVg7//XUub4UY/eNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m31wVm3xrbms261iI6YNla3eOFHUlW1kVlFsSJ3MWFs=;
 b=iJnR2Xhg4H6GSO+G8NQ/wyR2Rk/tsSL0U6ACAQqH9FhHPXbbTJd/L/pI1/O048E0qqxGBT9XWzEfR2+v7VsGIF9XL4z2sp+16vzD3lW/VyMQQH6KszlJLr8fj2s6jcgfEwVoKbAKvcSjHerWLNyZds9I5cImnn6MXtIRC2sFTDc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7712.namprd10.prod.outlook.com (2603:10b6:806:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:56:55 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:56:55 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 06/29] maple_tree: Make ma_wr_states reliable for reuse in spanning store
Date: Wed, 21 Jan 2026 11:45:03 -0500
Message-ID: <20260121164526.2093265-7-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0351.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: 79fc62e9-126e-4802-61d4-08de590e152c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p+wfIkiYaw7rsFcb1cOfAH/cbVMVkevsMRbd5uZ8XRwQFNJmXwlZCxRtQop+?=
 =?us-ascii?Q?CVXw9b5zd1Xr20ObBZ8E92rYniKSjdXcYbH3TY2x0aCKDvCVsrwWqtulJKUL?=
 =?us-ascii?Q?fdxCjJakEPpkgGzlMG1Wui8Oo6iDeHBHZ7eUaX9llHITs/Zl8vIoUZdQ3xuz?=
 =?us-ascii?Q?xbR5ox3QT3yLiGRCbJHRlmy7g1KzFNR9SID6RCYHphl44DoHFguLQiO2bl2L?=
 =?us-ascii?Q?WF6uA8fW70O1wozfVewnLDBQXu64VZVDqB7NYkFXwHVF57ZEYjr6IIcVbaIc?=
 =?us-ascii?Q?ShEGNov1LhcW+lVliP8L2NZO8JmL3zGpef0gj4zymZoQu7YSBPA5G7FXiS7p?=
 =?us-ascii?Q?ndXdJF/8fDnxX9KToN/APWipcLbKrl8xrnq20oCN1p0kRvqbAHFel14rLCfi?=
 =?us-ascii?Q?5R+8kf5F5sMG3IUyINZASWtX7lWvs9eJIPPlLNcR6JSQVdTsRHgDVOfgz3Ne?=
 =?us-ascii?Q?z9yxHfyxFg0M8xhMDUk1ErbIE0TossWQ1ZgZDz2FVvKp/pBF417ujXqcDZX7?=
 =?us-ascii?Q?JOQQmINNePVLUD4gx8Qr9znp7nQdpnVTfLmA4L3EbPjmOCQFAo+MstvI98rx?=
 =?us-ascii?Q?+U5PahWDbvlGSggOx71iHhhHi3lJlBVBJT1FG7Hfegd/hclkGYTrzYhCkwVt?=
 =?us-ascii?Q?9oUaAZuX0EHLZOrMGra4TgGfs3XKj3hp/2lubhQcDCD7k0aOqd+gd4uw9pal?=
 =?us-ascii?Q?apldl4gIWKTuFj0PlZhhVxQhGcrdp/dP1w3Az8QVqaDlLz7+rClZXY2nHkpL?=
 =?us-ascii?Q?XoAKJZ3Arx5lptcqSQ+LSJ/uao5gKhQsJQFIJM+VEV4VvoVK+SAA0/88xMk+?=
 =?us-ascii?Q?GNJiVkcFdKhYrrwbeeIbm/6JXkSSPmr+vwzQHNwv+TfR1zzIeni6f8qT/x3W?=
 =?us-ascii?Q?zd+0hF2q1AjbQx+nSvLalkvpfciL6B/LatMMwpabnrTU5hfSE3joa2gJPYaX?=
 =?us-ascii?Q?BqMFfgLP1iBHCqw6s+7jQfuAJELoSuCV7ZgPbS2l4dLFcwmjf7NH8bqt435I?=
 =?us-ascii?Q?WaUrpWAJUcCC55fHGPtt4TsPrGuehJrtrSDceo+fsdsJWpZczKNuMs+LfDdD?=
 =?us-ascii?Q?Dz+cu76o7f1hTCcl4YY02Z1SfF/V5HWP4hrai161iXxB8KPWEd+5cOXmgBVj?=
 =?us-ascii?Q?/1FsfzXK5cgnzeSQMr+1dPN+0qNW5U3AmgRpWVDtg4Ke+u9cYS7MlbnGvhCw?=
 =?us-ascii?Q?M1MyXv8JJ6mO1SRElhoZIldHPGA4bCNHqqgCX7tEUNiLmv75u3Zfzy4PIsjr?=
 =?us-ascii?Q?h2+HiyLW8Utf2bCkE3f+GNdONHt/F13vJcaqwfAFRajnd8JT4fxjaPpPH8m6?=
 =?us-ascii?Q?0VpjKdZ3KTsqj4Ykz3LlhisOEkkRCbVXwyxzLsQgPKj1Fzp8NpacOj7sM5BE?=
 =?us-ascii?Q?zGKzU3NJpLKCEwjHRtWXY3d4Xsswcd0AdpIhztko+a4VqZD1rBSCks93LNFo?=
 =?us-ascii?Q?w9zW8GWSAOPvlhLFAeHWV+Kg2nBdWgcseUx93eJTAYsx0tnAgRSE4YBhwF5X?=
 =?us-ascii?Q?JqqiPc8Q++4+DAnVJSC9+OfiqoEtJhhe/h5+DacoJVYiShZULK7I7j9zZY9P?=
 =?us-ascii?Q?lfP2zvFYORrrqV6BnBc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lmrlGLuhF+XZ+wWa4Mrvz6lOG7Ga+6tNqbPP1VPlQG4vI/64TnDhySf3CHcG?=
 =?us-ascii?Q?zwmaYHO1/g7RykfR37ghEnVXEogkwRkEYsOQLroB8M/YHRJTlwYHP8dkC0vd?=
 =?us-ascii?Q?QrjPjsFh3B9Ct+SOPJN82GoMLmjQRi4zkMg5EZ3b7PN+rN1UD5tdT0HXWsrY?=
 =?us-ascii?Q?y/XNmDWMf+HeWVAZsbIdY8gkKKPTEcTPb1LpwMPzGTSd/REjZJu/6GVHkGFL?=
 =?us-ascii?Q?mimky6eRWwsUiT+HKMfqWHAxb+05X58qiWrStpNqDbzAFTSI4/nS3UFjEITo?=
 =?us-ascii?Q?r8cchBiYG2ekrYU1ug76m7bjlYwdyDGMEjnHzlKBBXqZaw9x8KRECnhs8Ocw?=
 =?us-ascii?Q?ApNWQqpfhkxlumX2ftaWkyr301t8Ea32rTzHn+ZXN7zBS6OaFNTpfXwyUkpQ?=
 =?us-ascii?Q?1iVvmx+CGAxaCJsNndS0fsiAW7C6Tm6W06RoBtzdBuj2FO7O+n+0SaY+JNpx?=
 =?us-ascii?Q?HF4Q9hOBVYImHflzhAm2lhjxVj5LZ5We7pVwsKO+j7pxljoqCeZWKTD7h5bU?=
 =?us-ascii?Q?vOWdbccvD3MEvn3Lpix/09l2kIEoaWqvZO7C2caf79SizcC4wQrel7xQ388A?=
 =?us-ascii?Q?hvbqpEbixQpRGKBLjQ5L02SPliO+OE+oSx1Ylb8iBEHC9DPe7vMxIlbmwlkF?=
 =?us-ascii?Q?1ych/POAp0X3AkXBVZyVLFdnOYlTgVu13to7jJsF71dl1ELIYijX87QQuH6N?=
 =?us-ascii?Q?7mKKChR9BB7sraQ4D79mjA3v53C/pej4xPJRaFp/1ZABu+L0HU6iB7hLjgJ2?=
 =?us-ascii?Q?sM863kzrJfDWpGKB8v9J/7EOihK5d8SgfBa9tD3QhA2RmgnaBJWNkQroymbr?=
 =?us-ascii?Q?C6YlDLvf/rcM4CB5zuzAUB3aQ7S//kjpTdRfUu8M/sd9w8Tc2nB1144ofMqQ?=
 =?us-ascii?Q?aCZyI1AsZCZJq7KSVmPIbkVICt/Fk8HyIun39muPwgkbLolIZFV30Kj9VFCC?=
 =?us-ascii?Q?DEyi0O0EtwTtBToFyFZsMqfBTo+s2UUjAwbu33l2OCkfde+qMnZ+LLdu0P+S?=
 =?us-ascii?Q?VcIhT1gyl22PnfBSNz9wvoL8jQBWJwpNnHLcpGW+lgRktUvKUpMDQNAQm+ws?=
 =?us-ascii?Q?c69STVxnn6uiZ1Z1TeTFSc/Aqbfr6WWR0KNOYQXrGlAitjSKHF1loe9/GkOs?=
 =?us-ascii?Q?qjNq9mKcioSkeDHpCaxJC3H2fH/z9OkVHIsQxwomw/1ETMWQx0LQIea1To2t?=
 =?us-ascii?Q?OZfK3LvmJravyhWCVyLmX0c4mEZaINLF8n9tuaHVGT5/3JhpjwX1YZUeqFQr?=
 =?us-ascii?Q?7msAvV1wWEGTnqfGyrrtdI7iotg18hlsKH5oyqbvnTsNHoYKeSKVnQTo8tpN?=
 =?us-ascii?Q?5JcZJ1dUMvYHVugR/1WY59ka5OdbgGZyQj3yuGrNB9ATMVv+n3SD7SnDvfC5?=
 =?us-ascii?Q?v9PFlQxx84+bLrVzPfbcEZJJjBJXyY67EkOWS29XrdmjGLj+gYyj7xb8JuI9?=
 =?us-ascii?Q?+iu8stw85gdOAzAlqNSnfq0cTKrw6ZYNQQ3p5iRVvCnBvjlfYvnqAXJVtJDy?=
 =?us-ascii?Q?XvyRKwZwZxjG6EyqPL6WbmuuNbpyTC10fLhvoHyj+cxdqXnbVmeKDFdx9SGt?=
 =?us-ascii?Q?F6k5PO6NZG/sboMLtdlqjm8BJSuEf/Lo3frWVMUUuJGBYvId/dWAjBsrQfZT?=
 =?us-ascii?Q?e9+cTcEbiinjVZv00HzfcB7cm7DcrQmGvE8jkGFro+gMNepUYZBshGpfoPHm?=
 =?us-ascii?Q?Gwl/LV1mOAFXwE/DEJrCuUjr9qePUcAxE6CTTj9N6rndQ0v85JJ8fouMi1bl?=
 =?us-ascii?Q?c9xvDDjiXw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hXt7mEV3GEknhRLf4tztwVfD/mp/i4Albx0ynD55rX2DIWYW09wSn7X/Ctum2Mtp96rd/MXggU7ANkU5J8pExWy+GQDjAlB0WFn6Ks9ZZqdUw4M4qzqE6DlhotTlxif8rnyg5tZe7JJ8/KK/0LiKGVVnOU4+o2zeaelzWNxzMkby3mPU6po0Fhin5WtYocOBO5CTtjJ0hXVW2/lzfN1RAUogToK/YDR69VSiBm7N4MNAR1pk7XiV1gz0ocefnNS+XStCcqWBG7B3+HdrlLW1HzrxohyDcyJ/kfe8SCuQkT89aMrNrTmlBTh6iBweDMf8ZLherv26sfNUPtexCGWW+FHcP5XZfpeM6Q8winkFka0TIJkt1wZdB6lKpO0PpsHPWNgWHD+9PD6CIXEWVW1jiHvMgqZNNHja+7v6cjpRxhzGTd6iE2pA/nhMmnAE0ImOULXpJ5qWUHbeNpLbZ9eCvcCfRFcNuA6VRPo6meRuRsZYyZF2PIsTAZQ5bDpoh4NwxkiUldvQzcvF6PqlEXENAkZOkGJY21kIndzclWYgnylhpq6u0NWWC1HkJ2TadrjEiCqGkVtYfu2o3vfXnCDvRB9fRCiqeI1gCn/aMSGX940=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79fc62e9-126e-4802-61d4-08de590e152c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:56:55.3658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ow+v1RhPZYkBZdLOhKN+NN27b8IgPdRaAbKZ+HLErg2vsVfvZHnljf1OFglLyL3KmJ6bNP6wxGGpSYTTfhVP5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=6971055d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=gTX0PQgR-87UWUccDAQA:9
X-Proofpoint-GUID: EeeuNoGdNr77tKLZm0B-u8cTXq796_a3
X-Proofpoint-ORIG-GUID: EeeuNoGdNr77tKLZm0B-u8cTXq796_a3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX2CE5WNxRWdi4
 HceZOUaFLlyHimrma54BJHkVBMbxKgvOSUWkqBOGWYwJXo3e6KomZtU9KEFHvLtJxBUa0GkdYq9
 jTCXjdBrI+oRzSVV0Gvi5X57Hbopv8LL9y28rWKPsMKIL3ANgAsnpZAsSfzcGxO0UC6qdUNpgO6
 TfLf9x0orNA5sAofWcQp814JiZkyANiVf6/cvgj7Mv4fwKuu2a4ioF2A+goSLz05vML5Gnc8QZl
 ggHqbSzNIA5YaM24nqhuRMjqllw/1pVlQ3vTxOm6bZP3bLNU4OSCQbLeB+cFLckGxuQRA/cGcxK
 MxqcadgGca72I0xT405s5EbPVr20tZ2CQSUg4pxAIEwVQEYC7AvlWNOcYonoipsd2wG15CZ2pKJ
 oFzdnlb6XBus7+K2t/hb2r1lm1QXsoCLGd4elvuTf9xGrjE9dZJxbFShZ47JjzBtaD5ly4M1YHK
 J/bK5S49krk7wixhrXA==
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D269A40006
X-Stat-Signature: dwh9zjg4s6dqxkius9yaih3y77upoqhn
X-HE-Tag: 1769014627-326620
X-HE-Meta: U2FsdGVkX18zRniyfBdsy5k4/QPcFvLO1BaT/g063RpfXxSYxsiCK+mg8KXdNb51jGFLq02jbrV6/udD4UR7FyEb08/TmrpuOlwog7ZxzxZIn8e4IFj82fkHPrBHnl5L68q6Y2EqhP0YG6uc66FIgiK+Y1+LHHYX8JbqTtP8EBLJ4hkJwqsv6+c6jZgxgU+oRC+5hZF4TfwsPLRqTY0q+wcEULtw11oxblEmmWlnJnUrmgfXdxqKROUpHBrEAIQaupNc7UIe4VOt5Jo1x4Z+fh34yBhUhFrGe+QAvTwMESl+otYSnfT3aib46KV5F7z1cy43yoB86MSKTElmRQ7cFWc4KWIqVXXZYl11bEf26umsHyl6wpV9qxXDkBeBbobQkkl9iIJrAQRGnXQgOEhx0wm5PeM4tmE68aTuhK2NjJwyBfiBv5pJ7wYKrRAkXKuj4F9xDzTPh/+FQwjfKQ+c86RRjkwKPaRuWfQhSFBUDkZH5zLVDciLcCMR5B1zAbfprOjFf03kVhkIBeo74eZ7U8mwcjxG1wwVmyx0ZNY1UDcxrdrtSPVZQRSgccgmoxLUk1E900uaoOAuMwR9/G5ovj/c+0gbf01U4H64XZ5nPpRY9luhg4m4MeK+OCWEoRQfmVH/QS5/OQrR+3Wx23GEJFyKBz9DbifpzV24Kur63HeQ41BTgA4/ugvOK4qkRor7rSZJla0qGB5d3aI05lqkL0SEJizV3QpDlkurDW3GgYhQz2A94wVxT//RiqbNaFv5MrHpWeRHk8Hfu8NBaeJ95FEkm2PMuBbsDUgvITYk8nYv/8K2QaNd6mvRnocyXwToLTz8lYkKvCfGFXLcDmBMBJCwQo3Y3uLmZ0Xxj3ksJbiEHc3SyLyA7Xk5HS8cIbMtRjaSziT6iOWgxz+QMs2q+VQCahZF5r0GEQbB8BRGSFyVymhCLJG9goIK6kr2gWH+w70jcsF2LWAHf1hJx/4
 UAmPseFS
 Lh1uTTsJN1S+AW6jhaJH03nSd58hu3t8Vy5yhQdEckC6oNdc1FDnGQBf5D1aGc/8iaIaAb2WWFlT39x+yXSB/UxGAsNzNCd0rIl9eWcAcf7PpSBM3zGNvodgUmrkCndI7HN972YqRdUyCnG+TrJ3OQhQnpALk4thZeYzfcrkkh052/RO2Pob85XkoMMBW+dkDp5ApCAjnol5455ZrtH7SI52rHH0I+BqiAzPitQK+5dcwOW1mRuW6ehzlzMdt6qXQjJqkhcbC5gqO1bUYcDDY7Uewri96To+y2fAYp4+hnqI+g4V3FW6wRacp9EjSYNpnMlJF067hJUGjMRk+Np4VsCfHkzrlqNTZVDZYQWqcbELQrNyymmMF3yty7gh7lxPX9u0xQedRBpjUeeWYr/+ugyPLUHqYLIBvQZWz7zHMQ7UeG+2hXBuStfSN+2/xxTwzF6h9qrfrHjQl009dC6/NYgjuEqYjHnI4JCLclyOPgJ03HXEZ8g0OLlQzZKhOEuz/hhejujru23wEeQO/rUUDIXkQ4waMoucSI0H/fE3zWgjXEhJIHraZqcJo76JgM/lLu/f4q/Cw3x+2Z88ZUQcWKUzHlrDHTDRyD2+W/OWdPPjIAmwfD0q+r6RK6OHSORD9sVAUq5IwjFLth7a0MXsPHrw76w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mas_extend_spanning_null() was not modifying the range min and range max
of the resulting store operation.  The result was that the maple write
state no longer matched what the write was doing.  This was not an issue
as the values were previously not used, but to make the ma_wr_state
usable in future changes, the range min/max stored in the ma_wr_state
for left and right need to be consistent with the operation.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index fb14ce4a49c3c..ab14876bebf7c 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3319,6 +3319,7 @@ static inline void mas_extend_spanning_null(struct ma_wr_state *l_wr_mas,
 			l_mas->index = l_mas->min;
 
 		l_mas->offset = l_slot - 1;
+		l_wr_mas->r_min = l_mas->index;
 	}
 
 	if (!r_wr_mas->content) {
@@ -3331,6 +3332,7 @@ static inline void mas_extend_spanning_null(struct ma_wr_state *l_wr_mas,
 		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
 					     r_wr_mas->type, r_mas->offset + 1);
 		r_mas->offset++;
+		r_wr_mas->r_max = r_mas->last;
 	}
 }
 
-- 
2.47.3


