Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BCAC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72116B00A3; Mon,  4 Aug 2025 11:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D222F6B00A4; Mon,  4 Aug 2025 11:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2AB6B00A8; Mon,  4 Aug 2025 11:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A5FEC6B00A3
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:24:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 289D659BDB
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:24:35 +0000 (UTC)
X-FDA: 83739446910.18.81A1CC3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id ABC61100014
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:24:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LctCQ0eF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="iG1n53/8";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754321071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1IZb+qzktqBySLgZuLwT3kKZMbB8r9Og6ldE+52VuI=;
	b=booFwY6MhlpUQ2RAi8R6YvwYJkcA3ncnpGhBZie/h0VYt+NrGmVdCPWwkH9k8V5cmXSsLD
	Lu7qpl2sq1ZmtyNBGc3brB6bMAZBm1+9OPNDQHJb+bWIi4unp9XHgFwu2qsntMoB4Tvq29
	jb4jsp6xr9w2JWxqazGDTkz+0KyGuek=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754321071; a=rsa-sha256;
	cv=pass;
	b=VSyzDs6LMcK6r/YB5sc6ZCLLIDGmoFgg+ThbE8sVy0tL6H8rLe8HqoKjoYdEFvsTlQQjG8
	jxQ40HK7RlEFCFSL6HUrA3rzm4yF8IKghl7PKSKZ6IbvCsqRHCSaOvg41YHT+4Rdm91/rd
	nqeuTSY3I5DHifxVxpSkJHyR1LV1xjA=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LctCQ0eF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="iG1n53/8";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574D6W85028472;
	Mon, 4 Aug 2025 15:24:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=c1IZb+qzktqBySLgZu
	LwT3kKZMbB8r9Og6ldE+52VuI=; b=LctCQ0eFIiFcFD01KifU629HzqQwNTjkZb
	uG8juq22op8YYnBrX4FUQSNTCPXYFL2DtdPCAitvMLl6lEo50n3Td5h9qW4tS4QW
	obgB48CRkqxHJTqE6OkW/n1X1Xj5Hsg2JLsv3U5m1XsBhwlsLRLQHuo1gM+MuOrz
	F4OSM8MrbJ2ncxSmpaquslWrU7tBalndl4piuZE9htEdjBMgLDcmjG7W6DK7WwYv
	21vrMpaLJZrXsyrKtdLweuNaiZPvPgYyTqI0xsfqjBBmo+xSzuJypfokqDavgNqa
	kSc2mI5TZb8bBu10FMzfgV602pKqe9CZpaLrgn1dVoHJaOyXz1eQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4899f4tuyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 15:24:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 574EAx9R028780;
	Mon, 4 Aug 2025 15:24:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7qcs086-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 15:24:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wgRx1XQU57MfDJg/qmIQ2EliqBaVye7UHxg5HFhgFiA2rPD+3McN6uMidA8+0k4O2lD+JqOK7HhzjqXXWG72wIcfHazRd2wUn4gxH5iX7XsniSD8uj4DAyU6fTR3FXRygp56EZfzLGhhPztTbsEwVMfm3ADW7ATTOkg/vSk2Zf5NAe76/4QpvaqGPalzs19j/X7OGsw0XKPNzUANY85WeD6S+jxT72WaZ1Lf79NhfDGhTzCl3uRgT0/0d80D+CbVCvvKR8poKbGKuv6NpUQI17CJ3Ds15UlF8i2Z4VyuunK50JvekxHr/gvySvJ0TBthXmrsJOjTsLGm9EuPmrSshQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1IZb+qzktqBySLgZuLwT3kKZMbB8r9Og6ldE+52VuI=;
 b=ILuh1+126CvHa8eN7c5419BHovhuY+JUWrKfYLVsElzV+hWQ9+T/w+8F+Lm46bwyuT9e6yIuaUs1jMJvV5Z8JEHR40H2Ymx1QhFIyjBnR3uXVXKA6vJrYErHTocs56Xih2XjtsOuwxnuSD8fZazJ13JgPwYljTJTrM+tfzDsHzDsGvH++rwc4NMQ+UscjWAxgMjKkP1pTqwFnYGmb0lhFT/yQ1+ORUByu78e2BoxY7OVKkLjphq8OSoqnOPD1SgALEUZ7XagSr+hVRwHpTkDewhFvGoCboYmv3f43XbJc+NoZvq/h7v+YeirNOAO/45TkJYLc3AB0Jb/55woxz2gnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1IZb+qzktqBySLgZuLwT3kKZMbB8r9Og6ldE+52VuI=;
 b=iG1n53/8pgbydYwKT2G4dWqRer4zKlaOiGEVy3hI887ulqDAKrSG3GwT3hDz3oYuSkegEcUQaJE7RP1vIGRpk5HmECykSSgXfLE7Pi2xKAtV1zvRtKCL1RosHq6WcrGEuaJhePiC7ASXBsC/PwT4Frci4tYjgq53qG6Q0paezZA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8539.namprd10.prod.outlook.com (2603:10b6:208:580::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Mon, 4 Aug
 2025 15:24:06 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 15:24:06 +0000
Date: Mon, 4 Aug 2025 16:24:03 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>,
        Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
        Dev Jain <dev.jain@arm.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, willy@infradead.org, x86@kernel.org,
        linux-block@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
        Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 2/5] mm: rename MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO
Message-ID: <6abc4c98-1b50-48dc-bc25-9455439a45ad@lucifer.local>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-3-kernel@pankajraghav.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804121356.572917-3-kernel@pankajraghav.com>
X-ClientProxiedBy: AS4P251CA0022.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8539:EE_
X-MS-Office365-Filtering-Correlation-Id: 1330c3c2-f1ce-496b-d29a-08ddd36af386
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kTI96CV1vtioXe6wSPXRSzxdOIP+29MJ2UDcJpgWI2/Ju/DjQ7vNZoVquRiQ?=
 =?us-ascii?Q?1IS9T18AFF0BK9a4CkqAVGDf/gAAfY1SNBL1BWWDrSReI9aiC3kwecGa9ByX?=
 =?us-ascii?Q?aGuhP+TGiVX/3lvjvOxzVoHe2WtOaqfgK8PUrh8GsOn7Jrzb5qAvNvWHNeS+?=
 =?us-ascii?Q?zjAeIQJEQCtOYpPhUMMpNcZz+ryRcwumXt04MDpwz+iX1MQ9FFHgUIgKfBy7?=
 =?us-ascii?Q?pYSlljj8vegW0Ocd4RXQ4MCAVE1Qg2VvSnhfhRp5tVA/s6iENKbu7RVW1Mrf?=
 =?us-ascii?Q?CQDeuCaefWOk4bB4ImxLOjKygr7RFegexOwLYd87kiDvPe78C1kC47VDYdit?=
 =?us-ascii?Q?k4DWnKuzto0E+vmifMrmgsSn6dxX5G+dWU21bqnyKTFLDYttsO2dfuqqDafY?=
 =?us-ascii?Q?Jpq3DpvcBtQMaRhfxhWJx68qZSBFMG6xBYiPYaanJEqlWxtMlWmBhEFo7YmV?=
 =?us-ascii?Q?cG5K+Fb+7D6tv/GjrAyJiyR742/aM1WI7sSFXBLxIUn8BTaGAx8TUsRCAXAd?=
 =?us-ascii?Q?F+bLN1i8k/95xPd2OFTcSOEqfMOd99FVcCj+97fcW6QfRHuIbC0qdn94EB+F?=
 =?us-ascii?Q?+WzRgl4S8aNjS33DONMB60lLqICd88NK2+hmMJ7JXkilJs0ss8z7HcVszsiX?=
 =?us-ascii?Q?acr5nLWqoJzl8tvzM1R+iMQFzijkjvv5Y5Fvjq/wfT8ZP+TREDNKFyFzTfYu?=
 =?us-ascii?Q?L5bU9a0ukdUzVCpJKAIt7vs50QWHzfqvOix3uUpV2SLuCAn+O2N5/DcrP7pi?=
 =?us-ascii?Q?sBN4M1LKmlOjI/yGiuZnTSWpgLxPOiA91qNtwo0ilVUTfMr+lpQMSbQy3Db9?=
 =?us-ascii?Q?qMdwtIYi2kjDV9zTMadYpD7j5y8iOhk67nCGqKMWsUmhC3XfjJAQ+PDr/qED?=
 =?us-ascii?Q?I0dFEPkPYKDi08tG4MiKzw44wq2AzNUwPZMcdanWo8tn2PS+GdCNCQ9RrR/l?=
 =?us-ascii?Q?44UYU/InEWRYSydtBNJ0HjviEgYSDsv3SuUQW897v1nKePSzABIPhxh2Zj+Z?=
 =?us-ascii?Q?AamFzo8rOmt4yPQNryLDJn6g1pqgBhcD55HusrKc9o67XOvv8Mh/fraaWmZF?=
 =?us-ascii?Q?B+3uXW671RK8JwxCN8O17JETxkks3/Z5e7YUEKQex7W67zsYPJorxEy1dt6m?=
 =?us-ascii?Q?gWI3PkwQBSg18QQpljUtg1ffy65/e+59FXgS2IXsEC+NVJEU9v+0AkEohhCD?=
 =?us-ascii?Q?ZmoIexyS+wuoNWjKhC0Il8jU3Ofs272tlqUqfJrQR5nXgolS9CRzipxdTvuI?=
 =?us-ascii?Q?W0IJafXrRBMLhNIi9gv4Iluju8D6bct0oeNta4jeMHCEgWMTbXlsRQHOu+5H?=
 =?us-ascii?Q?PBsMwPzOTfi3Ol55CQAPGk5ql3a8U1sSpOi6cN/ISjGEviC4xTm+DSuPGmeD?=
 =?us-ascii?Q?JRb3A77YHowqqi9DUCZSRCCI5wghfFbyQiABfvGKguxRM7DOUN1TxTR/fd3j?=
 =?us-ascii?Q?MTpTzdvOYb0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FhIyYp2siBxYDCm5PZkD7fkE1jPNrHpt5/E7ujoswBjYsF95OPUoslUjZeIf?=
 =?us-ascii?Q?VZFwANsXNC6RgeqpJLrn+VPfxfpY5smhFrg7W6YP17asQ6jW+N+7yEVRVMcd?=
 =?us-ascii?Q?lc3V8TiUPIhiFkEPOtn8m7akNTYbwgPdyjqNuGgTbDZQoUnE1k4q23d/810Z?=
 =?us-ascii?Q?FyqdPKcsbchv819ZaCjSK1I1/oqC8Xs+d8qmizqvadI3MuZ1d18P21K+tpAS?=
 =?us-ascii?Q?JQCp63U32UF58/dtBwRa85NemFHRw3PRdLo2Jw26Qc7LDMH4SjG+zwjFV9OC?=
 =?us-ascii?Q?tJFtguGWqaAn3b4F9sqqL0y2Y+RdpvyQn+Oz6PhG/t3xtECL8lqA7PWOOZLY?=
 =?us-ascii?Q?k7Z08JHrlTztePUeWBd/Dxrq6Xi/SHZ0646Cp7E852qPbEvVnyOgnlEYLf99?=
 =?us-ascii?Q?5jj7KsN8nWgShNR4p12wPrRDqn0mTcF08foP5MJ+m3srG/1XSmCgK0gqjS1j?=
 =?us-ascii?Q?QPoFLqMkL6ZXrF0oyLFPSTTlzq9c8bt+UwIte0iWx5XG2lELi9HaYnEKLo2X?=
 =?us-ascii?Q?02nrYb+t5V2VLIUXCNDZ6c+dxg2XG286qcN70oxXZzkM0syrRkn7V5+eIpuT?=
 =?us-ascii?Q?EEyBlyKzuJMXmRaG7CWzWYX/w1+tsRIKB6LtiZZab8944QYuCgytLtunA69u?=
 =?us-ascii?Q?MLLuNTarV2yuf+ituQ5n0Ga7+wAGzBx6tNoicuMg34OM/ALShq/ZTPKGFVVq?=
 =?us-ascii?Q?oyY+jHooOtx0onr0g3NcKeJAry9Ad+JjURQfapSlWHA/mrb+9wYAi8pUYjhQ?=
 =?us-ascii?Q?5gG+IWdFZqeCS66/vkihL3YcEYj5UO2SE76hFSMD9l3hYHpoq1y5WG4EL5XW?=
 =?us-ascii?Q?e8WjGUzGS08vagKp19e+yPIxVuvDXgm4vzmjevVXShpXndmPH/koH8oVWwZZ?=
 =?us-ascii?Q?MVQH88tIgUeRwrM9ty/kPJkbHAiHUEvsQluZfPqO5gZFwaeYtyPAkFX6ziS/?=
 =?us-ascii?Q?EAeaHUDxN4gOh5OyhzGdQRM9nB5516+ci1ALCFJUjyRzSw0ELZ+yIdMcCZj4?=
 =?us-ascii?Q?cRDalUr7lp3Rm/+W0/JbcE8Uzb1cr9yCbC3BKMdRk58Snh1Zy2/oNuxfbIHr?=
 =?us-ascii?Q?Qf7jGwhGA/C67UnN9NVKzHTJwfXxZ9V04ZVjSR12n8KYxBYcA6R8qArRMO3Y?=
 =?us-ascii?Q?/jYEce4UWkHX72jR4LEe4CuPupAOknK9sEU1X4gKPcR7Fqepi7mh1UTswDTU?=
 =?us-ascii?Q?mBfZuUG0JFbfCZqR40dL2nzuJwJC+SXlIlOK7VyZ7nObr9u5gHik0xTviUwl?=
 =?us-ascii?Q?7wJJMyvTs09m+vpnIJAJ2WnAX2tbxcHAqz02bxu2xF5Iaat5HhwjpNu7/dVM?=
 =?us-ascii?Q?7KrbvOMUL+3SgvpLa5iqSIaj0Fa7ekBFmxSrTTn16+/eBN2EP8eXLWM0uqWk?=
 =?us-ascii?Q?AZOdFfAjBxJfhaWTUI2nj9HXDrqX8weQkAqvdGN4u7tofCXVuHzujFxaMeJ7?=
 =?us-ascii?Q?/K13P3ydWtR7qefMKKpbHMaivUZct4XnCrBGRDsZsDYogMRyIC9W23ifTOzB?=
 =?us-ascii?Q?w1hFX0i5bAv7JNp8dG8iKLt21SAzse+gIrom+qybA2ZZuBg05CNW6Lw+0wNb?=
 =?us-ascii?Q?eKPz74RDLk23VJMpPwqKyxj5wR5k2zoRETEFRCAxlFIEuXp5fBokTJS2JfGH?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SznqQUfdJUZlcqaIJqIfDQtB2i8qyNIxbPqcnbob6NItSwGpGu0Z4iUUuuHLLIz2fQd3+v7UxkLZ7B/7fN9hsxX/AzRYW3bo/MBAsVgr6H1gw2BFqdWVIWac9DitlJnBA70+12zpGoIqKHIYrwDHea9LzX5H8k/akZ3cU/srKnxaRHv8zmA1hqhqBp0EpTs1c9xvVt6pcVWKuPBvYAUcIEVOKZTQoANbzUGqopO1B1queTT/QBCn1U+7MsIl/oNUZeHsglGCRtNd/QLNXoa7t5zn0fq4T18JbBLdBbl6iJfTXL6v7piP6CT2eJQP8upJCPL3gVWXgCWS7Lz86Wh7avH7d428afTZ4IACWl0z8ja2H7Q3TaJL4+T8ZvV+9CjUNmsbicWLBLYDZTcMKVRmAk/fYfgDnNdXxB4m4haFKVg19eLZ1ipzQuEo8Ng60ge74d6n6+URW/gaZVRmhN4q1DGLcMqqIJrm/VAwAO5Cf7SVPASlwMo71oN0Ta5yDs6V6z1BDhMD16IJmNUJWEcLKN+fptFNNRnEbNW0WcYlBe8E2ydVfcWHi7grxBmqbznRw7gXFva6O9Quzcrh8L9Wfc7NRHbgyJ3LY5MZLBfOBrw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1330c3c2-f1ce-496b-d29a-08ddd36af386
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 15:24:06.2879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghfDcbUPBN13D/APmqH98R7KQ8SVG/oR1QMWeGvaoOAkwjhiTOf27hSRdHzGvVdGBKjIHWmKmltmsEdwlF8N1FDCIb3fT9qjSUKbjtFtc4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8539
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_06,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040085
X-Proofpoint-ORIG-GUID: M_lFIEvZPPTBfPFJfg9qo-cG1XrsqTVl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA4NSBTYWx0ZWRfX0VD4/VOasaE/
 6NcRvlfx1WL85w2UN5LyJ+Iou89CmdcDkYgHBM+I4QwUWIg6aCTyg0Eoivo/g3FD9sKzYuRmJ6t
 tUmoCZe6VQEfhIjQstdT11TnaPAIEZRZmI5DMq0qQDj8d/MheiFVB7e3UchCyiqXAN3OVjSXnVB
 ZOaS1AF031uLo/IbtOeiFq18FNrOSoOOXp+s7Cc0Q/epNHyuXngXIuGjTJzOxBFc00teVIjNjfL
 D+kJlvkD+EMEskpHZkNwQXyxBIfPeWumn6PKSCz9u2lNOkNYnnt3IOwvF018zvL1NxElQrR1Pud
 XNAcffrCTou9Ps1OhcQYcQjNbhzu+OOsdR4xL+17GVC5xS8B1Piw3PdMhcwpvR9CvCCOSUKQOTz
 pwqu4lLRUbGlHIMgXKlnFjXHE4JLPkyLn/f9xjlptwJ4UP6gCHU+KsfpmDMfNZuYlk566cVm
