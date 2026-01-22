Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 158F5D6261F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72886B0182; Thu, 22 Jan 2026 07:50:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE236B0186; Thu, 22 Jan 2026 07:50:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C829E6B0185; Thu, 22 Jan 2026 07:50:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6D686B0184
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:50:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55300C1761
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:50:57 +0000 (UTC)
X-FDA: 84359584554.29.D2ED347
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id C99A840002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:50:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pGUELiVJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BFXChuz9;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7RBkACBSpdvuYCPvlFWkQvgehMBAdoRwLW0QOdffuZY=;
	b=1pmeNYSkI6sC23bG1XAkwsymnhqSD60Bk5jCO5QGW596ruprjWR/mRc15v9t63YKLpHiOB
	RXOWrvr174wmoGsbCmxISccaJZ1pMaKFQafO8RiSH3+48OvfJAw8M5iy9MtCyUpSZ46YzQ
	pHSspXduw60BDoxxKWPeCPBYU1FpDXg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pGUELiVJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BFXChuz9;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086254; a=rsa-sha256;
	cv=pass;
	b=JTfMCCW/1diFUjytxNQOLGHV4sHSGuCCjQapEZx9GaxzaWvy1Kd2AR8yhdKQGo9rtTEC2k
	4LYeazvgZx90Uf/OlaPqCrhqN6SYlZ21M3fn8Fs0OXJnlXsb5EY3vq4cRWEC82Yft/n749
	y/n5yGH/80njA4W7mrj8x2WIcXPA6J8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60M1HeDt3432314;
	Thu, 22 Jan 2026 12:50:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7RBkACBSpdvuYCPvlFWkQvgehMBAdoRwLW0QOdffuZY=; b=
	pGUELiVJ+xe7tFrABzQxaShTutMyn3UKWMQZ10oJWyHWSPwCbwGDc8Vtk9eOgfNX
	eI64S3+NfbxcgmyBNnlPCHkolgjES8/jCpCt3O99BihYK9Vs2oSi07RqTAEo7l1i
	4g9vLxGtItvLmF+BwBRGreoAKNxyJGYeJI0wECSzyFX17IC47MiO5gS85oNeGnjr
	teYPKvkvH7IjD32tQKO7h/56QD1QGM3j6S2osatbSBhSxNylXpi0rn4PHhms0acl
	8w89B3Tbj4tp0A7YNCI9Jxd7xGRKpOwjxF35Yv41Z7P5vqprIiOTocqpi+D4Iisn
	XgTbQuHB5YRtgaqEdUBpqg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5qjv5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MCEjqm037786;
	Thu, 22 Jan 2026 12:50:36 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010071.outbound.protection.outlook.com [52.101.61.71])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vcrf1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LOUmF4lsuERgZWYwJSj8yLUcK1qRQ+ezP3O6jvV2M2KgdxdmG4zfS9spaO/05uCISXG9xap495BC1ub4A0563OPuFQxZUGzZx/sO934MmZPG+qmHOuVdrLVc0rMINtFaULFae4npsmnVXySz0bml0/hmF5m7B1Lyt+f4NGjQrrnUsX5oBiIk5biJVm9rsDBCJARtR9+ni4JGj9tbOYn+x2R2AJ062RNgO7AJ9TexNrxC4N7mOBzARty8DuujHVe2dnHmn1j9zd35Et3w55rGpX3mnigom7wS7YqIlyerauGoWCUUa04dgdOi27Xku44rINBsKzFfMJGvT4ViarhVPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7RBkACBSpdvuYCPvlFWkQvgehMBAdoRwLW0QOdffuZY=;
 b=QFkUb7wWVNtHmD1Zi8MeMIdN5Gdg6IlDfrdqdJeKAyP0KMaJ0qXEJL8zZfD/RRENZuKC/FBJ9whPrxwkSMHDTnKqmvgR6Z6C5QlAZmAmRw2uyRXQgQWvXjjYjHaCjqq5emSmTiVA8f96pV16MyELgq2J2QqJynVz/0r77eeJ/Od0XH4bExldA2s1P4GBM5pRrY4MP1oPcwNbmR6j2FL1tgr4zOfV+ioUvjYlrX6bNBiQYP5ih+lB4dJ5GvzKljaxy2UmUlHnbwEIzAWSzBWxDnFtaoiErdgdzOrq4plwAZAZixxsnXoWZZtUYcgl4drdv2wlw3VPlJbiM6N8ZE7RGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RBkACBSpdvuYCPvlFWkQvgehMBAdoRwLW0QOdffuZY=;
 b=BFXChuz9c8nswTpQKSoUNbvZA1rrHmulY66BsGGsc8CnjsHBYmC+JJl56m6pk2E5EYngf+LHsHiEaLpnbZIBguFftNsd5oEvAzfwjkJCGmFAS5x7LhaO5NKXhL05zupF6gG/IJooTxVMUjYzX8bf59sz9fbAdIgto92Hz+3et0w=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS4PR10MB997622.namprd10.prod.outlook.com (2603:10b6:8:318::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 12:50:34 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 12:50:34 +0000
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
Subject: [PATCH v3 2/8] mm/vma: document possible vma->vm_refcnt values and reference comment
Date: Thu, 22 Jan 2026 12:50:22 +0000
Message-ID: <a28f56dbe5057385b07498684dfb105918bf3644.1769085814.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
References: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0017.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::29) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS4PR10MB997622:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f640f8e-ddd0-4d2c-bcd7-08de59b4d54e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Qw4WCpBljdfe7QiNiJcFa2dWhltCV4qRys2GuKRJlVwpA7JzHUKZjpXzG9uI?=
 =?us-ascii?Q?dk3Oru2x7QU6c0nzrV//jS7l4F8wJaQOMjL/MSUcYZWPLousrXkgdaYVxLZF?=
 =?us-ascii?Q?Jz0hjGFgay4XKl5mc3PCDjR4X5wVDAObJpZ8+zpxUqW3YBCJjNzzPA+kmGUl?=
 =?us-ascii?Q?TfqFtQwroMgEheHqb6MQG61o6lkZzwxGscX7x8hq7wht/N4K2ZuU01ct72By?=
 =?us-ascii?Q?ZArZ2OILlm4neagDkc7w24c+bSmyvigoL8gepbCBgboNmOMsKCYaTyxC/Eop?=
 =?us-ascii?Q?Kn768UrzAwF3ryXXLcy5CED+PAMoX5s9vrQBeiyN9dAU2LkDG6MC9Ua2oi6f?=
 =?us-ascii?Q?EEby6elkaWp2/2pohb7E1EAvv4X52RjJcCWrJw4P1yN5+eUGtXW/ALAw0Mi4?=
 =?us-ascii?Q?DBNyWlhuxoWQe3r5X1Jt6Jo1nX4kAgEG6Tonk4aUnq5nqCmmmyNE/lR/EaZQ?=
 =?us-ascii?Q?XoQgU+yXnipZv23e5oDbWkh9t97FsOcEjx4VCZISrBWdLzjkvp118SEKVODQ?=
 =?us-ascii?Q?ypPQgyqi+ee99Ea4qVbCwILUPAqpCq78anuotioAG3x6JQ9yeM1NgejJTLNS?=
 =?us-ascii?Q?I8kng0aMUckT4mHRTRrbwRVSKriBqP/1p9Go8hBE2SdPl3Rl0XfwMpvbZMjI?=
 =?us-ascii?Q?kTtHITte6eoNjr/84woXfslaRASYRPW17EmboiVTbcOza1WbaE+glzjGqxbG?=
 =?us-ascii?Q?cDiPp8oxN/QVOLYVOqTpDRepuJNGvxjYFr1s1irpxErHKjFONwH+H0cBpwzE?=
 =?us-ascii?Q?kqLPJiG4i/gIEzw5ItFfLHg6UokiZZ0lj9xexhFsEAuYBIBsrTe6NI3cUfpY?=
 =?us-ascii?Q?rkPwenUxFZ+34EyXidEXcNvsbkc9/Y99kqqzbCIcE8JN9kkmG8L08Zcqcqbb?=
 =?us-ascii?Q?92c0wCqVsCENtLZhS2VMX6bSiV362f4x+6QIh/ojeA4IQ6LY7UshcAFYktg9?=
 =?us-ascii?Q?7MOjat6c03zwdoDzDuJF++a68Go7UC4+5Xav4XNc5SHWbY8fl9JAOY4wahNi?=
 =?us-ascii?Q?jDFm1xg5fUc/JHpPAJAZX7XN9iUcWPpKak/OYF4tHXPT4PY6rlAy7/7J4pbW?=
 =?us-ascii?Q?PnbE/ZGQ4zu2Q6hYbRfGckCbBBQoDVAowN66pk45RJsfFZ5Kmv1KCndnliG7?=
 =?us-ascii?Q?CxudaDXbHRXrcMCPRhatzNhnVkQGSwN9JMjn6JLYG3DLl2JjNU/P2qAIfXV7?=
 =?us-ascii?Q?mJkdnsgXJkoAl5UX4DhtbkS1qfoa1hCCxgWCJFHKIL30KCEnhldZQmRv7RQd?=
 =?us-ascii?Q?yhM7+fkAQjlDzWBUMU26pbvf4IIyVzS0QrgjxGGH2diFWWGwzGbVzRrmz9Z+?=
 =?us-ascii?Q?m8r/orCl2vDtGYLTo4P0tJvvdLABMRFn8DnG6IvRL2sC7mPg5mZulxrUx+xx?=
 =?us-ascii?Q?SNijtcDK9sZDGgfMIyZIYA5ngdmJcM3UESXTpUa+RZoniyqWEcujzxljvObk?=
 =?us-ascii?Q?ssb5m0dqCwQyiPVqxOyygF/myHGODAoRuBmjwLGxvcmV6a42Bq/eUighD+Rd?=
 =?us-ascii?Q?MMNiOZXdOia8D5bU30oTruw64piUSi52YHRMabWbqHbuMOejOGB8ROh5RtVY?=
 =?us-ascii?Q?Ds3BJqC2ZhrlGC0bZT4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3stF5Aqu2uwzYvJ1XpgrBEMhC0JPXZFm3ZCZ05ZQy26CgTv241dZtrC6KdVS?=
 =?us-ascii?Q?UIy+uUv27ZRcRzeTQ6aIDf0eTAiQhDKBQoCqSeAlejq8ZBf95xGfBLlf79/3?=
 =?us-ascii?Q?m8Q0yOqIzVox8RWBrsVM/KMi7G5AP/VvlsWkdeClAtUTOjWWpCPW42QCTjMj?=
 =?us-ascii?Q?APP3TGf9EvtKu+jQvMX6S7af4NJJmVMi2YNCLjH8jJObiLB+QBFa8M4XE6b4?=
 =?us-ascii?Q?tzGKd7EIZH8zKK4XU3MHROHf5HAbrGNCKAeyTz40OY1xdHM5PVBaDmqGbHgQ?=
 =?us-ascii?Q?FJ5o7yY+fG4Kkxr3h2K/o/5vVFC+ahHbhPuBl5Z23Jg4iRjaa7YN3df46tRd?=
 =?us-ascii?Q?XA9eRuYUMzxNlGm6gdLAymeMZnMR0bHzfZlRnHUsnj/s/jEZ2GB+yLyqE5t+?=
 =?us-ascii?Q?x1XDbfosyKkHRI7qUTQdiHYRdLlc38TCkVS1xSTS54FZ1d3tdft/QdGD62iB?=
 =?us-ascii?Q?9Qplfhm/FakiE2ozVIkByV73m4LAYjnPgpfZvuww+rrKaYQ8nw0V5qjdPrev?=
 =?us-ascii?Q?RzqAS8vZrotulz0GetDsuu0OMIUe0dM4gsfPLZc7FhBEetfI3QJknAj99YC1?=
 =?us-ascii?Q?3eAhdi0pWmmFU/Ai1kBeSiatixgZQPWsEDcCUZK+w9mZKPE/BgZeFAYhIxeR?=
 =?us-ascii?Q?GQ2vGLfQNv4h2kERmFr5iwu9C7YvJFspnO8LqASQVLAux4DLeAXuXm9eD8sY?=
 =?us-ascii?Q?P2SwVDAYlOOuZzu9dInS8CKHVFKs2UnX0xVYOC4tZutCTCk5wOfNPPxltEcT?=
 =?us-ascii?Q?gGViKha5m735aTPj1uEPzovGjOsoDmMkRXKNHsC2byztFxjfC32uha+y0g3W?=
 =?us-ascii?Q?k1y8bsTfraBh12iMHzg5tzWqugrvVwfTMtgxD6Ebj8EG5cGrJ7RTbONAQBx9?=
 =?us-ascii?Q?UvSDDKjp+NcBOcdX8kppLJZ02apuqJLxqW7ixf3zcLYCvNu9oBH+EA8m6+md?=
 =?us-ascii?Q?5oqGWMey7wU2n8xUjD6Qce/8MdlW2MisGaCJ7mKGtYOuu6br2vdBSGINuwIo?=
 =?us-ascii?Q?+RgYQwHgUvCbJk5sZEkRgpjnEaTvUBCKwKK2DcC3cx32y554C5JHgDTPTeBb?=
 =?us-ascii?Q?jbW4LlSimUQojYFbpDdCi3CZolA2JUNdrrOAP2UH40GOn+p9l3TyBSA1JRFa?=
 =?us-ascii?Q?Y1jg39QvM8MtkeBIReA2uBLIXwvtSzFbXwDWH+s99/ITmhu3joy+0nLeBnbZ?=
 =?us-ascii?Q?eSbUkk2IfOfni8HUo+oijFKJa1vOhG/YVQQiiD3uba5P+T+dTQLsgDFCQUKF?=
 =?us-ascii?Q?kR3MyQezXuDpGEWt5TTJ0vvl6CxZV9+PKtHPcopTagXZWqGGqk60xEokEbv6?=
 =?us-ascii?Q?2JY5Ts0sS45/Q2pGptkuP0Il89fZ0qsURXayZNZqaHaWtaWISqlD9oJQqm6V?=
 =?us-ascii?Q?X4b7GDHF5sRceJ1xqv8tGijYCpY0jUdIbGtLqlkhpNigvRjDXtPDD4khtNBl?=
 =?us-ascii?Q?k87FEQrwu440WXoQldTpIb7c6idD5Zn/ZgZ6XMFoQK0u4SE91DxwgdAePb6a?=
 =?us-ascii?Q?CUiVZUhV5uheJwighdCnwmWtP8VH9b9BEbb19K8bO90P7Y44iBBPXaYSwQIZ?=
 =?us-ascii?Q?o7TiDqgA8FQEwBGyqRcjwbSsd5OkrGr8kzl5q4HQ2Ns8QzvDrsDDfnL/g6cU?=
 =?us-ascii?Q?md/gl1TTElu8dH7ZuZqtaIh4NY+88tzSy4uMEwRtS+wp0C5avtwpNlf8sTT8?=
 =?us-ascii?Q?xVYzq4cWVY3PhSTWIZqBjfg8sBmAvi1qsnBjWkr2n+XP4hgbI+jxnpdYpjAR?=
 =?us-ascii?Q?TG0WbBdiJ8Uv5IKJTbPCd1MhROjvfZQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fm9qV4m/eQPsY+5vn7tGtfXiAAG6Uos5j7zM0UKBHB8GdTv3zHcmPS6MA7v07bwKH5GiBcdjRNDReN5iAA4Yo8mztC1rq6jbHGF9raArOhqvxr/I17Kkbnyh0ugQahLzhtBMD2Bc0sQlRXRB6rND1KOm9vIrKXs4qrAyQjp9YOUAWf/JX5eYiLBif7sIfHsVcAsIuUDtWBy/QSEPHs3I15YbFFOvsEMBafG5e5O82SFW4Kjmn93blK9wG2CEWFD8Th50iI2tPdK4pAo4zE/tSllZTHETo0kQQ8bI65zfFOvoYxyBwgfeCp973aEY/xA+ydEbMYyU2aeghsVzJ5TkUY8cSWnj6q6dAA9kIlvOGYO5y3erLHkUX43+CPzwL0XDTU0YjYxz5CpbC+0x0D7cvHLB6SmkbqDeQqGgHU/ByGu8ybIVm/kfQrHeZpUpAS9dwlpGQhGsOLqfWsudqB06+htQdSrvRiIZqbi9RD3k5E6c7o0aM3z8rHyY0gFyHyhhjItvJNtjKevtwnMeGq7QwNOcERPmkidzWTKCnqsaK3jNbYHrUlxqyipQDoheSJSP9nzp4lTVp76+XoVSP+jnUhaPxqV8YWc0T2xQuJXlY3U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f640f8e-ddd0-4d2c-bcd7-08de59b4d54e
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 12:50:34.3237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zO7Ni+iZ51O77cIRIUnSmZDUdUzHFlayJ/lt1/BHJRnm8A5/XLaOWgTO6Je8lLAB9Esj0LiyX1icLbWea57gcwA5F794XlaqfglLAmh7pI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX+4NWi/ASpjiI
 ssy4SCPej0lCXDiEZG5Vs7wDMH52B9N9MP0FZI+CrR6rtIn8zOvzKoEH99rcuySXlIAilcLS90E
 8poP7+LFtoJgPtK0t7S1eKr7GHnyLbYQ48fEec2tNpyIxIYkMi5r7b5u2r2rip4am+Kq1Ft277/
 pXNQw5mGeVEyUvqF+2jFmH9rg6RIrlB4xbf60/mRgtYKfubg7TPFrIZGRwCzR1E5tsDBV44NLZa
 sIU62LF2/3+B5lFNGFrmwGPlfM63jNNGOwKiWyn4hRTkxThf09SwSkqipshR3PPtWI9JkrNwyQQ
 WE3YiDhq2WUJjtTKJ1N+kZgURaiwpe7k9CbAkotM9m2JeyA/m4CzNl2Yo3IGwNTmrrlx5X6Oz8h
 1c9PPbbrpQilkT40S3DL3tAwG0AGbwGz5Enbfz4hXEusv1WytwM3H6dVbmRtrs1si8j5mXQwk+W
 hT3abUD6JUDBts+iVKQ==
