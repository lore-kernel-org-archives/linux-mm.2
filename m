Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8637CD262AF
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 01:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF32B6B0005; Tue, 20 Jan 2026 20:06:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCAD36B0088; Tue, 20 Jan 2026 20:06:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78C66B0089; Tue, 20 Jan 2026 20:06:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A62AE6B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 20:06:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23AF75A902
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:06:58 +0000 (UTC)
X-FDA: 84354181716.29.5DE587F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id B6DBAC0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:06:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dX5sHHWX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TMEp5MSr;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768957614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YoBTUVKkWSkcGCbsM3MIegGb6O/4W7SjN80DteeFGrg=;
	b=cyJRidPYECazKEzvrfyLWCP1o11dDWgV3hqvieYzBklUod9ZUYWXX8VwKdcwPl+9REK0FK
	U2Skl8RuKV/alon+gHjEUVu/cNxqgiaPXH0eiNxRnNQyDwjrl+T44+CsE4QCA9IK/tRIRF
	foDhL8B6xep0nLXfpn3ejJyni29+xZc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dX5sHHWX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TMEp5MSr;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768957614; a=rsa-sha256;
	cv=pass;
	b=oKuxdtqB5fYWxjeWv8QJNvbhQA61Yh+YbhRTgRhIzyzvnjiW1S+nDVy5o498EkxxKAj0yO
	bmtaEQ+2VNshVZuMSozRnIvVrqeWd4Twp4sS3gQFxuETJvnIXyNiX2rjmhlfVGe/miMQnc
	sZS1stoNNaJYnTGJIjqpvV4vWhqlD+M=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KIRdZw3523865;
	Wed, 21 Jan 2026 01:06:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YoBTUVKkWSkcGCbsM3MIegGb6O/4W7SjN80DteeFGrg=; b=
	dX5sHHWX+5QMDfeAj4OClnbLyKdXZ0pFkQ7B8++eUL0pSMVCABerzoP1lMwKSGj3
	gMeNb13tH+SOs4NLyXnjjemPNt0x6wUs1H/xWzJ0eYWQCdzRFIjfmjXVofr1NaMg
	UGT+HEBjz9bBsAjxhZ4AuwHWykDTk+qWWNGOat2IRX7mil5tm9m3XcMEHbazpMQS
	NiCuyAHLqKViSeed/npnJu3yJWwomhciONCuXEGBMCbXLCiomFBPxdIF7oQWVaCw
	bfX4XV3axy8fdcFdDT+XI3sHWUn23UENYAUEKs8AZ5M82sBh+30HayHLjxPAYP0T
	jXCD8CQe6U+lBbsH5rDLwQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qcvgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 01:06:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60L0MwTg021921;
	Wed, 21 Jan 2026 01:06:48 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013051.outbound.protection.outlook.com [40.93.196.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0ve95n7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 01:06:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sqVOI5nOkbzT+gpKuCaPLOOaWUuXD6oAsra3kcx0MJkGdBc4nXWf4itOur08ZGRXOtW3JYYxmeIV38nUK2w56jlsCFvnl7OVNb82tYo6zCbt+WQ4yU+eXUYwwp2vf5rCbJNP6bg/b/plCylUFNNHU6yEy+2uWk0y9me/TvRzZjq8OgR7u9BoYGIub2ztSC+/lRMAs5/AfzxMhCpiNg2waWtx1Zf+0Z9M26V33NsXlMl2Bg3I4aBo5dcbo1IkIj4/9NS0vKgW4YvcQGG6oVezzYYZj3njmDVIHY5r53czJ14hOLrHHMnhZnm3gmD3gGYrt5a0MUIsn2VjzJ3qCVtDHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoBTUVKkWSkcGCbsM3MIegGb6O/4W7SjN80DteeFGrg=;
 b=vPLobErUddArjcFMVRphD2BeentV0dWZgUv+hAJGFUmWvUmLfL0Ney6PqBiAGAODVIzrlMx1B+o6cQXDpkF5Hed+WMO2Tk61Zylf42ZGSmXbTIORNa3kqHXaFmtRc6DDjnraqRuIOHl7/sdWtPraoJ1yevdjSZQua7ljV3Zr90uMO0OXGl64x619JFOHuMTRyiLZF4O71TMJFY9tYaHZP0RbiQa6eRWeIWtMP01PGOyRzIRNKG6bgHmUK3ZFCiZqqYtHSwQ+VNgqsQGV+feHWVq+UbKk0QKleXC4MiNhxExU3x+9cng4ygiIsQAogxvrUoUpt6Q90OAhqJLDc6CYog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoBTUVKkWSkcGCbsM3MIegGb6O/4W7SjN80DteeFGrg=;
 b=TMEp5MSrTxTP2Dmqux4lnLPGa6tjaxIv09qE3rk6w6IXF9KBP4bJGrMsE+h2IndbhGNjJpHHcVVCsTdjHGEe09yB+INlp2Th2KFBz5QGTe6pKfZT4H7DBfnM1Mk6xSttDsYzbSytgkcoR0Yrbx4AF5ZxDwS4DkSp+HK5mqdWkM8=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 LV8PR10MB7822.namprd10.prod.outlook.com (2603:10b6:408:1e8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Wed, 21 Jan 2026 01:06:45 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d%5]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 01:06:45 +0000
Date: Wed, 21 Jan 2026 10:06:37 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Petr Tesarik <ptesarik@suse.com>,
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
Subject: Re: [PATCH v3 11/21] slab: remove SLUB_CPU_PARTIAL
Message-ID: <aXAmnbhynV3xUKPW@hyeyoo>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-11-5595cb000772@suse.cz>
 <CAJuCfpHaSg2O0vZhfAD+61i7Vq=T3OeQ=NXirXMd-2GCKRAgjg@mail.gmail.com>
 <aXAkwLsGP9rqamKL@hyeyoo>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXAkwLsGP9rqamKL@hyeyoo>
X-ClientProxiedBy: SEWP216CA0150.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2be::15) To DS0PR10MB7341.namprd10.prod.outlook.com
 (2603:10b6:8:f8::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|LV8PR10MB7822:EE_
X-MS-Office365-Filtering-Correlation-Id: 67cdaf47-38bd-43a6-0b56-08de5889584e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVJpS3NVK1RuYk9WbDhLZjFhcGhacFh0ZDVucjBieXl2WUE1U0hzSHhnMFdC?=
 =?utf-8?B?clBESGVUQjJYcUtmeXZnNW8yYVNaaGtabUFRcjgxbEF1WHFJd0YrYTZ2Z1Nk?=
 =?utf-8?B?QmdRbkVuY1Z1bjRiMFRCR2kyYmc2aGx4TU9uRzZXQStvODZxQmtMTkQ1cVRr?=
 =?utf-8?B?S2xycEpZdkNPT2RPam5CZ1ZLbzlETEQ4Nys1dnArazJEWWkvd252ZHV5TzNH?=
 =?utf-8?B?YmVjb3RJWnB5Q1l3R2ZCR3I4TVlZR0haeUs2UjQvTTVXOU5qWkYyUCtjUG9p?=
 =?utf-8?B?S0VJZ3YrTWpOK2hTSXQrUFhKT1ZPT08rQk8zK0lEZjV5MkV2U1lLSU10VTE3?=
 =?utf-8?B?T2VUeFNNQ0VZUHNnQVFCTXk3QjBkMDJIcFVpRCtsWjVYYmVLMXdTN0VNNFBi?=
 =?utf-8?B?TFBSMytBNStvUmN4a0xkZW1vNWp4WDlzUEI2b05GSVJyVDVVNnJtVlVzcjBF?=
 =?utf-8?B?SFpIdVNkL3R4YlBZbW1JU2ZvRVhJUGdoTlJ5TGxmcmgvWHRaaGNOVXpRang3?=
 =?utf-8?B?U2JYeEU2ZWJqSzA1OTNHYnAwc0hhVllYV3lxNEpXQWZ2T1NyNUVZY1QvNk5l?=
 =?utf-8?B?d1JuYWk1eU5LZ2ozbTdNVUtvd1ZDVG56S1BtSldSbE4yMU9oZDZJTXF3UW1x?=
 =?utf-8?B?QXorcm1tR0VaUHZNVEk1QklkYW1nOXk4aVMvSjhLWFd1RzB3ZCtWVXIzMytM?=
 =?utf-8?B?YWFOcy9UNHV0WlIxM0UvN0F1OEtFY1pyUERxbHVxRzR1ZnpYZ0VGdlZrSWMz?=
 =?utf-8?B?MlZ4OFJ2QVIrTm50bWVGK0ZIVjMrZVJmWlV5dUJOUWNyZ1l3aGh2Zy9aRUNt?=
 =?utf-8?B?V3RmQXFvMStqQjhtbDFFK3dFQVpkZytjbjBoYk1oK01uSms3TDV2UDAxZHNm?=
 =?utf-8?B?azBrRmdMdm5STTB3QVBML1cyL1FYNUtuMFdqSFNBZXlJcExNaC9iVlU0R3hu?=
 =?utf-8?B?aGVLS2pjU3FjZ1BSUC9QdjJYbVdKcVFUa3hERHc1bVpLUUZEY1QyMjIxbDdl?=
 =?utf-8?B?QTN3a1ZLWjJaN2lCWVRWWXo0ZmVqRk95V0xYVlU1OXFqcXRQWEtMa3EyU056?=
 =?utf-8?B?aFY5eWloY2MzbHhZRkRqYkFObXJFakZRWTRlWXJ0Q2hzaXprRm4wdDZlZDFY?=
 =?utf-8?B?Qno0M2NSMnlIVDdya1VWdzFrV3pLMjdTSTlXR0FFRlVpMnJ1czdBRXJPc3ZG?=
 =?utf-8?B?RFQ4cllmWEZWL2dqdzJGNm42dFJYaUdrOVhuVDdpZWpudkxQSXZGZUdCZndH?=
 =?utf-8?B?dFdKd01pTFc0VUNrWkJFRER6TDFtMGtvUGdlVktlWnZGU3hML0JmSVpqanQx?=
 =?utf-8?B?dWpiTWtEZlhFbWN6czBGenJ1VlBEbk84emZnU3ZPTERMd2VONGs4QnRBcHJ2?=
 =?utf-8?B?c3JMeDRHMXltRkMwa2RsdWJDR3d0ZEVJa3VsbjFabDFQRzBWdnFPSFVnOW9p?=
 =?utf-8?B?elFwWHBRMGQzWDkrN01wYzY5ZGlOcXBvYk1mSDZnOURaNTl4RENMS24wdmpa?=
 =?utf-8?B?dm9sTFdFQ09ZaG5BUFdzY0JrTnRsa1ovYmJ2Z1lYQ3N3NDE4KzQ2ekM1cG5t?=
 =?utf-8?B?UHNMSHovbFY0TXZEQkdiaDZ5a0NNUnd5TW4rRW5EL09KMDdhOU9sNVM3OUJL?=
 =?utf-8?B?L00rMEZzWDBCYUZxazJsQ3NKS2RiajFPZVVNVlhBV080SmNtYlhNZFpFRVhV?=
 =?utf-8?B?UWpsSjNtUkVOdmRwYTJjTk1PNXZaRFV3V1FQckNKMUZaQ084Vm9QZGxSZUxl?=
 =?utf-8?B?UUJIRWdUcG9WYkRTVUtPazVGY1cyNHNEdjhqR2tBYTFieGoya0JZcWVJejVr?=
 =?utf-8?B?c3l2NTRVTnNXQ3lGcFhPNVdCVEVqWGtnZXEwY1MyOEhRT29NbDU0bzJQclk5?=
 =?utf-8?B?dVdpYlR3YTNOOEZEdmYzNGNBZ1BzUFdwRTNRcWRBbEVGbHlRN0pVK0JzTTJn?=
 =?utf-8?B?aTNPcXhhZGYyMFpDcXZJMHM5Z3Y4dVg2aFhOcGhHVlQvT1RXbjlST1hxb21t?=
 =?utf-8?B?ajZvelhqSlFOdG1jc21HVTQ3Mmc0L3BLdWpGakRWelVrSUxKeVNCYVduMDQ4?=
 =?utf-8?B?cU9PMng4eW5pQXJpVGlueFdQMnRDMHZocVNIWUlMSU44QmxwVkJOblRnU1pj?=
 =?utf-8?Q?Lt7I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tkk1bzBtbnVXVDRqMm12Q2NiMHVJOWNLY1RKQ2Rrajc0enVkSEllaUhFRitx?=
 =?utf-8?B?S2ZhOGxFVHBXM1JPRVROQVhOQ2V4K0IrMGR1OFpUWFlKaFRrUTR4NndMbEpi?=
 =?utf-8?B?MDIvVHlyY3M0bGQ3VWZSSDJCVCtQZlBSNFErYWFGcWVBdGErVGpydGRDdmhm?=
 =?utf-8?B?aTBIM2krNGY0bnZtQSs1TmpkYTNGVmcySGNCTkhQUzI1Mmlad1BOQ2tWMndX?=
 =?utf-8?B?TGtjbjhhbGRHbVIyRDdlR2hGZGtvWEl4eEFkamtxdVZVNU52QzdUVEx4U0U1?=
 =?utf-8?B?ZGxZTWNOc3dUcmtLNXdvVWNLRVUzNU1hQndBZFBtUjlpclovUnVzY1JIejVu?=
 =?utf-8?B?WkdDb1R1L0srbm9LNjBEaGNzWTlRdEpOZnZTdEdjYVdIVnJUNDkwSmxQbXM4?=
 =?utf-8?B?N1Y0ZTYwcm1maXdnUDdxdnJZTHU0Y1pRQXA2SW90L2F1VGU2OGZtMEhOdmI1?=
 =?utf-8?B?UEJ3bStRWlJkUlRVTE0zMkJQYUxMN3RWNTc0VEFEZ3dQWnZ3TnhpUjVIUEdD?=
 =?utf-8?B?S2ZUQklHeXRJNnM0NSttMnZBb0ptVnFqdk9HVUlCeDhJNys1b2E0WHBHejg3?=
 =?utf-8?B?N1lwSnB6WnZmcHFkS0RxZ3NkK1htMlpndTBCUmlrbWRmVS9WUWFBNU1tNUV6?=
 =?utf-8?B?SmUyQmhIWmRVKzl3bTlTZW9ZYlpVYmRuRkhlSUJxZzZZYmhtcjRIYmEzTGxr?=
 =?utf-8?B?Z2NjYlhFL3JRbEdXZ3NraFViVGhuaURDQy9XK2ZSWWNDUHpnaGt5aWNYZFJ0?=
 =?utf-8?B?bG4vZkhWaDBrbGtHckFXMmxiZDRUbmJiaVB4aHFSQ0tjeEVLck9LZlRqbFMx?=
 =?utf-8?B?bTJDTytpbXNnTGl4OGZFNWsyd0VHVXJOdVhDUkp6TXZYTDFGcEpzd2tDRy9w?=
 =?utf-8?B?eFg3eVA3aTk5SlNhMlg1N3hMUmwxdC94WWpiYVRwTXY1dHFJajcyOXlyMFg4?=
 =?utf-8?B?YXVlYlFtUjJQeSs4SWh2dXptOHZJZ1RkblkyUVpDa0R2UXB5M3VNWFFER1o0?=
 =?utf-8?B?dXJXZ2FPL0phV0R0Z1hPWlVXaWNCM1pESk93N04vU21tbXJJSXk5d3Qwb3Iw?=
 =?utf-8?B?dUFxdFJ4a3hkYjlub2laYU5CNnRiQ3NncDltUU9UQURoWmFDcTgzb1ZUelQ5?=
 =?utf-8?B?S3ZGMFoxRjh2TXRnNmlRM2VVQnBHc1B0QUdlT2duNmRsanIyTEF4TzExdzBh?=
 =?utf-8?B?bjBFangvK1B3RFpTTWRxRnd4ektpYzRBdHdHRnhPZC80azBQUGdMbDdOckJS?=
 =?utf-8?B?WGRQYUtMTURxbE1STklYeDNiTUUxeklzVXJBMzhTYUJNdkw4K0ZUaklMTTNZ?=
 =?utf-8?B?bkxycFpJUERPSUpZMTdnaWgvbnlkNmJJeDZ2VExIVWNpclp6NFlCQldtVCtx?=
 =?utf-8?B?RVlDeVNuSnF2YUo0elFoRWlkdGJtSEFUbTVkNEtrc2xqanJmR3ZQMXdkWk5a?=
 =?utf-8?B?dEZ0TjlkT1drUHNyM3d4MHFlVlhjbmVBeERSd0FrMEpQUVUzUXFCN3RmUzRj?=
 =?utf-8?B?VGphdDNDbXlucjNPc0ZzczE4d1QxUTlla3NIZjhxTGtBL0swWFVsVDFJa3ZY?=
 =?utf-8?B?YStBckRRWWQ4aE1KMEcrNkVnT2NEUDVGM3dLTGF5d0E2cXNNZWFmS0dJT282?=
 =?utf-8?B?QTdERTIyQ29iSGRmYi9PZkVMUEsvdTl4T0tJR3hNRHRLRUp0QjJ5N2djL01v?=
 =?utf-8?B?VVlhQ2N6QytKK2ZpY1BxSnZORSthVHZ6Mis3M1BsZ3AwZm93aVJHam5hRVhP?=
 =?utf-8?B?elpSeGhXZldHUFg3UE1BZnRXRTNFNDg5cURmVnZ6WFJodzl1MGM0R2lnOW9V?=
 =?utf-8?B?NFllRzNGQ0VNTkxDc09LUmhWdGVVMzFvR3FNZFJ2U3p0dFpzVkNvWmxnZklX?=
 =?utf-8?B?dEJobTlXOWVwRzFSYm5MSnRjb0dWbHA4VEdhcjR6NllCYzVnZ0Jrcmh1RDVN?=
 =?utf-8?B?YUJ3eE85V0J6dWZwWDRLYUQwa0EwRURlS0JLWDJoRGZPVWltZ2VOR2FJTWQx?=
 =?utf-8?B?T1gwYjV4dTBYZkwrY0F6S2pwRjNndjFlNEdqY05qRWxURGhEZmt0TWM0dnFl?=
 =?utf-8?B?QTV2QVRvbHBtV21RNERIeFNob1ZSREJVUHNucklCd2NnbXdTN01qK2diSkZm?=
 =?utf-8?B?TzcxN0VDdTRDZ0xnVjZLb0RIYUFhNDZkUHI1R3ZvVW1uM0hpWnhoKzFkWExI?=
 =?utf-8?B?VFJSZHB2RUNiNEtxTFQyWDdGekp0VjlJR2ZXQWxGUHhTc0Z3WDJ5NTNOR3RG?=
 =?utf-8?B?TFFLc0hLQzRhdUNRZEdkT3ZjQXpwTldEY1k2czRERy8xWjJZbkVMY013a0xy?=
 =?utf-8?B?OHZNNXI0UTRybmovT3ZENjFqWHhmdTZ3dlo0SHNwQ0dSalJKS2c2Zz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QG6imd5a7QUckIdCrhzT+9CKrNWBFhm685b7xtJ0d0rTFesAjV3L94auHNTRuZ8Vz1xAvaVi0DuSJtEPLTD6Q83UBnmERAqO18hOXGco5Ts1QEch8mMoT00Vi2fQjG//0Xyi6uodJtd3LMYpTBE9SfIVU/T7AipshCtPRqu2muqxRYkR/bTRyo+2+vb1L87s5gjehyB/9MVW7Okeq1/cRxa7n/xfwNhgk2nq7w+urhjYSiXchAeNr/8oN7Dq43IJiBE90UVHo/JRHlroOZFpgeNhpmRrlmOEzfpnEiqwanMTbUMXOcn3X/dFGhfuQtyGj2vURiiNjU8hlXwH8NkgCLaICIuGKpwbrKuea06wIwci1u9+hp8OUs5wwRvDvP+Q9Nmb1yE79CM29XgmbgDGRYybazeGQbqCGFumJT1cMM4a4h8NifINjrw5+deVKO1/nLGYGAx9w0CYV3Sz5f1kSbKVOkljkz+s0mQOOHSidJ7XZtl14afbRPwgoxZ8GeDc+zAGATDxuwZ5rPm6jq1zQXwgR/WC3WYxrUnUDnupF/8qlzq9QjJW5rB90m3QuvUePzWuf32mbZ7pwpK7T2MWqjz6jFOJgrIv8QdxSeyGZKE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67cdaf47-38bd-43a6-0b56-08de5889584e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7341.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 01:06:44.9921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CyrhhbB2dOTaG4Y2e/fvMfWIqLF7WsXc+tUxCDKIhbp/CfInXSnncreTRWjLn4Gn1YTrs3fnk6iMqAiZ30loCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7822
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_06,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=965 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210007
X-Proofpoint-GUID: 0Rrxh7mdonmBjsLj5GBju7_uPUH0ynGM
X-Proofpoint-ORIG-GUID: 0Rrxh7mdonmBjsLj5GBju7_uPUH0ynGM
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=697026a9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=88JjD3xRybQXUDNOIxwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDAwNyBTYWx0ZWRfX/qHyMH+AzNuF
 uRMk49DJhmQyoI2R+QdXlld3LdD47Oe3JZtn82YE8XnieG9K4/V06AN162ndWIO/f3jGO+uu/a1
 +kzvtva+OX1GU89HZ6tUwihwfxmWcxWrz2t4YecBTsBfFptkgUUq9LHU0z6VTY2uJtdlvkmByJx
 wcEiHcyLvbOmmPb8R2YZVv5ZSJYLOq+sG4r9NGRNGzf4lFtvaVolqcN91iENlH6jtUy5zDPQDX7
 oCRIIeufejNj6qeQCPiXlzD44TTIV4/VOiS7cpWLSw+Ci3HNybZ/9qJKN8laiaQRS4MsZxZKXdE
 CSaOw3Shfk4iz3ZElrHStRy8fL7bdvG4h/1cw8viqguF6Sr0xtR0b3XAdDhQf1qvQnP0Ko/36iv
 0VxQggR7nQdDq/z8Du6VhygUPwP0Yu5nXEOTDqDbnNDZKOL9t2lL8bhE/8+2CQhNrEEOEOe/w73
 3luGpPgtUY3iIVGfHtt6oaq1vCwUv2kWgaeAg6nk=
X-Rspamd-Queue-Id: B6DBAC0005
X-Stat-Signature: zqqq69m87xmzdir4y7hm547rgn689drp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768957614-181847
X-HE-Meta: U2FsdGVkX1/5ApjDdtXxwy2z/MxN8a/qNZLL2rq1HdmLWas4YQjw9/5rVcw4S2FQySrkAgp1yUsXUPQNgW4tN/JOnKKphcjN41aONPoKMrt8f1+ZhksIOvVZRZMEubwpwiK1fePCAqMMf+QFRc90P9evH0LhsPvAjfo+k6KF/Cc5gr6HfgrEeNOrbxoISUnkTPF0yi9xt34TsVg/mRcXnH1W7lLzXeybDxT387r7cMm8P5rVkh63lCPvBt/aA7Z67L7AZDEl6TJRdrpYmWHi/lhlm1kAJDUXzrs5EgD0zRp4b0N+d/D1fTBR70imzh0xkCjbR700zEVRVC24WGTdQ4eccAVEhjssM1OjWMhg+0cM/iRkIvHO3/ZyBfOOofufzq59UIF0e1fbGtRnjBXCtjOhQWrsErBSIG/l1YuMwp9CKg6U8ahzZfupV8zALP4clIzCQbH4e3h2uxy3CBSwNqk82yddoXtLmHEzNCp2Um6cKijwAYw2NRnuw6i98pWQ7C0jBR6a7df9FIZFdi5VR9DKpdlVP/bout3rIrzTnW55YOoW5ToPKc5frip5gQHF9oks9toxNsdoDmXoc85nkzjgcTJ5IbY/m9vJvVYys+Yv2FK2J+0hgL+GDtpes4jzD98OvzCDxBuzttJa2YvzJsILH9DiWnybGU9DTsU+gLTp4Vkq/yxlbCdWzUwKQOzLj2RCvLpBC2VkJ0rLAEQ1NjltkijvRgYwRPOMVRjxIX4JQXb7IZdeDlSLDAfjMtbD1UU+HFyUFlZ39UeAf5OlGSrqe6twfK+wdb3ATfmTaeH2GPLrbH88t75dYeMOJhRvVT+W4kHzW7WhR8aG9+OzCZI4IPLVJg3n9FI97sjoebQYujb8z/UZlpTRTYavGt6Hss7H0BcsvFVIZpJ8p7g8/y/wYg27P7Se1tpmZE+5b5mF6el8ZYK/9mYCl7q0qIawTaUt+XZtdKXXBgapa+b
 cvEBD6SU
 ZocoFQvEii0HUS6Rk/u7Od+wzQsu4v0OuD0F9kwVKmeoRx2yqtOT95n+48/tafKo+eiyrChZNUbeWTTmXj+feUfpGtQCCjrYdfKdAKTuLGRPBcIBML7c42HuxWsqNzyQ8hBR8fIH7XEDX9YTZIPauzTXcvqfc/qFRKEDdr7npgAGYsGCZQHsHY0FUVbbZKOAXolwyHQnHYi++Igvd4jWEmrWpXV0mTtV/Gx0fOMEZx3ppSjmpk/xT5vqJaiyGWTxPkigu2olqkjOmuoUPEqbftRGah01+tH1FldEIrsOXt1ouxmnl4AjTu+BDKiy3VROHX+JunRkm3rQrmLvSoz9TNyEqpbcWN5Kdy8WD14h7bBeofomNY4H/uZ2oemXiCMGzVpQuDBNUMmnwhio6EAWr+sfGIiXTyFxbFn3NkLKAOD0oXEyjwRAsC/Ti2vP+SzxP3MDCgJHXZ4tDpUqhkN7062CU8kL2lkZba687UXKJN/6q1orVSbR7TlazcP8Iw/tl+1KAx4ulxB+mroqqM8/omwPXTwm6pOzNrCuq0UcgPe3an3m313H0NzBE8APan+CSXNRteMDriSgTcNZTRv7mx/+9PBIg2KCTxSvOyEf7CPrxEHsTo+jYJrb11nKOGYFbTCO66EqFVjKCVeUkcfcl+WZZpax3kea5ahJDZZ82ahT7pf01wkL8fmmTfXbgIpBFZtzvcXQ2cjB9Csrr2mxWQS6hzaOTXM/X0XvfP8N1F8JOECA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 09:58:40AM +0900, Harry Yoo wrote:
> On Tue, Jan 20, 2026 at 10:25:27PM +0000, Suren Baghdasaryan wrote:
> > On Fri, Jan 16, 2026 at 2:40 PM Vlastimil Babka <vbabka@suse.cz> wrote:
> > > @@ -5744,10 +5553,9 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
> > >
> > >         /*
> > >          * Objects left in the slab. If it was not on the partial list before
> > > -        * then add it. This can only happen when cache has no per cpu partial
> > > -        * list otherwise we would have put it there.
> > > +        * then add it.
> > >          */
> > > -       if (!IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) && unlikely(was_full)) {
> > > +       if (unlikely(was_full)) {
> > 
> > This is not really related to your change but I wonder why we check
> > for was_full to detect that the slab was not on partial list instead
> > of checking !on_node_partial... They might be equivalent at this point
> > but it's still a bit confusing.
> 
> If we only know that a slab is not on the partial list, we cannot
> manipulate its list because it may be on a linked list that cannot
> handle list manipulation outside function
> (e.g., pc.slabs in __refill_objects()).
> 
> If it's not on the partial list, we can safely manipulate the list
> only when we know it was full. It's safe because full slabs are not
> supposed to be on any list (except for debug caches, where frees are
> done via free_to_partial_list()).

Of course, when a slab was frozen, this doesn't apply and __slab_free()
explicitly handles that case.

-- 
Cheers,
Harry / Hyeonggon

