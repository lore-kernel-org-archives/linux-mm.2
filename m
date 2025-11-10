Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327C3CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 06:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A008E0016; Mon, 10 Nov 2025 01:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3198E8E0002; Mon, 10 Nov 2025 01:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1931E8E0016; Mon, 10 Nov 2025 01:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 03C4D8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:37:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E68DBDA58
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:37:23 +0000 (UTC)
X-FDA: 84093740766.26.A0A2B2A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2BDF5A000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:37:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KX+WBUkJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EZ90dd4d;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762756640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6VzInP7QhBixiZ51keWXXAKCKD9F6Mafw0xl1oHw14=;
	b=DKmf8snN1MvajNzwhSmTFBvPVHYP75DCeqsN25KNCktiIb2Tk6I66sQ0/LQ5DN2XBfADnU
	jGKHUg0hsVgzBN2nnUr5KbJnPldRDhDSx26aCdRgwtE7XHxolyRZqyXmWBmvQb/hwuIvsk
	7wXPjOFGb52oi9dn4O+oAeelm5mTU8c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762756640; a=rsa-sha256;
	cv=pass;
	b=RiN1pnbWk7iRgKfX/2/jS1qNwXnD6lgqa4WVghYrcJfI5FD1WJirdU8B7VX25KG1oTVJQs
	YrW42U+MJfX8TmNoWc2+5+GxlGB3+wfSR96nNFb2Nb1fO01AXmxd5N2G5McFkXdhfZ9xky
	dXG5bzxmSzqbYDQnvPLzxK0JCZDOyyA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KX+WBUkJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EZ90dd4d;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA6NYqA025467;
	Mon, 10 Nov 2025 06:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=T6VzInP7QhBixiZ51k
	eWXXAKCKD9F6Mafw0xl1oHw14=; b=KX+WBUkJqSAOCc4uJoOEFTO4OCQJMHgH0F
	4PmiuuAK91sLCjPhHXu9LDTDhwndtZgStHx7hz+0aScRTqImQWrS1r/1+YtLeegm
	A9zXBxD89Atm+0A3GeM28YizkojYjDMde9DHXeEY0AZzQXRMS2bCldPwX9305afF
	fcqZtkmNsB1PnDx9aehpgUWhDMqkYCYqISUoBpf+4aZ+3kjgzZytD5rihiDtLwfd
	cpdGBd93opFIRK5x2X1YPmgYYuUfl29/gxMuJOCRkNHCG1g/7Gczp4T97+wmIy2e
	5SC6dX9XPxPf/E3qIfu/5zbIyXiabb6QJeScO+H4JQ11iVwPRVmA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ab7yv08bv-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 06:37:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA5M62u007420;
	Mon, 10 Nov 2025 06:16:56 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013002.outbound.protection.outlook.com [40.93.196.2])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va88f9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 06:16:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NBQ8HLn200ovDclrfhck86PdM4UBbH0GBv8YKYX68PlIusfGldkjZuJcmkvNLpp2vfJW18uVPzOZNBcJCHea/zs3I+WRh3t55ekqz9GKdalwSAuB5Xi+P1hwvHO8dPSPxN//jGke3Oa631Sw1Rt+MT+GwhwfFK7uGDdwtelw0dTl9NL3U+XbaLFBzB4Dcoo4pgGWEVI+NGFGECuDWkcPBXOCUwkYfNMyle/aSWBEznZ+7KTrs3qQb44fLkOVOfnoN4+tT1JcVoRVKMRJzJ5Ig8l/WmIvkO9UGdsSX4j5yqk8LgHvT9blE6qYwfEY/TeoZJzc42HWd029S5cJCrhhBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T6VzInP7QhBixiZ51keWXXAKCKD9F6Mafw0xl1oHw14=;
 b=T7iwBxVXRxxKNVXA+RWbcg5L8fhixQFGJq+89HafIaDUp2kOubxyiIpyEgCoW20LWLwsyjzA69L3AsHcvQb4hCWPFdRObDz8a48VcLM9KZ1hIjHFxuh+Gmf9i6hq6A/q/3obm26MTMvZTPaIqsGj4kXAHbaUXQNtG1k/CHebmqoy24N02eydLkIDngj7Lv/yTQCKXOcM2pGcmbtWlGYIeBPMpeSK2gE6DqU4BeBJDcdWauLznr9IDOSUuujaxrXxH+2lQrN8G/2tLjU4vT8Z9PhsjCQJ5QpuAJF6Fh9Bb2Lijbf0cA57i4nARIzdHSnlBucqrrx8KBeajsbirihSCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6VzInP7QhBixiZ51keWXXAKCKD9F6Mafw0xl1oHw14=;
 b=EZ90dd4dm0ey2BHoyer00MQX8+SDBnedl60KSaI/fdilZ4gSzGZFJxq+/C4awBVI9tDMn0XnuXtDHjY9EBl6bhZ5jKyqXEM2hL2EMp0IvmbDww3zQ3Zs2vQDH5lQVgzA9pNgcxaRY7uX+DZfu96FpWxxgbs4/jSozcEFsaTXUF8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH3PPFAE1A1621A.namprd10.prod.outlook.com (2603:10b6:518:1::7bd) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 06:16:53 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 06:16:52 +0000