X-Proofpoint-GUID: _L7beMRU-3xP_zKKOZAzTf6KyPEnd3OU
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=69721d1d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=px5gXGW_QSS6PAkXjB8A:9
X-Proofpoint-ORIG-GUID: _L7beMRU-3xP_zKKOZAzTf6KyPEnd3OU
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C99A840002
X-Stat-Signature: 9rsdkts4jhqz7gktctgzhre6jfbrikj3
X-Rspam-User: 
X-HE-Tag: 1769086253-389407
X-HE-Meta: U2FsdGVkX19yhZKo6gnUjOoDv15r8owtFEpxCeMwLOmmEOJhkenhIkJCfZYTa+fslACvSbUe/3Ak7oMchnGHSeDvglmEMT/oZXO8lJSu6S0xrPKvQ4UTqU+KXMUBjSmhCMQr7rhhJuqqDVWWXk58rTXxxXTI+hqP1RMCFa1U/VZgHAS8tljezPFzqxGuib9FXpOT7b11zyQxAcZqUykMhonDNFv+BaiTWBQBvwx7vw4qnwpVfnV2JcSwkEpSEfRX18JZAhO4zck4ypT7tuVzqjVd7SWReE2TlDo249sPEULtgNgMCGPHULUHhBV0A87Kxgb7ZgD1LYivbdrTBsXnJl+tGc9HxBRIUsiba7jcL3sd9MEJCa81j/105SXP3uy9SwAP7hRSD+tMyQ1FERjqBzcMqWQUoI5Hgpu6lq3BjyEGAS6y0gcE8BRDrdYMa6K3KCsghCwK7Vqlp87Gu67Af2BerLZgzvhxYAuVCnRPaxMX07bW2K0O0iiuBktGDOQsMXXJMeHHjh1SPQ+b3CFglAPm8RjaT+SZK8hGy2lLBZDcQZvve4LBqvltYqfGauL3wnoNvhkOJwB0IoqNDT6mNc3sFvFFSM18Ej2vMbxc0ieF/cGS0dnRy0GBRHL87VOroXYNa3nw7OFc61DoUweHipBzsJkRCBIL0IzIhICMnCHofTCALTYxrAA0oxQrUrnz9AGOpzi44oWdyOmMs9mzytAODweDcDPHTk6DYAQMDl17oBlNyixoZIOerhatWMs4KsxmdF6193WhQuebQ3IzQhlRORmzL5Kq64yJZwgcRygIALlGCcIOh4MeILrDnS1xL3xWMFoeFCgdAo1R4j43U7bvYts6Q0gNadIa3HYf3BDX1hOm9VoecxcvNdcc1dtQ1BNegfjj8jMVNTkL7Xdlb944PuoMk0lvqWl16kePguO/qdMJR4VWx+U9/HNIWtd50eAwFXWBI/dSpyACyYJ
 rD94hmXM
 AQgORUc/M6Le29zTTNar8GGToy+sdB4DkXCpV/hC1S4GsaCtwHve2uPGEUz0bLpdlJ3BYNqCvMHwr7JlJJnib3toPAyNm7wucPe35a0AjiXmagtI1x0MZs9lGih1NzOoCix/yP6VVPuCxEtnCov8SRepVIytYizS91Eav+vT1zhvyJgKq10GEafyNxN3Cwn4D+h0K6MP7ZjJEDIZd73fcqwU7fxn8mm435LMoTarCbzowbkg4gE/plhVfTjN0iJfVeMHoFBt4cXTdwIXFUBoViUWvpgzHgwhDrn+nMyub+ddvsi9KUiCFylqputfdQsDMuTlZPlspAQ5FbSum9BESEquNd1xvD/3ux2SQ6D4lI+VOPBcxxFWcjetYTR4Hk8ueF9C4nRHltuA3Ibe28LDXx5T6/Bv4nHVAyYroU9KwkRjsIIsbCw9u5JXV3nVBGBU2vivgzloISl6AVqE0qsbnbxl5IyRw1zPoiJXhX2Mm2TqLA6OXMrxNZ7FzkiAj2cOAcecdjvBPK58R/XhYyJVDY+SfA/No9UHT6t4Gg+rsk0OnNX+xS8EmoD8AaV1CFqAmKHYYKFYIOkNn/FgN8E1xubu4ws7eA2usQtoxQHBK8Rde/euRDdcyB3DPx8ojak/RrBYPAbCM7kG7xrDlG70waBgCQX33Imaibq24Or+U0fYNyokdGxeltV2/Hv5rdQRW3KihuvyJdGkCiesKnctAJHGkPNZWOkNx8MbV3oPrtLXLnxba434bq5/zhpFES+sD0cld
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The possible vma->vm_refcnt values are confusing and vague, explain in
detail what these can be in a comment describing the vma->vm_refcnt field
and reference this comment in various places that read/write this field.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm_types.h  | 39 +++++++++++++++++++++++++++++++++++++--
 include/linux/mmap_lock.h |  7 +++++++
 mm/mmap_lock.c            |  6 ++++++
 3 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 94de392ed3c5..e5ee66f84d9a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -758,7 +758,8 @@ static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
  * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate to
  * vma_start_read() that the reference count should be left alone.
  *
