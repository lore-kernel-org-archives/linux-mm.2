Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88378C2A079
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 09:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9BD36B0106; Mon,  5 Jan 2026 04:12:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87936B0107; Mon,  5 Jan 2026 04:12:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A0F6B0108; Mon,  5 Jan 2026 04:12:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9F4C6B0106
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:12:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 599CF1B7B0
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:12:52 +0000 (UTC)
X-FDA: 84297345384.20.FD4B01A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id F2654A000C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:12:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fypvyTX6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="DMaL/Nto";
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767604369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISftXQU2FFszOK8YVVjmgfj/gGW5t2T0HcnSZwv9OYQ=;
	b=YDCB2Rqdzau60hGemF9ZnAEcJK7XT3Oqq2g2Cd66GFRhmiozVx+4j3McIsbykODL4JwWOk
	8M/wL1BmOM57XeFDv+veT1sP5ZTn4f1PVAVYILvLBa9hat8ptp9dgu6I12R3VgHx0560tn
	MQ8+BoFo7Q43w++tyGKvxiGqf7Mvt/U=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fypvyTX6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="DMaL/Nto";
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767604369; a=rsa-sha256;
	cv=pass;
	b=FZJhKZ0n4yzgHvv9hqVqFBhi054fTnglEDML2Za3NafIa6oxfCAwWmTgoFLVLqqniGlgv9
	nOEvE4MS8z43t7k/keiYxv2ASW5SlBfTCSOQ6uEbabWOH3sbdkvv9EWy/RDF09CFrENsIC
	FWi86xcbmr0zgYfsGuCNH1cRDuqYC6E=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6050vGVZ282118;
	Mon, 5 Jan 2026 09:12:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ISftXQU2FFszOK8YVV
	jmgfj/gGW5t2T0HcnSZwv9OYQ=; b=fypvyTX686C40mZaCuSJXuCM8ywO2uc+yO
	pcZC/ALICeBCjHIuxh59gIAcX0AWWwUief/uRaBrbW24OYQ3rdAS1SrRsxQJfSz4
	zvZfztKkSmd2E2NGXkZjBD71tJ8wyyY0pPiwIrWMps+8jMH/berxESKKce64SH2F
	dq/LN3VgaLruAKnsh6ojZaODfGHKm6lBNxb5g8vr8nMN8mf2lMa3CoGYHwES1/R8
	ABC0BpmtmXh75rf24mVxw6+vBEjnWV8Qfx0tcM+gWGOZ7xcN8DzdnDfbUPBI1nNL
	2HBYWxM5cpPOLi266ZUhtuKraju5DPiuVyhErIKfCe6ZTfbfyRhg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev37se53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 09:12:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60572bXj015504;
	Mon, 5 Jan 2026 09:12:40 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010046.outbound.protection.outlook.com [52.101.56.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj6wg9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 09:12:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BE3zmcpxU5YwtBBVqDM97LGBHSUEH+8abyhmfuimXL6fRxcUIa1ObcegoHo6XUVADRbwq8mFLTEIdbgdMl141AV2lgIDR+cPKIAdrSGFbx3YLb97YeSRib2ITvSkky8Dug5w/lyWvj8JXOPHV89MIN/6YxGBciYKIF0fu5kEycNncLuc4ICUVBta+oPrsBPj23Tk2ejvVTaaSC9jYXjz8HQEQuG/9VIsC9Y2c7S1SIVYjaIWQcEjrbOPx3zF5Pwyw7DE7KkSI9HhzUukXrFi9E8vGT+4wxKri66PjgNBFcUydgrL0axrq/mAW8x5VVu2fxvyuQz9tiXrd0EWpjESiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISftXQU2FFszOK8YVVjmgfj/gGW5t2T0HcnSZwv9OYQ=;
 b=xZR1BN3y3k2ZLaf37EnvGgx+fyn+65JbBUfzevyJJ+JFbSfi2I7A5HU+ibldZ/pFB7hzvRUBviZCrhhhlLKOHVrWPOM6WpdfefQHI4ZmGHRZW1h+azsMTZEa0bkzMeVxKfFIAd53qumE6AzxCqWzB7tOs8ELJJGSP7qItMwRHy3kczSD32K7p+MYIk+Ox/5Avc17DjXZ3CGnF/zQBDC3Zk1mG5Ahl5zfQVnzdZiVsw10zKUsztuDpJhof6HcJ2DI1wAPpEKVF/BLQWTFrtrRzUB1httt7vF2eDlM2Qvh2J5ibPQYsERF36xWEJ6u+nf/cABR+JaZq4lJKhreQE3+Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISftXQU2FFszOK8YVVjmgfj/gGW5t2T0HcnSZwv9OYQ=;
 b=DMaL/Ntoue5VI7leMBQX94FqHOy4M7yO8XRv/x+5aggv0ahjSIOG6Z/73Mu+I++8lG+1vQiDnkyUyhvachF5lwN+cbyJROVudfTRscDveww7vvLjM06jL3/NyJzgaK9bPNjfnOLI+1zFfaCjt6M4ZyWPaFgAz9PUVgFb4C7bw+M=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 09:12:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 09:12:35 +0000
Date: Mon, 5 Jan 2026 09:12:37 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH] mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted
 merge
