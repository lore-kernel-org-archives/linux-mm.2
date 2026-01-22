Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E148D3EE62
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776E26B01AA; Thu, 22 Jan 2026 08:03:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA8B6B01AE; Thu, 22 Jan 2026 08:03:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570E16B01B1; Thu, 22 Jan 2026 08:03:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40CA16B01AA
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:03:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1583316023E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:03:06 +0000 (UTC)
X-FDA: 84359615172.24.EBE3DF5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D87DA0005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:03:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FhnpUHay;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OaUEDuox;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VdDoARu2R8NRYGTS9g8O3Evq5xYPY3YfY23sEgRG6N4=;
	b=LVIT+XAh/t87zX8wvWbrMRF6/h8xqy9T4RRquQTehs4CymU0A9IomDIYPawBJOe42A7+4k
	4krv+Nc8019K48Fblhh/p8haU5fCjN5lNLa9xadYiLMqz8HjqPC76xqnEi9x2p7vt7SBQq
	Z0iH6FnwL1rS09UC1SP0xGJ4KZNpZn4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FhnpUHay;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OaUEDuox;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086982; a=rsa-sha256;
	cv=pass;
	b=gklc41Qvn+6wy++ysOjZ1ngGawSYhy8ZQAG+fT9rOgZk3UXz4LjtfMY8VtvDd8ExBTGcqN
	WQm/I2D/b1aHyWgcFT+xBnGeGImnnHXvfb9ByuAi/0rAv6VIUVG0/4a9rFDbmbW8haIneU
	/sEJQ4hh6b4oFrLeFRUPV98PCeAI24Y=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LKN1wQ3418986;
	Thu, 22 Jan 2026 13:02:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VdDoARu2R8NRYGTS9g8O3Evq5xYPY3YfY23sEgRG6N4=; b=
	FhnpUHayNYyTVNE+rIX8IThVLJdM76c/fztlFvYa6UJNSK0msbWXS0sVAiuHdGL9
	+ssuofWf3p9vIoLSJCOISSRmubf9ZTVGGqdslUEE/ebWlEzeUDMq05oaxg+Hr1Cf
	alIPodip85LZMO+e/t9lY5A0nI3xaynFGOrrf+aVp3BndrzEiJvMcZW0tRAWTYtW
	qWfETp0hCh+s7b9XRLZZiiGFQ3bJcYtftgWudEsaxazXtG3F13upKnCDxmm3QeZg
	xYvSXIPPLZNFhVKWbQptLxCKWm1tE5V+jD094V4wo2XVYIdwg3zzIwY8UTN2Y50p
	AvIc1njSs7Q4bFWQH8XTmA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9qtxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MCrUck038783;
	Thu, 22 Jan 2026 13:02:25 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013003.outbound.protection.outlook.com [40.107.201.3])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vcrwd4-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZixynWfUFapLYv/mXeGDW0EzppRX1iJkBjPsYZg4PuAlsbSmw96Jge6GSyX9rUwYiXf124W7hPypTTYERsB6vLJ+WJ5tdB819iCJ24BxUXuqxe7aveEeFDRENUs6RySbPQCNlXsnYys/Rop87S43PGyJ3r1bsDXRglEsfwXIKDRcEu04+XqKM5FJL55dk5rkk7UylZ5FoEdoMvafu6goirjHG1LP7kGZ3riKYQwBkzz98r/ux5jzPYBKLrE3wOF3MZqTahfn9RxACxBXOm9C3ih1fislL60AEI30op3lb3d8M658v6qDXLW9Ht9Z+WiRD9Mg5Aws9T/bt/yjx0W27w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VdDoARu2R8NRYGTS9g8O3Evq5xYPY3YfY23sEgRG6N4=;
 b=qq1A/WrhAJJF0H4j0YTG5jSVj+fL81aiHk7fY1xO1JxfRKIV3ZbExPkonY5vT8JEX46C7Qgsq7bj53hJbE6YBjAW5I7mjz3nCfExip8SmIegiQwwnwCJc91HzwcFnvG3oJ6h60GHPb5a1VNzVBr43J58gh2dOgu8xKaW6VikKTwJV3lZIbCqrje586zqt37r+jL7EPLsgzBPZXF/UxHf9luEh80WVd8rw0wAIjoBabrV/7HYsak/sJvQ1/Pz1MWOjuO7hqnb/nptLDIkL7GAkxYgtpsRcLoQCBKmUZx9HsDZl5xhNjjtT/WEaZK9JYE6972vkTmqkE60FUVw8P6oRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VdDoARu2R8NRYGTS9g8O3Evq5xYPY3YfY23sEgRG6N4=;
 b=OaUEDuoxbyMt1K7IF7lU7clRQTSwdrOcaWy3M6kCln6HAh5nyisyV6djMSPZkgiJd8NElxHWK/HRI7bdTnd+W/61iue8G5le/A3ONAw6BY1Dhwtay2YvtiszHKanxutOCvVU4CcAVVcoln1WZYDFTitGe7I2ItoPYba0JioFmGw=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB8198.namprd10.prod.outlook.com (2603:10b6:8:1f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 13:02:21 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 13:02:21 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RESEND v3 10/10] mm/vma: add and use vma_assert_stabilised()