X-Proofpoint-GUID: M_lFIEvZPPTBfPFJfg9qo-cG1XrsqTVl
X-Authority-Analysis: v=2.4 cv=daaA3WXe c=1 sm=1 tr=0 ts=6890d09b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=hD80L64hAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=WPonNpgQWiL6_P7nTeUA:9 a=CjuIK1q_8ugA:10
X-Stat-Signature: ozp1dyaiigzw58k45ijudafucmrdosbs
X-Rspamd-Queue-Id: ABC61100014
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754321071-33643
X-HE-Meta: U2FsdGVkX1+q6zqWzb8lHkc1U6jfdt96OKg6ZCag7KQpIOqoDgxyV7e6rXzrOskDCkD9Nqq37/Nx2ksd/OhQ3Ny4neFJYkTel6T8PDhRIC/aDEekZRQyGNBe/4SMTd5kKjCQIlDFeaP7qfbRHO8g6OCnhFLRRH6m6NStsPOgfakhbeprRBlr1LPm24jepYVEQl6WiQE1sWqLdyjqtPXOESXmuSlo32mdF2hb+5LPAeFZHhZlo1Zmyr3izZH0Ke1dio9wmiQofDrY4SHdweIG9fbyIv6lX5cR2wbAldM99FZr0ew2tCYLe/ETiXXJdg4OQXlHA22jXpnIrkHcVtHD/kZo6nBSwwt9AKeu0UwawDap3n3ihvi1p5ksY74m6sdYVeqipVtST1RwO761w/8mZ2Vmu9WupIDjATa+avjMbbYY4xnaM6ty0RmJaI0rqA0g6WqWwcnB2wlveVdFHdkqrmw5L4Yad5fbjf1Htrx8/UmmI8XGY4CrRqkK8mTJznTqN/bWSabt0WH+ePwLoNe25OdF4/z9LIuOr9svf0lL8owHVQDo55ciJFuPKNjT6+KhTPXrccdjVnMH9BeOfamv1TBIj/YFxXW8d7M9x2Kh15zH8Q4/9LjUIfigNq33puSUaJAAi9n+v6lnGEE5fWilyV9jHz7gST15RbWcp47AZyIy+h+a6eJRDJ7JPCXUobskJF795orRXiiYVt3KHPdOP09M7xSwvOiAISoheJ+EQn9O5li3D//vfmrmNB/uMfFZS4BKveGI+BEnUIdJsA6TuVq94jQGQLgy/3VxP66/EZnY5nc3X47EJnImE2H4Zx5sfdeCsSOVYyIVFXxON9VgTS4kTE/HIykSVYg6MqZfVwzEgQ0Qv/9w34k8Od0w/zvUSDTjoCC5LLFJvh7uhesw/g1jNMkPZd4uJBOAKGlEx/Vtl5hfzba22vr4wEQb8kDvBLjmDG2KZgtJ/w7fcUb
 Ly8ekkK7
 dcuPTVcIe2Dx3DEiQ5VVO0s1n6VhXC1DwfAXRlKoVGjyXgxtnvgNJv0ondUqoK/yw60hZMv1oxBXAPY+vSy7ctsB6GLbxgdfe54P7WOtmJjtk0yUwInGxkFSxnxQ5YKxSSXoo/jXONvpYGHKMK6X5CBuA6G5vIhmm4gdr3Za84me4tE2CaJ/MYZvn8PCMhbQaIrnysdMwZne66V8fSiZqE/QZOda3gTceccw5Ss8+GPa7IhwyopYgdZJ8Jsgj16/XikdPJQF/sdGtYA7Bn4dYFAQr7qVACs6IJ95qDOo1st4SOnhm3RNi5hu67TafdxIWTSsC2jrR4bQwKR1Qmw2DROSPTu6U8yEq5Tz4pWbEjeY/0yGkNt9rrQK1bc3yuQEMfCxI2BCLZXepU6pPFyb6GcagOGyf30nPlNP769TaAE+q4GXPP+qjIH+X4tbf61/fIUTsF1f6sPAE3WmSN8IUkFYsJxHr2QaJMHoHVkKubrSWNBd6mNhNzGAy+ipdSgOJMfLMSNu9n2j84J453PuhQ+z03kwMDbP4Dq1+MNjlIQRy9LmA5F81mdUXyMbuV+rWoYMh/ABh0/uWRO+iHMGgXopLkBNiPf3HzzRBG9+LFWyvBMe57E2fXfngqK6JSWKVg2Ab/Is1FdCyctM1pest3NntGbvU30ESpz6L1z507vadmpFNnhjQbhc7ASav5iSoHOezHJ/V8JTzv1PDwuq9rJgGLM0hGzwWTkXeCptrI6TYYCoTW8y3I9KimHKJWaAC+uNyRwgWnXhslqTtLMrRejvzEJk3bogTFy5bq4HNHli2H4AdfbzT2gHAXvAsakQZ9iIfo4fv0fRJ9UKc24PEi8ie0NVUOr+BUFHThaSacie8RFWUDQHcYl51bdFmAH9oPYbsENMV4jqGmok=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 02:13:53PM +0200, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
