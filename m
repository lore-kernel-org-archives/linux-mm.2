Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262CBCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 19:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE078E018F; Tue, 12 Aug 2025 15:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE768E0151; Tue, 12 Aug 2025 15:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4761D8E018F; Tue, 12 Aug 2025 15:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 366708E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:39:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40930135658
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 19:39:34 +0000 (UTC)
X-FDA: 83769119868.11.34DE62B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id D67D540002
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 19:39:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gi4lFGTJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0C4yxav0;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755027571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NH2Wp9+q0nQBCEAHmEVusm3040LluU6lw+YERl2G6M=;
	b=vzeW5lqUfOZFpLUkpi3FYJFUrd0Fr2T0lJltVWxZAa9WPd3hZRWjvCVgeKWV+IqNLJ7tbF
	mSmstXOgcsIfoo7FyUf1mB/sybxLzsZnwshLGF+LONWgcEDr8U6qWfoNGv3RIAxu4MjBH/
	aJAF2skebJw2dTSVTM2s8UZls/dGAGw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gi4lFGTJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0C4yxav0;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755027571; a=rsa-sha256;
	cv=pass;
	b=oI0iuzZ9+I7ouCN4tHkkDHvQTC/QV5hUvX9XHrgwvFKW7XlbLp4nmNYxsvdGnO6gQAzs8I
	exbLDQf8kb6bho3FLsc2+Q1PrPXfHUA41T0UJqc86NggANRNTlNIYadMkAZnNbyhRH70jh
	3/7mawFnC+Q4x/9m92PDEY9PHm6szbo=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CJC2wF004779;
	Tue, 12 Aug 2025 19:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4NH2Wp9+q0nQBCEAHm
	EVusm3040LluU6lw+YERl2G6M=; b=gi4lFGTJ+1OSCbWYXzFQrEsrHw6XViYoLm
	cntOTi4FC3/XFxyi0JiIy8JJxQdeyw3sFr4eA84nfydr8x9tzyuyj8pURfOIss3/
	RRbAVJqeeN9xxB0cUT368nj3gR+oM5Aax7ZBGMdlUq5Zzv5a9dgBGWb4KmwsqoG9
	EKvqXHjWe/gTdHFDS6gJ2Fgi0V0VYbJr/56sso63cAG8NSHw2MatC2sCT0fl/KXv
	YeSLma0tF1oZSiiugB6nabdOMOG7LqP1G750F8/wHhRgiw0LZt2juooHoyaJ7l/f
	7KG/0I7ssxgPlh1wQLj9c+vLnIajGY5noMf619BwTAP9Y/gHhTaw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dwxv5g1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 19:39:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57CIE6FP030192;
	Tue, 12 Aug 2025 19:39:03 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010066.outbound.protection.outlook.com [52.101.61.66])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsadsda-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 19:39:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i0Md3xEHc5MJvCYtZRFQsz2gpUDIF7Xh0mvDDgPzwiZbpp8RmuvCwgUGUg790n+V7fMykvPv9X1sFcoyBwuezq4BgU1VoHDNKy6TnauIjzBEt59eqmyQVfPFDM75Tc1Jvq0rZXIFnzuyetVfyqWFUbyLW5JQKn+7u13uQ7BEoJebc4KSZaJq9sPbryRAnnko9GkvkaD0Dxc2B87BnRJwVCQ7l1hxg8YpcaoWwspOIBqxmf0+HRoUtzikAttF3GKBdpChMJHdKxacw4t4Rd2/1DbFXdNpOjhyWNiRwKFGQMfxJMyb8bZXnceSwt98BPWxPdb6c4LAu5L+SElbh6TOXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4NH2Wp9+q0nQBCEAHmEVusm3040LluU6lw+YERl2G6M=;
 b=YVMZRef3nxbklzLyhK9V9xBCIAd26vPUJiJO/6Fbs7yn6Djse+WfDTkLrMNaxZqyovkukQsMZQcwfTdJEAtNuioNwh1aLxpHyshYyww/2OnX+TzkRX+VtLfVBY/cNbRvRT7NbjglHIVs+B+SGJdaVbYX7ZSXezL3Fo1O8Hf9irqKNxgM4AeVOCSxuBxpfOdvg96jqrYNCW9RrHnSZU7Icq3TqLM6eWxTShep+3mz6je4LL9N/5ioYnph84/Gd2tqeXd3qKCr3SEU6krT2CRC5xE6IAyEHi7Sqeit5KyI7Iuzyc6ivWuewCNDG7vc0GHyjwagW6mLfkGU3Bk0zqwyMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4NH2Wp9+q0nQBCEAHmEVusm3040LluU6lw+YERl2G6M=;
 b=0C4yxav0HH+fQmv5zglHpe86f9hvdNlo9fGC2Ok5CJ/SWNOWcC68enKxx6ccYevsgk18HSQLZxmoal/DcUY4H3PiUy7LHAMVe353tAeAc+PmLQ7BJVGg4AcoVZ6Minj9dktjt6xw6Y2RZPHd4n/m/95JsGYAWE7in+A6PUsb8OQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPFD57E5FBF5.namprd10.prod.outlook.com (2603:10b6:f:fc00::d4d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Tue, 12 Aug
 2025 19:39:00 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.012; Tue, 12 Aug 2025
 19:39:00 +0000
Date: Tue, 12 Aug 2025 20:38:50 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
        nvdimm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
        Lance Yang <lance.yang@linux.dev>,
        Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH v3 10/11] mm: introduce and use vm_normal_page_pud()