Date: Thu, 22 Jan 2026 13:02:02 +0000
Message-ID: <43c90424ba0874a71bb7ab9d6423b3a2bf616f8e.1769086312.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0237.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::20) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB8198:EE_
X-MS-Office365-Filtering-Correlation-Id: 68e07b19-29ce-450f-1ab5-08de59b67b11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zEPUNVvJhzitYprOkbLToNRDKgC66dytFnlmykK5Nb1Cn5BMScae6dnJgafn?=
 =?us-ascii?Q?vPJoJV4axB7ic6sEwp1Gr+0YAyKboWP4Y3gept55OJzkpLRYjQ0Qmw0Qhz5h?=
 =?us-ascii?Q?8JHNNA6bKxKxGVpY4IFqVs0B4dN4rqydbC6FpWI8Nfc7mkCbrb9wulHFXlev?=
 =?us-ascii?Q?GAChfvGoTQCR4+Vii82Yi+S6IUnHUl5oFVJEYq3wmFmbo+OztUrw67+Bxcl2?=
 =?us-ascii?Q?zakKrsp6tGWitBGHn5DgTBrfSA42tt96fzLKhjTb+FGzKsIKAtjfvyUnjxDy?=
 =?us-ascii?Q?BGYzUlJuw9I8BoLWWTwcMEy4jOmd/n/ILpkj/yuw1YCiFb7NrHvK3yX4yJhS?=
 =?us-ascii?Q?iYcm4XQEI2jxCr0EFX8zIbQ3jkgIgwpvP1/n8OVEbzXiZ9eXu84BX3bZ9L/S?=
 =?us-ascii?Q?TapzIZfvenueVPb9sHe6Qcmci5MVE5XX7idK3rIFSf5IH2nC7nj8kzK59S7f?=
 =?us-ascii?Q?aBmkbwK6ZzBoJ/Ql1r5L7czQtDpKYEi9ycfc2emmt2f2S5vFg6LqWeIGZJEv?=
 =?us-ascii?Q?WT6U/be1wno99X9n5LItLBYUKYGL1F0hmhGEo2AaZ+z0818aNhzuQqti8qpx?=
 =?us-ascii?Q?b3ABqlqCT/j946LHfaKRVj8xYwzHNgaqbu0cepFOYceghsUaM7WC+vPBQQc7?=
 =?us-ascii?Q?mcyEKvF/QCTdNJq4DcUZ/6dYlcn+ZD9vK6Y0oeg31I+MxzwEaiwAKiu1rv/U?=
 =?us-ascii?Q?XIgrpeLFL+JgZBXxlGMr1nTBVmPys/yJT4zkwil7g2FPU54RuRqjT1CZ/ZB/?=
 =?us-ascii?Q?zchq+xRX/89iBd8cuD4ItNXPPQR+rSKZ/nFljDVBQahOlWLjFCWOjbT8kFh5?=
 =?us-ascii?Q?sAHSaK9PaQWbFVPK8rLDI82xwWOCM0PN244t/dFup4j2AJ0bCKLiLG4vnIn9?=
 =?us-ascii?Q?+9XkqufcQCUNWjSPz1CzR1jMqo3uYxnhLlYxFl+MObSmuXxO1o8Q+Hjw5xCq?=
 =?us-ascii?Q?KtYfBlPGbFa8XJuXKWrKbuTG4LCzq/cqUl6G/UJ3ure3enZ3vUbKJMw6WJp4?=
 =?us-ascii?Q?neWZAlneF3SsGR3yUJsUz98xscNZG6xJxKLehHcsUwIpWqpxfW8toSTeQmGG?=
 =?us-ascii?Q?PzctzEZUvH/NHLgzVDQU2y+IISnWke3D+WeEcRtbZNsdjJRCspjZ0toGEBj+?=
 =?us-ascii?Q?APR0u/qiQBTCsv5rKjbBBrHJH71lNySs5ctIRbYWfyS3WxIzjEi0N5+gIV7S?=
 =?us-ascii?Q?81kHYWX1T6I9K+j4BwTKYDtqoYFmFf6rpQWq8O37YCHMRUOz6cZtPrZU0fxy?=
 =?us-ascii?Q?DkvcL/aGFJqtB1KERbru7JFD/NgT2tyPs9ktOCZyvIOlqGgOcOPz7jClvAfI?=
 =?us-ascii?Q?WBBU21K6VwuPVH1+NEDHVxpDzcR8iRsAEXYidw7pkFNVSvi+CmSwXndk7rUr?=
 =?us-ascii?Q?Pq22kzmLC5zgO9GkJH3Te7X1JDMeBsLPI/xKmbEJRdJF8lGJuj+z3kIu5J7Q?=
 =?us-ascii?Q?wa+SYARTIhuJQZEiRDrz/6bp6tCadMZCjnuYTcue050YrSQHJJA1c1FHCSFf?=
 =?us-ascii?Q?XU877LBuH8ogg8YQ+yoDS91aASInP8J2IBiAnLywnZ/Ttq3JDjSokoEm1bQ5?=
 =?us-ascii?Q?9zpVtB11EpDYROj2OiA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MQBv7K0IPh1n/562ABata+1DCxtroDqJLWt8k/I21f1wsSEk3hAXpwWmlEwK?=
 =?us-ascii?Q?7i32VOO9SZc50q5aSgbnQ+qYsOQgwbIw6r1T09FjBXXRDQDPQU+cmguNJbvb?=
 =?us-ascii?Q?/5hGWuHjKbD3UIkCxDQcDSueXx86iVItov4QoPDHs2dmx+1dx9pQ06fwjkhf?=
 =?us-ascii?Q?OL3uKjrG5txPwRtoZa027JlLp2mhctLaI+gjIspP89AtBYVxxwBsg/4IVHFw?=
 =?us-ascii?Q?/sXeL7uFj9VVMT3ME/6NHVdv1qJ9NZo3DHqvSsBk1dsWyMn1OJMDP2F+lyzk?=
 =?us-ascii?Q?MV3IjQhzDDfr6ZrCIzlGbSg2gT3Dc85BH2yjjZ+/IHhHqGTmTXUuImbm1Pr+?=
 =?us-ascii?Q?gRIl6WFRiRYR0CDGgizWrXNCj1OqJ7Y1XkjSaj7dGJQfhw9uEohxkUzDOxa/?=
 =?us-ascii?Q?z/kKZsBjeww9yJejsdbe0iJfLdrLOntlK5/vaCsKQcVMLKcU2/wy8iV58Ic4?=
 =?us-ascii?Q?B7feLIyC5iw0FT0Ai5R4VI/hz7dh1tI5LPdFBOKuXcxxKK9H+Sj48zt1T4rZ?=
 =?us-ascii?Q?rLgMPvvwas37HiUmnU8qciNpnkliYGrBPxaeHFFXNAfPVXje1Q9KsBi8xzXw?=
 =?us-ascii?Q?/9rNLyYu1O+pLY6c/Blje3w4A8FWgtqeR1nG6JW/OIc+MHwl2uJ4YdeUcDvS?=
 =?us-ascii?Q?VkQE2BI1n7QFRBdf0ncUD2cIYVt/IQo9Ej+xyzrpl600dMn4dpVY21ESnjC6?=
 =?us-ascii?Q?RiztYn4163UyMielyc7xlraQTTvPCWRCe1cy7i1O+rFSd1E7bB+cHOJtaNiI?=
 =?us-ascii?Q?Xzl1tgMnl8tyliZkBvhOBQQn8siycFI8JmwBVwCSA0QVw9df3vx7h2XnYo+9?=
 =?us-ascii?Q?y+buOIOaslH/WPrbKN4jlqFWMiiGVH1eNy2f6ble23oP9pg5R782gVoNKH5m?=
 =?us-ascii?Q?AigoRpCPsDgQVvUXHSj1OQyLtFnKnIjfIzuf+ziMnCmmx6txcR4a/99wqBXq?=
 =?us-ascii?Q?3VZCzkYo8Fmoiz/F8r7yUzckV0xNuhw9/fwpusNUT/fkn1kgU1O4R5PeO0To?=
 =?us-ascii?Q?yTY/ol+TDZXZAl3byp5YZR+ep0l1aJofGCZc2yTdB8RdqAc2FcCViq0hsK/e?=
 =?us-ascii?Q?BcLo91w4Sbr3XClllYLi3M6GI+6rjH2jEkMwi11InjE/Y1D0vFzYqM7xnh75?=
 =?us-ascii?Q?bnNTm0FOJ/3puiunlEBrU7nUMgRLV74GI14jQcJDWmzMy5y5y72opzYy0x9H?=
 =?us-ascii?Q?X+lhnLzY+Yg3JDS8HGiZ+uyqoYFoU4yA9DKjzvqcwKz33eN170eVigDE+075?=
 =?us-ascii?Q?JoN14aI1zBemQW1ZjYguRjVXyO84CaUTEevOBGYOQv2TNz8jnDA99C1We4kl?=
 =?us-ascii?Q?YsUp8heBU+aSADdJgPJ4GYDfsQ7jw1mqmvk0FwmJCAR3QXRjJcJ+LRaha+Q1?=
 =?us-ascii?Q?wZG5D+e7NfumSgHmaKqFxF3E9CBFjIv9qqN28atvpv/h8WTvogZgTrFpARdo?=
 =?us-ascii?Q?npysxPq45bbQvvtgs2utXeVF1i85WJio3FbjktK/6HjRyDS1dHyYoaX0quRx?=
 =?us-ascii?Q?vBd31QYt2aI78EUcsrkcvamlCAEYY/IG3Tm53L8IkfgltI67U57cWfloccKz?=
 =?us-ascii?Q?qHw1a0GH2zpTyes2dVhUQKadEHatQ/yY9gv9iJ5Plk4rRFegg+/I4NKxOT21?=
 =?us-ascii?Q?suMZJWukJxcApuSwYDtW03md0Qi259pJU6x4iCWqAfu/WWasnz+VYMnEcrjD?=
 =?us-ascii?Q?bB1X+ABaA0Yvz54HE0SWHfmDy4ITjI4/ZC8vVXknoNDx5MFcdDyEDfF9/IrD?=
 =?us-ascii?Q?I60ajCW6GhjqmYlIlsJYHJcjbCguBIo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/fAHaJ3zQtx5SjqT/xsHyn6nnxss3D6Hm/8XO96Ko4whbLRMABq76Wz8Qawi/HKcNxyEw42Wu/QbwViBl757ZaE9zHSG1oAwpPWbzpEUuS9l2609dCdJ3bhdcO9kdOZIgHfsGuh82cDzjyEoxoqLG3yHwDN0NYbvx9QDdOYO3U5847938F66yz/6lUvskUVe00Bds/JuYn8ZgGZqBYPih/HowUhO72XQENuZc/Rzp5+S93pUaiLjaWpnR03bevrznhmhTJVEZxfQcv5BWJF29SAj9Y7dHp0YXwmNsA97k4oLi/CfRWSUV8FEnoXx7XeTlPStfLTLl47BSu307B4I50njkDkNLgJLnOznTwcEDu2itDGR5zin2ZEsHBFyvLNpRmxNpaB51CajAmjQFIGkrhNhTFfxmqxECY6G8Rn3i6DQ6L/XMI6karXd47TxBSIKoOFDTz/05u3o1+l41GKDcArulswVb2fy2/hOB78w3xzQVor8Vhh5EucRqx0PavVedLrfcWyj197yUjov6NhEUiN2P/qZ+HyZfDyeUstywQ3Ul8U+MYx0YCaV6mvv6C8dRz2Z7DeT5TApwpDV1kdQdDswE5/mOgPeGWDZREDhp4s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e07b19-29ce-450f-1ab5-08de59b67b11
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 13:02:21.7596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWBrO+Ict8gijm1Xuk5F/M6WWTqgsSzqGJUj/w+MZpFWfNG0bDpHPJuJVFskM5rJhnM0y20bKP/7HuJq1PLeQPjupvfxeXAygPFwoLEDxC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8198
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220097
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=69721ffb b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=myXMqSKX-38MvfvLfZoA:9
X-Proofpoint-GUID: jBL8CPB4YWX_ZOh22Gsl8OxzUNb07jMr
X-Proofpoint-ORIG-GUID: jBL8CPB4YWX_ZOh22Gsl8OxzUNb07jMr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfXw2NK6hNWwkDV
 Pg2MxgiYYcxxiYYe9fBf8o1X6bqGXqIUZOiINNyHPrvL0qbUbBoCUAU7T+SBOUoPn+sAGcLq1U0
 jDAczb2TFX3I5iBSN9kXv2wcTuFNFQPAn1/vidH2wPEenFw1CUB7b8XACX6dMCTwZ9IHVHiBHay
 u1dlgbhVFW3y77Suwr0M3BrOJ00gbg/NeJfjthbkVgaCf7VMdUSvF/IHgRcx0CwiG9woynAH5BR
 HZHvBkR5G5k/eSbkMCVEhtaWGTayubv2ORlkN9WVjZayz4klNyMj1ylvkPQu7Iwi6hFjCdJAUdU
 CV8IB6nUxGFinjebwkXCFYMy6zPmN13XxVr3UgpJYStvk/9rjKWcYcxqHl30JsThhhHucXPTxcA
 A0mdbsY2hrPLYrigitFOMMiJsRVLRY8MFG8F5xxZ3PPjWXVAGM3DXOp4elLBySy+GbbepK7hmpQ
 BYk1l5DfDbSOcwoeyBQ==
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D87DA0005
X-Rspamd-Server: rspam07
X-Stat-Signature: 1p3rmj9totyino6734b4t1y8a4jandrt
X-HE-Tag: 1769086982-468290
X-HE-Meta: U2FsdGVkX19z4mHk2hawnEp2+EOWvQWm2OmM67v1bpz04SRXkm25DFTybk+gfU1OJtQWvRWcn7ywlKoF7QLn+mjUSLXc3zJH4wk3fFwuPijDsBALaa/KI17I85tq4A1RnYydF+CcnbrqFl2YH99fp5G0wA9XS/+Tq4Vq2ZYXzEv1rkpH8FQDZ4wCKsvl03n0yxCHxHWR/aEabykPBIPFYkWjqBP+KDdlp03OAHRSkCvUoXvTJclIu5xdDo1kSYyDhipVQAt3t/S3FcCo4pMlT8rFOST1hYyjkbsnse5glMQTg69nmbXF8YhVs8ECI3xgVFCc6w9vWs7YROG9iAYVDHSABBewDWJZupPds4vxQ8/1UtMrcAph+WKuKfdfzp9rg5OQtbPAZ0C6Nt98DTBGdaclRIxPGv68POXBSV8MkfMVUMf9jZu47+lZph4dg+N2LWh2OAghgU2AfvhMHUl1aIQo3cFradXk8XA2D/mxfaMNiyiVqNAUI3b2FCFOFzFYM7ZvOKg9QHDCP5STsUMbWhRyMVurj8MZ7Fbp868rhRp69Rp2vG1TIkhOJQ3/p20f8B/pa7aegtf4x5yaf1vIemZ8LzQYGVmTnBf65Ysg88UUP3ykI5dsRAlKKsoscVgQE6cHbvxLOS4zpZ80dZcIczlVIlRWNwFodARXN3F/8cbz6y9wx40yYF5VH0bWhO9cDsE0DqvmsKX2gi4wMYXlX5+TFZ+N4l7bfl2Vrqnim5v3zPInzHuFJR4wsoC5Nxiyh5HPtY9uwHWPkV1Po1SGyNuY/fi7Cy3QJqDVoty9yEbcDx5WPTNwOnkIYeeTf+7paGgQp6Z3Wnci0cvNIBh+RQmDCqZOkIe/oRWZvAd97KFIgA3lfiDCvt14v6rBV+OEEfkHO9h3bnssKubzQv3ZBEMvwd11e0Dl1OEE6vUbF9pdnEzF4SmGnJ9hY8Djjf471WfakxgSH/w3dqwbLZD
 I9qU473Z
 yg/ox5ftaxHXW1/Tx1Px/zS2WI4mIc0wtjSk645K+S6LsLrxVpW9Tp8ybgf+eHMJQLm/L8KNR+ZuLuh5dRkixXAv8FAzLfn6GmXFKYub0SgtOZBKyQmtoxmWe1obs0d9aGbiN8UVFZxYrPigs2Vt4hd3/2eaR3owWzqfYIja7MjsqGHZEwdZwIJj7mUdcWUYPDRc/otSNrbHA6ztTMkuIRnB5L0yxcev9lnP2yIH9RhQ4ftB2NFiVIc608iMBlhyKJ2bGsvU+Ybjyyq7aQiD8ZdRtNqZtaD8TjUu0tLjh3Cy2EczwCQBPu3efVdxziXuGM3mrIuM+rp4X6PiK7QsLAli/iV2U6+bkNM8GfG5eeqbydl/uyINPzmM1KAMkD9URljgoc5sRvlok2xizlFvMaRkiFLDZRtAsoY8LniBn+4BtoPDIqKim4lLvOPuVxK4tMBSo/IHFjmitItBN9NhWTSr8uWAcN4+1T4XKM/eq2gaqqqJ6o84nZ10RzNbzKV/0JKZFLqdfBi4mA8W2rSTJxzcyQaNRiDyAbr0F1yssH04UCVP2rqiIOu8VtUiZJSYcSHG772JHnwWnDURB5g7hsRDB3waeuQVLWrLSDb9X2U9ml36I2XucFfvzJgvJbHdZl6FZIh0FpBpQgV2nhw3PNFQwh7SU6999RTNjiUqUpMHxvv/OqYjn8y2V2CWWrDDdv/dyddaO8MmlK0BS1epriSHtvSvnLR/SydSM1yNaUXzHMmEmw+lZVih4wVA2jpdwaTpqXy+qRv5DCJa7o8RqKAACaB0/+qASK2kY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us. This will be the case if EITHER the VMA lock or
