Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC38CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBD618E0029; Mon, 10 Nov 2025 12:49:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94598E0003; Mon, 10 Nov 2025 12:49:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5CDF8E0029; Mon, 10 Nov 2025 12:49:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DC168E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:49:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38261140216
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:49:07 +0000 (UTC)
X-FDA: 84095433534.30.D129F0B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id D3847A0006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:49:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qPBT+ROh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Yhxi0f54;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762796944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNFeTtXA9B5amI6yFJm+cNv9ySckZ0fenCoPVkxiFsg=;
	b=GVVunEckoDz7tdX51fFkXBE6wPdoTXL7dpv+Mx4bOE/qCIafxVYvaPQujYQliJMgcCKvhw
	5T+dDicsqxKHothHjXhXMvd+4n2WqcoR5T/IHcBoUZgB8mS4yiw/me2lqsmDp3CCWa3DQW
	81CJEveAAU+w0vmA/IOnhdnDKjzLwHU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762796944; a=rsa-sha256;
	cv=pass;
	b=BwpngGw8h8VOsF8fATK4bcPS+GsmkSkdgIVesDajYryhn0T1pSOGNkj4OIDfPrkMRwptbb
	obq6ADt0ANGd6ODkmHsUwir9qrWpdFfcMqsLP6mjfIN4jj+g9UUdQ7JN/P9sNoCJGScY75
	r7The1xqY69Gsvr1BlIRl+orLs5E+Ts=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qPBT+ROh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Yhxi0f54;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAHKPrG032327;
	Mon, 10 Nov 2025 17:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MNFeTtXA9B5amI6yFJ
	m+cNv9ySckZ0fenCoPVkxiFsg=; b=qPBT+ROh8iGNYVXUx2A1NEzTCjah9x2GDH
	IQkifImighPoYI57RaI4lOF0Fz0L+kJOKGo9V4TXyrGfh+GuVcRxqsD3onv6uMcL
	Uf12XLhwyTNmZh6DntOvuQI6RwWELYMZw+KeJdVMvMdTF7MuPGkbYCXZ4ofLlgYk
	/kU6pKGeSBYMvYi9E2iIzK1KigAUZnS67t/L2TGY2OaEVGm/gLT6zStoqSjXcmSl
	SG7OSOYaxHabTJyYm8GDX2cT5MeEGhKLhhuj0n8NSGDgHu2jp5oEF1JEcp3Yedpx
	2ViVnHe7kW82NKQN5N81jTge3mH/iI2YVC9cPa1BZFPBmLRHbXrw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abks7g68q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:49:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAH5Rnx012637;
	Mon, 10 Nov 2025 17:49:00 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010022.outbound.protection.outlook.com [52.101.56.22])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaby7te-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:49:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mJLdLDkx70itElNrKP5OKaJxHnPPfm+djISYOw3HZfeVwUvB8BSPvH+Z4IgxBPupqAk6uYEdKXkkaickYxaH10bobFAfklisSQ2ZXNOFJEMuPEKONeNPDxBxmmdyaFF9ghJIXHok3CkudOwHHjEIhNA5Z3Qj/lgGAAruh3l7aTXynBIQDZgVvzG/nLp9G1gkiIscVXnPy83oUz5CLxq1YeTyCUh5qVfaj7jPqMXagzB4d5COPnfAnl2RthSqIZpDJKNuTi74vjrJVC6iE9iJx1/yITgj/VwYRkQm6JmoOVW/NBbMIRrSaYLsq/letrHYeGY6dhDAtu89YQVDFBtKPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNFeTtXA9B5amI6yFJm+cNv9ySckZ0fenCoPVkxiFsg=;
 b=CBRyXznI0yavxU7aSgkbtvtrCzbyW2mcK5SIkG/OR/vx22y8eKnNyBQxn9kNUcAds0gn/qIgSkg1aLSq+JEw30/jG0mnKXEeFtW0Jk6ZIlHN3xZ+doD2sFZ1+ZEOejvKvI7Yko2RfdUL3xtu+xbW/HH8/WvKnphHy37+hYHUzikfM/jwZGBsuxMyr840S1fB0lI21tV5tzc7EHP4/W8SaGvSxPCqbe2Tpvsr9bySzanFr5jE3UgTyIkEp3BHazSRxNudgMy2u/9oZ/+jTdcxv7LI2uHMIuIqEmA5FUyYWEra8ul6gDzj31uNhSOd4Q2BA1k+xT+H/VsOK1iZvUE4sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNFeTtXA9B5amI6yFJm+cNv9ySckZ0fenCoPVkxiFsg=;
 b=Yhxi0f54KaU5hpQr146nfSqIw/XAnOxiUm1aRFd23wfoPx6C54pQ8pYAozf0O8bsIc9R/0P8HRl69nLfFdW4LgcLE+qHCgSNw4QuCWYjIqkfyEQGP8f/htg1+u+IkTV6R3A+DS4mNJR0ItT5kZxNM2ic1EYYJguuTLWFXfHwfV0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6465.namprd10.prod.outlook.com (2603:10b6:930:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 17:48:56 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 17:48:56 +0000
Date: Mon, 10 Nov 2025 17:48:54 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 291/296] include/linux/mm.h:957:24: sparse:
 sparse: incorrect type in argument 2 (different modifiers)
