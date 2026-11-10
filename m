Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0590606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wisc.edu header.i=@wisc.edu header.a=rsa-sha256 header.s=pps1 header.b=zXgqWMXt;
	dkim=pass (2048-bit key, unprotected) header.d=wisc.edu header.i=@wisc.edu header.a=rsa-sha256 header.s=selector1 header.b=V7KBHmGL
Received: by kanga.kvack.org (Postfix)
	id E3C5D6B05CD; Tue, 10 Nov 2026 12:32:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD29F6B05CE; Tue, 10 Nov 2026 12:32:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9ACC6B05CF; Tue, 10 Nov 2026 12:32:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8D546B05CD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:32:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52FFF80A0E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:32:37 +0000 (UTC)
X-FDA: 85419903954.19.B5A0422
Received: from mx0a-007b0c01.pphosted.com (mx0a-007b0c01.pphosted.com [205.220.165.71])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7FD5C1C0008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:32:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=wisc.edu header.s=pps1 header.b=zXgqWMXt;
	dkim=pass header.d=wisc.edu header.s=selector1 header.b=V7KBHmGL;
	spf=pass (imf21.hostedemail.com: domain of san55@wisc.edu designates 205.220.165.71 as permitted sender) smtp.mailfrom=san55@wisc.edu;
	dmarc=pass (policy=quarantine) header.from=wisc.edu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794331953;
	b=3aeQiObUI4v2EfOt8FwiYjMFfzXtZbU6/lgCV8dFjJ6p9uY7z0ElA7Ii+k2for+lUZIm/0
	sSjCGKg5OhJ1LbuOxeN3KVTaYeiW9aAfFdat4gp5uIKQbSav6UlirHIbBdfNR2Y7DV11GA
	fnf+qW6lsRqAtNB9NcuMYCK7UwyYFus=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=wisc.edu header.s=pps1 header.b=zXgqWMXt;
	dkim=pass header.d=wisc.edu header.s=selector1 header.b=V7KBHmGL;
	spf=pass (imf21.hostedemail.com: domain of san55@wisc.edu designates 205.220.165.71 as permitted sender) smtp.mailfrom=san55@wisc.edu;
	dmarc=pass (policy=quarantine) header.from=wisc.edu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794331953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ik3shvaSZVonXHJ91BHi6cMWPo+KtP7KpAQHlyQoMTM=;
	b=418vpjyXCt9vVAnvAWGn2CiytrWguHYii4ILtsUyb9FRLnBjkJOINOjT7Nf8pXGaZxeHxJ
	x/90uPFZi/jQPtCcI+4v7SLMwOazq9bB3CXBwgOzjR+zPVXXecRMD3apsF0z7wD9TvswQ4
	0+EYQmzClEE+9NAZJG68aTQe+1S9d6E=