the mmap lock is held.

In order to do so, we introduce a new assert vma_assert_stablised() - this
will make a lockdep assert if lockdep is enabled AND the VMA is
read-locked.

Currently lockdep tracking for VMA write locks is not implemented, so it
suffices to check in this case that we have either an mmap read or write
semaphore held.

Note that because the VMA lock uses the non-standard vmlock_dep_map naming
convention, we cannot use lockdep_assert_is_write_held() so have to open
code this ourselves via lockdep-asserting that
lock_is_held_type(&vma->vmlock_dep_map, 0).

We have to be careful here - for instance when merging a VMA, we use the
mmap write lock to stabilise the examination of adjacent VMAs which might
be simultaneously VMA read-locked whilst being faulted in.

If we were to assert VMA read lock using lockdep we would encounter an
incorrect lockdep assert.

Also, we have to be careful about asserting mmap locks are held - if we try
to address the above issue by first checking whether mmap lock is held and
if so asserting it via lockdep, we may find that we were raced by another
thread acquiring an mmap read lock simultaneously that either we don't
own (and thus can be released any time - so we are not stable) or was
indeed released since we last checked.

So to deal with these complexities we end up with either a precise (if
lockdep is enabled) or imprecise (if not) approach - in the first instance
we assert the lock is held using lockdep and thus whether we own it.