>
> As all the helper functions has been renamed from *_page to *_folio,
> rename the MM flag from MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO.
>
> No functional changes.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/mm_types.h | 2 +-
>  mm/huge_memory.c         | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 1ec273b06691..2ad5eaddfcce 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1753,7 +1753,7 @@ enum {
>  #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
>  #define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
>  #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
> -#define MMF_HUGE_ZERO_PAGE	23      /* mm has ever used the global huge zero page */
> +#define MMF_HUGE_ZERO_FOLIO	23      /* mm has ever used the global huge zero folio */
>  #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
>  #define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
>  #define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6625514f622b..ff06dee213eb 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -248,13 +248,13 @@ static void put_huge_zero_folio(void)
>
>  struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
>  {
> -	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
> +	if (test_bit(MMF_HUGE_ZERO_FOLIO, &mm->flags))
>  		return READ_ONCE(huge_zero_folio);
>
>  	if (!get_huge_zero_folio())
>  		return NULL;
>
> -	if (test_and_set_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
> +	if (test_and_set_bit(MMF_HUGE_ZERO_FOLIO, &mm->flags))
>  		put_huge_zero_folio();
>
>  	return READ_ONCE(huge_zero_folio);
> @@ -262,7 +262,7 @@ struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
>
>  void mm_put_huge_zero_folio(struct mm_struct *mm)
>  {
> -	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
> +	if (test_bit(MMF_HUGE_ZERO_FOLIO, &mm->flags))
>  		put_huge_zero_folio();
>  }
>
> --
> 2.49.0
>

