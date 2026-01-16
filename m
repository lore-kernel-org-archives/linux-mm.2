Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65962D4A609
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 08:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8296B0093; Fri, 16 Jan 2026 03:46:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBF9A6B0098; Fri, 16 Jan 2026 03:46:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B439A6B0099; Fri, 16 Jan 2026 03:46:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A03FC6B0093
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:46:59 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CDFB8C075
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:46:59 +0000 (UTC)
X-FDA: 84337196958.04.7C6A052
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id D952180004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:46:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RdGhYwHS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dJBI0aZT;
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768553216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jpg5f7dY/g7pcBQwW96MP76n/f5t1ExbGSpixHlo1BE=;
	b=xcxVmancemDbqj1BjZS0UHhv/2hWYHSvRL9hxhcdelHnRQTnRLRkELm7/7Fp+BXUQVfWVY
	kp3niRbHbWutTqNZG0Xows/E2l9E0POhvlH/AXBoMvxDqNdlNKis6g4gB2VO2QXNLYS0IB
	z11j/E1x2UwAf1lNAuU1f+WYE4NRFu8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RdGhYwHS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dJBI0aZT;
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768553216; a=rsa-sha256;
	cv=pass;
	b=0B8FljqGJHWi8VgrurlpRf1hK0l4T8Nt73MgIy7/V1X6j/tWlva6H94rTQ5MTrZgvI6y7h
	8+FtEKeuLBGfCfbA2vVpF+jIKHUWxNeEfZsCGKdPRmuwWKbnYqTrVMk+XBw3nvCWSE0Lg0
	aPW1O/kWWwIr+EPJN4YOBcqllGjQbNU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNLvR1430046;
	Fri, 16 Jan 2026 08:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Jpg5f7dY/g7pcBQwW96MP76n/f5t1ExbGSpixHlo1BE=; b=
	RdGhYwHSVoSFV4SYKpjTGIN3c0AZrEKzu1LP0ZYohRe8KuBwnDKaF/GOFSidLFzL
	sOcYxRNqJGevjmRebX8cV+fO+w0uRoyc3fTxaQDCIzMwWRRjg0a3kh9Rl7HKRVhh
	qEbTJMBKu5TrzrDgVA+9pg9/5SDy90+UoS29x1XA9FWhsBExhjDBszHxvvQt+8DM
	SBcGedWapVnWUptKOhkgXrZRCYmoiZDL8+HL64yOYWdpgzw/V2E+WNfP0h2/XcmP
	bFJGvayumSIlZy1/SqmmZDo0zhBpzCOi9DMbMDGebv9ekgRubNopz/pzeGQKA5j1
	OfpfyJipZDWDvymN/wCIFw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre41nyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 08:46:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60G84j8b003564;
	Fri, 16 Jan 2026 08:46:48 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012068.outbound.protection.outlook.com [52.101.48.68])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7cmujc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 08:46:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PpvXVC63g0Z9kTgh8XCfwatFnY8gYXd04Y4NZudpgOwOg92NaCXxTECLyE1OFhFNjTM6E14V72SHw2O+Iznq9EPz8xE+6FDq+YRTs1Nb0Esy8kXdfmteNsiYbgF7eYvo1WnjhaGi3eOoVxk3VBAcWXrMhEU8eA86QtG2eFhuXmVx6VCDGxpRFkyGl4mBBnwiP+THmL7NwYMIDC+JFrbOvjj3Y9BR9vv5NmFYYiS4tZNRSGFOIMR4JJZ2I3H6wwzYM2Ihx+GR0wBJDC4uYIwMvtiEIlbgbneP8qfGbxyn/WSUcsCZtFIYXA9hkr0qQ4fSZjv2OAHB5uiRV3IefBrP+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jpg5f7dY/g7pcBQwW96MP76n/f5t1ExbGSpixHlo1BE=;
 b=D0c/o6c25cNqh0lj7bH6ZHl3HHtOBxlUQbrFOa2VtGI+9Kt+h1MN9G0wew2EqrZwPtz6Rm+hy1FGJ6/mDAy2GvgMl25H73wEREmY/L4mChxBf9qKCoqApDlryVg4Ao0pVUxrUqFfhXex3DLs9ZaYWTRvLsMUiH+py/3a8nGLjrf5lsAI/gL0pH4PG2fGwhUdpZa6ycaGZI4F5AECyKDlSgTBrNsoh8NONC0MV8I9klbZYfntE2apgos8snys87wMAlveAvyPpQRou/VInn7xgt1iEJzl+vLx0VqV/75psuEq6KHUe2QlanuaeT/aFrumVk3oIkNJ0ibFt+WOt4Yemg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jpg5f7dY/g7pcBQwW96MP76n/f5t1ExbGSpixHlo1BE=;
 b=dJBI0aZTvnJkkTQotCViV0UlSDwthYiNo3jHqF85fe9E0Myz9/LUfHC1eRLm+lMLK1DFWjSoR5ifO+9wXt2AEwLHwcEhYeuDYj5rrbRw6Z7ACzjF2GJea04HhXCo6AG+cPldBqUDdKBh8Fcb/uSADLCmftPT9hzjkRGLpmx2rb8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA4PR10MB8254.namprd10.prod.outlook.com (2603:10b6:208:568::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 08:46:45 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 08:46:45 +0000
Date: Fri, 16 Jan 2026 17:46:37 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, Petr Tesarik <ptesarik@suse.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH RFC v2 03/20] mm/slab: make caches with sheaves mergeable
Message-ID: <aWn67WZlfnqcWX46@hyeyoo>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-3-98225cfb50cf@suse.cz>
 <CAJuCfpHowLbqn7ex1COBTZBchhWFy=C3sgD0Uo=J-nKX+NYBvA@mail.gmail.com>
 <4e73da60-b58d-40bd-86ed-a0243967017b@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e73da60-b58d-40bd-86ed-a0243967017b@suse.cz>