Date: Mon, 10 Nov 2025 15:16:47 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Tytus Rogalewski <tytanick@gmail.com>
Cc: Liam.Howlett@oracle.com, aliceryhl@google.com, andrewjballance@gmail.com,
        maple-tree@lists.infradead.org, linux-mm@kvack.org, vbabka@suse.cz
Subject: Re: Memory leak in 6.18
Message-ID: <aRGDTwbt2EIz2CYn@hyeyoo>
References: <CANfXJztHS4t=w+2Ogq=fHe4WS8CwOJgxog0ZSVf8C=9-4Xx0RA@mail.gmail.com>
 <aRGAUjkKe_H1xc7H@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRGAUjkKe_H1xc7H@hyeyoo>
X-ClientProxiedBy: SL2P216CA0105.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:3::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH3PPFAE1A1621A:EE_
X-MS-Office365-Filtering-Correlation-Id: fa1f9ba2-18d8-4815-23bf-08de2020bd70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dAa5J/1XyUpMiwqQfxAvqkIBORY6/H4yINmek9nJCxE3QZw9GkRBSG6k/D+B?=
 =?us-ascii?Q?bb7Uglu4J9Sv52dRDCTDFEjHNRzU/pbFmBXxFHEQiNTZjQwXukVEU1M/RzK+?=
 =?us-ascii?Q?xxbPlFXPubzdkG1CDit2tEczfX0CylpFUOEi9APl4b9Y+fs5Coi9S55HLiRV?=
 =?us-ascii?Q?ZGE2hrlLH21YfUUhqh6kLaIStkM2b9hSqoPtSPOiv8OD9gdPmqAgiSerkkEo?=
 =?us-ascii?Q?g2pXqlWVeRE+uCFkZ1DmhtqlBsF5TxgzcqUEO8ym5ziwBMAc1wJDyd7auJAH?=
 =?us-ascii?Q?IrFnm5OUPvkedTKwEjiHrPIQ+iK8UCXgD2psYLuOycWei+KN/WQVBXIyVqNj?=
 =?us-ascii?Q?DpoA8MXJV3pHmT4zRS5Wb/VlBQaLPy7e3meNWSq26PR4pBpmzDz3HCr86OQo?=
 =?us-ascii?Q?nKBEZfRSjnOTTyUA+tmOCOhXntoTqRjPNsGGj60qYkgtHudSaLS4Y3BNiJmz?=
 =?us-ascii?Q?poopLpzoAz0FVXOJTMYi2cIj/fBnyw20p9+N7whhu12kkD/M1WFUh9UDFKpc?=
 =?us-ascii?Q?6i/lJEqMq2HopKG6AMxBmB7rb3CNmT21pU3TutWCBmbloQGLEG8+0QWnjP3S?=
 =?us-ascii?Q?c0yRI18pSs7BTyWyL+BEurJ7iOCYif96Fj0SqtvnHyXcHDFUhAA6v1VQR3WL?=
 =?us-ascii?Q?XIXp3WSfKYzUdGERrXkqpFXcFSSBPfZ6bkPzD8vEus6b2lU7HmDgT3eSwr5w?=
 =?us-ascii?Q?R7TW6PaZYsqG4RlgHL7C66U4lOgAi3qaabBiRCv4NIEcT2eECN2Bdj9+i1ca?=
 =?us-ascii?Q?dkSNjCVLcKd+OxcLxAk/AxJU0RLRR3pIZxlxRRHHXjorzBIUbcsV7x37R5Bm?=
 =?us-ascii?Q?gevkzVgpc0B0+f1kioO8T4jteu7bVhnZh68R5zwUDCu4GVB4VAFDlW1U1KXa?=
 =?us-ascii?Q?eWBp3tquOQEBR4Oy2Ir6zx+5bPDCzGmFpOhhMk3e5lsZZL0sbLGFEPwEF/b2?=
 =?us-ascii?Q?v5SsrXxXhUIcyb+5o3DAzmB3F3C9wHQKwNYfZLkr/flkV6JvBUUND8VlhXuC?=
 =?us-ascii?Q?mhN7NWzE2Vasr1u9wvdCAoQVdpCOqD/Rd9e/TWson5/wuBWbHox7L8hZjiob?=
 =?us-ascii?Q?5w6hqeu9EWo4rnQ2Y94k9XcJi6Dp5C51XnMHELqdfRkGwYt5y7TetYWlBzz0?=
 =?us-ascii?Q?3Xs1UYkYm2B1dxIoTwdpFI7G+ipE5YNHJIxo200FQC00rWveFlaR9rSsu1q1?=
 =?us-ascii?Q?YKuVPp1mP/NmRdRTNwRPkj0n1yknM6tPLEry0Bl74ZsMia76zpg8p5NXxOqT?=
 =?us-ascii?Q?+Y0sdw6ng+T4UnCcINfaH7pyVDoNK34MMRExK+aEZI7Dn3sh4EJ45lOGUb8x?=
 =?us-ascii?Q?9ec9iCiQMVboNj5PLEEQcK5iJdCvpqM8OCeie1uXnatnJHakHsDUBrNaIko0?=
 =?us-ascii?Q?aIOITGvu1hj9vasu2kZf8OjRT1v8FIcvTxO8rU2yvHfEi1tkpheZ7Est44AK?=
 =?us-ascii?Q?MrH8jeGKDsntpJXM/Hp/Sh92+V4aFg9ytfO/EAZzc7z1RGjIs9vobw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r/fvPmGjeCIEkKnMLxWiIbRcWv4s3KsKqmbfNP18AMAkP3aCBJR2RBoNXTKJ?=
 =?us-ascii?Q?MV/gynEt0IClMTQ8jfpsZyyRBKoItSdvy5WhWAnnTmob5rRIPe69NMrPBniB?=
 =?us-ascii?Q?8dehDv9eghLqRK6SnKb1SU/uXONTsPyW2kbcwzHP7FrLqwY0LCb8wpP7R3LB?=
 =?us-ascii?Q?Ebd4KxVxyGTng+tjpGSHmkV4B+xO2Hjv7SBrz2jI5TfhOcxBKXwUj1TcbkpV?=
 =?us-ascii?Q?/TSbz+0jmZ/ZbXVus4p8eTKfC5/okhcdp7xcmrmPyIjOcS4BPtapGrd2W1zK?=
 =?us-ascii?Q?Hm+I2UOTPVnX1sd995NCuY9UxcmqnTOcf4Hr4o3arua6Tezz8AgSjnqDB1Ve?=
 =?us-ascii?Q?QoW7NCfZWJUmphCHXKpDv1VfigXxOX1eMfG++OxVgbyYGlFYdQ47105knu/V?=
 =?us-ascii?Q?y3PqfE5n3m6comFVg5gX8uuB0ZM+CRAiDQ+SBsAVadBPPQrtSoosQ6OZHbTc?=
 =?us-ascii?Q?hzoFiyVK7p4kIBUiADsLgJNLMcyIkoBcuLS/NoVpdHZsmb2OZewN3cEZTbXj?=
 =?us-ascii?Q?LBQSc8ZPygax/yt4EOtylBNINvHJ5v++ItlMJWah0L28YQr/9ysEn9cui5eh?=
 =?us-ascii?Q?RoChuzBOa0Pe7rDYAnwOxZNbrqXyFBbKf7L0gwCVzBiL5J6mQfgJXeBCvCjc?=
 =?us-ascii?Q?+NUfsq8Glrjkt2bhzqxhH+YqwR2HsZN4G6LiMtmJApzLGPN9i3No1YRqd2OW?=
 =?us-ascii?Q?k/2cCT5JTXGLCAeZow4WDvQ5riLDu16HDAzWAaEz5Gtv0StOAcSbtCa7XWWR?=
 =?us-ascii?Q?tCSxs4fEDiNINEsU7+1B+2JhSQROw6RdxozNSrmepJWQIeBmob6uTVL/eeif?=
 =?us-ascii?Q?kvGHibfHGyAu7A7dKkicMKQg7VrpA5Wio4iY7g7+zniP8U8C0kjW7gG8gy30?=
 =?us-ascii?Q?tpzhCv95xJEqftABAEiM9CRo81eay94mn6VGztjWV9KIIvJqF4goXlephIW4?=
 =?us-ascii?Q?BwcxEkz+u38K4m/NMd3um0Vae2YWrERsbmc80o5655VjasyW//+E8PRDYqMs?=
 =?us-ascii?Q?W6k4eDHaebXzeV/gCi4aJVuAEwH5HGV7lNPtL0d6ja5f5Na0nJW05/05UPWo?=
 =?us-ascii?Q?pIjc6rvTXGXV64rkQ18J2V5F4MCaZVhUrfI4wwyOeaukvHL1GsED9C/m89rF?=
 =?us-ascii?Q?WSLuBiAOk7ypo44Tl3bWWOZNK/iePf3lQCDmDd58Bsx7AXgH2tGlBJ5xHuXJ?=
 =?us-ascii?Q?lv8qTwhCBQWbEOTh2IaYjSnp+NpCYCGaky9J3X3REKjoPdevGTTG3sQlJPQR?=
 =?us-ascii?Q?Wgg6yn+4CfswMC/jEdSc11gqTe43cmKOenSLZ1LGuRIM/YwGQ59oMcpQ8QYr?=
 =?us-ascii?Q?ybqyQgGXeOlEc4IPvKgeQSEsWiT+QvdhPGi6AwSngjh3DXmpIo+TYIBB1Lks?=
 =?us-ascii?Q?7d5APzIabL1nwrfkPts39ZEDTca9yt7Nx20cRNi4txs/JDFUXHbl1++UCQH2?=
 =?us-ascii?Q?v5rsttTDHiF+5jhWd7dxeB9f5YEs/oPLc7hDcxx+E8Z9B4fK9Kwryb6ApDGf?=
 =?us-ascii?Q?O/O2Kb5OM5pkbFmkJ8Ww0Upn5qSEqWW+G9HKS7wY9yq8kdCR6OukCAitkPmu?=
 =?us-ascii?Q?+qH4hXx4SZC3+qTq+fTTXmVI1dn6O91hYAe26Zrn?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U+6nhP35B/1u1n12Dos7k9x53tNwsyMAsh0RRHbYlid0TYO0B3PA9kSjYPUI9iC7aIzJ8linp878W4Eut09kSWpZLTzirE/yRFnrnyDy8dD/Bg+CmyP2i+1fkop/3Py0zTYNELCpTi1pCgUPuN3pICADUXMS60WBoq/oPRPK0ucyrVzcUTzY9c59R8z/jDh1xy91vUgg5ayaixFiKbGE2BMKJfVDjcyHmexP21E8vMQ4aNOjgwM+CTqpYXnBgRC4HKHddNfh5YxiA6lhjYE5ntlCoUjkoUiBA9DcRw0IfX66ETex/OG9Hp20DJEDnQGy6meygsi2By00nF15g3evzqmkHiio24jwchv/valGXrOCsfUp8vU9NPk87ctQH0D7lF20g4gpUjBPYvDNlpa8VOySifzrCwa3l2YtzIitfTaiAE0wCZ6Uv80Pan6BCWXQvtw/s5eOWPGP31PmSReNgRZk+pVvT7qDxiLC5wJvMEOXuBzpKJMlw/phdErgl/KlW4YcTCfsxTQhbRZAsmTj5gTkG0vWEzouRJ07Kfb25LU7aBRf5JmhR6sPSAtlPvsg5aed8we707znwiBNWgAYW/hT8hLDgPkmPJE9yk2L1xY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa1f9ba2-18d8-4815-23bf-08de2020bd70
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 06:16:52.6014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8tWY1atxZXvwsJZwhzo9Ofn8K5tiDymbeGzwyiF22nsrPhrbU8NarR4Ykrz5hfCPtXPFY54DAfQAOnzM4FpwZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFAE1A1621A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_02,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=792 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100052
X-Authority-Analysis: v=2.4 cv=HtJ72kTS c=1 sm=1 tr=0 ts=6911881c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=anyJmfQTAAAA:8 a=37rDS-QxAAAA:8 a=iM1VLOJJozv5Norg_l0A:9
 a=CjuIK1q_8ugA:10 a=n3RQkRzukWQA:10 a=k1Nq6YrhK2t884LQW06G:22
 a=cticBlMJ0p58aub3HyjC:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: eKRLGfOG8_-UEBS48x2J6FvNDW1zdk3g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDAyNiBTYWx0ZWRfX9ha4h0JYkxQf
 16+yr8ztE3Z32f2iTOt5TSd23u7yXWSMsQuGDnyAF4NVgEl6O1FpOlEeTOa1IWXMYlDW5whH6LX
 F1S+PbE27yMO74d5LuAGguO27gTF/YEqVV3XY8FWjr7cR8yNGmPl54CwBqmDFj1dT3huoTup9Oo
 mwrYwGvqIrgqBwGi+nX1cQ5VKorC3DhXVo4SpNGjgnt8nGOgjVwhRHOrJVx1ZWGLiM4Te6W0gD7
 psDMcAGDnNNectSSCzRFlA8m56uLrmSVxs//V/S/BQlozd8DrLv0ZoWoj7v6xmDOxFp4MCAotB6
 S3ZesnnM8efCd2nWqX3OVz6u52ccihG5y5V11ebGqUbaVnHYepFuVQVoKz4UaCRXw4buf830vNi
 tFpvWLfoUwN95QEqWWue1zbpOLDCeg==