Message-ID: <678256c5-1f05-4e37-b7d1-48d23ba01130@lucifer.local>
References: <202511102224.9qWchj6g-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511102224.9qWchj6g-lkp@intel.com>
X-ClientProxiedBy: LO4P123CA0135.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6465:EE_
X-MS-Office365-Filtering-Correlation-Id: 462186f0-5bd7-4279-4779-08de20816bf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i8tU63pg9KNQC9lNjzAgnpwYBS1rF4WWuvSotORBG+3+4ir59H+ohfw6sCn3?=
 =?us-ascii?Q?X15rhZmDzOWpcxjraIO4cq5saIz1eTHR1WAkwKRLswnfcqyrFjETZjfXdEOo?=
 =?us-ascii?Q?KvpqgcHS+hgsufXFHpZRu1JHlTuQiQm4A20focdCpG6nXnR9tCJexShz8ToN?=
 =?us-ascii?Q?SZPhRTLa1A9FWB/zXDFBo7KKNJ/IiC1AaonUABemPv4J8nznXdTP0fsFw5wZ?=
 =?us-ascii?Q?I62nuGAyG+aeT5duo5zo+2qMOtEsDn89qEDGOCBFFYoWO9Qo8G+76EWUJqST?=
 =?us-ascii?Q?IMpgYL4SVvzitNXwljuEi4TPBg3IrVbIFsEaf/PCtK5mY0RrySFy1qbWAPw6?=
 =?us-ascii?Q?pGVt6u278MXvRXfewQPH+lnbwy4Ae+vB4MNfLYZQfRi9aZd2+xAePuhwJIvb?=
 =?us-ascii?Q?lJMnZfzhEev/Qg6kTuBUgaqK7m18MPcZJFxIepRyPfbdhT+WhiK3Udcam7PR?=
 =?us-ascii?Q?EZdNl18WgJ5svsp+CAOfdgyEj8n+US1ZTKqWu0XaUozJO6z0uxS2iGPNkh8F?=
 =?us-ascii?Q?LNk10MQ37xxdpxwWpc/OmEupdXvHzclmdGQ6GZ0dwNmClrnuRQZgJegiIMLf?=
 =?us-ascii?Q?zntBf+isv1bB/9fdh/FgOVlQlWvuekrN6M8U4OfJDWFCYZ2Pddm64vK8mFoH?=
 =?us-ascii?Q?MVb+oRLgGZ1z9gozQ/8zlaPjKcA4lo+Z8G3fhrzfOh66Gu4ROb5bmEeRpts1?=
 =?us-ascii?Q?b+H+SUh8J/5H+wzOgL/diOW2O7mA/qAYxocjBa5esGhGqyRc+Do4URICiNbg?=
 =?us-ascii?Q?g1a4djSZRBx38QWeGgGRAJ81TeFovAAdDGj/WcLwuNIkAA9kghbOGIKBpXZY?=
 =?us-ascii?Q?vsChHxqmkluexeT9SJiYXWVu9ZNGgCr6KA/0sNWzaZe8BVIqaEFhDh7HhslB?=
 =?us-ascii?Q?/4V5n0MDo/UX0aP/6osaf3/Ho+SrVxkUmPH2h0flPn7NOtx0rcv1h3VeCf6N?=
 =?us-ascii?Q?BuE3J0iZANuzQduESfUqaA4ltpL3yyBf6TBDwKUrJKqwPee4keXA13sc2urw?=
 =?us-ascii?Q?XiPSpFyvaEqKZyb875rJExbPJ78mI4dwczDrHn8jwT3hwKUW1glLlpngCSJt?=
 =?us-ascii?Q?u33YcAIPhPLMhBde68RFwaAmLObI3LKS8Npy+Db390svatEr/9kDShGk8bdX?=
 =?us-ascii?Q?ff9Qu2U5nNe23bymYXSnqOe34u2gqpmG/LX2dA+lqT1Y3NuwoY0Ue6Wf1UKo?=
 =?us-ascii?Q?288Rm6Vk7upI9HEZyyKozPOGj5vzZei0rOZs9Q35zTlBEWKOrukQp1geVlB8?=
 =?us-ascii?Q?2VVY3t8eWSriYZK0L0AFUauljFMLg+APdspLkT2FKKEwnHlTxNUOJlzHu81c?=
 =?us-ascii?Q?b1eqEB0MpCR8Q0Q+7oth7hqXXjHwNTlX2JizbjqSKqaWUaPvrdW9NxeubXNg?=
 =?us-ascii?Q?oZaPoFiUpJMmjR0fYKTX2CLtfP1tCVIJ8rs4SD0V7O2f9//ktQgpfORP1guN?=
 =?us-ascii?Q?OikStdgX0HMVGg1ZU4X/7UW0TUqrWBxyxyhJWrEskDTerSnI6PhZag=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PbKCwJALHW5AkbSGkVAmQy7/aNseqiuksYXfL7BXlMFH8h1Rav+/6VYa7vpQ?=
 =?us-ascii?Q?t06kGQopex2I/GddjEFL9Q1ynN7bt7l8ijcPS1EXrxZZ4G5LDGBQdHGXpJYc?=
 =?us-ascii?Q?3CMZo1mDgDmBh5AdCv1agY0FWPHRK+97MlEtbxCiTegGfAEDH7uu6u+Xbu9T?=
 =?us-ascii?Q?Sv/LxJ7eOQcevAdshuU/VLBk2W2pbNCEJt/ILy+FuhUXrof8kKftTUQPaeLl?=
 =?us-ascii?Q?YXfOfpe7m3vX6ce+VTR2Y0IZabEs1rOxGnPOankxtg4crfj7eAVgvOTQVl7R?=
 =?us-ascii?Q?4AdqTg+VgEqFOVCudsX65j34j16fOT8I4h4TZHKwzNNziE9P5Zk8b3xO63oJ?=
 =?us-ascii?Q?iWHkMZ0W0O+snV08UvDamr3ZvVFhI66nrSEjT+iJPoBv+lZLG4tgT0P1kwlH?=
 =?us-ascii?Q?xb4kytVvLeu6VVCpWYkMgELWheTcvIV+nEHqS1xC4k57o7p0iSim+UYcr2YH?=
 =?us-ascii?Q?nbqvwtiervTLcP7R6qtWhrG4GBS2Mmk/gsMTJaVoVcLWF35VbYeKIdepMvA+?=
 =?us-ascii?Q?eA9AT6zDC6tiUQ8prhn5dbJaXo7AXYFlZoVMtNpzoCYtJjaBZ59Hn5vhxf+9?=
 =?us-ascii?Q?FZ+4e2IQLJh6wtsu9U8/Q2i5iEAJDyf5PiY7sGiWCXivR6tu4MfiIid1hDzf?=
 =?us-ascii?Q?cmQ78BfKyCjEUBcXOAc5b7bzBkoB8uOXrxyhS1kbqzKBJoIZv9+8oNB+GesY?=
 =?us-ascii?Q?+0sB/N7bH2slxqVJVV4ultAXjk+Mr9Oqh1Aj4LE5qzESIukZKVf7PyrozF+5?=
 =?us-ascii?Q?mJJN3uLHebSWCSeSEMpBhMa2uzWWT3MVZmBiYza4KOc60LojBYBEtCJLtrZH?=
 =?us-ascii?Q?YbgBsnCjOJNXDhqoGHHGD7ZL3xh9YmLOySOrh1cw3bHbIix1azwY6VekcGKc?=
 =?us-ascii?Q?SAOlHOog1Iv6E1Z3dO90wtUGRnN59eyXrxoB8W4ceoTQJ/diBVmWaoUXnAwB?=
 =?us-ascii?Q?aibfYLev4i4y5+tkRimEF3SgUiMGi47/4VFAKHbp+3I0FBnCwCpyUGulttX3?=
 =?us-ascii?Q?qDQftMbdYMhrO8T5BmoeW9xUkhbs5cuGkMEPAlc0gTLWme/dFSeavJ8tlDuz?=
 =?us-ascii?Q?W/XlN3t7Po1Iv2a8x7k3XRH6UpEsu9KFi7h/b1MHWcyNQVfu8dH7hb7Vrehz?=
 =?us-ascii?Q?HzijhpLk+HZx91RWQlWw9E5Eq1VWWHM49PAFdFpCU9gP2zR9Y8TxSKAG0QeC?=
 =?us-ascii?Q?yV47Sd9S6BS0WdU7EGkY4Tg7mtsKK2TZbjF86q56ygIO2/atTHer7A3OOY9W?=
 =?us-ascii?Q?q268kYkCmU6cH6CZzzuV+J9GD9ozwuc1j1L4o5P6X/nAy9z3HXnTnO2Ti65M?=
 =?us-ascii?Q?42gI6Uq6b3wB2KknR07kwCpBh5AKsxmD8AVECWLsRa0lay0YMJttgdWctANh?=
 =?us-ascii?Q?Av3xLdEjWglHskwtFO9XCGaI3M7VoENltvw/A+FYISeXfZENfbv+iRNNI7kT?=
 =?us-ascii?Q?WXiQyG74okAkIdpbfYiS9Gc/7yZUq7Y83URm+z154oFehNiQe/QR6ZRShB2q?=
 =?us-ascii?Q?jzahO3phJg6jz7jx5yWrNkjplSNk1k/2k/9+DLY9dmdCTPrXD+pfDi90g0/e?=
 =?us-ascii?Q?1XKyKgWZ1I6uBh46q5sWQGr67OEhlvi2iCicQiDgdUxMscpheyGCzMYR85ny?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8NyEJG4vrZo7qo6teTsS3olgGjWZCZOBn8i2wtYvyx1AheikQ7PP2u9vqKnuUz38opUdlngpMeORi1ZXTC+LjCD1jqzcCQQHu4bDxVLhmqDNNjFHErOm6GZAZavlA6TS0uoHBNvjDfkhRPFholt07aAtMY51Yyn3JjW0twfpPdSN9hzPJD5+MN5rWaM5E5wOlspHZOWjLHsnH4OD8VOyVaFB/lN8q+72ow1eaXmyAzXKzay8RKIii+gImlypkPAHvAbtcG/j4GV+yWj2mpsTPS7Ds9VE9w/9fAZTEJ1Y7RefoZAra/k5khZTjVxfQvArYT5amLIn31Ya7/rH1myKisjNOCaGOo5R7RYcP+sH3Oo8JZqROwi9YTblKZMu5SvD570SqjqwHG1Ji4jFJtI4OXs+D7rLrbCw2Bz47oh3FCjKKl7GSaHhxXmy0vydAY7a3FhPv6GldZsS4MQ5W7cRRR4Ll+FDOh72mOAGk8JSmB+97f+wpbepcadZg7p+Zfj7gbzyUsQLl1YPZmh/+2fzMkwKWDVQFjTzfnb9Hn7KqGUivl7zL1tXH8vUMGDAR647MVjm+mh2eR2gYVZnFr38nhjlv3a9aA9NE1Rcw4IZuAI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 462186f0-5bd7-4279-4779-08de20816bf6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 17:48:56.7909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: opFZkkNalsJY1+V3ElNsc+k3xEBQJNuJKX+1xWAr/sYNWdW1LchrvZgSSGY6P+sZI4pEiHjsl1403kwJXiKxgw6jjmDJZ/kIZ8q38w/4io0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6465
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100151
X-Proofpoint-GUID: vwe8-lwziiDLWFMU7Qp15sqdVF-SBBfn
X-Authority-Analysis: v=2.4 cv=L7cQguT8 c=1 sm=1 tr=0 ts=6912258d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=NEAV23lmAAAA:8
 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=IVL0B7gvS9FZHkHSpu4A:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDE0MSBTYWx0ZWRfX2zUi7h69jbhX
 CCMaDd1DtBQQCkOH+zUFLKMMEtmqmVtdZqDlRBY4Rdch56P1xnA4BfBpGBYiZobw0pB9+YI4ZpN
 4gz3WC1XKR619THPDnNexRPZbnvURtHQ2YbtL0QE7Igm2yxkBgvp1ydCBqolWKT2SRcDr/BKPg0
 jC8AcubL7z0HJeb5xR5xy6EaZIdhWJM82ecj8zAtVPFf2lhxRK1yTnn3kfU+Pj7kGU1Txk4K2eh
 +R25gjpjJ6STawgFZmLK3mwMIX3UI1hcLZ5a8GdT4PpMUAyTmyCBu38y3XFiQTxQvVHLXQJycA9
 fFN6yCtx2F7AcKqMnl8T3ZnJL1p3PxMRFSmihwcspdkZih1dBZ/+vDdzNNQKTbs6rhriZd5rVpC
 UOVKpbhxjBO1CD6F9R0FjCmpNovEameYxKJXhm/duKeniSmdOME=