X-ClientProxiedBy: SEWP216CA0024.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b6::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA4PR10MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a5d2c0b-b904-42be-af54-08de54dbc6fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ti9pNm9RamVnM0F4OGs5eksydk9TNFBEVlhWbDJTNU13WTRKM0tyUk1aaVFi?=
 =?utf-8?B?MFUwSThDQmY4K1RqRlMyUFFvMG1uUUEwc0pTb0JDQWVGTjJPNm1pMjdSTnAw?=
 =?utf-8?B?OWk2R0NhYmlseDdtVE81VXlORnJRVGVOcTBUVlhrdTFFaGdEdDdiRm8xTlky?=
 =?utf-8?B?bFRvK3V1VzBSSjhKcHB4RDAvNkFhanIranRSelQyZDBmZjRvSytRVnRTQjRX?=
 =?utf-8?B?MXFSWWlnRXZ0SC8yc25zdll5ejY0ampISUlSRjBHU0VOQ3pCcVByU3hpMjlE?=
 =?utf-8?B?UzcrbDRETXIxSkJoUTR0TmdDYTl3ajZnYzBIWkpHUG1TbDUrcUpMTHRLWTRB?=
 =?utf-8?B?NGVOQ2xtMWRaajZyM3piWWp1VTZVY1pJN0NOajNkcndZaTZYTVRoYUFWd3JP?=
 =?utf-8?B?THVlWk84WU9aMXZqUUhQUnZEVCs1Y3BDOUVPL1FsNEV5RForMjJYM3g3OE9h?=
 =?utf-8?B?ZTdRWkIzN0pzQXJLVzVYVTVkSldyOFR0SW5aSE0rTjB2VXBhYlVMQW1MenhF?=
 =?utf-8?B?clRvS1JDbC9FakJpQU1DeVBBdXcwNWdxR2w4UWM5R1BSZUwza0RndTFxL3Ji?=
 =?utf-8?B?N2F1SmRTZnE5OHlEeFVxNHBMOXBvVkRiQ2gwemdoY0YvTlNEeDVCTUlKREpB?=
 =?utf-8?B?UUIxZ3lQWFZ5b0xwajNTSXo5WmwvcHNwNDcrYTdJMUs5Z1NEeEtYQ3Z4MnFC?=
 =?utf-8?B?YmxOUG1zKzI4UERINmtKYXltVm5zdStPVkMwUS9JTU5Vd0dUSjdrOTg1eWpG?=
 =?utf-8?B?clB6NXNxRVZuQk1sd1hqSXhMbG1rZXV1MzJkWTh5WmJSVndhUnBQNjFVaFRF?=
 =?utf-8?B?U0V2c1cvWHRtdDhycUcvbzdkRUJaR0RXejIyQklJNTE0U3AySkpxU0FWOFpz?=
 =?utf-8?B?MkoyOU54TGxDalBFZnJ3MWgvVGZvM1BDdTM0V1pNNnA2bUpkenZES3g3bUpF?=
 =?utf-8?B?SHQ4clVneHQ2S2p5S3JGZjQ1ZWVrb25XTy9kejZLaWZLR2lneHZJNjZQaEpJ?=
 =?utf-8?B?SDlFVjFGd1d1UWtmZ0ZoYnBRbVlScXlTSmwxNU1qdFNzazlzdEFqaUpneTgx?=
 =?utf-8?B?OVMzbXFpMisxd3lUbzFZNDVWYityOWtJUSswK0dwRE9VamxnZkxIK0Vpbkh0?=
 =?utf-8?B?emVJRjdOVWxsMjMwa2JXQ1FpSWlIc21VLytybG9FQkdDV1NXVkNhdGFCN0tl?=
 =?utf-8?B?enRGdU9tM0R2Z3I4NFcwcHpsSkJMRWN1NExYWUpRQTRGN1F6WWVaSWltbTE2?=
 =?utf-8?B?WnhhQlllcCs4bmlzbDlBczJ6dzJQb200azZqL0dKT1hySWxRMlJiNWJKT2xD?=
 =?utf-8?B?LzVkenZWZjJhMlZMTkhJV2xxbXJ5dkxpM1hjQnBwNzVYaFd3SGNzTWRmRTdn?=
 =?utf-8?B?cmhZWmpjVEJzT1NFcVQ3d3NTNzlzRjl3bXpBYUVWYjk3MWZPNmlUN0xYOFpm?=
 =?utf-8?B?VFJsdG5xSE0xU3BvaWJrWWRESXY0cWNRcVFjOVU3RW1sOVNvcDhBQ0dRaFA1?=
 =?utf-8?B?NmVTclUvQjRoVEZNVk9lNXZLNmtMeVZ1cDVEMXBMTDJzdVZrTXJoUlJ4b0NK?=
 =?utf-8?B?eXBoKzNDRjljMlFkUlFGUC92WGlERmxQb0dBejdHQjBwMzRnNDNVV3FMRmZX?=
 =?utf-8?B?cEY3TWhhNHdENGVBanJJZDJUaTlhUmhrYVZ6alJIazFib0l2alNka2FRWFZq?=
 =?utf-8?B?RzQ0anlCaHRSOUxaR01UTS9VVzY2QStYZmd3WUlraFR4RVdvMjhxTCtNaExR?=
 =?utf-8?B?Z3FvWHlWN0RTQnFFZnFWUjdhbmJUeTk0cXI5U1FjaDBxcmd4a3JVbWd2VXRH?=
 =?utf-8?B?MVAyelQ2S0JFWFhSRFV5bFU4ZWxqcGRRa1lOeFl2QmtlamsxdGFwVkc2UVlO?=
 =?utf-8?B?eE4waGExOHJlTkF6YlA4VkNRMHVrUjljb0lCTFFmUUdqTlVhOFZGQlkwNU1X?=
 =?utf-8?B?a051OTAxV2pxc3RXMlVSc0p5SXNxVlhiNnM5TzRNR3FNOUN3UGtLUFRZT3J4?=
 =?utf-8?B?T2dwdTFEdTlOajdRMmozL05mNnlMNG9yZU4zL1hORVQ1L0cwTXFNNzJVV1M2?=
 =?utf-8?B?bzBLTnFHMElsazhGU0F2ZzV0SmdsbHZLNGF3WnFrekFEbmF0dWM2MU52dmhC?=
 =?utf-8?Q?x6yw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWxqTUZoV1dLZ2g1Y1VXNVh0WWJlQXZGLzNBbkFmUFhvTXQ0S2xXMW13ZzNp?=
 =?utf-8?B?Ym1BTXNhbEJKVy9IUXRrQWV1WHhGZWRjZi8wRmEyT3JRN2xnazlrZmFjZS9p?=
 =?utf-8?B?Q0plOHdPVFE5KzM1eElaZU8xTm44Nld0NFd0eHVNOVRCTFoyeEJoN254TE9C?=
 =?utf-8?B?NlVWYzcvZVJWSVZTeVd1OWdwV2lVbDVBckI0UU9DUWFzZDlNZTFPQ0loR21L?=
 =?utf-8?B?TTFsd3E1dDhXM2tMMjZmT0lXNkNBZFQ1NG9HN2RyRUJFZEpmaEwvMW5sOVNl?=
 =?utf-8?B?MWhwcVltdzYwWVFsTldMU0ZzSmlvdkxzQWdnY255ckFraU1yb1ZwL2RXbDlB?=
 =?utf-8?B?WUcva21sTTdXQ3p1cmlFZUlQcEhybGlUeTBMZGJUMC9TbzkwSmtqRFlsbXhF?=
 =?utf-8?B?Mk5DQVBwbkpxMEp2NFR2QTZiUUl5clF5ZWR5UFBwMDVWYzBuRys4U003djBW?=
 =?utf-8?B?R1QxQlZLWFVoM3J6bHpjN05IemlxU0VrSGhGVjRYMGRCMlZiNnVvZ3htL2xi?=
 =?utf-8?B?OUhiQ3hrYmxsdnJ4M0hBYlZSWm0zT3Q5UHpwZjJDRTdlWGxDNEdvdU13eEx3?=
 =?utf-8?B?S1k3cGR3UlM3cFBuMlAvSFFQZUhoSDBacFN4ZWZyNW9DeG1XZ2VxMVFoTDJi?=
 =?utf-8?B?Mnh5N0o1WlF1Zlh1eHlTeVY2RDJmcDdhaHB3ZS9nZFRQVnlhTkJieG42N0o0?=
 =?utf-8?B?UDEyazQvenBidnUySXhXQ3RiRVhCYmJ0UnBGdHROdTNHRzNGaDN0MTBJWnNE?=
 =?utf-8?B?VTF0NjlOTmJpSEZjMEc4WGNoWk5RSmNpb1dtb3BaZUZSOVlBekpYQU5VRGNx?=
 =?utf-8?B?VFRFeUlQMHhseFpmWEhTTTkwNDFxNzR6ekdMbklIZnVlbkh6ek1lcHFwNVR0?=
 =?utf-8?B?MHJjL2VhcWxkaWo5Vzg5QTJZd0YyNTJ1dkdWVktkSGMxUzlkOTYvenZ2eUF6?=
 =?utf-8?B?bHcvb0h2RFFuQ0ZUSnBCMTdsUFA4QU5rZ2hwNTRnajlyYUZzSFNXc0JDak1D?=
 =?utf-8?B?ZHp6NzBBZm1yZVk3cWZDWHkvT3dNdWJtVytiM2psMDZCZ1hvUGhTTTh5NjRo?=
 =?utf-8?B?S20zNTNmVGNuWGxmLzFhS1p0WWM5RmdqQ2VpTVV6c1NTTWpCSTBVbzlDSGZ2?=
 =?utf-8?B?bFZ2M2ZRbE9pU0JENC9LTUZmQlhQTWJINjd0V1czaHFxSG1hN2I3VnR5ZGxD?=
 =?utf-8?B?M2J2Zk04bHUvUmdDUzZzelMyRnlidUhqK0ZVdkVCdm1oMG4za21iWCtmTzll?=
 =?utf-8?B?QlZJY2pyanRlQU5lV2ZuWG16Sk9XNFdyVVRBR3p3K2RKS1Jva2lCQU42aEhM?=
 =?utf-8?B?UlN4NEtveGFTMXRkTlBkQUtmMDR0UW5oVzRsQkYyY2ttZ2VYaVdrNUlSU1VJ?=
 =?utf-8?B?cnFiY2puK05IR0RpbmM0ajI2c01XWHQ2TmpNOWdvY25wWjgvVkpWblpBMkVX?=
 =?utf-8?B?MGs0VVFyajVJYnl3cDVjQ0ZPZWw3cmFoWVBWVCtaQWZlLy9OaWUrSk9rMXJ1?=
 =?utf-8?B?aWFaUTl1SmtUMGhCRXl2ZDdnVVhqbjhxck9hbG1CcnJmSjNxV0wzdGVmWC9P?=
 =?utf-8?B?U2ZYYnVjbE1SNnRGdTBzOHNHZUd4ZlZRdCt2RnkwSXorOEtMaE1rR0tRVjNM?=
 =?utf-8?B?aXlrQmtZRmt5ZjlZcFBLLytiNU5BMjNLUHpNeXMzUkJmbWZIU2NOZkppSUVL?=
 =?utf-8?B?ekgvc3Q1aUZKUXR1Q0lwVVZqdjUwNk15c3c1MWg4MDRTdHdHNjV3VjVkaXd0?=
 =?utf-8?B?QXpUOTVleFdNYW9qRWNPUUFJZnZBTDJBdERodmsvc3FoejR3QTQ1b1IrcFpq?=
 =?utf-8?B?T3NGZktvOXFESUJRcEZ0NWZHSHF5ck5kMFVQaVhvczRZcDdVaTRpNDJDck92?=
 =?utf-8?B?NGdybk0yZTJoVUlya3ZkMG5qVmdkY1RlZ25pcmtleWxGbG5EaWh6TklNZjdF?=
 =?utf-8?B?SHRhQklUeXVqMDh1NTQ0WXNqVXVjZHVvbCtYNGM1TEQySDhMVTN5cUwzMy9m?=
 =?utf-8?B?SlpHSmE1cnJlQmprdHZBeWJsZytrY2lrMnhqQVdhcGxxcVR4WVlkcE51YjFN?=
 =?utf-8?B?TUlhNGI2aUNUUXo1U1lsei9SZkxjYjJJakdKWXJTUFNaNHhXZDNxa3RBWWtS?=
 =?utf-8?B?OWcvRnl3Z0ZZdDlBQVZjd08vSTg2MCttUUZUdDVWZjZnS050SmFCTDVnVWxH?=
 =?utf-8?B?QU1oSzhibU5yM0tnK2V5a1IyL2JhaU1zWnNBaUNQR0RUY3dIMG55TGxiaXJL?=
 =?utf-8?B?RjNYL2FrNWR0OGJzdjdKNjhhQnlvbFZGUUUxN05hUW1TSEp6VDZFZE1LdFZh?=
 =?utf-8?B?SkFoTFBhTzBLUGhEckNSRGhiMit3OXZoc1hmcEZ3cjdwR2N6Y0Vndz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QYTT7Jf02uolCswBsgrowkCKhjZ8a450NxKM2Ihy9oUT8G7EEdgpVaMeBP8o6iZdWC7mFpUj+cCyvpeUE80bLXNamvHpGosccbDnhd61MN+hlHpZ2VG898bZqXcBmZRqvxevWQKng/vrh1tLfI5z06SKLLBsLwS13Fny9JrBzE5exowGPR+eO7UhNqzOPsKA3Vla1rWCuGawdw/8V/KNXCz7p5V5EWnNT+xDy4MZ3+oa5Wxy3v146/OExeJgVMK1SLELIuvInZ9fGCU1MYbIG2OZTel9KncXO4tvBqjK86CRLr/oQEoG3cYOBPie21Cxdzs4ISP11tLY+/aEmiAZUQgbbFzt+q70uIV8HoMJXFNhjq+jWjxsGmJkiSDpIyTrpMKW+VC4hHBEfOO2tM/ipw5fzWdIefvcIK9hwpMYZ4QaNZBvWUwI1VwmmRv9oRbscW7EzqbVWY9lih2yQxujwZZM3wWCGATsTOvPlD8gKLSYrCsI6Ou4PS6T6nCHw5TCcu+iONgRH0LX4xUkrZ1GAnHTFvVhGTZlvpCQO0Ijc7h4WK0AS3PDL5muv+iVCKdxzkHxurujcz+XrVULiKEI8st+7pZnYxXfagM+sTtlOHE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a5d2c0b-b904-42be-af54-08de54dbc6fb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 08:46:44.8396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rnSO8cNbCWdeO8UvCmG4hAeN4MxkXSOhIoW1zilzU186tN1I3sOhGo4LMsPdTVG3dVkph5OHSX5HIfyyyM/vRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8254
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_02,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=814 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601160063
X-Proofpoint-ORIG-GUID: AEhZB1PruTUrlwqCem9-0S1QjKvQJRA1
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=6969faf9 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=krPbT0nLj78Er1Qms1gA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA2MyBTYWx0ZWRfX1Il22JYnvUWe
 N5EqOGJd0bU3nYWWA+HUBzn2e7JWgLgHq66ZrHOLzvJ5+eadH0l5H0MNVhYWhGEsKVQsfkUO4vw
 wh9QzKzixc53WvfC5QI/wJGOfzUrWLRufjdS1F8etRL+reoANjGd2s3o81a2K2KXmkZ1cqAf2hL
 QKhI5MAq9jpeHo8O2HqSsmXGLVGyJ3n35Lu1B0g9CwqOnVWnBNAWCwu9uUcjA7n0yUmmP4rLvXT
 0uHkmt2vQODy1oYe1I20/EetHaHLo25XCOFuZ4OrbCeFbcm7f3RE7F0QRuAUGRGsIjMoZM06ZS0
 cdviAvTA5Qt3FoQc2vO//PuHAFXY/reweuZsISFtktoJ2YLf25kcf680U+xqdyZz5eN4un7NXZS
 x8yzFua/9pte8xoduj7wQL+lSaMmkbuQgtHJtvJGg2vlNl6eJ9VUHZTp+9I9M7wSXw7A9lwWJI4
 q5wTntPKHUppzQ6mkPw==