Message-ID: <af0e6e5f-68ad-466f-b009-e45a2c553744@lucifer.local>
References: <20260102205520.986725-1-lorenzo.stoakes@oracle.com>
 <aVtH-9rUDNAhjc6V@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVtH-9rUDNAhjc6V@hyeyoo>
X-ClientProxiedBy: LO2P265CA0376.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::28) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4568:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c48b2aa-88d3-4a7d-e049-08de4c3a90c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LtSodsclUwq3evvyIK9528JMqKskc9WVwLm1HUmLbd+nIZ01aNEPj2Eds9cN?=
 =?us-ascii?Q?v2wh5IsxSt5Agfr+KJx3nhy65KKwje4icKn2zOZRUMFbYEkxJcgDR4iydoxX?=
 =?us-ascii?Q?wfTrGi48LZURUvmAH5N9x532wB3enxM/+3PlRa+gmGyQlv5i0HB2S8V58IKl?=
 =?us-ascii?Q?svri06YE/97VljEE67Elzc1lLS+QpOvKw2T3F3UoI9uJJXfZDVDw+8xHFtQP?=
 =?us-ascii?Q?74WCJ55G2dGJHbnSKBHZ7djMwGOaLmx9JrptIkVKu5ww7Sa22seful3Pn978?=
 =?us-ascii?Q?TwMPzhHWMa7xqZlXsJhvf9mh9nJx41G4s8dJuN/dM6jEuX6NNa8CvI38pzGj?=
 =?us-ascii?Q?p0WVBH7nTtn3BzYVrsKp4GLhHQNlmIIwFOtkzOziDtac5GiUcb92wrcLOuCn?=
 =?us-ascii?Q?+FqYtD2rD3JQ8EQb6FGV7jHKNBpdV23Bj8zRGVbHHhrOMUQP/WqEiUYgql61?=
 =?us-ascii?Q?KGJ33bUvZ57IcAqh50bX0O8QzT8nyok2K5XMZGRvtAM8gofYQ703wu/CCpKC?=
 =?us-ascii?Q?ry+Ar5Siw/JcR0+gI64F8RWcxRkUeKQD/Xrx4RILefzNoZpSp4n8M0ICC3lK?=
 =?us-ascii?Q?zp1kXdWlGvd8yZWOePqmRXbgGmAFLFGGtgiUIIZgNfW1nvyTpum6fDSODWJR?=
 =?us-ascii?Q?7FLxyy9Ux2kr6PNv7yoXfbOZkPALopp0w2hWvaHDAGrdOgSs3MyeE94aPEIX?=
 =?us-ascii?Q?bOnhnzrK0KXat9mbVxnoFkQ5MKl5Dcz0/L0zYT+UmdogAhfdMHAeIhqttZje?=
 =?us-ascii?Q?/tYKNmaw9LGrrtPzE+ICfYdqHlEAL44PCJf5tQk1WqeUwTUIdYGKyr+U3qyE?=
 =?us-ascii?Q?3+r6hfwiMDDb6H1fEfetBW+HWB581sWaV428hqu5XgT7ckWi/0GcPhVrMWMY?=
 =?us-ascii?Q?WssT3o4dHs7VqwI8ENZ1QI56WXIuzFUOgakTVAAwN4lRfp49rB3+e2mYQb40?=
 =?us-ascii?Q?1tsP73WF3lc82eLKSe2sXYw2hNtnWQGcCzX/63PdmPnURGEbg+owUhIT2m5y?=
 =?us-ascii?Q?gRhkcsJp0q2qfHahDBhG9GggqRrjiXuRxkYphBJv+qqTaevmFyXVdjENkfMG?=
 =?us-ascii?Q?EooO6pLTZl+ZwFZhNOU4vodSnBE35Q8eTeGqYH1sEd/7eQ2iQwEljHPBDqa4?=
 =?us-ascii?Q?s4ovyArVDocnTA/CzgLTmOe5T2N8UTWwKhASB8FsOwAjpeWg4VoWlEice4Z5?=
 =?us-ascii?Q?ruiYYa+miW4D/3mZGPQGoQbctRD+5ItZbJTK6OXt5DYvC7KOGn7s7Sdeqz+v?=
 =?us-ascii?Q?t6DB7ukj27mn9p9UJycpO9AYZYMtqURqy0S0eW4FEVdg416UeglzwSvrHgsT?=
 =?us-ascii?Q?CzGCYrwysPDx4H/FyR346EVfXkqE1CUV9b2wmHmzWkldUxP4sD8OcZwfSNCh?=
 =?us-ascii?Q?WfrcCVb/Za/0lVYG0jlcEyh/1kK1WeN1X7lIyaP1b4Qht3NhAYlML+msItbW?=
 =?us-ascii?Q?81nSKXDuvub3Oo8s2ZWV4skrx5n4dkGK9ADVpnVQTFkKld7e+rg/JA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pqYCMw1wVCANg6zayzfxEmOeIhH9UALD6ad6+iQX+sdCHOsNOelKy103qcvE?=
 =?us-ascii?Q?qmWatDXhvkTTTKe7TUpFb9CndeOHSafOZcIjvSLjxxogiXE6rvife6X+8/P3?=
 =?us-ascii?Q?/gq3HtWat9p8SddKn5Aeo+N2/I0b7FsRr5UzGEB3spNau/CYbHGmegkNuvxu?=
 =?us-ascii?Q?JLQ3ron0SghHq3ove2W0zMycb9LlAcPJM3PVVETKxpdSbWjG+j0VPAbQOS0f?=
 =?us-ascii?Q?PtvVzRpA9fwOdRcn/uyGbN6kjYTNS+e39YdHuHQJ+TYGYMHNvi7xomgeRH9d?=
 =?us-ascii?Q?zJ5MUUqNA9zVTyOeCtDgMRYLsS7QxuLfsPN95mCNmjQrdHHKOPZZKjdULCDg?=
 =?us-ascii?Q?9PJRc+/wzLQ8sEienGfEFWNevU4PekomoCVx0NXjyyJdFgvE7r5OWbxvvEV9?=
 =?us-ascii?Q?8jfui1aPlYXJ4faUTCIQHYOCcvd5oOjGUTn7G0PL23cv7RuVRtl+auJTNege?=
 =?us-ascii?Q?k4ihXDFYRV3QifDeS9RGYoyr0O8QVBX0phGayE3JwJhKyULEFTv9XvUz8xpO?=
 =?us-ascii?Q?y8x1SuwkFXVyNWPQmaIyJDXZhYUg3AMLF4gNutK68P1+QAq3RBB6ss9r/45e?=
 =?us-ascii?Q?ffHyBC6OX1XgjUzwQKGezgDj5UDHzK+TYHppsPPUFUC2TKjdrX/13wg89ryh?=
 =?us-ascii?Q?cXll9djmoBc1dItQ2VOXnUDUA1ee/dNAXMtYc1Xt/mcF9ILGPNLePaOETFRG?=
 =?us-ascii?Q?4mNTDDOWGJXrUXRnc1zw/ac5OmO1i5vLCkM0UJilrknC2TfZY+F1fW7MZMPA?=
 =?us-ascii?Q?6dGwW2CrLGVuqU6E21kXKIeesLNbkXvB/cnrjU7rU273Ww9GMGnN2ZHMgSDT?=
 =?us-ascii?Q?H8URxlR5dwlXaZOh1e/MQYBnCo63X5zG3j5/VflyeOAk5UoWn4KGC/f/TvDm?=
 =?us-ascii?Q?ATPXFR9g92BtBm2wvFlthue25mQMNTZApc2vT+C5KBYZFUC96O4C1g9/C10v?=
 =?us-ascii?Q?06JF9Ff+SfLLl+HhmX6HZDvjOPYQfSVkah+5riC1wINfTLsLhMlhqHf8C52h?=
 =?us-ascii?Q?o2r+KeX9/lG6k+K5FOrBNGwt/Z+xQwxafFsteL8m5IS0MuoMZHP5AeU9dBWZ?=
 =?us-ascii?Q?rHnusUrj8hKWzxbUlodEuMS7A1Yw3FQCf+QZQbYdCJyvzxDxCgYCW+1lFyte?=
 =?us-ascii?Q?9L+zfYI6MaDGCqvxY6i9b9WU982N/Fx1038fS2WmcONODp88e9oQeDhhlHrW?=
 =?us-ascii?Q?975Ti4nwDS3XZeBdw1xM+uB2JpQ29ajnJfZhgu9gId1/O9jtmBiBH+CXVzKV?=
 =?us-ascii?Q?xGU/9Jf446WHD8GGY9rJi9EBQjzjxitzKjdeJ89B+F/eQHYfxCJq6f+NCyVQ?=
 =?us-ascii?Q?jXO2vv4VPbkvZuktTMmRpZ+zUHM8idWw+Hg1wDOKkRHeX4h4w3N69TeK3LGx?=
 =?us-ascii?Q?3sRF4XvAlmyowG1VO/LXDf+lY89fBcZjYE5+ZahVLnikP5+vOG/9q5jlRks5?=
 =?us-ascii?Q?tYZecaZ/grJAvb9zYv5xxIPfBGYM0FdIFAsKhNL+OwDjxNajk6aBmmWRmKRa?=
 =?us-ascii?Q?YzIe4d6dYctY10P8+DuZDKVbqntQRG2MWbVPKVGGx2oRj7jlczgotnoFz7N5?=
 =?us-ascii?Q?ycICd8/l0Geoz/0x+h0h3SGESXQZpivGKMDLJ1ANfBnBxZJzqCC8UY8fR0JL?=
 =?us-ascii?Q?f7X1i/DDQs8NRiXler7x2jGxaJ/A9WIdAA6CcLT9bzo0yt65t1TNn76dQ+82?=
 =?us-ascii?Q?2zEUFQqA3kHsqgYHF8H3IHHyUBZ/TncUoXMQdryT11e1MnWI8RJWsNd2sZBI?=
 =?us-ascii?Q?qJbTrkEx4T6V/4AdDhhBUP5K/pCHd1o=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Gie1UEX/nPOBDxCDciAMb36aaARAA2y5sanVagRaFdHUmvHe4iYXECoF6k92gNZy3MHuwT4tgqD6jVlEXnMRXXuYzn27MfuXIZYbuWV8cZC4kHIp3YsYDeFiK+GDTekdpFnxGTjBRHDAI37m90DzXzIXophX+33ESiIb9wGWYasj1QiZyPDTX/gx+fn/2dzCOOrAb5KRFiTUqWkxn0+j6D9sm7STHh5RaaYRtGz/uvMz/Tr3kLZYQqpbVf3Y1E0k8P7tqZHcDieEpI30+X7v7VvKO1tV6tr8uOTI7H2p82DtiDQEq8aqN5BOmnthrm3uHkvjvzvW3ha66exrox/mytWPWlOZ2fACZZx/vsFbhMHNxPxIMIVa9p+XGTMWAM7cvVgdCl4dzDBk2L6VbmsFeY5VTEFyDHxhJjUaDvorKrh4YXWI8COFYmfZcDUhFsxtMzWY0Ipz9FLxm5T93iZ5AfDgqHOecyskOWO3nnddj+l3KV5xhy+Gzc3jS1RiSMjwVlWpYxx5DcZwMD4X/kz1UpOW6sqDxaUlSmvpifS9m2QdzH070xEZJ9ebmH81wJpxiPOwXBVS+BApAfstjtLHnE3cAQG7lVkjuIGtdqMeg/U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c48b2aa-88d3-4a7d-e049-08de4c3a90c6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 09:12:35.7329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MKp8iNdjHN6BYO2jUQTZQ+F4zV7M6rrrdiZDNrd1ht4CYdvljwLgk+lJu3owWcMtZbX1WmtySswmdKrIOuJPieYiNdkA7PSW3xghl1cTS9Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050081
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDA4MSBTYWx0ZWRfX5Fdc3HqH63V6
 1s4wLhXcRI5xM9IpMrffZeYBmppMfTDS5mgnKn8on39vf1rZ4kvK1QrprhNH4zmIN9KL5bsOe0u
 sBQ91yngvtnt4FgucibRXrSQ106nlEa4oRJf6f7rTDReopUs2TL+nHZgNfPHJ7Z01r7gFpVY0B8
 dNkKy3xMHKm5cuL1nlj4Y/XD6DBSSaiJZTGLbeVhSN+1RYZHZcYp24m2sQUFDie8eIWCpD1NBZu
 ksZZWpPsM4TSfBQAIzvm9tQ29gstfpiyBI4cnArKHCzaErCzlK9ETnDY1Ivl/SAJIv7yO8Otm0L
 1sskcbq1QOocCZM5pk78h5w+mQqPWkJmm/OEzg6TwxBKiH11l6dOfXa3Q5LKgJ63+QDs8XkttAL
 8SjTA1CV7PeXXtUxCXO0dA3B5QBBHDkSX9i8w+E9eRrEpfKaaNddMnrezknWQDFj1tnr6RZUVIy
 wFR3OKQNr1kN3ryneeA==