X-Proofpoint-ORIG-GUID: vwe8-lwziiDLWFMU7Qp15sqdVF-SBBfn
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: D3847A0006
X-Stat-Signature: h5ta5t59m316qx5byotmf3pj716hekqa
X-HE-Tag: 1762796943-555829
X-HE-Meta: U2FsdGVkX18lCzJwTnh5pPsQxyJlEUKCe/BsYX5dFpyeaxyokVH1nu/169FFKAFlDKU+o1ceY5DHQBdy2RFWYKbkeufYt4wZlZ4C1ArWk7kARWMtJ3ILsAdLg2MYtrVoHLYcxn1c5upe5dEy0azs+9LG0/+8tr9lYP+Xi8glFXHhqwv7LQbXEwkvw0nCPkekwqTy08wTJNUT+rYO/R+y0wNGLY35RC26GGxICopNH10KsGhaTPCj9JfrK6T29Rato1Nxfan6LVvhZHHv9Imv8/tGWvEi6x/RoaMPLHDj/KEHs8Y68ngldDXEe1mU6DQhkc/diN+zn0CutoPSdTF8urzOnTa2MAbD01AOjW7SvyiivN/nslmbtvg+oTHkZl6yrZFVFZRmbZWQLP3pHUHqb/Xd5GjuCEXs7XRUunpVHR79K2EQY/uaQTR2D0L1iUFcPK+y384rO62RSVH69xsJX7uglfuL5xALvfR3toIvlxfMbzNWIUqEHwEy11pTk0YUOCuxPSeQt+hq5TgaBn/vM44ympehT0cew/+HhVyzIUemVx4sLDqLdFVOsfQQXP5yKFEQlR237gTq4NaWHRQEVzK0tj5ARuss43RGkIByQUUj0l/l9SAMpt0T+fYnsFdk9MMNiB5/9gbFSTeqG+C2d1i3gCbmCpfATFWEXqSXVDyP9dsd05ddZ/qHjl1odYx934DxXEbZoITE/DCFLy7yICnHk9xtIOKqvURoqxvAePATTdZR7nt4REoarNm28OdlCqtqnNdOa2vUZRg/yOBML6OuhKDoylB8f9b71Z5PwcZ5lRH3zvymj+ollqQYPJP+3YTcov3nvMLV8PCmCNNRgu7BGFAwwLJDMJayMQ0OClYRYc+5PRA3Jov14HrJw1Kolp2QLkEzPvCqKa+mjhoP7E+vYSOJAWgUXWqdQ8BICflx2SJpiPeRI8cssOpE3mHr2pXU7SlLNrngugC7+Va
 VbFsv5id
 +A1dd7Vvc/fM0ZoRj7Esz/whDr8vjWlf4+Ve+2pHVvLq6P6s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 10:29:05PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   8017f1fc873a78f54df02521b4d150f7101916ae