Message-ID: <8bd06a6e-8d61-47aa-bb37-1916b18597da@lucifer.local>
References: <20250811112631.759341-1-david@redhat.com>
 <20250811112631.759341-11-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811112631.759341-11-david@redhat.com>
X-ClientProxiedBy: GVZP280CA0090.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:275::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPFD57E5FBF5:EE_
X-MS-Office365-Filtering-Correlation-Id: e3784dba-5fa3-40c6-a0a1-08ddd9d7e2b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e8UMrE+sXP3ZzLkeQYVZWmTkuEup/7ufvf5jAFEKXzXK23aWG8Cmfa3T0eOr?=
 =?us-ascii?Q?yZiNCFf2Xb11U6lHAqh+/BbW2di7RAC0DxgMzELHJh+D8qsKnubak72A27Ug?=
 =?us-ascii?Q?OLWrdt+xIK//Rs8fDKFgUyggwfPVroZK78yXII7eWO1twQhQ7bPSFU/Dar/L?=
 =?us-ascii?Q?s+6QBliXkA4b1hY7OO9py3RJ2XwoB08EUD+BQGpmp4u0OgMBvvna3JzyedhU?=
 =?us-ascii?Q?b4DnapbsRm+IKEGELUFVOBf45G/K/JL1cjrsXgSktsWHG9/HR/vEpUZLbLjV?=
 =?us-ascii?Q?ZKMMnGF+K6tgk+h7dCFw3W2Itd4InAjN9Ryc5JKIQmuSmpiwFqMQadelKbWh?=
 =?us-ascii?Q?dvkjE8zoE2Gdiyc6PyUxOfIatllPsFJ+wALATqBGDG89Sav5DiuIhg75tlGx?=
 =?us-ascii?Q?pi6snmTuki4LS4sqgW8F9PzvSFPv0+B03ukJrE3bihpsrwYNhYmEWNznZKuo?=
 =?us-ascii?Q?cWOsksqj4l5JbYFzhcgJTxeLkFVxES04T30orKg5nxbv2Gd+c6wQo79OS9P9?=
 =?us-ascii?Q?9GGQkT0y56Wvt+iPGk5ypAuFS7eFWioidLMQSTMLiIRZtNKjwQsjvskDIgWN?=
 =?us-ascii?Q?Tc62y2VD4e8ldyEJGmUcXNQplwZOZOoGr0VUFLP/xxEzfK9yYu+tPKcHCFpy?=
 =?us-ascii?Q?jF9vsS3ukIL8ubdp/LY2OHT+CmsMs6Wli/d2JYLNjDOefF3KNZ+hiZz2oJzS?=
 =?us-ascii?Q?ud4pCup9Fw7oEjo4s6cKxo68IGxY1nThkOfuZcrMIDyhYfnMEEUm5jkJx8TO?=
 =?us-ascii?Q?zytmA0ofecA1GPNWWEsPuRpjsRcFIblXt39pQbCzNsm7N0mpXlKSZSyX/xT/?=
 =?us-ascii?Q?7OBggXQ4O0bmUOIeePRQ4fG1VewP04DMZScW0V+t/a54oapOeoQ2IewCor9M?=
 =?us-ascii?Q?25az8aquDWChHbA1TO6QUkcNaYpS19QoWOoHvP1icz8GB7QGURl4TXWIWMp5?=
 =?us-ascii?Q?nKRICS5N5+gezLTRKIgzQZXP0s5iAbG4cI95KGhxPN1Aek6Di+d3ydzAb+EN?=
 =?us-ascii?Q?WuvEHyOaPMvGHrvkvdiIMELcm89dcT5/5GpeT1a0HtYjcwDkqyHMU8sDcTgB?=
 =?us-ascii?Q?qHI6jIvaV5S13o89v4a4nvJEnMRKz9gQZVE0Alg0GwZRZCldKqCKZKSTJ2y+?=
 =?us-ascii?Q?wtGx5C1j/HjQv04S34mg+RJmxOXyYN7yXcII6poZFWjDa25AJtAjc79ZL+s0?=
 =?us-ascii?Q?uawrZynyO+855MXZ5s9M86CFKVbPidzXv4FoatNS6TpEoZmcWF1NxSjQbnAU?=
 =?us-ascii?Q?j25YlGuoBIWrpfDdGJqWUGNGn09w79cof//OI6kCUldntpncCY+QY+jAymLM?=
 =?us-ascii?Q?9YF4LcLVnzF6c81LHhR9Esb4mgkuyreuRNuqzWL4eaiYZlVXjeQW+289dguL?=
 =?us-ascii?Q?67OE7wGagzcTAdnSBtfpnhgwy2XxaUglZDRa0T7W2QYnyeEzPw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NfjypGTCzHy0dtIgYNg07fvFgoV8MBndmp+Sgz4G6ZA1mg0xBexU8dTfe4lo?=
 =?us-ascii?Q?qYVGJgXtocGUCUyXQ6qbxVIuguWCv8KBnNx5RQBlEglKPq0a8INMusVGolZx?=
 =?us-ascii?Q?I5RHFovXnxpsk3z4OZJ3Qr+xNbvTWG1p5YFgmD2hVujUI38y642IyT9HhGQ8?=
 =?us-ascii?Q?TTIGPGFoKko/+/IPbBMomcbHQ6+87gzjWXHAGzbkqLiUsG6kdW+SHqt6kQQD?=
 =?us-ascii?Q?j7nrC3vN/tUwEB2rZioPym6KsEel8NyGsYaZo/LpJj8qAwQwJ2AN+or+79oH?=
 =?us-ascii?Q?ap9NBEPl4oAyaEBAvQs5qByHOwHMqQf9JUspWrBCG/6SB278iiszQyeqHdiF?=
 =?us-ascii?Q?gWoyanFIS186mI0ztvp27hBUIwA2kXIwz1m2z7j5hk7qXtNkpZq/3AWBoJcP?=
 =?us-ascii?Q?5rNxrXoSMV/ZNyWqgUdnI+jSDTLcEXwCachS7UAAxyHZZPYo/CuuiKyt0A2e?=
 =?us-ascii?Q?7YP6E+Rbxq8op7KebCkDZ/248vf8iN22uxq+1NpiYol7Hp5onY5BRbEEltke?=
 =?us-ascii?Q?Ja01+E4Km3rBz02YaptOQ8XC2gAfJtyGGYEMIaIkQj3Q311crh4plB2/Y9c/?=
 =?us-ascii?Q?66SN335H/sbzjX9yHD1lmuEPVXpf8xG2LJf09GGP7j2JkiqAf/3soglJnNS4?=
 =?us-ascii?Q?lvtI5oUL/Zcl4YSGu9dvHkBzy/efVYzKaF6oeayJMXE0MOZfG+1LJ1HWHQkc?=
 =?us-ascii?Q?HH63GIAEIMT8FB/41g6vfIOJIenEVt1wi9sfF/vbkQZaNfuP4pf9RGJBpmDV?=
 =?us-ascii?Q?Zo2IuNg/GU7HzlPGkD/Y56oY4/FbazbM8rre/3q5W6zRp5mnKmekSGjEtER7?=
 =?us-ascii?Q?j0GCkdr34Ewpn5j2qRogvWkFMIZ864xm/4u3+pB//q0NMG3ARUth5qP2Goh7?=
 =?us-ascii?Q?+nt6jXceXtM+dPOGAUhlNa7O7jWoRdYaI13E719hDDNprhYjbMPm6gnysFX/?=
 =?us-ascii?Q?Wc4+Z+t6pZn79KvPpfG76ZqcL6V03Z9I+9LsbtB+3p0ZCgEqJqejq9zsomfx?=
 =?us-ascii?Q?A1zs7KVPr6tlAvQQ2MUR/9BhaL1ZZ0wQZS+j1iqs8uhjjDBx2WMAqVZQgQa1?=
 =?us-ascii?Q?R1Aod9Af70VWj/x5nWWsnjjGu/3fFSB5nLYtNh+cSfSlEUz3rYINowhI6PLL?=
 =?us-ascii?Q?B5zh8ANOcKqQYkcfSTydVSwc8B277e8+zUVZJLBcn8GXF6CyO81HQOTHCD8z?=
 =?us-ascii?Q?eJIwvaxfwDyMZhDc2uyR9YdoYqCAcgTo6ZDE2km1RkdjVrbd/RgNqoZty3Ve?=
 =?us-ascii?Q?Jnb2Bowem4JtsOwU79ZBeWQMsqOLm/iZ+fxCRlu78VbKzTRxeC+42cgKz0Hg?=
 =?us-ascii?Q?zYcLQlssl0iz/ws4+vko3rCaP3SwqrCsmi2eDrQ/QHeAhxX0Fuk7xCldtnTY?=
 =?us-ascii?Q?9o21f4AAm1FHzzzdRzdKOh/hEXvSVCghonAKYZdO3WLv4vh5DU/rQHGbSCCc?=
 =?us-ascii?Q?tfmaV8MFJrfvEf2eVabFLourfn81FbfuX8lo+d6bp4wMdhJtCEI5eTD2ZSkL?=
 =?us-ascii?Q?2gJRAYSue+YiFQIeQ4UuQHbTe+SN5vBCY9CsAWk2/Sfn2j5V3lDnlRWmuP9Z?=
 =?us-ascii?Q?Q0s+CKIhnrZmz2RdQzqwI+q3kqLFVXsyTYoInz0ij8yRsnJ6kosVoA+NKHdy?=
 =?us-ascii?Q?sQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Sf7S9ZnQyKf7rLyy1bXfjA4loX94CVu8IqGx+gl67F+1srIGvJwO19Ne2mOKUPpnSlGc7MPiz4V8mp7GxI7lUP5/R1xUIY9jXCKU9miIrJv9nrqeFbVJEcyTEHM66YoISRWlZ9yVIjJfoU7JCwTseTu0f0rphwJvXvBglxSUXP/+8ujXvZrM7fXqYXa4SKpck7KAAfF07hy3Xr0adCL3Tb7Gg97xoJ7DXX+DNlr80Nd8fSFRXPeNUNeniR5Cf+QPYpV5TW7a3hNlQ8+eDUnCUrsaZubjwU9j40IkoJ/DWmORXo8yzFQxHAxpe250/K12J5p1TOGURcWZ32DoAmC2kJkMLm/nz/Ycq5lasASu3pN1L09sirk+wejJfXa4Bmge9xMax+dH7wKHx34cpCYTLu8cKKwKAw0NkmGXWLWak9IWWVcC9rz4eWwkIJZ9fda7mLD1Q659ubgBMhH65+HIuHFdal7sK7wCq60B5Va4kPA2ZQUkVu4tYsURA5mLVFW0L1nBk8q7wklDpqaqKqQO+fgtLMtsgAkFS/speHkGS/1tOF6CjI+Ruijfz1fNn77OnNiIH5l0hCVD2DxkHzQbWX3qFC0Ym9ROdg+3o0WNjgY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3784dba-5fa3-40c6-a0a1-08ddd9d7e2b1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 19:39:00.2110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p48QJtHL88lLgu9i0ZIx7EdpI4C3CWqJPjIA0QfRd2yhWL9SXHB+A0SE+KEL0gWGmoUYMTwcbS5I9GiFShqZ+LP94oXwCb6WbspgqGB0UVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFD57E5FBF5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_07,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508120189