X-Proofpoint-GUID: 1tsBtm4tKf2eInVRcRW6eWG9VET7S-Us
X-Proofpoint-ORIG-GUID: 1tsBtm4tKf2eInVRcRW6eWG9VET7S-Us
X-Authority-Analysis: v=2.4 cv=F89at6hN c=1 sm=1 tr=0 ts=695b8089 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8
 a=kI1-4JeCmWFsonBEqX8A:9 a=CjuIK1q_8ugA:10 a=cQPPKAXgyycSBL8etih5:22
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2654A000C
X-Stat-Signature: grxfop9n7bqjumdqtbh4jqhn3otk9msc
X-HE-Tag: 1767604368-665838
X-HE-Meta: U2FsdGVkX18dD51JiXJpLpjvSE7Phg1mt2iUmMcHO4eirwjcraNp6tktARWj/oTjyW6I6lVtXLbIPSYwrUF6SjzupFzCiopWLKIBihYbfUeAIEEJNf4gdo3TgtQi5HBk0hvA8Z9kfXBR8DlKZJI0+UGzEhQxla3CFGPaj43ksa9OKw1WuQqH+NPPWz72a9UpJkAHeU3KP4/cu6aUcxIyirQpfdUvFFmL+s9YNoROAquSkjED/YrUh1S6DpoGjcsyxyi1qy2o8mdOVMh67a+IVLrPOL1rMnj4VsYwB854Ax/mEFYDOWpNagziuQYv/U47TMhpnzBMj7e4u4yf8uvRUWp/bywmlYb/GHj0pYCbxWt6iy1S3f8RHh7JT9yRZEAat1NpCjXaX69I4GZW62BmxJgLGJGXgbakI0jpmjO3Oocbf9Clr3uNlFtoSZeynBVdubT+IdGafon3tfURC4KO3YPCqm/5lZkPeyKBdjSlOYOouCoRmB3uE2DlgwKLD3JGNag4lH3eh6Pms9yRScCEl8Cly1FqDY12CBQDg12i9NEmMlAetact8Y+HHFDa5nkQY3BEloWqSRmvmhqa8fmOKIWP8x3tm0dpHqoncCNueLoXyEvgPzdhdUzAODj6xMtxpXuqWttx5YKown3tAfA625HKFN7MD+o4i/OitL38iZk+zMuiZIf1+chA0Gd/DheYqiXeLBuACFUvvj48MwBSdc4d02KbtxuRKk84ly2uPkZdO4Bf31dvRB+mySnBdReQq5LzoISVZURzW6MyedsF6B9RuEsUMQiMVZkz+oRjODkEd947kWWApzRVPMMm4/vcPFchwB/DFEiz4yCFiGzmdXXI1h0faVJalbeMDvPpiO1Pv9eIK7tyEktl1836V2bjfgqjqM+4/ZnrSbMh5agJ6Nad6sqKgT6CuE0ahea6MS+OtiRmz8TtQpx7B7bwcSBzpZPwBSQW53ngvrXCrMF
 R1jBmqXS
 slkUJ+SB6BSmlgfCAVBIXnS2x1yhByjNhFxfgAAZWaCexiNhAGEFE5u8PTMAFYPeshIzzSHCCXCQh3Pq2GbxtHeN2j60Yf9YAH7b39fRZkX2TqFxnAPCNGGcS8kK0RSfQbdUI3xtTiQ3JdEs0X6jHxxC1yhLlT+oPZnTvBKQ2oKQAswS+eO7PvhLAc8XIRPs0LKbwU+nE1MCj3hU/IgMZAJedhk+kzgznfTkZ3LLiCVclA6dmNuPjygeB4EmSzmmR0K017p63fzguSMsyLaXWo2XCR+TOpl9QOD+JLaINDd9NEzuXpYovI+ogmJemYe5UZnZChCJA0UQ8Wg31aSGJ2GbLR0P+RenGUn5G4ztGzmBmREOcEAz5kL8SStKH2exaqSgJavJhCf2AVKfPhGV6aRlKVPtpg9LeBPugBVROMZkVU/Q5DqweNuPsAUBt4tboiqmCTBYoOGHyd5pA7lb1oyq12pJ1kZeoO7YzBISByGQBEO/ovcFRu1j1Ho465VjRh5gYTKgX5FXzWX9Cm8oysqiPdIm79+efe58BR0KoAivl/bc7nlDfSoLHhohxR5jREzvmWB7KIrBXP3agp9W0hlZ23xEm6TTouC941grQZLkejaSg+9MPamNNhchwAoR4SE+Mman4uLfPe8PWx84r4xfIjRZ9a6fNP0zqdwI9pNFKyIOJvq54ndKF+xaJvF1tdzZ1hrTnjQT2YE1EyeB0nZTaa9MgGIF5Z6Hx2i2NrsgXoCDHYtoANsnGefC5RNbd3SsJIH3O18oIwR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - drop the original will rework a v2, thanks.

