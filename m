Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1329DCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 19:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B116B009C; Tue, 19 Aug 2025 15:14:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802CC6B009D; Tue, 19 Aug 2025 15:14:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA946B00A0; Tue, 19 Aug 2025 15:14:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 58EAC6B009C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:14:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01AE7C01F1
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:14:35 +0000 (UTC)
X-FDA: 83794458552.21.FB29BF9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 93F44100006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:14:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Jk0fRNJz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pEfh7L2c;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755630872; a=rsa-sha256;
	cv=pass;
	b=fsQXnwVdMFm64LQacwS2fnMZUK2RZTAs/ZXoyzUTt2Bfrmtmbc/1Gb+X49qqpK91c2uzGG
	0fSHdAMzzoR2AMbYdm0GIETrshUYoBxdI7mupIx7aNCRzPXJNajSY0LSCjBK2n2es2yDjM
	Q/5Xi6bwlh6x3fa4RvSBHAYsDzz2WiY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Jk0fRNJz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pEfh7L2c;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755630872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6FXS19PollwiQ5JBtZm4Vis+Ohtij0EvIj2pYv/N7Y=;
	b=BOWb204J/OADduMzoM7BEq87a8QOtHqug0R4U5XhSH7SQ/qeXLvd/CKQkwmM34iSdhbPIy
	ZJ9veavrz+lWWqoz4/oXhKXbnhbiX5BzrMlRA2OYqhwqHqWU8Ao6h3kCM7/NUphz44rKSO
	G78dJoWFFoubI6xVtDo3TEsJpkxeoSA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JIC6tt018360;
	Tue, 19 Aug 2025 19:14:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=a6FXS19PollwiQ5JBt
	Zm4Vis+Ohtij0EvIj2pYv/N7Y=; b=Jk0fRNJzm8Yc7WV9wTG0pjOCJttKNb4mdR
	JwVeKlAGylOe9mTI2UmP59CvdU97JTIFaE+GfwC9dcMNgv4lbK4h44Ct5wPaWOdp
	vGFQR/Pe/j39pmrInSYp6ZhODPpn1o1NzWQWJHbxUuKUpSH/xcsujuNHEPWzPLwV
	+fOBRWfdTrFozBMBCAmWtMZfKhuzPrR77ECRBGBK5TWynEe38OAk0Ug/cOkrnJk6
	OcsnkU9OFoG4I7ySaZfnE6UZh/r9ITRWGxJEskH5ckxwFAgLPpnu4K3IwDNmFZJB
	2vDlrSVeIdksYtv1WldsdNUt83o21Tass7jF2vIof1cZahcsLXCw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jhkux1d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 19:14:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JJ4GM3030250;
	Tue, 19 Aug 2025 19:14:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3t0b74-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 19:14:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Af3Yyikww0bdg/N9jxQbD5e/irUAT7qAmtDA5ZLUwEg7KTi6FEhLZh+6j2l3y3ZIesTvz7lZVi7WYXH8FmBv89fS+uBkNqe3xWriu7D8HbJ1/7PtHOoRo2bGIi/MekxHMTc14Tax6rMVxxdTrx5PhjVuSpfDZz2+muWRtYSwxNpLWVK2t7gMn+ov74VLgYfaojiFwia7PAtH5KfDEWLiGOu4ye2w+cTynpndCWjY8rJ3ywrZSUcVvLLSAJUu22xNLOpwFKGgTtzQ+Up5yHc7TZ5fB2JuVrYrQUzZ7UPH23HykF0P4JtJZqF2AVqDLntbbmOPLAG9KuhSXC87Fin2Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6FXS19PollwiQ5JBtZm4Vis+Ohtij0EvIj2pYv/N7Y=;
 b=GeeacFu3unnCewWkmZ4zktKX7RaY06MKN8rRGIRAYwZ2NrZdY1qpc7NAtKhVNdf8H0VuujoPNhuXz9P/sZnTlDkfnB3IjXqcoYmxC2Udub/FhkLy/Q5bM5DvOAVGUA7Ekb3YB5E9Uju5u/iNkBsHWFuqqFfr8H/TYB5eVsKLwqCsMU30402mXtSDMWvRbXdQwkg0qMqTySdnWpcvFKRhhj+j8Age9lq7mrM3VFKHYVR+25qylkqpUcCSz06YY9aDPzAuRJfvXadmIYUESW0ku6+01cA/rNlv9joiqSj5X9F9MUyXMsvyoGWbrdXJVQYdrFgpeMrq8dIULqUBoC2RKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6FXS19PollwiQ5JBtZm4Vis+Ohtij0EvIj2pYv/N7Y=;
 b=pEfh7L2c3bc1fHpbFOTwIp0LpQ4UzBDHzK1LWnQGDSExjI41ZQcPFFw7aR/3i3qJSr3Fg/O24O1F85SFQAjZDlBzpen3+bGaWqw96i/EScNZ10tnaz9WueGxA8l1JSTugimAbVl0Z/8BAgxJRZ7mbXYRuSosTOo+able4vIv0eg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6945.namprd10.prod.outlook.com (2603:10b6:8:143::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.21; Tue, 19 Aug
 2025 19:14:11 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Tue, 19 Aug 2025
 19:14:11 +0000
Date: Tue, 19 Aug 2025 20:14:08 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 4/6] mm/memory: Add tree limit to free_pgtables()
Message-ID: <39c46a52-f63a-4f3d-a276-6f59c55680ba@lucifer.local>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-5-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815191031.3769540-5-Liam.Howlett@oracle.com>
X-ClientProxiedBy: GVX0EPF00014AFB.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::30d) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6945:EE_
X-MS-Office365-Filtering-Correlation-Id: eff32565-6c93-4039-dc13-08dddf549453
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CoflwyZcT96FrlPNkHmZvkFn+dsGvsglvgsc61g9I4P5nIoHg5ukc/tYpQki?=
 =?us-ascii?Q?WL443+VMHK0vbYJ+ugOr/Dl1vQjfCqFqm11sIZ+rRpQaBNQMndX0rTMdhgI2?=
 =?us-ascii?Q?1L6dYS10cp3+r2zLQmcLS90liyB6aivHGA/+oNj+xTFyY7gZTc6SX54HrA+1?=
 =?us-ascii?Q?RiqLA2iQ93d9IzKF/nOTJ1qrFe+TxhS5vjdYAuce1DyA8KeDB+yX/tzXoNrM?=
 =?us-ascii?Q?eeiBJ0UKLMuvOD3ps4tciEAqxTpkeAcbLWcgNPZ7gBQBTv2eQpgqZeU6RcQa?=
 =?us-ascii?Q?YPHlruRDBeEZE55G0kIdPsocokzR2tJfTb+0mjHPq+6yCyUp8Wl0ifERWuXP?=
 =?us-ascii?Q?hxEF9IvtC68C+n8erQNMyie9BRdMn4nsgNb7qhN4vuuspY2lp8ImS9Ir1oPg?=
 =?us-ascii?Q?CGTLVFxMUHXHqlQp0g4XsmAJMRtjXaxV/rxTVz8TfyPGCa5gTyyFCWR3MYKZ?=
 =?us-ascii?Q?s88Y4MsNFuSyE5zInFka1gqaqzPqUhO/M1tfJ//xUjK/LSao7FuIZ63dbpN0?=
 =?us-ascii?Q?dB5orsgPKYdeuCc95lMMWlta2e8FQFw5HcOGXb1Qw9Bfa8F+oXPsg4RR0OLO?=
 =?us-ascii?Q?DKnHX6UT65ejqmr94Ihnazw27NkCUn+f+Yy1iFA07Z01kfoNtnWkDfLpvsYp?=
 =?us-ascii?Q?8jBPyI2QlcegnHMzqTl76qdhrVJ3IuVL1rGd3eMvIq0ARpDfsC7XilmuMgoM?=
 =?us-ascii?Q?bnQ0n9+a1EMMcIp2HNZBZjP3eO3DdsA5L/nehpA4tgUrRJqsThKa1VhPgNF6?=
 =?us-ascii?Q?FWYQIey/XDZtazg7mNPgHTaqGxYi6ipSbXtdY0LfXZBgxWwrEEnp74MT3MGC?=
 =?us-ascii?Q?2PZtmFg8jQYiRiNxtcXLzrRMn9mepejVTAnOT4XDCAjGBGMCcvBKVy8JZCP9?=
 =?us-ascii?Q?UooGHOVFH4afFh/G0nQsjdsNoMpAoDkPJqIsXxfkUtflLW10y5lLp77PmDo0?=
 =?us-ascii?Q?YwtU6BBCAgXxtqOUH+HMyYvAlxRAaciNfbFDCqVpne0MmqNkVDFMC1WmOQGh?=
 =?us-ascii?Q?Q+z48j8/VyLH8R+NDRBJbuhY41SlFc8+FmwGZMopGD7/BVfwpOsT22N1ZXag?=
 =?us-ascii?Q?HJGGGZHd2rFyFaVUN1mRSdwZDQTLu/DqYFshzQFbWMMMfoDEfnSGeT+bIqYb?=
 =?us-ascii?Q?AwIjCM1doCkzC0nHWfMmoFj1ru2qvKSg1QmKz1+TAPm4OZi5txD5fgIJbFyG?=
 =?us-ascii?Q?n0pTxKfDThskhqM/PZATB6RWltmbFFLTqI8ZCcmKLtvL7d0Q9vl7Kxm3cUXK?=
 =?us-ascii?Q?mpgfCA+EaD8oCq0lCVFu4LVth54nHcLcICfqFqyx4OeeYr2IWH/QVfL2Tdxe?=
 =?us-ascii?Q?ap8g4CSlk/uQITyTJg4roaWa3HKb7fjD64reus9cjscwS82aUT39/ojiHRfq?=
 =?us-ascii?Q?C6xAmi7vEcQ8KuM2dVdWAter62k3vzSC5u0crGj5xdHnutTtwkxDwxHgTUlU?=
 =?us-ascii?Q?qfft1aUaM80=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QZxiOmmxwaicHJbhW2Ql6PQfOt7WG4UTxg7kLO6BhIp9F0TRW02dzXpCPv4D?=
 =?us-ascii?Q?74RHsQwUPDiB4br45HaMkrphmQPYv11PTHrEMOb5uW99QPwj7yFK2ZYSwVIJ?=
 =?us-ascii?Q?dcKdTc6x/BLDHs3eXlE2TGcUAICu3V/h80/UkSgx+/sF2KDgIER01bmMfUlS?=
 =?us-ascii?Q?v/BENuLKyKe1dL2eY9rvvKyVKuUc6Yk/K0PyrDBFqtjFsn9BJjtCGVZGBt+y?=
 =?us-ascii?Q?YjW0c+O7KrBsEgHsrbOlL002U6Nf8OTjTpPL7VGUoR+79x2vfQAgxaZ14le5?=
 =?us-ascii?Q?X/0LWKiXXqfx+q6Ui9zixbGLosoFLCNgLRJAf0AgFZj3uCW28SvDAbc4An68?=
 =?us-ascii?Q?DR1Q2nlNZx+H7xq5lMOJq5sto41JURd3JxMzQMqZL9/F8I3tyKIyW4mEdBxO?=
 =?us-ascii?Q?cbjF5AjtOCycDvAl+UG8CZiYFmip5W3FUWzcsEpL0v0qIkSADuR4+lWp8L8y?=
 =?us-ascii?Q?7raOZlLHLLkZw6h5Y8H2L1wYfcfLpFHkRk8XYRO4MQIOhn/PK4zCuH4uoL0Y?=
 =?us-ascii?Q?5Wa0Tx9Fm12OeV8xTkIFrmn/qLbrNq1iJKjmb8rgKJt8/rPc9lwJW/9bBfrw?=
 =?us-ascii?Q?SmqVK/WTkUzMMzujQuRNrJ49zGLrIOH6+uKef7HcY6EcYsupJHQiMjhiOYDz?=
 =?us-ascii?Q?28zYkd60T8EeJNxu6LikhSOzHfOv43mqMIHIwdmjutfIFeTuaE8/rzy8jXXH?=
 =?us-ascii?Q?jWddcEfN+n2JPv4bcd0VPGBaaQGPGwdgg+Sln9783KX6M+LdCVw3SOcgYM45?=
 =?us-ascii?Q?19TTq9VNultV4cQvnlKqK4VjaKYomlyeR4LrOc11LTrYryRxrpa5VdC4/i+r?=
 =?us-ascii?Q?cG165B6J8C5GO30Oeti1bShV5c2P7r5RMTp+ZjaMFkwhBXCky19cjFbaOQvw?=
 =?us-ascii?Q?gGRqoawUQAkyFlaGLgwJfb6Hvzs9D+AX/lREDDpP1TlLWiMSSdEIw8IP5ERD?=
 =?us-ascii?Q?9K/fnOvHtEGyzlqCzqVTtF+uwJxYicZXRPWH/bUYhEMCQcq/CzLwOQeZR0Cf?=
 =?us-ascii?Q?gjcHdXAh/znZSpKag3sI5vXyvnQRKDwa3dX0v/7EDAyI9IB2YXny2j6+txau?=
 =?us-ascii?Q?iXKQevY1HocVY1VVznKnUwnGMFn+cb3jdetni8kBpUqbg0bLLsaME5fGKrIF?=
 =?us-ascii?Q?kGcFB+HB5n5njJUgLCLXlRmnOFFp9VcoI2lsjvmlctoKIWN9gbRMIxzJP4Z/?=
 =?us-ascii?Q?vWmT84zBDs1cOONzNzfNi0vFYc1ZSl36Mv0kOELO4FgrD35UAXGT9LA7c+3D?=
 =?us-ascii?Q?XUpnwZBhz6wS4OWy/NJ3JGAJaLeECV4Mw5Ypmc3ZS0TN5avzvhtHT7IK2QGd?=
 =?us-ascii?Q?wLh/lTE2l3msoACtG4wokDLCLRWvlY3z7MJuzJLtR4GXKArT7Vo39HeXYTw0?=
 =?us-ascii?Q?VRQfp9MO1rV0PPVOSiskOb+LZZ4U8MQN5K+mn7MNWUi7OCGrIe8RM6nWfBcp?=
 =?us-ascii?Q?OTDVcv6S0Z+CekNHtCl9Z6KwLbONhapXcbXZAwt24O/W+kXv/kaC2ujMHVjS?=
 =?us-ascii?Q?EXgY1nGilJXADvOhBjuwygOEPwD7O9LXjWyAj1zzylc9MAg2T8iLYUuHYH9x?=
 =?us-ascii?Q?lQ6ZEMFbXDeJewQDpFZDpI2N0pP4ZUcVy4K/JeO5/TtTh36Kw2TEli9K2AU/?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GVBGzBPJVLjJ5Sbp+PMjLucLvvu5OP3PA90tJaxunj/kIe+iE2sJBPz8xRSXaetsFT+AYun6o+KpR5Bg315A+TLoCdTxn3XDW4pmoMEEU91yQTi0Fsp331sGhUxlI7lh0mxbjtT+2QrD6PIe3kxEMXa5fC+QRPNXGh0vnJ8Uhg9prvv/Nftpl5HwF1OH2+/Y+LmivEI+3+oB9GEV4ysh2wYKZefh7jHQYTxlj2eJSG/Ksq/sV1dEsql9QCUYYP6cwAcfQ7V6+i8TeCQC2eBk8EQhi64G0/ZbsuaJQCeZzh7V1Uu/nZDws8T2PiI5Q5KRtqXfXFhDN5c1onn584jQwor8ZwG9poOXKpvsPivS5Ov6QNpj2LP6gCGhl3GQU6axQrKCkn/fOV7QdTfP7L31lgAJIxjwhkeXwoCTk9VRaYsJrGk0yM9WIkeAvSvm8vbc5u3SXvZY4pSrK4nusmf4Rxcb4giTLTM3nEBiNyOQJ20KGLzIqHnhwKqEtXnx6mkxMzaFAXUXaYZh93rLxYaAiZMSZyw0Ttr+Zutc8tMu/d6jSodESVjX/5HCt8pYEV2MXx4+dT1fd5vFy//w03G6bHlmgnOMGiotvuPd0WHB/ow=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eff32565-6c93-4039-dc13-08dddf549453
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 19:14:11.7578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: feFsKGxXsL4kfgNrVZdaGMFsxFgnT2VXZ6rFXTt9pOHwB4Ud9wfKSjNBGhQNKr8I6Qn7yyc0mj/N2ew/qpaHZ/BDJ7iY6Ec8BC06bIJwpSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6945
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508190178
X-Proofpoint-GUID: dYil9GbWCyfL5kFtdGXLQ8p6Rb8M7rYK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE3NyBTYWx0ZWRfXw234QgZ5QIK4
 wBD9F7ITMW3ULr2mOq8mhW1HWelW3eQuAueieeW7LUYmTvs0tOIZIGspidqVVK+bw7Wx6AXdLmQ
 vBsn1M2u8Rhlcpi1CvPVzIoUoyuXDLmyUsw3P0dV/8KiDRW5uBtcUsZBKDVFlmEUM9aXkGt8wW7
 cPBxvUjI8KIdr41Q/iesBr0bXh74Q3W53Z6PgLgauEL8oynRLipNqeGxaTlgVslq2P2qj/HkWSH
 GX9KIo5xYQQOuk01u56m9iQLErTavPW7FNGeEhttURwZcDr1fqBK3Ok3eB5upgNkaoP2og5KPh8
 27JJOC5YZvJbG+mzyF6Ws4w37CIWhAImqZWA0y9SbdnI/qXn+3gtA4tyN5hTSyN0fKQ3xUu25Ji
 JFn3158fG04Swg3zIph0z6pHe1LWxAEEANX5XDeNx8PVAWgTVW0VKRkCUlYySNrRYCBnW+Ns
