Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16DD7CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 02:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483AD6B0006; Wed, 27 Aug 2025 22:05:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434018E0001; Wed, 27 Aug 2025 22:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AE416B0032; Wed, 27 Aug 2025 22:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 106508E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:05:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7193BC3F5
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:05:47 +0000 (UTC)
X-FDA: 83824525134.11.5736D57
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 30BE240003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:05:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SLN7OE1r;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="rFLOIeg/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756346744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vWzQlP4oHmFw8yfyDM1k061QANxteHKkFh1YwMVnNnA=;
	b=NZg7NSumd3GJpD5psQR5ExUCZEpMpcCohqS7pbwaHjnwgORmKrpPb8Vr6SIQ1+5zJK65e2
	9eSk6LfQJaRqZRkbpdIA11oWgT9VshCqVx6wqMv6Yk+qAm5QYyQuuNh8Ic9709Vk5syNYi
	niaQYjjo3flF7j33vdiM9CRqt8bLDFo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SLN7OE1r;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="rFLOIeg/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756346744; a=rsa-sha256;
	cv=pass;
	b=CT2KoNBFzXKOmykXYndfw9noye3F5BxOCf6revWsuDALkf0mAfAjY8ZshtrwLTxLqOXqgm
	h4G1TD41MURAUob9Mu3LkLm7DR7rBoQo9DytYwQdwgLqYfW3pVSAXOkwWdXJfS0opyM486
	2VozvjsU5SY/vLPdEDXb0Xc90Q5F700=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RLHCOv001969;
	Thu, 28 Aug 2025 02:05:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vWzQlP4oHmFw8yfyDM
	1k061QANxteHKkFh1YwMVnNnA=; b=SLN7OE1r1mnMcQfEhHAduX8rJAZmJY/USg
	sSYn7l2Clt5uHF8+vk3fszp+otfVrzcH2BKD826fVkLL2S3AfY09sJt0LEteZF+G
	IkkD6TI+rQM+Ei7Zcit6QVVRNdgJ/qFvbflSO6GTnkFizkD+GOpdHb25SFjlPyTN
	UBtdRhgA6IJU+1fR/PuhH/t7vKeDmAS59NAFG5oWNuiz2GWL71R8cmGWPRro3weL
	SrwTpYzl4bwUYbVsRCPJQSn2+GVZqZH5ioZ9wM97jmCkVEFhe9o2W+8uTxjaq6lb
	0efPYTAArAbOOH4AYDVZr8555n+27U822dLe19uYw4i9M6AuRSEw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt7quv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 02:05:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57S1Nc1Q005292;
	Thu, 28 Aug 2025 02:05:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2066.outbound.protection.outlook.com [40.107.236.66])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8bj5u6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 02:05:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gfvRf9Tp+lyNccEWXIawwdhZKl7Gx7EsDTGwS4Xbj4HmBzG2rjCMvHg+KYNynfDUKZrbDRrmC/mj5XaOc9cskU/211HuOzoBPYcGtK8Ema1lBnqd0d/hL9km6aL5MZIQSr3HyYtqcOmI33WNjHih5p2xrTEmyHJVGOy9jOjCwzeaRezhl16IiNtiUsjPDwlsL6V/Lgkekd2dE4ED8v9MWOs5m8FgtaYpVxSxQpjpCuyAF1ZpmX2lU9aPHgcHe9CpYAXArT0PwC9Ss0axEfoZ3mCOPv4XtK59CyyOKZdatfXuyilvQGYWok+iHXRwr/J9mtp6rylN3iO2zx7HR9qMkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWzQlP4oHmFw8yfyDM1k061QANxteHKkFh1YwMVnNnA=;
 b=YjUkHCWGKBTqTFjezVlv+ihfDDeNmqqnGCokBZuLVaVjRokx26+z/stmhhlTtPd5oGUxmjpg25V+9HBxSOyFwMmkFgbDYX7/8OxkIjYtqaQGRTIcoJIG6NLos21VW+NdCAftmSBOTl8R/6UwjvMW4qOd1CnE5oO1D/8Xw7jzmC5WwwTmX6oNqdR6g6Oj4dF8hugnuY3d9K3i7JmHnvFTKpg4cEB3fHtoXeFnjx6K0LZ9uC2sao/8idh/zCEgVPDoCqhaEIwv3cELISj6Xp17eg0V2w/z0buwPaNhZUMkDLMHQGeWZkaAQaTIdh28s1YzRnEFKjOwNGRHtqJnGjJZlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWzQlP4oHmFw8yfyDM1k061QANxteHKkFh1YwMVnNnA=;
 b=rFLOIeg/MyjkkfmsXSZTYiFk3f4CNP1te1j5bS08bTPWtdN3a0bdti3oZDDoObod1nPKcTrRN9CVRyKNNCW6Maq0sgRtAPdcYz3gHDbX0k9YIBriNcSzX0kAEn4z0x3Sp/g6NvHWh0DZOwRQ3iGW3msMiMHIcWVBpEVufKSIQlw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM4PR10MB6087.namprd10.prod.outlook.com (2603:10b6:8:bf::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Thu, 28 Aug
 2025 02:05:38 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 02:05:38 +0000
Date: Wed, 27 Aug 2025 22:05:35 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, jannh@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lorenzo.stoakes@oracle.com, pfalcato@suse.de,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_munmap (2)
Message-ID: <gbp663voo42lmhht3mzhxrmxyfwpdwaion4jz7symvuj6xgwhe@e6tektpig64u>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com>, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
References: <68a7eee9.a00a0220.33401d.0168.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68a7eee9.a00a0220.33401d.0168.GAE@google.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBP288CA0001.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::14) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM4PR10MB6087:EE_
X-MS-Office365-Filtering-Correlation-Id: 56ed8c45-fbe3-400a-a9be-08dde5d76205
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qIG2O86qZWFMnnO5AF0OOMvrGVN4Btp1CRgWQ2f+v0wnKgJrXQ+msYCHR/af?=
 =?us-ascii?Q?kyndK4ve26P1NwyrSP8aSrAm5cayuES5AQog1uFRXSRBTcwf9RuOX2EevPky?=
 =?us-ascii?Q?4w7C3GOkb9pc8iWpMtfWavwyspV/l4+c4uuz7/+1v5ai+BZSh5bHvgHG/xFE?=
 =?us-ascii?Q?btaHopZNEK84EohLxjIgCz9jzbNItIlUlqhqqlfLcK1JCgKN3eYCzTJJhC5l?=
 =?us-ascii?Q?TVstS66hUaSHb0HK4Dwra+ZoSvPDytS84NBCgKEFBrVRtLd3ZRBqmWdgDqke?=
 =?us-ascii?Q?gHUAHBgu3vPnx4mLVmUMQMjJUo2BfKIIU9S1YGtYI0c53EmIWBicY7ODzozL?=
 =?us-ascii?Q?YBkADX6ID4bU/FlBGBM0A1vzO8kk3fNtTaiYor0LPQKs6PCcD9l1al8ahOW1?=
 =?us-ascii?Q?dnAGTFt16SqPU98xnTJ72bRDTNoFpzFeAKeAKOHXkgzY/WMCSk3qlSfS2ezZ?=
 =?us-ascii?Q?Cl9vXdNVqAhfjpwqMpCRYcnn09bWdAfgJDU3X7uyPfaIETXWCkYUuiI7idmK?=
 =?us-ascii?Q?rbDBYoO1nRP5WcHYRJQXJQGqZiBTtdXSEaEZrd9X6pj0LZXu+cZ9Bt/rkhAS?=
 =?us-ascii?Q?BnDjR9RsJWKV4sLF2OkgikwE/K0Il3WfJVKKe1xS8UijaNQfKN6SPjS8fdF6?=
 =?us-ascii?Q?clVQ4H54GWmIcatPAOLLnCjdfWKIHjxd+t2lNf0vJoYr8TsVY2EXe9qDSdEg?=
 =?us-ascii?Q?zDuWf/jWaohGcP7zgClvappqCfzC/vM50maqNE+UbnqmS1mAdzkoIchFhjbI?=
 =?us-ascii?Q?KA26ViavSf6nMEd1caiPPRggukKcTWmicSYgBHz/fC/Iz4heoIYOEP0Aj5Dj?=
 =?us-ascii?Q?PhGQnyLj0us4OFhhyIFa47RWUwULUTEeeprklhxVG3Rh+BRmq2m1t5qfI0OA?=
 =?us-ascii?Q?huiK9diVtRr03iHv7OZ0iIOsSsvejfKYHkqzZKE4ORLNVH8L9v+DaaLHKGXR?=
 =?us-ascii?Q?B2p/wcf6pO85auOpL8L7977hXAsNKPPbK5eyKiwRSeDoiUjy+M1dKgP/U7Xx?=
 =?us-ascii?Q?NmtpxYxj2CHPQC0ju4NxtZaLP9oPe5ezaowOiXYx4EpCMVLJZTqZHxxFFTeq?=
 =?us-ascii?Q?XX4qvuvft1l2n03oD+swuYaNmHMHnJz3BsDqStsfiVlLah2Ox1sLIjVOlmS9?=
 =?us-ascii?Q?WMshaoSZn4tDoMRffhZiqnw2UFXCrpnVbhNteD/vNVE+k2+R6kZEfbUvkMl+?=
 =?us-ascii?Q?ZIcCiN8ywfjNT55zW/WRaIpNEMfa59xpT7jrcBBkWgVIbvImYGXXfJ76cppO?=
 =?us-ascii?Q?JfuLL+PwwAVu2pnqH4owcJU8UDPAtBHxWwjpwfqPJxkCHem37tQohkALIlPC?=
 =?us-ascii?Q?2os3Dkb0Zf+676e7YDKNOs+zcFSHclGrnMEnrnI5tgWZRkHIzkHusV+IBhb7?=
 =?us-ascii?Q?6lUsw9E2+kBJUZtNmAvb4DxzZUR6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q5+oDBVojTSB13RNkIknh/sKUdOFkMXLN815WUFsXEAXVfGesot/1s+qAJvr?=
 =?us-ascii?Q?64L/TYkZ6yVl6rqI35/wvhD8Nle4vAI6JBF4RXCAx/0P408TINa6Ygw/IuRK?=
 =?us-ascii?Q?NRiQQHaqUQFX0+iOT05LaDfYmy4yVX0HrU8haqXMavd03GP1st0v/AtNeeDH?=
 =?us-ascii?Q?0QK0noix0uqErPFh9rVVdt8uXGTGodBgBbeWjTtM/cB45X9T1N80qFkagdBF?=
 =?us-ascii?Q?Dk369WTIv7j5x8F1QCyOnNNgLqLzPq+ARaTIPUDi56TzVNyPKlle/k1ZKo0R?=
 =?us-ascii?Q?kBZROuOMvIEUtL5DlyOrrT6JvCB0uFqoSZwRCM5Vuw/QxJ36fZX/hzkgxcba?=
 =?us-ascii?Q?4UKQ6o+lAorJdQ00sSlOirffF5XDk+IZrdw5gQpH9AFI5PIcbwb+dCSgS0ej?=
 =?us-ascii?Q?EH4UuakPFJ5Axt7ihJOqA7yjymmrDzjtQYuHPrjh+m8IoiKL1CFVoxZKsABh?=
 =?us-ascii?Q?a1hE7TCIc63bhfQLpah7Dyu4l7GzFJgBoEs9NAX5qoC9/vjMk7FIZ9PiQDsL?=
 =?us-ascii?Q?l6sY9tACUUaFaKCmWTuAL5kuXYbP9cAK8XiaOTLNx8Y9v/+4FnM0hPJIj6ld?=
 =?us-ascii?Q?RrVmWdINdIO7f27YoARul+/xwrWZcy8m029YirmZw+6rhF5J4/R+V14E2rQl?=
 =?us-ascii?Q?vgf7M9+/kov1fyuvSVfedyrO9dPM53M56PWT9npkBAaIn4h26vz5iH/YYdhY?=
 =?us-ascii?Q?zehlgUMrqjBwhn9rB/kI7PBRksgXqQv310sU1xdeJqPqLPFJdpopLD7sBYU8?=
 =?us-ascii?Q?nC37+B2/spR86ptH3/SHY0SVYnfdqgKoQf2H5PqkdCZFd8PGS4b/JEhxRXiA?=
 =?us-ascii?Q?CxiQ99nyuFhP24V2pkVYhfFWzHPTSr3s0hx3J9F1Pf114dQRI5z7Zy0Pbn4T?=
 =?us-ascii?Q?qaK3+tB0KSIAlfNhqFk+egdeke1KWKai1hfZG2zc9nz4s/uVFjUY3s/f8TPc?=
 =?us-ascii?Q?3bsn39nEa+gW01ru4NQor8MOhCaiWtNZ3kaCcBLdF9yHOwwIx48ckBdkJ/Ov?=
 =?us-ascii?Q?l/LsehAOalG5VWM/QVP40ymomuilVN/X8olNcWEzHO0lVf4mAJB9zH9qVtDa?=
 =?us-ascii?Q?yfiuUVaIj9jJOsQyKxi5ulNzv/Va+dR733exRFHkwoda1oC0OOvLg7EBq9Ks?=
 =?us-ascii?Q?iz/mzrSpftUa3oJXavk1qjpDweoUjj8P8nAsWejUmcKYDD7bH19gfe2/sTFc?=
 =?us-ascii?Q?bB3+o2T07+k0RzgWaEW10B/OU4ixYtAiQtid6YwB+/EyXgo1DsKGQX7Ih9LR?=
 =?us-ascii?Q?1YfhqqmnQ6i0cBe900YLAeOFMDmBw/yQGFpwDNUzk7RuHANZk/IVqobrKXbe?=
 =?us-ascii?Q?kde7jJ4qw3s/5faYsMbIi5dSGmYOvUkkdNwsPRQFsOpbP3mXIMDvp8Mgoi7r?=
 =?us-ascii?Q?3wM3Lq7Nth6QbkMZ5JUH1Ka9kdjT/WwcqexwrXNgGy1ePjGz+AAXmp6qtAJz?=
 =?us-ascii?Q?wtkC2Bo4DAammMNxgN1TLWJoKSll6CJHcBIUant89uvrR6uo3a6Y6E8Ep+gI?=
 =?us-ascii?Q?69Q1xo3rW8gJQ8VX98NB+4QWh2x3N7STEVpnODghSRyllhaQWpKkRAry1ayq?=
 =?us-ascii?Q?m29HQP8QwnCU+3A83QcIYsOLfdGYX/q2b9hZvO/XyRltS5EmqXGEBG7aSmdt?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rpJ9trwWrTUFY0ZknBNPTMGmqKicirj6oRoVZ5GRsjQea1oxJvXXjr9gt5Ud4oiO/ERvXmkhKBrUZWl7c+epR+lwkxhMUQN9+Itlg1bcelHDnd4M2jYtUUPCjphbEe73/NChyeJShVKdxOx0PugajtHdb7+mUTVICiQtlR2BfL05DMCEhmVawEoYKNrfrTLt3mMFOHcaz1k2uqohyQ1AGwIPSIU8ia80/2dvxwbduvH75pfI2Px1Uhuj4DMVhFjg/1o3/+o6w4hSt/YmVFeChalTLdX6gApZUHueiQaPRyZI1+lYu41zDdMRNafhJlpqYOumbz7Eh8BNLEvopRyvMcyvGZFh4Wfu8z9RW76/XB+eRCqiKl1vAkoG/7f4fjGfO88YAVCv9B2eAegc/xcDwS6dP0FmcOvEeR/+j8eiKNwcw4bQpPeBZ7CCLkzqJcyG/hEE4CKU1bDrz80TvOJ3drDVUXmn1B8HcWfkm757ttNjQ/4hl386P0152fxCAHJb3mBnm+OravgV8rv83Mm42rXZEtmMBBICOlNPmjtH1ogtAitmsMyMk3n+Wzdi/LIx49itYnGOHLi3A6QwY9dgroXMZwXfcZT6l2H45Myn+Vg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56ed8c45-fbe3-400a-a9be-08dde5d76205
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 02:05:38.3851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDJYJomoARSgE8+avlsd6e2vj+pXGn6Gg/rnyuvrP9/H9pIXz83bhgUKQx/NEQqB81RiqM7o+3NsXcHA6hm4PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_01,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280016
X-Proofpoint-ORIG-GUID: O0OtH_4dPHgfbVTsI1P6NeNqxNuKEPu1
X-Proofpoint-GUID: O0OtH_4dPHgfbVTsI1P6NeNqxNuKEPu1
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68afb975 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8
 a=oHvirCaBAAAA:8 a=hSkVLCK3AAAA:8 a=4RBUngkUAAAA:8 a=DSZvekaDx0hFhfe1CyEA:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22
 a=_sbA2Q-Kp09kWB8D3iXc:22 cc=ntf awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfXw1nutDv6lTfS
 WP2AUe8Di0sl+DCXL2QUmnkTr3AU6608UNhIdSigLJlmPa685neAPw60up3aIuo843xi1gj65d4
 eAz9DnpMgtG/Uv0XhBvjJEWBzjRF2xQ2oyQ0d/KKn5pvDOJKj3DjmxnT8GXv6lTKhd79Py7679k
 7xTlpx2ZgwC90ItVgkoU/tKRxDlQy1faVZ0z0sgKbYr1jOMjfhbSOo1xVbAj9O04eQqUr1FogFx
 WnBvI3kP7Zky/iZ9s6sKDzsN4Q/GbUR8bDOwTQD5RAr/ag7cTXdM42ay1bn8+trwIs2NPwXaJRw
 R2QXiJDJUmdJa6bHMOmsrroVfehfnzvcv3EFQ38uYGycbwaxb5aSt431Xna8Kziy4Xj0zljuv3f
 109YflS1qYZs4eKXnX4SPAP5I2kZ+w==
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 30BE240003
X-Stat-Signature: i34cyoq58tcyqsicw379ercisghiup6j
X-Rspam-User: 
X-HE-Tag: 1756346744-756503
X-HE-Meta: U2FsdGVkX1+SLnXcjNR7NRTScH1bOti/lD3ThLvgJLOByWMXDvdRBoGUDAN7IG+33pYlBz1qiorb0dEZGWUJpCB5dyKoMVByXCcVhCYAO76//bNO0D+pHk2jpi0YKZpeKBsz4mv+U8/kj2+I4DbIZLIFPRIg8700+IMIQ8Q+Yrr+i2siyrEPJnEXnUA/f+CEZuFSfHnYOiqSvw1twb6qWMHTAipdN4Yiw9fiOd7eF2Jkcc77YUDGaRrtalFxpNz2/02zxvMczqU5g8FvB7dmzlPW90n8P88lvxPSXwPlgkNrLkw3WJDMcx8uJ+N3yhYhMECeCCjVvKsmxKhopemEGd5QKJyEUBE5BZFZxtHwcdsHQPENRJS2VpLOtZKg6gmKHSSLCkBsnhq8N2BAeZPzHr+4H/qxJGl2D1bVIjNXjTKgY+eB3ys4WTuv8OZ0h24gZM4ONzue8yhK77DMMk8m7JLTnGHP7Wz9XBO24ztm9G0yLhpW49Gl3etBhbN/6vBJAAlNjZxR83UKVC49jHV8pW7hXWxnVbfUaKl9+pfsJvFKbP8UuNYBwTjyeyOWYK5IAW3UubIO7nlWdd1bSBHOwoya4AuMpgrxfkkN+zJTIeqNlMN556+rG/3iIZdqj+rNI/p9/oWpZz13RiwWpNbd+//lBAfzc1pGbJMTA8YPZcUeq2bdyq6HeVEQ1RmQkQ8mItLledSby8mgThmd8HFPT1slSG6WP0oB/la6MDvlqaMrmUws9NoQZLhR6GUx9vlpHe/wEsoaub4CxK0I3jVAAQRJHbit3bVGUeq+7kGEZ6yHz30g/BBwT50cD2P9jIFSjGpBMrDPJGt0eZEgQd4CC34G2mts/ln/PIKESMwIzRIO7+V+3LtuyqPORgOKvZv7XQ8sh1xqn6gye1VR/XpO4SJzRe/QUAEmKGOWIvi21Bggm7aqcnwBoSPS+5GjHipeRBH6An4ZTbBnTdKh2K+
 2rDspJXo
 pyBLKWUr2o4lC+Kcj1rWu1VVDm8MdQ+Hdsk1Cd3fUAnssM7zvOnpuHgNhxNn9tPawggjjZCk4ZbPY8qi3vbJ8sVEaPLMTii7SC5qbNYC7uUxrl5Pc3845/84HC3nU0OJhpyNZ4JrlNgWDuywlLNY+kWQYJq/MKZ7XTENh9Kh8E9cqAu7sSM3QSDbqibyAhx+ZQE+C84dpXYbhUxuEJT9BEPSMJa23CzsLu7/2C3RK8p8tuaBti3nNxknU76vYGVGlXNbkbMCuXjVdefTK0L8LBfrQ5h7Hnw88rkTCOsmZcaZMnX47vn94J1YW3/VMvZ7zgAKj/kME559AguMis2Q0v+EMFtwIvhCqUlS3nESX27DL/SyOlmFIwUiQIzBlU0HxOW/sUxMHhvik7lfd2ILr10sQepi/9pa+yK8c1mCEtRGoyQvzx4glBH/qy35EblhxWd515EFB3tAizG+PC9isLDhgt0oZaVlLra4wKniSE+QBZiVQxthlz3NYQXM5oQfRi/wrhm2jeCq7DyIMNYkQI/lhW8gZj7fACqwBIgKj9Ip+xyCb0k5TSQC34RMssy16oEv//w/rS2yT9A0zzkRFn4DBKQP1K5kUAFx0051H5Kd3y2Bvo2DLZ1+2J83CP+5+HXn55hX7l2YCXW68LoUoFx0wtdD4QrY9HyukZSN/L67xktyDZxEiQlhcnFa8MEPrbEd+h3TeODeNLoQF0RtH1sJlU2E2bmL9RLr9uGQBUuBsenHYWzFOFOtG7NCjIV88zKgYCQcTDJj1N1fSMU5ZxgaxcQD4uhvBKP0+TbD0mk4ENjgj2+ez/BWtPjuLwUeQZcyJdRkgLXUH1ONkEqgTHpdIcJzpvHBBq9TI+JGGeKhYxD+pYTF4b/xwzDqH1Ro1lRzGcNufZFUfxPvSYxQGKfRElEmtWeAohFcBaW+zWrlFKZdsIhDhld6dGbjZigbMBh0s1ntMdgjeZ4EYu2Fr9BcHV0PG
 Dy5EGupL
 sINg+0rINXtHKV4oyQWhkwCOpv7GUSG12wm+6SOMHzseyEg0wXKDTTHvKpQgCF7LrynkHsh7GAG2YbFoEa0t/TDh3d8QuZ4KFTnsjvksuKAYRXRmHo/2pVpxR6VYmM5ZAYzRiuyFLTSvWbJ/0kGt5EIXNdd/Q3TAOBXQJFlpUAdYG7GZZLtM3j8TmuFG+Zsl2DpfshgM5uMIm2i9Lo2b5WqeBChAu2H1QNKJoIyd7/v2bln8uLL0ycd86eUca1Ve9KxBMLqtM5P5d2APvWu3XXVf7Mvz+jTct2r1+zOVUdiByzMrc8O2U7k+b5hTATE5znBMFUQ9xImbHXf57ddSEnd7ovhX+Ob0ymPv0tzF8QiZYhleKn/v+ylS77whZWmSKSPkVa/VcRzidkcLbm6L6dULXwDlDsf0MhEtYF0TLjw7u22EuRi5sHLprZmBCVWUWh+O8oskq9rwfo40dHMAhy0fdjWX/OZY7AyCsmt+0CI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com> [250822 00:15]:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    be48bcf004f9 Merge tag 'for-6.17-rc2-tag' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=136dfba2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=142508fb116c212f