X-Proofpoint-GUID: AEhZB1PruTUrlwqCem9-0S1QjKvQJRA1
X-Rspamd-Queue-Id: D952180004
X-Stat-Signature: xt759m4s7jgcoy1jmiuw4qj1z9uqw74q
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768553215-974228
X-HE-Meta: U2FsdGVkX19YwcYlQd/5FzDFHAUjJVl35bv3VVH3wTBuRatTbPQESCzvVsO/HfdObk8FTXcdY0MJSJMmToWWpgR/R53yftNP6lIqUdjWc0u6XAGZUQx3cwS9Eialm9HQqXGFSRiAg8L3Zbk7jRTqQzE3tHFVcvNVAli02cHzizYRqak5y/W1dQhQV2UM99OdkIaGmc9XPCOxakvqfAJKnmfcVskb+EdYORwlEQOMjkhkul/kz5Oung2G4WoA3m0z1i1kRBZF+TXMK3oGX2xY/gKADsqJw+ZylUtl1xHWkcKq6zv05fxdvlf9vFZ+wIKMtYzqLuc1CjpOlCQOpMCsPOKyWPdt2V5o++uGmTuoggBDC19pEVBU/6nfdg63e24MSMX6zH5MqaCmUHUBXFdniI5jaO4T96IIOaYruYIhUfXxkTloFuG7OZeFMtjlInCWq39dZLzj5SRF4c8OE3SHk9io9/SUFOUSVL0vdGqax4FNJFlBgAliV80T5In8aWu1BoLfivvDf6SM1nIrry5jd4CCCgKibBtdRu/TTbmsby/pXp4YYVWMbssgWehy8+HgBub2zFYk+IJAqXNtOQ6TK/rLj2kYbmVu5qNLRUY36dtnAZ22pnoXcgryIDYetdIuE9NmEwnn7FIamJH7NQ33KBzNmbwAbNJpOzUx9M4tiMgxAAMLz2HpW1F9cXP5TCb+0AnF3aoyFrRUlyHrkPspntRcNgLW/cPlg2HNvNPIIrf4+kLkTS51cojF4CLKM9pvXYWsvPZkFvRwsF81Vsxch/zmSBmnsBigz4vQmMmKBvh090aLCH0lJCri5XGgr0uzFg0XvpQOdRIqu30H1Re1wP7JH9GBwEYD4pvorxwaUMyCjoiHcKqa8QxZP4Sy/1g+48j1eaXfCIEhXixG84YcNFXR/UZ70vAkfvM0AdVsXFGVkr9VV53tQyzdygYiXK5pzK9m1qZXe86uQE9KwTO
 jU/AweQb
 WRdrp0eSNQj8qsslAAjhcCLyXOxFrkOqbd7b+e/bDvlon+0thz7+1aykAJ+12P7YfGlopieXZUFLIS22X9sbJjQeaHp2lkz5N4HBuhJMVlfV8QP1hsFBzf5ygrj0wAgk6Wtm7wxAdSvgxzMl/8MEZgI92iI6FypLfoHC1BOFlGcdT57t36gH6oRKkTiQrP48E9asuLABhCeBbCrbVaolQsEmwSUq3i/UfhNUh8Z1MUghhYSRhjzm6P0hNBcrU726KeumgA0ykXkgqYIo9kRFrNj77ee4MbrtZEVSa2ggsl+/8CIwBwdNiUGK6H0IqqH7qdcxzd+RAU8zxurDIAM0Bfcqx7/VLVVbX6QMO8BMPKrzj8hOA0muFG+O0/Lp1Zcfo0SM8FV3YOv5+I0EI/UFiQPKyMVrfPIwYrdVKpm0TgnZb2F3zY/OEV6JvxQ0461SgOjktEb4NVfvaGPPM2j/BFLOxHOHHweQooGTrLA6UBJQKXL1jJOKAxlnx4xjkRzCoVLHUg/3G2wUN9W/7a/TBsnLdp71TArTfwVHCXLdn3htkVM27EtPut4aAwSz+vhE62DThqr8wdpZxKP8Smx0HxbceyGbzg3KpPvGeb3JRgVFl13cGI5dAAndo+8TkTo7ID+h8HKnshJ9cSXEHO/qY2nF01Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 08:24:02AM +0100, Vlastimil Babka wrote:
