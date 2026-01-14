Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ECB1D31A31
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 09:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B9E6B0005; Wed, 14 Jan 2026 04:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829B86B0088; Wed, 14 Jan 2026 04:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0916B0089; Wed, 14 Jan 2026 04:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 57DC66B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:28:07 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EBEC7589D8
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:28:06 +0000 (UTC)
X-FDA: 84330042972.10.66190F4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8A40940003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:28:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b0+t2Va2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RA6dZz5d;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768382883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xW5VEgy2NxliJCt1z+58dqK01sinAD76PX9fSEPNono=;
	b=RJPuHTaIrVpsKN+V5rSGzLuSZnb2bJVzc2201kciMGHJbYhrHU0D3VyUm5lgQoWAzwgVCc
	UlzW+6zsMCEoYFyKMgqI/QwFq2NNTcYRASxTtoUPtEUTSJc9AcTH16bKh5fA21oSHFmeFQ
	O4J0Pi0LLaOfI3EZB/8kF6fbhFHFoi0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b0+t2Va2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RA6dZz5d;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768382883; a=rsa-sha256;
	cv=pass;
	b=axFGue6doXHuVNF4pEhN5U4BQdZCxNJqGokj6zoC7/3a7YRjesIURyCu2CKF84XgETquNT
	2MmKA4xSpx0b1mu7uARLFrnsWUzgHR9NMwCHqNFJRogB1FtDnhV5cNwa6F574uqoH8LKQG
	QJNK+zP2w5hZG0TYbQrHufycILGToIo=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E3vocl787278;
	Wed, 14 Jan 2026 09:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xW5VEgy2NxliJCt1z+
	58dqK01sinAD76PX9fSEPNono=; b=b0+t2Va2DXu8AYzr7B6Fi4WFOiOnwwgRzD
	n2ZMYuYCWCypJoPpsY/jNtfM2l5SDkJJNwLflOLJ6fkOVAwx8IAKjc9tpuzA30rQ
	KMjT0TtYNeWIbQ7OblRbyCph7/Z04mbKbCC/JPE2IC3T99bJ1wmV01UBP9ITNMad
	oa6vSzJrssadZEk4o15CB7tFfHb+TDkPmhdSPfzBn5zL8TgxVFgRSxYUf7KYqd9S
	2lWxAW6TnBKpDfh7PT+iwSbXGBXYi6W4ZfvepfpqpetZA3Rz1OTGTxioLJhoInbt
	5DDMoXsYbrhD6dMHMBRvJdo4l6Ig67jVYOJGf7AVSr4UnFh6dSEA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq54vh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 09:27:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60E9RZBG020498;
	Wed, 14 Jan 2026 09:27:46 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013051.outbound.protection.outlook.com [40.107.201.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7kk260-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 09:27:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=koCJGeJR1duDUQrX0QWymE46LV4wU6HilxpCxZteyl+asmCrkHHrIbvI4ATJMMDaf41a/5Uk8ahuMBUCyNJoL6D6eRIebCpUmVRyyxeX1aH0grWVedemMQ4ffiJdmpYCb07xY+LUi5TUXJCzaFFPwPyGXC3DbtDLRkG5GiOyfBIQRXvrwEWTIPjErEJHo+qsBnDNlkKMtqYs+YHx/QHlai4TcuC+4rv//nU49ofZaYt+6unJIsTDo1vyCdgZuMmDdNbeSZAYEdZn+bY6ol19dOOG2EGldOKvGFQUTLxa5D7SHZOOACWCNWc36AiFdCtA9TKdAFwCatNlLQnzHCvdXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xW5VEgy2NxliJCt1z+58dqK01sinAD76PX9fSEPNono=;
 b=yxIa7oz+Jwq0zY7J+vEWhF3GLQ3uXWfXwbvO2lW17EY4A5RrhVZgLcSCOSKVwedhMeqU4q/1duKmRG9g+7Y6g50OdywZk9vhz0CMueLi1Fa9dhMSbeKSP2WHAQTX3lYRweO1PewuwwyzH4zJBayXCE4UoAjiT9HhyBkO1kGcIWwrIKTz1TYZEtES3i4fNdffzaNqJuN9YrUfRlNMP2qDN4tyBbGnlwkja9EsV9RqAv7z+fjwbM655eKtzNYeLr1yIfzsnQOirDwoqaHq1ztTknmNxNqpAK8zqm4YH6VPf8AuKYdiM/x+CMH1zBnvtyie4kgmrnt4XfI5/fD7fzuWnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xW5VEgy2NxliJCt1z+58dqK01sinAD76PX9fSEPNono=;
 b=RA6dZz5dB7T8csrMXFFMkpQY52HvxnYQc94avIzmUMoTZGo7KamD9WXNxT2CVBzyXmjq9ruAUdIvPL8wHdhG16RY1hc3tCwHkb0tt76TbkWFCTvvK9pXk/44uPrjeXf4h5KzESMNgZEVj+SSQ+ZX+bnLeNtY6DCfoC3fUabWDwk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB997630.namprd10.prod.outlook.com (2603:10b6:806:4b4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 09:27:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 09:27:44 +0000
Date: Wed, 14 Jan 2026 09:27:48 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        david@kernel.org
Subject: Re: [PATCH] mm/khugepaged: make khugepaged_collapse_control static
Message-ID: <5ade8187-87ca-4f04-8c65-1d27acc001d9@lucifer.local>
References: <20260112161818.604651-1-ben.dooks@codethink.co.uk>
 <10ebbce4-1b83-4eb2-99f3-738a0e613958@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10ebbce4-1b83-4eb2-99f3-738a0e613958@arm.com>
X-ClientProxiedBy: LO4P123CA0547.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB997630:EE_
X-MS-Office365-Filtering-Correlation-Id: ca0950e7-48c5-47fd-4d5a-08de534f2c3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u011jpfftNxeS3pjlhYOK4TPAv4Jj+Fu7zElhjhRX2vXyBkYMJUTc2EfCSrE?=
 =?us-ascii?Q?lSbOIOlV5qtDioz8QgeOJ842zBg534hb12CSQb/kNDQOVGuX9sx5SvfkucKx?=
 =?us-ascii?Q?cvqg52aSPOOLnNV5z2ouJcyRGrh5OiPiwDNAV25UYRsk3QM7i7GyDfpqH77D?=
 =?us-ascii?Q?d/nlW9wA2jGU1IjswN87VJRhFdXBsVd4330iFk7+zWXMpb6Fmh8ymnJqaWRF?=
 =?us-ascii?Q?zWazqCEVjJkpYYFdrzHvmTNfBmkoidQfAlx5kA3vtYITrr7M7ixreu3sZKKk?=
 =?us-ascii?Q?/anyt1FrFQIGffDPsPHNGU5/mIAywa2aPHrvcX+0F3ra6hNZNgkyRJpg7Zwa?=
 =?us-ascii?Q?VDjrA8+lU9vGSqB3IuBYjZhrcKi9H1JyRn6THkbVStMYPc5aP6/jih9oLsHu?=
 =?us-ascii?Q?3WfjP4uQSIepTpy/srrrEDNA9ZHnZzNLWe98N5jDCsyKveEKhm0HukRmlViH?=
 =?us-ascii?Q?g8r00pMYhFEE0K4R5MBoyI3x+hCLD8RCf/nAJ7F9MMWbai2qlf0qZtFUqwl4?=
 =?us-ascii?Q?FG938QnL+i1VjFDgVwfLgAMj36v1AJTlBbqsRQOXBEr2b3Ifr3ghcF8tT9j2?=
 =?us-ascii?Q?qWDO+5TuP6q0USDO598mnhJzLfq0xcO04ey+pB4vt072ig3X+NQ5FaGW0jGI?=
 =?us-ascii?Q?5jMuF8KJQAauxOvoDru9XH35UOWY8A/42CDSshIb23AjSfvZ7EhqUwL/d+5o?=
 =?us-ascii?Q?kNsAQNPdhRypXddHL2nPyiuSJ1zB10wPpm3tws8Fyu2mjOTgVXKnYwoQ5FWO?=
 =?us-ascii?Q?Nva0VEsNgBP+puBiag5RbILnH1TRPg5quViOF/1BP+aFTUH1LgI7lpESJc28?=
 =?us-ascii?Q?yj3Tk3SBcw6tph3I3KC0gt1Rt7vRUtRzOuG/wJZ2RuWRZ7AQaeROpN3L+vYy?=
 =?us-ascii?Q?4B/rOjEovAyuQlT5IHk3w1M8XFGzaFzKyBF36+x+PJiIDOsknYirNrn76sca?=
 =?us-ascii?Q?F/knftFMC3wp1joUCtWYkodcWKXrMIDDmAhsotezwWVPe7hF0s/CQDfWW4zM?=
 =?us-ascii?Q?IGCa7HGTiZ0F4zFFjS7aY7ln1NnQnLW2+RfXRfOco31jjBYSgFRxWQHG5LyW?=
 =?us-ascii?Q?EDY7tcCI0U48mZLrGAWNRJ99e28LyVAT4h2AgBLJSSQvLQDPQIm76Zc8sWYT?=
 =?us-ascii?Q?zU7wFe7WvlgYDM+UWqZTuXNdN9op37ymW0+MQAeQzT1Kt672K4HQ0DyHmNK3?=
 =?us-ascii?Q?ouWRjFf/S/XHf6dujHd6SZ7YgejqXx5Au6c1NyP7EgJfpM1sVol6f3y9s+CI?=
 =?us-ascii?Q?U4/PJd9y55eMrQbvyEeoMQMG9DQf60OBn7yUw55wHcBI0dRw7rM82U71CijV?=
 =?us-ascii?Q?CDEfs2Fe0doG9OXDUPjnnDcETrcijyDftA9s4gY6GTg5yGnA1SFYOCmKeN1N?=
 =?us-ascii?Q?ThxRx/hTXdx7rB6nHCkT0GAQc9CSKxONNMyqheRWEs1eWot7QgmnP0UAgkyh?=
 =?us-ascii?Q?4Oj3vkRBBDdjgWpEdBHhxEFQvrNQvFLTFkY9DSfeXGG3GSWV7l2baA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NSsQgQ1hLxalsyhbi9finK5IBnUG3J7Dmmmzk0JxFhQ1plvvhXEPncYNf0my?=
 =?us-ascii?Q?/XT6AakaxJ6b32uRzoZ4a+SPoMXh3bwW/9M78VWk9Oig/qKmuNr0uVMMqsQW?=
 =?us-ascii?Q?517eKUWI5Vi3Bn93laCUYozSu0Abo9I/mNzP1heCedB4Sac3z+Ww64m+/G/6?=
 =?us-ascii?Q?5UB9u0wYmkoQR/R8/QFys/XLdU2fnPUymIyYqC3t1vYRTZiPfH1+SzT3C/xX?=
 =?us-ascii?Q?EJf45m5lrDzvfLAgRHaBbJ4zVm6A2Rl2gP15bUkplIdV4Ffp9sLc764pwyMB?=
 =?us-ascii?Q?N1QttpsRIYFVTSheV3tcWwVJn3FP+hgvmVRbcTeUzO9HGs8/uAtPAYZr5bst?=
 =?us-ascii?Q?KI4LmeHPM7hWjddXhO08bK4Opb3qSQOzzz4QEqZrEOkL47qis9+GK577+Njv?=
 =?us-ascii?Q?icy+GJq2IWg9Ik+RDbMazjhHCQN2mVvzEN70EghWh52Hb+yaVNY0bHls2/B8?=
 =?us-ascii?Q?7gwbzXZW5O+GncTsZgPLmec89oFcx+/eLIrdRSFvDw7nQ/IfriU2Zsjv449u?=
 =?us-ascii?Q?zxQFUlzBlbEkawobPldYr4nocmJWDjwrAhjpy4U1WA2c/Zw7Z8afTW2BP8tj?=
 =?us-ascii?Q?fZ3FLrsiyQTLFp8l4IwWX7amr/vskYvEsBvv8qacY1bNz+3miiXXGEoZDylW?=
 =?us-ascii?Q?S2A3AZVDdxOt+MOQ3rGWBWSCMrgzP8qgqMS07XLmZqL5emouzECEybLsheHN?=
 =?us-ascii?Q?WsJWjOCMxoLYUjeWsDrWQkH6WERNdsANhSFTDEn36QYZIysGN1zSj6gHaWFW?=
 =?us-ascii?Q?N0QxuGhc8smq013N8DBJ76Ifxr04GKJsXE286WfWBYevMkgb7wBLcDHPyYe2?=
 =?us-ascii?Q?Iaw3hk71fg9epWtS8xMgmoIvJ+8P0QouIIpDkJikR3xIC8/j5OZetIwx9MTu?=
 =?us-ascii?Q?MEXwyO5Tj6rOuWywIXHn2yMjCmG6fWg2n/s+b5rPdAKXQ74k98OGfsIBDywU?=
 =?us-ascii?Q?9S0tWZprkllN2QzzyE+FjGX6l/Ddv1exhIUN1mmcAt24auAhfBQywZjOuAfk?=
 =?us-ascii?Q?FH8vWPrd2IUGZ1IZoK/nREMDpC2EN4Vmd48lhdryDle/owlcnAfHYbM14xjd?=
 =?us-ascii?Q?TXMJvRO53CQgOvQSEZKskLMqi0IAmb10IwIt87aKyjqhqm6GJ8aFjH+BJ9Gl?=
 =?us-ascii?Q?fj62XDYtwow/TecmNQZ1lCplFdgltLqckY7QXHiqYEAeE1GXzgvH2aRXNUnC?=
 =?us-ascii?Q?8zZbnBj+L6FO8KM7vnI3AKxpcTqJGkFkTws50XfqAjJjSoXYawYHjHDERvbk?=
 =?us-ascii?Q?hx3NqTwbuOn4azL3Ta1fQSU5O+ok1Nrn1fYM+OZ3D5HJqisvv6phj3XuQWSk?=
 =?us-ascii?Q?cvGpEFBISvPqeVC5hR7AWNggp8rYOisgrWHKyTz55JImsUtFFJ6HutaeyeFM?=
 =?us-ascii?Q?E/Rf4RxTqXRacfL+9KZVQb3Psa3Rg6i6MCHXfVhnqqi2BUHkFNznx3tmb2Dj?=
 =?us-ascii?Q?kvUt60zaniZHOqCAOrNI+/9wSdRTcjj9vwj8Q/TojIILVfQW8QslD6dKAJRZ?=
 =?us-ascii?Q?q2w8Tgv5qODt1QZIpB3jN8dSiLfDtA1pR3nB4TcJEcvUykgGK56MQ3JpUtPi?=
 =?us-ascii?Q?x+t1fZaA+g6Ifep13tW7LVUmaj4xKUFCi2LJ60wjVvecWSARFkcAje7dIBLy?=
 =?us-ascii?Q?wkjsJSiX9NLvub/LI16THot/K9LlXvU/fv1TBgcxZ4qH2vDclWDP9/uoKytf?=
 =?us-ascii?Q?43/g6SaEoVapDT8T03sEi1wPdGZuHE0bXrEjhZxcjvj6IcrO6aaNsmzEoQxV?=
 =?us-ascii?Q?1YNasdQ60pjAe0k7PEXIvzgSCaVJuiA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EOoSuKIEmOv/1i6DganVGC/WmJLf7+O+rKcpzGZ3VvcNN77H11eQzK7onm8LIgW16dZRbeJKxJAYU49Bf59aNBjOC2ZEpi0tAL9FoOIId+VKfa/DfSilOBOeVElUx93BuyJ69wmGmT1bU42guZHTDvs/lDZaJj1kNm4Bfd4HER3BqAlJpUJh64d5mWHhdNqzdv2UJMnk0+1oAwbfknbkNV1383Nk8+7PHq7oic53b6rINvwtSUiMn0iBV3nmEWpIdhYJ02vp6wu9YN7qrpyiP/Cnbihlu0ZImoBcUUi5Cj2jNHll5BFPyEf/IanJrTsfNsq2zcj7MLD9MEvaa1CWX3y49Yo9UFBbwRqCtalvg8vUAczWUdTK9E/H1SUvpVpVuW8MB/wUGBCTQOXUsTaqwjJ219jYELR6OA2aRwE5Kh9gMVqO/KAcLrCiDFmWDaixtBsAv8mXqkyvl+en1f9MY44sOGofeJjif4hqEBaR4bsIclcks1hDsiFo6TeIeehJl8aPtoot316+t2P7N3PpQ9KP2vDxdizpsAIFLSR9c+X0a0Ia8TXaw7seBaFKIxIjJYeIvuC444zHA4I6nbAKov+BuKukCAw17mu4cZssbFQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca0950e7-48c5-47fd-4d5a-08de534f2c3a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 09:27:44.3595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCxqcQ6b0WOfdC2govLE8gmbqBFvoxvrSIWtYGZuZwt18QD3OpGAfI4Z0gJKyKkQLiYdrYtWi/x2qdXsDLedJQtz6lhOkn0FZC5DZavlxU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997630
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_03,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=866 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601140075
X-Proofpoint-ORIG-GUID: Lw9HjqT6xQ8QJ_9KfpyHLN_tzG2InV17
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDA3NiBTYWx0ZWRfXzZsPreddSRgg
 UZ1v4KFPQ5xSS7ZJP9GvJh550zEBxO7Lfp/nI3O6jez5nDZnEyfRMX7lZLCarcyEyPT9ZCOXRDS
 ctMvW2u3uSSR12pi6lXttmANn3FxxB3KfbBUUtBjjRA9Zil0T89TNUm+0obSwk7+yjWM9tnUSxC
 /QYioQRcu48gFhMGm+pNVDxKOawzrHCayXFcaKFZB6UNbBYCZz9wrHKR37oiPn67FWYAiee2Dp3
 2RIY2xETynv+hYDVOUIO64eUxmwETFl1smFxm6HyPKiSToKGO+Xgq8JsBfQK/WCr9IakbE+caqm
 J8anJWI/V6Ttt+A58XPcx5HWkB6/bq395C9YoBXGl8l3D8ze1bAhRVSu7ZbtTI4+QPe+uoJRxUZ
 F4U56J75Jq4IzS4zsTuV98KXvcrCjbhqAZIiA80WcfzwNMcgYo0Q2M0NMBYFmgykV9sK//qSJO+
 nZXrZ7W45a5VXLYq1cgjOtY1qnuFc/EMhHUyNHFI=
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=69676193 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1EsaE_6oAAAA:8 a=7CQSdrXTAAAA:8 a=S6iIS8DQnDKhuzroGP8A:9
 a=CjuIK1q_8ugA:10 a=3ZumFrijQQ-2J9H5h8ct:22 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf
 awl=host:12109
X-Proofpoint-GUID: Lw9HjqT6xQ8QJ_9KfpyHLN_tzG2InV17
X-Stat-Signature: mmto8kk5kjucx9rtj11jbbhti6heqzo9
X-Rspamd-Queue-Id: 8A40940003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768382883-36858
X-HE-Meta: U2FsdGVkX1++5RweDDrpQDz1Db+sdqG2ateUrB2a5cX0qwbnFzw4UVO0SNkawlEuEt2rlZ32zUi/Z7nKnivUl9xKVvo2J8tbC2Jxcwsyct+ifpWkLYrzIobIrwata1WKGG+5Qfb3ALk91VlsIs39QPdWbFfpYh+oV8v8UrW9531LaWjQUeeI5MBxlalX+0aMYVVebAlVZOFk+mmzE9KtqhWzNl5er1pnFMwTRNlY/wzNSYM1I4eJuGpAdgpMiA8FqPEQNCqrsRYNryXPGrgUXqtUqusoeBI07OBl9lFYNAVgBXXjarLAk1OlwDdT2bI0APPyv8mDfJaFjbqYA7NLCaQuvu3NeOUHeJ1PlNqz/C/qglvehBVILLuyYKy36IbyUw+uagwfzMVjvtfD+OlT17tAsQ6iH1gtfViRA0oRd8i+LhDOejq+a7AMOXLy4L89oh2rBxxGeuuQhBKpBTCvYx6spFcg+dqIWIj9OWNl1pFB6ia3HOQBGrzZzDO4BFOLRwOG5ZRiYpj5VuXIzqeG7Slj1llHVCDgnehl0zc+R7oOAYDxcJ1m2IibdlBlA3Uc353vnlrLUxmZw/01Pbp1U8LxuIPrXbs1rnUIF+rYw6J9SNHCQV3OlSpYh6ZyQJ0eu26zkf/syfxLhZlNiaYrJQeF1CbgYuIi985bIRIwD0/Cg5lFe6PL5qpqbedswQepIsySVr+MGWNCQ5K/kZ+fHafKDGeSQMqDmvnk3rzK/CSPjsQMyYjJyB9TQMSHbXoaE5QoxYoYxWe5Qo48jqLtbg62UdWZ6gs7iGUB4GzVoAAnQndAFewrOP8fqJ4Ciw8mIoWRjzoqTWyCxXgfscu1xPG+CCNZTg2hJo5auGVPgk0QhgzTqdD5H63SHY3fHIF8znHIqdLgy5EALP8rsc8iRdZfYddU5fIVGCiqJgh8ahoxfKGEajwdLZ+gYcLNkp3HUKwR96mNipPsV4S/QTo
 SshsT+iQ
 KUEam0TAi8PuFVGCQVLUOaGtCiGg16kK0PLiyD8qdCTap/+twrLEnGTszwpV+2hStF0tMI/Svz0DqJ3dPo6vtvy0lF5RmusrnTT/H1XgR72Ym26NwfighscCXj8qNbjjLsZfzvFgrZR7qZ1e02vrEcrLOEQHFdbuieGOuJk/nFdWMdvJ0TM7QVWZlC3gbBqAtDuZTBCwQhDCeNsaLiIivHc5ngEQXHxTd2OUXY6pabMk16w+7mlyk14DZ7fVbx2P37KvpTdPanhPU5IJ4xWzpHNpbZzLQISn7TsWBmE9EC9Pn9dGz2FjvyuUxulUvGVLDQc5IkrJgNrfieSqBbzORMdaPDm1tQCzgBjiayutMJbjFUsesAHLiQi+jc/72Ou02NDUp31OSf708bvYzZa0pryHJQKGTa1dURmbq3lvfOWp8yV1huGPtwY5DZ++DefMCq1YPRPae998U1NS1XmcaRbU0iNJgwoN8tjUKYd8MXjD8YykxsBhjO70A+R8vWNgH9ML9Y1NESKedwk0kP04WWWgPM7p2coYzwkBLFHbMkTmsSA+WJI3r1FXCKcxIbRRY+xoEHJ55tcuK1THhTbVb/V1W+DwZWPp8RphznHXNvErmDwbtclabBMTl8k9Tz/VTrHdb2Cv7IoQavqtwFCL5VO93aLgqbhIPYl7JTkjiPKWgJw/gm/UJT/hdU9w0UK3iIZ5/qz48GKaTbzluzjD/aW37jC7TBuDC1OFSWPe1V2yA3AlSmCYgDUF+PHm5F02by0yTE2BC4tAA0Oc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - just to avoid confusion - this patch should be ignored, is an
accidentally sent duplicate and was already sent by a previous submitter
see [0].

Cheers, Lorenzo

On Wed, Jan 14, 2026 at 10:50:19AM +0530, Anshuman Khandual wrote:
> On 12/01/26 9:48 PM, Ben Dooks wrote:
> > Make khugepaged_collapse_control as it is not exported.
> > Fixes the following sparse warning:
> >
> > mm/khugepaged.c:829:25: warning: symbol 'khugepaged_collapse_control' was not declared. Should it be static?
> >
> > Fixes: 34d6b470ab9cf ("mm/khugepaged: add struct collapse_control")
> > Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> > ---
> >  mm/khugepaged.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 97d1b2824386..c9bd0df632bd 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -826,7 +826,7 @@ static void khugepaged_alloc_sleep(void)
> >  	remove_wait_queue(&khugepaged_wait, &wait);
> >  }
> >
> > -struct collapse_control khugepaged_collapse_control = {
> > +static struct collapse_control khugepaged_collapse_control = {
> >  	.is_khugepaged = true,
> >  };
> >
>
> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

[0]: https://lore.kernel.org/linux-mm/49229782-acf5-4e33-b317-63399deb6f6d@lucifer.local/

