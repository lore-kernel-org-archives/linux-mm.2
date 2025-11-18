Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81CB9CED24E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 10:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCD1B6B009F; Tue, 18 Nov 2025 05:19:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DD66B00A0; Tue, 18 Nov 2025 05:19:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7596B00A1; Tue, 18 Nov 2025 05:19:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A89166B009F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:19:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38A914DB4D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:19:18 +0000 (UTC)
X-FDA: 84123330396.20.961FF90
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id B9246160002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:19:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kSBP5eQQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WCSDnmrQ;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763461154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+qMUa249jGesoN0N9VZs8Tj7kmeN3hEi+xQZzoB/bQ=;
	b=mM5JJ/CLU09sW2K26z3TbnigpqnmvvjHjiAaLZ9GVpQVwbh0uzCPSZC4sU48YS7ZUq4jNX
	JLfMml5f8T9d8LEyEF7v7ZEDgip7jUdKJnLItJfFC24x2X0KF0Ok5tGZt1iS4yXGv8m5xP
	BYzv0MXGwkQjHfGBsXmzh4ntzK0+HfI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kSBP5eQQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WCSDnmrQ;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763461154; a=rsa-sha256;
	cv=pass;
	b=tLcc6ZH51RJT7kDgV780Qk5+AlWOijHAycUlDNlZx0pMbnJUhRzLfdrbv1EQuiCu5SoFp3
	hfNbnaMMY0AHPBlRv7xANLUnezvXz7sQOJD7JeRVwnOauBuxS52JzUfSed/N8fWr+YzDt7
	6qjinfw1OOUBNXjV4xQY36jOpL+ACxw=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI9CcQZ008436;
	Tue, 18 Nov 2025 10:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8+qMUa249jGesoN0N9VZs8Tj7kmeN3hEi+xQZzoB/bQ=; b=
	kSBP5eQQH3u91rhHkKQtefyVlL+8qpnFsIT9m0psyfNHi10TuH/NlKzCcrt3GmUm
	/CnNi6OsCVQWQnHGMSRTya9E6ApPjuD9lzp24zpbxl6xW1y+dRc/4DKaErIW4s49
	HrL8lnlymjiZprXDvCY/S4UibGA8L6f2SOibPk3fg/sxffh+O2qV428Zk8nn3yIp
	7KZSR9slS1r2D5hI8rQOQJyFESXpVOmEGsk+r8LUyl+l5Zn7JBuXDkD0RxZy2Qc9
	F5RvBTpfswQB8YRMN6VKywvVpWtoWTEM1wJDVVw1NnukckAQN7Bb8w2WyWFc8A0+
	FrqVqhHcxD+4ZR0xQtN21Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej964gyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 10:18:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI8wjfo004268;
	Tue, 18 Nov 2025 10:18:40 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010048.outbound.protection.outlook.com [52.101.61.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy8pp85-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 10:18:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gTlxx7Pff/wkeQCeM7kDX8EKeR0hBOxEyyspZ3wUm6NSrdiLig88y2GDWd6VQOY/PQu/wKmBWaR4iB5P77Et/0QCIq1p3Ls0+xkrIHcFzm51Odr7YQwAkemP7zfBG63zb/FibVMi/JQ4Yk2GTuVoazJMg1oH4TE7lXSjIybymHpdwfFFV9E2V9w0OQuPNcEDRW43BF8T53UvKwzBl1rMcbhL1II1ayvKLuMenGBfHjWMhIl1MDl88w93W/hcarYwxEvPbHsFkM2MhvAMuo29RkHH0biaIh1V1kMa4lbu9bA9foC1jaeK7UKBuLM7aDu1S2M4QfazCVD5RI0T+Ys3Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+qMUa249jGesoN0N9VZs8Tj7kmeN3hEi+xQZzoB/bQ=;
 b=I9wmdQqWLZBU1aiDCbpoDZ4Iv0RItRawPo1KdbDWUwzQdCb4RAcig5GxfPgKSMUG13ZM7AZtXYjUFQ2YbJbc7xk34p7k5C8NAQLFCOq2LwURKArIoiwDT3Wkr3/lEaPdq4Aeb+aIxqtgC2/GrUM5kPUVgGHtXOw/si15t7GHVQ/P0YC36828CGEbg7KPVXUJzeHoPL2OdTeHd2saHYb1mivPeANSBW2kUBO7mCZ72EqxfjFMRllGnwHQZl/RQt4pAC49iHf8epiwe3Jsrqo7BCBbGMl9N5/0QP2ctCkKHmyAevZxxhBYtaCMajBaInfyIf3jPEcusVetnGEdYljKdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+qMUa249jGesoN0N9VZs8Tj7kmeN3hEi+xQZzoB/bQ=;
 b=WCSDnmrQiywQlMLw8e29LYcVmUTbpDi276JZAgedqbRVRNVsm+SQXr8aToM/OLgX3yd2m/yXq1hPjxp3fqJoPky50aOQ/hsIejlcAtcMxv8c46MTicJ9Uh/fU6MKqYrcC/bSiOW1Abk6zmvlbIFaZA7KzkxDniaZk4vA8Qk/OkU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8756.namprd10.prod.outlook.com (2603:10b6:208:562::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Tue, 18 Nov
 2025 10:18:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 10:18:31 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: [PATCH v4 5/9] mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one
Date: Tue, 18 Nov 2025 10:17:47 +0000
Message-ID: <5d41b24e7bc622cda0af92b6d558d7f4c0d1bc8c.1763460113.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
References: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0275.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8756:EE_
X-MS-Office365-Filtering-Correlation-Id: 0625fa5f-e4ee-4cc3-abfc-08de268bd2c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QQqLpxgn/2ZubEQS7Vyj36G7bbX4glrKyQE3OP0CE280ZMKkDuCaRpEqGBOs?=
 =?us-ascii?Q?xqzVrPI2bB5W17U5t+ulwP19beG3gjJR0EaTJoNgVqWLdPRgLPkD+riF4VVh?=
 =?us-ascii?Q?gn86/AEDM7kLLxD6zy/CFaarRBLKgeCRk/9+DUovuYgQvznfKVogIgbp/6OD?=
 =?us-ascii?Q?t3Tb+dDJw7HjtJi8uw6M68LSLeP6B5nfOj6/xz6k0iNBzautz3qU0ma+hg+O?=
 =?us-ascii?Q?6stl8rCw3vV7i7o1msvMqOZDK6DIcffxJ4ft0dB1ZJnZZc4JJWSjnJaHu5/u?=
 =?us-ascii?Q?1Ub52SIuy9PhP+sMRHv+7+KitHFL4m0lSFw3ZUo0S5Yzmc2PCkdC9irgY/4x?=
 =?us-ascii?Q?enGfEzODrz/DlD21o7pvK5LnG0zcK/P3nn8oFEY1VUnfsN71liXueeloLZAo?=
 =?us-ascii?Q?F1oWZumyLBSUlCielG8FGcbMlDjaEoEZg3god2bQorWEVCatwD66eukyyzgM?=
 =?us-ascii?Q?ZXwIB7s9RcYDWuSwAD9Z6RpKqka1QUqKG5lC45FosoaNRvixxuxyPrEkujnw?=
 =?us-ascii?Q?gs5DdYlrfcu8X6Hrywk1y3HqQLnXqnpLCapYSFUSLbfhYUcc15v8GvpMArHH?=
 =?us-ascii?Q?MM4XElUh3Gic6IdS679Vn6aR8DVKkB8Fn5my+YDHcPRIp83kVSf4YqvdT27r?=
 =?us-ascii?Q?erjTt/BpIPXUnrzYKZbY3SRI1g6V4mIXFMyYi7gwmdWy2tOx6WelnkpNViZ8?=
 =?us-ascii?Q?I2IXY+bycfjwSI0KXjjrM6aToIvYyyXiQLqTwnQsjn/Uxd7dgNOocS3vuSZK?=
 =?us-ascii?Q?UJt5TWoc7gEb2xniyAb/G7RtDR7+3dWxa5kioRr/XEjvS0IA2MhKGoQrgy/I?=
 =?us-ascii?Q?OmWspTeE97sbnR7p9dBBQqZrsaInyrVnyRxshQ8NId7v8OKpi7olt3BGecMO?=
 =?us-ascii?Q?Y8+veB3Bfxbl37L1f6lcMe69PDBfCnr3Updwpvm1pUf5COuLvwZftnIHOF7Q?=
 =?us-ascii?Q?vfi6V4dd4PPR4TH2sy3EQRWK00Zf5LQlbbau08rYErmXY092HiojLoAvQRO/?=
 =?us-ascii?Q?pD22QRo3eZDAuAfG44u5CVyppQ/PS3W+Bj3pMaaL+MOloH+dydw1p6SNSdQE?=
 =?us-ascii?Q?lXGxrAy4vBezwhEYZaF9HYXZrayWNISWl7aIzefVQ1OdFQ9i7xnvN5BBRwOR?=
 =?us-ascii?Q?oL2Brow/HtpmjKa8mSjIRjx/pxnNazy7iFAtG7D1v9yMuJ+S3TArTBHBewAc?=
 =?us-ascii?Q?Uow4KL8lFlG2oIP89FhYcuj4O9QEz+p0Ie/6jWEAjdHME/4u7zkkU/ezzSDX?=
 =?us-ascii?Q?WAeRzL2rFeP9vmsbWbIGAb7rHBAIjfmAwUKIfiPjc/mn742vqEuqQnJgY80G?=
 =?us-ascii?Q?bOfZ3BKWV9WzanXqSQqL8viowsRt3HuYiWcjEBwtnPeT3h6y5uOnX42kHfPc?=
 =?us-ascii?Q?bAXLuCcam7apijXBXM0tg3S9GOuXCzI4C+MnaVFmAqSwGA3gZ+1JZ5vtJ8px?=
 =?us-ascii?Q?iKkoLBaYvrt4+ioDJe5DDoNypmo+/ITp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MQcMLru/XakJDb1pfznJUXDvHmGRP2CZlzp4TNEO2x28wp6xLSnWXQZxwGcE?=
 =?us-ascii?Q?nsRaL1amUAsMO1mawYAeaSiKHv5H4Pw7bFUOa4iheiuU89wKYXod614bUCii?=
 =?us-ascii?Q?fV2pCAIk1/N884ADS3OZXx8zvbGC9yDwSR9lBhh9x8zk9MjJdaCkgG3hgG8V?=
 =?us-ascii?Q?5FFEnh4GTLvXQpthFs1AHO8+pIwE8YbtiGb0nLBWmzDt9N3H+cDGaIjzs+jy?=
 =?us-ascii?Q?VDbKFi8VIIYEo1epAPQe8kz4H6giUYUgeY1CF56RdWC/PxBl+rcnWV3rriei?=
 =?us-ascii?Q?ql4BFPiO68r+EnjFJ/9fsL3+AIfxUEtzA6QQhQKIB6RKquR2lpQnWS01Hig9?=
 =?us-ascii?Q?LWXrMSZv5Vjz0h5szBve+f5ZT/r8b2BVLg3tKU3zyGdf5t3MpWFf5UfsDZLb?=
 =?us-ascii?Q?jOhnzUM0inCYpQVsmVdlA4bToks/aZNxR2/NzVoIIJ/oBJ8Fai4pyYpDAlL9?=
 =?us-ascii?Q?rD7WdJEWOaHhExpvndbKpOUe02sqagclUkxwX1151BwH29bNIjO+6Nc0qReu?=
 =?us-ascii?Q?/743i4PXYyTib0YgLEflO79aIVn48avJMvr2PiyAh6PEPJvrV1tGVLiGyNS/?=
 =?us-ascii?Q?NeEN2+svuh+WUU+YfjyoHEGNLJLL1S05LpSr9ltAXPXF6fMKSiy2+yzGhOEC?=
 =?us-ascii?Q?x0ZZbU4qpjNqzNYq30PaexVH1KzEIfbJSvbZP3RUjAhPthbkAiK1i7aWAcUx?=
 =?us-ascii?Q?tX05cWKtwIa1YQQ80uMEt1+EQr7lFvDPpmLKbwK+nIolcZwjWdkUNp/3aCCm?=
 =?us-ascii?Q?LXGgeEE/yr0/gKnayUV9WTPLkNGU1ZUM992Lobzv7zqQLZFRB0VFd935Ux2d?=
 =?us-ascii?Q?z3xpNHAsSaHXwjtbWd1H8FeazhHbhvj5xmyhnQulrkXm/2i7unJ+uxjmvR6K?=
 =?us-ascii?Q?y9gaGIWBJWoVCmiAVKCh2aIyrBcUB3slf1wddcyyAsXYsZ8r4LgBiAbAP1Yh?=
 =?us-ascii?Q?64JpVD7pJHjbjs4JftTos34AnHqORqvxokXlzhzPhtS1IBjklopPlG3eSR2H?=
 =?us-ascii?Q?WCFk5FuVOrFenvSzyDTtZ+TZraJWiYJiP5MLwolFFjPLizLv1Ij1yZEaqp6j?=
 =?us-ascii?Q?v60Q8ejxGsjc3X80nbKSRgYazfgMAEF4CRIvqani3DmXX6eSVUmaSDVEk10y?=
 =?us-ascii?Q?P8H58n18G579CL2IUrbHWu+UZRj4ppDH3tt9BOooeqhorMFXnjYhPuZGnUI4?=
 =?us-ascii?Q?GF3m6CnKduR08ziszTxIFs80QjGOS76Sij8+QzV6O9vtptXAcigfM0xAuojR?=
 =?us-ascii?Q?Rc9YebaTgfn+/VLKYGvA/9DL8BTK2P3LIm9inn4VBrUtLmjGOU/G0DpCD7wC?=
 =?us-ascii?Q?CZzdpBUIEXFG08NMXiEtBqMEXlzrPWbqZtCaI97+sblExXaeNy8O/Cy1rMk7?=
 =?us-ascii?Q?MtqEFXCeQtzIPkOjlwEx4u1ssELLSrzIwoaZ5VcyHXzrbdNclyxpCgnWpgYd?=
 =?us-ascii?Q?sUV4UHWUxhJ/PA4kmEXYHXLXYRsINoNPQVVRwlD14zAa3SKCu3HbNyY40OQO?=
 =?us-ascii?Q?2+IZxl7NCuK/9LMk18uF/YJFh6JIn+y/eW5kK0W4yFFsgbUZAE/lYtgSY7SZ?=
 =?us-ascii?Q?ZpTm/OzFYTjY7pn3yIto2i6M6FPfXGcoV610MdFnDh1KnnKXPLlCoDyOCinI?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VZDgPxnyOiF2oeO5KGplXNGeCqjsvqVA/oPiPuHwvojC9Ga8K1MXOoYP9QJNvP+lQvKfa/ng1fXn1KnuptWDyWMwcX95NgiKEXTYDa1BVWFSdnt7nSSnfQ3GyzREHxhaehYBiBEWYQyc7pUiU7pZ6x3C9olanuLIRj+K0KDz/OHgsQ6eGFhrrN8TQkl4tomrprmvaTVA581huCahjNwy2ez71kttOlMdqmSap8gVilZS2t5kOpK73nIr65FPBbyoB0ct42fVDQD0JnVdLREaesxQ9wXo7IBaypLiNaYd+WA4HR6JHGTqYMSUkC/oIUEq2w+uv7ME8PhpPWkRN2Vof7OXR7EJBLlOegTtSxBdD+iMHQgcbzlObFE4MKx+RO5hS1DC3nPktMMrLzLiqPYpMb7+u7Y/l1GTi0qHMglOgCYEOMp5eAALEYRt1VE8YpctclPvXQkAqM4lM5Uppvj0rQYPpIhXiidLpsdgiPM+5WAxntAN9I5xsgxNgl6t0jNg6zNlqcdRbRFm9jxI+fC+4W7soDQCrdBF5Q0+wVYQ3YiCWWZboo8z2rgoztYXtnuWJ26a0TrTnyIOLbdcDWjMzMDryCWiVO+hRggjPdsS0z4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0625fa5f-e4ee-4cc3-abfc-08de268bd2c5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 10:18:31.3395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91JGSxKe19zEyvuqRskn/z60X5qsqKIfguopjw9TsDXL91543I4+gvt1/6UJ6yAjUbouH6JvnpmC1PvmgEdWp8KLjeC0ek0tgM9czr1wwAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511180082
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691c4801 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=iU0FZCYCfJC6mG8IRBoA:9 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22
 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-GUID: JitUu5YnEDqhZKiJdEGwpaOWH4F6hwIw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX0CkLnIhQ0pZw
 icCMmrsMIQzl4pnT/MNclfgc/FotfRI/ZAy2IHF5U3sdC4a83hODpB0UI4asgBT7trEYuXqBrhe
 z2PXuIMAHy57QIHE2NN1nD0yKXmnqIgav0XbljORBUL2JGiRK5fUzmD4k9+ITncmHop+i3UTcsx
 ohCnKZWNeg16Yiy+C/anOLNSeL/lxlERDGDEDeQZ9KrZTBU8qtgzd4zLBj/H3BzGIYdMS5ACJDa
 B4ZCqedBRZ7AquVhaW9IqVQJ8XoKUaZFbgBS96KW/yUD4bVYC4WzOmj7uJPcpFIRGdMSzAMBeDl
 DUZIiJJ6s81MMPHO1QLVrLl/p+u0L0EBwwzj/+UmXBbhm1q5vhu6poG8xd0E4pfFoFC4Aj0/ZN1
 pqsiAmoD0UK8n+nCM/iBRmMhSszVYw==
X-Proofpoint-ORIG-GUID: JitUu5YnEDqhZKiJdEGwpaOWH4F6hwIw
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B9246160002
X-Stat-Signature: dfha5sdenhwzqhxuo3u7fewuwg93xz5q
X-Rspam-User: 
X-HE-Tag: 1763461154-848580
X-HE-Meta: U2FsdGVkX1/3SMqy98Loq+K6NCTLl9I15qvuNTQpl5+hcHnJTI+gpMEFtu3TN6M6gKCT2NFkbo1S8XlBfKuu8K1exAwFrGdg6176oaHbeRCUoiGZ+IAfZaVL0jXQsbdMeYBzQCUTnUXp/308hUwP+BDZL3o31xuNbCnbc7U0sN1S4bckAq1vuUW0Y631S2lzLSLiD43RyXWzX4g2YwkoWGPgY3PHaCu/LndTKrErK2GYjvDPLw7rjshkN6VGyy0ts3iKt1I/DtahlhTQmHfeVOnMLgTH1lgPK0SD4FghGuLPHXDoGhd6mF9g6bbEtGM4gr4CoM+guSehVRc/J7YIyb55MLf7TBMK+LV0MRquWTPUO/aMQVoeEwsq7MwySdHqZbhjiG7gkgtbM4uLchS9l8hn/hBqlIPmMKLCAOzw2HmfuahFosJ0+ZrOP5P4o/mId6tdeF2Kk1/MoEWDJ1pLj7kUa+tiTs/EV2bUy2QnK0JtVXwT43UiZsmb7QOXncherSGU6hyUn17BAgBPq2lB5JXiRlUHMSEn0GSn2PJL1wd25MDbQTgsy44yebrOP5BZA3w3ZoJXsTfPJesuQOxJ4ZvXsWWDeoywGYjziIk/VGJrVeh+1g1zDt/03ymeAeSHta6vTpsZ8XvsPxkGCOhdwhsW7j5MgkBP/OG878qvUI2qP34rgZee5v01I6tOXJdcOJ1mNTad7rjCuD/EqKk8i/m28RNQ9hHeC5bJr4Xk0MbOp/g/d9+yeXfobVtMPP1k1YEy7MzCUzIy5jWqtRG1Pb62fq8RsK5sgXIkNgMoLcWoO+aj+5wMNloFluFE1WktpIdwF98H7Yhti2zXETNkwZ0u68TDCowDRLTMw4cJNBAy8qhp0qQN9kTqbkyYgW8tWCZGqyU1o/iyxL4n62fl6/DKp6VxSU58QXhf081Ee8LgdZG9b6nSKD3bq1PJw8DGU5y0nu7lkh/ehIcI0/s
 7g0N+FoT
 TaRwGvlEs6lNhDH9n50S7en4PWxLoXKr7nN9mSSb+L4AJB5z39KIVckt66jNMPCTuxiUsbz4ScKho/0TRRfkYiH4Lh4bzQizCl0PDNe2ycpfUaXVLRVlrOcVRqlCWBV2a1gB86X+x8Wle0LMFfmuCSExUpF31caZ8PBn5dEeRwE0ow+UlqU2jV1EjUyaUmD6alvP2w/WVKYd33m5fuRVtr421gfr26MpOT3XQQ4Yibc+LlXG+Ib2QrIwpu4bwp+A4LRqFHVXss3ZlPwD0Bu2XaS2B+smyFmOAsWX97zB4hxWQJCAfEdOHnWNfeS//xnkBZXws0bX8EGf0LFCqyK6A4cQNZHZZrRyOq/HCSLeG/CzkTHDcO70KwWeldvV4uQOymfWpP8jd/C7fi72PDoOomnljn2OJU7UdlzKD6/0tvOgqEFlMIrKTBocKdsQX7583gon3zjlStJfMkPNeG+kLBWnGzRuDurNGTI/epMoGAjy0vDdXIQ7yIyzxH1RSFDbNB/XMw3ZWVZUKznKjojwZ1stHJpRna58RNLtKkidV39hzgPBxOOF2+KuGGLI55Xg8q8PdYyN6U9ulJ4QnNJefkoo7F1fvcmpvGIv7zWGyEcQyS8I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gather all the VMA flags whose presence implies that page tables must be
copied on fork into a single bitmap - VM_COPY_ON_FORK - and use this
rather than specifying individual flags in vma_needs_copy().

We also add VM_MAYBE_GUARD to this list, as it being set on a VMA implies
that there may be metadata contained in the page tables (that is - guard
markers) which would will not and cannot be propagated upon fork.

This was already being done manually previously in vma_needs_copy(), but
this makes it very explicit, alongside VM_PFNMAP, VM_MIXEDMAP and
VM_UFFD_WP all of which imply the same.

Note that VM_STICKY flags ought generally to be marked VM_COPY_ON_FORK too
- because equally a flag being VM_STICKY indicates that the VMA contains
metadat that is not propagated by being faulted in - i.e.  that the VMA
metadata does not fully describe the VMA alone, and thus we must propagate
whatever metadata there is on a fork.

However, for maximum flexibility, we do not make this necessarily the case
here.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/mm.h               | 26 ++++++++++++++++++++++++++
 mm/memory.c                      | 18 ++++--------------
 tools/testing/vma/vma_internal.h | 26 ++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fea113d1d723..af2904aeb163 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -555,6 +555,32 @@ extern unsigned int kobjsize(const void *objp);
  */
 #define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
 
+/*
+ * Flags which should result in page tables being copied on fork. These are
+ * flags which indicate that the VMA maps page tables which cannot be
+ * reconsistuted upon page fault, so necessitate page table copying upon
+ *
+ * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
+ *                           reasonably reconstructed on page fault.
+ *
+ *              VM_UFFD_WP - Encodes metadata about an installed uffd
+ *                           write protect handler, which cannot be
+ *                           reconstructed on page fault.
+ *
+ *                           We always copy pgtables when dst_vma has uffd-wp
+ *                           enabled even if it's file-backed
+ *                           (e.g. shmem). Because when uffd-wp is enabled,
+ *                           pgtable contains uffd-wp protection information,
+ *                           that's something we can't retrieve from page cache,
+ *                           and skip copying will lose those info.
+ *
+ *          VM_MAYBE_GUARD - Could contain page guard region markers which
+ *                           by design are a property of the page tables
+ *                           only and thus cannot be reconstructed on page
+ *                           fault.
+ */
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+
 /*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
diff --git a/mm/memory.c b/mm/memory.c
index a520720702f0..732414852570 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1463,25 +1463,15 @@ copy_p4d_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 static bool
 vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
+	if (src_vma->vm_flags & VM_COPY_ON_FORK)
+		return true;
 	/*
-	 * Always copy pgtables when dst_vma has uffd-wp enabled even if it's
-	 * file-backed (e.g. shmem). Because when uffd-wp is enabled, pgtable
-	 * contains uffd-wp protection information, that's something we can't
-	 * retrieve from page cache, and skip copying will lose those info.
+	 * The presence of an anon_vma indicates an anonymous VMA has page
+	 * tables which naturally cannot be reconstituted on page fault.
 	 */
-	if (userfaultfd_wp(dst_vma))
-		return true;
-
-	if (src_vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
-		return true;
-
 	if (src_vma->anon_vma)
 		return true;
 
-	/* Guard regions have modified page tables that require copying. */
-	if (src_vma->vm_flags & VM_MAYBE_GUARD)
-		return true;
-
 	/*
 	 * Don't copy ptes where a page fault will fill them correctly.  Fork
 	 * becomes much lighter when there are big shared or private readonly
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 73c2025777e6..233819a9e7ee 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -145,6 +145,32 @@ extern unsigned long dac_mmap_min_addr;
  */
 #define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
 
+/*
+ * Flags which should result in page tables being copied on fork. These are
+ * flags which indicate that the VMA maps page tables which cannot be
+ * reconsistuted upon page fault, so necessitate page table copying upon
+ *
+ * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
+ *                           reasonably reconstructed on page fault.
+ *
+ *              VM_UFFD_WP - Encodes metadata about an installed uffd
+ *                           write protect handler, which cannot be
+ *                           reconstructed on page fault.
+ *
+ *                           We always copy pgtables when dst_vma has uffd-wp
+ *                           enabled even if it's file-backed
+ *                           (e.g. shmem). Because when uffd-wp is enabled,
+ *                           pgtable contains uffd-wp protection information,
+ *                           that's something we can't retrieve from page cache,
+ *                           and skip copying will lose those info.
+ *
+ *          VM_MAYBE_GUARD - Could contain page guard region markers which
+ *                           by design are a property of the page tables
+ *                           only and thus cannot be reconstructed on page
+ *                           fault.
+ */
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+
 #define FIRST_USER_ADDRESS	0UL
 #define USER_PGTABLES_CEILING	0UL
 
-- 
2.51.2