Received: from pps.filterd (m0316039.ppops.net [127.0.0.1])
	by mx0a-007b0c01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAEvR7w1248014;
	Tue, 10 Nov 2026 11:32:20 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wisc.edu; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps1; bh=Ik3sh
	vaSZVonXHJ91BHi6cMWPo+KtP7KpAQHlyQoMTM=; b=zXgqWMXttltaAI1+/DhXy
	OUbVLFqii/D71kb+LRP1Y5TmX9uwFvMi1yBHByQRsFvKA/wOSPXNRGjtg/RWNYtP
	GDDwr/KezImGeUZ4daf/AWiWKHrtCebWimj3Whon2RKFfMv5OnZYm+eFGN8IOULC
	kLAdUDnxCKOAJUFGN0j8Xuyqeygnfw2YsU+I+54oNKpJlJ0cwsDqjDwkI5M1kbXd
	dlOeNfbvY5OUVk7mLu8DqW0gwl60KYg8Uuoo4yWWQiGZaikm0EwDvXUnpVui37ki
	B5ji231NTEnFpxF1HQieBzQFoKiKx4anrncZsUiKIuGb8b/8W4XIYgPB3QmnK+w4
	w==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011002.outbound.protection.outlook.com [40.93.194.2])
	by mx0a-007b0c01.pphosted.com (PPS) with ESMTPS id 4hv4xx21fx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Nov 2026 11:32:19 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mmEULTGW2v1cbGJmjT6tMq9Kh51BtlDTyTkGHmu1Qa6G5Iqjdz64BOjKYbJ/aNXcPyd0yEkHMrLB3A4kbYOzFEn1LH5YxJl074ZyWdSOUA1K+FiYeAA3b+mCWk9lmrpO1uYP5pjAou+Pt5mTTIbYNpqTyqd1nqBpiENk/M7OoZMqavK+Cd1hdNCyH0ePwltQwgceKldodtzj3CCFM9lnqkOcuQ2gU7SjS6ZjtHzPmjQne6QGHJdSFX5Zva3URkR2qzcnPcCxpe5qSO+SZz2Yuq/9bQ+U6xcifcJg9P5h8Ny0whWUEtHl02MYTMEria5FpsEClWxEBm76islUXJqhfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ik3shvaSZVonXHJ91BHi6cMWPo+KtP7KpAQHlyQoMTM=;
 b=Q50N7G3QHSgPGFXeWkHlZ7mTVyNQQ3VnKA7jKg3RkvWStrI+Jrm34bTUoq6rYo9n5fzfNrhoeBn4wdvuU5Hh7jEvgXvXx3DYnGoZzL3jGTL8CHdfp1Y/j4kba8tRAMye/YK0+Ig9ArmRI+awG6TdeJVA74T/yCovvBS9LEFh1qYv9XKzbVWjFdqDV8e9qaEhr+8t4mIsq0U2ODLyhpTxJ4IE0bHtQw1HeERF2arrJiKbEnjMy10Qg1NbwvtZgbP2t3+gN/5268Fb0NfYQJaLk2mtyaq4AwO+HXkuuFhtX4nZ02Xi+ty4EdpZcfeRnEL/6IOPE20Ykf7n27T4zTwT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wisc.edu; dmarc=pass action=none header.from=wisc.edu;
 dkim=pass header.d=wisc.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wisc.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ik3shvaSZVonXHJ91BHi6cMWPo+KtP7KpAQHlyQoMTM=;
 b=V7KBHmGLCox3JsSy7lyOdT/kGNw/iVFDUW9hDemFzmzucc+QYlH70Gzfq6TWWqWNUFaPWMRmu5s3NCtXLWe0Kaiq5VZXhLdHAg+wVRm4+ybEeftT+HTqULFzHr/gJhdHANv9HhYGRQ2OqlEWrEN4fZ1jpNicH9jOtlgV7rUx73iqc73EF7NUWeBrfcmwhWOmNzN/6BqCjmz/U47ESruAE2nVCxf+FPqjwuDpRgDuF5jPY/2UBiR4tXluKbQF5+gUxsb1JAN4A/7/kO+8HZSK5CzRUffgODL2aFmwMqxDfW/QuiKukGDdpNRni+qGc1L/OoQOpx5MO/lM7zVYh684tQ==
Received: from MN2PR06MB6639.namprd06.prod.outlook.com (2603:10b6:208:20a::22)
 by CH2PPF9A54CA1B3.namprd06.prod.outlook.com (2603:10b6:61f:fc00::4ee) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 17:32:17 +0000
