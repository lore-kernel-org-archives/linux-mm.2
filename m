Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05143CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 12:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC168E0005; Tue, 11 Nov 2025 07:55:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383558E0002; Tue, 11 Nov 2025 07:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A918E0005; Tue, 11 Nov 2025 07:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D13A8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:55:34 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A36CA59724
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:55:33 +0000 (UTC)
X-FDA: 84098322546.02.6C726C9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3BEFEA0009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:55:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ItxFiuc0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=E5EueRDQ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762865730; a=rsa-sha256;
	cv=pass;
	b=hh6fWyZA/jyEbxA6jpzlCt3hC7wHXACAT2FJJquqxst+FHUGH1qracmW0YZEjlZ9vuRPK+
	F28x5FpWUVZQ9QdBVometNxW+jKUI6ZWTkx95gBgz0Vo2MGjt5NY67uxQBjQtoY0tyS83E
	A5Eh0QuNfgHSWxCQiYm/q+/Qi1URIFY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ItxFiuc0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=E5EueRDQ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762865730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gedVwHP3uwb/zv1lr5ebn8AaH2r6l2JzH6ENNomjySw=;
	b=gY/Ww26wrA+UjaQW9sAFi7fcyTMh7KCF3GbbCwkp8pqTJpeceTVQaBb0Qi5tNLl1LKBODi
	4wR2wmgpEhBEYhY8YaHYcm2RrwvXPzLe1NXwjjqhUwxgrqmrwhcXma0RYYMMNlkNaZ3KjF
	tNrS6KmG+ukMhtMfCxUlMeX9uIIiXFs=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABCpPh9015930;
	Tue, 11 Nov 2025 12:55:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=gedVwHP3uwb/zv1l
	r5ebn8AaH2r6l2JzH6ENNomjySw=; b=ItxFiuc0V2+W9Hkqj54SIaWQoBk7eBMU
	6xsm2uEvbTM5BJOTLQT6jxRDjrv4ZWW3UfxkCa2obF13mo4GJ5o/7ZT9pJzsD+53
	Eaf7xjmro6t8HKshStGZ0NNXigwhXrqWPd3gZTFJl9pfh7nV5uBz9ZJwDe5l+Q3E
	0Kb07b1vbNd4VOJtH917DxoHyM8IJF+NhKkcqgQ+tn9XQZRVfoGMUkURWkZcgGAX
	eWwkIoULrN1jdzPayxxzgxvPp1VpIvfqG1pyL4QXRLGt4bWB6Mhu3AyqXd5Mwm4I
	kzzDl+VYHRgEkr6/3wRKkW4rjf6eHge99XuhFHEHtHoONxF4mkUt+g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ac571r11e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 12:55:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABCiSZj012621;
	Tue, 11 Nov 2025 12:55:23 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010040.outbound.protection.outlook.com [52.101.201.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vad054k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 12:55:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BsnMUEu7js8B6OoIlQAPTFlSM8f6twLSuAWbsx/5odYH4DBROAeuuvmcnLNBywFiN/sDzWzwrnbdZLYacGUp0J+ZTJeCp6ElnQ0lSgK4tN0JOjvxq4nlss6YG2wpRd9BsExBuJONbojpy+Ay5KOgFmG0xtwAEdvuevtrK3rf7CAtwrBEpuNL1jyfF4ci0Ry+Dhe/BEQgo/8ksWU/B2YaaNoNNPY2igZfLfkbYwgjYNHtIE+83OS444ZH+0vNTcTP5OPCU38BBqIC5uZT+55G3tsXmF8+NsG9u5OsEvOFUkWwAZNhQ7retjOI3kPWq2nq8QpX7l5EnONPEMQLXN60UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gedVwHP3uwb/zv1lr5ebn8AaH2r6l2JzH6ENNomjySw=;
 b=FkPP8BmjoxDHkz+DdhAzxCCQnDPaghxDIqNBlGa9ijFgDvxK+mjf5VkVud7PgURd3MxCeBJZxhKfIFlspcEpaQTXohiIFpYJKZkanKScK+G8ZbRfItsDwdbgyNsX4v88hzZktywoLPMRFQ+l7r5jPg+qhLN3dwXO5pMkEbnTHIsisG3+pTuvn1Zj/Ko2OhJ9dTsj2mNwrd1zLeYGvZ7+K6KH5OWIzJGxKvFSywPVCUmOfRh1yQ1BdK8VN+WUqNYSbUbt31qY3qfviooMgmrhuMuaOe6xfCmfVKAXv1upduMDZ33w/cqT2o5QNkdKiERsgnTwdeKNwF8bSOPzoutVQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gedVwHP3uwb/zv1lr5ebn8AaH2r6l2JzH6ENNomjySw=;
 b=E5EueRDQBvD9IuvH3Y7da3iGkxOoJZu+wx7veo41vxVq1VggOFcuPwdtG656FSpxnsejZxC9bR69BE+ZkoMi2xeocF8mBLrlk7/dKM7nqUZ0Pq9B4TlOL1Gp13x0oLjK1WE4KMLv4BOgycv7qwW+0cyvRhBWaYE0U6r+pPX0Tjc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH7PR10MB5832.namprd10.prod.outlook.com (2603:10b6:510:126::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Tue, 11 Nov
 2025 12:55:20 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 12:55:20 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Tytus Rogalewski <tytanick@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: [PATCH V1] mm/slub: fix memory leak in free_to_pcs_bulk()
Date: Tue, 11 Nov 2025 21:53:31 +0900
Message-ID: <20251111125331.12246-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0139.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c0::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH7PR10MB5832:EE_
X-MS-Office365-Filtering-Correlation-Id: fb3f152c-a670-4eba-805a-08de212191e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fp2UI6PQau1B/5IsXrmD1Fwvl5TDe74pW+zJCchpvAu5urSJjVLZ1lmE3tcG?=
 =?us-ascii?Q?+KzYzz+xDppm+27ejLvgyA4A4P5cvVWxU7XGYQaXEbm5slY52+C9lnHE1FcI?=
 =?us-ascii?Q?78SujUs9hKTR0WNOqlCGV4I5J21XFRslqTffKUfINcCCMI+7Z4wWZr1Dp8Pr?=
 =?us-ascii?Q?RqQ/T41A6FwI8scEPsZvgvvwUkuRO1lD/heStF/zM1cSVqL7Y2LFWu3ECSmp?=
 =?us-ascii?Q?HwE6nTb5Z/NoYZNZbvl5AA7tOz5xyb9cyjSddKhyOa06l0mhdgEufaJN8PY0?=
 =?us-ascii?Q?mUZui4UrY/z1at9uVYACR2vdge77IoQCzwPp1b0XRYGKJILPs1By688iJlnX?=
 =?us-ascii?Q?dh9iuoGRGRKQUh/3hoPEYvWef+Cu7IUnvSfGW3dyIfkHF/kRBhRQzMRH4vjq?=
 =?us-ascii?Q?pQLZbCfBffQN3Sq9Kpu/m3adueXeC4Suop0LhP7+Ndg+dftRahFs5gcMGI5I?=
 =?us-ascii?Q?OPDkh7PC7LiH4T08DYOLfP/Sskh5prwe1eXShJbwarTigJN054LcOCi92bYW?=
 =?us-ascii?Q?OVKmLaigAwltMTzUUO8XxmQs+2UDv7S//ummqidy5gpf5YF6uk3oj4IMlvoM?=
 =?us-ascii?Q?xHxEKIzCfL7oL+F1xQgZzzkDEcNj5mnYPxCMdmEAqpvpPb2u5marFRhUDXdI?=
 =?us-ascii?Q?5bgroXPuvYUVDWDDATXoZ1AxAd397Ps9YhOX7gCocwvg2LG7nCeQk1dxY2ns?=
 =?us-ascii?Q?eK2toSdedMToWVWEU6qynFuOmalP77LbTJpNRWhI5yWnDjlGslO3qy9wz8Yi?=
 =?us-ascii?Q?V7yatCvRTf5nOkMC+n1sG90Bu0rZJ3BD48IxYOpZV4/VCvqEp1+TXe5k+dnZ?=
 =?us-ascii?Q?m3ADsoXa54WTf2enU6b7hWm42hfLoQsvQJG8jRqdbehJkAHnjGwNcQcLqTBd?=
 =?us-ascii?Q?HfO2wahw/G9l8fUlFE74Syk6RrVTUsXcHx1h1sOuhhAEnLd/xnBD5MhHgCBe?=
 =?us-ascii?Q?yeJ0n5bKx7Mzh1cUaIdqEUUIGH28tvprHWHmVQPlE4SnvZiyPAIpHufu/ILy?=
 =?us-ascii?Q?okr6sE5xuLZmRIoz7Lver28InbJE2BjOi4k9ZLbasPPGdU7JjVuH3/l/6EZB?=
 =?us-ascii?Q?Pem9T8ObPVLcSctuJusZJx0johedtUbyWyt4IaB4UNJC//Vze0tLHdvzmKmu?=
 =?us-ascii?Q?jLAXV9L+WqzloRa8c8pI6fJ87eKMhny/La+AFcVPF1q+rQ5VyvzXFWalbkch?=
 =?us-ascii?Q?tlDStxyWmHi4H1jC6gwiqRYPF0d8ma7qfgKSHtpw9WzUxZpN5ID3ZkHE03+G?=
 =?us-ascii?Q?+lK0PD47hMU7nMXcMRik5I+j8gVHlB5JA2ja6lZify7lE0BmR7ze9eZUW/Uu?=
 =?us-ascii?Q?Ij968AXA5g8BEGzsVxLSRC2L7gu19Hi6mGa4Tjm6cGV5Lda9gB+te9J+aqQ7?=
 =?us-ascii?Q?+Ud6ymCn+4QlwL1YLKUsw81tqyJ57F2GNGr8fm8Jv0ghMzS351ur5KojW+Ax?=
 =?us-ascii?Q?ICviK4QsDk0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bQOCW/49z5xMWT9yNrHDrNz5frr9ZJgOFXowksG1X0pycIDlWmkhMOnSQVYF?=
 =?us-ascii?Q?/y/qzsx0S0f90sow5eN2paL0SwGhDQnzbjD1DvIlvb/qRhB0inYaIBSeHxtI?=
 =?us-ascii?Q?hLlnxhyEJxHSQUnBEAGxniYnM63E8+OQ0k/O9SGgO82N/btx+ix4cKxzehoj?=
 =?us-ascii?Q?dNiE8an0R+CJMKWRMZVbjK/S/s7hyg7+R7ngR4VI4dYaYaZYmhdhHkOr344S?=
 =?us-ascii?Q?s9QgjhoeAuSvXAgPE8TzGfq621ibn4taYk4Hmg8ONcDCp58Zlu4mbqi/UtGY?=
 =?us-ascii?Q?K1ZkI7TlhaQ5bS3FOToPzA7hqPJ968mZ5+bVX99wNk17KFlziuqyX2Af4SQa?=
 =?us-ascii?Q?/0dGgD/jAR2/XLQ4o1AcbOfzIxFL9zYFTi2HAg5ISQOHAz+airpdbuEWkvf7?=
 =?us-ascii?Q?axa8F+fTKyJISJM4A7UbVXqVudVIb70ku/jOh1c+h2ZPUgaidB4vOF52xDsL?=
 =?us-ascii?Q?aC9BTCbrRbQCG3hn1m8mVB7JAhsupP4vYSe7tumBZgjpuQteIRFyC4cI4RWU?=
 =?us-ascii?Q?Tw6ldpI+PxF8g8bpl3ShcglSAd3V85KWBTu/RhL5Pk3HL4DSCrc8GvIMv6D6?=
 =?us-ascii?Q?mmy8Xn9gItwuph9YMaM+dpTYjVi94zWcJlaeB1FDdBnaVx4D0hAzaKVn38YR?=
 =?us-ascii?Q?fvpSEkwXSlA4XhVOPPwfC7FNJGsvpI60qkIXb2LN8Ysu/EPsctN3QEuth0IB?=
 =?us-ascii?Q?YyT2lx5t+iEUfsba/29vkbL2vTwdRVsoYyV7GyIa82KbTkNBEDqNeZAybym7?=
 =?us-ascii?Q?9DQhKms0WXBCyOpN8g4luzBeutsn4AraPAI5H3Eq2a502m1fNh2+WtnYQNNL?=
 =?us-ascii?Q?9HVBR/dZ1cKO5pq8V6226mo6at0b1+l6bzs03N5FIIT/7dYjh/bXOD0HjhP4?=
 =?us-ascii?Q?tTUWv33y/aNHIYg9eEx31kHso1R/3WpfH5TSETRdHoNzU4Sa9ljum+DGP+vY?=
 =?us-ascii?Q?uWXk+47BSksdvlMR+BFAWaYFYYSk+jSa0LyucoHPJyNX1MExWGKpmnB24953?=
 =?us-ascii?Q?GNW1tzxb6OYe6D3nt5d+o6uPogYp//G4TJjnzxY/Wdxta8H0lv6grJUuunjV?=
 =?us-ascii?Q?b9Wnf5cKkZzyxi7cdnU7sHK+3RU6Rl1AW5pCsi8XZjH+2Ufc4qqArTuYd9OI?=
 =?us-ascii?Q?Eypy/sqN+vTKBpvnCracp4pWHE6+7Xm3dJ2eySmxh7UxqtQ1GELmpinD0iMM?=
 =?us-ascii?Q?2sGU4F62OygOIpRcsncPtgakSkx4n0iWOJUaKw/Dlx1ArQRadnX0DnTHVzhC?=
 =?us-ascii?Q?OvlVT5bxtTNvF6/xCFivkVMA+c64b414pz36x0fkb5LvvBKM714ScP9RQrbY?=
 =?us-ascii?Q?6eRnD49FX+XtoOyemUq/WL6wLLV4AShFsoVOMj4CAJGTP3vqhqSjeYppdkFx?=
 =?us-ascii?Q?+oshR/V1DIW+8zIiAgUV0Ha6lf0eivvLffvwI0KvMxUFe29Cvlv8NL9OetJR?=
 =?us-ascii?Q?UortqB8F0f35uThIUwGNwrj6jPmEt/yOZ+qxJKkiJohA/VpFYlhWu8mETANJ?=
 =?us-ascii?Q?cHUsSKov5DLg63739zvF60s/G5ViuzAHYnrlPRGYISoiz1a61oiyKmGi6R88?=
 =?us-ascii?Q?11Nas6hnEWmshIfMSxJeUh2j3LqwtOmq+uhcfWvV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LKflmR9PiMpWI64ZT3EmcllfeqLpEH0SoBij5aCjCb8KwiXPgZkZT3Et37mB4YMRpjGA6/z52n+3+Uhvc6vx3H5M2DTmiIKGxixfyhvm2ehHq8pWEkZ1y8nNxGIy+IOvzljl240DCIENWjzBinOMblYCWQt1v0XruaouidhEoFQN3yu1MXURRzOHgkn6gEZ8GqDafwRtj4f881KAUcBrfboyqJv3uayVd5qvuGhUnjPDG+dfLnlug2iFNdwq8phg9eJylSj9zYSAYgaNq0ASsPETfMHYHsR+ILWzlmDwOpppmCIJojcSbQ5oJR1PSrEPH5+7DKblM8xq568ca1+q/M7U6cHsA/XSFECb0WwFrIYWOZPACXKMRWRzh+Eu69znW5FayTKU2HjdnvD6V8h/8VPfw+71i1f2cJbnrVMqNVSBNWd/9jUGSjS+JcMxjIKengZ880StdoqL325YQj1ZRVNzTdLcI90rtg9RP1qMSRPIM8h0010WHRskMrm/WhaKNNZwdUcRarkRE7l+4K7834GWgWeBh2NRAuc4yLbG4IoP2rYrLOvax/7CkywY35IOKgSB30blj5Mw/PowiY6IC7eJlWXG80c5oQhvnecYtug=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3f152c-a670-4eba-805a-08de212191e7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 12:55:20.0276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +89O0s/vi8Aor3yYF+945r1S/c0/EydtGmIR1k7VCgXzLwQ7ZxT8ssyVHkbWmwtZ6Yk+zsrJC0Vy+QBdLQEFtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_02,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511110103
X-Proofpoint-ORIG-GUID: 2ZgV-29_1drpBW24bGytsohtpzt0ZRnl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTExMDA5OSBTYWx0ZWRfX9S/PJRecjUXX
 CddPf03FJ99WaVzyXpseMqVox1mH4bYZrO0WO6xBYxKQUH86wdEAAfUP0qgRJbAI7G6PwDqUr+v
 pkrESVc2O9p9MONxyLN3nhCZv+yinm92HvZ69ZzO5gDBI4poVkfByPf1RKSLwKEJ6KnZswGnM6J
 ZIjc1egoHhPVOPDVu5e14v+yx3y7GnydR4mIwGVQJAbQ1QETEzxIU/xTwB+6YKXE4vJzPFvjctk
 0GMwFU/51RGYvSSHUv+qZZqwt16e8ZZejVZV20RuoQoC4RMpqf1QbvUIF0rGUoUEpJ8ceLEsCWG
 cC+9W0kgxgaK24u3nnFQM2kKxtBRw7ETncG3ts0o35d6obvF9SyCmJERJ/3TUsmDiBT2i6qCzOZ
 6bZ+9ta5U0+H69LCIYXsDWLRBsqSJAzNQW7JLZ8pKAHPdtnPe2k=
X-Proofpoint-GUID: 2ZgV-29_1drpBW24bGytsohtpzt0ZRnl
X-Authority-Analysis: v=2.4 cv=Y9T1cxeN c=1 sm=1 tr=0 ts=6913323c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=2Ysd3pv3ZpWesbIp83QA:9
 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12099
X-Rspamd-Queue-Id: 3BEFEA0009
X-Rspamd-Server: rspam07
X-Stat-Signature: thg8mift4amzr3di4dxm97o4qm46rm45
X-Rspam-User: 
X-HE-Tag: 1762865729-942747
X-HE-Meta: U2FsdGVkX1/rNJVIjlDvy8/fOOM9BZKq42/JIBxkyH/4rSJ8CgSlOs40h20c3SZm3uQ0vJv5qvGlzWZEuIXHMchpBGbS6b4CChXoePFmkX0mSzLdD/ZAWYdJ4DinPNrZhm7+mKB2xOC1yDhSj3JqHqD/Z+B5KyouzvYd5O0aGCZceGBb0Me2T98lcionbKaD29Bzrfh0okT0E8Ga8BAY7z2a/TRcQY7qVcYEBy++1TN3UuKy5yQ/MTUdDRzhbVxkw5CRCJC1mUf3oTjUTBZj7oXHtgLB95OS3Wfe15vWvUkw+EvltXcG1JCSz7ictiVMoeGIq/OD4nRdkACHhksh1zSObuB4UfOrNqsn9f6IWM8aaYpnBh6uYUvVnSVo3UvVaL8cBUjJ0w3ewKRHp0jIENZzAPkvTFULh20NLqIJBBnmICOaH7cuMZbYArY1xLbvGaaDuwXI9XTw7BsT10yRuvzz+H9tfuDoOdUfD1Fpm230MSffJ29fpPXS5uA+8gm16bDRiRbj+1DW0CdGFOuEnOySS9KX5G+OeKBuyfKC74AXfDkMaRrQyAcIO4oEjcygqtjxhmvOfkjrODU9/So0XiTXsQAasNL485mDszj2jN5ficuoNXFIHwq3UbtLmdCFECH36ucOoGHb6pIlHiXG6nwctvWQ5MHXHtxSNsv8dPLpuJrsOvHF9tywXJbCtmMTVAtihuOv71GORqiHG30vpb/lYAKpyxWbBR7RoVNyeBHVS7f+z8HEK4e2zFrwgL3XXRK2JsMTGlwZ6zrlPF9orRXDOp1tiXyF7WvtXL+cXhXdd+46PGrNWhQ2FX/5uAyH0X/RskRbE8wWg/CEx0ngpcmU3P92X3A3o8bDoVOJSgnjjt8FLV4wZmtNfiKDoC+CfMh3v+psGSFNZUJVsr5GR+KdY46YpRwm6qmOFK29ZgdwFX6hcsDMb6s/GRaoUzR1ikUEdxOwqsxYbrOSCYo
 LLM+Ov7d
 1Ip2JdMO+RoBMUz5gZ7hcHRmN4e0wfCxrLTdfCazqH6c85ZPn2Oh6MRTkb9bz41pVe6azSLQmnXKxT4iKAWKR/ks8gOF+A1YqFKneAtsB8AXyOqkI2VDMAFcFLjfYMfkHvGbO8cVUXpPzHAdxWKfSdihjFGk9vmreSbV7Jw15BecKSbhHtZOqV0Mzt88H73MaJhhyzxx8NRA8O00U3XTtgIi5dm/TDybG4kvA9UBROztfXA2Dkgq3k4kMMMcQmC3pD+ADskIsN5UwCYwS/V5JgahGq7S5o+MJl3UUbcGE5qWdkLwtwC2A35ed+ADJBt3EL4gf54Rh+4llcjCtRwDO+9CbBYYVN8tlC+InOPLGQL1u3j46sfZI3xsHTgh6WHTvgHOZU/Aj3XI34e3z+gctG8I8D9mlkvVFTFlY2+pHmOrTUiObWHqTCnwNeTHdXQ8VEKICBJtvbZX8r0i5qNIC5cMN2a5fzOqzdoARWNC7T4g5ZV5gmoJZHvQbzwL+o2NkdwQS+G18jzcSPoHCAQR38ldaTtSzlcQiFUEamOEXueN9GpTlbSjKfvagBnW6xQD1rdJnSCAQYFPu390Vyg3bO49KUMeJe5eWoIpXasguG43aF61xuJqkNZP4dtXSzYtZVBQgwAon5CfD9F8moOiPvWFASUhFEyDkGroytHj7Tn+MwImpBoZsEKc/QpwyB7tWzwjgysXJtmebJJJrypp/Xifkj8dksnKkzKy6f5ptEyyukIeuIWoQBIy6DiVtpXiosVMNHhwMBm3OB+FrNdAyYdY+CM17iw16IMbJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The commit 989b09b73978 ("slab: skip percpu sheaves for remote object
freeing") introduced the remote_objects array in free_to_pcs_bulk() to
skip sheaves when objects from a remote node are freed.

However, the array is flushed only when:
  1) the array becomes full (++remote_nr >= PCS_BATCH_MAX), or
  2) slab_free_hook() returns false and size becomes zero.

When neither of the conditions is met, objects in the array are leaked.
This resulted in a memory leak [1], where 82 GiB of memory was allocated
for the maple_node cache.

Flush the array after successfully freeing objects to sheaves
in the do_free: path.

In the meantime, move the snippet if (!size) goto flush_remote; outside
the while loop for readability. Let's say all objects in the array are
from a remote node: then we acquire s->cpu_sheaves->lock and try to free
an object even when size is zero. This doesn't appear to be harmful,
but isn't really readable.

Reported-by: Tytus Rogalewski <tytanick@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220765 [1]
Closes: https://lore.kernel.org/linux-mm/20251107094809.12e9d705b7bf4815783eb184@linux-foundation.org
Closes: https://lore.kernel.org/all/aRGDTwbt2EIz2CYn@hyeyoo
Fixes: 989b09b73978 ("slab: skip percpu sheaves for remote object freeing")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f1a5373eee7b..a787687a0d59 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6332,8 +6332,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 
 		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
 			p[i] = p[--size];
-			if (!size)
-				goto flush_remote;
 			continue;
 		}
 
@@ -6348,6 +6346,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		i++;
 	}
 
+	if (!size)
+		goto flush_remote;
+
 next_batch:
 	if (!local_trylock(&s->cpu_sheaves->lock))
 		goto fallback;
@@ -6402,6 +6403,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		goto next_batch;
 	}
 
+	if (remote_nr)
+		goto flush_remote;
+
 	return;
 
 no_empty:
-- 
2.43.0


