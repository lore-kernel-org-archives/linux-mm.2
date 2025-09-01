Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D82F0CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39C208E0064; Mon,  1 Sep 2025 09:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373A98E0006; Mon,  1 Sep 2025 09:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19EED8E0064; Mon,  1 Sep 2025 09:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4F648E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:59:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AEC25BBEAF
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:59:48 +0000 (UTC)
X-FDA: 83840839656.03.FBF1724
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2671CA000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:59:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FEgMQ4X3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TFXmX0C9;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756735185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4cUbTVUcBchgitQcplaOi0f+7wDQfVPIPeWF00QAEM=;
	b=kfY1O6FIsib/vz3bEo8yQiCqx/A/RE+5QNOvZbhbLlNtSPO97az3RSorTQJuPsZr5o22hy
	AEKQ3l+PWJ5lyRoLwe89PlAulQK15LOUAHt30pdqHvFgMiTxQTYwsb59azGCnpR9XG67AZ
	dazgNADrif5HMdgWeEks5frfggK0t10=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FEgMQ4X3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TFXmX0C9;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756735185; a=rsa-sha256;
	cv=pass;
	b=EZLAZeo98IW7my0VXulN8pXnSzt5a5kiJVCWOxRoZ0wDu8w0CiRKc0LxR6KDoPJN6ztDlB
	l8GcJVv1gO0LiHGJee+6uxuqNQ/jyij5oA2kCGmmDZZ1gGBEv566FsS5qj2aFNT02UhWxb
	uiqNzoRn3vFNOvMWBnPjWg2ePG3gWpk=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5815fwCG000592;
	Mon, 1 Sep 2025 13:59:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/4cUbTVUcBchgitQcp
	laOi0f+7wDQfVPIPeWF00QAEM=; b=FEgMQ4X3M4dWoCtTXHtX3JrLZCFJHbRO4W
	BQrKs3Kg9irMjsJU9g17lQ1OClUD8fKdtzFSuKV2k4rwvzJp8NIiO+LoPTlaT75O
	7j82T5nNrJF3CjZThAuYEwBuq7HV7ojnvmBFjF3q4RrJqeTwU/yX8s6WsgsQHHU3
	Xly+f4pbedV5zP0tncSMKOYB/zwdLHL8T58EbkQv4VhCy6cgSXlmXPSSAZscuQpL
	HuaPi6WlliCfbTKRTvEAXyjbsBhUPBMw/hUfA88MdsvkS6jAjOAs1LCUIta4xTFb
	FfhcWCfl0ZZS+orxQbBhl33uvNaKATJelJFvj0RwP+SMfjkCHbEg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmnahn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Sep 2025 13:59:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 581BwENa025032;
	Mon, 1 Sep 2025 13:58:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr7wprh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Sep 2025 13:58:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X0mVxhRt3r/eH3YZgE8HX2HBGyJrhZdEzyR1MWkejPWp7lp4/RYg8ds7Jl8NFVOadzRf6AXnxyShQrLwZxYiE2BYpeyHySeMAFsLa/QPmevHAfv6bw7H1IWadp2Qxzuhq5ODt/JBPMB5IEI0PzJU562kJvp04NJIfH60RXaUONBFSV1Fqdo+6phzWA5t0NiD/T4f/CPo3xNdebHHH2q32rTCcC+VESqaO+wFHza/1gTOhVeqtetDlWW7gGQxDfSJ0Gxl7nAmf29CgUmz4fmQYLUVkcUGU8MjIB89CK4Ep3HX3ALC6U4jGUFwF6I8zkWVqX06d9ebC7GPC98pPq7hmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/4cUbTVUcBchgitQcplaOi0f+7wDQfVPIPeWF00QAEM=;
 b=NYdQFY/Yxpp5is2X795H6TeNqzOnGVsJ6b6NVK4qHprXr66eslzFxKcnv2sh/U5/7nl7U00PtayxvDiOytGwPemcO07OOI7J0i2WV39lDMSw0txDHqB6qOeiGRwfIboIsxzD55qcpxAW3afsORd21rCFnyvgv4ytQGbExxQHCi7u0MCKKx3vExEMylqGZPT4/q8XUqC0P7UsgzNdpcFHaI1YpiJwFFbEcYFpgYZ7z00UlPSs8lWnaRmZD9OouVqMAzI0LiwLGoE9f3jy0r4Djz5F8h0NgGHZquXvHrl3uPCRTwMZw3GV4mreJNToNAZxkF/A+zsqJAm2nBgwGGhQTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4cUbTVUcBchgitQcplaOi0f+7wDQfVPIPeWF00QAEM=;
 b=TFXmX0C9iGcGbFtGjl2BnVVAKTzQSUOQm5/TsDF5bHwqXJylncHIckTcNyVtXna2T/6gp9bsVNaB7+iQE0qSPAK7dYDOsVTcwCZieOe2poev7O5bE/Lzr+HKKyHOl3Qrr3Vbq7rcjRt9MvZk/eP9xQ/U++3lrNtxCIKYFzzcy7k=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 13:58:55 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%3]) with mapi id 15.20.9073.026; Mon, 1 Sep 2025
 13:58:55 +0000