X-Proofpoint-GUID: eKRLGfOG8_-UEBS48x2J6FvNDW1zdk3g
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BDF5A000D
X-Stat-Signature: ypzuyun3pp8ctbn74psrk7jnkc5s34xg
X-HE-Tag: 1762756639-187535
X-HE-Meta: U2FsdGVkX186Mi+CoC+Ie88aBYM4JDVcOe1rkj4zbZ1IW2JHWovp1os5jrAw06inThaJ9xJQhiDdn2gL99ih/WSz7PnvYk6SFZNgOUOJaz1vz6WaRfttufBipVOGNix6Qbyabo3rfSC36pskIBQsrFW/E0tQZ43w1qerpgYQ+l9676+/BWPK7Jrb44hv7pSqFxIOQRHe094sj8h4pG7voZbjnQV5u0yggNjsjrSzdr/Cm00VPaZbvbGBr3erylOEM6hskNqxKTuoTjpm68/+yUEGNwBnBhixSCfv34DUuqQFk1Gr1YfUEAY0MD5AelQCcKzuoTD9+xajxwKfBXd3+TjtYjewoqtwl49hf0ZqZHM6maMeo9Y263O+JNQ1EYZZlHDiuTI5PTex7bNf8tAmoBaCjqlb6xPhOgPAOHQqWC1Lr38W1AXaclU89/HwVtCnSahY7d8a/yJsBpo6LNdq8qxg+meJ5SqMyWi1uKUzJrjKolLDU3yidBpPCTIF8vSyQmCCK+gCjRNKF4gDSqtMmWx/q3CVukDa5WpsChtA7durLSWJOTSZRNqdNaBdxGFh4Szc5hN/x5GtmR7RVAY9NsmvxytvOpNBPvJZ4RfzAWsGdrk6RHeHnUBu2oCkvk7HSlYH3yPc/lBjNS3T4InRqyhLpVvgttp6NCSm1CQaAcD1BMtjM0vvdEF434xaGGGokubwc+pLCCAcEhB6q3S5Pvm9ThaYTySAb15roRaFuCnXpGkc00C5LiIYjmWMw/a1rQFJjtWO+nzYST7OReYVIaHGbEpmo5G/0jopN01eMx1JjSmq40/w5dk8BhXuHL9fFLgCaYdNOkFAFi3WxRlZRwWCdDEuGzo9MIIupZ9wzr0B18E0ZdLjLIgmuojIl5+2b00khDeKppyL0NqUUqID6mrGinuoejvDoyCVE7dpf6owVQl0sKtHKw9bx+JQY+rTMFOGpEBMJz09bEm2+tc
 25dc3g1c
 ilPAeLwPB9mFaHC4EXiBu0JtR/DNZrD+TWMYr+tUabqPMDk3nyxa2jMcp7rxu+rEBUzuZqmsWnrnhc05fSKnrMmrOMRTbzf8nce9Ft3SxFfWRu7PpaNaqeYMSZvFOl330SW1oEr+8gzJjkEunzbhHkRzGdmLrU9401cfKX3CpNc8v/UQvJYTKd9dl0L33BMREaOU5pWxqhCTN6Fjw5kOvBRJLXnMJFSzuHzWhZZNHX2jGF4HoPx/bj23RY2In0DK9MVqfWaGhCMT8vY/RUFJZ7kMQa9l4HT6BlVAvL0uc8XjcujtxtkOWrtHjWfXMK807hXdT+6LhDtKXc678qvJTN9QimOJpgIO6nMdY68voew83TCS/N2w9VzENjadRVCW7oQRj9gCobNYizj3D3NAbcnxNFm4DUD/A5f2SQlzyxcVSaR4A5ND9Q623RW+RZamfImM7yARPN1VglH2XCPNDJwK/+WGc6NZrEakfj5GawD3EC8VVBR7XmwcFuiW9piPuyZARtRS+xGCZhTothKyrCQSKZ/JuTZy6xH+QGvzhpTn9Mz8rf5NTedRtS7tSnGbLaENhjzadg9TGXpm2r8NpHP5gdjJfozhld1TrgZOLHoJmdZyqu+9GIzpEKH/d3JfMSA2oATEBe5Byko8AwfbfZYwc+hzNuEUgJE5/w0k+PkcJMel8krHFqyfUt4YOr2W08sCJU1HTrhphKTNjK+tVEa062ZS35byVh1qTPJZChlCLBs2GdafSXod1TCVjHpLhwHhY13Dj4tN388uFshbHTDYFFwbFdRlEtjG8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 03:04:02PM +0900, Harry Yoo wrote:
> On Sun, Nov 09, 2025 at 11:36:26PM +0100, Tytus Rogalewski wrote:
> > Hi guys,
> > 
> > Been using 6.18 kernel and i have noticed that there is some memory leak.
> > Currently mapple_node takes 86GB when server does not do much.
> > I do not see that issue on 6.17 kernel at all.

Cc'ing linux-mm@kvack.org properly as I modified the address by mistake.

> Hi Tytus, thanks for the report!
> 
> Could you please boot your machine with kernel boot
> parameter slab_debug=U [1] and run
> 
> $ cat /sys/kernel/debug/slab/maple_node/alloc_traces
> 
> and
> 
> $ cat /sys/kernel/debug/slab/maple_node/free_traces
> 
> ?
> > Total 1000 GB memory
> > ASRockRack GENOA2D24G-2L
> > 2x AMD EPYC 9654 96-Core Processor
> > Running Proxmox 9
> > 
> >  Active / Total Objects (% used)    : 472110239 / 472257124 (100.0%)
> >  Active / Total Slabs (% used)      : 7385489 / 7385489 (100.0%)
> >  Active / Total Caches (% used)     : 164 / 231 (71.0%)
> >  Active / Total Size (% used)       : 95486861.00K / 95528053.72K (100.0%)
> >  Minimum / Average / Maximum Object : 0.01K / 0.20K / 8.06K
> > 
> >   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> > 345907216 345897683  99%    0.25K 5404801       64  86476816K maple_node
> > 120873408 120841337  99%    0.06K 1888647       64   7554588K dmaengine-unmap-2
> > 224256 223324  99%    0.01K    438      512      1752K kmalloc-8
> > 224040 224040 100%    0.13K   3734       60     29872K kernfs_node_cache
> > 196608 196608 100%    0.01K    384      512      1536K kmalloc-cg-8
> > 196160 166455  84%    0.50K   3065       64     98080K kmalloc-512
> 
> Not sure if this is because of sheaves or maple tree changes.
> Let's see what's in the alloc & free traces.
> 
> Or it would be great if you could build the kernel and perform
> git bisection [2] and give us what is the first bad commit.
> 
> Thanks!
> 
> [1] https://docs.kernel.org/next/admin-guide/mm/slab.html 
> [2] https://git-scm.com/docs/git-bisect

-- 
Cheers,
Harry / Hyeonggon

