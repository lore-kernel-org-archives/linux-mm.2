Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B961EC1105
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B70A6B008A; Mon, 23 Feb 2026 11:22:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6610B6B0092; Mon, 23 Feb 2026 11:22:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F2F6B0093; Mon, 23 Feb 2026 11:22:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3D86B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:22:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 865091B4EEE
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:22:55 +0000 (UTC)
X-FDA: 84476240310.16.1BA9AEF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 31ADBA0011
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:22:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Uuvw5o8f;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NcYqxtih;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771863772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZyLkYZ/YKFMkYbHNtjxzwRpYfghxT9n0Gi1q2Rr4+I=;
	b=nLfysEDyVQHTixFiXpNYaFlyNmcYB/t5NoybB4Y2hPfMc4bctibZQu0IyEDux74JYs5Zu+
	xM6fuxfNRehwy05r9s1K0HsDC0qMQFvPJDYaUpLT9rX9WgBT76Um6WxSQsCt9SQJ1Hdd01
	cu5uXi/dpGulOmrfWdutCCV09KBgaAU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Uuvw5o8f;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NcYqxtih;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771863772; a=rsa-sha256;
	cv=fail;
	b=LewMYGSxiCz8LFeqWUYaCDBfrjWGO4G+wD9Dk5k3rAFrwlSwUYg35hUtN/XyddbQAxohZu
	WUEoKEQFtpJfH38jgh0l2FKdnvkr6AUisDXeAIa2WsWCAT9DcNPvD1S5AaBfiH0+l9HNtd
	MPCsPVExhgsNKdZnGXyxB2/n1ve1Z5s=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NEuxGj2226619;
	Mon, 23 Feb 2026 16:22:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZZyLkYZ/YKFMkYbHNtjxzwRpYfghxT9n0Gi1q2Rr4+I=; b=
	Uuvw5o8ffWwtgcLcDVKea1XrWBjXHChu19n15pmPn4bAR8nopFgvJqNldOfzdQqw
	DCMU8z02LfNQIJakmrNyt+nblLEyxOims8e3DSKXvBUx6RuaYNqcgOWOMJ3+co0f
	YZ/jHOcqxmd+zr6Gl0UGqGoxeclTTEo4Gs1/HCHdoS8TJKNJpFgwCJC26+6G2hCD
	Rwl1veKfQpzNyqSCLAM4M63buRZEIAUI807bUObgLcY9C7xR35NjuVXQx68SEyGI
	T1gX2PM8SrxpytMSCs/NmqtE58mhGWkZRlF1DlI4VkBSsKBn33m5/F6+VwRqFjLy
	JlxoFz0uWPQLe63e/vOCfQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4arak93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Feb 2026 16:22:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61NEVtfw028640;
	Mon, 23 Feb 2026 16:22:22 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012010.outbound.protection.outlook.com [40.107.209.10])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf358j4ft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Feb 2026 16:22:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bTPEhXjh/X1BJBmDpSWaOqN4u4f49TNxGtm0NVbwh1NvaS+cLp1HbRE3/purR9IJkRg+OUrj+E1tw0QFdfV2B3ODJyX69qs/NEx+RDCQsudhh6rLcPgr3rzgOA+C7DrG3uteQ/cQ4aT4sRJEH/NBNq5acYuCM0AZz95hWlU4J0WGmdX97IE0t7AA5Ho2JAq08Tdw8Rlk/OagB9uKqx4xfkG3gntMZcb+c30Qf4yvfcsJK8HPWyukO2WUvY6V3B5YRrCaG6saux8luClYcYSdnLGiroA9zmqB4yjjUBGrO1cSEkMaVP3w08sn6CJFembanIsPG9IWjjLocbS2cnBcSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=quY1m+LOQHirmx10yqCYPk9c9OzDvZ3oI5GX6+oDsvQ=;
 b=anHxHpCrOkchROVAdN0HpDADI8OhhDQ6JMrTIkPj7ZbTWwJvyKMARLxrcfTxLx2gb3chF47ui8umVdsqOykIeFI1krLLa3LFYHRaqJ6z1C+a3oXTNR5JUwX1tZYnxpo2tvGkSNBITII/fGRorWjkuQPhbTXOCjMsF/XVg3iP78bwBLTORaUKgBCBgsmJ+J4yz0QAQ8Y7w9kSTZV38h970VyT6NG4XA/JjPIby52felJuc4C8QfskLVQBmY6LtonuMluijiMF2WHrOzzOfNmBhJPozEXnqNnQBL3Ef3cxE0u7mVHALwTGkvVWh5V4Lq1ChA7XLWXWkrXvSMdZFkvNVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quY1m+LOQHirmx10yqCYPk9c9OzDvZ3oI5GX6+oDsvQ=;
 b=NcYqxtihkxLmrafUZMmmIsffBxdzVLJFIbOHqfDsh7xuNkJGI7gRb0oBLMXjoNnnPtY3NfMLKfruC/30yp2SEr7QveV0QxFyKzEkD5l3Xq+49IaVdbulYw4Yhzd9usE0+2lrPDdWBniXSuBVr1uwwi6PSh0D43i3MuN4OdQli+w=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4468.namprd10.prod.outlook.com (2603:10b6:303:6c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 16:22:20 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 23 Feb 2026
 16:22:19 +0000
Date: Mon, 23 Feb 2026 16:22:17 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Kiryl Shutsemau <kas@kernel.org>,
        Kalesh Singh <kaleshsingh@google.com>,
        lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <2bbf2e89-a3c6-4da2-a6e3-6a5d8b382a03@lucifer.local>
References: <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
 <aZhErt9DZcWI24_v@thinkstation>
 <d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
 <CAC_TJvd=wKKnj=d3phZsAaarXUdUbZDGauxWNWkQtsFV-MTYEg@mail.gmail.com>
 <32ed82dd-62c3-4a5c-8bae-9465afd7e75f@kernel.org>
 <aZw1DlKHaWvgOtm_@thinkstation>
 <06684dc4-3902-4452-824a-ee2064314d24@kernel.org>
 <7b414e68-4d0b-4d2b-a664-bbbdf314c0d3@intel.com>
 <89cc554e-9c6a-4c8d-8c30-573b2eabccac@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89cc554e-9c6a-4c8d-8c30-573b2eabccac@kernel.org>
X-ClientProxiedBy: LO0P123CA0009.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4468:EE_
X-MS-Office365-Filtering-Correlation-Id: 49f39111-a172-4428-d144-08de72f7b7b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?bK0mXk5hvLYF2YMQ4oi0ecJq6H/5BbyS/WfZlM8w+zNJaDHJ2gFofOC2Qf?=
 =?iso-8859-1?Q?SB/X5TozmW2rx349wyKXuytGw9oEHeyMPRmsbSZlmmwN7AwlFgiTgTQZS9?=
 =?iso-8859-1?Q?HSxW2X2zT7G2ldtMat9Fpl82M+omDJMI2uHDWB1EiAhiaXRBXsYfnhw/DL?=
 =?iso-8859-1?Q?8/4Tc+tpWLhkzcNwRjhzlX/c5OazYmZuqnzGfI15hndf1uoxoOMGemhMRa?=
 =?iso-8859-1?Q?1us46+hJzMMy7dMkCHgoTqYCdqfFWa+pjT+lnhe4dRgcOhEtRVK0Nwd94v?=
 =?iso-8859-1?Q?bk3agzf3T2P/Ks0ybdT3L17qA7weIOCvIcx1Pjsq2RSf7ryJu2Kc/tweM/?=
 =?iso-8859-1?Q?cOB0vKA4jO8eNq+QA5vR2CbYF+2C19OnfQ2Yt5HiHgiPCSspu1VQo3B0jN?=
 =?iso-8859-1?Q?BUoC76vtd8EQEEBxuD8Y+N/Ab96V9JkmeNKsPCsesLvf0mXiYwK4VVzE9u?=
 =?iso-8859-1?Q?qHbZ/B5LtUPbB6LlL/BbP12RYxnShcSGiH8i8VLlk8j4OXEBPT9yIQ2AHS?=
 =?iso-8859-1?Q?36d/PpkzSxDIaKjO8EJM7aIyx+vsTaXoTrjoclDu/n9EFCeiw5Jw3KjATR?=
 =?iso-8859-1?Q?M9MR55+SebWeCKdIjg+TGWy8CR0TYSu8l1ItFftmSrZdKIWIARbaLjz55U?=
 =?iso-8859-1?Q?OUjYDLLr2Ek0HA2loI5mJQLdxfg+n8wOFUxTAmkDfJ+JVJWn5t08dXAbtP?=
 =?iso-8859-1?Q?TNQp1sT5Ln/o81KF+8yWrwrLo+H/8qG0MK5iPZmOjG6fMvogejnMVOOBbn?=
 =?iso-8859-1?Q?Bx6s4DgOdY7NnNTMy1/k4uswwB5P7iL4GcJN+wHRqlcQW03z+3FrLeYCrt?=
 =?iso-8859-1?Q?xNgWN4xKo+tl23wDz1ivpbPalvgUJ3XVENBek4Flv38KbEsUYMD79AAUHW?=
 =?iso-8859-1?Q?x5rUrJl0CQRnOThQVjOvHgo1HGafgmkifaXKM9CKZ54pbv46Gsf7xdyrfe?=
 =?iso-8859-1?Q?Vud550B8r4RgRhdH41p5pwxevZyF7GnyVjYkrEDXAJiR3BZwz3Z5r7ZLYw?=
 =?iso-8859-1?Q?1/tNgOpZk+qlusGWZcmmyvYD8Nl4y00iIKCbcGGwl+/tXA+BXOuXtcRk6s?=
 =?iso-8859-1?Q?L86bBqYoxWgujQWiOGz/aaxjcKkAvHz5jNMBQppeHXam6yoXhs7g+E6XVy?=
 =?iso-8859-1?Q?QP4GsJ6Qb7VGb5lAqca3YiF+QWRsPUQvc+pmM33UwNTOZlEzS6/hAHSaSt?=
 =?iso-8859-1?Q?Fy7nE7xW5U0/oqVnpTaJ3NSATNxKCs53DcFKCJ8/Ew1Y7RYsra+2haPklh?=
 =?iso-8859-1?Q?2AUaCn9QDYHaya0rdmEJ4saXMUGxp2psRkLXGjnYhWKooHJW1z/YS4czwR?=
 =?iso-8859-1?Q?+Yq4nZTwYjb4GLo6LVO/J8tPoCW4lk7ffWJT8xWMAM5S21oltn11YgwSzy?=
 =?iso-8859-1?Q?uEi0jedqmZ12weNjWGvf52P9uTwygkSQRwIOLrWsniy2BFu3Is0VM4geYS?=
 =?iso-8859-1?Q?MdbHrojcksOFY9Hg8kQpETLzkFKyojE8xfZXpSe4BIjz5+tzs/AeisMUKx?=
 =?iso-8859-1?Q?XTQ+dR0ygg70tGC1r8/xF9g0q2m7r7H1ho9i7KotJ/YmZTqAVeJMWyS2/X?=
 =?iso-8859-1?Q?JaoQwc39/WpWhotUaoFvgD2U8XhmzaHgysAwRDFlNg9XWhL+OOM4i1+SEt?=
 =?iso-8859-1?Q?3xSLsDnbxUU6k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?WUs0lw9sRRKbaszY64KiWnLLOhA17cOzJ6eGYGtqWDyhx8IZxGbn/eyDjY?=
 =?iso-8859-1?Q?QKNeOcacBBbReKa1BsDzBcyyKgASm0CMGXpJcxpnGva6RhWBxqUC7VxeAf?=
 =?iso-8859-1?Q?uSIB3JFQbLzYOXTI+u6tyTADyo7CrjcUK+u4d5ZLzcHBqzQdUKpSMcxNt7?=
 =?iso-8859-1?Q?sCXK90bkK2KA0ehzQjlsiENJh5suCVoGn1zUr7xejzK246Oaaujnnqj/2v?=
 =?iso-8859-1?Q?G477xlpoAa4gwjsBFedIBYbmIo5x5paUfGUIqkVjUaBw+FEdF0Uvou8tbO?=
 =?iso-8859-1?Q?hjYfCznZ4RtPsisNqppl7jlxqmb+ubn8ZPohehlfFppCtcSeLTRU9IE0lj?=
 =?iso-8859-1?Q?7ga0zMYHgQDCf1lwNsiJPh26HkpYijQ5inJs9wY1JxAxd5CYdjIofqIOOv?=
 =?iso-8859-1?Q?1QEvv9YnCCFuVnLsA2r7pCl3qohN1TPhW19z0FKeOysP8UKUybgdsgN8LB?=
 =?iso-8859-1?Q?+X3o1KdnKvvxRPzzxQkwXjOXd8czjK9aANDHgTi8j/ZScpK7RXIa/xxQqK?=
 =?iso-8859-1?Q?Wc+KzYGC5fDaJgMbGq/gPomvWGcUfFkwF+PBrn+Kgx9ycRhrD9MAMbVUh2?=
 =?iso-8859-1?Q?HZt/s5FHwwX4iiQ3/dMT6g1sIYu5MxvskP9w9kfLnx41PIeA02XoqUyAyr?=
 =?iso-8859-1?Q?ursvS32awI3RgXBNaHsYJ0QXnihuL7nxLycQKwvOHH7arubz/hIA6U7JiA?=
 =?iso-8859-1?Q?7HkR+lKNwY806CqyTP1XzaF0bUCLLK4naMGJ16N8XWepzTiWz76TVTzgBV?=
 =?iso-8859-1?Q?Q+ZueJPVsWELv6Riq6CS2mDwAyG6r+cI29HxG9f0sn6U4INv9t4uaQxt1/?=
 =?iso-8859-1?Q?Me1U3JIgKKHi1UCw2NrDDq4wPX6LhbqOulU9Y4QX9Mpx86sug4dxtu2V2F?=
 =?iso-8859-1?Q?rOT89/SNqtvlWzy0tvsdPYQilzoKcuEpv7dGWy/w91xYpB4i0gUy/I4zkW?=
 =?iso-8859-1?Q?mo2NTx2U2tghpUHkNBNxg6jIFuAM8qA8npYUkFFZBHyO+mnW9vakAVac/G?=
 =?iso-8859-1?Q?d9uboMC/nNwgryZ/1gMmeATRb5FxecpNgXtVX2XcogG3HS4ydUlU3bNNxF?=
 =?iso-8859-1?Q?Kbpum1laSWaxmogPEnpb7pXN4j5SPG4EbZgCQnL9/pxNFJO/c/QmAg/S5j?=
 =?iso-8859-1?Q?kL7gsjYXlewz9urfgk8KOUS4F26kzcjsXnSKZUgVd/D6vdy2MOWkiYOw75?=
 =?iso-8859-1?Q?0KPoEDwniO3XXFpiFIF3uX3HUmOG72FGb8ig9wfXPv8cODuPrDh+RwB7gW?=
 =?iso-8859-1?Q?+LXYMc0FYoAgGkJ2RzIv8K1HeN7QeR+t/mdMTc/eAeotrbi8UHNPwFNO/R?=
 =?iso-8859-1?Q?pda6TAumVgvuinLP6G8ZTkxemKHx+Zo/HMK5hhHVnbJWe5Fbhofb6yM6IL?=
 =?iso-8859-1?Q?hXUGWdN0F7bf0rgLBYB418tyUQ+D2izLHPQd7F0Y7+ZGq91vOTHJGwA/QG?=
 =?iso-8859-1?Q?ZCsxd/EbeYmI9QDGJh3X3fCAzMvCNDblhr6R2DtLBvOZgQqHQIM0Ra5kk2?=
 =?iso-8859-1?Q?Fz0pK/f4crItPFEoMM0uEPpM5JVjnXE92lAvFD/j2f8m9PBc9HDghQHv0N?=
 =?iso-8859-1?Q?BTsuA+oslG+tnHkkAc4/p5AVsN7m5+Rq7mastLMK/rsV1JikdYwH1xHQL/?=
 =?iso-8859-1?Q?HI3zRVhfJzoM2aYOfEckpzuVqDGxGOpTAa6u7fN92+s9G06kX68aS923h8?=
 =?iso-8859-1?Q?xx2oV/7dl+/5QPfMgCAVWBhAjhC35uQRmLPRgdvhSCBYytpRfR+ZyAu6dg?=
 =?iso-8859-1?Q?+pdlAoW79d0SfY1XLZgo2TZORqkEQ7L/VXBrJ/jdn4+PwcVBYxO1G/1D8W?=
 =?iso-8859-1?Q?xkPqWFK5CiMERhXl4wvnmMBCZUqlge4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Hrvjql4vKVO9VjmlH+60brH7p3IG+YZtmvS8OKhanV/LC7TQ0MCzA01m21XTMByZqDFSlSoZNMq3tB2VJa3zoWjKz/AF/2q1GD4yeC0QnNgN+bS4Ma0Yr31OmeY1P/GXLFl3uhEMlVeF1bgZOzij4LrPBol0yAOMP6qUjrOl858Ax5rjF2qdaD8mZtyS/VCrQ7/t2GkQ6z1dy3RY1Ti34ddAGeg3yzDziv40IBYmVg9b62nHaY7483EoysVHtfZoklpqevnB4eod1dQ6NTYIa2BnEpJxJTFkEYgmPnp+DDafNECqCc14v0tJyiBHMD52UWebPKAPJuyzi50Ney5IKLIScifnEJuIqvd81HUe93MXpmIdxCISt9OL/fC5Hd2c+gYd7BBjyAG3ebhbXGbhAJs+nFLt9KlBUl4MinlR28uyM9Qw3uxdu2z0mADy8pPZyrlfeEKekHIkDBviwsifahPcM4UFa2bR5W21fgKe1oO1FWXg71HvOzhZ8DUKWjFnSSzjjaWYYIfek5lBRv+n5VytG9K7jp9Sid038N00iGp8N5kmk/3bs8nCvpv6ZcfuaYEpXD1clJ/4qgRaPLOrbSfu8Uu1Z4A/ynJidUS5KlQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f39111-a172-4428-d144-08de72f7b7b6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 16:22:19.8933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ekdvzt1UWw8Fc4X3jxentbvOg/mKmXN4P/Dgxltm4qBg0y+OI9b1B+sahdQbEjDqTS4znzN7UPi8HVM7o+zGsp25ktxSqruUgSOj/vVO2/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4468
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602230140
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699c7ebf cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=hFem9kaWIBW115rplIAA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-ORIG-GUID: NYNCOmZIwJZPScaIhze-gwvYYEUT32Lo
X-Proofpoint-GUID: NYNCOmZIwJZPScaIhze-gwvYYEUT32Lo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIzMDE0MCBTYWx0ZWRfX/uF9QuRYMHbz
 ErmNKfgYy1eI3RvCU2GLNO7XnDz2Y3rGjSQn8mvXNZkdp39ART/043CNLTp0wfn3qWqtP4pAdrf
 vXPvdaq7CHYI0s+ceHUmD1wK4TlGuMpib+gSCN/ImcpZZ0fdh9mu4sX+hiMSA0YOTu5qlGwroq4
 HS5iP60LzzyucqajXI+8JUZ5XRVLhHpGq/nE4jxebmJxj6QbQC426moNV+M+bcy9WCyxT0eITTd
 Jsx5kECJnDVYZO8H/cXJOW0aEjP2xdXQh8AcjFs9xcMwo57ojrrl3TMpFQ/YezuFX7wAMd8104A
 RU04sVIfo3Ige7CdRhTWEt+ptMWgNP2w3XzIrIzMJrf09JPRJBlxAqoobivXEXKXUDgm2OUiz+B
 nCb/dsIeMCQOXHyvCn0pP+ZBaKKjpr6iwwrS7o2BNnYN0fzhmUR079+ER26F5RoIMR05BX2KFvN
 feZdPH9ZpznaMnlxBNg==
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 31ADBA0011
X-Stat-Signature: j9ufm1tbppsikqogaztd4bqj9yaabjkw
X-HE-Tag: 1771863772-494238
X-HE-Meta: U2FsdGVkX18E3+rq+nftzeYSX4XKXdwyBsjZp7nmHsFowdYpl1xXNRuFLONHL6EUZ7EcfIOxSusWG3WR7CDZkBD7r5I5O46vOmq6WrbwzI3MyXyHXu2Ry7vLe8ap4mJ6/oxmPRXnKLP5EtHLQi98trh/RzZMmpEs03jVyN9gmXNXbkJFaH/Wx3raXrQedC3wugRkSrjUGpvceIgcGyA+GMH8QRxE5p5ilSsc97ym4/6EbdcmSLP84tWqZXWdMwIiKR3QhtGyyTZBZbVIpgatdDcNR9GFO7KOu9DL67rSqzPYet61lWulNeT/V1mwLWrJm6o54yfIlTaBk5W4MmbLpFqL5X1Ivc1cKKDYY977wgJ8r16m074jqWhfFVl1cgMSHJMIhVD3oSR/SMu4z2rmnaPXvmpb94QDKtJTJpfA6pVNTUiQVRt7zIrOZtgrboL3YTeSFrhe9K4a/cdssBpAzriB2P9n/CSqW1VjSxyCJTusDonGTdf/aajrQJYrJJmoiAbSdFde8ZS8cDyKvuTjlcRFis7WOhwXd3OJ01MevVWe2ibI0/G7w5lqWSIUaX6idWmBkXBKkrkpmer8+5yPXN3Xa7KmENsJHXePWqFGWP9NXfr2RzkdxnMJvqxfaNVUduramjw/f0rZRcpU1YFbvUFN5/pbqG1O6PR1EbUdl0whHlVE4Yf5q2nnJgNvIQ12n0UYV0nng7xIiuCEls3op4k6+88Yn70VYdrn1w1DVyi6mBsw4TO/zRci5ROn3LF3fM+weAG/DNBI2kxWCrKteClufRNa6gaGqXxBGohamwvlnS1+DZUwT7sXVjsLPDhlce+/NpO2panzviAnh7JK5Iwp4Wj5tdtSlSy0FCU1uTXtA98oosEvDM6Uy0fvAHhvfFxbOIV4M61pr1S+1xgSksIqN97xEjf1fJVP+j7vAleJPL5iwcV7fTJuT2n6QaCLya7skPtXgoP8JuwH4SJ
 WhGvTMmQ
 cNXySNtABK3Mk2JUpo2qYND+jzUFtF7jrEl1OoHTWB9g8Nlw5q61l5bsxc1j38DYNJWVzhJK7J8aod4ESaAx/vkuU6ErpSI8NVwINwwB/P6X1TFYU1y7PIeLDULRaaJMRE4Dz7oR5KYiUeEkqbG4t2McFT6j64kwFTA6OLr1TCa6mkHHzWncOMvIpmljKhdDXUYjdjPkJpeSQr3XEMFt1HFxGRmRdLHeaH59bktDEXip9wP3CRfmTlQ3IZPVPx2uauORI8mPqrdL+C5Eo0blh+VmAhldvU1uQn+rdgcN/lCY85Kl/QDvO80RCLsiwRkNgdaCvNmYr/xDmH9TjgLw//b0BiCZpB+t8fKD3gaDNZ/dsZRA8Oe9KSSbPc+6MGxvZoG61fTJyMaK7b4G2zYe+yFjUj0KH3nofpXqhzLxc9WD25+VOu3M6o/rROWrohFufcAUjrdx07mSHiS35AM/MM+dUS8bLHMhsnTzwiTCbNF5SkzYA7SBOackfloK+T7gapho4rTa1IUhtCGTuzqabJNoTPPqRNE9aNoVOgRgioR4NA2CCRGkZVcitMCgQtkVyK4uLSeZfg2J3KsLg0FWYigDU6RPrVK2gyy8Y5JkKaBLq4+bUHs8q6M+YHKcHdGko4A/9D/UUwfJeUQdXNNwSLV5qqbSwNzy2MZlo761g5vzwKV2wLUMKSHhMK+ESmuewcZnfBfNQzXBp35CS7YZ4QgRmM7uHqAkMZllqKIR4dTJ6mAi9+csxccEceK7KFk9tlM21JSkGmvKM2vk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 04:31:56PM +0100, David Hildenbrand (Arm) wrote:
> On 2/23/26 16:14, Dave Hansen wrote:
> > On 2/23/26 03:27, David Hildenbrand (Arm) wrote:
> > ...
> > > > BTW, x86-64 SysV ABI allows for 64k page size:
> > > >
> > > >      Systems are permitted to use any power-of-two page size between
> > > >      4KB and 64KB, inclusive.
> > > >
> > > > But it doesn't work in practice.
> > >
> > > Even in well controlled environments you would run in a hyperscaler?
> >
> > I think what Kirill is trying to say is that "it breaks userspace". ;)
>
> Yes. Probably similar to Intel proposing an actual 64k page size. Expected.
> :)
>
> >
> > A hyperscaler (or other "embedded" environment) might be willing or able
> > to go fix up userspace breakage. I would suspect our high frequency
> > trading friends would be all over this if it shaved a microsecond off
> > their receive times.
> >
> > The more important question is what it breaks and how badly it breaks
> > things. 5-level paging, for instance, broke some JITs that historically
> > used the new (>48) upper virtual address bits for metadata. The gains
> > from 5-level paging were big enough and the userspace breakage was
> > confined and fixable enough that 5-level paging was viable.
> >
> > I'm not sure which side a larger base page side will fall on, though. Is
> > it going to be an out-of-tree hack that a few folks use, or will it be
> > more like 5-level paging and be good enough that it goes into mainline?
>
> Just thinking about VMAs spanning partial pages makes me shiver. Or A single
> page spanning multiple VMAs.

Yeah agree, we're not doing this.

It's already a nightmare to deal with per-page anonexclusive vs. per-folio
pretty much everything else, and we shouldn't have allowed that to be a thing,
but now we have to live with it.

>
> I haven't seen the code yet, but I am certain that I will not like it.

If the code tries to implement anything that even resembles some sub-base-page
metadata then that's just not something that's going to land.

Handling VMA vs. folio state coherently is _already_ painful and difficult.

Piling on more complexity because we theoretically could feels rather along the
lines of 'let's just keep adding features and not worrying about where we end
up', which is I think a bit of an anti-pattern in the kernel in general.

>
> I'm happy to be proven wrong :)

Sure me also if I'm missing something, but what's discussed here is... worrying.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