Date: Mon, 1 Sep 2025 14:58:46 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
        yuanchu@google.com, willy@infradead.org, hughd@google.com,
        mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, vishal.moola@gmail.com, linux@armlinux.org.uk,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, davem@davemloft.net, andreas@gaisler.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
        weixugc@google.com, baolin.wang@linux.alibaba.com, rientjes@google.com,
        shakeel.butt@linux.dev, thuth@redhat.com, broonie@kernel.org,
        osalvador@suse.de, jfalempe@redhat.com, mpe@ellerman.id.au,
        nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 01/12] mm: constify shmem related test functions for
 improved const-correctness
Message-ID: <0ba59836-511a-4d7b-b0a8-2c5db8d9e8b7@lucifer.local>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-2-max.kellermann@ionos.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901123028.3383461-2-max.kellermann@ionos.com>
X-ClientProxiedBy: GV3P280CA0048.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::29) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SJ0PR10MB4653:EE_
X-MS-Office365-Filtering-Correlation-Id: be1da326-b1fa-42a9-49b1-08dde95fb0c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3/Vw9u4ahGZuhwCWSd3CMBgwgmLUroRhzy0+r2yafP/N3ZUndHYSffzP8KX/?=
 =?us-ascii?Q?kUq8gKI/k4l7naWlIkkbDbauQLlw8x/PpFtH/PHceGRVjog+EMaRNek9wj53?=
 =?us-ascii?Q?bfL6jfeOaLnz7AtghpbMhZi10SVIqtsQ6RKnQJ/y53/0g13DKJ3cdZAaE9Oc?=
 =?us-ascii?Q?vZzGKj8TNrCepH+hWuacpsana93GXr4jHDQzlrneefSsJBkb00Xp0Pa1e4t9?=
 =?us-ascii?Q?GIWlHe0DNtRxGpKpOrBW/T6VDvqmm8nI06q43KKoTExfAFR0A8vU3/f/eWqA?=
 =?us-ascii?Q?b9B4xerr0b+d0ShFMbdDWxaE4acOMlh5yth25CsWNkjpplm2oqw+NsaeYTIA?=
 =?us-ascii?Q?miZ3IbVDE4WFUegLhp0+PyXa8pO5yTZ43HhTb4LZkU0jtBWVLmOZwiOt/Oj0?=
 =?us-ascii?Q?8/nERHTpb4Qmqdr/5m44rw/OJfzltjiNBy4Vm1n1PVyCJqEbV9ZXLvVdCdQy?=
 =?us-ascii?Q?axwVaL+ZgKit2Xgu9+9t00VKxER3jPcSQ4UYQcPfzEyU1CbMd6CEHrHPnHOc?=
 =?us-ascii?Q?s773DZRdKQrAxPslIBnCo1FrM5XmW5MA3E0u6nsF8CTq2UBl44Z24PugcdXu?=
 =?us-ascii?Q?A1pOXdGrOYc6UbQUMcixTt2jwj2Tg62IcQHqaDYa7uw4LrYpwqxoDxYa18as?=
 =?us-ascii?Q?tiyLAtEC7qgSqoYfidCYNBe+iLiBwZt/epVcSuNu3/fxFa08nLmnueDzC6zr?=
 =?us-ascii?Q?7QhpQShkdfjc3/qFgbXGlvX5RFIhTZbRcON2cM1mS9uqqess63UszCHsvcx4?=
 =?us-ascii?Q?Mr8463WtHInxlbTrFTnYq14131Co658o7TXUIpRg+kfoCddXzD959Na40hz5?=
 =?us-ascii?Q?358bmlTZjnE01CpYC+7lg4N/aLHlQFZ/DVHnXmBYn8p08uDMo8KqYaaWK8IJ?=
 =?us-ascii?Q?bfu2t1crGUWUnpozBBMd2dnS2xh74v5mio3iY/kJXvpUuwuQ460pUHc7EhT1?=
 =?us-ascii?Q?zDmribxXSXqa6GuTKAKcWrwboQP0mxgi2ltl8PKB8FjyaaJPyHIpQUgGyvnR?=
 =?us-ascii?Q?ef28gP6CbKmO8e+ch8ilp3ZV0Ycpj7JOf1S1Fy9S31tQwaABQmFn79OwtKjN?=
 =?us-ascii?Q?k23LqhyoJbaCF4nuKi8zO6vVqmHY15zx1A6QMDKseNFvDKy69H+KPiflDgAz?=
 =?us-ascii?Q?4vNr0GzTuNoROuVC/y99mfVCiv9W3c/4L77dlBqyRriFXCJ1tc9xULm3/+rI?=
 =?us-ascii?Q?meqcNaFNAK14bMDQQacMrTg4CdaG722HzbmOtkKguvaO2IOK6Jmay1C694aZ?=
 =?us-ascii?Q?72C1snq7bNA3BKsn6nijO+L9xMSrUqKCNhG+OIXKNTkNI/cf40DwKRWM0YDn?=
 =?us-ascii?Q?pfTmNRjteAk3k1Oh3vPnrvtdgcx4zzxDMmP8BTZi9sb+eNexJrm2fTTMo0Bh?=
 =?us-ascii?Q?HKiifteYWuappbtUjZTUBDV35amEUlAQyMZMTJ+ofNYzKsKUezf70+ymfL1K?=
 =?us-ascii?Q?J79qLTsAHck=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z/1lu9szRcsDdRQwFZjBhZeJFiY8o4MhR9Q2iwJI9QF3NRfSrg+Mj0Q/L01U?=
 =?us-ascii?Q?sW2H6v5vvW3vJTHzYbtVYiPf8dhoae8hrzqi4HVgKGri5r8YoJxS4ta+anZ9?=
 =?us-ascii?Q?lF+PokrJ9101LLJPprZJpMKJ4zAMkZ01uBKVRY76Rh5De+MmrVfwK+HXoE6S?=
 =?us-ascii?Q?Uhui5kYdqBOXxVMMkC8Iyy7INUpiSTeBaGSk63Zm4hN5FGg63y28viYiKnRQ?=
 =?us-ascii?Q?uQnnAtriiL769AEnmzLQItPkQlNHXqjYivusDxDwIs9g8WDF9coOh26czVBr?=
 =?us-ascii?Q?HmUb8ohbGBXeEYzF9xSSobCAaYM7NAyWbx4pKK476oB8nSvE+Zph2a3Z98m7?=
 =?us-ascii?Q?DykdrJH6NstzSP1S0BhF9NMEPlago5/d7LKD+0WopDLB4oIJzynMdLmiVSKz?=
 =?us-ascii?Q?7pX03b7+6/KA3tvBwQlvImQAxgrVcIgUGdNMfJuC3AOQkBd2Ra+I04Q7mqwh?=
 =?us-ascii?Q?nopX6GAQhP5VJV8Rx7Vq0532s9Z1vWBl03swOu2oQjfTwOVcGUsIIHb98syM?=
 =?us-ascii?Q?KoJupmWZ6FHeNtYa59kVwbx48uTSmcowktopYPWnkjexUj7FYsi5K7iDL4X5?=
 =?us-ascii?Q?rVvMGIwTW7zmsSOAmCSXqUJXNhcXVAf8bgwpB1Xp0a8ycMEoEksf8sMIfaew?=
 =?us-ascii?Q?1FiaM54jOIfcjLBh485VNIEScrKhWQqD2Fj8/33/byknaAJXPKlcSETdt0co?=
 =?us-ascii?Q?oVwBLSbZg4wzvMG9AxjRqoRvNtjo4gNfy2KmsV2hHiidXlHcLssQRpUTSzzq?=
 =?us-ascii?Q?ilyqC8uFx1ZdOm5+K0nXLjnhSfjQwATBMGUvZ22qPwm7E6Oh9R1L5jEnwieo?=
 =?us-ascii?Q?srjf3oHVZUUoMrmFDV2kJ4bwg8Ai13C51+PdZEB2TxGmUuFWB8CP1fkvVrU4?=
 =?us-ascii?Q?0pHqKNMBl8MsiYkofXkYzRvv4m3IWCEratRxcj35UnBlmIOAAw8t5TY6hdXB?=
 =?us-ascii?Q?QqWuMeW3AMzkh7hQasrJ4kZv3ZlpGXTePX2wEergsP+PNCPZYZUOUOQbrlFk?=
 =?us-ascii?Q?HI2kImLKqTN5Mr+zNtty+B/LHFhkNv30Cg+cQSzNijPT6OO9JFF+kBwxZZQZ?=
 =?us-ascii?Q?sJkKfTmKyqmPxzhKnDCyvFx8sxc3PbZCw1evZ08lw6/L8gXrmvrug8oM+DWD?=
 =?us-ascii?Q?vP15vbIkPxd1HZA3f/ADfRvFchs61ebbQamOh0HUL2gsevnqr+6m+WeY98zN?=
 =?us-ascii?Q?9C3J2o0plD+1+qGIYnafpoDt3tICBaYUT+g5dHLKbckCDxnfRQ6dI5lPqVhb?=
 =?us-ascii?Q?NzwF495Uve3VIWczJLjZf95fLQI82W609nLHAdM3vNo8x2+Tj2sKnIx15Df7?=
 =?us-ascii?Q?Ra52DbWlzsY7XIKJ0jD7NvtJ04GnauhlZ2txZCpQ5yXFt3NZvadu2h3N4i8r?=
 =?us-ascii?Q?tR6DH1KhbAD7qag3Rs9mUQ87Ua5wtF3F5gFK1+Xjnqlbt8mLUmX0OmXclEOa?=
 =?us-ascii?Q?MTH6IOhJbGlag1skOgW4Jl78xRZpdBiuoxxTx+aOGTBVkJNnwqEPNvo+X+7Z?=
 =?us-ascii?Q?8POwNikQRMsni6QB71rzz6BsvNVtiRSjnRpQdbwuUEGmwTHChVhZM33xR5QQ?=
 =?us-ascii?Q?TR8g2ozDmcCAGaSyDS8j+r017u2U9TipWNlSHh04YxtnY5uYe9rCapV6skgA?=
 =?us-ascii?Q?JQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u209lTqGouqwbUAAAQWclcWZBKIYPizO6RwA84b/Ur2R3ssZab1Bl0o9l1ZO3uZPA+hDSNBXCg1u3Ti+S+uiSgDRp+YywJITwMXtYJHOFrHQ2h3pHT691dtU6fO1KoU8RYU5M/amYcXwVaVCmWFYyJ3+q4AKo2WhDac+OHkog3XnZTmyzPxjmgystRfvvLQyiZC0NnKl7mb3vXFTtMxnVF9Ldiu3V2ybY4XqS8yitJjs/a9yEEERpfZgegi11W7Nvx9QMsdbU7CDMyVbx4vPjo1pGbrhpD7Cc+JxIF7yloQxAWHsaBlLeFUrNsh7uIKSkiwMuq4vL5xws4jaWMGSqjtucyKO/BJ+jXbM5dPUXiJLNw22ygKjv1tsGBFy3jM0pUoVv5/13BzxTwhdsVQYrqb1unRykKgAEQ5wCT595Bhed0GzIBJvgT/0sJ0wYeJ5wrqkChyPn7qJbwd10qWHm1p7Q4hlAvDegNR93igvMO5T68Y8tjmg8fULWCoo4F2x6i70hV4bkOuwkCkx3LFq6CCftGXcU2tpChxx1VXdGVGG5COPlYvFVqFAIntY8LuVWb2mMLnnANcog31VbS+VKm3iE4o0qm0wQnU4BoFUvsg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be1da326-b1fa-42a9-49b1-08dde95fb0c2
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 13:58:55.3724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJ0fNbuTXnfu8fuKAlGn8g1hZ458sP31tjIZYhimsy0hRm2/a8myJXfUm3o2V3LtwCOtKfex4FTa90R+Qv9GhyFoBBXefvhlYkTuWaJT0JQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-01_06,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509010148
X-Proofpoint-GUID: IwXkio_Q6Vj1DRTYfRn3Yh-Gi93C0CQb
X-Proofpoint-ORIG-GUID: IwXkio_Q6Vj1DRTYfRn3Yh-Gi93C0CQb
X-Authority-Analysis: v=2.4 cv=Of2YDgTY c=1 sm=1 tr=0 ts=68b5a6a4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=UgJECxHJAAAA:8 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=yRUURUDK4fCiVKFZ-C0A:9 a=CjuIK1q_8ugA:10
 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX3MeqXAsLydmJ
 Bne2uDTYyALMmRElSuczpZpdvvGATWNEa74rDto5ACzwaeUpSVAMN4XKWpDNwtZvuSduj3GJlhl
 AnZt+N+9CvQirm6CKmyz1qRttdbX7LXzOg8MdOVtevp2omJPyQtMT5qOri97b2pFP5qIvi55JNm
 zeXgglLo04hbc/bNDa3yVejrWzA6mnOjBzMh7lbFayIFXbWRwJJuYCRnTq2OuMbiaCbBjeel8MX
 rL+E/fOPgGJecdRHs65jmKRdhiNoSOdtDZJScnjQKKZh4vyt371/qA/X29bS92bTID6r90nQmJA
 ffpBAgcXzKdjSCZyain4sbn4roMY9/thS5sKdV6drj51oa3pTtKe+IngbL2klkdQml+ad9XXtaZ
 aRjha1B+
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2671CA000F
X-Stat-Signature: 6pjpd9mr35744813h838s76soht56u9f
X-Rspam-User: 
X-HE-Tag: 1756735184-612913
X-HE-Meta: U2FsdGVkX19XXXPyizLAvc5JBSE5DzRoWfCAtBFDlWYSnIjzED8fBipJl/bY0ceu22o41eEl4IvraklhYRCSpZkClsKtEozy6/9FeAt8lEUhE9glqeWefDJ4CLMsz/5lx+hJfXxObooNqcJlyqI4ih1+/5u6DZcqSKuPIrnLKAgY8Vn0xwA/LdYEoEXhjy10TJyi4wfQ/uhaJv/wnqFJitWDmGQuFsz7oy4KpMG0Qc8GPy10It5tYvYmC1V53cO2aQiD/CG2HnIkYOA03Znxm8lPfGTAbdn4IKZ9k28CRv6kVSG/uyyxVSX+27pX7T6vxi1/TrDfa504fHfbspH0nvCqLd3TeSD6cNVDI3VSNcmCU7mD36dQOdrVk7oKddGbJClNkPJsDIjcoK/fVATvWTzDITgOm+itIiq7davTJRqicYpaXuIFsZ9Qs9hPewLsyOhM2gWm540CQhiwWzbncUxuVIzzwuDOJ4Ax9E66vzp3idKocN46MBu9hi3dkTYr0f5dlOG1Omi1QFR+hX77U/WuAm5h/8DfYbB1NYZBt8896URXlXH7Tl8IZ7dro6UmQp6gdsyseVtebIt3kZWhCfE45LowI2fNp090kFUSMPduEURbVK7xOxQvBwRSsqZsrXvRj39zrUbHj/GxaQmnTkNvjrQ8DqUadgFTs6/3ja1fPwJGxz8yPndD+lV3ZhliTAjS+CYuJcPyeFo/GrjLRm3R6+w9aWsKmz769v9bJU67OFGKjDDhpHbzBhCAN3ZnhMjlIFrSuxNj//hvfy+6DPpf5tTH1gm2KAihUL+r4hLg17SdONYa/0IPnFHY6DQFKsb3gDMP1i6kZAuBYuP8cex+QsQXdCLhSU0lelt69ng2HvHaq9BwDrRlDoGpS4xp2tilrn9dL6jFM8nljioOSEOxIs9j+FPKuTwuPgI99Q10yVrd5QdvErcRaBiQCXFm5K7miDCDJCHdf7K7eC8
 v7xGdAQp
 +ELjbAbwCoC1ZSyAgNfvCb3zGg8bpDm0A5/KtcgLXnrIzEIvAaI1blcOV/4eMZYHgzfHvhZnJhRRgh5rwBDEhljTIIccpfcZbM4nWwdKnTeiDoTXWeyQvrzNFBCG1nTLHiXRG6ikWgNKnEYx4s0Ee6w/YPpQNSPiE2FB3QazgEhoB+lTLVaZEzeFdWAmWT7oglr/ilALOD7aFvRrR5LKUcKRvPc//GAJ/TZHgyiSOH64yUYXBYqDACftTQqnez3phL17yDXay47RaGMbJDS/nUjxD0aXxgI0QKiqIsixGQT0DGJVyly/SZ/++qxEnkrfIy5mvymxMIg1yYlMCbrqSrIFGGBsexOohEkq/8VsZ/uU89v0XsJ/xsgeuhLHMgDGhT6lTFCoDOZlVHQuVPVc1M08P93qvyh5oDQgZHycufJaG0WeaS1aaiQhx/woX57eAhBbYDZaQEDh1fE/8bLYqtEUbAdg3p3VwTvB2OqW9xb38qEqdSgQaNWFZxu+fOXggKg5xOF7c1K6rSonXN/+z0uyAeNYLmD1Z93XdThqJ8LLr7eC24bt2CeFy5dvqnfMS6ZwOamvmBCqQhm/gfI5PSrL3vH2SYkIVhG6QNb993XQBPn27fbDMAfWJF1Y+Yi7Vo4yHBatDSGmCiyv0PTN4pwwsz9VkDtTtRLCqmWXq2JCRRNBJrfQYzlBLUsOfK+UD3+M99Jik0h+WIUCV9IiuqhW57XHl0HYRwQPycmUntMnQtASPnwlbqyeuV3h+zyjQu+0nadupeyvp6Qqj2yEfFUgXVE7z+Z7eKn31n2qHRkPRgyxGBTy9r/3GoVQoftG4uniYvOVmcKYlyHHmtrHWAfpqrE+Qc0zwvbsVoph/2SNzHqlpLWgWuMOWFUXPIXDgsfNQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 02:30:17PM +0200, Max Kellermann wrote:
> We select certain test functions which either invoke each other,
> functions that are already const-ified, or no further functions.
>
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.

Thanks.

>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/mm.h       | 8 ++++----
>  include/linux/shmem_fs.h | 4 ++--
>  mm/shmem.c               | 6 +++---
>  3 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index cd14298bb958..18deb14cb1f5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -979,11 +979,11 @@ static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
>   * The vma_is_shmem is not inline because it is used only by slow
>   * paths in userfault.
>   */
> -bool vma_is_shmem(struct vm_area_struct *vma);
> -bool vma_is_anon_shmem(struct vm_area_struct *vma);
> +bool vma_is_shmem(const struct vm_area_struct *vma);
> +bool vma_is_anon_shmem(const struct vm_area_struct *vma);
>  #else
> -static inline bool vma_is_shmem(struct vm_area_struct *vma) { return false; }
> -static inline bool vma_is_anon_shmem(struct vm_area_struct *vma) { return false; }
> +static inline bool vma_is_shmem(const struct vm_area_struct *vma) { return false; }
> +static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return false; }
>  #endif
>
>  int vma_is_stack_for_current(struct vm_area_struct *vma);
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 6d0f9c599ff7..0e47465ef0fd 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -99,9 +99,9 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
>  		unsigned long len, unsigned long pgoff, unsigned long flags);
>  extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
>  #ifdef CONFIG_SHMEM
> -bool shmem_mapping(struct address_space *mapping);
> +bool shmem_mapping(const struct address_space *mapping);
>  #else
> -static inline bool shmem_mapping(struct address_space *mapping)
> +static inline bool shmem_mapping(const struct address_space *mapping)
>  {
>  	return false;
>  }
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 640fecc42f60..d55bceaa1c80 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -275,18 +275,18 @@ static const struct vm_operations_struct shmem_vm_ops;
>  static const struct vm_operations_struct shmem_anon_vm_ops;
>  static struct file_system_type shmem_fs_type;
>
> -bool shmem_mapping(struct address_space *mapping)
> +bool shmem_mapping(const struct address_space *const mapping)
>  {
>  	return mapping->a_ops == &shmem_aops;
>  }
>  EXPORT_SYMBOL_GPL(shmem_mapping);
>
> -bool vma_is_anon_shmem(struct vm_area_struct *vma)
> +bool vma_is_anon_shmem(const struct vm_area_struct *const vma)
>  {
>  	return vma->vm_ops == &shmem_anon_vm_ops;
>  }
>
> -bool vma_is_shmem(struct vm_area_struct *vma)
> +bool vma_is_shmem(const struct vm_area_struct *const vma)
>  {
>  	return vma_is_anon_shmem(vma) || vma->vm_ops == &shmem_vm_ops;
>  }
> --
> 2.47.2
>