X-Proofpoint-GUID: BCabanmaFOSTCbImAI4uzUebr1raNkuu
X-Proofpoint-ORIG-GUID: BCabanmaFOSTCbImAI4uzUebr1raNkuu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDE4OSBTYWx0ZWRfX/m3VhgS8/jzo
 xqYQq8CCyZvtCmfgc61Vf6Snsww2eMuV+PqOgjzmvAMJ9mZGWQqAQxcI795T1CH/jpl4qdkgTzh
 InV49fyTySnMIqFs3kvwUFnZKIUURSscOTLP+oNEJZOQOVbOTXsRNKe2TXEOSOjHFk7MxocmWRY
 KFHu/k8GDBK49F7L1BEQmjolL9i4cTm0zjUMYaJMjPkBRVbw8oNPehU690r1yMFy1Raruh5clNN
 5L8PEXW2YM+x1Y62JkAg4795QDgHdWKLl3v9ZuelPu0LMfLn+h6FDViOhxzU3xDeHk+PAsr1Byw
 KnNV4USvbvKCN6XLWMxNgtTUzj41xEfOWYkFgqIgVLd9A2D4rTHS70iqraTrFCJd2BqtjRjrRtN
 AMFXsVmJRt2KnqO4Oh8cjt97SiEwLCeyuZJheOwk3G7cX2oXqI3zjW5uUtLUA1e/2INKBIR6