> dashboard link: https://syzkaller.appspot.com/bug?extid=8785aaf121cfb2141e0d
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107a43bc580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/24fd400c6842/disk-be48bcf0.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/59146305635d/vmlinux-be48bcf0.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b3e5f65cbcc8/bzImage-be48bcf0.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com
> 
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6029/1:b..l P1208/1:b..l P6031/3:b..l P6030/1:b..l
> rcu: 	(detected by 1, t=10502 jiffies, g=6285, q=421 ncpus=2)
> task:dhcpcd          state:R  running task     stack:28896 pid:6030  tgid:6030  ppid:5513   task_flags:0x400040 flags:0x00004002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5357 [inline]
>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
>  preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
>  irqentry_exit+0x36/0x90 kernel/entry/common.c:197
>  asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:707
> RIP: 0010:unwind_next_frame+0xfe7/0x20a0 arch/x86/kernel/unwind_orc.c:664
> Code: 85 80 0c 00 00 49 89 6d 40 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 56 10 00 00 <41> 39 5d 00 0f 84 10 06 00 00 bd 01 00 00 00 e9 de f3 ff ff 48 b8
> RSP: 0018:ffffc90003cdf6a8 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffc90003ce0000
> RDX: 1ffff9200079bee3 RSI: ffffc90003cdfa70 RDI: ffffc90003cdf758
> RBP: ffffc90003cdfae0 R08: 0000000000000001 R09: 0000000000000000
> R10: ffffc90003cdf718 R11: 00000000000121e6 R12: ffffc90003cdf768
> R13: ffffc90003cdf718 R14: ffffc90003cdfa80 R15: ffffc90003cdf74c
>  arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
>  stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
>  kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:548
>  slab_free_hook mm/slub.c:2378 [inline]
>  slab_free mm/slub.c:4680 [inline]
>  kmem_cache_free+0x15a/0x4d0 mm/slub.c:4782
>  vms_complete_munmap_vmas+0x573/0x970 mm/vma.c:1293
>  do_vmi_align_munmap+0x43b/0x7d0 mm/vma.c:1536
>  do_vmi_munmap+0x204/0x3e0 mm/vma.c:1584
>  __vm_munmap+0x19a/0x390 mm/vma.c:3155
>  __do_sys_munmap mm/mmap.c:1080 [inline]
>  __se_sys_munmap mm/mmap.c:1077 [inline]
>  __x64_sys_munmap+0x59/0x80 mm/mmap.c:1077
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb13ec2f2e7
> RSP: 002b:00007fffe10fae78 EFLAGS: 00000206 ORIG_RAX: 000000000000000b
> RAX: ffffffffffffffda RBX: 0000562bd1443510 RCX: 00007fb13ec2f2e7
> RDX: 0000000000000002 RSI: 0000000000004028 RDI: 00007fb13ea1b000
> RBP: 00007fffe10faf80 R08: 0000562bd1432470 R09: 0000000000000001
> R10: 00007fffe10fadb0 R11: 0000000000000206 R12: 00007fffe10faea0
> R13: 00007fb13ec42000 R14: 0000562bd1443510 R15: 0000000000000000
>  </TASK>
> task:syz-executor    state:R  running task     stack:27632 pid:6031  tgid:6031  ppid:5870   task_flags:0x400000 flags:0x00004000
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5357 [inline]
>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
>  preempt_schedule_common+0x44/0xc0 kernel/sched/core.c:7145
>  preempt_schedule_thunk+0x16/0x30 arch/x86/entry/thunk.S:12
>  __raw_spin_unlock include/linux/spinlock_api_smp.h:143 [inline]
>  _raw_spin_unlock+0x3e/0x50 kernel/locking/spinlock.c:186
>  spin_unlock include/linux/spinlock.h:391 [inline]
>  filemap_map_pages+0xe15/0x1670 mm/filemap.c:3791
>  do_fault_around mm/memory.c:5531 [inline]
>  do_read_fault mm/memory.c:5564 [inline]
>  do_fault mm/memory.c:5707 [inline]
>  do_pte_missing+0xe39/0x3ba0 mm/memory.c:4234
>  handle_pte_fault mm/memory.c:6052 [inline]
>  __handle_mm_fault+0x152a/0x2a50 mm/memory.c:6195
>  handle_mm_fault+0x589/0xd10 mm/memory.c:6364
>  do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
>  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>  exc_page_fault+0x5c/0xb0 arch/x86/mm/fault.c:1532
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
> RIP: 0033:0x7f54cd7177c7
> RSP: 002b:00007fffb79a5b40 EFLAGS: 00010246
> RAX: 00007f54ce525000 RBX: 0000000000000000 RCX: 0000000000000064
> RDX: 00007fffb79a5de9 RSI: 0000000000000002 RDI: 00007fffb79a5dd8
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
> R13: 00007fffb79a5c48 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> task:kworker/0:3     state:R  running task     stack:25368 pid:1208  tgid:1208  ppid:2      task_flags:0x4208060 flags:0x00004000
> Workqueue: events_power_efficient gc_worker
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5357 [inline]
>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
>  preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
>  irqentry_exit+0x36/0x90 kernel/entry/common.c:197
>  asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:707
> RIP: 0010:write_comp_data+0x0/0x90 kernel/kcov.c:240
> Code: 48 8b 05 db b4 1a 12 48 8b 80 30 16 00 00 e9 97 05 db 09 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <49> 89 d2 49 89 f8 49 89 f1 65 48 8b 15 a7 b4 1a 12 65 8b 05 b8 b4
> RSP: 0018:ffffc9000441fb50 EFLAGS: 00000293
> RAX: 0000000000000000 RBX: 0000000000040000 RCX: ffffffff89ba2a52
> RDX: 0000000000040000 RSI: 0000000000000433 RDI: 0000000000000004
> RBP: ffffffff9b2c41ec R08: 0000000000000004 R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff9b030610 R12: ffff888031800000
> R13: 0000000000000433 R14: dffffc0000000000 R15: 0000000000001770
>  gc_worker+0x342/0x16e0 net/netfilter/nf_conntrack_core.c:1549
>  process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3236
>  process_scheduled_works kernel/workqueue.c:3319 [inline]
>  worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
>  kthread+0x3c5/0x780 kernel/kthread.c:463
>  ret_from_fork+0x5d7/0x6f0 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> task:dhcpcd          state:R  running task     stack:26072 pid:6029  tgid:6029  ppid:5513   task_flags:0x400040 flags:0x00004002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5357 [inline]
>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
>  preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
>  irqentry_exit+0x36/0x90 kernel/entry/common.c:197
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
> RIP: 0010:orc_ip arch/x86/kernel/unwind_orc.c:80 [inline]
> RIP: 0010:__orc_find+0x7e/0xf0 arch/x86/kernel/unwind_orc.c:102
> Code: ea 3f 48 c1 fe 02 48 01 f2 48 d1 fa 48 8d 5c 95 00 48 89 da 48 c1 ea 03 0f b6 34 0a 48 89 da 83 e2 07 83 c2 03 40 38 f2 7c 05 <40> 84 f6 75 4b 48 63 13 48 01 da 49 39 d5 73 af 4c 8d 63 fc 49 39
> RSP: 0018:ffffc90003337648 EFLAGS: 00000202
> RAX: ffffffff914e0dd8 RBX: ffffffff90c5215c RCX: dffffc0000000000
> RDX: 0000000000000007 RSI: 0000000000000000 RDI: ffffffff90c52148
> RBP: ffffffff90c52148 R08: ffffffff914e0e1a R09: 0000000000000000
> R10: ffffc900033376f8 R11: 0000000000011271 R12: ffffffff90c52170
> R13: ffffffff82127173 R14: ffffffff90c52148 R15: ffffffff90c52148
>  orc_find arch/x86/kernel/unwind_orc.c:227 [inline]
>  unwind_next_frame+0x2ec/0x20a0 arch/x86/kernel/unwind_orc.c:494
>  arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
>  stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
>  poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
>  __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:405
>  kmalloc_noprof include/linux/slab.h:905 [inline]
>  slab_free_hook mm/slub.c:2369 [inline]
>  slab_free mm/slub.c:4680 [inline]
>  kmem_cache_free+0x142/0x4d0 mm/slub.c:4782
>  vms_complete_munmap_vmas+0x573/0x970 mm/vma.c:1293
>  do_vmi_align_munmap+0x43b/0x7d0 mm/vma.c:1536
>  do_vmi_munmap+0x204/0x3e0 mm/vma.c:1584
>  __vm_munmap+0x19a/0x390 mm/vma.c:3155
>  __do_sys_munmap mm/mmap.c:1080 [inline]
>  __se_sys_munmap mm/mmap.c:1077 [inline]
>  __x64_sys_munmap+0x59/0x80 mm/mmap.c:1077
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb13ec2f2e7
> RSP: 002b:00007fffe10fae78 EFLAGS: 00000202 ORIG_RAX: 000000000000000b
> RAX: ffffffffffffffda RBX: 0000562bd1443f00 RCX: 00007fb13ec2f2e7
> RDX: 0000000000000001 RSI: 000000000002f6d0 RDI: 00007fb13e9c1000
> RBP: 00007fffe10faf80 R08: 00000000000004f0 R09: 0000000000000002
> R10: 00007fffe10fadb0 R11: 0000000000000202 R12: 00007fffe10faec0
> R13: 00007fb13ec42000 R14: 0000562bd1443f00 R15: 0000000000000000
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

Let's see if speeding up the debug helps.

#syz test:

--- a/mm/vma.c
+++ b/mm/vma.c
@@ -648,6 +648,7 @@ void validate_mm(struct mm_struct *mm)
        struct vm_area_struct *vma;
        VMA_ITERATOR(vmi, mm, 0);
 
+       return;
        mt_validate(&mm->mm_mt);
        for_each_vma(vmi, vma) {
 #ifdef CONFIG_DEBUG_VM_RB