> On 1/16/26 01:22, Suren Baghdasaryan wrote:
> > On Mon, Jan 12, 2026 at 3:17 PM Vlastimil Babka <vbabka@suse.cz> wrote:
> >> @@ -337,6 +331,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
> >>         flags &= ~SLAB_DEBUG_FLAGS;
> >>  #endif
> >>
> >> +       /*
> >> +        * Caches with specific capacity are special enough. It's simpler to
> >> +        * make them unmergeable.
> >> +        */
> >> +       if (args->sheaf_capacity)
> >> +               flags |= SLAB_NO_MERGE;
> > 
> > So, this is very subtle and maybe not that important but the comment
> > for kmem_cache_args.sheaf_capacity claims "When slub_debug is enabled
> > for the cache, the sheaf_capacity argument is ignored.". With this
> > change this argument is not completely ignored anymore... It sets
> > SLAB_NO_MERGE even if slub_debug is enabled, doesn't it?
> 
> True, but the various debug flags set by slub_debug also prevent merging so
> it doesn't change the outcome.

nit: except for slub_debug=F (SLAB_CONSISTENCY_CHECKS), since it doesn't
prevent merging (it's in SLAB_DEBUG_FLAGS but not in SLAB_NEVER_MERGE).

-- 
Cheers,
Harry / Hyeonggon

