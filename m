Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E1ACCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E63B680067; Mon, 27 Oct 2025 12:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13AF8000A; Mon, 27 Oct 2025 12:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C666480067; Mon, 27 Oct 2025 12:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC2548000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:00:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E28D56F2F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:00:47 +0000 (UTC)
X-FDA: 84044357334.10.4B480FD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id C9C98140026
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:00:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ekRDybaw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NcutKANK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761580844; a=rsa-sha256;
	cv=pass;
	b=l0sT6+C/oF1DGWIYFJsHAKzvl2X7uqF4LjthpEDH74FoRmxUq9rV+TAmBxEVQtLMUC5JkI
	nSg9M+WQF+Upk1KiuxRcn2wiVzGZfEGdb/JWMmqFrHpWduEHGccb4GmahEU0g9wyhTaV7+
	/U974D+JUVxz6RRHcLO83h4Z6tH3G+A=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ekRDybaw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NcutKANK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761580844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJdM9fHLCsIUA7UH0YTR4wOXd7XmM/TWwZwb+PY4MVc=;
	b=y9AopQERJs6Y5t95AIyFxJgis7TdoqjoIvl7gLjt1NR2XNYHxWdpVdhlHwFpox77AKZ4UD
	p07QnIOF6QmTLzM19ZR6kQISPSSptWIjtwm42LqvKIWow7R9cOzs514WIv1pejY+JFpcCU
	gJj/8O/7YYkRtEBI2Da4uvvDZBQEosk=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RDYGSI022180;
	Mon, 27 Oct 2025 16:00:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZJdM9fHLCsIUA7UH0Y
	TR4wOXd7XmM/TWwZwb+PY4MVc=; b=ekRDybaw7609yGompWTCtHvncTZurA2qPU
	Lj3DPoQm3+oE7j+GtrLlHH3lcTd9dKx9v/y6r8ateS9QWqWtEl5DID7D7U5asFoc
	cW7EleaeHnIE5kQRpHlVyR0ohJRLTsHM7RMcInJ7xF4Py6jBh2khHuGYYp2hHF5L
	JnQo8wrX6KQK566IuW6XBHEewL+1kG8wKLrFqVhiF1xrczRQH7IkXclDQar256Fp
	JybK317EHEMe89pN7C6lUdtW2G3rDfxXXxaI7Nmlbl54UcQLA7H276cXAQk1Y/R9
	9G+bpIW2nXiPuIcSm51i5eTcUoKv9h0cfeQYbT2P1Uo8mYUWdK4w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22x6s9nk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 16:00:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RF61uZ037611;
	Mon, 27 Oct 2025 16:00:18 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010027.outbound.protection.outlook.com [52.101.85.27])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n06ywdv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 16:00:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DYVVwta7uV23XQXwoCMEos4GdY7HuhfJ2msU0ZYBNVzSmJ4lHqg/8UqKnyo3QuKTQmbqepawl2eccVV/pC3JG78NNcr5XtczT5ilRZnPNv6cWrBS36a2IIY2tCy3U+eSpJPTxcDX15VILGpew8VAg4XmUaSSrLwxBWx/ygy0t4xrHSmqSqdqocHwHQ/dkKn8FAgci7dflCCVYOelvP+E1EVs9araEDCfgMTol2tGvEIDZXRBY3KoDmbW2xPqYHdlSxxE9f3xMz02jhJzplEDbGkag8LbMjqiJ34hoRy4FTlkuso/UeM9Wh7zJkxQFBtC4Z7KEYv8rutS+iBFipZ6uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZJdM9fHLCsIUA7UH0YTR4wOXd7XmM/TWwZwb+PY4MVc=;
 b=T+hwMf3pV7Eww3lRqlOd945I0VHXx+MaZddsvUtWU1RYQFi8j3ie3v7wDaGg9xAUhwcxznPPZpoxcJT55F3dyZ2wE95ti9HWDvt0XlfInVqQhohxwT/MxpM8AuRtTiB7WcpC6ngf1eg06DoIJkHIpSv4tsqW/dNg7XXUe/6uSKlcPugIOdux71bXkL5jCtcIiO383oINH796/lKAFTgswiWlvlWuQx1rHK917bvcKYQPpXvtdUH4tVHtape8vHuMEVOkIRIm+gA+6zikCQMHJJiRcwxeUsD/cEtQsfFiIDMPvgvjgHDwAO34dEeI2F9ldlMtXXJbIFk6p18uOxHjyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJdM9fHLCsIUA7UH0YTR4wOXd7XmM/TWwZwb+PY4MVc=;
 b=NcutKANKFQNMZZhJ6ze5KYAc+db+6BlWSTUlSsQ5OmV5XBAyYQfbycr3K6zWhaGR2PAYgE45rGjTWRoJpfzEf+UKw4AViDSkPpy1OuJyEEIFFbxdvMPDSsC15YbCRhtjpFGkK4EFy0lpDhTVWNwjt3d2hNzE9lvHrYenAOBe/9s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB5898.namprd10.prod.outlook.com (2603:10b6:208:3d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 16:00:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Mon, 27 Oct 2025
 16:00:12 +0000
Date: Mon, 27 Oct 2025 16:00:09 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 05/15] khugepaged: generalize
 __collapse_huge_page_* for mTHP support
