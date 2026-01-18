Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA4AFD4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 12:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CF96B0005; Sun, 18 Jan 2026 07:16:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22ACA6B0089; Sun, 18 Jan 2026 07:16:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8E26B008A; Sun, 18 Jan 2026 07:16:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC1C76B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 07:16:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2249B98D4
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:16:27 +0000 (UTC)
X-FDA: 84344982414.20.6E68EF0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 49509C0003
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:16:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="JPO5h/Qa";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SgavhAsC;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768738584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAvTWFWofot8D90F51hhViibv0EWNTCRuSl5WwFIR3Y=;
	b=fAgaW+yN2XQ5hQr3kjLwf+qsSGjg3kJRsxhr8pA0mPfugh0weIXlTZwIHjWrFfyXgL8/AH
	xhyXewy5erJn47f/oxMUD3FOEDL98l7HjcBignuG3oN3F4XbOvPi5YKP72Hji8z06sqW71
	M+WltjI3lJYSh+CmM8OVD7lTjVPwrqM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="JPO5h/Qa";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SgavhAsC;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768738584; a=rsa-sha256;
	cv=pass;
	b=KCH8dB4bytx0lLuQC0/bcV1nsgUNLqV8qZWnVTAGUYs1jmg4R//KsRVqn6Y1PHwMG8c7AF
	wfKbZMivQoifEo09uoxV8XaMzSoOYUgEZe6WyeO7uIe9uqoqQTYw8edocYfdBjAPasV37f
	yVJLWj9nrNxOr7K7mbHRqoPrTe8mCD0=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IAsOhS3246250;
	Sun, 18 Jan 2026 12:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JAvTWFWofot8D90F51
	hhViibv0EWNTCRuSl5WwFIR3Y=; b=JPO5h/Qa3wJVktGwPBfQoehxmKBMcDR59I
	YpXf11i3YT0nPPh6lsE+dkl+/M4o74xcfPfXrsC+ZtmF7m7DULzfMLYaz3GQ6q9O
	In9w2HX7cOQ+1bw5r+8Ry2DQQburBH/PmuFpNyVJCBmF0ergCuYeplA58lAfNkhO
	gx3R8XmszZ4R7DOjXVXGHAfsyAWMiC55CwkawL1MSsP0Zh3KUDaeifHGl5be98fw
	iRTZq8d227zOfBfSJBBcTr+d5o7N5xjqMTIv2ntJcB2+XM4dLAHxucgWco8d72Qe
	acvVnW2p3M/EhyUevlC0lPK3fhu3M8v8iJL0mPzLeT7rGeZ1E0Xw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1709arj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 12:16:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60IAPAFB040549;
	Sun, 18 Jan 2026 12:16:17 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011033.outbound.protection.outlook.com [40.107.208.33])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vb56r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 12:16:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g9L28mUodaHw0+3oXGxScJU1PtNwGDIp6YBNj9rIFNPDOJ7mkQbcpxRdraZWGaclZYklGDqFWfrM23S6CH+hHLjbXY3b4Rq6rnqSVh3By/JlPiDzcqvXDhu5tLdTcjDb/BXJNWxiq6msXWzcJKxxrKzYHWgqTi0VdBdw0V8sAVwB2xJlJ9Q2rLPaPikC56PNsyRZO8ZgppfYuJwFDqzedpGyHYclzyH/2tVL/s+pIm51qrsF4c5vg0RfSMN0bmczLo3Hbfh7IDb7m91CG7V8qByW73b3S3PEnl5dBbBHDl7DI3HnRoVQmapQY4X7WuGewQPQfhEt/jeKckWV9vahRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAvTWFWofot8D90F51hhViibv0EWNTCRuSl5WwFIR3Y=;
 b=y+f6h2A1oiibmeP4KMPQaAkH5rXIKsSa5koNAwjV+Dqxg4OBuf10cjyhUTSNk+DT0kYMMAh1wy5aK05xt0TS/mmTwFSk0jYWAKUqQTW/S3vGFn/Q00qPtPK6+lHQOo1OjGHNf8nwo7lr/vyw0QaUo1I7SOv7YGeBdzzkq8u3+44bmjuapSvSIsrFBF7qM8owrr9UuOhOPEfkSqOh6jVjIjGgTCd0sZpwThyFT1CHVE6rIDBMVKnusjYrFUocOAMbkv0CkfqXkbL/F9D8NH0BDwwlz1iRZ//5G1XlIM9Zh54BsV5kNQf0/qpbKx6VU0t53GVrHaINsNfNFFvpkqtTow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAvTWFWofot8D90F51hhViibv0EWNTCRuSl5WwFIR3Y=;
 b=SgavhAsC6oD2d5xyTL7ster3APwAszwwQgBmbV6DCa5SSN2XG6cZ2TMJ1jvL3uqJA9a5bCUp55XWnc5Xf5wSnjXxLuk396myK6+o05uSrtETupJ237GFkArD6N+4alnRwqshDlzf1lEGFM47DiSyhHUfnNQslrhSenLznRTCkhU=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB7470.namprd10.prod.outlook.com (2603:10b6:208:453::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.10; Sun, 18 Jan
 2026 12:16:14 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 12:16:14 +0000
Date: Sun, 18 Jan 2026 12:16:17 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: syzbot <syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
        harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, riel@surriel.com, syzkaller-bugs@googlegroups.com,
        vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in unlink_anon_vmas (2)
Message-ID: <711fc4a9-690f-4e82-a997-3b16cbd882ac@lucifer.local>
References: <696c8c10.050a0220.3390f1.001a.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <696c8c10.050a0220.3390f1.001a.GAE@google.com>
X-ClientProxiedBy: LO4P265CA0216.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::8) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: 2237d056-ed81-4a75-8192-08de568b5fb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7142099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?flahd6r6bZjC947SSJ5cJtqzlrvaKFR6vkUzAaYz2pJjLsobhJF4qXtkhjKJ?=
 =?us-ascii?Q?pd1KsCN5Mluq08+wbDP80GUKosHAAuj/65ZaPIt+aSOo18mr4tQhXNr6zQIO?=
 =?us-ascii?Q?khdmx4uvSzUdLqLey7bVQVlwVXVX3A/zbOUnr130FpwPkboMeePyg2Qd9ydf?=
 =?us-ascii?Q?DEPCyIE8+E2IIxrG3y0rilwVsi+laoeNaYddfHvrKqBZAOUz4RavSq6nz+lw?=
 =?us-ascii?Q?KXGgt9h0aWYCnsA0MqdAU9CTAFGw4C4sVSlzMlb8dIkNNbOL1SBpUW2ZkYNH?=
 =?us-ascii?Q?m6XxK9JtRFbyjqZYOW0LIq+6TPvo+y4kvdz3xOaQLy1mAFq9evM7gm3NkQ8/?=
 =?us-ascii?Q?bYtnGjWZU9UBryo8Mj1zMborqgR6tv9zpKXg6PYOdXXhqxQbnG5kIf09IOMt?=
 =?us-ascii?Q?UAxm1jAwgt2e0VooVFilXuRCTkXnTZua5R6tVT+Pj3Ip4fL0prAb1+hCWN1t?=
 =?us-ascii?Q?sK7XFcaNkRe2TYRygXNLEz6+6l3MOBCfCpD6g/njPWVyHI2FGn2Nd0O7NRwR?=
 =?us-ascii?Q?aeABT1YQmVqzC+mYo+BcykpVdB+sSMgMHqWwxx1LvAAfq0b7abcb3jDrCSp3?=
 =?us-ascii?Q?EMQ+pzdoNLNOlCt5BeEXV6QrhU4w5FHcAOz3UfAQeQgqZyUHL5/zESvvyDld?=
 =?us-ascii?Q?OrvnL4gCnwkCU0SN73AjZWdF2NAYMLjx3Gx8sDRvBGLreFCoU5Opxcu83TBO?=
 =?us-ascii?Q?GmavJsdPLeDfaKo6qWCMB9V2prDtnEoZ4RHvZWudgKLtjfxFCAEq4nMgvXMa?=
 =?us-ascii?Q?AtjLh7fzm/3SJODTf4yNo/tPe7xPefLpC4w3T6W3pNthqYRnQoI3gUe4NtO8?=
 =?us-ascii?Q?Vm8tho8GnSg6QwS4U5ml4LOlQSDE4G5+Xgkt66KDorZ+yugwUZsvfXYOuWaR?=
 =?us-ascii?Q?9QDAYHbenuxh39ta96YTolQppg0vchlKfWT7o6u3IcscYD7nYHBYPI9Yydhs?=
 =?us-ascii?Q?TWaUogJYsoGBkdqMVq/0eRkklfifDb0whM1x+9x4pnepjYa7MDGnQ+XApd6v?=
 =?us-ascii?Q?0J5NgYYQoTHDiVe/suWgGn4nfVLVQAXhTlW5BxIypLCGMAj3ntXeyq2lbIYZ?=
 =?us-ascii?Q?WddIJLQ7fC/x5G8xJYChnOg838iqKAm/+rz/rVb3GTv00fFcMsAMxMMDlKpb?=
 =?us-ascii?Q?iGzn3PMkn9MN4dn9F8/BkCtjTBc0iS6ssrYhAUw3OnhXngGVu0FurA3e1Fyk?=
 =?us-ascii?Q?SiuZc1z89XHTDtJuYdnWvCuVLpX+CtDm2tzjziPXf+8N5UwCiEn0lVm8dEIV?=
 =?us-ascii?Q?gGZg8y1BDFZeKuihm2hx9oQtVHZ8YliU1hMR5+d1sLMobS2ID5gDlVLZP8uZ?=
 =?us-ascii?Q?drBNAc3ENl0Peu27QzedjxJHqCjD/+k/Oz4VozgDkNPoIoAW0HMAmNNUWekc?=
 =?us-ascii?Q?ccVV6eBvCRObAQNiPtNgg9PxduWG8DCJryfmf2brEGJbq3fcT9HGbR8041hS?=
 =?us-ascii?Q?NA5mlAlEdCbOwxLkoD7yOuyYK5XsIUeos1fNBMoCCLGO6q8Xs3TZD3AgAQaj?=
 =?us-ascii?Q?PPuHirXG6Rly0j9QiIcaYXBA+ANqUVuirzpU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7142099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W7rTfBpzo59yyT6Undix8bBFfMwGdXWdecBrU4PIYAjqGfT/Hp0jtpqPt9Ei?=
 =?us-ascii?Q?gegSbT1fr497/8vYCPQFDAqbDZuwfK6eux61eS3v38GlNuaWEUmW3zpIwpt+?=
 =?us-ascii?Q?Nqx+ieA+n6iRdzbUcvfRVxOS4nhHXj0GOAKGt5ROeSIJ/MpX3sfSR+Sdo2H/?=
 =?us-ascii?Q?WsSyJ22QJn7JyyXq+Bw3Xzo8cKK1R69QTMSLnlcjgX4oZbFDffsmFYH7e17X?=
 =?us-ascii?Q?XmkqCGREFVFxYyWaLN2HyD9/8uuYOasfpslZzKh8CRTNiDQU+7aKuvrnyRXE?=
 =?us-ascii?Q?ohHQD9ntoYY8/HcH8dXIpUAAXBdeUyaxe7hj11w3Co/HPhDQeaMPM06VlW9J?=
 =?us-ascii?Q?ueA7zcr4gtkv19h6dabrraB+5ekYG8z2ptJfwchT0KiuEHcztDX4JV9YoJNl?=
 =?us-ascii?Q?PGjGJ+ugKL8Y6lEn8hI5neldlroHeCN5sjCnwqAzDa0K7opVmHu3qJ29DFxK?=
 =?us-ascii?Q?vVmZnivl3Qag5pOKwh+nqkHofVAjfFODD+0ju0YJ1F71GJXV3nY5KXBpgDBI?=
 =?us-ascii?Q?7GlgE4tkcIYgVQEqHhbaf7M0P9bBJdTSAbfFVqBquCbLku1Jz2i4xxhuewqg?=
 =?us-ascii?Q?qMM8r6EQQw9MyNZtV7XhVCKn3O0TY0pOxk8DghMtVWHeiJANffFoHAtJ1dDx?=
 =?us-ascii?Q?jTpg1YS7df9tBQVl0/ae8aPtVQmLcgUAUYv7Yg8lk+c+gUO8TaCfDIeKQZ7G?=
 =?us-ascii?Q?YHQseUUrXzbq7DGREaYxHqnzYE9Cbp2yTxl3SGtZ59NNSnb9qQZHf55gfFvY?=
 =?us-ascii?Q?FN8gd/5P2p3CkTl6hYqrCDA0U4QsPKzz50MI4SGND180e1BIGkUpX3RRBhmZ?=
 =?us-ascii?Q?tmcuquTNuNuVX+AoPl/2AeUyGTyGJ5dMpjD7nvpmmo5BxrG/9FURFAYb8kdO?=
 =?us-ascii?Q?sFig14COi1WffxYMkiocxCBJXkHTlzLXKtYWspaeSii19NkI+GPRO6qjvI1U?=
 =?us-ascii?Q?6fdTKmccEOoSS07luAm/r7z0Y8r7J6QzBrwj4vbUJvVGyLHVwCCVHMvZ9wxB?=
 =?us-ascii?Q?/afmSLlZtkv3dtgAQj3EFR8w0eZviruOhhS1lszWmolMtH3NWuvmXwYYbptJ?=
 =?us-ascii?Q?/lHGOn+FWQhk9qqTGQmp3WXLPjxedjJzKtW2YkgDQn1/3Ant2HrmgJq/sJIZ?=
 =?us-ascii?Q?pZV1dDa3oKqbeD10EwqjOp7lGKajKtFHgfAbOoMg6NY1jIqp9hqYfQdRFXyH?=
 =?us-ascii?Q?ycwDvyWGxG1Cvrl3ArphGWyEn3fMN/9tmSXNHaGtwbxsKZyPoAPY1hvVerAL?=
 =?us-ascii?Q?lpfz6mzH1ThW+MR0R9WS+TqoqhkfSyanqE8G/codnJ8bSiV9FgO3uov5vKC2?=
 =?us-ascii?Q?5Npj0LmQvtt/NYR0JlyuwOgo44SPgvGTA1iH9WOzbmMHJXY/OIde1MHmy8e7?=
 =?us-ascii?Q?qYHgJMwWLpapgcL1GBuZx5bewM0pwZmj1cXmEOspu1EnWHmDjX01gutiIo7O?=
 =?us-ascii?Q?6TCsTb8Cu2Cr3P2riv9IjKZccWcvOADqKHmVrGxSeQMACl6RoApgQY4XtiLo?=
 =?us-ascii?Q?frCYvowiMASYLaOY17BnDgaK83oNTuY/eJlSEq5dm3Vxj3OAeojDHiTA0LYX?=
 =?us-ascii?Q?fylmLD+YHD2+HMWi148VJRi/Xms/iDQpzANwXsxEEBOVP6RajlkMwEdpdEOx?=
 =?us-ascii?Q?0sSbQWmzJoGw3uvK8ny6zMcFYZ2I95r4il8iMF9N8UC8U6756R9ThllLsvkb?=
 =?us-ascii?Q?r7uXFd91ViDEDxDRt2x6oKdTKJFlLRG9jUDOLXTRqIQwWQx9x99M4aPL6Ezo?=
 =?us-ascii?Q?bHXDKnsTLiRlzP3ixDtWbk4UnPHYdaA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nFKsAGPGpjeCvLiE8Oj2ZNQs7Fk62MNzo3NZA2kB/qH88vgodmmwWAW1seXh79BLsm0YMqeq6IUPkaH4WZxlKaVvb47JAf/n2pC4IZcpekrC9tDvRVCSnlutEWzgWZmzXgcBtpYqbjlkVXt18beylJtDjFJWv3O4540hh75ta/sEXBJSxFGZilFdQuWKtM+RZYnmnxXkamaf1P5y+uDbxUQMaT5ZfbhVK0RVFYqvH2wujWZsnlIksedipSS0pOjs2zXC28qFXppbfaYWe2h7b53gGLD4AOaIDdPxgERd6/NKPrHl1C9J/Ptt9d47BUvfrhAoCNhA9Z4i/ewGAXWaJEyjZUSe7UGncF0nPod55SVOgns2pdhG5xSdeNGT1H1YaODOkEQ6iTXwL76ACHnhGs1XqAt2TkYOAScl3V9M7ABZTNSqAD2W7mL/9ME7uSCSlxxP37LJgY7K/1SQIR4ho96LEdjBtWe9h6PA4rWWYzBgbhPNIgUvyVjsvM2wWb+DLW/VmcwxUDRDhN2kaVzBLNRe3+cPUepjDIZfAso67y0fXtvslf/lL3uWBWju/cm5bxmTzR1oPtn9PVTQs8CBZ110//lWQ360MnlypMLzdqg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2237d056-ed81-4a75-8192-08de568b5fb1
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 12:16:14.0524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tg1NA0EyNnC0AVKA+VzgY/1AdXmSHU5FHN8QxHVAzd3XrKJMQJe3sItss4EAB4TyJMB1ZC/O/WY8jI8HnKwX+m6W7uzfnGKjevnlx+cECPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180107
X-Proofpoint-ORIG-GUID: KtrpYw6W8kosk3jKitKjyd8gLGxxVaHR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEwOCBTYWx0ZWRfX/L3JMr6SS25t
 rfQpWRY2hwyj83mUmo3Db0icA29LBeIzzi4UR3X90Uhan8y9a2N9aSdt4y9hPZQryydX5Zh64t0
 bVMnw2YfgCKnUt8KOHWbWeXc6SeUVWZrIv9T2ce7xcrHxD3puWFpkpe0zE3x7jAd395/K3a5XZh
 ORtEiKj1iRlWX7nOF8sRIR13y3GIU0rF4zch59MfjZ+KEd0KVl6AWwHmjvVteyJQhUQpqDjCh9P
 iHTPLv8pUGFFhqFxIqQolNeOFg5XLersD18ia3YVPStQGtBxho0fUuUiD1Ot1dmz0F7AcapEurD
 rq6aXTj3IFJqcejMMg+A5d1cJZ5oebLkv5FzEL3oOWRkkGvYdzJVbaagCOYavmLmMaft9irxRsz
 qn6VQF1m2aC1qt5fYuvt2clI6G/a+7V/baIZDZbedEJsLT3kLMNX5KSc3sBigVk8uWIOaHwrs5B
 AuZwtLP/RXSbeYFkg1vemjHpXYSIHZgCFK0Sd3b0=
