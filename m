Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D295AEB2711
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 21:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3708E6B0005; Tue, 10 Feb 2026 16:02:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323AC6B0089; Tue, 10 Feb 2026 16:02:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D14E6B008A; Tue, 10 Feb 2026 16:02:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 077DD6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:02:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B18541B3790
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:02:22 +0000 (UTC)
X-FDA: 84429770124.02.E8DA830
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id 21404A000D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:02:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=R+XSx2eQ;
	spf=pass (imf25.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com;
	dmarc=pass (policy=reject) header.from=ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770757339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NkUnKFBt1/cJ6uMnUOK6fFaV7ZVDb8iDYctQ9kriu0=;
	b=fAJFBZi1v/UIcPnI84ptCSF6stbbFkLAoGmRXMkratIrE+c919xcDABaAaCr/ZcjrOukFZ
	FOWXoHqVQFLIGbVkAMM9TNRa7wrPZxzoK1FelEtJ1GCD6gXE5emjQsbxp7JSPMvZA62UE1
	Dz2z18LFu/ZVpC1JmMXsSClMp8EBhSQ=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=R+XSx2eQ;
	spf=pass (imf25.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com;
	dmarc=pass (policy=reject) header.from=ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770757339; a=rsa-sha256;
	cv=fail;
	b=YHMaATCP4LhKIoMcgyxlniTpm5bCoO2PkpeUNcKabdk4d76rpLBt1wl0h4+EbC6fZLi1DW
	2qc80gwURcAhJF66uyRmKAOoiUHiKxueWakgO/jJsnxmU8/f0qmL+9xul4Ni0CWHLcqyCZ
	wiRhoGngRG0Jx8Xar8a9fgJgo/TL1LU=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A8URmb238024;
	Tue, 10 Feb 2026 21:02:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=9NkUnKFBt1/cJ6uMnUOK6fFaV7ZVDb8iDYctQ9kriu0=; b=R+XSx2eQ
	A8/yHVDC468aH8vsiIyhT/Ops8kM2mA50ytPdii4/uOKAwcX2OJPCk1pf0IDLZec
	boHzk/2kVvJ1NmsArVKoQ94R7qeHhrNa/HJe7ch5wCRpiN68B3FMlHeGkd1qJnEG
	xWdC5ubXV7q2Uvxlb5w0moyS4k3d4UknmGIRgg7gktBvLTRMBdNH+A6BqbsgXSII
	X7QrgvagxIYjj5LUoUlx5xtmzUdnPIwYqoYJdpz02LMogNe2OrpnO/59AJPLn9//
	d4e3SMIfmv+myAecme7M9hpMmfRNKKpsCf21fqu+MU5Fow9c5oOBYfNBOVStiUKF
	ik1lpbEQCXilGg==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012027.outbound.protection.outlook.com [40.107.200.27])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696w6auf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 21:02:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DucU6pzC0dj6k98E3dWsFzrNxqtzJLFNo7wp+GwoPoY28e4EDUUo3LY+dEgCGbEnLI5GgS/LWd0cbD5l6ai883N5MEsuq7w8/SFiiORBS9xGSeF5skWYmcSAx9fSvfonl9qSpt2K/DlAe7yxjXD8fLl4Az5suz5xGnMkednhkEWpukfcmw6/7i+weyAJtSJE2R2L07jYNT1IB74d+Bi8lNdxWmI5Ial8e7tTB78C+KdJIOiIqoDpE3xl090pTfKtFY/JCKba6bQcFRLwBGrI84XGhVg8E6o5ScWN9PyoKn1eDD7858tZkNbMEacV13b4hUCdNpD3EyKD3yiP8tyxjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9NkUnKFBt1/cJ6uMnUOK6fFaV7ZVDb8iDYctQ9kriu0=;
 b=kfofStbGDIkADrBpknhXQWMkQiWS5l1vkO3El2SvFzjHEK5ZEdmjxyd9rXqj5Zum4oAcxZQVP/4OyshMVpAmqS8FIplgPSRXtHLiBXgbCIz1ARlqs7aq0vY8phcHgytNY7qMQnK5pKrm/opcapZCxfv3vXRQsUfz0b57p8QCcxd8LWePupm6Vn9g227JGBkZTlw0maKcfFlDsG4MCxwJVU00qPXlYRtjINedpMB2he6dIemJzAQ01QnBE3IWL8IA6Eje1aLto4AjBiIA0a/dqx95k+8o3yqfB2NzXXxcZrokybeBRKRc5DLOcpybJBavwJ03miNXWFppxT9qfi1rBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ4PPF860862157.namprd15.prod.outlook.com (2603:10b6:a0f:fc02::8b3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Tue, 10 Feb
 2026 21:02:12 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%7]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 21:02:12 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "jack@suse.cz" <jack@suse.cz>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org"
	<lsf-pc@lists.linux-foundation.org>,
        "chrisl@kernel.org" <chrisl@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Pavan Rallabhandi
	<Pavan.Rallabhandi@ibm.com>,
        "clm@meta.com" <clm@meta.com>
Thread-Topic: [EXTERNAL] Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Machine Learning (ML)
 library in Linux kernel
Thread-Index: AQHcmpPXPV+chNeGskiA4zJOQ4d3LbV8a+KA
Date: Tue, 10 Feb 2026 21:02:12 +0000
Message-ID: <11f659fd88f887b9fe4c88a386f1a5c2157968a6.camel@ibm.com>
References: <47d21a6821c4b2d085f7b97bcdaa205bfcb0e0ad.camel@ibm.com>
	 <CACePvbVH0ovOcBqCN7kJ3n0QFmvuf+_5tMeRXs-JAQ+m5fdoCg@mail.gmail.com>
	 <a994bdedca7d966168076044249a58e52754c6ac.camel@ibm.com>
	 <6ek3nhulz72niscw2iz2n5xhczz4ta6a6hvyrlneuyk2d36ngx@4ymlemzifugr>
In-Reply-To: <6ek3nhulz72niscw2iz2n5xhczz4ta6a6hvyrlneuyk2d36ngx@4ymlemzifugr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ4PPF860862157:EE_
x-ms-office365-filtering-correlation-id: f58923c1-c896-457e-3e99-08de68e7a966
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Rk5YVFg5dDRWRGNobE8rVUQralJXWElDQytLY2JJQjg4OGk0SnV0Zjgwb1hw?=
 =?utf-8?B?Z1U3cDBHemtNSlJqa2d6V3pBeGYxNlFDSU5yWDI0RmpQSW1XQS9vNEFNUXlW?=
 =?utf-8?B?VFF1ZEU5UG5GRUtDaUVTR25ISlI5RHRqS21DR28rejNDR3hrWlNmWjVaRk5E?=
 =?utf-8?B?alQyV2U1UjdzUFlmLzhQNkRrUjRHTjBzeWVOQWRJTzlKWWN6OWFzYzRaMGJ5?=
 =?utf-8?B?aWZ5NFl4QjMxQXo0WTFoZkYreElhV1I0ak0yZ3VWZUVTVGpSSkVkYkNxNDhr?=
 =?utf-8?B?U05CSDVnNHhNOGw0WFU4TkovZUVuaHRyL1c0OTBWMHk1djA1b1RKREVtSWZZ?=
 =?utf-8?B?MTNzeWtXUzJjbG9LK0gxTkZSbWU5Rnk3b3g5KzlScHlrdU1mbEVrU3psSkRl?=
 =?utf-8?B?cU1XSHRGRXljc2g0UnhBN0FnRjBIUHlxY0FGZHBDZXE1Z2NSYjBRdkVzYUp3?=
 =?utf-8?B?QXR6UmJyQXVHaHdsU1NuTG95RS9wMmUrMXlIL1FiazZ3d1VVR08vZDhFckFE?=
 =?utf-8?B?ckZyYlRxY0J3NGxKWFJ0RFJvZjRYWVhIMUNJakN6NmY0RWFnZU5HSGdLM2Yz?=
 =?utf-8?B?b1NpR21nVEdhSjRzUFhLbXB5eGdOK0tYb1BaMnlubFd6d3F0c3VZaFFnZTNR?=
 =?utf-8?B?MDgyeFAyZWJhbkJNeXRxTDFpOHQ1WTl6OWVDY0xVU3c1OTVyWEpyL25tSnYy?=
 =?utf-8?B?cHByY204RFp5WlBpbGZJK2hrNVFCT2lQNk9DZXNtVVVUQW9ZZVF4MG5GUzNB?=
 =?utf-8?B?Qi8yMitaVnJjRmlRTC9kM29XQmh6ZHVRY0JVd2VlSU1VSmwrMHYyK3M2aGlR?=
 =?utf-8?B?Y1dBZk1rNkdHNzFXYkVBeEp5b1dJdUFiZHh6cmFIYWJiVS9PZCsvMmtzcFdR?=
 =?utf-8?B?N2ZqalI4ZmNWMldKMmVUeFNqUk5rbjBaV1NGU1hZcW9hd1R6U3Fzc1htVXA2?=
 =?utf-8?B?UEhmc2RuQ3AvdFFKMXRLTmsyaG5tYkhmM3VUVmdrTDI1RXBiWThrMlZ5aDVJ?=
 =?utf-8?B?cWV4UkZ0VGNXcGlib2wwNWswaWFGZ05RRkNpSHo1ZHRhdkNwcUZ6OWJVMUNo?=
 =?utf-8?B?YitnemxWdm9yZFpBSldJbTdiNTFqZlMzL0tndi9NRE4zSDV1RVU4d3FCREhj?=
 =?utf-8?B?c1VFK2tOMHFRbGtBYit2cGJ5YXdRb2I0QkJVNEVuZU1NeTMxM21uNVAydkg2?=
 =?utf-8?B?QXZQNEhzczJxcjFGK2dtYXdzRnd1UWl2Tk9Hb1g5M3B4VVRNcGUvUFN5NHEv?=
 =?utf-8?B?UUNNd1lhZW5KVkx6OWwxN1BETGViZ08wdlZ2dkc1ZmVmNzlEd081S3ROZEpC?=
 =?utf-8?B?aVpUc1pvaWJjVDlkK3FzemV5SWZUVDVaTUc4Ylo1WWZXVFBRWkVyUndVYXo4?=
 =?utf-8?B?eU1KMGljUnNVQUN4L05zcDU5ZXZHL1htdVRhV3lFZjJuODM2QXRFLzNTTVgw?=
 =?utf-8?B?YXEzSHExZ0wvZ253cFRONHhXN2NZTW1HRUw3RVNiRndNZEovUUM2dlJOWXBL?=
 =?utf-8?B?eE9MbW50NlRaQVgxT3J4eDlieXNlTHN2UWJ4MUZrck45dmtWaGI5MmxhZ3dm?=
 =?utf-8?B?Z05GNjlJSzUwVTBhQXRGcEpaS25PMVkyT28rQjViWDdkWnBrN09TOXowSWlX?=
 =?utf-8?B?c0hHdks1WkMrTjZTYzJhOUFDaGQ3SFNrTUhQbVBhT2dheS9qZGFBQUxlNENa?=
 =?utf-8?B?VGMvOEU3WjcxSUtEVWNsb0lJZEFlQi9qbTNsOEIyeDgza0k1NG5MMmhqWlFl?=
 =?utf-8?B?VnVMV0FKQW50aTBPdUdWR2hHMVhoZURpSjN6YzZuOWVUVlVUZDRudGQrY0lM?=
 =?utf-8?B?ZW5mcTJCR3JBL2VoN3NzRFFBL2tKOXRHMU9xd1hjRlpyaFBjMUJ1bWRjcVF0?=
 =?utf-8?B?YnUvWjJZb3oveFZQbnhBMFRJUjgvd09SRDdZRWlLZitneDN3TkRYclFKUHB3?=
 =?utf-8?B?TnIrbzZBMEtZWU5ud2ZGemIySENBckhrMGFmZUVUV0xpYUtLTDNBNEs5ZG1j?=
 =?utf-8?B?aDdhTEFTYjN3c29WOHBIQjhIY2c2bVo2NithMFpieDRPaysyeUhia3JHMURU?=
 =?utf-8?B?NW5VenJxajhlRnltRmNEM2NjQk9ydjc4ZHNwSHRzR2hBTDdIZzhkWVlJeHkv?=
 =?utf-8?B?TDlBQ3QwcFp5eWtDcndpUTNEeFlsMmdSaDQrWjB5cUJLYXBRNXk1dXNWZnhp?=
 =?utf-8?Q?y/Y3cohkuS2Tm+2+6HjC4a4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YlUyamFFK3J0ZTcyNzJtTnJRR2cvRGp6OERvL04rU3FGMzdlaDVLZXJVVHVz?=
 =?utf-8?B?MFQ5TWlTTllraVdjS05Oa3p1SlN2akU3LzdQaHlkUUhmS29rWEIyc1ZGclZK?=
 =?utf-8?B?VGJIMFQyTTV2ME5SWng0TU4rUkZSaThPeGJaRW9vSkozUTltVktSNnh6cUVK?=
 =?utf-8?B?UENtUkY2Qm9WUGFVb2pER0JuTS9IMW9wTlY4UW5xYzRBVlV0K3p3OWc2aXlF?=
 =?utf-8?B?dFFhZ1ZjeDBmM0FIL2g3bGxwTjJXalR2TVNMVVhsbnJkczZRMDVrT1ZxNEZ2?=
 =?utf-8?B?dE5HT1VwWHQ2djNoOW1DRlNvWE8zdmduTk9rK0luV1p0S1gxd3o4alhKcDdY?=
 =?utf-8?B?MkJKbmhPVWVmdk5WdlNNbmhCL3ZSZnhLUXJoKytOVUxSMllkdm9qZXFwcW5u?=
 =?utf-8?B?YTI2RHUrKzFQbFcxeDIxYm8rU2wyZDNyTDBqVDNidkwrZW5Nc0VzT0ZCNHNx?=
 =?utf-8?B?cHFhUkQzRHMvMVNQdlBkOFc0RFZkT3pZVkF0Nlo1WjBreU81eU04azF3UjJL?=
 =?utf-8?B?UTN3akh5ZXFlQ1dJTmIycEtXYTdqbGw5bWRsck9uOHE0YUpoekxWUG5JUnZu?=
 =?utf-8?B?MEtqaGt5bE9zV2E2U3BCWll2dldpOCsrSlROUkdjM21sbkxiSUtrVlBXTzcx?=
 =?utf-8?B?SUJBcFVEUHc4T3NPNWtRTXlFTVEzNXhrTGRKa0NhU0cxak5BS04vYzVPYXNj?=
 =?utf-8?B?L29idlVXeXhuOTJGZ0hRdnh1WllBWXgwVTcyY0RXMXpFTHdXcVkzdkhtN0pH?=
 =?utf-8?B?ajNKYTZ5aHNuUWd3bGN3RHFTdXQxUkNNb2ZEQ1JGSE5ZMVNYVjVRb25SaytM?=
 =?utf-8?B?SzQ0N0s1TGZ5U0dGblBWUGd2UEx5R2RQSEY3ajlmS2R1QmRpbEZXWm50blkv?=
 =?utf-8?B?MUsweVdXR2RZRkZxK2dyTXpRaWQvV3Bsd1dIUUJtSnQybnlGc01OWTV5a09w?=
 =?utf-8?B?KzNuS01VYlVwMU5xa1dPZDVOb0JsSStka3Z3K2Y3N093ZlVnN1JjK2FrL0E4?=
 =?utf-8?B?c2F1WmpGM0VPNEFwdERSdzljU3BJUGFFSlduTEpiai9IanZGbmhkaXpYMkI1?=
 =?utf-8?B?QnNycmVNczJ2dDg1b2RJTkNPbnN0NjMxTy9HcnN1VnJaVDQxY1JvOGRXMUhv?=
 =?utf-8?B?QWhlekNaUyttQk1lbWlnSk5oWjk4c3JJcUluVW03QUlnaWdhSmpzeTY4TjR0?=
 =?utf-8?B?ZHd2c2x4S0NLSi9CUG1TNnZEeWVDNlhpMklrZDNiZkxFaEhpNnJHc0ZHTldz?=
 =?utf-8?B?Skw1SEcyUDZ6ZkFFQ2t4ellNY21xdmZKQmQyTlJqcUJPcWsxRGhoa0FKWUxY?=
 =?utf-8?B?T0E0cTYwZmdvRE8xYnFjUmdhWFNXZFpIcHhFSjBjR0NSaU1LcCtyUVY5bG45?=
 =?utf-8?B?NExmckxLeDQzWTZNY3ZFQzZ2YjRhK3ZnNkVQT1BqZXYvUFR2WGdxSWx0aHFv?=
 =?utf-8?B?bDF5bTYxMlRoeS9IVW5zWEFFdldic05ObkJYYTVtaERjMThhN0xkcXBiWmw1?=
 =?utf-8?B?OTY4L2RQNDI1aGw2Z2tSTk9GQytPSk9RSStPWG1xMy9zdVh5ZndYVHhkVUl4?=
 =?utf-8?B?b0Y4QzkrSmlYQmhsZW5MLzZyVXFnWmJkN3QzZ3lld3FKZWhPWXJIRW1jTU5L?=
 =?utf-8?B?WjRYZG11ZmY0bENrSHFxek5QNHNGWWFIY0pHQzJ0OTVveTVhNE9hTTlHeWVF?=
 =?utf-8?B?N1hXQjB4azk4eEtjYk5KcGNEdkdsV2xqeEc2UjEwRVhpNTZkdm1WMnFwdVlr?=
 =?utf-8?B?MkgvdVZocW5zOW5pcVVnSVdtWFZlY05FY2JJRHl4c0ZEOTg0SEx2cGNNK3N2?=
 =?utf-8?B?MWxuSlFlTmVGcmhuNHdxN2trS0Y4NVprOHZOb1VNb0xXVmZUMnkvS1dmZzNn?=
 =?utf-8?B?cXZXM2l3NTZHbHU5S01XMzc2THZscGc2bHFxZko2UldUMm5kYTlSa3NwN1dG?=
 =?utf-8?B?cFVDMzA3Z1N4cldDdFlHTG9Gc1NoamgvajViTExwNjJTL3VJRFhtRXl0RFVX?=
 =?utf-8?B?NzQ1SWNDUjhtQW5TYU5rRTQ1dzZvQVRoR24zQkx6YkdVTEJFMlF3VUJGenFW?=
 =?utf-8?B?YVhnWTYrQWYwb2dDL3VLbmR3c2VmZktYM0pCNTU0UmovRXAwLzEySkF3SVdy?=
 =?utf-8?B?RDR6ZFhhajVpYURqV2lVc2ozUjE2QzB0a29GbDJMT2VVa0JJQU9iRjJiOEpv?=
 =?utf-8?B?MTVUTlZhSThrN283OVFzcGYwZFptRTBLTXZFY1NOTXNUV2p2SXh4TTZVNGxq?=
 =?utf-8?B?NTVJOFNpaHJheENZS3FlWW1ZZk1FbEVhQVkwU1V6b1VGNGpianpLZUxydExU?=
 =?utf-8?B?bGRCNUdoekxYMnorN2EwNnBoZnM3RFEyRGViV2t2OEFFQmc3THNVZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <097C37DBCCD3D641AF2897A559CC82F0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f58923c1-c896-457e-3e99-08de68e7a966
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2026 21:02:12.1793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CIVgGht0sTf9/urToDUUrQtRLC2ouHYfhBbK+YCJx3QxCuX6899p8BTnB43yfS6iMVtbOwhH/VOK/1ScsCd8Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ4PPF860862157
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=698b9cd7 cx=c_pps
 a=ScYCyfYCeG8NXYeL6jRcjA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8 a=VnNF1IyMAAAA:8
 a=HGlDu2oh7kANvq8MYyMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: wcuPfo8fzx65rrayk11bu5P70Vog4Ppw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDE3MiBTYWx0ZWRfX5hkCEWyOWK4N
 vR026hlNYR1Gu7sCC4q/g8dlK5tc68lrmO/fCvYoMHg/dGon4IOkwr6VXCyDPuzml68XudD1cLR
 xb9sc03oncwOxbPBWf4RHKlQ5yxYy7cLRwFJtiGHpY8joZT19X5c8IigC1PXGzQIlEcxf8pMlId
 KQueSKWBmSrdCIeA5OGT7XvxlB/TGdA0TOB0mTXMqu095o0YQe5PzVPWO0b8f/QoG+jJPJu/LCq
 enyFeUTgLX8U+BLlvsKfSI6bSCyAYJtU3+YqdyOG3D+gKUTK0Hx1TSyyDhidKu4WptVbJRSBAHL
 nCxZ+0an9ytL0Np9K45kHBstIrco2sr/wHvvUfxuZMzrgyXC4Mxh6E14vNnUoS+zW2w+Fu5bYp5
 dhFOUSvYUHUqZf/ztgxhIAzEIiK3vFyQT4XSvSwmtTg3Wyjnkbrdwg1YDIdLw4iJxAYgjTNgYBi
 fVlooViYsRka97H3cSg==
X-Proofpoint-ORIG-GUID: wcuPfo8fzx65rrayk11bu5P70Vog4Ppw
Subject: RE: [Lsf-pc] [LSF/MM/BPF TOPIC] Machine Learning (ML) library in
 Linux kernel
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100172
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 21404A000D
X-Stat-Signature: p73h53qq5a6h6boprmm1ddf7gfm8kg1a
X-Rspam-User: 
X-HE-Tag: 1770757338-838442
X-HE-Meta: U2FsdGVkX195fFNy4iMBwkcp2CeLfPu1DT/5tkptppTPycgEt9tYqCqP00blSz+GJd2aj3WJgeAFeN93TJHYRk/DKMBS7oieeYWzQLqMLPli0g8b63vxIs9/YTvQxYEltWjDeUWdWTne9MD0c3GeSoC/6pOLhTdP1JlIkQfoJkbUZwCWVwhtUlQaRveXQrFFdR/f1ZbH7zbpmmR4HV6Erya5oxOP3H4x7Dw3GTvggetxzgajt5UX4WHgl3jQlDT0VugzdfQTR4Zk428buZHlN8wTIPYV/hYwv5jRyKB9K75IqRkJMg1NbV/u+g1N+eVttF4dP4/wmUbooAfl9wPaWYvUtq0WQj2m02kSzqeE4NWCfkD3ALxqDBFLOMEPdjGIWZ7C5+bbrSCoGAe6+/TBIJUaXB/ZqmtVoRHWuTLa5QtbsyF9sGKwn7IU4RF0EBHIy/A39eVWiIdGBB3qnFZ6EWwgNT4EZaDKsAlaZGedf9yaxn29zlQgCEO61eTTQNp/rKPOG3utMLZW7cCH+cHaxEc6xl1y+I3MfrCVaDLgREw5ZGhItJGTVUDXurD19mfXbi9NokJAnsaI/rr3CXdSlwlpg7mcBqcYUwH2XkwZWcgXzDBN/NaRN9gARLjJx+D3VfyTznUqfZgJvI3kslxv5EwJmgYgPbNWW/cxwJ1zlzEqEFlYdLzc/g4uXcMttIFkorcUnUQP7tnnOAmhzKU9o45aainpHP6Yy5M9zPwm0Cc6uMXwF67dRXbe2CaKE8u40XUduLl+Bma5g21n3qsT+tHqrWs/isaS99qWUjHXYc4LlW90Lrs71IgEcDu6ljM2H4ctla6XqibbJZpoImWsVa4MwLcNjvPsnKeFYk2Z7m7w0DOSs07E6N0hqOmVWaKwJoHeN1xbVCWrLDoVuIMSuT85o2hlKF7ocZ3tvyknKZm3LxTdzdGJFkebJGOFun+PxGWlFCt5FbJk4btVnsP
 uVO5uHh9
 R9VSolfBpqzPQoV/xZq3M4dwu92ePOwu5tzRAV0OPcBtQwmEuCqzApK10USEpmh3bhJG96lpJ4IcsMqYHNFoNYC/Ok+TPqr0ZWDxONaLMB/Yk7fR7Hm646odr7ziZHcAk8myOTc7fQXMhXzenhuArqvVAcQOSFV6lYujrw7XI4zMtqZiv8RlLLigdDnEqdCGNkc6iSVjl6Ru2vtUXTgZFWQy+JGUt4OkWiwjlZEPIkpBb9vLqHzR2aT3LIWcr7EwwXeSlqfujRvdU2gSaVC/okLVYDPQ4U0kvDzqzyp74eossW1tQBNB2gYZbaTqs1qW9ieuXgl7+v1n238OzF4FEwMvfbF+u8DE7cH/9rnWR6ZA9fotKsrASO2WdPUwLsap0uVnchQIr1kZzgfEenL5fm4xgpSzngipa+wiZaLqEazluXOQaHR78TRYwI+tt8i0ByBwjGPgZZiZdjUXA41lExe+a+55h+d4JX235Umhn+dSE4+NCTqvS3JJhUgu0ILFBMBB/N6chWnm8uQu9aX9fiO1wWBXsIKxsosoqZmRiuEO66FQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVHVlLCAyMDI2LTAyLTEwIGF0IDE0OjQ3ICswMTAwLCBKYW4gS2FyYSB3cm90ZToNCj4gT24g
TW9uIDA5LTAyLTI2IDIyOjI4OjU5LCBWaWFjaGVzbGF2IER1YmV5a28gdmlhIExzZi1wYyB3cm90
ZToNCj4gPiBPbiBNb24sIDIwMjYtMDItMDkgYXQgMDI6MDMgLTA4MDAsIENocmlzIExpIHdyb3Rl
Og0KPiA+ID4gT24gRnJpLCBGZWIgNiwgMjAyNiBhdCAxMTozOOKAr0FNIFZpYWNoZXNsYXYgRHVi
ZXlrbw0KPiA+ID4gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4gd3JvdGU6DQo+ID4gPiA+IA0KPiA+
ID4gPiBIZWxsbywNCj4gPiA+ID4gDQo+ID4gPiA+IE1hY2hpbmUgTGVhcm5pbmcgKE1MKSBpcyBh
cHByb2FjaC9hcmVhIG9mIGxlYXJuaW5nIGZyb20gZGF0YSwNCj4gPiA+ID4gZmluZGluZyBwYXR0
ZXJucywgYW5kIG1ha2luZyBwcmVkaWN0aW9ucyB3aXRob3V0IGltcGxlbWVudGluZyBhbGdvcml0
aG1zDQo+ID4gPiA+IGJ5IGRldmVsb3BlcnMuIFRoZSBudW1iZXIgb2YgYXJlYXMgb2YgTUwgYXBw
bGljYXRpb25zIGlzIGdyb3dpbmcNCj4gPiA+ID4gd2l0aCBldmVyeSBkYXkuIEdlbmVyYWxseSBz
cGVha2luZywgTUwgY2FuIGludHJvZHVjZSBhIHNlbGYtZXZvbHZpbmcgYW5kDQo+ID4gPiA+IHNl
bGYtbGVhcm5pbmcgY2FwYWJpbGl0eSBpbiBMaW51eCBrZXJuZWwuIFRoZXJlIGFyZSBhbHJlYWR5
IHJlc2VhcmNoIHdvcmtzDQo+ID4gPiA+IGFuZCBpbmR1c3RyeSBlZmZvcnRzIHRvIGVtcGxveSBN
TCBhcHByb2FjaGVzIGZvciBjb25maWd1cmF0aW9uIGFuZA0KPiA+ID4gPiBvcHRpbWl6YXRpb24g
dGhlIExpbnV4IGtlcm5lbC4gSG93ZXZlciwgaW50cm9kdWN0aW9uIG9mIE1MIGFwcHJvYWNoZXMN
Cj4gPiA+ID4gaW4gTGludXgga2VybmVsIGlzIG5vdCBzbyBzaW1wbGUgYW5kIHN0cmFpZ2h0Zm9y
d2FyZCB3YXkuIFRoZXJlIGFyZSBtdWx0aXBsZQ0KPiA+ID4gPiBwcm9ibGVtcyBhbmQgdW5hbnN3
ZXJlZCBxdWVzdGlvbnMgb24gdGhpcyByb2FkLiBGaXJzdCBvZiBhbGwsIGFueSBNTCBtb2RlbA0K
PiA+ID4gPiByZXF1aXJlcyB0aGUgZmxvYXRpbmctcG9pbnQgb3BlcmF0aW9ucyAoRlBVKSBmb3Ig
cnVubmluZy4gQnV0IHRoZXJlIGlzDQo+ID4gPiA+IG5vIGRpcmVjdCB1c2Ugb2YgRlBVcyBpbiBr
ZXJuZWwgc3BhY2UuIEFsc28sIE1MIG1vZGVsIHJlcXVpcmVzIHRyYWluaW5nIHBoYXNlDQo+ID4g
PiA+IHRoYXQgY2FuIGJlIGEgcmVhc29uIG9mIHNpZ25pZmljYW50IHBlcmZvcm1hbmNlIGRlZ3Jh
ZGF0aW9uIG9mIExpbnV4IGtlcm5lbC4NCj4gPiA+ID4gRXZlbiBpbmZlcmVuY2UgcGhhc2UgY291
bGQgYmUgcHJvYmxlbWF0aWMgZnJvbSB0aGUgcGVyZm9ybWFuY2UgcG9pbnQgb2Ygdmlldw0KPiA+
ID4gPiBvbiBrZXJuZWwgc2lkZS4gVGhlIHVzaW5nIG9mIE1MIGFwcHJvYWNoZXMgaW4gTGludXgg
a2VybmVsIGlzIGluZXZpdGFibGUgc3RlcC4NCj4gPiA+ID4gQnV0LCBob3cgY2FuIHdlIHVzZSBN
TCBhcHByb2FjaGVzIGluIExpbnV4IGtlcm5lbD8gV2hpY2ggaW5mcmFzdHJ1Y3R1cmUNCj4gPiA+
ID4gZG8gd2UgbmVlZCB0byBhZG9wdCBNTCBtb2RlbHMgaW4gTGludXgga2VybmVsPw0KPiA+ID4g
DQo+ID4gPiBJIHRoaW5rIHRoZXJlIGFyZSB0d28gZGlmZmVyZW50IHRoaW5ncywgSSB0aGluayB5
b3Ugd2FudCB0aGUgbGF0dGVyDQo+ID4gPiBidXQgSSBhbSBub3Qgc3VyZQ0KPiA+ID4gDQo+ID4g
PiAxKSB1c2luZyBNTCBtb2RlbCB0byBoZWxwIGtlcm5lbCBkZXZlbG9wbWVudCwgY29kZSByZXZp
ZXdzLCBnZW5lcmF0ZQ0KPiA+ID4gcGF0Y2hlcyBieSBkZXNjcmlwdGlvbnMgZXRjLiBGb3IgZXhh
bXBsZSwgQ2hyaXMgTWFzb24gaGFzIGEga2VybmVsDQo+ID4gPiByZXZpZXcgcmVwbyBvbiBnaXRo
dWIgYW5kIGhlIGlzIHNoYXJpbmcgaGlzIHJldmlldyBmaW5kaW5nIHRoZSBtYWlsaW5nDQo+ID4g
PiBsaXN0Og0KPiA+ID4gaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91
PWh0dHBzLTNBX19naXRodWIuY29tX21hc29uY2xfcmV2aWV3LTJEcHJvbXB0c190cmVlX21haW4m
ZD1Ed0lGYVEmYz1CU0RpY3FCUUJEakRJOVJrVnlUY0hRJnI9cTViSW00QVhNemM4Tkp1MV9SR21u
UTJmTVdLcTRZNFJBa0VsdlVnU3MwMCZtPXZ2ckRQeHl3X0pYUHJrQzhCanpBMmtFdHdkUGZ3VjJn
Qk1FWEc3WnZlWE00TGhTMDFMZm9Hd3FoRXlVWnBQZTQmcz1ycU5lejVfcm1pRXVFN2luNWVfN01m
eVV6enF6YUE2R2s0NldXdm1OM3lrJmU9IA0KPiA+ID4gSXQgaXMga2VybmVsIGRldmVsb3BtZW50
IHJlbGF0ZWQsIGJ1dCB0aGUgTUwgYWdlbnQgY29kZSBpcyBydW5uaW5nIGluDQo+ID4gPiB0aGUg
dXNlciBzcGFjZS4gVGhlIGFjdHVhbCBNTCBjb21wdXRhdGlvbiBtaWdodCBydW4gR1BVL1RQVXMu
IFRoYXQNCj4gPiA+IGRvZXMgbm90IHNlZW0gdG8gYmUgd2hhdCB5b3UgaGF2ZSBpbiBtaW5kLg0K
PiA+ID4gDQo+ID4gPiAyKSBSdW4gdGhlIE1MIG1vZGVsIGNvbXB1dGF0aW9uIGluIHRoZSBrZXJu
ZWwgc3BhY2UuDQo+ID4gPiBDYW4geW91IGNsYXJpZnkgaWYgdGhpcyBpcyB3aGF0IHlvdSBoYXZl
IGluIG1pbmQ/IFlvdSBtZW50aW9uIGtlcm5lbA0KPiA+ID4gRlBVIHVzYWdlIGluIHRoZSBrZXJu
ZWwgZm9yIE1MIG1vZGVsLiBJdCBpcyBvbmx5IHJlbGV2YW50IGlmIHlvdSBuZWVkDQo+ID4gPiB0
byBydW4gdGhlIEZQIGluIHRoZSBrZXJuZWwgQ1BVIGluc3RydWN0aW9ucy4gTW9zdCBNTCBjb21w
dXRhdGlvbnMgYXJlDQo+ID4gPiBub3QgcnVuIGluIENQVSBpbnN0cnVjdGlvbnMuIFRoZXkgcnVu
IG9uIEdQVXMvVFBVcy4gV2h5IG5vdCBrZWVwIHRoZQ0KPiA+ID4gTUwgcHJvZ3JhbSAoUHlUb3Jj
aC9hZ2VudHMpIGluIHRoZSB1c2VyIHNwYWNlIGFuZCBwYXNzIHRoZSBkYXRhIHRvIHRoZQ0KPiA+
ID4gR1BVL1RQVSBkcml2ZXIgdG8gcnVuPyBUaGVyZSB3aWxsIGJlIHNvbWUga2VybmVsIGluc3Ry
dWN0dXJlIGxpa2UNCj4gPiA+IFZGSU8vSU9NTVUgaW52b2x2ZWQgd2l0aCB0aGUgR1BVL1RQVSBk
cml2ZXIuIEZvciB0aGUgbW9zdCBwYXJ0IHRoZQ0KPiA+ID4ga2VybmVsIGlzIGp1c3QgZmFjaWxp
dGF0aW5nIHRoZSBkYXRhIHBhc3NpbmcgdG8vZnJvbSB0aGUgR1BVL1RQVQ0KPiA+ID4gZHJpdmVy
IHRoZW4gdG8gdGhlIEdQVS9UUFUgaGFyZHdhcmUuIFRoZSBNTCBoYXJkd2FyZSBpcyBkb2luZyB0
aGUNCj4gPiA+IGhlYXZ5IGxpZnRpbmcuDQo+ID4gDQo+ID4gVGhlIGlkZWEgaXMgdG8gaGF2ZSBN
TCBtb2RlbCBydW5uaW5nIGluIHVzZXItc3BhY2UgYW5kIGtlcm5lbCBzdWJzeXN0ZW0gY2FuDQo+
ID4gaW50ZXJhY3Qgd2l0aCBNTCBtb2RlbCBpbiB1c2VyLXNwYWNlLiBBcyB0aGUgbmV4dCBzdGVw
LCBJIGFtIGNvbnNpZGVyaW5nIHR3bw0KPiA+IHJlYWwtbGlmZSB1c2UtY2FzZXM6ICgxKSBHQyBz
dWJzeXN0ZW0gb2YgTEZTIGZpbGUgc3lzdGVtLCAoMikgTUwtYmFzZWQgREFNT04NCj4gPiBhcHBy
b2FjaC4gU28sIGZvciBleGFtcGxlLCBHQyBjYW4gYmUgcmVwcmVzZW50ZWQgYnkgTUwgbW9kZWwg
aW4gdXNlci1zcGFjZS4gR0MNCj4gPiBjYW4gcmVxdWVzdCBkYXRhIChzZWdtZW50cyBzdGF0ZSkg
ZnJvbSBrZXJuZWwtc3BhY2UgYW5kIE1MIG1vZGVsIGluIHVzZXItc3BhY2UNCj4gPiBjYW4gZG8g
dHJhaW5pbmcgb3IvYW5kIGluZmVyZW5jZS4gQXMgYSByZXN1bHQsIE1MIG1vZGVsIGluIHVzZXIt
c3BhY2UgY2FuIHNlbGVjdA0KPiA+IHZpY3RpbSBzZWdtZW50cyBhbmQgaW5zdHJ1Y3Qga2VybmVs
LXNwYWNlIGxvZ2ljIG9mIG1vdmluZyB2YWxpZCBkYXRhIGZyb20gdmljdGltDQo+ID4gc2VnbWVu
dChzKSBpbnRvIGNsZWFuL2N1cnJlbnQgb25lKHMpLiANCj4gDQo+IFRvIGJlIGhvbmVzdCBJJ20g
c2tlcHRpY2FsIGFib3V0IGhvdyBnZW5lcmljIHRoaXMgY2FuIGJlLiBFc3NlbnRpYWxseQ0KPiB5
b3UncmUgZGVzY3JpYmluZyBhIGdlbmVyaWMgaW50ZXJmYWNlIHRvIG9mZmxvYWQgYXJiaXRyYXJ5
IGtlcm5lbCBkZWNpc2lvbg0KPiB0byB1c2Vyc3BhY2UuIE1MIGlzIGEgdXNlcnNwYWNlIGJ1c3Np
bmVzcyBoZXJlIGFuZCBub3QgcmVhbGx5IHJlbGV2YW50IGZvcg0KPiB0aGUgY29uY2VwdCBBRkFJ
Q1QuIEFuZCB3ZSBhbHJlYWR5IGhhdmUgc2V2ZXJhbCB3YXlzIG9mIGtlcm5lbCBhc2tpbmcNCj4g
dXNlcnNwYWNlIHRvIGRvIHNvbWV0aGluZyBmb3IgaXQgYW5kIHVubGVzcyBpdCBpcyB2ZXJ5IHJl
c3RyaWN0ZWQgYW5kIHdlbGwNCj4gZGVmaW5lZCBpdCBpcyByYXRoZXIgcGFpbmZ1bCwgcHJvbmUg
dG8gZGVhZGxvY2tzLCBzZWN1cml0eSBpc3N1ZXMgZXRjLg0KDQpTY2VwdGljaXNtIGlzIG5vcm1h
bCByZWFjdGlvbi4gOikgU28sIG5vdGhpbmcgd3JvbmcgaXMgdG8gYmUgc2NlcHRpY2FsLg0KDQpJ
IGJlbGlldmUgaXQgY2FuIGJlIHByZXR0eSBnZW5lcmljIGZyb20gdGhlIGRhdGEgZmxvdyBwb2lu
dCBvZiB2aWV3LiBQcm9iYWJseSwNCmRpZmZlcmVudCBrZXJuZWwgc3Vic3lzdGVtcyBjb3VsZCBy
ZXF1aXJlIGRpZmZlcmVudCB3YXlzIG9mIGludGVyYWN0aW9uIHdpdGgNCnVzZXItc3BhY2UuIEhv
d2V2ZXIsIGlmIHdlIGFyZSB0YWxraW5nIGFib3V0IGRhdGEgZmxvdyBidXQgTk9UIGV4ZWN1dGlv
biBmbG93LA0KdGhlbiBpdCBjb3VsZCBiZSBnZW5lcmljIGVub3VnaC4gQW5kIGlmIGl0IGNhbiBi
ZSBnZW5lcmljLCB0aGVuIHdlIGNhbiBzdWdnZXN0DQpnZW5lcmljIHdheSBvZiBleHRlbmRpbmcg
YW55IGtlcm5lbCBzdWJzeXN0ZW0gYnkgTUwgc3VwcG9ydC4NCg0KSSBkb24ndCB0aGluayB0aGF0
IHdlIG5lZWQgdG8gY29uc2lkZXIgdGhlIE1MIGxpYnJhcnkgYXBwcmFvY2ggbGlrZSAia2VybmVs
DQphc2tpbmcgdXNlcnNwYWNlIHRvIGRvIHNvbWV0aGluZyIuIFJhdGhlciBpdCBuZWVkcyB0byBj
b25zaWRlciB0aGUgbW9kZWwgbGlrZQ0KImtlcm5lbCBzaGFyZSBkYXRhIHdpdGggdXNlci1zcGFj
ZSBhbmQgdXNlci1zcGFjZSByZWNvbW1lbmRzIHNvbWV0aGluZyB0bw0Ka2VybmVsIi4gU28sIHVz
ZXItc3BhY2UgYWdlbnQgKE1MIG1vZGVsKSBjYW4gcmVxdWVzdCBkYXRhIGZyb20ga2VybmVsIHNw
YWNlIG9yDQprZXJuZWwgc3Vic3lzdGVtIGNhbiBub3RpZnkgdGhlIHVzZXItc3BhY2UgYWdlbnQg
dGhhdCBkYXRhIGlzIGF2YWlsYWJsZS4gQW5kDQppdCdzIHVwIHRvIGtlcm5lbCBzdWJzeXN0ZW0g
aW1wbGVtZW50YXRpb24gd2hpY2ggZGF0YSBjb3VsZCBiZSBzaGFyZWQgd2l0aCB1c2VyLQ0Kc3Bh
Y2UuIFNvLCBNTCBtb2RlbCBjYW4gYmUgdHJhaW5lZCBpbiB1c2VyLXNwYWNlIGFuZCwgdGhlbiwg
c2hhcmUNCnJlY29tbWVuZGF0aW9ucyAob3IgZUJQRiBjb2RlLCBmb3IgZXhhbXBsZSkgd2l0aCBr
ZXJuZWwgc3BhY2UuIEZpbmFsbHksIGl0J3MgdXANCnRvIGtlcm5lbCBzdWJzeXN0ZW0gaG93IGFu
ZCB3aGVuIHRvIGFwcGx5IHRoZXNlIHJlY29tbWVuZGF0aW9ucyBvbiBrZXJuZWwgc2lkZS4NCg0K
PiANCj4gU28gYnkgYWxsIG1lYW5zIGlmIHlvdSB3YW50IHRvIGRvIEdDIGRlY2lzaW9ucyBmb3Ig
eW91ciBmaWxlc3lzdGVtIGluDQo+IHVzZXJzcGFjZSBieSBNTCwgYmUgbXkgZ3Vlc3QsIGl0IGRv
ZXMgbWFrZSBzb21lIHNlbnNlIGFsdGhvdWdoIEknZCBiZSB3YXJ5DQo+IG9mIGlzc3VlcyB3aGVy
ZSB3ZSBuZWVkIHRvIHdyaXRlYmFjayBkaXJ0eSBwYWdlcyB0byBmcmVlIG1lbW9yeSB3aGljaCBt
YXkNCj4gbm93IGRlcGVuZCBvbiB5b3VyIHVzZXJzcGFjZSBoZWxwZXIgdG8gbWFrZSBhIGRlY2lz
aW9uIHdoaWNoIG1heSBuZWVkIHRoZQ0KPiBtZW1vcnkgdG8gZG8gdGhlIGRlY2lzaW9uLi4uIEJ1
dCBJIGRvbid0IHNlZSB3aHkgeW91IG5lZWQgYWxsIHRoZSBNTCBmbHVmZg0KPiBhcm91bmQgaXQg
d2hlbiBpdCBzZWVtcyBsaWtlIGp1c3QgYW5vdGhlciB3YXkgdG8gY2FsbCB1c2Vyc3BhY2UgaGVs
cGVyIGFuZA0KPiB3aHkgc29tZSBvZiB0aGUgZXhpc3RpbmcgbWV0aG9kcyB3b3VsZCBub3Qgc3Vm
ZmljZS4NCj4gDQoNCk9LLiBJIHNlZS4gOikgWW91IHVuZGVyc3Rvb2QgR0MgbGlrZSBhIHN1YnN5
c3RlbSB0aGF0IGhlbHBzIHRvIGtlcm5lbCBtZW1vcnkNCnN1YnN5c3RlbSB0byBtYW5hZ2UgdGhl
IHdyaXRlYmFjayBkaXJ0eSBtZW1vcnkgcGFnZXMuIDopIEl0J3MgcG90ZW50aWFsDQpkaXJlY3Rp
b24gYW5kIEkgbGlrZSB5b3VyIHN1Z2dlc3Rpb24uIDopIEJ1dCBJIG1lYW50IHNvbWV0aGluZyBk
aWZmZXJlbnQgYmVjYXVzZQ0KSSBjb25zaWRlciBvZiBMRlMgZmlsZSBzeXN0ZW0ncyBHQyBzdWJz
eXN0ZW0uIFNvLCBpZiB3ZSBhcmUgdXNpbmcgQ29weS1Pbi1Xcml0ZQ0KKENPVykgcG9saWN5LCB0
aGVuIHdlIGhhdmUgc2VnbWVudHMgb3IgZXJhc2UgYmxvY2tzIHdpdGggYSBtaXh0dXJlIG9mIHZh
bGlkIGFuZA0KaW52YWxpZCBsb2dpY2FsIGJsb2NrcyBhZnRlciB1cGRhdGUgb3BlcmF0aW9ucy4g
QW5kIHdlIG5lZWQgR0Mgc3Vic3lzdGVtIHRvDQpjbGVhbiBvbGQgc2VnbWVudHMgYnkgbWVhbnMg
b2YgbW92aW5nIHZhbGlkIGxvZ2ljYWwgYmxvY2tzIGZyb20gZXhoYXVzdGVkDQpzZWdtZW50cyBp
bnRvIGNsZWFuL2N1cnJlbnQgb25lcy4gVGhlIHByb2JsZW0gaGVyZSBpcyB0byBmaW5kIGFuIGVm
ZmljaWVudA0KYWxnb3JpdGhtIG9mIHNlbGVjdGluZyB2aWN0aW0gc2VnbWVudHMgd2l0aCBzbWFs
bGVzdCBhbW91bnQgb2YgdmFsaWQgYmxvY2tzIHdpdGgNCnRoZSBnb2FsIG9mIGRlY3JlYXNpbmcg
d3JpdGUgYW1wbGlmaWNhdGlvbi4gU28sIGZpbGUgc3lzdGVtIG5lZWRzIHRvIHNoYXJlIHRoZQ0K
bWV0YWRhdGEgZGV0YWlscyAoc2VnbWVudHMgc3RhdGUsIGZvciBleGFtcGxlKSwgTUwgbW9kZWwg
Y2FuIHNoYXJlIHRoZQ0KcmVjb21tZW5kYXRpb25zLCBhbmQga2VybmVsIGNvZGUgb2YgZmlsZSBz
eXN0ZW0gY2FuIGZpbmFsbHkgbW92ZSB2YWxpZCBibG9ja3MgaW4NCnRoZSBiYWNrZ3JvdW5kLg0K
DQpJIGRvbid0IHdhbnQgdG8gc2F5IHRoYXQgTUwgaXMgYSBtaXJhY2xlIHRoYXQgY2FuIHNvbHZl
IGFsbCBvdXIgcHJvYmxlbXMuIEFuZCBpdA0KY2Fubm90IHdvcmsgZWZmaWNpZW50bHkgZm9yIGFs
bCBwb3NzaWJsZSBwcm9ibGVtcy4gQnV0IGl0IGNhbiBoZWxwIHVzIHRvIHNvbHZlDQpzb21lIGNv
bXBsaWNhdGVkIGlzc3VlcyBhbmQgaXQgbWFrZXMgc2Vuc2UgdG8gZWxhYm9yYXRlIHNvbWUgZ2Vu
ZXJpYyBmcmFtZXdvcmsNCmZvciBNTCBhZG9wdGlvbiBpbnRvIExpbnV4IGtlcm5lbC4NCg0KVGhh
bmtzLA0KU2xhdmEuDQoNCg==