Message-ID: <c006138d-6d12-4f91-8a06-da279ae3795a@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-6-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-6-npache@redhat.com>
X-ClientProxiedBy: LO2P123CA0098.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB5898:EE_
X-MS-Office365-Filtering-Correlation-Id: e7079a2b-6e30-42c5-003b-08de1571e90b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nlwBOXKwJP2ik+FcS0kw6wg7x3obC+CQTUETe4GzqLnGAsP9yIqmHsPqiSSD?=
 =?us-ascii?Q?WkxH7GU+M8SLGQbS1dJxZ00KvftcKN1YBxtmlZLvL6g6gayQnwWISloDLirj?=
 =?us-ascii?Q?ml9YjQ5dJYi7lMBtG7X/TZtr4QY5m55bzUfJfgS2RtAGEtQaPKUOttBwdPVC?=
 =?us-ascii?Q?1HU1TiLU4L0U1FN2NQHBJoh1+Ei4Ta0HvDQ7Ge6Abof18/J7d11iORY41amc?=
 =?us-ascii?Q?+UaNRqcMiDC8NMV9kr/avDntusI4Vti7iGmiTfVusTwcxyjFPm02UjU8rUI7?=
 =?us-ascii?Q?EWdpAnvZLOtSmZFk3hVloijD9X2XCt4xP+ZTfEA/1xEklKiuMfzbyPpqAHh9?=
 =?us-ascii?Q?Y9EW7d6b/lymmP1gIwBZcC43crOU4bjHMGkRnVS79ytVQYsnGB0bQHr04HyK?=
 =?us-ascii?Q?iQEg6vga1U7nBuJjdSbkuJBzVdSslRYGaRhr6xWvVRQhfKB8qLZ/3krwrgDw?=
 =?us-ascii?Q?SMmGqtjvZ94/vfbrBhAQ3vnee61OoBp0RBGHdHvDOR9YfJH2UAnam3bAUr/0?=
 =?us-ascii?Q?02AAnpqABzTur7RCRAUR4+1kzPGz2trb9az9Rg0ZQCC2pXKjTcOP+unrhded?=
 =?us-ascii?Q?CNyWDZcydLClL8zE5nF8Q9Ne11rdN+j9BEYmsEOUGh8DruL/5Hfq1lbb+QhI?=
 =?us-ascii?Q?hezTHV1c1PyxWDJtw0HhMzFAuTelgG9caYzfr0g0IJQt3U8pelgPmOFBKR8m?=
 =?us-ascii?Q?r78rMhjplg1paRSPHHew9fjKw/HNl+K6cSd1A+XWL81BmMcTgezPqGrgpr9A?=
 =?us-ascii?Q?TWzPZXAh7DkELmu5SeYR0ojM5Xw7AWC5H2iZLNCO/CTc9JjQIgqKEkZzc2NI?=
 =?us-ascii?Q?qnSJtYmFyTLemRP/Jo2rae7WEOLQPuPsKNTsPM7wHntAI58Sxxm6n1NimpCB?=
 =?us-ascii?Q?d51DuZnO0V/xDWA/BzJewVwEgFpgOlHg2ji0OydPR/UtqQEiMq50B9VQzzCx?=
 =?us-ascii?Q?fTPeX29hZ1Y9amjJIb+klBufcl+tR1mlNBdvzP9bLz7U8xR+lyV0eoJk1beo?=
 =?us-ascii?Q?PIbluNX1TzAuRs9d8ImNesKrV5Jh8W1whwwUP44M5zPXOsLnWYhgjlASVi2D?=
 =?us-ascii?Q?/jZ/ink9JRY6c00ZdEx7h+JwfRlT2CvIt3LNnCGJP2KRcXJtwAtkslz3ro5I?=
 =?us-ascii?Q?fepKZs5ZxzkuRX77UbxvGg8h6veXRoK1otjJBN06h2Nl6wPoQSczcCxQDIDy?=
 =?us-ascii?Q?FJ/uqWAsYEjU2pMiZUbxWcLZcg5oYQGGmbXcfln3x0fghZ/t4w2sMNWMfXyv?=
 =?us-ascii?Q?ikZdcotxA2hqu8iw0UpYFuHXD3Ks3etGrvkUXDwrdpr2t7x6ffMRiy06rUbw?=
 =?us-ascii?Q?/BlsYfgEoNbdSoRllo5RFDn4HQIjaxPfuY82H1nb2mrj3FoO0JqifrG3v9a8?=
 =?us-ascii?Q?qdEHeMnNOKdY8SYYypuWpClyE0BvtRu7zj7DMjzEFqRdlobT0vokKvbngD6N?=
 =?us-ascii?Q?TLe36xRc8bMCAEc/FFM9zXEdxgfMn5Xe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gTn5DiikZdwWZNmRqs2wWisuRGi0aRpSapoIaL2KVk5fthk3lhcHfnqC01ZW?=
 =?us-ascii?Q?ae/0JgsMe40chBSnTp/zdrsZaEvX1CyW/5vjUUJZHw6lXuvdedv8cTlMTdRK?=
 =?us-ascii?Q?ts6KyYDPZGzxmwkDwXdJn3GkuRp/E5dk607XaiP7X2nPQ9m4ULSui3f3v/LR?=
 =?us-ascii?Q?5BG9R8IeasU2NarLUBXOGpQuaqG1+xqiJrefh5Ro5VCAUh2uhLGVxKuqWEg6?=
 =?us-ascii?Q?CN0CORdIBtEReBwCb6g1T+tw29g8PwH0tuKo1J13E9p8WlSOLXvjdYnF5/jz?=
 =?us-ascii?Q?IvfGfKBmS5klAFzPRIRyDxLvvQ3FjSwEnlZLrJ8GZ6bgveDKxICX3cZi7bc4?=
 =?us-ascii?Q?EReGH+fWlTwcHA1gXEeHjDVJJfhrKvC80aLJWplCZBrCmT1zKVNZQoWtRGRF?=
 =?us-ascii?Q?vcJ0zhl8fckkmQUJe+GcPhRLaY9Zh9ammT4OTZZVOJ7c8Wz5lHB9t6RNpqFx?=
 =?us-ascii?Q?2D1D6tdMXIZG8M/yp/nHp0gd7MNfWPLMHoEUuAjMOvm12BQLWVOoTbZmEbCa?=
 =?us-ascii?Q?RRYUfXgHS/i2eqTDqHG2WG1hQMWJ/l5ED8yPAay1rmRMDHfgNUhkOehL5ZYy?=
 =?us-ascii?Q?0EjYKvim1+wDpkWzjPCIrmtVjqFuBXKupz5xxlvRbsUE4PJAh0VJysV3ePJ0?=
 =?us-ascii?Q?dWsa0n6rOk+yTGHNaKB4TeqsmUQyStsekwMLKggX40d8lAXAtR5RjY22c70T?=
 =?us-ascii?Q?qvzVnOgPm3PlnQgQ/N9W9/pJZwY5pILyXNHzIhHW0aQE9tqVZqNd7Z5QAtc6?=
 =?us-ascii?Q?dH7i9mp135Aux8V6qHUHjbVMG9YTBJqqjw2y/PvWTbXsOWU9XnqWQcoCH59r?=
 =?us-ascii?Q?gZY2GDrkR3ldSdh3jay0pXo8LXJMaobjqJ2MgKihjVizy/X2jCS7YxVIJlyW?=
 =?us-ascii?Q?zhYL6W7uPPQsFb3QhWwJ7zDV1tJ6DZ2HCVPWbIWnx6mtWtqPfZ4zJfRUcqhb?=
 =?us-ascii?Q?CmAXjMY4qHo0uRPl4lhvCfHe6PDFHkntZ+Pez2PmdfHrWTjC4YSvZJZ2MoTy?=
 =?us-ascii?Q?ifoPHWSSycX9h2cm3FBSRuQFPkMwkFeXGBCkoZAelT+AkFNieaG8VsIFx6/M?=
 =?us-ascii?Q?v2Pb6zmQu1aYu6He4dR6IWqEavMBUfVCrmtPKfBq7aCZYmoKuT0j7rjVZpmw?=
 =?us-ascii?Q?triGycL+M5NVJH/afgiA6bLczGD68c88IzvLBzVaEQHSKdgfQ6LaX7MW8FYa?=
 =?us-ascii?Q?vlp13vXBDQmmWxT9cKIuqU0sv1yxLpxvVWusRjU1hnl3M0WY+bW1EguvESb0?=
 =?us-ascii?Q?i8jGMVnnrZ7dyOijflRU3NOFR2N55S4/L9abomxXIHLgo0p9cTMpBb54dHmO?=
 =?us-ascii?Q?rvWsjEggxyZ0Z4eAwD+FxvMu3Fz4AxhchBMBxX/t9gY93jFY4/yKhxdY2zSq?=
 =?us-ascii?Q?EHYQkYFnOTd5YxFEnm8b2dLfD5SI+ZQHZSr/Tn7NPVXPkFMOwMhxWCMcJLTz?=
 =?us-ascii?Q?WkM3A+p/g8dMwU1/M0oSUK4E2+nFgFIacoq00aTOEqFqp4oVQssA+2xNMyW/?=
 =?us-ascii?Q?karu+VRF1CprIk7aUIMGrzXE7/jzM38v8FeU0+GVPnqeeUagrJkzyTsA5qPl?=
 =?us-ascii?Q?dl2b1g8q9U3/s6o2w/G2BggmIyijdc4pW4E8vwtW4yvpwsq3IJFr1LCMYgOH?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aa/Gzs2gKXaDA4uFwxBgVDHXE8oSQH2a/aaCVt3C6E42wQW/UmvZ95ZzuBtczfI6Pza47bhd1uboynxAvY5jj6dVTmoiANZzc/RD+z6wpsXHJe/7Zc+iqEZBhg7C/pDtq6OMg893OXqagkts8JDXPY2/yy+1da0ZYvgiNOeRXEscvPd7Hjn1/QUTZB6rMWkBj7sCaKBdgUJqJ0t7o24CqiN7Z1cTvlmKgexSv+Xk3iXPhoy+Dt+eRERRm1NQq8N7GZaB9SULF6PnwoONplGSOMQ/8T0czOV/W+t43JBCMXIyCGxDqtbiwwhqcQpE+rUMXa8Rs0C6gCY+nv9QPff/I4W5lSq6AlcmbVNxBkXDFByoGu2x5p/0kbFYrpIJLgpH7BNlpR1c1jy03sZRokxXfujXxJEMRsga2NMlrl2LFkUL6hQY+KwHafg8XGeNaR/TKQwuG7E6fbb1A7xsz0qXEWb9DAOQo30SArSrBlq87F6MPLv6z2mlt/exW8w5pogS9Y8I65uEFYZq06mZ9JsSVAC8wiieIQr6IcenwOfsEIfQK5c8cPRpiabRkC+KI6Fz4F/4CpZTcPSnNNm1JzuU6mhOjL2GeqySbM/QGe08FWc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7079a2b-6e30-42c5-003b-08de1571e90b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 16:00:12.0173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N4pyT3DiToZ9xRkcCsIqfgCJuFcja6PaTUHW79XXBVbhCJz+r4G4SxC/qFYZqFLZZocT5rpuf9KE1NadfrFYDJDeaLF4YjDyt2eHhaL8a2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5898
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MiBTYWx0ZWRfX1pCik3V/pPDm
 dalhEm890r/esChXsYI2Tg99yRxbUz/duIj0iA4bwBS6ug3vp2twwzs/IfvNuhMsO9UNau2gXQp
 YoUo5vhbHdWlgG8CYlHXUhoh2/VsyV6gt0FnELQqIH37maifSrMoAYZfp190X/D3YSiPvqb4vOT
 VS/E17/vz9sbgtaKgmCFxht0ntHsf+ZSF78Ai111Fc/QgIaxXSCeI/SSCj9FlkErZBN8XEEr0rH
 l8XG3enOzXcQTiVE6yDKEf1JPlCq11GBuSwhZOHBhwaSePuHFCNKvJjswuSBeL6wxhjotR7McPB
 0270XqErxYkO7xQ/u6m5eveNcOAXvkBD3Zm7nCwutdFCB9R4EbRsJtojrFOu8TXXbxCNISQvD5y
 tRKzEjFnx/5GYFNm5H2AXCxvfy9dsw==
