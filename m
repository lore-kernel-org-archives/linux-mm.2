Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E081CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A16A8E000A; Mon, 10 Nov 2025 22:17:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8789D8E0002; Mon, 10 Nov 2025 22:17:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7406B8E000A; Mon, 10 Nov 2025 22:17:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 600AE8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:17:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E07B787ED8
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:17:20 +0000 (UTC)
X-FDA: 84096865440.08.5E8D18D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 75E7040008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:17:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qeAkrUFF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=f06HvFGp;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762831037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AHuOrkOTJATiT6Qvb7dWBs3yQpxkAiZsmpUPmASTQQ=;
	b=i/RMKTBei7S1BtmyKegvZXbCwKVCTSsTMkOmc4SmPuwkytpeIGq18I7dDL3hQwctYSrrh8
	ym0B8iRPxkOjVs+pL0NsR0ilNcVC7UXCtyS82Lz25YG3Bk5Muxpp0Zde6sWNkZYIDwBn3F
	672x8el/YOcBF6TbpTIzrq2U569YS/A=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qeAkrUFF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=f06HvFGp;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762831037; a=rsa-sha256;
	cv=pass;
	b=4XGyxR/7HF+gWVQ51ffY01TQLBBjLH9yJyy7Ft0dYsokpwIpEr4C7GvNLZsnRcsfJyhTLc
	S1O02i9V5lo1WLrM1RDgAUQ1jZCFz+JRXae17AuzURUcit1EAwgoCIzei6hiIdQM6kJ4Ed
	WIRkh+0oou+q1+5d1kHruzfVTWrGvow=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB392gW000387;
	Tue, 11 Nov 2025 03:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9AHuOrkOTJATiT6Qvb
	7dWBs3yQpxkAiZsmpUPmASTQQ=; b=qeAkrUFFS9sbcE5XCzO9XSKHxaFvdHVxC3
	Y2x0TYLAe2NKF10MHaAGI/NLcpFIPaiP+nZpj6Gfai6AUVMqDtoL0tgAIPBJrmoJ
	fofroGBAer5j774abntF5SYfYs3dKggbSHGLHxPjqxRFVwlpwXABS2h922j5AQao
	qi2MWUr2H2MWsffwRGf+PXTPODEMidyawyaL3B2sEUdecAEjcpjRPhfKD/7WKOs4
	GAt3o12OmSHoGu5S+Nm1QBdxdLgUvYl1BCV1AeqsbcK7CywYeBH8NE8xXYiVHtL4
	724dqYuyOhuIv8hK07yHvVmBhkFvKNKIe9TxIwDDZmtUC1tarWmQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abv94016h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 03:16:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB2jL5T000804;
	Tue, 11 Nov 2025 03:16:57 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010071.outbound.protection.outlook.com [52.101.193.71])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vad06nk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 03:16:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WMigAlpgK463Chf9crwFOsQQPlGU0gHHSmnXhKIRSriQ5y74zosVi/m28XtH7jQVBRlgDOwG9dwracAhJwXUmyzu8xTXsXhHUHDswJInlYMpJNJygk3Vba7FuTVyO2T+CpaeojdfuoMrQsGkbygvf6Sag6EzZbtu4Xp5RZut1p64yWhz2RlA+NasTNsxk0nmdL9j6YInzuXI4iRzDTsj27t2Bx3aa/ONw/NK7520k0YHtD3QNAt71kAB950HADW+0qwUciVK2RzJP2ES6RpabYGy/EHMB8w5a5dIdbecXeBiz6qbaxh6O1BbL+tKsz2mYMuInHIY+wxarzGm4kAsEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AHuOrkOTJATiT6Qvb7dWBs3yQpxkAiZsmpUPmASTQQ=;
 b=uveExkAkPG1G+GpiUpTrmiQAwqy0XAnPviP26KwK+Yx9Z9ADNJ3IKftVA6jSxuTBzXc026svFF0b4p2ResByCtsd2/NGTeB5PnHpUvuXajC0gEIiZm6FzOlkmPO1u/RR+ZaGovKZglbPxpe3/9zIFXWqbV3XUlWbYkSW5kWBj891TX0x2z/X6HRXI2lnIoVYljfrku34ODIgwAMdHEbjn+Jzo6y0oHaHy8A3btpQSE3Hn82MLKurYhdjFdFT4h+yx1VcV0tjphfXB6cXbEpD7Crpge+60Iu5q/w+nLiUsLTTLb4t899uAxH+5UABKJuUF287t8sCg7SyIVNyzYV3PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AHuOrkOTJATiT6Qvb7dWBs3yQpxkAiZsmpUPmASTQQ=;
 b=f06HvFGpLJK8TW9sqXhyzPV69CbW4dWdEqc0Q5bffJbemjkZZ+FktvZirQcFCsqGhMFkidUw5HEeYd02OvTx5iCUAoj+Fk7L0ZiM9obG16cvuAbjEtc+TSbXCuaqXs3760I8Gk56Xo1b6fOdAAZfRtqEKkUvRuGq9Pj0kZb/kPA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB5922.namprd10.prod.outlook.com (2603:10b6:208:3d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 03:16:54 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 03:16:54 +0000
Date: Tue, 11 Nov 2025 12:16:43 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, hannes@cmpxchg.org,
        hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
Message-ID: <aRKqm24Lrg-JnCoh@hyeyoo>
References: <97ea4728568459f501ddcab6c378c29064630bb9.1761658310.git.zhengqi.arch@bytedance.com>
 <aQ1_f_6KPRZknUGS@harry>
 <366385a3-ed0e-440b-a08b-9cf14165ee8f@linux.dev>
 <aQ3yLER4C4jY70BH@harry>
 <hfutmuh4g5jtmrgeemq2aqr2tvxz6mnqaxo5l5vddqnjasyagi@gcscu5khrjxm>
 <aRFKY5VGEujVOqBc@hyeyoo>
 <2a68bddf-e6e6-4960-b5bc-1a39d747ea9b@linux.dev>
 <aRF7eYlBKmG3hEFF@hyeyoo>
 <aqdvjyzfk6vpespzcszfkmx522iy7hvddefcjgusrysglpdykt@uqedtngotzmy>
 <8d6655f8-2756-45bb-85c1-223c3a5e656c@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d6655f8-2756-45bb-85c1-223c3a5e656c@linux.dev>
X-ClientProxiedBy: SE2P216CA0121.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c9::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB5922:EE_
X-MS-Office365-Filtering-Correlation-Id: 1760b0a6-b315-485e-3b46-08de20d0c397
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8diSXQFGwFmFsuUkX7PuloH7sYW0eOy1pzxB4QD1wojj9GLiigxV0FP0B4n6?=
 =?us-ascii?Q?6R4HZPh9OoQOKc7eSd8V+wkNON4vOAiCjJaBa2cG1sqhdup10rFxnM2NQrFu?=
 =?us-ascii?Q?gBgLFw4sApeASrQbba79lZMn9vXkWGrjkte/RIF8s/+kdXhPSd8XoGeqlmeP?=
 =?us-ascii?Q?G898cUQH1mJFg1LtaJhpdwATbdxIIqTOwPYwu5C2ArJ/1ZYS1bwAMhMc3uxi?=
 =?us-ascii?Q?krboXOAE2yZ5lQM8Mnz69B8jTVFk/kPr8qIMq5zbwvPZB6J6XvF0H9WPry5d?=
 =?us-ascii?Q?c5g3bhe8wt/GWpbgkuvr0pY8C/F+x4DXsjh0vSXAWVxY/A1KwxGA0Q8hYzZi?=
 =?us-ascii?Q?kLdlGGzhNtJWrMnBC1/rl3zghxWzhHLBrEqY6qk0rW4kj4KCmWGO/cWjeRHa?=
 =?us-ascii?Q?NxKjZ3j7OCqm44DLshL4vibm93RFg7MggSEvYbWf2NeijEwdPHsgGLSrR/nr?=
 =?us-ascii?Q?ntofPgDo47nNmQZ/el97h9k8kEsmtUgvFceaHhXTgUBdUnUORPTLx37Yz2Ze?=
 =?us-ascii?Q?Pe4ZCiDfUe6hzA4ofbVSmcp/PeunzKXeaeFdpWADSSNG6nWSXv4Fz/npR60Z?=
 =?us-ascii?Q?qkRhK6pZdfKLBVppU/Jk9nkyx/Pq5vrnzqdBCJe+ia/36nizScH34cXvQ1ak?=
 =?us-ascii?Q?HquYDbI79mhXgSxS7jnG1iHkcuRDicC8EmrudpMLBUQfDQzuCX6ehp9drqfH?=
 =?us-ascii?Q?zqYqV97Uu64QrXhSqsZG8mUNRp2ZW0WspsmK/EPf2mN6B0Vvg8phCSmif8RJ?=
 =?us-ascii?Q?o0wC2BfSpvo9m9CTCt86df8tnTACG5Ff+hJ/208hAVrNnfPlehjxn4dHiaR9?=
 =?us-ascii?Q?7AiPYKkhImPL5DTbreYG+fTmIOhLv5dVGgOPEd5anCi6IVD8e4NOAm3EMMuN?=
 =?us-ascii?Q?pAdXon3KcjCnxa+lA+DZcMiJT9f9W7PYvazy8eNZUUZn/LRayWrm9h55GkHc?=
 =?us-ascii?Q?zljI4p3h2zdIIr4eQMm7EiIHKC/TaeGdF/KVT9GY3HchZ3ckPbClkAs0qpqL?=
 =?us-ascii?Q?SrofZx9KFgNTJhdC3yYHDH6i3Wy+WNUi8EoNt0VIrhHk8/5/2SMKGu4EUHr/?=
 =?us-ascii?Q?wsA896v2r00ntb7fM1sUevlNMprPaN4QSMRpIjNmBlSi7EHnh481cdfi7BHM?=
 =?us-ascii?Q?VoZUew6RYUKd0ZogXrZd6tLFNZXxXt1CM+GjDJgtPoZM3qT6ehPv/GS3KgkZ?=
 =?us-ascii?Q?vUkhxjcyB1xJAACeR0nwJwPF2/oe6aF3gS29Co5qE/s6jmbJcPMliOBRy2uj?=
 =?us-ascii?Q?/ZgGZ9yH539EACqvOZuo8uqH/S6HL8BLOkn25fT4lSVl1C4/ifoNRrr10pIY?=
 =?us-ascii?Q?iNQ20xg0N5fagFifia2zkGCn/I9SweJNFt4EmhSONfOdSzlKKE5DTfDKZl5d?=
 =?us-ascii?Q?Yd0tgTmD2Adv5EKBWpVWJtyecZCHoiwj3KHx+qPruv0odtjoRgiLGOSrNxdf?=
 =?us-ascii?Q?4zaMzM/LSMX4XoddWR03qehHAarGyKWt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s9skvPetwccy6mm5XDT14mOE2VN5xWri7FdO7b/Nmw3fNR7XeJmxpboyFCTr?=
 =?us-ascii?Q?aimFK+iMOHPdMzHsblMw/dVCfNYhNCqLcxQOvBu81T6CsqBQkEyKRJOx6xSz?=
 =?us-ascii?Q?L9hpioob8Uzs8gieY+h6z/vcnHaYRwKb97wiR/IXE3LREVTOHN6WwPK8WxZV?=
 =?us-ascii?Q?aYqeBrkwHxIYwuUowwRlnL+9EQYmkwJJOWt2DJpawALldb7YHzynMoCTUXok?=
 =?us-ascii?Q?8B7k5vv7p3zJF+X0zCOvo4vq24x7QaXKvCh8QUf58mB+HCN9AFo/hPW9EDEy?=
 =?us-ascii?Q?J2FMu8mpQkS8kB1/aegelhnSe+47yStAyFwmz3Pp5e90YwNjQN983/FbpWwK?=
 =?us-ascii?Q?P1zi3hDPOPMoW4A5zDDIA+T5JYtE1S6vX3JX5SIBMDgXxIxVnOUCY+OBTofj?=
 =?us-ascii?Q?ZoBrsjfNBoFVoDHX42H+buyhwniGu2TmlxLYngRrRP9WeziJBXuXmVKLGlpl?=
 =?us-ascii?Q?EJvyURblAZeXu3BS/+8ieebxnhxtKAy1bcAji/fSP1MlbpdXmwIfBxBX+zS+?=
 =?us-ascii?Q?bt673DAp0hDCCWUSv2Y8KSDCNU5LYRJ6/brWGz8P1Zc48XX5PqZ9dJBornIo?=
 =?us-ascii?Q?s5kYKgdiFiYbleys44udlm1cSRKQAWG1yRPNwBWT3wm2+DKaWVZwLOps9IWV?=
 =?us-ascii?Q?ZGZV9Xpqo+ZmA2VRhYB3RCr2tgTqUvHko2sQtSHmUlzbGIIKo2jKDHvLsjhh?=
 =?us-ascii?Q?YLPdQROeyGNDf0RyCOrLtZr3P+iAyRnOg3wHQkfMRw7EtaDZoi/HtXFSJ/GV?=
 =?us-ascii?Q?bhM/eL08Ve41Vzoi6dW7aiviNwH3eHno5PoByCaDbseB4u7UlLpAi6J3VLrT?=
 =?us-ascii?Q?zYfRRMCtxtXGo8+oJ63UvGUCtB2oR5BlypEwsA3U1F/nStoXDgCqNa4Hn5+p?=
 =?us-ascii?Q?08I8tzdSxKDLVPJSbiAFew26E87/QmeH417XXc+z5PxEiaqXbl0LnduUcrsZ?=
 =?us-ascii?Q?+wo8ceb3ZAdpqD2AG2VXOttYc5Knt1UvWS5asFyG8OZ67wjABqbold0J9Bac?=
 =?us-ascii?Q?oEqU7i2Lq6J4ar0Bk4J6+qDZUZxRlrupJF88iwM7vcVD1KaOPluRFkbjrlwT?=
 =?us-ascii?Q?UhQkd8ebXVf7sRVByeJC8MlhW2PnDF8a1keKcswChuR3OGP0F/ruSqq0+JPe?=
 =?us-ascii?Q?a6UQlBdwwuO+Z/e7Jv5DSrJMNVAXwrZPxR0KRGPP7KViLIClzqTRipTB/XmK?=
 =?us-ascii?Q?OPrHhUF4NeT3WVuztnlQMPp6ptMzzwEa9XqvCDDLjmQR/Mu/2u70Yq5V4aXg?=
 =?us-ascii?Q?oAzIsBHuqqhA7vlV+tBfl7umv6qc8LgkE7K2yhOefNfQhV4k+VFQ584THrbB?=
 =?us-ascii?Q?lYPahecK4RjMFkPM9G5gBsqYKy1AU2LByLvkR2M1ubgr7p4dr+FLKXZAnGQ0?=
 =?us-ascii?Q?XGgFNtPq59iPFEtGjiWADTkdbFvK8kZd+QTg5ntgmzp67UlkWxh1y2Ar7mDb?=
 =?us-ascii?Q?XVLAZvEgciL26YUs1DY017iWEdhJotFdypcWC453Wl8q12tBWaVGn5jJBVGa?=
 =?us-ascii?Q?XkM7AMUwjNNviy1YkyB8ktpVUoPJkWHBm2Wt5+2vOeolh7fP40BRBbRry6tG?=
 =?us-ascii?Q?iLvX5mOmhC5G4+RUVERyHIu9p16vCyqzH6fsCgwr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	grLAW17ue4tsLFtZX435FUdhJzFG46KxQPn2/qVQmRWsyg1z5hHRrMv4wAJUO3kju57eJvHxMGmtX7s4gT+jQpEaKRIxYAMOng2Vu6hLXeldbmBqVVi9PMW/KaZ0Z1cIWGlyeGGydW79gC1OM1ZuG5wSTv2iUsGalncuuR1LSdM3nvvBE9iie/uc+ruqnqSIA79EJ8JJ6kiTORNZ30/2IFpAyZmX1c6Tkc280lOgnAGuYJq6sCoFs7L6rwFoYhH4sPUAEYsdm0qJA5MXiESu9lJUxcigVYxguEWVSSMw40hMKLArxYl6N+j7+WXXJiPiLXCo9DKjs7t+O9q6kEOXCW9wiOsiVRdFpVsZJ86CO4G9cZCpRaBzUIOML3R0D7uaiYPzUBE5yf4R+NoY6QtvLYXmbm5v9Jyl/Qaw7fZm80oXIFYJIyoaANGP/bJz5UlIsdmfv9M7/MTAbvbgoS20wF92e2C+Fnlx7S8dDKQRMpAAy4F1UzLFbrAKNQ1jFuwRMUzqRVMzDIlfwxophnpCg4l4mo+6eWylCea6P8ju+Riko2qzzwY9yJTxdBv0pAHQvszxFhVK+eAssQYhUQTdgh9NkD7dkcx/tUuF704K3o0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1760b0a6-b315-485e-3b46-08de20d0c397
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 03:16:54.3673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IzKUy10W17iMSSZUSm8A8aiTBqVOxcz4lmdFvt5IKCt5k1JehtuwE4BvEYIf6xRVz37Kf8aRSnYNC4sRc5aKyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5922
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_01,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=986 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511110022
X-Proofpoint-ORIG-GUID: tjWKjJCNO8LTQtN4R-WpWt7rrXF_q7oB
X-Proofpoint-GUID: tjWKjJCNO8LTQtN4R-WpWt7rrXF_q7oB
X-Authority-Analysis: v=2.4 cv=TZCbdBQh c=1 sm=1 tr=0 ts=6912aaaa b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=r4xTdAWZDPPdFobqJwsA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13634
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDAxNCBTYWx0ZWRfX72uTE+X5SBzt
 irCKP4Pw0hGqE//d1iFXJETOmL17rCusS2072EF0Zwx4ibarvxEg/qD5NbpmXWc70V3HqyUmH73
 KPTylW9VwICTJ++5yNZAvbyoSXamDUpHb80O/9czxQU+QMhYSTk9qXJBDm6K1ncdn48GcRr69Xy
 yjXYOa6wX9PuJ9n5TNDLWZO03BMAZQDsRmzDDIyjQYJ4S3AEbN1GAaT/wZ9Ui1M0hbrPJQcleD+
 kEMlU1uEDAysghaqL+VbmrBouilcImVUZlK2UcUJ6F9fvjE0wugfk9j39RvDYdnTTghQXYYQ2L7
 vHUf6QbpnLX6Abi/PPafhrouxfbSY2e0S6Pb3uvAxuTDA8OGw/SjcOq0ZcUEjWrpdyHPuUjPM00
 ZiNBLDjENd1X24b4QpMgxM0qXhyXOiUH7MxoqbvlUmbuj70Gy5A=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 75E7040008
X-Stat-Signature: u1qd8jzx7q6hjatoo31bygmnf1iuwt6w
X-Rspam-User: 
X-HE-Tag: 1762831037-290922
X-HE-Meta: U2FsdGVkX18TQChNEaxMRI1rrms1pNYAzEs3Z4M/kJAHxuHITVhLpwQDGxvuZxO9QUI8Sx5f+JsSUaO6aH15o5k8pJVTd5aCdWErFlG/Qe6qsjNkt1N7v4ZhEihg5Kg8ZJl0rZdkXOXsUFDT89Rqmos7iYG+POiTO3A5nkdNxaoEoQpC3K64P84aHSoDG96qN/5V/lxr8BHmalN5Kw6hTgceCnjLxYt2s1A5jCAEkgyBkHRp+Zgrx5MG07+Ay8b8gA5UHlIKuThb+FNnHbwSCTF/ib8eVlnKp0jH7X+uU1iar2LwdAEYCSxHZ51cbb5Pqnj3AGDeO9AhKVgKAheO2xXXZ5cZz7lZCYKV+IjWxINFTfx7MdEJJEtBNhi+5DpsO4/AxcKrWtU3FsARC2EAO/Q2b4JaVrUnvqqbEj79h+JLwqfCNBzMXB827s5UIgonq9dFoLwxzD6QaIQExLXG/RJXBvFSQh9IxlXrM4xeoFYsxWN1D+XskLIHeeaCD2X58xf/U/aYqv9YSgP6LD/xhq0Mxd9dzvLmuLVBgoJoajOAqyY2DX0j12eVLwnMts3NPSyED5kS2unIMDPX/JvWs2kQz7qYWRhSFeJ6gKeHz8NC44K/mBM+2cuJKwB8EgrSjpa2An0dqzVBJw9CggB1sCrlDkXT/Moy91y5O5IA4Fy9Ykq4c1XXQax+R0yBkV5fGc94VSpnfZCko0JV5WUgPzQ6fjlq/IOp+aPuckghDa7Od4W30W78ihta65yA74inyv7FUKcoZrYN30CmX0+xvX1QSIqjZLIwWzXgvz68CQHTC5LHCJgKNRAQ4o11UHm/j9pjbdOGDxFyoQyleeHgJ5gx8+bqd2pxGa/RRWlf8zP5YZzZZ8GoFIruSygOQv+9A9dxlF+JyTXrBfd2FcNEMg9CJIPjsZ4+zmGHF5Nyit2iUDaV4k8HNSEE8/fRdjcUgI5ds67eMnHOxAHizIN
 iA8z17Qk
 /QHRus3zCv1D6krcnUj3AC1w0/Mtp5AaVjq3T1t+VRbUOXY+VmT9gXYACzZW47rGkytQ3gLhFhx9r6uDCXVlln81DST3clbXpqgnThueetD4h2JujfSdCXWHGkl2aM2V61+m219sR4oxF909wJkh28jK/SjxYOPUlk6SAeYZ2VVyjSnQI0tAnlmjyFHrwtbYuWQfimzKFBQWhLr67nXHKpZX1WZ8muUOEd+6YYxHUP1UqTIV1Z7hAuTCKzkhb33xefz4w1kmzC9TIP84hA8aiBewOuzKk43BkW9D489IqPZZc4JFFjucDWiJCF0zjfBDbHM57yvAWsia3irxvkYs2EeaPg0ONAlvUnfJlL3bb5VKVm9ZIMYmb6nIeMVB2CrrYDao1nkVr3bYALAwEABQzLvqNcYhjmJiPA45QwTICJES2epam8Vm6g/kPzUVIimR44RFrWyKAusjEjMITupgOyNBks59RsxSPCRIWP+pnBqtHXlIGAvgR1EooFU3o5bwb/yitQrQ+vUzxOiY7ynMP3t45Y4klTXhUl38l4bkSClHMUPiORMA7oWTfnyIf1G2J9J14S9tAJtitbOu3dswJNkpq/6vO75fG6RhtTsaHJU/OnlwuJCqEiVBk36S2+OJKswU2V9prbGNSlw3QKggeLopPL4kcmmpH/iOGlQt7Gf5bc2w7JkoQbw4h4xThAZtjjGaHCteJKuehM4g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 11:04:09AM +0800, Qi Zheng wrote:
> 
> On 11/11/25 12:47 AM, Shakeel Butt wrote:
> > On Mon, Nov 10, 2025 at 02:43:21PM +0900, Harry Yoo wrote:
> > > On Mon, Nov 10, 2025 at 12:30:06PM +0800, Qi Zheng wrote:
> > > > > Maybe we could make it safe against re-entrant IRQ handlers by using
> > > > > read-modify-write operations?
> > > > 
> > > > Isn't it because of the RMW operation that we need to use IRQ to
> > > > guarantee atomicity? Or have I misunderstood something?
> > > 
> > > I meant using atomic operations instead of disabling IRQs, like, by
> > > using this_cpu_add() or cmpxchg() instead.
> > 
> > We already have mod_node_page_state() which is safe from IRQs and is
> > optimized to not disable IRQs for archs with HAVE_CMPXCHG_LOCAL which
> > includes x86 and arm64.
> 
> However, in the !CONFIG_HAVE_CMPXCHG_LOCAL case, mod_node_page_state()
> still calls local_irq_save(). Is this feasible in the PREEMPT_RT kernel?

Hmm I was going to say it's necessary, but AFAICT we don't allocate
or free memory in hardirq context on PREEMPT_RT (that's the policy)
and so I'd say it's not necessary to disable IRQs.

Sounds like we still want to disable IRQs only on !PREEMPT_RT on
such architectures?

Not sure how seriously do PREEMPT_RT folks care about architectures
without HAVE_CMPXCHG_LOCAL. (riscv and loongarch have ARCH_SUPPORTS_RT
but doesn't have HAVE_CMPXCHG_LOCAL).

If they do care, this can be done as a separate patch series because
we already call local_irq_{save,restore}() in many places in mm/vmstat.c
if the architecture doesn't not have HAVE_CMPXCHG_LOCAL.

> > Let me send the patch to cleanup the memcg code which uses
> > __mod_node_page_state.

-- 
Cheers,
Harry / Hyeonggon

