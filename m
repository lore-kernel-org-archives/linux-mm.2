Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A02ABD46952
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1072E6B0197; Thu, 22 Jan 2026 07:55:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2066B0198; Thu, 22 Jan 2026 07:55:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EADC16B0199; Thu, 22 Jan 2026 07:55:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7B026B0197
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:55:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 873825839E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:55:23 +0000 (UTC)
X-FDA: 84359595726.09.08C2513
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2F2E318000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:55:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L2gCtz5S;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fU+9MdnE;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k422RYoRSbpgSFx7aoaaNlGWMFwttH/CoKIj+EAOrXQ=;
	b=V0+hj+jP20pTNgZDfgpNa/8Qz/3GLOllZ04g+k0Da+Lo7dbt8OaiSLApKHcvbptsyjtYLg
	p8to47XezHaLn6yUebX5R2dfa/umIUzk5Cr3PPv37lNxGqwcz6+/oWVsq7ON7fS0F/PvrJ
	WQ7Tb4uh4JPjS+UyiuyUfl+GcOn5ZLQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L2gCtz5S;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fU+9MdnE;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086520; a=rsa-sha256;
	cv=pass;
	b=meovGJLvdoXCXG8d33CcYfiPutMAsaD9VBAlneEVxFNGl+P1FuxtZsaLW8KfwW+sj/31/N
	ET2t2PLjTWq8SkqcOtOi3fE0tdBBe4HaG94MVI/f/Z75KEPmmkaEy3kyp+gvOxY04ByJDD
	SAxQYuCcpLqMJopuKiA5LX3h7HaWwb8=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60M3EibV420947;
	Thu, 22 Jan 2026 12:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=k422RYoRSbpgSFx7ao
	aaNlGWMFwttH/CoKIj+EAOrXQ=; b=L2gCtz5SKAF6Nowbv+utOAjZVVO4cUwrTk
	QoONiXtvDa8SPe/oxj/gfls2M6s6f6kwQEiLIb0xhmtRtzjRwAS5/wOCrdHdCYOo
	biQ1dBSYW5cBixVD26s7IuWzDE1D/HuhCf22+lYtl06XorCxAdUT0V4HYTyR+k1l
	OLKmrhlrCG7uVB2Q5pIwA6di65VBhkq3Ne8rDjpnZ4DV+mF+XoGBKXZ1Rhe+sM4k
	FsptZq0NhM0yhu3FZQqsEFtOCZhdaewIqZwnHx4sADaYRExh+SZZUm+PjuiW0dBt
	I3teZYWIOe9I8L60gSVk+VaDX3aZeJGHcRSL26KEXujQ1XXJrTrA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagcv7tr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:55:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MCBRrs032254;
	Thu, 22 Jan 2026 12:55:06 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013049.outbound.protection.outlook.com [40.93.196.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgk65u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:55:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yfXscKTbx7UePVWRWlTMw/qzGlwHHvlO11YH95rsLZh21gbzfo/RULhnuYX7RM8p0POENl77jYcfdM+vgsbtZtYU9sbswj/MRYAJ3ddcIHOcPdCYLtjgOj9gJ29YC52xFzztDhpgVhnOJRdtABuRuL8yEBDx9Vvylh83snMsUfsjGXueq54mkhr98sswcAU7sLww3QJw+EzAIqYFvveqAWjTHdn3cSEl9E9v7gCBLqsKyYvPBH+xxXtBQbZmM2xyAHtJYSRt206KhLrCYtCddXNU9gAmb/mZKypNhvyB+kWG3Fj7ulD763Q+Feru+ImkGywheNjdHqObL1pRr+sEXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k422RYoRSbpgSFx7aoaaNlGWMFwttH/CoKIj+EAOrXQ=;
 b=eMpEQPDk/UrcrgmtkX/4zUk8jiZiJ5XT8UHFygq6VkiFso1+vVgCLFFh5BzAXoFda0xGjJ4vMUluUO694HYzvCV/I9dbSjiAgO7LBUfE4FjdEu73hEvZ9cjO2mNuN+YFgdts2xGIh+27u1rfcUSosaSWN5UNoLtU9HuauJUcHgGQqot4ffgFTZs/tIcc6yhJTaIGHt7FsQQrf1RR9tphFVKGAABwIz+ueLdbvKu4UEXHMUjeu0SRwq05afjBqf2UJ/YGvWltWGFo+8hPm00x07KPDH7w+5w3YObLNZtHa1vjheisdG3++4ESxqj8cPYAl9SLQyjDcTNBHwu1BP8p/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k422RYoRSbpgSFx7aoaaNlGWMFwttH/CoKIj+EAOrXQ=;
 b=fU+9MdnEg8YNeSuhzEYsp5J0K5OHCYS0vksWzAVAXmQuXPsW3rIEe0uRPmexvieMzMHfQ93Hu/744enVyyk/NNkHR8bDqGqbKjmOGSfmgzZod+nOlRWCm3kZwW5BfJQwgyQlG/lM4o7VS/GIWgl3ztbcDplqvnpDmuo6U7xXN9s=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by MW4PR10MB6557.namprd10.prod.outlook.com (2603:10b6:303:22a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 12:55:02 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 12:55:02 +0000
Date: Thu, 22 Jan 2026 12:55:04 +0000
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
Subject: Re: [PATCH v3 00/10] mm: add and use vma_assert_stabilised() helper
Message-ID: <d3b55169-ef23-4b23-b36d-f933973b351e@lucifer.local>
References: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO2P265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::33) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|MW4PR10MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: 37bc6075-2f64-41f0-d9af-08de59b57535
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NjlZxK+lifY2c6HVg0iTV1wJzDiHdzCCilJome7iGjwZ+CaL6TjRvMsSW1dv?=
 =?us-ascii?Q?MGp+b1G6qeFt9BLLHUE6vHjSYjU9TubLTBGAmwEhUkNMkC/Ai32TJJyQx9vo?=
 =?us-ascii?Q?NAJYwPmG2FtQFO/TLexU5xpVc0IYPCoPNmqX//hw9zpNWqu3VsCLNpYeWN8A?=
 =?us-ascii?Q?tdUYnokFABCHoKMXcc6XjQX5gL1hoUBibA0D7D3oKFEWueHKzPv/yWiKIOV8?=
 =?us-ascii?Q?+gLNr+f6XhRXqKN0Cs5eKicCXpHv6j5Gs+ie3gXAS4NTaCwGCd5bIxUwRgHj?=
 =?us-ascii?Q?flvz0GA8a4hlZQL/JZfJWva1wr1iPFUj7kEqlIzXQJPv2DBqDSlW/EmQTSDy?=
 =?us-ascii?Q?2W//oXete00HRkibi6v0XamI9OPl9t+45KvpNXZUYZo0tQBHDvt5Yh7MpQZw?=
 =?us-ascii?Q?sg5SoP1+iJ3SwZQDA/G3QTtJc1QJgzkvAJ1Y1HX4Q/C33uXW3glD3nIGqYeO?=
 =?us-ascii?Q?zklbLvpvnVSJTtn5ICCAYcNGiHDW2NuAOeYzi20sHJNHX5gjzSeIzmhstbTl?=
 =?us-ascii?Q?fgVFM6L86xOHoQQAzQoQtoTd7fYdcppYXwX89EgURt9w5udfqqZ/ENOBR8IL?=
 =?us-ascii?Q?aE9mVJRzMLBui4FgcDUqe7bNZiunKkBlHwPczMdx/E+FYS2dj9YcsCekJCJr?=
 =?us-ascii?Q?Rq09DbSiOiql5d5wSryBn31jJXrBC0YAjsaIpHa/YF1aPQyqRhrdFt1q/rKV?=
 =?us-ascii?Q?e3URtvw3nLcQkQ202DkDLPa+AQ3k97eQXfDWT6wRwMT5iOsSgcmOQoWyRy2p?=
 =?us-ascii?Q?MGW9x3cPMtvXhRdqkA9QHkQbaLpq08iY7XxlOffGx0bpwHv48YGcgYyalyUA?=
 =?us-ascii?Q?jVEGLKWN3mgT7AxZed6HFkyAPSJ6Khe6Mp/ugIYog/CTCZremZe+vic0x8Jm?=
 =?us-ascii?Q?e4AnL4UsMiuIl6FGrTAVTa8HICDN9EtgJj+m8WSmEwfjz+xs0Ev23Ck3Ayvg?=
 =?us-ascii?Q?Y60eMg+LoMx2XcVBm+k/TiVMcpCBol++ahpSKLrb5iRvdvdhmsZNti8FpXFA?=
 =?us-ascii?Q?5j/3MyXXvYa5s71nCYqyOb1zKIGRrjXKz33UqszjNR/5XHJWQtfOPC8iVGRK?=
 =?us-ascii?Q?O1SAqvcH2F28hg2IaRfQgWL2VYCXAXlSkQGNsa6TmtPep5zFyf36Ryr3fn2g?=
 =?us-ascii?Q?Hha1rdKHhP+XzQGyaRYPfVbK8zQVTODkqOFuOVhke6U0Z4JhirGgV/nAinKo?=
 =?us-ascii?Q?pjYEDg0nhypkNsjxg5h6c9dU5/cvichs9BDq8VJSrtypvOslEcuPzlw1sTo8?=
 =?us-ascii?Q?QI2xy8DgWcype2k5xiSwNoati90Xx19vlQjwRKqx4FzSvdRZnfUsj8kCWbus?=
 =?us-ascii?Q?cdQQXi9Ti5Z98mbtnk1b+A/DyzxB5JJw/pmOJntEQUzfTQHZi40cEm+ka+Sq?=
 =?us-ascii?Q?weYhcUP3K2yRfYuikvtn7aODIit1p/Y9wd99tqk7q4mZXJSrfL53sWgwXvYo?=
 =?us-ascii?Q?qRusq1gQKV856vNkpdTko8dV1x7nEcl25KGbYbyGF0mluzRJRz+RwSuR20V0?=
 =?us-ascii?Q?+VuEHY323LcU5fOQUr+Qe3MZ40qEejORU/ZIMYusPXQ82f7MXEHM00x40jE5?=
 =?us-ascii?Q?x9Kt/m4ko2al807h2e0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jrpyQ+vSy4ZBaNOQA4+UwjJRHEh7GDwKSyb8DcL6IUGJY8AW1z7j8pXTn1T0?=
 =?us-ascii?Q?enLxd3U800DIAzrqTEm8Bn7h68zWQaGq1btDDEz4wzq+7YRFjh/v6e518paN?=
 =?us-ascii?Q?hnU/FOjfBk9KNg3I3nWRmT7Osq5Y6GAOEQogEVzy/SCYtDoHBu3FzUtBUs56?=
 =?us-ascii?Q?mUCBIgeHFaI759VOoikSc0wOYhlgbN0lJelYJFgL3rckeViXp7VwKicg+R8C?=
 =?us-ascii?Q?+T68ezWYIXU+UZ2Xc3RSShHDjFABq6h2tr+XVemoOzpJZXZSN8I0gy+fyiNP?=
 =?us-ascii?Q?Y4LTfHlMU7u4Nopc6G39V8xsTQwS69v+NIrW5IZaEzTGsTk7Qh5wYqK3G3hc?=
 =?us-ascii?Q?1b0m015dEE0WcFRz3PxggHfbLwXKh6gDYdCnmgHlKixvAoSxgDXMt2VBXZCJ?=
 =?us-ascii?Q?CdgZOqRlyVVKWButYG8kB3Wo/F+Q4mymvg8WZHmSVO7wYVn9RBYXAaF7qWnc?=
 =?us-ascii?Q?f4jifUna4d72H1seqqtQIpy0eZkh2uuLFzxAiH3nt+8eo0KvjVBJwLJnj5pn?=
 =?us-ascii?Q?G+E2qFrLEuvj5Ze5P3tcRAuzfQb7B/+UOnGinS3uovndRxM4eTVj/4DL7pAZ?=
 =?us-ascii?Q?DOoRhe2EtqI1H1I4sQkUmqgVLuoGUVX7Ymn2FWbgvbDZ6Uh5SpZvBAWNZ3bj?=
 =?us-ascii?Q?Vpgh6w9J5Ptq7HRUwWdPAwpeR04ZGRn6OKSfZdecAV2Oym5mPNBUmaMBVzUE?=
 =?us-ascii?Q?ZULBwBiC6LQzLKFNu3GGH+g8OrdDdDSUtXtAaq05u1EH24IMJFmzhrVZqPmU?=
 =?us-ascii?Q?sV4po0i2JMnkPfLkFkdCBkCT8++WF1AJIOMe0SJpSnjI1Eh9HtRzTBXx8oTb?=
 =?us-ascii?Q?m0ykuryQ563eSMlrCEJHthswS9dpHWg2y6LZSjPMxlqu/q2ErnA1QmBh5r8b?=
 =?us-ascii?Q?Qp9TqAV/ti5SR6QF3UWxKhAY7l/oCtYwPp46rmr8vJ+AzHKz9tqJc4bQFXrI?=
 =?us-ascii?Q?I2V1jg3omj1EOKVeILVg3xXzp838Ml2uz/5F13KIJjuv7jZ+koNhHEnr+vsb?=
 =?us-ascii?Q?Y/6e8P9EE6YgHxMnCO/QAkd5CsxcF8XSmb/cf3PHVxfPN3l19ywigLIZm1Q6?=
 =?us-ascii?Q?VcyKv0yAieSuFlivohublJfogk18NNIR/sGsRNf453Js2VB/hfYCdW8vLe20?=
 =?us-ascii?Q?3IYfMW7SzCsIIrGmRnU9XM3uJLNyyOq+fcFMV1zTPcCX7LjdI+8cKJRF/ryw?=
 =?us-ascii?Q?9BlOy4pCrIrIxRDzGy8WyuE7yImHcMdQBtpH5glU6vzWZu0VTA1PSD8I2YOL?=
 =?us-ascii?Q?jDMheKOKVu2C6CDv7O8+brL7P6YpbodDh2OR1P8t9e36otwX4FjfNiX3Zp27?=
 =?us-ascii?Q?Go37x2t6XONs1YX9oRTOJ4Fza+JHO808ZHejXpdqq3zakJAjUN7B8lKtMA66?=
 =?us-ascii?Q?1L+qYgYCnL1At0eP5H6OHPlnSdwgVRctTxy7HH5jmq19HZj0KG0dzdySLT1g?=
 =?us-ascii?Q?rZpCibn/RabzsDTA7XQWY68WwIUQdRpX9tNtiKHrrCwFFRgJUgTA0+nNGmt/?=
 =?us-ascii?Q?+vNuT6R1Aw2E1SwWNhjR/Jc2ZdshCeIEsJ/EAIB7lxWrnH9vz4mnJdJKXZOh?=
 =?us-ascii?Q?UCBo3rQlO6bt56tTYaQ5WSsA+n+Bb/EdvQ2wtNXR37ZmXiKgZmcUCdU2PwPJ?=
 =?us-ascii?Q?XunNni/9u5oIN57rXdSxJ7cYrk5JcmIn3ufRqzuEJz2m+3knz2N+1ohllEn6?=
 =?us-ascii?Q?pdanpmVw9KMffxtBvAJWXhupRuwZkCSE1nVYZ4HhHYImqXoHIiF7/JDUvSBg?=
 =?us-ascii?Q?+t1d0Sk+ZieP6LiIQ6HCDErE8J4WbSc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v0afelBk3w3tvFDudKWCFenC9FaZCDnZhVAX99FREetXvX/HSy+ImOqRC+oZUPFckCNDmrORElKu0uPwSdIZpqEkBQZM8BWlk/m2WQMImpHZ/wlixxBJxEyjM3liTrGKug6qXGO05tK2mE6WVgcDlNAx6Ru7dSEfR9RArK1bAnCdUlNDzYfuOkQxHVPbQC0sztCPFt0EOrNAjcJaQawWYouF3mvCotw0gFoPTOJDsQAy7RBun9z4wKmKyT3GWxga6lSsFb6h7lfWpYifjxNfMY0uYDxaMm9y6A4wNiD73tJT3PNOYqfuqymaeRs4BWyqLoBcB/jw3vB3SMD6GJ35RnLrpte3/Vc6KFfnA1CQrxD6/XTyiSOf9IATpWSzvIkSspJf9/p6frLRQ16UXYmKzxdcRLEov95RHJz93rYe57a1cdzJw6DTr1fLIqlM3JdNjLZ6PWtiu+WZV0cg4v3pggFx93eCGRak9Jls4QM0HpkeXqqsxpJdIbnat87q2Tcdo6tsDVeLnaK1yPBS9w/ZicYlKwzssN0+OXJ0zGJyNHeT3DM1ddIbh+zr8rn9qyTkRouSDCJN2t/qv4SvPAlGPL/LokUdawmp+5fFT4/3Vqs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bc6075-2f64-41f0-d9af-08de59b57535
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 12:55:02.4392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vNGIpENRiqBhodrQSMffyK6kNMLmYKPrR+kLcxnMSESlS/KpM8a9QuD/Yd5+jekfcTF9tfoG3Jt/ODpSHLtwe8onHr6g8Ze0eFFF4U/Mwg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6557
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=672 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220096
X-Proofpoint-ORIG-GUID: zKy_X7RBESEnHetozz0oFlIj03B2UnBf
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=69721e2b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=XWfpx4c9kaSyDVD0QB8A:9 a=CjuIK1q_8ugA:10 a=QYH75iMubAgA:10 cc=ntf
 awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX1dmYLAJoSjDL
 j8LIh5rvIVZyRTA1V0sL9fCuBRQUv6KJN6EfVhMaRThNg0QzZ/rsXgUkEcAAEHZRH1WuknzmUas
 w8vKPOhjeor+ZQvLVRQei/0zR5boqT3kfkrI+sngT7BvLyaWDYFwGm788v3GdZlUm41PgkDjaiK
 8L9/2HWwPfmazfbzrtYLeEncfotRJUSCEJ23uAxPnPx44yQB9a9/OiINwrlHjQBMgNo4RgA6r+7
 cOnsiLsa6oTEKBQanZU0t83ajATZxEdjhlgBtF1VxCLxKLZCE+2qyFgc5S/mTxXPvLH7B0P1ONC
 5LI/ghasSyb5YbZn7WV1LeYP+oQ6EKex1w8notJ+tjgfkgg242nAkcG/bxTl5EAu354jFtgOp6S
 Ylr7Zac4X0cl5NMwmDEnr2eMM0JbLWB3N+FdJZKIv8hVJnqh5AkSVsWP+NkhKobxLeqtLPTA67x
 svOCiYN0kEgki+PTZKQTStkOXOIFseGGAdcl388w=
X-Proofpoint-GUID: zKy_X7RBESEnHetozz0oFlIj03B2UnBf
X-Rspamd-Server: rspam11
X-Stat-Signature: qom3upk1mkmtttdxq1cmj3cdyydy9yr1
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F2E318000A
X-HE-Tag: 1769086520-240754
X-HE-Meta: U2FsdGVkX1+iYMxunNktc7VqX1O/oOVhdnu+s/Ex1G/nVA4j0EJH2jqmdjyQ9w31c2GA1lD0MrUCDiiGEoli2+fkS9fdFad7POVKYyuaxNMa6gBUYA41/KCMhUKrtYf+su5Tb+6aoetcxoMYqS6/qQutuTdvZ/aHLyKLnJwe5t80i+1hnMl/APwPq92sH33fZNvJW7ZOBynooYCKJEGx5pLaKglcymVzwPuHkNg8/mXv6xEMj9p9VqYbxI72GU/V8FGhmyXCJKdmfHHcehlGXhZHf3CNuY+IAoNmFDONIZC9P/uRAu0lmrrGMfjsxulMxt0+93aNhpSbVM+tkM767T9QN2vRIJfIYEx6UwR964oHpuhyhKtnqfFJTHT2F6hTCd8s8ecyVW2Oj4abKP2vV0aJPQaz9FFlaolHtSo9OJ4OgkDoUFrTcGn4Xy2MBU2RbRf79057bRIcuEYDBtYzXHYr6+hr6/q8BxD8QEiwrEtiUhmrrzRXQd8uX4nIq7cwsfqocb3KlsIull8fOflCKvbXVVPiNbQV/6Eq0kd5oLJyspjQ+n5tWy4+K/d21ceEnXrJTHl2kh1U1KP9UHs8/jotjl62j1DgwVx1PSkfe+zimUK/qaZKAl4Wktbtx4KyRJlB48FZ0+hbrvzIKe6kwSFUQUiMd1GsDxLyL2bAqBpBw6D0cZSUrDtvvlCTPDavx1HtcGsbGIcLxdHQos0XooQ5Su7YSgIJcXUPx9ZB7KY5rl1QAs3XkJWAZB8nkci16cQdktUicZ0QE8NZsGckYtnfw+t8zHBRpwLvJXFOCbHy6i7oaDlVZYzL18Vo00exeF8oq8hxSZ8PCe4cjtkBtD26s5sA6ED6bN4TNQ9smxdSjGZZ6Yy0H54DInIyScdZAcyEOQfoP4IcBiPQ3N5abWReUUimHjeeAT/JRy4Wcr0gu8xDlTQARbELRs0gatYYpV0rN8+Xf0ZfI8W77Fk
 W2CRwsxy
 Yp6S5wFfJ6XErGnJuWYT3xrt8xZu/4yURDDq+bX+hjAumV3VHKG4jIVgJ2CjNhgakH3D3mQJSjlaazGCr/BCQGxYyhWLDY9zHFjYJlU9d5Zd4NnOcIvto3beikOnfAgKbTO57ZAJSxFmWXu6ucqKYqfskm7xD1hAxwCemCryPqcBZQbwb/XoeBjw7VIqzBuBdhUo9OEY3O9ZdET8IZ+6Po3CWW4IoUbXSRjJ+NovSdL9qoBna9AylHr6rKG2CcYEFx6hv1Y/ZBqr7FJZTvOLCRoG+07kbHkdn64rOIGB/MqYo3KRcmoMJM0EmKpeuGVVYHMFyu+JVqy7xLspPU/oT8MphxlsvZERjGDviUe9/rKzlw1HuidziN/U79nDIlP8MI4dxA66cePDzvqpzQi5tiHY2YeQe5hg3r5k81ZGDLWXBmAU3T9FqVUYlxvvbr3J4IrTOaAHFWtGoL5y1ROxoXgONA/+3bKIHTj6YAydZ5IPwOOFZMXnn/c6/K6Uo623BNVjuPOAUBGsgGnQgBNoshac7UzYx9iLOmSzLfvqPl/i16uWBOuZO76m/T2iEkeR5LZ9nuzV7iAR7m2GA/Cj3rdDg7STfIWJm41aT084hvttmcBMiN1TEKg8rFsr+7Q1UA7vFahog6Ckjx+32YxcXffqznlRRVkc8DP6D/zE3+sbLY7EUSABeXVxRWR+TlenNG5ojLd4dUjD7SNAyz7DfiXQ8/Ud7O4HmqwXAkAshabX8HgfvtLz8rAlLGZKG8NGYEjmFO2zaFs2IfoQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oops... this got screwed up, sorry for noise.

Will resend, corrected...

Cheers, Lorenzo