X-Proofpoint-GUID: KtrpYw6W8kosk3jKitKjyd8gLGxxVaHR
X-Authority-Analysis: v=2.4 cv=FvoIPmrq c=1 sm=1 tr=0 ts=696ccf12 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8 a=oHvirCaBAAAA:8 a=hSkVLCK3AAAA:8
 a=4RBUngkUAAAA:8 a=QmGNgy80h9-L8dam_soA:9 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19
 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22
 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22 a=_sbA2Q-Kp09kWB8D3iXc:22
 cc=ntf awl=host:12110
X-Rspamd-Queue-Id: 49509C0003
X-Stat-Signature: fp9ykaosntynue7k66grkju1rcqd1rzt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768738584-548718
X-HE-Meta: U2FsdGVkX1/WGDdGgjxQ6aopzqhk5iEDnX2/QE3l1wkLdqp0kcFUkDTJ4j8S6Y418o2v5PCDgXaTfhbGfepLGsDH0pa6q3A8dMebOQ1LfTezqiBK8G/tysfTQ0k8hOXb0iV9m7Skq1rebmXllCrga5vyOQo7nt3aHAkVKxggg9p8kcR85D36YnbcBIrjgNZBPVwWx0IWrQe6Rt2jVg0f9L6CxjOzBTYcAOK62WQFJwsDH+rE3iZdN6YHRyOCxPChziGWPbJI3CsDgVmhI/6u7CY3YfhxFRMgPhpk4/VIq4n6ElGtcaYYPNmtd5xslDg6qUM1Q2gm6SI0vvJWnBaJyg/vkM8IByA2AxVsArLITpKMAE9x2ct1Uq0673vM0Ysm5wNr0JdLhMaaoMnDLIn5ASyTinxl1ORvNSb3x4DZoztYusywrdJ9Xl2vJQim78mZiAG3Bl7R9XAbwoIDW5Mb9hvpbGqNCxiQKJTkIOl5+iHdSOhxcx2uAkUNh8H1yUCTZeA8Q0h5SUF7i+uq6M1moV2gAGKpKAqBEt9jC/KX2R1vyqDDblASkDJbN+7+PeC8t908AFE/0aCMgBoryxlq8OTNRDdkTkyBFjomGqTC61T7N09beN+K3L8kgSPdiVCKopSOY61pDffEhGIGmRbpxyAyzKu3xPSh0rJVkvxvg2kmAyOc/oXHQrcswr2cKPmTlc7JzHQXfwhLg/bZvTwxz8b01kQZf3qJf/6Ckh7Ajj9Wo01wzR6f0vkhAIRiB59zj+TO9Dgm5piqptyAx75ebmQ7fYRTwYV0i64wtT0tbFywKlRfFNoeeA+C8ajpVbjD9PFhQbtA1bLUptl7TUXx/vlT5nVISnltztxmv++CCgqBbw1FwA2C0nHZvcFsY9qmvSppFwC/x8E5/p9jIv4k0ZazCfNqAURv8aPpnwr+BM0nWaVAjUJNJwZ9kJqgpMOUW+TYU93VZ1XSkk/rN59
 e7rz9SdD
 yBPnjE6IKf1/5ra2bcqjOf8WGE266m7BdB0glC7v1wFNdRs/FP/VNsKzt8BU9TwqArSJ2/kbKe+IgBhtUjY+JEsh0QyAOndn194lYMAbIgHKtwV29ULN7J+V7MWfvVIF6HQ0LRGSUP5XRu7FfmoFyVoR68TZtKpOMkvIEp4gIoRlq/odi9WPkmDZp4rg6Jh5qyAR15g/8Sh8INWKn83wzDxYWWJNZGTh3SkOCbkm3ihxlZP0ERBelg5G5MXQhyXHvzJK+5tyfa3KEG6xqL1KRLfosrLdA1wO/kN4A+aQ78JizkSCqbDB3lZW//6LLp2n/YaYE4L9gugaVwXAX2CyuPkSRHiZDz0QrnfzKPziQg/pu/h6EtUd7bZJs126MiSEm02gF3Ezvl7HfXUXp0ICRwTcDMUG/QXtfqtsUp5NlfnwQ5twTW/KkMYyZ7DEzQ/WSeTM5jytvvv9RGGJsS1xZ0lVVuvPFUGq+yIFjZvPLNUv39R9lSk6SQaWnUX1CGDfuF7KlrdUCWA+/9dXico24qWARKYvJmixcn5BolfmIoRGyKiL9e9BfheBY0QapWYkJVac7Q2WkPWgJN8xitcv0qEBhiGdS9nkrZOyPWbrPNisObfl0SQOj/HWgFnly5hHkeVI9R144U4blMkuyKx319D2Sq7JmegP9SMefgkekBi/Nj7SrjsRDyoKfErIMZK+07INewMF8dwVMupyOsLW8KHVaYvDrOrgh6cFXqz8RGZsYY180ohyHgzh7sqPqYLJe7N/xL7ULWkEctEtIhq+R/7Ez+mqsv57U9Zzt571iPbVQ7c5Gkx9WzRj4HyeC+OOwYLtB/hSjwRCqcW8c9o65i85JCwUUHY60jBguVcQpAX0AZaxzhF4jwJILprRkb8mA8p0yItmGnZQN5zrsr1MmL/LT+uMU+sHJUN2kLWruYrttZIbs9JSHtVvVpZaIX3gkcYcE3Ib/QkukhBnTSJVaXFXQL5Cu
 QkLwzn3s
 OB9caPYaY5Vt9+Savdg0tRrXBA4ScXysXX/JJiLBXsWaLaw5WE2zyahUl7auL05ClfxOf1zjOfUlLAkV4AqQN7nKagPmoLwbuA5aSu37+j3ACBd6L0cQLOP95KKRgbgZRVFuLmHTgVhSm1LdMrRHwq76INXGy+OdN/uiTdr2Utcu7O82aNx8X2ZsDnPIlf8KYYNamI23IfJhizfjQwuNSaja8yeWXMa5lDpCJWY7cg7aduYyR9+x0dK3aYuJlGuXbCvLHFHoyiKFDaA6ehfLMtjRQEc5GghAJQFpqPSegDPgtNYS5rAnpdIrowh0Tr6u069BFiFGYDch52haOGDQMNrvfn3XKItY6zL1ZGHXiVJQIM2Qx2uc2Fn6zHQDOWczStYlcgrPrnA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 11:30:24PM -0800, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    b775e489bec7 Add linux-next specific files for 20260114
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15dbc444580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2dcf53f0a51185
> dashboard link: https://syzkaller.appspot.com/bug?extid=c27fa543e10a45d4e149
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17070522580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1683f99a580000