- * Once the operation is complete, this value is subtracted from vma->vm_refcnt.
+ * See the comment describing vm_refcnt in vm_area_struct for details as to
+ * which values the VMA reference count can be.
  */
 #define VM_REFCNT_EXCLUDE_READERS_BIT	(30)
 #define VM_REFCNT_EXCLUDE_READERS_FLAG	(1U << VM_REFCNT_EXCLUDE_READERS_BIT)
@@ -989,7 +990,41 @@ struct vm_area_struct {
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
 #endif
 #ifdef CONFIG_PER_VMA_LOCK
-	/* Unstable RCU readers are allowed to read this. */
+	/*
+	 * Used to keep track of the number of references taken by VMA read or
+	 * write locks. May have the VM_REFCNT_EXCLUDE_READERS_FLAG set
+	 * indicating that a thread has entered __vma_enter_locked() and is
+	 * waiting on any outstanding read locks to exit.
+	 *
+	 * This value can be equal to:
+	 *
+	 * 0 - Detached.
+	 *
+	 * 1 - Unlocked or write-locked.
+	 *
+	 * >1, < VM_REFCNT_EXCLUDE_READERS_FLAG - Read-locked or (unlikely)
+	 * write-locked with other threads having temporarily incremented the
+	 * reference count prior to determining it is write-locked and
+	 * decrementing it again.
+	 *
+	 * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
+	 * __vma_exit_locked() completion which will decrement the reference
+	 * count to zero. IMPORTANT - at this stage no further readers can
+	 * increment the reference count. It can only be reduced.
+	 *
+	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - Either an attached VMA pending
+	 * __vma_exit_locked() completion which will decrement the reference
+	 * count to one, OR a detached VMA waiting on a single spurious reader
+	 * to decrement reference count. IMPORTANT - as above, no further
+	 * readers can increment the reference count.
+	 *
+	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - VMA is waiting on readers,
+	 * whether it is attempting to acquire a write lock or attempting to
+	 * detach. IMPORTANT - as above, no ruther readers can increment the
+	 * reference count.
+	 *
+	 * NOTE: Unstable RCU readers are allowed to read this.
+	 */
 	refcount_t vm_refcnt ____cacheline_aligned_in_smp;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map vmlock_dep_map;
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 5acbd4ba1b52..a764439d0276 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -130,6 +130,9 @@ static inline bool is_vma_writer_only(int refcnt)
 	 * attached. Waiting on a detached vma happens only in
 	 * vma_mark_detached() and is a rare case, therefore most of the time
 	 * there will be no unnecessary wakeup.
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
 	 */
 	return (refcnt & VM_REFCNT_EXCLUDE_READERS_FLAG) &&
 		refcnt <= VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
@@ -249,6 +252,10 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
 	unsigned int mm_lock_seq;
 
+	/*
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
+	 */
 	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
 		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 1d23b48552e9..75dc098aea14 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -65,6 +65,9 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 	/*
 	 * If vma is detached then only vma_mark_attached() can raise the
 	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
 	 */
 	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
 		return 0;
@@ -137,6 +140,9 @@ void vma_mark_detached(struct vm_area_struct *vma)
 	 * before they check vm_lock_seq, realize the vma is locked and drop
 	 * back the vm_refcnt. That is a narrow window for observing a raised
 	 * vm_refcnt.
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
 	 */
 	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
 		/* Wait until vma is detached with no readers. */
-- 
2.52.0


