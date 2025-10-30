Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AFB0CCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 01:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1898E01AB; Wed, 29 Oct 2025 21:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8268E0106; Wed, 29 Oct 2025 21:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496C78E01AB; Wed, 29 Oct 2025 21:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 382A38E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:11:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02C0512B54F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:11:28 +0000 (UTC)
X-FDA: 84053002698.14.3398FE5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9886B180003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:11:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pH4diG73;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="cxYxmS/6";
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761786685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0A4gZ2ItiqgcbQPv9U3Wu7jlitCB7TW0uwK81IG4sNU=;
	b=FUcmqhV4jclHyPPxYVZ6KLMiohjb3TnTGMMKSmQklN5Ha3qoZpYuQurrdbSvqb4/W/rZvJ
	J60JNiYnTVvUQxPw3iYZ8df24qVWJoCHllysMv/oelvT/oTRseqCcXFwrPc5l0ce/ZBdUE
	+O3CbFDZRSfgExYLc+sTGBcfMUWS80c=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pH4diG73;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="cxYxmS/6";
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761786685; a=rsa-sha256;
	cv=pass;
	b=FoMahu6YEXMo80lYbpwDebIFhJBb4pTGAK46SwVGMcbpPkopdGuRNduALnRW2lnVoVpirR
	z45rQVfeTGqQcK6454dgAcTT3NKaoP7ugxrDC+wno4dE5dnxQZQH4USRSY/5qXSWvGNHyV
	Hh9OXjCh9QhtytcvvI1erk2M867etyI=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U0uxXJ007223;
	Thu, 30 Oct 2025 01:11:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0A4gZ2ItiqgcbQPv9U
	3Wu7jlitCB7TW0uwK81IG4sNU=; b=pH4diG731j6hllpwzGzdQwfTR6DzlSurUD
	Q7giQGKTSTS6lEGP2K1//M3A6ybNE3CdQyzEd9B7jiqAVYVywOjQpoYmA0I2EFrC
	G8A4UeWj+6o+imu25ac2Y+G1p4eG2yO8eKEKqP5E+alKmLAMlnO8C6gnad9toI+L
	GsbE9vS2c/4c39VawZPCKr4qFbOfoXdQn7W2AJpvkeMzfYN/4N44QgFOv2Tzwp7y
	xvJIN8RdbbF20/LO/Pslh6a6AY+LQmCjmIon/i9/pAWTTeEFdw0uJ0pUWlYJLylC
	NORbZazL8YA5N26RVrenPmcRe4Q9xaFTcMwoUimI7EG3gAl4gJ7Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a33vvkg9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 01:11:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U0Ciqc031687;
	Thu, 30 Oct 2025 01:11:16 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012047.outbound.protection.outlook.com [40.93.195.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a34ecp151-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 01:11:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gn90ySUpFZlCLSVVfaE2RQ7wcx+4swGucrEfDnTZyvLv3wh3v1ecui22ZtJA5zgJiTPM8s4YXto32BOkor2n7jhFbL6UiejUOaCHVUe4w9odRbEiyH29mT2V0Fk1CQV8RuBOEEwZqnAnfvLBJAiCRoCX2IOiBxAqSGN9qQgXWpdVdWbSlzntLbzlHtlHummKs8OnF8QAUBBonHsLYQuoSov1hkn/qensD/FzalVBqZx6F+b6oLcigMws4ujHSUsqq2xhXTO1PL8Rnv3epxFuCrXlc+Unrto3yc0agvPZPLkBqAsgJWRNypjWtx2k15iMI1MT5Bxo6mh/XoByprb2Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0A4gZ2ItiqgcbQPv9U3Wu7jlitCB7TW0uwK81IG4sNU=;
 b=YAv5ajgKl39UvLs0OYPHsjDvuVRcQG+IcNJX1TfGdG4tYcHYMIUFQ4MA5MUMz6jsGNpwSxsQJj7bMB2LUiSqZ+Y8GTgtZEBQ0odhPVV3vbfF/wPLgMZ18svKFu8+TgOWCVi1hwsua7k5jSDu96DR9jgOMcwvbdebrcn9Yb+jj/+RfnOTVhRkc+LVA35VC1oxvp3/MMWIrI018MsdiKpaTF4hnz9e+2vAjo2scc5M3rpKaIGlM4+UEHE8uqQmYOdTuUEDPH6ogNhs333vzyEZjhtRT7u3zLSsjBh/Ikq6rzupi0o42eRp5v+y7P9Y2OFIZrwuaA11BhL8DMSsoeL6fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0A4gZ2ItiqgcbQPv9U3Wu7jlitCB7TW0uwK81IG4sNU=;
 b=cxYxmS/6bqZRa+06byzJs6RE3oT5yDeXC+lJza7JKq3bVUTlrN8ApywUtdrMXnFgCpbv1q6Dx992Eb/GislcYsNGfwuxvx3V62HarvmGDzXaBGILCvcp70Pn0Mm2BrwY6BF1aYI08v7XKF0eOMJBEfBWDgURr7qDo0mClJdHl3c=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BN0PR10MB5173.namprd10.prod.outlook.com (2603:10b6:408:127::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 01:11:13 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 01:11:12 +0000
Date: Thu, 30 Oct 2025 10:11:05 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com,
        cl@linux.com, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        shakeel.butt@linux.dev, surenb@google.com, vincenzo.frascino@arm.com,
        yeoreum.yun@arm.com, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V3 6/7] mm/slab: save memory by allocating
 slabobj_ext array from leftover
Message-ID: <aQK7KaxX17goz926@hyeyoo>
References: <20251027122847.320924-1-harry.yoo@oracle.com>
 <20251027122847.320924-7-harry.yoo@oracle.com>
 <c8f89f0a-a327-441e-9bd6-17523c5fa65c@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8f89f0a-a327-441e-9bd6-17523c5fa65c@gmail.com>
X-ClientProxiedBy: SEWP216CA0093.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bf::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BN0PR10MB5173:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bf956e8-2dc9-47b5-ca9b-08de17513784
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yMAPCPhDNKLi8WbRMTunC66A/wIwKZjRB4lvGczxq9bpTimxso2Q/TAFV7l1?=
 =?us-ascii?Q?TzwmgIgKehWo2F3SBMJ0XwZE+nz3vCy184kUL8FB5211NTKtPoD2Mt0w43j7?=
 =?us-ascii?Q?D5GLLtG9CR06mu5N7O1qGVf+tuY+cmLAB0Mzvx+m5KLIpr9QbEdb7aPwiQW1?=
 =?us-ascii?Q?uQA980KrWjEJnAbIZVs8ttijeBATxEXA6L8w25/wxX7gvzAac59UdveSn+Mt?=
 =?us-ascii?Q?Bk8+q/IbU3oz/874OkdhqZBBjY/ypQykzvg/UJ8SGlq8/i5GOTbrniCXhU4Q?=
 =?us-ascii?Q?F9+cobvi/qpU6LhPB8+ErtRP1f65/h3fVzxVxILXnyS2Vgo7unvTcOC/O2S1?=
 =?us-ascii?Q?uz1JqXWika8wU3t5I8rmpgpFcPwJNH7L9qL4AL2TSOpCZQ5lBem3md9agI3F?=
 =?us-ascii?Q?2OpYXZh86SG4QDdRkMJQTggAa4lPFQ3A8WW2YnsY6URqdtz3ko0U1sVoGH6R?=
 =?us-ascii?Q?7m5Ejv3gLTTvl8xayaBzaaisafEpWL0o3TIM5oHQNvIEwlKEwUpP3rhbG+i4?=
 =?us-ascii?Q?+FSF9h8Fs2PlSfcmqI5hcOZljmMbduqH/VQrLzTYth73zJ/Pp1ybcLAgy5SU?=
 =?us-ascii?Q?JgDVvvUixojUkcFw3e4ikByLpBtCIIosxIPBiMzzBFUV+KefFGAj8AsLt0+v?=
 =?us-ascii?Q?6cDX3Q2wVLZwM/Io86okQpgKHyQsXVtqolU1LG1d/O6xJFeAof2JqGOqJjuG?=
 =?us-ascii?Q?9f65+OMaisYauIHlPSg1CpmlVvWwnxOgQR3F2X/JWmrVn8vyHf9MFuDWuTt8?=
 =?us-ascii?Q?41Y0mUGXiexfSu2h7YysHbQS/p1h3ommzJhj/UHhpeEoezOB3fS+w3BclSUk?=
 =?us-ascii?Q?epsvJwqF33d4eEEKDqHmBKSm11Km9iliM3S1Z5SBDsg7y/rgX22HBCrtVm1m?=
 =?us-ascii?Q?FS5JLuQ0SgMNLeTVei+IrsRc/71JXK3ywhy6JK8aOVG7xCbY08ZJ11+YmyxN?=
 =?us-ascii?Q?clu4Dojq1lu99jbsUfsfrOxZN2krH61kOWVqVpxMpzLsLIGQmYt8qgkU8Lep?=
 =?us-ascii?Q?jIcd7V2NtjJeAWFYgtHcpo95rgRj25BQCG42pJHhxJH8ScKjcrKvpAoR8x1I?=
 =?us-ascii?Q?KoCmQqXR2mSZUZJMvjTyhHTDsbSSHTPoDfpMFfBExgJvN2ezsyvrDmTRGM3V?=
 =?us-ascii?Q?CUYAQfO5Jpcf75cH/6sjOG2brkNd8PZM+7yUIA7vlrMQ1UqJUo2rRTzISK++?=
 =?us-ascii?Q?n0OjBPoPH49UW2kYpsjh+bys42hf1Dp1NLOF880rDrzEkGXnV/eATQpSoP6A?=
 =?us-ascii?Q?jvTD7Ek7C+RsZlFTfDnjTUcpuHaKzcIzFgIY88hF+ULXZP5yjfD7Oj6ovemS?=
 =?us-ascii?Q?+a6FqWwp+ovBo4lYhu5n6/01gl/8fW//g0BtSxpIngVF8yb+meZ8sd4uolrH?=
 =?us-ascii?Q?2Gux2GWi8+I30uQfuM34paOJTJzzaV8o9MdUeBRiq3HuUxt7EKknJo18SciX?=
 =?us-ascii?Q?/+QFOR27+SSKsL0ufJMAkwjS2srqVl/k?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c15c90z06yOwcnJMklgWrZUn/NcPVNBor8Lec8fM0TjHopoqJ4VBm55bJ014?=
 =?us-ascii?Q?dCdJ3DRvXnpcFKMR5e+A0Z9DZOHXHmHza2FL4l1W9PSUDT+ZJQW6Ah9DqdSP?=
 =?us-ascii?Q?xfLWMno4ck+oT89lhsYWRgaks5BGov7kqyI71+qeQfou8FUNHuAwyEq2X4oL?=
 =?us-ascii?Q?HQffblv55JHJ/HvrnUj4ERGA6LI5DK94Lu25YYs0aPU8/2JsnthrxXBsJyyM?=
 =?us-ascii?Q?Fca5Prp1jsUGm8ohvxhPFeB8Ohso333Jih1h82xphrn5REwx/Q0RsidXOJIK?=
 =?us-ascii?Q?wdzAHwIhA1LC3zURShyTA8VBUvUzwVI195IHFO57bE2Crxrwph7jVkRTxXSX?=
 =?us-ascii?Q?CRWCq/rt3RebQBEQYgTJtjcHbHsj8gal09/pjxYfiGFLJTAUSRrkQzHn4u96?=
 =?us-ascii?Q?+ZwWkkip9M84HFKZan2NrqOOFBgk7Ep5VotgmGLOchmApJpWigkiGWIOIk9b?=
 =?us-ascii?Q?eIHpm5U2CoYbOrlVUrROHxUBm3qvQ0NhhiqaQ3Klx7PudvVM3MGI/Fy9fDL2?=
 =?us-ascii?Q?oPvTCMJtHtiHDzxpga9CviblfAkibAbF/fzNhcYMSdCWFsCSieAWG1f4ku/u?=
 =?us-ascii?Q?H3MlMrlnoDqX6QLDFeqpkUgsLzJbl13OPWPjXdOotufThFPFBzDFHB1TNJGA?=
 =?us-ascii?Q?yW/PyWgQb0kK49O2uXLLjiT3isbcIuhCEt1HqlhduPBx1MrP7SNbKnhjRyjf?=
 =?us-ascii?Q?44fEBIyPmNjzDkLnCfastzNC12OIOMA3UNNpcT5UkucxveLaHcmUsmcaIRul?=
 =?us-ascii?Q?JannCgSpeyw8jdnb0h8FVgwanQFNCiSB8cEgpiYZa6Bs+HBWGaiMBwlbzBuz?=
 =?us-ascii?Q?USSmXIyscrvOSgB57GWqb/N66pEHzxcOtPxkjBc8wU8fmuk4TUTAbEMy7xb6?=
 =?us-ascii?Q?DERroDA2Cl0Shn9xV0hHrl0nGRE4mBJ1fk+8DSXX6F3diakJd8ex9HnBLPKa?=
 =?us-ascii?Q?TGINgTYTTGTIImxroMFCnjMF+REHjtfO8ZcHl9Hzt8osWTbtHA0NwUGjDJE9?=
 =?us-ascii?Q?0xRID6ETi7B0aKpBRfpv6W+XcT/PK/UBAUrZ4R/ty1S32rfdkvpKofQH039v?=
 =?us-ascii?Q?QETj9EyY5wnJSqDaOEedAS5lo9v2GTLhc4xCX1h/oRXMNbON+sE3Wkc6C3cr?=
 =?us-ascii?Q?oXChMDHdVFfgUUO7/91HslUBMspimwesvpOABcDIv8BFzvKFcI9VyzEgAE5a?=
 =?us-ascii?Q?CkvtMV6Qk5U1TzsymF/YwyMk3sPqYZsQXWWPBPG0G9WbeVPawu9tidLc1n/b?=
 =?us-ascii?Q?3MeexReb1PfvpuG3k5e1AjWE7IyvwC0jBNmFuvT7ZmqHwkLjEYfSn9xbv/lp?=
 =?us-ascii?Q?snus497F2RFTs+PIbCXdTc9i7W87N5tNMg2rofB1xnXzLPhaZvW50PcDcrl3?=
 =?us-ascii?Q?G3/0x/ux3H94roL0X/fet0jwLzWG6wckJ1GmwQhZ4hAJxZWcxXlhzSAtQNGz?=
 =?us-ascii?Q?R6WYf8q//iWB/1K1K496RcKSA7BSZFlBi4wBx3PYI23okLncOzYCX5InBOn2?=
 =?us-ascii?Q?6z6mQ5QDPas8leXeY6ssV7vlCU+Pssfc2A6xcoshnNkWx/WJlqjGxEVJtEl8?=
 =?us-ascii?Q?mqUD9TasaawuaTHdT0ky/oEuQloRh56J1BfYIW3U?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kN7IvKzmP++wYxX/xuruUMZJdY2kMiwMk3uPUBkgllPShqpYI44BA5Ke+eIY/5Wiv1ATv5T30EYOVTcDI8BHtSTOR6UiOW4kUgbVRVzQy6yOU25JRRg3up5IFdk7YCeqtN0pNYoohio2QQ4WFm3Odv9H/iQzLxpm7wjhaMvSRukWh9PiiP4T1GSppvYJs8tly7NFiJGNd1PME7ogMfywcVndePoI8oBXORzjdacTDirDOwc3LV340k1u4cUB4jUvVy8ehTiOIIwvO3CZlIxl4gHmDKmlzlRQO1rB1jDR4P3QXCS2NfJTK4HIA1K0noiD8Evf4biFoulA9+QKqrLztVc4Mcq2aVAuTtLSneffqjwxaY33Cgrgim0sfItJ57HkoFAStKC7guzDChoNKkHno2gKRvjTtN1ht0NU+UN8xrZpYq0YNe7QDIJNWO9lCo7/1xtBkGVsxizLuV4J8xSjydTcZ4Z4xwNuAU5fgnuzjbvdN5T/dNZNYnwxeOlcMYyP95UzpeYOoPxrgxnYJ50LuqjreQ+QQP47TgnCCddr5d5csc9R2llo3PEO/OopK3NpASXZGrc1YeuP3E1Csep1FEYSxjeo3YjXMvAUObdpWfQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf956e8-2dc9-47b5-ca9b-08de17513784
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 01:11:12.5904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXK3duXTzNYp/tLK6clzQg+Gp5L1DyaUEvqjqUDgFebyWzuyPRq0EuDocqBjfmdDKPX/i9UyOKR03UPIRmlrlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_01,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300007
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2MiBTYWx0ZWRfX7MBALrmxGInG
 +gwxgFrFHkmy2FedtTU+ieUXHj60FixQ034xl7J+roZ9rxN3YpeWZmWKfWEbQ7eNja9L1Lfmj0d
 k7MeYWSH0pR2Z1UoqBstOSqteuGrjpUisAiDgSq3inXAkY2j4WG1mk7wTp33nxIpXzodwEC6Dun
 5y03yVLhZABFrKxPiedoWW/TSPLMWZFqtpM/QXNewnH2O5MKcMy4stptRNn1zMnOZWzL7WXs773
 jziY4sgJsQEyjxKxAle+0gTAaO/g8/6jdCYyTjtsCzuavyZVWhN+SGuPrfQzTVH4QW8+BybqkZ0
 vrSAuG7SBAErI2iUjOj9/9f14bG+mfbCuQrWPpf0H1HB8Zhsz0MgctTrLwSlFvrbghPvKS5zdjw
 Z9ZaC00cy9I3cwCeIR2weriMTIwksU4kTJteAcKqllWC56lGBYc=
X-Proofpoint-ORIG-GUID: hVbPXHv0_SekAZQqxyqoleiO4qcmtTtn
X-Proofpoint-GUID: hVbPXHv0_SekAZQqxyqoleiO4qcmtTtn
X-Authority-Analysis: v=2.4 cv=SJ1PlevH c=1 sm=1 tr=0 ts=6902bb35 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pZ1mN9JGy3zALVz29ZkA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13657
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9886B180003
X-Stat-Signature: fj6fne1cwuu4h37mdh5haxfu7qx35why
X-Rspam-User: 
X-HE-Tag: 1761786685-912107
X-HE-Meta: U2FsdGVkX19XMjtH6ivWQkrvK/lZ5Lj3P3mW7jdRCRG+HozxQ9fdrbMnEvQwzBZIVX6GjiDgTHdxpPgTYPwFUFVbpexcA8WmRWz2o/THwiqfC1fiOgwnJuPlJmp0/ybWSD2vPDjXL8MuX/IeZA+5lIkGQu69XI70VEKbF/OxoKu1zkKN83hJAx94jyslZ2gHneJDBEYs0BzwHOwuSMncgD+gE+kCTz4Y965iFn+G+aen4C/TnQ7jAh4OiY0XCRRsqBpE5lO17+SjBrd4wRRo/9OjCa4CPgHhms07KOLFjm5hvpPxMI+EiZnqwg4EIPyVwdkiD/Z5yWEsTGCi2/Tf2JAa/SOfX/oTLOglB5Gt4tleWUIW37AWvFM4zWeovUDiJima3shPX7XzTHQlGiU+ZCUAiVm08Rdk4Tp/WOgReEMr+sQ3LOM4+WuZno2EwelJAPqUwzarGyJwWyFkT2s8xrWR34EKo5a4n7tq2yUWg1X4KDxvQb7B98E0NVZKVuVCh/z33l0MliYADzQwlamGjrWHXijVHXKbVQMSiVRxBx7kO9hFjkHy8KkbpXCjyKq/9vfXQWXJOWcQSLXgSyeerAmqDom4Mmfaj1nsF8xq8WjOoBh8Di600qRf+ORrMsFFEMISTxvVFDYsX9uGV0Sb8GqXeoWJWIuH8kDX2QZZN2l7sCKnjEtLz1yNyJP43tPdtOeTMfnw6Aq1Zg+tKfKvJU+3+tEtYnw8YuDKzTRep1Fo7H4aQ6jmcWDFiuI/U9kgM/fknpjXy23yxNfHNJqqIsgaBX4DmgIhqipQ5arH9VU/IR4brpXEKyCS9HceaTjTSzT4fdYAbIuNLbqCEUFf9FVOCjRdVioAWp+HXLnjMDQTYute9cF+Co8XDC57oYgCXBkZGOOkeDG5bkHppSk4WkUWzwJW4dc7qLSMVxDCP8n5w6lWyiPbZRAFGR0hyaTho9yPYvniEJ72R+1MJVd
 7thcGSam
 9f1F9LwwqlDt5dq8jagmWSjlskdzSoAifYkHSio5uPnAFSIamrBQmfrHHhR6/0VdqDwDyEgBKNbPp2aOoNcvJErut2VaynPQTjgftYQuvDk6ba910nca6CL8AQ6zMxgI+3rr8SXHxJdhOB1E+rodCe2WH8mw4C+1sLXmXc3VphryMOQ4iva83a9qeEl2D952qVhNmQhOfTYjQBVDFnl84FVX+enQPL71hmLDs+I12J92tcvdtgM9+z6HwM+JIlH1yH9Qn5aolGBNGSbIlFM1r3UoI2OAZSCRPQHSQDdzwAo/NOp9LPm7445nQ9dS49gt6l1A3eMwoZedelNOVH50pmhpf2gNlzOnndH5XHTiRGxetfw12m5It3GVZoPCE/8MYCiBpTKTs6eFoOEAh1q/EEdJ9XSUJsCciZ70n5jWGfBJU8Z8h8Ok7kFeJePYYY85Q3DZkLXQtZoBTT5q1xoSOQ98mY6eA4vIDzrFq8FMXvsiJ+v4/Rpf4oc5VuZ/lfs7CFGjklFd/XJlOdkIAdmIbw97Fn/Jstz4LSehPh/R3hrCrU8OWXOXR2IVq0pQeNv6EreRTqvPcaXVaC1uA8sPIbtl/5X0SiZ2R+24BiPAVgj0Ruv9HsOfaQ/37+0ehXK8EIrVn/Gnbi8EFoQ33JqUJear5+mRTYyJP09e+mDqzLN49FARm5K+WjA0ARGlxgQ8hdP4yJpwrmz0Dw+H+pFE9BTzZGXCKR+eueq+gKFIOdnFd0vQaKF/KpwFi8yehoug84QDJw46V0/CRBbJZ5EBRzjGbSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 07:45:32PM +0100, Andrey Ryabinin wrote:
> 
> 
> On 10/27/25 1:28 PM, Harry Yoo wrote:
> 
> >  
> > +#ifdef CONFIG_SLAB_OBJ_EXT
> > +
> > +/*
> > + * Check if memory cgroup or memory allocation profiling is enabled.
> > + * If enabled, SLUB tries to reduce memory overhead of accounting
> > + * slab objects. If neither is enabled when this function is called,
> > + * the optimization is simply skipped to avoid affecting caches that do not
> > + * need slabobj_ext metadata.
> > + *
> > + * However, this may disable optimization when memory cgroup or memory
> > + * allocation profiling is used, but slabs are created too early
> > + * even before those subsystems are initialized.
> > + */
> > +static inline bool need_slab_obj_exts(struct kmem_cache *s)
> > +{
> > +	if (!mem_cgroup_disabled() && (s->flags & SLAB_ACCOUNT))
> 
> Shouldn't this be !memcg_kmem_online() check?
> In case of disabled kmem accounting via 'cgroup.memory=nokmem'

Good catch. Will fix, thanks!

> > +		return true;
> > +
> > +	if (mem_alloc_profiling_enabled())
> > +		return true;
> > +
> > +	return false;
> > +}
> > +

-- 
Cheers,
Harry / Hyeonggon