> commit: 85de428c7ca1b71457690b95e162662d0edb2792 [291/296] mm: set the VM_MAYBE_GUARD flag on guard region install
> config: s390-randconfig-r131-20251110 (https://download.01.org/0day-ci/archive/20251110/202511102224.9qWchj6g-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 12.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251110/202511102224.9qWchj6g-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511102224.9qWchj6g-lkp@intel.com/
>
> sparse warnings: (new ones prefixed by >>)
> >> include/linux/mm.h:957:24: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *ptr @@     got unsigned long [noderef] * @@

Yeah my mistake this is the ACCESS_PRIVATE() stuff.

I'm not sure why it's not highlighting the vma_flags_set_atomic() stuff but
there we are :)

I'll fix this up.

>
> vim +957 include/linux/mm.h
>
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  946
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  947  /*
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  948   * Test for VMA flag atomically. Requires no locks. Only specific valid flags
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  949   * are allowed to do this.
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  950   *
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  951   * This is necessarily racey, so callers must ensure that serialisation is
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  952   * achieved through some other means, or that races are permissible.
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  953   */
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  954  static inline bool vma_flag_test_atomic(struct vm_area_struct *vma, int bit)
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  955  {
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  956  	if (__vma_flag_atomic_valid(vma, bit))
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07 @957  		return test_bit(bit, &vma->__vm_flags);
> 85de428c7ca1b71 Lorenzo Stoakes 2025-11-07  958
> 85de428c7ca1b71 Lorenzo Stoakes 2025-11-07  959  	return false;
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  960  }
> bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  961
>
> :::::: The code at line 957 was first introduced by commit
> :::::: bf91f4ed2a530f2e55e7b202c1692a4c682888d6 mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
>
> :::::: TO: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> :::::: CC: Andrew Morton <akpm@linux-foundation.org>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Thanks, Lorenzo