On Mon, Jan 05, 2026 at 02:11:23PM +0900, Harry Yoo wrote:
> On Fri, Jan 02, 2026 at 08:55:20PM +0000, Lorenzo Stoakes wrote:
> > Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
> > merges") introduced the ability to merge previously unavailable VMA merge
> > scenarios.
> >
> > The key piece of logic introduced was the ability to merge a faulted VMA
> > immediately next to an unfaulted VMA, which relies upon dup_anon_vma() to
> > correctly handle anon_vma state.
> >
> > In the case of the merge of an existing VMA (that is changing properties of
> > a VMA and then merging if those properties are shared by adjacent VMAs),
> > dup_anon_vma() is invoked correctly.
> >
> > However in the case of the merge of a new VMA, a corner case peculiar to
> > mremap() was missed.
> >
> > The issue is that vma_expand() only performs dup_anon_vma() if the target
> > (the VMA that will ultimately become the merged VMA): is not the next VMA,
> > i.e. the one that appears after the range in which the new VMA is to be
> > established.
> >
> > A key insight here is that in all other cases other than mremap(), a new
> > VMA merge either expands an existing VMA, meaning that the target VMA will
> > be that VMA, or would have anon_vma be NULL.
> >
> > Specifically:
> >
> > * __mmap_region() - no anon_vma in place, initial mapping.
> > * do_brk_flags() - expanding an existing VMA.
> > * vma_merge_extend() - expanding an existing VMA.
> > * relocate_vma_down() - no anon_vma in place, initial mapping.
> >
> > In addition, we are in the unique situation of needing to duplicate
> > anon_vma state from a VMA that is neither the previous or next VMA being
> > merged with.
> >
> > To account for this, introduce a new field in struct vma_merge_struct
> > specifically for the mremap() case, and update vma_expand() to explicitly
> > check for this case and invoke dup_anon_vma() to ensure anon_vma state is
> > correctly propagated.
> >
> > This issue can be observed most directly by invoked mremap() to move around
> > a VMA and cause this kind of merge with the MREMAP_DONTUNMAP flag
> > specified.
> >
> > This will result in unlink_anon_vmas() being called after failing to
> > duplicate anon_vma state to the target VMA, which results in the anon_vma
> > itself being freed with folios still possessing dangling pointers to the
> > anon_vma and thus a use-after-free bug.
> >
> > This bug was discovered via a syzbot report, which this patch resolves.
> >
> > The following program reproduces the issue (and is fixed by this patch):
>
> [...]
>
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
> > Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/694a2745.050a0220.19928e.0017.GAE@google.com/
> > Cc: stable@kernel.org
> > ---
>
> Hi Lorenzo, I really appreciate that you've done very through analysis of
> the bug so quickly and precisely, and wrote a fix. Also having a simpler
> repro (that works on my machine!) is hugely helpful.
>
> My comment inlined below.
>
> >  mm/vma.c | 58 ++++++++++++++++++++++++++++++++++++++++++--------------
> >  mm/vma.h |  3 +++
> >  2 files changed, 47 insertions(+), 14 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 6377aa290a27..2268f518a89b 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -1130,26 +1130,50 @@ int vma_expand(struct vma_merge_struct *vmg)
> >  	mmap_assert_write_locked(vmg->mm);
> >
> >  	vma_start_write(target);
> > -	if (next && (target != next) && (vmg->end == next->vm_end)) {
> > +	if (next && vmg->end == next->vm_end) {
> > +		struct vm_area_struct *copied_from = vmg->copied_from;
> >  		int ret;
> >
> > -		sticky_flags |= next->vm_flags & VM_STICKY;
> > -		remove_next = true;
> > -		/* This should already have been checked by this point. */
> > -		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> > -		vma_start_write(next);
> > -		/*
> > -		 * In this case we don't report OOM, so vmg->give_up_on_mm is
> > -		 * safe.
> > -		 */
> > -		ret = dup_anon_vma(target, next, &anon_dup);
> > -		if (ret)
> > -			return ret;
> > +		if (target != next) {
> > +			sticky_flags |= next->vm_flags & VM_STICKY;
> > +			remove_next = true;
> > +			/* This should already have been checked by this point. */
> > +			VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> > +			vma_start_write(next);
> > +			/*
> > +			 * In this case we don't report OOM, so vmg->give_up_on_mm is
> > +			 * safe.
> > +			 */
> > +			ret = dup_anon_vma(target, next, &anon_dup);
> > +			if (ret)
> > +				return ret;
>
> While this fix works when we're expanding the next VMA to cover the new
> range, I don't think it's covering the case where we're expanding the
> prev VMA to cover the new range and next VMA.

Right yeah because we're also not propagating the mremap'd VMA's anon_vma state,
damn.

I missed the wood for the trees, this just needs to be a general pattern for
propagating mremap(). This is probably why we disallowed these merges in the
past :) but it's good to address this, it also shows what a mess anon mremap()
makes, and further underlines the need for anon rmap rework.

Let me rework this, and come back with a general solution.

I will also add some self tests whose failure case will be 'breaks
CONFIG_DEBUG_VM kernel', and just assert basic stuff on them. We already have a
merge.c test suite for this.

>
> Previously I argued [1] that when mremap()'ing into a gap between two unfaulted

Right sorry missed this as was so focused on fixing the reported issue (and was
on leave at the time so wanted this done asap :)

> VMAs that are compatible, calling `dup_anon_vma(target, next, &anon_dup);`
> is incorrect:
>                                       mremap()
>                      |-----------------------------------|
>                      |                                   |
>                      v                                   |
> [ VMA C, unfaulted ][ gap ][ VMA B, unfaulted ][ gap ][ VMA A, faulted ]
>
>
> I suspected this patch doesn't cover the case, so I slightly modified your
> repro to test my theory (added to the end of the email).
>
> The test confirmed my theory. It doesn't cover the case above because
> target is not next but prev ((target != next) returns true), and neither
> target nor next have anon_vma, but the VMA that is copied from does.
>
> With the modified repro, I'm still seeing the warning that Jann added,
> on top of mm-hotfixes-unstable (HEAD: 871cf622a8ba) which already has
> your fix (65769f3b9877).
>
> [1] https://lore.kernel.org/linux-mm/aVd-UZQGW4ltH6hY@hyeyoo
>
> > +		} else if (copied_from) {
> > +			vma_start_write(next);
> > +
> > +			/*
> > +			 * We are copying from a VMA (i.e. mremap()'ing) to
> > +			 * next, and thus must ensure that either anon_vma's are
> > +			 * already compatible (in which case this call is a nop)
> > +			 * or all anon_vma state is propagated to next
> > +			 */
> > +			ret = dup_anon_vma(next, copied_from, &anon_dup);
> > +			if (ret)
> > +				return ret;
>
> So we need to fix this to work even when (target != next) returns true.
>
> Modified repro:
>
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <sys/mman.h>
>
> #define RESERVED_PGS	(100)
> #define VMA_A_PGS	(10)
> #define VMA_B_PGS	(10)
> #define VMA_C_PGS	(10)
> #define NUM_ITERS	(1000)
>
> static void trigger_bug(void)
> {
> 	unsigned long page_size = sysconf(_SC_PAGE_SIZE);
> 	char *reserved, *ptr_a, *ptr_b, *ptr_c;
>
> 	/*
> 	 * The goal here is to achieve:
> 	 *                                       mremap()
> 	 *                           |-----------------------------------|
> 	 *                           |                                   |
> 	 *                           v                                   |
> 	 *       [ VMA C, unfaulted ][ gap ][ VMA B, unfaulted ][ gap ][ VMA A, faulted ]
> 	 *
> 	 * Merge VMA C, B, A by expanding VMA C.
> 	 */
>
> 	/* Reserve a region of memory to operate in. */
> 	reserved = mmap(NULL, RESERVED_PGS * page_size, PROT_NONE,
> 			MAP_PRIVATE | MAP_ANON, -1, 0);
> 	if (reserved == MAP_FAILED) {
> 		perror("mmap reserved");
> 		exit(EXIT_FAILURE);
> 	}
>
> 	/* Map VMA A into place. */
> 	ptr_a = mmap(&reserved[page_size + VMA_C_PGS * page_size], VMA_A_PGS * page_size,
> 		     PROT_READ | PROT_WRITE,
> 		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
> 	if (ptr_a == MAP_FAILED) {
> 		perror("mmap VMA A");
> 		exit(EXIT_FAILURE);
> 	}
> 	/* Fault it in. */
> 	ptr_a[0] = 'x';
>
> 	/*
> 	 * Now move it out of the way so we can place VMA B in position,
> 	 * unfaulted.
> 	 */
> 	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
> 		       MREMAP_FIXED | MREMAP_MAYMOVE, &reserved[50 * page_size]);
> 	if (ptr_a == MAP_FAILED) {
> 		perror("mremap VMA A out of the way");
> 		exit(EXIT_FAILURE);
> 	}
>
> 	/* Map VMA C into place. */
> 	ptr_c = mmap(&reserved[page_size], VMA_C_PGS * page_size,
> 		     PROT_READ | PROT_WRITE,
> 		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
> 	if (ptr_c == MAP_FAILED) {
> 		perror("mmap VMA C");
> 		exit(EXIT_FAILURE);
> 	}
>
> 	/* Map VMA B into place. */
> 	ptr_b = mmap(&reserved[page_size + VMA_C_PGS * page_size + VMA_A_PGS * page_size],
> 		     VMA_B_PGS * page_size, PROT_READ | PROT_WRITE,
> 		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
> 	if (ptr_b == MAP_FAILED) {
> 		perror("mmap VMA B");
> 		exit(EXIT_FAILURE);
> 	}
>
> 	/* Now move VMA A into position w/MREMAP_DONTUNMAP + free anon_vma. */
> 	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
> 		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
> 		       &reserved[page_size + VMA_C_PGS * page_size]);
> 	if (ptr_a == MAP_FAILED) {
> 		perror("mremap VMA A with MREMAP_DONTUNMAP");
> 		exit(EXIT_FAILURE);
> 	}
>
> 	/* Finally, unmap VMA A which should trigger the bug. */
> 	munmap(ptr_a, VMA_A_PGS * page_size);
>
> 	/* Cleanup in case bug didn't trigger sufficiently visibly... */
> 	munmap(reserved, RESERVED_PGS * page_size);
> }
>
> int main(void)
> {
> 	int i;
>
> 	for (i = 0; i < NUM_ITERS; i++)
> 		trigger_bug();
>
> 	return EXIT_SUCCESS;
> }

Thanks for this! Will go through all this and come up with a v2.

>
> --
> Cheers,
> Harry / Hyeonggon

