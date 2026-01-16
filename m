Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95A1C98300
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 19:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F476B0005; Fri, 16 Jan 2026 14:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C136B0088; Fri, 16 Jan 2026 14:47:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DC06B0089; Fri, 16 Jan 2026 14:47:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C9C916B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:47:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3263A1A0181
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:47:10 +0000 (UTC)
X-FDA: 84338860620.01.345EC15
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id A0EF8160005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:47:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=quJWHyXk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aNNSyiJE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768592826; a=rsa-sha256;
	cv=pass;
	b=CjkMVLtvSJAf+Ql5ENVha35p9LGssuoWPRbOfH4h5nPokBZce3oSdz7UU/SfPefKdg2W2J
	0YeL8O+6c4LdoHRZgQqOgg0ELrYQhsmBaT2z5ADItWz8vf5/Wic3T8I6TsT/uAWLJ+kW00
	p2/2fkVnU6PhX3sLRpp3tDHKTLq7NAg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=quJWHyXk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aNNSyiJE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768592826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JdbS7xynVwRHjbjikpkP2eOuw5KlSBO30mROCcRJKpY=;
	b=6m5JXQHg5lnZOSFXAwJb+XsoGlWzpxO/vXe68U4EsWz7l+c6ffpu+PVBysH7Dbezx7T9lQ
	TFtvF4wGoAyYP5tRgjPRsjproisgJ7c80zeCD2PbmMXj7cpgIBcd2gKknLI6mmOTOYLukF
	7IEYkxX1OzV8prjTeDcy4cTyzgo0f1U=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GEZUdr1737994;
	Fri, 16 Jan 2026 19:46:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JdbS7xynVwRHjbjikp
	kP2eOuw5KlSBO30mROCcRJKpY=; b=quJWHyXkialcTLQcy6Bhpz8asxL1gl6vyk
	WsXXzOVhoB8kbRyR0L9YSqXg0G2gNdUJatRumLIyJXJetw+mTSGxlh6WFq5QWrHZ
	nPAjUBOr923WDfLeFh7VZ6JGt35cFBPDQMQao8aNxhfFUSgMBSEd4jawO5VU4wzD
	rRfvDf6Ttndfj3mHDF09rzdoZpK3Tes3Eay6VR+oyK8l/y3q6q92Umddy8lDTvGv
	DFPKMMKC+HGnUMtoyi14GhKpD37+0dp7RlqK6NUxS/ZM2wOSy6I+umAjiztzPLPb
	3bYZ+xCgT9SgdydMfXA+mH7lKZEffgmW0BYogv+lAPI0sls5dxzQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntbajg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 19:46:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GIgHJI008138;
	Fri, 16 Jan 2026 19:46:52 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010002.outbound.protection.outlook.com [52.101.56.2])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7d23gw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 19:46:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MaUcdZYnPLfuYslT97BGqOWR+0OmbcIunM7kJjNr1CAeK7QjmVJ+Y2AMo+AaeukSSQ2VkmGRfVTl4HlXjGKFTOJC5Wkth5ABxW0C1GgDn4QQEN7Mm9CSyEiWZguSKVHWHUJM176r0Y9xSwnuGzPAQidg29ywpv5QcRq76eZYXJ5zr4VGOqWY+KQHnBerlEbjoYDyE8tmVUGLPxUiFYBTBMnqadcEntmHaMH/K9eByje9MgPO7DWrT7Gylrj0A9QrMruISxPu1B10rXF+zkZE5ZbWzDoiAB5nPeVccOjw8WZKpTfK6G6uvLGf2D+ZA3ShS4Z0QJY7eDdaEjWlvh5ABg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JdbS7xynVwRHjbjikpkP2eOuw5KlSBO30mROCcRJKpY=;
 b=ZtGzPzMkEnviaXUYEA5EP+JGBBZH5ndwbi/BQs/PYW7DgG6V1RPt+XdhkAr190E73h+ZJlWZFOFzzEZArBeSg1x/v60qcUWma0BY9afWTzpGD3Lfl03IsHOuURrMBAcUDcmCx026Z72MNpHR5UQxvw7g0N1EhD5r4R8tN7viT3bGucsrmfTe3pWNSsbelnReB8w/sp/Ex8Yy4eHbd1MD2Z34cvrMt+vQqrlTDQhJg8DrVKNnKB65KgfS4IONuWmVs4QTSAVGQe2+GHEeMws55KD10rsXpCYRkwWSmFnoIAZ524gimbblF0nr2WSgNMOvo2wLONcz2BE7okQzb01svg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdbS7xynVwRHjbjikpkP2eOuw5KlSBO30mROCcRJKpY=;
 b=aNNSyiJEmzzwdzJbsmfJ5scHdtZCBxr6qLxiTMm0BKJ7MsB6nMLNPt7wWjZ+KrYYwBrj+Uwe1knx8VqWAnUQsY2Bx1+DYRp6uetITmXPb/dD/yipGfp8Hz/iu1/6hQgGB0h2/xIe4fmiHBZJ0gwPTeV63x0+l7oEbmrerIDqAl0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB6782.namprd10.prod.outlook.com (2603:10b6:208:42a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.8; Fri, 16 Jan
 2026 19:46:48 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Fri, 16 Jan 2026
 19:46:47 +0000
Date: Fri, 16 Jan 2026 14:46:44 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        maple-tree@lists.infradead.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH 10/28] maple_tree: Introduce maple_copy node and use it
 in mas_spanning_rebalance()