Received: from MN2PR06MB6639.namprd06.prod.outlook.com
 ([fe80::c7c1:6e17:5f9d:1245]) by MN2PR06MB6639.namprd06.prod.outlook.com
 ([fe80::c7c1:6e17:5f9d:1245%4]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 17:32:17 +0000
From: Seunghyun An <san55@wisc.edu>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R.
 Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>,
        Shakeel
 Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        Pedro Falcato
	<pfalcato@suse.de>, Lance Yang <lance.yang@linux.dev>,
        "David Hildenbrand
 (Arm)" <david@kernel.org>,
        "Kiryl Shutsemau (Meta)" <kas@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
Thread-Topic: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
Thread-Index: AQHdcSWzotCHaF9rK02pQ1Q2O6oOobcnkJA6
Date: Tue, 10 Nov 2026 17:32:17 +0000
Message-ID:
 <MN2PR06MB6639D846B30A3357B01BC61DD2722@MN2PR06MB6639.namprd06.prod.outlook.com>
References: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
In-Reply-To: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR06MB6639:EE_|CH2PPF9A54CA1B3:EE_
x-ms-office365-filtering-correlation-id: 909fdee1-96e0-413d-c91f-08df3f509102
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|786006|23010399003|7416014|376014|1800799024|366016|261026140227099003|261022075727099003|261026121527099003|261028144727099003|261022105027099003|10067099003|11063799006|56012099006|38070700021|921020|22082099003|18002099003;
x-microsoft-antispam-message-info:
 0Z8FLFlOsCK16GNYpTbNkKYUxbHGJqCF7Ir/wd8KtJSNkzUsFhO9t01Wd5US2dglBM9rkgLjh/7AR5Dr9AdOcWtrcdWFwAreyuMLQ038f8iwrg5Wn5nbpXhirjkM+sVAv61EL3T6DYkJvJbXSV30TmnfOuYes8ALpObRN2b91CYOknjAvkb+X+/DdpBDEm/0it9/PjKgnRB6khhbRgAY5wP3dJj+QGv9soJ2sy3RBcCW/ogt9lwkiUFY3wSKRM5Qh2C3tNVaIWV1N4jQ6yZa0q7GYhW9nopwoXhcJrDUebqyhzMOoIl41xS6YkJgvfXjAAJ45PHubkKxh3IHj87jmW3rFaRRsPeITw3j/jrsA5ac3Xr1z85UCKxKAZY0be5WO5aY+OdVpTpG8uKOkrWrr5UddpniXaNCR1/i6NuJmXAqyG0psflilMqZAXIR/QdPezQ1NY1uj9wMGvNKzWIBoTrmBDYz6J8iX4wi5cBri9SYjv0DmwNiFJQC3n4z9pCm7VZMl4M5GYbkAxErnP89trWoQgcPZbSaduIrvkxwEOC9Qr48aCO1Hl/fs7Lu9B5r3ouVLbQRlfj9obi3Tfpc6RX3hv2bMQzvw8BAEHUFHFRllWG4Zh8UODt8+gsIEs0wyy9S3mvQ1pHqN+fs4CCkGtfMY+FunWqW00AoCPHodshwidItYRhV1wYmtAGc9eAvRIPCzWZQTcvbbc+agTnMP/NnvkLXyCnvUFUwwEdPBh4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR06MB6639.namprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(786006)(23010399003)(7416014)(376014)(1800799024)(366016)(261026140227099003)(261022075727099003)(261026121527099003)(261028144727099003)(261022105027099003)(10067099003)(11063799006)(56012099006)(38070700021)(921020)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?4PAE/C587mKIP3bzMlRlzFnpd1RtsfLmPuYmn4y2ZL0KGJXRGXQSlpvyr3V7?=
 =?us-ascii?Q?nG6ZZzXXfVYrK38FP7vqsYbWBQywkFbF0bMcVfYyvoJyEwOwcdyrH2FeQ4Ah?=
 =?us-ascii?Q?qpsUMKdwHDIKWSb7yWYLpY+EpDuWG58l1TVsf8iA8BtkrVzcztkoxdWB1oK+?=
 =?us-ascii?Q?ApzN/hmtmH+cisn91vjrfy9NgyW1gukRCOQsBcdCPw4p+q8fPwBUnpzoKmxw?=
 =?us-ascii?Q?6V53WCsv23Yx89kQWOGuOpQ6O9SyvjF3zO7VU0+dmWUB4gimt3fgnIDFca0z?=
 =?us-ascii?Q?2qSqMcbCEOEa9YkXemzMza915oJATg8pvBi/4ri6CciF5hf0eL6h56iRkOQ5?=
 =?us-ascii?Q?Exd1BvEbljb+vIglEp2Zqjvzk+gqKD7L0h5vWjjErQBDOpBX4qfe1gAzNAfi?=
 =?us-ascii?Q?TV58etwq2TWgQ4JPUFpgy1lhLOyefmTaMlJy4Ga1oDqaLDAZksXiGR4Y0HMv?=
 =?us-ascii?Q?WYa0qjQ1XJNJqulvmBLV6hxsvFiP+C2J8PDRkd0szo/Gj0FedLQKxCP/3Dtn?=
 =?us-ascii?Q?wnNqECi3hcqWf/9cjsixMR6yd4kg0vrUk5MDpR3aIxpv+AtiLlhQ3XjCvRro?=
 =?us-ascii?Q?wYG1fAPY4KPyVTbKyHXUcUzH+7lY+GGkby3mIfjdYYlUF4ZW69WGwYyAW/BU?=
 =?us-ascii?Q?zwbR6p/YrKTcv8ylUt/OOs6RR7Dse3Frmnwgq0jLcPBBeuECcWUlhrp7UQU5?=
 =?us-ascii?Q?27p2Yboko4ybb7/uaAndIvK4ucWY3NgeUleamK021yGF3H0SZFkLXRVnwdZ8?=
 =?us-ascii?Q?fvHuTuVb4zWORpOR0JY9Mu9BDgnS3euN6Fqj36FkTCINwbJVoJzUIvBVoVUW?=
 =?us-ascii?Q?isDl3k7t4h6EPr1VAEHL3nnaIk4YpEQdmQegudJAArKkC203vwSdhfdDF1Qo?=
 =?us-ascii?Q?OtE5UuMk+rD6EX4SDKvMmIZNTdi0zJtsmdOVChbmqqPvQanLMfIFuA5eiFzh?=
 =?us-ascii?Q?eaMuu6ClAKa1rXHdH8WTTHtTbi+vAGQG/LH9QF/jeXgaJClpEPj5Y2brPj0b?=
 =?us-ascii?Q?4Y7wQLihhKXMFfdB7dqlr/DHPqEG6dpEZWIhgJBwvP7XSFm7gULaoMI3ZMcG?=
 =?us-ascii?Q?5qtAIYmqWCkNc0Muzlao7HzHLkWW4EjenQ8+LjrGeApmR1Dj3ErGtcc6U1Oc?=
 =?us-ascii?Q?zRnK56gQCapnEfXIpgJYIJ/1seegLMvuMH7sJaSvO6HkmXN6ycUSOw6TKu6m?=
 =?us-ascii?Q?nDB/xbkybGOVc0t57xP28Gj1aWIoBuee/O+hGWdUD1QcJd9RaB/FYMA6tpjf?=
 =?us-ascii?Q?DbmHiY8fIa6Bnogm9JdXGPaNnXv24Wxeog/uotF5+CqcNOZi3S5dmuWj27+E?=
 =?us-ascii?Q?GF2Tcw+BobPJVcFj+Q6kgGMI1E9z+2QgXGlHQQ2dP1BwwmvIeYYlxLFqgHhy?=
 =?us-ascii?Q?pyJAmFqSUhV+DAYcWDR7uENYHf0hBwb76Qeu1HJV3gCQWb/JetzZm5h0RmZl?=
 =?us-ascii?Q?4M4EfFBxm7t9uksTefawVRBp05OmI2KHMKxRlh1OqSgDm09LzfvMSk3fINKP?=
 =?us-ascii?Q?GaXn6AzYUWOcDX9Jh25cl4KGkahHdxQLNhDdQqaqUQvxVveyXdPgeMgAB7xm?=
 =?us-ascii?Q?Ubfq0ytFNTwQ3pogLl/owBJ3WdwdcRHCuRtGJ+2pcOkf1HQA1vCn9sP1CwrE?=
 =?us-ascii?Q?z1BRCPg4FRIUXEo1QubEprtVPiINzRp8XOJ5xh0YQW+nfw1hXpOVmlOv/Qcf?=
 =?us-ascii?Q?iCbY1yStm3Z69wkEvfBqaZP4SGwu/poS1l08F+LHkb5j3+d2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	kt9USqyP0XGKonjBR7QDYJcKy4eBHi+IqBFfvHTAbbcI1aCCB/OJk+sime2d2TvDIXwGCwYKD74W6pMJiX4FI9ZPECnZ/1cdOjz0EqzZ5TDvrH+B1R9VZX7498+ShSQeL8Dv7Rr7+G63PffY16FkskuQY9zHqx5BuWMUCH7Ujv5b7E8OwQX3Z5xUfDZ0B+qRZA1lx0kI9zXN12sJoqm/8TCoCygYW+fOeDKaxhj8wAT64hv69I1IWMVUrmreZ4SkfJ/bIm/EUJWJMjHH+CKxCxVNnwlZu3olZ1QcPnHARraeUAM+xvdnuKH+LdwrnEkhmDFWE5KJmgVfcXDUgQ3sHg==
X-OriginatorOrg: wisc.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR06MB6639.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 909fdee1-96e0-413d-c91f-08df3f509102
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2026 17:32:17.2270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2ca68321-0eda-4908-88b2-424a8cb4b0f9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k6w77dplre2wzEKS3GOFpr5MuR468R2z/6fA95i7AWJkUEednU5LtJzppKemBZLM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PPF9A54CA1B3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEwMDA2OSBTYWx0ZWRfX1AH69df31ToU
 sgoDRrBP9EOU6cYZtQqf6HjtZDqQgv4xGJzosYUXjzUx5Tu58LFGHa9znSlRizxIJxCEyuEfMyl
 xoCzSUKeqHD879dnAjYz94NLTobBWGI=
X-Proofpoint-GUID: V4VqHWodDigLUFg2GHDEhBQlgXv6DrKT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEwMDA2OSBTYWx0ZWRfX1PLcjvRubEko
 z/AdUxBjFWhZPU+LWojYyvRCpl15pYqgxkn1Wk3K/2NKhYUm7WqDmqy+Rct7aQ193YKm2uAovPS
 /cnRH2Qi4pZoTJ6eQJR8acFKQEsduRXhwGNL7l8dNAj2Tt51YkbrHp54AFM5It2TZdMAbRNXrgG
 Aj0kJFE41VUfegxG9Dt25r53fPGC9yATBYa2Ny6Wsgjv3HfIlfQDh6Gt4ge03zL8/gFCeWz6Qdw
 WdJ/DYopqkJ1CIhE7J9v+qXAO26Kwvuz2ViZiw3TLnYntz2Qbhv+m0gNC2eqF+V51jPzVubyoKP
 w/s9jgTCrrvu8+CJrybORGstDJMvJoQCyRDXkK+V7nv/ypiIYlwt14JK7AZ0pviNwXg5ssLIDk1
 lU4ircAv9UssLaM0oGK3g1hSzp07BDDDWf8wcxcQeaISiiVaUZdSuWhBrEokvrKh6lcQocFrBeG
 V5x8SarRjn1Iob7kRIw==
X-Authority-Analysis: v=2.4 cv=bdT+w+PB c=1 sm=1 tr=0 ts=6af35523 cx=c_pps
 a=QA4htdGqYz999Ta5EyqdmA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=U-hppK1rdbEA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=ZyELlZqCvD1aXIDzc3I-:22 a=eq2kN7DOR4gdPMKheIxe:22
 a=VCcXySyvJroUtO-_WyQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: V4VqHWodDigLUFg2GHDEhBQlgXv6DrKT
X-Wisc_ValidFrom: true
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1011 phishscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611100069
X-Stat-Signature: a36t5j9gfs1i8ng89nkmfk8axc9cdxca
X-Rspamd-Queue-Id: 7FD5C1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794331953-54649
X-HE-Meta: U2FsdGVkX180MMirTw1oNvqRYtJ2kxjza8Bz0GCMiwItVoMzHleBjFae1fmp9dmtXmxSRcs6SSVoYY9Jce7uYFDjsoy0G4HcaI4yOe2ydo9FwgUZpkmTprnR6PkM5tSgQl6WbhEDSEqWKfjB/B7uGm1s65s9CCVHRKxU3qWQ+0ErjKQVJg9ILwz3B8NMWSOEIsmQD0U0AawpLgAKZ+KXdqkfeFrmBDsOdhgZoAX6eLIq39IMD69bVnlOHRqnWVT9ABzEyZLZQu3wke2JYSzUdJzTqr4QV0ECx86RkZ84knHfRHXVwOD68qXGm/do59ooYCifp6yqYMwEXdGxLh9HT3aTQhiEbisBA0GPKK5vsk7BOcSOjlPppLxYZC6pr64iOgpJPqI8HglAkDKH6wVJVRO6yKrL8abM7z8u0SOLYCZ5rq690I8K6SU9Wtr05wvs9lF4+7/C8t8iUFjXVSNZi3k/w3r97xi7BfP3ft1kKs9C6dDSk2rSwDsUytfwwsPIBIEtzH98B7rtaZgwfmX7QL9xEYFgfB7b+VzmsafZ49Lm9E3V/zeL2p5nT76qMs5o6s3yzhrMFppFCrEuun23bp8jhCFlXwPOBPX90sfSFRx1IgvSFU+2LDO2/fopOwwyJCmx7sTAQCRC34d2KwX7nu2tmxuF6IOKIv4HaeNkyDfQr13ivSooPd+HodeZxO9ArbeioezbXnT4L0+JHC2xChjNZeUHeqAILbrJlTJxc+2sJwh6hdaXSdwv+XAVtPqKbi95fiIMDIClov3IvVs8QBycB1PLcAH7dNXAimSzOr9FgBiHSQYD77ADr2IkCiPNgPC5X2gaF5SrSMgM1B/1Kl2oaFGO6Bh6KU0lwU+H0/Gu212UYOTpYPHMfriBxgzbt3wY2ueQdzDERcHsZBsU0u/cBTdGu0CeE2AR6qDEMmW+yvyxPtLQaqMxmgNt/VXZY1GUvekrbWYEA5OZls9
 q91ATS3x
 bMmNaJdtjdVTLXcK7tC0lurRMylZej/zFx4OUmos5VmLVkiQiDNRMFbcxlAphGJIi77EoTlq6/PjWvEXMGwe6hl16XTWmmS82qUfkWD2xMk48LYYP2pP+b6KCwJ7B+hTimHXv4VXtL6ned1ZdBBL9c74zznkgm6PZ0mGxS6Z7ZPZkJI8bTpJilgdUXRZqSMb+RbhPXH73BVJJ/Qi+yg0KniHwpLb8CZrvpLfreK4jP7QexvQJDjxz0BgI2EguSQJ7/YVjjFIoclOyqER4li28VWwFuh46YkvltDza2+965k9eK4crvhwsy6DO5kRw8cMtH6/8033CPWUv6gLMvDq9HWLFtlqVw3T0ZEI3zi8doeCcMKcI0XT0lXP54lbW0XtnXCx96Dc21mvOejHUCuLTxqcNY6WNinLoRXT3wKRuFV9btVJoHIl0s8tkdkpNJZJbvAsTgTKnPZOr8tunKcorWVfsfOYToh8Pg7kQHv6qX+u18gO10vQusMCIFZJZmVo1fGuYXxnv3Iq9LZHJIWvovmRRxh/GezwMSRGjjl24gInIMMC4miBU1soqbu7/k2s6O2RdlO8JieEnOEXiK6UGWvAJeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 03:10:40PM +0000, Lorenzo Stoakes (ARM) wrote:=0A=
> I introduced commit 17fd82c3abe0 ("mm/vma: add and use=0A=
> vma_assert_stabilised()") with the intent of picking up programmatic bugs=
=0A=
=0A=
Tested on an AMD EPYC 9634 (84 cores, 12 CCDs), CONFIG_DEBUG_VM=3Dn.=0A=
Applied on d48723711bae; base and patched were measured on the same day.=0A=
Throughput figures are in faults/s; JVM pretouch time is in ms.=0A=
=0A=
                              base      patched=0A=
  shared-VMA faults, 7 CCDs   1.776M    1.917M   +7.9%=0A=
  shared-VMA faults, 12 CCDs  2.303M    2.431M   +5.6%=0A=
  pft, 7 CCDs                 1.910M    2.126M  +11.3%=0A=
  pft, 84 cores               4.201M    5.028M  +19.7%=0A=
  JVM G1 pretouch (32G)       1877 ms   1672 ms -10.9%=0A=
=0A=
Tested-by: Seunghyun An <san55@wisc.edu>=0A=
=0A=
As a follow-up, I also checked whether avoiding the __vm_anon_pgoff_hi=0A=
read in __folio_set_anon() provides any further benefit. For comparison,=0A=
I tested my earlier patch 1 on top, which computes the index from=0A=
vm_pgoff for anonymous VMAs and avoids that read:=0A=
=0A=
                              this patch  + patch 1=0A=
  shared-VMA faults, 12 CCDs  2.431M      2.941M   +21%=0A=
  pft, 12 CCDs                2.434M      3.474M   +43%=0A=
=0A=
With pft on 12 CCDs, this patch alone is essentially unchanged from=0A=
base (2.442M faults/s). The additional improvement with patch 1 suggests=0A=
that avoiding the __vm_anon_pgoff_hi read may be worth investigating on=0A=
CPUs with high coherency costs between L3 cache domains.=0A=
=0A=
Happy to run anything you'd like to try.=0A=
=0A=
Thanks,=0A=
Seunghyun=0A=

