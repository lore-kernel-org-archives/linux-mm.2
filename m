Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 182A9E81BC4
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 13:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363286B0005; Mon,  9 Feb 2026 08:27:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3105A6B0088; Mon,  9 Feb 2026 08:27:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7336B0089; Mon,  9 Feb 2026 08:27:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05ED66B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:27:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 875C5C023C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:27:46 +0000 (UTC)
X-FDA: 84424995732.08.CDD61B6
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010066.outbound.protection.outlook.com [40.93.198.66])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9C6E9120007
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:27:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=WhPJibks;
	spf=pass (imf29.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.198.66 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770643663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plb7mMXhJIHuIhXWsbn4FTfGCPsHFm/TayRUcT4tjJM=;
	b=ROmF3ZSImFFV8m8otLxCRE23sMeRyaznDkiSMh01SHbrnAn66km/BhkNQHQcRBBRykYhTO
	E8zw4uAGFpFEUCuk38i9oMrjKOn+p+hmzr9bXFq0/TkWacVVkys0qEmBvioR3DbprUNsII
	0rN00MDEWglHKOCxauDD78Xisjpx/Yk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=WhPJibks;
	spf=pass (imf29.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.198.66 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770643663; a=rsa-sha256;
	cv=pass;
	b=ZEIDL2puT5Kou7HZOvDlBka3OGUZhJWGnEpU9EYAZ2WhZL5q/NukDNgpb9URd+ZrTyT9pC
	RNp/ixmW/jmRJbd20GGSM9StIKiG0qAK5Hg073lx4vYmg3vV5oKoOrYlU8Buy87tpsCDBH
	xVyoBFbT3LlV/Bdg6456rz4gHGcm3hs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y36wQ10wOnHFze3mRVQiDxd/FQhRaQNFlZ9tUSAE8GQEaGnHJECcgiLZSVg6ll6MnBFf/L+/jaWCYWjegejq+hQu+AIZOD3h4VBisbD515PFr1ImqcO6U7TXygX18wy1rjIBLu8kEhPqhPYkhGFdqRVKN8TJK78Vm0Auynibc9gJuq9boh78ISiOBc8n0wMme2tW9qNG/EWPgK3Vt9EAZHgY2GrccfkPe6NSb3rtKQ0G362z1E9ChA76MZjZVa9DJw082FzdEXQSbd+jekM/+lC82AqgH8s8cE2QMJ3Idu3V0CWusUCBimWkqu9jZhDF60+O635EX3iUdTsZaEw+bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=plb7mMXhJIHuIhXWsbn4FTfGCPsHFm/TayRUcT4tjJM=;
 b=K+k3ML9qbLcC1/dJ0Z6PK/ykIhPz6seHz+k1tNNjpnlmdzGhvDVAOJZsU6bwt86iZECcA+sGGGj+1XAsOPLEDZZhPMhSSNQeg4C2q8tDJOhYDzHri4G8xIu7pXe82UMDaTBqYxu+o8pvVskMwaKfAL/OC5PZkvuLQU81bxnzdgLEder8j1mpMi+N1NStMpbMkLTxymEWBmTebLEixtPJk8dpOZ79pLh5ga7lm5liAgRuBTIEuK123rbZWc0l2Ty8ojzh0DrUne74du+1CcV4WJjq56SIYEegwnRD9Mzu+U9JkFwsqzKrikvoCBBZiiPVk/z20bbeeW4sWguu7rrsDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plb7mMXhJIHuIhXWsbn4FTfGCPsHFm/TayRUcT4tjJM=;
 b=WhPJibksxAZDWVEXaSf+reTdObkeNzh+/LIYqFAFEjpZPtW/CEoTMQJ6p5NkGAfOmZIvqy2Pr8u1L7yAzm8NQ1cO+p3asc2J7x9zFhL3PUIWXfhc99mcxdW6aWnRr7N/iYWs68iu9byaufd508Qb2lbZqUqjez2nrIC6l2s5XL0=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CH2PR12MB4054.namprd12.prod.outlook.com (2603:10b6:610:a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Mon, 9 Feb
 2026 13:27:40 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 13:27:40 +0000
Message-ID: <a31082ab-e0f9-45ea-9a8d-cfdef39fc507@amd.com>
Date: Mon, 9 Feb 2026 14:27:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] drm/amdkfd: Add batch userptr allocation support
To: Honglei Huang <honghuan@amd.com>
Cc: Felix.Kuehling@amd.com, Philip.Yang@amd.com, Ray.Huang@amd.com,
 alexander.deucher@amd.com, dmitry.osipenko@collabora.com,
 Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org
References: <20260206062557.3718801-1-honglei1.huang@amd.com>
 <da75eadd-865e-41fe-a86b-ed9d9aa45e5a@amd.com>
 <8ba8e4f2-89f2-4968-a291-e36e6fc8ab9b@amd.com>
 <f296a928-1ef6-4201-9326-eab43da79a84@amd.com>
 <38264429-a256-4c2f-bcfd-8a021d9603b2@amd.com>
 <451400e6-bbe0-4186-bae6-1bf64181c378@amd.com>
 <0eaf1785-0f84-45e5-b960-c995c1b1cf1e@amd.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <0eaf1785-0f84-45e5-b960-c995c1b1cf1e@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0172.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::19) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CH2PR12MB4054:EE_
X-MS-Office365-Filtering-Correlation-Id: 175a2e13-6729-48d2-414b-08de67deff89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|14052099004;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OXhKTWswczBXc01zZXRKR3JhREVoSVVGYUxmZDFRNTBWbi9YZmp4ZGFwNGpK?=
 =?utf-8?B?WmFUdjNnSWVacnhyT29vQ0EzTENaYnVOMVEzWWUwSEt2NjNvZHJHaUZtdkdx?=
 =?utf-8?B?NVY0bFMvTyt5VFlVNVdZYm5POG5TSXp5ZWF2aTFoUmhsTk1ld2szU1gzZm1z?=
 =?utf-8?B?Mk9LTkFhY0I2QU53RDVlNHBRWDNKM1JvdnVLcmNZcFVXQjVWV0JYZzdUcE9E?=
 =?utf-8?B?aE5RQ2E0UU8xbEZPbXZ3OG53d0FRUXVXUDJ6bjRZWExsZ05NME02Q244cEFz?=
 =?utf-8?B?SUlzQzQvamZ0MXQrWHNwelhzeitFMHE4U3VHbVhMakRIZTF3bGY2RnBHQ0NI?=
 =?utf-8?B?c2VBZWllYUhESTNJSGRLUUE5SXU1NTlyN1FZMzdLQ0c4QkhldGZpa1Y5aEo5?=
 =?utf-8?B?RWZZMDNGTmhPQ3VNbkRDMzkzS0lEM0U5UWpjWVRFYkdBVmFibGd0RGZwUTBU?=
 =?utf-8?B?M3N5a1MwWGJ2ZXJTUjdYTW1nUjBlWnFMczV6c3ZudU5qL0t5RG56a1BqZzFN?=
 =?utf-8?B?Q3o5TGRsN242cFU5bWYzMjErbnU0NEIwYlJzbmcrTUpWbWlvT1hxczFLWGxa?=
 =?utf-8?B?aUZhemMvNWx1Tm5GU0x6M0owZmltY1hISlVVYnBWNGV4QW1ldzBsMHpuU21J?=
 =?utf-8?B?dkdGM3A2LytnTnhOM2M5NkZJRmlkL2lmdnNqeTFuZzhIUHdueGNVMGs1QWwz?=
 =?utf-8?B?cmpGNyswbHN1ZGllNHZyQzZXaWZiRERvMXRIMVZ5NkJ2UHZrazFIbXJKRmFV?=
 =?utf-8?B?cHNFbmxuY3lObzhOVlhkOTlEQXdhTndhd0JkN1JTV0FPWFd6ZlhHa2tqdlRk?=
 =?utf-8?B?cDhCc0YyOTMwVFQ5aisweFJrOURYd2FMdm4weHVQdzQxbnl1WXR1MHBlMUs4?=
 =?utf-8?B?aFBOc1ZkcGFxSGliYkY5bkMyMWdZdG5DbW5YdHJyUlhKVFYvenFpcWVPclFM?=
 =?utf-8?B?c04wbm5GY0VDQ3daTTN2ZkhIeDFhU1pHMG1iZTFaL1o0VUtPcm9PQThRVVdo?=
 =?utf-8?B?R2EwcCtoMDIrRldiMTNuS1lKbFFsZWhhN09Jd1VCTmpTK0NTOVpiUXR6ZmJR?=
 =?utf-8?B?cnZXM0RVdDMvRHY2N3VpOTc0WWFKTEpwRU5vNGdhOHMvQjc3cDRpUDJqckVJ?=
 =?utf-8?B?UVFTd1B2aHRLMUpUeG9OSHJTdVZNelpmdE1qRU51cFZBME5xNnByWDFva0ZX?=
 =?utf-8?B?eE5SdllwYjdOcjVacVVzNVM3cVFWbXdUUGFFVnZUdzUrN09RK1d1MGJhVnBY?=
 =?utf-8?B?Wi9ZZ2xIZGVTQ29IUUpJWGFGRnJFamhqZUFRaXJmL3lvSWVvTE9wWnNJWXpo?=
 =?utf-8?B?Ull2YVk2RUJSUm5nSFA0UmdOM21TZmtOd3VVT3JVYXIvVEpscmJsSlJqV2x5?=
 =?utf-8?B?ZkxyVmpvNm5YalNkaDBUR3MxR25MeWt6d2QwUzF4QzVGZ0RxL2VxeUlxN2FS?=
 =?utf-8?B?aHl0ZkJUY3BFTDhZVjQ3TmxyMVBkVFI1UXhxUi9sM0dFLytKZ1hGTlNzaDg1?=
 =?utf-8?B?djlsbjRVQzQ1ampXcmYraFl3SnhvMHRDNWxGQnd2NkVReHVZRDJnQWtBZWZi?=
 =?utf-8?B?K2J6TmtneFFLaEFiNWRCdGVDT3dLT1VKVUZOZ3BoV0ZXMEV2T012VVlrY0ZE?=
 =?utf-8?B?WURJdDZ2L2RadnpzQlJaUEEwMWNEUCtGenNUTEw4MUdPZHFTTjBtY0FEaHh5?=
 =?utf-8?B?VTNkSWU2TGlkT0ErMHVZYVR3TlJUTi9UbVpsdms5S00xTXF2Wmx4alhMUnhn?=
 =?utf-8?B?UXhtVjlFakdtU0gyNjhNREUwNmpOWGRYU0tnWjhjOTE5RjFETDlQeFpWdXBy?=
 =?utf-8?B?SHBqcmtEbVpmVFRmeTg2RHdWNzJoaEExMFV5K1dzUmRxY1doSWNHbDBuaDJI?=
 =?utf-8?B?bTgzYXNDK1FCckVnekhSeDJTdXkrdisyZzFNanNJTzFDcDRLaVhRNWVSb0h3?=
 =?utf-8?B?NVNzdW43empxSUlQMkhjcHg0RFhsMnhrQU1yZzc0ajVGemFWOFY0MWFtTzd3?=
 =?utf-8?B?Y2ZCY3Vhckw2MkgzNml1aG1hMTh2QVU2cTRXNEFEci9sOFJYMERUa0pGVy9U?=
 =?utf-8?B?bmdhMlNNQnY2bUJGYmg4Z2drdmtsSEJjWXRNMlVTQXhoTFlYekE3TldkQ1ll?=
 =?utf-8?Q?S3wE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(14052099004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmhpUVJFWWdMQ3JYVGM3LzArc1RkemZDaHIzaVRqZExnOVY3UWFnMlJsR1VO?=
 =?utf-8?B?dHoyMWs4WmtMT2VtckdGTkVRNVROaEpXOVFVcVFjaHo3RW1YRGpJb0dweFRp?=
 =?utf-8?B?OTJzU3lNcVdvSWJOcEZtOVpmVGZKS1hRU3BsMDRFc1YxMmlBMkIvSkNWdmdP?=
 =?utf-8?B?RHJQcDhPTVhMRXV1NUd3dExRV1JaUlk5VllwSDVtTXZDdHNUU3N5SGQzWSs5?=
 =?utf-8?B?ckZLZjBUK3ZpNUNvbHpCSlp0NlBYcHAzMFB6Q0dYczZmWDJQemZvNENVcG5a?=
 =?utf-8?B?WWc2aGlUV2dUMHFYR0EvU0xIVGhPbjdESEh2eVNuZXYxeWIvVDBBQzkzRndm?=
 =?utf-8?B?OUF5UzZyaTc4MWlTK1Z4ZDJKd0JtdmhZdUk4US8rYVFwZHdqbjJrV2FDUmNa?=
 =?utf-8?B?eDVMV3BnREx4aU9DVEtWb1pQamluR2g2VllwSmlIaXNyWVVkVHVtdkFUMXBK?=
 =?utf-8?B?dXEwY1FMTGdrK2k0cGlVZm5LL213emJ3b2ZJVVR1RUc5a1Y2RFl1MjgvOUsx?=
 =?utf-8?B?dlp4WCtnM2UrSkwzZlUwaEQyR0l0bkRPU3p4ZjRNM1dRdEdKazJaVzMxUGR1?=
 =?utf-8?B?YjFzek5xcEdJOHpGZnZzSlFSbVZ3Qk5DNkUvSTRiY3pxVU4zNEs3SG5uYnls?=
 =?utf-8?B?V0FaUnlYZFJRL0toTExGMWdUeDRBNWJQWnExLzhRdDBPczlvWDZtM0tkY015?=
 =?utf-8?B?RGMwbWxVekpNTEpOSjRPMGtwYnVQcmpDS1JiYWQ2cmVXVGsvY29SdUNnVDNh?=
 =?utf-8?B?cm5FYllBNkRFYjZSV3o2OXZ0ZGhWRW95Z1BQT0JMM3BEcDVwZlNQRWV4bmZR?=
 =?utf-8?B?UEc3MC84NUhPWEY4OWU0YmtzWU5kTmZRb0NtUGJHcXFqR1hJek54T2g0RzY5?=
 =?utf-8?B?anc3K1E3TDNkdGplWkdxV3hRTVpjK0dwM2hmSUJIMVoyL1N1OVdMaEtXTjJF?=
 =?utf-8?B?MWZ0MHpMa2Nkcmdac0J1cXRHMXZkTkhGZEZ4ZThlOUVaMXl1Nkp2NEpqMzEr?=
 =?utf-8?B?bEhLK3hjbnV6RVllcHRDcHhvWlUrK25WYyt0dEI3VmtDcWQ4MUg0QWVIUngw?=
 =?utf-8?B?bHNjbmFWYko5WjdEand4WWE0Y2RhZHl6QURXYVl4NmZobVloMDZqNTdGL2hu?=
 =?utf-8?B?U1hGREhxNEdBM091cmhGazdzZCt1UHM5TDMxdHBQQTd4VHJkL2psbmRDZjlJ?=
 =?utf-8?B?VysrREdXTjhOWGtCaWtyUDlKN0hjUWdCRk5iNG41QWJiS2pERWQ0cEZZbGlE?=
 =?utf-8?B?clFIcjVMcE4vZk5URVZRNWFKU1ZQaGFrRTdUeTAxUGp1OUlNVGQwbFAzU1Zv?=
 =?utf-8?B?RlZJOVU2Rm1yRFZlKzgwQSt6YUN0L213RXp1dVB6Z20wbGY3ellhN01wNzda?=
 =?utf-8?B?cE5hdlRJazRTNjZhQUJaT0VxdFJYRmxSMEUrTld3WmhiT2hVRndwei9HM2tZ?=
 =?utf-8?B?Uk05YnJoSzJsdnZocUpHL3lWNG1LM0dWUHpDMlAvY1RaczNFbGRuL3h0aito?=
 =?utf-8?B?aHBQZnB1cUN5OTJPdFlORzNNQUtuQjdXdjd0M2IzaGVZbEdiV2d5cmtTWjlT?=
 =?utf-8?B?Y0hRN0NUMDhFVWNraTdsQUNHcmlJUlpLcG1mRldtaVplN282SWozT0JXbDVq?=
 =?utf-8?B?M3lqT2tMSHlEeDRjUnVzZkJaSVl1aGZQRzRHSlNkV2tzRDZnODQzdjFDaUF5?=
 =?utf-8?B?dGcxcStnR0J0blpsZDBNZk1uTmZXYy9uNExLVSsxU2xCcGJjRTZ0Z0pBeFlP?=
 =?utf-8?B?UjI5UFBpSXdKdmJncHV1ckRscDJhWXAvSVpaeitWUFZNbVI2TVZJTVVhUlJX?=
 =?utf-8?B?M0xOdGFtNDBRWWJvcXIvMWFUaWc3bzFsZVJQY0JYV2RZeGJ3QzdtbjJ6UldU?=
 =?utf-8?B?NVhjdTBOUVB1MmtiTHBpcUdRcGRCNEc3amFRZVdCK1pIaEQxZlRYbVRlMlhQ?=
 =?utf-8?B?THdJa2RCTldhNlRYallibG1hVDdRQVpQUkpneDNrclVOV1E4M21kZW5wWnVS?=
 =?utf-8?B?V09jR0xPNTREdnpkS0JzdWhTcGJOYlVTTHdPbTZWOEV0UGk4WEhWTTkvREVw?=
 =?utf-8?B?aU1qQzg1Zk5aQVE3SVM3R3NsRWdqQ2VEQTNZWkFlYm9zbG1PMXN5bEpHZVh1?=
 =?utf-8?B?SVp4WSttOGRCQi8yQ3A4QUc1dks1N3ROU2REZjlDejJtNFZ6UmZBaXRSdDZz?=
 =?utf-8?B?b0ZlbDJpY1pZUHFFUXl5VXVqWVppZjdLbG1kLzhZT2xrVjU1OGdCSVhvRUhW?=
 =?utf-8?B?RU9VRWdrZVR0RTRHb1djLzgvZDZUaWdPZk9vOHVvSWx3Zkx6QTZ4NHpsL0JE?=
 =?utf-8?Q?obk3gdZYlwW3PsEcZI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 175a2e13-6729-48d2-414b-08de67deff89
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 13:27:40.3050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oaq04YPCYsbVvR1iHJZE0UtKv54sc+/GVPTrPWBcCOZMtZtp/zDNSKjeGBE9b0xt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4054
X-Rspamd-Server: rspam12
X-Stat-Signature: 6tfa4dthb8pjzffs978u3emzks3tqkhf
X-Rspamd-Queue-Id: 9C6E9120007
X-Rspam-User: 
X-HE-Tag: 1770643663-957394
X-HE-Meta: U2FsdGVkX19ylkjNxRCuQOvmLWQt+84b6goXyGSCR8W+8o6sQAEvrnRTJzY2OcZ2ar5YfH9+K8FP6Jt6f6adhb+vMBcYJKmHJs2BRQbIO0s/09xerqB4dX72oiachjipqDBDFbgSDkyHZImDVJ4AkOBUFsUp50f7qixbK4P8nAaIBE83eG01ak5cm00Ei0pQyAMK6YaS/nhojsMzGCx2+VdRlM4Rpudx0vvQ3SEomL6Iz4MoVPAZu4r0D2Va+bgDRQWtE1Wz21JALsb9LAd3vPhDb+/PXFnYt3XWj1v55aE+Uu98l3bp9kUGUVZ1GpgGiaCdceF7xtgkQX2555jK0AXy4seEPCKV5/47dGiWD3iCbwEDGmispobIkSmklrrQkFIqrcLKtkiC/vyqKa8xgUFecnvEoZXQ4ifHO0NBieJtUCCa10r1PymaOVCFB3iPScEI2oKAGCZqm1XiPh3ih1nFXXtfRvblSIdZWdisHHf3SvCNYFIAG5H80fI+f2XNLN1Uev1nzMxE9joiUpNNB71Zxrrteemx1N3zDGpDxVAekT3SeHsVlJxzgPNmoUHkuJTCGQSlEIZw8IjGMCTXAXRzil/iserNkQknZ1Nk/SdlI4j3NGe5U+KqKqWyh62KeskxZoF6W26puV9vZHjfGipSX3lC4Ct7pULNFfq3Eki06Yg16V2BUa5UJONUb2TEgYnB77dwxz7wRv/46zvSw3FAUlhaBtF4rhM8uqif8W+Nce52p4uZWGLiUdK83lrpy28F3110jhqsmTz3i6IgiyyoFhZeXdftFcGWM2x2JnH0CMc9IE18LDN6o6WtZgv69pZxKdFJ2gq52G+ocNhS0HRUO7ZCT5vyFKNpqRRBrlfKJEv3ZdPYYbYHgRnpuINzGm6q9WJCXy7oCqg4m8a5qkIZyYrKinvj1/D+Hg6qmn+CtJYNTX8sgBl9BWDf+mdMpQAdlcQYFoFS4b7LUiF
 17PLkrhn
 130zFxJbfr9VvylIWb3N1GsypXcgSb65mnlmVuEXiCy5D7RpngiNfuHbFViocjho1NHY19fHGjByDzkbphi0QJncL8jZamrs4n8zOF8UUoJJT5a47SrefA+i6hDC7xKlTP7IIaQKoSiAI0WuqeUa0iEuSHHaOhgBLbbe5zkklCF2aYbdIbkksvA3WygewCDMtOxIGgJOeSE9CzE5bfZ7H3tw3spPMHVFl4RcA9GmTA82gRAjcpcBj5Q2LJgtiiX8KdOk0lIkuJqiq0nsnjk1dtA2smw148iCsoziEAmCS3ywTH/gNTZklo3shSmjKSbc8EIgKLuYwJjCTf9FCXf6UA7MIBIh4eX254u5c5cj+rjXaNCwo0fD5wmo8kITeTn+w5zPBkWndPwEiXu9maVnDg3H1/6fNtxyF/LR1yGRtAcD4kCkb2tjaZ+izcrQKxSoH5z532zkWsgqVmIAR1vpQZvm8sbn+K1aUbbVi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 14:11, Honglei Huang wrote:
> 
> So the drm svm is also a NAK?
> 
> These codes have passed local testing, opencl and rocr， I also provided a detailed code path and analysis.
> You only said the conclusion without providing any reasons or evidence. Your statement has no justifiable reasons and is difficult to convince
> so far.

That sounds like you don't understand what the issue here is, I will try to explain this once more on pseudo-code. 

Page tables are updated without holding a lock, so when you want to grab physical addresses from the then you need to use an opportunistically retry based approach to make sure that the data you got is still valid.

In other words something like this here is needed:

retry:
	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
	hmm_range.hmm_pfns = kvmalloc_array(npages, ...);
...
	while (true) {
		mmap_read_lock(mm);
		err = hmm_range_fault(&hmm_range);
		mmap_read_unlock(mm);

		if (err == -EBUSY) {
			if (time_after(jiffies, timeout))
				break;

			hmm_range.notifier_seq =
				mmu_interval_read_begin(notifier);
			continue;
		}
		break;
	}
...
	for (i = 0, j = 0; i < npages; ++j) {
...
		dma_map_page(...)
...
	grab_notifier_lock();
	if (mmu_interval_read_retry(notifier, hmm_range.notifier_seq))
		goto retry;
	restart_queues();
	drop_notifier_lock();
...

Now hmm_range.notifier_seq indicates if your DMA addresses are still valid or not after you grabbed the notifier lock.

The problem is that hmm_range works only on a single range/sequence combination, so when you do multiple calls to hmm_range_fault() for scattered VA is can easily be that one call invalidates the ranges of another call.

So as long as you only have a few hundred hmm_ranges for your userptrs that kind of works, but it doesn't scale up into the thousands of different VA addresses you get for scattered handling.

That's why hmm_range_fault needs to be modified to handle an array of VA addresses instead of just a A..B range.

Regards,
Christian.


> 
> On 2026/2/9 20:59, Christian König wrote:
>> On 2/9/26 13:52, Honglei Huang wrote:
>>> DRM GPU SVM does use hmm_range_fault(), see drm_gpusvm_get_pages()
>>
>> I'm not sure what you are talking about, drm_gpusvm_get_pages() only supports a single range as well and not scatter gather of VA addresses.
>>
>> As far as I can see that doesn't help the slightest.
>>
>>> My implementation follows the same pattern. The detailed comparison
>>> of invalidation path was provided in the second half of my previous mail.
>>
>> Yeah and as I said that is not very valuable because it doesn't solves the sequence problem.
>>
>> As far as I can see the approach you try here is a clear NAK from my side.
>>
>> Regards,
>> Christian.
>>
>>>
>>> On 2026/2/9 18:16, Christian König wrote:
>>>> On 2/9/26 07:14, Honglei Huang wrote:
>>>>>
>>>>> I've reworked the implementation in v4. The fix is actually inspired
>>>>> by the DRM GPU SVM framework (drivers/gpu/drm/drm_gpusvm.c).
>>>>>
>>>>> DRM GPU SVM uses wide notifiers (recommended 512M or larger) to track
>>>>> multiple user virtual address ranges under a single mmu_interval_notifier,
>>>>> and these ranges can be non-contiguous which is essentially the same
>>>>> problem that batch userptr needs to solve: one BO backed by multiple
>>>>> non-contiguous CPU VA ranges sharing one notifier.
>>>>
>>>> That still doesn't solve the sequencing problem.
>>>>
>>>> As far as I can see you can't use hmm_range_fault with this approach or it would just not be very valuable.
>>>>
>>>> So how should that work with your patch set?
>>>>
>>>> Regards,
>>>> Christian.
>>>>
>>>>>
>>>>> The wide notifier is created in drm_gpusvm_notifier_alloc:
>>>>>     notifier->itree.start = ALIGN_DOWN(fault_addr, gpusvm->notifier_size);
>>>>>     notifier->itree.last = ALIGN(fault_addr + 1, gpusvm->notifier_size) - 1;
>>>>> The Xe driver passes
>>>>>     xe_modparam.svm_notifier_size * SZ_1M in xe_svm_init
>>>>> as the notifier_size, so one notifier can cover many of MB of VA space
>>>>> containing multiple non-contiguous ranges.
>>>>>
>>>>> And DRM GPU SVM solves the per-range validity problem with flag-based
>>>>> validation instead of seq-based validation in:
>>>>>     - drm_gpusvm_pages_valid() checks
>>>>>         flags.has_dma_mapping
>>>>>       not notifier_seq. The comment explicitly states:
>>>>>         "This is akin to a notifier seqno check in the HMM documentation
>>>>>          but due to wider notifiers (i.e., notifiers which span multiple
>>>>>          ranges) this function is required for finer grained checking"
>>>>>     - __drm_gpusvm_unmap_pages() clears
>>>>>         flags.has_dma_mapping = false  under notifier_lock
>>>>>     - drm_gpusvm_get_pages() sets
>>>>>         flags.has_dma_mapping = true  under notifier_lock
>>>>> I adopted the same approach.
>>>>>
>>>>> DRM GPU SVM:
>>>>>     drm_gpusvm_notifier_invalidate()
>>>>>       down_write(&gpusvm->notifier_lock);
>>>>>       mmu_interval_set_seq(mni, cur_seq);
>>>>>       gpusvm->ops->invalidate()
>>>>>         -> xe_svm_invalidate()
>>>>>            drm_gpusvm_for_each_range()
>>>>>              -> __drm_gpusvm_unmap_pages()
>>>>>                 WRITE_ONCE(flags.has_dma_mapping = false);  // clear flag
>>>>>       up_write(&gpusvm->notifier_lock);
>>>>>
>>>>> KFD batch userptr:
>>>>>     amdgpu_amdkfd_evict_userptr_batch()
>>>>>       mutex_lock(&process_info->notifier_lock);
>>>>>       mmu_interval_set_seq(mni, cur_seq);
>>>>>       discard_invalid_ranges()
>>>>>         interval_tree_iter_first/next()
>>>>>           range_info->valid = false;          // clear flag
>>>>>       mutex_unlock(&process_info->notifier_lock);
>>>>>
>>>>> Both implementations:
>>>>>     - Acquire notifier_lock FIRST, before any flag changes
>>>>>     - Call mmu_interval_set_seq() under the lock
>>>>>     - Use interval tree to find affected ranges within the wide notifier
>>>>>     - Mark per-range flag as invalid/valid under the lock
>>>>>
>>>>> The page fault path and final validation path also follow the same
>>>>> pattern as DRM GPU SVM: fault outside the lock, set/check per-range
>>>>> flag under the lock.
>>>>>
>>>>> Regards,
>>>>> Honglei
>>>>>
>>>>>
>>>>> On 2026/2/6 21:56, Christian König wrote:
>>>>>> On 2/6/26 07:25, Honglei Huang wrote:
>>>>>>> From: Honglei Huang <honghuan@amd.com>
>>>>>>>
>>>>>>> Hi all,
>>>>>>>
>>>>>>> This is v3 of the patch series to support allocating multiple non-contiguous
>>>>>>> CPU virtual address ranges that map to a single contiguous GPU virtual address.
>>>>>>>
>>>>>>> v3:
>>>>>>> 1. No new ioctl: Reuses existing AMDKFD_IOC_ALLOC_MEMORY_OF_GPU
>>>>>>>       - Adds only one flag: KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH
>>>>>>
>>>>>> That is most likely not the best approach, but Felix or Philip need to comment here since I don't know such IOCTLs well either.
>>>>>>
>>>>>>>       - When flag is set, mmap_offset field points to range array
>>>>>>>       - Minimal API surface change
>>>>>>
>>>>>> Why range of VA space for each entry?
>>>>>>
>>>>>>> 2. Improved MMU notifier handling:
>>>>>>>       - Single mmu_interval_notifier covering the VA span [va_min, va_max]
>>>>>>>       - Interval tree for efficient lookup of affected ranges during invalidation
>>>>>>>       - Avoids per-range notifier overhead mentioned in v2 review
>>>>>>
>>>>>> That won't work unless you also modify hmm_range_fault() to take multiple VA addresses (or ranges) at the same time.
>>>>>>
>>>>>> The problem is that we must rely on hmm_range.notifier_seq to detect changes to the page tables in question, but that in turn works only if you have one hmm_range structure and not multiple.
>>>>>>
>>>>>> What might work is doing an XOR or CRC over all hmm_range.notifier_seq you have, but that is a bit flaky.
>>>>>>
>>>>>> Regards,
>>>>>> Christian.
>>>>>>
>>>>>>>
>>>>>>> 3. Better code organization: Split into 8 focused patches for easier review
>>>>>>>
>>>>>>> v2:
>>>>>>>       - Each CPU VA range gets its own mmu_interval_notifier for invalidation
>>>>>>>       - All ranges validated together and mapped to contiguous GPU VA
>>>>>>>       - Single kgd_mem object with array of user_range_info structures
>>>>>>>       - Unified eviction/restore path for all ranges in a batch
>>>>>>>
>>>>>>> Current Implementation Approach
>>>>>>> ===============================
>>>>>>>
>>>>>>> This series implements a practical solution within existing kernel constraints:
>>>>>>>
>>>>>>> 1. Single MMU notifier for VA span: Register one notifier covering the
>>>>>>>       entire range from lowest to highest address in the batch
>>>>>>>
>>>>>>> 2. Interval tree filtering: Use interval tree to efficiently identify
>>>>>>>       which specific ranges are affected during invalidation callbacks,
>>>>>>>       avoiding unnecessary processing for unrelated address changes
>>>>>>>
>>>>>>> 3. Unified eviction/restore: All ranges in a batch share eviction and
>>>>>>>       restore paths, maintaining consistency with existing userptr handling
>>>>>>>
>>>>>>> Patch Series Overview
>>>>>>> =====================
>>>>>>>
>>>>>>> Patch 1/8: Add userptr batch allocation UAPI structures
>>>>>>>        - KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH flag
>>>>>>>        - kfd_ioctl_userptr_range and kfd_ioctl_userptr_ranges_data structures
>>>>>>>
>>>>>>> Patch 2/8: Add user_range_info infrastructure to kgd_mem
>>>>>>>        - user_range_info structure for per-range tracking
>>>>>>>        - Fields for batch allocation in kgd_mem
>>>>>>>
>>>>>>> Patch 3/8: Implement interval tree for userptr ranges
>>>>>>>        - Interval tree for efficient range lookup during invalidation
>>>>>>>        - mark_invalid_ranges() function
>>>>>>>
>>>>>>> Patch 4/8: Add batch MMU notifier support
>>>>>>>        - Single notifier for entire VA span
>>>>>>>        - Invalidation callback using interval tree filtering
>>>>>>>
>>>>>>> Patch 5/8: Implement batch userptr page management
>>>>>>>        - get_user_pages_batch() and set_user_pages_batch()
>>>>>>>        - Per-range page array management
>>>>>>>
>>>>>>> Patch 6/8: Add batch allocation function and export API
>>>>>>>        - init_user_pages_batch() main initialization
>>>>>>>        - amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch() entry point
>>>>>>>
>>>>>>> Patch 7/8: Unify userptr cleanup and update paths
>>>>>>>        - Shared eviction/restore handling for batch allocations
>>>>>>>        - Integration with existing userptr validation flows
>>>>>>>
>>>>>>> Patch 8/8: Wire up batch allocation in ioctl handler
>>>>>>>        - Input validation and range array parsing
>>>>>>>        - Integration with existing alloc_memory_of_gpu path
>>>>>>>
>>>>>>> Testing
>>>>>>> =======
>>>>>>>
>>>>>>> - Multiple scattered malloc() allocations (2-4000+ ranges)
>>>>>>> - Various allocation sizes (4KB to 1G+ per range)
>>>>>>> - Memory pressure scenarios and eviction/restore cycles
>>>>>>> - OpenCL CTS and HIP catch tests in KVM guest environment
>>>>>>> - AI workloads: Stable Diffusion, ComfyUI in virtualized environments
>>>>>>> - Small LLM inference (3B-7B models)
>>>>>>> - Benchmark score: 160,000 - 190,000 (80%-95% of bare metal)
>>>>>>> - Performance improvement: 2x-2.4x faster than userspace approach
>>>>>>>
>>>>>>> Thank you for your review and feedback.
>>>>>>>
>>>>>>> Best regards,
>>>>>>> Honglei Huang
>>>>>>>
>>>>>>> Honglei Huang (8):
>>>>>>>      drm/amdkfd: Add userptr batch allocation UAPI structures
>>>>>>>      drm/amdkfd: Add user_range_info infrastructure to kgd_mem
>>>>>>>      drm/amdkfd: Implement interval tree for userptr ranges
>>>>>>>      drm/amdkfd: Add batch MMU notifier support
>>>>>>>      drm/amdkfd: Implement batch userptr page management
>>>>>>>      drm/amdkfd: Add batch allocation function and export API
>>>>>>>      drm/amdkfd: Unify userptr cleanup and update paths
>>>>>>>      drm/amdkfd: Wire up batch allocation in ioctl handler
>>>>>>>
>>>>>>>     drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  23 +
>>>>>>>     .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 539 +++++++++++++++++-
>>>>>>>     drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 128 ++++-
>>>>>>>     include/uapi/linux/kfd_ioctl.h                |  31 +-
>>>>>>>     4 files changed, 697 insertions(+), 24 deletions(-)
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
> 