Message-ID: <m4nmhm2zmgrelxtyhftmg6kkyxexmznyo7khfmjxphkzr37ea6@44ga7yswli3c>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	kernel test robot <lkp@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	oe-kbuild-all@lists.linux.dev, Linux Memory Management List <linux-mm@kvack.org>, 
	maple-tree@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Alice Ryhl <aliceryhl@google.com>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Kujau <lists@nerdbynature.de>
References: <20260115193647.1695937-11-Liam.Howlett@oracle.com>
 <202601161501.NZ3GNDCG-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601161501.NZ3GNDCG-lkp@intel.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0318.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB6782:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a3b9690-b4e2-4283-b9eb-08de5537fc15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EMewMvOz+lT5idcPFUOzkEoZ2wHBuckIvPM5HfXlEJYleIcJzDQ4EeS2ca8K?=
 =?us-ascii?Q?pIE6psCvZv3JpfsbHVQQ5KHyhqVgHrkll/tK8Ck+9Hz895ISBU9NX6/TghRr?=
 =?us-ascii?Q?KYG/qz9aFCFgSKnBadleNSBjOtTP34zSaEvfZcpbSWEDtqLuIO+xcHtGWghB?=
 =?us-ascii?Q?Q816ostRAdgQ90dUI4+uwN0x2q+KEaRfUTCWTN68SQWiiEkSGlF3U1m4P7/A?=
 =?us-ascii?Q?+n4wYNRnQRyG6XzDgK9NIHF5sJgV2tx2tc1oUhcf/HNaYWrZIpSZJ0kbWZA+?=
 =?us-ascii?Q?rz2wKgP5UME4cTquMu5dKfJqkGVSgX20PlfTlmVy+fC6JCr3Q4+nq3F/dNTe?=
 =?us-ascii?Q?A/y1zNTD7iFWQ21V1jUMLkE6tDrPVuheKZ04xZccYBsb9+ArNxzcSc5CgBbt?=
 =?us-ascii?Q?AA5cKgq9DOWMUhz4jYzjLHyMTZl+fJbh2BRruXgSvW36Zgpw7OY8nFbZyQjQ?=
 =?us-ascii?Q?FRpB23rXNHME1n0xCXLis/iEJIp/QtncqaPq6a2gbOhr9N2KZV7Pv39zXK1a?=
 =?us-ascii?Q?EkHMGqU7UIfwm2WmOrAYta2BknYD7ZhZ4W9o+C2oumIvNyeLn8dKIa/bLsfW?=
 =?us-ascii?Q?sTjRh2pNV0YokU/sOrs3E1I9btX3PLTzzF20bwre5SEuCA/f67YgN90RBD2p?=
 =?us-ascii?Q?CD1LYXaJMDks/mDv/lSAMA6Hx23KIOJdZqyK4beH0oJPtdutokJZDwdh1YsT?=
 =?us-ascii?Q?cJlhDMSEq5YltTsFaGjqn3/gX0LQhWJPlON3x1M/7JCzrfyc3FfCY+FZp812?=
 =?us-ascii?Q?jtN1QmzbcxFzJ0SF0pG+de+MNxmUgno0ornZznZ7/luC0ObzShjbxAO8aj7M?=
 =?us-ascii?Q?5Rzi4W37VqawFC6/skV3SApWFGONgEFnjRpjcHlrTsrsSK9VntZ2Q+kd4HGE?=
 =?us-ascii?Q?Am0fFRz54oJf0mGXer6HGQP0txHE1L28G71wYjMEp3l/lwi3ClwpdNwgKcbz?=
 =?us-ascii?Q?8ZNo7kmX+sQMlQAyvdIopCAIugtvRBQ6STZCXkI/Mfv0PufwWhqeflqTCX6C?=
 =?us-ascii?Q?0ZZ4rVOBfn/wCCGyQd86xX1OePJ+adHEHP8h83sUAU9d684j+lKgzy0kQfVb?=
 =?us-ascii?Q?sK8tLlS+stGl9PXCIb/pGDrm2vP9magJvUej+cz9HRdWaRJWVR/4YxcXlQTd?=
 =?us-ascii?Q?7sje0j5OmVkh7cGE9MfZWoRZ6YelsW78sXilw7uwIv21zc7h6td5D0hBy4n2?=
 =?us-ascii?Q?9wETujUnDJOeRHZLmD6E6NfPkKnzjHvCB/ePqRULF7v6d/oD/v9DOaBibfDn?=
 =?us-ascii?Q?ehi6Sm9dkZbEuZDi05gA0QZL+KxTkgAb1frQWYXJOxrqf7o6WottULCUAorL?=
 =?us-ascii?Q?5HauBrE1MGvnuh9F5evKF0JSisdIOHCDHtdNwRkr3w3+XtgvmjP2jBBrR93Q?=
 =?us-ascii?Q?B3Y/Zhf2M3Yajf0NlZG7BBE+w9qnDKmnEjNo05rpOMnqRC/rraadjXgh93LK?=
 =?us-ascii?Q?JjOirNbs7FKbjYYCcVbwHG+uFWqPnjNZt/UFK2fZT2NwSh2c/6tML1A5YeMy?=
 =?us-ascii?Q?v5bzsT3EmJtjPq0ixTHY1SMgvWZF6oeGU6a7TjjVemSL+6udwfwstpEHoSGg?=
 =?us-ascii?Q?Bg63C1ebNpAMaloFRSyv/pbPoh/P9djfi1a40o4y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Vn6EGwwvzh2fPpUSmbzvNtvy/jEqobHenKwDHCcYE+hThcpezScD824wHlC?=
 =?us-ascii?Q?zO7pwZoA+nr+in1GImXE1sdeO4fny0GNnU/oDAAWIg167f4QU+x9r398pB3c?=
 =?us-ascii?Q?msKRAGcbtLDFGjIV8X/FVQHFlXzuu95/py3kB7qBGt9UQKaseVHPVZ3F7W16?=
 =?us-ascii?Q?OVrZaekNMJrb7HCNKmQes2iXIqosfsPOk//V+9dP9pPsjZDoexbkHqrKKd3h?=
 =?us-ascii?Q?JMEndiRHhkUYAkGzpGe7Jbp4clHsg+KkkTiP6GB+Wugy8hO+hekgigVRj3Re?=
 =?us-ascii?Q?gE/zUaLx81lXBcMhSjHyUvy45iN+wM6LPX9zrBq2n3UP0LhBCG8NFoVEW/jB?=
 =?us-ascii?Q?lyqiW+8heStv9S6Xp50mOMF9GF53bRWAys8YTpb2s0DIMx6CqsEo+fdBhrm8?=
 =?us-ascii?Q?5wi5W2VPjkHtUAaB/62Q1GAv8ugOlR+ldSm6Mid4aTtmDL7QUp9glvAg8wRi?=
 =?us-ascii?Q?45c9S0Q2wKcGgw+pmzXBbg/FIz4dZO0A+oY6BdO5ixze8Gos0AOoBcn/6PqO?=
 =?us-ascii?Q?vN2ivc9l8X74Dr7uhNUACWP+b3Z+oN/YcpYqI2Dd7C6Fo+Jc1vqViwDGmOND?=
 =?us-ascii?Q?USDLIH61704MHJbrYLVVHst3kj+0NHPO+yCMa0B7a4lXL43oxZ77mkm308Yo?=
 =?us-ascii?Q?/j3v9/bWSk+h8AqUX2mMBTnH4SFxH9tFbqu/hL79iZ5nYWWGZQGaLbULghtd?=
 =?us-ascii?Q?vwlOrqss12vuRPuSvkr9Ss/aVfwY9BtMeu8HgzGESWwY43bgqfNFJ9vbPjLQ?=
 =?us-ascii?Q?xNNKo0CO742CLTQfvLsgBwsbQKWZIjhzTeDbyHFsBxGsO1h2OiBVN6gJ+/oR?=
 =?us-ascii?Q?zPOLYuYjrXzaL6TWS4UBT81U7z9Aepv2TFhPOXqqRC0mesfmnHuu+HY6TOcC?=
 =?us-ascii?Q?P17gUFiMEPjBOzK3EC7jb93xG01tGtlFVY9tptLordCGBY03Iq1zuI1G5/iS?=
 =?us-ascii?Q?Er67BdI/LfW+/grFUKvLFdIRepvK3DzNVZHcV1L+cFPcSXqC1bysPXqddtmh?=
 =?us-ascii?Q?/DC5uLN8qz2Um7HRbf6GRo85k+DuGR3OfrPCKZQSRZVoXdg6sQioRTncpX0w?=
 =?us-ascii?Q?uRKAAsBdDj0cQGO9JC4IttFM+IN8csTpN/FVyqG/Uu6+5F5AHZtcqnzZCQO7?=
 =?us-ascii?Q?aL2PZzZ1MCRiLzlpT/+XnhsPYUG44T+tki7hToXSE5As/bk4ucjHhVVGN3Sh?=
 =?us-ascii?Q?+0yKhGLpCJF2jMW+Vd68iGeNjmNgOmRBo0r3zv4qZu14h38AEzjb5FjIJbRC?=
 =?us-ascii?Q?LLM5MKQpqAMP7m10vXnRnXVxjOkDpvNx8IBB92IdPx5asB5pWaXV+MYTgf2Z?=
 =?us-ascii?Q?0TVkP6H8U5ZfdFwJoi4jhZtv6gqYOmIe5UJ9W4B4XDIhyWR+dVh+vkHXbGS0?=
 =?us-ascii?Q?7sdXNz3s7rl5lETwnq23fCp+QJhetbxNxrbZtgeey23VZO0XqYxtKS/vevK9?=
 =?us-ascii?Q?l8GIe1NL4gfNGBgVg8QPl9cHCYunUpxVp01//e1neAsefdQJdQFvsaaT6F6P?=
 =?us-ascii?Q?dxD+cfRv8avYVLQHcsdTGpkXooNQLMDLoMqnkCgljqqWYPjpqrsZ3Nc2GHVx?=
 =?us-ascii?Q?yNg6M1tSwq0C6Q+/o3p/g0ccX3lFttxAgILO7uzocZjrjbCqWcsvAGIwtAsn?=
 =?us-ascii?Q?FnrR5uu7jVv8W7yJ+DzAcksq+gu1HN+ZYiwKmDyDy0yosk16S/YUb2RKAAL7?=
 =?us-ascii?Q?574EREYs+pJR8V99i5ELOnyUPOZglcbGQ0T5hhIPTb6TDQg1gm3nwdEKsKhG?=
 =?us-ascii?Q?EidUf8wLEQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xe142Ye7dv44ecvEl357jQesImU6rrnckzTJ5GyPrFed9j7CW/UahqPfF8FYUQQU0zC7YXYN6izRcSeHAt/DSnSJAHoq3GUVUnKVZEgRi3rI2C7d+EwYczLsg55oEL8dAbiTlzGFMa2vHhxBofvEyZ3Z23up6cthMgC7q5mycbat2KHucqaY185eF0v2g7VWk/vDvQ+CL6ZBv5EQy5gxBIKzdXT4DRxInEVSzc2kxDGbggt0n77pSnDQGpPNe0yQ0NPuHbKuYugbrC1XSA0t0i6ve76qCgPg82qAck+CbJK4Bi8atTbH0RtLBAiFwNTFhvZfNKuL889g2Lpu4iP7yMerL+q4vjGuVb+o0czlr+NwL4DnFePowQzKMq0Aj+Xz8TR6im7tdmlKRIcGfCY+hyAbre4/N/4nvuxlwzGPE7P7nVwfNAOVXLarw/EpvmfZhsuFJCGI6Ai2XmgucEk+7Nc25Jv1E2AXO7CFsOiiuTfNGAl5C64EKJsXKbpv65iH/A0weKEH9jqVWCRBOz0YZEuFP0Nvw2oBh9SLycjCwEt9jZip3/iZbgNPbsvpqhR28TROz5x5EB9tldGXVcnKAEoVHqstY+QyRWZxLf3CcvI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a3b9690-b4e2-4283-b9eb-08de5537fc15
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 19:46:47.6086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zrsaLpEEOc5EY0uSUDXmBM5dIlj8G7QTDFIUvjzsdQkGhlxRitBKg9/Ef2Yb5jdLopPxzXFwVLrv1AhgLEXUVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_07,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160147
X-Proofpoint-GUID: NojQ5ywhuHFn0fXvkgZCFrZ49aNZwqkL
X-Proofpoint-ORIG-GUID: NojQ5ywhuHFn0fXvkgZCFrZ49aNZwqkL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDE0NyBTYWx0ZWRfXzEuB5k91qyXw
 +5RmPk+yVqb06AZktrLFJ57Q7PaBE1Y+0XbrMY+mUGC3bj9Ibhdbf3UIiXjMzvhchdo3i6704rh
 0BapPE7HzpdCb5sU1QaVm8vkhywGVRhb4SLAhWJbZMPNMCZcgkmYft8DkL3GQ1PMSGvFSf6ek9v
 gEfHGYWp9OtXL9VRzYSLFWUB0YsKmZ3ajLlfJoPxu5CVta7nzQcTURAgFzfk8pRHRZdXJoYHhjF
 nQFUWuNI4FnsmIKfN+s0/YSrwXSe5NPH5+FFfPsfaWSorhJmciLHzaJAZAMoNiXThMMuFamaIkS
 zz0LP+ICGJ7yatjYWEm0CQABEvGAAlfzF5PccpqRKDzHI32CI3mvIhzHsLjL/EoW2BEejGVKnZ6
 3QJ+/b7hF/HOJVCfqpFz9/cnVqfcke5nS/x5cA7oFI0kcRdq1mI7nJMU+FGY5H2RH0GILPyoDsI
 tFxl2SKQlbNAGiZdhew==
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=696a95ad cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=170n1hLx1v98HaIW2eoA:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A0EF8160005
X-Stat-Signature: aq6rag3e9jiw8cqcqoup469u6qm66e5s
X-Rspam-User: 
X-HE-Tag: 1768592826-842395
X-HE-Meta: U2FsdGVkX18OWpLGqZgFBQ7hhPPROYIrd+3rDS//yPxQsUqPTZx5pmOsYmGrSwHzqs2RCe8B9vsQ4iROskG5VKuwYBVJtSnDO4D5DjnIk9rQ0CJmU4Ta4E0yY9Vp6e7uG0wua1juvXb0t5EhcTYsHevnrgpsX3d0nGFf4Xx0gmPr7pvOjw/mlaDJ2g8SCRgihxE6027gOROq8GutwileC5QovQHJQUxPxhKNEXfixWvUyz/fmVIPh+3s+0//MjZZqCVP9rufnK7aW9s/fRgf13WKSPAapQ7+nWXvdkPMEcPBLyH9D4mx99aCH5dpZgpQxZqBAwvPHrjOdSdJPc8jnNNIANcsKc33pSh8WzlhVOKsGL3Kffk/SOMoOu9ZgrfuSgVHnIj7g78X9izocjayKIMJKtfyHluTD6ILhHnRI0xcQgbFhHrOaCf71+2OGUjy5QJEyT52inQk7YMCiUvl9B8W0i0KBtASTsHJ24Hnew3figaXRQDi0BHfoIVUfMk/lmqTNLlMFKN7hVoI+GbTP/Xz5TqWlFUWBOIhf/X5DHmujXKiDIrW+AjSqRqu6x7q2wQ4Upo3F+sfyBgl6d8/G1x/jTuRp2RFx8ME7HgVSTv/x+SJ435kF+fr3MGAy9vQZO78dwrI/MthaNm73pVfEGcga4Rzi1XH6Lf43vbaiQmUpe5xohmNl5qCgXUB2ToCYVhv0MX/hWSk4StCsoxBScbImhSUV97qkEnHkP1gXBvdGoG1dDZ8qtF2yRQvUg1k9Dju26m8MK2bRxq19ZxulC4cEgGWhyUA/03DctnCUrVrqm4WwsVLMheE8en0RNpDgdit0vBLbbkrINarJz8GUPaG9AOoQNYi5LK2KXVPzOH/OtwCuoKJKrkxYKTZk8tyHhAqS3bZAKzuO0BPmAG9zU1sEPVdrstFfNG1xaBG3tj6zbiQOr0fNIJCKhYClB5f+NOliLiiYwafep4/2qd
 r23B7Lag
 xyDCDhhp4r/6+t/vkY2aEH1Iv8FJPrUmuFybmgUhnlBN1/NxDnjOCuBGdsN1Toh/hEw18IDr5K/VXS2/aU8DD69gKXE5Tr+iIwr3Ff/1LCG86g7sf5/fDKypEuwjHgZMIXJ6JagF8ZDvO/n961mwHFkpmQR+e7Wr0Btz0CrTLyuySEEBieHTAfS7Vb7PuXWH5cuATCtsHlDS00QF064FYLnBwBQG/18WNFqnV2ezrRDohCnHhWQjRe5FWGjUbLeKvfNAumroqLJrycZyZVn4zOnwajnHB056A64lUqji1VY22mAMFseEOj6OAHU9w+KmPSoO89/DCBM+V5u9g5D3QL83D0cRPZCd4Rwa8pMxBdbJbCDVD0kKMlH3KIpIjDD6OdY9wzUSqtK2de6BvSdTWJaoo0WwST4s0sFICST8H2LpHJ+vKaPPctUu7C5MbjXZ3XFp6U3Glfb2oOBPON5YcTEHuGkas6ImH6KGsviNdCeIMAbvCyz1cTHepqRT9RLVGCY+z7itQQ3oe+DsTALJjqaWUn0isgURv/vAnR2fRFENXPvksg4lVia3teuPqbYboNFuxK/K0Z26UMoaP058ApJq+5rWzSW8Mg7Q4ibs0W6qlYJvB98eFzqrKjiqa5LFSU3jF8MdToDWR5wQwAZkp49ANofvxRCYjcCdbXobHFVkW/BkKp/Mi5/SpV1AzDKGlguLm/i7GKnb3wJwZonA8eDvDrkRPPlhfJqA+BXjcaGHysxUGqK6SJlSQlTNTLklK6Q4CnH+li3sJnc32PJheFV7snCnGm+53DNIoITtMGVJGsn3iYwNzbyDozQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* kernel test robot <lkp@intel.com> [260116 02:45]:
> Hi Liam,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on akpm-mm/mm-everything]
> [also build test WARNING on next-20260115]
> [cannot apply to akpm-mm/mm-nonmm-unstable soc/for-next linus/master v6.19-rc5]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/maple_tree-Move-mas_spanning_rebalance-loop-to-function/20260116-034135
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20260115193647.1695937-11-Liam.Howlett%40oracle.com
> patch subject: [PATCH 10/28] maple_tree: Introduce maple_copy node and use it in mas_spanning_rebalance()
> config: x86_64-randconfig-121-20260116 (https://download.01.org/0day-ci/archive/20260116/202601161501.NZ3GNDCG-lkp@intel.com/config)
> compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601161501.NZ3GNDCG-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601161501.NZ3GNDCG-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> lib/maple_tree.c:2621:29: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got void *content @@
>    lib/maple_tree.c:2621:29: sparse:     expected void [noderef] __rcu *
>    lib/maple_tree.c:2621:29: sparse:     got void *content
> >> lib/maple_tree.c:2624:23: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got void *entry @@
>    lib/maple_tree.c:2624:23: sparse:     expected void [noderef] __rcu *
>    lib/maple_tree.c:2624:23: sparse:     got void *entry
>    lib/maple_tree.c:2680:17: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu **b_slots @@     got void [noderef] __rcu * @@
>    lib/maple_tree.c:2680:17: sparse:     expected void [noderef] __rcu **b_slots
>    lib/maple_tree.c:2680:17: sparse:     got void [noderef] __rcu *
>    lib/maple_tree.c:6412:30: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got struct maple_node * @@
>    lib/maple_tree.c:6412:30: sparse:     expected void [noderef] __rcu *
>    lib/maple_tree.c:6412:30: sparse:     got struct maple_node *
>    lib/maple_tree.c:6412:30: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got struct maple_node * @@
>    lib/maple_tree.c:6412:30: sparse:     expected void [noderef] __rcu *
>    lib/maple_tree.c:6412:30: sparse:     got struct maple_node *
> 
> vim +2621 lib/maple_tree.c
> 
>   2603	
>   2604	/*
>   2605	 * cp_leaf_init() - Initialize a maple_copy node for the leaf level of a
>   2606	 * spanning store
>   2607	 * @cp: The maple copy node
>   2608	 * @mas: The maple state
>   2609	 * @l_wr_mas: The left write state of the spanning store
>   2610	 * @r_wr_mas: The right write state of the spanning store
>   2611	 */
>   2612	static inline void cp_leaf_init(struct maple_copy *cp,
>   2613			struct ma_state *mas, struct ma_wr_state *l_wr_mas,
>   2614			struct ma_wr_state *r_wr_mas)
>   2615	{
>   2616		unsigned char end = 0;
>   2617	
>   2618		/* Create entries to insert including split entries to left and right */
>   2619		if (l_wr_mas->r_min < mas->index) {
>   2620			end++;
> > 2621			cp->slot[0] = l_wr_mas->content;
>   2622			cp->pivot[0] = mas->index - 1;
>   2623		}
> > 2624		cp->slot[end] = l_wr_mas->entry;
>   2625		cp->pivot[end] = mas->last;
>   2626	
>   2627		if (r_wr_mas->end_piv > mas->last) {
>   2628			end++;
>   2629			cp->slot[end] = r_wr_mas->slots[r_wr_mas->offset_end];
>   2630			cp->pivot[end] = r_wr_mas->end_piv;
>   2631		}
>   2632	
>   2633		cp->min = l_wr_mas->r_min;
>   2634		cp->max = cp->pivot[end];
>   2635		cp->end = end;
>   2636	}
>   2637	
> 

#syz test:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2092,19 +2092,28 @@ static inline void cp_leaf_init(struct maple_copy *cp,
 {
        unsigned char end = 0;
 
+       /*
+        * It is very important that the maple_copy node is never seen before a
+        * write side barrier happens.  Otherwise, there could be a reordering
+        * in the RCU code below that will be extremely difficult to debug.
+        *
+        * In this case, it is fine because the maple_copy is never exposed to
+        * readers until it is put into a final node and a wmb() occurs.
+        */
        cp->height = 1;
        /* Create entries to insert including split entries to left and right */
        if (l_wr_mas->r_min < mas->index) {
                end++;
-               cp->slot[0] = l_wr_mas->content;
+               RCU_INIT_POINTER(cp->slot[0], l_wr_mas->content);
                cp->pivot[0] = mas->index - 1;
        }
-       cp->slot[end] = l_wr_mas->entry;
+       RCU_INIT_POINTER(cp->slot[end], l_wr_mas->entry);
        cp->pivot[end] = mas->last;
 
        if (r_wr_mas->end_piv > mas->last) {
                end++;
-               cp->slot[end] = r_wr_mas->slots[r_wr_mas->offset_end];
+               RCU_INIT_POINTER(cp->slot[end],
+                                r_wr_mas->slots[r_wr_mas->offset_end]);
                cp->pivot[end] = r_wr_mas->end_piv;
        }