Thanks, of course being a fault injection thing it's hard to repro :))

>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/5e077e7eafdc/disk-b775e489.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ea69aef6ee56/vmlinux-b775e489.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b8b6986280d1/bzImage-b775e489.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
>
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
> R13: 00007f16655e5fa0 R14: 00007f16655e5fa0 R15: 0000000000000002
>  </TASK>
> ------------[ cut here ]------------
> WARNING: mm/rmap.c:480 at unlink_anon_vmas+0x701/0x730 mm/rmap.c:480, CPU#0: syz.0.20/5987
> Modules linked in:
> CPU: 0 UID: 0 PID: 5987 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> RIP: 0010:unlink_anon_vmas+0x701/0x730 mm/rmap.c:480
> Code: ac ff 48 83 c4 40 5b 41 5c 41 5d 41 5e 41 5f 5d e9 84 df 56 09 cc e8 8e ed ac ff 90 0f 0b 90 e9 e2 f9 ff ff e8 80 ed ac ff 90 <0f> 0b 90 eb d3 48 c7 c1 10 ab c4 8f 80 e1 07 80 c1 03 38 c1 0f 8c
> RSP: 0018:ffffc900033676c0 EFLAGS: 00010293
> RAX: ffffffff821460b0 RBX: dffffc0000000000 RCX: ffff88802a773c80
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffffffff8fc47af7 R09: 1ffffffff1f88f5e
> R10: dffffc0000000000 R11: fffffbfff1f88f5f R12: 1ffff110062fbaa8
> R13: ffff888027aad900 R14: ffff8880317dd510 R15: ffff8880317dd530
> FS:  0000555592787500(0000) GS:ffff8881259ad000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f166526615a CR3: 000000002f0cc000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>