If we do own it, then the check is complete, otherwise we must check for
the VMA read lock being held (VMA write lock implies mmap write lock so the
mmap lock suffices for this).

If lockdep is not enabled we simply check if the mmap lock is held and risk
a false negative (i.e. not asserting when we should do).

There are a couple places in the kernel where we already do this
stabliisation check - the anon_vma_name() helper in mm/madvise.c and
vma_flag_set_atomic() in include/linux/mm.h, which we update to use
vma_assert_stabilised().

This change abstracts these into vma_assert_stabilised(), uses lockdep if
possible, and avoids a duplicate check of whether the mmap lock is held.

This is also self-documenting and lays the foundations for further VMA
stability checks in the code.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h        |  5 +---
 include/linux/mmap_lock.h | 52 +++++++++++++++++++++++++++++++++++++++
 mm/madvise.c              |  4 +--
 3 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6029a71a6908..d7ca837dd8a5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1008,10 +1008,7 @@ static inline void vma_flag_set_atomic(struct vm_area_struct *vma,
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(&vma->flags, __vma_flags);

-	/* mmap read lock/VMA read lock must be held. */
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
-
+	vma_assert_stabilised(vma);
 	if (__vma_flag_atomic_valid(vma, bit))
 		set_bit((__force int)bit, bitmap);
 }
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 92ea07f0da4e..e01161560608 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -374,6 +374,52 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 	vma_assert_write_locked(vma);
 }

