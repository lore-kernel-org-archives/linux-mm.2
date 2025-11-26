Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE19BD10F5F
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 15:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42DE96B002E; Wed, 26 Nov 2025 10:20:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B72E6B0032; Wed, 26 Nov 2025 10:20:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3246B007B; Wed, 26 Nov 2025 10:20:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 034036B002E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:20:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4F81131688
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:20:50 +0000 (UTC)
X-FDA: 84153120660.25.78D134B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5CDB44000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:20:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=G48I9wQM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=R2agJ9Qk;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764170447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zeUPHswB4vYQYmf+JcZBthefKjAE55VJW0QU4yVx7/8=;
	b=UTC5Tvay0UzggsrAaCm31r/gzhm9vc6IM2Ljg+FeSdhrPmHcjUpHNJgDPuQAPIljy6hVQE
	MhYdkFAIMAcktTxIhg7koX268vNTL3pbA7RLK4V1YP+3hnCC4r/GFeN/k0xbttpSxnQzFq
	lgaOSOdd8RutOj1nR1zjpwF5+3W4gOc=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=G48I9wQM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=R2agJ9Qk;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764170447; a=rsa-sha256;
	cv=pass;
	b=ZUQFhJkoT2O/rQFmt3uYzFPGNfwj4Q3bKp6IrFijybGP+RBTHbNa1IoJKGKWr0rHahDaAN
	c1GTI0H+Dj8F/sCMSkR7+gSXbcWBJn+I7BQm6at/Bp6jsCdi5JngwbZXRaSiJ86EwJuyqZ
	kOorcd5oVcFe1etvMM4jw+mbYxYCxEQ=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQEu9Hn2535965;
	Wed, 26 Nov 2025 15:20:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zeUPHswB4vYQYmf+Jc
	ZBthefKjAE55VJW0QU4yVx7/8=; b=G48I9wQMzJVtBvhWPy5V/UO5pFlngsafD7
	MzCOj2ACPO7MpqKnjx232OJ8QQZBxwfP5Ht9mWQjRtRfz1uccyVSV34ED2abohuN
	+MIPb4VRHezAKQFl1u6UF1GPAOSO7ITG9rJmn2i1SkFDOrF4krYHqDd0fm1JHfCh
	M/o119RP/OAJhPkqdnO/VrsrcrB7+LrlbaCAsS+fow3b1S6VNtXPWgbzmbtsfRNf
	uUpx7Fby7GxM2NLkKq3Y0SU6UWvLnMGAVvKhkkQd4UWwaiakGNlih0G7+WYvZVeW
	LO75ldwIvDQ1oSkLCcPH5gfN1vSWjqZcWNjcdPun8o9gM6V89O1w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8ddmm10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 15:20:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQDbU9C029736;
	Wed, 26 Nov 2025 15:20:40 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010068.outbound.protection.outlook.com [52.101.61.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mend5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 15:20:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NTvrzV4rGLr5d0eonteXJ83fJvpEhuyYGP9Gt29pikD2l/7o9PFXWsx7YbrS1z7AwIN2h47/OxeiT1l0uOnXUudIScVk43fts2dhWavyrz0U0nCeB0P5nlUJPaD6O5s/dtF4Xfzkc+N8Q+qjiLH8QDcKrNrXOj9QnCG3UTaIBmoVGGT3Npuy271TuG4C4ogKnQBM5Y5sLK/t0nFgyOmvil5omRr557uymJSM7L+RGKMCUtvrtVl/SMnZhkimMT0EsP/U8UN44RmNL1ZA7pWypEN8IeKIcQupjCEu1ZAV8HkejxhzJaOI8E26IOKLfnrCZDj7SnyOOazcMQDyBVLgzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zeUPHswB4vYQYmf+JcZBthefKjAE55VJW0QU4yVx7/8=;
 b=o/pv17Hf98pI5YrO8XFFdl6cbT5Hu2XG5UXw234Hl1r2PXOe9VRZSnEo8zIX9IALQZ5BxeliWiO6FwO1okzVFFuBjU0iQx8le7vxGZahRkFYNKVrQR0hwl2DHvnqHor2HoSTMSWDkRnOMMzwNQzNRyI8rXq0h1UtgeWHPEfb0e8FUjXK28vWg03PNSUOFQhkmRHC4o4UagoeM0o0MqGFKAKl1Tf+9OFV3/oOvLPFpFVRXUHGpWAjvoqyng+hH9Kf/yLWqmH9Q6N4axx7f12pm9pIXw/53Qgx9b+vIZpUII9uTjZ554380K7AnJ0/W6KqcAkaxOC4XvwWIgeHBm4XPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeUPHswB4vYQYmf+JcZBthefKjAE55VJW0QU4yVx7/8=;
 b=R2agJ9Qk3c1WbIgp1XKHxZ1MES7GbFfmx4HRrie+cYyLWQhHchBy9ynPyPx8Rq4lbPhaNf0Bp1PvRl164da53vxjbo9tC/Do3ow0BClMrNUIKkrg+2hiEA7kJIfn97ha1pvErRS6O5TZyuZ3GafLVHwl6lfGOdum9AimsX6oSRQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5545.namprd10.prod.outlook.com (2603:10b6:510:4b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 15:20:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 15:20:36 +0000
Date: Wed, 26 Nov 2025 15:20:34 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
Message-ID: <44f4d9b7-45e3-4d2e-b1df-cab8e254e54e@lucifer.local>
References: <20251126034404.2264317-1-willy@infradead.org>
 <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz>
 <aScXSEY7v7_fcEZF@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aScXSEY7v7_fcEZF@casper.infradead.org>
X-ClientProxiedBy: LO0P265CA0014.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5545:EE_
X-MS-Office365-Filtering-Correlation-Id: fd6a54c2-50ed-4bab-41c7-08de2cff597e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TekUj/K/4ol93ExmhpwY/ATsRV9kxA3QMDgNFqU44CRLtDYkmZn0p/BiEg4X?=
 =?us-ascii?Q?nI9W2koUIASAfar0gWITLNtaRlvhF5QkCtNOx6rDhrSmOgC2FQcmF6gOB8jg?=
 =?us-ascii?Q?zgyuWOAEQMzeszV/kKCjvogfhdPOwqVytmI+0gV3OpRkPNT6ULZt9bIGpG22?=
 =?us-ascii?Q?QsVhrnoeNPAw32c4jvlsAAu67A5uGmh8gGudF0XC4fb7u8ShlZfkLVxlv7xw?=
 =?us-ascii?Q?OALH3tUE2uZbklaxObt++f2XXtBthX7h7GC+2T3nwJGq6k7dHKYMPZrG86ZS?=
 =?us-ascii?Q?Yh2W/z9d2mZre412Rn1Ny894cCgcgC8BAjuIcpSW9XnxNCmGUNKe/5bP3Tt5?=
 =?us-ascii?Q?Vd5eeqGqToinhP61O7339hrsPfC3jH/LQk8TRlUAG9YHvnKfFD6atFRolEWK?=
 =?us-ascii?Q?teUSTcXV9T0ZFB1Gd2ijAvrk2SfmzXk1+3wFZkboPFFquRTx+HQpNHg49QxV?=
 =?us-ascii?Q?fiUQ4FAnoO2EiwlWgJQxXt3xP+VQlqxT2rAqwkyRBgH0Ih26tAB6sG316P68?=
 =?us-ascii?Q?c1ceSgFg38HHHsQ+2Y0b9Pd8gNtsiqeeFBprMf8VxfP7ZNwyS93ZobmiBGI7?=
 =?us-ascii?Q?1CIU4/0V5/Nsz4JWeQN5LkA+rsvYg/8e+R5RgfBySQfCnFMdm3dnVPejrrw4?=
 =?us-ascii?Q?DN+Cj3To8XxpghV4H1h2tX6/FqPGUyyNqOPUgQo2mh358WpEK4cXg1v++5Xr?=
 =?us-ascii?Q?sThKeEwlN934Qu3s9pmCwl+N1ukFFXlqMXH5EMoGfQBcnC3BYkQSO27xsEft?=
 =?us-ascii?Q?gfOz0+Il6zYeA69xXW4Q6uPZYViLs1YdPFh1E274vzwDzf9OcjAViE1rFZjX?=
 =?us-ascii?Q?CaImdegzts6KFLVdJpi77NiSuT59uYwoydcAxm1e7xe+jQ0Nfd+kUI6nkpxq?=
 =?us-ascii?Q?AcIjgvZKA4nnv0rOJ517s2XPcfKPgJIpNZbKofuR3P9cbCJ/A8cmTAG0Untq?=
 =?us-ascii?Q?QyGtTFK0JZ5eaF2FCiXMEl+22gYahFODs0aTyf+D94/SlOaz380IVsKoQjNw?=
 =?us-ascii?Q?lOde4+lvpTJnjrL2AwDNXFmSxof/+0aou6nVKkdN/qAyAByXe6At4mA+qfot?=
 =?us-ascii?Q?i5osklHsrEs7ZPEatVguOHFXVFLSNszGSlz4slTHbO6aR+y7T1fmqnMz5lJk?=
 =?us-ascii?Q?Rmyj441hSxlKYbHqvXp/v2q98gTRY4JNF7Z9S4WDeGs8xougcN5SS4m5Og3J?=
 =?us-ascii?Q?acNPwgHmf25NUNajDKNp0mHs4fWSXEoF1QfoizrX9lv6+gEClYCRYj0p2oR4?=
 =?us-ascii?Q?i5aOZy2fSHrY9apxFNT5/RdT9kpPfw0YuReN9L/idankFHE+tRXlrV/t2mdk?=
 =?us-ascii?Q?eRxHmSxXLZhbU3j1wEyJApAhtwAoo/c9E42/mhhhYiB9sa1aQrH4OvOmzUTX?=
 =?us-ascii?Q?BEQTtFT/piC9LcjzNpbqRAINLx5tqgKseWFjaykLTNQxNC06vQZcB1jhV3Vm?=
 =?us-ascii?Q?gy3z/jStw7ulXFFcGWuZ3N/Wkgti6L93?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WfDfLIBbSQeyfAxSdASCvT3Oq7C04l9JREpT7uGePthQwtrP6m8TcqpK5LEz?=
 =?us-ascii?Q?3JDW6/o+3XXSZQFTfSsg2ku8i7PLnK+JF2TI8dU81Q14lF3JnYKRWN9363a7?=
 =?us-ascii?Q?fPrElDY5P7ykiw0cUnom+SZHNK9OLsIhGc3B6tPCdoZ0rJEKm/d7qXi870D1?=
 =?us-ascii?Q?2tYvD/KXV1WZIkXn0V915m+7yhkVaTuA9YG4kVASeCgy+mV3b3L0ec4jcq7T?=
 =?us-ascii?Q?Aob3FioF1kmxQxlmxean+gurvLWAg7gvgpadkvkuc2lPzDXbKmj1zd2ReJRI?=
 =?us-ascii?Q?E5vP9s+qinkCtILHlX30ES9+mj+MkBYOhtMu3he8vaq9kmaczY2fpAOSRjb4?=
 =?us-ascii?Q?0YF0FFNPVmYyY/p2AHqaVJZ5lIUZuyHUHIvRpLdbF/f02uM0/P9H8cLOPV8Z?=
 =?us-ascii?Q?yWJdCdlBD66zDobydKhTAqETZs00uu+KFbQGzpu5EU8epzBD1bwkTL7jHn5i?=
 =?us-ascii?Q?9/ysnsgyhBtcw0+fVWU4TklRmWDh1o7p+dbZtpL+TDptlMOKNHg5svLAsanu?=
 =?us-ascii?Q?R5Qy8MPKzP+L/lw4NKDW1rRyjIm4SJZfHdnBvenjkI4kWJakiwO85a281a9N?=
 =?us-ascii?Q?qMaSRSwKrbWSqxddBV/w2xeZDZ/XCGMkJb7DF442w81gSf0hmWkPPVcNl2Vd?=
 =?us-ascii?Q?EFWmipyePbFtjVyr8nHVVlfdl920E6Q511keR1VvqgVoGBmjV/DEaYvRb+xF?=
 =?us-ascii?Q?+lASTRUOzz7TrI/m6keOl7mfNP6zpVAm+JWeuUuxWhhPLQ1XxMCcZYogRU1D?=
 =?us-ascii?Q?YAZ4D9j3akpAK4ZepPGoh7PKgd6he7rP6dC0Yg8ouHtHMcuhcPqEVNPacDQ7?=
 =?us-ascii?Q?T6aXnnb7cetxVsSzH+IjppOz9Ib5dpoBcHNXu5ZTqJLkQdJmEf+CawsSPPnx?=
 =?us-ascii?Q?0zDFW7jn9Bc8b902asG/PVi6n0d0BgeNAw3gipyZ3LJWXLr7jqpJrPO+Jxvi?=
 =?us-ascii?Q?eAH/gMVhZVvGHWvP9dGlma4dmSHykOAvKMDlHHwNhfs0PQl2bHmN+3+DnVZ3?=
 =?us-ascii?Q?St1uRwACKDoosGjm1S+NvtFQgp3QcIAsPm4RPnNuTgCIWjaGXl5pIxKiadAN?=
 =?us-ascii?Q?gAWZIs2Dx8a5qpBE3D6xf1RlM7vLnL5sR2/EVgDKuzdFpefJ4xbg8oahAoTC?=
 =?us-ascii?Q?juVHBGgP+GAgYNBcRzgBEVykwJxIwZ/FkGPveCe4D18Gy4C+dGpxsXgz62ZV?=
 =?us-ascii?Q?L1frZ+7XoghcVUynSIUByT1cqixTUhTwpGYKV6v3FdXahQHoO8JvROo9O4nI?=
 =?us-ascii?Q?iKC7tvljq+LYwXcKOTtubwBzOsiUqhp4BBkgIkWWYSYOZG1stLrnszuXfhfh?=
 =?us-ascii?Q?tiopxLMZuHbRmpgsfIOPB2C1iylxaCuUAFCweYH/PlXiVTYZ6647iWvp3zDf?=
 =?us-ascii?Q?qTKarWzxSu0W1vkW+OsR9BGz9F/uWkneZ7Yb9P1zc+n9tmB4SvXZ1x8sbJTp?=
 =?us-ascii?Q?uHRC6xUBlbp4fp84OVi0MoFMkSpO5dAIUBqsfhmf3jWLMxxEzt9oSx5dtaaM?=
 =?us-ascii?Q?S8EEgG6ACbO2zahS/JsOiKXVNy/fCygCG2cto7km+vw940pqsPkD5/sOx+P8?=
 =?us-ascii?Q?yCNU5n+YkiNY8qj3ok7cIxd7OytrsWGT76OH+CMB8MC7WYj9B/MRmYhoh4N3?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q8AejzZirAo+S1s4LI09kle7auFxZxWrOAegChr+CZjVBZGdukMUwwxXiT9U8+2ud5EUvVVKOUELLqT4rjppv0guGUnlDNuPsdYm71sQlAXbKYi/n/wH6Mv7rbX2RTi35PsgMZRZfOaWsmtBW8mq9DHoYzjjPmJfqX/02TKx+d7mNwSGvCulk6amhrtTI7c11hnv5f7Mcycd6UpLkevyKZZ7um3sto2GuhQY8wvr5m7gHbBpUpCvkQQTUWac4svZzzbHQJORaBZarYFkh84ThHTQWqra6GjjZtcr906ZSEPjowv2xa+xASPdA9Qwt4tBZWko2kdM472FSoEMHGo1e0ND5m4wYfZgf3l7OkFPuo/1m4rukVAzpHl4vnkFiiXE1ay8Fv2uNwVFCTKBKe6MG99GvzvS9j9AIIYCOLv939nqtwZbe5AfCLRHRnhijH8cucUoUXGVAsj2Ov/eVlOurRdU/pbU2QIOQehxdzDJj1KCeC5FmFZZl7So3VU/87UShCP+2qnI7muGt5dgjmAj2/rugJXJtTGCv5q2IH2xjjsxohu74NA+NNZRJZwlM9y4MDnfjfnQTTWnyy8iSflGO91I5SY6E80TNO5zwrVC4C4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd6a54c2-50ed-4bab-41c7-08de2cff597e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 15:20:36.4359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZPa3/ry89tyRpbyCDAsH7yDEbn6TUrToo8S9jJHVBawTQ9uwF9DupztuSbfr1zxZK1f6zYt2zj9L/jCNHlTFyEEA4S0NITUp6tz1cvnEDA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5545
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511260125
X-Proofpoint-GUID: b_tPs9WclqAOWIFV7cfbDyITppUqgWhI
X-Authority-Analysis: v=2.4 cv=ObqVzxTY c=1 sm=1 tr=0 ts=69271ac8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=2ZyZ724H-TOBEjs3NxoA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDEyNiBTYWx0ZWRfX01j3LRSfuDl2
 Yht2L936yHPYAa8zcd7shokQQSgwipU/kzef+IYq58ZR/fXCQUk0g4YJ9k8B2L/Im4QI8Yu9JdX
 IqgTbN54QGVKDS0I6zcPobhsXTjvp7A7ZsbI8SNuz8qZ/+1wnSrKf1H9tHjn7UTWXY278DcUjNL
 IUAD3qmHCAYl7jdv9paFFeVl5x8TIbfN+bXmrNn8CxT6PmdbmKPeh5Lwr+y2Opw8Mr+lsn/YjKv
 L6ihfSshctG+m6EEGzH8eq0cPo5t1L+FxW+7deA/pgeYQpr/4pJZM0AviFU0nnYXvqX8bnOdII4
 BBuOdHgHUScR5c9GafmZcYPKLawLvNzvDPn1mbwxlK1NEFw5DZc8Ar6tYa9Ie27oUG97YdVTbUC
 /Y+VAEjNwufP/7ycWGIiTd2clhj8+/5OICz+d/JbHhIg6SY1PgI=
X-Proofpoint-ORIG-GUID: b_tPs9WclqAOWIFV7cfbDyITppUqgWhI
X-Rspamd-Queue-Id: 5CDB44000E
X-Rspamd-Server: rspam02
X-Stat-Signature: u6bbchbhxu1a6berqitrobs1fmfj7opu
X-Rspam-User: 
X-HE-Tag: 1764170447-364750
X-HE-Meta: U2FsdGVkX1/5vMW5AXIVERq5Ddad0tYP4RYdb0lFCt1IJYkmy8FOlgmrDH+dQUbaHaZwSsoHjrGPYQDA9ioZZBG4babZ0R+Gt8EtcgS68v7sU/l25kGbsRSWXKTo/pCvZQy/IB0s7ENbTaLc86Z8uq6Lb27QocljSL+dDW8h69w84c4z00JCuirx1EjPvMXNd354wGgGQWQLy9CHWoAW9m+bbegIzEdnLQScLio0fgq9DCDL9lmj4/Gm1pgDSx410k5fmNKQLazhfp8gE3P35hGhzjxlovODT7JP0NZFHoousBgiUPSPxcp39o4THGMBuBEIfcQiHWtooA06FyG8l2bZDmaS7cWRJoidYDoBWnNOKSZ/ZeA3TjF/WRlvAdm/+YRfFTHSkgq9PlGez6ttLQe5gGHZ2s1Y5V6QhYtMUGXgujMPL17lO5SwQi4dlJEfoJMz50DFtt6cG5iwi27qqV2AsXt/VXOOKAwgH8kCaLaHkI62uGNGS+xzaNR6MEAQBU4ZxZrC8/9qC+RjOjF1S0zcmEVUB+vExFQv3URguqSUZzDfF643RRFPThI2/r/AtQPor137M+/lGxxLPB2fupldVzL341D7/RYwIGSyY6ghjk+k3ujQzK4ujtvVp03/3NnaSr+2ch0iZC2c2Ttj/RID/hm1BdRf5f53X8rvCih4+HxpWGZmPZ7kd6cb3HHaRxqpV92aP1Q6mWrJOmrFclhxKWpnpJbqLoUz55SbIv7kfz1SL7H9kMkMwHfQiFxZhvDPBIBzTHZ4uKSo74FGuuUtBI6X2CZ+DbBStKztY5VGSDknm8yQltAxhteys5KIHAVNZSDfxk6ATmQzpqt83J52l/cKBVGpg2Gdkk7CRh1iyIMA2JhKHTzu2lRtII+qEHdjx3GSzyHFb/WpDjocz2JAGIyECV2RqNWmpSKNglPh6DQF9BmeILPVUf9inwlDXK1CkXT5Sabywv++VWw
 nMeyZmCv
 WLlTAZamxl5g2SbffNyN45JnaImZYwdhcMzFrG/AhroTHKOOPR/sz5NnjePn9gtFtC+ZlVkI7fK/f5xz1XK/loI4CqpKO6T5PVwoWeYY7C57Jn4pF69qrC8cguvzFbdjbw1vNQSrRFFwNd/COxYluUlbIHSvKdt36yTU5DMFHIPnX3s0Drir2QjykWOyVM/EW5mfGYTZ5L7Jq9ouc7qygTQx6Bgc+0FmiGZoYOwNVtQNra4TdvLW1+o9pWssr/Ze8Dj9aZUVn1vNm1df2lcUhWsW5gTOgGMhr0SpmnH7kpA3rq6mjMqSyIm51EbZSyfvArnNqLoB4tfbQqBt/SK0+KVgvafMS+sujsPxNdJ7cAddtChs1wCCoXdl5ejHB7KaqNRXIqfBNy15Sy93amELBgj9tqXZZwk+xo+ZLC+aWveH1AZ2ho7YW55IAyb6sMyTvkbOSzaSS4Hz+oQqedp18MzOPqwy1ePRqgPxmsLv6W7klSPJWXjmVwEYOX8JBAoVnaIfGbx3PMaUNdaHN6+FjqMyl1l4U/QP1VHcSlIn4+2PPdiHo9fG66EIbL1OrBhlNC19pi/MrRoR9IQKfwdFM/LnJV3SwBtmAUMAzQJRpmuUFE6+1LM6m8nI5R0N+SX9Qv524Hmc4dAD5E3PwAeWWqyOizRwu2lEaTW7eAc2EW8aW+hg36wOv1prdu4cBqtC3lQkZ9cljANTZdfCUL+5MFIvRNuhlhwWYoPQ+Bk4fYkTujrLX1J4kCqbrC/0kkwkajO7glQl6eakrLBQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 03:05:44PM +0000, Matthew Wilcox wrote:
> On Wed, Nov 26, 2025 at 03:36:46PM +0100, Vlastimil Babka wrote:
> > On 11/26/25 5:28 AM, Suren Baghdasaryan wrote:
> > >> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
> > >
> > > Doh! This is embarassing...
> >
> > Hand-rolled synchronization primitives are wonderful, aren't they?
>
> That's why I liked the original approach of just using rwsems.  I
> mst admit to having not paid attention to this recently so I don't
> know what motivated the change.
>
> > > Wait, why do we consider this as a successful acquisition? The
> > > vm_refcnt is 0, so this is similar situation to an earlier:
> > >
> > > if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> > >         return 0;
> >
> > But this means "vma is not attached" not "we failed to lock it".
> >
> > > IOW, the vma is not referenced, so we failed to lock it. I think the
> > > fix should be:
> > >
> > >         if (err) {
> > > +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> > > +                       /* Oh cobblers.  While we got a fatal signal, we
> > > +                        * raced with the last user.  VMA is not referenced,
> > > +                        * fail to lock it.
> > > +                        */
> > > +                       err = 0;
> >
> > Returning 0 in this situation therefore wouldn't be correct.
> >
> > AFAIU since we started with attached vma above, it's not possible that
> > the refcount_sub_and_test here will drop the refcnt to zero. We could
> > just WARN_ON_ONCE() on the result (in a way to make also the
> > __must_check happy) and then can return err below.
>
> But how do we know that we started with an attached VMA?  Maybe the VMA
> was in the process of being detached and still has readers?

So we're talking about:

vma_mark_deteched()
-> refcount_dec_and_test() [ ref count is zero ]
-> __vma_enter_locked()

(meanwhile...)

-> reader attempts to read
  -> optimistic check doesn't successfully find write locked VMA
  -> __refcount_inc_not_zero_limited_acqure() somehow doesn't notice 0 refcount and increments
    (??? how)

(back to vma_mark_attached() -> __vma_enter_locked())

-> refcount_add_not_zero() returns true

[ process gets fatal signal ]

-> rcuwait_wait_event() errors out
-> oopsies need to do something, maybe [VM_]WARN_ON() not right?

Correct me if the above is wrong.

I mean is any of this actually possible...?

Seems dubious. But I guess right now we assume it _is_ possible. What a mess!

(Again I wonder why we made our lives so difficult here)

Anyway even if we are midway through a detach, the detach is ostensibly waiting
for the readers to go away, and our reader is about to go away anyway, but the
process has a fatal signal so do we even care?

I actually wonder if a WARN_ON() is warranted to see if this even ever
happens...

OK just going to reattach... my head which just exploded from the above :P

Cheers, Lorenzo