Yup this is a nasty additional and impossible-to-hit-in-practice case the
series didn't account for, this time in anon_vma_fork().

Very annoyingly, it violates assumptions made because we try to free up a
partially set up anon_vma.

I'll rework my series + respin to account for this.

Cheers, Lorenzo

>  anon_vma_fork+0x4b9/0x500 mm/rmap.c:438
>  dup_mmap+0x954/0x1b80 mm/mmap.c:1790
>  dup_mm kernel/fork.c:1529 [inline]
>  copy_mm+0x13c/0x4b0 kernel/fork.c:1581
>  copy_process+0x1812/0x3ba0 kernel/fork.c:2218
>  kernel_clone+0x21e/0x820 kernel/fork.c:2648
>  __do_sys_clone3 kernel/fork.c:2950 [inline]
>  __se_sys_clone3+0x256/0x2d0 kernel/fork.c:2929
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f166538f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe55f4df08 EFLAGS: 00000246 ORIG_RAX: 00000000000001b3
> RAX: ffffffffffffffda RBX: 0000000000000058 RCX: 00007f166538f749
> RDX: 00007ffe55f4df20 RSI: 0000000000000058 RDI: 00007ffe55f4df20
> RBP: 00007ffe55f4e090 R08: 0000000000000000 R09: 0000000000000058
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
> R13: 00007f16655e5fa0 R14: 00007f16655e5fa0 R15: 0000000000000002
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