X-Proofpoint-GUID: faLy5xjMtySbryGyvQYi14jT1SH3GWY2
X-Proofpoint-ORIG-GUID: faLy5xjMtySbryGyvQYi14jT1SH3GWY2
X-Authority-Analysis: v=2.4 cv=dbiNHHXe c=1 sm=1 tr=0 ts=68ff9713 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8
 a=zCnaQl7vHYAXJAyuaK8A:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspam-User: 
X-Stat-Signature: dzn4nkremjrrsq7b8mkyx14fhag9z7gr
X-Rspamd-Queue-Id: C9C98140026
X-Rspamd-Server: rspam09
X-HE-Tag: 1761580843-876134
X-HE-Meta: U2FsdGVkX1/T9WuPefUgCTSV3zxgupve+4fyX+kfgPp3Km5TZIXIgqSU3mz6nFZ8d/AzILXvbdVAYiPnaBPx+bk9RfR4Xlx6Yz30NzHvjUWUjdaHdJc4UnA4YOQLjJpqKd86mUXNQc2tnfncxBFVckMhCumdaz9r4oJQZGe1SCiCWWysozVfbZ/BX5XDvdUNTZDzBwFQOrt+l8xw1A5HJTrm3ECwembX1z//g9dnY0LQDft+Ofl5Ua+c7tOS7hNBNTRtrs6emV34CiN0rKVVBnnXa48uOxzp86A4QLX1x8ISxARw/EhC0pONVKnD1mDsOkoYulJiSuH06ghHkKWF1QmzAH4OqQYBY0eMN1tHi/RiqeP9hn3VaVQAROOE1BEEuHxql6b/0DWkM5nH9EFQxTJ58uqthA7SHrg6N9OqpQTvYVE4VsCS/Oj05lHuRYQ5zwzAgaeh1BPQQ7LNsVPO6E4JpFch8gFmdzAt/JdLCCSw9EjPWMYnleUgMttx2i0Kl8K1LzZrXXB8ZoAHRxfOq053zW4kIrck5zB0PEW1b+w6XVi3mcTJN+JdgBF9U/rmtqDIg1lVyD73wF3yaIYGQn7vd94e6GRc/URApG5djxriGuIlrif1FJWoeUDmpfJm6vsY8qINKfk+l5W6vB0U6svuGRi7jp4VA4OLAUF0rMRBTUyIyoe8oWOeplpWVODCuErxsEtAaqt+/qBHCVNDHpXuUQkHyIhFMqKfVGOS6JT+QAk2axyM7WMQqPP++Li/A3WmpdMVZULobyVrrQay6KMfKcOe4ErkcHkmSntMK8RV3EO1urMYcTBRIeJYX3hLYLMuLMqgJKWN5WcLrnJrIbbEtgs1rM0AOK/3/Btstu3KplB9CnjDYSq4u7songGPE+MW534pP37jjPi6NNfHtOSpBeg2yU2HSR2Ova7I1y52hzfXOYdm/Qdb0zMivQxYqcqw4CBmbqKYkwa1fic
 5l3l1O6k
 qS94uB/rWHa6R/iTh6JiqB/hpcpe0N2aDBeGI/Nj+vZgzMpPT8YGLPLUnOx+2LruEIxzh2qTmuUJbScNG3kLeNUTEI1Y7fy0IEZ9+OkJ5D5uon7S7OWJCZx8JZmGm6esqmrPZqIcrPYaW/K6RpSF+GzFxJgcYE3SyzAkKX9OA7NVcxTg/6EG99mZB++4rbwUUAVCCC74gxUP6W2/oEfUmRJ+fqgBXfnnv0b+kAth5oHbycWOOmzW8HSHMIftu8vo/tVbrg/mTFGMH7v/bWXuBCk9KL9kIEEKcI/tzqJ6PKQjGjHTbEMry1ggQHfaGUstYVANt4Cs9ZtuTcRzEYpcY2oacwEGcRFT/r0F9pf0wuW1wnDdh9C2EQwU2pFbLsnU7E5pgqiHEOOVsVfjgbvNKaw5BsUxxlmN2biXc0OLpX8cVD1KeEfXqg4LLovW9Xi8hQNBhXJQfEIp3xVdC0hTCFj8sMrhWg4hna7zZ+1/Psi4RFu3hPbwyEgC9vLoSrulLNpKm521RfAixhrsTSYltLmbwQpy9Zn8sU9SEuxuBIoJHMGIzBQUfeTTgh/Xf+1VgAZmtOEihnayyEw4VYhuzxBWIM4UW/FKPM2yQkMwM9vnnehktSjeAHgJBhtlj1fJAwMQ4Chii1WZLi4lvypTvxVRzLcctTzde4NgwiCpHBPmNIHrUn+SuWgBvBD91F+TIRgPHIhlmGglwJkUzi6GvVFezHLYKCKt3xlWFG4w2+FnuMJuuJu7VgXVei31+OVvH1HNNKSXGa3q2PC4y9xaoRQrrDuSfjM8ZYPJB1e5/Mm6CAlK6hV5pXrqMxI4KnMSCikkz3c3syMBZZZ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:07PM -0600, Nico Pache wrote:
> generalize the order of the __collapse_huge_page_* functions
> to support future mTHP collapse.
>
> mTHP collapse will not honor the khugepaged_max_ptes_shared or
> khugepaged_max_ptes_swap parameters, and will fail if it encounters a
> shared or swapped entry.
>
> No functional changes in this patch.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

Thanks for addressing the v10 stuff (didn't check at v11).

Overall LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Few minor nits below.

> ---
>  mm/khugepaged.c | 78 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 48 insertions(+), 30 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 36ee659acfbb..4ccebf5dda97 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -537,25 +537,25 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  }
>
>  static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> -					unsigned long start_addr,
> -					pte_t *pte,
> -					struct collapse_control *cc,
> -					struct list_head *compound_pagelist)
> +		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
> +		unsigned int order, struct list_head *compound_pagelist)

This series isn't the right place for it, but god do we need helper structs in
this code... :)

>  {
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long addr = start_addr;
>  	pte_t *_pte;
>  	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
> +	const unsigned long nr_pages = 1UL << order;
> +	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);

Nit, but we should const-ify this too.

>
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
> +	for (_pte = pte; _pte < pte + nr_pages;
>  	     _pte++, addr += PAGE_SIZE) {
>  		pte_t pteval = ptep_get(_pte);
>  		if (pte_none_or_zero(pteval)) {
>  			++none_or_zero;
>  			if (!userfaultfd_armed(vma) &&
>  			    (!cc->is_khugepaged ||
> -			     none_or_zero <= khugepaged_max_ptes_none)) {
> +			     none_or_zero <= max_ptes_none)) {
>  				continue;
>  			} else {
>  				result = SCAN_EXCEED_NONE_PTE;
> @@ -583,8 +583,14 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		/* See collapse_scan_pmd(). */
>  		if (folio_maybe_mapped_shared(folio)) {
>  			++shared;
> -			if (cc->is_khugepaged &&
> -			    shared > khugepaged_max_ptes_shared) {
> +			/*
> +			 * TODO: Support shared pages without leading to further
> +			 * mTHP collapses. Currently bringing in new pages via
> +			 * shared may cause a future higher order collapse on a
> +			 * rescan of the same range.
> +			 */

Yeah, I wish we could find a way to address this in some other way but given the
mire of THP code putting this comment here for now is probably the only sensible
way.

> +			if (order != HPAGE_PMD_ORDER || (cc->is_khugepaged &&
> +			    shared > khugepaged_max_ptes_shared)) {
>  				result = SCAN_EXCEED_SHARED_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
>  				goto out;
> @@ -677,18 +683,18 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  }
>
>  static void __collapse_huge_page_copy_succeeded(pte_t *pte,
> -						struct vm_area_struct *vma,
> -						unsigned long address,
> -						spinlock_t *ptl,
> -						struct list_head *compound_pagelist)
> +		struct vm_area_struct *vma, unsigned long address,
> +		spinlock_t *ptl, unsigned int order,
> +		struct list_head *compound_pagelist)
>  {
> -	unsigned long end = address + HPAGE_PMD_SIZE;
> +	unsigned long end = address + (PAGE_SIZE << order);
>  	struct folio *src, *tmp;
>  	pte_t pteval;
>  	pte_t *_pte;
>  	unsigned int nr_ptes;
> +	const unsigned long nr_pages = 1UL << order;
>
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
> +	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
>  	     address += nr_ptes * PAGE_SIZE) {
>  		nr_ptes = 1;
>  		pteval = ptep_get(_pte);
> @@ -741,13 +747,11 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>  }
>
>  static void __collapse_huge_page_copy_failed(pte_t *pte,
> -					     pmd_t *pmd,
> -					     pmd_t orig_pmd,
> -					     struct vm_area_struct *vma,
> -					     struct list_head *compound_pagelist)
> +		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> +		unsigned int order, struct list_head *compound_pagelist)
>  {
>  	spinlock_t *pmd_ptl;
> -
> +	const unsigned long nr_pages = 1UL << order;
>  	/*
>  	 * Re-establish the PMD to point to the original page table
>  	 * entry. Restoring PMD needs to be done prior to releasing
> @@ -761,7 +765,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>  	 * Release both raw and compound pages isolated
>  	 * in __collapse_huge_page_isolate.
>  	 */
> -	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
> +	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
>  }
>
>  /*
> @@ -781,16 +785,16 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>   */
>  static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>  		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> -		unsigned long address, spinlock_t *ptl,
> +		unsigned long address, spinlock_t *ptl, unsigned int order,
>  		struct list_head *compound_pagelist)
>  {
>  	unsigned int i;
>  	int result = SCAN_SUCCEED;
> -
> +	const unsigned long nr_pages = 1UL << order;
>  	/*
>  	 * Copying pages' contents is subject to memory poison at any iteration.
>  	 */
> -	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +	for (i = 0; i < nr_pages; i++) {
>  		pte_t pteval = ptep_get(pte + i);
>  		struct page *page = folio_page(folio, i);
>  		unsigned long src_addr = address + i * PAGE_SIZE;
> @@ -809,10 +813,10 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>
>  	if (likely(result == SCAN_SUCCEED))
>  		__collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
> -						    compound_pagelist);
> +						    order, compound_pagelist);
>  	else
>  		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
> -						 compound_pagelist);
> +						 order, compound_pagelist);
>
>  	return result;
>  }
> @@ -985,13 +989,12 @@ static int check_pmd_still_valid(struct mm_struct *mm,
>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
>   */
>  static int __collapse_huge_page_swapin(struct mm_struct *mm,
> -				       struct vm_area_struct *vma,
> -				       unsigned long start_addr, pmd_t *pmd,
> -				       int referenced)
> +		struct vm_area_struct *vma, unsigned long start_addr,
> +		pmd_t *pmd, int referenced, unsigned int order)