X-Proofpoint-ORIG-GUID: dYil9GbWCyfL5kFtdGXLQ8p6Rb8M7rYK
X-Authority-Analysis: v=2.4 cv=HKzDFptv c=1 sm=1 tr=0 ts=68a4cd07 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=RNcwn5mOwBLemk0BSRYA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13600
X-Rspamd-Queue-Id: 93F44100006
X-Stat-Signature: nwjpikjnf8uwp7qzomkwa4ubiyzgu6uo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755630872-353918
X-HE-Meta: U2FsdGVkX18tPIkaORjolRiv/ZpISy6ESJHvNoOpOlBFr+0E30vGirxcRUJf3QeLgWhFcLwsePQyE0jYvbcqCtlKCIdIKxZ0X6PdsQ2RB3JjMIdreyZJWhYt0Pyh/tgvED0/L378ev6qzJsEHntSBHhdygA4Ynbt8rg67rYi89KfK1i0hcBmWy5+BSH4XywCDszIfzLPpVRklq7Cpbp2MpGC+ReasEukjyYjpJBNA9K4hMR5qs2HlL8IY2zgYcTxS8n6FuJ2nuosmAhFd6i818FL6kwWhUB4b5MPybaedWkMHFit6OkOkDirJiuMPudw+SKQCACR/TXm13KEtUmeSfdzkOB40gI9OVZ43XdHHe0fclru5UqjMcUTFFeqmhkijFQ57LoCeNWxq4BAAytaHW4VhxY3NkKUvawCVrmZyhGtiJFfVmmnLEofeLWjcEX6iPwzfGP9cyu2l2TTopoN7Of+4/R5NXGQ49fG+DjZToZ/0UL2oYJPNWUvduZv7pImRfVVgeiD8tpJhAHPCt09DdmT4lGk5Yj61NPNcBD8qtEuq5D7SJF1P1c1Gr7M7l3YfBi/c8uswUk69hqlFSQoMJpgo4f0J0XOFzN8m0eAYxg64VNqtTQrvqeLxX/5EVRPOJq4ibuNU/iy6NjJmMtjHCWeiZ93WRXsKiVAaN6chls9g2mtvbZ7EnzCeUN6kwxbLpX14wz5CpQ6MQDoFJ8n47IoYkCWuBf7nLlxbKhrtXIqdxodJ/vJMMTdcSTbcTjb7p0rim46ppVLoFLQEZyLB85KjdQSKuTCF2q3aa1lDpoWdPR0rlBrSL0nskvfwEn9MUEBkKCPl2ZgxEv+weLp5HO1zcoma4Y2ZT96oapU4FBCWGnhu4PbAEaIpE5p6LTn70m1fm5mAh60pofA1kDDlMCtd/4wBOPKE64BNxVq+dRcNMMssiBNoXUQSGfX8FCNg3AELEUiuthEdE1zCn2
 R/jjrM3L
 lEuBlb4CMUwn4B+Vzikqeh24UaKqoJVNF0I/gwbZfNfLmcsnHqigR7gx0Bl9Wgv8yRRgGjz00TkEFCoW8UH1SbILQ6tCKAwM9GKJN1ezFUvnwagzVIJG/dPsyVHNKGwjmUvqpjkLUjLl09pY0WuXVMAhnZGmtUxTbyUaHUz63qFvh3PFiWsKtXlz6lVakR9W5smD+nKb/YeNcEPJ+RkaVcMDRgf2aEi+iCwgkfSAVVje07W2IJcj+nIHu0sftVEtwL51wHubGdYpXahAYbAidMBsJTODXoG5+dPXuVevDl2VjB3prRBsPaU64t35Fq8WV0YoXXSLN9zyS+Lh899ccipi5s3aL6uAy7xej6QdJviSG9FKlH8Y2GjJlS5gGnKZ5047WLDfoHIBBt1CAwnnHn4EfHvgJ3DshU6wMP44yRw1UwYuT6ENtO5FHnAxXtqIzRiiIr8h3I+ypPboHUop6RQmQOj758p1KwaSAPPuK0bMu2LfE1qmIuVF+MtzXwbo/FGBzAcePyasF7PSWeK1VRjQqsQWdsJvvPT9KqxyR3c3+fqQBP1jy2/mLMF+W88DiRyzPVxy733Ktzy7SZBX6ddxLIJjlkSK3bthkaIR/lRbrgUrJZgpsUUOkD9FFcTNDAvsQvkzWXjbbqEkhuQjIM3rFOYCQbn85UP6PWz8676abWEucwllmyTwoj82C9q7OaDgoNKCYsB6wKMClpSSDIpEijy1hIxYtw5TBeKDzddQ5wd79KEI9h58MBX9OvfsaPrH074n6WnBZ1PfDCFicbhFe72doJD/FKEaNbBuKRHRZng72vWInkyWJiWV5cjLs3Tfm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 03:10:29PM -0400, Liam R. Howlett wrote:
> The ceiling and tree search limit need to be different arguments for the
> future change in the failed fork attempt.
>
> No functional changes intended.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

(Obv. in addition to comment about broken VMA tests :P)

I guess intent is that if we discover any page tables beyond tree_max then
we ought to just wipe them all out so, in effect, we don't consider
mappings at or past tree_max to be valid?

I feel like we need a comment to this effect as this is confusing as it is.

Could we add a kerneldoc comment for free_pgtables() spelling this out?

> ---
>  mm/internal.h | 4 +++-
>  mm/memory.c   | 7 ++++---
>  mm/mmap.c     | 2 +-
>  mm/vma.c      | 3 ++-
>  4 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 45b725c3dc030..f9a278ac76d83 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -444,7 +444,9 @@ void folio_activate(struct folio *folio);
>
>  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		   struct vm_area_struct *start_vma, unsigned long floor,
> -		   unsigned long ceiling, bool mm_wr_locked);
> +		   unsigned long ceiling, unsigned long tree_max,
> +		   bool mm_wr_locked);
> +
>  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>
>  struct zap_details;
> diff --git a/mm/memory.c b/mm/memory.c
> index 0ba4f6b718471..3346514562bba 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -371,7 +371,8 @@ void free_pgd_range(struct mmu_gather *tlb,
>
>  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		   struct vm_area_struct *vma, unsigned long floor,
> -		   unsigned long ceiling, bool mm_wr_locked)
> +		   unsigned long ceiling, unsigned long tree_max,
> +		   bool mm_wr_locked)
>  {
>  	struct unlink_vma_file_batch vb;
>
> @@ -385,7 +386,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
>  		 * be 0.  This will underflow and is okay.
>  		 */
> -		next = mas_find(mas, ceiling - 1);
> +		next = mas_find(mas, tree_max - 1);

Do we need to put some sort of sanity checks in to make sure tree_max <= ceiling
(though this 0 case is a pain... so I guess tree_max - 1 <= ceiling - 1?)

>  		if (unlikely(xa_is_zero(next)))
>  			next = NULL;
>
> @@ -405,7 +406,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		 */
>  		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
>  			vma = next;
> -			next = mas_find(mas, ceiling - 1);
> +			next = mas_find(mas, tree_max - 1);
>  			if (unlikely(xa_is_zero(next)))
>  				next = NULL;
>  			if (mm_wr_locked)
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 0995a48b46d59..eba2bc81bc749 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1311,7 +1311,7 @@ void exit_mmap(struct mm_struct *mm)
>  	mt_clear_in_rcu(&mm->mm_mt);
>  	vma_iter_set(&vmi, vma->vm_end);
>  	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
> -		      USER_PGTABLES_CEILING, true);
> +		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
>  	tlb_finish_mmu(&tlb);
>
>  	/*
> diff --git a/mm/vma.c b/mm/vma.c
> index fd270345c25d3..aa75ca8618609 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -486,6 +486,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
>  		   /* mm_wr_locked = */ true);
>  	mas_set(mas, vma->vm_end);
>  	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
> +		      next ? next->vm_start : USER_PGTABLES_CEILING,
>  		      next ? next->vm_start : USER_PGTABLES_CEILING,
>  		      /* mm_wr_locked = */ true);
>  	tlb_finish_mmu(&tlb);
> @@ -1232,7 +1233,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
>  	mas_set(mas_detach, 1);
>  	/* start and end may be different if there is no prev or next vma. */
>  	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
> -		      vms->unmap_end, mm_wr_locked);
> +		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
>  	tlb_finish_mmu(&tlb);
>  	vms->clear_ptes = false;
>  }
> --
> 2.47.2
>