X-Authority-Analysis: v=2.4 cv=KJZaDEFo c=1 sm=1 tr=0 ts=689b9858 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=_vYpphbN4_vJ8DAqhOgA:9 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Rspamd-Queue-Id: D67D540002
X-Rspamd-Server: rspam06
X-Stat-Signature: arhf5k3sehw7j89cw6gmgug4krytu16g
X-HE-Tag: 1755027570-656116
X-HE-Meta: U2FsdGVkX18MLWY7+Ja/9KFnKO2IueBduMLcpGvbXfyChdh2JsRegrXI8GxJ1QxeAs/tpKN+aW4V+42p6LOzMpGEHO1XHgYFH7Vd9Glq/lXCY2WrmKsI32ciZNA2ktggdvbhW3tymLzoccU/lVbGDm2W7pfXHTqiI14Q3zmIEMq20ecRmRYff7NOm/gOJ7ckt2dPntRNwxOFGR561wVELSiH5zdT4EpSLLjKBSUNETyAY27CtKwuqsDO5VEH6rUqRjq1MwfQBo5SWPe/ppP87U/vS1M2F66E6BKf/8w7nVYX78ehfOip2BTCAl2TVyr0S+4/RH3BXSwIGDN7Tcv8TTU9mD4Bdpn9l9qFm31LNEdxMeb3i7fTzaO9/4zqPuvsAV/c5Yb4TslYsKzo/e+LF1XPaPlU808ZSNwwxFlGsp2DyCSEa3lTmTV0b3oFyOCFRXNaWE0g4cAy1d3ybz3e9vwZoAhpyateHZCQ1t6psiTF/Qz/eHLJVNsH2ws+/FN64kvrtbNbblK19Gao4pNg4t5oXbR3puMDLl6qVhy+xSVi9BCUN017LWqDEe7qoVNLP6nM0HIQptYdhoBKYk8pjB90EJ0eh/q1Og7t82Kag9Dv1rPGa5EL9FS4fnaaWOGO3F5it2QjtJN+tGIKPxhxQ/5gvDz7cfG6jEzDshdirhZpAlyW8JtmLYs/MCWA3lq4K9y1rg5RiLFLjlQsjaCuBMuK+M8N71pcM6A1zXyekDbsa5QbOt89A7LiEktxRsIKkTWL446Vn+xrIkt2P0eMyT5OSzUPIKc46mQ8E/LHlvPDwyDboVGlwV5AB7ewRfKVFHvhKRUO63f9sMoHGanoziGo80zXnIl5rtyARds+n9IqxDoEF4c2aHVrgzC+CsUBSJbSQmAgSSGqSz10raQkBvf1ptdtibWreR8jspGn8GsnNQxlC4IIgqlk3boh0GRzo/1DtK4a1tfgh5kRXH9
 iYUhHwuy
 fZaSQ4PH9lBt4q8rql5HA/e+g2B4IbeTCxdjoxbzGG3cMzhpNwL5r5uaNmu7E2Ne3oXtaCUGJ1vM756yt16i7cIxIjmSg0navWwdkbzMOEEWmTNk8Lj4pbB//VIuKhVVJOonTHeJktCVQMF7QlQkuQj76X5hYlS6RD3izhjjnh0oiHD01uk1UFJeVzLAgrOZpmUhnyU30+Kr/Ta8i8nYRy6qu9XLhzGZwTRj1WRbMILJzMBIzSyCMC5v6dgIjZEKmBIIMOnmL28aQQapM2DStN9X2LXAX7JOmuYboxOIBwBI02MwN8KHbzBsRXl2OGcrx/Smyxbxlkg19oyhbVOi8R0eM9CzA1uwRk0KmGiPJBEoQEBLbJX9+RAgtgfGf0VmnWYvON/cbh47IO+rB9A/Gu6D+bNnbfE/E4TKxeHYudDplx5r0bPrc9uNtKHiIHSuzhcQhpuS7FTeVShhdWnks4i7o3bnYkubFBzFI4a/k+sHn15fr2AuHAhhesCiQOYgyfrh8L1DfhOx7BqWKrGEotw8kutCN7IKNa7ujRIJkIWHbXxiVmbT5Ue5nLhnI25IA3Bg2VGc7EVg7ZqUbnU6LU1ZEw91B8NPeuFFm5HGljeirb0dOhA32Xa8IpVZUZiD/Qi9lhblS8i2BixjdulzHGcsZSIu2vOqakFUiDFZdF2cWXY0XP4+Dj76StI8sFKqRW52dPaOGJMTqa5szpcOCSYyKDKZbvo+s8u41SfJ1F+vWpTTePYfnq9Vd2AeOok2amo0+GXpvljv1pxKOcpEl1nabN04JWGCyCeZPVyHjM0CIijFjtEMi3c9zwwT3VKp7aEPGcjizTthwDJn0bObLZNI52RL+6hOZG0u5cyQnMCBjLk5v/5d7kOdHWpbC4lpfK4fnMfsHfNjUfAw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 01:26:30PM +0200, David Hildenbrand wrote:
> Let's introduce vm_normal_page_pud(), which ends up being fairly simple
> because of our new common helpers and there not being a PUD-sized zero
> folio.
>
> Use vm_normal_page_pud() in folio_walk_start() to resolve a TODO,
> structuring the code like the other (pmd/pte) cases. Defer
> introducing vm_normal_folio_pud() until really used.
>
> Note that we can so far get PUDs with hugetlb, daxfs and PFNMAP entries.

I guess hugetlb will be handled in a separate way, daxfs will be... special, I
think? and PFNMAP definitely is.

>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Anyway this is nice, thanks! Nice to resolve the todo :)

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/mm.h |  2 ++
>  mm/memory.c        | 19 +++++++++++++++++++
>  mm/pagewalk.c      | 20 ++++++++++----------
>  3 files changed, 31 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b626d1bacef52..8ca7d2fa71343 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2360,6 +2360,8 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
>  				  unsigned long addr, pmd_t pmd);
>  struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>  				pmd_t pmd);
> +struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
> +		pud_t pud);
>
>  void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
>  		  unsigned long size);
> diff --git a/mm/memory.c b/mm/memory.c
> index 78af3f243cee7..6f806bf3cc994 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -809,6 +809,25 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
>  		return page_folio(page);
>  	return NULL;
>  }
> +
> +/**
> + * vm_normal_page_pud() - Get the "struct page" associated with a PUD
> + * @vma: The VMA mapping the @pud.
> + * @addr: The address where the @pud is mapped.
> + * @pud: The PUD.
> + *
> + * Get the "struct page" associated with a PUD. See __vm_normal_page()
> + * for details on "normal" and "special" mappings.
> + *
> + * Return: Returns the "struct page" if this is a "normal" mapping. Returns
> + *	   NULL if this is a "special" mapping.
> + */
> +struct page *vm_normal_page_pud(struct vm_area_struct *vma,
> +		unsigned long addr, pud_t pud)
> +{
> +	return __vm_normal_page(vma, addr, pud_pfn(pud), pud_special(pud),
> +				pud_val(pud), PGTABLE_LEVEL_PUD);
> +}
>  #endif
>
>  /**
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 648038247a8d2..c6753d370ff4e 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -902,23 +902,23 @@ struct folio *folio_walk_start(struct folio_walk *fw,
>  		fw->pudp = pudp;
>  		fw->pud = pud;
>
> -		/*
> -		 * TODO: FW_MIGRATION support for PUD migration entries
> -		 * once there are relevant users.
> -		 */
> -		if (!pud_present(pud) || pud_special(pud)) {
> +		if (pud_none(pud)) {
>  			spin_unlock(ptl);
>  			goto not_found;
> -		} else if (!pud_leaf(pud)) {
> +		} else if (pud_present(pud) && !pud_leaf(pud)) {
>  			spin_unlock(ptl);
>  			goto pmd_table;
> +		} else if (pud_present(pud)) {
> +			page = vm_normal_page_pud(vma, addr, pud);
> +			if (page)
> +				goto found;
>  		}
>  		/*
> -		 * TODO: vm_normal_page_pud() will be handy once we want to
> -		 * support PUD mappings in VM_PFNMAP|VM_MIXEDMAP VMAs.
> +		 * TODO: FW_MIGRATION support for PUD migration entries
> +		 * once there are relevant users.
>  		 */
> -		page = pud_page(pud);
> -		goto found;
> +		spin_unlock(ptl);
> +		goto not_found;
>  	}
>
>  pmd_table:
> --
> 2.50.1
>