Nit, super nit really, but since other __collapse_huge_page_*() functions have
..., order, param) as their last parameters, perhaps worth flipping referenced +
order here?

Not a big deal though.

>  {
>  	int swapped_in = 0;
>  	vm_fault_t ret = 0;
> -	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
> +	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
>  	int result;
>  	pte_t *pte = NULL;
>  	spinlock_t *ptl;
> @@ -1022,6 +1025,19 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>  		if (!is_swap_pte(vmf.orig_pte))
>  			continue;
>
> +		/*
> +		 * TODO: Support swapin without leading to further mTHP
> +		 * collapses. Currently bringing in new pages via swapin may
> +		 * cause a future higher order collapse on a rescan of the same
> +		 * range.
> +		 */

Same comment as above re: this, i.e. that it's a pity but probably unavoidable
for now.

> +		if (order != HPAGE_PMD_ORDER) {
> +			pte_unmap(pte);
> +			mmap_read_unlock(mm);
> +			result = SCAN_EXCEED_SWAP_PTE;
> +			goto out;
> +		}
> +
>  		vmf.pte = pte;
>  		vmf.ptl = ptl;
>  		ret = do_swap_page(&vmf);
> @@ -1142,7 +1158,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  		 * that case.  Continuing to collapse causes inconsistency.
>  		 */
>  		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> -						     referenced);
> +						     referenced, HPAGE_PMD_ORDER);
>  		if (result != SCAN_SUCCEED)
>  			goto out_nolock;
>  	}
> @@ -1190,6 +1206,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
>  	if (pte) {
>  		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> +						      HPAGE_PMD_ORDER,
>  						      &compound_pagelist);
>  		spin_unlock(pte_ptl);
>  	} else {
> @@ -1220,6 +1237,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>
>  	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
>  					   vma, address, pte_ptl,
> +					   HPAGE_PMD_ORDER,
>  					   &compound_pagelist);
>  	pte_unmap(pte);
>  	if (unlikely(result != SCAN_SUCCEED))
> --
> 2.51.0
>