+/**
+ * vma_assert_stabilised() - assert that this VMA cannot be changed from
+ * underneath us either by having a VMA or mmap lock held.
+ * @vma: The VMA whose stability we wish to assess.
+ *
+ * If lockdep is enabled we can precisely ensure stability via either an mmap
+ * lock owned by us or a specific VMA lock.
+ *
+ * With lockdep disabled we may sometimes race with other threads acquiring the
+ * mmap read lock simultaneous with our VMA read lock.
+ */
+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+{
+	/*
+	 * If another thread owns an mmap lock, it may go away at any time, and
+	 * thus is no guarantee of stability.
+	 *
+	 * If lockdep is enabled we can accurately determine if an mmap lock is
+	 * held and owned by us. Otherwise we must approximate.
+	 *
+	 * It doesn't necessarily mean we are not stabilised however, as we may
+	 * hold a VMA read lock (not a write lock as this would require an owned
+	 * mmap lock).
+	 *
+	 * If (assuming lockdep is not enabled) we were to assert a VMA read
+	 * lock first we may also run into issues, as other threads can hold VMA
+	 * read locks simlutaneous to us.
+	 *
+	 * Therefore if lockdep is not enabled we risk a false negative (i.e. no
+	 * assert fired). If accurate checking is required, enable lockdep.
+	 */
+	if (IS_ENABLED(CONFIG_LOCKDEP)) {
+		if (lockdep_is_held(&vma->vm_mm->mmap_lock))
+			return;
+	} else {
+		if (rwsem_is_locked(&vma->vm_mm->mmap_lock))
+			return;
+	}
+
+	/*
+	 * We're not stabilised by the mmap lock, so assert that we're
+	 * stabilised by a VMA lock.
+	 */
+	vma_assert_locked(vma);
+}
+
 static inline bool vma_is_attached(struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
@@ -455,6 +501,12 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 	mmap_assert_locked(vma->vm_mm);
 }

+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+{
+	/* If no VMA locks, then either mmap lock suffices to stabilise. */
+	mmap_assert_locked(vma->vm_mm);
+}
+
 #endif /* CONFIG_PER_VMA_LOCK */

 static inline void mmap_write_lock(struct mm_struct *mm)
diff --git a/mm/madvise.c b/mm/madvise.c
index 4bf4c8c38fd3..1f3040688f04 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -109,9 +109,7 @@ void anon_vma_name_free(struct kref *kref)

 struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
 {
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
-
+	vma_assert_stabilised(vma);
 	return vma->anon_name;
 }

--
2.52.0

